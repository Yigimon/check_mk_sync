:::: {#header}
# Installation von Checkmk in der Appliance

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_appliance_cmk.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::: {#content}
:::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

:::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Schnellstart-Anleitung für
Checkmk-Racks](appliance_rack1_quick_start.html) [Schnellstart-Anleitung
für Checkmk virt1](appliance_virt1_quick_start.html) [Appliance
einrichten und nutzen](appliance_usage.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_grundsätzliches .hidden-anchor .sr-only}1. Grundsätzliches {#heading__grundsätzliches}

:::::: sectionbody
::: paragraph
Beginnend mit der Appliance-Version 1.4.14 ist in der Appliance keine
Checkmk-Software mehr vorinstalliert. Der Grund dafür ist simpel:
Checkmk wird wesentlich häufiger aktualisiert als die Appliance und Sie
sollen natürlich nicht mit einer veralteten Checkmk-Version starten
müssen.
:::

::: paragraph
Die Installation von Checkmk läuft in der Appliance nicht wie auf
normalen Rechnern über die Kommandozeile, sondern bequem über eine
eigene Weboberfläche --- wie Sie im Folgenden sehen werden. Um diese
Weboberfläche nutzen zu können, müssen Sie sie in der Geräteverwaltung
der Appliance [aktivieren.](appliance_usage.html#network_access)
:::

::: paragraph
Die Checkmk-Software zur Installation in der Appliance wird Ihnen als
CMA-Datei angeboten (Checkmk-Appliance). Dabei handelt es sich schlicht
um ein Archivformat, das die Checkmk-Ordnerstruktur plus eine Info-Datei
enthält.
:::
::::::
:::::::

:::::::::::::: sect1
## []{#_checkmk_installieren .hidden-anchor .sr-only}2. Checkmk installieren {#heading__checkmk_installieren}

::::::::::::: sectionbody
::: paragraph
Laden Sie die CMA-Datei über die
[Download-Seite](https://checkmk.com/de/download) herunter. Sie bekommen
die passende CMA-Datei nach der Auswahl der Checkmk-Edition und -Version
sowie der Plattform der Appliance.
:::

::: paragraph
Nachdem Sie die CMA-Datei heruntergeladen haben, wählen Sie im Hauptmenü
[Check_MK versions.]{.guihint} Suchen Sie dann auf der folgenden Seite
mit Hilfe des Dateiauswahldialogs die CMA-Datei von Ihrer Festplatte und
bestätigen Sie die Auswahl mit einem Klick auf [Upload &
Install.]{.guihint}
:::

::: paragraph
Nun wird die Checkmk-Software auf das Gerät hochgeladen. Dies kann, je
nach Netzwerkverbindung zwischen Ihrem Computer und dem Gerät, einige
Minuten dauern. Nachdem das Hochladen erfolgreich abgeschlossen wurde,
sehen Sie die neue Version in der Tabelle der installierten Versionen:
:::

:::: {.imageblock .border}
::: content
![Ansicht der installierten
Checkmk-Versionen.](../images/cma_webconf_cmk_versions_upload1_finished.png)
:::
::::

::: paragraph
Es ist möglich, auf dem Gerät mehrere Checkmk-Versionen parallel zu
installieren. Dadurch können mehrere Instanzen in verschiedenen
Versionen betrieben und einzelne Instanzen unabhängig voneinander auf
neuere Versionen aktualisiert werden. So können Sie beispielsweise eine
neue Version installieren und diese zunächst in einer Testinstanz
ausprobieren, um, nach erfolgreichem Test, anschließend Ihre
Produktivinstanz zu aktualisieren.
:::

::: paragraph
Eine weitere Checkmk-Software-Version laden und installieren Sie in
gleicher Weise wie die erste. Das Ergebnis sieht dann etwa so aus:
:::

:::: {.imageblock .border}
::: content
![Detailansicht der installierten
Checkmk-Versionen.](../images/cma_webconf_cmk_versions_upload2_finished.png)
:::
::::

::: paragraph
Sofern eine Software-Version von keiner Instanz verwendet wird, können
Sie diese Version mit dem Papierkorb-Symbol löschen.
:::
:::::::::::::
::::::::::::::
::::::::::::::::::::::::::
