:::: {#header}
# OpenShift überwachen

::: details
[Last modified on 01-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_openshift.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Docker
überwachen](monitoring_docker.html) [Kubernetes
überwachen](monitoring_kubernetes.html) [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#_vorwort .hidden-anchor .sr-only}1. Vorwort {#heading__vorwort}

:::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Für die
Einrichtung der Überwachung von Kubernetes und diversen
Geschmacksrichtungen davon gibt es bereits einen [eigenen
Artikel](monitoring_kubernetes.html). Da OpenShift im Allgemeinen und
die Einrichtung im Speziellen allerdings etwas anders funktionieren,
haben wir uns für die Beschreibung der Einrichtung der Überwachung von
OpenShift beziehungsweise der darin betriebenen Kubernetes-Cluster für
einen eigenen Artikel entschieden. Im weiteren Verlauf dieses Artikels
nennen wir eben diese Cluster - aus Gründen der Lesbarkeit und der
Einfachheit halber - OpenShift-Cluster. Das Monitoring von
OpenShift-Clustern ist nur mit einer der kommerziellen Editionen von
Checkmk möglich.
:::
::::
:::::

:::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}2. Einleitung {#heading__einleitung}

::::::::::: sectionbody
::: paragraph
Checkmk unterstützt Sie bei der Überwachung Ihrer OpenShift-Cluster. Ab
Version [2.3.0]{.new} können Sie mit jeder unserer kommerziellen
Editionen die folgenden Objekte überwachen:
:::

::: ulist
- Cluster

- Deployments

- Nodes

- Pods

- DaemonSets

- StatefulSets

- CronJobs
:::

::: paragraph
Eine vollständige Auflistung aller verfügbaren Check-Plugins für die
Überwachung von Kubernetes finden Sie in unserem [Katalog der
Check-Plugins.](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=kube_){target="_blank"}
:::

:::: sect2
### []{#_aufbau_der_monitoring_umgebung .hidden-anchor .sr-only}2.1. Aufbau der Monitoring-Umgebung {#heading__aufbau_der_monitoring_umgebung}

::: paragraph
Da es in OpenShift-Cluster sehr schnell auch zu größeren Veränderungen
kommen kann, was die Anzahl und Verortung der einzelnen Komponenten
angeht, empfehlen wir für das Monitoring Ihrer OpenShift-Umgebung eine
eigene Checkmk-Instanz zu erstellen. Diese können Sie dann wie üblich
über das [verteilte Monitoring](distributed_monitoring.html) an Ihre
Zentralinstanz anbinden.
:::
::::

::::: sect2
### []{#_ablauf_des_openshift_monitorings_in_checkmk .hidden-anchor .sr-only}2.2. Ablauf des OpenShift-Monitorings in Checkmk {#heading__ablauf_des_openshift_monitorings_in_checkmk}

::: paragraph
Checkmk überwacht Ihre OpenShift-Cluster auf zwei Wegen:
:::

::: ulist
- Grundlegende Informationen holt sich Checkmk direkt über die
  Kubernetes-API bei Ihrem Cluster ab. Hierüber lassen sich bereits die
  Zustände von Nodes und Containern abrufen. Auch die meisten Metadaten
  über Ihre Pods und Deployment werden auf diesem Wege gewonnen. Für ein
  umfängliches Monitoring fehlt bis zum diesem Punkt allerdings noch
  etwas. Die Fragen, wie viel Last beispielsweise ein bestimmtes
  Deployment auf der CPU erzeugt, oder wie viel Arbeitsspeicher ein
  DaemonSet gerade bindet, lassen sich so nicht beantworten.

- Da in OpenShift-Cluster standardmäßig bereits Prometheus installiert
  ist, kann Checkmk genau diese Prometheus-Instanz innerhalb Ihrer
  OpenShift-Umgebung abfragen und die so gewonnenen Daten für Sie in
  gewohnter Checkmk-Manier aufbereiten. Für ein vollumfängliches
  Monitoring Ihrer OpenShift-Umgebung empfehlen wir unbedingt diese
  Anbindung einzurichten. Auch ist die Verwendung der
  [Kubernetes-Dashboards](#dashboards) nur dann sinnvoll, wenn die
  entsprechenden Daten zur Auslastung vorliegen.
:::
:::::
:::::::::::
::::::::::::

:::::::::::::::::::::::::::::::::::::: sect1
## []{#_voraussetzungen_im_cluster_schaffen .hidden-anchor .sr-only}3. Voraussetzungen im Cluster schaffen {#heading__voraussetzungen_im_cluster_schaffen}

::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Um Ihre OpenShift-Umgebung in Checkmk überwachen zu können, schaffen Sie
zuerst die Voraussetzungen in Ihrem Cluster.
:::

::::::::::: sect2
### []{#_namespace_und_service_account_anlegen .hidden-anchor .sr-only}3.1. Namespace und Service-Account anlegen {#heading__namespace_und_service_account_anlegen}

::: paragraph
Zuerst müssen Sie in Ihrem OpenShift-Cluster einen Namespace und einen
Service-Account für Checkmk einrichten. Am schnellsten lässt sich das
über die OpenShift CLI (kurz: `oc`) bewerkstelligen.
:::

::: paragraph
Im folgenden Beispiel nennen wir diesen Namespace `checkmk-monitoring`.
Sollten Sie einen anderen Namen wählen wollen oder müssen, dann müssen
Sie diese Änderung auch in bei der Erzeugung des Service-Account
vornehmen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc create namespace checkmk-monitoring
namespace/checkmk-monitoring created
```
:::
::::

::: paragraph
Den Service-Account mit der zugehörigen Rolle und der sogenannten
RoleBinding, können Sie durch die Angabe einer von uns vorgefertigten
und [auf GitHub veröffentlichten
YAML-Datei](https://github.com/Checkmk/checkmk_kube_agent/blob/checkmk_docs/deploy/kubernetes/checkmk-serviceaccount.yaml){target="_blank"}
vornehmen. Prüfen Sie deren Inhalt und führen Sie anschließend den
folgenden Befehl aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc apply -f https://raw.githubusercontent.com/Checkmk/checkmk_kube_agent/checkmk_docs/deploy/kubernetes/checkmk-serviceaccount.yaml
serviceaccount/checkmk created
clusterrole.rbac.authorization.k8s.io/checkmk-metrics-reader created
clusterrolebinding.rbac.authorization.k8s.io/checkmk-metrics-reader-binding created
```
:::
::::

::: paragraph
Alternativ können Sie diese YAML-Datei auch zuerst herunterladen, nach
Ihren Bedürfnissen anpassen und anschließend `oc apply -f` auf Ihre
lokale Kopie anwenden.
:::
:::::::::::

:::::::::::::::::::::::::: sect2
### []{#_api_endpunkte_token_und_zertifikat_besorgen .hidden-anchor .sr-only}3.2. API-Endpunkte, Token und Zertifikat besorgen {#heading__api_endpunkte_token_und_zertifikat_besorgen}

::: paragraph
Mit dem Kommandozeilen-Tool `oc` können Sie nun auch alle Informationen
aus Ihrem Cluster auslesen, welche Sie in der Regel zur Einrichtung des
Spezialagenten angeben müssen. Wenn Sie den den Namen des
Service-Account oder den Namespace verändert haben, müssen diese Angaben
in der folgenden Befehlen entsprechend anpassen.
:::

::::::: sect3
#### []{#get_kubernetes_endpoint .hidden-anchor .sr-only}Kubernetes-API-Endpunkt auslesen {#heading_get_kubernetes_endpoint}

::: paragraph
Den Endpunkt der Kubernetes-API zeigt `oc` mit dem folgenden Befehl an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc cluster-info
Kubernetes control plane is running at https://api.myopenshift.example.com:6443
```
:::
::::

::: paragraph
Diese Adresse inklusive des angegebenen Ports gehört in der
[Kubernetes-Regel](#rule) später in das Feld [API server connection \>
Endpoint]{.guihint}.
:::
:::::::

:::::::: sect3
#### []{#get_prometheus_endpoint .hidden-anchor .sr-only}Prometheus-API-Endpunkt auslesen {#heading_get_prometheus_endpoint}

::: paragraph
Die Adresse vom API-Endpunkt der Prometheus-Instanz in Ihrem Cluster
herauszufinden, kann womöglich über die GUI von OpenShift einfacher
sein. In der Rolle des Administrators finden Sie über [Networking \>
Routes]{.guihint} eine mehr oder weniger lange Liste. Hier sollte sich
auch eine Route finden, die vermutlich das Wort Prometheus in Ihrem
Namen trägt. Auch das hängt schlicht von der Konfiguration Ihres
OpenShift-Cluster ab. Unter Location finden Sie dann eben die URL, die
Sie später für das Feld [Prometheus API endpoint]{.guihint} benötigen.
:::

::: paragraph
Mit dem folgenden Befehl können Sie die FQDN womöglich auch auf der
Kommandozeile ermitteln.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc get routes --all-namespaces | grep prometheus
openshift-monitoring    prometheus-k8s   prometheus-k8s-openshift-monitoring.apps.myopenshift.example.com   prometheus-k8s  web  reencrypt/Redirect   None
```
:::
::::

::: paragraph
Dem String
`prometheus-k8s-openshift-monitoring.apps.myopenshift.example.com`
müssen Sie dann später in der [Kubernetes-Regel](#rule) im Feld
[Prometheus API endpoint]{.guihint} nur noch das Protokoll voranstellen.
:::
::::::::

::::::: sect3
#### []{#get_token .hidden-anchor .sr-only}Token auslesen {#heading_get_token}

::: paragraph
Um das Token auszulesen, welches Sie später in Checkmk in der Regel für
den Spezialagenten angeben müssen, können Sie den folgenden Befehl
verwenden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc get secret $(oc describe sa checkmk -n checkmk-monitoring | grep 'Tokens' | awk '{ print $2 }') -n checkmk-monitoring -o=jsonpath='{.data.token}' | base64 --decode
eyJhbGciOiJSUzI1NiIsImtpZCI6IkxFbDdZb25t...
```
:::
::::

::: paragraph
Lassen Sie die Shell mit diesen Informationen geöffnet oder kopieren Sie
das Token an einen Ort, auf den Sie während der folgenden Einrichtung in
Checkmk zugreifen können.
:::
:::::::

:::::::: sect3
#### []{#get_certificate .hidden-anchor .sr-only}Zertifikat auslesen {#heading_get_certificate}

::: paragraph
Um das Zertifikat auszulesen, welches Sie später in Checkmk in den
[Global settings]{.guihint} angeben müssen, können Sie den folgenden
Befehl verwenden
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc get secret $(oc describe sa checkmk -n checkmk-monitoring | grep 'Tokens' | awk '{ print $2 }') -n checkmk-monitoring -o=jsonpath='{.data.ca\.crt}' | base64 --decode
```
:::
::::

::: paragraph
Lassen Sie die Shell mit diesen Informationen geöffnet oder kopieren Sie
das Zertifikat -- inklusive der Zeilen `BEGIN CERTIFICATE` und
`END CERTIFICATE` -- an einen Ort, auf den Sie während der folgenden
Einrichtung in Checkmk zugreifen können.
:::

::: paragraph
Sollte die Ausgabe leer sein, gilt der gleiche Hinweis, wie im Abschnitt
[Token auslesen.](#get_token)
:::
::::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setupincheckmk .hidden-anchor .sr-only}4. Monitoring in Checkmk einrichten {#heading_setupincheckmk}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Als nächstes geht es in der GUI von Checkmk an die Einrichtung des
[Spezialagenten](glossar.html#special_agent) und einer Regel für die
automatische Erzeugung von Hosts für Ihre Kubernetes-Objekte. Für die
Einrichtung des Spezialagenten müssen aber zuerst noch einige
Voraussetzungen erfüllt werden:
:::

::::::: sect2
### []{#token .hidden-anchor .sr-only}4.1. Passwort (Token) in Checkmk hinterlegen {#heading_token}

::: paragraph
Das [Passwort (Token) des Service-Accounts](#get_token) hinterlegen Sie
am besten im Passwortspeicher von Checkmk. Das ist die sicherste
Variante, da Sie Hinterlegung und Benutzung des Passworts
organisatorisch trennen können. Alternativ geben Sie es beim Anlegen der
Regel (siehe weiter unten) direkt im Klartext ein.
:::

::: paragraph
Um das Passwort in den Checkmk-Passwortspeicher einzufügen, navigieren
Sie zu [Setup \> General \> Passwords \> Add password]{.guihint}. Wir
verwenden für unser Beispiel als ID und Titel `My OpenShift Token`:
:::

:::: imageblock
::: content
![kubernetes password](../images/kubernetes_password.png)
:::
::::
:::::::

:::::: sect2
### []{#certimport .hidden-anchor .sr-only}4.2. CA-Zertifikat des Service-Accounts in Checkmk importieren {#heading_certimport}

::: paragraph
Damit Checkmk der [Zertifikatskette des
Service-Accounts](#get_certificate) vertrauen kann, müssen Sie diese in
Checkmk hinterlegen. Kopieren Sie hier alles -- inklusive der Zeilen,
die `BEGIN CERTIFICATE` und `END CERTIFICATE` enthalten -- und fügen Sie
das Zertifikat im Setup-Menü unter [Setup \> General \> Global settings
\> Site management \> Trusted certificate authorities for SSL]{.guihint}
hinzu:
:::

:::: imageblock
::: content
![kubernetes ca](../images/kubernetes_ca.png)
:::
::::
::::::

:::::: sect2
### []{#source-host .hidden-anchor .sr-only}4.3. Piggyback Quell-Host anlegen {#heading_source-host}

::: paragraph
Erzeugen Sie in Checkmk auf gewohnte Weise einen neuen Host und nennen
Sie diesen beispielsweise `myopenshiftclusterhost`. Wie Überschrift und
Host-Name schon nahelegen, dient dieser Host dazu, die
[Piggyback-Daten](glossar.html#piggyback) zu sammeln und außerdem alle
Services und Metriken auf Cluster-Ebene abzubilden. Da dieser Host
ausschließlich über den Spezialagenten Daten erhält, setzen Sie in den
Eigenschaften des Hosts die Option [IP address family]{.guihint}
unbedingt auf [No IP]{.guihint}. Bestätigen Sie das Ganze mit einem
Druck auf den Knopf [Save & view folder]{.guihint}.
:::

:::: imageblock
::: content
![Beispielhafte Einrichtung eines Cluster-Hosts mit der wichtigen
Einstellung \'No
IP\'.](../images/monitoring_openshift_add_host_no_ip.png)
:::
::::
::::::

::::::::::::: sect2
### []{#_dynamische_host_konfiguration_einrichten .hidden-anchor .sr-only}4.4. Dynamische Host-Konfiguration einrichten {#heading__dynamische_host_konfiguration_einrichten}

::: paragraph
Um eine Trennung zwischen den Objekten verschiedener Kubernetes-Cluster
zu gewährleisten, ist es meist praktisch, über [Setup \> Hosts \> Add
folder]{.guihint} pro Cluster einen Ordner anzulegen, in welchem die
[dynamische Host-Konfiguration](dcd.html) automatisch alle Hosts eines
Clusters anlegen kann. Einen solchen Ordner zu erzeugen und zu nutzen
ist aber optional.
:::

::: paragraph
Als nächstes richten Sie einen Konnektor für die anfallenden
Piggyback-Daten ein. Navigieren Sie hierfür zu [Setup \> Hosts \>
Dynamic host management \> Add connection.]{.guihint} Tragen Sie zuerst
einen Titel ein und klicken Sie anschließend unter [Connection
Properties]{.guihint} auf [show more]{.guihint}.
:::

::: paragraph
Als nächstes ist es sehr wichtig unter [Restrict source hosts]{.guihint}
den zuvor angelegten [Piggyback Quell-Host](#source-host) einzutragen.
:::

::: paragraph
Klicken Sie anschließend unter [Piggyback creation options]{.guihint}
auf [Add new element]{.guihint} und wählen Sie unter [Create hosts
in]{.guihint} den zuvor angelegten Ordner aus.
:::

::: paragraph
Die voreingestellten Attribute unter [Host attributes to set]{.guihint}
können Sie so belassen. Sie sorgen dafür, dass sich Checkmk bei den
automatisch angelegten Hosts ausschließlich an die Piggyback-Daten hält
und nicht versucht. diese beispielsweise zu pingen oder per SNMP zu
erreichen.
:::

::: paragraph
In einer OpenShift-Umgebung, in der überwachbare und überwachte Objekte
kontinuierlich kommen und gehen, empfiehlt es sich meist, auch die
Option [Automatically delete hosts without piggyback data]{.guihint} zu
aktivieren. Was genau diese Option bewirkt und unter welchen Umständen
Hosts dann tatsächlich gelöscht werden, erklären wir im Kapitel
[Automatisches Löschen von Hosts](dcd.html#automatic_deletion_of_hosts)
im Artikel zur dynamischen Host-Konfiguration.
:::

::: paragraph
Aktivieren Sie abschließend noch die Option [Discover services during
creation]{.guihint}.
:::

::: paragraph
Der Abschnitt [Connection Properties]{.guihint} dieses neuen Konnektors
könnte im Anschluss wie folgt aussehen:
:::

:::: imageblock
::: content
![Beispielhafte Einstellungen einer dynamischen
Host-Konfiguration.](../images/monitoring_openshift_connection_properties.png)
:::
::::
:::::::::::::

::::::::: sect2
### []{#_periodische_service_erkennung_anpassen .hidden-anchor .sr-only}4.5. Periodische Service-Erkennung anpassen {#heading__periodische_service_erkennung_anpassen}

::: paragraph
Standardmäßig führt Checkmk alle zwei Stunden eine Service-Erkennung
durch und zeigt das Ergebnis dieser Erkennung im Service [Check_MK
Discovery]{.guihint} an. Sie finden diese Einstellung im Regelsatz
[Periodic service discovery]{.guihint}. Im Kontext von OpenShift
empfehlen wir eine Regel für alle Hosts mit dem Label
`cmk/kubernetes:yes` zu erstellen. Dieses Label erhält nämlich jeder
Host, der Kubernetes-Objekte repräsentiert, automatisch von Checkmk. Sie
sollten hier ein kleineres Intervall als zwei Stunden für die
Service-Erkennung wählen und auch die Option [Automatically update
service configuration]{.guihint} aktivieren. Die Einstellungen im
folgenden Screenshot sind nur exemplarisch. Was für Ihre Cluster
sinnvoll ist, müssen Sie von Fall zu Fall entscheiden.
:::

:::: imageblock
::: content
![Exemplarische Einrichtung der periodischen Service-Erkennung für
Kubernetes-Objekte.](../images/monitoring_kubernetes_periodic_service_discovery.png)
:::
::::

::: paragraph
Um diese Regel auf alle Hosts Ihrer Cluster zu beschränken, genügt es
bei den [Conditions]{.guihint} unter [Host labels]{.guihint}
`cmk/kubernetes:yes` einzutragen. Wollen Sie jedoch für verschiedene
Cluster auch verschiedene Regeln erstellen, verwenden Sie hier einfach
das jeweilige Cluster-spezifische Label. Diese Labels haben immer die
Form `cmk/kubernetes/cluster:mycluster`.
:::

:::: imageblock
::: content
![Exemplarische Einschränkung auf Hosts mit einem Cluster-spezifischen
Label.](../images/monitoring_kubernetes_periodic_service_discovery_conditions.png)
:::
::::
:::::::::

::::::::::::::::::::::::::::::: sect2
### []{#rule .hidden-anchor .sr-only}4.6. Spezialagent einrichten {#heading_rule}

::: paragraph
Nachdem nun alle Voraussetzungen im Cluster und in Checkmk geschaffen
sind, können Sie sich der Konfiguration des Spezialagenten widmen. Diese
finden Sie über [Setup \> Agents \> VM, cloud, container \>
Kubernetes]{.guihint}. Erstellen Sie mit [Add rule]{.guihint} eine neue
Regel.
:::

::: paragraph
Zuallererst müssen Sie einen Namen für den zu überwachenden Cluster
vergeben. Diesen Namen können Sie frei wählen. Er dient dazu, alle
Objekte, die aus genau diesem Cluster stammen, mit einem eindeutigen
Namen zu versehen. Wenn Sie hier beispielsweise `mycluster` eintragen,
werden die Namen der Hosts aller Pods aus diesem Cluster später mit
`pod_mycluster` beginnen. Der nächste Teil des Host-Namens wird dann
immer der Namespace sein, in dem dieses Kubernetes-Objekt existiert. Der
Host-Name eines Pods könnte dann beispielsweise
`pod_mycluster_kube-system_svclb-traefik-8bgw7` lauten.
:::

::: paragraph
Wählen Sie unter [Token]{.guihint} nun den [zuvor angelegten
Eintrag](#token) aus dem Passwortspeicher von Checkmk aus.
:::

:::: imageblock
::: content
![Beispielhafter Cluster-Name und Auswahl des
Tokens.](../images/monitoring_openshift_cluster_name_and_token.png)
:::
::::

::: paragraph
Unter [API server connection \> Endpoint]{.guihint} verlangt Checkmk nun
die Eingabe der URL über welche Ihr Kubernetes API-Server erreichbar
ist. Die Angabe des Ports ist nur notwendig, wenn der Dienst nicht über
einen virtuellen Host bereitgestellt wird. Tragen Sie hier die Adresse
ein, welche Sie im Abschnitt [Kubernetes-API-Endpunkt
auslesen](#get_kubernetes_endpoint) ermittelt haben.
:::

::: paragraph
Wenn Sie diese Anleitung bisher Schritt für Schritt befolgt haben und
das CA-Zertifikat Ihres Clusters - [wie oben beschrieben](#certimport) -
in Checkmk hinterlegt haben, wählen Sie unter [SSL certificate
verification]{.guihint} den Eintrag [Verify the certificate]{.guihint}
aus.
:::

:::: imageblock
::: content
![Exemplarische Angabe der API-Server
Verbindung.](../images/monitoring_openshift_rule_api_server_connection.png)
:::
::::

::: paragraph
Aktivieren Sie die Option [Enrich with usage data]{.guihint}, wählen Sie
im folgenden Menü [Use data from OpenShift]{.guihint} und tragen Sie den
[Prometheus API endpoint]{.guihint} ein, den Sie im Abschnitt
[Prometheus-API-Endpunkt auslesen](#get_prometheus_endpoint) ermittelt
haben.
:::

:::: imageblock
::: content
![Exemplarische Angabe der Cluster Collector
Verbindung.](../images/monitoring_openshift_rule_enrich.png)
:::
::::

::: paragraph
Die Liste unter [Collect information about...​]{.guihint} erlaubt Ihnen
noch die Auswahl, welche Objekte innerhalb Ihres Cluster überwacht
werden sollen. Unsere Vorauswahl deckt hier die relevantesten Objekte
ab. Sollten Sie sich dazu entscheiden auch die [Pods of
CronJobs]{.guihint} zu überwachen, so beachten Sie die
[Inline-Hilfe](user_interface.html#inline_help) zu diesem Punkt.
:::

:::: imageblock
::: content
![Exemplarische Auswahl überwachbarer
Kubernetes-Objekte.](../images/monitoring_openshift_rule_collect_info_about.png)
:::
::::

::: paragraph
Mit den nächsten beiden Auswahlmöglichkeiten können Sie die zu
überwachenden Objekte weiter eingrenzen. Falls Sie sich nur für die
Objekte aus bestimmten Namespaces interessieren, stellen Sie dies
entsprechend unter [Monitor namespaces]{.guihint} ein. Hier können Sie
entweder einzelne Namespaces eintragen, die überwacht werden sollen,
oder aber einzelne Namespaces explizit vom Monitoring ausschließen.
:::

::: paragraph
Mit der Option [Cluster resource aggregation]{.guihint} können Sie Nodes
benennen, welche keine Ressourcen für die Arbeitslast Ihres Clusters zur
Verfügung stellen. Diese Nodes sollten aus der Berechnung der zur
Verfügung stehenden Ressourcen ausgenommen werden. Ansonsten besteht die
Gefahr, dass Kapazitätsengpässe nicht erkannt werden. Standardmäßig
nehmen wir daher bereits die Nodes `control-plane` und `infra` aus der
Berechnung heraus.
:::

:::: imageblock
::: content
![Beispielhafte Konfiguration für Namensräume und
Ressourcen-Aggregation](../images/monitoring_openshift_namespaces_and_resource_aggregation.png)
:::
::::

::: paragraph
Als letzte Option können Sie noch sogenannte *Annotations* aus
Kubernetes importieren. In Checkmk werden diese Annotations zu
[Host-Labels](glossar.html#label) und können somit als Bedingungen in
Regeln weiterverwendet werden. Welche Annotations importiert werden
sollen, können Sie über reguläre Ausdrücke festlegen. Konsultieren Sie
an dieser Stelle erneut die ausführliche Inline-Hilfe.
:::

::: paragraph
**Hinweis:** Die Option [Import all valid annotations]{.guihint} bieten
wir an dieser Stelle nur der Vollständigkeit halber an. Wir raten davon
ab, einfach unbesehen *alle* Annotations zu importieren, weil hierdurch
mitunter ein sehr großer Berg nutzloser Labels in Checkmk erzeugt wird.
:::

::: paragraph
**Wichtig:** Unter [Conditions \> Explicit hosts]{.guihint} **müssen**
Sie nun den [zuvor angelegten Host](#source-host) eintragen:
:::

:::: imageblock
::: content
![Regeln für Spezialagenten müssen, wie hier zu sehen, immer auf
explizite Hosts festgelegt
werden.](../images/monitoring_openshift_explicit_hosts.png)
:::
::::

::: paragraph
Speichern Sie anschließend die Regel und führen Sie eine
Service-Erkennung für diesen Host durch. Sie werden hier gleich die
ersten Services auf Cluster-Ebene sehen:
:::

:::: imageblock
::: content
![Exemplarische Ansicht der ersten Service-Erkennung nach Abschluss der
Konfiguration.](../images/monitoring_openshift_service_discovery.png)
:::
::::

::: paragraph
Aktivieren Sie im Anschluss alle vorgenommenen Änderungen und überlassen
Sie ab jetzt der dynamischen Host-Konfiguration die Arbeit. Diese wird
schon nach kurzer Zeit alle Hosts für Ihre Kubernetes-Objekte erzeugen.
:::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::: sect1
## []{#_labels_für_kubernetes_objekte .hidden-anchor .sr-only}5. Labels für Kubernetes-Objekte {#heading__labels_für_kubernetes_objekte}

:::: sectionbody
::: paragraph
Checkmk erzeugt Labels für Objekte wie Cluster, Deployments oder
Namespaces während der Service-Erkennung automatisch. Alle Labels zu
diesen Objekten, die Checkmk automatisch erzeugt, beginnen mit
`cmk/kubernetes/`. Ein Pod erhält beispielsweise immer ein Label der
Node (`cmk/kubernetes/node:mynode`), ein Label, welches eben zeigt, dass
es sich bei diesem Objekt um einen Pod handelt
(`cmk/kubernetes/object:pod`) und ein Label für den Namespace
(`cmk/kubernetes/namespace:mynamespace`). So lassen sich in der Folge
sehr einfach Filter und Regeln für alle Objekte gleichen Typs bzw. im
gleichen Namespace erstellen.
:::
::::
:::::

:::::::::::::::::: sect1
## []{#_dashboards_und_ansichten .hidden-anchor .sr-only}6. Dashboards und Ansichten {#heading__dashboards_und_ansichten}

::::::::::::::::: sectionbody
::::::::::: sect2
### []{#dashboards .hidden-anchor .sr-only}6.1. Kubernetes-Dashboards {#heading_dashboards}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen von Checkmk werden mit sechs eingebauten Dashboards für
Kubernetes ausgeliefert. Um diese Dashboards sinnvoll verwenden zu
können, ist es notwendig, dass unser Cluster Collector installiert und
konfiguriert ist. Im einzelnen heißen diese Dashboards:
:::

::: ulist
- Kubernetes (Overview)

- Kubernetes Cluster

- Kubernetes DaemonSet

- Kubernetes Deployment

- Kubernetes Namespace

- Kubernetes StatefulSet
:::

::: paragraph
Der Einstieg geschieht dabei immer über das Dashboard
[Kubernetes]{.guihint}, welches Sie über [Monitor \> Applications \>
Kubernetes]{.guihint} erreichen:
:::

:::: imageblock
::: content
![Exemplarische Ansicht des
Übersichts-Dashboards.](../images/monitoring_kubernetes_kubernetes_dashboard.png)
:::
::::

::: paragraph
Im Dashboard [Kubernetes]{.guihint} werden auf der linken Seite alle
Ihre überwachten Cluster aufgelistet. Diese Auflistung der Cluster ist
auch Ihr Einstieg, um sich tiefer in die Dashboards zu bohren. Mit einem
Klick auf den Namen eines Clusters gelangen Sie in das Dashboard
[Kubernetes Cluster]{.guihint} des angewählten Clusters. Im Dashboard
[Kubernetes Cluster]{.guihint} führt ein Klick auf den jeweiligen Namen
dann in die übrigen kontextabhängigen Dashboards:
:::

:::: imageblock
::: content
![Ausschnitt des Cluster-Dashboards mit Wegen in die weiteren
Dashboards.](../images/monitoring_kubernetes_cluster_dashboard.png)
:::
::::
:::::::::::

::::::: sect2
### []{#_hardware_software_inventur .hidden-anchor .sr-only}6.2. Hardware-/Software-Inventur {#heading__hardware_software_inventur}

::: paragraph
Die Überwachung von OpenShift mit Checkmk unterstützt auch die
[HW-/SW-Inventur.](inventory.html) Wenn Sie beispielsweise in dem obigen
Cluster-Dashboard auf den großen Namen des Clusters (hier:
[mycluster]{.guihint}) klicken, gelangen Sie zur Inventur des Clusters.
:::

::: paragraph
Auf dem gleichen Weg, also über die Boxen mit den großen Namen der
Objekte, gelangen Sie auch in den anderen Dashboards zur Inventur des
jeweiligen Objekts. Im folgenden Beispiel sehen Sie die HW-/SW-Inventur
eines Pods:
:::

:::: imageblock
::: content
![kubernetes monitoring hw sw
inventory](../images/kubernetes_monitoring_hw_sw_inventory.png){width="88% alt="
exemplarische="" ansicht="" der="" hardware-="" und=""
software-inventur="" eines="" pods=""}
:::
::::
:::::::
:::::::::::::::::
::::::::::::::::::

::::::::::::::: sect1
## []{#_prüfung_der_installation .hidden-anchor .sr-only}7. Prüfung der Installation {#heading__prüfung_der_installation}

:::::::::::::: sectionbody
::: paragraph
In der GUI von Checkmk können Sie die erfolgreiche Installation und
Konfiguration prüfen.
:::

::: paragraph
Die wichtigsten Services sind hier sicherlich [Kubernetes API]{.guihint}
und [Cluster collector]{.guihint}. Diese müssen auf dem von Ihnen
erstellten Cluster-Host vorhanden sein und sollten auch bestimmte
Informationen anzeigen.
:::

:::: imageblock
::: content
![Wichtigste Services zur Prüfung der korrekten
Installation](../images/monitoring_openshift_check_installation.png)
:::
::::

::: paragraph
Der Service [Kubernetes API]{.guihint} sollte im Normalfall unter
[Summary]{.guihint} [Live, Ready]{.guihint} vermelden und wenn der
Cluster Collector eingerichtet ist, wird dieser im Idealfall
[Successfully queried usage data from Prometheus]{.guihint} ausgeben.
:::

::: paragraph
Im Dashboard [Kubernetes]{.guihint} können Sie bereits sehr früh
erkennen, ob der Cluster Collector in einem Cluster läuft und Daten
sammelt. Bei korrekter Einrichtung sollte das Dashboard
[Kubernetes]{.guihint} in etwa so aussehen:
:::

:::: imageblock
::: content
![Kubernetes-Dashbaord mit Daten für CPU resources und Memory
resources](../images/monitoring_openshift_validation_dashboard.png)
:::
::::

::: paragraph
Wenn Sie hier nun auf den Namen des Clusters klicken, landen Sie im
Dashboard [Kubernetes Cluster]{.guihint} des jeweiligen Clusters. Hier
sollten die drei Boxen [Primary datasource]{.guihint}, [Cluster
collector]{.guihint} und [API health]{.guihint} grün sein und
[OK]{.guihint} anzeigen.
:::

:::: imageblock
::: content
![Funktionierendes
Cluster-Monitoring.](../images/monitoring_kubernetes_cluster_state.png)
:::
::::
::::::::::::::
:::::::::::::::

::::::::::: sect1
## []{#_monitoring_komponenten_aus_openshift_entfernen .hidden-anchor .sr-only}8. Monitoring-Komponenten aus OpenShift entfernen {#heading__monitoring_komponenten_aus_openshift_entfernen}

:::::::::: sectionbody
:::::: sect2
### []{#_service_account_löschen .hidden-anchor .sr-only}8.1. Service-Account löschen {#heading__service_account_löschen}

::: paragraph
Wenn Sie zur Erzeugung des Service-Accounts unsere vorgegebene
YAML-Datei verwendet haben, können Sie diesen wie folgt auch wieder
entfernen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc delete -f https://raw.githubusercontent.com/Checkmk/checkmk_kube_agent/checkmk_docs/deploy/kubernetes/checkmk-serviceaccount.yaml
serviceaccount "checkmk" deleted
clusterrole.rbac.authorization.k8s.io "checkmk-metrics-reader" deleted
clusterrolebinding.rbac.authorization.k8s.io "checkmk-metrics-reader-binding" deleted
```
:::
::::
::::::

::::: sect2
### []{#_namespace_entfernen_wenn_gewünscht .hidden-anchor .sr-only}8.2. Namespace entfernen, wenn gewünscht {#heading__namespace_entfernen_wenn_gewünscht}

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ oc delete namespace checkmk-monitoring
namespace "checkmk-monitoring" deleted
```
:::
::::
:::::
::::::::::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
