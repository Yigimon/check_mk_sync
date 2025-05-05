:::: {#header}
# VMware ESXi überwachen

::: details
[Last modified on 29-Dec-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_vmware.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Virtuelle Appliance
installieren](appliance_install_virt1.html)
[Datenquellenprogramme](datasource_programs.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
Mit Checkmk können Sie ESXi-Hosts und auch seine VMs überwachen. So ist
es zum Beispiel auf dem Host möglich, Disk-IO, Durchsatz der Datastores,
Status der physischen Netzwerkschnittstellen, diverse Hardwaresensoren
und vieles mehr abzufragen. Für die VMs bietet Checkmk ebenfalls eine
Reihe an Check-Plugins. Eine ausführliche Liste finden Sie im [Katalog
der Check-Plugins](https://checkmk.com/de/integrations?tags=vsphere).
:::

::: paragraph
Über den [Piggyback](glossar.html#piggyback)-Mechanismus werden die
Daten der VM „huckepack" direkt in dem dazugehörigen Host angezeigt. So
befinden sich die VM-bezogenen Daten gleich dort, wo sie auch wirklich
benötigt werden und können auch mit denen verglichen werden, die von dem
OS der VM gemeldet werden:
:::

:::: imageblock
::: content
![vmware services](../images/vmware_services.png)
:::
::::

::: paragraph
Der Zugriff auf diese Daten geschieht über die auf HTTP basierende
vSphere-API und nicht über den normalen Agenten oder SNMP. Dadurch muss
auf den ESXi-Hosts kein Agent oder andere Software installiert werden
und der Zugriff ist sehr einfach über eine Regel einzurichten.
:::
::::::::
:::::::::

::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einrichtung .hidden-anchor .sr-only}2. Einrichtung {#heading__einrichtung}

:::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_einrichtung_über_esxi_host_system .hidden-anchor .sr-only}2.1. Einrichtung über ESXi-Host-System {#heading__einrichtung_über_esxi_host_system}

::: paragraph
Die erste Einrichtung zur Überwachung eines ESXi-Servers ist sehr
einfach und in weniger als fünf Minuten erledigt. Bevor Sie aber den
Zugriff einrichten können, müssen folgende Voraussetzungen erfüllt sein:
:::

::: ulist
- Sie haben einen Benutzer auf dem ESXi-Server eingerichtet. Für diesen
  Benutzer reicht es, wenn er ausschließlich über Leserechte verfügt.

- Sie haben den ESXi-Server als Host im Checkmk angelegt und als Agent
  [Check_MK Agent]{.guihint} eingestellt. Tipp: Wählen Sie den
  Host-Namen so, wie der Server sich selbst auch kennt.
:::

::: paragraph
Sind die Voraussetzungen erfüllt, können Sie eine
[Regel](wato_rules.html#create_rules) im Regelsatz [Setup \> VM, cloud,
container \> VMware ESX via vSphere]{.guihint} erstellen. Diese wird dem
angelegten Host zugewiesen, damit der
[Spezialagent](datasource_programs.html#specialagents) für die
VMware-Überwachung statt des normalen Agenten für die Abfrage der Daten
benutzt wird.
:::

::: paragraph
Tragen sie nun den Namen und das Passwort des Benutzers ein, wie Sie ihn
auf dem ESXi-Server angelegt haben. Die Bedingung für die Regel muss auf
den in Checkmk angelegten Host gesetzt werden. Danach ist die erste
Einrichtung bereits fertig und Checkmk kann die Daten von dem Server
holen.
:::

:::: imageblock
::: content
![vmware username](../images/vmware_username.png)
:::
::::

::: paragraph
Zum Schluss gehen Sie zurück zu der Konfiguration des Hosts und führen
eine [Service-Erkennung](hosts_setup.html#services) durch. Dabei sollte
eine Reihe von Services gefunden werden:
:::

:::: imageblock
::: content
![vmware discovery](../images/vmware_discovery.png)
:::
::::

::: paragraph
Aktivieren Sie die Änderungen wie üblich. Sollten keine Services erkannt
werden, können Sie mit den weiter unten beschriebenen
[Diagnosemöglichkeiten](#diagnose) nach Fehlern in der Konfiguration
suchen.
:::
:::::::::::::

::::::::::::::::::: sect2
### []{#_einrichtung_über_vcenter .hidden-anchor .sr-only}2.2. Einrichtung über vCenter {#heading__einrichtung_über_vcenter}

::: paragraph
Falls ein vCenter vorhanden ist, können Sie die Überwachungsdaten statt
über die einzelnen Host-Systeme auch das vCenter abrufen. Diese Methode
hat verschiedene Vor- und Nachteile:
:::

+-----------------------------------+-----------------------------------+
| Vorteile                          | Nachteile                         |
+===================================+===================================+
| Einfacher Aufzusetzen in          | Keine Überwachung wenn vCenter    |
| Situationen, in denen die         | nicht verfügbar ist.              |
| Zuordnung der VMs über vMotion    |                                   |
| dynamisch geschieht.              |                                   |
+-----------------------------------+-----------------------------------+
| Überwachung der Gesamtnutzung des | Keine Überwachung von sonstigen   |
| RAM im Cluster möglich.           | hardwarespezifischen Daten der    |
|                                   | Cluster-Knoten (z.B. RAM-Disks    |
|                                   | und Netzwerkkarten).              |
+-----------------------------------+-----------------------------------+

::: paragraph
Man kann auch eine Kombination von beiden Methoden einsetzen. Sie haben
dann alle Vorteile beider Methoden auf Ihrer Seite.
:::

::::::::: sect3
#### []{#_konfiguration_des_vcenter .hidden-anchor .sr-only}Konfiguration des vCenter {#heading__konfiguration_des_vcenter}

::: paragraph
Bei der Einrichtung gelten ähnliche Voraussetzungen, wie auch bei der
Einrichtung über einen einzelnen ESXi-Server:
:::

::: ulist
- Ein Benutzer mit Leserechten ist auf dem vCenter vorhanden.

- Sie haben das vCenter als Host im Checkmk angelegt und als Agenten
  [Checkmk Agent]{.guihint} eingestellt.

- Wenn die ESXi-Server in Checkmk bereits eingerichtet sind und Sie die
  Überwachung kombinieren möchten, dann heißen diese im vCenter so, wie
  sie auch im Checkmk als Host angelegt sind.
:::

::: paragraph
Erstellen Sie wie oben beschrieben eine Regel für den Spezialagenten der
VMware-Überwachung, wählen Sie bei [Type of Query]{.guihint} den vCenter
aus und setzen Sie die Bedingung auf den entsprechenden in Checkmk
angelegten Host:
:::

:::: imageblock
::: content
![vmware vcenter username](../images/vmware_vcenter_username.png)
:::
::::

::: paragraph
Auch hier ist die Einrichtung damit abgeschlossen. Führen Sie wie oben
beschrieben eine Serviceerkennung für den vCenter-Host durch.
:::
:::::::::

::::::::: sect3
#### []{#datasource_combination .hidden-anchor .sr-only}ESXi-Hosts und vCenter abrufen {#heading_datasource_combination}

::: paragraph
Um zu vermeiden, dass Sie Daten bei einer Kombination beider
Einrichtungsmöglichkeiten doppelt abrufen, können Sie bei der
Konfiguration der Regel für das vCenter nur bestimmte Daten holen
lassen. Eine Möglichkeit ist es, die [Datastores]{.guihint} und die
[Virtual Machines]{.guihint} über das vCenter und die anderen Daten
direkt auf den ESXi-Hosts abzurufen. Die Nutzung der Lizenzen können Sie
in beiden Konfigurationen abrufen lassen, da das vCenter einen
Gesamtstatus meldet.
:::

:::: imageblock
::: content
![vmware data1](../images/vmware_data1.png)
:::
::::

::: paragraph
Haben Sie die ESXi-Hosts bereits eingerichtet, dann passen Sie die
Regeln dort entsprechend an. Es bietet sich hier an, nur die [Host
Systems]{.guihint} und [Performance Counters]{.guihint} abzurufen, da
diese unveränderlich zu einem bestimmten ESXi-Server gehören. Der
Lizenzstatus bezieht sich nur auf den abgerufenen ESXi-Server.
:::

:::: imageblock
::: content
![vmware data2](../images/vmware_data2.png)
:::
::::
:::::::::
:::::::::::::::::::

::::::::::::::::::: sect2
### []{#_überwachung_der_vms .hidden-anchor .sr-only}2.3. Überwachung der VMs {#heading__überwachung_der_vms}

::: paragraph
Standardmäßig wird nur der Status der VMs als Service angelegt und dem
ESXi-Host bzw. dem vCenter zugeordnet. Es gibt allerdings auch noch mehr
Informationen zu diesen VMs, wie z.B. zum RAM oder den Snapshots. Diese
Daten werden als Piggyback-Daten abgelegt und direkt den Hosts
zugeordnet, welche im Checkmk den VMs entsprechen.
:::

::: paragraph
Um diese Daten sichtbar zu machen, muss die VM in Checkmk als Host
angelegt sein. Sie können auf der VM natürlich auch den Checkmk Agenten
installieren und vollumfänglich nutzen. Die Piggyback-Daten kommen dann
einfach zu den bereits vorhandenen hinzu.
:::

:::::::::::::::: sect3
#### []{#rename_piggyback .hidden-anchor .sr-only}Benennung der Piggyback-Daten {#heading_rename_piggyback}

::: paragraph
Wenn der Host-Name der VM in Checkmk mit dem Namen der VM übereinstimmt,
klappt die Zuordnung automatisch. Falls nicht, gibt es in Checkmk
verschiedene Möglichkeiten den Piggyback-Namen anzupassen. In der
Konfigurationsregel selbst gibt es die folgenden Optionen:
:::

::: ulist
- Sie können den Host-Namen des Betriebssystems der VM zu nutzen, falls
  dieser über die vSphere-API abgerufen werden kann.

- Enthalten die Namen der VMs Leerzeichen, wird alles nach dem ersten
  abgeschnitten. Alternativ können alle Leerzeichen durch Unterstriche
  ersetzt werden.
:::

:::: imageblock
::: content
![vmware nametranslation](../images/vmware_nametranslation.png)
:::
::::

::: paragraph
Sollte der Name des Hosts in Checkmk ganz anders sein, kann eine
explizite Zuordnung mit Hilfe der Regel [Setup \> Agents \> Access to
agents \> Hostname translation for piggybacked hosts]{.guihint}
geschehen:
:::

:::: imageblock
::: content
![vmware nametranslation2](../images/vmware_nametranslation2.png)
:::
::::

::: paragraph
Ist der Host in Checkmk angelegt und die Namensgleichheit gegeben,
können Sie in der Konfigurationsregel die Checkbox [Display VM power
state on]{.guihint} aktivieren. Hier kann ausgewählt werden, ob und wo
die Daten zur Verfügung gestellt werden sollen. Wählen Sie hier [The
Virtual Machine]{.guihint}.
:::

:::: imageblock
::: content
![vmware vms](../images/vmware_vms.png)
:::
::::

::: paragraph
In der Serviceerkennung auf dem oder den Hosts werden nun die neuen
Services erkannt und können aktiviert werden. Beachten Sie, dass sich
die Informationen der Services voneinander unterscheiden können. So
sieht der ESXi-Server die Nutzung des RAM einer virtuellen Maschine
anders, als es das OS dieser Maschine selbst meldet.
:::

:::: imageblock
::: content
![vmware services](../images/vmware_services.png)
:::
::::
::::::::::::::::
:::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::: sect1
## []{#diagnose .hidden-anchor .sr-only}3. Diagnosemöglichkeiten {#heading_diagnose}

:::::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#_einleitung_2 .hidden-anchor .sr-only}3.1. Einleitung {#heading__einleitung_2}

::: paragraph
Bei der Suche nach einer Fehlerquelle gibt es verschiedene
Anlaufstellen. Da die Daten von dem ESXi-/vCenter-Server kommen, bietet
es sich an, dort mit der Fehlersuche zu beginnen. Danach ist relevant,
ob die Daten im Checkmk-Server ankommen, richtig verarbeitet und
dargestellt werden können.
:::
::::

:::::::::::::::::: sect2
### []{#_problemen_mit_der_konfiguration_des_esxi_vcenter_servers .hidden-anchor .sr-only}3.2. Problemen mit der Konfiguration des ESXi-/vCenter-Servers {#heading__problemen_mit_der_konfiguration_des_esxi_vcenter_servers}

::: paragraph
Mit dem Befehl `curl` können Sie prüfen, ob der Server vom Monitoring
aus erreichbar ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ curl -Ik https://myESXhost.my-domain.net
HTTP/1.1 200 OK
Date: Fri, 4 Nov 2016 14:29:31 GMT
Connection: Keep-Alive
Content-Type: text/html
X-Frame-Options: DENY
Content-Length: 5426
```
:::
::::

::: paragraph
Ob die Zugangsdaten korrekt eingegeben wurden und Checkmk den Host auf
abrufen kann, können Sie mit dem Spezialagenten auf der Konsole testen.
Benutzen Sie die Optionen `--help` oder `-h`, um eine vollständige Liste
der verfügbaren Optionen zu bekommen. In dem Beispiel wurde mit Hilfe
von `grep` die Ausgabe auf eine bestimmte Sektion und die ersten vier
Zeilen danach begrenzt. Sie können diesen Teil weglassen, um eine
vollständige Ausgabe zu bekommen oder auch nach einer anderen filtern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/check_mk/agents/special/agent_vsphere --debug --user myesxuser --secret myesxpassword -D myESXhost | grep -A4 esx_vsphere_objects
<<<esx_vsphere_objects:sep(9)>>>
hostsystem      myESXhost           poweredOn
hostsystem      myESXhost2          poweredOn
virtualmachine  myVM123             myESXhost   poweredOn
virtualmachine  myVM126             myESXhost   poweredOn
```
:::
::::

::: paragraph
Ob Checkmk den Host abrufen kann, können Sie auf der Konsole prüfen.
Auch hier wurde die Ausgabe auf fünf Zeilen begrenzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d myESXhost | grep -A4 esx_vsphere_objects
<<<esx_vsphere_objects:sep(9)>>>
hostsystem      myESXhost           poweredOn
hostsystem      myESXhost2          poweredOn
virtualmachine  myVM123             myESXhost   poweredOn
virtualmachine  myVM126             myESXhost   poweredOn
```
:::
::::

::: paragraph
Alternativ können Sie den Test auch auf der Diagnoseseite des Hosts im
Setup durchführen:
:::

:::: imageblock
::: content
![vmware agent test](../images/vmware_agent_test.png)
:::
::::

::: paragraph
Wenn bis hier hin alles funktioniert, muss die Ausgabe in einem
temporären Verzeichnis abgelegt worden sein. Ob eine solche Datei
angelegt wurde und ob deren Inhalt stimmt, können Sie folgendermaßen
herausfinden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll tmp/check_mk/cache/myESXhost
-rw-r--r-- 1 mysite mysite 17703 Nov  4 15:42 myESXhost
OMD[mysite]:~$ head -n5 tmp/check_mk/cache/myESXhost
<<<esx_systeminfo>>>
Version: 6.0
AgentOS: VMware ESXi
<<<esx_systeminfo>>>
vendor VMware, Inc.
```
:::
::::
::::::::::::::::::

::::::::::::: sect2
### []{#_probleme_mit_piggyback_daten .hidden-anchor .sr-only}3.3. Probleme mit Piggyback-Daten {#heading__probleme_mit_piggyback_daten}

::: paragraph
Checkmk legt für jeden Host ein Verzeichnis und darin eine Textdatei an.
In diesen Textdateien finden Sie die Daten, welche den Hosts zugeordnet
werden sollen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll tmp/check_mk/piggyback/
total 0
drwxr-xr-x 2 mysite mysite 60 Nov  4 15:51 myVM123/
drwxr-xr-x 2 mysite mysite 60 Nov  4 15:51 myVM124/
drwxr-xr-x 2 mysite mysite 60 Nov  4 15:51 myVM126/
drwxr-xr-x 2 mysite mysite 60 Nov  4 15:51 myESXhost2/
OMD[mysite]:~$ ll tmp/check_mk/piggyback/myVM123/
-rw-r--r-- 1 mysite mysite 1050 Nov  4 15:51 myESXhost
```
:::
::::

::: paragraph
Sind diese Verzeichnisse oder Dateien nicht vorhanden, wurden sie von
dem Spezialagenten nicht angelegt. In der Agentenausgabe können Sie
sehen, ob die Daten zu der VM enthalten sind. Schauen Sie gegebenenfalls
in Ihrer Konfigurationsregel zu dem ESXi-/vCenter-Host, ob das Holen der
[Daten](#datasource_combination) aktiviert ist.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ grep "<<<&ltmyVM123&gt>>>" tmp/check_mk/cache/myESXhost
<<<<myVM123>>>>
```
:::
::::

::: paragraph
Bei einer sehr großen Anzahl an solchen Unterverzeichnissen für
Piggyback-Daten kann es sehr schwierig werden, diejenigen zu finden,
welche über keine Zuordnung zu einem Host verfügen. In den
Checkmk-„Treasures" finden Sie ein Skript, mit dem Sie Piggyback-Hosts
ohne Zuordnung sehr einfach finden können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/doc/check_mk/treasures/find_piggy_orphans
myESXhost2
```
:::
::::

::: paragraph
Zu den Ergebnissen aus dem Skript kann Checkmk keinen Host mit dem
gleichen Namen finden, um die Daten zuzuordnen. Sie können aber die
Piggyback-Namen auf verschiedene Weisen [anpassen](#rename_piggyback).
:::
:::::::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~                        | Hier legt Checkmk die Piggyback-Daten    |
| /tmp/check_mk/piggyback/` | ab. Für jeden Host wird ein Unterordner  |
|                           | mit seinem Namen erzeugt. Darin befindet |
|                           | sich eine Textdatei mit den Daten des    |
|                           | Hosts. Dateiname ist der Host, welcher   |
|                           | die Daten angeliefert hat.               |
+---------------------------+------------------------------------------+
| `~/tmp/check_mk/cache/`   | Hier wird die jeweils jüngste            |
|                           | Agentenausgabe aller Hosts temporär      |
|                           | gespeichert. Der Inhalt einer Datei zu   |
|                           | einem Host ist identisch zu dem Befehl   |
|                           | `cmk -d myserver123`.                    |
+---------------------------+------------------------------------------+
| `~/share/check_mk/agen    | Der Spezialagent, um die Abfrage von     |
| ts/special/agent_vsphere` | ESXi- und vCenter-Servern auszuführen.   |
|                           | Dieses Skript kann zu Testzwecken auch   |
|                           | manuell ausgeführt werden.               |
+---------------------------+------------------------------------------+
| `                         | Ein Skript, um Piggyback-Daten zu        |
| ~/share/doc/check_mk/trea | finden, die keinem Host zugeordnet sind. |
| sures/find_piggy_orphans` |                                          |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
