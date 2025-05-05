:::: {#header}
# Checkmk aufsetzen

::: details
[Last modified on 25-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_setup.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Checkmk-Oberfläche](intro_gui.html) [Grundsätzliches zur
Installation von Checkmk](install_packages.html) [Instanzen (Sites) mit
omd verwalten](omd_basics.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#editions .hidden-anchor .sr-only}1. Edition auswählen {#heading_editions}

::::::::::: sectionbody
::: paragraph
Bevor Sie beginnen, Checkmk zu installieren, müssen Sie sich zuerst
entscheiden, welche der verfügbaren Editionen Sie einsetzen möchten:
:::

::: paragraph
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** ist kostenlos, zu 100 % Open Source und enthält Nagios
als Kern. Sie können damit komplexe Umgebungen umfassend überwachen.
Support erhalten Sie in unserem
[Forum](https://forum.checkmk.com){target="_blank"} von der Checkmk
Community.
:::

::: paragraph
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise** richtet sich vor allem an professionelle Anwender
und bietet über den Umfang von Checkmk Raw hinaus eine Reihe von
interessanten Features, wie z.B. mit dem [Checkmk Micro Core
(CMC)](cmc.html) einen sehr performanten, eigenen Kern (der Nagios
ersetzt), eine flexible Verteilung der Checkmk
[Monitoring-Agenten](glossar.html#agent) (die die Informationen der
überwachten Zielsysteme beschaffen), eine große Anzahl von
ausgeklügelten Dashlets zum Einbau in
[Dashboards,](glossar.html#dashboard) ein Reporting, und vieles mehr.
Für Checkmk Enterprise können Sie optional [von
uns](https://checkmk.com/de/produkt/support){target="_blank"} oder einem
[unserer
Partner](https://checkmk.com/de/partner/partner-finden){target="_blank"}
professionellen Support erhalten.
:::

::: paragraph
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** erweitert den Funktionsumfang von Checkmk Enterprise
um Funktionen, die in Cloud-Umgebungen wie Amazon Web Services (AWS) und
Microsoft Azure nützlich sind, wie z.B. spezielle Check-Plugins,
Dashboards oder die Kombination von Autoregistrierung und Konfiguration
des Checkmk-Agenten im [Push-Modus.](glossar.html#push_mode) Mehr
Details zu Checkmk Cloud finden Sie in [diesem Artikel.](cce.html)
:::

::: paragraph
Sie können Checkmk Cloud unverbindlich testen, denn sie ist in den
ersten 30 Tagen (im Lizenzstatus „Trial") nicht limitiert. In kleinem
Rahmen, d.h. mit einer Instanz und bis zu 750 Services, können Sie
Checkmk mit Checkmk Cloud auch dauerhaft ohne Lizenzierung im
Lizenzstatus „Free" betreiben. Die Eingabe eines Lizenzschlüssels nach
spätestens 30 Tagen ist nur notwendig, falls Sie Checkmk Cloud ohne
Beschränkungen einsetzen möchten.
:::

::: paragraph
Die
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** ist eine mandantenfähige Erweiterung von Checkmk Cloud
und verfügt über alle notwendigen Funktionen, um mit Checkmk über das
[verteilte Monitoring](glossar.html#distributed_monitoring) voneinander
abgeschottete Instanzen für mehrere Kunden zu betreiben. Falls Sie als
Provider für Ihre Kunden diese Dienste anbieten wollen, ist dies Ihre
Edition. Genaueres zum Konzept der Managed Services finden Sie in der
Einleitung [dieses Artikels.](managed.html#intro)
:::

::: paragraph
Eine Aufstellung der Unterschiede zwischen den Editionen finden Sie auf
unserer
[Website.](https://checkmk.com/de/produkt/editionen){target="_blank"}
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wann immer wir in
diesem Handbuch Funktionen besprechen, die nur für die kommerziellen
Editionen gelten --- also für Checkmk Enterprise, Checkmk Cloud oder
Checkmk MSP --- , kennzeichnen wir dies mit dem Symbol wie in diesem
Absatz.
:::
:::::::::::
::::::::::::

::::: sect1
## []{#versions .hidden-anchor .sr-only}2. Version auswählen {#heading_versions}

:::: sectionbody
::: paragraph
Wir entwickeln alle Editionen von Checkmk ständig weiter, und daher gibt
es von jeder Edition verschiedene Versionen. Für den Einstieg empfehlen
wir Ihnen grundsätzlich die jeweils neueste stabile Version. Einen
detaillierten Überblick, welche Arten von anderen Versionen es außerdem
gibt, zeigt [dieser Artikel](cmk_versions.html).
:::
::::
:::::

::::::::::::::::::: sect1
## []{#install .hidden-anchor .sr-only}3. Die Software installieren {#heading_install}

:::::::::::::::::: sectionbody
::: paragraph
Der Checkmk-Server benötigt grundsätzlich ein Linux-System, auf dem er
laufen kann. (Sie können natürlich trotzdem auch Windows und andere
Betriebssysteme überwachen.) Wenn Sie keinen eigenen Linux-Server
aufsetzen möchten, können Sie Checkmk auch mithilfe von Docker oder
einer Appliance betreiben. Insgesamt gibt es vier Möglichkeiten, die wir
im folgenden kurz vorstellen und die auf unterschiedliche Weise zu
installieren sind. Wenn Sie die Installation Ihrer Variante
abgeschlossen haben, lesen Sie im [nächsten Kapitel](#create_site)
weiter, in der es um die Erstellung einer Instanz geht.
:::

::::: sect2
### []{#linux_server .hidden-anchor .sr-only}3.1. Linux-Server {#heading_linux_server}

::: paragraph
Die Installation von Checkmk auf einem Linux-Server, egal, ob auf einer
„echten" oder auf einer virtuellen Maschine, ist der Standardfall. Wenn
Sie über Linux-Grundkenntnisse verfügen, ist die Installation sehr
einfach. Die komplette Software, die Sie benötigen, ist entweder in
Ihrer Linux-Distribution oder in unserem Checkmk-Paket enthalten.
:::

::: paragraph
Checkmk unterstützt die folgenden Linux-Distributionen: Red Hat
Enterprise Linux (RHEL) basierte Systeme, SUSE Linux Enterprise Server
(SLES), Debian und Ubuntu. Für jede Checkmk-Edition, Checkmk-Version und
Linux-Distribution gibt es ein eigenes angepasstes Paket von uns, das
Sie mit dem Paketmanager Ihrer Linux-Distribution
[installieren](install_packages.html) können.
:::
:::::

::::::: sect2
### []{#virtual_appliance .hidden-anchor .sr-only}3.2. Virtuelle Appliance {#heading_virtual_appliance}

::: paragraph
Mit der virtuellen Appliance **Checkmk virt1** erhalten Sie eine
komplett eingerichtete virtuelle Maschine im Dateiformat OVA (Open
Virtualization Archive), die Sie in einem Hypervisor wie zum Beispiel
VirtualBox oder VMware ESXi verwenden können.
:::

::: paragraph
Die Appliance enthält das Linux-Betriebssystem Debian und eine Firmware,
die unter anderem eine Web-GUI zur Verwaltung der Appliance
bereitstellt. Der Vorteil der Appliance ist, neben einem
vorinstallierten System, dass Sie Betriebssystem, Appliance und Checkmk
komplett über die grafische Oberfläche konfigurieren können, ohne die
Linux-Kommandozeile bemühen zu müssen. Auch die Installation der
Checkmk-Software und die Erstellung von Instanzen erfolgt über die
Web-GUI der Appliance.
:::

::: paragraph
Die virtuelle Appliance hat eine eigene, von der Checkmk-Software
unterschiedliche, Versionsführung. Daher können Sie die
Appliance-Software durch die Installation einer neuen Firmware
aktualisieren --- unabhängig von der in der Appliance installierten
Checkmk-Software.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die virtuelle
Appliance ist für alle kommerziellen Editionen verfügbar, für Checkmk
Cloud und Checkmk MSP auch in den Lizenzstatus „Trial" und „Free". Wie
Sie bei der Installation vorgehen müssen, erfahren Sie in der
[Schnellstart-Anleitung.](appliance_virt1_quick_start.html)
:::
:::::::

::::: sect2
### []{#physical_appliance .hidden-anchor .sr-only}3.3. Physische Appliance {#heading_physical_appliance}

::: paragraph
Einen Schritt weiter können Sie mit der physischen Appliance (auch
Hardware Appliance genannt) gehen. Hier wird die komplette Software, die
Sie für Checkmk benötigen, fertig vorinstalliert und sofort einsetzbar
auf einem Gerät geliefert, um es zum Beispiel direkt in Ihrem
Rechenzentrum einzubauen. Zwei physische Appliances können Sie mit
wenigen Handgriffen zu einem Hochverfügbarkeits-Cluster (HA-Cluster)
zusammenschalten.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die physische
Appliance gibt es für alle kommerziellen Editionen. Sie können zwischen
mehreren
[Modellen](https://checkmk.com/de/produkt/appliances){target="_blank"}
mit verschiedenen Wartungsstufen wählen. Die Anleitung zur
Inbetriebnahme finden Sie in der
[Schnellstart-Anleitung.](appliance_rack1_quick_start.html)
:::
:::::

::::: sect2
### []{#docker .hidden-anchor .sr-only}3.4. Docker-Container {#heading_docker}

::: paragraph
Wenn Sie Checkmk mithilfe eines Docker-Containers bereitstellen wollen,
haben Sie auch diese Möglichkeit. Dabei unterstützen wir sowohl Checkmk
Raw als auch die kommerziellen Editionen mit fertigen Container Images,
die mit wenigen Kommandos eingerichtet sind.
:::

::: paragraph
Die Anleitung dazu finden Sie im [Artikel über die Installation als
Docker-Container](introduction_docker.html).
:::
:::::
::::::::::::::::::
:::::::::::::::::::

:::::::::::::::::::::::::: sect1
## []{#create_site .hidden-anchor .sr-only}4. Eine Instanz erstellen {#heading_create_site}

::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk hat eine Besonderheit, die Ihnen zu Beginn vielleicht unwichtig
erscheint, die sich in der Praxis aber als sehr nützlich herausgestellt
hat: Sie können auf einem Server mehrere unabhängige Instanzen (*sites*)
von Checkmk parallel betreiben. Dabei kann sogar jede Instanz mit einer
anderen Version von Checkmk laufen.
:::

::: paragraph
Hier sind zwei häufige Anwendungen für dieses gut durchdachte Feature:
:::

::: ulist
- Unkompliziertes Ausprobieren einer neuen Checkmk-Version.

- Parallelbetrieb einer Testinstanz zum Überwachen von Hosts, die noch
  nicht produktiv sind.
:::

::: paragraph
Wenn Sie Checkmk gerade auf einem Linux-Server installiert haben, kommt
es noch komplett ohne Instanzen daher. Wir zeigen Ihnen in diesem
Kapitel, wie Sie nach einer Software-Installation von Checkmk auf einer
Linux-Distribution eine Instanz anlegen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Checkmk Appliances werden über    |
|                                   | eine Web-GUI administriert, die   |
|                                   | auch das Anlegen von Instanzen    |
|                                   | abdeckt. Dies wird im [Artikel    |
|                                   | über die                          |
|                                   | Appliance](appl                   |
|                                   | iance_usage.html#site_management) |
|                                   | erklärt. Falls Sie Checkmk in     |
|                                   | einem Docker-Container betreiben, |
|                                   | wird für Sie automatisch während  |
|                                   | der Installation eine Instanz     |
|                                   | angelegt.                         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Wählen Sie zunächst einen Namen für Ihre Instanz. Dieser darf nur aus
Buchstaben, Ziffern und Unterstrichen bestehen, muss mit einem
Buchstaben anfangen und darf maximal 16 Zeichen lang sein. Konvention
sind dabei Kleinbuchstaben. Im Handbuch verwenden wir in Beispielen den
Namen `mysite`. Ersetzen Sie diesen Namen mit Ihren eigenen
Instanznamen.
:::

::: paragraph
Das Anlegen selbst geht sehr einfach. Geben Sie einfach als `root` den
Befehl `omd create`, gefolgt vom Namen der Instanz ein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd create mysite
Adding /opt/omd/sites/mysite/tmp to /etc/fstab.
Creating temporary filesystem /omd/sites/mysite/tmp...OK
Updating core configuration...
Generating configuration for core (type nagios)...
Precompiling host checks...OK
Executing post-create script "01_create-sample-config.py"...OK
Executing post-create script "02_cmk-compute-api-spec"...OK
Restarting Apache...OK
Created new site mysite with version 2.3.0p1.cre.

  The site can be started with omd start mysite.
  The default web UI is available at http://linux/mysite/

  The admin user for the web applications is cmkadmin with password: YzxfoFZh
  For command line administration of the site, log in with 'omd su mysite'.
  After logging in, you can change the password for cmkadmin with 'cmk-passwd cmkadmin'.
```
:::
::::

::: paragraph
Beim Anlegen einer neuen Instanz passieren die folgenden Dinge:
:::

::: ulist
- Es werden ein Linux-Benutzer (ohne Passwort) und eine Linux-Gruppe
  angelegt, die den Namen der Instanz tragen. Der Benutzer wird
  Instanzbenutzer (*site user*) genannt.

- Für die Instanz wird ein Home-Verzeichnis unterhalb von `/omd/sites`
  angelegt, z.B. `/omd/sites/mysite`. Dieses Verzeichnis wird
  Instanzverzeichnis (*site directory*) genannt.

- Eine sinnvolle Standardkonfiguration wird in das neue Verzeichnis
  kopiert.

- Für die Web-Oberfläche von Checkmk wird ein Benutzer mit dem Namen
  `cmkadmin` und einem zufälligen Passwort angelegt. Notieren Sie sich
  dieses Passwort. Sie können das Passwort auch ändern, wie es weiter
  unten beschrieben ist.
:::

::: paragraph
Übrigens: Immer wenn wir im Handbuch Pfadnamen angeben, die **nicht**
mit einem Schrägstrich beginnen, beziehen sich diese auf das
Instanzverzeichnis. Wenn Sie sich in diesem Verzeichnis befinden, können
Sie solche Pfade daher direkt so verwenden. Das gilt z.B. auch für die
Datei `etc/htpasswd`, deren absoluter Pfad hier
`/omd/sites/mysite/etc/htpasswd` ist. Diese Datei enthält die Passwörter
der Checkmk-Benutzer dieser Instanz. Verwechseln Sie diese Datei nicht
mit `/etc/htpasswd`.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie beim Versuch, die        |
|                                   | Instanz zu erstellen, diese oder  |
|                                   | eine ähnliche Fehlermeldung       |
|                                   | erhalten:                         |
|                                   | :::                               |
|                                   |                                   |
|                                   | :::: listingblock                 |
|                                   | ::: content                       |
|                                   | ``` {.pygments .highlight}        |
|                                   | root@linux# omd create mysite     |
|                                   | Group 'mysite' already existing.  |
|                                   | ```                               |
|                                   | :::                               |
|                                   | ::::                              |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | dann existiert bereits ein        |
|                                   | Linux-Benutzer oder eine Gruppe   |
|                                   | mit dem von Ihnen angegebenen     |
|                                   | Instanznamen. Wählen Sie dann     |
|                                   | einfach einen anderen Namen.      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Sobald Sie die neue Instanz erzeugt haben, erfolgt die weitere
Administration nicht mehr als `root`, sondern als Instanzbenutzer. Zu
diesem werden Sie am einfachsten mit dem folgenden Kommando:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# su - mysite
OMD[mysite]:~$
```
:::
::::

::: paragraph
Am geänderten Prompt sehen Sie, dass Sie in der Instanz angemeldet sind.
Wie der Befehl `pwd` zeigt, befinden Sie sich danach automatisch im
Instanzverzeichnis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ pwd
/omd/sites/mysite
```
:::
::::

::: paragraph
Wie Sie in der Ausgabe von `omd create` gesehen haben, wird beim
Erzeugen der Instanz automatisch ein administrativer Checkmk-Benutzer
mit dem Namen `cmkadmin` erzeugt. Dieser Benutzer ist für die Anmeldung
an der Web-Oberfläche von Checkmk gedacht und hat ein zufälliges
Passwort erhalten. Dieses Passwort können Sie als Instanzbenutzer leicht
ändern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk-passwd cmkadmin
New password: *****
Re-type new password: *****
```
:::
::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#start_site .hidden-anchor .sr-only}5. Die Instanz starten {#heading_start_site}

:::::::::::::::: sectionbody
::: paragraph
Eine Instanz kann gestartet oder gestoppt sein. Die Startart ist dabei
automatisch, was bedeutet, dass eine gestartete Instanz auch nach einem
Reboot des Rechners wieder gestartet wird. Frisch angelegte Instanzen
beginnen ihr Leben dennoch gestoppt. Das können Sie leicht mit dem
Befehl `omd status` überprüfen, der den Status aller Einzelprozesse
zeigt, die zum Betrieb der Instanz nötig sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd status
agent-receiver: stopped
mkeventd:       stopped
rrdcached:      stopped
npcd:           stopped
nagios:         stopped
apache:         stopped
redis:          stopped
crontab:        stopped
-----------------------
Overall state:  stopped
```
:::
::::

::: paragraph
Mit einem einfachen `omd start` können Sie die Instanz starten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Temporary filesystem already mounted
Starting agent-receiver...OK
Starting mkeventd...OK
Starting rrdcached...OK
Starting npcd...OK
Starting nagios...OK
Starting apache...OK
Starting redis...OK
Initializing Crontab...OK
```
:::
::::

::: paragraph
Wie erwartet, zeigt `omd status` danach alle Dienste als `running`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd status
agent-receiver: running
mkeventd:       running
rrdcached:      running
npcd:           running
nagios:         running
apache:         running
redis:          running
crontab:        running
-----------------------
Overall state:  running
```
:::
::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Da die
kommerziellen Editionen über mehr Features als Checkmk Raw verfügen,
sehen Sie dort mehr Dienste. Außerdem finden Sie für den Kern `cmc`
statt `nagios`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd status
agent-receiver: running
mkeventd:       running
liveproxyd:     running
mknotifyd:      running
rrdcached:      running
cmc:            running
apache:         running
dcd:            running
redis:          running
crontab:        running
-----------------------
Overall state:  running
```
:::
::::

::: paragraph
Der Befehl `omd` bietet noch viele weitere Möglichkeiten zur Steuerung
und Konfiguration von Instanzen, die im [Artikel über
Instanzen](omd_basics.html) beschrieben sind. Zusätzlich erfahren Sie im
[Artikel über Checkmk auf der
Kommandozeile](cmk_commandline.html#folder_structure), wie die
Verzeichnisstruktur von Checkmk aufgebaut ist.
:::
::::::::::::::::
:::::::::::::::::

:::::::::::::::: sect1
## []{#login .hidden-anchor .sr-only}6. Anmelden {#heading_login}

::::::::::::::: sectionbody
::: paragraph
Mit laufender Instanz kann es auch schon losgehen: Jede Instanz hat eine
eigene URL, die Sie in Ihrem Browser öffnen können. Diese setzt sich
zusammen aus dem Namen oder der IP-Adresse des Checkmk-Servers, einem
Schrägstrich und dem Namen der Instanz, z.B.
`http://mycmkserver/mysite`. Unter dieser Adresse finden Sie diesen
Anmeldedialog:
:::

:::: imageblock
::: content
![Checkmk-Anmeldedialog.](../images/login.png){width="60%"}
:::
::::

::: paragraph
Melden Sie sich nun mit dem Benutzernamen `cmkadmin` und dem anfangs
ausgewürfelten bzw. von Ihnen geänderten Passwort an. Dadurch landen Sie
auf der Startseite von Checkmk, die wir uns im [nächsten
Kapitel](intro_gui.html) genauer ansehen werden.
:::

::: paragraph
Falls Ihre Instanz nicht gestartet ist, sehen Sie statt des
Anmeldedialogs folgende Fehlermeldung:
:::

:::: {.imageblock .border}
::: content
![Fehlermeldung im Webbrowser zu einer nicht gestarteten
Instanz.](../images/intro_omd_site_not_started.png)
:::
::::

::: paragraph
Falls es überhaupt keine Instanz mit diesem Namen gibt (oder Sie auf
einem Server ohne Checkmk gelandet sind), sieht das eher so aus:
:::

:::: {.imageblock .border}
::: content
![Fehlermeldung im Webbrowser zu einer nicht vorhandenen
Instanz.](../images/intro_omd_site_not_found.png)
:::
::::

::: paragraph
**Wichtig:** Sobald Sie Checkmk produktiv betreiben, empfehlen wir Ihnen
aus Sicherheitsgründen den Zugriff auf die Oberfläche ausschließlich
gesichert zuzulassen. Was Sie dafür tun müssen, erfahren Sie im [Artikel
über die Absicherung der Web-Oberfläche mit HTTPS](omd_https.html).
:::

::: paragraph
[Weiter geht es mit der Checkmk-Oberfläche](intro_gui.html)
:::
:::::::::::::::
::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
