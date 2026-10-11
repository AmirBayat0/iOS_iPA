import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'home_widget_view.dart';

/// Wohin die Werte des Widgets gehen. Hinter einer Schnittstelle, damit ein
/// Test sieht, **was** hinterlegt worden wäre — dasselbe Muster wie bei
/// [ReminderBackend] und [ShareBackend].
abstract class HomeWidgetBackend {
  Future<void> save(String key, Object value);

  /// Sagt dem Startbildschirm, dass er neu zeichnen soll.
  Future<void> update();
}

/// Die echte Umsetzung über `home_widget`.
class PluginHomeWidgetBackend implements HomeWidgetBackend {
  const PluginHomeWidgetBackend();

  /// Muss zum Klassennamen in `android/app/src/main/kotlin/.../`
  /// übereinstimmen — sonst wird ein Widget hinterlegt, das es nicht gibt.
  static const String androidName = 'KleinesWidget';

  @override
  Future<void> save(String key, Object value) async {
    try {
      await HomeWidget.saveWidgetData<Object>(key, value);
    } catch (error) {
      debugPrint('Widget-Wert $key nicht ablegbar: $error');
    }
  }

  @override
  Future<void> update() async {
    try {
      await HomeWidget.updateWidget(name: androidName, androidName: androidName);
    } catch (error) {
      // Kein Widget auf dem Startbildschirm, oder eine Plattform ohne
      // Widgets: beides kein Fehler, über den jemand etwas erfahren müsste.
      debugPrint('Widget nicht aktualisierbar: $error');
    }
  }
}

/// Hält das Widget auf dem Stand.
///
/// **Wann geschrieben wird:** beim Start und beim Zuklappen der App — nicht
/// bei jeder Antwort. Ein Widget liest niemand, während die App offen ist;
/// alles andere wären Schreibzugriffe ohne Betrachter.
class HomeWidgetBridge {
  HomeWidgetBridge({HomeWidgetBackend? backend})
      : _backend = backend ?? const PluginHomeWidgetBackend();

  final HomeWidgetBackend _backend;

  /// Was zuletzt hinterlegt wurde — damit ein unveränderter Stand kein
  /// Neuzeichnen auslöst.
  Map<String, Object>? _zuletzt;

  Future<void> push(WidgetAnsicht ansicht) async {
    final Map<String, Object> daten = widgetDaten(ansicht);
    if (_zuletzt != null && _gleich(_zuletzt!, daten)) return;
    _zuletzt = daten;

    for (final MapEntry<String, Object> e in daten.entries) {
      await _backend.save(e.key, e.value);
    }
    await _backend.update();
  }

  /// Der Tagesstempel ändert sich jeden Tag und sagt über die Anzeige
  /// nichts — er darf kein Neuzeichnen erzwingen.
  static bool _gleich(Map<String, Object> a, Map<String, Object> b) {
    for (final String k in a.keys) {
      if (k == 'w_stand') continue;
      if (a[k] != b[k]) return false;
    }
    return true;
  }
}

/// Der Bereich, den ein Tipp auf das Widget öffnen soll.
///
/// Das Widget startet die App mit `taeglichklueger://azkar` oder
/// `…//lernen`; mehr steht in der Adresse nicht, und mehr soll auch nicht
/// darin stehen — eine Adresse, die Lernstand mitschleppt, veraltet im
/// Benachrichtigungsschacht.
WidgetZiel? zielAusAdresse(Uri? uri) {
  if (uri == null || uri.scheme != 'taeglichklueger') return null;
  final String name = uri.host.isNotEmpty ? uri.host : uri.path.replaceAll('/', '');
  return switch (name) {
    'azkar' => WidgetZiel.azkar,
    'lernen' => WidgetZiel.lernen,
    _ => null,
  };
}
