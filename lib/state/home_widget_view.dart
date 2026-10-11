import 'package:flutter/foundation.dart';

import 'word_progress.dart';

/// Welcher Bereich sich öffnet, wenn man das Widget antippt.
enum WidgetZiel {
  lernen('lernen'),
  azkar('azkar');

  const WidgetZiel(this.id);

  final String id;

  static WidgetZiel byId(String id) =>
      values.firstWhere((WidgetZiel z) => z.id == id, orElse: () => lernen);
}

/// Was auf dem Widget steht.
@immutable
class WidgetKachel {
  const WidgetKachel({
    required this.titel,
    required this.zeile,
    required this.prozent,
    required this.ziel,
  });

  /// Eine Zeile, fett — „Block 3", „Morgen-Azkar".
  final String titel;

  /// Eine Zeile, leise — „4 von 10 sitzen", „06:12 · 0 von 5".
  final String zeile;

  /// Der Balken, 0 bis 100.
  final int prozent;

  final WidgetZiel ziel;

  @override
  bool operator ==(Object other) =>
      other is WidgetKachel &&
      other.titel == titel &&
      other.zeile == zeile &&
      other.prozent == prozent &&
      other.ziel == ziel;

  @override
  int get hashCode => Object.hash(titel, zeile, prozent, ziel);

  @override
  String toString() => '$titel — $zeile ($prozent %, ${ziel.id})';
}

/// Was jetzt gilt, und was später an seine Stelle tritt.
///
/// **Warum zwei Kacheln.** Ein Widget läuft, während die App zu ist, und
/// kann nichts nachrechnen — es zeigt nur, was zuletzt hinterlegt wurde.
/// Ohne eine zweite Kachel stünde um 05:00 „Block 3" und um 06:30, wenn das
/// Fajr-Fenster längst offen ist, noch immer dasselbe. Deshalb bekommt die
/// Android-Seite beides mitgegeben und **einen** Zeitpunkt: Ab [ab] zeigt sie
/// [dann]. Das ist ein Vergleich und keine zweite Rechenlogik.
@immutable
class WidgetAnsicht {
  const WidgetAnsicht({required this.jetzt, this.ab, this.dann});

  final WidgetKachel jetzt;
  final DateTime? ab;
  final WidgetKachel? dann;

  @override
  String toString() => dann == null ? '$jetzt' : '$jetzt → ab $ab: $dann';
}

/// Ein Azkar-Fenster, soweit das Widget davon wissen muss.
@immutable
class WidgetAzkar {
  const WidgetAzkar({
    required this.label,
    required this.beginn,
    required this.ende,
    required this.faellig,
    required this.gesamt,
    required this.fertig,
  });

  /// „Morgen-Azkar" oder „Abend-Azkar".
  final String label;

  final DateTime beginn;
  final DateTime ende;

  /// Die Uhrzeit, die auf dem Widget steht.
  final DateTime faellig;

  /// Wie viele Azkar das Pensum hat und wie viele davon stehen.
  final int gesamt;
  final int fertig;

  bool get durch => gesamt > 0 && fertig >= gesamt;

  bool offenUm(DateTime moment) =>
      !durch && !moment.isBefore(beginn) && moment.isBefore(ende);
}

/// Alles, was das Widget über den Lernstand wissen muss.
@immutable
class WidgetFacts {
  const WidgetFacts({
    this.dayStreak = 0,
    this.dailyGoal = 10,
    this.answeredToday = 0,
    this.blockNumber = 1,
    this.blockLearned = 0,
    this.blockSize = 10,
    this.repetitionsDue = 0,
    this.azkar = const <WidgetAzkar>[],
  });

  final int dayStreak;
  final int dailyGoal;
  final int answeredToday;
  final int blockNumber;
  final int blockLearned;
  final int blockSize;
  final int repetitionsDue;

  /// Die Fenster des Tages, in zeitlicher Reihenfolge. Leer, solange kein
  /// Ort eingestellt ist — dann zeigt das Widget nur den Lernstand.
  final List<WidgetAzkar> azkar;

  bool get zielErreicht => answeredToday >= dailyGoal;
}

/// Was jetzt dran ist — rein, damit ein Test es ohne Gerät nachrechnen kann.
///
/// Die Reihenfolge ist eine Entscheidung und keine Laune:
///
/// 1. **Ein offenes Azkar-Fenster hat Vorrang.** Es hat eine Zeit, die
///    vergeht; das Lernen hat den ganzen Tag.
/// 2. Sonst das Lernen, solange das Tagesziel offen ist.
/// 3. Sonst das nächste Azkar-Fenster des Tages, mit seiner Uhrzeit.
/// 4. Sonst: durch für heute. Das Widget drängt dann zu nichts mehr — das
///    ist dieselbe Haltung wie beim Feed und bei der Tagesportion.
WidgetAnsicht buildWidgetAnsicht({
  required DateTime now,
  required WidgetFacts facts,
}) {
  final WidgetAzkar? offen =
      facts.azkar.where((WidgetAzkar a) => a.offenUm(now)).firstOrNull;
  if (offen != null) {
    return WidgetAnsicht(
      jetzt: _azkarKachel(offen),
      ab: offen.ende,
      dann: _nachDemFenster(facts, offen),
    );
  }

  // Das nächste Fenster, das heute noch aufgeht und nicht schon steht.
  final WidgetAzkar? naechstes = facts.azkar
      .where((WidgetAzkar a) => !a.durch && a.beginn.isAfter(now))
      .firstOrNull;

  final WidgetKachel jetzt =
      facts.zielErreicht ? _ruhe(facts, naechstes) : _lernKachel(facts);

  // Geht später ein Fenster auf, übernimmt das Widget dort von selbst.
  if (naechstes != null) {
    return WidgetAnsicht(
      jetzt: jetzt,
      ab: naechstes.beginn,
      dann: _azkarKachel(naechstes),
    );
  }
  return WidgetAnsicht(jetzt: jetzt);
}

/// Was nach einem Azkar-Fenster gilt: das nächste, sonst das Lernen.
WidgetKachel _nachDemFenster(WidgetFacts facts, WidgetAzkar vorbei) {
  final WidgetAzkar? spaeter = facts.azkar
      .where((WidgetAzkar a) =>
          !a.durch && !a.beginn.isBefore(vorbei.ende))
      .firstOrNull;
  if (spaeter != null) return _azkarKachel(spaeter);
  return facts.zielErreicht ? _ruhe(facts, null) : _lernKachel(facts);
}

WidgetKachel _azkarKachel(WidgetAzkar a) => WidgetKachel(
      titel: a.label,
      zeile: '${_uhr(a.faellig)} · ${a.fertig} von ${a.gesamt}',
      prozent: a.gesamt == 0 ? 0 : (a.fertig * 100 / a.gesamt).round(),
      ziel: WidgetZiel.azkar,
    );

WidgetKachel _lernKachel(WidgetFacts facts) {
  // Fällige Wiederholungen zuerst: Sie sind das, was sonst verfällt.
  final String zeile = facts.repetitionsDue > 0
      ? '${facts.repetitionsDue} ${facts.repetitionsDue == 1 ? "Wiederholung" : "Wiederholungen"} fällig'
      : '${facts.blockLearned} von ${facts.blockSize} sitzen';
  return WidgetKachel(
    titel: 'Block ${facts.blockNumber}',
    zeile: zeile,
    prozent: facts.dailyGoal == 0
        ? 0
        : (facts.answeredToday * 100 / facts.dailyGoal).clamp(0, 100).round(),
    ziel: WidgetZiel.lernen,
  );
}

/// Alles erledigt. Keine Zahl, die noch etwas fordert.
WidgetKachel _ruhe(WidgetFacts facts, WidgetAzkar? naechstes) => WidgetKachel(
      titel: 'Durch für heute',
      zeile: facts.dayStreak > 0
          ? '${facts.dayStreak} ${facts.dayStreak == 1 ? "Tag" : "Tage"} am Stück'
          : 'Morgen geht es weiter',
      prozent: 100,
      ziel: WidgetZiel.lernen,
    );

String _uhr(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Die Werte, die an die Android-Seite gehen.
///
/// Flache Zeichenketten und Zahlen, nichts Verschachteltes: Das Widget liest
/// sie ohne JSON-Zerlegung, und was es anzeigt, steht hier schon fertig da.
Map<String, Object> widgetDaten(WidgetAnsicht ansicht) => <String, Object>{
      'w_titel': ansicht.jetzt.titel,
      'w_zeile': ansicht.jetzt.zeile,
      'w_prozent': ansicht.jetzt.prozent,
      'w_ziel': ansicht.jetzt.ziel.id,
      // **Als Zeichenkette, nicht als Zahl.** Eine Dart-Zahl kommt auf der
      // Android-Seite als `Int` an, solange sie in 32 Bit passt, und sonst
      // als `Long` — das Plugin legt sie entsprechend mit `putInt` oder
      // `putLong` ab. Ein Zeitstempel ist immer groß (Long), die 0 für „kein
      // Umschalten" aber klein (Int), und `getLong` auf einem mit `putInt`
      // geschriebenen Wert wirft eine ClassCastException. Eine Zeichenkette
      // hat dieses Problem nicht.
      'w_ab': '${ansicht.ab?.millisecondsSinceEpoch ?? 0}',
      'w_titel2': ansicht.dann?.titel ?? '',
      'w_zeile2': ansicht.dann?.zeile ?? '',
      'w_prozent2': ansicht.dann?.prozent ?? 0,
      'w_ziel2': (ansicht.dann?.ziel ?? WidgetZiel.lernen).id,
      // Nur zum Nachsehen, wenn etwas altbacken aussieht.
      'w_stand': dayKey(DateTime.now()),
    };
