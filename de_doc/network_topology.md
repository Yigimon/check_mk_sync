:::: {#header}
# Netzwerkvisualisierung

::: details
[draft]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/network_topology.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::: {#content}
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
[Blog-Artikel -
Netzwerkvisualisierung](https://checkmk.com/de/blog/network-layer-visualization-with-checkmk)
[Ansichten von Hosts und Services (Views)](views.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::: sectionbody
::: paragraph
Checkmk enthält ab Version [2.3.0]{.new} ein Backend für die
Visualisierung von Netzwerktopologien.
:::
::::
:::::

::::: sect1
## []{#_voraussetzungen .hidden-anchor .sr-only}2. Voraussetzungen {#heading__voraussetzungen}

:::: sectionbody
::: paragraph
Wenn Daten zur Ihrer Netzwerktopologie nicht bereits vorliegen, können
Sie auf ein großes Community-Project zugreifen, welche Sie bei der
Erstellung dieser Daten unterstützt. Wo Sie diese Erweiterungen und
Werkzeuge finden und wie Sie diese einsetzen, lesen Sie in unserem
Blog-Artikel [Netzwerk-Layer-Visualisierung mit Checkmk
erstellen](https://checkmk.com/de/blog/network-layer-visualization-with-checkmk){target="_blank"}.
:::
::::
:::::

:::: sect1
## []{#_datenformat .hidden-anchor .sr-only}3. Datenformat {#heading__datenformat}

::: sectionbody
:::
::::

::::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: sect2
### []{#_auf_dem_checkmk_server .hidden-anchor .sr-only}4.1. Auf dem Checkmk-Server {#heading__auf_dem_checkmk_server}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `~/var/check_mk/topology/data`       | Das Verzeichnis, in dem Sie   |
|                                      | die Daten Ihrer               |
|                                      | Netzwerktopologie ablegen     |
|                                      | müssen.                       |
+--------------------------------------+-------------------------------+
| `~/var/check_mk/topology/configs`    | Das Verzeichnis, in das       |
|                                      | angepasste Layouts Ihrer      |
|                                      | Visualisierung abgelegt       |
|                                      | werden.                       |
+--------------------------------------+-------------------------------+
:::
::::
:::::
::::::::::::::::::::
