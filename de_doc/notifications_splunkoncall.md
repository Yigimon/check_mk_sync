:::: {#header}
# Benachrichtigungen per Splunk On-Call

::: details
[Last modified on 22-Nov-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_splunkoncall.asciidoc){.edit-document}
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
Die Incident-Management-Plattform [Splunk
On-Call](https://www.splunk.com/de_de/products/on-call.html){target="_blank"}
kümmert sich um das Verteilen von Meldungen aus Dutzenden
unterschiedlicher Quellen, die als Integrationen direkt in der
Weboberfläche ausgewählt werden können. Für Checkmk steht ein
generisches REST-API-Backend zur Verfügung.
:::
:::::::
:::::::::

:::::: sect1
## []{#config_splunkoncall .hidden-anchor .sr-only}1. Splunk On-Call konfigurieren {#heading_config_splunkoncall}

::::: sectionbody
::: paragraph
Eine explizite Aktivierung der Benachrichtigungen aus Checkmk benötigen
Sie nicht, lediglich die REST-API-Endpunktadresse:
:::

::: {.olist .arabic}
1.  Rufen Sie in Splunk On-Call unter [Integrations]{.guihint} den Punkt
    [REST Generic]{.guihint} auf.

2.  Kopieren Sie die angezeigte URL des REST-API-Endpunkts.
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
In Checkmk genügt es nun, die oben kopierte URL anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [Splunk
    On-Call.]{.guihint}

3.  Tragen Sie unter [REST Endpoint URL]{.guihint} die kopierte URL ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für Splunk
    On-Call.](../images/notifications_splunkoncall.png)
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
::::::::::::::::::::::::
