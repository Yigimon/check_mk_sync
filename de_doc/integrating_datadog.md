:::: {#header}
# Datadog integrieren

::: details
[Last modified on 08-Mar-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/integrating_datadog.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
[Kubernetes überwachen](monitoring_kubernetes.html) [Amazon Web Services
(AWS) überwachen](monitoring_aws.html) [Microsoft Azure
überwachen](monitoring_azure.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::: sectionbody
::::: sect2
### []{#_hintergrund_und_motivation .hidden-anchor .sr-only}1.1. Hintergrund und Motivation {#heading__hintergrund_und_motivation}

::: paragraph
Unsere Integration von Datadog richtet sich an alle unsere Benutzer, die
Datadog in ihren Unternehmen bereits im Einsatz haben. Durch unsere
Integration verringern wir die Notwendigkeit dauerhaft zwei
Monitoring-Systeme prüfen zu müssen und schließen damit die entstandene
Lücke zwischen den zwei Systemen.
:::

::: paragraph
So ermöglichen wir eine Korrelation der Daten aus den beiden Systemen,
beschleunigen eine etwaige Fehlerursachenanalyse und erleichtern
gleichzeitig die Kommunikation zwischen Checkmk- und Datadog-Benutzern.
:::
:::::

::::: sect2
### []{#_monitore_und_events .hidden-anchor .sr-only}1.2. Monitore und Events {#heading__monitore_und_events}

::: paragraph
Konkret ermöglichen wir mit unserer Anbindung beliebige sogenannte
Monitore (englisch: *Monitors*) und Events aus Datadog in Checkmk zu
überwachen und anzuzeigen. Selbstverständlich können Sie sich dann auch
auf den gewohnten Wegen aus Checkmk heraus über Vorkommnisse
[benachrichtigen](glossar.html#notification) lassen.
:::

::: paragraph
Die Integration beliebiger Monitore und Events aus Datadog wird über
einen [Spezialagenten](glossar.html#special_agent) zur Verfügung
gestellt.
:::
:::::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einrichten_der_integration .hidden-anchor .sr-only}2. Einrichten der Integration {#heading__einrichten_der_integration}

::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_schlüssel_erzeugen_und_kopieren .hidden-anchor .sr-only}2.1. Schlüssel erzeugen und kopieren {#heading__schlüssel_erzeugen_und_kopieren}

::: paragraph
Für die Datengewinnung nutzt unser Spezialagent die API von Datadog. Um
den Zugriff auf diese API abzusichern werden zwei Schlüssel benötigt -
jeweils ein *API Key* und ein *Application Key*. Wir empfehlen für die
Verwendung durch Checkmk zwei neue Schlüssel zu erzeugen und diese
ausschließlich für den Abruf durch Checkmk zu verwenden.
:::

::: paragraph
Zum Zeitpunkt, zu dem dieser Artikel entstanden ist, finden Sie die
entsprechenden Schlüssel bzw. die Möglichkeit solche Schlüssel neu zu
erzeugen, in Datadog über den Knopf unten links in der Ecke, auf dem Ihr
Benutzername steht. Klicken Sie dort auf [Organization
Settings]{.guihint}. Unter der Überschrift [ACCESS]{.guihint} finden Sie
nun die beiden Einträge [API Keys]{.guihint} und [Application
Keys]{.guihint}. Erzeugen Sie in diesen beiden Untermenüs über den Knopf
[New Key]{.guihint} jeweils einen neuen Schlüssel.
:::

:::: {.imageblock .border}
::: content
![integrating datadog application
key](../images/integrating_datadog_application_key.png)
:::
::::

::: paragraph
Damit Sie die beiden Schlüssel im Anschluss in Checkmk einfügen können,
empfiehlt es sich, diese zu kopieren. Klicken Sie dazu in die Zeile des
jeweiligen Schlüssels und anschließend auf [Copy]{.guihint}.
:::

::: paragraph
**Hinweis:** Während der Entstehung dieses Artikels hat sich der
Ablageort der Schlüssel bereits einmal geändert. Sollten Sie die oben
beschriebenen Menüpunkte so nicht vorfinden, konsultieren Sie bitte die
Dokumentation von Datadog.
:::
:::::::::

:::::::: sect2
### []{#create_host .hidden-anchor .sr-only}2.2. Host anlegen {#heading_create_host}

::: paragraph
Je nachdem, wie Sie Datadog in Checkmk integrieren möchten, kann es
unterschiedliche Wege geben, wie Sie die gewonnenen Daten auf Hosts in
Checkmk zuweisen. Dazu später mehr. Im Folgenden konzentrieren wir uns
erstmal auf eine einfache Einrichtung und zeigen, wie Sie alle Daten
einem Host zuweisen.
:::

::: paragraph
Erzeugen Sie dazu in Checkmk auf gewohnte Weise einen neuen Host und
nennen Sie diesen beispielsweise `mydatadoghost`. Da dieser Host vorerst
ausschließlich über den Spezialagenten Daten erhält, setzen Sie die
Option [IP address family]{.guihint} auf [No IP.]{.guihint}
:::

:::: imageblock
::: content
![integrating datadog add
host](../images/integrating_datadog_add_host.png)
:::
::::

::: paragraph
Nehmen Sie alle weiteren Einstellungen Ihrer Umgebung entsprechend vor
und bestätigen Sie Ihre Auswahl über [Save & view folder.]{.guihint}
:::
::::::::

::::::::::::::::::::::::::: sect2
### []{#_regel_für_den_datadog_agenten_anlegen .hidden-anchor .sr-only}2.3. Regel für den Datadog-Agenten anlegen {#heading__regel_für_den_datadog_agenten_anlegen}

::: paragraph
Als nächstes müssen Sie den Spezialagenten über den Regelsatz [Setup \>
Agents \> Other integrations \> Applications \> Datadog]{.guihint}
einrichten. Kopieren Sie als erstes die beiden zuvor erzeugten Schlüssel
in die dafür vorgesehenen Felder oder verwenden Sie alternativ den
Passwortspeicher von Checkmk. Prüfen Sie danach, ob der voreingetragene
[API host]{.guihint} dem Ihrer Datadog-Instanz entspricht. Vergleichen
Sie dazu einfach die URL Ihrer Datadog-Instanz mit dem vorgegebenen
Eintrag in der Regel und passen Sie diesen gegebenenfalls an.
:::

::: paragraph
Falls Sie die Kommunikation von Checkmk mit Datadog über einen [HTTP
proxy]{.guihint} laufen lassen, tragen Sie diesen in der folgenden
Option ein.
:::

::: paragraph
Nun können Sie entscheiden, welche Daten Sie konkret aus Datadog nach
Checkmk übertragen möchten. Hier stehen die sogenannten
[Monitors,]{.guihint} [Events]{.guihint} und [Logs]{.guihint} zur
Auswahl.
:::

:::::::::: sect3
#### []{#_fetch_monitors .hidden-anchor .sr-only}Fetch monitors {#heading__fetch_monitors}

::: paragraph
Wenn Sie die Überwachung der Monitore aktivieren, haben Sie die
Möglichkeit, die zu übertragenden Daten über Tags innerhalb von Datadog
zu filtern. Gerade in großen Umgebungen empfiehlt es sich, Monitore, die
Sie in Checkmk sehen möchten, in Datadog mit einem entsprechenden Tag
(bspw. `monitored_by_checkmk:yes`) zu versehen. Tragen Sie diese Tags
dann unter [Restrict by monitor tags]{.guihint} ein.
:::

::: paragraph
Des Weiteren ist es auch möglich andere Tags, die in der Konfiguration
der Monitore in Datadog auftauchen, zum Filtern zu verwenden. Sie können
beispielsweise in Datadog Hosts mit einem Tag \'checkmk:yes\' versehen.
:::

::: paragraph
Wenn Sie im Anschluss in Datadog einen Host-Monitor erstellen, der sich
auf alle Hosts mit diesem Tag bezieht, können Sie eben dieses Tag auch
in Checkmk unter [Restrict by tags]{.guihint} eintragen. So erhalten Sie
mit sehr geringem Aufwand alle Monitore aus Datadog, die dieses Tag
enthalten. Das funktioniert natürlich nicht nur für Host-Tags, sondern
für alle Tags aus denen sich Monitore in Datadog erstellen lassen.
:::

:::: imageblock
::: content
![integrating datadog fetch
monitors](../images/integrating_datadog_fetch_monitors.png){width="41%"}
:::
::::

::: paragraph
Wenn Sie die beiden Optionen deaktiviert lassen, werden einfach alle
Monitore aus Datadog nach Checkmk übertragen.
:::

::: paragraph
Für jeden Monitor, welchen Sie überwachen, wird in Checkmk ein Service
angelegt.
:::
::::::::::

:::::::: sect3
#### []{#_fetch_events .hidden-anchor .sr-only}Fetch events {#heading__fetch_events}

::: paragraph
Mit dem Spezialagenten für Datadog haben Sie auch die Möglichkeit Events
aus Datadog direkt in die [Event Console](glossar.html#ec) von Checkmk
zu übertragen. Zur Eingrenzung, welche Events übertragen werden sollen,
können Sie erneut Tags aus Datadog verwenden. Des Weiteren kann ein
Zeitrahmen festgelegt werden, aus welchem Events übertragen werden
sollen. Dieses [Maximum age of fetched events]{.guihint} sollte nicht
kürzer sein als das Check-Intervall, da sonst gegebenenfalls Events
übersehen werden. Da es aber auch vorkommen kann, dass Datadog Events
mit einem Zeitstempel anlegt, der in der Vergangenheit liegt, sollte der
Zeitraum nicht zu knapp bemessen werden. Die voreingestellten 10 Minuten
sind hier ein guter Anhaltspunkt.
:::

:::: imageblock
::: content
![integrating datadog fetch
events](../images/integrating_datadog_fetch_events.png){width="50%"}
:::
::::

::: paragraph
Alle weiteren Felder in diesem Teil der Regel beziehen sich darauf, mit
welchen Parametern die Events aus Datadog in der Event Console von
Checkmk angelegt werden sollen. Eine detaillierte Beschreibung all
dieser Felder finden Sie im Artikel zur Event Console in den Abschnitten
[Syslog-Priorität und -Facility](ec.html#syslogfacility) und
[Service-Level.](ec.html#servicelevel)
:::

::: paragraph
Für die Events wird auf dem Host in Checkmk nur ein einzelner Service
angelegt, der Sie darüber in Kenntnis setzt, wie viele Events übertragen
wurden.
:::
::::::::

:::::: sect3
#### []{#_fetch_logs .hidden-anchor .sr-only}Fetch logs {#heading__fetch_logs}

::: paragraph
Auch Logs können Sie von Datadog importieren und über die [Event
Console](glossar.html#ec) auswerten lassen, grundsätzlich exakt wie just
für die Events beschrieben. Im Feld [Log search query]{.guihint}
verwenden Sie für die Suche die [Datadog-eigene
Syntax.](https://docs.datadoghq.com/logs/explorer/search_syntax/){target="_blank"}
Und auch die Zusammensetzung des weiterzuleitenden Texts über die Option
[Text of forwarded events]{.guihint} wird in der
[Datadog-Dokumentation](https://docs.datadoghq.com/api/latest/logs/#search-logs){target="_blank"}
ausgeführt.
:::

:::: imageblock
::: content
![integrating datadog fetch
logs](../images/integrating_datadog_fetch_logs.png){width="50%"}
:::
::::
::::::

::::: sect3
#### []{#_expliziten_host_festlegen_und_service_erkennung_durchführen .hidden-anchor .sr-only}Expliziten Host festlegen und Service-Erkennung durchführen {#heading__expliziten_host_festlegen_und_service_erkennung_durchführen}

::: paragraph
Damit die Monitore und Events, die Sie mit dieser Regel aus Datadog
abholen, nur auf einem Host ankommen, **müssen** Sie den [zuvor
erzeugten Host](#create_host) zum Abschluss noch unter [Conditions \>
Explicit hosts]{.guihint} eintragen. Klicken Sie anschließend auf
[Save.]{.guihint} Sobald Sie für diesen Host eine
[Service-Erkennung](glossar.html#service_discovery) durchführen, sehen
Sie Ihre ersten Monitore und Events aus Datadog in Checkmk.
:::

::: paragraph
**Hinweis:** In der Praxis hat sich gezeigt, dass es günstig sein kann,
Monitore und Events auf getrennte Hosts in Checkmk zu legen. Dieses
Vorgehen erhöht im Allgemeinen die Übersicht und erlaubt eine einfachere
Konfiguration weiterer Parameter für die einzelnen Hosts.
:::
:::::
:::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#_mapping_der_zustände .hidden-anchor .sr-only}3. Mapping der Zustände {#heading__mapping_der_zustände}

::::::: sectionbody
::: paragraph
Die Zustände, die mit den Monitoren aus Datadog übertragen werden,
lassen sich nicht für jeden Anwendungsfall 1:1 auf die Zustände in
Checkmk übertragen. Um Ihnen die Möglichkeit zu geben, diese Zustände
nach Ihren Bedürfnissen einzustellen, gibt es die Regel [Checking of
Datadog monitors.]{.guihint} Diese finden Sie über die Suche im
[Setup]{.guihint}-Menü oder über [Setup \> Services \> Service
monitoring rules \> Applications, Processes & Services \> Checking of
Datadog monitors.]{.guihint}
:::

:::: imageblock
::: content
![integrating datadog
parameters](../images/integrating_datadog_parameters.png)
:::
::::

::: paragraph
Des Weiteren können Sie in dieser Regel auch festlegen, welche Tags aus
Datadog im Service Output in Checkmk angezeigt werden sollen.
:::
:::::::
::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
