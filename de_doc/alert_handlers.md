:::: {#header}
# Alert Handler

::: details
[Last modified on 13-Feb-2017]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/alert_handlers.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Benachrichtigungen](notifications.html) [Kommandos](commands.html)
[Monitoring-Agenten](wato_monitoringagents.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::::::: sectionbody
::::::::: sect2
### []{#_soll_das_monitoring_eingreifen .hidden-anchor .sr-only}1.1. Soll das Monitoring eingreifen? {#heading__soll_das_monitoring_eingreifen}

::: paragraph
Man möchte meinen, es sei offensichtlich, dass ein Monitoring-System
niemals ins Geschehen eingreift, sondern eben nur überwacht. Und
wahrscheinlich ist es auch eine gute Idee, es dabei zu belassen.
:::

::: paragraph
Nun ist es aber zugegeben eine verlockende Vorstellung, dass ein System,
das zuverlässig Probleme erkennen kann, diese auch selbst behebt, sofern
das automatisch geht.
:::

::: paragraph
Dafür finden sich leicht einige Beispiele:
:::

::: ulist
- Das Starten eines Dienstes, wenn dieser abgestürzt ist.

- Das Auslösen eines Garbage Collectors, wenn der Speicher einer Java-VM
  knapp ist.

- Das neue Aufbauen eines VPN-Kanals, wenn dieser definitiv tot ist.
:::

::: paragraph
Wer sich auf so etwas einlässt, muss natürlich Monitoring anders denken.
Aus einem System, das einfach nur zuguckt und für den Betrieb „nicht
notwendig" ist, wird Schritt für Schritt ein lebenswichtiges Organ des
Rechenzentrums.
:::

::: paragraph
Aber das Beheben von Problemen ist nicht das Einzige, was das Monitoring
automatisiert tun kann, wenn es ein Problem feststellt. Ebenfalls sehr
nützlich und gleichzeitig viel harmloser ist das Sammeln von
zusätzlichen Diagnosedaten genau in dem Augenblick des Fehlers. Und
sicher fallen Ihnen auf Anhieb noch etliche weitere Dinge ein, die Sie
mit **Alert Handlers** anfangen können.
:::
:::::::::

::::::::: sect2
### []{#_alert_handlers_in_checkmk .hidden-anchor .sr-only}1.2. Alert Handlers in Checkmk {#heading__alert_handlers_in_checkmk}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Alert Handlers
sind von Ihnen selbst geschriebene Skripte, die Checkmk in den
kommerziellen Editionen für Sie ausführt, wenn ein Problem festgestellt
wird --- oder genauer ausgedrückt: wenn ein Host oder Service seinen
Zustand ändert.
:::

::: paragraph
Alert Handlers sind sehr ähnlich zu
[Benachrichtigungen](glossar.html#notification) und werden auch ähnlich
konfiguriert, aber es gibt ein paar wichtige Unterschiede:
:::

::: ulist
- Alert Handlers sind unabhängig von
  [Wartungszeiten](glossar.html#scheduled_downtime),
  Benachrichtigungsperioden, [Quittierungen](basics_ackn.html) und
  ähnlichen Einschränkungen.

- Alert Handlers werden auch schon beim ersten Wiederholversuch
  aufgerufen (falls Sie mehrere Check-Versuche konfiguriert haben).

- Alert Handlers sind unabhängig von Benutzern und Kontaktgruppen.

- Alert Handlers gibt es nur in den kommerziellen Editionen.
:::

::: paragraph
Man kann auch sagen, dass Alert Handlers sehr „low level" sind. Sobald
ein Host oder Service seinen Status ändert, werden *sofort* die von
Ihnen konfigurierten Alert Handlers aufgerufen. Auf diese Art kann ein
Alert Handler auch erfolgreich etwas reparieren, bevor es überhaupt zu
einem Alert kommt.
:::

::: paragraph
Natürlich können Sie --- wie immer bei Checkmk --- durch Regeln genaue
Bedingungen festlegen, wann welcher Handler ausgeführt werden soll. Wie
das geht und auch alles andere über Alert Handlers erfahren Sie in
diesem Artikel.
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Ein Hinweis für
Benutzer von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw**: Auch Sie können das Monitoring automatisiert Aktionen
ausführen lassen. Verwenden Sie dazu die „Event Handlers" von Nagios.
Konfigurieren Sie diese mit manuellen Konfigurationsdateien in
Nagios-Syntax unterhalb von `~/etc/nagios/conf.d/`. Die Event Handlers
sind gut dokumentiert. Hinweise dazu finden Sie durch einfaches
[googeln.](https://www.google.de/search?q=nagios+event+handlers){target="_blank"}
:::
:::::::::
:::::::::::::::::
::::::::::::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}2. Alert Handler einrichten {#heading_setup}

:::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_skripte_in_das_richtige_verzeichnis_legen .hidden-anchor .sr-only}2.1. Skripte in das richtige Verzeichnis legen {#heading__skripte_in_das_richtige_verzeichnis_legen}

::: paragraph
Alert Handlers sind Skripte, die auf dem Checkmk-Server ausgeführt
werden. Diese müssen im Verzeichnis
`~/local/share/check_mk/alert_handlers/` liegen und können in jeder von
Linux unterstützten Sprache geschrieben sein, z.B. in BASH, Python oder
Perl. Vergessen Sie nicht, die Skripte mit `chmod +x` ausführbar zu
machen.
:::

::: paragraph
Wenn Sie im Skript in der zweiten Zeile einen Kommentar einfügen (mit
einer Raute `#`), dann erscheint dieser als Name des Skripts in der
Auswahlliste bei der Regel:
:::

::::: listingblock
::: title
\~/local/share/check_mk/alert_handlers/myhandler
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# Foobar handler for repairing stuff
...
```
:::
:::::
::::::::

::::::::: sect2
### []{#_ein_einfacher_alert_handler_zum_testen .hidden-anchor .sr-only}2.2. Ein einfacher Alert Handler zum Testen {#heading__ein_einfacher_alert_handler_zum_testen}

::: paragraph
Wie bei den [Benachrichtigungen](notifications.html) bekommt das Skript
alle Informationen über den Host oder Service als Umgebungsvariablen,
wobei diese hier alle mit dem Präfix `ALERT_` beginnen.
:::

::: paragraph
Um zu testen, welche Umgebungsvariablen genau beim Skript ankommen,
können Sie folgenden Alert Handler zum Testen verwenden:
:::

::::: listingblock
::: title
\~/local/share/check_mk/alert_handlers/debug
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# Dump all variables to ~/tmp/alert.out

env | grep ^ALERT_ | sort > $OMD_ROOT/tmp/alert.out
```
:::
:::::

::: ulist
- `env` gibt alle Umgebungsvariablen aus.

- `grep ^ALERT_` wählt daraus diejenigen aus, die mit `ALERT_` beginnen.

- `sort` sortiert dann die verbleibende Liste alphabetisch.
:::
:::::::::

:::::::::: sect2
### []{#_alert_handler_aktivieren .hidden-anchor .sr-only}2.3. Alert Handler aktivieren {#heading__alert_handler_aktivieren}

::: paragraph
Die Aktivierung des Handlers erfolgt über [Setup \> Events \> [![icon
alert handlers](../images/icons/icon_alert_handlers.png)]{.image-inline}
Alert handlers.]{.guihint}
:::

::: paragraph
Gehen Sie wie folgt vor:
:::

::: {.olist .arabic}
1.  Legen Sie das obige Skript unter
    `~/local/share/check_mk/alert_handlers/debug` ab.

2.  Machen Sie es mit `chmod +x debug` ausführbar.

3.  Rufen Sie dann über [Setup \> Events]{.guihint} die Konfiguration
    der [Alert handlers]{.guihint} auf.

4.  Legen Sie dort mit [Add rule]{.guihint} eine neue Regel an.
:::

::: paragraph
Das Formular erlaubt eine direkte Auswahl des Alert Handlers. Die zweite
Zeile in dem ausgewählten Skript wird als Titel benutzt. Zusätzlich
können Sie Aufrufargumente mitgeben, die Sie in die Freitextfelder
eintragen. Diese kommen beim Skript als Kommandozeilenargumente an. In
der Shell können Sie darauf mit `$1`, `$2` usw. zugreifen.
:::

:::: imageblock
::: content
![alert handler arguments](../images/alert_handler_arguments.png)
:::
::::

::: paragraph
**Wichtig**: Nach dem Speichern der Regel ist der Alert Handler sofort
wirksam und wird bei jeder Zustandsänderung irgendeines Hosts oder
Services ausgeführt!
:::
::::::::::

:::::::::::: sect2
### []{#_test_und_fehlerdiagnose .hidden-anchor .sr-only}2.4. Test und Fehlerdiagnose {#heading__test_und_fehlerdiagnose}

::: paragraph
Zum Testen setzen Sie z.B. einen Service mit [Fake check
results]{.guihint} von Hand auf [CRIT]{.state2}. Nun sollte die Datei
mit den Variablen angelegt worden sein. Hier die ersten 20 Zeilen davon:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ head -n 20 ~/tmp/alert.out
ALERT_ALERTTYPE=STATECHANGE
ALERT_CONTACTNAME=check-mk-notify
ALERT_CONTACTS=
ALERT_DATE=2016-07-19
ALERT_HOSTADDRESS=127.0.0.1
ALERT_HOSTALIAS=myserver123
ALERT_HOSTATTEMPT=1
ALERT_HOSTCHECKCOMMAND=check-mk-host-smart
ALERT_HOSTCONTACTGROUPNAMES=all
ALERT_HOSTDOWNTIME=0
ALERT_HOSTFORURL=myserver123
ALERT_HOSTGROUPNAMES=check_mk
ALERT_HOSTNAME=myserver123
ALERT_HOSTNOTESURL=
ALERT_HOSTNOTIFICATIONNUMBER=1
ALERT_HOSTOUTPUT=Packet received via smart PING
ALERT_HOSTPERFDATA=
ALERT_HOSTPROBLEMID=0
ALERT_HOSTSHORTSTATE=UP
ALERT_HOSTSTATE=UP
```
:::
::::

::: paragraph
Eine Log-Datei über die (Nicht-)Ausführung der Alert Handlers finden Sie
unter `~/var/log/alerts.log`. Der Abschnitt für die Ausführung des
Handlers `debug` für den Service `Filesystem /` auf dem Host
`myserver123` sieht etwa so aus:
:::

::::: listingblock
::: title
\~/var/log/alerts.log
:::

::: content
``` {.pygments .highlight}
2016-07-19 15:17:22 Got raw alert (myserver123;Filesystem /) context with 60 variables
2016-07-19 15:17:22 Rule ''...
2016-07-19 15:17:22  -> matches!
2016-07-19 15:17:22 Executing alert handler debug for myserver123;Filesystem /
2016-07-19 15:17:22 Spawned event handler with PID 6004
2016-07-19 15:17:22 1 running alert handlers:
2016-07-19 15:17:22 PID: 6004, object: myserver123;Filesystem /
2016-07-19 15:17:24 1 running alert handlers:
2016-07-19 15:17:24 PID: 6004, object: myserver123;Filesystem /
2016-07-19 15:17:24 Handler [6004] for myserver123;Filesystem / exited with exit code 0.
2016-07-19 15:17:24 Output:
```
:::
:::::

::: paragraph
Noch einige nützliche Hinweise:
:::

::: ulist
- Texte, die der Alert Handler auf der Standardausgabe ausgibt,
  erscheinen in der Log-Datei neben `Output:`.

- Auch der Exit Code des Skripts wird geloggt
  (`exited with exit code 0`).

- Alert Handlers sind erst wirklich nützlich, wenn Sie auf dem Ziel-Host
  ein Kommando ausführen. Für Linux bietet Checkmk eine fertige Lösung,
  die [weiter unten](#linux_remote) erklärt wird.
:::
::::::::::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

::::::::::: sect1
## []{#rules .hidden-anchor .sr-only}3. Regelbasierte Konfiguration {#heading_rules}

:::::::::: sectionbody
::: paragraph
Wie im einführenden Beispiel gezeigt, legen Sie über Regeln fest, welche
Ereignisse Alert Handlers auslösen sollen. Das Ganze funktioniert analog
zu den [Benachrichtigungen,](notifications.html) nur etwas vereinfacht.
Im Beispiel haben Sie überhaupt keine Bedingungen festgelegt, was in der
Praxis natürlich unrealistisch ist. Folgendes Beispiel zeigt eine
Bedingung, die einen Alert Handler für ganz bestimmte Hosts und Services
festlegt:
:::

:::: imageblock
::: content
![alert handlers rule
condition](../images/alert_handlers_rule_condition.png)
:::
::::

::: paragraph
Der Alert Handler wird nur aufgerufen, wenn
:::

::: ulist
- einer der Hosts `myhost123` oder `myhost124` betroffen ist,

- es um den Service `JVM CaramKern Memory` geht,

- der Zustand von [OK]{.state0} oder [WARN]{.state1} auf [CRIT]{.state2}
  wechselt und

- das alles beim zweiten Check-Versuch passiert.
:::

::: paragraph
Damit der Handler überhaupt aufgerufen wird, ist es in diesem Beispiel
also notwendig, dass per Regel [Maximum number of check attempts for
service]{.guihint} die Anzahl der Versuche mindestens auf 2 eingestellt
wird. Um einen Alert im Falle eines erfolgreichen Garbage Collectors zu
vermeiden, sollte die Anzahl auf 3 eingestellt werden. Denn wenn der
Handler direkt nach dem zweiten Versuch das Problem beheben konnte,
sollte der dritte Versuch wieder den Zustand [OK]{.state0} feststellen
und somit kein Alert mehr notwendig sein.
:::

::: paragraph
**Hinweis:** Anders als an anderen Stellen von Checkmk, wird bei den
Alert Handlers **jede** Regel ausgeführt, deren Bedingung erfüllt ist.
Sogar wenn zwei zutreffende Regeln jeweils den gleichen Handler
auswählen, wird dieser also auch tatsächlich zweimal getriggert. Der
Alert Helper (der im nächsten Kapitel beschrieben wird) wird dann die
zweite Ausführung in der Regel wieder mit einer Fehlermeldung
unterdrücken, da der gleiche Handler niemals mehrfach gleichzeitig
laufen soll. Trotzdem ist es besser, wenn Sie Ihre Regeln so schreiben,
dass dieser Fall nicht auftritt.
:::
::::::::::
:::::::::::

::::::::::::::::::::::::::::: sect1
## []{#execution .hidden-anchor .sr-only}4. Wie Alert Handlers ausgeführt werden {#heading_execution}

:::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_asynchrone_ausführung .hidden-anchor .sr-only}4.1. Asynchrone Ausführung {#heading__asynchrone_ausführung}

::: paragraph
Sehr oft werden Alert Handlers dazu benutzt, sich remote per SSH oder
einem anderen Protokoll auf der betroffenen Maschine anzumelden und dort
skriptgesteuert eine Aktion auszuführen. Da die Maschine ja gerade ein
Problem hat, ist es nicht ausgeschlossen, dass die Verbindung sehr lange
dauert oder sogar in einen Timeout läuft.
:::

::: paragraph
Da während dieser Zeit natürlich weder das Monitoring stehen bleiben
darf noch andere Alert Handlers aufgehalten werden dürfen, werden Alert
Handlers grundsätzlich *asynchron* ausgeführt. Verantwortlich dafür ist
ein Hilfsprozess --- der Alert Helper ---  welcher vom [CMC](cmc.html)
automatisch gestartet wird. Um Overhead zu vermeiden, geschieht dies
allerdings nur, wenn Sie mindestens eine Regel für Alert Handlers
angelegt haben. Im `cmc.log` sehen Sie dann folgende Zeile:
:::

::::: listingblock
::: title
\~/var/log/cmc.log
:::

::: content
``` {.pygments .highlight}
2016-07-19 15:17:00 [5] Alert handlers have been switched on
```
:::
:::::

::: paragraph
Der Alert Helper bekommt vom CMC bei jeder Zustandsänderung eines Hosts
oder Services eine Benachrichtigung mit allen Informationen zu dem
Ereignis. Nun wertet er alle Alert-Regeln aus und stellt so fest, ob ein
Handler aufgerufen werden soll. Falls ja, wird das entsprechende Skript
als externer Prozess gestartet und im Hintergrund ausgeführt.
:::
:::::::::

:::: sect2
### []{#_stoppen_des_monitoring_kerns .hidden-anchor .sr-only}4.2. Stoppen des Monitoring-Kerns {#heading__stoppen_des_monitoring_kerns}

::: paragraph
Wenn Sie den CMC stoppen (z.B. durch `omd stop` oder durch
Herunterfahren des Monitoring-Servers), werden alle noch laufenden Alert
Helper **abgebrochen.** Diese werden später **nicht wiederholt.** Denn
wer weiß schon, wie viel später dieses „später" sein wird. Eventuell ist
dann ein Neustart von einem Dienst oder dergleichen eher schädlich als
nützlich!
:::
::::

:::: sect2
### []{#_timeouts .hidden-anchor .sr-only}4.3. Timeouts {#heading__timeouts}

::: paragraph
Um sich im Fall eines Fehlers vor zu vielen Prozessen zu schützen, gilt
für die Laufzeit eines Alert Handlers ein Timeout von (einstellbar) 60
Sekunden. Nach Ablauf dieser Zeit wird der Handler beendet. Im Detail
heißt das, dass nach Ablauf des Timeouts ein Signal 15 (`SIGTERM`) an
den Handler geschickt wird. So hat dieser die Gelegenheit, sich sauber
zu beenden. Nach weiteren 60 Sekunden (doppelter Timeout) wird er dann
mit Signal 9 (`SIGKILL`) endgültig „abgeschossen".
:::
::::

:::: sect2
### []{#_überlagerung .hidden-anchor .sr-only}4.4. Überlagerung {#heading__überlagerung}

::: paragraph
Checkmk verhindert die gleichzeitige Ausführung von Alert Helpers, wenn
diese den gleichen Host/Service betreffen und das gleiche Skript mit den
gleichen Parametern ausführen würden. So ein Fall deutet darauf hin,
dass der erste Handler noch am Laufen ist und es keinen Sinn macht,
einen zweiten gleichen Handler zu starten. Der zweite Handler wird dann
sofort abgebrochen und als gescheitert gewertet.
:::
::::

:::: sect2
### []{#_exit_codes_und_ausgaben .hidden-anchor .sr-only}4.5. Exit Codes und Ausgaben {#heading__exit_codes_und_ausgaben}

::: paragraph
Ausgaben und Exit Codes der Alert Handlers werden sauber ausgewertet,
zum Kern zurück transportiert und dort in die Historie des Monitorings
geschrieben. Außerdem können sie zu einer Benachrichtigung führen (siehe
[unten](#notification)).
:::
::::

::::::: sect2
### []{#_globale_einstellungen .hidden-anchor .sr-only}4.6. Globale Einstellungen {#heading__globale_einstellungen}

::: paragraph
Für die Ausführung der Alert Handlers gibt es etliche globale
Einstellungen:
:::

:::: imageblock
::: content
![\]](../images/alert_handlers_options.png)
:::
::::

::: paragraph
Das [Alert handler log level]{.guihint} hingegen beeinflusst das Logging
in der Alert Helper Log-Datei (`~/var/log/alerts.log`).
:::
:::::::

::::::: sect2
### []{#_master_control .hidden-anchor .sr-only}4.7. Master control {#heading__master_control}

:::: {.imageblock .inline-image}
::: content
![alert handlers master control
off](../images/alert_handlers_master_control_off.png){width="350"}
:::
::::

::: paragraph
Mit einem Klick in das [Snapin](glossar.html#snapin) [Master
control]{.guihint} können Sie Alert Handlers global deaktivieren.
Bereits laufende Handlers sind davon *nicht* betroffen und werden noch
fertig ausgeführt.
:::

::: paragraph
Vergessen Sie nicht, den kleinen Schalter beizeiten wieder auf grün zu
stellen! Sie könnten sich sonst zu Unrecht in Sicherheit wiegen, dass
das Monitoring alles wieder repariert  ...​\
\
\
:::
:::::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

:::::::::::::: sect1
## []{#history .hidden-anchor .sr-only}5. Alert Handlers in der Historie {#heading_history}

::::::::::::: sectionbody
::: paragraph
Alert Handlers erzeugen Einträge in der Monitoring-Historie. Damit haben
Sie eine bessere Nachvollziehbarkeit, als allein durch die Log-Datei
`alerts.log`. Es wird ein Eintrag erzeugt, sobald ein Alert Handler
gestartet wird und auch wenn er sich beendet.
:::

::: paragraph
Die Alert Handlers werden dabei so betrachtet wie klassische
Monitoring-Plugins. Das heißt, sie sollen eine Zeile Text ausgeben und
als Exit Code einen der vier Werte 0 ([OK]{.state0}), 1
([WARN]{.state1}), 2 ([CRIT]{.state2}) oder 3 ([UNKNOWN]{.state3})
zurückgeben. Alle Fehler, die eine Ausführung des Handlers von
vornherein verhindern (Abbruch wegen Doppelausführung, Skript nicht
vorhanden, Timeout, etc.), werden automatisch mit [UNKNOWN]{.state3}
bewertet.
:::

::: paragraph
Der Aufruf von folgendem sehr einfachen Handler  ...​
:::

::::: listingblock
::: title
\~/local/share/check_mk/alert_handlers/dummy
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# Dummy handler for testing

sleep 3
echo "Everything is fine again"
exit 0
```
:::
:::::

::: paragraph
\... sieht in der Historie des betroffenen Services dann z.B. so aus
(wie immer sind die neuen Meldungen oben):
:::

:::: imageblock
::: content
![alert handler history](../images/alert_handler_history.png)
:::
::::

::: paragraph
In der allgemeinen Ansicht [Monitor \> System \> Alert handler
executions]{.guihint} werden zudem alle Ausführungen der Alert Handlers
zusammen dargestellt.
:::
:::::::::::::
::::::::::::::

:::::::: sect1
## []{#notification .hidden-anchor .sr-only}6. Benachrichtigungen über Alert Handlers {#heading_notification}

::::::: sectionbody
::: paragraph
Die Ausführung eines Alert Handlers --- genauer gesagt die *Beendigung*
der Ausführung --- ist ein Ereignis, das zu einer
[Benachrichtigung](notifications.html) führt. So können Sie sich
informieren lassen, wenn ein Handler seine Arbeit verrichtet hat. Dazu
gibt es zwei Ereignistypen, auf die Sie in einer Benachrichtigungsregel
filtern können:
:::

:::: imageblock
::: content
![alert handler notif
condition](../images/alert_handler_notif_condition.png)
:::
::::

::: paragraph
Sie können also auch zwischen erfolgreich ausgeführten Handlers (Exit
Code 0 - [OK]{.state0}) und gescheiterten (alle anderen Codes)
unterscheiden. Die E-Mail-Benachrichtigung von Checkmk zeigt nicht die
Ausgabe des Checks, sondern die Ausgabe des Alert Handlers.
:::
:::::::
::::::::

:::::::::::::::: sect1
## []{#check_execution .hidden-anchor .sr-only}7. Alert Handler bei jeder Check-Ausführung {#heading_check_execution}

::::::::::::::: sectionbody
::: paragraph
Normalerweise werden Alert Handlers nur aufgerufen, wenn sich der
Zustand eines Hosts oder Services ändert (oder während der
Wiederholversuche bei Problemen). Einfache Check-Ausführungen ohne
Zustandsänderung lösen keinen Alert Handler aus.
:::

::: paragraph
Über die globale Einstellung [Global settings \> Alert handlers \> Types
of events that are being processed \> All check executions!]{.guihint}
können Sie genau das umstellen. **Jede** Ausführung eines Checks löst
dann potenziell Alert Handlers aus. Sie können das z.B. nutzen, um die
laufenden Monitoring-Daten in andere Systeme zu übertragen.
:::

::: paragraph
Seien Sie mit dieser Einstellung vorsichtig! Das Starten von Prozessen
und Aufrufen von Skripten sind sehr CPU-lastige Operationen. Checkmk
kann spielend 1000 Checks pro Sekunde durchführen --- aber 1000 Alert
Handler-Skripte pro Sekunde schafft Linux ganz sicher nicht.
:::

::: paragraph
Um das Ganze dennoch sinnvoll möglich zu machen, bietet Checkmk die
Möglichkeit, Alert Handlers als **Python-Funktionen** zu schreiben,
welche dann inline laufen --- ohne Prozesserzeugung. So einen Inline
Handler legen Sie einfach im gleichen Verzeichnis ab wie die normalen
Handler-Skripte. Folgendes funktionierendes Beispiel zeigt die Struktur
eines Inline Handlers:
:::

::::: listingblock
::: title
\~/local/share/check_mk/alert_handlers/foo
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/python
# Inline: yes

# Do some basic initialization (optional)
def handle_init():
    log("INIT")

# Called at shutdown (optional)
def handle_shutdown():
    log("SHUTDOWN")

# Called at every alert (mandatory)
def handle_alert(context):
    log("ALERT: %s" % context)
```
:::
:::::

::: paragraph
Das Skript hat keine Hauptfunktion, sondern definiert lediglich drei
Funktionen. Dabei ist nur die Funktion `handle_alert()` vorgeschrieben.
Sie wird nach jeder Check-Ausführung aufgerufen und bekommt im Argument
`context` ein Python-Dictionary mit Variablen wie `"HOSTNAME"`,
`"SERVICEOUTPUT"` usw. Dies entspricht den Umgebungsvariablen, die auch
die normalen Handlers bekommen --- allerdings ohne den Präfix `ALERT_`.
Sie können das Beispiel verwenden, um sich den Inhalt von `context`
anzusehen.
:::

::: paragraph
Alle Ausgaben, die die Hilfsfunktion `log()` erzeugt, landen in
`~/var/log/alert.log`. Die beiden globalen Variablen `omd_root` und
`omd_site` sind gesetzt auf das Home-Verzeichnis bzw. den Namen der
Checkmk-Instanz.
:::

::: paragraph
Die Funktionen `handle_init()` und `handle_shutdown()` werden von
Checkmk beim Starten bzw. Stoppen des Monitoring-Kerns aufgerufen und
ermöglichen Ihnen eine Initialisierung, z.B. den Aufbau einer Verbindung
zu einer Datenbank.
:::

::: paragraph
Weitere Hinweise:
:::

::: ulist
- Beachten Sie das `# Inline: yes` in der zweiten Zeile.

- Nach jeder Änderung in dem Skript muss der Kern neu gestartet werden
  (`omd restart cmc`).

- `import`-Befehle sind erlaubt.

- Der Alert Helper von Checkmk ruft Ihre Funktionen **synchron** auf.
  Achten Sie darauf, dass keine Wartezustände entstehen!
:::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#linux_remote .hidden-anchor .sr-only}8. Remote-Ausführung unter Linux {#heading_linux_remote}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_grundprinzipien .hidden-anchor .sr-only}8.1. Grundprinzipien {#heading__grundprinzipien}

::: paragraph
Jede Checkmk-Version bringt einen Alert Handler mit, der die sichere
Ausführung von Skripten auf überwachten Linux-Systemen ermöglicht.
Wichtigste Eigenschaften dieser Lösung sind:
:::

::: ulist
- Die Skripte werden per SSH mit Befehlsbeschränkung (*command
  restriction*) aufgerufen.

- Es können keine beliebigen Befehle, sondern nur die von Ihnen
  definierten aufgerufen werden.

- Das Ganze kann komplett mit der
  [Agentenbäckerei](glossar.html#agent_bakery) aufgesetzt werden.
:::

::: paragraph
Die *Linux Remote Alert Handlers* bestehen aus folgenden Einzelteilen:
:::

::: ulist
- Der Alert Handler `linux_remote` mit dem Titel `Linux via SSH` auf dem
  Checkmk-Server.

- Das Skript `mk-remote-alert-handler` auf dem Zielsystem.

- Von Ihnen geschriebene Skripte („Remote Handlers") auf dem Zielsystem.

- Einträge in `.ssh/authorized_keys` desjenigen Benutzers auf dem
  Zielsystem, der diese ausführen soll.

- Regeln in [Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agent
  rules \> Linux Agent \> Remote alert handlers (Linux)]{.guihint},
  welche SSH-Schlüssel generieren.

- Alert Handler-Regeln, welche `linux_remote` aufrufen.
:::
:::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_aufsetzen .hidden-anchor .sr-only}8.2. Aufsetzen {#heading__aufsetzen}

::: paragraph
Angenommen, Sie möchten auf dem Linux-System `myserver123` das Skript
`/etc/init.d/foo restart` ausführen, wann immer der Service *Process
FOO* kritisch wird (welchen Sie bereits eingerichtet haben). Gehen Sie
wie folgt vor:
:::

::::::::::: sect3
#### []{#_remote_handler_schreiben .hidden-anchor .sr-only}Remote Handler schreiben {#heading__remote_handler_schreiben}

::: paragraph
Schreiben Sie zunächst das Skript, das auf dem Zielsystem ausgeführt
werden soll. Da Sie mit der
[Agentenbäckerei](wato_monitoringagents.html#bakery) arbeiten, legen Sie
das Skript **auf dem Checkmk-Server** an (nicht auf dem Zielsystem!).
Das korrekte Verzeichnis dafür ist
`~/local/share/check_mk/agents/linux/alert_handlers`. Auch hier sorgt
der Kommentar in der zweiten Zeile für einen Titel zur Auswahl in der
Benutzeroberfläche:
:::

::::: listingblock
::: title
\~/local/share/check_mk/agents/linux/alert_handlers/restart_foo
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# Restart FOO service

/etc/init.d/foo restart || {
    echo "Could not restart FOO."
    exit 2
}
```
:::
:::::

::: paragraph
Machen Sie das Skript ausführbar:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cd local/share/check_mk/agents/linux/alert_handlers
OMD[mysite]:~$ chmod +x restart_foo
```
:::
::::

::: paragraph
Das Beispielskript ist so gebaut, dass es sich im Fehlerfall mit dem
Code 2 beendet, so dass der Alert Handler dies als [CRIT]{.state2}
werten wird.
:::
:::::::::::

:::::::::::: sect3
#### []{#_agentenpaket_mit_dem_handler_vorbereiten .hidden-anchor .sr-only}Agentenpaket mit dem Handler vorbereiten {#heading__agentenpaket_mit_dem_handler_vorbereiten}

::: paragraph
Wir beschreiben hier das Vorgehen mit der Agentenbäckerei. Hinweise für
ein Aufsetzen von Hand finden Sie weiter [unten.](#manual_setup)
:::

::: paragraph
Legen Sie eine Regel unter [Setup \> Agents \> Windows, Linux, Solaris,
AIX \> Agent rules \> Linux Agent \> Remote alert handlers
(Linux)]{.guihint} an. In den Eigenschaften sehen Sie den Remote Handler
`Restart FOO service`, den Sie gerade angelegt haben. Wählen Sie diesen
zur Installation aus:
:::

:::: imageblock
::: content
![alert handlers install
remote](../images/alert_handlers_install_remote.png)
:::
::::

::: paragraph
Nachdem Sie gespeichert haben, sehen Sie die Regel in der Liste: Es
wurde automatisch ein SSH-Schlüsselpaar für den Aufruf des Handlers
„ausgewürfelt", dessen Fingerprint in der Regel angezeigt wird. In dem
Screenshot wurde er aus Gründen der Darstellung gekürzt:
:::

:::: imageblock
::: content
![alert handlers install
remote2](../images/alert_handlers_install_remote2.png)
:::
::::

::: paragraph
Der öffentliche Schlüssel ist für den Agenten vorgesehen. Der private
Schlüssel wird vom Checkmk-Server später benötigt, um das so
installierte Skript ohne Eingabe eines Passworts aufrufen zu können.
:::

::: paragraph
Sie können auch einen anderen Benutzer als `root`
verwenden --- natürlich nur, wenn dieser ausreichend Rechte für die
benötigte Aktion hat. Der Checkmk-Agent installiert den SSH-Schlüssel
nur auf Systemen, auf denen dieser Benutzer bereits existiert.
:::
::::::::::::

:::::: sect3
#### []{#_agent_backen .hidden-anchor .sr-only}Agent backen {#heading__agent_backen}

::: paragraph
Backen Sie nun neue Agenten mit [![button bake
agents](../images/icons/button_bake_agents.png)]{.image-inline}. In der
Liste der fertigen Agenten muss nun ein Eintrag auftauchen, in dem Sie
wieder Ihren Remote Handler und SSH-Schlüssel sehen. Auch hier wurde der
Screenshot --- um die Anzahl der möglichen Pakete, die Sie herunterladen
können --- gekürzt:
:::

:::: imageblock
::: content
![alert handlers baked
handler](../images/alert_handlers_baked_handler.png)
:::
::::
::::::

:::::::::::: sect3
#### []{#_agent_installieren .hidden-anchor .sr-only}Agent installieren {#heading__agent_installieren}

::: paragraph
Installieren Sie nun das RPM- oder DEB-Paket auf Ihrem Zielsystem (die
Installation des TGZ-Archivs kann die SSH-Schlüssel nicht aufsetzen und
ist deshalb unvollständig). Bei der Installation geschehen folgende
Dinge:
:::

::: ulist
- Ihr Remote Handler-Skript wird installiert.

- Das Hilfsprogramm `mk-remote-alert-handler` wird installiert.

- Beim gewählten Benutzer (hier `root`) wird ein Eintrag in
  `authorized_keys` gemacht, der die Ausführung des Handlers ermöglicht.

- Das Verzeichnis `.ssh` und die Datei `authorized_keys` werden bei
  Bedarf automatisch angelegt.
:::

::: paragraph
Bei der Installation via DEB sieht das etwa so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@myserver123:~# dpkg -i check-mk-agent_2016.07.19-9d3ab34905da4934_all.deb
Selecting previously unselected package check-mk-agent.
(Reading database ... 515080 files and directories currently installed.)
Preparing to unpack ...check-mk-agent_2016.07.19-9d3ab34905da4934_all.deb ...
Unpacking check-mk-agent (2016.07.19-9d3ab34905da4934) ...
Setting up check-mk-agent (2016.07.19-9d3ab34905da4934) ...
Reloading xinetd...
 * Reloading internet superserver configuration xinetd                            [ OK ]
Package 9d3ab34905da4934: adding SSH keys for Linux remote alert handlers for user root...
```
:::
::::

::: paragraph
Ein Blick in die SSH-Konfiguration von `root` zeigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@myserver123:~# cat /root/.ssh/authorized_keys
command="/usr/bin/mk-remote-alert-handler restart_foo",no-port-forwarding,no-x11-forwarding,no-agent-forwarding ssh-rsa  AAAAB3NzaC1yc2EAAAADAQABAAACAQCqoDVNFEbTqYEmhSZhUMvRy5SqGIPp1nE+EJGw1LITV/rej4AAiUUBYwMkeo5aBC6VOXkq78CdRuReSozec3krKkkwVbgYf98Wtc6N3WiljS85PLAVvPadJiJCkXFctbxyI2xeF5TQ1VKDRvzbBjXE9gjTnLWbPy77RC8SVXLoOQgabixpWQquIIdGyccPsWGTRgeI7Ua0lgWZQUJt7OIKQ0X7Syv2VHKJNqtW28IWu8y2hBEY/TERip5EQoNT/VclhHqjDG2y3F45PswcXD5in6y30EnfHGcwk+PD6fgp7jPGbO2+QBUwYgW67GmRpbaVQ97CqXFJvORNF+C6+O8DNweyH3ogspjfKvM7eN+M4NIJzjMRyNBMzqF3VmrMeqpzRjfFj2BS/8UbXGgHzZRapwrK3+GXX1pG49n77cIs+GWos9xb1DxX1pEu2tgQwRBBhYcTkk2eKkH18LKzFUyObxtQmf40C24cdQOp6USbwzsniqehsLIHH2unQ7bW6opF/GiaEjZamGbgsPOe8rmey5Vcd//e8cS+OsmcPZNybsTJpBeHpes+5bw0e1POw9GD9qptylrQLYIO5R467Ov8YlRFgYKyaDFHD40j5/JHPzmtp4vjH8Si7YZZOzvTRgBYEoEgbLS5dgdr/I5ZMRKfDPCpRUbGhp9kUEdGX99o5Q== mk-remote-alert-handler-9d3ab34905da4934
```
:::
::::

::: paragraph
Beachten Sie noch, dass Ihr System eventuell so eingestellt ist, dass
ein SSH-Zugriff als `root` generell nicht möglich ist. In diesem Fall
können Sie über einen anderen Benutzer gehen und dort mit `sudo`
arbeiten, was so konfiguriert ist, dass der gewünschte Befehl ohne
Passwort ausgeführt werden kann.
:::
::::::::::::

::::::: sect3
#### []{#_handler_per_regel_aufrufen .hidden-anchor .sr-only}Handler per Regel aufrufen {#heading__handler_per_regel_aufrufen}

::: paragraph
Sie sind fast am Ziel. Der Agent ist bereit. Nun fehlt nur noch eine
Regel, um den Alert Handler auch wirklich aufzurufen. Das Vorgehen ist
wie am Anfang dieses Artikels beschrieben und geschieht über das Anlegen
einer entsprechenden Regel. Wählen Sie als Handler dieses Mal
`Linux via SSH` aus, tragen Sie den Benutzer ein, bei dem der
SSH-Schlüssel installiert wurde, und wählen Sie Ihren Remote Handler
aus:
:::

:::: imageblock
::: content
![alert handlers rule foo](../images/alert_handlers_rule_foo.png)
:::
::::

::: paragraph
Setzen Sie auch eine sinnvolle Bedingung in der Regel, denn sonst wird
bei **jedem** Service-Alert versucht, eine SSH-Verbindung zum Ziel-Host
aufzubauen!
:::
:::::::

:::::::: sect3
#### []{#_test .hidden-anchor .sr-only}Test {#heading__test}

::: paragraph
Wenn Sie den betroffenen Service jetzt z.B. von Hand auf [CRIT]{.state2}
setzen, sehen Sie nach kurzer Zeit in der Historie des Services:
:::

:::: imageblock
::: content
![alert handlers foo failing](../images/alert_handlers_foo_failing.png)
:::
::::

::: paragraph
Da es natürlich keinen Dienst `foo` gibt, klappt auch
`/etc/init.d/foo restart` nicht. Aber Sie können daran sehen, dass
dieser Befehl ausgeführt und auch der Fehlerstatus korrekt
zurückgemeldet wurde. Und Checkmk hat eine Benachrichtigung ausgelöst,
da sich ein Alert Handler beendet hat.
:::

::: paragraph
Die Meldung
`Warning: Permanently added '127.0.0.1' (ECDSA) to the list of known hosts.`
ist übrigens harmlos und tritt nur beim ersten Kontakt mit dem Host auf.
Um den aufwendigen manuellen Austausch des Host Key zu vermeiden, wird
SSH mit `-o StrictHostKeyChecking=false` aufgerufen. Bei der ersten
Verbindung wird der Schlüssel dann für die Zukunft gespeichert.
:::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::::: sect2
### []{#manual_setup .hidden-anchor .sr-only}8.3. Aufsetzen ohne Agentenbäckerei {#heading_manual_setup}

::: paragraph
Ein Präparieren des Agenten von Hand geht natürlich auch. Für diesen
Fall empfehlen wir, dass Sie auf einem Testsystem das Verfahren mit der
Agentenbäckerei durchführen und sich dann die betroffenen Dateien
ansehen und auf Ihrem System von Hand nachbauen. Eine Liste der Pfade
finden Sie [hier.](#files_agent)
:::

::: paragraph
Wichtig dabei ist, dass Sie auch in diesem Fall in der Agentenbäckerei
eine Regel für die Installation der Remote Handlers anlegen. Denn in
dieser Regel werden die SSH-Schlüssel für den Zugriff generiert und auch
vom Alert Handler verwendet! Den öffentlichen Schlüssel für die
Installation in `authorized_keys` finden Sie in der Konfigurationsdatei
`~/etc/check_mk/conf.d/wato/rules.mk` (oder in `rules.mk` in einem
Unterordner).
:::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#files .hidden-anchor .sr-only}9. Dateien und Verzeichnisse {#heading_files}

::::: sectionbody
::: sect2
### []{#files_server .hidden-anchor .sr-only}9.1. Pfade auf dem Checkmk-Server {#heading_files_server}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/var/log/alerts.log`            | Log-Datei mit allen Ereignissen   |
|                                   | rund um die Alert Handlers (vom   |
|                                   | Alert Helper geschrieben).        |
+-----------------------------------+-----------------------------------+
| `~/var/log/cmc.log`               | Log-Datei des Kerns. Auch hier    |
|                                   | landen teilweise Informationen zu |
|                                   | Alert Handlers.                   |
+-----------------------------------+-----------------------------------+
| `~/loca                           | Legen Sie hier Ihre selbst        |
| l/share/check_mk/alert_handlers/` | geschriebenen Alert Handlers ab.  |
+-----------------------------------+-----------------------------------+
| `~/var/check_mk/core/history`     | Log-Datei der                     |
|                                   | Monitoring-Historie, wird vom     |
|                                   | Kern geschrieben und auch         |
|                                   | ausgewertet.                      |
+-----------------------------------+-----------------------------------+
| `~/local/share/check              | Remote Alert Handlers, die auf    |
| _mk/agents/linux/alert_handlers/` | Linux-Systemen ausgeführt werden  |
|                                   | sollen.                           |
+-----------------------------------+-----------------------------------+
:::

::: sect2
### []{#files_agent .hidden-anchor .sr-only}9.2. Pfade auf dem überwachten Linux-Host {#heading_files_agent}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `                                 | Hilfsskript zur Ausführung der    |
| /usr/bin/mk-remote-alert-handler` | Remote Handlers.                  |
+-----------------------------------+-----------------------------------+
| `/usr/li                          | Von Ihnen geschriebene Remote     |
| b/check_mk_agent/alert_handlers/` | Handlers.                         |
+-----------------------------------+-----------------------------------+
| `/root/.ssh/authorized_keys`      | SSH-Konfiguration für den         |
|                                   | Benutzer `root`.                  |
+-----------------------------------+-----------------------------------+
| `~harri/.ssh/authorized_keys`     | SSH-Konfiguration für einen       |
|                                   | Benutzer `harri`.                 |
+-----------------------------------+-----------------------------------+
:::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
