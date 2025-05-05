:::: {#header}
# Besonderheiten des CMC

::: details
[Last modified on 02-Sep-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/cmc_differences.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Der Checkmk Micro Core](cmc.html) [Migration auf den
CMC](cmc_migration.html) [Dateien und Verzeichnisse des
CMC](cmc_files.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#_besonderheiten_des_checkmk_micro_cores .hidden-anchor .sr-only}1. Besonderheiten des Checkmk Micro Cores {#heading__besonderheiten_des_checkmk_micro_cores}

::::: sectionbody
::: paragraph
Die wichtigsten Vorteile des [CMC](cmc.html) liegen in seiner gegenüber
Nagios höheren Performance und schnelleren Reaktionszeiten. Es gibt
jedoch auch darüber hinaus einige interessante Besonderheiten, die Sie
kennen sollten. Die wichtigsten sind:
:::

::: ulist
- Smart Ping --- Intelligente Host-Checks

- Hilfsprozesse Check Helper, Checkmk Fetcher und Checkmk Checker

- Initiales Scheduling

- Verarbeitung von Messdaten

- Einige Funktionen von Nagios sind im CMC nicht oder anders umgesetzt.
  Die Details finden Sie im Artikel zur [Migration auf den
  CMC.](cmc_migration.html)
:::
:::::
::::::

:::::::::::::::::::::::: sect1
## []{#smartping .hidden-anchor .sr-only}2. Smart Ping --- Intelligente Host-Checks {#heading_smartping}

::::::::::::::::::::::: sectionbody
::: paragraph
Bei Nagios ist es üblich, die Erreichbarkeit von Hosts mittels eines
*Ping* zu prüfen. Dazu wird für jeden Host einmal pro Intervall (in der
Regel eine Minute) ein Plugin wie `check_ping` oder `check_icmp`
aufgerufen. Dieses sendet dann z.B. fünf Ping-Pakete und wartet auf
deren Rückkehr. Das Erzeugen der Prozesse für den Aufruf der Plugins
bindet wertvolle CPU-Ressourcen. Zudem sind diese recht lange blockiert,
falls ein Host nicht erreichbar ist und lange Timeouts abgewartet werden
müssen.
:::

::: paragraph
Der CMC führt Host-Checks hingegen --- soweit nicht anders
konfiguriert --- mit einem Verfahren namens *Smart Ping* aus. *Smart
Ping* basiert auf einer internen Komponente namens `icmpsender`, die
ihre eigene Ping-Implementierung hat. Da Checkmk mit CMC nicht auf ein
externes Binary angewiesen ist, muss nicht für jedes gesendete
Ping-Paket ein neuer Prozess gestartet werden, Außerdem unterscheidet
sich das Standardverhalten von `icmpsender` von seinem
Nagios-Gegenstück. Anstelle mehrerer Pakete in schneller Folge, auf die
gewartet wird, sendet `icmpsender` nur *ein* ICMP-Paket pro Host alle
n-Sekunden (der Standardwert von 6 Sekunden ist mit dem Regelsatz
[Normal check interval for host checks]{.guihint} konfigurierbar).
Dieses Verhalten reduziert den Ressourcenverbrauch und Datenverkehr
drastisch.
:::

::: paragraph
Die Antworten auf die Pings werden nicht explizit abgewartet. Die
CMC-Komponente `icmpreceiver` ist für die Entscheidung zuständig, ob der
Zustand eines Hosts [UP]{.hstate0} oder [DOWN]{.hstate1} ist. Sie
bewertet eingehende Ping-Pakete von einem Host als erfolgreichen
Host-Check und kennzeichnet den Host somit als [UP]{.hstate0}. Wenn
innerhalb einer bestimmten Zeit kein Paket von einem Host empfangen
wird, wird dieser Host als [DOWN]{.hstate1} markiert. Das Timeout ist
auf 15 Sekunden (2,5 Intervalle) voreingestellt und kann pro Host mit
dem Regelsatz [Settings for host checks via Smart PING]{.guihint}
geändert werden.
:::

::: paragraph
Die Komponente `icmpreceiver` lauscht auch auf TCP SYN (synchronization)
und RST (reset) Pakete, die von einem Host kommen. Wenn sie solche
Pakete empfängt, wird der Host als [UP]{.hstate0} betrachtet. Dieser
Mechanismus kann zu schwankenden (*flapping*) Zuständen von Hosts in
Infrastrukturen führen, in denen ICMP-Verkehr nicht erlaubt ist,
TCP-Verkehr aber schon.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | `icmpreceiver` wird jedes         |
|                                   | SNMP-Paket ignorieren, da SNMP    |
|                                   | nicht über TCP sondern UDP        |
|                                   | kommuniziert.                     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::::: sect2
### []{#no_on-demand_host_checks .hidden-anchor .sr-only}2.1. Keine Host-Checks auf Abruf {#heading_no_on-demand_host_checks}

::: paragraph
Host-Checks dienen nicht nur der Benachrichtigung bei einem Totalausfall
eines Hosts, sondern auch dazu, [Benachrichtigungen zu
Service-Problemen](notifications.html#state_host) während der Zeit des
Host-Ausfalls zu unterdrücken. Service-Probleme können auftreten, ohne
dass der Service selbst dafür verantwortlich ist, sondern eher ein
Fehlerzustand des Hosts. Es kann vorkommen, dass ein Host tatsächlich
[DOWN]{.hstate1} ist, auch wenn sein letzter bekannter Zustand in
Checkmk [UP]{.hstate0} ist, wie das Ergebnis des letzten Host-Checks
zeigt. In einem solchen Fall könnten mehrere Service-Checks Probleme
zurückgeben, die vom [DOWN]{.hstate1}-Zustand des Hosts abhängen und
Benachrichtigungen für die Services --- fälschlicherweise --- versendet
werden. Daher ist es wichtig, im Falle eines Service-Problems zuerst den
Zustand des Hosts zu bestimmen.
:::

::: paragraph
Der CMC löst dieses Problem sehr einfach: Wenn ein Service-Problem
auftritt und der Host sich im Zustand [UP]{.hstate0} befindet, wartet
der CMC auf den nächsten Host-Check. Da das Intervall mit
(standardmäßig) 6 Sekunden sehr kurz ist, gibt es nur eine
vernachlässigbare Verzögerung bis zu einer Benachrichtigung --- falls
der Host weiterhin [UP]{.hstate0} ist und daher die Benachrichtigung für
den Service gesendet werden muss.
:::

::: paragraph
Nehmen wir folgendes Beispiel: Ein `check_http`-Plugin liefert einen
[CRIT]{.state2}-Zustand, weil der abgefragte Webserver nicht erreichbar
ist. In diesem Fall wurde *nach dem Beginn* des Service-Checks ein
TCP-RST-Paket (*connection refused*) von diesem Server von der
Komponente `icmpreceiver` empfangen. Der CMC weiß daher mit Sicherheit,
dass der Host selbst [UP]{.hstate0} ist und kann die Benachrichtigung
ohne Verzögerung versenden.
:::

::: paragraph
Das gleiche Prinzip wird beim Berechnen von Netzwerkausfällen
angewendet, wenn [Parent-Hosts](notifications.html#parents) definiert
sind. Auch hier werden Benachrichtigungen teilweise kurz zurückgehalten,
um einen gesicherten Zustand abzuwarten.
:::
:::::::

::::::: sect2
### []{#_der_nutzen .hidden-anchor .sr-only}2.2. Der Nutzen {#heading__der_nutzen}

::: paragraph
Durch dieses Verfahren ergibt sich eine Reihe von Vorteilen:
:::

::: ulist
- Nahezu vernachlässigbare CPU-Last durch Host-Checks: Es können selbst
  ohne besonders leistungsfähige Hardware Zigtausende von Hosts
  überwacht werden.

- Kein Ausbremsen des Monitorings durch blockierende Host-Checks auf
  Abruf, falls Hosts [DOWN]{.hstate1} sind.

- Keine Fehlalarme von Services bei nicht aktuellem Host-Zustand.
:::

::: paragraph
Ein Nachteil soll dabei nicht verschwiegen werden: Die Host-Checks via
Smart Ping erzeugen keine Performance-Daten (Paketlaufzeiten).
:::

::: paragraph
Für Hosts, bei denen Sie diese benötigen, können Sie einfach einen
[aktiven Check](glossar.html#active_check) per Ping einrichten mit dem
Regelsatz [Check hosts with PING (ICMP Echo Request)]{.guihint}.
:::
:::::::

:::: sect2
### []{#_nicht_ping_bare_hosts .hidden-anchor .sr-only}2.3. Nicht Ping-bare Hosts {#heading__nicht_ping_bare_hosts}

::: paragraph
In der Praxis sind nicht alle Hosts durch Ping überprüfbar. Für diese
Fälle kann man auch im CMC andere Methoden für den Host-Check verwenden,
z.B. einen TCP-Connect. Da dies Ausnahmen von der Regel sind, wirken sie
sich nicht negativ auf die Gesamtperformance aus. Der Regelsatz dazu
lautet [Host Check Command]{.guihint}.
:::
::::

::::: sect2
### []{#_probleme_mit_firewalls .hidden-anchor .sr-only}2.4. Probleme mit Firewalls {#heading__probleme_mit_firewalls}

::: paragraph
Es gibt Firewalls, die TCP-Verbindungspakete an nicht erreichbare Hosts
mit einem TCP-RST-Paket beantworten. Das Trickreiche ist dabei, dass die
Firewall als *Absender* dieser Pakete nicht sich selbst eintragen darf,
sondern die IP-Adresse des Ziel-Hosts angeben muss. Smart Ping wird
dieses Paket als Lebenszeichen werten und somit zu Unrecht annehmen,
dass der Ziel-Host erreichbar ist.
:::

::: paragraph
In so einer (seltenen) Situation haben Sie die Möglichkeit, mit [Global
settings \> Monitoring Core \> Tuning of Smart PING]{.guihint} die
Option [Ignore TCP RST packets when determining host state]{.guihint} zu
aktivieren. Oder Sie wählen für die betroffenen Hosts als Host-Check
einen klassischen Ping mit `check_icmp`.
:::
:::::
:::::::::::::::::::::::
::::::::::::::::::::::::

:::::::::::::::::::::::::::::: sect1
## []{#aux_processes .hidden-anchor .sr-only}3. Hilfsprozesse {#heading_aux_processes}

::::::::::::::::::::::::::::: sectionbody
::: paragraph
Eine Lehre aus der schlechten Performance von Nagios in größeren
Umgebungen ist, dass das Erzeugen von Prozessen eine teure Operation
ist. Entscheidend hierbei ist vor allem die *Größe des Mutterprozesses*.
Bei jeder Ausführung eines [aktiven Checks](glossar.html#active_check)
muss zunächst der komplette Nagios-Prozess dupliziert werden (*fork*),
bevor er durch den neuen Prozess --- das Check-Plugin --- ersetzt wird.
Je mehr Hosts und Services überwacht werden, desto größer ist dieser
Prozess und desto länger dauert der Fork. Da der Prozess während dessen
auch noch blockiert ist, bleiben auch die anderen Aufgaben des
Prozessorkerns liegen --- da helfen auch keine 24 CPU-Kerne.
:::

:::: sect2
### []{#checkhelper .hidden-anchor .sr-only}3.1. Check Helper {#heading_checkhelper}

::: paragraph
Um das Forken des Kerns zu vermeiden, erzeugt der CMC beim Programmstart
eine festgelegte Anzahl sehr schlanker Hilfsprozesse, deren Aufgabe das
Starten der aktiven Check-Plugins ist: die **Check Helper.** Nicht nur
forken diese viel schneller, das Forken skaliert auch noch über alle
vorhandenen CPU-Kerne, da der Prozessorkern selbst nicht mehr blockiert
wird. Dadurch wird das Ausführen von aktiven Checks (z.B. `check_http`),
deren eigentliche Laufzeit recht kurz ist, stark beschleunigt.
:::
::::

:::::::::::: sect2
### []{#fetcher_checker .hidden-anchor .sr-only}3.2. Checkmk Fetcher und Checkmk Checker {#heading_fetcher_checker}

::: paragraph
Der CMC geht noch einen wesentlichen Schritt weiter. Denn in einer
Checkmk-Umgebung sind aktive Checks eher die Ausnahme. Hier kommen
hauptsächlich Checkmk-basierte Checks zum Einsatz, bei denen pro Host
und Intervall nur noch ein Fork notwendig ist.
:::

::: paragraph
Um die Ausführung dieser Checks zu optimieren, unterhält der CMC noch
zwei weitere Typen von Hilfsprozessen: die **Checkmk Fetcher** und die
**Checkmk Checker.**
:::

::::: sect3
#### []{#_die_checkmk_fetcher .hidden-anchor .sr-only}Die Checkmk Fetcher {#heading__die_checkmk_fetcher}

::: paragraph
rufen die benötigten Informationen von den überwachten Hosts ab, das
heißt, die Daten der Services [Check_MK]{.guihint} und [Check_MK
Discovery.]{.guihint} Die Fetcher übernehmen damit die
Netzwerkkommunikation mit den Checkmk-Agenten, SNMP-Agenten und den
[Spezialagenten.](glossar.html#special_agent) Das Sammeln dieser
Informationen benötigt etwas Zeit, aber mit normalerweise weniger als 50
Megabytes pro Prozess vergleichsweise wenig Arbeitsspeicher. Es können
also viele dieser Prozesse ohne Probleme konfiguriert werden. Bedenken
Sie dennoch, dass die Prozesse teilweise oder gar nicht in den Swap
ausgelagert werden können und damit immer im physischen Speicher
gehalten werden müssen. Der limitierende Faktor ist hier der verfügbare
Arbeitsspeicher des Checkmk-Servers.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Bei den 50 Megabytes handelt es   |
|                                   | sich um eine Schätzung, die der   |
|                                   | grundsätzlichen Orientierung      |
|                                   | dienen soll. Unter bestimmten     |
|                                   | Umständen (z.B. bei der           |
|                                   | Konfiguration von IPMI im         |
|                                   | [Management                       |
|                                   | board](ho                         |
|                                   | sts_setup.html#management_board)) |
|                                   | kann der Wert auch höher sein.    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::

:::::: sect3
#### []{#_die_checkmk_checker .hidden-anchor .sr-only}Die Checkmk Checker {#heading__die_checkmk_checker}

::: paragraph
analysieren und bewerten die von den Checkmk Fetchern gesammelten
Informationen und erzeugen die Check-Resultate für die Services. Die
Checker benötigen viel Arbeitsspeicher, da sie die Checkmk-Konfiguration
mit dabei haben müssen. Ein Checker-Prozess belegt mindestens ca. 90
Megabytes --- es kann aber auch ein Vielfaches davon notwendig sein, je
nachdem wie die Checks konfiguriert sind. Dafür verursachen die Checker
keine Netzwerklast und sind sehr schnell in der Ausführung. Die Anzahl
der Checker sollte nur so groß sein, wie Ihr Checkmk-Server parallel
Prozesse abarbeiten kann. Im Regelfall entspricht diese Zahl der Anzahl
an Prozessorkernen Ihres Servers. Da die Checker nicht IO-gebunden sind,
sind sie am effektivsten, wenn jeder Checker seinen eigenen
Prozessorkern erhält.
:::

::: paragraph
Die Aufteilung der beiden unterschiedlichen Aufgaben „Sammeln" und
„Ausführen" auf Checkmk Fetcher und Checkmk Checker gibt es seit der
Checkmk-Version [2.0.0]{.new}. Vorher gab es nur *einen*
Hilfsprozesstyp, der für beides zuständig war --- die sogenannten
Checkmk Helper.
:::

::: paragraph
Mit dem Fetcher/Checker-Modell können nunmehr beide Aufgaben auf zwei
separate Pools von Prozessen aufgeteilt werden: das Abrufen der
Informationen aus dem Netzwerk mit vielen kleinen Fetcher-Prozessen und
die rechenintensive Überprüfung mit wenigen großen Checker-Prozessen.
Dadurch benutzt ein CMC bei gleicher Leistung (Checks pro Sekunde) bis
zu viermal weniger Arbeitsspeicher!
:::
::::::
::::::::::::

::::::::::::::: sect2
### []{#numbers .hidden-anchor .sr-only}3.3. Zahl der Hilfsprozesse richtig einstellen {#heading_numbers}

::: paragraph
Standardmäßig werden 5 Check Helper, 13 Checkmk Fetcher und 4 Checkmk
Checker gestartet. Diese Werte werden unter [Global settings \>
Monitoring Core]{.guihint} festgelegt und können von Ihnen angepasst
werden:
:::

:::: imageblock
::: content
![Liste der globalen Einstellungen für die Hilfsprozesse des
CMC.](../images/cmc_differences_global_settings_monitoring_core.png)
:::
::::

::: paragraph
Um herauszufinden, ob und wie sie die Standardwerte verändern müssen,
haben Sie mehrere Möglichkeiten:
:::

::: paragraph
In der Seitenleiste zeigt Ihnen das Snapin [Core statistics]{.guihint}
die prozentuale Auslastung im Durchschnitt der letzten 10-20 Sekunden:
:::

:::: imageblock
::: content
![Snapin Core
statistics.](../images/cmc_differences_snapin_core_statistics.png){width="50%"}
:::
::::

::: paragraph
Für alle Hilfsprozesstypen gilt: Es sollten immer genügend Prozesse
vorhanden sein, um die konfigurierten Prüfungen durchzuführen. Wenn ein
Pool zu 100 % ausgelastet ist, werden die Checks nicht rechtzeitig
ausgeführt, die Latenzzeit wächst und die Zustände der Services sind
nicht aktuell.
:::

::: paragraph
Die Auslastung (*usage*) sollte wenige Minuten nach dem Start einer
Instanz 80 % nicht überschreiten. Bei höheren Prozentwerten sollten Sie
die Anzahl der Prozesse erhöhen. Da die notwendige Anzahl der Checkmk
Fetcher mit der Zahl der überwachten Hosts und Services wächst, ist hier
eine Korrektur am wahrscheinlichsten. Achten Sie jedoch darauf, nur so
viele Hilfsprozesse zu erzeugen, wie wirklich benötigt werden, da jeder
Prozess Ressourcen belegt. Außerdem werden alle Hilfsprozesse beim Start
des CMC parallel initialisiert, was zu Lastspitzen führen kann.
:::

::: paragraph
Das Snapin [Core statistics]{.guihint} zeigt Ihnen aber nicht nur die
Auslastung, sondern auch die Latenzzeiten (*latency*). Für diese Werte
gilt die simple Regel: Je niedriger, desto besser --- und am allerbesten
sind daher 0 Sekunden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die im Snapin gezeigten Werte     |
|                                   | können Sie sich für Ihre Instanz  |
|                                   | auch in den Details des Services  |
|                                   | [OMD \<site_name\>                |
|                                   | performance]{.guihint} anzeigen   |
|                                   | lassen.                           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Alternativ zum Snapin [Core statistics]{.guihint} können Sie sich auch
Ihre [Konfiguration von Checkmk analysieren
lassen](analyze_configuration.html), mit [Setup \> Maintenance \>
Analyze configuration]{.guihint}. Der Vorteil: Hier erhalten Sie von
Checkmk sofort die Bewertung, wie es um den Zustand der Hilfsprozesse
steht. Sehr praktisch ist: Sollte einer der Hilfsprozesse nicht
[OK]{.state0} sein, können Sie aus dem Hilfetext gleich die zugehörige
Option in den [Global settings]{.guihint} öffnen, um den Wert zu ändern.
:::
:::::::::::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

:::::: sect1
## []{#_initiales_scheduling .hidden-anchor .sr-only}4. Initiales Scheduling {#heading__initiales_scheduling}

::::: sectionbody
::: paragraph
Beim Scheduling wird festgelegt, welche Checks zu welcher Zeit
ausgeführt werden sollen. Nagios hat hier mehrere Verfahren
implementiert, die dafür sorgen sollen, dass die Checks gleichmäßig über
die Zeit verteilt werden. Dabei wird auch versucht, die Abfragen, die
auf einem einzelnen Zielsystem laufen, über das Intervall zu verteilen.
:::

::: paragraph
Der CMC hat hier ein eigenes, einfacheres Verfahren. Dies trägt dem
Umstand Rechnung, dass Checkmk einen Host ohnehin nur einmal pro
Intervall kontaktiert. Außerdem sorgt der CMC dafür, dass neue Checks
*sofort* ausgeführt werden und nicht über mehrere Minuten verteilt. Für
den Anwender ist das sehr angenehm, da ein neu aufgenommener Host sofort
nach dem Aktivieren der Konfiguration abgefragt wird. Um eine Lastspitze
bei einer großen Zahl von neuen Checks zu vermeiden, werden neue Checks,
die eine bestimmte einstellbare Zahl überschreiten, auf das ganze
Intervall verteilt. Die Option dafür finden Sie unter [Global settings
\> Monitoring Core \> Initial Scheduling]{.guihint}.
:::
:::::
::::::

::::::::::::: sect1
## []{#metrics .hidden-anchor .sr-only}5. Verarbeitung von Messdaten {#heading_metrics}

:::::::::::: sectionbody
::: paragraph
Eine wichtige Funktion von Checkmk ist das [Verarbeiten von
Messdaten](graphing.html), wie z.B. CPU-Auslastung, und deren
Speicherung über einen längeren Zeitraum. In
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** kommt dabei
[PNP4Nagios](https://github.com/pnp4nagios){target="_blank"} zum
Einsatz, welches wiederum auf dem
[RRDtool](https://oss.oetiker.ch/rrdtool/){target="_blank"} aufsetzt.
:::

::: paragraph
Die Software erledigt zwei Aufgaben:
:::

::: {.olist .arabic}
1.  Das Anlegen und Aktualisieren der [Round-Robin-Datenbanken
    (RRDs).](graphing.html#rrds)

2.  Die grafische Darstellung der Daten in der GUI.
:::

::: paragraph
Bei Verwendung des Nagios-Kerns läuft der erste Part über einen recht
langen Weg. Je nach Methode kommen dabei Spool-Dateien, Perl-Skripte und
ein Hilfsprozess (`npcd`) zum Einsatz, der in C geschrieben ist. Am Ende
werden leicht umgewandelte Daten in das Unix-Socket des
RRD-Cache-Daemons geschrieben.
:::

::: paragraph
Der CMC kürzt diese Kette ab, in dem er *direkt* zum RRD-Cache-Daemon
schreibt --- alle Zwischenschritte werden ausgelassen. Das Parsen der
Daten und Umwandeln in das Format des RRDtools erfolgt direkt in C++.
Dieses Verfahren ist heute möglich und sinnvoll, da der RRD-Cache-Daemon
ohnehin sein eigenes sehr effizientes Spooling implementiert und
mithilfe von Journaldateien auch bei einem Absturz des Systems keine
Daten verliert.
:::

::: paragraph
Die Vorteile:
:::

::: ulist
- Einsparen von Disk-I/O und CPU.

- Einfachere Implementierung mit deutlich mehr Stabilität.
:::

::: paragraph
Das Neuanlegen von RRDs erledigt der CMC mit einem weiteren Helper, der
per `cmk --create-rrd` aufgerufen wird. Dieser legt die Dateien
wahlweise kompatibel zu PNP an oder alternativ im neuen Checkmk-Format
(gilt nur für Neuinstallationen). Ein Wechsel von Nagios auf CMC hat
daher keinen Einfluss auf bestehende RRD-Dateien. Diese werden nahtlos
weiter gepflegt.
:::

::: paragraph
In den kommerziellen Editionen übernimmt die grafische Darstellung der
Daten direkt die GUI von Checkmk selbst, so dass keine Komponente von
PNP4Nagios mehr beteiligt ist.
:::
::::::::::::
:::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
