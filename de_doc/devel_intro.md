:::: {#header}
# Erweiterungen für Checkmk entwickeln

::: details
[Last modified on 10-Oct-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/devel_intro.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Lokale Checks](localchecks.html) [Agentenbasierte Check-Plugins
schreiben](devel_check_plugins.html) [SNMP-basierte Check-Plugins
schreiben](devel_check_plugins_snmp.html)
[Monitoring-Agenten](wato_monitoringagents.html) [Services verstehen und
konfigurieren](wato_services.html) [Checkmk-Erweiterungspakete
(MKPs)](mkps.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Mit über 2000 [mitgelieferten
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"} und
vielfältigen Methoden für die [Überwachung von Dateien und
Ordnerinhalten,](mk_filestats.html) die [Auswertung von
Log-Meldungen](ec.html) sowie die [Überwachung wiederkehrender
Aufgaben](monitoring_jobs.html) hat Checkmk für eine Fülle von
Monitoring-Aufgaben die passende Out-of-the-Box-Lösung. Und wo es die
nicht gibt, hilft die Community gerne mit in der [Checkmk
Exchange](https://exchange.checkmk.com/){target="_blank"}
bereitgestellten Eigenentwicklungen.
:::

::: paragraph
Dennoch kommt es immer wieder vor, dass eine Hardware zu neu ist, eine
Software zu exotisch oder eine firmeninterne Eigenentwicklung zu
individuell, als dass schon jemand Bedarf für die Integration in Checkmk
gesehen hätte. Sind Sie an diesem Punkt angelangt, ist es an der Zeit,
sich mit der Programmierung eigener Erweiterungen zu befassen.
:::

::: paragraph
Dieser Artikel zeigt eine Übersicht der zur Verfügung stehenden
Möglichkeiten.
:::

::: paragraph
Und die sind vielfältig: In manchen Fällen genügt es beispielsweise, ein
Backup-Skript um wenige Zeilen zu erweitern, um Erfolg oder Misserfolg
in einer gut in Checkmk darstellbaren Form auszugeben -- damit ist die
„Eigenentwicklung" mitunter in wenigen Minuten abgeschlossen. In anderen
Fällen werden Sie darauf angewiesen sein, mit umfangreichen Graphen
Lastsituationen zu visualisieren -- dann lohnt es sich auch, einige
Stunden mehr zu investieren.
:::
:::::::
::::::::

::::::::::::::::::::::::: sect1
## []{#_erweiterungsmöglichkeiten_mit_eigenen_programmen .hidden-anchor .sr-only}2. Erweiterungsmöglichkeiten mit eigenen Programmen {#heading__erweiterungsmöglichkeiten_mit_eigenen_programmen}

:::::::::::::::::::::::: sectionbody
::: paragraph
Die folgenden Abschnitte zeigen, welche Verfahren in Checkmk möglich
sind, eigene Erweiterungen zu integrieren, und wo dabei jeweils die
Datenerhebung und die Auswertung erfolgt.
:::

::::: sect2
### []{#local_checks .hidden-anchor .sr-only}2.1. Lokale Checks {#heading_local_checks}

::: paragraph
Die wahrscheinlich einfachste Art und Weise, Checkmk zu erweitern, sind
[lokale Checks.](localchecks.html) Ein Programm, welches vom
Agentenskript des überwachten Hosts ausgeführt wird, gibt in einer Zeile
Namen, Zustand und weitere Informationen aus. Für lokale Checks
unterstützt Checkmk die automatische
[Service-Erkennung.](glossar.html#service_discovery) Die Programmierung
ist in beliebigen Sprachen möglich, ohne eine API erlernen zu müssen.
:::

::: ulist
- **Ausführung:** Vollständig auf dem überwachten Host. Sie müssen
  selbst sicherstellen, dass gegebenenfalls auf allen Hosts, die einen
  lokalen Check erhalten, der passende Interpreter verfügbar ist.

- **Schwellwerte:** Ein Paar von unteren und von oberen Schwellwerten
  (für die Übergänge nach [WARN]{.state1} respektive [CRIT]{.state2})
  kann von der Checkmk-Instanz verwaltet werden.

- **Metriken:** Mehrere Metriken pro Service sind möglich. Einheiten
  können nicht explizit verwaltet werden, diese werden automatisch
  zugewiesen oder weggelassen.
:::
:::::

:::::: sect2
### []{#check_plugins_agent .hidden-anchor .sr-only}2.2. Native agentenbasierte Check-Plugins {#heading_check_plugins_agent}

::: paragraph
Die [agentenbasierten Check-Plugins](devel_check_plugins.html) werten
vom Checkmk-Agenten gelieferte Daten aus. Ein
[Agentenplugin](glossar.html#agent_plugin) sammelt Rohdaten und filtert
diese vor, führt aber keine Bewertung der erhobenen Daten durch. Diese
Datensammlung kann in beliebigen Programmiersprachen erfolgen. Sehr
verbreitet ist die Ausgabe als JSON-Datei oder im CSV-Format. Sie werden
aber auch viele Agentenplugins sehen, die nur rohe Linux-Systembefehle
aufrufen.
:::

::: paragraph
Auf dem Checkmk-Server findet dann die Auswertung durch ein in Python
geschriebenes Check-Plugin statt, welches APIs von Checkmk nutzt. Die
Ermittlung des Zustands kann dabei sehr flexibel erfolgen. So ist die
Verwendung unterer und oberer Schwellwerte möglich. Zudem können mehrere
Services erzeugt und der Status eines Services durch mehrere
Überprüfungen bestimmt werden. Des Weiteren ist die Ermittlung von
Trends und Einbeziehung älterer Werte möglich. Native Check-Plugins
unterstützen die automatische Erstellung von
[Labels](glossar.html#label) und die [HW/SW-Inventur.](inventory.html)
:::

::: ulist
- **Ausführung:** Agentenplugin zur Datensammlung in beliebiger
  Programmiersprache auf dem überwachten Host, weitere Auswertung durch
  Check-Plugin auf dem Checkmk-Server unter Verwendung der Check-API.

- **Schwellwerte:** Beliebige Kombination von Schwellwerten für jeden
  Service.

- **Metriken:** Beliebig viele Metriken pro Service mit Einheiten.
:::
::::::

:::::: sect2
### []{#special_agent .hidden-anchor .sr-only}2.3. Spezialagenten {#heading_special_agent}

::: paragraph
Eine Erweiterung der agentenbasierten Check-Plugins sind
[Spezialagenten:](datasource_programs.html#specialagents) Hier sammelt
kein Agentenplugin die Rohdaten ein, sondern ein Programm, das auf dem
Checkmk-Server läuft und Daten aus einer anderen Quelle abfragt und in
das Agentenformat von Checkmk umwandelt. Spezialagenten kommen
beispielsweise zum Einsatz, wenn ein zu überwachendes Gerät fürs
Monitoring relevante Daten als JSON oder XML über eine REST-API
bereitstellt. Beispiele für den Einsatz von bei Checkmk mitgelieferten
Spezialagenten finden Sie in der Überwachung von
[AWS](monitoring_aws.html), [Azure](monitoring_azure.html) oder
[VMware.](monitoring_vmware.html)
:::

::: paragraph
Bei der Programmierung greifen Sie auf zwei APIs zu: Für die
Konfiguration von Ports oder ähnlichem stellt Checkmk eine API bereit,
die erlaubt, solche Einstellungen im Setup zu bestimmen. Für die
Datenabfrage selbst verwenden Sie die REST-API der externen Quelle. Die
Auswertung auf dem Checkmk-Server erfolgt so, wie im vorherigen
Abschnitt zu nativen Check-Plugins beschrieben.
:::

::: ulist
- **Ausführung:** Programm/Skript zur Datensammlung und weiteren
  Auswertung auf dem Checkmk-Server.

- **Schwellwerte:** Beliebige Kombination von Schwellwerten für jeden
  Service.

- **Metriken:** Beliebig viele Metriken pro Service mit Einheiten.
:::
::::::

:::::: sect2
### []{#check_plugins_snmp .hidden-anchor .sr-only}2.4. Native SNMP-basierte Check-Plugins {#heading_check_plugins_snmp}

::: paragraph
Eine Variante der agentenbasierten Check-Plugins sind die [Check-Plugins
für SNMP.](devel_check_plugins_snmp.html) Der Unterschied besteht hier
darin, dass keine Agentensektion angefordert und ausgewertet wird,
sondern bestimmte SNMP-OIDs, die explizit vom SNMP-Agenten angefordert
werden.
:::

::: ulist
- **Ausführung:** Datensammlung und weitere Auswertung durch
  Check-Plugin auf dem Checkmk-Server unter Verwendung der Check-API.

- **Schwellwerte:** Beliebige Kombination von Schwellwerten für jeden
  Service.

- **Metriken:** Beliebig viele Metriken pro Service mit Einheiten.
:::

::: paragraph
Da das SNMP-Protokoll inhärent sehr ineffizient ist, raten wir, SNMP nur
dann zu verwenden, wenn kein anderer Zugriff auf die Monitoring-Daten
möglich ist. Stellt ein Gerät beispielsweise dieselben Daten auch über
eine REST-API zur Verfügung, sollten Sie dafür einen Spezialagenten
bauen.
:::
::::::

::::::: sect2
### []{#check_plugins_nagios .hidden-anchor .sr-only}2.5. Legacy-Nagios-Check-Plugins {#heading_check_plugins_nagios}

::: paragraph
An zwei Stellen in Checkmk finden Sie Nagios-Check-Plugins: Als [aktive
Checks,](active_checks.html) um vom Checkmk-Server aus die
Erreichbarkeit bestimmter Services zu prüfen. Und als
[MRPE-Erweiterung](active_checks.html#mrpe) der
[Windows-](agent_windows.html#mrpe) oder
[Linux-](agent_linux.html#mrpe)Agenten, um solche Services von einem
Host aus prüfen zu lassen - falls sie vom Checkmk-Server nicht
erreichbar sind.
:::

::: paragraph
Die Programmierung ist in beliebigen Sprachen möglich.
:::

::: ulist
- **Ausführung:** Vollständig auf dem überwachten Host (via MRPE) oder
  vollständig auf dem Checkmk-Server (aktiver Check).

- **Schwellwerte:** Schwellwerte nur bei Verwendung als aktiver Check.

- **Metriken:** Metriken nur bei Verwendung als aktiver Check.
:::

::: paragraph
Wegen diverser Nachteile wie umständlicher Fehlersuche empfehlen wir die
Neuimplementierung nur, wenn vollumfängliche Kompatibilität zu Nagios
erforderlich ist. Verwenden Sie in allen anderen Fällen native
Check-Plugins oder -- bei einfachen Überprüfungen -- lokale Checks. Eine
ausführliche Dokumentation der Ausgabeformate finden Sie auf
[Monitoring-Plugins.org](https://www.monitoring-plugins.org/){target="_blank"}.
:::
:::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::::::: sect1
## []{#further_readings .hidden-anchor .sr-only}3. Ergänzende Artikel {#heading_further_readings}

::::::::::::::: sectionbody
:::::: sect2
### []{#spool_directory .hidden-anchor .sr-only}3.1. Das Spool-Verzeichnis {#heading_spool_directory}

::: paragraph
Checkmk stellt noch einen weiteren Mechanismus bereit, wie Agentendaten
erzeugt werden können: Lassen Sie ein Programm direkt eine Textdatei im
Checkmk-Agentenformat schreiben. Im
[Spool-Verzeichnis](spool_directory.html) abgelegt überträgt der
Checkmk-Agent den Inhalt dieser Datei mit der restlichen Agentenausgabe.
:::

::: paragraph
Mit dem Spool-Verzeichnis können Sie beispielsweise Backup-Skripte
direkt bei Beendigung Status und Statistik für einen lokalen Check oder
ein Check-Plugin schreiben lassen. Dies erspart Umwege über die
Auswertung von Log-Dateien.
:::

::: paragraph
Bei der Entwicklung eigener Check-Plugins helfen Spool-Dateien,
bestimmte Ausgaben Ihres Agentenplugins zu simulieren.
:::
::::::

::::: sect2
### []{#piggyback .hidden-anchor .sr-only}3.2. Der Piggyback-Mechanismus {#heading_piggyback}

::: paragraph
Der [Piggyback](glossar.html#piggyback)-Mechanismus kommt dann zum
Einsatz, wenn ein Host etwas über einen anderen weiß. Eine speziell
formatierte Agentensektion wird dann beim Auswerten der Agentenausgabe
dem betreffenden Host zugeordnet.
:::

::: paragraph
Bei virtuellen Maschinen wird der Piggyback-Mechanismus genutzt, um von
der Virtualisierungssoftware erhobene Daten mit den Daten aus dem
Monitoring von innerhalb der virtuellen Maschine zusammenzuführen.
:::
:::::

:::: sect2
### []{#mkps .hidden-anchor .sr-only}3.3. Checkmk-Erweiterungspakete (MKPs) {#heading_mkps}

::: paragraph
Wenn Sie eigene Erweiterungen programmiert haben und diese versionieren
und schließlich weitergeben wollen, haben Sie die Möglichkeit,
zusammengehörige Dateien in [Checkmk-Erweiterungspaketen
(MKPs)](mkps.html) zu bündeln. Dieses Paketformat müssen Sie auch
nutzen, wenn Sie diese Erweiterungen in der [Checkmk
Exchange](https://exchange.checkmk.com/){target="_blank"} anbieten
wollen.
:::
::::

::::: sect2
### []{#bakery_api .hidden-anchor .sr-only}3.4. Die Bakery-API {#heading_bakery_api}

::: paragraph
In vielen Fällen werden Sie Agentenplugins mit zusätzlicher
Konfiguration versehen wollen. Oder Sie möchten in Abhängigkeit von im
Setup von Checkmk vorgenommenen Einstellungen bestimmte
*Installations-Scriptlets* ausführen lassen.
:::

::: paragraph
Wenn Sie für die Verteilung von Agentenpaketen die
[Agentenbäckerei](glossar.html#agent_bakery) verwenden, steht Ihnen mit
der [Bakery-API](bakery_api.html) eine Programmierschnittstelle zur
Verfügung, mit der in Checkmk vorgenommene Einstellungen einfach den Weg
auf überwachte Hosts finden.
:::
:::::
:::::::::::::::
::::::::::::::::

:::::: sect1
## []{#contribute .hidden-anchor .sr-only}4. Zu Checkmk beitragen {#heading_contribute}

::::: sectionbody
::: paragraph
Wenn Sie selbst Erweiterungen programmieren, raten wir zunächst dazu,
diese in die [Checkmk
Exchange](https://exchange.checkmk.com/){target="_blank"} einzureichen.
Hier bleiben Sie Eigentümer und Ansprechpartner und Sie können
unkompliziert neue Versionen bereitstellen. Da die Anforderungen an die
Code-Qualität für die Exchange nicht so hoch sind wie für mit Checkmk
ausgelieferte Check-Plugins, können Sie via Exchange neue Ideen
unkompliziert mit einem breiten Publikum ausprobieren.
:::

::: paragraph
Sollten Sie irgendwann zum Entschluss kommen, dass Ihr Check-Plugin
fester Bestandteil von Checkmk werden soll, lesen Sie zunächst
[Contributing to
Checkmk](https://github.com/Checkmk/checkmk/blob/master/CONTRIBUTING.md){target="_blank"}.
:::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::
