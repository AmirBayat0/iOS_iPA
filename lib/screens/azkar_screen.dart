import 'package:flutter/material.dart';

import '../data/azkar_data.dart';
import '../models/azkar.dart';
import '../state/azkar_store.dart';
import '../state/prayer_times.dart';
import '../theme/app_theme.dart';
import '../widgets/arabic_text.dart';
import '../widgets/azkar_settings.dart';
import '../widgets/speak_button.dart';

/// Morgen- und Abend-Azkar.
///
/// **Bewusst keine Strecke, die zieht.** Kein Wischfeed, kein Fortschritt,
/// der zum Weitermachen drängt, keine Punkte: eine Liste, die man durchgeht,
/// und dann ist sie durch. Die Lernspur der App berührt das an keiner Stelle.
class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  AzkarTime? _gewaehlt;

  @override
  Widget build(BuildContext context) {
    final AzkarSettings settings = AzkarSettingsScope.of(context);
    final AzkarStore store = AzkarScope.of(context);
    final DateTime jetzt = DateTime.now();

    // Was gerade dran ist, steht vorn. Außerhalb beider Fenster die Hälfte,
    // die als Nächstes kommt — mit ihrer Zeit, damit man weiß, worauf man
    // wartet.
    final AzkarTime aktiv =
        _gewaehlt ?? settings.jetztDran(jetzt) ?? _naechste(settings, jetzt);

    final List<Dhikr> pensum =
        azkarFor(time: aktiv, level: settings.level);
    final List<Dhikr> darueber =
        azkarDarueberHinaus(time: aktiv, level: settings.level);
    final AzkarFenster? fenster = settings.fenster(aktiv, jetzt);

    // Was gesprochen ist, verlässt die Liste.
    //
    // **Warum.** Ein abgehaktes Dhikr blieb vorher an seiner Stelle stehen,
    // nur blasser — und arabische Texte sind lang. Auf der vollständigen
    // Stufe scrollte man am Ende an zwanzig erledigten Karten vorbei, um die
    // letzte offene zu finden. Gelöscht wird trotzdem nichts: Das
    // Gesprochene sammelt sich unten in einem Abschnitt, den man aufklappen
    // kann — zum Nachlesen und zum Zurücknehmen.
    bool gesprochen(Dhikr d) => store.istFertig(aktiv, d);
    final List<Dhikr> offen =
        pensum.where((Dhikr d) => !gesprochen(d)).toList();
    final List<Dhikr> offenDarueber =
        darueber.where((Dhikr d) => !gesprochen(d)).toList();
    final List<Dhikr> erledigt = <Dhikr>[
      for (final Dhikr d in <Dhikr>[...pensum, ...darueber])
        if (gesprochen(d)) d,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Azkar'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            tooltip: 'Einstellungen',
            icon: const Icon(Icons.tune),
            onPressed: () => AzkarSettingsSheet.open(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          SegmentedButton<AzkarTime>(
            segments: <ButtonSegment<AzkarTime>>[
              for (final AzkarTime t in AzkarTime.values)
                ButtonSegment<AzkarTime>(value: t, label: Text(t.label)),
            ],
            selected: <AzkarTime>{aktiv},
            onSelectionChanged: (Set<AzkarTime> auswahl) =>
                setState(() => _gewaehlt = auswahl.first),
          ),
          const SizedBox(height: Insets.md),
          _Kopf(zeit: aktiv, fenster: fenster, pensum: pensum, store: store),
          const SizedBox(height: Insets.md),
          if (!settings.eingerichtet) const _KeinOrt(),
          for (final Dhikr d in offen)
            _DhikrKarte(dhikr: d, zeit: aktiv, pensum: pensum),
          if (offen.isEmpty && erledigt.isNotEmpty)
            const _AllesGesprochen(),
          if (erledigt.isNotEmpty)
            _Gesprochen(eintraege: erledigt, zeit: aktiv),
          if (offenDarueber.isNotEmpty) ...<Widget>[
            const SizedBox(height: Insets.lg),
            Text(
              'Mehr, wenn du magst',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Nicht Teil deiner Stufe — und trotzdem hier, falls heute mehr '
              'geht.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: Insets.sm),
            for (final Dhikr d in offenDarueber)
              _DhikrKarte(dhikr: d, zeit: aktiv, pensum: pensum, extra: true),
          ],
          const SizedBox(height: Insets.lg),
          const _Quellenhinweis(),
        ],
      ),
    );
  }

  /// Nach dem Abendfenster beginnt der nächste Morgen.
  AzkarTime _naechste(AzkarSettings settings, DateTime jetzt) {
    final AzkarFenster? abend = settings.fenster(AzkarTime.abends, jetzt);
    if (abend == null) return AzkarTime.morgens;
    return jetzt.isBefore(abend.beginn) ? AzkarTime.morgens : AzkarTime.abends;
  }
}

/// Überschrift mit Zeit, Stand und Serie.
class _Kopf extends StatelessWidget {
  const _Kopf({
    required this.zeit,
    required this.fenster,
    required this.pensum,
    required this.store,
  });

  final AzkarTime zeit;
  final AzkarFenster? fenster;
  final List<Dhikr> pensum;
  final AzkarStore store;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int fertig = store.fertigeVon(zeit, pensum);
    final bool durch = store.istHaelfteFertig(zeit, pensum);
    final int serie = store.serie(zeit);

    return Card(
      color: durch
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(durch ? Icons.check_circle : Icons.schedule,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    _zeile(),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (serie > 0)
                  Text('$serie ${serie == 1 ? "Tag" : "Tage"}',
                      style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: Insets.sm),
            LinearProgressIndicator(
              value: pensum.isEmpty ? 0 : fertig / pensum.length,
              minHeight: 6,
            ),
            const SizedBox(height: 6),
            Text(
              durch
                  ? 'Durch für heute.'
                  : '$fertig von ${pensum.length} gesprochen',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _zeile() {
    final AzkarFenster? f = fenster;
    if (f == null) return zeit.label;
    final String nach = zeit == AzkarTime.morgens ? 'nach Fajr' : 'nach ʿAsr';
    return '${zeit.label} · $nach, ${_uhr(f.faellig)}';
  }

  static String _uhr(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// Die gesprochenen Azkar des Tages, zusammengeklappt.
///
/// **Ein Abschnitt und kein Löschen.** „Weg" wäre zu viel: Man will
/// nachsehen können, was man schon gesprochen hat, und sich vertippen darf
/// man auch. Zugeklappt steht hier nur eine Zeile; aufgeklappt eine kurze
/// Liste, in der ein Tipp das Dhikr wieder öffnet.
///
/// Vorher war das Zurücknehmen ein langes Drücken auf der Karte — ein Weg,
/// den niemand findet, der ihn nicht kennt.
class _Gesprochen extends StatelessWidget {
  const _Gesprochen({required this.eintraege, required this.zeit});

  final List<Dhikr> eintraege;
  final AzkarTime zeit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AzkarStore store = AzkarScope.of(context);

    return Card(
      margin: const EdgeInsets.only(top: Insets.sm),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Theme(
        // Ohne das zieht ExpansionTile eine Linie über und unter sich, und
        // in einer Karte sieht das aus wie ein Fehler.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.check_circle, color: theme.colorScheme.primary),
          title: Text(
            'Gesprochen · ${eintraege.length}',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Zum Nachsehen oder Zurücknehmen aufklappen',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          childrenPadding: const EdgeInsets.only(bottom: Insets.sm),
          children: <Widget>[
            for (final Dhikr d in eintraege)
              ListTile(
                dense: true,
                leading: Icon(Icons.check,
                    size: 18, color: theme.colorScheme.primary),
                title: Text(
                  _kurz(d),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  d.count == 1 ? d.source : '${d.count}× · ${d.source}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.hintColor),
                ),
                trailing: TextButton(
                  onPressed: () => store.zuruecksetzen(zeit, d),
                  child: const Text('Zurück'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Der Anfang der Lautschrift — genug, um ein Dhikr wiederzuerkennen,
  /// ohne die ganze Karte noch einmal aufzubauen.
  static String _kurz(Dhikr d) {
    final List<String> woerter = d.transliteration.split(RegExp(r'\s+'));
    final String anfang = woerter.take(5).join(' ');
    return woerter.length > 5 ? '$anfang …' : anfang;
  }
}

/// Alles gesprochen — und nichts mehr, was drängt.
class _AllesGesprochen extends StatelessWidget {
  const _AllesGesprochen();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      child: Column(
        children: <Widget>[
          Icon(Icons.done_all, size: 36, color: theme.colorScheme.primary),
          const SizedBox(height: Insets.sm),
          Text('Durch für diese Zeit',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Eine Karte je Dhikr. Antippen zählt hoch.
class _DhikrKarte extends StatelessWidget {
  const _DhikrKarte({
    required this.dhikr,
    required this.zeit,
    required this.pensum,
    this.extra = false,
  });

  final Dhikr dhikr;
  final AzkarTime zeit;
  final List<Dhikr> pensum;

  /// Über der eigenen Stufe — leiser dargestellt.
  final bool extra;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AzkarStore store = AzkarScope.of(context);
    final int stand = store.zaehler(zeit, dhikr);
    final bool fertig = store.istFertig(zeit, dhikr);

    return Card(
      margin: const EdgeInsets.only(bottom: Insets.md),
      child: InkWell(
        onTap: fertig ? null : () => store.tippe(zeit, dhikr, pensum),
        // Für ein halb gezähltes Dhikr („2 von 3") der Weg zurück. Was ganz
        // gesprochen ist, steht nicht mehr hier, sondern im Abschnitt
        // „Gesprochen" — dort gibt es dafür einen sichtbaren Knopf.
        onLongPress:
            stand == 0 ? null : () => store.zuruecksetzen(zeit, dhikr),
        child: Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ArabicText(
                        dhikr.arabic,
                        fontSize: 22,
                        color: extra
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.primary,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SpeakButton(text: dhikr.arabic, size: 20),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                Text(
                  dhikr.transliteration,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 6),
                Text(dhikr.german, style: theme.textTheme.bodyMedium),
                if (dhikr.note case final String note) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(note,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor)),
                ],
                const SizedBox(height: Insets.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dhikr.source,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                    _Zaehler(stand: stand, ziel: dhikr.count, fertig: fertig),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}

/// Der Knopf zum Abhaken — und zugleich der Stand.
///
/// **Warum er wie ein Knopf aussieht.** Vorher stand bei einem einmaligen
/// Dhikr nur das Wort „einmal" da; dass die Karte sich antippen lässt,
/// musste man raten. Jetzt steht dort „Abhaken" mit einem leeren Kreis, und
/// bei mehrfachen „3 / 7" mit einem Pluszeichen.
class _Zaehler extends StatelessWidget {
  const _Zaehler({
    required this.stand,
    required this.ziel,
    required this.fertig,
  });

  final int stand;
  final int ziel;
  final bool fertig;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fertig
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: Radii.chipShape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            fertig
                ? Icons.check_circle
                : (ziel == 1 ? Icons.circle_outlined : Icons.add),
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            fertig ? 'gesprochen' : (ziel == 1 ? 'Abhaken' : '$stand / $ziel'),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ohne Ort gibt es keine Zeiten — und das muss dastehen, nicht raten lassen.
class _KeinOrt extends StatelessWidget {
  const _KeinOrt();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Noch kein Ort eingestellt',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            Text(
              'Ohne Ort lassen sich Fajr und ʿAsr nicht berechnen — die Azkar '
              'kannst du trotzdem sprechen, aber es gibt keine Erinnerung und '
              'keine Zeitangabe.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onErrorContainer),
            ),
            const SizedBox(height: Insets.sm),
            FilledButton(
              onPressed: () => AzkarSettingsSheet.open(context),
              child: const Text('Ort einstellen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Woher die Texte kommen — und die Bitte, sie prüfen zu lassen.
class _Quellenhinweis extends StatelessWidget {
  const _Quellenhinweis();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      'Der quranische Text stammt aus der Tanzil-Ausgabe „quran-simple", die '
      'übrigen Azkar aus dem Bestand von „Ḥiṣn al-Muslim"; die Quelle steht '
      'an jedem Eintrag. Die deutschen Zeilen sind eine Verständnishilfe und '
      'keine anerkannte Übersetzung. Die arabischen Texte sind von Hand '
      'gesetzt — lass sie prüfen, bevor du dich darauf verlässt.',
      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
    );
  }
}
