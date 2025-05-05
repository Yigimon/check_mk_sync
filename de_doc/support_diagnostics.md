:::: {#header}
# Support Diagnostics

::: details
[Last modified on 12-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/support_diagnostics.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::: sectionbody
::: paragraph
Sollten Sie in Checkmk mal mit Problemen konfrontiert sein, die Sie
nicht selbsttätig --- unter Zuhilfenahme dieses Handbuchs --- lösen
können, so bieten sich Ihnen mit dem offiziellen
[Checkmk-Support](https://checkmk.com/de/produkt/support){target="_blank"}
und dem [Checkmk-Forum](https://forum.checkmk.com/){target="_blank"}
zwei exzellente Anlaufstellen. In beiden Fällen ist eine möglichst
präzise Beschreibung des Fehlers oder der Problemstellung äußerst
hilfreich. Zudem sind bestimmte Informationen zu Ihrer Checkmk-Umgebung
für eine schnelle Analyse und Lösung zwingend erforderlich. Die
grundlegendsten Informationen stellen hierbei sicherlich die von Ihnen
eingesetzte [Version](cmk_versions.html) und
[Edition](cmk_versions.html#suffix) von Checkmk dar. Je nach Situation
können jedoch wesentlich mehr Informationen erforderlich sein, um Ihrem
Problem auf die Schliche zu kommen. In der Vergangenheit hat Ihnen der
Checkmk-Support gesagt, welche Informationen Sie ihm zur Verfügung
stellen müssen.
:::

::: paragraph
Seit Version [2.0.0]{.new} kann das Leben nun viel einfacher sein, da
Sie ein in Checkmk integriertes Werkzeug haben, das die benötigten
Informationen generiert --- die *Support Diagnostics*. Statt dass der
Support Ihnen, wie oben erwähnt, eine \"Wunschliste\" vorlegt und Sie
damit auf eine Schnitzeljagd durch die unterschiedlichen Bereiche von
Checkmk schickt, können Sie mit nur wenigen Klicks in der grafischen
Oberfläche ein maßgeschneidertes Päckchen mit Informationen
zusammenstellen --- in diesem Artikel *Dump* genannt. Hier entscheiden
Sie selbst, ob Sie Konfigurationsdateien einschließen wollen, die
möglicherweise vertrauliche Informationen enthalten --- oder nicht, und
wenn ja, welche.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Einige der
auswählbaren Daten sind nur in den kommerziellen Editionen verfügbar,
etwa [Performance Graphs of Checkmk Server]{.guihint}, [CMC (Checkmk
Microcore)]{.guihint} und [Licensing information.]{.guihint}
:::
::::::
:::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#compile .hidden-anchor .sr-only}2. Support-Informationen zusammenstellen {#heading_compile}

:::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_instanz_auswählen .hidden-anchor .sr-only}2.1. Instanz auswählen {#heading__instanz_auswählen}

::: paragraph
Nach Klick auf [Setup \> Maintenance \> Support diagnostics]{.guihint}
bietet sich Ihnen folgendes aufgeräumtes Bild:
:::

:::: imageblock
::: content
![Optionen der Support Diagnostics.](../images/support_diagnostics.png)
:::
::::

::: paragraph
Falls Sie ein verteiltes Monitoring einsetzen, können Sie im ersten Feld
die Instanz ([Site]{.guihint}) auswählen, von welcher Sie die im
Folgenden auszuwählenden Daten sammeln wollen.
:::
:::::::

:::::::: sect2
### []{#_general_information .hidden-anchor .sr-only}2.2. General information {#heading__general_information}

::: paragraph
Unter [General information]{.guihint} finden Sie im Grunde nur einen
Hinweis darauf, dass die Informationen zur Checkmk-Version und dem
genutzten Betriebssystem in jedem Fall aufgenommen werden. Wenn Sie es
dabei belassen --- also keine der weiteren Optionen auswählen --- und
über [Collect diagnostics]{.guihint} die Sammlung der Daten starten,
erhalten Sie eine Datei, die nur die folgenden Daten enthält:
:::

::::: listingblock
::: title
general.json
:::

::: content
``` {.pygments .highlight}
{
    "arch": "x86_64",
    "core": "cmc",
    "edition": "cee",
    "os": "Ubuntu 22.04.2 LTS",
    "python_paths": [
        "/opt/omd/versions/2.2.0p1.cee/bin",
        "/omd/sites/mysite/local/lib/python3",
        ...
        "/omd/sites/mysite/lib/python3"
    ],
    "python_version": "3.11.2 (main, Mar 14 2023, 20:27:12) [GCC 12.2.0]",
    "time": 1681821714.8444054,
    "time_human_readable": "2023-04-18 14:41:54.844405",
    "version": "2.2.0p1"
}
```
:::
:::::

::: paragraph
Zusätzlich zur Datei `general.json` generiert Checkmk in dieser
Standardeinstellung noch weitere Dateien unter anderem mit
Performance-Daten wie der Anzahl von Hosts und Services, zur Hardware
des Checkmk-Servers, den in der Instanz gesetzten Umgebungsvariablen, zu
Namen und Größen der Dateien in der Instanz sowie den dort installierten
Python-Modulen mit ihren Versionen. Welche Daten genau zusammengestellt
werden, zeigt die Seite [Background job details]{.guihint}, die geöffnet
wird, nachdem Sie [Collect diagnostics]{.guihint} angeklickt haben.
:::
::::::::

::::::::::::::::: sect2
### []{#_optional_general_information .hidden-anchor .sr-only}2.3. Optional general information {#heading__optional_general_information}

::: paragraph
Unter [Optional general information]{.guihint} finden Sie dann
Auswahlmöglichkeiten, die Sie schon im Vorfeld zu Ihrer Fragestellung
passend zusammenstellen können oder die ggf. im Support explizit
angefragt werden.
:::

::: paragraph
Wählen Sie hier [Local Files and MKPs]{.guihint}, erstellt Checkmk
zusätzlich eine Übersicht aller Dateien, die im Verzeichnis `~/local/`
Ihrer Instanz liegen. Dies kann mitunter hilfreich sein, wenn Ihre
lokalen Anpassungen zu einem kürzlich durchgeführten Update von Checkmk
inkompatibel sind. Auch alle installierten [MKPs](glossar.html#mkp)
werden hier mit erfasst.
:::

::: paragraph
Mit der Auswahl von [OMD Config]{.guihint} können Sie dem Dump die
Informationen über Ihre Konfiguration von OMD beifügen. Diese
entsprechen genau dem, was Sie sich auf der Kommandozeile mit dem Befehl
`omd config show` ausgeben lassen können.
:::

::::: listingblock
::: title
omd_config.json
:::

::: content
``` {.pygments .highlight}
{
    "CONFIG_ADMIN_MAIL": "",
    "CONFIG_AGENT_RECEIVER": "on",
    "CONFIG_AGENT_RECEIVER_PORT": "8000",
    "CONFIG_APACHE_MODE": "own",
    "CONFIG_APACHE_TCP_ADDR": "127.0.0.1",
    "CONFIG_APACHE_TCP_PORT": "5000",
    "CONFIG_AUTOSTART": "off",
    "CONFIG_CORE": "cmc",
    "CONFIG_LIVEPROXYD": "on",
    "CONFIG_LIVESTATUS_TCP": "off",
    "CONFIG_LIVESTATUS_TCP_ONLY_FROM": "0.0.0.0 ::/0",
    "CONFIG_LIVESTATUS_TCP_PORT": "6557",
    "CONFIG_LIVESTATUS_TCP_TLS": "on",
    "CONFIG_MKEVENTD": "on",
    "CONFIG_MKEVENTD_SNMPTRAP": "off",
    "CONFIG_MKEVENTD_SYSLOG": "on",
    "CONFIG_MKEVENTD_SYSLOG_TCP": "off",
    "CONFIG_MULTISITE_AUTHORISATION": "on",
    "CONFIG_MULTISITE_COOKIE_AUTH": "on",
    "CONFIG_PNP4NAGIOS": "on",
    "CONFIG_TMPFS": "on"
}
```
:::
:::::

::: paragraph
Aktivieren Sie die Checkbox [Checkmk Overview]{.guihint} werden
generelle Informationen zu **allen** auf Ihrem Checkmk-Server laufenden
Instanzen gesammelt. Außerdem wird eine Aufstellung aller installierten
Checkmk-Versionen angelegt. Und falls es sich bei der oben ausgewählten
Instanz um den Knoten eines Clusters handelt, wird dieser Umstand
ebenfalls hier festgehalten.
:::

::: paragraph
Mit der Option [Crash Reports]{.guihint} können Sie aus den
verschiedenen Kategorien der Absturzberichte --- z.B. `base`, `check`,
`gui` oder `rest_api` --- den jeweils letzten dem Dump hinzufügen
lassen. Weitere Informationen zu Absturzberichten finden Sie im Artikel
zur Programmierung von [agentenbasierten
Check-Plugins.](devel_check_plugins.html#error_exception_gui) In Checkmk
finden Sie die Absturzberichte unter [Monitor \> System \> Crash
reports.]{.guihint}
:::

::: paragraph
Nach der Aktivierung einer der Optionen [Checkmk Log files]{.guihint}
oder [Checkmk Configuration files]{.guihint} haben Sie die Möglichkeit,
mehr oder weniger vertrauliche Daten aus dem jeweiligen Teil des Pakets
zu entfernen --- über die Auswahl des Listeneintrags [Pack only Low
sensitivity files.]{.guihint} Alle Dateien, die Sie hier auswählen
können, stammen aus den Verzeichnissen `~/var/log/` bzw.
`~/etc/checkmk/` und ihren Unterverzeichnissen. Eine genaue Auflistung
sehen Sie direkt unter dem jeweiligen Drop-down-Menü. Mit der Option
[Select individual files from list]{.guihint} haben Sie gar die
Möglichkeit, nur bestimmte Dateien mit in den Dump zu packen.
:::

::: paragraph
Bei dieser Option sehen Sie auch, welche Dateien welche
Vertraulichkeitsstufe haben; also Hoch/High (H) für Dateien mit zum
Beispiel Passwörtern, Mittel/Middle (M), wenn sie etwa Adressen oder
Benutzernamen beinhalten, oder letztlich Niedrig/Low (L).
:::

:::: imageblock
::: content
![Liste der auswählbaren
Dateien.](../images/support_diagnostics_sensitivity_levels.png)
:::
::::

::: paragraph
**Hinweis:** Um in den Log-Dateien möglichst viele detaillierte
Informationen über das Verhalten von Checkmk finden zu können, kann es
mitunter notwendig sein, das sogenannte Log-Level in Checkmk kurzzeitig
zu erhöhen. Die entsprechenden Einstellungen finden Sie über [Setup \>
General \> Global settings.]{.guihint} Geben Sie auf dieser Seite am
einfachsten `logging` in das Feld [Filter]{.guihint} ein und setzen Sie
dann beispielsweise das Log-Level für den [Core]{.guihint} auf
[Debug.]{.guihint} Wenn Sie die Instanz jetzt einfach einige Minuten
weiter laufen lassen oder einen reproduzierbaren Fehler wiederholen,
steigt so die Chance, dass sich dazu auch Informationen in den
Log-Dateien verfangen.
:::

::: paragraph
Als Nächstes haben Sie die Möglichkeit, [Performance Graphs of Checkmk
Server]{.guihint} mit einzupacken. Gerade bei Problemen mit der
Performance einer Checkmk-Instanz werden diese Berichte fast immer
angefragt. Es bietet sich also an, diese bei einem Performance-Problem
einfach gleich mitzuschicken. Die Support Diagnostics nehmen Ihnen hier
die Arbeit ab, eine ganze Reihe von Berichten manuell als PDF-Dateien zu
erzeugen. Unter anderem werden hier die Berichte des Services [OMD
mysite performance]{.guihint} über die letzten 25 Stunden und die
letzten 35 Tage generiert.
:::
:::::::::::::::::

::::::::::: sect2
### []{#_component_specific_information .hidden-anchor .sr-only}2.4. Component specific information {#heading__component_specific_information}

::: paragraph
Über die Sektion [Component specific information]{.guihint} können Sie
erneut sehr granular darüber entscheiden, welche Informationen aus Ihren
globalen Checkmk-Einstellungen, Ihren Hosts und Ordnern sowie Ihren
Einstellungen bezüglich Benachrichtigungen mit in den Dump gepackt
werden sollen.
:::

::: paragraph
**Wichtig:** In den Dateien, die Sie hier auswählen, können je nach
Konfiguration streng vertrauliche Informationen, wie beispielsweise
Passwörter, enthalten sein. Im Regelbetrieb sind diese Daten dadurch
geschützt, dass nur der Instanzbenutzer und Administratoren Zugriff
darauf haben. Wenn Sie diese Daten zu Diagnose- und Analysezwecken
Dritten zur Verfügung stellen, sollten Sie mit großer Vorsicht vorgehen.
:::

::: paragraph
Im Unterpunkt [Global Settings]{.guihint} stehen Ihnen alle
`global.mk`-Dateien der einzelnen Komponenten Ihrer Checkmk-Instanz, wie
beispielsweise des Dynamic-Configuration-Daemons oder auch des
Livestatus-Proxy-Daemons, zur Auswahl.
:::

::: paragraph
Die Informationen, die sich über den Unterpunkt [Hosts and
Folders]{.guihint} auswählen lassen, können unter anderem dabei helfen,
ungünstige Regelwerke und Fehler in der Host-Konfiguration zu finden.
:::

::: paragraph
Im Abschnitt [Notifications]{.guihint} finden Sie neben den
entsprechenden Konfigurationsdateien noch eine Auswahl für diverse
Log-Dateien. Bei Schwierigkeiten mit Ihren Benachrichtigungen können Sie
oder in letzter Instanz der Checkmk-Support in diesen Logs häufig die
Ursache entdecken.
:::

:::: imageblock
::: content
![Auswahl der Dateien für die
Benachrichtigungen.](../images/support_diagnostics_components.png)
:::
::::

::: paragraph
Mit der Option [Business Intelligence]{.guihint} wählen Sie
Konfigurationsdateien der [Business Intelligence](glossar.html#bi) aus.
Nach der Aktivierung der Optionen [CMC (Checkmk Microcore)]{.guihint}
oder [Licensing information]{.guihint} haben Sie wieder die Möglichkeit,
mehr oder weniger vertrauliche Daten aus dem jeweiligen Teil des Pakets
zu entfernen --- über die Vorgaben [Pack only Medium and Low sensitivity
files]{.guihint} oder [Pack only Low sensitivity files]{.guihint}.
:::
:::::::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::

::::::::: sect1
## []{#commandline .hidden-anchor .sr-only}3. Support Diagnostics über die Kommandozeile {#heading_commandline}

:::::::: sectionbody
::: paragraph
Wie so oft in Checkmk, lässt sich auch diese Aufgabe gut über ein
Terminal erledigen. Mit dem Befehl `cmk` und der Option
`--create-diagnostics-dump` geht das ganz leicht von der Hand. Für alle
oben beschriebenen Wahlmöglichkeiten können Sie jeweils den zugehörigen
Parameter an den Befehl anhängen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --create-diagnostics-dump --local-files --omd-config --performance-graphs
```
:::
::::

::: paragraph
Folgende Optionen ergänzen die Ausgabe des Befehls:
:::

+--------------------+-------------------------------------------------+
| `--local-files`    | Liste aller installierter, unpaketierter und    |
|                    | optionaler Dateien unterhalb von `~/local/`.    |
|                    | Dies beinhaltet auch Informationen über         |
|                    | installierte MKPs.                              |
+--------------------+-------------------------------------------------+
| `--omd-config`     | Inhalt der Datei `~/etc/omd/site.conf`.         |
+--------------------+-------------------------------------------------+
| `-                 | Informationen aus [HW/SW Inventory-Knoten       |
| -checkmk-overview` | Software \> Applications \> Checkmk]{.guihint}  |
|                    | der Checkmk-Server.                             |
+--------------------+-------------------------------------------------+
| `--checkmk-config- | Alle .mk- und .conf-Dateien aus dem Verzeichnis |
| files FILE,FILE …​` | `~/etc/check_mk`.                               |
+--------------------+-------------------------------------------------+
| `--checkmk-log-    | Alle Log-Dateien (.log und .state) aus          |
| files FILE,FILE …​` | `~/var/log`.                                    |
+--------------------+-------------------------------------------------+
| `--p               | Performance-Graphen (bspw. CPU load, CPU        |
| erformance-graphs` | utilization) des Checkmk-Servers --- nur        |
|                    | verfügbar in den kommerziellen Editionen.       |
+--------------------+-------------------------------------------------+

::: paragraph
Diese und alle weiteren Optionen des `cmk`-Befehls finden Sie wie
gewohnt in der Ausgabe von `cmk --help`.
:::
::::::::
:::::::::

:::::::: sect1
## []{#missing_information .hidden-anchor .sr-only}4. Fehlende Informationen im Dump {#heading_missing_information}

::::::: sectionbody
:::: sect2
### []{#_aktueller_agent_benötigt .hidden-anchor .sr-only}4.1. Aktueller Agent benötigt {#heading__aktueller_agent_benötigt}

::: paragraph
Um gewisse Informationen in den Support Diagnostics ausgeben zu können,
müssen Sie sicherstellen, dass auf den Checkmk-Servern mindestens der
Agent mit der Versionsnummer [2.0.0]{.new} installiert ist. Im
Besonderen die Informationen, die aus der HW-/SW-Inventur des
Checkmk-Servers stammen, wurden in älteren Versionen des Agenten noch
gar nicht bereitgestellt.
:::
::::

:::: sect2
### []{#_label_cmkcheck_mk_serveryes .hidden-anchor .sr-only}4.2. Label cmk/check_mk_server:yes {#heading__label_cmkcheck_mk_serveryes}

::: paragraph
Die Support Diagnostics sind darauf angewiesen, dass die Checkmk-Server
in Ihrer Umgebung das entsprechende Label tragen. Sollten Sie in einem
erstellten Dump gewisse Daten vermissen, prüfen Sie, ob Ihre
Checkmk-Server über das Label `cmk/check_mk_server:yes` verfügen.
:::
::::
:::::::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
