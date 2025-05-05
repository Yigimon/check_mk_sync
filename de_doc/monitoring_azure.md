:::: {#header}
# Microsoft Azure überwachen

::: details
[Last modified on 19-Oct-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_azure.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
:::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![azure logo](../images/azure_logo.png){width="140"}
:::
::::

::: paragraph
Checkmk enthält ein umfangreiches Monitoring von Microsoft Azure,
welches aus einem Konnektor zu Azure und einer stattlichen Sammlung von
Check-Plugins besteht, die für Sie verschiedenste Metriken und Zustände
abrufen und auswerten.
:::

::: paragraph
Neben den allgemeinen Informationen zu den
[Kosten](https://checkmk.com/de/integrations/azure_usagedetails){target="_blank"}
Ihrer Azure-Umgebung und dem aktuellen
[Status](https://checkmk.com/de/integrations/azure_status){target="_blank"}
der Azure-Dienste in Ihrer Region, können Sie mit allen Editionen von
Checkmk die folgenden Microsoft Azure-Produkte überwachen:
:::

::: ulist
- [Virtual
  Machines](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_vm){target="_blank"}

- [Storage
  Accounts](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_storageaccounts){target="_blank"}

- [MySQL
  Database](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_mysql){target="_blank"}

- [PostgreSQL
  Database](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_postgresql){target="_blank"}

- [SQL
  Database](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_databases){target="_blank"}

- [Load
  Balancer](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_load_balancer){target="_blank"}

- [Virtual Network
  Gateways](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_virtual_network){target="_blank"}

- [Traffic
  Manager](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_traffic_manager){target="_blank"}

- [Active Directory (AD)
  Connect](https://checkmk.com/de/integrations?distributions%5B%5D=check_mk&distributions%5B%5D=check_mk_cloud&search=azure_ad){target="_blank"}

- [Webserver](https://checkmk.com/de/integrations/azure_sites){target="_blank"}
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
- [Application
  Gateway](https://checkmk.com/de/integrations/azure_app_gateway){target="_blank"}

- [Recovery Services
  vaults](https://checkmk.com/de/integrations/azure_vault_backup_containers){target="_blank"}
:::

::: paragraph
Eine vollständige Auflistung aller verfügbaren Check-Plugins für die
Überwachung von Azure finden Sie in unserem [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=azure){target="_blank"}
und wie Sie Ihre AKS-Cluster (Azure Kubernetes Service) ins Monitoring
aufnehmen, beschreiben wir im Artikel [Kubernetes
überwachen](monitoring_kubernetes.html).
:::
:::::::::::
::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#preparation .hidden-anchor .sr-only}2. Azure für Checkmk vorbereiten {#heading_preparation}

::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Um Azure mit Checkmk zu überwachen, benötigen Sie einige Daten aus Ihrer
Azure-Umgebung. Mindestens die Directory-ID (auch Tenant-ID genannt) und
eine Application-ID (auch Client-ID genannt) werden zwingend benötigt.
In den meisten Fällen müssen Sie auch Ihre Subskriptions-ID angeben.
Letztere benötigen Sie nur dann **nicht**, wenn Sie **ausschließlich**
Ihr Azure AD überwachen wollen.
:::

::: paragraph
In den folgenden Kapiteln zeigen wir Ihnen, wo Sie diese Daten finden
bzw. welche Voraussetzungen Sie dafür schaffen müssen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | An dieser Stelle ist zu sagen,    |
|                                   | dass sich Webportale von          |
|                                   | Hyperscalern und Anbietern von    |
|                                   | Cloud-Diensten mit schöner        |
|                                   | Regelmäßigkeit ändern. Wir        |
|                                   | bemühen uns, die folgenden        |
|                                   | Informationen aktuell und         |
|                                   | gleichzeitig so allgemein zu      |
|                                   | halten, dass die jeweiligen Orte  |
|                                   | und Funktionen im Portal auch     |
|                                   | auffindbar bleiben, wenn ein      |
|                                   | Screenshot mal nicht mehr zu 100  |
|                                   | % zum Gesehenen passt.            |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::::::::: sect2
### []{#app_registration .hidden-anchor .sr-only}2.1. App anlegen {#heading_app_registration}

::: paragraph
Registrieren Sie zunächst eine App in Azure. Über diese App wird Checkmk
die gewünschten Daten aus Azure auslesen. Sie finden die Option dafür im
[Azure-Portal](https://portal.azure.com){target="_blank"} unter [(All
services \> Identity \> Identity management \> ) App
registrations]{.guihint}. Alternativ können Sie hier die Suche des
Portals verwenden und dort `App registrations` eingeben. Auf der Seite
angekommen, müssen Sie nun auf [New registration]{.guihint} klicken.
:::

::: paragraph
Vergeben Sie einen Namen Ihrer Wahl. Im Beispiel verwenden wir
`my-checkmk-app`. Der Name ist jedoch nur informativ. Der Bezug auf die
App wird stattdessen über die Application-ID hergestellt, die Sie in
einem nächsten Schritt angezeigt bekommen. Im Abschnitt [Supported
account types]{.guihint} müssen Sie nichts ändern und das Feld [Redirect
URI]{.guihint} muss leer bleiben. Bestätigen Sie Ihre Eingaben mit einem
Klick auf [Register]{.guihint}.
:::

:::: {.imageblock .border}
::: content
![azure register 1](../images/azure_register_1.png)
:::
::::

::: paragraph
Nachdem Sie die App angelegt haben, sollten Sie in einer Übersicht zu
dieser neuen App landen. Ist dem nicht so, finden Sie die neue App in
der oben beschriebenen Liste aller [App registrations]{.guihint} im
Reiter [All applications]{.guihint}. In den Details der App finden Sie
nun sowohl die [Application (client) ID]{.guihint} als auch die
[Directory (tenant) ID]{.guihint}, welche Sie später in Checkmk
eintragen müssen.
:::

:::: {.imageblock .border}
::: content
![azure register 2](../images/azure_register_2.png)
:::
::::
::::::::::

:::::::::::: sect2
### []{#client_secret .hidden-anchor .sr-only}2.2. Client-Schlüssel für die App anlegen {#heading_client_secret}

::: paragraph
Nun brauchen Sie noch einen geheimen Client-Schlüssel (im Englischen
schlicht *client secret* genannt), mit dem sich Checkmk bei der API von
Azure anmelden kann. Um einen solchen Schlüssel zu erzeugen, klicken Sie
in der Übersicht der App auf [Certificates & secrets]{.guihint}, dann
auf den Reiter [Client secrets]{.guihint} und schließlich auf [New
client secret.]{.guihint}
:::

:::: {.imageblock .border}
::: content
![azure register 5](../images/azure_register_5.png)
:::
::::

::: paragraph
Dadurch öffnet sich der Dialog [Add a client secret]{.guihint}. Vergeben
Sie einen beliebigen Namen und wählen Sie aus, wie lange der Schlüssel
gültig sein soll. Wenn Sie später, in der [Regel für den
Spezialagenten,](#azure_agent) die Option [App Registrations]{.guihint}
aktiveren, bekommen Sie einen praktischen Service, der Sie daran
erinnert, wenn sich diese Gültigkeitsdauer dem Ende nähert. Bestätigen
Sie den Dialog mit einem Klick auf [Add.]{.guihint}
:::

:::: imageblock
::: content
![azure register 6](../images/azure_register_6.png){width="76%"}
:::
::::

::: paragraph
Jetzt ist es wichtig, dass Sie den [Value]{.guihint} dieses neuen
Schlüssel umgehend kopieren. Nach einer gewissen Zeit werden im
Azure-Portal nur noch die ersten drei Zeichen solcher Schlüssel
angezeigt.
:::

:::: {.imageblock .border}
::: content
![monitoring azure copy
secret](../images/monitoring_azure_copy_secret.png)
:::
::::
::::::::::::

::::::: sect2
### []{#_optional_weitere_api_berechtigungen_hinzufügen .hidden-anchor .sr-only}2.3. Optional: Weitere API-Berechtigungen hinzufügen {#heading__optional_weitere_api_berechtigungen_hinzufügen}

::: paragraph
Sie müssen der App zusätzliche API-Berechtigungen erteilen, wenn Sie die
folgenden Services mit Checkmk überwachen möchten:
:::

::: ulist
- Users in the Active Directory

- AD Connect Sync

- App Registrations
:::

::: paragraph
Die Vergabe der Berechtigungen starten Sie in der Übersicht Ihrer neuen
App, die Sie noch vom vorherigen Abschnitt geöffnet haben sollten.
:::

::: paragraph
Klicken Sie auf [API permissions]{.guihint} und anschließend auf [Add a
permission.]{.guihint} In dem Dialog, der sich öffnet, müssen Sie den
Punkt [Microsoft Graph]{.guihint} finden und anklicken. Wählen Sie
anschließend [Application permissions]{.guihint} und tippen Sie
`Directory.Read.All` in die Suche ein. Aktivieren Sie die zugehörige
Checkbox und klicken Sie auf [Add permissions]{.guihint}. Für diese
Berechtigung wird eine zusätzliche Zustimmung durch einen Administrator
Ihrer Azure-Umgebung benötigt ([Admin consent required]{.guihint}.) Wenn
Sie über der Liste der erteilten Berechtigungen nicht den Knopf [Grant
admin consent]{.guihint} sehen, müssen Sie sich an einen solchen Admin
wenden.
:::
:::::::

:::::::::::: sect2
### []{#assign_role .hidden-anchor .sr-only}2.4. Der App eine Rolle zuweisen {#heading_assign_role}

::: paragraph
Damit Checkmk über die neue App an die Monitoring-Daten kommen kann,
müssen Sie der App noch eine Rolle auf Ebene der Subskription zuweisen.
Wählen Sie dazu in der Hauptnavigation auf der linken Seite den Punkt
[All services]{.guihint} und dann unter [General]{.guihint} den Punkt
[Subscriptions.]{.guihint} Auch hier können Sie wieder die Suche im
Portal bemühen, wenn sich der entsprechende Knopf nicht finden lässt.
:::

::: paragraph
Eventuell müssen Sie nun noch den Namen der Subskription anklicken, die
Sie überwachen möchten. In der folgenden Übersicht finden Sie auch die
[Subscription ID]{.guihint}, die Sie später in die Regel des
Spezialagenten eintragen müssen. Sobald diese notiert ist, klicken Sie
auf [Access Control (IAM)]{.guihint} und dort auf [Add]{.guihint} und
dann auf [Add role assignment:]{.guihint}
:::

:::: {.imageblock .border}
::: content
![azure access control](../images/azure_access_control.png)
:::
::::

::: paragraph
Wählen Sie jetzt die Rolle aus, die [Reader]{.guihint} heißt und den
[Type]{.guihint} [BuiltInRole]{.guihint} hat. Da es insgesamt über 100
Rollen gibt, die das Wort Reader im Namen tragen, gilt es hier
aufmerksam zu sein. Klicken Sie anschließend auf [Next]{.guihint}, um
zum Reiter [Members]{.guihint} zu kommen.
:::

::: paragraph
Klicken Sie hier auf [+ Select members.]{.guihint}
:::

:::: {.imageblock .border}
::: content
![azure role assignment](../images/azure_role_assignment.png)
:::
::::

::: paragraph
Im Dialog [Select members]{.guihint} geben Sie im Suchfeld den Namen der
App ein, wie Sie ihn vorhin angelegt haben, wählen die App aus und
klicken auf [Select.]{.guihint} Nach zwei weiteren Klicks auf [Review +
assign]{.guihint} ist die Einrichtung im Azure-Portal abgeschlossen.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}3. Grundlegendes Monitoring in Checkmk konfigurieren {#heading_setup}

:::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Bevor Sie mit der Konfiguration in Checkmk starten, vergewissern Sie
sich, dass Sie die folgenden vier Azure-spezifischen Informationen parat
haben, die Sie sich im vorherigen Kapitel besorgt haben:
:::

::: {.olist .arabic}
1.  Ihre Tenant-ID (auch bekannt als „Directory-ID")

2.  Die Application-ID (Client-ID) der App

3.  Den geheimen Client-Schlüssel zu dieser App

4.  Ihre Subskriptions-ID
:::

::::::: sect2
### []{#create_host .hidden-anchor .sr-only}3.1. Host für Azure anlegen {#heading_create_host}

::: paragraph
Auch wenn Sie es bei Azure nicht mit einem physikalischen Host zu tun
haben, legen Sie in Checkmk für Ihr Azure-Directory einen Host an. Den
Host-Namen können Sie nach Belieben vergeben. Wichtig: Da Azure ein
Dienst ist und daher keine IP-Adresse oder DNS-Namen hat (den Zugriff
macht der Spezialagent von selbst), müssen Sie die [IP address
family]{.guihint} auf [No IP]{.guihint} einstellen.
:::

:::: imageblock
::: content
![azure wato no ip](../images/azure_wato_no_ip.png)
:::
::::

::: paragraph
Speichern Sie am besten mit [Save & Finish,]{.guihint} da die
Service-Erkennung natürlich noch nicht funktionieren kann.
:::
:::::::

:::::::: sect2
### []{#azure_agent .hidden-anchor .sr-only}3.2. Den Azure-Agenten konfigurieren {#heading_azure_agent}

::: paragraph
Da Azure nicht über den normalen Checkmk-Agenten abgefragt werden kann,
richten Sie jetzt den [Spezialagenten](glossar.html#special_agent) für
Azure ein, welcher auch als
[Datenquellenprogramm](datasource_programs.html) bezeichnet wird.
Hierbei kontaktiert Checkmk den Ziel-Host nicht wie üblich über TCP Port
6556, sondern ruft stattdessen ein Hilfsprogramm auf, welches mit dem
Zielsystem über ein die anwendungsspezifische API von Azure
kommuniziert.
:::

::: paragraph
Dazu legen Sie unter [Setup \> Agents \> VM, Cloud, Container \>
Microsoft Azure]{.guihint} eine Regel an, deren
[Bedingungen](wato_rules.html#conditions) ausschließlich auf den gerade
angelegten Azure-Host greifen. Dort finden Sie die Eingabefelder für die
IDs und das Secret:
:::

:::: imageblock
::: content
![azure agent rule](../images/azure_agent_rule.png)
:::
::::

::: paragraph
Hier können Sie auch die Ressourcengruppen oder Ressourcen auswählen,
die Sie überwachen möchten. Wenn Sie [explicitly specified
groups]{.guihint} **nicht** angekreuzt haben, werden automatisch alle
Ressourcengruppen überwacht.
:::
::::::::

::::::::: sect2
### []{#_test .hidden-anchor .sr-only}3.3. Test {#heading__test}

::: paragraph
Wenn Sie jetzt eine Service-Erkennung auf dem Azure-Host machen, sollte
auf diesem ein einziger Service mit dem Namen [Azure Agent
Info]{.guihint} erkannt werden:
:::

:::: imageblock
::: content
![azure services ok](../images/azure_services_ok.png)
:::
::::

::: paragraph
Falls der Zugriff auf die API nicht klappt (z.B. wegen einer falschen ID
oder fehlerhaften Berechtigungen), erscheint im Statustext von [Azure
Agent Info]{.guihint} eine Fehlermeldung der Azure-API:
:::

:::: imageblock
::: content
![azure services fail](../images/azure_services_fail.png)
:::
::::
:::::::::

::::::::::::::: sect2
### []{#resource_groups .hidden-anchor .sr-only}3.4. Ressourcengruppen als Hosts verfügbar machen {#heading_resource_groups}

::: paragraph
Aus Gründen der Übersichtlichkeit ist das Azure-Monitoring von Checkmk
so aufgebaut, dass jede Azure-Ressourcengruppe durch einen (sozusagen
logischen) Host im Checkmk repräsentiert wird. Dies geschieht mit Hilfe
des [Piggyback-Verfahrens](piggyback.html). Dabei werden Daten, die vom
Azure-Host per Spezialagenten abgerufen werden, innerhalb von Checkmk an
diese Ressourcengruppen-Hosts umgeleitet.
:::

::: paragraph
Die Ressourcengruppen-Hosts erscheinen nicht automatisch im Checkmk.
Legen Sie diese Hosts entweder von Hand an oder optional mit dem
[Dynamic Configuration Daemon (DCD).](dcd.html) Wichtig dabei ist, dass
die Namen der Hosts exakt mit den Namen der Ressourcengruppen
übereinstimmen --- und zwar auch die Groß-/Kleinschreibung! Wenn Sie
sich über die genaue Schreibung der Gruppen unsicher sind, können Sie
diese direkt aus dem Service [Azure Agent Info]{.guihint} auf dem
Azure-Host ablesen.
:::

::: paragraph
Übrigens: mit dem Hilfsskript `find_piggy_orphans` aus dem
treasures-Verzeichnis finden Sie alle Piggyback Hosts, für es Daten
gibt, die aber noch nicht als Host im Checkmk angelegt sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/doc/check_mk/treasures/find_piggy_orphans
Glastonbury
Woodstock
```
:::
::::

::: paragraph
Konfigurieren Sie die Ressourcengruppen-Hosts ohne IP-Adresse (analog
zum Azure-Host) und wählen Sie als Agent [No API integrations, no
Checkmk agent]{.guihint} und als Piggyback [Always use and expect
piggyback data]{.guihint} aus.
:::

:::: imageblock
::: content
![wato host no agent](../images/wato_host_no_agent.png)
:::
::::

::: paragraph
Wenn Sie jetzt die Service-Erkennung zu einem dieser
Ressourcengruppen-Hosts machen, finden Sie dort weitere Services, welche
speziell diese Ressourcengruppe betreffen:
:::

:::: imageblock
::: content
![azure services piggy](../images/azure_services_piggy.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie die Namen der            |
|                                   | Ressourcengruppen-Hosts frei      |
|                                   | wählen möchten, können Sie mit    |
|                                   | der Regel [Setup \> Agents \>     |
|                                   | Access to Agents \> Host name     |
|                                   | translation for piggybacked       |
|                                   | hosts]{.guihint} eine Umrechnung  |
|                                   | von Ressourcengruppen zu Hosts    |
|                                   | definieren.                       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#advanced_configuration .hidden-anchor .sr-only}4. Erweiterte Konfiguration {#heading_advanced_configuration}

::::::::::::::::::: sectionbody
::::: sect2
### []{#azure_vms .hidden-anchor .sr-only}4.1. Virtuelle Maschinen (VMs) {#heading_azure_vms}

::: paragraph
Wenn Sie über Azure virtuelle Maschinen überwachen, welche Sie
gleichzeitig als normale Hosts in Checkmk haben, können Sie die
Azure-Services, welche sich auf diese VMs beziehen, anstelle zu den
Ressourcengruppen-Hosts direkt zu den VM-Hosts in Checkmk zuordnen
lassen.
:::

::: paragraph
Wählen Sie dazu in der Azure-Regel bei der Option [Map data relating to
VMs]{.guihint} die Einstellung [Map data to the VM itself.]{.guihint}
Damit dies funktioniert, muss der Checkmk-Host der VM im Monitoring den
exakt gleichen Namen haben wie die entsprechende VM in Azure.
:::
:::::

::::::: sect2
### []{#monitor_cost .hidden-anchor .sr-only}4.2. Kosten überwachen {#heading_monitor_cost}

::: paragraph
Die Regel [Microsoft Azure]{.guihint} ist so voreingestellt, dass
Checkmk auch alle Kosten, die in Ihrer Azure-Umgebung anfallen,
überwacht. Konkret zeigen die Services die Kosten an, welche am Vortag
angefallen sind. Auf diese Weise erkennen Sie schnell, wenn es hier zu
Veränderungen gekommen ist.
:::

::: paragraph
Um eine bessere Übersicht zu erhalten, wo genau Kosten entstanden sind
und um gezielt Schwellwerte setzen zu können, werden mehrere Services
erzeugt. Die Gesamtkosten auf Ebene Ihres Azure-Directory, werden bei
dem [Azure-Host](#create_host) angezeigt, den sie zuerst angelegt haben.
Zusätzlich werden Services für jeden Host erzeugt, der eine
[Ressourcengruppe](#resource_groups) repräsentiert. Auf beiden Ebenen
erzeugt Checkmk pro sogenanntem „Resource Provider" (bspw.
`microsoft.compute` and `microsoft.network`) einen Service für die
Kosten. Die Gesamtsumme für die Ressourcengruppe bzw. das gesamte
Azure-Directory zeigt dann der Service [Costs Summary.]{.guihint}
:::

::: paragraph
Für all diese Services können Sie mit der Regel [Azure Usage Details
(Costs)]{.guihint} individuelle Schwellwerte festlegen.
:::

::: paragraph
Sollten Sie keine Kostenüberwachung wünschen, müssen Sie in der Regel
[Microsoft Azure]{.guihint} die Option [Usage Details]{.guihint}
deaktivieren.
:::
:::::::

:::::::::: sect2
### []{#rate_limit .hidden-anchor .sr-only}4.3. Rate-Limit der API-Abfragen {#heading_rate_limit}

::: paragraph
Stand heute sind die API-Abfragen, die Checkmk zum Monitoring benötigt,
bei Azure kostenlos (im Gegensatz zu [AWS](monitoring_aws.html)).
Allerdings gibt es eine Begrenzung in der Anzahl der Abfragen pro Zeit
(„Rate-Limit"). Pro Application-ID liegt die Grenze bei 12.000
Leseabfragen pro Stunde.
:::

::: paragraph
Aufgrund der Bauart der API benötigt Checkmk pro abgefragte Ressource
mindestens eine oder mehrere Abfragen. Daher skaliert die Gesamtzahl der
benötigten Abfragen linear mit der Anzahl der überwachten Ressourcen.
Wird das Rate-Limit erreicht oder überschritten, scheitert die Abfrage
mit einem HTTP-Code 429 (Too many requests) und der [Check_MK]{.guihint}
Service des Azure-Hosts geht auf [CRIT]{.state2}.
:::

::: paragraph
Das Rate-Limit ist von Azure als sogenannter „Token Bucket" Algorithmus
realisiert. Alles beginnt damit, dass Sie ein „Guthaben" von 12.000
verbleibenden Abfragen haben. Jede Abfrage verbraucht davon einen.
Gleichzeitig kommen 3,33 Abfragen pro Sekunde zum Guthaben dazu. In der
Ausgabe des Services [Azure Agent Info]{.guihint} sehen Sie, wie viele
Abfragen aktuell noch übrig sind.
:::

::: paragraph
Konkret bedeutet das:
:::

::: ulist
- Wenn Ihre Abfragerate ausreichend klein ist, sind die verfügbaren
  Abfragen immer knapp unter 12.000.

- Wenn Ihre Rate zu hoch ist, sinkt das Guthaben langsam auf 0 und es
  werden dann sporadisch Fehler bei der Abfrage auftreten.
:::

::: paragraph
In diesem Fall können Sie die Abfragerate reduzieren, indem Sie weniger
Ressourcengruppen oder Ressourcen abfragen oder indem Sie das
Check-Intervall des aktiven Checks [Check_MK]{.guihint} auf dem
Azure-Host reduzieren. Dies geht mit der Regel [Normal check interval
for service checks.]{.guihint}
:::

::: paragraph
Damit Sie rechtzeitig reagieren können, überwacht der Service [Azure
Agent Info]{.guihint} die Anzahl der verbleibenden Abfragen und warnt
Sie rechtzeitig vorher. Per Default ist die Warnschwelle bei 50 % und
die kritische Schwelle bei 25 % verbleibender Abfragen.
:::
::::::::::
:::::::::::::::::::
::::::::::::::::::::

::::::::::: sect1
## []{#dashboards .hidden-anchor .sr-only}5. Dashboards {#heading_dashboards}

:::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Zum komfortablen
Einstieg in die Überwachung von Azure liefert Checkmk ab Checkmk Cloud
die beiden eingebauten [Dashboards](glossar.html#dashboard) [Azure VM
instances]{.guihint} und [Azure storage accounts]{.guihint} mit aus.
Beide finden Sie im Monitoring als Menüeinträge unter [Monitor \>
Cloud.]{.guihint}
:::

::: paragraph
Damit Sie einen direkten Eindruck bekommen, finden Sie nachfolgend zwei
Beispiele, wie diese Dashboards aufgebaut sind. Zuerst das Dashboard zu
den VM-Instanzen, bei der Sie auf der linken Seite den aktuellen Zustand
und auf der rechten Seite den zeitlichen Verlauf der wichtigsten
Metriken vergleichen können:
:::

:::: imageblock
::: content
![Dashboard zu den Azure
VM-Instanzen.](../images/monitoring_azure_dashboard_vm.png)
:::
::::

::: paragraph
Das Dashboard zu den Storage Accounts ist ganz ähnlich aufgebaut. Auf
der linken Seite finden Sie aktuelle Daten der jeweiligen Buckets. Auf
der rechten werden wieder die wichtigsten Metriken im zeitlichen Verlauf
dargestellt:
:::

:::: imageblock
::: content
![Dashboard zu den Azure Storage
Accounts.](../images/monitoring_azure_dashboard_storage.png)
:::
::::
::::::::::
:::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
