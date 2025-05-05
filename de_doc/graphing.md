:::: {#header}
# Messwerte und Graphing

::: details
[Last modified on 14-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/graphing.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Benutzeroberfläche](user_interface.html) [Ansichten von Hosts und
Services (Views)](views.html) [Dashboards](dashboards.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::: sectionbody
:::: imageblock
::: content
![Beispiel eines Graphen.](../images/example_graph.png)
:::
::::

::: paragraph
Neben dem eigentlichen System-Monitoring --- nämlich der Erkennung von
Problemen --- ist Checkmk ein ausgezeichnetes Werkzeug zur Aufzeichnung
und Analyse von unterschiedlichsten Messdaten, welche in IT-Umgebungen
so anfallen können. Dazu gehören zum Beispiel:
:::

::: ulist
- Betriebssystem-Performance (Platten-IO, CPU- und
  Speicherauslastung, ...​)

- Netzwerkgrößen (genutzte Bandbreite, Paketlaufzeiten,
  Fehlerraten, ...​)

- Umgebungssensoren (Temperatur, Luftfeuchte, Luftdruck, ...​)

- Nutzungsstatistiken (angemeldete Benutzer, Seitenabrufe,
  Sessions, ...​)

- Qualitätskennzahlen von Anwendungen (z.B. Antwortzeiten von Webseiten)

- Stromverbrauch und -qualität im Rechenzentrum (Ströme, Spannungen,
  Leistungen, Batteriegüte, ...​)

- Anwendungsspezifische Daten (z.B. Länge von E-Mail-Warteschlangen von
  MS Exchange)

- und vieles mehr ...​
:::

::: paragraph
Checkmk zeichnet grundsätzlich alle beim Monitoring anfallenden
Messwerte über einen Zeitraum von (einstellbar) vier Jahren auf, so dass
Sie nicht nur auf die aktuellen, sondern auch auf historische Messwerte
zugreifen können. Um den Bedarf an Plattenplatz in Grenzen zu halten,
werden die Daten mit zunehmendem Alter immer weiter verdichtet.
:::

::: paragraph
Die [Metriken](glossar.html#metric) selbst werden von den einzelnen
[Check-Plugins](glossar.html#check_plugin) ermittelt. Die Plugins legen
somit auch fest, welche Metriken genau bereitgestellt werden.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Oberfläche
für die Visualisierung der historischen Messdaten basiert auf HTML5 und
ist in den kommerziellen Editionen und in Checkmk Raw identisch.
Ausschließlich in den kommerziellen Editionen können Sie erweiterte
Funktionen wie PDF-Export, Graphensammlungen, benutzerdefinierte Graphen
und Anbindung an externe Metrik-Datenbanken nutzen.
:::
::::::::::
:::::::::::

:::::::::::::: sect1
## []{#access .hidden-anchor .sr-only}2. Zugriff über die GUI {#heading_access}

::::::::::::: sectionbody
::: paragraph
Die Messwerte eines Services werden in der GUI in drei verschiedenen
Formen präsentiert. Die sogenannten **Perf-O-Meter** tauchen direkt in
der Tabelle der Hosts oder Services auf und bieten einen schnellen
Überblick und einen optischen Vergleich. Allerdings beschränken sich
diese aus Platzgründen meist auf eine einzelne ausgewählte Metrik. Bei
den Dateisystemen ist dies z.B. der prozentual belegte Platz:
:::

:::: imageblock
::: content
![Ansicht des localhost mit
Perf-O-Meter-Werten.](../images/graphing_filesystems.png)
:::
::::

::: paragraph
Alle Metriken eines Services im **Zeitverlauf** erhalten Sie, wenn Sie
mit der Maus über das [![icon
pnp](../images/icons/icon_pnp.png)]{.image-inline} Graphsymbol fahren
oder es anklicken. Der @-Wert rechts oberhalb der Grafik zeigt dabei an,
in welchem Intervall neue Daten geholt und ergänzt werden. [@
1m]{.guihint} steht zum Beispiel für ein Abfrageintervall von einer
Minute.
:::

::: paragraph
Die gleichen Graphen finden Sie zudem auch ganz einfach in den Details
zu einem Host oder Service:
:::

:::: imageblock
::: content
![Verlaufsgrafik der
CPU-Nutzung.](../images/graphing_cpu_utilization.png)
:::
::::

::: paragraph
In den Details gibt es zudem eine Tabelle mit den aktuellen präzisen
Messwerten für alle Metriken:
:::

:::: imageblock
::: content
![Ausschnitt der
Service-Metriken.](../images/graphing_metrics_table.png)
:::
::::
:::::::::::::
::::::::::::::

:::::::::::: sect1
## []{#interaction .hidden-anchor .sr-only}3. Interaktion mit dem Graphen {#heading_interaction}

::::::::::: sectionbody
::: paragraph
Sie können die Darstellung des Graphen auf verschiedene Arten interaktiv
beeinflussen:
:::

::: ulist
- Durch Ziehen mit gedrückter Maustaste (*panning* oder *dragging* im
  Englischen) verschieben Sie den Zeitbereich (links/rechts) oder
  skalieren vertikal (hoch/runter).

- Mit dem Mausrad zoomen Sie in die Zeit rein und raus.

- Durch Ziehen an der rechten unteren Ecke verändern Sie die Größe des
  Graphen.

- Ein Klick an eine Stelle im Graphen setzt eine \"Stecknadel\" (den
  *Pin*). Damit erfahren Sie die genaue zeitliche Lage eines Punkts und
  alle präzisen Messwerte zu diesem Zeitpunkt. Der exakte Zeitpunkt des
  Pins wird pro Benutzer gespeichert und in allen Graphen angezeigt.

- Durch Anklicken einer Spaltenüberschrift stellen Sie die angezeigten
  Werte auf Minimum-, Maximum- oder Durchschnittswerte ein.
:::

:::: imageblock
::: content
![Visualisierung möglicher Interaktionen in einem
Graphen.](../images/graphing_pin.png)
:::
::::

::: paragraph
Wenn sich auf einer Seite mehrere Graphen befinden, so folgen auch alle
anderen Graphen auf der Seite den gemachten Änderungen am gewählten
Zeitbereich und des Pins. Somit sind die Werte immer vergleichbar. Auch
eine Größenänderung wirkt sich auf alle Graphen aus. Der Abgleich
geschieht allerdings erst beim nächsten Neuladen der Seite (sonst würde
auch zwischenzeitlich ein ziemliches Chaos auf dem Bildschirm
entstehen ...​).
:::

::: paragraph
Sobald Sie die interaktiven Funktionen nutzen, also beispielsweise einen
Pin setzen, erscheint auf dem Bildschirm ein großes Pause-Symbol und die
Seitenaktualisierung setzt für 60 Sekunden aus. So wird Ihre Änderung im
Graphen nicht sofort durch die Aktualisierung wieder rückgängig gemacht.
Der Countdown wird immer wieder auf 60 Sekunden zurückgesetzt, wenn Sie
erneut aktiv werden. Sie können den Countdown aber auch komplett
abschalten, wenn Sie auf die Zahl klicken. Durch Klick auf das
Pause-Symbol können Sie die Pause jederzeit wieder beenden.
:::

:::: imageblock
::: content
![Das Pause-Symbol in einem Graphen.](../images/graphing_pause.png)
:::
::::
:::::::::::
::::::::::::

::::::::: sect1
## []{#graph_collections .hidden-anchor .sr-only}4. Graphensammlungen (Graph collections) {#heading_graph_collections}

:::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können Sie mit dem [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} Menü, das links
unten im Graphen angezeigt wird, diesen an verschiedenen Stellen
einbetten, z.B. in Berichte oder Dashboards. Sehr nützlich ist dabei der
Menübereich [Add to graph collection]{.guihint}. In so eine
Graphensammlung können Sie beliebig viele Graphen packen und diese dann
später vergleichen oder auch als PDF exportieren. Als Standard hat jeder
Benutzer eine Graphensammlung mit dem Namen [My graphs]{.guihint}. Sie
können aber sehr einfach weitere anlegen und diese sogar für andere
Benutzer sichtbar machen. Das Vorgehen ist dabei exakt das Gleiche wie
bei den [Tabellenansichten](views.html).
:::

::: paragraph
Sie gelangen zu Ihrer Graphensammlung über [Monitor \> Workplace \> My
graphs.]{.guihint} Der Eintrag [My graphs]{.guihint} taucht erst auf,
wenn Sie auch tatsächlich mindestens einen Graphen hinzugefügt haben.
:::

:::: imageblock
::: content
![Auswahl der Graphensammlung im
\'Monitor\'-Menü.](../images/graphing_monitor_menu.png)
:::
::::

::: paragraph
Über [Customize \> Graphs \> Graph collections]{.guihint} kommen Sie zur
Tabelle all Ihrer Graphensammlungen mit der Möglichkeit, weitere
anzulegen, zu ändern usw.
:::
::::::::
:::::::::

:::::::::::: sect1
## []{#graph_tunings .hidden-anchor .sr-only}5. Graphen anpassen (Graph tunings) {#heading_graph_tunings}

::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können Sie kleine Anpassungen an den eingebauten
Graphen vornehmen und zwar über [Customize \> Graphs \> Graph
tunings.]{.guihint} Diese [Graph tunings]{.guihint} ermöglichen Ihnen
zum Beispiel, die Skalierung der Y-Achse für einen bestimmten Graphen zu
verändern, über die Option [Vertical axis scaling:]{.guihint}
:::

:::: imageblock
::: content
![Die Einstellungen zum Anpassen eines
Graphen.](../images/graphing_tunings.png)
:::
::::

::: paragraph
Diese Änderung ließe sich dann auch mit [Apply to]{.guihint} auf
bestimmte Vorkommen des Graphen beschränken, beispielsweise in
Dashboards. Im folgenden Bild sehen Sie eine Skalierung auf den Bereich
*0.5 bis 0.9* in einem PDF-Bericht:
:::

:::: {.imageblock .border}
::: content
![Ansicht einer eingeschränkten
Skalierung.](../images/graphing_tunings_yaxis.png)
:::
::::

::: paragraph
Darüber hinaus stehen Ihnen zwei weitere Optionen zur Verfügung: Über
[Graph visibility]{.guihint} lässt sich ein Graph an bestimmten Orten
explizit ein- oder ausblenden. Und [Vertical axis mirroring]{.guihint}
ist nützlich bei Graphen, die Daten ober- und unterhalb der Zeitleiste
(X-Achse) zeigen, wie etwa der Graph [Disk throughput](#disk_throughput)
weiter unten: Dort lassen sich die Daten spiegeln, so dass also die
vormals oberen Daten unterhalb der Zeitleiste angezeigt werden und
umgekehrt.
:::

::: paragraph
**Hinweis:** Die Temperaturmaßeinheiten von Graphen und Perf-O-Metern
können Nutzer individuell über ihr
[Profil](user_interface.html#user_menu) festlegen. Die allgemeine
Anpassung für Zusammenfassungen und Detailansichten erledigen Sie über
den [Service-Regelsatz](wato_rules.html#checkparameters)
[Temperature.]{.guihint}
:::
:::::::::::
::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#custom_graphs .hidden-anchor .sr-only}6. Benutzerdefinierte Graphen (Custom graphs) {#heading_custom_graphs}

::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen bieten einen grafischen Editor, mit dem Sie komplett eigene
Graphen mit eigenen Berechnungsformeln erstellen können. Damit ist es
auch möglich, Metriken von verschiedenen Hosts und Services in einem
Graphen zu kombinieren.
:::

::: paragraph
Zu den benutzerdefinierten Graphen gelangen Sie z.B. über [Customize \>
Graphs \> Custom graphs.]{.guihint} Ein anderer Weg geht über die
Metrik-Tabelle bei einem Service. Dort gibt es bei jeder Metrik ein
[![icon menu](../images/icons/icon_menu.png)]{.image-inline} Menü mit
einem Eintrag, um die Metrik zu einem benutzerdefinierten Graphen
hinzuzufügen:
:::

:::: imageblock
::: content
![Auswahloptionen für benutzerdefinierte
Graphen.](../images/graphing_new_custom.png)
:::
::::

::: paragraph
Folgende Abbildung zeigt die Liste der benutzerdefinierten Graphen (hier
mit nur einem Eintrag):
:::

:::: imageblock
::: content
![Übersicht der beutzerdefinierten
Graphen.](../images/custom_graph_list.png)
:::
::::

::: paragraph
Bei jedem vorhandenen Graphen haben Sie fünf mögliche Operationen:
:::

+------+---------------------------------------------------------------+
| [![  | Zeigt den Graphen an.                                         |
| icon |                                                               |
| cu   |                                                               |
| stom |                                                               |
| g    |                                                               |
| raph |                                                               |
| ](.. |                                                               |
| /ima |                                                               |
| ges/ |                                                               |
| icon |                                                               |
| s/ic |                                                               |
| on_c |                                                               |
| usto |                                                               |
| m_gr |                                                               |
| aph. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Erzeugt eine Kopie dieses Graphen.                            |
| icon |                                                               |
| inse |                                                               |
| rt]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _ins |                                                               |
| ert. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Löscht den Graphen.                                           |
| icon |                                                               |
| dele |                                                               |
| te]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _del |                                                               |
| ete. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Öffnet die Eigenschaften dieses Graphen. Hier können Sie      |
| icon | neben dem Titel auch Einstellungen zur Sichtbarkeit für       |
| edit | andere Benutzer festlegen. Alles verhält sich exakt wie bei   |
| ](.. | den [Tabellenansichten](views.html). Wenn Sie Fragen zu einer |
| /ima | der Einstellungen haben, können Sie sich die kontextsensitive |
| ges/ | Hilfe einblenden lassen mit [Help \> Show inline              |
| icon | help.]{.guihint}                                              |
| s/ic |                                                               |
| on_e |                                                               |
| dit. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Hier gelangen Sie zum [Graphdesigner](#graph_designer), mit   |
| icon | dem Sie die Inhalte verändern können.                         |
| cu   |                                                               |
| stom |                                                               |
| g    |                                                               |
| raph |                                                               |
| ](.. |                                                               |
| /ima |                                                               |
| ges/ |                                                               |
| icon |                                                               |
| s/ic |                                                               |
| on_c |                                                               |
| usto |                                                               |
| m_gr |                                                               |
| aph. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+

::: paragraph
Beachten Sie, dass jeder benutzerdefinierte Graph --- analog zu den
Ansichten --- eine eindeutige ID hat. Über diese wird der Graph in
Berichten und Dashboards angesprochen. Wenn Sie die ID eines Graphen
später ändern, gehen dadurch solche Referenzen verloren. Alle Graphen,
die nicht [hidden]{.guihint} sind, werden standardmäßig unter [Monitor
\> Workplace]{.guihint} angezeigt.
:::

:::::: sect2
### []{#graph_designer .hidden-anchor .sr-only}6.1. Der Graphdesigner {#heading_graph_designer}

:::: imageblock
::: content
![Gesamtansicht des
Graphdesigners.](../images/graphing_custom_graphs.png)
:::
::::

::: paragraph
Der Graphdesigner ist in vier Bereiche unterteilt:
:::
::::::

:::: sect2
### []{#graph_preview .hidden-anchor .sr-only}6.2. Vorschau des Graphen {#heading_graph_preview}

::: paragraph
Hier sehen Sie den Graphen exakt so, wie er auch später zu sehen sein
wird. Sie können alle interaktiven Funktionen nutzen.
:::
::::

:::::::: sect2
### []{#list_metrics .hidden-anchor .sr-only}6.3. Liste der Metriken {#heading_list_metrics}

::: paragraph
Die im Graphen enthaltenen Kurven können hier direkt bearbeitet werden.
Eine Änderung des Titels einer Kurve in diesem Feld bestätigen Sie mit
der Enter-Taste. Der [Style]{.guihint} legt fest, wie der Wert im
Graphen optisch gezeichnet wird. Dabei gibt es folgende Möglichkeiten:
:::

+-------------+--------------------------------------------------------+
| [Line       | Der Wert wird als Linie eingezeichnet.                 |
| ]{.guihint} |                                                        |
+-------------+--------------------------------------------------------+
| [Area       | Der Wert wird als Fläche eingezeichnet. Beachten Sie,  |
| ]{.guihint} | dass die Kurven Vorrang haben, die weiter oben in der  |
|             | Liste stehen, und so Kurven überdecken können, die     |
|             | weiter unten stehen. Wenn Sie Linien und Flächen       |
|             | kombinieren möchten, sollten die Flächen immer unten   |
|             | stehen.                                                |
+-------------+--------------------------------------------------------+
| [Stacked    | Alle Kurven dieses Stils werden als Flächen gezeichnet |
| Area        | und vom Wert her aufeinander gestapelt (also quasi     |
| ]{.guihint} | addiert). Die obere Grenze dieses Stapels symbolisiert |
|             | also die Summe aller beteiligten Kurven.               |
+-------------+--------------------------------------------------------+

::: paragraph
Die weiteren drei Möglichkeiten [Mirrored Line]{.guihint}, [Mirrored
Area]{.guihint} und [Mirrored Stacked]{.guihint} funktionieren analog,
nur dass die Kurven von der Nulllinie aus nach unten gezeichnet werden.
Das ermöglicht eine Art von Graph, wie sie Checkmk generell für
Input/Output-Graphen wie den folgenden verwendet:
:::

:::: {#disk_throughput .imageblock}
::: content
![Ein Input/Output-Graph.](../images/graphing_input_output.png)
:::
::::

::: paragraph
In der Spalte [Actions]{.guihint} finden Sie zu jeder angelegten Metrik
einen [![button clone](../images/icons/button_clone.png)]{.image-inline}
Knopf zum Klonen derselben. So können Sie fix Kurven kopieren und
schlicht etwa den Host-Namen austauschen.
:::
::::::::

:::::::::: sect2
### []{#adding_metrics .hidden-anchor .sr-only}6.4. Hinzufügen einer Metrik {#heading_adding_metrics}

::: paragraph
Über den [Metrics]{.guihint} Kasten können Sie neue Metriken zum Graphen
hinzufügen. Sobald Sie in das erste Feld einen Host-Namen ausgewählt
haben, wird das zweite Feld mit der Liste der Services des Hosts
gefüllt. Eine Auswahl in dieser Liste füllt das dritte Feld mit der
Liste der Metriken dieses Services. Im vierten und letzten Feld wählen
Sie die **Konsolidierungsfunktion**. Zur Auswahl stehen
[Minimum]{.guihint}, [Maximum]{.guihint} und [Average]{.guihint}. Diese
Funktionen kommen immer dann zur Anwendung, wenn die Speicherung der
Daten in den [RRDs](#data_rrds) für den gewählten Zeitraum bereits
verdichtet ist. In einem Bereich, wo z.B. nur noch ein Wert pro halber
Stunde zur Verfügung steht, können Sie so wählen, ob Sie den größten,
kleinsten oder durchschnittlichen Originalmesswert dieses Zeitraums
einzeichnen möchten.
:::

:::: imageblock
::: content
![Auswahl der Optionen zu einer Metrik.](../images/graphing_metrics.png)
:::
::::

::: paragraph
Auf die gleiche Art blenden Sie über die Funktion [Add new
scalar]{.guihint} die Werte eines Services für [WARN]{.state1},
[CRIT]{.state2}, Maximum und Minimum als waagerechte Linien ein.
:::

:::: imageblock
::: content
![Ansicht einer Konstanten in einer
Metrik.](../images/graphing_scalar.png)
:::
::::

::: paragraph
Sie können dem Graphen auch eine **Konstante** hinzufügen. Diese wird
dann zunächst als waagerechte Linie angezeigt. Konstanten sind manchmal
nötig zur Bildung von Berechnungsformeln. Dazu später
[mehr.](#calculation)
:::
::::::::::

::::: sect2
### []{#graph_options .hidden-anchor .sr-only}6.5. Graphoptionen {#heading_graph_options}

::: paragraph
Hier finden Sie Optionen, die den Graphen als Ganzes betreffen. Die
Einheit ([Unit]{.guihint}) beeinflusst die Beschriftung der Achsen und
der Legende. Sie wird automatisch eingestellt, sobald die erste Metrik
hinzugefügt wird. Beachten Sie, dass es zwar möglich, aber nicht sehr
sinnvoll ist, zwei Metriken mit unterschiedlichen Einheiten in einem
Graphen unterzubringen.
:::

::: paragraph
Unter [Explicit vertical range]{.guihint} können Sie den vertikalen
Bereich des Graphen voreinstellen. Normalerweise wird die Y-Achse so
skaliert, dass alle Messwerte im gewählten Zeitraum genau in den Graphen
passen. Wenn Sie einen Graphen für z.B. einen Prozentwert entwerfen,
könnten Sie sich aber auch entscheiden, dass immer von 0 bis 100
dargestellt wird. Beachten Sie dabei, dass der Graph vom Benutzer (und
auch Ihnen selbst) trotzdem mit der Maus skaliert werden kann und die
Einstellung dann wirkungslos wird.
:::
:::::

:::::::::::: sect2
### []{#calculation .hidden-anchor .sr-only}6.6. Rechnen mit Formeln {#heading_calculation}

::: paragraph
Der Graphdesigner ermöglicht es Ihnen, die einzelnen Kurven durch
Rechenoperationen zu kombinieren. Folgendes Beispiel zeigt einen Graphen
mit zwei Kurven: CPU utilization [User]{.guihint} und
[System]{.guihint}.
:::

::: paragraph
Nehmen wir an, dass Sie für diesen Graphen nur die Summe von beiden
interessiert. Dazu wählen Sie zunächst die beiden Kurven durch Ankreuzen
ihrer Checkboxen aus. Sobald Sie das tun, erscheinen im Kasten
[Metrics]{.guihint} in der Zeile [Operation on selected
metrics]{.guihint} Knöpfe für alle wählbaren Verknüpfungen:
:::

:::: imageblock
::: content
![Zusätzliche Optionen in der Übersicht zu einem
Graphen.](../images/graphdesigner_ops_1.png)
:::
::::

::: paragraph
Ein Klick auf [Sum]{.guihint} kombiniert die beiden gewählten Zeilen zu
einer neuen Kurve, deren Farbe der obersten ausgewählten Metrik
entspricht. Der Titel der neuen Kurve wird zu [Sum of System,
User]{.guihint}. Die Berechnungsformel wird in der Spalte
[Formula]{.guihint} angezeigt. Außerdem taucht ein neues [![button
dissolve
operation](../images/icons/button_dissolve_operation.png)]{.image-inline}
Symbol auf:
:::

:::: imageblock
::: content
![Ansicht eines Graphen für kombinierte
Werte.](../images/graphdesigner_ops_2.png)
:::
::::

::: paragraph
Durch einen Klick auf [![button dissolve
operation](../images/icons/button_dissolve_operation.png)]{.image-inline}
machen Sie die Operation quasi rückgängig, in dem Sie die Formel wieder
auflösen und die einzelnen enthaltenen Kurven wieder zum Vorschein
kommen. Weitere Hinweise zu den Rechenoperationen:
:::

::: ulist
- Manchmal ist es sinnvoll, Konstanten hinzuzufügen, um z.B. den Wert
  einer Kurve von der Zahl 100 abzuziehen.

- Skalare können ebenfalls für Berechnungen genutzt werden.

- Sie können die Operationen beliebig verschachteln.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#graphing_api .hidden-anchor .sr-only}7. InfluxDB, Graphite und Grafana {#heading_graphing_api}

::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie eine der
kommerziellen Editionen einsetzen, so können Sie parallel zum in Checkmk
eingebauten Graphing auch externe Metrikdatenbanken anbinden und die
[Metriken an InfluxDB oder Graphite senden.](metrics_exporter.html)
:::

::: paragraph
In allen Editionen ist es außerdem möglich, [Checkmk in Grafana zu
integrieren](grafana.html) und Metriken aus Checkmk in Grafana abrufen
und anzeigen zu lassen.
:::
:::::
::::::

::::::::::::::::::::::::::::::: sect1
## []{#historical_data .hidden-anchor .sr-only}8. Historische Messwerte in Tabellen {#heading_historical_data}

:::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_um_was_geht_es .hidden-anchor .sr-only}8.1. Um was geht es? {#heading__um_was_geht_es}

::: paragraph
Wenn Sie die Messwerte der Vergangenheit betrachten, sind Sie manchmal
nicht an deren genauem Verlauf interessiert, sondern eventuell nur an
einer groben Zusammenfassung wie: *Die durchschnittliche CPU-Auslastung
der letzten 7 Tage*. Das Ergebnis wäre dann einfach eine Zahl als
Prozentwert wie 88 %.
:::

::: paragraph
Sie können in einer Tabelle von Hosts oder Services Spalten hinzufügen,
welche den Durchschnitt, das Minimum, das Maximum oder andere
Zusammenfassungen einer Metrik über einen bestimmten Zeitraum als Zahl
darstellen. Das ermöglicht Ihnen dann auch Auswertungen, die nach diesen
Spalten sortieren und so z.B. die Liste derjenigen
[ESXi-Hosts](monitoring_vmware.html) anzeigen, die im Vergleichszeitraum
die geringste Auslastung hatten.
:::

::: paragraph
Um solche Messwerte in einer Ansicht anzuzeigen, gehen Sie so vor:
:::

::: {.olist .arabic}
1.  Wählen Sie eine bestehende Ansicht oder erstellen Sie eine neue.

2.  Fügen Sie eine Spalte vom Typ [Services: Metric History]{.guihint}
    hinzu.
:::
:::::::

::::::: sect2
### []{#_ansicht_erstellen .hidden-anchor .sr-only}8.2. Ansicht erstellen {#heading__ansicht_erstellen}

::: paragraph
Zunächst benötigen Sie eine Ansicht, zu welcher die Spalten hinzugefügt
werden sollen. Dies kann entweder eine Ansicht von Hosts oder von
Services sein. Einzelheiten zum Anlegen oder Editieren von Ansichten
finden Sie in dem [Artikel über Ansichten](views.html#edit).
:::

::: paragraph
Für das folgende Beispiel wählen wir die Ansicht [All hosts]{.guihint},
die Sie über [Monitor \> Hosts \> All hosts]{.guihint} öffnen können.
Wählen Sie im Menü [Display \> Customize view]{.guihint}. Das führt Sie
zur Seite [Clone view]{.guihint}, mit der Sie sich die Ansicht nach
Belieben zurechtkonfigurieren können.
:::

::: paragraph
Damit das Original [All hosts]{.guihint} nicht durch die Kopie
überlagert wird, wählen Sie eine neue ID und auch einen neuen Titel,
unter der die Ansicht später im [Monitor]{.guihint}-Menü angezeigt wird.
:::

::: paragraph
Dann entfernen Sie (optional) alle Spalten, die die Anzahl der Services
in den verschiedenen Zuständen zeigen.
:::
:::::::

::::::::::::::::::: sect2
### []{#_spalte_hinzufügen .hidden-anchor .sr-only}8.3. Spalte hinzufügen {#heading__spalte_hinzufügen}

::: paragraph
Fügen Sie nun eine neue Spalte vom Typ [Services: Metric
History]{.guihint} hinzu. Da dies eine Spalte für Services ist,
benötigen Sie im Falle einer Host-Ansicht als erste Auswahl den
Spaltentyp [Joined column]{.guihint}, welcher das Anzeigen einer
Service-Spalte in einer Host-Tabelle ermöglicht. Bei einer
Service-Ansicht reicht es, wenn Sie eine neue [Column]{.guihint}
hinzufügen.
:::

:::: imageblock
::: content
![Optionen für das Hinzufügen einer weiteren
Spalte.](../images/graphing_historic_metrics_2.png)
:::
::::

::: paragraph
In [Metric]{.guihint} wählen Sie den Namen der Metrik aus, die
historisch ausgewertet werden soll. Sollten Sie unsicher über den Namen
der Metrik sein, finden Sie diesen in den Service-Details beim Eintrag
[Service Metrics]{.guihint}:
:::

:::: imageblock
::: content
![Ansicht der Service-Details.](../images/graphing_metrics_table.png)
:::
::::

::: paragraph
Im Beispiel wählen wir die Metrik [CPU utilization]{.guihint}, welche
hier **zufällig** gleich lautet wie der Name des Services.
:::

::: paragraph
Bei [RRD consolidation]{.guihint} wählen Sie am besten den gleichen Wert
wie weiter unten bei [Aggregation function]{.guihint}, da es wenig
sinnvoll ist, Dinge wie „das Minimum vom Maximum" zu berechnen. Was es
mit der Auswahlmöglichkeit bei RRDs auf sich hat, erfahren Sie im
folgenden Kapitel über die [Organisation der RRD-Daten](#data_rrds).
:::

::: paragraph
Der [Time range]{.guihint} ist der Zeitraum in der Vergangenheit, über
den Sie etwas erfahren wollen. In Beispiel sind es die letzten sieben
Tage, was exakt 168 Stunden entspricht.
:::

::: paragraph
[Column title]{.guihint} ist dann der Spaltentitel, also zum Beispiel
`Util @ 7 days`. Wundern Sie sich nicht, dass später noch ein Feld mit
dem Namen [Title]{.guihint} kommt. Dieses sehen Sie nur dann, wenn hier
eine [Joined column]{.guihint} benutzt wird, welche immer die Angabe
eines Titels ermöglicht. Lassen Sie den zweiten Titel einfach leer.
:::

::: paragraph
Zu guter Letzt geben Sie im Feld [Of Service]{.guihint} den Namen des
Services ein, zudem die oben gewählte Metrik gehört. Achten Sie auf die
exakte Schreibweise des Services inklusive Groß- und Kleinschreibung.
:::

::: paragraph
Nach dem Speichern erhalten Sie jetzt eine neue Ansicht mit einer
weiteren Spalte, welche die prozentuale CPU-Auslastung der letzten
sieben Tage anzeigt:
:::

:::: imageblock
::: content
![Host-Übersicht mit der zusätzlichen Spalte für die
CPU-Auslastung.](../images/graphing_historic_metrics_3.png)
:::
::::

::: paragraph
**Hinweise**
:::

::: ulist
- Sie können natürlich auch mehrere Spalten auf diese Art hinzufügen,
  z.B. für unterschiedliche Metriken oder unterschiedliche Zeiträume.

- Bei Hosts, welche die Metrik oder den Service nicht haben, bleibt die
  Spalte leer.

- Falls Sie mit einer Tabelle von Services arbeiten, benötigen Sie keine
  [Joined Column]{.guihint}. Allerdings können Sie dann pro Host in
  einer Zeile nur einen Service anzeigen.
:::
:::::::::::::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#rrds .hidden-anchor .sr-only}9. Die Round-Robin-Datenbanken (RRDs) {#heading_rrds}

::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk speichert alle Messwerte in dafür eigens entwickelten
Datenbanken, sogenannten **Round-Robin-Datenbanken** (RRDs). Dabei kommt
das [RRDtool von Tobi Oetiker](https://oss.oetiker.ch/rrdtool/) zum
Einsatz, welches in Open-Source-Projekten sehr beliebt und weit
verbreitet ist.
:::

::: paragraph
Die RRDs bieten gegenüber klassischen SQL-Datenbanken bei der
Speicherung von Messwerten wichtige Vorteile:
:::

::: ulist
- RRDs speichern die Messdaten sehr kompakt und effizient.

- Der Platzbedarf auf der Platte pro Metrik ist statisch. RRDs können
  weder wachsen noch schrumpfen. Der benötigte Plattenplatz kann gut
  geplant werden.

- Die benötigte CPU- und Disk-Zeit pro Update ist immer gleich. RRDs
  sind (nahezu) echtzeitfähig, da es nicht zu Staus aufgrund von
  Reorganisationen kommen kann.
:::

:::::::: sect2
### []{#data_rrds .hidden-anchor .sr-only}9.1. Organisation der Daten in den RRDs {#heading_data_rrds}

::: paragraph
Checkmk ist so voreingestellt, dass der Verlauf jeder Metrik über einen
Zeitraum von **vier Jahren** aufgezeichnet wird. Die Grundauflösung ist
dabei eine Minute. Dies ist deswegen sinnvoll, weil das Check-Intervall
auf eine Minute voreingestellt ist und so von jedem Service genau einmal
pro Minute neue Messwerte kommen.
:::

::: paragraph
Nun kann sich allerdings jeder ausrechnen, dass die Speicherung von
einem Wert pro Minute über vier Jahre eine enorme Menge an Plattenplatz
benötigen würde (obwohl die RRDs pro Messwert nur genau 8 Bytes
benötigen). Aus diesem Grund werden die Daten mit der Zeit
**verdichtet**. Die erste Verdichtung findet nach 48 Stunden statt. Ab
diesem Zeitpunkt wird nur noch ein Wert pro fünf Minuten aufbewahrt. Die
übrigen Stufen werden nach 10 Tagen und 90 Tagen umgesetzt:
:::

+-----------------+-----------------+-----------------+-----------------+
| Phase           | Dauer           | Auflösung       | Messwerte       |
+=================+=================+=================+=================+
| 1               | 2 Tage          | 1 Minute        | 2880            |
+-----------------+-----------------+-----------------+-----------------+
| 2               | 10 Tage         | 5 Minuten       | 2880            |
+-----------------+-----------------+-----------------+-----------------+
| 3               | 90 Tage         | 30 Minuten      | 4320            |
+-----------------+-----------------+-----------------+-----------------+
| 4               | 4 Jahre         | 6 Stunden       | 5840            |
+-----------------+-----------------+-----------------+-----------------+

::: paragraph
Jetzt stellt sich natürlich die Frage, wie denn nun fünf Werte sinnvoll
zu einem einzigen konsolidiert werden sollen. Als
Konsolidierungsfunktionen bieten sich das **Maximum**, das **Minimum**
oder der **Durchschnitt** an. Was in der Praxis sinnvoll ist, hängt von
der Anwendung oder Betrachtungsweise ab. Möchten Sie z.B. den
Temperaturverlauf in einem Rechenzentrum über vier Jahre beobachten,
wird Sie wahrscheinlich eher die maximale Temperatur interessieren, die
je erreicht wurde. Bei der Messung von Zugriffszahlen auf eine Anwendung
könnte der Durchschnitt interessieren.
:::

::: paragraph
Um maximal flexibel bei der späteren Auswertung zu sein, sind die RRDs
von Checkmk so voreingestellt, dass sie einfach jeweils **alle drei**
Werte speichern --- also Minimum, Maximum und Durchschnitt. Pro
Verdichtungsstufe und Konsolidierungsfunktion enthält die RRD einen
ringförmigen Speicher --- ein sogenanntes Round-Robin-Archiv (RRA). Im
Standardaufbau gibt es insgesamt 12 RRAs. So benötigt das Standardschema
von Checkmk genau 384 952 Bytes pro Metrik. Das ergibt sich aus 2880 +
2880 + 4320 + 5840 Messpunkten mal drei Konsolidierungsfunktionen mal
acht Bytes pro Messwert, was genau 382 080 Bytes ergibt. Addiert man den
Dateiheader von 2872 Bytes hinzu, ergibt sich die oben angegebene Größe
von 384 952 Bytes.
:::

::: paragraph
Ein interessantes alternatives Schema wäre z.B. das Speichern von einem
Wert pro Minute für ein komplettes Jahr. Dabei kann man einen kleinen
Vorteil ausnutzen: Da die RRDs dann zu allen Zeiten die optimale
Auflösung haben, können Sie auf die Konsolidierung verzichten und z.B.
nur noch *Average* anlegen. So kommen Sie auf 365 x 24 x 60 Messwerte zu
je 8 Bytes, was ziemlich genau 4 MB pro Metrik ergibt. Auch wenn die
RRDs somit mehr als den zehnfachen Platz benötigen, ist die nötige
\"Disk I/O\" sogar reduziert! Der Grund: Ein Update muss nicht mehr in
12 verschiedene RRAs geschrieben werden, sondern nur noch in eines.
:::
::::::::

::::::::::::::: sect2
### []{#customise_rrds .hidden-anchor .sr-only}9.2. Anpassen des RRD-Aufbaus {#heading_customise_rrds}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Ihnen das
voreingestellte Speicherschema nicht zusagt, so können Sie dieses über
[Regelsätze](glossar.html#rule_set) ändern (sogar für Hosts oder
Services unterschiedlich). Den nötigen Regelsatz finden Sie am
einfachsten über die Regelsuche --- also das Menü [Setup]{.guihint}.
Geben Sie dort einfach `RRD` in das Suchfeld ein. So finden Sie den
Regelsatz [Configuration of RRD databases of services]{.guihint}. Es
gibt auch einen analogen Regelsatz für Hosts, aber Hosts haben nur in
Ausnahmefällen Messwerte. Folgendes Bild zeigt die Regel mit den
Standardeinstellungen:
:::

:::: imageblock
::: content
![Regeleinstellungen für eine
RRD.](../images/graphing_rrd_configuration.png)
:::
::::

::: paragraph
In den Abschnitten [Consolidation functions]{.guihint} und [RRA
configuration]{.guihint} können Sie die Anzahl und Größe der
Verdichtungsphasen bestimmen und festlegen, welche Konsolidierungen
bereit gehalten werden sollen. Das Feld [Step (precision)]{.guihint}
bestimmt die Auflösung in Sekunden, in der Regel 60 (eine Minute). Für
Services mit einem Check-Interval von kleiner als einer Minute kann es
sinnvoll sein, diese Zahl kleiner einzustellen. Beachten Sie dabei, dass
die Angaben im Feld [Number of steps aggregated into one data
point]{.guihint} dann nicht mehr Minuten bedeuten, sondern die in [Step
(precision)]{.guihint} eingestellte Zeitspanne.
:::

::: paragraph
Jede Änderung des RRD-Aufbaus hat zunächst nur Einfluss auf **neu
angelegte** RRDs --- sprich wenn Sie neue Hosts oder Services in das
Monitoring aufnehmen. Sie können aber die bestehenden RRDs von Checkmk
umbauen lassen. Dazu dient der Befehl `cmk --convert-rrds`, bei welchem
sich immer die Option `-v` (verbose) anbietet. Checkmk kontrolliert dann
alle vorhandenen RRDs und baut diese nach Bedarf in das eingestellte
Zielformat um.
:::

::: paragraph
**Wichtig:** Um die Integrität der in den RRDs enthaltenen Daten
sicherzustellen, stoppen Sie stets Ihre Instanz (mit `omd stop`)
**bevor** Sie mit `cmk --convert-rrds` existierende RRDs konvertieren.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --convert-rrds
myserver012:
  Uptime (CMC).....converted, 376 KB -> 159 KB
  Filesystem / (CMC).....converted, 1873 KB -> 792 KB
  OMD mysite apache (CMC).....converted, 14599 KB -> 6171 KB
  Memory (CMC).....converted, 14225 KB -> 6012 KB
  Filesystem /home/user (CMC).....converted, 1873 KB -> 792 KB
  Interface 2 (CMC).....converted, 4119 KB -> 1741 KB
  CPU load (CMC).....converted, 1125 KB -> 475 KB
```
:::
::::

::: paragraph
Der Befehl ist intelligent genug, um RRDs zu erkennen, die bereits den
richtigen Aufbau haben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --convert-rrds
myserver345:
  Uptime (CMC).....uptodate
  Filesystem / (CMC).....uptodate
  OMD mysite apache (CMC).....uptodate
  Memory (CMC).....uptodate
  Filesystem /home/user (CMC).....uptodate
  Interface 2 (CMC).....uptodate
  CPU load (CMC).....uptodate
```
:::
::::

::: paragraph
Wenn das neue Format eine höhere Auflösung oder zusätzliche
Konsolidierungsfunktionen hat, werden die bestehenden Daten so gut es
geht interpoliert, so dass die RRDs mit möglichst sinnvollen Werten
gefüllt werden. Nur ist natürlich klar, dass wenn Sie z.B ab sofort
nicht 2 sondern 5 Tage mit minutengenauen Werten haben möchten, die
Genauigkeit der bestehenden Daten nicht nachträglich erhöht werden kann.
:::
:::::::::::::::

::::::::::: sect2
### []{#rrdformat .hidden-anchor .sr-only}9.3. RRD-Speicherformat {#heading_rrdformat}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die oben gezeigte
Regel hat noch eine weitere Einstellung: [RRD storage format]{.guihint}.
Mit dieser können Sie zwischen zwei Methoden wählen, wie Checkmk die
RRDs erzeugt. Das Format [One RRD per host/service]{.guihint} (oder kurz
Checkmk-Format) speichert dabei alle Metriken eines Hosts bzw. Services
in einer einzigen RRD-Datei. Dies sorgt für ein effizienteres Schreiben
der Daten, da so immer ein kompletter Satz an Metriken in einer einzigen
Operation geschrieben werden kann. Diese Metriken liegen dann in
benachbarten Speicherzellen, was die Anzahl der Plattenblöcke reduziert,
die geschrieben werden müssen.
:::

::: paragraph
Sollten Ihre Checkmk-Instanzen mit einer kommerziellen Edition in einer
älteren Version als [1.2.8]{.new} erzeugt worden sein, lohnt sich
gegebenenfalls ein genauer Blick darauf, ob ihre Messdaten jemals in das
aktuelle und weitaus performantere Format konvertiert worden sind.
Sollten die Daten noch im alten Format vorliegen, können Sie diese über
das Anlegen einer Regel im oben gezeigten Regelsatz auf das
Checkmk-Format umstellen.
:::

::: paragraph
Auch hier benötigen Sie anschließend den Befehl `cmk --convert-rrds`,
und auch hier gilt: Stoppen Sie stets Ihre Instanz bevor Sie
existierende RRDs konvertieren.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --convert-rrds
myhost123:
   Uptime PNP -> CMC..converted.
  WARNING: Dupliate RRDs for stable/Uptime. Use --delete-rrds for cleanup.
   OMD mysite apache PNP -> CMC..converted.
  WARNING: Dupliate RRDs for stable/OMD mysite apache. Use --delete-rrds for cleanup.
   fs_/home/user PNP -> CMC..converted.
  WARNING: Dupliate RRDs for stable/fs_/home/user. Use --delete-rrds for cleanup.
   OMD mysite apache PNP -> CMC..converted.
  WARNING: Dupliate RRDs for stable/OMD mysite apache. Use --delete-rrds for cleanup.
   Memory PNP -> CMC..converted.
...
```
:::
::::

::: paragraph
Wie Sie an der Warnung sehen können, lässt Checkmk die bestehenden
Dateien im alten Format zunächst liegen. Dies ermöglicht Ihnen im
Zweifel eine Rückkehr zu diesem Format, weil ein Konvertieren in die
Rückrichtung **nicht** möglich ist. Die Option `--delete-rrds` sorgt
dafür, dass diese Kopien nicht erzeugt bzw. nachträglich gelöscht
werden. Sie können das Löschen bequem später mit einem weiteren Aufruf
des Befehls erledigen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --convert-rrds --delete-rrds
```
:::
::::
:::::::::::

::::::::::::::: sect2
### []{#rrdcached .hidden-anchor .sr-only}9.4. Der RRD-Cache-Daemon (rrdcached) {#heading_rrdcached}

::: paragraph
Um die Anzahl der nötigen Schreibzugriffe auf die Platte (drastisch) zu
reduzieren, kommt ein Hilfsprozess zum Einsatz: der RRD-Cache-Daemon
(`rrdcached`). Er ist einer der Dienste, welche beim Start einer Instanz
gestartet werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Temporary filesystem already mounted
Starting agent-receiver...OK
Starting mkeventd...OK
Starting liveproxyd...OK
Starting mknotifyd...OK
Starting rrdcached...OK
Starting cmc...OK
Starting apache...OK
Starting dcd...OK
Starting redis...OK
Initializing Crontab...OK
```
:::
::::

::: paragraph
Alle neuen Messwerte für die RRDs werden zunächst vom Checkmk Micro Core
(kommerzielle Editionen) bzw. von NPCD (Checkmk Raw) an den `rrdcached`
gesendet. Dieser schreibt die Daten zunächst nicht in die RRDs, sondern
merkt sie sich im Hauptspeicher, um sie später dann gesammelt in die
jeweilige RRD zu schreiben. So wird die Anzahl der Schreibzugriffe auf
die Platte (oder in das SAN!) deutlich reduziert.
:::

::: paragraph
Damit im Falle eines Neustarts keine Daten verloren gehen, werden die
Updates zusätzlich in Journaldateien geschrieben. Dies bedeutet zwar
auch Schreibzugriffe, aber da hier die Daten direkt hintereinander
liegen, wird dadurch kaum IO erzeugt.
:::

::: paragraph
Damit der RRD-Cache-Daemon effizient arbeiten kann, benötigt er
natürlich viel Hauptspeicher. Die benötigte Menge hängt von der Anzahl
Ihrer RRDs ab und davon, wie lange Daten zwischengespeichert werden
sollen. Letzteres können Sie in der Datei `~/etc/rrdcached.conf`
einstellen. Die Standardeinstellung legt eine Speicherung von 7200
Sekunden (zwei Stunden) plus eine Zufallsspanne von 0-1800 Sekunden
fest. Diese zufällige Verzögerung pro RRD verhindert ein pulsierendes
Schreiben und sorgt für eine gleichmäßige Verteilung der IO über die
Zeit:
:::

::::: listingblock
::: title
\~/etc/rrdcached.conf
:::

::: content
``` {.pygments .highlight}
# Tuning settings for the rrdcached. Please refer to rrdcached(1) for
# details. After changing something here, you have to do a restart
# of the rrdcached (reload is not sufficient)

# Data is written to disk every TIMEOUT seconds. If this option is
# not specified the default interval of 300 seconds will be used.
TIMEOUT=3600

# rrdcached will delay writing of each RRD for a random
# number of seconds in the range [0,delay). This will avoid too many
# writes being queued simultaneously. This value should be no
# greater than the value specified in TIMEOUT.
RANDOM_DELAY=1800

# Every FLUSH_TIMEOUT seconds the entire cache is searched for old values
# which are written to disk. This only concerns files to which
# updates have stopped, so setting this to a high value, such as
# 3600 seconds, is acceptable in most cases.
FLUSH_TIMEOUT=7200

# Specifies the number of threads used for writing RRD files. Increasing this
# number will allow rrdcached to have more simultaneous I/O requests into the
# kernel. This may allow the kernel to re-order disk writes, resulting in better
# disk throughput.
WRITE_THREADS=4
```
:::
:::::

::: paragraph
Eine Änderung der Einstellungen in dieser Datei aktivieren Sie mit:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd restart rrdcached
Stopping rrdcached...waiting for termination....OK
Starting rrdcached...OK
```
:::
::::
:::::::::::::::

:::: sect2
### []{#files .hidden-anchor .sr-only}9.5. Dateien und Verzeichnisse {#heading_files}

::: paragraph
Hier ist eine Übersicht über die wichtigsten Dateien und Verzeichnisse,
die mit Messdaten und RRDs zu tun haben (alle bezogen auf das
Home-Verzeichnis der Instanz):
:::

+------------------------+---------------------------------------------+
| Pfadname               | Bedeutung                                   |
+========================+=============================================+
| `~/var/check_mk/rrd`   | RRDs im Checkmk-Format                      |
+------------------------+---------------------------------------------+
| `~/va                  | RRDs im alten Format (PNP)                  |
| r/pnp4nagios/perfdata` |                                             |
+------------------------+---------------------------------------------+
| `~/var/rrdcached`      | Journaldateien des RRD-Cache-Daemons        |
+------------------------+---------------------------------------------+
| `~/                    | Logdatei des RRD-Cache-Daemons              |
| var/log/rrdcached.log` |                                             |
+------------------------+---------------------------------------------+
| `~/var/log/cmc.log`    | Logdatei des Checkmk-Kerns (enthält ggf.    |
|                        | Fehlermeldungen zu RRDs)                    |
+------------------------+---------------------------------------------+
| `~/etc/rrdcached.conf` | Einstellungen für den RRD-Cache-Daemon      |
+------------------------+---------------------------------------------+
::::
:::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
