:::: {#header}
# Benachrichtigungen per Opsgenie

::: details
[Last modified on 14-Aug-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_opsgenie.asciidoc){.edit-document}
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
[Opsgenie](https://www.atlassian.com/software/opsgenie){target="_blank"},
mittlerweile Teil von Atlassian, bietet als
Incident-Management-Plattform Benachrichtigungen und Eskalationen für
Teams und kann dabei viele externe Tools integrieren, darunter auch
Checkmk. Die grundsätzliche Anbindung benötigt lediglich einen
API-Schlüssel und eine URL. Sie können in Checkmk jedoch auch weitere
Optionen festlegen, beispielsweise zusätzliche Informationen je nach Art
der Quelle der Benachrichtigung.
:::
:::::::
:::::::::

:::::: sect1
## []{#config_opsgenie .hidden-anchor .sr-only}1. Opsgenie konfigurieren {#heading_config_opsgenie}

::::: sectionbody
::: paragraph
Zur Integration von Checkmk finden Sie direkt innerhalb von Opsgenie
eine kurze Anleitung --- die sich jedoch auf eine ältere Checkmk-Version
bezieht, in der Sie noch eine komplette URL samt API-Schlüssel übergeben
mussten. In aktuellen Versionen geben Sie URL und Schlüssel separat ein.
Zudem ist die URL nur für in Europa gehostete Accounts nötig.
:::

::: {.olist .arabic}
1.  Legen Sie ein Team an oder rufen Sie ein bestehendes auf.

2.  Wählen Sie unter [Integrations/Add Integration]{.guihint} den
    Eintrag Checkmk.

3.  In der nun angezeigten, fehlerhaften Anleitung finden Sie unter dem
    Punkt [Paste]{.guihint} eine URL samt Optionen und API-Key. Kopieren
    Sie den Domain-Teil der URL (`https://api.eu.opsgenie.com`).

4.  Kopieren Sie anschließend noch den API-Schlüssel und speichern Sie
    die Integration.
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
In Checkmk genügt es nun, die beiden oben kopierten Daten anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag
    [Opsgenie.]{.guihint}

3.  Geben Sie unter [API Key to use]{.guihint} den kopierten Schlüssel
    ein.

4.  Aktivieren Sie --- als EU-Nutzer --- die Checkbox [Domain]{.guihint}
    und fügen Sie die kopierte URL ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    Opsgenie.](../images/notifications_opsgenie.png)
    :::
    ::::

    ::: paragraph
    Statt die URL hier direkt einzugeben, können Sie diese auch aus dem
    [Passwortspeicher](password_store.html) auslesen --- sofern sie
    vorher dort hinterlegt wurde.
    :::
:::

::: paragraph
Die Konfiguration der Benachrichtigungsmethode Opsgenie bietet Ihnen
allerlei weitere Optionen, insbesondere zum Anreichern und Ändern der
Standardinhalte der Benachrichtigungen. Darüber hinaus können Sie über
den Punkt [Responsible teams]{.guihint} das Opsgenie-Team festlegen,
wenn Sie nicht wie hier beschrieben speziell für ein Team, sondern für
das gesamte Opsgenie-Konto integriert haben --- was wiederum nur bei
bestimmten Subskriptionen möglich ist.
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
