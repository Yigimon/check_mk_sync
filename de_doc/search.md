:::: {#header}
# Suchen in docs.checkmk.com

::: details
[Last modified on 24-Aug-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/search.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::: {#content}
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
[Glossar](glossar.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::: sectionbody
::: paragraph
Diese Website -- docs.checkmk.com -- nutzt statisch mit
[Asciidoctor](https://asciidoctor.org/){target="_blank"} gebaute
HTML-Seiten, die täglich aktualisiert werden. Solch eine Lösung ist
performant und sie wird noch viele Jahre die effizienteste Möglichkeit
sein, Ihnen das Handbuch auszuliefern. Ein weiterer Vorteil ist, dass
jeder Artikel als Einzeldatei vorhanden ist. Damit kann der Index für
die Suche im Dateisystem ohne den Umweg über das Netzwerk aufgebaut
werden. Um dies zu nutzen, wurde die Suche im September 2022 von einer
Crawler-Lösung auf das JavaScript-Programm
[Lunr.js](https://lunrjs.com/){target="_blank"} umgestellt.
:::

::: paragraph
Lunr verwendet einen Index, der als JavaScript-Objekt beim ersten
Seitenaufruf komplett mitgeladen wird. Das Objekt ist komprimiert
weniger als ein Megabyte groß und verbleibt im Cache des Browsers, was
die Suche sehr schnell macht. Nur, wenn ein neuer Index verfügbar
ist --- was einmal täglich der Fall ist --- wird dieser neu in den
Browser Cache geladen.
:::

::: paragraph
Das Bauen des Index zusammen mit den HTML-Seiten erlaubt es uns,
Seitenelemente wie das Inhaltsverzeichnis auszublenden, so dass der
Index nur relevante Begriffe enthält.
:::
::::::
:::::::

:::::::::::::::::: sect1
## []{#searchfield .hidden-anchor .sr-only}2. Suchen im Suchfeld {#heading_searchfield}

::::::::::::::::: sectionbody
::: paragraph
Prinzipiell funktioniert die Suche wie bei jeder anderen Suchmaschine
auch: Sie geben Suchbegriffe in das Suchfeld auf `docs.checkmk.com` ein.
Diese werden mit dem Index abgeglichen und Sie erhalten eine gewichtete
Liste von Ergebnissen.
:::

::::::: sect2
### []{#simple_search .hidden-anchor .sr-only}2.1. Einfache Suche {#heading_simple_search}

::: paragraph
Bei der einfachen Suche geben Sie die Suchbegriffe nacheinander in das
Suchfeld sein. Die Ergebnisliste ist dann wie folgt sortiert:
:::

::: {.olist .arabic}
1.  Ganz oben stehen Seiten, die *alle* Suchbegriffe in direkter Nähe
    zueinander enthalten.

2.  Es folgen Seiten, die *alle* Suchbegriffe, aber in größerer Distanz,
    enthalten.

3.  Schließlich folgen Seiten, welche *weniger* und schließlich nur
    *einen* der eingegebenen Suchbegriffe enthalten.
:::

::: paragraph
Das Vorkommen im Seitentitel und in der Meta-Beschreibung wird hierbei
höher gewichtet als im Fließtext.
:::

::: paragraph
Unterhalb des Suchfelds werden die 5 besten Ergebnisse gelistet. In der
Zeile darunter können Sie sich alle Ergebnisse in einem neuen
Overlay-Fenster anzeigen lassen.
:::
:::::::

:::: sect2
### []{#in_exclusion .hidden-anchor .sr-only}2.2. Suchbegriffe ein- und ausschließen {#heading_in_exclusion}

::: paragraph
Mit den Operatoren `+` und `-` können Sie Suchbegriffe explizit
einschließen und ausschließen. Beispiele:
:::

+--------------------+-------------------------------------------------+
| `                  | Findet alle Seiten, die `database` enthalten,   |
| +database -oracle` | `oracle` aber nicht.                            |
+--------------------+-------------------------------------------------+
| `+datab            | Findet Seiten, die `database`, aber nicht       |
| ase -oracle mysql` | `oracle` enthalten und zeigt diejenigen         |
|                    | Ergebnisse höher gewichtet, die zudem noch      |
|                    | `mysql` enthalten.                              |
+--------------------+-------------------------------------------------+
| `-databa           | Findet alle Seiten, in denen weder `database`   |
| se -oracle -mysql` | noch `oracle` noch `mysql` vorkommen.           |
+--------------------+-------------------------------------------------+
::::

:::: sect2
### []{#exact_match .hidden-anchor .sr-only}2.3. Zusammen vorkommende Begriffe {#heading_exact_match}

::: paragraph
Um zusammen stehende Begriffe zu finden, können Sie Leer- oder
Satzzeichen oder Kopplungsstriche durch zwei Backslashes gefolgt von
einem Leerzeichen maskieren. So findet `agent\\ controller` alle Seiten
mit *Agent Controller* auch wenn die falsche Schreibweise mit
Bindestrich verwendet wird. Mit `+agent +controller` werden dagegen
Seiten gefunden, die *Agent* und *Controller* in beliebiger Reihenfolge
und in beliebigem Abstand enthalten.
:::
::::

:::: sect2
### []{#wildcard .hidden-anchor .sr-only}2.4. Wildcard {#heading_wildcard}

::: paragraph
Der Asterisk `*` ersetzt eine beliebige Zeichenkette an einer beliebigen
Stelle eines Suchbegriffs. Während Sie tippen, fügen wir im Hintergrund
automatisch den Asterisk am Ende des eingegebenen Textes hinzu, um die
Vorschau erzeugen zu können. Schließen Sie Ihre Suche mit einem
Leerzeichen ab, um den exakten Suchbegriff zu finden.
:::
::::

:::: sect2
### []{#weight .hidden-anchor .sr-only}2.5. Gewichtung {#heading_weight}

::: paragraph
Hängen Sie eine Ganzzahl mit einem Zirkumflex an einen Suchbegriff an,
um ihn um diesen Faktor höher als den Standard zu gewichten:
:::

+--------------------+-------------------------------------------------+
| `oracle^10         | Gewichtet `oracle` zehnfach höher als           |
|  mysql^3 database` | `database` und `mysql` dreifach höher als       |
|                    | `database`.                                     |
+--------------------+-------------------------------------------------+
::::
:::::::::::::::::
::::::::::::::::::

:::::: sect1
## []{#linking .hidden-anchor .sr-only}3. Verlinkung auf die Suche {#heading_linking}

::::: sectionbody
::: paragraph
Sie können für die Suche auf `docs.checkmk.com` in der URL auch
Parameter übergeben. Das JavaScript überträgt den Suchbegriff dann ins
Suchfeld und startet die Suche. Folgende Parameter sind möglich:
:::

+--------------------+-------------------------------------------------+
| `find=searchterm`  | Mindestens ein Suchbegriff ist notwendig,       |
|                    | mehrere Suchbegriffe können Sie mit `+`         |
|                    | trennen. Verwenden Sie die                      |
|                    | [Proze                                          |
|                    | ntdarstellung](https://de.wikipedia.org/wiki/UR |
|                    | L-Encoding#Prozentdarstellung){target="_blank"} |
|                    | für alle anderen Sonderzeichen und Umlaute. Zum |
|                    | Beispiel wird `+` durch `%2B` ersetzt und `-`   |
|                    | durch `%2D`.                                    |
+--------------------+-------------------------------------------------+
| `fulloverlay=1`    | Öffnet nicht die Vorschau mit fünf Ergebnissen, |
|                    | sondern das größere Overlay-Fenster mit allen   |
|                    | Treffern.                                       |
+--------------------+-------------------------------------------------+
| `imlucky=1`        | Öffnet sofort den Artikel des ersten            |
|                    | Suchergebnisses.                                |
+--------------------+-------------------------------------------------+
| `origin=forum`     | Geben Sie diesen Parameter zum Ursprung mit an, |
|                    | wenn Sie zum Beispiel aus dem Forum verlinken   |
|                    | oder sich die Suche im Handbuch als             |
|                    | Suchmaschine anlegen. Unser Webserver schreibt  |
|                    | die Query-Parameter in seine Log-Dateien. Wir   |
|                    | werten diesen Parameter statistisch aus,        |
|                    | derzeit für `bookmarks`, `forum`, `support` und |
|                    | `checkmk`.                                      |
+--------------------+-------------------------------------------------+

::: paragraph
Prinzipiell funktioniert die Suche auf jeder Seite. Sie können
beispielsweise den englischen Artikel zum Linux-Agenten mit geöffneter
Suche nach dem Begriff `linux` wie folgt aufrufen:\
`https://docs.checkmk.com/latest/en/agent_linux.html?find=linux&origin=bookmarks`
:::
:::::
::::::
::::::::::::::::::::::::::::::::::
