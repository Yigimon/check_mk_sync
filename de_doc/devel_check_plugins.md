:::: {#header}
# Agentenbasierte Check-Plugins schreiben

::: details
[Last modified on 18-Apr-2025]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/devel_check_plugins.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Erweiterungen für Checkmk entwickeln](devel_intro.html) [SNMP-basierte
Check-Plugins entwickeln](devel_check_plugins_snmp.html)
[Monitoring-Agenten](wato_monitoringagents.html) [Linux
überwachen](agent_linux.html) [Windows überwachen](agent_windows.html)
[Services verstehen und konfigurieren](wato_services.html) [Checkmk auf
der Kommandozeile](cmk_commandline.html) [Checkmk-Erweiterungspakete
(MKPs)](mkps.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::::::: sectionbody
::: paragraph
Check-Plugins sind in Python geschriebene Software-Module, die auf der
Checkmk-[Instanz](glossar.html#site) ausgeführt werden und die
[Services](glossar.html#service) eines [Hosts](glossar.html#host)
erstellen und auswerten.
:::

::: paragraph
Checkmk umfasst über 2000 fertige Check-Plugins für alle nur denkbare
Hardware und Software. Diese werden vom Checkmk-Team gepflegt und jede
Woche kommen neue dazu. Daneben gibt es auf der [Checkmk
Exchange](https://exchange.checkmk.com){target="_blank"} weitere
Plugins, die von unseren Anwendern beigesteuert werden.
:::

::: paragraph
Und trotzdem kann es immer wieder vorkommen, dass ein Gerät, eine
Anwendung oder einfach nur eine bestimmte [Metrik,](glossar.html#metric)
die für Sie wichtig ist, noch von keinem dieser Plugins erfasst
wird --- vielleicht auch einfach deshalb, weil es sich dabei um etwas
handelt, das in Ihrer Firma entwickelt wurde und es daher niemand anders
haben kann. Im Artikel zur Einführung in die [Programmierung von
Erweiterungen](devel_intro.html) für Checkmk erfahren Sie, welche
Möglichkeiten Sie haben.
:::

::: paragraph
Dieser Artikel zeigt Ihnen, wie Sie echte Check-Plugins für den
Checkmk-Agenten entwickeln können --- mit allem was dazugehört. Für
SNMP-basierte Check-Plugins gibt es einen [eigenen
Artikel.](devel_check_plugins_snmp.html)
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Bei der Entwicklung eines         |
|                                   | agentenbasierten Check-Plugins    |
|                                   | benötigen Sie in aller Regel      |
|                                   | *zwei* Plugins: das               |
|                                   | [Agentenp                         |
|                                   | lugin](glossar.html#agent_plugin) |
|                                   | auf dem überwachten Host, welches |
|                                   | die Daten liefert, und das        |
|                                   | [Check-P                          |
|                                   | lugin](glossar.html#check_plugin) |
|                                   | auf dem Checkmk-Server, das diese |
|                                   | Daten auswertet. Beide müssen     |
|                                   | geschrieben und aufeinander       |
|                                   | abgestimmt werden. Nur so         |
|                                   | funktionieren sie hinterher       |
|                                   | reibungsfrei.                     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::::::: sect2
### []{#check_api_doc .hidden-anchor .sr-only}1.1. Die Check-API-Dokumentation {#heading_check_api_doc}

::: paragraph
Für die Programmierung der Check-Plugins gibt es seit der
Checkmk-Version [2.0.0]{.new} eine neu entwickelte **Check-API.** In der
Checkmk-Version [2.3.0]{.new} ist die Check-API V2 die aktuelle Version.
Wir zeigen Ihnen in diesem Artikel, wie Sie die Check-API Version 2 für
die Plugin-Programmierung nutzen können. Hinweise zum Umstieg auf die
Check-API Version 2 finden Sie am Ende dieses Artikels im Kapitel
[Migration.](#migration)
:::

::: paragraph
Über die Checkmk-Benutzeroberfläche haben Sie jederzeit Zugriff auf die
Dokumentation der Check-API: [Help \> Developer resources \> Plugin API
references.]{.guihint} Wählen Sie im neuen Browserfenster in der linken
Navigationsleiste [Agent based (\"Check API\") \> Version 2]{.guihint}
aus:
:::

:::: {.imageblock .border}
::: content
![Seite zum Einstieg in die Dokumentation der Check-API Version
2.](../images/devel_cpi_checkapi_doc.png)
:::
::::

::: paragraph
Hier finden Sie nicht nur die Dokumentation der Check-API in allen
unterstützten Versionen, sondern auch die Dokumentation aller anderen,
für die Erstellung von Check-Plugins relevanten APIs. In diesem Artikel
nutzen wir nicht nur die Check-API, sondern bei der Erstellung eines
[Regelsatzes](#rule_set) auch die **Rulesets-API** V1 und bei der
Erstellung von [Metrikdefinitionen](#metrics_advanced) die
**Graphing-API** V1.
:::
::::::::

::::: sect2
### []{#prerequisites .hidden-anchor .sr-only}1.2. Voraussetzungen {#heading_prerequisites}

::: paragraph
Wenn Sie Lust haben, sich mit dem Programmieren von Check-Plugins zu
befassen, benötigen Sie folgendes:
:::

::: ulist
- Kenntnisse in der Programmiersprache Python.

- Erfahrung mit Checkmk, vor allem was das Thema Agenten und Checks
  betrifft.

- Übung mit Linux auf der Kommandozeile.
:::
:::::
:::::::::::::::::
::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#agentplugin .hidden-anchor .sr-only}2. Ein Agentenplugin schreiben {#heading_agentplugin}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Wer sich für die Programmierung von Check-Plugins in Checkmk
interessiert, hat mit großer Wahrscheinlichkeit auch schon einmal einen
Checkmk-Server aufgesetzt. Haben auch Sie dies bereits gemacht, haben
Sie dabei als Einstieg vermutlich auch Ihren Checkmk-Server selbst als
Host überwacht.
:::

::: paragraph
Hier kreieren wir ein Szenario, in dem es nützlich ist, wenn
Checkmk-Server und überwachter Host identisch sind. So ist es uns
möglich über [Livestatus](glossar.html#livestatus)-Abfragen vom Host
Informationen über Host-Gruppen zu erhalten, die der Checkmk-Server zur
Verfügung stellt.
:::

::: paragraph
Im beschriebenen Beispiel gehen wir von einem Unternehmen mit mehreren
Standorten aus:
:::

::: ulist
- Jeder dieser Standorte wird in Checkmk durch eine
  [Host-Gruppe](glossar.html#host_group) abgebildet.

- Jeder Standort hat sein eigenes Service-Team.
:::

::: paragraph
Damit bei Problemen jeweils das richtige Service-Team verständigt werden
kann, gilt, dass jeder Host einem Standort --- also auch einer
Host-Gruppe --- zugewiesen sein muss. Das Ziel in diesem Beispiel ist
nun, eine Prüfung aufzusetzen, mit der kontrolliert werden kann, ob für
keinen Host vergessen wurde, eine Host-Gruppe zuzuweisen.
:::

::: paragraph
Das Ganze läuft in zwei Schritten:
:::

::: {.olist .arabic}
1.  Informationen für das Monitoring aus dem Host auslesen. Darum geht
    es in diesem Kapitel.

2.  Schreiben eines Check-Plugins in der Checkmk-Instanz, welches diese
    Daten auswertet. Das zeigen wir im [nächsten
    Kapitel.](#write_check_plugin)
:::

::: paragraph
Und los geht's ...​
:::

:::::::::::::::: sect2
### []{#right_command .hidden-anchor .sr-only}2.1. Informationen auslesen und filtern {#heading_right_command}

::: paragraph
Am Anfang jeder Plugin-Programmierung steht: die Recherche! Das
bedeutet, dass Sie herausfinden müssen, wie Sie überhaupt an die
Informationen kommen, die Sie für die Überwachung brauchen.
:::

::: paragraph
Für das gewählte Beispiel nutzen wir die Tatsache, dass der
Checkmk-Server zugleich der Host ist. Damit genügt zunächst ein [Abruf
der Statusdaten via Livestatus,](livestatus.html) also der in Tabellen
organisierten Daten, die Checkmk über die überwachten Hosts und Services
im flüchtigen Speicher vorhält.
:::

::: paragraph
Melden Sie sich als Instanzbenutzer an und fragen Sie die Informationen
zu den Host-Gruppen mit folgendem Befehl ab:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hostgroups"
action_url;alias;members;members_with_state;name;notes;notes_url;num_hosts;num_hosts_down;num_hosts_handled_problems;num_hosts_pending;num_hosts_unhandled_problems;num_hosts_unreach;num_hosts_up;num_services;num_services_crit;num_services_handled_problems;num_services_hard_crit;num_services_hard_ok;num_services_hard_unknown;num_services_hard_warn;num_services_ok;num_services_pending;num_services_unhandled_problems;num_services_unknown;num_services_warn;worst_host_state;worst_service_hard_state;worst_service_state
;Hamburg;myhost11,myhost22,myhost33;myhost11|0|1,myhost22|0|1,myhost33|0|1;Hamburg;;;3;0;0;0;0;0;3;123;10;0;10;99;0;14;99;0;24;0;14;0;2;2
;Munich;myhost1,myhost2,myhost3;myhost1|0|1,myhost2|0|1,myhost3|0|1;Munich;;;3;0;0;0;0;0;3;123;10;0;10;99;0;14;99;0;24;0;14;0;2;2
;check_mk;localhost;localhost|0|1;check_mk;;;1;0;0;0;0;0;1;66;0;0;0;4;0;1;4;61;1;0;1;0;1;1
```
:::
::::

::: paragraph
Die erste Zeile der Ausgabe enthält die Spaltennamen der abgefragten
Tabelle `hostgroups`. Als Trennzeichen fungiert das Semikolon. In den
folgenden Zeilen folgen dann die Inhalte sämtlicher Spalten, ebenfalls
durch Semikolons getrennt.
:::

::: paragraph
Die Ausgabe ist bereits für dieses kleine Beispiel relativ
unübersichtlich und enthält Informationen, die für unser Beispiel nicht
relevant sind. Generell sollten Sie zwar die Interpretation der Daten
Checkmk überlassen. Allerdings kann eine Vorfilterung auf dem Host den
Umfang der zu übertragenden Daten reduzieren, wenn diese gar nicht
gebraucht werden. Also schränken Sie in diesem Fall die Abfrage auf die
relevanten Spalten (`Columns`) ein --- auf die Namen der Host-Gruppen
(`name`) und die in den Gruppen befindlichen Hosts (`members`):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET hostgroups\nColumns: name members"
Hamburg;myhost11,myhost22,myhost33
Munich;myhost1,myhost2,myhost3
check_mk;localhost
```
:::
::::

::: paragraph
Die Livestatus-Schnittstelle erwartet alle Befehle und Header in jeweils
einer eigenen Zeile. Die daher notwendigen Zeilenumbrüche machen Sie
durch `\n` kenntlich.
:::

::: paragraph
In diesem Beispiel existieren aktuell drei Host-Gruppen: zwei Gruppen
für die Standorte sowie die Gruppe `check_mk`. Diese enthält einen Host
namens `localhost`.
:::

::: paragraph
Die Host-Gruppe `check_mk` stellt eine Besonderheit innerhalb der
Host-Gruppen dar. Sie haben diese nämlich nicht selbst angelegt. Und Sie
können auch keinen Host aktiv in diese Gruppe aufnehmen. Woher also
stammt diese Host-Gruppe? Da in Checkmk per Definition jeder Host einer
Gruppe angehören muss, weist Checkmk jeden Host, den Sie keiner Gruppe
zuweisen, der „speziellen" Gruppe `check_mk` zu. Sobald Sie einen Host
einer Ihrer eigenen Host-Gruppen zuweisen, wird er aus der Gruppe
`check_mk` entfernt. Auch gibt es keinen Weg, einen Host erneut der
Host-Gruppe `check_mk` zuzuweisen.
:::

::: paragraph
Genau diese Eigenschaften der Gruppe `check_mk` werden nun für unser
Beispiel genutzt: Da jeder Host einem Standort zugeordnet sein soll,
müsste die Host-Gruppe `check_mk` leer sein. Ist sie nicht leer, so
besteht Handlungsbedarf, sprich darin befindliche Hosts müssen den
Host-Gruppen und damit den Standorten zugeordnet werden.
:::
::::::::::::::::

:::::::::::::::::::::::::::::: sect2
### []{#command_in_agent .hidden-anchor .sr-only}2.2. Den Befehl in den Agenten einbauen {#heading_command_in_agent}

::: paragraph
Bis jetzt haben Sie sich mit dem `lq`-Befehl als Instanzbenutzer die
Informationen anzeigen lassen. Das ist hilfreich, um sich einen Einblick
in die Daten zu verschaffen.
:::

::: paragraph
Damit Sie diese Daten vom Checkmk-Server aus abrufen können, muss der
neue Befehl jedoch Teil vom Checkmk-Agenten auf dem überwachten Host
werden. Theoretisch könnten Sie nun direkt den Checkmk-Agenten in der
Datei `/usr/bin/check_mk_agent` editieren und diesen Teil einbauen. Das
hätte aber den Nachteil, dass Ihr neuer Befehl bei einem Software-Update
des Agenten wieder verschwindet, weil die Datei ersetzt wird.
:::

::: paragraph
Besser ist es daher, ein [Agentenplugin](glossar.html#agent_plugin) zu
erstellen. Alles was Sie dafür brauchen, ist eine ausführbare Datei, die
den Befehl enthält und im Verzeichnis `/usr/lib/check_mk_agent/plugins/`
liegt.
:::

::: paragraph
Und noch eins ist wichtig: Die Daten können nicht einfach so ausgegeben
werden. Sie brauchen noch einen **Sektions-Header** (*section header*).
Das ist eine speziell formatierte Zeile, die den Namen des neuen
Agentenplugins enthält. An diesem Sektions-Header kann Checkmk später
erkennen, wo die Daten des Agentenplugins beginnen und die des
vorherigen aufhören. Am einfachsten ist es, wenn Agentenplugin,
Sektions-Header und Check-Plugin den gleichen Namen tragen --- auch wenn
dies nicht verpflichtend ist.
:::

::: paragraph
Also brauchen Sie jetzt erst einmal einen sinnvollen Namen für Ihr neues
Check-Plugin. Dieser Name darf nur Kleinbuchstaben (nur *a-z*, keine
Umlaute, keine Akzente), Unterstriche und Ziffern enthalten und muss
eindeutig sein. Vermeiden Sie Namenskollisionen mit vorhandenen
Check-Plugins. Wenn Sie neugierig sind, welche Namen es schon gibt,
können Sie diese in einer Checkmk-Instanz auf der Kommandozeile mit
`cmk -L` auflisten lassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -L
3par_capacity               agent      HPE 3PAR: Capacity
3par_cpgs                   agent      HPE 3PAR: CPGs
3par_cpgs_usage             agent      HPE 3PAR: CPGs Usage
3par_hosts                  agent      HPE 3PAR: Hosts
3par_ports                  agent      HPE 3PAR: Ports
3par_remotecopy             agent      HPE 3PAR: Remote Copy
3par_system                 agent      HPE 3PAR: System
3par_volumes                agent      HPE 3PAR: Volumes
3ware_disks                 agent      3ware ATA RAID Controller: State of Disks
3ware_info                  agent      3ware ATA RAID Controller: General Information
3ware_units                 agent      3ware ATA RAID Controller: State of Units
acme_agent_sessions         snmp       ACME Devices: Agent Sessions
acme_certificates           snmp       ACME Devices: Certificates
```
:::
::::

::: paragraph
Die Ausgabe zeigt nur die ersten Zeilen der sehr langen Liste. Durch die
Verwendung von Präfixen ist die Zugehörigkeit vieler Check-Plugins hier
bereits gut zu erkennen. Auch für Ihre eigenen Check-Plugins empfiehlt
sich daher die Verwendung von Präfixen. Die zweite Spalte zeigt übrigens
an, wie das jeweilige Check-Plugin seine Daten bezieht.
:::

::: paragraph
Ein für unser Beispiel passender Name für das neue Check-Plugin ist zum
Beispiel `myhostgroups`.
:::

::: paragraph
Nun haben Sie alle Informationen zusammen, um das Skript mit dem
Agentenplugin zu erstellen. Legen Sie als `root`-Benutzer eine neue
Datei `myhostgroups` im Verzeichnis `/usr/lib/check_mk_agent/plugins/`
an:
:::

::::: listingblock
::: title
/usr/lib/check_mk_agent/plugins/myhostgroups
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

columns="name members"
site="mysite"

echo '<<<myhostgroups:sep(59)>>>'
su - ${site} lq "GET hostgroups\nColumns: ${columns}"
```
:::
:::::

::: paragraph
Was bedeutet das nun im Einzelnen?
:::

::: paragraph
Die erste Zeile enthält den „Shebang" (das ist eine Abkürzung für
*sharp* und *bang,* wobei Letzteres eine Abkürzung für das
Ausrufezeichen ist), an dem Linux erkennt, dass es das Skript mit der
angegebenen Shell ausführen soll.
:::

::: paragraph
Um das Skript erweiterbar zu halten, werden als nächstes zwei Variablen
eingeführt:
:::

::: ulist
- die Variable `columns`, die aktuell die Gruppennamen und die
  zugehörigen Mitglieder enthält,

- die Variable `site`, die den Namen der Checkmk-Instanz enthält.
:::

::: paragraph
Mit dem `echo`-Befehl geben Sie den Sektions-Header aus. Da die Spalten
der Tabelle mit dem Semikolon getrennt werden, legen Sie gleichzeitig
mit dem Zusatz `sep(59)` fest, dass das Semikolon als Trennzeichen
(*separator*) für die Daten in der Agentenausgabe genutzt wird. 59 steht
für das
[ASCII](https://de.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange#ASCII-Tabelle){target="_blank"}-Zeichen
Nummer 59, das Semikolon. Ohne diesen Zusatz würde als Standard das
Leerzeichen (ASCII-Zeichen 32) als Trennzeichen verwendet werden.
:::

::: paragraph
Um den `lq`-Befehl, der Ihnen als Instanzbenutzer zur Verfügung steht,
auch in einem Skript nutzen zu können, das vom `root`-Benutzer
ausgeführt wird, stellen Sie ein `su` voran.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Es kann vorkommen, dass der       |
|                                   | Zugriff auf `lq` per `su`         |
|                                   | Probleme bereitet. Sie können     |
|                                   | alternativ als `root`-Benutzer    |
|                                   | auch direkt auf Livestatus in der |
|                                   | Shell mit `printf` oder `echo -e` |
|                                   | über einen Unix-Socket zugreifen. |
|                                   | Im Artikel zu                     |
|                                   | [Lives                            |
|                                   | tatus](livestatus.html#lql_shell) |
|                                   | erfahren Sie, wie das geht.       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Eines ist noch wichtig, sobald Sie die Datei erstellt haben. Machen Sie
die Datei ausführbar:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod +x /usr/lib/check_mk_agent/plugins/myhostgroups
```
:::
::::

::: paragraph
Sie können das Agentenplugin direkt von Hand ausprobieren, indem Sie den
kompletten Pfad als Befehl eingeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/plugins/myhostgroups
<<<myhostgroups:sep(59)>>>
Hamburg;myhost11,myhost22,myhost33
Munich;myhost1,myhost2,myhost3
check_mk;localhost
```
:::
::::

::: paragraph
Host-Gruppen, die keine Hosts enthalten, werden hierbei nicht
aufgeführt.
:::
::::::::::::::::::::::::::::::

::::::::::::::::::::: sect2
### []{#test_agent .hidden-anchor .sr-only}2.3. Agent ausprobieren {#heading_test_agent}

::: paragraph
Test und Fehlersuche sind am wichtigsten, um zu einem funktionierenden
Agentenplugin zu gelangen. Am besten gehen Sie in drei Schritten vor:
:::

::: {.olist .arabic}
1.  Agentenplugin solo ausprobieren. Das haben Sie gerade im vorherigen
    Abschnitt gemacht.

2.  Agent als Ganzes lokal testen.

3.  Agent vom Checkmk-Server aus abrufen.
:::

::: paragraph
Das lokale Testen des Agenten ist sehr einfach. Rufen Sie als `root` den
Befehl `check_mk_agent` auf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent
```
:::
::::

::: paragraph
Irgendwo in der sehr langen Ausgabe muss die neue Sektion erscheinen.
Agentenplugins werden vom Agenten zum Schluss ausgegeben.
:::

::: paragraph
Durch Anhängen von `less` können Sie in der Ausgabe blättern (drücken
Sie die Leertaste zum Blättern, `/` zum Suchen und `q` zum Beenden):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent | less
```
:::
::::

::: paragraph
Oder Sie durchsuchen die Ausgabe nach den interessanten Zeilen. So hat
`grep` mit `-A` eine Option, nach jedem Treffer noch einige Zeilen mehr
auszugeben. Damit können Sie bequem die Sektion suchen und ausgeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent | grep -A3 '^<<<myhostgroups'
<<<myhostgroups:sep(59)>>>
Hamburg;myhost11,myhost22,myhost33
Munich;myhost1,myhost2,myhost3
check_mk;localhost
```
:::
::::

::: paragraph
Der dritte und letzte Test ist dann direkt von der Checkmk-Instanz aus.
Nehmen Sie den [Host ins Monitoring](intro_setup_monitor.html#linux) auf
(zum Beispiel als `localhost`), melden Sie sich als Instanzbenutzer an
und rufen Sie dann die Agentendaten mit `cmk -d` ab:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d localhost | grep -A3 '^<<<myhostgroups'
```
:::
::::

::: paragraph
Hier sollte die gleiche Ausgabe kommen wie beim vorherigen Befehl.
:::

::: paragraph
Wenn das funktioniert, ist Ihr Agent vorbereitet. Und was haben Sie
dafür gemacht? Sie haben ein kurzes Skript unter dem Pfadnamen
`/usr/lib/check_mk_agent/plugins/myhostgroups` erzeugt und ausführbar
gemacht.
:::

::: paragraph
Alles was nun folgt, geschieht nur noch auf dem Checkmk-Server: Dort
schreiben Sie das Check-Plugin.
:::
:::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#write_check_plugin .hidden-anchor .sr-only}3. Ein einfaches Check-Plugin schreiben {#heading_write_check_plugin}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Vorbereiten des Agenten ist nur die halbe Miete. Jetzt müssen Sie
Checkmk noch beibringen, wie es mit den Informationen aus der neuen
Agentensektion umgehen soll, welche Services es erzeugen soll, wann
diese auf [WARN]{.state1} oder [CRIT]{.state2} gehen sollen usw. All
dies machen Sie durch die Programmierung eines Check-Plugins in Python.
:::

::::::::::::::::::: sect2
### []{#scaffold .hidden-anchor .sr-only}3.1. Die Datei vorbereiten {#heading_scaffold}

::: paragraph
Für Ihre eigenen Check-Plugins finden Sie das Basisverzeichnis
vorbereitet in der `local`-Hierarchie des
[Instanzverzeichnisses.](cmk_commandline.html#sitedir) Dieses lautet
`~/local/lib/python3/cmk_addons/plugins/`. Das Verzeichnis gehört dem
Instanzbenutzer und ist daher für Sie schreibbar.
:::

::: paragraph
In diesem Verzeichnis werden die Plugins in *Plugin-Familien*
organisiert, deren Verzeichnisnamen Sie frei wählen können. Zum Beispiel
werden alle Plugins, die Cisco-Geräte betreffen, im Ordner `cisco`
abgelegt, oder im Ordner `myhostgroups` alle Plugins, die Ihre
Host-Gruppen betreffen. Diese Konvention ermöglicht es, dass alle
Plugins, die zur gleichen Familie gehören, Code gemeinsam nutzen
können --- und wird genau so auch von den Plugins genutzt, die mit
Checkmk ausgeliefert werden.
:::

::: paragraph
In diesem Unterverzeichnis `<plug-in_family>` werden dann nach Bedarf
für die verschiedenen APIs weitere Unterverzeichnisse mit vorgegebenem
Namen angelegt, z.B. `agent_based` für die Check-API agentenbasierter
Check-Plugins. Weitere Unterverzeichnisse für die
[Rulesets-API](#rule_set) und die [Graphing-API](#metrics_advanced)
werden wir später vorstellen.
:::

::: paragraph
Erstellen Sie die beiden Unterverzeichnisse für das neue agentenbasierte
Check-Plugin und wechseln Sie am besten danach zum Arbeiten dort hinein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir -p local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based
OMD[mysite]:~$ cd local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based
```
:::
::::

::: paragraph
Sie können Ihr Check-Plugin mit jedem auf dem Linux-System installierten
Texteditor bearbeiten.
:::

::: paragraph
Legen Sie also die Datei `myhostgroups.py` für das Check-Plugin hier an.
Konvention ist, dass der Dateiname den Namen der Agentensektion
wiedergibt. *Pflicht* ist, dass die Datei mit `.py` endet, denn ab
Version [2.0.0]{.new} von Checkmk handelt es sich bei den Check-Plugins
immer um echte Python-Module.
:::

::: paragraph
Ein lauffähiges Grundgerüst ([Download bei
GitHub](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/check_plugin_simple_myhostgroups_bare_minimum.py){target="_blank"}),
das Sie im Folgenden Schritt für Schritt weiter ausbauen werden, sieht
so aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python3

from cmk.agent_based.v2 import AgentSection, CheckPlugin, Service, Result, State, Metric, check_levels

def parse_myhostgroups(string_table):
    parsed = {}
    return parsed

def discover_myhostgroups(section):
    yield Service()

def check_myhostgroups(section):
    yield Result(state=State.OK, summary="Everything is fine")

agent_section_myhostgroups = AgentSection(
    name = "myhostgroups",
    parse_function = parse_myhostgroups,
)

check_plugin_myhostgroups = CheckPlugin(
    name = "myhostgroups",
    service_name = "Host group check_mk",
    discovery_function = discover_myhostgroups,
    check_function = check_myhostgroups,
)
```
:::
:::::

::: paragraph
Als erstes müssen Sie die für die Check-Plugins nötigen Funktionen und
Klassen aus Python-Modulen importieren. Für unser Beispiel wird nur
importiert, was im weiteren Verlauf des Artikels genutzt wird oder
nützlich sein kann. Dabei wird mit `cmk.agent_based.v2` festgelegt, dass
die Module aus der Check-API **V2** importiert werden:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
from cmk.agent_based.v2 import AgentSection, CheckPlugin, Service, Result, State, Metric, check_levels
```
:::
:::::
:::::::::::::::::::

:::::::::::::::::::::: sect2
### []{#parse_function .hidden-anchor .sr-only}3.2. Die Parse-Funktion schreiben {#heading_parse_function}

::: paragraph
Die Parse-Funktion hat die Aufgabe, die „rohen" Agentendaten zu
„parsen", das heißt zu analysieren und zu zerteilen, und in eine logisch
aufgeräumte Form zu bringen, die für alle weiteren Schritte einfach zu
verarbeiten ist.
:::

::: paragraph
Wie im Abschnitt zum [Testen des Agenten](#test_agent) gezeigt, hat die
vom Agentenplugin gelieferte Sektion die folgende Struktur:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
<<<myhostgroups:sep(59)>>>
Hamburg;myhost11,myhost22,myhost33
Munich;myhost1,myhost2,myhost3
check_mk;localhost
```
:::
::::

::: paragraph
Checkmk zerlegt bereits die Zeilen der vom Agentenplugin gelieferten
Sektion anhand des Trennzeichens im Sektions-Header (im Beispiel `;`) in
eine Liste von Zeilen, die ihrerseits wiederum Listen von Worten sind.
In Checkmk steht daher statt der Rohdaten des Agentenplugins die
folgende Datenstruktur zur Verfügung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
[
    ['Hamburg', 'myhost11,myhost22,myhost33'],
    ['Munich', 'myhost1,myhost2,myhost3'],
    ['check_mk', 'localhost']
]
```
:::
::::

::: paragraph
In der inneren Liste enthält das jeweils erste Element den Namen der
Host-Gruppe und das zweite die Namen der der Gruppe angehörenden Hosts.
:::

::: paragraph
Diese Informationen können Sie zwar alle ansprechen, aber jeweils nur
über ihre Position im Datensatz. Sie müssten also immer angeben, die
wievielte eckige Klammer und den wievielten Inhalt innerhalb der
jeweiligen Klammer Sie brauchen. Bei größeren Datenmengen gestaltet sich
dies komplex und es wird immer schwieriger, den Überblick zu behalten.
:::

::: paragraph
An diesem Punkt bietet eine Parse-Funktion durch die von ihr erzeugte
Struktur deutliche Vorteile. Durch sie wird der Code leichter lesbar,
die Zugriffe werden performanter und Sie behalten viel einfacher den
Überblick. Sie transformiert die von Checkmk gelieferte Datenstruktur
so, dass man jeden der einzelnen Werte wahlfrei durch einen Namen (oder
Schlüssel) ansprechen kann und nicht darauf angewiesen ist, den Bereich
(*array*) iterativ zu durchlaufen, um das zu finden, was man sucht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
{
    'Hamburg': {'members': 'myhost11,myhost22,myhost33'},
    'Munich': {'members': 'myhost1,myhost2,myhost3'},
    'check_mk': {'members': 'localhost'}
}
```
:::
::::

::: paragraph
Konvention ist, dass die Parse-Funktion nach der Agentensektion benannt
wird und mit `parse_` beginnt. Sie bekommt als einziges Argument
`string_table` übergeben. Beachten Sie, dass Sie hier nicht frei in der
Wahl des Arguments sind. Es *muss* exakt so heißen.
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def parse_myhostgroups(string_table):
    # print(string_table)
    parsed = {}
    for line in string_table:
        parsed[line[0]] = {"members": line[1]}
    # print(parsed)
    return parsed
```
:::
:::::

::: paragraph
Mit `def` geben Sie in Python an, dass nachfolgend eine Funktion
definiert wird. `parsed = {}` erzeugt das *Dictionary* mit der
verbesserten Datenstruktur. In unserem Beispiel wird jede Zeile Element
für Element durchgegangen. Aus jeder Zeile wird die Host-Gruppe gefolgt
von den Mitgliedern der Host-Gruppe genommen und zu einem Eintrag für
das Dictionary zusammengesetzt.
:::

::: paragraph
Mit `return parsed` wird dann das Dictionary zurückgegeben.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Im oben gezeigten Beispiel finden |
|                                   | Sie zwei auskommentierte Zeilen.  |
|                                   | Wenn Sie diese später beim        |
|                                   | [Testen des Check-Plugins](#test) |
|                                   | einkommentieren, werden Ihnen die |
|                                   | Daten vor und nach der Ausführung |
|                                   | der Parse-Funktion auf der        |
|                                   | Kommandozeile angezeigt. So       |
|                                   | können Sie überprüfen, ob die     |
|                                   | Funktion auch wirklich das tut,   |
|                                   | was sie soll.                     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::::::::::::

::::::::::: sect2
### []{#agent_section .hidden-anchor .sr-only}3.3. Die Agentensektion erstellen {#heading_agent_section}

::: paragraph
Damit das Ganze auch etwas bewirken kann, müssen Sie die neue
Agentensektion mit der neuen Parse-Funktion erzeugen. Nur so wird sie
von Checkmk erkannt und berücksichtigt. Dazu erstellen Sie die
Agentensektion als Instanz der Klasse `AgentSection`:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
agent_section_myhostgroups = AgentSection(
    name = "myhostgroups",
    parse_function = parse_myhostgroups,
)
```
:::
:::::

::: paragraph
Hier ist es wichtig, dass der Name der Sektion wirklich exakt mit dem
Sektions-Header in der Agentenausgabe übereinstimmt. Von diesem Moment
an bekommt jedes Check-Plugin, das die Sektion `myhostgroups` benutzt,
den Rückgabewert der Parse-Funktion übergeben. In der Regel wird das das
gleichnamige Check-Plugin sein. Aber auch andere Check-Plugins können
dieses Sektion abonnieren, wie wir bei der [Erweiterung des
Check-Plugins](#discovery) noch zeigen werden.
:::

::: paragraph
Übrigens: Wenn Sie es ganz genau wissen wollen, können Sie an dieser
Stelle einen Blick in die [Check-API-Dokumentation](#check_api_doc)
werfen. Dort finden Sie die detaillierte Beschreibung dieser
Klasse --- und auch der Klassen, Funktionen und Objekte, die später im
Artikel noch verwendet werden.
:::

:::: {.imageblock .border}
::: content
![Check-API-Dokumentation für die Klasse
\'AgentSection\'.](../images/devel_cpi_checkapi_doc_agent_section.png)
:::
::::
:::::::::::

:::::::::::: sect2
### []{#check_plug-in .hidden-anchor .sr-only}3.4. Das Check-Plugin erstellen {#heading_check_plug-in}

::: paragraph
Damit Checkmk erkennen kann, dass es ein neues Check-Plugin gibt, muss
dieses erzeugt werden. Dies geschieht durch die Erstellung einer Instanz
der Klasse `CheckPlugin`.
:::

::: paragraph
Dabei müssen Sie immer mindestens vier Dinge angeben:
:::

::: {.olist .arabic}
1.  `name`: Der Name des Check-Plugins. Am einfachsten ist es, wenn Sie
    hier den gleichen Namen wie bei Ihrer neuen Agentensektion nehmen.
    Damit weiß der später in der Check-Funktion definierte Check
    automatisch, welche Sektion er auswerten soll.

2.  `service_name`: Der Name des Services wie er dann im Monitoring
    erscheinen soll.

3.  `discovery_function`: Die Funktion zum Erkennen von Services dieses
    Typs (dazu gleich mehr).

4.  `check_funktion`: Die Funktion zum Durchführen des eigentlichen
    Checks (auch dazu gleich mehr).
:::

::: paragraph
Der Name der Instanz muss dabei mit `check_plugin_` beginnen. Das sieht
dann so aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
check_plugin_myhostgroups = CheckPlugin(
    name = "myhostgroups",
    service_name = "Host group check_mk",
    discovery_function = discover_myhostgroups,
    check_function = check_myhostgroups,
)
```
:::
:::::

::: paragraph
Versuchen Sie am besten noch nicht, das gleich auszuprobieren, denn Sie
müssen die Funktionen `discover_myhostgroups` und `check_myhostgroups`
vorher noch schreiben. Und diese müssen im Quellcode *vor* obiger
Erstellung von Agentensektion und Check-Plugin erscheinen.
:::

::: paragraph
Unresolved directive in devel_check_plugins.asciidoc -
include::include_special_chars.asciidoc\[\]
:::
::::::::::::

::::::::::: sect2
### []{#discovery_function .hidden-anchor .sr-only}3.5. Die Discovery-Funktion schreiben {#heading_discovery_function}

::: paragraph
Eine Besonderheit von Checkmk ist die automatische Erkennung von zu
überwachenden Services. Damit dies klappt, muss jedes Check-Plugin eine
Funktion definieren, welche anhand der Agentenausgabe erkennt, *ob* ein
Service dieses Typs bzw. *welche* Services des Typs für den betreffenden
Host angelegt werden sollen.
:::

::: paragraph
Die Discovery-Funktion wird immer dann aufgerufen, wenn für einen Host
die Service-Erkennung durchgeführt wird. Sie entscheidet dann ob, bzw.
welche Services angelegt werden sollen. Im Standardfall bekommt sie
genau ein Argument mit dem Namen `section`. Dieses enthält die Daten der
Agentensektion in einem durch die [Parse-Funktion](#parse_function)
aufbereiteten Format.
:::

::: paragraph
Daher implementieren Sie folgende simple Logik: *Wenn* die
Agentensektion `myhostgroups` vorhanden ist, dann legen Sie auch einen
passenden Service an. Dann erscheint dieser automatisch auf allen Hosts,
auf denen das Agentenplugin verteilt ist.
:::

::: paragraph
Bei Check-Plugins, die pro Host nur einen Service erzeugen, benötigt man
keine weiteren Angaben:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def discover_myhostgroups(section):
    yield Service()
```
:::
:::::

::: paragraph
Die Discovery-Funktion muss für jeden anzulegenden Service mittels
`yield` ein Objekt vom Typ `Service` zurückgeben (nicht mit `return`).
`yield` hat in Python die gleiche Aufgabe wie `return` -- beide geben
einen Wert an die aufrufende Funktion zurück. Der entscheidende
Unterschied besteht darin, dass sich bei einem `yield` gemerkt wird, wie
weit die Funktion in einer Datenverarbeitung gekommen ist. Beim nächsten
Aufruf wird *nach* der letzten `yield`-Anweisung weiter gemacht - und
nicht wieder am Anfang begonnen. Dadurch wird nicht nur der erste
Treffer ausgelesen (wie es beim `return` der Fall wäre), sondern
sukzessive alle Treffer (dieser Vorteil wird später in unserem Beispiel
bei der [Service-Erkennung](#discovery) noch relevant).
:::
:::::::::::

:::::::::::::: sect2
### []{#check_function .hidden-anchor .sr-only}3.6. Die Check-Funktion schreiben {#heading_check_function}

::: paragraph
Somit können Sie nun zur eigentlichen Check-Funktion kommen, welche
anhand der aktuellen Agentenausgabe entscheidet, welchen Zustand der
Service annehmen soll und weitere Informationen ausgeben kann.
:::

::: paragraph
Ziel der Check-Funktion ist es, eine Prüfung aufzusetzen, mit der
kontrolliert werden kann, ob für keinen Host vergessen wurde, eine
Host-Gruppe zuzuweisen. Dazu wird überprüft, ob die Host-Gruppe
`check_mk` Hosts enthält. Wenn das der Fall ist, soll der Service den
Zustand [CRIT]{.state2} erhalten. Wenn nicht, ist alles [OK]{.state0}
und der Zustand des Services auch.
:::

::: paragraph
Hier ist die Implementierung:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups(section):
    attr = section.get("check_mk")
    hosts = attr["members"] if attr else ""
    if hosts:
        yield Result(state=State.CRIT, summary=f"Default group is not empty; Current member list: {hosts}")
    else:
        yield Result(state=State.OK, summary="Everything is fine")
```
:::
:::::

::: paragraph
Und nun die Erklärung dazu: Die Funktion `check_myhostgroups()` holt als
erstes den zum Schlüssel `check_mk` gehörenden Wert in die Variable
`attr`. Dann wird die Variable `hosts` mit dem `members`-Wert verknüpft,
wenn dieser vorhanden ist. Gibt es keine `members`, so bleibt `hosts`
leer.
:::

::: paragraph
Jetzt folgt eine `if`-Abfrage für die eigentliche Auswertung:
:::

::: ulist
- Enthält die Variable `hosts` Inhalte, ist also die Host-Gruppe
  `check_mk` nicht leer, so geht der Status des Services auf
  [CRIT]{.state2} und es wird ein Hinweistext ausgegeben. Dieser enthält
  zusätzlich eine Auflistung der Host-Namen aller Hosts, die sich in der
  Host-Gruppe `check_mk` befinden. Für die Ausgabe des Textes mit
  Ausdrücken wird der Python
  [F-String](https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals){target="_blank"}
  verwendet, der so heißt, weil vor der String-Zeichenfolge der
  Buchstabe `f` steht.

- Ist die Variable `hosts` leer, sind also keine Hosts in der
  Host-Gruppe `check_mk`, so geht stattdessen der Status des Services
  auf [OK]{.state0}. Dann wird zudem ein passender Hinweistext
  ausgegeben.
:::

::: paragraph
Mit der Erstellung der Check-Funktion ist das Check-Plugin fertig.
:::

::: paragraph
Das
[Check-Plugin](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/check_plugin_simple_myhostgroups.py){target="_blank"}
und auch das
[Agentenplugin](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/agent_plugin_simple_myhostgroups){target="_blank"}
haben wir auf GitHub bereitgestellt.
:::
::::::::::::::

::::::::::::::::::::: sect2
### []{#test .hidden-anchor .sr-only}3.7. Das Check-Plugin testen und aktivieren {#heading_test}

::: paragraph
Test und Aktivierung werden auf der Kommandozeile mit dem Befehl `cmk`
erledigt.
:::

::: paragraph
Probieren Sie zunächst die
[Service-Erkennung](wato_services.html#commandline) mit der Option `-I`
aus. Durch Zugabe der Option `v` (für *verbose*) werden ausführliche
Ausgaben angefordert. Das `--detect-plugins` beschränkt die
Befehlsausführung auf dieses Check-Plugin und durch `localhost` auf eben
diesen Host:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vI --detect-plugins=myhostgroups localhost
Discovering services and host labels on: localhost
localhost:
+ FETCHING DATA
No piggyback files for 'localhost'. Skip processing.
Get piggybacked data
+ ANALYSE DISCOVERED HOST LABELS
SUCCESS - Found no new host labels
+ ANALYSE DISCOVERED SERVICES
+ EXECUTING DISCOVERY PLUGINS (1)
  1 myhostgroups
SUCCESS - Found 1 services
```
:::
::::

::: paragraph
Wie geplant, erkennt die Service-Erkennung einen neuen Service im
Check-Plugin `myhostgroups`.
:::

::: paragraph
Jetzt können Sie den im Check-Plugin enthaltenen [Check
ausprobieren:](cmk_commandline.html#execute_checks)
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --detect-plugins=myhostgroups -v localhost
+ FETCHING DATA
No piggyback files for 'localhost'. Skip processing.
Get piggybacked data
Host group check_mk  Default group is not empty; Current member list: localhost
No piggyback files for 'localhost'. Skip processing.
[agent] Success, [piggyback] Success (but no data found for this host), execution time 1.8 sec | execution_time=1.800 user_time=0.030 system_time=0.000 children_user_time=0.000 children_system_time=0.000 cmk_time_agent=1.780
```
:::
::::

::: paragraph
Durch Ausführung des Checks wird der Zustand des zuvor gefundenen
Services bestimmt.
:::

::: paragraph
Wenn soweit alles wie erwartet abgelaufen ist, können Sie die Änderungen
aktivieren. Falls nicht, finden Sie im Kapitel zur
[Fehlerbehebung](#errors) Hinweise.
:::

::: paragraph
Aktivieren Sie zum Abschluss die Änderungen durch einen [Neustart des
Monitoring-Kerns:](cmk_commandline.html#commands_core)
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -R
Generating configuration for core (type nagios)...
Precompiling host checks...OK
Validating Nagios configuration...OK
Restarting monitoring core...OK
```
:::
::::

::: paragraph
Im Monitoring von Checkmk finden Sie nun beim Host `localhost` den neuen
Service [Host group check_mk:]{.guihint}
:::

::::: imageblock
::: content
![Der vom Check-Plugin erzeugte neue Service im
Monitoring.](../images/devel_cpi_service_simple.png)
:::

::: title
Da die Host-Gruppe `check_mk` nicht leer ist, ist der Service
[CRIT]{.state2}
:::
:::::

::: paragraph
Wir gratulieren Ihnen zur erfolgreichen Erstellung des ersten
Check-Plugins!
:::
:::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#extend .hidden-anchor .sr-only}4. Das Check-Plugin erweitern {#heading_extend}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::::::: sect2
### []{#prepare .hidden-anchor .sr-only}4.1. Vorbereitungen {#heading_prepare}

::: paragraph
Das gerade frisch fertiggestellte erste Check-Plugin soll nun
schrittweise erweitert werden. Bisher hat das Agentenplugin nur die
Informationen über die Namen und die Mitglieder der Host-Gruppen
geliefert. Um etwa die Zustände der Hosts und der auf ihnen laufenden
Services auswerten zu können, braucht es mehr Daten.
:::

:::::::::::::::::: sect3
#### []{#_agentenplugin_erweitern .hidden-anchor .sr-only}Agentenplugin erweitern {#heading__agentenplugin_erweitern}

::: paragraph
Sie werden zunächst das Agentenplugin *einmal* erweitern, um all die
Informationen einzusammeln, die für die Erweiterung des Check-Plugins in
den nächsten Abschnitten benötigt werden.
:::

::: paragraph
Um herauszubekommen, welche Informationen Checkmk denn für Host-Gruppen
so bietet, können Sie alle verfügbaren Spalten der Host-Gruppentabelle
mit [folgendem Befehl](livestatus.html#columns) als Instanzbenutzer
abfragen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET columns\nFilter: table = hostgroups\nColumns: name"
action_url
alias
members
members_with_state
name
notes
notes_url
num_hosts
...
```
:::
::::

::: paragraph
Die Ausgabe geht noch weiter. Fast 30 Spalten bietet die Tabelle --- und
unter den meisten Spaltennamen kann man sich sogar etwas vorstellen.
Hier interessieren die folgenden Spalten: Anzahl der Hosts pro Gruppe
(Spalte `num_hosts`), Anzahl der Hosts im Zustand [UP]{.hstate0}
(`num_hosts_up`), Anzahl der Services aller Hosts in der Gruppe
(`num_services`) und Anzahl der Services im Zustand [OK]{.state0}
(`num_services_ok`).
:::

::: paragraph
Jetzt müssen diese neuen Spalten nur noch vom Agenten geliefert werden.
Das erreichen Sie durch Erweiterung des im vorherigen Kapitel erstellten
[Agentenplugins.](#agentplugin)
:::

::: paragraph
Editieren Sie als root-Benutzer das Skript des Agentenplugins. Da das
Skript die konfigurierbaren Werte bereits in Variablen gesteckt hat,
reicht es aus, nur die mit `columns` beginnende Zeile zu ändern und dort
die zusätzlich abgerufenen vier Spalten einzutragen:
:::

::::: listingblock
::: title
/usr/lib/check_mk_agent/plugins/myhostgroups
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

columns="name members num_hosts num_hosts_up num_services num_services_ok"
site="mysite"

echo '<<<myhostgroups:sep(59)>>>'
su - ${site} lq "GET hostgroups\nColumns: ${columns}"
```
:::
:::::

::: paragraph
Führen Sie zur Kontrolle das Skript aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/plugins/myhostgroups
<<<myhostgroups:sep(59)>>>
Munich;myhost3,myhost2,myhost1;3;3;180;144
Hamburg;myhost22,myhost33,myhost11;3;2;132;105
check_mk;localhost;1;1;62;45
```
:::
::::

::: paragraph
Am Ende jeder Zeile stehen nun, durch Semikolon abgetrennt, die vier
neuen Werte.
:::

::: paragraph
Mit dieser Änderung liefert das Agentenplugin nun andere Daten als
vorher. An dieser Stelle ist es wichtig, sich zu vergewissern, dass das
Check-Plugin auch mit den geänderten Daten immer noch das tut, was es
soll.
:::
::::::::::::::::::

::::::::::: sect3
#### []{#_parse_funktion_erweitern .hidden-anchor .sr-only}Parse-Funktion erweitern {#heading__parse_funktion_erweitern}

::: paragraph
Im Check-Plugin ist die Parse-Funktion für die Umwandlung der vom
Agentenplugin gelieferten Daten verantwortlich. Beim [Schreiben der
Parse-Funktion](#parse_function) haben Sie nur zwei Spalten der
Host-Gruppentabelle berücksichtigt. Nun werden sechs statt zwei Spalten
geliefert. Die Parse-Funktion muss also fit gemacht werden, um auch die
zusätzlichen vier Spalten zu verarbeiten.
:::

::: paragraph
Ändern Sie als Instanzbenutzer die Parse-Funktion in der Datei
`myhostgroups.py`, die das Check-Plugin enthält:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def parse_myhostgroups(string_table):
    parsed = {}
    column_names = [
        "name",
        "members",
        "num_hosts",
        "num_hosts_up",
        "num_services",
        "num_services_ok",
    ]
    for line in string_table:
        parsed[line[0]] = {}
        for n in range(1, len(column_names)):
            parsed[line[0]][column_names[n]] = line[n]
    return parsed
```
:::
:::::

::: paragraph
Geändert wurde hier alles zwischen `parsed = {}` und `return parsed`.
Zuerst werden die zu verarbeitenden Spalten unter ihren Namen als Liste
`column_names` definiert. In der `for`-Schleife wird dann ein Dictionary
aufgebaut, indem in jeder Zeile aus Spaltenname und ausgelesenem Wert
die Schlüssel-Wert-Paare erzeugt werden.
:::

::: paragraph
Für die existierende [Check-Funktion](#check_function) ist diese
Erweiterung unkritisch, denn die Datenstruktur für die ersten beiden
Spalten bleibt unverändert. Es werden nur zusätzliche Spalten
bereitgestellt, die in der Check-Funktion (noch) gar nicht ausgewertet
werden.
:::

::: paragraph
Nun, da die neuen Daten verarbeitet werden können, werden Sie sie auch
nutzen.
:::
:::::::::::
:::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::: sect2
### []{#discovery .hidden-anchor .sr-only}4.2. Service-Erkennung {#heading_discovery}

::: paragraph
Im [vorherigen Kapitel](#check_function) haben Sie einen sehr einfachen
Check gebaut, der auf einem Host einen Service erzeugt. Ein sehr
üblicher Fall ist aber auch, dass es von einem Check mehrere Services
auf einem Host geben kann.
:::

::: paragraph
Das häufigste Beispiel dafür sind die Dateisysteme eines Hosts. Das
Check-Plugin mit dem Namen `df` legt pro Dateisystem auf dem Host einen
Service an. Um diese Services zu unterscheiden, wird der Mount-Punkt des
Dateisystems (zum Beispiel `/var`) bzw. der Laufwerksbuchstabe (zum
Beispiel `C:`) in den Namen des Services eingebaut. Das ergibt dann als
Service-Name zum Beispiel `Filesystem /var` oder `Filesystem C:`. Das
Wort `/var` bzw. `C:` wird hier als *Item* bezeichnet. Wir sprechen also
auch von einem *Check mit Items.*
:::

::: paragraph
Wenn Sie einen Check mit Items bauen möchten, müssen Sie folgende Dinge
umsetzen:
:::

::: ulist
- Die Discovery-Funktion muss für jedes der Items, die auf dem Host
  sinnvollerweise überwacht werden sollen, einen Service generieren.

- Im Service-Namen müssen Sie das Item mithilfe des Platzhalters `%s`
  einbauen (also zum Beispiel `"Filesystem %s"`).

- Die Check-Funktion wird pro Item einmal separat aufgerufen und bekommt
  dieses als Argument. Sie muss dann aus den Agentendaten die für dieses
  Item relevanten Daten herausfischen.
:::

::: paragraph
Um dies praktisch auszuprobieren, werden Sie für jede existierende
Host-Gruppe einen eigenen Service erzeugen.
:::

::: paragraph
Da das im vorherigen Kapitel erstellte Check-Plugin `myhostgroups` zur
Überprüfung der Standardgruppe `check_mk` weiterhin funktionieren soll,
bleibt dieses Check-Plugin so, wie es ist. Für die Erweiterung erstellen
Sie in der bestehenden Datei `myhostgroups.py` das neue Check-Plugin
`myhostgroups_advanced` --- im ersten Schritt so wie
[zuvor](#check_plug-in) durch die Erstellung einer Instanz der Klasse
`CheckPlugin`.
:::

::: paragraph
Hier finden Sie den alten und markiert den neuen Code:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
check_plugin_myhostgroups = CheckPlugin(
    name = "myhostgroups",
    service_name = "Host group check_mk",
    discovery_function = discover_myhostgroups,
    check_function = check_myhostgroups,
)

check_plugin_myhostgroups_advanced = CheckPlugin(
    name = "myhostgroups_advanced",
    sections = [ "myhostgroups" ],
    service_name = "Host group %s",
    discovery_function = discover_myhostgroups_advanced,
    check_function = check_myhostgroups_advanced,
)
```
:::
:::::

::: paragraph
Damit man das neue vom alten Check-Plugin unterscheiden kann, erhält es
mit `myhostgroups_advanced` einen eindeutigen Namen. Der Parameter
`sections` bestimmt die Sektionen der Agentenausgabe, die das
Check-Plugin abonniert. Mit `myhostgroups` wird hier festgelegt, dass
das neue Check-Plugin die gleichen Daten nutzt wie das alte: die durch
die Parse-Funktion aufbereitete Sektion des Agentenplugins. Der
Service-Name enthält jetzt den Platzhalter `%s`. An dieser Stelle wird
später dann von Checkmk der Name des Items eingesetzt. In den letzten
beiden Zeilen werden schließlich die Namen für die neue
Discovery-Funktion und die neue Check-Funktion festgelegt, die beide
noch geschrieben werden wollen.
:::

::: paragraph
Zuerst zur Discovery-Funktion, die jetzt die Aufgabe hat, die zu
überwachenden Items zu ermitteln -- auch diese wird *zusätzlich* zur
vorhandenen eingetragen:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def discover_myhostgroups_advanced(section):
    for group in section:
        if group != "check_mk":
            yield Service(item=group)
```
:::
:::::

::: paragraph
Wie [zuvor](#discovery_function) bekommt die Discovery-Funktion das
Argument `section`. Mit einer Schleife werden die einzelnen Host-Gruppen
durchlaufen. Hier interessieren alle Host-Gruppen --- mit Ausnahme von
`check_mk`, denn um diese spezielle Host-Gruppe kümmert sich bereits das
existierende Check-Plugin `myhostgroups`. Immer, wenn ein Item gefunden
wurde, wird es mit `yield` zurück gegeben, wobei ein Objekt vom Typ
`Service` erzeugt wird, das den Host-Gruppennamen als Item übergeben
bekommt.
:::

::: paragraph
Wenn später der Host überwacht wird, dann wird die Check-Funktion für
jeden Service --- und damit für jedes Item --- separat aufgerufen. Womit
Sie bereits bei der Definition der Check-Funktion für das neue
Check-Plugin `myhostgroups_advanced` angekommen sind. Die Check-Funktion
bekommt zusätzlich zur Sektion das Argument `item` übergeben. Die erste
Zeile der Funktion sieht dann so aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, section):
```
:::
:::::

::: paragraph
Der Algorithmus für die Check-Funktion ist einfach: Wenn die Host-Gruppe
existiert, wird der Service auf [OK]{.state0} gesetzt und Anzahl und
Namen der Hosts in der Gruppe aufgelistet. Die komplette Funktion dazu:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, section):
    attr = section.get(item)
    if attr:
        yield Result(state=State.OK, summary=f"{attr['num_hosts']} hosts in this group: {attr['members']}")
```
:::
:::::

::: paragraph
Das Check-Ergebnis wird geliefert, indem ein Objekt der Klasse `Result`
per `yield` zurückgeben wird. Dieses benötigt die Parameter `state` und
`summary`. Dabei legt `state` den Zustand des Services fest (im Beispiel
`OK`) und `summary` den Text, der in dem [Summary]{.guihint} des
Services angezeigt wird. Er ist rein informativ und wird von Checkmk
nicht weiter ausgewertet. Mehr dazu erfahren Sie im [nächsten
Abschnitt.](#summary_details)
:::

::: paragraph
So weit, so gut. Was passiert aber, wenn das gesuchte Item nicht
gefunden wird? Das kann passieren, wenn in der Vergangenheit ein Service
für eine Host-Gruppe bereits erzeugt wurde, diese Host-Gruppe aber nun
verschwunden ist --- entweder weil die Host-Gruppe in Checkmk noch
existiert, aber keinen Host mehr enthält, oder weil sie gleich ganz
gelöscht wurde. In beiden Fällen ist diese Host-Gruppe in der
Agentenausgabe nicht (mehr) präsent.
:::

::: paragraph
Die gute Nachricht: Checkmk kümmert sich darum! Wird ein gesuchtes Item
nicht gefunden, so erzeugt Checkmk *automatisch* für den Service das
Resultat `UNKNOWN - Item not found in monitoring data`. Das ist so
gewollt und gut so. Wenn ein gesuchtes Item nicht gefunden wird, so
können Sie Python einfach aus der Funktion herauslaufen und Checkmk
seine Arbeit erledigen lassen.
:::

::: paragraph
Checkmk weiß nur, dass das Item, das vorher da war, nun weg ist. Den
Grund dafür kennt Checkmk nicht --- Sie aber schon. Darum ist es
legitim, Ihr Wissen nicht für sich zu behalten und diesen Fall in der
Check-Funktion abzufangen und dabei eine hilfreiche Meldung ausgeben zu
lassen.
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, section):
    attr = section.get(item)
    if not attr:
        yield Result(state=State.CRIT, summary="Group is empty or has been deleted")
        return

    yield Result(state=State.OK, summary=f"{attr['num_hosts']} hosts in this group: {attr['members']}")
```
:::
:::::

::: paragraph
Was hat sich geändert? Der Fehlerfall wird jetzt zuerst abgehandelt.
Daher überprüfen Sie im `if`-Zweig, ob das Item *nicht* existiert,
setzen den Status auf [CRIT]{.state2} und verlassen mit `return` die
Funktion. In allen anderen Fällen geben Sie, wie zuvor, [OK]{.state0}
zurück.
:::

::: paragraph
Damit haben Sie in der Check-Funktion den Fall der verschwundenen
Host-Gruppen übernommen. Statt [UNKNOWN]{.state3} wird der zugehörige
Service nun [CRIT]{.state2} sein und die Information über die Ursache
des kritischen Zustands beinhalten.
:::

::: paragraph
Damit ist das neue Check-Plugin als Erweiterung des alten
fertiggestellt. Das erweiterte
[Agentenplugin](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/agent_plugin_advanced_myhostgroups){target="_blank"}
und die erweiterte Datei für die
[Check-Plugins](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/check_plugin_advanced_myhostgroups_step01.py){target="_blank"}
finden Sie wieder auf GitHub. Letztere enthält das einfache Check-Plugin
`myhostgroups` aus dem [vorherigen Kapitel](#write_check_plugin), die
erweiterte Parse-Funktion und die Komponenten des neuen Check-Plugins
`myhostgroups_advanced` mit der Erstellung des Check-Plugins, der
Discovery-Funktion und der Check-Funktion. Beachten Sie, dass die
Funktionen immer vor der Erstellung von Check-Plugins oder
Agentensektionen definiert werden müssen, damit es keine Fehler wegen
nicht definierter Funktionsnamen gibt.
:::

::: paragraph
Da das neue Check-Plugin `myhostgroups_advanced` neue Services zur
Verfügung stellt, müssen Sie eine Service-Erkennung für dieses
Check-Plugin durchführen und die Änderungen aktivieren, um die Services
im Monitoring zu sehen:
:::

::::: imageblock
::: content
![Die vom erweiterten Check-Plugin erzeugten zwei neuen Services im
Monitoring.](../images/devel_cpi_service_advanced_01.png)
:::

::: title
Zwei neue Services im Monitoring
:::
:::::

::: paragraph
Gehen Sie dabei so vor, wie es im Kapitel für das [einfache
Check-Plugin](#test) beschrieben ist. Führen Sie dabei die ersten beiden
Kommandos nicht für `myhostgroups` sondern für das neue Check-Plugin
`myhostgroups_advanced` aus.
:::
::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::: sect2
### []{#summary_details .hidden-anchor .sr-only}4.3. Summary und Details {#heading_summary_details}

::: paragraph
Im Monitoring von Checkmk hat jeder Service neben dem
Status --- [OK]{.state0}, [WARN]{.state1} usw. --- auch eine Zeile Text.
Diese steht in der Spalte [Summary]{.guihint} --- wie im vorherigen
Screenshot zu sehen ist --- und hat also die Aufgabe einer knappen
Zusammenfassung des Zustands. Die Idee ist, dass dieser Text eine Länge
von 60 Zeichen nicht überschreitet. Das sorgt dann immer für eine
übersichtliche Tabellendarstellung ohne störende Zeilenumbrüche.
:::

::: paragraph
Daneben gibt es noch das Feld [Details,]{.guihint} in dem alle Details
zum Zustand des Services angezeigt werden, wobei alle Informationen des
Summary auch in den Details enthalten sind. Nach Anklicken des Services
wird die Service-Seite geöffnet, in der neben vielen anderen auch die
beiden Felder [Summary]{.guihint} und [Details]{.guihint} zu sehen sind.
:::

::: paragraph
Beim Aufruf von `yield Result(...)` können Sie bestimmen, welche
Informationen so wichtig sind, dass sie im Summary angezeigt werden
sollen, und bei welchen es genügt, dass diese in den Details erscheinen.
:::

::: paragraph
In unserem Beispiel haben Sie bisher immer einen Aufruf der folgenden
Art verwendet:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield Result(state=State.OK, summary=f"{attr['num_hosts']} hosts in this group: {attr['members']}")
```
:::
:::::

::: paragraph
Dieser führt dazu, dass der als `summary` festgelegte Text immer im
[Summary]{.guihint} erscheint --- und zusätzlich auch in den
[Details]{.guihint}. Dies sollten Sie also nur für wichtige
Informationen verwenden. Enthält eine Host-Gruppe viele Hosts, kann die
Liste sehr lang werden --- länger als die empfohlenen 60 Zeichen. Ist
eine Information eher untergeordnet, so können Sie mit `details`
festlegen, dass der Text *nur* in den Details erscheint:
:::

::::: {#summary_details_yield .listingblock}
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield Result(
        state = State.OK,
        summary = f"{attr['num_hosts']} hosts in this group",
        details = f"{attr['num_hosts']} hosts in this group: {attr['members']}",
    )
```
:::
:::::

::: paragraph
Im obigen Beispiel wird die Liste der Hosts daher nur noch in den
[Details]{.guihint} angezeigt. Im [Summary]{.guihint} steht dann nur die
Anzahl der Hosts in der Gruppe:
:::

::::: imageblock
::: content
![\'Summary\' und \'Details\' in den
Service-Details.](../images/devel_cpi_service_summary_details.png)
:::

::: title
Unterschiedliche Inhalte für Summary und Details im Monitoring
:::
:::::

::: {#notice .paragraph}
Es gibt neben `summary` und `details` noch einen dritten Parameter. Mit
`notice` bestimmen Sie, dass ein Text für einen Service im Zustand
[OK]{.state0} *nur* in den Details angezeigt wird --- aber zusätzlich im
Summary für alle anderen Zustände. Somit wird dann aus dem Summary
sofort klar, warum der Service nicht [OK]{.state0} ist. Der Parameter
`notice` ist nicht besonders sinnvoll, wenn Texte fest an Zustände
gebunden sind, wie bisher in unserem Beispiel.
:::

::: paragraph
Zusammengefasst bedeutet das:
:::

::: ulist
- Der Gesamttext für das Summary sollte bei Services, die [OK]{.state0}
  sind, nicht länger als 60 Zeichen sein.

- Verwenden Sie immer entweder `summary` oder `notice` --- nicht beides
  und nicht keines davon.

- Fügen Sie bei Bedarf `details` hinzu, wenn der Text für die Details
  ein alternativer sein soll.
:::
:::::::::::::::::::::

:::::::::::::::::::::::::::::::: sect2
### []{#partial_results .hidden-anchor .sr-only}4.4. Mehrere Teilresultate pro Service {#heading_partial_results}

::: paragraph
Um die Anzahl der Services auf einem Host nicht ins Unermessliche
steigen zu lassen, sind in einem Service oft mehrere Teilresultate
zusammengefasst. So prüft zum Beispiel der Service [Memory]{.guihint}
unter Linux nicht nur RAM- und Swap-Nutzung, sondern auch geteilten
Speicher (*shared memory*), Page-Tabellen und alles Mögliche andere.
:::

::: paragraph
Die Check-API bietet dafür eine sehr komfortable Schnittstelle. So darf
eine Check-Funktion einfach beliebig oft ein Ergebnis mit `yield`
erzeugen. Der Gesamtstatus des Services richtet sich dann nach dem
schlechtesten Teilergebnis in der Reihenfolge [OK]{.state0} →
[WARN]{.state1} → [UNKNOWN]{.state3} → [CRIT]{.state2}.
:::

::: paragraph
Nutzen Sie diese Möglichkeit, um im Beispiel für jeden Service der
Host-Gruppen zu dem bestehenden Resultat zwei weitere zu definieren.
Diese werten den Prozentsatz der Hosts im Zustand [UP]{.hstate0} und der
Services im Zustand [OK]{.state0} aus. Dabei nutzen Sie die
[zuvor](#prepare) in der Agentenausgabe und der Parse-Funktion
festgelegten zusätzlichen Spalten der Host-Gruppentabelle.
:::

::: paragraph
Erweitern Sie die Check-Funktion nun sukzessive von oben nach unten:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, section):
    attr = section.get(item)
    if not attr:
        yield Result(state=State.CRIT, summary="Group is empty or has been deleted")
        return

    members = attr["members"]
    num_hosts = int(attr["num_hosts"])
    num_hosts_up = int(attr["num_hosts_up"])
    num_services = int(attr["num_services"])
    num_services_ok = int(attr["num_services_ok"])
```
:::
:::::

::: paragraph
Der `if`-Zweig bleibt unverändert, das heißt auch die neuen
Teilresultate gelten nur für Host-Gruppen, die auch existieren.
Anschließend definieren Sie fünf Variablen für die in der Sektion
enthaltenen Spalten der Host-Gruppentabelle. Dies erhöht zum einen im
folgenden die Lesbarkeit und nebenbei können Sie für die vier Spalten,
mit denen noch gerechnet werden soll, die ausgelesenen Strings mit
`int()` in Zahlen umwandeln.
:::

::: paragraph
Auch das bisher einzig existierende Resultat bleibt (fast) unverändert:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield Result(
        state = State.OK,
        summary = f"{num_hosts} hosts in this group",
        details = f"{num_hosts} hosts in this group: {members}",
    )
```
:::
:::::

::: paragraph
Nur der Zugriff im Python-„F-String" auf den Ausdruck, der den Wert
liefert, ist nun einfacher als [zuvor](#summary_details_yield), da das
`attr` bereits in den Variablendefinitionen steckt.
:::

::: paragraph
Nun zum eigentlichen Kern der Erweiterung, der Definition eines
Resultats, das die folgende Aussage umsetzt: „Der Service der
Host-Gruppe ist [WARN]{.state1}, wenn 90 % der Hosts [UP]{.hstate0}
sind, und [CRIT]{.state2} bei 80 % der Hosts." Dabei gilt die
Konvention, dass der Check bereits beim *Erreichen* der Schwelle --- und
nicht erst beim Überschreiten --- auf [WARN]{.state1} bzw.
[CRIT]{.state2} geht. Für den Vergleich eines ermittelten Werts mit
Schwellwerten stellt die Check-API die Hilfsfunktion `check_levels`
bereit.
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    hosts_up_perc = 100.0 * num_hosts_up / num_hosts
    yield from check_levels(
        hosts_up_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        label = "UP hosts",
        notice_only = True,
    )
```
:::
:::::

::: paragraph
In der ersten Zeile wird aus Gesamtzahl und Zahl der Hosts im Zustand
[UP]{.hstate0} der Prozentsatz berechnet und in der Variablen
`hosts_up_perc` gespeichert. Durch den einfachen Schrägstrich (`/`) wird
eine Gleitkommadivison ausgeführt, die sicherstellt, das das Ergebnis
ein Float-Wert ist. Das ist sinnvoll, weil einige im weiteren Verlauf
verwendete Funktionen Float als Eingabe erwarten.
:::

::: paragraph
In der zweiten Zeile wird dann das Ergebnis der Funktion `check_levels`
als Objekt vom Typ `Result` zurückgegeben, was in der API-Dokumentation
nachgelesen werden kann. Die Funktion wird gefüttert mit dem gerade
berechneten Prozentsatz als Wert (`hosts_up_perc`), den beiden unteren
Schwellwerten (`levels_lower`), einer Bezeichnung, die der Ausgabe
vorangestellt wird (`label`) und schließlich mit `notice_only=True`.
:::

::: paragraph
Der letzte Parameter nutzt den im [vorherigen Abschnitt](#notice) für
das Objekt `Result()` bereits vorgestellten Parameter `notice`. Mit
`notice_only = True` legen Sie fest, dass der Text für den Service nur
dann im [Summary]{.guihint} angezeigt wird, wenn der Zustand nicht
[OK]{.state0} ist. Allerdings werden Teilergebnisse, die zu einem
[WARN]{.state1} oder [CRIT]{.state2} führen, sowieso *immer* im Summary
sichtbar werden --- unabhängig davon, welchen Wert `notice_only` hat.
:::

::: paragraph
Schließlich definieren Sie analog zum zweiten das dritte Resultat, das
den Prozentsatz der Services im Zustand [OK]{.state0} auswertet:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    services_ok_perc = 100.0 * num_services_ok / num_services
    yield from check_levels(
        services_ok_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        label = "OK services",
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Damit ist die Check-Funktion komplett.
:::

::: paragraph
Der Service für eine Host-Gruppe wertet jetzt drei Resultate aus und
zeigt aus diesen den schlechtesten Zustand im Monitoring an, wie im
folgenden Beispiel:
:::

::::: imageblock
::: content
![Das Summary zeigt den Text zum kritischen
Zustand.](../images/devel_cpi_service_partial_results.png)
:::

::: title
Das Summary zeigt den Text zum kritischen Zustand
:::
:::::
::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::: sect2
### []{#metrics .hidden-anchor .sr-only}4.5. Metriken {#heading_metrics}

::: paragraph
Nicht immer, aber oft befassen sich Checks mit Zahlen. Und sehr oft
handelt es sich bei diesen Zahlen um gemessene oder berechnete Werte. In
unserem Beispiel sind die Zahl der Hosts in der Host-Gruppe
(`num_hosts`) und die Zahl der Hosts im Zustand [UP]{.hstate0}
(`num_hosts_up`) die Messwerte. Der Prozentsatz der Hosts im Zustand
[UP]{.hstate0} (`hosts_up_perc`) ist ein daraus berechneter Wert. Wenn
dann solch ein Wert im zeitlichen Verlauf dargestellt werden kann, wird
er auch als [Metrik](glossar.html#metric) bezeichnet.
:::

::: paragraph
Mit seinem [Graphing-System](graphing.html) hat Checkmk eine Komponente,
um solche Zahlen zu speichern, auszuwerten und darzustellen. Das geht
dabei völlig unabhängig von der Berechnung der Zustände [OK]{.state0},
[WARN]{.state1} und [CRIT]{.state2}.
:::

::: paragraph
Sie werden in diesem Beispiel die beiden berechneten Werte
`hosts_up_perc` und `services_ok_perc` als Metriken definieren. Metriken
werden in der grafischen Benutzeroberfläche von Checkmk sofort sichtbar,
ohne dass Sie etwas dafür tun müssen. Pro Metrik wird automatisch ein
Graph erzeugt.
:::

::: paragraph
Metriken werden von der Check-Funktion ermittelt und als zusätzliches
Ergebnis zurückgegeben. Am einfachsten ist es, der Funktion
`check_levels()` im Aufruf die Metrikinformationen mitzugeben.
:::

::: paragraph
Zur Erinnerung folgen die Zeilen mit dem Funktionsaufruf von
`check_levels()` aus dem [vorherigen Abschnitt:](#partial_results)
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield from check_levels(
        hosts_up_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        label = "UP hosts",
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Die beiden neuen Argumente für die Metrik sind `metric_name` und
`boundaries`:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield from check_levels(
        hosts_up_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        metric_name = "hosts_up_perc",
        label = "UP hosts",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Um es schön einfach und aussagekräftig zu halten, nehmen Sie als Namen
der Metrik den Namen der Variablen, in der der Prozentsatz als Wert
gespeichert ist.
:::

::: paragraph
Mit `boundaries` können Sie dem Graphing-System die Information über den
möglichen Wertebereich mitgeben. Damit ist der kleinste und größte
mögliche Wert gemeint. Bei einem Prozentsatz sind die Grenzen mit `0.0`
und `100.0` nicht allzu schwer zu bestimmen. Es sind sowohl
Gleitkommazahlen (*Float*) als auch Ganzzahlen (*Integer*, die intern
wiederum in Gleitkommazahlen umgewandelt werden) erlaubt, aber keine
Strings. Falls nur eine Grenze des Wertebereichs definiert ist, tragen
Sie für die andere einfach `None` ein, also zum Beispiel
`boundaries = (0.0, None)`.
:::

::: paragraph
Durch diese Erweiterung gibt die Funktion `check_levels` nun per `yield`
zusätzlich zum `Result` auch noch ein Objekt vom Typ `Metric` zurück.
:::

::: paragraph
Analog können Sie jetzt auch die Metrik `services_ok_perc` definieren.
Die letzten Zeilen der Check-Funktion sehen dann so aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    hosts_up_perc = 100.0 * num_hosts_up / num_hosts
    yield from check_levels(
        hosts_up_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        metric_name = "hosts_up_perc",
        label = "UP hosts",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
    services_ok_perc = 100.0 * num_services_ok / num_services
    yield from check_levels(
        services_ok_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        metric_name = "services_ok_perc",
        label = "OK services",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Mit der so erweiterten Check-Funktion sind die beiden Graphen im
Monitoring sichtbar. In der Service-Liste zeigt nun das Symbol [![Symbol
zur Anzeige der Graphen eines
Services.](../images/icons/icon_service_graph.png)]{.image-inline}, dass
es Graphen zum Service gibt. Wenn Sie mit der Maus auf das Symbol
zeigen, werden die Graphen als Vorschau eingeblendet.
:::

::::: imageblock
::: content
![Die Service-Liste mit 2 Graphen als
Vorschau.](../images/devel_cpi_service_graphs.png)
:::

::: title
Die Namen der Metriken werden als Titel der Graphen verwendet
:::
:::::

::: paragraph
Eine Übersicht aller Graphen inklusive Legende und mehr finden Sie in
den Service-Details.
:::

::: paragraph
Was macht man aber, wenn der Wert für die gewünschte Metrik gar nicht
mit der Funktion `check_levels()` definiert wurde? Sie können
selbstverständlich eine Metrik auch unabhängig von einem Funktionsaufruf
festlegen. Dazu dient das Objekt `Metric()`, welches Sie auch direkt
über seinen Konstruktor erzeugen können. Die alternative Definition
einer Metrik für den Wert `hosts_up_perc` sieht so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    yield Metric(
        name = "hosts_up_perc",
        value = hosts_up_perc,
        levels = (80.0, 90.0),
        boundaries = (0.0, 100.0),
    )
```
:::
::::

::: paragraph
Die Argumente von `Metric()` sind sehr ähnlich zu denen im oben
gezeigten Funktionsaufruf: Verpflichtend sind die ersten beiden
Argumente für den Metriknamen und den Wert. Zusätzlich gibt es noch zwei
optionale Argumente: `levels` für die Schwellwerte [WARN]{.state1} und
[CRIT]{.state2} und `boundaries` für den Wertebereich.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Angabe von `levels` dient     |
|                                   | hier lediglich als Information    |
|                                   | für die Darstellung des Graphen.  |
|                                   | Im Graphen werden die             |
|                                   | Schwellwerte üblicherweise als    |
|                                   | gelbe und rote Linien             |
|                                   | eingezeichnet. Für die            |
|                                   | *Überprüfung* ist die Funktion    |
|                                   | `check_levels` mit den dort       |
|                                   | festgelegten Schwellwerten        |
|                                   | verantwortlich.                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Nutzen Sie nun die Möglichkeit, nicht nur die beiden berechneten Werte,
sondern mit `Metric()` *alle* Messwerte als Metriken zu
definieren --- in unserem Beispiel also die vier Messwerte aus der
Host-Gruppentabelle. Beschränken Sie sich dabei auf die beiden
obligatorischen Angaben von Metrikname und Wert. Die vier neuen Zeilen
komplettieren die Erweiterung der Check-Funktion für Metriken:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    hosts_up_perc = 100.0 * num_hosts_up / num_hosts
    yield from check_levels(
        hosts_up_perc,
        levels_lower = (90.0, 80.0),
        metric_name = "hosts_up_perc",
        label = "UP hosts",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
    services_ok_perc = 100.0 * num_services_ok / num_services
    yield from check_levels(
        services_ok_perc,
        levels_lower = (90.0, 80.0),
        metric_name = "services_ok_perc",
        label = "OK services",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )

    yield Metric(name="num_hosts", value=num_hosts)
    yield Metric(name="num_hosts_up", value=num_hosts_up)
    yield Metric(name="num_services", value=num_services)
    yield Metric(name="num_services_ok", value=num_services_ok)
```
:::
:::::

::: paragraph
Das erhöht schon einmal die Zahl der Graphen pro Service, bietet Ihnen
aber zum Beispiel auch die Möglichkeit, mehrere Metriken in einem
Graphen zu kombinieren. Wir zeigen diese und andere Möglichkeiten im
Abschnitt [Darstellung von Metriken anpassen](#metrics_advanced) weiter
unten.
:::

::: paragraph
In der Beispieldatei auf
[GitHub](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/check_plugin_advanced_myhostgroups_step02.py){target="_blank"}
finden Sie wieder die gesamte Check-Funktion.
:::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#rule_set .hidden-anchor .sr-only}5. Regelsätze für Check-Parameter {#heading_rule_set}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im erweiterten Check-Plugin `myhostgroups_advanced` haben Sie den
Zustand [WARN]{.state1} erzeugt, wenn nur 90 % der Hosts [UP]{.hstate0}
sind, und [CRIT]{.state2} bei 80 %. Dabei sind die Zahlen `90` und `80`
in der Check-Funktion fest einprogrammiert oder, wie Programmierer sagen
würden, *hart codiert.* In Checkmk ist man allerdings als Benutzer
gewohnt, dass man solche Schwellwerte und andere Check-Parameter per
[Regel](glossar.html#rule) konfigurieren kann. Denn hat zum Beispiel
eine Host-Gruppe nur vier Mitglieder, dann passen die beiden
Schwellwerte von 90 und 80 % nicht wirklich gut, da bereits beim Ausfall
des ersten Hosts der Prozentsatz auf 75 % sinkt und der Zustand --- ohne
Umweg über [WARN]{.state1} --- direkt auf [CRIT]{.state2} geht.
:::

::: paragraph
Daher soll das Check-Plugin nun so verbessert werden, dass es über die
[Setup]{.guihint}-Oberfläche konfigurierbar ist. Dazu benötigen Sie
einen [Regelsatz.](glossar.html#rule_set)
:::

::: paragraph
Mit der Erstellung eines Regelsatzes *für* ein Check-Plugin verlassen
Sie die Check-Plugin-Entwicklung und wechseln Dateiverzeichnis, Datei
und API. Seit Checkmk [2.3.0]{.new} unterstützt Sie die **Rulesets-API**
bei der Erstellung solcher Regelsätze für Check-Plugins. Die
API-Dokumentation für Regelsätze finden Sie in Ihrer Checkmk-Instanz auf
der gleichen Seite wie die der [Check-API](#check_api_doc) unter
[Rulesets \> Version 1.]{.guihint}
:::

::::::::::::::::::::::::::: sect2
### []{#new_ruleset .hidden-anchor .sr-only}5.1. Neuen Regelsatz definieren {#heading_new_ruleset}

::: paragraph
Um einen neuen Regelsatz zu erstellen, legen Sie im Verzeichnis Ihrer
Plugin-Familie `~/local/lib/python3/cmk_addons/plugins/myhostgroups/`
zuerst ein neues Unterverzeichnis an. Der Name `rulesets` dieses
Unterverzeichnisses ist dabei vorgegeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir -p local/lib/python3/cmk_addons/plugins/myhostgroups/rulesets
OMD[mysite]:~$ cd local/lib/python3/cmk_addons/plugins/myhostgroups/rulesets
```
:::
::::

::: paragraph
In diesem Verzeichnis erstellen Sie dann eine Datei für die Definition
des Regelsatzes. Der Name der Datei sollte sich an dem des Check-Plugins
orientieren und muss wie alle Plugin-Dateien die Endung `.py` haben. Für
unser Beispiel passt der Dateiname `ruleset_myhostgroups.py`.
:::

::: paragraph
Sehen Sie sich den Aufbau dieser Datei Schritt für Schritt an. Zunächst
kommen einige Importbefehle:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/rulesets/ruleset_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python3

from cmk.rulesets.v1 import Label, Title
from cmk.rulesets.v1.form_specs import BooleanChoice, DefaultValue, DictElement, Dictionary, Float, LevelDirection, SimpleLevels
from cmk.rulesets.v1.rule_specs import CheckParameters, HostAndItemCondition, Topic
```
:::
:::::

::: paragraph
Zuerst werden die Klassen für die Texte importiert.
:::

::: paragraph
Die zweite Zeile trifft eine Auswahl aus den *Form Specs,* das heißt,
den Basiselementen für die GUI, die im Regelsatz genutzt werden, z. B.
für die binäre Auswahl (`BooleanChoice`), die Mehrfachauswahl
(`Dictionary`, `DictElement`), die Festlegung von Schwellwerten
(`SimpleLevel`, `LevelDirection`, `DefaultValue`) und die Eingabe von
Gleitkommazahlen (`Float`). Dabei fordern Sie hier lediglich die
logischen Formularelemente an und überlassen Checkmk die Gestaltung der
GUI.
:::

::: paragraph
Die letzte Zeile importiert die *Rule Specs,* die das Anwendungsgebiet
der Regel in Checkmk bestimmen, also hier die Festlegung von
Check-Parametern, die Zuordnung zu Hosts und Items und die Ablage unter
einem Thema (*topic*). Da Ihr Check-Plugin `myhostgroups_advanced`
mehrere Services erzeugt, importieren Sie hier `HostAndItemCondition`.
Falls Ihr Check keinen Service erzeugt, mit anderen Worten kein Item
hat, importieren Sie stattdessen `HostCondition`.
:::

::: paragraph
Nun kommen die eigentlichen Definitionen des Formulars für die Eingabe
der Check-Parameter. Der Benutzer soll die beiden Schwellwerte für
[WARN]{.state1} und [CRIT]{.state2} festlegen können und zwar getrennt
für die Anzahl der Hosts im Zustand [UP]{.hstate0} und der Services im
Zustand [OK]{.state0}:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/rulesets/ruleset_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def _parameter_form():
    return Dictionary(
        elements = {
            "hosts_up_lower": DictElement(
                parameter_form = SimpleLevels(
                    title = Title("Lower percentage threshold for host in UP status"),
                    form_spec_template = Float(),
                    level_direction = LevelDirection.LOWER,
                    prefill_fixed_levels = DefaultValue(value=(90.0, 80.0)),
                ),
                required = True,
            ),
            "services_ok_lower": DictElement(
                parameter_form = SimpleLevels(
                    title = Title("Lower percentage threshold for services in OK status"),
                    form_spec_template = Float(),
                    level_direction = LevelDirection.LOWER,
                    prefill_fixed_levels = DefaultValue(value=(90.0, 80.0)),
                ),
                required = True,
            ),
        }
    )
```
:::
:::::

::: paragraph
Hierfür legen Sie eine Funktion an, welche das Dictionary erzeugt. Den
Namen der Funktion können Sie frei wählen, er wird nur bei der
Erstellung der Regel weiter unten benötigt. Damit die Funktion nicht
über die Modulgrenze hinaus sichtbar wird, sollte der Name mit einem
Unterstrich beginnen.
:::

::: paragraph
Das `return Dictionary()` ist vorgeschrieben. Innerhalb dessen erstellen
Sie mit `elements={}` die Elemente des Dictionaries, im Beispiel
`hosts_up_lower` und `services_ok_lower`. Das Parameterformular
`SimpleLevels` dient der Eingabe von festen Schwellwerten. Im Formular
bestimmen Sie zuerst den Titel (`title`) und Gleitkommazahlen für die
einzugebenden Werte (`form_spec_template`). Dass sich der Zustand bei
*Unterschreitung* der Werte ändert, legen Sie mit `LevelDirection.LOWER`
fest.
:::

::: paragraph
Schließlich können Sie mit `prefill_fixed_levels` den Benutzern des
Regelsatzes statt leerer Eingabefelder bereits Werte vorgeben. Beachten
Sie, dass diese in der GUI angezeigten Werte *nicht* die Standardwerte
sind, die weiter unten bei der [Erstellung des
Check-Plugins](#ruleset_defaults) per `check_default_parameters` gesetzt
werden. Wollen Sie die gleichen Standardwerte in der GUI anzeigen
lassen, die auch für die Check-Funktion gelten, dann müssen Sie die
Werte an beiden Stellen selbst konsistent halten.
:::

::: paragraph
Zu guter Letzt erstellen Sie jetzt mithilfe der importierten und selbst
definierten Dinge den neuen Regelsatz. Dies geschieht durch die
Erstellung einer Instanz der Klasse `CheckParameters`. Der Name dieser
Instanz muss dabei mit `rule_spec_` beginnen:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/rulesets/ruleset_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
rule_spec_myhostgroups = CheckParameters(
    name = "myhostgroups_advanced",
    title = Title("Host group status"),
    topic = Topic.GENERAL,
    parameter_form = _parameter_form,
    condition = HostAndItemCondition(item_title=Title("Host group name")),
)
```
:::
:::::

::: paragraph
Dazu die folgenden Erklärungen:
:::

::: ulist
- Der Name des Regelsatzes `name` stellt die Verbindung zu den
  Check-Plugins her. Ein Check-Plugin, das diesen Regelsatz verwenden
  will, muss beim Erstellen diesen Namen als `check_ruleset_name`
  verwenden. Um bei mehreren neuen Regelsätzen den Überblick zu
  behalten, empfiehlt es sich im Namen einen Präfix zu verwenden.

- `title` legt den Titel des Regelsatzes fest, so wie er auch in der
  Checkmk-GUI erscheint.

- Das `topic` legt fest, wo im [Setup]{.guihint} der Regelsatz
  auftauchen soll. Mit dem im Beispiel gewählten Wert finden Sie den
  Regelsatz unter [Setup \> Services \> Service monitoring
  rules]{.guihint} im Kasten [Various,]{.guihint} wo er in aller Regel
  gut aufgehoben ist.

- Als `parameter_form` geben Sie den Namen der zuvor erstellten Funktion
  ein.

- Falls Ihr Check kein Item verwendet, lautet die Bedingung
  `HostCondition` und nicht `HostAndItemCondition`, wie im obigen
  Beispiel. Mit dem Titel `"Host group name"` des Items legen Sie das
  Label in der GUI fest, mit dem Sie die Regel auf bestimmte
  Host-Gruppen einschränken können.
:::
:::::::::::::::::::::::::::

:::::::::::::: sect2
### []{#test_ruleset .hidden-anchor .sr-only}5.2. Regelsatz testen {#heading_test_ruleset}

::: paragraph
Wenn Sie die Datei für den Regelsatz angelegt haben, sollten Sie
ausprobieren, ob alles soweit funktioniert --- noch ohne Verbindung zum
Check-Plugin. Dazu müssen Sie zuerst den Apache der Instanz neu starten,
damit die neue Datei gelesen wird. Das macht der Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd restart apache
```
:::
::::

::: paragraph
Danach sollte der Regelsatz im [Setup]{.guihint} auf der oben genannten
Seite zu finden sein. Mit der Suchfunktion im Setup-Menü finden Sie den
Regelsatz auch --- aber erst nach einem Neustart von Redis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd restart redis
```
:::
::::

::: paragraph
Der soeben definierte Regelsatz sieht in der GUI so aus:
:::

:::: imageblock
::: content
![Der neu erstellte Regelsatz im
Setup.](../images/devel_cpi_ruleset.png)
:::
::::

::: paragraph
In Kasten [Conditions]{.guihint} finden Sie das per
`HostAndItemCondition` definierte Eingabefeld [Host group
name]{.guihint} wieder zur Einschränkung der Regel für Host-Gruppen.
:::

::: paragraph
Legen Sie eine Regel an und probieren Sie verschiedene Werte aus, wie im
obigen Screenshot gezeigt. Wenn das ohne Fehler geht, können Sie die
Check-Parameter jetzt in der Check-Funktion verwenden.
:::
::::::::::::::

:::::::::::::::::::::::::::::::::::: sect2
### []{#use_ruleset .hidden-anchor .sr-only}5.3. Regelsatz mit Check-Plugin verbinden {#heading_use_ruleset}

::: paragraph
Der frisch erstellte Regelsatz wird nun mit dem im [vorherigen
Kapitel](#extend) vorläufig fertiggestellten Check-Plugin verbunden.
Damit die Regel zum Greifen kommt, müssen Sie dem Check-Plugin erlauben,
Check-Parameter entgegenzunehmen und ihm sagen, welche Regel benutzt
werden soll. Dazu fügen Sie in der Datei des Check-Plugins zwei neue
Zeilen bei der Erstellung des Check-Plugins `myhostgroups_advanced` ein:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
check_plugin_myhostgroups_advanced = CheckPlugin(
    name = "myhostgroups_advanced",
    sections = [ "myhostgroups" ],
    service_name = "Host group %s",
    discovery_function = discover_myhostgroups_advanced,
    check_function = check_myhostgroups_advanced,
    check_default_parameters = {},
    check_ruleset_name = "myhostgroups_advanced",
)
```
:::
:::::

::: paragraph
Mit dem Eintrag `check_default_parameters` können Sie die Standardwerte
setzen, die gelten, solange noch keine Regel angelegt ist. Bei der
Umstellung des Check-Plugins für Check-Parameter muss diese Zeile
unbedingt vorhanden sein. Im einfachsten Fall übergeben Sie ein leeres
Dictionary `{}`.
:::

::: paragraph
Als zweites tragen Sie noch `check_ruleset_name` ein, also den Namen des
Regelsatzes. So weiß Checkmk aus welchem Regelsatz die Parameter
bestimmt werden sollen.
:::

::: paragraph
Nun wird Checkmk versuchen, der Check-Funktion Parameter zu übergeben.
Damit das klappen kann, müssen Sie die Check-Funktion so erweitern, dass
sie das Argument `params` erwartet, welches sich zwischen `item` und
`section` schiebt:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, params, section):
```
:::
:::::

::: paragraph
Falls Sie einen Check ohne Item bauen, entfällt das `item` und `params`
steht am Anfang.
:::

::: paragraph
Es ist sehr empfehlenswert, sich jetzt als ersten Test den Inhalt der
Variable `params` mit einem `print` ausgeben zu lassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, params, section):
    print(params)
```
:::
::::

::: paragraph
Bei der Ausführung des Check-Plugins sehen die ausgedruckten Zeilen (für
jeden Service eine) mit den per Regel festgelegten Werten dann etwa so
aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --detect-plugins=myhostgroups_advanced -v localhost
Parameters({'hosts_up_lower': ('fixed', (75.0, 60.0)), 'services_ok_lower': ('fixed', (75.0, 60.0))})
Parameters({'hosts_up_lower': ('fixed', (75.0, 60.0)), 'services_ok_lower': ('fixed', (75.0, 60.0))})
Parameters({'hosts_up_lower': ('fixed', (75.0, 60.0)), 'services_ok_lower': ('fixed', (75.0, 60.0))})
```
:::
::::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Wenn alles fertig ist und         |
|                                   | funktioniert, entfernen Sie die   |
|                                   | `print`-Aufrufe wieder. Diese     |
|                                   | können die interne Kommunikation  |
|                                   | von Checkmk durcheinanderbringen. |
|                                   | Alternativ können Sie die Ausgabe |
|                                   | von Debug-Informationen auf deren |
|                                   | [explizite                        |
|                                   | Anforderung](#custom_debug)       |
|                                   | beschränken.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Nun passen Sie Ihre Check-Funktion weiter an, so dass die übergebenen
Parameter ihre Wirkung entfalten können. Holen Sie sich die beiden in
der Regel festgelegten Dictionary-Elemente mit dem dort gewählten Namen
aus den Parametern:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
def check_myhostgroups_advanced(item, params, section):
    hosts_up_lower = params["hosts_up_lower"]
    services_ok_lower = params["services_ok_lower"]
```
:::
:::::

::: paragraph
Weiter unten in der Check-Funktion werden dann die bisher hart kodierten
Schwellwerte `"fixed", (90.0, 80.0)` durch die Variablen
`hosts_up_lower` und `services_ok_lower` ersetzt:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    hosts_up_perc = 100.0 * num_hosts_up / num_hosts
    yield from check_levels(
        hosts_up_perc,
        levels_lower = (hosts_up_lower),
        metric_name = "hosts_up_perc",
        label = "UP hosts",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
    services_ok_perc = 100.0 * num_services_ok / num_services
    yield from check_levels(
        services_ok_perc,
        levels_lower = (services_ok_lower),
        metric_name = "services_ok_perc",
        label = "OK services",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Falls eine Regel konfiguriert ist, können Sie nun die Host-Gruppen des
Beispiels mit den über die GUI gesetzten Schwellwerten überwachen. Wenn
allerdings keine Regel definiert ist, wird diese Check-Funktion
abstürzen: Da die Default-Parameter des Check-Plugins nicht befüllt
sind, wird das Plugin bei Abwesenheit einer Regel einen `KeyError`
erzeugen.
:::

::: {#ruleset_defaults .paragraph}
Dieses Problem kann aber behoben werden, wenn bei der Erstellung des
Check-Plugins die Standardwerte gesetzt sind:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
check_plugin_myhostgroups_advanced = CheckPlugin(
    name = "myhostgroups_advanced",
    sections = [ "myhostgroups" ],
    service_name = "Host group %s",
    discovery_function = discover_myhostgroups_advanced,
    check_function = check_myhostgroups_advanced,
    check_default_parameters = {"hosts_up_lower": ("fixed", (90, 80)), "services_ok_lower": ("fixed", (90, 80))},
    check_ruleset_name = "myhostgroups_advanced",
)
```
:::
:::::

::: paragraph
Sie sollten Standardwerte immer auf diese Weise übergeben (und den Fall
fehlender Parameter nicht im Check-Plugin abfangen), da diese
Standardwerte auch in der [Setup]{.guihint}-Oberfläche angezeigt werden
können. Dazu gibt es zum Beispiel bei der Service-Erkennung eines Hosts,
auf der Seite [Services of host]{.guihint}, im Menü [Display]{.guihint}
den Schalter [Show check parameters.]{.guihint}
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Auf GitHub finden Sie sowohl die  |
|                                   | Datei mit dem                     |
|                                   | [R                                |
|                                   | egelsatz](https://github.com/Chec |
|                                   | kmk/checkmk-docs/blob/master/exam |
|                                   | ples/devel_check_plugins/ruleset_ |
|                                   | myhostgroups.py){target="_blank"} |
|                                   | als auch das um den Regelsatz     |
|                                   | erweiterte                        |
|                                   | [Check-Plugin.](http              |
|                                   | s://github.com/Checkmk/checkmk-do |
|                                   | cs/blob/master/examples/devel_che |
|                                   | ck_plugins/check_plugin_advanced_ |
|                                   | myhostgroups.py){target="_blank"} |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#metrics_advanced .hidden-anchor .sr-only}6. Darstellung von Metriken anpassen {#heading_metrics_advanced}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im [obigen Beispiel](#metrics) haben Sie das Check-Plugin
`myhostgroups_advanced` [Metriken](glossar.html#metric) für alle
gemessenen und berechneten Werte erzeugen lassen. Dazu haben wir zwei
Wege vorgestellt. Zuerst wurden die Metriken der berechneten Werte als
Bestandteil der Funktion `check_levels()` mit dem Argument `metric_name`
erstellt, zum Beispiel so:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield from check_levels(
        services_ok_perc,
        levels_lower = ("fixed", (90.0, 80.0)),
        metric_name = "services_ok_perc",
        label = "OK services",
        boundaries = (0.0, 100.0),
        notice_only = True,
    )
```
:::
:::::

::: paragraph
Dann haben Sie die gemessenen Metriken direkt mit dem Objekt `Metric()`
erzeugt --- für die Anzahl der Services im Zustand [OK]{.state0} zum
Beispiel so:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py
:::

::: content
``` {.pygments .highlight}
    yield Metric(name="num_services_ok", value=num_services_ok)
```
:::
:::::

::: paragraph
Metriken werden in der grafischen Benutzeroberfläche von Checkmk zwar
sofort sichtbar, ohne dass Sie etwas dafür tun müssen. Allerdings gibt
es dabei ein paar Einschränkungen:
:::

::: ulist
- Es werden nicht automatisch passende Metriken in einem Graphen
  kombiniert, sondern jede erscheint einzeln.

- Die Metrik hat keinen richtigen Titel, sondern es wird der interne
  Variablenname der Metrik gezeigt.

- Es wird keine Einheit verwendet, die eine sinnvolle Darstellung
  erlaubt (zum Beispiel GB anstelle von einzelnen Bytes).

- Es wird zufällig eine Farbe ausgewählt.

- Es erscheint nicht automatisch ein „Perf-O-Meter", also die grafische
  Vorschau der Metrik als Balken in der Service-Liste (zum Beispiel in
  der Ansicht, die alle Services eines Hosts darstellt).
:::

::: paragraph
Um die Darstellung Ihrer Metriken in diesen Belangen zu
vervollständigen, benötigen Sie *Metrikdefinitionen.*
:::

::: paragraph
So, wie für [Regelsätze](#rule_set) gibt es seit Checkmk [2.3.0]{.new}
mit der **Graphing-API** auch eine eigene API für Metriken, Graphen und
Perf-O-Meter. Die Dokumentation der Graphing-API finden Sie in Ihrer
Checkmk-Instanz auf der gleichen Seite wie die der
[Check-API](#check_api_doc) unter [Graphing \> Version 1.]{.guihint}
:::

:::::::::::::::::::::::: sect2
### []{#new_metricdefinition .hidden-anchor .sr-only}6.1. Neue Metrikdefinition erstellen {#heading_new_metricdefinition}

::: paragraph
Das Vorgehen bei der Erstellung von [Regelsätzen](#new_ruleset) und
Metrikdefinitionen ist sehr ähnlich. Legen Sie im Verzeichnis Ihrer
Plugin-Familie `~/local/lib/python3/cmk_addons/plugins/myhostgroups/`
zuerst ein neues Unterverzeichnis mit dem vorgegeben Namen `graphing`
an.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir -p local/lib/python3/cmk_addons/plugins/myhostgroups/graphing
OMD[mysite]:~$ cd local/lib/python3/cmk_addons/plugins/myhostgroups/graphing
```
:::
::::

::: paragraph
In diesem Verzeichnis erstellen Sie dann eine Graphing-Datei, z. B.
`graphing_myhostgroups.py`.
:::

::: paragraph
Zunächst kommen wieder einige Importbefehle:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/graphing/graphing_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python3
from cmk.graphing.v1 import Title
from cmk.graphing.v1.graphs import Graph, MinimalRange
from cmk.graphing.v1.metrics import Color, DecimalNotation, Metric, Unit
from cmk.graphing.v1.perfometers import Closed, FocusRange, Open, Perfometer
```
:::
:::::

::: paragraph
Für unser Beispiel definieren Sie nun eine eigene Metrik für den
Prozentsatz der Services im Zustand [OK]{.state0}. Dies geschieht durch
die Erstellung einer Instanz der Klasse `Metric`. Der Name dieser
Instanz muss dabei mit `metric_` beginnen
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/graphing/graphing_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
metric_myhostgroups_services_ok_perc = Metric(
    name = "services_ok_perc",
    title = Title("Percentage of services in OK state"),
    unit = Unit(DecimalNotation("%")),
    color = Color.ORANGE,
)
```
:::
:::::

::: paragraph
Hier die Erklärung dazu:
:::

::: ulist
- Der Metrikname (hier `services_ok_perc`) muss dem entsprechen, was die
  Check-Funktion ausgibt.

- Der `title` ist die Überschrift im Metrikgraphen und ersetzt den
  bisher verwendeten internen Variablennamen.

- Die verfügbaren Einheiten (`unit`) können Sie in der API-Dokumentation
  nachlesen, sie enden alle auf `Notation`, z. B. `DecimalNotation`,
  `EngineeringScientificNotation` oder `TimeNotation`.

- Die in Checkmk verwendeten Farbnamen für die Farbdefinition `color`
  finden Sie auf
  [GitHub.](https://github.com/Checkmk/checkmk/blob/master/packages/cmk-graphing/cmk/graphing/v1/metrics.py){target="_blank"}
:::

::: paragraph
Diese Definition in der Graphing-Datei sorgt jetzt dafür, dass Titel,
Einheit und Farbe der Metrik angepasst dargestellt werden.
:::

::: paragraph
Analog zur Erstellung einer [Regelsatzdatei](#test_ruleset) muss die
Graphing-Datei erst gelesen werden, bevor die Änderung in der GUI
sichtbar ist. Das macht der Neustart des Apache der Instanz:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd restart apache
```
:::
::::

::: paragraph
Der Metrikgraph sieht dann in der Checkmk-GUI ungefähr so aus:
:::

:::: imageblock
::: content
![Die neue Metrikdefinition in den
Service-Details.](../images/devel_cpi_new_metric.png)
:::
::::
::::::::::::::::::::::::

:::::::::::::::: sect2
### []{#graph_multiple_metrics .hidden-anchor .sr-only}6.2. Graph mit mehreren Metriken {#heading_graph_multiple_metrics}

::: paragraph
Möchten Sie mehrere Metriken in einem Graphen kombinieren (was oft sehr
sinnvoll ist), benötigen Sie eine Graphdefinition, die Sie der im
vorherigen Abschnitt erstellten Graphing-Datei hinzufügen können.
:::

::: paragraph
Für unser Beispiel sollen die beiden Metriken `num_services` und
`num_services_ok` in einem Graphen dargestellt werden. Die
Metrikdefinitionen dazu werden analog wie im vorherigen Abschnitt für
`services_ok_perc` erstellt und sehen wie folgt aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/graphing/graphing_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
metric_myhostgroups_services = Metric(
    name = "num_services",
    title = Title("Number of services in group"),
    unit = Unit(DecimalNotation("")),
    color = Color.PINK,
)

metric_myhostgroups_services_ok = Metric(
    name = "num_services_ok",
    title = Title("Number of services in OK state"),
    unit = Unit(DecimalNotation("")),
    color = Color.BLUE,
)
```
:::
:::::

::: paragraph
Fügen Sie nun einen Graphen an, der diese beiden Metriken als Linien
einzeichnet. Dies geschieht über eine Instanz der Klasse `Graph`, wobei
der Instanzname auch hier wieder mit einem vorgegebenen Präfix
(`graph_`) beginnen muss:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/graphing/graphing_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
graph_myhostgroups_combined = Graph(
    name = "services_ok_comparison",
    title = Title("Services in OK state out of total"),
    simple_lines=[ "num_services", "num_services_ok" ],
    minimal_range=MinimalRange(0, 50),
)
```
:::
:::::

::: paragraph
Der Parameter `minimal_range` beschreibt, was die vertikale Achse des
Graphen mindestens abdeckt, unabhängig von den Werten der Metrik. Die
vertikale Achse wird erweitert, wenn die Werte den minimalen Bereich
überschreiten, aber sie wird nie kleiner sein.
:::

::: paragraph
Das Resultat ist der kombinierte Graph in der Checkmk-GUI:
:::

:::: imageblock
::: content
![Der Graph zeigt beide Metriken in den
Service-Details.](../images/devel_cpi_graph_two_metrics.png)
:::
::::
::::::::::::::::

::::::::::::::: sect2
### []{#perfometer .hidden-anchor .sr-only}6.3. Metriken im Perf-O-Meter {#heading_perfometer}

::: paragraph
Möchten Sie zu einer Metrik noch ein Perf-O-Meter in der Zeile der
Service-Liste anzeigen? Das könnte zum Beispiel so aussehen:
:::

::::: imageblock
::: content
![Das Perf-O-Meter zeigt den Prozentsatz der Services im Status
\'OK\'.](../images/devel_cpi_perfometer_percentage.png)
:::

::: title
Das Perf-O-Meter zeigt den Prozentsatz der Services im Status
[OK]{.state0}
:::
:::::

::: paragraph
Um so ein Perf-O-Meter zu erstellen, benötigen Sie eine weitere Instanz,
diesmal der Klasse `Perfometer`, deren Name mit dem Präfix `perfometer_`
beginnt:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/myhostgroups/graphing/graphing_myhostgroups.py
:::

::: content
``` {.pygments .highlight}
perfometer_myhostgroups_advanced = Perfometer(
    name = "myhostgroups_advanced",
    focus_range = FocusRange(Closed(0), Closed(100)),
    segments = [ "services_ok_perc" ],
)
```
:::
:::::

::: paragraph
Perf-O-Meter sind etwas trickreicher als Graphen, da es keine Legende
gibt. Daher ist die Darstellung des Wertebereichs schwierig,
insbesondere, wenn es um die Darstellung absoluter Werte geht. Einfacher
ist es, einen Prozentsatz darzustellen. Dies ist auch im obigen Beispiel
der Fall:
:::

::: ulist
- In `segments` werden die Metriknamen eingetragen, hier der Prozentsatz
  der Services im Zustand [OK]{.state0}.

- In `focus_range` wird die untere und obere Grenze eingetragen.
  Geschlossene (`Closed`) Grenzen sind vorgesehen für Metriken, die nur
  Werte zwischen den angegebenen Grenzen annehmen können (hier also `0`
  und `100`).
:::

::: paragraph
Weitere, noch ausgefeiltere Möglichkeiten zur Umsetzung von Metriken in
Perf-O-Metern finden Sie in der Dokumentation der Graphing-API, z. B.
mit den Klassen `Bidirectional` und `Stacked`, die es erlauben mehrere
Perf-O-Meter in einem darzustellen.
:::

::: paragraph
Die Graphing-Datei dieses Kapitels finden Sie wieder auf
[GitHub](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins/graphing_myhostgroups.py){target="_blank"}.
Sie enthält unter anderem die Metrikdefinitionen der vier gemessenen und
der zwei berechneten Werte.
:::
:::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#format_numbers .hidden-anchor .sr-only}7. Zahlen formatieren {#heading_format_numbers}

::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im [Summary]{.guihint} und den [Details]{.guihint} eines Services werden
oft Zahlen ausgegeben. Um Ihnen eine schöne und korrekte Formatierung
möglichst einfach zu machen, und auch um die Ausgaben von allen
Check-Plugins zu vereinheitlichen, gibt es Hilfsfunktionen für die
Darstellung von verschiedenen Arten von Größen. All diese sind
Unterfunktionen vom Modul `render` und werden folglich mit `render.`
aufgerufen. Zum Beispiel ergibt `render.bytes(2000)` den Text
`1.95 KiB`.
:::

::: paragraph
All diesen Funktionen ist gemein, dass Sie ihren Wert in einer
sogenannten *kanonischen* oder natürlichen Einheit bekommen. So muss man
nie nachdenken und es gibt keine Schwierigkeiten oder Fehler bei der
Umrechnung. Beispielsweise werden Zeiten immer in Sekunden angegeben und
Größen von Festplatten, Dateien etc. immer in Bytes und nicht in
Kilobytes, Kibibytes, Blöcken oder sonstigem Durcheinander.
:::

::: paragraph
Verwenden Sie diese Funktionen auch dann, wenn Ihnen die Darstellung
nicht so gut gefällt. Immerhin ist diese dann für den Benutzer
einheitlich. Und zukünftige Versionen von Checkmk können die Darstellung
möglicherweise ändern oder sogar konfigurierbar für den Benutzer machen,
wie es zum Beispiel bereits bei der Anzeige der Temperatur der Fall ist.
Davon wird dann Ihr Check-Plugin auch profitieren.
:::

::: paragraph
Bevor Sie die `render`-Funktion in Ihrem Check-Plugin nutzen können,
müssen Sie sie zusätzlich importieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
from cmk.agent_based.v2 import render
```
:::
::::

::: paragraph
Nach der ausführlichen Beschreibung aller Darstellungsfunktionen
(Render-Funktionen) finden Sie eine [Zusammenfassung](#numbers_summary)
in Form einer übersichtlichen Tabelle.
:::

::::::::: sect2
### []{#time .hidden-anchor .sr-only}7.1. Zeiten, Zeiträume, Frequenzen {#heading_time}

::: paragraph
Absolute Zeitangaben (Zeitstempel) werden mit `render.date()` oder
`render.datetime()` formatiert. Die Angaben erfolgen immer als
*Unix-Zeit,* also in Sekunden ab dem 1. Januar 1970, 00:00:00
UTC --- dem Beginn der *Unix-Epoche.* Dies ist auch das Format, mit dem
die Python-Funktion `time.time()` arbeitet.
:::

::: paragraph
Vorteil an dieser Darstellung ist, dass sich damit sehr einfach rechnen
lässt, also zum Beispiel die Berechnung des Zeitraums, wenn Start- und
Endzeit bekannt sind. Die Formel ist dann einfach
`duration = end - start`. Und diese Berechnungen funktionieren
unabhängig von der Zeitzone, Sommerzeitumstellungen oder Schaltjahren.
:::

::: paragraph
`render.date()` gibt nur das Datum aus, `render.datetime()` fügt noch
die Uhrzeit hinzu. Die Ausgabe erfolgt dabei gemäß der aktuellen
Zeitzone desjenigen Checkmk-Servers, welcher den Check ausführt.
Beispiele:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.date(0)`                  | `1970-01-01`                      |
+-----------------------------------+-----------------------------------+
| `render.datetime(0)`              | `1970-01-01 01:00:00`             |
+-----------------------------------+-----------------------------------+
| `render.date(1700000000)`         | `2023-11-14`                      |
+-----------------------------------+-----------------------------------+
| `render.datetime(1700000000)`     | `2023-11-14 23:13:20`             |
+-----------------------------------+-----------------------------------+

::: paragraph
Wundern Sie sich jetzt nicht, dass `render.datetime(0)` als Uhrzeit
nicht `00:00`, sondern `01:00` ausgibt. Das liegt daran, dass wir dieses
Handbuch in der Zeitzone von Deutschland schreiben --- und die ist der
Standardzeit UTC eine Stunde voraus (zumindest während der Normalzeit,
denn der 1. Januar liegt ja bekanntlich nicht in der Sommerzeit).
:::

::: paragraph
Für Zeiträume (oder *Zeitspannen*) gibt es noch die Funktion
`render.timespan()`. Diese bekommt eine Dauer in Sekunden und gibt das
menschenlesbar aus. Bei größeren Zeitspannen werden Sekunden oder
Minuten weggelassen. Wenn Sie eine Zeitspanne in einem
`TimeDelta`-Objekt vorliegen haben, lesen Sie aus diesem mit der
Funktion `total_seconds()` die Zahl der Sekunden als Fließkommazahl aus.
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.timespan(1)`              | `1 second`                        |
+-----------------------------------+-----------------------------------+
| `render.timespan(123)`            | `2 minutes 3 seconds`             |
+-----------------------------------+-----------------------------------+
| `render.timespan(12345)`          | `3 hours 25 minutes`              |
+-----------------------------------+-----------------------------------+
| `render.timespan(1234567)`        | `14 days 6 hours`                 |
+-----------------------------------+-----------------------------------+

::: paragraph
Eine *Frequenz* ist quasi der Kehrwert der Zeit. Die kanonische Einheit
ist *Hz*, was das gleiche bedeutet wie 1 / sec. Einsatzgebiet ist zum
Beispiel die Taktrate einer CPU:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.frequency(111222333444)`  | `111 GHz`                         |
+-----------------------------------+-----------------------------------+
:::::::::

::::::::: sect2
### []{#byte .hidden-anchor .sr-only}7.2. Bytes {#heading_byte}

::: paragraph
Überall wo es um Arbeitsspeicher, Dateien, Festplatten, Dateisysteme und
dergleichen geht, ist die kanonische Einheit das *Byte.* Da Computer so
etwas meist in Zweierpotenzen organisieren, also zum Beispiel in
Einheiten zu 512, 1024 oder 65 536 Bytes, hatte sich dabei von Beginn an
eingebürgert, dass ein *Kilobyte* nicht 1000, und damit das Tausendfache
der Einheit ist, sondern 1024 (2 hoch 10) Bytes. Das ist zwar unlogisch,
aber sehr praktisch, weil so meist runde Zahlen herauskommen. Der
legendäre Commodore C64 hatte eben 64 Kilobytes Speicher und nicht
65,536.
:::

::: paragraph
Leider kamen irgendwann Festplattenhersteller auf die Idee, die Größen
ihrer Platten in 1000er-Einheiten anzugeben. Da bei jeder Größenordnung
der Unterschied zwischen 1000 und 1024 immerhin 2,4 % ausmacht, und
diese sich aufmultiplizieren, wird so aus einer Platte der Größe 1 GB
(1024 mal 1024 mal 1024) auf einmal 1,07 GB. Das verkauft sich besser.
:::

::: paragraph
Diese lästige Verwirrung besteht bis heute und sorgt immer wieder für
Fehler. Als Linderung wurden von der internationalen elektrotechnischen
Kommission (IEC) neue Präfixe auf Grundlage des Binärsystems festgelegt.
Demnach ist heute offiziell ein Kilobyte 1000 Bytes und ein *Kibibyte*
1024 Bytes (2 hoch 10). Außerdem soll man *Mebibyte,* *Gibibyte* und
*Tebibyte* sagen. Die Abkürzungen lauten dann KiB, MiB, GiB und TiB.
:::

::: paragraph
Checkmk passt sich an diesen Standard an und hilft Ihnen mit mehreren
angepassten Render-Funktionen dabei, dass Sie immer korrekte Ausgaben
machen. So gibt es speziell für Festplatten und Dateisysteme die
Funktion `render.disksize()`, welche die Ausgabe in 1000er-Potenzen
macht.
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.disksize(1000)`           | `1.00 kB`                         |
+-----------------------------------+-----------------------------------+
| `render.disksize(1024)`           | `1.02 kB`                         |
+-----------------------------------+-----------------------------------+
| `render.disksize(2000000)`        | `2.00 MB`                         |
+-----------------------------------+-----------------------------------+

::: paragraph
Bei der Größe von Dateien ist es oft üblich, die genaue Größe in Bytes
*ohne Rundung* anzugeben. Dies hat den Vorteil, dass man so sehr schnell
sehen kann, wenn sich eine Datei auch nur minimal geändert hat oder dass
zwei Dateien (wahrscheinlich) gleich sind. Hierfür ist die Funktion
`render.filesize()` verantwortlich:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.filesize(1000)`           | `1,000 B`                         |
+-----------------------------------+-----------------------------------+
| `render.filesize(1024)`           | `1,024 B`                         |
+-----------------------------------+-----------------------------------+
| `render.filesize(2000000)`        | `2,000,000 B`                     |
+-----------------------------------+-----------------------------------+

::: paragraph
Wenn Sie eine Größe ausgeben möchten, die keine Festplatten- oder
Dateigröße ist, dann verwenden Sie einfach das generische
`render.bytes()`. Hier bekommen Sie die Ausgabe in klassischen
1024er-Potenzen in der offiziellen Schreibweise:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.bytes(1000)`              | `1000 B`                          |
+-----------------------------------+-----------------------------------+
| `render.bytes(1024)`              | `1.00 KiB`                        |
+-----------------------------------+-----------------------------------+
| `render.bytes(2000000)`           | `1.91 MiB`                        |
+-----------------------------------+-----------------------------------+
:::::::::

:::::::: sect2
### []{#bandwith .hidden-anchor .sr-only}7.3. Bandbreiten, Datenraten {#heading_bandwith}

::: paragraph
Die Netzwerker haben ihre eigenen Begriffe und Arten, Dinge
auszudrücken. Und wie immer gibt sich Checkmk Mühe, in jeder Domäne die
dort übliche Art zu kommunizieren, zu übernehmen. Deswegen gibt es für
Datenraten und Geschwindigkeiten gleich drei verschiedene
Render-Funktionen. Alle haben gemeinsam, dass die Raten in *Bytes pro
Sekunde* übergeben werden, selbst dann, wenn die Ausgabe in Bits
erfolgt!
:::

::: paragraph
`render.nicspeed()` stellt die Maximalgeschwindigkeit einer
Netzwerkkarte oder eines Switchports dar. Da es keine Messwerte sind,
muss auch nicht gerundet werden. Obwohl kein Port einzelne Bits
versenden kann, sind die Angaben aus historischen Gründen in Bits.
:::

::: paragraph
**Wichtig:** Trotzdem müssen Sie auch hier Bytes pro Sekunde übergeben!
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.nicspeed(12500000)`       | `100 MBit/s`                      |
+-----------------------------------+-----------------------------------+
| `render.nicspeed(100000000)`      | `800 MBit/s`                      |
+-----------------------------------+-----------------------------------+

::: paragraph
`render.networkbandwidth()` ist gedacht für eine tatsächlich gemessene
Übertragungsgeschwindigkeit im Netzwerk. Eingabewert ist wieder Bytes
pro Sekunde:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.networkbandwidth(123)`    | `984 Bit/s`                       |
+-----------------------------------+-----------------------------------+
| `render.networkbandwidth(123456)` | `988 kBit/s`                      |
+-----------------------------------+-----------------------------------+
| `re                               | `988 MBit/s`                      |
| nder.networkbandwidth(123456789)` |                                   |
+-----------------------------------+-----------------------------------+

::: paragraph
Wo es nicht ums Netzwerk geht und dennoch Datenraten ausgegeben werden,
sind wieder Bytes üblich. Prominentester Fall sind IO-Raten von
Festplatten. Dafür gibt es die Funktion `render.iobandwidth()`, die in
Checkmk mit 1000er-Potenzen arbeitet:
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.iobandwidth(123)`         | `123 B/s`                         |
+-----------------------------------+-----------------------------------+
| `render.iobandwidth(123456)`      | `123 kB/s`                        |
+-----------------------------------+-----------------------------------+
| `render.iobandwidth(123456789)`   | `123 MB/s`                        |
+-----------------------------------+-----------------------------------+
::::::::

::::: sect2
### []{#percentage .hidden-anchor .sr-only}7.4. Prozentsätze {#heading_percentage}

::: paragraph
Die Funktion `render.percent()` stellt einen Prozentsatz dar --- auf
zwei Nachkommastellen gerundet. Sie ist insofern eine Ausnahme zu den
anderen Funktionen, als hier nicht der eigentlich natürliche
Wert --- also das Verhältnis --- übergeben wird, sondern wirklich die
Prozentzahl. Wenn also etwas zum Beispiel zur Hälfte voll ist, müssen
Sie nicht `0.5` sondern `50` übergeben.
:::

::: paragraph
Weil es manchmal interessant sein kann, zu wissen, ob ein Wert beinahe
Null oder exakt Null ist, werden Werte durch Anfügen eines „`<`"
Zeichens markiert, die größer als Null, aber kleiner als 0,01 Prozent
sind.
:::

+-----------------------------------+-----------------------------------+
| Aufruf                            | Ausgabe                           |
+===================================+===================================+
| `render.percent(0.004)`           | `<0.01%`                          |
+-----------------------------------+-----------------------------------+
| `render.percent(18.5)`            | `18.50%`                          |
+-----------------------------------+-----------------------------------+
| `render.percent(123)`             | `123.00%`                         |
+-----------------------------------+-----------------------------------+
:::::

:::: sect2
### []{#numbers_summary .hidden-anchor .sr-only}7.5. Zusammenfassung {#heading_numbers_summary}

::: paragraph
Hier folgt zum Abschluss die Übersicht über alle Render-Funktionen:
:::

+-------------+-------------+---------------------------+-------------+
| Funktion    | Eingabe     | Beschreibung              | Beis        |
|             |             |                           | pielausgabe |
+=============+=============+===========================+=============+
| `date()`    | Unix-Zeit   | Datum                     | `           |
|             |             |                           | 2023-11-14` |
+-------------+-------------+---------------------------+-------------+
| `           | Unix-Zeit   | Datum und Uhrzeit         | `2023-11-1  |
| datetime()` |             |                           | 4 23:13:20` |
+-------------+-------------+---------------------------+-------------+
| `           | Sekunden    | Dauer / Alter             | `3 hours    |
| timespan()` |             |                           | 25 minutes` |
+-------------+-------------+---------------------------+-------------+
| `f          | Hz          | Frequenz (z. B. Taktrate) | `111 GHz`   |
| requency()` |             |                           |             |
+-------------+-------------+---------------------------+-------------+
| `           | Bytes       | Größe einer Festplatte,   | `1,234 GB`  |
| disksize()` |             | Basis 1000                |             |
+-------------+-------------+---------------------------+-------------+
| `           | Bytes       | Größe einer Datei, volle  | `1          |
| filesize()` |             | Genauigkeit               | ,334,560 B` |
+-------------+-------------+---------------------------+-------------+
| `bytes()`   | Bytes       | Größe, Basis 1024         | `23,4 KiB`  |
+-------------+-------------+---------------------------+-------------+
| `           | Bytes pro   | Geschwindigkeit von       | `           |
| nicspeed()` | Sekunde     | Netzwerkkarten            | 100 MBit/s` |
+-------------+-------------+---------------------------+-------------+
| `networkb   | Bytes pro   | Üb                        | `23         |
| andwidth()` | Sekunde     | ertragungsgeschwindigkeit | .50 GBit/s` |
+-------------+-------------+---------------------------+-------------+
| `iob        | Bytes pro   | IO-Bandbreiten            | `124 MB/s`  |
| andwidth()` | Sekunde     |                           |             |
+-------------+-------------+---------------------------+-------------+
| `percent()` | Prozentzahl | Prozentsatz, sinnvoll     | `99.997%`   |
|             |             | gerundet                  |             |
+-------------+-------------+---------------------------+-------------+
::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#errors .hidden-anchor .sr-only}8. Fehler beheben {#heading_errors}

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die korrekte Behandlung von Fehlern nimmt (leider) einen großen Teil der
Programmierarbeit ein. Dabei ist die gute Nachricht, dass Ihnen die
Check-API hinsichtlich der Fehlerbehandlung bereits viel Arbeit abnimmt.
Bei einigen Arten von Fehlern ist es daher richtig, diese gar nicht
selbst zu behandeln.
:::

::: paragraph
Wenn Python in eine Situation kommt, die in irgendeiner Form
*unerwartet* ist, reagiert es mit einer sogenannten Ausnahme
(*Exception*). Hier sind ein paar Beispiele:
:::

::: ulist
- Sie konvertieren mit `int()` einen String in eine Zahl, aber der
  String enthält keine Zahl, zum Beispiel `int("foo")`.

- Sie greifen mit `bar[4]` auf das fünfte Element von `bar` zu, aber das
  hat nur vier Elemente.

- Sie rufen eine Funktion auf, die es nicht gibt.
:::

::: paragraph
Um entscheiden zu können, wie Sie Fehler angehen, ist es zunächst
wichtig, die exakte Stelle im Code zu kennen, an der ein Fehler
auftritt. Hierfür können Sie sowohl die GUI als auch die Kommandozeile
verwenden --- je nachdem, wo Sie gerade arbeiten.
:::

:::::::::: sect2
### []{#error_exception_gui .hidden-anchor .sr-only}8.1. Exceptions und Absturzberichte in der GUI {#heading_error_exception_gui}

::: paragraph
Tritt eine Exception im Monitoring oder während der Service-Erkennung im
[Setup]{.guihint} auf, enthält das [Summary]{.guihint} Hinweise auf den
eben erstellten Absturzbericht (*crash report*). Das sieht dann zum
Beispiel so aus:
:::

:::: imageblock
::: content
![Ein Service, dessen Check-Plugin abgestürzt
ist.](../images/devel_cpi_service_crash_report.png)
:::
::::

::: paragraph
Durch einen Klick auf das Symbol [![Symbol für ein abgestürztes
Check-Plugin.](../images/icons/icon_crash.png)]{.image-inline} wird eine
Seite mit Details angezeigt, auf der Sie:
:::

::: ulist
- die Datei angezeigt bekommen, in der der Absturz stattgefunden hat,

- alle Informationen über den Absturz erhalten, wie die Auflistung der
  aufgetretenen Fehler im Programm (*Traceback*), aktuelle Werte lokaler
  Variablen, Agentenausgabe und vieles mehr sowie

- den Report zu uns (Checkmk GmbH) als Feedback einsenden können.
:::

::: paragraph
Der Traceback hilft Ihnen als Programmierer zu entscheiden, ob ein
Fehler im Programm vorliegt (beispielsweise der Aufruf einer nicht
vorhandenen Funktion) oder Agentendaten vorliegen, die nicht wie
erwartet verarbeitet werden konnten. Im ersten Fall werden Sie den
Fehler beheben wollen, im zweiten Fall ist es häufig sinnvoll, nichts zu
tun.
:::

::: paragraph
Das Einsenden des Reports ist natürlich nur für Check-Plugins sinnvoll,
die offiziell Teil von Checkmk sind. Falls Sie eigene Plugins Dritten
zugänglich machen, können Sie Ihre Anwender bitten, Ihnen die Daten
zukommen zu lassen.
:::
::::::::::

:::::::::::::: sect2
### []{#error_exception_cli .hidden-anchor .sr-only}8.2. Exceptions auf der Kommandozeile ansehen {#heading_error_exception_cli}

::: paragraph
Wenn Sie Ihr Check-Plugin auf der Kommandozeile ausführen, erhalten Sie
keinen Hinweis auf die ID des erzeugten Absturzberichts. Sie sehen nur
die zusammengefasste Fehlermeldung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --detect-plugins=myhostgroups_advanced localhost
Error in agent based plugin: cmk_addons.plugins.myhostgroups.agent_based.myhostgroups: name 'agent_section_myhostgroups' is not defined
```
:::
::::

::: paragraph
Hängen Sie die Option `--debug` als zusätzlichen Aufrufparameter an,
dann bekommen Sie den Traceback des Python-Interpreters:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --debug --detect-plugins=myhostgroups_advanced localhost
Traceback (most recent call last):
  File "/omd/sites/mysite/lib/python3/cmk/discover_plugins/_python_plugins.py", line 195, in add_from_module
    module = importer(mod_name, raise_errors=True)
             ^^^^^^^^^^^^^
  File "/omd/sites/mysite/lib/python3/cmk/discover_plugins/_python_plugins.py", line 156, in _import_optionally
    return importlib.import_module(module_name)
           ^^^^^^^^^^^^
  File "/omd/sites/mysite/lib/python3.12/importlib/init.py", line 90, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
           ^^^^^^^^^^^^^^^^^^
  File "<frozen importlib._bootstrap>", line 1387, in _gcd_import
  File "<frozen importlib._bootstrap>", line 1360, in _find_and_load
  File "<frozen importlib._bootstrap>", line 1331, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 935, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 995, in exec_module
  File "<frozen importlib._bootstrap>", line 488, in _call_with_frames_removed
  File "/omd/sites/mysite/local/lib/python3/cmk_addons/plugins/myhostgroups/agent_based/myhostgroups.py", line 110, in <module>
    agent_section_myhostgroups == AgentSection(
    ^^^^^^^^^^
NameError: name 'agent_section_myhostgroups' is not defined
```
:::
::::

::: paragraph
Tritt der Fehler beim Aufruf mit `--debug` beim nächsten Mal nicht mehr
auf, zum Beispiel, weil eine neue Agentenausgabe bereitsteht, können Sie
die letzten Absturzberichte auch im Dateisystem einsehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ls -lhtr ~/var/check_mk/crashes/check/ | tail -n 5
drwxrwxr-x 2 mysite mysite 4.0K Aug  6 17:56 7b59a49e-540c-11ef-9595-7574c603ce8d/
drwxrwxr-x 2 mysite mysite 4.0K Aug  6 17:56 7c8870c0-540c-11ef-9595-7574c603ce8d/
drwxrwxr-x 2 mysite mysite 4.0K Aug  6 17:56 7cf9626c-540c-11ef-9595-7574c603ce8d/
drwxrwxr-x 2 mysite mysite 4.0K Aug  6 17:56 7d192d68-540c-11ef-9595-7574c603ce8d/
drwxrwxr-x 2 mysite mysite 4.0K Aug  6 17:56 7e2d5ec2-540c-11ef-9595-7574c603ce8d/
```
:::
::::

::: paragraph
In jedem dieser Ordner liegen zwei Dateien:
:::

::: {.olist .arabic}
1.  `crash.info` enthält ein Python-Dictionary mit Traceback und vielen
    weiteren Informationen. Oft genügt der Blick in die Datei mit dem
    Pager.

2.  `agent_output` enthält die vollständige Agentenausgabe, die zum
    Zeitpunkt des Absturzes aktuell war.
:::
::::::::::::::

::::::::: sect2
### []{#custom_debug .hidden-anchor .sr-only}8.3. Eigene Debug-Ausgabe {#heading_custom_debug}

::: paragraph
In den oben gezeigten Beispielen verwenden wir die Funktion `print()`,
um für Sie als Programmierer den Inhalt von Variablen oder die Struktur
von Objekten auszugeben. Diese Funktionen für Debug-Ausgaben müssen aus
dem fertigen Check-Plugin wieder entfernt werden.
:::

::: paragraph
Alternativ zur Entfernung können Sie Ihre Debug-Ausgabe auch nur
ausgeben lassen, wenn das Check-Plugin in der Konsole im Debug-Modus
aufgerufen wird. Dafür importieren Sie das Debug-Objekt aus der
Checkmk-Werkzeugkiste und gegebenenfalls die Formatierungshilfe
`pprint()`. Sie können nun Debug-Ausgaben abhängig vom Wert des
Debug-Objektes vornehmen:
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das Debug-Objekt wird von Checkmk |
|                                   | [2.3.0]{.new} nach [2.4.0]{.new}  |
|                                   | seinen Pfad ändern. Statt bisher  |
|                                   | unter `cmk.utils` ist es künftig  |
|                                   | unter `cmk.ccc` zu finden.        |
|                                   | Portabler Code versucht zuerst,   |
|                                   | aus dem neuen Pfad zu importieren |
|                                   | und fällt im Fehlerfall auf den   |
|                                   | alten zurück.                     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::: listingblock
::: content
``` {.pygments .highlight}
try:
    from cmk.ccc import debug
except ImportError:
    from cmk.utils import debug

from pprint import pprint

def check_mystuff(section):
    if debug.enabled():
        pprint(section)
```
:::
::::

::: paragraph
Beachten Sie, dass verbleibende Debug-Ausgaben sparsam verwendet und auf
Hinweise beschränkt sein sollten, die den späteren Benutzern bei der
Fehlersuche helfen. Offensichtliche und abzusehende Fehler des Benutzers
(zum Beispiel, dass die Inhalte der Agentensektion darauf hindeuten,
dass das Agentenplugin falsch konfiguriert ist) sollten Sie mit dem
Zustand [UNKNOWN]{.state3} und aussagekräftigen Hinweisen im Summary
beantworten.
:::
:::::::::

::::::::::: sect2
### []{#error_invalid_agent .hidden-anchor .sr-only}8.4. Ungültige Agentenausgabe {#heading_error_invalid_agent}

::: paragraph
Die Frage ist, wie Sie reagieren sollen, wenn die Ausgaben vom Agenten
nicht die Form haben, die Sie eigentlich erwarten --- egal ob vom
Checkmk-Agenten oder per [SNMP](devel_check_plugins_snmp.html) erhalten.
Angenommen, Sie erwarten pro Zeile immer drei Worte. Was sollen Sie tun,
falls nur zwei kommen?
:::

::: paragraph
Nun, wenn das ein *erlaubtes und bekanntes* Verhalten des Agenten ist,
dann müssen Sie das natürlich abfangen und mit einer Fallunterscheidung
arbeiten. Falls das aber eigentlich nicht sein darf, dann tun Sie am
besten so, als ob die Zeile immer aus drei Worten besteht, also zum
Beispiel mit folgender Parse-Funktion:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
def parse_foobar(string_table):
    for foo, bar, baz in string_table:
        # ...
```
:::
::::

::: paragraph
Sollte jetzt mal eine Zeile dabei sein, die nicht aus genau drei Worten
besteht, wird eine Exception erzeugt und Sie bekommen den gerade
erwähnten sehr hilfreichen Absturzbericht.
:::

::: paragraph
Falls Sie auf Schlüssel in einem Dictionary zugreifen, die gelegentlich
erwartbar fehlen, kann es natürlich sinnvoll sein, darauf entsprechend
zu reagieren. Das kann erfolgen, indem *Sie* den Service auf
[CRIT]{.state2} oder [UNKNOWN]{.state3} setzen und im Summary einen
Hinweis auf die nicht auswertbare Agentenausgabe unterbringen. In jedem
Fall ist es besser, Sie verwenden hierfür die `get()`-Funktion des
Dictionaries als die `KeyError` Exception abzufangen. Denn `get()`
liefert bei Nichtvorhandensein des Schlüssels ein Objekt vom Typ `None`
oder einen optional als zweiten Parameter zu übergebenden Ersatz:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
def check_foobar(section):
    foo = section.get("bar")
    if not foo:
        yield Result(state=State.CRIT, summary="Missing key in section: bar")
        return
    # ...
```
:::
::::
:::::::::::

::::::: sect2
### []{#error_missing_item .hidden-anchor .sr-only}8.5. Fehlende Items {#heading_error_missing_item}

::: paragraph
Was ist, wenn der Agent korrekte Daten ausgibt, aber das Item fehlt, das
überprüft werden soll? Also zum Beispiel auf diese Art:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
def check_foobar(item, section):
    # Try to access the item as key in the section:
    foo = section.get(item)
    if foo:
        yield Result(state=State.OK, summary="Item found in monitoring data")
    # If foo is None, nothing is yielded here
```
:::
::::

::: paragraph
Ist das gesuchte Item nicht dabei, so wird die Schleife durchlaufen und
Python fällt am Ende der Funktion einfach hinten raus, ohne dass ein
Resultat per `yield` zurückgegeben wurde. Und das ist genau das
Richtige! Denn daran erkennt Checkmk, dass das zu überwachende Item
fehlt und erzeugt mit [UNKNOWN]{.state3} den richtigen Status und einen
passenden Standardtext dazu.
:::
:::::::

::::: sect2
### []{#error_spool .hidden-anchor .sr-only}8.6. Test mit Spool-Dateien {#heading_error_spool}

::: paragraph
Wenn Sie bestimmte Agentenausgaben simulieren wollen, sind Dateien im
[Spool-Verzeichnis](spool_directory.html) sehr hilfreich. Diese können
Sie nutzen, um sonst schwer nachzustellende Grenzfälle zu testen. Oder
Sie verwenden direkt die Agentenausgabe, welche zu einem Absturzbericht
geführt hat, zur Prüfung von Änderungen an einem Check-Plugin.
:::

::: paragraph
Deaktivieren Sie zunächst Ihr reguläres Agentenplugin, beispielsweise
indem Sie ihm die Ausführungsberechtigung entziehen. Erstellen Sie dann
eine Datei im Verzeichnis `/var/lib/check_mk_agent/spool/`, welche die
von Ihrem Check-Plugin erwartete Agentensektion (oder erwarteten
*Agentensektionen*) inklusive Sektions-Header enthält und auf Newline
endet. Beim nächsten Aufruf des Agenten wird dann der Inhalt der
Spool-Datei statt der Ausgabe des Agentenplugins übertragen.
:::
:::::

:::::: sect2
### []{#performance .hidden-anchor .sr-only}8.7. Alte Check-Plugins werden bei vielen Services langsam {#heading_performance}

::: paragraph
Bei einigen Check-Plugins, die Items nutzen, ist es auf größeren Servern
durchaus möglich, dass einige hundert Services erzeugt werden. Wenn
keine eigene Parse-Funktion verwendet wird, hat dies zur Folge, dass für
jedes der hunderten Items die gesamte Liste von hunderten Zeilen
durchlaufen werden muss. Die zum Suchen benötigte Zeit steigt also im
Quadrat mit der Zahl der Listenelemente, bei hunderten Services bedeutet
das zigtausende Vergleiche. Ist dagegen die geschachtelte Liste in ein
Dictionary überführt, steigt der Aufwand für die Suche eines Elements
nur linear mit der Größe des Dictionaries.
:::

::: paragraph
Im Python-Wiki finden Sie eine [Übersicht der
Kosten](https://wiki.python.org/moin/TimeComplexity){target="_blank"}
für die Suche in verschiedenen Datentypen, inklusive Erläuterung und
*O-Notation.* Mit der Parse-Funktion reduzieren die Komplexität der
Suche von *O(n)* auf *O(1)*.
:::

::: paragraph
Da ältere Versionen dieses Artikels keinen Gebrauch von der
Parse-Funktion gemacht haben, sollten Sie derartige Check-Plugins
identifizieren und diese auf Verwendung einer Parse-Funktion
umschreiben.
:::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#migration .hidden-anchor .sr-only}9. Migration {#heading_migration}

::::::: sectionbody
::: paragraph
Die in der Checkmk-Version [2.0.0]{.new} eingeführte Check-API V1 wird
in der Version [2.3.0]{.new} weiterhin unterstützt, aber nicht mehr in
der nächsten Version [2.4.0]{.new}. Wir empfehlen daher, die Zeit bis
zur Freigabe der Version [2.4.0]{.new} zu nutzen und alle Check-Plugins
auf die neuen APIs zu migrieren.
:::

::: paragraph
Die folgenden Informationen helfen Ihnen bei der Migration von
Check-Plugins der Check-API V1 auf die V2:
:::

::: ulist
- Die neue Verzeichnisstruktur und Namenskonvention zur Ablage der
  Dateien für alle Plugin-APIs finden Sie in der
  [API-Dokumentation](#check_api_doc) auf der Hauptseite [Checkmk's
  Plug-in APIs.]{.guihint}

- Die Zusammenfassung der Änderungen in der Check-API V2 steht ebenfalls
  in der API-Dokumentation in [Checkmk's Plug-in APIs \> Agent based
  (\"Check API\") \> Version 2 \> New in this version.]{.guihint} Dort
  finden Sie auch den Link zu einem GitHub-Commit, der das bestehende
  Check-Plugin `apt` zur Check-API V2 migriert.

- Auf
  [GitHub](https://github.com/Checkmk/checkmk/tree/master/doc/treasures/migration_helpers/){target="_blank"}
  finden Sie im `treasures`-Verzeichnis von Checkmk Skripte, die Ihnen
  bei der Migration auf die neuen APIs helfen.
:::

::: paragraph
Ein abschließender Hinweis für Benutzer, die noch Check-Plugins haben,
die mit der alten, bis zur Checkmk-Version [1.6.0]{.new} gültigen
Check-API entwickelt wurden. Diese Check-Plugins werden in der
Checkmk-Version [2.3.0]{.new} nicht mehr offiziell unterstützt. Details
finden Sie im [Werk
#16689](https://checkmk.com/de/werk/16689){target="_blank"}. Wie Sie
solche, veralteten Check-Plugins auf die Check-API V1 migrieren,
erfahren Sie im [Blogpost zur
Migration.](https://checkmk.com/de/blog/migrating-check-plug-ins-to-checkmk-2-0){target="_blank"}
:::
:::::::
::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}10. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/local                          | Basisverzeichnis zur Ablage von   |
| /lib/python3/cmk_addons/plugins/` | Plugin-Dateien.                   |
+-----------------------------------+-----------------------------------+
| `~/l                              | Ablageort für nach der Check-API  |
| ocal/lib/python3/cmk_addons/plugi | V2 selbst geschriebene            |
| ns/<plug-in_family>/agent_based/` | Check-Plugins.                    |
+-----------------------------------+-----------------------------------+
| `                                 | Ablageort für nach der            |
| ~/local/lib/python3/cmk_addons/pl | Rulesets-API erstellte            |
| ugins/<plug-in_family>/rulesets/` | Regelsatzdateien.                 |
+-----------------------------------+-----------------------------------+
| `                                 | Ablageort für nach der            |
| ~/local/lib/python3/cmk_addons/pl | Graphing-API erstellte            |
| ugins/<plug-in_family>/graphing/` | Graphing-Dateien.                 |
+-----------------------------------+-----------------------------------+
| `                                 | Dieses Verzeichnis liegt auf      |
| /usr/lib/check_mk_agent/plugins/` | einem überwachten Linux-Host.     |
|                                   | Hier erwartet der Checkmk-Agent   |
|                                   | für Linux Erweiterungen des       |
|                                   | Agenten (Agentenplugins).         |
+-----------------------------------+-----------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
