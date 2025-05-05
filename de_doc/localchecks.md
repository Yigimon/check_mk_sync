:::: {#header}
# Lokale Checks

::: details
[Last modified on 22-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/localchecks.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html)
[Datenquellenprogramme](datasource_programs.html) [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#_warum_eigene_checks .hidden-anchor .sr-only}1. Warum eigene Checks? {#heading__warum_eigene_checks}

::::: sectionbody
::: paragraph
Checkmk überwacht durch die große Anzahl an mitgelieferten Check-Plugins
bereits sehr viele relevante Daten. Dennoch ist jede IT-Umgebung
einzigartig, so dass sich oft sehr individuelle Anforderungen ergeben.
Mit den **lokalen Checks** (*local checks*) sind Sie in der Lage, den
Agenten auf dem Ziel-Host zu erweitern, indem Sie schnell und einfach
eigene Services erstellen.
:::

::: paragraph
Diese lokalen Plugins unterscheiden sich dabei in einem wesentlichen
Punkt von anderen Checks: Die Berechnung des Status erfolgt direkt auf
dem Host, auf dem die Daten auch abgerufen werden. Dadurch entfällt die
komplexe Erstellung von Checks in Python und Sie sind bei der Wahl der
Skriptsprache völlig frei.
:::
:::::
::::::

::::::::::::::::::::::::::::::::::::: sect1
## []{#simple_check .hidden-anchor .sr-only}2. Einen einfachen lokalen Check schreiben {#heading_simple_check}

:::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::: sect2
### []{#syntax .hidden-anchor .sr-only}2.1. Skript erstellen {#heading_syntax}

::: paragraph
Sie können einen lokalen Check in jeder beliebigen Programmiersprache
schreiben, die der Ziel-Host unterstützt. Das Skript muss so konstruiert
sein, dass es pro Check eine Statuszeile ausgibt, die aus vier Teilen
besteht. Hier ist ein Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
0 "My service" myvalue=73 My output text which may contain spaces
```
:::
::::

::: paragraph
Die vier Teile sind durch Leerzeichen getrennt und haben folgende
Bedeutung:
:::

+-----------------+-------------+--------------------------------------+
| Beispielwert    | Bedeutung   | Beschreibung                         |
+=================+=============+======================================+
| `0`             | Status      | Der Zustand des Services wird als    |
|                 |             | Ziffer angegeben: `0` für            |
|                 |             | [OK]{.state0}, `1` für               |
|                 |             | [WARN]{.state1}, `2` für             |
|                 |             | [CRIT]{.state2} und `3` für          |
|                 |             | [UNKNOWN]{.state3}. Alternativ ist   |
|                 |             | es möglich, den [Status dynamisch    |
|                 |             | berechnen](#dynamic_state) zu        |
|                 |             | lassen: dann wird die Ziffer durch   |
|                 |             | ein `P` ersetzt.                     |
+-----------------+-------------+--------------------------------------+
| `"My service"`  | S           | Der Name des Services, wie er in     |
|                 | ervice-Name | Checkmk angezeigt wird, in der       |
|                 |             | Ausgabe des Checks in doppelten      |
|                 |             | Anführungszeichen.                   |
+-----------------+-------------+--------------------------------------+
| `my             | Wert und    | Metrikwerte zu den Daten. Sie finden |
| value=73;65;75` | Metriken    | im Kapitel zu den                    |
|                 |             | [Metriken](#metrics) näheres zum     |
|                 |             | Aufbau. Alternativ können Sie ein    |
|                 |             | Minuszeichen setzen, wenn der Check  |
|                 |             | keine Metriken ausgibt.              |
+-----------------+-------------+--------------------------------------+
| `My output      | S           | Details zum Status, wie sie in       |
| text which may  | tatusdetail | Checkmk angezeigt werden. Dieser     |
| contain spaces` |             | Teil kann auch Leerzeichen           |
|                 |             | enthalten.                           |
+-----------------+-------------+--------------------------------------+

::: paragraph
Zwischen den vier Teilen dieser Ausgabe muss immer **genau ein
Leerzeichen** (ASCII `0x20`) stehen. Innerhalb der Statusdetails können
beliebige Leerzeichen in beliebiger Reihenfolge verwendet werden.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Abweichungen von der soeben       |
|                                   | beschriebenen Spezifikation       |
|                                   | *können* funktionieren, *müssen*  |
|                                   | es aber nicht. Künftige Versionen |
|                                   | von Checkmk werden dieses         |
|                                   | Ausgabeformat möglicherweise      |
|                                   | erzwingen und abweichende lokale  |
|                                   | Checks ignorieren.                |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Wenn Sie wegen einer möglichen Ausgabe unsicher sind, können Sie diese
einfach testen, indem Sie ein kleines Skript mit dem Kommando `echo`
schreiben. Fügen Sie in das `echo`-Kommando Ihre Ausgabe ein, die Sie
testen möchten. Unser Beispiel verwendet außen die doppelten
Anführungszeichen, da innerhalb stehende Variablen (Umgebungsvariablen
und im Skript gesetzte) ausgewertet werden. Das hat zur Folge, dass Sie
die Anführungszeichen für den Service-Namen mit `\` maskieren müssen,
damit diese Zeichen nicht von der Shell als Ende und Anfang eines
Strings interpretiert (und damit aus der Ausgabe entfernt) werden:
:::

::::: listingblock
::: title
mylocalcheck
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
echo "0 \"My 1st service\" - This static service is always OK"
```
:::
:::::

::: paragraph
Für Windows-Hosts sieht so ein Testskript sehr ähnlich aus:
:::

::::: listingblock
::: title
mylocalcheck.bat
:::

::: content
``` {.pygments .highlight}
@echo off
echo 0 "My 1st service" - This static service is always OK
```
:::
:::::

::: paragraph
Beide Skripte führen in der Ausgabe zum selben Ergebnis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
0 "My 1st service" - This static service is always OK
```
:::
::::

::: paragraph
Für Checkmk ist nur diese Ausgabe relevant, nicht wie Sie diese Ausgabe
erzeugt haben.
:::

::: paragraph
Sie können übrigens beliebig viele Ausgaben in einem Skript erzeugen.
Für jede ausgegebene Zeile wird dann ein eigener Service in Checkmk
erstellt. Daher sind in der Ausgabe auch keine Zeilenumbruchzeichen
erlaubt --- es sei denn, sie sind maskiert, zum Beispiel für eine
[mehrzeilige Ausgabe](#multi-line) in Checkmk.
:::

::: paragraph
Wie Sie prüfen, ob das lokale Skript vom Agenten richtig aufgerufen
wird, sehen Sie in der [Fehleranalyse](#diagnose).
:::

::: paragraph
Unresolved directive in localchecks.asciidoc -
include::include_special_chars.asciidoc\[\]
:::
::::::::::::::::::::::::

:::::::: sect2
### []{#distribute .hidden-anchor .sr-only}2.2. Skript verteilen {#heading_distribute}

::: paragraph
Nachdem das Skript geschrieben ist, können Sie es an die entsprechenden
Hosts verteilen. Der Pfad unterscheidet sich je nach Betriebssystem.
Eine Liste der Pfade finden Sie in [Dateien und
Verzeichnisse](#folders_script) weiter unten.
:::

::: paragraph
Vergessen Sie nicht, das Skript auf Unix-artigen Systemen ausführbar zu
machen. Der Pfad in dem Beispiel bezieht sich auf Linux:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod +x /usr/lib/check_mk_agent/local/mylocalcheck
```
:::
::::

::: paragraph
Wenn Sie die [Agentenbäckerei](wato_monitoringagents.html#bakery)
nutzen, können Sie das Skript auch regelbasiert verteilen. Mehr zur
Regelerstellung erfahren Sie im Kapitel [Verteilung über die
Agentenbäckerei](#bakery).
:::
::::::::

::::::: sect2
### []{#add_service .hidden-anchor .sr-only}2.3. Den Service ins Monitoring aufnehmen {#heading_add_service}

::: paragraph
Bei jedem Aufruf des Checkmk-Agenten wird auch der im Skript enthaltene
lokale Check ausgeführt und an die Ausgabe des Agenten angehängt. Die
[Service-Erkennung](wato_services.html#discovery) funktioniert also wie
bei anderen Services auch automatisch:
:::

:::: imageblock
::: content
![localchecks services](../images/localchecks_services.png)
:::
::::

::: paragraph
Nachdem Sie den Service ins Monitoring übernommen und die Änderungen
aktiviert haben, ist die Einrichtung eines selbst erstellten Services
mit Hilfe eines lokalen Checks bereits abgeschlossen. Falls es bei der
Service-Erkennung zu Problemen kommen sollte, kann Ihnen die
[Fehleranalyse](#diagnose) weiterhelfen.
:::
:::::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#extended_functions .hidden-anchor .sr-only}3. Erweiterte Funktionen {#heading_extended_functions}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::: sect2
### []{#metrics .hidden-anchor .sr-only}3.1. Metriken {#heading_metrics}

::: paragraph
Sie können in einem lokalen Check auch Metriken festlegen. Damit diese
ausgewertet werden, muss der zurückgelieferte Status `P` sein. Die
Berechnung des Zustands erfolgt dann durch Checkmk.
:::

::: paragraph
Die allgemeine Syntax für Metrikdaten ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
metricname=value;warn;crit;min;max
```
:::
::::

::: paragraph
wobei `value` der aktuelle Wert ist, `warn` und `crit` die (oberen)
Schwellwerte festlegen sowie `min` und `max` den Wertebereich
fixieren --- zum Beispiel so:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
count=73;80;90;0;100
```
:::
::::

::: paragraph
Die Werte werden mit Semikolon getrennt. Alle Werte mit Ausnahme von
`value` sind optional. Wird ein Wert nicht benötigt, so bleibt das Feld
leer bzw. wird am Ende weggelassen, wie im Folgenden für `warn`, `crit`
und `max`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
count=42;;;0
```
:::
::::

::: paragraph
**Hinweis:** In den kommerziellen Editionen können die Werte für `min`
und `max` zwar gesetzt werden --- aber nur aus Kompatibilitätsgründen.
Die Begrenzung des zugehörigen Graphen auf einen bestimmten Wertebereich
hat in den kommerziellen Editionen keine Auswirkungen.
:::
::::::::::::::

::::::::: sect2
### []{#metricname .hidden-anchor .sr-only}3.2. Metriknamen {#heading_metricname}

::: paragraph
Bei der Wahl des - hier im Beispiel `metricname` genannten - Bezeichners
dieser Metrik sollten Sie besondere Vorsicht walten lassen. Wir
empfehlen, die Bezeichner mit einem Präfix zu versehen, um
Überschneidungen mit bereits in Checkmk vorhandenen Metriken zu
verhindern.
:::

::: paragraph
Statt also beispielsweise eine Metrik, die die Zahl von derzeit
wartenden Anfragen in einer von Ihnen überwachten Queue angibt, einfach
\'current\' zu nennen, empfehlen wir hier einen klareren Bezeichner mit
einem Präfix - etwa: `mycompany_current_requests`.
:::

::: paragraph
Sollten Sie hier nämlich einen Bezeichner wählen, der bereits in Checkmk
vorhanden ist, würde die Darstellung Ihrer Metriken in Graphen mit den
bereits vorliegenden Definitionen überschrieben.
:::

::: paragraph
Natürlich können Sie auch absichtlich eine bereits vorhandene Metrik aus
Checkmk wiederverwenden. Eine Metrik für eine elektrische Spannung
könnten Sie also bspw. durch die Verwendung des Bezeichners `current`
ohne weiteres in Ihrem lokalen Check nutzen. Im Zweifelsfall müssen Sie
sich die aktuelle Definition dieser Metrik aber in
`~/lib/python3/cmk/gui/plugins/metric` selbsttätig heraussuchen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ grep -r -A 4 'metric_info\["current"\]' ./lib/python3/cmk/gui/plugins/metrics/
```
:::
::::
:::::::::

:::::::::::::::: sect2
### []{#multiple_metrics .hidden-anchor .sr-only}3.3. Mehrere Metriken {#heading_multiple_metrics}

::: paragraph
Sie können auch mehrere Metriken ausgeben lassen. Diese werden dann
durch das \"Pipe\"-Zeichen `|` getrennt, zum Beispiel so:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
count1=42|count2=23
```
:::
::::

::: paragraph
**Achtung:** Auf Windows-Hosts müssen Sie diesen Pipes im Skript noch
einen Zirkumflex (`^`) voranstellen, damit diese Pipes auch in der
Ausgabe ankommen.
:::

::::: listingblock
::: title
mylocalcheck.bat
:::

::: content
``` {.pygments .highlight}
@echo off
echo 0 "My 2nd service" count1=42^|count2=23 A service with 2 graphs
```
:::
:::::

::: paragraph
Eine komplette **Ausgabe** mit zwei Metriken sieht dann etwa so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/mylocalcheck
0 "My 2nd service" count1=42|count2=23 A service with 2 graphs
```
:::
::::

::: paragraph
Nachdem Sie auch den neuen Service ins Monitoring aufgenommen haben,
sehen Sie in der Service-Liste im Feld [Summary]{.guihint} den Text zum
Statusdetail. Nach Anklicken des Services wird die Seite mit den
Service-Details gezeigt. Die Metriken zeigt das Feld
[Details,]{.guihint} und darunter sehen Sie die von Checkmk automatisch
erzeugten Service-Graphen:
:::

:::: imageblock
::: content
![localchecks graphs2](../images/localchecks_graphs2.png)
:::
::::
::::::::::::::::

::::::::::::: sect2
### []{#dynamic_state .hidden-anchor .sr-only}3.4. Status dynamisch berechnen lassen {#heading_dynamic_state}

::: paragraph
In den vorherigen Kapiteln haben Sie erfahren, wie man für Metriken
Schwellwerte festlegen und diese auch in den Graphen anzeigen lassen
kann. Der nächste naheliegende Schritt ist es nun, diese Schwellwerte
für eine dynamische Berechnung des Service-Zustands zu nutzen. Checkmk
bietet genau diese Möglichkeit, um einen lokalen Check auszubauen.
:::

::: paragraph
Wenn Sie im ersten Feld der Ausgabe, das den Status bestimmt, statt
einer Ziffer den Buchstaben `P` übergeben, wird der Service-Zustand
anhand der übergebenen Schwellwerte berechnet.
:::

::: paragraph
Eine Ausgabe würde dann so aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/mylocalcheck
P "My 1st dynamic service" count=40;30;50 Result is computed from two threshold values
P "My 2nd dynamic service" - Result is computed with no values
```
:::
::::

::: paragraph
... und die Anzeige in einer Service-Ansicht so:
:::

:::: imageblock
::: content
![localchecks dynsrv](../images/localchecks_dynsrv.png)
:::
::::

::: paragraph
Die Anzeige unterscheidet sich in zwei Punkten von derjenigen, die
bisher zu sehen war:
:::

::: ulist
- Für Services im Zustand [WARN]{.state1} oder [CRIT]{.state2} zeigt die
  [Summary]{.guihint} des Services alle wichtigen Informationen der
  Metriken (Name, Wert, Schwellwerte). So können Sie immer
  nachvollziehen, wie dieser Zustand aus einem Wert berechnet wurde. Für
  alle anderen Zustände werden die Metrikinformationen nur im Feld
  [Details]{.guihint} angezeigt.

- Wenn keine Metriken übergeben werden, ist der Service-Zustand immer
  [OK]{.state0}.
:::
:::::::::::::

::::::::::::::::: sect2
### []{#upper_lower_thresholds .hidden-anchor .sr-only}3.5. Obere und untere Schwellwerte {#heading_upper_lower_thresholds}

::: paragraph
Manche Parameter haben nicht nur obere, sondern auch untere
Schwellwerte. Ein Beispiel dafür ist die Luftfeuchtigkeit. Für solche
Fälle bietet der lokale Check die Möglichkeit, jeweils zwei Schwellwerte
für die Zustände [WARN]{.state1} und [CRIT]{.state2} zu übergeben. Sie
werden durch einen Doppelpunkt getrennt und stellen jeweils den unteren
und den oberen Schwellwert dar.
:::

::: paragraph
In der allgemeinen Syntax sieht das so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
metricname=value;warn_lower:warn_upper;crit_lower:crit_upper
```
:::
::::

::: paragraph
... im Beispiel so:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/mylocalcheck
P "My 3rd service" humidity=37;40:60;30:70 A service with lower and upper thresholds
```
:::
::::

::: paragraph
... und in der Anzeige einer Service-Ansicht so:
:::

:::: imageblock
::: content
![localchecks lower](../images/localchecks_lower.png)
:::
::::

::: paragraph
Falls es Ihnen nur um untere Schwellwerte geht, lassen Sie die Felder
der oberen Schwellwerte weg:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/mylocalcheck
P "My 4th dynamic service" count_lower=37;40:;30: A service with lower thresholds only
```
:::
::::

::: paragraph
Mit dieser Ausgabe legen Sie fest, dass der Service bei einem Wert
kleiner 40 [WARN]{.state1} und kleiner 30 [CRIT]{.state2} werden soll:
beim festgelegten Wert 37 wird der Service also den
[WARN]{.state1}-Zustand erhalten.
:::
:::::::::::::::::

::::::::: sect2
### []{#multi-line .hidden-anchor .sr-only}3.6. Mehrzeilige Ausgaben {#heading_multi-line}

::: paragraph
Auch die Option, die Ausgabe über mehrere Zeilen zu verteilen, steht
Ihnen zur Verfügung. Da Checkmk unter Linux läuft, können Sie mit der
Escape-Sequenz `\n` arbeiten, um einen Zeilenumbruch zu erzwingen. Auch
wenn Sie, bedingt durch die Skriptsprache, den Backslash selbst
maskieren müssen, wird das von Checkmk korrekt interpretiert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/mylocalcheck
P "My service" humidity=37;40:60;30:70 My service output\nA line with details\nAnother line with details
```
:::
::::

::: paragraph
In den Details des Services können Sie dann diese zusätzlichen Zeilen
unter der [Summary]{.guihint} sehen:
:::

:::: imageblock
::: content
![localchecks srv details](../images/localchecks_srv_details.png)
:::
::::
:::::::::

::::::::::::::::::::: sect2
### []{#cache .hidden-anchor .sr-only}3.7. Asynchron ausführen und Ausgabe zwischenspeichern {#heading_cache}

::: paragraph
Die Ausgabe lokaler Checks kann, wie auch die von Agenten-Plugins,
zwischengespeichert werden (*caching*). Das kann nützlich sein, wenn
Skripte längere Zeit zur Ausführung benötigen. Ein solches Skript wird
dann asynchron und nur in einem definierten Zeitintervall ausgeführt und
die letzte Ausgabe zwischengespeichert. Wird der Agent vor Ablauf der
Zeit erneut abgefragt, verwendet er für den lokalen Check diesen Cache
und liefert ihn in der Agentenausgabe zurück.
:::

::: paragraph
**Hinweis**: Das Caching steht nur für AIX, FreeBSD, Linux, OpenWrt und
Windows zur Verfügung.
:::

::::::::::: sect3
#### []{#_konfiguration_unter_linux .hidden-anchor .sr-only}Konfiguration unter Linux {#heading__konfiguration_unter_linux}

::: paragraph
Unter Linux oder einem anderen Unix-artigen Betriebssystem kann jedes
Plugin asynchron ausgeführt werden. Für einen lokalen Check ist die
notwendige Konfiguration sehr ähnlich zu der eines
[Plugins](agent_linux.html#async_plugins). Legen Sie dazu ein
Unterverzeichnis an, das so heißt, wie die Anzahl der Sekunden, die die
Ausgabe zwischengespeichert werden soll und legen Sie Ihr Skript in
diesem Unterverzeichnis ab.
:::

::: paragraph
In folgenden Beispiel wird der lokale Check nur alle 10 Minuten (600
Sekunden) ausgeführt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/local/600/mylocalcheck
2 "My cached service" count=4 Some output of a long running script
```
:::
::::

::: paragraph
Die zwischengespeicherten Daten werden in ein
[Cache-Verzeichnis](#folders_cache) geschrieben.
:::

::: paragraph
Für einen Service, der zwischengespeicherte Daten liefert, werden die
Cache-spezifischen Informationen in der Service-Ansicht hinzugefügt:
:::

:::: imageblock
::: content
![localchecks srv cached](../images/localchecks_srv_cached.png)
:::
::::
:::::::::::

::::::::: sect3
#### []{#_konfiguration_unter_windows .hidden-anchor .sr-only}Konfiguration unter Windows {#heading__konfiguration_unter_windows}

::: paragraph
Unter Windows erfolgt die Konfiguration ebenfalls analog zu der eines
[Plugins](agent_windows.html#customizeexecution). Statt mit einem
speziellen Unterverzeichnis wie bei Linux & Co werden die Optionen in
einer Konfigurationsdatei gesetzt:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
local:
    enabled: yes
    execution:
        - pattern     : $CUSTOM_LOCAL_PATH$\mylocalcheck.bat
          async       : yes
          run         : yes
          cache_age   : 600
```
:::
:::::

::: paragraph
Wie Sie oben sehen, können Sie unter Windows die asynchrone Ausführung
(mit `async`) und das Zeitintervall (mit `cache_age`) getrennt
konfigurieren.
:::

::: paragraph
Alternativ können Sie die Konfiguration unter Windows auch in der
[Agentenbäckerei](#bakery) durchführen.
:::
:::::::::
:::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}4. Verteilung über die Agentenbäckerei {#heading_bakery}

::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie die
[Agentenbäckerei](wato_monitoringagents.html#bakery) bereits nutzen,
können Sie die Skripte mit lokalen Checks auch über diesen Weg an
mehrere Hosts verteilen.
:::

::: paragraph
Erstellen Sie dazu auf dem Checkmk-Server als Instanzbenutzer unterhalb
von `~/local/share/check_mk/agents/` zuerst das Verzeichnis `custom` und
darin für jedes Paket von lokalen Checks einen Unterverzeichnisbaum:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cd ~/local/share/check_mk/agents
OMD[mysite]:~$ ~/local/share/check_mk/agents$ mkdir -p custom/mycustompackage/lib/local/
```
:::
::::

::: paragraph
Das Paketverzeichnis im obigen Beispiel ist `mycustompackage`. Darunter
markiert das `lib`-Verzeichnis das Skript als Plugin oder lokalen Check.
Das nachfolgende Verzeichnis `local` ordnet die Datei dann eindeutig zu.
Legen Sie in diesem Verzeichnis das Skript mit dem lokalen Check ab.
:::

::: paragraph
**Wichtig:** Unter Linux können Sie die asynchrone Ausführung analog
konfigurieren wie im [vorherigen Kapitel](#cache) beschrieben, indem Sie
nun unter `custom/mycustompackage/lib/local/` ein Verzeichnis mit der
Sekundenzahl des Ausführungsintervalls erzeugen und dort das Skript
ablegen. Unter Windows können Sie dafür die Regelsätze [Set execution
mode for plugins and local checks]{.guihint} und [Set cache age for
plugins and local checks]{.guihint} nutzen. Diese und weitere Regelsätze
für lokale Checks unter Windows finden Sie in der Agentenbäckerei unter
[Agent rules \> Windows Agent]{.guihint}.
:::

::: paragraph
In der Konfigurationsumgebung von Checkmk wird dann das Paketverzeichnis
`mycustompackage` als neue Option angezeigt: Öffnen Sie [Setup \> Agents
\> Windows, Linux, Solaris, AIX]{.guihint}, erstellen Sie eine neue
Regel mit [Agents \> Agent rules \> Generic options \> Deploy custom
files with agent]{.guihint} und wählen Sie das eben erstellte Paket aus:
:::

:::: imageblock
::: content
![localchecks custom](../images/localchecks_custom.png)
:::
::::

::: paragraph
Checkmk wird nun selbstständig den lokalen Check im Installationspaket
der jeweiligen Betriebssysteme richtig einordnen. Nachdem Sie die
Änderungen aktiviert und die Agenten gebacken haben, sind Sie mit der
Konfiguration auch schon fertig. Die Agenten müssen nun nur noch neu
verteilt werden.
:::
:::::::::::::
::::::::::::::

:::::::::::::::::::::::::: sect1
## []{#diagnose .hidden-anchor .sr-only}5. Fehleranalyse {#heading_diagnose}

::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_skript_testen .hidden-anchor .sr-only}5.1. Skript testen {#heading__skript_testen}

::: paragraph
Wenn Sie bei einem selbst geschriebenen Skript auf Probleme stoßen,
sollten Sie die folgenden potentiellen Fehlerquellen prüfen:
:::

::: ulist
- Liegt das Skript im richtigen [Verzeichnis](#folders_script)?

- Ist das Skript ausführbar und stimmen die Zugriffsberechtigungen? Das
  ist vor allem relevant, wenn Sie den Agenten oder das Skript nicht
  unter root oder dem LocalSystem-Konto ausführen.

- Ist die Ausgabe konform zur vorgegebenen Syntax? Die Ausgabe des
  lokalen Checks muss der Syntax entsprechen, wie sie in den Kapiteln
  [Skript erstellen](#syntax) und [Erweiterte
  Funktionen](#extended_functions) beschrieben ist. Andernfalls kann die
  fehlerfreie Ausführung nicht garantiert werden.

  ::: paragraph
  Probleme und Fehler können insbesondere dann entstehen, wenn ein
  lokaler Check eine Aufgabe erfüllen soll, die ein [vollwertiges
  Check-Plugin](devel_intro.html) erfordert, beispielsweise, wenn die
  Ausgabe des lokalen Checks selbst einen Sektions-Header (*section
  header*) enthält oder die Definition eines Host-Namens, wie er beim
  Transport von [Piggyback-Daten](piggyback.html) verwendet wird.
  :::
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Beim direkten Aufruf des          |
|                                   | Agentenskripts oder des Plugins   |
|                                   | in einer Shell unter Linux stehen |
|                                   | möglicherweise andere             |
|                                   | [Umgebungsvariabl                 |
|                                   | en](https://wiki.debian.org/Envir |
|                                   | onmentVariables){target="_blank"} |
|                                   | zur Verfügung als beim Aufruf     |
|                                   | durch den Agent Controller des    |
|                                   | [Checkmk-Agenten.](w              |
|                                   | ato_monitoringagents.html#agents) |
|                                   | Unter Windows kommt hinzu, dass   |
|                                   | der Agent Controller unter dem    |
|                                   | LocalSystem-Konto läuft, der      |
|                                   | Aufruf im Terminal aber unter     |
|                                   | einem normalen Benutzer oder      |
|                                   | Administrator erfolgt. Zusätzlich |
|                                   | zur anderen Umgebung kann dies    |
|                                   | fehlende Berechtigungen bedeuten. |
|                                   | Um die Ausgabe des Agentenskripts |
|                                   | möglichst nahe an den Bedingungen |
|                                   | zu analysieren, unter denen der   |
|                                   | Checkmk-Agent aufgerufen wird,    |
|                                   | sollten Sie daher nach            |
|                                   | Möglichkeit den [Agent Controller |
|                                   | im                                |
|                                   | Dump-Modus]                       |
|                                   | (agent_linux.html#agent_ctl_dump) |
|                                   | verwenden.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::

::::::::::: sect2
### []{#_agentenausgabe_auf_dem_ziel_host_testen .hidden-anchor .sr-only}5.2. Agentenausgabe auf dem Ziel-Host testen {#heading__agentenausgabe_auf_dem_ziel_host_testen}

::: paragraph
Wenn das Skript selbst korrekt ist, können Sie den Agenten auf dem Host
ausführen. Bei Unix-artigen Betriebssystemen, wie Linux, BSD und so
weiter, bietet sich der Befehl `grep` an, um nach einem bestimmten
Textmuster zu suchen. Mit der Option `-A` bestimmen Sie die Anzahl der
zusätzlichen Zeilen, die nach einem Treffer angezeigt werden sollen. Sie
können diese Zahl entsprechend der Anzahl der erwarteten Ausgabezeilen
anpassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl dump | grep -v grep | grep -A2 "<<<local"
<<<local:sep(0)>>>
P "My service" humidity=37;40:60;30:70 My service output\nA line with details\nAnother line with details
cached(1618580356,600) 2 "My cached service" count=4 Some output of a long running script
```
:::
::::

::: paragraph
In der letzten Zeile erkennen Sie einen zwischengespeicherten Service an
der vorangestellten `cache`-Information mit der aktuellen Unixzeit und
dem Ausführungsintervall in Sekunden.
:::

::: paragraph
Unter Windows können Sie mit der PowerShell und dem „Cmdlet"
`Select-String` ein sehr ähnliches Resultat erreichen wie mit dem
`grep`-Befehl unter Linux. Im folgenden Befehl bestimmen die beiden
Ziffern hinter dem Parameter `Context` wie viele Zeilen vor und nach dem
Treffer ausgegeben werden sollen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\Program Files (x86)\checkmk\service> ./cmk-agent-ctl.exe dump | Select-String -Pattern "<<<local" -Context 0,3
> <<<local:sep(0)>>>
  0 "My 1st service" - This static service is always OK

  cached(1618580520,600) 1 "My cached service on Windows" count=4 Some output of a long running script
```
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Je nach Umgebung, verwendeter     |
|                                   | Programmiersprache,               |
|                                   | Windows-Version und einigen       |
|                                   | weiteren Bedingungen, sind Sie    |
|                                   | oft unter Windows mit dem         |
|                                   | Zeichensatz *UTF-16*              |
|                                   | konfrontiert. Zudem ist dort      |
|                                   | häufig die Kombination aus        |
|                                   | *Carriage Return* und *Line Feed* |
|                                   | für Zeilenumbrüche anzutreffen.   |
|                                   | Checkmk als Linux-Anwendung       |
|                                   | erwartet aber ohne wenn und aber  |
|                                   | *UTF-8* und einfache *Line        |
|                                   | Feeds.* Der Zeichensatz-bezogenen |
|                                   | Fehlersuche widmen wir im Artikel |
|                                   | zu Spool-Verzeichnis ein [eigenes |
|                                   | Kapite                            |
|                                   | l.](spool_directory.html#charset) |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::

::::::::::: sect2
### []{#_agentenausgabe_auf_dem_checkmk_server_testen .hidden-anchor .sr-only}5.3. Agentenausgabe auf dem Checkmk-Server testen {#heading__agentenausgabe_auf_dem_checkmk_server_testen}

::: paragraph
Zuletzt können Sie die Verarbeitung der Skriptausgaben auch auf dem
Checkmk-Server mit dem Befehl `cmk` testen --- einmal die
Service-Erkennung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -IIv --detect-plugins=local mycmkserver
Discovering services and host labels on: mycmkserver
mycmkserver:
...
+ EXECUTING DISCOVERY PLUGINS (1)
  2 local
SUCCESS - Found 2 services, no host labels
```
:::
::::

::: paragraph
... und mit einem ähnlichen Befehl auch die Verarbeitung der
Serviceausgabe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -nv --detect-plugins=local mycmkserver
Checkmk version 2.0.0p2
+ FETCHING DATA
...
+ PARSE FETCHER RESULTS
Received no piggyback data
My cached service    Some output of a long running script(!!), Cache generated 6 minutes 52 seconds ago, Cache interval: 10 minutes 0 seconds, Elapsed cache lifespan: 68.71%
My service           My service output\, humidity: 37.00 (warn/crit below 40.00/30.00)(!)
```
:::
::::

::: paragraph
Für beide Befehle haben wir die Ausgabe um für dieses Thema nicht
relevante Zeilen gekürzt.
:::

::: paragraph
Wenn es in den lokalen Checks Fehler gibt, wird Checkmk Sie in der
Serviceausgabe darauf hinweisen. Das gilt sowohl für fehlerhafte
Metriken, als auch für falsche, unvollständige Informationen in der
Skriptausgabe oder einen ungültigen Status. Diese Fehlermeldungen sollen
Ihnen helfen, die Fehler in den Skripten schnell zu identifizieren.
:::
:::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::: sect1
## []{#folders .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading_folders}

:::::: sectionbody
::: sect2
### []{#folders_script .hidden-anchor .sr-only}6.1. Skript-Verzeichnis auf dem Ziel-Host {#heading_folders_script}

+---------------------------------------------+------------------------+
| Pfad                                        | Betriebssystem         |
+=============================================+========================+
| `/usr/check_mk/lib/local/`                  | AIX                    |
+---------------------------------------------+------------------------+
| `/usr/local/lib/check_mk_agent/local/`      | FreeBSD                |
+---------------------------------------------+------------------------+
| `/usr/lib/check_mk_agent/local/`            | HP-UX, Linux, OpenBSD, |
|                                             | OpenWrt und Solaris    |
+---------------------------------------------+------------------------+
| `%ProgramData%\checkmk\agent\local`         | Windows                |
+---------------------------------------------+------------------------+
:::

:::: sect2
### []{#folders_cache .hidden-anchor .sr-only}6.2. Cache-Verzeichnis auf dem Ziel-Host {#heading_folders_cache}

::: paragraph
Hier werden zwischengespeicherte Daten einzelner Sektionen, u.a. der
`local` Sektion, abgelegt und dem Agenten, solange die Daten gültig
sind, bei jeder Ausführung wieder angehängt.
:::

+---------------------------------------------+------------------------+
| Pfad                                        | Betriebssystem         |
+=============================================+========================+
| `/tmp/check_mk/cache/`                      | AIX                    |
+---------------------------------------------+------------------------+
| `/var/run/check_mk/cache/`                  | FreeBSD                |
+---------------------------------------------+------------------------+
| `/var/lib/check_mk_agent/cache/`            | Linux, OpenWrt und     |
|                                             | Solaris                |
+---------------------------------------------+------------------------+
::::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
