:::: {#header}
# Checkmk Enterprise

::: details
[Last modified on 06-Jun-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cse.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk Cloud](cce.html) [Checkmk aufsetzen](intro_setup.html) [Updates
und Upgrades](update.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::: sectionbody
::: paragraph
Eine Lösung für alle kann es nicht geben und wer für
Software-Subskriptionen Geld bezahlt, möchte möglichst nur Features
bezahlen, die man auch nutzt. Checkmk bietet aus diesem Grund
verschiedene Editionen für verschiedene Einsatzbereiche. In diesem
Artikel stellen wir Ihnen mit
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise** eine der kommerziellen
[Editionen](intro_setup.html#editions) vor, die im professionellen
Umfeld am häufigsten anzutreffen ist.
:::
::::
:::::

:::::::: sect1
## []{#editions .hidden-anchor .sr-only}2. Einordnung von Checkmk Enterprise {#heading_editions}

::::::: sectionbody
::: paragraph
Aufbauend auf der reinen Open Source Variante
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** bietet Checkmk Enterprise vor allem Verbesserungen der
Performance, umfangreichere Möglichkeiten von *Dashboards* sowie
*Reporting* und Erleichterungen der *Automatisierung*. Sie spricht damit
vor allem professionelle Anwender an, die Subskriptionskosten gesparten
Hardwarekosten und reduziertem Aufwand zur Erstellung eigener
Erweiterungen entgegenstellen. Daneben bietet Checkmk Enterprise
verschiedene Möglichkeiten, Support mit garantierter Reaktionszeit zu
buchen.
:::

::: paragraph
Auf Checkmk Enterprise baut wiederum
[[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud**](cce.html) auf.
:::

::: paragraph
Ergänzend zum
[Editionsvergleich](https://checkmk.com/de/preise){target="_blank"} auf
unserer Website zeigt dieser Artikel die Unterschiede auf technischer
Ebene und versucht so, eine komplementäre Entscheidungshilfe bei der
Wahl der Edition zu sein.
:::

::: paragraph
Daneben soll er helfen, abzuschätzen, welche Einstellungsänderungen beim
[Wechsel der Edition](update.html) -- egal, ob Up- oder Downgrade --
notwendig oder sinnvoll sind.
:::
:::::::
::::::::

:::::: sect1
## []{#functions .hidden-anchor .sr-only}3. Zusätzliche Funktionen von Checkmk Enterprise {#heading_functions}

::::: sectionbody
::: paragraph
Die wesentlichen Funktionen von Checkmk Enterprise, die diese von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** unterscheiden:
:::

::: ulist
- Performance-Verbesserungen:\
  Mit dem *Checkmk Micro Core (CMC)* nutzt Checkmk Enterprise einen
  Monitoring-Kern, der Speicher und CPU effizienter ausnutzt.

- Erleichtertes verteiltes Monitoring:\
  Eine Vielzahl von Erweiterungen erleichtert verteiltes Monitoring.
  Dazu gehört die Möglichkeit, die Konfiguration komplett zu
  zentralisieren, Benachrichtigungen komplett über die Zentralinstanz
  abzuwickeln und verschiedene Techniken, auch bei langsamen oder
  instabilen Netzen einen zuverlässigen Transfer von Monitoring-Daten zu
  gewährleisten.

- Business-Features:\
  Wo IT geschäftskritisch ist, muss Monitoring helfen, Probleme zu
  dokumentieren, einzuordnen und zu verhindern. Checkmk Enterprise
  bietet hierfür *vorausschauende* Funktionen wie die Einrichtung von
  wiederkehrenden Wartungszeiten und *auswertende* wie die Erstellung
  von Verfügbarkeitsberichten -- letzteres auch für komplexe Systeme,
  die aus einer Vielzahl an Komponenten bestehen.
:::
:::::
::::::

:::::: sect1
## []{#upgrade .hidden-anchor .sr-only}4. Upgrade zu Checkmk Enterprise {#heading_upgrade}

::::: sectionbody
::: paragraph
Sie können Checkmk Raw jederzeit auf Checkmk Enterprise upgraden. Folgen
Sie dafür der [Upgrade-Beschreibung](update.html#updateraw) zu Checkmk
Enterprise.
:::

::: paragraph
Falls Sie Checkmk mit Checkmk Cloud getestet haben, die in den ersten 30
Tagen nicht limitiert ist, können Sie nach dem Testzeitraum auch
dauerhaft zu Checkmk Enterprise wechseln. Folgen Sie dafür der
[Downgrade-Beschreibung](update.html#cce2cee) zu Checkmk Enterprise.
:::
:::::
::::::

::::::::::: sect1
## []{#details .hidden-anchor .sr-only}5. Unterschiede der Komponenten im Detail {#heading_details}

:::::::::: sectionbody
:::: sect2
### []{#core .hidden-anchor .sr-only}5.1. Monitoring-Kern {#heading_core}

::: paragraph
Dieser Abschnitt behandelt Unterschiede am Monitoring-Kern und der
Übertragung von Monitoring-Daten in verteilten Umgebungen. Nutzer, die
von Nagios-Umgebungen zu Checkmk migrieren, sollten die Artikel zum
[Checkmk Micro Core](cmc.html) und den [Besonderheiten des
CMC](cmc_differences.html) aufmerksam lesen, um zu beurteilen, ob es für
eine Übergangszeit sinnvoll sein kann, Checkmk mit dem Nagios-Kern zu
betreiben.
:::

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| CMC         | Die kommerziellen Editionen verwenden standardmäßig    |
|             | den [Checkmk Micro Core](cmc.html), welcher durch      |
|             | Reduzierung auf die wesentliche Funktionalität und     |
|             | Optimierung dieser performanter als andere             |
|             | Monitoring-Kerne ist.                                  |
+-------------+--------------------------------------------------------+
| Alert       | Der CMC unterstützt keine *Nagios Event Handler*,      |
| Handler     | bietet dafür aber flexiblere [Alert                    |
|             | Handler](alert_handlers.html).                         |
+-------------+--------------------------------------------------------+
| Smart Ping  | Der [Smart Ping](cmc_differences.html#smartping)       |
|             | gewährleistet eine effizientere und schnellere         |
|             | Erkennung, ob Hosts erreichbar sind.                   |
+-------------+--------------------------------------------------------+
| CMCDump     | Diese Übertragungstechnik vereinfacht [verteiltes      |
|             | Monitoring](distributed_monitoring.html#livedump) in   |
|             | Umgebungen mit unzuverlässiger Netzwerkanbindung. In   |
|             | Umgebungen mit Nagios-Kern steht stattdessen Livedump  |
|             | zur Verfügung.                                         |
+-------------+--------------------------------------------------------+
| Lives       | Der                                                    |
| tatus-Proxy | [Livestat                                              |
|             | us-Proxy](distributed_monitoring.html#livestatusproxy) |
|             | optimiert im verteilten Monitoring Performance und     |
|             | Latenzen.                                              |
+-------------+--------------------------------------------------------+
| Verteilte   | Die automatische Synchronisierung von Inventardaten im |
| HW/         | [verteilten Monitoring](distributed_monitoring.html)   |
| SW-Inventur | macht Inventardaten zentral verfügbar.                 |
+-------------+--------------------------------------------------------+
| RRD-Spe     | Bei Verwendung des CMC nutzt Checkmk ein auf           |
| icherformat | Einsparung von Disk-I/O [optimiertes                   |
|             | Speicherformat](cmc_differences.html#metrics) der      |
|             | Round Robin Database (RRD).                            |
+-------------+--------------------------------------------------------+
| Parent-Chil | Mit dem CMC kann Checkmk in Umgebungen mit             |
| d-Beziehung | Parent-Child-Topologie präziser [den Zustand von       |
|             | abhängigen Hosts](monitoring_basics.html#parents)      |
|             | ermitteln.                                             |
+-------------+--------------------------------------------------------+
| Unstetigkei | In den kommerziellen Editionen ist eine                |
| tserkennung | [Feineinstellung der                                   |
| (*flapping  | Unstetigkeitserkennung](notifications.html#flapping)   |
| detection*) | möglich für Hosts und Services, deren Zustand sich in  |
|             | kurzen Abständen immer wieder ändert.                  |
+-------------+--------------------------------------------------------+
::::

::: sect2
### []{#ui .hidden-anchor .sr-only}5.2. Monitoring-Oberfläche {#heading_ui}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Standar     | Die kommerziellen Editionen verwenden als Standard ein |
| d-Dashboard | [Dashboard](dashboards.html#usage), welches in Checkmk |
|             | Raw nicht verfügbar ist. Diese nutzt stattdessen das   |
|             | Problem-Dashboard.                                     |
+-------------+--------------------------------------------------------+
| Messwerte   | Erweiterte [Funktionen des Graphings](graphing.html)   |
| und         | stehen ausschließlich in den kommerziellen Editionen   |
| Graphing    | zur Verfügung. Dazu gehören: Umfang der Dashlets,      |
|             | PDF-Export, Graphensammlungen, Anpassungen (*graph     |
|             | tunings*), Einbettung in Berichte oder Dashboards und  |
|             | benutzerdefinierte Graphen.                            |
+-------------+--------------------------------------------------------+
| Kubernetes- | Die                                                    |
| und         | [Kuberne                                               |
| OpenShift   | tes-Dashboards](monitoring_kubernetes.html#dashboards) |
| -Dashboards | sind den kommerziellen Editionen vorbehalten.          |
+-------------+--------------------------------------------------------+
| War         | Nur in den kommerziellen Editionen können regelmäßig   |
| tungszeiten | wiederkehrende [Wartungszeiten](basics_downtimes.html) |
| (*scheduled | festgelegt werden. Zudem ist über *Kommandos* eine     |
| downtimes*) | komfortable [Änderung oder Entfernung einer oder       |
|             | mehrerer Wartungszeiten](commands.html#commands)       |
|             | möglich.                                               |
+-------------+--------------------------------------------------------+
| Ve          | In den kommerziellen Editionen kann die Berechnung der |
| rfügbarkeit | [Verfügbarkeit](availability.html) von Zeitperioden    |
|             | abhängig gemacht werden. Verfügbarkeitsdaten können    |
|             | auch als PDF exportiert werden.                        |
+-------------+--------------------------------------------------------+
| PDF-Export  | Der direkte PDF-Export von [Ansichten](views.html) im  |
| von         | Monitoring ist den kommerziellen Editionen             |
| Ansichten   | vorbehalten.                                           |
+-------------+--------------------------------------------------------+
| Reporting   | Das [Reporting](reporting.html) ist den kommerziellen  |
|             | Editionen vorbehalten.                                 |
+-------------+--------------------------------------------------------+
| Erweiterte  | Die nur in den kommerziellen Editionen enthaltenen     |
| Verf        | [Erweiterte Verfügbarkeiten / Service Level            |
| ügbarkeiten | Agreements](sla.html) erleichtern die Kontrolle von    |
| (SLAs)      | vertraglichen Vereinbarungen betreffend der            |
|             | Verfügbarkeit von Diensten.                            |
+-------------+--------------------------------------------------------+
| Quittierung | Die [Quittierung von Problemen](basics_ackn.html) kann |
| mit         | in den kommerziellen Editionen mit einer maximalen     |
| Gülti       | Gültigkeitsdauer versehen werden.                      |
| gkeitsdauer |                                                        |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#notifications .hidden-anchor .sr-only}5.3. Benachrichtigungen {#heading_notifications}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Ben         | Die kommerziellen Editionen enthalten mit dem          |
| achrichtigu | [Benachrichtigungs-Spooler](notifications.html#async)  |
| ngs-Spooler | eine Komponente, welche die effizientere und           |
| (*n         | flexiblere Zustellung von Benachrichtigungen erlaubt.  |
| otification |                                                        |
| spooler*)   |                                                        |
+-------------+--------------------------------------------------------+
| Nachv       | Über                                                   |
| ollziehbare | [Smarthost-Einstellungen](notifications.html#syncsmtp) |
| Zustellung  | kann in den kommerziellen Editionen zuverlässiger      |
|             | sichergestellt werden, dass Benachrichtigungen         |
|             | ankommen als mit einer reinen Übergabe an das lokale   |
|             | Mailsystem von Checkmk Raw.                            |
+-------------+--------------------------------------------------------+
| Zentrale    | Im verteilten Monitoring kann der                      |
| Benachr     | Benachrichtigungs-Spooler der kommerziellen Editionen  |
| ichtigungen | so konfiguriert werden, dass er [Benachrichtigungen    |
|             | von den Remote-Instanzen für alle                      |
|             | Ziele](distributed_monitoring.html#notifications)      |
|             | verschickt.                                            |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#agents .hidden-anchor .sr-only}5.4. Monitoring-Agenten {#heading_agents}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Agen        | Die kommerziellen Editionen verfügen mit der           |
| tenbäckerei | [Agentenbäckerei](wato_monitoringagents.html#bakery)   |
| (*Agent     | über einen Mechanismus, automatisch individuelle       |
| Bakery*)    | Agentenpakete mit Plugins und Konfigurationsdateien zu |
|             | erstellen. Einstellungen der Agenten-Konfiguration     |
|             | können mit der [Bakery-API](bakery_api.html) in der    |
|             | Setup-GUI vorgenommen werden.                          |
+-------------+--------------------------------------------------------+
| Age         | Die [automatische                                      |
| nten-Update | Aktualisierung](agent_deployment.html) von             |
|             | Agentenpaketen nach Konfigurationsänderungen ist nur   |
|             | in den kommerziellen Editionen möglich.                |
+-------------+--------------------------------------------------------+
| SNMP        | Dank einer eigenen [SNMP-Engine](snmp.html)            |
| -Monitoring | *(Inline-SNMP)* sind die kommerziellen Editionen       |
|             | performanter als Checkmk Raw mit der Nutzung von       |
|             | `snmpget`/`snmpbulkwalk`.                              |
+-------------+--------------------------------------------------------+
| Chec        | In den kommerziellen Editionen sorgen die              |
| kmk-Fetcher | Checkmk-Fetcher für effizientes [Einholen der          |
|             | Monitoring-Daten.](wato_monitoringagents.html)         |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#connectors .hidden-anchor .sr-only}5.5. Anbindungen {#heading_connectors}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| SAML        | Seit Checkmk [2.2.0]{.new} können die kommerziellen    |
|             | Editionen nativ gegen [SAML                            |
|             | authentifizieren](saml.html), bis [2.1.0]{.new} und    |
|             | weiterhin in Checkmk Raw ist dies nur auf Apache-Ebene |
|             | möglich.                                               |
+-------------+--------------------------------------------------------+
| Grafana     | Das [Grafana-Plugin](grafana.html) erlaubt bei Nutzung |
|             | mit den kommerziellen Editionen Filterkaskaden.        |
+-------------+--------------------------------------------------------+
| InfluxDB    | Nur die kommerziellen Editionen liefern eine           |
| und         | Schnittstelle zur Anbindung an [externe                |
| Graphite    | Metrik-Datenbanken](metrics_exporter.html) mit.        |
+-------------+--------------------------------------------------------+
| Jira        | Die [Benachrichtigungsmethode für                      |
|             | Jira](notifications_jira.html) ist den kommerziellen   |
|             | Editionen vorbehalten.                                 |
+-------------+--------------------------------------------------------+
| ServiceNow  | Die [Benachrichtigungsmethode für                      |
|             | ServiceNow](notifications_servicenow.html) gibt es nur |
|             | in den kommerziellen Editionen.                        |
+-------------+--------------------------------------------------------+
| ntopng      | Um die [Integration von ntopng in Checkmk](ntop.html)  |
|             | nutzen zu können, benötigen Sie eine der kommerziellen |
|             | Editionen mit dem kostenpflichtigen Add-on für die     |
|             | ntopng-Integration.                                    |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#other .hidden-anchor .sr-only}5.6. Weitere Funktionen {#heading_other}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| DCD         | Die dynamische Host-Verwaltung mit dem [Distributed    |
|             | Configuration Daemon](dcd.html) ermöglicht die         |
|             | automatische Erstellung von Hosts und erleichtert      |
|             | damit die Überwachung von                              |
|             | [Docker](monitoring_docker.html) und der Cloud wie zum |
|             | Beispiel [Amazon Web Services                          |
|             | (AWS)](monitoring_aws.html) oder [Google Cloud         |
|             | Platform (GCP).](monitoring_gcp.html)                  |
+-------------+--------------------------------------------------------+
| Checkmk     | [Checkmk Synthetic Monitoring mit                      |
| Synthetic   | Robotmk](robotmk.html) gibt es nur in den              |
| Monitoring  | kommerziellen Editionen, benötigt jedoch eine          |
|             | zusätzliche Subskription.                              |
+-------------+--------------------------------------------------------+
| MKP         | Die Verwaltung von                                     |
| -Verwaltung | [Checkmk-Erweiterungspaketen](mkps.html) ist in        |
|             | Checkmk Raw nur auf der Kommandozeile möglich, in den  |
|             | kommerziellen Editionen zusätzlich über die Setup-GUI. |
+-------------+--------------------------------------------------------+
| MKPs für    | In den kommerziellen Editionen können Sie für          |
| GUI-Er      | Dashboards, Ansichten und Berichte                     |
| weiterungen | [GUI-Erweiterungspakete                                |
|             | erstellen.](mkp_viewables.html)                        |
+-------------+--------------------------------------------------------+
| Progno      | Auf Basis der ermittelten Werte über einen längeren    |
| sebasiertes | Zeitraum kann in den kommerziellen Editionen ein       |
| Monitoring  | [prognosebasiertes                                     |
| (           | Monitoring](predictive_monitoring.html) mit            |
| *predictive | dynamischen Schwellwerten genutzt werden.              |
| m           |                                                        |
| onitoring*) |                                                        |
+-------------+--------------------------------------------------------+
| Vorher      | In den kommerziellen Editionen können Sie              |
| sagegraphen | [Vorhersagegraphen](forecast_graphs.html) erstellen.   |
| (*forecast  |                                                        |
| graphs*)    |                                                        |
+-------------+--------------------------------------------------------+
| Support     | Einige Optionen zur Auswahl von Daten für einen *Dump* |
| Diagnostics | in den [Support Diagnostics](support_diagnostics.html) |
|             | gibt es nur in den kommerziellen Editionen, etwa zum   |
|             | Checkmk Micro Core (CMC) oder zur Lizenzierung.        |
+-------------+--------------------------------------------------------+
:::
::::::::::
:::::::::::
:::::::::::::::::::::::::::::::::::
