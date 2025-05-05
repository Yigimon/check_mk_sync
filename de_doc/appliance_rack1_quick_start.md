:::: {#header}
# Schnellstart-Anleitung für Checkmk-Racks

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_rack1_quick_start.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::: {#content}
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
[Appliance einrichten und nutzen](appliance_usage.html) [Installation
von Checkmk in der Appliance](install_appliance_cmk.html)
[Schnellstart-Anleitung für virt1](appliance_virt1_quick_start.html)
:::
::::
:::::

::: paragraph
Diese Schnellstart-Anleitung führt Sie vom Aufstellen der Appliance über
eine Minimalkonfiguration bis hin zum Anmeldebildschirm einer laufenden
Checkmk-Instanz.
:::

::: paragraph
Ausführliche Informationen und Anleitungen finden Sie im [Hauptartikel
zur Appliance.](appliance_usage.html)
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Beachten Sie, dass das            |
|                                   | Management-Interface aller        |
|                                   | Checkmk-Racks **im                |
|                                   | Auslieferungszustand              |
|                                   | deaktiviert** ist und bei Bedarf  |
|                                   | [manuell über die Weboberfläche   |
|                                   | aktiviert werden                  |
|                                   | muss.]                            |
|                                   | (appliance_rack_config.html#ipmi) |
|                                   | Sie **müssen** das unbedingt      |
|                                   | beachten, wenn Sie das Rack bspw. |
|                                   | direkt an einen entfernten        |
|                                   | Standort liefern und dort         |
|                                   | aufstellen lassen. [Mehr          |
|                                   | ...​]                              |
|                                   | (appliance_rack_config.html#ipmi) |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::
:::::::::::

::::: sect1
## []{#_maschine_einrichten_konsole .hidden-anchor .sr-only}1. Maschine einrichten (Konsole) {#heading__maschine_einrichten_konsole}

:::: sectionbody
::: {.olist .arabic}
1.  Schließen Sie das Gerät an. Für die Inbetriebnahme benötigen Sie
    zumindest: Monitor (VGA), USB-Tastatur, Netzwerkverbindung
    (Anschluss: LAN1) und Stromversorgung (vorzugsweise beide
    Anschlüsse).

2.  Während der Initialisierung beim Erststart werden Sie zur
    Initialisierung des RAIDs aufgefordert, wobei natürlich alle Daten
    auf den Festplatten gelöscht werden. [Mehr
    ...​](appliance_usage.html#init_start)\
    Bestätigen Sie.

3.  Nach der Initialisierung sehen Sie die Statusansicht der Konsole,
    den Startbildschirm bei allen weiteren Starts.

4.  Damit die Appliance zum Monitoring genutzt werden kann, müssen Sie
    nun noch einige Einstellungen vornehmen. Drücken Sie die Taste `F1`,
    um das Konfigurationsmenü aufzurufen und setzen Sie mindestens die
    folgenden Einstellungen:

    ::: {.olist .loweralpha}
    a.  [Network Configuration:]{.guihint} IP-Adresse, Netzmaske und
        optional das Standard-Gateway. [Mehr
        ...​](appliance_usage.html#network_config)

    b.  [Device Password:]{.guihint} Passwort zur **Aktivierung** der
        Weboberfläche der Appliance. [Mehr
        ...​](appliance_usage.html#network_access)
    :::

5.  Starten Sie nun die Weboberfläche der Appliance über die oben
    vergebene IP-Adresse auf einem beliebigen Rechner im Netzwerk mit
    `http://<ipaddress>/`. Loggen Sie sich mit dem gesetzten Passwort
    ein. Ein Benutzername wird nicht benötigt.

6.  Schließen Sie zuletzt noch --- optional, aber dringend
    empfohlen --- das Management-Interface über ein separates Netzwerk
    an. [Mehr ...​](appliance_rack_config.html#ipmi)
:::
::::
:::::

::::::: sect1
## []{#_monitoring_einrichten_web_gui .hidden-anchor .sr-only}2. Monitoring einrichten (Web-GUI) {#heading__monitoring_einrichten_web_gui}

:::::: sectionbody
::: {.olist .arabic}
1.  Laden Sie das Checkmk-Software-Paket für die Appliance von unserer
    [Download-Seite](https://checkmk.com/de/download){target="_blank"}
    herunter.

2.  Navigieren Sie in der Weboberfläche der Appliance zu [Check_MK
    Versions]{.guihint} und installieren Sie das Checkmk-Paket über den
    Knopf [Upload & Install.]{.guihint} [Mehr
    ...​](appliance_usage.html#manage_cmk)

3.  Navigieren Sie nun zu [Site Management]{.guihint} und legen Sie mit
    [Create New Site]{.guihint} eine Checkmk-Instanz an. [Mehr
    ...​](appliance_usage.html#create_site)\
    Geben Sie mindestens die folgenden Werte ein:

    ::: {.olist .loweralpha}
    a.  [Unique site ID:]{.guihint} Name der Instanz

    b.  [Version:]{.guihint} Version von Checkmk

    c.  [Login for the administrator:]{.guihint} Admin-Benutzername

    d.  [Password for administrator:]{.guihint} Admin-Passwort
    :::

4.  Nun können Sie sich an der Checkmk-Instanz anmelden --- einfach den
    Instanznamen an die URL von oben anhängen:
    `http://<ipaddress>/<siteid>/`
:::

::: paragraph
Checkmk steht nun für Sie bereit! Erfahren Sie im Artikel [Die
Checkmk-Oberfläche,](intro_gui.html) wie es weiter geht.
:::

::: paragraph
Für den produktiven Betrieb sollten Sie freilich weitere Einstellungen
vornehmen, beispielsweise für Namensauflösungen, Kommunikation per
E-Mail, Verschlüsselung etc. Alles Weitere erfahren Sie im [Hauptartikel
zur Appliance.](appliance_usage.html)
:::
::::::
:::::::
::::::::::::::::::::
