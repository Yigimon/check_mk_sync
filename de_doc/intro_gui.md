:::: {#header}
# Die Checkmk-Oberfläche

::: details
[Last modified on 25-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_gui.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Das Monitoring einrichten](intro_setup_monitor.html) [Die
Benutzeroberfläche](user_interface.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#start_page .hidden-anchor .sr-only}1. Startseite {#heading_start_page}

::::::::: sectionbody
::: paragraph
In der Benutzeroberfläche (*graphical user interface*, GUI) von Checkmk
sehen Sie einige Elemente, die wir zum jetzigen Zeitpunkt noch nicht
benötigen. Viele davon sind leer oder zeigen lauter Nullen, was daran
liegt, dass wir noch keine Objekte ins Monitoring aufgenommen haben:
:::

::::: imageblock
::: content
![Checkmk-Startseite mit noch leerem \'Main
dashboard\'.](../images/intro_empty_dashboard.png)
:::

::: title
Die Startseite von Checkmk Raw
:::
:::::

::: paragraph
Trotzdem sollten Sie sich mit den Grundelementen der Oberfläche vertraut
machen. Am wichtigsten ist die Aufteilung in die **Navigationsleiste**
links, die **Hauptseite** in der Mitte und die **Seitenleiste** rechts.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das oben abgebildete [Main        |
|                                   | dashboard]{.guihint} mit          |
|                                   | Problemen und Statistiken aller   |
|                                   | Hosts und Services ist das von    |
|                                   | Checkmk Raw. Die kommerziellen    |
|                                   | Editionen bieten standardmäßig    |
|                                   | ein anderes, mit Graphen          |
|                                   | erweitertes [Main                 |
|                                   | d                                 |
|                                   | ashboard.](dashboards.html#usage) |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::
::::::::::

::::::::::::::: sect1
## []{#navigation_bar .hidden-anchor .sr-only}2. Navigationsleiste {#heading_navigation_bar}

:::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Checkmk-Navigationsleiste.](../images/gui_navbar.png){width="70px"}
:::
::::

::: paragraph
Mit der Navigationsleiste (*navigation bar*) auf der linken Seite und
den sich darin befindenden Symbolen treffen Sie die
Grundsatzentscheidung, worum sich Checkmk für Sie kümmern soll:
:::

::: paragraph
[Monitor]{.guihint} --- die Überwachung selbst
:::

::: paragraph
[Customize]{.guihint} --- die Anpassung von Oberflächenelementen, die
für die Überwachung nützlich sind (wie Lesezeichen, Views
(Statusansichten), Dashboards und Graphen)
:::

::: paragraph
[Setup]{.guihint} --- die Einrichtung der zu überwachenden Objekte (wie
Hosts und Services)
:::

::: paragraph
Hinter den drei Symbolen verbergen sich mehr oder weniger umfangreiche
Menüs, die sogenannten „Mega-Menüs" oder Symbolmenüs, deren Einträge in
mehrere Themen gegliedert sind: Zum Beispiel finden Sie im
[Setup]{.guihint}-Menü zum Thema [Hosts]{.guihint} Einträge zum
Konfigurieren von Hosts, Host-Gruppen, Host-Merkmalen und
Host-spezifischen Regeln.
:::

::: paragraph
Im unteren Bereich der Navigationsleiste finden Sie im
[User]{.guihint}-Menü Einträge, die Ihr Benutzerkonto betreffen. Oben
rechts im Menü sehen Sie den aktuellen Benutzernamen (zurzeit
`cmkadmin`) und die diesem Benutzer zugewiesene
[Rolle](wato_user.html#roles) (`admin`). In diesem Menü können Sie das
Passwort ändern, sich von der Checkmk-Oberfläche abmelden und Ihr Profil
persönlich anpassen. Eine Übersicht der persönlichen Einstellungen
finden Sie im [Kapitel zum User-Menü](user_interface.html#user_menu).
:::

::: paragraph
Im [Help]{.guihint}-Menü finden Sie die aktuell genutzte Edition und
Version von Checkmk und einige Einträge, mit denen Sie Dokumentation und
Information aufrufen können --- innerhalb von Checkmk oder außerhalb.
Unter anderem können Sie auch dieses Handbuch öffnen. Falls es nach
einem [Update](update.html) inkompatible Änderungen gibt, wird Ihnen die
Zahl im Symbol des [Help]{.guihint}-Menüs eingeblendet. Im
[Help]{.guihint}-Menü selbst wird dann ein Link in roter
Hintergrundfarbe angezeigt, mit dem Sie die Liste der *Werks* dieser
inkompatiblen Änderungen öffnen können.
:::

::: paragraph
Komplettiert wird die Navigationsleiste ganz unten durch
[Sidebar]{.guihint} (mit der Sie durch einfaches Anklicken die
Seitenleiste aus- oder einblenden können) und ganz oben durch das
Checkmk-Logo. Ein Klick auf das Logo bringt Sie immer zurück zum
Standard-Dashboard, das auf der Hauptseite angezeigt wird.
:::

::: paragraph
Für die schnelle Navigation in den Symbolmenüs stehen Ihnen folgende
Tastaturbefehle zur Verfügung:
:::

+-------------+--------------------------------------------------------+
| Kürzel      | Aktion                                                 |
+=============+========================================================+
| `ALT+m`     | Öffnet das [Monitor]{.guihint}-Menü.                   |
+-------------+--------------------------------------------------------+
| `ALT+c`     | Öffnet das [Customize]{.guihint}-Menü.                 |
+-------------+--------------------------------------------------------+
| `ALT+s`     | Öffnet das [Setup]{.guihint}-Menü.                     |
+-------------+--------------------------------------------------------+
| `ESC`       | Schließt das geöffnete Menü.                           |
+-------------+--------------------------------------------------------+
| `TAB`       | Nächster Treffer in den Suchergebnissen.               |
+-------------+--------------------------------------------------------+
| `UM         | Voriger Treffer in Suchergebnissen.                    |
| SCHALT+TAB` |                                                        |
+-------------+--------------------------------------------------------+
| `ENTER`     | Suchtreffer aufrufen.                                  |
+-------------+--------------------------------------------------------+
| `ESC`       | Mit aktivem Suchbegriff: Schließt die Suchergebnisse.  |
+-------------+--------------------------------------------------------+
::::::::::::::
:::::::::::::::

:::::::::: sect1
## []{#main_page .hidden-anchor .sr-only}3. Hauptseite {#heading_main_page}

::::::::: sectionbody
::: paragraph
Was Sie auf der Hauptseite sehen, hängt davon ab, wo Sie in Checkmk
gerade unterwegs sind. Nach der Anmeldung sehen Sie zunächst das
Standard- oder Haupt-[Dashboard](intro_tools.html#dashboards), das einen
Überblick über den aktuellen Zustand und die kürzlichen Ereignisse der
überwachten Objekte zeigt:
:::

::::: imageblock
::: content
![Checkmk-Hauptseite mit \'Main
dashboard\'.](../images/intro_mainpage_default.png)
:::

::: title
Die Hauptseite mit dem [Main dashboard]{.guihint} von Checkmk Raw
:::
:::::

::: paragraph
Der Inhalt der Hauptseite ändert sich abhängig von Ihrer Auswahl in der
Navigationsleiste oder auch der Seitenleiste. Wenn Sie zum Beispiel im
[User]{.guihint}-Menü die Änderung Ihres Profils auswählen, werden Ihnen
alle Profileinstellungen auf der Hauptseite angezeigt.
:::

::: paragraph
Unterhalb des Seitentitels sehen Sie den Pfad zur aktuellen Seite, stets
beginnend mit dem Namen des Menüs aus der Navigationsleiste. Mithilfe
dieser „Breadcrumb-Navigation" wissen Sie auch nach komplexen Aktionen,
wo Sie sich in Checkmk gerade befinden --- momentan also auf der Seite
[Main dashboard]{.guihint} im Monitoring.
:::
:::::::::
::::::::::

::::::::::::::: sect1
## []{#sidebar .hidden-anchor .sr-only}4. Seitenleiste {#heading_sidebar}

:::::::::::::: sectionbody
::: paragraph
Die Seitenleiste (*sidebar*) ist Ihr Checkmk-Cockpit. Es ist der Ort, an
dem Sie ständig die wichtigsten Monitoring-Informationen im Blick und
den schnellen Zugriff auf die Funktionen haben, die Sie in Checkmk immer
wieder benötigen.
:::

:::: imageblock
::: content
![Checkmk-Seitenleiste.](../images/gui_sidebar_default.png){width="50%"}
:::
::::

::: paragraph
Sie können sich die komplette Seitenleiste nach Ihren Vorlieben
zusammenstellen. Dazu dienen die Seitenleistenelemente, auch „Snapins"
genannt. Snapins sind kompakte GUI-Container mit vordefinierter
Funktion. Da die Seitenleiste für **Ihre** Präferenzen da sein soll,
enthält sie in der Standardeinstellung nur einige wenige Snapins:
:::

::: ulist
- [Overview]{.guihint} --- Übersicht aller überwachten Objekte mit
  aktuellen Statusinformationen

- [Bookmarks]{.guihint} --- Ihre persönlichen Lesezeichen innerhalb von
  Checkmk

- [Master control]{.guihint} --- Verschiedene Hauptschalter für das
  Monitoring
:::

::: paragraph
Wenn Sie ganz unten in der Seitenleiste auf [![Symbol zum Anzeigen aller
Snapins.](../images/icons/button_sidebar_add_snapin.png)]{.image-inline}
klicken, werden Ihnen in der Hauptseite alle Snapins angezeigt, die
aktuell **nicht** in Ihrer Seitenleiste sind und die Sie durch einen
einfachen Klick hinzufügen können. In dieser Vorschau zeigt der untere
Bereich eines jeden Snapins eine kurze Beschreibung über dessen Sinn und
Zweck. Probieren Sie es aus und füllen Sie testweise die Seitenleiste.
:::

::: paragraph
Je nach Größe Ihres Bildschirms werden nun eventuell nicht alle Snapins
sichtbar sein. Am schnellsten bewegen Sie sich vertikal durch die
Seitenleiste mit dem Mausrad, während der Mauszeiger über der
Seitenleiste ist. Bei Touchpads ist diese Funktion oft mit der Geste
„zwei Finger nebeneinander hoch- und runterschieben" möglich.
:::

::: paragraph
In der Seitenleiste können Sie die Snapins so manipulieren:
:::

::: ulist
- Auf- oder zuklappen: Klicken Sie **in** den angezeigten Titel des
  Snapins. Alternativ können Sie mit der Maus auf die Titelleiste zeigen
  und dann [![Symbol zum Einblenden des
  Snapins.](../images/icons/button_show_snapin.png)]{.image-inline} bzw.
  [![Symbol zum Ausblenden des
  Snapins.](../images/icons/button_hide_snapin.png)]{.image-inline}
  anklicken.

- Mehr oder weniger anzeigen: Manche Snapins (wie [Overview]{.guihint})
  bieten Ihnen zwei Ansichten an: entweder nur mit den wichtigsten oder
  mit allen Informationen. Zeigen Sie mit der Maus auf die Titelleiste
  und klicken Sie auf [![Symbol zum Wechsel in den
  Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline}
  bzw. [![Symbol zum Wechsel in den
  Show-less-Modus.](../images/icons/button_showless.png)]{.image-inline},
  um zwischen den beiden Ansichten zu wechseln.

- Verschieben: Drücken Sie mit der linken Maustaste **rechts neben** den
  Titel, ziehen Sie das Snapin auf- oder abwärts an eine andere Position
  in der Seitenleiste und lassen Sie die Maustaste los.

- Aus der Seitenleiste entfernen: Zeigen Sie mit der Maus auf die
  Titelleiste und klicken Sie auf [![Symbol zum Entfernen des Snapins
  aus der
  Seitenleiste.](../images/icons/button_sidebar_close_snapin.png)]{.image-inline}.
:::

::: paragraph
Soweit zu den Möglichkeiten, den Inhalt der Seitenleiste anzupassen. Als
Ganzes können Sie die Seitenleiste aus- und wieder einblenden (mit
[Sidebar]{.guihint} in der Navigationsleiste) und Sie können Ihre
Position von rechts nach links verschieben, so dass sie an die
Navigationsleiste andockt (im Menü [User \> Sidebar
position]{.guihint}).
:::

::: paragraph
Übrigens erhalten Sie genauere Informationen zu den genannten Snapins im
[Kapitel über die Monitoring-Werkzeuge](intro_tools.html).
:::
::::::::::::::
:::::::::::::::

:::::::::: sect1
## []{#show_less_more .hidden-anchor .sr-only}5. Weniger oder mehr anzeigen {#heading_show_less_more}

::::::::: sectionbody
::: paragraph
Checkmk bietet an vielen Stellen der Oberfläche eine große Auswahl an
Einstellungs- und Auswahlmöglichkeiten. Diese Auswahl kann manchmal ganz
schön überwältigend sein, sodass dadurch der Blick aufs Wesentliche
verloren gehen kann und die Orientierung erschwert wird --- nicht nur,
aber insbesondere für Einsteiger ins Monitoring.
:::

::: paragraph
Als Maßnahme zur Reduktion der Komplexität werden Sie an vielen Stellen
der Checkmk-Oberfläche drei Punkte (**...​**) finden, wie im
[Overview]{.guihint} oder hier ganz rechts in der ersten Zeile des
[Monitor]{.guihint}-Menüs:
:::

:::: imageblock
::: content
![Erste Zeile des Monitor-Menüs mit Sucheingabefeld und
Show-more-Symbol.](../images/intro_monitor_menu_showmore.png)
:::
::::

::: paragraph
Immer, wenn Sie diese Auslassungspunkte sehen, bietet Checkmk zwei
Ansichten an: Im „Show less"-Modus werden nur die wichtigsten Einträge
angezeigt (gedacht für den Einsteiger) und im „Show more"-Modus alle
Einträge (für den Experten). Sie können mit einem Klick auf die
Auslassungspunkte zwischen beiden Ansichten wechseln: mehr anzeigen mit
[![Symbol zum Wechsel in den
Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline}
und weniger mit [![Symbol zum Wechsel in den
Show-less-Modus.](../images/icons/button_showless.png)]{.image-inline}.
:::

::: paragraph
Das generelle Verhalten setzen Sie in den Einstellungen Ihres
Benutzerprofils ([User \> Edit profile \> Show more / Show less \> Set
custom show mode]{.guihint}), indem Sie einen der beiden Modi als
Default setzen --- oder auf beide Modi verzichten und sich mit [Enforce
show more]{.guihint} der ungefilterten Komplexität stellen.
:::
:::::::::
::::::::::

:::::::::::::::::::::: sect1
## []{#search .hidden-anchor .sr-only}6. Suchen und finden {#heading_search}

::::::::::::::::::::: sectionbody
::: paragraph
In der Checkmk Oberfläche finden Sie zwei zentrale Stellen für die
Suche: in der Monitoring-Umgebung im [Monitor]{.guihint}-Menü und in der
Konfigurationsumgebung im [Setup]{.guihint}-Menü. Die Eingabefelder für
die Suchbegriffe finden Sie in der ersten Zeile des entsprechenden
Menüs.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Suche in der                  |
|                                   | Monitoring-Umgebung wird so lange |
|                                   | keine Ergebnisse liefern, bis Sie |
|                                   | den ersten Host ins Monitoring    |
|                                   | aufgenommen haben.                |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::::::::: sect2
### []{#search_monitor .hidden-anchor .sr-only}6.1. Suchen in der Monitoring-Umgebung {#heading_search_monitor}

::: paragraph
Im [Monitor]{.guihint}-Menü können Sie Hosts und Services suchen. Die
Suche ist interaktiv: Sobald Sie etwas getippt haben, sehen Sie sofort
unterhalb des Suchfelds die Ergebnisse, die zu Ihrer Eingabe passen:
:::

:::: imageblock
::: content
![Monitor-Menü mit
Suchergebnissen.](../images/gui_monitor_menu_search.png){width="65%"}
:::
::::

::: paragraph
Die Suchfunktion im [Monitor]{.guihint}-Menü ist identisch mit
derjenigen, die Ihnen das Snapin [Quicksearch]{.guihint} bietet.
:::

::: paragraph
Hier ein paar Tipps für die Suche:
:::

::: ulist
- Groß- und Kleinschreibung ist bei der Suche nicht relevant --- mit
  Ausnahme der Suche nach Labels, die nur dann gefunden werden, wenn sie
  in der Syntax `Schlüssel:Wert` exakt so eingegeben werden, wie sie
  heißen.

- Sie können frei mit Stichwörtern arbeiten, z.B. nach `pending service`
  suchen.

- Sie können aber auch mit Filtern nach Mustern von Host-Namen suchen
  (mit `h:`), nach Mustern von Service-Namen (mit `s:`) und Sie können
  beide kombinieren. Eine Suche nach `s:boot` zeigt Ihnen alle Services
  an, die `boot` enthalten und eine Suche nach `h:win s:cpu` zeigt Ihnen
  alle Services an, die `cpu` enthalten, auf Hosts, die ihrerseits `win`
  enthalten.

- Pro Ergebniskategorie werden Ihnen zuerst nur maximal 10 Ergebnisse
  angezeigt. Die restlichen können Sie dann mit dem letzten Eintrag
  [Show all results]{.guihint} nachladen.

- Sie müssen keinen Eintrag aus der Vorschlagsliste auswählen. Drücken
  Sie nach Eingabe Ihres Suchbegriffs einfach die Eingabetaste und Sie
  erhalten in der Hauptseite das passende Ergebnis mit allen
  aufgelisteten Hosts bzw. Services.

- Die Suchanfrage können Sie in einem Lesezeichen speichern.
:::

::: paragraph
Außer den beiden oben erwähnten Filtern `h:` und `s:` können Sie weitere
nutzen. Welche das sind, und wie Sie auch reguläre Ausdrücke verwenden
können, erfahren Sie im [Artikel über die
Benutzeroberfläche](user_interface.html#search_monitor).
:::
::::::::::

:::::::::: sect2
### []{#search_setup .hidden-anchor .sr-only}6.2. Suchen in der Konfigurationsumgebung {#heading_search_setup}

::: paragraph
Mit dem Suchfeld des [Setup]{.guihint}-Menüs können Sie die
Konfigurationsumgebung von Checkmk durchsuchen, d.h. das
[Setup]{.guihint}-Menü selbst, mit allen seinen sichtbaren Einträgen und
zusätzlich mit einigen verborgenen.
:::

::: paragraph
Der Suchbereich (*search scope*) umfasst unter anderem alle Regelsätze,
die im [Setup]{.guihint}-Menü zu Themen zusammengefasst sind, und die
globalen Einstellungen ([Global settings]{.guihint}). Gesucht wird in
den Titeln und den Parameternamen.
:::

::: paragraph
Sie suchen mit Freitext, d.h. ohne Filterregeln wie im
[Monitor]{.guihint}-Menü. Auf Groß- und Kleinschreibung brauchen Sie
nicht zu achten. Bereits während der Eingabe werden Ihnen die
Suchergebnisse angezeigt:
:::

:::: imageblock
::: content
![Setup-Menü mit
Suchergebnissen.](../images/gui_setup_menu_search.png){width="65%"}
:::
::::

::: paragraph
Die Suche nach Regelsätzen wird dann interessant, wenn es später um die
[Feinjustierung des Monitoring](intro_finetune.html#rules) geht, aber so
weit sind wir noch nicht, denn:
:::

::: paragraph
[Weiter geht es mit der Einrichtung des
Monitorings](intro_setup_monitor.html)
:::
::::::::::
:::::::::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
