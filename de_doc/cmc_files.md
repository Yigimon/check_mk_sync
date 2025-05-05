:::: {#header}
# Dateien und Verzeichnisse des CMC

::: details
[Last modified on 15-Sep-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cmc_files.asciidoc){.edit-document}
:::
::::

::::::::::::::::: {#content}
::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Der Checkmk Micro Core (CMC)](cmc.html) [Besonderheiten des
CMC](cmc_differences.html) [Migration auf den CMC](cmc_migration.html)
:::
::::
:::::

::: paragraph
Folgende Übersicht zeigt Ihnen alle wichtigen Dateien und Verzeichnisse,
die den [Checkmk Micro Core (CMC)](cmc.html) betreffen. Alle Pfade sind
relativ vom Home-Verzeichnis der Instanz angegeben. Heißt die Instanz
z.B. `mysite`, so sind alle Pfade von `/omd/sites/mysite` aus zu
verstehen.
:::
:::::::
:::::::::

:::: sect1
## []{#_laufzeitdaten .hidden-anchor .sr-only}1. Laufzeitdaten {#heading__laufzeitdaten}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `                  | In dieser Datei finden Sie Meldungen zum Start  |
| ~/var/log/cmc.log` | und Stop des CMC und eventuell Warnungen oder   |
|                    | Fehler genereller Art. Die Historie von Hosts   |
|                    | und Services (bei Nagios beides in              |
|                    | `var/nagios/nagios.log` enthalten) ist beim CMC |
|                    | in eine eigene Datei `history` ausgelagert.     |
+--------------------+-------------------------------------------------+
| `~/v               | Verzeichnis mit allen Laufzeitdaten des CMC.    |
| ar/check_mk/core/` |                                                 |
+--------------------+-------------------------------------------------+
| `~/var/che         | Konfiguration für den Kern mit allen statischen |
| ck_mk/core/config` | Daten zu Hosts, Services, Gruppen, Benutzern    |
|                    | und globalen Einstellungen. Diese Datei         |
|                    | entspricht bei Nagios den Dateien unter         |
|                    | `etc/nagios/conf.d`.                            |
+--------------------+-------------------------------------------------+
| `~/var/ch          | Aktueller Laufzeitzustand des Kerns. Die Datei  |
| eck_mk/core/state` | speichert Informationen über den aktuellen      |
|                    | Status von Hosts und Services sowie über        |
|                    | [Wartungszeiten](basics_downtimes.html),        |
|                    | [Quittierungen](basics_ackn.html) und           |
|                    | Kommentare. Die Datei wird regelmäßig und beim  |
|                    | Anhalten des Kerns aktualisiert. Wenn sie beim  |
|                    | Start des Kerns nicht vorhanden oder nicht      |
|                    | kompatibel ist, beginnt der Kern mit einem      |
|                    | leeren Zustand. Die Datei entspricht der Datei  |
|                    | `var/nagios/retention.dat` von Nagios, ist aber |
|                    | binär kodiert.                                  |
+--------------------+-------------------------------------------------+
| `~/var/chec        | Sicherheitskopien des Status nach Migration von |
| k_mk/core/state.*` | einer alten CMC-Version oder wenn der CMC       |
|                    | feststellt, dass die Zahl der Hosts in der      |
|                    | Konfiguration stark gesunken ist. So können Sie |
|                    | zum alten Status zurückkehren (und Ihre         |
|                    | Wartungszeiten und Quittierungen                |
|                    | wiederbekommen), wenn Sie z.B. durch eine       |
|                    | Fehlkonfiguration alle Hosts vorübergehend aus  |
|                    | dem Monitoring entfernt hatten.                 |
+--------------------+-------------------------------------------------+
| `~/var/c           | Diese Datei ist normalerweise nicht vorhanden.  |
| heck_mk/core/core` | Falls doch, deutet sie auf einen früheren       |
|                    | Absturz des Kerns hin und hilft den Entwicklern |
|                    | beim Finden der Fehlerursache.                  |
+--------------------+-------------------------------------------------+
| `~/var/chec        | In dieser Datei ist die Historie aller Hosts    |
| k_mk/core/history` | und Services im Textformat gespeichert. Sie     |
|                    | entspricht vom Inhalt und Aufbau der Datei      |
|                    | `var/nagios/nagios.log` von Nagios und ist mit  |
|                    | ihr weitgehend kompatibel.                      |
+--------------------+-------------------------------------------------+
| `~/var/check       | In dieses Verzeichnis werden alte Versionen von |
| _mk/core/archive/` | `history` bei der Rotation der Log-Dateien      |
|                    | verschoben. Nur wenn diese Dateien              |
|                    | unkomprimiert vorhanden sind, kann man mit      |
|                    | Livestatus und Multisite auf historische Daten  |
|                    | zugreifen (Events, Verfügbarkeit).              |
+--------------------+-------------------------------------------------+
| `~/tmp/run/live`   | Livestatus-Socket des CMC. Es befindet sich an  |
|                    | der gleichen Stelle, wie das von Nagios. Da der |
|                    | CMC Livestatus-kompatibel zu Nagios und Icinga  |
|                    | ist, können so alle Erweiterungen, die auf      |
|                    | Livestatus basieren, ohne Anpassung genutzt     |
|                    | werden (z.B. [NagVis](nagvis.html)).            |
+--------------------+-------------------------------------------------+
| `                  | Aktuelle Prozess-ID des CMC.                    |
| ~/tmp/run/cmc.pid` |                                                 |
+--------------------+-------------------------------------------------+
:::
::::

::::: sect1
## []{#_konfiguration .hidden-anchor .sr-only}2. Konfiguration {#heading__konfiguration}

:::: sectionbody
::: paragraph
Der CMC hat keine eigene Konfigurationsdatei. Alle Einstellungen für den
CMC finden Sie in der Weboberfläche von Checkmk unter [![Symbol für die
globalen
Einstellungen.](../images/icons/icon_configuration.png)]{.image-inline}
[Global settings \> Monitoring Core]{.guihint}. Sie werden zusammen mit
den anderen globalen Einstellungen in
`etc/check_mk/conf.d/wato/global.mk` gespeichert.
:::
::::
:::::

:::: sect1
## []{#_software .hidden-anchor .sr-only}3. Software {#heading__software}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `~/bin/cmc`        | Ausführbares Programm für den CMC selbst.       |
|                    | Dieses ist in C++ entwickelt und benötigt außer |
|                    | der Standard-C++-Bibliothek keine weiteren      |
|                    | Bibliotheken (insbesondere kein Boost). Zu      |
|                    | Testzwecken kann man den CMC auch von Hand      |
|                    | aufrufen (probieren Sie: `cmc --help`).         |
+--------------------+-------------------------------------------------+
| `~/etc/init.d/cmc` | Startskript des CMC.                            |
+--------------------+-------------------------------------------------+
| `~/l               | Hilfsprozess, der vom CMC gestartet wird und    |
| ib/cmc/icmpsender` | das Senden von ICMP-Paketen für das [Smart      |
|                    | Ping](cmc_differences.html#smartping)           |
|                    | übernimmt. Dieser muss unbedingt mit Set User   |
|                    | ID (SUID) für root installiert sein.            |
+--------------------+-------------------------------------------------+
| `~/lib             | Hilfsprozess, der vom CMC gestartet wird und    |
| /cmc/icmpreceiver` | das Empfangen von ICMP- und                     |
|                    | TCP-Verbindungspaketen für das Smart Ping       |
|                    | übernimmt. Dieser muss unbedingt mit Set User   |
|                    | ID (SUID) für root installiert sein.            |
+--------------------+-------------------------------------------------+
| `~/li              | Hilfsprozess [Check                             |
| b/cmc/checkhelper` | Helper](cmc_differences.html#checkhelper), der  |
|                    | vom CMC mehrfach gestartet wird und das         |
|                    | effiziente Ausführen von aktiven Checks         |
|                    | übernimmt.                                      |
+--------------------+-------------------------------------------------+
| `~/bin/fetcher`    | Hilfsprozess [Checkmk                           |
|                    | Fetcher](cmc_differences.html#fetcher_checker), |
|                    | der vom CMC mehrfach gestartet wird und die     |
|                    | Informationen von den Agenten aus dem Netzwerk  |
|                    | abruft.                                         |
+--------------------+-------------------------------------------------+
:::
::::
:::::::::::::::::
