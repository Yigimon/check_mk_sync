:::: {#header}
# Quittierung von Problemen

::: details
[Last modified on 26-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/basics_ackn.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::: {#content}
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
[Grundlagen des Monitorings mit Checkmk](monitoring_basics.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Checkmk unterscheidet bei Problemen (also [DOWN]{.hstate1},
[UNREACH]{.hstate2}, [WARN]{.state1}, [CRIT]{.state2} oder
[UNKNOWN]{.state3}) zwei mögliche Zustände: **unbehandelt** und [![icon
ack](../images/icons/icon_ack.png)]{.image-inline} **bearbeitet**. Bei
bearbeiteten (quittierten) Problemen geht man davon aus, dass diese
bereits zur Kenntnis genommen wurden und sich jemand darum kümmert.
:::

::: paragraph
Wenn ein Problem quittiert ist, dann
:::

::: ulist
- wird dieses mit einem [![icon
  ack](../images/icons/icon_ack.png)]{.image-inline} Symbol
  gekennzeichnet,

- taucht es im Snapin [Overview](user_interface.html#overview) nicht
  mehr bei [Unhandled]{.guihint} auf,

- werden keine wiederholten [Benachrichtigungen](notifications.html)
  mehr versendet.
:::

::: paragraph
Ferner können Sie in Ansichten mit dem [![Symbol zur Anzeige der
Filterleiste.](../images/icons/icon_filter.png)]{.image-inline} Filter
[Problem acknowledged]{.guihint} gezielt nur quittierte oder
unquittierte Probleme anzeigen lassen.
:::
:::::::
::::::::

::::::::: sect1
## []{#procedure .hidden-anchor .sr-only}2. Ablauf einer Quittierung {#heading_procedure}

:::::::: sectionbody
::: paragraph
Probleme werden über [Kommandos](commands.html) auf den betroffenen
Hosts/Services quittiert. Über den gleichen Weg können Sie Quittierungen
auch wieder entfernen:
:::

:::: imageblock
::: content
![basics ackn acknowledge](../images/basics_ackn_acknowledge.png)
:::
::::

::: paragraph
Hinweise zu den Optionen:
:::

+--------------------+-------------------------------------------------+
| [                  | Sie können an dieser Stelle auch eine URL in    |
| Comment]{.guihint} | der Form `https://www.example.com` eintragen,   |
|                    | die dann als anklickbarer Link zur Verfügung    |
|                    | steht.                                          |
+--------------------+-------------------------------------------------+
| [Expire            | Kommerzielle Editionen: Mit dieser Option       |
| on]{.guihint}      | setzen Sie eine Gültigkeitsdauer für die        |
|                    | Quittierung. Nach dem Erreichen der             |
|                    | eingestellten Zeit verschwindet die Quittierung |
|                    | von selbst, auch wenn der Host/Service nicht    |
|                    | wieder auf [OK]{.state0} bzw. [UP]{.hstate0}    |
|                    | geht.                                           |
+--------------------+-------------------------------------------------+
| [Ignore status     | Normalerweise gilt eine Quittierung immer nur   |
| changes until      | bis zum **nächsten Zustandswechsel**. Wenn also |
| services/hosts are | z.B. ein Service im Zustand [WARN]{.state1}     |
| OK/UP again        | quittiert wird und später nach [CRIT]{.state2}  |
| (                  | wechselt, so wird die Quittierung automatisch   |
| sticky)]{.guihint} | entfernt. Durch das Aktivieren dieser Option    |
|                    | bleibt die Quittierung solange erhalten, bis    |
|                    | der Zustand [OK]{.state0} bzw. [UP]{.hstate0}   |
|                    | erreicht wird.                                  |
+--------------------+-------------------------------------------------+
| [Keep comment      | Mit dieser Option wird Ihr Kommentar nicht      |
| after              | automatisch gelöscht, wenn die Quittierung      |
| acknowledgment     | verschwindet oder entfernt wird. So erstellte   |
| expires            | Kommentare müssen Sie später manuell löschen,   |
| (persistent        | wie im [nächsten Kapitel](#gui) beschrieben.    |
| c                  |                                                 |
| omment)]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
| [Notify affected   | Löst Benachrichtigungen vom Typ                 |
| users if           | `ACKNOWLEDGEMENT` an alle Kontakte des          |
| notification rules | Hosts/Services aus. So wissen Ihre Kollegen     |
| are in place (send | Bescheid.                                       |
| notific            |                                                 |
| ations)]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+

::: paragraph
Sie können die Voreinstellungen dieser Optionen dauerhaft über [Edit
defaults]{.guihint} verändern. Fußläufig erreichen Sie diese
Voreinstellung über [Setup \> General \> Global settings \> User
interface \> Acknowledge problems.]{.guihint}
:::
::::::::
:::::::::

::::::::: sect1
## []{#gui .hidden-anchor .sr-only}3. Quittierungen in der GUI {#heading_gui}

:::::::: sectionbody
::: paragraph
In der Checkmk-Oberfläche gibt es mehrere Möglichkeiten, um
Quittierungen anzuzeigen.
:::

::: paragraph
In allen Ansichten von Host und Services werden quittierte Probleme
durch zwei Symbole gekennzeichnet:
:::

+--------------------+-------------------------------------------------+
| [![icon            | Dieses Symbol kennzeichnet die Quittierung.     |
| ack](../images     |                                                 |
| /icons/icon_ack.pn |                                                 |
| g)]{.image-inline} |                                                 |
+--------------------+-------------------------------------------------+
| [![icon            | Wenn Sie dieses Symbol anklicken, dann wird die |
| comm               | Liste mit Quittierungskommentaren angezeigt.    |
| ent](../images/ico |                                                 |
| ns/icon_comment.pn |                                                 |
| g)]{.image-inline} |                                                 |
+--------------------+-------------------------------------------------+

::: paragraph
Über [Monitor \> Overview \> Comments]{.guihint} gelangen Sie zur Liste
aller Kommentare auf Hosts und Services --- darunter auch diejenigen,
die durch Quittierungen entstanden sind. Kommentare können über
[Kommandos](commands.html) gelöscht werden.
:::

:::: imageblock
::: content
![basics ackn comments](../images/basics_ackn_comments.png)
:::
::::
::::::::
:::::::::
:::::::::::::::::::::::::::::
