:::: {#header}
# Benachrichtigungen per Slack

::: details
[Last modified on 14-Aug-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_slack.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::: {#content}
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
[Benachrichtigungen](notifications.html)
:::
::::
:::::

::: paragraph
Über den Messenger [Slack](https://slack.com/){target="_blank"} können
Sie Benachrichtigungen einfach über einen Webhook empfangen. Das
funktioniert sowohl auf selbst gehosteten oder gemieteten Servern, als
auch über den kostenlosen öffentlichen Slack-Dienst.
:::
:::::::
:::::::::

::::::: sect1
## []{#config_slack .hidden-anchor .sr-only}1. Slack konfigurieren {#heading_config_slack}

:::::: sectionbody
::: paragraph
Um Webhooks zu aktivieren und einen neuen Webhook zu erstellen, müssen
Sie zunächst eine Slack App erstellen. Melden Sie sich bei Slack an und
erstellen Sie einen *Workspace.* Gehen Sie dann wie folgt vor:
:::

::: {.olist .arabic}
1.  Erstellen Sie über [diesen
    Link](https://api.slack.com/messaging/webhooks){target="_blank"}
    eine neue App über die Slack-API.

2.  Vergeben Sie einen beliebigen Namen und wählen Sie Ihren Workspace.

3.  Im nächsten Dialog wählen Sie als Funktion der App [Incoming
    Webhook.]{.guihint}

4.  Aktivieren Sie anschließend Webhooks, indem Sie den Schalter auf
    [on]{.guihint} setzen.

5.  Erstellen Sie den Webhook über den Knopf [Add New Webhook to
    Workspace.]{.guihint}

6.  Legen Sie zum Abschluss den Channel (Gruppe) fest, in den die App
    senden soll, und bestätigen Sie die Rechteanfrage.
:::

::: paragraph
Zum Testen bekommen Sie nach Abschluss eine `curl`-Anweisung, die *Hello
World* in den gewünschten Channel sendet. Kopieren Sie die Webhook-URL
und wechseln Sie zu Checkmk.
:::
::::::
:::::::

:::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
In Checkmk genügt es nun, die oben kopierte URL anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [Slack or
    Mattermost.]{.guihint}

3.  Geben Sie die kopierte Webhook-URL ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für Slack und
    Mattermost.](../images/notifications_slack.png)
    :::
    ::::

    ::: paragraph
    Statt die URL hier direkt einzugeben, können Sie diese auch aus dem
    [Passwortspeicher](password_store.html) auslesen --- sofern sie
    vorher dort hinterlegt wurde.
    :::
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
:::::::::::
::::::::::::
:::::::::::::::::::::::::
