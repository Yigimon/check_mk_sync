:::: {#header}
# Benachrichtigungen per ServiceNow

::: details
[Last modified on 06-Apr-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_servicenow.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::: {#content}
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
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Anbindung von
[ServiceNow](https://www.servicenow.com/){target="_blank"} steht nur für
die kommerziellen Editionen zur Verfügung. Über die Plattform ServiceNow
lassen sich unterschiedlichste Workflows abbilden und automatisieren
(Stichwort ITIL), so auch die Weiterleitung von
Checkmk-Benachrichtigungen an Benutzer. Die Integration läuft über die
Instanz-URL und Login-Daten.
:::
:::::::
:::::::::

::::: sect1
## []{#config_servicenow .hidden-anchor .sr-only}1. ServiceNow konfigurieren {#heading_config_servicenow}

:::: sectionbody
::: paragraph
Eine spezielle Konfiguration innerhalb von ServiceNow ist nicht
erforderlich, es müssen lediglich Instanz-URL (gegebenenfalls in Form
einer Custom-URL) und Benutzerdaten bekannt sein. Der verwendete
Benutzer muss in ServiceNow die Rolle *itil* inne haben.
:::
::::
:::::

:::::::::::::::::::::: sect1
## []{#config_checkmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_checkmk}

::::::::::::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
Für die Anbindung von ServiceNow gehen Sie in Checkmk nun wie folgt vor:
:::

::: {.olist .arabic}
1.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

2.  Wählen Sie als [Notification Method]{.guihint} den Eintrag
    [Servicenow (Enterprise only).]{.guihint}

3.  Geben Sie unter [ServiceNow URL]{.guihint} Ihre Instanz-URL ein.

4.  Fügen Sie Benutzername und Passwort des *erstellenden* Benutzers
    hinzu.

5.  Wählen Sie den [Management type]{.guihint} aus, ServiceNow kennt
    zwei Typen: *case* und *incident.* Abhängig von Ihrer Auswahl ändern
    sich die darunter angezeigten Optionen. Jede der in Checkmk
    angebotenen Optionen, sowohl beim Typ *case* als auch beim Typ
    *incident* entspricht der gleichnamigen Einstellung in ServiceNow.
:::

:::::: sect2
### []{#_den_managementtyp_case_ausgestalten .hidden-anchor .sr-only}2.1. Den Managementtyp *Case* ausgestalten {#heading__den_managementtyp_case_ausgestalten}

::: paragraph
Haben Sie [Case]{.guihint} ausgewählt, so können Sie verschiedene
weitere Optionen setzen, um den Inhalt der Benachrichtigung zu
gestalten.
:::

:::: imageblock
::: content
![Die Einstellungen zur Benachrichtigungsmethode für den Typ Case bei
ServiceNow.](../images/notifications_servicenow_case.png)
:::
::::
::::::

::::::: sect2
### []{#_den_managementtyp_incident_ausgestalten .hidden-anchor .sr-only}2.2. Den Managementtyp *Incident* ausgestalten {#heading__den_managementtyp_incident_ausgestalten}

::: paragraph
Haben Sie [Incident]{.guihint} ausgewählt, so gibt es ein paar
Besonderheiten bei der Ausgestaltung der Benachrichtigung.
:::

:::: imageblock
::: content
![Die Einstellungen zur Benachrichtigungsmethode für den Typ Incident
bei ServiceNow.](../images/notifications_servicenow_incident.png)
:::
::::

::: {.olist .arabic}
1.  Unter [Caller ID]{.guihint} ergänzen Sie den Benutzernamen des
    *betroffenen* Benutzers. Es wird empfohlen, als erstellenden und
    betroffenen Benutzer denselben Benutzernamen zu verwenden. In der
    Inline-Hilfe von Checkmk finden Sie dazu genauere Informationen.

2.  Alle weiteren Optionen dienen auch hier der Gestaltung des Inhalts
    der Benachrichtigung.

3.  Für die beiden ServiceNow-eigenen Optionen [Urgency]{.guihint} und
    [Impact]{.guihint} finden Sie in der Inline-Hilfe von Checkmk Links
    auf die jeweiligen Einträge in der ServiceNow-Dokumentation.
:::
:::::::

::::: sect2
### []{#_kontakt_auswählen .hidden-anchor .sr-only}2.3. Kontakt auswählen {#heading__kontakt_auswählen}

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
:::::

::::: sect2
### []{#_benachrichtigungen_testen .hidden-anchor .sr-only}2.4. Benachrichtigungen testen {#heading__benachrichtigungen_testen}

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
:::::
:::::::::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::::::::::::
