:::: {#header}
# Prometheus integrieren

::: details
[Last modified on 12-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_prometheus.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Kubernetes überwachen](monitoring_kubernetes.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::: sectionbody
::::::: sect2
### []{#_hintergrund_und_motivation .hidden-anchor .sr-only}1.1. Hintergrund und Motivation {#heading__hintergrund_und_motivation}

::: paragraph
Vielleicht fragen Sie sich, warum man überhaupt Prometheus in Checkmk
integrieren sollte. Deswegen an dieser Stelle ein wichtiger Hinweis:
Unsere Integration von Prometheus richtet sich an alle unsere Nutzer,
die Prometheus bereits im Einsatz haben. Damit Sie nicht dauerhaft zwei
Monitoring-Systeme prüfen müssen, schließen wir durch die Integration
von Prometheus in Checkmk die hier entstandene Lücke.
:::

::: paragraph
Damit ermöglichen wir eine Korrelation der Daten aus den beiden
Systemen, beschleunigen eine etwaige Fehlerursachenanalyse und
erleichtern gleichzeitig die Kommunikation zwischen Checkmk- und
Prometheus-Nutzern. So bleibt Checkmk ihr \"Single pane of glass\".
:::

:::: sect3
#### []{#_endlich_wieder_kontext .hidden-anchor .sr-only}Endlich wieder Kontext {#heading__endlich_wieder_kontext}

::: paragraph
Mit der angenehmste Nebeneffekt dieser Integration ist es wohl, dass
Ihre Metriken aus Prometheus in Checkmk automatisch einen sinnvollen
Kontext erhalten. Während Prometheus Ihnen beispielsweise die Menge des
belegten Hauptspeichers korrekt anzeigt, müssen Sie in Checkmk keine
weiteren manuellen Schritte gehen, um zu erfahren, wie groß dabei der
Anteil am insgesamt verfügbaren Speicher ist. So banal das Beispiel sein
mag, zeigt es an welchen Stellen Checkmk das Monitoring bereits im ganz
Kleinen erleichtert.
:::
::::
:::::::

:::::: sect2
### []{#_exporter_oder_promql .hidden-anchor .sr-only}1.2. Exporter oder PromQL {#heading__exporter_oder_promql}

::: paragraph
Die Integration der wichtigsten Exporter für Prometheus wird über einen
[Spezialagenten](glossar.html#special_agent) zur Verfügung gestellt. Für
Prometheus stehen Ihnen die folgenden Exporter zur Verfügung:
:::

::: ulist
- [cAdvisor (Container
  Advisor)](https://checkmk.com/de/integrations?tags=cadvisor){target="_blank"}

- [Node
  Exporter](https://github.com/prometheus/node_exporter/blob/master/README.md){target="_blank"}
:::

::: paragraph
Wenn wir den von Ihnen benötigten Exporter nicht unterstützen, haben
erfahrene Nutzer von Prometheus auch die Möglichkeit direkt über Checkmk
selbst-definierte Abfragen an Prometheus zu richten. Dies geschieht in
der Prometheus-eigenen [Abfragesprache PromQL.](#promQL)
:::
::::::
::::::::::::
:::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einrichten_der_integration .hidden-anchor .sr-only}2. Einrichten der Integration {#heading__einrichten_der_integration}

:::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_host_anlegen .hidden-anchor .sr-only}2.1. Host anlegen {#heading__host_anlegen}

::: paragraph
Da es das Konzept der Hosts in Prometheus schlicht nicht gibt, schaffen
Sie zuerst einen Ort, der die gewünschten Metriken sammelt. Dieser Host
bildet die zentrale Anlaufstelle für den Spezialagenten und verteilt die
angelieferten Daten dann später an die richtigen Hosts in Checkmk.
Erzeugen Sie dazu einen neuen Host über [Setup \> Hosts \> Hosts \> Add
host.]{.guihint}
:::

:::: imageblock
::: content
![prometheus hostname](../images/prometheus_hostname.png)
:::
::::

::: paragraph
Sollte der angegebene Host-Name nicht vom Checkmk-Server auflösbar sein,
geben Sie hier noch die IP-Adresse an unter der der Prometheus-Server
erreichbar ist.
:::

::: paragraph
Nehmen Sie alle weiteren Einstellungen Ihrer Umgebung entsprechend vor
und bestätigen Sie Ihre Auswahl mit [Save & view folder.]{.guihint}
:::
::::::::

::::::::::::::::::::::::::::::::::: sect2
### []{#_regel_für_prometheus_anlegen .hidden-anchor .sr-only}2.2. Regel für Prometheus anlegen {#heading__regel_für_prometheus_anlegen}

::: paragraph
Bevor Checkmk Ihre Metriken aus Prometheus finden kann, müssen Sie
zuerst noch den Spezialagenten über den Regelsatz [Prometheus]{.guihint}
einrichten. Diesen finden Sie über [Setup \> Agents \> VM, cloud,
container.]{.guihint} Unabhängig davon, welchen Exporter Sie verwenden
wollen, gibt es verschiedene Möglichkeiten, die Verbindung zu dem Web
Frontend Ihres Prometheus-Servers anzupassen.
:::

::: ulist
- [URL server address]{.guihint}: Geben Sie hier die URL Ihres
  Prometheus-Servers an, einschließlich aller erforderlichen Ports. Das
  Protokoll können Sie weiter unten auswählen.

- [Authentication]{.guihint}: Ist ein Login erforderlich, geben Sie die
  Zugangsdaten hier an.

- [Protocol]{.guihint}: Nach der Installation wird das Web Frontend per
  HTTP zur Verfügung gestellt. Sofern Sie den Zugriff mit HTTPS
  abgesichert haben, stellen Sie hier das Protokoll entsprechend um.
:::

::: paragraph
Die Standardwerte sehen Sie in folgendem Screenshot:
:::

:::: imageblock
::: content
![prometheus connection
details](../images/prometheus_connection_details.png)
:::
::::

:::::::: sect3
#### []{#node_exporter .hidden-anchor .sr-only}Integration per Node Exporter {#heading_node_exporter}

::: paragraph
Wenn Sie nun beispielsweise die Hardware-Komponenten eines sogenannten
[Scrape Targets]{.guihint} aus Prometheus integrieren möchten, nutzen
Sie dafür den Node Exporter. Wählen Sie nun [Add new Scrape
Target]{.guihint} und danach im ersten Drop-down-Menü [Node
Exporter]{.guihint} aus:
:::

:::: imageblock
::: content
![prometheus ruleset
exporter](../images/prometheus_ruleset_exporter.png)
:::
::::

::: paragraph
Hier können Sie auswählen, welche Hardware oder welche
Betriebssystem-Instanzen vom Node Exporter abgefragt werden sollen. Sie
haben immer die Option, Informationen abzuwählen, wenn Sie diese nicht
abrufen wollen. Die erzeugten Services benutzen dann dieselben
Check-Plugins, wie sie auch für andere Linux-Hosts verwendet werden.
Dadurch sind sie in ihrem Verhalten identisch zu den bekannten und Sie
können ohne große Umstellung Schwellwerte konfigurieren oder mit den
Graphen arbeiten.
:::

::: paragraph
Normalerweise wird der Agent versuchen, die Daten automatisch den Hosts
in Checkmk zuzuordnen. So auch für den Host in Checkmk, der die Daten
holt. Sollte in den Daten des Prometheus-Servers aber weder die
IP-Adresse, der FQDN, noch localhost vorkommen, bestimmen Sie über die
Option [Explicitly map Node Exporter host]{.guihint}, welcher Host aus
den Daten des Prometheus-Servers dem Prometheus-Host in Checkmk
zugeordnet wird.
:::
::::::::

:::::::::::: sect3
#### []{#cadvisor .hidden-anchor .sr-only}Integration per cAdvisor {#heading_cadvisor}

::: paragraph
Der Exporter cAdvisor erlaubt die Überwachung von Docker-Umgebungen und
liefert dabei Metriken zurück.
:::

::: paragraph
Über das Menü [Entity level used to create Checkmk piggyback
hosts]{.guihint} können Sie festlegen, ob und wie die Daten aus
Prometheus schon aggregiert abgeholt werden sollen. Ihnen stehen dabei
die folgenden drei Optionen zur Auswahl:
:::

::: ulist
- [Container - Display the information on container level]{.guihint}

- [Pod - Display the information for pod level]{.guihint}

- [Both - Display the information for both, pod and container,
  levels]{.guihint}
:::

::: paragraph
Wählen Sie hierbei entweder [Both]{.guihint} oder [Container]{.guihint}
aus, legen Sie außerdem noch fest, unter welchem Namen Hosts für Ihre
Container angelegt werden. Die folgenden drei Option stehen Ihnen für
die Benamsung zur Verfügung. Die Option [Short]{.guihint} ist hierbei
der Standard:
:::

::: ulist
- [Short - Use the first 12 characters of the docker container
  ID]{.guihint}

- [Long - Use the full docker container ID]{.guihint}

- [Name - Use the name of the container]{.guihint}
:::

:::: imageblock
::: content
![prometheus cadvisor names](../images/prometheus_cadvisor_names.png)
:::
::::

::: paragraph
Beachten Sie, dass die Auswahl an dieser Stelle Auswirkungen auf das
automatische Anlegen und Löschen von Hosts entsprechend Ihrer
[dynamischen Host-Konfiguration](#dcd_cadvisor) hat.
:::

::: paragraph
Mit [Monitor namespaces matching]{.guihint} haben Sie die Möglichkeit,
die Anzahl der überwachten Objekte einzuschränken. Alle Namespaces, die
nicht von den regulären Ausdrücken erfasst werden, werden dann
ignoriert.
:::
::::::::::::

::::::::: sect3
#### []{#promQL .hidden-anchor .sr-only}Integration per PromQL {#heading_promQL}

::: paragraph
Wie bereits erwähnt, ist es mit Hilfe des Spezialagenten auch möglich,
Ihren Prometheus-Server über PromQL abzufragen. Wählen Sie [Service
creation using PromQL queries \> Add new Service]{.guihint} aus. Mit dem
Feld [Service name]{.guihint} bestimmten Sie, wie der neue Service in
Checkmk heißen soll.
:::

::: paragraph
Wählen Sie dann [Add new PromQL query]{.guihint} und legen Sie über das
Feld [Metric label]{.guihint} fest, wie die zu importierende Metrik in
Checkmk heißen soll. In das Feld [PromQL query]{.guihint} geben Sie nun
Ihre Abfrage ein. Dabei ist es wichtig, dass diese Abfrage nur **einen**
Rückgabewert haben darf.
:::

:::: imageblock
::: content
![prometheus ruleset promql](../images/prometheus_ruleset_promql.png)
:::
::::

::: paragraph
In diesem Beispiel wird Prometheus nach der Anzahl der laufenden und
blockierten Prozesse gefragt. In Checkmk werden diese dann in einem
Service mit dem Namen [Processes]{.guihint} und den beiden Metriken
[Running]{.guihint} und [Blocked]{.guihint} zusammengefasst.
:::

::: paragraph
Sie können diesen Metriken auch Schwellwerte zuweisen. Aktivieren Sie
dafür die [Metric levels]{.guihint} und wählen Sie danach zwischen
[Lower levels]{.guihint} oder [Upper levels]{.guihint}. Beachten Sie,
dass sie zwar immer Gleitkommazahlen angeben, diese sich aber natürlich
auch auf Metriken beziehen, welche nur Ganzzahlen zurückgeben.
:::
:::::::::

:::::: sect3
#### []{#_regel_dem_prometheus_host_zuweisen .hidden-anchor .sr-only}Regel dem Prometheus-Host zuweisen {#heading__regel_dem_prometheus_host_zuweisen}

::: paragraph
Weisen Sie zum Schluss diese Regel explizit dem soeben angelegten Host
zu und bestätigen Sie mit [Save.]{.guihint}
:::

:::: imageblock
::: content
![prometheus ruleset explicit
host](../images/prometheus_ruleset_explicit_host.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::

:::::: sect2
### []{#_service_erkennung .hidden-anchor .sr-only}2.3. Service-Erkennung {#heading__service_erkennung}

::: paragraph
Nachdem Sie den Spezialagenten nun konfiguriert haben, ist es Zeit, eine
[Service-Erkennung](glossar.html#service_discovery) auf dem
Prometheus-Host durchzuführen.
:::

:::: imageblock
::: content
![prometheus discovery](../images/prometheus_discovery.png)
:::
::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#dcd .hidden-anchor .sr-only}3. Dynamische Host-Konfiguration {#heading_dcd}

::::::::::: sectionbody
:::::: sect2
### []{#_generelle_konfiguration .hidden-anchor .sr-only}3.1. Generelle Konfiguration {#heading__generelle_konfiguration}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Überwachung
von Kubernetes Clustern ist vermutlich eine der Aufgaben, die am
häufigsten mit Prometheus bewerkstelligt wird. Um eine Integration der
mitunter sehr kurzlebigen Container, die per Kubernetes orchestriert und
mit Prometheus überwacht werden, auch in Checkmk ohne großen Aufwand zu
gewährleisten, bietet sich in den kommerziellen Editionen die
Einrichtung einer [dynamischen Host-Konfiguration](dcd.html) an. Die
Daten der einzelnen Container werden dabei als
[Piggyback](glossar.html#piggyback)-Daten an Checkmk weitergeleitet.
:::

::: paragraph
Legen Sie nun über [Setup \> Hosts \> Hosts \> Dynamic host management
\> Add connection]{.guihint} eine neue Verbindung an, wählen als Sie als
Connector type [Piggyback data]{.guihint} und legen Sie über [Add new
element]{.guihint} die Bedingungen fest, unter denen neue Hosts
dynamisch erstellt werden sollen.
:::

::: paragraph
Überlegen Sie auch, ob es für Ihre Umgebung notwendig ist, Hosts auch
wieder dynamisch zu löschen, wenn keine Daten mehr über den
Piggyback-Mechanismus bei Checkmk ankommen. Stellen Sie die Option
[Delete vanished hosts]{.guihint} entsprechend ein.
:::
::::::

:::::: sect2
### []{#dcd_cadvisor .hidden-anchor .sr-only}3.2. Besonderheit im Zusammenspiel mit cAdvisor {#heading_dcd_cadvisor}

::: paragraph
Normalerweise bekommen Container eine neue ID, wenn sie neu gestartet
werden. In Checkmk werden die Metriken des Hosts mit der alten ID nicht
automatisch auf die neue ID übertragen. Das würde in den meisten Fällen
auch gar keinen Sinn ergeben. Im Falle von Containern kann das aber
durchaus nützlich sein, wie in dem Beispiel eben gesehen.
:::

::: paragraph
Wenn Container nur neu gestartet werden, möchten Sie sehr wahrscheinlich
deren Historie nicht verlieren. Um das zu erreichen, legen Sie die
Container nicht unter ihren IDs, sondern stattdessen unter ihren Namen
an --- mit der Option [Name - Use the name of the container]{.guihint}
in der [Prometheus-Regel.](#cadvisor)
:::

::: paragraph
Auf diese Weise können Sie nicht mehr vorhandene Container dennoch mit
der Option [Delete vanished hosts]{.guihint} in der dynamischen
Host-Konfiguration löschen, ohne befürchten zu müssen, dass die Historie
damit auch verloren ist. Stattdessen wird diese --- durch den
identischen Namen des Containers --- fortgeführt, auch wenn es sich um
einen anderen Container handelt, der aber denselben Namen hat.
:::
::::::
:::::::::::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
