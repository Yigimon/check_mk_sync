:::: {#header}
# Das Spool-Verzeichnis

::: details
[Last modified on 09-Oct-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/spool_directory.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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

::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
Die Überwachung regelmäßig oder bei Bedarf abgearbeiteter Aufgaben,
sowie dauerhaft laufender Prozesse kann beispielsweise durch die Analyse
von Log- oder Statusdateien erfolgen. Dies ist jedoch häufig mit Aufwand
verbunden: Oft ist es erforderlich, große Datenmengen zu lesen, um wenig
Information herauszuziehen.
:::

::: paragraph
Um diesen Aufwand zu reduzieren, bietet Checkmk die Möglichkeit, dass
ein Programm Ausgaben direkt im Checkmk-Agentenformat in eine Datei
schreibt. Im sogenannten Spool-Verzeichnis (*spool directory*) abgelegt,
sammelt der Agent diese Dateien und integriert ihren Inhalt in die
Agentenausgabe. Der Weg über das Spool-Verzeichnis bietet sich
beispielsweise an bei
:::

::: ulist
- der regelmäßigen Analyse von Log-Dateien,

- der Überwachung automatischer Backups,

- der Erstellung und Prüfung von Nutzungsstatistiken aus einer
  Datenbank,

- der Kontrolle von Cronjobs -- wenn [das
  `mk-job`-Plugin](monitoring_jobs.html) nicht genügt --,

- der [Entwicklung eigener Checks](devel_intro.html) zum Test von
  Beispielausgaben.
:::

::: paragraph
In Checkmk wird das Spool-Verzeichnis von den Agenten der folgenden
Betriebssysteme unterstützt: Windows, Linux, AIX, FreeBSD, OpenWrt und
Solaris.
:::

::: paragraph
Damit Sie dieses Feature reibungslos nutzen können, sind einige Dinge zu
beachten.
:::
::::::::
:::::::::

::::::::: sect1
## []{#paths .hidden-anchor .sr-only}2. Verzeichnispfade {#heading_paths}

:::::::: sectionbody
::: paragraph
Der Standardpfad des Spool-Verzeichnisses ist unter Linux und anderen
Unix-Systemen `/var/lib/check_mk_agent/spool/` und unter Windows
`C:\ProgramData\checkmk\agent\spool\`. Für Linux und Unix können Sie den
Pfad des übergeordneten Verzeichnisses mit der Regel [Agent rules \>
Installation paths for agent files (Linux, UNIX)]{.guihint} und der dort
vorhandenen Option [Base directory for variable data (caches, state
files)]{.guihint} anpassen.
:::

::: paragraph
Wenn Sie auf einem Host im Monitoring arbeiten, können Sie das dort
konfigurierte Spool-Verzeichnis aus der Agentenausgabe herausfiltern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ check_mk_agent | grep SpoolDirectory
SpoolDirectory: /var/lib/check_mk_agent/spool
```
:::
::::

::: paragraph
Checkmk nutzt ein einziges Spool-Verzeichnis, welches in den
Standardeinstellungen `root` gehört. Mehrere Verzeichnisse mit
unterschiedlichen Eigentümern sind nicht vorgesehen. Selbstverständlich
können Sie aber im Spool-Verzeichnis (zunächst leere) Dateien anlegen
und einen anderen Benutzer zum Eigentümer machen, der den Inhalt seiner
Datei dann überschreiben kann.
:::
::::::::
:::::::::

:::::::::::::::::: sect1
## []{#contents .hidden-anchor .sr-only}3. Dateinamen und -inhalt {#heading_contents}

::::::::::::::::: sectionbody
::: paragraph
Spool-Dateien können beliebige Textausgaben in den von Checkmk
verarbeiteten Formaten beinhalten. Sie werden in der im
Spool-Verzeichnis vorhandenen Reihenfolge aneinander gehängt. Die
verwendete Dateiendung ist dabei egal.
:::

::: paragraph
Wenn Sie ein numerisches Schema zur Sortierung verwenden wollen, stellen
Sie dem Dateinamen einen Unterstrich (`_`) voran, da mit Zahlen
beginnende Dateinamen einer [Altersprüfung](#agecheck) dienen. Dateien,
die mit einem Punkt beginnen, werden ignoriert.
:::

::: paragraph
Um Durcheinander bei den aneinander gehängten Dateiinhalten zu
vermeiden, sollte jede Spool-Datei
:::

::: ulist
- mit einem Sektions-Header beginnen, d.h. einer Zeile, die in `<<<` und
  `>>>` eingeschlossen ist --- auch wenn in der Datei nur das Format
  [lokaler Checks](glossar.html#local_check) verwendet wird,

- mit einem Zeilenumbruch beendet werden.
:::

::: paragraph
Ein lokaler Check, der sofort einen Service bereitstellt, kann demnach
so aussehen:
:::

::::: listingblock
::: title
/var/lib/check_mk_agent/spool/spooldummy.txt
:::

::: content
``` {.pygments .highlight}
<<<local>>>
0 "Spool Test Dummy" - This static service is always OK
```
:::
:::::

::: paragraph
Analog können Sie Ausgaben ablegen, die auf Checkmk-Seite ein
[Check-Plugin](glossar.html#check_plugin) erfordern:
:::

::::: listingblock
::: title
/var/lib/check_mk_agent/spool/poolplugin.txt
:::

::: content
``` {.pygments .highlight}
<<<waterlevels>>>
rainbarrel 376
pond 15212
pool 123732
```
:::
:::::

:::: sect2
### []{#piggyback .hidden-anchor .sr-only}3.1. Terminierung von Piggyback-Sektionen {#heading_piggyback}

::: paragraph
Wenn Sie in einer Datei [Piggyback](glossar.html#piggyback)-Sektionen
verwenden, schließen Sie diese Datei mit der Zeile `<<<<>>>>` ab. Nur so
ist sichergestellt, dass bei einer möglichen Änderung der
Auslesereihenfolge die der Piggyback-Ausgabe folgenden Ausgaben wieder
dem Host selbst zugeordnet werden.
:::
::::
:::::::::::::::::
::::::::::::::::::

:::::: sect1
## []{#agecheck .hidden-anchor .sr-only}4. Altersprüfung vorgefundener Dateien {#heading_agecheck}

::::: sectionbody
::: paragraph
Wenn ein Programm korrekt in seine Ausgabedatei schreiben kann, ist
alles prima --- egal, ob es erfolgreich durchgelaufen ist oder nicht.
Doch was, wenn ein Programm vor dem Schreiben auf Festplatte abbricht
oder ein Fehler am Dateisystem verhindert, dass neue Dateien geschrieben
werden?
:::

::: paragraph
Für diesen Fall haben Sie die Möglichkeit, dem Dateinamen eine Ganzzahl
vorne anzustellen, beispielsweise `600MyCronjob`. Die Zahl wird in
diesem Fall als Maximalalter der Datei in Sekunden interpretiert. Ist
die Datei älter, wird sie vom Agenten ignoriert und der zugehörige
Service in Checkmk wechselt wegen der fehlenden Ausgabe in den Zustand
[UNKNOWN]{.state3}. Im Falle einer Datei `3900_hourly_cleaner.txt` ist
die Zahl demnach passend gewählt für einen stündlich laufenden Cronjob,
bei dem eine Ausführungszeit von unter fünf Minuten erwartet wird.
:::
:::::
::::::

::::::::::::::::::: sect1
## []{#example .hidden-anchor .sr-only}5. Ein Praxisbeispiel {#heading_example}

:::::::::::::::::: sectionbody
::: paragraph
Nehmen wir an, Sie betreiben einen Dienst, an dem sich Benutzer an- und
abmelden. In den Log-Dateien des Dienstes finden Sie Zeilen der
folgenden drei Arten vor:
:::

::::: listingblock
::: title
/var/log/dummyapp.log
:::

::: content
``` {.pygments .highlight}
21/Oct/2022:12:42:09 User harrihirsch logged in from 12.34.56.78
21/Oct/2022:12:42:23 User zoezhang logged out after 10 min idle
21/Oct/2022:13:00:00 Current user count: 739
```
:::
:::::

::: paragraph
Die Zeile mit `Current user count` schreibt der Prozess dabei nicht nach
jedem Login/Logout, sondern in festen Zeitabständen. Ist die Zahl der
Zeilen in der Log-Datei klein genug, um sie schnell einzulesen, können
Sie einen [lokalen Check](localchecks.html) programmieren. Dieser liest
jedes Mal die ganze Log-Datei Zeile für Zeile und setzt immer beim
Vorkommen der Zeile `Current user count` die Benutzerzahl auf den
angezeigten Wert. Bei Vorkommen der Zeilen `logged in` und `logged out`
erhöht oder verringert er die Benutzerzahl. Am Ende gibt Ihr Check eine
Zeile ähnlich der folgenden aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
1 "Frobolator User Count" count=1023 Watch out! Limit nearly used up.
```
:::
::::

::: paragraph
Mit steigender Beliebtheit Ihres Dienstes läuft der lokale Check immer
länger, so dass irgendwann diese Lösung und selbst die Ausführung als
[asynchrones Agentenplugin](agent_linux.html#async_plugins) nicht mehr
praktikabel sind. Hier kann die richtige Nutzung des
Spool-Verzeichnisses die Effizienz der Check-Ausführung drastisch
erhöhen. In den nächsten Absätzen zeigen wir Ihnen, wie Sie das
Programm, welches bisher Ihren lokalen Check bereitstellt, so abändern,
dass es das Spool-Verzeichnis effektiv nutzt.
:::

::: paragraph
Zunächst soll es sich nicht selbst beenden, wenn es am Ende der Datei
angekommen ist, sondern eine Spool-Datei schreiben, die den aktuell
ermittelten Zustand des Dienstes bei vollständiger Auswertung der
Log-Datei enthält:
:::

::::: listingblock
::: title
/var/lib/check_mk_agent/spool/1800_frobolator.txt
:::

::: content
``` {.pygments .highlight}
<<<local>>>
2 "Frobolator User Count" count=1200 Maximum number of users reached!
```
:::
:::::

::: paragraph
Lassen Sie Ihr Programm dann eine gewisse Zeitspanne warten --- ob
wenige Sekunden oder mehrere Minuten, sollten Sie von der Frequenz neu
hinzukommender Log-Einträge abhängig machen. Es soll dann nur die neu
hinzugekommenen Zeilen auswerten, und den Zustand neu berechnen. Liegen
geänderte Zahlen vor, schreibt es die Spool-Datei neu.
:::

::: paragraph
Dieses Vorgehen programmieren Sie als Endlosschleife. Um abzufangen,
dass dieses Programm auch abstürzen kann, sollten Sie die Spool-Datei
entsprechend benennen, beispielsweise `1800_frobolator.txt` --- wenn 30
Minuten ohne Aktualisierung der Spool-Datei auf Probleme des Dienstes
oder des auswertenden Programms hindeuten.
:::

::: paragraph
Anstatt über das Plugin-Verzeichnis des Agenten starten Sie das Programm
jetzt als *Daemon* (oder *Hintergrundprogramm*) mit den Mitteln Ihres
Betriebssystems. Achten Sie hierbei auf automatischen Neustart, wenn das
Programm abstürzt oder terminiert wird. Viele Server-Applikationen
bieten zudem die Möglichkeit, statt oder zusätzlich zum Schreiben
normaler Log-Dateien, einem anderen Programm Log-Ausgaben per Pipe zu
übergeben. Diesen Mechanismus für ein Auswertungsskript zu nutzen, das
Spool-Dateien schreibt, bietet sich ebenfalls an.
:::
::::::::::::::::::
:::::::::::::::::::

::::::::::::::::::: sect1
## []{#pitfalls .hidden-anchor .sr-only}6. Zu beachtende Feinheiten {#heading_pitfalls}

:::::::::::::::::: sectionbody
::: paragraph
Das Lesen von Dateien hält andere Fallstricke bereit als das regelmäßige
Starten von Prozessen durch den Agenten. Beachten Sie die folgenden
Punkte für einen reibungslosen Betrieb.
:::

::::::: sect2
### []{#charset .hidden-anchor .sr-only}6.1. Zeichensatz {#heading_charset}

::: paragraph
Checkmk erwartet die Agentenausgabe ausschließlich
[UTF-8](https://de.wikipedia.org/wiki/UTF-8){target="_blank"} kodiert
(ohne [Byte Order Mark /
BOM](https://de.wikipedia.org/wiki/Byte_Order_Mark#In_UTF-8){target="_blank"})
mit einem einfachen Newline (`0x0A` oder `\n`) als Zeilenumbruch.
Abweichungen können schlimmstenfalls dazu führen, dass die
Agentenausgabe ab dem ersten Zeichen einer falsch formatierten
Spool-Datei nicht mehr gelesen werden kann. Konkret bedeutet dies:
:::

::: ulist
- Sorgen Sie insbesondere auf *älteren* Windows- und Linux-Systemen
  dafür, dass Spool-Dateien *nicht* in der Kodierung [Windows 1250 bis
  1258](https://de.wikipedia.org/wiki/Windows-1250){target="_blank"}
  oder [ISO
  8859](https://de.wikipedia.org/wiki/ISO_8859){target="_blank"}
  geschrieben werden. Sollte es dennoch nötig sein, stellen Sie sicher,
  dass nur die Schnittmenge zu UTF-8 -- de facto
  [7-Bit-ASCII](https://de.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange){target="_blank"}
  -- verwendet wird.

- Sorgen Sie insbesondere auf *neueren* Windows-Systemen dafür, dass
  Spool-Dateien *nicht* in der dort als Standard genutzten Kodierung
  [UTF-16](https://de.wikipedia.org/wiki/UTF-16){target="_blank"}
  geschrieben werden.

- Verzichten Sie auf das
  [BOM.](https://de.wikipedia.org/wiki/Byte_Order_Mark){target="_blank"}
  Insbesondere Skriptsprachen unter Windows schreiben häufig diese
  Zeichensequenz, welche die verwendete Kodierung anzeigt, automatisch
  in Ausgabedateien. In der Agentenausgabe verhindert sie, dass `<<<` am
  Anfang einer Zeile stehen.

- Verwenden Sie den Unix-Zeilenumbruch Newline (`0x0A` oder `\n`). Auch
  hier nutzt Windows häufig die Zeichenfolge `CRLF` (`0x0D 0x0A` oder
  `\r\n`).
:::

::: paragraph
Sollte eine Spool-Datei unerwünschtes Verhalten verursachen, untersuchen
Sie deren erste Zeilen mit einem
[Hex-Editor](https://de.wikipedia.org/wiki/Hex-Editor){target="_blank"}:
:::

::: ulist
- `0xFF 0xFE` zeigt eine UTF-16 kodierte Datei an: Ändern Sie in diesem
  Fall Ihre Skripte auf Ausgabe in UTF-8.

- `0xEF 0xBB 0xBF` zeigt UTF-8 mit BOM an. Hier genügt es in der Regel,
  die Datei künftig ohne BOM zu schreiben.
:::
:::::::

::::: sect2
### []{#softlinks .hidden-anchor .sr-only}6.2. Softlinks und benannte Pipes {#heading_softlinks}

::: paragraph
Im Prinzip können Dateien im Spool-Verzeichnis auch Softlinks oder
benannte Pipes (*named pipes*) sein. Zu beachten ist, dass hier die
Altersprüfung über Dateinamen nicht funktioniert, weil das Alter des
Softlinks oder der benannten Pipe selbst ausgewertet wird und nicht das
Alter der geschriebenen Daten. Bei benannten Pipes müssen Sie zudem
sicherstellen, dass der in die Pipe schreibende Prozess immer Daten
nachliefert. Werden keine Daten geliefert, wartet der Checkmk-Agent ewig
und wird schließlich mit Timeout abgebrochen.
:::

::: paragraph
Falls Sie nicht unprivilegierten Benutzern die Möglichkeit geben müssen,
in Spool-Dateien zu schreiben, legen Sie leere Dateien für diese
Benutzer an, deren Eigentümerschaft Sie entsprechend setzen. Diese
Benutzer können dann von sich aus einen Softlink setzen oder direkt in
die Spool-Datei schreiben.
:::
:::::

::::: sect2
### []{#locking .hidden-anchor .sr-only}6.3. Sperren und Puffern {#heading_locking}

::: paragraph
Beim Schreiben längerer Programme, die mehrere Statuszeilen in eine
Spool-Datei schreiben, ist die Versuchung groß, die Ausgabedatei beim
Start des Programms schreibend zu öffnen. Die Datei bleibt in diesem
Fall aber komplett leer, bis der Schreibpuffer das erste Mal geleert und
ins Ziel geschrieben wird, und sie wird unvollständig sein, bis das
schreibende Programm die Datei geschlossen hat. Ähnlich sieht es aus,
wenn eine Datei für die Dauer eines längeren Schreibvorgangs exklusiv
gesperrt ist.
:::

::: paragraph
Aus diesem Grund sollten Sie entweder die Ausgabedatei erst schreibend
öffnen, wenn der gesamte zu schreibende Inhalt vorliegt, oder in eine
temporäre Datei schreiben, die Sie dann ins Spool-Verzeichnis
kopieren --- respektive den Inhalt einer temporären Datei mit `cat` in
eine vorhandene im Spool-Verzeichnis übertragen.
:::
:::::

::::: sect2
### []{#losingcontrol .hidden-anchor .sr-only}6.4. Den Überblick behalten {#heading_losingcontrol}

::: paragraph
Ein weiteres Problem kann auftreten, wenn verschiedene Programme
versuchen, in gleichnamige Dateien zu schreiben. Bei vielen
Spool-Dateien kann leicht der Überblick verloren gehen, welches Programm
eigentlich in welche Spool-Datei schreibt. Insbesondere, wenn eine
falsch formatierte Spool-Datei zur Folge hat, dass ein Teil der
Agentenausgabe unbrauchbar wird, ist dies sehr ärgerlich und kann eine
Zeit raubende Suche verursachen.
:::

::: paragraph
Sie können hier Ordnung schaffen, indem Sie zu jeder Spool-Datei eine
gleichnamige Datei mit vorangestelltem Punkt anlegen, die Informationen
zum Job und gegebenenfalls einem Ansprechpartner enthält. Der Inhalt
dieser versteckten Datei wird nicht mit übertragen.
:::
:::::
::::::::::::::::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
