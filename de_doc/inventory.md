:::: {#header}
# Die HW/SW-Inventur

::: details
[Last modified on 16-Aug-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/inventory.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen](agent_linux.html) [Windows
überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::: sectionbody
::: paragraph
Neben dem klassischen Monitoring --- also dem Überwachen von Status-,
Log- und Messdaten --- bringt Checkmk noch eine ganz andere Funktion
quasi kostenlos mit: die *Hardware-/Software-Inventur* (oder kurz
*HW/SW-Inventur*). Diese kann auf Ihren Hosts z.B. folgende
Informationen automatisch ermitteln:
:::

::: ulist
- Welche Softwarepakete sind in welchen Versionen auf einem Server
  installiert?

- Welchen Ausbau an RAM-Bausteinen hat ein Server?

- Welche BIOS-Version ist auf dem Mainboard installiert?

- Welche Seriennummern haben die verbauten Festplatten?

- Welche Ports auf einem Switch sind länger nicht genutzt worden (also
  wahrscheinlich frei)?

- ...​ und vieles mehr
:::

::: paragraph
Die so ermittelten Daten werden pro Host in einem strukturierten Baum
und in verschiedenen anderen [Ansichten](views.html) dargestellt und
sind auch über eine API verfügbar. Hier ein Beispiel mit Daten zum
Prozessor:
:::

::::: imageblock
::: content
![Aufgeklapptes Inventar mit
CPU-Daten.](../images/inventory_example_main.png)
:::

::: title
CPU-Daten im Inventurpfad `hardware.cpu`
:::
:::::

::: paragraph
Mit der HW/SW-Inventur können Sie zum Beispiel:
:::

::: ulist
- Daten über installierte Software für ein Lizenz-Management-System
  bereitstellen,

- Typenbezeichnungen für Ersatzteilbestellungen (RAM, Festplatten,
  Lüfter) ermitteln,

- generelle Daten über Hardware- und Softwareausstattung für den
  regelmäßigen Import in CMDBs liefern,

- Änderungen an Hardware oder Software zurückverfolgen, z.B. um
  festzustellen, wann ein bestimmtes BIOS-Update durchgeführt wurde,

- informiert werden, wenn sich etwas an der Hardware oder Software
  geändert hat,

- gezielt Server finden, die ein bestimmtes Service Pack noch nicht
  installiert haben.
:::

::: paragraph
Der wichtigste Vorteil gegenüber vergleichbaren anderen Systemen liegt
auf der Hand: Sie können dafür einfach die vorhandene Infrastruktur von
Checkmk verwenden und sparen sich das Einrichten und Administrieren
einer weiteren Software-Umgebung. Sie rollen lediglich ein einziges
zusätzliches Agentenplugin aus. Bei SNMP-Geräten ist nicht einmal das
notwendig, da der Inventurscanner auch SNMP unterstützt und sich die
Daten einfach auf diesem Weg holt.
:::

::: paragraph
Außerdem braucht sich Checkmk hinter anderen Inventurscannern nicht zu
verstecken. Wie auch bei unseren Check-Plugins arbeiten wir ständig an
einer Erweiterung der gescannten Daten. Jede Checkmk-Version bringt neue
Plugins für den Inventurscanner mit, und die eingesammelten
Informationen werden immer detaillierter und umfangreicher.
:::
:::::::::::::
::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#config .hidden-anchor .sr-only}2. Einrichtung {#heading_config}

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Einrichten der HW/SW-Inventur geht in zwei Schritten. Voraussetzung
ist, dass auf den Hosts bereits der Checkmk-Agent installiert ist (falls
diese nicht per SNMP überwacht werden):
:::

::: {.olist .arabic}
1.  Die Inventur für die gewünschten Hosts einschalten.

2.  Das Inventory-Agentenplugin auf diesen Hosts ausrollen.
:::

::::::::::::::::::::::: sect2
### []{#activate .hidden-anchor .sr-only}2.1. Die Inventur für die gewünschten Hosts einschalten {#heading_activate}

::::::::::::::: sect3
#### []{#_regel_erstellen .hidden-anchor .sr-only}Regel erstellen {#heading__regel_erstellen}

::: paragraph
Wie immer, wenn Sie etwas für bestimmte Hosts konfigurieren wollen, geht
das auch hier mithilfe einer [Regel.](wato_rules.html) Den Regelsatz
finden Sie unter [Setup \> Hosts \> HW/SW inventory rules \> Do
hardware/software inventory]{.guihint} oder noch einfacher mit der Suche
nach `inventory`. Verwechseln Sie diesen nicht mit dem Regelsatz
[Hardware/Software-Inventory (Linux, Windows, Solaris, AIX).]{.guihint}
Dieser wird für das [Agentenplugin](#inventory_plugin) verwendet, wie
Sie später sehen werden.
:::

::: paragraph
Im Regelsatz [Do hardware/software inventory]{.guihint} sind bereits
einige Regeln standardmäßig aktiv, die sich auf
Host-[Labels](labels.html) beziehen. Wenn die von Ihnen gewünschten
Hosts ein solches Label haben, ist der Service für die HW/SW-Inventur
bereits eingerichtet. Wenn nicht, müssen Sie eine neue Regel erstellen.
:::

::: paragraph
Legen Sie also hier mit [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add rule]{.guihint}
eine neue Regel für die Hosts an, für die Sie die Inventur aktivieren
möchten. Dort finden Sie etliche Einstellungen:
:::

::::: imageblock
::: content
![Dialog für
Inventuroptionen.](../images/inventory_do_inventory_default.png)
:::

::: title
Standardmäßig sind alle Optionen deaktiviert und werden auch nicht
benötigt
:::
:::::

::: paragraph
Fürs Erste übernehmen Sie die Voreinstellungen. Die anderen
Möglichkeiten erklären wir im Verlauf dieses Artikels.
:::

::: paragraph
Die Regel, die Sie gerade angelegt haben, erzeugt bei der nächsten
[Aktivierung der Änderungen](wato.html#activate_changes) einen [aktiven
Check](active_checks.html) pro Host, der alle Inventurdaten zu diesem
einsammelt, darunter Daten von einem normalen Checkmk-Agenten, aber auch
solche, die über SNMP-Abfragen hereinkommen. Den neuen Service [Check_MK
HW/SW Inventory]{.guihint} finden Sie in der Serviceliste bei den Hosts,
und er sieht etwa so aus:
:::

::::: imageblock
::: content
![Statusanzeige eines frischen
Inventur-Services.](../images/inventory_list_first_item.png)
:::

::: title
Ohne Agentenplugin werden nur einige Standardeinträge gemeldet
:::
:::::

::: paragraph
Lassen Sie sich nicht verunsichern, weil der Check nur wenige Einträge
gefunden hat. Das liegt daran, dass Sie das Plugin noch nicht ausgerollt
haben.
:::
:::::::::::::::

::::::::: sect3
#### []{#_intervall_festlegen .hidden-anchor .sr-only}Intervall festlegen {#heading__intervall_festlegen}

::: paragraph
Inventurdaten ändern sich nur selten. Und das Erkennen einer Änderung
ist in der Regel auch nicht zeitkritisch. Deswegen ist es sehr sinnvoll,
das Intervall, in dem der Inventurcheck ausgeführt wird, anzupassen und
nicht einfach den Standard (1 Minute) zu verwenden --- vor allem, weil
das Verarbeiten der Inventurdaten in dem aktiven Check deutlich mehr
Rechenzeit benötigt als für einen normalen Service.
:::

::: paragraph
Checkmk-Instanzen haben dazu *automatisch* eine Regel im Regelsatz
[Setup \> Service monitoring rules \> Service Checks \> Normal check
interval for service checks]{.guihint}, die für alle Services mit dem
Namen [Check_MK HW/SW Inventory]{.guihint} das Intervall auf einen Tag
festlegt:
:::

::::: imageblock
::: content
![Die Regel zum Festlegen des
Intervalls.](../images/inventory_interval.png)
:::

::: title
Eine tägliche Inventur genügt in der Praxis, für Testzwecke bieten sich
kürzere Zeiträume an
:::
:::::

::: paragraph
Falls Ihnen einmal am Tag zu selten ist, können Sie diese Regel
natürlich auch anpassen --- z.B. auf Prüfintervalle von vier oder acht
Stunden. Und natürlich besteht immer die Möglichkeit, dass Sie das
mithilfe mehrerer Regeln für unterschiedliche Hosts anders einstellen.
:::
:::::::::
:::::::::::::::::::::::

:::::::::::::::::::::::::: sect2
### []{#inventory_plugin .hidden-anchor .sr-only}2.2. Das Inventory-Agentenplugin auf diesen Hosts ausrollen {#heading_inventory_plugin}

::: paragraph
Der wichtigste Schritt ist das Installieren des Agentenplugins für die
Inventur auf den entsprechenden Hosts. Das können Sie entweder manuell
oder mit der [Agentenbäckerei](wato_monitoringagents.html#bakery) (nur
kommerzielle Editionen) machen.
:::

:::::::::::::::::: sect3
#### []{#_installation_von_hand .hidden-anchor .sr-only}Installation von Hand {#heading__installation_von_hand}

::: paragraph
Für eine manuelle Installation benötigen Sie zunächst das Plugin. Das
finden Sie in den kommerziellen Editionen unter [Setup \> Agents \>
Windows, Linux, Solaris, AIX \> Related]{.guihint} und in Checkmk Raw
unter [Setup \> Agents.]{.guihint} In allen Editionen finden Sie dort
Menüeinträge für die unterschiedlichen Betriebssysteme. Verwenden Sie je
nach Betriebssystem folgendes Plugin im Kasten [Plugins]{.guihint}:
:::

+-----------------+-----------------------------------------------------+
| Betriebssystem  | Plugin                                              |
+=================+=====================================================+
| Windows         | `mk_inventory.vbs`                                  |
+-----------------+-----------------------------------------------------+
| Linux           | `mk_inventory.linux`                                |
+-----------------+-----------------------------------------------------+
| AIX             | `mk_inventory.aix`                                  |
+-----------------+-----------------------------------------------------+
| Solaris         | `mk_inventory.solaris`                              |
+-----------------+-----------------------------------------------------+

::: paragraph
Sie finden diese Dateien auch auf der Kommandozeile in der
Checkmk-Instanz im Unterverzeichnis `share/check_mk/agents/plugins`
(Linux/Unix) bzw. `share/check_mk/agents/windows/plugins` (Windows).
:::

::: paragraph
Kopieren Sie das Plugin auf die Ziel-Hosts in das korrekte Verzeichnis
für Plugins. Beim Windows-Agenten ist das
`C:\ProgramData\checkmk\agent\plugins`. Einzelheiten finden Sie im
[Artikel zum Windows-Agenten.](agent_windows.html#plugins)
:::

::: paragraph
Bei Linux und Unix lautet das Verzeichnis
`/usr/lib/check_mk_agent/plugins`. Achten Sie darauf, dass die Datei
ausführbar ist (`chmod +x`). Einzelheiten erfahren Sie im [Artikel zum
Linux-Agenten.](agent_linux.html#plugins)
:::

::: paragraph
Wichtig ist nun Folgendes: Der Agent wird ja von Checkmk in der Regel
einmal pro Minute abgerufen. Das Inventory-Agentenplugin benötigt aber
mehr Rechenzeit als normale Plugins, weil es z.B. in vielen
Verzeichnissen nach installierter Software suchen muss. Es erzeugt
darüber hinaus deutlich größere Datenmengen. Deswegen ist es so
entwickelt, dass es nur alle vier Stunden (14400 Sekunden) neue Daten
erzeugt und ausliefert.
:::

::: paragraph
Falls Sie also für Ihren Inventurcheck aus irgendeinem Grund ein
*kürzeres* Intervall als vier Stunden eingestellt haben, werden Sie
trotzdem nur alle vier Stunden wirklich neue Daten bekommen. Falls Sie
wirklich häufiger Daten ermitteln möchten, müssen Sie das
voreingestellte Berechnungsintervall anpassen.
:::

::: paragraph
Bei Windows ersetzen Sie die Zahl direkt in der Plugin-Datei. Suchen Sie
nach `14400` und ersetzen Sie diese durch eine andere Anzahl von
Sekunden. Die Stelle in der Datei sieht so aus (Ausschnitt):
:::

::::: listingblock
::: title
mk_inventory.vbs
:::

::: content
``` {.pygments .highlight}
Dim delay
Dim exePaths
Dim regPaths

'These three lines are set in the agent bakery
delay = 14400
exePaths = Array("")
regPaths = Array("Software\Microsoft\Windows\CurrentVersion\Uninstall","Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall")
```
:::
:::::

::: paragraph
Bei Linux und Unix geht das etwas anders. Dort legen Sie zu diesem Zweck
eine Konfigurationsdatei `/etc/check_mk/mk_inventory.cfg` an mit
folgender Zeile (hier im Beispiel mit 7200 Sekunden):
:::

::::: listingblock
::: title
/etc/check_mk/mk_inventory.cfg
:::

::: content
``` {.pygments .highlight}
INVENTORY_INTERVAL=7200
```
:::
:::::

::: paragraph
Noch ein Hinweis: Das Inventory-Agentenplugin kümmert sich *selbst*
darum, dass es nur alle vier Stunden ausgeführt wird. Verwenden Sie
daher **nicht** den Mechanismus vom Agenten für eine asynchrone
Ausführung von Plugins mit größeren Intervallen. Installieren Sie das
Plugin auf die normale Art zur direkten Ausführung.
:::
::::::::::::::::::

:::::::: sect3
#### []{#_konfiguration_über_die_agentenbäckerei .hidden-anchor .sr-only}Konfiguration über die Agentenbäckerei {#heading__konfiguration_über_die_agentenbäckerei}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Falls Sie in den
kommerziellen Editionen für die Konfiguration Ihrer Agenten die
[Agentenbäckerei](wato_monitoringagents.html#bakery) verwenden, ist die
Sache natürlich viel komfortabler. Hier gibt es unabhängig vom
Betriebssystem nur einen einzigen Regelsatz mit dem Namen
[Hardware/Software-Inventory (Linux, Windows, Solaris, AIX).]{.guihint}
Dieser steuert das Ausrollen des nötigen Plugins sowie dessen
Konfiguration. Sie finden ihn unter [Setup \> Agents \> Windows, Linux,
Solaris, AIX \> Agents \> Agent rules]{.guihint}:
:::

::::: imageblock
::: content
![Eingabemaske mit Optionen für das
Inventory-Agentenplugin.](../images/inventory_agent_rule.png)
:::

::: title
Portable Programme können Sie direkt über Verzeichnisse mit einbeziehen
:::
:::::

::: paragraph
Hier können Sie neben dem Intervall auch noch für Windows Pfade angeben,
in denen nach ausführbaren `.EXE`-Dateien gesucht werden soll, wenn es
darum geht, die auf dem System installierte Software zu finden. Auch die
Pfade in der Windows-Registry, die als Indikator für installierte
Software berücksichtigt werden sollen, können Sie hier konfigurieren.
:::
::::::::
::::::::::::::::::::::::::

::::::: sect2
### []{#_test .hidden-anchor .sr-only}2.3. Test {#heading__test}

::: paragraph
Wenn Sie das Plugin korrekt ausgerollt haben, dann finden Sie bei der
nächsten Ausführung des Inventurchecks eines Hosts deutlich mehr
Datensätze. Das sieht dann z.B. so aus:
:::

::::: imageblock
::: content
![Statusanzeige eines Inventur-Services mit laufendem
Agentenplugin.](../images/inventory_list_entries.png)
:::

::: title
So wenige Einträge werden Sie nur auf frisch aufgesetzten Systemen
vorfinden
:::
:::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::: sect1
## []{#operating .hidden-anchor .sr-only}3. Mit den Inventurdaten arbeiten {#heading_operating}

::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Inventurdaten gibt es natürlich insbesondere für jeden einzelnen Host,
teils als Baum-, teils als Tabellendarstellung. Wie genau diese
funktionieren und wie Sie darauf zugreifen können, sehen Sie unten. Es
gibt aber freilich auch Ansichten, insbesondere Suchen, die Ihre gesamte
Host-Landschaft betreffen. Diese erreichen Sie über den Eintrag
[Inventory]{.guihint} im [Monitor]{.guihint}-Menü:
:::

::::: imageblock
::: content
![Inventar-Einträge im
Monitor-Menü.](../images/inventory_monitor_menu.png)
:::

::: title
Globale Ansichten der Inventurdaten
:::
:::::

::::::::::::::::::: sect2
### []{#_darstellung_als_baum .hidden-anchor .sr-only}3.1. Darstellung als Baum {#heading__darstellung_als_baum}

::: paragraph
Im Monitoring werden die Inventurdaten der Hosts einmal in einem Baum
pro Host und noch einmal in Tabellen dargestellt. Den Baum erreichen Sie
beispielsweise in einer Host-Ansicht über den Menüeintrag [Host \>
Inventory \> Inventory of host.]{.guihint}
:::

::: paragraph
Alternativ können Sie in Ansichten, die Hosts auflisten, das [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} Menü eines Hosts
aufrufen und darüber wiederum das [![icon
inventory](../images/icons/icon_inventory.png)]{.image-inline} Inventar:
:::

::::: imageblock
::: content
![Kontextmenü zum Anzeigen des Inventars eines
Hosts.](../images/inventory_host_contextmenu.png)
:::

::: title
Zugriff auf das Inventar aus einer Liste mit Hosts
:::
:::::

::: paragraph
In beiden Fällen landen Sie bei der Baumdarstellung der Inventurdaten
des Hosts. Ausgehend von den drei Basiskategorien [![icon
hardware](../images/icons/icon_hardware.png)]{.image-inline}
[Hardware]{.guihint}, [![icon
networking](../images/icons/icon_networking.png)]{.image-inline}
[Networking]{.guihint} und [![icon
software](../images/icons/icon_software.png)]{.image-inline}
[Software]{.guihint} können Sie Unteräste auf- und zuklappen:
:::

::::: {#internal_paths .imageblock}
::: content
![Aufgeklapptes Inventar mit
CPU-Informationen.](../images/inventory_example_main.png)
:::

::: title
Ein sehr kleiner Teil des Inventurbaums
:::
:::::

::: paragraph
Hinter den einzelnen Einträgen sehen Sie oben im Bild in Klammern die
internen *Inventurpfade*, die Sie sich über [Display \> Modify display
options]{.guihint} und die Option [Show internal tree paths]{.guihint}
einblenden lassen können:
:::

:::: imageblock
::: content
![Option zum Anzeigen der
Inventurpfade.](../images/inventory_show_internal_paths.png)
:::
::::

::: paragraph
Im Inventar sehen Sie dann die internen Bezeichnungen. So heißt der
interne Pfad für den Bereich `Processor` beispielsweise `hardware.cpu`.
Die Bezeichnungen für CPU-Modell und -Architektur, `model` und `arch`,
finden Sie darunter in den CPU-Daten.
:::

::: paragraph
Sie können diese internen Bezeichnungen nutzen, um nur einzelne Pfade
für [Kontaktgruppen freizuschalten.](wato_user.html#visibility) Benutzer
einer Kontaktgruppe, denen nur die oben gezeigten Einträge
`hardware.cpu`, model und arch zugewiesen sind, sehen dann nur noch ein
abgespecktes Inventar:
:::

:::: imageblock
::: content
![Inventar mit ausgewählten
Datensätzen.](../images/inventory_restricted_internal_path.png)
:::
::::
:::::::::::::::::::

::::::::::::::::::: sect2
### []{#table .hidden-anchor .sr-only}3.2. Darstellung als Tabelle {#heading_table}

::: paragraph
Viele der Inventurdaten sind Einzelwerte unter ganz konkreten Pfaden im
Baum, z.B. der Eintrag [Hardware \> System \> Manufacturer \> Apple
Inc.]{.guihint}. Es gibt aber auch Stellen im Baum mit Tabellen
gleichartiger Objekte. Eine sehr wichtige ist z.B. die Tabelle [[![icon
software](../images/icons/icon_software.png)]{.image-inline} Software \>
[![icon packages](../images/icons/icon_packages.png)]{.image-inline}
Packages]{.guihint}:
:::

::::: imageblock
::: content
![Softwarepakete im Inventarbaum.](../images/inventory_packages.png)
:::

::: title
Die Paketliste ist sehr ausführlich und hier im Bild stark beschnitten
:::
:::::

::: paragraph
Das Besondere an diesem Teil der Inventurdaten: Sie können die Pakete
über [Host \> Inventory \> Software packages]{.guihint} in einer
separaten Ansicht aufrufen. Dort finden Sie dann [![icon
filter](../images/icons/icon_filter.png)]{.image-inline} Filter speziell
für die Suche in Paketen (im Bild stark gekürzt):
:::

::::: imageblock
::: content
![Filterliste für
Softwarepakete.](../images/inventory_packages_search.png)
:::

::: title
Der Filter für den Host-Namen ist bereits ausgefüllt
:::
:::::

::: paragraph
Sie können auch in Softwarepaketen auf mehreren Hosts suchen. Die
entsprechende Ansicht finden Sie im
[Monitor](user_interface.html#monitor_menu)-Menü unter [Monitor \>
Inventory \> Search Software packages]{.guihint} oder im Snapin
[Views]{.guihint} der [Seitenleiste](user_interface.html#sidebar) im
Bereich [Inventory.]{.guihint} Dort sind auch alle weiteren
Tabellenansichten für die Inventur aufgeführt, darunter weitere Suchen,
etwa für bestimmte Oracle-Daten.
:::

::: paragraph
Beachten Sie, dass in der Voreinstellung viele allgemeine Filter zu den
Hosts nicht in diesen Ansichten verfügbar sind. Sie können die
Voreinstellungen aber bearbeiten und weitere Filter hinzufügen.
:::

::: paragraph
Weitere Dinge, die Sie mit diesen Ansichten machen können:
:::

::: ulist
- In [Berichte](reporting.html) einbinden

- Als PDF- oder CSV-Datei exportieren

- In [Dashboards](dashboards.html) integrieren
:::

::: paragraph
Übrigens können Sie auch solche Inventurdaten in Ansichten aufnehmen,
die *nicht* tabellarisch sind. Dazu gibt es für jeden bekannten Pfad im
Inventurbaum einen Spaltentyp, den Sie in Ansichten von Hosts hinzufügen
können. Ein Beispiel dafür ist die vordefinierte Beispielansicht [CPU
inventory of all hosts.]{.guihint} Das ist eine Tabelle der Hosts, die
jeweils zusätzliche Daten aus der Inventur anzeigt. Hier ist
beispielhaft eine der Spaltendefinitionen, die eine Spalte mit der
Anzahl der physikalischen CPUs des Hosts hinzufügt:
:::

::::: imageblock
::: content
![Dialog für die Aufnahme von Spalten mit Inventurdaten in
Ansichten.](../images/inventory_cpus.png)
:::

::: title
Inventurdaten stehen allen Ansichten zur Verfügung
:::
:::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#history .hidden-anchor .sr-only}4. Historischer Verlauf der Inventurdaten {#heading_history}

::::::::::::::::: sectionbody
::: paragraph
Sobald Sie die HW/SW-Inventur für einen Host eingerichtet haben, wird
Checkmk jede Änderung in den Inventurdaten erfassen und die Historie
aufzeichnen. Sie finden diese in Ansichten mit Inventurdaten über [Host
\> Inventory \> Inventory history of host.]{.guihint}
:::

::: paragraph
Hier ist ein Ausschnitt aus der Historie mit einer Reihe von IP-Daten,
die sich seit dem letzten Durchlauf geändert haben:
:::

::::: imageblock
::: content
![Historie von Einträgen im Inventar.](../images/inventory_history.png)
:::

::: title
Änderungen im Inventar werden in der Historie sofort sichtbar
:::
:::::

::: paragraph
Wenn Sie möchten, können Sie sich informieren lassen, wann immer eine
Änderung in der Software oder Hardware auftritt. Das geschieht über den
Status des Services [Check_MK HW/SW Inventory.]{.guihint} Dazu
bearbeiten Sie die Regel, die Sie ganz am Anfang dieses Artikels
angelegt haben (im Regelsatz [Do hardware/software
inventory).]{.guihint} Dort finden Sie im Wert der Regel etliche
Einstellungen, welche die Historie betreffen. Folgendes Beispiel setzt
den Service auf [WARN]{.state1}, wenn sich Änderungen in Software oder
Hardware ergeben:
:::

::::: imageblock
::: content
![Dialog zum Zustandswechsel des
Inventurchecks.](../images/inventory_do_inventory_warn.png)
:::

::: title
Ein gutes Mittel, um auf Schatten-IT auf Arbeitsplatzrechnern aufmerksam
zu werden
:::
:::::

::: paragraph
Sobald der Inventurcheck das nächste Mal Änderungen feststellt, wird er
auf [WARN]{.state1} gehen. Das sieht dann z.B. so aus:
:::

::::: imageblock
::: content
![Inventurcheck mit Warnung wegen erkannter
Änderungen.](../images/inventory_list_warn.png)
:::

::: title
Warnungen in der Service-Liste eines einzelnen Hosts
:::
:::::

::: paragraph
Bei der nächsten Ausführung des Checks geht dieser wieder automatisch
auf [OK]{.state0}, wenn sich nichts geändert hat. Das heißt, dass Sie
den Check von Hand ausführen können, um den Service wieder auf
[OK]{.state0} zu setzen, wenn Sie nicht bis zum nächsten regelmäßigen
Lauf warten möchten.
:::
:::::::::::::::::
::::::::::::::::::

:::::::::: sect1
## []{#statusdata .hidden-anchor .sr-only}5. Statusdaten {#heading_statusdata}

::::::::: sectionbody
::: paragraph
Der Baum der Inventurdaten kann automatisch um aktuelle, passende
Statusdaten ergänzt werden. Das ist in einigen Fällen sehr nützlich. Ein
Beispiel dafür sind *Oracle Tablespaces.* In den eigentlichen
Inventurdaten sind lediglich relativ statische Dinge wie die SID, der
Name und der Typ enthalten. Aktuelle Statusdaten können dies um Angaben
zur aktuellen Größe, zu freiem Platz usw. ergänzen.
:::

::: paragraph
Wenn Sie Statusdaten in Ihrem Baum sehen möchten (und da spricht
eigentlich nichts dagegen), müssen Sie lediglich die entsprechende
Option aktivieren in der Regel, die Sie [am Anfang](#activate) unter [Do
hardware/software inventory]{.guihint} angelegt haben:
:::

::::: imageblock
::: content
![Dialog zum Aktivieren der
Statusdaten.](../images/inventory_do_inventory_status.png)
:::

::: title
Statusdaten erweitern das Monitoring teils erheblich
:::
:::::

::: paragraph
Änderungen in Statusdaten finden übrigens *keinen* Niederschlag in der
[Historie!](#history) Dies würde quasi zu ständigen Änderungen führen
und die Funktion nutzlos machen. Statusdaten werden auch nicht in
Dateien abgelegt, sondern wie die Resultate von Checks direkt im
Hauptspeicher vom Monitoring-Kern gehalten.
:::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#external .hidden-anchor .sr-only}6. Externer Zugriff auf die Daten {#heading_external}

::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::::::::::: sect2
### []{#_zugriff_via_eigener_web_api .hidden-anchor .sr-only}6.1. Zugriff via eigener Web-API {#heading__zugriff_via_eigener_web_api}

::: paragraph
Sie können die HW/SW-Inventurdaten eines Hosts über eine Inventur-eigene
Web-API exportieren.
:::

::: paragraph
**Hinweis:** Die hier erwähnte, Inventur-eigene Web-API ist **nicht**
die Web-API, die in der Version [2.2.0]{.new} aus Checkmk entfernt
wurde.
:::

::: paragraph
Die URL dazu lautet
:::

::: paragraph
`http://myserver/mysite/check_mk/host_inv_api.py?host=myhost`
:::

::: paragraph
Das Ausgabeformat in diesem Fall ist Python-Quellcode. Wenn Sie JSON
bevorzugen, dann hängen Sie einfach ein `&output_format=json` an die URL
an:
:::

::: paragraph
`http://myserver/mysite/check_mk/host_inv_api.py?host=myhost&output_format=json`
:::

::: paragraph
Das Ergebnis sieht in gekürzter Form etwa so aus:
:::

::::: listingblock
::: title
myhost.json
:::

::: content
``` {.pygments .highlight}
result:
    Attributes: {}
    Nodes:
        hardware:
            Attributes: {}
            Nodes:
                memory:
                    Attributes:
                        Pairs:
                            total_ram_usable: 16495783936
                            total_swap: 1027600384
                            total_vmalloc: 35184372087808
                        Nodes: {}
                        Table: {}
                Table: {}
 ... usw. ...
result_code: 0
```
:::
:::::

::: paragraph
Analog können Sie die Ausgabe auch in XML anfordern:
:::

::: paragraph
`http://myserver/mysite/check_mk/host_inv_api.py?host=myhost&output_format=xml`
:::

::: paragraph
Geben Sie die jeweilige URL in die Adressleiste Ihres Browsers ein,
sehen Sie sofort ein Ergebnis, weil Sie bereits bei Checkmk angemeldet
sind. Die HW/SW-Inventurdaten finden Sie in der Ausgabedatei im
Abschnitt nach dem Schlüssel *result*. Von einem Skript aus
authentifizieren Sie sich am besten als
[Automationsbenutzer.](glossar.html#automation_user)
:::

::: paragraph
Im Fehlerfall, z.B. wenn der angegebene Host nicht gefunden wurde, wird
der *result code* auf 1 gesetzt und eine entsprechende Fehlermeldung
ausgegeben:
:::

::: paragraph
`{"result": "Found no inventory data for this host.", "result_code": 1}`
:::

::::::::: sect3
#### []{#_mehrere_hosts_abfragen .hidden-anchor .sr-only}Mehrere Hosts abfragen {#heading__mehrere_hosts_abfragen}

::: paragraph
Sie können auch die HW/SW-Inventurdaten mehrerer Hosts in einer Ausgabe
abfragen. Erweitern Sie dafür die Abfrage auf alle gewünschten Hosts:
:::

::: paragraph
`http://myserver/mysite/check_mk/host_inv_api.py?request={"hosts":["myhost","myhost2"]}&output_format=json`
:::

::: paragraph
Das Ergebnis dieser Abfrage sieht dann fast genauso aus wie die obige
Ausgabe. Auf der obersten Ebene werden jedoch die Namen der Hosts als
Schlüssel verwendet. Die Angaben zu den Hosts folgen dann darunter in
den Verzeichnisbäumen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
result:
    myhost:
        Attributes: {}
        Nodes:
            hardware:
                Attributes: {}
                Nodes:
                    memory:
                        Attributes:
                            Pairs:
                                total_ram_usable: 16495783936
                                total_swap: 1027600384
                                total_vmalloc: 35184372087808
                            Nodes: {}
                            Table: {}
                    Table:
            networking:
                Attributes:
                    Pairs:
                        available_ethernet_ports: 1
                        hostname: "MyServer"
                        total_ethernet_ports: 3
                        total_interfaces: 4
... etc. ...
    myhost2:
        Attributes: {}
        Nodes: {}
        Table: {}
result_code: 0
```
:::
::::

::: paragraph
Werden zu einem Host keine Inventurdaten gefunden, dann hat der Host
einen leeren Inventureintrag anstelle der Fehlermeldung.
:::
:::::::::

::::::::: sect3
#### []{#_abfrage_auf_spezifische_daten_einschränken .hidden-anchor .sr-only}Abfrage auf spezifische Daten einschränken {#heading__abfrage_auf_spezifische_daten_einschränken}

::: paragraph
Nun wollen Sie aber vielleicht nicht alle Inventurdaten abfragen,
sondern suchen nur gezielt nach einzelnen Informationen. Dann geben Sie
sogenannte [Inventurpfade](#internal_paths) an, um die gewünschten
Angaben zu definieren. Sie bekommen dann nur von denjenigen Hosts
Informationen angezeigt, die diese Pfade / Informationen haben.
:::

::: paragraph
Um zum Beispiel für den Host `myhost` nur die Angaben zu Gesamtspeicher
und Auslagerungsspeicher zu sehen, verwenden Sie diese URL:
:::

::: paragraph
`http://myserver/mysite/check_mk/host_inv_api.py?host=myhost&request={"paths":[".hardware.memory.total_ram_usable",".hardware.memory.total_swap"]}&output_format=json`
:::

::: paragraph
Sie bekommen die gewünschten Angaben zurück:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
result:
    Attributes: {}
    Nodes:
        hardware:
            Attributes: {}
            Nodes:
                memory:
                    Attributes:
                        Pairs:
                            total_ram_usable: 16495783936
                            total_swap: 1027600384
                        Nodes: {}
                        Table: {}
                Table: {}
        Table: {}
result_code: 0
```
:::
::::
:::::::::
::::::::::::::::::::::::::::::::

:::: sect2
### []{#_zugriff_via_datei .hidden-anchor .sr-only}6.2. Zugriff via Datei {#heading__zugriff_via_datei}

::: paragraph
Alternativ können Sie auch einfach die Dateien auslesen, die Checkmk
selbst erzeugt. Diese liegen im Python-Format im Verzeichnis
`~/var/check_mk/inventory` vor. Für jeden Host gibt es dort eine Datei
in unkomprimierter (z.B. `myhost`) und eine in komprimierter Variante
(z.B. `myhost.gz`).
:::
::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

::::::::: sect1
## []{#distributed .hidden-anchor .sr-only}7. Inventur in verteilten Umgebungen {#heading_distributed}

:::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen funktioniert die HW/SW-Inventur auch in
[verteilten Umgebungen.](distributed_monitoring.html) Hier werden die
Inventurdaten zunächst durch die lokalen Instanzen ermittelt und dort
unterhalb von `~/var/check_mk/inventory` abgelegt.
:::

::: paragraph
Der
[Livestatus-Proxy-Daemon](distributed_monitoring.html#livestatusproxy)
überträgt turnusmäßig alle aktualisierten Inventurdaten von der
Remote-Instanz in die Zentralinstanz und legt sie dort ebenfalls unter
`~/var/check_mk/inventory` ab. Das ist wichtig, da diese Daten zu
umfangreich sind, um sie bei einer Abfrage in diesem Augenblick live
abzuholen.
:::

::: paragraph
Sobald über die Zentralinstanz Abfragen zu Inventurdaten kommen, werden
diese Dateien gelesen und dann noch mit aktuellen Statusdaten
zusammengeführt, welche per [Livestatus](livestatus.html) von den
Remote-Instanzen geholt werden.
:::

::: paragraph
Kurz zusammengefasst: Sie müssen sich um nichts kümmern.
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In Checkmk Raw
gibt es keinen Livestatus-Proxy. Daher ist auch die HW/SW-Inventur in
der GUI der Zentralinstanz unvollständig und zeigt nur die Statusdaten.
Sie können sich behelfen und die Dateien im Verzeichnis
`~/var/check_mk/inventory` regelmäßig mit einem Skript o.Ä. an die
Zentralinstanz übertragen. Dabei genügt es, die Dateien *ohne* die
Endung `.gz` zu kopieren. Für eine effiziente Übertragung eignet sich
z.B. `rsync`.
:::
::::::::
:::::::::

:::::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}8. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::::: sectionbody
::: sect2
### []{#_verzeichnisse_auf_dem_checkmk_server .hidden-anchor .sr-only}8.1. Verzeichnisse auf dem Checkmk-Server {#heading__verzeichnisse_auf_dem_checkmk_server}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/sh                         | Agentenplugins für Linux und Unix    |
| are/check_mk/agents/plugins/` |                                      |
+-------------------------------+--------------------------------------+
| `~/share/chec                 | Agentenplugins für Windows           |
| k_mk/agents/windows/plugins/` |                                      |
+-------------------------------+--------------------------------------+
| `~/var/check_mk/inventory/`   | Inventurdaten der einzelnen Hosts    |
|                               | als Python-Dateien (komprimiert und  |
|                               | unkomprimiert)                       |
+-------------------------------+--------------------------------------+
:::

::: sect2
### []{#_verzeichnisse_auf_den_überwachten_hosts .hidden-anchor .sr-only}8.2. Verzeichnisse auf den überwachten Hosts {#heading__verzeichnisse_auf_den_überwachten_hosts}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `C:\Progra                    | Ablageort für das                    |
| mData\checkmk\agent\plugins\` | Inventory-Agentenplugin beim         |
|                               | Windows-Agenten                      |
+-------------------------------+--------------------------------------+
| `/usr                         | Ablageort für das                    |
| /lib/check_mk_agent/plugins/` | Inventory-Agentenplugin beim         |
|                               | Linux-/Unix-Agenten                  |
+-------------------------------+--------------------------------------+
| `/e                           | Konfiguration für das                |
| tc/check_mk/mk_inventory.cfg` | Inventory-Agentenplugin beim         |
|                               | Linux-/Unix-Agenten                  |
+-------------------------------+--------------------------------------+
:::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
