:::: {#header}
# Migration auf den CMC

::: details
[Last modified on 16-Sep-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cmc_migration.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Der Checkmk Micro Core (CMC)](cmc.html) [Besonderheiten des
CMC](cmc_differences.html) [Dateien und Verzeichnisse des
CMC](cmc_files.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::: sect1
## []{#_umstellung_von_nagios_auf_cmc .hidden-anchor .sr-only}1. Umstellung von Nagios auf CMC {#heading__umstellung_von_nagios_auf_cmc}

:::::::::::::::::::::: sectionbody
::: paragraph
Neue Instanzen werden von den kommerziellen Editionen automatisch mit
dem [Checkmk Micro Core (CMC)](cmc.html) als Kern erzeugt. Wenn Ihre
Instanz von einer älteren Version stammt, können Sie diese nachträglich
von Nagios auf CMC umstellen. Der Vorgang an sich ist dabei sehr
einfach:
:::

::: paragraph
Stoppen Sie zunächst Ihre Checkmk-Instanz:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd stop
```
:::
::::

::: paragraph
Danach können Sie umschalten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set CORE cmc
```
:::
::::

::: paragraph
Vergessen Sie danach nicht das Starten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
```
:::
::::

::: paragraph
**Achtung:** Der aktuelle Status des Kerns (aktueller Zustand von Hosts
und Services, etc.) wird dabei *nicht* übernommen. Sobald jeder Check
einmal ausgeführt wurde, hat das System den Status aber ohnehin wieder
ermittelt. Dabei werden alle Hosts und Services, die nicht
[UP]{.hstate0} bzw. [OK]{.state0} sind, **neu benachrichtigt.** Wenn Sie
das nicht wünschen, dann schalten Sie vor der Umstellung die
Benachrichtigungen (*notifications*) ab --- mit dem Snapin [Master
control](user_interface.html#master_control) der Seitenleiste.
[Wartungszeiten](basics_downtimes.html) und Kommentare werden aber
übernommen, ebenso wie historische Messdaten in den
[RRDs](graphing.html#rrds).
:::

::: paragraph
Die Historie der Ereignisse (Nagios-Log) wird vom CMC in einem
kompatiblen Format, allerdings an einer anderen Stelle
(`var/check_mk/core/history`) gepflegt. Das Log-Archiv befindet sich in
`var/check_mk/core/archive`. Wenn Sie eine Übernahme der historischen
Ereignisse (z.B. für die [Verfügbarkeit](availability.html)) wünschen,
so kopieren Sie die nötigen Dateien auf der Kommandozeile:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cp var/nagios/nagios.log var/check_mk/core/history
OMD[mysite]:~$ mkdir -p var/check_mk/core/archive && [[ -e var/nagios/archive/ ]] && cp var/nagios/archive/ var/check_mk/core/archive
```
:::
::::

::::::: sect2
### []{#_zurück_von_cmc_auf_nagios .hidden-anchor .sr-only}1.1. Zurück von CMC auf Nagios {#heading__zurück_von_cmc_auf_nagios}

::: paragraph
Wenn Sie feststellen, dass Ihre Konfiguration noch nicht kompatibel ist
mit dem CMC (die Hinweise dazu finden siehe [unten](#tips_migrating),
dann können Sie analog, wie oben beschrieben, auf Nagios zurückschalten
mit:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set CORE nagios
```
:::
::::

::: paragraph
Eine Übernahme von Wartungszeiten etc. von CMC in Richtung Nagios ist
dabei nicht möglich. Nagios wird aber seinen alten Zustand von vor der
Migration zu CMC wieder einlesen.
:::
:::::::
::::::::::::::::::::::
:::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#tips_migrating .hidden-anchor .sr-only}2. Tipps zum Umstieg auf CMC {#heading_tips_migrating}

:::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Um den CMC so schlank und effizient wie möglich zu halten und an
wichtigen Stellen zu modernisieren, wurden nicht alle Funktionen von
Nagios 1:1 nachprogrammiert. Das bedeutet, dass Sie eventuell an einigen
Stellen Ihre Konfiguration anpassen müssen.
:::

::: paragraph
Grundsätzlich kann der CMC keine Nagios-Konfigurationsdateien einlesen.
Sollten Sie also Teile der Nagios-Dateien von Hand geschrieben haben
oder Konstrukte wie `extra_nagios_conf` in der Datei `main.mk`
verwenden, so können diese nicht verarbeitet werden. Wenn Sie immer mit
dem [Setup](wato.html#setup_menu) der Weboberfläche gearbeitet haben,
ist keine Anpassung notwendig.
:::

::: paragraph
In den folgenden Abschnitten finden Sie eine Aufstellung aller Dinge,
die Sie eventuell von Hand in Nagios konfiguriert haben und die beim CMC
nicht oder anders umgesetzt sind.
:::

:::::: sect2
### []{#_hilfsprozesse .hidden-anchor .sr-only}2.1. Hilfsprozesse {#heading__hilfsprozesse}

::: paragraph
Mit der Verwendung des CMC ändert sich die Art und Weise, wie Daten
eingesammelt und anschließend geprüft werden, grundlegend. Deshalb ist
es bei einer Umstellung auf den CMC - besonders bei Instanzen mit
mehreren tausend Hosts - wahrscheinlich erforderlich, die Zahl der
voreingestellten Checkmk Checker und Fetcher zu prüfen und anzupassen.
Einen ersten Hinweis darauf kann schon die Funktion [Analyze
configuration](analyze_configuration.html) liefern. Wir empfehlen
allerdings dringend, das Kapitel
[Hilfsprozesse](cmc_differences.html#aux_processes) im Handbuch zu
lesen.
:::

::: paragraph
Und für alle, die es eilig haben:
:::

::: ulist
- [Maximum concurrent Checkmk checkers]{.guihint} = Anzahl an
  Prozessorkernen Ihres Servers

- [Maximum concurrent Checkmk fetchers]{.guihint} = Jeder Fetcher
  benötigt **ungefähr** 50 MB Arbeitsspeicher - also gerne hochdrehen.
:::
::::::

:::: sect2
### []{#_event_handler .hidden-anchor .sr-only}2.2. Event Handler {#heading__event_handler}

::: paragraph
Der CMC unterstützt keine klassischen Nagios Event Handler. Die
kommerziellen Editionen haben aber dafür die sogenannten [Alert
Handler](alert_handlers.html), die deutlich flexibler sind. Sie können
über [Setup \> Events \> [![icon alert
handlers](../images/icons/icon_alert_handlers.png)]{.image-inline} Alert
handlers]{.guihint} konfiguriert werden.
:::
::::

:::: sect2
### []{#_service_abhängigkeiten .hidden-anchor .sr-only}2.3. Service-Abhängigkeiten {#heading__service_abhängigkeiten}

::: paragraph
Service-Abhängigkeiten (*service dependencies*) werden vom CMC aktuell
nicht unterstützt. Da Serviceabhängigkeiten in Nagios umständlich zu
konfigurieren und sehr intransparent für den Benutzer sind, ist auch
nicht geplant, sie in dieser Form umzusetzen.
:::
::::

:::: sect2
### []{#_event_broker_module .hidden-anchor .sr-only}2.4. Event-Broker-Module {#heading__event_broker_module}

::: paragraph
[Livestatus](livestatus.html) und die Verarbeitung von Performance-Daten
sind im CMC fest integriert. Andere Module können nicht geladen werden.
:::
::::

:::: sect2
### []{#_eskalationen .hidden-anchor .sr-only}2.5. Eskalationen {#heading__eskalationen}

::: paragraph
Die Eskalation von Benachrichtigungen wird nicht mehr im Kern gesteuert,
sondern über [regelbasierte
Benachrichtigungen](notifications.html#rules).
:::
::::

:::: sect2
### []{#_zeitperioden .hidden-anchor .sr-only}2.6. Zeitperioden {#heading__zeitperioden}

::: paragraph
Bei den [Zeitperioden](timeperiods.html) (*time periods*) sind einige
der Ausnahmedefinitionen, welche in Nagios funktionieren, nicht möglich.
Aktuell wird nur das Format `YYYY-MM-DD`, also z.B. `1970-12-18`,
unterstützt, nicht aber ein Format wie `february -2`. Mit [Setup \>
General \> [![icon
timeperiods](../images/icons/icon_timeperiods.png)]{.image-inline} Time
periods]{.guihint} gibt es aber die Möglichkeit, Kalenderdateien im
iCal-Format zu importieren.
:::
::::

:::::::::::::: sect2
### []{#_konfigurationsvariable_legacy_checks .hidden-anchor .sr-only}2.7. Konfigurationsvariable legacy_checks {#heading__konfigurationsvariable_legacy_checks}

::: paragraph
Die Konfigurationsvariable `legacy_checks`, mit der in alten
Checkmk-Versionen aktive Checks konfiguriert wurden, gibt es nicht mehr.
Natürlich können Sie auch mit dem CMC aktive Checks ausführen, nur in
einer etwas anderen Form.
:::

::: paragraph
Der Grund ist, dass die `legacy_checks` sich auf Kommandos beziehen, die
man von Hand in der Nagios-Konfiguration anlegt und die dem CMC folglich
nicht bereitstehen. Anstelle dessen können Sie die moderneren
`custom_checks` verwenden. Diese verwalten sie mit dem Regelsatz
[Integrate Nagios plugins]{.guihint}, den Sie in [Setup \> Services \>
Other services]{.guihint} finden --- und übrigens auch ohne CMC nutzen
können.
:::

::: paragraph
Folgendes Beispiel zeigt, wie Sie einen bestehenden Legacy-Check ...​
:::

::::: listingblock
::: title
main.mk (altes Format)
:::

::: content
``` {.pygments .highlight}
# Definition of the Nagios command
extra_nagios_conf += r"""

define command {
    command_name    check-my-foo
    command_line    $USER1$/check_foo -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$
}
"""

# Create service definition
legacy_checks += [
  (( "check-my-foo!20!40", "FOO", True), [ "foohost", "othertag" ], ALL_HOSTS ),
]
```
:::
:::::

::: paragraph
... auf das neue Format der `custom_checks` umstellen:
:::

::::: listingblock
::: title
main.mk (neues Format)
:::

::: content
``` {.pygments .highlight}
custom_checks += [
  ({
      'command_name':        'check-my-foo',
      'service_description': 'FOO',
      'command_line':        'check_foo -H $HOSTADDRESS$ -w 20 -c 40',
      'has_perfdata':        True,
  },
  [ "foohost", "othertag" ],
  ALL_HOSTS )]
```
:::
:::::

::: paragraph
Die neue Methode funktioniert auch mit Nagios als Kern, so dass Sie nach
der Umstellung problemlos zwischen beiden CMC und Nagios hin- und
herschalten können.
:::
::::::::::::::

:::::::: sect2
### []{#_performance_daten_von_host_checks .hidden-anchor .sr-only}2.8. Performance-Daten von Host-Checks {#heading__performance_daten_von_host_checks}

::: paragraph
Der CMC verwendet für Host-Checks als Standard [Smart
Ping](cmc_differences.html#smartping). Das bedeutet, dass nach einer
Umstellung vom Nagios Kern,
:::

::: ulist
- die Host-Checks zunächst keine Performance-Daten mehr liefern und

- die manuell erzeugten Ping-Checks auf Hosts ohne sonstige Checks per
  Default Performance-Daten erzeugen.
:::

::: paragraph
Wenn Sie die Ping-Performance-Daten für einzelne oder alle Hosts
benötigen, dann empfehlen wir einen [aktiven Check](active_checks.html)
per Ping für die gewünschten Hosts hinzuzufügen mit dem Regelsatz [Check
hosts with PING (ICMP Echo Request)]{.guihint}.
:::

::: paragraph
Wenn Sie die bestehenden [Round-Robin-Datenbanken
(RRDs)](graphing.html#rrds) weiterführen möchten, können Sie
einfach --- während der Kern angehalten ist --- die Dateien in den
Verzeichnissen `var/pnp4nagios/perfdata/<hostname>`, die mit `_HOST_`
beginnen umbenennen: von `_HOST_*` nach `PING*`.
:::

::: paragraph
Alternativ können Sie Smart Ping auch mit dem Regelsatz [Host Check
Command]{.guihint} abschalten und durch einen klassischen Ping ersetzen,
der intern wie gehabt mit `check_icmp` arbeitet. In diesem Fall müssen
Sie die RRDs nicht umbenennen, verzichten aber auf die Vorzüge von Smart
Ping.
:::
::::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
