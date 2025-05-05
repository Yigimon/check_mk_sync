:::: {#header}
# Automatisch Hosts erstellen

::: details
[Last modified on 28-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/hosts_autoregister.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Linux
überwachen](agent_linux.html) [Windows überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#autoregister .hidden-anchor .sr-only}1. Die Autoregistrierung {#heading_autoregister}

::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Cloud-Systeme wie
[Amazon Web Services (AWS)](monitoring_aws.html), [Microsoft
Azure](monitoring_azure.html) oder [Google Cloud Platform
(GCP)](monitoring_gcp.html) erzeugen und löschen selbständig Objekte,
die in Checkmk [Hosts](glossar.html#host) entsprechen. Damit diese
Cloud-Objekte nach ihrer Entstehung ohne Verzögerung als Hosts ins
Monitoring von Checkmk aufgenommen werden können, ist eine Lösung ohne
manuelles Eingreifen gefragt.
:::

::: paragraph
Mit der *Autoregistrierung* gibt Checkmk die Antwort --- und kann Hosts
automatisch erstellen lassen. Da die automatische Host-Erstellung vor
allem für die Cloud-Umgebungen benötigt wird, ist die Autoregistrierung
erst ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** verfügbar, d. h. in Checkmk Cloud und Checkmk MSP.
:::

::: paragraph
Die Autoregistrierung erfolgt durch Kommunikation zwischen dem
[Checkmk-Agenten](wato_monitoringagents.html#agents) und dem
Checkmk-Server. Der Agent Controller des Agenten stellt eine Anfrage zur
Registrierung an den Agent Receiver des Servers und übermittelt dabei
die zur Erstellung des Hosts notwendigen Daten. Wenn der Agent Receiver
die Anfrage akzeptiert, wird die Registrierung durchgeführt und eine
TLS-verschlüsselte Verbindung aufgebaut. Der Host wird erstellt, eine
[Service-Erkennung](glossar.html#service_discovery) durchgeführt und die
Änderungen aktiviert, so dass der Host in die
[Monitoring-Umgebung](glossar.html#monitoring_environment) aufgenommen
wird --- alles vollautomatisch.
:::

::: paragraph
Damit dieser Automatismus funktioniert, ist natürlich eine entsprechende
Vorbereitung notwendig. Los geht es mit der Checkmk-Instanz: mit der
Erstellung eines Benutzers, der die Berechtigung zur Autoregistrierung
besitzt, eines Ordners, in dem die Hosts erstellt werden sollen, und
einer Regel, mit der der Agent Receiver Registrierungsanfragen ohne
manuellen Eingriff abarbeiten kann. Bei der Konfiguration des Ordners
können Sie übrigens festlegen, ob die Agenten der dort zu erstellenden
Hosts im [Pull-Modus](glossar.html#pull_mode) oder im
[Push-Modus](glossar.html#push_mode) arbeiten sollen.
:::

::: paragraph
Dann folgt der Checkmk-Agent: Hier werden per Agentenregel die
Informationen für eine Registrierungsanfrage festgelegt und dann mit der
Agentenbäckerei in ein Agentenpaket verpackt. Dieses für die
Autoregistrierung konfigurierte Agentenpaket wird abschließend auf den
Hosts installiert, die eine Autoregistrierung durchführen können sollen.
:::

::: paragraph
Wie das alles genau abläuft, wird in den folgenden Kapiteln erklärt.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup_autoregister .hidden-anchor .sr-only}2. Autoregistrierung einrichten {#heading_setup_autoregister}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#user .hidden-anchor .sr-only}2.1. Benutzer für die Autoregistrierung auswählen {#heading_user}

::: paragraph
Die Berechtigungen, die zur Registrierung des Agenten beim
Checkmk-Server (für die TLS-verschlüsselte Datenübertragung) und zur
Erstellung von Hosts benötigt werden, sind in der
[Rolle](wato_user.html#roles) [Agent registration user]{.guihint}
enthalten. Dabei sind in dieser Rolle die Berechtigungen zur
Registrierung *neuer* Hosts nur ab Checkmk Cloud verfügbar.
:::

::: paragraph
Diese Rolle ist dem [Automationsbenutzer](glossar.html#automation_user)
`agent_registration` zugewiesen, der in jeder Checkmk-Instanz
eingerichtet ist und dessen Eigenschaften Sie sich über [Setup \> Users
\> Users]{.guihint} anzeigen lassen können:
:::

::::: imageblock
::: content
![Dialog mit den Eigenschaften des Automationsbenutzer
\'agent_registration\'.](../images/hosts_autoregister_user.png)
:::

::: title
Dieser Automationsbenutzer hat standardmäßig nur die Rolle [Agent
registration user]{.guihint}
:::
:::::

::: paragraph
Es bietet sich an, für die Autoregistrierung diesen Automationsbenutzer
zu verwenden, der nichts anderes darf, als Hosts zu registrieren.
:::
:::::::::

::::::::::: sect2
### []{#new_folder .hidden-anchor .sr-only}2.2. Ordner für die neuen Hosts einrichten {#heading_new_folder}

::: paragraph
Die automatisch erstellten Hosts sollen in einem neuen Ordner angelegt
werden. Sie können alternativ auch einen bestehenden Ordner verwenden,
wenn Sie ihn so konfigurieren, wie es im Folgenden beschrieben ist.
:::

::: paragraph
Starten Sie die Erstellung eines Ordners mit [Setup \> Hosts \> Hosts \>
Add folder.]{.guihint} Geben Sie dem Ordner im Kasten [Basic
settings]{.guihint} einen Namen.
:::

::: paragraph
Im Kasten [Network address]{.guihint} geht es um die Option [IP address
family.]{.guihint} Sollen die Checkmk-Agenten der zu erstellenden Hosts
den [Pull-Modus](glossar.html#pull_mode) verwenden, können Sie den
Standardwert [IPv4 only]{.guihint} unverändert lassen. Für den
[Push-Modus](glossar.html#push_mode) wählen Sie den Wert [No
IP]{.guihint} aus. Damit verhindern Sie, dass die Erreichbarkeit des
Hosts per [Smart Ping](cmc_differences.html#smartping) überprüft wird.
:::

::: paragraph
Im folgenden Kasten [Monitoring agents]{.guihint} setzen Sie zwei
wichtige Optionen für die Autoregistrierung. Mit [Checkmk agent
connection mode]{.guihint} entscheiden Sie, ob der Checkmk-Agent im
Pull-Modus oder (wie im folgenden Bild) im Push-Modus arbeiten soll.
Diese Option gibt es nur ab Checkmk Cloud. Aktivieren Sie schließlich
bei [Bake agent packages]{.guihint} die Checkbox [Bake a generic agent
package for this folder.]{.guihint} Damit nutzen Sie die Möglichkeit der
[Agentenbäckerei](glossar.html#agent_bakery), eine
[Agentenkonfiguration](wato_monitoringagents.html#agent_configurations)
für einen Ordner und alle darin enthaltenen **und** hinzukommenden Hosts
zu erstellen.
:::

::::: imageblock
::: content
![Dialog zur Erstellung eines neuen Ordners für die
Autoregistrierung.](../images/hosts_autoregister_new_folder.png)
:::

::: title
Die Konfiguration eines Ordners für den Push-Modus
:::
:::::

::: paragraph
Schließen Sie die Erstellung des Ordners mit [Save]{.guihint} ab.
:::
:::::::::::

:::::::::::::::::::::::: sect2
### []{#rule_autoregister_site .hidden-anchor .sr-only}2.3. Regel für die Checkmk-Instanz erstellen {#heading_rule_autoregister_site}

::: paragraph
Die Entscheidung darüber, welche Hosts sich automatisch registrieren
dürfen, welche Namen sie erhalten und was sonst noch nach der
Registrierung mit ihnen geschieht, wird in Checkmk --- wenig
überraschend --- mit Regeln getroffen. Dabei spielen die Labels, mit
denen sich der Agent des Hosts bei der Registrierung meldet, eine
entscheidende Rolle. Doch der Reihe nach.
:::

::: paragraph
Den Regelsatz [Agent registration]{.guihint} gibt es nur ab Checkmk
Cloud. Sie finden ihn unter [Setup \> Agents]{.guihint} (sofern der
[Show-more-Modus](intro_gui.html#show_less_more) aktiv ist) oder über
die Suche im [Setup]{.guihint}-Menü. Starten Sie mit [Add
rule]{.guihint} die Erstellung einer neuen Regel und vergeben Sie im
ersten Kasten [Properties,]{.guihint} wie bei Checkmk gewohnt, zuerst
eine ID und einen Titel.
:::

::: paragraph
Im folgenden Kasten [Matching criteria]{.guihint} bestimmen Sie, welche
Labels akzeptiert werden, wenn der Checkmk-Server eine Anfrage zur
Registrierung von einem Agenten erhält. Diese *Agenten-Labels* werden
ausschließlich für die Autoregistrierung verwendet und sind andere als
die [Labels](glossar.html#label), die sonst in Checkmk zur Kennzeichnung
von Hosts und Services verwendet werden. Zwei Agenten-Labels werden vom
Checkmk-Agenten geliefert und können in der Liste ausgewählt werden:
`cmk/hostname-simple` enthält den Host-Namen ohne Domain-Anteil (daher
`simple`) und ist für die Bestimmung eines eindeutigen Host-Namens in
Checkmk gedacht. `cmk/os-family` liefert das Betriebssystem des Hosts
und kann z.B. für die Ablage der Hosts in unterschiedlichen Ordnern
verwendet werden. Sie können mit [Custom label]{.guihint} aber auch Ihre
eigenen Labels eintragen.
:::

::: paragraph
Dabei wird das durch Doppelpunkt getrennte Schlüssel-Wert-Paar, aus dem
sich ein Label zusammensetzt (z.B. `cmk/os-family:linux`) separat
ausgewertet. So können Sie gezielt festlegen, dass ein Schlüssel (z.B.
`cmk/os-family`) vorhanden sein muss ([Exists]{.guihint}), nicht
vorhanden sein darf ([Does not exist]{.guihint}) oder nur mit einem
vorgegebenen Wert ([Equals]{.guihint}) akzeptiert wird. Als Wert können
Sie auch einen [regulären Ausdruck](regexes.html) ([Regex]{.guihint})
eingeben. Wenn Sie mehrere Agenten-Labels festlegen, werden diese
logisch mit UND verknüpft. Im folgenden Beispiel soll neben dem
vordefinierten Label `cmk/hostname-simple` auch noch das
benutzerdefinierte Label `my_autoregister_label` geprüft werden:
:::

::::: imageblock
::: content
![Regel zur Autoregistrierung mit Festlegung der zulässigen
Labels.](../images/hosts_autoregister_rule_matching_criteria.png)
:::

::: title
Hier wird überprüft, ob die Label mit den Schlüsseln
`cmk/hostname-simple` und `my_autoregister_label` existieren
:::
:::::

::: paragraph
**Hinweis**: Jeder Host, der erfolgreich automatisch registriert wurde,
erhält von Checkmk das Host-Label `cmk/agent_auto_registered:yes`
angehängt. Dieses Label können Sie aber hier nicht verwenden, da es kein
Agenten-Label ist und erst *nach* der Registrierung vergeben wird.
:::

::: paragraph
Im nächsten Kasten [Action]{.guihint} bestimmen Sie, was passieren soll,
wenn die Auswertung der Labels greift: Den Host erstellen oder eben
nicht. Bei Auswahl von [Stop and do not create hosts]{.guihint} ist die
Regelauswertung abgeschlossen und die beiden folgenden Kästen werden
nicht mehr betrachtet. In unserem Beispiel sollen aber Hosts erstellt
werden:
:::

::::: imageblock
::: content
![Regel zur Autoregistrierung mit Festlegung der durchzuführenden
Aktion.](../images/hosts_autoregister_rule_action.png)
:::

::: title
Die Standardaktion ist die Erstellung der Hosts
:::
:::::

::: paragraph
Im Kasten [Hostname computation]{.guihint} legen Sie nun fest, welchen
Namen der Host erhalten soll. Im Feld [Hostname template]{.guihint}
geben Sie die Vorlage ein. Hier können Sie per Makro auf die Werte
derjenigen Agenten-Labels zugreifen, die Sie im obigen Kasten [Matching
criteria]{.guihint} ausgewählt haben, z. B. mit `$cmk/hostname-simple$`
auf den vom Checkmk-Agenten gelieferten einfachen Host-Namen. Die
Vorlage können Sie dann, wenn gewünscht, verändern durch Umwandlung in
Klein- oder Großbuchstaben sowie Ersetzungen mit regulären Ausdrücken
und mit expliziten Host-Namen. Dies sind übrigens die gleichen Optionen,
die es bei der [Anpassung der Namen von Piggyback
Hosts](piggyback.html#renamehosts) gibt. Mehr Informationen finden Sie
auch in der [Inline-Hilfe.](user_interface.html#inline_help)
:::

::::: imageblock
::: content
![Regel zur Autoregistrierung mit Festlegung des
Host-Namens.](../images/hosts_autoregister_rule_hostname_computation.png)
:::

::: title
Übernahme des einfachen Host-Namens, ergänzt um den Prefix `push-`
:::
:::::

::: paragraph
Zum Schluss wählen Sie dann noch im Kasten [Host creation]{.guihint} den
[vorbereiteten Ordner](#new_folder) aus, in dem die neuen Hosts landen
sollen. Zusätzlich können Sie noch Attribute bestimmen, die dem Host
mitgegeben werden sollen. Mehr zu diesen Attributen erfahren Sie im
Artikel zur [Verwaltung der Hosts.](hosts_setup.html#create_hosts)
:::

::::: imageblock
::: content
![Regel zur Autoregistrierung mit Festlegung des Zielordners und der
Host-Attribute.](../images/hosts_autoregister_rule_host_creation.png)
:::

::: title
Die neuen Hosts sollen im vorbereiteten Ordner `Autoregistered` erstellt
werden
:::
:::::

::: paragraph
Nach dem Sichern der Regel, kehren Sie zur Seite [Agent
registration]{.guihint} zurück. Hier finden Sie den [Agent labels
simulator]{.guihint}. Wenn Sie viele Regeln definiert haben, hilft Ihnen
der Simulator dabei, den Überblick zu behalten. Sie können
Agenten-Labels eingeben und mit [Try out]{.guihint} simulieren, ob und
welche Regel bei der Übermittlung eines Agenten-Labels greift. Im
Ergebnis sehen Sie dann die farbigen Ampelsymbole, die im Artikel zu den
[Regeln](wato_rules.html#analyse_traffic_light) beschrieben sind.
:::
::::::::::::::::::::::::

::::::::::: sect2
### []{#rule_autoregister_bakery .hidden-anchor .sr-only}2.4. Regel für die Agentenbäckerei erstellen {#heading_rule_autoregister_bakery}

::: paragraph
Nachdem im vorherigen Abschnitt die Checkmk-Instanz konfiguriert wurde,
geht es jetzt um den Agent Controller des Checkmk-Agenten. Hierfür
nutzen Sie den [Agent controller auto-registration]{.guihint} Regelsatz
der Agentenbäckerei, der nur ab Checkmk Cloud vorhanden ist. Sie finden
den Regelsatz in der Agentenbäckerei unter [Agent rules]{.guihint} oder
am schnellsten über die Suche im [Setup]{.guihint}-Menü. Erstellen Sie
eine neue Regel.
:::

::: paragraph
In Kasten [Agent controller auto-registration]{.guihint} geben Sie dem
Agent Controller alle Informationen mit, die dieser für eine
Registrierungsanfrage beim Agent Receiver benötigt: den Checkmk-Server
([Monitoring server address]{.guihint}), gegebenenfalls mit der
Portnummer des Agent Receivers ([Agent receiver port]{.guihint}), die
Checkmk-Instanz ([Site to register with]{.guihint}) und den
[Automationsbenutzer](#user) für die Autoregistrierung.
:::

::: paragraph
Sie können auch hier mit [Additional agent labels to send during
registration]{.guihint} eigene Labels definieren. Damit die
Autoregistrierung funktioniert, müssen diese Labels zu denen passen, die
Sie in der [Regel für die Checkmk-Instanz](#rule_autoregister_site) als
[Custom label]{.guihint} eingetragen haben: im Beispiel also das zuvor
gesetzte benutzerdefinierte Label mit dem Schlüssel
`my_autoregister_label`.
:::

::: paragraph
Mit der letzten Option [Keep existing connections]{.guihint} bestimmen
Sie, ob der Agent Controller bereits existierende Verbindungen löschen
([no]{.guihint}) oder behalten soll ([yes]{.guihint}). Wenn Sie neben
der automatischen Registrierung einer Verbindung auch manuelle
Verbindungen zu anderen Checkmk-Instanzen konfiguriert haben, und diese
auch nach einem Neustart des Agent Controllers `cmk-agent-ctl` behalten
wollen, sollten Sie diese Option auf [yes]{.guihint} setzen.
:::

::::: imageblock
::: content
![Regel zur Autoregistrierung für die
Agentenbäckerei.](../images/hosts_autoregister_rule_agent_bakery.png)
:::

::: title
Die Werte für die Agentenbäckerei müssen zu denen der Checkmk-Instanz
passen
:::
:::::

::: paragraph
**Wichtig:** Im letzten Kasten [Conditions]{.guihint} dieser Regel
wählen Sie als [Folder]{.guihint} erneut den vorbereiteten Ordner aus.
:::
:::::::::::

::::::: sect2
### []{#bake .hidden-anchor .sr-only}2.5. Agentenpaket backen {#heading_bake}

::: paragraph
Nun geht es weiter in der Agentenbäckerei mit [Setup \> Agents \>
Windows, Linux, Solaris, AIX.]{.guihint} Klicken Sie auf [![Symbol zum
Backen der
Agenten.](../images/icons/button_bake_agents.png)]{.image-inline} und
backen Sie sich einen neuen Agenten. Als Ergebnis erhalten Sie
zusätzlich zur Agentenkonfiguration [Vanilla (factory
settings)]{.guihint} eine neue Zeile für die Konfiguration, in der die
Regel eingebacken ist, die im vorherigen Abschnitt erstellt wurde:
:::

::::: imageblock
::: content
![Liste mit der neuen Konfiguration der Agenten für die
Autoregistrierung.](../images/hosts_autoregister_baked_agent.png)
:::

::: title
Die Spalte [Agent type]{.guihint} zeigt, dass die neue Konfiguration
spezifisch für den konfigurierten Ordner ist
:::
:::::
:::::::

:::: sect2
### []{#install .hidden-anchor .sr-only}2.6. Agentenpaket herunterladen und installieren {#heading_install}

::: paragraph
Das Agentenpaket muss nun auf jedem Host installiert werden, der eine
Autoregistrierung starten soll. Laden Sie das für das Betriebssystem des
Hosts passende Agentenpaket herunter und installieren Sie es auf dem
Host. Das Vorgehen ist genauso, wie in der Agentenbäckerei üblich. Mehr
dazu finden Sie in den Artikeln zu den
[Monitoring-Agenten](wato_monitoringagents.html#bakery_download), dem
[Linux-Agenten](agent_linux.html#install) und dem
[Windows-Agenten.](agent_windows.html#install)
:::
::::

::::::::::::: sect2
### []{#success .hidden-anchor .sr-only}2.7. Erfolgskontrolle {#heading_success}

::: paragraph
Nach der Installation des Agentenpakets wertet der Agent Controller die
Datei `/var/lib/cmk-agent/pre_configured_connections.json` aus und setzt
für eine darin enthaltene Verbindung den Befehl zur Registrierung ab.
Wenn der Agent Receiver akzeptiert, wird die Verbindung eingerichtet und
der Host in der Checkmk-Instanz erstellt.
:::

::::: imageblock
::: content
![Inhalt des Ordners für die Autoregistrierung mit dem automatisch
erstellten Host.](../images/hosts_autoregister_setup_new_host.png)
:::

::: title
Der automatisch erstellte Host im Setup
:::
:::::

::: paragraph
Anschließend wird die
[Service-Erkennung](glossar.html#service_discovery) durchgeführt und die
[Änderungen aktiviert](glossar.html#activate_changes), damit der Host
auch im Monitoring sichtbar ist. Beachten Sie, dass bei der
automatischen Aktivierung alle anderen gesammelten Änderungen --- auch
von anderen Benutzern --- mit aktiviert werden.
:::

::: paragraph
Es kann insgesamt einige (bis zu 5) Minuten dauern von der Installation
des Agentenpakets bis zum Erscheinen des Hosts im Monitoring. Die
einzelnen Schritte können Sie in [Setup \> General \> Audit
log]{.guihint} nach Auswahl der Datei `wato_audit.log` nachverfolgen.
:::

::: paragraph
Auf dem Host können Sie sich den Verbindungsstatus des Agent Controllers
per Kommando ausgeben lassen, der nach einer erfolgreichen Registrierung
im Push-Modus etwa so aussieht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl status
Version: 2.3.0b1
Agent socket: operational
IP allowlist: any


Connection: myserver/mysite
   UUID: b11af975-40a8-4574-b6cd-12dc11c6f273
   Local:
       Connection mode: push-agent
       Connecting to receiver port: 8000
       Certificate issuer: Site 'mysite' agent signing CA
       Certificate validity: Tue, 13 Feb 2024 12:50:35 +0000 - Tue, 13 Feb 2029 12:50:35 +0000
   Remote:
       Connection mode: push-agent
       Registration state: discoverable
       Host name: push-myhost
```
:::
::::

::: paragraph
Automatisch erstellte Hosts können Sie auch wieder [automatisch
entfernen lassen.](hosts_setup.html#hosts_autoremove) Ab Checkmk Cloud
bietet Checkmk damit die beiden wichtigsten Komponenten für das
*Lifecycle Management* von Hosts. Übrigens funktioniert die automatische
Entfernung auch für manuell erstellte Hosts --- und das in allen
Editionen.
:::
:::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#test .hidden-anchor .sr-only}3. Test und Fehlerdiagnose {#heading_test}

::::::::::: sectionbody
::: paragraph
Die einzelnen Schritte für die Erstellung des Hosts im Monitoring
(Erstellung des Hosts im Setup, Service-Erkennung und Aktivierung)
können Sie in der Checkmk-Instanz unter [Setup \> General \> Audit
log]{.guihint} nachverfolgen. Die erfolgreiche automatische
Registrierung überprüfen Sie auf dem Host mit dem Befehl
`cmk-agent-ctl status`.
:::

::: paragraph
Diese im vorherigen Abschnitt genannten Prüfungen zur Erfolgskontrolle
zeigen allerdings nur im Erfolgsfall die gewünschten Ergebnisse. Wenn
Sie dort nicht das sehen, was oben gezeigt ist, kann dies daran liegen,
dass eine Registrierungsanfrage vom Agent Controller zwar abgesetzt,
aber vom Agent Receiver nicht akzeptiert wurde.
:::

::: paragraph
Eine Übersicht über alle Registrierungsanfragen, die von der
Checkmk-Instanz *abgelehnt* wurden, erhalten Sie auf der Seite [Agent
registration]{.guihint}, auf der Sie weiter oben die [Regel für die
Checkmk-Instanz](#rule_autoregister_site) erstellt haben. Eine Ablehnung
kann allerlei Gründe haben. Im folgenden Bild sehen Sie zwei davon: ein
Schreibfehler (`my_autoregister_labell`) im vom Agenten übermittelten
Agenten-Label und einen Host, der bereits existiert:
:::

::::: imageblock
::: content
![Liste der abgelehnten Anfragen zur
Autoregistrierung.](../images/hosts_autoregister_declined_requests.png)
:::

::: title
Zwei abgelehnte Registrierungsanfragen
:::
:::::

::: paragraph
Für jede abgelehnte Anfrage können Sie in der ersten Spalte
[Actions]{.guihint} eine Simulation starten, deren Ergebnis in der
letzten Spalte [Simulation result]{.guihint} angezeigt wird.
:::

::: paragraph
Für eine darüber hinausgehende Fehlerdiagnose finden Sie in den Artikeln
zum [Linux-Agenten](agent_linux.html#test) und zum
[Windows-Agenten](agent_windows.html) weitere Informationen --- unter
anderem zu den Themen Kommunikation zwischen Agent und Checkmk-Instanz
sowie zur (manuellen) Registrierung.
:::
:::::::::::
::::::::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: sect2
### []{#_pfade_auf_dem_überwachten_linux_host .hidden-anchor .sr-only}4.1. Pfade auf dem überwachten Linux-Host {#heading__pfade_auf_dem_überwachten_linux_host}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `/var/lib/cmk-agent           | Enthält eine Liste der mit dem Agent |
| /registered_connections.json` | Controller registrierten             |
|                               | Verbindungen.                        |
+-------------------------------+--------------------------------------+
| `/var/lib/cmk-agent/pre       | Enthält eine vorkonfigurierte und    |
| _configured_connections.json` | per Agentenbäckerei in das           |
|                               | Agentenpaket integrierte Verbindung  |
|                               | zu einer Instanz für die             |
|                               | Autoregistrierung ab Checkmk Cloud.  |
+-------------------------------+--------------------------------------+
:::

::: sect2
### []{#_pfade_auf_dem_überwachten_windows_host .hidden-anchor .sr-only}4.2. Pfade auf dem überwachten Windows-Host {#heading__pfade_auf_dem_überwachten_windows_host}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `C:\ProgramData\checkmk\agent | Enthält eine Liste der mit dem Agent |
| \registered_connections.json` | Controller registrierten             |
|                               | Verbindungen.                        |
+-------------------------------+--------------------------------------+
| `C:\                          | Enthält eine vorkonfigurierte und    |
| ProgramData\checkmk\agent\pre | per Agentenbäckerei in das           |
| _configured_connections.json` | Agentenpaket integrierte Verbindung  |
|                               | zu einer Instanz für die             |
|                               | Autoregistrierung ab Checkmk Cloud.  |
+-------------------------------+--------------------------------------+
:::

::: sect2
### []{#_pfade_auf_dem_checkmk_server .hidden-anchor .sr-only}4.3. Pfade auf dem Checkmk-Server {#heading__pfade_auf_dem_checkmk_server}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/var/agen                   | Enthält für jede Verbindung deren    |
| t-receiver/received-outputs/` | UUID als Softlink, der auf den       |
|                               | Ordner mit der Agentenausgabe zeigt. |
+-------------------------------+--------------------------------------+
| `~/va                         | Log-Datei für die                    |
| r/log/agent-registration.log` | Agentenregistrierung. Sie können die |
|                               | Ausführlichkeit der Meldungen in 6   |
|                               | Stufen steuern über [Setup \>        |
|                               | General \> Global settings \> User   |
|                               | interface \> Logging \> Agent        |
|                               | registration.]{.guihint}             |
+-------------------------------+--------------------------------------+
| `~/var/log/agent-receiver/`   | Enthält die Log-Dateien des Agent    |
|                               | Receivers.                           |
+-------------------------------+--------------------------------------+
:::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
