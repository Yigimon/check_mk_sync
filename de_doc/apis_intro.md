:::: {#header}
# Übersicht der API-Ressourcen

::: details
[Last modified on 14-Oct-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/apis_intro.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::: {#content}
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
[Erweiterungen für Checkmk entwickeln](devel_intro.html) [Die Checkmk
REST-API](rest_api.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::::::::::: sectionbody
::: paragraph
Checkmk bietet mittlerweile eine ganze Menge unterschiedlicher
Schnittstellen, allen voran die REST-API, mit der Sie sehr viel von dem
erledigen können, was auch über die Weboberfläche möglich ist. Darüber
hinaus gibt es jedoch noch APIs für
[Check-Plugins,](glossar.html#check_plugin) die
Hardware-/Software-Inventur, die
[Agentenbäckerei](glossar.html#agent_bakery) und so weiter. Zu all
diesen Schnittstellen gibt es Artikel, Referenzen und weitere
Ressourcen, verteilt über dieses Handbuch, die Website und Checkmk
selbst.
:::

::: paragraph
In diesem Artikel verschaffen wir Ihnen einen Überblick über alle
Schnittstellen und Ressourcen und geben einige Tipps zum generellen
Umgang. Viele Links in diesem Artikel sind redundant, da die
Informationen drei unterschiedliche Herangehensweisen oder Fragen
bedienen sollen:
:::

::: ulist
- Welche APIs bietet Checkmk?

- Welche API-relevanten Artikel finden sich im Handbuch?

- Welche API-relevanten Ressourcen gibt es in Checkmk?
:::

::: paragraph
Die wichtigste Schnittstelle ist fraglos die [Checkmk
REST-API](rest_api.html), über die sich fast alles programmatisch
erledigen lässt, was auch über die Weboberfläche geht.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Einen schnellen, praktischen      |
|                                   | Einstieg in die REST-API bietet   |
|                                   | die interaktive REST-API GUI.     |
|                                   | Hier können Sie vorgegebene       |
|                                   | Abfragen absenden und optional    |
|                                   | auch manipulieren. Sie finden die |
|                                   | GUI in Checkmk selbst über [Help  |
|                                   | \> Developer resources \> REST    |
|                                   | API interactive GUI.]{.guihint}   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::: {.imageblock .border}
::: content
![REST-API GUI mit Beispiel zum Erstellen eines
Hosts.](../images/restapi_swaggerui.png)
:::

::: title
Interaktive Weboberfläche der REST-API
:::
:::::

::: paragraph
Die zweite große Schnittstelle sind die *Plugin-APIs* für die
Entwicklung eigener Erweiterungen. Je nach Erfahrung können Sie hier mit
unserem [Einführungsartikel](devel_intro.html) starten oder der
Referenz, die Sie wieder direkt in Checkmk selbst finden: [Help \>
Developer resource \> Plug-in API references.]{.guihint}
:::

::::: {.imageblock .border}
::: content
![Bild der API-Referenz mit Versionshinweisen zur
Check-API.](../images/devel_cpi_checkapi_doc.png)
:::

::: title
Referenz der Plugin-APIs samt Versionshinweisen für die Check-API
:::
:::::

::: paragraph
In den Tabellen unten finden Sie diese APIs, aber auch weniger
prominente Schnittstellen, wie etwa für das Hardware-/Software-Inventar,
Sub-Schnittstellen für die Check-Plugin-Entwicklung, wie etwa die
explizite Graphing-API, sowie *Quasi-Schnittstellen,* wie das
Ausgabeformat von [lokalen Checks](localchecks.html), der simplen,
Skript-basierten Vorstufe ausgewachsener Plugins.
:::
::::::::::::::::
:::::::::::::::::

:::: sect1
## []{#apis .hidden-anchor .sr-only}2. APIs in Checkmk {#heading_apis}

::: sectionbody
+-------+-----------+-----------------+-------------------------------+
| API   | Handbuch  | Web             | Beschreibung                  |
+=======+===========+=================+===============================+
| RES   | [Die      | [REST-          | Funktional eine Teilmenge der |
| T-API | Checkmk   | API-Code-Beispi | Weboberfläche.                |
|       | REST-A    | ele](https://ch |                               |
|       | PI](rest_ | eckmk.atlassian |                               |
|       | api.html) | .net/wiki/space |                               |
|       |           | s/KB/pages/9473 |                               |
|       |           | 812/REST-API+co |                               |
|       |           | de+examples){ta |                               |
|       |           | rget="_blank"}, |                               |
|       |           | [Video-Tut      |                               |
|       |           | orial](https:// |                               |
|       |           | checkmk.com/vid |                               |
|       |           | eos/en/ep-46-wo |                               |
|       |           | rking-with-chec |                               |
|       |           | kmk-rest-api){t |                               |
|       |           | arget="_blank"} |                               |
+-------+-----------+-----------------+-------------------------------+
| Chec  | [Agente   | [Checkmk        | Programmieren von             |
| k-API | nbasierte | Exchange        | Check-Plugins.                |
|       | Chec      | (Beispiele)](ht |                               |
|       | k-Plugins | tps://exchange. |                               |
|       | schreiben | checkmk.com/){t |                               |
|       | ](devel_c | arget="_blank"} |                               |
|       | heck_plug |                 |                               |
|       | ins.html) |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| Baker | [Die      | In Checkmk:\    | Einbinden von Check-Plugins   |
| y-API | B         | [Help \>        | in die Agentenbäckerei.       |
|       | akery-API | Developer       |                               |
|       | ](bakery_ | resources \>    |                               |
|       | api.html) | Plug-in API     |                               |
|       |           | references \>   |                               |
|       |           | Ba              |                               |
|       |           | kery]{.guihint} |                               |
+-------+-----------+-----------------+-------------------------------+
| S     | tbd       | In Checkmk:\    | Entwickeln von [aktiven       |
| erver |           | [Help \>        | Check                         |
| -side |           | Developer       | s](glossar.html#active_check) |
| -call |           | resources \>    | und                           |
| s-API |           | Plug-in API     | [Spezialagenten.              |
|       |           | references \>   | ](glossar.html#special_agent) |
|       |           | Server-side     |                               |
|       |           | c               |                               |
|       |           | alls]{.guihint} |                               |
+-------+-----------+-----------------+-------------------------------+
| Gr    | [Da       | In Checkmk:\    | Einbinden von                 |
| aphin | rstellung | [Help \>        | [Me                           |
| g-API | von       | Developer       | triken,](glossar.html#metric) |
|       | Metriken  | resources \>    | Graphen, Perf-O-Metern.       |
|       | anpasse   | Plug-in API     |                               |
|       | n](devel_ | references \>   |                               |
|       | check_plu | Grap            |                               |
|       | gins.html | hing]{.guihint} |                               |
|       | #metrics_ |                 |                               |
|       | advanced) |                 |                               |
|       | im        |                 |                               |
|       | Artikel   |                 |                               |
|       | über      |                 |                               |
|       | agente    |                 |                               |
|       | nbasierte |                 |                               |
|       | Chec      |                 |                               |
|       | k-Plugins |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| Ru    | [R        | In Checkmk:\    | Entwickeln eigener            |
| leset | egelsätze | [Help \>        | [Regels                       |
| s-API | für       | Developer       | ätze.](glossar.html#rule_set) |
|       | Check-    | resources \>    |                               |
|       | Parameter | Plug-in API     |                               |
|       | ](devel_c | references \>   |                               |
|       | heck_plug | Rule            |                               |
|       | ins.html# | sets]{.guihint} |                               |
|       | rule_set) |                 |                               |
|       | im        |                 |                               |
|       | Artikel   |                 |                               |
|       | über      |                 |                               |
|       | agente    |                 |                               |
|       | nbasierte |                 |                               |
|       | Chec      |                 |                               |
|       | k-Plugins |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| DC    | tbd       | In Checkmk:\    | Eigene Konnektoren für den    |
| D-API |           | [Help \>        | Dynamic Configuration Daemon  |
|       |           | Developer       | (DCD).                        |
|       |           | resources \>    |                               |
|       |           | Plug-in API     |                               |
|       |           | references \>   |                               |
|       |           | Dynamic         |                               |
|       |           | configuration   |                               |
|       |           | conne           |                               |
|       |           | ctor]{.guihint} |                               |
+-------+-----------+-----------------+-------------------------------+
| HW/S  | [Web-API  | n.a.            | Web-API zur Abfrage von       |
| W-API | für       |                 | Inventurdaten.                |
|       | HW/SW-Inv |                 |                               |
|       | enturdate |                 |                               |
|       | n](invent |                 |                               |
|       | ory.html# |                 |                               |
|       | external) |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| Lives | [St       | n.a.            | Direkter Abruf von            |
| tatus | atusdaten |                 | Statusdaten via Livestatus    |
|       | abrufen   |                 | Query Language (LQL).         |
|       | via       |                 |                               |
|       | Li        |                 |                               |
|       | vestatus] |                 |                               |
|       | (livestat |                 |                               |
|       | us.html), |                 |                               |
|       | [L        |                 |                               |
|       | ivestatus |                 |                               |
|       | Befehlsr  |                 |                               |
|       | eferenz]( |                 |                               |
|       | livestatu |                 |                               |
|       | s_referen |                 |                               |
|       | ces.html) |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| Ev    | [Die      | n.a.            | Zugriff auf interne Status    |
| ent-C | Statussch |                 | und Ausführen von Befehlen    |
| onsol | nittstell |                 | via Unix-Socket.              |
| e-Sch | e](ec.htm |                 |                               |
| nitts | l#statusi |                 |                               |
| telle | nterface) |                 |                               |
|       | der Event |                 |                               |
|       | Console   |                 |                               |
+-------+-----------+-----------------+-------------------------------+
| L     | [Lokale   | n.a.            | \"Mini-Schnittstelle\" für    |
| okale | Checks]   |                 | eigene, Skript-basierte       |
| C     | (localche |                 | Checks.                       |
| hecks | cks.html) |                 |                               |
+-------+-----------+-----------------+-------------------------------+
:::
::::

:::: sect1
## []{#docs .hidden-anchor .sr-only}3. Artikel im Handbuch {#heading_docs}

::: sectionbody
+-------+-------------------+------------------------------------------+
| A     | Handbuch          | Beschreibung                             |
| PI-Be |                   |                                          |
| reich |                   |                                          |
+=======+===================+==========================================+
| Autom | [Die Checkmk      | Beschreibung der REST-API sowie deren    |
| atisi | REST-AP           | Dokumentation und Nutzungsmöglichkeiten. |
| erung | I](rest_api.html) |                                          |
+-------+-------------------+------------------------------------------+
|       | [Statusdaten      | Die Daten-Schnittstelle für Host- und    |
|       | abrufen via       | Service-Informationen in der Übersicht.  |
|       | Livestatus]       |                                          |
|       | (livestatus.html) |                                          |
+-------+-------------------+------------------------------------------+
|       | [Live             | Alle Tabellen, Header, Filter und        |
|       | status-Befehlsref | Operatoren.                              |
|       | erenz](livestatus |                                          |
|       | _references.html) |                                          |
+-------+-------------------+------------------------------------------+
|       | [Web-API für      | Beschreibung der Inventar-eigenen        |
|       | HW/SW-Inven       | Web-API für den externen Zugriff.        |
|       | turdaten](invento |                                          |
|       | ry.html#external) |                                          |
+-------+-------------------+------------------------------------------+
|       | [Die              | Per Unix-Socket und über eine Teilmenge  |
|       | Statusschni       | des Livestatus-Protokolls können Daten   |
|       | ttstelle](ec.html | von der Event Console ausgelesen und     |
|       | #statusinterface) | Kommandos abgesetzt werden.              |
|       | der Event Console |                                          |
+-------+-------------------+------------------------------------------+
| Prog  | [Erweiterungen    | Übersichtsartikel mit allen              |
| rammi | für Checkmk       | Möglichkeiten für Erweiterungen und      |
| erung | entwickeln](      | Links zu weiterführenden Informationen.  |
|       | devel_intro.html) |                                          |
+-------+-------------------+------------------------------------------+
|       | [Agentenbasierte  | Ausführliche Beschreibung zur            |
|       | Check-Plugins     | Entwicklung eines Check-Plugins.         |
|       | sc                |                                          |
|       | hreiben](devel_ch |                                          |
|       | eck_plugins.html) |                                          |
+-------+-------------------+------------------------------------------+
|       | [SNMP-basierte    | Ausführliche Beschreibung zur            |
|       | Check-Plugins     | Entwicklung eines Check-Plugins für      |
|       | schreib           | SNMP-Daten.                              |
|       | en](devel_check_p |                                          |
|       | lugins_snmp.html) |                                          |
+-------+-------------------+------------------------------------------+
:::
::::

:::: sect1
## []{#resources .hidden-anchor .sr-only}4. Ressourcen in Checkmk {#heading_resources}

::: sectionbody
+---------------------------+------------------------------------------+
| In Checkmk                | Beschreibung                             |
+===========================+==========================================+
| [Help \> Developer        | Auf Sphinx basierende Referenz aller     |
| resources \> Plug-in API  | APIs, die für die Entwicklung von        |
| references]{.guihint}     | Check-Plugins relevant sind.             |
+---------------------------+------------------------------------------+
| [Help \> Developer        | Auf ReDoc/OpenAPI basierende Referenz    |
| resources \> REST API     | für alle Check-relevanten Abfragen,      |
| documentation]{.guihint}  | inklusive Code-Beispielen für Requests   |
|                           | (Python), Urllib (Python), Httpie und    |
|                           | Curl.                                    |
+---------------------------+------------------------------------------+
| [Help \> Developer        | Interaktive Weboberfläche zum Testen     |
| resources \> REST API     | aller API-Endpunkte, inklusive           |
| interactive               | Rückmeldungen direkt auf der Seite.      |
| GUI]{.guihint}            |                                          |
+---------------------------+------------------------------------------+
| [Help \> Developer        | Im Bereich [Version 2 \> New in this     |
| resources \> Plug-in API  | version]{.guihint} finden Sie wichtige   |
| references \> Agent based | Informationen für die Migration alter    |
| (\"Check                  | Plugins auf die aktuelle API-Version.    |
| API\")]{.guihint}         |                                          |
+---------------------------+------------------------------------------+
:::
::::

:::: sect1
## []{#web .hidden-anchor .sr-only}5. Ressourcen im Web {#heading_web}

::: sectionbody
+---------------------------+------------------------------------------+
| Ressource                 | Beschreibung                             |
+===========================+==========================================+
| [Working with the Checkmk | Video-Tutorial (in Englisch) mit         |
| REST                      | praktischen Beispielen für den Einsatz   |
| API](https://             | der REST-API, etwa zum Setzen von        |
| checkmk.com/videos/en/ep- | Wartungszeiten.                          |
| 46-working-with-checkmk-r |                                          |
| est-api){target="_blank"} |                                          |
+---------------------------+------------------------------------------+
| [REST-API-Code-Beispiele] | Curl-Beispiele in der Checkmk Knowledge  |
| (https://checkmk.atlassia | Base für konkrete, beispielsweise        |
| n.net/wiki/spaces/KB/page | UND-verknüpfte Abfragen.                 |
| s/9473812/REST-API+code+e |                                          |
| xamples){target="_blank"} |                                          |
+---------------------------+------------------------------------------+
| [Checkmk                  | Im Checkmk-Plugin-Store finden Sie viele |
| Exchang                   | praktische Implementierungen der APIs    |
| e](https://exchange.check | samt Quellcode.                          |
| mk.com/){target="_blank"} |                                          |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::
