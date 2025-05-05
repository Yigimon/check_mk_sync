:::: {#header}
# Prognosebasiertes Monitoring

::: details
[Last modified on 14-Dec-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/predictive_monitoring.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Vorhersagegraphen erstellen](forecast_graphs.html) [Messwerte und
Graphing](graphing.html) [Zeitperioden (Time Periods)](timeperiods.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Für Checks, die
Leistungswerte messen, ist es oft schwierig, die richtigen Schwellwerte
festzulegen. Während zu niedrige Werte [WARN]{.state1}- oder
[CRIT]{.state2}-Zustände erzeugen, die nur vermeintlich Probleme
anzeigen, bleibt es bei einer zu hohen Einstellung beim Zustand
[OK]{.state0}, was das Monitoring blind für Probleme macht.
:::

::: paragraph
Nehmen wir als Beispiel den Service [CPU load]{.guihint} eines
Linux-Hosts (oder analog [Processor Queue]{.guihint} eines
Windows-Hosts): Sie haben vielleicht einen Server, der die meiste Zeit
im Leerlauf ist, aber regelmäßig für einige kurze Zeiträume viel
Rechenleistung benötigt. Nehmen wir weiter an, dass jeden Tag außer
samstags und sonntags auf diesem Server von ca. 0:00 bis 7:00 Uhr
morgens einige große Backup-Aufträge laufen. In dieser Zeit ist eine
CPU-Auslastung von 10 (bei 20 Prozessorkernen) völlig normal. In der
restlichen Zeit könnte sogar eine Auslastung von 3 verdächtig hoch sein.
:::

::: paragraph
In Checkmk haben Sie verschiedene Möglichkeiten, dieses Beispiel
abzubilden. Eine davon ist, zuerst die Zeiträume mit unterschiedlicher
Auslastung zu definieren und für diese Zeiten dann spezifische
Schwellwerte festzulegen. Für unser Beispiel bedeutet das, zuerst eine
neue [Zeitperiode](timeperiods.html) für die Zeit mit hoher Auslastung
zu definieren (montags bis freitags von 0:00 bis 7:00 Uhr). Anschließend
können Sie in einer Regel für den Service ([CPU load]{.guihint} bzw.
[Processor Queue]{.guihint}) diese neue Zeitperiode auswählen und für
diese abweichende (höhere) Schwellwerte festlegen.
:::

::: paragraph
Die Nutzung einer Zeitperiode hat den Vorteil, dass immer gut
nachvollziehbar ist, warum ein [WARN]{.state1}-/[CRIT]{.state2}-Zustand
zu einem bestimmten Zeitpunkt auftrat. Allerdings ist die manuelle
Bindung von Schwellwerten an Zeitperioden auch etwas unflexibel und
manchmal auch einfach viel zu umständlich.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Falls Sie eine
der kommerziellen Editionen einsetzen, steht Ihnen aber noch eine
weitere Möglichkeit zu Verfügung, um das Problem zu lösen. Sie heißt
prognosebasiertes Monitoring (*predictive monitoring*), und dabei werden
die Messdaten der Vergangenheit ausgewertet um daraus eine Vorhersage zu
berechnen, wie sich diese in Zukunft verhalten werden.
:::

::: paragraph
Einmal eingerichtet, ist die Vorhersage nicht mehr statisch, sondern
passt sich mit der Zeit der sich ändernden Realität an: Die Prognose von
heute ist übermorgen eine andere, weil übermorgen bereits die realen
Werte von morgen einbezogen sind. Ohne Zeitreisen zu strapazieren kann
man es auch so ausdrücken: Checkmk lernt kontinuierlich dazu. Da die
Schwellwerte für die [WARN]{.state1}-/[CRIT]{.state2}-Zustände stets
relativ zu den prognostizierten Werten festgelegt werden, lernen die
Schwellwerte ebenfalls mit.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_prognosebasiertes_monitoring_einrichten .hidden-anchor .sr-only}2. Prognosebasiertes Monitoring einrichten {#heading__prognosebasiertes_monitoring_einrichten}

:::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_vom_plugin_namen_zum_prognoseparameter .hidden-anchor .sr-only}2.1. Vom Plugin-Namen zum Prognoseparameter {#heading__vom_plugin_namen_zum_prognoseparameter}

::: paragraph
Eine ganze Reihe von Checkmk-Plugins unterstützt das prognosebasierte
Monitoring. Im Folgenden finden Sie einige wichtige Beispiele:
:::

+-------------+--------------------------------------------------------+
| Kategorie   | Plugin-Name                                            |
+=============+========================================================+
| CPU         | [CPU                                                   |
|             | Utilization](https://chec                              |
|             | kmk.com/de/integrations/kernel_util){target="_blank"}\ |
|             | [CPU                                                   |
|             | Load](https://ch                                       |
|             | eckmk.com/de/integrations/cpu_loads){target="_blank"}\ |
|             | [OpenVMS: CPU Utilization and                          |
|             | IO-Wait](https:/                                       |
|             | /checkmk.com/de/integrations/vms_cpu){target="_blank"} |
|             | [UCD SNMP Daemon: CPU                                  |
|             | Utilization](https://chec                              |
|             | kmk.com/de/integrations/ucd_cpu_util){target="_blank"} |
+-------------+--------------------------------------------------------+
| Festplatte  | [Disk                                                  |
|             | Throughput](https://c                                  |
|             | heckmk.com/de/integrations/diskstat){target="_blank"}\ |
|             | [Windows: Disk                                         |
|             | Throughput](https://checkmk.                           |
|             | com/de/integrations/winperf_phydisk){target="_blank"}\ |
|             | [EMC ScaleIO: Volume Size and                          |
|             | Throughput](https://checkmk                            |
|             | .com/de/integrations/scaleio_volume){target="_blank"}\ |
|             | [VMware ESX Host Systems: Disk                         |
|             | Throughput](https://checkmk.com/de/integ               |
|             | rations/esx_vsphere_counters_diskio){target="_blank"}\ |
|             | [AWS EC2: Instance Disk                                |
|             | IO](https://checkmk                                    |
|             | .com/de/integrations/aws_ec2_disk_io){target="_blank"} |
+-------------+--------------------------------------------------------+
| Sc          | [Linux: State of Network                               |
| hnittstelle | Interfaces](https:/                                    |
|             | /checkmk.com/de/integrations/lnx_if){target="_blank"}\ |
|             | [Windows: State and Performance of Network             |
|             | Interfaces](https://che                                |
|             | ckmk.com/de/integrations/winperf_if){target="_blank"}\ |
|             | [Traffic and Status of Network                         |
|             | Interfaces](https://che                                |
|             | ckmk.com/de/integrations/interfaces){target="_blank"}\ |
|             | [Monitor Network Interfaces via Standard MIB Using     |
|             | 64-Bit                                                 |
|             | Counters](http                                         |
|             | s://checkmk.com/de/integrations/if64){target="_blank"} |
+-------------+--------------------------------------------------------+

::: paragraph
Die Einstellungen für das prognosebasierte Monitoring finden Sie an der
gleichen Stelle, an der Sie auch sonst Schwellwerte für einen Service
einstellen. Dort finden Sie --- sofern der betroffene Check dies
unterstützt --- die Auswahl [Predictive Levels (only on CMC).]{.guihint}
:::
:::::

:::::::: sect2
### []{#_eine_regel_für_das_prognosebasierte_monitoring_erstellen .hidden-anchor .sr-only}2.2. Eine Regel für das prognosebasierte Monitoring erstellen {#heading__eine_regel_für_das_prognosebasierte_monitoring_erstellen}

::: paragraph
Für den Service [CPU load]{.guihint} des Linux-Hosts unseres Beispiels
können Sie eine neue Regel mit dem Regelsatz [CPU load (not
utilization!)]{.guihint} unter [Service monitoring rules]{.guihint}
erstellen, den Sie am schnellsten mit der [Suche im
Setup-Menü](user_interface.html#search_setup) finden.
:::

::: paragraph
Im Abschnitt [Value]{.guihint} finden Sie den Parameter auf
Service-Ebene, für den Sie den Wert [Predictive Levels (only on
CMC)]{.guihint} auswählen können:
:::

::::: imageblock
::: content
![Regel mit Auswahl für das prognosebasierte
Monitoring.](../images/predictive_rule_select_only_on_cmc.png)
:::

::: title
Das prognosebasierte Monitoring in einer Regel auswählen
:::
:::::
::::::::

:::::::::::::::::::: sect2
### []{#_referenzwerte_der_vergangenheit_auswählen .hidden-anchor .sr-only}2.3. Referenzwerte der Vergangenheit auswählen {#heading__referenzwerte_der_vergangenheit_auswählen}

::: paragraph
Nach der Auswahl von [Predictive Levels (only on CMC)]{.guihint} werden
die Parameter angezeigt, von denen wir zunächst die ersten beiden
genauer vorstellen werden:
:::

::::: {#predictive_rule_base_parameters .imageblock}
::: content
![Parameter für die Referenzwerte der
Vergangenheit.](../images/predictive_rule_base_parameters.png)
:::

::: title
Blick in die Vergangenheit: Auswahl der Referenzwerte
:::
:::::

::: paragraph
Mit [Base prediction on]{.guihint} legen Sie die Periodizität fest, in
der die Wiederholung der Messdaten zu erwarten ist (monatlich,
wöchentlich, täglich oder stündlich):
:::

::: ulist
- [Day of the month]{.guihint}: Die Messwerte jedes Monatstags werden
  miteinander verglichen, d.h. des 1., 2., 3., ...​ jedes Monats.

- [Day of the week]{.guihint}: Der Vergleich basiert auf den
  Wochentagen, d.h. für jeden Wochentag (montags, dienstags, mittwochs,
  etc.) wird eine andere Prognose erstellt. Dies ist meist die richtige
  Einstellung.

- [Hour of the day]{.guihint}: Es werden die einzelnen Stunden jedes
  Tages verglichen, d.h. die Prognose wiederholt sich täglich.

- [Minute of the hour]{.guihint}: Der Vergleich auf Minutenbasis und die
  stündliche Wiederholung ist in der Regel nur nützlich, um eine
  Prognose zu testen.
:::

::: paragraph
Im nächsten Parameter [Time horizon]{.guihint} geben Sie ein, bis zu wie
vielen Tagen in der Vergangenheit Checkmk die Messdaten auswerten soll.
Checkmk greift dabei auf die in den [RRD-Dateien](graphing.html#rrds)
gespeicherten historischen Daten zu. Obwohl die Messdaten in den
RRD-Dateien 4 Jahre lang gespeichert werden, macht es keinen Sinn, zu
weit in die Vergangenheit zurückzugehen. Zum einen könnten sich die
typischen Werte der jüngeren von denen der älteren Vergangenheit
unterscheiden.
:::

::: paragraph
Zum anderen gibt es, je weiter Sie in die Vergangenheit zurückschauen,
desto weniger Messdaten pro Zeiteinheit für den Vergleich. Das liegt
daran, dass Checkmk die minütlich vorliegenden Messdaten in den
RRD-Dateien *standardmäßig* in drei Phasen verdichtet, um Platz zu
sparen: nach 2, 10 und nach 90 Tagen. Verdichtung bedeutet, dass aus
mehreren Messdaten das Minimum, das Maximum und der Durchschnitt
berechnet werden und diese berechneten Daten die ursprünglich gemessenen
Daten ersetzen. Liegen die Messdaten der letzten beiden Tage in der
vollen Auflösung von 1 Minute vor, so beträgt die Auflösung nach 2 Tagen
5 Minuten, nach 10 Tagen 30 Minuten und nach 90 Tagen 6 Stunden. Greift
Checkmk für das prognosebasierte Monitoring auf historische Daten zu,
wird von den drei gespeicherten Werten immer das Maximum genommen.
:::

::: paragraph
Für unseren Beispiel-Server mit der hohen Auslastung Montag bis Freitag
nachts bietet es sich an, die wöchentliche *Referenzperiode* auszuwählen
und einen *Referenzzeitraum* von (maximal) 90 Tagen. 90 Tage sind ein
akzeptabler Kompromiss, da einerseits in diesem Zeitraum genügend
Vergleichstage enthalten sind und andererseits die Messdaten in einer
Auflösung von immerhin noch 30 Minuten vorliegen - sofern die
Default-Werte nicht verändert wurden.
:::

::: paragraph
Wählen Sie als [Base prediction on]{.guihint} den Eintrag [Day of the
week]{.guihint} aus und geben Sie als [Time horizon]{.guihint} `90` ein,
so wie es das [Bild oben](#predictive_rule_base_parameters) zeigt.
:::

::: paragraph
Mit der Festlegung der wöchentlichen Referenzperiode für einen
90-Tage-Zeitraum in der Vergangenheit hat Checkmk die notwendigen
Informationen, um die Referenzkurve zu berechnen. Dabei wird jeder
Montag in der Zeitperiode ausgewertet (bei 90 Tagen sind es 12 Montage),
jeder Messwert eines Montags mit den Messwerten der anderen Montage zur
gleichen Uhrzeit verglichen und der Durchschnitt berechnet. Nach dem
Montag kümmert sich Checkmk in gleicher Weise um die anderen Wochentage
Dienstag bis Sonntag. Die so berechnete Referenzkurve der Vergangenheit
wird dann fortgeschrieben und damit zur prognostizierten Referenzkurve
für die Zukunft.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Werte, die zur Berechnung des |
|                                   | Durchschnitts für die             |
|                                   | Referenzperiode hergenommen       |
|                                   | werden, können selbst bereits     |
|                                   | berechnete (d.h. nicht gemessene) |
|                                   | Werte sein - je nach Auflösung    |
|                                   | der historischen Daten in den     |
|                                   | RRD-Dateien.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die von Checkmk auf Basis der beiden bisher festgelegten Parameter
(Referenzperiode und Referenzzeitraum) berechnete Referenzkurve ist im
folgenden Bild als schwarze Linie gezeichnet:
:::

:::: {.imageblock .border}
::: content
![Prognose-Graph mit zwei Kurven für die prognostizierten und die
aktuellen Werte und farbige Bereiche für die
Zustände.](../images/predictive_graph.png)
:::
::::

::: paragraph
Dieses Bild zeigt als Vorgriff den Prognose-Graphen, den Sie sich nach
der vollständig abgeschlossenen Einrichtung anzeigen lassen können.
Außer der schwarzen Referenzkurve werden die aktuellen Werte als blaue
Linie dargestellt - sofern sie in der dargestellten Zeitperiode
verfügbar sind.
:::

::: paragraph
Was fehlt, um die Einrichtung abzuschließen, sind die Festlegungen der
Schwellwerte für die Zustände [WARN]{.state1} und [CRIT]{.state2}, die
im Graphen mit gelber und roter Hintergrundfarbe markiert sind. Um die
Festlegung dieser Schwellwerte geht es im nächsten Abschnitt.
:::
::::::::::::::::::::

:::::::::::::::::::::::::: sect2
### []{#_schwellwerte_für_die_prognose_festlegen .hidden-anchor .sr-only}2.4. Schwellwerte für die Prognose festlegen {#heading__schwellwerte_für_die_prognose_festlegen}

::: paragraph
Die Schwellwerte für [WARN]{.state1} und [CRIT]{.state2} legen Sie in
Abhängigkeit der in der Referenzkurve abgebildeten prognostizierten
Werte fest.
:::

::::: imageblock
::: content
![Parameter für die Schwellwerte der
Prognose.](../images/predictive_rule_threshold_parameters.png)
:::

::: title
Blick in die Zukunft: Schwellwerte für die Prognose
:::
:::::

::: paragraph
Um die Auswirkung der verschiedenen Parameterwerte zur Festlegung der
Schwellwerte zu verdeutlichen, sehen wir uns einen einzigen Wert auf der
Referenzkurve genau an. Wir nehmen an, dass der prognostizierte Wert des
Services [CPU load]{.guihint} freitags um 3:30 Uhr 10 beträgt.
:::

::: paragraph
Für die oberen Schwellwerte gibt es den Parameter [Dynamic levels -
upper bound]{.guihint}, für die unteren Schwellwerte [Dynamic levels -
lower bound]{.guihint}. Für beide Parameter haben Sie 3
Auswahlmöglichkeiten, die in den folgenden 3 Abschnitten beschrieben
werden.
:::

:::: sect3
#### []{#_absolute_differenz_zur_vorhersage .hidden-anchor .sr-only}Absolute Differenz zur Vorhersage {#heading__absolute_differenz_zur_vorhersage}

::: paragraph
Mit [Absolute difference from prediction]{.guihint} werden die
Schwellwerte berechnet, indem der prognostizierte Wert um einen festen,
absoluten Wert erhöht bzw. vermindert wird. Beispiel: [Warning
at]{.guihint} `2.00` wird dazu führen, dass bei einem Wert über 12 und
unter 8 eine Warnung angezeigt wird.
:::
::::

:::: sect3
#### []{#_relative_differenz_zur_vorhersage .hidden-anchor .sr-only}Relative Differenz zur Vorhersage {#heading__relative_differenz_zur_vorhersage}

::: paragraph
Mit [Relative difference from prediction]{.guihint} werden die
Schwellwerte berechnet, indem der prognostizierte Wert um einen
Prozentsatz erhöht bzw. vermindert wird. Beispiel: [Warning
at]{.guihint} `10.0` % wird dazu führen, dass bei einem Wert über 11 und
unter 9 eine Warnung angezeigt wird.
:::
::::

:::::::: sect3
#### []{#_in_relation_zur_standardabweichung .hidden-anchor .sr-only}In Relation zur Standardabweichung {#heading__in_relation_zur_standardabweichung}

::: paragraph
Mit [In relation to standard deviation]{.guihint} werden die
Schwellwerte berechnet, indem der prognostizierte Wert um ein Vielfaches
der Standardabweichung erhöht bzw. vermindert wird. Die
Standardabweichung gibt an, wie stark sich die Werte in einer
Referenzperiode (z.B. freitags um 3:30 Uhr) unterscheiden.
:::

::: paragraph
Mit dieser Option ist die Berechnung der Schwellwerte nicht so einfach
vorherzusagen, da Checkmk die Standardabweichung aus allen Messwerten
der Referenzperiode intern kalkuliert. Zur Verdeutlichung der Auswirkung
benötigen wir weitere Informationen über die 12 Messwerte der
Referenzperiode freitags um 3:30 Uhr: Wir nehmen an, dass 10 Messwerte
gleich 10 sind, einer 11 und einer 9. Die 12 Messwerte haben also den
Mittelwert von 10 (was dem prognostizierten Wert entspricht), eine
Varianz von ca. 0,167 und eine Standardabweichung von ca. 0,41. (Die
Berechnungsdetails sparen wir uns hier, können aber auf verschiedenen
[Statistikseiten](https://de.statista.com/statistik/lexikon/definition/126/standardabweichung/){target="_blank"}
im Internet nachgelesen werden.)
:::

::: paragraph
Beispiel: [Warning at]{.guihint} `1.00` als Vielfaches der
Standardabweichung wird dazu führen, dass bei einem Wert über 10,41 und
unter 9,59 eine Warnung angezeigt wird.
:::

::: paragraph
Um ungewollte [WARN]{.state1}-/[CRIT]{.state2}-Zustände zu vermeiden,
werden keine Schwellwerte angewendet, wenn die Standardabweichung
undefiniert ist (z. B. weil es nur einen Messwert in der Referenzperiode
gibt) oder Null ist (wenn alle Messwerte identisch sind).
:::

::: paragraph
Allgemein gilt die Regel: Je gleichmäßiger die Werte der Vergangenheit
sind, desto geringer ist die Standardabweichung und desto strikter die
Prognose. Diese Option bietet sich daher an, um Schwellwerte enger zu
definieren für eine Referenzperiode mit stabilen, gleichmäßigen Werten.
:::
::::::::

::::: sect3
#### []{#_mindestwerte_der_oberen_schwellwerte .hidden-anchor .sr-only}Mindestwerte der oberen Schwellwerte {#heading__mindestwerte_der_oberen_schwellwerte}

::: paragraph
Schließlich haben Sie mit [Limit for upper bound dynamic
levels]{.guihint} die Möglichkeit für die oberen Schwellwerte absolute
Mindestwerte vorzugeben. Damit können Sie ungewollte
[WARN]{.state1}-/[CRIT]{.state2}-Zustände vorbeugen für Zeiten, in denen
die prognostizierten Werte sehr niedrig sind.
:::

::: paragraph
Beispiel: Ein [Warning level]{.guihint} von `2.00` wird dazu führen,
dass eine Warnung nur bei einem Wert über 2 angezeigt wird, selbst wenn
der obere Schwellwert für eine Warnung bei 1,5 liegt.
:::
:::::

:::::: sect3
#### []{#_darstellung_der_schwellwerte_im_prognose_graphen .hidden-anchor .sr-only}Darstellung der Schwellwerte im Prognose-Graphen {#heading__darstellung_der_schwellwerte_im_prognose_graphen}

::: paragraph
Die beispielhaft für *einen* Wert beschriebenen Auswirkungen berechnet
Checkmk für *alle* Werte der Referenzkurve. Das Ergebnis sehen Sie im
[Prognose-Graphen](#predictive_graph), der im nächsten Kapitel noch
genauer beschrieben wird. Im Graphen sind ober- und unterhalb der
Referenzkurve die Kurven für die oberen und unteren Schwellwerte
gezeichnet. Die Bereiche für [WARN]{.state1} sind in gelb und für
[CRIT]{.state2} in rot eingefärbt.
:::

::: paragraph
Sie sollten die Bereiche für [WARN]{.state1} und [CRIT]{.state2} im
Prognose-Graphen kritisch überprüfen, insbesondere wenn Sie die
Schwellwerte aus der Standardabweichung berechnen lassen, da sich die
der Standardabweichung zugrundeliegenden Werte nicht direkt aus der
Checkmk-Oberfläche ablesen lassen. Durch die Prüfung und ggf. die
Anpassung der Schwellwerte können Sie vermeiden, dass der Service zu
häufig ungewollt die Zustände [WARN]{.state1} oder [CRIT]{.state2}
annimmt.
:::

::: paragraph
Damit ist die Einrichtung des prognosebasierten Monitoring
abgeschlossen. Im nächsten Kapitel erfahren Sie, wie sich die
Einrichtung im Monitoring bemerkbar macht und wie Sie sich den
Prognose-Graphen anzeigen lassen können.
:::
::::::
::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#_die_prognose_analysieren .hidden-anchor .sr-only}3. Die Prognose analysieren {#heading__die_prognose_analysieren}

:::::::::::::::: sectionbody
::: paragraph
Haben Sie das prognosebasierte Monitoring für einen Service
eingerichtet, die [Änderungen aktiviert](wato.html#activate_changes) und
hat Checkmk danach den Check für den Service einmal ausgeführt, wird das
neue Symbol [![icon
prediction](../images/icons/icon_prediction.png)]{.image-inline} in der
Service-Liste angezeigt:
:::

::::: imageblock
::: content
![Service-Liste mit zwei Einträgen und Symbolen für die Anzeige des
Prognose-Graphen.](../images/predictive_service_list.png)
:::

::: title
Mit dem neuen Symbol lässt sich der Prognose-Graph öffnen
:::
:::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Insbesondere nach der             |
|                                   | Ersteinrichtung für einen Service |
|                                   | kann es vorkommen, dass das       |
|                                   | Symbol fehlt, da noch nicht       |
|                                   | genügend Daten für die            |
|                                   | konfigurierte Prognose            |
|                                   | bereitstehen. In diesem Fall wird |
|                                   | in der Spalte [Summary]{.guihint} |
|                                   | eine Meldung der Art              |
|                                   | `(                                |
|                                   | no reference for prediction yet)` |
|                                   | angezeigt. Sobald genügend Daten  |
|                                   | vorhanden sind, wird sich das     |
|                                   | Problem von selbst erledigen.     |
|                                   | Falls Sie in einer frisch         |
|                                   | aufgesetzten Instanz allerdings   |
|                                   | einen 90-Tage-Zeitraum in der     |
|                                   | Vergangenheit auswerten wollen,   |
|                                   | werden Sie länger warten müssen.  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Klicken Sie in der Service-Liste auf [![icon
prediction](../images/icons/icon_prediction.png)]{.image-inline} und
eine grafische Darstellung des aktuellen Prognosezeitraums, der
Prognose-Graph (*prediction graph*), wird angezeigt:
:::

:::: {#predictive_graph .imageblock .border}
::: content
![Prognose-Graph mit zwei Kurven für die prognostizierten und die
aktuellen Werte und farbige Bereiche für die
Zustände.](../images/predictive_graph.png)
:::
::::

::: paragraph
Im Graphen sehen Sie die Referenzkurve als schwarze Linie, die aktuellen
Werte als blaue Linie und die Bereiche für die Zustände [OK]{.state0} in
weißer, für [WARN]{.state1} in gelber und für [CRIT]{.state2} in roter
Hintergrundfarbe.
:::

::: paragraph
Der dargestellte Zeitraum orientiert sich an der ausgewählten
Referenzperiode. Zum Beispiel können Sie sich bei einer wöchentliche
Periode die einzelnen Wochentage ansehen und mit der Liste über dem
Graphen zu einem anderen Tag wechseln. Mit dem speziellen Listeneintrag
[Everyday]{.guihint} zeigt Ihnen der Graph die Durchschnittswerte aller
Tage, für die Daten verfügbar sind.
:::

::: paragraph
Im Beispielgraphen ist die hohe Auslastung nachts und die niedrige
Auslastung tagsüber zu erkennen. Von 0:00 bis 04:00 Uhr sind die
aktuellen Werte (blaue Linie) niedriger als die prognostizierte
Referenzkurve (schwarze Linie), und zwar so niedrig, dass die unteren
Schwellwerte zeitweise unterschritten wurden und
[WARN]{.state1}-/[CRIT]{.state2}-Zustände ausgelöst haben. Ähnlich ist
das Verhalten im Zeitraum zwischen 08:30 und 23:30 Uhr, in der sich die
blaue Linie konstant im unteren [CRIT]{.state2}-Bereich befindet. Diese
Zustände könnten in Zukunft durch höhere Werte für die unteren
Schwellwerte vermieden werden.
:::

::: paragraph
Schließlich lässt sich aus dem Graphen ablesen, dass die oberen
Schwellwerte auf der Standardabweichung basieren, denn zwischen 05:00
und 07:30 Uhr erhöhen sich tendenziell die oberen Schwellwerte bei
gleichzeitig abnehmenden Werten in der Referenzkurve. Dieses Verhalten
kann nur durch die Standardabweichung erklärt werden, da die anderen
beiden Optionen (absoluter und prozentualer Wert) zu einer Veränderung
der Schwellwerte in Richtung der Referenzkurve geführt hätten.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wie beim erstmaligen Einrichten   |
|                                   | wird auch jede Änderung des       |
|                                   | prognosebasierten Monitoring erst |
|                                   | nach einem neuen Check des        |
|                                   | Services wirksam. Sie brauchen    |
|                                   | auf den nächsten regelmäßigen     |
|                                   | Check nicht zu warten, sondern    |
|                                   | können ihn manuell in der         |
|                                   | Service-Liste anstoßen mit dem    |
|                                   | Symbol [![icon                    |
|                                   | menu](../images/ico               |
|                                   | ns/icon_menu.png)]{.image-inline} |
|                                   | und dem Menüeintrag [Reschedule   |
|                                   | \'Check_MK\' service.]{.guihint}  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::::::
:::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
