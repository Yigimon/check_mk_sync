:::: {#header}
# Die Konfiguration von Checkmk

::: details
[Last modified on 08-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/wato.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk auf der Kommandozeile](cmk_commandline.html) [Verwaltung der
Hosts](hosts_setup.html) [Regeln](wato_rules.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#setup_menu .hidden-anchor .sr-only}1. Setup-Menü {#heading_setup_menu}

:::::::::: sectionbody
::: paragraph
Ihr Einstieg in die Konfiguration von Checkmk ist das
[Setup]{.guihint}-Menü, das Sie über die Navigationsleiste öffnen
können:
:::

::::: imageblock
::: content
![Setup-Menü in der
Navigationsleiste.](../images/wato_setup_menu_showmore.png)
:::

::: title
Das [Setup]{.guihint}-Menü von Checkmk Cloud im Show-more-Modus
:::
:::::

::: paragraph
In diesem Menü finden Sie die Werkzeuge, mit denen Sie Checkmk
einrichten und konfigurieren können. Das Menü ist nach Themen (*topics*)
untergliedert. Unterhalb jedes Themas finden Sie die Menüeinträge.
:::

::: paragraph
Die folgende Tabelle gibt einen Überblick über die Menüs, und in welchem
Teil des Handbuchs Sie genauere Informationen erhalten.
:::

+-----------------+-----------------------------------------------------+
| Menü            | Inhalt                                              |
+=================+=====================================================+
| [H              | Die [Verwaltung der zu überwachenden                |
| osts]{.guihint} | Hosts.](hosts_setup.html) Hier finden Sie die       |
|                 | Hosts, die [Regeln](wato_rules.html) für das        |
|                 | Monitoring der Hosts, die                           |
|                 | [Host-Merkmale,](host_tags.html) die Verbindungen   |
|                 | für die [dynamische Host-Verwaltung](dcd.html) (nur |
|                 | in den kommerziellen Editionen), die                |
|                 | [Host-Gruppen](hosts_structure.html#host_groups)    |
|                 | und die Regeln für die                              |
|                 | [Hardware/Software-Inventur.](inventory.html) Mit   |
|                 | den [Custom host attributes]{.guihint} können Sie   |
|                 | selbst Attribute erstellen, die den Eigenschaften   |
|                 | der Hosts hinzugefügt werden.                       |
+-----------------+-----------------------------------------------------+
| [Serv           | Die [Verwaltung der Services](wato_services.html),  |
| ices]{.guihint} | die auf den Hosts laufen. Hier finden Sie die       |
|                 | [Regeln](wato_rules.html) für das Monitoring der    |
|                 | Services, für die                                   |
|                 | [Service-Erkennung,](wato_services.html#discovery)  |
|                 | für [erzwungene                                     |
|                 | Services](wato_services.html#enforced_services) und |
|                 | für die Überwachung von Netzwerkdiensten wie HTTP,  |
|                 | TCP, E-Mail ([aktive Checks](active_checks.html)).  |
|                 | Außerdem können Sie die Liste der                   |
|                 | [                                                   |
|                 | Service-Gruppen](wato_services.html#service_groups) |
|                 | und den [Katalog der                                |
|                 | Check-Plugins](ht                                   |
|                 | tps://checkmk.com/de/integrations){target="_blank"} |
|                 | in Checkmk öffnen.                                  |
+-----------------+-----------------------------------------------------+
| [Business       | Der Einstieg in die Verwaltung der [Business        |
| Intellig        | Intelligence (BI).](bi.html)                        |
| ence]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [Ag             | Die                                                 |
| ents]{.guihint} | [Monitoring-Agenten](wato_monitoringagents.html),   |
|                 | die die Daten von den Hosts übermitteln. Hier gibt  |
|                 | es die                                              |
|                 | [                                                   |
|                 | Checkmk-Agenten](wato_monitoringagents.html#agents) |
|                 | für Linux, Windows und andere Betriebssysteme zum   |
|                 | Download, Zugang zur                                |
|                 | [                                                   |
|                 | Agentenbäckerei](wato_monitoringagents.html#bakery) |
|                 | (nur in den kommerziellen Editionen), mit der       |
|                 | Agenten konfiguriert, paketiert und automatisch     |
|                 | aktualisiert werden können, und zur                 |
|                 | Agentenregistrierung um [Hosts automatisch zu       |
|                 | erstellen](hosts_autoregister.html) (nur in Checkmk |
|                 | Cloud und Checkmk MSP). Außerdem finden Sie hier    |
|                 | Regeln zur Überwachung anderer Systeme --- z.B.     |
|                 | über [SNMP.](snmp.html) Der Eintrag [VM, cloud,     |
|                 | container]{.guihint} führt Sie u.a. zu den Regeln   |
|                 | zur Überwachung von [Amazon Web Services            |
|                 | (AWS),](monitoring_aws.html) [Microsoft             |
|                 | Azure,](monitoring_azure.html) [Google Cloud        |
|                 | Platform (GCP),](monitoring_gcp.html)               |
|                 | [Kubernetes,](monitoring_kubernetes.html)           |
|                 | [Prometheus](monitoring_prometheus.html) und        |
|                 | [VMware ESXi.](monitoring_vmware.html)              |
+-----------------+-----------------------------------------------------+
| [Ev             | Die Verarbeitung von Ereignissen --- mit Regeln für |
| ents]{.guihint} | [Benachrichtigungen](notifications.html), [Event    |
|                 | Console](ec.html) und [Alert                        |
|                 | Handler](alert_handlers.html) (nur in den           |
|                 | kommerziellen Editionen).                           |
+-----------------+-----------------------------------------------------+
| [U              | Die Themen rund um [Benutzer, Zuständigkeiten und   |
| sers]{.guihint} | Berechtigungen](wato_user.html). Sie können die     |
|                 | Listen der Benutzer, Kontaktgruppen und Rollen      |
|                 | aufrufen, die [Benutzerverwaltung mit LDAP/Active   |
|                 | Directory](ldap.html) einrichten und die Anmeldung  |
|                 | mit [SAML](saml.html) konfigurieren (nur in den     |
|                 | kommerziellen Editionen).                           |
+-----------------+-----------------------------------------------------+
| [Gen            | Übergreifende Themen finden Sie hier, u.a. [Rule    |
| eral]{.guihint} | search]{.guihint} zum (Wieder-)Finden von Regeln,   |
|                 | die globalen Einstellungen ([Global                 |
|                 | settings]{.guihint}), die [vordefinierten           |
|                 | Bedingungen,](wato_rules.html#conditions) die       |
|                 | [Zeitperioden,](timeperiods.html) den               |
|                 | [Passwortspeicher](password_store.html) und den     |
|                 | Einstieg in das [verteilte                          |
|                 | Monitoring.](distributed_monitoring.html) Mit       |
|                 | [Audit log]{.guihint} können Sie sich alle jemals   |
|                 | durchgeführten Änderungen der                       |
|                 | Konfigurationsumgebung anzeigen lassen und mit dem  |
|                 | [Read only mode]{.guihint} solche Änderungen        |
|                 | temporär unterbinden.                               |
+-----------------+-----------------------------------------------------+
| [Mainten        | Dieses Thema fasst Aktionen zur Wartung von Checkmk |
| ance]{.guihint} | zusammen, wie z.B. die Erstellung von               |
|                 | [Backups,](backup.html) die [Analyse der            |
|                 | Checkmk-Konfiguration](analyze_configuration.html)  |
|                 | oder die Auswahl der Daten für die [Support         |
|                 | Diagnostics.](support_diagnostics.html) Die         |
|                 | Einträge für die [Lizenzierung](license.html) und   |
|                 | zum Umgang mit [Checkmk-Erweiterungspaketen         |
|                 | (MKPs)](mkps.html) gibt es nur in den kommerziellen |
|                 | Editionen.                                          |
+-----------------+-----------------------------------------------------+
| [Expo           | Der Export von Daten, d.h. von Metriken an          |
| rter]{.guihint} | [InfluxDB (und Graphite).](metrics_exporter.html)   |
|                 | Dieses Thema gibt es nur in den kommerziellen       |
|                 | Editionen.                                          |
+-----------------+-----------------------------------------------------+

::: paragraph
Die Konfiguration wird von Checkmk in handlichen Textdateien
gespeichert, welche erfahrene Benutzer auch von Hand editieren oder
sogar per Skript erzeugen können.
:::
::::::::::
:::::::::::

::::::::: sect1
## []{#quick_setup .hidden-anchor .sr-only}2. Quick setup {#heading_quick_setup}

:::::::: sectionbody
::: paragraph
Wenn Sie schon länger mit dem [Setup]{.guihint}-Menü arbeiten, werden
Sie die Symbole im Menü wahrscheinlich schon auswendig
kennen --- insbesondere dann, wenn Sie sich die Symbole in den
Mega-Menüs bei jedem Menüeintrag anzeigen lassen, wie Sie es im
[User-Menü](user_interface.html#user_menu) einstellen können.
:::

::: paragraph
Dann empfiehlt sich für den Schnellzugriff das Snapin [Quick
setup]{.guihint} für die [Seitenleiste](user_interface.html#sidebar) mit
Symbolen für jeden [Setup]{.guihint}-Menüeintrag:
:::

::::: imageblock
::: content
![Snapin Quick setup.](../images/wato_quick_setup.png){width="50%"}
:::

::: title
Das Snapin [Quick setup]{.guihint} von Checkmk Cloud im Show-less-Modus
:::
:::::
::::::::
:::::::::

:::::::::::::::: sect1
## []{#activate_changes .hidden-anchor .sr-only}3. Änderungen aktivieren {#heading_activate_changes}

::::::::::::::: sectionbody
::: paragraph
Checkmk speichert alle Änderungen, die Sie vornehmen, zunächst nur in
einer vorläufigen **Konfigurationsumgebung**, in der Sie Hosts, Services
und Einstellungen verwalten, und die das aktuell laufende Monitoring
noch nicht beeinflusst. Erst durch das „Aktivieren der ausstehenden
Änderungen" werden diese in die **Monitoring-Umgebung** übernommen.
:::

::: paragraph
Änderungen in der Konfiguration --- z.B. das Hinzufügen eines neuen
Hosts --- haben also zunächst keinen Einfluss auf das Monitoring. Erst
durch die Aktivierung werden alle Änderungen, die sich seit der letzten
Aktivierung angesammelt haben, gleichzeitig aktiv.
:::

::: paragraph
Vielleicht mag Ihnen das umständlich erscheinen. Es hat aber den
Vorteil, dass Sie eine komplexere Änderung erst in Ruhe vorbereiten
können, bevor diese produktiv geht. So kann es z.B. sein, dass Sie nach
dem Hinzufügen eines Hosts erst noch Schwellwerte setzen oder manche
Services entfernen möchten, bevor das Ganze „scharfgeschaltet" werden
soll.
:::

::: paragraph
Wann immer Sie mit dem [Setup]{.guihint}-Menü eine Änderung an der
Monitoring-Umgebung durchführen, wird diese zunächst gesammelt und gilt
als *pending*.
:::

::: paragraph
Sie finden auf jeder Seite der Konfigurationsumgebung rechts oben einen
gelben Knopf mit der Zahl der ausstehenden Änderungen, die noch nicht
aktiviert sind. Dieser Knopf bringt Sie zu einer Liste dieser
Änderungen:
:::

:::: imageblock
::: content
![Liste der ausstehenden Änderungen zur
Aktivierung.](../images/wato_pending_log.png)
:::
::::

::: paragraph
Durch Klick auf [Activate on selected sites]{.guihint} wird aus den
Konfigurationsdateien eine neue Konfiguration für den Monitoring-Kern
erzeugt und diesem der Befehl gegeben, diese Konfiguration ab sofort zu
verwenden:
:::

:::: imageblock
::: content
![Illustration zur Übernahme von Änderungen aus der
Konfigurationsumgebung in die
Monitoring-Umgebung.](../images/wato_activate_changes.png){width="500px"}
:::
::::

::: paragraph
Die Liste der anstehenden Änderungen wird dadurch geleert. Diese
Einträge sind aber nicht verloren, sondern können über [Setup \> General
\> Audit log]{.guihint} abgerufen werden. Dort finden Sie den Inhalt der
Log-Datei mit allen aktivierten Änderungen, die in der Instanz jemals
durchgeführt wurden. Die Anzeige in [Audit log]{.guihint} kann gefiltert
werden und zeigt standardmäßig die Änderungen von heute.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie versuchen, Änderungen zu |
|                                   | aktivieren und gerade eine andere |
|                                   | Aktivierung läuft, erhalten Sie   |
|                                   | eine entsprechende Warnung:       |
|                                   | :::                               |
|                                   |                                   |
|                                   | :::: imageblock                   |
|                                   | ::: content                       |
|                                   | ![Meldung, dass die Aktivierung   |
|                                   | aktuell blockiert                 |
|                                   | ist.](../im                       |
|                                   | ages/wato_activation_blocked.png) |
|                                   | :::                               |
|                                   | ::::                              |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Aus der Meldung können Sie        |
|                                   | ablesen, wer (d.h., welcher       |
|                                   | Checkmk-Benutzer) eine andere     |
|                                   | Aktivierung auf welchem Weg (über |
|                                   | die GUI oder die                  |
|                                   | [REST-API](rest_api.html))        |
|                                   | gestartet hat.                    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::
::::::::::::::::

::::::::: sect1
## []{#revert_changes .hidden-anchor .sr-only}4. Änderungen rückgängig machen {#heading_revert_changes}

:::::::: sectionbody
::: paragraph
Die Aktivierung von Änderungen wird Ihnen bei der Einrichtung Ihrer
Überwachung ebenso wie bei jeder späteren Anpassung der Konfiguration
immer wieder begegnen. Gerade wenn Sie komplexere Modifikationen an
Ihrem System vornehmen, kann es passieren, dass Sie doch im Laufe eines
Bearbeitungsprozesses Änderungen rückgängig machen wollen anstatt sie zu
aktivieren. Nutzen Sie hierfür den Menüeintrag [Changes \> Revert
changes.]{.guihint}
:::

::: paragraph
Damit können Sie alle seit dem letzten [Activate on selected
sites]{.guihint} ausstehenden Änderungen verwerfen:
:::

:::: imageblock
::: content
![Bestätigung zum Rückgängig machen der
Änderungen.](../images/wato_revert_changes.png)
:::
::::

::: paragraph
Im unteren Bereich werden Ihnen alle Änderungen angezeigt, die nach der
Zustimmung im Bestätigungsdialog verworfen werden. Sie kehren damit zum
Stand der letzten Änderungsaktivierung zurück.
:::
::::::::
:::::::::
::::::::::::::::::::::::::::::::::::::::::::::
