:::: {#header}
# Amazon Web Services (AWS) überwachen

::: details
[Last modified on 11-Jul-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_aws.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Microsoft Azure überwachen](monitoring_azure.html) [Katalog der
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
![logo aws](../images/logo_aws.png){width="140"}
:::
::::

::: paragraph
Checkmk enthält ein umfangreiches Monitoring von Amazon Web Services
(AWS), welches aus einem Konnektor zu AWS und einer stattlichen Sammlung
von Check-Plugins besteht, die für Sie verschiedenste Metriken und
Zustände abrufen und auswerten.
:::

::: paragraph
Neben den allgemeinen Informationen zu den
[Kosten](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_costs){target="_blank"}
Ihrer AWS-Umgebung und dem aktuellen
[Status](https://checkmk.com/de/integrations/aws_status){target="_blank"}
der AWS-Dienste in Ihrer Region, können Sie mit allen Editionen von
Checkmk die folgenden AWS-Produkte überwachen:
:::

::: ulist
- [Elastic Compute Cloud
  (EC2)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_ec2)

- [Elastic Block Store
  (EBS)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_ebs){target="_blank"}

- [Simple Storage Service
  (S3)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_s3){target="_blank"}
  und [S3
  Glacier](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_glacier){target="_blank"}

- [Relational Database Service
  (RDS)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_rds){target="_blank"}

- [DynamoDB](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_dynamodb)

- [Elastic Load Balancing (ELB) - Application, Network,
  Classic](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_elb){target="_blank"}

- [CloudWatch](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_cloudwatch){target="_blank"}

- [AWS Web Application Firewall
  (WAF)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_waf){target="_blank"}
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
- [AWS
  Lambda](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_lambda){target="_blank"}

- [Elastic Container Service
  (ECS)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_ecs){target="_blank"}

- [Route
  53](https://checkmk.com/de/integrations/aws_route53){target="_blank"}

- [CloudFront](https://checkmk.com/de/integrations/aws_cloudfront){target="_blank"}

- [ElastiCache for
  Redis](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=elasticache){target="_blank"}

- [Simple Notification Service
  (SNS)](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=aws_sns){target="_blank"}
:::

::: paragraph
Eine vollständige Auflistung aller verfügbaren Check-Plugins für die
Überwachung von Amazon Web Services finden Sie in unserem [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=aws){target="_blank"}
und wie Sie Ihre Amazon-EKS-Cluster (Amazon Elastic Kubernetes Service)
ins Monitoring aufnehmen, beschreiben wir im Artikel [Kubernetes
überwachen](monitoring_kubernetes.html).
:::
:::::::::::
::::::::::::

:::::::::: sect1
## []{#implementation .hidden-anchor .sr-only}2. Konkrete Umsetzung der AWS-Überwachung {#heading_implementation}

::::::::: sectionbody
:::::: sect2
### []{#_hosts_und_services .hidden-anchor .sr-only}2.1. Hosts und Services {#heading__hosts_und_services}

::: paragraph
In Checkmk ordnen sich alle zu überwachenden Objekte in eine
hierarchische Struktur von Hosts und Services ein. Nun gibt es bei
Cloud-basierten Diensten das Konzept von Hosts nicht. Um die Einfachheit
und Konsistenz von Checkmk zu bewahren, bilden wir dennoch AWS-Objekte
auf das Schema Host/Service ab.
:::

::: paragraph
Wie das geht, zeigt am besten ein Beispiel: In einer Region sind mehrere
EC2-Instanzen konfiguriert. Einer EC2 sind üblicherweise EBS zugeordnet.
Diese Konstellation sieht in Checkmk wie folgt aus:
:::

::: ulist
- Es gibt einen Host, der dem AWS-Account entspricht. Dieser gibt eine
  Übersicht aller EC2-Instanzen und deren Status als Service.

- Die EC2-Instanzen selbst sind wiederum eigene Hosts.

- Auf diesen EC2-Hosts finden Sie Services mit den eigentlichen
  Metriken.

- Die EBS werden als eine Art Festplatten interpretiert und liefern
  dementsprechend Metriken zu I/O (z.B. gelesene oder geschriebene
  Anzahl an Bytes). Dazu existieren in Checkmk eigene Services mit dem
  Namen `AWS/EBS Disk IO` pro EBS, die der EC2-Instanz zugeordnet
  werden.
:::
::::::

:::: sect2
### []{#_zugriff_auf_aws .hidden-anchor .sr-only}2.2. Zugriff auf AWS {#heading__zugriff_auf_aws}

::: paragraph
AWS stellt eine HTTP-basierte API bereit, über die auch Monitoring-Daten
abrufbar sind. Checkmk greift auf diese API über den
[Spezialagenten](glossar.html#special_agent) `agent_aws` zu, welcher an
die Stelle des Checkmk-Agenten tritt, aber anders als dieser lokal auf
dem Checkmk-Server ausgeführt wird.
:::
::::
:::::::::
::::::::::

:::::::::::::::::::::::::: sect1
## []{#preparation .hidden-anchor .sr-only}3. AWS für Checkmk vorbereiten {#heading_preparation}

::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_benutzer_anlegen .hidden-anchor .sr-only}3.1. Benutzer anlegen {#heading__benutzer_anlegen}

::: paragraph
Um die Überwachung per Checkmk zu ermöglichen, legen Sie am besten dafür
einen speziellen AWS-Benutzer unterhalb Ihres Root-Accounts an. [Loggen
Sie sich](https://console.aws.amazon.com){target="_blank"} dafür bei AWS
als Root-Benutzer ein und navigieren Sie unter [All services]{.guihint}
zu [Security, Identity, & Compliance \> IAM]{.guihint} (Identity and
Access Management). Gehen Sie hier auf [Users]{.guihint} und legen Sie
mit [Add user]{.guihint} einen neuen Benutzer an. Als Benutzername
wählen Sie z.B. `check-mk`. Wichtig ist, dass Sie bei [Select AWS
credential type]{.guihint} den [Access key - Programmatic
access]{.guihint} auswählen.
:::

:::: {.imageblock .border}
::: content
![aws create user](../images/aws_create_user.png)
:::
::::
::::::

:::::: sect2
### []{#_berechtigungen .hidden-anchor .sr-only}3.2. Berechtigungen {#heading__berechtigungen}

::: paragraph
Der soeben angelegte Benutzer sollte nur für das Monitoring durch
Checkmk verwendet werden und benötigt ausschließlich lesenden Zugriff
auf AWS. Wir empfehlen diesem Benutzer ausschließlich die Policy
[ReadOnlyAccess]{.guihint} zuzuweisen. Um diese Policy zu finden,
klicken Sie zuerst auf [Attach existing policies directly]{.guihint} und
geben anschließend `readonlyaccess` in das Suchfeld ein. In der Liste
unter dem Suchfeld müssen Sie dennoch weit nach unten scrollen, da es
eine ganze Reihe Policies gibt, die diesen String enthalten:
:::

:::: imageblock
::: content
![aws create user policies](../images/aws_create_user_policies.png)
:::
::::
::::::

::::::::: sect2
### []{#_schlüssel .hidden-anchor .sr-only}3.3. Schlüssel {#heading__schlüssel}

::: paragraph
Nach dem Abschluss des Anlegens des Benutzers wird für Sie automatisch
ein Zugangsschlüssel erzeugt. **Achtung:** Das Secret des Schlüssels
wird nur ein einziges Mal --- direkt nach dem Erzeugen --- angezeigt.
Kopieren Sie daher unbedingt den Schlüssel und legen ihn z.B. im
Checkmk-Passwortspeicher ab. Alternativ geben Sie ihn im Klartext in der
Regel an (siehe unten). Für Checkmk benötigen Sie neben dem Secret noch
die [Access key ID.]{.guihint} Der Name des Benutzers (bei uns
`check-mk`) spielt hier keine Rolle.
:::

:::: imageblock
::: content
![aws create user key](../images/aws_create_user_key.png)
:::
::::

::: paragraph
Falls Sie das Secret trotzdem einmal verlieren sollten, können Sie für
den Benutzer einen neuen Access Key anlegen und bekommen ein neues
Secret:
:::

:::: imageblock
::: content
![aws create access key](../images/aws_create_access_key.png)
:::
::::
:::::::::

::::::::: sect2
### []{#_zugriff_auf_billing_informationen .hidden-anchor .sr-only}3.4. Zugriff auf Billing-Informationen {#heading__zugriff_auf_billing_informationen}

::: paragraph
Wenn Sie möchten, dass Checkmk auch Lesezugriff auf die
Abrechnungsinformationen bekommt (um den globalen Check [Costs and
Usage]{.guihint} ausführen zu können), benötigen Sie für Ihren
AWS-Benutzer eine weitere Richtlinie (*policy*), die Sie allerdings erst
selbst definieren müssen.
:::

::: paragraph
Wählen Sie dazu unter [Security, Identity, & Compliance \> IAM \>
Policies]{.guihint} den Knopf [Create Policy.]{.guihint} Wählen Sie
unter [Select a Service \> Service \> Choose a Service]{.guihint} den
Service [Billing]{.guihint} aus. Unter [Actions]{.guihint} kreuzen Sie
die Checkbox [Read]{.guihint} an. Sie müssen noch eine weitere
Berechtigung setzen. Fügen Sie diese mit dem Knopf [Add additional
permissions]{.guihint} hinzu. Wählen Sie in der neuen Box unter [Select
a Service \> Service \> Choose a Service]{.guihint} den Service [Cost
Explorer Service]{.guihint} aus. Unter [Actions]{.guihint} kreuzen Sie
die Checkbox [Read]{.guihint} an.
:::

:::: imageblock
::: content
![aws policies](../images/aws_policies.png)
:::
::::

::: paragraph
Mit dem Knopf [Review]{.guihint} geht es zum Schritt zwei. Legen Sie
dort als [Name]{.guihint} `BillingViewAccess` an und speichern Sie mit
dem Knopf [Create policy.]{.guihint}
:::

::: paragraph
Diese neue Richtlinie müssen Sie jetzt noch dem Benutzer hinzufügen.
Dazu gehen Sie wieder zu [Security, Identity, & Compliance \> IAM \>
Policies]{.guihint}, suchen im Suchfeld [Filter Policies]{.guihint} nach
`BillingViewAccess`, wählen diese durch Klick in den Kreis link aus und
gehen dann auf [Policy actions \> Attach]{.guihint}. Hier finden Sie
Ihren `check-mk`-Benutzer, den Sie auswählen und mit [Attach
policy]{.guihint} bestätigen.
:::
:::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}4. Monitoring in Checkmk konfigurieren {#heading_setup}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#create_host .hidden-anchor .sr-only}4.1. Host für AWS anlegen {#heading_create_host}

::: paragraph
Legen Sie für die Überwachung von AWS nun einen Host in Checkmk an. Den
Host-Namen können Sie nach Belieben vergeben. Wichtig: Da AWS als Dienst
keine IP-Adresse oder DNS-Namen hat (den Zugriff macht der Spezialagent
von selbst), müssen Sie die [IP address family]{.guihint} auf [No
IP]{.guihint} einstellen.
:::

:::: imageblock
::: content
![monitoring aws add host no
ip](../images/monitoring_aws_add_host_no_ip.png)
:::
::::
::::::

:::::::::::::::::: sect2
### []{#agent_rule .hidden-anchor .sr-only}4.2. Den AWS-Agenten konfigurieren {#heading_agent_rule}

::: paragraph
AWS kann nicht über den normalen Checkmk-Agenten abgefragt werden.
Richten Sie daher jetzt den [Spezialagenten](glossar.html#special_agent)
für AWS ein. Dazu legen Sie unter [Setup \> Agents \> VM, cloud,
container \> Amazon Web Services (AWS)]{.guihint} eine Regel an, deren
[Bedingungen](wato_rules.html#conditions) ausschließlich auf den gerade
angelegten AWS-Host greifen.
:::

::: paragraph
Beim eigentlichen Inhalt der Regel finden Sie zunächst die Angaben für
den Login. Hier tragen Sie die „Access Key ID" des angelegten
AWS-Benutzers `check-mk` ein. Auch wählen Sie hier, ob Sie einen Proxy
benötigen, um auf die Daten zuzugreifen und welche globalen Daten Sie
überwachen möchten. Das sind solche, die unabhängig von einer Region
sind. Aktuell sind hier lediglich die Daten über die Kosten auswählbar:
:::

:::: imageblock
::: content
![aws rule 1](../images/aws_rule_1.png)
:::
::::

::: paragraph
Im obigen Bild sehen Sie außerdem die Option [Use STS AssumeRole to
assume a different IAM role.]{.guihint} Sollten Sie einen oder mehrere
weitere Accounts bei AWS haben, können Sie mit einem einzigen
Monitoring-Benutzer alle anderen ebenfalls überwachen.
:::

::: paragraph
Die eigentlich interessanten Daten aber sind einzelnen Regionen
zugeordnet. Wählen Sie also hier Ihre AWS-Region(en) aus:
:::

:::: imageblock
::: content
![aws rule 2](../images/aws_rule_2.png)
:::
::::

::: paragraph
Unter [Services per region to monitor]{.guihint} legen Sie nun fest,
welche Informationen Sie in diesen Regionen abrufen möchten. In der
Standardkonfiguration sind alle AWS-Dienste und die Überwachung derer
[Limits](#limits) uneingeschränkt aktiviert. Der Übersichtlichkeit
halber wurden im folgenden Bild aber alle bis auf einen deaktiviert:
:::

:::: imageblock
::: content
![aws rule 3](../images/aws_rule_3.png)
:::
::::

::: paragraph
Diese können Sie dann pro Webdienst oder global mit [Restrict monitoring
services by one of these AWS tags]{.guihint} wieder einschränken. Wenn
Sie pro Webdienst einschränken, wird damit immer die globale Option
überschrieben. Ihnen steht hier zusätzlich zu den AWS Tags auch noch die
Möglichkeit zur Verfügung, explizite Namen anzugeben:
:::

:::: imageblock
::: content
![aws rule 4](../images/aws_rule_4.png)
:::
::::

::: paragraph
Letztendlich müssen Sie noch den Spezialagenten dem vorher erstellten
Host zuordnen, indem Sie den Host-Namen in [Conditions \> Explicit
hosts]{.guihint} eintragen.
:::
::::::::::::::::::

:::::: sect2
### []{#_services_auf_dem_aws_host_selbst .hidden-anchor .sr-only}4.3. Services auf dem AWS-Host selbst {#heading__services_auf_dem_aws_host_selbst}

::: paragraph
Wechseln Sie nun in Checkmk zur Service-Erkennung des neu angelegten
AWS-Hosts, wo Checkmk nun etliche Services finden sollte. Nachdem Sie
die Services hinzugefügt haben, sieht das nach einem [Aktivieren der
Änderungen](wato.html#activate_changes) etwa so im Monitoring aus:
:::

:::: imageblock
::: content
![aws services ec](../images/aws_services_ec.png)
:::
::::
::::::

::::::::::::::::::::::: sect2
### []{#ec2-hosts .hidden-anchor .sr-only}4.4. Hosts für die EC2-Instanzen anlegen {#heading_ec2-hosts}

::: paragraph
Services, die EC2-Instanzen zugeordnet sind, werden nicht dem AWS-Host
zugeordnet, sondern sogenannten
[Piggyback-Hosts](glossar.html#piggyback). Dies funktioniert so, dass
Daten, die vom AWS-Host abgerufen wurden, an diese Piggyback-Hosts, die
ohne eigene Monitoring-Agenten arbeiten, verteilt werden. Dabei wird
jeder EC2-Instanz ein Piggyback-Host zugeordnet.
:::

::: paragraph
Für die Benamsung dieser Piggyback-Hosts haben Sie bei der Konfiguration
des Spezialagenten die Wahl zwischen zwei Schemata. Zum einen können Sie
die Hosts nach ihrem privaten IP DNS-Namen benennen lassen oder Sie
wählen die etwas längere aber dafür eindeutige Benamsung nach IP, Region
und Instanz-ID. Letztere Variante ist ab Checkmk [2.2.0]{.new} unsere
Standardeinstellung. Die Variante ohne Region und Instanz-ID wird nur
aus Gründen der Kompatibilität weiterhin angeboten. Ein solcher
Piggyback-Host könnte also bspw.
`172.23.1.123-ap-northeast-2-i-0b16121900a32960c` heißen. Legen Sie
diese Hosts entweder von Hand an oder - falls möglich - überlassen Sie
diese Aufgabe der dynamischen Host-Verwaltung.
:::

:::::::::::: sect3
#### []{#_dynamische_host_verwaltung_einrichten .hidden-anchor .sr-only}Dynamische Host-Verwaltung einrichten {#heading__dynamische_host_verwaltung_einrichten}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Als Nutzer einer
unserer kommerziellen Editionen können Sie die Erstellung und Löschung
von Hosts für Ihre EC2-Instanzen einfach der [dynamischen
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
Im Rahmen der Überwachung Ihrer AWS-Umgebung sollte die Option [Restrict
source hosts]{.guihint} aktiviert werden. Tragen Sie hier Ihren AWS-Host
aus dem Abschnitt [Host für AWS anlegen](#create_host) ein.
:::

::: paragraph
Eine exemplarische Konfiguration der Verbindung könnte dann so aussehen:
:::

:::: imageblock
::: content
![Exemplarische Konfiguration der Connection
Properties.](../images/monitoring_aws_connection_properties.png)
:::
::::
::::::::::::

:::::::::: sect3
#### []{#_hosts_für_ec2_instanzen_manuell_anlegen .hidden-anchor .sr-only}Hosts für EC2-Instanzen manuell anlegen {#heading__hosts_für_ec2_instanzen_manuell_anlegen}

::: paragraph
Alternativ können Sie Hosts für die Piggyback-Daten auch manuell
anlegen. Dabei ist es wichtig, dass die Namen der Hosts exakt dem [oben
beschriebenen Schema](#ec2-hosts) entsprechen.
:::

::: paragraph
**Tipp:** Mit dem Skript `find_piggy_orphans` aus dem
treasures-Verzeichnis finden Sie alle Piggyback-Hosts, für die es zwar
Daten gibt, die aber noch nicht als Hosts in Checkmk angelegt sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/doc/check_mk/treasures/find_piggy_orphans
172.23.1.123-ap-northeast-2-i-0b16121900a32960c
172.23.1.124-ap-northeast-2-i-0b32960a16121900c
```
:::
::::

::: paragraph
Konfigurieren Sie die Hosts für diese EC2-Instanzen ohne IP-Adresse
(analog zum AWS-Host) und wählen Sie als Monitoring-Agent [No API
integrations, no Checkmk agent]{.guihint} aus. Wenn Sie unter
[Piggyback]{.guihint} auch noch die Option [Always use and expect
piggyback data]{.guihint} wählen, werden Sie beim Ausbleiben der Daten
entsprechend gewarnt.
:::

:::: imageblock
::: content
![monitoring aws add host for piggyback
data](../images/monitoring_aws_add_host_for_piggyback_data.png)
:::
::::
::::::::::
:::::::::::::::::::::::

:::: sect2
### []{#_hosts_für_elb_classic_load_balancer .hidden-anchor .sr-only}4.5. Hosts für ELB (Classic Load Balancer) {#heading__hosts_für_elb_classic_load_balancer}

::: paragraph
Auch die Services für die ELB werden Piggyback-Hosts zugeordnet. Die
Namen dafür entsprechen deren DNS-Namen.
:::
::::

:::::::::::: sect2
### []{#_traffic_statistiken_von_s3_buckets_überwachen .hidden-anchor .sr-only}4.6. Traffic-Statistiken von S3 Buckets überwachen {#heading__traffic_statistiken_von_s3_buckets_überwachen}

::: paragraph
Mit Checkmk können Sie den Traffic jedes einzelnen S3 Buckets
überwachen. In Checkmk müssen Sie dazu lediglich die Option [Request
metrics]{.guihint} unterhalb von [Simple Storage Service (S3)]{.guihint}
aktivieren.
:::

:::: imageblock
::: content
![Option für S3-Buckets mit aktivierten Request
Metrics.](../images/monitoring_aws_request_metrics.png){width="68%"}
:::
::::

::: paragraph
In AWS ist ein wenig mehr Arbeit erforderlich. Hier müssen Sie eben
diese *Request metrics* noch für die gewünschten Buckets einrichten. Wie
das funktioniert beschreibt AWS detailliert in dem Artikel [Erstellen
einer CloudWatch-Metrik-Konfiguration für alle Objekte in Ihrem
Bucket.](https://docs.aws.amazon.com/de_de/AmazonS3/latest/userguide/configure-request-metrics-bucket.html){target="_blank"}
Während der Einrichtung in AWS müssen Sie einen Filter erzeugen. Diesen
Filter **müssen** Sie `EntireBucket` nennen, damit dieser von Checkmk
erkannt wird. Filter mit anderen Namen wird Checkmk ignorieren. Es steht
Ihnen also frei, weitere Filter für diesen Bucket zu definieren, ohne
die Funktionalität in Checkmk zu beeinflussen.
:::

:::: imageblock
::: content
![Einrichtung eines Filters für die Request
Metrics.](../images/monitoring_aws_s3_create_filter.png)
:::
::::

::: paragraph
Wie Sie den sogenannten (Filter) [Scope]{.guihint} in AWS wählen, steht
Ihnen ebenfalls frei. In den meisten Fällen wird es allerdings sinnvoll
sein, alle Objekte des Buckets in den Filter aufzunehmen.
:::

::: paragraph
Nach der Einrichtung der *Request metrics* wird es noch einige Minuten
dauern, bis überhaupt Metriken gespeichert sind. AWS gibt diese Zeit mit
15 Minuten an.
:::

::: paragraph
**Wichtig:** Solange die Graphen innerhalb der S3-Konsole noch leer
sind, wird auch über den Spezialagenten nichts in Checkmk ankommen. Erst
wenn auch Metriken aufgezeichnet wurden, kann Checkmk die entsprechenden
Services anlegen. Führen Sie also gegebenenfalls erneut eine
[Service-Erkennung](wato_services.html#discovery) auf dem AWS-Host
durch.
:::
::::::::::::

::::::: sect2
### []{#limits .hidden-anchor .sr-only}4.7. Limits überwachen {#heading_limits}

::: paragraph
Einige Webdienste von AWS bringen Limits mit und Checkmk kann diese auch
überwachen. Dazu gehören zum Beispiel diese:
:::

::: ulist
- [AWS EBS:
  Limits](https://checkmk.com/de/integrations/aws_ebs_limits){target="_blank"}

- [AWS EC2:
  Limits](https://checkmk.com/de/integrations/aws_ec2_limits){target="_blank"}

- [AWS ELB:
  Limits](https://checkmk.com/de/integrations/aws_elb_limits){target="_blank"}

- [AWS ELBv2: Application and Network
  Limits](https://checkmk.com/de/integrations/aws_elbv2_limits){target="_blank"}

- [AWS Glacier:
  Limits](https://checkmk.com/de/integrations/aws_glacier_limits){target="_blank"}

- [AWS RDS:
  Limits](https://checkmk.com/de/integrations/aws_rds_limits){target="_blank"}

- [AWS S3:
  Limits](https://checkmk.com/de/integrations/aws_s3_limits){target="_blank"}

- [AWS CloudWatch: Alarm
  Limits](https://checkmk.com/de/integrations/aws_cloudwatch_alarms_limits){target="_blank"}
:::

::: paragraph
Sobald ein solches Check-Plugin Services erzeugt und diese später prüft,
werden immer **alle** Elemente des Webdienstes geholt. Nur so kann
Checkmk sinnvoll die aktuelle Auslastung zu diesen Limits berechnen und
entsprechend Schwellwerte prüfen. Das gilt auch dann, wenn Sie in der
Konfiguration die Daten auf bestimmte Namen oder Tags einschränken.
:::

::: paragraph
In der Grundkonfiguration sind die Limits automatisch aktiviert. Wenn
Sie also die zu holenden Daten in der [Regel zum
Spezialagenten](#agent_rule) einschränken, weil Sie die zu übertragenden
Daten reduzieren wollen, schalten Sie ebenfalls die Limits ab.
:::
:::::::

:::: sect2
### []{#_weitere_services .hidden-anchor .sr-only}4.8. Weitere Services {#heading__weitere_services}

::: paragraph
Die weiteren Services von AWS werden wie folgt zugeordnet:
:::

+------+-----------------+---------------------------------------------+
|      | Service         | Zuordnung                                   |
+======+=================+=============================================+
| CE   | Costs & Usage   | Beim AWS-Host                               |
+------+-----------------+---------------------------------------------+
| EBS  | Block Storages  | Werden der EC2-Instanz angefügt, sofern     |
|      |                 | diese der Instanz gehören, ansonsten dem    |
|      |                 | AWS-Host                                    |
+------+-----------------+---------------------------------------------+
| S3   | Simple Storages | Beim AWS-Host                               |
+------+-----------------+---------------------------------------------+
| RDS  | Relational      | Beim AWS-Host                               |
|      | Databases       |                                             |
+------+-----------------+---------------------------------------------+
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::: sect1
## []{#dashboards .hidden-anchor .sr-only}5. Dashboards {#heading_dashboards}

:::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Zum komfortablen
Einstieg in die Überwachung von AWS liefert Checkmk ab Checkmk Cloud die
beiden eingebauten [Dashboards](glossar.html#dashboard) [AWS EC2
instances]{.guihint} und [AWS S3]{.guihint} mit aus. Beide finden Sie im
Monitoring als Menüeinträge unter [Monitor \> Cloud.]{.guihint}
:::

::: paragraph
Damit Sie einen direkten Eindruck bekommen, finden Sie nachfolgend zwei
Beispiele, wie diese Dashboards aufgebaut sind. Zuerst das Dashboard zu
den EC2-Instanzen, bei der Sie auf der linken Seite den aktuellen
Zustand und auf der rechten Seite den zeitlichen Verlauf der wichtigsten
Metriken vergleichen können:
:::

:::: imageblock
::: content
![Dashboard zu den AWS
EC2-Instanzen.](../images/monitoring_aws_dashboard_vm.png)
:::
::::

::: paragraph
Das Dashboard zu den S3 Buckets ist ganz ähnlich aufgebaut. Auf der
linken Seite finden Sie die aktuelle Speicherauslastung der jeweiligen
Buckets. Auf der rechten werden wieder die wichtigsten Metriken im
zeitlichen Verlauf dargestellt:
:::

:::: imageblock
::: content
![Dashboard zu den AWS S3
Buckets.](../images/monitoring_aws_dashboard_storage.png)
:::
::::
::::::::::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
