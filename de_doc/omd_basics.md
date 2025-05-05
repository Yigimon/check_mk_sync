:::: {#header}
# Instanzen (Sites) mit omd verwalten

::: details
[Last modified on 07-Feb-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/omd_basics.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Updates und Upgrades](update.html) [Grundsätzliches zur Installation
von Checkmk](install_packages.html)
[Checkmk-Versionen](cmk_versions.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_omddie_open_monitoring_distribution .hidden-anchor .sr-only}1. OMD --- Die Open Monitoring Distribution {#heading__omddie_open_monitoring_distribution}

:::::::: sectionbody
::: paragraph
Das Checkmk Monitoring-System baut auf der *Open Monitoring
Distribution* (OMD) auf. OMD ist ein von Mathias Kettner gegründetes
Open Source Projekt, das sich rund um die komfortable und flexible
Installation einer Monitoring-Lösung aus diversen Komponenten dreht. Die
Abkürzung OMD haben Sie bereits als Teil der Namen der installierten
RPM/DEB-Pakete kennengelernt.
:::

::: paragraph
Eine OMD-basierte Installation zeichnet sich durch diese Eigenschaften
aus:
:::

::: ulist
- die Möglichkeit *mehrere* Monitoring-Instanzen parallel zu betreiben,

- die Möglichkeit, dies in *unterschiedlichen Versionen* der
  Monitoring-Software zu tun,

- einen intelligenten und komfortablen Mechanismus zur Aktualisierung
  (*update*) der Software,

- einheitliche Dateipfade --- egal welche Linux-Plattform Sie einsetzen,

- eine saubere Trennung von *Daten* und *Software,*

- eine sehr einfache Installation --- ohne Abhängigkeit von
  Drittanbieter-Software,

- eine perfekte Vorkonfiguration aller Komponenten.
:::

::: paragraph
OMD wird auf der Kommandozeile verwaltet, mit dem Befehl
`omd` --- genauer mit einer Reihe von `omd`-Befehlen für die
unterschiedlichen Aktionen rund um die Verwaltung der
Monitoring-Instanzen, z.B. `omd create` für das Anlegen einer Instanz.
Die wichtigsten `omd`-Befehle werden in diesem Artikel vorgestellt.
:::

::: paragraph
Der erste Befehl ist `omd help`, der eine Übersicht der verfügbaren
`omd`-Befehle anzeigt. Hilfe zu einem dieser Befehle erhalten Sie, indem
Sie hinter den Befehl die Option `--help` anfügen, z.B.
`omd create --help`. Die beiden Bindestriche vor dem `help` sind dabei
wichtig, denn ohne sie hätten Sie mit `omd create help` bereits Ihre
erste Instanz mit dem Namen `help` erstellt.
:::
::::::::
:::::::::

:::::::::::::::::::::::::: sect1
## []{#omd_create .hidden-anchor .sr-only}2. Erstellen von Instanzen {#heading_omd_create}

::::::::::::::::::::::::: sectionbody
::: paragraph
Das vielleicht Beste an OMD ist, dass OMD auf einem Server beliebig
viele *Monitoring-Instanzen* verwalten kann. Diese heißen auf Englisch
*monitoring sites.* Jede Instanz ist ein in sich geschlossenes
Monitoring-System, welches von den anderen getrennt läuft.
:::

::: paragraph
Eine Instanz hat immer einen eindeutigen Namen, der bei ihrer Erstellung
festgelegt wird. Dieser ist gleichzeitig der Name eines Linux-Benutzers,
der dabei angelegt wird. Der Instanzname orientiert sich an den
Konventionen zu Benutzernamen unter Linux. Das erste Zeichen eines
Instanznamen muss ein Buchstabe sein, alle weiteren Zeichen dürfen
Buchstaben, Ziffern und Unterstriche sein. Die Länge darf maximal 16
Zeichen betragen.
:::

::: paragraph
Das Erstellen geschieht mit dem Befehl `omd create`. Dieser muss als
`root`-Benutzer ausgeführt werden:
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
Restarting Apache...OK
Created new site mysite with version 2.1.0p17.cre.

  The site can be started with omd start mysite.
  The default web UI is available at http://linux/mysite/

  The admin user for the web applications is cmkadmin with password: YzxfoFZh
  For command line administration of the site, log in with 'omd su mysite'.
  After logging in, you can change the password for cmkadmin with 'cmk-passwd cmkadmin'.
```
:::
::::

::: paragraph
Bei der Erstellung des Benutzers `cmkadmin` wird ein zufällig
generiertes Passwort angelegt und ausgegeben.
:::

::: paragraph
Was geschieht beim Anlegen einer Instanz mit dem Namen `mysite`?
:::

::: ulist
- Ein Betriebssystembenutzer `mysite` und eine Gruppe `mysite` werden
  angelegt.

- Dessen neues Home-Verzeichnis `/omd/sites/mysite` wird angelegt und
  diesem übereignet. Dieses Verzeichnis wird auch Instanzverzeichnis
  (englisch: *site directory*) genannt.

- Dieses Verzeichnis wird mit Konfigurationsdateien und Verzeichnissen
  gefüllt.

- Für die neue Instanz wird eine Grundkonfiguration erstellt.
:::

::: paragraph
**Hinweis:** Es ist nicht möglich eine neue Instanz mit einem Namen zu
erstellen, der auf dem Server bereits als Namen eines \"normalen\"
Benutzers vergeben ist.
:::

::::::: sect2
### []{#user_group_id .hidden-anchor .sr-only}2.1. Benutzer- und Gruppen-IDs {#heading_user_group_id}

::: paragraph
In manchen Fällen möchte man die Benutzer-/Gruppen-ID des neu
anzulegenden Benutzers festlegen. Dies geschieht mit den Optionen `-u`
und `-g`, z.B.:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd create -u 6100 -g 180 mysite
```
:::
::::

::: paragraph
Eine Übersicht über weitere Optionen erhalten Sie mit
`omd create --help`. Die wichtigsten Optionen sind:
:::

+-----------------+-----------------------------------------------------+
| `-u UID`        | Der neue Benutzer wird mit der Benutzer-ID `UID`    |
|                 | angelegt.                                           |
+-----------------+-----------------------------------------------------+
| `-g GID`        | Die Gruppe des neuen Benutzers wird mit der         |
|                 | Gruppen-ID `GID` angelegt.                          |
+-----------------+-----------------------------------------------------+
| `--admin-passw  | Der neue Benutzer wird --- statt mit dem zufällig   |
| ord mypassword` | generierten --- mit dem Passwort `mypassword`       |
|                 | angelegt.                                           |
+-----------------+-----------------------------------------------------+
| `--reuse`       | OMD geht davon aus, dass der neue Benutzer bereits  |
|                 | existiert und legt ihn nicht an. Das                |
|                 | Home-Verzeichnis dieses Benutzers muss sich         |
|                 | unterhalb von `/omd/sites/` befinden und leer sein. |
+-----------------+-----------------------------------------------------+
| `-t SIZE`       | Das temporäre Dateisystem der neuen Instanz wird    |
|                 | mit der Größe `SIZE` angelegt. `SIZE` endet mit `M` |
|                 | (Megabyte), `G` (Gigabyte) oder `%` (Prozent vom    |
|                 | RAM). Beispiel: `-t 4G`                             |
+-----------------+-----------------------------------------------------+
:::::::

:::::::::: sect2
### []{#init .hidden-anchor .sr-only}2.2. Externes Instanzverzeichnis {#heading_init}

::: paragraph
Standardmäßig wird das Home-Verzeichnis einer neuen Instanz unter
`/omd/sites/` angelegt und mit Standarddateien gefüllt. Sie können
jedoch auch ein leeres Home-Verzeichnis erstellen lassen, um etwa ein
externes Medium an dieser Stelle zu mounten. Das erledigt die Option
`--no-init`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd create --no-init mysite
```
:::
::::

::: paragraph
Mit dieser Option wird auch die Integration in den System-Apache
ausgesetzt, sprich `/omd/apache/mysite.conf` bleibt leer. Anschließend
könnten Sie ein beliebiges Verzeichnis mounten und die Einrichtung
fortsetzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd init mysite
```
:::
::::

::: paragraph
`omd init` holt dann die beiden ausgelassenen Schritte nach, fügt also
die Standarddateien ein und erstellt die Apache-Konfiguration.
:::
::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::::::::::: sect1
## []{#site_user .hidden-anchor .sr-only}3. Instanzbenutzer {#heading_site_user}

:::::::::::::: sectionbody
::: paragraph
Die `omd`-Befehle können Sie als `root`-Benutzer oder als
Instanzbenutzer (englisch: *site user*) ausführen. Unter `root` haben
Sie mehr Möglichkeiten. So kann nur `root` eine Instanz erstellen, was
nachvollziehbar ist, denn erst beim Erstellen der Instanz wird der
Instanzbenutzer angelegt. Da Sie unter `root` Befehle für alle
existierenden Instanzen ausführen können, müssen Sie den Namen der
Instanz, um die es geht, beim `omd`-Befehl mit angeben.
:::

::: paragraph
Sobald die Instanz existiert, sollten Sie die weiteren `omd`-Befehle nur
noch als Instanzbenutzer ausführen. Als Instanzbenutzer können Sie alle
wichtigen Operationen durchführen, die diese Instanz betreffen.
:::

::: paragraph
Der Benutzerwechsel geschieht mit `su`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# su - mysite
```
:::
::::

::: paragraph
Beachten Sie unbedingt das Minuszeichen nach dem `su`. Es sorgt dafür,
dass der Benutzerwechsel *alle* Operationen durchläuft, die auch bei
einer normalen Anmeldung ablaufen. Insbesondere werden alle
Umgebungsvariablen korrekt gesetzt, und Ihre Sitzung wird als `mysite`
im Instanzverzeichnis `/omd/sites/mysite` gestartet:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$
```
:::
::::

::: paragraph
Sobald sie als Instanzbenutzer angemeldet sind, brauchen Sie in der
Regel bei `omd`-Befehlen keinen Instanznamen mitanzugeben, da so ein
Befehl auf die Instanz angewendet wird, unter der Sie angemeldet sind.
:::

::: paragraph
Falls Sie mehrere Checkmk-Versionen auf Ihrem Checkmk-Server installiert
haben, wird mit jeder dieser Versionen auch die zugehörige OMD-Version
mitinstalliert. Da kann sich mit der Zeit schon eine lange Liste von
Software-Versionen ansammeln. Da sich auch `omd`-Befehle zwischen den
Versionen unterscheiden können, ist es manchmal interessant zu wissen,
mit welcher OMD-Version Sie gerade arbeiten:
:::

::: ulist
- Als Instanzbenutzer nutzen Sie stets die `omd`-Befehle der auf der
  Instanz aktuell installierten Checkmk-Version, die Sie sich mit
  `omd version` anzeigen lassen können.

- Als `root`-Benutzer werden die Befehle der Standardversion ausgeführt,
  die auch bei der Erstellung einer Instanz verwendet wird. In der Regel
  ist das die zuletzt auf dem Server installierte Version. Die
  Standardversion können Sie sich mit `omd version` anzeigen lassen und
  mit `omd setversion` ändern.
:::
::::::::::::::
:::::::::::::::

::::::::::::::::::::: sect1
## []{#omd_start_stop .hidden-anchor .sr-only}4. Starten und Stoppen von Instanzen {#heading_omd_start_stop}

:::::::::::::::::::: sectionbody
::: paragraph
Ihre Instanz ist jetzt bereit, gestartet zu werden. Sie können das als
`root` mit `omd start mysite` machen. Besser ist es aber, wenn Sie das
Arbeiten mit der Instanz grundsätzlich als Instanzbenutzer erledigen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Creating temporary filesystem /omd/sites/mysite/tmp...OK
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
Wenig überraschend geht das Anhalten mit `omd stop`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd stop
Removing Crontab...OK
Stopping redis...killing 484382...OK
Stopping apache...killing 484371...OK
Stopping nagios...OK
Stopping npcd...OK
Stopping rrdcached...waiting for termination...OK
Stopping mkeventd...killing 484279...OK
Stopping agent-receiver...killing 484267...OK
Stopping 1 remaining site processes...OK
```
:::
::::

::: paragraph
Das Starten und Stoppen einer Instanz ist nichts anderes als das Starten
bzw. Stoppen einer Reihe von Diensten. Diese können auch einzeln
verwaltet werden, indem Sie den Namen des Diensts mit angeben, z.B.:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start apache
Temporary filesystem already mounted
Starting apache...OK
```
:::
::::

::: paragraph
Wie die einzelnen Dienste heißen, erfahren Sie im Verzeichnis
`~/etc/init.d`. Beachten Sie die Tilde (`~`) am Anfang des Pfadnamens.
Diese steht für das Home-Verzeichnis des Instanzbenutzers (das
Instanzverzeichnis). `~/etc/init.d` und `/etc/init.d` sind
unterschiedliche Verzeichnisse.
:::

::: paragraph
Neben `start` und `stop` gibt es noch die `omd`-Befehle `restart`,
`reload` und `status`. Das Neuladen von Apache ist z.B. immer nach einer
manuellen Änderung der Apache-Konfiguration notwendig:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd reload apache
Reloading apache
```
:::
::::

::: paragraph
Beachten Sie, dass hier nicht der globale Apache-Prozess des
Linux-Servers gemeint ist, sondern ein eigener dedizierter
Apache-Prozess in der Instanz selbst:
:::

::: paragraph
Um nach den ganzen Starts und Stops einen Überblick vom Zustand der
Instanz zu erhalten, verwenden Sie einfach `omd status`:
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
apache:         running
redis:          stopped
crontab:        stopped
-----------------------
Overall state:  partially running
```
:::
::::
::::::::::::::::::::
:::::::::::::::::::::

::::::::::::::::::::::::::::::: sect1
## []{#omd_config .hidden-anchor .sr-only}5. Konfigurieren der Komponenten {#heading_omd_config}

:::::::::::::::::::::::::::::: sectionbody
::: paragraph
Wie bereits erwähnt, integriert OMD mehrere Software-Komponenten zu
einem Monitoring-System. Dabei sind manche Komponenten optional und für
manche gibt es Alternativen oder verschiedene Betriebseinstellungen.
Dies alles kann komfortabel mit dem Befehl `omd config` konfiguriert
werden. Dabei gibt es einen interaktiven Modus und einen Skriptmodus.
:::

:::::::::::::: sect2
### []{#interactive_mode .hidden-anchor .sr-only}5.1. Interaktive Konfiguration {#heading_interactive_mode}

::: paragraph
Den interaktiven Modus rufen Sie als Instanzbenutzer einfach so auf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config
```
:::
::::

::::: imageblock
::: content
![Hauptmenü von \'omd
config\'.](../images/omd_basics_omd_config_main.png){width="300"}
:::

::: title
Im `omd config`-Menü navigieren Sie mit den Cursor- und Enter-Tasten
:::
:::::

::: paragraph
Sobald Sie bei laufender Instanz eine Einstellung ändern, wird Sie OMD
darauf hinweisen, dass zuvor Ihre Instanz angehalten werden muss und
diese bei Bedarf auch stoppen:
:::

::::: imageblock
::: content
![Hinweis zum Ändern einer Einstellung bei gestarteter
Instanz.](../images/omd_basics_omd_config_cannotchange.png){width="300"}
:::

::: title
Die Konfiguration kann nur geändert werden, wenn die Instanz nicht läuft
:::
:::::

::: paragraph
Vergessen Sie nicht, nach getaner Arbeit die Instanz wieder zu starten.
`omd config` wird das *nicht* automatisch für Sie tun.
:::
::::::::::::::

::::::::::::: sect2
### []{#script_mode .hidden-anchor .sr-only}5.2. Konfiguration per Skriptmodus {#heading_script_mode}

::: paragraph
Wer den interaktiven Modus nicht liebt oder mit Skripten arbeiten will,
kann die einzelnen Einstellungen als Variablen auch per Kommandozeile
setzen. Dafür gibt es den Befehl `omd config set`. Folgendes Beispiel
setzt die Variable `AUTOSTART` auf `off`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set AUTOSTART off
```
:::
::::

::: paragraph
Sie können `omd config set` auch als `root` aufrufen, wenn Sie den Namen
der Instanz als Argument mit angeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd config mysite set AUTOSTART off
```
:::
::::

::: paragraph
Die aktuelle Belegung aller Variablen zeigt als `root` das Kommando
`omd config mysite show` und als Instanzbenutzer `omd config show`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config show
ADMIN_MAIL:
AGENT_RECEIVER: on
AGENT_RECEIVER_PORT: 8005
APACHE_MODE: own
APACHE_TCP_ADDR: 127.0.0.1
APACHE_TCP_PORT: 5008
AUTOSTART: off
[...]
```
:::
::::

::: paragraph
Die obige Kommandoausgabe zeigt nur die ersten Einträge.
:::
:::::::::::::

::::: sect2
### []{#_häufig_benötigte_einstellungen .hidden-anchor .sr-only}5.3. Häufig benötigte Einstellungen {#heading__häufig_benötigte_einstellungen}

::: paragraph
In `omd config` gibt es zahlreiche Einstellungen. Die Wichtigsten sind:
:::

+---------+-------------+---------------------------------------------+
| V       | Standard    | Bedeutung                                   |
| ariable |             |                                             |
+=========+=============+=============================================+
| `AUT    | `on`        | Stellen Sie dies auf `off`, wenn Sie        |
| OSTART` |             | verhindern möchten, dass diese Instanz beim |
|         |             | Hochfahren des Rechners automatisch         |
|         |             | gestartet wird. Das ist vor allem bei       |
|         |             | Testinstallationen interessant, die         |
|         |             | normalerweise nicht laufen sollen.          |
+---------+-------------+---------------------------------------------+
| `CORE`  | `nagios`    | Auswahl des Monitoring-Kerns. In den        |
|         | (Checkmk    | kommerziellen Editionen kann statt des      |
|         | Raw),\      | [Checkmk Micro Core (CMC)](cmc.html) auch   |
|         | `cmc`       | der Nagios-Kern ausgewählt werden. In       |
|         | (k          | [![CRE](../images/icons/CRE.png             |
|         | ommerzielle |  "Checkmk Raw"){width="20"}]{.image-inline} |
|         | Editionen)  | **Checkmk Raw** gibt es nur `nagios` als    |
|         |             | Monitoring-Kern.                            |
+---------+-------------+---------------------------------------------+
| `MK     | `on`        | Aktiviert die [Event                        |
| EVENTD` |             | Console](glossar.html#ec), mit der Sie      |
|         |             | Syslog-Meldungen, SNMP-Traps und andere     |
|         |             | Events verarbeiten können.                  |
+---------+-------------+---------------------------------------------+
| `L      | `off`       | Hiermit erlauben Sie Zugriff auf die        |
| IVESTAT |             | Statusdaten dieser Instanz von außen. Damit |
| US_TCP` |             | kann ein [verteiltes                        |
|         |             | Monit                                       |
|         |             | oring](glossar.html#distributed_monitoring) |
|         |             | aufgebaut werden. Auf der Zentralinstanz    |
|         |             | kann dann der Status dieser (Remote-)       |
|         |             | Instanz eingebunden werden. Aktivieren Sie  |
|         |             | diese Einstellung nur in einem              |
|         |             | abgesicherten Netzwerk.                     |
+---------+-------------+---------------------------------------------+

::: paragraph
**Hinweis:** Diese Variablen sehen Sie unter gleichem Namen auch im
interaktiven Modus.
:::
:::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#omd_cp_mv .hidden-anchor .sr-only}6. Kopieren und Umbenennen von Instanzen {#heading_omd_cp_mv}

:::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::: sect2
### []{#omd_cp .hidden-anchor .sr-only}6.1. Kopieren von Instanzen {#heading_omd_cp}

::: paragraph
Manchmal ist es nützlich, eine Kopie einer Instanz zu erzeugen --- sei
es zu Testzwecken oder für die Vorbereitung eines
[Updates.](update.html) Natürlich könnte man jetzt einfach das
Verzeichnis `/omd/sites/mysite_old` nach `/omd/sites/mysite_new`
kopieren. Das würde aber nicht so funktionieren wie gewünscht, denn:
:::

::: ulist
- in vielen Konfigurationsdateien ist der Name der Instanz enthalten,

- auch tauchen an etlichen Stellen absolute Pfade auf, die mit
  `/omd/sites/mysite_old` beginnen,

- und nicht zuletzt muss es auf Betriebssystemebene einen [Benutzer samt
  zugehöriger Gruppe](#user_group_id) geben, dem die Instanz gehört und
  der standardmäßig so heißt, wie die Instanz.
:::

::: paragraph
Um das Kopieren einer Instanz zu vereinfachen, gibt es stattdessen den
Befehl `omd cp`, welcher all das berücksichtigt. Führen Sie den Befehl
als `root` aus und geben Sie als Argumente einfach den Namen der
bestehenden Instanz und dann den Namen der neuen an, z.B.:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd cp mysite_old mysite_new
```
:::
::::

::: paragraph
Das Kopieren geht nur, wenn
:::

::: ulist
- die Instanz gestoppt ist und

- keine Prozesse mehr laufen, die dem Instanzbenutzer gehören.
:::

::: paragraph
Beides stellt sicher, dass die Instanz zum Zeitpunkt des Kopierens in
einem konsistenten Zustand ist und sich auch während des Vorgangs nicht
ändert.
:::
:::::::::::

:::::::::::::::::::::::: sect2
### []{#omd_cp_mv_migration .hidden-anchor .sr-only}6.2. Migration der Konfiguration {#heading_omd_cp_mv_migration}

::: paragraph
OMD konnte ursprünglich lediglich mit den Dateien umgehen, die beim
[Erstellen der Instanz](#omd_create) mit `omd create` auch tatsächlich
angelegt wurden, und die zudem die Instanz-ID (`$OMD_SITE`) enthalten.
Diese Dateien sind im Instanzverzeichnis `~/etc` zu finden mit diesem
Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ grep -r $OMD_SITE etc
```
:::
::::

::: paragraph
Mit Konfigurationsdateien, die erst später über die Arbeit mit der
Checkmk-Instanz entstanden, konnte OMD nichts anfangen (also zum
Beispiel den Konfigurationen hinzugefügter Hosts). Rein technisch
betrachtet entspricht dieses Verhalten genau dem Geltungsbereich von
OMD. Die Erwartungshaltung der meisten Benutzer ist aber die, dass ein
`omd cp` eine komplett neue Instanz erschafft, die produktiv
weitergenutzt werden kann --- inklusive der eigenen
Monitoring-Konfiguration.
:::

::: paragraph
Seit der Checkmk-Version [2.1.0]{.new} kann OMD nunmehr auch die
wichtigsten Teile der Checkmk-Konfiguration anpassen. Sie selbst müssen
dafür übrigens im Grunde nichts tun, die gesamte folgend beschriebene
Migration findet ganz automatisch statt.
:::

::: paragraph
Ein typisches Beispiel dazu: In den Eigenschaften eines Hosts können Sie
über das Attribut [Monitored on site]{.guihint} manuell festlegen, über
welche Instanz dieser Host überwacht werden soll, etwa `mysite_old`.
Nach einem `omd cp mysite_old mysite_new` ändert sich der Wert
entsprechend auf `mysite_new`. (Früher hätte dieses Prozedere zu dem
Eintrag `Unknown site (mysite_old)` geführt.)
:::

::: paragraph
Die technische Umsetzung dieser Migration sieht wie folgt aus: OMD
erkennt Änderungen an der Instanz-ID und führt dann den Befehl
`post-rename-site -v -o mysite_new` aus. Die einzelnen
Migrationsschritte werden in der Folge ganz automatisch über die so
genannten *rename actions plugins* abgearbeitet, die Sie unter unter
`cmk/post_rename_site/plugins/actions` im
[Git-Repository](https://github.com/Checkmk/checkmk/tree/master/cmk/post_rename_site/plugins/actions){target="_blank"}
finden.
:::

::: paragraph
Zur Migration gehört auch, dass Sie über Dinge informiert werden, die
**nicht** automatisch migriert werden (können).
:::

::: paragraph
Hier ein konkretes Beispiel: Sie nutzen ein verteiltes Monitoring und
benennen sowohl die Zentralinstanz als auch eine Remote-Instanz um.
:::

::: paragraph
**Zentralinstanz:** Das Plugin `sites.py` erkennt, dass es sich um eine
Zentralinstanz handelt und aktualisiert unter anderem den Wert [URL
prefix,]{.guihint} der sich in den Verbindungseinstellungen der lokalen
Instanz unter [Setup \> General \> Distributed Monitoring]{.guihint}
findet.
:::

::: paragraph
**Remote-Instanz:** Das Plugin `warn_remote_site.py` erkennt, dass es
sich um eine Remote-Instanz handelt und weist entsprechend darauf hin,
dass die Zentralinstanz manuell geprüft und gegebenenfalls angepasst
werden muss. Das heißt hier konkret: In den
Distributed-Monitoring-Einstellungen auf der Zentralinstanz muss in der
Verbindungseinstellung zur umbenannten Remote-Instanz deren neuer Name
eingetragen werden --- das kann OMD von einem entfernten Rechner aus
freilich nicht leisten.
:::

::: paragraph
OMD selbst informiert Sie im Terminal ausführlich über das gesamte
Prozedere. Hier sehen Sie beispielhaft die Migrationsmeldungen der
`omd cp`-Ausgabe beim Umbenennen einer Zentralinstanz - getrennt nach
Erfolgs- und Warnmeldungen. Die abgearbeiteten *rename actions plugins*
werden dabei einzeln durchnummeriert. Zunächst die Ausgabe der
automatisch erfolgten Migrationsaufgaben (gekürzt):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
...
Executing post-cp script "01_cmk-post-rename-site"...
-|  1/6 Distributed monitoring configuration...
-|  2/6 Hosts and folders...
-|  3/6 Update core config...
...
```
:::
::::

::: paragraph
Der zweite Teil der Ausgabe enthält nun Hinweise bezüglich
Einstellungen, die Sie **möglicherweise** manuell anpassen müssen (stark
gekürzt):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
...
-|  4/6 Warn about renamed remote site...
-|  5/6 Warn about new network ports...
-|  6/6 Warn about configurations to review...
...
```
:::
::::

::: paragraph
Zum Punkt `Warn about configurations to review…​` gehören allgemeine
Hinweise zu einzelnen Aspekten, die bei einer Migration generell manuell
geprüft werden müssen, beispielsweise hartkodierte Filter für Ansichten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
...
-| Parts of the site configuration cannot be migrated automatically. The following
-| parts of the configuration may have to be reviewed and adjusted manually:
-|
-| - Custom bookmarks (in users bookmark lists)
-| - Hard coded site filters in custom dashboards, views, reports
-| - Path in rrdcached journal files
-| - NagVis maps or custom NagVis backend settings
-| - Notification rule "site" conditions
-| - Event Console rule "site" conditions
-| - "site" field in "Agent updater (Linux, Windows, Solaris)" rules (CEE/CME only)
-| - Alert handler rule "site" conditions (CEE/CME only)
-|
-| Done
```
:::
::::

::: paragraph
Hier eine Übersicht der derzeit sechs aktiven Plugins - die Reihenfolge
entspricht der Nummerierung in den obigen Ausgaben:
:::

+------------------------+---------------------------------------------+
| Plugin                 | Funktion                                    |
+========================+=============================================+
| `sites.py`             | Ändert die Instanz-ID in diversen           |
|                        | Konfigurationsdateien.                      |
+------------------------+---------------------------------------------+
| `hosts_and_folders.py` | Ändert das Instanz-Attribut von Host- und   |
|                        | Ordner-Eigenschaften.                       |
+------------------------+---------------------------------------------+
| `                      | Aktualisiert die Konfiguration des Kerns    |
| update_core_config.py` | (`cmk -U`).                                 |
+------------------------+---------------------------------------------+
| `warn_remote_site.py`  | Hinweise beim Umbenennen einer              |
|                        | Remote-Instanz.                             |
+------------------------+---------------------------------------------+
| `                      | Hinweise bezüglich Problemen mit mehrfach   |
| warn_changed_ports.py` | genutzten Ports.                            |
+------------------------+---------------------------------------------+
| `warn_about_no         | Allgemeine Hinweise zu Aspekten, die        |
| t_migrated_configs.py` | manuell geprüft werden sollten.             |
+------------------------+---------------------------------------------+
::::::::::::::::::::::::

:::::::: sect2
### []{#limit_data .hidden-anchor .sr-only}6.3. Datenmengen einschränken {#heading_limit_data}

::: paragraph
Wenn Sie mit der Instanz eine größere Zahl von Hosts überwachen, können
die Datenmengen, die kopiert werden müssen, schon ganz erheblich sein.
Der Großteil wird dabei durch die Messwerte verursacht, die in den
[Round-Robin-Datenbanken (RRDs)](graphing.html#rrds) gespeichert sind.
Aber auch die Log-Dateien mit historischen Ereignissen können größere
Datenmengen erzeugen.
:::

::: paragraph
Wenn Sie die Historie nicht benötigen (z.B. weil Sie einfach schnell
etwas testen möchten), können Sie diese beim Kopieren weglassen. Dazu
dienen folgende Optionen, die Sie bei `omd cp` angeben können:
:::

+------+---------------------------------------------------------------+
| `--  | Kopiert die Instanz ohne die RRDs.                            |
| no-r |                                                               |
| rds` |                                                               |
+------+---------------------------------------------------------------+
| `--  | Kopiert die Instanz ohne Log-Dateien und übrige historische   |
| no-l | Daten.                                                        |
| ogs` |                                                               |
+------+---------------------------------------------------------------+
| `-N` | Macht beides: `-N` ist eine Abkürzung für                     |
|      | `--no-rrds --nologs`.                                         |
+------+---------------------------------------------------------------+

::: paragraph
Die Reihenfolge der Option(en) ist dabei wichtig:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd cp --no-rrds mysite_old mysite_new
```
:::
::::
::::::::

:::::::: sect2
### []{#omd_mv .hidden-anchor .sr-only}6.4. Instanzen umbenennen {#heading_omd_mv}

::: paragraph
Das Umbenennen einer Instanz erfolgt mit dem Befehl `omd mv`. Dies
geschieht analog zum [Kopieren einer Instanz](#omd_cp), hat die gleichen
Voraussetzungen und wird ebenfalls inklusive der [Migration der
Konfiguration](#omd_cp_mv_migration) durchgeführt. Die Optionen zum
Beschränken der Datenmengen existieren hier nicht, weil die Dateien ja
einfach nur in ein anderes Verzeichnis verschoben und nicht dupliziert
werden.
:::

::: paragraph
Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd mv mysite_old mysite_new
```
:::
::::

::: paragraph
Beim Umbenennen einer Instanz mit `omd mv` wird der Instanzname
geändert, aber einige Instanzattribute nicht, unter anderem die
Instanz-ID. Dieses Kommando eignet sich daher *nicht,* um eine Instanz,
die z.B. durch ein Backup dupliziert wurde, mit dem Original in einem
verteilten Monitoring zu betreiben --- auch wenn die beteiligten
Instanzen nach Ausführung von `omd mv` unterschiedliche Namen haben.
:::
::::::::

:::: sect2
### []{#_weitere_optionen .hidden-anchor .sr-only}6.5. Weitere Optionen {#heading__weitere_optionen}

::: paragraph
Wie beim Erstellen einer Instanz wird auch beim Kopieren und beim
Umbenennen jeweils ein neuer Linux-Benutzer angelegt. Daher verfügen
`omd cp` und `omd mv` auch über einige der Optionen von `omd create`,
z.B. zur Festlegung von [Benutzer- und Gruppen-IDs](#user_group_id).
Genaue Information erhalten Sie mit den Befehlen `omd cp --help` und
`omd mv --help`.
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::: sect1
## []{#omd_diff .hidden-anchor .sr-only}7. Änderungen in Konfigurationsdateien anzeigen {#heading_omd_diff}

:::::::::::::: sectionbody
::: paragraph
Beim [Erstellen einer Instanz](#omd_create) füllt der Befehl
`omd create` das Verzeichnis `~/etc` mit vielen vordefinierten
Konfigurationsdateien. Auch unter `~/var` und `~/local` werden etliche
Verzeichnisse angelegt.
:::

::: paragraph
Nun ist es wahrscheinlich so, dass Sie im Laufe der Zeit einige der
Dateien anpassen werden. Wenn Sie nach einiger Zeit feststellen möchten,
welche Dateien nicht mehr dem Auslieferungszustand entsprechen, können
Sie das mit dem Befehl `omd diff` herausfinden. Nützlich ist dies unter
anderem vor einem [Update von Checkmk](update.html), da hier Ihre
Änderungen möglicherweise im Konflikt stehen mit Änderungen der
Standarddateien.
:::

::: paragraph
Bei einem Aufruf ohne weitere Argumente sehen Sie alle geänderten
Dateien unterhalb des aktuellen Verzeichnisses:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd diff
 * Changed content var/check_mk/wato/auth/auth.php
 ! Changed permissions var/check_mk/wato/auth/auth.php
 * Changed content etc/htpasswd
 * Changed content etc/diskspace.conf
 ! Changed permissions etc/diskspace.conf
 * Changed content etc/auth.secret
 * Changed content etc/mk-livestatus/xinetd.conf
 * Changed content etc/omd/allocated_ports
 * Changed content etc/apache/apache.conf
 * Deleted etc/apache/apache-own.conf
```
:::
::::

::: paragraph
Sie können beim Aufruf auch ein Verzeichnis angeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd diff etc/apache
 * Changed content etc/apache/apache.conf
 * Deleted etc/apache/apache-own.conf
```
:::
::::

::: paragraph
Wenn Sie die Änderungen in der Datei im Detail sehen möchten, geben Sie
einfach den Pfad zur Datei an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd diff etc/apache/apache.conf
74,75c74,75
< ServerLimit          64
< MaxClients           64
---
> ServerLimit          128
> MaxClients           128
```
:::
::::
::::::::::::::
:::::::::::::::

::::::: sect1
## []{#omd_update .hidden-anchor .sr-only}8. Instanzen aktualisieren {#heading_omd_update}

:::::: sectionbody
::: paragraph
Um die auf der Instanz installierte Monitoring-Software auf eine höhere
Version zu aktualisieren, dient der Befehl `omd update`. Dieser wird
ausführlich im Artikel zum [Update von Checkmk](update.html#detailed)
vorgestellt. Dort werden auch weitere nützliche `omd`-Befehle rund um
das Software-Update beispielhaft gezeigt:
:::

::: ulist
- `omd versions` zur Auflistung aller installierten Software-Versionen,

- `omd sites` zur Auflistung aller existierender Instanzen mit den auf
  ihnen installierten Versionen,

- `omd version` zur Anzeige der Standardversion, die bei der Erstellung
  einer Instanz verwendet wird,

- `omd setversion` zur Festlegung einer anderen Standardversion.
:::

::: paragraph
Mit `omd update` wird übrigens auch ein [Upgrade](update.html#upgrade)
auf eine andere Edition durchgeführt, z.B. von Checkmk Raw auf Checkmk
Enterprise.
:::
::::::
:::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#omd_backup_restore .hidden-anchor .sr-only}9. Instanzen sichern und wiederherstellen {#heading_omd_backup_restore}

:::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#_backup_erstellen .hidden-anchor .sr-only}9.1. Backup erstellen {#heading__backup_erstellen}

::: paragraph
Die Instanzverwaltung von Checkmk hat einen eingebauten Mechanismus zum
Sichern und Wiederherstellen von Checkmk-Instanzen. Die Grundlage davon
sind die Befehle `omd backup` und `omd restore`, welche alle Daten einer
Instanz in ein tar-Archiv einpacken bzw. von dort wieder auspacken.
:::

::: paragraph
**Hinweis:** Checkmk bietet auch die Möglichkeit Backup und Restore ohne
Kommandozeile über die GUI durchzuführen unter [Setup \> Maintenance \>
Backups.]{.guihint} Dort können Sie auch verschlüsselte Backups und
zeitgesteuerte Backup-Aufträge erstellen. Im Artikel zu
[Backups](backup.html) erfahren Sie, wie das geht.
:::

::: paragraph
Das Sichern einer Instanz mit `omd backup` erfordert keine
`root`-Rechte. Sie können es als Instanzbenutzer ausführen. Geben Sie
einfach als Argument den Namen einer zu erzeugenden Backup-Datei an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd backup /tmp/mysite.tar.gz
```
:::
::::

::: paragraph
Beachten Sie dabei:
:::

::: ulist
- Der erzeugte Dateityp ist ein gzip-komprimiertes tar-Archiv. Verwenden
  Sie daher `.tar.gz` oder `.tgz` als Dateiendung.

- Legen Sie die Sicherung **nicht** in das Instanzverzeichnis. Denn
  dieses wird ja komplett gesichert. So würde jedes weitere Backup
  *alle* bisherigen als Kopie enthalten.

- Wenn Sie das Backup als Instanzbenutzer erstellen, erhält nur der
  Instanzbenutzer und seine Gruppe Lese- und Schreibzugriff auf das
  tar-Archiv.
:::

::: paragraph
Wenn das Zielverzeichnis der Sicherung nicht als Instanzbenutzer
schreibbar ist, können Sie die Sicherung auch als `root` durchführen.
Dazu benötigen Sie wie immer als zusätzliches Argument den Namen der zu
sichernden Instanz:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd backup mysite /var/backups/mysite.tar.gz
```
:::
::::

::: paragraph
Die Sicherung enthält alle Daten der Instanz --- außer den flüchtigen
Daten unterhalb von `~/tmp/`. Sie können mit dem Befehl `tar tzf`
einfach einen Blick in die Datei werfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ tar tvzf /tmp/mysite.tar.gz  | less
lrwxrwxrwx mysite/mysite     0 2022-07-25 11:59 mysite/version -> ../../versions/2.1.0p8.cre
drwxr-xr-x mysite/mysite     0 2022-07-25 17:25 mysite/
-rw------- mysite/mysite   370 2022-07-26 17:09 mysite/.bash_history
-rw-r--r-- mysite/mysite  1091 2022-07-25 11:59 mysite/.bashrc
-rw-r--r-- mysite/mysite    63 2022-07-25 11:59 mysite/.modulebuildrc
-rw-r--r-- mysite/mysite  2066 2022-07-25 11:59 mysite/.profile
drwxr-xr-x mysite/mysite     0 2022-07-25 11:59 mysite/.version_meta/
drwxr-xr-x mysite/mysite     0 2022-07-20 11:40 mysite/.version_meta/skel/
-rw-r--r-- mysite/mysite  1091 2022-06-26 02:03 mysite/.version_meta/skel/.bashrc
-rw-r--r-- mysite/mysite    52 2022-07-20 09:02 mysite/.version_meta/skel/.modulebuildrc
-rw-r--r-- mysite/mysite  2055 2022-06-26 02:03 mysite/.version_meta/skel/.profile
drwxr-xr-x mysite/mysite     0 2022-07-20 11:40 mysite/.version_meta/skel/etc/
drwxr-xr-x mysite/mysite     0 2022-07-20 11:40 mysite/.version_meta/skel/etc/apache/
-rw-r--r-- mysite/mysite  1524 2022-06-26 02:03 mysite/.version_meta/skel/etc/apache/apache-own.conf
```
:::
::::
::::::::::::::::

::::::: sect2
### []{#_backup_ohne_historie .hidden-anchor .sr-only}9.2. Backup ohne Historie {#heading__backup_ohne_historie}

::: paragraph
Der Löwenanteil der zu bewegenden Daten bei einer Instanzsicherung sind
die Messwerte und die Log-Dateien mit historischen Ereignissen. Das gilt
beim Sichern genauso wie beim Kopieren einer Instanz. Wenn Sie diese
Daten nicht zwingend benötigen, können Sie diese weglassen und so die
Sicherung deutlich schneller und die Ergebnisdatei deutlich kleiner
machen.
:::

::: paragraph
`omd backup` bietet zum Verzicht auf diese Daten [die gleichen
Optionen](#limit_data) wie `omd cp` beim Kopieren. Im folgenden Beispiel
wird das Backup ohne Messdaten und ohne die in den Log-Dateien
gespeicherte Historie erstellt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd backup -N /tmp/mysite.tar.gz
```
:::
::::
:::::::

:::: sect2
### []{#_backup_bei_laufender_instanz .hidden-anchor .sr-only}9.3. Backup bei laufender Instanz {#heading__backup_bei_laufender_instanz}

::: paragraph
Ein Backup kann auch von einer laufenden Instanz erstellt werden. Um
einen konsistenten Stand der für das Aufzeichnen der Messdaten
verwendeten [Round-Robin-Datenbanken (RRDs)](graphing.html#rrds) zu
gewährleisten, versetzt der Befehl `omd backup` den Round-Robin-Cache
automatisch in einen Modus, bei dem laufende Updates nur noch in das
Journal und nicht mehr in die RRDs geschrieben werden. Die
Journaldateien werden zu allerletzt gesichert. Damit wird erreicht, dass
möglichst viele der Messdaten, die während der Sicherung angefallen
sind, noch mitgesichert werden.
:::
::::

::::::::::::::: sect2
### []{#_restore .hidden-anchor .sr-only}9.4. Restore {#heading__restore}

::: paragraph
Das Zurückspielen einer Sicherung ist ebenso einfach wie das Sichern
selbst. Der Befehl `omd restore` stellt eine Instanz aus einer Sicherung
wieder her --- in der Checkmk-Version, mit der die Instanz gesichert
wurde. Damit das Wiederherstellen klappt, muss daher diese Version auf
dem Server installiert sein.
:::

::: paragraph
Die Instanz wird komplett geleert und neu befüllt. Vor dem `omd restore`
muss die Instanz gestoppt sein und danach muss sie dann wieder gestartet
werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd stop
OMD[mysite]:~$ omd restore /tmp/mysite.tar.gz
OMD[mysite]:~$ omd start
```
:::
::::

::: paragraph
Auch als `root`-Benutzer ist ein Wiederherstellen möglich. Anders als
beim Aufruf durch den Instanzbenutzer wird dabei die Instanz mit der
Sicherung *neu erstellt.*
:::

::: paragraph
Falls also noch eine Instanz mit dem gleichen Namen existiert, müssen
Sie diese vorher [löschen.](#omd_rm) Das können Sie entweder mit einem
`omd rm` erledigen, oder Sie geben beim `omd restore` die Option
`--reuse` mit an. Ein `--kill` sorgt zusätzlich dafür, dass die noch
bestehende Instanz vorher gestoppt wird. Den Namen der Instanz brauchen
Sie beim Befehl nicht anzugeben, da dieser in der Sicherung enthalten
ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd restore --reuse --kill /var/backup/mysite.tar.gz
root@linux# omd start mysite
```
:::
::::

::: paragraph
Als `root`-Benutzer können Sie eine Instanz auch mit einem anderen Namen
als dem in der Sicherung gespeicherten wiederherstellen. Geben Sie dazu
den gewünschten Namen als Argument hinter dem Wort `restore` an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd restore mysite2 /var/backup/mysite.tar.gz
Restoring site mysite2 from /tmp/mysite.tar.gz...
 * Converted      ./.modulebuildrc
 * Converted      ./.profile
 * Converted      etc/xinetd.conf
 * Converted      etc/logrotate.conf
```
:::
::::

::: paragraph
Die lange Liste der Konvertierungen, die hier stattfinden, hat den
gleichen Grund wie bei dem weiter oben beschriebenen [Kopieren und
Umbenennen von Instanzen](#omd_cp_mv). Der Name der Instanz kommt in
etlichen Konfigurationsdateien vor und wird hier automatisch durch den
neuen Namen ersetzt.
:::
:::::::::::::::

::::::::::::::::: sect2
### []{#ssh_omd_backup_restore .hidden-anchor .sr-only}9.5. Live Backup & Restore auf einen anderen Server {#heading_ssh_omd_backup_restore}

::: paragraph
Die Befehle `omd backup` und `omd restore` können --- in guter alter
Unix-Tradition --- anstelle von Dateien auch über die
Standard-Ein-/Ausgabe arbeiten. Geben Sie hierzu anstelle eines Pfads
für die tar-Datei einfach einen Bindestrich (`-`) an.
:::

::: paragraph
Auf diese Art können Sie eine Pipe aufbauen und die Daten ohne
Zwischendatei direkt auf einen anderen Rechner „streamen". Je größer die
Sicherung ist, desto nützlicher ist das, denn so wird kein temporärer
Platz im Dateisystem des gesicherten Servers benötigt.
:::

::: paragraph
Folgender Befehl sichert eine Instanz per SSH auf einen anderen Rechner:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd backup mysite - | ssh user@otherserver "cat > /var/backup/mysite.tar.gz"
```
:::
::::

::: paragraph
Wenn Sie den SSH-Zugriff umdrehen, sich also lieber vom Backup Server
auf die Checkmk-Instanz verbinden möchten, so geht auch das, wie
folgendes Beispiel zeigt. Dazu muss zuvor ein SSH-Login als
Instanz-Benutzer erlaubt werden.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@otherserver# ssh mysite@checkmkserver "omd backup -" > /var/backup/mysite.tar.gz
```
:::
::::

::: paragraph
Wenn Sie das geschickt mit einem `omd restore` kombinieren, das die
Daten von der Standardeingabe liest, können Sie eine komplette Instanz
im laufenden Betrieb von einem Server auf einen anderen kopieren --- und
das ohne irgendeinen zusätzlichen Platz für eine Sicherungsdatei:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@otherserver# ssh mysite@checkmkserver "omd backup -" | omd restore -
```
:::
::::

::: paragraph
Und jetzt nochmal das Ganze mit umgedrehtem SSH-Zugriff --- diesmal
wieder vom Quellsystem auf das Zielsystem:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd backup mysite - | ssh user@otherserver "omd restore -"
```
:::
::::
:::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#enable .hidden-anchor .sr-only}10. Instanzen deaktivieren {#heading_enable}

:::::: sectionbody
::: paragraph
OMD kann Instanzen deaktivieren. Mit dem Befehl
`omd disable --kill mysite`, ausgeführt als `root`, passiert Folgendes:
:::

::: {.olist .arabic}
1.  Die Instanz `mysite` wird gestoppt.

2.  Prozesse, die auf das `tmpfs` zugreifen, werden gestoppt.

3.  Das `tmpfs` wird ausgehängt.

4.  Die Datei `/omd/apache/mysite.conf` wird geleert.

5.  Apache wird neu gestartet.
:::

::: paragraph
In diesem Status wird das Home-Verzeichnis der Instanz, hier
`/omd/sites/mysite`, von keinem Prozess mehr referenziert. Praktisch ist
dies vor allem in einem [Cluster,](appliance_cluster.html) da sich das
Home-Verzeichnis nun auf einen anderen Knoten verschieben lässt.
:::
::::::
:::::::

:::::::::::: sect1
## []{#omd_rm .hidden-anchor .sr-only}11. Instanzen löschen {#heading_omd_rm}

::::::::::: sectionbody
::: paragraph
Das Löschen einer Instanz geht ebenso einfach wie das
[Erstellen](#omd_create) --- mit dem Befehl `omd rm` als `root`. Dabei
wird die Instanz vorher automatisch gestoppt.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd rm mysite
PLEASE NOTE: This action removes all configuration files
             and variable data of the site.

In detail the following steps will be done:
- Stop all processes of the site
- Unmount tmpfs of the site
- Remove tmpfs of the site from fstab
- Remove the system user <SITENAME>
- Remove the system group <SITENAME>
- Remove the site home directory
- Restart the system wide apache daemon
 (yes/NO): yes
```
:::
::::

::: paragraph
Man muss wohl nicht extra dazuschreiben, dass hierbei **alle Daten der
Instanz gelöscht** werden!
:::

::: paragraph
Wenn Sie kein Freund von Bestätigungsdialogen sind oder das Löschen in
einem Skript durchführen wollen, können Sie mit der Option `-f` das
Löschen erzwingen.
:::

::: paragraph
**Achtung:** `-f` muss hier **vor** dem `rm` stehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd -f rm mysite
```
:::
::::
:::::::::::
::::::::::::

:::::::: sect1
## []{#cleanup .hidden-anchor .sr-only}12. Ungenutzte Versionen deinstallieren {#heading_cleanup}

::::::: sectionbody
::: paragraph
Da Checkmk in mehreren Versionen gleichzeitig installiert sein darf,
kann es vorkommen, dass nicht alle Versionen auch wirklich von einer
Instanz genutzt werden. OMD kann ungenutzte Versionen mit dem Kommando
`cleanup` deinstallieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd cleanup
1.6.0p28.cee         In use (by mysite_old). Keeping this version.
2.1.0p15.cee         Uninstalling
2.1.0p15.cme         Uninstalling
2.1.0p15.cre         In use (by mysite_raw). Keeping this version.
2.1.0p19.cme         Keeping this version, since it is the default.
2022.12.14.cee       In use (by mysite). Keeping this version.
```
:::
::::

::: paragraph
OMD behält dabei neben den genutzten Versionen auch die Standardversion.
Die Standardversion ist, sofern nicht manuell mit `omd setversion`
anders konfiguriert, die zuletzt installierte Version von Checkmk, im
obigen Beispiel also `2.1.0p19.cme`.
:::
:::::::
::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}13. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `                  | Instanzverzeichnis der Instanz `mysite`.        |
| /omd/sites/mysite` |                                                 |
+--------------------+-------------------------------------------------+
| `~/etc/`           | In diesem Verzeichnis werden die                |
|                    | Konfigurationsdateien der Instanz abgelegt.     |
+--------------------+-------------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
