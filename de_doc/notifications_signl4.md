:::: {#header}
# Benachrichtigungen per SIGNL4

::: details
[Last modified on 31-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_signl4.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::: {#content}
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
SIGNL4 ist eine Alarmierungssoftware in der Cloud, um Teams in
Rufbereitschaft Alarme unterschiedlichster Systeme zuzustellen --- durch
SMS, Push-Benachrichtigung oder Anruf. Die Alarme werden mit einer
mobilen App für iPhone bzw. Android angezeigt. Per App erfolgt auch die
Quittierung, Nachverfolgung und Eskalation.
:::

::: paragraph
In Checkmk können Sie SIGNL4 über dessen *Team Secret* anbinden. Dadurch
werden Benachrichtigungen von Checkmk als Alarme in der SIGNL4 App
angezeigt.
:::

::: paragraph
Den Rückweg der Kommunikation von Checkmk zu SIGNL4 richten Sie im
SIGNL4-Portal ein: durch Auswahl und Konfiguration der
Checkmk-Integration. Anschließend führen Alarme, die in der mobilen App
von SIGNL4 quittiert, geschlossen oder kommentiert werden, auch zu einem
Update in Checkmk.
:::
:::::::::
:::::::::::

::::::: sect1
## []{#config_signl4_secret .hidden-anchor .sr-only}1. Team Secret aus SIGNL4 auslesen {#heading_config_signl4_secret}

:::::: sectionbody
::: paragraph
In SIGNL4 ist keine Aktivierung der Weiterleitung erforderlich. Das Team
Secret, das Sie für die Konfiguration in Checkmk benötigen, können Sie
im SIGNL4-Portal auslesen:
:::

::: {.olist .arabic}
1.  Wählen Sie in der Navigationsleiste [Teams.]{.guihint}

2.  Kopieren Sie in der Kachel des Teams, welches Benachrichtigungen von
    Checkmk erhalten soll, das angezeigte [Secret.]{.guihint}
:::

::: paragraph
Ein Secret ist nur dann verfügbar, wenn für das Team die Integration
[Webhook (Inbound)]{.guihint} eingerichtet ist. Die URL dieses Webhooks
enthält als letzten Eintrag das Team Secret.
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
In Checkmk genügt es nun, das oben kopierte Secret anzugeben:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [SIGNL4
    Alerting.]{.guihint}

3.  Tragen Sie unter [Team Secret]{.guihint} das kopierte Secret ein:

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    SIGNL4.](../images/notifications_signl4.png)
    :::
    ::::

    ::: paragraph
    Statt das Secret hier direkt einzugeben, können Sie dieses auch aus
    dem [Passwortspeicher](password_store.html) auslesen --- sofern es
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

:::::::: sect1
## []{#config_signl4_acknowledge .hidden-anchor .sr-only}3. SIGNL4 für die Quittierung konfigurieren {#heading_config_signl4_acknowledge}

::::::: sectionbody
::: paragraph
Der Rückkanal von SIGNL4 zu Checkmk wird mit der
[REST-API](rest_api.html) von Checkmk realisiert. Damit die
REST-API-Anfragen bei Checkmk ankommen, muss die Checkmk-Instanz
öffentlich zugänglich, oder präziser vom SIGNL4-Server aus erreichbar
sein.
:::

::: paragraph
Die Konfiguration erfolgt im SIGNL4-Portal:
:::

::: {.olist .arabic}
1.  Wählen Sie in der Navigationsleiste [Integrations]{.guihint}, dann
    [Gallery]{.guihint} und suchen Sie in den Integrationen nach
    `Checkmk`. Für Checkmk werden zwei Ergebnisse gefunden. Nur die
    Integration mit dem Namen [Checkmk ITOM Back channel for 2-way
    updates in Checkmk]{.guihint} ist für Einrichtung des Rückkanals
    zuständig.

2.  Klicken Sie auf diese, um die Einstellungen dieser Integration
    einzublenden.

3.  Geben Sie im Feld [Checkmk URL]{.guihint} die Basis-URL der REST-API
    Ihrer Checkmk-Instanz ein, also z.B.:
    `https://mydomain/mysite/check_mk/api/1.0/`.

4.  Geben Sie im Feld [Your Checkmk username]{.guihint} den Namen eines
    Benutzers der Checkmk-Instanz mit Zugriff auf die REST-API ein. Für
    diesen Zweck bietet sich der
    [Automationsbenutzer](glossar.html#automation_user) `automation` an.

5.  Geben Sie im Feld [Your Checkmk password]{.guihint} das zugehörige
    Passwort ein. Für den Automationsbenutzer ist dies das
    Automationspasswort (*automation secret*).

6.  Durch das Aktivieren des Schalters [Annotations as Ack]{.guihint}
    werden Kommentare aus der App auch als Kommentare in Checkmk
    sichtbar. Jeder aus der App gesendete Kommentar führt dann
    gleichzeitig zur Quittierung des Problems.

7.  Klicken Sie abschließend auf [Install.]{.guihint} Anschließend
    werden Ihre Eingaben überprüft. Wenn Sie sich nicht vertippt haben,
    sollten Sie oben auf der Seite im neu eingeblendeten Feld
    [Status]{.guihint} diese beruhigende Meldung sehen:
    `Everything is fine.`
:::

::: paragraph
Nach erfolgter Konfiguration ist es möglich, aus der mobilen SIGNL4 App
ein Problem in Checkmk zu [quittieren.](basics_ackn.html) Abgesetzte
Kommentare --- sofern [Annotations as Ack]{.guihint} aktiviert
ist --- und das Schließen eines Alarms aus der App werden in Checkmk als
Kommentare beim betroffenen Host/Service vermerkt.
:::
:::::::
::::::::
:::::::::::::::::::::::::::::::::
