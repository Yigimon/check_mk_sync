:::: {#header}
# Dashboards

::: details
[Last modified on 13-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/dashboards.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Ansichten von Hosts und Services](views.html) [Messwerte und
Graphing](graphing.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_was_genau_sind_dashboards .hidden-anchor .sr-only}1.1. Was genau sind Dashboards? {#heading__was_genau_sind_dashboards}

::: paragraph
Dashboards sind in Checkmk die zentralen Ansichten für Ihr Monitoring.
Sie liefern Ihnen sowohl Übersichten als auch detaillierte Einsichten in
bestimmte Bereiche. Sie können etwa den allgemeinen Status ganzer
Netzwerksegmente visualisieren, aber auch schlicht auflisten, welche
Services just für eine Aus- oder Überlastung bestimmter Systemressourcen
sorgen. Checkmk bringt einige Standard-Dashboards mit sich, so für
Probleme, Checkmk-Server-Statistiken und natürlich einen
Gesamtüberblick. Sie dürfen aber völlig individuelle Dashboards von
Grund auf selbst gestalten.
:::

::: paragraph
Welche Werkzeuge dafür zur Verfügung stehen und wie genau Sie damit
eigene Übersichten aufbauen, lesen Sie in diesem Artikel. Zunächst
zeigen wir Ihnen, wie [Dashboards](#features) funktionieren und wie Sie
damit arbeiten. Anschließend beleuchten wir die Grundlagen für [Layout
und Konfiguration](#dashboard_layout_config), um darauf aufbauend ein
komplettes, einfaches [Beispiel-Dashboard](#example) Schritt für Schritt
zu kreieren. Dann folgt eine kurze Zusammenfassung zum Thema
[Filter](#filter), da diese an mehreren Stellen gesetzt werden können.
Weiter geht es mit der Vorstellung aller bereits eingebauten [Dashboards
und Dashlets](#builtins) --- den einzelnen Bausteinen für Übersichten.
Den Abschluss bilden Tipps zum Umgang mit Fehlern und Problemen.
:::

::: paragraph
Das auffälligste Dashboard sehen Sie übrigens direkt auf der Startseite
von Checkmk, allerdings können Dashboards wie sonstige Ansichten
behandelt und ganz einfach über die
[Navigationsleiste](user_interface.html#navigation_bar) und die
[Seitenleiste](user_interface.html#sidebar) aufgerufen werden. Und
natürlich eignen sich Dashboards bestens, um sie separat auf einzelne
Monitore zu legen, sei es für einen großen Leitstand, als Info-Display
für Serverräume oder als schlichtes Kiosk-Display für den Konferenzsaal.
:::
::::::

:::::: sect2
### []{#features .hidden-anchor .sr-only}1.2. Das können Dashboards {#heading_features}

::: paragraph
Das Besondere an Checkmk-Dashboards ist, dass sie sich über einen
intelligenten Algorithmus automatisch an die Dimensionen des Displays
beziehungsweise des Browserfensters anpassen. Dabei können Sie für alle
einzelnen Elemente des Dashboards, die Dashlets, festlegen, wie genau
sie sich verhalten, und in welche Richtungen sie sich bei Bedarf
ausdehnen.
:::

::: paragraph
Für den Inhalt stehen Dashlets unterschiedlicher Kategorien zur
Verfügung: Reguläre Ansichten, Graphen, Metriken, vorgefertigte Elemente
für diverse Statistiken und Zeitleisten sowie Kästen für statische Texte
und beliebige URLs. Eine Übersicht aller Dashlets finden Sie weiter
unten. Einige der Dashlets gibt es exklusiv in den kommerziellen
Editionen.
:::

::: paragraph
Ein wichtiges Feature bei der Dashboard*-Nutzung:* Über Filter können
selbst Dashboards, die Werte für alle Hosts oder Services im Netzwerk
anzeigen, auf bestimmte Bereiche heruntergebrochen werden. Dashboards
sind also nicht bloß starre Anzeigen, sondern echte Werkzeuge zum
Auffinden und Analysieren von Problemen und Zuständen.
:::
::::::

:::::::::::::::::: sect2
### []{#usage .hidden-anchor .sr-only}1.3. Dashboards im Einsatz {#heading_usage}

:::::::::::: sect3
#### []{#_main_dashboard_interpretieren .hidden-anchor .sr-only}Main-Dashboard interpretieren {#heading__main_dashboard_interpretieren}

::: paragraph
Auf der Startseite von Checkmk sehen Sie das [Main-Dashboard,]{.guihint}
das Sie im [Monitor]{.guihint}-Menü und auch im
[Snapin](glossar.html#snapin) [Views]{.guihint} jeweils unter [Overview
\> Main dashboard]{.guihint} finden.
:::

::: paragraph
Checkmk Raw und kommerzielle Editionen kommen mit unterschiedlichen
Standard-Dashboards, hier zunächst ein Blick auf die Variante der
kommerziellen Editionen:
:::

:::: imageblock
::: content
![Das Standard-Dashboard der kommerziellen Editionen mit Nummern für die
detaillierte Beschreibung.](../images/dashboard_main_numbered.png)
:::
::::

+----+--------------------------------+--------------------------------+
| N  | Titel                          | Funktion                       |
| r. |                                |                                |
+====+================================+================================+
| 1  | Filter-Knopf                   | Filter aufrufen                |
+----+--------------------------------+--------------------------------+
| 2  | Layout-Knopf                   | Layout-Modus ein-/ausschalten  |
+----+--------------------------------+--------------------------------+
| 3  | Host statistics                | Aktueller Zustand der Hosts    |
+----+--------------------------------+--------------------------------+
| 4  | Total host problems            | Zeitleiste der Host-Probleme   |
+----+--------------------------------+--------------------------------+
| 5  | Service statistics             | Aktueller Zustand der Services |
+----+--------------------------------+--------------------------------+
| 6  | Total service problems         | Zeitleiste der                 |
|    |                                | Service-Probleme               |
+----+--------------------------------+--------------------------------+
| 7  | Problem notifications          | Zeitleiste der Alarmierungen   |
+----+--------------------------------+--------------------------------+
| 8  | Percentage of total service    | Zeitleiste aktiver Services    |
|    | problems                       |                                |
+----+--------------------------------+--------------------------------+
| 9  | Host overview                  | Per Mausrad zoombare           |
|    |                                | Visualisierung von Problemen   |
|    |                                | auf Hosts                      |
+----+--------------------------------+--------------------------------+
| 10 | Top alerters (last 7 days)     | Für Alarmierungen              |
|    |                                | verantwortliche Services       |
+----+--------------------------------+--------------------------------+
| 11 | Filter                         | Filter zur Beschränkung des    |
|    |                                | Dashboards auf einzelne        |
|    |                                | Hosts/Services                 |
+----+--------------------------------+--------------------------------+

::: paragraph
**Hinweis** zum [![icon dashboard
edit](../images/icons/icon_dashboard_edit.png)]{.image-inline}
Layout-Knopf: Bei den [eingebauten Dashboards](#builtin_dashboards)
sehen Sie diesen Knopf standardmäßig zunächst nicht! Er taucht erst, und
dann dauerhaft, auf, wenn Sie einmal den Menüeintrag [Dashboard \>
Customize builtin dashboard]{.guihint} aufrufen. Verstehen Sie dies
einfach als kleine *Schutzmaßnahme,* denn es ist ratsam, [eingebaute
Dashboards zu klonen](#builtin_dashboards) [![icon
clone](../images/icons/icon_clone.png)]{.image-inline} und dann die
Klone anzupassen.
:::

::: paragraph
Wenn Sie mit dem Mauszeiger über die Graphen oder die Host-Symbole im
Dashlet [Host overview]{.guihint} fahren, bekommen Sie sofort weitere
Detailinformationen via Tooltipp. Die Farben entsprechen jeweils der
Darstellung der Dashlets zu aktuellen Host- und Service-Statistiken.
Über die verlinkten Titelzeilen der Dashlets gelangen Sie zu
ausführlicheren Darstellungen.
:::

::: paragraph
Bei
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** ist das Haupt-Dashboard auf der Startseite hingegen das
[Problem Dashboard]{.guihint}, welches auch in den kommerziellen
Editionen über [![icon dashboard
problems](../images/icons/icon_dashboard_problems.png)]{.image-inline}
aufrufbar ist und ganz klassisch unerledigte Probleme und aktuelle
Events in Listenform zeigt:
:::

:::: imageblock
::: content
![Das Checkmk Raw Standard-Dashboard mit Nummern für die detaillierte
Beschreibung.](../images/dashboard_main_numbered_raw.png)
:::
::::

+----+--------------------------------+--------------------------------+
| N  | Titel                          | Funktion                       |
| r. |                                |                                |
+====+================================+================================+
| 1  | Filter-Knopf                   | Filter aufrufen                |
+----+--------------------------------+--------------------------------+
| 2  | Layout-Knopf                   | Layout-Modus ein-/ausschalten  |
+----+--------------------------------+--------------------------------+
| 3  | Host statistics                | Aktueller Zustand der Hosts    |
+----+--------------------------------+--------------------------------+
| 4  | Service statistics             | Aktueller Zustand der Services |
+----+--------------------------------+--------------------------------+
| 5  | Host Problems                  | Liste unbehandelter            |
|    |                                | Host-Probleme                  |
+----+--------------------------------+--------------------------------+
| 6  | Service Problems               | Liste unbehandelter            |
|    |                                | Service-Probleme               |
+----+--------------------------------+--------------------------------+
| 7  | Events of recent 4 hours       | Ereignisse der letzten vier    |
|    |                                | Stunden                        |
+----+--------------------------------+--------------------------------+
| 8  | Filter                         | Filter zur Beschränkung des    |
|    |                                | Dashboards auf einzelne        |
|    |                                | Hosts/Services                 |
+----+--------------------------------+--------------------------------+
::::::::::::

::::::: sect3
#### []{#dashboard_filter .hidden-anchor .sr-only}Dashboards filtern {#heading_dashboard_filter}

::: paragraph
Wie Sie später sehen werden, lassen sich Dashboards natürlich von
vornherein für eine bestimmte Auswahl von Hosts oder Services erstellen.
Über Filter können Sie aber jedes Dashboard temporär auf eine Auswahl
beschränken:
:::

::: {.olist .arabic}
1.  Filterfunktion über [![Symbol zur Anzeige der
    Filterleiste.](../images/icons/icon_filter.png)]{.image-inline}
    aufrufen.

2.  Filter über [Add filter]{.guihint} hinzufügen --- beispielsweise
    [Hostname]{.guihint}.

3.  Filter konfigurieren --- beispielsweise `myhost`.
:::

::: paragraph
Der dritte Schritt ist von Filter zu Filter unterschiedlich, wichtig ist
hier vor allem die Handhabung eingegebener Suchbegriffe, also
beispielsweise für Host-Namen: Wie üblich wertet Checkmk diese als
[reguläre Ausdrücke](regexes.html). Ein Filter nach `myhost` würde daher
sowohl den Host `myhost` finden als auch `2myhost` und `myhost2`. Wenn
Sie nur `myhost` im Dashboard sehen wollen, müssen Sie als Suchbegriff
entsprechend `^myhost$` verwenden, um Anfang und Ende der Zeile
einzubeziehen und so einen exakten Match zu provozieren.
:::

::: paragraph
Natürlich lassen sich auch mehrere Filter miteinander kombinieren, die
die Treffermenge dann per *UND-Verknüpfung* reduzieren. Innerhalb eines
Filters dürfen Sie *ODER-Verknüpfungen* mit den Mitteln der regulären
Ausdrücke verwenden, also beispielsweise `myhost1|db_server`.
:::
:::::::
::::::::::::::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#dashboard_layout_config .hidden-anchor .sr-only}2. Layout, Konfiguration, Rechte {#heading_dashboard_layout_config}

::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Dashboard-Einstellungen gliedern sich in zwei Teile: Über das Layout
bestimmen Sie die Anordnung der Dashlets, deren Dimensionen und
dynamische Skalierung. Die Konfiguration bezieht sich auf die
Eigenschaften des Dashboards an sich, vor allem aber auf die einzelnen
Dashlets, also welche Inhalte sie wie aufbereitet zeigen.
:::

::::::::::::::::::: sect2
### []{#layout .hidden-anchor .sr-only}2.1. Layout {#heading_layout}

::: paragraph
Das Besondere am Dashboard-Layout ist die Dynamik: Dashlets können zwar
mit fixer Höhe und Breite angelegt werden, sie können aber auch
automatisch in beiden Dimensionen wachsen, um den vorhandenen Platz bei
jeder Skalierung optimal auszunutzen --- ähnlich wie beim
Responsive-Webdesign, aber detaillierter zu konfigurieren.
:::

::: paragraph
Das Prinzip ist simpel: Eine beliebige Ecke eines Dashlets wird als
Anker festgelegt. Von diesem Fixpunkt aus kann das Dashlet dann in Höhe
und/oder Breite wachsen, sobald mehr Platz zur Verfügung steht, also zum
Beispiel schlicht auf einem größeren Bildschirm, aber auch, wenn sich
die Position oder Größe anderer Dashlets verändert.
:::

:::::::::::::::: sect3
#### []{#_dynamisches_layout_in_aktion .hidden-anchor .sr-only}Dynamisches Layout in Aktion {#heading__dynamisches_layout_in_aktion}

::: paragraph
Zur Verdeutlichung des Prinzips hier ein Beispiel mit einem
Host-Matrix-Dashlet mit manueller Höhe und Breite in der Mitte sowie dem
Anker oben links. Den Anker erkennen Sie an der grünen Ecke, die
Einstellungen für aktuelle Höhe und Breite finden Sie in der Mitte der
Dashlets.
:::

::: paragraph
Umrahmt wird es von vier Host-Overview-Dashlets (beziehungsweise
[Site-Overview-Dashlets](#dashlet_siteoverview)), allesamt mit
automatischer Höhe, die seitlichen auch mit automatischer Breite --- die
Dashlets oben und unten bekommen die Einstellung [max width]{.guihint}.
Standardmäßig sitzt der Anker oben links, hier bekommt jedoch das rechte
Dashlet den Anker oben rechts und das untere unten links.
:::

:::: imageblock
::: content
![Ein Host-Matrix-Dashlet in der
Dashboard-Mitte.](../images/dashboard_layout_example_1.png)
:::
::::

::: paragraph
Wenn man nun das Host-Matrix-Dashlet zum Beispiel weiter nach links und
unten verschiebt, verändern sich die Host-Overview---​Dashlets links,
rechts und unten --- denn sie wachsen automatisch von ihren Ankern hin
zum zentralen Host-Matrix-Dashlet.
:::

::: paragraph
Das obere Dashlet hingegen bleibt wie es ist --- nach unten kann es
schließlich nicht wachsen, da die beiden seitlichen Dashlets oben
verankert sind.
:::

:::: imageblock
::: content
![Das Host-Matrix-Dashlet, verschoben nach unten
links.](../images/dashboard_layout_example_2.png)
:::
::::

::: paragraph
Schaltet man nun das untere Dashlet von [max width]{.guihint} auf [auto
width]{.guihint} geht es nicht mehr über die gesamte Breite --- weil die
automatische Höhe des rechten Dashlets vor der automatischen Breite des
unteren Dashlets gerendert wird.
:::

:::: imageblock
::: content
![Das unterste Dashlet mit verkürzter
Breite.](../images/dashboard_layout_example_3.png)
:::
::::

::: paragraph
Wenn Dashlets mit automatischen Dimensionen um denselben Raum streiten,
können Sie mit der Maximal-Einstellung quasi den Gewinner
festlegen --- aber Vorsicht: Konkurrieren zwei auf Maximum gesetzte
Dashlets um denselben Raum, kann es zu Überlappungen kommen.
:::

::: paragraph
Einfacher zu verstehen ist das ganze dynamische Layout-Prinzip, wenn Sie
sich solch einen Testaufbau selbst anlegen und die Dashlets ein wenig
herumschubsen.
:::
::::::::::::::::
:::::::::::::::::::

::::::::: sect2
### []{#config_dashboard .hidden-anchor .sr-only}2.2. Konfiguration: Dashboard {#heading_config_dashboard}

::: paragraph
Die Dashboard-Konfiguration sehen Sie automatisch beim Anlegen eines
neuen Dashboards, später erreichen Sie sie über die Icons in der
Dashboard-Liste ([Customize \> Dashboards]{.guihint}) oder den
Menüeintrag [Dashboard\>Properties]{.guihint} eines geöffneten
Dashboards.
:::

:::: imageblock
::: content
![Das Menü \'Dashboard\' mit ausgewähltem Eintrag
\'Properties\'.](../images/dashboard_config_dashboard.png){width="60%"}
:::
::::

::: paragraph
Die Eigenschaften des Dashboards an sich sind trivial, hier werden
lediglich Metadaten wie Name, Menüeintrag oder Sichtbarkeit gesetzt,
zudem bei Bedarf Kontextfilter. Kontextfilter beschränken Dashboards und
Dashlets schlicht auf bestimmte Hosts und/oder Services.
:::

:::: imageblock
::: content
![Allgemeine Eigenschaften des
Dashboards.](../images/dashboard_config_example_dashboard.png)
:::
::::
:::::::::

::::::::: sect2
### []{#config_layout .hidden-anchor .sr-only}2.3. Konfiguration: Dashlets {#heading_config_layout}

::: paragraph
Die Konfiguration einzelner Dashlets sehen Sie automatisch beim
Hinzufügen zu einem Dashboard; später rufen Sie sie direkt über das
Zahnrad-Icon der Dashlets im Layout-Modus auf.
:::

:::: imageblock
::: content
![Das Symbol zum Aufruf der Eigenschaften eines
Dashlets.](../images/dashboard_config_dashlet.png){width="60%"}
:::
::::

::: paragraph
Die Konfiguration der meisten Dashlets ist recht simpel, wie etwa das
Dashlet mit der Host-Matrix aus den obigen Screenshots zeigt: Dabei
handelt es sich nämlich eigentlich um ein Dashlet vom Typ [Sidebar
element]{.guihint} und die ganze Konfiguration beschränkt sich auf die
Auswahl eben dieses Seitenleistenelements. Bei allen Dashlets, die sich
auf einige oder einzelne Hosts und Services beziehen, finden Sie zudem
entsprechende Filtermöglichkeiten. Und letztlich bieten einige Dashlets
noch Optionen zur genauen Gestaltung der Visualisierung, beispielsweise
über Grenzwerte. Als Beispiel hier der [Properties]{.guihint}-Kasten des
[Gauge]{.guihint}-Dashlets:
:::

:::: imageblock
::: content
![Eigenschaften des Dashlets
\'Gauge\'.](../images/dashboard_config_example_dashlet.png)
:::
::::
:::::::::

:::::: sect2
### []{#permissions .hidden-anchor .sr-only}2.4. Rechte {#heading_permissions}

::: paragraph
Auch abseits der Dashboard- und Dashlet-Konfiguration gibt es in Checkmk
wichtige Einstellungen, nämlich die Rechte. Unter [Setup \> Users \>
Roles & permissions \> Edit role user]{.guihint} können Sie einfach nach
*dashboard* filtern, um alle Optionen aufzulisten. Hier lässt sich für
eine [Rolle](wato_user.html#roles) detailliert festlegen, welche
Standard-Dashboards deren zugewiesene Nutzer sehen und was genau sie mit
sonstigen Dashboards anfangen dürfen.
:::

:::: imageblock
::: content
![Benutzerrolle mit den Berechtigungen für
Dashboards.](../images/dashboard_config_permissions.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#example .hidden-anchor .sr-only}3. Beispiel-Dashboard {#heading_example}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Beispiel-Projekt führt Sie einmal durch die notwendigen Schritte, um
ein Dashboard von Grund auf aufzusetzen. Dabei werden Sie grundsätzlich
alle Möglichkeiten exemplarisch zu Gesicht bekommen. Um das Beispiel
komplett nachzubauen, benötigen Sie eine der kommerziellen Editionen.
Dazu dienen vier Dashlets:
:::

::: paragraph
Das [Performance graph]{.guihint}-Dashlet zeigt die Nutzung eines
Dateisystems eines Hosts, [Gauge]{.guihint} die durchschnittliche
CPU-Auslastung der letzten Minute, die [Alert timeline]{.guihint}
visualisiert Alarmierungen für eine Auswahl von Hosts und Services über
einer Zeitleiste und die in den kommerziellen Editionen bereits
existierende Ansicht [Scheduled downtimes]{.guihint} listet geplante
Wartungszeiten.
:::

::: paragraph
Und so wird das fertige Dashboard aussehen:
:::

:::: imageblock
::: content
![Das im Folgenden erstellte
Beispiel-Dashboard.](../images/dashboard_example_view.png)
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#example_build .hidden-anchor .sr-only}3.1. Beispiel-Dashboard aufsetzen {#heading_example_build}

::::::::::::::: sect3
#### []{#_1_dashboard_anlegen .hidden-anchor .sr-only}1. Dashboard anlegen {#heading__1_dashboard_anlegen}

::: paragraph
Legen Sie zunächst ein Dashboard über [Customize \> Dashboards \> Add
dashboard]{.guihint} an. Sie gelangen umgehend zu einer ersten
grundsätzlichen Einstellung:
:::

:::: imageblock
::: content
![Auswahl der Objekttypen für das
Dashboard.](../images/dashboard_example_1.png)
:::
::::

::: paragraph
Über [Select specific object type]{.guihint} können Sie das Dashboard
von vornherein auf bestimmte Hosts, Services und sogar einzelne Objekte
wie Docker-Images oder Lüfter beschränken. Für das Beispiel belassen Sie
es bei der Vorgabe [No restrictions to specific objects]{.guihint},
filtern können Sie zudem auch später noch.
:::

::: paragraph
Anschließend landen Sie mit [Continue]{.guihint} in den Eigenschaften
des zu erstellenden Dashboards.
:::

:::: imageblock
::: content
![Allgemeine Eigenschaften des Dashboards mit der notwendigen Eingabe zu
ID und Titel.](../images/dashboard_example_2.png)
:::
::::

::: paragraph
Verlangt werden hier lediglich Name und Titel für das Dashboard im
Kasten [General Properties]{.guihint}, hier `my_dashboard` und
`My Dashboard`. Interessant sind hier zudem die Optionen zur
Sichtbarkeit, insbesondere der Punkt [Topic in \'Monitor\'
menu]{.guihint}. Darüber bestimmen Sie, unter welchen Thema das
Dashboard später im Monitor-Menü der Navigationsleiste sowie in den
Seitenleistenelementen [Views]{.guihint} und [Dashboards]{.guihint}
aufgelistet wird.
:::

::: paragraph
Wichtig sind aber auch die Kontextfilter, die hier gleich zwei mal
auftauchen: Im Kasten [Context / Search Filters]{.guihint} können Sie
einen Standardfilter für das Dashboard setzen, so dass bei dessen Aufruf
umgehend bestimmte Hosts und/oder Services auftauchen.
:::

::: paragraph
Im Kasten [Dashboard Properties]{.guihint} lassen sich über [Required
context filters]{.guihint} hingegen benötigte, aber **leere** Filter
setzen: Wenn Sie hier beispielsweise den Filter [Host:
Hostname]{.guihint} setzen, startet das Dashboard mit eben diesem
Filter --- und der Nutzer muss dann entsprechend selbst angeben, auf
welchen Host-Namen gefiltert werden soll. Auf diese Weise können Sie
Nutzer mit dynamischen Dashboards versorgen und direkt darauf stoßen,
dass sie noch für den benötigten Kontext sorgen müssen.
:::

::: paragraph
Für das Beispiel-Dashboard lassen Sie die Filter einfach komplett
leer --- die Filterung erfolgt über die einzelnen Dashlets. Bestätigen
Sie mit [Save & go to dashboard]{.guihint}. Daraufhin wird das leere
Dashboard angezeigt und Sie können fortan über den [![icon dashboard
edit](../images/icons/icon_dashboard_edit.png)]{.image-inline}
Layout-Knopf zwischen Ansichts- und Layout-Modus hin und her schalten.
Sie erreichen das neue Dashboard jederzeit über den Eintrag im
Monitor-Menü.
:::

::: paragraph
Übrigens: Sie müssen Dashboards nie manuell speichern, jede Änderung
bleibt automatisch erhalten --- auch wenn Sie ein Dashboard verlassen.
:::
:::::::::::::::

::::::::::::::: sect3
#### []{#_2_dashlet_performance_graph_hinzufügen .hidden-anchor .sr-only}2. Dashlet Performance Graph hinzufügen {#heading__2_dashlet_performance_graph_hinzufügen}

::: paragraph
Fügen Sie nun auf dem leeren Dashboard das Dashlet über [Add \>
Performance graph]{.guihint} hinzu. Unter [General Settings]{.guihint}
sollten Sie einen sprechenden Titel vergeben, ansonsten werden
Dashboards mit vielen Dashlets schnell unübersichtlich --- vor allem,
wenn sie nicht von vornherein auf bestimmte Elemente gefiltert werden.
Da hier das Root-Dateisystem vom Host `myhost` visualisiert werden soll,
bietet sich `My Host - Filesystem/` an. Komfortabler geht das wie in
vielen Eingabefeldern in Checkmk über Makros:
`$HOST_NAME$: $SERVICE_DESCRIPTION$` Welche Makros Sie jeweils nutzen
können, entnehmen Sie den Hilfetexten, die Sie sich mit [Help \> Show
inline help]{.guihint} einblenden können.
:::

:::: imageblock
::: content
![Allgemeine Einstellungen des Dashlets \'Performance
graph\'.](../images/dashboard_example_3.png)
:::
::::

::: paragraph
Im Kasten für die Kontextfilter geben Sie den Host-Namen und das
gewünschte Dateisystem an. In beiden Eingabefeldern können Sie schlicht
den ersten Buchstaben eingeben und dann mit der Pfeil-runter-Taste durch
die möglichen Einträge scrollen.
:::

:::: imageblock
::: content
![Kontextfilter des Dashlets \'Performance
graph\'.](../images/dashboard_example_4.png)
:::
::::

::: paragraph
Im dritten Kasten [Properties]{.guihint} werden die beiden Filter
automatisch für die Einstellung [Graph]{.guihint} übernommen. Sie müssen
lediglich noch den gewünschten Graphen wählen, hier also [Filesystem
size and used space]{.guihint}. Die weiteren Darstellungsoptionen können
Sie unverändert lassen.
:::

:::: imageblock
::: content
![Eigenschaften des Dashlets \'Performance
graph\'.](../images/dashboard_example_5.png)
:::
::::

::: paragraph
Wenn Sie das Dashlet nun speichern, landen Sie im Layout-Modus. Da das
Dashlet über die gesamte Breite laufen soll, klicken Sie auf [manual
width]{.guihint}, um die manuelle Breite auf [auto width]{.guihint}
umzuschalten. Der Anker kann auf seiner Standardposition oben links
verbleiben.
:::

:::: imageblock
::: content
![Das Dashlet \'Performance graph\' im Layout-Modus des
Dashboards.](../images/dashboard_example_6.png)
:::
::::
:::::::::::::::

:::::::::::: sect3
#### []{#_3_dashlet_gauge_hinzufügen .hidden-anchor .sr-only}3. Dashlet Gauge hinzufügen {#heading__3_dashlet_gauge_hinzufügen}

::: paragraph
Das [Gauge]{.guihint}-Dashlet steht nur in den kommerziellen Editionen
zur Verfügung und visualisiert Werte wie die CPU-Auslastung in Anlehnung
an einen Tachometer.
:::

::: paragraph
Die Konfiguration unterscheidet sich kaum von der des eben erzeugten
Graphen, wieder filtern Sie auf `myhost` und jetzt auf den Service
`CPU load`.
:::

::: paragraph
Und wieder werden beide Werte automatisch in den
[Properties]{.guihint}-Kasten übernommen, nun unter [Metric]{.guihint}
(statt wie zuvor unter [Graph]{.guihint}). Als Metrik wählen Sie [CPU
load average of last minute]{.guihint}.
:::

::: paragraph
Allerdings müssen Sie dieses mal noch eine weitere Einstellung setzen,
nämlich das Maximum der Skala unter [Date range]{.guihint}. Hier können
Sie [Floating point number]{.guihint} belassen und das Maximum auf 10
setzen. Ohne diese Angabe landen Sie in einer Fehlermeldung.
:::

:::: imageblock
::: content
![Eigenschaften des Dashlets
\'Gauge\'.](../images/dashboard_example_7.png)
:::
::::

::: paragraph
Nach dem Speichern landen Sie wieder im Layout-Modus und können das
Dashlet unterhalb des Performance-Graphen platzieren (der zunächst vom
neuen Dashlet überlagert wird!); hier bieten sich manuelle Breite und
Höhe an. Die gewünschte Größe bestimmen Sie durch Ziehen mit der Maus an
den Dashlet-Rändern. An dieser Stelle könnten Sie nun auch das
Graphen-Dashlet auf automatische Höhe setzen und die Höhe dann schlicht
durch die Platzierung des neuen Gauge-Dashlets bestimmen lassen.
:::

:::: imageblock
::: content
![Das Dashlet \'Gauge\' im Layout-Modus des
Dashboards.](../images/dashboard_example_8.png)
:::
::::
::::::::::::

::::::::::::: sect3
#### []{#_4_dashlet_alert_timeline_hinzufügen .hidden-anchor .sr-only}4. Dashlet Alert Timeline hinzufügen {#heading__4_dashlet_alert_timeline_hinzufügen}

::: paragraph
Als drittes Dashlet folgt nun die [Alert timeline]{.guihint} zur
Darstellung der Alarmierungen auf einer Zeitachse; ebenfalls exklusiv in
den kommerziellen Editionen zu finden.
:::

::: paragraph
In diesem Dashlet sollen nun Daten mehrerer Hosts und Services
landen --- daher auch oben der Verzicht auf eine Dashboard-weite
Vorabfilterung. Um alle Alarmierungen aller Hosts zu bekommen, die mit
`my` anfangen, setzen Sie den Filter für den Host-Namen auf `^my*`. Bei
diesem Dashlet bietet sich häufig der komplette Verzicht auf Filter an,
um schlicht alle Hosts auszuwerten.
:::

:::: imageblock
::: content
![Kontextfilter des Dashlets \'Alert
timeline\'.](../images/dashboard_example_9a.png)
:::
::::

::: paragraph
Für das Beispiel-Dashlet wird die Darstellung [Bar chart]{.guihint}
beibehalten, der Zeitraum auf [The last 35 days]{.guihint} gesetzt, die
Einheit auf ganze Tage.
:::

:::: imageblock
::: content
![Eigenschaften des Dashlets \'Alert
timeline\'.](../images/dashboard_example_9b.png)
:::
::::

::: paragraph
Nach dem Speichern platzieren Sie das Dashlet wieder auf dem Dashboard,
auch hier bietet sich eine automatische Breite mit manueller Höhe an, um
die Zeile mit dem Gauge-Dashlet zu füllen.
:::

:::: imageblock
::: content
![Das Dashlet \'Alert timeline\' im Layout-Modus des
Dashboards.](../images/dashboard_example_9c.png)
:::
::::
:::::::::::::

::::::::::::::: sect3
#### []{#_5_dashlet_per_ansicht_hinzufügen .hidden-anchor .sr-only}5. Dashlet per Ansicht hinzufügen {#heading__5_dashlet_per_ansicht_hinzufügen}

::: paragraph
Auch bereits existierende [Ansichten](views.html) können als Dashlet
genutzt werden. Das funktioniert etwa über [Add \> Link to existing
view]{.guihint}, aber auch über die Ansichten selbst, wie Sie es hier
sehen.
:::

::: paragraph
Um die Ansicht der geplanten Wartungszeiten einzufügen, rufen Sie diese
zum Beispiel über [Monitor \> Overview \> Scheduled downtimes]{.guihint}
auf. Anschließend fügen Sie die Ansicht Ihrem Dashboard über [Export \>
Add to dashboard]{.guihint} hinzu.
:::

:::: imageblock
::: content
![Das Menü \'Export\' der Tabellenansicht \'Scheduled
downtimes\'.](../images/dashboard_example_10.png){width="55%"}
:::
::::

::: paragraph
Wählen Sie Ihr Dashboard aus.
:::

:::: imageblock
::: content
![Auswahl des Dashboards für die
Ansicht.](../images/dashboard_example_10a.png)
:::
::::

::: paragraph
Platzieren Sie das Dashlet als letzte Zeile --- hier bieten sich nun
automatische Höhe und Breite an, um leere Bereiche zu vermeiden.
:::

::: paragraph
Wenn Sie nun die [![icon dashlet
edit](../images/icons/icon_dashlet_edit.png)]{.image-inline}
Konfiguration des Dashlets aus dem Layout-Modus heraus aufrufen, stehen
Ihnen die aus [Ansichten](views.html) bekannten Einstellungen zur
Verfügung, um das Dashlet beispielsweise ein wenig schlanker zu
gestalten --- ein Klick auf den Dashlet-Titel führt Sie schließlich
sowieso zur vollständigen Ansicht der Wartungszeiten.
:::

::: paragraph
Damit wäre Ihr Beispiel-Dashboard fertig, hier nochmal komplett im
Layout-Modus:
:::

:::: imageblock
::: content
![Das komplette Beispiel-Dashboard im
Layout-Modus.](../images/dashboard_example_11.png)
:::
::::
:::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::: sect1
## []{#filter .hidden-anchor .sr-only}4. Filter {#heading_filter}

::::::::: sectionbody
::: paragraph
Die Filterung von Dashboards und Dashlets ist ein mächtiges Feature,
wurde bislang an recht vielen Stellen erwähnt und soll daher hier
nochmal kurz zusammengefasst werden. Sie haben drei Möglichkeiten dies
zu tun:
:::

::: ulist
- Dashboard-Eigenschaften

  ::: ulist
  - [Context / Search filters]{.guihint}

  - [Required context filters]{.guihint}
  :::

- Dashlet-Eigenschaften: [Context / Search filters]{.guihint}

- Dashboard-Ansicht: [Context / Filter]{.guihint}
:::

::: paragraph
Der Eintrag [Context / Search filters]{.guihint} ist im Grunde an allen
drei Orten identisch, aber: Wenn Sie ein Dashboard in den Eigenschaften
auf einen Host filtern, können Sie in der Dashboard-Ansicht keine
anderen Hosts anschauen, lediglich die vorhandenen Hosts noch weiter
filtern. In den Dashlet-Eigenschaften können Sie aber sehr wohl den
Filter der Dashboard-Eigenschaften übergehen und andere Hosts
einbeziehen!
:::

::: paragraph
Die [Required context filters]{.guihint} sind ebenfalls in den
Dashboard-Eigenschaften zu finden, filtern aber zunächst nichts. Sie
werden lediglich als benötigte Filter gesetzt: Ein Dashboard mit solchen
Vorgaben erscheint in der Dashboard-Ansicht ohne Informationen zu Hosts
und Services, aber mit der geöffneten Filterfunktion und dem Hinweis auf
diesen [Mandatory context]{.guihint}, den der Nutzer gewissermaßen zur
Laufzeit setzen muss.
:::

:::: imageblock
::: content
![Filterleiste mit verpflichtendem Kontext beim Öffnen des
Dashboards.](../images/dashboard_example_mandatory.png){width="60%"}
:::
::::
:::::::::
::::::::::

::::::::::::::: sect1
## []{#builtins .hidden-anchor .sr-only}5. Eingebaute Dashboards und Dashlets {#heading_builtins}

:::::::::::::: sectionbody
:::::: sect2
### []{#builtin_dashboards .hidden-anchor .sr-only}5.1. Eingebaute Dashboards {#heading_builtin_dashboards}

::: paragraph
Eine Liste aller individuell angelegten sowie eingebauten Dashboards
finden Sie über [Customize \> Dashboards]{.guihint}. Für die eigenen
Varianten können Sie über [![icon dashlet
edit](../images/icons/icon_dashlet_edit.png)]{.image-inline} die
Eigenschaften aufrufen und über [![icon dashboard
edit](../images/icons/icon_dashboard_edit.png)]{.image-inline} den
Layout-Modus. Die werksseitig vorgegebenen Dashboards können Sie nicht
direkt aus der Liste heraus bearbeiten, jedoch über [![icon
clone](../images/icons/icon_clone.png)]{.image-inline} klonen und dann
anpassen.
:::

::: paragraph
**Hinweis:** Nicht alle Dashboards sind in allen Editionen von Checkmk
integriert. Die Cloud-Anbieter-spezifischen Dashboards finden Sie nur in
Checkmk Cloud und Checkmk MSP, Checkmk Raw beschränkt sich auf einige
Basis-Dashboards.
:::

::: paragraph
Hier ein Auszug der eingebauten Dashboards:
:::

+---------+--------------------+--------------------------------------+
| Name/ID | M                  | Inhalt                               |
|         | onitor-Menüeintrag |                                      |
+=========+====================+======================================+
| `aws    | Cloud \> AWS EC2   | Übersicht der EC2-Instanzen          |
| _ec2_ov | instances          |                                      |
| erview` |                    |                                      |
+---------+--------------------+--------------------------------------+
| `azur   | Cloud \> Azure VM  | Übersicht für Azure-VMs              |
| e_vm_ov | instances          |                                      |
| erview` |                    |                                      |
+---------+--------------------+--------------------------------------+
| `c      | System \> Checkmk  | Checkmk-Server und -Instanzen        |
| heckmk` | dashboard          |                                      |
+---------+--------------------+--------------------------------------+
| `checkm | \-                 | Systeminformationen eines            |
| k_host` |                    | Checkmk-Servers                      |
+---------+--------------------+--------------------------------------+
| `gcp    | Cloud \> GCP GCE   | Übersicht für GCP-VMs                |
| _gce_ov | instances          |                                      |
| erview` |                    |                                      |
+---------+--------------------+--------------------------------------+
| `kubern | Applications \>    | Übersicht der Cluster, Ressourcen,   |
| etes_ov | Kubernetes         | Nodes etc.                           |
| erview` |                    |                                      |
+---------+--------------------+--------------------------------------+
| `main`  | Overview \> Main   | Gesamtübersicht                      |
|         | dashboard          |                                      |
+---------+--------------------+--------------------------------------+
| `ntop_  | Network statistics | Alerts in [ntopng](ntop.html)        |
| alerts` | \> Alerts          |                                      |
+---------+--------------------+--------------------------------------+
| `pr     | Problems \>        | Probleme und Statistiken aller Hosts |
| oblems` | Problems dashboard | und Services. Das [Problems          |
|         |                    | dashboard]{.guihint} ist in Checkmk  |
|         |                    | Raw das [Main dashboard]{.guihint}.  |
+---------+--------------------+--------------------------------------+
| `si     | Problems \> Host & | Probleme aller Hosts und Services    |
| mple_pr | service problems   |                                      |
| oblems` |                    |                                      |
+---------+--------------------+--------------------------------------+
| `site`  | \-                 | Übersicht einer Instanz              |
+---------+--------------------+--------------------------------------+
::::::

::::::::: sect2
### []{#builtin_dashlets .hidden-anchor .sr-only}5.2. Dashlets {#heading_builtin_dashlets}

::: paragraph
Hier sehen Sie zunächst alle Dashlets in der Übersicht, anschließend
zeigen wir Ihnen noch ein paar Besonderheiten, die im obigen
Beispiel-Dashboard nicht mit abgehandelt wurden.
:::

+---------+--------------------+-------+-----------------------------+
| Ka      | Name               | Ch    | Funktion                    |
| tegorie |                    | eckmk |                             |
|         |                    | Raw   |                             |
+=========+====================+=======+=============================+
| Views   | View               | ja    | Reguläre Ansichten als      |
|         |                    |       | Dashlets                    |
+---------+--------------------+-------+-----------------------------+
| Graphs  | Single metric      | nein  | Graph für einzelne Metriken |
|         | graph              |       | über Zeitachse              |
+---------+--------------------+-------+-----------------------------+
| Graphs  | Performance graph  | nein  | Vorgegebene                 |
|         |                    |       | Performance-Graphen für     |
|         |                    |       | einzelne Hosts/Services     |
+---------+--------------------+-------+-----------------------------+
| Graphs  | Custom graph       | ja    | Manuell erstellte           |
|         |                    |       | Freiformgraphen             |
+---------+--------------------+-------+-----------------------------+
| Graphs  | Combined graph     | nein  | Graphen mit mehreren        |
|         |                    |       | Metriken                    |
+---------+--------------------+-------+-----------------------------+
| Metrics | Average            | nein  | Metriken diverser           |
|         | scatterplot        |       | Hosts/Services als          |
|         |                    |       | Streudiagramm               |
+---------+--------------------+-------+-----------------------------+
| Metrics | Barplot            | nein  | Balkendiagramm für einzelne |
|         |                    |       | Services                    |
+---------+--------------------+-------+-----------------------------+
| Metrics | Gauge              | nein  | Einzelne Metrik als         |
|         |                    |       | *Tachometer*                |
+---------+--------------------+-------+-----------------------------+
| Metrics | Single metric      | nein  | Einzelne Metrik als Zahl    |
+---------+--------------------+-------+-----------------------------+
| Metrics | Top list           | nein  | Rangliste einer einzelnen   |
|         |                    |       | Metrik von mehreren         |
|         |                    |       | Hosts/Services              |
+---------+--------------------+-------+-----------------------------+
| State   | Host state         | nein  | Zustand eines einzelnen     |
|         |                    |       | Hosts                       |
+---------+--------------------+-------+-----------------------------+
| State   | Service state      | nein  | Zustand eines einzelnen     |
|         |                    |       | Services                    |
+---------+--------------------+-------+-----------------------------+
| State   | Host state summary | nein  | Zusammenfassung einzelner   |
|         |                    |       | Zustände                    |
+---------+--------------------+-------+-----------------------------+
| State   | Service state      | nein  | Zusammenfassung einzelner   |
|         | summary            |       | Zustände                    |
+---------+--------------------+-------+-----------------------------+
| In      | Host Inventory     | nein  | Daten aus dem Inventar      |
| ventory |                    |       |                             |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Site overview      | nein  | Hosts als Zustand-Hexagons  |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Alert statistics   | nein  | Hosts als                   |
|         |                    |       | Alarmierungs-Hexagons       |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Host statistics    | ja    | Gesamtstatistik             |
|         |                    |       | Host-Zustand                |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Service statistics | ja    | Gesamtstatistik             |
|         |                    |       | Service-Zustand             |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Event statistics   | ja    | Gesamtstatistik             |
|         |                    |       | Event-Zustand               |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Notification       | nein  | Benachrichtigungen über     |
|         | timeline           |       | Zeitleiste                  |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Alert timeline     | nein  | Alarmierungen über          |
|         |                    |       | Zeitleiste                  |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Percentage of      | nein  | Prozentsatz                 |
|         | service Problems   |       | Service-Probleme über       |
|         |                    |       | Zeitleiste                  |
+---------+--------------------+-------+-----------------------------+
| Checkmk | User notifications | ja    | Nutzerbenachrichtigungen    |
+---------+--------------------+-------+-----------------------------+
| Checkmk | Sidebar element    | ja    | Beliebige Sidebar-Widgets   |
+---------+--------------------+-------+-----------------------------+
| Ntop    | Alerts             | nein  | Alerts in                   |
|         |                    |       | [ntopng](ntop.html)         |
+---------+--------------------+-------+-----------------------------+
| Ntop    | Flows              | nein  | Datenflüsse in ntopng       |
+---------+--------------------+-------+-----------------------------+
| Ntop    | Top talkers        | nein  | Hosts in ntopng, die den    |
|         |                    |       | meisten Netzwerkverkehr     |
|         |                    |       | verursachen                 |
+---------+--------------------+-------+-----------------------------+
| Other   | Custom URL         | ja    | Interne/externe URLs        |
+---------+--------------------+-------+-----------------------------+
| Other   | Static text        | ja    | Statischer Text für         |
|         |                    |       | Hinweise                    |
+---------+--------------------+-------+-----------------------------+

::: paragraph
Die vielleicht wichtigste Frage der meisten Dashlets: Sind die
dargestellten Informationen auf einzelne Hosts oder Services beschränkt?
Die Antwort finden Sie in allen Dashlet-Einstellungen im Kasten [General
Settings]{.guihint} neben [Show information of single]{.guihint}. Steht
an der Stelle [host, service]{.guihint}, müssen Sie einen Kontextfilter
setzen. Wenn Sie stattdessen die Angabe [Not restricted to showing a
specific object]{.guihint} sehen, müssen Sie keinen Filter
setzen --- können es teilweise aber. Bei Dashlets wie [Custom
URL]{.guihint} oder [Sidebar element]{.guihint} gibt es freilich keine
Filtermöglichkeiten.
:::

::: paragraph
Wie genau Sie die Graphen in den Graphing-Dashlets gestalten, ist etwas
komplexer und wird im zugehörigen [Graphing-Artikel](graphing.html)
ausführlich erläutert.
:::

::: paragraph
Eine besondere Rolle spielt das Dashlet [Custom URL]{.guihint}.
Theoretisch können Sie über die simple Angabe einer Adresse externe
Webseiten oder Ressourcen einbinden --- in der Praxis scheitert das oft
an Sicherheitsmaßnahmen der Betreiber und Browser. Freilich funktioniert
das sehr wohl mit Checkmk-eigenen Ressourcen, beispielsweise anderen
Dashboards. So ließen sich etwa mehrere Host-spezifische Dashboards zu
einer großen Übersicht verknüpfen. Was Sie --- mit ein wenig
Experimentierfreude --- ebenso einbinden können sind interne Ressourcen
des Checkmk-Servers; beispielsweise jegliche Art von Webanwendungen, sei
es ein Wiki, ein kleines Chat-Programm oder gar eine per PHP
implementierte Shell.
:::

::: {#dashlet_siteoverview .paragraph}
Das Dashlet [Site overview]{.guihint} hat zwei Funktionen: In den
Erläuterungen zum [Layout](#layout) oben sehen Sie es als Übersicht der
Hosts --- Standard auf einer normalen, einzelnen Checkmk-Instanz. Im
[verteilten Monitoring](distributed_monitoring.html) zeigt dieses
Dashlet hingegen eine Übersicht der namensgebenden Instanzen/Sites.
:::

::: paragraph
Ein wenig mehr als Sie vielleicht vermuten würden kann auch das Dashlet
[Static text]{.guihint}: Es eignet sich für Hinweise und simple
Beschriftungen, kann aber auch zum Verlinken sonstiger Dashboards oder
anderer Checkmk-Bereiche verwendet werden, wie Sie auch im folgenden
Beispiel für ein Top-Down-Dashboard sehen.
:::
:::::::::
::::::::::::::
:::::::::::::::

:::::::::::::: sect1
## []{#_dashboard_beispiele .hidden-anchor .sr-only}6. Dashboard-Beispiele {#heading__dashboard_beispiele}

::::::::::::: sectionbody
:::::::::::: sect2
### []{#dashboard_examples_1 .hidden-anchor .sr-only}6.1. Top-Down-Dashboard {#heading_dashboard_examples_1}

::: paragraph
Sie kennen nun also alle verfügbaren Dashlets und fertigen Dashboards,
wissen, wo deren Konfigurationen und Layout-Optionen zu erreichen sind
und wie man ein komplettes Dashboard zusammenbaut. Dashboards müssen
aber nicht unbedingt ganz allein für sich stehen, sondern können auch
aufeinander aufbauen --- beispielsweise, um von einer großen Übersicht
bis ins kleinste Detail zu navigieren.
:::

::: paragraph
Im Grunde funktionieren viele Dashlets bereits genau so: Die [Host
statistics]{.guihint} visualisieren die Host-Zustände und ein Klick auf
einen der Zustände leitet zu einer Ansicht weiter, die die zugehörigen
Hosts auflistet --- und von dort geht es wiederum weiter zu den
einzelnen Services eines einzelnen Hosts.
:::

::: paragraph
Bei eigenen Dashboards können Sie auch Links auf andere Dashboards
setzen, indem sie schlicht die Titelzeile von Dashlets via [Link of
Title]{.guihint} in den Dashlet-Einstellungen verlinken. Mal als ganz
konkretes Beispiel: Hier sehen Sie ein Dashboard, das Informationen zu
CPU, RAM und Dateisystem aller Hosts zeigt, die mit *my* beginnen.
:::

:::: imageblock
::: content
![Beispiel-Dashboard aller Hosts, die mit \'my\'
beginnen.](../images/dashboard_topdown1.png)
:::
::::

::: paragraph
Der Titel des CPU-Graphen verlinkt hier ein weiteres Dashboard, welches
die CPU-Informationen für jeden Host einzeln visualisiert. In diesem
Dashboard gibt es wiederum ganz oben einen Link zurück zur Übersicht,
einfach realisiert über ein [Static text]{.guihint}-Dashlet.
:::

:::: imageblock
::: content
![Link zur Rückkehr in das aufrufende
Dashboard.](../images/dashboard_topdown2.png)
:::
::::

::: paragraph
Mit solchen Querverlinkungen können Sie komplexe Recherchewerkzeuge über
Dashboards realisieren. Dabei sind Sie übrigens nicht auf die Titelzeile
beschränkt, als statischen Text können Sie durchaus HTML-Code verwenden
und so ganze Navigationen einbauen. Denken Sie etwa an verteiltes
Monitoring und Pfade wie *Gesamtübersicht \> Instanzübersicht \>
Host-Übersicht \> Container-Übersicht \> Services \> Probleme.*
:::
::::::::::::
:::::::::::::
::::::::::::::

::::::::::::::::::: sect1
## []{#troubleshooting .hidden-anchor .sr-only}7. Fehlerbehebung {#heading_troubleshooting}

:::::::::::::::::: sectionbody
:::::: sect2
### []{#_fehlende_filter .hidden-anchor .sr-only}7.1. Fehlende Filter {#heading__fehlende_filter}

::: paragraph
Es kann vorkommen, dass Sie bei einem Dashlet lediglich die folgende,
gelb unterlegte Warnung sehen:
:::

::: paragraph
[Unable to render this element, because we miss some required context
information (host, service). Please update the form on the right to make
this element render.]{.guihint}
:::

::: paragraph
In diesem Fall soll das Dashlet Informationen für nur einen Host
und/oder Service anzeigen --- für den oder die aber kein Filter gesetzt
wurde. Um das zu beheben, können Sie wahlweise die Filter in der
Dashboard-Ansicht nutzen oder in der Dashlet-Konfiguration.
:::
::::::

::::: sect2
### []{#_leere_dashlets .hidden-anchor .sr-only}7.2. Leere Dashlets {#heading__leere_dashlets}

::: paragraph
Für gänzlich leere Dashlets bei ausbleibenden Fehlermeldungen kann es
mehrere Gründe geben. In der Regel handelt es sich um eine
Fehlkonfiguration des Dashlets. Beispiel: Sie erstellen ein Dashlet für
die CPU-Auslastung mit der Metrik und dem gefilterten Service [CPU
load]{.guihint}. Später ändern Sie den Filter der Service-Beschreibung
auf etwa [Check_MK Discovery]{.guihint}, belassen die gewählte Metrik
aber auf [CPU load]{.guihint}. Beim Anlegen eines Dashlets kann Ihnen
das nicht passieren, da nach dem Filter auf die CPU-Auslastung gar keine
Auswahl einer unpassenden Metrik möglich ist --- beim Umkonfigurieren
von Dashlets wird die ursprünglich gewählte Metrik jedoch beibehalten.
:::

::: paragraph
Die Lösung ist trivial: Passen Sie Service-Filter und gewählte Metrik in
der Dashlet-Konfiguration an. Das gilt natürlich auch für alle anderen
Dashlet-Varianten.
:::
:::::

:::::::::: sect2
### []{#host_problems .hidden-anchor .sr-only}7.3. Leere Dashlets: Total host/service problems {#heading_host_problems}

::: paragraph
Die Dashlets [Total host problems]{.guihint} und [Total service
problems]{.guihint} sind ein Sonderfall für leere Dashlets. Hier könnte
Ihnen folgende Fehlermeldung unterkommen, wenn Sie [verteiltes
Monitoring](distributed_monitoring.html) einsetzen: [As soon as you add
your Checkmk server(s) to the monitoring ...​ Currently the following
Checkmk sites are note monitored: ...​]{.guihint}
:::

:::: imageblock
::: content
![Fehlermeldung im Dashlet \'Total host
problems\'.](../images/dashboards_total_dashlets.png)
:::
::::

::: paragraph
Grundsätzlich heißt das also, dass Checkmk den Server der Remote-Instanz
nicht als Host im Monitoring sieht. Zunächst sollten Sie also prüfen, ob
nicht bloß die Verbindung für das verteilte Monitoring aufgesetzt,
sondern auch der entfernte Server als Host aufgenommen wurde.
:::

::: paragraph
Nun kann es sein, dass der Server der Remote-Instanz aber sehr wohl
bereits im Monitoring ist und die Fehlermeldung dennoch auftaucht. In
dem Fall liegt es in der Regel an der Version der Remote-Instanz: Wenn
die Zentralinstanz eine [2.0.0]{.new} ist, muss auch die entfernte eine
[2.0.0]{.new} sein. In diesem Fall müssen Sie entsprechend
aktualisieren --- beachten Sie aber die
[Update-Hinweise.](update_major.html)
:::

::: paragraph
Und noch eine Ursache kann für die Fehlermeldung verantwortlich sein: In
der Verbindung zu einer Remote-Instanz wird für diese eine [Site
ID]{.guihint} vergeben. Wenn diese ID nicht **exakt** mit dem Namen der
Instanz übereinstimmt, die IP-Adresse aber korrekt ist, wird die
Verbindung selbst zwar als okay angezeigt, aber es wird im Dashlet diese
Fehlermeldung provoziert. Die Lösung ist einfach: Neue Verbindung mit
korrekter ID anlegen.
:::

::: paragraph
Der Grund ist in beiden Fällen identisch: Für die Dashlets werden die
Namen der verbundenen Sites aus den Verbindungen des verteilten
Monitorings gelesen **und** aus den Service-Ausgaben --- und nur wenn
jeweils exakt dieselben Instanzen gefunden werden, funktionieren die
Dashlets korrekt. So ist sichergestellt, dass auch tatsächlich die
korrekten Daten ausgegeben werden.
:::
::::::::::
::::::::::::::::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
