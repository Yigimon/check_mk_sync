:::: {#header}
# Glossar

::: details
[Last modified on 28-Nov-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/glossar.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_checkmk_spezifische_begriffe .hidden-anchor .sr-only}1. Checkmk-spezifische Begriffe {#heading__checkmk_spezifische_begriffe}

::::: sect3
#### []{#agent .hidden-anchor .sr-only}Agent {#heading_agent}

::: paragraph
Ein Agent sammelt die für das Monitoring relevanten Daten von einem Host
ein. Das kann ein kleines, auf dem Host installiertes Programm sein (der
Checkmk-Agent), ein unabhängig von Checkmk auf dem Host laufender
SNMP-Agent, ein Spezialagent, der sich die Informationen über eine vom
Zielsystem bereitgestellte API besorgt --- oder ein aktiver Check, der
netzwerkbasierte Dienste abfragt.
:::

::: paragraph
Mehr unter [Monitoring-Agenten.](wato_monitoringagents.html)
:::
:::::

::::: sect3
#### []{#agent_updater .hidden-anchor .sr-only}Agent Updater {#heading_agent_updater}

::: paragraph
Der Agent Updater ist ein Agentenplugin in den kommerziellen Editionen,
das die automatischen Aktualisierungen der Agenten ermöglicht.
:::

::: paragraph
Mehr unter [Automatische Agenten-Updates.](agent_deployment.html)
:::
:::::

::::: sect3
#### []{#agent_bakery .hidden-anchor .sr-only}Agentenbäckerei {#heading_agent_bakery}

::: paragraph
Mit der Agentenbäckerei (englisch: *agent bakery*) können Agenten in den
kommerziellen Editionen individuell paketiert und optional auch
automatisch verteilt werden.
:::

::: paragraph
Mehr unter [Die Agentenbäckerei.](wato_monitoringagents.html#bakery)
:::
:::::

::::: sect3
#### []{#agent_plugin .hidden-anchor .sr-only}Agentenplugin {#heading_agent_plugin}

::: paragraph
Ein Agentenplugin erweitert die Funktionen des standardmäßig
ausgelieferten Checkmk-Agenten. Es ist ein kleines Programm oder Skript,
das vom Checkmk-Agenten aufgerufen wird und die Ausgabe des Agenten um
weitere Sektionen mit zusätzlichen Monitoring-Daten anreichert. Ein
Beispiel für ein Agentenplugin ist der Agent Updater.
:::

::: paragraph
Mehr unter [Agent um Plugins erweitern.](agent_linux.html#plugins)
:::
:::::

::::: sect3
#### []{#active_check .hidden-anchor .sr-only}Aktiver Check {#heading_active_check}

::: paragraph
Ein aktiver Check ist ein kleines Programm oder Skript, das eine direkte
Verbindung zu einem Dienst im Netzwerk oder Internet aufbaut und von
dort die Monitoring-Daten abfragt. Aktive Checks werden für
netzwerkbasierte Dienste wie HTTP, SMTP oder IMAP genutzt, z.B.
`check_http` für das Abfragen von Webseiten. Ein aktiver Check kümmert
sich sowohl um die Erhebung als auch um die Auswertung der Daten. Im
Gegensatz dazu wird ein Check-Plugin manchmal auch als passiver Check
bezeichnet, da es nur vorhandene Daten auswertet.
:::

::: paragraph
Mehr unter [Netzwerkdienste überwachen (Aktive
Checks).](active_checks.html)
:::
:::::

::::: sect3
#### []{#activate_changes .hidden-anchor .sr-only}Änderungen aktivieren {#heading_activate_changes}

::: paragraph
Änderungen an der Konfiguration wirken sich erst auf das Monitoring aus,
nachdem sie in einem zweiten Schritt aktiviert wurden; ähnlich, wie es
zum Beispiel Partitionierungsprogramme handhaben: Konfigurieren, prüfen,
anwenden.
:::

::: paragraph
Mehr unter [Änderungen aktivieren.](wato.html#activate_changes)
:::
:::::

::::: sect3
#### []{#api_integrations .hidden-anchor .sr-only}API-Integrationen {#heading_api_integrations}

::: paragraph
Wenn im Setup von Checkmk von [API integrations]{.guihint} die Rede ist,
sind Monitoring-Daten gemeint, die zwar das Datenformat des
Checkmk-Agenten nutzen, aber aus einer anderen Quelle stammen. Solche
Quellen können Datenquellenprogramme, Spezialagenten oder Hosts sein,
die ihre Daten per Piggyback (huckepack) liefern. Sollen per
API-Integration empfangene Daten im Monitoring verwendet werden, muss in
den Eigenschaften eines Hosts [API integrations]{.guihint} aktiviert
sein.
:::

::: paragraph
Mehr unter [Datenquellenprogramme.](datasource_programs.html)
:::
:::::

::::: sect3
#### []{#automation_user .hidden-anchor .sr-only}Automationsbenutzer {#heading_automation_user}

::: paragraph
Spezielles Konto für die Abfrage und Konfiguration von Checkmk abseits
der Weboberfläche, also zum Beispiel über API, Kommandozeile, Skript
oder Webdienst. Ein Automationsbenutzer hat standardmäßig ein zufällig
ausgewürfeltes Automationspasswort (englisch *automation secret*). In
einer frischen Checkmk-Instanz sind mehrere Automationsbenutzer bereits
eingerichtet, z. B. für Webdienste und für die Registrierung des Agenten
beim Checkmk-Server zur TLS-verschlüsselten Datenübertragung.
:::

::: paragraph
Mehr unter [Automationsbenutzer (für
Webdienste).](wato_user.html#automation)
:::
:::::

::::: sect3
#### []{#notification .hidden-anchor .sr-only}Benachrichtigung {#heading_notification}

::: paragraph
Mit einer Benachrichtigung (englisch: *notification*) wird ein
Checkmk-Benutzer über Probleme oder andere Monitoring-Ereignisse aktiv
informiert, per HTML-E-Mail, SMS, Slack oder ähnlichem. Wer wie
benachrichtigt wird, legen die Benachrichtigungsregeln fest. Wenn zum
Beispiel Herr Hirsch eine E-Mail mit der Information erhält, dass der
Service `Filesystem /` auf dem Host `myserver123` von [WARN]{.state1}
nach [CRIT]{.state2} gewechselt ist, dann deshalb, weil Herr Hirsch
Kontakt für diesen Host ist und in einer Benachrichtigungsregel steht,
dass alle Kontakte des Hosts eine E-Mail erhalten sollen, wenn einer
seiner Services nach [CRIT]{.state2} wechselt.
:::

::: paragraph
Mehr unter [Benachrichtigungen.](notifications.html)
:::
:::::

::::: sect3
#### []{#bi .hidden-anchor .sr-only}Business Intelligence (BI) {#heading_bi}

::: paragraph
Business Intelligence in Checkmk ermöglicht es, aus vielen einzelnen
Statuswerten den Gesamtzustand einer übergeordneten Ebene abzuleiten und
übersichtlich darzustellen. Das kann die abstrakte Gruppierung einzelner
Komponenten oder eine geschäftskritische Anwendung sein. So lässt sich
etwa der Zustand einer Anwendung *E-Mail,* bestehend aus diversen Hosts,
Switches und Diensten wie SMTP und IMAP, über eine einzige
Visualisierung erfassen. Auch die Formulierung gänzlich ungreifbarer und
nicht-technischer Belange ist hier möglich, zum Beispiel die
termingerechte Verfügbarkeit eines auszuliefernden Produkts: Dieses Ziel
liegt in der Zukunft und hängt von vielen Aspekten ab, der Supply Chain,
einem funktionierenden Maschinenpark, verfügbarem Personal etc. Etwaige
Gefährdungen für dieses abstrakte Ziel ließen sich über das BI-Modul
erfassen.
:::

::: paragraph
Mehr unter [Business Intelligence (BI).](bi.html)
:::
:::::

::::: sect3
#### []{#check .hidden-anchor .sr-only}Check {#heading_check}

::: paragraph
Ein Check im Sinne von Checkmk ist ein Skript oder Programm, das einen
Host oder Service gemäß erstellter Regeln prüft, also der Vorgang, der
den Status von Hosts und Services bestimmt und zu einem der folgenden
Ergebnisse führt: [OK]{.state0}, [DOWN]{.hstate1}, [UNREACH]{.hstate2},
[WARN]{.state1}, [CRIT]{.state2}, [PEND]{.statep} oder
[UNKNOWN]{.state3}. Checks können zum Beispiel mit einem Check-Plugin,
lokalen Check oder aktiven Check implementiert werden.
:::

::: paragraph
Mehr unter [Checks.](monitoring_basics.html#checks)
:::
:::::

::::: sect3
#### []{#check_plugin .hidden-anchor .sr-only}Check-Plugin {#heading_check_plugin}

::: paragraph
Check-Plugins sind in Python geschriebene Module, die auf der
Checkmk-Instanz ausgeführt werden und die Services eines Hosts erstellen
und auswerten. Ein Beispiel: Das Check-Plugin *df*, zu finden innerhalb
einer Instanz unter
`~/local/lib/python3/cmk_addons/plugins/<plug-in_family>/agent_based/`
(bei Nutzung der Check-API V2) oder
`~/local/lib/check_mk/base/plugins/agent_based/` (bei Nutzung der
Check-API V1), erstellt aus den Daten eines Agenten in der Instanz
Services für die vorhandenen eingebundenen Dateisysteme eines Hosts und
überprüft diese Services anhand der Daten, also etwa wie viel freien
Speicherplatz es noch gibt.
:::

::: paragraph
[Mehr über Check-Plugins.](wato_services.html#checkplugins)
:::
:::::

::::: sect3
#### []{#mkp .hidden-anchor .sr-only}Checkmk-Erweiterungspaket (MKP) {#heading_mkp}

::: paragraph
MKP ist das Checkmk-eigene Dateiformat zum Zusammenfassen und Verteilen
von Erweiterungen, also eigenen Check-Plugins, Agentenplugins,
Zeitreihen-Graph-Definitionen, Benachrichtigungsskripten,
Tabellenansichten, Dashboards und so weiter.
:::

::: paragraph
Mehr unter [Checkmk-Erweiterungspakete (MKPs).](mkps.html)
:::
:::::

::::: sect3
#### []{#dashboard .hidden-anchor .sr-only}Dashboard {#heading_dashboard}

::: paragraph
Ein Dashboard ist eine frei konfigurierbare Übersicht, bestehend aus
Tabellenansichten und/oder so genannten Dashboard-Elementen (englisch:
*dashlet*). Diese Elemente gibt es zum Beispiel in Form von Listen (etwa
Host-Probleme), Zeitreihen-Graphen oder kleinen Tachometern, die
einzelne Werte wie etwa eine CPU-Temperatur visualisieren.
:::

::: paragraph
Mehr unter [Dashboards.](dashboards.html)
:::
:::::

::::: sect3
#### []{#edition .hidden-anchor .sr-only}Edition {#heading_edition}

::: paragraph
Checkmk-Editionen sind die unterschiedlichen Software-Varianten von
Checkmk, die geladen und installiert werden können. Also die Open Source
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw**, für professionelle Anwender die per Subskription
erhältliche
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise**, die darauf aufbauende
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** sowie die mandantenfähige
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP**. In dieser Reihenfolge enthält jede Edition den
kompletten Funktionsumfang der vorher genannten Edition --- und
erweitert diesen um spezifische Zusatzfunktionen. So ist zum Beispiel
Checkmk Cloud eine für Cloud-Umgebungen ausgebaute und optimierte
Checkmk Enterprise.
:::

::: paragraph
Mehr unter [Edition auswählen.](intro_setup.html)
:::
:::::

::::: sect3
#### []{#ec .hidden-anchor .sr-only}Event Console (EC) {#heading_ec}

::: paragraph
Bei der Überwachung von Hosts und Services geht es in Checkmk um
*Zustände.* Die Event Console ist das Modul, das sich im Gegensatz dazu
um *Ereignisse* kümmert, also die Überwachung aus Quellen wie Syslog
oder SNMP-Traps, aber optional auch Windows Event Log, Log-Dateien und
eigenen Anwendungen. Ein Beispiel: Eine Warnmeldung des SMTP-Dienstes
auf einem Mailserver würde weder den Status/Zustand von dessen Host noch
Services ändern --- dennoch ist es eine relevante Information, die ins
Monitoring gehört. Mit der Event Console können solche Ereignisse in
Checkmk dargestellt werden.
:::

::: paragraph
Mehr unter [Die Event Console.](ec.html)
:::
:::::

:::: sect3
#### []{#_flapping .hidden-anchor .sr-only}Flapping {#heading__flapping}

::: paragraph
Siehe [Unstetig.](#flapping)
:::
::::

:::::: sect3
#### []{#host .hidden-anchor .sr-only}Host {#heading_host}

::: paragraph
Ein Host im Sinne von Checkmk ist jedes eigenständige, physische oder
virtuelle System, das von Checkmk überwacht wird. In der Regel handelt
es sich um Dinge mit eigener IP-Adresse (Server, Switches, SNMP-Geräte,
virtuelle Maschinen), aber auch um beispielsweise Docker Container oder
andere logische Objekte ohne eine solche Adresse. Jeder Host hat immer
einen der Zustände [UP]{.hstate0}, [DOWN]{.hstate1}, [UNREACH]{.hstate2}
oder [PEND]{.statep} und immer mindestens einen Service.
:::

::: paragraph
Noch weiter heruntergebrochen: Ein Host ist für Checkmk intern lediglich
ein Strukturierungselement, das zu überwachende Elemente beinhaltet,
also Services. Jeder Host hat zwangsläufig mindestens einen Service, um
überhaupt die Erreichbarkeit zu verifizieren (etwa [PING]{.guihint} oder
der Checkmk-Agent selbst, also der Service [Check_MK]{.guihint}).
Insofern meint Host kaum mehr als die Überschrift, unter der eine Anzahl
an Services gruppiert ist.
:::

::: paragraph
Mehr unter [Verwaltung der Hosts.](hosts_setup.html)
:::
::::::

::::: sect3
#### []{#host_group .hidden-anchor .sr-only}Host-Gruppe {#heading_host_group}

::: paragraph
Hosts werden in Checkmk primär über Ordner verwaltet. Host-Gruppen
ermöglichen eine andere Gruppierung von Hosts, um Hosts im Monitoring
z.B. in Tabellenansichten auswählen zu können. Host-Merkmale, Labels und
Ordner werden genutzt, um Hosts über Regeln solchen Gruppen zuzuordnen.
Hosts können aber auch explizit einer Host-Gruppe zugeordnet werden.
:::

::: paragraph
Mehr unter [Host-Gruppen](hosts_structure.html#host_groups)
:::
:::::

::::: sect3
#### []{#host_tag .hidden-anchor .sr-only}Host-Merkmal {#heading_host_tag}

::: paragraph
Host-Merkmale (englisch: *host tags*) sind Kennzeichen, die Hosts
zugeordnet werden können, um diese in der Konfiguration für Regeln oder
später im Monitoring für Tabellenansichten gezielt ansprechen zu können.
Host-Merkmale sind in Gruppen eingeteilt, beispielsweise lässt sich eine
Merkmalsgruppe *Betriebssysteme* mit den Merkmalen *Linux* und *Windows*
einrichten. Einige Merkmalsgruppen sind bereits vordefiniert, etwa zur
Art des verwendeten Checkmk-Agenten oder zur IP-Adressfamilie, über die
festgehalten wird, ob ein Host über IPv4, IPv6 oder beide Versionen
überwacht werden soll. Sie haben außerdem vorher festgelegte Werte und
einen Standard, welcher jedem Host zugeordnet ist, solange er nicht mit
einer anderen Option aus der Gruppe überschrieben wurde.
:::

::: paragraph
Mehr unter [Host-Merkmale.](host_tags.html)
:::
:::::

::::: sect3
#### []{#host_state .hidden-anchor .sr-only}Host-Zustand {#heading_host_state}

::: paragraph
Der Zustand eines Hosts, also ob dieser über das Netz erreichbar ist
([UP]{.hstate0}), nicht auf Anfragen aus dem Netz antwortet
([DOWN]{.hstate1}) oder ob der Weg durch ausgefallene
zwischengeschaltete Geräte (Switches, Router etc.) versperrt ist
([UNREACH]{.hstate2}). Für frisch ins Monitoring aufgenommene, noch nie
abgefragte Hosts gibt es zudem den Zustand [PEND]{.statep}, welcher aber
kein Status im eigentlichen Sinne ist.
:::

::: paragraph
Mehr unter [Hosts und Services.](monitoring_basics.html#hosts_services)
:::
:::::

::::: sect3
#### []{#site .hidden-anchor .sr-only}Instanz {#heading_site}

::: paragraph
Instanz (englisch: *site*) nennt sich **ein** laufendes
Checkmk-Monitoring-Projekt. Checkmk lässt sich parallel auf demselben
Server in mehreren, unabhängigen Instanzen betreiben, um beispielsweise
unterschiedliche Checkmk-Versionen oder -Editionen auszuprobieren oder
ein separates Monitoring für (neue) Hosts zu betreiben, die (noch) nicht
ins produktive Monitoring aufgenommen werden sollen.
:::

::: paragraph
Mehr unter [Eine Instanz erstellen.](omd_basics.html#omd_create)
:::
:::::

::::: sect3
#### []{#configuration_environment .hidden-anchor .sr-only}Konfigurationsumgebung {#heading_configuration_environment}

::: paragraph
Die Checkmk-Weboberfläche teilt sich auf in Monitoring- und
Konfigurationsumgebung. Letztere bezeichnet die Bereiche, in denen
Regeln gebaut, Host und Services hinzugefügt und eingestellt, Benutzer
verwaltet oder generelle Optionen gesetzt werden. Zur
Konfigurationsumgebung geht es über das [Setup]{.guihint}-Menü in der
Navigationsleiste.
:::

::: paragraph
Mehr unter [Die Benutzeroberfläche.](user_interface.html)
:::
:::::

::::: sect3
#### []{#contact .hidden-anchor .sr-only}Kontakt {#heading_contact}

::: paragraph
Kontakte werden Checkmk-Benutzer genannt, die für bestimmte Hosts und
Services zuständig sind. Die Zuordnung von Kontakten zu Hosts und
Service geschieht über Kontaktgruppen. Kontakte können auch
Benutzerkonten sein, die rein für die Benachrichtigungen existieren,
beispielsweise für die Weiterleitung an ein Ticketsystem.
:::

::: paragraph
Mehr unter [Kontaktgruppen.](wato_user.html#contact_groups)
:::
:::::

::::: sect3
#### []{#label .hidden-anchor .sr-only}Label {#heading_label}

::: paragraph
Hosts können mit vordefinierten Host-Merkmalen, aber auch mit direkten
Kennzeichen, den Labels, versehen werden. Ein Label besteht aus zwei
Teilen (Schlüssel und Wert), getrennt durch einen Doppelpunkt. Solche
beliebigen Schlüssel-Wert-Paare (`os:linux`, `os:windows`, `foo:bar`
etc.) können bei einem Host direkt gesetzt werden --- ohne jede
vorherige Konfiguration, wie es bei den Host-Merkmalen nötig ist. Labels
verfügen daher über keinen vorher definierten Umfang und haben auch
keinen Standardwert, sind dafür aber sehr dynamisch. Insbesondere kann
Checkmk von Containersystemen wie Kubernetes, Azure oder AWS automatisch
erzeugte Objekte selbständig als Hosts ins Monitoring übernehmen und
diese dann mit automatisch aus deren Metadaten generierten Labels
anreichern. Label lassen sich z. B. für die Auswahl von Bedingungen in
Regeln oder im Monitoring für die Filterung in Tabellenansichten nutzen.
:::

::: paragraph
Mehr unter [Labels.](labels.html)
:::
:::::

::::: sect3
#### []{#livestatus .hidden-anchor .sr-only}Livestatus {#heading_livestatus}

::: paragraph
Livestatus ist die wichtigste Schnittstelle in Checkmk. Durch sie
bekommen Checkmk-Benutzer schnellstmöglich und live Zugriff auf alle
Daten der überwachten Hosts und Services. So werden z.B. die Daten im
Snapin [Overview]{.guihint} direkt über diese Schnittstelle abgerufen.
Dass die Daten direkt aus dem RAM geholt werden, vermeidet langsame
Festplattenzugriffe und gibt einen schnellen Zugriff auf das Monitoring,
ohne das System zu sehr zu belasten.
:::

::: paragraph
Mehr unter [Statusdaten abrufen via Livestatus.](livestatus.html)
:::
:::::

::::: sect3
#### []{#local_check .hidden-anchor .sr-only}Lokaler Check {#heading_local_check}

::: paragraph
Ein lokaler Check ist eine (selbst geschriebene) Erweiterung, die in
Form eines Skripts in einer beliebigen Sprache auf dem überwachten Host
läuft. Im Gegensatz zu normalen Checks läuft die Statusberechnung direkt
auf dem Host. Die Ergebnisse werden der regulären Agentenausgabe
hinzugefügt.
:::

::: paragraph
Mehr unter [Lokale Checks.](localchecks.html)
:::
:::::

::::: sect3
#### []{#metric .hidden-anchor .sr-only}Metrik {#heading_metric}

::: paragraph
Mess- und berechenbare Werte zu Hosts und Services in ihrem zeitlichen
Verlauf, etwa Temperatur, Auslastung oder Verfügbarkeit, die
beispielsweise für Graphen herangezogen werden können. Vergangene Werte
werden in RRDs (Round-Robin-Datenbank) gespeichert und halten diese in
der Standardeinstellung bis zu 4 Jahre vor.
:::

::: paragraph
Mehr unter [Messwerte und Graphing.](graphing.html)
:::
:::::

::::: sect3
#### []{#monitoring_environment .hidden-anchor .sr-only}Monitoring-Umgebung {#heading_monitoring_environment}

::: paragraph
Die Checkmk-Weboberfläche teilt sich auf in Monitoring- und
Konfigurationsumgebung. Erstere bezeichnet die Bereiche, in denen der
Status der überwachten Infrastruktur angezeigt wird; dazu zählen etwa
das Inventar, Dashboards, Listen mit Hosts, Services, Ereignissen oder
Problemen, historische Daten und so weiter. Zur Monitoring-Umgebung geht
es über das [Monitor]{.guihint}-Menü in der Navigationsleiste.
:::

::: paragraph
Mehr unter [Die Benutzeroberfläche.](user_interface.html)
:::
:::::

::::: sect3
#### []{#navigation_bar .hidden-anchor .sr-only}Navigationsleiste {#heading_navigation_bar}

::: paragraph
Die Navigationsleiste ist die Hauptnavigation der Checkmk-Oberfläche,
auf der linken Seite u.a. mit den Menüs [Monitor,]{.guihint}
[Setup]{.guihint} und [Customize.]{.guihint}
:::

::: paragraph
Mehr unter [Navigationsleiste.](user_interface.html#navigation_bar)
:::
:::::

::::: sect3
#### []{#physical_appliance .hidden-anchor .sr-only}Physische Appliance {#heading_physical_appliance}

::: paragraph
Die physische Appliance ist ein 19\"-Server mit einer vorinstallierten,
für Checkmk vorbereiteten Firmware, der sofort in Rechenzentren
eingesetzt werden kann. Sie kommt mit einer grafischen
Konfigurationsoberfläche, die jegliche Linux-Kenntnisse überflüssig
macht.
:::

::: paragraph
Mehr unter [Physische Appliance.](intro_setup.html#physical_appliance)
:::
:::::

::::: sect3
#### []{#piggyback .hidden-anchor .sr-only}Piggyback {#heading_piggyback}

::: paragraph
Manche Hosts im Monitoring werden nicht direkt abgefragt, weil es sich
nicht um physischen Geräte, sondern virtuelle Maschinen oder Container
handelt, oder die Daten nur von einem Drittsystem bereitgestellt werden
können. Diese Drittsysteme (die physischen Gastgeber) liefern die Daten
quasi als Anhang in ihrer eigenen Agentenausgabe mit. Ein Docker-Server
würde also zum Beispiel neben den eigenen Daten die Daten der Container
huckepack (englisch: *piggyback*) mitliefern.
:::

::: paragraph
Mehr unter [Der Piggyback-Mechanismus.](piggyback.html)
:::
:::::

::::: sect3
#### []{#pull_mode .hidden-anchor .sr-only}Pull-Modus {#heading_pull_mode}

::: paragraph
Im Pull-Modus lauscht der Checkmk-Agent am TCP-Port 6556 auf eingehende
Verbindungen vom Checkmk-Server. Sobald der Agent eine Aufforderung
erhält, schickt er die Monitoring-Daten an den Server. Hier geht die
Initiative zur Datenübertragung vom Server aus, der die Daten vom
Agenten quasi heran*zieht*. Der Pull-Modus ist der Standardweg zur
Datenübertragung vom Checkmk-Agenten --- und funktioniert in allen
Checkmk-Editionen.
:::

::: paragraph
Mehr unter [Der Checkmk-Agent.](wato_monitoringagents.html#agents)
:::
:::::

::::: sect3
#### []{#push_mode .hidden-anchor .sr-only}Push-Modus {#heading_push_mode}

::: paragraph
Im Push-Modus sendet der Checkmk-Agent minütlich die Monitoring-Daten an
den Checkmk-Server. Der Agent *stößt* also die Datenübertragung von sich
aus an und wartet nicht auf eine Aufforderung des Servers. Der
Push-Modus ist immer dann erforderlich, wenn der Checkmk-Server nicht
auf das Netzwerk zugreifen kann, in dem sich der zu überwachende Host
mit seinem Agenten befindet, also z.B. in einer Cloud-basierte
Konfiguration. Daher gibt es den Push-Modus nur ab
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud**, d. h. für Checkmk Cloud und Checkmk MSP.
:::

::: paragraph
Mehr unter [Der Checkmk-Agent.](wato_monitoringagents.html#agents)
:::
:::::

::::: sect3
#### []{#rule .hidden-anchor .sr-only}Regel {#heading_rule}

::: paragraph
Regeln sind die Grundlage der Konfiguration von Hosts und Services in
Checkmk. Regeln in einem Regelsatz steuern immer einen einzelnen,
fokussierten Aspekt eines Hosts oder Services. Sie lassen sich mit
Bedingungen versehen, sowie innerhalb eines Regelsatzes beliebig
aufeinander \"stapeln\". Die Auswertung erfolgt dann von oben nach
unten, so dass es Standardregeln geben kann, wenn keine Bedingung
greift, aber auch sehr spezielle Regeln, die nur einen ganz bestimmten
Host betreffen. Viele Regelsätze in Checkmk haben bereits vordefinierte
Standardwerte, so dass nur für abweichende Anforderungen Regeln erstellt
werden müssen.
:::

::: paragraph
Mehr unter [Regeln.](wato_rules.html)
:::
:::::

::::: sect3
#### []{#rule_set .hidden-anchor .sr-only}Regelsatz {#heading_rule_set}

::: paragraph
Ein Regelsatz steht für einen bestimmten Aspekt eines Hosts oder
Services, beispielsweise die Schwellwerte der CPU-Auslastung. In jedem
Regelsatz können beliebig viele einzelne Regeln erstellt werden. So
könnte etwa der Regelsatz [CPU utilization on Linux/UNIX]{.guihint} zwei
Regeln enthalten, die den Service auf bestimmten Hosts bei 90 Prozent
und auf anderen schon bei 70 Prozent auf den Status [WARN]{.state1}
setzen.
:::

::: paragraph
Mehr unter [Arten von Regelsätzen.](wato_rules.html#rule_set_types)
:::
:::::

::::: sect3
#### []{#sidebar .hidden-anchor .sr-only}Seitenleiste {#heading_sidebar}

::: paragraph
Die Seitenleiste (englisch: *sidebar*) lässt sich aus der
Navigationsleiste per Mausklick einblenden. In die Seitenleiste können
Benutzer diverse Snapins aufnehmen, die die Navigation erleichtern oder
wichtige Statusdaten auf einen Blick zeigen.
:::

::: paragraph
Mehr unter [Seitenleiste.](user_interface.html#sidebar)
:::
:::::

::::: sect3
#### []{#service .hidden-anchor .sr-only}Service {#heading_service}

::: paragraph
Ein Service ist ein logisches Objekt, welches einen oder mehrere
Teilaspekte eines Hosts zusammenfasst. Also beispielsweise Größe,
Auslastung und Trends von Dateisystemen, CPU-Auslastung, Temperaturen,
Alter und Anzahl laufender Programme, Ports, Sensoren und so weiter.
Jeder Service im Monitoring hat zu jedem Zeitpunkt einen der Zustände
[OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2}, [UNKNOWN]{.state3} oder
[PEND]{.statep}, ist immer genau einem Host zugeordnet und enthält
optional eine oder mehrere Metriken.
:::

::: paragraph
Mehr unter [Services verstehen und konfigurieren.](wato_services.html)
:::
:::::

::::: sect3
#### []{#service_discovery .hidden-anchor .sr-only}Service-Erkennung {#heading_service_discovery}

::: paragraph
Sobald ein Host dem Monitoring hinzugefügt wird, erkennt Checkmk
automatisch alle verfügbaren Services, die ins Monitoring aufgenommen
werden können --- und hält diese Liste auch im laufenden Betrieb stets
aktuell. Die Service-Erkennung (englisch: *service discovery*) lässt
sich aber auch jederzeit manuell über die Konfiguration eines Hosts
starten.
:::

::: paragraph
Mehr unter [Services verstehen und konfigurieren.](wato_services.html)
:::
:::::

::::: sect3
#### []{#service_group .hidden-anchor .sr-only}Service-Gruppe {#heading_service_group}

::: paragraph
Analog zu den Hosts lassen sich auch Services in Gruppen zusammenfassen,
um diese Gruppen später in Tabellenansichten zu filtern oder in der
Konfiguration gezielt anzusprechen. Gruppieren lässt sich nach Ordnern,
Host-Merkmalen, Host- und Service-Labels sowie via regulären Ausdrücken
gefilterten Host- und Service-Namen.
:::

::: paragraph
Mehr unter [Service-Gruppen.](wato_services.html#service_groups)
:::
:::::

::::: sect3
#### []{#service_state .hidden-anchor .sr-only}Service-Zustand {#heading_service_state}

::: paragraph
Der Service-Zustand ist immer [OK]{.state0} [WARN]{.state1},
[CRIT]{.state2} oder [UNKNOWN]{.state3} und beschreibt, in welchem
Zustand sich der Service aktuell befindet --- gemäß den gesetzten
Regeln. Für frisch ins Monitoring aufgenommene, noch nie abgefragte
Services gibt es zudem den Zustand [PEND]{.statep}, welcher aber kein
Status im eigentlichen Sinne ist.
:::

::: paragraph
Mehr unter [Services.](monitoring_basics.html#services)
:::
:::::

::::: sect3
#### []{#snapin .hidden-anchor .sr-only}Snapin {#heading_snapin}

::: paragraph
Snapins, auch Seitenleistenelemente genannt, sind die einzelnen
Bausteine, die sich in der Seitenleiste platzieren lassen,
beispielsweise [Overview]{.guihint} und [Master control.]{.guihint}
Zugriff auf die Snapins liefert das Plus-Symbol unten in der
Seitenleiste.
:::

::: paragraph
Mehr unter [Seitenleiste.](user_interface.html#sidebar)
:::
:::::

::::: sect3
#### []{#snmp .hidden-anchor .sr-only}SNMP {#heading_snmp}

::: paragraph
Das „Simple Network Management Protocol" dient der Überwachung und
Konfiguration von Netzwerkgeräten wie Routern, Switches oder Firewalls.
Checkmk unterstützt dieses Protokoll --- da es aber vergleichsweise
ineffizient ist, sollten Sie SNMP nur bei Geräten einsetzen, die keine
besseren Möglichkeiten zur Überwachung anbieten, wie beispielsweise
Spezialagenten.
:::

::: paragraph
Mehr unter [SNMP.](snmp.html)
:::
:::::

::::: sect3
#### []{#special_agent .hidden-anchor .sr-only}Spezialagent {#heading_special_agent}

::: paragraph
Auf einigen Systemen lässt sich der reguläre Checkmk-Agent nicht
installieren und SNMP steht nicht (befriedigend) zur Verfügung.
Stattdessen bieten diese Systeme Management-APIs, die auf Telnet, SSH
oder HTTP/XML basieren. Über einen Spezialagenten, der auf dem
Checkmk-Server läuft, fragt Checkmk diese Schnittstellen ab, womit der
Host per API in Checkmk integriert wird.
:::

::: paragraph
Mehr unter [Spezialagenten.](datasource_programs.html#specialagents)
:::
:::::

::::: sect3
#### []{#view .hidden-anchor .sr-only}Tabellenansicht {#heading_view}

::: paragraph
Neben den Dashboards sind die Tabellenansichten (englisch: *views*) die
in der Checkmk-Oberfläche am häufigsten genutzten Darstellungen von
Hosts, Services und anderen Objekten. Diese werden als Tabellen mit den
im aktuellen Kontext relevanten Attributen angezeigt. Zum Beispiel sind
[All hosts]{.guihint} und [Host problems]{.guihint} Tabellenansichten im
Monitoring. Mitgelieferte Tabellenansichten können in ihrer Anzeige
angepasst werden, und sie können als Basis für neue Ansichten dienen. Es
ist auch möglich, Tabellenansichten komplett neu zu erstellen.
:::

::: paragraph
Mehr unter [Ansichten von Hosts und Services (Views).](views.html)
:::
:::::

::::: sect3
#### []{#flapping .hidden-anchor .sr-only}Unstetig {#heading_flapping}

::: paragraph
Wenn ein Objekt (Host oder Service) in kurzer Zeit mehrfach den Zustand
ändert, gilt es als unstetig (englisch: *flapping*) und wird mit dem
Symbol [![Symbol zur Anzeige des unstetigen
Zustands.](../images/icons/icon_flapping.png)]{.image-inline} markiert.
Für ein unstetiges Objekt wird bei weiteren Zustandswechseln keine
Benachrichtigung mehr versendet. Die Erkennung von Unstetigkeiten
(englisch: *flap detection*) kann ab- oder eingeschaltet
werden --- global oder per Regel, getrennt für Hosts und Services.
:::

::: paragraph
Mehr unter [Unstetige Hosts und Services.](notifications.html#flapping)
:::
:::::

::::: sect3
#### []{#distributed_monitoring .hidden-anchor .sr-only}Verteiltes Monitoring {#heading_distributed_monitoring}

::: paragraph
Checkmk unterscheidet zwischen verteiltem Monitoring und einem
verteilten Setup. Verteiltes Monitoring bedeutet, dass das gesamte
Monitoring-System aus mehr als einer Checkmk-Instanz besteht und die
Daten an einer Stelle zusammen angezeigt werden. Oder anders: Das
Monitoring besteht dann aus einer Zentralinstanz und mindestens einer
Remote-Instanz und die Daten der Remote-Instanz werden auch in der
Zentrale angezeigt. Ein verteiltes Monitoring kann optional mit einem
verteilten Setup kombiniert werden.
:::

::: paragraph
Mehr unter [Zentraler
Status.](distributed_monitoring.html#central_status)
:::
:::::

::::: sect3
#### []{#distributed_setup .hidden-anchor .sr-only}Verteiltes Setup {#heading_distributed_setup}

::: paragraph
Checkmk unterscheidet zwischen verteiltem Monitoring und einem
verteilten Setup. Verteiltes Setup bedeutet, dass das gesamte
Monitoring-System aus mehr als einer Checkmk-Instanz besteht und die
Konfiguration an einer einzigen Stelle vorgenommen wird. Oder anders:
Das Monitoring besteht dann aus einer Zentralinstanz und mindestens
einer Remote-Instanz und die Konfiguration der Remote-Instanz kommt aus
der Zentrale. Ein Verteiltes Setup beinhaltet immer auch ein verteiltes
Monitoring.
:::

::: paragraph
Mehr unter [Zentrale
Konfiguration.](distributed_monitoring.html#distr_wato)
:::
:::::

::::: sect3
#### []{#virtual_appliance .hidden-anchor .sr-only}Virtuelle Appliance {#heading_virtual_appliance}

::: paragraph
Die virtuelle Appliance ist ein für VirtualBox oder VMware ESXi
erstelltes System mit einer vorinstallierten, für Checkmk vorbereiteten
Firmware. Sie beinhaltet eine grafischen Konfigurationsoberfläche, die
jegliche Linux-Kenntnisse überflüssig macht.
:::

::: paragraph
Mehr unter [Virtuelle Appliance.](intro_setup.html#virtual_appliance)
:::
:::::

::::: sect3
#### []{#scheduled_downtime .hidden-anchor .sr-only}Wartungszeit {#heading_scheduled_downtime}

::: paragraph
Wartungszeiten (englisch: *scheduled downtimes*) sind geplante Ausfälle,
etwa für Aktualisierungen bestimmter Hosts. Wartungszeiten setzen
beispielsweise die Benachrichtigungen temporär außer Kraft, werden bei
der Verfügbarkeitsberechnung extra berücksichtigt und sorgen dafür, dass
zugehörige Hosts und Services zeitweilig nicht als Probleme auftauchen.
:::

::: paragraph
Mehr unter [Wartungszeiten.](basics_downtimes.html)
:::
:::::

::::: sect3
#### []{#wato .hidden-anchor .sr-only}WATO {#heading_wato}

::: paragraph
Das „Web Administration Tool" war bis zur Checkmk-Version [1.6.0]{.new}
das GUI-Werkzeug zur Konfiguration von Checkmk. Mit der Einführung von
WATO hatten Benutzer erstmals die Möglichkeit, Checkmk über eine
Weboberfläche statt über Konfigurationsdateien anzupassen. WATO wurde in
der Version [2.0.0]{.new} ersetzt durch das [Setup]{.guihint}-Menü in
der Navigationsleiste.
:::

::: paragraph
Mehr unter [Setup-Menü.](wato.html#setup_menu)
:::
:::::

::::: sect3
#### []{#werk .hidden-anchor .sr-only}Werk {#heading_werk}

::: paragraph
Die Software-Entwicklung von Checkmk ist in sogenannten Werks
organisiert. Jede Änderung, Fehlerbehebung oder Neuerung, die einen
Einfluss auf die Erfahrung des Benutzers hat, wird in einem eigenen Werk
erfasst, samt Hinweisen zu Auswirkungen und etwaigen Inkompatibilitäten.
Die Liste der Werks gibt es direkt in Checkmk über das
[Help]{.guihint}-Menü in der Navigationsleiste und auf der
Checkmk-Homepage.
:::

::: paragraph
Mehr unter [Werks.](https://checkmk.com/de/werks){target="_blank"}
:::
:::::

::::: sect3
#### []{#time_period .hidden-anchor .sr-only}Zeitperiode {#heading_time_period}

::: paragraph
In Checkmk lassen sich Dinge wie Benachrichtigungen,
Verfügbarkeitsberechnungen und selbst die generelle Ausführung von
Checks auf bestimmte, regelmäßig wiederkehrende Zeiträume beschränken.
Mit Zeitperioden (englisch: *time periods*) lassen sich zum Beispiel
tägliche Arbeitszeiten definieren, Urlaube und Feiertage festlegen oder
Wochenenden von Wochentagen trennen. Diese Zeitperioden können
anschließend in Regeln genutzt werden.
:::

::: paragraph
Mehr unter [Zeitperioden.](timeperiods.html)
:::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
