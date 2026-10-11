# Täglich Klüger

Eine Lern-App auf Deutsch, gebaut mit Flutter — für Android und iOS aus
demselben Code. Zwei Fächer unter einem Dach:

* **Arabisch**, vollständig vokalisiert, mit Alphabet, Verben und
  Quran-Sprache — der ursprüngliche Kern der App.
* **Allgemeinwissen** in drei Fächern: Allgemeinbildung, Technik & Digitales,
  Politik/Wirtschaft/Gesellschaft.

Dazu jeden Tag etwas Neues aus dem Netz im Bereich „Heute".

Es ist bewusst **eine** App geblieben: Die Lernmechanik — Leitner-Termine,
Punkte, Serie, Erinnerung — ist themenneutral. Zwei Apps würden sie
duplizieren und die Tagesserie zerteilen, also genau das zerstören, was zum
täglichen Lernen führt.

> Der Paket- und Ordnername lautet weiterhin `de.susasek.arabischlernen`. Das
> ist Absicht: Er ist kein Anzeigename, sondern die Identität der
> Installation. Würde er sich ändern, gälte die App auf jedem Gerät als neu —
> ohne Lernstand. `test/naming_test.dart` friert ihn und alle sechs
> Speicher-Schlüssel ein.

Die App besteht nicht aus Listen zum Durchlesen, sondern aus Übungen zum
Mitmachen.

**Alle 801 arabischen Wörter sind vollständig vokalisiert** — mit Fatḥa,
Kasra, Ḍamma, Sukūn, Shadda und Tanwīn (شُكْرًا statt شكرا). Ohne diese
Zeichen schreibt Arabisch nur die Konsonanten, und Anfänger können nicht
wissen, wie ein Wort klingt. Ein Test setzt das durch: kommt ein Wort ohne
Zeichen dazu, schlägt er an.

## Ein Fach zur Zeit

Oben auf „Lernen" stehen zwei Knöpfe: **Arabisch** und **Wissen**. Es ist
immer genau eines aktiv, und alles folgt der Wahl — Tagesportion, Lernweg,
jede Übung, die Zahl unten am Symbol. Eine Runde aus Vokabeln und
Wissensfragen durcheinander lernt sich schlechter als zehn Minuten in einer
Sache.

Die Leiste bleibt beim Scrollen stehen; der Fachwechsel ist der häufigste
Griff auf dieser Seite.

**Damit nichts verschwindet**, trägt der *nicht* gewählte Knopf die Zahl
seiner offenen Wiederholungen. Gezählt werden nur angefangene Wörter, deren
Termin gekommen ist — ein nie angesehenes Wort wäre eine Zahl, die sich nie
ändert. Die Abenderinnerung zählt beide Fächer zusammen, und die **Abzeichen
hängen nicht am Fach**: Wer umschaltet, hat nichts verlernt.

## Aufbau der App

Unten vier Bereiche, statt alles auf einer Seite:

| Bereich | Inhalt |
| --- | --- |
| **Lernen** | Was heute fällig ist, Tagesziel, Serie, Level — darunter der Lernweg mit allen Themen. Die Zahl am Symbol zeigt die fälligen Wörter. |
| **Üben** | Alle Übungen und alles zum Nachschlagen, jeweils mit einem Satz dazu, was einen erwartet. |
| **Heute** | Artikel des Tages, „Was geschah heute" und Nachrichten — jeden Tag neu. |
| **Erfolge** | Level, Punkte, Serie und die zwölf Abzeichen. |

## Bereich „Heute"

Einmal am Tag holt die App drei Dinge aus dem Netz: den **Artikel des Tages**
und **„Was geschah heute"** von der deutschen Wikipedia (beides in einem
einzigen Aufruf) sowie die **Nachrichten** der Tagesschau — von dort nur
Überschrift, Dachzeile und erster Satz, kein Volltext. Quelle und Lizenz
(Wikipedia, CC BY-SA 4.0) stehen unter den Karten.

Was gefällt, wandert mit **„Als Karte merken"** unter *Meine Karten* und läuft
danach durch dieselbe Wiederholung wie der übrige Wortschatz. Ein Ereignis
wird dabei zur Frage „In welchem Jahr …?" mit drei plausiblen Jahreszahlen
zur Auswahl, der Artikel des Tages zur Begriffskarte.

**Nachrichten lassen sich nicht merken.** Sie sind morgen überholt und hätten
in einer Wiederholung nach drei Wochen nichts mehr zu suchen.

Der Bereich lädt erst, wenn man ihn öffnet, und merkt sich den Stand für den
Tag. Ohne Netz steht der letzte Stand mit seinem Datum da statt einer
Fehlermeldung ins Leere — der Rest der App braucht kein Netz.

## Wissen wird gelesen, nicht gedrillt

Im Fach Wissen sieht die App **anders aus als bei Arabisch** — weil anders
gelernt wird.

Vokabeln sind willkürliche Paare: „Haus" und بَيْت haben nichts miteinander zu
tun, das muss man stur wiederholen. Dafür ist die Kartei gemacht. Wissen ist
nicht willkürlich. Es hängt zusammen, und wer den Zusammenhang einmal
verstanden hat, braucht keine Karteikarte, sondern einen Text. Eine Karte
„Wolga | Längster Fluss Europas" lehrt ein Stück Trivia, kein Verständnis.

Einheit ist deshalb die **Lektion**, Maß das **verstandene Thema**:

1. **Kurz nachgefasst** — höchstens zwei Fragen, die beim letzten Mal falsch
   waren. Mehr sichtbare Wiederholung gibt es hier nicht.
2. **Einstieg** — ein Satz, worum es geht.
3. **Lesekarten** — Begriff, Bedeutung, Erklärung. Nur „Weiter": **kein
   Bewerten, kein Ankreuzen, keine Selbsteinschätzung.** Hier wird gelesen.
4. **Prüffragen** zu genau dem, was gerade stand, mit sofortiger Auflösung.
5. **„Das nimmst du mit"** — zwei bis drei Kernsätze.

42 Lektionen zu je fünf Minuten, zwei pro Thema. Die Leitner-Wiederholung
läuft für die Fragen im Hintergrund weiter — sie wird im Wissen nur nirgends
angezeigt.

Entsprechend gibt es dort **keine Karteikarten, kein Zuordnen, kein Wort
bauen**: Das sind Vokabelwerkzeuge. Es bleiben Lektion, Feed und Quiz. Und der
Tagesstoff aus dem Netz steht jetzt dort, wo er hingehört — auf der
Wissens-Startseite statt in einem eigenen Bereich. Unten sind es dadurch drei
Bereiche statt vier.

## Ein Thema ist ein Feed

Die Lektion ist der geführte Weg. Wer nur zwei Minuten hat und stöbern will,
tippt ein **Thema** an — und bekommt keinen Karteikasten, sondern einen
**Feed zum Wischen**: eine Karte füllt den Bildschirm, nach oben wischen heißt
weiter.

* **Fakt und Frage wechseln sich ab**, beginnend mit einem Fakt: erst etwas
  erfahren, dann geprüft werden. Wer durchwischt, ohne zu lesen, merkt es an
  der nächsten Frage.
* Bei einer Frage stehen die **vier Antworten eng untereinander am unteren
  Rand** — in der Daumenzone, ohne dass die Hand umgreifen muss. Antippen
  färbt sofort und schiebt die Erklärung an die Stelle der Frage; weiter geht
  es per Wisch.
* Oben läuft ein **Fortschrittsbalken** über das ganze Thema, wie bei Stories.
* Am Ende steht, wie viele Fragen saßen — „Nochmal" oder zurück zur Übersicht.

Der Lernstand läuft dabei still mit: Fragen wandern im Leitner-Kasten wie
überall, Lesekarten ändern nichts. Der Feed ist eine neue **Oberfläche**, kein
zweiter Speicher.

Der Vokabelbildschirm mit Suchfeld und Wortliste gehört damit wieder allein
dem Wortschatz.

## Antworten, die nah beieinander liegen

Bei etlichen Wissensfragen fiel eine der vier Antworten schon der **Form** nach
heraus, ohne dass man etwas wissen musste:

> **Was ist ein Server?**
> Ein Rechner, der Dienste bereitstellt · Ein besonders schneller PC ·
> ~~Ein Netzwerkkabel~~ · Ein Programm im Browser

Ein Kabel ist keine Art von Rechner — die Antwort fällt raus, ohne dass man
etwas weiß. Alle 155 Fragen sind deshalb durchgesehen und die Ablenker von 42
davon neu geschrieben: Sie sind jetzt **dieselbe Art Ding** wie die richtige
Antwort.

> **Was ist ein Server?**
> Ein Rechner, der Dienste bereitstellt · Ein Rechner, der Daten weiterleitet ·
> Ein Rechner, der besonders schnell rechnet · Ein Rechner, der Seiten anzeigt

Kategoriefehler kann kein Test finden; die sind von Hand ausgeräumt.
`test/knowledge_data_test.dart` hält das Ergebnis fest und fängt den Rückfall:
höchstens zwei Bauformen je Frage, kein Ablenker unter 45 % oder über 220 %
der Länge einer Definition, zu einer Zahl nur Zahlen, und Jahreszahlen im
selben Jahrhundert.

## Wissen neben Sprache

Neben rund 800 arabischen Wörtern stecken jetzt **301 Wissenskarten** in der
App, in drei Fächern und 21 Themen:

| Fach | Themen |
| --- | --- |
| **Allgemeinbildung** | Geografie, Geschichte, Naturwissenschaft, Körper & Medizin, Kunst & Literatur, Mathematik, Astronomie, Tiere & Pflanzen |
| **Technik & Digitales** | Computer-Grundlagen, Internet & Netze, Datenschutz & Sicherheit, Künstliche Intelligenz, Alltagstechnik, Energie |
| **Politik, Wirtschaft, Gesellschaft** | Staat & Verfassung, Wahlen & Parteien, Europa & Welt, Recht & Rechte, Wirtschaft & Geld, Arbeit & Soziales, Medien |

Jede Karte ist entweder ein **Begriff** mit seiner Bedeutung oder eine **Frage
mit vier Antworten** und einer Erklärung, die nach dem Antworten erscheint.

**Regel für den festen Bestand: keine Frage, deren Antwort sich ändern kann.**
Wer gerade Bundeskanzler ist, gehört in den Bereich „Heute" — nicht in eine
Karte, die in drei Wochen wiederkommt.

## Dranbleiben: Jokertag, Tagesaufgaben, Belohnung

Punkte, Level und Tagesserie gab es von Anfang an — mit drei Löchern, die
man im Betrieb sofort merkt.

**Ein verpasster Tag löschte die Serie.** Wer dreißig Tage geschafft hat und
einmal krank ist, stand wieder bei null. Es gibt jetzt **Jokertage**. Sie
werden von selbst eingesetzt, und die Grenzen sind der Punkt:

* höchstens **drei Tage am Stück**,
* nur **unmittelbar vor heute**,
* und nur, wenn davor überhaupt eine Serie stand.

Wer nach drei Monaten zurückkommt, verbraucht keinen einzigen — dort gibt es
nichts zu halten. Verdient wird ein Joker, nicht geschenkt: für einen Tag,
an dem alle drei Tagesaufgaben erledigt sind, höchstens drei auf Vorrat.

**Jeder Tag sah gleich aus.** Neben dem Tagesziel stehen jetzt drei
**Tagesaufgaben** — eine zählende („15 Fragen beantworten") und zwei ganze
Übungen („eine Lektion", „ein Thema durchwischen", „eine Runde ohne
Fehler"). Sie sind aus dem **Datum abgeleitet**, nicht gewürfelt: Ein
Neustart der App darf sie nicht neu mischen, sonst wäre jeder Fortschritt
daran wertlos. Angeboten wird nur, wofür es Inhalt gibt.

**Man sah nie, dass man etwas gewinnt.** Serie und Punkte standen nur im
Reiter „Erfolge". Sie stehen jetzt in der **Kopfzeile beider Startseiten**;
die Flamme brennt erst, wenn das Tagesziel gefallen ist. Und ein Abzeichen
schaltete sich lautlos frei — eine Belohnung, die niemand bemerkt, ist
keine. Jetzt meldet sich jedes neue mit einem Blatt von unten, immer nur
eines auf einmal. Beim ersten Start nach dem Update geht **kein Schwall**
alter Abzeichen hoch: Sie gelten als gesehen.

Gezählt wird an einer Stelle. Jede Antwort läuft ohnehin durch den Lernkern,
und der erreicht die Tagesaufgaben über einen Rückruf — nicht acht
Übungsbildschirme, die einzeln daran denken müssten.

## Lernen in Blöcken

Auf der Startseite stand: **„793 Wörter warten auf eine Wiederholung."**

Das ist keine Aufgabe, das ist eine Drohung — und sie wurde über Monate
nicht kleiner. Der Grund steckte in der Zählung: `dueCount` hält auch ein
**nie angesehenes** Wort für fällig. Bei 801 Wörtern und 8 angefangenen
kommt genau diese Zahl heraus.

Jetzt ist die Einheit der **Block**: die nächsten zehn Wörter des Lernwegs,
die noch nicht sitzen. Man übt sie, bis sie sitzen; dann rückt der Block von
selbst weiter.

```
   Block 3 von 81 · 4 von 10 sitzen
   ▓▓▓▓░░░░░░
   2 Wiederholungen fällig · Tagesziel 8/10
   ┌────────────────────────────────┐
   │   Block üben & wiederholen     │
   └────────────────────────────────┘
```

**Der Block braucht nichts Gespeichertes.** Was sitzt, steht im Lernstand;
die Reihenfolge steht im Lernweg. Ein zweiter Merker wäre eine zweite
Wahrheit, die irgendwann abweicht.

Und die Übungen ziehen nicht mehr aus allen 801 Wörtern, sondern aus dem
**Arbeitsvorrat**: fällige Wiederholungen zuerst, dann der laufende Block.
Vorher bekam man ständig neue Wörter vorgesetzt und brachte keines zu
Ende — genau daher kam die Zahl, die nie kleiner wurde. Sitzt einmal alles,
greift eine Übung wieder ins ganze Fach, statt ins Leere.

Die Blockgröße ist einstellbar (5 bis 30), zusammen mit der Kurzrunde unter
**Üben → Kurzrunde → Zahnrad**: welche Übungsarten vorkommen dürfen und wie
viele Blöcke eine Runde hat. Eine Art bleibt immer an — eine Kurzrunde ohne
Übung wäre ein Knopf ins Leere.

## Was man schon kann, sofort abhaken

Ein Wort, das man ohnehin kennt, musste bisher denselben Weg gehen wie jedes
andere: „Kann ich" schiebt es nur **eine** Stufe weiter, gelernt ist es ab
Fach 3, und weil zwischen den Stufen 1, 3 und 7 Tage liegen, dauert
„Gesundheit!" mindestens vier Tage. Bis es wirklich aus dem Weg ist (Fach 5,
60 Tage Pause), über zwei Wochen. Das ist bei „Tee" oder „Taxi" reine
Wartezeit — und sie hält nebenbei den Block auf.

Auf der Karteikarte steht deshalb über den beiden Knöpfen eine leise Zeile:

```
        ┌────────────────────────────┐
        │          Gesundheit        │
        └────────────────────────────┘

           ✓✓ Kenn ich schon — abhaken

   ┌ ─ ─ ─ ─ ─ ─ ─ ┐   ┌───────────────┐
     Nochmal üben        Kann ich       │
   └ ─ ─ ─ ─ ─ ─ ─ ┘   └───────────────┘
```

Das setzt das oberste Fach, das Wort verlässt den laufenden Block, und der
füllt sich sofort nach. Bewusst **kein** dritter gleichwertiger Knopf: Der
Weg ist selten richtig und soll die beiden Hauptwege nicht schmaler machen.

* **Abhaken zählt nicht als beantwortete Frage.** Es heißt „das weiß ich
  schon", nicht „ich habe geübt" — sonst ließe sich das Tagesziel durch
  Wegklicken erreichen.
* **Rückgängig** steht in der Meldung darunter und stellt das **vorherige**
  Fach wieder her, nicht Fach 0. Ein Fehlgriff würde das Wort sonst für zwei
  Monate verstecken.
* In der Wortliste geht das Abhaken wie bisher durch Antippen der Zeile.
* In Quiz, Zuordnen und Wort bauen gibt es den Weg **nicht**: Dort ist das
  Wort die Aufgabe, und ein Abhaken-Knopf wäre ein Weg an der Übung vorbei.
  Die Karteikarte ist die eine Stelle, an der man das Wort sieht, ohne etwas
  gelöst zu haben.

## Wort bauen verrät die Lösung nicht mehr

Unter dem deutschen Wort stand fest die Lautschrift:

```
        siebzig
        sab'un          ← das war die Bauanleitung
    [ ن ] [ و ] [ سَ ] [ بْ ] [ عُ ]
```

s → سَ, b → بْ, ʻ → عُ, u → و, n → ن. Es blieb nichts zu wissen, nur noch
abzulesen. Die Lautschrift ist jetzt ein **Hinweis, den man holen kann** —
und nach dem Prüfen steht sie ohnehin da, dann verrät sie nichts mehr.

Beim **Tippen** bleibt sie sichtbar: Dort steht das arabische Wort oben und
gesucht ist das deutsche, also ist sie eine Lesehilfe und keine Lösung. Auf
der **Karteikarte** steht sie auf der Rückseite, bei der Antwort. Nur „Wort
bauen" war kaputt.

## Der Feed zieht nicht

Ein Wisch-Feed ist ein gefährliches Werkzeug: Dieselbe Form, die Wissen
nebenbei vermittelt, hält abends um eins noch am Telefon. Die erste Fassung
hatte genau diesen Fehler — am Ende eines Themas stand **„Nochmal" als
größter, gefüllter Knopf**, und Themen ließen sich endlos aneinanderreihen.
Der auffälligste Griff schob einen zurück in den Feed.

Das ist umgedreht:

* **„Fertig" ist der Knopf.** „Nochmal durchgehen" steht nur noch als Zeile
  darunter — der ehrliche Fall (drei von acht richtig) bleibt möglich, der
  Reflex ist weg.
* **„Nächstes Thema" ist gestrichen.** Der Knopf hat nie ein nächstes Thema
  geöffnet, sondern nur geschlossen. Wer eins will, wählt eins; das ist eine
  Entscheidung mehr, und genau darum geht es.
* **Eine Tagesportion.** Sie ist `dosePerRound` — dieselbe Zahl, die auch
  Karteikarten und Kurzrunde begrenzt, also standardmäßig 20 Karten und mit
  dem Tagesziel wachsend. Es gibt keine zweite Zahl daneben.
* **Gezählt wird die Karte, nicht das Thema.** Wer auf halber Strecke
  aussteigt und das nächste Thema öffnet, spürt die Grenze genauso. Zurück-
  und wieder Vorwischen zählt nicht doppelt.
* **Die Grenze entscheidet über das nächste Thema, nicht über das laufende.**
  Ein begonnenes darf man zu Ende bringen — mitten aus dem Zusammenhang
  gerissen zu werden wäre Schikane, keine Bremse.
* **Man sieht das Ende kommen.** Unter den Story-Strichen läuft leise
  „heute 12 von 20", und in der Themenliste steht „Portion für heute
  erledigt", bevor man antippt.

Ist die Portion durch, kommt statt des Feeds:

```
              ✓
        Das war deine Portion

    20 Karten heute. Morgen geht es weiter.

   ┌──────────────────────────┐
   │         Fertig           │
   └──────────────────────────┘
          Trotzdem weiter          ← Zeile, kein Knopf
```

**Warum es „Trotzdem weiter" gibt.** Eine Mauer in der eigenen Lern-App wäre
bevormundend — wer wirklich zehn Minuten hat, soll lernen dürfen. Aber es
steht als Zeile unter dem Hauptknopf und gilt nur für dieses eine Thema.
Damit wird aus einem Reflex eine Entscheidung.

Damit gilt der Satz, der hier seit Langem steht, endlich überall: *Jede
Übung ist eine Portion, kein Marathon.* Der Feed war die letzte Stelle, die
sich davor gedrückt hat.

## Die Erinnerung, die sich nicht abnutzt

Die tägliche Erinnerung hatte drei Fehler, und alle drei sorgten dafür, dass
man sie nach einer Woche nicht mehr wahrnimmt.

**Vierzehn Tage lang derselbe Satz.** `plan()` gab jedem Tag ab morgen wörtlich
dieselbe Meldung: *„Zeit für ein paar Wörter — ein paar Wörter heute halten die
Serie am Leben."* Nur der heutige Tag hatte einen eigenen Text. Ab Tag drei
liest man so etwas nicht mehr.

**Eine Meldung am Tag.** Wer um 19:00 gerade kocht, hatte sie verpasst.

**Und die eine Zahl darin war die kaputte.** Übergeben wurde `dueCountTotal`,
und das zählt über `dueEntries` — dort gilt ein nie angesehenes Wort als
fällig. Über beide Fächer sind das fast alle Einträge: Die Abendmeldung sagte
sinngemäß *„1101 Wörter sind heute fällig"*, dieselbe Sorte Zahl wie die „793
Wörter warten", die auf der Startseite schon rausgeflogen ist.

Jetzt sind es **drei Anstöße am Tag**, jeder mit eigener Aufgabe:

| | Voreinstellung | Was dort steht |
| --- | --- | --- |
| Morgens | 08:00 | Ein Wort zum Mitnehmen: „Gesundheit — ʿāfiya" |
| Mittags | 13:00 | Der Stand: „Block 3 — noch 6 Wörter, dann ist er durch." |
| Abends | **deine Zeit** (19:00) | Der Termin mit Gewicht: „Tag 12. Bis Mitternacht zählt heute noch." |

* **Jeden Tag ein anderer Satz.** Der Zufall hängt an Tag und Anstoß, wie bei
  den Tagesaufgaben — derselbe Tag ergibt denselben Text, ohne dass dafür etwas
  gespeichert wird. Tag und Anstoß werden dabei **durchgerührt** (`stableMix`)
  und nicht addiert: Bei benachbarten Startwerten liefert Darts Zufall oft
  denselben ersten Griff, und dann stünde an drei Tagen hintereinander wieder
  dasselbe da. Ein Test hält das fest.
* **Keine Zahl, die nicht stimmt.** Ist nichts fällig, steht nichts von
  Wiederholungen da; gibt es keine Serie, wird keine beschworen. Genannt wird
  `repetitionsDueTotal` — die angefangenen Wiederholungen, nicht der ganze
  Bestand.
* **Zahlen nur für heute.** Was in drei Tagen fällig ist, weiß heute niemand;
  die späteren Tage bekommen den wechselnden Text ohne Zahlen.
* **Was erledigt ist, meldet sich nicht.** Ist das Tagesziel geschafft,
  schweigt der ganze restliche Tag. Dafür schreibt die App den Plan jetzt auch
  **beim Zuklappen** neu, nicht nur beim Start — sonst käme der Abendanstoß
  auch dann noch, wenn man mittags längst fertig war. Drei Erinnerungen am Tag
  sind genau so lange in Ordnung, wie keine davon überflüssig ist.
* **Morgens und mittags lassen sich einzeln abschalten**, der Abendtermin
  nicht. Wem eine Meldung zu viel ist, der nimmt eine heraus statt alles
  abzustellen — so sterben Erinnerungen sonst. Und ein Hauptschalter, der
  unbemerkt leer läuft, wäre schlimmer als keiner.

Die gespeicherte Uhrzeit einer bestehenden Installation bleibt der
**Abendtermin**; Morgen und Mittag kommen als Minuten seit Mitternacht dazu,
`-1` heißt „aus".

## Die App geht nie aus

Nachgemessen: **42 Lektionen, 21 Themen.** Wer eine Lektion am Tag macht, ist
nach **sechs Wochen** durch. Für eine App, die „jeden Tag zwischendurch"
sein will, ist das der wunde Punkt.

Die Lösung lag schon halb im Code. `DailyItem.toCard()` macht seit dem
Bereich „Heute" aus dem **Artikel des Tages** eine Begriffskarte und aus
**„Was geschah heute"** eine Jahresfrage mit drei plausiblen
Falschantworten — geschrieben, getestet, benutzt. Nur der Weg dorthin
fehlte: Man musste den Bereich aufschlagen und jeden Fund einzeln auf „Als
Karte merken" tippen. Das tut niemand täglich.

Jetzt geschieht es von selbst. **Zwei Karten am Tag**, die in Wiederholung,
Quiz und Feed mitlaufen wie alles andere — und auf beiden Startseiten steht
einen Tag lang:

```
 ✦  Neu von heute                          2 Karten
    Golfstrom · In welchem Jahr wurde …            ›
```

Antippen heißt: eine Runde aus genau diesen zwei Fragen. Dreißig Sekunden,
jeden Tag etwas anderes.

**Die Regeln, damit daraus keine Lawine wird:**

* **Ein** Ereignis am Tag, nicht alle zwölf, die Wikipedia für ein Datum
  listet. Ein Schwall wäre keine Abwechslung, sondern eine Hausaufgabe.
* Nachrichten nie — sie wären in einer Wiederholung nach drei Wochen
  überholt. Das entscheidet weiter `canRemember`, nicht eine zweite Regel.
* **Grenze bei 180 Karten** (rund drei Monate). Darüber fallen die ältesten
  weg, und der Lernkern **vergisst ihre Lernstufen mit**. Sonst wüchse der
  Lernstand still weiter mit Einträgen zu Karten, die es nicht mehr gibt.
* Derselbe Fund an zwei Tagen ergibt eine Karte — die `id` ist der Schlüssel
  des Lernstands.

**Abschaltbar, wo es hingehört:** ein Schalter im Bereich „Heute", direkt
über dem Stoff, um den es geht. Aus heißt: Der Bestand bleibt liegen, es
kommt nur nichts dazu. Dort steht auch, wie viele Tagesfunde sich
angesammelt haben, und dort wirft man sie wieder weg.

**Zwei Speicher, zwei Themen.** „Meine Karten" ist, was man sich selbst
aufgehoben hat; „Tagesfunde" ist, was von allein kam. Sie stehen im Lernweg
nebeneinander unter **„Aus dem Alltag"** — nicht in einem Topf, damit „alles
löschen" auf dem einen den anderen nicht mitnimmt.

## Duell — Community ohne Server

Die App hat **kein Konto, keinen Server und keine Anmeldung**, und ein Duell
braucht das auch nicht. Beide Seiten bauen aus **derselben Zahl** dieselbe
Runde: dieselben Fragen, in derselben Reihenfolge, mit den Antworten an
denselben Stellen. Verschickt wird deshalb nur diese Zahl, als kurzer Code
in einer gewöhnlichen Nachricht.

```
Duell: Geografie
Ich hatte 8 von 10. Schaffst du mehr?

TK-4G7Q-M2XP-RB91-KTZ4
```

Drei Wege unter „Üben · Duell":

1. **Herausfordern** — Thema wählen, selbst spielen, Code verschicken.
2. **Annehmen** — die Nachricht einfügen; die App sucht sich den Code
   heraus und spielt genau dieselbe Runde.
3. **Ergebnis eintragen** — die Antwort des anderen einfügen, und es steht
   „Du 8 : 6".

Der Code ist in **Crockford-Base32** geschrieben, ohne I, L, O und U: Das
sind die Zeichen, die man beim Abtippen mit 1, 0 und V verwechselt. Ein
verdrehtes Zeichen ergibt deshalb **keine andere Runde, sondern gar keine**.

Darin steckt außerdem ein **Fingerabdruck** des Fragenbestands. Hat der
Freund eine ältere App-Version mit anderen Fragen, sagt die App das — statt
stillschweigend andere Fragen zu stellen und die Ergebnisse trotzdem zu
vergleichen.

**Was das Gerät verlässt:** nur der Text, den man selbst verschickt. Beim
Teilen eines Ergebnisses sind das Ergebnis, Serie und Level — kein Name,
keine Kennung, nichts über das Gerät. Man sieht ihn vor dem Senden im
Teilen-Blatt. Gibt es keines, landet er in der Zwischenablage, und es steht
dabei.

## Tippen

Die härteste der Übungen: Die Antwort wird selbst geschrieben, statt aus
vieren gewählt. Bei vier Antworten erkennt man oft wieder, was man nicht
abrufen könnte.

Getippt wird immer die **deutsche** Seite — ein arabisches Wort lässt sich auf
einer deutschen Tastatur nicht eingeben. Verglichen wird nachsichtig: Groß-
und Kleinschreibung, Umlautpunkte, Satzzeichen und ein vorangestellter Artikel
entscheiden nichts, und ein Tippfehler in einem längeren Wort zählt als
gewusst („Fast — so wird es geschrieben"). **Nachsicht endet aber dort, wo
eine falsche Antwort durchginge:** „Totes Meer" ist von „Rotes Meer" nur einen
Buchstaben entfernt und trotzdem ein anderes Meer. Liegt die Eingabe genauso
nah an einem Ablenker wie an der Antwort, zählt sie nicht.

## Kurzrunde — zwei Minuten zwischendurch

Ein Knopf ganz oben auf „Lernen" startet eine gemischte Runde: drei Blöcke
verschiedener Übungsarten, etwa acht Aufgaben, dann eine Bilanz. Ein Griff,
und man ist beschäftigt — kein Bereich, keine Übung, keine Richtung wählen.

Die Zusammenstellung entsteht aus dem, was gerade fällig ist, und **nie
zweimal dieselbe Art hintereinander**. Welche Arten möglich sind, ergibt sich
aus dem Vorrat: Im Fach Wissen fällt „Wort bauen" von selbst weg, weil es dort
keine arabischen Buchstaben zu bauen gibt.

Der Fortschrittsbalken oben gilt für die **ganze** Runde, nicht für den
laufenden Block — man sieht, dass es gleich vorbei ist, und hört deshalb nicht
mittendrin auf.

## Tagesportion statt Marathon

Karteikarten und Quiz zeigen nicht den ganzen Bestand, sondern eine Portion:
fällige und schwache Karten zuerst, dann ist Schluss. Die Portion wächst mit
dem Tagesziel — wer sich mehr vornimmt, bekommt mehr. Ein Stapel mit über
tausend Karten ist keine Übung, sondern eine Drohung; wer ihn einmal sieht,
fängt gar nicht erst an. Ein ausgewähltes Thema wird weiterhin ganz
durchgearbeitet.

## Übungen

| Übung | Was man macht |
| --- | --- |
| **Karteikarten** | Wort aufdecken und selbst einschätzen — Vorderseite wahlweise Deutsch oder Arabisch. |
| **Quiz** | Multiple Choice mit vier Antworten, in beide Richtungen (Arabisch → Deutsch und umgekehrt). |
| **Zuordnen** | Deutsches Wort antippen, dann das passende arabische — gelöste Paare verschwinden. |
| **Wort bauen** | Das arabische Wort aus durcheinandergewürfelten Buchstaben zusammensetzen. |
| **Erfolge** | Level, Punkte, Serie und zwölf Abzeichen — mit Fortschrittsbalken zum nächsten. |
| **Alphabet & Zeichen** | Alle 28 Buchstaben mit Aussprache-Hinweis und den vier Formen (allein, Anfang, Mitte, Ende) — dazu eine Übersicht der Tashkīl-Zeichen von Fatḥa bis Tanwīn, jeweils mit Beispiel. |
| **Hören → Deutsch** | Nur das gesprochene Wort ist gegeben. Die schwerste und nützlichste Richtung — nur verfügbar, wenn eine arabische Stimme installiert ist. |

## Quran-Sprache

Ein eigener Bereich für klassisches Arabisch:

* **Sechs kurze Suren Wort für Wort** — al-Fātiḥa, al-ʿAṣr, al-Kauṯar,
  al-Iḫlāṣ, al-Falaq, an-Nās. Jeder Vers mit arabischem Text, deutscher
  Verständnishilfe und jedem einzelnen Wort samt Bedeutung.
* **Die 100 häufigsten Wortformen**, ermittelt aus dem vollständigen Text:
  78.245 Wörter, davon entfallen 29.637 Vorkommen auf diese 100 Formen —
  rund 38 % des gesamten Textes. Gezählt werden Wortformen, nicht Wurzeln.
* **Zwölf Wurzeln** und die Wörter, die aus ihnen wachsen
  (ك·ت·ب → كَتَبَ، كِتَاب، كَاتِب، مَكْتُوب).

Der arabische Text stammt unverändert aus der Ausgabe `quran-simple` des
[Tanzil-Projekts](https://tanzil.net/) und wurde **nicht abgetippt**. Ein Test
vergleicht jeden Vers zeichenweise gegen die mitgelieferte Quellkopie
(`test/data/quran_reference.json`) — er hat beim Bauen bereits einen Fehler
gefunden, bei dem eine von Hand geschriebene Basmala optisch gleich, aber
byteweise anders war (Reihenfolge von Shadda und Fatḥa).

Die deutschen Zeilen sind eine schlichte Verständnishilfe zum Sprachenlernen
und ersetzen keine anerkannte Übersetzung.

## Aussprache

Jedes arabische Wort lässt sich anhören — auf der Karteikarte, im Quiz, in der
Wortliste, beim Alphabet und bei den Tashkīl-Zeichen. Die App nutzt die
Sprachausgabe des Geräts (`flutter_tts`) und spricht standardmäßig langsam.

Ist keine arabische Stimme installiert, bleibt die App still und erklärt beim
Antippen, wo man sie nachinstalliert — statt wortlos nichts zu tun. Die
Hör-Übung wird in diesem Fall übersprungen.

## Jeden Tag ein paar Wörter

Der Teil, der aus Vorsatz Gewohnheit macht:

* **Tägliche Erinnerung** als Benachrichtigung, Uhrzeit frei wählbar
  (Voreinstellung 19:00). An Tagen, an denen das Tagesziel schon geschafft
  ist, bleibt es still — die App plant die nächsten 14 Tage einzeln und
  lässt erledigte Tage aus, statt stur jeden Abend zu piepen.
* **Tagesziel** (Voreinstellung 10 Antworten) und **Serie**: 🔥 zählt die
  Tage in Folge, an denen das Ziel erreicht wurde.
* **Punkte und Level**: 10 Punkte je richtige Antwort, 2 für einen Versuch,
  50 extra für das erreichte Tagesziel, 25 für eine fehlerfreie Quizrunde.
  Level 2 ab 100 Punkten, Level 3 ab 400, Level 4 ab 900.
* **Zwölf Abzeichen** für Meilensteine — von „10 Wörter gelernt" über
  „7 Tage in Folge" bis „ein ganzes Thema gemeistert". Der Erfolge-Bildschirm
  zeigt auch, wie weit es bis zum nächsten ist.

Unter Android 13 und neuer fragt die App beim Einschalten nach der Erlaubnis
für Benachrichtigungen. Wird sie verweigert, sagt die App das offen, statt
eine Erinnerung zu versprechen, die nie ankommt.

## Wie die App sich merkt, was noch wackelt

Jedes Wort durchläuft sechs Stufen mit echten Wiederholungsterminen:

| Stufe | 0 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| nächste Wiederholung | heute | in 1 Tag | in 3 Tagen | in 7 Tagen | in 21 Tagen | in 60 Tagen |

Richtige Antwort → eine Stufe weiter, falsche → zurück auf Stufe 0. Ab Stufe 3
gilt ein Wort als **sitzt**. Die Startseite zeigt, was heute fällig ist, und
startet die Wiederholung mit einem Tippen.

Dazu ein Tagesziel (Voreinstellung: 10 Antworten) und eine Tagesserie: 🔥
zählt die Tage in Folge, an denen das Ziel erreicht wurde.

**Der Lernstand wird auf dem Gerät gespeichert** (`shared_preferences`) und
übersteht das Schließen der App. Ein beschädigter Speicher lässt die App
leer starten statt abzustürzen — auch das ist getestet.

## Wortschatz und Aufbau

**801 vollständig vokalisierte Wörter in 33 Themen**, geordnet in sechs
Bereichen — die Startseite zeigt den Lernweg von oben nach unten:

| Bereich | Themen | Wörter |
| --- | ---: | ---: |
| Erste Schritte — die Wörter, mit denen jedes Gespräch anfängt | 5 | 102 |
| Alltag — zu Hause, Einkaufen, Essen, Kleidung, Zeit | 7 | 176 |
| Unterwegs — Reise, Weg, Orte, Restaurant, Hotel | 5 | 97 |
| Mensch & Welt — Körper, Gesundheit, Gefühle, Arbeit, Natur, Technik | 9 | 190 |
| Bausteine der Sprache — Verben, Adjektive, Gegensätze, Mengen | 6 | 136 |
| Quran-Sprache — die häufigsten Wörter des Quran | 1 | 100 |

Dazu **Verbtabellen**: acht häufige Verben mit allen acht Personen in
Vergangenheit und Gegenwart (64 Formen). Arabisch zeigt die Person in der
Gegenwart über eine Vorsilbe an — أ für „ich", تـ für „du", يـ für „er",
نـ für „wir" —, und dieses Muster wiederholt sich bei fast jedem Verb.

Als Inspiration für die Themenauswahl diente der
[Grundwortschatz Arabisch von Sprachheld](https://www.sprachheld.de/).

Die Wörter stehen in Pausalform: innen voll vokalisiert, ohne Kasusendung am
Wortende — so, wie man sie einzeln ausspricht. Wo das Tanwīn zur Aussprache
gehört (شُكْرًا, غَدًا, مُبَاشَرَةً), steht es. Die Suche findet ein Wort mit
und ohne Zeichen: Wer كتاب tippt, findet كِتَاب.

## Das Symbol

Ein fast geschlossener Ring — die Tagesrunde, die sich füllt — und ein Funke
darin. Erzeugt wird es aus einer einzigen Zeichnung:

```bash
python3 tool/make_icons.py             # alle Größen schreiben
python3 tool/make_icons.py --preview   # nur ansehen
```

Das Skript schreibt Android (Symbol, adaptives Vordergrundbild,
Benachrichtigung), iOS und Web. Es liegt bewusst im Repository: Der Erzeuger
des ersten Symbols lag nur in einem Arbeitsverzeichnis und ist weg — jenes
Symbol ließe sich heute nicht mehr nachbauen.

Das **Benachrichtigungssymbol** bleibt eine flache weiße Silhouette. Android
färbt es selbst ein und benutzt nur den Alphakanal; alles mit Farbverlauf
würde dort zu einem grauen Klecks.

## Projektstruktur

```
lib/
├── main.dart              App, Theme (hell & dunkel)
├── models/                VocabEntry, VocabCategory, ArabicLetter,
│                          ArabicDiacritic + Tashkīl-Hilfsfunktionen
├── theme/                 Abstände, Radien, Bewegung, Erscheinungsbild
├── state/                 Lernstufen & Termine, Speicherung, Punkte,
│                          Jokertage, Tagesaufgaben, Duell-Codes, Teilen,
│                          Tagesfunde und ihre Ernte,
│                          Sprachausgabe, Erinnerungen, Tagesinhalte,
│                          gemerkte Karten
├── data/                  Wortschatz, Lernweg, Registry, Alphabet, Verben,
│                          Quran
├── screens/               Start (Arabisch), Start (Wissen), Heute, Lektion,
│                          Feed, Thema, Karteikarten, Quiz, Zuordnen,
│                          Wort bauen, Duell, Alphabet & Zeichen, Suche,
│                          Quran-Übersicht, Sure, Wurzeln, Verbtabellen,
│                          Navigationsgerüst, Übungsübersicht
└── widgets/               Arabische Textausgabe (RTL), Wortzeile, Lernboxen,
                           Fachumschalter, Serienanzeige, Tagesaufgaben,
                           Belohnungsblatt, Tagesfund-Karte, Portionsende,
                           Lerneinstellungen
```

## Entwickeln

```bash
flutter pub get
flutter test        # 154 Tests: Daten, Lernlogik, Speicherung, Sprachausgabe,
                    # Quran-Text gegen die Quelle, Verbtabellen,
                    # Erinnerungsplan, Punkte & Abzeichen, Registry,
                    # Layout auf drei Displaygrößen und bei 150 % Schrift
flutter analyze
flutter run
```

## Builds über GitHub Actions

| Workflow | Ergebnis |
| --- | --- |
| `.github/workflows/android.yml` | Analyse + Tests, danach `app-release.apk` und `app-release.aab` als Artefakte. Läuft bei Push/PR und manuell. |
| `.github/workflows/dart.yml` | Unsignierte iOS-`.ipa` (ohne Apple-Developer-Account), manuell über *Run workflow*. |

Die Android-Artefakte liegen nach dem Lauf unter *Actions → Run → Artifacts*.
Die APK ist mit dem Debug-Key signiert und damit zum Ausprobieren, nicht für
den Play Store gedacht.

## Quellen der Tagesinhalte

| Quelle | Aufruf | Lizenz |
| --- | --- | --- |
| Wikipedia | `de.wikipedia.org/api/rest_v1/feed/featured/JJJJ/MM/TT` | CC BY-SA 4.0, im Bereich genannt |
| Tagesschau | `tagesschau.de/api2u/news` (ohne Schrägstrich am Ende) | nur Überschrift und erster Satz, mit Verweis |

Beide sind ohne Vertrag nutzbar, aber auch ohne Zusage. Die App muss deshalb
ohne sie vollständig funktionieren — der Feed ist Beiwerk, nicht Fundament.
Getestet wird er gegen abgelegte echte Antworten unter `test/data/`, nicht
gegen das Netz.

## Ein kleines Widget für den Startbildschirm

2x1 Zellen, zwei Zeilen, ein Balken. Es zeigt **immer nur eine Sache: was
gerade dran ist.**

```
   ┌────────────────────────────┐
   │ ◟ Morgen-Azkar             │
   │   06:12 · 0 von 5          │
   │   ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁     │
   └────────────────────────────┘
```

Die Reihenfolge ist eine Entscheidung und keine Laune:

1. **Ein offenes Azkar-Fenster hat Vorrang.** Es hat eine Zeit, die vergeht;
   das Lernen hat den ganzen Tag.
2. Sonst der laufende Block — fällige Wiederholungen zuerst, denn die sind
   das, was sonst verfällt.
3. Sonst das nächste Azkar-Fenster des Tages, mit seiner Uhrzeit.
4. Ist alles erledigt: „Durch für heute · 12 Tage am Stück". Dann **fordert
   das Widget nichts mehr** — dieselbe Haltung wie bei der Tagesportion.

Ein Tipp öffnet den Bereich, um den es gerade geht (`taeglichklueger://azkar`
beziehungsweise `…//lernen`), nicht irgendeine Startseite, von der aus man
noch zweimal tippen müsste.

### Warum zwei Kacheln hinterlegt werden

Ein Widget kann **nichts nachrechnen** — es zeigt, was die App zuletzt
abgelegt hat. Ohne Zutun stünde um 05:00 „Block 3" und um 06:30, wenn das
Fajr-Fenster längst offen ist, noch immer dasselbe.

Deshalb legt die App zwei fertige Kacheln ab und **einen** Zeitpunkt, ab dem
die zweite gilt. Die Android-Seite vergleicht nur die Uhr mit dieser Zahl —
ein Vergleich, keine zweite Rechenlogik. Was angezeigt wird, entscheidet
`buildWidgetAnsicht` (`lib/state/home_widget_view.dart`), eine reine Funktion
mit eigenen Tests. Zusammen mit `updatePeriodMillis` (30 Minuten, Androids
Untergrenze) wechselt die Anzeige von allein, auch wenn die App seit dem
Abend nicht lief.

### Geschrieben wird beim Zuklappen

Nicht bei jeder Antwort: Niemand liest ein Widget, während die App offen ist.
Und ein Stand, der sich nicht geändert hat, löst **kein** Neuzeichnen aus —
der Startbildschirm soll nicht bei jedem Zuklappen flackern.

Die Farben liegen in `values/widget_colors.xml` und `values-night/` doppelt:
Ein Widget, das nachts weiß leuchtet, ist auf einem dunklen Startbildschirm
ein Fremdkörper. Das Benachrichtigungssymbol ist eine flache weiße
Silhouette und wird im Widget eingefärbt, sonst wäre es auf heller Fläche
unsichtbar.

## Azkar: Morgen und Abend

Ein vierter Bereich neben Lernen, Üben und Erfolge — und bewusst **keine
zweite Lernspur**: kein XP, kein Level, keine Abzeichen, kein Einfluss auf
den Jokertag. Eine Liste, die man durchgeht, und dann ist sie durch.

### Drei Stufen, keine Mauer

| Stufe | Umfang |
| --- | --- |
| **Leicht** | 5 Azkar — Āyat al-Kursī, die drei letzten Suren, Sayyid al-Istiġfār |
| **Voll** | ~12, der Regelfall |
| **Vollständig** | ~22 |

Was nicht zur eigenen Stufe gehört, steht trotzdem unten unter **„Mehr, wenn
du magst"** und lässt sich antippen. Wer an einem guten Tag mehr schafft, soll
nicht erst in die Einstellungen.

Antippen zählt hoch (`1 / 3`, `47 / 100`), langes Drücken setzt zurück. Kein
Wischfeed, kein Fortschritt, der zum Weitermachen drängt.

### Die Zeiten kommen aus den Gebetszeiten

Morgen-Azkar nach **Fajr** bis zum Sonnenaufgang, Abend-Azkar nach **ʿAsr**
bis zum Maġrib — gerechnet mit dem Paket `adhan`, reines Dart, offline. Eine
feste Uhrzeit wäre im Dezember falsch oder im Juni.

**Ohne Standortberechtigung.** Man stellt seinen Ort einmal ein (Stadtliste
oder Koordinaten); danach fragt die App nie wieder. Methode (Vorgabe: Muslim
World League), Maḏhab für ʿAsr (Vorgabe: Šāfiʿī) und der Versatz nach dem
Gebet sind einstellbar.

**Ein gemessener Fallstrick.** In Berlin geht die Sonne im Sommer nie 18°
unter den Horizont — Fajr ist nach der reinen Winkelrechnung undefiniert, und
`adhan` behilft sich mit einer Regel. Mit der Vorgabe der Bibliothek fiel Fajr
am 21. Juni auf den **20. Juni, 23:08**, also einen Tag zu früh; eine darauf
geplante Erinnerung läge in der Vergangenheit und entfiele den ganzen Sommer
über still.

```
middle_of_the_night    fajr = 20.06. 23:08   ← falscher Tag
twilight_angle         fajr = 21.06. 00:34
seventh_of_the_night   fajr = 21.06. 01:42   ← gewählt
```

Ein Test geht jeden Junitag durch und prüft, dass Fajr auf seinem eigenen Tag
bleibt.

### In den Erinnerungen

Aus drei Anstößen am Tag werden fünf. Zwei Dinge sind bei den Azkar anders:

* Ihre Zeit steht in keiner Einstellung, sie kommt je Tag aus der
  Gebetszeitrechnung — und wandert von allein mit der Jahreszeit.
* **Das erreichte Tagesziel bremst sie nicht.** Wer sein Lernpensum geschafft
  hat, hat deshalb noch nichts gesprochen; die beiden Spuren berühren sich
  nicht. Dafür schweigen sie, sobald die Azkar des Tages abgehakt sind.

Ohne eingestellten Ort gibt es **keine** Azkar-Erinnerung — lieber keine als
eine zur geratenen Stunde.

### Eine eigene, ruhige Serie

Morgen und Abend zählen getrennt („12 Tage Morgen-Azkar"). Ein Test hält
fest, dass XP, Lernserie, Antwortzahl und Jokertage dabei unberührt bleiben
und der Lernstand nicht einmal angefasst wird.

### Woher die Texte stammen

**Der quranische Teil wird nicht abgetippt.** Al-Iḫlāṣ, Al-Falaq und An-Nās
kommen aus `kSuras` — sie liegen bereits im Repository (Tanzil-Ausgabe
„quran-simple"), und ein Test vergleicht sie zeichengenau, damit sich keine
zweite Fassung einschleicht. Āyat al-Kursī stammt aus derselben Quelle.

Die **Hadith-Azkar sind von Hand gesetzt**, nach dem Bestand von „Ḥiṣn
al-Muslim", mit Sammlung und Nummer an jedem Eintrag; ein Test erzwingt, dass
kein Eintrag ohne Quelle existiert.

> **Bitte prüfen lassen.** Bei Tashkīl von Hand sind Fehler möglich, und bei
> einem Gebetstext wiegt ein falsches Zeichen schwerer als anderswo. Der
> Hinweis steht auch in der App, unter der Liste. Korrekturen sind in
> `lib/data/azkar_data.dart` eine Zeile.

Die deutschen Zeilen sind — wie beim Quran-Teil — eine Verständnishilfe und
ersetzen keine anerkannte Übersetzung.

## Updates, die nichts kaputtmachen

Zwei Dinge, die zusammengehören: Die App sagt Bescheid, wenn es etwas Neues
gibt, und man kann seinen Lernstand jederzeit beiseitelegen.

### „Version 3.9.0 ist da"

Einmal am Tag — nicht bei jedem Start, das wäre Datenverkehr ohne Gegenwert —
fragt die App bei GitHub nach der neuesten Version. Ist eine da, steht auf der
Startseite eine ruhige Karte mit einem Knopf; der öffnet die APK-Adresse,
Android lädt sie, ein Tipp installiert sie **über** die vorhandene App.

* **Kein Dialog.** Ein Update ist nie dringend. Etwas, das sich vor den
  Bildschirm stellt, bevor man lernen darf, wäre an dieser Stelle respektlos.
* **Scheitert die Abfrage, passiert nichts Sichtbares.** Offline, Repository
  nicht öffentlich, GitHub gerade weg — alles derselbe Fall. Eine
  Fehlermeldung über ein Update, das man nicht wollte, ist Lärm.
* **Das Repository muss öffentlich sein.** Bei einem privaten bräuchte die App
  einen GitHub-Token im Programmcode, und ein Token, der in einer 57-MB-APK
  mitreist, ist keiner.
* Verglichen wird **Zahl für Zahl**. Zeichenweise wäre „3.10.0" kleiner als
  „3.9.0", weil „1" vor „9" kommt — der Fehler, den jeder Versionsvergleich
  einmal macht, und deshalb steht `istNeuer` als reine Funktion mit eigenem
  Test da.

### Lernstand sichern und zurückholen

Unter **Erfolge → Menü**. Gesichert wird in genau dem Format, in dem der Stand
ohnehin auf dem Gerät liegt (`ProgressStore.encode`) — ein zweites Format für
die Sicherung wäre ein zweites, das veraltet. Dazu eine Hülle mit Kennzeichen,
damit nicht irgendeine JSON-Datei aus dem Download-Ordner als Lernstand
durchgeht.

Beim Einspielen wird **erst gefragt**, mit Zahlen aus der Datei („412
Antworten, 180 Wörter mit Lernstand"). Eine Sicherung, die stillschweigend
überschreibt, ist eine Falle: Wer die falsche Datei erwischt, wäre seinen
Stand los und hätte es nicht gemerkt.

Eine Datei aus einer älteren Version liest sich weiter — in `StoredProgress`
hat jedes Feld eine Vorgabe, und ein Test hält genau diesen Fall fest.

## Eigenen Signaturschlüssel benutzen

**Das ist der Grund, warum der Lernstand bei jedem Update verschwand.** Ohne
eigenen Schlüssel signiert der Bau mit dem **Debug-Schlüssel**, und den
erzeugt jeder CI-Läufer frisch. Jede Version trägt also eine andere Signatur,
Android verweigert das Drüberinstallieren, man deinstalliert — und der
Lernstand ist weg. Nicht gelegentlich: jedes Mal.

Mit festem Schlüssel hört das auf. Der Workflow kann das längst, ihm fehlten
nur die Secrets.

Einen eigenen Schlüssel erzeugt **nur der Besitzer**, niemand sonst — er darf
nicht durch fremde Hände gehen:

```bash
keytool -genkeypair -v -keystore ~/upload.jks -storetype PKCS12 \
        -keyalg RSA -keysize 4096 -validity 10950 -alias upload
```

Dann `android/key.properties` anlegen — die Datei steht in `.gitignore` und
gehört nie ins Repository:

```properties
storeFile=/absoluter/pfad/upload.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

Ist die Datei da, signiert `flutter build apk --release` damit; fehlt sie,
läuft der Bau unverändert mit dem Debug-Schlüssel weiter. Beide Wege sind
geprüft: einmal ohne Datei, einmal mit einem Wegwerfschlüssel, dessen Zertifikat
danach im APK stand.

Für GitHub Actions dieselben vier Werte unter **Settings → Secrets and
variables → Actions → New repository secret** hinterlegen:

| Secret | Wert |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Ausgabe von `base64 -w0 ~/upload.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | das vergebene Kennwort |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | dasselbe Kennwort |

Fehlen sie, baut der Workflow weiter — mit dem Debug-Schlüssel, und damit
beginnt das Spiel von vorn.

**Ein letztes Mal deinstallieren.** Der Wechsel auf den festen Schlüssel ist
selbst noch ein Signaturwechsel; die Version davor lässt sich nicht
überschreiben. Danach nie wieder.

**Den Schlüssel nie verlieren.** Ohne ihn lässt sich keine installierte App
mehr aktualisieren — weder über GitHub noch über den Play Store.

## Bewusst offen

Ehrlicher als eine halbe Umsetzung:

* **Beispielsätze auf Arabisch.** Rund 800 Sätze mit vollständigem Tashkīl zu
  schreiben ist eine eigene Etappe, keine Beigabe — und ohne Quelle nicht so
  prüfbar, wie es der Quran-Text ist. Wissenskarten tragen ihren Kontext
  dagegen schon in der Erklärung.
* **Schreibtrainer** (Buchstabenformen nachziehen). Bräuchte Zeichenfläche und
  Erkennung; „Wort bauen" übt dieselbe Fertigkeit ohne Gestenerkennung.
* **iOS.** Der Ordner steht weitgehend auf der Vorlage; Anzeigename und
  Version sind gesetzt. Ob ein `.ipa` durchläuft, **kann ich ohne Mac nicht
  nachprüfen** — der Workflow dafür liegt bereit, gebaut habe ich ihn nie.
* **Gerätefragen.** Ob die Erinnerung abends wirklich ankommt, wie die
  arabische Sprachausgabe klingt und ob die Tagesinhalte eintreffen, zeigt
  erst das Telefon.
* **Ob morgens wirklich zwei neue Karten dastehen**, braucht einen echten
  Tageswechsel und echtes Netz. Geprüft ist, was die abgelegten Antworten
  hergeben (`test/daily_harvest_test.dart`) — ein echter Morgen ist das
  nicht.
* **Ob das Teilen-Blatt aufgeht** und wie ein Code in WhatsApp ankommt, ist
  nur am Gerät zu sehen — `share_plus` gehört dem Betriebssystem. Im Test
  liegt eine Attrappe dahinter, und der Rückfall auf die Zwischenablage ist
  geprüft; das Blatt selbst nicht.
* **Ein Duell über zwei echte Telefone** ist hier nicht nachstellbar. Dass
  beide Seiten aus demselben Code dieselben Fragen mit derselben
  Antwortreihenfolge bauen, prüft `test/duel_test.dart` — zwei Geräte im
  selben Raum ersetzt das nicht.

## Herkunft

Das Repository geht auf ein Tutorial von
[AmirBayat0](https://github.com/AmirBayat0/iOS_iPA) zurück, das zeigt, wie
man eine Flutter-iOS-`.ipa` ohne Mac baut ([YouTube](https://youtu.be/mQMy12Sk0xM)).
Der iOS-Workflow stammt von dort.
