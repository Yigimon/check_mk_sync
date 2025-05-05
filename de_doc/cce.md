:::: {#header}
# Checkmk Cloud

::: details
[Last modified on 06-Jun-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cce.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk Enterprise](cse.html) [Checkmk MSP](managed.html) [Checkmk
aufsetzen](intro_setup.html) [Updates und Upgrades](update.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::: sectionbody
::: paragraph
Die eine perfekte Software-Lösung für jeden Nutzer und jeden
Anwendungsfall gibt es nicht. Was dem einen gefällt, ist dem anderen zu
viel oder zu wenig, zu simpel oder zu komplex. Deshalb ist auch Checkmk
in verschiedenen Editionen verfügbar. Diese unterscheiden sich vor allem
im Leistungsumfang und in den Einsatzmöglichkeiten. Im Folgenden möchten
wir Ihnen mit
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** eine der kommerziellen
[Editionen](intro_setup.html#editions) vorstellen.
:::
::::
:::::

::::::: sect1
## []{#editions .hidden-anchor .sr-only}2. Einordnung von Checkmk Cloud {#heading_editions}

:::::: sectionbody
::: paragraph
Inhaltlich baut Checkmk Cloud auf
[[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise**](cse.html) auf, bietet aber zusätzlich
umfangreiche Cloud-Funktionen. Damit ist sie vor allem für die Nutzer
von Wert, deren Hosts in einer Cloud beheimatet sind und die auch ihr
gesamtes Monitoring in einer Cloud aufsetzen wollen.
:::

::: paragraph
Die Unterstützung bei der Verlagerung von Anwendungen und Prozessen in
die Cloud, d.h. in sogenannten *Lift and Shift*-Szenarien, ist bereits
in allen Editionen integriert --- bei der Überwachung von Amazon Web
Services (AWS), Microsoft Azure und Google Cloud Platform (GCP). Darüber
hinaus bietet Checkmk Cloud auch Cloud-spezifische
[Check-Plugins.](glossar.html#check_plugin) So können Sie beim Übergang
aus dem Rechenzentrum in eine Cloud weiter Checkmk Enterprise nutzen.
Möchten Sie danach auch SaaS und PaaS Produkte, die eine Cloud Ihnen
bietet, nutzen, können Sie auf Checkmk Cloud upgraden.
:::

::: paragraph
Auf Checkmk Cloud baut dann
[[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP**](managed.html) auf.
:::
::::::
:::::::

::::::: sect1
## []{#functions .hidden-anchor .sr-only}3. Zusätzliche Funktionen von Checkmk Cloud {#heading_functions}

:::::: sectionbody
::: paragraph
Die wesentlichen Funktionen von Checkmk Cloud, die diese von anderen
Editionen unterscheiden:
:::

::: ulist
- Nur Checkmk Cloud ist über die Marketplaces von [Microsoft
  Azure](install_azure.html) und [AWS](install_aws.html) verfügbar.

- Fortgeschrittene Check-Plugins:\
  Bei der Überwachung von [Amazon Web Services
  (AWS),](monitoring_aws.html) [Microsoft Azure](monitoring_azure.html)
  und [Google Cloud Platform (GCP)](monitoring_gcp.html) gibt es in
  Checkmk Cloud zusätzliche, Cloud-spezifische Check-Plugins.

- Cloud-spezifische Dashboards:\
  In Checkmk Cloud gibt es für AWS, Microsoft Azure und GCP spezifische
  Dashboards.

- Konfiguration eines Push-Agenten:\
  In allen Checkmk-Editionen initiiert der Checkmk-Server die
  Kommunikation mit einem Host und fragt die Daten vom Checkmk-Agenten
  ab - im sogenannten [Pull-Modus.](glossar.html#pull_mode) Mit Checkmk
  Cloud können Sie zusätzlich den [Push-Modus](glossar.html#push_mode)
  nutzen.

- Autoregistrierung von Hosts:\
  In Checkmk Cloud können Sie [Hosts automatisch erstellen
  lassen](hosts_autoregister.html), auf denen ein Checkmk-Agent
  installiert ist. Dies beinhaltet die Registrierung des Agenten beim
  Checkmk-Server, den Aufbau einer TLS-verschlüsselte Verbindung, die
  Erstellung des Hosts, die Durchführung einer Service-Erkennung und die
  Aktivierung der Änderungen, so dass der Host in die
  Monitoring-Umgebung aufgenommen wird --- alles vollautomatisch. Die
  Autoregistrierung funktioniert für Pull- und Push-Agenten.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Im Setup der                      |
|                                   | Checkmk-Benutzeroberfläche werden |
|                                   | Elemente, die es nur ab Checkmk   |
|                                   | Cloud gibt, durch den Zusatz      |
|                                   | [(Managed Services Edition, Cloud |
|                                   | Edition)]{.guihint}               |
|                                   | gekennzeichnet, z. B. Regeln oder |
|                                   | Parameterwerte,                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::
:::::::

:::::: sect1
## []{#upgrade .hidden-anchor .sr-only}4. Upgrade zu Checkmk Cloud {#heading_upgrade}

::::: sectionbody
::: paragraph
Sie können Checkmk Cloud unverbindlich testen, denn sie ist in den
ersten 30 Tagen nicht limitiert. Durch Eingabe eines Lizenzschlüssels
nach spätestens 30 Tagen können Sie Checkmk Cloud dann ohne
Beschränkungen einsetzen.
:::

::: paragraph
Für den Wechsel von einer der anderen Editionen zu Checkmk Cloud folgen
Sie der [Upgrade-Beschreibung.](update.html#upgrade)
:::
:::::
::::::

::::::::: sect1
## []{#details .hidden-anchor .sr-only}5. Unterschiede der Komponenten im Detail {#heading_details}

:::::::: sectionbody
::: sect2
### []{#ui .hidden-anchor .sr-only}5.1. Monitoring-Oberfläche {#heading_ui}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Cloud       | In Checkmk Cloud finden Sie im Monitoring die          |
| -Dashboards | spezifischen Dashboards für                            |
|             | [AWS,](monitoring_aws.html#dashboards)                 |
|             | [Azure](monitoring_azure.html#dashboards) und          |
|             | [GCP.](monitoring_gcp.html#dashboards)                 |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#agents .hidden-anchor .sr-only}5.2. Monitoring-Agenten {#heading_agents}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Push-Modus  | In Checkmk Cloud kann der                              |
|             | [Checkmk-Agent](wato_monitoringagents.html#agents) für |
|             | Linux und für Windows im                               |
|             | [Push-Modus](glossar.html#push_mode) konfiguriert und  |
|             | genutzt werden. Den Modus (Push oder                   |
|             | [Pull](glossar.html#pull_mode)) konfigurieren Sie in   |
|             | den Eigenschaften eines Hosts oder Ordners, im         |
|             | Abschnitt zu den                                       |
|             | [Mo                                                    |
|             | nitoring-Agenten.](hosts_setup.html#monitoring_agents) |
|             | Der Push-Modus ist auf den Agent Controller angewiesen |
|             | und daher im Legacy-Modus des Agenten nicht verfügbar. |
+-------------+--------------------------------------------------------+
| Autore      | Checkmk Cloud bietet die Möglichkeit, Hosts            |
| gistrierung | automatisch bei der Registrierung anzulegen mit der    |
|             | sogenannten                                            |
|             | [Autoregistrierung.](hosts_autoregister.html) Zur      |
|             | Konfiguration der Checkmk-Instanz dient der Regelsatz  |
|             | [[Agent                                                |
|             | registration.]{.gui                                    |
|             | hint}](hosts_autoregister.html#rule_autoregister_site) |
|             | Auch die Autoregistrierung setzt den Agent Controller  |
|             | voraus.                                                |
+-------------+--------------------------------------------------------+
| Agen        | In Checkmk Cloud können Sie die Agentenbäckerei        |
| tenbäckerei | zusätzlich nutzen, um Agentenpakete mit einer          |
| (*Agent     | Konfiguration für die Autoregistrierung zu versehen.   |
| Bakery*)    | Die Regel für die Agentenbäckerei heißt [[Agent        |
|             | controller                                             |
|             | auto-registration.]{.guihi                             |
|             | nt}](hosts_autoregister.html#rule_autoregister_bakery) |
|             | Diese Pakete führen die Registrierung automatisch nach |
|             | der Installation durch.                                |
+-------------+--------------------------------------------------------+
| B           | Die [vordefinierte                                     |
| erechtigung | Rolle](wato_user.html#predefined_roles)                |
| zur         | `agent_registration` enthält in Checkmk Cloud          |
| Agentenre   | zusätzliche Berechtigungen, um Hosts automatisch zu    |
| gistrierung | erstellen.                                             |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#connectors .hidden-anchor .sr-only}5.3. Anbindungen {#heading_connectors}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Grafana     | Das [Grafana-Plugin](grafana.html) können Sie direkt   |
|             | aus dem                                                |
|             | [Grafana-Katalog](https://grafana.com/graf             |
|             | ana/plugins/checkmk-cloud-datasource){target="_blank"} |
|             | installieren, so dass sich die Integration einfach in  |
|             | Ihre Cloud-Umgebung einbetten lässt.                   |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#provision .hidden-anchor .sr-only}5.4. Bereitstellung {#heading_provision}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Ve          | Checkmk Cloud steht in den Marketplaces von [Microsoft |
| rfügbarkeit | Azure](https://azuremarketp                            |
| in den      | lace.microsoft.com/de-de/marketplace/apps/tribe29gmbh1 |
| Azure und   | 665582614827.checkmk003?tab=Overview){target="_blank"} |
| AWS         | und                                                    |
| M           | [AWS](https://aws.amazon.com/m                         |
| arketplaces | arketplace/pp/prodview-gddkal2hfn7yo){target="_blank"} |
|             | zur Installation bereit. Die Artikel zu den Images von |
|             | [Azure](install_azure.html) und                        |
|             | [AWS](install_aws.html) führen Sie in die Einrichtung  |
|             | ein.                                                   |
+-------------+--------------------------------------------------------+
| Test der    | Sie können Checkmk Cloud 30 Tage lang in vollem        |
| Edition     | Funktionsumfang unverbindlich testen. In kleinem       |
|             | Rahmen, d.h. mit einer Instanz und bis zu 750          |
|             | Services, können Sie Checkmk mit Checkmk Cloud auch    |
|             | dauerhaft ohne Subskription betreiben.                 |
+-------------+--------------------------------------------------------+
:::

::: sect2
### []{#other .hidden-anchor .sr-only}5.5. Weitere Funktionen {#heading_other}

+-------------+--------------------------------------------------------+
| Funktion    | Ergänzende Informationen                               |
+=============+========================================================+
| Ch          | In Checkmk Cloud gibt es zusätzlich Check-Plugins für  |
| eck-Plugins | die AWS Cloud-Produkte [AWS                            |
| für AWS     | Lambda,](https://checkmk.com/de/inte                   |
|             | grations?distributions%5B%5D=check_mk&distributions%5B |
|             | %5D=check_mk_cloud&search=aws_lambda){target="_blank"} |
|             | [Elastic Container Service                             |
|             | (ECS),](https://checkmk.com/de/i                       |
|             | ntegrations?distributions%5B%5D=check_mk&distributions |
|             | %5B%5D=check_mk_cloud&search=aws_ecs){target="_blank"} |
|             | [Route                                                 |
|             | 53,](https://che                                       |
|             | ckmk.com/de/integrations/aws_route53){target="_blank"} |
|             | [CloudFront,](https://checkm                           |
|             | k.com/de/integrations/aws_cloudfront){target="_blank"} |
|             | [ElastiCache for                                       |
|             | Redis](https://checkmk.com/de/integ                    |
|             | rations?distributions%5B%5D=check_mk&distributions%5B% |
|             | 5D=check_mk_cloud&search=elasticache){target="_blank"} |
|             | und [Simple Notification Service                       |
|             | (SNS).](https://checkmk.com/de/i                       |
|             | ntegrations?distributions%5B%5D=check_mk&distributions |
|             | %5B%5D=check_mk_cloud&search=aws_sns){target="_blank"} |
+-------------+--------------------------------------------------------+
| Ch          | In Checkmk Cloud gibt es zusätzlich Check-Plugins für  |
| eck-Plugins | die Azure-Produkte [Application                        |
| für Azure   | Gateway](https://checkmk.c                             |
|             | om/de/integrations/azure_app_gateway){target="_blank"} |
|             | und [Recovery Services                                 |
|             | vaults.](https://checkmk.com/de/integr                 |
|             | ations/azure_vault_backup_containers){target="_blank"} |
+-------------+--------------------------------------------------------+
| Ch          | In Checkmk Cloud gibt es zusätzlich Check-Plugins für  |
| eck-Plugins | die Goggle Cloud-Produkte [Cloud                       |
| für GCP     | Functions,](https://checkmk.com/de/integr              |
|             | ations?distributions%5B%5D=check_mk&distributions%5B%5 |
|             | D=check_mk_cloud&search=gcp_function){target="_blank"} |
|             | [Cloud                                                 |
|             | Run](https://checkmk.com/de/i                          |
|             | ntegrations?distributions%5B%5D=check_mk&distributions |
|             | %5B%5D=check_mk_cloud&search=gcp_run){target="_blank"} |
|             | und [Memorystore for                                   |
|             | Redis.](https://checkmk.com/de/int                     |
|             | egrations?distributions%5B%5D=check_mk&distributions%5 |
|             | B%5D=check_mk_cloud&search=gcp_redis){target="_blank"} |
+-------------+--------------------------------------------------------+
:::
::::::::
:::::::::
:::::::::::::::::::::::::::::::::
