:::: {#header}
# Ansichten von Hosts und Services (Views)

::: details
[Last modified on 14-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/views.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Benutzeroberfläche](user_interface.html)
[Dashboards](dashboards.html) [Messwerte und Graphing](graphing.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die wichtigste Aufgabe der [Benutzeroberfläche](user_interface.html) von
Checkmk ist das Anzeigen des aktuellen Zustands von Hosts und Services.
Dies geschieht größtenteils in tabellarischen *Ansichten,* welche in der
englischen Oberfläche mit *Views* bezeichnet werden. Damit das tägliche
Arbeiten mit Checkmk so effizient wie möglich abläuft, bieten diese
Tabellenansichten zahlreiche nützliche Funktionen und Sie können sie an
Ihre Anforderungen anpassen.
:::

::: paragraph
Wir unterscheiden zwischen **globalen** Tabellenansichten und solchen,
die einen **Kontext** benötigen. Globale Tabellenansichten können immer
direkt aufgerufen werden. Ein Beispiel ist die Liste aller aktuellen
Service-Probleme. Einen Kontext benötigt z.B. die Tabellenansicht
[Status of Host ...​]{.guihint} --- nämlich die Angabe desjenigen Hosts,
dessen Zustand angezeigt werden soll. Solche Tabellenansichten können
nur in Situationen aufgerufen werden, in denen es um einen bestimmten
Host geht.
:::

::::::::::::::::: sect2
### []{#_globale_tabellenansichten .hidden-anchor .sr-only}1.1. Globale Tabellenansichten {#heading__globale_tabellenansichten}

::: paragraph
Die globalen Tabellenansichten erreichen Sie am einfachsten über das
[Monitor]{.guihint}-Menü.
:::

::::: imageblock
::: content
![Monitor-Menü von Checkmk Raw im
Show-less-Modus.](../images/monitor_menu_less.png)
:::

::: title
Das [Monitor]{.guihint}-Menü von Checkmk Raw im Show-less-Modus
:::
:::::

::: paragraph
Alternativ können Sie auch die [Snapins](glossar.html#snapin)
[Overview]{.guihint} und [Views]{.guihint} nutzen. Im
[Overview]{.guihint} ist jede der Zahlen anklickbar und bringt Sie zu
einer globalen Tabellenansicht, die die jeweils gezählten Hosts oder
Services einzeln auflistet.
:::

:::: imageblock
::: content
![Das Snapin \'Overview\' der
Seitenleiste.](../images/views_snapin_overview.png){width="50%"}
:::
::::

::: paragraph
Im Snapin [Views]{.guihint} sind alle globalen Tabellenansichten
erreichbar --- gruppiert nach Thema (*topic*). Zudem finden Sie einige
Einträge, die eigentlich keine [Views]{.guihint} sind --- wie z.B. die
[Dashboards](glossar.html#dashboard#), welche unter dem Thema
[Overview]{.guihint} einsortiert sind. Dashboards können aber Views
*enthalten.*
:::

:::: imageblock
::: content
![Das Snapin \'Views\' der
Seitenleiste.](../images/views_snapin_views.png){width="50%"}
:::
::::

::: paragraph
Von einer globalen Tabellenansicht aus gelangen Sie zu den Einzelheiten
eines bestimmten Hosts oder Services in einem weiteren Schritt. Die
Namen von Hosts und Services und auch andere Spalten in den einzelnen
Zellen sind anklickbar ... :
:::

:::: imageblock
::: content
![Die Ansicht \'All hosts\'.](../images/views_all_hosts.png)
:::
::::

::: paragraph
... und bringen Sie zu (kontext-abhängigen) Detailansichten.
:::
:::::::::::::::::

::::::::::::::: sect2
### []{#_kontext_abhängige_tabellenansichten .hidden-anchor .sr-only}1.2. Kontext-abhängige Tabellenansichten {#heading__kontext_abhängige_tabellenansichten}

::: paragraph
In Tabellenansichten, die *einen bestimmten* Host oder Service
betreffen, finden Sie in den Menüs [Host]{.guihint} beziehungsweise
[Service]{.guihint} wiederum allerlei Einträge, die Sie dann zu weiteren
Tabellenansichten mit demselben Kontext bringen --- also von demselben
Host oder Service.
:::

:::: imageblock
::: content
![Ansicht mit geöffnetem Menü
\'Service\'.](../images/views_context_buttons.png)
:::
::::

::: paragraph
Sie können Host- und Service-spezifische Tabellenansichten auch über die
[Suche im Monitor-Menü](intro_gui.html#search_monitor) erreichen:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Die Suche im
Monitor-Menü.](../images/views_monitor_search.png){width="60%"}
:::
::::

::: paragraph
Ein weiterer Weg zu Detailansichten ist die Schnellsuche mit dem Snapin
[Quicksearch]{.guihint} in der Seitenleiste:
:::

:::: imageblock
::: content
![Das Snapin \'Quicksearch\' der
Seitenleiste.](../images/views_snapin_quicksearch.png){width="50%"}
:::
::::

::: paragraph
Zu welcher Tabellenansicht Sie jeweils gelangen, hängt vom Ergebnis der
Suche ab. Wenn die Suche einen Host eindeutig ermittelt, dann gelangen
Sie direkt zur Seite [Services of Host ...​]{.guihint} dieses Hosts. Dort
finden Sie dann wieder die Menüeinträge zu den anderen Tabellenansichten
des gleichen Hosts. Ein Klick auf den Namen des Hosts bringt Sie
beispielsweise zur Ansicht [Status of Host.]{.guihint}
:::

:::: imageblock
::: content
![Die Ansicht der Services eines
Hosts.](../images/views_services_of_host.png)
:::
::::
:::::::::::::::

::::::::::::: sect2
### []{#_auswirkung_in_der_menüleiste .hidden-anchor .sr-only}1.3. Auswirkung in der Menüleiste {#heading__auswirkung_in_der_menüleiste}

::: {#menucontext .paragraph}
Die Unterscheidung zwischen globalen, Host- und Service-spezifischen
Tabellenansichten macht sich auch in der Menüleiste bemerkbar. Immer
vorhanden sind die Menüs [Commands, Export, Display]{.guihint} und
[Help.]{.guihint}
:::

::: paragraph
In globalen Host-Ansichten gibt es zudem das Menü [Hosts]{.guihint}
sowie in globalen Service-Ansichten [Services]{.guihint} --- beachten
Sie hier den Plural! Darüber können Sie zum Beispiel die
[Verfügbarkeit](availability.html) aller Hosts oder Services der
aktuellen Ansicht aufrufen.
:::

:::: imageblock
::: content
![Menüleiste der Ansicht \'All
hosts\'.](../images/views_menu_global.png)
:::
::::

::: paragraph
Tabellenansichten eines einzelnen Hosts hingegen, haben die Menüs
[Host]{.guihint} und [Services]{.guihint} mit allen Aktionen für den
aktuellen Host beziehungsweise für all die Services der aktuellen
Ansicht.
:::

:::: imageblock
::: content
![Menüleiste der Ansicht \'Services of
Host\'.](../images/views_menu_context_host.png)
:::
::::

::: paragraph
Tabellenansichten eines einzelnen Services wiederum haben ebenfalls das
Menü [Host]{.guihint}, dazu aber nun im Singular [Service]{.guihint},
mit Aktionen für diesen einen Service.
:::

:::: imageblock
::: content
![Menüleiste der Ansicht eines
Services.](../images/views_menu_context_service.png)
:::
::::
:::::::::::::
::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::: sect1
## []{#using_views .hidden-anchor .sr-only}2. Tabellenansichten verwenden {#heading_using_views}

:::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#_optionen_filter_und_kommandos .hidden-anchor .sr-only}2.1. Optionen, Filter und Kommandos {#heading__optionen_filter_und_kommandos}

::: paragraph
Jede Tabellenansicht bietet diverse Optionen, über die Sie diese
beeinflussen und Aktionen auslösen können.
:::

+--------------------+-------------------------------------------------+
| Menü               | Funktion                                        |
+====================+=================================================+
| [C                 | Hier können Sie Kommandos auf den gezeigten     |
| ommands]{.guihint} | Objekten ausführen (z.B. Eintragen von          |
|                    | Wartungszeiten). Die Kommandos sind detailliert |
|                    | in einem [eigenen Artikel](commands.html)       |
|                    | beschrieben.                                    |
+--------------------+-------------------------------------------------+
| [Display \>        | Öffnet die Filterleiste am rechten Rand der     |
| Filter]{.guihint}  | Hauptseite. Damit können Sie die gezeigten      |
|                    | Daten weiter einschränken. Sobald Sie einen     |
|                    | Filter gesetzt haben, ändert sich das Symbol    |
|                    | auf [![button filters set                       |
|                    | lo](../images/ic                                |
|                    | ons/button_filters_set_lo.png)]{.image-inline}, |
|                    | damit klar ist, dass unter Umständen nicht alle |
|                    | Daten angezeigt werden. Umgekehrt haben manche  |
|                    | Tabellenansichten schon Filter vorbelegt (z.B.  |
|                    | die Liste aller Probleme). Hier können Sie      |
|                    | durch Entfernen der Filter wiederum mehr Daten  |
|                    | anzeigen lassen. Änderungen der Filter werden   |
|                    | nicht gespeichert, sondern wieder               |
|                    | zurückgesetzt, sobald Sie die Ansicht           |
|                    | verlassen.                                      |
+--------------------+-------------------------------------------------+
| [Display \> Show   | Damit schalten Sie Checkboxen ein oder aus. Mit |
| che                | den Checkboxen können Sie die Kommandos auf     |
| ckboxes]{.guihint} | ausgewählte Datensätze einschränken.            |
+--------------------+-------------------------------------------------+
| [Display \> Modify | Legt die Anzahl der Spalten für die Ansicht     |
| display options \> | fest. Mehrspaltige Tabellenansichten helfen,    |
| Entries per        | auf breiten Monitoren den verfügbaren Platz     |
| row]{.guihint}     | auszunutzen. Bei Tabellenansichten, die nur     |
|                    | einen Datensatz anzeigen, ist diese Einstellung |
|                    | wirkungslos.                                    |
+--------------------+-------------------------------------------------+
| [Display \> Modify | Legt fest, in welchem Intervall die Ansicht neu |
| display options \> | geladen wird. Sie können damit das automatische |
| Refresh            | Neuladen auch ganz abschalten. Beachten Sie,    |
| i                  | dass es in diesem Fall sein kann, dass Sie über |
| nterval]{.guihint} | ein inzwischen aufgetretenes Problem nicht      |
|                    | informiert werden!                              |
+--------------------+-------------------------------------------------+
| [Display \> Modify | Änderung des Formats für die Datumsanzeige.     |
| display options \> |                                                 |
| Date               |                                                 |
| format]{.guihint}  |                                                 |
+--------------------+-------------------------------------------------+
| [Display \> Modify | Zeitstempel können absolut, relativ, gemixt,    |
| display options \> | gemeinsam oder als „Unix Timestamp" angezeigt   |
| Time stamp         | werden.                                         |
| format]{.guihint}  |                                                 |
+--------------------+-------------------------------------------------+
::::

:::::: sect2
### []{#_zeit_und_datumsangaben .hidden-anchor .sr-only}2.2. Zeit- und Datumsangaben {#heading__zeit_und_datumsangaben}

::: paragraph
Checkmk zeigt in seinen Ansichten alle Zeitangaben, die weniger als 24
Stunden in der Vergangenheit oder Zukunft liegen, als relative
Angaben --- also z.B. [16 hours.]{.guihint} Sie können das im Menü über
[Display \> Modify display options]{.guihint} umschalten und wahlweise
nur absolute, nur relative oder beide Werte anzeigen lassen, oder auch
den „Unix Timestamp". Auch das Datumsformat können Sie in diesem Dialog
festlegen.
:::

:::: imageblock
::: content
![Änderung der Darstellungsoptionen.](../images/views_time_date.png)
:::
::::
::::::

::::::::: sect2
### []{#_sortierung .hidden-anchor .sr-only}2.3. Sortierung {#heading__sortierung}

::: paragraph
Die Tabellenansichten können Sie durch ein Klicken auf die
Spaltenüberschriften sortieren. Dabei gibt es drei Zustände einer
Spalte, die durch mehrfaches Klicken im Kreis herum der Reihe nach
ausgewählt werden:
:::

::: ulist
- Aufsteigend sortieren

- Absteigend sortieren

- Nicht mehr nach dieser Spalte sortieren
:::

::: paragraph
Zunächst wird eine Tabellenansicht immer auf eine „natürliche" Art
sortiert, die in der Tabellenansicht selbst festgelegt ist. Bei den
Service-Ansichten ist die Sortierung immer alphabetisch nach dem Namen
des Services --- mit der Ausnahme, dass die
[Check_MK]{.guihint}-Services immer oben stehen. Neben dem Service
[Check_MK]{.guihint}, der für die Abfrage des Monitoring-Agenten
zuständig ist, sind das noch [Check_MK Discovery]{.guihint}, [Check_MK
HW/SW Inventory]{.guihint} und gegebenenfalls [Check_MK
Agent]{.guihint}. Um eine solche Liste nach dem aktuellen Zustand der
Services zu sortieren genügt ein Klick auf [State.]{.guihint}
:::

:::: imageblock
::: content
![Sortierung einer Liste nach
Spaltenüberschriften.](../images/views_sort_by_state.png)
:::
::::

::: paragraph
Die Sortierung nach der Spalte [Perf-O-Meter]{.guihint} führt manchmal
zu überraschenden Ergebnissen. Das liegt daran, dass die grafische
Darstellung der [Messwerte](graphing.html) teilweise eine prozentuale
Zusammenfassung der eigentlichen Werte zeigt. Die Sortierung geschieht
aber nach den absoluten Werten --- und zwar immer nach der *ersten
Metrik*, die ein Service ausgibt.
:::
:::::::::

:::: sect2
### []{#export .hidden-anchor .sr-only}2.4. Export {#heading_export}

::: paragraph
Sie können die in einer Tabellenansicht gezeigten Daten in verschiedenen
Formaten über das Menü [Export]{.guihint} exportieren:
:::

+--------------------+-------------------------------------------------+
| Menüeintrag        | Funktion                                        |
+====================+=================================================+
| [Data \> Export    | Als Trennzeichen wird ein Semikolon verwendet.  |
| CSV]{.guihint}     | Die einzelnen Zellen sind in Anführungszeichen  |
|                    | eingeschlossen. In der ersten Zeile sind die    |
|                    | internen Kürzel für die einzelnen Spalten       |
|                    | eingetragen.                                    |
+--------------------+-------------------------------------------------+
| [Data \> Export    | Beim JSON-Export landen die Zellen ebenfalls in |
| JSON]{.guihint}    | Anführungszeichen, getrennt durch Umbrüche und  |
|                    | Kommata, umschlossen von eckigen Klammern.      |
+--------------------+-------------------------------------------------+
| [Reports \> This   | Nur in den kommerziellen Editionen: Hierbei     |
| view as            | wird ein sogenannter Sofortbericht (*instant    |
| PDF]{.guihint}     | report*) erzeugt, der die aktuelle              |
|                    | Tabellenansicht in ein PDF-Dokument überführt,  |
|                    | abzüglich Icons, Navigation und so weiter. Das  |
|                    | Aussehen können Sie über spezielle              |
|                    | Berichtsvorlagen im [Reporting](reporting.html) |
|                    | anpassen.                                       |
+--------------------+-------------------------------------------------+
| [                  | Je nach aktueller Tabellenansicht werden hier   |
| Reports]{.guihint} | weitere PDF-Exporte angeboten, etwa zur         |
|                    | Verfügbarkeit, sowie gegebenenfalls individuell |
|                    | erstellte Vorlagen.                             |
+--------------------+-------------------------------------------------+
| [REST API \> Query | Ausgabe der [REST-API](rest_api.html) zur       |
| hosts/services     | Host-/Service-Auswahl der aktuellen             |
| r                  | (gefilterten) Tabellenansicht.                  |
| esource]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
::::

:::::::::::::: sect2
### []{#limit .hidden-anchor .sr-only}2.5. Das Anzeigelimit {#heading_limit}

::: paragraph
Bei einer größeren Monitoring-Umgebung sind nicht mehr alle
Tabellenansichten sinnvoll. Wenn Sie 50.000 Services überwachen und die
Ansicht [All Services]{.guihint} anwählen, würde die Darstellung nicht
nur sehr lange brauchen --- sie wäre auch wenig nützlich.
:::

::: paragraph
Um den Benutzer in solchen Situationen vor langen Wartezeiten zu
schützen und das System nicht durch absurde Datenmengen in die Knie zu
zwingen, sind Tabellenansichten auf die Anzeige von 1000 Einträgen
begrenzt. Bei einer Überschreitung erhalten Sie folgenden Hinweis:
:::

:::: imageblock
::: content
![Hinweis vor der Anzeige einer Ansicht mit mehr als 1000
Einträgen.](../images/views_limit1.png){width="80%"}
:::
::::

::: paragraph
Wie Sie sehen, werden Sie darauf hingewiesen, dass die gezeigten
Datensätze nicht unbedingt die ersten 1000 gemäß der gewählten
Sortierung sind! Das hat einen technischen Hintergrund: Die Limitierung
wird nämlich bereits an der Quelle der Daten durchgesetzt: in den
Monitoring-Kernen der angebundenen Instanzen. Das ist sehr wichtig: Denn
wenn wir erst eine Million Datensätze aus Ihrer weltweit verteilten
Umgebung zusammensammeln würden, um gleich danach 99,9 % der Daten
wieder wegzuwerfen, dann wäre das Kind ja schon in den Brunnen gefallen.
Die Sortierung übernimmt erst am Ende die Oberfläche --- es geschieht
also *nach* der Limitierung. Denn die Daten von allen Instanzen müssen
ja gemeinsam sortiert werden.
:::

::: paragraph
Sofern Sie wirklich der Meinung sind, mehr als 1000 Datensätze sehen zu
wollen, können Sie durch einen Klick auf [Repeat query and allow more
results]{.guihint} ins nächste Level kommen. Hier greift eine Begrenzung
auf 5000 Datensätze. Ist diese wieder überschritten, so können Sie *ganz
ohne Limit* fortfahren. Da dies eine gefährliche Operation sein kann,
benötigt sie Administratorrechte. Sie wurden gewarnt!
:::

:::: imageblock
::: content
![Hinweis vor der Anzeige einer Ansicht mit mehr als 5000
Einträgen.](../images/views_limit2.png){width="80%"}
:::
::::

::: paragraph
Sie können die beiden Stufen unter [Global settings \> User
interface]{.guihint} anpassen:
:::

:::: imageblock
::: content
![Globale Einstellung zur Änderung der beiden
Limits.](../images/views_limit3.png)
:::
::::
::::::::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#edit .hidden-anchor .sr-only}3. Ansichten anpassen {#heading_edit}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_grundsätzliches .hidden-anchor .sr-only}3.1. Grundsätzliches {#heading__grundsätzliches}

::: paragraph
Checkmk erlaubt Ihnen, die mitgelieferten Tabellenansichten anzupassen
und sogar ganz Neue zu erzeugen, welche Sie dann auch in
[Berichte](reporting.html) und [Dashboards](glossar.html#dashboard)
einbauen können. Dabei können Sie bei jeder Tabellenansicht eine Menge
verschiedener Aspekte bestimmen:
:::

::: ulist
- **Allgemeine Dinge** wie Titel, Thema, usw.

- Welche **Datenquelle** wird dargestellt (z.B., Hosts, Services, Events
  der Event Console etc.)?

- Welche Auswahl an Datensätzen wird dargestellt (**Filterung**)?

- Welche **Spalten** werden dargestellt?

- Zu welchen anderen Tabellenansichten **verlinken** die Texte in den
  Spalten?

- Wie wird standardmäßig **sortiert**?

- Gibt es eine **Gruppierung,** und falls ja, wie sieht diese aus?

- Wo und für welche Benutzer soll die Tabellenansicht **sichtbar** sein?

- Welche Art von **Tabellenlayout** soll verwendet werden?
:::

::: paragraph
Den Editiermodus für Tabellenansichten erreichen Sie auf zwei Arten:
:::

::: {.olist .arabic}
1.  Bei einer bestehenden Tabellenansicht über einen Menüeintrag. Hier
    gibt es vier Varianten, abhängig vom Ursprung der jeweiligen
    Tabellenansicht:

    ::: ulist
    - [Display \> Clone builtin view]{.guihint} --- erstellt einen Klon
      der mitgelieferten Tabellenansicht.

    - [Display \> Edit my view]{.guihint} --- öffnet den
      Bearbeitungsmodus für Ihre selbst erstellte Tabellenansicht.

    - [Display \> Clone view]{.guihint} --- legt einen Klon der
      Tabellenansicht eines anderen Benutzers an --- wenn Sie keine
      Berechtigung zur Bearbeitung fremder Tabellenansichten haben.

    - [Display \> Edit view of user X]{.guihint} und [Display \> Clone
      view]{.guihint} --- womit Sie wählen können, ob Sie die
      Tabellenansicht des anderen Benutzers bearbeiten oder stattdessen
      einen Klon seiner Tabellenansicht erstellen wollen --- wenn Sie
      die Berechtigung zur Bearbeitung fremder Tabellenansichten haben.
    :::

2.  Im Menü [Customize \> Visualization \> Views]{.guihint}. Dort können
    Sie mit [![button add
    view](../images/icons/button_add_view.png)]{.image-inline} ganz neue
    Tabellenansichten erzeugen oder wiederum mit [![icon
    clone](../images/icons/icon_clone.png)]{.image-inline} bestehende
    klonen und anpassen:
:::

:::: imageblock
::: content
![Ansicht zur Erstellung einer neuen
Ansicht.](../images/views_edit_views.png)
:::
::::
:::::::::

::::::::::::: sect2
### []{#_erst_klonen_dann_verändern .hidden-anchor .sr-only}3.2. Erst klonen, dann verändern {#heading__erst_klonen_dann_verändern}

::: paragraph
Da die mitgelieferten Tabellenansichten Teil der Software sind und somit
nicht verändert werden können, kennt Checkmk das Konzept des *Klonens*.
Beim ersten Anpassen einer Tabellenansicht wird automatisch eine Kopie
der Tabellenansicht für Sie erzeugt. Diese Kopie ist dabei Ihrem
Benutzerprofil zugeordnet.
:::

::: paragraph
Die Kopie können Sie dann so anpassen, wie Sie es möchten. Die
ursprüngliche Tabellenansicht bleibt erhalten, wird aber
*verschattet* --- also durch Ihre Kopie verdeckt. Sie können später
einfach zur Standardansicht zurückkehren, indem Sie Ihren Klon löschen
(das geht dann in der Tabelle der Ansichten wie erwartet mit [![icon
delete](../images/icons/icon_delete.png)]{.image-inline}).
:::

::: paragraph
Dieses Konzept hat noch einen weiteren Vorteil: Sie können nämlich
bestimmen, ob die Tabellenansicht *für alle Benutzer* geändert sein
soll, oder nur für Sie selbst. Dies legen Sie in den [General
Properties]{.guihint} der Tabellenansicht unter [Visibility]{.guihint}
mit der Checkbox [Make this view available for other users]{.guihint}
fest. Es überrascht wohl nicht, dass Sie diese Checkbox nur dann setzen
können, wenn Sie [Administratorrechte](wato_user.html#roles) haben
(genau genommen gibt es dafür eine eigene Berechtigung mit dem Namen
[Publish views]{.guihint}). Zusätzlich können einzelne Tabellenansichten
in den [Rollendefinitionen](wato_user.html#roles) gesperrt werden.
:::

::: paragraph
Was ist nun, wenn eine Tabellenansicht von mehreren Benutzern angepasst
und freigegeben wurde? Jeder der Benutzer hat dann nämlich eine eigene
Variante der Tabellenansicht. Welche davon wird für wen sichtbar? Dies
wird durch folgende Regeln bestimmt:
:::

::: {.olist .arabic}
1.  Wenn ein Benutzer für sich selbst eine Tabellenansicht erzeugt hat,
    hat diese für ihn immer Vorrang.

2.  Danach gelten Tabellenansichten, die ein Administrator angepasst und
    freigegeben hat (genau gesagt jemand mit dem Recht [Modify builtin
    views]{.guihint}).

3.  Gibt es hier keine, so gelten Tabellenansichten, die ein anderer
    normaler Benutzer mit dem Recht [Publish views]{.guihint}
    freigegeben hat.

4.  Und wenn es hier auch keine gibt, dann wird die ausgelieferte
    Variante sichtbar.
:::

::: paragraph
Wie können Sie nun aber eine *echte Kopie* einer Tabellenansicht
erstellen, also am Ende beide Tabellenansichten sehen --- die
mitgelieferte und Ihre Version? Dies wird über die [Unique ID]{.guihint}
in den [General Properties]{.guihint} gesteuert. Ändern Sie einfach die
ID Ihrer Tabellenansicht auf einen anderen Wert. Damit gilt diese nicht
mehr als Klon der mitgelieferten Tabellenansicht sondern beginnt ein
eigenes Leben.
:::

::: paragraph
Die ID ist übrigens auch die entscheidende Angabe in der URL, über die
Tabellenansichten aufgerufen werden. Das Schema ist ganz einfach. So
wird z.B. die globale Tabellenansicht mit der ID `allhosts` wie folgt
aufgerufen:
:::

::: paragraph
`/mysite/check_mk/view.py?view_name=allhosts`
:::

::: paragraph
Das Konzept mit dem Klonen und Anpassen und der Sichtbarkeit finden Sie
übrigens auch an vielen anderen Stellen von Checkmk, nämlich bei:
:::

::: ulist
- [Dashboards](dashboards.html)

- [Berichten](reporting.html)

- [Graphensammlungen](graphing.html#graph_collections)

- [benutzerdefinierten Graphen](graphing.html#custom_graphs)

- [Lesezeichenlisten](user_interface.html#bookmarks)
:::
:::::::::::::

::::::: sect2
### []{#_integration_einer_tabellenansicht_in_die_navigation .hidden-anchor .sr-only}3.3. Integration einer Tabellenansicht in die Navigation {#heading__integration_einer_tabellenansicht_in_die_navigation}

::: paragraph
Wie und ob eine Tabellenansicht im [Monitor]{.guihint}-Menü der
Navigationsleiste sowie dem Snapin [Views]{.guihint} angezeigt wird,
legen folgende Eigenschaften unter [General Properties]{.guihint} fest:
:::

:::: imageblock
::: content
![Allgemeine Eigenschaften der
Ansicht.](../images/views_edit_view_general_properties.png)
:::
::::

::: ulist
- [Title:]{.guihint} Dies wird der Name des Eintrags.

- [Topic in \'Monitor menu\':]{.guihint} Unter diesem Thema wird die
  Tabellenansicht einsortiert. Sie können auch eigene Themen definieren.

- [Sort index:]{.guihint} Entscheidet, wie weit oben die Tabellenansicht
  im Menü erscheint.

- [Visibility:]{.guihint} Damit können Sie den Eintrag unterdrücken
  und/oder für andere Benutzer freigeben.
:::
:::::::

:::::::::: sect2
### []{#_grundlegendes_layout .hidden-anchor .sr-only}3.4. Grundlegendes Layout {#heading__grundlegendes_layout}

::: paragraph
Der nächste Kasten [View Properties]{.guihint} bestimmt das generelle
Aussehen der Tabellenansicht:
:::

:::: imageblock
::: content
![Spezifische Eigenschaften der
Ansicht.](../images/views_edit_view_view_properties.png)
:::
::::

::: paragraph
Die Einstellung [Number of Columns]{.guihint} bestimmt die Anzahl der
Spalten, [Automatic page reload]{.guihint} das
Aktualisierungsintervall --- beide Werte können in der Tabellenansicht
selbst [Display \> Modify display options]{.guihint} noch verändert
werden.
:::

::: paragraph
Unter [Basic Layout]{.guihint} gibt es verschiedene Arten, wie die Daten
in Tabellen dargestellt werden. Die meisten Tabellenansichten verwenden
[Table]{.guihint} --- eine normale Tabelle, die nach Spalten sortierbar
ist --- oder [Single dataset]{.guihint} --- welches die Legende links
hat und meist für einzelne Datensätze verwendet wird. Sie können [Single
dataset]{.guihint} aber auch für Tabellenansichten mit mehr als einem
Objekt verwenden. Die Tabellenansicht [All hosts]{.guihint} sieht nach
einer Umstellung auf [Single dataset]{.guihint} etwa so aus:
:::

:::: imageblock
::: content
![Ergebnis der geänderten
Ansicht.](../images/views_layout_single_dataset.png)
:::
::::
::::::::::

::::::::::: sect2
### []{#columns .hidden-anchor .sr-only}3.5. Spalten {#heading_columns}

::: paragraph
Der Kasten [Columns]{.guihint} legt fest, welche Spalten Sie sehen. Die
mögliche Auswahl von Spalten hängt von der gewählten Datenquelle ab. Die
meisten Spalten finden Sie bei den Services, denn hier sind natürlich
auch alle Informationen über den jeweiligen Host verfügbar. Die Liste
kann schon recht lang werden und wenn Sie nicht sicher sind, welche
Spalte die richtige ist, hilft nur eines: Ausprobieren.
:::

:::: imageblock
::: content
![Eigenschaften für die Spalten der
Ansicht.](../images/views_edit_view_columns.png)
:::
::::

::: paragraph
Je nach gewählter Spalte kann es dafür spezifische Optionen geben. Mit
der Spalte [Hosts: Hostname]{.guihint} ist es zum Beispiel möglich, den
Host-Namen über die Option [Coloring]{.guihint} entsprechend seines
Zustands farblich zu hinterlegen.
:::

::: paragraph
Das Feld [Link]{.guihint} bietet eine Auswahl von allen
Tabellenansichten und Dashboards. Ist hier eine Tabellenansicht
ausgewählt, dann ist die jeweilige Zelle dieser Spalte *anklickbar* und
bringt den Benutzer zur gewählten Tabellenansicht. Wirklich sinnvoll ist
das natürlich nur, wenn die Zielansicht einen Kontext hat. Bestes
Beispiel ist die Tabellenansicht [All hosts]{.guihint}. Die Spalte
[Hostname]{.guihint} ist hier anklickbar und bringt den Benutzer dann zu
[Services of Host]{.guihint} --- von diesem Host. Alternativ können hier
auch Dashboards angegeben werden, die freilich keinen Kontext benötigen.
:::

::: paragraph
Unter [Tooltip]{.guihint} werden Sie wiederum die Liste aller Spalten
finden. So können Sie eine weitere Information zu dem Host oder Service
einblenden, sobald der Benutzer mit der Maus über die jeweilige Zelle
fährt (wie im folgenden Beispiel die IP-Adresse):
:::

:::: imageblock
::: content
![Ergebnis der geänderten Ansicht mit einem
Tooltipp.](../images/views_hover_address.png)
:::
::::
:::::::::::

:::::::::::::::: sect2
### []{#joined_columns .hidden-anchor .sr-only}3.6. Information über Services in einer Host-Ansicht {#heading_joined_columns}

::: paragraph
Stellen Sie sich vor, Sie möchten gerne Informationen zu bestimmten
Services in einer Tabelle von Hosts anzeigen. Das folgende ist ein sehr
schönes Beispiel für so etwas: Zu jedem Host werden die aktuelle Uptime,
die CPU-Last, die Speichernutzung und die Ausführungszeit des
Checkmk-Agenten ausgegeben:
:::

:::: imageblock
::: content
![Host-Ansicht mit Perf-O-Metern für die
Services.](../images/views_joined_columns_example.png)
:::
::::

::: paragraph
Hier wurde eine Tabelle von Hosts erstellt, in der für jeden Host die
**Service-Spalte** [Perf-O-Meter]{.guihint} von je vier verschiedenen
Services angezeigt wird. Man sieht auch, dass bei einem der drei Hosts
die Services [CPU, Memory]{.guihint} und [Uptime]{.guihint} nicht
existieren und die Spalten dort konsequenterweise leer sind.
:::

::: paragraph
Um eine Konfiguration zu dieser Tabellenansicht umzusetzen, fügen Sie in
der Ansicht Spalten vom Typ [Joined column]{.guihint} hinzu. Hier
erscheinen dann unter [Column]{.guihint} die Spalten für Services, von
denen Sie für das Beispiel [Perf-O-Meter]{.guihint} auswählen. Mit dem
Eintrag [Title]{.guihint} weiter unten bestimmen Sie dann bei Bedarf die
Überschrift der Spalte, wenn die automatische nicht passen sollte.
:::

::: paragraph
Unter [of Service]{.guihint} wählen Sie zunächst entweder [Explicit
match]{.guihint} oder [Regular expression match]{.guihint} aus. Bei
Ersterem tragen Sie anschließend den **exakten** Namen inklusive der
Groß- und Kleinschreibung ein. Dadurch wird der korrekte Service zu dem
Host bestimmt.
:::

:::: imageblock
::: content
![Eigenschaften einer \'Joined column\' mit expliziter Angabe des
Servicse.](../images/views_edit_view_columns_2.png)
:::
::::

::: paragraph
Wenn Sie nicht genau wissen, wie der Service heißt oder er auf jedem
Host ein wenig anders ist, geben Sie einen regulären Ausdruck an, der
pro Host auf exakt **einen** Service matcht. Das ist vor allem dann
nützlich, wenn Sie eine Gruppe von Hosts betrachten wollen, bei denen es
eine vergleichbare Gruppe an Services gibt, von denen jeweils immer nur
einer auf einem Host vorkommen kann. In dem nachfolgenden Beispiel ist
das die [CPU load]{.guihint} oder die [Processor queue,]{.guihint}
welche entweder nur auf Linux- oder Windows-Systemen vorkommen kann.
:::

:::: imageblock
::: content
![Eigenschaften einer \'Joined column\' mit regulärem Ausdruck für den
Service.](../images/views_edit_view_columns_3.png)
:::
::::

::: paragraph
Es gibt übrigens nichts zu befürchten, sollte ein regulärer Ausdruck
doch einmal auf mehrere Services zutreffen. In einem solchen Fall wird
immer der erste Treffer in der Spalte angezeigt.
:::

::: paragraph
In beiden Varianten ist so eine Darstellung natürlich nur dann nützlich,
wenn die Tabellenansicht eine Liste von ähnlichen Hosts anzeigt, welche
auch alle über die gewählten Services verfügen oder sich ähnelnde
Services haben. Das ist auch der Grund, warum Checkmk nur wenige solcher
Ansichten mit ausliefert: Welche Spalten hier sinnvoll sind, hängt
absolut von der Art der gewählten Hosts ab. Bei Linux-Servern
interessieren sicherlich völlig andere Informationen als z.B. bei USVs.
:::
::::::::::::::::

:::::: sect2
### []{#_sortierung_2 .hidden-anchor .sr-only}3.7. Sortierung {#heading__sortierung_2}

::: paragraph
Die Sortierung einer Tabellenansicht konfigurieren Sie im vierten
Kasten. Es handelt sich dabei nur um die voreingestellte Sortierung: Der
Benutzer kann, wie oben beschrieben, über einen Klick auf die
Spaltentitel die Sortierung für sich anpassen. In der Konfiguration der
Tabellenansicht haben Sie aber mehr Möglichkeiten: Sie können eine
*mehrstufige* Sortierung einstellen, z.B. zuerst nach dem
Service-Zustand, und bei gleichem Zustand nach dem Namen des Services.
Die so eingestellte Reihenfolge bleibt auch als nachrangige Sortierung
erhalten, wenn der Benutzer nach einer bestimmten Spalte umsortiert.
:::

:::: imageblock
::: content
![Eigenschaften zur Sortierung der
Ansicht.](../images/views_edit_view_sorting.png)
:::
::::
::::::

:::::::::: sect2
### []{#_gruppierung .hidden-anchor .sr-only}3.8. Gruppierung {#heading__gruppierung}

::: paragraph
Durch Gruppierung zerteilen Sie eine Tabelle in mehrere
Abschnitte --- wobei jeder Abschnitt Daten anzeigt, die irgendwie
zusammengehören. Ein gutes Beispiel ist die Tabellenansicht [Service
problems]{.guihint}, welche Sie bequem über das Snapin
[Overview]{.guihint} erreichen.
:::

::: paragraph
Hier sehen Sie diese Tabelle gruppiert nach dem Service-Zustand
([State]{.guihint}): zuerst alle [CRIT]{.state2}, dann
[UNKNOWN]{.state3}, dann [WARN]{.state1} - jeweils mit einem eigenen
Gruppentitel:
:::

:::: imageblock
::: content
![Gruppierte Ansicht.](../images/views_edit_view_grouping.png)
:::
::::

::: paragraph
Die Gruppierung in einer Tabellenansicht konfigurieren Sie analog zu den
Spalten. Legen Sie einfach fest, nach welchen Spalten gruppiert werden
soll. Meist ist das nur eine einzige, aber es können auch mehrere sein.
Alle Datensätze mit dem gleichen Wert für alle gewählten Spalten werden
dann in einer Gruppe angezeigt. Und die Spalteninformation wird jeweils
als Gruppentitel anzeigt.
:::

::: paragraph
Es ist wichtig, dass Sie die Datensätze auch vorrangig nach der
gewählten Gruppeneigenschaft **sortieren!** Andernfalls kann es sein,
dass die gleiche Gruppe mehrfach auftaucht (in Einzelfällen kann dies
sogar gewünscht sein).
:::

::: paragraph
Übrigens: Ein Umsortieren nach einer Spalte durch den Benutzer hat
keinen Einfluss auf die Gruppierung: In diesem Fall wird nur die
Reihenfolge der Gruppen bestimmt und die Datensätze werden innerhalb der
Gruppen sortiert. Die Gruppen selbst bleiben erhalten.
:::
::::::::::

::::::::::::: sect2
### []{#filter_context .hidden-anchor .sr-only}3.9. Filter, Kontext und Suche {#heading_filter_context}

::: paragraph
Ein wichtiger Aspekt von Tabellenansichten ist die *Selektion* der
Daten. Welche Hosts oder Services sollen in der Tabelle angezeigt
werden? Checkmk verwendet hierfür das Konzept der **Filter.** Hier sind
ein paar Beispiele für Host-Filter:
:::

:::: imageblock
::: content
![Beispiele für Host-Filter.](../images/views_filter.png)
:::
::::

::: paragraph
Jeder Filter kann vom Benutzer mit Suchbegriffen oder anderen Kriterien
gefüllt werden und reduziert dann die Liste der Ergebnisse auf
diejenigen Datensätze, die die Kriterien erfüllen. Die Filter werden
dabei UND-verknüpft. Die Filterkriterien, die bei einer Tabellenansicht
dann tatsächlich zum Einsatz kommen, werden aus drei Quellen
zusammengestellt:
:::

::: {.olist .arabic}
1.  Filter, die direkt in der Tabellenansicht hinterlegt und mit
    Kriterien gefüllt sind.

2.  Filter, die der Benutzer interaktiv in der Tabellenansicht mit
    [![icon filter](../images/icons/icon_filter.png)]{.image-inline}
    gesetzt hat.

3.  Filter, die per Variablen über die URL gesetzt werden.
:::

::: paragraph
Die Filter, die Sie beim Editieren einer Tabellenansicht im Kasten
[Context / Search Filters]{.guihint} zusammenstellen, haben dabei zwei
Funktionen. Zum einen legen Sie so fest, welche Filter dem Benutzer beim
Klick auf [![icon
filter](../images/icons/icon_filter.png)]{.image-inline} angeboten
werden. Zum anderen können Sie Filter bereits mit Kriterien vorbelegen
und so die in der Tabellenansicht gezeigten Daten einschränken (Punkt 1
von oben).
:::

::: paragraph
Falls Sie eine Tabellenansicht mit **Kontext** anlegen oder editieren,
so tritt anstelle der Filter des entsprechenden Objekts nur ein
optionales Eingabefeld. In diesem gilt dann immer ein *exakter*
Vergleich (Groß-/Kleinschreibung beachten). Nehmen wir als Beispiel die
Tabellenansicht `host`, welche alle Services eines bestimmten Hosts
anzeigt. Der Host-Name wird der Tabellenansicht über einen Kontext mit
auf den Weg gegeben. Sie können sich aber eine Tabellenansicht bauen,
welche den gezeigten Host quasi **hart kodiert** direkt in der
Tabellenansicht festlegt:
:::

:::: imageblock
::: content
![Eigenschaften zum Filtern der
Ansicht.](../images/views_edit_view_context_filter.png)
:::
::::

::: paragraph
Damit können Sie diese Tabellenansicht wieder ohne Kontext aufrufen und
auf Wunsch auch problemlos in das Snapin [Views]{.guihint} einbinden.
:::
:::::::::::::

::::::: sect2
### []{#_spezielle_suchansichten .hidden-anchor .sr-only}3.10. Spezielle Suchansichten {#heading__spezielle_suchansichten}

::: paragraph
Die mitgelieferten Tabellenansichten [Host search]{.guihint} und
[Service search]{.guihint} (und auch andere) verhalten sich im Bezug auf
die Filter auf eine spezielle Art: Wenn Sie so eine Tabellenansicht
anwählen, so startet diese mit einem geöffnetem Filter-Formular und
zeigt erst dann Hosts oder Services an, wenn dieses abgeschickt wurde.
:::

::: paragraph
Warum? Es wäre einfach sehr unpraktisch, wenn Sie erst auf [All
services]{.guihint} gehen müssten --- dann warten bis viele tausend
Services dargestellt würden --- und erst dann durch eine Sucheingabe das
Ergebnis filtern könnten. Dieses Verhalten legt die Option [Show data
only on search]{.guihint} fest:
:::

:::: imageblock
::: content
![Die Option \'Show data only on
search\'.](../images/views_edit_view_view_properties_show_data.png)
:::
::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#new .hidden-anchor .sr-only}4. Neue Tabellenansichten erstellen {#heading_new}

:::::::::::::::::::::::: sectionbody
::: paragraph
Das Erzeugen einer neuen Tabellenansicht mit [![button add
view](../images/icons/button_add_view.png)]{.image-inline} geht im
Prinzip genauso wie das Editieren einer bestehenden
Tabellenansicht --- mit einem kleinen Unterschied: Sie müssen vorher
noch eine **Datenquelle** und einen **spezifischen Objekttyp**
auswählen.
:::

::::::::::::::: sect2
### []{#datasource .hidden-anchor .sr-only}4.1. Datenquelle {#heading_datasource}

:::: imageblock
::: content
![Auswahl einer Datenquelle.](../images/views_create_view_1.png)
:::
::::

::: paragraph
Die Datenquelle ist das, was man in Datenbanken vielleicht als Tabelle
oder Datenbank-View bezeichnen würde. Checkmk verwendet zwar keine
SQL-Datenbank, ist intern aber ähnlich aufgebaut. In den meisten Fällen
liegen Sie mit [All services]{.guihint} oder [All hosts]{.guihint}
richtig. Es gibt aber einige spezielle Datenquellen, die hier kurz
aufgelistet werden sollen:
:::

+-----------------------------------+-----------------------------------+
| Datenquelle                       | Bedeutung                         |
+===================================+===================================+
| Host- und Service-Gruppen,        | siehe                             |
| diverse                           | [unten](#host_service_groups)     |
+-----------------------------------+-----------------------------------+
| [Alert Statistics]{.guihint}      | [Statusstatistiken](lives         |
|                                   | tatus.html#retrieving_statistics) |
+-----------------------------------+-----------------------------------+
| [BI]{.guihint}, diverse           | [Business Intelligence](bi.html)  |
+-----------------------------------+-----------------------------------+
| [Event Console]{.guihint}, Host-  | [Event Console](ec.html)          |
| und Service-Events                |                                   |
+-----------------------------------+-----------------------------------+
| [Inventory]{.guihint}, diverse    | [HW/SW-Inventur](inventory.html)  |
+-----------------------------------+-----------------------------------+
| [The Logfile]{.guihint}           | [Livest                           |
|                                   | atus-Daten](livestatus.html#logs) |
+-----------------------------------+-----------------------------------+

::::::::::: sect3
#### []{#host_service_groups .hidden-anchor .sr-only}Host- und Service-Gruppen {#heading_host_service_groups}

::: paragraph
Die Datenquellen [Host groups]{.guihint} und [Service groups]{.guihint}
liefern je Zeile die Informationen über die Gruppe selbst --- Filter für
einzelne Hosts oder Services gibt es entsprechend nicht. Ein Beispiel
für diese Datenquelle ist die Standardansicht [Host groups]{.guihint}.
In verteilten Umgebungen erledigen die Datenquellen [Host groups,
merged]{.guihint} und [Service groups, merged]{.guihint} genau das
Gleiche.
:::

:::: imageblock
::: content
![Ansicht für Host-Gruppen.](../images/views_hostgroups_summary.png)
:::
::::

::: paragraph
Wenn Sie hingegen Informationen zu einzelnen Hosts wünschen, lediglich
gruppiert nach Host-Gruppen, können Sie etwa die Standardansicht [All
hosts]{.guihint} in den Einstellungen im Kasten [Grouping]{.guihint} um
die Option [Hosts: Host groups the host is member of]{.guihint}
ergänzen. Da Hosts mehreren Gruppen zugeordnet sein können, finden Sie
in der Tabellenansicht dann einen einzelnen Bereich für jede
**Host-Gruppenkombination,** die für mindestens einen Host gilt.
:::

:::: imageblock
::: content
![Ansicht mit Gruppierung nach
Host-Gruppen.](../images/views_hostgroups.png)
:::
::::

::: paragraph
Auf dieselbe Weise können Sie auch mit Services und Service-Gruppen
verfahren.
:::

::: paragraph
Je nach ausgewählter Datenquelle stehen Ihnen unterschiedliche Spalten
zum Aufbau der Tabellenansicht zur Verfügung.
:::
:::::::::::
:::::::::::::::

::::::::: sect2
### []{#_objekttyp_global_oder_mit_kontext .hidden-anchor .sr-only}4.2. Objekttyp: Global oder mit Kontext {#heading__objekttyp_global_oder_mit_kontext}

:::: imageblock
::: content
![Auswahl eines spezifischen
Objekttyps.](../images/views_create_view_2.png)
:::
::::

::: paragraph
Hier entscheidet sich, ob Ihre neue Tabellenansicht einen Kontext haben
oder ob es eine globale Tabellenansicht werden soll. Welche
Auswahlmöglichkeiten Sie haben, hängt von der gewählten Datenquelle ab.
Der mit Abstand häufigste Kontext ist Host. Die Abbildung von oben
erscheint nach der Auswahl der Datenquelle [All services.]{.guihint}
:::

::: paragraph
Durch das Aktivieren von [Show information of a single Host]{.guihint}
legen Sie fest, dass die neue Tabellenansicht genau einen Host
beschreibt. So haben Sie die Grundlage dafür geschaffen, dass die
Tabellenansicht nicht global, sondern verlinkt sichtbar wird:
:::

::: ulist
- Bei einer Host-Ansicht mit einem Kontext

- Als Verknüpfung in einer Spalte (siehe oben, z.B. Klick auf Host-Name
  in einer Tabellenansicht)
:::

::: paragraph
Bei dem Kontexttyp Service gibt es zwei Möglichkeiten: Wenn Sie nur
[Show information of a single Service]{.guihint} anwählen, können Sie
eine Tabellenansicht bauen, die alle Services mit dem gleichen Namen
aber auf *verschiedenen Hosts* anzeigt. Wenn es um einen ganz bestimmten
Service von einem einzigen Host gehen sollen, dann wählen Sie zusätzlich
[Show information of a single Host]{.guihint} aus.
:::
:::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

::::::::::::::::::::::::::::: sect1
## []{#joined_inventory_columns .hidden-anchor .sr-only}5. Inventur-Tabellen verknüpfen {#heading_joined_inventory_columns}

:::::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk bietet viele unterschiedliche Daten zu einem Host oder einem
Service. Die meisten davon können Sie mit den Datenquellen [All
services]{.guihint} oder [All hosts]{.guihint} darstellen. Die
[HW/SW-Inventur](inventory.html) bietet darüber hinaus weitere
[Tabellen](inventory.html#table) (als Datenquellen), die Sie ebenso in
eigenen Ansichten anzeigen und individuell strukturieren können. Ab
Checkmk [2.2.0]{.new} können Sie solchen Ansichten auch Spalten aus
anderen Tabellen hinzufügen, sofern diese eine gemeinsame Spalte haben.
:::

::: paragraph
**Wichtig:** Die Anzahl der Zeilen der finalen Ansicht entspricht der
Anzahl der Zeilen der zugrundeliegenden Datenquelle Ihrer Ansicht.
Verknüpfte Tabellen fügen lediglich ausgewählte Spalten hinzu.
:::

::: paragraph
In dem folgenden Beispiel werden Sie einmal eine sehr kompakte Ansicht
erstellen, in der zwei HW/SW-Inventur-Tabellen miteinander verknüpft
werden. Erstellen Sie zum Anfang [eine neue Ansicht](#new) und wählen
Sie als grundlegende [Datenquelle](#datasource) die gewünschte
Inventur-Tabelle aus. Für das Beispiel suchen Sie nach [Inventory table:
Checkmk ➤ Checkmk sites]{.guihint} und bestätigen anschließend mit
[![button continue](../images/icons/button_continue.png)]{.image-inline}
[Continue]{.guihint}:
:::

:::: imageblock
::: content
![Auswahl der Datenquelle \'Checkmk
sites\'.](../images/views_create_view_3.png)
:::
::::

::: paragraph
Die darauf folgende Seite können Sie überspringen, da es nicht nötig
ist, die Datenquelle auf einen einzelnen Host oder eine einzelne Instanz
einzuschränken. Der nächste Schritt erfolgt also direkt auf der
Hauptseite der Konfiguration, wo Sie zunächst die [Unique ID]{.guihint}
und einen [Title]{.guihint} eintragen.
:::

::: paragraph
Im Kasten [Macros for joining service data or inventory
tables]{.guihint} kommt dann die erste spezifische Konfiguration, um
später andere Datenquellen in die Ansicht einzubinden. Zu diesem Zweck
werden Indikatoren benötigt, über die man dann später die richtigen
Zeilen in den weiteren Datenquellen identifiziert. Legen Sie also hier
wie in dem nachfolgenden Beispiel die Makros für die Spalten
[Version]{.guihint} und [Site]{.guihint} an:
:::

:::: imageblock
::: content
![Dialog zum Anlegen von Makros.](../images/views_create_view_4.png)
:::
::::

::: paragraph
Diese Makros können Sie nun in speziellen [Columns]{.guihint} verwenden.
Neben den [regulären Spalten,](#columns) die bereits in der Anpassung
von Ansichten verwendet wurden, stehen jetzt sowohl die ebenfalls vorher
beschriebenen Spalten der [Service-Datenquelle](#joined_columns)
([Joined columns]{.guihint}) als auch die der [Joined inventory
columns]{.guihint} zur Verfügung.
:::

::: paragraph
Die ersten beiden Spalten nutzen Standarddaten aus der Datenquelle. Da
Daten aus der HW/SW-Inventur immer zu einem bestimmten Host und einer
bestimmten Instanz gehören, stehen Ihnen diese Tabellen ebenfalls zur
Verfügung, wenn Sie eine solche Datenquelle ausgewählt haben.
:::

:::: imageblock
::: content
![Dialog zur Auswahl der Spalten.](../images/views_create_view_5.png)
:::
::::

::: paragraph
Anschließend können Sie die definierten Makros nicht nur in den [Joined
inventory columns]{.guihint} verwenden, sondern auch in den [Joined
columns,]{.guihint} um die Daten von bestimmten Services anzuzeigen. Das
ermöglicht die Kombination unterschiedlichster Quellen --- in diesem
Fall, das Perf-O-Meter des dazugehörigen Performance-Service einer
Instanz anzuzeigen.
:::

::: paragraph
Die Makros können Sie übrigens genauso auch bei der Definition von
regulären Ausdrücken verwenden.
:::

:::: imageblock
::: content
![Auswahl einer \'Joined column\' unter Verwendung eines
Makros.](../images/views_create_view_6.png)
:::
::::

::: paragraph
Daten aus anderen HW/SW-Inventur-Tabellen anzuzeigen funktioniert ganz
ähnlich. Lediglich die zu verwendende Tabelle ist vorher auszuwählen. In
dem nachfolgenden Beispiel verwenden Sie die Tabelle [Checkmk ➤ Checkmk
versions,]{.guihint} wodurch die Drop-down-Liste [Display the
column]{.guihint} automatisch auf eine sinnvolle Auswahl eingeschränkt
wird.
:::

::: paragraph
Wie Checkmk die richtige Zeile in der Tabelle findet, von der die Spalte
angezeigt werden soll, bestimmen Sie danach. Fügen Sie dafür mit dem
Knopf [Add new match criteria]{.guihint} ein Kriterium in Form einer
Spalte hinzu, über das Checkmk später die passende Zeile bestimmen kann.
In dem obigen Beispiel ist das die [Version.]{.gui} Denn diese ist in
der Tabelle einzigartig und kann nur einmal vorkommen. Das bedeutet
umgekehrt auch, dass Sie zwar beliebige Tabellen der HW/SW-Inventur
miteinander verknüpfen können, Sie dabei aber auch sicherstellen müssen,
dass die beiden Tabellen immer eine gemeinsame Spalte haben und diese
Spalte auch immer einzigartige Einträge enthält. In dem obigen Beispiel
wäre die Spalte [Sites]{.guihint} also kein geeignetes Kriterium, da es
mehrere Editionen mit derselben Anzahl an Instanzen geben könnte.
:::

:::: imageblock
::: content
![Auswahl einer \'Joined inventory column\' unter Verwendung eines
Makros.](../images/views_create_view_7.png)
:::
::::

::: paragraph
Selbstverständlich können Sie bei Bedarf auch bei einer [Joined
inventory column]{.guihint} den Titel der Spalte anpassen, wenn der
automatische nicht passen sollte. Nachdem alle Einstellungen vorgenommen
wurden, speichern Sie mit [![button save and go to
view](../images/icons/button_save_and_go_to_view.png)]{.image-inline}
[Save & go to view]{.guihint} die neue Ansicht ab und werden direkt zu
dem Ergebnis geleitet. Je nachdem, wie viele Instanzen bei Ihnen
überwacht werden, wird auch entsprechend für jede eine Zeile in der
Ansicht eingefügt:
:::

:::: imageblock
::: content
![Fertige Ansicht inklusive Spalten aus anderen
Quellen.](../images/views_create_view_8.png)
:::
::::

::: paragraph
Wie Sie hier sehen können, gibt es für jede Spalte immer einen
Standardtitel, wenn dieser nicht von Ihnen vorgegeben wird. In der
dritten Spalte zu dem [Perf-O-Meter]{.guihint} wurde der Titel nicht
vergeben, so dass von Checkmk der verwendete reguläre Ausdruck als Titel
herangezogen wurde. Sie können das jederzeit ändern und wie bei der
Spalte zu der [Edition]{.guihint} anpassen.
:::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

:::::::::::::::::::::::::::: sect1
## []{#matrix .hidden-anchor .sr-only}6. Die Matrix {#heading_matrix}

::::::::::::::::::::::::::: sectionbody
::: paragraph
Wenn Sie in den [View Properties]{.guihint} als [Basic Layout]{.guihint}
bei einer Ihrer Tabellenansichten [Matrix]{.guihint} einstellen, werden
Sie wahrscheinlich erstmal seltsame Dinge erleben und sich fragen, was
das Ganze soll. Die Matrix ist sicher nicht auf den ersten Blick
einleuchtend, aber Sie können damit tolle Dinge machen.
:::

::: paragraph
In den ausgelieferten Tabellenansichten gibt es z.B. [Search performance
data,]{.guihint} die dieses Layout verwendet. Sie finden diese
Tabellenansicht über [Customize \> Visualization \> Views.]{.guihint}
:::

::: paragraph
Folgende Abbildung zeigt eine Suche nach dem Serviceausdruck
`CPU|^memory|Filesystem /opt/omd/sites/mysite`:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Filter für die
Service-Suche.](../images/views_matrix_filter_service.png){width="55%"}
:::
::::

::: paragraph
Das Ergebnis ist eine hübsche Tabelle der Hosts, in denen die Metriken
all dieser Services gegenübergestellt sind. Nicht alle Hosts haben die
gleichen Services, so dass bei einigen Hosts dann die entsprechenden
Zellen einfach leer bleiben:
:::

:::: imageblock
::: content
![Ergebnis der Service-Suche in einer
Matrixansicht.](../images/views_matrix_view_1.png)
:::
::::

::: paragraph
Das Ganze sieht jetzt erstmal sehr ähnlich aus wie die weiter oben
beschriebene [Information über Services in einer
Host-Ansicht.](#joined_columns) Es gibt aber ein paar wesentliche
Unterschiede:
:::

::: {.olist .arabic}
1.  Die Liste der Services ist dynamisch und nicht fest konfiguriert.

2.  Die Hosts sind hier die Spalten  ---  nicht die Zeilen.
:::

::: paragraph
Sie können mit der Matrix noch viel mehr anstellen. Wenn Sie in die
Definition der Tabellenansicht gucken, können Sie sehen, wie diese
konstruiert ist:
:::

::: ulist
- Als [Basic Layout]{.guihint} ist [Matrix]{.guihint} eingetragen.

- Bei [Grouping]{.guihint} ist als einzige Spalte der Host-Name ([Hosts:
  Hostname]{.guihint}) eingetragen.

- Bei [Columns]{.guihint} sind die [Service description]{.guihint} und
  das [Service Perf-O-Meter]{.guihint} eingetragen.
:::

::: paragraph
Die Regel für das Matrix-Layout ist so:
:::

::: ulist
- Die unter **Grouping festgelegten Spalten** werden als Überschriften
  für die Spalten verwendet.

- Die **erste normale Spalte** bildet die linke Spalte mit der
  Beschriftung der Zeilen.

- Alle **weiteren normalen Spalten** werden in den Zellen angezeigt.
:::

::: paragraph
Wenn Sie z.B. mehr Informationen über den Host anzeigen möchten, fügen
Sie einfach weitere Spalten im Kasten [Grouping]{.guihint} hinzu. So
sieht z.B. die Tabelle von oben aus, wenn Sie die Spalten [Host
icons]{.guihint} und [Folder - just folder name]{.guihint} hinzufügen:
:::

:::: imageblock
::: content
![Matrixansicht mit zusätzlichen
Zeilen.](../images/views_matrix_view_2.png)
:::
::::

::: paragraph
Weitere **normale Spalten** landen dann direkt in den Zellen. Folgendes
Beispiel (gekürzt) zeigt die Matrix mit der zusätzlichen Spalte [Output
of check plugin]{.guihint}:
:::

:::: imageblock
::: content
![Matrixansicht mit zusätzlichen Informationen in den
Zellen.](../images/views_matrix_view_3.png)
:::
::::

:::::: sect2
### []{#_erkennen_von_ausreißern .hidden-anchor .sr-only}6.1. Erkennen von Ausreißern {#heading__erkennen_von_ausreißern}

::: paragraph
Warum sind eigentlich manche Zellen farbig hinterlegt? Nun --- hier
werden Sie hingewiesen auf Werte, die sich **abheben von der Mehrheit.**
Das ist wohl bei Messdaten nicht so sinnvoll. Aber es gibt Anwender, die
mit einer speziell konstruierten Matrixansicht auf einen Blick
feststellen können, ob z.B. bei gewissen Hosts oder Services eine
falsche Kontaktgruppe eingetragen ist.
:::

:::: imageblock
::: content
![Matrixansicht mit farblicher Kennzeichnung von Zellen mit abweichendem
Inhalt.](../images/views_matrix_view_4.png)
:::
::::
::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

::::::::::: sect1
## []{#alarm_sounds .hidden-anchor .sr-only}7. Alarmtöne {#heading_alarm_sounds}

:::::::::: sectionbody
::: paragraph
Eine Tabellenansicht kann über den Browser Alarmtöne (*alarm sounds*)
abspielen, wenn sich in der Tabelle mindestens ein Problem befindet
(also ein Host der nicht [UP]{.hstate0} oder ein Service der nicht
[OK]{.state0} ist). Diese primitive Art der Alarmierung ist z.B.
interessant für Leitstände, wo die Liste der Probleme ständig auf einem
Schirm sichtbar ist, aber der Operator nicht ständig auf diesen starren
möchte.
:::

::: paragraph
Die Alarmtöne sind per Default ausgeschaltet. Über den globalen Schalter
[Setup \> General \> Global settings \> User interface \> Enable sounds
in views]{.guihint} können Sie diese einschalten. Wie (fast) immer hilft
hier die Suche im [Setup]{.guihint}-Menü:
:::

:::: imageblock
::: content
![Globale Einstellung zum Einschalten von Alarmtönen in
Ansichten.](../images/global_settings_enable_sound.png)
:::
::::

::: paragraph
Alarmtöne werden aber nicht in allen Tabellenansichten abgespielt,
sondern nur, wo dies in den [View Properties]{.guihint} aktiviert ist:
:::

:::: imageblock
::: content
![Aktivierung von Alarmtönen in einer
Ansicht.](../images/view_properties_sounds.png)
:::
::::
::::::::::
:::::::::::

:::::::::: sect1
## []{#embed_views .hidden-anchor .sr-only}8. Ansichten in externe Websites einbetten {#heading_embed_views}

::::::::: sectionbody
::: paragraph
Da jede Tabellenansicht über eine URL erreichbar ist, können Sie diese
auch in andere Webseiten einbetten --- z.B. über einen `<iframe>`.
Etliche Elemente der Tabellenansicht ergeben allerdings in so einem
Kontext keinen Sinn oder sind sogar störend. In so einem Fall können Sie
an die URL die Variable `display_options=…​` anhängen, über die Sie genau
steuern können, welche Bestandteile der Tabellenansicht im HTML-Code
**nicht** generiert werden sollen.
:::

::: paragraph
**Wichtig:** Auch die Navigation von Checkmk ist beim Einbetten meist
eher unerwünscht. Bevor Sie also in einer Tabellenansicht manuell
Optionen setzen, lassen Sie die Seite ohne Navigation und Seitenleiste
anzeigen indem Sie [Display \> Show page navigation]{.guihint}
ausschalten.
:::

::: paragraph
Jeder Bestandteil wird durch einen Buchstaben kodiert und kann
entsprechend ausgeschlossen werden.
:::

::: paragraph
Folgende Buchstaben sind definiert:
:::

+------+---------------------------------------------------------------+
| Op   | Wirkung                                                       |
| tion |                                                               |
+======+===============================================================+
| `t`  | Titelzeile (mit Seitentitel, Breadcrumb-Pfad, Symbol zum      |
|      | Countdown der Seitenaktualisierung), Menüleiste und           |
|      | Aktionsleiste werden entfernt.                                |
+------+---------------------------------------------------------------+
| `b`  | Menüeinträge und Aktionsknöpfe werden entfernt, die zu        |
|      | anderen Tabellenansichten verlinken.                          |
+------+---------------------------------------------------------------+
| `f`  | Menüeintrag [Display \> Filter]{.guihint} und der zugehörige  |
|      | Aktionsknopf [![icon                                          |
|      | filter](../images/icons/icon_filter.png)]{.image-inline} zum  |
|      | Öffnen der Filterleiste werden entfernt.                      |
+------+---------------------------------------------------------------+
| `c`  | Menü [Commands]{.guihint} und zugehörige Aktionsknöpfe werden |
|      | entfernt.                                                     |
+------+---------------------------------------------------------------+
| `o`  | Die Optionen [Entries per row]{.guihint} und [Refresh         |
|      | interval]{.guihint} werden entfernt, sonst einzublenden mit   |
|      | [Display \> Modify display options]{.guihint}.                |
+------+---------------------------------------------------------------+
| `d`  | Menüeintrag [Display \> Modify display options]{.guihint}     |
|      | wird entfernt.                                                |
+------+---------------------------------------------------------------+
| `e`  | Menüeintrag [Display \> Customize View]{.guihint} wird        |
|      | entfernt.                                                     |
+------+---------------------------------------------------------------+
| `r`  | Symbol zum Countdown der Seitenaktualisierung in der          |
|      | Titelzeile und der JavaScript-Code für die automatische       |
|      | Aktualisierung werden entfernt.                               |
+------+---------------------------------------------------------------+
| `s`  | Abspielen von [Alarmtönen](#alarm_sounds) bei den             |
|      | Service-Zuständen [WARN]{.state1} und [CRIT]{.state2} wird    |
|      | unterdrückt.                                                  |
+------+---------------------------------------------------------------+
| `i`  | Links auf andere Tabellenansichten werden entfernt, z.B. in   |
|      | einer Service-Liste die Links in der Spalte                   |
|      | [Service]{.guihint}.                                          |
+------+---------------------------------------------------------------+
| `m`  | Das Ziel von Links ist standardmäßig der HTML-Frame           |
|      | `main` --- mit dieser Option werden Links in neuen Tabs       |
|      | geöffnet.                                                     |
+------+---------------------------------------------------------------+
| `l`  | Links in Spaltentiteln werden entfernt.                       |
+------+---------------------------------------------------------------+
| `w`  | Limitierung und Livestatus-Fehlermeldungen.                   |
+------+---------------------------------------------------------------+

::: paragraph
Wenn Sie also die z.B. alle Bedienelemente, Knöpfe und Links abschalten
und nur die eigentliche Tabelle darstellen möchten, so sieht ein Link
auf die Tabellenansicht `allhosts` so aus:
:::

::: paragraph
`/myserver/mysite/check_mk/view.py?view_name=allhosts&display_options=til`
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::: sect1
## []{#_eigene_icons_und_aktionen_einfügen .hidden-anchor .sr-only}9. Eigene Icons und Aktionen einfügen {#heading__eigene_icons_und_aktionen_einfügen}

:::::::::::::::::::::::::::: sectionbody
::: paragraph
In Tabellenansichten von Hosts und Services sehen Sie auch eine Spalte
für Icons und darin das [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} Aktionsmenü, aus
dem Sie Host- beziehungsweise Service-Aktionen auswählen können. Sie
dürfen Tabellenansichten aber auch um eigene Icons erweitern. Diese
können wahlweise schlicht zur Visualisierung genutzt oder mit eigenen
Aktionen belegt werden.
:::

::: paragraph
So ließen sich zum Beispiel Hosts, die über eine grafische Weboberfläche
verfügen, über solch ein individuelles Icon schnell identifizieren und
über einen Link auch direkt ansteuern.
:::

::: paragraph
Das Prozedere für eigene Icons und Aktionen gliedert sich in drei
Schritte:
:::

::: {.olist .arabic}
1.  Icons hochladen.

2.  Icons/Aktionen definieren.

3.  Icons Hosts/Services zuordnen.
:::

::: paragraph
Starten Sie über [Setup \> General \> Custom Icons]{.guihint} und laden
Sie eine lokale Datei mit einer maximalen Größe von 80 x 80 Pixeln hoch.
Damit ist das Icon im System, findet aber noch keinerlei Verwendung.
:::

:::: imageblock
::: content
![Dialog zur Auswahl und zum Hochladen eines eigenen
Icons.](../images/views_manage_icons_upload.png)
:::
::::

::: paragraph
Nun müssen Sie das Icon noch als über [Regeln](glossar.html#rule)
ansprechbares Objekt und optional eine zugehörige Aktion definieren. Die
Einstellungen finden Sie unter [Setup \> General \> Global settings \>
User interface \> Custom icons and actions.]{.guihint} Erstellen Sie
hier über [Add new element]{.guihint} einen neuen Eintrag und legen Sie
[ID]{.guihint}, [Icon]{.guihint} und einen [Title]{.guihint} fest; der
Titel wird übrigens später per On-Mouse-Over-Effekt als Tooltipp direkt
am Icon angezeigt und ist für die Benutzer damit sehr hilfreich.
:::

:::: imageblock
::: content
![Eigenschaften für eigene
Icons.](../images/views_global_settings_custom_icons_and_actions.png)
:::
::::

::: paragraph
Interessant wird es nun beim Punkt [Action]{.guihint}: Aktion ist hier
gleichzusetzen mit einer URL und für diese dürfen Sie einige Variablen
wie `$HOSTNAME$` oder `$SERVICEDESC$` (Service-Beschreibung)
nutzen --- weitere Hinweise bekommen Sie über die Inline-Hilfe. Eine
gültige Aktion wäre beispielsweise:
:::

::: paragraph
`view.py?host=$HOSTNAME$&site=mysite&view_name=host`
:::

::: paragraph
Diese Aktion ruft schlicht die Standard-Host-Ansicht für den jeweiligen
Host auf der Instanz `mysite` auf.
:::

::: paragraph
Über ein Häkchen bei [Show in column]{.guihint} können Sie das Icon dann
als eigenständiges Bildchen neben [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} anzeigen lassen,
andernfalls landet Ihre Aktion im zugehörigen Aktionsmenü.
:::

::: paragraph
Im letzten Schritt bestimmen Sie nun, bei welchen Hosts oder Services
das neue Icon angezeigt werden soll --- und das natürlich über Regeln.
Sie finden die beiden Regelsätze [Custom icons or actions for hosts in
status GUI]{.guihint} und [Custom icons or actions for services in
status GUI]{.guihint} im [Setup]{.guihint}-Menü unter [Host monitoring
rules]{.guihint} und [Service monitoring rules]{.guihint}. Am
schnellsten finden Sie die beiden Regeln mit der Suche im
[Setup]{.guihint}-Menü.
:::

::: paragraph
Legen Sie eine neue Regel im gewünschten Ordner an und setzen Sie darin
mindestens zwei Optionen: Zum einen wählen Sie unter [Custom icons or
actions for hosts in status GUI]{.guihint} das just angelegte Icon:
:::

:::: imageblock
::: content
![Die Regel für die Nutzung eines eigenen
Icons.](../images/views_custom_icons_or_actions.png)
:::
::::

::: paragraph
Zum anderen filtern Sie im Kasten [Conditions]{.guihint} wie üblich auf
die gewünschten Hosts/Services:
:::

:::: imageblock
::: content
![Bedingungen in der Regel für die Nutzung eines eigenen
Icons.](../images/views_custom_icons_or_actions_b.png)
:::
::::

::: paragraph
Speichern und bestätigen Sie anschließend die Änderungen.
:::

::: paragraph
In Host- und Service-Ansichten sehen Sie ab sofort bei den gefilterten
Hosts und Services Ihr neues Icon neben oder im Aktionsmenü:
:::

:::: imageblock
::: content
![Host-Ansicht mit dem eigenen
Icon.](../images/views_view_with_custom_icon.png)
:::
::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
