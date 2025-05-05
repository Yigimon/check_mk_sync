:::: {#header}
# Google Cloud Platform (GCP) überwachen

::: details
[Last modified on 07-Jun-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_gcp.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Dynamische Host-Konfiguration](dcd.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![logo google cloud](../images/logo_google_cloud.png){width="120"}
:::
::::

::: paragraph
Checkmk enthält ein umfangreiches Monitoring von Google Cloud Platform
(GCP), welches aus einem Konnektor zu GCP und einer stattlichen Sammlung
von Check-Plugins besteht, die für Sie verschiedenste Metriken und
Zustände abrufen und auswerten.
:::

::: paragraph
Neben den allgemeinen Informationen zu den
[Kosten](https://checkmk.com/de/integrations/gcp_cost){target="_blank"}
Ihrer Google Cloud und dem aktuellen
[Status](https://checkmk.com/de/integrations/gcp_status){target="_blank"}
der Google-Dienste in Ihrer Region, können Sie mit allen Editionen von
Checkmk ab Version [2.2.0]{.new} die folgenden Google Cloud-Produkte
überwachen:
:::

::: ulist
- [Compute Engine
  (GCE)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_gce){target="_blank"}

- [Cloud Storage
  (GCS)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_gcs){target="_blank"}

- [Filestore](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_filestore){target="_blank"}

- [Cloud
  SQL](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_sql){target="_blank"}

- [Cloud Load
  Balancing](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_http_lb){target="_blank"}
:::

::: paragraph
Mit
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** und
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** können Sie darüber hinaus noch die folgenden Produkte in
Ihr Monitoring aufnehmen:
:::

::: ulist
- [Cloud
  Functions](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_function){target="_blank"}

- [Cloud
  Run](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_run){target="_blank"}

- [Memorystore for
  Redis](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=gcp_redis){target="_blank"}
:::

::: paragraph
Eine vollständige Auflistung aller verfügbaren Check-Plugins für die
Überwachung von GCP finden Sie in unserem [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=gcp){target="_blank"}
und wie Sie Ihre GKE-Cluster (Google Kubernetes Engine) ins Monitoring
aufnehmen, beschreiben wir im Artikel [Kubernetes
überwachen](monitoring_kubernetes.html).
:::
:::::::::::
::::::::::::

::::::::::: sect1
## []{#implementation_gcp .hidden-anchor .sr-only}2. Konkrete Umsetzung der GCP-Überwachung {#heading_implementation_gcp}

:::::::::: sectionbody
::::::: sect2
### []{#_hosts_und_services .hidden-anchor .sr-only}2.1. Hosts und Services {#heading__hosts_und_services}

::: paragraph
In Checkmk ordnen sich alle zu überwachenden Objekte in eine
hierarchische Struktur von Hosts und Services ein. Nun gibt es bei
Cloud-basierten Diensten das Konzept von Hosts in dieser Form nicht. Um
die Einfachheit und Konsistenz von Checkmk zu bewahren, bilden wir
GCP-Objekte auf das Schema Host/Service ab. Jedes Ihrer Projekte in der
Google Cloud wird dabei einem eigenen Host in Checkmk zugewiesen. Alle
Cloud-Produkte, die Sie in diesem Projekt überwachen möchten, werden
dann auf mehrere Services auf diesem speziellen Host aufgeteilt.
:::

::: paragraph
Ein kleines Projekt, in dem nur eine Compute Engine-VM läuft, kann dann
in der Überwachung in Checkmk so aussehen:
:::

:::: imageblock
::: content
![monitoring gcp example
host](../images/monitoring_gcp_example_host.png)
:::
::::
:::::::

:::: sect2
### []{#_zugriff_auf_gcp .hidden-anchor .sr-only}2.2. Zugriff auf GCP {#heading__zugriff_auf_gcp}

::: paragraph
GCP stellt eine HTTP-basierte API bereit, über die auch Monitoring-Daten
abrufbar sind. Checkmk greift auf diese API über den
[Spezialagenten](glossar.html#special_agent) `agent_gcp` zu. Dieser
tritt an die Stelle des Checkmk-Agenten, wird aber - anders als dieser -
lokal auf dem Checkmk-Server ausgeführt.
:::
::::
::::::::::
:::::::::::

::::::::::::::::::::::::: sect1
## []{#preparation_gcp .hidden-anchor .sr-only}3. GCP für Checkmk vorbereiten {#heading_preparation_gcp}

:::::::::::::::::::::::: sectionbody
:::::::::: sect2
### []{#acquire_project_id .hidden-anchor .sr-only}3.1. Projekt-ID besorgen {#heading_acquire_project_id}

::: paragraph
Melden Sie sich in der [Konsole von Google
Cloud](https://console.cloud.google.com){target="_blank"} an. Achten Sie
darauf, dass in der Titelzeile das korrekte Projekt ausgewählt ist bzw.
wählen Sie hier das zu überwachende Projekt aus.
:::

::: paragraph
Öffnen Sie dann das Dashboard des Projekts. Hier sollten Sie - wenn das
Dashboard noch dem Standard entspricht - eine Karte finden auf der die
[Project ID]{.guihint} angegeben ist. Kopieren oder notieren Sie diese.
:::

:::: imageblock
::: content
![monitoring gcp project
info](../images/monitoring_gcp_project_info.png){width="56%"}
:::
::::

::: paragraph
Sollte die Karte mit den Projektinformationen nicht mehr Teil Ihres
Dashboards sein, finden Sie die notwendige ID auch über die [Project
settings:]{.guihint}
:::

:::: imageblock
::: content
![monitoring gcp project
settings](../images/monitoring_gcp_project_settings.png){width="30%"}
:::
::::
::::::::::

:::::: sect2
### []{#_benutzer_anlegen .hidden-anchor .sr-only}3.2. Benutzer anlegen {#heading__benutzer_anlegen}

::: paragraph
Öffnen Sie als nächstes die Benutzerverwaltung unter [IAM &
Admin]{.guihint}. In der Übersicht auf der linken Seite müssen Sie nun
[Service Accounts]{.guihint} auswählen und dann oben auf [Create Service
Account]{.guihint} klicken. Legen Sie anschließend einen Namen für den
Service Account fest. Wir empfehlen hier einen Namen zu vergeben, der
sofort klar macht, wofür dieser Account da ist, bspw.
`checkmk-monitoring`. Zusätzlich zu einem sprechenden Namen können Sie
optional noch eine Beschreibung - eine Service Account Description -
angeben. Nach einem Klick auf [Create and continue]{.guihint} müssen Sie
diesem Service-Account noch die beiden Rollen *Monitoring Viewer* und
*Cloud Asset Viewer* zuweisen. Klicken Sie dafür jeweils in das Feld
[Select a role]{.guihint} und geben Sie den Rollennamen ein.
:::

::: paragraph
**Achtung:** Wenn Sie *Monitoring Viewer* in das Feld eingeben, werden
Ihnen eine ganze Reihe Rollen mit ähnlichen Namen angezeigt. Achten Sie
darauf tatsächlich *Monitoring Viewer* zu wählen.
:::

::: paragraph
Nach der Auswahl der Rollen, können Sie den nächsten optionalen Schritt
überspringen und direkt auf [Done]{.guihint} klicken.
:::
::::::

::::: sect2
### []{#create_key .hidden-anchor .sr-only}3.3. Schlüssel erzeugen {#heading_create_key}

::: paragraph
Damit Sie über diesen neuen Service Account auch tatsächlich auf die
Monitoring- und Asset-Daten Ihrer Google Cloud zugreifen können, müssen
Sie noch einen Schlüssel erzeugen. Diesen hinterlegen Sie später in der
entsprechenden Regel in Checkmk bzw. im [Password store]{.guihint}.
:::

::: paragraph
In der Übersicht [Service accounts for project My Project]{.guihint}
können Sie dazu in der Zeile Ihres neuen Service Accounts auf die drei
Punkte klicken und dort [Manage keys]{.guihint} auswählen. Klicken Sie
sodann auf [Add key]{.guihint} und dann auf [Create new key]{.guihint}.
Wählen Sie als Format unbedingt `JSON` aus und klicken Sie auf
[Create]{.guihint}. Mit diesem Klick auf [Create]{.guihint} wird -
leicht übersehbar - eine Datei im JSON-Format heruntergeladen. Bewahren
Sie diese Datei vorübergehend gut auf, da Sie sie **nicht** erneut
herunterladen können. Wir empfehlen allerdings, auch diese Datei zu
löschen, nachdem Sie deren Inhalt in Checkmk hinterlegt haben (siehe
[Regel für GCP-Agenten anlegen](#agent_rule)). Bei Bedarf sollte ein
neuer Schlüssel erzeugt und der alte gänzlich verworfen werden.
:::
:::::

:::: sect2
### []{#enable_apis .hidden-anchor .sr-only}3.4. APIs im GCP-Projekt aktivieren {#heading_enable_apis}

::: paragraph
Auf der Übersichtsseite Ihres GCP-Projekts finden Sie auch den Menüpunkt
[APIs & Services]{.guihint}. Überprüfen Sie in dieser Übersicht, ob die
`Cloud Asset API` in der Liste der [Enabled APIs & services]{.guihint}
auftaucht. Wenn dem nicht der Fall ist, aktivieren Sie diese API über
den Knopf [Enable APIs and services]{.guihint}. Nach der Aktivierung
dauert es noch einige Minute bis die API auch tatsächlich ansprechbar
ist.
:::
::::

:::::: sect2
### []{#_abrechnungsinformationen_überwachen .hidden-anchor .sr-only}3.5. Abrechnungsinformationen überwachen {#heading__abrechnungsinformationen_überwachen}

::: paragraph
In der Google Cloud Platform werden Abrechnungsinformationen separat von
den Ressourcen gespeichert. Im Regelfall werden dazu eigene Projekte für
die Kostenanalyse in GCP angelegt, in welchen dann wiederum die
Abrechnungsinformationen für andere Projekte gesammelt werden. Um diese
Informationen auch mit Checkmk überwachen zu können ist es unerlässlich,
dass diese Daten innerhalb der GCP nach BigQuery exportiert werden. Nur
Daten, die in Tabellen von BigQuery vorliegen sind von außen - und somit
für Checkmk - abrufbar. Wie ein solcher Export innerhalb von GCP
eingerichtet wird, wird in dem Dokument [Cloud Billing-Daten nach
BigQuery
exportieren](https://cloud.google.com/billing/docs/how-to/export-data-bigquery?hl=de){target="_blank"}
der GCP-Hilfe ausführlich erklärt.
:::

::: paragraph
Wenn Sie BigQuery eingerichtet haben bzw. ohnehin bereits nutzen, finden
Sie im [SQL-Arbeitsbereich]{.guihint} des Abrechnungsprojekts eine
Auflistung der enthaltenen Tabellen. Öffnen Sie die Tabelle des
Abrechnungsprojekts und klicken Sie auf den Reiter [Details.]{.guihint}
Unter [Tabellen-ID]{.guihint} finden Sie die Information, die Sie beim
Anlegen der Regel in Checkmk unter [Costs \> BigQuery table
ID]{.guihint} eintragen müssen.
:::

::: paragraph
Der Service für die Überwachung der Projektkosten ist als Übersicht
ausgelegt. Es werden ausschließlich die monatlichen Kosten der einzelnen
Projekte angezeigt und überwacht. Schwellwerte für diese monatlichen
Kosten können Sie mit der Regel [GCP Cost]{.guihint} festlegen.
:::
::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#configure_cmk .hidden-anchor .sr-only}4. Monitoring in Checkmk konfigurieren {#heading_configure_cmk}

::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#create_host .hidden-anchor .sr-only}4.1. Host für GCP anlegen {#heading_create_host}

::: paragraph
Legen Sie für die Überwachung von GCP nun einen Host in Checkmk an. Den
Host-Namen können Sie nach Belieben vergeben. Wenn Sie mehrere Projekte
in GCP überwachen wollen, müssen Sie für jedes Projekt einen eigenen
Host in Checkmk anlegen.
:::

::: paragraph
**Wichtig:** Da GCP als Dienst weder eine IP-Adresse noch einen
DNS-Namen hat (den Zugriff macht der Spezialagent von selbst), müssen
Sie die [IP address family]{.guihint} auf [No IP]{.guihint} einstellen.
:::

:::: imageblock
::: content
![monitoring gcp no ip](../images/monitoring_gcp_no_ip.png)
:::
::::
:::::::

::::::::: sect2
### []{#agent_rule .hidden-anchor .sr-only}4.2. Den GCP-Agenten konfigurieren {#heading_agent_rule}

::: paragraph
Wie eingangs erwähnt werden Projekte auf der Google Cloud Platform von
einem [Spezialagenten](glossar.html#special_agent) überwacht. Dieser
wird mit einer Regel konfiguriert, welche Sie über [Setup \> Agents \>
VM, cloud, container \> Google Cloud Platform (GCP)]{.guihint} finden.
:::

::: paragraph
Tragen Sie hier im entsprechenden Feld die [Project ID]{.guihint} ein,
welche Sie zuvor [in Ihrem Projekt nachgeschlagen](#acquire_project_id)
haben.
:::

::: paragraph
Unter [JSON credentials for service account]{.guihint} muss als nächstes
der Schlüssel eingetragen werden, welchen Sie [für Ihren Service Account
erzeugt](#create_key) haben. Sie müssen hier das gesamte JSON-Objekt
(inklusive der geschweiften Klammern) hineinkopieren.
:::

:::: imageblock
::: content
![monitoring gcp id and key](../images/monitoring_gcp_id_and_key.png)
:::
::::

::: paragraph
Unter [GCP services to monitor]{.guihint} können Sie nun auswählen,
welche GCP-Produkte durch den Spezialagenten überwacht werden sollen. Um
die API-Abfragen möglichst sparsam zu gestalten, empfehlen wir nur die
Produkte auszuwählen, die tatsächlich in Ihrem Projekt verwendet werden.
:::
:::::::::

:::::: sect2
### []{#_services_auf_dem_gcp_host_selbst .hidden-anchor .sr-only}4.3. Services auf dem GCP-Host selbst {#heading__services_auf_dem_gcp_host_selbst}

::: paragraph
Starten Sie nun eine [Service-Erkennung](glossar.html#service_discovery)
des neu angelegten GCP-Hosts, wo Checkmk nun etliche Services finden
sollte. Nachdem Sie die Services hinzugefügt haben, sieht das nach einem
[Aktivieren der Änderungen](glossar.html#activate_changes) im Monitoring
etwa so aus:
:::

:::: imageblock
::: content
![monitoring gcp services](../images/monitoring_gcp_services.png)
:::
::::
::::::

:::::::::::::::::::::: sect2
### []{#vm-hosts .hidden-anchor .sr-only}4.4. Hosts für die Compute Engine VM-Instanzen anlegen {#heading_vm-hosts}

::: paragraph
Services, die Compute Engine VM-Instanzen zugeordnet sind, werden nicht
dem GCP-Host zugeordnet, sondern sogenannten
[Piggyback-Hosts](glossar.html#piggyback). Dies funktioniert so, dass
Daten, die vom GCP-Host abgerufen wurden, an diese Piggyback-Hosts, die
ohne eigene Monitoring-Agenten arbeiten, verteilt werden. Dabei wird
jeder VM-Instanz ein Piggyback-Host zugeordnet. Die Namen dieser
Piggyback-Hosts setzen sich aus der ID Ihres Projekts, einem Unterstrich
und dem vollständigen Namen der Instanz zusammen. Wenn Ihr Projekt
beispielsweise die Projekt-ID `my-project-19001216` trägt und Sie dann
eine VM mit dem Namen `my-instance01` überwachen, heißt der
Piggyback-Host `my-project-19001216_my-instance01`. Legen Sie diese
Hosts entweder von Hand an oder - falls möglich - überlassen Sie diese
Aufgabe der dynamischen Host-Verwaltung.
:::

:::::::::::: sect3
#### []{#_dynamische_host_verwaltung_einrichten .hidden-anchor .sr-only}Dynamische Host-Verwaltung einrichten {#heading__dynamische_host_verwaltung_einrichten}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Als Nutzer einer
unserer kommerziellen Editionen können Sie die Erstellung und Löschung
von Hosts für Ihre VM-Instanzen einfach der [dynamischen
Host-Verwaltung](dcd.html) überlassen. Der Menüeintrag [Setup \> Hosts
\> Dynamic host management]{.guihint} bringt Sie zur Übersichtsseite
aller bereits konfigurierten Verbindungen. Klicken Sie hier auf [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add
connection]{.guihint} und geben Sie der Verbindung anschließend eine
[ID]{.guihint} und einen [Title.]{.guihint}
:::

::: paragraph
Im Folgenden werden nicht alle Optionen der [Connection
properties]{.guihint} behandelt. Konsultieren Sie bei Fragen die
Inline-Hilfe und den oben verlinkten Hauptartikel.
:::

::: paragraph
Stellen Sie zuerst sicher, dass für den Kasten [Connection
properties]{.guihint} der
[Show-more-Modus](intro_gui.html#show_less_more) aktiviert ist, damit
alle verfügbaren Optionen angezeigt werden.
:::

::: paragraph
Klicken Sie als nächstes unter [Piggyback creation options]{.guihint}
auf [Add new element]{.guihint}. Passen Sie den Ordner an, in dem die
Hosts Ihrer VM-Instanzen erstellt werden sollen. Die vorausgewählten
[Host attributes]{.guihint} sind für Piggyback-Hosts im Grunde korrekt
und bedürfen eher nicht der Anpassung.
:::

::: paragraph
Mit dem Aktivieren der Option [Delete vanished hosts]{.guihint} können
Sie dafür sorgen, dass Piggyback-Hosts, für die über einen bestimmten
Zeitraum keine frischen Daten mehr kommen, automatisch wieder gelöscht
werden.
:::

::: paragraph
Im Rahmen der Überwachung Ihrer GCP-Projekte sollte die Option [Restrict
source hosts]{.guihint} aktiviert werden. Tragen Sie hier Ihren GCP-Host
aus dem Abschnitt [Host für GCP in Checkmk anlegen](#create_host) ein.
:::

::: paragraph
Eine exemplarische Konfiguration der Verbindung könnte dann so aussehen:
:::

:::: imageblock
::: content
![Exemplarische Konfiguration der Connection
Properties.](../images/monitoring_gcp_connection_properties.png)
:::
::::
::::::::::::

:::::::::: sect3
#### []{#_hosts_für_vm_instanzen_manuell_anlegen .hidden-anchor .sr-only}Hosts für VM-Instanzen manuell anlegen {#heading__hosts_für_vm_instanzen_manuell_anlegen}

::: paragraph
Alternativ können Sie Hosts für die Piggyback-Daten auch manuell
anlegen. Dabei ist es wichtig, dass die Namen der Hosts exakt dem [oben
beschriebenen Schema](#vm-hosts) entsprechen.
:::

::: paragraph
**Tipp:** Mit dem Skript `find_piggy_orphans` aus dem
Treasures-Verzeichnis finden Sie alle Piggyback-Hosts, für die es zwar
Daten gibt, die aber noch nicht als Hosts in Checkmk angelegt sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/doc/check_mk/treasures/find_piggy_orphans
my-project-19001216_my-instance01
my-project-19001216_my-instance02
```
:::
::::

::: paragraph
Konfigurieren Sie die Hosts für diese Compute Engine VMs ohne IP-Adresse
(analog zum GCP-Host) und wählen Sie als Monitoring-Agent [No API
integrations, no Checkmk agent]{.guihint} aus. Wenn Sie unter
[Piggyback]{.guihint} auch noch die Option [Always use and expect
piggyback data]{.guihint} wählen, werden Sie beim Ausbleiben der Daten
entsprechend gewarnt.
:::

:::: imageblock
::: content
![monitoring gcp add host for piggyback
data](../images/monitoring_gcp_add_host_for_piggyback_data.png)
:::
::::
::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#_diagnosemöglichkeiten .hidden-anchor .sr-only}5. Diagnosemöglichkeiten {#heading__diagnosemöglichkeiten}

::::::::::: sectionbody
:::::::::: sect2
### []{#_der_service_exceptions .hidden-anchor .sr-only}5.1. Der Service Exceptions {#heading__der_service_exceptions}

::: paragraph
Um Sie bei der Einrichtung des GCP-Monitorings zu unterstützen und auch
zukünftig bei Problemen in der Kommunikation mit der Google Cloud API zu
helfen, gibt es den Service [Exceptions]{.guihint}. Hier werden alle
Fehlermeldungen, welche die Google Cloud API an den Spezialagenten
zurückliefert, gesammelt und aufbereitet. Im Fehlerfall wird dieser
Service standardmäßig [CRIT]{.state2} und gibt bereits in der
[Summary]{.guihint} einen Hinweis darauf, wo das Problem liegt.
:::

:::: imageblock
::: content
![monitoring gcp exceptions](../images/monitoring_gcp_exceptions.png)
:::
::::

::: paragraph
Nach einem Klick auf den Namen des Services erhalten Sie dann eine sehr
detaillierte Meldung, die oft einen Link an genau die Stelle in Ihrem
GCP-Projekt enthält, an der es beispielsweise einer anderen Einstellung
bedarf. In folgendem Beispiel ist die [Cloud Asset API]{.guihint} im
überwachten Projekt deaktiviert.
:::

:::: imageblock
::: content
![monitoring gcp exceptions
details](../images/monitoring_gcp_exceptions_details.png)
:::
::::

::: paragraph
Ein Klick auf den WWW-Globus [![icon
link](../images/icons/icon_link.png)]{.image-inline} bringt Sie dann
genau auf die Seite in Ihrem Projekt, auf der sich diese API aktivieren
lässt.
:::
::::::::::
:::::::::::
::::::::::::

::::::::::: sect1
## []{#dashboards .hidden-anchor .sr-only}6. Dashboards {#heading_dashboards}

:::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Zum komfortablen
Einstieg in die Überwachung von GCP liefert Checkmk ab Checkmk Cloud die
beiden eingebauten [Dashboards](glossar.html#dashboard) [GCP GCE
instances]{.guihint} und [GCP storage buckets]{.guihint} mit aus. Beide
finden Sie im Monitoring als Menüeinträge unter [Monitor \>
Cloud.]{.guihint}
:::

::: paragraph
Damit Sie einen direkten Eindruck bekommen, finden Sie nachfolgend zwei
Beispiele, wie diese Dashboards aufgebaut sind. Zuerst das Dashboard zu
den Compute-Engine-Instanzen, bei der Sie auf der linken Seite den
aktuellen Zustand und auf der rechten Seite den zeitlichen Verlauf der
wichtigsten Metriken vergleichen können:
:::

:::: imageblock
::: content
![Dashboard zu den GCP
Compute-Engine-Instanzen.](../images/monitoring_gcp_dashboard_vm.png)
:::
::::

::: paragraph
Das Dashboard zu den Storage Buckets ist ganz ähnlich aufgebaut. Auf der
linken Seite finden Sie aktuelle Daten der jeweiligen Buckets. Auf der
rechten werden wieder die wichtigsten Metriken im zeitlichen Verlauf
dargestellt:
:::

:::: imageblock
::: content
![Dashboard zu den GCP Storage
Buckets.](../images/monitoring_gcp_dashboard_storage.png)
:::
::::
::::::::::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
