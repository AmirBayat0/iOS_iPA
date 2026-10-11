import 'package:flutter_test/flutter_test.dart';

import 'package:ipa_testing_github_action/state/home_widget_bridge.dart';
import 'package:ipa_testing_github_action/state/home_widget_view.dart';

/// Ein Widget-Ziel ohne Startbildschirm: merkt sich, was hinterlegt worden
/// wäre, und zählt die Neuzeichnungen.
class FakeHomeWidgetBackend implements HomeWidgetBackend {
  final Map<String, Object> gespeichert = <String, Object>{};
  int zeichnungen = 0;

  @override
  Future<void> save(String key, Object value) async =>
      gespeichert[key] = value;

  @override
  Future<void> update() async => zeichnungen++;
}

void main() {
  /// Ein Fenster, das zu einer Uhrzeit offen steht.
  WidgetAzkar azkar(
    String label,
    DateTime tag,
    int vonStunde,
    int bisStunde, {
    int gesamt = 5,
    int fertig = 0,
  }) =>
      WidgetAzkar(
        label: label,
        beginn: DateTime(tag.year, tag.month, tag.day, vonStunde),
        ende: DateTime(tag.year, tag.month, tag.day, bisStunde),
        faellig: DateTime(tag.year, tag.month, tag.day, vonStunde, 20),
        gesamt: gesamt,
        fertig: fertig,
      );

  final DateTime tag = DateTime(2026, 10, 11);

  List<WidgetAzkar> beide({
    int morgensFertig = 0,
    int abendsFertig = 0,
  }) =>
      <WidgetAzkar>[
        azkar('Morgen-Azkar', tag, 6, 8, fertig: morgensFertig),
        azkar('Abend-Azkar', tag, 16, 18, fertig: abendsFertig),
      ];

  group('Ein offenes Azkar-Fenster hat Vorrang', () {
    test('mitten im Morgenfenster stehen die Azkar da', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(azkar: beide(), blockNumber: 3, blockLearned: 4),
      );
      expect(a.jetzt.titel, 'Morgen-Azkar');
      expect(a.jetzt.zeile, '06:20 · 0 von 5');
      expect(a.jetzt.ziel, WidgetZiel.azkar);
    });

    test('auch wenn das Tagesziel noch offen ist', () {
      // Das Fenster hat eine Zeit, die vergeht; das Lernen hat den ganzen Tag.
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(azkar: beide(), dailyGoal: 10, answeredToday: 0),
      );
      expect(a.jetzt.ziel, WidgetZiel.azkar);
    });

    test('ein gesprochenes Pensum tritt zurück', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(
          azkar: beide(morgensFertig: 5),
          blockNumber: 3,
          blockLearned: 4,
          blockSize: 10,
        ),
      );
      expect(a.jetzt.titel, 'Block 3');
      expect(a.jetzt.ziel, WidgetZiel.lernen);
    });

    test('der Fortschritt zählt die gesprochenen Azkar', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(azkar: beide(morgensFertig: 2)),
      );
      expect(a.jetzt.zeile, contains('2 von 5'));
      expect(a.jetzt.prozent, 40);
    });
  });

  group('Sonst der Lernstand', () {
    test('vor dem ersten Fenster steht der Block', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: WidgetFacts(
          azkar: beide(),
          blockNumber: 3,
          blockLearned: 4,
          blockSize: 10,
          answeredToday: 3,
          dailyGoal: 10,
        ),
      );
      expect(a.jetzt.titel, 'Block 3');
      expect(a.jetzt.zeile, '4 von 10 sitzen');
      expect(a.jetzt.prozent, 30, reason: 'der Balken zeigt das Tagesziel');
    });

    test('fällige Wiederholungen gehen vor dem Block', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: const WidgetFacts(repetitionsDue: 7, blockNumber: 3),
      );
      expect(a.jetzt.zeile, '7 Wiederholungen fällig');
    });

    test('eine einzige Wiederholung heißt nicht „Wiederholungen"', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: const WidgetFacts(repetitionsDue: 1),
      );
      expect(a.jetzt.zeile, '1 Wiederholung fällig');
    });

    test('ohne eingestellten Ort gibt es nur den Lernstand', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: const WidgetFacts(blockNumber: 2, blockLearned: 1),
      );
      expect(a.jetzt.ziel, WidgetZiel.lernen);
      expect(a.ab, isNull, reason: 'es gibt nichts, worauf umgeschaltet würde');
    });
  });

  group('Ist alles erledigt, fordert das Widget nichts mehr', () {
    test('Tagesziel und beide Hälften durch', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 20),
        facts: WidgetFacts(
          azkar: beide(morgensFertig: 5, abendsFertig: 5),
          dailyGoal: 10,
          answeredToday: 12,
          dayStreak: 12,
        ),
      );
      expect(a.jetzt.titel, 'Durch für heute');
      expect(a.jetzt.zeile, '12 Tage am Stück');
      expect(a.jetzt.prozent, 100);
      expect(a.ab, isNull);
    });

    test('ohne Serie keine erfundene Zahl', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 20),
        facts: const WidgetFacts(dailyGoal: 10, answeredToday: 10),
      );
      expect(a.jetzt.zeile, 'Morgen geht es weiter');
    });

    test('ein Tag heißt „Tag", nicht „Tage"', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 20),
        facts: const WidgetFacts(dailyGoal: 1, answeredToday: 1, dayStreak: 1),
      );
      expect(a.jetzt.zeile, '1 Tag am Stück');
    });
  });

  group('Die zweite Kachel', () {
    test('vor dem Morgenfenster wird dessen Beginn hinterlegt', () {
      // Der Grund für die zweite Kachel: Das Widget kann nichts nachrechnen.
      // Ohne sie stünde um 06:30 noch „Block 3".
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: WidgetFacts(azkar: beide(), blockNumber: 3),
      );
      expect(a.ab, DateTime(2026, 10, 11, 6));
      expect(a.dann?.titel, 'Morgen-Azkar');
      expect(a.dann?.ziel, WidgetZiel.azkar);
    });

    test('im Morgenfenster folgt das Abendfenster', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(azkar: beide()),
      );
      expect(a.ab, DateTime(2026, 10, 11, 8), reason: 'wenn der Morgen endet');
      expect(a.dann?.titel, 'Abend-Azkar');
    });

    test('ist der Abend schon gesprochen, folgt der Lernstand', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 7),
        facts: WidgetFacts(
          azkar: beide(abendsFertig: 5),
          blockNumber: 4,
          blockLearned: 2,
          blockSize: 10,
        ),
      );
      expect(a.dann?.titel, 'Block 4');
      expect(a.dann?.ziel, WidgetZiel.lernen);
    });

    test('nach dem letzten Fenster gibt es keine zweite mehr', () {
      final WidgetAnsicht a = buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 19),
        facts: WidgetFacts(azkar: beide(), blockNumber: 3),
      );
      expect(a.ab, isNull);
      expect(a.dann, isNull);
    });
  });

  group('Was an die Android-Seite geht', () {
    test('flache Werte, fertig zum Anzeigen', () {
      final Map<String, Object> daten = widgetDaten(buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: WidgetFacts(azkar: beide(), blockNumber: 3, blockLearned: 4),
      ));
      expect(daten['w_titel'], 'Block 3');
      expect(daten['w_ziel'], 'lernen');
      expect(daten['w_ab'],
          '${DateTime(2026, 10, 11, 6).millisecondsSinceEpoch}',
          reason: 'als Zeichenkette — sonst stolpert getLong über putInt');
      expect(daten['w_titel2'], 'Morgen-Azkar');
      expect(daten['w_ziel2'], 'azkar');
      for (final Object v in daten.values) {
        expect(v, anyOf(isA<String>(), isA<int>()),
            reason: 'das Widget zerlegt kein JSON');
      }
    });

    test('ohne zweite Kachel steht dort eine Null und leere Texte', () {
      final Map<String, Object> daten = widgetDaten(buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 19),
        facts: const WidgetFacts(blockNumber: 1),
      ));
      expect(daten['w_ab'], '0');
      expect(daten['w_titel2'], '');
    });
  });

  group('Die Brücke', () {
    test('legt alle Werte ab und lässt neu zeichnen', () async {
      final FakeHomeWidgetBackend backend = FakeHomeWidgetBackend();
      final HomeWidgetBridge bridge = HomeWidgetBridge(backend: backend);

      await bridge.push(buildWidgetAnsicht(
        now: DateTime(2026, 10, 11, 5),
        facts: const WidgetFacts(blockNumber: 3, blockLearned: 4),
      ));
      expect(backend.gespeichert['w_titel'], 'Block 3');
      expect(backend.zeichnungen, 1);
    });

    test('ein unveränderter Stand zeichnet nicht neu', () async {
      // Der Startbildschirm soll nicht bei jedem Zuklappen flackern.
      final FakeHomeWidgetBackend backend = FakeHomeWidgetBackend();
      final HomeWidgetBridge bridge = HomeWidgetBridge(backend: backend);
      const WidgetFacts facts = WidgetFacts(blockNumber: 3, blockLearned: 4);

      await bridge.push(
          buildWidgetAnsicht(now: DateTime(2026, 10, 11, 5), facts: facts));
      await bridge.push(
          buildWidgetAnsicht(now: DateTime(2026, 10, 11, 6), facts: facts));
      expect(backend.zeichnungen, 1);
    });

    test('ein geänderter Stand schon', () async {
      final FakeHomeWidgetBackend backend = FakeHomeWidgetBackend();
      final HomeWidgetBridge bridge = HomeWidgetBridge(backend: backend);

      await bridge.push(buildWidgetAnsicht(
          now: DateTime(2026, 10, 11, 5),
          facts: const WidgetFacts(blockLearned: 4)));
      await bridge.push(buildWidgetAnsicht(
          now: DateTime(2026, 10, 11, 5),
          facts: const WidgetFacts(blockLearned: 5)));
      expect(backend.zeichnungen, 2);
    });
  });

  group('Der Tipp auf das Widget', () {
    test('führt in den Bereich, um den es ging', () {
      expect(zielAusAdresse(Uri.parse('taeglichklueger://azkar')),
          WidgetZiel.azkar);
      expect(zielAusAdresse(Uri.parse('taeglichklueger://lernen')),
          WidgetZiel.lernen);
    });

    test('ein gewöhnlicher Start führt nirgendwo hin', () {
      expect(zielAusAdresse(null), isNull);
      expect(zielAusAdresse(Uri.parse('https://example.invalid/azkar')), isNull);
      expect(zielAusAdresse(Uri.parse('taeglichklueger://irgendwas')), isNull);
    });
  });
}
