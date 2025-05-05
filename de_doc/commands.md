:::: {#header}
# Kommandos

::: details
[Last modified on 22-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/commands.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::: {#content}
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
[Quittierung von Problemen](basics_ackn.html)
[Wartungszeiten](basics_downtimes.html)
[Benachrichtigungen](notifications.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::: sect1
## []{#command_execute .hidden-anchor .sr-only}1. Ein Kommando ausführen {#heading_command_execute}

:::::::::::::::: sectionbody
::: paragraph
Mit Kommandos auf Hosts, Services und anderen Objekten können Sie in den
Ablauf des Monitorings eingreifen. Am häufigsten werden die Kommandos
zum Quittieren von Problemen und zum Setzen von
[Wartungszeiten](glossar.html#scheduled_downtime) verwendet. Aber es
gibt eine Reihe von weiteren Kommandos, von denen manche dem
Administrator vorbehalten sind. Welche Kommandos in einer
[Tabellenansicht](glossar.html#view) (*view*) genau zur Verfügung
stehen, hängt also von Ihrer Berechtigung
([Rolle](wato_user.html#roles)) ab und auch von der Art der angezeigten
Objekte.
:::

::: paragraph
Zu den Kommandos gelangen Sie in einer Ansicht über das Menü
[Commands]{.guihint}. Bei Auswahl eines der Kommandos wird unterhalb der
Menüleiste bzw. Aktionsleiste ein Bereich mit den Parametern des
Kommandos eingeblendet. Bei Auswahl von [Acknowledge problems]{.guihint}
sieht das so aus:
:::

:::: imageblock
::: content
![Die Parameter zur Ausführung eines
Kommandos.](../images/commands_acknowledge.png)
:::
::::

::: paragraph
Manche Kommandos brauchen weitere Angaben, wie z.B. einen Kommentar für
die Quittierung. Das Drücken des Knopfs [Acknowledge problems]{.guihint}
öffnet einen Bestätigungsdialog:
:::

:::: imageblock
::: content
![Bestätigungsdialog vor Ausführung des
Kommandos.](../images/commands_confirm_acknowledgement.png)
:::
::::

::: paragraph
Wenn Sie die Nachfrage bestätigen, wird das gewählte Kommando auf
**allen** gerade in der Ansicht gezeigten Objekten ausgeführt. Wenn Sie
vorher eine Auswahl treffen möchten, haben Sie drei Möglichkeiten:
:::

::: ulist
- Sie gehen in die Detailansicht eines Hosts oder eines Services, um nur
  auf diesem ein Kommando auszuführen.

- Sie setzen in der Ansicht [![icon
  filter](../images/icons/icon_filter.png)]{.image-inline}
  [Filter]{.guihint}, um die Liste der gezeigten Objekte einzuschränken.

- Sie aktivieren die Checkboxen mit [![Symbol zur Anzeige eines
  aktivierten
  Schalters.](../images/icons/icon_toggle_on.png)]{.image-inline} [Show
  checkboxes]{.guihint}.
:::

::: paragraph
Bei aktivierten Checkboxen erscheint eine zusätzliche Spalte ganz links
in der Ansicht, in der Sie die Objekte auswählen können, für die das
Kommando ausgeführt werden soll:
:::

:::: imageblock
::: content
![Service-Liste mit eingeschalteten Checkboxen in der ersten
Spalte.](../images/commands_list_checkboxes.png)
:::
::::

::: paragraph
Durch einen Klick auf das kleine Kreuz in der Titelzeile können Sie alle
Checkboxen der ganzen Tabelle ein- oder ausschalten.
:::
::::::::::::::::
:::::::::::::::::

:::::::::: sect1
## []{#commands .hidden-anchor .sr-only}2. Die Kommandos im Überblick {#heading_commands}

::::::::: sectionbody
::: paragraph
Die verfügbaren Kommandos finden Sie im Menü [Commands]{.guihint}:
:::

:::: imageblock
::: content
![Das Menü \'Commands\' im
Show-more-Modus.](../images/commands_menu_more.png){width="40%"}
:::
::::

::: paragraph
Zur Erinnerung: Verfügbar heißt, dass die Kommandos nach Ansicht und
Berechtigung unterschiedlich sein können. Beachten Sie außerdem, dass
Sie sich in diesem Menü [weniger oder mehr
anzeigen](intro_gui.html#show_less_more) lassen können.
:::

::: paragraph
Die wichtigsten Kommandos in Kurzfassung:
:::

+------------------------+---------------------------------------------+
| [Acknowledge           | [Probleme quittieren.](basics_ackn.html)\   |
| problems]{.guihint}    | Quittierungen entfernen Sie mit dem         |
|                        | Kommando [Remove                            |
|                        | acknowledgments.]{.guihint}                 |
+------------------------+---------------------------------------------+
| [Schedule              | [Wartungszeiten](basics_downtimes.html)     |
| downtimes]{.guihint}   | (*scheduled downtimes*) setzen.\            |
|                        | Wartungszeiten entfernen Sie mit dem        |
|                        | Kommando [Remove downtimes.]{.guihint}      |
+------------------------+---------------------------------------------+
| [Fake check            | Die Ergebnisse von Checks manuell           |
| results]{.guihint}     | bestimmen, also die Ausgabe,                |
|                        | Performance-Daten oder schlicht den Status  |
|                        | eines Hosts oder Services. Nützlich ist das |
|                        | beispielsweise, um die Auswirkungen         |
|                        | unterschiedlicher Ausgaben und Status auf   |
|                        | Monitoring, Ansichten oder auch             |
|                        | [Ben                                        |
|                        | achrichtigungen](glossar.html#notification) |
|                        | zu testen. Nach einem mit diesem Kommando   |
|                        | initiierten Zustandswechsel sollte dann     |
|                        | beim nächsten regulären Check der           |
|                        | ursprüngliche Zustand wiederhergestellt     |
|                        | werden.\                                    |
|                        | **Hinweis:** Für den Test von               |
|                        | Benachrichtigungen ist dieses Kommando nur  |
|                        | bedingt einsetzbar, da ein Zustandswechsel  |
|                        | oft nur zu einen [Soft                      |
|                        | State](                                     |
|                        | notifications.html#repeated_check_attempts) |
|                        | führt, für den keine Benachrichtigungen     |
|                        | erzeugt werden. Außerdem kann der           |
|                        | Host/Service bei häufigen Zustandswechseln  |
|                        | nach einiger Zeit [![Symbol zur Anzeige des |
|                        | unstetigen                                  |
|                        | Zustands.](../imag                          |
|                        | es/icons/icon_flapping.png)]{.image-inline} |
|                        | [unstetig](notifications.html#flapping)     |
|                        | werden. Weitere Zustandswechsel lösen dann  |
|                        | ebenfalls keine Benachrichtigungen mehr     |
|                        | aus. Nutzen Sie daher für den [Test von     |
|                        | Benachrichtigunge                           |
|                        | n](notifications.html#notification_testing) |
|                        | [Test notifications.]{.guihint}             |
+------------------------+---------------------------------------------+
| [Reschedule active     | [Aktive Checks](glossar.html#active_check)  |
| checks]{.guihint}      | außerhalb des üblichen Rhythmus manuell neu |
|                        | ansetzen, zum Beispiel die                  |
|                        | Hardware-/Software-Inventur. Bei vielen     |
|                        | Hosts könnte dies jedoch kurzfristig zu     |
|                        | Spitzen bei der CPU-Auslastung führen. Um   |
|                        | dem entgegen zu wirken, lassen sich die     |
|                        | Checks über einen einzugebenden Zeitraum in |
|                        | Minuten gleichmäßig verteilen.              |
+------------------------+---------------------------------------------+
| [Send custom           | Benutzerdefinierte Benachrichtigungen       |
| n                      | erstellen. Dadurch wird kein                |
| otification]{.guihint} | Zustandswechsel erzeugt. Mit diesem         |
|                        | Kommando erzeugte Benachrichtigungen sind   |
|                        | vom speziellen Typ `CUSTOM` und können per  |
|                        | Benachrichtigungsregeln auch speziell       |
|                        | ausgewertet werden.                         |
+------------------------+---------------------------------------------+
| [Add                   | Kommentar hinzufügen. Ein Kommentar wird in |
| comment]{.guihint}     | einer Ansicht mit dem Symbol [![Symbol für  |
|                        | einen                                       |
|                        | Kommentar.](../ima                          |
|                        | ges/icons/icon_comment.png)]{.image-inline} |
|                        | gekennzeichnet. Eine Übersicht aller        |
|                        | Kommentare erhalten Sie über [Monitor \>    |
|                        | Overview \> Comments.]{.guihint} Dort       |
|                        | finden Sie auch das Kommando [Delete        |
|                        | comments]{.guihint} zum Entfernen von       |
|                        | Kommentaren.                                |
+------------------------+---------------------------------------------+
| [Archive events of     | Alle offenen Ereignisse (*events*) der      |
| hosts]{.guihint}       | [Event Console](glossar.html#ec)            |
|                        | archivieren.\                               |
|                        | Weitere Kommandos für die Event Console     |
|                        | werden im zugehörigen                       |
|                        | [Artikel](ec.html#commands) besprochen.     |
+------------------------+---------------------------------------------+
| [Freeze                | Aggregate der [Business Intelligence        |
| a                      | (BI)](glossar.html#bi) einfrieren. Mehr     |
| ggregations]{.guihint} | dazu finden Sie im Artikel zur              |
|                        | [BI.](bi.html#freeze)                       |
+------------------------+---------------------------------------------+

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In die Kommentare zu [Acknowledge |
|                                   | problems]{.guihint}, [Schedule    |
|                                   | downtimes]{.guihint} und [Add     |
|                                   | comment]{.guihint} können Sie     |
|                                   | eine URL der Form                 |
|                                   | `https://www.example.com`         |
|                                   | eintragen. Diese wird dann        |
|                                   | automatisch in einen Link         |
|                                   | umgewandelt.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::
::::::::::
::::::::::::::::::::::::::::::::
