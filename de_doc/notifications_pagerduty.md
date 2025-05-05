:::: {#header}
# Benachrichtigungen per PagerDuty

::: details
[Last modified on 14-Aug-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_pagerduty.asciidoc){.edit-document}
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
Die Incident-Management-Plattform
[PagerDuty](https://www.pagerduty.com){target="_blank"} kann aus
unterschiedlichsten Quellen Meldungen empfangen und diese
weiterverarbeiten, also zum Beispiel filtern, als Benachrichtigungen
versenden oder Eskalationen in Gang setzen. Aus Checkmk lassen sich
Benachrichtigungen über einen Schlüssel an die Plattform leiten.
:::
:::::::
:::::::::

:::::: sect1
## []{#config_pagerduty .hidden-anchor .sr-only}1. PagerDuty konfigurieren {#heading_config_pagerduty}

::::: sectionbody
::: paragraph
PagerDuty bietet Integrationen für viele populäre Werkzeuge, darunter
auch Checkmk. Dazu benötigen Sie lediglich einen Integrationsschlüssel
(*integration key*), den Sie unter PagerDuty wie folgt anlegen:
:::

::: {.olist .arabic}
1.  Erstellen Sie einen neuen Service oder öffnen Sie einen vorhandenen.

2.  Im entsprechenden Service erstellen Sie über den Reiter
    [Integrations]{.guihint} eine neue Integration.

3.  Vergeben Sie einen beliebigen Namen und wählen Sie als [Integration
    Type]{.guihint} den Punkt [Check_MK.]{.guihint}

4.  Kopieren Sie den erzeugten [Integration Key.]{.guihint}
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
In Checkmk genügt es nun, den oben kopierten Schlüssel anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag
    [PagerDuty.]{.guihint}

3.  Tragen Sie unter [Integration Key]{.guihint} den kopierten Schlüssel
    ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    PagerDuty.](../images/notifications_pagerduty.png)
    :::
    ::::

    ::: paragraph
    Statt den Schlüssel hier direkt einzugeben, können Sie diesen auch
    aus dem [Passwortspeicher](password_store.html) auslesen --- sofern
    er vorher dort hinterlegt wurde.
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
Die Filterung der erzeugten Benachrichtigungen können Sie wahlweise in
Checkmk oder erst in PagerDuty über die [Event Rules]{.guihint}
umsetzen. Optional können Sie die PagerDuty-Anbindung auch auf ein
eigenes Checkmk-Benutzerkonto aufschalten. Erstellen Sie dazu einfach
einen Standard-Benutzer mit deaktiviertem Login und anschließend eine
persönliche Benachrichtigungsregel.
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
