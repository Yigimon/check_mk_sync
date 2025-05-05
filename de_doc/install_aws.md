:::: {#header}
# Installation aus dem AWS Marketplace

::: details
[Last modified on 26-Jun-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_aws.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk aufsetzen](intro_setup.html) [Grundsätzliches zur Installation
von Checkmk](install_packages.html) [Updates und Upgrades](update.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#welcome .hidden-anchor .sr-only}1. Willkommen bei Checkmk als AMI {#heading_welcome}

::::::::::: sectionbody
::: paragraph
Egal, ob Sie bereits langjähriger Nutzer von Checkmk sind, oder erst mit
der Verfügbarkeit fertiger Images im Marketplace von Amazon Web Services
(AWS) zu uns gefunden haben, Sie finden in diesem Handbuchartikel alle
Ressourcen, um das vorbereitete *Amazon Machine Image (AMI)* zum für
Ihre Bedürfnisse passenden Monitoring zu vervollständigen.
:::

::: paragraph
Wenn Sie neu bei Checkmk sind, empfehlen wir die vorbereitende Lektüre
unseres [Leitfadens für Einsteiger](intro_setup.html). Vorkonfigurierte
VM Images kürzen zwar viele Punkte bei der Installation ab, doch
Kenntnis fundamentaler Konzepte, wie das der
[Instanzen](glossar.html#site), hilft bei der Einrichtung.
:::

:::::::: sect2
### []{#basics .hidden-anchor .sr-only}1.1. Grundsätzliches {#heading_basics}

::: paragraph
Falls Sie AWS-Nutzer sind, hatten Sie schon immer die Möglichkeit, ein
im Marketplace [vorhandenes
Ubuntu-Image](https://aws.amazon.com/marketplace/pp/prodview-o5bowpuwmx3ng?sr=0-10&ref_=beagle&applicationId=AWSMPContessa){target="_blank"}
mit Checkmk zu versehen und so \"Monitoring in der Cloud\" einzurichten.
Checkmk [2.2.0]{.new} geht den nächsten Schritt und bietet [ein
vorinstalliertes
Image](https://aws.amazon.com/marketplace/pp/prodview-gddkal2hfn7yo){target="_blank"}
auf Basis von Ubuntu 22.04 *(Jammy Jellyfish)*, bei denen alle
Abhängigkeiten bereits erfüllt sind. Hierbei kommt ausschließlich die
[Checkmk Cloud](cce.html) zum Einsatz. Diese befindet sich mit dem
Einrichten der ersten Instanz im 30 Tage währenden Lizenzstatus
\"Trial\", in dem keine Einschränkungen gelten. Nach Ablauf des
Testzeitraums kann Checkmk mit bis zu 750 überwachten Services auf einer
einzigen Instanz ohne Subskription weiter genutzt werden. Sollen mehr
Services überwacht werden, benötigen Sie einen
[Lizenzschlüssel.](license.html#license_cce)
:::

::: paragraph
Generell ist die Einrichtung ein wenig aufwendiger als beispielsweise
beim [Docker-Image](introduction_docker.html), schließlich muss das
bereitgestellte Image verschiedene Einsatzszenarien abdecken:
:::

::: ulist
- Setup mit einer einzigen Instanz *(single site setup)* auf einem
  Server in verschiedenster Skalierung

- Zentralinstanz im verteilten Monitoring

- Remote-Instanz im verteilten Monitoring

- Mischbetrieb von produktiver Instanz und Instanz(en) zum Testen auf
  einem Host
:::

::: paragraph
Aus diesem Grund enthält das AM Image weder eine vorbereitete Instanz,
noch E-Mail- oder Firewall-Konfiguration.
:::

::: paragraph
In diesem Artikel führen wir Sie durch das komplette Setup. Wo
Hintergrundinformationen sinnvoll sind, verlinken wir in detaillierte
Artikel des Handbuchs.
:::
::::::::
:::::::::::
::::::::::::

:::::::::::::::::: sect1
## []{#preparation .hidden-anchor .sr-only}2. Vorbereitung {#heading_preparation}

::::::::::::::::: sectionbody
::: paragraph
Neben der Dimensionierung von RAM, Prozessor und virtueller Festplatte
sollten Sie sich Gedanken um den Speicherort von Backups machen. Checkmk
unterstützt von Haus aus die Objektspeicher von Amazon, daneben können
Backups in Dateisystempfaden abgelegt werden, was Sicherungen auf SMB-
oder WebDAV-Mounts ermöglicht oder den regelmäßigen Transfer per `rsync`
erlaubt.
:::

:::: sect2
### []{#ssh_keys .hidden-anchor .sr-only}2.1. SSH-Schlüssel erstellen {#heading_ssh_keys}

::: paragraph
AWS unterstützt derzeit Schlüssel in den [Formaten ED25519 und
RSA.](https://docs.aws.amazon.com/de_de/AWSEC2/latest/UserGuide/create-key-pairs.html){target="_blank"}
Sie können für das erste Login auf der virtuellen Maschine ein
ED25519-Schlüsselpärchen erstellen, dessen öffentlichen Schlüssel
(*public key*) Sie beim Anlegen der VM hochladen. Alternativ können Sie
AWS das Schlüsselpaar erstellen lassen. Vergessen Sie in diesem Fall
nicht, den privaten Schlüssel sofort nach Erstellung zu speichern, denn
dieser wird aus Sicherheitsgründen sogleich wieder gelöscht.
:::
::::

::::::: sect2
### []{#ports .hidden-anchor .sr-only}2.2. Benötigte Ports ermitteln {#heading_ports}

::: paragraph
In einer Checkmk-Konfiguration mit einer einzigen Instanz *(single site
setup)*, in der Hosts auch im Push-Modus Daten zur Checkmk-Instanz
schicken, müssen die folgenden Ports des Checkmk-Servers erreichbar
sein:
:::

::: ulist
- Von den Hosts im Monitoring aus: Port 80/443 (HTTP/HTTPS, während der
  Agentenregistrierung) und Port 8000 (Agent Receiver, dauerhaft)

- Für die Verwaltung per Browser und REST-API: Port 80/443 (HTTP/HTTPS)
:::

::: paragraph
Die Freigaben dieser Ports sind in unseren
[Standard-Sicherheitsgruppen]{.guihint} bereits vorbereitet. Für
bestmögliche Sicherheit sollten Sie den Zugriff auf die tatsächlich
benötigten IP-Adressbereiche weiter einschränken.
:::

::: paragraph
Konsultieren Sie unsere Übersicht [aller verwendeten Ports](ports.html),
falls Sie ein verteiltes Monitoring aufsetzen oder beispielsweise
Statusabfragen über die
[Livestatus](glossar.html#livestatus)-Schnittstelle vornehmen wollen.
:::
:::::::

:::::: sect2
### []{#book_vm .hidden-anchor .sr-only}2.3. Image im Marketplace buchen {#heading_book_vm}

::: paragraph
Die folgenden VM-Instanzen stellen eine Empfehlung zur Dimensionierung
dar für die Zahl der zu überwachenden Services.
:::

+--------------+--------------+--------------+-----------------------+
| Type         | CPU Cores    | RAM (GB)     | Checkmk-Services      |
+==============+==============+==============+=======================+
| `c6a.xlarge` | 4            | 8            | 12 000                |
+--------------+--------------+--------------+-----------------------+
| `            | 8            | 16           | 30 000                |
| c6a.2xlarge` |              |              |                       |
+--------------+--------------+--------------+-----------------------+
| `            | 16           | 32           | 60 000                |
| c6a.4xlarge` |              |              |                       |
+--------------+--------------+--------------+-----------------------+

::: paragraph
Kalkulationsgrundlage für die Dimensionierung sind ca. 15 % der Services
durch [Spezialagenten](glossar.html#special_agent) und [aktive
Checks,](glossar.html#active_check) sowie 25 oder mehr Services pro
regulärem Host, der Daten per Agent im
[Push-Modus](glossar.html#push_mode) liefert. Unter Umständen sind
deutlich mehr Services in einem rein synthetischen Monitoring (primär
Spezialagenten liefern Daten) möglich. Bei Verwendung von Agenten im
[Pull-Modus](glossar.html#pull_mode) ist die angegebene Zahl an Services
möglicherweise nur durch konsequente Optimierung zu erreichen.
:::

::: paragraph
Die Dimensionierung des Festplattenplatzes basiert auf Erfahrungen
typischer Windows- und Linux-Serverumgebungen. Bringen viele Dienste
eine große Zahl an Metriken mit, kann ein größerer Speicherplatzbedarf
entstehen.
:::
::::::

:::: sect2
### []{#book_backup .hidden-anchor .sr-only}2.4. Backup-Speicher buchen {#heading_book_backup}

::: paragraph
Wegen der günstigen Traffic-Kosten raten wir zur Nutzung eines *AWS S3
Buckets*. Für die Kalkulation des benötigten Speicherplatzes lesen Sie
die [Hinweise zum RRD Datenformat.](graphing.html#rrds) Als Faustregel
für die Kalkulation eines vollständigen Backups gilt, dass die *Round
Robin Databases* nach 10 Tagen etwas mehr als ein Drittel ihrer
maximalen Größe erreicht haben. Das bedeutet, nach dieser Zeit ist es
sinnvoll, die Größe des gebuchten Backup-Speichers noch einmal zu
überprüfen.
:::
::::
:::::::::::::::::
::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}3. Einrichtung {#heading_setup}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#login .hidden-anchor .sr-only}3.1. Login auf der virtuellen Maschine {#heading_login}

::: paragraph
Das Root-Login ist auf den AWS-/Azure-Images deaktiviert. Stattdessen
kommt der Nutzer `ubuntu` zum Einsatz, der über die Berechtigung
verfügt, `sudo` mit beliebigen Kommandos ohne Passwortabfrage
auszuführen. Wenn Sie ein separates Schlüsselpaar für das Login auf der
virtuellen Maschine erstellt haben, müssen Sie mit dem Parameter `-i`
den Pfad zu dessen privaten Teil angeben. Die IP-Adresse ist natürlich
auf die anzupassen, unter der die VM von außen erreichbar ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ ssh -i /path/to/id_file.priv ubuntu@192.0.2.123
```
:::
::::

::: paragraph
Sie finden sich nun am Prompt des Nutzers `ubuntu` wieder. Der exakte
Prompt kann als Host-Name den beim Anlegen der VM angegebenen Host-Namen
oder eine IP-Adresse enthalten. Wir verwenden im Laufe des weiteren
Artikels den Host-Namen `cloud`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$
```
:::
::::
:::::::::

::::::::::: sect2
### []{#create_site .hidden-anchor .sr-only}3.2. Instanz aufsetzen {#heading_create_site}

::: paragraph
Eine Checkmk-Instanz muss eindeutig benannt sein und sollte darüber
hinaus eine leichte Identifikation ermöglichen. Hier, wie in den meisten
anderen Stellen dieses Handbuches, verwenden wir als Instanznamen
`mysite`.
:::

::: paragraph
Das Erstellen einer Instanz geschieht mit dem Verwaltungswerkzeug von
Checkmk, [`omd`](omd_basics.html). Vorinstalliert ist immer die neueste
Version von Checkmk:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo omd create mysite
Adding /opt/omd/sites/mysite/tmp to /etc/fstab.
Creating temporary filesystem /omd/sites/mysite/tmp...OK
Updating core configuration...
Generating configuration for core (type cmc)...

Starting full compilation for all hosts Creating global helper config...OK
 Creating cmc protobuf configuration...OK
Executing post-create script "01_create-sample-config.py"...OK
Restarting Apache...OK
Created new site mysite with version 2.2.0p1.cce.

  The site can be started with omd start mysite.
  The default web UI is available at http://cloud/mysite/

  The admin user for the web applications is cmkadmin with password: UbWeec9QuazIf
  For command line administration of the site, log in with 'omd su mysite'.
  After logging in, you can change the password for cmkadmin with 'cmk-passwd cmkadmin'.
```
:::
::::

::: paragraph
Starten Sie jetzt die neu angelegte Instanz mit
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo omd start mysite
```
:::
::::

::: paragraph
Die in der obigen Kommandoausgabe gezeigte URL (`http://cloud/mysite`)
verwendet den intern genutzten Host-Namen Ihrer AWS- oder Azure-VM. Da
dieser in der Regel nicht extern aufgelöst wird, ist die URL von
eingeschränktem Nutzen. In der Regel werden Sie zunächst über die
IP-Adresse oder einen im eigenen DNS-Server hinterlegten Host-Namen
zugreifen.
:::
:::::::::::

::::: sect2
### []{#ssl_certs .hidden-anchor .sr-only}3.3. Zertifikate hinterlegen {#heading_ssl_certs}

::: paragraph
Damit der System-Apache überhaupt am HTTPS-Port 443 lauschen kann,
benötigt er gültige Zertifikate. Beim ersten Start der virtuellen
Maschine werden hierfür die selbst signierten [*Snakeoil Inc.*
Zertifikate](https://packages.ubuntu.com/de/jammy/all/ssl-cert/filelist){target="_blank"}
generiert. Wir raten dringend zum baldigen Austausch gegen [eigene
Zertifikate](omd_https.html), bei denen die komplette Zertifikatskette
leicht verifiziert werden kann.
:::

::: paragraph
Die Apache-Konfiguration hält sich dabei eng an die Ubuntu-Standards,
geänderte Zertifikatspfade müssen in der Datei
`/etc/apache2/sites-enabled/000-default.conf` eingetragen werden.
:::
:::::

:::::::::: sect2
### []{#mta .hidden-anchor .sr-only}3.4. E-Mail-System einrichten {#heading_mta}

::: paragraph
Da die Wege der [Benachrichtigungen](intro_notifications.html) in
Checkmk vielfältig sind und variieren können, ist kein E-Mail-System
vorbereitet.
:::

::::: sect3
#### []{#no_mta .hidden-anchor .sr-only}Checkmk ohne E-Mail-System {#heading_no_mta}

::: paragraph
Auch der vollständige Verzicht auf ein lokales E-Mail-System ist
möglich, falls Sie ausschließlich die [nachvollziehbare Zustellung von
HTML-E-Mails per SMTP](notifications.html#syncsmtp) aktivieren wollen
oder auf Benachrichtigungs-Plugins für Plattformen wie [Microsoft
Teams](notifications_teams.html) oder [Slack](notifications_slack.html)
setzen.
:::

::: paragraph
Beachten Sie aber, dass in dieser Konfiguration keine
[Sammelbenachrichtigungen](notifications.html#bulk) möglich ist.
:::
:::::

::::: sect3
#### []{#simple_mta .hidden-anchor .sr-only}Relay-only oder vollwertiger Mail Transport Agent (MTA) {#heading_simple_mta}

::: paragraph
Im Regelfall werden Sie wegen der höheren Flexibilität ein E-Mail-System
einrichten wollen. Für kleinere Umgebungen hat sich der *relay-only MTA*
[Nullmailer](https://manpages.ubuntu.com/manpages/jammy/man7/nullmailer.7.html){target="_blank"}
bewährt.
:::

::: paragraph
Für größere Installationen, bei denen unvorhergesehene Ereignisse auch
einige Hundert E-Mails zur Folge haben können, empfehlen wir die
Installation eines vollwertigen MTAs wie Postfix.
:::
:::::
::::::::::

:::::::::::: sect2
### []{#add_hosts .hidden-anchor .sr-only}3.5. Hosts ins Monitoring aufnehmen {#heading_add_hosts}

::::::::: sect3
#### []{#pull .hidden-anchor .sr-only}Localhost im Pull-Modus {#heading_pull}

::: paragraph
In den allermeisten Fällen dürfte der Checkmk-Server selbst der erste
Host sein, den Sie [ins Monitoring
aufnehmen.](intro_setup_monitor.html#linux) Dazu müssen Sie den
Linux-Agenten auf dem Checkmk-Server installieren. Der Agent
kommuniziert mit dem Server im [Pull-Modus](glossar.html#pull_mode).
Wenn Ihnen der Download des Agentenpaketes über die Weboberfläche mit
anschließendem Transfer per `scp` zu umständlich erscheint, können Sie
den Agenten in seiner Standardkonfiguration (\"Vanilla\") direkt aus dem
Dateisystem installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo apt install $(sudo find /opt/omd/versions/ -name 'check-mk-agent_*.deb' | tail -n1)
```
:::
::::

::: paragraph
Unmittelbar nach der Installation lauscht der Checkmk-Agent im
unverschlüsselten Legacy-Pull-Modus auf Port 6556. Führen Sie daher
zeitnah [die Registrierung](intro_setup_monitor.html#register) durch,
damit keine unbefugten Dritten auf die Agentenausgabe zugreifen können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo cmk-agent-ctl register --hostname localhost --server localhost --site mysite --user cmkadmin
```
:::
::::
:::::::::

:::: sect3
#### []{#push .hidden-anchor .sr-only}Hosts im Push-Modus {#heading_push}

::: paragraph
Sollen Hosts überwacht werden, die hinter einer Firewall nicht direkt
vom Checkmk-Server erreicht werden können, ist oft der
[Push-Modus](glossar.html#push_mode) der bevorzugte Kommunikationsweg.
Sie können den Push-Modus in den Eigenschaften des Hosts im Abschnitt
[Monitoring agents](hosts_setup.html#monitoring_agents) mit der Option
[Checkmk agent connection mode]{.guihint} auswählen. Alternativ können
Sie den Push-Modus auch mit vorkonfigurierten Agentenpaketen für die
[Autoregistrierung](hosts_autoregister.html) kombinieren und so den
Komfort weiter erhöhen.
:::
::::
::::::::::::

::::::::::::::::::: sect2
### []{#update .hidden-anchor .sr-only}3.6. Checkmk aktualisieren {#heading_update}

::: paragraph
Prüfen Sie die
[Download-Seite](https://checkmk.com/de/download?method=cmk&edition=cce&version=2.2.0&platform=ubuntu&os=jammy&type=cmk){target="_blank"}
regelmäßig auf Updates und laden sie das aktualisierte Paket mit dem
dort angezeigten `wget` Kommando herunter.
:::

::: paragraph
Die [Installation eines Updates](update.html) erfolgt in zwei Schritten,
was darin begründet liegt, dass mit `omd` verschiedene Instanzen mit
verschiedenen Versionen von Checkmk auf einem Server laufen können.
:::

::::::::: sect3
#### []{#install_new .hidden-anchor .sr-only}Neue Checkmk-Version installieren und Instanz aktualisieren {#heading_install_new}

::: paragraph
Der erste Schritt ist die Installation des Paketes, im folgenden
Beispiel die Version [2.2.0]{.new}p2:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo apt install ./check-mk-cloud-2.2.0p2_0.jammy_amd64.deb
```
:::
::::

::: paragraph
Der nächste Schritt ist das Update Ihrer Instanz(en):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo omd stop mysite
ubuntu@cloud:~$ sudo omd update mysite
ubuntu@cloud:~$ sudo omd start mysite
```
:::
::::
:::::::::

::::::::: sect3
#### []{#remove_old .hidden-anchor .sr-only}Nicht mehr benötigte Pakete entfernen {#heading_remove_old}

::: paragraph
Falls Sie mehrere Instanzen auf dem Server nutzen (beispielsweise eine
produktiv genutzte und eine für den Test von Erweiterungen), stellen Sie
sicher, dass alle aktualisiert sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ omd sites
SITE         VERSION       COMMENTS
mysite       2.2.0p2.cce   default version
mytestsite   2.2.0p2.cce   default version
```
:::
::::

::: paragraph
Nicht mehr genutzte Checkmk-Versionen können Sie dann über das
Ubuntu-Paketmanagement deinstallieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
ubuntu@cloud:~$ sudo apt purge check-mk-cloud-2.2.0p1
```
:::
::::
:::::::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::: sect1
## []{#aftermath .hidden-anchor .sr-only}4. Nachbereitung {#heading_aftermath}

:::::::::: sectionbody
::::::::: sect2
### []{#backup .hidden-anchor .sr-only}4.1. Backup einrichten {#heading_backup}

::: paragraph
Checkmk bietet eine komfortable [Backup-Funktion](backup.html), die Sie
unter [Setup \> Maintenance \> Backups \> Backup targets]{.guihint}
konfigurieren. Mit [Add backup target]{.guihint} fügen Sie einen
Speicherort hinzu. Hier bietet es sich an, wegen des schnellen und
günstigen Transfers als [Destination]{.guihint} ein [AWS S3
Bucket]{.guihint} zu wählen.
:::

::: paragraph
Neben den Zugangsdaten müssen Sie einen Ordnerpfad angeben, in dem die
Zwischenspeicherung des Archivs vorgenommen wird, bevor dieses in den
Objektspeicher kopiert wird. Dies kann unter `/tmp` sein. Falls Ihre AWS
Instanz ein flüchtiges *(ephemeral)* Laufwerk bereitstellt, können Sie
dieses einbinden und als Zwischenspeicher nutzen.
:::

:::::: sect3
#### []{#restore .hidden-anchor .sr-only}Vorgehen beim Restore {#heading_restore}

::: paragraph
Das [Restore eines Backups](backup.html#backup_restore) muss immer auf
exakt derselben Version von Checkmk erfolgen wie dessen Erstellung. Soll
ein Backup dazu dienen, auf einen anderen Typ der virtuellen Maschine,
zu einem anderen Cloud-Anbieter oder von einer *On Premise Installation*
in die Cloud (oder andersherum) umzuziehen, aktualisieren Sie *vor* dem
finalen Backup und dem Umzug auf das höchste verfügbare Patchlevel von
Checkmk.
:::

::: paragraph
Für das Restore eines Backups gilt damit:
:::

::: {.olist .arabic}
1.  Installieren Sie auf dem Zielsystem exakt die Version von Checkmk,
    mit der das Backup erstellt wurde.

2.  Erstellen Sie mit `omd create` eine Monitoring-Instanz, die
    denselben Instanznamen wie das Ursprungssystem nutzt.

3.  Geben Sie das Backup-Ziel an und laden Sie den Backup-Schlüssel
    hoch.

4.  Führen Sie das eigentliche Restore durch.
:::
::::::
:::::::::
::::::::::
:::::::::::

::::: sect1
## []{#monitoring_azure .hidden-anchor .sr-only}5. AWS überwachen {#heading_monitoring_azure}

:::: sectionbody
::: paragraph
Checkmk bietet nicht nur die Verfügbarkeit als AMI, sondern auch
umfangreiche Möglichkeiten der [Überwachung Ihrer
AWS-Infrastruktur.](monitoring_aws.html) Selbst wenn Checkmk Ihr erstes
oder einziges AWS-Projekt sein sollte, lohnt bereits die Überwachung der
Leistung der Instanz, des Zustands der Backup-Buckets und der Höhe der
anfallenden Kosten.
:::
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
