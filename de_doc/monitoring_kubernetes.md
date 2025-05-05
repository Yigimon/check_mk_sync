:::: {#header}
# Kubernetes überwachen

::: details
[Last modified on 31-May-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_kubernetes.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
überwachen](monitoring_docker.html) [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::::::::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![kubernetes logo](../images/kubernetes_logo.jpg){width="140"}
:::
::::

::: paragraph
Kubernetes ist seit geraumer Zeit das am meisten verwendete Werkzeug für
die Orchestrierung von Containern. Checkmk unterstützt Sie bei der
Überwachung Ihrer Kubernetes-Umgebungen.
:::

::: paragraph
Ab Version [2.1.0]{.new} können Sie mit Checkmk die folgenden
Kubernetes-Objekte überwachen:
:::

::: ulist
- Cluster

- Nodes

- Deployments

- Pods

- DaemonSets

- StatefulSets

- Persistent Volume Claims

- CronJobs (ab Checkmk [2.2.0]{.new})
:::

::: paragraph
Eine vollständige Auflistung aller verfügbaren Check-Plugins für die
Überwachung von Kubernetes finden Sie in unserem [Katalog der
Check-Plugins.](https://checkmk.com/de/integrations?tags=kubernetes){target="_blank"}
:::

:::::: sect2
### []{#_unterstützte_distributionen_und_versionen .hidden-anchor .sr-only}1.1. Unterstützte Distributionen und Versionen {#heading__unterstützte_distributionen_und_versionen}

::: paragraph
Beginnend mit Version [2.2.0]{.new} unterstützt Checkmk die folgenden
Distributionen bzw. Kubernetes-Dienste:
:::

::: ulist
- Vanilla Kubernetes

- Amazon Elastic Kubernetes Service (Amazon EKS)

- Azure Kubernetes Service (AKS)

- Google Kubernetes Engine (GKE) inkl. Autopilot-Modus

- [OpenShift](monitoring_openshift.html)

- Tanzu Kubernetes (ab Checkmk [2.2.0]{.new}p9)
:::

::: paragraph
Unser Ziel ist die Unterstützung der jeweils letzten 5 veröffentlichten
(Minor-)Versionen von Kubernetes. Wir unterstützen somit auch Versionen
von Kubernetes, die aus dem Lifecycle von (Vanilla) Kubernetes bereits
herausgefallen sind. Damit stellen wir vor allen Dingen die reibungslose
Zusammenarbeit mit denjenigen Cloud-Anbietern sicher, die für ihre
Dienste ebenfalls längere Support-Zeiträume anbieten. Unmittelbar nach
dem Release einer neuen Version von Kubernetes kann es --- je nach
Umfang der Neuerungen und Zeitpunkt --- etwas dauern, bis auch diese
vollständig in Checkmk unterstützt wird. Sobald Checkmk mit dieser neuen
Version reibungslos zusammenarbeiten kann, werden wir dies in einem Werk
(wie beispielsweise [Werk
#14584](https://checkmk.com/werk/14584){target="_blank"}) kundtun.
:::
::::::

:::: sect2
### []{#_einstieg_in_das_kubernetes_monitoring .hidden-anchor .sr-only}1.2. Einstieg in das Kubernetes-Monitoring {#heading__einstieg_in_das_kubernetes_monitoring}

::: paragraph
Für einen Einstieg in das neue Monitoring von Kubernetes empfehlen wir
unsere beiden Videos [Kubernetes Monitoring with
Checkmk](https://www.youtube.com/watch?v=H9AlO98afUE){target="_blank"}
und [Detecting issues and configuring alerts for Kubernetes
clusters.](https://www.youtube.com/watch?v=2H-cLhyfYbc){target="_blank"}
:::
::::

:::: sect2
### []{#_aufbau_der_monitoring_umgebung .hidden-anchor .sr-only}1.3. Aufbau der Monitoring-Umgebung {#heading__aufbau_der_monitoring_umgebung}

::: paragraph
Da es in Kubernetes-Clustern sehr schnell auch zu größeren Veränderungen
kommen kann, was die Anzahl und Verortung der einzelnen Komponenten
angeht, empfehlen wir für das Monitoring Ihrer Kubernetes-Umgebung eine
eigene Instanz zu erstellen. Diese können Sie dann wie üblich über das
[verteilte Monitoring](distributed_monitoring.html) an Ihre
Zentralinstanz anbinden.
:::
::::

::::::::: sect2
### []{#_ablauf_des_kubernetes_monitorings_in_checkmk .hidden-anchor .sr-only}1.4. Ablauf des Kubernetes-Monitorings in Checkmk {#heading__ablauf_des_kubernetes_monitorings_in_checkmk}

::: paragraph
Checkmk überwacht Ihre Kubernetes-Cluster auf zwei Wegen:
:::

:::: imageblock
::: content
![monitoring kubernetes
architecture](../images/monitoring_kubernetes_architecture.png)
:::
::::

::: paragraph
Grundlegende Informationen holt sich der
Kubernetes-[Spezialagent](glossar.html#special_agent) einfach über den
API-Server Ihres Clusters ab. Hierüber lassen sich bereits die Zustände
von Nodes und Containern abrufen. Auch die meisten Metadaten über Ihre
Pods und Deployment werden auf diesem Wege gewonnen.
:::

::: paragraph
Für ein umfängliches Monitoring fehlt bis zum diesem Punkt allerdings
noch etwas. Die Fragen, wie viel Last beispielsweise ein bestimmtes
Deployment auf der CPU erzeugt, oder wie viel Arbeitsspeicher ein
DaemonSet gerade bindet, lassen sich so nicht beantworten.
:::

::: paragraph
An dieser Stelle kommen unser Checkmk Node Collector und unser Checkmk
Cluster Collector ins Spiel. Diese sind ein unerlässlicher Teil des
Kubernetes-Monitorings in Checkmk. Ein nicht unerheblicher Teil der
folgenden Ausführungen drehen sich dann auch darum, diese zu
installieren und einzurichten. Auch ist die Verwendung der
[Kubernetes-Dashboards](#dashboards) in den kommerziellen Editionen nur
dann sinnvoll, wenn Node und Cluster Collector hierfür Daten zur
Auslastung liefern können.
:::
:::::::::

:::: sect2
### []{#_unterschiede_zum_übrigen_monitoring_in_checkmk .hidden-anchor .sr-only}1.5. Unterschiede zum übrigen Monitoring in Checkmk {#heading__unterschiede_zum_übrigen_monitoring_in_checkmk}

::: paragraph
Beim Monitoring von Pods und Replicas in Ihren Kubernetes-Clustern kommt
es mitunter wesentlich häufiger zu Statusänderungen bzw. zu
Verzögerungen. Um dem Rechnung zu tragen, ändern die Checks bei
bestimmten Zuständen dieser Objekte erst nach 10 Minuten ihren Status in
Checkmk.
:::
::::

:::: sect2
### []{#_unterschiede_zum_bisherigen_kubernetes_monitoring .hidden-anchor .sr-only}1.6. Unterschiede zum bisherigen Kubernetes-Monitoring {#heading__unterschiede_zum_bisherigen_kubernetes_monitoring}

::: paragraph
Das Kubernetes-Monitoring in Checkmk wurde von Grund auf neu
geschrieben. Der Umfang der überwachbaren Daten ist stark gewachsen. Da
die technische Grundlage für das Kubernetes-Monitoring in Checkmk
[2.1.0]{.new} grundlegend anders ist, ist eine Übernahme oder auch eine
Weiterschreibung bisheriger Monitoring-Daten Ihrer Kubernetes-Objekte
nicht möglich.
:::
::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_voraussetzungen_im_cluster_schaffen .hidden-anchor .sr-only}2. Voraussetzungen im Cluster schaffen {#heading__voraussetzungen_im_cluster_schaffen}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Um Ihr Kubernetes-Cluster in Checkmk überwachen zu können, schaffen Sie
zuerst die Voraussetzungen in Ihrem Cluster. Vor allem, indem Sie dem
Cluster mitteilen, welche Pods/Container bereitgestellt werden sollen
und wie die Konfiguration derselben aussehen muss.
:::

::::::::::: sect2
### []{#setup_helm_repo .hidden-anchor .sr-only}2.1. Helm-Repository einrichten {#heading_setup_helm_repo}

::: paragraph
Die Installation des Kubernetes-Monitoring geschieht mit Hilfe des Tools
`helm`. Helm eignet sich auch für weniger versierte Nutzer und
standardisiert die Verwaltung der Konfigurationen. Helm ist eine Art
Paketmanager für Kubernetes. Sollten Sie Helm noch nicht verwenden, so
erhalten Sie es im Regelfall über die Paketverwaltung Ihrer
Linux-Distribution oder über [die Website des
Helm-Projekts](https://helm.sh/docs/intro/install/){target="_blank"}.
:::

::: paragraph
Sie können darüber *Repositories* als Quellen einbinden und die darin
enthaltenen *Helm-Charts* wie Pakete ganz einfach Ihrem Cluster
hinzufügen. Machen Sie dafür zuallererst das Repository bekannt. In dem
folgenden Beispiel nutzen wir den Namen `checkmk-chart`, um später
einfacher auf das Repository zugreifen zu können. Sie können aber
selbstverständlich auch jeden anderen Namen nutzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm repo add checkmk-chart https://checkmk.github.io/checkmk_kube_agent
```
:::
::::

::: paragraph
Wir aktualisieren unsere Helm-Charts immer dann, wenn neue Gegebenheiten
in Kubernetes dies erfordern. Deshalb lohnt sich von Zeit zu Zeit eine
Prüfung, ob im Repository neue Versionen verfügbar sind. Wenn Sie ihre
lokale Kopie unseres Repositories, wie in dem vorherigen Befehl, mit
`checkmk-chart` bezeichnet haben, können Sie sich mit dem folgenden
Befehl alle im Repository vorliegenden Versionen der Charts anzeigen
lassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm search repo checkmk-chart --versions
NAME               CHART VERSION   APP VERSION   DESCRIPTION
checkmk-chart/checkmk  1.2.0             1.2.0         Helm chart for Checkmk - Your complete IT monit...
checkmk-chart/checkmk  1.1.0             1.1.0         Helm chart for Checkmk - Your complete IT monit...
checkmk-chart/checkmk  1.0.1             1.0.1         Helm chart for Checkmk - Your complete IT monit...
checkmk-chart/checkmk  1.0.0             1.0.0         Helm chart for Checkmk - Your complete IT monit...
```
:::
::::

::: paragraph
Wenn eine neue Version für Sie vorliegt, können Sie das Update mit
`helm repo update` durchführen.
:::
:::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_konfiguration_auf_ihre_umgebung_anpassen .hidden-anchor .sr-only}2.2. Konfiguration auf Ihre Umgebung anpassen {#heading__konfiguration_auf_ihre_umgebung_anpassen}

::: paragraph
Da wir im Vorfeld nicht wissen können, wie Ihr Kubernetes-Cluster
aufgebaut ist, haben wir die sicherste Variante gewählt, wie die Cluster
Collectors gestartet werden: Sie stellen standardmäßig keine Ports
bereit, die von außen erreicht werden können. Damit Sie später auf die
Collectors zugreifen können, müssen Sie diese Einstellungen an Ihr
jeweiliges Cluster anpassen.
:::

::: paragraph
Wir unterstützen standardmäßig zwei Kommunikationspfade: Die Abfrage
über *Ingress* und die Abfrage über *NodePort*. Je nachdem, welche
Variante Sie in Ihrem Cluster unterstützen, ist die Konfiguration
unterschiedlich.
:::

::: paragraph
Um bestimmte Parameter über alle Konfigurationen hinweg selbst bestimmen
zu können, geben Sie dabei eine Steuerdatei mit, die sogenannte
`values.yaml`.
:::

::: paragraph
Um eine solche `values.yaml` zu erstellen bieten sich zwei Wege an. Sie
können entweder die von uns in den Helm-Charts mitgelieferte Datei
extrahieren und anpassen oder Sie erstellen eine minimale Version
einfach selbst.
:::

::: paragraph
Immer wenn Sie Änderungen an dieser Datei in Ihrem Cluster bereitstellen
möchten, können Sie erneut den später folgenden Befehl zur
[Installation](#install_helm_charts) der Helm Chart verwenden.
:::

::::::::: sect3
#### []{#_minimale_values_yaml_selbst_anlegen .hidden-anchor .sr-only}Minimale values.yaml selbst anlegen {#heading__minimale_values_yaml_selbst_anlegen}

::: paragraph
Sie können eine `values.yaml` anlegen, in die Sie nur die Werte
eintragen, die Sie auch ändern wollen. In unserer Helm Chart ist der
Servicetyp des Cluster Collectors bspw. auf `ClusterIP` voreingestellt.
Wenn Sie nun ausschließlich diesen Servicetyp auf `NodePort` und den
Port auf 30035 umstellen möchten, genügt es auch eine `values.yaml` wie
folgt zu erzeugen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo 'clusterCollector: {service: {type: NodePort, nodePort: 30035}}' > values.yaml
```
:::
::::

::: paragraph
Eine Aktivierung von *Ingress* könnte bspw. so aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ echo 'clusterCollector: {ingress: { enabled: true }}' > values.yaml
```
:::
::::
:::::::::

::::::: sect3
#### []{#_values_yaml_aus_helm_charts_extrahieren .hidden-anchor .sr-only}values.yaml aus Helm-Charts extrahieren {#heading__values_yaml_aus_helm_charts_extrahieren}

::: paragraph
Die vollständige von uns mitgelieferte `values.yaml` lässt sich ganz
einfach mit dem folgenden Befehl extrahieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm show values checkmk-chart/checkmk > values.yaml
```
:::
::::

::: paragraph
Die so erzeugte Datei können Sie nun nach Ihren Bedürfnissen anpassen
und bei der [Installation](#install_helm_charts) oder einem späteren
Upgrade mit dem Parameter `-f values.yaml` an `helm` übergeben.
:::
:::::::

::::::: sect3
#### []{#_kommunikation_per_ingress_bereitstellen .hidden-anchor .sr-only}Kommunikation per Ingress bereitstellen {#heading__kommunikation_per_ingress_bereitstellen}

::: paragraph
Falls Sie
[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/){target="_blank"}
verwenden, um die Zugriffe zu Ihren Diensten zu steuern, passen Sie
entsprechend die bereits vorbereiteten Teile in der `values.yaml` an.
Zur besseren Übersicht ist in dem folgenden Beispiel nur der relevante
Ausschnitt gezeigt. Den Parameter `enabled` setzen Sie auf `true`. Die
restlichen Parameter passen Sie entsprechend Ihrer Umgebung an:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
  ingress:
    enabled: true
    className: ""
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
    hosts:
      - host: checkmk-cluster-collector.local
        paths:
          - path: /
            pathType: Prefix
    tls: []
    #  - secretName: chart-example-tls
    #    hosts:
    #      - chart-example.local
```
:::
:::::
:::::::

::::::: sect3
#### []{#_kommunikation_per_nodeport_bereitstellen .hidden-anchor .sr-only}Kommunikation per NodePort bereitstellen {#heading__kommunikation_per_nodeport_bereitstellen}

::: paragraph
Sie können den Zugriff auf die Dienste auch direkt über einen Port
bereitstellen. Das ist dann notwendig, wenn Sie kein Ingress verwenden.
Auch in dem nachfolgenden Beispiel wird nur der relevante Ausschnitt
gezeigt. Sie setzen dabei den Wert `type` auf `NodePort` und entfernen
die Auskommentierung zu dem Wert `nodePort`:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
  service:
    # if required specify "NodePort" here to expose the cluster-collector via the "nodePort" specified below
    type: NodePort
    port: 8080
    nodePort: 30035
```
:::
:::::
:::::::

::::::::::: sect3
#### []{#_cluster_collector_auf_https_umstellen .hidden-anchor .sr-only}Cluster Collector auf HTTPS umstellen {#heading__cluster_collector_auf_https_umstellen}

::: paragraph
Wenn Sie die Kommunikation mit dem und zwischen den Cluster Collectors
auf HTTPS umstellen möchten, müssen Sie hierzu ebenfalls Änderungen in
der Datei `values.yaml` vornehmen.
:::

::: paragraph
Folgend sehen Sie den Abschnitt in unserer mitgelieferten `values.yaml`
den Sie bearbeiten müssen, um HTTPS zu aktivieren:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
tlsCommunication:
  enabled: false
  verifySsl: false
  # clusterCollectorKey: |-
  #   -----BEGIN EC PRIVATE KEY-----
  #   XYZ
  #   -----END EC PRIVATE KEY-----
  # clusterCollectorCert: |-
  #   -----BEGIN CERTIFICATE-----
  #   XYZ
  #   -----END CERTIFICATE-----
  # checkmkCaCert: |-
  #   -----BEGIN CERTIFICATE-----
  #   XYZ
  #   -----END CERTIFICATE-----
```
:::
:::::

::: paragraph
In den Zeilen, die mit `enabled` bzw. `verifySsl` beginnen, müssen Sie
`false` durch `true` ersetzen. Entfernen Sie als nächstes vor den drei
Abschnitten `clusterCollectorKey`, `clusterCollectorCert` und
`checkmkCaCert` die Rautezeichen und fügen Sie dahinter die
entsprechenden Daten ein. Ob Sie hierfür selbst signierte Zertifikate
nutzen oder sich Zertifikate von einer Certificate Authority (CA)
besorgen, dürfte in erster Linie durch Ihre Organisation vorgegeben
sein.
:::

::: paragraph
Bitte beachten Sie dabei nur die folgenden Voraussetzungen, die die
Zertifikate erfüllen müssen:
:::

::: ulist
- Das CA-Zertifikat muss den Host-Namen bzw. den Namen des Ingress als
  FQDN enthalten.

- Beim Server-Zertifikat muss der FQDN dem folgenden Muster entsprechen:
  `<service_name>.<namespace>.cluster.local`

- Im Abschnitt `[ v3_ext ]` der Konfigurationsdatei für die Erzeugung
  Ihres Certificate Signing Requests muss der `subjectAltName` dem
  folgenden Muster entsprechen:
  `subjectAltName: DNS:<service_name>.<namespace>.cluster.local, IP:<service ip>`
:::
:::::::::::

::::::: sect3
#### []{#_eigenen_service_account_verwenden .hidden-anchor .sr-only}Eigenen Service-Account verwenden {#heading__eigenen_service_account_verwenden}

::: paragraph
Mithilfe unserer Helm-Charts würde standardmäßig ein Service-Account in
Ihrem Cluster erstellt. Wenn Sie bereits über einen passenden
Service-Account verfügen, genügt es, wenn Sie diesen in der
`values.yaml` hinzufügen und die Erstellung eines neuen Accounts
unterbinden.
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
serviceAccount:
  create: false
  name: "myserviceaccount"
```
:::
:::::
:::::::

:::::::: sect3
#### []{#_voraussetzung_für_monitoring_von_gke_autopilot .hidden-anchor .sr-only}Voraussetzung für Monitoring von GKE Autopilot {#heading__voraussetzung_für_monitoring_von_gke_autopilot}

::: paragraph
Falls Sie Ihr GKE-Cluster (Google Kubernetes Engine) im Autopilot-Modus
betreiben, so ist das Monitoring mit Checkmk problemlos möglich, da
Checkmk ein sogenannter [Autopilot
Partner](https://cloud.google.com/kubernetes-engine/docs/resources/autopilot-partners?hl=de#allowlisted-partner-workloads)
ist.
:::

::: paragraph
Sie müssen in der `values.yaml` lediglich `var_run` auf `readOnly`
setzen:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
volumeMountPermissions:
      var_run:
        readOnly: true
```
:::
:::::
::::::::

::::::::::: sect3
#### []{#pod_security_standards .hidden-anchor .sr-only}Pod Security Admission Controller konfigurieren {#heading_pod_security_standards}

::: paragraph
Wenn Sie in Ihrem Cluster Pod Security Standards einsetzen, müssen Sie
den Checkmk Cluster Collector so einrichten, dass dieser ungehinderten
Zugriff im entsprechenden Namespace erhält. Idealerweise erstellen Sie
einen Namespace mit den folgenden Spezifikationen:
:::

::::: listingblock
::: title
namespace.yaml
:::

::: content
``` {.pygments .highlight}
apiVersion: v1
kind: Namespace
metadata:
  name: checkmk-monitoring
  labels:
    pod-security.kubernetes.io/enforce: privileged
    pod-security.kubernetes.io/enforce-version: latest
```
:::
:::::

::: paragraph
Den Namespace können Sie erzeugen, indem Sie beispielsweise
`kubectl apply -f namespace.yaml` aufrufen. Denken Sie daran, dass Sie
dann die Option `--create-namespace` nicht verwenden müssen, wenn Sie
später den Befehl `helm upgrade` ausführen.
:::

::: paragraph
Wenn der Cluster Collector bereits läuft bzw. der Namespace bereits
existiert, können Sie die obigen Labels auch mit dem folgenden Befehl
setzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ kubectl label --overwrite ns checkmk-monitoring pod-security.kubernetes.io/enforce=privileged pod-security.kubernetes.io/enforce-version=latest
```
:::
::::
:::::::::::

::::::::::::::::: sect3
#### []{#pod_security_policies .hidden-anchor .sr-only}Pod Security Policies und Network Policies {#heading_pod_security_policies}

::: paragraph
Die Policies *PodSecurityPolicy* (kurz: PSP) und *NetworkPolicy* sind in
erster Linie aus Gründen der Kompatibilität in unserer Helm-Chart
enthalten. Da die PSP mit dem Erscheinen von Kubernetes `v1.25` entfernt
wurden, haben wir diese ab Version `1.3.0` unserer Helm-Chart
standardmäßig deaktiviert.
:::

::: paragraph
Der entsprechende Abschnitt sieht nun folgendermaßen aus:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
rbac:
  pspEnabled: false
```
:::
:::::

::: paragraph
Sollten Sie die PSP in Ihrem Cluster noch einsetzen, ist es unbedingt
erforderlich, diese Option in der `values.yaml` auf `true` zu setzen:
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
rbac:
  pspEnabled: true
```
:::
:::::

::: paragraph
Sollten wir zu einem späteren Zeitpunkt feststellen, dass dieser Eintrag
auch im deaktivierten Zustand nicht mehr korrekt verarbeitet wird,
werden wir diesen gänzlich entfernen.
:::

::: paragraph
Ähnliches gilt für die *NetworkPolicy*. Wenn Sie diese in Ihrem Cluster
einsetzen, müssen die Stelle in der `values.yaml` von `enabled: false`
auf `enabled: true` umstellen. Bitte beachten Sie in diesem Fall die
folgende Dokumentation innerhalb der `values.yaml`, um die
*NetworkPolicy* korrekt zu konfigurieren.
:::

::::: listingblock
::: title
values.yaml
:::

::: content
``` {.pygments .highlight}
## ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/
networkPolicy:
  # keep in mind: your cluster network plugin has to support NetworkPolicies, otherwise they won't have any effect
  enabled: false

  # specify ipBlock cidrs here to allow ingress to the cluster-collector
  # this is required for the checkmk servers to be able to scrape data from checkmk, so include the resprective ip range(s) here
  allowIngressFromCIDRs: []
  # - 127.0.0.1/32 # e.g. Checkmk Server
  # - 127.0.0.1/24 # e.g. Metallb speakers

  # the cluster-collector needs to be able to contact the kube-apiserver
  # you have three options here to choose from, depending on your cluster setup:
  # 1) if your apiserver resides outside the cluster, resp. you have a kubernetes endpoint available (check via "kubectl -n default get ep kubernetes")
  #    we can make use of helm lookup to automatically inject the endpoint (cidr + port) here.
  #    This is the most comfortable one, just note that helm lookup won't work on a "helm template" or "helm diff" command.
  #    (see also: https://helm.sh/docs/chart_template_guide/functions_and_pipelines/#using-the-lookup-function)
  # 2) similar to 1) you can also specify the "ipBlockCidr" directly. Make sure to disable "enableCidrLookup", and also fill the "port".
  # 3) if the apiserver resides inside the cluster, disable "enableCidrLookup", unset "ipBlockCidr", and fill the "labelSelectors" section
  #    with the name of the namespace where the kube-apiserver is availabe, and the label key and label value that defines your kube-apiserver pod.
  egressKubeApiserver:
    enableCidrLookup: true
    # ipBlockCidr: 172.31.0.3/32
    # port: 6443
    # labelSelectors:
    #   namespace: kube-system
    #   key: app
    #   value: kube-apiserver
```
:::
:::::
:::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: sect2
### []{#install_helm_charts .hidden-anchor .sr-only}2.3. Helm-Charts installieren {#heading_install_helm_charts}

::: paragraph
Nachdem Sie die `values.yaml` angepasst oder eine eigene erstellt haben,
installieren Sie mit dem folgenden Kommando alle notwendigen Komponenten
in Ihrem Cluster, um es in Checkmk überwachen zu können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm upgrade --install --create-namespace -n checkmk-monitoring myrelease checkmk-chart/checkmk -f values.yaml
```
:::
::::

::: paragraph
Da das Kommando nicht selbsterklärend ist, bieten wir Ihnen nachfolgend
eine Erläuterung zu den einzelnen Optionen:
:::

+-----------------+-----------------------------------------------------+
| Befehlsteil     | Bedeutung                                           |
+=================+=====================================================+
| `helm upg       | Dieser Teil ist der Basisbefehl, um dem             |
| rade --install` | Kubernetes-Cluster die Konfiguration zu             |
|                 | übermitteln.                                        |
+-----------------+-----------------------------------------------------+
| `--cr           | In Kubernetes geben Sie immer an, zu welchem        |
| eate-namespace` | *Namespace* die Konfiguration hinzugefügt werden    |
|                 | soll. Diese Option benötigen Sie, falls es den      |
|                 | Namespace noch nicht gibt. Helm wird ihn in diesem  |
|                 | Fall mit anlegen.                                   |
+-----------------+-----------------------------------------------------+
| `-n chec        | Diese Option bestimmt den Namespace, zu dem die     |
| kmk-monitoring` | Konfiguration hinzugefügt werden soll.              |
|                 | `checkmk-monitoring` ist dabei nur ein Beispiel,    |
|                 | wie dieser heißen könnte.                           |
+-----------------+-----------------------------------------------------+
| `myrelease`     | `myrelease` bezeichnet hier das Release. Jede       |
|                 | Instanz einer Helm-Chart, die in Ihrem              |
|                 | Kubernetes-Cluster läuft wird als Release           |
|                 | bezeichnet. Diesen Namen können Sie frei wählen.    |
+-----------------+-----------------------------------------------------+
| `checkmk        | Der erste Teil dieser Option beschreibt das         |
| -chart/checkmk` | Repository, welches Sie [zuvor](#setup_helm_repo)   |
|                 | angelegt haben. Der zweite Teil --- nach dem        |
|                 | Schrägstrich --- ist das *Paket*, in dem die        |
|                 | notwendigen Informationen liegen, um die            |
|                 | Konfiguration ihres Kubernetes-Monitoring erstellen |
|                 | zu können.                                          |
+-----------------+-----------------------------------------------------+
| `               | Zuletzt geben Sie die Konfigurationsdatei an, die   |
| -f values.yaml` | Sie zuvor erstellt bzw. angepasst haben. Sie        |
|                 | enthält alle Anpassungen, die in den                |
|                 | Konfigurationsdateien berücksichtigt werden sollen, |
|                 | die mit `helm` erstellt werden.                     |
+-----------------+-----------------------------------------------------+

::: paragraph
Nachdem Sie das Kommando ausgeführt haben, ist Ihr Kubernetes-Cluster
vorbereitet, um mit Checkmk überwacht zu werden. Das Cluster wird sich
nun selbstständig darum kümmern, dass die notwendigen Pods und die darin
enthaltenen Container laufen und erreichbar sind.
:::

::::::::::::::::::: sect3
#### []{#helm_output .hidden-anchor .sr-only}Ausgabe der Helm-Charts {#heading_helm_output}

::: paragraph
Als nächstes steht nun die Einrichtung in Checkmk an. Um Ihnen diese
Einrichtung so einfach wie möglich zu machen, haben wir den Output
unserer Helm-Charts mit einer ganzen Reihe an Kommandos ausgestattet.
Dieser Output passt sich auch automatisch an die von Ihnen eingestellten
Werte in der Datei `values.yaml` an. Verwenden Sie also den NodePort,
bekommen Sie hier unter anderem die Befehle um IP und Port des NodePort
anzuzeigen. Verwenden Sie stattdessen Ingress, wird die Ausgabe
entsprechend angepasst. Im Folgenden zeigen wir die - leicht gekürzte -
Ausgabe nach erfolgreicher Installation bei der Verwendung des NodePort:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm upgrade --install --create-namespace -n checkmk-monitoring myrelease checkmk-chart/checkmk -f values.yaml
Release "myrelease" has been upgraded. Happy Helming!
NAME: myrelease
LAST DEPLOYED: Sat Dec 16 19:00:11 2022
NAMESPACE: checkmk-monitoring
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
You can access the checkmk cluster-collector via:
NodePort:
  export NODE_PORT=$(kubectl get --namespace checkmk-monitoring -o jsonpath="{.spec.ports[0].nodePort}" services myrelease-checkmk-cluster-collector);
  export NODE_IP=$(kubectl get nodes --namespace checkmk-monitoring -o jsonpath="{.items[0].status.addresses[0].address}");
  echo http://$NODE_IP:$NODE_PORT
  # Cluster-internal DNS of cluster-collector: myrelease-checkmk-cluster-collector.checkmk-monitoring
With the token of the service account named myrelease-checkmk-checkmk in the namespace checkmk-monitoring you can now issue queries against the cluster-collector.
Run the following to fetch its token and the ca-certificate of the cluster:
  export TOKEN=$(kubectl get secret myrelease-checkmk-checkmk -n checkmk-monitoring -o=jsonpath='{.data.token}' | base64 --decode);
  export CA_CRT="$(kubectl get secret myrelease-checkmk-checkmk -n checkmk-monitoring -o=jsonpath='{.data.ca\.crt}' | base64 --decode)";
  # Note: Quote the variable when echo'ing to preserve proper line breaks: echo "$CA_CRT"
To test access you can run:
  curl -H "Authorization: Bearer $TOKEN" http://$NODE_IP:$NODE_PORT/metadata | jq
```
:::
::::

::: paragraph
Kopieren Sie aus dieser Ausgabe einfach die farblich markierten Zeilen
und führen Sie die Befehle aus.
:::

::: paragraph
Der erste Block zeigt Ihnen Informationen zum NodePort an:
:::

:::: {#token_ca_crt .listingblock}
::: content
``` {.pygments .highlight}
user@host:~$ export NODE_PORT=$(kubectl get --namespace checkmk-monitoring -o jsonpath="{.spec.ports[0].nodePort}" services myrelease-checkmk-cluster-collector);
user@host:~$ export NODE_IP=$(kubectl get nodes --namespace checkmk-monitoring -o jsonpath="{.items[0].status.addresses[0].address}");
user@host:~$ echo http://$NODE_IP:$NODE_PORT
http://10.184.38.103:30035
```
:::
::::

::: paragraph
Genau diese Adresse müssen Sie in Checkmk später in der Kubernetes-Regel
im Feld [Collector NodePort / Ingress endpoint]{.guihint} eintragen.
:::

::: paragraph
Mit den Befehlen aus dem nächsten Block erhalten Sie sowohl den Token
and auch das Zertifikat des Service-Accounts. Die Daten werden so in den
Umgebungsvariablen `TOKEN` und `CA_CRT` gespeichert. Achten Sie bei der
Ausgabe der Variable `CA_CRT` unbedingt darauf diese in Hochkommata
einzuschließen, da ansonsten die wichtigen Zeilenumbrüche des
Zertifikats verloren gehen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ export TOKEN=$(kubectl get secret myrelease-checkmk-checkmk -n checkmk-monitoring -o=jsonpath='{.data.token}' | base64 --decode);
user@host:~$ export CA_CRT="$(kubectl get secret myrelease-checkmk-checkmk -n checkmk-monitoring -o=jsonpath='{.data.ca\.crt}' | base64 --decode)";
user@host:~$ echo $TOKEN
eyJhbGciOiJSUzI1NiIsImtpZCI6InR6VXhGSU ...
user@host:~$ echo "$CA_CRT"
-----BEGIN CERTIFICATE-----
MIIBdjCCAR2gAwIBAgIBADAKBggqhkjOPQQDAjAjMSEwHwYDVQQDDBhrM3Mtc2Vy
dmVyLWNhQDE2NjIxNDc5NTMwHhcNMjIwOTAyMTk0NTUzWhcNMzIwODMwMTk0NTUz
...
-----END CERTIFICATE-----
```
:::
::::

::: paragraph
Bei der Einrichtung in Checkmk müssen Sie sowohl [den Token](#token) als
auch das [das Zertifikat](#certimport) hinterlegen. Lassen Sie die Shell
mit diesen Informationen geöffnet oder kopieren Sie Token und Zertifikat
an einen Ort, an dem Sie während der folgenden Einrichtung in Checkmk
zugreifen können.
:::

::: paragraph
Wenn Sie die beiden vorherigen Export-Befehle ausgeführt haben, können
Sie mit dem letzten Befehl prüfen, ob die Einrichtung erfolgreich war:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
curl -H "Authorization: Bearer $TOKEN" http://$NODE_IP:$NODE_PORT/metadata | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1815  100  1815    0     0   126k      0 --:--:-- --:--:-- --:--:--  126k
{
  "cluster_collector_metadata": {
    "node": "mynode",
    "host_name": "myrelease-checkmk-cluster-collector-58f97df9c9-mdhsw",
    "container_platform": {
      "os_name": "alpine",
      "os_version": "3.15.4",
      "python_version": "3.10.4",
      "python_compiler": "GCC 10.3.1 20211027"
    },
    "checkmk_kube_agent": {
      "project_version": "1.0.1"
    }
  }
  ...
```
:::
::::

::: paragraph
Am Anfang der stark gekürzten Ausgabe sehen Sie beispielsweise die
Version des Cluster Collectors. Weiter unten würden dann noch Metadaten
zu allen Nodes in diesem Cluster folgen.
:::
:::::::::::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setupincheckmk .hidden-anchor .sr-only}3. Monitoring in Checkmk einrichten {#heading_setupincheckmk}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Als nächstes geht es in der GUI von Checkmk an die Einrichtung des
[Spezialagenten](glossar.html#special_agent) und einer Regel für die
automatische Erzeugung von Hosts für Ihre Kubernetes-Objekte. Für die
Einrichtung des Spezialagenten müssen aber zuerst noch einige
Voraussetzungen erfüllt werden:
:::

:::::: sect2
### []{#token .hidden-anchor .sr-only}3.1. Passwort (Token) in Checkmk hinterlegen {#heading_token}

::: paragraph
Das Passwort (Token) des Service-Accounts können Sie am besten im
Passwortspeicher von Checkmk hinterlegen. Das ist die sicherste
Variante, da Sie Hinterlegung und Benutzung des Passworts
organisatorisch trennen können. Alternativ geben Sie es beim Anlegen der
Regel (siehe weiter unten) direkt im Klartext ein. Wie Sie sich das
benötigte Passwort anzeigen lassen können, steht in der [Ausgabe der
Helm-Charts.](#helm_output) Fügen Sie das Passwort in den
Checkmk-Passwortspeicher ein mit [Setup \> General \> Passwords \> Add
password]{.guihint} z.B. unter der ID und dem Titel
`My Kubernetes Token`:
:::

:::: imageblock
::: content
![kubernetes password](../images/kubernetes_password.png)
:::
::::
::::::

:::::: sect2
### []{#certimport .hidden-anchor .sr-only}3.2. CA-Zertifikat des Service-Accounts in Checkmk importieren {#heading_certimport}

::: paragraph
Damit Checkmk der Certificate Authority (CA) des Service-Accounts
vertrauen kann, müssen Sie das CA-Zertifikat in Checkmk hinterlegen. Wie
Sie sich das benötigte Zertifikat anzeigen lassen können, steht
ebenfalls in der [Ausgabe der Helm-Charts.](#helm_output) Kopieren Sie
hier alles inklusive der Zeilen `BEGIN CERTIFICATE` und
`END CERTIFICATE` und fügen Sie das Zertifikat im Setup-Menü unter
[Setup \> General \> Global settings \> Site management \> Trusted
certificate authorities for SSL]{.guihint} hinzu:
:::

:::: imageblock
::: content
![kubernetes ca](../images/kubernetes_ca.png)
:::
::::
::::::

:::::: sect2
### []{#source-host .hidden-anchor .sr-only}3.3. Piggyback Quell-Host anlegen {#heading_source-host}

::: paragraph
Erzeugen Sie in Checkmk auf gewohnte Weise einen neuen Host und nennen
Sie diesen beispielsweise `mykubernetesclusterhost`. Wie Überschrift und
Host-Name schon nahelegen, dient dieser Host dazu, die
[Piggyback-Daten](glossar.html#piggyback) zu sammeln und außerdem alle
Services und Metriken auf Cluster-Ebene abzubilden. Da dieser Host
ausschließlich über den Spezialagenten Daten erhält, setzen Sie in den
Eigenschaften des Hosts die Option [IP address family]{.guihint}
unbedingt auf [No IP]{.guihint}.
:::

:::: imageblock
::: content
![Beispielhafte Einrichtung eines Cluster-Hosts mit der wichtigen
Einstellung \'No IP\'.](../images/monitoring_kubernetes_no_ip.png)
:::
::::
::::::

:::::::::::: sect2
### []{#_dynamische_host_konfiguration_einrichten .hidden-anchor .sr-only}3.4. Dynamische Host-Konfiguration einrichten {#heading__dynamische_host_konfiguration_einrichten}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Um eine Trennung
zwischen den Objekten verschiedener Kubernetes-Cluster zu gewährleisten,
kann es sich anbieten über [Setup \> Hosts \> Add folder]{.guihint} pro
Cluster einen Ordner anzulegen, in welchem die [dynamische
Host-Konfiguration](dcd.html) automatisch alle Hosts eines Clusters
anlegen kann. Einen solchen Ordner zu erzeugen bzw. zu nutzen ist aber
optional.
:::

::: paragraph
Als nächstes richten Sie in den kommerziellen Editionen einen Konnektor
für die anfallenden Piggyback-Daten ein: mit [Setup \> Hosts \> Dynamic
host management \> Add connection.]{.guihint} Tragen Sie zuerst einen
Titel ein und klicken Sie anschließend unter [Connection
Properties]{.guihint} auf [show more]{.guihint}.
:::

::: paragraph
Klicken Sie als Nächstes auf [Add new element]{.guihint} und wählen Sie
unter [Create hosts in]{.guihint} den zuvor angelegten Ordner aus.
:::

::: paragraph
Die voreingestellten Attribute unter [Host attributes to set]{.guihint}
können Sie so belassen. Sie sorgen dafür das sich Checkmk bei den
automatisch angelegten Hosts ausschließlich an die Piggyback-Daten hält
und nicht versucht diese beispielsweise zu pingen oder per SNMP zu
erreichen.
:::

::: paragraph
In einer Kubernetes-Umgebung, in der überwachbare und überwachte Objekte
kontinuierlich kommen und gehen, empfiehlt es sich auch die Option
[Automatically delete hosts without piggyback data]{.guihint} zu
aktivieren. Was genau diese Option bewirkt und unter welchen Umständen
Hosts dann tatsächlich gelöscht werden, erklären wir im Kapitel
[Automatisches Löschen von Hosts](dcd.html#automatic_deletion_of_hosts)
im Artikel zur dynamischen Host-Konfiguration.
:::

::: paragraph
Tragen Sie nun noch unter [Restrict source hosts]{.guihint} den zuvor
angelegten [Piggyback Quell-Host](#source-host) ein und aktivieren Sie
die Option [Discover services during creation]{.guihint}.
:::

::: paragraph
Der Abschnitt [Connection Properties]{.guihint} dieses neuen Konnektors
könnte im Anschluss wie folgt aussehen:
:::

:::: imageblock
::: content
![Beispielhafte Einstellungen einer dynamischen
Host-Konfiguration.](../images/monitoring_kubernetes_connection_properties.png)
:::
::::
::::::::::::

:::: sect2
### []{#_piggyback_daten_in_checkmk_raw_verarbeiten .hidden-anchor .sr-only}3.5. Piggyback-Daten in Checkmk Raw verarbeiten {#heading__piggyback_daten_in_checkmk_raw_verarbeiten}

::: paragraph
In Checkmk Raw müssen Sie die Hosts für die anfallenden Piggyback-Daten
[manuell erstellen.](piggyback.html#piggyback_in_practice) Weil hier in
einem Kubernetes-Cluster eine große Zahl an Piggyback-Hosts entstehen
dürften, empfiehlt sich die Verwendung unseres Skript
[`find_piggy_orphans`](piggyback.html#orphaned_piggyback_data) im
Verzeichnis `~/share/doc/check_mk/treasures/` Ihrer Checkmk-Instanz.
:::
::::

::::::::: sect2
### []{#_periodische_service_erkennung_anpassen .hidden-anchor .sr-only}3.6. Periodische Service-Erkennung anpassen {#heading__periodische_service_erkennung_anpassen}

::: paragraph
Standardmäßig führt Checkmk alle zwei Stunden eine Service-Erkennung
durch und zeigt das Ergebnis dieser Erkennung im Service [Check_MK
Discovery]{.guihint} an. Sie finden diese Einstellung im Regelsatz
[Periodic service discovery]{.guihint}. Im Kontext von Kubernetes
empfehlen wir eine Regel für alle Hosts mit dem Label
`cmk/kubernetes:yes` zu erstellen. Dieses Label erhält nämlich jeder
Host der Kubernetes-Objekte repräsentiert automatisch von Checkmk. Sie
sollten hier ein kürzeres Intervall für die Service-Erkennung wählen und
auch die Option [Automatically update service configuration]{.guihint}
aktivieren. Die Einstellungen im folgenden Screenshot sind nur
exemplarisch. Was für Ihre Cluster sinnvoll ist, müssen Sie von Fall zu
Fall entscheiden.
:::

:::: imageblock
::: content
![Exemplarische Einrichtung der periodischen Service-Erkennung für
Kubernetes-Objekte.](../images/monitoring_kubernetes_periodic_service_discovery.png)
:::
::::

::: paragraph
Um diese Regel auf alle Hosts Ihrer Cluster zu beschränken genügt es bei
den [Conditions]{.guihint} unter [Host labels]{.guihint}
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

::::::::::::::::::::::::::::::::::: sect2
### []{#rule .hidden-anchor .sr-only}3.7. Spezialagent einrichten {#heading_rule}

::: paragraph
Nachdem nun alle Voraussetzungen im Cluster und in Checkmk geschaffen
sind, können Sie sich der Konfiguration des Spezialagenten widmen. Diese
finden Sie über [Setup \> Agents \> VM, cloud, container \>
Kubernetes]{.guihint}. Erstellen Sie mit [Add rule]{.guihint} eine neue
Regel.
:::

::: paragraph
Zuallererst müssen Sie einen Namen für das zu überwachende Cluster
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
Tokens.](../images/monitoring_kubernetes_cluster_name_and_token.png)
:::
::::

::: paragraph
Unter [API server connection \> Endpoint]{.guihint} verlangt Checkmk nun
die Eingabe der URL (bzw. IP-Adresse) über welche Ihr Kubernetes
API-Server erreichbar ist. Die Angabe des Ports ist nur notwendig, wenn
der Dienst nicht über einen virtuellen Host bereitgestellt wird. Wie Sie
diese Adresse am einfachsten herausfinden können --- falls Sie sie nicht
bereits zur Hand haben --- hängt von Ihrer Kubernetes-Umgebung ab. Mit
dem folgenden Befehl erhalten Sie den Endpunkt des API-Servers in der
Zeile `server`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ kubectl config view
apiVersion: v1
clusters:
  - cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://DFE7A4191DCEC150F63F9DE2ECA1B407.mi6.eu-central-1.eks.amazonaws.com
    name: xyz:aws:eks:eu-central-1:150143619628:cluster/my-kubernetes
```
:::
::::

::: paragraph
Die tatsächlich Ausgabe von `kubectl config view` variiert allerdings
sehr stark. Wird hier in der Zeile `server` auch ein Port angegeben, so
fügen Sie diesen unbedingt auch in der Regel ein.
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
Verbindung.](../images/monitoring_kubernetes_rule_api_server_connection.png)
:::
::::

::: paragraph
Als Nächstes haben Sie die Wahl das Monitoring Ihres Kubernetes-Clusters
mit Nutzungsdaten anzureichern, welche der Checkmk Cluster Collector
einsammelt. Wir wiederholen es an dieser Stelle ein weiteres Mal, um die
Wichtigkeit zu unterstreichen: **Die Einrichtung des Cluster Collectors
ist für ein vollumfängliches Monitoring Ihrer Cluster absolut
unerlässlich.** Nur so erhalten Sie wichtige Daten wie CPU- und
Speicherauslastung und werden über die Dateisysteme der einzelnen
Komponenten informiert.
:::

::: paragraph
Aktivieren Sie also die Option [Enrich with usage data from Checkmk
Cluster Collector]{.guihint} und geben Sie den Endpunkt des NodePorts
bzw. des Ingress an. Wie Sie sich diesen Endpunkt erneut anzeigen lassen
können, steht in der [Ausgabe der Helm-Charts.](#helm_output)
:::

:::: imageblock
::: content
![Exemplarische Angabe der Cluster Collector
Verbindung.](../images/monitoring_kubernetes_rule_enrich.png)
:::
::::

::: paragraph
Mit den Optionen [Collect information about...​]{.guihint} können Sie nun
noch auswählen, welche Objekte innerhalb Ihres Cluster überwacht werden
sollen. Unsere Vorauswahl deckt hier die relevantesten Objekte ab.
Sollten Sie sich dazu entscheiden auch die [Pods of CronJobs]{.guihint}
zu überwachen, so beachten Sie die
[Inline-Hilfe](user_interface.html#inline_help) zu diesem Punkt.
:::

:::: imageblock
::: content
![Exemplarische Auswahl überwachbarer
Kubernetes-Objekte.](../images/monitoring_kubernetes_rule_collect_info_about.png)
:::
::::

::: paragraph
Mit den nächsten beiden Auswahlmöglichkeiten, können Sie die zu
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
Ressourcen-Aggregation](../images/monitoring_kubernetes_namespaces_and_resource_aggregation.png)
:::
::::

::: paragraph
Als letzte Option können Sie noch sogenannte *Annotations* aus
Kubernetes importieren. In Checkmk werden diese *Annotations* zu
[Host-Labels](glossar.html#label) und können somit als Bedingungen in
Regeln weiterverwendet werden. Welche *Annotations* importiert werden
sollen, können Sie über reguläre Ausdrücke festlegen. Konsultieren Sie
an dieser Stelle erneut die ausführliche Inline-Hilfe.
:::

::: paragraph
**Hinweis:** Die Option [Import all valid annotations]{.guihint} bieten
wir an dieser Stelle nur der Vollständigkeit halber an. Wir raten davon
ab, einfach blind alle *Annotations* zu importieren, weil hierdurch
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
werden.](../images/monitoring_kubernetes_explicit_hosts.png)
:::
::::

::: paragraph
Speichern Sie anschließend die Regel und führen Sie eine
Service-Erkennung auf diesem Host durch. Sie werden hier gleich die
ersten Services auf Cluster-Ebene sehen:
:::

:::: imageblock
::: content
![Exemplarische Ansicht der ersten Service-Erkennung nach Abschluss der
Konfiguration.](../images/monitoring_kubernetes_service_discovery.png)
:::
::::

::: paragraph
Aktivieren Sie im Anschluss alle vorgenommenen Änderungen und überlassen
Sie ab jetzt der dynamischen Host-Konfiguration die Arbeit. Diese wird
schon nach kurzer Zeit alle Hosts für Ihre Kubernetes-Objekte erzeugen.
:::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::: sect1
## []{#_labels_für_kubernetes_objekte .hidden-anchor .sr-only}4. Labels für Kubernetes-Objekte {#heading__labels_für_kubernetes_objekte}

:::: sectionbody
::: paragraph
Checkmk erzeugt Labels für die Kubernetes-Objekte wie Cluster,
Deployments oder Namespace während der Service-Erkennung automatisch.
Alle Labels zu Kubernetes-Objekten, die Checkmk automatisch erzeugt,
beginnen mit `cmk/kubernetes/`. Ein Pod erhält beispielsweise immer ein
Label der Node (`cmk/kubernetes/node:mynode`), ein Label, welches eben
zeigt, dass es sich bei diesem Objekt um einen Pod handelt
(`cmk/kubernetes/object:pod`) und ein Label für den Namespace
(`cmk/kubernetes/namespace:mynamespace`). So lassen sich in der Folge
sehr einfach Filter und Regeln für alle Objekte gleichen Typs bzw. im
gleichen Namespace erstellen.
:::
::::
:::::

:::::::::::::::::: sect1
## []{#_dashboards_und_ansichten .hidden-anchor .sr-only}5. Dashboards und Ansichten {#heading__dashboards_und_ansichten}

::::::::::::::::: sectionbody
::::::::::: sect2
### []{#dashboards .hidden-anchor .sr-only}5.1. Kubernetes-Dashboards {#heading_dashboards}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen von Checkmk werden mit sechs eingebauten Dashboards für
Kubernetes ausgeliefert. Um diese Dashboards sinnvoll verwenden zu
können, ist es notwendig, dass unser Cluster Collector installiert und
konfiguriert ist. Im einzelnen heißen diese Dashboards:
:::

::: ulist
- Kubernetes

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
Ihre überwachten Kubernetes-Cluster aufgelistet. Diese Auflistung der
Cluster ist auch Ihr Einstieg um sich tiefer in die
Kubernetes-Dashboards zu bohren. Mit einem Klick auf den Namen eines
Clusters gelangen Sie in das Dashboard [Kubernetes Cluster]{.guihint}
des angewählten Clusters. Im Dashboard [Kubernetes Cluster]{.guihint}
führt ein Klick auf den jeweiligen Namen dann in die übrigen
kontextabhängigen Dashboards:
:::

:::: imageblock
::: content
![Ausschnitt des Cluster-Dashboards mit Wegen in die weiteren
Dashboards.](../images/monitoring_kubernetes_cluster_dashboard.png)
:::
::::
:::::::::::

::::::: sect2
### []{#_hardware_software_inventur .hidden-anchor .sr-only}5.2. Hardware-/Software-Inventur {#heading__hardware_software_inventur}

::: paragraph
Die Kubernetes-Überwachung von Checkmk unterstützt auch die
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

:::::::::::::::: sect1
## []{#_prüfung_der_installation .hidden-anchor .sr-only}6. Prüfung der Installation {#heading__prüfung_der_installation}

::::::::::::::: sectionbody
::: paragraph
Im Abschnitt [Ausgabe der Helm-Charts](#helm_output) haben Sie bereits
die erste Möglichkeit kennengelernt, um die erfolgreiche Installation
der Komponenten für das vollständige Monitoring von Kubernetes zu
prüfen. In der GUI von Checkmk können Sie ebenfalls an einigen Stellen
die erfolgreiche Installation und Konfiguration prüfen.
:::

::: paragraph
Die wichtigsten Services sind hier sicherlich [Kubernetes API]{.guihint}
und [Cluster Collector]{.guihint}. Diese müssen auf dem von Ihnen
erstellten Cluster-Host vorhanden sein und sollten auch bestimmte
Informationen anzeigen.
:::

:::: imageblock
::: content
![Wichtigste Services zur Prüfung der korrekten
Installation](../images/monitoring_kubernetes_check_installation.png)
:::
::::

::: paragraph
Der Service [Kubernetes API]{.guihint} sollte im Normalfall unter
[Summary]{.guihint} [Live, Ready]{.guihint} vermelden. Der Service
[Cluster Collector]{.guihint} muss die Versionsnummer des installierten
Cluster Collectors anzeigen. Ist eins von beidem nicht der Fall, müssen
Sie die Installation der Helm-Charts und die Konfiguration des
Spezialagenten überprüfen.
:::

::: paragraph
Weitere Möglichkeiten zur Prüfung bieten in den kommerziellen Editionen
die Cluster-Dashboards.
:::

::: paragraph
Im Dashboard [Kubernetes]{.guihint} können Sie bereits sehr früh
erkennen, ob der Cluster Collector in einem Cluster läuft und Daten
sammelt. Wenn die Spalten [CPU resources]{.guihint} und [Memory
resources]{.guihint} keine Daten enthalten, ist dies bereits ein starker
Indikator dafür, dass der Cluster Collector nicht ordnungsgemäß läuft.
Bei korrekter Einrichtung sollte das Dashboard [Kubernetes]{.guihint} in
etwa so aussehen:
:::

:::: imageblock
::: content
![Kubernetes-Dashbaord mit Daten für CPU resources und Memory
resources](../images/kubernetes_monitoring_validation_dashboard.png)
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
:::::::::::::::
::::::::::::::::

:::::::::::: sect1
## []{#_monitoring_komponenten_aus_cluster_entfernen .hidden-anchor .sr-only}7. Monitoring-Komponenten aus Cluster entfernen {#heading__monitoring_komponenten_aus_cluster_entfernen}

::::::::::: sectionbody
::: paragraph
Wenn Sie Checkmk über unsere Helm-Charts in Ihrem Cluster bereitgestellt
haben, können Sie die erstellten Accounts, Services, Pods und Node Ports
genauso leicht wieder entfernen, wie Sie sie eingerichtet haben.
Deinstallieren Sie dafür einfach das Release, welches Sie mithilfe
unserer Charts [installiert](#install_helm_charts) haben.
:::

::: paragraph
Sollten Sie sich beim Namen des Releases unsicher sein, lassen Sie sich
zuerst alle Helm-Releases in allen Namespaces anzeigen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm list --all-namespaces
NAME        NAMESPACE           REVISION  UPDATED                                   STATUS    CHART          APP VERSION
myrelease   checkmk-monitoring  1         2022-08-15 19:00:42.318666784 +0200 CEST  deployed  checkmk-1.0.1  1.0.1
```
:::
::::

::: paragraph
Wie in der obigen Beispielausgabe sollten Sie hier ein Release finden,
welches in der Spalte `CHART` einen Hinweis auf Checkmk enthält.
:::

::: paragraph
Entfernen Sie dieses Release anschließend - unter Angabe des korrekten
Namespaces - mit folgendem Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ helm uninstall myrelease -n checkmk-monitoring
release "myrelease" uninstalled
```
:::
::::
:::::::::::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
