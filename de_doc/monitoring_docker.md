:::: {#header}
# Docker überwachen

::: details
[Last modified on 17-Feb-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_docker.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Linux
überwachen](agent_linux.html) [Das Monitoring
einrichten](intro_setup_monitor.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Company-Logo der Firma Docker,
Inc.](../images/docker_logo_breit.png){width="335"}
:::
::::

::: paragraph
Docker hat sich weltweit zu einem der am häufigsten verwendeten
Softwareprodukte zur Container-Virtualisierung entwickelt. So notwendig
eine durchgängige und transparente Überwachung der Container ist, so
komplex ist sie aber auch aufgrund von deren dynamischer und
vielschichtiger Architektur.
:::

::: paragraph
Checkmk kann Docker-Container direkt über den
[Linux-Agenten](agent_linux.html) überwachen. Dabei werden nicht nur
Rahmendaten, wie der Status des Daemons oder des Containers, sondern
auch die Container selbst überwacht. Eine vollständige Liste der aktuell
überwachbaren Dinge finden Sie wie immer im [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}.
:::

::: paragraph
Neben den Status- und Inventurinformationen, die Checkmk über den Node
(Docker-Bezeichnung für: Host, auf dem die Container laufen) ermitteln
kann, kann Checkmk auch detaillierte Statusinformationen der Container
selbst ermitteln. Hierzu wird in Checkmk jeder Container als
eigenständiger Host angelegt, wenn er überwacht werden soll. Seine Daten
werden im [Piggyback-Verfahren](piggyback.html) an diesen Host
geliefert.
:::

::: paragraph
In den kommerziellen Editionen können Sie mithilfe der [dynamischen
Konfiguration](dcd.html) die Container-Hosts auch automatisch anlegen
und entfernen lassen.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einrichtung .hidden-anchor .sr-only}2. Einrichtung {#heading__einrichtung}

:::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::: sect2
### []{#install_agent_plugin .hidden-anchor .sr-only}2.1. Agent und Plugin installieren {#heading_install_agent_plugin}

::: paragraph
Damit Sie einen Docker-Node mit Checkmk überwachen können, muss diese
zunächst mit dem normalen [Linux-Agenten](agent_linux.html) überwacht
werden. Dadurch erhalten Sie ein Grund-Monitoring des Wirtssystems,
jedoch noch keine Information über den Docker-Daemon oder gar über die
Container.
:::

::: paragraph
Dazu benötigen Sie noch das [Agentenplugin](glossar.html#agent_plugin)
`mk_docker.py`, das Sie hier finden: [Setup \> Agents \> Other operating
systems \> Plugins]{.guihint}
:::

::: paragraph
Installieren Sie das Plugin in das Plugin-Verzeichnis des Agenten (im
Regelfall `/usr/lib/check_mk_agent/plugins`). Detaillierte Informationen
zur Installation eines Agentenplugins finden Sie im [Artikel zum
Linux-Agenten.](agent_linux.html#plugins)
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# install -m 0755 mk_docker.py /usr/lib/check_mk_agent/plugins
```
:::
::::

::: paragraph
In den kommerziellen Editionen können Sie alternativ auch mit der
[Agentenbäckerei](wato_monitoringagents.html#bakery) arbeiten, welche
für Docker den entsprechenden Regelsatz bereitstellt: [Docker node and
containers]{.guihint}
:::

::: paragraph
Beachten Sie, das die Python-Bibliothek `docker` benötigt wird
(**nicht** `docker-py`). Es ist mindestens Version 2.6.1 notwendig. Mit
`python` auf der Kommandozeile können Sie dies leicht überprüfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# python3
Python 3.8.10 (default, Nov 26 2021, 20:14:08)
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import docker
>>> docker.version
'5.0.3'
```
:::
::::

::: paragraph
Falls notwendig, können Sie die Bibliothek mit `pip3` installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# pip3 install docker
```
:::
::::

::: paragraph
**Achtung:** Die Pakete `docker-py` beziehungsweise `python-docker-py`
dürfen nicht installiert sein. Diese stellen eine veraltete und nicht
kompatible Version der Docker-Bibliothek unter dem selben Namensraum zur
Verfügung! Wenn Sie `docker-py` (oder beide Varianten) installiert
haben, reicht eine alleinige Deinstallation nicht aus, da `pip3` den
Namensraum nicht reparieren kann. Um sicher zu stellen, dass die
korrekte Version installiert ist, führen Sie in diesem Fall folgende
Befehle aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# pip3 uninstall docker-py docker
root@linux# pip3 install docker
```
:::
::::

::: paragraph
Wenn Sie jetzt in Checkmk die [Service-Erkennung](wato_services.html)
durchführen und die Änderungen aktivieren, sollten Sie zunächst einige
neue Services finden, welche den Docker-Node selbst betreffen:
:::

:::: imageblock
::: content
![Ansicht der aktuell in Checkmk gefundenen
Docker-Services.](../images/docker_basic_services.png)
:::
::::
:::::::::::::::::::::

:::::: sect2
### []{#finetuning .hidden-anchor .sr-only}2.2. Plugin feinjustieren {#heading_finetuning}

::: paragraph
Sie können verschiedene Parameter des Plugins konfigurieren. So können
Sie zum Beispiel Ressourcen schonen, in dem Sie nicht benötigte
Sektionen deaktivieren, oder --- falls nötig --- den Docker
API-Engine-Endpunkt anpassen (der Standard ist das Unix-Socket
`unix://var/run/docker.sock`).
:::

::: paragraph
Erstellen Sie dazu auf dem Docker-Host eine Konfigurationsdatei unter
`/etc/check_mk/docker.cfg`. Eine Vorlage mit ausführlichen Erläuterungen
hierzu finden Sie im Checkmk Verzeichnis unter
`~/share/check_mk/agents/cfg_examples/docker.cfg`.
:::

::: paragraph
In den kommerziellen Editionen können Sie alle Parameter bequem mit der
[Agentenbäckerei](wato_monitoringagents.html#bakery) einstellen.
:::
::::::

:::::::::::::::::::::::::::: sect2
### []{#_container_überwachen .hidden-anchor .sr-only}2.3. Container überwachen {#heading__container_überwachen}

::::::::: sect3
#### []{#_container_hosts_anlegen .hidden-anchor .sr-only}Container-Hosts anlegen {#heading__container_hosts_anlegen}

::: paragraph
Das eigentlich Interessante ist natürlich das Überwachen der
Docker-Container. Dies geschieht durch Installation der Plugins
automatisch. Allerdings werden die Services nicht dem Docker-Node
zugeordnet, sondern Checkmk geht von einem eigenen Host pro
Docker-Container aus.
:::

::: paragraph
Der Mechanismus, der hier zum Einsatz kommt, heißt
[Piggyback](piggyback.html) (Huckepack). Dabei transportiert ein Plugin
oder Spezialagent Daten zu anderen Hosts quasi „huckepack" in seiner
Ausgabe mit. Checkmk legt diese Daten im Verzeichnis
`tmp/check_mk/piggyback` ab. Sie brauchen dann nur noch im Setup Hosts
mit den richtigen Namen anzulegen und die Services werden diesen
automatisch zugeordnet.
:::

::: paragraph
In den kommerziellen Editionen können Sie diese Hosts automatisch
anlegen lassen. Verwenden Sie dazu in der [dynamischen
Konfiguration](dcd.html) den Konnektor [Piggyback]{.guihint}. Sie können
die Hosts auch von Hand anlegen. Beachten Sie dabei Folgendes:
:::

::: ulist
- Der Host-Name muss exakt dem Verzeichnis entsprechen, welches in
  `tmp/check_mk/piggyback` angelegt wird. Per Default ist das die
  zwölfstellige Short-ID des Containers (z.B. `2ed23056480f`).

- Falls die Container keine eigene IP-Adresse haben (was meist der Fall
  ist), stellen Sie im Abschnitt [Network address]{.guihint} das
  Attribut bei [IP address family]{.guihint} auf [No IP]{.guihint} ein.

- Bei [Monitoring agents]{.guihint} stellen Sie [Checkmk agent / API
  integrations]{.guihint} unbedingt auf [No API integrations, no Checkmk
  agent]{.guihint} ein.

- Das Feld [Parents]{.guihint} im Abschnitt [Basic settings]{.guihint}
  können Sie auf den Host-Namen des Docker-Nodes setzen.

- Wichtig ist ferner, dass der Docker-Node und deren Container von der
  selben Checkmk Instanz aus überwacht werden.
:::

::: paragraph
Nachdem Sie die Container-Hosts angelegt und die Service-Erkennung
durchgeführt haben, tauchen in dieser weitere Services auf.
:::

::: paragraph
Falls Sie in dem Container einen
[Linux-Agenten](agent_linux.html#install) installiert haben, wird er
automatisch ausgeführt. Da allerdings viele Services, welche der Agent
innerhalb des Containers überwacht, eigentlich die Informationen des
Node zeigen (z.B. CPU load, Temperatur und viele weitere
Betriebssystemparameter), wurden diese entfernt.
:::
:::::::::

::::::::::: sect3
#### []{#_alternative_benennung_der_container_hosts .hidden-anchor .sr-only}Alternative Benennung der Container-Hosts {#heading__alternative_benennung_der_container_hosts}

::: paragraph
Als Standardeinstellung wird, wie oben erwähnt, die zwölfstellige
Short-ID des Containers als Name des Container-Hosts verwendet. Dies
können Sie optional anders konfigurieren. Setzen Sie hierzu in der
Konfigurationsdatei `docker.cfg` (siehe [Plugin
feinjustieren](#finetuning)) die Option `container_id` auf `long`, um
die vollständige Container-ID als Name zu verwenden, oder auf `name`, um
den Container-Namen zu verwenden.
:::

::: paragraph
Nutzer der kommerziellen Editionen können dies in der
[Agentenbäckerei](wato_monitoringagents.html#bakery) mit Hilfe der Regel
[Docker node and containers]{.guihint}, Option [Host name used for
containers]{.guihint} einstellen.
:::

:::: imageblock
::: content
![Regel zur Auswahl der Host-Namen der
Container.](../images/docker_host_name_used.png){width="70%"}
:::
::::

::: paragraph
Übrigens: Mit dem Regelsatz [Access to Agents \> General Settings \>
Hostname translation for piggybacked hosts]{.guihint} können Sie recht
flexibel Regeln zur Umbenennung von Host-Namen, die in Piggyback-Daten
enthalten sind, festlegen. Damit können Sie z.B. auch eine Lösung
erstellen, für den Fall, dass Sie auf zwei verschiedenen Docker-Nodes
Container mit dem gleichen Namen haben.
:::

:::: imageblock
::: content
![Regel zur Umbenennung der in den Piggyback-Daten enthaltenen
Host-Namen.](../images/docker_hostname_translation.png)
:::
::::

::: paragraph
Im Artikel [Der Piggyback-Mechanismus](piggyback.html#renamehosts)
finden Sie weitere Möglichkeiten und eine genauere Beschreibung hierzu.
:::
:::::::::::

:::::: sect3
#### []{#_host_zustand_überwachen .hidden-anchor .sr-only}Host-Zustand überwachen {#heading__host_zustand_überwachen}

::: paragraph
Da der [Host-Zustand](monitoring_basics.html#hosts) eines Containers
nicht unbedingt über [TCP-Pakete oder
ICMP](cmc_differences.html#smartping) geprüft werden kann, muss dieser
anders ermittelt werden. Hier bietet sich der zum jeweiligen Container
gehörige Service [Docker container status]{.guihint} an. Dieser prüft
ohnehin, ob der Container läuft und kann daher als sicheres Mittel
verwendet werden, um den Host-Zustand zu ermitteln. Legen Sie dazu eine
Regel in dem Regelsatz [Host Check Command]{.guihint} an und setzen Sie
die Option [Use the status of the service...​]{.guihint} auf den
erwähnten Service. Vergessen Sie nicht die Bedingungen so zu setzen,
dass sie nur Container betreffen. In unserem Beispiel liegen alle
Container in einem gleichnamigen Ordner:
:::

:::: imageblock
::: content
![Regel für das Kommando zur Überprüfung des Host-Zustand der
Container.](../images/docker_container_hoststatus.png)
:::
::::
::::::

::::::: sect3
#### []{#_den_agenten_direkt_im_container_betreiben .hidden-anchor .sr-only}Den Agenten direkt im Container betreiben {#heading__den_agenten_direkt_im_container_betreiben}

::: paragraph
Um Details im Container selbst zu überwachen (z.B. laufende Prozesse,
Datenbanken, Log-Dateien, etc.), ist es notwendig, dass der Checkmk
Agent im Container selbst installiert ist und dort ausgeführt wird. Das
gilt insbesondere für das Ausrollen von Agentenplugins. Die drei Plugins
`mem`, `cpu` und `diskstat` (Disk-I/O) funktionieren allerdings auch
ohne Agent im Container und werden vom Checkmk Agenten auf dem Node
selbst berechnet.
:::

::: paragraph
Gerade für selbst erstellte Docker-Images möchten Sie vielleicht den
Agenten selbst in den Container ausrollen. In diesem Fall werden die
Daten nicht mehr, wie oben beschrieben, von dem Agenten des Docker-Nodes
berechnet. Stattdessen läuft ein separater Agent in jedem Container. Der
Aufruf erfolgt aber nach wie vor gebündelt über den Docker-Node im
Piggyback-Verfahren.
:::

::: paragraph
Der im Container installierte Agent funktioniert allerdings nur dann,
wenn in dem Container auch alle benötigten Befehle vorhanden sind.
Speziell bei minimal gebauten Containern auf Basis von Alpine-Linux kann
es gut sein, dass elementare Dinge wie die Bash nicht vorhanden sind. In
diesem Fall sollten Sie den Container aus dem Docker-Node heraus
überwachen.
:::

::: paragraph
Die Verwendung des Regelsets [Host Check Command]{.guihint} wird in
diesem Fall nur benötigt, wenn der Container nicht pingbar ist,
funktioniert aber ansonsten exakt so wie oben beschrieben.
:::
:::::::
::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::: sect1
## []{#_diagnosemöglichkeiten .hidden-anchor .sr-only}3. Diagnosemöglichkeiten {#heading__diagnosemöglichkeiten}

::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_diagnose_für_einen_docker_node .hidden-anchor .sr-only}3.1. Diagnose für einen Docker-Node {#heading__diagnose_für_einen_docker_node}

::: paragraph
Sollte die Einrichtung nicht klappen, gibt es verschiedene Möglichkeiten
der Analyse des Problems. Prüfen Sie gegebenenfalls, ob auf dem Host ein
Checkmk Agent der Version [1.5.0]{.new} oder höher installiert ist.
:::

::: paragraph
Falls die Version des Agenten auf dem Host passt, prüfen Sie als
nächstes, ob die Daten in der Ausgabe des Agenten enthalten sind. Sie
können die Ausgabe als Textdatei herunterladen: in einer Host-Ansicht im
Monitoring über den Eintrag [Download agent output]{.guihint} des
Aktionsmenüs:
:::

:::: imageblock
::: content
![Aktionsmenü des Hosts im Monitoring mit dem Eintrag zum Download der
Agentenausgabe.](../images/docker_node_dropdown.png){width="65%"}
:::
::::

::: paragraph
Oder Sie durchsuchen direkt den Agent-Cache. Die Ausgabe in dem
folgenden Beispiel ist für die Anschaulichkeit auf die Ausgaben zum Node
gekürzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ strings tmp/check_mk/cache/mydockerhost | grep "&lt&lt&ltdocker"
<<<docker_node_info>>>
<<<docker_node_disk_usage:sep(44)>>>
<<<docker_node_images>>>
<<<docker_node_network:sep(0)>>>
```
:::
::::

::: paragraph
Werden die Sektionen hier nicht geführt, wird die Docker-Installation
nicht erkannt. Für den Service [Docker node info]{.guihint} wird der
folgende Befehl benutzt. Dieser muss auf dem Host in exakt dieser Form
ausführbar sein. Prüfen Sie dann gegebenenfalls Ihre
Docker-Installation:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker info 2>&1
```
:::
::::
:::::::::::::

::::::::: sect2
### []{#_diagnose_für_einen_container_host .hidden-anchor .sr-only}3.2. Diagnose für einen Container-Host {#heading__diagnose_für_einen_container_host}

::: paragraph
Falls der Container-Host keine Daten erhält bzw. keine Services erkannt
werden, prüfen Sie zuerst, ob die Piggyback-Daten zu diesem Host
vorhanden sind. Der Name des Hosts muss identisch mit der ID des
Containers sein. Alternativ können Sie auch über den Regelsatz [Hostname
translation for piggybacked hosts]{.guihint} eine manuelle Zuordnung
vornehmen. Hier bietet sich allerdings nur die Option [Explicit hostname
mapping]{.guihint} an:
:::

:::: imageblock
::: content
![Regel zur Übersetzung der Host-Namen von Hosts mit
Piggyback-Daten.](../images/docker_container_namemapping.png)
:::
::::

::: paragraph
Um zu prüfen, ob zu einer ID Piggyback-Daten angelegt werden, können Sie
das folgende Verzeichnis prüfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ls -l tmp/check_mk/piggyback/
76adfc5a7794  f0bced2c8c96  bf9b3b853834
```
:::
::::
:::::::::
:::::::::::::::::::::
::::::::::::::::::::::

::::::: sect1
## []{#_host_labels .hidden-anchor .sr-only}4. Host-Labels {#heading__host_labels}

:::::: sectionbody
::: paragraph
In Checkmk gibt es sogenannte [Host-Labels](labels.html). Das
Docker-Monitoring setzt unter anderem diese automatischen Labels:
:::

::: ulist
- für den Docker-Node das Label `cmk/docker_object:node`,

- für jeden Container die Labels `cmk/docker_image`,
  `cmk/docker_image_name`, `cmk/docker_image_version` und
  `cmk/docker_object`.
:::

::: paragraph
Diese Labels können Sie z.B. in Bedingungen für Ihre
[Regeln](wato_rules.html) verwenden, um Ihre Monitoring-Konfiguration
abhängig von dem Image zu machen, das in einem Container verwendet wird.
:::
::::::
:::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}5. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `tmp/ch            | Hier legt Checkmk die Piggyback-Daten ab. Für   |
| eck_mk/piggyback/` | jeden Host wird ein Unterordner mit seinem      |
|                    | Namen erzeugt. Darin befindet sich eine         |
|                    | Textdatei mit den Daten des Hosts. Dateiname    |
|                    | ist der Host, welcher die Daten angeliefert     |
|                    | hat.                                            |
+--------------------+-------------------------------------------------+
| `tm                | Hier wird die jeweils jüngste Agentenausgabe    |
| p/check_mk/cache/` | aller Hosts temporär gespeichert. Der Inhalt    |
|                    | einer Datei zu einem Host ist identisch zu dem  |
|                    | Befehl `cmk -d myserver123`.                    |
+--------------------+-------------------------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
