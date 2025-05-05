:::: {#header}
# Der Checkmk Micro Core (CMC)

::: details
[Last modified on 10-Mar-2016]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/cmc.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Besonderheiten des CMC](cmc_differences.html) [Migration auf den
CMC](cmc_migration.html) [Dateien und Verzeichnisse des
CMC](cmc_files.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::: sect1
## []{#_der_monitoring_kern .hidden-anchor .sr-only}1. Der Monitoring-Kern {#heading__der_monitoring_kern}

::::::::::::: sectionbody
::: paragraph
An zentraler Stelle im Checkmk-System arbeitet der Monitoring-Kern.
Seine Aufgaben sind
:::

::: ulist
- das regelmäßige Anstoßen von Checks und Sammeln der Ergebnisse,

- das Bereitstellen des aktuellen Zustands für die GUI und

- das Erkennen von Zustandsänderungen und darauf basierend das
  [Benachrichtigen.](notifications.html)
:::

::: paragraph
Folgendes Architekturbild zeigt den Kern im Zusammenhang mit den
wichtigsten Komponenten der kommerziellen Editionen:
:::

:::: {#architecture .imageblock}
::: content
![cmc cee architecture](../images/cmc_cee_architecture.png)
:::
::::

::::::: sect2
### []{#_nagios_und_icinga .hidden-anchor .sr-only}1.1. Nagios und Icinga {#heading__nagios_und_icinga}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline}
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** baut auf dem Kern aus dem bekannten Open-Source-Projekt
*Nagios* auf. Dieser hat sich weltweit bei Millionen von Benutzern über
Jahre hinweg bewährt und bietet zahlreiche nützliche Funktionen. Seine
Flexibilität ist einer der Gründe für den Erfolg von Nagios.
:::

::: paragraph
Alternativ kann auch der Kern von *Icinga* eingesetzt werden. Dieser ist
vor allem in Deutschland verbreitet und basiert auf dem gleichen
Programm-Code, wird aber seit einigen Jahren unabhängig
weiterentwickelt.
:::

::: paragraph
Auch wenn Nagios, bzw. Icinga, hervorragende Dienste leistet, flexibel,
stabil und gut erprobt ist, so gibt es doch Situationen, in denen man
damit an Grenzen stößt. Bei einer größeren Zahl von überwachten Hosts
und Services treten vor allem drei Probleme auf:
:::

::: ulist
- Die hohe CPU-Last beim Ausführen von Checks.

- Die lange Dauer eines Neustarts nach einer Konfigurationsänderung.

- Die Tatsache, dass das System während dieser Zeit nicht verfügbar ist.
:::
:::::::
:::::::::::::
::::::::::::::

::::::::::::::::::::::::: sect1
## []{#_der_checkmk_micro_core_cmc .hidden-anchor .sr-only}2. Der Checkmk Micro Core (CMC) {#heading__der_checkmk_micro_core_cmc}

:::::::::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Da Checkmk in
immer größeren Umgebungen eingesetzt wird und um die oben genannten
Limitierungen von Nagios zu überwinden, haben wir im Jahr 2013 mit der
Neuentwicklung eines eigenen Kerns speziell für die kommerziellen
Editionen begonnen. Der *Checkmk Micro Core* --- kurz *CMC* ist dabei
nicht als Fork von Nagios entstanden, sondern hat eine komplett eigene
Codebasis. Er verfügt über eine einzigartige und perfekt auf Checkmk
zugeschnittene Softwarearchitektur.
:::

::: paragraph
Seine wichtigsten Vorteile sind:
:::

::: ulist
- **Hohe Effizienz beim Ausführen von Checks** - Das betrifft sowohl
  [aktive Checks](active_checks.html) als auch Checkmk-basierte Checks.
  In Benchmarks wurden auf einem Desktop-PC (Core i7) mehr als 600.000
  Checks pro Minute erreicht.

- **Schnelles Aktivieren von Änderungen** - Eine Konfiguration mit
  20.000 Hosts und 600.000 Services kann in 0,5 Sekunden geladen werden.

- **Konfigurationsänderungen im laufenden Betrieb** - Aktuell laufende
  Checks und [Livestatus](livestatus.html)-Verbindungen werden nicht
  unterbrochen. Für die Nutzer des Monitorings ist der Vorgang nicht
  spürbar.

- **Schnelle Verfügbarkeitsabfragen** - Durch einen speziellen Cache
  können Analysen der [Verfügbarkeit](availability.html)
  (*availability*) auch über lange Zeiträume ohne spürbare Wartezeit
  berechnet werden.

- **Zusätzliche Features** - Der CMC verfügt über mehrere nützliche
  Zusatzfunktionen wie z.B. wiederkehrende
  [Wartungszeiten](basics_downtimes.html) und
  [Quittierungen](basics_ackn.html) mit automatischer Ablaufzeit.
:::

::: paragraph
Auch an anderen Stellen wurde optimiert. So werden z.B. Messwerte jetzt
ohne Umwege direkt vom Kern an den RRD-Cache-Daemon übergeben,
Benachrichtigungen in einem „KeepAlive"-Modus erzeugt und Host-Checks
mit einem eingebauten ICMP-Hilfsprozess ausgeführt. Das alles vermeidet
kostspielige Prozesserzeugungen und spart CPU-Ressourcen.
:::

::: paragraph
Diese Eigenschaften bringen zahlreiche Vorteile --- auch in kleineren
Installationen:
:::

::: ulist
- Der geringere Bedarf an Prozessorleistung ermöglicht in vielen Fällen
  Virtualisierung anstelle echter Hardware.

- Das unterbrechungsfreie Aktivieren von Änderungen ermöglicht häufige
  Konfigurationsänderungen.

- Dadurch ist auch die Umsetzung von Anforderungen wie z.B.
  Cloud-Monitoring möglich, bei denen in kurzer Abfolge Server
  hinzugefügt und entfernt werden.
:::

::: paragraph
Die folgenden beiden Grafiken zeigen die CPU-Last auf einem
Checkmk-Server vor und nach der Umstellung von Nagios auf CMC. Diese
wurden uns freundlicherweise von dem Unternehmen DFi Service SA
bereitgestellt. Sie überwachten zu diesem Zeitpunkt 1.205 Hosts und
13.555 Services auf einem Server mit 10 Prozessorkernen.
:::

:::: imageblock
::: content
![cmc migration
cpuload4](../images/cmc-migration-cpuload4.png){width="500"}
:::
::::

:::: imageblock
::: content
![cmc migration
cpuutil4](../images/cmc-migration-cpuutil4.png){width="500"}
:::
::::

::: paragraph
In einem anderen Projekt zeigen sich ähnliche Effekte. Folgende Graphen
zeigen eine Umstellung vom Nagios-Kern auf den CMC in einer Umgebung mit
56.602 Services auf 2.230 überwachten Hosts auf einer virtuellen
Maschine mit zwei Prozessorkernen:
:::

:::: {.imageblock .border}
::: content
![cmc migration
cpuload](../images/cmc-migration-cpuload.png){width="500"}
:::
::::

:::: {.imageblock .border}
::: content
![cmc migration
cpuutil](../images/cmc-migration-cpuutil.png){width="500"}
:::
::::

:::: {.imageblock .border}
::: content
![cmc migration diskio](../images/cmc-migration-diskio.png){width="500"}
:::
::::

::: paragraph
Wie groß der Unterschied im Einzelfall ist, hängt natürlich von vielen
Rahmenbedingungen ab. Im obigen Fall läuft auf dem gleichen Server noch
eine kleinere Instanz, die nicht umgestellt wurde. Ohne diese wäre der
Unterschied in der Last noch deutlicher zu erkennen.
:::

::: paragraph
Weitere Aspekte des CMC werden in den folgenden Artikeln erläutert:
:::

::: ulist
- [Besonderheiten des CMC](cmc_differences.html)

- [Migration auf den CMC](cmc_migration.html)

- [Dateien und Verzeichnisse des CMC](cmc_files.html)
:::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::: sect1
## []{#_häufig_gestellte_fragen_faq .hidden-anchor .sr-only}3. Häufig gestellte Fragen (FAQ) {#heading__häufig_gestellte_fragen_faq}

::::::::::: sectionbody
:::: sect2
### []{#_kann_der_cmc_auch_normale_nagios_plugins_ausführen .hidden-anchor .sr-only}3.1. Kann der CMC auch normale Nagios-Plugins ausführen? {#heading__kann_der_cmc_auch_normale_nagios_plugins_ausführen}

::: paragraph
Selbstverständlich kann der CMC auch klassische aktive und passive
Nagios-Checks ausführen.
:::
::::

:::: sect2
### []{#_wird_checkmk_weiterhin_nagios_unterstützen .hidden-anchor .sr-only}3.2. Wird Checkmk weiterhin Nagios unterstützen? {#heading__wird_checkmk_weiterhin_nagios_unterstützen}

::: paragraph
Checkmk ist und bleibt kompatibel zu Nagios und wird auch den
Nagios-Kern weiterhin voll unterstützen. Auch die kommerziellen
Editionen enthalten Nagios weiterhin als optionalen Kern --- allerdings
nur um die Migration von Checkmk Raw auf die kommerziellen Editionen zu
unterstützen.
:::
::::

:::: sect2
### []{#_wie_kann_ich_zwischen_nagios_und_cmc_wechseln .hidden-anchor .sr-only}3.3. Wie kann ich zwischen Nagios und CMC wechseln? {#heading__wie_kann_ich_zwischen_nagios_und_cmc_wechseln}

::: paragraph
Ein Umschalten zwischen den beiden Kernen ist einfach, sofern Ihre
Konfiguration ausschließlich mit dem [Setup-Menü](wato.html#setup_menu)
der Checkmk Weboberfläche erstellt wurde. Einzelheiten finden Sie im
Artikel [Migration auf den CMC.](cmc_migration.html) Die kommerziellen
Editionen erzeugen neue Instanzen per Default mit CMC als Kern.
:::
::::

:::: sect2
### []{#_ist_der_cmc_frei_verfügbar .hidden-anchor .sr-only}3.4. Ist der CMC frei verfügbar? {#heading__ist_der_cmc_frei_verfügbar}

::: paragraph
Der CMC ist verfügbar als Bestandteil der [kommerziellen
Editionen,](intro_setup.html#editions) die über eine Subskription
erhältlich sind. Checkmk Cloud kann für einen begrenzten Zeitraum
unverbindlich getestet und in kleinem Rahmen dauerhaft ohne Lizenzierung
betrieben werden.
:::
::::
:::::::::::
::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::
