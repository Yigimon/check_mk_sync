:::: {#header}
# Dateien überwachen

::: details
[Last modified on 18-Nov-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/mk_filestats.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html) [Services verstehen und
konfigurieren](wato_services.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#basics .hidden-anchor .sr-only}1. Grundlagen zur Dateiüberwachung {#heading_basics}

::::::: sectionbody
::: paragraph
Mit Checkmk können Sie Dateien bezüglich Anzahl, Größe und Alter
überwachen, einzeln oder in Gruppen. Diese Funktion lässt sich äußerst
vielfältig einsetzen. Beispielsweise lässt sich damit der Erfolg von
Backup-Strategien überwachen: Ist die richtige Anzahl an Archiven
vorhanden? Ist keines der Backups älter als X Tage? Ist eines der
Backups verdächtig groß oder klein? Sie können auch unternehmensweite
Dateiserver darauf abklopfen, ob Nutzer diese als private Ablage für
Filme missbrauchen. Oder ganz klassisch Auslagerungs- oder flüchtige
Dateien wie Container im Auge behalten.
:::

::: paragraph
Das grundsätzliche Vorgehen entspricht dem Checkmk-Standard: Im Agenten
wird ein Plugin/eine Konfiguration installiert, das die gewünschten
Informationen über Dateien oder Dateigruppen ins Monitoring bringt. Dort
wird dann über entsprechende Regelsätze bestimmt, welche Eigenschaften
zu welchen Status führen.
:::

::: paragraph
Die eigentliche Filterung, also welche Daten überhaupt im Monitoring
landen, geschieht im Agenten. Sie können hier über Globbing-Muster
beispielsweise Dateien ganzer Verzeichnisse rekursiv einbeziehen oder
auch nur bestimmte Dateitypen oder gar einzelne Dateien. Über
Globbing-Muster wie `/myfiles/*.*` können dabei unter Umständen enorm
große Dateilisten entstehen, obwohl Sie vielleicht nur an besonders
alten oder großen Dateien interessiert sind. Diesem Umstand ist es
geschuldet, dass es derzeit zwei Agenten- und zugehörige
Monitoring-Regelsätze gibt: Das ältere *fileinfo* ist bereits im Agenten
eingebaut und filtert nur nach Globbing-Muster/Pfad, das neuere
*mk_filestats* muss als Plugin separat installiert werden und filtert
nach weiteren Eigenschaften.
:::

::: paragraph
Es gibt noch weitere Unterschiede zwischen mk_filestats und fileinfo,
die wir im Folgenden aufzeigen werden. Der wichtigste Unterschied:
mk_filestats kann nur Linux-Hosts überwachen, fileinfo hingegen auch
Windows-Hosts. Für Linux-Hosts sollten Sie in der Regel das aktuellere
mk_filestats verwenden.
:::
:::::::
::::::::

::::::::::::: sect1
## []{#differences .hidden-anchor .sr-only}2. Unterschiede mk_filestats und fileinfo {#heading_differences}

:::::::::::: sectionbody
::: paragraph
Wenn Sie die Regelsätze der beiden Varianten der Übersicht halber
nebeneinander sehen wollen, geben Sie einfach im [Setup]{.guihint}-Menü
`size age` ein. Die Regeln für einzelne Dateien und Gruppen heißen
(weitgehend) identisch, die mk_filestats-Regeln sind aber explizit als
solche ausgewiesen. Beide Varianten von Service-Regeln gibt es
zusätzlich als [erzwungene
Services.](wato_services.html#enforced_services)
:::

::::: imageblock
::: content
![Setup-Menü mit mk_filestats- und
fileinfo-Einträgen.](../images/filestats_setup_menu.png)
:::

::: title
fileinfo-Regeln sind nicht explizit gekennzeichnet
:::
:::::

::: paragraph
Unterschiede der beiden Varianten gibt es auf Agenten- und
Service-Ebene. Hier zunächst die groben theoretischen Unterschiede. Die
Details sehen Sie dann im Anschluss in den konkreten Anleitungen für das
Agentenplugin mk_filestats und für fileinfo des Agenten.
:::

::: paragraph
Beim Agenten zeichnet sich mk_filestats durch zwei Möglichkeiten aus,
die fileinfo fehlen: mk_filestats bietet zum einen die bereits erwähnten
zusätzlichen Filtermöglichkeiten, nämlich nach Dateigröße, -anzahl und
-name, letzteres in Form [regulärer Ausdrücke.](regexes.html) So könnten
Sie bei einem Globbing-Muster `/myfiles/*` beispielsweise nur die
Dateien ins Monitoring holen, die größer als 1 KB sind und `backup`
irgendwo im Dateinamen haben. Zum anderen werden bei mk_filestats auch
Dateigruppen direkt in der Plugin-Konfiguration festgelegt, ganz
einfach, indem mehrere Filter angelegt werden, die dann jeweils als
eigene [Sektion](wato_monitoringagents.html#diagnostics) in der
Agentenausgabe landen und später über die Sektionsnamen von Regeln
angesprochen werden können.
:::

::: paragraph
Bei den **Service-Monitoring-Regeln** unterscheiden sich die Wege von
mk_filestats und fileinfo eher im Detail. Beide können Auswertungen auf
bestimmte [Zeitperioden](timeperiods.html) beschränken, aber nur
fileinfo ermöglicht die explizite Angabe von Zeitfenstern pro Tag direkt
in der Regel. Ebenfalls exklusiv kann fileinfo für Dateigruppen so
genannte [Conjunctions]{.guihint} konfigurieren. Dabei wird für jeden
Status eine Reihe von Bedingungen verknüpft, also zum Beispiel: „Der
Status geht auf [CRIT]{.state2}, sobald die älteste Datei der Gruppe
genau 5 Stunden alt **und** die kleinste Datei genau 8 Megabyte groß
ist." Im Gegenzug liefert mk_filestats für Dateigruppen die Option,
Ausreißer zu definieren: Angenommen, eine Dateigruppe soll auf
[CRIT]{.state2} gehen, sobald die Gruppengröße 2 Gigabyte übersteigt.
Wenn die Gruppe aber **nicht** auf [CRIT]{.state2} gehen soll, wenn eine
bestimmte einzelne Datei allein schon auf über 1 Gigabyte kommt (etwa
eine temporäre Datei), so können Sie dies als Sonderfall definieren und
die Gruppenregel damit fallweise überschreiben.
:::

::: paragraph
Die Unterschiede in der Übersicht:
:::

+-------------+---------------------------+---------------------------+
| Feature     | mk_filestats              | fileinfo                  |
+=============+===========================+===========================+
| Überwachte  | Linux                     | Linux und Windows         |
| Betr        |                           |                           |
| iebssysteme |                           |                           |
+-------------+---------------------------+---------------------------+
| Agent       | Agentenplugin             | Im Agenten enthalten      |
+-------------+---------------------------+---------------------------+
| Filter      | Filtert direkt im Agenten | Filtert im Agenten nur    |
|             | nach Globbing-Muster und  | nach Globbing-Muster      |
|             | Eigenschaften             |                           |
+-------------+---------------------------+---------------------------+
| Dateilisten | Liefert schlanke          | Liefert bisweilen         |
|             | Dateilisten               | ausschweifende            |
|             |                           | Dateilisten               |
+-------------+---------------------------+---------------------------+
| Datei       | Gruppiert direkt im       | Gruppiert über einen      |
| gruppierung | Agenten                   | separaten                 |
|             |                           | Monitoring-Regelsatz      |
+-------------+---------------------------+---------------------------+
| Anzeige von | Zeigt optional Dateien in | Zeigt immer Dateien in    |
| Dateien     | den Service-Details       | den Service-Details       |
+-------------+---------------------------+---------------------------+
| Date        | Kann Ausreißer bei den    | Kann Zusammenhänge        |
| iauswertung | Dateien berücksichtigen   | zwischen Dateien          |
|             |                           | berücksichtigen           |
+-------------+---------------------------+---------------------------+

::: paragraph
In den folgenden Kapiteln sehen Sie nun die beiden Funktionen einzeln im
praktischen Einsatz --- dabei sollten die geschilderten Unterschiede und
Features deutlich werden. mk_filestats liefert zudem selbst ausführliche
Informationen über den Aufruf `filestats.py --help`.
:::
::::::::::::
:::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#mk_filestats .hidden-anchor .sr-only}3. Dateien überwachen mit mk_filestats (Linux) {#heading_mk_filestats}

::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im folgenden Beispiel sehen Sie das Vorgehen für Gruppen von Dateien.
Bei einzelnen Dateien ist das Prozedere identisch, es gibt lediglich
weniger Optionen. Angenommen, Sie möchten eine **Gruppe** von
Backup-Dateien (`mybackup_01.zip` etc.) überwachen, die eine bestimmte
Anzahl haben und eine minimale Größe nicht unterschreiten sollen, dann
können Sie wie folgt vorgehen:
:::

:::::::::::::::::::::: sect2
### []{#mk_filestats_agent_rule .hidden-anchor .sr-only}3.1. Regel für das Agentenplugin konfigurieren {#heading_mk_filestats_agent_rule}

:::::::::: sect3
#### []{#_konfiguration_über_agentenbäckerei .hidden-anchor .sr-only}Konfiguration über Agentenbäckerei {#heading__konfiguration_über_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen rufen Sie zunächst die Regel für das
Agentenplugin [Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agent
rules \> Count, size and age of files - mk_filestats (Linux)]{.guihint}
auf. Unter [Section name]{.guihint} vergeben Sie einen beliebigen Namen,
der so später in der Agentenausgabe als eigenständige Sektion erscheint.
:::

::: paragraph
Unter [Globbing pattern for input files]{.guihint} geben Sie dann an,
welche Dateien überwacht werden sollen. Dabei können Sie Globbing-Muster
nutzen, also letztlich Pfadangaben mit Platzhaltern. Hier soll es bei
einer absoluten Pfadangabe bleiben, die alle Dateien im angegebenen
Ordner einbezieht.
:::

::: paragraph
Die weitere Filterung übernehmen hier die nächsten beiden Optionen:
[Filter files by matching regular expression]{.guihint} inkludiert
Dateien nach angegebenem Muster, hier Dateien mit `my` irgendwo im
Namen. [Filter files by not matching regular expression]{.guihint}
exkludiert dann Dateien, hier solche, die auf `tmp` enden.
:::

::::: imageblock
::: content
![Formular zur Konfiguration des Agentenplugins
mk_filestats.](../images/filestats_agent_rule.png)
:::

::: title
Achten Sie auf die Unterscheidung von Globs und regulären Ausdrücken
:::
:::::

::: paragraph
Damit ist die Konfiguration abgeschlossen und Sie können das Plugin samt
Konfiguration über die [Agentenbäckerei
verteilen.](agent_linux.html#install_plugins_using_bakery)
:::
::::::::::

:::::::: sect3
#### []{#_manuelle_konfiguration .hidden-anchor .sr-only}Manuelle Konfiguration {#heading__manuelle_konfiguration}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** konfigurieren Sie das Plugin wie üblich über eine
Textdatei: Eine Beispielkonfiguration finden Sie als Instanzbenutzer in
der Datei `share/check_mk/agents/cfg_examples/filestats.cfg`. Eine
Konfiguration gemäß obiger Vorgaben sieht dann so aus:
:::

::::: listingblock
::: title
/etc/check_mk/filestats.cfg
:::

::: content
``` {.pygments .highlight}
[myfiles]
input_patterns: /media/evo/myfiles/
filter_regex: .*my.*
filter_regex_inverse: tmp$
```
:::
:::::

::: paragraph
Damit ist die Konfiguration abgeschlossen und Sie können das
Agentenplugin [manuell installieren.](agent_linux.html#manualplugins)
:::
::::::::

::::::: sect3
#### []{#_daten_in_der_agentenausgabe .hidden-anchor .sr-only}Daten in der Agentenausgabe {#heading__daten_in_der_agentenausgabe}

::: paragraph
Das Ergebnis Ihrer Konfiguration finden Sie dann in Form von Rohdaten in
der Agentenausgabe:
:::

::::: listingblock
::: title
mysite-myhost-agent.txt
:::

::: content
``` {.pygments .highlight}
<<<filestats:sep(0)>>>
[[[file_stats myfiles]]]
{'type': 'file', 'path': '/media/evo/myfiles/mybackup_01.zip', 'stat_status': 'ok', 'size': 13146562, 'age': 339080, 'mtime': 1633966263}
{'type': 'file', 'path': '/media/evo/myfiles/mybackup_02.zip', 'stat_status': 'ok', 'size': 13145766, 'age': 325141, 'mtime': 1633980202}
{'type': 'file', 'path': '/media/evo/myfiles/mybackup_03.zip', 'stat_status': 'ok', 'size': 13151050, 'age': 325352, 'mtime': 1633979991}
...
```
:::
:::::
:::::::
::::::::::::::::::::::

:::::::::::::::::::: sect2
### []{#mk_filestats_service_rule .hidden-anchor .sr-only}3.2. Service-Regel konfigurieren {#heading_mk_filestats_service_rule}

::: paragraph
Über den Agenten stehen dem Monitoring jetzt also die Daten zu den
Dateien zur Verfügung. Zur Auswertung rufen Sie die Regel [Setup \>
Services \> Service monitoring rules \> Size, age and count of file
groups (mk_filestats)]{.guihint} auf. In unserem Beispiel soll gewarnt
werden, sobald eine bestimmte Anzahl von Dateien über- oder
unterschritten wird. Das erledigen die Optionen [Minimal file
count]{.guihint} und [Maximal file count]{.guihint}, über die schlicht
Grenzwerte eingetragen werden. Alle anderen Minimal-Maximal-Optionen
arbeiten analog.
:::

::::: imageblock
::: content
![Formular mit Grenzwerten für
Dateiüberwachung.](../images/filestats_service_rule_group_value_1.png)
:::

::: title
Teil 1/3: [OK]{.state0} sind hier ausschließlich 7 oder 8 Dateien
:::
:::::

::: paragraph
Aber welche Datei provoziert dann beispielsweise einen
[CRIT]{.state2}-Status? Dabei hilft die Option [Show files in service
details]{.guihint}: Ist diese aktiviert, sehen Sie alle betroffenen
Dateien aufgelistet in der Detailansicht des Services.
:::

::::: {#showfiles .imageblock}
::: content
![Festlegung zur Anzeige einzelner Dateien in den
Service-Details.](../images/filestats_service_rule_group_value_2.png)
:::

::: title
Teil 2/3: Die Option sorgt für Transparenz --- kann aber auch sehr lange
Listen erzeugen
:::
:::::

::: paragraph
Nun könnte es sein, dass zwar die richtige Anzahl an Dateien vorhanden
ist, es aber beispielsweise Ausreißer bezüglich der Größe gibt. Für
solche Ausnahmen können Sie die Option [Additional rules for
outliers]{.guihint} einsetzen: Hier wird zum Beispiel festgelegt, dass
für Dateien unterhalb von 5 Megabyte der Status [WARN]{.state1} gesetzt
wird, unter 1 Megabyte geht der Service auf [CRIT]{.state2}. Nützlich
ist das zum Beispiel, um auf defekte Backups aufmerksam zu werden.
:::

::::: imageblock
::: content
![Festlegung von Ausreißern in den überwachten
Dateien.](../images/filestats_service_rule_group_value_3.png)
:::

::: title
Teil 3/3: Dateien müssen mindestens 5 MB groß sein, sonst wird gewarnt
:::
:::::

::: paragraph
Im Kasten [Conditions]{.guihint} können Sie nun noch bestimmen, dass die
Regel ausschließlich für die im Agentenplugin konfigurierte Dateigruppe
`myfiles` gelten soll: Geben Sie dazu unter [File Group Name]{.guihint}
den Namen ein, den Sie im Agentenplugin unter [Section name]{.guihint}
vergeben haben.
:::

::::: imageblock
::: content
![Filter auf Dateien der Gruppe
myfiles.](../images/filestats_service_rule_group_condition.png)
:::

::: title
[File Group Name]{.guihint} entspricht dem [Section name]{.guihint} aus
der Plugin-Regel
:::
:::::

::: paragraph
Damit ist auch die Service-Regel fertig. Optional könnten Sie die
Auswertung noch auf eine [Zeitperiode](timeperiods.html) beschränken.
Fügen Sie anschließend wie üblich den neuen Service zu den betroffenen
Hosts hinzu und aktivieren Sie die Änderungen.
:::
::::::::::::::::::::

::::::::::: sect2
### []{#mk_filestats_monitoring .hidden-anchor .sr-only}3.3. mk_filestats im Monitoring {#heading_mk_filestats_monitoring}

::: paragraph
Die Auswertung sehen Sie dann im Monitoring in Listen und natürlich in
den Details. Neben den Parametern des Services sehen Sie hier nun auch
die Dateien, die für den Status [WARN]{.state1} beziehungsweise
[CRIT]{.state2} verantwortlich sind.
:::

::::: imageblock
::: content
![Service-Details im Monitoring für den Status
WARN.](../images/filestats_service_monitoring.png)
:::

::: title
mk_filestats offenbart im Monitoring, welche Dateien für den Status
verantwortlich sind
:::
:::::

::: paragraph
Bei der Option [Show files in service details](#showfiles) ist jedoch
Vorsicht angeraten: Wenn viele Dateien für eine Statusänderung sorgen,
werden sie auch alle aufgeführt, was zu langen Listen und damit
verbundenen Problemen mit Performance und Ansichten führen kann.
:::

::::: imageblock
::: content
![Service-Details im Monitoring für den Status
CRIT.](../images/filestats_many_files.png)
:::

::: title
Allzu offenherzige reguläre Ausdrücke können riesige Listen erzeugen
:::
:::::
:::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#fileinfo .hidden-anchor .sr-only}4. Dateien überwachen mit fileinfo (Linux, Windows) {#heading_fileinfo}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die Überwachung von Dateien mit fileinfo läuft prinzipiell genauso wie
mit mk_filestats, daher das Prozedere hier leicht verkürzt, abermals für
Dateigruppen.
:::

:::::::::::::::::::::::::::::::::::::::: sect2
### []{#fileinfo_agent_rule .hidden-anchor .sr-only}4.1. Regel für den Agenten konfigurieren {#heading_fileinfo_agent_rule}

::::::::::::::::::::: sect3
#### []{#_konfiguration_über_agentenbäckerei_2 .hidden-anchor .sr-only}Konfiguration über Agentenbäckerei {#heading__konfiguration_über_agentenbäckerei_2}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Konfiguration
des Agenten in den kommerziellen Editionen unter [Setup \> Agents \>
Windows, Linux, Solaris, AIX \> Agent rules \> Count, size and age of
files (Linux, Windows)]{.guihint} ist deutlich einfacher gehalten: Sie
definieren hier lediglich den Pfad für die Dateien in Form eines
Globbing-Musters. Das wirft eben auch das Problem auf, dass eventuell
extrem lange Dateilisten übertragen werden, die das Monitoring spürbar
verlangsamen können.Außerdem wird standardmäßig für jede gefundene Datei
ein eigener Service angelegt, was sich lediglich durch Gruppenbildung
verhindern lässt.
:::

::::: imageblock
::: content
![Regel für fileinfo mit Filterung auf
Windows-Pfad.](../images/filestats_fileinfo_agent_rule.png)
:::

::: title
Überwachung aller Dateien in angegebenen Verzeichnis
:::
:::::

::: paragraph
**Alle Unterverzeichnisse einbeziehen:** Ausschließlich auf Windows-Host
können Sie mit dem sogenannten Globstar (zwei aufeinanderfolgende
Sternchen) auch gleich alle Dateien in **allen** Unterverzeichnissen
einbeziehen. Verwenden Sie diese Möglichkeit aber mit Vorsicht. Ein
unbedachtes `C:\**` führt entweder zu einer 6-stelligen Zahl an Services
oder einem Timeout während der Discovery.
:::

::::: imageblock
::: content
![Regel für fileinfo mit Filterung auf Windows-Pfad und allen
Unterverzeichnissen.](../images/filestats_fileinfo_agent_rule_globstar.png)
:::

::: title
Überwachung aller Dateien in angegebenen Verzeichnis und seinen
Unterverzeichnissen
:::
:::::

::: paragraph
**Zusätzliches Datum:** Auf Linux-Host gibt dafür noch die Möglichkeit
nach dem Datum zu filtern: Im Globbing-Muster können Sie die Variable
`$DATE` nutzen, um nur Dateien einzubeziehen, deren Namen das aktuelle
Datum enthält. Die Angabe des Datumsformats entspricht dabei dem
Linux-Programm `date`.
:::

::::: imageblock
::: content
![Regel für fileinfo mit Filterung über
Datumsvariable.](../images/filestats_fileinfo_date_rule.png)
:::

::: title
Dateien mit Zeitstempel im Namen lassen sich nur unter Linux explizit
ansprechen
:::
:::::

::: paragraph
Eine Angabe wie `/backups/mybackup_*_$DATE:%Y%m%d$` würde --- Stand
heute, dem 22.10.2021 --- folglich Dateien wie `mybackup_01_20211022`
und `mybackup_foobar_20211022` finden:
:::

::::: imageblock
::: content
![Datei im Monitoring, gefiltert nach Datum im
Dateinamen.](../images/filestats_fileinfo_date_monitoring.png)
:::

::: title
Für Backup-Dateien bieten sich Zeitstempel und eine tagesaktuelle
Prüfung an
:::
:::::

::: paragraph
Weitere Informationen finden Sie direkt auf der Seite der Regel sowie in
der zugehörigen Inline-Hilfe.
:::

::: paragraph
Damit ist die Konfiguration abgeschlossen und Sie können das Plugin samt
Konfiguration über die [Agentenbäckerei
verteilen.](agent_deployment.html)
:::
:::::::::::::::::::::

:::::::::::::: sect3
#### []{#fileinfo_manual_configuration .hidden-anchor .sr-only}Manuelle Konfiguration {#heading_fileinfo_manual_configuration}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** müssen Sie auch bei fileinfo wieder über Dateien
konfigurieren, unterschiedlich nach Betriebssystem:
:::

::: paragraph
**Linux:** Konfigurationsdatei `fileinfo.cfg`:
:::

::::: listingblock
::: title
/etc/check_mk/fileinfo.cfg
:::

::: content
``` {.pygments .highlight}
C:\myfiles\*
/myfiles/*
/media/evo/test_$DATE:%Y%m%d$
```
:::
:::::

::: paragraph
**Windows:** Konfigurationsdatei `check_mk.user.yml`:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
fileinfo:
  enabled: yes
  path:
  - c:\myfiles\*
  - c:\myotherfiles\**
```
:::
:::::

::: paragraph
Ausschließlich auf Windows-Host können Sie mit dem sogenannten Globstar
(zwei aufeinanderfolgende Sternchen) auch gleich alle Dateien in
**allen** Unterverzeichnissen einbeziehen. Verwenden Sie diese
Möglichkeit aber mit Vorsicht. Ein unbedachtes `C:\**` führt entweder zu
einer 6-stelligen Zahl an Services oder einem Timeout während der
Discovery.
:::

::: paragraph
Damit ist die Konfiguration abgeschlossen und Sie können das Plugin
[unter Linux](agent_linux.html#manualplugins) oder [unter
Windows](agent_windows.html#manual_installation_of_plugins) manuell
installieren.
:::
::::::::::::::

:::::::: sect3
#### []{#_daten_in_der_agentenausgabe_2 .hidden-anchor .sr-only}Daten in der Agentenausgabe {#heading__daten_in_der_agentenausgabe_2}

::: paragraph
Das Ergebnis Ihrer Konfiguration finden Sie dann in Form von Rohdaten in
der Agentenausgabe, beginnend mit dem Sektions-Header
[fileinfo:]{.guihint}
:::

::::: listingblock
::: title
mysite-mywindowshost-agent_output.txt
:::

::: content
``` {.pygments .highlight}
<<<fileinfo:sep(124)>>>
1743070736
C:\myfiles\myfile01|30219|1724242936
C:\myfiles\myfile02|30219|1724242936
C:\myfiles\myfile03|1337|1741368907
C:\myotherfiles\myotherfile01|1900|1743070353
C:\myotherfiles\myotherfile02|728|1743070370
C:\myotherfiles\myotherfile03|1023120|1743070389
C:\myotherfiles\mysubdirectory\myfileinasubdirectory|14114|1743070321
```
:::
:::::

::: paragraph
Dies ist eine Beispielausgabe, die der oben angegebenen
[Konfigurationsdatei](#fileinfo_manual_configuration) für einen
Windows-Host entsprechen könnte.
:::
::::::::
::::::::::::::::::::::::::::::::::::::::

:::::::::::::::: sect2
### []{#fileinfo_service_rule .hidden-anchor .sr-only}4.2. Service-Regel konfigurieren {#heading_fileinfo_service_rule}

::: paragraph
Im zweiten Schritt wird auch hier wieder die Service-Regel [Setup \>
Services \> Service monitoring rules \> Size, age and count of file
groups]{.guihint} konfiguriert: Die Minimal-Maximal-Optionen entsprechen
denen von mk_filestats, die Optionen zum Anzeigen der betroffenen
Dateinamen in den Service-Details und für Ausreißer sind hier aber nicht
vorhanden. Dafür gibt es zwei zusätzliche Optionen: Zum einen können Sie
über [Add time range]{.guihint} direkt einen Zeitraum
eingeben --- außerhalb dieses Zeitraums hat der Service immer den Status
[OK]{.state0}.
:::

::: paragraph
Zum anderen steht Ihnen das mächtige Feature [Level
conjunctions]{.guihint} zur Verfügung: Hierüber können Sie für jeden der
vier Zustände [OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2} und
[UNKNOWN]{.state3} Reihen von Bedingungen setzen. So könnten Sie zum
Beispiel festlegen, dass der Service auf [CRIT]{.state2} geht, wenn
:::

::: ulist
- es exakt 7 Dateien gibt,

- die kleinste Datei unterhalb von 10 Megabyte liegt,

- die älteste Datei jünger als 5 Tage alt ist und
:::

::::: imageblock
::: content
![Festlegung der Bedingungen für die mit fileinfo überwachten
Dateien.](../images/filestats_fileinfo_service_rule.png)
:::

::: title
[Level conjunctions]{.guihint} ermöglichen auch, explizite Ausnahmen zu
definieren
:::
:::::

::: paragraph
Und auch diese Regel können Sie wieder im Kasten [Conditions]{.guihint}
auf die gewünschte Gruppe `myfiles` mit [File Group Name]{.guihint}
beschränken.
:::

::: paragraph
Anders als bei mk_filestats läuft die Gruppenbildung erst im Monitoring
über die Service-Regel [Setup \> Services \> Service monitoring rules \>
File grouping patterns]{.guihint}. Die Zuordnung stellen Sie sicher,
indem Sie unter [Group name]{.guihint} ebenfalls die Gruppe `myfiles`
eintragen.
:::

::: paragraph
Die Angabe der Muster für ein- und auszuschließende Dateien geschieht
hier **standardmäßig** nicht über reguläre Ausdrücke, sondern lediglich
über Globbing. Wenn Sie eine Tilde (`~`) voranstellen, können Sie aber
auch hier reguläre Ausdrücke verwenden.
:::

::::: imageblock
::: content
![Filter auf Dateien der Gruppe
myfiles.](../images/filestats_fileinfo_grouping_pattern.png)
:::

::: title
Eingabefelder verhalten sich nicht immer identisch --- die Inline-Hilfe
bietet immer weitere Details
:::
:::::

::: paragraph
**Zusätzliches Datum:** Wieder ist die Verwendung der Variablen `$DATE`
möglich, mehr noch: Alternativ können Sie auch `$YESTERDAY` zum Filtern
verwenden, was schlicht einen Tag von `$DATE` abzieht. Weitere Infos
dazu erhalten Sie wie immer in der Inline-Hilfe.
:::
::::::::::::::::

:::::::::::: sect2
### []{#fileinfo_monitoring .hidden-anchor .sr-only}4.3. fileinfo im Monitoring {#heading_fileinfo_monitoring}

::: paragraph
Im Monitoring unterscheidet sich die Ansicht einer fileinfo-Gruppe nicht
sonderlich von einer mk_filestats-Gruppe. Allerdings werden bei fileinfo
immer alle betroffenen Dateien explizit aufgeführt, egal, ob sie für
eine Statusänderung verantwortlich sind oder nicht. Hier im Beispiel
sehen Sie etwa die beiden Dateien `yourfile` mit 0 Megabyte ohne
Auswirkungen auf den Status und `yourfile_2.exe` mit knapp 11 Megabyte,
die damit den Status [CRIT]{.state2} auslöst:
:::

::::: imageblock
::: content
![Eine fileinfo-Gruppe im
Monitoring.](../images/filestats_fileinfo_service_monitoring.png)
:::

::: title
`yourfile` wird von fileinfo angezeigt, obwohl nicht für die
Statusänderung verantwortlich
:::
:::::

::: paragraph
Alle Dateien, die von fileinfo ins Monitoring geliefert und keiner
Gruppe zugeordnet werden, bleiben als einzelne Services erhalten:
:::

::::: imageblock
::: content
![Einzelne Dateien als separate Services im
Monitoring.](../images/filestats_fileinfo__service_monitoring_singlefiles.png)
:::

::: title
Bei fileinfo sind es zu offenherzige Globbing-Muster, die für riesige
Listen sorgen können
:::
:::::

::: paragraph
Genau diese Liste zeigt, warum es so wichtig ist, bei fileinfo präzise
auf die Filter zu achten: Wenn hier etwa `C:\` ohne jegliche
Einschränkungen angegeben würde, gäbe es es anschließend mehrere
Hunderttausend einzelne Services im Monitoring.
:::
::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#troubleshooting .hidden-anchor .sr-only}5. Troubleshooting {#heading_troubleshooting}

::::: sectionbody
:::: sect2
### []{#_keinezu_viele_dateien_im_monitoring .hidden-anchor .sr-only}5.1. Keine/zu viele Dateien im Monitoring {#heading__keinezu_viele_dateien_im_monitoring}

::: paragraph
Egal, ob Sie mit mk_filestats oder fileinfo arbeiten, fehlende Dateien
oder auch zu viele Einträge im Monitoring liegen häufig an falschen
Filtern. Dafür gibt es vor allem zwei Quellen: Eine Verwechslung von
Globbing-Muster und regulärem Ausdruck oder eine falsche Konfiguration.
Beispielsweise verhält sich das Sternchen in beiden Varianten anders:
Beim Globbing steht `*` als Platzhalter für beliebig viele beliebige
Zeichen, in einem regulären Ausdruck für ein oder mehrere Vorkommen des
davor stehenden Zeichens. Um per Regex beliebige Zeichen in beliebiger
Menge zu matchen, müsste entsprechend mit `.*` gearbeitet werden.
:::
::::
:::::
::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: paragraph
Wie immer sind alle Pfadangaben für den Checkmk-Server relativ zum
Instanzverzeichnis (z.B. `/omd/sites/mysite`) angegeben.
:::

::: sect2
### []{#_mk_filestats .hidden-anchor .sr-only}6.1. mk_filestats {#heading__mk_filestats}

+---------+---------------------------+--------------------------------+
| Ort     | Pfad                      | Bedeutung                      |
+=========+===========================+================================+
| Checkmk | `~                        | Beispielkonfigurationsdatei    |
| -Server | /share/check_mk/agents/cf |                                |
|         | g_examples/filestats.cfg` |                                |
+---------+---------------------------+--------------------------------+
| Checkmk | `~/share/check_mk/agents  | Python-3-Agentenplugin         |
| -Server | /plugins/mk_filestats.py` | inklusive Erläuterungen        |
+---------+---------------------------+--------------------------------+
| Checkmk | `                         | Python-2-Agentenplugin         |
| -Server | ~/share/check_mk/agents/p | inklusive Erläuterungen        |
|         | lugins/mk_filestats_2.py` |                                |
+---------+---------------------------+--------------------------------+
| Lin     | `/et                      | Konfigurationsdatei - von der  |
| ux-Host | c/check_mk/filestats.cfg` | Agentenbäckerei oder manuell   |
|         |                           | erstellt                       |
+---------+---------------------------+--------------------------------+
:::

::: sect2
### []{#_fileinfo .hidden-anchor .sr-only}6.2. fileinfo {#heading__fileinfo}

+---------+---------------------------+--------------------------------+
| Ort     | Pfad                      | Bedeutung                      |
+=========+===========================+================================+
| Checkmk | `                         | Beispielkonfigurationsdatei    |
| -Server | ~/share/check_mk/agents/c |                                |
|         | fg_examples/fileinfo.cfg` |                                |
+---------+---------------------------+--------------------------------+
| Lin     | `/e                       | Konfigurationsdatei - von der  |
| ux-Host | tc/check_mk/fileinfo.cfg` | Agentenbäckerei oder manuell   |
|         |                           | erstellt                       |
+---------+---------------------------+--------------------------------+
| Windo   | `C:\Pro                   | Konfigurationsdatei - von der  |
| ws-Host | gramData\checkmk\agent\ba | Agentenbäckerei erstellt       |
|         | kery\check_mk.bakery.yml` |                                |
+---------+---------------------------+--------------------------------+
| Windo   | `C:\ProgramData\checkmk   | Konfigurationsdatei - manuell  |
| ws-Host | \agent\check_mk.user.yml` | erstellt                       |
+---------+---------------------------+--------------------------------+
:::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
