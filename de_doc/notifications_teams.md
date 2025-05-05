:::: {#header}
# Benachrichtigungen per Microsoft Teams

::: details
[Last modified on 24-Jun-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_teams.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::: {#content}
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
[Teams](https://www.microsoft.com/de-de/microsoft-teams/log-in/){target="_blank"}
ist Microsofts Chat- und Videokonferenzlösung. In der Business-Variante
können Sie Kanäle für Ihre Teams erstellen und darin Benachrichtigungen
aus Checkmk empfangen. Die Anbindung erfolgt über einen Webhook.
:::
:::::::
:::::::::

::::::: sect1
## []{#config_teams .hidden-anchor .sr-only}1. Microsoft Teams konfigurieren {#heading_config_teams}

:::::: sectionbody
::: paragraph
In Teams müssen Sie einen Workflow für eine Webhook-Anfrage erstellen:
:::

::: {.olist .arabic}
1.  Öffnen Sie den gewünschten Kanal.

2.  In der Menüleiste dieses Kanals öffnen Sie das Drei-Punkte-Menü und
    wählen `Workflows` aus.

3.  Suchen Sie nach
    `Post to a channel when a webhook request is received` und öffnen
    Sie den Workflow.

4.  Als nächstes müssen Sie diesem Workflow einen Namen geben.

5.  Wählen Sie schließlich den Chat, in den veröffentlicht werden soll.

6.  Auf der nächsten Seite sollten Sie die URL des neuen Webhooks sehen.
    Kopieren Sie diese URL, damit Sie sie im nächsten Schritt in Checkmk
    einfügen können.
:::

::: paragraph
Die obige Beschreibung ist etwas vage. Das liegt daran, dass die
tatsächliche Art und Weise, wie Sie klicken müssen, in Ihrer speziellen
Version von MS Teams unterschiedlich sein kann. Wenn größere Änderungen
auftreten, versuchen wir, die Informationen rechtzeitig zu
aktualisieren.
:::
::::::
:::::::

::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

:::::::::: sectionbody
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

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag
    [Microsoft Teams.]{.guihint}

3.  Geben Sie die kopierte URL unter [Webhook URL]{.guihint} ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für Microsoft
    Teams.](../images/notifications_teams.png)
    :::
    ::::

    ::: paragraph
    Statt die URL hier direkt einzugeben, können Sie diese auch aus dem
    [Passwortspeicher](password_store.html) auslesen --- sofern sie
    vorher dort hinterlegt wurde.
    :::
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
::::::::::
:::::::::::
::::::::::::::::::::::::
