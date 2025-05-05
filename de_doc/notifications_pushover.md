:::: {#header}
# Benachrichtigungen per Pushover

::: details
[Last modified on 14-Aug-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_pushover.asciidoc){.edit-document}
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
[Pushover](https://pushover.net/){target="_blank"} ist ein einfacher
Dienst, um Meldungen aus unterschiedlichsten Quellen an Apple- oder
Android-Mobilgeräte zu senden, wo sie dann als Benachrichtigungen
auftauchen. Auf dem Desktop lassen sich die Meldungen über den Browser
empfangen. Die Anbindung erfolgt über zwei API-Schlüssel für eine Gruppe
und eine App/Quelle.
:::
:::::::
:::::::::

:::::: sect1
## []{#config_pushover .hidden-anchor .sr-only}1. Pushover konfigurieren {#heading_config_pushover}

::::: sectionbody
::: paragraph
In Pushover müssen Sie sowohl eine Gruppe anlegen, auch wenn Sie nur
eine „Gruppe" haben, als auch eine App explizit für Checkmk --- beide
bekommen eigene API-Schlüssel:
:::

::: {.olist .arabic}
1.  Legen Sie in Pushover eine neue Gruppe mit mindestens einem Mitglied
    über [Create a Group]{.guihint} an.

2.  Kopieren Sie den angezeigten Gruppen-API-Schlüssel.

3.  Erstellen Sie eine App mit beliebigem Namen über [Create an
    Application/API Token.]{.guihint}

4.  Kopieren Sie den angezeigten App-API-Schlüssel.
:::
:::::
::::::

:::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
In Checkmk genügt es nun, die beiden oben kopierten Schlüssel anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [Push
    Notifications (using Pushover).]{.guihint}

3.  Tragen Sie unter [API Key]{.guihint} den kopierten App-API-Schlüssel
    ein.

4.  Tragen Sie unter [User / Group Key]{.guihint} den kopierten
    Gruppen-API-Schlüssel ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    Pushover.](../images/notifications_pushover.png)
    :::
    ::::
:::

::: paragraph
Optional können Sie hier noch die Pushover-Funktionen
[Priority]{.guihint} und [Select sound]{.guihint} aktivieren. Über die
Priorität dürfen Sie zum Beispiel in Pushover konfigurierte Ruhezeiten
aushebeln --- und derartige Benachrichtigungen dann auch mit passenden
Tönen untermalen.
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
::::::::::::::::::::::::
