package de.susasek.arabischlernen

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Das kleine Widget für den Startbildschirm.
 *
 * ## Was es zeigt
 *
 * Immer nur **eine** Sache: was gerade dran ist. Steht ein Azkar-Fenster
 * offen, dann die Azkar; sonst der laufende Lernblock; ist alles erledigt,
 * sagt es das und fordert nichts mehr.
 *
 * ## Warum hier trotzdem ein Vergleich steht
 *
 * Ein Widget kann nichts nachrechnen — es zeigt, was die App zuletzt
 * hinterlegt hat. Ohne Zutun stünde um 05:00 „Block 3" und um 06:30, wenn
 * das Fajr-Fenster längst offen ist, noch immer dasselbe.
 *
 * Deshalb legt die App **zwei** fertige Kacheln ab und einen Zeitpunkt, ab
 * dem die zweite gilt. Hier wird nur die Uhr mit dieser Zahl verglichen.
 * Das ist bewusst keine zweite Rechenlogik: Was angezeigt wird, entscheidet
 * `buildWidgetAnsicht` in `lib/state/home_widget_view.dart`, und das ist
 * eine reine Funktion mit eigenen Tests.
 *
 * Zusammen mit `updatePeriodMillis` (30 Minuten, Androids Untergrenze) wechselt
 * die Anzeige damit von allein, auch wenn die App seit dem Abend nicht lief.
 */
class KleinesWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { id ->
            val ansicht = RemoteViews(context.packageName, R.layout.widget_klein)

            // Ab dem hinterlegten Zeitpunkt gilt die zweite Kachel. 0 heißt:
            // es gibt keine, dann bleibt die erste bis zum nächsten Start.
            //
            // Der Wert kommt als Zeichenkette und nicht als Zahl: Eine
            // Dart-Zahl landet je nach Größe über `putInt` oder `putLong`
            // im Speicher, und `getLong` auf einem `putInt`-Wert wirft eine
            // ClassCastException. Beim Zeitstempel (groß) und der 0 (klein)
            // wäre genau das passiert.
            val ab = widgetData.getString("w_ab", null)?.toLongOrNull() ?: 0L
            val zweite = ab > 0L && System.currentTimeMillis() >= ab

            val titel = widgetData.getString(if (zweite) "w_titel2" else "w_titel", null)
            val zeile = widgetData.getString(if (zweite) "w_zeile2" else "w_zeile", null)
            val prozent = widgetData.getInt(if (zweite) "w_prozent2" else "w_prozent", 0)
            val ziel = widgetData.getString(if (zweite) "w_ziel2" else "w_ziel", "lernen")

            // Fehlt ein Wert, ist die App noch nie gelaufen. Dann bleibt der
            // Platzhalter aus dem Layout stehen, statt eine leere Zeile zu
            // zeigen — das Widget sagt dann „Zum Einrichten antippen".
            if (!titel.isNullOrEmpty()) {
                ansicht.setTextViewText(R.id.widget_titel, titel)
            }
            if (!zeile.isNullOrEmpty()) {
                ansicht.setTextViewText(R.id.widget_zeile, zeile)
            }
            ansicht.setProgressBar(R.id.widget_balken, 100, prozent.coerceIn(0, 100), false)

            // Ein Tipp öffnet den Bereich, um den es gerade geht — nicht
            // irgendeine Startseite, von der aus man noch zweimal tippen
            // müsste.
            ansicht.setOnClickPendingIntent(R.id.widget_wurzel, startIntent(context, ziel))

            appWidgetManager.updateAppWidget(id, ansicht)
        }
    }

    /**
     * Öffnet die App mit einer Adresse, aus der die Oberfläche den Bereich
     * ablesen kann: `taeglichklueger://azkar` oder `…//lernen`.
     */
    private fun startIntent(context: Context, ziel: String?): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("taeglichklueger://${ziel ?: "lernen"}")
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
        }
        // Je Ziel ein eigener requestCode, sonst gäbe Android denselben
        // Intent zurück und das Widget führte immer in denselben Bereich.
        val code = if (ziel == "azkar") 2 else 1
        return PendingIntent.getActivity(
            context,
            code,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
