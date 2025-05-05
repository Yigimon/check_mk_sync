:::: {#header}
# Die Monitoring-Werkzeuge

::: details
[Last modified on 03-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_tools.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
:::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

:::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Checkmk im Monitoring](intro_monitor.html) [Die
Benutzeroberfläche](user_interface.html) [Ansichten von Hosts und
Services (Views)](views.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#status_interface .hidden-anchor .sr-only}1. Statusoberfläche {#heading_status_interface}

:::: sectionbody
::: paragraph
Jetzt, da wir unserem Monitoring-System endlich etwas zu tun gegeben
haben, ist es an der Zeit, dass wir uns näher mit den Elementen der
Checkmk-Benutzeroberfläche befassen, die Ihnen im täglichen Leben beim
Monitoring (oder im Operating) helfen. In Checkmk wird dieser Teil auch
manchmal als **Statusoberfläche** bezeichnet, weil es meist darum geht,
den aktuellen Status von allen Hosts und Services zu sehen. Dazu gehören
Dashboards und Views, die Sie über das [Monitor]{.guihint}-Menü
aufrufen, die Snapins der Statusleiste, aber auch die Darstellung und
Aufbereitung von Messwerten.
:::
::::
:::::

::::::::::::::::: sect1
## []{#overview .hidden-anchor .sr-only}2. Overview {#heading_overview}

:::::::::::::::: sectionbody
::: paragraph
Prominent oben in der Seitenleiste platziert finden Sie das Snapin
[Overview]{.guihint}:
:::

::::: imageblock
::: content
![Snapin Overview im
Show-less-Modus.](../images/gui_overview_less.png){width="50%"}
:::

::: title
Das Snapin [Overview]{.guihint} im Show-less-Modus
:::
:::::

::: paragraph
In der linken Spalte dieser kleinen Tabelle sehen Sie zunächst die
Anzahl Ihrer überwachten Hosts und Services. Die dritte Zeile zeigt
[Events]{.guihint}. Diese werden für Sie erst dann relevant, wenn Sie
eine Überwachung von Meldungen konfiguriert haben. Damit sind z.B.
Meldungen aus Syslog, SNMP-Traps und Log-Dateien gemeint. Dafür hat
Checkmk ein eigenes, sehr mächtiges Modul, das ausführlich besprochen
wird im gleichnamigen Artikel zur [Event Console.](ec.html)
:::

::: paragraph
Die rechte Spalte zeigt die Zahl der Probleme, die noch nicht quittiert
wurden. Probleme sind Objekte, die gerade im Status
[WARN]{.state1}/[CRIT]{.state2}/[UNKNOWN]{.state3} bzw.
[DOWN]{.hstate1}/[UNREACH]{.hstate2} sind. Die Quittierung
(*acknowledgment*) ist eine Art „zur Kenntnisnahme" eines Problems.
Übrigens werden Probleme von Services hier nicht mitgezählt, deren Host
[DOWN]{.hstate1} oder in einer
[Wartungszeit](glossar.html#scheduled_downtime) ist.
:::

::: paragraph
Sie können auf die Zahl in der Zelle klicken und kommen dann direkt zu
einer Liste der Objekte, die hier gezählt wurden. Das funktioniert
übrigens bei allen Zellen im [Overview.]{.guihint}
:::

::: paragraph
Auch im [Overview]{.guihint} können Sie entscheiden, ob Sie weniger oder
mehr Informationen sehen wollen. Mit dem Knopf [![Symbol zum Wechsel in
den
Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline}
schalten Sie in den Show-more-Modus:
:::

::::: imageblock
::: content
![Snapin Overview im
Show-more-Modus.](../images/overview_more.png){width="50%"}
:::

::: title
Das Snapin [Overview]{.guihint} im Show-more-Modus
:::
:::::

::: paragraph
Zwischen den beiden zuvor sichtbaren Spalten zeigt jetzt die neue zweite
Spalte die Zahl **aller** Probleme, d.h. zusätzlich auch diejenigen, die
bereits quittiert wurden. In unserem Beispiel sind die Zahlen in der
zweiten und dritten Spalte identisch, da wir noch kein Problem quittiert
haben.
:::

::: paragraph
Schließlich zeigt die letzte Spalte ganz rechts die Hosts oder Services,
deren Information „veraltet" (*stale*) ist, da über sie zurzeit keine
aktuellen Monitoring-Daten vorliegen. Wenn z.B. ein Host aktuell gar
nicht erreichbar ist, kann Checkmk auch keine Neuigkeiten über dessen
Services ermitteln. Das bedeutet aber nicht automatisch, dass diese ein
Problem haben. Deswegen nimmt Checkmk nicht einfach einen neuen Status
für diese Services an, sondern setzt sie auf den Pseudostatus „Stale".
Die Spalte [Stale]{.guihint} wird von Checkmk weggelassen, wenn sie
überall `0` zeigen würde.
:::
::::::::::::::::
:::::::::::::::::

::::::::::: sect1
## []{#monitor_menu .hidden-anchor .sr-only}3. Monitor-Menü {#heading_monitor_menu}

:::::::::: sectionbody
::: paragraph
Ihr Werkzeugkasten zur Erledigung aller Aufgaben im Monitoring ist das
[Monitor]{.guihint}-Menü, das Sie über die Navigationsleiste öffnen
können:
:::

::::: imageblock
::: content
![Monitor-Menü von Checkmk Raw im
Show-less-Modus.](../images/monitor_menu_less.png)
:::

::: title
Das [Monitor]{.guihint}-Menü von Checkmk Raw im Show-less-Modus
:::
:::::

::: paragraph
In diesem Menü finden Sie die Hilfsmittel, die Ihnen Antworten auf Ihre
Fragen im Monitoring geben. Das Menü ist nach Themen (*topics*)
untergliedert. Unterhalb jedes Themas finden Sie die Menüeinträge.
:::

::: paragraph
Nach Auswahl eines der Einträge im [Monitor]{.guihint}-Menü wird Ihnen
auf der Hauptseite die angeforderte Information in der Regel entweder
als Dashboard oder als Tabellenansicht (*view*) angezeigt, auf die wir
in diesem Artikel noch näher eingehen werden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Den Inhalt des                    |
|                                   | [Monitor]{.guihint}-Menüs können  |
|                                   | Sie sich auch in die Seitenleiste |
|                                   | laden: als Snapin mit dem Titel   |
|                                   | [Views]{.guihint}. Dieses Snapin  |
|                                   | ist standardmäßig nicht in der    |
|                                   | Seitenleiste enthalten. Sie       |
|                                   | können es aber einfach durch      |
|                                   | Anklicken von [![Symbol zum       |
|                                   | Anzeigen aller                    |
|                                   | Snapin                            |
|                                   | s.](../images/icons/button_sideba |
|                                   | r_add_snapin.png)]{.image-inline} |
|                                   | aus der Liste der verfügbaren     |
|                                   | Snapins in die Seitenleiste       |
|                                   | aufnehmen.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::
:::::::::::

::::::::::::: sect1
## []{#dashboards .hidden-anchor .sr-only}4. Dashboards {#heading_dashboards}

:::::::::::: sectionbody
::: paragraph
Ein Dashboard bereitet auf einer Seite die wichtigsten Informationen zu
einem Thema auf, etwa die Antwort auf die Frage \"Wie ist der Zustand
meiner Checkmk-Instanz?\". Dabei werden in einem Dashboard verschiedene
Visualisierungen von Daten genutzt und kombiniert, etwa Ansichten,
Verlaufsgraphen, Tabellen, Diagramme und viele andere Elemente. Ziel ist
es, Ihnen die Informationen aus verschiedenen Perspektiven so zu
präsentieren, dass Sie das Wesentliche schnell erfassen können und nicht
von Details abgelenkt werden.
:::

::: paragraph
Checkmk stellt mehrere vorkonfigurierte Dashboards zur Verfügung, die
Sie über das [Monitor]{.guihint}-Menü öffnen können: das
[Main]{.guihint} und das [Checkmk]{.guihint} dashboard.
:::

::::: imageblock
::: content
![Das \'Main\' Dashboard der Checkmk
Raw.](../images/gui_dashboard_main_cre.png)
:::

::: title
Das [Main dashboard]{.guihint} der Checkmk Raw
:::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen haben ein anderes [Main]{.guihint} Dashboard als Checkmk Raw.
Das [Main]{.guihint} Dashboard von Checkmk Raw ist das
[Problem]{.guihint} Dashboard der kommerziellen Editionen.
:::

::: paragraph
Wird eines dieser Dashboards angezeigt, können Sie schnell zu einem
anderen umschalten: in der Menüleiste rechts neben dem
[Help]{.guihint}-Menü finden Sie die Symbole für die verfügbaren
Dashboards. Sie können auch das aktuell angezeigte Dashboard zur
Startseite befördern: im Menü [Dashboard \> Set as start URL]{.guihint}.
:::

::: paragraph
Das Besondere an den Dashboards in Checkmk ist, dass sie sich mit einem
intelligenten Algorithmus automatisch an die Bildschirmdimensionen
anpassen und die Bildschirmgröße optimal ausnutzen.
:::

::: paragraph
Außerdem können Sie die Einzelteile eines Dashboards, die sogenannten
**Dashlets**, nutzen, um bestehende Dashboards anzupassen und neue zu
erstellen. Im [Artikel zu den Dashboards](dashboards.html) erfahren Sie
dazu alle Details.
:::
::::::::::::
:::::::::::::

::::::::::::::::::: sect1
## []{#views .hidden-anchor .sr-only}5. Tabellenansichten {#heading_views}

:::::::::::::::::: sectionbody
::: paragraph
Eine Tabellenansicht (*view*) zeigt Ihnen im Monitoring den aktuellen
Zustand von Hosts, Services oder auch anderen Objekten unter einer
bestimmten Perspektive als vordefinierte Tabelle an.
:::

::: paragraph
So eine Tabellenansicht (oder kurz Ansicht) kann einen Kontext haben,
z.B. wenn sie alle Services des Hosts `localhost` zeigt. Andere
Ansichten funktionieren global, z.B. diejenige, die Ihnen alle Services
anzeigt, die gerade ein Problem haben.
:::

::: paragraph
All die **globalen** Ansichten können Sie aus dem
[Monitor]{.guihint}-Menü öffnen, unterhalb des jeweiligen Themas, z.B.
[All hosts]{.guihint}, [Service problems]{.guihint} oder [Host & service
events.]{.guihint} Nach Anklicken eines dieser Menüeinträge wird Ihnen
die zugehörige Statusansicht in der Hauptseite angezeigt, im folgenden
Beispiel [Service problems]{.guihint}:
:::

:::: imageblock
::: content
![Tabellenansicht \'Service
problems\'.](../images/gui_view_service_problems.png)
:::
::::

::: paragraph
In einer Tabellenansicht haben Sie zahlreiche Bedienmöglichkeiten, unter
anderem:
:::

::: ulist
- Sie können zu anderen Ansichten navigieren, indem Sie bestimmte Zellen
  anklicken (im obigen Beispiel etwa den Host-Namen oder einen der
  Services).

- Durch einen Klick auf einen Spaltentitel können Sie nach dieser Spalte
  sortieren.

- Das Menü [Display \> Modify display options]{.guihint} blendet einige
  Einstellungen ein zur Anpassung der Ansicht: Mit [Entries per
  row]{.guihint} können auswählen, in wie vielen Tabellen die Objekte in
  der Ansicht nebeneinander angezeigt werden (z.B. um Ihren breiten
  Bildschirm voll auszunutzen). Im obigen Beispiel steht der Wert auf
  `1`. Mit [Refresh interval]{.guihint} stellen Sie die Anzahl an
  Sekunden ein, nach denen die Ansicht automatisch neu geladen wird
  (schließlich können sich Statusdaten jederzeit ändern).

- Sie können die Tabelleneinträge nach Anklicken von [Filter]{.guihint}
  mit der **Filterleiste** reduzieren --- was im gezeigten Beispiel
  nicht wirklich notwendig, aber bei langen Tabellen sehr hilfreich ist.
:::

::: paragraph
Wir werden die Filterleiste an einem sehr einfachen Beispiel vorstellen
und aus der Gesamtheit aller Services die herausfiltern, in deren Name
`cpu` vorkommt: Klicken Sie im [Overview](#overview) auf die Gesamtzahl
der Services. Auf der Hauptseite werden dann in der Ansicht [All
services]{.guihint} alle Services eingeblendet. Klicken Sie in der
Aktionsleiste auf [Filter]{.guihint}. Die Filterleiste wird am rechten
Rand der Hauptseite eingeblendet. Im Eingabefeld [Service]{.guihint}
geben Sie `cpu` ein und klicken Sie auf [Apply filters]{.guihint}:
:::

::::: imageblock
::: content
![Tabellenansicht mit geöffneter
Filterleiste.](../images/intro_view_service_filter.png)
:::

::: title
Mit angewendetem Filter haben wir die Services auf zwei reduziert
:::
:::::

::: paragraph
Die Filterleiste ist eine sehr mächtige Möglichkeit, um
Tabellenansichten an Ihre Interessen anzupassen. Die Filterkriterien
sind stets kontext-spezifisch und passen daher zum Inhalt der aktuell
angezeigten Ansicht. Im obigen Beispiel sind nur einige der zum Filtern
der Services verfügbaren Kriterien zu sehen. Wenn Ihnen die
Standardauswahl nicht ausreicht, können Sie sich mit [Add
filter]{.guihint} noch mehr Kriterien einblenden lassen und der
Filterleiste hinzufügen.
:::

::: paragraph
Die Filterleiste wird auch genutzt für die Sucheinträge im
[Monitor]{.guihint}-Menü, z.B. [Host search]{.guihint} oder [Service
search]{.guihint}. Wenn Sie einen dieser Sucheinträge auswählen, wird
eine leere Tabellenansicht mit geöffneter Filterleiste angezeigt, in der
Sie mit den Filterkriterien suchen können.
:::

::: paragraph
Wenn Sie den Filter so zugeschnitten haben, dass er genau das anzeigt,
was Sie interessiert, können Sie diese angepasste Ansicht als
Lesezeichen speichern --- womit wir beim nächsten Thema wären: den
Bookmarks.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Tabellenansichten haben noch  |
|                                   | viele weitere                     |
|                                   | Möglichkeiten --- zur Anpassung   |
|                                   | und zur Erstellung eigener        |
|                                   | Ansichten. Wie das geht, erfahren |
|                                   | Sie im [Artikel über              |
|                                   | Ansichten](views.html).           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::::::::
:::::::::::::::::::

::::::::::::::: sect1
## []{#bookmarks .hidden-anchor .sr-only}6. Bookmarks {#heading_bookmarks}

:::::::::::::: sectionbody
::: paragraph
Für Seiten, die Sie immer wieder aufsuchen, können Sie in der
Seitenleiste mit dem Snapin [Bookmarks]{.guihint} Lesezeichen anlegen.
:::

::: paragraph
Braucht man die wirklich? Immerhin gibt es ja auch Lesezeichen im
Webbrowser. Nun, die Checkmk-Lesezeichen haben ein paar Vorteile:
:::

::: ulist
- Ein aufgerufenes Lesezeichen ändert nur den Inhalt auf der Hauptseite,
  ohne die Seitenleiste neu zu laden.

- Sie können Lesezeichen mit anderen Benutzern teilen.

- Beim Setzen von Lesezeichen wird automatisch das Wiederausführen von
  Aktionen verhindert.
:::

::: paragraph
Am Anfang ist das Snapin [Bookmarks]{.guihint} noch leer:
:::

:::: imageblock
::: content
![Snapin Bookmarks noch ohne
Lesezeichen.](../images/gui_empty_bookmarks.png){width="50%"}
:::
::::

::: paragraph
Wenn Sie nun auf [Add bookmark]{.guihint} klicken, wird für den Inhalt,
der gerade auf der Hauptseite angezeigt wird, ein neues Lesezeichen
erzeugt:
:::

:::: imageblock
::: content
![Snapin Bookmarks mit einem
Lesezeichen.](../images/gui_bookmarks.png){width="50%"}
:::
::::

::: paragraph
Ihre persönlichen Lesezeichen werden unter [My Bookmarks]{.guihint}
gespeichert.
:::

::: paragraph
Wenn Sie tiefer in das Thema einsteigen wollen, um z.B. eine
Lesezeichenliste für andere Benutzer freizugeben, können Sie das im
[Artikel über die
Benutzeroberfläche](user_interface.html#bookmarks_edit) tun.
:::
::::::::::::::
:::::::::::::::

::::::::: sect1
## []{#master_control .hidden-anchor .sr-only}7. Master control {#heading_master_control}

:::::::: sectionbody
::: paragraph
Im Snapin [Master control]{.guihint} der Seitenleiste können Sie
verschiedene Funktionen des Monitorings einzeln aus- und wieder
einschalten, wie z.B. die Benachrichtigungen
([Notifications]{.guihint}). Letzteres ist sehr nützlich, wenn Sie am
System größere Umbauarbeiten vornehmen und Ihre Kolleginnen nicht mit
sinnlosen Meldungen ärgern möchten.
:::

::::: imageblock
::: content
![Snapin Master control von Checkmk
Raw.](../images/gui_master_control.png){width="50%"}
:::

::: title
Das Snapin [Master control]{.guihint} von Checkmk Raw
:::
:::::

::: paragraph
**Wichtig:** Achten Sie darauf, dass im Normalbetrieb alle Schalter
eingeschaltet sind, da sonst wichtige Funktionen des Monitorings
ausgeschaltet sein können.
:::
::::::::
:::::::::

:::::::::::::::::: sect1
## []{#metrics .hidden-anchor .sr-only}8. Metriken {#heading_metrics}

::::::::::::::::: sectionbody
::: paragraph
Die große Mehrheit der Services liefert nicht nur einen Zustand, sondern
zusätzlich auch [Metriken.](glossar.html#metric) Nehmen wir als Beispiel
den Service, der auf einem Windows-Server das Dateisystem `C:` prüft:
:::

:::: imageblock
::: content
![Listeneintrag eines Services für ein
Windows-Server-Dateisystem.](../images/intro_filesystem_c.png)
:::
::::

::: paragraph
Neben dem Status [OK]{.state0} sehen wir, dass ca. 65 von insgesamt
200 Gibibytes des Dateisystems belegt sind, was ca. 32 % ausmacht. Die
Angaben sehen Sie in der Spalte [Summary]{.guihint}. Der wichtigste Wert
davon --- die Prozentangabe --- wird außerdem auf der rechten Seite in
der Spalte [Perf-O-Meter]{.guihint} visualisiert.
:::

::: paragraph
Das ist aber nur eine grobe Übersicht. Eine detaillierte Tabelle aller
Messwerte eines Services finden Sie, nachdem Sie den Service angeklickt
haben, in dessen Detailansicht in der Zeile [Service Metrics]{.guihint}:
:::

:::: imageblock
::: content
![Service-Details mit der Tabelle aller
Metriken.](../images/intro_service_metrics.png)
:::
::::

::: paragraph
Noch interessanter ist aber, dass Checkmk automatisch den Zeitverlauf
aller solcher Metriken standardmäßig für bis zu vier Jahren aufbewahrt
(in den sogenannten [RRD-Dateien](graphing.html#rrds)). Innerhalb der
ersten 48 Stunden werden die Werte minutengenau gespeichert. Dargestellt
werden die Zeitverläufe in Graphen wie diesem für den Service
[Check_MK]{.guihint}:
:::

:::: imageblock
::: content
![Service-Details mit einem Zeitreihen-Graph für
Metriken.](../images/example_graph.png)
:::
::::

::: paragraph
Hier ein paar Tipps, was Sie mit diesen Graphen anstellen können:
:::

::: ulist
- Zeigen Sie mit der Maus in den Graphen und ein Tooltipp zeigt die
  genauen Messwerte für den aktuellen Zeitpunkt.

- Mit dem Mausrad können Sie in die Zeitachse zoomen.

- Drücken Sie mit der linken Maustaste in eine beliebige Stelle des
  Graphen und ziehen Sie nach links oder rechts um das angezeigte
  Zeitintervall zu verändern.

- Ziehen Sie mit gedrückter linker Maustaste nach oben oder unten, um in
  die vertikale Achse zu zoomen.

- Mit dem Symbol [![Symbol zur Größenänderung eines
  Graphen.](../images/icons/resize_graph.png)]{.image-inline} in der
  Ecke rechts unten können Sie den Graphen in seiner Größe ändern.
:::

::: paragraph
Das System für die Aufzeichnung, Auswertung und Darstellung von Metriken
in Checkmk kann noch viel mehr. Details dazu finden Sie im [Artikel über
Metriken.](graphing.html)
:::

::: paragraph
[Weiter geht es mit Checkmk im Monitoring](intro_monitor.html)
:::
:::::::::::::::::
::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
