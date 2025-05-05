:::: {#header}
# Wartungszeiten

::: details
[Last modified on 22-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/basics_downtimes.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Kommandos](commands.html) [Benachrichtigungen](notifications.html)
[Zeitperioden (Time Periods)](timeperiods.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#mode .hidden-anchor .sr-only}1. Funktionsweise {#heading_mode}

::::: sectionbody
::: paragraph
Im IT-Betrieb unterscheidet man zwei Arten von Ausfällen: geplante und
ungeplante. Das Monitoring-System kann --- wenn es einen Ausfall
feststellt --- natürlich erst mal nicht wissen, ob dieser geplant war
oder nicht. Über das Konzept von *Wartungszeiten* (Englisch *scheduled
downtimes*) können Sie geplante Ausfallzeiten eines Hosts oder Services
dem System bekannt machen, indem Sie für die entsprechenden Objekte eine
Wartungszeit definieren. Befindet sich ein Host oder Service in so einer
Wartungszeit, hat das folgende Auswirkungen:
:::

::: ulist
- In den [Tabellenansichten](glossar.html#view) erscheint ein Symbol bei
  den betroffenen Hosts und Services: Services werden mit einem
  [![Symbol zur Anzeige der Wartungszeit bei
  Services.](../images/icons/icon_downtime.png)]{.image-inline}
  Leitkegel markiert, Hosts mit einem [![Symbol zur Anzeige der
  Wartungszeit bei
  Hosts.](../images/icons/icon_derived_downtime.png)]{.image-inline}
  blauen Pause-Symbol. Auch Services, deren Hosts sich in Wartung
  befinden, bekommen das blaue Pause-Symbol. In der [History](#history)
  werden gestartete Wartungszeiten mit [![Symbol zur Anzeige einer
  gestarteten
  Wartungszeit.](../images/icons/icon_alert_downtime.png)]{.image-inline}
  markiert und beendete mit [![Symbol zur Anzeige einer beendeten
  Wartungszeit.](../images/icons/icon_alert_downtimestop.png)]{.image-inline}.

- Die Benachrichtigungen über Probleme sind während der Wartung
  abgeschaltet.

- Die betroffenen Hosts/Services tauchen im
  [[Overview]{.guihint}](user_interface.html#overview) nicht mehr als
  Probleme auf.

- In der [Verfügbarkeitsanalyse](availability.html) werden geplante
  Wartungszeiten gesondert berücksichtigt.

- Zu Beginn und Ende einer Wartungszeit wird eine spezielle
  Benachrichtigung ausgelöst, die darüber informiert.
:::
:::::
::::::

::::::::::::::::::::::::::::::::: sect1
## []{#enter .hidden-anchor .sr-only}2. Wartungszeiten festlegen {#heading_enter}

:::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Festlegen von Wartungszeiten geschieht über
[Kommandos.](commands.html) Alle Aktionen, die Wartungszeiten betreffen,
sind hier in einem eigenen Kasten zusammengefasst:
:::

:::: imageblock
::: content
![Dialog zur Definition einer
Wartungszeit.](../images/basics_downtimes_schedule.png)
:::
::::

::: paragraph
Das Feld [Comment]{.guihint} muss immer ausgefüllt werden. Sie können an
dieser Stelle auch eine URL in der Form `https://www.example.com`
eintragen, die dann als anklickbarer Link zur Verfügung steht. Für die
zeitliche Definition gibt es zahlreiche unterschiedliche
Möglichkeiten --- vom einfachen [2 hours]{.guihint}, welches die Wartung
**ab sofort** definiert, bis hin zu Start und Ende eines expliziten
Zeitraums, mit dem auch eine Wartung in der Zukunft definiert werden
kann.
:::

::::::::::::::::: sect2
### []{#scheduled .hidden-anchor .sr-only}2.1. Regelmäßige Wartungszeiten {#heading_scheduled}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Manche Wartungen
werden regelmäßig ausgeführt --- wie z.B. der automatische Neustart
eines Servers einmal pro Woche. Jedes Mal von Hand eine Wartung
einzutragen wäre recht umständlich. Wenn es nur um die
[Benachrichtigungen](glossar.html#notification) geht, können Sie hierzu
mit [Zeitperioden](glossar.html#time_period) und dem Regelsatz
[Notification period for Hosts/Services]{.guihint} arbeiten. Dies hat
allerdings verschiedene Einschränkungen. Eine Wichtige ist, dass man für
das Anlegen von Zeitperioden globale Konfigurationsberechtigungen
benötigt.
:::

::: paragraph
Die kommerziellen Editionen bieten daher das Konzept von sich
automatisch periodisch wiederholenden Wartungszeiten. Diese können auf
zwei verschiedene Arten eingetragen werden.
:::

::::::: sect3
#### []{#_anlegen_mittels_kommando .hidden-anchor .sr-only}Anlegen mittels Kommando {#heading__anlegen_mittels_kommando}

::: paragraph
Der erste Weg führt über die Option [Repeat.]{.guihint}
:::

:::: imageblock
::: content
![Die Wiederholungsperiode
auswählen.](../images/basics_downtimes_periodic.png)
:::
::::

::: paragraph
Dabei wählen Sie die Periode aus, mit der sich die Wartung wiederholen
soll. Das **erste** Auftreten tragen Sie über [Start]{.guihint} und
[End]{.guihint} ein. Von der hier eingetragenen Startzeit aus wird die
Periode berechnet. Es gibt folgende Möglichkeiten:
:::

+--------------------+-------------------------------------------------+
| [never]{.guihint}  | Die Wartungszeit wird nicht wiederholt, d.h.    |
|                    | nur einmal ausgeführt (Standardeinstellung).    |
+--------------------+-------------------------------------------------+
| [hour]{.guihint}   | Die Wartungszeit wiederholt sich stündlich      |
|                    | genau um die gleiche Uhrzeit.                   |
+--------------------+-------------------------------------------------+
| [day]{.guihint}    | Tägliche Wiederholung um die gleiche Uhrzeit.   |
+--------------------+-------------------------------------------------+
| [week]{.guihint}   | Wiederholung alle sieben Tage am gleichen       |
|                    | Wochentag und zur gleichen Uhrzeit wie beim     |
|                    | ersten Mal.                                     |
+--------------------+-------------------------------------------------+
| [second            | Wie wöchentlich, nur jetzt 14-tägig.            |
| week]{.guihint}    |                                                 |
+--------------------+-------------------------------------------------+
| [fourth            | Wie wöchentlich, aber jetzt alle 28 Tage.       |
| week]{.guihint}    |                                                 |
+--------------------+-------------------------------------------------+
| [same nth weekday  | Hiermit können Sie monatliche Wiederholungen    |
| (from              | auf Basis des Wochentags realisieren. Wenn also |
| beg                | die Startzeit am zweiten Montag des Monats ist, |
| inning)]{.guihint} | wird fortan jeden Monat am zweiten Montag       |
|                    | wieder eine Wartung eingetragen.                |
+--------------------+-------------------------------------------------+
| [same nth weekday  | Analog zur vorherigen Option, allerdings wird   |
| (from              | jetzt vom Ende des Monats gerechnet, also so    |
| end)]{.guihint}    | etwas wie „jeder letzte Freitag im Monat".      |
+--------------------+-------------------------------------------------+
| [same day of the   | Bei dieser Variante bleibt der Wochentag        |
| month]{.guihint}   | unberücksichtigt. Hier geht es nur darum, der   |
|                    | wievielte Tag im Monat es ist. Wenn also das    |
|                    | Startdatum am 5. eines Monats ist, so wird die  |
|                    | Wartungszeit fortan jeden 5. eines Monats       |
|                    | wiederholt.                                     |
+--------------------+-------------------------------------------------+
:::::::

::::::::: sect3
#### []{#_anlegen_mittels_regeln .hidden-anchor .sr-only}Anlegen mittels Regeln {#heading__anlegen_mittels_regeln}

::: paragraph
Eine alternative, sehr elegante Methode für das Einrichten von
periodischen Wartungszeiten ist das Anlegen über
[Regeln.](glossar.html#rule) Mithilfe von
[Host-Merkmalen](glossar.html#host_tag) können Sie damit z.B. Dinge
bestimmen wie: *Jeder produktive Windows-Server bekommt jeden Sonntag
von 22:00 bis 22:10 Uhr eine Wartungszeit.*
:::

::: paragraph
Zwar könnten Sie fast das Gleiche erreichen, indem Sie mit der
Host-Suche alle betroffenen Server finden und die Wartungszeit dann über
ein Kommando eintragen. Aber dies funktioniert natürlich nur für
**bestehende** Server.
:::

::: paragraph
Wird in Zukunft ein neuer Host ins Monitoring aufgenommen, so fehlt ihm
dieser Eintrag. Wenn Sie stattdessen mit Regeln arbeiten, haben Sie
dieses Problem nicht mehr. Ein weiterer Vorteil von Regeln ist, dass Sie
die Wartungsrichtlinie später ändern können --- einfach durch Anpassung
der Regeln.
:::

::: paragraph
Die Regeln für die regelmäßigen Wartungszeiten finden Sie unter [Setup
\> Hosts \> Host monitoring rules \> Recurring downtimes for
hosts]{.guihint} beziehungsweise [Setup \> Services \> Service
monitoring rules \> Recurring downtimes for services.]{.guihint}
:::

:::: imageblock
::: content
![Festlegung einer regelmäßigen Wartungszeit mittels
Regel.](../images/basics_downtimes_recurring_rule.png)
:::
::::
:::::::::
:::::::::::::::::

:::::::::::: sect2
### []{#advanced_options .hidden-anchor .sr-only}2.2. Weitere Optionen {#heading_advanced_options}

::: paragraph
Für die Definition von Wartungszeiten gibt es neben den eben
beschriebenen regelmäßigen Wartungszeiten noch weitere Möglichkeiten.
Diese finden Sie in den [Advanced options:]{.guihint}
:::

:::: imageblock
::: content
![Die erweiterten Optionen für
Wartungszeiten.](../images/basics_downtimes_advanced.png)
:::
::::

::: paragraph
Die Option [Only for hosts: Set child hosts in downtime]{.guihint} ist
für Router und Switche nützlich, aber z.B. auch für
Virtualisierungs-Hosts. Checkmk wird so auch automatisch für alle Hosts
eine Wartungszeit setzen, welche über den betroffenen Host direkt (oder
bei ausgewähltem [Include indirectly connected hosts
(recursively)]{.guihint} auch indirekt) erreichbar sind.
:::

::: paragraph
Mit der Option [Only start downtime if host/service goes
DOWN/UNREACH...​]{.guihint} beginnt die Wartungszeit nicht automatisch
zum angegebenen Zeitpunkt, sondern erst dann, wenn der Host tatsächlich
in einen Problemzustand eintritt. Diese Option ist z.B. nützlich, wenn
Sie wissen, dass ein Host für ein paar Minuten [DOWN]{.hstate1} gehen
wird, aber die exakte Uhrzeit nicht vorhersagen können.
:::

::: paragraph
Beispiel: Sie definieren eine Wartungszeit von 14:00 bis 16:00 Uhr und
aktivieren die Option [Only start downtime if host/service goes
DOWN/UNREACH during the defined start and end time]{.guihint} mit einer
maximalen Dauer von 30 Minuten. Um 14:00 Uhr wird die Wartungszeit noch
nicht automatisch aktiv, sondern ist nur in Wartestellung. Sobald der
Host auf [DOWN]{.hstate1} oder [UNREACH]{.hstate2} geht, beginnt die
Wartungszeit und das Pausenzeichen erscheint. Sie dauert jetzt genau die
bei der Option angegebene Zeit --- egal wie sich der tatsächliche
Zustand vom Host entwickelt und ggf. auch über die eingestellte Endzeit
der Wartungszeit hinaus.
:::

:::: imageblock
::: content
![Einstellung einer flexiblen
Wartungszeit.](../images/basics_downtimes_flexible.png)
:::
::::

::: paragraph
Die Start-/Endzeit ist also bei den flexiblen Wartungszeiten nur das
Zeitfenster, innerhalb dessen die Wartungszeit beginnt. Wenn innerhalb
dieses Zeitfensters kein Problemzustand eintritt, so wird die
Wartungszeit einfach ausgelassen. Alles für Hosts gesagte gilt natürlich
für Services analog.
:::
::::::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#activate .hidden-anchor .sr-only}3. Wartungszeiten aktivieren {#heading_activate}

::::::: sectionbody
::: paragraph
Mit einem Klick auf [Schedule downtime on service]{.guihint} bzw.
[Schedule downtime on host]{.guihint} aktivieren Sie die soeben
definierten Einstellungen für die betreffenden Services bzw. Hosts.
:::

::: paragraph
Haben Sie gerade Wartungszeiten für Services geplant, beispielsweise in
der Ansicht [Services of Host,]{.guihint} können Sie zudem mit einem
Klick auf [Schedule downtime on host]{.guihint} dafür sorgen, dass sich
die Wartungszeiten nicht auf die Services, sondern stattdessen direkt
auf den zugehörigen Host beziehen.
:::

:::: imageblock
::: content
![Bestätigung, dass die Wartungszeit tatsächlich auf den Host angewendet
werden soll.](../images/basics_downtimes_schedule_host.png)
:::
::::
:::::::
::::::::

:::::::::: sect1
## []{#edit_remove .hidden-anchor .sr-only}4. Wartungszeiten ändern und löschen {#heading_edit_remove}

::::::::: sectionbody
::: paragraph
Für die Wartungszeiten gibt es in Checkmk eine eigene Ansicht, die Sie
erreichen über [Monitor \> Overview \> Scheduled downtimes:]{.guihint}
:::

:::: imageblock
::: content
![Ansicht der
Wartungszeiten.](../images/basics_downtimes_downtimeslist.png)
:::
::::

::: paragraph
Wie in jeder Ansicht können Sie über die [![Symbol zur Anzeige der
Filterleiste.](../images/icons/icon_filter.png)]{.image-inline} Filter
die Auswahl einschränken. Über die [![Symbol zur Anzeige eines
Kommandos.](../images/icons/icon_commands.png)]{.image-inline} Kommandos
in dieser Ansicht können Sie eine oder mehrere Wartungszeiten entfernen
und sogar auch nachträglich ändern (nur kommerzielle Editionen), z.B.
wenn diese verlängert werden müssen, da die eigentliche Wartung länger
dauert als zunächst vorgesehen.
:::

:::: imageblock
::: content
![Änderung einer
Wartungszeit.](../images/basics_downtimes_editdowntimes.png)
:::
::::
:::::::::
::::::::::

::::::: sect1
## []{#history .hidden-anchor .sr-only}5. History {#heading_history}

:::::: sectionbody
::: paragraph
Die Ansicht [Monitor \> History \> Downtime history]{.guihint} zeigt
nicht die aktuellen Wartungszeiten, sondern deren Geschichte --- also
alle Ereignisse, bei denen eine Wartungszeit begonnen hat oder endete
(entweder durch ein natürliches Ende oder durch das Löschen per
Kommando).
:::

:::: imageblock
::: content
![Übersicht vergangener
Wartungszeiten.](../images/basics_downtimes_downtimes_history.png)
:::
::::
::::::
:::::::

::::::::::: sect1
## []{#availability .hidden-anchor .sr-only}6. Wartungszeiten und Verfügbarkeit {#heading_availability}

:::::::::: sectionbody
::: paragraph
Wie eingangs erwähnt, haben Wartungszeiten eine Auswirkung auf die
Berechnung der [Verfügbarkeitsanalyse.](availability.html) Standardmäßig
werden alle Wartungszeiten in einen eigenen „Topf" gerechnet und in der
Spalte [Downtime]{.guihint} angezeigt.
:::

:::: imageblock
::: content
![Verfügbarkeitsanalyse der
Hosts.](../images/basics_downtimes_availability_list.png)
:::
::::

::: paragraph
Wie genau Wartungszeiten verrechnet werden sollen, können Sie über
[Availability \> Change computation options]{.guihint} einstellen:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Auswahl zur Berücksichtigung von
Wartungszeiten.](../images/basics_downtimes_availability_option.png){width="50%"}
:::
::::

+--------------------+-------------------------------------------------+
| [Honor scheduled   | Wartungszeiten werden in die                    |
| do                 | Verfügbarkeitsgrafiken eingerechnet und als     |
| wntimes]{.guihint} | eigenständige Spalte angezeigt. Das ist das     |
|                    | Standardverhalten.                              |
+--------------------+-------------------------------------------------+
| [Exclude scheduled | Wartungszeiten werden bei der Berechnung der    |
| do                 | 100 % komplett ausgeklammert. Alle prozentualen |
| wntimes]{.guihint} | Angaben über die Verfügbarkeit beziehen sich    |
|                    | also nur auf die restlichen Zeiten, quasi zur   |
|                    | Beantwortung der Frage: *Wie viel Prozent der   |
|                    | Nicht-Wartungszeit war das Objekt verfügbar?*   |
+--------------------+-------------------------------------------------+
| [Ignore scheduled  | Wartungszeiten werden überhaupt nicht           |
| do                 | berücksichtigt, sondern nur der tatsächliche    |
| wntimes]{.guihint} | Status, den das Objekt jeweils hatte.           |
+--------------------+-------------------------------------------------+

::: paragraph
Zusätzlich gibt es noch unter [Phases]{.guihint} die Option [Treat
phases of UP/OK as non-downtime.]{.guihint} Wenn diese ausgewählt ist,
dann werden Zeiten, in denen ein Objekt in einer Wartung, aber trotzdem
gleichzeitig [OK]{.state0} bzw. [UP]{.hstate0} ist, **nicht** als
Wartungszeit gewertet. Somit geht in die Berechnung nur derjenige Teil
der Wartungszeiten ein, der **tatsächlich** mit einem Ausfall verbunden
war.
:::
::::::::::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
