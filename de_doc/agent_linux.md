:::: {#header}
# Linux überwachen

::: details
[Last modified on 28-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/agent_linux.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen im Legacy-Modus](agent_linux_legacy.html)
[Monitoring-Agenten](wato_monitoringagents.html) [Automatische
Agenten-Updates](agent_deployment.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Der Linux-Agent {#heading_intro}

:::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Linux-Logo.](../images/linux.png){width="120"}
:::
::::

::: paragraph
Linux-Systeme können Sie mit Checkmk besonders gut überwachen. Das liegt
weniger daran, dass sich das Checkmk-Entwicklerteam auf Linux „zu Hause"
fühlt, sondern vielmehr daran, dass Linux ein sehr offenes System ist
und zahlreiche gut dokumentierte und einfach abzufragende Schnittstellen
für eine detaillierte Überwachung bereitstellt.
:::

::: paragraph
Da die meisten der Schnittstellen per se nicht über das Netzwerk
erreichbar sind, ist die Installation eines Monitoring-Agenten
unumgänglich. Deswegen hat Checkmk einen eigenen Agenten für die
Überwachung von Linux. Dieser ist ein simples Shellskript, das
minimalistisch, transparent und sicher ist.
:::

::: paragraph
In der Checkmk-Version [2.1.0]{.new} wurde diesem **Agentenskript** mit
dem **Agent Controller** eine neue Komponente zur Seite gestellt. Der
Agent Controller ist dem Agentenskript vorgeschaltet, fragt dieses ab
und kommuniziert an dessen Stelle mit dem Checkmk-Server. Dazu
registriert er sich am **Agent Receiver**, einem Prozess, der auf dem
Checkmk-Server läuft.
:::

::: paragraph
Der Linux-Agent übernimmt also zum einen das Agentenskript, und damit
dessen Vorteile. Zum anderen ergänzt er das Skript so, dass neue
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
Der Agent Controller wird als Hintergrundprozess (*Daemon*) vom
init-System `systemd` gestartet, daher setzt der Agent eine
Linux-Distribution mit `systemd` voraus. Wahrscheinlich wird diese
Voraussetzung auf Ihrem Host erfüllt sein, da seit 2015 die meisten
Linux-Distributionen `systemd` als init-System übernommen haben.
:::

::: paragraph
Allerdings beherrscht der Agent auch einen sogenannten **Legacy-Modus**,
um Linux-Systeme zu unterstützen mit einer anderen Rechnerarchitektur
als x86_64, ohne RPM- bzw. DEB-Paketmanagement und ohne init-System
`systemd`. In diesem Legacy-Modus arbeitet der Agent nur als
Agentenskript, d.h. ohne Agent Controller und damit auch ohne
Registrierung am Checkmk-Server.
:::

::: paragraph
Der Artikel, den Sie gerade lesen, behandelt Installation, Konfiguration
und Erweiterungen des Linux-Agenten **mit** Agent Controller. Er zeigt
Ihnen aber auch, wie Sie herausfinden können, ob der Agent auf Ihrem
Linux-System ohne Agent Controller im Legacy-Modus eingerichtet werden
muss. Im Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) finden Sie dann dazu alle
Informationen.
:::
::::::::::::::
:::::::::::::::

:::::::: sect1
## []{#agent_architecture .hidden-anchor .sr-only}2. Architektur des Agenten {#heading_agent_architecture}

::::::: sectionbody
::: paragraph
Der Checkmk-Agent besteht aus dem Agentenskript und dem Agent
Controller, der mit dem Agent Receiver auf dem Checkmk-Server
kommuniziert. Im allgemeinen Artikel über die
[Monitoring-Agenten](wato_monitoringagents.html#agents) finden Sie
Einzelheiten zur gemeinsamen Architektur von Linux-Agent und
[Windows-Agent.](agent_windows.html) In diesem Kapitel geht es um die
für Linux spezifische Implementierung.
:::

::: paragraph
Das **Agentenskript** `check_mk_agent` ist zuständig für die Sammlung
der Monitoring-Daten und ruft für die Datensammlung der Reihe nach
vorhandene Systembefehle auf. Um auch diejenigen Informationen zu
erhalten, zu deren Beschaffung `root`-Rechte erforderlich sind, wird
`check_mk_agent` unter `root` ausgeführt.
:::

::: paragraph
Das Agentenskript ist minimalistisch, sicher, leicht erweiterbar und
transparent, denn es ist ein Shellskript, in dem Sie sehen können,
welche Befehle es aufruft.
:::

::: paragraph
Der **Agent Controller** `cmk-agent-ctl` kümmert sich um den Transport
der vom Agentenskript gesammelten Daten. Er wird unter dem Benutzer
`cmk-agent` ausgeführt, der nur beschränkte Rechte besitzt, z.B. keine
Login-Shell hat und nur zur Datenübertragung genutzt wird. Der Benutzer
`cmk-agent` wird während der Installation des Agentenpakets angelegt.
Der Agent Controller wird als Daemon von `systemd` gestartet und ist als
Service an diesen gekoppelt. Im Pull-Modus lauscht er am TCP-Port 6556
auf eingehende Verbindungen der Checkmk-[Instanz](glossar.html#site) und
fragt das Agentenskript über einen Unix-Socket (einer `systemd` Unit)
ab.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#install .hidden-anchor .sr-only}3. Installation {#heading_install}

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk bietet Ihnen für die Installation des Linux-Agenten verschiedene
Wege --- von der manuellen Installation des Software-Pakets bis hin zur
vollautomatischen Verteilung inklusive Update-Funktion. Manche davon
stehen nur in den kommerziellen Editionen zur Verfügung:
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
| RPM/DEB-Paket      | Standard-Agenten mit manueller    |      |      |
|                    | Konfiguration über                |      |      |
|                    | Konfigurationsdateien. Die        |      |      |
|                    | Installationsroutine überprüft    |      |      |
|                    | und konfiguriert in allen         |      |      |
|                    | Editionen `systemd` und           |      |      |
|                    | `xinetd` --- in dieser            |      |      |
|                    | Reihenfolge.                      |      |      |
+--------------------+-----------------------------------+------+------+
| RPM/DEB-Paket aus  | Konfiguration über die GUI,       |      | X    |
| der                | individuelle Konfiguration pro    |      |      |
| [Agenten           | Host möglich.                     |      |      |
| bäckerei](glossar. |                                   |      |      |
| html#agent_bakery) |                                   |      |      |
+--------------------+-----------------------------------+------+------+
| [Automatisches     | Das Paket aus der Agentenbäckerei |      | X    |
| Update](agen       | wird erstmalig von Hand oder per  |      |      |
| t_deployment.html) | Skript installiert und von da an  |      |      |
|                    | automatisch aktualisiert.         |      |      |
+--------------------+-----------------------------------+------+------+

::::::::::::::::::::::::::: sect2
### []{#download .hidden-anchor .sr-only}3.1. Download des RPM/DEB-Pakets {#heading_download}

::: paragraph
Sie installieren den Linux-Agenten durch Installation des RPM- oder des
DEB-Pakets. Ob Sie RPM oder DEB benötigen, hängt von der
Linux-Distribution ab, auf der Sie das Paket installieren möchten:
:::

+------+------+--------------------------------------------------------+
| P    | En   | Installation auf                                       |
| aket | dung |                                                        |
+======+======+========================================================+
| RPM  | `.   | Red Hat Enterprise Linux (RHEL) basierte Systeme,      |
|      | rpm` | SLES, Fedora, openSUSE, etc.                           |
+------+------+--------------------------------------------------------+
| DEB  | `.   | Debian, Ubuntu, alle anderen DEB-basierten             |
|      | deb` | Distributionen                                         |
+------+------+--------------------------------------------------------+

::: paragraph
Vor der Installation müssen Sie das Paket holen und auf den Host bringen
(zum Beispiel mit `scp` oder WinSCP), auf dem der Agent laufen soll.
:::

:::::::: sect3
#### []{#download_gui .hidden-anchor .sr-only}Paket per Checkmk-GUI holen {#heading_download_gui}

::: paragraph
In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** finden Sie die Linux-Pakete des Agenten über [Setup \>
Agents \> Linux]{.guihint}. In den kommerziellen Editionen gelangen Sie
im [Setup]{.guihint}-Menü über [Agents \> Windows, Linux, Solaris,
AIX]{.guihint} zunächst in die
[Agentenbäckerei](wato_monitoringagents.html#bakery), wo Sie die
gebackenen Pakete finden. Von dort aus kommen Sie mit dem Menüeintrag
[Related \> Linux, Solaris, AIX files]{.guihint} zur Liste der
Agentendateien:
:::

::::: imageblock
::: content
![Download-Seite mit den
RPM/DEB-Paketen.](../images/agent_linux_agent_files.png)
:::

::: title
Auf der Download-Seite finden Sie die RPM- und DEB-Pakete
:::
:::::

::: paragraph
Alles was Sie brauchen, finden Sie gleich im ersten Kasten mit dem Namen
[Packaged Agents]{.guihint}: die fertigen RPM- und DEB-Paketdateien für
die Installation des Linux-Agenten mit Standardeinstellungen.
:::
::::::::

:::::::::: sect3
#### []{#_paket_per_http_holen .hidden-anchor .sr-only}Paket per HTTP holen {#heading__paket_per_http_holen}

::: paragraph
Manchmal ist der Download auf einen Rechner und das anschließende
Kopieren auf den Zielrechner mit `scp` oder WinSCP sehr umständlich. Sie
können das Paket vom Checkmk-Server auch direkt per HTTP auf das
Zielsystem laden. Für diesen Zweck sind die Downloads der Agentendateien
bewusst *ohne Anmeldung* möglich. Immerhin enthalten die Dateien keine
Geheimnisse. Jeder kann sich Checkmk selbst herunterladen und
installieren und so auf die Dateien zugreifen.
:::

::: paragraph
Am einfachsten geht das mit `wget`. Die URL können Sie über den Browser
ermitteln. Wenn Sie den Namen des Pakets bereits kennen, können Sie die
URL einfach selbst zusammensetzen. Setzen Sie `/mysite/check_mk/agents/`
vor den Dateinamen, im folgenden Beispiel für das RPM-Paket:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# wget http://mycmkserver/mysite/check_mk/agents/check-mk-agent-2.3.0p16-1.noarch.rpm
```
:::
::::

::: paragraph
**Tipp:** RPM hat sogar ein eingebautes `wget`. Hier können Sie Download
und [Installation](#install_package) mit einem Kommando durchführen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -U http://mycmkserver/mysite/check_mk/agents/check-mk-agent-2.3.0p16-1.noarch.rpm
```
:::
::::
::::::::::

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
direkt auf den Zielrechner zu holen. Das mitgelieferte DEB-Paket des
Linux-Agenten lässt sich beispielsweise mit dem folgenden
`curl`-Kommando holen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# curl -OJG "http://mycmkserver/mysite/check_mk/api/1.0/domain-types/agent/actions/download/invoke" \
--header 'Accept: application/octet-stream' \
--header 'Authorization: Bearer automation myautomationsecret' \
--data-urlencode 'os_type=linux_deb'
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
:::::::::::::::::::::::::::

:::::::::::: sect2
### []{#install_package .hidden-anchor .sr-only}3.2. Paket installieren {#heading_install_package}

::: paragraph
Nachdem Sie das RPM- oder das DEB-Paket geholt und --- falls
nötig --- mit `scp`, WinSCP oder anderen Mitteln auf den zu
überwachenden Host kopiert haben, ist die Installation mit einem
Kommando erledigt.
:::

::: paragraph
Die Installation des RPM-Pakets erfolgt unter `root` mit dem Befehl
`rpm -U`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -U check-mk-agent-2.3.0p16-1.noarch.rpm
```
:::
::::

::: paragraph
Die Option `-U` steht übrigens für „Update", kann aber auch eine
Erstinstallation korrekt durchführen. Das bedeutet auch, dass Sie mit
diesem Befehl einen bereits installierten Agenten auf die aktuelle
Version updaten können --- und ihn auch zukünftig für Updates des
Agentenpakets nutzen können.
:::

::: paragraph
Die Installation des DEB-Pakets --- und ein Update --- erfolgt unter
`root` mit dem Befehl `dpkg -i`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg -i check-mk-agent_2.3.0p16-1_all.deb
(Reading database ... 739920 files and directories currently installed.)
Preparing to unpack .../check-mk-agent_2.3.0p16-1_all.deb ...
Unpacking check-mk-agent (2.3.0p16-1) ...
Setting up check-mk-agent (2.3.0p16-1) ...

Deploying systemd units: check-mk-agent.socket check-mk-agent-async.service cmk-agent-ctl-daemon.service check-mk-agent@.service
Deployed systemd
Creating/updating cmk-agent user account ...

WARNING: The agent controller is operating in an insecure mode! To secure the connection run cmk-agent-ctl register.

Reloading xinetd
Activating systemd unit 'check-mk-agent.socket'...
Created symlink /etc/systemd/system/sockets.target.wants/check-mk-agent.socket → /lib/systemd/system/check-mk-agent.socket.
Activating systemd unit 'check-mk-agent-async.service'...
Created symlink /etc/systemd/system/multi-user.target.wants/check-mk-agent-async.service → /lib/systemd/system/check-mk-agent-async.service.
Activating systemd unit 'cmk-agent-ctl-daemon.service'...
Created symlink /etc/systemd/system/multi-user.target.wants/cmk-agent-ctl-daemon.service → /lib/systemd/system/cmk-agent-ctl-daemon.service.
```
:::
::::

::: paragraph
Hier wurde das Paket auf einem zuvor agentenlosen Host erstmalig
installiert. Der Benutzer `cmk-agent` wurde erstellt und `systemd`
konfiguriert. Auf die dazwischen angezeigte Warnung zum `insecure mode`,
also dem Legacy-Pull-Modus, gehen wir [gleich](#post_install) ein.
:::
::::::::::::

::::: sect2
### []{#_installation_mit_der_agentenbäckerei .hidden-anchor .sr-only}3.3. Installation mit der Agentenbäckerei {#heading__installation_mit_der_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen verfügen mit der [Agentenbäckerei](glossar.html#agent_bakery)
über ein Software-Modul zum automatischen Paketieren von individuell
angepassten Agenten. Eine ausführliche Beschreibung dazu finden Sie im
allgemeinen Artikel über die [Agenten](wato_monitoringagents.html). Die
Installation der gebackenen Pakete geschieht genauso wie es für die
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

::::::::::::: sect2
### []{#post_install .hidden-anchor .sr-only}3.5. Wie geht es weiter nach der Installation? {#heading_post_install}

::: paragraph
Falls der Agent Controller bei der Installation mit `systemd`
konfiguriert werden konnte, ist der nächste Schritt die
[Registrierung](#registration), mit der die TLS-Verschlüsselung
eingerichtet wird, so dass die verschlüsselte Agentenausgabe vom
Checkmk-Server entschlüsselt und im Monitoring angezeigt werden kann.
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
Einen Hinweis auf den aktivierten Legacy-Pull-Modus erhalten Sie bereits
in der Kommandoausgabe bei der [Installation des
Agenten.](#install_package) Im Monitoring sieht das dann etwa so aus:
:::

::::: imageblock
::: content
![Der WARN-Zustand des \'Check_MK\' Services wegen fehlender
Verschlüsselung.](../images/agent_linux_service_legacy_pull_mode.png)
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
solange, bis Sie die Registrierung durchgeführt haben. Nach der
Registrierung wird nur noch im verschlüsselten Pull-Modus kommuniziert.
Der Legacy-Pull-Modus wird abgeschaltet und bleibt es auch. Allerdings
kann er im Bedarfsfall [per Kommando](#deregister) wieder eingeschaltet
werden.
:::

::: paragraph
Anders liegt der Fall, wenn der Agent Controller sich während der
Installation nicht als Daemon bei `systemd` registrieren konnte. Ohne
Agent Controller ist die Registrierung des Hosts nicht möglich und der
einzige Kommunikationsweg verbleibt der **Legacy-Modus**.
:::

::: paragraph
Im nächsten Kapitel können Sie durch [Test von Agent Controller und
Systemumgebung](#test_environment) feststellen, ob Sie mit der
Registrierung fortsetzen können.
:::

::: paragraph
**Hinweis:** Im Regelsatz [Checkmk Agent installation
auditing]{.guihint} finden Sie verschiedene Einstellungen, um den
Zustand des Agenten zu prüfen und im Monitoring sichtbar zu machen.
Unter anderem können Sie hier festlegen, welchen Zustand der Service
[Check_MK Agent]{.guihint} bei einer noch nicht durchgeführten
TLS-Konfiguration haben soll.
:::
:::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#registration .hidden-anchor .sr-only}4. Registrierung {#heading_registration}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::: sect2
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
:::

:::: sect3
#### []{#_voraussetzungen_auf_dem_host .hidden-anchor .sr-only}Voraussetzungen auf dem Host {#heading__voraussetzungen_auf_dem_host}

::: paragraph
Die Registrierung mit dem Agent Controller setzt ein Linux-System voraus
mit einem init-System `systemd` ab Version 219 und einer
x86_64-Rechnerarchitektur. Im Abschnitt [Agent Controller und
Systemumgebung testen](#test_environment) erfahren Sie, wie Sie diese
Voraussetzungen überprüfen.
:::
::::

:::: sect3
#### []{#_voraussetzungen_auf_dem_checkmk_server .hidden-anchor .sr-only}Voraussetzungen auf dem Checkmk-Server {#heading__voraussetzungen_auf_dem_checkmk_server}

::: paragraph
Damit die Registrierung direkt auf dem ins Monitoring aufzunehmenden
Host durchgeführt werden kann, muss dieser die REST-API des
Checkmk-Servers (Port 443 oder 80) und den Agent Receiver (Port 8000 bei
der ersten Instanz, 8001 bei der zweiten...) erreichen können. Lesen Sie
den Abschnitt [Netzwerkumgebung für die
Registrierung](#networkrequirements), falls in Ihrer IT-Infrastruktur
eine dieser Bedingungen nicht erfüllt werden kann.
:::
::::
:::::::::::

::::: sect2
### []{#_host_ins_setup_aufnehmen .hidden-anchor .sr-only}4.2. Host ins Setup aufnehmen {#heading__host_ins_setup_aufnehmen}

::: paragraph
Erstellen Sie zunächst den neuen Host über [Setup \> Hosts \> Add
host.]{.guihint} Ein Host muss in der
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

::::::::::::::::::::::::: sect2
### []{#test_environment .hidden-anchor .sr-only}4.3. Agent Controller und Systemumgebung testen {#heading_test_environment}

::: paragraph
Der Agent mit Agent Controller setzt eine Linux-Distribution mit
`systemd` voraus, präziser `systemd` in einer Version 219 oder neuer.
:::

::: paragraph
Die Chance ist groß, dass diese Voraussetzung auf Ihrem Host erfüllt
ist, da seit 2015 die meisten Linux-Distributionen `systemd` als
init-System übernommen und damit andere init-Systeme wie SysVinit
ersetzt haben, z.B. SUSE Linux Enterprise Server ab Version 12, openSUSE
ab Version 12.1, Red Hat Enterprise Linux ab Version 7, Fedora ab
Version 15, Debian ab Version 8 und Ubuntu ab Version 15.04. Leider
bringt der Vergleich der Versionsnummer alleine keine Gewissheit, da
`systemd` auch auf einem aktuellen Linux-System fehlen kann, wenn dieses
Jahre lang „nur" aktualisiert wurde.
:::

::: paragraph
Neben der Version von `systemd` sind einige weitere Voraussetzungen zu
erfüllen, die in diesem Kapitel abgeprüft werden.
:::

::: paragraph
**Achtung:** Push-Modus und Autoregistrierung sind zwingend an den Agent
Controller gebunden und daher nicht nutzbar im Legacy-Modus, auf den wir
in diesem Kapitel mehrfach verweisen.
:::

::: paragraph
Prüfen Sie zunächst auf dem Host, auf dem der Agent installiert werden
soll, ob und in welcher Version `systemd` läuft:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl --version
systemd 245 (245.4-4ubuntu3.15)
```
:::
::::

::: paragraph
Die obige Kommandoausgabe zeigt, dass `systemd` in der richtigen Version
installiert ist. Falls `systemd` nicht, oder nur in einer zu alten
Version läuft, kann der Agent Controller nicht verwendet werden.
Schließen Sie die Einrichtung ab, wie im Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) beschrieben.
:::

::: paragraph
Prüfen Sie nun, ob der Agent Controller gestartet werden kann:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl --version
```
:::
::::

::: paragraph
Als Ausgabe sollte die Versionsnummer zu sehen sein, beispielsweise:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
cmk-agent-ctl 2.3.0p16
```
:::
::::

::: paragraph
In seltenen Fällen erscheint die folgende Fehlermeldung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
bash: /usr/bin/cmk-agent-ctl: cannot execute binary file: Exec format error
```
:::
::::

::: paragraph
Ursache hierfür ist, dass Ihr Linux eine andere Rechnerarchitektur als
*x86_64* nutzt, zum Beispiel das ältere *32-Bit x86* oder *ARM*. In
diesem Fall kann der Agent Controller nicht verwendet werden. Schließen
Sie die Einrichtung ab, wie im Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) beschrieben.
:::

::: paragraph
Im nächsten Schritt gilt es herauszufinden, welches Programm auf Port
6556 auf Anfragen wartet:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ss -tulpn | grep 6556
tcp    LISTEN  0   1024    0.0.0.0:6556    0.0.0.0:*   users:(("cmk-agent-ctl",pid=1861810,fd=9))
```
:::
::::

::: paragraph
Hier ist es `cmk-agent-ctl`. Die Voraussetzungen für verschlüsselte
Kommunikation sind also erfüllt. Steht innerhalb der Klammer stattdessen
`systemd`, `xinetd` oder `inetd`, sind die Voraussetzungen für die
Verwendung des Agent Controllers nicht gegeben. Schließen Sie auch in
diesem Fall die Einrichtung ab, wie im Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) beschrieben.
:::
:::::::::::::::::::::::::

::::::::::::::: sect2
### []{#_host_beim_server_registrieren .hidden-anchor .sr-only}4.4. Host beim Server registrieren {#heading__host_beim_server_registrieren}

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
`root`-Rechten eine Anfrage an die Checkmk-[Instanz](glossar.html#site)
zu stellen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl register --hostname mynewhost \
    --server cmkserver --site mysite \
    --user agent_registration --password 'PTEGDYXBFXVGNDPRL'
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
:::::::::::::::

:::::::::: sect2
### []{#autoregister .hidden-anchor .sr-only}4.5. Host beim Server automatisch registrieren lassen {#heading_autoregister}

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
root@linux# cmk-agent-ctl register-new \
    --server cmkserver --site mysite \
    --agent-labels testhost:true \
    --user agent_registration --password 'PTEGDYXBFXVGNDPRL'
```
:::
::::

::: paragraph
Größter Unterschied hier ist das geänderte Subkommando `register-new`,
mit dem die Registrierung *und* die Erstellung eines neuen Hosts in der
Checkmk-Instanz angefragt wird. Als Name des Hosts wird der in der
Umgebungsvariable `$HOSTNAME` hinterlegte verwendet. Die anschließende
Bestätigung des Zertifikats entspricht der im letzten Abschnitt
gezeigten.
:::

::: paragraph
Ob der Host im Pull-Modus, im Push-Modus oder überhaupt nicht angelegt
wird, entscheiden Ihre Einstellungen des Regelsatzes [Agent
registration.]{.guihint} Nach erfolgreicher Registrierung können mehrere
Minuten vergehen, bis der Host im Monitoring auftaucht.
:::
::::::::::

:::::::: sect2
### []{#_vertrauensverhältnis_überprüfen .hidden-anchor .sr-only}4.6. Vertrauensverhältnis überprüfen {#heading__vertrauensverhältnis_überprüfen}

::: paragraph
Das Kommando `cmk-agent-ctl status` zeigt nun genau ein
Vertrauensverhältnis zum Checkmk-Server:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl status
Connection: 12.34.56.78:8000/mysite
   UUID: d38e7e53-9f0b-4f11-bbcf-d19617971595
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

::::::::::::: sect2
### []{#proxyregister .hidden-anchor .sr-only}4.7. Im Auftrag registrieren {#heading_proxyregister}

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
root@linux# cmk-agent-ctl import /tmp/mynewhost3.json
```
:::
::::

::: paragraph
Der gesamte Vorgang ist auch in einer Pipeline möglich, in der Sie die
Ausgabe von `cmk-agent-ctl proxy-register` an
`ssh hostname cmk-agent-ctl import` übergeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl proxy-register --hostname mynewhost3 \
    --server cmkserver --site mysite \
    --user agent_registration --password 'PTEGDYXBFXVGNDPRL' | \
    ssh root@mynewhost3 cmk-agent-ctl import
```
:::
::::
:::::::::::::

::::: sect2
### []{#_host_ins_monitoring_aufnehmen .hidden-anchor .sr-only}4.8. Host ins Monitoring aufnehmen {#heading__host_ins_monitoring_aufnehmen}

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
### []{#deregister .hidden-anchor .sr-only}4.9. Host deregistrieren {#heading_deregister}

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
root@linux# cmk-agent-ctl delete d38e7e53-9f0b-4f11-bbcf-d19617971595
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
root@linux# cmk-agent-ctl delete-all --enable-insecure-connections
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
### []{#changepush .hidden-anchor .sr-only}4.10. Umstellung zwischen Push- und Pull-Modus {#heading_changepush}

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
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#test .hidden-anchor .sr-only}5. Test und Fehlerdiagnose {#heading_test}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
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
Wir arbeiten uns im Folgenden vom Agentenskript über den Agent
Controller und den TCP-Port 6556 bis zur Checkmk-Instanz durch. Beim
Agent Controller im Push-Modus überspringen Sie Tests auf Port 6556 --
selbst wenn der Port 6556 vor der Registrierung geöffnet ist, wird er
nach der Registrierung im Push-Modus geschlossen. In den meisten Fällen
können Sie nach Korrektur eines Fehlers die Service-Erkennung erneut
starten und die Aufnahme ins Monitoring abschließen.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Beim direkten Aufruf des          |
|                                   | Agentenskripts in einer Shell     |
|                                   | stehen möglicherweise andere      |
|                                   | [Umgebungsvariabl                 |
|                                   | en](https://wiki.debian.org/Envir |
|                                   | onmentVariables){target="_blank"} |
|                                   | zur Verfügung als beim Aufruf     |
|                                   | durch den Agent Controller. Um    |
|                                   | die Ausgabe des Agentenskripts zu |
|                                   | analysieren, sollten Sie daher    |
|                                   | nach Möglichkeit den [Agent       |
|                                   | Controller im                     |
|                                   | Dump-Modus](#agent_ctl_dump)      |
|                                   | verwenden.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::::::: sect2
### []{#script_output .hidden-anchor .sr-only}5.1. Ausgabe des Agentenskripts {#heading_script_output}

::: paragraph
Das Agentenskript ist ein einfaches Shellskript, welches Daten über Ihr
System beschafft und als lose formatierten Text ausgibt. Sie können es
direkt auf der Kommandozeile aufrufen. Da die Ausgabe etwas länger sein
kann, ist der Pager `less` zum Scrollen der Ausgabe hier sehr praktisch.
Sie können Ihn mit der Taste Q verlassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent | less
<<<check_mk>>>
Version: 2.3.0p16
AgentOS: linux
Hostname: mynewhost
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
LocalDirectory: /usr/lib/check_mk_agent/local
AgentController: cmk-agent-ctl 0.1.0
```
:::
::::

::: paragraph
So ermitteln Sie, ob das Agentenskript und Ihre Plugins und lokalen
Checks richtig installiert sind.
:::

::: paragraph
Sie müssen übrigens nicht unbedingt `root` sein, um den Agenten
aufzurufen. Allerdings werden dann in der Ausgabe einige Informationen
fehlen, zu deren Beschaffung `root`-Rechte erforderlich sind (z.B.
Multipath-Informationen und die Ausgaben von `ethtool`).
:::
::::::::

::::::::::: sect2
### []{#_agentenskript_im_debug_modus .hidden-anchor .sr-only}5.2. Agentenskript im Debug-Modus {#heading__agentenskript_im_debug_modus}

::: paragraph
Damit eventuelle Fehlerausgaben von nicht funktionierenden Plugins oder
Befehlen nicht die eigentlichen Daten „verunreinigen", unterdrückt das
Agentenskript generell den Standardfehlerkanal (STDERR). Sind Sie auf
der Suche nach einem bestimmten Problem, können Sie diesen wieder
aktivieren, indem Sie das Agentenskript in einem speziellen Debug-Modus
aufrufen.
:::

::: paragraph
Vorbereitend sollten Sie prüfen, ob das Agentenskript und der Agent
Controller im [Dump-Modus](#agent_ctl_dump) eine identische Ausgabe
liefern und gegebenenfalls eine identische Umgebung (*environment*)
sicherstellen. Dies kann durch Setzen von Variablen in einem
Plugin/lokalen Check oder der Shell geschehen. Einen Dump der Umgebung
können Sie erstellen, indem Sie die Zeile
:::

:::: listingblock
::: content
``` {.pygments .highlight}
env > /tmp/cmk_agent_environment.txt
```
:::
::::

::: paragraph
zu einer Plugin-Datei hinzufügen und dann den Inhalt der Datei nach
Ausführung durch den Agent Controller ansehen.
:::

::: paragraph
Die Ausgabe der zusätzlichen Debug-Informationen erledigt dann die
Option `-d`. Dabei werden auch sämtliche Shell-Befehle ausgegeben, die
das Skript ausführt. Damit Sie hier mit `less` arbeiten können, müssen
Sie Standardausgabe (STDOUT) und Fehlerkanal mit `2>&1` zusammenfassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent -d 2>&1 | less
```
:::
::::
:::::::::::

::::::::::::::::::::::: sect2
### []{#networkrequirements .hidden-anchor .sr-only}5.3. Netzwerkumgebung für die Registrierung {#heading_networkrequirements}

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
Anfrage auf dem Host mit einem Programm wie `curl` simulieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# curl -v --insecure https://mycmkserver/mysite/check_mk/api/1.0/domain-types/internal/actions/discover-receiver/invoke
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
  (https) oder 80 (http) ab.
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
root@linux# cmk-agent-ctl register --hostname mynewhost \
    --server mycmkserver:8000 --site mysite \
    --user agent_registration --password 'PTEGDYXBFXVGNDPRL'
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

::::::::::::::::: sect2
### []{#agent_ctl_dump .hidden-anchor .sr-only}5.4. Agent Controller im Dump-Modus {#heading_agent_ctl_dump}

::: paragraph
Der Agent Controller stellt ein eigenes Subkommando `dump` bereit, das
die vollständige Agentenausgabe anzeigt, wie sie im Monitoring ankommt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl dump | less
<<<check_mk>>>
Version: 2.3.0p16
AgentOS: linux
Hostname: mynewhost
```
:::
::::

::: paragraph
So können Sie überprüfen, ob die Daten vom Agentenskript beim Agent
Controller angekommen sind. Diese Ausgabe beweist noch nicht, dass der
Agent auch über das Netzwerk erreichbar ist.
:::

::: paragraph
In einigen Fällen sieht die Ausgabe wie folgt aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ERROR [cmk_agent_ctl] Error collecting monitoring data.

Caused by:
    Connection refused (os error 111)
```
:::
::::

::: paragraph
Dies ist der Fall, wenn der Socket des Agenten nicht im Hintergrund
läuft -- beispielsweise unmittelbar nach einem Update. Starten Sie
diesen Hintergrundprozess neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl restart check-mk-agent.socket
```
:::
::::

::: paragraph
Schlägt `cmk-agent-ctl dump` erneut fehl, prüfen Sie, ob und wenn,
welches Programm an Port 6556 lauscht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ss -tulpn | grep 6556
tcp    LISTEN  0   1024    0.0.0.0:6556 0.0.0.0:*  users:(("cmk-agent-ctl",pid=1861810,fd=9))
```
:::
::::

::: paragraph
Ist die Ausgabe leer oder innerhalb der Klammer steht ein anderer Befehl
als `cmk-agent-ctl`, sind die Systemvoraussetzungen für die Nutzung des
Agent Controllers nicht erfüllt. Schließen Sie in diesem Fall die
Einrichtung ab, wie im Artikel [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) beschrieben.
:::
:::::::::::::::::

:::::::::: sect2
### []{#_verbindungstest_von_außen .hidden-anchor .sr-only}5.5. Verbindungstest von außen {#heading__verbindungstest_von_außen}

::: paragraph
Ist im Pull-Modus sichergestellt, dass lokal das Agentenskript und die
mitinstallierten Plugins korrekt ausgeführt werden, können Sie als
Nächstes per `netcat` (oder `nc`) prüfen, ob Port 6556 über die externe
IP-Adresse des Hosts erreichbar ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# echo | nc 10.76.23.189 6556
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
Schlägt der Verbindungstest von außen fehl, liegt dies meist an der
Firewall-Einstellung. Konfigurieren Sie `iptables` oder `nftables` in
diesem Fall so, dass Zugriff auf TCP Port 6556 vom Checkmk-Server aus
möglich ist.
:::

::: paragraph
Falls die Kommunikation zwischen Agent und Checkmk-Server *noch*
unverschlüsselt ist (wie im Legacy-Pull-Modus) oder unverschlüsselt ist
und auch bleibt (wie im [Legacy-Modus](agent_linux_legacy.html)),
erhalten Sie mit diesem Kommando statt der `16` die komplette
unverschlüsselte Agentenausgabe.
:::

::: paragraph
**Hinweis:** Weitere Diagnosemöglichkeiten zur Ausführung auf dem
Checkmk-Server finden Sie im allgemeinen Artikel über die
[Monitoring-Agenten.](wato_monitoringagents.html#diagnostics)
:::
::::::::::

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
Des Weiteren können Sie auf dem Host mit dem Kommando
`systemctl status cmk-agent-ctl-daemon` den Status der letzten
Übertragungen und Übertragungsversuche auslesen. Zeilen wie die folgende
deuten auf Verbindungsprobleme hin:
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
der Datei `/var/lib/cmk-agent/pre_configured_connections.json` die
Variable `keep_existing_connections` auf `true` setzen. Eine dauerhafte
Änderung über ein Update der Agentenpakete hinweg erreichen Sie, indem
Sie im oben genannten Regelsatz [Keep existing connections]{.guihint}
auf [yes]{.guihint} setzen.
:::
:::::

::::: sect2
### []{#howlong .hidden-anchor .sr-only}5.8. Zeitdauer bis Änderungen sichtbar werden {#heading_howlong}

::: paragraph
Bei der Autoregistrierung eines Hosts vergehen typischerweise etwa zwei
Minuten, bis der Host im Monitoring auftaucht.
:::

::: paragraph
Wurde einem Host, der zuerst für den Push-Modus konfiguriert wurde,
nachträglich eine Verbindung im Pull-Modus zu einer anderen Instanz
hinzugefügt, vergehen bis zu fünf Minuten, bis Port 6556 geöffnet wird.
Die sofortige Öffnung des Ports erreichen Sie durch den Neustart des
Dienstes `cmk-agent-ctl-daemon`.
:::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#security .hidden-anchor .sr-only}6. Absicherung {#heading_security}

::::::::::::::::::: sectionbody
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

::::: sect2
### []{#security_tls .hidden-anchor .sr-only}6.2. Transport Layer Security (TLS) {#heading_security_tls}

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
:::::

:::: sect2
### []{#_zugriff_über_ip_adressen_beschränken .hidden-anchor .sr-only}6.3. Zugriff über IP-Adressen beschränken {#heading__zugriff_über_ip_adressen_beschränken}

::: paragraph
Da nur autorisierte Checkmk-Server Daten abrufen können und nicht
berechtigte Server nach einigen Bytes Handshake scheitern, ist die
Gefahr einer *Denial of Service (DoS)* Attacke sehr gering. Aus diesem
Grund ist aktuell keine weitere Zugriffsbeschränkung vorgesehen.
Selbstverständlich können Sie Port 6556 per `iptables` gegen
unberechtigten Zugriff sperren. Eine möglicherweise vorhandene und per
Agentenbäckerei auf Clients übertragene Regel zur Einschränkung des
Zugriffs auf bestimmte IP-Adressen wird vom Agent Controller ignoriert.
:::
::::

:::::::::: sect2
### []{#_eingebaute_verschlüsselung_abschalten .hidden-anchor .sr-only}6.4. Eingebaute Verschlüsselung abschalten {#heading__eingebaute_verschlüsselung_abschalten}

::: paragraph
Insbesondere bei einem Update des Agenten kann es sein, dass die
[eingebaute (symmetrische)
Verschlüsselung](agent_linux_legacy.html#encryption) aktiv ist, die vom
Agentenskript selbst durchgeführt wird. Sind TLS-Verschlüsselung und
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
Im zweiten Schritt benennen Sie auf dem Host des Agenten die
Konfigurationsdatei `/etc/check_mk/encryption.cfg` um.
:::

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
`/etc/check_mk/encryption.cfg` wird automatisch für Sie geändert und mit
in die Agentenpakete eingebaut. Übrig bleibt dann nur der dritte
Schritt, d.h. die Änderung der Regel [Enforce agent data
encryption.]{.guihint}
:::

::: paragraph
Nach dem nächsten automatischen Agenten-Update ist die Verschlüsselung
des Agentenskripts abgeschaltet, aber durch den Agent Controller die
Verschlüsselung garantiert. Beachten Sie, dass nach dem automatischen
Agenten-Update nur noch registrierte Hosts Monitoring-Daten liefern
können.
:::
::::::::::
:::::::::::::::::::
::::::::::::::::::::

::::::::::::::: sect1
## []{#disabled_sections .hidden-anchor .sr-only}7. Sektionen deaktivieren {#heading_disabled_sections}

:::::::::::::: sectionbody
::: paragraph
Die Ausgabe des Checkmk-Agenten ist in Sektionen unterteilt. Jede dieser
Sektionen enthält zusammengehörige Informationen und ist meist einfach
die Ausgabe eines Diagnosebefehls. Sektionen beginnen immer mit einem
Sektions-Header. Dies ist eine Zeile, die in `<<<` und `>>>`
eingeschlossen ist.
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
sections (Linux agent)]{.guihint} einfach eine Regel anlegen, welche
dann von der [Agentenbäckerei](glossar.html#agent_bakery) berücksichtigt
wird.
:::

::::: imageblock
::: content
![Liste der Agentenregeln für den
Linux-Agenten.](../images/agent_linux_disabled_sections.png)
:::

::: title
In den kommerziellen Editionen können Sie Sektionen per Regel
deaktivieren
:::
:::::

::: paragraph
In der Regel finden Sie für jede deaktivierbare Sektion eine eigene
Checkbox. Für jede angewählte Checkbox finden Sie dann --- nachdem der
neu gebackene Agent auf den ausgewählten Hosts installiert wurde --- in
der Konfigurationsdatei der Agentenbäckerei
`/etc/check_mk/exclude_sections.cfg` einen eigenen Eintrag. Würden Sie
in der Regel beispielsweise die beiden Optionen `Running processes` und
`Systemd services` auswählen, sähe die passende Konfigurationsdatei wie
folgt aus:
:::

::::: listingblock
::: title
/etc/check_mk/exclude_sections.cfg
:::

::: content
``` {.pygments .highlight}
MK_SKIP_PS=yes
MK_SKIP_SYSTEMD=yes
```
:::
:::::

::: paragraph
Nutzer von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** können die oben genannte Datei
`/etc/check_mk/exclude_sections.cfg` manuell anlegen und dort die
Sektionen eintragen, die deaktiviert werden sollen. Alle deaktivierbaren
Sektionen sind in der Datei
`~/share/check_mk/agents/cfg_examples/exclude_sections.cfg` aufgelistet.
:::
::::::::::::::
:::::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#plugins .hidden-anchor .sr-only}8. Agent um Plugins erweitern {#heading_plugins}

::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_was_sind_agentenplugins .hidden-anchor .sr-only}8.1. Was sind Agentenplugins? {#heading__was_sind_agentenplugins}

::: paragraph
Das Agentenskript `/usr/bin/check_mk_agent` enthält eine ganze Reihe von
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
- Das Plugin ist in einer anderen Programmiersprache als Shell
  geschrieben und kann daher nicht inline realisiert werden (Beispiel:
  `mk_logwatch`).

- Das Plugin benötigt sowieso eine Konfiguration, ohne die es nicht
  funktionieren würde (Beispiel: `mk_oracle`).

- Das Plugin ist so speziell, dass es von den meisten Anwendern nicht
  benötigt wird (Beispiel: `plesk_domains`).
:::
:::::::

:::::::::::: sect2
### []{#manualplugins .hidden-anchor .sr-only}8.2. Manuelle Installation {#heading_manualplugins}

::: paragraph
Die mitgelieferten Plugins für Linux und Unix finden Sie alle auf dem
Checkmk-Server unter `~/share/check_mk/agents/plugins`.
:::

::: paragraph
Auch über die Download-Seite der Agenten im Setup-Menü (wie im Kapitel
[Installation](#download_gui) beschrieben) sind diese im Kasten
[Plugins]{.guihint} verfügbar:
:::

::::: imageblock
::: content
![Download-Seite mit den
Agentenplugins.](../images/agent_linux_files_agent_plugins.png)
:::

::: title
Der Anfang der langen Liste verfügbarer Agentenplugins
:::
:::::

::: paragraph
Zu allen von uns mitgelieferten Agentenplugins existieren die passenden
Check-Plugins, welche deren Daten auswerten und Services erzeugen
können. Diese sind bereits mitinstalliert, so dass neu gefundene
Services sofort erkannt und konfiguriert werden können.
:::

::: paragraph
**Hinweis:** Bevor Sie ein Plugin auf dem Host installieren, werfen Sie
einen Blick in die entsprechende Datei. Oft finden Sie dort wichtige
Hinweise zur korrekten Verwendung des Plugins.
:::

::: paragraph
Die eigentliche Installation ist dann einfach: Kopieren Sie die Datei
nach `/usr/lib/check_mk_agent/plugins`. Achten Sie dabei darauf, dass
diese ausführbar ist. Falls nicht, verwenden Sie ein `chmod 755`. Der
Agent wird das Plugin sonst nicht ausführen. Insbesondere, wenn Sie die
Dateien nicht per `scp` übertragen sondern per HTTP von der
Download-Seite holen, geht die Ausführungsberechtigung verloren.
:::

::: paragraph
Sobald das Plugin ausführbar ist und im richtigen Verzeichnis liegt,
wird es vom Agenten automatisch aufgerufen und es entsteht eine neue
Sektion in der Agentenausgabe. Diese trägt üblicherweise den gleichen
Namen wie das Plugin. Komplexe Plugins (z.B. `mk_oracle`) erzeugen sogar
eine ganze Reihe an neuen Sektionen.
:::
::::::::::::

::::: sect2
### []{#pluginconfig .hidden-anchor .sr-only}8.3. Konfiguration {#heading_pluginconfig}

::: paragraph
Manche Plugins brauchen eine Konfigurationsdatei in `/etc/check_mk/`,
damit sie funktionieren können. Bei anderen ist eine Konfiguration
optional und ermöglicht besondere Features oder Anpassungen. Wieder
andere funktionieren einfach so. Sie haben verschiedene Quellen, um an
Informationen zu kommen:
:::

::: ulist
- Die Dokumentation der zugehörigen Check-Plugins in Ihrer
  Checkmk-Instanz, welche Sie über [Setup \> Services \> Catalog of
  check plugins]{.guihint} erreichen.

- Kommentare im Plugin selbst (oft sehr hilfreich!).

- Einen passenden Artikel in diesem Handbuch (z.B. über das Überwachen
  von [Oracle](monitoring_oracle.html))
:::
:::::

::::::::: sect2
### []{#async_plugins .hidden-anchor .sr-only}8.4. Asynchrone Ausführung {#heading_async_plugins}

::: paragraph
Ebenso wie bei [MRPE](#mrpe) können Sie auch Plugins asynchron ausführen
lassen. Das ist sehr nützlich, wenn die Plugins eine lange Laufzeit
haben und die gewonnenen Statusdaten ohnehin nicht jede Minute neu
erzeugt werden brauchen.
:::

::: paragraph
Die asynchrone Ausführung wird nicht über eine Datei konfiguriert.
Stattdessen erzeugen Sie unter `/usr/lib/check_mk_agent/plugins` ein
Unterverzeichnis, dessen Name eine Zahl ist: eine Anzahl von Sekunden.
Plugins in diesem Verzeichnis werden nicht nur asynchron ausgeführt,
sondern gleichzeitig geben Sie mit der Sekundenzahl eine
Mindestwartezeit vor, bevor das Plugin erneut ausgeführt werden soll.
Wird der Agent vor Ablauf der Zeit erneut abgefragt, verwendet er
zwischengespeicherte Daten von der letzten Ausführung des Plugins. Damit
können Sie ein größeres Intervall für das Plugin konfigurieren, als die
typische eine Minute.
:::

::: paragraph
Folgendes Beispiel zeigt, wie das Plugin `my_foo_plugin` von synchroner
Ausführung auf eine asynchrone Ausführung mit einem Intervall von 5
Minuten (oder 300 Sekunden) umgestellt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cd /usr/lib/check_mk_agent/plugins
root@linux# mkdir 300
root@linux# mv my_foo_plugin 300
```
:::
::::

::: paragraph
**Hinweis:** Beachten Sie, dass einige Plugins bereits von sich aus eine
asynchrone Ausführung umsetzen. Dazu gehört `mk_oracle`. Installieren
Sie solche Plugins direkt nach `/usr/lib/check_mk_agent/plugins`.
:::
:::::::::

:::::::: sect2
### []{#install_plugins_using_bakery .hidden-anchor .sr-only}8.5. Installation über die Agentenbäckerei {#heading_install_plugins_using_bakery}

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

::::::: sect2
### []{#_manuelle_ausführung .hidden-anchor .sr-only}8.6. Manuelle Ausführung {#heading__manuelle_ausführung}

::: paragraph
Da Agentenplugins ausführbare Programme sind, können Sie diese zu
Test-und Diagnosezwecken auch von Hand ausführen. Es gibt allerdings
Plugins, welche bestimmte vom Agenten gesetzte Umgebungsvariablen
brauchen, um z.B. ihre Konfigurationsdatei zu finden. Setzen Sie diese
vor der Ausführung von Hand:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# export MK_LIBDIR=/usr/lib/check_mk_agent
root@linux# export MK_CONFDIR=/etc/check_mk
root@linux# export MK_VARDIR=/var/lib/check_mk_agent
root@linux# /usr/lib/check_mk_agent/plugins/mk_foobar
<<<foobar>>>
FOO BAR BLA BLUBB 17 47 11
```
:::
::::

::: paragraph
Einige Plugins kennen auch spezielle Aufrufoptionen zum Debuggen. Werfen
Sie einfach einen Blick in die Plugin-Datei.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#e2e_monitoring .hidden-anchor .sr-only}9. Einbinden von Legacy Nagios Check-Plugins {#heading_e2e_monitoring}

:::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::: sect2
### []{#mrpe .hidden-anchor .sr-only}9.1. Plugins über MRPE ausführen {#heading_mrpe}

::: paragraph
Es gibt zwei gute Gründe, Nagios-Plugins auch unter Checkmk zu nutzen.
Wenn Sie Ihr Monitoring von einer Nagios-basierten Lösung auf Checkmk
migriert haben, können Sie ältere Check-Plugins, zu denen es noch kein
Checkmk-Pendant gibt, zunächst weiternutzen. In vielen Fällen sind das
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
Der MRPE ist im Agenten fest eingebaut und wird mit einer einfachen
Textdatei konfiguriert, welche Sie als `/etc/check_mk/mrpe.cfg` selbst
anlegen. Dort geben Sie pro Zeile einen Plugin-Aufruf an --- zusammen
mit dem Namen, den Checkmk für den Service verwenden soll, den es dafür
automatisch erzeugt. Hier ist ein Beispiel:
:::

::::: listingblock
::: title
/etc/check_mk/mrpe.cfg
:::

::: content
``` {.pygments .highlight}
Foo_Application /usr/local/bin/check_foo -w 60 -c 80
Bar_Extender /usr/local/bin/check_bar -s -X -w 4:5
```
:::
:::::

::: paragraph
**Hinweis:** Die Nagios-Plugins dürfen nicht im Verzeichnis
`/usr/lib/check_mk_agent/plugins` abgelegt werden. Dieses Verzeichnis
ist den [Agentenplugins](#plugins) vorbehalten. Abgesehen von diesem
Verzeichnis steht Ihnen die Wahl frei, solange der Agent die Plugins
dort finden und ausführen kann.
:::

::: paragraph
Wenn Sie jetzt den Agenten lokal laufen lassen, finden Sie pro Plugin
eine neue Sektion mit dem Titel `<<<mrpe>>>`, welche Name, Exitcode und
Ausgabe des Plugins enthält. Das können Sie mit folgendem praktischen
`grep`-Befehl überprüfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent | grep -A1 '^...mrpe'
<<<mrpe>>>
(check_foo) Foo_Application 0 OK - Foo server up and running
<<<mrpe>>>
(check_bar) Bar_Extender 1 WARN - Bar extender overload 6.012|bar_load=6.012
```
:::
::::

::: paragraph
Die `0` bzw. `1` in der Ausgabe stehen für die Exitcodes der Plugins und
folgen dem klassischen Schema: `0` = [OK]{.state0}, `1` =
[WARN]{.state1}, `2` = [CRIT]{.state2} und `3` = [UNKNOWN]{.state3}.
:::

::: paragraph
Den Rest macht jetzt Checkmk automatisch. Sobald Sie die
Service-Erkennung für den Host aufrufen, werden die beiden neuen
Services als [verfügbar](wato_services.html#available) angezeigt. Das
sieht dann so aus:
:::

::::: imageblock
::: content
![Liste der erkannten Services für die per MRPE eingerichteten
Plugins.](../images/agent_linux_mrpe_checks.png)
:::

::: title
Für die beiden MRPE Plugins wird je ein Service erkannt
:::
:::::

::: paragraph
Übrigens: Aufgrund der Syntax der Datei darf der Name keine Leerzeichen
enthalten. Sie können aber mithilfe der gleichen Syntax wie in URLs ein
Space durch `%20` ersetzen (ASCII-Code 32 für Space ist Hexadezimal 20):
:::

::::: listingblock
::: title
/etc/check_mk/mrpe.cfg
:::

::: content
``` {.pygments .highlight}
Foo%20Application /usr/local/bin/check_foo -w 60 -c 80
Bar%20Extender /usr/local/bin/check_bar -s -X -w 4:5
```
:::
:::::
:::::::::::::::::::::::

::::::::::: sect2
### []{#_asynchrone_ausführung .hidden-anchor .sr-only}9.2. Asynchrone Ausführung {#heading__asynchrone_ausführung}

::: paragraph
Beachten Sie, dass alle Plugins, die Sie in `mrpe.cfg` aufführen, der
Reihe nach synchron ausgeführt werden. Die Plugins sollten daher keine
allzu große Ausführungszeit haben. Wenn ein Plugin hängt, verzögert sich
die Ausführung aller weiteren. Das kann dazu führen, dass das komplette
Abfragen des Agenten durch Checkmk-in einen Timeout läuft und der Host
nicht mehr zuverlässig überwacht werden kann.
:::

::: paragraph
Wenn Sie wirklich länger laufende Plugins benötigen, sollten Sie diese
auf asynchrone Ausführung umstellen und das Problem damit vermeiden.
Dabei legen Sie eine Zeit in Sekunden fest, die ein berechnetes Ergebnis
Gültigkeit haben soll, z.B. `300` für fünf Minuten. Setzen Sie dazu in
`mrpe.cfg` nach dem Servicenamen den Ausdruck `(interval=300)`:
:::

::::: listingblock
::: title
/etc/check_mk/mrpe.cfg
:::

::: content
``` {.pygments .highlight}
Foo_Application (interval=300) /usr/local/bin/check_foo -w 60 -c 80
Bar_Extender /usr/local/bin/check_bar -s -X -w 4:5
```
:::
:::::

::: paragraph
Das hat mehrere Auswirkungen:
:::

::: ulist
- Das Plugin wird in einem Hintergrundprozess ausgeführt und bremst
  nicht mehr die Ausführung des Agenten.

- Weil der Agent die Ausführung nicht abwartet, wird das Ergebnis erst
  beim *nächsten* Aufruf des Agenten geliefert.

- Frühestens nach 300 Sekunden wird das Plugin neu ausgeführt. Bis dahin
  wird das alte Ergebnis wiederverwendet.
:::

::: paragraph
Damit können Sie also Tests, die etwas mehr Rechenzeit benötigen, auch
in größeren Intervallen ausführen, ohne dass Sie dazu am Checkmk-Server
etwas konfigurieren müssen.
:::
:::::::::::

::::::::::: sect2
### []{#_mrpe_mit_der_agentenbäckerei .hidden-anchor .sr-only}9.3. MRPE mit der Agentenbäckerei {#heading__mrpe_mit_der_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Nutzer der
kommerziellen Editionen können MRPE auch mit der
[Agentenbäckerei](glossar.html#agent_bakery) konfigurieren. Zuständig
dafür ist der Regelsatz [Setup \> Agents \> Windows, Linux Solaris, AIX
\> Agent Rules \> Generic Options \> Execute MRPE checks]{.guihint}.
Dort können Sie die gleichen Dinge wie oben beschrieben konfigurieren.
Die Datei `mrpe.cfg` wird dann von der Bäckerei automatisch generiert.
:::

::::: imageblock
::: content
![Regel zur MRPE-Konfiguration in der
Agentenbäckerei.](../images/agent_linux_mrpe_rule.png)
:::

::: title
MRPEs können in den kommerziellen Editionen bequem per Regel
konfiguriert werden
:::
:::::

:::::: sect3
#### []{#_backen_der_plugins .hidden-anchor .sr-only}Backen der Plugins {#heading__backen_der_plugins}

::: paragraph
Auch die Check-Plugins selbst können Sie mit dem Paket ausliefern
lassen. Damit ist der Agent dann komplett und braucht keine manuelle
Installation von weiteren Dateien. Das Ganze geht so:
:::

::: {.olist .arabic}
1.  Erzeugen Sie auf dem Checkmk-Server das Verzeichnis
    `local/share/check_mk/agents/custom`.

2.  Erzeugen Sie dort ein Unterverzeichnis --- z.B. `my_mrpe_plugins`.

3.  Erzeugen Sie wiederum darin das Unterverzeichnis `bin`.

4.  Kopieren Sie Ihre Plugins in den `bin`-Ordner.

5.  Legen Sie eine Regel in [Setup \> Agents \> Windows, Linux, Solaris,
    AIX \> Agent rules \> Generic Options \> Deploy custom files with
    agent]{.guihint} an.

6.  Wählen Sie `my_mrpe_plugins` aus, speichern Sie und backen Sie!
:::

::: paragraph
Die Check-Plugins werden jetzt in das Standard-`bin`-Verzeichnis Ihres
Agenten installiert. Per Default ist das `/usr/bin`. Bei der
Konfiguration der MRPE-Checks verwenden Sie dann also
`/usr/bin/check_foo` anstelle von `/usr/local/bin/check_foo`.
:::
::::::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::: sect1
## []{#hw_monitoring .hidden-anchor .sr-only}10. Hardware überwachen {#heading_hw_monitoring}

:::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Zu einer möglichst vollständigen Überwachung eines Linux-Servers gehört
natürlich auch die Hardware. Die Überwachung geschieht teils direkt mit
dem Checkmk-Agenten, teils auch über spezielle [Plugins](#plugins).
Außerdem gibt es noch Fälle, in denen man per SNMP oder sogar über ein
separates Managementboard eine Überwachung umsetzen kann.
:::

:::::::::: sect2
### []{#_überwachung_der_smart_werte .hidden-anchor .sr-only}10.1. Überwachung der SMART-Werte {#heading__überwachung_der_smart_werte}

::: paragraph
Moderne Festplatten verfügen fast immer über *S.M.A.R.T.*
(Self-Monitoring, Analysis and Reporting Technology). Dieses System
zeichnet kontinuierlich Daten zum Zustand der HDD oder SSD auf und
Checkmk kann mit dem Plugin `smart` diese Werte abrufen und die
wichtigsten davon auswerten. Damit das Plugin nach der Installation auch
funktioniert, müssen folgende Voraussetzungen erfüllt sein:
:::

::: ulist
- Das Paket `smartmontools` muss installiert sein. Sie können es auf
  allen modernen Distributionen über den jeweiligen Paketmanager
  installieren.

- Falls die Festplatten an einen RAID-Controller angeschlossen sind und
  dieser Zugriff auf die SMART-Werte erlaubt, muss das jeweilige Tool
  dazu installiert sein. Unterstützt werden `tw_cli` (3ware) und
  `megacli` (LSI).
:::

::: paragraph
Sind diese Voraussetzungen erfüllt und ist das Plugin installiert,
werden die Daten automatisch ausgelesen und der Ausgabe des Agenten
angehängt. In Checkmk können Sie die [neuen
Services](wato_services.html#available) dann auch direkt aktivieren:
:::

::::: imageblock
::: content
![Liste gefundener SMART-Services in der
Service-Erkennung.](../images/agent_linux_smart_stats.png)
:::

::: title
Von der Service-Erkennung gefundene SMART-Services
:::
:::::

::: paragraph
Sollte --- wie im Screenshot zu sehen --- gelegentlich `cmd_timeout`
auftreten, stellen Sie das Plugin auf asynchrone Ausführung im Abstand
einiger Minuten um.
:::
::::::::::

::::::::::: sect2
### []{#_überwachung_mit_hilfe_von_ipmi .hidden-anchor .sr-only}10.2. Überwachung mit Hilfe von IPMI {#heading__überwachung_mit_hilfe_von_ipmi}

::: paragraph
IPMI (Intelligent Platform Management Interface) ist eine Schnittstelle
zum Hardware-Management, welche auch die Überwachung der Hardware
ermöglicht. Checkmk nutzt dafür `freeipmi`, um direkt und ohne Netzwerk
auf die Hardware zuzugreifen. `freeipmi` wird aus den Paketquellen
installiert und ist danach sofort einsatzbereit, so dass die Daten schon
beim nächsten Aufruf von Checkmk übermittelt werden.
:::

::: paragraph
Falls `freeipmi` nicht verfügbar ist, oder andere Gründe gegen eine
Installation sprechen, kann auch `ipmitool` verwendet werden. `ipmitool`
ist oft bereits auf dem System vorhanden und muss lediglich mit einem
IPMI Gerätetreiber versorgt werden, wie ihn z.B. das Paket `openipmi`
zur Verfügung stellt. Auch hier müssen Sie danach nichts weiter tun. Die
Daten werden von Checkmk automatisch erfasst.
:::

::: paragraph
Zur Fehlerdiagnose können Sie die Tools auch händisch in einer Shell des
Hosts ausführen. Haben Sie das Paket `freeipmi` installiert, können Sie
die Funktion hiermit kontrollieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ipmi-sensors Temperature
32 Temperature_Ambient 20.00_C_(1.00/42.00) [OK]
96 Temperature_Systemboard 23.00_C_(1.00/65.00) [OK]
160 Temperature_CPU_1 31.00_C_(1.00/90.00) [OK]
224 Temperature_CPU_2 NA(1.00/78.00) [Unknown]
288 Temperature_DIMM-1A 54.00_C_(NA/115.00) [OK]
352 Temperature_DIMM-1B 56.00_C_(NA/115.00) [OK]
416 Temperature_DIMM-2A NA(NA/115.00) [Unknown]
480 Temperature_DIMM-2B NA(NA/115.00) [Unknown]
```
:::
::::

::: paragraph
Wenn `ipmitool` installiert wurde, können Sie die Ausgabe der Daten mit
folgendem Befehl prüfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ipmitool sensor list
UID_Light 0.000 unspecified ok na na 0.000 na na na
Int._Health_LED 0.000 unspecified ok na na 0.000 na na na
Ext._Health_LED 0.000 unspecified ok na na 0.000 na na na
Power_Supply_1 0.000 unspecified nc na na 0.000 na na na
Fan_Block_1 34.888 unspecified nc na na 75.264 na na na
Fan_Block_2 29.792 unspecified nc na na 75.264 na na na
Temp_1 39.000 degrees_C ok na na -64.000 na na na
Temp_2 16.000 degrees_C ok na na -64.000 na na na
Power_Meter 180.000 Watts cr na na 384.00
```
:::
::::
:::::::::::

:::::: sect2
### []{#_herstellerspezifische_tools .hidden-anchor .sr-only}10.3. Herstellerspezifische Tools {#heading__herstellerspezifische_tools}

::: paragraph
Viele große Server-Hersteller bieten auch eigene Tools an, um die
Hardware-Informationen auszulesen und über SNMP bereitzustellen. Es
gelten dabei die folgenden Voraussetzungen, um diese Daten abrufen und
Checkmk bereitstellen zu können:
:::

::: ulist
- Auf dem Linux-Host ist ein SNMP-Server eingerichtet.

- Das Tool des Herstellers ist installiert (z.B. Dells *OpenManage* oder
  Supermicros *SuperDoctor*).

- Der Host ist in Checkmk für die Überwachung per SNMP **zusätzlich**
  zum Checkmk-Agenten konfiguriert. Im Artikel zur [Überwachung mit
  SNMP](snmp.html#snmp_cmk_agent) erfahren Sie, wie das geht.
:::

::: paragraph
Die dadurch unterstützten neuen Services für die Hardware-Überwachung
werden dann automatisch erkannt. Es werden keine weiteren Plugins
benötigt.
:::
::::::

::::::::: sect2
### []{#_zusätzliche_überwachung_über_das_managementboard .hidden-anchor .sr-only}10.4. Zusätzliche Überwachung über das Managementboard {#heading__zusätzliche_überwachung_über_das_managementboard}

::: paragraph
Man kann zu jedem Host ein Managementboard konfigurieren und zusätzliche
Daten per SNMP holen. Die dadurch erkannten Services werden dann
ebenfalls dem Host zugeordnet.
:::

::: paragraph
Die Einrichtung des Managementboards ist dabei sehr einfach. Geben Sie
in den Eigenschaften des Hosts lediglich das Protokoll, die IP-Adresse
und die Zugangsdaten für SNMP an und speichern Sie die neuen
Einstellungen ab:
:::

::::: imageblock
::: content
![Die Konfiguration des Managementboards für SNMP in den Eigenschaften
des Hosts.](../images/agent_linux_snmp_management_board.png)
:::

::: title
In den Eigenschaften des Hosts im Setup wird das Managementboard für
SNMP konfiguriert
:::
:::::

::: paragraph
In der Service-Erkennung werden die neu erkannten Services dann wie
gewohnt aktiviert.
:::
:::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#uninstall .hidden-anchor .sr-only}11. Deinstallation {#heading_uninstall}

::::::::::::::::: sectionbody
::: paragraph
Wie die [Installation](#install) erfolgt auch die Deinstallation des
Agenten mit dem Paketmanager des Betriebssystems. Geben Sie hier den
Namen des installierten Pakets an, nicht den Dateinamen der
ursprünglichen RPM/DEB-Datei.
:::

::: paragraph
So finden Sie heraus, welches DEB-Paket installiert ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg -l | grep check-mk-agent
ii  check-mk-agent          2.3.0p16-1          all          Checkmk Agent for Linux
```
:::
::::

::: paragraph
Die Deinstallation des DEB-Pakets erfolgt dann mit `dpkg --purge`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg --purge check-mk-agent
(Reading database ... 739951 files and directories currently installed.)
Removing check-mk-agent (2.3.0p16-1) ...
Removing systemd units: check-mk-agent.socket, check-mk-agent-async.service, cmk-agent-ctl-daemon.service, check-mk-agent@.service
Deactivating systemd unit 'check-mk-agent.socket'...
Deactivating systemd unit 'check-mk-agent-async.service'...
Deactivating systemd unit 'cmk-agent-ctl-daemon.service'...
Reloading xinetd
Purging configuration files for check-mk-agent (2.3.0p16-1) ...
```
:::
::::

::: paragraph
So finden Sie heraus, welches RPM-Paket installiert ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -qa | grep check-mk
```
:::
::::

::: paragraph
Die Deinstallation des RPM-Pakets erfolgt unter `root` mit dem Befehl
`rpm -e`.
:::

::::: sect2
### []{#reenable_legacy_pull .hidden-anchor .sr-only}11.1. Reaktivierung des Legacy-Pull-Modus {#heading_reenable_legacy_pull}

::: paragraph
Bei der Deinstallation des Agenten bleibt der vom Installationsskript
angelegte Nutzer `cmk-agent` erhalten. Er dient dem Post-Install-Skript
als Indikator dafür, dass der Agent bereits auf diesem System
installiert war. Ist dies der Fall, wird bei einer späteren
Neuinstallation kein Legacy-Pull-Modus aktiviert. Dies führt dazu, dass
nach Ausführung von `cmk-agent-ctl delete-all` und späterer
Neuinstallation des Agenten gar keine Verbindung auf Port 6556 möglich
ist.
:::

::: paragraph
Sollte es erwünscht sein, wieder den unverschlüsselten Legacy-Pull-Modus
zu aktivieren, z.B. um die Kommunikation einer [2.0.0]{.new} Instanz mit
einem [2.2.0]{.new} Agenten zu ermöglichen, müssen Sie diesen Modus
[explizit aktivieren.](#deregister)
:::
:::::
:::::::::::::::::
::::::::::::::::::

:::::: sect1
## []{#files .hidden-anchor .sr-only}12. Dateien und Verzeichnisse {#heading_files}

::::: sectionbody
::: sect2
### []{#_pfade_auf_dem_überwachten_host .hidden-anchor .sr-only}12.1. Pfade auf dem überwachten Host {#heading__pfade_auf_dem_überwachten_host}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `/usr/bin/`                   | Installationsverzeichnis für das     |
|                               | Agentenskript `check_mk_agent` und   |
|                               | des Agent Controllers                |
|                               | `cmk-agent-ctl` auf dem Zielsystem.  |
+-------------------------------+--------------------------------------+
| `/usr/lib/check_mk_agent`     | Basisverzeichnis für Erweiterungen   |
|                               | des Agenten.                         |
+-------------------------------+--------------------------------------+
| `/us                          | Verzeichnis für Plugins, welche      |
| r/lib/check_mk_agent/plugins` | automatisch vom Agenten ausgeführt   |
|                               | werden sollen und dessen Ausgabe um  |
|                               | zusätzliche Überwachungsdaten        |
|                               | erweitern. Plugins können in jeder   |
|                               | verfügbaren Programmiersprache       |
|                               | geschrieben werden.                  |
+-------------------------------+--------------------------------------+
| `/                            | Verzeichnis für eigene [lokale       |
| usr/lib/check_mk_agent/local` | Checks](localchecks.html).           |
+-------------------------------+--------------------------------------+
| `/var/lib/check_mk_agent`     | Basisverzeichnis für Daten des       |
|                               | Agenten.                             |
+-------------------------------+--------------------------------------+
| `/                            | Hier werden Cache-Daten einzelner    |
| var/lib/check_mk_agent/cache` | Sektionen abgelegt und dem Agenten,  |
|                               | solange die Cache-Daten gültig sind, |
|                               | bei jeder Ausführung wieder          |
|                               | angehängt.                           |
+-------------------------------+--------------------------------------+
| `/var/lib/check_mk_agent/job` | Verzeichnis für überwachte Jobs.     |
|                               | Diese werden der Agentenausgabe bei  |
|                               | jeder Ausführung angehängt.          |
+-------------------------------+--------------------------------------+
| `/                            | Enthält Daten, die z.B. von          |
| var/lib/check_mk_agent/spool` | Log-Dateien erstellt werden und eine |
|                               | eigene Sektion beinhalten. Diese     |
|                               | werden ebenfalls der Agentenausgabe  |
|                               | angehängt. Mehr dazu erfahren Sie im |
|                               | Artikel [Das                         |
|                               | Spool                                |
|                               | -Verzeichnis.](spool_directory.html) |
+-------------------------------+--------------------------------------+
| `/var/lib/cmk-agent           | Enthält eine Liste der mit dem Agent |
| /registered_connections.json` | Controller registrierten             |
|                               | Verbindungen.                        |
+-------------------------------+--------------------------------------+
| `/var/lib/cmk-agent/pre       | Enthält eine vorkonfigurierte und    |
| _configured_connections.json` | per Agentenbäckerei in das           |
|                               | Agentenpaket integrierte Verbindung  |
|                               | zu einer Instanz für die             |
|                               | [Autoregi                            |
|                               | strierung.](hosts_autoregister.html) |
+-------------------------------+--------------------------------------+
| `/etc/check_mk`               | Ablage von Konfigurationsdateien für |
|                               | den Agenten.                         |
+-------------------------------+--------------------------------------+
| `/etc/check_mk/mrpe.cfg`      | Konfigurationsdatei für              |
|                               | [MRPE](#mrpe) --- für die Ausführung |
|                               | von Legacy Nagios-kompatiblen        |
|                               | Check-Plugins.                       |
+-------------------------------+--------------------------------------+
| `                             | Konfiguration für die [eingebaute    |
| /etc/check_mk/encryption.cfg` | Verschlüsselung]                     |
|                               | (agent_linux_legacy.html#encryption) |
|                               | der Agentendaten.                    |
+-------------------------------+--------------------------------------+
| `/etc/c                       | Konfigurationsdatei für die          |
| heck_mk/exclude_sections.cfg` | [Deaktivierung bestimmter            |
|                               | Sektionen](#disabled_sections) des   |
|                               | Agenten.                             |
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
| `                             | Beispielhafte Konfigurationsdatei    |
| ~/share/check_mk/agents/cfg_e | für das Deaktivieren von Sektionen.  |
| xamples/exclude_sections.cfg` |                                      |
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
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
