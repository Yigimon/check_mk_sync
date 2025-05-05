:::: {#header}
# MKPs für GUI-Erweiterungen

::: details
[Last modified on 02-Jun-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/mkp_viewables.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Erweiterungen für Checkmk entwickeln](devel_intro.html) [Richtlinien
für Check-Plugins](dev_guidelines.html) [Checkmk-Erweiterungspakete
(MKPs)](mkps.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die
[Checkmk-Erweiterungspakete (MKPs)](glossar.html#mkp) können neben
funktionalen Erweiterungen auch solche für die Benutzeroberfläche (GUI)
verpacken, also Dashboards, Ansichten oder Berichte. Das Besondere
daran: Sie können derlei MKPs in den kommerziellen Editionen direkt über
die Weboberfläche erstellen, externe Dateien oder Werkzeuge werden nicht
benötigt. Alternativ steht dafür natürlich auch die Kommandozeile zur
Verfügung, ebenfalls exklusiv in den kommerziellen Editionen.
:::

::: paragraph
Die MKPs lassen sich dann intern mit weiteren Nutzern und
Checkmk-Installationen teilen und natürlich auch über die [Checkmk
Exchange.](https://exchange.checkmk.com/) Doch auch ohne Beteiligung der
Community oder weiterer Instanzen kann es nützlich sein, komplexe
Kreationen zu paketieren.
:::

::: paragraph
Wird beispielsweise ein Dashboard mit der Option [Make this dashboard
available for other users]{.guihint} erstellt, steht dieses allen oder
einigen Nutzern ebenfalls zur Verfügung. Löschen Nutzer ihre Dashboards
dann aber irgendwann wieder, sind sie natürlich auch für alle anderen
verloren --- sofern sie sich nicht rechtzeitig persönliche Kopien
angefertigt haben. Da bietet es sich an, dass mit entsprechenden Rechten
ausgestattete Nutzer Dashboards bei Bedarf als Erweiterung zur Verfügung
stellen.
:::

::: paragraph
Auch eine *Versionierung* von Dashboards wird so möglich --- nützlich
für reibungslose Updates.
:::

::: paragraph
Das Vorgehen zum Erstellen von MKPs ist für alle Arten von
GUI-Erweiterungen identisch, daher beschränken wir uns im Folgenden auf
das Beispiel Dashboard.
:::

::: paragraph
Voraussetzung: Nutzer benötigen die Berechtigung [Manage Extension
Packages (MKPs).]{.guihint}
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::: sect1
## []{#webgui .hidden-anchor .sr-only}2. Weboberfläche {#heading_webgui}

:::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::: sect2
### []{#_gui_mkps_erstellen .hidden-anchor .sr-only}2.1. GUI-MKPs erstellen {#heading__gui_mkps_erstellen}

::: paragraph
Los geht es in der Dashboard-Liste unter [Customize \> Visualization \>
Dashboards.]{.guihint} Wenn Sie bereits ein eigenes Dashboard angelegt
haben, können Sie damit arbeiten. Ansonsten erstellen Sie eine private
Kopie eines beliebigen eingebauten Dashboards. In beiden Fällen ist Ihr
Ausgangspunkt ein Dashboard im Bereich [Customized.]{.guihint}
:::

:::: imageblock
::: content
![Liste mit angepassten Dashboards.](../images/mkp_visuals_01.png)
:::
::::

::: paragraph
Über [![Icon für das Klonen von
Elementen.](../images/icons/icon_mkp_viewable_clone.png)]{.image-inline}
[Clone this dashboard for packaging as extension package]{.guihint}
erstellen Sie aus dem Dashboard eine Erweiterung, die anschließend im
Bereich [Extensions]{.guihint} gelistet wird:
:::

:::: imageblock
::: content
![Listen mit angepassten und als Erweiterungen geführten
Dashboards.](../images/mkp_visuals_03.png)
:::
::::

::: paragraph
Von hier aus gelangen Sie über [![Icon, das zum Paketmanagement
führt.](../images/icons/icon_mkp_viewable_package.png)]{.image-inline}
[Go to extension packages]{.guihint} zur Verwaltung der
Erweiterungspakete. Ihre unpaketierten Erweiterungen, beziehungsweise
Dateien, sehen Sie unter [Packages \> List unpackaged files.]{.guihint}
:::

:::: imageblock
::: content
![Liste mit GUI-Erweiterungen.](../images/mkp_visuals_04.png)
:::
::::

::: paragraph
Über [![icon new mkp](../images/icons/icon_new_mkp.png)]{.image-inline}
[Create Package]{.guihint} erstellen Sie nun das Paket.
:::

:::: imageblock
::: content
![Einstellungsdialog eines zu paketierenden
Dashboards.](../images/mkp_visuals_05.png)
:::
::::

::: paragraph
In den Paketeinstellungen fügen Sie unten unter [Packaged
files]{.guihint} die eben erstellte GUI-Erweiterung ein. Natürlich
können dies auch mehrere Dashboards oder sonstige Elemente sein.
Ansonsten müssen Sie vor allem auf die korrekten Versionsinformationen
achten. Zum einen benötigt das Paket selbst eine Versionsnummer. Diese
muss den Richtlinien des [Semantic
Versioning](https://semver.org/){target="_blank"} folgen, also zum
Beispiel `1.0.0`. Zum anderen können Sie die minimal und maximal
unterstützten Checkmk-Versionen angeben. Praktisch ist die Versionierung
für Checkmk-Updates und verteiltes Monitoring mit Instanzen mit
unterschiedlichen Checkmk-Versionen (mehr dazu im
[MKP-Artikel](mkps.html#enabled_inactive_cli)).
:::

::: paragraph
Nach der Paketierung werden Ihre Pakete auf der Startseite der
Erweiterungspakete gelistet --- hier im Beispiel in zwei
unterschiedlichen Versionen, ein mal aktiviert, ein mal deaktiviert:
:::

:::: imageblock
::: content
![Versionierte und paketierte Erweiterungen in der
Übersicht.](../images/mkp_visuals_06.png)
:::
::::

::: paragraph
Unter [All packages (enabled or disabled)]{.guihint} haben Sie nun die
Möglichkeit, die Pakete als MKP-Dateien herunterzuladen.
:::
::::::::::::::::::::

::::::::: sect2
### []{#_gui_mkps_installieren .hidden-anchor .sr-only}2.2. GUI-MKPs installieren {#heading__gui_mkps_installieren}

::: paragraph
Die Installation von Paketen ist weitgehend selbsterklärend. Zunächst
laden Sie das gewünschte Paket unter [Setup \> Maintenance \> Extension
packages]{.guihint} über [![Icon für den
Paket-Upload.](../images/icons/icon_upload.png)]{.image-inline} [Upload
package]{.guihint} hoch.
:::

:::: imageblock
::: content
![Upload-Formular für Erweiterungspakete mit
Dashboard-MKP.](../images/mkp_visuals_07.png)
:::
::::

::: paragraph
Das Paket landet wieder in der Tabelle [All packages (enabled or
disabled)]{.guihint} und kann dort über [![Icon zum Aktivieren von
Erweiterungen.](../images/icons/icon_install.png)]{.image-inline}
aktiviert werden.
:::

:::: imageblock
::: content
![Hochgeladenes, nicht aktiviertes Paket in der
Paketverwaltung.](../images/mkp_visuals_08.png)
:::
::::
:::::::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#cli .hidden-anchor .sr-only}3. Kommandozeile {#heading_cli}

::::::::::: sectionbody
::::: sect2
### []{#_gui_mkps_erstellen_2 .hidden-anchor .sr-only}3.1. GUI-MKPs erstellen {#heading__gui_mkps_erstellen_2}

::: paragraph
Alternativ können Sie auch über die Kommandozeile paketieren. Das
Vorgehen entspricht exakt dem Paketieren funktionaler Erweiterungen, wie
im [MKP-Artikel](mkps.html) ausführlich beschrieben. Daher hier nur die
Kurzversion:
:::

::: {.olist .arabic}
1.  Erstellen des Dashboards.

2.  Wechsel auf die Kommandozeile als Instanzbenutzer.

3.  Nicht paketierte Dateien auflisten:\
    `mkp find`

4.  Erstellen der Paketkonfiguration:\
    `mkp template mydashboard`

5.  Bearbeiten der Konfiguration in:\
    `~/tmp/check_mk/mydashboard.manifest.temp`

6.  Erstellen des Pakets mit:\
    `mkp package tmp/check_mk/mydashboard.manifest.temp`

7.  Paket wird gespeichert unter:\
    `/var/check_mk/packages_local/mydashboard-1.0.0.mkp`
:::
:::::

::::::: sect2
### []{#_gui_mkps_installieren_2 .hidden-anchor .sr-only}3.2. GUI-MKPs installieren {#heading__gui_mkps_installieren_2}

::: paragraph
Wenn Sie derlei MKPs nun installieren und aktivieren möchten:
:::

::: {.olist .arabic}
1.  Installieren:\
    `mkp add /tmp/mydashboard-1.0.0.mkp`

2.  Aktivieren:\
    `mkp enable mydashboard-1.0.0.mkp`
:::

::: paragraph
Befehlsreferenzen, eine Beschreibung des MKP-Formats und weitere
Hinweise finden Sie im [MKP-Artikel.](mkps.html)
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} **Hinweis** für
Nutzer von Checkmk Raw: Auch hier können Sie GUI-Erweiterungen wie alle
anderen MKPs installieren. Da die kommerziellen Editionen jedoch einige
exklusive visuelle Elemente (etwa Dashlets) enthalten, könnten Sie über
eine Meldung folgender Art stolpern:\
`Dashlet type 'state_host' could not be found. Please remove it from your dashboard configuration.`\
Hier fehlt also ein einzelnes Dashlet, das übrige Dashboard ist aber
weiterhin nutzbar.
:::
:::::::
:::::::::::
::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+------------------------------+---------------------------------------+
| Pfad                         | Bedeutung                             |
+==============================+=======================================+
| `~/local/lib                 | Ablageort für als Erweiterung         |
| /check_mk/gui/plugins/views` | geklonte Ansichten.                   |
+------------------------------+---------------------------------------+
| `~/local/lib/c               | Ablageort für als Erweiterung         |
| heck_mk/gui/plugins/reports` | geklonte Berichte.                    |
+------------------------------+---------------------------------------+
| `~/local/lib/chec            | Ablageort für als Erweiterung         |
| k_mk/gui/plugins/dashboards` | geklonte Dashboards.                  |
+------------------------------+---------------------------------------+
| `~/tmp/check_m               | Konfigurationsdatei zum Erstellen des |
| k/mydashboard.manifest.temp` | Pakets.                               |
+------------------------------+---------------------------------------+
| `~/v                         | Ablageort für installierte MKPs.      |
| ar/check_mk/packages_local/` |                                       |
+------------------------------+---------------------------------------+
| `~/local/share               | Ablageort für aktivierte MKPs.        |
| /check_mk/enabled_packages/` |                                       |
+------------------------------+---------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::
