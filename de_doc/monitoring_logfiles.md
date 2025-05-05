:::: {#header}
# Log-Dateien überwachen

::: details
[draft]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_logfiles.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Dateien überwachen](mk_filestats.html) [Die Event Console](ec.html)
:::
::::
:::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Dieser Artikel ist derzeit im     |
|                                   | Entstehen begriffen und wird      |
|                                   | regelmäßig ergänzt.               |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::
:::::::::

:::::::: sect1
## []{#basics .hidden-anchor .sr-only}1. Wesentliches zur Überwachung von Log-Dateien {#heading_basics}

::::::: sectionbody
::: paragraph
Die Geschichte der Überwachung von Log-Dateien ist eine Geschichte
voller Missverständnisse. Die Missverständnisse beginnen bereits, wenn
wir uns anschauen, was Log-Einträge sind und was andererseits Services
in Checkmk anzeigen. Zeilen oder Einträge in Log-Dateien sind \"von
Natur aus\" ereignisbasiert (event based). Checkmk hingegen bildet
Zustände ab. Mehr über den Unterschied von Ereignissen und Zuständen im
Artikel [Grundlagen des Monitorings mit
Checkmk](monitoring_basics.html#states_events).
:::

::: paragraph
In Checkmk umgehen wir dieses Problem, indem wir definieren, wann ein
Service, der eine oder mehrere Log-Dateien abbildet, einen kritischen
Zustand annimmt. Im Regelfall definieren wir \"werde kritisch, wenn die
Log-Datei Meldungen enthält die
:::

::: ulist
- neu,

- unbestätigt und

- kritisch sind\".
:::

::: paragraph
Außerdem sollten Sie bei der Verwendung von Logwatch Maß halten.
Logwatch eignet sich für den dosierten Einsatz und nicht dafür,
Gigabytes oder Terabytes von Log-Dateien zu verarbeiten. Dafür gibt es
sicherlich geeignetere Werkzeuge. Wir empfehlen unbedingt Logwatch nur
anlassbezogen und nicht flächendeckend einzusetzen. Wie Sie im weiteren
Verlauf des Artikels noch sehen werden, ist es leicht möglich, bereits
auf dem überwachten Host einen wichtigen Teil der (Vor-)Filterung
vorzunehmen.
:::
:::::::
::::::::

::::::::::::::::: sect1
## []{#prereqisites .hidden-anchor .sr-only}2. Voraussetzungen {#heading_prereqisites}

:::::::::::::::: sectionbody
::: paragraph
Logwatch ist ein Python-Programm und benötigt somit eine Python-Umgebung
auf dem Host. In den meisten Linux-Distributionen wird Python bereits
installiert sein und auch Solaris bringt seit geraumer Zeit Python 3.x
mit. Falls Sie Log-Dateien auf einem Windows-Host überwachen möchten,
gibt es unterschiedliche Wege zum Ziel.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Nutzer unserer
kommerziellen Editionen können Logwatch komfortabel über die GUI
konfigurieren und das Plugin mit der Agentenbäckerei in das Agentenpaket
einfügen lassen. Sobald Checkmk bemerkt, dass Sie ein Agentenplugin auf
Basis von Python für einen Windows-Host konfigurieren, wird dem Agenten
zusätzlich eine virtuelle Python-Umgebung (`venv`) mitgegeben.
:::

::: paragraph
Sollten Sie zwar eine unserer kommerziellen Editionen, aber die
Agentenbäckerei nicht nutzen, so können Sie für Ihre Windows-Hosts den
nun folgenden Abschnitt zu Rate ziehen.
:::

:::::::::::: sect2
### []{#python_windows .hidden-anchor .sr-only}2.1. Python für Windows in Checkmk Raw {#heading_python_windows}

::::::: sect3
#### []{#install_python_venv .hidden-anchor .sr-only}Checkmk Python (`venv`) installieren {#heading_install_python_venv}

::: paragraph
Das Installationspaket des Windows-Agenten aus Checkmk Raw enthält keine
Python-Umgebung. Eine entsprechende Cabinet-Datei liegt allerdings
bereits auf Ihrem Checkmk-Server bereit. Diese Datei namens
`python-3.cab` finden Sie im Verzeichnis
`~/share/check_mk/agents/windows` oder in Checkmk über [Setup \> Agents
\> Windows \> Windows Agent]{.guihint}. Kopieren Sie diese Datei auf
Ihren Windows-Host in das Verzeichnis
`C:\Program Files (x86)\checkmk\service\install`. Dort liegt bereits
eine Datei mit diesem Namen und einer Dateigröße von 0 Byte. Diese Datei
müssen Sie mit der Version vom Checkmk-Server überschreiben. Starten Sie
anschließend den Service des Checkmk-Agenten neu. In der Windows
PowerShell mit Administratorrechten, können Sie das mit dem folgenden
Befehl erledigen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
net stop checkmkservice; net start checkmkservice
```
:::
::::

::: paragraph
Beim Neustart des Windows-Service wird die virtuelle Python-Umgebung
automatisch installiert.
:::
:::::::

:::::: sect3
#### []{#install_full_python .hidden-anchor .sr-only}Python vollständig installieren {#heading_install_full_python}

::: paragraph
Alternativ können Sie auch ein aktuelles Python-Paket von
[python.org](https://www.python.org/){target="_blank"} herunterladen und
installieren. Achten Sie bei der Installation darauf, die folgenden
Optionen zu aktivieren:
:::

::: ulist
- [Install Python 3.x for all users]{.guihint}. Hierdurch wird auch
  automatisch die Option [Precompile standard library]{.guihint}
  aktiviert und das ist auch gut so.

- [Add Python to environment variables]{.guihint}
:::

::: paragraph
Falls sie nach der Installation von Python gleich drauflos testen
wollen, ist auch unbedingt ein Neustart von `checkmkservice` entweder
über den Windows Task Manager oder mit den oben angegebenen Befehlen
notwendig. Sonst weiß der Service nämlich nichts von den neuen
Umgebungsvariablen.
:::
::::::
::::::::::::
::::::::::::::::
:::::::::::::::::

::::::::::::::::::::::::::::::::::::::::: sect1
## []{#monitor_logfiles .hidden-anchor .sr-only}3. Log-Dateien überwachen {#heading_monitor_logfiles}

:::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#installation .hidden-anchor .sr-only}3.1. Installation auf dem Host {#heading_installation}

::: paragraph
Beginnen Sie damit, das Agentenplugin zu installieren. Kopieren Sie dazu
die Datei `~/share/check_mk/agents/plugins/mk_logwatch.py` von Ihrem
Checkmk-Server auf den Host in das Verzeichnis
`/usr/lib/check_mk_agent/plugins/` (Linux) bzw.
`C:\ProgramData\checkmk\agent\plugins` (Windows). Achten Sie darauf,
dass die Datei auf dem Host ausführbar ist. Weitere Informationen zu
diesem Schritt finden Sie jeweils im Abschnitt \"Manuelle Installation\"
in den Artikeln [Linux überwachen](agent_linux.html#manualplugins) und
[Windows überwachen](agent_windows.html#manual_installation_of_plugins).
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Nutzer unserer
kommerziellen Editionen können während der [Konfiguration der
Regel](#configuration) [Text logfiles (Linux, Solaris,
Windows)]{.guihint} die Option [Deploy the Logwatch plugin and its
configuration]{.guihint} auswählen und das Agentenplugin so automatisch
mit dem Agenten ausrollen.
:::
:::::

:::::::::::::::::::::::::::::::::::: sect2
### []{#configuration .hidden-anchor .sr-only}3.2. Konfiguration von Logwatch {#heading_configuration}

::: paragraph
Passend zu den anfänglichen Überlegungen überwacht Logwatch ohne
Konfiguration nichts. Deshalb ist es nach der Installation den
Agentenplugins unerlässlich, eine Konfigurationsdatei vom dem
überwachten Host anzulegen.
:::

:::::::::::::::::::::::::: sect3
#### []{#configuration_bakery .hidden-anchor .sr-only}Konfiguration über die Agentenbäckerei {#heading_configuration_bakery}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen rufen Sie zunächst die Regel für das
Agentenplugin [Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agent
rules \> Text logfiles (Linux, Solaris, Windows)]{.guihint} auf. Die
Voreinstellung [Deploy the Logwatch plugin and its
configuration]{.guihint} sollte im Regelfall so belassen werden. Falls
Sie die Konfigurationsdatei `logwatch.cfg` allerdings auf einem anderen
Weg auf den Host übertragen wollen oder müssen, steht hier noch die
Option [Deploy the Logwatch plugin without configuration]{.guihint} zur
Verfügung.
:::

::: paragraph
Weiter geht es mit der Option [Retention period]{.guihint}. Die
Voreinstellung beträgt hier eine Minute, was auch dem voreingestellten
Check-Intervall in Checkmk entspricht. Der Wert sollte immer mindestens
dem Check-Intervall entsprechen. Diese Option ist in erster Linie dafür
zuständig, dass keine Log-Meldungen durch eine Service-Erkennung oder
die manuelle Ausführung von `cmk -d myhost` verloren gehen. Weitere
Details dazu finden Sie in der Inline-Hilfe der Option und im [Werk
#14451](https://checkmk.com/werk/14451){target="_blank"} mit dem diese
Option eingeführt wurde.
:::

::: paragraph
Jetzt folgt die Sektion der Regel, wo es endlich richtig losgeht -
[Configure a logfile section]{.guihint}. Und das beginnen wir direkt mit
dem größten Stolperstein der vergangenen Jahre. In dem Feld [Patterns
for logfiles to monitor]{.guihint} müssen Sie die Log-Dateien, die Sie
überwachen wollen, benennen. Dies können Sie einzeln und explizit oder
mit sogenannten Glob Patterns (kurz: Glob) erledigen. Wir verwenden an
dieser Stelle das Python-Modul `glob`, zu dem es auf docs.python.org
eine [ausführliche
Dokumentation](https://docs.python.org/3/library/glob.html){target="_blank"}
gibt. Wir wollen Ihnen aber gleich hier ein paar hilfreiche Beispiele an
die Hand geben.
:::

::: paragraph
Schreiben Sie hier beispielsweise `/var/log/my.log` hinein, wird
Logwatch eben diese eine Log-Datei überwachen. Geben Sie hier
stattdessen `/var/log/*log` ein, wird Logwatch alle Dateien, die auf die
Zeichenfolge `log` enden und **direkt** im Verzeichnis `/var/log`
liegen, überwachen. Wollen Sie Log-Dateien in allen direkten
Unterverzeichnissen von `/var/` überwachen, können Sie das
beispielsweise mit dem folgenden Glob erledigen: `/var/*/*log`. Das Glob
`**` zum rekursiven Durchsuchen einer Verzeichnisstruktur bieten wir
hier explizit **nicht** an, weil wir damit viel zu schnell bei viel zu
großen Trefferlisten landen und den eigentlichen Einsatzzweck von
Logwatch hinter uns lassen.
:::

::: paragraph
Die folgende Tabelle gibt Ihnen noch ein paar hilfreiche Beispiele, wie
Sie Globs verwenden können, um auch wirklich zu die Dateien zu
überwachen, die der Überwachung bedürfen, ohne alle einzeln angeben zu
müssen:
:::

+----------------------+----------------------+-----------------------+
| Glob Pattern         | Erläuterung          | Beispieltreffer       |
+======================+======================+=======================+
| `/var/log/*`         | Alle Dateien in      | `/var/log/mylog`      |
|                      | `/var/log`.          | `/var/log/my.log`     |
+----------------------+----------------------+-----------------------+
| `/var/log/*/*`       | Alle Dateien in      | `/var/log/foo/mylog`  |
|                      | allen direkten       | `/var/log/bar/mylog`  |
|                      | Unterverzeichnissen  |                       |
|                      | von `/var/log/`.     |                       |
+----------------------+----------------------+-----------------------+
| `                    | Alle Dateien in      | `/var/log/mylog1.log` |
| /var/log/mylog?.log` | `/var/log` deren     | `/var/log/mylog9.log` |
|                      | Namen mit `mylog`    |                       |
|                      | beginnen, gefolgt    |                       |
|                      | von einem einzelnen  |                       |
|                      | Zeichen und mit      |                       |
|                      | `.log` enden.        |                       |
+----------------------+----------------------+-----------------------+
| `/var                | Alle Dateien in      | `/var/log/mylog1.log` |
| /log/mylog[123].log` | `/var/log` deren     | `/var/log/mylog3.log` |
|                      | Namen mit `mylog`    |                       |
|                      | beginnen, gefolgt    |                       |
|                      | von entweder einer   |                       |
|                      | `1`, `2` oder `3`    |                       |
|                      | und auf `.log`       |                       |
|                      | enden.               |                       |
+----------------------+----------------------+-----------------------+

::: paragraph
Wenn es also darum geht, welche Dateien im **ersten** Schritt
\"gematcht\" werden, verwenden wir **keine** regulären Ausdrücke und
womöglich genügt Ihnen das schon, um alle gewünschten Dateien zu
erreichen.
:::

::: paragraph
Wenn Sie jetzt allerdings weiter aussieben müssen, können Sie in einem
zweiten Schritt mit der Option [Regular expression for logfile
filtering]{.guihint} reguläre Ausdrücke auf die Treffer aus Schritt 1
anwenden.
:::

::: paragraph
Haben Sie also im ersten Schritt mit `/var/log/*` und `/var/log/*/*`
alle Dateien in `/var/log/` und seinen direkten Unterverzeichnissen
eingesammelt, könnten Sie mit dem regulären Ausdruck `error.log$|err$`
die Trefferliste auf alle Dateien reduzieren, die auf `err.log` oder
`err` enden. Obacht: Der Punkt ist nun wieder ein beliebiges Zeichen.
Somit könnten dann zum Beispiel die Dateien
`/var/log/apache2/error.log`, `/var/log/mail.err` und
`/var/log/cups/error_log` übrig bleiben.
:::

::: paragraph
Sie sehen also, dass wir Ihnen für Auswahl der überwachten Dateien
bereits zwei gute und mächtige Werkzeuge an die Hand geben, damit
Logwatch im nächsten Schritt sehr zügig durch eine überschaubare
Dateiliste auch die weiteren Parameter bzw. Inhalte prüfen kann. Zu
Letzterem können Sie Ihre Kenntnisse im Artikel [reguläre Ausdrücke in
Checkmk](regexes.html) weiter vertiefen.
:::

::: paragraph
Mit der Option [Restrict the length of the lines]{.guihint} können Sie
Logwatch anweisen, überlange Zeilen nach der vorgegebenen Anzahl an
Zeichen abzuschneiden.
:::

::: paragraph
Die folgende Option [Watch the total size of the log file]{.guihint}
bietet sich an, um eine defekte Log-Rotation zu erkennen. Wenn Sie hier
100 MiB einstellen, erhalten Sie jedes Mal eine Warnung, wenn eine
bestimmte Log-Datei erneut um die eingestellte Größe gewachsen ist.
:::

::: paragraph
Die maximale Anzahl der Zeilen, die Logwatch pro Durchlauf und Datei
prüft, lässt sich mit [Restrict number of processed messages per
cycle]{.guihint} einschränken und mit [Restrict runtime of logfile
parsing]{.guihint} können Sie dafür sorgen, dass Logwatch sich nicht zu
lang an einer einzelnen Datei aufhält, die womöglich seit der letzten
Prüfung mit abertausenden neuen Einträgen geflutet wurde.
:::

::: paragraph
Wenn Sie eine der beiden letzteren Optionen aktivieren, müssen Sie auch
festlegen, was bei einer Überschreitung des angegebenen Grenzwerts
passieren soll. Mit unserer Voreinstellung wird der zugehörige Service
kritisch und Sie erhalten die Mitteilung, dass Zeilen übersprungen
wurden bzw. dass die maximale Laufzeit überschritten wurde.
:::

::: paragraph
[Handling of context messages]{.guihint} ist eine Option, mit der die
Menge der übertragenen Daten sehr rasch sehr groß werden **kann**.
Überlegen Sie also genau, ob Ihnen nur die Log-Meldung wichtig ist, die
Ihrer Ansicht nach ein [CRIT]{.state2} oder [WARN]{.state1} erzeugen
soll, oder ob **alle** Zeilen, die seit dem letzten Durchlauf von
Logwatch hinzugekommen sind, an den Checkmk-Server übertragen werden
sollen. Bei kleinen Log-Dateien, die minütlich nur um ein paar Zeilen
anwachsen, ist die Einstellung [Do transfer context]{.guihint}
sicherlich unproblematisch. Wenn aber auf einem Host aber 50 Log-Dateien
überwacht werden, die plötzlich 100 000 neue Zeilen mit einer Länge von
500 Zeichen aufweisen, landen wir schon im Gigabyte-Bereich. Womöglich
würde es bei einem solchen Ereignis eben genügen zu sehen, dass seit der
letzten Prüfung sehr viele neue Meldungen dazu gekommen sind, um eine
Prüfung direkt auf dem betroffenen Host zu veranlassen.
:::

::: paragraph
Sollten Sie den Kontext - also die Zeilen vor und nach einer für Sie
wichtigen Log-Meldung - doch benötigen, so können Sie diesen mit der
Option [Limit the amount of context data sent to the monitoring
server]{.guihint} auf eine bestimmte Zahl an Zeilen vorher und nachher
beschränken.
:::

::: paragraph
Mit [Limit the amount of data sent to the monitoring server]{.guihint}
beschränken Sie die Größe der übertragenen Daten ganz allgemein.
:::

::: paragraph
[Process new logfiles from the beginning]{.guihint} ist standardmäßig
abgeschaltet. Dies führt mitunter zu Verwunderung, weil Logwatch
Probleme, die in Log-Dateien stehen, nicht \"erkennt\" und an den
Checkmk-Server weiterreicht. Nach unserer Auffassung ist nichts älter
als die Zeitung von gestern und so eben auch die Log-Meldungen, die
**vor dem ersten Durchlauf** von Logwatch bereits in einer Log-Datei
standen. Bei diesem allerersten Durchlauf tut Logwatch nämlich nicht
mehr, als sich zu notieren, wie viele Zeilen bereits in dem jeweiligen
Log enthalten sind. Erst beim zweiten Durchlauf werden die Dateien dann
auf Ihren Inhalt - sprich die neu hinzugekommenen Zeilen - geprüft.
:::

::: paragraph
Logwatch ist bei seiner Arbeit darauf angewiesen, die Log-Dateien auch
tatsächlich lesen zu können. Unter der Haube gibt sich Logwatch sehr
viel Mühe, die Kodierung einer jeden Log-Datei zu erkennen. Allzu
exotische Zeichenkodierungen können aber dazu führen, dass es hier zu
Problemen kommt. Falls Sie die Zeichenkodierungen der überwachten
Log-Dateien beeinflussen können, ist UTF-8 eine sehr gute Wahl. Geht das
nicht und schafft Logwatch es nicht, die Kodierung herauszufinden,
können Sie mit [Codec that should be used to decode the matching
files]{.guihint} eine explizite Angabe machen.
:::

::: paragraph
Mit [Duplicated messages management]{.guihint} lässt sich wieder ein
bisschen Bandbreite sparen und auch die spätere Ausgabe in Checkmk wird
leserlicher, wenn Sie diese Option aktivieren. Wenn Sie [Filter out
consecutive duplicated messages in the agent output]{.guihint}
aktivieren, zählt Logwatch wie oft eine Zeile wiederholt wurde und
schreibt dies entsprechend in den Output, statt die Zeilen zu
wiederholen.
:::

::: paragraph
Zu guter Letzt werden jetzt die für Sie interessanten Zeilen in den
Log-Dateien per regulärem Ausdruck beschrieben und einem Zustand
zugeordnet. Wenn Sie möchten, dass jede Zeile, die das Wort `panic`
enthält zu einem [CRIT]{.state2} in Checkmk führt, genügt es hier nach
einem Klick auf [Add message pattern]{.guihint} unterhalb von [Regular
expressions for message classification]{.guihint} `panic` in das Feld
[Pattern(Regex)]{.guihint} einzutragen. Die Funktion der weiteren
angebotenen Optionen sind bereits sehr detailliert ist der Inline-Hilfe
an dieser Stelle beschrieben und werden hier nicht dupliziert.
:::

::: paragraph
Nur soviel: Der Zustand [OK]{.guihint} mag auf den ersten Blick
verwirren. Er dient dazu, Zeilen aus einer Log-Datei erstmal an den
Checkmk-Server zu übertragen, um dann dort erst die endgültige
Klassifizierung vorzunehmen. Und damit kommen wir zu einem wichtigen
Punkt, der zeigt, wie flexibel Logwatch - bei richtigem Einsatz - sein
kann.
:::

::: paragraph
Alle Optionen, die in diesem Abschnitt erklärt wurden, werden zu
Einträgen in der bereits erwähnten Konfigurationsdatei, die auf dem
jeweiligen Host abgelegt wird. Sollten Sie nun Änderungen an der
Klassifizierung bestimmter Meldungen vornehmen wollen, kann es also
sein, dass Sie zuerst die Regel editieren müssen, anschließend den
Agenten backen und diesen installieren müssen.
:::

::: paragraph
Alternativ können Sie aber erstmal alle interessanten Meldungen an den
Checkmk-Server übertragen (beispielsweise eben mit dem Zustand
[OK]{.state0}) und diese dann im Anschluss mit der Regel [Logfile
patterns]{.guihint} auf dem Checkmk-Server (um-)klassifizieren. Auf
diesem Wege können Sie sich das Backen und Ausrollen des neuen Agenten
sparen und müssen nach einer entsprechenden Anpassung der oben genannten
Regel nur einmal schnell die Änderungen aktivieren. Wie das genau geht,
erfahren Sie weiter unten im Kapitel [Umklassifizieren mit
Log-Datei-Mustern.](#logfile_patterns)
:::
::::::::::::::::::::::::::

:::::::::: sect3
#### []{#configuration_manual .hidden-anchor .sr-only}Manuelle Konfiguration {#heading_configuration_manual}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In der
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** konfigurieren Sie das Agentenplugin wie üblich über eine
Textdatei. Im Regelfall sucht Logwatch eine Datei namens `logwatch.cfg`
in den Verzeichnissen `/etc/check_mk` (Linux) bzw.
`c:\ProgramData\checkmk\agent\config\` (Windows). Eine (fast) minimale
Konfiguration könnte so aussehen:
:::

::::: listingblock
::: title
/etc/check_mk/logwatch.cfg
:::

::: content
``` {.pygments .highlight}
"/var/log/my.log" overflow=C nocontext=True
 C a critical message
 W something that should only trigger a warning
```
:::
:::::

::: paragraph
Zuerst geben Sie hier also immer ein Glob Pattern an, gefolgt von allen
anzuwendenden Optionen. Darauf folgt - mit einer Einrückung von einem
Leerzeichen - zuerst ein Buchstabe, der den gewünschten Zustand bzw. die
Funktion repräsentiert und schließend ein regulärer Ausdruck, der mit
jeder Zeile der Log-Datei verglichen wird. Mit obiger Konfiguration
würden alle neuen Zeilen, die seit dem letzten Durchlauf von Logwatch in
die Datei `/var/log/my.log` hinzugefügt wurden, auf die beiden Pattern
`a critical message` und `something that should only trigger a warning`
geprüft.
:::

::: paragraph
Eine sehr umfangreiche Beispielkonfiguration finden Sie als
Instanzbenutzer in der Datei
`~/share/check_mk/agents/cfg_examples/logwatch.cfg`.
:::

::: paragraph
Da alle Optionen, die Sie in einer solchen Konfigurationsdatei angeben
können, bereits im Abschnitt [Konfiguration über
Agentenbäckerei](#configuration_bakery) erklärt wurden, folgt hier nur
eine Auflistung samt Verweis. Konsultieren Sie für die Erklärung den
obigen Abschnitt.
:::

+-----------------+-----------------+-----------------+-----------------+
| Option in       | Entsprechung    | Beispiel        | Anmerkung       |
| `logwatch.cfg`  |                 |                 |                 |
+=================+=================+=================+=================+
| `regex`         | [Regular        | `regex='er      |                 |
|                 | expression for  | ror.log$|err$'` |                 |
|                 | logfile         |                 |                 |
|                 | filte           |                 |                 |
|                 | ring]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `encoding`      | [Codec that     | `               |                 |
|                 | should be used  | encoding=utf-8` |                 |
|                 | to decode the   |                 |                 |
|                 | matching        |                 |                 |
|                 | f               |                 |                 |
|                 | iles]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `maxlines`      | [Restrict       | `maxlines=500`  |                 |
|                 | number of       |                 |                 |
|                 | processed       |                 |                 |
|                 | messages per    |                 |                 |
|                 | c               |                 |                 |
|                 | ycle]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `maxtime`       | [Restrict       | `maxtime=23`    |                 |
|                 | runtime of      |                 |                 |
|                 | logfile         |                 |                 |
|                 | par             |                 |                 |
|                 | sing]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `overflow`      | In case of an   | `overflow=W`    |                 |
|                 | overflow        |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `maxlinesize`   | [Restrict the   | `m              |                 |
|                 | length of the   | axlinesize=123` |                 |
|                 | l               |                 |                 |
|                 | ines]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `maxoutputsize` | [Limit the      | `maxoutpu       | Größe in Bytes  |
|                 | amount of data  | tsize=10485760` |                 |
|                 | sent to the     |                 |                 |
|                 | monitoring      |                 |                 |
|                 | se              |                 |                 |
|                 | rver]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `skipconsecu    | [Duplicated     | `s              |                 |
| tiveduplicated` | messages        | kipconsecutived |                 |
|                 | manage          | uplicated=True` |                 |
|                 | ment]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `nocontext`     | [Handling of    | `               |                 |
|                 | context         | nocontext=True` |                 |
|                 | mess            |                 |                 |
|                 | ages]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| `m              | [Limit the      | `maxcont        |                 |
| axcontextlines` | amount of       | extlines=55,66` |                 |
|                 | context data    |                 |                 |
|                 | sent to the     |                 |                 |
|                 | monitoring      |                 |                 |
|                 | se              |                 |                 |
|                 | rver]{.guihint} |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
::::::::::
::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#logfile_grouping .hidden-anchor .sr-only}4. Gruppierung von Log-Dateien {#heading_logfile_grouping}

::::: sectionbody
::: paragraph
Der zum Agentenplugin gehörige Check namens `logwatch` erstellt
normalerweise für jede Log-Datei einen eigenen Service. Durch die
Definition von Gruppierungen mithilfe der Regel [Logfile
Grouping]{.guihint} können Sie auf den Check `logwatch_groups`
umschalten.
:::

::: paragraph
Weitere Informationen folgen demnächst. Konsultieren Sie bis dahin die
Inline-Hilfe der Regel [Logfile Grouping.]{.guihint}
:::
:::::
::::::

::::: sect1
## []{#logfile_patterns .hidden-anchor .sr-only}5. Umklassifizieren mit Log-Datei-Mustern {#heading_logfile_patterns}

:::: sectionbody
::: paragraph
Dieser Abschnitt folgt zeitnah. Konsultieren Sie bis dahin die
Inline-Hilfe der Regel [Logfile patterns.]{.guihint}
:::
::::
:::::

::::: sect1
## []{#_weiterleitung_an_die_event_console .hidden-anchor .sr-only}6. Weiterleitung an die Event Console {#heading__weiterleitung_an_die_event_console}

:::: sectionbody
::: paragraph
Neben der direkten Verarbeitung von Log-Meldungen in Checkmk und einer
etwaigen Umklassifizierung mit der Regel [Logfile patterns]{.guihint},
gibt es auch noch die Möglichkeit, durch Logwatch gewonnene Log-Zeilen
an die [Event Console](glossar.html#ec) weiterzuleiten. Dies geschieht
mithilfe der Regel [Logwatch Event Console Forwarding]{.guihint} und
wird im Artikel [Die Event Console](ec.html#logwatch) beschrieben.
:::
::::
:::::

::::::: sect1
## []{#_logwatch_im_monitoring .hidden-anchor .sr-only}7. Logwatch im Monitoring {#heading__logwatch_im_monitoring}

:::::: sectionbody
::: paragraph
Im Monitoring unterscheidet sich die Darstellung je nach verwendetem
Check-Plugin.
:::

::: paragraph
Verwenden Sie entweder `logwatch` oder `logwatch_groups`, finden Sie -
nach der notwendigen Service-Erkennung - pro Log-Datei bzw. pro
Gruppierung von Log-Dateien (siehe [Gruppierung von
Log-Dateien](#logfile_grouping)) einen Service der mit `Log` beginnt.
Darauf folgt der vollständige Pfad der Datei bzw. der Gruppenname.
:::

::: paragraph
Wenn Sie ihre Log-Meldungen hingegen and die Event Console weiterleiten,
sehen Sie je nach Einstellung der Regel [Logwatch Event Console
Forwarding]{.guihint} pro Weiterleitung einen Service, der Sie über die
Zahl der weitergeleiteten Log-Meldungen informiert. Bei der gebündelten
Weiterleitung durch das Plugin `logwatch_ec` heißt dieser Service [Log
Forwarding]{.guihint}. Wenn Sie die Option [Separate check]{.guihint}
und damit das Plugin `logwatch_ec_single` verwenden, beginnt der
Service-Name auch wieder mit `Log` gefolgt von dem Pfad der Log-Datei.
Auch dieser Service informiert Sie dann über die Anzahl der
weitergeleiteten Meldungen und darüber, wenn eine Log-Datei nicht
gelesen werden kann.
:::
::::::
:::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}8. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: paragraph
Alle Pfadangaben für den Checkmk-Server sind relativ zum
Instanzverzeichnis (z.B. `/omd/sites/mysite`) angegeben.
:::

+---------+---------------------------+--------------------------------+
| Ort     | Pfad                      | Bedeutung                      |
+=========+===========================+================================+
| Checkmk | `                         | Beispielkonfigurationsdatei    |
| -Server | ~/share/check_mk/agents/c |                                |
|         | fg_examples/logwatch.cfg` |                                |
+---------+---------------------------+--------------------------------+
| Checkmk | `~/share/check_mk/agent   | Python-3-Agentenplugin         |
| -Server | s/plugins/mk_logwatch.py` | inklusive Erläuterungen        |
+---------+---------------------------+--------------------------------+
| Checkmk | `~/share/check_mk/agents/ | Python-2-Agentenplugin         |
| -Server | plugins/mk_logwatch_2.py` | inklusive Erläuterungen        |
+---------+---------------------------+--------------------------------+
| Lin     | `/e                       | Konfigurationsdatei - von der  |
| ux-Host | tc/check_mk/logwatch.cfg` | Agentenbäckerei oder manuell   |
|         |                           | erstellt                       |
+---------+---------------------------+--------------------------------+
| Lin     | `/var/lib/check_m         | State-Dateien von mk_logwatch  |
| ux-Host | k_agent/logwatch.state.*` |                                |
+---------+---------------------------+--------------------------------+
| Lin     | `/var/lib/check_mk_       | Speicherort der einzelnen      |
| ux-Host | agent/logwatch-batches/*` | Batches, die mk_logwatch pro   |
|         |                           | Abfrage erzeugt                |
+---------+---------------------------+--------------------------------+
| Windo   | `c:\ProgramData\checkmk\a | Konfigurationsdatei - von der  |
| ws-Host | gent\config\logwatch.cfg` | Agentenbäckerei oder manuell   |
|         |                           | erstellt                       |
+---------+---------------------------+--------------------------------+
| Windo   | `c:\Program               | Ablageort für die              |
| ws-Host | Data\checkmk\agent\state` | State-Dateien von mk_logwatch  |
+---------+---------------------------+--------------------------------+
| Windo   | `c:                       | Speicherort der einzelnen      |
| ws-Host | \ProgramData\checkmk\agen | Batches, die mk_logwatch pro   |
|         | t\state\logwatch-batches` | Abfrage erzeugt                |
+---------+---------------------------+--------------------------------+
::::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
