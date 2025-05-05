:::: {#header}
# Die Benutzeroberfläche

::: details
[Last modified on 10-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/user_interface.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk aufsetzen](intro_setup.html) [Grundlagen des Monitorings mit
Checkmk](monitoring_basics.html) [Die Konfiguration von
Checkmk](wato.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::: sectionbody
::: paragraph
Die grafische Benutzeroberfläche von Checkmk hat zwei Funktionen:
:::

::: ulist
- Sie zeigt in der **Monitoring-Umgebung** den aktuellen Status aller
  Hosts, Services und Ereignisse (*events*).

- Sie dient in der **Konfigurationsumgebung** zur Verwaltung und zur
  Einrichtung (*setup*) der Monitoring-Umgebung.
:::

::: paragraph
Für diese beiden Funktionen bietet Checkmk zwei Sichtweisen auf die
Hosts und Services an --- und zum Einstieg in beide Funktionen auch zwei
Menüs: das [Monitor]{.guihint}- und das [Setup]{.guihint}-Menü.
:::

::: paragraph
Das folgende Bild zeigt die Startseite von Checkmk, die direkt nach der
Anmeldung zu sehen ist:
:::

::::: imageblock
::: content
![Die Checkmk-Startseite von Checkmk Enterprise.](../images/gui.png)
:::

::: title
Die Checkmk-Startseite von Checkmk Enterprise
:::
:::::

::: paragraph
Wir werden uns in diesem Artikel mit allen Elementen beschäftigen, die
Sie auf dieser Startseite sehen --- und arbeiten uns dabei von links
nach rechts durch die Checkmk-Benutzeroberfläche: von der
Navigationsleiste über die [Hauptseite](#main_page) zur
[Seitenleiste](#sidebar).
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die sichtbaren Menüs und          |
|                                   | Menüeinträge in der               |
|                                   | Navigationsleiste sind abhängig   |
|                                   | von Ihrer Berechtigung. Sollten   |
|                                   | Sie einzelne Menüs oder           |
|                                   | Menüeinträge in Ihrem Checkmk     |
|                                   | nicht sehen, so fehlen Ihnen die  |
|                                   | entsprechenden                    |
|                                   | Zugriffsberechtigungen.           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::
:::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#navigation_bar .hidden-anchor .sr-only}2. Navigationsleiste {#heading_navigation_bar}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
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
finden Sie im [Kapitel zum User-Menü](#user_menu).
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

:::::::::: sect2
### []{#monitor_menu .hidden-anchor .sr-only}2.1. Monitor-Menü {#heading_monitor_menu}

::: paragraph
Ihr Werkzeugkasten zur Erledigung aller Aufgaben im Monitoring ist das
[Monitor]{.guihint}-Menü, das Sie über die Navigationsleiste öffnen
können:
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
In diesem Menü finden Sie die Hilfsmittel, die Ihnen Antworten auf Ihre
Fragen im Monitoring geben. Das Menü ist nach Themen (*topics*)
untergliedert. Unterhalb jedes Themas finden Sie die Menüeinträge.
:::

::: paragraph
Nach Auswahl eines der Einträge im [Monitor]{.guihint}-Menü wird Ihnen
auf der Hauptseite die angeforderte Information in der Regel entweder
als Dashboard oder als Tabellenansicht (*view*) angezeigt, auf die wir
in diesem Artikel noch näher eingehen werden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Den Inhalt des                    |
|                                   | [Monitor]{.guihint}-Menüs können  |
|                                   | Sie sich auch in die Seitenleiste |
|                                   | laden: als Snapin mit dem Titel   |
|                                   | [Views]{.guihint}. Dieses Snapin  |
|                                   | ist standardmäßig nicht in der    |
|                                   | Seitenleiste enthalten. Sie       |
|                                   | können es aber einfach durch      |
|                                   | Anklicken von [![Symbol zum       |
|                                   | Anzeigen aller                    |
|                                   | Snapin                            |
|                                   | s.](../images/icons/button_sideba |
|                                   | r_add_snapin.png)]{.image-inline} |
|                                   | aus der Liste der verfügbaren     |
|                                   | Snapins in die Seitenleiste       |
|                                   | aufnehmen.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::

::::::::::::::::::::: sect2
### []{#search_monitor .hidden-anchor .sr-only}2.2. Suchen in der Monitoring-Umgebung {#heading_search_monitor}

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
Zur Suche nach Hosts und Services können Sie eine Reihe vordefinierter
Filter nutzen, und diese auch kombinieren, um zum Beispiel gezielt nach
bestimmten Services auf bestimmten Hosts zu suchen. So findet etwa
`h:^myhost s:myservice` alle Services, deren Service-Beschreibung
`myservice` enthält und auf Hosts laufen, deren Name mit `myhost`
beginnt.
:::

::: paragraph
Die Filter können Sie auch mehrfach und kombiniert nutzen. Mehrere
Instanzen eines Filters werden dabei mit **ODER** verknüpft,
unterschiedliche Filter mit **UND**. Ausnahme: Mehrere
Host-Merkmalsfilter (`tg:`) werden immer mit **UND** verbunden.
:::

::: paragraph
Folgende Filter stehen Ihnen zur Verfügung:
:::

+-------------+------+-------------------------------------------------+
| Filter      | Be   | Beispiele                                       |
|             | fehl |                                                 |
+=============+======+=================================================+
| Host-Name   | `h:` | `h: oracle`                                     |
+-------------+------+-------------------------------------------------+
| Service-B   | `s:` | `s: cpu s: Check_MK`                            |
| eschreibung |      |                                                 |
+-------------+------+-------------------------------------------------+
| Host-Gruppe | `    | `hg: server hg: database`                       |
|             | hg:` |                                                 |
+-------------+------+-------------------------------------------------+
| Ser         | `    | `sg: testing s: myservice`                      |
| vice-Gruppe | sg:` |                                                 |
+-------------+------+-------------------------------------------------+
| H           | `    | `ad: 192.168.200. s: test`                      |
| ost-Adresse | ad:` |                                                 |
+-------------+------+-------------------------------------------------+
| Host-Alias  | `    | `al: database al: _db`                          |
|             | al:` |                                                 |
+-------------+------+-------------------------------------------------+
| H           | `    | `tg: agent:cmk-agent`\                          |
| ost-Merkmal | tg:` | `tg: cmk-agent tg: prod`                        |
+-------------+------+-------------------------------------------------+
| Host-Label  | `    | `hl: os:windows h: win`                         |
|             | hl:` |                                                 |
+-------------+------+-------------------------------------------------+
| Se          | `    | `sl: critical_interface:yes s: test`            |
| rvice-Label | sl:` |                                                 |
+-------------+------+-------------------------------------------------+

::: paragraph
In Kombination mit regulären Ausdrücken ergeben sich daraus präzise,
komplexe Filtermöglichkeiten, etwa:
:::

::: paragraph
`h: ^My.*Host$ s: ^my.*(\d|test)$ tg: mytag tg: mytest`
:::

::: paragraph
Damit werden gefunden: Services, die mit `my` beginnen und mit einer
*Ziffer* oder `test` enden, auf Hosts laufen, die mit `My` beginnen und
mit `Host` enden sowie letztlich die beiden Host-Merkmale `mytag` und
`mytest` vorweisen.
:::

::: paragraph
Sie können reguläre Ausdrücke für jeden einzelnen Filter
verwenden --- mit den folgenden Ausnahmen: Für Host- und Service-Label
sind keine regulären Ausdrücke erlaubt, d.h. das Label muss in der
Syntax `Schlüssel:Wert` exakt so eingegeben werden, wie es heißt, z.B.
`os:windows`. Sobald Sie Gruppen- oder Host-Merkmalsfilter zusätzlich zu
Filtern für Name, Beschreibung, Adresse oder Alias setzen, müssen
erstere explizit angegeben werden, also beispielsweise
`hg: Webserver s: apache`. Was entsprechend **nicht** geht:
`hg: Web.* s: apache`. Hintergrund: Die unterschiedlichen Filter
sprechen unterschiedliche Quellen mit unterschiedlichen Datenstrukturen
und Funktionen an. Freilich können Sie die konkreten Host-Gruppen mit
Muster heraussuchen (`hg: .*server`), um das Ergebnis dann in der
ursprünglichen Suche zu nutzen.
:::

::: paragraph
Im Hintergrund werden aus diesen Suchabfragen
[Livestatus](livestatus.html)-Abfragen erstellt. Aus
`h: localhost s: mem s: cpu h:switch-intern` würde zum Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq
GET services
Cache: reload
Columns: service_description host_name hostgroups servicegroups
Filter: host_name ~~ switch-intern
Filter: host_name ~~ localhost
Or: 2
Filter: service_description ~~ cpu
Filter: service_description ~~ mem
Or: 2
And: 2
Limit: 80

CPU utilization;localhost;;
Memory;localhost;;
CPU load;localhost;;
CPU utilization;myhost;;
Memory;myhost;;
CPU load;myhost;;
```
:::
::::

::: paragraph
Sie sehen in der obigen Livestatus-Abfrage auch den Wert `Limit: 80`.
Das bedeutet, dass die Ergebnisliste maximal 80 Treffer anzeigt. Sie
können diesen Wert jedoch unter [Setup \> Global settings \> User
interface \> Number of elements to show in Quicksearch]{.guihint}
verändern.
:::

::: paragraph
Wenn Sie beim Suchen gar keinen Filter setzen, wird standardmäßig zuerst
in den Einträgen des [Monitor]{.guihint}-Menüs gesucht und anschließend
nacheinander in den Filtern für Host-Name, Host-Alias, Host-Adresse und
Service-Beschreibung --- und zwar in dieser Reihenfolge. Sie können die
Filter und deren Reihenfolge unter [Setup \> Global settings \> User
interface \> Quicksearch search order]{.guihint} anpassen.
:::
:::::::::::::::::::::

::::::::: sect2
### []{#customize_menu .hidden-anchor .sr-only}2.3. Customize-Menü {#heading_customize_menu}

::: paragraph
Die Anpassung und Erweiterung von Elementen der grafischen
Benutzeroberfläche, die für das Monitoring nützlich sind, können Sie im
[Customize]{.guihint}-Menü durchführen:
:::

::::: imageblock
::: content
![Customize-Menü in der
Navigationsleiste.](../images/customize_menu_more.png){width="75%"}
:::

::: title
Das [Customize]{.guihint}-Menü von Checkmk Enterprise im Show-More-Modus
:::
:::::

::: paragraph
Hier haben Sie unter anderem Zugriff auf [Lesezeichen
(*bookmarks*)](#bookmarks), [Tabellenansichten (*views*)](views.html)
und [Dashboards](dashboards.html) --- und in den kommerziellen Editionen
zusätzlich auf [Graphen](graphing.html), [Vorhersagegraphen (*forecast
graphs*)](forecast_graphs.html), [Berichte (*reports*)](reporting.html)
und [erweiterte Verfügbarkeiten (SLA)](sla.html).
:::

::: paragraph
Beim Aufruf eines der Menüeinträge wird Ihnen die Liste der bereits
existierenden Objekte angezeigt. In einigen Listen finden Sie Objekte,
die Checkmk mit ausliefert, und die Sie bearbeiten oder als Vorlage für
Ihre eigenen Objekte verwenden können.
:::
:::::::::

::::::::: sect2
### []{#setup_menu .hidden-anchor .sr-only}2.4. Setup-Menü {#heading_setup_menu}

::: paragraph
Ihr Einstieg in die [Konfiguration von Checkmk](wato.html) ist das
[Setup]{.guihint}-Menü, das Sie über die Navigationsleiste öffnen
können:
:::

::::: imageblock
::: content
![Setup-Menü in der Navigationsleiste.](../images/setup_menu.png)
:::

::: title
Das [Setup]{.guihint}-Menü von Checkmk Raw im Show-Less-Modus
:::
:::::

::: paragraph
In diesem Menü finden Sie die Werkzeuge, mit denen Sie Checkmk
einrichten und konfigurieren können. Das Menü ist nach Themen (*topics*)
untergliedert. Unterhalb jedes Themas finden Sie die Menüeinträge. Bei
[Hosts]{.guihint}, [Services]{.guihint} und [Agents]{.guihint} erhalten
Sie Zugriff auf verschiedene Kategorien der Regelsätze. Das Konzept der
[regelbasierten Konfiguration](wato_rules.html) ist zentral in Checkmk
und sehr leistungsfähig.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Auch den Inhalt des               |
|                                   | [Setup]{.guihint}-Menüs können    |
|                                   | Sie sich in die Seitenleiste      |
|                                   | laden mit dem Snapin [Quick       |
|                                   | setup.]{.guihint}                 |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::

:::::::: sect2
### []{#search_setup .hidden-anchor .sr-only}2.5. Suchen in der Konfigurationsumgebung {#heading_search_setup}

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
::::::::

:::::::: sect2
### []{#user_menu .hidden-anchor .sr-only}2.6. User-Menü {#heading_user_menu}

::: paragraph
Im [User]{.guihint}-Menü können Sie persönliche Einstellungen ändern,
die für Ihr Benutzerkonto gültig sind:
:::

:::: imageblock
::: content
![User-Menü in der
Navigationsleiste.](../images/user_menu.png){width="65%"}
:::
::::

::: paragraph
Häufig verwendete Einstellungen können per Klick direkt im
[User]{.guihint}-Menü umgeschaltet werden ([User interface]{.guihint}),
manche durch Aufruf einer spezifischen Seite, z.B. zum Ändern des
Passworts. Die meisten Einstellungen sind aber zentral über die
Profil-Seite ([Edit profile]{.guihint}) erreichbar und änderbar.
:::

+-----------------------------------+-----------------------------------+
| Einstellung                       | Anmerkung                         |
+===================================+===================================+
| Farbthema ([Color                 | Die Umschaltung zwischen          |
| theme]{.guihint})                 | [Dark]{.guihint} und              |
|                                   | [Light]{.guihint} ist direkt im   |
|                                   | [User]{.guihint}-Menü möglich.    |
+-----------------------------------+-----------------------------------+
| Position der Seitenleiste         | Auch hier kann direkt im          |
| ([Sidebar position]{.guihint})    | [User]{.guihint}-Menü zwischen    |
|                                   | [Right]{.guihint} und             |
|                                   | [Left]{.guihint} umgeschaltet     |
|                                   | werden.                           |
+-----------------------------------+-----------------------------------+
| Sprache der Benutzeroberfläche    | Sie können zwischen den offiziell |
| ([Language]{.guihint})            | von Checkmk unterstützten         |
|                                   | Sprachen Deutsch und Englisch     |
|                                   | wählen. Außerdem werden           |
|                                   | standardmäßig die von der         |
|                                   | Community                         |
|                                   | [übersetzten](https://transla     |
|                                   | te.checkmk.com/){target="_blank"} |
|                                   | Sprachen zur Auswahl angeboten.   |
|                                   | Die Sichtbarkeit der Einträge im  |
|                                   | Menü [Language]{.guihint} können  |
|                                   | Sie in [Setup \> Global settings  |
|                                   | \> User interface \> Enable       |
|                                   | community translated languages    |
|                                   | (not supported)]{.guihint}        |
|                                   | einstellen.                       |
+-----------------------------------+-----------------------------------+
| Einheit der Temperatur            | Sie können zwischen Celsius und   |
| ([Temperature unit]{.guihint})    | Fahrenheit wählen für die Anzeige |
|                                   | in Graphen und Perf-O-Metern.     |
+-----------------------------------+-----------------------------------+
| Sichtbarkeit von Hosts und        | Alle Hosts und Services anzeigen  |
| Services ([Visibility of          | oder nur die, denen Sie als       |
| hosts/services]{.guihint})        | Kontakt zugewiesen sind.          |
+-----------------------------------+-----------------------------------+
| Benachrichtigungen ausschalten    | Alle Benachrichtigungen           |
| ([Disable                         | abschalten für einen auswählbaren |
| notifications]{.guihint})         | Zeitraum.                         |
+-----------------------------------+-----------------------------------+
| Startseite ([Start URL to display | URL der Startseite festlegen.     |
| in main frame]{.guihint})         | Wird auf der Hauptseite ein       |
|                                   | [Dashboard](#dashboards)          |
|                                   | angezeigt, können Sie dieses      |
|                                   | alternativ über das Menü          |
|                                   | [Dashboard]{.guihint} zur         |
|                                   | Startseite machen.                |
+-----------------------------------+-----------------------------------+
| Symbole in der Navigationsleiste  | Symbole mit Titel oder nur        |
| ([Navigation bar                  | Symbole anzeigen.                 |
| icons]{.guihint})                 |                                   |
+-----------------------------------+-----------------------------------+
| Symbole in den Mega-Menüs ([Mega  | (Grüne) Symbole beim Thema oder   |
| menu icons]{.guihint})            | (farbige) Symbole bei jedem       |
|                                   | Menüeintrag anzeigen.             |
+-----------------------------------+-----------------------------------+
| Weniger oder mehr anzeigen ([Show | Standardmäßig [weniger oder       |
| more / Show less]{.guihint})      | meh                               |
|                                   | r](intro_gui.html#show_less_more) |
|                                   | oder stets alles anzeigen.        |
+-----------------------------------+-----------------------------------+
| Benachrichtigungsregeln           | Regeln zu [benutzerdefinierten    |
| ([Notification rules]{.guihint})  | Benachrichtigung                  |
|                                   | en](notifications.html#personal). |
+-----------------------------------+-----------------------------------+
| Passwort ändern ([Change          | Sie müssen das bestehende         |
| password]{.guihint})              | Passwort einmal und das neue      |
|                                   | Passwort zweimal eingeben.        |
|                                   | Passwort-Anforderungen für lokale |
|                                   | Konten können global gesetzt      |
|                                   | werden: [Setup \> Global settings |
|                                   | \> Password policy for local      |
|                                   | accounts]{.guihint}               |
+-----------------------------------+-----------------------------------+
| Zwei-Faktor-Authentifizierung     | Aktivierung der erhöhten          |
| ([Two-factor                      | Sicherheit durch                  |
| authentication]{.guihint})        | [Zwei-Faktor-Authen               |
|                                   | tifizierung.](wato_user.html#2fa) |
+-----------------------------------+-----------------------------------+
| Abmelden ([Logout]{.guihint})     | Nur direkt im                     |
|                                   | [User]{.guihint}-Menü möglich.    |
+-----------------------------------+-----------------------------------+

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Für einige Einstellungen gibt es  |
|                                   | Default-Werte, die global per     |
|                                   | [Setup \> Global                  |
|                                   | settings]{.guihint} für alle      |
|                                   | Benutzer geändert werden können,  |
|                                   | meist unter dem Thema [User       |
|                                   | Interface.]{.guihint} Außerdem    |
|                                   | bestimmt die Ihrem Benutzerkonto  |
|                                   | zugewiesene [Rolle mit ihren      |
|                                   | Berec                             |
|                                   | htigungen,](wato_user.html#roles) |
|                                   | ob bestimmte Einstellungen        |
|                                   | sichtbar sind und geändert werden |
|                                   | können.                           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::: sect1
## []{#main_page .hidden-anchor .sr-only}3. Hauptseite {#heading_main_page}

:::::::::::::::::::::::::::::: sectionbody
::: paragraph
Was Sie auf der Hauptseite sehen, hängt davon ab, wo Sie in Checkmk
gerade unterwegs sind. Nach der Anmeldung sehen Sie zunächst das
Standard- oder Haupt-Dashboard.
:::

::: paragraph
Der Inhalt der Hauptseite ändert sich abhängig von Ihrer Auswahl in der
Navigationsleiste oder auch der Seitenleiste. Wenn Sie zum Beispiel im
[Monitor]{.guihint}-Menü [Hosts \> All hosts]{.guihint} auswählen, wird
Ihnen auf der Hauptseite die Liste der Hosts angezeigt:
:::

:::: imageblock
::: content
![Hauptseite mit Liste aller Hosts.](../images/mainpage_all_hosts.png)
:::
::::

::: paragraph
Unabhängig davon, welche Seite aktuell angezeigt wird, finden Sie auf
der Hauptseite in der Regel die folgenden Elemente:
:::

::: ulist
- „Breadcrumb"-Pfad: Unterhalb des Seitentitels sehen Sie den Pfad zur
  aktuellen Seite, stets beginnend mit dem Namen des Menüs aus der
  Navigationsleiste. Diese „Brotkrumen" verhindern, dass Sie sich in der
  Oberfläche verirren. So wissen Sie auch nach komplexen Aktionen, wo
  Sie sich in Checkmk gerade befinden --- momentan also auf der Seite
  [All hosts]{.guihint} im Monitoring.

- Menüleiste: Unterhalb des Breadcrumb-Pfads wird die Menüleiste
  angezeigt, die die möglichen Aktionen auf dieser Seite in Menüs und
  Menüeinträgen zusammenfasst. Die Menüs sind in Checkmk stets
  kontext-spezifisch, d.h. sie finden nur Menüeinträge für Aktionen, die
  sinnvoll auf der aktuellen Seite sind.
:::

::: {#inline_help .ulist}
- Inline-Hilfe (*inline help*): Sie können per [Help]{.guihint}-Menü auf
  der aktuellen Seite kontext-sensitiv Hilfetexte einblenden lassen mit
  [Help \> Show inline help]{.guihint}, was sehr hilfreich ist auf
  Seiten, die viele Parameter enthalten. Der gewählte Modus bleibt aktiv
  auch für weitere Seiten, die Sie aufrufen, bis Sie ihn wieder
  deaktivieren.

- Aktionsleiste: Unter der Menüleiste finden Sie die Aktionsleiste, in
  der die wichtigsten Aktionen aus den Menüs als Knöpfe zum direkten
  Anklicken angeboten werden. Die Aktionsleiste können Sie mit dem Knopf
  [![Symbol zum Ausblenden der
  Aktionsleiste.](../images/icons/button_hide_toolbar.png)]{.image-inline}
  rechts neben dem [Help]{.guihint}-Menü ausblenden und mit [![Symbol
  zum Einblenden der
  Aktionsleiste.](../images/icons/button_show_toolbar.png)]{.image-inline}
  wieder einblenden. Bei ausgeblendeter Aktionsleiste werden Symbole für
  die ausgeblendeten Knöpfe rechts neben dem [Help]{.guihint}-Menü
  hinzugefügt.

- Countdown für die Seitenaktualisierung: In der Monitoring-Umgebung
  wird in der Kopfzeile rechts oben das Aktualisierungsintervall für die
  Seite in Sekunden angezeigt und auf der umgebenden Kreislinie wird die
  verbleibende Zeit zur nächsten Aktualisierung visualisiert.

  ::: paragraph
  Das Aktualisierungsintervall können Sie übrigens ändern im Menü
  [Display \> Modify display options]{.guihint}.
  :::

- Ausstehende Änderungen: In der Monitoring-Umgebung zeigt das gelbe
  Symbol unter dem Countdown an, *dass* es noch nicht aktivierten
  Änderungen gibt. In der Konfigurationsumgebung wird rechts oben auf
  der Seite statt des Countdowns die Zahl der ausstehenden Änderungen
  angezeigt. Erst mit der Aktivierung wird eine in der
  Konfigurationsumgebung durchgeführte Änderung in die
  Monitoring-Umgebung übernommen.
:::

::: paragraph
Nach Auswahl eines der Einträge im [Monitor]{.guihint}-Menü wird Ihnen
auf der Hauptseite die angeforderte Information in der Regel entweder
als [Dashboard](#dashboards) oder als [View](#views) angezeigt, auf die
wir in den folgenden Kapiteln näher eingehen werden.
:::

:::::::::::: sect2
### []{#dashboards .hidden-anchor .sr-only}3.1. Dashboards {#heading_dashboards}

::: paragraph
Ein Dashboard bereitet auf einer Seite die wichtigsten Informationen zu
einem Thema auf, etwa die Antwort auf die Frage \"Wie ist der Zustand
meiner Checkmk-Instanz?\". Dabei werden in einem Dashboard verschiedene
Visualisierungen von Daten genutzt und kombiniert, etwa Ansichten,
Verlaufsgraphen, Tabellen, Diagramme und viele andere Elemente. Ziel ist
es, Ihnen die Informationen aus verschiedenen Perspektiven so zu
präsentieren, dass Sie das Wesentliche schnell erfassen können und nicht
von Details abgelenkt werden.
:::

::: paragraph
Checkmk stellt mehrere vorkonfigurierte Dashboards zur Verfügung, die
Sie über das [Monitor]{.guihint}-Menü öffnen können: das
[Main]{.guihint} und das [Checkmk]{.guihint} dashboard.
:::

::::: imageblock
::: content
![Das \'Main\' Dashboard der Checkmk
Raw.](../images/gui_dashboard_main_cre.png)
:::

::: title
Das [Main dashboard]{.guihint} der Checkmk Raw
:::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen haben ein anderes [Main]{.guihint} Dashboard als Checkmk Raw.
Das [Main]{.guihint} Dashboard von Checkmk Raw ist das
[Problem]{.guihint} Dashboard der kommerziellen Editionen.
:::

::: paragraph
Wird eines dieser Dashboards angezeigt, können Sie schnell zu einem
anderen umschalten: in der Menüleiste rechts neben dem
[Help]{.guihint}-Menü finden Sie die Symbole für die verfügbaren
Dashboards. Sie können auch das aktuell angezeigte Dashboard zur
Startseite befördern: im Menü [Dashboard \> Set as start URL]{.guihint}.
:::

::: paragraph
Das Besondere an den Dashboards in Checkmk ist, dass sie sich mit einem
intelligenten Algorithmus automatisch an die Bildschirmdimensionen
anpassen und die Bildschirmgröße optimal ausnutzen.
:::

::: paragraph
Außerdem können Sie die Einzelteile eines Dashboards, die sogenannten
**Dashlets**, nutzen, um bestehende Dashboards anzupassen und neue zu
erstellen. Im [Artikel zu den Dashboards](dashboards.html) erfahren Sie
dazu alle Details.
:::
::::::::::::

::::::::::: sect2
### []{#views .hidden-anchor .sr-only}3.2. Tabellenansichten (views) {#heading_views}

::: paragraph
Eine Tabellenansicht (*view*) zeigt Ihnen im Monitoring den aktuellen
Zustand von Hosts, Services oder auch anderen Objekten unter einer
bestimmten Perspektive als vordefinierte Tabelle an.
:::

::: paragraph
So eine Tabellenansicht (oder kurz Ansicht) kann einen Kontext haben,
z.B. wenn sie alle Services des Hosts `localhost` zeigt. Andere
Ansichten funktionieren global, z.B. diejenige, die Ihnen alle Services
anzeigt, die gerade ein Problem haben.
:::

::: paragraph
All die **globalen** Ansichten können Sie aus dem
[Monitor]{.guihint}-Menü öffnen, unterhalb des jeweiligen Themas, z.B.
[All hosts]{.guihint}, [Service problems]{.guihint} oder [Host & service
events.]{.guihint} Nach Anklicken eines dieser Menüeinträge wird Ihnen
die zugehörige Statusansicht in der Hauptseite angezeigt, im folgenden
Beispiel [Service problems]{.guihint}:
:::

:::: imageblock
::: content
![Tabellenansicht \'Service
problems\'.](../images/gui_view_service_problems.png)
:::
::::

::: paragraph
In einer Tabellenansicht haben Sie zahlreiche Bedienmöglichkeiten, unter
anderem:
:::

::: ulist
- Sie können zu anderen Ansichten navigieren, indem Sie bestimmte Zellen
  anklicken (im obigen Beispiel etwa den Host-Namen oder einen der
  Services).

- Durch einen Klick auf einen Spaltentitel können Sie nach dieser Spalte
  sortieren.

- Das Menü [Display \> Modify display options]{.guihint} blendet einige
  Einstellungen ein zur Anpassung der Ansicht: Mit [Entries per
  row]{.guihint} können auswählen, in wie vielen Tabellen die Objekte in
  der Ansicht nebeneinander angezeigt werden (z.B. um Ihren breiten
  Bildschirm voll auszunutzen). Im obigen Beispiel steht der Wert auf
  `1`. Mit [Refresh interval]{.guihint} stellen Sie die Anzahl an
  Sekunden ein, nach denen die Ansicht automatisch neu geladen wird
  (schließlich können sich Statusdaten jederzeit ändern).

- Sie können die Tabelleneinträge nach Anklicken von [Filter]{.guihint}
  mit der **Filterleiste** reduzieren --- was im gezeigten Beispiel
  nicht wirklich notwendig, aber bei langen Tabellen sehr hilfreich ist.
:::

::: paragraph
Die Tabellenansichten haben noch viele weitere Möglichkeiten --- zur
Anpassung und zur Erstellung eigener Ansichten. Wie das geht, erfahren
Sie im [Artikel über Ansichten.](views.html)
:::
:::::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#sidebar .hidden-anchor .sr-only}4. Seitenleiste {#heading_sidebar}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
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

:::::::::::::::: sect2
### []{#overview .hidden-anchor .sr-only}4.1. Overview {#heading_overview}

::: paragraph
Prominent oben in der Seitenleiste platziert finden Sie das Snapin
[Overview]{.guihint}:
:::

::::: imageblock
::: content
![Snapin Overview im
Show-less-Modus.](../images/gui_overview_less.png){width="50%"}
:::

::: title
Das Snapin [Overview]{.guihint} im Show-less-Modus
:::
:::::

::: paragraph
In der linken Spalte dieser kleinen Tabelle sehen Sie zunächst die
Anzahl Ihrer überwachten Hosts und Services. Die dritte Zeile zeigt
[Events]{.guihint}. Diese werden für Sie erst dann relevant, wenn Sie
eine Überwachung von Meldungen konfiguriert haben. Damit sind z.B.
Meldungen aus Syslog, SNMP-Traps und Log-Dateien gemeint. Dafür hat
Checkmk ein eigenes, sehr mächtiges Modul, das ausführlich besprochen
wird im gleichnamigen Artikel zur [Event Console.](ec.html)
:::

::: paragraph
Die rechte Spalte zeigt die Zahl der Probleme, die noch nicht quittiert
wurden. Probleme sind Objekte, die gerade im Status
[WARN]{.state1}/[CRIT]{.state2}/[UNKNOWN]{.state3} bzw.
[DOWN]{.hstate1}/[UNREACH]{.hstate2} sind. Die Quittierung
(*acknowledgment*) ist eine Art „zur Kenntnisnahme" eines Problems.
Übrigens werden Probleme von Services hier nicht mitgezählt, deren Host
[DOWN]{.hstate1} oder in einer
[Wartungszeit](glossar.html#scheduled_downtime) ist.
:::

::: paragraph
Sie können auf die Zahl in der Zelle klicken und kommen dann direkt zu
einer Liste der Objekte, die hier gezählt wurden. Das funktioniert
übrigens bei allen Zellen im [Overview.]{.guihint}
:::

::: paragraph
Auch im [Overview]{.guihint} können Sie entscheiden, ob Sie weniger oder
mehr Informationen sehen wollen. Mit dem Knopf [![Symbol zum Wechsel in
den
Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline}
schalten Sie in den Show-more-Modus:
:::

::::: imageblock
::: content
![Snapin Overview im
Show-more-Modus.](../images/overview_more.png){width="50%"}
:::

::: title
Das Snapin [Overview]{.guihint} im Show-more-Modus
:::
:::::

::: paragraph
Zwischen den beiden zuvor sichtbaren Spalten zeigt jetzt die neue zweite
Spalte die Zahl **aller** Probleme, d.h. zusätzlich auch diejenigen, die
bereits quittiert wurden. In unserem Beispiel sind die Zahlen in der
zweiten und dritten Spalte identisch, da wir noch kein Problem quittiert
haben.
:::

::: paragraph
Schließlich zeigt die letzte Spalte ganz rechts die Hosts oder Services,
deren Information „veraltet" (*stale*) ist, da über sie zurzeit keine
aktuellen Monitoring-Daten vorliegen. Wenn z.B. ein Host aktuell gar
nicht erreichbar ist, kann Checkmk auch keine Neuigkeiten über dessen
Services ermitteln. Das bedeutet aber nicht automatisch, dass diese ein
Problem haben. Deswegen nimmt Checkmk nicht einfach einen neuen Status
für diese Services an, sondern setzt sie auf den Pseudostatus „Stale".
Die Spalte [Stale]{.guihint} wird von Checkmk weggelassen, wenn sie
überall `0` zeigen würde.
:::
::::::::::::::::

::::::::::::::::::::::::::::::: sect2
### []{#bookmarks .hidden-anchor .sr-only}4.2. Bookmarks {#heading_bookmarks}

::: paragraph
Für Seiten, die Sie immer wieder aufsuchen, können Sie in der
Seitenleiste mit dem Snapin [Bookmarks]{.guihint} Lesezeichen anlegen.
:::

::: paragraph
Braucht man die wirklich? Immerhin gibt es ja auch Lesezeichen im
Webbrowser. Nun, die Checkmk-Lesezeichen haben ein paar Vorteile:
:::

::: ulist
- Ein aufgerufenes Lesezeichen ändert nur den Inhalt auf der Hauptseite,
  ohne die Seitenleiste neu zu laden.

- Sie können Lesezeichen mit anderen Benutzern teilen.

- Beim Setzen von Lesezeichen wird automatisch das Wiederausführen von
  Aktionen verhindert.
:::

::: paragraph
Am Anfang ist das Snapin [Bookmarks]{.guihint} noch leer:
:::

:::: imageblock
::: content
![Snapin Bookmarks noch ohne
Lesezeichen.](../images/gui_empty_bookmarks.png){width="50%"}
:::
::::

::: paragraph
Wenn Sie nun auf [Add bookmark]{.guihint} klicken, wird für den Inhalt,
der gerade auf der Hauptseite angezeigt wird, ein neues Lesezeichen
erzeugt:
:::

:::: imageblock
::: content
![Snapin Bookmarks mit einem
Lesezeichen.](../images/gui_bookmarks.png){width="50%"}
:::
::::

::: paragraph
Ihre persönlichen Lesezeichen werden unter [My Bookmarks]{.guihint}
gespeichert.
:::

:::::::::::::::::::: sect3
#### []{#bookmarks_edit .hidden-anchor .sr-only}Lesezeichen bearbeiten {#heading_bookmarks_edit}

::: paragraph
Checkmk verwaltet Lesezeichen als **Listen**. Jede Liste enthält ein
oder mehrere Lesezeichen. Zudem ist jedem Lesezeichen ein Thema
(*topic*) zugeordnet. Im Snapin [Bookmarks]{.guihint} werden dann alle
Lesezeichen zum gleichen Thema gesammelt.
:::

::: paragraph
Warum so kompliziert? Nun, Sie können eine Liste von Lesezeichen für
andere Benutzer sichtbar machen. Dann können Sie mit den Themen
festlegen, wie die Lesezeichen den anderen Benutzern im Snapin
[Bookmarks]{.guihint} präsentiert werden. So können Sie für Ihre Firma
eine Navigationsstruktur zu ausgewählten Checkmk-Seiten und sogar zu
externen Seiten aufbauen. Trotzdem kann jeder Benutzer zusätzlich eigene
Lesezeichen erstellen und verwalten.
:::

::: paragraph
In die Verwaltung der Lesezeichenlisten steigen Sie im Snapin
[Bookmarks]{.guihint} mit dem Knopf [Edit]{.guihint} ein:
:::

:::: imageblock
::: content
![Lesezeichenliste.](../images/user_interface_bookmark_lists.png)
:::
::::

::: paragraph
Sie können nun entweder mit [![Symbol zum Bearbeiten eines
Listeneintrags.](../images/icons/icon_edit.png)]{.image-inline} eine
bestehende Liste bearbeiten --- oder mit [Add list]{.guihint} eine neue
anlegen:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften beim Erstellen einer
Lesezeichenliste.](../images/user_interface_new_bookmark_list_general_properties.png)
:::
::::

::: paragraph
Im Kasten [General Properties]{.guihint} geben Sie die interne ID und
den Titel der Liste ein, wobei der [Title]{.guihint} für die Darstellung
der Lesezeichen unwichtig ist: er dient nur der internen Verwaltung. Mit
[Make this Bookmark list available for other users]{.guihint} machen Sie
die Lesezeichen dieser Liste für andere Benutzer sichtbar. Dafür
benötigt Ihr aktuelles Benutzerkonto allerdings eine Berechtigung, die
standardmäßig nur die [Rolle](wato_user.html#roles) `admin` besitzt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das Prinzip der Sichtbarkeit wird |
|                                   | bei Checkmk an vielen Stellen     |
|                                   | verwendet und im Artikel über die |
|                                   | [Ansichten](views.html#edit)      |
|                                   | näher erklärt.                    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Im Kasten [Bookmarks]{.guihint} können Sie nun die neuen Lesezeichen mit
Titel und URL festlegen:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Eigenschaften für die neuen
Lesezeichen.](../images/user_interface_new_bookmark_list_bookmarks.png)
:::
::::

::: paragraph
Wo die Lesezeichen einsortiert werden, entscheidet das [Default
Topic]{.guihint} in der Liste bzw. das [Individual Topic]{.guihint} bei
einem einzelnen Lesezeichen  ---  falls dies gesetzt ist. Sie können
übrigens den Lesezeichen auch eigene Icons verpassen. Sichern Sie
abschließend die neue Liste mit [Save & go to list.]{.guihint}
:::

::: paragraph
Die im Beispiel erstellte neue Liste ergänzt nun für alle Benutzer die
persönlichen Lesezeichen unter [My Bookmarks]{.guihint} mit drei
Lesezeichen zu zwei neuen Themen:
:::

:::: imageblock
::: content
![Snapin Bookmarks mit den drei neu erstellten
Lesezeichen.](../images/user_interface_bookmarks.png){width="50%"}
:::
::::
::::::::::::::::::::
:::::::::::::::::::::::::::::::

:::::::: sect2
### []{#master_control .hidden-anchor .sr-only}4.3. Master control {#heading_master_control}

::: paragraph
Im Snapin [Master control]{.guihint} der Seitenleiste können Sie
verschiedene Funktionen des Monitorings einzeln aus- und wieder
einschalten, wie z.B. die Benachrichtigungen
([Notifications]{.guihint}). Letzteres ist sehr nützlich, wenn Sie am
System größere Umbauarbeiten vornehmen und Ihre Kolleginnen nicht mit
sinnlosen Meldungen ärgern möchten.
:::

::::: imageblock
::: content
![Snapin Master control von Checkmk
Raw.](../images/gui_master_control.png){width="50%"}
:::

::: title
Das Snapin [Master control]{.guihint} von Checkmk Raw
:::
:::::

::: paragraph
**Wichtig:** Achten Sie darauf, dass im Normalbetrieb alle Schalter
eingeschaltet sind, da sonst wichtige Funktionen des Monitorings
ausgeschaltet sein können.
:::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
