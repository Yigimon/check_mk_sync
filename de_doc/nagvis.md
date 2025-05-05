:::: {#header}
# NagVis: Statusdaten auf Karten und Diagrammen

::: details
[Last modified on 26-Jun-2018]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/nagvis.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Grundlagen des Monitorings mit Checkmk](monitoring_basics.html)
[Statusdaten abrufen via Livestatus](livestatus.html) [Verwaltung der
Hosts](hosts_setup.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Was ist NagVis? {#heading_intro}

:::::::::: sectionbody
::: paragraph
Im Artikel zu den
[Monitoring-Grundlagen](monitoring_basics.html#parents) haben Sie kurz
eine Karte einer Netzwerktopologie, basierend auf
Parent-Child-Beziehungen gesehen. Verantwortlich für derlei Karten ist
NagVis. Die Erweiterung dient zum Visualisieren von beispielsweise
Infrastrukturen, Servers, Ports oder Prozessen.
:::

::: paragraph
Die Funktionsweise von NagVis ist im Grunde sehr einfach: Checkmk,
genauer gesagt [Livestatus](glossar.html#livestatus), liefert als
Backend Daten wie zum Beispiel Hosts, Services, Host-Gruppen und
Service-Gruppen. Diese Elemente aus Ihrem Monitoring lassen sich als
Symbole (*icons*) auf unterschiedlichen Karten platzieren. Dabei zeigen
die dynamischen Symbole den jeweils aktuellen Zustand des oder der Hosts
und Services. Detaillierte Informationen werden zudem als Tooltipps
geliefert. Und letztlich sind Symbole und sonstige Elemente auch Links
zu den Checkmk-Objekten, die sie repräsentieren. Als sonstige Elemente
stehen Ihnen zum Beispiel Linien, Leistungsanzeigen (Gadgets) und
Container für externe Inhalte zur Verfügung.
:::

::: paragraph
Um eine Vorstellung zu bekommen, was sich mit NagVis in Checkmk
anstellen lässt, hier drei Beispiele:
:::

::: ulist
- Geografische Karten zur Verwaltung von Standorten auf Basis von
  [OpenStreetMap.](https://www.openstreetmap.org/){target="_blank"}

- Automatische Topologiekarten aus Parent-Child-Beziehungen.

- Karten für einzelne Switches oder Server-Räume, um Ports
  beziehungsweise Hardware im Überblick zu haben.
:::

::: paragraph
Sofern Sie [Parent-Child-Beziehungen](monitoring_basics.html#parents)
definiert haben, können Sie eine Karte in Checkmk über [Monitor \>
Overview \> Parent / Child topology]{.guihint} aufrufen. Weitere
Schritte sind hier nicht nötig.
:::

:::: imageblock
::: content
![monitoring parents](../images/monitoring_parents.png)
:::
::::
::::::::::
:::::::::::

:::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}2. NagVis einrichten {#heading_setup}

::::::::::: sectionbody
::: paragraph
NagVis ist komplett in Checkmk integriert und so konfiguriert, dass Sie
direkt anfangen können, Elemente aus Ihrem Monitoring in Karten
einzubauen.
:::

::: paragraph
Um NagVis zu starten, öffnen Sie zunächst den Bereich mit den
verfügbaren Snapins für die [Seitenleiste](glossar.html#sidebar) über
[![button sidebar add
snapin](../images/icons/button_sidebar_add_snapin.png)]{.image-inline}
unten in der Seitenleiste. Wählen Sie hier das Snapin [NagVis
maps]{.guihint} aus und starten Sie NagVis anschließend über [![button
view snapin
edit](../images/icons/button_view_snapin_edit.png)]{.image-inline}.
:::

:::: imageblock
::: content
![nagvis snapin nagvis](../images/nagvis_snapin_nagvis.png){width="50%"}
:::
::::

::: paragraph
Bevor Sie eine erste Karte anlegen, sollten Sie einen Blick in die
Grundkonfiguration unter [Options \> General Configuration]{.guihint}
werfen. Hier finden Sie über 100 Optionen von Grundlagen wie
Datumsformat oder Spracheinstellungen, über die Darstellung von Objekten
auf Karten, bis hin zur Gewichtung der verfügbaren Host- und
Service-Zustände.
:::

:::: imageblock
::: content
![nagvis2 general
configuration](../images/nagvis2_general_configuration.png)
:::
::::

::: paragraph
Auf eine ausführliche Beschreibung der Nutzung und vor allem der
Konfigurationsmöglichkeiten von NagVis verzichten wir an dieser Stelle.
NagVis hat selbst eine sehr gute, ausführliche
[Dokumentation,](https://www.nagvis.org/doc){target="_blank"} in der
auch alle Optionen der Grundkonfiguration beschrieben sind. Im Folgenden
beschränken wir uns auf die nötigsten Grundlagen, um mit NagVis
einfache, sinnvolle Karten in Checkmk erstellen zu können.
:::
:::::::::::
::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#maps .hidden-anchor .sr-only}3. Karten erstellen {#heading_maps}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_die_verschiedenen_kartentypen .hidden-anchor .sr-only}3.1. Die verschiedenen Kartentypen {#heading__die_verschiedenen_kartentypen}

::: paragraph
NagVis bietet insgesamt fünf verschiedene Kartentypen: Reguläre,
dynamische, automatische und interaktive/nicht-interaktive geographische
Karten.
:::

::: ulist
- Die reguläre Karte (*regular map*) ist der Standardkartentyp. Die
  Karte kann beliebige Szenarien visualisieren, von Switchports, über
  Server-Räume, bis hin zu ganzen Infrastrukturen. Die Elemente
  (Symbole, Linien etc.) werden einzeln aus dem Bestand der
  Checkmk-Hosts und -Services zur Karte hinzugefügt.

- Die dynamische Karte (*dynamic map*) entspricht weitestgehend der
  regulären, allerdings mit einem gewaltigen Vorteil: Hosts, Services,
  Host-Gruppen und Service-Gruppen werden hier nicht explizit, sondern
  über Filter in Form von [regulären Ausdrücken](regexes.html)
  angegeben; genauer gesagt in Form gültiger
  [Livestatus](livestatus.html)-Filter. Somit landen auch neue Hosts und
  Services sowie jegliche Veränderungen ohne weiteres Zutun in der
  Karte.

- Die automatische Karte (*automap*) haben Sie bereits kennengelernt.
  Dabei handelt es sich um die [anfangs](#intro) erwähnte
  Netzwerktopologiekarte, die vollautomatisch aus in Checkmk definierten
  Parent-Child-Beziehungen erstellt wird.

- Die geografische Karte (*geographical map*) ist eine Karte, die mit
  Kartenmaterial aus dem OpenStreetMap (OSM) Projekt als Hintergrund
  gerendert werden.
:::
:::::

:::::::::::: sect2
### []{#automap .hidden-anchor .sr-only}3.2. Eine automatische Karte erstellen {#heading_automap}

::: paragraph
Die schnellste Möglichkeit, eine aussagekräftige Karte zu erstellen, ist
die automatische Karte (*automap*). Erstellen Sie über [Options \>
Manage Maps \> Create Map]{.guihint} eine neue Karte vom Typ [Automap
based on parent/child relations.]{.guihint} Bei [ID]{.guihint} tragen
Sie den internen Namen `myautomap` und bei [Alias]{.guihint} den Namen
`My Automap` für die Anzeige ein.
:::

:::: imageblock
::: content
![nagvis2 automap create](../images/nagvis2_automap_create.png)
:::
::::

::: paragraph
Die Karte selbst erscheint sofort im Anzeigebereich und im Snapin
[NagVis maps]{.guihint} ein entsprechender Link. Die spezifischen
Einstellungen für die automatische Karte können Sie nun über [Edit Map
\> Map Options \> Automap]{.guihint} anpassen. Insbesondere der Eintrag
[render_mode]{.guihint} ist interessant, sorgt er doch für das
grundlegende Layout der Knoten auf der Karte.
:::

:::: imageblock
::: content
![nagvis2 automap options](../images/nagvis2_automap_options.png)
:::
::::

::: paragraph
Zudem können Sie hier die Wurzel der Karte bestimmen - einfacher geht
das allerdings über einen Rechtsklick auf ein Symbol in der Karte und
den Kontextmenüeintrag [Make root.]{.guihint}
:::

:::: imageblock
::: content
![nagvis2 automap
contextmenu](../images/nagvis2_automap_contextmenu.png)
:::
::::
::::::::::::

::::::::::::::::::::::::::::::::: sect2
### []{#regular_map .hidden-anchor .sr-only}3.3. Eine reguläre Karte erstellen {#heading_regular_map}

::: paragraph
Die regulären Karten (*regular maps*) sind die gebräuchlichsten Karten
in NagVis. Um die Vorgehensweise und die wichtigsten Elemente von NagVis
kennenzulernen, zeigen wir Ihnen, wie Sie eine kleine Karte von einem
Server-Rack erstellen. Diese visualisiert einen Hosts auf einem
individuellen Hintergrund und warnt optisch und akustisch, sobald der
überwachte Host nicht mehr [OK]{.state0} ist.
:::

::: paragraph
Um die Karte anzulegen, öffnen Sie die Optionen über [Options \> Manage
Maps.]{.guihint} Hier vergeben Sie unter [Create Map]{.guihint} den
Namen `mymap` und den Alias `My Map`. Als [Map Type]{.guihint} wählen
Sie [Regular map]{.guihint} und bestätigen dann mit dem Knopf
[Create]{.guihint}.
:::

:::: imageblock
::: content
![nagvis2 regularmap create](../images/nagvis2_regularmap_create.png)
:::
::::

::: paragraph
Als nächstes importieren Sie ein Bild des zu überwachenden Racks als
Hintergrund. Dies erledigen Sie über [Options \> Manage
Backgrounds.]{.guihint} Wählen Sie die lokale Datei und bestätigen Sie
mit dem Knopf [Upload.]{.guihint}
:::

:::: imageblock
::: content
![nagvis2 regularmap upload
background](../images/nagvis2_regularmap_upload-background.png)
:::
::::

::: paragraph
Nun muss das importierte Bild als Hintergrund für die aktuelle Karte
gesetzt werden. Rufen Sie dazu die Kartenoptionen über [Edit Map \> Map
Options]{.guihint} auf und wechseln Sie zum Reiter
[Appearance.]{.guihint} Aktivieren Sie hier die Option
[map_image]{.guihint} und wählen Sie aus dem Menü das gewünschte Bild.
Speichern Sie noch nicht, Sie brauchen noch eine Einstellung aus den
Kartenoptionen.
:::

:::: imageblock
::: content
![nagvis2 regularmap
background](../images/nagvis2_regularmap_background.png)
:::
::::

::: paragraph
Wechseln Sie zum Reiter [Obj. Defaults.]{.guihint} Hier können Sie die
Option [label_show]{.guihint} aktivieren. Diese Option sorgt dafür, dass
Host- und Service-Symbole auf der Karte mit den jeweiligen
Host-/Service-Namen beschriftet werden --- ansonsten wären die Symbole
nur über ihre Tooltipps zu identifizieren. Speichern Sie diese
Einstellungen danach ab.
:::

:::: imageblock
::: content
![nagvis2 regularmap show
label](../images/nagvis2_regularmap_show-label.png)
:::
::::

::: paragraph
Nun wird es Zeit, den Host hinzuzufügen. Klicken Sie dazu auf [Edit Map
\> Add Icon \> host]{.guihint} und dann mit dem zum Kreuz gewordenen
Cursor auf die Stelle der Karte, wo das Host-Symbol platziert werden
soll --- erst dann öffnet sich der Dialog [Create Object.]{.guihint} Im
Reiter [General]{.guihint} wählen Sie im Grunde nur den gewünschten Host
im Drop-down-Menü bei [host_name]{.guihint} aus und speichern. Sofern
Sie mehrere Checkmk-[Instanzen](glossar.html#site) betreiben, können Sie
über [backend_id]{.guihint} auch eine alternative Datenquelle nutzen.
:::

:::: imageblock
::: content
![nagvis2 regularmap host
create](../images/nagvis2_regularmap_host_create.png)
:::
::::

::: paragraph
Das Symbol ist nun auf der Karte platziert und liefert
Detailinformationen über einen Tooltipp. Per Klick auf das Symbol
gelangen Sie direkt zum Host in Checkmk --- alle platzierten Elemente in
NagVis sind Links zu ihren Checkmk-Objekten.
:::

:::: imageblock
::: content
![nagvis2 regularmap host
hover](../images/nagvis2_regularmap_host-hover.png)
:::
::::

::: paragraph
Um das Symbol verschieben oder bearbeiten zu können, müssen Sie den
Bearbeitungsmodus aktivieren. Rufen Sie dazu mit einem Rechtsklick auf
das Symbol dessen Kontextmenü auf und wählen Sie [Unlock.]{.guihint}
:::

:::: imageblock
::: content
![nagvis2 regularmap icon menu
locked](../images/nagvis2_regularmap_icon-menu_locked.png)
:::
::::

::: paragraph
Nun können Sie das Symbol verschieben oder wieder das Kontextmenü
aufrufen. Hier finden Sie nun einige neue Optionen, um das Objekt zu
klonen, zu löschen, zu bearbeiten oder ein Problem über
[Acknowledge]{.guihint} direkt von hier aus zu
[quittieren.](basics_ackn.html)
:::

:::: imageblock
::: content
![nagvis2 regularmap icon menu
unlocked](../images/nagvis2_regularmap_icon-menu_unlocked.png)
:::
::::

::: paragraph
Um die Bearbeitung des Hosts/Symbols zu beenden, müssen Sie aus dem
Kontextmenü noch [Lock]{.guihint} wählen. Den Bearbeitungsmodus können
Sie übrigens über [Edit Map \> Lock/Unlock all]{.guihint} auch für die
gesamte Karte ein- und ausschalten.
:::

::: paragraph
Sie können die Karte nun mit weiteren Hosts bestücken. Und auch das
Hinzufügen von Services, Host-Gruppen und Service-Gruppen funktioniert
analog.
:::

::: paragraph
Zum Abrunden können Sie die Karte noch so konfigurieren, dass Störungen
beim Laden durch einen Warnton und blinkende Host-Symbole signalisiert
werden. Rufen Sie dazu [Edit Map \> Map Options]{.guihint} auf und
wechseln Sie zum Reiter [Events.]{.guihint} Aktivieren Sie hier ganz
oben [event_on_load]{.guihint} und setzen Sie ein Häkchen ganz unten bei
[event_sound]{.guihint}, um auch die akustische Warnmeldung zu bekommen.
:::

:::: imageblock
::: content
![nagvis2 regularmap events](../images/nagvis2_regularmap_events.png)
:::
::::
:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::: sect2
### []{#geographical_map .hidden-anchor .sr-only}3.4. Eine geografische Karte erstellen {#heading_geographical_map}

::: paragraph
Geografische Karten gibt es in zwei unterschiedlichen Ausführungen: In
der *interaktiven* Variante handelt es sich um eine verschieb- und
zoombare Karte, wie man es von Google Maps & Co. kennt, die automatisch
als Hintergrund gesetzt wird. Objekte, die auf derlei Karten platziert
werden, finden sich auch auf jeder weiteren Karte desselben Typs. NagVis
geht davon aus, dass ein Objekt an einem bestimmten Ort zu finden ist,
gleich wie groß der Kartenausschnitt ist. So wäre beispielsweise ein in
Hamburg platzierter Host sowohl auf einer Welt- als auch einer
Deutschland- oder gar Hamburg-Karte zu sehen.
:::

::: paragraph
NagVis sieht die unterschiedlichen Kartenausschnitte und Zoom-Level
letztlich nur als *Viewports.* Viewports können jederzeit als eigene,
neue Karte gespeichert werden. Da sich Viewports/Karten ebenfalls als
Symbole auf Karten darstellen lassen, können Karten gewissermaßen
verschachtelt werden. So könnten Sie beispielsweise eine
Deutschlandkarte mit Ihren Abhängigkeiten aufrufen, per Klick in eine
detailliertere Ansicht für ein Bundesland wechseln, dann in eine
spezifische Niederlassung, dann in einen bestimmten Server-Raum und von
dort letztlich zu einer Karte für einen einzelnen Switch.
:::

::: paragraph
Im Gegensatz zum manuellen Navigieren in der interaktiven Karte spart
das Aufwand und die Karten stehen auch einzeln bereit, beispielsweise,
um sie auf unterschiedlichen Monitoren parallel zu verfolgen oder
automatisch rotieren zu lassen (mehr dazu [später](#rotate)). Auch
wichtig: So steht die Zusammenfassung der verbundenen Karte als Tooltipp
zur Verfügung. Zudem ist die Nutzung für Dritte intuitiver, da sie sich
schlicht durch die Hierarchie klicken können und keine Vorstellung haben
müssen, wo sie denn hin zoomen müssten.
:::

::: paragraph
Die *nicht interaktive* geografische Karte muss mit einer CSV-Datei
gefüttert werden, die zu rendernde Hosts und Koordinaten enthält. Hier
gibt es keine übergreifend vorhandenen Elemente.
:::

::: paragraph
In der
[Nagvis-Dokumentation](https://www.nagvis.org/doc){target="_blank"}
heißen die *interaktiven* geografischen Karten *Worldmaps* und die
*nicht-interaktiven* Varianten *Geomaps.* Worldmaps sind erst in der
Version 1.9 von NagVis hinzugekommen und bislang nur in der englischen
Dokumentation erläutert.
:::

::: paragraph
Beispiel: Sie erstellen eine interaktive Karte für ganz Deutschland und
verknüpfen einen neuen Viewport für Nordrhein-Westfalen (NRW). Eine
interaktive geografische Karte, also eine Worldmap, legen Sie über
[Options \> Manage Maps \> Create Map]{.guihint} an. Als [Map
Type]{.guihint} wählen Sie den Eintrag [Geographical Map
(interactive).]{.guihint} Vergeben Sie auch hier wieder ID (`mygeomap`)
und Alias (`My Geographical Map`).
:::

:::: imageblock
::: content
![nagvis2 geomap create](../images/nagvis2_geomap_create.png)
:::
::::

::: paragraph
Stellen Sie anschließend den gewünschten Kartenausschnitt ein, welchen
Sie als Gesamtüberblick haben wollen und speichern Sie diese Ansicht
über [Edit Map \> Viewport \> Save view.]{.guihint}
:::

:::: imageblock
::: content
![nagvis2 geomap save view](../images/nagvis2_geomap_save-view.png)
:::
::::

::: paragraph
Zoomen Sie nun soweit in die Karte, bis Sie die gewünschte Ansicht für
NRW erreicht haben. Dieses mal speichern Sie die Ansicht über [Edit Map
\> Viewport \> Save as new map]{.guihint} als neue Karte `mygeomap_nrw`.
:::

:::: imageblock
::: content
![nagvis2 geomap save
viewport](../images/nagvis2_geomap_save-viewport.jpeg)
:::
::::

::: paragraph
Der Alias der Karte wird von der Ursprungskarte übernommen, so dass Sie
links in der Navigationsleiste nun zwei Karten namens [My Geographical
Map]{.guihint} haben. Vergeben Sie daher zunächst einen neuen Alias
`My Geographical Map NRW` über [Edit Map \> Map Options]{.guihint}.
:::

:::: imageblock
::: content
![nagvis2 geomap vieport
alias](../images/nagvis2_geomap_vieport-alias.jpeg)
:::
::::

::: paragraph
Wechseln Sie zur Deutschlandkarte [My Geographical Map]{.guihint} und
fügen Sie die Verknüpfung zur NRW-Karte über [Edit Map \> Add Icon \>
Map]{.guihint} ein. Im folgenden Dialog [Create Object]{.guihint} müssen
Sie lediglich die Karte [mygeomap_nrw]{.guihint} im Menü unter
[map_name]{.guihint} festlegen.
:::

:::: imageblock
::: content
![nagvis2 geomap map icon
create](../images/nagvis2_geomap_map-icon_create.png)
:::
::::

::: paragraph
Anschließend gelangen Sie in der Kartenansicht für Deutschland über
einen Klick auf das neue Symbol direkt zur NRW-Karte. Auf die gleiche
Art und Weise können Sie noch weitere Karten miteinander verbinden und
natürlich auch eine Navigation von der NRW- zurück zur Deutschlandkarte
einbauen.
:::

:::: imageblock
::: content
![nagvis2 geomap map link](../images/nagvis2_geomap_map-link.png)
:::
::::

::: paragraph
Das eigentliche Befüllen der Karten entspricht dann dem Vorgehen bei
anderen Kartentypen auch. Aber denken Sie daran: Alle Objekte, die Sie
auf *einer* der Worldmap-Karten hinzufügen, landen auch auf *jeder
anderen* Worldmap-Karte --- da es eben nur unterschiedliche Ansichten
auf die echte geografische Verteilung sind.
:::
:::::::::::::::::::::::::::

:::::::::::::::: sect2
### []{#dynamic_map .hidden-anchor .sr-only}3.5. Eine dynamische Karte erstellen {#heading_dynamic_map}

::: paragraph
Dynamische Karten (*dynamic maps*) unterscheiden sich von den reguläre
Karten wie oben erwähnt durch die Art des Hinzufügens von Elementen.
Statt manuell bekommen die dynamische Karten ihre Elemente, also Hosts,
Services, Host-Gruppen und Service-Gruppen, dynamisch über
Livestatus-Filter zugewiesen. Als Beispiel soll eine Karte automatisch
mit den [CPU load]{.guihint}-Services aller Hosts bestückt werden.
:::

::: paragraph
Um eine solche Karte zu erstellen, beginnen Sie wieder mit [Options \>
Manage Maps \> Create Map]{.guihint} und vergeben ID (`mydynamicmap`)
und Alias (`My Dynamic Map`).
:::

:::: imageblock
::: content
![nagvis2 dynmap create](../images/nagvis2_dynmap_create.png)
:::
::::

::: paragraph
Öffnen Sie anschließend die Kartenoptionen über [Edit Map \> Map
Options]{.guihint} und wechseln Sie zum Reiter [Dynmap.]{.guihint} Hier
aktivieren Sie die Option [dynmap_object_types]{.guihint} und wählen als
Objekttyp die Services.
:::

::: paragraph
Der spannende Teil folgt nun in der zweiten Option
[dynmap_object_filter]{.guihint}, wo der Filter für die Services gesetzt
wird. Verwenden Sie die einfache [Livestatus-Abfrage](livestatus.html)
`Filter: description ~ CPU load\n`. Damit wird in der Spalte
`description` nach dem String `CPU load` gesucht. Das `\n` gehört nicht
zum Filter selbst, sondern erzeugt einen Zeilenumbruch, der für die aus
dem Filter konstruierte Livestatus-Anfrage benötigt wird.
:::

:::: imageblock
::: content
![nagvis2 dynmap options
filter](../images/nagvis2_dynmap_options_filter.png)
:::
::::

::: paragraph
Wenn Sie nun speichern, landen alle [CPU load]{.guihint}-Services in
Ihrem Monitoring als Symbole auf der Karte. Auch neue Objekte im
Monitoring, die auf den Filter zutreffen, werden der Karte automatisch
hinzugefügt.
:::

:::: imageblock
::: content
![nagvis2 dynmap auto icons](../images/nagvis2_dynmap_auto-icons.png)
:::
::::

::: paragraph
In der NagVis-Dokumentation wird auch gezeigt, wie die Konfiguration
direkt über die Konfigurationsdateien funktioniert.
:::

::: paragraph
**Übrigens:** Da Sie dynamische Karten über [Actions \> Export to static
map]{.guihint} auch als statische Karten speichern können, dienen sie
auch als Einstiegshilfe, um statische Karten initial mit sehr vielen
Elementen zu bestücken.
:::
::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#customizing .hidden-anchor .sr-only}4. Karten anpassen {#heading_customizing}

:::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#lines .hidden-anchor .sr-only}4.1. Linien {#heading_lines}

::: paragraph
NagVis bietet verschiedene Arten von Linien an: Es gibt rein dekorative
Linien ohne weitere Funktion unter [Edit Map \> Add Special \> Stateless
Line]{.guihint}, Linien, die genau wie Symbole Hosts und Services in
Ampelfarben visualisieren und die Wetterkartenlinien (*weathermap
lines*). Letztere visualisieren Netzwerkbandbreite in sieben
verschiedenen Farben. Um eine solche Wetterkartenlinie zu erstellen,
gehen Sie wie folgt vor:
:::

::: paragraph
Starten Sie über [Edit Map \> Add Line \> Service]{.guihint} und wählen
Sie im Dialog [Create Object]{.guihint} einen Host und eine
Netzwerkschnittstelle.
:::

:::: imageblock
::: content
![nagvis2 lines create](../images/nagvis2_lines_create.png)
:::
::::

::: paragraph
Wechseln Sie anschließend zum Reiter [Appearance]{.guihint} und setzen
Sie den [view_type]{.guihint} auf [line.]{.guihint} Als
[line_type]{.guihint} aktivieren Sie den Eintrag `--%+BW-><-%+BW--`.
Damit werden Linien für Up- und Download inklusive Labels für
prozentuale (`%`) und absolute (`BW`) Bandbreitennutzung erstellt.
:::

:::: imageblock
::: content
![nagvis2 lines line type](../images/nagvis2_lines_line-type.png)
:::
::::

::: paragraph
Nach dem Speichern finden Sie die erzeugte Linie auf der Karte. Klicken
Sie nun auf das Schlosssymbol in der Mitte, können Sie die Anfangspunkte
sowie den Mittelpunkt der Linien verschieben.
:::

:::: imageblock
::: content
![nagvis2 lines weatherlines](../images/nagvis2_lines_weatherlines.png)
:::
::::

::: paragraph
NagVis liefert auch gleich eine fertige Legende mit: Fügen Sie über
[Edit Map \> Add Special \> Shape]{.guihint} eine sogenannte *Form* ein,
in NagVis schlicht ein Bild. Wählen Sie bei der Option [icon]{.guihint}
aus dem Drop-down-Menü das Bild
[demo_traffic_load_legend.png]{.guihint}.
:::

:::: imageblock
::: content
![nagvis2 lines weatherlines
result](../images/nagvis2_lines_weatherlines_result.png)
:::
::::
::::::::::::::::

:::::::: sect2
### []{#gadgets .hidden-anchor .sr-only}4.2. Gadgets {#heading_gadgets}

::: paragraph
Gadgets sind wie Linien und Symbole Visualisierungen auf der Karte. Sie
zeigen Performance-Daten in Form von Tachos, Thermometern und ähnlichem
an. Folglich sind diese nur für Services verfügbar. Beispielsweise
können Sie die Auslastung einer Netzwerkschnittstelle in Form einer
Tachoanzeige erzeugen:
:::

::: paragraph
Fügen Sie zunächst Ihrer Karte einen Service über [Edit Map \> Add Icon
\> Service]{.guihint} als Symbol hinzu. Wählen Sie im Reiter
[General]{.guihint} einen Host und als Service eine passende
Netzwerkschnittstelle.
:::

::: paragraph
Wechseln Sie zum Reiter [Appearance]{.guihint} und setzen Sie
[view_type]{.guihint} auf [gadget.]{.guihint} Direkt darunter aktivieren
Sie [gadget_url.]{.guihint} Hier finden Sie einige
Darstellungsvarianten, die den Dateien unter
`~/share/nagvis/htdocs/userfiles/gadgets/` entsprechen. Für die
Tacho-Darstellung wählen Sie hier [std_speedometer.php]{.guihint}.
:::

:::: imageblock
::: content
![nagvis2 gadget speedometer](../images/nagvis2_gadget_speedometer.png)
:::
::::
::::::::

:::::::::: sect2
### []{#container_iframes .hidden-anchor .sr-only}4.3. Container/Iframes {#heading_container_iframes}

::: paragraph
Eine interessante Möglichkeit, externe Informationen einzublenden,
bieten die *Container.* Hier können Sie einfach eine URL angeben und das
Ziel in einem Iframe anzeigen lassen. Als Beispiel soll die Ansicht
einer Host-Gruppe dienen, als [eingebettete
Ansicht](views.html#embed_views) auf die reine Tabelle beschränkt.
:::

::: paragraph
Fügen Sie Ihrer Karte über [Edit Map \> Add Special \>
Container]{.guihint} einen Container hinzu. Im Gegensatz zu Host- und
Service-Symbolen müssen Sie hier nicht bloß in die Karte klicken,
sondern einen Rahmen aufziehen. Sie können diesen später natürlich
jederzeit anpassen. Anschließend öffnet sich wieder ein Dialog mit
Optionen.
:::

::: paragraph
Im Reiter [General]{.guihint} setzen Sie den [view_type]{.guihint} auf
[iframe.]{.guihint} Die eigentliche Arbeit steckt in der Option
[url]{.guihint}: Die Basis-URL bekommen Sie über [![button
frameurl](../images/icons/button_frameurl.png)]{.image-inline} auf der
Seite der Host-Gruppenansicht. Anschließend müssen noch die Optionen für
die [eingebettete Ansicht](views.html#embed_views) hinzugefügt werden,
damit auch wirklich nur die Tabelle selbst angezeigt wird (plus ein
wenig Hintergrund). Samt dieser könnte die URL etwa so aussehen:
:::

::: paragraph
`/mysite/check_mk/view.py?view_name=hostgroups&display_options=tbdezocf`
:::

::: paragraph
Das genaue Einpassen und Platzieren des Containers erledigen Sie
ebenfalls im Reiter [General]{.guihint} über die Eingabe der Koordinaten
sowie der Höhe und Breite. Wenn Sie das Kontextmenü eines
Iframe-Containers öffnen wollen, müssen Sie den Mauszeiger direkt über
dem Rand platzieren, so dass er seine Form ändert zum Skalieren.
:::

:::: imageblock
::: content
![nagvis modify container](../images/nagvis_modify_container.png)
:::
::::
::::::::::

::::::::: sect2
### []{#rotate .hidden-anchor .sr-only}4.4. Karten rotieren lassen {#heading_rotate}

::: paragraph
Auf der Übersichtsseite von NagVis ist Ihnen vielleicht links unten in
der Navigationsleiste der Eintrag [Rotations]{.guihint} beziehungsweise
mittig die Auflistung von Karten unter [Rotation Pools]{.guihint}
aufgefallen. Sie können Karten automatisch in einem beliebigen Intervall
rotieren lassen, praktisch beispielsweise für öffentliche
Informations-Monitore.
:::

::: paragraph
Die Konfiguration nehmen Sie in der NagVis-Konfigurationsdatei
`~/etc/nagvis/nagvis.ini.php` vor. Öffnen Sie diese Datei und scrollen
Sie zu Zeile 448, wo Sie die `Rotation pool definitions` finden.
:::

::: paragraph
Hier benötigen Sie drei Zeilen, um einen Rotation Pool, die zugehörigen
Karten und das Intervall zu definieren --- im folgenden Beispiel den
Pool `myrotation` mit den Karten `mymap1`, `mymap2` und `mymap3` sowie
einem Intervall von 30 Sekunden:
:::

::::: listingblock
::: title
\~/etc/nagvis/nagvis.ini.php
:::

::: content
``` {.pygments .highlight}
[rotation_myrotation]
maps="mymap1,mymap2,mymap3"
interval=30
```
:::
:::::
:::::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
