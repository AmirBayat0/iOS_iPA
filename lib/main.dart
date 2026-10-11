import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/content_registry.dart';
import 'data/azkar_data.dart';
import 'data/knowledge/knowledge_data.dart';
import 'screens/app_shell.dart';
import 'theme/app_theme.dart';
import 'state/custom_cards.dart';
import 'state/daily_feed.dart';
import 'state/learning_state.dart';
import 'models/daily_item.dart';
import 'state/daily_card_store.dart';
import 'state/daily_harvest.dart';
import 'state/daily_quests.dart';
import 'state/duel_store.dart';
import 'state/lesson_store.dart';
import 'state/reward_store.dart';
import 'models/azkar.dart';
import 'state/azkar_store.dart';
import 'state/home_widget_bridge.dart';
import 'state/home_widget_view.dart';
import 'state/prayer_times.dart';
import 'state/sharing.dart';
import 'state/update_check.dart';
import 'state/reminder_texts.dart';
import 'state/reminders.dart';
import 'state/speech.dart';
import 'widgets/speak_button.dart';

void main() {
  runApp(const TaeglichKluegerApp());
}

/// „Täglich Klüger" — Arabisch und Allgemeinwissen in einer App.
///
/// Der Paketname `de.susasek.arabischlernen` und der Dart-Paketname
/// bleiben, wie sie sind: Sie sind kein Anzeigename, sondern die
/// Identität der Installation. Ein anderer Paketname hieße für jedes
/// Gerät: neue App, kein Lernstand.
class TaeglichKluegerApp extends StatefulWidget {
  const TaeglichKluegerApp({super.key});

  @override
  State<TaeglichKluegerApp> createState() => _TaeglichKluegerAppState();
}

class _TaeglichKluegerAppState extends State<TaeglichKluegerApp>
    with WidgetsBindingObserver {
  final CustomCardStore _cards = CustomCardStore();
  late final LearningState _state = LearningState(
    content: ContentWithCustomCards(kDefaultContent, _cards, _dailyCards),
  );
  final Speaker _speaker = Speaker();
  final ReminderService _reminders = ReminderService();
  final DailyFeedService _feed = DailyFeedService();
  final DailyCardStore _dailyCards = DailyCardStore();
  final LessonStore _lessons = LessonStore();
  final RewardStore _rewards = RewardStore();
  final DuelStore _duels = DuelStore();
  final Sharer _sharer = Sharer();
  final UpdateService _updates = UpdateService();
  final AzkarSettings _azkarSettings = AzkarSettings();
  final AzkarStore _azkar = AzkarStore();
  final HomeWidgetBridge _widget = HomeWidgetBridge();

  @override
  void initState() {
    super.initState();
    // Eine gemerkte Karte ändert den Vorrat — die Startseite muss das sehen,
    // ohne dass die App neu gestartet wird.
    _cards.addListener(_state.contentChanged);
    _cards.load();
    // Reads the saved boxes, streak and statistics from the device …
    _state.load();
    // … and asks the system whether it can speak Arabic at all.
    _speaker.init();
    // Der Tagesinhalt wird aus dem Speicher gelesen; geholt wird er im
    // Gerüst, einmal am Tag (siehe AppShell).
    _feed.load();
    // Ein neuer Tagesstoff heißt: zwei neue Karten im Bestand.
    _feed.addListener(_ernten);
    _dailyCards.addListener(_state.contentChanged);
    _dailyCards.load();
    // Die Abzeichen fürs Wissen zählen Lektionen; der Lernkern erfährt den
    // Stand, statt den Speicher zu kennen.
    _lessons.addListener(_meldeLektionen);
    _lessons.load().then((_) => _meldeLektionen());
    // Jede Antwort läuft durch den Lernkern; von dort aus zählen die
    // Tagesaufgaben mit, ohne dass acht Übungsbildschirme davon wissen.
    _state.attachQuests(
        (QuestKind kind, int amount) => _rewards.report(kind, amount: amount));
    _rewards.load();
    _duels.load();
    // Die Azkar sind eine eigene Spur: eigener Speicher, eigene Serie, kein
    // Einfluss auf den Lernstand. Sie melden sich trotzdem beim
    // Erinnerungsplan, damit ein gesprochenes Pensum nicht noch einmal
    // angemahnt wird.
    _azkar.addListener(_planeErinnerungen);
    _azkarSettings.addListener(_planeErinnerungen);
    _azkarSettings.load();
    _azkar.load().then((_) => _schreibeWidget());
    unawaited(_pruefeVersion());
    // Der Erinnerungsplan wird beim Start **und** beim Zuklappen neu
    // geschrieben — siehe didChangeAppLifecycleState.
    WidgetsBinding.instance.addObserver(this);
    _setUpReminders();
  }

  /// Beim Zuklappen den Plan auffrischen.
  ///
  /// **Warum das nötig ist.** Benachrichtigungen werden im Voraus geplant, ob
  /// man gelernt hat, weiß nur die laufende App. Ohne diesen Haken käme der
  /// Mittags- und Abendanstoß auch dann noch, wenn man morgens längst fertig
  /// war — und drei Erinnerungen am Tag sind genau so lange in Ordnung, wie
  /// keine davon überflüssig ist.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.paused) return;
    unawaited(_setUpReminders());
    // Das Widget wird beim Zuklappen geschrieben, nicht bei jeder Antwort:
    // Niemand liest es, während die App offen ist.
    unawaited(_schreibeWidget());
  }

  /// Bei jedem Start den Erinnerungsplan auffrischen: Ein Tag, an dem das
  /// Ziel schon erreicht ist, bekommt keine Erinnerung mehr.
  Future<void> _setUpReminders() async {
    await _reminders.load();
    if (!_state.isLoaded) await _state.load();
    await _reminders.refresh(
      goalReachedToday: _state.goalReached,
      facts: _facts(),
      azkarZeit: _azkarZeit,
      azkarErledigt: _azkarErledigt(),
    );
  }

  void _planeErinnerungen() {
    unawaited(_setUpReminders());
    unawaited(_schreibeWidget());
  }

  /// Den Stand ins kleine Widget legen.
  Future<void> _schreibeWidget() async {
    if (!_state.isLoaded) return;
    final DateTime jetzt = DateTime.now();
    await _widget.push(buildWidgetAnsicht(
      now: jetzt,
      facts: WidgetFacts(
        dayStreak: _state.dayStreak,
        dailyGoal: _state.dailyGoal,
        answeredToday: _state.answeredToday,
        blockNumber: _state.blockNumber,
        blockLearned: _state.blockLearned,
        blockSize: _state.blockSize,
        repetitionsDue: _state.repetitionsDueTotal,
        azkar: _azkarFenster(jetzt),
      ),
    ));
  }

  /// Die beiden Azkar-Fenster des Tages, soweit das Widget sie braucht.
  /// Leer ohne eingestellten Ort — dann zeigt es nur den Lernstand.
  List<WidgetAzkar> _azkarFenster(DateTime jetzt) => <WidgetAzkar>[
        for (final AzkarTime t in AzkarTime.values)
          if (_azkarSettings.fenster(t, jetzt) case final AzkarFenster f)
            WidgetAzkar(
              label: t.label,
              beginn: f.beginn,
              ende: f.ende,
              faellig: f.faellig,
              gesamt: azkarFor(time: t, level: _azkarSettings.level).length,
              fertig: _azkar.fertigeVon(
                  t, azkarFor(time: t, level: _azkarSettings.level)),
            ),
      ];

  /// Wann die Azkar an einem bestimmten Tag fällig sind.
  ///
  /// `null` ohne eingestellten Ort — dann entfällt die Erinnerung, statt zu
  /// einer geratenen Stunde zu kommen.
  DateTime? _azkarZeit(ReminderSlot slot, DateTime tag) {
    final AzkarTime welche = slot == ReminderSlot.azkarMorgens
        ? AzkarTime.morgens
        : AzkarTime.abends;
    return _azkarSettings.fenster(welche, tag)?.faellig;
  }

  /// Was heute schon gesprochen ist, meldet sich nicht mehr.
  Set<ReminderSlot> _azkarErledigt() => <ReminderSlot>{
        for (final (AzkarTime t, ReminderSlot s) in <(AzkarTime, ReminderSlot)>[
          (AzkarTime.morgens, ReminderSlot.azkarMorgens),
          (AzkarTime.abends, ReminderSlot.azkarAbends),
        ])
          if (_azkar.heuteSchonFertig(t)) s,
      };

  /// Einmal am Tag nachsehen, ob es eine neuere Version gibt.
  ///
  /// Still: Geht es nicht — offline, Repository nicht öffentlich, GitHub
  /// gerade nicht da —, passiert nichts Sichtbares. Eine Fehlermeldung über
  /// ein Update, das man nicht wollte, ist nur Lärm.
  Future<void> _pruefeVersion() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      await _updates.check(laufendeVersion: info.version);
    } catch (error) {
      debugPrint('Versionsabfrage übersprungen: $error');
    }
  }

  /// Was die Erinnerung über den Lernstand wissen darf.
  ///
  /// Über beide Fächer: Sie soll an das ganze Pensum erinnern, nicht nur an
  /// das gerade gewählte. Und über `repetitionsDueTotal` statt `dueCountTotal`
  /// — sonst stünde dort die Zahl, die auch nie angesehene Wörter für fällig
  /// hält, also fast der ganze Bestand.
  ReminderFacts _facts() => ReminderFacts(
        streak: _state.dayStreak,
        freezes: _state.freezes,
        blockNumber: _state.blockNumber,
        blockOpen: _state.blockSize - _state.blockLearned,
        repetitionsDue: _state.repetitionsDueTotal,
        goalRemaining:
            max(0, _state.dailyGoal - _state.answeredToday),
        azkarStreakMorgens: _azkar.serie(AzkarTime.morgens),
        azkarStreakAbends: _azkar.serie(AzkarTime.abends),
        woerter: _state.workingSet.take(20).toList(),
      );

  /// Holt aus dem frischen Tagesstoff die Karten des Tages.
  ///
  /// Hier und nicht in einem Bildschirm: Der Fund soll ankommen, egal wo man
  /// gerade ist — und nur **einmal**, nicht bei jedem Neuzeichnen. Fallen
  /// dabei alte Karten aus dem Bestand, vergisst der Lernkern ihre Stufen
  /// mit; sonst wüchse er still weiter.
  Future<void> _ernten() async {
    final DailyFeed? heute = _feed.feed;
    if (heute == null || !_dailyCards.enabled) return;
    final List<String> weg = await _dailyCards.addAll(harvestDaily(heute));
    if (weg.isNotEmpty) await _state.forget(weg);
  }

  void _meldeLektionen() => _state.reportLessons(
        done: _lessons.doneCount,
        topicsUnderstood: _lessons.understoodIn(kKnowledgeCategories),
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lessons.removeListener(_meldeLektionen);
    _feed.removeListener(_ernten);
    _dailyCards.removeListener(_state.contentChanged);
    _dailyCards.dispose();
    _rewards.dispose();
    _duels.dispose();
    _cards.removeListener(_state.contentChanged);
    _cards.dispose();
    _feed.dispose();
    _lessons.dispose();
    _state.dispose();
    _speaker.dispose();
    _reminders.dispose();
    _updates.dispose();
    _azkar.removeListener(_planeErinnerungen);
    _azkarSettings.removeListener(_planeErinnerungen);
    _azkar.dispose();
    _azkarSettings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LearningScope(
      state: _state,
      child: CustomCardScope(
        store: _cards,
        child: LessonScope(
          store: _lessons,
          child: RewardScope(
          store: _rewards,
          child: DailyCardScope(
          store: _dailyCards,
          child: DuelScope(
          store: _duels,
          child: ShareScope(
          sharer: _sharer,
          child: DailyFeedScope(
          service: _feed,
          child: SpeechScope(
            speaker: _speaker,
            child: ReminderScope(
              service: _reminders,
              child: UpdateScope(
              service: _updates,
              child: AzkarSettingsScope(
              settings: _azkarSettings,
              child: AzkarScope(
              store: _azkar,
              child: MaterialApp(
                title: 'Täglich Klüger',
                debugShowCheckedModeBanner: false,
                theme: buildAppTheme(Brightness.light),
                darkTheme: buildAppTheme(Brightness.dark),
                home: const AppShell(),
              ),
              ),
              ),
              ),
            ),
          ),
        ),
        ),
        ),
        ),
        ),
        ),
      ),
    );
  }
}
