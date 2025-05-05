:::: {#header}
# Der Piggyback-Mechanismus

::: details
[Last modified on 19-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/piggyback.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Dynamische
Host-Konfiguration](dcd.html) [Microsoft Azure
überwachen](monitoring_azure.html) [Amazon Web Services (AWS)
überwachen](monitoring_aws.html) [Google Cloud Platform (GCP)
überwachen](monitoring_gcp.html) [Kubernetes
überwachen](monitoring_kubernetes.html) [Docker
überwachen](monitoring_docker.html) [VMware ESXi
überwachen](monitoring_vmware.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
::: paragraph
Der Piggyback-Mechanismus wurde bereits in den frühen Zeiten von Checkmk
eingeführt --- und zwar im Rahmen der Überwachung von
[VMware.](monitoring_vmware.html) Hier ist die Situation, dass Daten von
einem bestimmten Host abgefragt werden müssen, weil sie nur dort
bereitstehen (z.B. von einem ESX-Host-System oder dem vCenter), diese
aber im Monitoring einen ganz anderen Host betreffen (z.B. eine
virtuelle Maschine).
:::

::: paragraph
Das ist mit dem normalen Mechanismus von Checkmk nicht zu realisieren,
denn dieser ordnet Daten und Services, die er von einem Host holt,
automatisch diesem zu. Und es wäre schließlich sehr unpraktisch für das
Monitoring, wenn alle Informationen zu allen VMs immer direkt beim
ESX-Host oder gar vCenter erschienen.
:::

::: paragraph
Der Begriff „Piggyback" (im Deutschen „Huckepack") drückt aus, dass
Monitoring-Daten zu Host B quasi *huckepack* beim Abfragen von Host A
mit übertragen werden.
:::

::: paragraph
Heute kommt Piggyback bei vielen weiteren Monitoring-Plugins zum
Einsatz, z.B. bei der Überwachung von:
:::

::: ulist
- [AWS](monitoring_aws.html)

- [Azure](monitoring_azure.html)

- [GCP](monitoring_gcp.html)

- [Docker](monitoring_docker.html)

- [Kubernetes](monitoring_kubernetes.html)

- Proxmox VE

- [VMware](monitoring_vmware.html)
:::

::: paragraph
Neben Virtualisierungsumgebungen kann der Piggyback-Mechanismus auch
beim Monitoring von Mobilgeräten oder dem Klima-Monitoring im
Rechenzentrum (MQTT) eingesetzt werden. Da die Abfrageschnittstellen
sehr simpel sind, ist es sehr einfach, den Piggyback-Mechanismus selbst
zu verwenden. Sie können ihn beispielsweise beim Realisieren eigener
Check-Plugins nutzen, um Daten aus einer Quelle beliebigen anderen Hosts
zuzuordnen.
:::
:::::::::
::::::::::

:::::::::::: sect1
## []{#principle .hidden-anchor .sr-only}2. Das Piggyback-Prinzip {#heading_principle}

::::::::::: sectionbody
::: paragraph
Das Grundprinzip von Piggyback funktioniert wie in der folgenden
Abbildung dargestellt. Ein Host A kennt nicht nur seine Monitoring-Daten
sondern auch die anderer Hosts --- oder allgemeiner gesagt: anderer
Objekte. So kennt z.B. ein ESX-Host den Zustand und viele aktuelle
Metriken zu jeder seiner virtuellen Maschinen (VMs). Der Host A wird in
diesem Zusammenhang manchmal auch als *Quell-Host* (*source host*)
bezeichnet.
:::

::: paragraph
Wenn Checkmk jetzt von A in seinem minütlichen Rhythmus die
Monitoring-Daten abruft --- sei es vom normalen Checkmk-Agenten oder von
einem Spezialagenten über eine Hersteller-API --- , bekommt es in der
Antwort speziell markiert auch Daten zu den anderen Hosts/Objekten B, C
usw. mitgeteilt. Diese *Piggyback-Daten* legt es dann für die spätere
Verarbeitung in Dateien auf dem Checkmk-Server ab. Die Hosts B, C usw.
werden als *Piggyback-Hosts* bezeichnet.
:::

::: paragraph
Wenn Checkmk dann später die Monitoring-Daten von B oder C benötigt,
liegen diese bereits in den Dateien vor und können direkt verarbeitet
werden, ohne einen Agenten abzufragen:
:::

:::: imageblock
::: content
![Schematische Darstellung der indirekten Datenweitergabe über den
Piggyback-Mechanismus.](../images/piggyback_scheme_1.png){width="50%"}
:::
::::

::: paragraph
Es ist auch möglich und sinnvoll, normales Monitoring und Piggyback zu
kombinieren. Nehmen wir wieder das VMware-Beispiel: Vielleicht haben Sie
ja in Ihrer VM B einen Checkmk-Agenten installiert, der lokale
Informationen aus der VM auswertet, die dem ESX-Host nicht bekannt sind
(z.B. die in der VM laufenden Prozesse). In diesem Fall wird der Agent
abgefragt, und die Daten werden mit den Piggyback-Daten von Host A
zusammengefasst:
:::

:::: imageblock
::: content
![Schematische Darstellung der kombinierten Datenweitergabe: Ein Teil
der Daten kommt via Piggyback, der Rest direkt vom überwachten
Host.](../images/piggyback_scheme_2.png){width="50%"}
:::
::::
:::::::::::
::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#piggyback_in_practice .hidden-anchor .sr-only}3. Piggyback in der Praxis {#heading_piggyback_in_practice}

:::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::: sect2
### []{#_einrichten_von_piggyback .hidden-anchor .sr-only}3.1. Einrichten von Piggyback {#heading__einrichten_von_piggyback}

::: paragraph
Die gute Nachricht ist, dass der Piggyback-Mechanismus häufig völlig
automatisch funktioniert:
:::

::: ulist
- Wenn beim Abfragen von A Piggyback-Daten für andere Hosts entdeckt
  werden, werden diese automatisch für die spätere Auswertung
  gespeichert.

- Wenn beim Abfragen von B Piggyback-Daten von einem anderen Host
  auftauchen, werden diese automatisch verwendet.
:::

::: paragraph
Allerdings ist --- wie immer in Checkmk --- alles konfigurierbar. So
können Sie beispielsweise bei den Eigenschaften eines Hosts (Host B) im
Kasten [Monitoring agents]{.guihint} einstellen, wie dieser auf
vorhandene oder fehlende Piggyback-Daten reagieren soll:
:::

:::: imageblock
::: content
![Die Umleitung der Piggyback-Daten wird in den Agenten-Einstellungen
festgelegt](../images/piggyback_settings.png)
:::
::::

::: paragraph
Der Standard ist [Use piggyback data from other hosts if
present]{.guihint}. Falls vorhanden, werden also Piggyback-Daten
verwendet, und wenn keine da sind, verwendet der Host eben nur seine
„eigenen" Monitoring-Daten.
:::

::: paragraph
Bei der Einstellung [Always use and expect piggyback data]{.guihint}
*erzwingen* Sie die Verarbeitung von Piggyback-Daten. Wenn diese fehlen
oder veraltet sind, wird der Service [Check_MK]{.guihint} eine Warnung
ausgeben.
:::

::: paragraph
Bei [Never use piggyback data]{.guihint} werden eventuell vorhandene
Piggyback-Daten einfach ignoriert --- eine Einstellung, die Sie nur in
Ausnahmefällen brauchen werden.
:::
:::::::::::

::::: sect2
### []{#_hosts_müssen_vorhanden_sein .hidden-anchor .sr-only}3.2. Hosts müssen vorhanden sein {#heading__hosts_müssen_vorhanden_sein}

::: paragraph
Damit ein Host Piggyback-Daten verarbeiten kann, muss dieser natürlich
im Monitoring vorhanden sein. Im Beispiel von ESX bedeutet das, dass Sie
Ihre VMs auch als Hosts in Checkmk aufnehmen müssen, damit sie überhaupt
überwacht werden.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können Sie dies mithilfe der [dynamischen
Konfiguration](dcd.html) automatisieren und Hosts, für die
Piggyback-Daten vorhanden sind, automatisch anlegen lassen.
:::
:::::

:::::::::::::::: sect2
### []{#renamehosts .hidden-anchor .sr-only}3.3. Host-Namen und ihre Zuordnung {#heading_renamehosts}

::: paragraph
Im Beispiel oben war es irgendwie logisch, dass die Daten von Objekt B
auch dem Host B im Monitoring zugeordnet wurden. Aber wie genau
funktioniert das?
:::

::: paragraph
Beim Piggyback-Mechanismus geht die Zuordnung immer über einen *Namen*.
Der (Spezial-)Agent schreibt zu jedem Satz von Piggyback-Daten einen
Objektnamen. Im Fall von ESX ist das z.B. der Name der virtuellen
Maschine. Manche Plugins wie z.B. [Docker](monitoring_docker.html) haben
auch mehrere Möglichkeiten, was als Name verwendet werden soll.
:::

::: paragraph
**Hinweis:** Piggyback-Daten von Hosts, deren Namen mit einem Punkt
beginnen, werden nicht in Checkmk verarbeitet. Dies betrifft z.B. Namen
wie `.`, `.hostname` oder `.hostname.domain.com`. Um diese Hosts ins
Monitoring aufzunehmen, müssen die Host-Namen wie beschrieben geändert
werden.
:::

::: paragraph
Damit die Zuordnung klappt, muss der Name des passenden Hosts in Checkmk
natürlich identisch sein --- auch die Groß-/Kleinschreibung betreffend.
:::

::: paragraph
Was aber, wenn die Namen der Objekte in den Piggyback-Daten für das
Monitoring ungeeignet oder unerwünscht sind? Ungeeignet sind z. B. Namen
von Piggyback-Hosts, die nur aus einem Punkt bestehen oder mit einem
Punkt beginnen, wie `.myhostname`, da diese in Checkmk nicht verarbeitet
werden. Für die Umbenennung von Piggyback-Hosts gibt es einen speziellen
[Regelsatz](wato_rules.html) [Hostname translation for piggybacked
hosts]{.guihint}, den Sie im Setup-Menü unter [Setup \> Agents \> Agent
access rules]{.guihint} finden.
:::

::: paragraph
Um eine Umbenennung zu konfigurieren, führen Sie die folgenden zwei
Schritte aus:
:::

::: {.olist .arabic}
1.  Legen Sie eine Regel an und stellen Sie die Bedingung so ein, dass
    Sie auf dem *Quell-Host* greift --- also quasi auf Host A.

2.  Legen Sie im Wert der Regel eine passende Namenszuordnung fest.
:::

::: paragraph
Hier ist ein Beispiel für den Wert der Regel. Es wurden zwei Dinge
konfiguriert: Zunächst werden alle Host-Namen aus den Piggyback-Daten in
Kleinbuchstaben umgewandelt. Danach werden noch die beiden Hosts
`vm0815` bzw. `vm0816` in die Checkmk-Hosts `mylnxserver07` bzw.
`mylnxserver08` umgewandelt:
:::

:::: imageblock
::: content
![Optionen der \'Hostname translation\', Entfernen des Domain-Parts,
Umwandlung nach Kleinbuchstaben oder explizites
Mapping.](../images/piggyback_hostname_translation.png)
:::
::::

::: paragraph
Flexibler ist die Methode mit [regulären Ausdrücken,](regexes.html) die
Sie unter [Multiple regular expressions]{.guihint} finden. Diese bietet
sich an, wenn die Umbenennung von vielen Hosts notwendig ist und diese
nach einem bestimmten Schema erfolgt. Gehen Sie wie folgt vor:
:::

::: {.olist .arabic}
1.  Aktivieren Sie die Option [Multiple regular expressions]{.guihint}.

2.  Fügen Sie mit dem Knopf [Add expression]{.guihint} einen
    Übersetzungseintrag an. Jetzt erscheinen zwei Felder.

3.  Geben Sie im Feld [Regular expression]{.guihint} einen regulären
    Ausdruck ein, der auf die ursprünglichen Objektnamen matcht und der
    mindestens eine Subgruppe enthält --- also einen Teilausdruck, der
    in runde Klammern gesetzt ist. Eine gute Erklärung zu diesen Gruppen
    finden Sie im [Artikel zu regulären
    Ausdrücken.](regexes.html#matchgroups)

4.  Geben Sie bei [Replacement]{.guihint} ein Schema für den gewünschten
    Namen des Ziel-Hosts an, wobei Sie die Werte, die mit den Subgruppen
    „eingefangen" wurden, durch `\1`, `\2` usw. ersetzen können.
:::

::: paragraph
Ein Beispiel für den regulären Ausdruck wäre z.B. `vm(.*)-local`. Die
Ersetzung `myvm\1` würde dann z.B. den Namen `vmharri-local` in
`myvmharri` übersetzen.
:::
::::::::::::::::

::::::::::: sect2
### []{#outdated_data .hidden-anchor .sr-only}3.4. Veraltete Piggyback-Daten {#heading_outdated_data}

::: paragraph
Verändert sich Ihr Netzwerk, so können sich auch die Piggyback-Daten
ändern. Das wirft neue Fragen auf. Wie reagiert das Monitoring darauf,
wenn ein Host nicht erreichbar ist? Was passiert, wenn Piggyback-Daten
veralten, zum Beispiel, weil das Objekt temporär - oder sogar
dauerhaft - nicht mehr vorhanden ist? Werden alle Piggyback-Daten gleich
behandelt oder gibt es Unterschiede? Wie bei vielen anderen Themen in
Checkmk ist das Verhalten auch hier wieder Einstellungs- und damit
Regelsache. Mit der Regel [Processing of piggybacked host
data]{.guihint}, die Sie unter [Setup \> Agents \> Agent access
rules]{.guihint} finden, können Sie verschiedene Optionen einstellen.
:::

::: paragraph
Im Abschnitt [Processing of piggybacked host data]{.guihint} geben Sie
die eigentlich interessanten Angaben zur Verarbeitung der
Piggyback-Daten an.
:::

:::: imageblock
::: content
![Festlegung der Regeln für veraltete
Piggyback-Daten.](../images/piggyback_processing_rule2.png)
:::
::::

::: paragraph
Checkmk erleichtert Ihnen die Arbeit bei der Verwaltung der
Piggyback-Daten. So entfernt es unter anderem automatisch alle
Hosts/Objekte, zu denen keine Piggyback-Daten (mehr) von einem
Quell-Host geliefert werden. Mit der Option [Keep hosts while piggyback
source sends piggyback data only for other hosts]{.guihint} legen Sie
fest, nach welcher Zeit die betroffenen Dateien mit Piggyback-Daten
gelöscht werden. Achten Sie darauf, dass dieser Zeitraum mindestens so
groß sein muss wie das Check-Intervall für die Piggyback-Hosts.
:::

::: paragraph
Über die beiden Optionen in [Set period how long outdated piggyback data
is treated as valid]{.guihint} legen Sie fest, für wie lange vorhandene
Piggyback-Daten noch als valide angesehen werden sollen, wenn der Host
keine neuen Daten mehr liefert. Nach Ablauf des definierten Zeitraums
werden die Services, die auf den Piggyback-Daten basieren, als
[*stale*](monitoring_basics.html#stale) angezeigt. Außerdem legen Sie
den Zustand des Services [Check_MK]{.guihint} in diesem Zeitraum fest.
Insbesondere wenn es immer wieder zu kurzzeitigen
Verbindungsunterbrechungen kommen kann, können Sie damit unnötige
Warnungen umgehen.
:::

::: paragraph
Nachdem Sie die Behandlung der Piggyback-Daten im Allgemeinen festgelegt
haben, können Sie unter [Exceptions for piggybacked hosts]{.guihint} mit
den beschriebenen Optionen gezielt für einzelne Hosts eine gesonderte
Behandlung (nach dem gleichen Schema) definieren.
:::

::: paragraph
In den [Conditions]{.guihint} müssen Sie zum Abschluss auf jeden Fall in
der Option [Explicit hosts]{.guihint} den Namen des Quell-Hosts angeben.
:::
:::::::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#technology .hidden-anchor .sr-only}4. Die Technik dahinter {#heading_technology}

::::::::::::::::::: sectionbody
:::::::::: sect2
### []{#_transport_der_piggyback_daten .hidden-anchor .sr-only}4.1. Transport der Piggyback-Daten {#heading__transport_der_piggyback_daten}

::: paragraph
Wie oben beschrieben werden die Piggyback-Daten zu anderen Hosts in der
Agentenausgabe des Quell-Hosts transportiert. Die Ausgabe des
Checkmk-Agenten ist ein einfaches textbasiertes Format, das der [Artikel
über die Agenten](wato_monitoringagents.html) vorstellt.
:::

::: paragraph
Neu ist jetzt, dass im Output eine Zeile erlaubt ist, die mit `<<<<`
beginnt und mit `>>>>` endet. Dazwischen steht ein Host-Name. Alle
weiteren Monitoring-Daten ab dieser Zeile werden dann diesem Host
zugeordnet. Hier ist ein beispielhafter Auszug, der die Sektion
`<<<esx_vsphere_vm>>>` dem Host `316-VM-MGM` zuordnet:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
<<<<316-VM-MGM>>>>
<<<esx_vsphere_vm>>>
config.datastoreUrl url /vmfs/volumes/55b643e1-3f344a10-68eb-90b11c00ff94|uncommitted 12472944334|name EQLSAS-DS-04|type VMFS|accessible true|capacity 1099243192320|freeSpace 620699320320
config.hardware.memoryMB 4096
config.hardware.numCPU 2
config.hardware.numCoresPerSocket 2
guest.toolsVersion 9537
guest.toolsVersionStatus guestToolsCurrent
guestHeartbeatStatus green
name 316-VM-MGM
```
:::
::::

::: paragraph
Durch eine Zeile mit dem Inhalt `<<<<>>>>` kann diese Zuordnung wieder
aufgehoben werden. Der weitere Output gehört dann wieder zum Quell-Host.
:::

::: paragraph
Bei der Verarbeitung der Agentenausgabe extrahiert Checkmk die Teile,
die für andere Hosts bestimmt sind, und legt sie in Dateien unterhalb
von `~/tmp/check_mk/piggyback` ab. Darunter befindet sich für jeden
Ziel-Host (z.B. für jede VM) ein Unterverzeichnis --- in unserem
Beispiel also ein Ordner mit dem Namen `B`. Darin ist dann pro
Quell-Host eine Datei mit den eigentlichen Daten. Deren Name wäre in
unserem Beispiel `A`. Warum ist das so kompliziert gelöst? Nun, ein Host
kann in der Tat Piggyback-Daten von *mehreren* Hosts bekommen, somit
wäre eine einzelne Datei nicht ausreichend.
:::

::: paragraph
**Tipp:** Wenn Sie neugierig sind, wie die Piggyback-Daten bei Ihnen
aussehen, finden Sie die Agentenausgaben Ihrer Hosts in der
Monitoring-Instanz im Verzeichnis `~/tmp/check_mk/cache`. Eine Übersicht
über alle beteiligten Dateien und Verzeichnisse finden Sie [weiter
unten.](#files)
:::
::::::::::

:::::::: sect2
### []{#orphaned_piggyback_data .hidden-anchor .sr-only}4.2. Verwaiste Piggyback-Daten {#heading_orphaned_piggyback_data}

::: paragraph
Wenn Sie in in einer Umgebung arbeiten, in der Hosts automatisiert den
Quell-Host wechseln, empfehlen wir die Nutzung der [dynamischen
Host-Konfiguration.](dcd.html) Wird deren Einsatz nicht benötigt oder
erwünscht (beispielsweise weil virtuelle Maschinen manuell umgezogen
werden), dann kann es Ihnen passieren, dass Piggyback-Daten für einen
Host vorhanden sind, den Sie in Checkmk gar nicht angelegt haben. Das
kann Absicht sein, vielleicht aber auch ein Fehler --- z.B. weil ein
Name nicht genau übereinstimmt.
:::

::: paragraph
In den „Treasures" finden Sie ein Skript mit dem Namen
`find_piggy_orphans`, das Checkmk nach Piggyback-Daten durchsucht, zu
denen es keinen Host im Monitoring gibt. Dieses rufen Sie einfach ohne
Argumente auf. Es gibt dann pro Zeile den Namen von einem nicht
überwachten Piggyback-Host aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ share/doc/check_mk/treasures/find_piggy_orphans
fooVM01
barVM02
```
:::
::::

::: paragraph
Diese Ausgabe ist „sauber", und Sie können sie z.B. in einem Skript
weiterverarbeiten.
:::
::::::::

:::: sect2
### []{#_piggyback_im_verteilten_monitoring .hidden-anchor .sr-only}4.3. Piggyback im verteilten Monitoring {#heading__piggyback_im_verteilten_monitoring}

::: paragraph
Beachten Sie, dass in [verteilten
Umgebungen](distributed_monitoring.html) aktuell Quell-Host und die
Piggyback-Hosts in der gleichen Instanz überwacht werden müssen. Dies
liegt daran, dass die Übertragung der Daten zwischen den Hosts aus
Effizienzgründen mit einem lokalen Dateiaustausch über das Verzeichnis
`~/tmp/check_mk` läuft.
:::
::::
:::::::::::::::::::
::::::::::::::::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}5. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: sect2
### []{#_pfade_auf_dem_checkmk_server .hidden-anchor .sr-only}5.1. Pfade auf dem Checkmk-Server {#heading__pfade_auf_dem_checkmk_server}

+------------------------+---------------------------------------------+
| Pfad                   | Bedeutung                                   |
+========================+=============================================+
| `~/tm                  | Ablageort für Piggyback-Daten               |
| p/check_mk/piggyback/` |                                             |
+------------------------+---------------------------------------------+
| `~/tmp/                | Verzeichnis von Piggyback-Daten *für* Host  |
| check_mk/piggyback/B/` | B                                           |
+------------------------+---------------------------------------------+
| `~/tmp/c               | Datei mit Piggyback-Daten *von* Host A      |
| heck_mk/piggyback/B/A` | *für* Host B                                |
+------------------------+---------------------------------------------+
| `~/tmp/check_          | Metadaten zu den Hosts, die Piggyback-Daten |
| mk/piggyback_sources/` | erzeugen                                    |
+------------------------+---------------------------------------------+
| `~                     | Agentenausgabe von Host A --- inklusive     |
| /tmp/check_mk/cache/A` | eventuell vorhandenen Piggyback-Daten in    |
|                        | Rohform                                     |
+------------------------+---------------------------------------------+
:::
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
