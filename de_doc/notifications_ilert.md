:::: {#header}
# Benachrichtigungen per ilert

::: details
[Last modified on 23-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_ilert.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::: {#content}
::::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Benachrichtigungen](notifications.html)
:::
::::
:::::

::: paragraph
[ilert](https://www.ilert.com/de){target="_blank"} ist eine Plattform
für Alarmierung, Rufbereitschaften und Statusseiten, die Alarme aus
verschiedenen Quellen sammelt und weiterverarbeiten kann. Checkmk kann
als eine dieser Alarmquellen genutzt werden. Die Benachrichtigungen von
Checkmk werden in ilert als Alarme (*alerts*) angezeigt, für die
wiederum Aktionen festgelegt werden können, wie die die Einrichtung von
Arbeitsabläufen (*workflows*) oder die Weiterleitung per E-Mail und an
andere Incident-Management-Systeme wie z.B. Jira oder TOPdesk.
:::

::: paragraph
Die Anbindung erfolgt über einen API-Schlüssel, den Sie in ilert für
eine Alarmquelle der Integration Checkmk erstellen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wie Sie nach erfolgter Anbindung  |
|                                   | die Alarme in ilert               |
|                                   | weiterverarbeiten können,         |
|                                   | erfahren Sie in unserem           |
|                                   | [Blog-Artikel.](https:/           |
|                                   | /checkmk.com/de/blog/setting-up-c |
|                                   | heckmk-in-ilert){target="_blank"} |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::
:::::::::::

:::::: sect1
## []{#config_ilert .hidden-anchor .sr-only}1. ilert konfigurieren {#heading_config_ilert}

::::: sectionbody
::: paragraph
In ilert erstellen Sie für Checkmk eine neue Alarmquelle (*alert
source*) und erhalten zum Abschluss der Einrichtung den zugehörigen
API-Schlüssel:
:::

::: {.olist .arabic}
1.  Öffnen Sie die Seite [Alert sources]{.guihint} und starten Sie die
    Erstellung einer neue Alarmquelle mit [Create a new alert
    source.]{.guihint} Ein Wizard führt Sie durch die nächsten Schritte.
    Im folgenden werden die Einträge vorgeschlagen, mit denen Sie am
    schnellsten ans Ziel kommen. Die im Wizard getroffenen
    Entscheidungen können Sie später durch das Editieren der Alarmquelle
    ändern.

2.  Wählen Sie auf der ersten Wizard-Seite Checkmk als Integration für
    die Alarmquelle aus und bestätigen Sie mit [Next.]{.guihint} Geben
    Sie anschließend Ihrer Alarmquelle einen Namen. Wählen Sie dann eine
    Eskalationskette (*escalation policy*) aus, z. B.
    [Default.]{.guihint} Als Letztes wählen Sie die Alarm-Gruppierung
    oder lassen es (erstmal) bleiben mit [Do not group
    alerts.]{.guihint}

3.  Beenden Sie den Wizard mit [Continue setup]{.guihint}. Sie erhalten
    eine Zusammenfassung der bisher gemachten Einstellungen und weitere
    Auswahlmöglichkeiten für Alarmvorlage (*alert template*) und
    Benachrichtigungspriorität (*notification priority*).

    ::: paragraph
    Die Benachrichtigungspriorität können Sie sowohl in ilert als auch
    [später in Checkmk](#config_checkmk) festlegen. Wenn Sie möchten,
    dass die Priorität von Checkmk gesteuert wird, dann wählen Sie hier
    [High (with escalation)]{.guihint} oder [Low (no
    escalation),]{.guihint} das heißt einen Wert, der in beiden Systemen
    verfügbar ist. Lassen Sie außerdem die Prioritätsbindung (*priority
    mapping*) deaktiviert.
    :::

4.  Bestätigen Sie mit [Finish setup.]{.guihint} Auf der folgenden Seite
    wird der API-Schlüssel (*API key*) angezeigt, den Sie für die
    Konfiguration in Checkmk benötigen. Vor dem Schlüssel finden Sie
    einen Knopf zum Kopieren in die Zwischenablage.
:::
:::::
::::::

::::::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

:::::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
In Checkmk genügt es nun, den oben kopierten Schlüssel anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag
    [iLert.]{.guihint}

3.  Tragen Sie unter [API key]{.guihint} den kopierten Schlüssel ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    ilert.](../images/notifications_ilert.png)
    :::
    ::::

    ::: paragraph
    Statt den Schlüssel hier direkt einzugeben, können Sie diesen auch
    aus dem [Passwortspeicher](password_store.html) auslesen --- sofern
    er vorher dort hinterlegt wurde.
    :::
:::

::: paragraph
Die Auswahl unter [Notification priority]{.guihint} überschreibt die
Benachrichtigungspriorität in bestimmten Fällen, wie bei der
[Konfiguration von ilert](#config_ilert) beschrieben.
:::

::: paragraph
Mit den beiden Eingabefeldern zu [Custom incident summary]{.guihint}
legen Sie fest, wie eine Checkmk-Benachrichtigung in ilert in der Liste
der Alerts als [Summary]{.guihint} angezeigt wird.
:::

::: paragraph
Optional dürfen Sie URL-Präfixe angeben, um Links auf Ihre Checkmk-GUI
innerhalb der Benachrichtigung zu steuern.
:::

::: paragraph
Bei der Kontaktauswahl im folgenden Kasten [Contact selection]{.guihint}
beachten Sie die folgenden beiden Punkte:
:::

::: {.olist .arabic}
1.  Sorgen Sie bei der Kontaktauswahl dafür, dass die Benachrichtigungen
    nur an *einen* Kontakt versendet werden, z. B. durch Auswahl eines
    einzelnen Benutzers. Bei den Benachrichtigungsmethoden zu
    Ticketsystemen & Co. dient die Kontaktauswahl nur dazu, festzulegen,
    *dass* benachrichtigt wird. Die Benachrichtigungen werden aber nicht
    an den ausgewählten Benutzer, sondern an das Ticketsystem gesendet.
    Beachten Sie, dass eine Kontaktauswahl über Kontaktgruppen, alle
    Kontakte eines Objekts oder ähnliches in den meisten Fällen mehrere
    identische Benachrichtigungen für ein Ereignis generiert, die dann
    doppelt, dreifach oder noch öfter im Ticketsystem landen.

2.  Wenn der erste Punkt erfüllt ist, der Benutzer aber in mehreren
    Benachrichtigungsregeln für dieselbe Methode verwendet wird, dann
    greift jeweils nur die letzte Regel. Es empfiehlt sich daher, für
    jede dieser Benachrichtigungsregeln einen eigenen funktionalen
    Benutzer anzulegen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In ilert werden nur die           |
|                                   | [Checkmk                          |
|                                   | -Benachrichtigungstypen](notifica |
|                                   | tions.html#environment_variables) |
|                                   | `PROBLEM`, `ACKNOWLEDGEMENT` und  |
|                                   | `RECOVERY` verarbeitet - alle     |
|                                   | anderen werden ignoriert.         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Mit der neuen Funktion [Test
notifications](notifications.html#notification_testing) können Sie
überprüfen, ob Ihre neue Benachrichtigungsregel für bestimmte Hosts und
Services zutrifft.
:::

::: paragraph
Um Test-Benachrichtigungen über diese Benachrichtigungsmethode auch
tatsächlich zu versenden, müssen Sie in Checkmk [2.3.0]{.new} weiterhin
[Fake check results](notifications.html#fake_check_results) verwenden.
:::
::::::::::::::
:::::::::::::::
:::::::::::::::::::::::::::::
