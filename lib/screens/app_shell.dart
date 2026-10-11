import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../models/subject.dart';
import '../state/daily_card_store.dart';
import '../state/daily_feed.dart';
import '../state/home_widget_bridge.dart';
import '../state/home_widget_view.dart';
import '../state/learning_state.dart';
import '../widgets/reward_sheet.dart';
import 'achievements_screen.dart';
import 'azkar_screen.dart';
import 'home_screen.dart';
import 'knowledge_home.dart';
import 'practice_screen.dart';

/// Das Gerüst der App: unten drei Bereiche, dazwischen wird nur der Inhalt
/// getauscht.
///
/// Vorher lag alles auf der Startseite übereinander — Tagesziel, Level, sieben
/// Übungskacheln und der Lernweg. Das war mit wachsendem Umfang nicht mehr zu
/// überblicken. Jetzt hat jeder Teil seinen Platz: „Lernen" für die tägliche
/// Runde, „Üben" für die Übungen und das Nachschlagen, „Erfolge" für den
/// Fortschritt.
///
/// **„Lernen" sieht je Fach anders aus.** In Arabisch ist das Maß das
/// gelernte Wort und der Weg die Wiederholung; im Wissen ist das Maß das
/// verstandene Thema und der Weg die Lektion. Zwei Fächer, zwei Startseiten —
/// eine gemeinsame hätte beiden nicht gepasst. Der Tagesstoff aus dem Netz
/// steht seit dieser Trennung im Fach Wissen, wo er inhaltlich hingehört.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  bool _gefragt = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_gefragt) return;
    _gefragt = true;
    // Der Tagesstoff wird hier geholt und nicht mehr nur im Bereich „Heute":
    // Wer nur Arabisch lernt, bekäme sonst nie einen Fund. Einmal am Tag,
    // aus dem Zwischenspeicher beantwortet — und nur, wenn der Schalter an
    // ist, damit ein Abgeschalteter keinen Abruf auslöst.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!DailyCardScope.of(context).enabled) return;
      DailyFeedScope.of(context).ensureFresh();
    });
    unawaited(_vomWidget());
    // Tippt man das Widget an, während die App im Hintergrund liegt, ist das
    // kein neuer Start — dann kommt die Adresse über diesen Strom.
    _vomWidgetSpaeter = HomeWidget.widgetClicked.listen(_zeigeZiel);
  }

  StreamSubscription<Uri?>? _vomWidgetSpaeter;

  @override
  void dispose() {
    _vomWidgetSpaeter?.cancel();
    super.dispose();
  }

  void _zeigeZiel(Uri? adresse) {
    final WidgetZiel? ziel = zielAusAdresse(adresse);
    if (ziel == null || !mounted) return;
    setState(() =>
        _index = ziel == WidgetZiel.azkar ? AppTabs.azkar : AppTabs.lernen);
  }

  /// Kam der Start von einem Tipp auf das Widget, den passenden Bereich
  /// öffnen.
  ///
  /// Das Widget zeigt genau eine Sache; wer darauf tippt, will **die** sehen
  /// und nicht von der Startseite aus weitersuchen.
  Future<void> _vomWidget() async {
    try {
      _zeigeZiel(await HomeWidget.initiallyLaunchedFromHomeWidget());
    } catch (error) {
      // Auf einer Plattform ohne Widgets oder bei einem gewöhnlichen Start
      // ist hier nichts zu holen — das ist kein Fehler.
      debugPrint('Widget-Start nicht auswertbar: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LearningState state = LearningScope.of(context);
    final int due = state.repetitionsDueIn(state.subject);

    return AppTabs(
      goTo: (int index) => setState(() => _index = index),
      // Der Wächter sitzt über dem Gerüst, damit sein Blatt über allem
      // liegt — und einmal, statt in jeder einzelnen Übung.
      child: RewardWatcher(
      child: Scaffold(
      // IndexedStack statt Neuaufbau: Wer in einem Bereich gescrollt hat,
      // findet die Stelle beim Zurückwechseln wieder.
      body: IndexedStack(
        index: _index,
        children: <Widget>[
          if (state.subject == Subject.wissen)
            const KnowledgeHome()
          else
            const HomeScreen(),
          const PracticeScreen(),
          const AzkarScreen(),
          const AchievementsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int index) => setState(() => _index = index),
        destinations: <Widget>[
          NavigationDestination(
            icon: Badge(
              // Anstehende Wiederholungen — nicht alles, was je fällig war.
              // Auf einer frischen Installation gilt jedes Wort als fällig;
              // die Zahl stünde dann für immer auf 801 und sagte nichts.
              isLabelVisible: due > 0,
              label: Text('$due'),
              child: const Icon(Icons.school_outlined),
            ),
            selectedIcon: const Icon(Icons.school),
            label: 'Lernen',
          ),
          const NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Üben',
          ),
          const NavigationDestination(
            icon: Icon(Icons.brightness_4_outlined),
            selectedIcon: Icon(Icons.brightness_4),
            label: 'Azkar',
          ),
          const NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Erfolge',
          ),
        ],
      ),
      ),
      ),
    );
  }
}

/// Lässt einen Bildschirm den Bereich wechseln, ohne das Gerüst zu kennen.
///
/// Gebraucht für die Serienanzeige in der Kopfzeile: Sie führt zu
/// „Erfolge", und das ist ein **Bereich**, keine Seite, die man aufschlägt.
/// Ohne diesen Weg bliebe nur, denselben Bildschirm ein zweites Mal als
/// Route zu öffnen — mit zwei Rücksprüngen und ohne unten markierten
/// Bereich.
class AppTabs extends InheritedWidget {
  const AppTabs({super.key, required this.goTo, required super.child});

  /// Der Bereich „Lernen" — die Startseite des gewählten Fachs.
  static const int lernen = 0;

  /// Der Bereich „Azkar" — Morgen- und Abendgedenken.
  static const int azkar = 2;

  /// Der Bereich „Erfolge" — dort stehen Level, Serie und Abzeichen.
  ///
  /// Die Zahl ist die Stelle in der Leiste. Rückt ein Bereich dazwischen,
  /// rückt sie mit — deshalb steht sie hier und nicht verstreut im Code.
  static const int erfolge = 3;

  final void Function(int index) goTo;

  static void open(BuildContext context, int index) => context
      .getInheritedWidgetOfExactType<AppTabs>()
      ?.goTo(index);

  @override
  bool updateShouldNotify(AppTabs oldWidget) => false;
}
