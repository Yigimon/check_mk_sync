:::: {#header}
# Metriken an InfluxDB und Graphite senden

::: details
[Last modified on 22-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/metrics_exporter.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Messwerte und Graphing](graphing.html) [Checkmk in Grafana
integrieren](grafana.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::: sectionbody
::: paragraph
[Metriken](glossar.html#metric) sind die mess- und berechenbare Werte zu
Hosts und Services und werden von Checkmk intern in den sogenannten
[Round-Robin-Datenbanken (RRDs)](graphing.html#rrds) gespeichert. Diese
Metriken werden durch das eingebaute Graphing-System aufbereitet und in
der Checkmk-Weboberfläche an vielen Stellen visualisiert, zum Beispiel
als Perf-O-Meter in der Liste der Services oder als Graphen, die Sie
sich aus der Service-Liste mit dem [![Symbol zur Anzeige von
Graphen.](../images/icons/icon_pnp.png)]{.image-inline} Graphsymbol
einblenden lassen können. Die Oberfläche für die Visualisierung der
Metriken basiert auf HTML5 und ist in den kommerziellen Editionen und
Checkmk Raw identisch. Im Artikel zum [Graphing](graphing.html) erfahren
Sie darüber alle Details.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Parallel zum in
Checkmk eingebauten Graphing können Sie zusätzlich auch externe
Metrikdatenbanken anbinden und die Metriken an
[InfluxDB](https://influxdata.com/){target="_blank"} oder
[Graphite](https://graphiteapp.org/){target="_blank"} senden. Da die
Weiterleitung vom Checkmk Micro Core (CMC) durchgeführt wird, ist diese
Funktion nur in den kommerziellen Editionen verfügbar.
:::

::: paragraph
In diesem Artikel erfahren Sie, wie Sie in Checkmk die Weiterleitung der
Metriken zur InfluxDB und zu Graphite einrichten.
:::
::::::
:::::::

::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#influxdb .hidden-anchor .sr-only}2. Metriken an InfluxDB senden {#heading_influxdb}

:::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![InfluxDB-Logo.](../images/influxdb-logo.png){width="120"}
:::
::::

::: paragraph
InfluxDB ist ein Open Source Datenbankmanagementsystem (DBMS) für
Zeitreihen (*time series*) --- und in diesem Segment zurzeit das
populärste. InfluxDB bietet beginnend mit ihrer V2.0 eine neue,
einheitliche API --- die InfluxDB v2 API --- mit der unter anderem
Metrikdaten in die Datenbank geschrieben werden können. Checkmk nutzt
die InfluxDB v2 API und bietet Ihnen die Möglichkeit, die Metriken aus
Checkmk nicht nur an die InfluxDB zu senden, sondern auch passend in die
bestehende Struktur der InfluxDB abzulegen. Durch die Nutzung der API
wird einerseits die Konfiguration für das Versenden der Metrikdaten
vereinfacht und andererseits ist Checkmk vorbereitet für zukünftige
Erweiterungen.
:::

::: paragraph
**Wichtig:** Die in diesem Kapitel beschriebene Konfiguration gilt nur
für die Anbindung einer InfluxDB V2.0 (oder neuer), da erst ab dieser
Version die InfluxDB v2 API verfügbar ist. Falls Sie eine InfluxDB \<=
V1.8 einsetzen, dann richten Sie diese stattdessen so wie im
[Kapitel](#graphite) zur Graphite-Anbindung beschrieben ein, da InfluxDB
bis zur V1.8 das Carbon-Protokoll von
[Graphite](https://docs.influxdata.com/influxdb/v1.8/supported_protocols/graphite/){target="_blank"}
unterstützt.
:::

:::::: sect2
### []{#influxdb_collect .hidden-anchor .sr-only}2.1. Informationen sammeln {#heading_influxdb_collect}

::: paragraph
Bevor Sie mit der Einrichtung in Checkmk loslegen, sollten Sie sich die
folgenden Informationen besorgen über das InfluxDB-Zielsystem, das Sie
mit Checkmk verbinden möchten:
:::

+--------------------+-------------------------------------------------+
| Parameter          | Bedeutung                                       |
+====================+=================================================+
| Host-Name          | Name (oder IP-Adresse) des InfluxDB-Servers.    |
|                    | Die Eingabe des DNS-Namens ist vor allem dann   |
|                    | wichtig, wenn die Verbindung über HTTPS         |
|                    | verschlüsselt wird, da Zertifikate fast nie für |
|                    | IP-Adressen ausgestellt werden.                 |
+--------------------+-------------------------------------------------+
| Port-Nummer        | Nummer des TCP Ports, über den der              |
|                    | InfluxDB-Server erreichbar ist. Der             |
|                    | Standard-Port ist `8086`. Beim Start mit        |
|                    | `influxd` kann mit der Option                   |
|                    | `--http-bind-address` auch ein anderer Port     |
|                    | angegeben werden.                               |
+--------------------+-------------------------------------------------+
| Protokoll          | `HTTP` für unverschlüsselte Verbindungen oder   |
|                    | `HTTPS`, um die Verbindung abzusichern.         |
+--------------------+-------------------------------------------------+
| Organisation       | Bei InfluxDB ist die Organisation               |
|                    | (*organization*) der Arbeitsbereich für mehrere |
|                    | Benutzer. Die initiale Organisation wird bei    |
|                    | der InfluxDB-Einrichtung abgefragt. Weitere     |
|                    | Organisationen können manuell über die          |
|                    | InfluxDB-GUI angelegt werden.                   |
+--------------------+-------------------------------------------------+
| Buckets            | InfluxDB speichert die Zeitreihendaten in       |
|                    | Behältern, sogenannten *Buckets.* Für jeden     |
|                    | Bucket wird insbesondere ein                    |
|                    | Aufbewahrungszeitraum (*retention period*)      |
|                    | festgelegt. InfluxDB löscht automatisch alle    |
|                    | Datenpunkte, die älter sind als dieser          |
|                    | Zeitraum.\                                      |
|                    | Ein Bucket gehört stets zu einer Organisation.  |
|                    | Der initiale Bucket wird zusammen mit der       |
|                    | Organisation bei der InfluxDB-Einrichtung       |
|                    | festgelegt. Weitere Buckets können manuell      |
|                    | erstellt werden.                                |
+--------------------+-------------------------------------------------+
| Token              | Die Kommunikation zwischen Checkmk und InfluxDB |
|                    | erfolgt über die InfluxDB v2 API. InfluxDB      |
|                    | verwendet API-Tokens zur Autorisierung von      |
|                    | Anfragen via API. Ein API-Token gehört zu einem |
|                    | bestimmten Benutzer und identifiziert die       |
|                    | InfluxDB-Berechtigungen innerhalb der           |
|                    | Organisation des Benutzers. Tokens werden über  |
|                    | die InfluxDB-GUI angelegt, entweder mit vollem  |
|                    | Lese- und Schreibzugriff auf alle Ressourcen in |
|                    | einer Organisation (*All Access Token*) oder    |
|                    | mit ausgewählten Zugriffsrechten für bestimmte  |
|                    | Buckets in einer Organisation (*Read/Write      |
|                    | Token*). Ein Token kann in die Zwischenablage   |
|                    | kopiert werden, was das spätere Einfügen        |
|                    | während der Checkmk-Konfiguration erleichtert.  |
|                    | Der Token für die Verbindung zum Checkmk-Server |
|                    | sollte natürlich Lese- und Schreibrechte für    |
|                    | den Bucket haben, der in Checkmk konfiguriert   |
|                    | wird.                                           |
+--------------------+-------------------------------------------------+

::: paragraph
Genaueres dazu finden Sie in der
[InfluxDB-Dokumentation](https://docs.influxdata.com/influxdb/latest/){target="_blank"}.
:::

::: paragraph
Mit diesen Informationen zur Hand, erfolgt die Konfiguration in Checkmk
mit nur zwei unkomplizierten Schritten.
:::
::::::

::::::::::::::::::::::: sect2
### []{#influxdb_connection .hidden-anchor .sr-only}2.2. Checkmk mit InfluxDB verbinden {#heading_influxdb_connection}

::: paragraph
Öffnen Sie das [Setup-Menü](user_interface.html#setup_menu) und schalten
Sie den [Show-more-Modus](intro_gui.html#show_less_more) an --- denn nur
dann wird der Menüeintrag [Setup \> Exporter \> InfluxDB
connections]{.guihint} angezeigt. Wählen Sie diesen aus, um sich die
Liste der existierenden InfluxDB-Verbindungen anzeigen zu lassen. Da Sie
hier wahrscheinlich noch nichts konfiguriert haben, wird die Liste leer
sein.
:::

::: paragraph
Eine Verbindung ist die Voraussetzung für das Versenden der Daten. Ohne
[Regel zur Auswahl der Metrikinformationen](#influxdb_metrics) werden
aber keine Daten versendet.
:::

::: paragraph
Erstellen Sie also zuerst eine neue Verbindung mit [![Symbol zum
Erstellen einer neuen
Verbindung.](../images/icons/icon_new.png)]{.image-inline} [Add
connection]{.guihint}:
:::

::::: imageblock
::: content
![Die allgemeinen Eigenschaften einer
InfluxDB-Verbindung.](../images/metrics_exporter_influxdb_new_connection_general_properties.png)
:::

::: title
ID, Titel und Instanzauswahl reichen für die allgemeinen Eigenschaften
:::
:::::

::: paragraph
In den [General properties]{.guihint} bestimmen Sie, wie gewohnt, die
interne ID und den Titel für die Verbindung.
:::

::: paragraph
Falls mit der aktuellen Instanz weitere Instanzen verbunden sind, wie
das beim [verteilten Monitoring](distributed_monitoring.html) der Fall
ist, können Sie unter [Site restriction]{.guihint} die Verbindung auf
bestimmte Instanzen einschränken. Dazu verschieben Sie zuerst den
Eintrag [All sites]{.guihint} in die linke Spalte und schieben
anschließend die Instanzen, die Metriken erhalten sollen, aus der linken
in die rechte Spalte [Selected]{.guihint}. In der linken Spalte
verbleiben dann die Instanzen, die auf Metriken verzichten müssen.
:::

::: paragraph
Dann geht es weiter im nächsten Kasten mit den [InfluxDB Connection
properties:]{.guihint}
:::

::::: imageblock
::: content
![Die InfluxDB-spezifischen Eigenschaften der
Verbindung.](../images/metrics_exporter_influxdb_new_connection_influxdb_properties.png)
:::

::: title
Die InfluxDB-spezifischen Eigenschaften festlegen
:::
:::::

::: paragraph
Geben Sie hier den ersten Satz der Parameterwerte ein, die Sie im
[vorherigen Abschnitt](#influxdb_collect) zusammengestellt haben.
:::

::: paragraph
Sichern Sie die Verbindung mit [Save]{.guihint} und Sie kehren zurück
zur Liste der Verbindungen:
:::

::::: {#influxdb_connection_list .imageblock}
::: content
![Liste der
InfluxDB-Verbindungen.](../images/metrics_exporter_influxdb_connection_list.png)
:::

::: title
Aktiv, inaktiv, mit oder ohne Regel? Die Verbindungsliste zeigt es
:::
:::::

::: paragraph
In der Verbindungsliste zeigt die Spalte [Enabled]{.guihint} wichtige
Informationen zum Zustand der Verbindung. Wundern Sie sich nicht, dass
die Liste im obigen Bild drei Einträge enthält: Um alle Symbole in
Aktion sehen zu können, haben wir die Liste um zwei weitere Verbindungen
erweitert. Aus der ersten Spalte in [Enabled]{.guihint} können Sie
ablesen, ob die Verbindung [![Symbol zur Anzeige einer aktiven
Verbindung.](../images/icons/icon_perm_yes.png)]{.image-inline}
aktiviert oder [![Symbol zur Anzeige einer deaktivierten
Verbindung.](../images/icons/icon_perm_no.png)]{.image-inline}
deaktiviert ist. In der zweiten Spalte sehen Sie, ob es für die
Verbindung bereits eine Regel [![Knopf zur Anzeige der Liste mit den
Regeln im
Regelsatz.](../images/icons/button_rulesets_enabled.png)]{.image-inline}
gibt oder [![Knopf zur Erstellung einer neuen
Regel.](../images/icons/button_rulesets_disabled.png)]{.image-inline}
nicht.
:::

::: paragraph
Daten werden über eine Verbindung erst dann gesendet, wenn diese mit
einer Regel zur Auswahl der Metrikinformationen verknüpft ist. Diese
Regel heißt [Send metrics to InfluxDB]{.guihint}. Die Regelsymbole sind
Knöpfe und bieten eine Abkürzung zur Regelerstellung: Bei einer
Verbindung mit Regel klicken Sie auf [![Knopf zur Anzeige der Liste mit
den Regeln im
Regelsatz.](../images/icons/button_rulesets_enabled.png)]{.image-inline},
um die Übersichtsseite des Regelsatzes zu öffnen, in der hervorgehoben
ist, welche Regel für die Verbindung greift oder greifen würde. Bei
einer Verbindung ohne Regel führt ein Klick auf [![Knopf zur Erstellung
einer neuen
Regel.](../images/icons/button_rulesets_disabled.png)]{.image-inline}
direkt in die Seite zur Erstellung der Regel.
:::

::: paragraph
Was in dieser Regel festgelegt werden kann, beschreiben wir im folgenden
Kapitel genau.
:::
:::::::::::::::::::::::

:::::::::::::: sect2
### []{#influxdb_metrics .hidden-anchor .sr-only}2.3. Metrikinformationen auswählen {#heading_influxdb_metrics}

::: paragraph
Welche Daten an den InfluxDB-Server gesendet und wo sie abgelegt werden,
bestimmen Sie in Checkmk mit einer Regel.
:::

::: paragraph
Den Regelsatz [Send metrics to InfluxDB]{.guihint} finden Sie unter
[Setup \> Services \> Service monitoring rules]{.guihint}, noch
schneller mit der [Suche im
Setup-Menü](user_interface.html#search_setup) und am schnellsten per
Klick in der [Verbindungsliste](#influxdb_connection_list):
:::

::::: imageblock
::: content
![Regel zur Auswahl der Metrikinformationen zum Versand über die
InfluxDB-Verbindung.](../images/metrics_exporter_influxdb_send_metrics_rule.png)
:::

::: title
Die Auswahl der Metrikinformationen erfolgt per Regel
:::
:::::

::: paragraph
Im Kasten [Send metrics to InfluxDB]{.guihint} wählen Sie zuerst die im
[vorherigen Abschnitt](#influxdb_connection) erstellte Verbindung aus
und legen dann fest, wo die Daten auf dem InfluxDB-Server abgelegt
werden. Hier geben Sie den zweiten Satz der [gesammelten
Informationen](#influxdb_collect) über den InfluxDB-Server ein. Mit
[Organization]{.guihint} entscheiden Sie, welche Benutzer die Daten
erhalten, und mit [Bucket]{.guihint}, wie lange die Metriken vorgehalten
werden. Eine Mehrfachauswahl ist nicht möglich, d.h. Sie können die
Metriken z.B. nicht an mehrere Buckets unterschiedlicher Organisationen
schicken.
:::

::: paragraph
Im folgenden wählen Sie die Metrikdaten aus, die von Checkmk an den
InfluxDB-Server gesendet werden. [Metrics of service]{.guihint} ist
standardmäßig bereits ausgewählt und aktiviert den Metrikversand. Durch
Ankreuzen der Checkbox [Service state]{.guihint} wird der
[Service-Zustand](monitoring_basics.html#services) als eigene Metrik
gesendet.
:::

::: paragraph
Nach Aktivierung von [Additional values per metric]{.guihint} können Sie
den Metriken eine Reihe von Metadaten mitgeben, die der Darstellung
dienen, z.B. den Zustand des zugehörigen Services ([State of
service]{.guihint}) und die Schwellwerte ([Thresholds]{.guihint}).
Beachten Sie dabei, dass [Unit]{.guihint} derzeit nur bei Metriken aus
[aktiven Checks](glossar.html#active_check) funktioniert, wenn diese das
unterstützen. Der Grund liegt darin, dass nur aktive Checks optional die
Einheit mitliefern und der CMC auf andere keinen Zugriff hat.
:::

::: paragraph
In der letzten Liste [Tags to use]{.guihint} werden den Metriken
Metadaten wie [Host-Merkmale](glossar.html#host_tag) oder
[Labels](glossar.html#label) hinzugefügt, die hauptsächlich der
Filterung dienen und dafür optimiert sind. Die standardmäßig
ausgewählten [Host name]{.guihint} und [Service name]{.guihint} sind
dabei Pflichteinträge, die nicht abgewählt werden können.
:::

::: paragraph
In InfluxDB werden die [Additional values per metric]{.guihint} als
*fields* und die [Tags to use]{.guihint} als *tags* gespeichert.
:::

::: paragraph
Zum Schluss [aktivieren Sie die
Änderungen](glossar.html#activate_changes) für die Erstellung der
Verbindung und der Regel. Bei Problemen mit dem Metrikversand finden Sie
weiter unten [Informationen zur Fehlerdiagnose.](#diagnosis)
:::
::::::::::::::

:::::::: sect2
### []{#influxdb_display .hidden-anchor .sr-only}2.4. Metriken in InfluxDB anzeigen {#heading_influxdb_display}

::: paragraph
Wenn die Metriken von Checkmk beim InfluxDB-Server angekommen sind,
können sie in der InfluxDB-GUI angezeigt werden. Das folgende Bild zeigt
als Beispiel den Graphen für die Metrik `total_used`, die den
verwendeten Arbeitsspeicher anzeigt:
:::

::::: imageblock
::: content
![Anzeige der Metrik zum verwendeten Arbeitsspeicher in der
InfluxDB-GUI.](../images/metrics_exporter_influxdb_show_metric.png)
:::

::: title
In der InfluxDB-GUI gibt es unterhalb des Graphen Listen zur Auswahl und
zum Filtern
:::
:::::

::: paragraph
**Hinweis:** Diese Metrik finden Sie in Checkmk beim Service
[Memory]{.guihint} unter dem Metriknamen [Total used memory.]{.guihint}
:::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::: sect1
## []{#graphite .hidden-anchor .sr-only}3. Metriken an Graphite senden {#heading_graphite}

::::::::::::::::::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Graphite-Logo.](../images/graphite-logo.png){width="120"}
:::
::::

::: paragraph
Auch Graphite ist ein bekanntes Open Source DBMS für Zeitreihen, um
Metriken zu speichern, abzurufen, weiterzugeben und zu visualisieren.
Graphite besteht aus dem Carbon Daemon, der auf die Daten wartet und
diese in einer Datenbank speichert, aus der sie mit der Graphite
Webanwendung aufbereitet und als Graphen angezeigt werden. Mit Checkmk
können Sie die Metriken im Plaintext-Protokoll an den Carbon Daemon von
Graphite weiterleiten, der auf Port 2003 auf Daten dieses Protokolls
wartet. Im Plaintext-Protokoll ist ein Datensatz sehr einfach aufgebaut
im Format `<Metrikpfad> <Wert> <Zeitstempel>`, wobei `<Metrikpfad>` ein
durch Punkte getrennter eindeutiger Bezeichner ist.
:::

::: paragraph
Anders als bei der [InfluxDB-Verbindung](#influxdb) werden standardmäßig
**alle** Metrikdaten gesendet sobald eine Graphite-Verbindung aktiviert
ist. Falls Sie dies nicht wünschen, sollten Sie **vor** der Aktivierung
der Verbindung die Metriken per Regel auswählen und dann Regeln und
Verbindung zusammen aktivieren.
:::

:::::::::::: sect2
### []{#graphite_metrics .hidden-anchor .sr-only}3.1. Metrikinformationen auswählen {#heading_graphite_metrics}

::: paragraph
In Checkmk finden Sie unter [Setup \> Services \> Service monitoring
rules]{.guihint} die beiden Regelsätze [Send host metrics to
Graphite]{.guihint} und [Send service metrics to Graphite.]{.guihint}
Die Konfiguration erfolgt in gleicher Weise für Host- und für
Service-Metriken. Wir zeigen hier die Konfiguration für
Service-Metriken. Die Host-Metriken richten Sie dann analog ein.
:::

::: paragraph
Mit der Regel [Send service metrics to Graphite]{.guihint} können Sie
einerseits die Werte auswählen, die mit den Metriken mitgeliefert werden
sollen:
:::

::::: imageblock
::: content
![Regel zur Auswahl der Service-Metriken zum Versand über die
Graphite-Verbindung.](../images/metrics_exporter_graphite_rule.png)
:::

::: title
Auch bei Graphite erfolgt die Auswahl der Metrikinformationen per Regel
:::
:::::

::: paragraph
Zum anderen können Sie in der Box [Conditions]{.guihint} den Versand auf
bestimmte Hosts und Services einschränken. Da ohne einschränkende Regel
alle Daten gesendet werden, empfiehlt es sich zuerst eine Regel zu
erstellen, die den Versand global abschaltet, indem Sie alle Checkboxen
im obigen Bild abwählen. Erstellen Sie anschließend eine spezifische
Regel mit den gewünschten Metrikinformationen für die Hosts und
Services, deren Metriken an den Graphite-Server übermittelt werden
sollen. Ordnen Sie die spezifische vor der globalen Regel an:
:::

::::: imageblock
::: content
![Liste der Regeln für den Versand über die
Graphite-Verbindung.](../images/metrics_exporter_graphite_rule_list.png)
:::

::: title
Durch die Reihenfolge der beiden Regeln werden nur Service-Metriken des
Hosts `myhost` versendet
:::
:::::
::::::::::::

::::::::: sect2
### []{#graphite_connection .hidden-anchor .sr-only}3.2. Checkmk mit Graphite verbinden {#heading_graphite_connection}

::: paragraph
Die Verbindung zum Graphite-Server richten Sie ein unter [Setup \>
General \> Global Settings \> Monitoring Core \> Send metrics to
Graphite]{.guihint}. Klicken Sie dort auf [Add new Graphite
connection:]{.guihint}
:::

::::: imageblock
::: content
![Die Eigenschaften einer
Graphite-Verbindung.](../images/metrics_exporter_graphite_new_connection.png)
:::

::: title
Die Graphite-Verbindung wird in den [Global Settings]{.guihint} erstellt
:::
:::::

::: paragraph
Neben den offensichtlichen Angaben zum Graphite-Server (Name und
Port-Nummer des Carbon-Plaintext-Protokolls) können Sie mit [Optional
variable prefix]{.guihint} einen Präfix konfigurieren, der jedem
Host-Namen vorangestellt wird, um z.B. eindeutige Namen zu erzwingen.
Checkmk setzt den Metrikpfad für das Plaintext-Protokoll auf
`<Host>.<Service>.<Metrik>`.
:::

::: paragraph
Die [Aktivierung der Änderungen](glossar.html#activate_changes) für die
Regeln und die Verbindung schließt die Konfiguration für Graphite ab.
:::
:::::::::

::::::: sect2
### []{#graphite_display .hidden-anchor .sr-only}3.3. Metriken in Graphite anzeigen {#heading_graphite_display}

::: paragraph
Auch in der Graphite-GUI können Sie sich die von Checkmk empfangenen
Metriken ansehen. Das folgende Bild zeigt den Graphen für die Metrik
`total_used`, den wir bereits [oben](#influxdb_display) als Beispiel in
der InfluxDB-GUI gezeigt haben:
:::

::::: imageblock
::: content
![Anzeige der Metrik zum verwendeten Arbeitsspeicher in der
Graphite-GUI.](../images/metrics_exporter_graphite_show_metric.png)
:::

::: title
In der Graphite-GUI erfolgt die Auswahl in einem Navigationsbereich
links vom Graphen
:::
:::::
:::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

:::::::::::::::: sect1
## []{#diagnosis .hidden-anchor .sr-only}4. Fehlerdiagnose {#heading_diagnosis}

::::::::::::::: sectionbody
::: paragraph
Sollten die Metriken nicht dort ankommen, wo Sie sie erwarten, finden
Sie Diagnoseinformationen in Ihrer Instanz in der Datei
`~/var/log/cmc.log` --- der [Log-Datei des Checkmk Micro
Core.](cmc_files.html)
:::

::: paragraph
Folgendes Beispiel zeigt die Meldungen, falls das in Checkmk
konfigurierte Bucket auf dem InfluxDB-Server nicht existiert:
:::

::::: listingblock
::: title
\~/var/log/cmc.log
:::

::: content
``` {.pygments .highlight}
2022-01-10 11:41:35 [5] [influxdb https://myinfluxdb.example.com:8086] Successfully initiated connection
2022-01-10 11:41:36 [5] [influxdb https://myinfluxdb.example.com:8086] Successfully connected
2022-01-10 11:41:36 [3] [influxdb https://myinfluxdb.example.com:8086] POST [404] {"code":"not found","message":"bucket \"my_bucket\" not found"}
2022-01-10 11:41:36 [5] [influxdb https://myinfluxdb.example.com:8086] Closing connection
```
:::
:::::

::: paragraph
Folgendes Beispiel zeigt die Meldungen im Fall, dass eine Verbindung zum
Graphite-Server nicht klappt:
:::

::::: listingblock
::: title
\~/var/log/cmc.log
:::

::: content
``` {.pygments .highlight}
2021-12-15 17:33:33 [5] [carbon 10.0.0.5:2003] Successfully initiated connection
2021-12-15 17:33:33 [4] [carbon 10.0.0.5:2003] Connection failed: Connection refused
2021-12-15 17:33:33 [5] [carbon 10.0.0.5:2003] Closing connection
```
:::
:::::

::: paragraph
Der Checkmk Micro Core versucht in solchen Situationen von sich aus
immer wieder, die Verbindung aufzubauen.
:::

::: paragraph
**Wichtig:** Metriken, die während einer Zeit anfallen, zu der keine
Verbindung zum Zielsystem besteht, werden aus Performance-Gründen
*nicht* zwischengespeichert, sondern gehen verloren (bzw. sind dann nur
in den RRDs von Checkmk verfügbar).
:::

::: paragraph
**Hinweis:** Falls Ihnen die Log-Meldungen nicht aussagekräftig genug
sind, können Sie die Standardwerte zum Log Level ändern unter [Setup \>
General \> Global Settings \> Monitoring Core \> Logging of the
core]{.guihint}. Hier finden Sie Einträge für das Logging der InfluxDB
([InfluxDB processing]{.guihint}) und für Graphite ([Carbon
connections]{.guihint}).
:::
:::::::::::::::
::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
