:::: {#header}
# Windows überwachen

::: details
[Last modified on 15-Jul-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/agent_windows.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Automatische
Agenten-Updates](agent_deployment.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Der Windows-Agent {#heading_intro}

::::::::::: sectionbody
::: paragraph
Die Überwachung von Windows-Servern war von Anfang an eine der
wichtigsten Aufgaben von Checkmk. Wie für alle anderen
Server-Betriebssysteme liefert Checkmk daher auch für Windows einen
eigenen Agenten aus. Dieser ist ein Agentenprogramm, das minimalistisch
und sicher ist.
:::

::: paragraph
In der Checkmk-Version [2.1.0]{.new} wurde diesem **Agentenprogramm**
mit dem **Agent Controller** eine neue Komponente zur Seite gestellt.
Der Agent Controller ist dem Agentenprogramm vorgeschaltet, fragt dieses
ab und kommuniziert an dessen Stelle mit dem Checkmk-Server. Dazu
registriert er sich am **Agent Receiver**, einem Prozess, der auf dem
Checkmk-Server läuft.
:::

::: paragraph
Der Windows-Agent übernimmt also zum einen das Agentenprogramm, und
damit dessen Vorteile. Zum anderen ergänzt er das Programm so, dass neue
Funktionen hinzugefügt werden können wie die TLS-Verschlüsselung der
Kommunikation oder die Datenkomprimierung.
:::

::: paragraph
Der registrierte, verschlüsselte und komprimierte
[Pull-Modus](glossar.html#pull_mode) mit dem Agent Controller ist für
alle Checkmk-Editionen verfügbar -- sofern sowohl Checkmk-Server als
auch Agent mindestens Version [2.1.0]{.new} haben. Den
[Push-Modus](glossar.html#push_mode) gibt es ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud**, d. h. in Checkmk Cloud und Checkmk MSP. Die Umkehrung
der Kommunikationsrichtung erleichtert die Überwachung von Hosts, die
sich hinter Firewalls befinden. Kombiniert wird der Push-Modus meist mit
der [automatischen Registrierung](hosts_autoregister.html) des
Checkmk-Agenten, die ebenfalls ab Checkmk Cloud verfügbar ist.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Standard-Agentenpakete öffnen     |
|                                   | sofort nach der Installation Port |
|                                   | 6556. Sie geben darüber die       |
|                                   | unverschlüsselte Agentenausgabe   |
|                                   | an jeden, der sie anfordert aus.  |
|                                   | Bei Hosts, die aus dem Internet   |
|                                   | erreichbar sind, sollten Sie      |
|                                   | daher *vor* der Installation per  |
|                                   | Firewall sicherstellen, dass der  |
|                                   | Zugriff auf diesen Port nur       |
|                                   | ausgewählten Hosts erlaubt ist.   |
|                                   | Führen Sie die Registrierung und  |
|                                   | die damit verbundene Aktivierung  |
|                                   | der TLS-Verschlüsselung zeitnah   |
|                                   | nach der Installation durch.      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Aus Kompatibilitätsgründen unterstützt der Agent nur die aktuellen
Versionen der [Microsoft Windows
NT](https://de.wikipedia.org/wiki/Microsoft_Windows_NT){target="_blank"}
Produktlinie (Edition). Welche das genau sind, steht im Artikel [Release
notes.](release_notes.html#windows)
:::

::: {#legacyagent .paragraph}
**Wichtig**: Andere Windows-Editionen werden nicht offiziell
unterstützt. Dazu gehört zum Beispiel auch *Windows Embedded*. Für die
Überwachung älterer Windows-Editionen, wie z.B. Windows Server 2008,
können Sie auf eigenes Risiko einen **Legacy-Agenten** verwenden. Ein
Legacy-Agent ist ein Agent einer älteren Checkmk-Version ohne Agent
Controller, der dann auch nicht die an den Agent Controller gekoppelten
Features bietet wie TLS-Verschlüsselung und Datenkomprimierung.
Legacy-Agenten stellen wir [hier zum
Download](https://download.checkmk.com/legacy-agents/){target="_blank"}
zur Verfügung. Für einen Legacy-Agenten sind einige Besonderheiten zu
beachten, die im [Installationskapitel](#post_install) zusammengefasst
sind.
:::

::: paragraph
Die Installation, Registrierung und Einrichtung des Agenten ist mit
wenigen Schritten erledigt, denn dieser braucht für seine Funktion zum
Beispiel keine zusätzlichen Bibliotheken. Zudem wird der Agent mit einer
Grundkonfiguration ausgeliefert, die für die meisten Anwendungsfälle
ausreicht.
:::
:::::::::::
::::::::::::

:::::::: sect1
## []{#agent_architecture .hidden-anchor .sr-only}2. Architektur des Agenten {#heading_agent_architecture}

::::::: sectionbody
::: paragraph
Der Checkmk-Agent besteht aus dem Agentenprogramm und dem Agent
Controller, der mit dem Agent Receiver auf dem Checkmk-Server
kommuniziert. Im allgemeinen Artikel über die
[Monitoring-Agenten](wato_monitoringagents.html#agents) finden Sie
Einzelheiten zur gemeinsamen Architektur von
[Linux-Agent](agent_linux.html) und Windows-Agent. In diesem Kapitel
geht es um die für Windows spezifische Implementierung.
:::

::: paragraph
Das **Agentenprogramm** `check_mk_agent.exe` ist zuständig für die
Sammlung der Monitoring-Daten. Es wird als Windows-Dienst unter dem
LocalSystem-Konto gestartet. Es sammelt bei einem Aufruf Daten zu dem
lokalen System und stellt sie dem Agent Controller zur Verfügung.
:::

::: paragraph
Das Agentenprogramm ist minimalistisch, sicher, leicht erweiterbar und
umfassend, denn es hat Zugriff auf wichtige Daten, die per WMI oder SNMP
nicht erreichbar sind. In einigen Fällen kann allerdings die Überwachung
per SNMP **zusätzlich** zum Checkmk-Agenten sinnvoll sein. Im Artikel
zur [Überwachung mit SNMP](snmp.html#snmp_cmk_agent) finden Sie mehr zu
diesem Thema. Außerdem ist das Agentenprogramm so transparent, wie es
eine als ausführbar gelieferte Datei sein kann, denn Sie haben jederzeit
Zugriff auf den Quellcode und damit Einsicht in die Funktionalität und
können den Agenten prinzipiell auch selbst kompilieren.
:::

::: paragraph
Der **Agent Controller** `cmk-agent-ctl.exe` kümmert sich um den
Transport der vom Agentenprogramm gesammelten Daten. Er wird als
Hintergrundprozess unter dem LocalSystem-Konto von Windows ausgeführt.
Im Pull-Modus lauscht er am TCP-Port 6556 auf eingehende Verbindungen
der Checkmk-[Instanz](glossar.html#site) und fragt das Agentenprogramm
über *Mailslot* ab.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#install .hidden-anchor .sr-only}3. Installation {#heading_install}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk bietet Ihnen für die Installation des Windows-Agenten
verschiedene Wege --- von der manuellen Installation des Software-Pakets
bis hin zur vollautomatischen Verteilung inklusive Update-Funktion.
Manche davon stehen nur in den kommerziellen Editionen zur Verfügung:
:::

+--------------------+-----------------------------------+------+------+
| Methode            | Beschreibung                      | Che  | Komm |
|                    |                                   | ckmk | erzi |
|                    |                                   | Raw  | elle |
|                    |                                   |      | E    |
|                    |                                   |      | diti |
|                    |                                   |      | onen |
+====================+===================================+======+======+
| Mitgeliefertes     | Einfache Installation eines       | X    | X    |
| MSI-Paket          | Standard-Agenten mit manueller    |      |      |
|                    | Konfiguration über                |      |      |
|                    | Konfigurationsdateien.            |      |      |
+--------------------+-----------------------------------+------+------+
| MSI-Paket aus der  | Konfiguration über die GUI,       |      | X    |
| [Agenten           | individuelle Konfiguration pro    |      |      |
| bäckerei](glossar. | Host möglich.                     |      |      |
| html#agent_bakery) |                                   |      |      |
+--------------------+-----------------------------------+------+------+
| [Automatisches     | Das Paket aus der Agentenbäckerei |      | X    |
| Update](agen       | wird erstmalig von Hand oder per  |      |      |
| t_deployment.html) | Skript installiert und von da an  |      |      |
|                    | automatisch aktualisiert.         |      |      |
+--------------------+-----------------------------------+------+------+

::: paragraph
Alternativ können Sie das MSI-Paket auch über andere Wege, wie zum
Beispiel das Microsoft Active Directory, verteilen. Die Installation
kann hier durch das MSI-Format komplett automatisiert werden.
:::

::::::::::::::::::: sect2
### []{#download .hidden-anchor .sr-only}3.1. Download des MSI-Pakets {#heading_download}

::: paragraph
Sie installieren den Windows-Agenten durch Installation des MSI-Pakets.
:::

::: paragraph
Vor der Installation müssen Sie das Paket holen und auf den Host bringen
(zum Beispiel mit `scp` oder WinSCP), auf dem der Agent laufen soll.
:::

:::::::: sect3
#### []{#download_gui .hidden-anchor .sr-only}Paket per Checkmk-GUI holen {#heading_download_gui}

::: paragraph
In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** finden Sie das Windows-Paket des Agenten über [Setup \>
Agents \> Windows]{.guihint}. In den kommerziellen Editionen gelangen
Sie im [Setup]{.guihint}-Menü über [Agents \> Windows, Linux, Solaris,
AIX]{.guihint} zunächst in die
[Agentenbäckerei](wato_monitoringagents.html#bakery), wo Sie die
gebackenen Pakete finden. Von dort aus kommen Sie mit dem Menüeintrag
[Related \> Windows files]{.guihint} zur Liste der Agentendateien:
:::

::::: imageblock
::: content
![Download-Seite mit dem
MSI-Paket.](../images/agent_windows_agent_files.png)
:::

::: title
Auf der Download-Seite finden Sie das MSI-Paket
:::
:::::

::: paragraph
Alles, was Sie brauchen, finden Sie gleich im ersten Kasten mit dem
Namen [Packaged Agents]{.guihint}: die fertige MSI-Paketdatei
`check_mk_agent.msi` für die Installation des Windows-Agenten mit
Standardeinstellungen.
:::
::::::::

:::::::::: sect3
#### []{#_paket_per_rest_api_holen .hidden-anchor .sr-only}Paket per REST-API holen {#heading__paket_per_rest_api_holen}

::: paragraph
Die [REST-API](rest_api.html) von Checkmk bietet die folgenden
Möglichkeiten Agentenpakete vom Checkmk-Server herunterzuladen:
:::

::: ulist
- Herunterladen des mitgelieferten Agenten.

- Herunterladen eines gebackenen Agenten nach Host-Name und
  Betriebssystem.

- Herunterladen eines gebackenen Agenten nach Hash des Agenten und
  Betriebssystems.
:::

::: paragraph
Per REST-API haben Sie die Möglichkeit, das Paket vom Checkmk-Server
direkt auf den Zielrechner zu holen. Das mitgelieferte MSI-Paket des
Windows-Agenten lässt sich beispielsweise mit dem folgenden
`curl`-Kommando holen. In neueren Windows-Versionen wird `curl` bereits
mitgeliefert, in älteren müssen Sie sich vorher die
`curl`-Kommandoumgebung per [curl for
Windows](https://curl.se/windows/){target="_blank"} extra installieren.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> curl -OJG "http://mycmkserver/mysite/check_mk/api/1.0/domain-types/agent/actions/download/invoke" ^
--header "Accept: application/octet-stream" ^
--header "Authorization: Bearer automation myautomationsecret" ^
--data-urlencode "os_type=windows_msi"
```
:::
::::

::: paragraph
**Hinweis:** Der Befehl wurde zugunsten der Lesbarkeit in vier Zeilen
aufgeteilt.
:::

::: paragraph
Hierbei handelt es sich nur um ein einfaches Beispiel, um die
Funktionsweise dieses einen REST-API-Endpunkts zum Herunterladen des
Agenten zu demonstrieren. Details zu diesem und anderen
REST-API-Endpunkten finden Sie in der API-Dokumentation, die Sie in
Checkmk über [Help \> Developer resources \> REST API
documentation]{.guihint} aufrufen können.
:::
::::::::::
:::::::::::::::::::

::::::::::::::::::::::::::::::: sect2
### []{#install_package .hidden-anchor .sr-only}3.2. Paket installieren {#heading_install_package}

:::::::::::::::::: sect3
#### []{#install_manual .hidden-anchor .sr-only}Manuelle Installation {#heading_install_manual}

::: paragraph
Nachdem Sie das MSI-Paket geholt und --- falls nötig --- mit `scp`,
WinSCP oder anderen Mitteln auf den zu überwachenden Host kopiert haben,
starten Sie die Installation entweder per Doppelklick auf die MSI-Datei
oder wie folgt von der Kommandozeile:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> check_mk_agent.msi
```
:::
::::

::: paragraph
Sie erhalten die Startseite des Setup-Assistenten:
:::

::::: imageblock
::: content
![Startseite des
Setup-Assistenten.](../images/agent_windows_setup_wizard_1.png)
:::

::: title
Die Installation startet mit einem Willkommen
:::
:::::

::: paragraph
Mit den [Next]{.guihint}-Knöpfen hangeln Sie sich durch die Seiten des
Assistenten. Akzeptieren Sie die Lizenzbedingungen der [GNU GENERAL
PUBLIC LICENSE]{.guihint}, um fortzufahren. Anschließend präsentiert
Ihnen der Setup-Assistent die folgende Seite:
:::

::::: {#agent_windows_setup_wizard_3b .imageblock}
::: content
![Seite des Setup-Assistenten zum Vorgehen beim Update eines alten
Agenten.](../images/agent_windows_setup_wizard_3b.png)
:::

::: title
Auswahlmöglichkeiten bei der Installation des Agenten
:::
:::::

::: paragraph
Die Auswahlmöglichkeiten dieser Seite sind für Sie nur dann relevant,
wenn bereits ein Windows-Agent auf dem Host installiert ist und dieser
**älter** als Version [1.6.0]{.new} ist. In der Version [1.6.0]{.new}
hatte sich die Architektur des Windows-Agenten grundlegend geändert.
Falls Sie von einem Windows-Agenten **vor** Version [1.6.0]{.new} auf
den aktuellen Agenten updaten (oder *migrieren*), dann lesen Sie zuerst
im Checkmk-Handbuch der Version [2.0.0]{.new} das [Kapitel zum alten
Agenten.](https://docs.checkmk.com/2.0.0/de/agent_windows.html#legacy)
Dort erfahren Sie, welche der angebotenen Optionen Sie in diesem
speziellen Update-Fall auswählen sollten.
:::

::: paragraph
In allen anderen Fällen empfehlen wir die Auswahl von [Clean
installation.]{.guihint}
:::

::: paragraph
Bestätigen Sie den Start der Installation und erlauben Sie dann noch im
Dialog zur Benutzerkontensteuerung ([User Account Control]{.guihint}),
dass das Installationsprogramm Änderungen durchführen darf. Nach dem
Abschluss können Sie den Setup-Assistenten beenden.
:::

::: paragraph
Nach der Installation wird der Agent sofort als Windows-Dienst gestartet
und ist für die Überwachung des Systems bereit.
:::
::::::::::::::::::

:::::::::::::: sect3
#### []{#install_unattended .hidden-anchor .sr-only}Unbeaufsichtigte Installation {#heading_install_unattended}

::: paragraph
Windows bietet über die Kommandozeile für Administratoren mit `msiexec`
die Möglichkeit, MSI-Pakete automatisiert, ohne Benutzerinteraktion zu
installieren. Eine automatisierte Installation kann dann zum Beispiel
folgendermaßen aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> msiexec /i check_mk_agent.msi /qn
```
:::
::::

::: paragraph
In diesem Fall wird der Agent ohne Benutzerinteraktion und
Benutzeroberfläche (`/qn`) installiert (`/i`) und ebenfalls sofort als
Windows-Dienst gestartet. Diese Methode eignet sich also hervorragend
zum automatischen Verteilen des Agenten auf viele Hosts.
:::

::: paragraph
Sie können auf diesem Wege auch die drei Optionen auswählen, die Ihnen
während der manuellen Installation [im
Setup-Assistenten](#agent_windows_setup_wizard_3b) angeboten wurden. Für
jede Option gibt es einen Bezeichner, den Sie für das
Installationskommando verwenden können:
:::

+---------------------------------------------+------------------------+
| Option im Setup-Assistenten                 | Bezeichner             |
+=============================================+========================+
| [Clean installation.]{.guihint}             | `WIXUI_CLEANINSTALL`   |
+---------------------------------------------+------------------------+
| [Remove Legacy Windows Agent (pre 1.6) if   | `WIXUI_REMOVELEGACY`   |
| present.]{.guihint}                         |                        |
+---------------------------------------------+------------------------+
| [Migrate from Legacy Windows Agent (pre     | `WIXUI_MIGRATELEGACY`  |
| 1.6) configuration if present.]{.guihint}   |                        |
+---------------------------------------------+------------------------+

::: paragraph
Um eine Option zu *aktivieren*, hängen Sie deren Bezeichner gefolgt von
einem Gleichheitszeichen an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> msiexec /i check_mk_agent.msi /qn WIXUI_CLEANINSTALL=
```
:::
::::

::: paragraph
Um eine Option explizit zu *deaktivieren*, müssen Sie hinter dem
Gleichheitszeichen noch zwei Anführungszeichen anfügen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> msiexec /i check_mk_agent.msi /qn WIXUI_MIGRATELEGACY=""
```
:::
::::
::::::::::::::
:::::::::::::::::::::::::::::::

::::: sect2
### []{#_installation_mit_der_agentenbäckerei .hidden-anchor .sr-only}3.3. Installation mit der Agentenbäckerei {#heading__installation_mit_der_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen verfügen mit der [Agentenbäckerei](glossar.html#agent_bakery)
über ein Software-Modul zum automatischen Paketieren von individuell
angepassten Agenten. Eine ausführliche Beschreibung dazu finden Sie im
allgemeinen Artikel über die [Agenten](wato_monitoringagents.html). Die
Installation des gebackenen MSI-Pakets geschieht genauso wie es für die
mitgelieferten Pakete [oben](#install_package) beschrieben ist.
:::

::: paragraph
Ab Checkmk Cloud können Sie die Agentenbäckerei zusätzlich nutzen, um
Agentenpakete mit einer Konfiguration für die Autoregistrierung zu
versehen, was die [automatische Erstellung von
Hosts](hosts_autoregister.html) ermöglicht. In diesem Fall erfolgt die
Registrierung des Agenten automatisch nach der Installation des
Agentenpakets und eine manuelle Registrierung, wie im folgenden
[Kapitel](#registration) beschrieben, ist *nicht* mehr notwendig.
:::
:::::

:::: sect2
### []{#_automatisches_update .hidden-anchor .sr-only}3.4. Automatisches Update {#heading__automatisches_update}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie die
Agentenbäckerei verwenden, können Sie automatische Updates des Agenten
einrichten. Diese werden in einem [eigenen
Artikel](agent_deployment.html) beschrieben.
:::
::::

::::::::: sect2
### []{#config_files .hidden-anchor .sr-only}3.5. Konfigurationsdateien des Agenten {#heading_config_files}

::: paragraph
Das MSI-Paket speichert bei der Installation die programmspezifischen
Dateien in `C:\Program Files (x86)\checkmk\service\` und die
Host-spezifischen Dateien in `C:\ProgramData\checkmk\agent\`. Die
programmspezifischen Dateien brauchen Sie nicht anzupassen. Mit den
Host-spezifischen Dateien werden Plugins, Log- und Konfigurationsdateien
abgelegt und das Verhalten des Agenten konfiguriert.
:::

::: paragraph
**Hinweis**: Standardmäßig ist das gesamte Verzeichnis `C:\ProgramData`
in Windows versteckt (*hidden*).
:::

::: paragraph
Der Agent liest nacheinander drei Konfigurationsdateien ein:
:::

::: {.olist .arabic}
1.  `C:\Program Files (x86)\checkmk\service\check_mk.yml`\
    ist die Standardkonfigurationsdatei, die Sie nicht ändern sollten.

2.  `C:\ProgramData\checkmk\agent\bakery\check_mk.bakery.yml`\
    wird von der Agentenbäckerei erstellt und sollte nicht manuell
    geändert werden.

3.  `C:\ProgramData\checkmk\agent\check_mk.user.yml`\
    ist Ihre Konfigurationsdatei, in der Sie von Hand individuelle
    Anpassungen vornehmen können, um eine Einstellung oder eine
    Erweiterung auf einem Host zu testen.
:::

::: paragraph
Wird eine Option in mehreren Dateien gesetzt, dann bestimmt die zuletzt
eingelesene Datei den Wert dieser Option. Für das manuelle Arbeiten mit
dem Agenten ist also lediglich die letzte Konfigurationsdatei
`check_mk.user.yaml` relevant, weil sie als letzte eingelesen wird und
damit *das letzte Wort hat*. Wenn die Agentenbäckerei nicht genutzt
wird, ist sie sogar die einzige Datei, in der Anpassungen an der
Konfiguration des Agenten vorgenommen werden dürfen.
:::

::: paragraph
Wie Sie vielleicht schon an der Dateiendung der Konfigurationsdateien
erkannt haben, wird als Dateiformat
[YAML](https://yaml.org){target="_blank"} verwendet.
:::
:::::::::

:::::::::::: sect2
### []{#post_install .hidden-anchor .sr-only}3.6. Wie geht es weiter nach der Installation? {#heading_post_install}

::: paragraph
Nach der Installation des Agenten mit Agent Controller ist der nächste
Schritt die [Registrierung](#registration), mit der die
TLS-Verschlüsselung eingerichtet wird, so dass die verschlüsselte
Agentenausgabe vom Checkmk-Server entschlüsselt und im Monitoring
angezeigt werden kann.
:::

::: paragraph
Eine Besonderheit gibt es, falls der Agent mit Agent Controller
erstmalig installiert wurde. Dann schaltet der Agent in den
unverschlüsselten **Legacy-Pull-Modus**, damit der Checkmk-Server nicht
von den Monitoring-Daten abgeschnitten wird und diese weiterhin anzeigen
kann. Das betrifft sowohl eine Neuinstallation als auch das Update eines
Agenten der Version [2.0.0]{.new} und älter.
:::

::: paragraph
Im Monitoring sieht das dann etwa so aus:
:::

::::: imageblock
::: content
![Der WARN-Zustand des \'Check_MK\' Services wegen fehlender
Verschlüsselung.](../images/agent_windows_service_legacy_pull_mode.png)
:::

::: title
Warnung im Checkmk-Monitoring, dass TLS noch nicht genutzt wird
:::
:::::

::: paragraph
Die Checkmk-Instanz erkennt an der Agentenausgabe, dass der Agent
Controller vorhanden und damit die TLS-Verschlüsselung möglich
ist --- aber noch nicht eingeschaltet ist. Der Service [Check_MK
Agent]{.guihint} wechselt in den Zustand [WARN]{.state1} und bleibt es
so lange, bis Sie die Registrierung durchgeführt haben. Nach der
Registrierung wird nur noch im verschlüsselten Pull-Modus kommuniziert.
Der Legacy-Pull-Modus wird abgeschaltet und bleibt es auch. Allerdings
kann er im Bedarfsfall [per Kommando](#deregister) wieder eingeschaltet
werden.
:::

::: paragraph
Anders liegt der Fall bei Nutzung eines **Legacy-Agenten** auf einem
sehr alten [Windows-System](#legacyagent). Ohne Agent Controller ist
keine Registrierung möglich. Für einen Legacy-Agenten sind im Kapitel
[Registrierung](#registration) daher nur die Abschnitte relevant, um den
Host ins Setup und anschließend ins Monitoring aufzunehmen. Im Kapitel
[Test und Fehlerdiagnose](#test) können Sie sich den Test zum Aufruf des
Agent Controllers sparen, da dieser bei einem Legacy-Agenten nicht
vorhanden ist. Da es ohne Agent Controller auch keine
TLS-Verschlüsselung gibt, müssen Sie bei Bedarf andere Wege der
Verschlüsselung wählen. Wir empfehlen, in diesem Fall die eingebaute
(symmetrische) Verschlüsselung zu nutzen, sie wird mit der Regel
[Symmetric encryption (Linux, Windows)]{.guihint} eingerichtet.
:::

::: paragraph
**Hinweis:** Im Regelsatz [Checkmk Agent installation
auditing]{.guihint} finden Sie verschiedene Einstellungen, um den
Zustand des Agenten zu prüfen und im Monitoring sichtbar zu machen.
Unter anderem können Sie hier festlegen, welchen Zustand der Service
[Check_MK Agent]{.guihint} bei einer noch nicht durchgeführten
TLS-Konfiguration haben soll.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#registration .hidden-anchor .sr-only}4. Registrierung {#heading_registration}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#overview .hidden-anchor .sr-only}4.1. Übersicht und Voraussetzungen {#heading_overview}

::: paragraph
Unmittelbar nach der Installation des Agenten (auch als Update eines
Agenten der Version [2.0.0]{.new} und älter) ist nur unverschlüsselte
Kommunikation im Legacy-Pull-Modus möglich. Eine ausschließlich
verschlüsselte Datenübertragung ist erst nach Aufbau eines
Vertrauensverhältnisses aktiv.
:::

::: paragraph
Eine Ausnahme hiervon sind die für die
[Autoregistrierung](hosts_autoregister.html) vorkonfigurierten und via
Agentenbäckerei heruntergeladene Pakete. Diese Pakete führen die
Registrierung automatisch nach der Installation durch.
:::

::: paragraph
In allen anderen Fällen führen Sie die manuelle Registrierung zeitnah
nach der Installation des Agenten durch. Wie Sie dies bewerkstelligen,
zeigt dieses Kapitel.
:::

::: paragraph
Die Registrierung und damit die Herstellung des gegenseitigen
Vertrauensverhältnisses erfolgt unter einem Checkmk-Benutzer mit Zugriff
auf die [REST-API.](rest_api.html) Dafür bietet sich der
[Automationsbenutzer](glossar.html#automation_user) `agent_registration`
an, der nur die Berechtigung zur Registrierung von Agenten besitzt und
bei jeder Checkmk-Installation automatisch angelegt wird. Das zugehörige
Automationspasswort (*automation secret*) können Sie mit [![Symbol zum
Auswürfeln eines
Passworts.](../images/icons/icon_random.png)]{.image-inline} auswürfeln.
Beim Auswürfeln wird ein neues Passwort generiert. Sie müssen den
Benutzer anschließend speichern, bevor Sie das neue Passwort nutzen
können.
:::

::: paragraph
**Hinweis:** Da es auf sehr alten [Windows-Systemen](#legacyagent)
keinen Agent Controller, und da mit keine Registrierung und
TLS-Verschlüsselung gibt, müssen Sie bei Bedarf andere Wege der
Verschlüsselung wählen. Wir empfehlen, in diesem Fall die eingebaute
(symmetrische) Verschlüsselung zu nutzen, sie wird mit der Regel
[Symmetric encryption (Linux, Windows)]{.guihint} eingerichtet.
:::
::::::::

::::: sect2
### []{#_host_ins_setup_aufnehmen .hidden-anchor .sr-only}4.2. Host ins Setup aufnehmen {#heading__host_ins_setup_aufnehmen}

::: paragraph
Erstellen Sie zunächst den neuen Host über [Setup \> Hosts \> Add
host]{.guihint}. Ein Host muss in der
[Konfigurationsumgebung](glossar.html#configuration_environment)
existieren, bevor er registriert werden kann.
:::

::: paragraph
Ab Checkmk Cloud finden Sie in den Eigenschaften des Hosts im Abschnitt
zu den [Monitoring-Agenten](hosts_setup.html#monitoring_agents) die
Option [Checkmk agent connection mode.]{.guihint} Hier können Sie
alternativ zum Pull-Modus, der in allen Editionen verfügbar ist, für den
Checkmk-Agenten den Push-Modus aktivieren.
:::
:::::

:::::::::::::::: sect2
### []{#_host_beim_server_registrieren .hidden-anchor .sr-only}4.3. Host beim Server registrieren {#heading__host_beim_server_registrieren}

::: paragraph
Die Registrierung erfolgt mit dem Agent Controller `cmk-agent-ctl`, der
für die Konfiguration der Verbindungen eine Kommandoschnittstelle
bietet. Sie können sich mit `cmk-agent-ctl help` die Kommandohilfe
anzeigen lassen, auch spezifisch für die verfügbaren Subkommandos, z.B.
mit `cmk-agent-ctl help register`.
:::

::: paragraph
Ob der Host dabei für den Pull-Modus oder den Push-Modus konfiguriert
ist, macht für die Befehlsbeispiele keinen Unterschied. In welchem Modus
der Agent Controller arbeiten soll, teilt ihm der Agent Receiver bei der
Registrierung mit.
:::

::: paragraph
Begeben Sie sich nun zum Host, der registriert werden soll. Hier ist mit
Administratorrechten eine Anfrage an die
Checkmk-[Instanz](glossar.html#site) zu stellen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    register ^
    --hostname mynewhost ^
    --server cmkserver --site mysite ^
    --user agent_registration --password "PTEGDYXBFXVGNDPRL"
```
:::
::::

::: paragraph
Dabei ist der Host-Name hinter der Option `--hostname` exakt so
anzugeben, wie zuvor beim Erstellen im Setup. Die Optionen `--server`
und `--site` geben den Namen des Checkmk-Servers und der Instanz an. Der
Server-Name darf auch die IP-Adresse sein, der Instanzname (hier
`mysite`) entspricht demjenigen, den Sie im URL-Pfad der Weboberfläche
sehen. Komplettiert werden die Optionen durch Name und Passwort des
Automationsbenutzers. Wenn Sie die Option `--password` auslassen, wird
das Passwort interaktiv abgefragt.
:::

::: paragraph
**Vorsicht, Falle:** Falls Sie vorrangig Unix-Maschinen administrieren,
sind Sie es gewohnt, Pfade oder Parameter mit Leer- oder Sonderzeichen
in einfachen Anführungszeichen (*apostrophes*, `0x27`) zu umschließen.
Dieses Zeichen interpretiert Windows als Teil des Aufrufs -- hier des
Passworts --, und die Registrierung wird fehlschlagen. Verwenden Sie
stattdessen doppelte Anführungszeichen (*quotation marks*, `0x22`).
:::

::: paragraph
Waren die angegebenen Werte korrekt, werden Sie aufgefordert, die
Identität der Checkmk-Instanz zu bestätigen, zu der Sie die Verbindung
herstellen wollen. Das zu bestätigende Server-Zertifikat haben wir aus
Gründen der Übersichtlichkeit stark verkürzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Attempting to register at cmkserver:8000/mysite. Server certificate details:

PEM-encoded certificate:
---BEGIN CERTIFICATE---
MIIC6zCCAdOgAwIBAgIUXbSE8FXQfmFqoRNhG9NpHhlRJ40wDQYJKoZIhvcNAQEL
[...]
nS+9hN5ILfRI+wkdrQLC0vkHVYY8hGIEq+xTpG/Pxw==
---END CERTIFICATE---

Issued by:
   Site 'mysite' local CA
Issued to:
   localhost
Validity:
   From Thu, 10 Feb 2022 15:13:22 +0000
   To   Tue, 13 Jun 3020 15:13:22 +0000

Do you want to establish this connection? [Y/n]
> Y
```
:::
::::

::: paragraph
Bestätigen Sie mit `Y`, um den Vorgang abzuschließen.
:::

::: paragraph
Falls keine Fehlermeldung angezeigt wird, ist die verschlüsselte
Verbindung hergestellt. Über diese Verbindung werden alle Daten
komprimiert übertragen.
:::

::: paragraph
Wenn Sie die interaktive Zertifikatsprüfung -- beispielsweise, um die
Registrierung komplett automatisieren zu können -- abschalten wollen,
können Sie den zusätzlichen Parameter `--trust-cert` verwenden. Dem
übermittelten Zertifikat wird dann automatisch vertraut. Beachten Sie in
diesem Fall, dass Sie auf anderem Weg die Integrität des Zertifikats
sicher stellen sollten. Dies kann (von Hand oder per Skript) durch
Kontrolle der [Datei](#files)
`/var/lib/cmk-agent/registered_connections.json` erfolgen.
:::
::::::::::::::::

:::::::::: sect2
### []{#autoregister .hidden-anchor .sr-only}4.4. Host beim Server automatisch registrieren lassen {#heading_autoregister}

::: paragraph
Checkmk bietet ab Checkmk Cloud die Möglichkeit, Hosts automatisch bei
der Registrierung anzulegen. Für die
[Autoregistrierung](hosts_autoregister.html) benötigen Sie zusätzlich zu
einem Benutzer mit der Berechtigung Hosts zu registrieren, mindestens
einen Ordner, der für die Aufnahme der automatisch zu erstellenden Hosts
konfiguriert ist.
:::

::: paragraph
Ist dies der Fall, können Sie die Registrierung inklusive automatischer
Erstellung des Hosts auch per Kommandozeile vornehmen.
:::

::: paragraph
In der Regel werden Sie den Weg über die [Einstellungen der
Agentenbäckerei](hosts_autoregister.html#rule_autoregister_bakery)
gehen, welche die Konfigurationsdatei
`/var/lib/cmk-agent/pre_configured_connections.json` ins Agentenpaket
integrieren und die Registrierung automatisch bei der Installation
vornehmen. Der hier vorgestellte Kommandozeilenaufruf dient daher primär
dem Test und der Fehlersuche, beispielsweise dem Ausprobieren eigener
*Agenten-Labels* mit der Option `--agent-labels <KEY=VALUE>`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    register-new ^
    --server cmkserver --site mysite ^
    --agent-labels testhost:true ^
    --user agent_registration --password "PTEGDYXBFXVGNDPRL"
```
:::
::::

::: paragraph
Größter Unterschied hier ist das geänderte Subkommando `register-new` in
Zusammenspiel mit Angabe des Benutzers für die Autoregistrierung. Beide
zusammen fragen an der Checkmk-Instanz die Erstellung eines neuen Hosts
an. Als Name des Hosts wird der in der Umgebungsvariable
`%COMPUTERNAME%` hinterlegte verwendet. Die anschließende Bestätigung
des Zertifikats entspricht der im letzten Abschnitt gezeigten.
:::

::: paragraph
Ob der Host im Pull-Modus, im Push-Modus oder überhaupt nicht angelegt
wird, entscheiden Ihre Einstellungen des Regelsatzes [Agent
registration.]{.guihint} Nach erfolgreicher Registrierung können mehrere
Minuten vergehen, bis der Host im Monitoring auftaucht.
:::
::::::::::

:::::::: sect2
### []{#_vertrauensverhältnis_überprüfen .hidden-anchor .sr-only}4.5. Vertrauensverhältnis überprüfen {#heading__vertrauensverhältnis_überprüfen}

::: paragraph
Das Kommando `cmk-agent-ctl status` zeigt nun genau ein
Vertrauensverhältnis zum Checkmk-Server:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" status
Connection: 12.34.56.78:8000/mysite
   UUID: d38e7e53-9f0b-4f11-bbcf-d196deadbeef
   Local:
       Connection type: pull-agent
       Certificate issuer: Site 'mysite' local CA
       Certificate validity: Mon, 21 Feb 2022 11:23:57 +0000 - Sat, 24 Jun 3020 11:23:57 +0000
   Remote:
       Connection type: pull-agent
       Host name: mynewhost
```
:::
::::

::: paragraph
Ist die Information in einem maschinenlesbaren Format erforderlich,
hängen Sie den zusätzlichen Parameter `--json` an, um die Ausgabe als
JSON-Objekt formatiert zu erhalten.
:::

::: paragraph
**Hinweis:** Es kann stets nur ein Vertrauensverhältnis zwischen Host
und Instanz geben. Wenn Sie beispielsweise den bereits registrierten
Host `mynewhost` unter anderem Namen (`mynewhost2`), aber mit der
gleichen IP-Adresse registrieren, dann ersetzt die neue Verbindung die
bestehende. Die Verbindung von `mynewhost` zur Instanz wird gelöst und
für den Host werden keine Agentendaten mehr für das Monitoring
geliefert.
:::
::::::::

:::::::::: sect2
### []{#proxyregister .hidden-anchor .sr-only}4.6. Im Auftrag registrieren {#heading_proxyregister}

::: paragraph
Zur leichteren Registrierung mehrerer Hosts kann ein beliebiger Host,
auf dem der Agent installiert ist, eine Registrierung im Auftrag anderer
durchführen. Dabei wird eine JSON-Datei exportiert, die dann auf den
Ziel-Host übertragen und dort importiert werden kann. Auch hier gilt wie
zuvor: Der im Auftrag registrierte Host muss in der Instanz bereits
eingerichtet sein.
:::

::: paragraph
Zunächst wird auf einem beliebigen im Setup befindlichen Host die
Registrierung stellvertretend durchgeführt. Hier bietet sich natürlich
der Checkmk-Server an, der in der Regel als erster Host eingerichtet
wird. Wie beim Beispiel oben gilt, dass Sie das Passwort per Option
übergeben können oder interaktiv danach gefragt werden, wenn Sie die
Option `--password` weglassen. Die JSON-Ausgabe leiten wir im Beispiel
in eine Datei um:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl proxy-register \
    --hostname mynewhost3 \
    --server cmkserver --site mysite \
    --user agent_registration > /tmp/mynewhost3.json
```
:::
::::

::: paragraph
Nun übertragen wir die Datei `/tmp/mynewhost3.json` auf den Host, für
den wir die Registrierung durchgeführt haben, und importieren die Datei:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    import %TEMP%\mynewhost3.json
```
:::
::::
::::::::::

::::: sect2
### []{#_host_ins_monitoring_aufnehmen .hidden-anchor .sr-only}4.7. Host ins Monitoring aufnehmen {#heading__host_ins_monitoring_aufnehmen}

::: paragraph
Sobald die Registrierung fertiggestellt ist, führen Sie im Setup des
Checkmk-Servers einen
[Verbindungstest](wato_monitoringagents.html#diagnosticpage) und eine
[Service-Erkennung](wato_services.html#discovery) durch. Anschließend
nehmen Sie die gefundenen Services ins Monitoring auf, indem Sie als
letzten Schritt [die Änderungen aktivieren.](wato.html#activate_changes)
:::

::: paragraph
Falls der Verbindungstest fehlschlägt, finden Sie im [folgenden
Kapitel](#test) Informationen zu Test und Fehlerdiagnose.
:::
:::::

::::::::::::::: sect2
### []{#deregister .hidden-anchor .sr-only}4.8. Host deregistrieren {#heading_deregister}

::: paragraph
Die Registrierung eines Hosts können Sie auch wieder rückgängig machen.
:::

::: paragraph
Auf einem Host, der mit dem Checkmk-Server verbunden ist, können Sie das
Vertrauensverhältnis widerrufen. Dabei ist im folgenden Kommando der
anzugebende Universally Unique Identifier (UUID) derjenige, der beim
Kommando `cmk-agent-ctl status` ausgegeben wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    delete d38e7e53-9f0b-4f11-bbcf-d196deadbeef
```
:::
::::

::: paragraph
Um alle Verbindungen des Hosts zu entfernen **und** zusätzlich den
Legacy-Pull-Modus wiederherzustellen, geben Sie folgendes Kommando ein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    delete-all --enable-insecure-connections
```
:::
::::

::: paragraph
Anschließend verhält sich der Agent wie nach der erstmaligen
Installation und vor der ersten Registrierung und sendet seine Daten
unverschlüsselt.
:::

::: paragraph
Komplettiert wird die Deregistrierung auf dem Checkmk-Server: Im Setup
wählen Sie auf der Seite [Properties of host]{.guihint} den Menüeintrag
[Host \> Remove TLS registration]{.guihint} aus und bestätigen die
Nachfrage.
:::

::: paragraph
Falls Sie die Kommandozeile bevorzugen: Auf dem Checkmk-Server existiert
für jede Verbindung eines registrierten Hosts, der sich im Monitoring
befindet, ein Softlink mit der UUID, welcher auf den Ordner mit der
Agentenausgabe zeigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cd ~/var/agent-receiver/received-outputs
OMD[mysite]:~$ ls -l d38e7e53-9f0b-4f11-bbcf-d19617971595
lrwxrwxrwx 1 mysite mysite 67 Feb 23 07:18 d38e7e53-9f0b-4f11-bbcf-d19617971595 -> /omd/sites/mysite/tmp/check_mk/data_source_cache/push-agent/mynewhost
```
:::
::::
:::::::::::::::

::::: sect2
### []{#changepush .hidden-anchor .sr-only}4.9. Umstellung zwischen Push- und Pull-Modus {#heading_changepush}

::: paragraph
Ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** können Sie Hosts vom Push- zum Pull-Modus und
umgekehrt umstellen. Dies kann in Einzelfällen nötig sein, wenn
Änderungen an der Netzwerktopologie anstehen oder ein Downgrade auf
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise** durchgeführt werden soll, wo nur der Pull-Modus
möglich sind.
:::

::: paragraph
Stellen Sie zunächst im Setup, in den Eigenschaften des Hosts, den
Zugriffsmodus mit der Option [Checkmk agent connection mode]{.guihint}
um. Innerhalb der nächsten Minute werden alle Services den Status
[UNKNOWN]{.state3} annehmen, weil keine Monitoring-Daten eingehen.
Führen Sie anschließend eine erneute Registrierung durch. Bei dieser
erneuten Registrierung teilt der Agent Receiver des Checkmk-Servers dem
Agent Controller mit, ob er Daten im Pull- oder im Push-Modus erwartet.
Die anschließende Kontrolle mit `cmk-agent-ctl status` zeigt dann eine
neue UUID und den Modus konsistent mit der Änderung im Setup an.
:::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#test .hidden-anchor .sr-only}5. Test und Fehlerdiagnose {#heading_test}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Ein modulares System kann an vielen Stellen nicht wie vorgesehen
funktionieren. Da mit dem Agenten seit der Version [2.1.0]{.new} die
beiden Komponenten Agent Controller auf dem Host und Agent Receiver auf
dem Checkmk-Server eingeführt wurden, steigt die Zahl der Stellen, an
denen etwas schiefgehen kann.
:::

::: paragraph
Bei der Fehlersuche ist daher eine strukturierte Vorgehensweise
sinnvoll. Selbstverständlich können Sie die hier beschriebene
schrittweise Analyse auch nutzen, die Datenerhebung und Kommunikation
von Checkmk näher kennenzulernen.
:::

::: paragraph
Alle Möglichkeiten, die es vom Checkmk-Server aus gibt, sind im
allgemeinen Artikel über die
[Monitoring-Agenten](wato_monitoringagents.html#diagnostics)
beschrieben. Aber natürlich gibt es noch weitere Diagnosemöglichkeiten,
wenn man direkt auf dem überwachten Host angemeldet ist.
:::

::: paragraph
Wir arbeiten uns im Folgenden vom Agentenprogramm über den Agent
Controller und den TCP-Port 6556 bis zur Checkmk-Instanz durch. Beim
Agent Controller im Push-Modus überspringen Sie Tests auf Port 6556 --
selbst wenn der Port 6556 vor der Registrierung geöffnet ist, wird er
nach der Registrierung im Push-Modus geschlossen. In den meisten Fällen
können Sie nach Korrektur eines Fehlers die Service-Erkennung erneut
starten und die Aufnahme ins Monitoring abschließen.
:::

:::::::: sect2
### []{#_prüfen_der_konfiguration .hidden-anchor .sr-only}5.1. Prüfen der Konfiguration {#heading__prüfen_der_konfiguration}

::: paragraph
Um zu prüfen, ob die Konfiguration so eingelesen wurde, wie Sie das
erwarten, rufen Sie das Agentenprogramm mit der Option `showconfig` auf.
Mit dieser Option bekommen Sie nicht nur die Konfiguration ausgegeben,
wie sie derzeit vom Agenten benutzt wird. Zusätzlich werden auch immer
die benutzten Umgebungsvariablen sowie die verwendeten
Konfigurationsdateien angezeigt.
:::

::: paragraph
Ist nur ein bestimmter Teil der Konfiguration interessant, schränken Sie
die Ausgabe auf diesen Teil ein. Hier wird zum Beispiel geprüft, ob die
Optionen der Sektion `ps` korrekt gesetzt sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\check_mk_agent.exe" showconfig ps
# Environment Variables:
# MK_LOCALDIR="C:\ProgramData\checkmk\agent\local"
# MK_STATEDIR="C:\ProgramData\checkmk\agent\state"
# MK_PLUGINSDIR="C:\ProgramData\checkmk\agent\plugins"
# MK_TEMPDIR="C:\ProgramData\checkmk\agent\tmp"
# MK_LOGDIR="C:\ProgramData\checkmk\agent\log"
# MK_CONFDIR="C:\ProgramData\checkmk\agent\config"
# MK_SPOOLDIR="C:\ProgramData\checkmk\agent\spool"
# MK_INSTALLDIR="C:\ProgramData\checkmk\agent\install"
# MK_MSI_PATH="C:\ProgramData\checkmk\agent\update"
# Loaded Config Files:
# system: 'C:\Program Files (x86)\checkmk\service\check_mk.yml'
# bakery: 'C:\ProgramData\checkmk\agent\bakery'
# user  : 'C:\ProgramData\checkmk\agent\check_mk.user.yml'

# ps
enabled: yes
use_wmi: yes
full_path: no
```
:::
::::

::: paragraph
Über diesen Weg bekommen Sie einen schnellen Überblick, wie die drei
verschiedenen [Konfigurationsdateien](#config_files) vom Agentenprogramm
zusammengeführt und benutzt werden. Fehler werden somit sofort sichtbar.
:::
::::::::

::::::::::::::::::::::: sect2
### []{#networkrequirements .hidden-anchor .sr-only}5.2. Netzwerkumgebung für die Registrierung {#heading_networkrequirements}

::: paragraph
Schlägt die Registrierung eines Hosts im Monitoring fehl, ohne dass
überhaupt das Zertifikat angezeigt wird, hilft Kenntnis der involvierten
Netzwerkkommunikation bei der Identifizierung des Problems --- und
natürlich bei der Behebung.
:::

::: paragraph
Nach Absetzen des Kommandos `cmk-agent-ctl register` fragt der Agent
Controller zunächst mittels REST-API den Checkmk-Server nach dem Port
des Agent Receivers. Im zweiten Schritt wird eine Verbindung zum Agent
Receiver aufgebaut, um das Zertifikat abzurufen. Sie können die erste
Anfrage auf dem Host mit einem Programm wie
[`curl`](https://curl.se/windows/microsoft.html){target="_blank"}
simulieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> curl.exe -v --insecure https://mycmkserver/mysite/check_mk/api/1.0/domain-types/internal/actions/discover-receiver/invoke
```
:::
::::

::: paragraph
Der Parameter `--insecure` weist `curl` hier an, keine
Zertifikatsprüfung vorzunehmen. Dieses Verhalten entspricht dem
Verhalten des Agent Controller an dieser Stelle. Die Antwort ist
lediglich wenige Bytes groß und besteht aus der Port-Nummer des Agent
Receiver. Bei der ersten Instanz auf einem Server wird die Antwort
einfach `8000` lauten, bei der zweiten `8001` und so weiter. Typische
Probleme bei dieser Anfrage sind:
:::

::: ulist
- Der Checkmk-Server ist vom Host aus gar nicht erreichbar.

- Der von der REST-API verwendete Port weicht von den Standard-Ports 443
  (https) oder 80 (http) ab
:::

::: paragraph
Falls die obige Anfrage fehlschlägt, können Sie die Routing- oder
Firewall-Einstellungen so verändern, dass der Zugriff möglich ist.
:::

::: paragraph
Wenn der zu registrierende Host einen HTTP-Proxy verwendet, nutzt `curl`
diesen, `cmk-agent-ctl` jedoch nicht in den Standardeinstellungen. Mit
der zusätzlichen Option `--detect-proxy` weisen Sie `cmk-agent-ctl` an,
den systemweit konfigurierten Proxy zu nutzen.
:::

::: paragraph
Oft dürfte es am einfachsten sein, auf dem Checkmk-Server den Port des
Agent Receiver auszulesen und zu notieren. Führen Sie dazu den folgenden
Befehl als Instanzbenutzer aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config show | grep AGENT_RECEIVER
AGENT_RECEIVER: on
AGENT_RECEIVER_PORT: 8000
```
:::
::::

::: paragraph
Sie können nun den ermittelten Port bei der Registrierung direkt angeben
und so die erste Anfrage via REST-API überspringen. Die Kommunikation
findet dann ohne Umwege direkt mit dem Agent Receiver statt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" ^
    register ^
    --hostname mynewhost ^
    --server cmkserver:8000 --site mysite ^
    --user agent_registration --password PTEGDYXBFXVGNDPRL
```
:::
::::

::: paragraph
Auch dieser Port 8000 muss vom Host aus erreichbar sein. Ist er das
nicht, erhalten Sie die eindeutige Fehlermeldung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ERROR [cmk_agent_ctl] Connection refused (os error 111)
```
:::
::::

::: paragraph
Analog zu Port 443 (respektive 80) oben können Sie jetzt die Routing-
oder Firewall-Einstellungen so anpassen, dass der zu registrierende Host
den Checkmk-Server auf dem Port des Agent Receiver (8000 oder 8001...)
erreichen kann.
:::

::: paragraph
Im Falle der Registrierung im Push-Modus gilt: Hat die Registrierung
funktioniert, wird auch der minütliche Transfer der Agentenausgabe
erfolgreich sein.
:::

::: paragraph
Sollten Sicherheitsrichtlinien in Ihrer Umgebung den Zugriff auf den
Agent Receiver nicht zulassen, haben sie die Möglichkeit, auf dem
Checkmk-Server selbst die [Registrierung im Auftrag](#proxyregister)
vorzunehmen.
:::
:::::::::::::::::::::::

:::::::: sect2
### []{#agent_ctl_dump .hidden-anchor .sr-only}5.3. Agent Controller im Dump-Modus {#heading_agent_ctl_dump}

::: paragraph
Da das Agentenprogramm unter dem LocalSystem-Konto aufgerufen werden
muss, um exakt jene Daten zu liefern, die im Monitoring ankommen,
sollten Sie es nie in einer Shell starten. Wenn Sie die Agentenausgabe
lokal untersuchen wollen, verwenden Sie den Agent Controller im
*Dump-Modus* (Subkommando `dump`). Dieser startet das Agentenprogramm
mit der richtigen Environment und unter der richtigen Nutzerkennung und
gibt anschließend das Ergebnis aus.
:::

::: paragraph
Weil die Ausgabe etwas länger sein kann, ist der Pager `more` hier sehr
praktisch. Sie können Ihn mit der Taste Q verlassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\system32> "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe" dump | more
<<<check_mk>>>
Version: 2.3.0p16
BuildDate: Mar 14 2023
AgentOS: windows
Hostname: DESKTOP-QVPV284
Architecture: 64bit
WorkingDirectory: C:\Windows\system32
ConfigFile: C:\Program Files (x86)\checkmk\service\check_mk.yml
LocalConfigFile: C:\ProgramData\checkmk\agent\check_mk.user.yml
AgentDirectory: C:\Program Files (x86)\checkmk\service
PluginsDirectory: C:\ProgramData\checkmk\agent\plugins
StateDirectory: C:\ProgramData\checkmk\agent\state
ConfigDirectory: C:\ProgramData\checkmk\agent\config
TempDirectory: C:\ProgramData\checkmk\agent\tmp
LogDirectory: C:\ProgramData\checkmk\agent\log
SpoolDirectory: C:\ProgramData\checkmk\agent\spool
LocalDirectory: C:\ProgramData\checkmk\agent\local
OnlyFrom:
<<<cmk_agent_ctl_status:sep(0)>>>
```
:::
::::

::: paragraph
So können Sie überprüfen, welche Daten vom Agentenprogramm beim Agent
Controller angekommen sind. Diese Ausgabe beweist aber noch nicht, dass
der Agent auch über das Netzwerk erreichbar ist.
:::
::::::::

::::::::::::: sect2
### []{#_verbindungstest_von_außen .hidden-anchor .sr-only}5.4. Verbindungstest von außen {#heading__verbindungstest_von_außen}

::: paragraph
Ist im Pull-Modus sichergestellt, dass lokal das Agentenprogramm und die
mitinstallierten Plugins korrekt ausgeführt werden, können Sie als
Nächstes vom Checkmk-Server per `netcat` (oder `nc`) prüfen, ob Port
6556 über die externe IP-Adresse des Hosts erreichbar ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo | nc 10.76.23.189 6556
16
```
:::
::::

::: paragraph
Die Ausgabe `16` zeigt an, dass die Verbindungsaufnahme erfolgreich war
und nun der TLS-Handshake stattfinden kann. Da alles weitere hier TLS
verschlüsselt stattfindet, ist keine detaillierte Prüfung möglich.
:::

::: paragraph
Falls die Kommunikation zwischen Agent und Checkmk-Server *noch*
unverschlüsselt ist (wie im Legacy-Pull-Modus) oder unverschlüsselt ist
und auch bleibt (wie beim Legacy-Agenten), erhalten Sie mit diesem
Kommando statt der `16` die komplette unverschlüsselte Agentenausgabe.
:::

::: paragraph
Weitere Diagnosemöglichkeiten zur Ausführung auf dem Checkmk-Server
finden Sie im allgemeinen Artikel über die
[Monitoring-Agenten.](wato_monitoringagents.html#diagnostics) Sie können
insbesondere einen
[Verbindungstest](wato_monitoringagents.html#diagnosticpage) auch über
die Checkmk-Oberfläche durchführen. Das Ergebnis erhalten Sie im Kasten
[Agent:]{.guihint}
:::

::::: imageblock
::: content
![Fehlermeldung eines nicht erreichbaren Agenten beim
Verbindungstest.](../images/agent_windows_communication_failed.png){width="64%"}
:::

::: title
Fehler beim Verbindungstest zum Agenten
:::
:::::

::: paragraph
Falls Sie beim Verbindungstest, wie im obigen Beispiel, keine
Informationen bzw. nur eine Fehlermeldung über einen Timeout erhalten,
so sollten Sie auf dem Host die [Inbound Rules]{.guihint} der
Windows-Firewall prüfen.
:::
:::::::::::::

:::::::::::::: sect2
### []{#windows_firewall .hidden-anchor .sr-only}5.5. Windows Firewall {#heading_windows_firewall}

::: paragraph
Der Agent legt bei seiner Installation bereits eine Regel in der Windows
Firewall an, damit der Agent Controller über den Port 6556 von außen
erreichbar ist. Bei Verwendung des Push-Modus ist in der Regel keine
Änderung der Einstellungen nötig. Falls Sie eine sehr strenge
Firewall-Konfiguration verwenden, sind die *Outbound Rules* für
Verbindungen zum Monitoring-Server so anzupassen, dass wenigstens [Port
8000](ports.html#cmk_incoming_host_outgoing) (für einfachere
Registrierung zusätzlich 80 oder 443) erreichbar ist.
:::

::: paragraph
In aktuellen Versionen von Windows können Sie die [Windows Defender
Firewall with Advanced Security]{.guihint} über die Windows
Einstellungen ([Settings \> Windows Security]{.guihint}) finden oder
über den Aufruf von `wf.msc` über die Kommandozeile starten:
:::

::::: imageblock
::: content
![Eintrag des Checkmk-Agenten für die Windows
Firewall.](../images/agent_windows_windows_firewall.png)
:::

::: title
Windows Firewall mit der eingehenden Regel für den Checkmk-Agenten
:::
:::::

::: paragraph
Sollten Sie in den Einstellungen der Windows Firewall keinen solchen
Eintrag finden, können Sie diesen genau an dieser Stelle hinzufügen.
Klicken Sie dafür im Menü [Action]{.guihint} auf [New Rule]{.guihint}.
:::

::: paragraph
Daraufhin öffnet sich ein Assistent für die Erstellung einer neuen
Firewall-Regel. Stellen Sie die fünf Auswahlmöglichkeiten wie folgt ein:
:::

+---------+------------------------------------------------------------+
| [Rule   | Belassen Sie die Auswahl hier auf [Program.]{.guihint}     |
| T       |                                                            |
| ype]{.g |                                                            |
| uihint} |                                                            |
+---------+------------------------------------------------------------+
| [Prog   | Tragen Sie unter [This program path]{.guihint}             |
| ram]{.g | `%ALLUSERSPROFILE%\checkmk\agent\bin\cmk-agent-ctl.exe`    |
| uihint} | ein oder wählen Sie über den Knopf [Browse]{.guihint} die  |
|         | Datei `cmk-agent-ctl.exe` aus.                             |
+---------+------------------------------------------------------------+
| [Act    | Belassen Sie die Auswahl auf [Allow the                    |
| ion]{.g | connection.]{.guihint}                                     |
| uihint} |                                                            |
+---------+------------------------------------------------------------+
| [Prof   | Dieser Punkt kommt stark auf die Konfiguration Ihres       |
| ile]{.g | Netzwerks an. Es empfiehlt sich allerdings in den meisten  |
| uihint} | Fällen hier nur [Domain]{.guihint} und [Private]{.guihint} |
|         | zu aktivieren.                                             |
+---------+------------------------------------------------------------+
| [N      | Geben Sie der Regel einen prägnanten und kurzen Namen.     |
| ame]{.g |                                                            |
| uihint} |                                                            |
+---------+------------------------------------------------------------+

::: paragraph
Alternativ können Sie auch diesen Schritt automatisieren und die Regel
direkt auf der Kommandozeile setzen. Passen Sie den folgenden Befehl
gegebenenfalls Ihrem angepassten Installationspfad an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Windows\System32> netsh advfirewall firewall add rule name="Checkmk Agent" ^
description="Allow inbound network traffic to the Checkmk Agent" dir=in localport=6556 protocol=tcp action=allow ^
program="%ALLUSERSPROFILE%\checkmk\agent\bin\cmk-agent-ctl.exe" ^
profile=private,domain enable=yes
OK.
```
:::
::::

::: paragraph
**Hinweis:** Der Befehl wurde zugunsten der Lesbarkeit in vier Zeilen
aufgeteilt.
:::
::::::::::::::

:::::::: sect2
### []{#debugpush .hidden-anchor .sr-only}5.6. Fehlersuche beim Agenten im Push-Modus {#heading_debugpush}

::: paragraph
Im Ordner `~/var/agent-receiver/received-outputs/` Ihrer Checkmk-Instanz
finden Sie für jeden registrierten Host einen Softlink, der als Name die
UUID des Hosts verwendet. Bei Hosts im Push-Modus zeigt dieser Softlink
auf den Ordner mit der Agentenausgabe, bei Pull-Hosts auf eine nicht
vorhandene Datei mit dem Namen des Hosts, wie er im Monitoring verwendet
wird.
:::

::: paragraph
Anhand des Alters der zwischengespeicherten Agentenausgabe können Sie
ermitteln, ob die regelmäßige Übertragung erfolgreich war oder
beispielsweise durch sporadische Netzwerkprobleme vereitelt wird.
:::

::: paragraph
Des Weiteren können Sie auf dem Host einen Blick in die Log-Datei
`C:\ProgramData\checkmk\agent\log\check_mk.log` werfen (Pfade können
abweichend konfiguriert sein). Zeilen wie die folgende deuten auf
Verbindungsprobleme hin:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Dez 15 17:59:49 myhost23 cmk-agent-ctl[652648]: WARN [cmk_agent_ctl::modes::push] https://mycmkserver:8000/mysite: Error pushing agent output.
```
:::
::::
::::::::

::::: sect2
### []{#lostconnections .hidden-anchor .sr-only}5.7. Verbindungen gehen verloren {#heading_lostconnections}

::: paragraph
Wurde ein Host für die
[Autoregistrierung](hosts_autoregister.html#rule_autoregister_bakery)
mit dem Regelsatz [Agent controller auto-registration]{.guihint}
konfiguriert und die Option [Keep existing connections]{.guihint} auf
[no]{.guihint} gesetzt, werden bei jedem Neustart des Dienstes
`cmk-agent-ctl-daemon` (beispielsweise beim Neustart eines Hosts) alle
anderen Verbindungen entfernt --- außer der für die Autoregistrierung
konfigurierten Verbindung. Dies betrifft beispielsweise Hosts, auf denen
vor der Installation des gebackenen Agentenpakets Verbindungen zu
mehreren Instanzen eingerichtet waren oder nach der Installation des
Agentenpakets manuell Verbindungen hinzugefügt wurden.
:::

::: paragraph
Sie können dieses Verhalten temporär ändern, indem Sie auf dem Host in
der Datei `C:\ProgramData\checkmk\agent\pre_configured_connections.json`
die Variable `keep_existing_connections` auf `true` setzen. Eine
dauerhafte Änderung über ein Update der Agentenpakete hinweg erreichen
Sie, indem Sie im oben genannten Regelsatz [Keep existing
connections]{.guihint} auf [yes]{.guihint} setzen.
:::
:::::

:::: sect2
### []{#howlong .hidden-anchor .sr-only}5.8. Zeitdauer bis Änderungen sichtbar werden {#heading_howlong}

::: paragraph
Bei der Autoregistrierung eines Hosts vergehen typischerweise etwa zwei
Minuten, bis der Host im Monitoring auftaucht.
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::: sect1
## []{#security .hidden-anchor .sr-only}6. Absicherung {#heading_security}

:::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_vorüberlegung .hidden-anchor .sr-only}6.1. Vorüberlegung {#heading__vorüberlegung}

::: paragraph
Sicherheit ist ein wichtiges Kriterium für jegliche Software, hier darf
Monitoring keine Ausnahme machen. Da der Monitoring-Agent auf jedem
überwachten Server installiert wird, hätte hier ein Sicherheitsproblem
besonders gravierende Auswirkungen.
:::

::: paragraph
Deswegen wurde schon beim Design von Checkmk auf Sicherheit Wert gelegt
und es gilt seit den ersten Tagen von Checkmk ein eherner Grundsatz:
*Der Agent liest keine Daten vom Netzwerk. Punkt.* Somit ist mit
Sicherheit ausgeschlossen, dass ein Angreifer über den Überwachungsport
6556 irgendwelche Befehle oder Skriptbestandteile einschleusen kann.
:::
:::::

:::::: sect2
### []{#_transport_layer_security_tls .hidden-anchor .sr-only}6.2. Transport Layer Security (TLS) {#heading__transport_layer_security_tls}

::: paragraph
Für einen Angreifer kann jedoch bereits eine Prozessliste ein erster
Ansatz sein, Rückschlüsse auf lohnenswerte Ziele zu ziehen. Daher ist
die Transportverschlüsselung zwischen Agent und Checkmk-Server mit
Transport Layer Security (TLS) ab Checkmk-Version [2.1.0]{.new}
obligatorisch. Hierbei \"pingt\" der Checkmk-Server den überwachten Host
an, der daraufhin die TLS-Verbindung zum Checkmk-Server aufbaut und
darüber die Agentenausgabe überträgt. Da nur Checkmk-Server, zu denen
ein Vertrauensverhältnis besteht, diese Datenübertragung initiieren
können, besteht schon einmal kein Risiko, dass Daten in die falschen
Hände gelangen.
:::

::: paragraph
Für die Absicherung der TLS-Verbindung verwendet Checkmk ein selbst
signiertes Zertifikat, das kurz vor Ablauf seiner Gültigkeit automatisch
ersetzt wird. Der Agent Controller kümmert sich um die rechtzeitige
Erneuerung des Zertifikates vor seinem Ablauf. Nur längere Zeit inaktive
Agenten, d.h., ohne laufenden Agent Controller, können ihre
Registrierung bei Ablauf verlieren und müssen dann erneut registriert
werden. Die Laufzeit des Zertifikats kann über die globale Einstellung
[Agent Certificates \> Lifetime of certificates]{.guihint} festgelegt
werden.
:::

::: paragraph
**Hinweis:** Da es auf sehr alten [Windows-Systemen](#legacyagent)
keinen Agent Controller, und damit keine Registrierung und
TLS-Verschlüsselung gibt, müssen Sie bei Bedarf andere Wege der
Verschlüsselung wählen. Wir empfehlen, in diesem Fall die eingebaute
(symmetrische) Verschlüsselung zu nutzen, sie wird mit der Regel
[Symmetric encryption (Linux, Windows)]{.guihint} eingerichtet.
:::
::::::

::::::::: sect2
### []{#_zugriff_über_ip_adressen_beschränken .hidden-anchor .sr-only}6.3. Zugriff über IP-Adressen beschränken {#heading__zugriff_über_ip_adressen_beschränken}

::: paragraph
Die Einschränkung auf bestimmte IP-Adressen können Sie zwar auch über
die [Firewall](#windows_firewall) konfigurieren. Zusätzlich bietet aber
auch der Agent selbst die Möglichkeit, Anfragen von fremden IP-Adressen
schlicht zu ignorieren. Fügen Sie der Konfigurationsdatei lediglich die
folgende Einschränkung in den globalen Optionen hinzu. Beachten Sie,
dass davor oder danach noch andere Parameter in der Konfigurationsdatei
gesetzt sein können und dies nur ein Ausschnitt ist:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
global:
  only_from: 127.0.0.1/32 192.168.42.0/24
```
:::
:::::

::: paragraph
Wie in dem Beispiel gut zu sehen ist, können Sie prinzipiell beliebig
viele Subnetze erlauben. Mit einem `/32` geben Sie z.B. ein Subnetz der
Größe 1 an, so dass nur diese eine Adresse erlaubt ist, während sie mit
`192.168.42.0/24` alle Adressen zwischen `192.168.42.0` und
`192.168.42.255` erlauben.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In der
Agentenbäckerei können Sie die erlaubten IP-Adressen über folgenden
Regelsatz konfigurieren: [Setup \> Agents \> Windows, Linux, Solaris,
AIX \> Agent rules \> Allowed agent access via IP address (Linux,
Windows)]{.guihint}
:::
:::::::::

::::::::::::: sect2
### []{#_eingebaute_verschlüsselung_abschalten .hidden-anchor .sr-only}6.4. Eingebaute Verschlüsselung abschalten {#heading__eingebaute_verschlüsselung_abschalten}

::: paragraph
Insbesondere bei einem Update des Agenten kann es sein, dass die
eingebaute (symmetrische) Verschlüsselung aktiv ist, die vom
Agentenprogramm selbst durchgeführt wird. Sind TLS-Verschlüsselung und
eingebaute Verschlüsselung gleichzeitig aktiv, dann ist die Entropie der
übertragenen Daten so hoch, dass die ab Version [2.1.0]{.new} aktive
Komprimierung keine Ersparnis der übertragenen Daten bringt -- und die
CPUs sowohl des Hosts als auch des Checkmk-Servers mit zusätzlichen Ver-
und Entschlüsselungsschritten belasten.
:::

::: paragraph
Aus diesem Grund sollten Sie die eingebaute Verschlüsselung zeitnah nach
dem Wechsel auf TLS deaktivieren.
:::

::: paragraph
Im ersten Schritt schalten Sie in der vorhandenen Regel unter [Setup \>
Agents \> Access to agents \> Checkmk agent \> Symmetric encryption
(Linux, Windows)]{.guihint} die Verschlüsselung ab.
:::

::: paragraph
Im zweiten Schritt ändern Sie auf dem Host des Agenten in der
Konfigurationsdatei `C:\ProgramData\checkmk\agent\check_mk.user.yml` den
Wert des Parameters `encrypted` auf `no`:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
global:
  encrypted: no
  passphrase: D0e5NotMat7erAnym0r3
```
:::
:::::

::: paragraph
Im dritten und letzten Schritt legen Sie mit der Regel [Enforce agent
data encryption]{.guihint} fest, dass der Checkmk-Server nur noch per
TLS verschlüsselte Daten akzeptiert. Wählen Sie dazu in der Regel den
Wert [Accept TLS encrypted connections only]{.guihint} aus.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Das Abschalten
der Verschlüsselung mit der Agentenbäckerei geht so: Mit dem ersten
Schritt, dem Ändern der Regel [Symmetric encryption (Linux,
Windows),]{.guihint} sind Sie fast fertig. Sie brauchen nur noch neue
Agenten zu backen und zu verteilen. Die Konfigurationsdatei
`C:\ProgramData\checkmk\agent\check_mk.user.yml` wird automatisch für
Sie geändert und mit in die Agentenpakete eingebaut. Übrig bleibt dann
nur der dritte Schritt, d.h. die Änderung der Regel [Enforce agent data
encryption.]{.guihint}
:::

::: paragraph
Nach dem nächsten automatischen Agenten-Update ist die Verschlüsselung
des Agentenprogramms abgeschaltet, aber durch den Agent Controller die
Verschlüsselung garantiert. Beachten Sie, dass nach dem automatischen
Agenten-Update nur noch registrierte Hosts Monitoring-Daten liefern
können.
:::
:::::::::::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#disable_sections .hidden-anchor .sr-only}7. Sektionen deaktivieren {#heading_disable_sections}

:::::::::::::::: sectionbody
::: paragraph
Die Ausgabe des Checkmk-Agenten ist in Sektionen unterteilt. Jede dieser
Sektionen enthält zusammengehörige Informationen. Sektionen beginnen
immer mit einem Sektions-Header. Dies ist eine Zeile, die in `<<<` und
`>>>` eingeschlossen ist.
:::

::: paragraph
Bis auf die Checkmk eigenen Sektionen, können Sie jede der über 30
Sektionen, die der Agent standardmäßig erzeugt, einzeln deaktivieren.
Konkret bedeutet dies, dass die entsprechenden Befehle durch den Agenten
überhaupt nicht ausgeführt werden und ggf. Rechenzeit eingespart werden
kann. Andere Gründe für die Deaktivierung könnten sein, dass Sie sich
für bestimmte Informationen einer gewissen Gruppe von Hosts schlicht
nicht interessieren, oder dass ein bestimmter Host fehlerhafte Werte
liefert und Sie den Abruf dieser Daten kurzzeitig aussetzen wollen.
:::

::: paragraph
Als Nutzer einer der kommerziellen Editionen können Sie über [Setup \>
Agents \> Windows, Linux, Solaris, AIX \> Agent rules \> Disabled
sections (Windows agent)]{.guihint} einfach eine Regel anlegen, welche
dann von der [Agentenbäckerei](glossar.html#agent_bakery) berücksichtigt
wird.
:::

::::: imageblock
::: content
![Liste der Agentenregeln für den
Windows-Agenten.](../images/agent_windows_disabled_sections.png)
:::

::: title
In den kommerziellen Editionen können Sie Sektionen per Regel
deaktivieren
:::
:::::

::: paragraph
**Hinweis:** Das obige Bild zeigt, dass es zu [Disabled sections
(Windows agent)]{.guihint} auch eine gegenteilige Regel [Enabled
sections (Windows agent)]{.guihint} gibt. Sie können also statt mit der
Negativ- auch mit der Positivliste arbeiten. Um den Überblick zu
behalten, empfehlen wir aber, nur *eine* der beiden Regeln zu verwenden.
:::

::: paragraph
In der Regel [Disabled sections (Windows agent)]{.guihint} finden Sie
für jede deaktivierbare Sektion eine eigene Checkbox. Für die
angewählten Checkboxen finden Sie dann --- nachdem der neu gebackene
Agent auf den ausgewählten Hosts installiert wurde --- in der
Konfigurationsdatei der Agentenbäckerei
`C:\ProgramData\checkmk\agent\bakery\check_mk.bakery.yml` unterhalb von
`global:` eine Zeile `disabled_sections:`, in der die ausgewählten
Sektionen aufgelistet sind.
:::

::: paragraph
Würden Sie in der Regel beispielsweise die beiden Optionen
`System uptime` und `Web Services` auswählen, sähe die passende
Konfigurationsdatei wie folgt aus:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
global:
    disabled_sections: [uptime, wmi_webservices]
```
:::
:::::

::: paragraph
Nutzer von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** können einen Eintrag in der Konfigurationsdatei
`C:\ProgramData\checkmk\agent\check_mk.user.yml` manuell anlegen und
dort die Sektionen eintragen, die deaktiviert werden sollen. Alle
deaktivierbaren Sektionen sind in dieser Datei unterhalb von `global:`
im Abschnitt `_sections:` aufgelistet.
:::
::::::::::::::::
:::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::: sect1
## []{#plugins .hidden-anchor .sr-only}8. Agent um Plugins erweitern {#heading_plugins}

::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_was_sind_agentenplugins .hidden-anchor .sr-only}8.1. Was sind Agentenplugins? {#heading__was_sind_agentenplugins}

::: paragraph
Das Agentenprogramm `check_mk_agent.exe` enthält eine ganze Reihe von
Sektionen, welche Überwachungsdaten für diverse Check-Plugins liefern,
die dann von der Service-Erkennung automatisch gefunden werden. Dazu
gehören alle wichtigen Überwachungen des Betriebssystems.
:::

::: paragraph
Darüber hinaus gibt es die Möglichkeit, den Agenten um *Agentenplugins*
zu erweitern. Das sind kleine Skripte oder Programme, die vom Agenten
aufgerufen werden und diesen um weitere Sektionen mit zusätzlichen
Monitoring-Daten erweitern. Das Checkmk-Projekt liefert eine ganze Reihe
solcher Plugins mit aus, welche --- wenn sie korrekt installiert und
konfiguriert sind --- in der Service-Erkennung automatisch neue Services
liefern.
:::

::: paragraph
Warum sind diese Plugins nicht einfach in den Agenten fest integriert?
Für jedes der Plugins gibt es einen der folgenden Gründe:
:::

::: ulist
- Das Plugin kann seine Daten nur über interne Schnittstellen holen, die
  der Agent nicht bereitstellt (Beispiel: PowerShell).

- Das Plugin benötigt sowieso eine Konfiguration, ohne die es nicht
  funktionieren würde (Beispiel: `mk_oracle.ps1`).

- Das Plugin ist so speziell, dass es von den meisten Anwendern nicht
  benötigt wird (Beispiel: `citrix_licenses.vbs`).
:::
:::::::

:::::::::::: sect2
### []{#manual_installation_of_plugins .hidden-anchor .sr-only}8.2. Manuelle Installation {#heading_manual_installation_of_plugins}

::: paragraph
Die mitgelieferten Plugins für Windows finden Sie alle auf dem
überwachten Host im Installationsverzeichnis des Agenten unter
`C:\Program Files (x86)\checkmk\service\plugins`. Sie werden dort
abgelegt, damit sie auch direkt zur Verfügung stehen. Alternativ liegen
die Plugins für Windows auch auf dem Checkmk-Server unter
`~/share/check_mk/agents/windows/plugins`.
:::

::: paragraph
Auch über die Download-Seite des Agenten im Setup-Menü (wie im Kapitel
[Installation](#download_gui) beschrieben) sind diese im Kasten
[Plugins]{.guihint} verfügbar:
:::

::::: imageblock
::: content
![Download-Seite mit den
Agentenplugins.](../images/agent_windows_files_plugins.png)
:::

::: title
Der Anfang der Liste verfügbarer Agentenplugins
:::
:::::

::: paragraph
Zu allen von uns mitgelieferten Agentenplugins existieren die passenden
Check-Plugins, welche deren Daten auswerten und Services erzeugen
können. Diese sind bereits mitinstalliert, so dass neu gefundene
Services sofort erkannt werden und konfiguriert werden können.
:::

::: paragraph
**Hinweis:** Bevor Sie ein Plugin auf dem Host installieren, werfen Sie
einen Blick in die entsprechende Datei. Oft finden Sie dort wichtige
Hinweise zur korrekten Verwendung des Plugins.
:::

::: paragraph
Die eigentliche Installation ist dann einfach: Kopieren Sie die Datei
nach `C:\ProgramData\checkmk\agent\plugins`.
:::

::: paragraph
Sobald das Plugin im richtigen Verzeichnis liegt, wird es vom Agenten
automatisch aufgerufen und es entsteht eine neue Sektion in der
Agentenausgabe. Diese trägt üblicherweise den gleichen Namen wie das
Plugin. Komplexe Plugins (z.B. `mk_oracle.ps1`) erzeugen sogar eine
ganze Reihe an neuen Sektionen.
:::
::::::::::::

:::::::::: sect2
### []{#pluginconfig .hidden-anchor .sr-only}8.3. Konfiguration {#heading_pluginconfig}

::: paragraph
Manche Plugins benötigen eine Konfigurationsdatei in
`C:\ProgramData\checkmk\agent\config`, damit sie funktionieren können.
Bei anderen ist eine Konfiguration optional (z.B. `mssql.vbs`) und
ermöglicht besondere Features oder Anpassungen. Wieder andere
funktionieren einfach so. Sie haben verschiedene Quellen, um an
Informationen zu kommen:
:::

::: ulist
- Die Dokumentation der zugehörigen Check-Plugins in Ihrer
  Checkmk-Instanz, welche Sie über [Setup \> Services \> Catalog of
  check plugins]{.guihint} erreichen.

- Kommentare in der Plugin-Datei (oft sehr hilfreich!)

- Einen passenden Artikel in diesem Handbuch (z.B. über das Überwachen
  von [Oracle](monitoring_oracle.html))
:::

::: paragraph
Bei speziellen (Skript)-Sprachen kann es notwendig sein, diese erst in
der Konfiguration des Agenten *freizuschalten*. So werden beispielsweise
Python-Skripte nicht ausgeführt, wenn sie nicht explizit freigegeben
wurden. Sie können dazu in der Konfigurationsdatei `check_mk.user.yml`
in der Sektion `global` die Dateiendungen erweitern, wie im folgenden
Ausschnitt zu sehen:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
global:
    execute: [exe, bat, vbs, cmd, ps1, py]
```
:::
:::::

::: paragraph
**Wichtig**: Der Einsatz solcher Plugins setzt voraus, dass die Dateien
auch in einer regulären Kommandozeile ohne spezielle Pfade aufgerufen
werden können. Im Fall von Python muss dieses entsprechend korrekt
installiert und der Pfad zu dem Interpreter in den Umgebungsvariablen
vorhanden sein. Anleitungen, wie Sie Python korrekt einrichten, finden
Sie direkt auf den Seiten der [Python Software
Foundation.](https://www.python.org/doc/){target="_blank"}
:::
::::::::::

::::::::: sect2
### []{#customizeexecution .hidden-anchor .sr-only}8.4. Ausführung eines speziellen Plugins anpassen {#heading_customizeexecution}

::: paragraph
Jedes Plugin kann in unterschiedlichen Modi ausgeführt werden. Dabei
stehen die folgenden Optionen zur Eingabe in der Konfigurationsdatei zur
Verfügung.
:::

+-------+---------+---------------------------------------------------+
| O     | Wert    | Beschreibung                                      |
| ption |         |                                                   |
+=======+=========+===================================================+
| `pat  | `       | Setzt die Reichweite der nachfolgenden Optionen.  |
| tern` | '@user\ | Hier kann auch mit Wildcards gearbeitet werden.   |
|       | *.ps1'` | Dann beziehen sich die nachfolgenden Optionen auf |
|       |         | alle Plugins, auf die der Ausdruck zutrifft.      |
|       |         | Führend wird bestimmt, ob das Plugin direkt aus   |
|       |         | dem Installationsverzeichnis unter                |
|       |         | `C:\Program Files (x86)\` oder aus dem            |
|       |         | Datenverzeichnis unter `C:\ProgramData`           |
|       |         | ausgeführt werden soll.                           |
+-------+---------+---------------------------------------------------+
| `run` | **`yes` | Bestimmt, ob die Ausführung eines Plugins         |
|       | **`/no` | unterdrückt werden soll.                          |
+-------+---------+---------------------------------------------------+
| `a    | **`yes` | Führt ein Plugin asynchron aus und legt die Daten |
| sync` | **`/no` | in einer Datei ab. Bei synchroner Ausführung wird |
|       |         | die Ausgabe direkt dem Agenten übergeben.         |
+-------+---------+---------------------------------------------------+
| `tim  | *       | Setzt die maximale Ausführungszeit. Danach wird   |
| eout` | *`60`** | das Plugin beendet, auch wenn keine Ausgabe       |
|       |         | gekommen ist. Der Standardwert orientiert sich an |
|       |         | dem Standard für das Abfrageintervall des         |
|       |         | Agenten.                                          |
+-------+---------+---------------------------------------------------+
| `     | *       | Legt in Sekunden fest, wie lange eine Ausgabe     |
| cache | *`60`** | gültig ist.                                       |
| _age` |         |                                                   |
+-------+---------+---------------------------------------------------+
| `re   | **`1`** | Die Häufigkeit, wie oft ein Plugin fehlschlagen   |
| try_c |         | darf, bevor eine Ausgabe aus dem Cache verworfen  |
| ount` |         | wird.                                             |
+-------+---------+---------------------------------------------------+
| `de   | `       | Hier können Sie einen freien Text eintragen, der  |
| scrip | 'Text'` | den Logs angefügt werden soll.                    |
| tion` |         |                                                   |
+-------+---------+---------------------------------------------------+

::: paragraph
Eine Konfiguration für das Veeam-Plugin sieht dann zum Beispiel so aus
(der Auszug ist gekürzt und enthält nur den relevanten Teil für das
Beispiel):
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
plugins:
    enabled: yes
    execution:
        - pattern: $CUSTOM_PLUGINS_PATH$\veeam_backup_status.ps1
          async: yes
          timeout: 120
          cache_age: 300
          retry_count: 2
```
:::
:::::

::: paragraph
Nach der obigen beispielhaften Konfiguration wird das Plugin im
Datenverzeichnis `C:\ProgramData\checkmk\agent\plugins` ausgeführt, und
zwar asynchron alle fünf Minuten (300 Sekunden) und darf dabei maximal
zwei Minuten (120 Sekunden) laufen. Falls das Plugin in diesen Timeout
läuft, wird ein zweites Mal versucht ein Ergebnis zu bekommen.
:::
:::::::::

:::::::: sect2
### []{#_installation_über_die_agentenbäckerei .hidden-anchor .sr-only}8.5. Installation über die Agentenbäckerei {#heading__installation_über_die_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können die mitgelieferten Plugins über die
[Agentenbäckerei](glossar.html#agent_bakery) konfiguriert werden. Diese
sorgt sowohl für die Installation des Plugins selbst als auch für die
korrekte Erstellung der Konfigurationsdatei, falls eine notwendig sein
sollte.
:::

::: paragraph
Jedes Plugin wird über eine Agentenregel konfiguriert. Sie finden die
passenden Regelsätze in [Setup \> Agents \> Windows, Linux, Solaris, AIX
\> Agent rules \> Agent Plugins]{.guihint}:
:::

::::: imageblock
::: content
![Seite mit den Regeln zur Konfiguration der Agentenplugins in den
kommerziellen Editionen.](../images/agent_linux_rules_agent_plugins.png)
:::

::: title
Liste mit Regeln für die Agentenplugins in den kommerziellen Editionen
:::
:::::
::::::::

:::: sect2
### []{#_manuelle_ausführung .hidden-anchor .sr-only}8.6. Manuelle Ausführung {#heading__manuelle_ausführung}

::: paragraph
Da Agentenplugins ausführbare Programme sind, können Sie diese zu Test-
und Diagnosezwecken auch von Hand ausführen. Es gibt allerdings Plugins,
welche bestimmte vom Agenten gesetzte Umgebungsvariablen brauchen, um
z.B. ihre Konfigurationsdatei zu finden. Setzen Sie diese gegebenenfalls
von Hand, wenn sie in dem Skript oder Programm benötigt werden.
:::
::::
:::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::: sect1
## []{#e2e_monitoring .hidden-anchor .sr-only}9. Einbinden von Legacy Nagios Check-Plugins {#heading_e2e_monitoring}

::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::::: sect2
### []{#mrpe .hidden-anchor .sr-only}9.1. Plugins über MRPE ausführen {#heading_mrpe}

::: paragraph
Es gibt zwei gute Gründe, Nagios-Plugins auch unter Checkmk zu nutzen.
Wenn Sie Ihr Monitoring von einer Nagios-basierten Lösung auf Checkmk
migriert haben, können Sie ältere Check-Plugins, zu denen es noch kein
Checkmk-Pendant gibt, zunächst weiter nutzen. In vielen Fällen sind das
selbst geschriebene Plugins in Perl oder Shell.
:::

::: paragraph
Der zweite Grund für die Verwendung ist echtes End-to-End-Monitoring.
Nehmen wir an, Sie haben Ihren Checkmk-Server, einen Webserver und einen
Datenbankserver über ein großes Rechenzentrum verteilt. In so einem Fall
sind die Antwortzeiten des Datenbankservers vom Checkmk-Server aus
gemessen wenig aussagekräftig. Weit wichtiger ist es, diese Werte für
die Verbindung zwischen Web- und Datenbankserver zu kennen.
:::

::: paragraph
Der Checkmk-Agent bietet einen einfachen Mechanismus, diesen beiden
Anforderungen gerecht zu werden: *MK's Remote Plugin Executor* oder kurz
*MRPE*. Der Name ist bewusst eine Analogie zum *NRPE* von Nagios, der
dort die gleiche Aufgabe übernimmt.
:::

::: paragraph
Der MRPE ist im Agenten fest eingebaut und wird über verschiedene
Konfigurationsdateien gesteuert.
:::

::::::: sect3
#### []{#_mrpe_aktivieren_und_deaktivieren .hidden-anchor .sr-only}MRPE aktivieren und deaktivieren {#heading__mrpe_aktivieren_und_deaktivieren}

::: paragraph
Standardmäßig ist die Berücksichtigung von MRPE-Plugins aktiviert. Falls
Sie diese Funktion nicht nutzen wollen, können Sie sie in der
Konfigurationsdatei deaktivieren, indem Sie die folgende Definition
hinzufügen:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
mrpe:
  enabled: no
```
:::
:::::
:::::::

::::::: sect3
#### []{#_die_ausführungszeit_begrenzen .hidden-anchor .sr-only}Die Ausführungszeit begrenzen {#heading__die_ausführungszeit_begrenzen}

::: paragraph
Manchmal ist die Laufzeit eines Skripts oder Nagios-Plugins nicht
vorhersehbar und im schlimmsten Fall wird ein Plugin nie beendet. Um
hier die Kontrolle zu behalten, können Sie die maximale Laufzeit der
MRPE-Plugins begrenzen. Der hier gezeigte Wert ist auch gleichzeitig der
Standardwert in Sekunden. Anpassungen sind also nur notwendig, wenn Sie
ein kürzeres oder längeres Intervall festlegen möchten:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
mrpe:
  # enabled: yes
  timeout: 60
```
:::
:::::
:::::::

::::::::::: sect3
#### []{#_mrpe_plugins_hinzufügen .hidden-anchor .sr-only}MRPE-Plugins hinzufügen {#heading__mrpe_plugins_hinzufügen}

::: paragraph
Um dem Agenten mitzuteilen, wo sich die auszuführende Datei befindet und
wie diese aufzurufen ist, fügen Sie einen Eintrag in der Konfiguration
des MRPE hinzu:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
mrpe:
  config:
    - check = MyServiceName 'C:\ProgramData\checkmk\agent\mrpe\my_check_plugin.bat' -w 10 -c 20 MyParameter
```
:::
:::::

::: paragraph
Es ist nicht notwendig, die Datei ebenfalls in dem Verzeichnis des
Agenten abzulegen, auch wenn es sich anbietet, um alle an einem
gemeinsamen Ort zu sammeln. In dieser Beispielkonfiguration sehen Sie
nun folgende Elemente der relevanten Zeile:
:::

+-----------------------------------+-----------------------------------+
| Element                           | Beschreibung                      |
+===================================+===================================+
| `MyServiceName`                   | Der Servicename, wie er in        |
|                                   | Checkmk angezeigt werden soll.    |
+-----------------------------------+-----------------------------------+
| `'C:\ProgramData\checkmk          | Auszuführendes Programm;          |
| \agent\mrpe\my_check_plugin.bat'` | Anführungszeichen für eventuelle  |
|                                   | Leerzeichen.                      |
+-----------------------------------+-----------------------------------+
| `-w 10 -c 20`                     | Übergebene Optionen: Ein          |
|                                   | Schwellwert von 10 für            |
|                                   | [WARN]{.state1} und 20 für        |
|                                   | [CRIT]{.state2}.                  |
+-----------------------------------+-----------------------------------+
| `MyParameter`                     | Beispielhafte Übergabe weiterer   |
|                                   | Parameter.                        |
+-----------------------------------+-----------------------------------+

::: paragraph
Nachdem Sie das MRPE-Plugin eingerichtet haben, ist es direkt und ohne
Neustart des Agenten aktiv und wird der Ausgabe hinzugefügt. In der
Service-Erkennung werden Sie nun Ihren neuen Service automatisch finden:
:::

:::: imageblock
::: content
![agent windows service
discovery](../images/agent_windows_service_discovery.png)
:::
::::
:::::::::::
::::::::::::::::::::::::::

:::: sect2
### []{#_mrpe_mit_der_agentenbäckerei .hidden-anchor .sr-only}9.2. MRPE mit der Agentenbäckerei {#heading__mrpe_mit_der_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Alternativ zu der
Konfiguration direkt auf einem Host in der benutzerspezifischen
Konfigurationsdatei können Sie Ihre MRPE-Plugins auch direkt im
[Setup]{.guihint}-Menü definieren. Benutzen Sie dazu den Regelsatz
[Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agent \> Agent rules
\> Execute MRPE checks]{.guihint}. Der notwendige Eintrag wird dann
automatisch in der [Konfigurationsdatei der
Agentenbäckerei](#config_files) erzeugt.
:::
::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

::::::: sect1
## []{#hw_monitoring .hidden-anchor .sr-only}10. Hardware überwachen {#heading_hw_monitoring}

:::::: sectionbody
::: paragraph
Die Hardware-Überwachung von Windows-Hosts wird vom Checkmk-Agenten,
mitgelieferten Plugins und in der [Checkmk
Exchange](https://exchange.checkmk.com/){target="_blank"} erhältlichen
Erweiterungen gut abgedeckt. Dennoch gibt es Situationen, in denen weder
fertige Plugins noch Programmierschnittstellen zur Erstellung eigener
Plugins erhältlich sind, aber entweder eine Anwendungssoftware oder ein
Hardware-Überwachungstool eines Hardware-Herstellers Überwachungsdaten
per SNMP liefern kann.
:::

::: paragraph
Setzen Sie in so einem Fall in den Eigenschaften des Hosts im Setup im
Kasten [Monitoring agents]{.guihint} die Einstellung [SNMP]{.guihint}
auf die geeignete Verbindungsart ([SNMP v2 or v3]{.guihint} oder [SNMP
v1)]{.guihint}. Services, die sowohl per SNMP als auch per Checkmk-Agent
verfügbar sind (z.B. CPU-Auslastung, Dateisysteme, Netzwerkkarten),
werden dann automatisch vom Checkmk-Agenten geholt und nicht per SNMP.
Damit wird eine Doppelübertragung automatisch vermieden.
:::

::: paragraph
Weitere Informationen entnehmen Sie dem Artikel zur [Überwachung mit
SNMP.](snmp.html#snmp_cmk_agent)
:::
::::::
:::::::

::::::::::::::::::: sect1
## []{#uninstall .hidden-anchor .sr-only}11. Deinstallation {#heading_uninstall}

:::::::::::::::::: sectionbody
::: paragraph
Für die Deinstallation des Agenten haben Sie in Windows mehrere
Möglichkeiten. In allen Versionen von Windows finden Sie einen Eintrag
in der Systemsteuerung unter [Control Panel \> Programs and Features \>
Uninstall a program.]{.guihint} In neueren Versionen finden Sie den
Eintrag für den Checkmk-Agenten zudem in den Einstellungen unter
[Settings \> Apps \> Apps & features.]{.guihint}
:::

::: paragraph
Über die Kommandozeile für Administratoren haben Sie mehrere
Möglichkeiten den Agenten zu entfernen. Sollte Ihnen das zuletzt
installierte MSI-Paket noch vorliegen, können Sie dieses wie folgt für
die Deinstallation nutzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\Users\hhirsch\Downloads\> msiexec /x check_mk_agent.msi /qn
```
:::
::::

::: paragraph
Alternativ können Sie auch das Windows Management Instrumentation
Command (WMIC) für die Deinstallation verwenden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\> wmic product where name="Check MK Agent 2.1" call uninstall /nointeractive
```
:::
::::

::: paragraph
War die Deinstallation erfolgreich, erhalten Sie als Bestätigung die
Meldung `Method execution successful.`
:::

::: paragraph
**Hinweis:** Der String hinter `name=` muss exakt stimmen. Wenn Sie hier
eine andere Version des Agenten deinstallieren wollen, finden Sie eine
Auflistung aller installierten Produkte mit folgendem Aufruf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\> wmic product get name
```
:::
::::

::: paragraph
Der Vorgang kann bisweilen recht lange dauern und gibt derweil keinerlei
Statusmeldungen aus, dafür dann aber sehr lange Listen. Zum Filtern
können Sie den Befehl zur Pipe ausbauen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\> wmic product get name | findstr Check
Check MK Agent 2.1
```
:::
::::

::: paragraph
Da die verschiedenen Routinen von Windows nur Dateien entfernen, welche
auch durch den Installationsprozess dorthin gekommen sind, ist es
vollkommen normal, dass in den [Verzeichnissen des Agenten](#files) noch
Dateien übrig bleiben. Diese können manuell gelöscht werden.
:::
::::::::::::::::::
:::::::::::::::::::

:::::: sect1
## []{#files .hidden-anchor .sr-only}12. Dateien und Verzeichnisse {#heading_files}

::::: sectionbody
::: sect2
### []{#_pfade_auf_dem_überwachten_host .hidden-anchor .sr-only}12.1. Pfade auf dem überwachten Host {#heading__pfade_auf_dem_überwachten_host}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `C:\Program                   | Installationsverzeichnis für die     |
| Files (x86)\checkmk\service\` | programmspezifischen Dateien         |
|                               | inklusive des Agentenprogramms       |
|                               | `check_mk_agent.exe` und des Agent   |
|                               | Controllers `cmk-agent-ctl.exe`.     |
|                               | Anpassungen sind hier nicht          |
|                               | notwendig.\                          |
|                               | Der Agent wird als 32-Bit und 64-Bit |
|                               | Programm ausgeliefert. Die           |
|                               | Installationsroutine wählt           |
|                               | automatisch das richtige Programm    |
|                               | für ein 32-Bit oder 64-Bit           |
|                               | Betriebssystem aus. In das           |
|                               | Verzeichnis `Program Files (x86)`    |
|                               | wird der Agent aus Gründen der       |
|                               | Kompatibilität installiert.          |
+-------------------------------+--------------------------------------+
| `C:\Program Files (x86)\      | Die Standardkonfigurationsdatei des  |
| checkmk\service\check_mk.yml` | Agenten. Ändern Sie diese Datei      |
|                               | nicht.                               |
+-------------------------------+--------------------------------------+
| `C                            | Installationsverzeichnis für die     |
| :\ProgramData\checkmk\agent\` | Host-spezifischen Dateien. Hier      |
|                               | befinden sich Erweiterungen, Log-    |
|                               | und Konfigurationsdateien, welche    |
|                               | spezifisch für diesen Host gelten.   |
+-------------------------------+--------------------------------------+
| `C:\ProgramData\checkmk\agen  | Diese Konfigurationsdatei wird von   |
| t\bakery\check_mk.bakery.yml` | der Agentenbäckerei erstellt und     |
|                               | überschreibt gegebenenfalls Werte    |
|                               | aus der Standardkonfigurationsdatei. |
+-------------------------------+--------------------------------------+
| `C:\ProgramData\che           | Konfigurationsdatei für Ihre         |
| ckmk\agent\check_mk.user.yml` | individuellen Anpassungen. Diese     |
|                               | Datei wird als letztes eingelesen    |
|                               | und überschreibt gegebenenfalls      |
|                               | Werte aus den anderen                |
|                               | Konfigurationsdateien.               |
+-------------------------------+--------------------------------------+
| `C:\Progr                     | Verzeichnis für Plugins, welche      |
| amData\checkmk\agent\plugins` | automatisch vom Agenten ausgeführt   |
|                               | werden sollen und dessen Ausgabe um  |
|                               | zusätzliche Überwachungsdaten        |
|                               | erweitern.                           |
+-------------------------------+--------------------------------------+
| `C:\Pro                       | Enthält Daten, die z.B. von          |
| gramData\checkmk\agent\spool` | Log-Dateien erstellt werden und eine |
|                               | eigene Sektion beinhalten. Diese     |
|                               | werden ebenfalls der Agentenausgabe  |
|                               | angehängt. Mehr dazu erfahren Sie im |
|                               | Artikel [Das                         |
|                               | Spool                                |
|                               | -Verzeichnis.](spool_directory.html) |
+-------------------------------+--------------------------------------+
| `C:\ProgramData\checkmk\agent | Enthält eine Liste der mit dem Agent |
| \registered_connections.json` | Controller registrierten             |
|                               | Verbindungen.                        |
+-------------------------------+--------------------------------------+
| `C:\                          | Enthält eine vorkonfigurierte und    |
| ProgramData\checkmk\agent\pre | per Agentenbäckerei in das           |
| _configured_connections.json` | Agentenpaket integrierte Verbindung  |
|                               | zu einer Instanz für die             |
|                               | [Autoregi                            |
|                               | strierung.](hosts_autoregister.html) |
+-------------------------------+--------------------------------------+
| `C:\Prog                      | Ablage von Konfigurationsdateien für |
| ramData\checkmk\agent\config` | den Agenten.                         |
+-------------------------------+--------------------------------------+
| `C:\Pro                       | Verzeichnis für eigene [lokale       |
| gramData\checkmk\agent\local` | Checks](localchecks.html).           |
+-------------------------------+--------------------------------------+
| `C:\Pr                        | MRPE-Erweiterungen können hier       |
| ogramData\checkmk\agent\mrpe` | gespeichert werden.                  |
+-------------------------------+--------------------------------------+
| `C:\Prog                      | Nach jeder Änderung des              |
| ramData\checkmk\agent\backup` | Checkmk-Agenten-Service wird von der |
|                               | Benutzerkonfiguration hier ein       |
|                               | Backup angelegt.                     |
+-------------------------------+--------------------------------------+
| `C:\P                         | Hier finden Sie Log-Dateien. Neben   |
| rogramData\checkmk\agent\log` | der ständig im Betrieb               |
|                               | aktualisierten `check_mk.log` (in    |
|                               | allen Editionen) können hier weitere |
|                               | Protokolle von automatischer         |
|                               | Installation oder Updates vorhanden  |
|                               | sein.                                |
+-------------------------------+--------------------------------------+
:::

::: sect2
### []{#_pfade_auf_dem_checkmk_server .hidden-anchor .sr-only}12.2. Pfade auf dem Checkmk-Server {#heading__pfade_auf_dem_checkmk_server}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/local/                     | Basisverzeichnis für eigene Dateien, |
| share/check_mk/agents/custom` | die mit einem gebackenen Agenten     |
|                               | ausgeliefert werden sollen.          |
+-------------------------------+--------------------------------------+
| `~/sh                         | Verzeichnis mit dem MSI-Paket des    |
| are/check_mk/agents/windows/` | Agenten. In diesem Verzeichnis       |
|                               | finden Sie auch                      |
|                               | Konfigurationsbeispiele und alle     |
|                               | Agentenplugins.                      |
+-------------------------------+--------------------------------------+
| `~/var/age                    | Enthält für jede Verbindung deren    |
| nt-receiver/received-outputs` | UUID als Softlink, der auf einen     |
|                               | Ordner mit dem Namen des Hosts       |
|                               | zeigt. Im Push-Modus enthält dieser  |
|                               | Ordner die Agentenausgabe.           |
+-------------------------------+--------------------------------------+
:::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
