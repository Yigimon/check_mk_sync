:::: {#header}
# Die Event Console

::: details
[Last modified on 02-Dec-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/ec.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Grundlagen des Monitorings mit Checkmk](monitoring_basics.html)
[Regeln](wato_rules.html) [Statusdaten abrufen via
Livestatus](livestatus.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::::::::: sectionbody
::::: sect2
### []{#_ereignisse_sind_keine_zustände .hidden-anchor .sr-only}1.1. Ereignisse sind keine Zustände {#heading__ereignisse_sind_keine_zustände}

::: paragraph
Die Hauptaufgabe von Checkmk ist das aktive Überwachen von *Zuständen.*
Zu jedem Zeitpunkt hat jeder überwachte Service einen der Zustände
[OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2} oder [UNKNOWN]{.state3}.
Durch regelmäßige Abfragen aktualisiert das Monitoring ständig sein Bild
von der Lage.
:::

::: paragraph
Eine ganz andere Art des Monitorings ist das Arbeiten mit *Ereignissen*
(*events*). Ein Beispiel für ein Ereignis ist eine Exception, die in
einer Anwendung auftritt. Die Anwendung läuft eventuell korrekt weiter
und hat nach wie vor den Zustand [OK]{.state0} --- aber irgendetwas *ist
passiert.*
:::
:::::

:::::::::: sect2
### []{#_die_event_console .hidden-anchor .sr-only}1.2. Die Event Console {#heading__die_event_console}

::: paragraph
Checkmk verfügt mit der **Event Console** (kurz EC) über ein voll
integriertes System zur Überwachung von Ereignissen aus Quellen wie
Syslog, SNMP-Traps, Windows Event Logs, Log-Dateien und eigenen
Anwendungen. Dabei werden aus Ereignissen nicht einfach Zustände
gemacht, sondern sie bilden eine eigene Kategorie und werden von Checkmk
sogar im [Overview]{.guihint} der
[Seitenleiste](user_interface.html#sidebar) mit angezeigt:
:::

:::: imageblock
::: content
![Das Snapin Overview mit der Anzeige der
Ereignisse.](../images/ec_overview_events.png){width="50%"}
:::
::::

::: paragraph
Intern werden Ereignisse nicht durch den Monitoring-Kern, sondern von
einem eigenen Dienst verarbeitet --- dem *Event Daemon* (`mkeventd`).
:::

::: paragraph
Die Event Console verfügt auch über ein Archiv, in dem Sie über
Ereignisse in der Vergangenheit recherchieren können. Gleich vorweg sei
allerdings gesagt: Dies ist kein Ersatz für ein echtes Log-Archiv. Die
Aufgabe der Event Console ist das intelligente Herausfiltern einer
*kleinen* Zahl von *relevanten* Meldungen aus einem großen Strom. Sie
ist optimiert auf Einfachheit, Robustheit und Durchsatz --- nicht auf
Speicherung großer Datenmengen.
:::

::: paragraph
Ein kurzer Abriss der Funktionalität der EC:
:::

::: ulist
- Sie kann Meldungen per Syslog oder SNMP-Traps *direkt* empfangen. Eine
  Konfiguration der entsprechenden Linux-Systemdienste ist daher nicht
  notwendig.

- Sie kann mithilfe der Checkmk-Agenten auch textbasierte Log-Dateien
  und Windows Event Logs auswerten.

- Sie klassifiziert Meldungen anhand einer Kette von benutzerdefinierten
  Regeln.

- Sie kann Meldungen korrelieren, zusammenfassen, zählen, annotieren,
  umschreiben und auch deren zeitliche Zusammenhänge berücksichtigen.

- Sie kann automatisiert Aktionen ausführen und über Checkmk
  [Benachrichtigungen](notifications.html) versenden.

- Sie ist voll in die Oberfläche von Checkmk integriert.

- Sie ist in jedem aktuellen Checkmk-System enthalten und sofort
  einsatzfähig.
:::
::::::::::

::::::: sect2
### []{#_begriffe .hidden-anchor .sr-only}1.3. Begriffe {#heading__begriffe}

::: paragraph
Die Event Console empfängt **Meldungen** (meist in Form von *Log
Messages*). Eine Meldung ist eine Zeile Text mit einer Reihe von
möglichen Zusatzattributen, wie z.B. einem Zeitstempel, einem Host-Namen
usw. Wenn die Meldung relevant ist, wird daraus direkt ein **Event** mit
den gleichen Attributen, aber:
:::

::: ulist
- Nur wenn eine Regel greift, wird aus einer Meldung ein Event erzeugt.

- Regeln können den Text und andere Attribute von Meldungen verändern.

- Mehrere Meldungen können zu einem Event zusammengefasst werden.

- Meldungen können aktuelle Events wieder [aufheben](#canceling).

- Künstliche Events können erzeugt werden, wenn bestimmte [Meldungen
  ausbleiben](#expect).
:::

::: paragraph
Ein Event kann verschiedene **Phasen** durchlaufen:
:::

+-------------+--------------------------------------------------------+
| **open**    | Der „normale" Zustand: Etwas ist passiert: der         |
|             | Operator soll sich kümmern.                            |
+-------------+--------------------------------------------------------+
| **ack       | Das Problem wurde quittiert --- dies ist analog zu     |
| nowledged** | Host- und Service-Problemen aus dem statusbasierten    |
|             | Monitoring.                                            |
+-------------+--------------------------------------------------------+
| *           | Es ist noch nicht die erforderliche Anzahl von         |
| *counting** | bestimmten Meldungen eingetroffen: die Situation ist   |
|             | noch unproblematisch. Das Ereignis wird dem Operator   |
|             | deswegen noch nicht angezeigt.                         |
+-------------+--------------------------------------------------------+
| **delayed** | Eine Störmeldung ist eingegangen, aber die Event       |
|             | Console wartet noch, ob in einer konfigurierten Zeit   |
|             | die passende [OK]{.state0}-Meldung eingeht. Erst       |
|             | danach wird das Event dem Operator angezeigt.          |
+-------------+--------------------------------------------------------+
| **closed**  | Das Event wurde vom Operator oder automatisch          |
|             | geschlossen und ist nur noch im Archiv.                |
+-------------+--------------------------------------------------------+

::: paragraph
Ein Event hat ferner einen **Zustand.** Genau genommen ist hier aber
nicht der Zustand des Events selbst gemeint, sondern des Dienstes oder
Gerätes, der/das den Event gesendet hat. Um eine Analogie zum
statusbasierten Monitoring zu schaffen, ist auch ein Event als
[OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2} oder [UNKNOWN]{.state3}
eingestuft.
:::
:::::::
:::::::::::::::::::
::::::::::::::::::::

:::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}2. Die Event Console aufsetzen {#heading_setup}

::::::::::::: sectionbody
::: paragraph
Das Einrichten der Event Console ist sehr einfach, da die Event Console
fester Bestandteil von Checkmk ist und automatisch aktiviert wird.
:::

::: paragraph
Falls Sie jedoch über das Netzwerk Syslog-Meldungen oder SNMP-Traps
empfangen möchten, so müssen Sie dies separat aktivieren. Der Grund ist,
dass beide Dienste einen UDP-Port mit einer jeweils bestimmten bekannten
Portnummer öffnen müssen. Und da dies pro System nur eine Checkmk
Instanz machen kann, ist der Empfang über das Netzwerk per Default
abgeschaltet.
:::

::: paragraph
Die Port-Nummern sind:
:::

+----------------------+----------------------+-----------------------+
| Protokoll            | Port                 | Dienst                |
+======================+======================+=======================+
| UDP                  | 162                  | SNMP-Traps            |
+----------------------+----------------------+-----------------------+
| UDP                  | 514                  | Syslog                |
+----------------------+----------------------+-----------------------+
| TCP                  | 514                  | Syslog via TCP        |
+----------------------+----------------------+-----------------------+

::: paragraph
Syslog via TCP wird nur selten verwendet, hat aber den Vorteil, dass die
Übertragung der Meldungen hier abgesichert wird. Bei UDP ist niemals
garantiert, dass Pakete wirklich ankommen. Und weder Syslog noch
SNMP-Traps bieten Quittungen oder einen ähnlichen Schutz vor
verlorengegangen Meldungen. Damit Sie Syslog via TCP verwenden können,
muss natürlich auch das sendende System dazu in der Lage sein, Meldungen
über diesen Port zu verschicken.
:::

::: paragraph
In der Checkmk Appliance können Sie den Empfang von Syslog/SNMP-Traps in
der Instanzkonfiguration einschalten. Ansonsten verwenden Sie einfach
`omd config`. Sie finden die benötigte Einstellung unter
[Addons]{.guihint}:
:::

:::: imageblock
::: content
![ec omd config](../images/ec_omd_config.png){width="360"}
:::
::::

::: paragraph
Beim `omd start` sehen Sie in der Zeile mit `mkeventd`, welche externen
Schnittstellen Ihre EC offen hat:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Creating temporary filesystem /omd/sites/mysite/tmp...OK
Starting mkeventd (builtin: syslog-udp,snmptrap)...OK
Starting liveproxyd...OK
Starting mknotifyd...OK
Starting rrdcached...OK
Starting cmc...OK
Starting apache...OK
Starting dcd...OK
Starting redis...OK
Initializing Crontab...OK
```
:::
::::
:::::::::::::
::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_erste_schritte_mit_der_event_console .hidden-anchor .sr-only}3. Erste Schritte mit der Event Console {#heading__erste_schritte_mit_der_event_console}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#first_steps_rules .hidden-anchor .sr-only}3.1. Regeln, Regeln, Regeln {#heading_first_steps_rules}

::: paragraph
Eingangs wurde erwähnt, dass die EC dazu dient, *relevante* Meldungen
herauszufischen und anzuzeigen. Nun ist es leider so, dass die meisten
Meldungen --- egal ob aus Textdateien, dem Windows Event Log oder dem
Syslog --- ziemlich unwichtig sind. Und da hilft es auch nichts, wenn
Meldungen seitens des Verursachers bereits voreingestuft sind.
:::

::: paragraph
Zum Beispiel gibt es in Syslog und im Windows Event Log eine
Klassifizierung der Meldungen in etwas Ähnliches wie OK, WARN und CRIT.
Aber was jetzt WARN und CRIT ist, hat dabei der jeweilige Programmierer
subjektiv festgelegt. Und es ist noch nicht einmal gesagt, dass die
Anwendung, welche die Meldung produziert hat, auf diesem Rechner
überhaupt wichtig ist. Kurzum: Sie kommen nicht drumherum, selbst zu
konfigurieren, welche Meldungen für Sie nach einem Problem aussehen und
welche einfach verworfen werden können.
:::

::: paragraph
Wie überall in Checkmk erfolgt auch hier die Konfiguration über
[Regeln,](glossar.html#rule) welche bei jeder eingehenden Meldung von
der EC nach dem „first match"-Prinzip abgearbeitet werden. Die erste
Regel, die auf eine eingehende Meldung greift, entscheidet also über
deren Schicksal. Greift keine Regel, so wird die Meldung einfach lautlos
verworfen.
:::

::: paragraph
Da man bei der EC mit der Zeit gewöhnlich sehr viele Regeln aufbaut,
sind die Regeln hier in *Paketen* organisiert. Die Abarbeitung geschieht
Paket für Paket und innerhalb eines Pakets von oben nach unten. Damit
ist auch die Reihenfolge der Pakete wichtig.
:::
:::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_anlegen_einer_einfachen_regel .hidden-anchor .sr-only}3.2. Anlegen einer einfachen Regel {#heading__anlegen_einer_einfachen_regel}

::: paragraph
Die Konfiguration der EC finden Sie wenig überraschend im
[Setup]{.guihint}-Menü unter [Events \> Event Console]{.guihint}. Ab
Werk finden Sie dort nur das [Default rule pack]{.guihint}, das aber
keine Regeln enthält. Eingehende Meldungen werden demnach, wie bereits
erwähnt, verworfen und auch nicht geloggt. Das Modul präsentiert sich
so:
:::

:::: imageblock
::: content
![ec wato module](../images/ec_wato_module.png)
:::
::::

::: paragraph
Legen Sie nun mit [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add rule
pack]{.guihint} als Erstes ein neues Regelpaket an:
:::

:::: imageblock
::: content
![ec new rule pack](../images/ec_new_rule_pack.png)
:::
::::

::: paragraph
Wie immer gilt die ID als interne Referenz und kann später nicht mehr
geändert werden. Nach dem Speichern finden Sie den neuen Eintrag in der
Liste Ihrer Regelpakete:
:::

:::: imageblock
::: content
![ec rule pack list](../images/ec_rule_pack_list.png)
:::
::::

::: paragraph
Dort können Sie jetzt mit [![icon ec
rules](../images/icons/icon_ec_rules.png)]{.image-inline} in das noch
leere Paket wechseln und mit [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add rule]{.guihint}
eine neue Regel anlegen. Füllen Sie hier lediglich den ersten Kasten mit
der Überschrift [Rule Properties]{.guihint}:
:::

:::: imageblock
::: content
![ec first rule](../images/ec_first_rule.png)
:::
::::

::: paragraph
Einzig notwendig ist eine eindeutige [Rule ID]{.guihint}. Diese ID
werden Sie später auch in Log-Dateien finden, und sie wird bei den
erzeugten Events mit gespeichert. Es ist also nützlich, die IDs
systematisch zu vergeben. Alle weiteren Kästen sind optional. Das gilt
insbesondere für die Bedingungen.
:::

::: paragraph
**Wichtig:** Die neue Regel ist erst einmal nur zum Testen und greift
vorerst auf *jedes* Ereignis. Daher ist es auch wichtig, dass Sie diese
später wieder entfernen oder zumindest deaktivieren! Andernfalls wird
Ihre Event Console mit jeder nur erdenklichen unnützen Meldung geflutet
und so ziemlich nutzlos werden.
:::

::::::::: sect3
#### []{#_aktivieren_der_änderungen .hidden-anchor .sr-only}Aktivieren der Änderungen {#heading__aktivieren_der_änderungen}

::: paragraph
Wie immer in Checkmk, müssen Sie zuerst [Änderungen
aktivieren](glossar.html#activate_changes), damit diese wirksam werden.
Das ist nicht von Nachteil: Denn so können Sie bei Änderungen, die
mehrere zusammengehörige Regeln betreffen, genau festlegen, wann diese
„live" gehen sollen. Und Sie können mit dem [Event Simulator]{.guihint}
zuvor testen, ob alles passt.
:::

::: paragraph
Klicken Sie zuerst rechts oben auf der Seite auf die Zahl der
aufgelaufenen Änderungen.
:::

:::: imageblock
::: content
![ec activate changes](../images/ec_activate_changes.png)
:::
::::

::: paragraph
Klicken Sie anschließend auf [Activate on selected sites]{.guihint} um
die Änderung zu aktivieren. Die Event Console ist so konstruiert, dass
diese Aktion absolut *unterbrechungsfrei* abläuft. Der Empfang von
eingehenden Meldungen wird zu jeder Zeit sichergestellt, so dass durch
den Prozess keine Meldungen verlorengehen können.
:::

::: paragraph
Das Aktivieren von Änderungen in der EC ist nur Administratoren erlaubt.
Gesteuert wird das über die [Berechtigung](wato_user.html#roles)
[Activate changes for event console]{.guihint}.
:::
:::::::::

::::::::::::: sect3
#### []{#eventsimulator .hidden-anchor .sr-only}Ausprobieren der neuen Regel {#heading_eventsimulator}

::: paragraph
Für das Testen könnten Sie jetzt natürlich Meldungen per Syslog oder
SNMP senden. Das sollten Sie später auch tun. Für einen ersten Test ist
aber der in der EC eingebaute [Event Simulator]{.guihint} praktischer:
:::

:::: imageblock
::: content
![ec simulator](../images/ec_simulator.png)
:::
::::

::: paragraph
Hier haben Sie zwei Möglichkeiten: [Try out]{.guihint} berechnet anhand
der simulierten Meldung, welche der Regeln matchen würden. Befinden Sie
sich in der obersten Ebene der Setup-GUI für die EC, so werden die
Regelpakete markiert. Befinden Sie sich innerhalb eines Regelpakets, so
werden die einzelnen Regeln markiert. Jedes Paket bzw. jede Regel wird
mit einem der folgenden drei Symbole gekennzeichnet:
:::

+------+---------------------------------------------------------------+
| [![  | Diese Regel ist die erste, die auf die Meldung greift und     |
| icon | legt folglich deren Schicksal fest.                           |
| ru   |                                                               |
| lema |                                                               |
| tch] |                                                               |
| (../ |                                                               |
| imag |                                                               |
| es/i |                                                               |
| cons |                                                               |
| /ico |                                                               |
| n_ru |                                                               |
| lema |                                                               |
| tch. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Diese Regel würde zwar greifen, aber die Meldung wurde schon  |
| icon | von einer früheren Regel bearbeitet.                          |
| rule |                                                               |
| pmat |                                                               |
| ch]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _rul |                                                               |
| epma |                                                               |
| tch. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Diese Regel greift nicht. Sehr praktisch: Wenn Sie mit der    |
| icon | Maus über die graue Kugel fahren, bekommen Sie eine           |
| rule | Erklärung, aus welchem Grund die Regel nicht greift.          |
| nmat |                                                               |
| ch]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _rul |                                                               |
| enma |                                                               |
| tch. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+

::: paragraph
Ein Klick auf [Generate event]{.guihint} macht fast das Gleiche wie [Try
out]{.guihint}, nur wird jetzt die Meldung **tatsächlich erzeugt.**
Eventuell definierte [Aktionen](#actions) werden tatsächlich ausgeführt.
Und das Event taucht dann auch in den offenen Events im Monitoring auf.
Den Quelltext der erzeugten Meldung sehen Sie in der Bestätigung:
:::

:::: imageblock
::: content
![ec event generated](../images/ec_event_generated.png)
:::
::::

::: paragraph
Das so erzeugte Event taucht im [Monitor]{.guihint}-Menü unter [Event
Console \> Events]{.guihint} auf:
:::

:::: imageblock
::: content
![ec one open event](../images/ec_one_open_event.png)
:::
::::
:::::::::::::

::::::::::::: sect3
#### []{#_meldungen_testweise_von_hand_erzeugen .hidden-anchor .sr-only}Meldungen testweise von Hand erzeugen {#heading__meldungen_testweise_von_hand_erzeugen}

::: paragraph
Für einen ersten echten Test über das Netzwerk können Sie sehr einfach
von einem anderen Linux-Rechner aus per Hand eine Syslog-Meldung
versenden. Da das Protokoll so einfach ist, brauchen Sie dafür nicht
einmal ein spezielles Programm, sondern können die Daten einfach per
`netcat` oder `nc` via UDP versenden. Der Inhalt des UDP-Pakets besteht
aus einer Zeile Text. Wenn diese einem bestimmten Aufbau entspricht,
werden die Bestandteile von der Event Console sauber zerlegt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo '<78>Dec 18 10:40:00 myserver123 MyApplication: It happened again.' | nc -w 0 -u 10.1.1.94 514
```
:::
::::

::: paragraph
Sie können aber auch einfach *irgendetwas* senden. Die EC wird das dann
trotzdem annehmen und einfach als Meldungstext auswerten.
Zusatzinformation wie z.B. die Anwendung, die Priorität etc. fehlen dann
natürlich. Als Status wird zur Sicherheit [CRIT]{.state2} angenommen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo 'This is no syslog message' | nc -w 0 -u 10.1.1.94 514
```
:::
::::

::: paragraph
Innerhalb der Checkmk Instanz, auf der die EC läuft, gibt es eine *named
Pipe*, in die Sie Textmeldungen lokal per `echo` schreiben können. Dies
ist eine sehr einfache Methode, um eine lokale Anwendung anzubinden und
ebenfalls eine Möglichkeit, das Verarbeiten von Meldungen zu testen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo 'Local application says hello' > tmp/run/mkeventd/events
```
:::
::::

::: paragraph
Auch hier ist es übrigens möglich, im Syslog-Format zu senden, damit
alle Felder des Events sauber befüllt werden.
:::
:::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

:::::::: sect2
### []{#globalsettings .hidden-anchor .sr-only}3.3. Einstellungen der Event Console {#heading_globalsettings}

::: paragraph
Die Event Console hat ihre eigenen globalen Einstellungen, welche Sie
nicht bei denen der anderen Module finden, sondern unter [Setup \>
Events \> Event Console]{.guihint} mit dem Knopf [Settings.]{.guihint}
:::

:::: imageblock
::: content
![ec settings](../images/ec_settings.png)
:::
::::

::: paragraph
Die Bedeutung der einzelnen Einstellungen erfahren Sie wie immer aus der
[Inline-Hilfe](user_interface.html#inline_help) und an den jeweils
passenden Stellen in diesem Artikel.
:::

::: paragraph
Der Zugriff auf die Einstellungen ist über die Berechtigung
[Configuration of Event Console]{.guihint} geschützt, welche per Default
nur in der Rolle `admin` enthalten ist.
:::
::::::::

::::::: sect2
### []{#permissions .hidden-anchor .sr-only}3.4. Berechtigungen {#heading_permissions}

::: paragraph
Auch bei den [Rollen und Berechtigungen](wato_user.html#roles) hat die
Event Console einen eigenen Abschnitt:
:::

:::: imageblock
::: content
![ec permissions](../images/ec_permissions.png)
:::
::::

::: paragraph
Auf einige der Berechtigungen werden wir an passenden Stellen im Artikel
näher eingehen.
:::
:::::::

:::::::::::: sect2
### []{#hostnames .hidden-anchor .sr-only}3.5. Host-Zuordnung in der Event Console {#heading_hostnames}

::: paragraph
Eine Besonderheit der Event Console ist, dass im Gegensatz zum
statusbasierten Monitoring nicht Hosts im Zentrum stehen: Events können
ohne explizite Host-Zuordnung auftreten, was oft sogar gewünscht ist.
Allerdings sollte bei Hosts, die sich bereits im aktiven Monitoring
befinden, eine leichte Zuordnung möglich sein, um im Monitoring bei
Auftreten eines Events schnell zur Statusübersicht zu gelangen.
Spätestens, wenn aus Events [Zustände](#eventsgostate) werden sollen,
ist die korrekte Zuordnung zwingend.
:::

::: paragraph
Grundsätzlich gilt bei per Syslog empfangenen Meldungen, dass der in der
Meldung verwendete Host-Name dem Host-Namen im Monitoring entsprechen
sollte. Dies erreichen Sie durch Verwendung des *fully qualified domain
name* (FQDN) / *fully qualified host name* (FQHN) sowohl in Ihrer
Syslog-Konfiguration als auch in der Benennung der Hosts in Checkmk. In
Rsyslog erreichen Sie dies über die globale Direktive
`$PreserveFQDN on`.
:::

::: paragraph
Checkmk versucht die Host-Namen aus den Events denen aus dem aktiven
Monitoring so gut es geht [automatisch zuzuordnen.](#hostmatching) Neben
dem Host-Namen wird auch der Host-Alias ausprobiert. Steht hier der per
Syslog übertragene Kurzname, erfolgt die Zuordnung korrekt.
:::

::: paragraph
Eine Rückwärtsauflösung der IP-Adresse wäre hier wenig sinnvoll, da
häufig zwischengeschaltete Log-Server genutzt werden. Ist die Umstellung
der Host-Namen auf FQDN/FQHN oder das Nachtragen vieler Aliase zu
aufwendig, können Sie in den [Einstellungen der Event
Console](#globalsettings) mit [Hostname translation for incoming
messages]{.guihint} Host-Namen bereits direkt beim Empfang von Meldungen
umschreiben. Dabei haben Sie zahlreiche Möglichkeiten:
:::

:::: imageblock
::: content
![ec hostname translation](../images/ec_hostname_translation.png)
:::
::::

::: paragraph
Am flexibelsten ist die Arbeit mit [regulären Ausdrücken](regexes.html),
welche intelligentes Suchen und Ersetzen in den Host-Namen erlauben.
Insbesondere, wenn zwar Host-Namen eineindeutig sind, aber nur der in
Checkmk mitverwendete Domain-Teil fehlt, hilft eine simple Regel: `(.*)`
wird zu `\1.mydomain.test`. In Fällen, wo das alles nicht genügt, können
Sie noch mit [Explicit hostname mapping]{.guihint} eine Tabelle von
einzelnen Namen und deren jeweiliger Übersetzung angeben.
:::

::: paragraph
**Wichtig:** Die Namensumwandlung geschieht bereits **vor** dem Prüfen
der Regelbedingungen und somit lange vor einem möglichen Umschreiben des
Host-Namens durch die Regelaktion [Rewrite hostname]{.guihint} beim
[automatischen Umschreiben von Texten.](#rewriting)
:::

::: paragraph
Etwas einfacher ist die Zuordnung bei [SNMP](snmp.html). Hier wird die
IP-Adresse des Senders mit den zwischengespeicherten IP-Adressen der
Hosts im Monitoring verglichen, d.h. sobald regelmäßige aktive Checks
vorhanden sind, wie Erreichbarkeitsprüfung des Telnet- oder SSH-Ports
eines Switches, werden per SNMP versandte Statusmeldungen dieses Gerätes
dem korrekten Host zugeordnet.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#monitoring .hidden-anchor .sr-only}4. Die Event Console im Monitoring {#heading_monitoring}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#_event_ansichten .hidden-anchor .sr-only}4.1. Event-Ansichten {#heading__event_ansichten}

::: paragraph
Von der Event Console erzeugte Events werden analog zu Hosts und
Services in der
[Monitoring-Umgebung](glossar.html#monitoring_environment) angezeigt.
Den Einstieg dazu finden Sie im [Monitor]{.guihint}-Menü unter [Event
Console \> Events:]{.guihint}
:::

:::: imageblock
::: content
![ec open events hilites](../images/ec_open_events_hilites.png)
:::
::::

::: paragraph
Die angezeigte Ansicht [Events]{.guihint} können Sie genauso anpassen
wie alle anderen. Sie können die angezeigten Events filtern, Kommandos
ausführen usw. Einzelheiten erfahren Sie im Artikel über die
[Ansichten](views.html). Wenn Sie neue Event-Ansichten erstellen, stehen
Ihnen Events sowie [Event-Historie](#archive) als Datenquellen zur
Verfügung.
:::

::: paragraph
Ein Klick auf die ID des Events (hier z.B. `27`) bringt Sie zu dessen
Details:
:::

:::: imageblock
::: content
![ec event details](../images/ec_event_details.png)
:::
::::

::: paragraph
Wie Sie sehen können, hat ein Event eine ganze Menge von Datenfeldern,
deren Bedeutung wir in diesem Artikel nach und nach erklären werden. Die
wichtigsten Felder sollen trotzdem bereits hier kurz erwähnt werden:
:::

+-----------------+-----------------------------------------------------+
| Feld            | Bedeutung                                           |
+=================+=====================================================+
| [State          | Wie in der Einleitung erwähnt, wird jeder Event als |
| (severity) of   | [OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2}     |
| e               | oder [UNKNOWN]{.state3} eingestuft. Events vom      |
| vent]{.guihint} | Status [OK]{.state0} sind eher ungewöhnlich. Denn   |
|                 | die EC ist gerade dafür gedacht, nur die *Probleme* |
|                 | herauszufiltern. Es gibt aber Situationen, in denen |
|                 | ein [OK]{.state0}-Event durchaus Sinn machen kann.  |
+-----------------+-----------------------------------------------------+
| [Text/Message   | Der eigentliche Inhalt des Events: Eine             |
| of the          | Textmeldung.                                        |
| e               |                                                     |
| vent]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [Host           | Der Name des Hosts, der die Meldung gesendet hat.   |
| name]{.guihint} | Dieser muss nicht unbedingt ein mit Checkmk aktiv   |
|                 | überwachter Host sein. Falls ein Host dieses Namens |
|                 | jedoch im Monitoring existiert, stellt die EC       |
|                 | automatisch eine [Verknüpfung](#hostnames) her. In  |
|                 | diesem Fall sind dann auch die Felder [Host         |
|                 | alias]{.guihint}, [Host contacts]{.guihint} und     |
|                 | [Host icons]{.guihint} gefüllt und der Host         |
|                 | erscheint in der gleichen Schreibweise wie im       |
|                 | aktiven Monitoring.                                 |
+-----------------+-----------------------------------------------------+
| [Rul            | Die ID der Regel, welche diesen Event erzeugt hat.  |
| e-ID]{.guihint} | Ein Klick auf diese ID bringt Sie direkt zu den     |
|                 | Details der Regel. Übrigens bleibt die ID auch dann |
|                 | erhalten, wenn die Regel inzwischen nicht mehr      |
|                 | existiert.                                          |
+-----------------+-----------------------------------------------------+

::: paragraph
Wie eingangs erwähnt, werden Events direkt im [Overview]{.guihint} der
Seitenleiste angezeigt:
:::

:::: imageblock
::: content
![Das Snapin Overview mit der Anzeige der
Ereignisse.](../images/ec_overview_events.png){width="50%"}
:::
::::

::: paragraph
Dabei sehen Sie drei Zahlen:
:::

::: ulist
- [Events]{.guihint} --- alle offenen und quittierten Events (entspricht
  der Ansicht [Event Console \> Events]{.guihint})

- [Problems]{.guihint} --- davon nur diejenigen mit dem Zustand
  [WARN]{.state1} / [CRIT]{.state2} / [UNKNOWN]{.state3}

- [Unhandled]{.guihint} --- davon wiederum nur die noch nicht
  quittierten (dazu gleich mehr)
:::
::::::::::::::::

:::::::::::::::::::::: sect2
### []{#commands .hidden-anchor .sr-only}4.2. Kommandos und Workflow von Events {#heading_commands}

::: paragraph
Analog zu den Hosts und Services wird auch für Events ein einfacher
Workflow abgebildet. Wie gewohnt geschieht das über
[Kommandos](commands.html), welche Sie im Menü [Commands]{.guihint}
finden. Durch Einblenden und Auswahl mit Checkboxen können Sie ein
Kommando auf vielen Events gleichzeitig ausführen. Als Besonderheit gibt
es das häufig gebrauchte *Archivieren* eines einzelnen Events direkt
über das Symbol [![icon archive
event](../images/icons/icon_archive_event.png)]{.image-inline}.
:::

::: paragraph
Für jedes der Kommandos gibt es eine [Berechtigung](#permissions), über
die Sie steuern können, welcher Rolle das Ausführen des Kommandos
erlaubt ist. Per Default sind alle Kommandos für Mitglieder der Rollen
`admin` und `user` freigeschaltet.
:::

:::: imageblock
::: content
![ec commands menu](../images/ec_commands_menu.png){width="550"}
:::
::::

::: paragraph
Folgende Kommandos stehen zur Verfügung:
:::

::::::::: sect3
#### []{#_aktualisieren_und_quittieren .hidden-anchor .sr-only}Aktualisieren und quittieren {#heading__aktualisieren_und_quittieren}

::: paragraph
Das Kommando [Update & Acknowledge]{.guihint} blendet den folgenden
Bereich oberhalb der Event-Liste ein:
:::

:::: imageblock
::: content
![ec commands](../images/ec_commands.png){width="550"}
:::
::::

::: paragraph
Mit dem Knopf [Update]{.guihint} können Sie in einem einzigen
Arbeitsschritt einen Kommentar an das Event hängen, eine Kontaktperson
eintragen und das Event quittieren. Das Feld [Change contact]{.guihint}
ist bewusst Freitext. Hier können Sie auch Dinge wie Telefonnummern
eintragen. Das Feld hat insbesondere keinen Einfluss auf die
Sichtbarkeit des Events in der GUI. Es ist ein reines Kommentarfeld.
:::

::: paragraph
Die Checkbox [Set event to acknowledged]{.guihint} führt dazu, dass das
Event von der Phase [open]{.guihint} übergeht nach
[acknowledged]{.guihint} und fortan als [handled]{.guihint} gilt. Dies
ist analog zu dem [Quittieren](basics_ackn.html) von Host-und
Service-Problemen.
:::

::: paragraph
Ein späteres erneutes Aufrufen des Kommando mit nicht gesetzter Checkbox
*entfernt* die Quittierung wieder.
:::
:::::::::

:::: sect3
#### []{#_zustand_ändern .hidden-anchor .sr-only}Zustand ändern {#heading__zustand_ändern}

::: paragraph
Das Kommando [Change State]{.guihint} erlaubt den manuellen
Zustandswechsel von Events --- z.b. von [CRIT]{.state2} auf
[WARN]{.state1}.
:::
::::

:::: sect3
#### []{#_aktionen_ausführen .hidden-anchor .sr-only}Aktionen ausführen {#heading__aktionen_ausführen}

::: paragraph
Mit dem Kommando [Custom Action]{.guihint} können Sie auf Events frei
definierbare [Aktionen](#actions) ausführen lassen. Zunächst ist nur die
Aktion [Send monitoring notification]{.guihint} verfügbar. Diese sendet
eine Checkmk Benachrichtigung, die genauso behandelt wird wie die von
einem aktiv überwachten Service. Diese durchläuft die
[Benachrichtigungsregeln](notifications.html#rules) und führt dann
entsprechend zu E-Mails, SMS oder was auch immer Sie konfiguriert haben.
Einzelheiten zur Benachrichtigung durch die EC erfahren Sie [weiter
unten](#notifications).
:::
::::

::::: sect3
#### []{#_archivieren .hidden-anchor .sr-only}Archivieren {#heading__archivieren}

::: paragraph
Das Kommando [Archive Event]{.guihint} löscht das Event endgültig aus
der Liste der offenen Events. Da alle Aktionen auf Events --- inklusive
dieses Löschvorgangs --- auch im [Archiv](#archive) aufgezeichnet
werden, können Sie später immer noch auf alle Informationen des Events
zugreifen. Deswegen sprechen wir nicht von Löschen, sondern von
Archivieren.
:::

::: paragraph
Das Archivieren von einzelnen Events erreichen Sie auch aus der
Event-Liste bequem über das Symbol [![icon archive
event](../images/icons/icon_archive_event.png)]{.image-inline}.
:::
:::::
::::::::::::::::::::::

:::::::::::::::: sect2
### []{#visibility .hidden-anchor .sr-only}4.3. Sichtbarkeit von Events {#heading_visibility}

::::: sect3
#### []{#_problematik_der_sichtbarkeit .hidden-anchor .sr-only}Problematik der Sichtbarkeit {#heading__problematik_der_sichtbarkeit}

::: paragraph
Für die Sichtbarkeit von Hosts und Services im Monitoring für normale
Benutzer werden von Checkmk
[Kontaktgruppen](wato_user.html#contact_groups) verwendet. Diese werden
per Setup-GUI, Regel oder Ordnerkonfiguration den Hosts und Service
zugeordnet.
:::

::: paragraph
Nun ist es aber bei der Event Console so, dass so eine Zuordnung von
Events zu Kontaktgruppen erst einmal nicht existiert. Denn im Vorhinein
ist gar nicht bekannt, welche Meldungen überhaupt empfangen werden
können. Nicht einmal die Liste der Hosts ist bekannt, denn die Sockets
für Syslog und SNMP sind ja von überall aus erreichbar. Deswegen gibt es
bei der Sichtbarkeit in der Event Console ein paar Besonderheiten.
:::
:::::

:::: sect3
#### []{#_erst_einmal_dürfen_alle_alles_sehen .hidden-anchor .sr-only}Erst einmal dürfen alle alles sehen {#heading__erst_einmal_dürfen_alle_alles_sehen}

::: paragraph
Zunächst einmal gibt es bei der Konfiguration der
[Benutzerrollen](wato_user.html#roles) die Berechtigung [Event Console
\> See all events]{.guihint}. Diese ist per Default an, so dass **auch
normale Benutzer alle Events sehen dürfen!** Dies ist bewusst so
eingestellt, damit nicht aufgrund fehlerhafter Konfiguration wichtige
Fehlermeldungen unter den Tisch fallen. Der erste Schritt zu einer
genaueren Steuerung der Sichtbarkeit ist also das Entfernen dieser
Berechtigung aus der Rolle `user`.
:::
::::

:::::::::: sect3
#### []{#hostmatching .hidden-anchor .sr-only}Zuordnung zu Hosts {#heading_hostmatching}

::: paragraph
Damit die Sichtbarkeit von Events möglichst konsistent mit dem übrigen
Monitoring ist, versucht die Event Console so gut wie möglich die Hosts,
von denen sie Events empfängt, ihren per Setup-GUI konfigurierten Hosts
zuzuordnen. Was einfach klingt ist trickreich im Detail. Denn teils
fehlt im Event eine Angabe zum Host-Namen und nur die IP-Adresse ist
bekannt. In anderen Fällen hat der Host-Name eine andere Schreibweise
als in der Setup-GUI.
:::

::: paragraph
Die Zuordnung erfolgt konkret wie folgt:
:::

::: ulist
- Ist im Event kein Host-Name bekannt, so wird anstelle dessen seine
  IP-Adresse als Host-Name verwendet.

- Der Host-Name im Event wird dann *ohne Berücksichtigung von
  Groß-/Kleinschreibung* mit allen Host-Namen, Host-Aliase und
  IP-Adressen der Hosts aus dem Monitoring verglichen.

- Wird so ein Host gefunden, werden dessen Kontaktgruppen für den Event
  übernommen, und darüber wird dann die Sichtbarkeit gesteuert.

- Wird der Host jedoch **nicht** gefunden, so werden die
  Kontaktgruppen --- falls [dort konfiguriert](#contactgroups) --- aus
  der Regel übernommen, welche den Event erzeugt hat.

- Sind auch dort keine Gruppen hinterlegt, so darf der Benutzer den
  Event nur dann sehen, wenn er die Berechtigung [Event Console \> See
  events not related to a known host]{.guihint} hat.
:::

::: paragraph
Sie können die Zuordnung an einer Stelle beeinflussen: Falls nämlich in
der Regel Kontaktgruppen definiert sind **und** der Host zugeordnet
werden konnte, hat normalerweise die Zuordnung Vorrang. Dies können Sie
in einer Regel mit der Option [Precedence of contact groups]{.guihint}
umstellen:
:::

:::: imageblock
::: content
![ec outcome contact groups](../images/ec_outcome_contact_groups.png)
:::
::::

::: paragraph
Zudem können Sie direkt in der Regel Einstellungen für die
Benachrichtigung vornehmen. Dies ermöglicht es, die Art des Events
gegenüber den regulären Zuständigkeiten für einen Host zu priorisieren.
:::
::::::::::
::::::::::::::::

::::::::::::::::::: sect2
### []{#_fehlersuche .hidden-anchor .sr-only}4.4. Fehlersuche {#heading__fehlersuche}

::::::::::: sect3
#### []{#_welche_regel_greift_wie_oft .hidden-anchor .sr-only}Welche Regel greift wie oft? {#heading__welche_regel_greift_wie_oft}

::: paragraph
Sowohl bei den Regelpaketen  ...​
:::

:::: imageblock
::: content
![ec pack hits](../images/ec_pack_hits.png)
:::
::::

::: paragraph
...  als auch bei den einzelnen Regeln  ...​
:::

:::: imageblock
::: content
![ec rule hits](../images/ec_rule_hits.png)
:::
::::

::: paragraph
... finden Sie in der Spalte [Hits]{.guihint} die Angabe, wie oft das
Paket bzw. die Regel schon auf eine Meldung gepasst hat. Dies hilft
Ihnen zum einen dabei, unwirksame Regeln zu eliminieren oder zu
reparieren. Aber auch bei Regeln, die sehr oft matchen, kann dies
interessant sein. Für die optimale Performance der EC sollten diese
möglichst am Anfang der Regelkette stehen. So können Sie die Anzahl von
Regeln reduzieren, die die EC bei jeder Meldung ausprobieren muss.
:::

::: paragraph
Die Zählerstände können Sie jederzeit mit dem Menüpunkt [Event Console
\> Reset counters]{.guihint} zurücksetzen.
:::
:::::::::::

::::::::: sect3
#### []{#_regelauswertung_debuggen .hidden-anchor .sr-only}Regelauswertung debuggen {#heading__regelauswertung_debuggen}

::: paragraph
Beim [Ausprobieren einer Regel](#eventsimulator) haben Sie schon
gesehen, wie Sie mit dem [Event Simulator]{.guihint} die Auswertungen
Ihrer Regeln prüfen können. Ähnliche Informationen bekommen Sie zur
Laufzeit für *alle* Meldungen, wenn Sie in den [Einstellungen der Event
Console](#globalsettings) den Wert von [Debug rule execution]{.guihint}
auf [on]{.guihint} umstellen.
:::

::: paragraph
Die Log-Datei der Event Console finden Sie unter `var/log/mkeventd.log`.
Für jede Regel, die geprüft wird, aber nicht greift, erfahren Sie den
genauen Grund:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1481020022.001612] Processing message from ('10.40.21.11', 57123): '<22>Dec  6 11:27:02 myserver123 exim[1468]: Delivery complete, 4 message(s) remain.'
[1481020022.001664] Parsed message:
 application:    exim
 facility:       2
 host:           myserver123
 ipaddress:      10.40.21.11
 pid:            1468
 priority:       6
 text:           Delivery complete, 4 message(s) remain.
 time:           1481020022.0
[1481020022.001679] Trying rule test/myrule01...
[1481020022.001688]   Text:   Delivery complete, 4 message(s) remain.
[1481020022.001698]   Syslog: 2.6
[1481020022.001705]   Host:   myserver123
[1481020022.001725]   did not match because of wrong application 'exim' (need 'security')
[1481020022.001733] Trying rule test/myrule02n...
[1481020022.001739]   Text:   Delivery complete, 4 message(s) remain.
[1481020022.001746]   Syslog: 2.6
[1481020022.001751]   Host:   myserver123
[1481020022.001764]   did not match because of wrong text
```
:::
:::::

::: paragraph
Es versteht sich wohl von selbst, dass Sie dieses intensive Logging nur
bei Bedarf und mit Bedacht verwenden sollten. Bei einer nur etwas
komplexeren Umgebung werden *Unmengen* von Daten erzeugt!
:::
:::::::::
:::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#rules .hidden-anchor .sr-only}5. Die ganze Mächtigkeit der Regeln {#heading_rules}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_die_bedingung .hidden-anchor .sr-only}5.1. Die Bedingung {#heading__die_bedingung}

::: paragraph
Der wichtigste Teil einer EC-Regel ist die *Bedingung* ([Matching
Criteria]{.guihint}). Nur wenn eine Meldung alle in der Regel
hinterlegten Bedingungen erfüllt, werden die in der Regel definierten
Aktionen ausgeführt und die Auswertung der Meldung damit abgeschlossen.
:::

:::: imageblock
::: content
![ec matching criteria](../images/ec_matching_criteria.png)
:::
::::

::::::: sect3
#### []{#_allgemeines_zu_textvergleichen .hidden-anchor .sr-only}Allgemeines zu Textvergleichen {#heading__allgemeines_zu_textvergleichen}

::: paragraph
Bei allen Bedingungen, die Textfelder betreffen, wird der Vergleichstext
grundsätzlich als [regulärer Ausdruck](regexes.html) behandelt. Der
Vergleich findet hier immer *ohne Unterscheidung von
Groß-/Kleinschreibung* statt. Letzteres ist eine Ausnahme von Checkmk
Konventionen in anderen Modulen. Es macht aber das Formulieren der
Regeln robuster. Auch sind gerade Host-Namen in Events nicht unbedingt
konsistent in ihrer Schreibweise, falls diese nicht zentral, sondern auf
jedem Host selbst konfiguriert werden. Daher ist diese Ausnahme hier
sehr sinnvoll.
:::

::: paragraph
Ferner gilt immer ein *Infix-Match* --- also eine Überprüfung auf ein
*Enthaltensein* des Suchtextes. Ein `.*` am Anfang oder am Ende des
Suchtexts können Sie sich also sparen.
:::

::: paragraph
Davon gibt es allerdings eine **Ausnahme:** Wird beim Match auf den
Host-Namen **kein regulärer Ausdruck** verwendet, sondern ein **fester
Host-Name,** so wird dieser auf **exaktes** Übereinstimmen geprüft und
**nicht** auf ein Enthaltensein.
:::

::: paragraph
**Achtung:** Sobald der Suchtext einen Punkt enthält, wird dieser als
regulärer Ausdruck gewertet und es gilt die Infix-Suche. `myhost.de`
matcht dann auch z.B. auf `notmyhostide`!
:::
:::::::

::::::::::::::::::::: sect3
#### []{#matchgroups .hidden-anchor .sr-only}Match-Gruppen {#heading_matchgroups}

::: paragraph
Sehr wichtig und nützlich ist hier das Konzept
[Match-Gruppen](regexes.html#matchgroups) beim Feld [Text to
match]{.guihint}. Damit sind die Textabschnitte gemeint, die beim
Matchen mit geklammerten Ausdrücken im regulären Ausdruck
übereinstimmen.
:::

::: paragraph
Nehmen Sie an, Sie möchten folgende Art von Meldung in der Log-Datei
einer Datenbank überwachen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Database instance WP41 has failed
```
:::
::::

::: paragraph
Das `WP41` ist dabei natürlich variabel und Sie möchten sicher nicht für
jede unterschiedliche Instanz eine eigene Regel formulieren. Daher
verwenden Sie im regulären Ausdruck `.*`, was für eine beliebige
Zeichenfolge steht:
:::

::: paragraph
`Database instance .* has failed`
:::

::: paragraph
Wenn Sie jetzt den variablen Teil in runde Klammern setzen, wird sich
die Event Console den tatsächlichen Wert beim Matchen für weitere
Aktionen **merken** (*capturing*):
:::

::: paragraph
`Database instance `**`(.*)`**` has failed`
:::

::: paragraph
Nach einem erfolgreichen Match der Regel ist jetzt die erste
Match-Gruppe auf den Wert `WP41` gesetzt (oder welche Instanz auch immer
den Fehler produziert hat).
:::

::: paragraph
Diese Match-Gruppen können Sie im [Event Simulator]{.guihint} sehen,
wenn Sie mit der Maus über die grüne Kugel fahren:
:::

:::: imageblock
::: content
![ec match groups 1](../images/ec_match_groups_1.png)
:::
::::

::: paragraph
Auch in den Details des erzeugten Events können Sie die Gruppen sehen:
:::

:::: imageblock
::: content
![ec match groups 2](../images/ec_match_groups_2.png){width="700"}
:::
::::

::: paragraph
Die Match-Gruppen finden unter anderem Anwendung bei:
:::

::: ulist
- Umschreiben von Events ([Rewriting](#rewriting))

- Automatisches Aufheben von Events ([Canceling](#canceling))

- Zählen von Meldungen ([Counting](#counting))
:::

::: paragraph
An dieser Stelle noch ein Tipp: Es gibt Situationen, in denen Sie im
regulären Ausdruck etwas gruppieren müssen, aber **keine** Match-Gruppe
erzeugen möchten. Dies können Sie durch ein `?:` direkt nach der
öffnenden Klammer erreichen. Beispiel: Der Ausdruck
`one (.*) two (?:.*) three` erzeugt bei einem Match auf
`one 123 two 456 three` nur die eine Match-Gruppe `123`.
:::
:::::::::::::::::::::

::::: sect3
#### []{#_ip_adresse .hidden-anchor .sr-only}IP-Adresse {#heading__ip_adresse}

::: paragraph
Im Feld [Match original source IP address]{.guihint} können Sie auf die
IPv4-Adresse des Senders der Meldung matchen. Geben Sie entweder eine
exakte Adresse an oder ein Netzwerk in der Notation X.X.X.X/Y, also z.B.
`192.168.8.0/24`, um alle Adressen im Netzwerk `192.168.8.`X zu matchen.
:::

::: paragraph
Beachten Sie, dass der Match auf die IP-Adresse nur dann funktioniert,
wenn die überwachten Systeme direkt an die Event Console senden. Ist
noch ein anderer Syslog-Server dazwischen geschaltet, der die Meldungen
weiterleitet, wird stattdessen dessen Adresse als Absender in der
Meldung erscheinen.
:::
:::::

::::::: sect3
#### []{#syslogfacility .hidden-anchor .sr-only}Syslog-Priorität und -Facility {#heading_syslogfacility}

::: paragraph
Die Felder [Match syslog priority]{.guihint} und [Match syslog
facility]{.guihint} sind ursprünglich von Syslog definierte,
standardisierte Informationen. Intern wird dabei ein 8-Bit-Feld in 5
Bits für die Facility (ergibt 32 Möglichkeiten) und 3 Bits für die
Priorität (8 Möglichkeiten) aufgeteilt.
:::

::: paragraph
Die 32 vordefinierten Facilities waren mal für so etwas wie eine
Anwendung gedacht. Nur ist die Auswahl damals nicht sehr zukunftsweisend
gemacht worden. Eine der Facilities ist z.B. `uucp` --- ein Protokoll
das schon in den 90er Jahren des vergangenen Jahrtausends kaum noch
verwendet wurde.
:::

::: paragraph
Fakt ist aber, dass jede Meldung, die per Syslog kommt, eine der
Facilities trägt. Teilweise können Sie diese beim Senden auch frei
vergeben, um später darauf gezielt zu filtern. Das ist durchaus
nützlich.
:::

::: paragraph
Die Verwendung von Facility und Priorität hat auch einen
Performance-Aspekt. Wenn Sie eine Regel definieren, die sowieso nur auf
Meldungen greift, die alle die gleiche Facility oder Priorität haben,
sollten Sie diese zusätzlich in den Filtern der Regel setzen. Die Event
Console kann diese Regeln dann sehr effizient sofort umgehen, wenn eine
Meldung mit abweichenden Werten eingeht. Je mehr Regeln diese Filter
gesetzt haben, desto weniger Regelvergleiche werden benötigt.
:::
:::::::

:::::: sect3
#### []{#_invertieren_des_matches .hidden-anchor .sr-only}Invertieren des Matches {#heading__invertieren_des_matches}

::: paragraph
Die Checkbox [Negate match: Execute this rule if the upper conditions
are not fulfilled.]{.guihint} führt dazu, dass die Regel genau dann
greift, wenn die Bedingungen *nicht* alle erfüllt sind. Dies ist
eigentlich nur nützlich im Zusammenhang mit zwei Regelarten ([Rule
type]{.guihint} im Kasten [Outcome & Action]{.guihint} der Regel):
:::

::: ulist
- [Do not perform any action, drop this message, stop
  processing]{.guihint}

- [Skip this rule pack, continue rule execution with next
  pack]{.guihint}
:::

::: paragraph
Zu den Regelpaketen erfahren Sie [weiter unten](#rulepacks) mehr.
:::
::::::
::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::: sect2
### []{#outcome .hidden-anchor .sr-only}5.2. Auswirkung der Regel {#heading_outcome}

::::::: sect3
#### []{#_regeltyp_abbrechen_oder_event_erzeugen .hidden-anchor .sr-only}Regeltyp: Abbrechen oder Event erzeugen {#heading__regeltyp_abbrechen_oder_event_erzeugen}

::: paragraph
Wenn eine Regel matcht, legt sie fest, was mit der Meldung geschehen
soll. Das geschieht im Kasten [Outcome & Action]{.guihint}:
:::

:::: imageblock
::: content
![ec outcome](../images/ec_outcome.png)
:::
::::

::: paragraph
Mit dem [Rule type]{.guihint} kann die Auswertung an der Stelle ganz
oder für das aktuelle Regelpaket abgebrochen werden. Gerade die erste
Möglichkeit sollten Sie nutzen, um den größten Teil des nutzlosen
„Rauschens" durch ein paar gezielte Regeln ganz am Anfang loszuwerden.
Nur bei den „normalen" Regeln werden die anderen Optionen in diesem
Kasten überhaupt ausgewertet.
:::
:::::::

::::::::::: sect3
#### []{#_festlegen_des_status .hidden-anchor .sr-only}Festlegen des Status {#heading__festlegen_des_status}

::: paragraph
Mit [State]{.guihint} legt die Regel den Monitoring-Status des Events
fest. In der Regel wird diese [WARN]{.state1} oder [CRIT]{.state2} sein.
Regeln, die [OK]{.state0}-Events erzeugen, können in Ausnahmen
interessant sein, um bestimmte Ereignisse rein informativ darzustellen.
Hier ist dann eine Kombination mit einem automatischen
[Herausaltern](#timing) dieser Events interessant.
:::

::: paragraph
Neben dem Festlegen eines expliziten Status gibt es noch zwei
dynamischere Möglichkeiten. Die Einstellung [(set by syslog)]{.guihint}
übernimmt die Einstufung anhand der Syslog-Priorität. Dies funktioniert
allerdings nur, wenn die Meldung bereits vom Absender nutzbar
klassifiziert wurde. Meldungen, die direkt per Syslog empfangen wurden,
enthalten eine von acht per RFC festgelegten Prioritäten, die wie folgt
abgebildet werden:
:::

+---------+---------+---------+--------------------------------------+
| Pr      | ID      | Zustand | Definition laut Syslog               |
| iorität |         |         |                                      |
+=========+=========+=========+======================================+
| `emerg` | 0       | [       | Das System ist unbrauchbar           |
|         |         | CRIT]{. |                                      |
|         |         | state2} |                                      |
+---------+---------+---------+--------------------------------------+
| `alert` | 1       | [       | Sofortige Aktion erforderlich        |
|         |         | CRIT]{. |                                      |
|         |         | state2} |                                      |
+---------+---------+---------+--------------------------------------+
| `crit`  | 2       | [       | Kritischer Zustand                   |
|         |         | CRIT]{. |                                      |
|         |         | state2} |                                      |
+---------+---------+---------+--------------------------------------+
| `err`   | 3       | [       | Fehler                               |
|         |         | CRIT]{. |                                      |
|         |         | state2} |                                      |
+---------+---------+---------+--------------------------------------+
| `w      | 4       | [       | Warnung                              |
| arning` |         | WARN]{. |                                      |
|         |         | state1} |                                      |
+---------+---------+---------+--------------------------------------+
| `       | 5       | [OK]{.  | Normal, aber signifikante            |
| notice` |         | state0} | Information                          |
+---------+---------+---------+--------------------------------------+
| `info`  | 6       | [OK]{.  | Reine Information                    |
|         |         | state0} |                                      |
+---------+---------+---------+--------------------------------------+
| `debug` | 7       | [OK]{.  | Debug-Meldung                        |
|         |         | state0} |                                      |
+---------+---------+---------+--------------------------------------+

::: paragraph
Neben Syslog-Meldungen bieten auch Meldungen aus dem Windows Event Log
und Meldungen aus Textdateien, die bereits mit dem Checkmk Plugin
[Logwatch](#logwatch) auf dem Zielsystem klassifiziert wurden,
vorbereitete Zustände. Bei SNMP-Traps gibt es diese leider nicht.
:::

::: paragraph
Eine ganze andere Methode ist, die Einstufung der Meldung anhand des
Texts selbst zu machen. Dies geht mit der Einstellung [(set by message
text)]{.guihint}:
:::

:::: imageblock
::: content
![ec state by text](../images/ec_state_by_text.png)
:::
::::

::: paragraph
Der Match auf die hier konfigurierten Texte geschieht erst, nachdem auf
[Text to match]{.guihint} und auf die anderen Regelbedingungen geprüft
wurde. Diese müssen Sie also hier nicht wiederholen.
:::

::: paragraph
Falls keines der konfigurierten Patterns gefunden wird, nimmt das Event
den Zustand [UNKNOWN]{.state3} an.
:::
:::::::::::

:::::: sect3
#### []{#servicelevel .hidden-anchor .sr-only}Service-Level {#heading_servicelevel}

::: paragraph
Hinter dem Feld [Service Level]{.guihint} steckt die Idee, dass jeder
Host und jeder Service im Unternehmen eine bestimmte Wichtigkeit hat.
Damit kann eine konkrete Service-Vereinbarung verbunden sein. In Checkmk
können Sie per [Regeln](glossar.html#rule) Ihren Hosts und Services
solche Level zuordnen und dann z.B. die Benachrichtigung oder selbst
definierte Dashboards davon abhängig machen.
:::

::: paragraph
Da Events erst einmal nicht unbedingt mit Hosts oder Services
korrelieren, erlaubt die Event Console, dass Sie einem Event per Regel
ebenfalls einen Service-Level zuordnen. Sie können die Event-Ansichten
dann später nach diesem Level filtern.
:::

::: paragraph
Ab Werk definiert Checkmk die vier Level 0 (kein Level), 10 (Silber), 20
(Gold) und 30 (Platin). Diese Auswahl können Sie in den [Global settings
\> Notifications \> Service Levels]{.guihint} beliebig anpassen.
Entscheidend sind hierbei die Zahlen der Levels, dann nach diesen werden
sie sortiert und auch nach der Wichtigkeit verglichen.
:::
::::::

:::: sect3
#### []{#contactgroups .hidden-anchor .sr-only}Kontaktgruppen {#heading_contactgroups}

::: paragraph
Die Kontaktgruppen für die Sichtbarkeit werden auch bei der
[Benachrichtigung](#notifications) von Events verwendet. Sie können hier
per Regel Events explizit Kontaktgruppen zuordnen. Einzelheiten erfahren
Sie im [Kapitel über das Monitoring](#visibility).
:::
::::

:::: sect3
#### []{#_aktionen .hidden-anchor .sr-only}Aktionen {#heading__aktionen}

::: paragraph
Aktionen sind den [Alert Handlers](alert_handlers.html) für Hosts und
Services sehr ähnlich. Hier können Sie beim Öffnen eines Events ein
selbst definiertes Skript ausführen lassen. Alle Einzelheiten zu den
Aktionen erfahren Sie weiter unten in einem eigenen
[Abschnitt](#actions).
:::
::::

:::: sect3
#### []{#_automatisches_löschen_archivieren .hidden-anchor .sr-only}Automatisches Löschen (Archivieren) {#heading__automatisches_löschen_archivieren}

::: paragraph
Das automatische Löschen (= Archivieren), welches Sie mit [Delete event
immediately after the actions]{.guihint} einstellen können, sorgt
letztlich dafür, dass ein Event im Monitoring überhaupt nicht sichtbar
wird. Das ist dann sinnvoll, wenn Sie lediglich automatisch Aktionen
auslösen oder nur bestimmte Events archivieren möchten, damit Sie später
danach recherchieren können.
:::
::::
:::::::::::::::::::::::::::

:::::::::::: sect2
### []{#rewriting .hidden-anchor .sr-only}5.3. Automatisches Umschreiben von Texten (Rewriting) {#heading_rewriting}

::: paragraph
Mit dem [Rewriting]{.guihint} kann eine EC-Regel Textfelder in der
Meldung automatisch umschreiben und Anmerkungen anfügen. Dies wird in
einem eigenen Kasten konfiguriert:
:::

:::: imageblock
::: content
![ec rewriting](../images/ec_rewriting.png)
:::
::::

::: paragraph
Beim Umschreiben sind die [Match-Gruppen](#matchgroups) besonders
wichtig. Denn Sie erlauben es, Teile der Originalmeldung gezielt in den
neuen Text einzubauen. Sie können bei den Ersetzungen auf die Gruppen
wie folgt zugreifen:
:::

+------+---------------------------------------------------------------+
| `\1` | Wird durch die *erste* Match-Gruppe der Originalmeldung       |
|      | ersetzt.                                                      |
+------+---------------------------------------------------------------+
| `\2` | Wird durch die *zweite* Match-Gruppe der Originalmeldung      |
|      | ersetzt (usw.).                                               |
+------+---------------------------------------------------------------+
| `\0` | Wird durch die *komplette* Originalmeldung ersetzt.           |
+------+---------------------------------------------------------------+

::: paragraph
In obigem Screenshot wird der neue Meldungstext auf
`Instance \1 has been shut down.` gesetzt. Das klappt natürlich nur,
wenn beim [Text to match]{.guihint} in der **gleichen** Regel der
reguläre Suchausdruck auch mindestens einen Klammerausdruck hat. Ein
Beispiel dafür wäre z.B.:
:::

:::: imageblock
::: content
![ec rewrite match](../images/ec_rewrite_match.png)
:::
::::

::: paragraph
Einige weitere Hinweise zum Umschreiben:
:::

::: ulist
- Das Umschreiben geschieht *nach* dem Matchen und *vor* dem Ausführen
  von Aktionen.

- Match, Umschreiben und Aktionen geschehen immer in der gleichen Regel.
  Es ist nicht möglich, eine Meldung umzuschreiben, um sie dann mit
  einer späteren Regel zu bearbeiten.

- Die Ausdrücke `\1`, `\2` usw. können in allen Textfeldern verwendet
  werden, nicht nur im [Rewrite message text]{.guihint}.
:::
::::::::::::

:::::::::::::::::::::::: sect2
### []{#canceling .hidden-anchor .sr-only}5.4. Automatisches Aufheben von Events (Canceling) {#heading_canceling}

::: paragraph
Manche Anwendungen oder Geräte sind so nett, nach einer Störmeldung
später eine passende OK-Meldung zu senden, sobald das Problem wieder
behoben ist. Sie können die EC so konfigurieren, dass in so einem Fall
das durch die Störung geöffnete Event automatisch wieder geschlossen
wird. Dies nennt man *Aufheben* (*canceling*).
:::

::: paragraph
Folgende Abbildung zeigt eine Regel, in der nach Meldungen mit dem Text
`database instance (.*) has failed` gesucht wird. Der Ausdruck `(.*)`
steht für eine beliebige Zeichenfolge, die in einer
[Match-Gruppe](#matchgroups) eingefangen wird. Der Ausdruck
`database instance (.*) recovery in progress`, welcher im Feld [Text to
cancel event(s)]{.guihint} in der gleichen Regel eingetragen ist, sorgt
für ein automatisches Schließen von mit dieser Regel erzeugten Events,
wenn eine passende Meldung eingeht:
:::

:::: imageblock
::: content
![ec cancelling](../images/ec_cancelling.png)
:::
::::

::: paragraph
Das automatische Aufheben funktioniert genau dann, wenn
:::

::: ulist
- eine Meldung eingeht, deren Text auf [Text to cancel
  event(s)]{.guihint} passt,

- der hier in der Gruppe `(.*)` eingefangene Wert *identisch* mit der
  Match-Gruppe aus der ursprünglichen Meldung ist,

- beide Meldungen vom gleichen Host kamen und

- es sich um die gleiche Anwendung handelt (Feld [Syslog application to
  cancel event]{.guihint}).
:::

::: paragraph
Das Prinzip der Match-Gruppen ist hier sehr wichtig. Denn es wäre
schließlich wenig sinnvoll, wenn die Meldung
`database instance TEST recovery in progress` ein Event aufheben würde,
das von der Meldung `database instance PROD has failed` stammt, oder?
:::

::: paragraph
Machen Sie nicht den Fehler, in [Text to cancel events(s)]{.guihint} den
Platzhalter `\1` zu verwenden. Das funktioniert *nicht*! Diese
Platzhalter funktionieren nur beim [Rewriting](#rewriting).
:::

::: paragraph
In einigen Fällen kommt es vor, dass ein Text sowohl zur *Erzeugung* als
auch zum *Aufheben* eines Events passt. In diesem Fall erhält das
Aufheben Priorität.
:::

::::::: sect3
#### []{#_ausführen_von_aktionen_beim_aufheben .hidden-anchor .sr-only}Ausführen von Aktionen beim Aufheben {#heading__ausführen_von_aktionen_beim_aufheben}

::: paragraph
Sie können beim Aufheben eines Events auch automatisch
[Aktionen](#automatic_actions) ausführen lassen. Dazu ist es wichtig zu
wissen, dass beim Aufheben etliche Datenfelder des Events von Werten der
OK-Meldung überschrieben werden, bevor die Aktionen ausgeführt werden.
Auf diese Art sind im Aktionsskript dann die Daten der OK-Meldung
vollständig verfügbar. Auch ist während dieser Phase der Zustand des
Events als [OK]{.state0} eingetragen. Auf diese Art kann ein
Aktionsskript ein Aufheben erkennen und Sie können das gleiche Skript
für Fehler und OK-Meldung verwenden (z.B. bei der Anbindung an ein
Ticketsystem).
:::

::: paragraph
Folgende Felder werden aus Daten der OK-Meldung überschrieben:
:::

::: ulist
- Der Meldungstext

- Der Zeitstempel

- Die Zeit des letzten Auftretens

- Die Syslog-Priorität
:::

::: paragraph
Alle anderen Felder bleiben unverändert --- inklusive der Event-ID.
:::
:::::::

:::::: sect3
#### []{#_aufheben_in_kombination_mit_umschreiben .hidden-anchor .sr-only}Aufheben in Kombination mit Umschreiben {#heading__aufheben_in_kombination_mit_umschreiben}

::: paragraph
Falls Sie in der gleichen Regel mit [Umschreiben](#rewriting) und
Aufheben arbeiten, so sollten Sie vorsichtig sein beim Umschreiben des
Host-Namens oder der Application. Beim Aufheben prüft die EC stets, ob
die aufhebende Meldung zu Host-Name und Anwendung des offenen Events
passt. Wenn diese aber umgeschrieben wurden, würde das Aufheben nie
funktionieren.
:::

::: paragraph
Daher simuliert die Event Console vor dem Aufheben ein Umschreiben von
Host-Name und Anwendung (*application*), um so die relevanten Texte zu
vergleichen. Das ist wahrscheinlich das, was Sie auch erwarten würden.
:::

::: paragraph
Dieses Verhalten können Sie auch ausnutzen, wenn das Anwendungsfeld bei
der Fehlermeldung und der späteren OK-Meldung nicht übereinstimmen.
Schreiben Sie in diesem Fall einfach das Anwendungsfeld in einen
bekannten festen Wert um. Das führt faktisch dazu, dass dieses Feld beim
Aufheben ignoriert wird.
:::
::::::

::::: sect3
#### []{#_aufheben_anhand_der_syslog_priorität .hidden-anchor .sr-only}Aufheben anhand der Syslog-Priorität {#heading__aufheben_anhand_der_syslog_priorität}

::: paragraph
Es gibt (leider) Fälle, in denen der Text der Fehler- und OK-Meldung
absolut identisch ist. Meist ist der eigentliche Status dann nicht im
Text, sondern in der Syslog-Priorität kodiert.
:::

::: paragraph
Dazu gibt es die Option [Syslog priority to cancel event]{.guihint}.
Geben Sie hier z.B. den Bereich `debug` ...​ `notice` an. Alle
Prioritäten in diesem Bereich werden normalerweise als OK-Status
gewertet. Bei Verwendung dieser Option sollten Sie *trotzdem* in das
Feld [Text to cancel event(s)]{.guihint} einen passenden Text eintragen.
Sonst wird die Regel auf alle OK-Meldungen matchen, welche die gleiche
Anwendung betreffen.
:::
:::::
::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: sect2
### []{#counting .hidden-anchor .sr-only}5.5. Zählen von Meldungen {#heading_counting}

::: paragraph
Im Kasten [Counting & Timing]{.guihint} finden Sie Optionen zum Zählen
von gleichartigen Meldungen. Die Idee ist, dass manche Meldungen erst
dann relevant sind, wenn Sie in bestimmten Zeiträumen *zu häufig* oder
*zu selten* auftreten.
:::

::::::::::::::::::::::: sect3
#### []{#_zu_häufige_meldungen .hidden-anchor .sr-only}Zu häufige Meldungen {#heading__zu_häufige_meldungen}

::: paragraph
Das Prüfen auf zu oft auftretende Meldungen aktivieren Sie mit der
Option [Count messages in interval]{.guihint}:
:::

:::: imageblock
::: content
![ec counting](../images/ec_counting.png)
:::
::::

::: paragraph
Hier geben Sie zunächst einen Zeitraum bei [Time period for
counting]{.guihint} und eine Anzahl von Meldungen bei [Count until
triggered]{.guihint} vor, die zum Öffnen eines Events führen sollen. Im
Beispiel in der Abbildung ist das auf 10 Meldungen pro Stunde
eingestellt. Natürlich handelt es sich dabei nicht um 10 beliebige
Meldungen, sondern um solche, die von der Regel gematcht werden.
:::

::: paragraph
Normalerweise ist es hier aber sinnvoll, nicht einfach global alle
passenden Meldungen zu zählen, sondern nur diejenigen, die sich auf die
gleiche „Ursache" beziehen. Um das zu steuern, gibt es die drei
Checkboxen mit dem Titel [Force separate events for different
...​]{.guihint}. Diese sind so voreingestellt, dass Meldungen nur dann
zusammengezählt werden, wenn sie übereinstimmen in:
:::

::: ulist
- Host

- Anwendung

- [Match-Gruppen](#matchgroups)
:::

::: paragraph
Damit können Sie Regeln formulieren wie „Wenn vom gleichen Host, der
gleichen Anwendung und dort der gleichen Instanz mehr als 10 Meldungen
pro Stunde kommen, dann...​". Dadurch kann es dann auch sein, dass
aufgrund der Regel mehrere unterschiedliche Events erzeugt werden.
:::

::: paragraph
Wählen Sie z.B. alle drei Checkboxen ab, so wird nur noch global gezählt
und die Regel kann auch nur insgesamt ein einziges Event generieren!
:::

::: paragraph
Es kann übrigens durchaus sinnvoll sein, als Anzahl eine 1 einzutragen.
Damit können Sie „Event-Stürme" effektiv in den Griff bekommen. Kommen
z.B. in kurzer Zeit 100 Meldungen der gleichen Art, so wird dafür dann
trotzdem nur ein einziges Event erzeugt. Sie sehen dann in den
Event-Details
:::

::: ulist
- den Zeitpunkt des Auftretens der ersten Meldung,

- den Zeitpunkt der jüngsten Meldung und

- die Gesamtzahl an Meldungen, die in diesem Event zusammengefasst sind.
:::

::: paragraph
Wann der Fall dann „abgeschlossen" ist und bei erneuten Meldungen wieder
ein neues Event aufgemacht werden soll, legen Sie über zwei Checkboxen
fest. Normalerweise führt eine Quittierung des Events dazu, dass bei
weiteren Meldungen eine neue Zählung mit einem neuen Event angefangen
wird. Das können Sie mit [Continue counting when event is
acknowledged]{.guihint} abschalten.
:::

::: paragraph
Die Option [Discontinue counting after time has elapsed]{.guihint} sorgt
dafür, dass für jeden Vergleichszeitraum immer ein separates Event
geöffnet wird. In obigem Beispiel war eine Schwelle von 10 Meldungen pro
Stunde eingestellt. Ist diese Option aktiviert, so werden auf ein
bereits geöffnetes Event maximal 10 Meldungen einer Stunde aufgerechnet.
Sobald die Stunde abgelaufen ist, wird (bei ausreichender Zahl von
Meldungen) wieder ein neues Event geöffnet.
:::

::: paragraph
Setzen Sie z.B. die Anzahl auf 1 und das Zeitintervall auf einen Tag, so
werden Sie pro Tag von diesem Meldungstyp nur noch maximal ein Event
sehen.
:::

::: paragraph
Die Einstellung [Algorithm]{.guihint} ist auf den ersten Blick
vielleicht etwas überraschend. Aber mal ehrlich: Was meint man
eigentlich mit „10 Meldungen pro Stunde"? Welche Stunde ist damit
gemeint? Immer volle Stunden der Tageszeit? Dann könnte es sein, dass in
der letzten Minute einer Stunde neun Meldungen kommen und in der ersten
Minute der nächsten nochmal neun. Macht insgesamt 18 Meldungen in zwei
Minuten. Aber trotzdem weniger als 10 pro Stunde und die Regel würde
nicht greifen. Das klingt nicht so sinnvoll  ...​
:::

::: paragraph
Weil es dazu nicht nur eine einzige Lösung gibt, bietet Checkmk drei
verschiedene Definitionen an, was denn „10 Meldungen pro Stunde" genau
bedeuten soll:
:::

+-------------+--------------------------------------------------------+
| Algorithmus | Funktionsweise                                         |
+=============+========================================================+
| [Interval   | Das Zählintervall startet bei der ersten eingehenden   |
| ]{.guihint} | passenden Meldung. Ein Event in der Phase              |
|             | [counting]{.guihint} wird erzeugt. Vergeht nun die     |
|             | eingestellte Zeit, bevor die Anzahl erreicht wird,     |
|             | wird das Event stillschweigend gelöscht. Wird die      |
|             | Anzahl aber schon vor Ablauf der Zeit erreicht, wird   |
|             | das Event *sofort* geöffnet (und eventuell             |
|             | konfigurierte Aktionen ausgelöst).                     |
+-------------+--------------------------------------------------------+
| [Token      | Dieser Algorithmus arbeitet nicht mit festen           |
| Bucket      | Zeitintervallen, sondern implementiert ein Verfahren,  |
| ]{.guihint} | das bei Netzwerken oft zum Traffic Shaping eingesetzt  |
|             | wird. Angenommen, Sie haben 10 Meldungen pro Stunde    |
|             | konfiguriert. Das sind im Schnitt eine alle 6 Minuten. |
|             | Wenn zum ersten Mal eine passende Meldung eingeht,     |
|             | wird ein Event in der Phase [counting]{.guihint}       |
|             | erzeugt und die Anzahl auf 1 gesetzt. Bei jeder        |
|             | weiteren Meldung wird diese um 1 erhöht. Und alle 6    |
|             | Minuten wird der Zähler wieder um 1                    |
|             | *verringert* --- egal, ob eine Meldung gekommen ist    |
|             | oder nicht. Fällt der Zähler wieder auf 0, wird das    |
|             | Event gelöscht. Der Trigger wird also dann ausgelöst,  |
|             | wenn die Rate der Meldungen *im Schnitt* dauerhaft     |
|             | über 10 pro Stunde liegt.                              |
+-------------+--------------------------------------------------------+
| [Dynamic    | Dies ist eine Variante des [Token                      |
| Token       | Bucket]{.guihint}-Algorithmus, bei der der Zähler umso |
| Bucket      | langsamer verringert wird, je kleiner er gerade ist.   |
| ]{.guihint} | In obigem Beispiel würde der Zähler bei Stand von 5    |
|             | nur alle *12* statt alle 6 Minuten verringert. Das     |
|             | führt insgesamt dazu, dass Meldungsraten, die nur      |
|             | knapp über der erlaubten Rate liegen, deutlich         |
|             | schneller ein Event öffnen (und damit benachrichtigt   |
|             | werden).                                               |
+-------------+--------------------------------------------------------+

::: paragraph
Welchen Algorithmus sollten Sie also wählen?
:::

::: ulist
- [Interval]{.guihint} ist am einfachsten zu verstehen und leichter
  nachzuvollziehen, wenn Sie später in Ihrem Syslog-Archiv genau
  nachzählen möchten.

- [Token Bucket]{.guihint} dagegen ist intelligenter und „weicher". Es
  kommt zu weniger Anomalien an den Rändern der Intervalle.

- [Dynamic Token Bucket]{.guihint} macht das System reaktiver und
  erzeugt schneller Benachrichtigungen.
:::

::: paragraph
Events, die die eingestellte Anzahl noch nicht erreicht haben, sind
latent schon vorhanden aber für den Operator nicht automatisch sichtbar.
Sie befinden sich in der Phase [counting]{.guihint}. Sie können solche
Events mit dem Filter [Phase]{.guihint} in der Event-Ansicht sichtbar
machen:
:::

:::: imageblock
::: content
![ec phase filter
counting](../images/ec_phase_filter_counting.png){width="440"}
:::
::::
:::::::::::::::::::::::

::::::::: sect3
#### []{#expect .hidden-anchor .sr-only}Zu seltene oder ausbleibende Meldungen {#heading_expect}

::: paragraph
Genauso wie das Eingehen einer bestimmten Meldung kann auch das
**Ausbleiben** ein Problem bedeuten. Eventuell erwarten Sie pro Tag
mindestens eine Meldung von einem bestimmten Job. Bleibt diese aus, ist
der Job wahrscheinlich nicht gelaufen und sollte dringend repariert
werden.
:::

::: paragraph
So etwas können Sie unter [Counting & Timing \> Expect regular
messages]{.guihint} konfigurieren:
:::

:::: imageblock
::: content
![ec expect messages](../images/ec_expect_messages.png)
:::
::::

::: paragraph
Wie beim Zählen müssen Sie auch hier einen Zeitraum angeben, in dem Sie
die Meldung(en) erwarten. Hier kommt allerdings ein ganz anderer
Algorithmus zur Anwendung, der an dieser Stelle viel sinnvoller ist. Der
Zeitraum wird hier nämlich immer exakt an definierten Stellen
ausgerichtet. So wird z.B. beim Interval [hour]{.guihint} immer bei
Minute und Sekunde Null begonnen. Sie haben folgende Optionen:
:::

+-----------------+-----------------------------------------------------+
| Interval        | Ausrichtung                                         |
+=================+=====================================================+
| [10             | Bei einer durch 10 teilbaren Sekundenzahl           |
| sec             |                                                     |
| onds]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [mi             | Auf der vollen Minute                               |
| nute]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [5              | Bei 0:00, 0:05, 0:10, usw.                          |
| min             |                                                     |
| utes]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [15             | Bei 0:00, 0:15, 0:30, 0:45, usw.                    |
| min             |                                                     |
| utes]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [               | Auf dem Beginn jeder vollen Stunde                  |
| hour]{.guihint} |                                                     |
+-----------------+-----------------------------------------------------+
| [day]{.guihint} | Exakt bei 00:00 Uhr, allerdings in einer            |
|                 | konfigurierbaren Zeitzone. Damit können Sie auch    |
|                 | sagen, dass Sie eine Meldung zwischen 12:00 Uhr und |
|                 | 12:00 Uhr am nächsten Tag erwarten. Wenn Sie selbst |
|                 | z.B. in der Zeitzone *UTC +1* sind, geben Sie dazu  |
|                 | [UTC -11 hours]{.guihint} an.                       |
+-----------------+-----------------------------------------------------+
| [two            | Zu Beginn einer vollen Stunde. Sie können hier      |
| days]{.guihint} | einen Zeitzonenoffset von 0 bis 47 angeben, der     |
|                 | sich auf 1970-01-01 00:00:00 UTC bezieht.           |
+-----------------+-----------------------------------------------------+
| [               | Um 00:00 Uhr am Donnerstag morgen in der Zeitzone   |
| week]{.guihint} | UTC plus das Offset, das Sie in Stunden ausgeben    |
|                 | können. Donnerstag deswegen, weil der               |
|                 | 1.1.1970 --- der Beginn der „Epoche", an einem      |
|                 | Donnerstag war.                                     |
+-----------------+-----------------------------------------------------+

::: paragraph
Warum ist das so kompliziert? Das soll Fehlalarme vermeiden. Erwarten
Sie z.B. eine Meldung vom Backup pro Tag? Sicher wird es leichte
Unterschiede in der Laufzeit des Backups geben, so dass die Meldungen
nicht exakt 24 Stunden auseinander liegen. Erwarten Sie die Meldung z.B.
ungefähr gegen Mitternacht plus/minus ein oder zwei Stunden, so ist ein
Intervall von 12:00 bis 12:00 Uhr viel robuster, als eines von 00:00 bis
00:00 Uhr. Allerdings bekommen Sie dann auch erst um 12:00 Uhr eine
Benachrichtigung, wenn die Meldung ausbleibt.
:::
:::::::::

:::: sect3
#### []{#_mehrfaches_auftreten_des_gleichen_problems .hidden-anchor .sr-only}Mehrfaches Auftreten des gleichen Problems {#heading__mehrfaches_auftreten_des_gleichen_problems}

::: paragraph
Die Option [Merge with open event]{.guihint} ist so voreingestellt, dass
bei einem mehrfachen hintereinander Ausbleiben der gewünschten Meldung,
das bestehende Event aktualisiert wird. Dies können Sie so umschalten,
dass jedes Mal ein neues Event aufgemacht wird.
:::
::::
::::::::::::::::::::::::::::::::::

::::::::::: sect2
### []{#timing .hidden-anchor .sr-only}5.6. Timing {#heading_timing}

::: paragraph
Unter [Counting & Timing]{.guihint} gibt es zwei Optionen, welche das
Öffnen bzw. automatische Schließen von Events betreffen.
:::

::: paragraph
Die Option [Delay event creation]{.guihint} ist nützlich, wenn Sie mit
dem automatischen [Aufheben](#canceling) von Events arbeiten. Setzen Sie
z.B. eine Verzögerung von 5 Minuten, so verharrt bei einer Störmeldung
das so erzeugte Event 5 Minuten im Zustand [delayed]{.guihint} --- in
der Hoffnung, dass in dieser Zeit die OK-Meldung eintrifft. Ist das der
Fall, so wird das Event automatisch und ohne Aufhebens wieder
geschlossen und schlägt nicht im Monitoring auf. Läuft die Zeit aber ab,
so wird das Event geöffnet und eventuell eine dafür definierte Aktion
ausgeführt:
:::

:::: imageblock
::: content
![ec delay](../images/ec_delay.png)
:::
::::

::: paragraph
In etwa das Gegenteil macht [Limit event lifetime]{.guihint}. Damit
können Sie Events nach einer bestimmten Zeit automatisch schließen
lassen. Das ist z.B. nützlich für informative Events mit
[OK]{.state0}-Status, die Sie zwar anzeigen möchten, aber für die das
Monitoring keine Aktivitäten nach sich ziehen soll. Durch das
automatische „Herausaltern" sparen Sie sich das manuelle Löschen solcher
Meldungen:
:::

:::: imageblock
::: content
![ec limit livetime](../images/ec_limit_livetime.png)
:::
::::

::: paragraph
Durch ein Quittieren wird das Herausaltern erst einmal gestoppt. Dieses
Verhalten können Sie aber mit den beiden Checkboxen nach Bedarf
justieren.
:::
:::::::::::

::::::::: sect2
### []{#rulepacks .hidden-anchor .sr-only}5.7. Regelpakete {#heading_rulepacks}

::: paragraph
Regelpakete haben nicht nur den Sinn, Dinge übersichtlicher zu machen,
sondern können die Konfiguration vieler ähnlicher Regeln auch deutlich
vereinfachen und gleichzeitig die Auswertung beschleunigen.
:::

::: paragraph
Angenommen, Sie haben einen Satz von 20 Regeln, die sich alle um das
Windows Event Log [Security]{.guihint} drehen. Alle diese Regeln haben
gemeinsam, dass sie in der Bedingung auf einen bestimmten Text im
Anwendungsfeld prüfen (der Name dieser Log-Datei wird bei den Meldungen
von der EC als [Application]{.guihint} eingetragen). Gehen Sie in so
einem Fall wie folgt vor:
:::

::: {.olist .arabic}
1.  Legen Sie ein eigenes Regelpaket an.

2.  Legen Sie die 20 Regeln für [Security]{.guihint} in diesem Paket an
    oder ziehen Sie sie dorthin um (Auswahlliste [Move to
    pack...​]{.guihint} rechts in der Regeltabelle).

3.  Entfernen Sie aus allen diesen Regeln die Bedingung auf die
    Anwendung.

4.  Legen Sie **als erste Regel** in dem Paket eine Regel an, durch die
    Meldungen das Paket sofort verlassen, wenn die Anwendung *nicht*
    [Security]{.guihint} ist.
:::

::: paragraph
Diese Ausschlussregel ist wie folgt aufgebaut:
:::

::: ulist
- [Matching Criteria \> Match syslog application (tag)]{.guihint} auf
  `Security`

- [Matching Criteria \> Invert matching]{.guihint} auf [Negate match:
  Execute this rule if the upper conditions are not
  fulfilled.]{.guihint}

- [Outcome & Action \> Rule type]{.guihint} auf [Skip this rule pack,
  continue rule execution with next rule pack]{.guihint}
:::

::: paragraph
Jede Meldung, die nicht vom Security-Log kommt, wird also bereits von
der ersten Regel in diesem Paket „abgewiesen". Das vereinfacht nicht nur
die weiteren Regeln des Pakets, sondern beschleunigt auch die
Abarbeitungen, da diese in den meisten Fällen gar nicht mehr geprüft
werden müssen.
:::
:::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#actions .hidden-anchor .sr-only}6. Aktionen {#heading_actions}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_arten_von_aktionen .hidden-anchor .sr-only}6.1. Arten von Aktionen {#heading__arten_von_aktionen}

::: paragraph
Die Event Console bietet drei Arten von Aktionen, welche Sie entweder
manuell oder beim Öffnen oder [Aufheben](#canceling) von Events
ausführen lassen können:
:::

::: ulist
- Ausführen von selbst geschriebenen Shell-Skripten

- Versenden von selbst definierten E-Mails

- Erzeugen von Checkmk [Benachrichtigungen](#notifications)
:::
:::::

::::::::::::::::::::::: sect2
### []{#_shell_skripte_und_e_mails .hidden-anchor .sr-only}6.2. Shell-Skripte und E-Mails {#heading__shell_skripte_und_e_mails}

::: paragraph
E-Mails und Skripte müssen Sie zunächst in den [Einstellungen der Event
Console](#globalsettings) definieren. Sie finden diese unter dem Eintrag
[Actions (E-Mails & Scripts)]{.guihint}:
:::

:::: imageblock
::: content
![ec add action](../images/ec_add_action.png)
:::
::::

::::::::::::::: sect3
#### []{#_shell_skripte_ausführen .hidden-anchor .sr-only}Shell-Skripte ausführen {#heading__shell_skripte_ausführen}

::: paragraph
Mit dem Knopf [Add new action]{.guihint} legen Sie eine neue Aktion an.
Folgendes Beispiel zeigt, wie Sie ein einfaches Shell-Skript als Aktion
vom Typ [Execute Shell Script]{.guihint} anlegen können. Dem Skript
stehen über Umgebungsvariablen Details zu den Events zur Verfügung,
beispielsweise die `$CMK_ID` des Events, der `$CMK_HOST`, Volltext
`$CMK_TEXT` oder die erste Match-Gruppe als `$CMK_MATCH_GROUP_1`. Eine
vollständige Liste der verfügbaren Umgebungsvariablen erhalten Sie in
der [![icon help](../images/icons/icon_help.png)]{.image-inline}
Inline-Hilfe.
:::

:::: imageblock
::: content
![ec define action](../images/ec_define_action.png)
:::
::::

::: paragraph
Ältere Versionen von Checkmk haben neben Umgebungsvariablen auch Makros
wie `$TEXT$` erlaubt, die vor Ausführung des Skriptes ersetzt wurden.
Wegen der Gefahr, dass ein Angreifer über ein eigens angefertigtes
UDP-Paket Befehle einschleusen kann, die mit den Rechten des Checkmk
Prozesses ausgeführt werden, sollten Sie von Makros keinen Gebrauch
machen. Makros sind derzeit noch aus Kompatibilitätsgründen erlaubt,
jedoch behalten wir uns die Entfernung in einer künftigen Checkmk
Version vor.
:::

::: paragraph
Das Beispielskript aus dem Screenshot legt im Instanzverzeichnis die
Datei `tmp/test.out` an und schreibt dort einen Text mit den konkreten
Werten der Variablen zu dem jeweils letzten Event:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
cat << EOF > ${OMD_ROOT}/tmp/test.out
Something happened:

Event-ID: $CMK_ID
Host: $CMK_HOST
Application: $CMK_APPLICATION
Message: $CMK_TEXT
EOF
```
:::
::::

::: paragraph
Die Skripte werden unter folgender Umgebung ausgeführt:
:::

::: ulist
- Als Interpreter wird `/bin/bash` verwendet.

- Das Skript läuft als Instanzbenutzer mit dem Home-Verzeichnis der
  Instanz (z.B. `/omd/sites/mysite`).

- Während der Laufzeit des Skripts ist die Verarbeitung weiterer Events
  angehalten!
:::

::: paragraph
Sollte Ihr Skript eventuell Wartezeiten enthalten, können Sie es
mithilfe von Linux\' `at`-Spooler asynchron laufen lassen. Dazu legen
Sie das Skript in einer eigenen Datei `local/bin/myaction` an und
starten es mit dem `at`-Befehl, z.B.:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
echo "$OMD_ROOT/local/bin/myaction '$HOST$' '$TEXT$' | at now
```
:::
::::
:::::::::::::::

:::::: sect3
#### []{#_versenden_von_e_mails .hidden-anchor .sr-only}Versenden von E-Mails {#heading__versenden_von_e_mails}

::: paragraph
Der Aktionstyp [Send Email]{.guihint} versendet eine einfache
Text-E-Mail. Eigentlich könnten Sie das auch über den Umweg mit einem
Skript erreichen, in dem Sie z.B. mit dem Kommandozeilenbefehl `mail`
arbeiten. Aber so ist es komfortabler. Beachten Sie, dass auch in den
Feldern [Recipient E-Mail address]{.guihint} und [Subject]{.guihint}
Platzhalter erlaubt sind.
:::

:::: imageblock
::: content
![ec define action email](../images/ec_define_action_email.png)
:::
::::
::::::
:::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect2
### []{#notifications .hidden-anchor .sr-only}6.3. Benachrichtigung durch Checkmk {#heading_notifications}

::: paragraph
Neben dem Ausführen von Skripten und dem Versenden von (einfachen)
E-Mails kennt die EC noch eine dritte Art von Aktion: Das Versenden von
Benachrichtigungen über das Checkmk
[Benachrichtigungssystem](glossar.html#notification#). Die dabei von der
EC erzeugten Benachrichtigungen gehen den gleichen Weg, wie die Host-
und Servicebenachrichtigungen aus dem aktiven Monitoring. Die Vorteile
gegenüber den oben beschriebenen einfachen E-Mails liegen auf der Hand:
:::

::: ulist
- Die Benachrichtigung wird für aktives und Event-basiertes Monitoring
  gemeinsam an zentraler Stelle konfiguriert.

- Funktionen wie [Sammelbenachrichtigungen](notifications.html#bulk),
  HTML-E-Mails und andere nützliche Dinge stehen zur Verfügung.

- Benutzerdefinierte Benachrichtigungsregeln, ein Abschalten der
  Benachrichtigungen und Ähnliches funktionieren wie gewohnt.
:::

::: paragraph
Die Aktionsart [Send monitoring notification]{.guihint}, die das macht,
steht immer automatisch zur Verfügung und muss nicht extra konfiguriert
werden.
:::

::: paragraph
Da Events einige Unterschiede zu den „normalen" Hosts oder Services
haben, gibt es ein paar Besonderheiten bei deren Benachrichtigung,
welche Sie im Folgenden genauer kennen lernen.
:::

:::::::::::: sect3
#### []{#_zuordnung_zu_bestehenden_hosts .hidden-anchor .sr-only}Zuordnung zu bestehenden Hosts {#heading__zuordnung_zu_bestehenden_hosts}

::: paragraph
Events können von beliebigen Hosts kommen --- egal, ob diese im aktiven
Monitoring konfiguriert sind oder nicht. Schließlich steht der Syslog-
und SNMP-Port allen Hosts im Netzwerk offen. Daher stehen die
erweiterten Host-Attribute wie Alias, Host-Merkmale, Kontakte usw. erst
einmal nicht zur Verfügung. Das bedeutet insbesondere, dass
*Bedingungen* in Benachrichtigungsregeln nicht unbedingt so
funktionieren, wie Sie das erwarten würden.
:::

::: paragraph
Daher versucht die EC bei der Benachrichtigung einen zum Event passenden
Host aus dem aktiven Monitoring zu finden. Dabei wird das gleiche
Verfahren wie bei der [Sichtbarkeit von Events](#visibility) angewandt.
Kann so ein Host gefunden werden, so werden von diesem folgende Daten
übernommen:
:::

::: ulist
- Die korrekte Schreibweise des Host-Namens

- Der Host-Alias

- Die in Checkmk konfigurierte primäre IP-Adresse

- Die Host-Merkmale (*host tags*)

- Der Ordner in der Setup-GUI

- Die Liste der Kontakte und Kontaktgruppen
:::

::: paragraph
Dadurch kann es dazu kommen, dass der Host-Name in der Benachrichtigung
nicht exakt mit dem Host-Namen aus der ursprünglichen Meldung
übereinstimmt. Die Anpassung auf die Schreibweise des aktiven
Monitorings vereinfacht aber das Formulieren von einheitlichen
Benachrichtigungsregeln, welche Bedingungen auf den Host-Namen
enthalten.
:::

::: paragraph
Die Zuordnung geschieht in Echtzeit durch eine
[Livestatus](glossar.html#livestatus)-Abfrage an den Monitoring-Kern,
welcher in der gleichen Instanz wie die EC läuft, die die Meldung
empfangen hat. Das klappt natürlich nur, wenn die Syslog-Meldungen,
SNMP-Traps usw. immer an diejenige Checkmk Instanz gesendet werden, auf
der der Host auch aktiv überwacht wird!
:::

::: paragraph
Falls die Abfrage nicht klappt oder der Host nicht gefunden werden kann,
werden Ersatzdaten angenommen:
:::

+-----------------+-----------------------------------------------------+
| Host-Name       | Der Host-Name aus dem Event.                        |
+-----------------+-----------------------------------------------------+
| Host-Alias      | Als Alias wird der Host-Name verwendet.             |
+-----------------+-----------------------------------------------------+
| IP-Adresse      | Das Feld IP-Adresse enthält die originale           |
|                 | Absenderadresse der Meldung.                        |
+-----------------+-----------------------------------------------------+
| Host-Merkmale   | Der Host erhält kein Host-Merkmal. Falls Sie        |
|                 | Host-Merkmalsgruppen mit leeren Merkmalen haben,    |
|                 | nimmt der Host dort diese Merkmale an. Ansonsten    |
|                 | hat er kein Merkmal der Gruppe. Beachten Sie das,   |
|                 | wenn Sie in den Benachrichtigungsregeln Bedingungen |
|                 | über Host-Merkmale definieren.                      |
+-----------------+-----------------------------------------------------+
| Setup-GUI       | Kein Ordner. Sämtliche Bedingungen, die auf einen   |
| Ordner          | bestimmten Ordner gehen, sind damit                 |
|                 | unerfüllbar --- selbst wenn es sich um den          |
|                 | Hauptordner handelt.                                |
+-----------------+-----------------------------------------------------+
| Kontakte        | Die Liste der Kontakte ist leer. Sind               |
|                 | Fallback-Kontakte vorhanden, werden diese           |
|                 | eingetragen.                                        |
+-----------------+-----------------------------------------------------+

::: paragraph
Wenn der Host im aktiven Monitoring nicht zugeordnet werden kann, kann
das natürlich zu Problemen bei der Benachrichtigung führen. Zum einen
wegen der Bedingungen, die dann eventuell nicht mehr greifen, zum
anderen wegen der Kontaktauswahl. Für solche Fälle können Sie Ihre
Benachrichtigungsregeln so anpassen, dass Benachrichtigungen aus der
Event Console mit einer eigenen Regel gezielt behandelt werden. Dazu
gibt es eine eigene Bedingung, mit der Sie entweder positiv nur auf
EC-Benachrichtigungen matchen oder umgekehrt diese ausschließen können:
:::

:::: imageblock
::: content
![ec notification condition](../images/ec_notification_condition.png)
:::
::::
::::::::::::

:::: sect3
#### []{#_restliche_felder_der_benachrichtigung .hidden-anchor .sr-only}Restliche Felder der Benachrichtigung {#heading__restliche_felder_der_benachrichtigung}

::: paragraph
Damit Benachrichtigungen aus der EC das Benachrichtigungssystem des
aktiven Monitorings durchlaufen können, muss sich die EC an dessen
Schema anpassen. Dabei werden die typischen Datenfelder einer
Benachrichtigung so sinnvoll wie möglich gefüllt. Wie die Daten des
Hosts ermittelt werden, haben wir gerade beschrieben. Weitere Felder
sind:
:::

+-----------------+-----------------------------------------------------+
| Benac           | EC-Benachrichtigungen gelten immer als              |
| hrichtigungstyp | *Servicenachricht.*                                 |
+-----------------+-----------------------------------------------------+
| Service         | Hier wird der Inhalt des Felds                      |
| description     | [Application]{.guihint} aus dem Event eingetragen.  |
|                 | Falls das leer ist, wird `Event Console`            |
|                 | eingetragen.                                        |
+-----------------+-----------------------------------------------------+
| Benachri        | Diese ist fest auf `1` eingestellt. Damit ist hier  |
| chtigungsnummer | auch keine Eskalation möglich. Selbst mehrere       |
|                 | aufeinanderfolgende Events der gleichen Art         |
|                 | geschehen voneinander unabhängig. Aktuell           |
|                 | unterstützt die EC keine wiederholte                |
|                 | Benachrichtigung für den Fall, dass ein Event nicht |
|                 | quittiert wird.                                     |
+-----------------+-----------------------------------------------------+
| Datum/Uhrzeit   | Bei Events, die [zählen](#counting), ist das der    |
|                 | Zeitpunkt des *letzten* Auftretens einer zum Event  |
|                 | gehörigen Meldung.                                  |
+-----------------+-----------------------------------------------------+
| Plugin Output   | Der Textinhalt des Events.                          |
+-----------------+-----------------------------------------------------+
| Service-Zustand | Zustand des Events, also [OK]{.state0},             |
|                 | [WARN]{.state1}, [CRIT]{.state2} oder               |
|                 | [UNKNOWN]{.state3}.                                 |
+-----------------+-----------------------------------------------------+
| Vorheriger      | Da Events keinen früheren Status haben, wird hier   |
| Zustand         | bei normalen Events immer [OK]{.state0}, beim       |
|                 | [Aufhebung eines Events](#canceling) immer          |
|                 | [CRIT]{.state2} eingetragen. Diese Regelung kommt   |
|                 | dem am nächsten, was man für                        |
|                 | Benachrichtigungsregeln braucht, die eine Bedingung |
|                 | auf den genauen Zustandswechsel haben.              |
+-----------------+-----------------------------------------------------+
::::

:::::: sect3
#### []{#_kontaktgruppen_manuell_festlegen .hidden-anchor .sr-only}Kontaktgruppen manuell festlegen {#heading__kontaktgruppen_manuell_festlegen}

::: paragraph
Wie oben beschrieben, können zu einem Event eventuell nicht die
passenden Kontakte automatisch ermittelt werden. Für solche Fälle können
Sie direkt in der EC-Regel Kontaktgruppen angeben, welche für die
Benachrichtigung verwendet werden sollen. Wichtig ist, dass Sie den
Haken bei [Use in notifications]{.guihint} nicht vergessen:
:::

:::: imageblock
::: content
![ec set contact groups](../images/ec_set_contact_groups.png)
:::
::::
::::::

:::::::::: sect3
#### []{#_globaler_schalter_für_benachrichtigungen .hidden-anchor .sr-only}Globaler Schalter für Benachrichtigungen {#heading__globaler_schalter_für_benachrichtigungen}

::: paragraph
Im Snapin [Master control]{.guihint} gibt es einen zentralen Schalter
für Benachrichtigungen. Dieser gilt auch für Benachrichtigungen, die von
der EC weitergeleitet werden:
:::

:::: imageblock
::: content
![Das Snapin Master control mit abgeschalteten
Benachrichtigungen.](../images/ec_master_control_notifications_off.png){width="50%"}
:::
::::

::: paragraph
Ebenso wie die Host-Zuordnung erfordert die Abfrage des Schalters durch
die EC einen Livestatus-Zugriff auf den lokalen Monitoring-Kern. Eine
erfolgreiche Abfrage sehen Sie in der Log-Datei der Event Console:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1482142567.147669] Notifications are currently disabled. Skipped notification for event 44
```
:::
:::::
::::::::::

:::::::: sect3
#### []{#_wartungszeiten_von_hosts .hidden-anchor .sr-only}Wartungszeiten von Hosts {#heading__wartungszeiten_von_hosts}

::: paragraph
Die Event Console erkennt Hosts, die gerade in einer
[Wartungszeit](glossar.html#scheduled_downtime) sind und versendet in
diesem Fall keine Benachrichtigungen. In der Log-Datei sieht das so aus:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1482144021.310723] Host myserver123 is currently in scheduled downtime. Skipping notification of event 433.
```
:::
:::::

::: paragraph
Auch das setzt natürlich ein erfolgreiches Finden des Hosts im aktiven
Monitoring voraus. Falls dies nicht gelingt, wird angenommen, dass sich
der Host *nicht* in Wartung befindet und die Benachrichtigung auf jeden
Fall generiert.
:::
::::::::

:::: sect3
#### []{#_zusätzliche_makros .hidden-anchor .sr-only}Zusätzliche Makros {#heading__zusätzliche_makros}

::: paragraph
Falls Sie ein eigenes
[Benachrichtigungsskript](notifications.html#scripts) schreiben, haben
Sie speziell bei Benachrichtigungen, die aus der Event Console kommen,
etliche zusätzliche Variablen zur Verfügung, die den ursprünglichen
Event beschreiben (Zugriff wie gewohnt mit Präfix `NOTIFY_`):
:::

+-----------------+-----------------------------------------------------+
| `EC_ID`         | Event-ID.                                           |
+-----------------+-----------------------------------------------------+
| `EC_RULE_ID`    | ID der Regel, die das Event erzeugt hat.            |
+-----------------+-----------------------------------------------------+
| `EC_PRIORITY`   | Syslog-Priorität als Zahl von `0` (`emerg`) bis `7` |
|                 | (`debug`).                                          |
+-----------------+-----------------------------------------------------+
| `EC_FACILITY`   | Syslog Facility --- ebenfalls als Zahl. Der         |
|                 | Wertebereich geht von `0` (`kern`) bis `32`         |
|                 | (`snmptrap`).                                       |
+-----------------+-----------------------------------------------------+
| `EC_PHASE`      | Phase des Events. Da nur offene Events Aktionen     |
|                 | auslösen, sollte hier `open` stehen. Bei einer      |
|                 | manuellen Benachrichtigung eines bereits            |
|                 | quittierten Events steht hier `ack`.                |
+-----------------+-----------------------------------------------------+
| `EC_COMMENT`    | Das Kommentarfeld des Events.                       |
+-----------------+-----------------------------------------------------+
| `EC_OWNER`      | Das Feld [Owner]{.guihint}.                         |
+-----------------+-----------------------------------------------------+
| `EC_CONTACT`    | Das Kommentarfeld mit der Event-spezifischen        |
|                 | Kontaktinformation.                                 |
+-----------------+-----------------------------------------------------+
| `EC_PID`        | Die ID des Prozesses, der die Meldung gesendet hat  |
|                 | (bei Syslog-Events).                                |
+-----------------+-----------------------------------------------------+
| `E              | Die Match-Gruppen vom Matchen in der Regel.         |
| C_MATCH_GROUPS` |                                                     |
+-----------------+-----------------------------------------------------+
| `EC_            | Die optional manuell in der Regel definierten       |
| CONTACT_GROUPS` | Kontaktgruppen.                                     |
+-----------------+-----------------------------------------------------+
::::
:::::::::::::::::::::::::::::::::::::::

:::::::::::: sect2
### []{#automatic_actions .hidden-anchor .sr-only}6.4. Aktionen ausführen {#heading_automatic_actions}

::: paragraph
Das manuelle Ausführen von Aktionen durch den Operator haben Sie schon
weiter oben bei den [Kommandos](#commands) gesehen. Spannender ist das
automatische Ausführen von Aktionen, welches Sie in EC-Regeln im
Abschnitt [Outcome & Action]{.guihint} konfigurieren können:
:::

:::: imageblock
::: content
![ec rule actions](../images/ec_rule_actions.png)
:::
::::

::: paragraph
Hier können Sie eine oder mehrere Aktionen auswählen, die immer dann
ausgeführt werden, wenn aufgrund der Regel ein Event *geöffnet* oder
[aufgehoben](#canceling) wird. Bei Letzterem können Sie über die Liste
[Do cancelling actions]{.guihint} noch festlegen, ob die Aktion nur dann
ausgeführt werden soll, wenn das aufgehobene Event schon die Phase
[open]{.guihint} erreicht hat. Bei Verwendung von [Zählen](#counting)
oder [Verzögerung](#timing) kann es nämlich dazu kommen, dass Events
aufgehoben werden, die quasi noch im Wartezustand und für den Benutzer
noch nicht sichtbar waren.
:::

::: paragraph
Die Ausführung von Aktionen wird in der Log-Datei `var/log/mkeventd.log`
vermerkt:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1481120419.712534] Executing command: ACTION;1;cmkadmin;test
[1481120419.718173] Exitcode: 0
```
:::
:::::

::: paragraph
Auch in das [Archiv](#archive) werden diese geschrieben.
:::
::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#snmp .hidden-anchor .sr-only}7. SNMP-Traps {#heading_snmp}

::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::: sect2
### []{#_empfang_von_snmp_traps_aufsetzen .hidden-anchor .sr-only}7.1. Empfang von SNMP-Traps aufsetzen {#heading__empfang_von_snmp_traps_aufsetzen}

::: paragraph
Da die Event Console eine eingebaute eigene SNMP-Engine hat, ist das
Aufsetzen des Empfangs von SNMP-Traps sehr einfach. Sie benötigen keinen
`snmptrapd` vom Betriebssystem! Falls Sie diesen bereits am Laufen
haben, so beenden Sie ihn.
:::

::: paragraph
Wie im Abschnitt über das [Aufsetzen](#setup) der Event Console
beschrieben, aktivieren Sie mit `omd config` den Trap-Empfänger in
dieser Instanz:
:::

:::: imageblock
::: content
![ec config traps](../images/ec_config_traps.png){width="360"}
:::
::::

::: paragraph
Da auf jedem Server der UDP-Port für die Traps nur von einem Prozess
verwendet werden kann, darf das pro Rechner nur in einer einzigen
Checkmk Instanz gemacht werden. Beim Start der Instanz können Sie in der
Zeile mit `mkeventd` kontrollieren, ob der Trap-Empfang eingeschaltet
ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Creating temporary filesystem /omd/sites/mysite/tmp...OK
Starting mkeventd (builtin: snmptrap)...OK
Starting liveproxyd...OK
Starting mknotifyd...OK
Starting rrdcached...OK
Starting cmc...OK
Starting apache...OK
Starting dcd...OK
Starting redis...OK
Initializing Crontab...OK
```
:::
::::

::: paragraph
Damit SNMP-Traps funktionieren, müssen sich Sender und Empfänger auf
bestimmte [Credentials]{.guihint} einigen. Im Fall von SNMP v1 und v2c
ist das ein einfaches Passwort, was hier „Community" genannt wird. Bei
Version 3 benötigen Sie ein paar mehr Angaben. Diese Credentials
konfigurieren Sie in den [Einstellungen der Event
Console](#globalsettings) unter [Credentials for processing SNMP
traps]{.guihint}. Dabei können Sie mit dem Knopf [Add new
element]{.guihint} mehrere unterschiedliche Credentials einrichten,
welche von den Geräten alternativ verwendet werden können:
:::

:::: imageblock
::: content
![ec trap credentials](../images/ec_trap_credentials.png)
:::
::::

::: paragraph
Der weitaus aufwendigere Teil ist es jetzt natürlich, bei allen
Zielgeräten, die überwacht werden sollen, die Zieladresse für Traps
einzutragen und auch hier die Credentials zu konfigurieren.
:::
::::::::::::::

::::::::::::::::: sect2
### []{#_testen .hidden-anchor .sr-only}7.2. Testen {#heading__testen}

::: paragraph
Leider bieten die wenigsten Geräte sinnvolle Testmöglichkeiten. Immerhin
können Sie den Empfang der Traps durch die Event Console selbst recht
einfach von Hand testen, indem Sie --- am besten von einem anderen
Linux-Rechner aus --- eine Test-Trap senden. Dies geht mit dem Befehl
`snmptrap`. Folgendes Beispiel sendet eine Trap an `192.168.178.11`. Der
eigene Host-Name wird nach dem `.1.3.6.1` angegeben und muss auflösbar
sein oder als IP-Adresse (hier `192.168.178.30`) angegeben werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ snmptrap -v 1 -c public 192.168.178.11 .1.3.6.1 192.168.178.30 6 17 '' .1.3.6.1 s "Just kidding"
```
:::
::::

::: paragraph
Falls Sie in den Einstellungen das [Log level]{.guihint} auf [Verbose
logging]{.guihint} eingestellt haben, können Sie den Empfang und die
Auswertung der Traps in der Log-Datei der EC sehen:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1482387549.481439] Trap received from 192.168.178.30:56772. Checking for acceptance now.
[1482387549.485096] Trap accepted from 192.168.178.30 (ContextEngineId "0x80004fb8054b6c617070666973636816893b00", ContextName "")
[1482387549.485136] 1.3.6.1.2.1.1.3.0                        = 329887
[1482387549.485146] 1.3.6.1.6.3.1.1.4.1.0                    = 1.3.6.1.0.17
[1482387549.485186] 1.3.6.1.6.3.18.1.3.0                     = 192.168.178.30
[1482387549.485219] 1.3.6.1.6.3.18.1.4.0                     =
[1482387549.485238] 1.3.6.1.6.3.1.1.4.3.0                    = 1.3.6.1
[1482387549.485258] 1.3.6.1                                  = Just kidding
```
:::
:::::

::: paragraph
Bei falschen Credentials sehen Sie nur eine einzige Zeile:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[1482387556.477364] Trap received from 192.168.178.30:56772. Checking for acceptance now.
```
:::
:::::

::: paragraph
Und so sieht ein Event aus, das von solch einer Trap erzeugt wurde:
:::

:::: imageblock
::: content
![ec trap event](../images/ec_trap_event.png)
:::
::::
:::::::::::::::::

:::::::::::::: sect2
### []{#_aus_zahlen_werden_texte_traps_übersetzen .hidden-anchor .sr-only}7.3. Aus Zahlen werden Texte: Traps übersetzen {#heading__aus_zahlen_werden_texte_traps_übersetzen}

::: paragraph
SNMP ist ein binäres Protokoll und sehr sparsam mit textuellen
Beschreibungen der Meldungen. Um welche Art von Traps es sich handelt,
wird intern durch Folgen von Zahlen in sogenannten OIDs übermittelt.
Diese werden als durch Punkte getrennte Zahlenfolgen angezeigt (z.B.
`1.3.6.1.6.3.18.1.3.0`).
:::

::: paragraph
Mithilfe von sogenannten MIB-Dateien kann die Event Console diese
Zahlenfolgen in Texte übersetzen. So wird dann aus
`1.3.6.1.6.3.18.1.3.0` z.B. der Text `SNMPv2-MIB::sysUpTime.0`.
:::

::: paragraph
Die Übersetzung der Traps schalten Sie in den Einstellungen der Event
Console ein:
:::

:::: imageblock
::: content
![ec translate traps](../images/ec_translate_traps.png)
:::
::::

::: paragraph
Die Test-Trap von oben erzeugt jetzt einen etwas anderen Event:
:::

:::: imageblock
::: content
![ec trap event translated](../images/ec_trap_event_translated.png)
:::
::::

::: paragraph
Haben Sie die Option [Add OID descriptions]{.guihint} aktiviert, wird
das Ganze wesentlich umfangreicher --- und unübersichtlicher. Es hilft
aber besser zu verstehen, was ein Trap genau bedeutet:
:::

:::: imageblock
::: content
![ec trap event translated2](../images/ec_trap_event_translated2.png)
:::
::::
::::::::::::::

::::::::: sect2
### []{#_hochladen_eigener_mibs .hidden-anchor .sr-only}7.4. Hochladen eigener MIBs {#heading__hochladen_eigener_mibs}

::: paragraph
Leider haben sich die Vorteile von Open Source bei den Autoren von
MIB-Dateien noch nicht herumgesprochen, und so sind wir vom Checkmk
Projekt leider nicht in der Lage, herstellerspezifische MIB-Dateien mit
auszuliefern. Nur eine kleine Sammlung von freien Basis-MIBs ist
vorinstalliert und sorgt z.B. für eine Übersetzung von `sysUpTime`.
:::

::: paragraph
Sie können aber in der Event Console im Modul [SNMP MIBs for trap
translation]{.guihint} mit dem Menü-Eintrag [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add one or multiple
MIBs]{.guihint} eigene MIB-Dateien hochladen, wie das hier mit einigen
MIBs von *Netgear Smart Switches* geschehen ist:
:::

:::: imageblock
::: content
![ec mibs for translation](../images/ec_mibs_for_translation.jpg)
:::
::::

::: paragraph
Hinweise zu den MIBs:
:::

::: ulist
- Anstelle von Einzeldateien können Sie auch ZIP-Dateien mit
  MIBs-Sammlungen in einem Rutsch hochladen.

- MIBs haben untereinander Abhängigkeiten. Fehlende MIBs werden Ihnen
  von Checkmk angezeigt.

- Die hochgeladenen MIBs werden auch auf der Kommandozeile von
  `cmk --snmptranslate` verwendet.
:::
:::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#logwatch .hidden-anchor .sr-only}8. Überwachen von Log-Dateien {#heading_logwatch}

:::::::::::::::::::::: sectionbody
::: paragraph
Der Checkmk Agent ist in der Lage, Log-Dateien über das
*Logwatch*-Plugin auszuwerten. Dieses Plugin bietet zunächst einmal eine
eigene von der Event Console unabhängige Überwachung von
Log-Dateien --- inklusive der Möglichkeit, Meldungen direkt im
Monitoring zu quittieren. Es gibt aber auch die Möglichkeit, die vom
Plugin gefundenen Meldungen 1:1 in die Event Console weiterzuleiten.
:::

::: paragraph
Beim Windows-Agenten ist die Log-Dateiüberwachung fest integriert --- in
Form eines Plugins für die Auswertung von Textdateien und eines für die
von Windows Event Logs. Für Linux und Unix steht das in Python
geschriebene Plugin `mk_logwatch` bereit. Alle drei können Sie über die
[Agentenbäckerei](wato_monitoringagents.html#bakery) aufsetzen bzw.
konfigurieren. Verwenden Sie dazu folgende Regelsätze:
:::

::: ulist
- [Text logfiles (Linux, Solaris, Windows)]{.guihint}

- [Finetune Windows Eventlog monitoring]{.guihint}
:::

::: paragraph
Die genaue Konfiguration des Logwatch-Plugins ist nicht Thema dieses
Artikels. Wichtig ist allerdings, dass Sie nach wie vor im
Logwatch-Plugin selbst bereits eine möglichst gute Vorfilterung der
Meldungen vornehmen und nicht einfach die kompletten Inhalte der
Textdateien zur Event Console senden.
:::

::: paragraph
Verwechseln Sie das nicht mit der *nachträglichen* Umklassifizierung
über den Regelsatz [Logfile patterns]{.guihint}. Diese kann lediglich
den Status von Meldungen ändern, die bereits vom Agenten gesendet
wurden. Sollten Sie diese Patterns aber schon eingerichtet haben und
möchten einfach nur von Logwatch auf die Event Console umstellen, so
können Sie die Patterns beibehalten. Dazu gibt es bei den Regeln für die
Weiterleitung ([Logwatch Event Console Forwarding]{.guihint}) die Option
[Reclassify messages before forwarding them to the EC]{.guihint}.
:::

::: paragraph
In diesem Fall gehen alle Meldungen durch insgesamt **drei**
Regelketten: auf dem Agenten, durch die Reklassifizierung und in der
Event Console!
:::

::: paragraph
Stellen Sie Logwatch nun so um, dass die von den Plugins gefundenen
Meldungen nicht mehr mit dem normalen Logwatch-Check überwacht, sondern
einfach 1:1 in die Event Console weitergeleitet und dort verarbeitet
werden. Dazu dient der Regelsatz [Logwatch Event Console
Forwarding]{.guihint}:
:::

:::: imageblock
::: content
![ec logwatch forwarding](../images/ec_logwatch_forwarding.png)
:::
::::

::: paragraph
Dazu einige Hinweise:
:::

::: paragraph
Falls Sie eine verteilte Umgebung haben, bei der nicht in jeder Instanz
eine eigene Event Console läuft, müssen die Remote-Instanzen die
Meldungen an die Zentralinstanz per Syslog weiterleiten. Der Default
dafür ist UDP. Das ist aber kein abgesichertes Protokoll. Besser ist,
Sie verwenden Syslog via TCP, welches Sie allerdings in der
Zentralinstanz [aktivieren](#setup) müssen (`omd config`).
:::

::: paragraph
Bei der Weiterleitung geben Sie eine beliebige [Syslog
facility]{.guihint} an. Anhand dieser können Sie in der EC dann leicht
die weitergeleiteten Meldungen erkennen. Gut geeignet sind dafür
`local0` bis `local7`.
:::

::: paragraph
Mit [List of expected logfiles]{.guihint} können Sie die Liste der
gefundenen Log-Dateien überwachen lassen und werden so gewarnt, wenn
bestimmte erwartete Dateien gar nicht gefunden werden.
:::

::: paragraph
**Wichtig:** Das Speichern der Regel alleine bewirkt noch nichts. Diese
Regel wird lediglich bei der Service-Erkennung aktiv. Erst wenn Sie
diese neu durchführen, werden die bisherigen Logwatch-Services entfernt,
und anstelle dessen wird pro Host *ein* neuer Service mit dem Namen [Log
Forwarding]{.guihint} erzeugt.
:::

:::: imageblock
::: content
![ec log forwarding check](../images/ec_log_forwarding_check.png)
:::
::::

::: paragraph
Dieser Check zeigt Ihnen später auch an, ob es beim Weiterleiten an die
Event Console zu irgendwelchen Problemen kommen sollte.
:::

:::: sect2
### []{#_service_level_und_syslog_priorität .hidden-anchor .sr-only}8.1. Service-Level und Syslog-Priorität {#heading__service_level_und_syslog_priorität}

::: paragraph
Da weitergeleiteten Log-Dateien je nach verwendetem Format oft die
Syslog-Klassifizierung fehlt, können Sie die Neu-Klassifizierung im
Regelsatz [Logwatch Event Console Forwarding]{.guihint} unter [Log
Forwarding]{.guihint} vornehmen. Zudem ist in den Regelsätzen, die Sie
als Teil von [Rule packs]{.guihint} definieren, immer das individuelle
[Setzen von Status und Service-Level](#outcome) möglich.
:::
::::
::::::::::::::::::::::
:::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#eventsgostate .hidden-anchor .sr-only}9. Event-Status im aktiven Monitoring sehen {#heading_eventsgostate}

:::::::::::::::::::::: sectionbody
::: paragraph
Wenn Sie auch im aktiven Monitoring sehen möchten, zu welchen Hosts
aktuell problematische Events offen sind, können Sie pro Host einen
[aktiven Check](glossar.html#active_check) hinzufügen lassen, welcher
dessen aktuellen Event-Status zusammenfasst. Bei einem Host ohne offene
Events sieht das dann so aus:
:::

:::: imageblock
::: content
![ec events check none](../images/ec_events_check_none.png)
:::
::::

::: paragraph
Sind nur Events im Zustand [OK]{.state0} vorhanden, so zeigt der Check
deren Anzahl, bleibt aber immer noch grün:
:::

:::: imageblock
::: content
![ec events check ok](../images/ec_events_check_ok.png)
:::
::::

::: paragraph
Hier ist ein Fall mit offenen Events im Zustand [CRIT]{.state2}:
:::

:::: imageblock
::: content
![ec events check crit](../images/ec_events_check_crit.png)
:::
::::

::: paragraph
Diesen aktiven Check erzeugen Sie durch eine Regel im Regelsatz [Check
event state in Event Console.]{.guihint} Dabei können Sie auch angeben,
ob bereits quittierte Events noch zum Status beitragen sollen oder
nicht:
:::

:::: imageblock
::: content
![ec check remote](../images/ec_check_remote.png)
:::
::::

::: paragraph
Über die Option [Application (regular expression)]{.guihint} können Sie
den Check auf solche Events einschränken, die einen bestimmten Text im
Anwendungsfeld haben. In diesem Fall kann es dann Sinn machen, mehr als
einen Events-Check auf einem Host zu haben und die Checks nach
Anwendungen zu trennen. Damit sich diese Services vom Namen
unterscheiden, benötigen Sie dabei dann noch die Option [Item (used in
service description)]{.guihint}, welche einen von Ihnen festgelegten
Text in den Namen des Services einbaut.
:::

::: paragraph
Falls Ihre Event Console nicht auf der gleichen Checkmk Instanz läuft,
von der auch der Host überwacht wird, brauchen Sie unter [Access to
Event Console]{.guihint} einen Remote-Zugriff per TCP:
:::

:::: imageblock
::: content
![ec events check](../images/ec_events_check.png)
:::
::::

::: paragraph
Damit dies funktioniert, muss die Event Console den Zugriff per TCP
erlauben. Dies können Sie in den [Einstellungen der Event
Console](#globalsettings) konfigurieren, auf die zugegriffen werden
soll:
:::

:::: imageblock
::: content
![ec remote access](../images/ec_remote_access.png)
:::
::::
::::::::::::::::::::::
:::::::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#archive .hidden-anchor .sr-only}10. Das Archiv {#heading_archive}

:::::::::::::::::::::::: sectionbody
:::::::::: sect2
### []{#_funktionsweise .hidden-anchor .sr-only}10.1. Funktionsweise {#heading__funktionsweise}

::: paragraph
Die Event Console führt ein Protokoll von allen Änderungen, die ein
Event durchläuft. Dieses finden Sie über zwei Wege:
:::

::: ulist
- In der globalen Ansicht [Recent event history]{.guihint}, die Sie in
  [Monitor \> Event Console]{.guihint} finden.

- Bei den Details eines Events mit dem Menüeintrag [Event Console Event
  \> History of Event]{.guihint}.
:::

::: paragraph
In der globalen Ansicht greift ein Filter, der nur die Ereignisse der
letzten 24 Stunden zeigt. Sie können die Filter aber wie gewohnt
anpassen.
:::

::: paragraph
Folgende Abbildung zeigt die Historie von Event 33, welches insgesamt
vier Änderungen erfahren hat. Zuerst wurde das Event erzeugt (`NEW`),
dann der Zustand manuell von [OK]{.state0} auf [WARN]{.state1} geändert
(`CHANGESTATE`), dann wurde quittiert und ein Kommentar hinzugefügt
(`UPDATE`) und schließlich archiviert/gelöscht (`DELETE`):
:::

:::: imageblock
::: content
![ec history](../images/ec_history.png)
:::
::::

::: paragraph
Es gibt im Archiv folgende Aktionstypen, die in der Spalte
[Action]{.guihint} angezeigt werden:
:::

+-------------+--------------------------------------------------------+
| Aktionstyp  | Bedeutung                                              |
+=============+========================================================+
| `NEW`       | Das Event wurde neu erzeugt (aufgrund einer Meldung    |
|             | oder aufgrund einer Regel, welche eine Meldung         |
|             | erwartet, die ausgeblieben ist).                       |
+-------------+--------------------------------------------------------+
| `UPDATE`    | Das Event wurde durch den Operator editiert (Änderung  |
|             | an Kommentar, Kontaktinformation, Quittierung).        |
+-------------+--------------------------------------------------------+
| `DELETE`    | Das Event wurde archiviert.                            |
+-------------+--------------------------------------------------------+
| `CANCELLED` | Das Event wurde durch eine OK-Meldung automatisch      |
|             | [aufgehoben](#canceling).                              |
+-------------+--------------------------------------------------------+
| `C          | Der Zustand des Events wurde durch den Operator        |
| HANGESTATE` | geändert.                                              |
+-------------+--------------------------------------------------------+
| `ARCHIVED`  | Das Event wurde automatisch archiviert, da keine Regel |
|             | gegriffen hat und in den globalen Einstellungen [Force |
|             | message archiving]{.guihint} aktiviert war.            |
+-------------+--------------------------------------------------------+
| `ORPHANED`  | Das Event wurde automatisch archiviert, da, während es |
|             | in der Phase [counting]{.guihint} war, die zugehörige  |
|             | Regel gelöscht wurde.                                  |
+-------------+--------------------------------------------------------+
| `CO         | Das Event wurde von [counting]{.guihint} nach          |
| UNTREACHED` | [open]{.guihint} gesetzt, weil die konfigurierte       |
|             | Anzahl von Meldungen erreicht wurde.                   |
+-------------+--------------------------------------------------------+
| `C          | Das Event wurde automatisch archiviert, da in der      |
| OUNTFAILED` | Phase [counting]{.guihint} die erforderliche Anzahl    |
|             | von Meldungen nicht erreicht wurde.                    |
+-------------+--------------------------------------------------------+
| `NOCOUNT`   | Das Event wurde automatisch archiviert, da, während es |
|             | in der Phase [counting]{.guihint} war, die zugehörige  |
|             | Regel so umgestellt wurde, dass sie nicht mehr zählt.  |
+-------------+--------------------------------------------------------+
| `DELAYOVER` | Das Event wurde geöffnet, da die in der Regel          |
|             | konfigurierte [Verzögerung](#timing) abgelaufen ist.   |
+-------------+--------------------------------------------------------+
| `EXPIRED`   | Das Event wurde automatisch archiviert, da seine       |
|             | konfigurierte [Lebenszeit](#timing) abgelaufen ist.    |
+-------------+--------------------------------------------------------+
| `EMAIL`     | Eine E-Mail wurde versendet.                           |
+-------------+--------------------------------------------------------+
| `SCRIPT`    | Eine automatische Aktion (Skript) wurde ausgeführt.    |
+-------------+--------------------------------------------------------+
| `           | Das Event wurde direkt nach dem Öffnen sofort          |
| AUTODELETE` | automatisch archiviert, da dies in der entsprechenden  |
|             | Regel so konfiguriert war.                             |
+-------------+--------------------------------------------------------+
::::::::::

:::::::::: sect2
### []{#_speicherort_des_archivs .hidden-anchor .sr-only}10.2. Speicherort des Archivs {#heading__speicherort_des_archivs}

::: paragraph
Wie eingangs erwähnt, ist die Event Console nicht als vollwertiges
Syslog-Archiv konzipiert. Um die Implementierung und vor allem die
Administration so einfach wie möglich zu halten, wurde auf ein
Datenbank-Backend verzichtet. Anstelle dessen wird das Archiv in simple
Textdateien geschrieben. Jeder Eintrag besteht aus einer Zeile Text,
welche durch Tabulatoren getrennte Spalten enthält. Sie finden die
Dateien in `~/var/mkeventd/history`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll var/mkeventd/history/
total 1328
-rw-rw-r-- 1 stable stable     131 Dez  4 23:59 1480633200.log
-rw-rw-r-- 1 stable stable 1123368 Dez  5 23:39 1480892400.log
-rw-rw-r-- 1 stable stable  219812 Dez  6 09:46 1480978800.log
```
:::
::::

::: paragraph
Per Default wird jeden Tag automatisch eine neue Datei begonnen. In den
[Einstellungen der Event Console](#globalsettings) können Sie die
Rotation anpassen. Die Einstellung [Event history logfile
rotation]{.guihint} ermöglicht das Umstellen auf eine wöchentliche
Rotation.
:::

::: paragraph
Die Namen der Dateien entsprechen dem Unix-Zeitstempel vom Zeitpunkt der
Erzeugung der Datei (Sekunden seit dem 1.1.1970 UTC).
:::

::: paragraph
Die Dateien werden 365 Tage aufbewahrt, sofern Sie das nicht in der
Einstellung [Event history lifetime]{.guihint} umstellen. Zudem werden
die Dateien auch vom zentralen Plattenplatzmanagement von Checkmk
erfasst, welches Sie in den globalen Einstellungen unter [Site
management]{.guihint} konfigurieren können. Dabei gilt die jeweils
*kürzere* eingestellte Frist. Das globale Management hat den Vorteil,
dass es automatisch bei Knappheit von Plattenplatz alle historischen
Daten von Checkmk **gleichmäßig** beginnend mit den ältesten löschen
kann.
:::

::: paragraph
Wenn Sie in Platzprobleme laufen sollten, können Sie die Dateien in dem
Verzeichnis auch einfach von Hand löschen oder auslagern. Legen Sie
jedoch keine gezippten oder irgendwelche anderen Dateien in diesem
Verzeichnis ab.
:::
::::::::::

::::::: sect2
### []{#_automatisches_archivieren .hidden-anchor .sr-only}10.3. Automatisches Archivieren {#heading__automatisches_archivieren}

::: paragraph
Trotz der Limitierung durch die Textdateien ist es theoretisch möglich,
in der Event Console sehr viele Meldungen zu archivieren. Das Schreiben
in die Textdateien des Archivs ist sehr performant --- allerdings auf
Kosten einer späteren Recherche. Da die Dateien als einzigen Index den
Anfragezeitraum haben, müssen bei jeder Anfrage alle relevanten Dateien
komplett gelesen und durchsucht werden.
:::

::: paragraph
Normalerweise wird die EC nur solche Meldungen ins Archiv schreiben, für
die auch wirklich ein Event geöffnet wird. Sie können das auf zwei
verschieden Arten auf *alle* Events ausweiten:
:::

::: {.olist .arabic}
1.  Sie erzeugen eine Regel, die auf alle (weiteren) Events matcht und
    aktiveren in [Outcome & actions]{.guihint} die Option [Delete event
    immediately after the actions]{.guihint}.

2.  Sie aktivieren in den Einstellungen der Event Console den Schalter
    [Force message archiving]{.guihint}.
:::

::: paragraph
Letzterer sorgt dafür, dass Meldungen, auf die keine Regel greift,
trotzdem ins Archiv wandern (Aktionstyp `ARCHIVED`).
:::
:::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#tuning .hidden-anchor .sr-only}11. Performance und Tuning {#heading_tuning}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::::: sect2
### []{#_verarbeitung_von_meldungen .hidden-anchor .sr-only}11.1. Verarbeitung von Meldungen {#heading__verarbeitung_von_meldungen}

::: paragraph
Auch in Zeiten, da Server 64 Kerne und 2 TB Hauptspeicher haben, spielt
Performance von Software noch eine Rolle. Speziell bei der Verarbeitung
von Events kommt hinzu, dass bei nicht ausreichender Leistung bei der
Verarbeitung im Extremfall eingehende Meldungen verloren gehen können.
:::

::: paragraph
Der Grund ist, dass keines der verwendeten Protokolle (Syslog,
SNMP-Traps, etc.) eine Flusskontrolle vorsieht. Wenn tausende Hosts
gleichzeitig im Sekundentakt munter drauf los senden, dann hat der
Empfänger keinerlei Chance, diese auszubremsen.
:::

::: paragraph
Deswegen ist es in etwas größeren Umgebungen wichtig, dass Sie ein Auge
darauf haben, wie lang die Verarbeitungszeit für eine Meldung ist. Dies
hängt natürlich ganz wesentlich davon ab, wie viele Regeln Sie definiert
haben und wie diese aufgebaut sind.
:::

::::::::::: sect3
#### []{#ecperformance .hidden-anchor .sr-only}Messen der Performance {#heading_ecperformance}

::: paragraph
Zum Messen Ihrer Performance gibt es ein eigenes Snapin für die
[Seitenleiste](user_interface.html#sidebar) mit dem Namen [Event Console
Performance]{.guihint}. Dieses können Sie wie gewohnt mit [![button
sidebar add
snapin](../images/icons/button_sidebar_add_snapin.png)]{.image-inline}
einbinden:
:::

:::: imageblock
::: content
![ec performance](../images/ec_performance.png){width="400"}
:::
::::

::: paragraph
Die hier dargestellten Werte sind Mittelwerte über etwa die letzte
Minute. Einen Event-Sturm, der nur ein paar Sekunden dauert, können Sie
hier also nicht direkt ablesen, aber dadurch sind die Zahlen etwas
geglättet und daher besser zu lesen.
:::

::: paragraph
Um die maximale Performance zu testen, können Sie künstlich einen Sturm
von unklassifizierten Meldungen erzeugen (bitte nur im Testsystem!),
indem Sie z.B. in einer Shell-Schleife fortwährend den Inhalt einer
Textdatei in die Events Pipe schreiben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ while true ; do cat /etc/services > tmp/run/mkeventd/events ; done
```
:::
::::

::: paragraph
Die wichtigsten Messwerte aus dem Snapin haben folgende Bedeutung:
:::

+--------------------+-------------------------------------------------+
| Wert               | Bedeutung                                       |
+====================+=================================================+
| [Received          | Anzahl der aktuell pro Sekunde eingehenden      |
| m                  | Meldungen.                                      |
| essages]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
| [Rule              | Anzahl der Regeln, die ausprobiert werden. Dies |
| tries]{.guihint}   | liefert wertvolle Informationen über die        |
|                    | Effizienz der Regelkette --- vor allem zusammen |
|                    | mit dem nächsten Parameter.                     |
+--------------------+-------------------------------------------------+
| [Rule              | Anzahl der Regeln, die aktuell pro Sekunde      |
| hits]{.guihint}    | *greifen*. Dies können auch Regeln sein, die    |
|                    | Meldungen verwerfen oder einfach nur zählen.    |
|                    | Daher resultiert nicht aus jedem Regeltreffer   |
|                    | auch ein Event.                                 |
+--------------------+-------------------------------------------------+
| [Rule hit          | Das Verhältnis aus [Rule tries]{.guihint} und   |
| ratio]{.guihint}   | [Rule hits]{.guihint}. Mit anderen Worten: Wie  |
|                    | viele Regeln muss die EC ausprobieren, bis      |
|                    | (endlich) eine greift. In dem Beispiel aus dem  |
|                    | Screenshot ist die Rate bedenklich klein.       |
+--------------------+-------------------------------------------------+
| [Created           | Anzahl der Events, die pro Sekunde neu erzeugt  |
| events]{.guihint}  | werden. Da die Event Console ja nur *relevante  |
|                    | Probleme* anzeigen soll (also vergleichbar mit  |
|                    | Host- und Service-Problemen aus dem             |
|                    | Monitoring), wäre in der Praxis die Zahl        |
|                    | `0.73/s` aus der Abbildung natürlich zu hoch!   |
+--------------------+-------------------------------------------------+
| [Processing time   | Hier können Sie ablesen, wie viel Zeit denn nun |
| per                | die Verarbeitung einer Meldung gedauert hat.    |
| message]{.guihint} | Vorsicht: Im allgemeinen ist dies **nicht** der |
|                    | Kehrwert zu [Received messages]{.guihint}. Denn |
|                    | dabei fehlen ja noch die Zeiten, in denen die   |
|                    | Event Console gar nichts zu tun hatte, weil     |
|                    | gerade keine Meldungen eingingen. Hier wird     |
|                    | wirklich die reine real vergangene Zeit         |
|                    | zwischen dem Eintreffen einer Meldung und dem   |
|                    | endgültigen Abschluss der Verarbeitung          |
|                    | gemessen. Sie können darin in etwa ablesen, wie |
|                    | viele Meldungen die EC pro Zeit maximal         |
|                    | schaffen *kann*. Beachten Sie auch, dass es     |
|                    | sich hier nicht um *CPU-Zeit* handelt, sondern  |
|                    | um *reale* Zeit. Bei einem System mit genügend  |
|                    | freien CPUs sind diese Zeiten etwa gleich.      |
|                    | Sobald aber das System so unter Last ist, dass  |
|                    | nicht alle Prozesse immer eine CPU bekommen,    |
|                    | kann die reale Zeit deutlich höher werden.      |
+--------------------+-------------------------------------------------+
:::::::::::

::::::::::::: sect3
#### []{#_tipps_für_das_tuning .hidden-anchor .sr-only}Tipps für das Tuning {#heading__tipps_für_das_tuning}

::: paragraph
Wie viele Meldungen die Event Console pro Sekunde verarbeiten kann,
können Sie in etwa an der [Processing time per message]{.guihint}
ablesen. Generell hängt diese Zeit damit zusammen, wie viele Regeln
probiert werden müssen, bis eine Meldung verarbeitet wird. Sie haben
verschiedene Möglichkeiten, hier zu optimieren:
:::

::: ulist
- Regeln, die sehr viele Meldungen ausschließen, sollten möglichst weit
  am Anfang der Regelkette stehen.

- Arbeiten Sie mit [Regelpaketen](#rulepacks), um Sätze von verwandten
  Regeln zusammenzufassen. Die erste Regel in jedem Paket sollte das
  Paket sofort verlassen, wenn die gemeinsame Grundbedingung nicht
  erfüllt ist.
:::

::: paragraph
Weiterhin gibt es in der EC eine Optimierung, die auf der
[Syslog-Priorität und -Facility](#syslogfacility) basiert. Dazu wird für
jede Kombination von Priorität und Facility intern eine eigene
Regelkette gebildet, in die jeweils nur solche Regeln aufgenommen
werden, die für Meldungen dieser Kombination relevant sind.
:::

::: paragraph
Jede Regel, die eine Bedingung auf die Priorität, die Facility oder am
besten auf beides enthält, kommt dann nicht mehr in alle diese
Regelketten, sondern optimalerweise nur in eine einzige. Das bedeutet,
dass diese Regel bei Meldungen mit einer anderen Syslog-Klassifizierung
gar nicht überprüft werden muss.
:::

::: paragraph
Im `~/var/log/mkeventd.log` sehen Sie nach einem Neustart eine Übersicht
der optimierten Regelketten:
:::

::::: listingblock
::: title
var/log/mkeventd.log
:::

::: content
``` {.pygments .highlight}
[8488808306.233330]  kern        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233343]  user        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233355]  mail        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233367]  daemon      : emerg(120) alert(89) crit(89) err(89) warning(89) notice(89) info(89) debug(89)
[8488808306.233378]  auth        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233389]  syslog      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233408]  lpr         : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233482]  news        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233424]  uucp        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233435]  cron        : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233446]  authpriv    : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233457]  ftp         : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233469]  (unused 12) : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233480]  (unused 13) : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233498]  (unused 13) : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233502]  (unused 14) : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233589]  local0      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233538]  local1      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233542]  local2      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233552]  local3      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233563]  local4      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233574]  local5      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233585]  local6      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233595]  local7      : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
[8488808306.233654]  snmptrap    : emerg(112) alert(67) crit(67) err(67) warning(67) notice(67) info(67) debug(67)
```
:::
:::::

::: paragraph
In obigem Beispiel sehen Sie, dass es 67 Regeln gibt, die in jedem Fall
geprüft werden müssen. Bei Meldungen der Facility `daemon` sind 89
Regeln relevant, nur bei der Kombination `daemon`/`emerg` müssen 120
Regeln geprüft werden. Jede Regel, die eine Bedingung auf Priorität oder
Facility bekommt, reduziert die Anzahl von 67 weiter.
:::

::: paragraph
Natürlich können Sie diese Bedingungen nur dann setzen, wenn Sie sicher
sind, dass sie von den relevanten Meldungen auch erfüllt werden!
:::
:::::::::::::
::::::::::::::::::::::::::

:::::::::::::::::::::::: sect2
### []{#_anzahl_aktueller_events .hidden-anchor .sr-only}11.2. Anzahl aktueller Events {#heading__anzahl_aktueller_events}

::: paragraph
Auch die Anzahl der aktuell vorhandenen Events kann die Performance der
EC beeinflussen --- und zwar, wenn diese deutlich aus dem Ruder läuft.
Wie bereits erwähnt, sollte die EC nicht als Ersatz für ein
Syslog-Archiv gesehen werden, sondern lediglich „aktuelle Probleme"
anzeigen. Die Event Console kann zwar durchaus mit mehreren tausend
Problemen umgehen, aber der eigentliche Sinn ist das nicht.
:::

::: paragraph
Sobald die Anzahl der aktuellen Events etwa 5 000 übersteigt, beginnt
die Performance spürbar schlechter zu werden. Das zeigt sich zum einen
in der GUI, die langsamer auf Anfragen reagiert. Zum anderen wird auch
die Verarbeitung langsamer, da in manchen Situationen Meldungen mit
allen aktuellen Events verglichen werden müssen. Auch der Speicherbedarf
kann problematisch werden.
:::

::: paragraph
Die Event Console hält aus Gründen der Performance alle aktuellen Events
stets im RAM. Diese werden einmal pro Minute (einstellbar) und beim
sauberen Beenden in die Datei `~/var/mkeventd/status` geschrieben. Wenn
diese sehr groß wird (z.B. über 50 Megabytes), wird dieser Vorgang
ebenfalls immer langsamer. Die aktuelle Größe können Sie schnell mit
`ll` abfragen (Alias für `ls -alF`):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll -h var/mkeventd/status
-rw-r--r-- 1 mysite mysite 386K Dez 14 13:46 var/mkeventd/status
```
:::
::::

::: paragraph
Sollten Sie aufgrund einer ungeschickten Regel (z.B. einer, die auf
alles matcht) viel zu viele aktuelle Events haben, ist ein manuelles
Löschen über die GUI kaum noch sinnvoll zu schaffen. In diesem Fall
hilft einfach ein Löschen der Statusdatei:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd stop mkeventd
Stopping mkeventd...killing 17436......OK
OMD[mysite]:~$ rm var/mkeventd/status
OMD[mysite]:~$ omd start mkeventd
Starting mkeventd (builtin: syslog-udp)...OK
```
:::
::::

::: paragraph
**Achtung:** Natürlich gehen dabei *alle* aktuellen Events verloren
sowie die gespeicherten Zählerstände und andere Zustände. Insbesondere
beginnen neue Events dann wieder mit der ID 1.
:::

:::::::::::::: sect3
#### []{#overflow .hidden-anchor .sr-only}Automatischer Überlaufschutz {#heading_overflow}

::: paragraph
Die Event Console besitzt einen automatischen Schutz vor einem
„Überlaufen". Dieser limitiert die Anzahl von aktuellen Events pro Host,
pro Regel und global. Dabei werden nicht nur offene Events gezählt,
sondern auch solche in anderen Phasen, wie z.B. [delayed]{.guihint} oder
[counting]{.guihint}. Archivierte Events werden nicht gezählt.
:::

::: paragraph
Dies schützt Sie in Situationen, in denen aufgrund eines systematischen
Problems in Ihrem Netzwerk Tausende von kritischen Events hereinströmen
und die Event Console „dicht" machen würde. Zum einen verhindert das
Performance-Einbrüche der Event Console, die zu viele Events im
Hauptspeicher halten müsste. Zum anderen bleibt so die Übersicht für den
Operator (einigermaßen) bewahrt und Events, die nicht Teil des Sturms
sind, bleiben sichtbar.
:::

::: paragraph
Sobald ein Limit erreicht ist, geschieht eine der folgenden Aktionen:
:::

::: ulist
- Das Erzeugen neuer Events wird gestoppt (für diesen Host, diese Regel
  bzw. global).

- Das Gleiche, aber zusätzlich wird ein „Overflow Event" erzeugt.

- Das Gleiche, aber zusätzlich werden passende Kontaktpersonen
  benachrichtigt.

- Alternativ zu obigen drei Varianten können Sie auch das jeweils
  älteste Event löschen lassen, um Platz für das Neue zu machen.
:::

::: paragraph
Die Limits sowie die verknüpfte Auswirkung beim Erreichen stellen Sie in
den [Einstellungen der Event Console](#globalsettings) mit [Limit amount
of current events]{.guihint} ein. Folgende Abbildung zeigt die
Voreinstellung:
:::

:::: imageblock
::: content
![ec limit open events](../images/ec_limit_open_events.png)
:::
::::

::: paragraph
Falls Sie einen Wert mit [...​create overflow event]{.guihint} aktiviert
haben, wird beim Erreichen des Limits *ein* künstliches Event erzeugt,
das den Operator von der Fehlersituation in Kenntnis setzt:
:::

:::: imageblock
::: content
![ec overflow event](../images/ec_overflow_event.png)
:::
::::

::: paragraph
Falls Sie zusätzlich einen Wert mit [...​notify contacts]{.guihint}
aktiviert haben, werden passende Kontaktpersonen per Checkmk
Benachrichtigung informiert. Die Benachrichtigung durchläuft die
[Benachrichtigungsregeln](notifications.html#rules) von Checkmk. Diese
Regeln müssen sich nicht unbedingt an die Kontaktauswahl der Event
Console halten, sondern können diese modifizieren. Folgende Tabelle
zeigt, welche Kontakte ausgewählt werden, falls Sie [Notify all contacts
of the notified host or service]{.guihint} eingestellt haben (was der
Default ist):
:::

+---------+------------------------------------------------------------+
| Limit   | Kontaktauswahl                                             |
+=========+============================================================+
| pro     | Die Kontakte zum Host, welche genauso ermittelt werden,    |
| Host    | wie bei der [Benachrichtigung von Events](#notifications)  |
|         | über Checkmk.                                              |
+---------+------------------------------------------------------------+
| pro     | Hier wird das Feld für den Host-Namen leer gelassen. Falls |
| Regel   | in der Regel Kontaktgruppen definiert sind, werden diese   |
|         | ausgewählt, ansonsten die Fallback-Kontakte.               |
+---------+------------------------------------------------------------+
| Global  | Die Fallback-Kontakte.                                     |
+---------+------------------------------------------------------------+
::::::::::::::
::::::::::::::::::::::::

:::::::: sect2
### []{#_zu_großes_archiv .hidden-anchor .sr-only}11.3. Zu großes Archiv {#heading__zu_großes_archiv}

::: paragraph
Wie [oben](#archive) gezeigt, hat die Event Console ein Archiv von allen
Events und deren Verarbeitungsschritten. Dieses ist aus Gründen der
einfachen Implementierung und Administration in Textdateien abgelegt.
:::

::: paragraph
Textdateien sind beim *Schreiben* von Daten in der Performance schwer zu
übertreffen --- von Datenbanken beispielsweise nur mit enormem
Optimierungsaufwand. Das liegt unter anderem an der Optimierung dieser
Zugriffsart durch Linux und der kompletten Speicherhierarchie von
Platten und SANs. Dies geht allerdings zulasten der Lesezugriffe. Da
Textdateien über keinen Index verfügen, ist für das Suchen in den
Dateien ein komplettes Einlesen notwendig.
:::

::: paragraph
Die Event Console verwendet als Index für die *Zeit* der Ereignisse
zumindest die Dateinamen der Log-Dateien. Je weiter Sie den
Anfragezeitraum eingrenzen, desto schneller geht also die Suche.
:::

::: paragraph
Sehr wichtig ist trotzdem, dass Ihr Archiv nicht zu groß wird. Wenn Sie
die Event Console nur dazu verwenden, wirkliche Fehlermeldungen zu
verarbeiten, kann das eigentlich nicht passieren. Sollten Sie versuchen,
die EC als Ersatz für ein echtes Syslog-Archiv einzusetzen, kann dies
allerdings zu sehr großen Dateien führen.
:::

::: paragraph
Wenn Sie in eine Situation geraten, in der Ihr Archiv zu groß geworden
ist, können Sie einfach ältere Dateien in `~/var/mkeventd/history/`
löschen. Auch können Sie in [Event history lifetime]{.guihint} die
Lebenszeit der Daten generell begrenzen, so dass das Löschen in Zukunft
voreingestellt ist. Per Default wird 365 Tage gespeichert. Vielleicht
kommen Sie ja mit deutlich weniger aus.
:::
::::::::

::::::::::::::::: sect2
### []{#_performance_über_die_zeit_messen .hidden-anchor .sr-only}11.4. Performance über die Zeit messen {#heading__performance_über_die_zeit_messen}

::: paragraph
Checkmk startet automatisch für jede laufende Instanz der Event Console
einen Service, der die Leistungsdaten in Kurven aufzeichnet und Sie auch
warnt, wenn es zu [Überläufen](#overflow) kommt.
:::

::: paragraph
Sofern Sie auf dem Monitoring-Server einen Linux-Agenten installiert
haben, wird der Check wie gewohnt automatisch gefunden und eingerichtet:
:::

:::: imageblock
::: content
![ec check](../images/ec_check.png)
:::
::::

::: paragraph
Der Check bringt sehr viele interessante Messarten mit, z.B. die Anzahl
der eingehenden Meldungen pro Zeit und wie viele davon verworfen wurden:
:::

:::: imageblock
::: content
![ec graph message rate](../images/ec_graph_message_rate.png)
:::
::::

::: paragraph
Die Effizienz Ihrer Regelkette wird dargestellt durch einen Vergleich
von ausprobierten Regeln zu solchen, die gegriffen haben:
:::

:::: imageblock
::: content
![ec graph rule efficiency](../images/ec_graph_rule_efficiency.png)
:::
::::

::: paragraph
Dieser Graph zeigt die durchschnittliche Zeit für die Verarbeitung einer
Meldung:
:::

:::: imageblock
::: content
![ec graph processing time](../images/ec_graph_processing_time.png)
:::
::::

::: paragraph
Daneben gibt es noch etliche weitere Diagramme.
:::
:::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::: sect1
## []{#_verteiltes_monitoring .hidden-anchor .sr-only}12. Verteiltes Monitoring {#heading__verteiltes_monitoring}

:::: sectionbody
::: paragraph
Wie Sie die Event Console in einer Installation mit mehreren Checkmk
Instanzen einsetzen, erfahren Sie im [Artikel über das verteilte
Monitoring](distributed_monitoring.html#ec).
:::
::::
:::::

:::::::::::: sect1
## []{#statusinterface .hidden-anchor .sr-only}13. Die Statusschnittstelle {#heading_statusinterface}

::::::::::: sectionbody
::: paragraph
Die Event Console bietet über das Unix-Socket
`~/tmp/run/mkeventd/status` sowohl Zugriff auf den internen Status als
auch die Möglichkeit, Kommandos auszuführen. Das hier verwendete
Protokoll ist eine stark eingeschränkte Teilmenge von
[Livestatus](glossar.html#livestatus). Auf diese Schnittstelle greift
der Monitoring-Kern zu und reicht die Daten an die GUI durch, um so ein
[verteiltes Monitoring](distributed_monitoring.html) auch für die Event
Console zu ermöglichen.
:::

::: paragraph
Für den vereinfachten Livestatus der Event Console gelten folgende
Einschränkungen:
:::

::: ulist
- Die einzigen erlaubten Header sind `Filter:` und `OutputFormat:`.

- Daher ist kein KeepAlive möglich, pro Verbindung ist nur eine Anfrage
  durchführbar.
:::

::: paragraph
Folgende Tabellen sind verfügbar:
:::

+-------------+--------------------------------------------------------+
| `events`    | Liste aller aktuellen Events.                          |
+-------------+--------------------------------------------------------+
| `history`   | Zugriff auf das [Archiv](#archive). Eine Anfrage auf   |
|             | diese Tabelle führt zum Zugriff auf die Textdateien    |
|             | des Archivs. Verwenden Sie auf jeden Fall einen Filter |
|             | über die Zeit des Eintrags, um einen Vollzugriff auf   |
|             | alle Dateien zu vermeiden.                             |
+-------------+--------------------------------------------------------+
| `status`    | Status- und Performancewerte der EC. Diese Tabelle hat |
|             | immer genau eine Zeile.                                |
+-------------+--------------------------------------------------------+

::: paragraph
Kommandos können Sie mithilfe von `unixcat` mit einer sehr einfachen
Syntax in das Socket schreiben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "COMMAND RELOAD" | unixcat tmp/run/mkeventd/status
```
:::
::::

::: paragraph
Folgende Kommandos sind verfügbar:
:::

+-------------+--------------------------------------------------------+
| `DELETE`    | Archiviert ein Event. Argumente: Event-ID und          |
|             | Benutzerkürzel.                                        |
+-------------+--------------------------------------------------------+
| `RELOAD`    | Neuladen der Konfiguration.                            |
+-------------+--------------------------------------------------------+
| `SHUTDOWN`  | Beendet die Event Console.                             |
+-------------+--------------------------------------------------------+
| `REOPENLOG` | Die Log-Datei wird neu geöffnet. Dieses Kommando wird  |
|             | von der Log-Dateirotation benötigt.                    |
+-------------+--------------------------------------------------------+
| `FLUSH`     | Löscht alle aktuellen und archivierten Events.         |
+-------------+--------------------------------------------------------+
| `SYNC`      | Löst ein sofortiges Aktualisieren der Datei            |
|             | `~/var/mkeventd/status` aus.                           |
+-------------+--------------------------------------------------------+
| `RES        | Setzt die Trefferzähler der Regeln zurück (entspricht  |
| ETCOUNTERS` | dem Menüeintrag [Event Console \> Reset                |
|             | counters]{.guihint} in der Setup-GUI).                 |
+-------------+--------------------------------------------------------+
| `UPDATE`    | Führt ein Update von einem Event aus. Die Argumente    |
|             | sind der Reihe nach Event-ID, Benutzerkürzel,          |
|             | Quittierung (0/1), Kommentar und Kontaktinformation.   |
+-------------+--------------------------------------------------------+
| `C          | Ändert den Status [OK]{.state0} / [WARN]{.state1} /    |
| HANGESTATE` | [CRIT]{.state2} / [UNKNOWN]{.state3} eines Events.     |
|             | Argumente sind Event-ID, Benutzerkürzel und            |
|             | Statusziffer (`0`/`1`/`2`/`3`).                        |
+-------------+--------------------------------------------------------+
| `ACTION`    | Führt eine benutzerdefinierte Aktion auf einem Event   |
|             | aus. Argumente sind Event-ID, Benutzerkürzel und       |
|             | Aktions-ID. Die spezielle ID `@NOTIFY` steht für eine  |
|             | [Benachrichtigung](#notifications) über Checkmk.       |
+-------------+--------------------------------------------------------+
:::::::::::
::::::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}14. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `var/mkeventd`                    | Arbeitsverzeichnis des Event      |
|                                   | Daemons.                          |
+-----------------------------------+-----------------------------------+
| `var/mkeventd/status`             | Kompletter aktueller Zustand der  |
|                                   | Event Console. Dies umfasst vor   |
|                                   | allem alle aktuell offenen Events |
|                                   | (und solche in Übergangsphasen    |
|                                   | wie [counting]{.guihint} etc.).   |
|                                   | Im Falle einer Fehlkonfiguration, |
|                                   | die zu sehr vielen offenen Events |
|                                   | führt, kann diese Datei riesig    |
|                                   | werden und die Performance der EC |
|                                   | drastisch reduzieren. In diesem   |
|                                   | Fall können Sie den Dienst        |
|                                   | `mkeventd` stoppen, die Datei     |
|                                   | löschen und den Dienst wieder     |
|                                   | starten, um alle offenen Events   |
|                                   | auf einmal zu löschen.            |
+-----------------------------------+-----------------------------------+
| `var/mkeventd/history/`           | Ablageort des                     |
|                                   | [Archivs](#archive).              |
+-----------------------------------+-----------------------------------+
| `var/log/mkeventd.log`            | Log-Datei der Event Console.      |
+-----------------------------------+-----------------------------------+
| `etc/ch                           | Die globalen Einstellungen der    |
| eck_mk/mkeventd.d/wato/global.mk` | Event Console in Python-Syntax.   |
+-----------------------------------+-----------------------------------+
| `etc/c                            | Ihre ganzen konfigurierten        |
| heck_mk/mkeventd.d/wato/rules.mk` | Regelpakete und Regeln in         |
|                                   | Python-Syntax.                    |
+-----------------------------------+-----------------------------------+
| `tmp/run/mkeventd/events`         | Eine Named Pipe, in die Sie mit   |
|                                   | `echo` oder anderen Befehlen      |
|                                   | direkt Meldungen schreiben        |
|                                   | können, um diese an die EC zu     |
|                                   | übergeben. Achten Sie darauf,     |
|                                   | dass zu jedem Zeitpunkt nur eine  |
|                                   | einzige Anwendung in diese Pipe   |
|                                   | schreibt, da sich die Texte der   |
|                                   | Meldungen sonst vermischen        |
|                                   | können.                           |
+-----------------------------------+-----------------------------------+
| `tmp/run/mkeventd/eventsocket`    | Ein Unix-Socket, das die gleiche  |
|                                   | Aufgabe wie die Pipe erfüllt,     |
|                                   | aber ein gleichzeitiges Schreiben |
|                                   | mehrerer Anwendungen ermöglicht.  |
|                                   | Zum Hineinschreiben benötigen Sie |
|                                   | den Befehl `unixcat` oder         |
|                                   | `socat`.                          |
+-----------------------------------+-----------------------------------+
| `tmp/run/mkeventd/pid`            | Die aktuelle Prozess-ID des Event |
|                                   | Daemons während dieser läuft.     |
+-----------------------------------+-----------------------------------+
| `tmp/run/mkeventd/status`         | Ein Unix-Socket, das die Abfrage  |
|                                   | des aktuellen Status und das      |
|                                   | Senden von Kommandos erlaubt. Die |
|                                   | Anfragen der GUI gehen zunächst   |
|                                   | zum Monitoring-Kern, der dann auf |
|                                   | diesen Socket zugreift.           |
+-----------------------------------+-----------------------------------+
| `local/share/snmp/mibs`           | Von Ihnen hochgeladene            |
|                                   | MIB-Dateien für die Übersetzung   |
|                                   | von SNMP-Traps.                   |
+-----------------------------------+-----------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
