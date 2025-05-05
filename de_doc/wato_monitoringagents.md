:::: {#header}
# Monitoring-Agenten

::: details
[Last modified on 26-Sep-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/wato_monitoringagents.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen](agent_linux.html) [Windows
überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::: sectionbody
::: paragraph
Damit ein Monitoring-System von einem überwachten Zielsystem mehr
Informationen bekommt als nur, ob dieses erreichbar ist, benötigt es
dessen Mithilfe. Denn wie soll Checkmk z.B. wissen, wie voll ein
Dateisystem auf einem Server ist, ohne dass dieser das irgendwie
mitteilt? Die Komponente, die diese Auskunft gibt, ist immer ein aktives
Stück Software --- also ein *Monitoring-Agent* oder auch kürzer ein
*Agent.* Ein Agent sammelt die für das Monitoring relevanten Daten in
festgelegten Zeitabständen von einem Host ein und übermittelt die Daten
an den Monitoring-Server.
:::

::: paragraph
Für Server und Workstations bietet Checkmk eigene, die sogenannten
*Checkmk-Agenten* an. Checkmk-Agenten gibt es für verschiedenste
Betriebssysteme --- von gängigen wie Windows und Linux, bis zu Exoten
wie OpenVMS. Die Agenten verhalten sich im
[Pull-Modus](glossar.html#pull_mode) passiv und horchen auf TCP-Port
6556. Erst bei einer Abfrage durch den Checkmk-Server werden sie aktiv
und antworten mit den benötigten Daten. Im
[Push-Modus](glossar.html#push_mode) dagegen sendet der Checkmk-Agent
von sich aus regelmäßig die Monitoring-Daten an den Checkmk-Server.
:::

::: paragraph
Alle Checkmk-Agenten finden Sie über die Weboberfläche im
[Setup]{.guihint}-Menü. Von dort können Sie die Agenten herunterladen
und auf dem Zielsystem installieren. Wie Sie Checkmk-Agenten
installieren, konfigurieren und erweitern können, erfahren Sie in diesem
Artikel.
:::

::: paragraph
Allerdings gibt es Situationen, in denen man für das Monitoring nicht
extra einen Agenten *installieren* muss --- weil nämlich schon einer
vorhanden ist, der genutzt werden kann. Bestes Beispiel ist hier SNMP:
Alle verwaltbaren Netzwerkgeräte und Appliances haben einen
[SNMP-Agenten](snmp.html) eingebaut. Checkmk greift auf diesen
SNMP-Agenten zu und holt sich mit aktiven Anfragen (GET) Details über
den Systemzustand ab.
:::

::: paragraph
Einige Systeme erlauben aber weder die Installation eines Agenten noch
unterstützen sie SNMP auf brauchbare Weise. Stattdessen bieten sie
Anwendungsprogrammierschnittstellen für das Management, sogenannte
*APIs*, die auf Telnet, SSH oder HTTP/XML basieren. Über diese
sogenannten [Spezialagenten](glossar.html#special_agent), die auf dem
Checkmk-Server laufen, fragt Checkmk diese Schnittstellen ab.
:::

::: paragraph
Ein Fall für sich ist schließlich die Überwachung von Netzwerkdiensten
wie HTTP, SMTP oder IMAP. Bei einem Netzwerkdienst liegt es nahe, den
Dienst über das Netzwerk abzufragen und über diesen Weg auch zu
überwachen. Dazu verwendet Checkmk teils eigene, teils bereits
existierende Plugins. Diese werden auch als [aktive
Checks](active_checks.html) bezeichnet. Sehr beliebt ist z.B.
`check_http` für das Abfragen von Webseiten. Aber selbst in diesem Fall
kommt meist zusätzlich ein Agent zum Einsatz, mit dem man auch die
übrigen Daten des Servers in das Monitoring bekommt.
:::

::: paragraph
Folgende Grafik zeigt Ihnen die verschiedenen Wege, wie Checkmk auf zu
überwachende Systeme zugreift:
:::

:::: {.imageblock .border}
::: content
![Illustration der Wege, auf denen Checkmk auf die überwachten Systeme
zugreift.](../images/monitoringagents_agent_access.png)
:::
::::

::: paragraph
Bisher haben wir nur von *aktiver* Überwachung gesprochen --- der
Paradedisziplin von Checkmk. Es gibt auch den umkehrten Weg, nämlich
dass die Zielsysteme von sich aus Nachrichten an das Monitoring senden,
z.B. per Syslog oder SNMP-Traps. Für dieses ganze Thema bietet Checkmk
die *Event Console*, die in einem [eigenen Artikel](ec.html) beschrieben
ist.
:::
:::::::::::::
::::::::::::::

:::::::::::::::::: sect1
## []{#agents .hidden-anchor .sr-only}2. Der Checkmk-Agent {#heading_agents}

::::::::::::::::: sectionbody
::: paragraph
Sie benötigen für die Überwachung eines Servers oder einer Workstation
ein kleines Programm, das auf dem Host installiert werden muss: den
Checkmk-Agenten.
:::

::: paragraph
Der Agent ist ein simples Shellskript, das minimalistisch, sicher und
leicht erweiterbar ist. In der Checkmk-Version [2.1.0]{.new} wurde
diesem **Agentenskript** mit dem **Agent Controller** eine neue
Komponente zur Seite gestellt. Der Agent Controller ist dem
Agentenskript vorgeschaltet, fragt dieses ab und kommuniziert an dessen
Stelle mit dem Checkmk-Server. Dazu registriert er sich am **Agent
Receiver**, der auf dem Checkmk-Server läuft.
:::

::::: {.imageblock .border}
::: content
![Illustration der Kommunikation zwischen Agent und
Instanz.](../images/monitoringagents_communication_flow.png)
:::

::: title
Zusammenspiel der Software-Komponenten
:::
:::::

::: paragraph
Diese Architektur ist beim
[Linux-Agenten](agent_linux.html#agent_architecture) und beim
[Windows-Agenten](agent_windows.html#agent_architecture) identisch. Nur
die technische Realisierung ist spezifisch für die Betriebssysteme.
:::

::: paragraph
Das **Agentenskript** ist zuständig für die Sammlung der
Monitoring-Daten und stellt diese dem Agent Controller zur Verfügung. Es
ist:
:::

::: ulist
- minimalistisch, denn es begnügt sich mit minimalen Ressourcen an RAM,
  CPU, Plattenplatz und Netzwerk.

- sicher, denn es erlaubt keinerlei Zugriffe aus dem Netzwerk.

- leicht erweiterbar, denn Sie können Plugins in einer beliebigen
  Programmier- oder Skriptsprache schreiben und vom Agentenskript
  ausführen lassen.
:::

::: paragraph
Der **Agent Controller** ist die Komponente des Agenten, die für den
Transport der vom Agentenskript gesammelten Daten zuständig ist. Im
Pull-Modus lauscht er am TCP-Port 6556 auf eingehende Verbindungen der
Checkmk-Instanz und fragt das Agentenskript ab.
:::

::: paragraph
Die Software-Architektur des Agenten mit dem Agent Controller ist die
Voraussetzung dafür, neue Funktionen anzubieten, die mit dem
minimalistischen Design des Agentenskripts nicht umsetzbar waren, wie
beispielsweise die Verschlüsselung der Kommunikation per Transport Layer
Security (TLS), Datenkomprimierung und die Umkehrung der
Kommunikationsrichtung vom [Pull-Modus](glossar.html#pull_mode) zum
[Push-Modus.](glossar.html#push_mode)
:::

::: paragraph
Im Pull-Modus initiiert der Checkmk-Server die Kommunikation und fragt
die Daten vom Agenten ab. Im Push-Modus geht die Initiative vom Agenten
aus. Der Push-Modus ist für eine Cloud-basierte Konfiguration und in
einigen abgeschotteten Netzwerken erforderlich. In beiden Fällen kann
der Checkmk-Server nicht auf das Netzwerk zugreifen, in dem sich die zu
überwachenden Hosts befinden. Daher sendet der Agent von sich aus
regelmäßig die Daten an den Checkmk-Server.
:::

::: paragraph
Der **Agent Receiver** ist die Komponente des Checkmk-Servers, die als
genereller Endpunkt für die Kommunikation des Agent Controllers dient,
z.B. für die Registrierung der Verbindung und für den Empfang der im
Push-Modus vom Agent Controller gesendeten Daten. Im Push-Modus werden
die empfangenen Daten vom Agent Receiver im Dateisystem abgelegt und so
den Fetchern der Instanz zur Verfügung gestellt, in den kommerziellen
Editionen sind das die
[Checkmk-Fetcher.](cmc_differences.html#fetcher_checker) Dagegen erfolgt
im Pull-Modus der Datenaustausch ohne Agent Receiver direkt zwischen den
Fetchern der Instanz und dem Agent Controller.
:::

::: paragraph
TLS-Verschlüsselung und Datenkomprimierung werden über den Agent
Controller und den Agent Receiver realisiert, d.h. Checkmk-Server und
Agent müssen mindestens Version [2.1.0]{.new} haben. Dabei ist nach der
Installation der erste Schritt die Registrierung des Agent Controller
beim Agent Receiver der Checkmk-Instanz, mit der ein
Vertrauensverhältnis hergestellt wird. Bei der Registrierung wird
bereits die TLS-Verschlüsselung der Kommunikation eingerichtet. Für den
Push-Modus müssen Checkmk-Server und Agent mindestens Version
[2.2.0]{.new} haben.
:::

::: paragraph
Die folgende Tabelle stellt die verschiedenen Funktionen des
Checkmk-Agenten zusammen und zeigt, in welchen Checkmk-Editionen diese
Funktionen verfügbar sind:
:::

+-----------------+-----------------------------------+-----------------+
| Funktion        | Beschreibung                      | Verfügbarkeit   |
+=================+===================================+=================+
| Registrierung   | Das Vertrauensverhältnis zwischen | Alle Editionen  |
|                 | dem Agent Controller des Hosts    | ab Version      |
|                 | und dem Agent Receiver der        | [2.1.0]{.new}   |
|                 | Checkmk-Instanz wird hergestellt. |                 |
+-----------------+-----------------------------------+-----------------+
| TLS-            | Nach erfolgreicher Registrierung  | Alle Editionen  |
| Verschlüsselung | werden die Daten mit TLS          | ab Version      |
|                 | verschlüsselt ausgetauscht.       | [2.1.0]{.new}   |
+-----------------+-----------------------------------+-----------------+
| Komprimierung   | Die Daten werden komprimiert      | Alle Editionen  |
|                 | ausgetauscht.                     | ab Version      |
|                 |                                   | [2.1.0]{.new}   |
+-----------------+-----------------------------------+-----------------+
| Pull-Modus      | Der Agent versendet die Daten auf | Alle Editionen  |
|                 | Anforderung der Checkmk-Instanz.  |                 |
+-----------------+-----------------------------------+-----------------+
| Push-Modus      | Der Agent versendet die Daten von | Checkmk Cloud   |
|                 | sich aus an die Checkmk-Instanz.  | ab Version      |
|                 |                                   | [2.2.0]{.new},  |
|                 |                                   | Checkmk MSP ab  |
|                 |                                   | [2.3.0]{.new}   |
+-----------------+-----------------------------------+-----------------+
| Individuelle    | Per                               | Kommerzielle    |
| Agent           | [Agentenbäc                       | Editionen       |
| enkonfiguration | kerei](glossar.html#agent_bakery) |                 |
|                 | können Agenten für einzelne oder  |                 |
|                 | Gruppen von Hosts individuell     |                 |
|                 | konfiguriert und die              |                 |
|                 | Agentenpakete für die             |                 |
|                 | Installation erstellt werden.     |                 |
+-----------------+-----------------------------------+-----------------+
| [Automatische   | Das Paket aus der Agentenbäckerei | Kommerzielle    |
| Agenten-U       | wird zuerst manuell oder per      | Editionen       |
| pdates](agent_d | Skript installiert und wird von   |                 |
| eployment.html) | da an automatisch aktualisiert.   |                 |
+-----------------+-----------------------------------+-----------------+
| [Automatische   | Die Registrierung des Agenten bei | Checkmk Cloud   |
| Erstellung von  | der Checkmk-Instanz und die       | ab Version      |
| H               | Erstellung des Hosts erfolgt      | [2.2.0]{.new},  |
| osts](hosts_aut | automatisch.                      | Checkmk MSP ab  |
| oregister.html) |                                   | [2.3.0]{.new}   |
+-----------------+-----------------------------------+-----------------+
:::::::::::::::::
::::::::::::::::::

::::::::::: sect1
## []{#download_page .hidden-anchor .sr-only}3. Agent von der Download-Seite herunterladen {#heading_download_page}

:::::::::: sectionbody
::: paragraph
Im Checkmk-Projekt werden aktuell Agenten für elf verschiedene
Betriebssystemfamilien gepflegt. Alle diese Agenten sind Bestandteil von
Checkmk und stehen über die Weboberfläche des Checkmk-Servers zum
Download bereit. Die Agenten erreichen Sie über [Setup \>
Agents]{.guihint}.
:::

::: paragraph
In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** führen Sie die Menüeinträge [Linux]{.guihint},
[Windows]{.guihint} und [Other operating systems]{.guihint} direkt zu
den Download-Seiten, auf denen Sie die vorkonfigurierten Agenten und
Agentenplugins finden, im folgenden Beispiel zur Download-Seite für
[Linux, Solaris, AIX]{.guihint}:
:::

:::: imageblock
::: content
![Liste der Linux-Agenten zum Download in Checkmk
Raw.](../images/monitoringagents_download_linux_cre.png)
:::
::::

::: paragraph
In den kommerziellen Editionen gelangen Sie mit dem Menüeintrag
[Windows, Linux, Solaris, AIX]{.guihint} zu einer Seite, die Ihnen
Zugang zur [Agentenbäckerei](#bakery) bietet. Von dieser Seite aus
kommen Sie mit dem Menüeintrag [Related]{.guihint} zu den Seiten mit den
Agentendateien wie in Checkmk Raw.
:::

::: paragraph
Die paketierten Agenten für Linux (im RPM- und DEB-Dateiformat) und für
Windows (im MSI-Dateiformat) finden Sie gleich im ersten Kasten der
entsprechenden Download-Seite. In diesen Softwarepaketen finden Sie seit
der Version [2.1.0]{.new} den neuen Agenten mit Agent Controller. Die
Installation und Konfiguration ist ausführlich in den Artikeln zum
[Linux-Agenten](agent_linux.html#install) und
[Windows-Agenten](agent_windows.html#install) beschrieben.
:::

::: paragraph
Im Kasten [Agents]{.guihint} finden Sie die Agentenskripte für die
verschiedenen Betriebssysteme. Für Betriebssysteme, auf denen der Agent
im Legacy-Modus (d.h. ohne Agent Controller) eingerichtet werden muss,
gibt es die Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) und [FreeBSD
überwachen](agent_freebsd.html).
:::
::::::::::
:::::::::::

::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}4. Die Agentenbäckerei {#heading_bakery}

:::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_einleitung_2 .hidden-anchor .sr-only}4.1. Einleitung {#heading__einleitung_2}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie eine der
kommerziellen Editionen verwenden, dann können Sie mit der
Agentenbäckerei (*Agent Bakery*) Agenten individuell paketieren. So
können Sie Agentenpakete erzeugen (oder eben „backen"), die neben dem
eigentlichen Agenten auch eine individuelle Konfiguration und
zusätzliche Plugins enthalten. Diese Pakete können Sie mit einem
einzigen Befehl installieren. Sie eignen sich daher ideal für eine
automatische Verteilung und Installation. Und Sie können sogar für
Ordner oder bestimmte Gruppen von Hosts individuelle Agenten erzeugen.
Das schafft vor allem in Verbindung mit dem [automatischen
Agenten-Update](agent_deployment.html) große Flexibilität.
:::

::: paragraph
Zwar funktioniert der Checkmk-Agent auch erst mal „nackt", also ohne
Konfiguration und Plugins, aber in einigen Fällen muss der Agent eben
doch angepasst werden. Beispiele:
:::

::: ulist
- Beschränkung des Zugriffs auf bestimmte IP-Adressen

- Überwachung von Oracle-Datenbanken (Plugin und Konfiguration nötig)

- Überwachung von Text-Logdateien (Plugin, Dateinamen und Textmuster
  nötig)

- Verwendung der [Hardware-/Software-Inventur](inventory.html) (Plugin
  nötig)
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Bei jedem Backvorgang kann eine   |
|                                   | fortlaufende Bake                 |
|                                   | Revision --- für die              |
|                                   | Unterscheidbarkeit verschiedener  |
|                                   | Backvorgänge --- erzeugt werden.  |
|                                   | Diese ist nur in den Metadaten    |
|                                   | des gebackenen Pakets sichtbar.   |
|                                   | Die Funktion ist ab Checkmk       |
|                                   | [2.3.0]{.new} standardmäßig       |
|                                   | deaktiviert, um zu verhindern,    |
|                                   | dass gebackene Agenten            |
|                                   | möglicherweise ihre gültige       |
|                                   | Signatur verlieren. Wenn Sie die  |
|                                   | Bake Revision dennoch aktivieren  |
|                                   | möchten, zum Beispiel für die     |
|                                   | eindeutige Verarbeitung in einem  |
|                                   | Paketmanager, schalten Sie die    |
|                                   | Option [Setup \> Global settings  |
|                                   | \> Setup \> Apply bake            |
|                                   | revision]{.guihint} ein. Und      |
|                                   | sofern eingeschaltet: Bei später  |
|                                   | über die Regel [Automatically     |
|                                   | create monitoring                 |
|                                   | agents]{.guihint} automatisch     |
|                                   | gebackenen Agenten bleibt die     |
|                                   | vorige Revision in jedem Fall     |
|                                   | bestehen und wird nicht weiter    |
|                                   | erhöht --- abermals, um die       |
|                                   | Signatur nicht zu verlieren. Wenn |
|                                   | Sie automatisch gebackene Agenten |
|                                   | *mit* fortlaufenden Revisionen    |
|                                   | benötigen, sollten Sie zum        |
|                                   | Beispiel die                      |
|                                   | [REST-API](rest_api.html) statt   |
|                                   | der Regel einsetzen.              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::

:::::::::: sect2
### []{#bakery_download .hidden-anchor .sr-only}4.2. Agent herunterladen {#heading_bakery_download}

::: paragraph
Sie erreichen die Agentenbäckerei über [Setup \> Agents \> Windows,
Linux, Solaris, AIX]{.guihint}:
:::

:::: imageblock
::: content
![Einstiegsseite zur
Agentenbäckerei.](../images/monitoringagents_agent_bakery_main.png)
:::
::::

::: paragraph
Checkmk unterstützt mit der Agentenbäckerei die Betriebssysteme Windows,
Linux, Solaris und AIX. Bei Linux haben Sie dabei die Wahl zwischen den
Paketformaten RPM (für Red Hat Enterprise Linux (RHEL) basierte Systeme,
SLES) und DEB (für Debian, Ubuntu) sowie einem sogenannten „Tarball" im
TGZ-Dateiformat, der einfach als `root` unter `/` ausgepackt wird. Für
AIX steht ebenfalls ein Tarball bereit. Dieser enthält allerdings keine
automatische Integration in den `inetd`. Dies muss einmalig von Hand
gemacht werden. Für Solaris gibt es wiederum den Tarball sowie ein
PKG-Paket.
:::

::: paragraph
Wenn Sie noch keine Einstellungen für bestimmte Hosts vorgenommen haben,
gibt es nur eine einzige Standardagentenkonfiguration. Was es mit den
unterschiedlichen Agentenkonfigurationen auf sich hat, erfahren Sie in
den nächsten beiden Abschnitten.
:::

::: paragraph
Jede Agentenkonfiguration hat eine eindeutige ID: den [Hash]{.guihint}.
Die ersten 8 Zeichen des Hashs werden in der GUI angezeigt. Dieser Hash
wird Teil der Paketversion und auch in den Namen der Paketdatei
eingebaut. Wann immer Sie etwas an der Konfiguration eines Paketes
ändern oder Checkmk aktualisieren, ändert sich auch der Hash des Pakets.
Dadurch erkennt der Paketmanager des Betriebssystems, dass es sich um
ein anderes Paket handelt und führt einen Update durch. Die
Versionsnummer von Checkmk wäre hier zur Unterscheidung nicht
ausreichend.
:::

::: paragraph
Gebackene Pakete für Linux und Windows werden auf die gleiche Art
installiert wie die Pakete, die Sie von der [Download-Seite
herunterladen](#download_page) können.
:::
::::::::::

:::::::::: sect2
### []{#_konfiguration_über_regeln .hidden-anchor .sr-only}4.3. Konfiguration über Regeln {#heading__konfiguration_über_regeln}

::: paragraph
Die Konfiguration des Agenten ändern Sie, wie so oft in Checkmk, über
[Regeln.](glossar.html#rule) Diese bieten Ihnen die Möglichkeit,
verschiedene Hosts mit unterschiedlichen Einstellungen oder Plugins
auszustatten. Über den Knopf [Agent rules]{.guihint} gelangen Sie zu
einer Seite, die Ihnen alle Regelsätze zeigt, die die Agenten
beeinflussen:
:::

:::: imageblock
::: content
![Liste der Regeln für die
Agenten.](../images/monitoringagents_agent_rules.png)
:::
::::

::: paragraph
Nehmen wir folgendes Beispiel: Sie möchten die Liste der IP-Adressen
beschränken, welche auf den Agenten zugreifen dürfen. Dazu wählen Sie
den Regelsatz [Generic Options \> Allowed agent access via IP address
(Linux, Windows)]{.guihint}. Tragen Sie als Wert der Regel eine oder
mehrere IP-Adressen ein:
:::

:::: imageblock
::: content
![Regel zur Einschränkung der IP-Adressen zum Zugriff auf den
Agenten.](../images/monitoringagents_agent_rule_ipaccess.png)
:::
::::

::: paragraph
Lassen Sie die Standardwerte im Kasten [Conditions]{.guihint}
unverändert, damit diese Regel für alle Hosts gilt. Speichern Sie die
neue Regel.
:::
::::::::::

::::::::::::: sect2
### []{#agent_configurations .hidden-anchor .sr-only}4.4. Die Agentenkonfigurationen {#heading_agent_configurations}

::: paragraph
Gehen Sie nach dem Speichern zurück zur Seite [Windows, Linux, Solaris,
AIX.]{.guihint} Der Knopf [![Symbol zum Backen der
Agenten.](../images/icons/button_bake_agents.png)]{.image-inline} sorgt
für ein neues Backen der Agenten. Das Ergebnis: Sie haben nun zwei
Konfigurationen:
:::

:::: imageblock
::: content
![Liste mit zwei Konfigurationen der Agenten zum
Download.](../images/monitoringagents_agent_bakery_agentlist.png)
:::
::::

::: paragraph
In der Spalte [Agent type]{.guihint} können Sie ablesen, welchen Hosts
die jeweilige Konfiguration zugeordnet ist. Aus Platzgründen ist diese
Liste eventuell nicht vollständig.
:::

+-------------+--------------------------------------------------------+
| [Vanilla    | Die Agentenpakete enthalten nur die                    |
| (factory    | Standardkonfiguration und damit **keine** einzige      |
| settings)   | Agentenregel.                                          |
| ]{.guihint} |                                                        |
+-------------+--------------------------------------------------------+
| [Folders    | Die Agentenpakete enthalten **alle** Agentenregeln, in |
| ]{.guihint} | denen keine Bedingungen für Hosts definiert sind, und  |
|             | die für die genannten Ordner greifen.\                 |
|             | Agentenpakete werden spezifisch für einen Ordner       |
|             | erstellt, wenn in den Eigenschaften dieses Ordners     |
|             | ([Folder properties]{.guihint}) das Attribut [Bake     |
|             | agent packages]{.guihint} auf [Bake a generic agent    |
|             | package for this folder]{.guihint} gesetzt ist. Dieses |
|             | Attribut gilt nur für den Ordner und wird nicht        |
|             | vererbt.\                                              |
|             | Dieser Eintrag ist nützlich, um Agenten für Hosts zu   |
|             | erstellen, die noch nicht in Checkmk existieren. Der   |
|             | Ordner kann sogar leer sein, um dort später [Hosts     |
|             | automatisch erstellen zu                               |
|             | lassen.](hosts_autoregister.html) Standardmäßig werden |
|             | Agentenpakete nur für den Ordner [Main]{.guihint}      |
|             | (oder [root folder]{.guihint}) erstellt.               |
+-------------+--------------------------------------------------------+
| [Hosts      | Die Agentenpakete enthalten **alle** Agentenregeln,    |
| ]{.guihint} | die für die genannten Hosts greifen.                   |
+-------------+--------------------------------------------------------+

::: paragraph
Für das oben gezeigte Beispiel wurde die Regel [Allowed agent access via
IP address (Linux, Windows)]{.guihint} ohne Bedingungen für Hosts
erstellt. Die neue Agentenkonfiguration gilt daher für den Ordner
[Main]{.guihint} und für den einzigen in der Instanz existierenden Host
`localhost`.
:::

::: paragraph
Je mehr Host-spezifische Regeln Sie aufstellen, desto mehr
unterschiedliche Varianten von Agenten werden gebaut. Die
Agentenbäckerei achtet dabei darauf, dass nur solche Konfigurationen
gebaut werden, die auch von mindestens einem der vorhandenen Ordner oder
Hosts verwendet werden.
:::

::: paragraph
Sie erreichen die Agentenpakete für einen Host übrigens auch bequem über
die Eigenschaften des Hosts, indem Sie in [Setup \> Hosts \>
Hosts]{.guihint} den Host anklicken und im Menü [Hosts]{.guihint} den
Eintrag [Monitoring agent]{.guihint} auswählen:
:::

:::: imageblock
::: content
![Liste der Agenten für einen Host zum
Download.](../images/monitoringagents_download_host_agent.png)
:::
::::

::: paragraph
Warum werden für jeden Host die Pakete für alle Betriebssysteme
angeboten? Die Antwort ist sehr einfach: Solange kein Agent auf einem
System installiert ist, kann Checkmk das Betriebssystem natürlich nicht
erkennen. Sobald die [automatischen
Agenten-Updates](agent_deployment.html) aktiviert sind, brauchen Sie
sich darum ohnehin nicht mehr zu kümmern.
:::
:::::::::::::

:::::: sect2
### []{#_erweiterung_über_plugins .hidden-anchor .sr-only}4.5. Erweiterung über Plugins {#heading__erweiterung_über_plugins}

::: paragraph
Sehr viele Regeln befassen sich mit der Installation verschiedener
*Plugins.* Diese erweitern den Agenten um die Überwachung von ganz
bestimmten Komponenten. Meist sind dies spezielle Anwendungen wie z.B.
Datenbanken. Bei der Regel, die das Plugin aktiviert, finden Sie auch
gleich die Einstellungen für die Konfiguration des Plugins. Hier als
Beispiel die Regel für die Überwachung von MySQL:
:::

:::: imageblock
::: content
![Regel für das MySQL Plugin des
Agenten.](../images/monitoringagents_agent_rule_mysql.png)
:::
::::
::::::

:::: sect2
### []{#_konfigurationsdateien .hidden-anchor .sr-only}4.6. Konfigurationsdateien {#heading__konfigurationsdateien}

::: paragraph
Achten Sie darauf, dass Sie Konfigurationsdateien, die die
Agentenbäckerei erzeugt, auf dem Zielsystem **nicht von Hand anpassen.**
Zwar wird die manuelle Änderung erst mal funktionieren, aber beim
nächsten Update des Agenten sind die Änderungen wieder verloren. Das
Installieren von zusätzlichen Plugins und Konfigurationsdateien ist
dagegen problemlos möglich.
:::
::::

::::::: sect2
### []{#_logging_aktivieren .hidden-anchor .sr-only}4.7. Logging aktivieren {#heading__logging_aktivieren}

::: paragraph
In den globalen Einstellungen können Sie unter [Agent bakery
logging]{.guihint} das Logging für die Bakery-Prozesse aktivieren. Die
Resultate finden Sie in der Datei `~/var/log/agent_bakery.log`.
:::

:::: imageblock
::: content
![Option zum Aktivieren des
Bakery-Loggings.](../images/wato_monitoringagents_bakery_logging.png)
:::
::::

::: paragraph
Ohne aktiviertes Logging sehen Sie diese Informationen nur, wenn Sie
Agenten mit `cmk --bake-agents -v` [auf der Kommandozeile
backen.](cmk_commandline.html#bake_agents)
:::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::: sect1
## []{#agent_update .hidden-anchor .sr-only}5. Wann soll man den Agenten updaten? {#heading_agent_update}

:::::::::: sectionbody
::: paragraph
Egal, ob Sie nur eine Handvoll oder gleich tausende Hosts überwachen:
Eine Aktualisierung des Checkmk-Agenten auf allen Hosts ist immer ein
größerer Eingriff. Das [automatische
Agenten-Update](agent_deployment.html) der kommerziellen Editionen ist
zwar eine Erleichterung, doch trotzdem sollten Sie den Agenten immer nur
dann aktualisieren, wenn das Update:
:::

::: ulist
- einen Fehler behebt, von dem Sie betroffen sind, oder

- neue, benötigte Funktionen enthält.
:::

::: paragraph
Damit dies auch so möglich ist, gilt in Checkmk die generelle Regel:
Neuere Checkmk-Versionen können mit der Ausgabe von älteren Agenten
grundsätzlich umgehen.
:::

::: paragraph
**Wichtig:** Umgekehrt gilt das nicht unbedingt. Wenn die
Checkmk-Version eines Agenten neuer ist, als die des Monitoring-Servers,
kann es sein, dass die dort vorhandenen Check-Plugins Ausgaben des
Agenten nicht korrekt interpretieren können. In so einem Fall gehen die
betroffenen Services auf [UNKNOWN]{.state3}:
:::

:::: imageblock
::: content
![Liste von Services im Status UNKNOWN wegen eines fehlgeschlagenen
Checks.](../images/monitoringagents_crashed_check.png)
:::
::::

::: paragraph
Auch wenn die Ausgabe im obigen Bild etwas anderes nahelegt, senden Sie
bitte in so einem Fall *keinen* Crash-Report.
:::
::::::::::
:::::::::::

:::::::::::::::::::::::::: sect1
## []{#diagnostics .hidden-anchor .sr-only}6. Fehlerdiagnose {#heading_diagnostics}

::::::::::::::::::::::::: sectionbody
:::::::::::::::::: sect2
### []{#_agent_über_die_kommandozeile_testen .hidden-anchor .sr-only}6.1. Agent über die Kommandozeile testen {#heading__agent_über_die_kommandozeile_testen}

::: paragraph
Sie können einen korrekt installierten Agenten sehr einfach von der
Kommandozeile aus abfragen. Am besten machen Sie das direkt von der
Checkmk-Instanz aus, welche den Agenten auch produktiv überwachen soll.
So können Sie sicherstellen, dass die IP-Adresse des Servers vom Agenten
akzeptiert wird. Als Befehle eignen sich z.B. `telnet` und `netcat`
(oder `nc`).
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo | nc 10.1.1.2 6556
16
```
:::
::::

::: paragraph
Die Ausgabe `16` zeigt an, dass die Verbindungsaufnahme über den
TCP-Port 6556 erfolgreich war und nun der TLS-Handshake stattfinden
kann. Der Agent wurde per Agent Controller bei der Checkmk-Instanz
registriert, so dass die Kommunikation TLS verschlüsselt stattfindet und
keine Agentenausgabe angezeigt wird. Einzelheiten zur Registrierung
finden Sie im Artikel zum [Linux-Agenten](agent_linux.html#registration)
und [Windows-Agenten](agent_windows.html#registration).
:::

::: paragraph
Falls die Kommunikation zwischen Agent und Checkmk-Server *noch*
unverschlüsselt ist (wie im Legacy-Pull-Modus) oder unverschlüsselt ist
und auch bleibt (wie im Legacy-Modus), erhalten Sie mit diesem Kommando
statt der `16` die komplette unverschlüsselte Agentenausgabe (von der im
folgenden nur die ersten Zeilen gezeigt werden):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo | nc 10.1.1.2 6556
<<<check_mk>>>
Version: 2.1.0p1
AgentOS: linux
Hostname: mycmkserver
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
```
:::
::::

::: paragraph
Die Ausgabe beginnt immer mit der Zeile `<<<check_mk>>>`. Zeilen, die in
`<<<` und `>>>` eingeschlossen sind, werden als *Sektions-Header*
bezeichnet. Sie teilen die Agentenausgaben in Sektionen. Jede Sektion
enthält zusammengehörige Informationen und ist meist einfach die Ausgabe
eines Diagnosebefehls. Die Sektion `check_mk` spielt eine Sonderrolle.
Sie enthält allgemeine Informationen über den Agenten selbst, wie z.B.
dessen Versionsnummer.
:::

::: paragraph
Wenn der Host bereits in das Monitoring aufgenommen ist, können Sie die
Daten auch mit dem [Befehl](cmk_commandline.html#dump_agent) `cmk -d`
abrufen. Dieser verwendet dann die im [Setup]{.guihint} konfigurierte
IP-Adresse, berücksichtigt eine eventuell umkonfigurierte Port-Nummer
und auch den Fall eines Spezialagenten. Mit den Optionen `--debug -v`
können Sie sich zusätzlich noch einige Debugging-Informationen ausgeben
lassen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d mycmkserver
<<<check_mk>>>
Version: 2.1.0p1
```
:::
::::

::: paragraph
Wenn das Monitoring für den besagten Host bereits regelmäßig läuft,
finden Sie immer eine aktuelle Kopie der Ausgabe im Instanzverzeichnis
`~/tmp/check_mk/cache`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cat tmp/check_mk/cache/mycmkserver
<<<check_mk>>>
Version: 2.1.0p1
```
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Weitere Diagnosekommandos zur     |
|                                   | Ausführung auf dem Host des       |
|                                   | Agenten finden Sie im Artikel zum |
|                                   | [Linu                             |
|                                   | x-Agenten](agent_linux.html#test) |
|                                   | und                               |
|                                   | [Windows-A                        |
|                                   | genten.](agent_windows.html#test) |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::::::::

:::::::: sect2
### []{#diagnosticpage .hidden-anchor .sr-only}6.2. Agent über die Weboberfläche testen {#heading_diagnosticpage}

::: paragraph
Auch über die Weboberfläche können Sie eine Diagnose des Agenten
durchführen. Diese berücksichtigt sämtliche Einstellungen, unterstützt
auch SNMP-basierte Geräte und solche, die über einen Spezialagenten
abgefragt werden. Das Praktische: Checkmk probiert hier einfach immer
gleichzeitig die Abfrage über TCP-Port 6556 **und** SNMP.
:::

::: paragraph
Sie erreichen den Verbindungstest über die Eigenschaften des Hosts:
Wählen Sie auf der Seite [Properties of host]{.guihint} im Menü [Host \>
Connection tests]{.guihint} und starten Sie den Test durch Klick auf
[Run tests]{.guihint}:
:::

:::: imageblock
::: content
![Ergebnis des Verbindungstests zu einem
Host.](../images/monitoringagents_host_diag.png)
:::
::::

::: paragraph
Etliche der Einstellungen (z.B. die SNMP-Community) können Sie hier
sofort ausprobieren und bei Erfolg speichern.
:::
::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
