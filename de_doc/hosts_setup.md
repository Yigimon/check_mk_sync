:::: {#header}
# Verwaltung der Hosts

::: details
[Last modified on 05-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/hosts_setup.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Automatisch Hosts erstellen](hosts_autoregister.html) [Die
Konfiguration von Checkmk](wato.html) [Regeln](wato_rules.html)
[Services verstehen und konfigurieren](wato_services.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Die wichtigste Aufgabe beim Einrichten des Monitorings ist das Verwalten
der zu überwachenden Systeme --- der [*Hosts*.](glossar.html#host) Dabei
geht es nicht nur darum, dass diese mit den richtigen Stammdaten (z.B.
Host-Name, IP-Adresse) eingetragen sind. Auch Einstellungen für das
Monitoring (z.B. Benachrichtigungen, Schwellwerte usw.) erfordern
regelmäßige Pflege.
:::

::: paragraph
Checkmk wurde von Anfang an für Umgebungen mit sehr vielen Hosts
entworfen und hat einen ganz eigenen Ansatz, um die Konfiguration
solcher Umgebungen für den Benutzer handhabbar zu machen. Die
wichtigsten Prinzipien sind:
:::

::: ulist
- Eine [Hierarchie von Ordnern](#folder), in denen Hosts abgelegt
  werden.

- [Host-Merkmale](glossar.html#host_tag) (englisch: *host tags*) und
  eine darauf aufbauende [regelbasierte](wato_rules.html) Konfiguration.

- Automatische Erkennung der zu überwachenden
  [Services.](wato_services.html)
:::

::: paragraph
Generell hat es sich bewährt, sich als Erstes ein Ordnungssystem zu
überlegen und dieses danach mit Inhalt zu füllen. Welche Möglichkeiten
Checkmk bietet, Ordnung in Ihre Hosts zu bringen, erfahren Sie im
Artikel über die [Strukturierung von Hosts.](hosts_structure.html)
:::
:::::::
::::::::

::::::::::::::::::::: sect1
## []{#folder .hidden-anchor .sr-only}2. Ordner und Vererbung {#heading_folder}

:::::::::::::::::::: sectionbody
::: paragraph
Jeder, der mit Computern arbeitet, kennt das Prinzip von Dateien und
Ordnern. Checkmk verwendet ein analoges Prinzip für die Verwaltung der
Hosts, welche quasi die Rolle der Dateien übernehmen. Da Ordner auch
selbst in Ordnern enthalten sein können, ergibt sich eine Baumstruktur.
:::

::::::::: sect2
### []{#_hierarchie_der_ordner .hidden-anchor .sr-only}2.1. Hierarchie der Ordner {#heading__hierarchie_der_ordner}

::: paragraph
In der Ausgestaltung der Baumstruktur sind Sie völlig frei. Jede Form
der Unterscheidung ist möglich. Drei Kriterien für den Aufbau des
Host-Baums sind jedoch verbreitet:
:::

::: ulist
- **Standort** (z.B. München versus Shanghai)

- **Host-Typ** (z.B. Switch versus Load Balancer)

- **Organisationsstruktur** (z.B. Datenbankgruppe versus Netzwerkgruppe)
:::

::: paragraph
Natürlich können Sie die Kriterien auch mischen, also z.B. in der ersten
Ebene des Baums nach Standort aufteilen und in der zweiten dann nach
Host-Typen.
:::

::: paragraph
Wenn Sie einfache Dinge lieben, sollten Sie die Hosts nur in die
„Blätter" des Baums packen (auch wenn Checkmk Hosts in mittleren Ordnern
erlaubt). Folgendes Beispiel zeigt eine einfache Baumstruktur nach
Host-Typ: Die Hosts A, B und C sind im Ordner „Servers" und D, E und F
im Ordner „Network" eingeordnet:
:::

:::: imageblock
::: content
![Illustration einer Ordnerstruktur mit zwei
Unterordnern.](../images/wato_folders_step_2.png){width="430px"}
:::
::::
:::::::::

::::::::: sect2
### []{#inheritance .hidden-anchor .sr-only}2.2. Vererbung von Attributen {#heading_inheritance}

::: paragraph
Wenn Sie den Baum geschickt aufbauen, können Sie ihn nutzen, um sinnvoll
Attribute zu vererben. Das ist vor allem bei solchen Attributen
nützlich, die bei großen Gruppen von Hosts gleich sind, wie z.B. die
SNMP-Community oder Host-Merkmale (*host tags*), mit denen Sie
festlegen, ob der Host per Checkmk-Agent oder per SNMP überwacht werden
soll.
:::

::: paragraph
Folgendes Beispiel zeigt die Vererbung der Merkmalsgruppen „Criticality"
(mit den Werten `prod` und `test`) und „Checkmk agent / API
integrations" (mit den Ausprägungen `tcp` und `no-agent`). Das
Hilfsmerkmal `tcp` wird dabei automatisch gesetzt, wenn der
Checkmk-Agent und/oder eine API-Integration ausgewählt ist, während
`no-agent` die Option der Wahl ist, wenn über SNMP überwacht werden
soll.
:::

:::: imageblock
::: content
![Illustration einer Ordnerstruktur mit zugewiesenen Attributen auf
unterschiedlichen
Ebenen.](../images/wato_folders_step_4.png){width="500px"}
:::
::::

::: paragraph
Weiter unten im Baum definierte Attribute haben immer Vorrang. Direkt
beim Host festgelegte Werte überschreiben also alles, was von den
Ordnern kommt. In obigem Beispiel ergeben sich so für den Host A die
Merkmale `prod` und `tcp`, für D `prod` und `no-agent` und für den Host
F wegen des expliziten Attributs die Werte `test` und `no-agent`.
:::

::: paragraph
Ein großer Vorteil dieses Schemas gegenüber dem weit verbreiteten „Copy
& Paste"-Ansatz von Datenbank orientierten Konfigurationssystemen: Sie
können Attribute auch für solche Hosts festlegen, die erst **in
Zukunft** hinzukommen werden. Das macht die Arbeit für Sie (und Ihre
Kollegen) leichter: Einfach den neuen Host in den richtigen Ordner
werfen und alle vordefinierten Attribute stimmen automatisch.
:::
:::::::::

:::: sect2
### []{#create_folders .hidden-anchor .sr-only}2.3. Ordner erstellen {#heading_create_folders}

::: paragraph
Wie Sie Ordner erstellen, erfahren Sie im [Leitfaden für
Einsteiger.](intro_setup_monitor.html#create_folders)
:::
::::
::::::::::::::::::::
:::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#create_hosts .hidden-anchor .sr-only}3. Hosts im Setup erstellen und bearbeiten {#heading_create_hosts}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Zur Verwaltung der Ordner und Hosts gelangen Sie mit [Setup \> Hosts \>
Hosts:]{.guihint}
:::

:::: imageblock
::: content
![Ordneransicht \'Main\' mit mehreren
Unterordnern.](../images/hosts_main_directory.png)
:::
::::

::: paragraph
In der Standardansicht sehen Sie hier die (zu Beginn leere) Übersicht
der Ordner und darunter tabellarisch die bereits im aktuellen Ordner
vorhandenen Hosts. Das Anlegen eines neuen Hosts mit dem Aktionsknopf
[![icon new](../images/icons/icon_new.png)]{.image-inline} [Add
host]{.guihint}, das [![Symbol zum Klonen eines
Listeneintrags.](../images/icons/icon_clone.png)]{.image-inline} Klonen
oder das [![Symbol zum Bearbeiten eines
Listeneintrags.](../images/icons/icon_edit.png)]{.image-inline}
Editieren eines bestehenden Hosts bringt Sie zu den Eigenschaften des
Hosts auf der Seite [Properties of host]{.guihint}. Hier werden die
Attribute des Hosts aufgelistet. Diese sind in mehreren Abschnitten
gruppiert, von denen wir hier die Wichtigsten vorstellen.
:::

::::::: sect2
### []{#host_name .hidden-anchor .sr-only}3.1. Der Host-Name {#heading_host_name}

::: paragraph
Das Feld [Hostname]{.guihint} dient überall innerhalb von Checkmk zur
eindeutigen Identifizierung des Hosts. Wenn möglich sollten Sie den
DNS-Namen des Hosts verwenden. Ist der DNS-Name zu sperrig, können Sie
später einen leichter erkennbaren Aliasnamen vergeben. Beachten Sie
allerdings, dass Checkmk für den Host-Namen maximal eine Länge 253
Zeichen erlaubt.
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts: der
Host-Name.](../images/hosts_new_host_1.png)
:::
::::

::: paragraph
[Änderungen am Host-Namen](#rename) sind prinzipiell auch später
möglich. Da der Host-Name jedoch an vielen Stellen in Checkmk verwendet
wird, sind Änderungen aufwendiger je mehr Monitoring-Daten zum Zeitpunkt
der Änderung schon angefallen sind.
:::
:::::::

::::::::::: sect2
### []{#dns .hidden-anchor .sr-only}3.2. Alias und IP-Adresse {#heading_dns}

::: paragraph
Sie können unter [Alias]{.guihint} einen alternativen, beschreibenden
Namen für den Host vergeben, welcher an vielen Stellen in der GUI und in
Berichten angezeigt wird. Vergeben Sie keinen Alias, so wird stattdessen
der Host-Name verwendet.
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts: Alias und
IP-Adresse.](../images/hosts_new_host_2.png)
:::
::::

::: paragraph
Eine IP-Adresse müssen Sie nicht zwangsläufig angeben. Für die
Konfiguration der IP-Adresse haben Sie vier Möglichkeiten, die auch den
Zeitpunkt der Namensauflösung bestimmen:
:::

+---+---------------------------------------------+--------------------+
| M | Vorgehen                                    | Wann wird die      |
| ö |                                             | Namensauflösung    |
| g |                                             | durchgeführt?      |
| l |                                             |                    |
| i |                                             |                    |
| c |                                             |                    |
| h |                                             |                    |
| k |                                             |                    |
| e |                                             |                    |
| i |                                             |                    |
| t |                                             |                    |
+===+=============================================+====================+
| 1 | Sie geben *keine* IP-Adresse an. Der        | Beim [Aktivieren   |
| \ | Host-Name muss per DNS auflösbar sein.      | der                |
| . |                                             | Änd                |
|   |                                             | erungen](wato.html |
|   |                                             | #activate_changes) |
+---+---------------------------------------------+--------------------+
| 2 | Sie geben eine IPv4-Adresse ein --- in der  | Nie                |
| \ | üblichen Punkt-Notation.                    |                    |
| . |                                             |                    |
+---+---------------------------------------------+--------------------+
| 3 | Sie geben anstelle einer IP-Adresse einen   | Beim Ausführen der |
| \ | (alternativen) Host-Namen ein, welcher per  | Checks             |
| . | DNS auflösbar ist.                          |                    |
+---+---------------------------------------------+--------------------+
| 4 | Über den [Regelsatz](wato_rules.html)       | Beim Ausführen der |
| \ | [Hosts with dynamic DNS lookup during       | Checks             |
| . | monitoring]{.guihint} bestimmen Sie Hosts   |                    |
|   | für ein dynamisches DNS. Das Resultat ist   |                    |
|   | analog zu Möglichkeit 3, nur dass für die   |                    |
|   | DNS-Anfrage jetzt das Feld                  |                    |
|   | [Hostname]{.guihint} verwendet wird.        |                    |
+---+---------------------------------------------+--------------------+

::: paragraph
Bei der ersten Möglichkeit verwendet Checkmk eine Cache-Datei, um
wiederholte DNS-Anfragen während der Aktivierung der Änderungen zu
vermeiden. Dieser Cache ist sehr wichtig für die Beschleunigung des
Vorgangs. Außerdem sorgt er dafür, dass Sie eine geänderte Konfiguration
auch dann aktivieren können, wenn das DNS einmal nicht funktioniert.
:::

::: paragraph
Der Haken ist, dass Checkmk die Änderung einer IP-Adresse im DNS nicht
sofort mitbekommt. Deswegen gibt es bei den Host-Eigenschaften den
Menüeintrag [Host \> Update DNS cache.]{.guihint} Dieser löscht den
kompletten DNS-Cache und erzwingt beim nächsten Aktivieren der
Änderungen eine neue Auflösung. Die zugehörige Datei liegt in Ihrer
Instanz unter `~/var/check_mk/ipaddresses.cache`. Das Löschen dieser
Datei hat den gleichen Effekt wie die Ausführung von [Update (site) DNS
cache.]{.guihint}
:::

::: paragraph
Checkmk unterstützt auch Monitoring via IPv6 --- auch im Dual Stack. Die
Rangfolge der Auflösung ist hier durch die Betriebssystemeinstellungen
(`/etc/gai.conf`) vorgegeben. In den Feldern [Additional IPv4
addresses]{.guihint} respektive [Additional IPv6 addresses]{.guihint}
sind nur IP-Adressen in Punkt- beziehungsweise Doppelpunkt-Notation
zugelassen, keine alternativen DNS-Namen.
:::

::: paragraph
Für einige Anwendungsfälle ist es notwendig die [IP address
family]{.guihint} auf [No IP]{.guihint} zu setzen. Dies gilt für Hosts,
die über einen [Spezialagenten](glossar.html#special_agent) abgefragt
werden und für den [Push-Modus](glossar.html#push_mode) des
Checkmk-Agenten. Mehr dazu erfahren Sie im folgenden Abschnitt zu den
Monitoring-Agenten.
:::
:::::::::::

::::::::::: sect2
### []{#monitoring_agents .hidden-anchor .sr-only}3.3. Monitoring-Agenten {#heading_monitoring_agents}

::: paragraph
Mit den [Monitoring agents]{.guihint} entscheiden Sie, aus welchen
Quellen Daten für das Monitoring verwendet werden. Die
Standardeinstellung sieht die Verwendung des
[Checkmk-Agenten](wato_monitoringagents.html#agents) vor. Darüber hinaus
sind zahlreiche alternative oder zusätzliche Überwachungsmöglichkeiten
vorgesehen.
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts:
Monitoring-Agenten.](../images/hosts_new_host_agents.png)
:::
::::

::: paragraph
Insbesondere der erste Eintrag [Checkmk agent / API
integrations]{.guihint} entscheidet, welche Daten bei Vorhandensein
mehrerer Quellen herangezogen und welche verworfen werden. Sie haben die
folgenden Auswahlmöglichkeiten:
:::

+---------------------------+------------------------------------------+
| [API integrations if      | Monitoring-Daten werden per              |
| configured, else Checkmk  | [API-Integr                              |
| agent]{.guihint}          | ationen](glossar.html#api_integrations), |
|                           | das heißt von Spezialagenten oder per    |
|                           | Piggyback von anderen Hosts geliefert.   |
|                           | Sind keine API-Integrationen             |
|                           | konfiguriert, wird auf die Ausgabe des   |
|                           | Checkmk-Agenten zugegriffen. Dies ist    |
|                           | der Standardwert.                        |
+---------------------------+------------------------------------------+
| [Configured API           | Die Ausgabe eines Checkmk-Agenten wird   |
| integrations and Checkmk  | erwartet. Per API-Integrationen          |
| agent]{.guihint}          | gelieferte Daten werden -- falls         |
|                           | konfiguriert -- zusätzlich herangezogen. |
+---------------------------+------------------------------------------+
| [Configured API           | Ausschließlich per API-Integrationen     |
| integrations, no Checkmk  | gelieferte Daten werden für das          |
| agent]{.guihint}          | Monitoring herangezogen.                 |
+---------------------------+------------------------------------------+
| [No API integrations, no  | Mit dieser Einstellung wird der Host per |
| Checkmk agent]{.guihint}  | SNMP oder agentenlos nur mit [aktiven    |
|                           | Checks](glossar.html#active_check)       |
|                           | überwacht. Regeln für aktive Checks      |
|                           | finden Sie u.a. in [Setup \> Hosts \>    |
|                           | HTTP, TCP, Email, ...​ .]{.guihint} Wenn  |
|                           | Sie nicht mindestens einen aktiven Check |
|                           | definieren, erzeugt Checkmk automatisch  |
|                           | einen PING-Service.                      |
+---------------------------+------------------------------------------+

::: paragraph
**Hinweis:** Die Auswahl von [Configured API integrations, no Checkmk
agent]{.guihint} sorgt dafür, dass die beiden Services
[Check_MK]{.guihint} und [Check_MK Discovery]{.guihint} immer den
Zustand [OK]{.state0} haben. Falls Sie für den Host keine IP-Adresse
eingetragen haben, wird dieser den Zustand [DOWN]{.hstate1} annehmen, da
kein Ping durchgeführt werden kann. Sie müssen hier über eine Regel
[Setup \> Hosts \> Host monitoring rules \> Host Check
Command]{.guihint} bestimmen, wie geprüft werden soll, ob der Host als
[UP]{.hstate0} bewertet wird.
:::

::: paragraph
Mit [Checkmk agent connection mode]{.guihint} entscheiden Sie, ob der
Checkmk-Agent im [Pull-Modus](glossar.html#pull_mode) oder im
[Push-Modus](glossar.html#push_mode) arbeiten soll. Diese Option gibt es
nur ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud**, d. h. in Checkmk Cloud und Checkmk MSP, da nur in
diesen Editionen der Push-Modus zur Verfügung steht. Diese Option gibt
es ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** übrigens auch in den Eigenschaften eines Ordners und
wird dort verwendet, um per Autoregistrierung [Hosts automatisch
erstellen zu lassen.](hosts_autoregister.html) Wenn Sie hier [Push -
Checkmk agent contacts the server]{.guihint} auswählen, setzen Sie
zusätzlich im [Kasten Network address](#dns) die [IP address
family]{.guihint} auf [No IP.]{.guihint} Damit verhindern Sie, dass die
Erreichbarkeit des Hosts per [Smart
Ping](cmc_differences.html#smartping) überprüft wird. In allen anderen
Editionen arbeitet der Agent im Pull-Modus.
:::

::: paragraph
Mit der folgenden Einstellung [SNMP]{.guihint} konfigurieren Sie die
Überwachung per [SNMP.](glossar.html#snmp) Nach Aktivierung von
[SNMP]{.guihint} und Auswahl der SNMP-Version wird das Feld [SNMP
credentials]{.guihint} eingeblendet. Damit können Sie die SNMP-Community
festlegen. Da diese meist für viele Hosts gleich ist, empfiehlt es sich
aber eher, diese Einstellung im [Ordner](#folder) zu hinterlegen. Wenn
Sie nichts spezifizieren, wird automatisch `public` angenommen.
:::

::: paragraph
Das letzte Feld [Piggyback]{.guihint} bezieht sich auf die Verwendung
von [Piggyback-Daten](glossar.html#piggyback), welche durch andere Hosts
\"huckepack\" geliefert und als Agentenausgabe diesem Host zugeordnet
werden. Beachten Sie, dass die hier vorgenommene Einstellung zu den
Einstellungen der ersten Option [Checkmk agent / API
integrations]{.guihint} passen muss. Es kann sonst vorkommen, dass das
Ausbleiben erwarteter Monitoring-Daten nicht bemerkt wird. Aus diesem
Grund lautet ein Eintrag explizit [Always use and expect piggyback
data.]{.guihint}
:::
:::::::::::

::::::::::: sect2
### []{#custom_attributes .hidden-anchor .sr-only}3.4. Eigene Attribute {#heading_custom_attributes}

::: paragraph
Im Kasten [Custom attributes]{.guihint} können Sie beliebige
Freitextfelder anzeigen lassen, die Sie zuvor als eigene,
benutzerdefinierte Attribute erstellt haben. In der Standardeinstellung
sind hier [Labels]{.guihint} und die beiden vordefinierten
Host-Merkmalsgruppen [Criticality]{.guihint} (Kritikalität) und
[Networking Segment]{.guihint} (Netzwerksegment) vorhanden:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts: eigene
Attribute.](../images/hosts_new_host_attributes.png)
:::
::::

::: paragraph
Sie können mit [Setup \> Hosts \> Custom host attributes]{.guihint}
eigene Attribute definieren.
:::

:::: imageblock
::: content
![Formular zum Erstellen eines eigenen
Attributs.](../images/hosts_setup_custom_attributes.png)
:::
::::

::: paragraph
Eigene Attribute können beispielsweise ein Vor-Ort-Kontakt, eine
Filialnummer, Informationen zur Hardware, Inventarnummern oder
geografische Koordinaten sein. Werte der eigenen Attribute sollten in
erster Linie Benutzern den Überblick erleichtern, können jedoch auch in
Regeln und Filtern eingesetzt werden, wenn beispielsweise
[Labels](glossar.html#label) oder [Host-Merkmale](glossar.html#host_tag)
zu unflexibel sind.
:::

::: paragraph
Eigene Attribute können durch die Auswahl von [Topic]{.guihint} (Thema)
einem beliebigen Kasten in den Eigenschaften eines Hosts zugeordnet
werden.
:::
:::::::::::

:::::::: sect2
### []{#management_board .hidden-anchor .sr-only}3.5. Management Board {#heading_management_board}

::: paragraph
Die Bezeichnung *Management Board* steht für separate Steckkarten oder
erweiterte BIOS-Funktionalität (Baseboard Management Controller/BMC,
Management Engine/ME, Lights Out Management/LOM) zur Überwachung und
Verwaltung der Hardware neben dem installierten Betriebssystem.
Derartige Hardware bringt neben Fernsteuerungs- und
Fernwartungsfunktionen (bspw. für das Deployment von Betriebssystemen)
meist auch eine IPMI- oder SNMP-Schnittstelle mit, über die
Gesundheitswerte (Temperaturen und Lüfterdrehzahlen) ausgelesen werden
können.
:::

::: paragraph
Tragen Sie hier IP-Adresse und Zugriffsmethode ein, wenn der zu
überwachende Host über ein Management Board verfügt:
:::

:::: imageblock
::: content
![Einrichtung eines Management
Boards.](../images/hosts_setup_management_board.png)
:::
::::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Beginnend mit Checkmk-Version     |
|                                   | [2.4.0]{.new} werden Management   |
|                                   | Boards nicht mehr als Eigenschaft |
|                                   | eines Hosts unterstützt werden.   |
|                                   | Wir raten daher, Management       |
|                                   | Boards als separate SNMP-Hosts    |
|                                   | anzulegen oder -- wenn vorhanden  |
|                                   | -- mit Spezialagenten zu          |
|                                   | überwachen.                       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::

:::::::::: sect2
### []{#creation_locking .hidden-anchor .sr-only}3.6. Erstellung / Sperrung {#heading_creation_locking}

::: paragraph
Während die meisten der bisher beschriebenen Angaben bearbeitet werden
können, stehen im Kasten [Creation / Locking]{.guihint} Angaben, die an
dieser Stelle nur der Information dienen.
:::

:::: imageblock
::: content
![Anzeige der Erstell- und
Sperrinformationen.](../images/hosts_setup_creation_locking.png)
:::
::::

::: paragraph
Der Zeitpunkt der Erstellung ([Created at]{.guihint}) und der Ersteller
([Created by]{.guihint}) werden von Checkmk ermittelt. Für den Namen des
Erstellers gibt es im Wesentlichen drei Möglichkeiten:
:::

::: ulist
- Benutzername, z.B. [cmkadmin]{.guihint}: Der Host wurde manuell durch
  einen Benutzer erstellt, z.B. im [Setup.](#create_hosts)

- *automation*: Der Host wurde durch den
  [Automationsbenutzer](glossar.html#automation_user) erstellt, z.B. mit
  der [REST-API.](rest_api.html)

- *Network scan*: Der Host wurde bei einem automatischen
  [Netzwerk-Scan](#folder_network_scan) gefunden.
:::

::: paragraph
Wenn der Host durch den Automationsbenutzer erstellt wurde, ist er durch
die zugehörige Instanz gesperrt ([Locked by]{.guihint}). Diese Angabe
kann auch für die [Suche nach Hosts im Setup](#search) genutzt werden.
:::

::: paragraph
Gesperrte Attribute ([Locked attributes]{.guihint}) können in den
Eigenschaften des Hosts nicht mehr bearbeitet werden.
:::
::::::::::

::::: sect2
### []{#save .hidden-anchor .sr-only}3.7. Speichern und weiter {#heading_save}

::: paragraph
Beim Erstellen oder Klonen eines Hosts ist nach der Festlegung der
Eigenschaften der nächste sinnvolle Schritt [Save & run service
discovery.]{.guihint} Damit gelangen Sie in die automatische
Service-Erkennung, die wir im [nächsten Kapitel](#services) erklären.
:::

::: paragraph
Dagegen bringt Sie [Save & run connection tests]{.guihint} zum
Verbindungstest. Damit können Sie zuerst einmal testen, ob Sie mit den
festgelegten Einstellungen überhaupt Daten von dem Host bekommen --- sei
es per Agent oder was auch immer Sie vorher konfiguriert haben.
Einzelheiten zum Verbindungstest finden Sie im [Artikel über die
Monitoring-Agenten.](wato_monitoringagents.html#diagnosticpage)
:::
:::::

:::::::::: sect2
### []{#bulk_operations .hidden-anchor .sr-only}3.8. Bulk-Aktionen {#heading_bulk_operations}

::: paragraph
Gelegentlich kommt es vor, dass Sie Dinge wie Löschen, Verschieben,
Editieren oder Service-Erkennung für eine ganze Reihe von Hosts
gleichzeitig durchführen möchten. Dazu gibt es in Checkmk die
sogenannten „Bulk-Aktionen".
:::

::: paragraph
Sie finden diese Aktionen auf der Seite eines geöffneten Ordners im Menü
[Hosts]{.guihint} im Abschnitt [On selected hosts]{.guihint}:
:::

:::: imageblock
::: content
![Menü \'Hosts\' mit den
Bulk-Aktionen.](../images/hosts_bulk_actions.png){width="40%"}
:::
::::

::: paragraph
Die Aktionen beziehen sich immer auf die Hosts, die direkt im
angezeigten Ordner liegen --- und von Ihnen ausgewählt wurden. Dazu
dienen die Checkboxen in der ersten Spalte der Host-Liste. Wenn Sie das
Kreuz im Spaltentitel anklicken, werden alle Hosts ausgewählt --- und
nach erneutem Klick wieder abgewählt.
:::

::: paragraph
Hier einige Hinweise zu den angebotenen Aktionen:
:::

::: ulist
- [Edit attributes:]{.guihint} Ändert ein oder mehrere Attribute der
  Hosts. Das Attribut wird dadurch in die Hosts explizit eingetragen.

  ::: paragraph
  **Achtung:** Es ist ein Unterschied, ob ein Host ein Attribut von
  einem Ordner erbt oder es explizit gesetzt ist, wie durch diese
  Aktion. Warum? In letzterem Fall wird eine Änderung der Attribute im
  Ordner keine Wirkung haben, da Werte, die direkt beim Host festgelegt
  sind, immer Vorrang haben. Aus diesem Grund gibt es auch die folgende
  Aktion.
  :::

- [Run bulk service discovery:]{.guihint} [Service-Erkennung für viele
  Hosts](wato_services.html#bulk_discovery) gleichzeitig durchführen.

- [Move to other folder:]{.guihint} Verschiebt die Hosts in einen
  anderen Ordner. Nach Auswahl dieses Eintrags werden Ihnen die
  bestehenden Ordner als mögliche Ziele angeboten.

- [Detect network parent hosts:]{.guihint} [Parents per
  Scan](#folder_network_scan) anlegen lassen.

- [Remove explicit attribute settings:]{.guihint} Entfernt von den Hosts
  explizite Attribute und setzt die Vererbung wieder in Kraft. Das
  Gleiche würden Sie erreichen, wenn Sie jeden Host einzeln auswählen
  und die Checkboxen bei den betroffenen Attributen abwählen würden.

  ::: paragraph
  Generell ist es eine gute Idee, so wenig explizite Attribute wie
  möglich zu verwenden. Wenn alles korrekt über die Ordner vererbt wird,
  vermeidet dies Fehler und ermöglicht das bequeme Aufnehmen von neuen
  Hosts.
  :::

- [Remove TLS registration:]{.guihint} Entfernt die Registrierung zur
  verschlüsselten Kommunikation per Transport Layer Security (TLS), z.B.
  um die Kommunikation mit dem
  [Checkmk-Agenten](wato_monitoringagents.html#agents) auf den
  unverschlüsselten Modus zurückzusetzen.

- [Delete hosts:]{.guihint} Löscht die Hosts --- nach Bestätigung der
  Nachfrage.
:::
::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::: sect1
## []{#hosts_autoremove .hidden-anchor .sr-only}4. Automatisch Hosts entfernen {#heading_hosts_autoremove}

:::::::::::: sectionbody
::: paragraph
Sie können Hosts, die nicht mehr existieren, aus der
[Konfigurationsumgebung](glossar.html#configuration_environment) und der
[Monitoring-Umgebung](glossar.html#monitoring_environment) automatisch
entfernen lassen. Dabei wird auch das gegenseitige Vertrauensverhältnis
(mTLS) gelöscht, so dass im Falle eines Wiedererscheinens die
Registrierungprozedur erneut durchlaufen werden muss.
:::

::: paragraph
Das Kriterium, mit dem entschieden wird, ob ein Host noch *da* ist, ist
der Zustand des Services [Check_MK]{.guihint}. Dieser Service kümmert
sich um den Zustand des auf dem Host laufenden Monitoring-Agenten im
laufenden Betrieb. Falls es keine Verbindung mehr zum Agenten
gibt --- und damit auch keine aktuellen Monitoring-Daten --- wechselt
der Service in den Zustand [CRIT]{.state2}.
:::

::: paragraph
Hosts, deren Service [Check_MK]{.guihint} über einen bestimmten Zeitraum
[CRIT]{.state2} sind, können Sie automatisch entfernen lassen. Dazu
dient die Regel [Automatic host removal,]{.guihint} die Sie unter [Setup
\> Hosts \> Host monitoring rules]{.guihint} finden. Die Regel ist
einfach. Sie bestimmen nur den Zeitraum, in dem der Service
[Check_MK]{.guihint} sich im Zustand [CRIT]{.state2} befinden muss,
bevor der zugehörige Host entfernt wird:
:::

::::: imageblock
::: content
![Regel zur Festlegung des Zeitraums für das automatische Entfernen von
Hosts.](../images/hosts_rule_automatic_removal.png)
:::

::: title
Hier werden nach 14 Tagen Hosts automatisch entfernt
:::
:::::

::: paragraph
Um die Hosts nicht nur aus dem Setup sondern auch aus dem Monitoring zu
entfernen, werden die Änderungen automatisch aktiviert. Beachten Sie,
dass bei der automatischen Aktivierung *alle* anderen ausstehende
Änderungen mit aktiviert werden.
:::

::: paragraph
**Tipp**: Diese Regel ist in allen Checkmk-Editionen verfügbar. Sie
passt aber besonders gut als Gegenstück zur Möglichkeit, [Hosts
automatisch erstellen zu lassen](hosts_autoregister.html), die im
Funktionsumfang ab Checkmk Cloud enthalten ist. Wenn Sie automatisch
erstellte Hosts auch wieder automatisch entfernen lassen wollen, können
Sie die Bedingung der Regel auf Hosts mit dem Host-Label
`cmk/agent_auto_registered:yes` beschränken. Dieses Label hängt Checkmk
an alle automatisch erstellten Hosts.
:::

::: paragraph
Beachten Sie, dass auch die [dynamische
Host-Konfiguration](dcd.html#automatic_deletion_of_hosts) die
Möglichkeit bietet, Hosts automatisch entfernen zu lassen. Beide
Optionen zum *Lifecycle Management* arbeiten unabhängig voneinander,
d.h. ein Host wird entfernt, wenn eine der beiden Voraussetzungen
erfüllt ist.
:::
::::::::::::
:::::::::::::

:::::::::::: sect1
## []{#services .hidden-anchor .sr-only}5. Services konfigurieren {#heading_services}

::::::::::: sectionbody
::: paragraph
Der nächste Schritt nach dem Anlegen eines Hosts ist die Konfiguration
der darauf zu überwachenden Services. Alle Einzelheiten der
automatischen Erkennung und Konfiguration der Services erfahren Sie im
Artikel [Services verstehen und konfigurieren.](wato_services.html) Wir
schildern hier nur das Wichtigste.
:::

::: paragraph
Zur Liste der konfigurierten Services eines Hosts gelangen Sie auf den
folgenden Wegen:
:::

::: ulist
- Im Setup über die Host-Liste:\
  Wählen Sie [Setup \> Hosts \> Hosts.]{.guihint} In der Host-Liste
  klicken Sie auf [![Symbol zur Anzeige der konfigurierten
  Services.](../images/icons/icon_services.png)]{.image-inline}.

- Im Setup über die Eigenschaften eines Hosts:\
  Wählen Sie [Setup \> Hosts \> Hosts.]{.guihint} In der Host-Liste
  klicken Sie den Host an. Auf der Seite [Properties of host]{.guihint}
  wählen Sie im Menü [Host \> Save & run service discovery.]{.guihint}
  Wenn Sie stattdessen im Menü [Host \> Run service discovery]{.guihint}
  wählen, kommen Sie ebenfalls zur Service-Liste --- ohne allerdings die
  Host-Eigenschaften zu speichern.

- Im Monitoring über die Liste der Services eines Hosts:\
  Wählen Sie das Menü [Host]{.guihint} und dort im Abschnitt
  [Setup]{.guihint} den Eintrag [Service configuration.]{.guihint} Ein
  kleines Zahnradsymbol am Icon zeigt, dass dieser Menüeintrag in eine
  Seite im Setup führt. So kommen Sie direkt zur Konfiguration der
  Services.
:::

::: paragraph
Egal für welchen Weg Sie sich entscheiden, das Ergebnis sollte ungefähr
so aussehen:
:::

:::: imageblock
::: content
![Liste der auf dem Host gefundenen
Services.](../images/hosts_services.png)
:::
::::

::: paragraph
Die wichtigsten Aktionen werden Ihnen in der Aktionsleiste angeboten,
weitere finden Sie im Menü [Actions.]{.guihint} Zu den möglichen
Aktionen einige Hinweise:
:::

::: ulist
- Der Knopf [Accept all]{.guihint} ist meist die beste Aktion für einen
  neuen Host. Dies ist auch die richtige Wahl für bestehende Hosts, bei
  denen Services gefunden wurden, die aktuell nicht überwacht werden.
  Diese finden Sie im Abschnitt [Undecided services (currently not
  monitored).]{.guihint} [Accept all]{.guihint} fügt die fehlenden
  Services hinzu, entfernt verschwundene Services und übernimmt
  gefundene Host-Labels.

- Der Knopf [Rescan]{.guihint} sorgt dafür, dass frische, vollständige
  Daten vom Zielgerät geholt werden. Um einen schnellen Seitenaufbau zu
  ermöglichen, arbeitet Checkmk mit zwischengespeicherten Dateien, die
  beim normalen Monitoring aufgezeichnet werden. Bei SNMP-Geräten löst
  der Knopf daher eine aktive Suche nach neuen Check-Plugins aus und
  findet eventuell weitere Services.

- Der Knopf [Monitor undecided services]{.guihint} übernimmt die
  entsprechenden Services ins Monitoring, allerdings ohne Übernahme der
  Host-Labels.

- [Remove vanished services]{.guihint} entfernt nicht mehr vorhandene
  Services. Das ist bei Services nützlich, die sich bei der Erkennung
  einen aktuellen Zustand merken (z.B. den aktuellen Zustand der Ports
  eines Switches oder von Dateisystemen und ihren Mountpoints).

- Nach jeder Änderung ist ein [Aktivieren der
  Änderungen](wato.html#activate_changes) nötig, um diese wirksam zu
  machen.
:::
:::::::::::
::::::::::::

::::::::::::::::::::::::: sect1
## []{#import .hidden-anchor .sr-only}6. Hosts über CSV-Daten importieren {#heading_import}

:::::::::::::::::::::::: sectionbody
::: paragraph
Wenn Sie eine größere Anzahl von Hosts auf einmal in Checkmk eintragen
möchten, können Sie sich die Arbeit einfach machen. Importieren Sie die
Hosts mithilfe einer CSV-Datei. Vor allem in zwei Anwendungsfällen ist
dies eine Unterstützung:
:::

::: ulist
- Sie wollen Hosts aus einem anderen Monitoring-System übernehmen,
  welches den Export in strukturierten Datenformaten anbietet. Dann
  können Sie sich daraus eine CSV-Datei erstellen lassen und für den
  Checkmk-Import nutzen.

- Sie wollen viele neue Hosts auf einmal anlegen. In diesem Fall
  schreiben Sie diese in eine Excel-Tabelle. Anschließend importieren
  Sie diese Liste als CSV-Datei.
:::

::: paragraph
Checkmk ist beim Einlesen von CSV-Daten recht flexibel. Im einfachsten
Fall haben Sie schlicht eine Datei, in der in jeder Zeile ein Host-Name
steht, der per DNS auflösbar ist:
:::

::::: listingblock
::: title
import.csv
:::

::: content
``` {.pygments .highlight}
myserver01
myserver02
```
:::
:::::

::: paragraph
Sie können beim Import auch gleich weitere Attribute übergeben. Eine
Übersicht aller möglichen Attribute finden Sie im [nächsten
Abschnitt.](#import_attributes) Enthält die CSV-Datei in der ersten
Zeile die Namen der Attribute, wird Checkmk diese automatisch zuordnen.
Checkmk ist recht tolerant gegenüber nicht exakter Rechtschreibung und
versucht kleine Abweichungen zu interpretieren. In folgender Datei z.B.
kann Checkmk automatisch alle Spalten korrekt zuordnen:
:::

::::: listingblock
::: title
import.csv
:::

::: content
``` {.pygments .highlight}
hostname;ip address;alias;agent;snmp_ds
lnx17.example.com;192.168.178.48;Webserver;cmk-agent;
lnx18.exmpl.com;192.168.178.55;Backupserver;cmk-agent;
switch47-11;;Switch47;no-agent;snmp-v2
```
:::
:::::

::: paragraph
Das Vorgehen ist wie folgt: Wählen oder erstellen Sie einen Ordner, in
den der Import erfolgen soll. Wechseln Sie in diesen Ordner [(Setup \>
Hosts \> ...​)]{.guihint} und wählen Sie im Menü [Hosts]{.guihint} den
Eintrag [![Symbol zum Import mehrerer Hosts im
CSV-Dateiformat.](../images/icons/icon_bulk_import.png)]{.image-inline}
[Import hosts via CSV file.]{.guihint}
:::

::: paragraph
Auf der folgenden Seite laden Sie mit [Upload CSV File]{.guihint} die
Datei hoch. Alternativ wählen Sie [Content of CSV File]{.guihint} und
kopieren den Inhalt der Datei in das Textfeld unter der Liste. Sie
können auf den neu importierten Hosts sofort eine automatische
Service-Erkennung ausführen lassen. Wählen Sie dafür die Option [Perform
automatic service discovery:]{.guihint}
:::

:::: imageblock
::: content
![Dialog zur Eingabe der CSV-Daten für den
Import.](../images/hosts_bulk_import_step1.png)
:::
::::

::: paragraph
Per Klick auf [![Symbol zur Übernahme der
Eingaben.](../images/icons/icon_save.png)]{.image-inline}
[Upload]{.guihint} kommen Sie zur nächsten Seite:
:::

:::: imageblock
::: content
![Dialog zur Kontrolle der CSV-Daten für den
Import.](../images/hosts_bulk_import_step2.png)
:::
::::

::: paragraph
Die Auswahl eines Trennzeichens ([field delimiter]{.guihint}) ist für
dieses Beispiel nicht notwendig. Das Semikolon wurde bereits korrekt
interpretiert. Checkmk erkennt gebräuchliche Trennzeichen, wie z.B.
Tabulator oder Semikolon automatisch. Aber wählen Sie hier die Option
[Has title line,]{.guihint} um die Überschriften zu berücksichtigen.
Unter [Preview]{.guihint} sehen Sie die Vorschau der Tabelle.
:::

::: paragraph
Falls die automatische Erkennung einer Spalte nicht klappt, können Sie
auch manuell das Attribut auswählen, welches zugeordnet werden soll.
Nutzen Sie dafür die jeweilige Liste. Bei den Host-Merkmalen (das sind
die Einträge, die mit [Tag]{.guihint} beginnen) muss in der CSV-Datei
unbedingt die interne ID des Merkmals stehen (hier z.B. `cmk-agent` und
nicht der in der GUI sichtbare Titel [Checkmk agent / API
integrations]{.guihint}). Wie die internen IDs der Host-Merkmale genau
lauten, können Sie unter [Setup \> Hosts \> Tags]{.guihint} nachsehen.
Die IDs der vordefinierten ([builtin]{.guihint}) Merkmale finden Sie in
der Tabelle im Artikel über die
[Host-Merkmale.](host_tags.html#predefined_tags)
:::

::: paragraph
Starten Sie den Import durch Klick auf [![Symbol zum Sichern der
Eingaben.](../images/icons/icon_save.png)]{.image-inline}
[Import.]{.guihint} Falls Sie die Option [Perform automatic service
discovery]{.guihint} gewählt haben, landen Sie auf der Seite [Bulk
discovery](wato_services.html#bulk_discovery) und sollten diese noch
bearbeiten. Nach Abschluss der Service-Erkennung fehlt nur noch die
gewohnte Aktivierung der Änderungen, dann befinden sich alle neuen Hosts
im Monitoring.
:::

::: sect2
### []{#import_attributes .hidden-anchor .sr-only}6.1. Übersicht der Attribute für den Import {#heading_import_attributes}

+--------------------+-------------------------------------------------+
| Attribut           | Bedeutung                                       |
+====================+=================================================+
| `Hostname`         | Name des Hosts (maximal 253 Zeichen)            |
+--------------------+-------------------------------------------------+
| `Alias`            | Aliasbezeichnung des Hosts                      |
+--------------------+-------------------------------------------------+
| `                  | Instanz, auf der dieser Host überwacht wird     |
| Monitored on site` |                                                 |
+--------------------+-------------------------------------------------+
| `IPv4 address`     | IPv4-Adresse                                    |
+--------------------+-------------------------------------------------+
| `IPv6 address`     | IPv6-Adresse                                    |
+--------------------+-------------------------------------------------+
| `SNMP community`   | SNMP-Community                                  |
+--------------------+-------------------------------------------------+
| `Tag: Criticality` | Merkmal: Kritikalität                           |
+--------------------+-------------------------------------------------+
| `Tag: N            | Merkmal: Netzwerksegment                        |
| etworking Segment` |                                                 |
+--------------------+-------------------------------------------------+
| `Ta                | Merkmal: Checkmk-Agent / API-Integration        |
| g: Checkmk agent / |                                                 |
|  API integrations` |                                                 |
+--------------------+-------------------------------------------------+
| `Tag: Piggyback`   | Merkmal: Piggyback                              |
+--------------------+-------------------------------------------------+
| `Tag: SNMP`        | Merkmal: SNMP                                   |
+--------------------+-------------------------------------------------+
| `Tag:              | Merkmal: IP-Adressfamilie                       |
| IP address family` |                                                 |
+--------------------+-------------------------------------------------+
:::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::::::::::::: sect1
## []{#folder_network_scan .hidden-anchor .sr-only}7. Netzwerk-Scan für Ordner durchführen {#heading_folder_network_scan}

::::::::::::::::::::: sectionbody
:::::: sect2
### []{#network_scan_principle .hidden-anchor .sr-only}7.1. Das Prinzip {#heading_network_scan_principle}

::: paragraph
Checkmk bietet die Möglichkeit, Ihr Netzwerk --- oder auch nur Teile
davon --- automatisch und regelmäßig nach (neuen) Hosts zu durchsuchen.
Dieser Netzwerk-Scan wird auf Ebene der Ordner in der Host-Verwaltung
von Checkmk eingerichtet. Im Hintergrund läuft dafür minütlich ein
Cronjob. Dieser prüft alle Ordner dahingehend, ob wieder ein
entsprechender Scan ansteht. Der Cronjob prüft dafür die beiden
Einstellungen [Scan interval]{.guihint} und [Time allowed.]{.guihint}
Wenn das Intervall abgelaufen ist und der Server sich innerhalb der für
den Scan erlaubten Zeitspanne befindet, wird der Scan gestartet. Ein neu
eingerichteter Netzwerk-Scan würde also innerhalb einer Minute nach dem
Klick auf [Save]{.guihint} starten, sofern Sie die [Time
allowed]{.guihint} nicht verändert wurde.
:::

::: paragraph
Sobald ein Scan startet, passieren im Grunde drei Dinge:
:::

::: {.olist .arabic}
1.  Checkmk ermittelt zuerst die IP-Adressen, die gescannt werden
    sollen. Aus den konfigurierten Adressbereichen werden dabei alle
    Adressen entfernt, die bereits in der Konfiguration Ihrer Hosts in
    einem beliebigen Ordner verwendet werden.

2.  Die ermittelten Adressen werden nun gepingt. Wenn es auf einer
    Adresse eine Antwort auf diesen Ping gibt, wird versucht einen
    Host-Namen zu ermitteln.

3.  Zuletzt werden die Hosts in dem Ordner erzeugt. Ausgelassen werden
    dabei alle Hosts mit Namen, die es in der Instanz bereits gibt.
:::
::::::

:::::::::::::::: sect2
### []{#setup_network_scan .hidden-anchor .sr-only}7.2. Netzwerk-Scan einrichten {#heading_setup_network_scan}

::: paragraph
Wie oben bereits angesprochen, wird der Netzwerk-Scan auf Ebene der
Ordner eingerichtet. Öffnen Sie zuerst [Setup \> Hosts \>
Hosts.]{.guihint} Navigieren Sie dann in einen beliebigen Ordner oder
verbleiben Sie im Ordner [Main.]{.guihint} Über das Menü [Folder \>
Properties]{.guihint} finden Sie den Kasten [Network Scan.]{.guihint}
:::

:::: imageblock
::: content
![Deaktivierter Kasten \_Network Scan\_ in den Eigenschaften eines
Ordners](../images/wato_host_network_scan_new.png){width="."}
:::
::::

::: paragraph
Aktivieren Sie den Netzwerk-Scan über die entsprechende Checkbox.
:::

:::: imageblock
::: content
![Aktivierter aber unkonfigurierter Kasten \_Network
Scan\_](../images/wato_host_network_scan_activated.png){width="."}
:::
::::

::: paragraph
Legen Sie anschließend bei [IP ranges to scan]{.guihint} die IP-Adressen
fest, welche Checkmk für Sie automatisch überwachen soll. Für diese
Festlegung haben Sie die Wahl zwischen einzelnen IP-Adressen,
IP-Bereichen und ganzen Netzwerken. Wir empfehlen die Adressbereiche
nicht zu groß zu wählen, da es ansonsten zu sehr langen Laufzeiten des
Netzwerk-Scans kommen kann. Bei der Wahl eines Netzwerks empfehlen wir
die Netzmaske von `/21` nicht zu überschreiten, was 2048 IP-Adressen
entspricht. Die Anzahl von 2048 IP-Adressen sollten Sie auch bei Auswahl
über [IP-Range]{.guihint} nicht überschreiten. Dies kann natürlich nur
eine grobe Empfehlung sein, da Ihr (Firmen-)Netzwerk womöglich mit
größeren Adressbereichen problemlos klarkommt.
:::

::: paragraph
Über die folgende Option [IP ranges to exclude]{.guihint} können Sie
Teile aus dem oberhalb konfigurierten Adressbereich ausnehmen. Die
Option bietet sich auch an, um bereits bekannte und überwachte Hosts
bzw. IP-Adressen aus dem Netzwerk-Scan auszuschließen. So können Sie
verhindern, dass Dubletten von Hosts angelegt werden.
:::

::: paragraph
Mit den folgenden beiden Optionen [Scan interval]{.guihint} und [Time
allowed]{.guihint} können Sie festlegen, wie häufig der Scan laufen soll
und zu welcher Zeit Sie dies erlauben möchten.
:::

::: paragraph
Mit die wichtigste Überlegung bei der Einrichtung des Netzwerk-Scans
ist, wie Sie mit gefundenen Hosts umgehen wollen. Hierbei fällt der
Option [Set criticality host tag]{.guihint} eine zentrale Rolle zu:
:::

::: ulist
- Standardmäßig ist [Do not monitor this host]{.guihint} ausgewählt.
  Dies legt fest, dass die gefundenen Hosts erst einmal nur in die
  Host-Verwaltung aufgenommen werden. Ein Monitoring findet so also erst
  einmal nicht statt. Ein Ansatz könnte hier sein, die gefundenen Hosts
  *manuell* in Ihre bestehende Host-Struktur zu überführen --- zum
  Beispiel mithilfe der Funktion [Move this host to another
  folder.]{.guihint} Nach dem Verschieben müssen Sie dann noch das
  Host-Merkmal [Criticality]{.guihint} anpassen oder entfernen. Bei
  einer größeren Zahl von Hosts können Sie hierfür die Funktion [Remove
  explicit attribute settings]{.guihint} in [Setup \> Hosts \>
  Hosts]{.guihint} verwenden.

- Wählen Sie stattdessen hier als Host-Merkmal [Productive
  system]{.guihint} aus, werden die gefundenen Hosts --- bei
  entsprechender Konfiguration mit dem Regelsatz [[Periodic service
  discovery]{.guihint}](wato_services.html#discovery_auto) --- auch
  direkt ins Monitoring aufgenommen.
:::

::: paragraph
Beachten Sie vor Verwendung des Netzwerk-Scans auch die folgenden
grundsätzlichen Überlegungen:
:::

::: ulist
- Der Scan läuft über einen Ping ab. Das bedeutet auch, dass Geräte, die
  nur über SNMP überwacht werden können, zwar womöglich gefunden, aber
  nicht automatisch überwacht werden, da die [SNMP
  credentials]{.guihint} nicht konfiguriert sind.

- Bei neuen Windows-Hosts ist ohne eine entsprechende Konfiguration
  durch z.B. Gruppenrichtlinien das sogenannte *Echo Request* in der
  Firewall deaktiviert. Solche Windows-Hosts werden dem Scan also nicht
  antworten und somit auch nicht gefunden werden.

- Checkmk kann Ihnen zu den gefundenen Hosts nur dann saubere Daten
  liefern, wenn Ihr Netzwerk und Ihre Instanz entsprechend konfiguriert
  sind. Widersprüchliche Einträge im DNS und Ihrer Checkmk-Instanz
  können zu Dubletten führen. Eine Dublette wird angelegt, wenn der Host
  mit Namen (aber ohne IP-Adresse) in Checkmk bereits eingerichtet ist
  und nun über seine IP-Adresse unter einem anderen Namen gefunden wird.
:::
::::::::::::::::
:::::::::::::::::::::
::::::::::::::::::::::

::::::::::::: sect1
## []{#search .hidden-anchor .sr-only}8. Hosts im Setup suchen {#heading_search}

:::::::::::: sectionbody
::: paragraph
Checkmk bietet Ihnen die komfortable Möglichkeit zur Suche in der
[Monitoring-Umgebung](user_interface.html#search_monitor) (im
[Monitor]{.guihint}-Menü) und in der
[Konfigurationsumgebung](user_interface.html#search_setup) (im
[Setup]{.guihint}-Menü). Die Ergebnisse können unterschiedlich sein, da
die Hosts in der Monitoring-Umgebung nicht unbedingt die gleichen sein
müssen wie in der Konfigurationsumgebung: Wenn Sie z.B. einen Host im
Setup erstellt haben, ohne diese Änderung zu aktivieren, existiert
dieser (noch) nicht im Monitoring.
:::

::: paragraph
Zur Suche nach Hosts in der Konfigurationsumgebung gibt es noch eine
andere Möglichkeit, die folgende Vorteile hat:
:::

::: ulist
- Sie können Hosts nach verschiedenen Kriterien suchen lassen.

- Die gefundenen Hosts werden auf einer Ergebnisseite gelistet, von der
  aus Sie die weiter oben vorgestellten
  [Bulk-Aktionen](#bulk_operations) starten können.
:::

::: paragraph
Sie finden diese Suche unter [Setup \> Hosts \> Hosts]{.guihint} auf der
Seite eines geöffneten Ordners im Menü [Display \> Search
hosts.]{.guihint} Die Suche geht immer vom aktuellen Ordner aus,
rekursiv in alle Unterordner. Um global zu suchen, verwenden Sie einfach
die Suche vom Hauptordner [Main]{.guihint} aus:
:::

:::: imageblock
::: content
![Dialog zur Suche nach Hosts in einem
Ordner.](../images/hosts_search.png)
:::
::::

::: paragraph
Beim Feld [Hostname]{.guihint} wird eine Wortteilsuche (*Infix-Suche*)
verwendet --- der eingegebene Text wird, an beliebiger Stelle, im
Host-Namen gesucht. Ferner können Sie die Suche auch über andere
Attribute einschränken. Alle Bedingungen werden mit *UND* verknüpft. Das
Beispiel aus dem Bild oben sucht also alle Hosts mit [my]{.guihint} im
Namen, die gleichzeitig das Merkmal [Test system]{.guihint} haben.
:::

::: paragraph
Mit [Submit]{.guihint} starten Sie die Suche. Die Ergebnisseite verhält
sich fast wie ein normaler Ordner. Das bedeutet, dass Sie hier die
Bulk-Aktionen nutzen können, die im Menü [Hosts]{.guihint} im Abschnitt
[On selected hosts]{.guihint} angeboten werden, um z.B. alle gefundenen
Hosts in einen bestimmten Ordner zu verschieben.
:::

::: paragraph
Sie können die Suche auf der Ergebnisseite mit [Refine search]{.guihint}
weiter anpassen und verfeinern.
:::
::::::::::::
:::::::::::::

:::::::::::::::::: sect1
## []{#rename .hidden-anchor .sr-only}9. Hosts umbenennen {#heading_rename}

::::::::::::::::: sectionbody
::: paragraph
Das Umbenennen von Hosts ist auf den ersten Blick eine einfache Sache.
Bei näherem Hinsehen entpuppt es sich aber als komplexe Operation. Der
Grund ist, dass Checkmk den Namen des Hosts als eindeutigen Schlüssel
für den Host verwendet --- und das an zahlreichen Stellen. Dazu gehören
Dateinamen, Log-Daten, [Regeln](glossar.html#rule),
[Dashboards](glossar.html#dashboard), Berichte,
[BI](glossar.html#bi)-Aggregate und vieles mehr. Auch taucht der
Host-Name in URLs auf.
:::

::: paragraph
Um einen Host an allen Stellen sauber umzubenennen, stellt Checkmk im
[Setup]{.guihint} zwei Aktionen bereit. Sie können entweder einen
einzelnen Host umbenennen (in den Eigenschaften des Hosts im Menü [Host
\> Rename]{.guihint}) oder in einem Ordner mehrere Hosts gleichzeitig
(im Menü [Hosts \> Rename multiple hosts]{.guihint}).
:::

::: paragraph
**Wichtig:** Bei Änderungen an vielen Stellen und für mehrere Hosts kann
auch einmal etwas schief gehen. Vergewissern Sie sich daher, dass Sie
über ein aktuelles [Backup](backup.html) Ihrer Instanz
verfügen --- bevor Sie die Umbenennungsaktion starten.
:::

::: paragraph
Das [Bulk renaming of hosts]{.guihint} ermöglicht die gleichzeitige,
systematische Namensanpassung für mehrere Hosts:
:::

:::: imageblock
::: content
![Dialog zur Umbenennung mehrerer
Hosts.](../images/hosts_bulk_renaming.png)
:::
::::

::: paragraph
Im Feld [Hostname matching]{.guihint} geben Sie zunächst optional einen
regulären Ausdruck an, der mit dem **Anfang** der Host-Namen
übereinstimmt, die Sie umbenennen möchten --- hier im Beispiel also alle
Hosts, deren Namen mit `lnx` beginnen. Dann fügen Sie mit [Add
renaming]{.guihint} eine oder mehrere Operationen ein. Diese werden
**der Reihe nach** auf die Host-Namen angewendet. In obigem Beispiel
wird von allen Host-Namen zunächst mit [Drop Domain Suffix]{.guihint}
alles ab dem ersten `.` abgeschnitten und danach mit [Add
Suffix]{.guihint} die Endung `-linuxserver` angefügt.
:::

::: paragraph
Es stehen weitere Operationen zur Verfügung, die großteils
selbsterklärend sind. Ansonsten können Sie durch Einblenden der
[Inline-Hilfe](user_interface.html#inline_help) weitere Informationen
erhalten.
:::

::: paragraph
Nach dem Start der Umbenennung mit [![Symbol zum Sichern der
Eingaben.](../images/icons/icon_save.png)]{.image-inline} [Bulk
rename]{.guihint} und Bestätigung der obligatorischen „Sind Sie
sicher...​?"-Frage ...
:::

:::: imageblock
::: content
![Dialog zur Bestätigung der
Host-Umbenennung.](../images/hosts_bulk_renaming_sure.png)
:::
::::

::: paragraph
... kann es eine Weile dauern. Während der Umbenennung wird das
Monitoring **komplett gestoppt!** Dies ist notwendig, um alles in einem
konsistenten Zustand zu halten. Am Ende erhalten Sie eine Übersicht, wo
genau Umbenennungen durchgeführt wurden:
:::

:::: imageblock
::: content
![Ergebnis der
Host-Umbenennung.](../images/hosts_bulk_bulk_renaming_result.png)
:::
::::
:::::::::::::::::
::::::::::::::::::

:::::::: sect1
## []{#rest_api .hidden-anchor .sr-only}10. REST-API-Anfragen für Hosts und Ordner {#heading_rest_api}

::::::: sectionbody
::: paragraph
Viele der Aktionen, die in diesem Artikel beschrieben sind, können Sie
auch mit der Checkmk-REST-API ausführen. Dies ist besonders dann
interessant, wenn Sie viele Objekte in Ihrer Instanz zu verwalten haben
und Aktionen automatisieren wollen. So können Sie z.B. viele Hosts per
REST-API erstellen und vermeiden damit mögliche Fehler, die bei der
manuellen Eingabe über die GUI immer wieder vorkommen können.
:::

::: paragraph
Wenn Kommandozeile, Skripte und APIs nicht Ihre Werkzeuge der ersten
Wahl sind, reicht es an dieser Stelle aus, zu wissen, dass es diese API
gibt. Sie können damit auf ein mächtiges Hilfsmittel bei Bedarf
zurückgreifen --- als Alternative zur Verwaltung über die Weboberfläche.
:::

::: paragraph
Im Artikel zur [REST-API](rest_api.html) erhalten Sie eine Einführung
zur Anwendung dieser API. Die Referenz-Dokumentation finden Sie in der
[Weboberfläche](rest_api.html#rest_api_gui) Ihrer Checkmk-Instanz. Dort
können Sie sich mit der Syntax der Anfragen und der Struktur der
Antworten vertraut machen. Auf alle wichtigen Einträge zur REST-API
können Sie in der Checkmk-Weboberfläche über die Navigationsleiste im
Menü [Help \> Developer resources]{.guihint} zugreifen.
:::

::: paragraph
Schließlich finden Sie im Artikel zur REST-API
[Beispiele,](rest_api.html#examples) wie Sie auf der Kommandozeile
Aktionen für Hosts und Ordner ausführen können, z.B. die Ordnerstruktur
und die Hosts eines Ordners anzeigen, einen Host in einem bestimmten
Ordner erstellen und vieles mehr.
:::
:::::::
::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}11. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~/e                      | In diesem Verzeichnis wird die           |
| tc/check_mk/conf.d/wato/` | Ordnerstruktur im Setup unterhalb des    |
|                           | Ordners [Main]{.guihint} durch eine      |
|                           | Unterverzeichnisstruktur abgebildet.     |
|                           | Wird in der GUI ein Ordner angelegt,     |
|                           | wird im Dateisystem auch ein neues       |
|                           | Verzeichnis erstellt. Dabei sorgt        |
|                           | Checkmk dafür, dass die Namen der        |
|                           | Verzeichnisse eindeutig sind und nur     |
|                           | Zeichen verwendet werden, die im         |
|                           | Dateisystem erlaubt sind. So wird etwa   |
|                           | ein Leerzeichen durch einen Unterstrich  |
|                           | ersetzt.                                 |
+---------------------------+------------------------------------------+
| `~/etc/check              | Konfigurationsdatei für alle Hosts im    |
| _mk/conf.d/wato/hosts.mk` | Ordner [Main.]{.guihint} Für Hosts in    |
|                           | Unterordnern von [Main]{.guihint} gibt   |
|                           | es jeweils eine gleichnamige Datei in    |
|                           | den zugehörigen Unterverzeichnissen.     |
+---------------------------+------------------------------------------+
| `~/etc/ch                 | Diese versteckte Datei enthält den       |
| eck_mk/conf.d/wato/.wato` | Anzeigenamen in der GUI                  |
|                           | ([Main]{.guihint}) und alle weiteren     |
|                           | Eigenschaften dieses Verzeichnisses.     |
|                           | Eine Datei `.wato` existiert in jedem    |
|                           | Unterverzeichnis. Wird ein Ordner in der |
|                           | GUI umbenannt, wird in dieser Datei nur  |
|                           | der Parameter `title` für den            |
|                           | Anzeigenamen geändert. Der Name des      |
|                           | Verzeichnisses im Dateisystem bleibt     |
|                           | unverändert.                             |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
