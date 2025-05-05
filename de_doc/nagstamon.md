:::: {#header}
# Nagstamon mit Checkmk verbinden

::: details
[Last modified on 18-Jun-2019]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/nagstamon.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::: {#content}
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
[Statusdaten abrufen via Livestatus](livestatus.html) [Grundlagen des
Monitorings mit Checkmk](monitoring_basics.html)
[Benachrichtigungen](notifications.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::: sectionbody
::: paragraph
[Nagstamon](https://nagstamon.de/){target="_blank"} ist ein kleines Tool
für den Desktop, welches ursprünglich für Monitoring-Systeme mit
Livestatus entwickelt wurde. In der heutigen Version unterstützt der
Client unter anderem aber auch Checkmk. Es übersetzt in sehr kompakter
Form eine [Tabellenansicht](glossar.html#view) (*view*) aus Checkmk und
fasst die Probleme zusammen.
:::

::: paragraph
Auch wenn es keinen offiziellen Support für Nagstamon gibt, möchten wir
dennoch die Anbindung so einfach wie möglich gestalten. Im Folgenden
beschreiben wir, wie man Nagstamon mit Checkmk verbinden kann.
:::
:::::
::::::

::::::::::::: sect1
## []{#_konfiguration .hidden-anchor .sr-only}2. Konfiguration {#heading__konfiguration}

:::::::::::: sectionbody
::: paragraph
Die einfachste Methode ist es, Nagstamon direkt mit der Weboberfläche
von Checkmk zu verbinden. Damit diese Anbindung nahtlos klappt, liefert
Checkmk zwei Ansichten aus, die Nagstamon dann als Datenquelle nutzt:
:::

::: ulist
- `nagstamon_hosts`

- `nagstamon_svc`
:::

::: paragraph
Sie müssen also initial keine Ansichten einrichten, um die Anbindung zu
ermöglichen. Wenn Sie Nagstamon zum ersten Mal starten, werden Sie
direkt nach einem Server gefragt. Andernfalls erreichen Sie das Menü für
die Einrichtung eines neuen Servers über den Menüpunkt
[Settings]{.guihint}. Hier erstellen Sie dann eine neue Verbindung über
[New server...​]{.guihint}.
:::

::: paragraph
Wählen Sie in dem darauf erscheinenden Dialog unter [Monitor
type]{.guihint} den Eintrag [Checkmk Multisite]{.guihint} aus, vergeben
einen menschenlesbaren Namen und tragen die URL der Anbindung in das
Feld [Monitor URL]{.guihint} ein.
:::

::: paragraph
**Wichtig:** Authentifizieren können Sie sich hier nur mit einem
regulären Benutzer; ein Automationsbenutzer funktioniert hier nicht!
:::

::: paragraph
Eine Konfiguration kann dann zum Beispiel so aussehen:
:::

:::: imageblock
::: content
![nagstamon server](../images/nagstamon-server.png){width="400"}
:::
::::

::: paragraph
Über die Option [Show more options]{.guihint} können Sie dann noch
Feinheiten einstellen und dort zum Beispiel die aufgerufenen Ansichten
verändern, wenn Sie hier eigene konfiguriert haben.
:::
::::::::::::
:::::::::::::

::::::: sect1
## []{#_diagnosemöglichkeiten .hidden-anchor .sr-only}3. Diagnosemöglichkeiten {#heading__diagnosemöglichkeiten}

:::::: sectionbody
::: paragraph
Sollte es wider Erwarten dennoch zu Problemen kommen, prüfen Sie
zunächst, ob Sie von dem Gerät, auf dem Nagstamon läuft, direkt die
folgenden Seiten aufrufen können. Ersetzen Sie dabei die Platzhalter
durch ihre realen Werte:
:::

::: ulist
- `https://mon.mydomain.org/mysite/check_mk/view.py?view_name=nagstamon_hosts`

- `https://mon.mydomain.org/mysite/check_mk/view.py?view_name=nagstamon_svc`
:::

::: paragraph
Sollte dieser Aufruf --- zusammen mit den Login-Daten, welche Sie in der
Konfiguration angegeben haben --- nicht funktionieren, bekommen Sie eine
aussagekräftige Fehlermeldung, was hier schief gelaufen ist. Sobald der
Aufruf korrekt funktioniert, sollte auch Nagstamon Daten liefern.
:::
::::::
:::::::
:::::::::::::::::::::::::::::
