:::: {#header}
# Benachrichtigungen per Cisco Webex Teams

::: details
[Last modified on 14-Aug-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_webex.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::: {#content}
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
[Webex
Teams](https://www.webex.com/team-collaboration.html){target="_blank"}
ist eine Anwendung der Firma Cisco für die kontinuierliche
Zusammenarbeit im Team mit Video-Meetings, Gruppennachrichten und
Dateifreigaben. Themen oder Teams werden hierin in sogenannten Bereichen
(*Spaces*) organisiert. Einen solchen Bereich können Sie auch für den
Empfang von Benachrichtigungen aus Checkmk nutzen. Für die eigentliche
Verbindung muss in Webex Teams noch ein Webhook erzeugt werden.
:::
:::::::
:::::::::

:::::::::::::::: sect1
## []{#config_webex .hidden-anchor .sr-only}1. Cisco Webex Teams konfigurieren {#heading_config_webex}

::::::::::::::: sectionbody
::: paragraph
Die Voraussetzung dafür, Benachrichtigungen aus Checkmk in Webex Teams
erhalten zu können, ist es also, dass mindestens ein Bereich (Space)
eingerichtet ist. Dies lässt sich in wenigen Sekunden erledigen und wird
in dem folgenden Artikel der Webex Hilfe beschrieben: [Webex App -
Bereich](https://help.webex.com/de-de/article/hk71r4/Webex-App%7C-Bereich){target="_blank"}
:::

::: paragraph
Mindestens für einen ersten Test bietet es sich an, einen dedizierten
Bereich alleine für Checkmk mit einem entsprechenden Namen einzurichten.
:::

::: paragraph
In Webex Teams muss nun noch die App *Incoming Webhooks* aktiviert bzw.
verbunden werden. Diese App finden Sie im [Webex App
Hub](https://apphub.webex.com/applications/incoming-webhooks-cisco-systems-38054-23307-75252){target="_blank"}.
:::

:::: {.imageblock .border}
::: content
![notifications webex1](../images/notifications_webex1.png)
:::
::::

::: paragraph
Klicken Sie auf dieser Seite auf [Connect]{.guihint}. (Sollten Sie mit
dem verwendeten Browser nicht in Webex Teams angemeldet sein, erscheint
nun erst der Anmeldedialog von Cisco Webex.)
:::

::: paragraph
Nach kurzer Wartezeit sieht es erst mal so aus, als ob sich nicht viel
getan hätte. Wenn Sie jetzt aber an das Ende der Seite scrollen, können
Sie über die Eingabe- und Auswahlfelder sowohl einen Namen für den
Webhook festlegen, als auch den zu verwendenden Bereich in Webex Teams
auswählen. Klicken Sie zum Schluss auf [Add]{.guihint}.
:::

:::: {.imageblock .border}
::: content
![notifications webex2](../images/notifications_webex2.png){width="70%"}
:::
::::

::: paragraph
Kopieren Sie die so erzeugte Webhook-URL nun durch ein Klick auf das
entsprechende Symbol:
:::

:::: {.imageblock .border}
::: content
![notifications webex3](../images/notifications_webex3.png){width="70%"}
:::
::::
:::::::::::::::
::::::::::::::::

:::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
In Checkmk genügt es nun, die oben kopierte Webhook-URL anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [Cisco
    Webex Teams.]{.guihint}

3.  Geben Sie die kopierte Webhook-URL ein.

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für Cisco Webex
    Teams.](../images/notifications_webex4.png)
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
::::::::::::::::::::::::::::::::::
