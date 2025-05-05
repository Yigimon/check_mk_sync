:::: {#header}
# Cluster-Services überwachen

::: details
[Last modified on 25-Jan-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/clustered_services.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Verwaltung der Hosts](hosts_setup.html) [Windows
überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_cluster_knoten_und_cluster_services .hidden-anchor .sr-only}1.1. Cluster, Knoten und Cluster-Services {#heading__cluster_knoten_und_cluster_services}

::: paragraph
Bei der Bereitstellung wichtiger und geschäftskritischer Services wie
Datenbanken oder Websites für den elektronischen Handel (*E-commerce*)
werden Sie sich kaum darauf verlassen, dass der Host, auf dem diese
Services laufen, ein langes, stabiles und absturzfreies Leben führen
wird. Stattdessen werden Sie den Ausfall eines Hosts einkalkulieren und
dafür sorgen, dass andere Hosts bereitstehen, um bei einem Ausfall die
Services unmittelbar zu übernehmen (*failover*), so dass sich der
Ausfall nach außen gar nicht bemerkbar macht.
:::

::: paragraph
Eine Gruppe von vernetzten Hosts, die zusammenarbeiten, um die gleiche
Aufgabe zu erledigen, wird als Rechnerverbund oder Computer-Cluster oder
kürzer als Cluster bezeichnet. Ein Cluster agiert nach außen als ein
System und organisiert nach innen die Zusammenarbeit der Hosts, um die
gemeinsame Aufgabe zu erfüllen.
:::

::: paragraph
Ein Cluster kann verschiedene Aufgaben übernehmen, zum Beispiel ein
HPC-Cluster das Hochleistungsrechnen (*high-performance computing*), das
unter anderem dann eingesetzt wird, wenn Berechnungen viel mehr Speicher
benötigen als auf einem Computer verfügbar ist. Falls das Cluster die
Aufgabe hat, für Hochverfügbarkeit (*high availability*) zu sorgen, wird
es auch als HA-Cluster bezeichnet. Um HA-Cluster geht es in diesem
Artikel, d.h. wenn wir im folgenden „Cluster" schreiben, ist stets ein
**HA-Cluster** gemeint.
:::

::: paragraph
Ein Cluster bietet einen oder mehrere Services nach außen an: die
Cluster-Services, die manchmal auch als „geclusterte Services"
bezeichnet werden. In einem Cluster werden die Hosts, aus denen es
besteht, als Knoten (*nodes*) bezeichnet. Zu einem bestimmten Zeitpunkt
wird jeder Service von genau einem der Knoten bereitgestellt. Fällt ein
Knoten des Clusters aus, werden alle Services, die für die Aufgabe des
Clusters essentiell sind, auf einen der verbleibenden Knoten verschoben.
:::

::: paragraph
Um ein Failover transparent zu machen, stellen einige Cluster eine
eigene Cluster-IP-Adresse zur Verfügung, die manchmal auch als virtuelle
IP-Adresse bezeichnet wird. Die Cluster-IP-Adresse verweist stets auf
den aktiven Knoten und steht stellvertretend für das gesamte Cluster. Im
Falle eines Failover geht die IP-Adresse auf einen anderen, bisher
passiven Knoten über, der dann zum aktiven Knoten wird. Dem Client, der
mit dem Cluster kommuniziert, kann ein internes Failover egal sein: Er
verwendet unverändert die gleiche IP-Adresse und braucht nicht
umzuschalten.
:::

::: paragraph
Andere Cluster haben keine Cluster-IP-Adresse. Ein prominentes Beispiel
sind Oracle-Datenbank-Cluster in vielen ihrer Varianten. Ohne
Cluster-IP-Adresse muss der Client eine Liste der IP-Adressen aller
Knoten führen, die den Service bereitstellen könnten. Fällt der aktive
Knoten aus, muss der Client dies erkennen und auf denjenigen Knoten
umschalten, der den Service nunmehr bereitstellt.
:::
:::::::::

::::::::::::: sect2
### []{#_das_monitoring_eines_clusters .hidden-anchor .sr-only}1.2. Das Monitoring eines Clusters {#heading__das_monitoring_eines_clusters}

::: paragraph
Checkmk ist einer der Clients, der mit dem Cluster kommuniziert. In
Checkmk können alle Knoten eines Clusters eingerichtet und überwacht
werden --- unabhängig davon, wie die Cluster-Software intern den Status
der einzelnen Knoten überprüft und, falls notwendig, einen Failover
durchführt.
:::

::: paragraph
Die meisten Checks, die Checkmk auf den einzelnen Knoten eines Clusters
ausführt, befassen sich mit den physischen Eigenschaften der Knoten, die
unabhängig davon sind, ob der Host zu einem Cluster gehört oder nicht.
Beispiele dafür sind CPU- und Speichernutzung, lokale Festplatten,
physische Netzwerkschnittstellen usw. Für die Abbildung der
Cluster-Funktion der Knoten in Checkmk ist es aber notwendig, diejenigen
Services zu identifizieren, die die Aufgabe des Clusters definieren und
gegebenenfalls auf einen anderen Knoten übertragen werden: die
Cluster-Services.
:::

::: paragraph
Checkmk hilft Ihnen dabei, die Cluster-Services zu überwachen. Was Sie
tun müssen, ist:
:::

::: {.olist .arabic}
1.  Cluster erstellen

2.  Cluster-Services auswählen

3.  Service-Erkennung für alle beteiligten Hosts durchführen
:::

::: paragraph
Wie Sie dabei vorgehen, wird im nächsten Kapitel anhand der folgenden
Beispielkonfiguration beschrieben:
:::

:::: {.imageblock .border}
::: content
![cs example cluster](../images/cs_example_cluster.png)
:::
::::

::: paragraph
In Checkmk soll ein Windows Failover Cluster als HA-Cluster eingerichtet
werden, das aus zwei Knoten mit installiertem Microsoft SQL (MS SQL)
Server besteht. Es handelt sich dabei um ein sogenanntes
Aktiv/Passiv-Cluster, das heißt, nur auf einem, dem aktiven Knoten läuft
eine Datenbankinstanz. Der andere Knoten ist passiv und wird nur im Fall
eines Failover aktiv, fährt die Datenbankinstanz hoch und ersetzt den
ausgefallenen Knoten. Die Daten der Datenbankinstanz werden nicht auf
den Knoten selbst gespeichert, sondern auf einem gemeinsam genutzten
Speichermedium, z.B. einem Storage Area Network (SAN), an das beide
Knoten angeschlossen sind. Die Beispielkonfiguration besteht aus den
folgenden Komponenten:
:::

::: ulist
- `mssql-node01` ist der aktive Knoten mit laufender Datenbankinstanz.

- `mssql-node02` ist der passive Knoten.

- `mssql-cluster01` ist das Cluster, dem beide Knoten angehören.
:::

::: paragraph
Anders als in diesem Beispiel ist es auch möglich, das derselbe Knoten
in mehreren Clustern enthalten ist. Im letzten Kapitel erfahren Sie, wie
Sie solche überlappenden Cluster konfigurieren anhand einer abgeänderten
Beispielkonfiguration.
:::
:::::::::::::
:::::::::::::::::::::
::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#_cluster_und_cluster_services_einrichten .hidden-anchor .sr-only}2. Cluster und Cluster-Services einrichten {#heading__cluster_und_cluster_services_einrichten}

:::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_cluster_erstellen .hidden-anchor .sr-only}2.1. Cluster erstellen {#heading__cluster_erstellen}

::: paragraph
In Checkmk werden die Knoten und das Cluster selbst als Hosts erstellt
(Knoten-Hosts und Cluster-Hosts), wobei es für einen Cluster-Host einen
speziellen Host-Typen gibt.
:::

::: paragraph
Vor der Einrichtung eines Cluster-Hosts gibt es folgendes zu beachten:
:::

::: ulist
- Der Cluster-Host ist ein virtueller Host, der mit Cluster-IP-Adresse
  konfiguriert werden soll, wenn diese existiert. In unserem Beispiel
  gehen wir davon aus, dass der Name des Cluster-Hosts über DNS
  auflösbar ist.

- Cluster-Hosts können auf die gleiche Art und Weise konfiguriert werden
  wie „normale" Hosts, zum Beispiel mit
  [Host-Merkmalen](glossar.html#host_tag) oder
  [Host-Gruppen.](glossar.html#host_group)

- Für alle beteiligten Hosts (damit sind stets der Cluster-Host und alle
  zugehörigen Knoten-Hosts gemeint), müssen die Datenquellen identisch
  konfiguriert werden, d.h. insbesondere dürfen nicht einige per
  Checkmk-Agent und andere per SNMP konfiguriert sein. Checkmk stellt
  sicher, dass ein Cluster-Host nur dann erstellt werden kann, wenn
  diese Voraussetzung erfüllt ist.

- In einem [verteilten Monitoring](distributed_monitoring.html) müssen
  alle beteiligten Hosts derselben Checkmk-Instanz zugeordnet sein.

- Nicht alle Checks funktionieren in einer Cluster-Konfiguration. Bei
  denjenigen Checks, die die Cluster-Unterstützung implementiert haben,
  können Sie dies in der Manual Page des Plugins nachlesen. Zu den
  Manual Pages geht es im Menü [Setup \> Services \> Catalog of check
  plugins]{.guihint}.
:::

::: paragraph
In unserem Beispiel sind die beiden Knoten-Hosts `mssql-node01` und
`mssql-node02` bereits als [Hosts](glossar.html#host) angelegt und
eingerichtet. Wie es so weit kommen konnte, können Sie im [Artikel zur
Überwachung von Windows-Servern](agent_windows.html) nachlesen --- und
dort im Kapitel zur Erweiterung des Standard Windows-Agenten mit
Plugins, für unser Beispiel den [MS SQL
Server-Plugins.](https://checkmk.com/de/integrations?tags=mssql){target="_blank"}
:::

::: paragraph
Starten Sie die Erstellung des Clusters im Menü [Setup \> Hosts \>
Hosts]{.guihint} und dann im Menü [Hosts \> Add cluster]{.guihint}:
:::

:::: imageblock
::: content
![cs create cluster](../images/cs_create_cluster.png)
:::
::::

::: paragraph
Geben Sie als [Hostname]{.guihint} `mssql-cluster01` ein und tragen Sie
unter [Nodes]{.guihint} die beiden Knoten-Hosts ein.
:::

::: paragraph
**Hinweis:** Falls Sie es mit einem Cluster ohne Cluster-IP-Adresse zu
tun haben, müssen Sie einen nicht ganz komfortablen Umweg gehen: Sie
können im Kasten [Network Address]{.guihint} für die [IP Address
Family]{.guihint} den Eintrag [No IP]{.guihint} auswählen. Um aber zu
verhindern, dass der Host im Monitoring auf [DOWN]{.hstate1} geht,
müssen Sie für diesen das standardmäßig eingestellte „Host Check
Command" über die gleichnamige Regel ändern: von [Smart PING]{.guihint}
bzw. [PING]{.guihint} auf z.B. den Status eines der Services, die dem
Cluster-Host im nächsten Kapitel zugewiesen werden. Mehr Informationen
zu den Host-Regelsätzen finden Sie im [Artikel über
Regeln](wato_rules.html).
:::

::: paragraph
Schließen Sie die Erstellung mit [Save & view folder]{.guihint} ab und
[aktivieren Sie die Änderungen](wato.html#activate_changes).
:::
:::::::::::::

::::::::::::: sect2
### []{#_cluster_services_auswählen .hidden-anchor .sr-only}2.2. Cluster-Services auswählen {#heading__cluster_services_auswählen}

::: paragraph
Checkmk kann nicht wissen, welche der auf einem Knoten laufenden
Services lokale und welche Cluster-Services sind: Einige Dateisysteme
können lokal sein, andere sind möglicherweise nur auf dem aktiven Knoten
gemountet. Ähnliches gilt für Prozesse: Während der Windows Dienst
„Windows-Zeitgeber" höchstwahrscheinlich auf allen Knoten läuft, wird
eine bestimmte Datenbankinstanz nur auf dem aktiven Knoten verfügbar
sein.
:::

::: paragraph
Statt Checkmk raten zu lassen, wählen Sie die Cluster-Services mit einer
Regel aus. Ohne Regel werden dem Cluster keine Services zugewiesen. Für
das Beispiel gehen wir davon aus, dass die Namen aller MS SQL Server
Cluster-Services mit `MSSQL` beginnen und das Dateisystem des gemeinsam
genutzten Speichermedium über das Laufwerk `D:` zugreifbar ist.
:::

::: paragraph
Starten Sie mit [Setup \> Hosts \> Hosts]{.guihint} und klicken Sie den
Cluster-Namen an. Auf der Seite [Properties of host]{.guihint} wählen
Sie im Menü [Hosts \> Clustered services]{.guihint}. Sie landen auf der
Seite des Regelsatzes [Clustered services]{.guihint}, auf der Sie eine
neue Regel erstellen können.
:::

::: paragraph
Unabhängig davon, ob und wie die Hosts in Ordner organisiert sind:
Achten Sie darauf, dass Sie alle Regeln für Cluster-Services so
erstellen, dass sie für die Knoten-Hosts gelten, auf denen die Services
laufen. Für einen Cluster-Host ist eine solche Regel unwirksam.
:::

::: paragraph
Wählen Sie unter [Create rule in folder]{.guihint} den Ordner aus, der
die Knoten-Hosts enthält. Sie erhalten die Seite [New rule: Clustered
services]{.guihint}:
:::

:::: imageblock
::: content
![cs rule cs](../images/cs_rule_cs.png)
:::
::::

::: paragraph
Im Kasten [Conditions]{.guihint} aktivieren Sie [Explicit
hosts]{.guihint} und tragen den aktiven Knoten-Host `mssql-node01` und
den passiven Knoten-Host `mssql-node02` ein. Dann aktivieren Sie
[Services]{.guihint} und machen dort zwei Einträge: `MSSQL` für alle MS
SQL-Services, deren Name mit `MSSQL` beginnen und `Filesystem D:` für
das Laufwerk. Die Eingaben werden als [reguläre Ausdrücke](regexes.html)
interpretiert.
:::

::: paragraph
Alle Services, die nicht als Cluster-Services definiert sind, werden von
Checkmk als lokale Services behandelt.
:::

::: paragraph
Schließen Sie die Erstellung der Regel mit [Save]{.guihint} ab und
aktivieren Sie die Änderungen.
:::
:::::::::::::

::::::::::::: sect2
### []{#_service_erkennung_durchführen .hidden-anchor .sr-only}2.3. Service-Erkennung durchführen {#heading__service_erkennung_durchführen}

::: paragraph
Für alle beteiligten Hosts (Cluster- und Knoten-Hosts) muss zum
Abschluss eine neue Service-Erkennung (*discovery*) durchgeführt werden,
damit alle neu definierten Cluster-Services zuerst bei den Knoten
entfernt und dann beim Cluster hinzugefügt werden.
:::

::: paragraph
Unter [Setup \> Hosts \> Hosts]{.guihint} markieren Sie zuerst alle
beteiligten Hosts und wählen dann im Menü [Hosts \> On Selected hosts \>
Run bulk service discovery]{.guihint}. Auf der Seite [Bulk
discovery]{.guihint} sollte die erste Option [Add unmonitored services
and new host labels]{.guihint} zum gewünschten Ergebnis führen.
:::

::: paragraph
Klicken Sie [Start]{.guihint} um die [Serviceerkennung für viele
Hosts](wato_services.html#bulk_discovery) zu beginnen. Nach
erfolgreichem Abschluss, erkennbar an der Meldung
`Bulk discovery successful`, verlassen Sie die Seite und aktivieren die
Änderungen.
:::

::: paragraph
Um herauszufinden, ob die Auswahl der Cluster-Services zum gewünschten
Ergebnis geführt hat, können Sie sich alle Services auflisten, die
nunmehr dem Cluster zugewiesen sind: Unter [Setup \> Hosts \>
Hosts]{.guihint} klicken Sie in der Host-Liste beim Eintrag des
Cluster-Hosts auf das Symbol [![icon
services](../images/icons/icon_services.png)]{.image-inline} zum
Bearbeiten der Services. Auf der folgenden Seite [Services of
host]{.guihint} werden unter [Monitored services]{.guihint} alle
Cluster-Services aufgelistet:
:::

:::: imageblock
::: content
![cs cluster monitored
services](../images/cs_cluster_monitored_services.png)
:::
::::

::: paragraph
Auf der anderen Seite, bei den Knoten-Hosts, fehlen nunmehr genau die
zum Cluster verschobenen Services in der Liste der überwachten Services.
Am Knoten-Host finden Sie diese am Ende der Services-Liste im Abschnitt
[Monitored clustered services (located on cluster host)]{.guihint}:
:::

:::: imageblock
::: content
![cs node monitored services](../images/cs_node_monitored_services.png)
:::
::::

::: paragraph
**Tipp:** Falls Sie [lokale Checks](localchecks.html) in einem Cluster
ausführen, in der die Regel [Clustered services]{.guihint} angewendet
ist, können Sie mit dem Regelsatz [Local checks in Checkmk
clusters]{.guihint} das Ergebnis beeinflussen, indem Sie zwischen [Worst
state]{.guihint} und [Best state]{.guihint} auswählen.
:::
:::::::::::::

:::: sect2
### []{#_automatische_service_erkennung .hidden-anchor .sr-only}2.4. Automatische Service-Erkennung {#heading__automatische_service_erkennung}

::: paragraph
Wenn Sie die Service-Erkennung automatisch über den [Discovery
Check](wato_services.html#discovery_auto) erledigen lassen, müssen Sie
eine Besonderheit beachten. Der [Discovery Check]{.guihint} kann
verschwundene Services automatisch löschen. Wandert ein geclusterter
Service aber von einem Knoten zum anderen, könnte er fälschlicherweise
als verschwunden registriert und dann gelöscht werden. Verzichten Sie
hingegen auf diese Option, würden wiederum tatsächlich verschwundene
Services niemals gelöscht.
:::
::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::: sect1
## []{#_überlappende_cluster .hidden-anchor .sr-only}3. Überlappende Cluster {#heading__überlappende_cluster}

:::::::::::::::::::::::::::: sectionbody
::: paragraph
Es ist möglich, dass mehrere Cluster einen oder auch mehrere Knoten
gemeinsam nutzen. Man spricht dann von überlappenden Clustern. Bei
überlappenden Clustern benötigen Sie eine spezielle Regel, um Checkmk
mitzuteilen, welche Cluster-Services eines gemeinsam genutzten
Knoten-Hosts welchem Cluster zugeordnet werden sollen.
:::

::: paragraph
Das prinzipielle Vorgehen beim Einrichten eines überlappenden Clusters
werden wir im folgenden vorstellen, indem wir das Beispiel des MS SQL
Server Clusters von einem Aktiv/Passiv- zu einem Aktiv/Aktiv-Cluster
abwandeln:
:::

:::: {.imageblock .border}
::: content
![cs example cluster overlap](../images/cs_example_cluster_overlap.png)
:::
::::

::: paragraph
In dieser Konfiguration ist nicht nur MS SQL Server auf beiden
Knoten-Hosts installiert, sondern auf jedem der beiden Knoten läuft eine
eigene Datenbankinstanz. Beide Knoten greifen auf das gemeinsam genutzte
Speichermedium zu, aber auf unterschiedlichen Laufwerken. Dieses
Beispiel realisiert ein zu 100 % überlappendes Cluster, da die beiden
Knoten beiden Clustern angehören.
:::

::: paragraph
Der Vorteil des Aktiv/Aktiv-Clusters besteht darin, dass die verfügbaren
Ressourcen der beiden Knoten besser genutzt werden. Im Fall eines
Failover wird die Aufgabe des ausgefallenen Knotens vom anderen Knoten
übernommen, auf dem dann beide Datenbankinstanzen laufen.
:::

::: paragraph
Diese Beispielkonfiguration besteht somit aus den folgenden Komponenten:
:::

::: ulist
- `mssql-node01` ist der erste aktive Knoten mit der laufenden
  Datenbankinstanz `MSSQL Instance1`.

- `mssql-node02` ist der zweite aktive Knoten mit der laufenden
  Datenbankinstanz `MSSQL Instance2`.

- `mssql-cluster01` und `mssql-cluster02` sind die beiden Cluster, denen
  beide Knoten angehören.
:::

::: paragraph
Den 1. Schritt zur Einrichtung des Aktiv/Passiv-Clusters müssen Sie für
ein Aktiv/Aktiv-Cluster nur leicht abwandeln: Sie erstellen, wie oben
beschrieben, das erste Cluster `mssql-cluster01`. Anschließend erstellen
Sie das zweite Cluster `mssql-cluster02` mit denselben beiden
Knoten-Hosts.
:::

::: paragraph
Im 2. Schritt nutzen Sie zur Auswahl der Cluster-Services statt des
allgemeinen Regelsatzes [Clustered services]{.guihint} den speziell für
überlappende Cluster geltenden Regelsatz [Clustered services for
overlapping clusters]{.guihint}. Damit definieren Sie in einer Regel die
Cluster-Services, die bei den Knoten-Hosts entfernt und dem ausgewählten
Cluster zugeschlagen werden.
:::

::: paragraph
Für unser Beispiel mit 100 % Überlappung benötigen wir zwei dieser
Regeln: Die erste Regel definiert die Cluster-Services der ersten
Datenbankinstanz, die standardmäßig auf dem ersten Knoten-Host laufen.
Da im Fall eines Failover diese Cluster-Services auf den zweiten
Knoten-Host übertragen werden, weisen wir die Services beiden
Knoten-Hosts zu. Die zweite Regel tut dies analog für das zweite Cluster
und die zweite Datenbankinstanz.
:::

::: paragraph
Starten wir mit der ersten Regel: Unter [Setup \> General \> Rule
search]{.guihint} suchen Sie den Regelsatz [Clustered services for
overlapping clusters]{.guihint} und klicken ihn an. Wählen Sie unter
[Create rule in folder]{.guihint} wieder den Ordner aus, der die
Knoten-Hosts enthält.
:::

::: paragraph
Tragen Sie als [Assign services to the following cluster]{.guihint} das
Cluster `mssql-cluster01` ein:
:::

:::: imageblock
::: content
![cs rule cs overlapping](../images/cs_rule_cs_overlapping.png)
:::
::::

::: paragraph
Im Kasten [Conditions]{.guihint} aktivieren Sie [Explicit
hosts]{.guihint} und tragen beide Knoten-Hosts ein. Dann aktivieren Sie
[Services]{.guihint} und machen dort zwei Einträge: `MSSQL Instance1`
für alle MS SQL-Services der ersten Datenbankinstanz und `Filesystem D:`
für das Laufwerk:
:::

:::: imageblock
::: content
![cs rule cs overlapping
conditions](../images/cs_rule_cs_overlapping_conditions.png)
:::
::::

::: paragraph
Schließen Sie die Erstellung der ersten Regel mit [Save]{.guihint} ab.
:::

::: paragraph
Erstellen Sie anschließend gleich die zweite Regel, diesmal für das
zweite Cluster `mssql-cluster02` und erneut für beide Knoten-Hosts.
Unter [Services]{.guihint} tragen Sie jetzt `MSSQL Instance2` ein für
alle MS SQL-Services der zweiten Datenbankinstanz. Der zweite
Knoten-Host, auf dem die zweiten Datenbankinstanz standardmäßig läuft,
greift auf sein Speichermedium unter einem anderen Laufwerk zu, im
folgenden Beispiel über das `E:` Laufwerk:
:::

:::: imageblock
::: content
![cs rule cs overlapping
conditions2](../images/cs_rule_cs_overlapping_conditions2.png)
:::
::::

::: paragraph
Sichern Sie auch diese Regel und aktivieren Sie dann die beiden
Änderungen.
:::

::: paragraph
Führen Sie abschließend die Service-Erkennung als 3. und letzten Schritt
genauso aus wie oben beschrieben: als [Bulk discovery]{.guihint} für
alle beteiligten Hosts, d.h. die beiden Cluster-Hosts und die beiden
Knoten-Hosts.
:::

::: paragraph
**Hinweis:** Falls mehrere Regeln einen Cluster-Service definieren, hat
die spezifischere Regel [Clustered services for overlapping
clusters]{.guihint} mit der expliziten Zuordnung zu einem bestimmten
Cluster Vorrang vor der allgemeineren Regel [Clustered
Services]{.guihint}. Für die beiden in diesem Artikel vorgestellten
Beispiele bedeutet das: Durch die beiden zuletzt erstellten spezifischen
Regeln würde die im ersten Beispiel erstellte allgemeine Regel nie zur
Anwendung kommen.
:::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
