:::: {#header}
# Dynamische Host-Konfiguration

::: details
[Last modified on 25-May-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/dcd.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Der Piggyback-Mechanismus](piggyback.html) [Amazon Web Services (AWS)
überwachen](monitoring_aws.html) [Microsoft Azure
überwachen](monitoring_azure.html) [Kubernetes
überwachen](monitoring_kubernetes.html) [Docker
überwachen](monitoring_docker.html) [VMware ESXi
überwachen](monitoring_vmware.html)
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
![Symbol für Dynamische
Host-Konfiguration.](../images/dcd_large_icon_dcd_connections.png){width="100%"}
:::
::::

::: paragraph
In Cloud- und Containerumgebungen ist es immer öfter der Fall, dass zu
überwachende Hosts automatisch entstehen und vergehen. Die Konfiguration
des Monitorings hier aktuell zu halten, ist manuell nicht mehr sinnvoll
möglich. Aber auch klassische Infrastrukturen wie z.B. VMware-Cluster
können sehr dynamisch sein, und selbst wenn eine manuelle Pflege hier
noch möglich ist, ist sie doch auf jeden Fall lästig.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen von Checkmk unterstützen Sie bei diesem Thema mit einem
smarten Werkzeug: dem *Dynamic Configuration Daemon* oder kurz *DCD*.
Die dynamische Konfiguration von Hosts bedeutet, dass aufgrund von
Informationen aus der Überwachung von [AWS](monitoring_aws.html),
[Azure](monitoring_azure.html),
[Kubernetes](monitoring_kubernetes.html),
[VMware](monitoring_vmware.html) und anderen Quellen vollautomatisch
Hosts in das Monitoring aufgenommen, aber auch wieder entfernt werden
können.
:::

::: paragraph
Der DCD ist dabei sehr generisch gehalten und nicht auf das Anlegen von
Hosts beschränkt. Er bildet die Grundlage für künftige Erweiterungen von
Checkmk, welche dynamisch die Konfiguration anpassen. Das kann z.B. auch
das Verwalten von Benutzern bedeuten. Zu diesem Zweck arbeitet der DCD
mit sogenannten *Konnektoren*. Jeder Konnektor kann aus einer ganz
bestimmten Art von Quelle Informationen holen und hat dazu seine eigene
spezifische Konfiguration.
:::

::: paragraph
Mit speziellen Konnektoren wird es in Zukunft noch einfacher werden,
Hosts aus einer vorhandenen CMDB automatisch nach Checkmk zu übernehmen.
:::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_verwalten_von_hosts_mit_dem_dcd .hidden-anchor .sr-only}2. Verwalten von Hosts mit dem DCD {#heading__verwalten_von_hosts_mit_dem_dcd}

::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_der_piggyback_konnektor .hidden-anchor .sr-only}2.1. Der Piggyback-Konnektor {#heading__der_piggyback_konnektor}

::: paragraph
Derzeit ist der DCD von Checkmk nur mit einem einzigen Konnektor
ausgestattet: demjenigen für [Piggyback-Daten](piggyback.html). Dieser
ist jedoch sehr universell, denn der Piggyback-Mechanismus wird von
Checkmk in allen Situationen verwendet, wo die Abfrage von einem Host
(meist per Spezialagent) Daten zu anderen Hosts liefert (meist virtuelle
Maschinen oder Cloud-Objekte).
:::

::: paragraph
Hier sind einige Beispiele, wo Checkmk bei der Überwachung Piggyback
einsetzt:
:::

::: ulist
- [AWS](monitoring_aws.html)

- [Azure](monitoring_azure.html)

- [Kubernetes](monitoring_kubernetes.html)

- [Docker](monitoring_docker.html)

- [VMware](monitoring_vmware.html)
:::

::: paragraph
In allen diesen Fällen werden beim Monitoring automatisch Daten zu
anderen Hosts (z.B. den VMs) geholt, die nicht direkt per Netzwerk
angesprochen werden und auf denen auch kein Checkmk-Agent laufen muss.
Mit dem DCD können Sie solche Hosts automatisch ins Monitoring aufnehmen
und auch wieder entfernen lassen, um so immer zeitnah die Realität
abzubilden.
:::

::: paragraph
Dazu analysiert der DCD die vorhandenen Piggyback-Daten, vergleicht,
welche der Hosts bereits im Setup vorhanden sind und legt die fehlenden
Hosts neu an bzw. entfernt inzwischen weggefallene. Dabei sind Hosts,
welche vom DCD automatisch angelegt wurden, trotzdem für Sie in der
Setup-GUI editierbar.
:::
::::::::

::::::::::: sect2
### []{#user_automation .hidden-anchor .sr-only}2.2. Der Automationsbenutzer {#heading_user_automation}

::: paragraph
In Checkmk gibt es standardmäßig einen
[Automationsbenutzer](wato_user.html#automation). Dieser Benutzer wird
von Checkmk angelegt, um automatisierte Abrufe durchführen zu können.
Ein existierender Automationsbenutzer ist auch für die dynamische
Host-Konfiguration zwingend notwendig.
:::

::: paragraph
Haben Sie, aus welchen Gründen auch immer, in Ihrem System diesen
Benutzer gelöscht oder geändert, so müssen Sie einen anderen Benutzer
mit automatisiertem Zugriff auf die API schaffen. In diesem Fall öffnen
Sie über [Setup \> General \> Global settings]{.guihint} die globalen
Grundeinstellungen:
:::

:::: imageblock
::: content
![Automationsbenutzer in den
Grundeinstellungen.](../images/dcd_basic_settings.png)
:::
::::

::: paragraph
Mit einem Klick auf [Credentials: Use \"Checkmk Automation\"
user]{.guihint} kommen Sie zur Bearbeitungsseite der REST-API
Verbindung:
:::

:::: imageblock
::: content
![Umstellung des
Automationsbenutzers.](../images/dcd_connection_RESTAPI.png)
:::
::::

::: paragraph
Hier können Sie einen anderen Benutzer und dessen Zugriffsdaten (Name,
Passwort) eintragen oder Änderungen am bestehenden Automationsbenutzer
eintragen. Sobald Sie die Änderungen mit [![Symbol für das
Speichern.](../images/icons/icon_save.png)]{.image-inline}
[Save]{.guihint} gespeichert haben, wird der definierte Benutzer für die
Automatisierung genutzt und Sie können mit der dynamischen
Host-Konfiguration fortfahren.
:::
:::::::::::

::::::::::::::::::::::::::::::::::: sect2
### []{#_dynamische_konfiguration_einrichten .hidden-anchor .sr-only}2.3. Dynamische Konfiguration einrichten {#heading__dynamische_konfiguration_einrichten}

::::::: sect3
#### []{#_sind_piggyback_daten_da .hidden-anchor .sr-only}Sind Piggyback-Daten da? {#heading__sind_piggyback_daten_da}

::: paragraph
Als einzige Voraussetzung, um den DCD zu nutzen, benötigen Sie
Piggyback-Daten. Diese haben Sie immer dann, wenn Sie das Monitoring für
AWS, Azure und Co. korrekt aufgesetzt haben. Sie können das auch leicht
auf der Kommandozeile überprüfen, denn die Piggyback-Daten werden von
Checkmk im Verzeichnis `tmp/check_mk/piggyback` angelegt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ls tmp/check_mk/piggyback
myvm01  myvm02  myvm03
```
:::
::::

::: paragraph
Wenn dieses Verzeichnis nicht leer ist, dann wurden in dieser Instanz
Piggyback-Daten erzeugt.
:::
:::::::

:::::::::: sect3
#### []{#_generelle_einstellungen_eines_konnektors .hidden-anchor .sr-only}Generelle Einstellungen eines Konnektors {#heading__generelle_einstellungen_eines_konnektors}

::: paragraph
Gehen Sie nun in die Host-Verwaltung. Der Menüeintrag [Setup \> Hosts \>
Dynamic host management]{.guihint} bringt Sie zur Konfiguration des DCD
beziehungsweise dessen Konnektoren:
:::

:::: imageblock
::: content
![Die Seite \'Dynamic host management\' mit leerer
Konnektorenliste.](../images/dcd_connections_empty.png)
:::
::::

::: paragraph
Legen Sie mit [![icon new](../images/icons/icon_new.png)]{.image-inline}
[Add connection]{.guihint} eine neue Verbindung an. Der erste Teil der
Konfiguration sind die [General Properties]{.guihint}:
:::

:::: imageblock
::: content
![Allgemeine Eigenschaften beim Hinzufügen eines neuen
Konnektors.](../images/dcd_connection_general.png)
:::
::::

::: paragraph
Hier vergeben Sie, wie so oft, eine eindeutige ID dieses Konnektors und
einen Titel. Wichtig ist ferner die Auswahl der Checkmk-Instanz, auf der
dieser Konnektor laufen soll. Da Piggyback-Daten immer nur lokal
verarbeitet werden können, muss der Konnektor immer einer konkreten
Instanz zugeordnet werden.
:::
::::::::::

:::::::::::::::: sect3
#### []{#_eigenschaften_des_konnektors .hidden-anchor .sr-only}Eigenschaften des Konnektors {#heading__eigenschaften_des_konnektors}

::: paragraph
Der zweite Teil sind die [Connection Properties]{.guihint}:
:::

:::: imageblock
::: content
![Einstellungen des Konnektors im
Detail.](../images/dcd_connection_properties.png)
:::
::::

::: paragraph
Hier ist bereits der Konnektor [Piggyback data]{.guihint} vorausgewählt
(und aktuell auch der einzig mögliche).
:::

::: paragraph
Mit dem [Sync interval]{.guihint} bestimmen Sie, wie oft der Konnektor
nach neuen Hosts suchen soll. Wenn Sie den regulären Check-Zeitraum von
einer Minute beibehalten haben, macht es keinen Sinn, das wesentlich
öfter zu machen, da ja maximal einmal pro Minute eine Änderung der
Piggyback-Daten stattfinden kann. In dynamischeren Umgebungen können Sie
sowohl Check-Zeitraum als auch Konnektorintervall auch auf deutlich
kleinere Werte einstellen. Dies hat allerdings auch eine höhere
CPU-Auslastung auf dem Checkmk-Server zur Folge.
:::

::: paragraph
Wichtig ist jetzt, dass Sie unter [Piggyback creation options]{.guihint}
mindestens ein neues Element hinzufügen ([Add new element]{.guihint}).
Damit gelangen Sie zu den Einstellungen für automatisch erzeugte Hosts:
:::

:::: imageblock
::: content
![Ordner, in dem Hosts erstellt werden und Datenquellen, die hierfür
herangezogen werden.](../images/dcd_connection_properties_2.png)
:::
::::

::: paragraph
Hier können Sie zwei wichtige Dinge festlegen: In welchem Ordner die
Hosts erzeugt werden sollen (hier z.B. [AWS Cloud 02]{.guihint}) und
welche Host-Attribute gesetzt werden sollen (für letzteres müssen Sie
den [Show-more-Modus](intro_gui.html#show_less_more) aktiviert haben).
Vier wichtige Attribute sind dabei voreingestellt, welche für
piggybacked Hosts meistens Sinn ergeben:
:::

::: {.olist .arabic}
1.  Kein Monitoring per SNMP.

2.  Kein Checkmk-Agent auf dem Host selbst (Daten kommen ja per
    Piggyback).

3.  Piggyback-Daten werden immer erwartet (und es gibt einen Fehler,
    wenn diese fehlen).

4.  Die Hosts haben keine IP-Adresse.
:::

::: paragraph
**Wichtig:** Nur wenn Sie [Delete vanished hosts]{.guihint} aktivieren,
werden Hosts auch wieder entfernt, wenn Sie in Ihrer dynamischen
Umgebung verschwunden sind.
:::

::: paragraph
Möchten Sie nicht automatisch alle Hosts anlegen, so können Sie das mit
der Option [Only add matching hosts]{.guihint} mit einem [regulären
Ausdruck](regexes.html) einschränken. **Wichtig:** Gemeint sind hier die
Hosts, welche *angelegt* werden und *nicht* die Hosts, über die Sie die
Überwachung von z.B. AWS eingerichtet haben.
:::

::: paragraph
Letzteres können Sie mit der Option [Restrict source hosts]{.guihint}
erreichen. Diese bezieht sich auf die Namen der Hosts, welche
Piggyback-Daten *erzeugen*.
:::
::::::::::::::::

::::::: sect3
#### []{#_änderungen_aktivieren .hidden-anchor .sr-only}Änderungen aktivieren {#heading__änderungen_aktivieren}

::: paragraph
Zwei weitere Optionen befassen sich mit dem automatischen Aktivieren von
Änderungen --- für den Fall, dass wirklich Hosts angelegt oder entfernt
wurden. Denn nur dadurch tauchen diese dann auch im Monitoring auf.
:::

::: paragraph
Wenn das [Aktivieren der Änderungen](wato.html#activate_changes) bei
Ihrer Instanz sehr lange dauert, können Sie mit [Group \"Activate
changes\"]{.guihint} dafür sorgen, dass das nach Möglichkeit nicht bei
jedem neuen Host sofort passiert, sondern nachdem einige
„zusammengekommen\" sind.
:::

::: paragraph
Ferner können Sie das automatische Aktivieren von Änderungen auch für
bestimmte Tageszeiten komplett verbieten --- z.B. für die Tageszeiten,
wo ihr Monitoring-System aktiv betreut wird. Denn wenn der DCD
Änderungen aktiviert, werden auch alle anderen Änderungen aktiv, die Sie
oder ein Kollege gerade gemacht haben!
:::

::: paragraph
Nachdem Sie gespeichert haben, erscheint der Konnektor in der Liste. Er
kann aber erst ausgeführt werden, wenn Sie die Änderungen aktiviert
haben. Erst dadurch nimmt er seinen Dienst auf. Lassen Sie sich daher
nicht von der Meldung irritieren, welche zunächst nach dem Speichern
erscheint:\
`Failed to get the status from DCD (The connection 'piggy01' does not exist)`
:::
:::::::
:::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::: sect1
## []{#_den_konnektor_in_betrieb_nehmen .hidden-anchor .sr-only}3. Den Konnektor in Betrieb nehmen {#heading__den_konnektor_in_betrieb_nehmen}

:::::::: sectionbody
::::::: sect2
### []{#_erstes_aktivieren .hidden-anchor .sr-only}3.1. Erstes Aktivieren {#heading__erstes_aktivieren}

::: paragraph
Nach dem Speichern der Konnektoreigenschaften und einem Aktivieren der
Änderungen nimmt die Verbindung automatisch ihren Betrieb auf. Das kann
so schnell gehen, dass Sie bereits direkt nach dem Aktivieren der
Änderungen sehen, wie Hosts im Monitoring angelegt wurden:
:::

:::: imageblock
::: content
![Liste der anstehenden Änderungen unmittelbar vor der automatischen
Übernahme ins Monitoring.](../images/dcd_pending_changes.png)
:::
::::

::: paragraph
Wenn Sie diese Seite kurz darauf neu laden, sind diese Änderungen
wahrscheinlich schon wieder verschwunden, weil sie ja vom DCD
automatisch aktiviert wurden. Die neuen Hosts sind dann bereits im
Monitoring und werden regelmäßig überwacht.
:::
:::::::
::::::::
:::::::::

:::::::::::::: sect1
## []{#automatic_deletion_of_hosts .hidden-anchor .sr-only}4. Automatisches Löschen von Hosts {#heading_automatic_deletion_of_hosts}

::::::::::::: sectionbody
::::: sect2
### []{#_wann_werden_hosts_entfernt .hidden-anchor .sr-only}4.1. Wann werden Hosts entfernt? {#heading__wann_werden_hosts_entfernt}

::: paragraph
Wie oben erwähnt, können Sie den DCD selbstverständlich Hosts, die es
„nicht mehr gibt", automatisch aus dem Monitoring löschen lassen. Das
klingt erst einmal sehr logisch. Was *genau* das „nicht mehr gibt"
allerdings bedeutet, ist auf den zweiten Blick doch etwas komplexer, da
es verschiedene Fälle zu betrachten gibt. Wir gehen in folgender
Übersicht davon aus, dass Sie die Löschoption aktiviert haben. Denn
sonst werden grundsätzlich nie Hosts automatisch entfernt.
:::

+--------------------+-------------------------------------------------+
| Situation          | Was geschieht?                                  |
+====================+=================================================+
| Entfernen eines    | Wenn Sie einen DCD-Konnektor stilllegen ([do    |
| DCD-Konnektors     | not activate this dynamic configuration         |
|                    | connection]{.guihint}) oder ganz entfernen,     |
|                    | bleiben alle Hosts, die durch diesen Konnektor  |
|                    | erzeugt wurden, erhalten. Bei Bedarf müssen Sie |
|                    | diese von Hand löschen.                         |
+--------------------+-------------------------------------------------+
| Piggybacked Host   | Wenn Sie den Host, über den Sie Ihre Cloud-     |
| wird nicht mehr    | oder Containerumgebung überwachen, aus dem      |
| überwacht          | Monitoring entfernen, erzeugt dieser natürlich  |
|                    | keine Piggyback-Daten mehr. In diesem Fall      |
|                    | werden die automatisch erzeugten Hosts *nach    |
|                    | einer Stunde* automatisch entfernt.             |
+--------------------+-------------------------------------------------+
| Piggybacked Host   | Wenn Ihre Cloud-Umgebung mal nicht erreichbar   |
| ist nicht          | ist, und der Checkmk-Service, der diese         |
| erreichbar         | abfragt, auf [CRIT]{.state2} geht, so bleiben   |
|                    | die erzeugten Hosts *auf unbestimmte Zeit* im   |
|                    | Monitoring. Hier gibt es keinen einstündigen    |
|                    | Timeout!                                        |
+--------------------+-------------------------------------------------+
| Der Checkmk-Server | Ein Stoppen des ganzen Monitorings führt zwar   |
| selbst ist         | dazu, dass Piggyback-Daten veralten. Aber       |
| gestoppt           | natürlich werden angelegte Hosts deswegen       |
|                    | *nicht* gelöscht. Das gleiche gilt, wenn der    |
|                    | Checkmk-Server neu gebootet wird (wodurch       |
|                    | vorübergehend alle Piggyback-Daten verloren     |
|                    | gehen, da diese in der RAM-Disk liegen).        |
+--------------------+-------------------------------------------------+
| Ein Host ist nicht | Das ist quasi der Normalfall: Ein Host in der   |
| mehr in den        | Cloud-/Containerumgebung ist verschwunden. In   |
| Piggyback-Daten    | diesem Fall wird er *sofort* aus dem Monitoring |
| enthalten          | entfernt.                                       |
+--------------------+-------------------------------------------------+

::: paragraph
Beachten Sie, dass es mit der Regel [Automatic host removal]{.guihint}
für alle Hosts die Möglichkeit gibt, diese [automatisch entfernen zu
lassen.](hosts_setup.html#hosts_autoremove) Beide Optionen zum
*Lifecycle Management* arbeiten unabhängig voneinander, d.h. ein Host
wird entfernt, wenn eine der beiden Voraussetzungen erfüllt ist.
:::
:::::

::::::::: sect2
### []{#_konfigurationsmöglichkeiten .hidden-anchor .sr-only}4.2. Konfigurationsmöglichkeiten {#heading__konfigurationsmöglichkeiten}

::: paragraph
Neben der Frage, ob Hosts überhaupt automatisch entfernt werden sollen,
gibt es bei den Konnektoreigenschaften noch drei weitere Optionen, die
das Löschen beeinflussen und die wir vorhin übersprungen haben:
:::

:::: imageblock
::: content
![Feineinstellungen zum automatischen Löschen von
Hosts.](../images/dcd_deletion_tuning.png)
:::
::::

::: paragraph
Die erste Einstellung --- [Prevent host deletion right after
initialization]{.guihint} --- betrifft einen kompletten Neustart des
Checkmk-Servers selbst. Denn in dieser Situation fehlen erst einmal
Piggyback-Daten von allen Hosts, bis diese zum ersten Mal abgefragt
wurden. Um ein sinnloses Löschen und Wiedererscheinen von Hosts zu
vermeiden (welches auch mit wiederholten Benachrichtigungen zu schon
bekannten Problemen einhergeht), wird standardmäßig in den ersten 10
Minuten auf ein Löschen generell verzichtet. Diese Zeit können Sie hier
einstellen.
:::

::: paragraph
Die Option [Validity of missing data]{.guihint} behandelt den Fall, dass
ein Host, aufgrund dessen Monitoring-Daten etliche Hosts automatisch
angelegt wurden, keine Piggyback-Daten mehr liefert. Das kann z.B. der
Fall sein, wenn ein Zugriff auf AWS und Co. nicht mehr funktioniert.
Oder natürlich auch, wenn Sie den Spezialagenten aus der Konfiguration
entfernt haben. Die automatisch erzeugten Hosts bleiben dann noch die
eingestellte Zeit im System, bevor sie aus der Setup-GUI entfernt
werden.
:::

::: paragraph
Die Option [Validity of outdated data]{.guihint} ist ähnlich, behandelt
aber den Fall, dass schon noch Piggyback-Daten kommen, allerdings für
manche Hosts nicht mehr. Das ist der normale Fall wenn z.B. virtuelle
Maschinen oder Cloud-Dienste nicht mehr vorhanden sind. Wenn Sie
möchten, dass die entsprechenden Objekte aus Checkmk dann zeitnah
verschwinden, dann setzen Sie hier eine entsprechend kurze Zeitspanne.
:::
:::::::::
:::::::::::::
::::::::::::::

:::::::::::::::: sect1
## []{#_diagnose .hidden-anchor .sr-only}5. Diagnose {#heading__diagnose}

::::::::::::::: sectionbody
::::::: sect2
### []{#_ausführungshistorie .hidden-anchor .sr-only}5.1. Ausführungshistorie {#heading__ausführungshistorie}

::: paragraph
Wenn Sie dem DCD bei der Arbeit zusehen möchten, finden Sie in der Liste
der Konnektoren bei jedem Eintrag das Symbol [![icon dcd
history](../images/icons/icon_dcd_history.png)]{.image-inline}. Dieses
führt Sie zur Ausführungshistorie:
:::

:::: imageblock
::: content
![Ausführungshistorie bei Suche und Anlegen neuer
Hosts.](../images/dcd_execution_history.png)
:::
::::

::: paragraph
Sollte aus irgendwelchen Gründen die Erstellung eines Hosts
fehlschlagen, sehen Sie dies in der Ausführungshistorie.
:::
:::::::

:::: sect2
### []{#_audit_log .hidden-anchor .sr-only}5.2. Audit Log {#heading__audit_log}

::: paragraph
Mit [Setup \> General \> Audit log]{.guihint} öffnen Sie eine Seite mit
der Liste aller Änderungen, die in der Setup-GUI gemacht wurden --- egal
ob diese bereits aktiviert wurden oder nicht. Suchen Sie nach Einträgen
vom Benutzer `automation` bzw. dem Benutzer, den Sie stattdessen
autorisiert haben (siehe hierzu Abschnitt [Der Benutzer
\'automation\'](#user_automation)). Unter diesem Account arbeitet der
DCD und erzeugt Änderungen. So können Sie nachvollziehen, wann er
welchen Host angelegt oder entfernt hat.
:::
::::

::::::: sect2
### []{#_log_datei_des_dcd .hidden-anchor .sr-only}5.3. Log-Datei des DCD {#heading__log_datei_des_dcd}

::: paragraph
Die Log-Datei des DCD ist `var/log/dcd.log`. Hier ist ein Beispiel,
welches zu obiger Abbildung passt. Auch hier finden Sie die
Fehlermeldung, dass ein bestimmter Host nicht angelegt werden konnte:
:::

::::: listingblock
::: title
var/log/dcd.log
:::

::: content
``` {.pygments .highlight}
2021-11-10 14:45:22,916 [20] [cmk.dcd] ---------------------------------------------------
2021-11-10 14:45:22,916 [20] [cmk.dcd] Dynamic Configuration Daemon (2.0.0p14) starting (Site: mysite, PID: 7450)...
2021-11-10 14:45:22,917 [20] [cmk.dcd.ConnectionManager] Initializing 0 connections
2021-11-10 14:45:22,918 [20] [cmk.dcd.ConnectionManager] Initialized all connections
2021-11-10 14:45:22,943 [20] [cmk.dcd.CommandManager] Starting up
2021-11-10 15:10:58,271 [20] [cmk.dcd.Manager] Reloading configuration
2021-11-10 15:10:58,272 [20] [cmk.dcd.ConnectionManager] Initializing 1 connections
2021-11-10 15:10:58,272 [20] [cmk.dcd.ConnectionManager] Initializing connection 'piggy01'
2021-11-10 15:10:58,272 [20] [cmk.dcd.ConnectionManager] Initialized all connections
2021-11-10 15:10:58,272 [20] [cmk.dcd.ConnectionManager] Starting new connections
2021-11-10 15:10:58,272 [20] [cmk.dcd.piggy01] Starting up
2021-11-10 15:10:58,273 [20] [cmk.dcd.ConnectionManager] Started all connections
```
:::
:::::
:::::::
:::::::::::::::
::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `tmp/c             | Hier entstehen Piggyback-Daten. Für jeden in    |
| heck_mk/piggyback` | den Piggyback-Daten enthaltenen piggybacked     |
|                    | Host entsteht ein Verzeichnis.                  |
+--------------------+-------------------------------------------------+
| `var/log/dcd.log`  | Logdatei des Dynamic Configuration Daemon (DCD) |
+--------------------+-------------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
