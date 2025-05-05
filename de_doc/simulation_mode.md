:::: {#header}
# Der Simulationsmodus

::: details
[Last modified on 02-Oct-2017]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/simulation_mode.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::: {#content}
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
[Instanzen (Sites) mit omd verwalten](omd_basics.html) [Services
verstehen und konfigurieren](wato_services.html)
[Kommandos](commands.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_grundlegendes .hidden-anchor .sr-only}1. Grundlegendes {#heading__grundlegendes}

:::::::: sectionbody
::: paragraph
Mit dem Simulationsmodus können Sie die generelle Funktionalität von
Checkmk testen, ohne dass dabei Monitoring-Agenten auf Ziel-Hosts
kontaktiert werden. Das kann z.B. von Vorteil sein, wenn Sie die
[Kopie](omd_basics.html#omd_cp_mv) einer Instanz [updaten](update.html)
und starten möchten, um eine neue Version von Checkmk zu evaluieren.
Konkret gelten in diesem Modus dann die folgenden Bedingungen:
:::

::: ulist
- Alle Service-Daten werden --- sofern vorhanden --- aus
  [zwischengespeicherten Dateien](#files) bezogen und *keine einzige*
  Host-Anfrage geht über das Netzwerk. Ein Betrieb einer einzelnen
  Instanz ist somit sogar komplett ohne Netzwerkzugriff möglich. Sollte
  keine Cache-Datei für einen Host zur Verfügung stehen, gehen die
  betroffenen Services in den Status [UNKNOWN]{.state3}.

- Alle aktiven Netzwerkanfragen (Ping, HTTP, etc.) werden auf
  `127.0.0.1` „umgebogen". Es werden also **alle** Hosts als
  [UP]{.hstate0} betrachtet, sofern deren Status über Ping oder Smart
  Ping festgestellt wird. HTTP-Checks versuchen, den Monitoring-Server
  selbst zu kontaktieren --- was natürlich zu unterschiedlichen
  Resultaten führen kann.
:::

::: paragraph
Alle anderen Dinge in der Instanz laufen ganz normal weiter:
:::

::: ulist
- [Benachrichtigungen](glossar.html#notification) finden weiterhin
  statt! Schalten Sie am besten in Ihrer Testinstanz die
  Benachrichtigungen aus oder ändern Sie die Regeln so, dass nur Sie
  selbst alle Benachrichtigungen erhalten.

- Benachrichtigungen und SNMP-Traps in der Event Console werden weiter
  verarbeitet.

- Konfigurierte Backup-Aufträge werden zu ihrem definierten Zeitpunkt
  ausgeführt.

- Hosts und Services auf anderen Instanzen werden in einer verteilten
  Umgebung weiterhin normal geprüft. Nur in einem verteilten Setup wird
  der Simulationsmodus an die anderen Remote-Instanzen weitergereicht.

- Metriken bleiben auf dem letzten Wert stehen, werden aber auch
  weitergeschrieben.
:::

::: paragraph
Da im Simulationsmodus nur noch bereits vorhandene Daten benutzt werden,
werden sich die Check-Resultate nicht mehr ändern. Services, die also
Metriken zu ihrer Funktion benötigen, werden
[stale.](monitoring_basics.html#stale)
:::
::::::::
:::::::::

::::::::::::::::: sect1
## []{#_aktivierung .hidden-anchor .sr-only}2. Aktivierung {#heading__aktivierung}

:::::::::::::::: sectionbody
::: paragraph
Sie haben zwei Möglichkeiten, den Simulationsmodus zu einzurichten. Zum
einen ist es möglich den Modus direkt im Setup anzuschalten. Sie finden
die Option über [Setup \> General \> Global settings \> Execution of
checks \> Simulation mode]{.guihint}:
:::

:::: imageblock
::: content
![omd basics simulation](../images/omd_basics_simulation.png)
:::
::::

::: paragraph
Zum anderen können Sie den Simulationsmodus auch direkt in der
Konfigurationsdatei aktivieren. Das ist sinnvoll, wenn Sie eine Kopie
erstellt haben, und den Modus aktiveren wollen, bevor Sie die Instanz
starten. In diesem Fall fügen Sie in der kopierten Instanz manuell in
der Datei `global.mk` die entsprechende Zeile hinzu:
:::

::::: listingblock
::: title
\~/etc/check_mk/conf.d/wato/global.mk
:::

::: content
``` {.pygments .highlight}
simulation_mode = True
```
:::
:::::

::: paragraph
Achten Sie darauf, dass das `True` groß geschrieben ist. Um die Änderung
wirksam zu machen, erzeugen Sie dann noch die Konfiguration für den
Monitoring-Kern neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -U
Generating configuration for core (type cmc)...
Starting full compilation for all hosts Creating global helper config...OK
 Creating cmc protobuf configuration...OK
```
:::
::::

::: paragraph
Die Instanz kann nun gestartet werden, ohne dass echte Daten von den
Hosts geholt werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
Creating temporary filesystem /omd/sites/mysite/tmp...OK
Starting agent-receiver...OK
Starting mkeventd...OK
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
::::::::::::::::
:::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}3. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~/etc/check_             | Hier wird unter anderem der              |
| mk/conf.d/wato/global.mk` | Simulationsmodus aktiviert. Ist der Wert |
|                           | `simulation_mode` in dieser Datei nicht  |
|                           | gesetzt, wird der Standardwert (off)     |
|                           | benutzt.                                 |
+---------------------------+------------------------------------------+
| `~/tmp/check_mk/cache/`   | Hier befinden sich die                   |
|                           | zwischengespeicherten Agentendaten. Das  |
|                           | Verzeichnis ist leer, wenn noch nie      |
|                           | Agentendaten geholt wurden. Da sich      |
|                           | zudem alle Dateien unterhalb von         |
|                           | `~/tmp/` in einer RAM-Disk befinden,     |
|                           | wird das Verzeichnis nach einem Neustart |
|                           | ebenfalls leer sein.                     |
+---------------------------+------------------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::
