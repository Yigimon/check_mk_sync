:::: {#header}
# Automatische Agenten-Updates

::: details
[Last modified on 05-Sep-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/agent_deployment.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Monitoring-Agenten](wato_monitoringagents.html) [Updates und
Upgrades](update.html) [Checkmk auf der
Kommandozeile](cmk_commandline.html)
:::
::::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen können ihre Agenten auf Linux, Windows und Solaris automatisch
aktualisieren. Damit können Sie nicht nur im Falle von neuen
Checkmk-Versionen die Agenten leicht aktualisieren, auch eine geänderte
Konfiguration der Agenten kann so ausgebracht werden. Dabei können Sie
den Vorteil der [Agentenbäckerei](wato_monitoringagents.html#bakery)
(*Agent Bakery*) nutzen, um Hosts individuell zu konfigurieren.
:::
:::::::
:::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup_automatic_updates .hidden-anchor .sr-only}1. Automatische Updates einrichten {#heading_setup_automatic_updates}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die automatische Verteilung von Agenten ist standardmäßig global
deaktiviert. Bevor Sie sich also um die Konfiguration selbst kümmern,
aktivieren Sie die Option [Activation of automatic agent
updates]{.guihint} unter [Setup \> General \> Global settings \>
Automatic agent updates:]{.guihint}
:::

:::: imageblock
::: content
![agent deployment activation of automatic agent
updates](../images/agent_deployment_activation_of_automatic_agent_updates.png)
:::
::::

::: paragraph
Gehen Sie zum Einrichten der Updates nach folgenden Schritten vor:
Öffnen Sie zuerst [Setup \> Agents \> Windows, Linux, Solaris,
AIX]{.guihint} und wählen Sie dort [Agents \> Automatic
updates]{.guihint}.
:::

:::: imageblock
::: content
![agent deployment automatic agent
updates](../images/agent_deployment_automatic_agent_updates.png)
:::
::::

::: paragraph
Unter [Prerequisites]{.guihint} sehen Sie eine Liste von
Voraussetzungen, die erfüllt sein müssen, damit die automatischen
Updates funktionieren. Diese können Sie einfach der Reihe nach abhaken.
Vergessen Sie nicht, dass Sie für jeden dieser Punkte über [Help \> Show
inline help]{.guihint} weitere Informationen erhalten können. Ein Klick
auf [![icon edit](../images/icons/icon_edit.png)]{.image-inline} bringt
Sie direkt zu der Einstellung, die Sie konfigurieren müssen. Im
Einzelnen müssen die in den folgenden fünf Kapiteln beschriebenen
Einstellungen vorgenommen und über den [Master switch]{.guihint}
aktiviert werden.
:::

::::::: sect2
### []{#create_signature_key .hidden-anchor .sr-only}1.1. Signaturschlüssel erstellen {#heading_create_signature_key}

::: paragraph
Das System ist so aufgebaut, dass die Agenten per HTTP oder HTTPS von
ihrem zentralen Monitoring-Server Updates herunterladen. Da Agenten
ausführbaren Code enthalten, ist es besonders wichtig, dass Sie
sicherstellen, dass die Agenten nicht von einem Angreifer verfälscht
werden können. Zu diesem Zweck werden Signaturschlüssel verwendet. Diese
bestehen aus einem Paar von öffentlichem und privatem Schlüssel
(Public-Key-Verfahren).
:::

::: paragraph
Sie können beliebig viele Signaturschlüssel anlegen. Diese werden
jeweils mit einer Passphrase geschützt, welche Sie später bei jedem
Signieren eingeben müssen. Damit wird verhindert, dass z.B. ein
Angreifer, der Zugriff auf eine Datensicherung des Monitoring-Servers
erlangt, Agenten signieren kann.
:::

::: paragraph
Erzeugen Sie hier einen Signaturschlüssel und merken Sie sich die
Passphrase.
:::

::: paragraph
**Wichtig:** Der Signaturschlüssel kann später weder geändert noch
wiederhergestellt werden. Geht der Schlüssel verloren, so kann dies
bedeuten, dass alle Agenten einmal manuell aktualisiert werden müssen.
:::
:::::::

::::::::::::::::::::::::::::::::::::::: sect2
### []{#configure_update_plugin .hidden-anchor .sr-only}1.2. Konfiguration des Update-Plugins {#heading_configure_update_plugin}

::: paragraph
Das eigentliche Update wird durch ein Agentenplugin mit dem Namen
`cmk-update-agent` ausgeführt. Dieses wird vom Agenten in einem
einstellbaren Zyklus aufgerufen (z.B. einmal pro Stunde). Es fragt dann
den Deployment-Server (Ihr zentrales Monitoring-System) jeweils an, ob
ein neues Paket für diesen Host vorliegt und führt dann das Update
durch.
:::

::: paragraph
Das Plugin muss natürlich im Agenten vorhanden und korrekt konfiguriert
sein. Dazu erweitern Sie die Agenten um dieses Plugin mit dem Regelsatz
[Agent updater (Linux, Windows, Solaris)]{.guihint}. Den Regelsatz
finden Sie z.B. schnell auf der Seite [Automatic agent
updates]{.guihint} im Menü [Related \> Agent updater ruleset.]{.guihint}
:::

::: paragraph
Beachten Sie, dass der Regelsatz hier das Prinzip [\"Erste Regel pro
Parameter gewinnt\"](wato_rules.html#matching_type) verwendet. Sie haben
dadurch die Möglichkeit grundlegende Einstellungen allgemein zu
definieren, sodass diese nicht in den spezielleren Regeln immer wieder
neu gesetzt werden müssen. Zusätzlich bietet auch hier die
[Inline-Hilfe](user_interface.html#inline_help) weitere Informationen zu
jedem einzelnen Punkt, sobald Sie diesen aktivieren.
:::

:::: imageblock
::: content
![agent deployment agent updater
empty](../images/agent_deployment_agent_updater_empty.png)
:::
::::

::: paragraph
Nachfolgend noch ein paar Erläuterungen zu den einzelnen Punkten.
:::

:::: sect3
#### []{#activation .hidden-anchor .sr-only}Aktivierung (Activation) {#heading_activation}

::: paragraph
Diese Einstellung muss aktiviert werden ([Deploy plugin ...​]{.guihint}),
damit das Plugin zum Agenten hinzugefügt wird. Hier kann z.B. die
Regelvererbung genutzt werden, um auf oberer Ordnerebene eine
Grundeinstellung zu setzen und diese für einzelne Hosts und Ordner zu
überschreiben.
:::
::::

::::::::::::: sect3
#### []{#update_server_information .hidden-anchor .sr-only}Aktualisiere Server Informationen (Update server information) {#heading_update_server_information}

::: paragraph
Optional lassen sich hier bereits zur Konfiguration Daten für die
Verbindung des Agent Updaters zum Checkmk-Server angeben. Werden die
zugehörigen Einträge nicht konfiguriert, müssen die Informationen später
beim Registrieren des Agent Updaters angegeben werden.
:::

:::: sect4
##### []{#fixed_update_server .hidden-anchor .sr-only}Verwendung (Usage) {#heading_fixed_update_server}

::: paragraph
Bei einem verteilten Monitoring mit zentraler Konfiguration erhält der
Agent Updater standardmäßig seinen zuständigen Update-Server von der
Checkmk-Instanz, zu der er sich verbindet. Mit dieser Option lässt sich
konfigurieren, dass der hier eingegebene Update-Server dauerhaft
verwendet und der automatische Update-Server ignoriert wird.
:::
::::

:::: sect4
##### []{#dns_name_update_server .hidden-anchor .sr-only}DNS-Name oder IP-Adresse des Update-Servers (DNS name or IP address of update server) {#heading_dns_name_update_server}

::: paragraph
Hier geben Sie den DNS-Namen an, unter dem der Checkmk-Server erreichbar
ist. Wichtig ist hier, dass der zu überwachende Host diesen Namen
auflösen kann und er in Checkmk als Host konfiguriert ist. Achten Sie
bei dem Einsatz von HTTPS darauf, dass der Name des Zertifikats mit dem
Namen des Checkmk-Servers übereinstimmt, der dem Host bekannt ist.
:::
::::

:::: sect4
##### []{#cmk_site_update_server .hidden-anchor .sr-only}Name der Checkmk-Instanz des Update-Servers (Name of Checkmk site of update server) {#heading_cmk_site_update_server}

::: paragraph
Hier tragen Sie - bis auf wenige Ausnahmen - den Namen der Instanz ein,
auf der Sie gerade diese Regel konfigurieren. Eine Ausnahme von diesem
Vorgehen wäre es, wenn die betroffenen Hosts zu einer anderen
Checkmk-Instanz \"umziehen\" sollen. In diesem Fall tragen Sie hier
einmalig eine andere Instanz ein. Siehe hier auch weiter unten unter
[Einsatzszenarien](#scenarios). Bei einem verteilten Setup mit zentraler
Konfiguration kann die Instanz, an der Sie sich registrieren wollen,
ebenfalls von der zentralen Instanz, auf der diese Regel konfiguriert
wird, abweichen.
:::
::::

::::: sect4
##### []{#update_protocol .hidden-anchor .sr-only}Protokoll zum Holen von Updates (Protocol to use for fetching updates) {#heading_update_protocol}

::: paragraph
Wenn Sie - wie von uns empfohlen - HTTPS verwenden, müssen Sie
sicherstellen, dass dem Agent Updater auch ein CA-Zertifikat (CA =
Certification Authority) zur Verfügung steht, mit dem die Verbindung
verifiziert wird.
:::

::: paragraph
**Wichtig**: Je nach Konfiguration des Servers kann es sein, dass HTTPS
(inklusive Weiterleitung von HTTP auf HTTPS) erzwungen wird. In einem
solchen Fall ist eine Konfiguration dieser Regel auf HTTP wirkungslos.
:::
:::::
:::::::::::::

::::: sect3
#### []{#certificates_for_https .hidden-anchor .sr-only}Zertifikate für HTTPS-Verifizierung (Certificates for HTTPS verification) {#heading_certificates_for_https}

::: paragraph
Hier konfigurierte CA- oder selbst signierte Zertifikate stehen dem
Agent Updater für die Verifikation von HTTPS-Verbindungen zur Verfügung.
Alternativ hierzu können dem Agent Updater bei einem verteilten Setup
mit zentraler Konfiguration auch Zertifikate von der Checkmk-Instanz zur
Verfügung gestellt werden oder diese per Kommandozeilenparameter direkt
bei der Verbindung importiert werden.
:::

::: paragraph
**Wichtig**: Ist die Zertifikatskette des Servers mit einer öffentlichen
CA signiert, kann die Verbindung im Normalfall ohne importierte
Zertifikate verifiziert werden. Sobald dem Agent Updater aber
importierte Zertifikate aus einer der genannten Quellen zur Verfügung
stehen, werden alle anderen CA-Zertifikatsstellen ignoriert! Bei
Problemen mit der Konfiguration von HTTPS, konsultieren Sie bitte das
unten [folgende FAQ](#faq4).
:::
:::::

:::: sect3
#### []{#interval_for_update_check .hidden-anchor .sr-only}Intervall für den Update-Check (Interval for update check) {#heading_interval_for_update_check}

::: paragraph
Hier legen Sie das Intervall fest, in dem der Agent Updater den
konfigurierten Monitoring-Server nach einem Update anfragt. Solange das
gesetzte Intervall nicht abgelaufen ist, wird ein zwischengespeicherter
Aufruf zurückgegeben, um das Netzwerk so wenig wie möglich zu belasten.
Normalerweise ist es sinnvoll, ein Intervall zu nutzen, welches
mindestens 10 Minuten oder mehr beträgt, da sonst die Gefahr besteht,
dass Ihr Netzwerk unnötig belastet wird, falls Sie sehr viele
Checkmk-Agenten haben. Wenn Sie hier nichts einstellen, gilt ein
Defaultwert von 1 Stunde.
:::
::::

:::: sect3
#### []{#proxy_settings .hidden-anchor .sr-only}Proxy-Einstellungen (Proxy settings) {#heading_proxy_settings}

::: paragraph
Diese Regeleinstellung ist ebenfalls optional. Der Agent Updater geht
zunächst davon aus, dass auch bei konfigurierten Proxy-Einstellungen auf
dem Ziel-Host eine direkte Verbindung zum Checkmk-Server vorliegt und
ignoriert alle lokalen Proxy-Einstellungen. Wenn dies das gewünschte
Verhalten ist, kann diese Regeleinstellung also weggelassen werden.
Andernfalls geben Sie die Proxy-Einstellungen entweder manuell an oder
nutzen die existierenden Umgebungsvariablen des Hosts.
:::
::::

::::::: sect3
#### []{#executable_format .hidden-anchor .sr-only}Ausführbares Format (Linux) (Executable format (Linux)) {#heading_executable_format}

::: paragraph
Sie können optional bestimmen, in welcher Form das Plugin dem
Installationspaket für den Agenten hinzugefügt wird. Wie sich die Regel
verhält, hängt standardmäßig von dem Zielsystem ab:
:::

::: ulist
- Linux (deb, rpm, tgz): Für diese Systeme müssen Sie nichts manuell
  anpassen; der Agent Updater wird als 64-Bit-Binary übergeben. Optional
  können Sie auch ein 32-Bit-Binary für ältere Systeme oder das alte
  Python-Skript auswählen. **Wichtig**: Für das Binary benötigen Sie das
  Paket *glibc* mindestens in der Version 2.5. Linux-Distributionen
  erfüllen diese Anforderungen in der Regel seit 2006.

- Windows: Für Windows wird das Plugin immer als 32-Bit-Executable
  ausgeliefert. Diese Regel wird dementsprechend standardmäßig
  ignoriert. **Hinweis:** Etwaig vorhandene 64-Bit-Binaries stammen aus
  älteren Versionen von Checkmk und entsprechen nicht mehr dem aktuellen
  Standard.

- Solaris: Hier müssen Sie ebenfalls nichts anpassen. Checkmk wird hier
  das Python-Skript verwenden, auch wenn Sie den Standardwert auf dem
  64-Bit-Binary lassen.

- Andere Architekturen: Wenn Sie Pakete für andere Architekturen, wie
  beispielsweise arm oder ppc, verwenden möchten, setzen Sie diese
  Option manuell auf [Python]{.guihint}. Dies ist notwendig, da diese
  Architekturen von Checkmk nicht automatisch abgefangen werden und
  keine Binaries dafür angeboten werden.
:::

::: paragraph
Falls Sie dennoch auf das Python-Skript zurückgreifen müssen, gelten die
folgenden Voraussetzungen für das System:
:::

::: ulist
- Python3 in der Version 3.4 oder neuer

- Die Python-Module *requests*, *PySocks* und *pyOpenSSL*
:::
:::::::

::::::: sect3
#### []{#signature_keys .hidden-anchor .sr-only}Signaturen, die der Agent akzeptieren soll (Signature keys the agent will accept) {#heading_signature_keys}

::: paragraph
Wählen Sie hier mindestens einen Signaturschlüssel aus, dessen Signatur
vom Agent Updater akzeptiert werden soll. Optional können Sie auch
mehrere Schlüssel angeben. Das kann z.B. der Fall sein, wenn Sie einen
alten Schlüssel deaktivieren wollen. Für dieses Vorhaben muss der Agent
Updater eines Hosts zwischenzeitlich beide Schlüssel akzeptieren.
:::

::: paragraph
Nach dieser letzten Anpassung könnte Ihre Regel wie im folgenden
Screenshot aussehen. Speichern Sie alle Ihre Angaben durch einen Klick
auf [![icon save](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint}.
:::

:::: imageblock
::: content
![agent deployment agent
updater](../images/agent_deployment_agent_updater.png)
:::
::::
:::::::
:::::::::::::::::::::::::::::::::::::::

:::::::: sect2
### []{#bakery .hidden-anchor .sr-only}1.3. Agenten backen und signieren {#heading_bakery}

::: paragraph
Als Nächstes können Sie bereits die so konfigurierten Agenten in einem
Schritt backen und signieren. Die erstellten und angepassten Regeln
finden sich nämlich erst dann in den Installationspaketen wieder, wenn
Sie diese neu erstellen/backen. Navigieren Sie dazu wieder nach [Setup
\> Agents \> Windows, Linux, Solaris AIX]{.guihint} und klicken Sie dann
auf [Bake and sign agents]{.guihint}. Sie müssen nun die Passphrase des
gewünschten Schlüssels eingeben. Nach dem Klick auf [Bake and
sign]{.guihint} startet der Backvorgang als Hintergrundprozess. Wenn
dieser Prozess abgeschlossen ist, werden Sie darüber informiert:
:::

:::: imageblock
::: content
![agent deployment agent baking
successful](../images/agent_deployment_agent_baking_successful.png)
:::
::::

::: {#sign_agent .paragraph}
Alle so signierten Agenten werden mit einem entsprechenden Symbol
[![icon signature
key](../images/icons/icon_signature_key.png)]{.image-inline}
gekennzeichnet. Wenn Sie mehrere Schlüssel angelegt haben, signieren Sie
mit den weiteren Schlüsseln separat.
:::

::: paragraph
**Wichtig:** Einem Agent Updater auf dem zu überwachenden Host genügt
es, wenn das neue Paket mit einem der ihm bekannten Schlüssel signiert
ist.
:::
::::::::

:::::::::::::::::::::::::::: sect2
### []{#register_agent .hidden-anchor .sr-only}1.4. Agent Updater registrieren {#heading_register_agent}

::: paragraph
Registrieren Sie im nächsten Schritt die Hosts, für die Sie den Agent
Updater einrichten wollen, am Checkmk-Server. Da ein neuer Host dem
Checkmk-Server bisher noch nicht vertraut und dieser auch noch nicht
weiß, dass der Host automatisch aktualisiert werden soll, muss der Agent
auf dem Host einmalig von Hand installiert werden.
:::

::: paragraph
Laden Sie dafür zunächst unter [Setup \> Agents \> Windows, Linux,
Solaris, AIX]{.guihint} das für den Host passende Paket aus der
[Agentenbäckerei](wato_monitoringagents.html#bakery_download) herunter.
Achten Sie darauf, dass das Paket auch wirklich das Agent-Updater-Plugin
enthält.
:::

:::::::::: sect3
#### []{#_agent_updater_unter_linux_registrieren .hidden-anchor .sr-only}Agent Updater unter Linux registrieren {#heading__agent_updater_unter_linux_registrieren}

::: paragraph
Kopieren Sie nun das Agentenpaket auf den zugehörigen Host und
installieren Sie es mit `rpm` bzw. `dpkg` ([Paketinstallation unter
Linux](agent_linux.html#install_package).)
:::

::: paragraph
Nach der Installation finden Sie das Agent-Updater-Plugin im Verzeichnis
`/usr/lib/check_mk_agent/plugins/3600/cmk-update-agent`. Das
Unterverzeichnis `3600` steht dabei für das [Intervall für den
Update-Check](#interval_for_update_check) in Sekunden (hier für den
Standardwert von einer Stunde). Ein gleichnamiges Skript wird auch unter
`/usr/bin/` abgelegt, daher steht `cmk-update-agent` auch als Kommando
zur Verfügung.
:::

::: paragraph
Rufen Sie nun den Agent Updater mit dem Argument `register` auf. Geben
Sie dann der Reihe nach die erforderlichen Angaben ein.
:::

::: paragraph
Mit dem folgenden Kommando registrieren Sie den Agent Updater von einem
**Linux-Host** aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-update-agent register -v
-------------------------------------------------------------------
|                                                                   |
|  Check_MK Agent Updater v2.1.0 - Registration                     |
|                                                                   |
|  Activation of automatic agent updates. Your first step is to     |
|  register this host at your deployment server for agent updates.  |
|  For this step you need a user with the permission                |
|  "Register all hosts" on that Checkmk site.                       |
|                                                                   |
-------------------------------------------------------------------
Our host name in the monitoring:
myhost

User with registration permissions:
cmkadmin

Password:

Going to register agent at deployment server
Successfully registered agent of host "myhost" for deployment.
You can now update your agent by running 'cmk-update-agent -v'
Saved your registration settings to /etc/cmk-update-agent.state.

Hint: you can do this in scripts with the command:

cmk-update-agent register -s myserver.example.com -i mysite -H myhost -p https -U cmkadmin -P * -v
```
:::
::::

::: paragraph
Alternativ können Sie die Registrierung auch im nicht-interaktiven Modus
durchführen, indem die benötigten Daten per Kommandozeilenoptionen
übergeben werden. Ein Aufruf von `cmk-update-agent register --help`
zeigt die setzbaren Optionen an.
:::
::::::::::

:::::::::::: sect3
#### []{#_agent_updater_unter_windows_registrieren .hidden-anchor .sr-only}Agent Updater unter Windows registrieren {#heading__agent_updater_unter_windows_registrieren}

::: paragraph
Kopieren Sie nun das Agentenpaket auf den zugehörigen Host und
installieren Sie es mit `msiexec` ([Paketinstallation unter
Windows.](agent_windows.html#install_package))
:::

::: paragraph
Nach der Installation ist der Agent Updater in den Windows-Agenten
`C:\Program Files (x86)\checkmk\service\check_mk_agent.exe` integriert.
Dem Updater selbst können Sie dann immer mit
`check_mk_agent.exe updater` Befehle erteilen.
:::

::: paragraph
Rufen Sie nun den Agent Updater mit dem Argument `register` auf. Unter
Windows muss dies in einer Eingabeaufforderung mit Administratorrechten
geschehen. Geben Sie dann der Reihe nach die erforderlichen Angaben ein.
:::

::: paragraph
Da der Agent Updater für **Windows-Hosts** direkt durch den Agenten
selbst ausgeführt wird, sieht der Befehl für die Registrierung so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\WINDOWS\system32> "C:\Program Files (x86)\checkmk\service\check_mk_agent.exe" updater register
Using previous settings from C:\ProgramData\checkmk\agent\config\cmk-update-agent.state.
Our host name in the monitoring:
mywindowshost

User with registration permissions:
cmkadmin

Password:

Successfully registered agent of host "mywindowshost" for deployment.
```
:::
::::

::: paragraph
Alternativ können Sie die Registrierung auch im nicht-interaktiven Modus
durchführen, indem die benötigten Daten per Kommandozeilenoptionen
übergeben werden. Der komplette Befehl zur Registrierung sieht wie folgt
aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
C:\WINDOWS\system32> "C:\Program Files (x86)\checkmk\service\check_mk_agent.exe" ^
updater register -s myserver.example.com -i mysite -H mywindowshost -p https -U cmkadmin -P mycmkadminpassword -v
```
:::
::::
::::::::::::

::::::: sect3
#### []{#_einmalige_registrierung_und_generelle_hinweise .hidden-anchor .sr-only}Einmalige Registrierung und generelle Hinweise {#heading__einmalige_registrierung_und_generelle_hinweise}

::: paragraph
Die einmalige Registrierung kann auch über einen
[Automationsbenutzer](glossar.html#automation_user) erfolgen. Dafür wird
auf der Kommandozeile der Benutzer per `-U/--user` und das
Automationspasswort per `-S/--secret` übergeben.
:::

::: paragraph
Einige Hinweise zur Registrierung:
:::

::: ulist
- Bei der Registrierung benötigt das Plugin auch den Namen des Hosts,
  wie er im Monitoring bekannt ist. Dieser ist nicht unbedingt mit dem
  Host-Namen des Rechners identisch. Der Host-Name wird dann zusammen
  mit dem Schlüssel lokal gespeichert.

- Um HTTPS zu verwenden, muss auf Ihrem Monitoring-Server HTTPS
  eingerichtet sein. HTTP ist hier deutlich einfacher, bietet aber keine
  Verschlüsselung der Übertragung. Da der Agent in Skripten und
  Konfigurationsdateien Passwörter enthalten kann, ist HTTPS der
  empfohlene Weg. Die Authentizität des Agenten wird aber durch die
  Signatur unabhängig davon sichergestellt.

- Der Login als Checkmk-Administrator ist nur einmal erforderlich. Agent
  und Server vereinbaren bei der Registrierung einen geheimen Schlüssel
  (*Host Secret*), der nur diesem Host bekannt ist. Das Passwort des
  Checkmk-Administrators wird nirgendwo gespeichert.

- Während der interaktive Modus nur Felder abfragt, die in noch keiner
  Konfiguration vorhanden sind, lassen sich durch den nicht-interaktiven
  Modus alle in der Hilfe angezeigten Felder setzen und haben für diesen
  Aufruf die höchste Priorität. Optionen, die nur in der Datei
  `cmk-update-agent.state` gespeichert sind, werden so
  überschrieben --- Optionen aus `cmk-update-agent.cfg` jedoch nicht.
  Mehr Details dazu gibt es weiter unten unter [Einsehen der lokalen
  Konfiguration.](#show_config)
:::

::: paragraph
Nach einer erfolgreichen Registrierung wird das Host Secret beim Agenten
in der Datei `/etc/cmk-update-agent.state` gespeichert. Auf dem Server
liegt er dann in `~/var/check_mk/agent_deployment/myhost`. Das Host
Secret erlaubt von nun an dem Host **seinen eigenen** Agenten ohne
Passwort vom Server herunterzuladen. Ein Herunterladen von Agenten
anderer Hosts ist nicht möglich (da diese vertrauliche Daten enthalten
könnten).
:::
:::::::
::::::::::::::::::::::::::::

::::::::: sect2
### []{#master_switch .hidden-anchor .sr-only}1.5. Master switch {#heading_master_switch}

::: paragraph
Nun sollten alle Bedingungen erfüllt sein. Falls noch nicht passiert,
aktivieren Sie das Ganze durch einen Klick auf [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} beim [Master
switch]{.guihint}. Die Tabelle [Prerequisites]{.guihint} sieht dann so
aus:
:::

:::: imageblock
::: content
![agent deployment prerequisites
fulfilled](../images/agent_deployment_prerequisites_fulfilled.png)
:::
::::

::: paragraph
Ab sofort wird sich nun der Agent jeweils zum Ende des konfigurierten
Update-Intervalls melden und nach einer neuen Version des Agenten
Ausschau halten. Sobald diese bereitsteht *und signiert ist*, wird er
sie automatisch herunterladen und installieren.
:::

::: paragraph
Gleichzeitig ist der [Master switch]{.guihint} eine Möglichkeit, die
Updates global abzuschalten.
:::

::: paragraph
Eine Schritt-für-Schritt-Anleitung bietet auch das Video unter folgendem
Link, das auf der Checkmk Konferenz #3 (2017) entstanden ist. Es handelt
sich hier nicht um die aktuelle Version --- die prinzipielle
Vorgehensweise hat sich jedoch nicht verändert: [Die neuen automatischen
Agent Updates](https://youtu.be/S7TNo2YcGpM?t=767){target="_blank"}
:::
:::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::: sect1
## []{#host_selection .hidden-anchor .sr-only}2. Begrenzung des Updates auf bestimmte Hosts {#heading_host_selection}

::::::::: sectionbody
::: paragraph
Bevor Sie einen neuen Agenten auf eine größere Zahl von Hosts ausrollen,
möchten Sie ihn sicherlich zuerst mit einer kleineren Anzahl von Hosts
ausprobieren. Dieser wichtige Schritt verhindert, dass ein möglicher
Fehler große Ausmaße annimmt.
:::

::: paragraph
Dazu dient der mittlere Kasten auf der Seite [Automatic agent
updates:]{.guihint}
:::

:::: imageblock
::: content
![agent deployment host
selection](../images/agent_deployment_host_selection.png)
:::
::::

::: paragraph
Die Bedingungen werden dabei immer mit einer Konjunktion (*logisches
UND*) verknüpft: Nur Hosts, die *alle* ausgewählten Bedingungen
erfüllen, erhalten das Update. Nachdem Sie hier Bedingungen für die
Auswahl von Hosts festgelegt haben, können Sie in dem Feld [Test
hostname before activation]{.guihint} einzelne Host-Namen eintippen und
kontrollieren, ob die Updates für diese Hosts nun aktiviert sind oder
nicht.
:::

::: paragraph
**Wichtig:** Auf Hosts, die bisher noch nicht mit automatischen Updates
versorgt werden sollen, darf das installierte Paket nicht das
Agent-Updater-Plugin enthalten. Andernfalls wird das Plugin Sie
regelmäßig davor warnen, dass der Host bisher noch nicht registriert
ist.
:::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::: sect1
## []{#diagnosis .hidden-anchor .sr-only}3. Diagnose {#heading_diagnosis}

::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Zur Diagnose, ob alle Updates wie gewollt funktionieren, gibt es etliche
Informationsquellen.
:::

::::::::: sect2
### []{#statistics .hidden-anchor .sr-only}3.1. Statistik zur Agentenverteilung {#heading_statistics}

:::: imageblock
::: content
![agent deployment update
status](../images/agent_deployment_update_status.png)
:::
::::

::: paragraph
Diese Übersicht zeigt, wie sich die einzelnen Hosts im Agenten-Update
verhalten. Die [Inline-Hilfe](user_interface.html#inline_help) gibt
weitere Erklärungen. Ein Klick auf [![icon view
20](../images/icons/icon_view_20.png)]{.image-inline} bringt Sie zu
einer detaillierten Liste der einzelnen Hosts. Zu der Gesamtliste aller
registrierten Hosts gelangen Sie auch über die Ansicht [Monitor \>
System \> Agent update status.]{.guihint} Dort können Sie dann gezielt
nach einzelnen Hosts suchen.
:::

:::: imageblock
::: content
![agent deployment status
view](../images/agent_deployment_status_view.png)
:::
::::

::: paragraph
In dieser Liste finden Sie auch dokumentiert, wie der Hash eines Agenten
anfängt, der für einen Host vorgesehen ist ([Target Agent]{.guihint}),
welcher zuletzt vom Host heruntergeladen wurde ([Downloaded
Agent]{.guihint}) und welcher aktuell auf dem Host installiert ist
([Installed Agent]{.guihint}). So können Sie jederzeit nachvollziehen,
ob die Vorgaben eingehalten wurden oder wo sich der Prozess gerade
befindet. Zu beachten ist hierbei, dass die Statusinformationen weiter
links direkt bei der Kommunikation zwischen Agentenbäckerei und Agent
Updater entstehen, während die Felder [Update Check]{.guihint} und
[Update Check Output]{.guihint} von dem Agent-Updater-Plugin bei der
Abfrage des Agenten des Hosts kommen und durch die Zwischenspeicherung
(definiert durch das Abfrageintervall) ggf. zu einem anderen Zeitpunkt
aktualisiert werden.
:::
:::::::::

:::::::: sect2
### []{#check_mk_agent .hidden-anchor .sr-only}3.2. Der Service Check_MK Agent {#heading_check_mk_agent}

::: paragraph
Wenn Sie auf einem Agenten das Agent-Updater-Plugin installiert haben,
gibt dieses regelmäßig den aktuellen Status des Updates in Form von
Monitoring-Daten aus. Die Service-Erkennung erzeugt daraus einen neuen
Service bei dem Host mit dem Namen [Check_MK Agent.]{.guihint} Dieser
spiegelt den aktuellen Zustand des Updates wider. Sie können sich so
über ein Problem mit den Updates benachrichtigen lassen.
:::

:::: imageblock
::: content
![agent deployment agent
check](../images/agent_deployment_agent_check.png)
:::
::::

::: paragraph
Unter anderem signalisiert der Zustand des Services, wie der Status des
Signaturschlüssels beurteilt wird. Folgende Zustände sind möglich:
:::

::: ulist
- [WARN]{.state1}: Das Zertifikat des Signaturschlüssels ist korrupt,
  nicht mehr gültig oder wird in den nächsten 90 Tagen ungültig.

- [CRIT]{.state2}: Es gibt kein gültiges Zertifikat für den
  Signaturschlüssel oder das Zertifikat verliert innerhalb der nächsten
  30 Tage seine Gültigkeit.
:::
::::::::

:::::: sect2
### []{#show_config .hidden-anchor .sr-only}3.3. Einsehen der lokalen Konfiguration {#heading_show_config}

::: paragraph
Das Verhalten des Agent Updaters wird maßgeblich durch die beiden
Dateien `cmk-update-agent.cfg` und `cmk-update-agent.state` bestimmt.
Dabei gilt immer, dass gesetzte Werte aus der `.cfg`-Datei über die
`.state`-Datei gewinnen. Zeigt der Agent Updater unerwartetes Verhalten,
lohnt sich manchmal ein Blick in die Konfiguration. Dafür gibt es auch
eine praktische Funktion, wenn Sie den Agent Updater direkt in der
Kommandozeile aufrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-update-agent show-config
Showing current configuration...

Configuration from config file (/etc/check_mk/cmk-update-agent.cfg):
server: myserver
site: mysite
protocol: http
certificates: []
ignore_update_url: False
interval: 3600
proxy: None
signature_keys: ['-----BEGIN CERTIFICATE-----\n [...] \n-----END CERTIFICATE-----\n']
use_proxy_env: False

Configuration from state file (/etc/cmk-update-agent.state):
last_error: None
host_secret: zqscykkqfdkpwnwenqfibdksqvuamblstbtmpasbhnlbubmncgmrqxvakasittxw
host_name: myhost
user: cmkadmin
last_check: 1660750511.8183599
pending_hash: None
installed_aghash: 94b60c8ef40c4900
last_update: 1660750584.8527653
```
:::
::::
::::::

:::::::::::: sect2
### []{#logs_on_host .hidden-anchor .sr-only}3.4. Log-Meldungen {#heading_logs_on_host}

::: paragraph
Im Falle eines Problems finden Sie auch auf dem zu überwachenden Host
Log-Daten über die Updates. Unter Linux loggt `cmk-update-agent`
wichtige Informationen wie Warnings und Errors nach syslog:
:::

::::: listingblock
::: title
/var/log/syslog
:::

::: content
``` {.pygments .highlight}
Jul 02 13:59:23 myhost [cmk-update-agent] WARNING: Missing config file at ./cmk-update-agent.cfg. Configuration may be incomplete.
Jul 02 13:59:23 myhost [cmk-update-agent] ERROR: Not yet registered at deployment server. Please run 'cmk-update-agent register' first.
```
:::
:::::

::: paragraph
Eine detailliertere Log-Datei `cmk-update-agent.log` inklusive
Debug-Ausgaben und eventuellen Tracebacks finden Sie unter Linux und
unter Windows:
:::

::::: listingblock
::: title
/var/lib/check_mk_agent/cmk-update-agent.log
:::

::: content
``` {.pygments .highlight}
2021-07-02 17:58:18,321 DEBUG: Starting Check_MK Agent Updater v2.0.0p9
2021-07-02 17:58:18,322 DEBUG: Successfully read /etc/cmk-update-agent.state.
2021-07-02 17:58:18,322 DEBUG: Successfully read /etc/check_mk/cmk-update-agent.cfg.
pass:q[[...]]
2021-07-02 17:58:18,387 INFO: Target state (from deployment server):
2021-07-02 17:58:18,387 INFO:   Agent Available:     True
2021-07-02 17:58:18,387 INFO:   Signatures:          1
2021-07-02 17:58:18,387 INFO:   Target Hash:         081b6bcc6102d94a
2021-07-02 17:58:18,387 INFO: Ignoring signature #1 for certificate: certificate is unknown.
2021-07-02 17:58:18,388 DEBUG: Caught Exception:
Traceback (most recent call last):
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 1733, in main
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 714, in run
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 1372, in _run_mode
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 1071, in _do_update_as_command
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 1150, in _do_update_agent
  File "/build/enterprise/agents/plugins/cmk_update_agent.py", line 1221, in _check_signatures
Exception: No valid signature found.
```
:::
:::::

::: paragraph
Sie können aber auch auf beiden Systemen per Kommandozeilenoption
`--logfile LOGFILE` einen alternativen Pfad für die Log-Datei angeben.
:::
::::::::::::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#scenarios .hidden-anchor .sr-only}4. Einsatzszenarien {#heading_scenarios}

:::::::::::::::: sectionbody
::::: sect2
### []{#deactivate_automatic_updates .hidden-anchor .sr-only}4.1. Automatische Updates für einen Host abschalten {#heading_deactivate_automatic_updates}

::: paragraph
Soll ein Host aus den automatischen Updates entfernt werden, so passen
Sie über den Regelsatz [Agent updater (Linux, Windows,
Solaris)]{.guihint} dessen Einstellung so an, dass das Update-Plugin
dort deaktiviert ist. Beim nächsten regelmäßigen Update entfernt der
Agent seinen Updater dann selbst!
:::

::: paragraph
Es versteht sich von selbst, dass das Update dann nur durch die manuelle
Installation eines neuen Agentenpakets erneut aktiviert werden kann. Die
Registrierung bleibt aber erhalten und muss nicht erneuert werden.
:::
:::::

:::::::: sect2
### []{#move_to_new_monitoring_server .hidden-anchor .sr-only}4.2. Umzug auf eine neue Monitoring-Instanz {#heading_move_to_new_monitoring_server}

::: paragraph
Möchten Sie bei einem Single-Site-Setup auf eine neue Checkmk-Instanz
umziehen, ohne dabei die am Server registrierten Hosts zu verlieren, so
ist dabei zu beachten, dass für einen erfolgreichen Agent-Update-Vorgang
die folgenden Informationen auf Server und Host übereinstimmen müssen:
:::

::: ulist
- Der Name, unter dem der Host überwacht wird und registriert ist.

- Das [Host Secret](#show_config), das bei der Registrierung automatisch
  vergeben wurde.

- Die Signatur, mit der die Agenten signiert werden.
:::

::: paragraph
Um dies zu erreichen, gehen Sie folgendermaßen vor:
:::

::: {.olist .arabic}
1.  Nehmen Sie alle Hosts, deren Registrierungsinformationen portiert
    werden sollen, zunächst in der neuen Instanz ins Monitoring auf.
    Achten Sie darauf, dass die Hosts in der neuen Instanz unter
    demselben Namen überwacht werden. Kopieren Sie danach den Ordner
    `~/var/check_mk/agent_deployment` von der alten zur neuen
    Monitoring-Instanz.

2.  Exportieren Sie die Signaturschlüssel, die die auf den Hosts
    installierten Agenten akzeptieren. Die Signaturschlüssel lassen sich
    unter [Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agents \>
    Signature keys]{.guihint} ex- und importieren.

3.  Importieren Sie diese Signaturschlüssel aus Schritt 2 auf der neuen
    Monitoring-Instanz.

4.  Konfigurieren Sie die Agent-Updater-Regel auf der neuen
    Monitoring-Instanz entsprechend der Anleitung und signieren Sie die
    gebackenen Agenten mit dem/den importieren Signaturschlüssel(n).

5.  Konfigurieren Sie zuletzt in der Agent-Updater-Regel auf der alten
    Instanz die Felder für den Update-Server und den Namen der
    Checkmk-Instanz entsprechend Ihrer neuen Monitoring-Instanz und
    backen Sie die Agenten neu. **Achtung**: Bitte prüfen Sie an dieser
    Stelle, ob Sie alles richtig angegeben haben *bevor* Sie die Agenten
    neu backen.
:::

::: paragraph
Sobald die nächsten automatischen Updates auf den Hosts durchlaufen,
wird die alte Monitoring-Instanz ausgesperrt. Die zu überwachenden Hosts
werden sich zukünftig nur noch bei dem neuen Checkmk-Server melden. Nach
dem zweiten automatischen Update wird dementsprechend der Agent vom
neuen Checkmk-Server installiert.
:::
::::::::

:::::: sect2
### []{#automatic_installer .hidden-anchor .sr-only}4.3. Der Agent Updater als automatischer Installer {#heading_automatic_installer}

::: paragraph
**Achtung**: Hierbei handelt es sich um keine offizielle Funktion des
Agent Updaters. Die Anleitung richtet sich daher vor allem an
erfahrenere Nutzer. Der offizielle Weg, den Checkmk Agent auf einem Host
zu installieren, ist das Herunterladen und Ausführen des zum System
passenden Agenten-Pakets. Es ist jedoch auch möglich, den Checkmk Agent
initial vom Agent Updater installieren zu lassen, denn dieser
funktioniert auch als eigenständiges Programm.
:::

::: paragraph
Gehen Sie dafür folgendermaßen vor:
:::

::: {.olist .arabic}
1.  Kopieren Sie das cmk-update-agent-Binary oder das
    `cmk_update_agent.py`-Skript (beides zu finden unter
    `~/share/check_mk/agents/plugins` auf dem Checkmk-Server) auf den zu
    überwachenden Host.

2.  Registrieren Sie den Host am Checkmk-Server mit dem Aufruf von
    `cmk-update-agent register`. Hier bietet es sich an, die benötigten
    Registrierungsinformationen per Kommandozeile direkt zu übergeben.
    Vor allem, wenn Sie ein Installationsskript verwenden wollen. Die
    entsprechenden Optionen können Sie sich beim Aufruf von
    `cmk-update-agent register --help` anzeigen lassen.

3.  Anschließend installieren Sie den Agenten mit allen
    Konfigurationsdetails für den zu überwachenden Host durch einen
    abschließenden Aufruf des Agent-Updater-Plugins. Da jedoch keine
    lokale Konfiguration (der Agent Updater zeigt auch eine
    entsprechende Warnung an) und somit auch keine Signatur für das
    herunterzuladende Agenten-Paket vorliegt, rufen Sie den Updater
    einmalig mit `cmk-update-agent --skip-signatures` auf, um dem
    heruntergeladenen Paket explizit zu vertrauen. Voraussetzung für die
    Installation per Agent Updater ist natürlich, dass von der
    Agentenbäckerei auf dem Checkmk-Server ein passendes Agenten-Paket
    für den Ziel-Host bereitliegt.
:::
::::::
::::::::::::::::
:::::::::::::::::

:::::::::::::::: sect1
## []{#distr_wato .hidden-anchor .sr-only}5. Agenten-Updates im verteilten Monitoring {#heading_distr_wato}

::::::::::::::: sectionbody
::: paragraph
Seit Checkmk [2.0.0]{.new} ist es möglich, gebackene Agenten auch über
Remote-Instanzen zu verteilen. Voraussetzung dafür ist ein Setup mit
[zentraler Konfiguration](distributed_monitoring.html) und die
Möglichkeit, dass die Zentralinstanz von den Remote-Instanzen aus per
HTTP/HTTPS erreicht werden kann.
:::

::: paragraph
Ein solches verteiltes Monitoring kann --- vor allem temporär --- auch
mit verschiedenen Checkmk-Versionen betrieben werden. Dadurch ist es
möglich, größere Systeme sukzessive auf eine neue Checkmk-Version
umzustellen. Beachten Sie dann jedoch unbedingt die Hinweise zu
versionsgemischten Monitoring-Umgebungen im [verteilten
Monitoring.](distributed_monitoring.html#mixed_versions)
:::

::::: sect2
### []{#functionality .hidden-anchor .sr-only}5.1. Funktionsweise {#heading_functionality}

::: paragraph
Technisch ist das Feature so umgesetzt, dass Update-Anfragen an eine
Remote-Instanz an die Zentralinstanz weitergeleitet werden --- die
gesamte Konfiguration sowie das Backen der Agenten findet also
ausschließlich auf der Zentralinstanz statt. Agenten-Pakete, die bereits
einmal an einer Remote-Instanz angefragt wurden, werden dort
zwischengespeichert (so lange sie gültig sind), so dass die Pakete nicht
erneut von der Zentralinstanz heruntergeladen werden müssen. Zudem
werden die angefragten Daten bereits auf der Remote-Instanz auf
Konsistenz überprüft, so dass unnötige Verbindungen zur Zentralinstanz
vermieden werden.
:::

::: paragraph
Anders als im Single-Site-Setup ergibt sich der passende Update-Server
für die Hosts nicht ausschließlich aus dem Regelwerk des Agent Updaters,
sondern wird dem anfragenden Agent Updater von der kontaktierten
Checkmk-Instanz mitgeteilt. Dabei wird einem Host der Server zugeteilt,
von dessen Instanz aus er überwacht wird. Die Angabe eines
Checkmk-Servers wird daher nur noch für die einmalige Registrierung
gebraucht, die theoretisch an jeder (vom Host aus erreichbaren) Instanz
im gesamten verteilten Monitoring-Setup stattfinden kann. Sollte die
Verbindung zum automatisch ermittelten Server fehlschlagen, wird der
zuvor gespeicherte Server (aus der Regel-Konfiguration oder zuvor
erfolgter manueller Eingabe bei der Registrierung) als Fallback
verwendet.
:::
:::::

::::::::: sect2
### []{#configuration_distributed_monitoring .hidden-anchor .sr-only}5.2. Konfiguration {#heading_configuration_distributed_monitoring}

::: paragraph
Das Verteilen der Agentenpakete über Remote-Instanzen muss nicht separat
aktiviert werden - die jeweilige Remote-Instanz erkennt die Situation
automatisch und kommuniziert dementsprechend mit der Zentralinstanz
sowie dem anfragenden Agent Updater. Sollen sich die Agenten für Updates
explizit nur an der Zentralinstanz melden, erfolgt dies über einen fest
eingestellten Update-Server im [Regelwerk des Agent
Updaters](#fixed_update_server).
:::

::: paragraph
Damit die Agenten-Updates im verteilten Monitoring tatsächlich
funktionieren, müssen jedoch auf der Zentralinstanz noch einige
Einstellungen vorgenommen werden, die sich alle in [Setup \> General \>
Global settings \> Automatic agent updates]{.guihint} befinden.
Unterscheiden sich die Einstellungen je Remote-Instanz, können diese
über [Setup \> General \> Distributed monitoring \> [![icon site
globals](../images/icons/icon_site_globals.png)]{.image-inline} (Site
specific global settings)]{.guihint} realisiert werden.
:::

:::: sect3
#### []{#connection_to_central_bakery .hidden-anchor .sr-only}Connection to central agent bakery {#heading_connection_to_central_bakery}

::: paragraph
An dieser Stelle muss die URL angegeben werden, unter der die
Zentralinstanz von der Remote-Instanz aus erreichbar ist, inklusive
Protokoll und `check_mk`, also z.B.
`https://myserver.org/mysite/check_mk`. Während die Checkmk-Instanz
versucht, alle anderen fehlenden Einstellungen selbst herauszufinden,
ist die Angabe dieser URL nicht optional, da diese Verbindungsrichtung
bei einer zentralen Konfiguration sonst nicht zustande kommt. Handelt es
sich beim Protokoll um HTTPS, verwendet die Remote-Instanz für die
Verifikation der Verbindung automatisch die im Setup zur Verfügung
stehenden CA- oder selbst signierten Zertifikate ([Setup \> General \>
Global settings \> Site management \> Trusted certificate authorities
for SSL]{.guihint}). Die Remote-Instanz benötigt zusätzlich einen zuvor
angelegten Automationsbenutzer, um sich an der Zentralinstanz anmelden
zu können. Dieser kann hier ebenfalls ausgewählt werden. Wird keiner
angegeben, sucht die Remote-Instanz nach einem Automationsbenutzer mit
dem Namen *Automation*.
:::
::::

:::: sect3
#### []{#connection_to_remote_bakery .hidden-anchor .sr-only}Connection to remote agent bakery {#heading_connection_to_remote_bakery}

::: paragraph
Da die Remote-Instanzen von den jeweils überwachten Hosts aus nicht
notwendigerweise über die gleiche URL erreichbar sind wie von der
Zentralinstanz aus, kann hier eine URL für diesen Zweck konfiguriert
werden. Diese wird dem Host (bzw. dem anfragenden Agent Updater) dann
automatisch bei einem Kontakt zu einer Checkmk-Instanz mitgeteilt. Hier
macht die Konfiguration als *Site specific global setting* besonders
Sinn. Wird keine URL angegeben, wird angenommen, dass die
Remote-Instanzen von der Zentralinstanz und von den überwachten Hosts
aus unter der identischen URL erreichbar sind. Handelt es sich um eine
HTTPS-Verbindung, kann dem Host ebenfalls automatisch das passende
Zertifikat zur Verfügung gestellt werden. Da hierfür aber leider nicht
der zentrale CA-Store verwendet werden kann, lassen sich an dieser
Stelle entsprechende Zertifikate angeben. Alternativ können die
Zertifikate auch bereits im Agent Updater Regelwerk angegeben werden.
:::
::::
:::::::::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::: sect1
## []{#https_handling .hidden-anchor .sr-only}6. HTTPS-Handling {#heading_https_handling}

::::::::::::::::::::::::::::: sectionbody
::: paragraph
An verschiedenen Stellen dieses Artikels ist von einer Absicherung der
jeweiligen Verbindungen über HTTPS die Rede. Hier wird noch einmal
zentral zusammengetragen, was alles für eine vollständige Absicherung
über HTTPS getan werden muss. Sowohl die Verbindung von Remote- zu
Zentralinstanz als auch von Host zu Checkmk-Instanz kann und sollte per
TLS abgesichert werden, d.h. über HTTPS erfolgen. Dies ist unabhängig
davon, ob es sich dabei um ein Setup mit einer einzelnen Instanz oder
ein verteiltes Setup handelt.
:::

::::: sect2
### []{#https_usage .hidden-anchor .sr-only}6.1. HTTPS verwenden {#heading_https_usage}

::: paragraph
Um eine Checkmk-Instanz per HTTPS ansprechen zu können, muss zunächst
einmal der Monitoring-Server auch für HTTPS konfiguriert sein. Dies kann
z.B. über eine geeignete [Konfiguration des
System-Apache](omd_https.html) oder besonders einfach durch die
HTTPS-Einstellungen der Checkmk-Appliance erreicht werden.
:::

::: paragraph
Ob ein Checkmk-Server dann per HTTP oder HTTPS angesprochen wird,
entscheidet sich anhand der jeweils konfigurierten URL. Beginnt diese
mit `https://`, wird der Server über das HTTPS-Protokoll über Port 443
angesprochen. Das gilt ebenso für das Protokoll, welches Sie mit der
Einstellung [[Update server
information]{.guihint}](#update_server_information) konfiguriert haben.
Prinzipiell können Sie auf Apache-Seite die Weiterleitung von HTTP nach
HTTPS erzwingen und dafür (zunächst) einzelne Pfade ausnehmen. Details
der Konfiguration entnehmen Sie der Apache-Dokumentation der Module
`mod_rewrite` und `mod_redirect`.
:::
:::::

:::::::::::::::::::::::: sect2
### []{#provide_certificates .hidden-anchor .sr-only}6.2. Zertifikate bereitstellen {#heading_provide_certificates}

::: paragraph
Damit eine HTTPS-Verbindung zustande kommen kann, muss die
Zertifikatskette oder das selbst signierte Zertifikat (je nachdem, wie
der Server konfiguriert ist) des kontaktierten Servers verifiziert
werden können. Die Bereitstellung von geeigneten CA- oder selbst
signierten Zertifikaten macht dies möglich und kann auf verschiedene
Weisen realisiert werden.
:::

:::::::::::: sect3
#### []{#connection_to_cmk_server .hidden-anchor .sr-only}Verbindung von Host zu Checkmk-Server {#heading_connection_to_cmk_server}

::: paragraph
Der Agent Updater versucht grundsätzlich HTTPS-Verbindungen zu
verifizieren und bricht diese ab, wenn die Verifizierung nicht möglich
ist. Zertifikate zur Verifikation stehen dem Agent Updater aus den
folgenden Quellen zur Verfügung:
:::

::: paragraph
**Agent Updater:** In Standardeinstellungen bringt der Agent Updater
eine Python Laufzeitumgebung inclusive benötigter Module mit. Enthalten
ist auch das Zertifikats-Bundle des
[Certifi-Moduls.](https://pypi.org/project/certifi/#){target="_blank"}
Dieses wiederum basiert auf der Zertifikatssammlung des
Mozilla-Projekts. So ist sichergestellt, dass öffentliche CAs dem Agent
Updater zeitnah bekannt gemacht werden, selbst wenn
Betriebssystemupdates ausstehen.
:::

::: paragraph
**Zertifikate via Agentenbäckerei:** Im Certifi-Modul enthaltene
Zertifikate werden ignoriert, sobald ein oder mehrere Zertifikate über
einen der folgenden Mechanismen importiert wurden. Zertifikate aus den
folgenden Quellen werden lokal auf dem Host gespeichert und nur vom
Agent Updater verwendet:
:::

::: {.olist .arabic}
1.  Über die Einstellung [[Certificates for HTTPS
    verification]{.guihint}](#certificates_for_https) können Zertifikate
    mit in das Agentenpaket eingebacken werden und stehen dem Agent
    Updater ab Installation (oder Update) zur Verfügung.

2.  Bei der Konfiguration der Verbindung zur Remote-Instanz über [Setup
    \> General \> Global settings \> Automatic agent updates \>
    Connection to remote agent bakery]{.guihint} können Sie Zertifikate
    angeben, mit denen die HTTPS-Verbindung zur jeweiligen
    Remote-Instanz verifiziert werden kann. Dies ist insbesondere dann
    sinnvoll, wenn zur Konfigurationszeit noch nicht klar ist, welcher
    Host welcher Instanz zugeteilt wird. Auch lässt sich mit dieser
    Importmöglichkeit die Anzahl der zu backenden Agenten reduzieren, da
    die richtigen Zertifikate für die jeweiligen Update-Server nicht
    Host-spezifisch konfiguriert werden müssen.
:::

::: paragraph
**Certificate Store:** Nur wenn der Agent Updater so konfiguriert ist,
dass er statt der mitgelieferten Python Laufzeitumgebung das
[System-Python](#executable_format) nutzt und im System-Python kein
Certifi-Modul konfiguriert ist, nutzt er *möglicherweise* den
Certificate Store des Betriebssystems. Da hier viele Faktoren wie
Installationsparameter oder die Umgebungsvariable `_PIP_STANDALONE_CERT`
mit hineinspielen, wird diese Konstellation von uns nicht offiziell
unterstützt.
:::

::: paragraph
**Zertifikat via Kommandozeile -- Zertifikat importieren:** Sie können
den Agent Updater auch mit dem Kommandozeilenargument `--trust-cert`
aufrufen. Dadurch wird das Serverzertifikat abgerufen und importiert.
Dies erfolgt ohne Berücksichtigung der Art des Zertifikats: Dem
Zertifikat wird ohne weitere Prüfung einer möglichen Kette vertraut --
egal, ob es sich um ein selbst signiertes Zertifikat handelt, ein
Zertifikat am Ende einer öffentlichen Zertifikatskette oder ein
Zertifikat, das mit einer internen CA signiert wurde.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: {.olist .arabic}              |
| t](../images/icons/important.png) | 1.  Wird ein Zertifikat auf diese |
|                                   |     Weise importiert, müssen Sie  |
|                                   |     die Authentizität des Servers |
|                                   |     selbst sicherstellen, da das  |
|                                   |     Zertifikat aus keiner         |
|                                   |     separaten Quelle stammt.      |
|                                   |                                   |
|                                   | 2.  Da nur das Serverzertifikat   |
|                                   |     importiert wird, das mitunter |
|                                   |     sehr kurzlebig ist, müssen    |
|                                   |     Sie rechtzeitig vor Ablauf    |
|                                   |     [neue                         |
|                                   |                                   |
|                                   | Zertifikate](#certificate_change) |
|                                   |     über die Agentenbäckerei      |
|                                   |     bereitstellen.                |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
**Zertifikat via Kommandozeile -- Zertifikat ignorieren:** Falls dem
Agent Updater gar kein gültiges Zertifikat zur Verfügung steht, kann die
Zertifikats-Validierung durch das Kommandozeilenargument `--insecure`
für einen Aufruf umgangen werden. Dies kann sinnvoll sein, wenn das
gültige Zertifikat bereits darauf wartet, bei der nächsten Verbindung
vom Server abgerufen zu werden, der Agent Updater aber eben durch dieses
fehlende Zertifikat „ausgesperrt" ist.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Die Prüfung des Zertifikates wird |
|                                   | hierdurch tatsächlich für diesen  |
|                                   | Aufruf komplett deaktiviert. Die  |
|                                   | Kommunikation findet dennoch      |
|                                   | verschlüsselt statt --            |
|                                   | dementsprechend ist der Einsatz   |
|                                   | dieses Arguments „besser als      |
|                                   | nichts".                          |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::

:::: sect3
#### []{#connection_from_remote_to_central_site .hidden-anchor .sr-only}Verbindung von Remote-Instanz zu Zentralinstanz {#heading_connection_from_remote_to_central_site}

::: paragraph
Einfacher gestaltet sich die Verteilung der Zertifikate bei der
Verbindung von der Remote- zur Zentralinstanz, da hier das Setup gar
nicht verlassen wird. Die Remote-Instanz kann sich aus dem Checkmk
eigenen Certificate Store unter [Global settings \> Site management \>
Trusted certificate authorities for SSL]{.guihint} bedienen. Es reicht
also, das Zertifikat bzw. die Zertifikate über die Zentralinstanz zu
importieren, ggf. auch über [Site specific global settings]{.guihint},
falls die Zentralinstanz unter verschiedenen URLs erreichbar ist.
:::
::::

:::::::::: sect3
#### []{#certificate_change .hidden-anchor .sr-only}Vorgehen beim Austausch eines Zertifikats {#heading_certificate_change}

::: paragraph
Wenn Sie mit einer eigenen Zertifizierungsinfrastruktur arbeiten,
verwenden Sie im Idealfall ein sehr lange gültiges Root-Zertifikat, mit
dessen zugehörigem Schlüssel regelmäßig Intermediate-Zertifikate
erstellt werden. Diese werden dann wiederum zum Signieren der
Server-Zertifikate verwendet. In diesem Fall rollen Sie
Intermediate-Zertifikate als Zertifikatskette *(Certificate Chain)* auf
dem Checkmk-Server aus. Den Hosts, die automatische Agenten-Updates
erhalten, muss nun lediglich das Root-Zertifikat bekannt gemacht werden.
:::

::: paragraph
Sind Sie unsicher, ob ein neues Server-Zertifikat ein neues
Root-Zertifikat erfordert, verwenden Sie den folgenden Befehl. Mit ihm
ermitteln Sie den Identifier des Root Keys, mit dem ein
Server-Zertifikat signiert wurde:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# openssl x509 -noout -text -in cert.pem | grep -A1 'X509v3 Authority Key'
            X509v3 Authority Key Identifier:
                14:2E:B3:17:B7:58:56:CB:AE:50:09:40:E6:1F:AF:9D:8B:14:C2:C6
```
:::
::::

::: paragraph
Ist der angezeigte Identifier beim alten und neuen Zertifikat identisch,
sind keine weiteren Maßnahmen erforderlich. Hosts, die diesem
Root-Zertifikat vertrauen, können auch bei Änderungen der
Zertifikatskette weiter Updates beziehen -- sofern die Kette korrekt im
System-Apache hinterlegt wurde.
:::

::: paragraph
Wurde bislang ein selbst signiertes Zertifikat oder ein kurzlebiges
Root-Zertifikat einer internen CA verwendet oder wurde der bisherige
Root-Schlüssel einer Ihrer internen CAs kompromittiert, ist beim
Austausch wie folgt vorzugehen:
:::

::: {.olist .arabic}
1.  Fügen Sie das neue Zertifikat über den Parameter [Certificates for
    HTTPS verification]{.guihint} (in der Regel [Agent updater (Linux,
    Windows, Solaris)]{.guihint}) hinzu.

2.  Backen Sie die Agentenpakete neu und führen Sie ein Update aller
    Hosts im Monitoring durch. Stellen Sie sicher, dass dieses Update
    für alle Hosts durchlaufen wurde, bevor Sie fortfahren.

3.  Tauschen Sie nun das Serverzertifikat aus.

4.  Testen Sie mit wenigen Hosts, bei denen bei Fehlschlag eine manuelle
    Neuinstallation des Agents leicht durchführbar ist, ob ein weiteres
    Update über das neue Zertifikat möglich ist.

5.  Konnte der letzte Schritt erfolgreich durchgeführt werden, können
    (das Zertifikat läuft ab) oder müssen (der Schlüssel wurde
    kompromittiert) Sie das alte Zertifikat entfernen und ein erneutes
    Agentenupdate durchführen.
:::
::::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_fehlerbehebung .hidden-anchor .sr-only}7. Fehlerbehebung {#heading__fehlerbehebung}

:::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::::::::::::::::::: sect2
### []{#faq .hidden-anchor .sr-only}7.1. Typische Fehler und ihre Ursachen {#heading_faq}

:::: sect3
#### []{#faq1 .hidden-anchor .sr-only}Bereits behobene Fehler im Service Checkmk Agent {#heading_faq1}

::: paragraph
Der Agent Updater wird nur einmal innerhalb des Update-Intervalls
wirklich ausgeführt. Ein Fehler wird also so lange angezeigt, bis Sie
das Plugin entweder manuell aufrufen oder das nächste Intervall ansteht.
:::
::::

:::: sect3
#### []{#faq2 .hidden-anchor .sr-only}Registrierung schlägt nach einer manuellen Neuinstallation des Checkmk-Agenten fehl {#heading_faq2}

::: paragraph
Der Agent Updater legt sich (unter Linux/Unix unter `/etc`, unter
Windows im `config`-Ordner) selbständig die Statusdatei
`cmk-update-agent.state` an. Diese verbleibt nach der Deinstallation
weiterhin auf dem Host, damit die Registrierungsinformationen nicht
verloren gehen. Eine neue Installation findet diese Datei ebenfalls
wieder und verwendet diese. Wenn dieser Effekt unerwünscht ist, löschen
Sie die Datei `cmk-update-agent.state` nach einer Deinstallation einfach
manuell.
:::
::::

:::: sect3
#### []{#faq3 .hidden-anchor .sr-only}Update-Status für Hosts, bei denen gar keine automatischen Updates aktiv sind {#heading_faq3}

::: paragraph
Auf der Seite [Monitor \> System \> Agent Update Status]{.guihint}
werden alle Hosts angezeigt, die sich im Monitoring befinden und für die
gleichzeitig eine Statusdatei auf dem Checkmk-Server existiert. Dabei
ist es ganz unerheblich, ob sich der Host tatsächlich für automatische
Updates beim Checkmk-Server meldet. Wird hier ein unerwarteter Host
angezeigt, lohnt sich ein Blick in den Ordner
`/omd/sites/mysite/var/check_mk/agent_deployment`, da sich hier
wahrscheinlich eine alte oder versehentlich erzeugte Registrierung
befindet.
:::
::::

::::::::::::: sect3
#### []{#faq4 .hidden-anchor .sr-only}Die Verbindung über SSL/TLS funktioniert nicht {#heading_faq4}

::: paragraph
Der Agent Updater ist so konzipiert, dass er explizit nur den
Zertifikaten vertraut, die in der Regel in [Agent updater (Linux,
Windows, Solaris)]{.guihint} bei der
[HTTPS-Konfiguration](#certificates_for_https) angegeben sind.
Insbesondere werden lokal installierte Zertifikate ignoriert. So kann es
auch vorkommen, dass der Checkmk-Server über den Browser erreichbar ist,
während der Agent Updater keine Verbindung (aufgrund einer falschen
Konfiguration) aufbauen kann.
:::

::: paragraph
Bei der HTTPS-Konfiguration der Agent-Updater-Regel muss ein
*Root-Zertifikat* angegeben werden, mit dem die Verbindung zum
Checkmk-Server verifiziert werden kann. Mit anderen Worten: Die
*Zertifikatskette,* die im *Server-Zertifikat* des Checkmk-Servers
hinterlegt ist, muss durch das hier angegebene Zertifikat verifiziert
werden können. Oft wird hier stattdessen das Server-Zertifikat
angegeben. Welches jedoch für diesen Zweck nicht geeignet ist.
:::

::: paragraph
Schauen Sie sich einmal die Zertifikatskette des Checkmk-Servers mit dem
Tool *OpenSSL* an. Aufgrund der Länge wird nur ein Ausschnitt gezeigt
und gekürzte Stellen mit `[...]` markiert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# openssl s_client -connect mymonitoring.example.net:443
[...]
subject=/CN=mymonitoring.example.net
issuer=/C=DE/O=Deutsche Telekom AG/OU=T-TeleSec Trust Center/CN=Deutsche Telekom Root CA 2
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 3832 bytes and written 302 bytes
Verification: OK
---
[...]
```
:::
::::

::: paragraph
Für den letzten Eintrag --- in unserem Fall
`subject=/CN=mymonitoring.example.net` --- benötigen Sie ein gültiges
Root-Zertifikat. Dieses muss nicht, wie in diesem Beispiel, unbedingt
der Aussteller des Zertifikats sein. In der Regel handelt es sich um
eine Kette von Ausstellern.
:::

::: paragraph
Schauen Sie sich anschließend das eingesetzte Zertifikat an. Auch hier
wird aufgrund der Länge wie oben gekürzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# openssl x509 -text -noout -in myca.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 38 (0x26)
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C = DE, O = Deutsche Telekom AG, OU = T-TeleSec Trust Center, CN = Deutsche Telekom Root CA 2
        Validity
            Not Before: Jul  9 12:11:00 1999 GMT
            Not After : Jul  9 23:59:00 2019 GMT
        Subject: C = DE, O = Deutsche Telekom AG, OU = T-TeleSec Trust Center, CN = Deutsche Telekom Root CA 2
        [...]
        X509v3 extensions:
            [...]
            X509v3 Basic Constraints:
                CA:TRUE, pathlen:5
            [...]
```
:::
::::

::: paragraph
Das oberste Zertifikat --- zu sehen in dem obigen Ausschnitt --- darf
keine Abhängigkeit zu einem anderen Zertifikat haben. Das können Sie
daran erkennen, dass der Aussteller (`Issuer`) und der Gegenstand
(`Subject`) identisch sind und die option `CA:TRUE` enthalten ist.
Zusätzlich muss die Kette der Aussteller, welche einen Gegenstand
beglaubigen, bis zu dem letzten Eintrag konsistent sein. Sie benötigen
also auch alle Zwischenzertifikate, wenn der Aussteller des letzten kein
CA sein sollte.
:::
:::::::::::::

::::::: sect3
#### []{#faq5 .hidden-anchor .sr-only}Fehlermeldung: Cannot open self cmk-update-agent or archive cmk-update-agent.pkg {#heading_faq5}

::: paragraph
Auf einigen Linux-Systemen ist das Programm *prelink* installiert und
ein cronjob aktiviert, der regelmäßig alle Binärdateien auf dem System
untersucht und gegebenenfalls anpasst, um die Programme zu
beschleunigen. Das Agent-Updater-Plugin wird aber mit dem Programm
*PyInstaller* paketiert, dessen Pakete zu solchen Maßnahmen nicht
kompatibel sind und dadurch *kaputt* gemacht werden. Checkmk hat daher
bei deb-/rpm-Paketen eine Blacklist-Eintrag hinterlegt, welcher unter
`/etc/prelink.conf.d` abgelegt wird und --- falls prelink vorhanden
ist --- einen Eintrag in der vorhandenen Datei `/etc/prelink.conf`
setzt. Da dieses Problem nur schwer zu fassen ist, kann es
dennoch --- insbesondere bei einer nachträglichen Einrichtung von
prelink --- dazu kommen, dass diese Maßnahmen nicht greifen.
:::

::: paragraph
Setzen Sie daher bei einer nachträglichen Installation von prelink den
Eintrag selbst und fügen Sie die folgende Zeile der Datei mit folgendem
Kommando hinzu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# echo "-c /etc/prelink.conf.d/cmk-update-agent.conf" >> /etc/prelink.conf
```
:::
::::
:::::::

:::: sect3
#### []{#faq6 .hidden-anchor .sr-only}Fehlermeldung cmk-update-agent: error while loading shared libraries: libz.so.1: failed to map segment from shared object {#heading_faq6}

::: paragraph
Diese Fehlermeldung tritt auf, wenn das `/tmp`-Verzeichnis mit dem Flag
`noexec` in das System eingehängt wurde. Um dieses Problem zu beheben,
können Sie entweder das Flag entfernen, oder --- weil Sie das Flag
bewusst gesetzt haben und benötigen --- auf dem Checkmk-Server im
[Setup]{.guihint} eine Regel unter [Agents \> Windows, Linux, Solaris,
AIX \> Agents \> Agent rules \> Installation paths for agent files
(Linux, UNIX)]{.guihint} anlegen. Dort können Sie das tmp-Verzeichnis in
der option [Directory for storage of temporary data (set TMPDIR
environment variable)]{.guihint} selbst definieren. Das
Agent-Updater-Plugin wird dann zukünftig temporäre Dateien in das
definierte Verzeichnis schreiben. Das klappt sogar, wenn Sie das Plugin
manuell mit dem Helferskript in `/usr/bin/cmk-update-agent` aufrufen.
:::
::::

:::: sect3
#### []{#faq7 .hidden-anchor .sr-only}RPM-Installation schlägt auf Red Hat Enterprise Linux/CentOS fehl {#heading_faq7}

::: paragraph
Es ist vereinzelt aufgetreten --- insbesondere auf
RedHat/CentOS-Systemen --- dass der vom automatischen Update ausgelöste
Aufruf von `rpm` wiederholt fehlschlägt, während ein manueller Aufruf
von `cmk-update-agent` erfolgreich durchläuft. Die Ursache lag in diesen
Fällen in einer SELinux-Policy, die einen fehlerfreien Aufruf verhindert
hat, wenn `rpm` von einem Kindprozess von `xinetd` aufgerufen wurde. Sie
können dem Problem z.B. durch Analyse von SELinux-Logs auf den Grund
gehen und ggf. die Policy mithilfe des Tools `audit2allow` entsprechend
anpassen.
:::
::::

:::::::::::::: sect3
#### []{#faq8 .hidden-anchor .sr-only}Fehlermeldung: No valid signature found {#heading_faq8}

::: paragraph
Wenn der Service [Check_MK Agent]{.guihint} die Warnung
`No valid signature found` anzeigt, bedeutet das, dass das
Agenten-Paket, welches in der Agentenbäckerei für den Host vorgesehen
ist, **nicht** mit einem der [akzeptierten Schlüssel](#signature_keys)
signiert wurde.
:::

:::: imageblock
::: content
![agent deployment no valid
signature](../images/agent_deployment_no_valid_signature.png)
:::
::::

::: paragraph
Im einfachsten Fall genügt es, wenn Sie Ihre Agenten mit Hilfe der
Funktion [Sign agents]{.guihint} in der Agentenbäckerei mit einem der
Schüssel signieren, die unter [Signature keys the agent will
accept]{.guihint} angezeigt werden.
:::

:::: imageblock
::: content
![agent deployment sign
agent](../images/agent_deployment_sign_agent.png)
:::
::::

::: paragraph
Sobald der Agent Updater des betroffenen Hosts sich das nächste mal beim
Checkmk-Server gemeldet hat **und** anschließend das Cache-Intervall des
Service abgelaufen ist, wird die Warnung verschwinden.
:::

::: paragraph
Falls der Host allerdings keinen einzigen Signaturschlüssel (mehr)
kennt, der auf dem Checkmk-Server liegt, müssen Sie das [Backen und
signieren](#bakery) mit einem unter [Signature keys the agent will
accept]{.guihint} angezeigten Schlüssel wiederholen, den gebackenen
Agenten im Anschluss auf den betroffenen Host kopieren und dort neu
installieren.
:::

::: paragraph
Auf einem betroffenen Host können Sie `cmk-update-agent -v` bzw.
`check_mk_agent.exe updater -v` ausführen, um weitere Details zu diesem
Fehler zu erhalten. In der detaillierten Fehlermeldung werden explizit
die Signaturen aus der [Konfigurationsdatei des
Agent-Updater-Plugins](#files) angegeben, die kein akzeptiertes (sprich:
konfiguriertes) Gegenstück auf Ihrem Checkmk-Server haben.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Ignoring signature #1 for certificate: certificate is unknown.
No valid signature found.
```
:::
::::
::::::::::::::
:::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}8. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: sect2
### []{#_pfade_auf_dem_checkmk_server .hidden-anchor .sr-only}8.1. Pfade auf dem Checkmk-Server {#heading__pfade_auf_dem_checkmk_server}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/var/check_mk/agents/`          | Enthält die gebackenen Agenten,   |
|                                   | geordnet zuerst in                |
|                                   | Unterverzeichnissen nach          |
|                                   | Betriebssystemen (z.B.            |
|                                   | `linux_rpm`) und darunter nach    |
|                                   | Hosts per Soft-Link.              |
+-----------------------------------+-----------------------------------+
| `                                 | Enthält Dateien mit den Namen der |
| ~/var/check_mk/agent_deployment/` | registrierten Hosts. Eine solche  |
|                                   | Datei enthält den Zeitpunkt der   |
|                                   | letzten Registrierung und das     |
|                                   | *Host Secret.*                    |
+-----------------------------------+-----------------------------------+
:::

::: sect2
### []{#_pfade_auf_dem_überwachten_linux_unix_host .hidden-anchor .sr-only}8.2. Pfade auf dem überwachten Linux-/Unix-Host {#heading__pfade_auf_dem_überwachten_linux_unix_host}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `/usr/lib/check_mk_age            | Das Agent-Updater-Plugin als      |
| nt/plugins/3600/cmk-update-agent` | Binärdatei oder Skript, abhängig  |
|                                   | von der Konfiguration als         |
|                                   | [ausführbares                     |
|                                   | Format.](#executable_format) Das  |
|                                   | Unterverzeichnis `3600` steht     |
|                                   | dabei für das [Intervall für den  |
|                                   | Update-C                          |
|                                   | heck](#interval_for_update_check) |
|                                   | in Sekunden (hier für den         |
|                                   | Standardwert von einer Stunde).   |
+-----------------------------------+-----------------------------------+
| `/usr/bin/cmk-update-agent`       | Skript zum Aufruf des             |
|                                   | Agent-Updater-Plugins und zur     |
|                                   | Registrierung des Agenten mit dem |
|                                   | Kommando                          |
|                                   | `cmk-update-agent register`       |
+-----------------------------------+-----------------------------------+
| `/e                               | Konfigurationsdatei des           |
| tc/check_mk/cmk-update-agent.cfg` | Agent-Updater-Plugins, die die    |
|                                   | Einstellungen der Regel [Agent    |
|                                   | updater (Linux, Windows,          |
|                                   | Solaris)]{.guihint} enthält.      |
|                                   | Editieren Sie diese Datei nicht,  |
|                                   | denn Sie wird bei der             |
|                                   | Installation und beim Update      |
|                                   | geschrieben.                      |
+-----------------------------------+-----------------------------------+
| `/etc/cmk-update-agent.state`     | Datei mit                         |
|                                   | Registrierungsinformationen       |
|                                   | inklusive des *Host Secrets*      |
+-----------------------------------+-----------------------------------+
| `/var/lib/che                     | Ausführliche Log-Datei mit        |
| ck_mk_agent/cmk-update-agent.log` | DEBUG-Meldungen                   |
+-----------------------------------+-----------------------------------+
:::

::: sect2
### []{#_pfade_auf_dem_überwachten_windows_host .hidden-anchor .sr-only}8.3. Pfade auf dem überwachten Windows-Host {#heading__pfade_auf_dem_überwachten_windows_host}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `C:\ProgramData\checkmk\agent\plu | Das Agent-Updater-Plugin als      |
| gins\cmk_update_agent.checkmk.py` | Python-Datei                      |
+-----------------------------------+-----------------------------------+
| `C:\Program Files (x86)\ch        | Agentenprogramm zur Registrierung |
| eckmk\service\check_mk_agent.exe` | des Agenten mit dem Kommando      |
|                                   | `che                              |
|                                   | ck_mk_agent.exe updater register` |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\checkmk\a         | Konfigurationsdatei des           |
| gent\config\cmk-update-agent.cfg` | Agent-Updater-Plugins             |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\checkmk\age       | Datei mit                         |
| nt\config\cmk-update-agent.state` | Registrierungsinformationen       |
|                                   | inklusive des *Host Secrets*      |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\checkm            | Ausführliche Log-Datei mit        |
| k\agent\log\cmk-update-agent.log` | DEBUG-Meldungen                   |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\checkmk\          | Von der Agentenbäckerei erstellte |
| agent\bakery\check_mk.bakery.yml` | Konfigurationsdatei, die u.a. das |
|                                   | Intervall für den Update-Check    |
|                                   | definiert.                        |
+-----------------------------------+-----------------------------------+
:::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
