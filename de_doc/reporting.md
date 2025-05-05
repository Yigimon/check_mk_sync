:::: {#header}
# Berichte (Reports)

::: details
[Last modified on 28-Jun-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/reporting.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Ansichten von Hosts und Services (Views)](views.html) [Messwerte und
Graphing](graphing.html) [Dashboards](dashboards.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#_was_sind_berichte .hidden-anchor .sr-only}1. Was sind Berichte? {#heading__was_sind_berichte}

::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Ein Bericht in
Checkmk soll in druckbarer Form einen Überblick über die Daten, Inhalte
und Zustände in Checkmk geben. Er ist eine Zusammenstellung
unterschiedlicher Elemente ([Tabellenansichten](glossar.html#view),
[Verfügbarkeitstabellen](availability.html),
[Verlaufsgraphen](graphing.html), Fließtext, Logos) zu einem
druckfähigen PDF-Dokument.
:::

:::: imageblock
::: content
![Beispiel eines Berichts.](../images/reporting_report.png){width="70%"}
:::
::::

::: paragraph
Berichte in Checkmk sind einfach zu handhaben:
:::

::: ulist
- Es sind keine externen Werkzeuge wie Jasper, DB oder Ähnliches
  notwendig.

- Die PDF-Datei wird sauber mit Vektorgrafiken erstellt.

- Berichte können über Schablonen und Vererbung verwaltet werden.

- Mit dem [Berichtsplaner](#scheduler) definieren Sie Berichte, die in
  regelmäßigen Abständen verschickt werden sollen.

- Sofortberichte werden über [Export \> This view as PDF]{.guihint}
  erzeugt.
:::

::::: imageblock
::: content
![Aufgeklapptes \'Export\'-Menü mit dem Eintrag zur
PDF-Erstellung.](../images/reporting_menu_export.png)
:::

::: title
Ansichten können jederzeit als PDF exportiert werden
:::
:::::
:::::::::::
::::::::::::

::::::::::: sect1
## []{#builtin .hidden-anchor .sr-only}2. Vorgefertigte Berichte in Checkmk {#heading_builtin}

:::::::::: sectionbody
::: paragraph
Die kommerziellen Editionen liefern einige vorgefertigte Berichte. Diese
können Sie entweder direkt nutzen, um Auswertungen aus Checkmk zu
erhalten oder auch jederzeit als Vorlage für [eigene
Berichte](#create_reports) nutzen.
:::

::: paragraph
Ebenso wie [Tabellenansichten](glossar.html#view) und
[Dashboards](glossar.html#dashboard) können in Checkmk mitgelieferte
Berichte nicht verändert werden. Aber Sie können alle bereits
vorhandenen Berichte beliebig häufig klonen/kopieren und jeweils an Ihre
Bedürfnisse anpassen. Das Vorgehen bei der Erstellung
[einfacher](#create_reports) aber auch [komplexer](#complex_reports)
Berichte wird im Folgenden beschrieben.
:::

::: paragraph
Einen Überblick über alle Berichte, vorgefertigte und eigene, in Checkmk
finden Sie unter [Customize \> Business reporting \> Reports]{.guihint}
(eventuell müssen Sie vorher noch [show more]{.guihint} anklicken):
:::

::::: imageblock
::: content
![Liste mit Berichten.](../images/reporting_list.png)
:::

::: title
Einige der vorgefertigten Berichte
:::
:::::

::: paragraph
Auf der linken Seite stehen folgende Symbole für die Bearbeitung zur
Verfügung:
:::

+---+-------------------------------------------------------------------+
| [ | Bericht kopieren                                                  |
| ! |                                                                   |
| [ |                                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| m |                                                                   |
| K |                                                                   |
| o |                                                                   |
| p |                                                                   |
| i |                                                                   |
| e |                                                                   |
| r |                                                                   |
| e |                                                                   |
| n |                                                                   |
| e |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| s |                                                                   |
| B |                                                                   |
| e |                                                                   |
| r |                                                                   |
| i |                                                                   |
| c |                                                                   |
| h |                                                                   |
| t |                                                                   |
| s |                                                                   |
| . |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| c |                                                                   |
| l |                                                                   |
| o |                                                                   |
| n |                                                                   |
| e |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Vorschau anzeigen                                                 |
| ! |                                                                   |
| [ |                                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| r |                                                                   |
| E |                                                                   |
| r |                                                                   |
| s |                                                                   |
| t |                                                                   |
| e |                                                                   |
| l |                                                                   |
| l |                                                                   |
| u |                                                                   |
| n |                                                                   |
| g |                                                                   |
| e |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| r |                                                                   |
| B |                                                                   |
| e |                                                                   |
| r |                                                                   |
| i |                                                                   |
| c |                                                                   |
| h |                                                                   |
| t |                                                                   |
| s |                                                                   |
| v |                                                                   |
| o |                                                                   |
| r |                                                                   |
| s |                                                                   |
| c |                                                                   |
| h |                                                                   |
| a |                                                                   |
| u |                                                                   |
| . |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| p |                                                                   |
| d |                                                                   |
| f |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | [Berichtsplaner](#scheduler) öffnen                               |
| ! |                                                                   |
| [ |                                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| m |                                                                   |
| Ö |                                                                   |
| f |                                                                   |
| f |                                                                   |
| n |                                                                   |
| e |                                                                   |
| n |                                                                   |
| d |                                                                   |
| e |                                                                   |
| s |                                                                   |
| B |                                                                   |
| e |                                                                   |
| r |                                                                   |
| i |                                                                   |
| c |                                                                   |
| h |                                                                   |
| t |                                                                   |
| s |                                                                   |
| p |                                                                   |
| l |                                                                   |
| a |                                                                   |
| n |                                                                   |
| e |                                                                   |
| r |                                                                   |
| s |                                                                   |
| . |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| r |                                                                   |
| e |                                                                   |
| p |                                                                   |
| o |                                                                   |
| r |                                                                   |
| t |                                                                   |
| s |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| d |                                                                   |
| u |                                                                   |
| l |                                                                   |
| e |                                                                   |
| r |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
::::::::::
:::::::::::

:::::::::::::::::::::::::: sect1
## []{#_berichte_aufrufen .hidden-anchor .sr-only}3. Berichte aufrufen {#heading__berichte_aufrufen}

::::::::::::::::::::::::: sectionbody
::: paragraph
Berichte können, abhängig von ihrem Kontext und ihrer Bestimmung, an
verschiedenen Punkten in Checkmk aufgerufen werden. So lassen sich die
dafür vorgesehenen Berichte beispielsweise aus dem
[Monitor]{.guihint}-Menü der
[Navigationsleiste](glossar.html#navigation_bar) aufrufen.
:::

:::: imageblock
::: content
![Auswahl der Berichte aus der
Navigationsleiste.](../images/reporting_main_menu.png)
:::
::::

::: paragraph
Kontextabhängig finden Sie die Berichte im Menü [Export]{.guihint} der
verschiedenen Ansichten:
:::

:::: imageblock
::: content
![Liste der Berichte im Menü
Export.](../images/reporting_exportmenu.png)
:::
::::

::: paragraph
Über das Snapin [Reporting]{.guihint} der
[Seitenleiste](glossar.html#sidebar) erhalten Sie raschen Zugriff auf
alle Berichte, die für die Anzeige in [Monitor]{.guihint}-Menü und der
Seitenleiste vorgesehen sind, und den [Berichtsplaner](#scheduler)
([(Scheduler)]{.guihint}):
:::

::::: imageblock
::: content
![Snapin \'Reporting\' in der
Seitenleiste.](../images/reporting_sidebar.png){width="45%"}
:::

::: title
Das Snapin [Reporting]{.guihint} können Sie der Seitenleiste hinzufügen
:::
:::::

::: paragraph
In diesem Snapin befinden sich drei Knöpfe:
:::

+--------------------+-------------------------------------------------+
| [Change            | Zeitfenster für Sofortberichte ändern           |
| Ti                 |                                                 |
| merange]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
| [Sc                | [Berichtsplaner](#scheduler) öffnen             |
| heduler]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
| [Edit]{.guihint}   | Liste vorhandener Berichte öffnen               |
+--------------------+-------------------------------------------------+

::::::::::::: sect2
### []{#_kontext_für_berichte .hidden-anchor .sr-only}3.1. Kontext für Berichte {#heading__kontext_für_berichte}

::: paragraph
Um Berichten einen Kontext zu geben, sie also mit Daten bestimmter Hosts
und Services zu füllen, gibt es verschiedene Möglichkeiten. Daraus
resultiert dann auch, dass die Berichte unterschiedlich aufgerufen
werden müssen, um sinnvolle Informationen zu enthalten. Fehlt der
Kontext, also die Angabe, welche Hosts und Services in den Bericht
einfließen sollen, so bekommen Sie statt einer korrekten Ausgabe nur rot
hervorgehobene Fehlermeldungen:
:::

:::: imageblock
::: content
![Ausgabe eines Berichts mit unspezifizierten
Daten.](../images/reporting_output_red.png){width="79%"}
:::
::::

::: paragraph
Der Unterschied besteht darin, an welcher Stelle der Kontext festgelegt
wird:
:::

::: ulist
- Kontext vorgegeben (über Berichtseigenschaften): Der Bericht kann von
  überall aufgerufen werden. Er ist immer mit korrekten Informationen
  gefüllt.

- Kontext nicht vorgegeben: Der Aufruf erfolgt über das Menü
  [Export]{.guihint} in den verschiedenen Ansichten. Der Kontext wird
  durch die (gefilterte) Ansicht geliefert.
:::

:::: imageblock
::: content
![Ausgabe eines Berichts mit spezifizierten
Daten.](../images/reporting_output_nored.png){width="78%"}
:::
::::

::: paragraph
Denken Sie nun nochmal an das oben erwähnte Snapin
[Reporting]{.guihint}: Hierüber gelangen Sie ohne weitere Vorauswahl /
Einschränkung etc. direkt zu den gerenderten Berichten. Sinnvoll sind
hier also eigentlich nur solche Berichte, die einen *eingebauten*
Kontext haben. Berichte, deren Kontext erst über (gefilterte) Ansichten
entsteht, können Sie daher getrost über die Option [Hide this report in
the monitor menu]{.guihint} aus dem [Monitor]{.guihint}-Menü sowie dem
Snapin ausschließen.
:::

:::: imageblock
::: content
![Auswahl zum Ausblenden des Berichts in \'Monitor\'-Menü und
Snapin.](../images/reporting_general_properties_view2.png)
:::
::::
:::::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#create_reports .hidden-anchor .sr-only}4. Einen ersten eigenen Bericht erstellen {#heading_create_reports}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Auf Basis der vorhandenen Berichte und Berichtsvorlagen können Sie
relativ schnell und einfach einen ersten eigenen Bericht erstellen. Wie
Sie dabei am Besten vorgehen, erklären wir Ihnen gleich. Tiefergehende
Informationen rund um komplexere Berichte folgen dann [weiter
unten](#complex_reports) im Text.
:::

::: paragraph
Die schnellste Methode einen Bericht zu erstellen ist, einen vorhandenen
Bericht zu kopieren und dann anzupassen. Wollen Sie zum Beispiel eine
Übersicht über die Verfügbarkeit der Services auf einem spezifischen
Host, dem Host namens `mycmkserver`, erstellen, so gehen Sie
folgendermaßen vor.
:::

::: paragraph
Öffnen Sie als erstes die Berichtsübersicht mit [Customize \> Business
reporting \> Reports:]{.guihint}
:::

:::: imageblock
::: content
![Auswahl aus der Liste mit
Berichten.](../images/reporting_list_selection.png)
:::
::::

::: paragraph
Mit einem Klick auf [![Symbol zum Kopieren eines
Berichts.](../images/icons/icon_clone.png)]{.image-inline} vor dem
Bericht [service_availability]{.guihint} gelangen Sie in die
Grundeinstellungen Ihrer Berichtskopie:
:::

:::: imageblock
::: content
![Eingabe der Grundeinstellungen eines
Reports.](../images/reporting_general_properties_simple.png)
:::
::::

::: paragraph
Geben Sie die gewünschten Texte für [Unique ID]{.guihint} und
[Title]{.guihint} ein. Mit den weiteren Optionen in diesem Kasten sowie
den [Report Properties]{.guihint} befassen wir uns erst bei den
[komplexeren Berichten.](#complex_reports)
:::

::: paragraph
Für den Moment reicht es, wenn Sie nach unten zum Kasten [Context /
Search Filters]{.guihint} scrollen. Wählen Sie bei [Host]{.guihint} die
Option [Hostname]{.guihint} aus. Sobald Sie jetzt auf [Add
filter]{.guihint} klicken, können Sie aus der Liste der Host-Namen den
passenden Host wählen:
:::

:::: imageblock
::: content
![Auswahl des passenden Hosts für den
Bericht.](../images/reporting_filter_host.png)
:::
::::

::: paragraph
Mit [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline} speichern Sie
Ihren Bericht und kehren zur Übersichtsseite der Berichte zurück. Unter
[Customized]{.guihint} können Sie nun direkt Ihren neuen Bericht
aufrufen, indem Sie auf den Titel klicken:
:::

:::: imageblock
::: content
![Ansicht des eigenen Berichts.](../images/reporting_customized.png)
:::
::::

::::: sect2
### []{#_bearbeitungsfunktionen .hidden-anchor .sr-only}4.1. Bearbeitungsfunktionen {#heading__bearbeitungsfunktionen}

::: paragraph
Für die Bearbeitung eigener Berichte können Sie auf folgende Funktionen
zurückgreifen:
:::

+---+-------------------------------------------------------------------+
| [ | Bericht kopieren                                                  |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| l |                                                                   |
| o |                                                                   |
| n |                                                                   |
| e |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| c |                                                                   |
| l |                                                                   |
| o |                                                                   |
| n |                                                                   |
| e |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Bericht löschen                                                   |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| d |                                                                   |
| e |                                                                   |
| l |                                                                   |
| e |                                                                   |
| t |                                                                   |
| e |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| d |                                                                   |
| e |                                                                   |
| l |                                                                   |
| e |                                                                   |
| t |                                                                   |
| e |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Berichtseinstellungen bearbeiten                                  |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| e |                                                                   |
| d |                                                                   |
| i |                                                                   |
| t |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| e |                                                                   |
| d |                                                                   |
| i |                                                                   |
| t |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Berichtsinhalte bearbeiten                                        |
| ! |                                                                   |
| [ |                                                                   |
| b |                                                                   |
| u |                                                                   |
| t |                                                                   |
| t |                                                                   |
| o |                                                                   |
| n |                                                                   |
| r |                                                                   |
| e |                                                                   |
| p |                                                                   |
| o |                                                                   |
| r |                                                                   |
| t |                                                                   |
| e |                                                                   |
| l |                                                                   |
| e |                                                                   |
| m |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
| l |                                                                   |
| o |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| b |                                                                   |
| u |                                                                   |
| t |                                                                   |
| t |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| r |                                                                   |
| e |                                                                   |
| p |                                                                   |
| o |                                                                   |
| r |                                                                   |
| t |                                                                   |
| _ |                                                                   |
| e |                                                                   |
| l |                                                                   |
| e |                                                                   |
| m |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
| _ |                                                                   |
| l |                                                                   |
| o |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Vorschau anzeigen                                                 |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| p |                                                                   |
| d |                                                                   |
| f |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| p |                                                                   |
| d |                                                                   |
| f |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Regelmäßigen Bericht planen                                       |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| r |                                                                   |
| e |                                                                   |
| p |                                                                   |
| o |                                                                   |
| r |                                                                   |
| t |                                                                   |
| s |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| d |                                                                   |
| u |                                                                   |
| l |                                                                   |
| e |                                                                   |
| r |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| r |                                                                   |
| e |                                                                   |
| p |                                                                   |
| o |                                                                   |
| r |                                                                   |
| t |                                                                   |
| s |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| d |                                                                   |
| u |                                                                   |
| l |                                                                   |
| e |                                                                   |
| r |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+

::: paragraph
Eine Beschreibung der unterschiedlichen Möglichkeiten folgt in den
weiteren Abschnitten.
:::
:::::

:::::::::::::::::::::::::::: sect2
### []{#_ohne_vorlage_einen_neuen_bericht_erstellen .hidden-anchor .sr-only}4.2. Ohne Vorlage einen neuen Bericht erstellen {#heading__ohne_vorlage_einen_neuen_bericht_erstellen}

::: paragraph
Ein wenig komplexer wird es nun, wenn Sie anstelle einer Berichtskopie
einen komplett neuen Bericht erstellen wollen. Als Beispiel erstellen
Sie im Folgenden eine einfache Übersicht über alle problematischen
Services Ihrer Instanz, d.h. alle Services im Status [WARN]{.state1},
[CRIT]{.state2} oder [UNKNOWN]{.state3}. Diese Übersicht wird den Titel
„critical_services" tragen.
:::

::: paragraph
Einen neuen Bericht legen Sie auf der Seite [Edit Reports]{.guihint}
über [Reports \> Add report]{.guihint} an.
:::

:::: imageblock
::: content
![Öffnen eines neuen
Berichts.](../images/reporting_add_report.png){width="38%"}
:::
::::

::: paragraph
Im ersten Schritt lassen Sie den Filter [Select specific object
type]{.guihint} auf der Auswahl [No restrictions to specific
objects]{.guihint} stehen und wechseln direkt mit [![Symbol zum
Fortfahren.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} zur nächsten Auswahl.
:::

:::: imageblock
::: content
![Auswahl \'Keine Einschränkung auf spezifische Objekte\'
beibehalten.](../images/reporting_no_specific_objects.png)
:::
::::

::: paragraph
Wie beim Kopieren eines bestehenden Berichts geben Sie auch hier zuerst
[Unique ID]{.guihint} und [Title]{.guihint} an:
:::

:::: imageblock
::: content
![Vergabe von eindeutiger ID und Titel für den neuen
Bericht.](../images/reporting_general_properties2.png)
:::
::::

::: paragraph
Im Abschnitt [Context / Search Filters]{.guihint} wählen Sie nun unter
[Service]{.guihint} die [Service states]{.guihint} aus. Nach einem Klick
auf [Add filter]{.guihint} können Sie die gewünschten Zustände
festlegen:
:::

:::: imageblock
::: content
![Auswahl der Service-Zustände für den
Report.](../images/reporting_search_filters.png)
:::
::::

::: paragraph
Mit [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline} [Save & go to
list]{.guihint} wird der neue Bericht in den Abschnitt
[Customized]{.guihint} der Übersichtsliste der Berichte aufgenommen.
:::

:::: imageblock
::: content
![Liste der Berichte mit dem erstellten eigenen
Bericht.](../images/reporting_customized2.png)
:::
::::

::: paragraph
Wenn Sie diesen Bericht jetzt in freudiger Erwartung aufrufen, ist das
Ergebnis ernüchternd. Die Berichtsseite hat zwar ein erstes Layout und
auch eine Überschrift, ist aber ansonsten leer. Nicht gerade das
Ergebnis, mit dem man seinen Chef beeindrucken kann ...​
:::

:::: imageblock
::: content
![Leerer Bericht.](../images/reporting_empty_report.png)
:::
::::

::: paragraph
Deshalb muss nun die Gestaltung des Inhalts für den Bericht definiert
werden. Über das Symbol [![Symbol für die Bearbeitung des
Berichtsinhalts.](../images/icons/icon_edit_report.png)]{.image-inline}
gelangen Sie zur Inhaltsfestlegung für den Bericht. Die Auswahl von
Berichtselementen erfolgt dreistufig, jeweils mit einem Klick auf
[![Symbol für das Fortfahren im
Prozess.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} dazwischen.
:::

::: paragraph
Beginnen Sie mit einem Klick auf [Add content.]{.guihint} Wählen Sie für
dieses Beispiel in [Step 1]{.guihint} den Elementtyp [Availability
table.]{.guihint} Setzen Sie [Step 2]{.guihint} auf die Auswahl [All
services]{.guihint} und [Step 3]{.guihint} auf die Auswahl [No
restrictions to specific objects.]{.guihint} Die weiteren Optionen der
nachfolgenden Seite lassen Sie für den Moment erst einmal unverändert.
Stattdessen klicken Sie direkt auf [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint}. Betrachten Sie nun die Vorschau auf Ihren Bericht:
:::

:::: imageblock
::: content
![Vorschau des Berichts mit dem hinzugefügten
Inhalt.](../images/reporting_content_output.png)
:::
::::

::: paragraph
Auf der linken Seite sehen Sie die Vorschau, hier für den Bericht
[critical_services.]{.guihint} Rechts daneben werden die Elemente des
Berichts in einer Liste angezeigt. Diese Elemente werden mit den
Symbolen [![icon edit](../images/icons/icon_edit.png)]{.image-inline}
bearbeitet, [![icon
clone](../images/icons/icon_clone.png)]{.image-inline} kopiert, [![icon
delete](../images/icons/icon_delete.png)]{.image-inline} gelöscht und
[![icon drag](../images/icons/icon_drag.png)]{.image-inline} umsortiert.
:::

::: paragraph
Diesen einfachen, selbst erstellten Bericht können Sie nun flexibel um
weitere Elemente erweitern (siehe unten) und jederzeit, z. B. aus der
Seitenleiste heraus, aufrufen.
:::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#complex_reports .hidden-anchor .sr-only}5. Aufbau komplexer Berichte {#heading_complex_reports}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
In den vorherigen Abschnitten haben Sie gesehen, wie man mit geringem
Aufwand erste Berichte erstellen kann, entweder als Kopie eines
bestehenden Berichts oder auch komplett neu. Diese Möglichkeiten sind
toll, um erste Erfolge zu erzielen. Meist bleibt es jedoch nicht bei so
einfach strukturierten Berichten. Komplexere Darstellungen, eine
Mischung verschiedener Inhalte, ein eigenes Layout usw. sind der nächste
logische Schritt.
:::

::: paragraph
Die vielen Möglichkeiten lassen sich am Besten an einem Beispiel
aufzeigen:
:::

:::: imageblock
::: content
![reporting complex report](../images/reporting_complex_report.png)
:::
::::

:::::::::::::::: sect2
### []{#_grundeinstellungen_setzen .hidden-anchor .sr-only}5.1. Grundeinstellungen setzen {#heading__grundeinstellungen_setzen}

::: paragraph
In beinahe jedem Schritt der Berichtserstellung gibt es die Möglichkeit,
die Inhalte an Ihre Bedürfnisse anzupassen.
:::

::: paragraph
Im ersten Schritt können Sie einen Filter setzen und den Bericht von
vornherein auf einen bestimmten Host oder eine bestimmte Datenquelle
beschränken, etwa Netzwerkschnittstellen, BI-Aggregate, Sensoren und so
weiter:
:::

::::: imageblock
::: content
![Liste mit Filtern für die Beschränkung des
Berichts.](../images/reporting_specific_objects.png)
:::

::: title
Meist werden Sie die Filter auf dieser Ebene jedoch nicht benötigen
:::
:::::

::: paragraph
Als nächstes tragen Sie wieder die [Unique ID]{.guihint} und den
[Title]{.guihint} ein. Für den Titel können Sie auch die mitgelieferten
[Makros](#macros) (=Textbausteine) nutzen. Wählen Sie als nächstes ein
[Icon]{.guihint}, mit dem der Bericht in den Menüs sichtbar sein soll.
Durch die Einstellung der Option [Make this report available for other
users]{.guihint} auf die Kontaktgruppe, im Beispiel `check-mk-notify`,
geben Sie den zugehörigen Gruppenmitgliedern die Möglichkeit, den
Bericht jederzeit eigenständig aufzurufen und sich selbstständig zu
informieren.
:::

:::: imageblock
::: content
![Einstellung der komplexeren Grundeigenschaften für den
Bericht.](../images/reporting_general_properties_complex.png)
:::
::::

::: paragraph
Im Kasten [Context / Search Filters]{.guihint} stehen Ihnen wie üblich
umfangreiche Filtermöglichkeiten zur Verfügung, von bestimmten Hosts
über einzelne Docker-Container bis hin zu Werten aus der
Oracle-Überwachung.
:::

:::: imageblock
::: content
![Auswahl für die
Berichtsinhalte.](../images/reporting_context_search_filters.png)
:::
::::

::: paragraph
Für dieses Beispiel ist die Host-Auswahl auf einen Ordner beschränkt und
zusätzlich auf festgelegte Host-Probleme. Diese Einschränkung
beschleunigt, gerade in komplexeren Umgebungen, die Datenabfrage.
:::

::: paragraph
Mit [Save & go to list]{.guihint} gelangen Sie zur Berichtsübersicht.
Als nächstes geht es an die Ausgestaltung des Berichtsinhalts.
:::
::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect2
### []{#_berichtsinhalt_definieren .hidden-anchor .sr-only}5.2. Berichtsinhalt definieren {#heading__berichtsinhalt_definieren}

::: paragraph
Mit Hilfe des Symbols [![button report element
lo](../images/icons/button_report_element_lo.png)]{.image-inline}
gelangen Sie zur inhaltlichen Gestaltung:
:::

:::: imageblock
::: content
![Aufruf der Inhaltsgestaltung.](../images/reporting_edit_content.png)
:::
::::

::: paragraph
Öffnen Sie mit [Reports \> Add content]{.guihint} die Bearbeitung des
Berichtsinhalts. Hiermit fügen Sie beispielsweise Tabellen, Graphen,
Inhaltsverzeichnisse oder Texte (auch via Makros oder HTTP) in den
Bericht ein. Diese Inhalte erscheinen nacheinander und bestimmen so auch
die finale Länge des Berichts.
:::

::::: imageblock
::: content
![Hinzufügen eines
Inhaltselements.](../images/reporting_add_content.png){width="58%"}
:::

::: title
Eine Auflistung aller Inhaltselemente finden Sie am [Ende des
Artikels](#content_elements)
:::
:::::

::: paragraph
Wählen Sie in Schritt 1 ([Step 1]{.guihint}) das gewünschte Element aus,
für dieses Beispiel [Multiple graphs.]{.guihint} Damit erhalten Sie,
abhängig von Ihren weiteren Einstellungen, mehrere gleichartige Grafiken
untereinander. So können Sie zum Beispiel den direkten Vergleich
zwischen den Zuständen mehrerer Hosts abbilden.
:::

:::: imageblock
::: content
![Auswahl mehrerer Grafiken.](../images/reporting_step1.png)
:::
::::

::: paragraph
Fahren Sie mit [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} fort. Als Datenquelle für die Grafiken wählen Sie
in Schritt 2 für dieses Beispiel [All services,]{.guihint} d.h. alle auf
den Hosts laufenden Services:
:::

:::: imageblock
::: content
![Auswahl der Datenquelle.](../images/reporting_step2.png)
:::
::::

::: paragraph
Fahren Sie mit [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} fort. In Schritt 3 könnten Sie nun die anzuzeigende
Datenmenge beschränken. Dies wird für das aktuelle Beispiel nicht
benötigt. Wieder wechseln Sie mit [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} zur nächsten Auswahl.
:::

:::: imageblock
::: content
![Festlegung verschiedener
Eigenschaften.](../images/reporting_properties_context.png)
:::
::::

::: paragraph
Für den Beispielbericht legen Sie im Kasten [Properties]{.guihint} unter
[Graph layout]{.guihint} fest, dass Sie für die Grafiken jeweils einen
Titel sehen wollen, bestehend aus dem Grafiktitel, dem Host-Namen und
der Service-Beschreibung. Zudem setzen Sie die angezeigte Zeitspanne
unter [Graph time range]{.guihint} auf vier Stunden.
:::

::: paragraph
Im Kasten [Context / Search Filters]{.guihint} schränken Sie den Bericht
auf festgelegte Host- oder Service-Merkmale ein. Hier wählen Sie diesmal
[CPU utilization]{.guihint} für den [Service]{.guihint} aus.
:::

::: paragraph
Mit einem Klick auf [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint} haben Sie das erste Berichtselement fertiggestellt.
:::

::: paragraph
Für die zweite Grafik im Beispiel beginnen Sie wieder mit [Reports \>
Add content]{.guihint} und wählen in [Step 1]{.guihint} die Option
[Metrics graph of a single service.]{.guihint} Wechseln Sie mit
[![Symbol zum
Weiterspringen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} zu [Step 2]{.guihint} und beschränken Sie die
Suchfilter auf Host-Name und Service-Beschreibung:
:::

:::: imageblock
::: content
![Auswahl von Host-Name und
Service-Beschreibung.](../images/reporting_context_search_filters2.png)
:::
::::

::: paragraph
Mit einem Klick auf [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint} ist auch das zweite Berichtselement fertig.
:::

::: paragraph
Als drittes Element erstellen Sie eine Übersicht aktueller
Alarmierungen. Das Vorgehen bleibt wie gehabt:
:::

::: {.olist .arabic}
1.  Aufruf von [Reports \> Add content]{.guihint}

2.  [Step 1:]{.guihint} Auswahl des Elements [Availability
    table]{.guihint}

3.  [Step 2:]{.guihint} Datenquelle [Alert Statistics]{.guihint}

4.  [Step 3:]{.guihint} Einschränkung auf [Restrict to a single
    host]{.guihint}

5.  Keine weiteren Optionen im nachfolgenden Schritt
:::

::: paragraph
Mit einem Klick auf [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint} ist auch dieses Berichtselement fertig.
:::

::: paragraph
Um die Darstellung übersichtlicher zu gestalten, fügen Sie noch
Überschriften ein:
:::

::: paragraph
Öffnen Sie mit [Reports \> Add content]{.guihint} die Bearbeitung des
Berichtsinhalts. Wählen Sie in [Step 1]{.guihint} als Elementtyp
[Heading]{.guihint}. Wechseln Sie mit [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} zu [Step 2.]{.guihint} Optional können Sie eine
Hierarchieebene für die Überschrift angeben. Tragen Sie die Überschrift
bei [The text]{.guihint} ein.
:::

:::: imageblock
::: content
![Eingabe der Überschrift.](../images/reporting_add_heading.png)
:::
::::

::: paragraph
Mit einem Klick auf [![Symbol zum
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint} kehren Sie zur Übersicht zurück. Die neue Überschrift
befindet sich jetzt jedoch in der Reihenfolge unterhalb der Grafiken.
Klicken Sie daher in der Liste der Inhaltselemente auf das entsprechende
[![Symbol zum
Verschieben.](../images/icons/icon_drag.png)]{.image-inline} und
verschieben Sie die Überschrift an die gewünschte Position in der Liste.
:::

:::: imageblock
::: content
![Bearbeitungsansicht des Berichts mit roten
Elementen.](../images/reporting_content_overview.png)
:::
::::

::: paragraph
**Tipp:** In der Vorschau sehen Sie möglicherweise rote Zeilen und
Fehlermeldungen statt echter Daten --- denn an diesen Stellen fehlt dem
Bericht im Editor der Kontext, hier also etwa die Angabe eines Hosts,
der sich erst über den Aufruf des Berichts aus einer entsprechenden
Ansicht ergeben würde. Wenn Sie eine brauchbare Vorschau sehen wollen,
filtern Sie einfach in den Berichtseinstellungen im Bereich [Context /
Search Filters]{.guihint} zwischenzeitlich auf einen bestimmten Host.
Das macht das Gestalten deutlich einfacher.
:::

:::: imageblock
::: content
![Bearbeitungsansicht des Berichts ohne rote
Elemente.](../images/reporting_content_overview2.png)
:::
::::
:::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect2
### []{#views .hidden-anchor .sr-only}5.3. Optische Gestaltung des Berichts {#heading_views}

::: paragraph
Um den Bericht zu strukturieren, gibt es ergänzende Gestaltungselemente:
Horizontale Linie, Bild, Seitenrahmen und eine einzelne Textzeile. Diese
Bausteine können Sie auf allen oder bestimmten Seiten Ihres Berichts
anzeigen lassen.
:::

::: paragraph
Für den Beispielbericht fügen Sie einen Rahmen um den Bericht ein. Auch
hier erfolgt die Definition wieder schrittweise, jeweils fortgesetzt mit
einem Klick auf [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}. Beginnen
Sie mit [Reports \> Add page element.]{.guihint}
:::

::::: imageblock
::: content
![Auswahl des Rahmens.](../images/reporting_step1_fixed.png)
:::

::: title
Eine Auflistung aller Seitenelemente finden Sie am [Ende des
Artikels](#page_elements)
:::
:::::

::: paragraph
Da der Rahmen auf allen Seiten sichtbar sein soll, erfordert der nächste
Schritt keine Änderungen:
:::

:::: imageblock
::: content
![Auswahl der Positionierung.](../images/reporting_placement.png)
:::
::::

::: paragraph
Der neue Seitenrahmen wird nun in der Übersicht angezeigt, sowohl in der
Vorschau links als auch in der Tabelle der statischen Seitenelemente
rechts.
:::

:::: imageblock
::: content
![Aktuelle Übersicht des
Berichts.](../images/reporting_content_overview3.png)
:::
::::

::: paragraph
**Tipp:** Die in Checkmk vorhandenen [Makros](#macros) (=Textbausteine)
können Sie zum Beispiel auch nutzen, um noch eine Fußzeile mit
Seitenzahl und Namen des Berichts zu erstellen. Wählen Sie dazu das
Seitenelement [One line of text]{.guihint} und geben Sie im zweiten
Schritt die Position am unteren Seitenende sowie den Text inklusive der
gewünschten Makros an:
:::

:::: imageblock
::: content
![Festlegung der Fußzeile.](../images/reporting_footer.png)
:::
::::
:::::::::::::::::

::::::::::::::::::::::::::::::: sect2
### []{#_das_layout_anpassen .hidden-anchor .sr-only}5.4. Das Layout anpassen {#heading__das_layout_anpassen}

::: paragraph
Mit einem hochwertigeren Erscheinungsbild, z.B. mit dem Firmenlogo
versehen, wirken Berichte gleich ansprechender.
:::

::: paragraph
Öffnen Sie mit [Reports \> Edit properties]{.guihint} die
Berichtseinstellungen:
:::

:::: imageblock
::: content
![Auswahl der
Berichtseinstellungen.](../images/reporting_edit_properties.png){width="62%"}
:::
::::

::: paragraph
Im zweiten Kasten finden Sie hier die [Report Properties.]{.guihint} An
dieser Stelle konfigurieren Sie Werte für Schrift, Seitenformat, Zeit-
und Datumseinstellungen, das Berichtslayout und den Dateinamen bei
Downloads.
:::

::::: imageblock
::: content
![Formular für Layout-Voreinstellungen eines
Berichts.](../images/reporting_report_properties2.png)
:::

::: title
An dieser Stelle können Sie grundlegende Gestaltungsmerkmale vorgeben
:::
:::::

::: paragraph
Kopieren Sie Ihr Firmenlogo in das Verzeichnis
`~/local/share/check_mk/reporting/images/` und speichern Sie es als
Datei `logo_mk.png`. Ab sofort wird dieses Logo auf allen Berichten
angezeigt.
:::

:::: imageblock
::: content
![Ansicht des Berichtskopfes mit eigenem
Logo.](../images/reporting_own_logo.png){width="80%"}
:::
::::

::: paragraph
**Hinweis:** Aktuell passen Sie die bestehende Berichtsvorlage an Ihre
Bedürfnisse an. Alternativ können Sie auch eine [komplette, neue
Berichtsvorlage](#new_template) entsprechend Ihren Firmenvorgaben
erstellen, z.B. um das Corporate Design des Unternehmens abzubilden.
:::

:::::::::::::::::: sect3
#### []{#_zusätzliches_bild_einfügen .hidden-anchor .sr-only}Zusätzliches Bild einfügen {#heading__zusätzliches_bild_einfügen}

::: paragraph
Bilder, die Sie in Ihren Berichten als Gestaltungselemente verwenden
möchten, müssen vorher im Verzeichnis
`~/local/share/check_mk/reporting/images/` abgelegt worden sein.
:::

::: paragraph
Klicken Sie in der Berichtserstellung auf den Knopf [Add page
element]{.guihint}.
:::

:::: imageblock
::: content
![Aufruf der Auswahl von
Bildelementen.](../images/reporting_add_page_element.png){width="71%"}
:::
::::

::: paragraph
Wählen Sie in dem folgenden [Step 1]{.guihint} als Typ [Embedded
image]{.guihint} und setzen Sie mit [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint} fort.
:::

::::: imageblock
::: content
![Dialog zur Auswahl eines
Bildelements.](../images/reporting_image_add.png)
:::

::: title
Eine Auflistung aller Seitenelemente finden Sie am [Ende des
Artikels](#page_elements)
:::
:::::

::: paragraph
Im folgenden Dialog werden Detaileinstellungen wie Position, Dateiname
und Größe gesetzt.
:::

::::: imageblock
::: content
![Dialog für
Bildeigenschaften.](../images/reporting_image_properties.png)
:::

::: title
Größenangaben in Millimetern für einfache Druckgestaltung
:::
:::::

::: paragraph
Wenn Sie mit allen Einstellungen fertig sind, speichern Sie mit
[![Symbol zum Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save.]{.guihint} Danach gelangen Sie in die Berichtsübersicht und sehen
das eingefügte Bild im Bericht.
:::

:::: imageblock
::: content
![Ansicht des Berichtskopfes mit eigenem
Logo.](../images/reporting_own_pic.png){width="80%"}
:::
::::
::::::::::::::::::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::: sect1
## []{#scheduler .hidden-anchor .sr-only}6. Bericht zeitlich planen {#heading_scheduler}

::::::::::::::::::::::::: sectionbody
::: paragraph
Über den Berichtsplaner können Sie vorhandene Berichte automatisiert
erstellen und versenden lassen. Sie erreichen den Planer auf der Seite
[Edit Reports]{.guihint} über [Reports \> Scheduler.]{..guihint}
:::

::::::::::::::: sect2
### []{#_regelmäßig_einen_bericht_verschicken .hidden-anchor .sr-only}6.1. Regelmäßig einen Bericht verschicken {#heading__regelmäßig_einen_bericht_verschicken}

::: paragraph
Öffnen Sie mit [Scheduled reports \> Add schedule]{.guihint} einen neuen
Plan, wählen Sie dann den Bericht aus und klicken Sie [![Symbol zum
Fortsetzen.](../images/icons/icon_save.png)]{.image-inline}
[Continue]{.guihint}.
:::

::: paragraph
Im Kasten [General Options]{.guihint} legen Sie Grundeinstellungen wie
Titel, Erstellungszeit, Berichtszeitraum und so weiter fest:
:::

::::: imageblock
::: content
![Einstellungen für den
Berichtsplaner.](../images/reporting_schedule.png)
:::

::: title
Sie können sich zum Beispiel automatisch freitagnachmittags einen
Wochenbericht per PDF zuschicken lassen
:::
:::::

::: paragraph
Unter [Context / Search Filters]{.guihint} finden Sie die üblichen
Filtermöglichkeiten, abhängig vom gewählten Bericht. Speichern Sie den
Plan anschließend, um zur Liste Ihrer geplanten Berichte zurückzukehren.
:::

::: paragraph
In der Liste finden Sie auch Informationen darüber, wann der Bericht zum
letzten Mal erzeugt/versandt wurde, ob dabei ein Fehler aufgetreten ist,
wann er das nächste Mal erzeugt/versendet wird und einiges mehr (hier
leicht gekürzt):
:::

::::: imageblock
::: content
![Liste mit geplanten Berichten.](../images/reporting_schedule_list.png)
:::

::: title
Ein geplanter Bericht mit ausführlichen, hier leicht gekürzten,
Informationen
:::
:::::

::: paragraph
Einträge in der Liste werden über die fünf Symbole am Anfang eines
Eintrags verwaltet:
:::

+------+---------------------------------------------------------------+
| [![  | Berichtseinstellungen bearbeiten                              |
| icon |                                                               |
| edit |                                                               |
| ](.. |                                                               |
| /ima |                                                               |
| ges/ |                                                               |
| icon |                                                               |
| s/ic |                                                               |
| on_e |                                                               |
| dit. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Berichtseinstellungen kopieren                                |
| icon |                                                               |
| cl   |                                                               |
| one] |                                                               |
| (../ |                                                               |
| imag |                                                               |
| es/i |                                                               |
| cons |                                                               |
| /ico |                                                               |
| n_cl |                                                               |
| one. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Geplanten Bericht löschen                                     |
| icon |                                                               |
| dele |                                                               |
| te]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _del |                                                               |
| ete. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Bericht erzeugen                                              |
| icon |                                                               |
| pd   |                                                               |
| f](. |                                                               |
| ./im |                                                               |
| ages |                                                               |
| /ico |                                                               |
| ns/i |                                                               |
| con_ |                                                               |
| pdf. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [![  | Vorschau anzeigen                                             |
| icon |                                                               |
| pdfp |                                                               |
| revi |                                                               |
| ew]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _pdf |                                                               |
| prev |                                                               |
| iew. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+

::: paragraph
**Hinweis:** Versendete Berichte werden nicht in der Instanz
gespeichert.
:::
:::::::::::::::

:::::::::: sect2
### []{#_einen_bericht_regelmäßig_lokal_ablegen .hidden-anchor .sr-only}6.2. Einen Bericht regelmäßig lokal ablegen {#heading__einen_bericht_regelmäßig_lokal_ablegen}

::: paragraph
Statt den Bericht zu versenden, können Sie diesen auch lokal ablegen.
Wählen Sie dafür [Action - Store locally]{.guihint}:
:::

:::: imageblock
::: content
![Parameter für die lokale Ablage eines
Berichts.](../images/reporting_general_options_local.png)
:::
::::

::: paragraph
Legen Sie dann einen Dateinamen und optional einen Berichtstitel fest.
Um eine Historie der Berichte aufbauen zu können - anstatt bei jeder
Erstellung des Berichts die Vorgängerversion zu überschreiben, bietet
Checkmk diverse [Makros](#macros) (=Textbausteine) an.
:::

::: paragraph
Die Übersicht aller lokal gespeicherten Berichte können Sie im Fenster
[Edit Reports]{.guihint} über den Menüeintrag [Reports \> Stored
reports]{.guihint} aufrufen:
:::

:::: imageblock
::: content
![Aufruf der gespeicherten
Berichte.](../images/reporting_reports_storedreports.png){width="34%"}
:::
::::
::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

:::::::: sect1
## []{#global_settings .hidden-anchor .sr-only}7. Globale Vorgaben für Berichte {#heading_global_settings}

::::::: sectionbody
::: paragraph
Einige grundlegende Einstellungen für Berichte können Sie global
festlegen, zum Beispiel um ein Corporate Design zentral zu erstellen und
zu verwalten. Einstellungen zu einem einzelnen Bericht legen dann nur
noch die Abweichungen zum Corporate Design fest. Die globalen
Voreinstellungen für Berichte konfigurieren Sie über [Setup \> General
\> Global settings \> Reporting.]{.guihint}
:::

::::: imageblock
::: content
![Globale Einstellungen für
Berichte.](../images/reporting_global_settings.png)
:::

::: title
Einstellungen wie Vorlagen und Schriftgrößen können Sie übergreifend
festlegen
:::
:::::
:::::::
::::::::

:::::::::::::::::::::: sect1
## []{#new_template .hidden-anchor .sr-only}8. Eine eigene Berichtsvorlage erstellen {#heading_new_template}

::::::::::::::::::::: sectionbody
::: paragraph
Checkmk stellt eine vorgefertigte, übersichtliche Berichtsvorlage
bereit, die Sie, wie oben beschrieben, beliebig ergänzen und nutzen
können. Gerade Berichte, die an das Management weitergereicht werden,
wirken aber noch einmal so gut, wenn sie dem eigenen Firmenlayout
entsprechen. Dazu gibt es die Möglichkeit, eine eigene Berichtsvorlage
zu erstellen.
:::

::: paragraph
Standardmäßig wird für alle Berichte in Checkmk das [Default template
for all reports]{.guihint} verwendet:
:::

:::: imageblock
::: content
![Die Standardvorlage in der
Berichtsliste.](../images/reporting_list_selection2.png)
:::
::::

::: paragraph
Um eine eigene Berichtsvorlage zu erstellen, kopieren Sie die
Standardvorlage mit [![Symbol zum
Kopieren](../images/icons/icon_clone.png)]{.image-inline}. Ändern Sie
als erstes [Unique ID]{.guihint} und [Title.]{.guihint}
:::

::: paragraph
Um diese Berichtsvorlage als solche zu markieren, aktivieren Sie im
Kasten [Report Properties]{.guihint} die Option [This is a front matter
Template]{.guihint}:
:::

:::: imageblock
::: content
![Festlegung als
Berichtsvorlage.](../images/reporting_report_properties4.png)
:::
::::

::: paragraph
Ab dem ersten Speichern finden Sie diese Vorlage dann bei den eigenen
Berichtsvorlagen:
:::

:::: imageblock
::: content
![Liste der Berichtsvorlagen.](../images/reporting_customized3.png)
:::
::::

::: paragraph
Nun können Sie diese Vorlage entsprechend der obigen Beschreibungen
genau wie jeden anderen Bericht an Ihre Bedürfnisse anpassen. Verändern
Sie die Seiteneinteilung, die Schrift, die Linienfarben etc. Legen Sie
auch gleich die Inhaltselemente fest. Exklusiv für Berichtsvorlagen gibt
es zudem das Berichtselement [Table of Contents:]{.guihint}
:::

:::: imageblock
::: content
![Auswahl des
Inhaltsverzeichnisses.](../images/reporting_step1_content.png)
:::
::::

::: paragraph
Um einen Ihrer Berichte nun mit der neuen Vorlage zu erstellen, ändern
Sie noch die Einstellungen in den [Report Properties]{.guihint} des
Berichts. Stellen Sie die Option [Use settings and page layout
from]{.guihint} auf den Namen Ihrer neuen Vorlage um:
:::

:::: imageblock
::: content
![Wechsel der
Berichtsvorlage.](../images/reporting_report_properties3.png)
:::
::::

::: paragraph
Ihr Bericht wird ab dem Speichern künftig immer mit dieser Vorlage
erstellt werden.
:::
:::::::::::::::::::::
::::::::::::::::::::::

::::::::: sect1
## []{#_ergänzende_informationen .hidden-anchor .sr-only}9. Ergänzende Informationen {#heading__ergänzende_informationen}

:::::::: sectionbody
:::: sect2
### []{#content_elements .hidden-anchor .sr-only}9.1. Inhaltselemente {#heading_content_elements}

::: paragraph
Inhaltselemente werden aufgelistet, wenn Sie bei der Bearbeitung eines
Berichts [Reports \> Add content]{.guihint} auswählen.
:::

+-----------------+-----------------+-----------------------------------+
| Element         | Funktion        | Möglichkeiten                     |
+=================+=================+===================================+
| `A              | Komplexe        | Mehrschichtige Auswahl            |
| Multisite view` | Ansicht zu      |                                   |
|                 | definierbarem   |                                   |
|                 | Thema           |                                   |
+-----------------+-----------------+-----------------------------------+
| `Avai           | Liste der       | Auswahl der Datenquelle und       |
| lability table` | Verfügb         | weitere Einschränkungen der Daten |
|                 | arkeitszustände | möglich                           |
+-----------------+-----------------+-----------------------------------+
| `               | Graphen auf     | Verwendung einer Vorlage, Auswahl |
| Combined graph` | Basis mehrerer  | der Datenquelle und diverse       |
|                 | Datenreihen     | Layout-Einstellungen möglich      |
+-----------------+-----------------+-----------------------------------+
| `Custom Graph`  | Individuell     | Standard-Layout-Optionen          |
|                 | erstellte       |                                   |
|                 | Graphen         |                                   |
+-----------------+-----------------+-----------------------------------+
| `               | Statisches Bild | Größe kann festgelegt werden.     |
| Embedded image` |                 | *Die Position dieses Bildes ist   |
|                 |                 | dynamisch, relativ zu den         |
|                 |                 | umgebenden Inhaltselementen.*     |
+-----------------+-----------------+-----------------------------------+
| `               | Prognoseansicht | Vorgabe der zu berücksichtigenden |
| Forecast Graph` |                 | Hosts, Services und Zeiträume     |
+-----------------+-----------------+-----------------------------------+
| `Gr             | Alle Graphen    | Standard-Layout-Optionen          |
| aph collection` | einer Sammlung  |                                   |
+-----------------+-----------------+-----------------------------------+
| `Heading`       | Überschrift     | Abstufung in Überschriften        |
|                 |                 | verschiedener Hierarchien möglich |
+-----------------+-----------------+-----------------------------------+
| `H              | Statusberichte  | Definition der einzubindenden     |
| ost report for  | für             | Sub-Berichte inklusive            |
| multiple hosts` | verschiedene    | Strukturierung                    |
|                 | Hosts           |                                   |
+-----------------+-----------------+-----------------------------------+
| `Metr           | Metriken eines  | Standard-Layout-Optionen          |
| ics graph of a  | einzelnen       |                                   |
| single service` | Services als    |                                   |
|                 | Graph           |                                   |
+-----------------+-----------------+-----------------------------------+
| `M              | Sammlung        | Auswahl der Datenquelle,          |
| ultiple graphs` | mehrerer        | verschiedene Gestaltungsmerkmale  |
|                 | Grafiken zu     | der Grafiken                      |
|                 | einem Thema     |                                   |
+-----------------+-----------------+-----------------------------------+
| `Page break`    | Seitenumbruch   |                                   |
+-----------------+-----------------+-----------------------------------+
| `Par            | Statischer Text | *Die Position dieses Textes ist   |
| agraph of text` |                 | dynamisch, relativ zu den         |
|                 |                 | umgebenden Inhaltselementen.*     |
+-----------------+-----------------+-----------------------------------+
| `Service        | Serviceb        | Vorgabe der einzubindenden        |
|  report for mul | erichtssammlung | Sub-Berichte, verschiedene        |
| tiple services` | für mehrere     | Gestaltungsmerkmale der           |
|                 | Services        | Einzelberichte                    |
+-----------------+-----------------+-----------------------------------+
| `T              | Übersicht aller | Name und aktuelle Ausgabe des     |
| able of availab | verfügbaren     | [Makros](#macros) werden          |
| le text macros` | Makros          | angezeigt                         |
+-----------------+-----------------+-----------------------------------+
| `Table of Con   | Inh             | Nur in Berichtsvorlagen           |
| tents (only act | altsverzeichnis | einsetzbar                        |
| ive in frontmat |                 |                                   |
| ter templates)` |                 |                                   |
+-----------------+-----------------+-----------------------------------+
| `               | Freifläche      | Höhe sowie Verhalten an einem     |
| Vertical space` |                 | Seitenanfang können definiert     |
|                 |                 | werden                            |
+-----------------+-----------------+-----------------------------------+
::::

:::: sect2
### []{#page_elements .hidden-anchor .sr-only}9.2. Seitenelemente {#heading_page_elements}

::: paragraph
Seitenelemente werden aufgelistet, wenn Sie bei der Bearbeitung eines
Berichts [Reports \> Add page element]{.guihint} auswählen.
:::

+-----------------+-----------------+-----------------------------------+
| Element         | Funktion        | Möglichkeiten                     |
+=================+=================+===================================+
| `A frame a      | Rahmen um die   | Wahlweise um alle oder um         |
| round the page` | gesamte Seite   | spezifische Seiten                |
+-----------------+-----------------+-----------------------------------+
| `               | Statisches Bild | Wahlweise auf einer oder auf      |
| Embedded image` |                 | spezifischen Seiten. Position und |
|                 |                 | Größe können festgelegt werden.   |
|                 |                 | *Dieses Bild bewegt sich nicht    |
|                 |                 | mit den Berichtsinhalten mit.*    |
+-----------------+-----------------+-----------------------------------+
| `H              | Waagrechte      | Wahlweise auf allen oder auf      |
| orizontal rule` | Linie           | spezifischen Seiten. Position,    |
|                 |                 | Farbe und Dicke können festgelegt |
|                 |                 | werden.                           |
+-----------------+-----------------+-----------------------------------+
| `On             | Statische       | Wahlweise auf allen oder auf      |
| e line of text` | Textzeile       | spezifischen Seiten. Position und |
|                 |                 | Schrifteigenschaften können       |
|                 |                 | festgelegt werden.                |
+-----------------+-----------------+-----------------------------------+
::::

::: sect2
### []{#macros .hidden-anchor .sr-only}9.3. Verfügbare Makros {#heading_macros}

+-----------------+-----------------------------------------------------+
| Name            | Inhalt                                              |
+=================+=====================================================+
| `$FROM_TIME$`   | Startzeit des Berichts                              |
+-----------------+-----------------------------------------------------+
| `$NOW_TIME$`    | Aktuelle Zeit                                       |
+-----------------+-----------------------------------------------------+
| `$UNTIL_TIME$`  | Endzeit des Berichts                                |
+-----------------+-----------------------------------------------------+
| `$FROM_EPOCH$`  | Startzeit des Berichts in Unix-Zeit                 |
+-----------------+-----------------------------------------------------+
| `$NOW_EPOCH$`   | Aktuelle Zeit in Unix-Zeit                          |
+-----------------+-----------------------------------------------------+
| `$UNTIL_EPOCH$` | Endzeit des Berichts in Unix-Zeit                   |
+-----------------+-----------------------------------------------------+
| `$CHE           | Aktuelle Checkmk-Version                            |
| CK_MK_VERSION$` |                                                     |
+-----------------+-----------------------------------------------------+
| `$NOW_DATE$`    | Aktuelles Datum                                     |
+-----------------+-----------------------------------------------------+
| `$FROM_DATE$`   | Startdatum des Berichts                             |
+-----------------+-----------------------------------------------------+
| `$UNTIL_DATE$`  | Enddatum des Berichts                               |
+-----------------+-----------------------------------------------------+
| `$FROM$`        | Startdatum und -zeit des Berichts                   |
+-----------------+-----------------------------------------------------+
| `$NOW$`         | Aktuelles Datum und Uhrzeit                         |
+-----------------+-----------------------------------------------------+
| `$UNTIL$`       | Enddatum und -zeit des Berichts                     |
+-----------------+-----------------------------------------------------+
| `$PAGE$`        | Seitenzahl                                          |
+-----------------+-----------------------------------------------------+
| `               | Titel des Berichts                                  |
| $REPORT_TITLE$` |                                                     |
+-----------------+-----------------------------------------------------+
| `$RANGE_TITLE$` | Zeitraum für den Bericht                            |
+-----------------+-----------------------------------------------------+
| `$USER_ALIAS$`  | Benutzerkennung                                     |
+-----------------+-----------------------------------------------------+
| `$USER_ID$`     | Benutzer-ID                                         |
+-----------------+-----------------------------------------------------+
| `$OMD_SITE$`    | Name der Instanz                                    |
+-----------------+-----------------------------------------------------+
| `$REPORT_NAME$` | Name des Berichts                                   |
+-----------------+-----------------------------------------------------+
:::
::::::::
:::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}10. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~/var/check_mk/web/[o    | In diesen Dateien werden die angepassten |
| wner_id]/user_reports.mk` | und neu erstellten Berichte der          |
|                           | jeweiligen Eigentümer                    |
|                           | ([Owner]{.guihint}) der Berichte         |
|                           | gespeichert.                             |
+---------------------------+------------------------------------------+
| `~/local/share/ch         | Verzeichnis zur Ablage                   |
| eck_mk/reporting/images/` | benutzerdefinierter Bilder, die in       |
|                           | Berichten verwendet werden sollen.       |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
