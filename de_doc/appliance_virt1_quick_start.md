:::: {#header}
# Schnellstart-Anleitung für Checkmk virt1

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_virt1_quick_start.asciidoc){.edit-document}
:::
::::

::::::::::::::::::: {#content}
:::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

:::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Appliance einrichten und nutzen](appliance_usage.html) [Installation
von Checkmk in der Appliance](install_appliance_cmk.html)
[Schnellstart-Anleitung für
Checkmk-Racks](appliance_rack1_quick_start.html)
:::
::::
:::::

::: paragraph
Diese Schnellstart-Anleitung führt Sie vom Download der Appliance über
eine Minimalkonfiguration bis hin zum Anmeldebildschirm einer laufenden
Checkmk-Instanz.
:::

::: paragraph
Ausführliche Informationen und Anleitungen finden Sie im [Hauptartikel
zur Appliance.](appliance_usage.html)
:::
::::::::
::::::::::

::::: sect1
## []{#_maschine_einrichten_konsole .hidden-anchor .sr-only}1. Maschine einrichten (Konsole) {#heading__maschine_einrichten_konsole}

:::: sectionbody
::: {.olist .arabic}
1.  Laden Sie die Checkmk virt1 als OVA-Datei (Open Virtualization
    Appliance) von unserer
    [Download-Seite](https://checkmk.com/de/download){target="_blank"}
    herunter und importieren Sie diese Datei in Ihren Hypervisor,
    wahlweise VirtualBox, Proxmox oder VMware ESXi (für bessere
    Performance sollten Sie die Netzwerkkarte beim Import in ESXi auf
    VMXNET 3 ändern). [Mehr ...​](appliance_install_virt1.html)

2.  Starten Sie die importierte virtuelle Maschine. Sie landen in einer
    textbasierten Konfigurationsumgebung (Konsole genannt), in der Sie
    die Grundkonfiguration der Appliance vornehmen.

3.  Während der Initialisierung beim Erststart werden Sie zur
    Partitionierung des Datenträgers aufgefordert. [Mehr
    ...​](appliance_usage.html#init_start)\
    Bestätigen Sie.

4.  Nach der Partitionierung sehen Sie die Statusansicht der Konsole,
    den Startbildschirm bei allen weiteren Starts.

5.  Damit die Appliance zum Monitoring genutzt werden kann, müssen Sie
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

6.  Starten Sie nun die Weboberfläche der Appliance auf einem beliebigen
    Rechner im Netzwerk über die oben vergebene IP-Adresse mit
    `http://<ipaddress>/`. Loggen Sie sich mit dem gesetzten Passwort
    ein. Ein Benutzername wird nicht benötigt.
:::
::::
:::::

::::::: sect1
## []{#_monitoring_einrichten_web_gui .hidden-anchor .sr-only}2. Monitoring einrichten (Web-GUI) {#heading__monitoring_einrichten_web_gui}

:::::: sectionbody
::: {.olist .arabic}
1.  Laden Sie das Checkmk-Software-Paket für die Appliance von unserer
    [Download-Seite](https://checkmk.com/de/download) herunter.

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
:::::::::::::::::::
