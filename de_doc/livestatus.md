:::: {#header}
# Statusdaten abrufen via Livestatus

::: details
[Last modified on 27-Oct-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/livestatus.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Livestatus Befehlsreferenz](livestatus_references.html) [Checkmk auf
der Kommandozeile](cmk_commandline.html) [Die Checkmk
REST-API](rest_api.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::: sectionbody
::: paragraph
Der Livestatus ist die wichtigste Schnittstelle in Checkmk. Durch sie
bekommen Sie schnellstmöglich und live Zugriff auf alle Daten der
überwachten Hosts und Services. So werden z.B. die Daten im
[Overview](user_interface.html#overview) direkt über diese Schnittstelle
abgerufen. Da diese direkt aus dem RAM geholt werden, werden langsame
Festplattenzugriffe vermieden und es gibt einen schnellen Zugriff auf
das Monitoring, ohne das System zu sehr zu belasten.
:::

::: paragraph
Um die Daten zu strukturieren, werden sie in Tabellen und Spalten
geordnet. Die Tabelle `hosts` enthält dann z.B. die Spalten `name`,
`state` und viele weitere. Jede Zeile in der Tabelle `hosts`
repräsentiert dabei einen Host, in der Tabelle `services` einen Service
usw. Auf diese Weise können die Daten einfach durchsucht und abgerufen
werden.
:::

::: paragraph
Dieser Artikel soll Ihnen helfen, diese Schnittstelle für eigene
Abfragen, Erweiterungen und Anpassungen zu nutzen. Alle Abfragen und
Kommandos in diesem Artikel können Sie als Instanzbenutzer durch
Copy&Paste direkt ausprobieren.
:::
::::::
:::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#lql .hidden-anchor .sr-only}2. Die Livestatus Query Language (LQL) {#heading_lql}

::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::::: sect2
### []{#lql_shell .hidden-anchor .sr-only}2.1. Nutzung der LQL in der Shell {#heading_lql_shell}

::: paragraph
Der Zugriff zum Livestatus erfolgt über einen Unix-Socket unter
Benutzung der *Livestatus Query Language (LQL)*. Diese ist in ihrer
Syntax an HTTP angelehnt.
:::

::: paragraph
Sie können auf der Kommandozeile auf verschiedene Arten auf die
Schnittstelle zugreifen. Eine Möglichkeit ist es, über die Kommandos
`printf` und `unixcat` den Befehl an den Socket zu leiten. Checkmk
liefert für den Instanzbenutzer das Tool `unixcat` bereits mit.
**Wichtig:** Alle Eingaben an den Socket unterscheiden Groß- und
Kleinschreibung, so dass diese immer eingehalten werden muss:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ printf "GET hosts\nColumns: name\n" | unixcat ~/tmp/run/live
```
:::
::::

::: paragraph
Die Schnittstelle erwartet alle Befehle und Header in jeweils einer
eigenen Zeile. Markieren Sie daher jeden Zeilenumbruch mit einem `\n`.
Als Alternative zu dem Kommando oben können Sie auch den Skriptbefehl
`lq` nutzen, welcher Ihnen einiges bei der Eingabe abnimmt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name"
```
:::
::::

::: paragraph
Oder Sie starten den interaktiven Eingabe-Stream und geben dann den
Befehl und die Header nacheinander ein. Mit einer Leerzeile führen Sie
den Befehl mit seinen Headern aus und eine weitere Zeile beendet den
Zugriff auf den Socket. Beachten Sie, dass in dem Beispiel alles vor der
ersten Leerzeile zum dem Befehl gehört und alles zwischen der ersten und
zweiten Leerzeile die Antwort ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET hosts
Columns: name

myserver123
myserver124
myserver125

OMD[mysite]:~$
```
:::
::::

::: paragraph
Die folgenden Beispiele werden immer mit dem `lq`-Befehl ausgeführt; in
direkter Form, wenn der Aufruf kurz ist und als Eingabe-Stream bei einem
längeren.
:::

::::: sect3
#### []{#_befehle_der_lql .hidden-anchor .sr-only}Befehle der LQL {#heading__befehle_der_lql}

::: paragraph
In den ersten Beispielen haben Sie bereits den ersten der beiden Befehle
gesehen: Mit `GET` können Sie alle verfügbaren Tabellen abrufen. In der
Befehlsreferenz finden Sie eine vollständige Liste aller verfügbaren
[Tabellen](livestatus_references.html#tables) mit einer Beschreibung In
diesem Artikel wird die generelle Benutzung des Livestatus gezeigt.
:::

::: paragraph
Mit `COMMAND` können Sie Kommandos direkt an den Core schicken, um z.B.
eine Downtime zu setzen oder Benachrichtigungen komplett zu
deaktivieren. Eine Liste aller verfügbaren Kommandos finden Sie
ebenfalls in der Befehlsreferenz bei den
[Commands](livestatus_references.html#commands).
:::
:::::

::::: sect3
#### []{#_header_in_der_lql .hidden-anchor .sr-only}Header in der LQL {#heading__header_in_der_lql}

::: paragraph
Zu jedem GET-Befehl können Sie verschiedene Header hinzufügen, um das
Ergebnis der Abfrage einzugrenzen, nur bestimmte Spalten einer Tabelle
auszugeben und vieles mehr. Die beiden wichtigsten Header sind die
folgenden:
:::

+--------------------+-------------------------------------------------+
| Header             | Beschreibung                                    |
+====================+=================================================+
| Columns            | Es werden nur die angegebenen Spalten einer     |
|                    | Abfrage ausgegeben.                             |
+--------------------+-------------------------------------------------+
| Filter             | Es werden nur die Einträge ausgegeben, auf die  |
|                    | eine bestimmte Bedingung zutrifft.              |
+--------------------+-------------------------------------------------+

::: paragraph
Eine Liste aller Header mit einer Kurzbeschreibung finden Sie
[hier](livestatus_references.html#hdr).
:::
:::::

::::::::: sect3
#### []{#columns .hidden-anchor .sr-only}Verfügbare Spalten und Tabellen anzeigen {#heading_columns}

::: paragraph
Sie werden sich nicht alle Tabellen und deren Spalten merken können und
haben vielleicht auch nicht immer auf dieses Handbuch (mit den
Referenzen in der Online-Version) Zugriff. Es lässt sich jedoch schnell
eine Abfrage erstellen, welche die gewünschten Informationen bereit
stellt. Um eine Liste aller verfügbaren Tabellen zu bekommen führen Sie
die folgende Abfrage aus und entfernen in der Ausgabe die duplizierten
Zeilen mit `sort`. In der Ausgabe sehen Sie die ersten vier Zeilen als
Beispielausgabe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET columns\nColumns: table" | sort -u
columns
commands
comments
contactgroups
```
:::
::::

::: paragraph
Für die Abfrage aller Spalten zu einer Tabelle müssen Sie diese
natürlich angeben. Ersetzen Sie daher `hosts` durch die gewünschte
Tabelle. Auch hier sind die ersten vier Zeilen der Ausgabe als Beispiel
zu sehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET columns\nFilter: table = hosts\nColumns: name"
accept_passive_checks
acknowledged
acknowledgement_type
action_url
```
:::
::::
:::::::::
:::::::::::::::::::::::::::

::::::: sect2
### []{#lql_python .hidden-anchor .sr-only}2.2. Nutzung der LQL in Python {#heading_lql_python}

::: paragraph
Da Checkmk sehr stark auf Python aufbaut, bieten sich Skripten in dieser
Sprache an. Für den Zugriff auf den Socket des Livestatus können Sie das
folgende Skript als Ausgangsbasis nutzen:
:::

::::: listingblock
::: title
live_example.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python
# Sample program for accessing Livestatus from Python

import json, os, socket

# for local site only: file path to socket
address = "%s/tmp/run/live" % os.getenv("OMD_ROOT")
# for local/remote sites: TCP address/port for Livestatus socket
# address = ("localhost", 6557)

# connect to Livestatus
family = socket.AF_INET if type(address) == tuple else socket.AF_UNIX
sock = socket.socket(family, socket.SOCK_STREAM)
sock.connect(address)

# send our request and let Livestatus know we're done
sock.sendall(str.encode("GET status\nOutputFormat: json\n"))
sock.shutdown(socket.SHUT_WR)

# receive the reply as a JSON string
chunks = []
while len(chunks) == 0 or chunks[-1] != "":
    data = sock.recv(4096)
    chunks.append(str(data.decode("utf-8")))
sock.close()
reply = "".join(chunks)

# print the parsed reply
print(json.loads(reply))
```
:::
:::::
:::::::

:::: sect2
### []{#_nutzung_der_livestatus_api .hidden-anchor .sr-only}2.3. Nutzung der Livestatus-API {#heading__nutzung_der_livestatus_api}

::: paragraph
Checkmk stellt auch eine API für die Programmiersprachen Python, Perl
und C++ zur Verfügung, welche den Zugriff auf den Livestatus
vereinfachen. Zu jeder Sprache steht Ihnen Beispielcode zur Verfügung,
welcher die Nutzung erläutert. Die Pfade zu diesen Beispielen finden Sie
in dem Kapitel [Dateien und Verzeichnisse](#files).
:::
::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::: sect1
## []{#_einfache_abfragen .hidden-anchor .sr-only}3. Einfache Abfragen {#heading__einfache_abfragen}

:::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_spalten_abfragen_columns .hidden-anchor .sr-only}3.1. Spalten abfragen (Columns) {#heading__spalten_abfragen_columns}

::: paragraph
Bisher wurden in den Beispielen alle Informationen zu allen Hosts
abgefragt. In der Praxis möchten Sie aber wahrscheinlich nur bestimmte
Informationen (Spalten) haben. Mit dem bereits erwähnten Header
`Columns` können Sie die Ausgabe auf diese Spalten eingrenzen. Die
einzelnen Spaltennamen werden durch ein einfaches Leerzeichen getrennt.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name address"
myserver123;192.168.0.42
myserver234;192.168.0.73
```
:::
::::

::: paragraph
Wie Sie sehen, erfolgt die Trennung der einzelnen Werte einer Zeile
wiederum durch ein Semikolon.
:::

::: paragraph
**Wichtig:** Wenn Sie diesen Header benutzen, werden die Kopfzeilen in
der Ausgabe unterdrückt. Sie können diese aber mit dem Header
[ColumnHeaders](#columnheader) der Ausgabe wieder hinzufügen.
:::
::::::::

::::::::::::::: sect2
### []{#_einfache_filter_setzen_filter .hidden-anchor .sr-only}3.2. Einfache Filter setzen (Filter) {#heading__einfache_filter_setzen_filter}

::: paragraph
Um die Abfrage nur auf bestimmte Zeilen einzugrenzen, können Sie Spalten
auf bestimmte Inhalte filtern. Wenn Sie also nur Services mit einem
bestimmten Status suchen, können Sie das durch einen Filter realisieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET services\nColumns: host_name description state\nFilter: state = 2"
myserver123;Filesystem /;2
myserver234;ORA MYINST Processes;2
```
:::
::::

::: paragraph
In dem Beispiel wird nach allen Services gesucht, deren Status
[CRIT]{.state2} ist; anschließend werden der Hostname, die
Servicebeschreibung und dessen Status ausgegeben. Sie können solche
Filter natürlich auch kombinieren und weiter einschränken auf Services,
deren Status [CRIT]{.state2} ist **und** noch nicht bestätigt wurde:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET services\nColumns: host_name description state\nFilter: state = 2\nFilter: acknowledged = 0"
myserver234;Filesystem /;2
```
:::
::::

::: paragraph
Wie Sie sehen, kann man auch nach Spalten filtern, die nicht in
`Columns` aufgelistet sind.
:::

::::::: sect3
#### []{#_operatoren_und_reguläre_ausdrücke .hidden-anchor .sr-only}Operatoren und reguläre Ausdrücke {#heading__operatoren_und_reguläre_ausdrücke}

::: paragraph
Bisher haben Sie nur auf die Übereinstimmung von Zahlen gefiltert. Sie
können das vorläufige Ergebnis einer Abfrage aber auch auf „kleiner als"
bei Zahlen oder auf Zeichenketten durchsuchen. Die Ihnen zur Verfügung
stehenden Operatoren finden Sie im Kapitel
[Operatoren](livestatus_references.html#operators) der Befehlsreferenz.
Dadurch können Sie z.B. auch über reguläre Ausdrücke in den Spalten
filtern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET services\nColumns: host_name description state\nFilter: description ~~ exchange database|availability"
myserver123;Exchange Database myinst1;1
myserver123;Exchange Availability Service;0
myserver234;Exchange Database myinst3;0
```
:::
::::

::: paragraph
Mit dem richtigen Operator können Sie auf verschiedene Art und Weise mit
regulären Ausdrücken die Spalten durchsuchen. Der Livestatus wird einen
solchen Ausdruck grundsätzlich immer als „kann irgendwo in der Spalte
vorkommen" interpretieren, sofern das nicht entsprechend anders
definiert wurde. Auf den Anfang einer Zeile verweisen Sie z.B. mit dem
Zeichen `^`, während Sie mit dem Zeichen `$` auf das Ende einer Zeile
hinweisen. Eine ausführliche Liste aller Sonderzeichen für Reguläre
Ausdrücke in Checkmk finden Sie in dem Artikel für [Reguläre
Ausdrücke](regexes.html#characters).
:::
:::::::
:::::::::::::::

:::::::::::: sect2
### []{#_ausgabe_sortieren_orderby .hidden-anchor .sr-only}3.3. Ausgabe sortieren (OrderBy) {#heading__ausgabe_sortieren_orderby}

::: paragraph
Mit dem Header `OrderBy` können Sie die Ausgabe nach den Inhalten
beliebiger Spalten oder auch den Werten beliebiger Dictionary-Schlüssel
sortieren. So lässt sich bspw. eine alphabetische Auflistung aller Host
erstellen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name\nOrderBy: name"
ahost
anotherhost
yetanotherhost
```
:::
::::

::: paragraph
Implizit wird die Ausgabe erwartungsgemäß aufsteigend sortiert (`asc`).
Sie können die gewünschte Sortierung aber auch explizit angeben und
durch die Angabe von `desc` umdrehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name\nOrderBy: name desc"
yetanotherhost
anotherhost
ahost
```
:::
::::

::: paragraph
Mit etwas längeren Abfragen und bspw. einer Sortierung nach
Performance-Daten, können interessante Ranglisten entstehen. Im
folgenden Beispiel werden die Hosts absteigend nach ihrer Uptime
sortiert ausgegeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$  lq "GET services\nColumns: host_name performance_data\nFilter: description = Uptime\nOrderBy: performance_data.uptime desc"
anotherhost;uptime|249531.1
yetanotherhost;uptime|149142.3
ahost;uptime|48959
```
:::
::::
::::::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#_komplexe_abfragen .hidden-anchor .sr-only}4. Komplexe Abfragen {#heading__komplexe_abfragen}

:::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#filter .hidden-anchor .sr-only}4.1. Filter für Listen {#heading_filter}

::: paragraph
Manche Spalten einer Tabelle liefern nicht nur einen Wert zurück,
sondern gleich eine ganze Liste davon. Damit Sie auch diese effektiv
durchsuchen können, haben die Operatoren hier eine andere Bedeutung.
Eine vollständige Liste der Operatoren finden Sie bei den [Operatoren
für Listen](livestatus_references.html#list_operators). So hat z.B. der
Operator `>=` die Bedeutung „enthält". Mit diesem können Sie z.B. nach
einem bestimmten Kontakt suchen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name address contacts\nFilter: contacts >= hhirsch"
myserver123;192.168.0.42;hhirsch,hhirsch,mfrisch
myserver234;192.168.0.73;hhirsch,wherrndorf
```
:::
::::

::: paragraph
Wie Sie in dem Beispiel sehen, werden die Kontakte in der Spalte
`contacts` kommasepariert aufgelistet. Dadurch lassen sie sich eindeutig
von dem Beginn einer neuen Spalte unterscheiden. Eine Besonderheit
stellt bei den Listen der Gleichheitsoperator dar. Er prüft, ob eine
Liste leer ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name contacts\nFilter: contacts ="
myserver345;
myserver456;
```
:::
::::
:::::::::

::::::::: sect2
### []{#combining .hidden-anchor .sr-only}4.2. Filter kombinieren {#heading_combining}

::: paragraph
Bereits vorher wurden mehrere Filter kombiniert. Dabei erscheint es
intuitiv, dass die Daten alle Filter passieren müssen, um angezeigt zu
werden. Die Filter werden also mit einem logischen **und** verknüpft. Um
bestimmte Filter mit einem logischen **oder** zu verknüpfen, können Sie
am Ende der Filterreihe ein `Or:` gefolgt von einer Ganzzahl einfügen.
Der Counter bestimmt, wie viele der letzten Zeilen zu einem **oder**
zusammengefasst werden. Dadurch können Sie Gruppen bilden und diese
beliebig kombinieren. Ein einfaches Beispiel ist das folgende. Hier
werden zwei Filter so kombiniert, dass alle Services angezeigt werden,
die entweder den Status [WARN]{.state1} oder [UNKNOWN]{.state3} haben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Columns: host_name description state
Filter: state = 1
Filter: state = 3
Or: 2

myserver123;Log /var/log/messages;1
myserver123;Interface 3;1
myserver234;Bonding Interface SAN;3

OMD[mysite]:~$
```
:::
::::

::: paragraph
Sie können das Ergebnis einer Kombination aber auch negieren oder
Gruppen wiederum zu Gruppen zusammenfassen. In dem Beispiel werden alle
Services angezeigt, deren Status nicht [OK]{.state0} ist und deren
Beschreibung entweder nicht mit `Filesystem` anfängt oder einen anderen
Status als [UNKNOWN]{.state3} hat:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Columns: host_name description state
Filter: state = 3
Filter: description ~ Filesystem
And: 2
Filter: state = 0
Or: 2
Negate:

myserver123;Log /var/log/messages;1
myserver123;Interface 3;1
myserver234;Filesystem /media;2
myserver234;Filesystem /home;2
```
:::
::::
:::::::::

::::::::::::::::::: sect2
### []{#_das_ausgabeformat_festlegen .hidden-anchor .sr-only}4.3. Das Ausgabeformat festlegen {#heading__das_ausgabeformat_festlegen}

::: paragraph
Sie können das Ausgabeformat auf zwei verschiedene Arten festlegen. Zum
einen können Sie die Separatoren der Standardausgabe neu definieren. Zum
anderen kann die Ausgabe auch Python- oder JSON-konform erfolgen.
:::

:::::::::::: sect3
#### []{#csv .hidden-anchor .sr-only}`csv` anpassen {#heading_csv}

::: paragraph
Wie bereits beschrieben, können Sie die genaue Formatierung des
Standardausgabeformates `csv` (kleingeschrieben!) anpassen und
definieren, wie die einzelnen Elemente voneinander getrennt werden
sollen. Checkmk kennt hier vier verschiedene Separatoren, um die Daten
zu strukturieren. Nach dem Doppelpunkt geben Sie dazu die entsprechenden
Standard-ASCII-Werte an, so dass der Filter wie folgt aufgebaut ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Separators: 10 59 44 124
```
:::
::::

::: paragraph
Diese Trenner haben nun die folgende Bedeutung:
:::

::: {.olist .arabic}
1.  Trenner für die Datensätze: `10` (Zeilenumbruch)

2.  Trenner für die Spalten eines Datensatzes: `59` (Semikolon)

3.  Trenner für die Elemente einer Liste: `44` (Komma)

4.  Trenner für die Elemente einer Serviceliste: `124` (Pipe)
:::

::: paragraph
Jeden dieser Werte können Sie anpassen, um die Ausgabe nach den eigenen
Wünschen zu strukturieren. In dem folgenden Beispiel werden die
einzelnen Spalten eines Datensatzes nicht mit Hilfe eines Semikolons
(59), sondern mit einem Tabulator (9) getrennt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Columns: host_name description state
Filter: description ~ Filesystem
Separators: 10 9 44 124

myserver123     Filesystem /opt     0
myserver123     Filesystem /var/some/path       1
myserver123     Filesystem /home        0
```
:::
::::

::: paragraph
**Wichtig:** Die Reihenfolge der Separatoren ist fest und darf daher
nicht vertauscht werden.
:::
::::::::::::

::::::: sect3
#### []{#output_format .hidden-anchor .sr-only}Ausgabeformat ändern {#heading_output_format}

::: paragraph
Neben einer Ausgabe in `csv` kann Livestatus für Sie auch andere Formate
erzeugen. Diese haben den Vorteil, dass sie sich in höheren
Programmiersprachen leichter und sauberer parsen lassen. Sie können sich
die Ausgabe demnach in den folgenden Formaten kodieren lassen:
:::

+-----------------------------------+-----------------------------------+
| Format                            | Beschreibung                      |
+===================================+===================================+
| python                            | Erzeugt die Ausgabe als Liste     |
|                                   | kompatibel zu Python 2.x. Text    |
|                                   | wird in Unicode formatiert.       |
+-----------------------------------+-----------------------------------+
| python3                           | Erzeugt ebenso die Ausgabe als    |
|                                   | Liste und berücksichtigt dabei    |
|                                   | Änderungen in den Datentypen, wie |
|                                   | z.B. die automatische             |
|                                   | Konvertierung von Text zu         |
|                                   | Unicode.                          |
+-----------------------------------+-----------------------------------+
| json                              | Die Ausgabe wird ebenfalls als    |
|                                   | Liste zurückgegeben. Es werden    |
|                                   | dabei jedoch nur JSON-kompatible  |
|                                   | Formate verwendet.                |
+-----------------------------------+-----------------------------------+
| CSV                               | Formatiert die Ausgabe nach       |
|                                   | [RFC-4180](https://tools.ietf.or  |
|                                   | g/html/rfc4180){target="_blank"}. |
+-----------------------------------+-----------------------------------+
| csv                               | Siehe [`csv` anpassen](#csv). Das |
|                                   | ist das Standardformat, wenn      |
|                                   | nichts angegeben wird und an das  |
|                                   | offizielle CSV-Format angelehnt.  |
+-----------------------------------+-----------------------------------+

::: paragraph
Verwechseln Sie das `CSV-Format` bitte nicht mit der `csv`-Ausgabe des
Livestatus, welches verwendet wird, wenn kein Ausgabeformat festgelegt
wurde. Eine korrekte Groß-/Kleinschreibung ist daher absolut notwendig.
Für die Anpassung übergeben Sie am Ende ein `OutputFormat` statt des
`Separator`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Columns: host_name description state
Filter: description ~ Filesystem
OutputFormat: json

[["myserver123","Filesystem /opt",0]
["myserver123","Filesystem /var/some/path",1]
["myserver123","Filesystem /home",0]]
```
:::
::::
:::::::
:::::::::::::::::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: sect1
## []{#retrieving_statistics .hidden-anchor .sr-only}5. Statistiken abrufen (Stats) {#heading_retrieving_statistics}

::::::::::::::::::::::: sectionbody
:::: sect2
### []{#_einleitung_2 .hidden-anchor .sr-only}5.1. Einleitung {#heading__einleitung_2}

::: paragraph
Es wird Situationen geben, in denen Sie gar nicht daran interessiert
sind, wie der Status eines einzelnen oder einer Gruppe von Services ist.
Vielmehr ist die Anzahl der Services wichtig, welche gerade
[WARN]{.state1} sind oder die Anzahl der überwachten Datenbanken.
Livestatus ist in der Lage mit `Stats` Statistiken zu erstellen und
auszugeben.
:::
::::

::::::: sect2
### []{#_zählen .hidden-anchor .sr-only}5.2. Zählen {#heading__zählen}

::: paragraph
Der [Overview]{.guihint} bekommt seine Daten, indem er über Livestatus
Statistiken zu Hosts, Services und Events abruft und dann in der
Oberfläche von Checkmk darstellt. Mit dem direkten Zugriff auf
Livestatus können Sie ebenfalls eigene Aufsummierungen erstellen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Stats: state = 0
Stats: state = 1
Stats: state = 2
Stats: state = 3

34506;124;54;20
```
:::
::::

::: paragraph
Solche Statistiken lassen sich übrigens auch mit allen
[Filtern](#filter) kombinieren.
:::
:::::::

::::::: sect2
### []{#_gruppieren .hidden-anchor .sr-only}5.3. Gruppieren {#heading__gruppieren}

::: paragraph
Auch Statistiken lassen sich mit `and/or` zusammenfassen. Die Header
heißen dann `StatsAnd` oder `StatsOr`. Wenn Sie die Ausgabe umkehren
wollen, benutzen Sie `StatsNegate`. In dem Beispiel wird die Gesamtzahl
der Hosts ausgegeben (das erste `Stats`) und dazu die Anzahl derer, die
als `stale` markiert wurden und sich nicht in einer Downtime befinden
(Stats 2 und 3 werden mit einem logischen UND verknüpft):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET hosts
Stats: state >= 0
Stats: staleness >= 3
Stats: scheduled_downtime_depth = 0
StatsAnd: 2

734;23
```
:::
::::

::: paragraph
Verwechseln Sie nicht die unterschiedlichen Möglichkeiten, die
Ergebnisse der Filter und Statistiken zusammenzufassen. Während bei dem
Header [`Filter`](#combining) alle Hosts ausgegeben werden, auf die die
Bedingungen zutreffen, wird bei den Statistiken die Summe ausgegeben,
wie oft die `Stats`-Filter zutreffen.
:::
:::::::

:::::::::: sect2
### []{#_minimum_maximum_durchschnitt_etc .hidden-anchor .sr-only}5.4. Minimum, Maximum, Durchschnitt etc. {#heading__minimum_maximum_durchschnitt_etc}

::: paragraph
Sie können auch Berechnungen an Werten durchführen und z.B. den
Durchschnittswert oder das Maximum ausgeben lassen. Eine vollständige
Liste der möglichen Operatoren finden Sie
[hier](livestatus_references.html#stats).
:::

::: paragraph
In dem folgenden Beispiel wird die durchschnittliche, minimale und
maximale Zeit ausgegeben, welche die Check-Plugins eines Hosts für die
Berechnung eines Status benötigen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Filter: host_name = myserver123
Stats: avg execution_time
Stats: max execution_time
Stats: min execution_time

0.0107628;0.452087;0.008593
```
:::
::::

::: paragraph
Berechnungen von Metriken werden etwas besonders behandelt. Auch hier
sind alle Funktionen des `Stats`-Header möglich. Diese werden jedoch auf
**alle** Metriken eines Service **einzeln** angewandt. Nachfolgend
werden als Beispiel die Metriken der CPU-Benutzung einer Host-Gruppe
aufsummiert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Filter: decription ~ CPU utilization
Filter: host_groups >= cluster_a
Stats: sum perf_data

guest=0.000000 steal=0.000000 system=34.515000 user=98.209000 wait=23.008000
```
:::
::::
::::::::::
:::::::::::::::::::::::
::::::::::::::::::::::::

:::::::: sect1
## []{#_begrenzung_der_ausgabe_limit .hidden-anchor .sr-only}6. Begrenzung der Ausgabe (Limit) {#heading__begrenzung_der_ausgabe_limit}

::::::: sectionbody
::: paragraph
Die Anzahl der Zeilen in der Ausgabe ist begrenzbar. Das kann z.B.
nützlich sein, wenn Sie nur sehen wollen, ob überhaupt eine Antwort auf
eine Livestatus-Anfrage zurückkommt, aber eine seitenlange Ausgabe
verhindern wollen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$  lq "GET hosts\nColumns: name\nLimit: 3"
myserver123
myserver234
myserver345
```
:::
::::

::: paragraph
Beachten Sie, dass dieses Limit auch funktioniert, wenn Sie es mit
anderen Headern kombinieren. Wenn Sie z.B. mit `Stat` zählen, wie viele
Hosts den Status [UP]{.hstate0} haben und die Ausgabe auf 10 begrenzen,
werden nur die ersten 10 Hosts berücksichtigt.
:::
:::::::
::::::::

::::::: sect1
## []{#_zeitbeschränkungen_timelimit .hidden-anchor .sr-only}7. Zeitbeschränkungen (Timelimit) {#heading__zeitbeschränkungen_timelimit}

:::::: sectionbody
::: paragraph
Sie können nicht nur die Anzahl der ausgegebenen Zeilen einschränken.
Auch die maximale Zeit, wie lange eine Abfrage dauern darf, können Sie
begrenzen. Damit verhindern Sie, dass eine Livestatus-Abfrage nicht für
immer eine Verbindung blockiert, weil sie aus irgendwelchen Gründen
hängt. Die Zeitbeschränkung gibt dabei die Zeit in Sekunden an, die die
Verarbeitung einer Abfrage dauern darf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nTimelimit: 1"
```
:::
::::
::::::
:::::::

::::::: sect1
## []{#columnheader .hidden-anchor .sr-only}8. Kopfzeilen aktivieren (ColumnHeaders) {#heading_columnheader}

:::::: sectionbody
::: paragraph
Mit den `ColumnHeaders` können Sie zu der Ausgabe die Namen der Spalten
ausgeben lassen. Diese werden normalerweise unterdrückt, um die
Weiterbearbeitung zu vereinfachen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$  lq "GET hosts\nColumns name address groups\nColumnHeaders: on"
name;address;groups
myserver123;192.168.0.42;cluster_a,headnode
myserver234;192.168.0.43;cluster_a
myserver345;192.168.0.44;cluster_a
```
:::
::::
::::::
:::::::

:::::::::: sect1
## []{#_berechtigungen_authuser .hidden-anchor .sr-only}9. Berechtigungen (AuthUser) {#heading__berechtigungen_authuser}

::::::::: sectionbody
::: paragraph
Wenn Sie Skripten auf Basis des Livestatus zur Verfügung stellen
möchten, sollen die Nutzer wahrscheinlich nur die Daten sehen, für die
sie auch berechtigt sind. Checkmk stellt dafür den Header `AuthUser` mit
der Einschränkung zur Verfügung, dass dieser nicht in den folgenden
Tabellen benutzt werden kann:
:::

::: ulist
- `columns`

- `commands`

- `contacts`

- `contactgroups`

- `eventconsolerules`

- `eventconsolestatus`

- `status`

- `timeperiods`
:::

::: paragraph
Umgekehrt bedeutet es, dass Sie diesen Header in allen Tabellen nutzen
können, die auf die Tabellen `hosts` oder `services` zugreifen. Ob ein
Nutzer nun berechtigt ist, hängt dabei von seinen Kontaktgruppen ab.
:::

::: paragraph
Auf diese Weise werden bei einer Abfrage nur diejenigen Daten
ausgegeben, die der Kontakt auch sehen darf. Beachten Sie hier den
Unterschied zwischen [`strict` und
`loose`](wato_user.html#visibility_host) bei den
Berechtigungseinstellungen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET services\nColumns: host_name description contacts\nAuthUser: hhirsch"
myserver123;Uptime;hhirsch
myserver123;TCP Connections;hhirsch
myserver123;CPU utilization;hhrisch,kkleber
myserver123;File /etc/resolv.conf;hhirsch
myserver123;Kernel Context Switches;hhrisch,kkleber
myserver123;File /etc/passwd;hhirsch
myserver123;Filesystem /home;hhirsch
myserver123;Kernel Major Page Faults;hhrisch
myserver123;Kernel Process Creations;hhirsch
myserver123;CPU load;hhrisch,kkleber
```
:::
::::
:::::::::
::::::::::

::::::::::::: sect1
## []{#_verzögerungen_wait .hidden-anchor .sr-only}10. Verzögerungen (Wait) {#heading__verzögerungen_wait}

:::::::::::: sectionbody
::: paragraph
Mit den Wait-Headern erstellen Sie Abfragen, um bestimmte Datensätze zu
bekommen, ohne wissen zu müssen, wann die Bedingungen für die Daten
erfüllt sind. Das kann nützlich sein, wenn Sie zu einem bestimmten
Fehlerbild Vergleichsdaten benötigen, aber das System nicht durchgehend
sinnlos belasten wollen. Informationen werden demnach nur dann
abgerufen, wenn Sie auch wirklich benötigt werden.
:::

::: paragraph
Eine vollständige Liste der Wait-Header finden Sie
[hier](livestatus_references.html#hdr).
:::

::: paragraph
In dem folgenden Beispiel wird der Service [Disk IO SUMMARY]{.guihint}
eines ESXi-Servers ausgegeben, sobald der Status des Service [CPU
load]{.guihint} auf einer bestimmten VM [CRIT]{.state2} wird. Durch den
Header `WaitTimeout` wird die Abfrage auch dann ausgeführt, wenn sie
nach 10000 Millisekunden nicht eingetreten ist. Das verhindert, dass die
Livestatus-Verbindung lange blockiert wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
WaitObject: myvmserver CPU load
WaitCondition: state = 2
WaitTrigger: state
WaitTimeout: 10000
Filter: host_name = myesxserver
Filter: description = Disk IO SUMMARY
Columns: host_name description plugin_output

myesxserver;Disk IO SUMMARY;OK - Read: 48.00 kB/s, Write: 454.54 MB/s, Latency: 1.00 ms
```
:::
::::

::: paragraph
Ein weiterer Anwendungsfall ist die Kombination mit einem
[Kommando.](#commands) Sie können ein Kommando absetzen und die
Ergebnisse abrufen, sobald diese verfügbar sind. In dem nachfolgenden
Beispiel werden die aktuellen Daten eines Services abgerufen und
angezeigt. Dafür wird zuerst das Kommando übergeben und danach eine
normale Abfrage erstellt. Diese prüft, ob die Daten des Service Checkmk
jünger sind als der definierte Zeitpunkt. Sobald die Bedingung erfüllt
ist, wird der Status des Service [Memory]{.guihint} ausgegeben.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "COMMAND [$(date +%s)] SCHEDULE_FORCED_SVC_CHECK;myserver;Check_MK;$(date
+%s)"
OMD[mysite]:~$ lq
GET services
WaitObject: myserver Check_MK
WaitCondition: last_check >= 1517914646
WaitTrigger: check
Filter: host_name = myserver
Filter: description = Memory
Columns: host_name description state

myserver;Memory;0
```
:::
::::

::: paragraph
**Wichtig:** Achten Sie darauf, dass der Zeitstempel in `last_check` aus
dem Beispiel durch einen aktuellen ersetzt werden muss. Andernfalls ist
die Bedingung immer erfüllt und die Ausgabe kommt sofort.
:::
::::::::::::
:::::::::::::

::::::::::: sect1
## []{#_zeitzonen_localtime .hidden-anchor .sr-only}11. Zeitzonen (Localtime) {#heading__zeitzonen_localtime}

:::::::::: sectionbody
::: paragraph
Viele größere Monitoring-Umgebungen rufen auf globaler Ebene Hosts und
Services ab. Da kann es schnell zu einer Situation kommen, bei der die
beteiligten Monitoring-Instanzen in verschiedenen Zeitzonen arbeiten. Da
Checkmk die zeitzonenunabhängige Unixzeit benutzt, sollte es hier zu
keinen Problemen kommen.
:::

::: paragraph
Falls einer der Server jedoch einer falschen Zeitzone zugeordnet wurde,
können Sie diese Differenz mit dem Header `Localtime` ausgleichen.
Übergeben Sie dazu der Abfrage die aktuelle Zeit. Checkmk wird dann
selbstständig auf die näher liegende halbe Stunde runden und die
Differenz ausgleichen. Sie können die Zeit automatisch übergeben, wenn
Sie eine direkte Abfrage nutzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name last_check\nFilter: name = myserver123\nLocaltime: $(date +%s)"
myserver123;1511173526
```
:::
::::

::: paragraph
Ansonsten übergeben Sie das Ergebnis aus `date +%s`, wenn Sie den
Eingabe-Stream nutzen möchten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET hosts
Columns: name last_check
Filter: name = myserver123
Localtime: 1511173390

myserver123;Memory;1511173526
```
:::
::::
::::::::::
:::::::::::

::::::::::: sect1
## []{#response_header .hidden-anchor .sr-only}12. Statuscodes (ResponseHeader) {#heading_response_header}

:::::::::: sectionbody
::: paragraph
Wenn Sie eine API schreiben, wollen Sie sehr wahrscheinlich auch einen
Statuscode als Rückmeldung haben, um die Ausgabe besser verarbeiten zu
können. Der Header `ResponseHeader` unterstützt die Werte `off`
(Standard) und `fixed16` und bietet damit eine exakt 16 Bytes lange
Statusnachricht in der ersten Zeile der Antwort. Im Falle eines Fehlers
enthalten die weiteren Zeilen eine ausführliche Fehlerbeschreibung zu
dem Statuscode. Sie eignet sich dadurch auch gut für eine Fehlersuche in
der Abfrage.
:::

::: paragraph
Die Statusnachricht der ersten Zeile setzt sich folgendermaßen zusammen:
:::

::: ulist
- Byte 1-3: Der Statuscode. Die komplette Tabelle der möglichen Codes
  finden Sie [hier](livestatus_references.html#response).

- Byte 4: Ein einfaches Leerzeichen (ASCII-Zeichen: 32).

- Byte 5-15: Die Länge der eigentlichen Antwort als Ganzzahl. Nicht
  benötigte Bytes werden mit Leerzeichen aufgefüllt.

- Byte 16: Ein Zeilenvorschub (ASCII-Zeichen: 10).
:::

::: paragraph
In dem folgenden Beispiel führen Sie eine fehlerhafte Abfrage aus, indem
Sie einen Filter falsch setzen bzw. mit dem Namen einer Spalte
*verwechseln.*
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nName: myserver123\nResponseHeader: fixed16"
400          33
Coluns: undefined request header
```
:::
::::

::: paragraph
**Wichtig:** Das [Ausgabeformat](#output_format) ist im Fehlerfall immer
eine Fehlermeldung in Textform. Das gilt unabhängig davon, wie Sie es
angepasst haben.
:::
::::::::::
:::::::::::

:::::::::: sect1
## []{#keepalive .hidden-anchor .sr-only}13. Verbindung aufrecht erhalten (KeepAlive) {#heading_keepalive}

::::::::: sectionbody
::: paragraph
Gerade bei Skripten, welche eine Livestatus-Verbindung über das
[Netzwerk](#network) aufbauen, wollen Sie vielleicht den Kanal offen
halten, um sich den Overhead des Verbindungsaufbaus zu sparen. Sie
erreichen das mit dem Header `KeepAlive` und sind so in der Lage, sich
einen Kanal zu *reservieren*. Nach einem [Kommando](#commands) bleibt
eine Livestatus-Verbindung übrigens immer offen. Sie benötigen dafür
keine Angabe eines zusätzlichen Headers.
:::

::: paragraph
**Wichtig:** Da der Kanal für die Dauer der Verbindung für andere
Prozesse blockiert ist, kann das zu einem Problem werden, wenn keine
Verbindungen mehr zur Verfügung stehen. Andere Prozesse müssen dann
warten, bis wieder eine Verbindung frei ist. In der
Standardkonfiguration hält Checkmk 20 Verbindungen bereit --- erhöhen
Sie bei Bedarf die maximale Anzahl dieser Verbindungen in [Setup \>
General \> Global Settings \> Monitoring Core \> Maximum concurrent
Livestatus connections]{.guihint}.
:::

::: paragraph
Kombinieren Sie `KeepAlive` immer mit dem
[`ResponseHeader`](#response_header), um die einzelnen Antworten
voneinander korrekt unterscheiden zu können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET hosts
ResponseHeader: fixed16
Columns: name
KeepAlive: on

200          33
myserver123
myserver234
myserver345
GET services
ResponseHeader: fixed16
Columns: host_name description last_check
Filter: description = Memory

200          58
myserver123;Memory;1511261122
myserver234;Memory;1511261183
```
:::
::::

::: paragraph
Achten Sie darauf, dass es zwischen der ersten Antwort und der zweiten
Abfrage anders als sonst keine Leerzeile gibt. Sobald Sie in einer
Abfrage den Header weglassen, wird die Verbindung nach der darauf
folgenden Ausgabe durch die übliche Leerzeile geschlossen.
:::
:::::::::
::::::::::

::::::::::::: sect1
## []{#logs .hidden-anchor .sr-only}14. Logs abrufen {#heading_logs}

:::::::::::: sectionbody
::::::::: sect2
### []{#_übersicht .hidden-anchor .sr-only}14.1. Übersicht {#heading__übersicht}

::: paragraph
Über die Tabelle `log` im Livestatus haben Sie direkten Zugriff auf die
Monitoring-Historie des Cores, so dass Sie mit der LQL bequem nach
bestimmten Ereignissen filtern können. Verfügbarkeiten werden zum
Beispiel auf Basis dieser Tabelle berechnet. Um die Übersicht zu erhöhen
und eine Abfrage thematisch einzugrenzen, haben Sie auf die folgenden
Log-Klassen zugriff:
:::

+-------------+--------------------------------------------------------+
| Klasse      | Beschreibung                                           |
+=============+========================================================+
| 0           | Alle Nachrichten, welche nicht über andere Klassen     |
|             | abgedeckt sind                                         |
+-------------+--------------------------------------------------------+
| 1           | Host- und Service-Alerts                               |
+-------------+--------------------------------------------------------+
| 2           | Wichtige Ereignisse des Programms                      |
+-------------+--------------------------------------------------------+
| 3           | Benachrichtigungen                                     |
+-------------+--------------------------------------------------------+
| 4           | Passive Checks                                         |
+-------------+--------------------------------------------------------+
| 5           | Externe Kommandos                                      |
+-------------+--------------------------------------------------------+
| 6           | Initiale oder aktuelle Statuseinträge (z.B. nach einer |
|             | Rotation des Logs)                                     |
+-------------+--------------------------------------------------------+
| 7           | Änderungen des Programmstatus                          |
+-------------+--------------------------------------------------------+

::: paragraph
Mit Hilfe dieser Log-Klassen können Sie bereits sehr gut eingrenzen,
welche Art von Einträgen angezeigt werden soll. Zusätzlich dazu wird der
Zeitraum eingeschränkt, der bei der Abfrage berücksichtigt werden soll.
Das ist wichtig, da andernfalls die gesamte Historie der Instanz
durchsucht wird. Das kann logischerweise das System aufgrund der
Informationsflut stark ausbremsen.
:::

::: paragraph
Eine weitere sinnvolle Einschränkung der Ausgabe sind die Spalten
(`Columns`), die zu einem Eintrag angezeigt werden sollen. In dem
folgenden Beispiel wird nach allen Benachrichtigungen gesucht, welche in
der letzten Stunde geloggt wurden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET log\nFilter: class = 3\nFilter: time >= $$(date +%s)-3600\nColumns: host_name service_description time state"
myserver123;Memory;1511343365;0
myserver234;CPU load;1511343360;3
myserver123;Memory;1511343338;2
myserver234;CPU load;1511342512;0
```
:::
::::

::: paragraph
**Wichtig:** Achten Sie darauf, dass Sie im interaktiven Modus des
Eingabe-Streams keine Variablen wie in dem Beispiel nutzen können. Und
schränken Sie die Abfragen **immer** auf einen Zeitraum ein.
:::
:::::::::

:::: sect2
### []{#_die_monitoring_historie_konfigurieren .hidden-anchor .sr-only}14.2. Die Monitoring-Historie konfigurieren {#heading__die_monitoring_historie_konfigurieren}

::: paragraph
Sie haben die Möglichkeit, die Rotation der Dateien und deren maximale
Größe zu beeinflussen. Zusätzlich können Sie auch bestimmen, wie viele
Zeilen einer Datei eingelesen werden sollen, bevor Checkmk abbricht. Das
alles kann, abhängig von dem Aufbau der Instanz, Auswirkungen auf die
Performance Ihrer Abfragen haben. Es stehen dabei die folgenden drei
Parameter zur Verfügung, welche Sie in unter [Setup \> General \> Global
Settings \> Monitoring Core]{.guihint} finden und anpassen können:
:::

+-----------------------------------+-----------------------------------+
| Name                              | Beschreibung                      |
+===================================+===================================+
| [History log rotation: Regular    | Hier wird festgelegt, in welchem  |
| interval of rotations]{.guihint}  | Zeitintervall die Historie in     |
|                                   | einer neuen Datei weitergeführt   |
|                                   | wird.                             |
+-----------------------------------+-----------------------------------+
| [History log rotation: Rotate by  | Unabhängig von dem Zeitintervall  |
| size (Limit of the                | wird hier die maximale Größe      |
| size)]{.guihint}                  | einer Datei festgelegt. Die Größe |
|                                   | stellt einen Kompromiss zwischen  |
|                                   | der möglichen Leserate und den    |
|                                   | möglichen IOs dar.                |
+-----------------------------------+-----------------------------------+
| [Maximum number of parsed lines   | Nach der angegeben Anzahl an      |
| per log file]{.guihint}           | Zeilen wird eine Datei nicht      |
|                                   | weiter gelesen. Das verhindert    |
|                                   | Timeouts, falls eine Datei aus    |
|                                   | irgendwelchen Gründen doch sehr   |
|                                   | groß geworden sein sollte.        |
+-----------------------------------+-----------------------------------+
::::
::::::::::::
:::::::::::::

:::::::::::::: sect1
## []{#_verfügbarkeiten_prüfen .hidden-anchor .sr-only}15. Verfügbarkeiten prüfen {#heading__verfügbarkeiten_prüfen}

::::::::::::: sectionbody
::: paragraph
Mit der Tabelle `statehist` können Sie die Rohdaten zu der Verfügbarkeit
von Hosts und Services abfragen und haben somit auf alle Informationen
Zugriff, die auch bei der [Verfügbarkeit](availability.html) in der
Oberfläche genutzt werden. Geben Sie auch hier immer einen Zeitraum an,
da sonst alle verfügbaren Logs durchsucht werden, was das System sehr
stark auslasten kann. Zusätzlich gelten folgende Besonderheiten:
:::

::: ulist
- Der Zeitraum, in der ein Host/Service einen bestimmten Status hatte,
  kann sowohl absolut in Unix-Zeit ausgegeben werden, als auch relativ
  als prozentualer Anteil zum abgefragten Zeitraum.

- In Zeiten, in denen ein Host/Service nicht überwacht wurde, ist der
  Status `-1`.
:::

::: paragraph
Die Überprüfung, ob, wann und wie lange ein Host/Service überwacht
wurde, ist in Checkmk durch das Logging von initialen Status möglich.
Dadurch können Sie nicht nur sehen, welcher Status zu einem bestimmten
Zeitpunkt bestand, sondern auch nachvollziehen ob dieser zu diesem
Zeitpunkt überhaupt überwacht wurde. **Wichtig:** Auch bei dem
Nagios-Core ist dieses Logging aktiviert. Hier können Sie es jedoch
deaktivieren:
:::

::::: listingblock
::: title
\~/etc/nagios/nagios.d/logging.cfg
:::

::: content
``` {.pygments .highlight}
log_initial_states=0
```
:::
:::::

::: paragraph
In dem folgenden Beispiel sehen Sie, wie die Abfrage einer prozentualen
Verteilung und absoluten Zeiten von bestimmten Status aussieht. Als
Zeitraum wurden hier die letzten 24 Stunden eingestellt und die Abfrage
wurde auf die Verfügbarkeit eines Service von einem bestimmten Host
eingeschränkt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET statehist
Columns: host_name service_description
Filter: time >= 1511421739
Filter: time < 1511436139
Filter: host_name = myserver123
Filter: service_description = Memory
Stats: sum duration_ok
Stats: sum duration_warning
Stats: sum duration_critical
Stats: sum duration_part_ok
Stats: sum duration_part_warning
Stats: sum duration_part_critical

myserver123;Memory;893;0;9299;0.0620139;0;0.645764
```
:::
::::

::: paragraph
Wie Sie eine vollständige Liste der verfügbaren Spalten abrufen, wird in
der [Befehlsreferenz](#columns) näher erläutert.
:::
:::::::::::::
::::::::::::::

:::::::::: sect1
## []{#_variablen_im_livestatus .hidden-anchor .sr-only}16. Variablen im Livestatus {#heading__variablen_im_livestatus}

::::::::: sectionbody
::: paragraph
Sie können an verschiedenen Stellen in der Checkmk-Oberfläche Variablen
nutzen, um Hosts/Services kontextbezogen zuzuweisen. Einige dieser Daten
sind auch über Livestatus abrufbar. Da diese Variablen auch aufgelöst
werden müssen, stehen solche Spalten in einer Tabelle doppelt zur
Verfügung: Einmal als wörtlicher Eintrag und einmal als Variante, in der
die Variable durch den entsprechenden Wert ersetzt wurde. Ein Beispiel
dafür ist die Spalte `notes_url`, welche eine URL mit der Variable
ausgibt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name notes_url"
myserver123;https://mymonitoring/heute/wiki/doku.php?id=hosts:$HOSTNAME$
```
:::
::::

::: paragraph
Wenn Sie jedoch stattdessen die Spalte `note_url_expanded` abfragen,
bekommen Sie den eigentlichen Wert des Makros ausgegeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hosts\nColumns: name notes_url_expanded"
myserver123;https://mymonitoring/heute/wiki/doku.php?id=hosts:myserver123
```
:::
::::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#network .hidden-anchor .sr-only}17. Livestatus über das Netzwerk nutzen {#heading_network}

:::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_verbindung_per_tcpip .hidden-anchor .sr-only}17.1. Verbindung per TCP/IP {#heading__verbindung_per_tcpip}

::: paragraph
Um über das Netzwerk auf den Livestatus zuzugreifen, können Sie den
Unix-Socket des Livestatus an einen TCP-Port binden. Auf diese Weise
können Sie Skripte über das auf entfernten Maschinen ausführen und die
Daten direkt dort erheben, wo sie auch verarbeitet werden sollen.
:::

::: paragraph
Den Zugriff über TCP aktivieren Sie bei abgeschalteter Site mit dem
`omd`-Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set LIVESTATUS_TCP on
```
:::
::::

::: paragraph
Nach dem Start der Instanz ist Livestatus per TCP in der Regel auf dem
[Standardport 6557](ports.html) aktiv. Bei Checkmk-Servern mit mehreren
Sites, die Livestatus per TCP nutzen, wird der nächsthöhere freie Port
gewählt.
:::

::: paragraph
Alle Einstellungen wie Port und berechtigte IP-Adressen können Sie per
`omd config` vornehmen. Alternativ sind diese Einstellungen im Setup
möglich. In Checkmk ist SSL-Verschlüsselung der Livestatus-Kommunikation
standardmäßig aktiviert:
:::

::::: imageblock
::: content
![Livestatus-Einstellungen im Setup.](../images/livestatus_setup.png)
:::

::: title
Livestatus-Einstellungen im Setup
:::
:::::

::::::::::: sect3
#### []{#_lokaler_test_der_ssl_verbindung .hidden-anchor .sr-only}Lokaler Test der SSL-Verbindung {#heading__lokaler_test_der_ssl_verbindung}

::: paragraph
Livestatus nutzt ein Zertifikat, welches beim Erstellen der Site
automatisch generiert wird. Dieses befindet sich mit allen anderen
CA-Zertifikaten, denen die Site vertraut in der Datei
`var/ssl/ca-certificates.crt`. Damit das Kommandozeilentool
`openssl s_client` das vom Livestatus-Server genutzte Zertifikat
validieren kann, muss diese Datei als *Certificate Authority File*
bekannt gemacht werden.
:::

::: paragraph
Die Ausgabe des Kommandozeilenaufrufs haben wir hier stark gekürzt,
`[…​]` zeigt die Auslassungen an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ openssl s_client -CAfile var/ssl/ca-certificates.crt -connect localhost:6557
CONNECTED(00000003)
Can't use SSL_get_servername
depth=1 CN = Site 'mysite' local CA
verify return:1
depth=0 CN = mysite
verify return:1
---
Certificate chain
 0 s:CN = mysite
   i:CN = Site 'mysite' local CA
 1 s:CN = Site 'mysite' local CA
   i:CN = Site 'mysite' local CA
---
Server certificate
[...]
    Start Time: 1664965470
    Timeout   : 7200 (sec)
    Verify return code: 0 (ok)
    Extended master secret: no
    Max Early Data: 0
---
read R BLOCK
```
:::
::::

::: paragraph
Erfolgt keine weitere Ausgabe mehr, können Sie interaktiv LQL-Kommandos
absetzen, welche Sie mit einer Leerzeile (zweimal Return-Taste)
abschließen. Klappt dies, können Sie Livestatus-Abfragen auch per
Pipeline übergeben, der zusätzliche Parameter `-quiet` unterdrückt hier
Debugging-Ausgaben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo -e "GET hosts\nColumns: name\n\n" | \
    openssl s_client -quiet  -CAfile var/ssl/ca-certificates.crt -connect localhost:6557
Can't use SSL_get_servername
depth=1 CN = Site 'mysite' local CA
verify return:1
depth=0 CN = mysite
verify return:1
myserver23
myserver42
myserver123
myserver124
```
:::
::::

::: paragraph
Die Ausgabe vor den vier Hostnamen schreibt `openssl` auf STDERR, Sie
können diese durch anhängen von `2>/dev/null` unterdrücken.
:::
:::::::::::

:::::::::::: sect3
#### []{#_remote_zugriff_auf_livestatus .hidden-anchor .sr-only}Remote-Zugriff auf Livestatus {#heading__remote_zugriff_auf_livestatus}

::: paragraph
Wenn Sie von entfernten Rechnern auf Livestatus zugreifen, sollten Sie
auf diesen nicht die gesamte Liste der von der Checkmk-Site vertrauten
Zertifikate verwenden. Lesen Sie stattdessen alleine das Zertifikat der
Site-CA aus dem Setup aus.
:::

::: paragraph
Begeben Sie sich hierfür nach [Global Settings \> Site management \>
Trusted certificate authorities for SSL]{.guihint}. Hier können Sie das
verwendete Zertifikat der Site-CA per Copy and Paste übernehmen.
Kopieren Sie den kompletten Text des ersten Zertifikats unter [Content
of CRT/PEM file]{.guihint} in eine Datei, im Beispiel verwenden wir
`/tmp/mysite_ca.pem`.
:::

::::: imageblock
::: content
![Anzeige des Zertifikats der Site CA im
Setup.](../images/livestatus_ca_copy_paste.png)
:::

::: title
Anzeige des Zertifikats der Site CA im Setup
:::
:::::

::: paragraph
Wenn der entfernte Host nun für den Livestatus-Zugriff freigeschaltet
wurde, sind mit dieser Zertifikatsdatei Livestatus-Abfragen per Skript
möglich:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo -e "GET hosts\nColumns: name\n\n" | \
    openssl s_client -quiet  -CAfile /tmp/mysite_ca.pem -connect cmkserver:6557
```
:::
::::

::: paragraph
Beachten Sie: Die Zertifikatsdatei bietet keine Authentifizierung, sie
stellt lediglich die Transportverschlüsselung sicher! Zugriffsschutz
wird ausschließlich über die IP-Adressen geregelt, welche auf den
Livestatus-Port zugreifen dürfen.
:::
::::::::::::

:::::::::: sect3
#### []{#_livestatus_mit_stunnel .hidden-anchor .sr-only}Livestatus mit stunnel {#heading__livestatus_mit_stunnel}

::: paragraph
Falls Sie einen entfernten verschlüsselten Livestatus Port als lokal
unverschlüsselten Port erreichbar machen wollen, können Sie das Programm
[stunnel](https://www.stunnel.org/){target="_blank"} verwenden.
:::

::::: listingblock
::: title
/etc/stunnel/cmk_myremotesite.conf
:::

::: content
``` {.pygments .highlight}
[pinning client]
client = yes
accept = 0.0.0.0:6557
connect = <myremotesiteip>:6557
verifyPeer = yes
CAfile = /etc/stunnel/myremotesite.pem
```
:::
:::::

::: paragraph
Nach Neustart des stunnel ist der Zugriff auf den lokalen Port
unverschlüsselt möglich:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo -e "GET hosts\nColumns: name\n\n" | nc localhost 6557
```
:::
::::
::::::::::

:::: sect3
#### []{#_ssl_im_skript .hidden-anchor .sr-only}SSL im Skript {#heading__ssl_im_skript}

::: paragraph
Falls Sie per Skript via SSL auf Livestatus zugreifen wollen, verwenden
Sie möglichst nicht `openssl s_client`. Primärer Zweck dieses Tools ist
der Test des Verbindungsaufbaus und das Debugging von Zertifikatsketten.
Um im Falle von Verbindungsabbrüchen zu erkennen, ob die erwartete
Ausgabe vollständig war, empfehlen wir, den
[`ResponseHeader`](#response_header) auszuwerten. Ein gut gepflegtes
API, welches SSL und Header-Auswertung unterstützt, ist jenes für
Python, das Sie unter `share/doc/check_mk/livestatus/api/python` finden.
Weitere APIs listet das Kapitel [*Dateien und Verzeichnisse*](#files).
:::
::::
:::::::::::::::::::::::::::::::::::::::::

:::::::::::::: sect2
### []{#_verbindung_über_ssh .hidden-anchor .sr-only}17.2. Verbindung über SSH {#heading__verbindung_über_ssh}

::: paragraph
Wenn Zugriff auf Livestatus von außerhalb Ihres lokalen Netzwerkes
erforderlich ist, mag Zugriffsschutz alleine auf Basis von IP-Adressen
nicht praktikabel sein. Der einfachste Weg, authentifizierten Zugriff zu
erlangen, ist hier die Verwendung der *Secure Shell*.
:::

::: paragraph
Mit SSH haben Sie die Möglichkeit, ein Kommando zu übergeben, welches
auf dem entfernten Server ausgeführt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ ssh mysite@myserver 'lq "GET hosts\nColumns: name"'
myserver123
myserver234
```
:::
::::

::: paragraph
Alternativ können Sie den Livestatus-Port per SSH-Tunnel auf den Host
weiterleiten, auf dem Sie aktuell arbeiten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ ssh -L 6557:localhost:6557 mysite@myserver
```
:::
::::

::: paragraph
Wenn die Verbindung steht, können Sie in einer zweiten Konsolensitzung
testen, ob mit `openssl s_client` Zugriff möglich ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ openssl s_client -CAfile /tmp/mysite_ca.pem -connect localhost:6557
```
:::
::::

::: paragraph
Klappt dieser Test, können Sie jedes Skript, dass Sie für direkten
Livestatus-Netzwerkzugriff geschrieben haben, auf `localhost` einsetzen.
:::
::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#commands .hidden-anchor .sr-only}18. Kommandos setzen {#heading_commands}

:::::::::::::::: sectionbody
:::::::: sect2
### []{#_übersicht_2 .hidden-anchor .sr-only}18.1. Übersicht {#heading__übersicht_2}

::: paragraph
Sie können Livestatus nicht nur für die Abfrage von Daten nutzen,
sondern auch, um Kommandos live und direkt an den Core (CMC oder Nagios)
zu schicken. Ein korrektes Kommando enthält immer einen Zeitstempel.
Dieser kann zwar beliebig sein. Da er aber in den [Logs](#logs) dazu
benutzt wird, den Zeitpunkt der Ausführung nachzuvollziehen, ist es
sinnvoll, möglichst die exakte Zeit anzugeben. Kommandos mit fehlendem
Zeitstempel werden ohne Fehlermeldung und lediglich mit einem Eintrag im
[`cmc.log`](#files) verworfen!
:::

::: paragraph
Damit der Zeitstempel so genau, wie möglich ist, bietet es sich an, das
Kommando nicht über den Eingabe-Stream zu setzen, sondern direkt zu
übergeben. Sie haben in diesem Fall auch Zugriff auf Variablen und
können automatisch die gerade aktuelle Zeit übergeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "COMMAND [$(date +%s)] DISABLE_NOTIFICATIONS"
```
:::
::::

::: paragraph
Dieses Format funktioniert sowohl mit dem Nagios-Core von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw**, als auch mit dem CMC der kommerziellen Editionen.
Allerdings überschneiden sich bei den beiden Cores nur teilweise die
Kommandos. Eine vollständige Liste der Kommandos für den Nagios-Core
finden Sie direkt auf der Internetseite von
[Nagios](https://old.nagios.org/developerinfo/externalcommands/commandlist.php){target="_blank"}.
Die für Checkmk relevanten und für den CMC verfügbaren Kommandos finden
Sie in der [Befehlsreferenz](livestatus_references.html#commands).
:::
::::::::

::::::::: sect2
### []{#_besonderheiten_bei_nagios .hidden-anchor .sr-only}18.2. Besonderheiten bei Nagios {#heading__besonderheiten_bei_nagios}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In der Liste der
Kommandos werden Sie die Syntax in der folgenden Form vorfinden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
#!/bin/sh
# This is a sample shell script showing how you can submit the CHANGE_CUSTOM_HOST_VAR command
# to Nagios.  Adjust variables to fit your environment as necessary.

now=`date +%s`
commandfile='/usr/local/nagios/var/rw/nagios.cmd'

/bin/printf "[%lu] CHANGE_CUSTOM_HOST_VAR;host1;_SOMEVAR;SOMEVALUE\n" $now > $commandfile
```
:::
::::

::: paragraph
Wie Sie gelernt haben, benutzt Checkmk ein sehr viel einfacheres Format
für die Übergabe des Kommandos. Um dieses Format für Checkmk kompatibel
zu übertragen, benötigen Sie lediglich das Kommando, den Zeitstempel und
gegebenenfalls die Variablen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "COMMAND [$(date +%s)] CHANGE_CUSTOM_HOST_VAR;host1;_SOMEVAR;SOMEVALUE"
```
:::
::::
:::::::::
::::::::::::::::
:::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}19. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+--------------------------------------+-------------------------------+
| Pfad                                 | Bedeutung                     |
+======================================+===============================+
| `~/tmp/run/live`                     | Der Unix-Socket zur Übergabe  |
|                                      | der Abfragen und Kommandos.   |
+--------------------------------------+-------------------------------+
| `~/bin/lq`                           | Skriptbefehl für die          |
|                                      | einfachere Übergabe der       |
|                                      | Abfragen und Kommandos and    |
|                                      | den Unix-Socket des           |
|                                      | Livestatus.                   |
+--------------------------------------+-------------------------------+
| `~/var/log/cmc.log`                  | Die Logdatei des CMC, in der  |
|                                      | unter anderem die             |
|                                      | Abfragen/Kommandos            |
|                                      | dokumentiert werden.          |
+--------------------------------------+-------------------------------+
| `~/var/check_mk/core/history`        | Die Logdatei des CMC, in der  |
|                                      | alle zur Laufzeit des Core    |
|                                      | auftretenden Änderungen       |
|                                      | eingetragen werden, wie z.B.  |
|                                      | Statusänderungen eines        |
|                                      | Host/Service.                 |
+--------------------------------------+-------------------------------+
| `~/var/check_mk/core/archive/`       | Hier werden die               |
|                                      | `history`-Logdateien          |
|                                      | archiviert. Diese werden nur  |
|                                      | nach Bedarf eingelesen.       |
+--------------------------------------+-------------------------------+
| `~/var/log/nagios.log`               | Die Logdatei des Nagios-Core, |
|                                      | in der unter anderem die      |
|                                      | Abfragen/Kommandos            |
|                                      | dokumentiert werden.          |
+--------------------------------------+-------------------------------+
| `~/var/nagios/archive/`              | Hier werden die               |
|                                      | `history`-Logdateien          |
|                                      | archiviert. Diese werden nur  |
|                                      | nach Bedarf eingelesen.       |
+--------------------------------------+-------------------------------+
| `~/share/do                          | In diesem Verzeichnis finden  |
| c/check_mk/livestatus/LQL-examples/` | Sie einige Beispiele zu       |
|                                      | Livestatus-Abfragen, die Sie  |
|                                      | ausprobieren können. Die      |
|                                      | Beispiele werden an den       |
|                                      | Skriptbefehl `lq` geleitet,   |
|                                      | wie z.B.: `lq < 1.lql`        |
+--------------------------------------+-------------------------------+
| `~/share                             | In diesem Verzeichnis finden  |
| /doc/check_mk/livestatus/api/python` | Sie die API zu Python sowie   |
|                                      | einige Beispiele. Lesen Sie   |
|                                      | auch das `README` in diesem   |
|                                      | Verzeichnis.                  |
+--------------------------------------+-------------------------------+
| `~/sha                               | Die API zu Perl finden Sie    |
| re/doc/check_mk/livestatus/api/perl` | hier. Auch hier gibt es       |
|                                      | wieder ein `README`. Die      |
|                                      | Beispiele zur Nutzung         |
|                                      | befinden sich hier in dem     |
|                                      | Unterverzeichnis `examples`.  |
+--------------------------------------+-------------------------------+
| `~/sh                                | Zu der Programmiersprache C++ |
| are/doc/check_mk/livestatus/api/c++` | finden Sie hier ebenfalls     |
|                                      | Beispielcode. Der Code zu der |
|                                      | API selbst liegt ebenfalls    |
|                                      | unkompiliert vor, so dass Sie |
|                                      | maximalen Einblick in die     |
|                                      | Funktionsweise der API haben. |
+--------------------------------------+-------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
