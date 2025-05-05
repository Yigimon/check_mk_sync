:::: {#header}
# Checkmk im Monitoring

::: details
[Last modified on 26-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_monitor.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Das Monitoring feinjustieren](intro_finetune.html) [Quittierung von
Problemen](basics_ackn.html) [Wartungszeiten](basics_downtimes.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#monitoring .hidden-anchor .sr-only}1. Wichtige Aufgaben im Monitoring {#heading_monitoring}

::::::: sectionbody
::: paragraph
Sie haben Hosts aufgenommen und sich wichtige Werkzeuge angesehen: Jetzt
können Sie loslegen mit dem eigentlichen Monitoring. Denn der Sinn von
Checkmk ist es ja nicht, sich ständig mit der Konfiguration zu befassen,
sondern eine Unterstützung beim IT-Betrieb zu leisten.
:::

::: paragraph
Zwar zeigen Ihnen bereits die standardmäßig verfügbaren Ansichten oder
z.B. das Snapin [Overview]{.guihint} sehr genau, wie viele und welche
Probleme es gerade gibt. Zur Abbildung eines Arbeitsablaufs
(*workflow*), d.h. dem „richtigen Arbeiten" mit dem Monitoring,
benötigen Sie aber noch etwas mehr Informationen über:
:::

::: ulist
- die Quittierung von Problemen

- das Senden von Benachrichtigungen im Falle von Problemen

- das Setzen von Wartungszeiten
:::

::: paragraph
Dieses Kapitel befasst sich nur mit dem ersten und dem letzten Punkt.
Die Benachrichtigungen behandelt später ein [eigenes
Kapitel](intro_notifications.html), da für dieses Thema einige spezielle
Vorbereitungen zu treffen sind.
:::
:::::::
::::::::

:::::::::::::::::::::: sect1
## []{#ack .hidden-anchor .sr-only}2. Probleme quittieren {#heading_ack}

::::::::::::::::::::: sectionbody
::: paragraph
Im [[Overview]{.guihint}](intro_tools.html#overview) hatten Sie schon
gesehen, dass Probleme entweder unbehandelt (*unhandled*) oder
bearbeitet (*handled*) sein können. Das Quittieren ist nun genau die
Aktion, die aus einem unbehandelten Problem ein bearbeitetes macht. Das
muss nicht unbedingt heißen, dass sich wirklich jemand darum kümmert.
Manche Probleme verschwinden ja auch von selbst wieder. Aber das
Quittieren hilft, einen Überblick zu behalten und einen Workflow zu
etablieren.
:::

::: paragraph
Was passiert beim Quittieren eines Problems genau?
:::

::: ulist
- Im [Overview]{.guihint} wird das Problem in der Spalte
  [Unhandled]{.guihint} beim Host oder Service nicht mehr gezählt.

- Die Dashboards listen das Problem ebenfalls nicht mehr auf.

- Das Objekt (Host oder Service) wird in Tabellenansichten mit dem
  Symbol [![Symbol zur Anzeige der
  Quittierung.](../images/icons/icon_ack.png)]{.image-inline} markiert.

- Ein Eintrag erfolgt in die Objekt-History, sodass die Aktion später
  nachvollzogen werden kann.

- Wiederholte Benachrichtigungen (falls konfiguriert) werden gestoppt.
:::

::: paragraph
Wie quittieren Sie nun ein Problem?
:::

::: paragraph
Rufen Sie zunächst eine Tabellenansicht auf, in der das Problem
enthalten ist. Am einfachsten ist der Einstieg über die vordefinierten
Ansichten im Menü [Monitor \> Problems \> Host problems]{.guihint} oder
[Service problems]{.guihint}. Zu diesen gelangen Sie übrigens fast noch
schneller, wenn Sie im [Overview]{.guihint} die Zahl der Probleme
anklicken.
:::

::: paragraph
Sie können in der Liste den problematischen Host oder Service anklicken
und dann auf der Seite mit den Details die Quittierung nur für diesen
einzelnen Host oder Service durchführen. Wir bleiben aber auf der Seite
mit der Liste, da Sie hier alle Optionen haben, um nur ein Problem oder
gleich mehrere auf einmal zu quittieren.
:::

::: paragraph
Es ist gar nicht so selten, dass Sie eine Reihe (zusammengehöriger)
Probleme auf einmal quittieren wollen. Das geht einfach, indem Sie sich
mit einem Klick auf [Show checkboxes]{.guihint} eine neue erste Spalte
in der Liste einblenden lassen, die eine Checkbox vor jeder Zeile
enthält. Die Checkboxen sind alle nicht markiert, denn die Auswahl
treffen Sie: Markieren Sie die Checkbox für jeden gewünschten Host oder
Service.
:::

::: paragraph
**Wichtig:** Wenn Sie auf einer Seite mit einer Liste eine Aktion
durchführen, ohne dass Sie Checkboxen eingeblendet haben, dann wird
diese Aktion für **alle** Listeneinträge durchgeführt.
:::

::: paragraph
Klicken Sie nun auf [Acknowledge problems]{.guihint}. Dies blendet am
Beginn der Seite den folgenden Bereich ein:
:::

:::: imageblock
::: content
![Dialog zum Quittieren von
Problemen.](../images/intro_command_acknowledge.png)
:::
::::

::: paragraph
Tragen Sie einen Kommentar ein und klicken Sie auf [Acknowledge
problems]{.guihint} --- und mit der Bestätigung der „Sind Sie
sicher?"-Frage ...​
:::

:::: imageblock
::: content
![Dialog zur Bestätigung der
Quittierung.](../images/intro_really_acknowledge.png)
:::
::::

::: paragraph
... gelten alle vorher ausgewählten Probleme als quittiert.
:::

::: paragraph
Abschließend noch einige Hinweise:
:::

::: ulist
- Mit dem Knopf [Remove acknowledgement]{.guihint} können Sie eine
  Quittierung auch wieder entfernen.

- Quittierungen können automatisch ablaufen. Dazu dient die Option
  [Expire on]{.guihint}, die aber nur in den kommerziellen Editionen
  wirksam ist.
:::

::: paragraph
Weitere Informationen zu allen Quittierungsoptionen erhalten Sie im
[Artikel über die Quittierung.](basics_ackn.html)
:::
:::::::::::::::::::::
::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#downtimes .hidden-anchor .sr-only}3. Wartungszeiten einrichten {#heading_downtimes}

::::::::::::::::::: sectionbody
::: paragraph
Manchmal gehen Dinge nicht aus Versehen kaputt, sondern mit
Absicht --- oder etwas vorsichtiger ausgedrückt, ein Ausfall wird
absichtlich in Kauf genommen. Denn jedes Stück Hard- oder Software muss
gelegentlich gewartet werden, und während der dazu notwendigen
Umbauarbeiten wird der betroffene Host oder Service im Monitoring sehr
wahrscheinlich in den Zustand [DOWN]{.hstate1} oder [CRIT]{.state2}
gehen.
:::

::: paragraph
Für diejenigen, die auf Probleme in Checkmk reagieren sollen, ist es
dabei natürlich sehr wichtig, dass sie über geplante Ausfälle Bescheid
wissen und nicht wertvolle Zeit mit „Fehlalarmen" verlieren. Um dies zu
gewährleisten, kennt Checkmk das Konzept der (geplanten) Wartungszeit
(in Englisch *scheduled downtime* oder kürzer *downtime*).
:::

::: paragraph
Wenn also für ein Objekt eine Wartung ansteht, können Sie dieses in den
Wartungszustand versetzen --- entweder sofort oder aber auch für einen
Zeitraum in der Zukunft.
:::

::: paragraph
Die Einrichtung von Wartungszeiten ist sehr ähnlich zum Ablauf der
Quittierung von Problemen: Sie starten wieder mit einer Tabellenansicht,
in der das gewünschte Objekt (Host oder Service) enthalten ist, für das
Sie eine Wartungszeit einrichten wollen. Zum Beispiel können Sie im
[Overview]{.guihint} auf die Zahl der Hosts oder der Services klicken,
um sich alle Objekte auflisten zu lassen.
:::

::: paragraph
In der dann angezeigten Liste blenden Sie mit [Show
checkboxes]{.guihint} die Checkboxen ein und wählen alle relevanten
Einträge aus.
:::

::: paragraph
Klicken Sie nun [Schedule downtimes.]{.guihint} Dies blendet am Beginn
der Seite den folgenden Bereich ein:
:::

::::: imageblock
::: content
![Dialog zur Definition einer
Wartungszeit.](../images/intro_command_downtime.png)
:::

::: title
Der Dialog zur Wartungszeit eines Hosts
:::
:::::

::: paragraph
Bei den Wartungszeiten gibt es einen ganzen Haufen von Optionen. Einen
Kommentar müssen Sie in jedem Fall eingeben. Für die Festlegung des
Zeitraums gibt es zahlreiche unterschiedliche Möglichkeiten --- vom
einfachen [2 hours]{.guihint}, welches die Wartung **ab sofort**
definiert, bis hin zu der Angabe eines expliziten Zeitraums, mit dem
auch eine Wartung in der Zukunft definiert werden kann. Im Gegensatz zu
den Quittierungen haben Wartungszeiten grundsätzlich ein Ende, das
vorher festgelegt wird.
:::

::: paragraph
Hier noch ein paar Hinweise:
:::

::: ulist
- Wenn Sie einen Host in die Wartung schicken, werden automatisch auch
  alle seine Services mitgeschickt. Sparen Sie sich daher die Arbeit,
  dies doppelt zu tun.

- Die **flexiblen** Wartungszeiten beginnen tatsächlich erst dann, wenn
  das Objekt in einen anderen Zustand als [OK]{.state0} wechselt.

- Wenn Sie eine der kommerziellen Editionen nutzen, können Sie auch
  **regelmäßige** Wartungszeiten definieren (z.B. wegen eines
  obligatorischen Reboots einmal in der Woche).

- Einen Überblick über aktuell laufende Wartungszeiten erhalten Sie in
  [Monitor \> Overview \> Scheduled downtimes]{.guihint}.
:::

::: paragraph
Die Auswirkungen einer Wartungszeit sind folgende:
:::

::: ulist
- Im [Overview]{.guihint} tauchen die betroffenen Hosts und Services
  nicht mehr als Probleme auf.

- In Tabellenansichten wird der ausgewählte Host oder Service mit dem
  [![Symbol zur Anzeige der
  Wartungszeit.](../images/icons/icon_downtime.png)]{.image-inline}
  Leitkegel markiert. Wird ein Host mit allen seinen Services in die
  Wartung geschickt, erhalten die Services das [![Symbol zur Anzeige
  einer abgeleiteten Wartungszeit bei einem
  Service.](../images/icons/icon_derived_downtime.png)]{.image-inline}
  blaue Pause-Zeichen.

- Für diese Objekte wird die Benachrichtigung über Probleme während der
  Wartung abgeschaltet.

- Zu Beginn und Ende einer Wartungszeit wird eine spezielle
  Benachrichtigung ausgelöst.

- In der [Verfügbarkeitsanalyse](availability.html) werden geplante
  Wartungszeiten gesondert berücksichtigt.
:::

::: paragraph
Eine detaillierte Beschreibung zu allen genannten und weiteren Aspekten
finden Sie im [Artikel über Wartungszeiten](basics_downtimes.html).
:::

::: paragraph
[Weiter geht es mit der Feinjustierung](intro_finetune.html)
:::
:::::::::::::::::::
::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::
