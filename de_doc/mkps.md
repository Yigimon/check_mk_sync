:::: {#header}
# Checkmk-Erweiterungspakete (MKPs)

::: details
[Last modified on 15-Mar-2025]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/mkps.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
[Lokale Checks](localchecks.html) [Erweiterungen für Checkmk
entwickeln](devel_intro.html) [Richtlinien für
Check-Plugins](dev_guidelines.html) [Die Bakery-API](bakery_api.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::::: sectionbody
::: paragraph
Checkmk ist sehr modular aufgebaut und kann an vielen Stellen mit
Python-Programmierkenntnissen erweitert werden. Unter anderem ist es
möglich, Checkmk um folgende Elemente auszubauen:
:::

::: ulist
- Eigene Checks und Agentenplugins inklusive Eingabemasken für die
  Konfigurationsumgebung

- Eigene Plugins für die Checkmk [HW/SW-Inventur](inventory.html)

- Erweiterungen für die GUI (Ansichten, Dashboards, Spalten, Icons,
  etc.)

- Definitionen von Graphen oder Perf-O-Metern

- Benachrichtigungs- und Alert Handler-Skripte (auch in Shell oder
  anderen Skriptsprachen)
:::

::: paragraph
All diese Erweiterungen werden durch Ablage von zusätzlichen Dateien
unterhalb des Verzeichnisses `~/local` innerhalb der Checkmk-Instanz
realisiert. Um diese Erweiterungen sinnvoll zu verwalten, innerhalb von
verteilten Umgebungen auszurollen und auch mit anderen Anwendern
auszutauschen, stellt Checkmk ein eigenes Paketformat bereit: das
**Checkmk-Erweiterungspaket** --- kurz **MKP**.
:::

::: paragraph
Ein MKP sammelt eine beliebige Menge von Erweiterungen --- z.B. einen
Satz Check-Plugins inklusive zugehöriger Handbuchseiten, der
Konfigurationsumgebung für Schwellwerte und zugehörigen
Metrikdefinitionen. Es kann darüber hinaus Einstellungen für die
Verteilung via Agentenbäckerei enthalten. Das MKP hat einen Namen, eine
Versionsnummer und kann mit einer einfachen Aktion installiert oder auch
wieder entfernt werden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Verwenden Sie zur Erstellung und  |
|                                   | Anpassung von MKPs eine           |
|                                   | Testinstanz und kopieren Sie die  |
|                                   | MKPs für die Verteilung auf die   |
|                                   | produktiv genutzte Instanz. Dies  |
|                                   | wird Ihnen vor allem zwei         |
|                                   | potentielle Probleme ersparen,    |
|                                   | die entstehen, wenn geänderte     |
|                                   | Dateien nicht rechtzeitig zu MKPs |
|                                   | gepackt werden:                   |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: ulist                         |
|                                   | - Beim Checkmk-Update werden      |
|                                   |   lokal geänderte Dateien durch   |
|                                   |   den letzten Stand des MKPs      |
|                                   |   überschrieben (dem Autor dieses |
|                                   |   Satzes ist genau dies           |
|                                   |   passiert).                      |
|                                   |                                   |
|                                   | - Im [verteilten                  |
|                                   |   Setup                           |
|                                   | ](glossar.html#distributed_setup) |
|                                   |   wundern Sie sich, weil sich     |
|                                   |   Plugins auf Remote-Instanzen    |
|                                   |   anders verhalten als auf der    |
|                                   |   Zentralinstanz, denn die        |
|                                   |   Remote-Instanzen erhalten       |
|                                   |   weiterhin den zuletzt gepackten |
|                                   |   Stand.                          |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::: sect2
### []{#exchange .hidden-anchor .sr-only}1.1. Die Checkmk Exchange {#heading_exchange}

::: paragraph
Auf der [Checkmk
Exchange](https://exchange.checkmk.com){target="_blank"} können
Plugin-Programmierer Pakete für andere Checkmk-Benutzer bereitstellen
und untereinander austauschen. Von dort können Sie kostenlos
Erweiterungen herunterladen und verwenden. Beachten Sie bei Paketen von
der Exchange, dass diese durch andere Benutzer freiwillig und ohne jede
Garantie bereitgestellt werden.
:::

::: paragraph
Unsauber programmierte Plugins können zu erhöhter Last und erhöhtem
Arbeitsspeicherbedarf führen. Zudem ist es möglich, dass MKPs für ältere
Versionen von CMK entwickelt wurden und so keine vollständige
Kompatibilität vorhanden ist. In Extremfällen droht Datenverlust. Wir
empfehlen daher vor dem produktiven Einsatz fremder MKPs die
Installation in einer Testinstanz.
:::
:::::

:::::: sect2
### []{#tools .hidden-anchor .sr-only}1.2. Werkzeuge für MKPs {#heading_tools}

::: paragraph
Zur Verwaltung von MKPs gibt es zwei Werkzeuge:
:::

::: ulist
- Den [Kommandozeilenbefehl](#commandline) `mkp`

- In den kommerziellen Editionen haben Sie zusätzlich den
  Setup-Menüeintrag [Extension Packages]{.guihint}
:::

::: paragraph
Beide sind miteinander kompatibel, so dass Sie mal den
Kommandozeilenbefehl und mal [Extension Packages]{.guihint} verwenden
können, ohne dass dabei etwas „durcheinandergerät".
:::
::::::
:::::::::::::::
::::::::::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#wato .hidden-anchor .sr-only}2. Erweiterungspakete über das Setup-Menü verwalten {#heading_wato}

:::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Möglichkeit
MKPs über die GUI zu verwalten gibt es ausschließlich in den
kommerziellen Editionen von Checkmk. Im [Setup]{.guihint}-Menü steigen
Sie in die Verwaltung der MKPs über [Setup \> Maintenance \> Extension
packages]{.guihint} ein. Hier können Sie MKPs hinzufügen, ändern oder
neu erstellen:
:::

:::: imageblock
::: content
![mkp manager sidebar](../images/mkp_manager_sidebar.png){width="30%"}
:::
::::

::::::::: sect2
### []{#add .hidden-anchor .sr-only}2.1. Hinzufügen eines MKPs {#heading_add}

::: paragraph
Ein MKP, das Sie z.B. von der Exchange heruntergeladen haben, können Sie
mit dem Knopf [Upload package]{.guihint} in Checkmk hochladen und so
verfügbar machen. Dafür muss die Datei auf dem Rechner vorhanden sein,
auf dem auch Ihr Webbrowser läuft. Die Dateiendung des Pakets muss
`.mkp` sein.
:::

:::: imageblock
::: content
![mkp manager upload](../images/mkp_manager_upload.png)
:::
::::

::: paragraph
Nach der Installation ist das Erweiterungspaket zunächst *verfügbar*,
jedoch *nicht aktiv*. Es befindet sich unter [All packages (enabled or
disabled)]{.guihint}:
:::

:::: imageblock
::: content
![mkp manager present not
active](../images/mkp_manager_present_not_active.png)
:::
::::
:::::::::

::::::: sect2
### []{#enable .hidden-anchor .sr-only}2.2. Aktivierung eines MKPs {#heading_enable}

::: paragraph
Erst mit dem Klick auf das Steckersymbol [![icon
install](../images/icons/icon_install.png)]{.image-inline} wird ein
verfügbares Paket auch aktiviert. Bei der Aktivierung werden die Dateien
in einer Ordnerhierarchie unterhalb von `~/local/` installiert und eine
Paketbeschreibungsdatei in `~/var/check_mk/packages/` abgelegt. Das
Paket erscheint dann auch in der Liste der *freigeschalteten und
aktiven* MKPs -- [Enabled (active on this site)]{.guihint}:
:::

:::: imageblock
::: content
![mkp manager list active](../images/mkp_manager_list_active.png)
:::
::::

::: paragraph
Nun führen Sie noch eine [Aktivierung der
Änderungen](wato.html#activate_changes) durch und alle Funktionen aus
dem Paket sind im System verankert und stehen Ihnen bereit.
:::
:::::::

::::: sect2
### []{#disable_remove .hidden-anchor .sr-only}2.3. Pakete deaktivieren und entfernen {#heading_disable_remove}

::: paragraph
Auch die vollständige Löschung eines Paketes erfolgt zweistufig. Mit dem
[![icon disabled](../images/icons/icon_disabled.png)]{.image-inline}
deaktivieren Sie es zunächst in der Liste der aktiven Pakete. In diesem
Schritt werden die installierten Dateien entfernt, aber das MKP wird
weiter vorgehalten -- dieser Schritt macht lediglich die *Aktivierung*
rückgängig.
:::

::: paragraph
Über das Symbol [![icon
delete](../images/icons/icon_delete.png)]{.image-inline} in der Liste
aller Pakete, können Sie installierte und nicht verwendete Pakete wieder
löschen. Beim Löschen wird das Paket gelöscht und somit die Erweiterung
komplett entfernt -- also das Gegenteil des *Hinzufügens eines Paketes*.
:::
:::::

:::::::: sect2
### []{#distr_wato .hidden-anchor .sr-only}2.4. MKPs in verteilten Umgebungen {#heading_distr_wato}

::: paragraph
Bei einem [verteilten Setup](distributed_monitoring.html#distr_wato)
reicht es, wenn Sie die Pakete auf der Zentralinstanz verfügbar machen.
Für jede der Zentralinstanz zugeordneten Remote-Instanz können Sie dann
separat bestimmen, ob die Anpassungen an diese Instanz übertragen werden
sollen. Sie müssen dazu lediglich die Option [Replicate
extensions]{.guihint} aktivieren. Danach werden bei der Synchronisation
auch die MKPs und alle anderen Änderungen unterhalb des Verzeichnisses
`~/local` übertragen.
:::

:::: imageblock
::: content
![mkp distr wato](../images/mkp_distr_wato.png)
:::
::::

::: paragraph
Ist die Übertragung nicht gewünscht, schalten Sie die Option für diese
oder alle Instanzen einfach ab.
:::

::: paragraph
**Wichtig**: Die Anpassungen für das verteilte Setup werden nur
übertragen, wenn die Option [Enable replication]{.guihint} auf [Push
configuration to this site]{.guihint} eingestellt ist.
:::
::::::::

::::::::: sect2
### []{#enabled_inactive .hidden-anchor .sr-only}2.5. Sonderfall: Freigeschaltete, aber inaktive Pakete {#heading_enabled_inactive}

::: paragraph
Ein Sonderfall stellt der Aktivierungsversuch eines Paketes dar, das
nicht zur verwendeten Checkmk-Version passt. Ein solches Paket, das zwar
freigeschaltet ist, aber dessen Aktivierung wegen einer inkompatiblen
Checkmk-Version fehlschlägt, landet in der Liste [Enabled (inactive on
this site)]{.guihint}.
:::

:::: imageblock
::: content
![mkp manager all states](../images/mkp_manager_all_states.png)
:::
::::

::: paragraph
Warum aber sollte man Pakete installieren, die nicht zur verwendeten
Checkmk-Version passen? Dafür gibt es zwei gute Gründe:
:::

::: {.olist .arabic}
1.  Das [Update der Checkmk-Version](update_major.html): Sie haben die
    Möglichkeit, Pakete sowohl für die alte als auch für die neue
    Version vorzuhalten -- beim Update wird dann automatisch das neuere
    aktiviert.

2.  [Verteiltes Monitoring](distributed_monitoring.html): Um Updates zu
    erleichtern, darf die Checkmk-Major-Version von Remote-Instanzen
    eine höher als die der Zentralinstanz sein. Dies erschwerte jedoch
    bislang die Verteilung von MKPs, denn diese mussten zu beiden
    Major-Versionen kompatibel sein. Mit der Möglichkeit, auch
    unpassende Pakete freizuschalten, können Sie in der Zentralinstanz
    jeweils Pakete vorhalten, die zur Ausgangs- und Zielversion passen.
    Beim Update wird dann automatisch das neuere aktiviert.
:::

::: paragraph
Aus den Versionsnummern im Screenshot können Sie entnehmen, dass es sich
um eine Checkmk [2.1.0]{.new} Zentralinstanz handelte, die Pakete für
Remote-Instanzen bereithält, welche bereits auf [2.2.0]{.new}
aktualisiert wurden.
:::
:::::::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#commandline .hidden-anchor .sr-only}3. Erweiterungspakete auf der Kommandozeile verwalten {#heading_commandline}

:::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Alle oben genannten Aktionen können Sie auch auf der Kommandozeile
ausführen. Dazu dient der Befehl `mkp`. Ruft man ihn ohne Subkommando
auf, zeigt er Hinweise zur Verwendung. Die etwa 50 Zeilen lange Ausgabe
haben wir auf weniger als die Hälfte abgekürzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp
usage: mkp [-h] [--debug] [--verbose] {find,inspect,show,show-all,files,list,add,...}

Command line interface for the Checkmk Extension Packages

options:
  -h, --help            show this help message and exit
  --debug, -d
  --verbose, -v         Be more verbose

available commands:
  {find,inspect,show,show-all,files,list,add,...}
    find                Show information about local files.
    inspect             Show manifest of an MKP file.
    show                Show manifest of a stored package.
    show-all            Show all manifests.
    files               Show all files beloning to a package.
    list                Show a table of all known files, including the deployment state.
    add                 Add an MKP to the collection of managed MKPs.
[...]
```
:::
::::

::: paragraph
In den folgenden Abschnitten stellen wir Ihnen die wichtigsten Befehle
zur Verwaltung von MKPs vor. Eine Befehlsreferenz in Tabellenform finden
Sie am [Ende dieses Artikels.](#command_reference)
:::

::::::::: sect2
### []{#_hinzufügen_eines_mkps .hidden-anchor .sr-only}3.1. Hinzufügen eines MKPs {#heading__hinzufügen_eines_mkps}

::: paragraph
Das Hinzufügen eines Pakets geschieht mit `mkp add`. Dazu müssen Sie die
MKP-Datei natürlich zunächst auf den Checkmk-Server bringen (z.B. mit
`scp`). Anschließend führen Sie den folgenden Befehl aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp add /tmp/hello_world-0.2.5.mkp
```
:::
::::

::: paragraph
Die Liste der vorhandenen Pakete rufen Sie mit `mkp list` ab. Nach der
Installation ist das Erweiterungspaket zunächst *verfügbar*, jedoch
*nicht aktiv*. Es hat den Zustand [State: Disabled]{.guihint}:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp list
Name        Version Title        Author                 Req. Version Until Version Files State
----------- ------- ------------ ---------------------- ------------ ------------- ----- --------
hello_world 0.2.5   Hello world! Checkmk knowledge team 2.3.0b1      2.5.99        8     Disabled
```
:::
::::
:::::::::

:::::::::::: sect2
### []{#_aktivierung_eines_mkps .hidden-anchor .sr-only}3.2. Aktivierung eines MKPs {#heading__aktivierung_eines_mkps}

::: paragraph
Erst mit dem Subkommando `enable` wird ein verfügbares Paket auch
aktiviert. Die Angabe der Versionsnummer ist nur in dem Fall
erforderlich, dass der Name alleine [nicht
eindeutig](#enabled_inactive_cli) ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp enable hello_world 0.2.5
```
:::
::::

::: paragraph
Bei der Aktivierung werden die Dateien in einer Verzeichnishierarchie
unterhalb von `~/local/` installiert und die Paketbeschreibungsdatei in
`~/var/check_mk/packages/` abgelegt. Das Paket erhält dadurch den
Zustand [Enabled (active on this site)]{.guihint}:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp list
Name        Version Title        Author                 Req. Version Until Version Files State
----------- ------- ------------ ---------------------- ------------ ------------- ----- -----------------------------
hello_world 0.2.5   Hello world! Checkmk knowledge team 2.3.0b1      2.5.99        8     Enabled (active on this site)
```
:::
::::

::: paragraph
Details über ein einzelnes Paket erfahren Sie mit `mkp show`, der
Aktivierungszustand spielt dabei keine Rolle:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp show hello_world 0.2.5
Name:                          hello_world
Version:                       0.2.5
Packaged on Checkmk Version:   2.4.0b1
Required Checkmk Version:      2.3.0b1
Valid until Checkmk version:   2.5.99
Title:                         Hello world!
Author:                        Checkmk knowledge team
Download-URL:                  https://docs.checkmk.com/latest/en/devel_check_plugins.html
Files:
  Agents
    plugins/hello_world
    windows/plugins/hello_world.cmd
  Additional Checkmk plug-ins by third parties
    hello_world/agent_based/hello_world.py
    hello_world/checkman/hello_world
    hello_world/graphing/helloworld_perfometer_graphing.py
    hello_world/rulesets/ruleset_hello_world.py
    hello_world/rulesets/ruleset_hello_world_bakery.py
  Libraries
    python3/cmk/base/cee/plugins/bakery/hello_world.py
Description:
  This is a very basic plugin with the sole purpose to be used as template for your own plugin development...
```
:::
::::
::::::::::::

:::::::::::: sect2
### []{#_pakete_deaktivieren_und_entfernen .hidden-anchor .sr-only}3.3. Pakete deaktivieren und entfernen {#heading__pakete_deaktivieren_und_entfernen}

::: paragraph
Die Deinstallation eines Pakets geschieht in zwei Stufen. Zunächst wird
das Paket mit `mkp disable` deaktiviert. Dies löscht installierte
Dateien, hält das Paket aber -- beispielsweise für eine spätere erneute
Aktivierung -- weiterhin vor. Die Angabe der Versionsnummer ist auch
hier nur in dem Fall erforderlich, dass der Name alleine [nicht
eindeutig](#enabled_inactive_cli) ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp disable hello_world 0.2.5
```
:::
::::

::: paragraph
In der Paketliste sehen Sie nun den Zustand [Disabled]{.guihint}, wenn
Sie ein weiteres mal `mkp list` aufrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp list
Name        Version Title        Author                 Req. Version Until Version Files State
----------- ------- ------------ ---------------------- ------------ ------------- ----- --------
hello_world 0.2.5   Hello world! Checkmk knowledge team 2.3.0b1      2.5.99        8     Disabled
```
:::
::::

::: paragraph
Erst `mkp remove` löscht das Paket unwiderruflich:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp remove hello_world 0.2.5
```
:::
::::
::::::::::::

:::::::::: sect2
### []{#enabled_inactive_cli .hidden-anchor .sr-only}3.4. Sonderfall: Freigeschaltete, aber inaktive Pakete {#heading_enabled_inactive_cli}

::: paragraph
Ein Sonderfall stellt die Installation eines Paketes dar, das nicht zur
verwendeten Checkmk-Version passt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp install hello_world-0.3.0.mkp
The package requires Checkmk version 2.5.0, but you have 2.3.0p23 installed.
```
:::
::::

::: paragraph
Ein solches Paket können Sie zwar freischalten. Dessen Aktivierung
schlägt dann aber wegen der inkompatiblen Checkmk-Version fehl und
erhält den Zustand [Enabled (inactive on this site)]{.guihint}.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp list
Name        Version Title        Author                 Req. Version Until Version Files State
----------- ------- ------------ ---------------------- ------------ ------------- ----- -------------------------------
hello_world 0.3.0   Hello world! Checkmk knowledge team 2.5.0b1      2.6.99        8     Enabled (inactive on this site)
hello_world 0.2.5   Hello world! Checkmk knowledge team 2.3.0b1      2.5.99        8     Enabled (active on this site)
```
:::
::::

::: paragraph
Die Gründe für die Installation inkompatibler Pakete -- Updates und
verteilte Umgebungen -- erklären wir [oben](#enabled_inactive) im
entsprechenden Setup-Schritt. Ebenso analog zum Vorgehen im Setup
verwenden Sie `mkp enable paketname version`, um ein Paket
freizuschalten, respektive `mkp disable paketname version`, um eine
vorhandene Freischaltung aufzuheben.
:::
::::::::::
::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#developers .hidden-anchor .sr-only}4. MKPs für Entwickler {#heading_developers}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die meisten von uns, die programmieren können oder lernen, sind
*gleichsam Zwerge, die [auf den Schultern von
Riesen](https://de.wikipedia.org/wiki/Zwerge_auf_den_Schultern_von_Riesen){target="_blank"}
sitzen, um mehr und Entfernteres als diese sehen zu können:* Gerade im
Open Source Bereich können wir vom früheren Schaffen anderer
profitieren. Im Falle von Checkmk gilt dies ganz besonders für
Erweiterungen, welche im Sinne der GPL abgeleitete Werke von Checkmk
selbst sind, die wiederum der GPL ([Version
2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html){target="_blank"})
unterliegen. Konkret bedeutet dies, dass Sie in der [Checkmk
Exchange](https://exchange.checkmk.com){target="_blank"}
heruntergeladene Pakete nach Herzenslust (oder einfach aktuellem Bedarf)
anpassen können.
:::

::: paragraph
In den folgenden Abschnitten zeigen wir -- angefangen vom neu paketieren
mit kleinen Änderungen, über Auflösen eines vorhandenen (Beispiel-)
Paketes, hin zur Zusammenstellung unpaketierter Dateien -- alle
relevanten Schritte in ihrer typischen Reihenfolge.
:::

::: paragraph
Wenn Sie selbst Plugins für Checkmk programmieren oder modifizieren,
beachten Sie die Artikel zu den vorhandenen
[Programmierschnittstellen](devel_intro.html), der [Integration in die
Agentenbäckerei](bakery_api.html) sowie die [Richtlinien für
Check-Plugins](dev_guidelines.html).
:::

:::::::: sect2
### []{#edit_mkp .hidden-anchor .sr-only}4.1. Pakete editieren {#heading_edit_mkp}

::: paragraph
Oft macht die Korrektur kleinerer Fehler die Anpassung eines vorhandenen
Paketes notwendig, ohne dass Struktur oder Name geändert werden sollen.
In diesem Fall ist es ratsam, nicht nur die im Dateisystem abgelegten
Dateien anzupassen, sondern zumindest auch die Versionsnummer zu
aktualisieren. Erfordern Änderungen der APIs von Checkmk-Modifikationen
an einem Paket, passen Sie zudem die im Paket hinterlegten
Versionsnummern für minimal und maximal unterstützte Versionen an. Bei
Verwendung der Agentenbäckerei triggert zudem das Vorhandensein neuer
MKPs den Neubau der Agentenpakete.
:::

::: paragraph
In den kommerziellen Editionen verwenden Sie das Symbol [![icon
edit](../images/icons/icon_edit.png)]{.image-inline}, um zum
Änderungsdialog zu gelangen.
:::

:::: imageblock
::: content
![mkp edit description](../images/mkp_edit_description.png)
:::
::::

::: paragraph
Benutzer von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** gehen stattdessen die beiden folgenden Schritte über
[auflösen](#release_mkp) und neu [erstellen.](#package_mkp)
:::
::::::::

::::::::::: sect2
### []{#release_mkp .hidden-anchor .sr-only}4.2. Pakete auflösen {#heading_release_mkp}

::::: sect3
#### []{#release_mkp_gui .hidden-anchor .sr-only}Setup-Menü {#heading_release_mkp_gui}

::: paragraph
Das [![icon release
mkp](../images/icons/icon_release_mkp.png)]{.image-inline} Auflösen
eines Paketes entlässt die paketierten Dateien unter `~/local/`
sozusagen \"in die Freiheit\" und entfernt nur die Paketbeschreibung.
Als Ergebnis sind die Dateien dann unpaketiert und die Erweiterungen
weiterhin aktiv. Dies ist das Gegenteil des Erzeugens eines Pakets aus
bisher unpaketierten Dateien.
:::

::: paragraph
In der Praxis werden Sie das Auflösen von Paketen am ehesten benötigen,
wenn Sie eine Erweiterung anpassen und später mit Änderungen neu
paketieren wollen. Zum Beispiel können Sie mit unserem [Hello
world!](https://exchange.checkmk.com/p/hello-world){target="_blank"}
Beispiel, welches nichts sinnvolles tut, aber als Vorlage für das erste
eigene Paket dienen kann, loslegen.
:::
:::::

::::::: sect3
#### []{#release_mkp_cli .hidden-anchor .sr-only}Kommandozeile {#heading_release_mkp_cli}

::: paragraph
Auf der Kommandozeile lösen Sie ein Paket mit `mkp release` auf. Das
aufzulösende Paket muss hierfür den Zustand [Enabled (active on this
site)]{.guihint} haben. Dabei bleiben die Erweiterungsdateien erhalten
und nur die Paketbeschreibung wird gelöscht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp release hello_world
```
:::
::::

::: paragraph
Das ursprüngliche Paket bleibt hierbei erhalten und wechselt den Zustand
auf [Enabled (inactive on this site)]{.guihint}. Es kann so auch als
Backup für den Fall dienen, dass bei der Anpassung etwas schiefgeht.
Löschen Sie dann einfach die \"entlassenen\" Dateien, aktivieren Sie das
Paket erneut und beginnen Sie von vorn.
:::
:::::::
:::::::::::

::::::::::::: sect2
### []{#find_unpackaged .hidden-anchor .sr-only}4.3. Unpaketierte Dateien finden {#heading_find_unpackaged}

::::::: sect3
#### []{#find_unpackaged_gui .hidden-anchor .sr-only}Setup-Menü {#heading_find_unpackaged_gui}

::: paragraph
Sind die Programmier- oder Anpassungsarbeiten abgeschlossen, gilt es,
die vorhandenen und hinzugefügten Dateien wieder zu finden. Da diese
Dateien momentan zu keinem Paket gehören, werden sie im Setup unter
[Unpackaged files]{.guihint} aufgelistet:
:::

::::: imageblock
::: content
![mkps unpackaged](../images/mkps_unpackaged.png)
:::

::: title
Liste der [Unpackaged files]{.guihint} und der Knopf [Create
package]{.guihint}
:::
:::::
:::::::

::::::: sect3
#### []{#find_unpackaged_cli .hidden-anchor .sr-only}Kommandozeile {#heading_find_unpackaged_cli}

::: paragraph
Das Äquivalent auf der Kommandozeile ist `mkp find`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp find
File                                                    Package Version Part                                         Mode
------------------------------------------------------- ------- ------- -------------------------------------------- ----------
hello_world/rulesets/ruleset_hello_world_bakery.py                      Additional Checkmk plug-ins by third parties -rw-------
hello_world/agent_based/hello_world.py                                  Additional Checkmk plug-ins by third parties -rw-------
hello_world/checkman/hello_world                                        Additional Checkmk plug-ins by third parties -rw-------
hello_world/rulesets/ruleset_hello_world.py                             Additional Checkmk plug-ins by third parties -rw-------
hello_world/graphing/helloworld_perfometer_graphing.py                  Additional Checkmk plug-ins by third parties -rw-------
plugins/hello_world                                                     Agents                                       -rwx------
windows/plugins/hello_world.cmd                                         Agents                                       -rwx------
python3/cmk/base/cee/plugins/bakery/hello_world.py                      Libraries                                    -rw-------
```
:::
::::

::: paragraph
Löschen Sie nicht benötigte Dateien, beziehungsweise notieren Sie,
welche noch nicht mit ins Paket gepackt werden sollen. Im nächsten
Schritt werden die unpaketierten Dateien dann (wieder) zu einem Paket
zusammengefasst.
:::
:::::::
:::::::::::::

:::::::::::::::::::::::::: sect2
### []{#package_mkp .hidden-anchor .sr-only}4.4. Pakete erstellen {#heading_package_mkp}

::::::::: sect3
#### []{#package_mkp_gui .hidden-anchor .sr-only}Setup-Menü {#heading_package_mkp_gui}

::: paragraph
Über den Knopf [![icon new
mkp](../images/icons/icon_new_mkp.png)]{.image-inline} [Create
package]{.guihint} in der Übersicht der unpaketierten Dateien gelangen
Sie zum Dialog zum Erstellen eines neuen Pakets:
:::

:::: imageblock
::: content
![mkps create](../images/mkps_create.png)
:::
::::

::: paragraph
Neben den offensichtlichen Angaben ist es wichtig, dass Sie mindestens
eine Datei auswählen, die eingepackt werden soll. Durch das Erstellen
wird eine Paketbeschreibung unter `~/var/check_mk/packages/` angelegt,
welche neben den allgemeinen Angaben auch die Liste der enthaltenen
Dateien beinhaltet. Die maximal unterstützte Checkmk-Version ist
natürlich ohne Glaskugel schwer vorherzusagen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Erweiterungen, welche die neuen,  |
|                                   | in Checkmk [2.3.0]{.new}          |
|                                   | eingeführten APIs nutzen, sind    |
|                                   | zukunftssicher und werden auch    |
|                                   | bis Checkmk [2.5.0]{.new} ohne    |
|                                   | Anpassungen funktionieren. Sie    |
|                                   | können daher für [Valid until     |
|                                   | Checkmk version]{.guihint} 2.5.99 |
|                                   | als maximal unterstützte          |
|                                   | Checkmk-Version eintragen.        |
|                                   | Darüber hinaus kann zum Zeitpunkt |
|                                   | der aktuellen Revision dieses     |
|                                   | Artikels keine Aussage getroffen  |
|                                   | werden. Pakete, welche die in     |
|                                   | Checkmk [2.0.0]{.new}             |
|                                   | eingeführten APIs nutzen, werden  |
|                                   | mit Checkmk [2.4.0]{.new} nicht   |
|                                   | mehr funktionieren. Tragen Sie    |
|                                   | hier 2.3.99 als maximal           |
|                                   | unterstützte Version ein.         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Das neu erstellte Paket können Sie nun in der Paketliste mit dem Symbol
[![icon download](../images/icons/icon_download.png)]{.image-inline} als
MKP-Datei herunterladen, um es z.B. auf ein anderes System zu übertragen
oder auf die Exchange hochzuladen.
:::
:::::::::

:::::::::::::::::: sect3
#### []{#package_mkp_cli .hidden-anchor .sr-only}Kommandozeile {#heading_package_mkp_cli}

::: paragraph
Die Vorgehensweise zum Erstellen von MKPs auf der Kommandozeile ist
analog zum Setup-Menü. Zunächst erzeugen Sie mit `mkp template` eine
Paketkonfiguration, welche (vorerst) all diese Dateien beinhaltet. Geben
Sie als Parameter den gewünschten Namen des neuen Pakets an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp template hello_world_ng
Created 'tmp/check_mk/hello_world_ng.manifest.temp'.
You may now edit it.
Create the package using mkp package tmp/check_mk/hello_world_ng.manifest.temp.
```
:::
::::

::: paragraph
Die Eigenschaften des Pakets editieren Sie nun mit einem Texteditor:
:::

::::: listingblock
::: title
tmp/check_mk/hello_world_ng.manifest.temp
:::

::: content
``` {.pygments .highlight}
{'author': 'Add your name here',
 'description': 'Please add a description here',
 'download_url': 'https://example.com/hello_world_ng/',
 'files': {'agents': ['plugins/hello_world', 'windows/plugins/hello_world.cmd'],
           'cmk_addons_plugins': ['hello_world/agent_based/hello_world.py',
                                  'hello_world/checkman/hello_world',
                                  'hello_world/graphing/helloworld_perfometer_graphing.py',
                                  'hello_world/rulesets/ruleset_hello_world.py',
                                  'hello_world/rulesets/ruleset_hello_world_bakery.py'],
           'lib': ['python3/cmk/base/cee/plugins/bakery/hello_world.py']},
 'name': 'hello_world_ng',
 'title': 'Title of hello_world_ng',
 'version': '1.0.0',
 'version.min_required': '2.3.0p27',
 'version.packaged': 'cmk-mkp-tool 0.2.0',
 'version.usable_until': None}
```
:::
:::::

::: paragraph
Bearbeiten Sie diese Datei nach Ihren Wünschen. Achten Sie dabei auf
korrekte Python-Syntax. Unicode-Zeichenketten (Texte, die
nicht-ASCII-Zeichen wie Umlaute enthalten) müssen mit einem kleinen
vorangestellten `u` gekennzeichnet werden.
:::

::: paragraph
Unter dem Eintrag `files` können Sie Dateien entfernen, welche nicht
paketiert werden sollen. Tragen Sie unter `version.min_required` die
Mindestversion von Checkmk ein, die erforderlich ist, um das Paket zu
verwenden.
:::

::: paragraph
Anschließend können Sie mit `mkp package` eine MKP-Datei erzeugen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkp package tmp/check_mk/hello_world_ng.manifest.temp
Successfully created hello_world_ng 1.0.0
Successfully wrote package file
Removing packaged files before reinstalling...
[hello_world_ng 1.0.0]: Removed file local/share/check_mk/agents/plugins/hello_world
[hello_world_ng 1.0.0]: Removed file local/share/check_mk/agents/windows/plugins/hello_world.cmd
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk_addons/plugins/hello_world/graphing/helloworld_perfometer_graphing.py
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk_addons/plugins/hello_world/agent_based/hello_world.py
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk_addons/plugins/hello_world/rulesets/ruleset_hello_world.py
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk_addons/plugins/hello_world/rulesets/ruleset_hello_world_bakery.py
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk_addons/plugins/hello_world/checkman/hello_world
[hello_world_ng 1.0.0]: Removed file local/lib/python3/cmk/base/cee/plugins/bakery/hello_world.py
[hello_world_ng 1.0.0]: Installing
Successfully installed hello_world_ng 1.0.0
```
:::
::::

::: paragraph
Abgelegt werden Pakete unter `~/var/check_mk/packages_local`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll ~/var/check_mk/packages_local/*.mkp
-rw-rw---- 2 mysite mysite 4197 Mar 15 13:37 hello_world_ng-1.0.0.mkp
```
:::
::::
::::::::::::::::::
::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::: sect1
## []{#_das_mkp_paketformat .hidden-anchor .sr-only}5. Das MKP-Paketformat {#heading__das_mkp_paketformat}

:::::::::::: sectionbody
::: paragraph
Möglicherweise möchten Sie Erweiterungspakete auf einem
Entwicklungsrechner programmieren und packen, um dann das fertige Paket
zum Checkmk-Server zu übertragen und dort zu testen. Das ist recht
einfach möglich, weil das MKP-Format lediglich eine `.tar.gz` Datei ist,
die wiederum `.tar` Dateien und Manifest-Dateien enthält.
:::

::: paragraph
Die Untersuchung der heruntergeladenen `hello_world-0.2.5.mkp` gibt die
erste Stufe der Struktur preis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ tar tvf hello_world-0.2.5.mkp
-rw-r--r-- 0/0            1715 2025-03-07 16:19 info
-rw-r--r-- 0/0            1311 2025-03-07 16:19 info.json
-rw-r--r-- 0/0           10240 2025-03-07 16:19 agents.tar
-rw-r--r-- 0/0           20480 2025-03-07 16:19 cmk_addons_plugins.tar
-rw-r--r-- 0/0           10240 2025-03-07 16:19 lib.tar
```
:::
::::

::: paragraph
Entpacken Sie das Paket in ein temporäres Verzeichnis, können Sie die
Inhalte der enthaltenen Tar-Archive anschauen. Die Pfade sind relativ
zum Verzeichnis, das die jeweiligen Komponenten enthält:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ tar tvf cmk_addons_plugins.tar
-rw------- mysite/mysite 3711 2025-03-07 10:59 hello_world/agent_based/hello_world.py
-rw------- mysite/mysite 1079 2025-03-07 10:59 hello_world/checkman/hello_world
-rw------- mysite/mysite 1179 2025-03-07 10:59 hello_world/graphing/helloworld_perfometer_graphing.py
-rw------- mysite/mysite 3373 2025-03-07 10:59 hello_world/rulesets/ruleset_hello_world.py
-rw------- mysite/mysite 2634 2025-03-07 10:59 hello_world/rulesets/ruleset_hello_world_bakery.py
```
:::
::::

::: paragraph
Und was ist mit den beiden Manifest-Dateien `info` und `info.json`? Die
Datei `info` und Ihre im Python-Dict-Format enthaltenen Felder haben Sie
weiter [oben](#package_mkp_cli) kennengelernt. Das JSON-Äquivalent
`info.json` enthält exakt die gleichen Felder und Werte, wurde aber im
JSON-Format serialisiert. Falls Sie den Paketbau in einem Skript
durchführen wollen, sollten Sie die Python-Dict-Datei `info` einlesen
und vor dem Packen daraus die JSON-Datei `info.json` generieren.
:::

::: paragraph
Wenn Sie die Archive neu packen, achten Sie darauf, keine Pfade
miteinzupacken, die nicht Teil der Ordnerhierarchie unter `~/local`
sind. Auf der obersten Ebene dürfen nur die oben zu sehenden Manifeste
und Tar-Dateien enthalten sein.
:::
::::::::::::
:::::::::::::

::::::: sect1
## []{#command_reference .hidden-anchor .sr-only}6. Befehlsreferenz {#heading_command_reference}

:::::: sectionbody
::: sect2
### []{#_verwaltung .hidden-anchor .sr-only}6.1. Verwaltung {#heading__verwaltung}

+---------+-----------------------------+-----------------------------+
| Subk    | Parameter                   | Verwendungszweck            |
| ommando |                             |                             |
+=========+=============================+=============================+
| `add`   | Dateiname des               | Macht ein Paket verfügbar,  |
|         | hinzuzufügenden Pakets      | aktiviert es aber noch      |
|         |                             | nicht.                      |
+---------+-----------------------------+-----------------------------+
| `       | Name des Pakets (und ggf.   | Aktiviert ein Paket je nach |
| enable` | Versionsnummer)             | Versionskompatibilität für  |
|         |                             | lokale Verwendung oder      |
|         |                             | Verteilung an               |
|         |                             | Remote-Instanzen.           |
+---------+-----------------------------+-----------------------------+
| `d      | Name des Pakets und         | Deaktiviert ein Paket, das  |
| isable` | Versionsnummer              | im Dateisystem verfügbar    |
|         |                             | bleibt.                     |
+---------+-----------------------------+-----------------------------+
| `       | Name des Pakets und         | Entfernt ein zuvor          |
| remove` | Versionsnummer              | deaktiviertes Paket         |
|         |                             | vollständig.                |
+---------+-----------------------------+-----------------------------+
| `i      | Dateiname des               | Dieses Subkommando ist      |
| nstall` | hinzuzufügenden Pakets      | abgekündigt und wird bald   |
|         |                             | entfernt werden!            |
+---------+-----------------------------+-----------------------------+
| `list`  | *keine*                     | Listet alle verfügbaren     |
|         |                             | Pakete und deren            |
|         |                             | Aktivierungszustand auf.    |
+---------+-----------------------------+-----------------------------+
| `i      | Dateiname des zu            | Zeigt Informationen zu      |
| nspect` | untersuchenden Pakets       | einem nicht installierten   |
|         |                             | MKP.                        |
+---------+-----------------------------+-----------------------------+
| `show`  | Name des Pakets (und ggf.   | Zeigt Informationen zu      |
|         | Versionsnummer)             | einem verfügbaren MKP.      |
+---------+-----------------------------+-----------------------------+
| `sh     | *keine*                     | Zeigt Informationen zu      |
| ow-all` |                             | allen verfügbaren MKPs.     |
+---------+-----------------------------+-----------------------------+
| `files` | Name des Pakets (und ggf.   | Listet alle zu einem Paket  |
|         | Versionsnummer)             | gehörenden Dateien auf.     |
+---------+-----------------------------+-----------------------------+
:::

::: sect2
### []{#_entwicklung .hidden-anchor .sr-only}6.2. Entwicklung {#heading__entwicklung}

+---------+-----------------------------+-----------------------------+
| Subk    | Parameter                   | Verwendungszweck            |
| ommando |                             |                             |
+=========+=============================+=============================+
| `r      | Name des Pakets             | Löst ein aktives Paket auf. |
| elease` |                             |                             |
+---------+-----------------------------+-----------------------------+
| `find`  | *keine*                     | Listet alle zu keinem Paket |
|         |                             | gehörenden Dateien auf.     |
+---------+-----------------------------+-----------------------------+
| `te     | Name des neu zu             | Erstellt eine               |
| mplate` | erstellenden Pakets         | Manifest-Datei als Basis    |
|         |                             | für ein neues Paket.        |
+---------+-----------------------------+-----------------------------+
| `p      | Pfad zur Manifest-Datei     | Erstellt auf Basis des      |
| ackage` |                             | Inhalts einer               |
|         |                             | Manifest-Datei ein MKP.     |
+---------+-----------------------------+-----------------------------+
:::

::: sect2
### []{#_updates .hidden-anchor .sr-only}6.3. Updates {#heading__updates}

+---------+-----------------------------+-----------------------------+
| Subk    | Parameter                   | Verwendungszweck            |
| ommando |                             |                             |
+=========+=============================+=============================+
| `dis    | *keine*                     | Deaktiviert nach einem      |
| able-ou |                             | Update nicht mehr zur       |
| tdated` |                             | Checkmk-Version passende    |
|         |                             | Pakete.                     |
+---------+-----------------------------+-----------------------------+
| `       | *keine*                     | Aktiviert nach einem Update |
| update- |                             | die zur Checkmk-Version     |
| active` |                             | passenden Pakete.           |
+---------+-----------------------------+-----------------------------+
:::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
