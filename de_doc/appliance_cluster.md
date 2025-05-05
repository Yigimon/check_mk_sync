:::: {#header}
# Appliance im Cluster-Betrieb

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_cluster.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Appliance einrichten und nutzen](appliance_usage.html) [Besonderheiten
der Appliance auf Racks](appliance_rack_config.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_grundlagen .hidden-anchor .sr-only}1. Grundlagen {#heading__grundlagen}

:::::::: sectionbody
::: paragraph
Sie können zwei Checkmk-Appliances zu einem Failover-Cluster
zusammenschließen. Dabei werden alle Konfigurationen und Daten zwischen
den beiden Geräten abgeglichen. Die Geräte, die als Cluster verbunden
sind, nennt man auch Knoten (Nodes). Einer der Knoten im Cluster
übernimmt die aktive Rolle, führt also die Aufgaben des Clusters aus.
Beide Knoten tauschen sich ständig über ihren Zustand aus. Sobald der
inaktive Knoten erkennt, dass der aktive Knoten seine Aufgaben nicht
mehr erfüllen kann, z.B. aufgrund eines Ausfalls, übernimmt er dessen
Aufgaben und wird selbst zum aktiven Knoten.
:::

::: paragraph
Der Failover-Cluster ist dazu da, die Verfügbarkeit Ihrer
Monitoring-Installation zu erhöhen, indem diese gegen Hardwareausfälle
eines Geräts oder einzelner Komponenten abgesichert wird. Das Clustern
ersetzt hingegen keine Datensicherung und fängt keine logischen Fehler
ab.
:::

::: paragraph
In den folgenden Situationen sorgt der Cluster für eine geringere
Ausfallzeit, indem der inaktive Knoten die Ressourcen übernimmt:
:::

::: ulist
- Wenn das RAID in einem Checkmk-Rack nicht mehr zugreifbar ist.

- Wenn das bisher aktive Gerät nicht mehr erreichbar (ausgefallen) ist.

- Wenn das bisher aktive Gerät das „externe" Netzwerk nicht mehr
  erreichen kann, der inaktive Knoten hingegen schon.

- Wenn Sie ein Firmware-Update auf den Knoten durchführen.
:::

::: paragraph
Funktionieren kann das Cluster im Ernstfall natürlich nur, wenn die
Knoten über *separate* Switches und Stromversorgungen betrieben werden!
:::
::::::::
:::::::::

:::::::::: sect1
## []{#_voraussetzungen .hidden-anchor .sr-only}2. Voraussetzungen {#heading__voraussetzungen}

::::::::: sectionbody
::: paragraph
Damit Sie einen Cluster aufbauen können, brauchen Sie zunächst zwei
kompatible Checkmk-Appliances. Folgende Modelle können miteinander
geclustert werden:
:::

::: ulist
- 2 x Checkmk rack1

- 2 x Checkmk rack5

- 2 x Checkmk virt1 (Technisch möglich, aber nicht unterstützt bzw.
  empfohlen. Siehe [unten](#cluster_virt1) für Details.)

- 1 x Checkmk rack1/rack5 und 1 x Checkmk virt1
:::

::: paragraph
Weiterhin müssen die beiden Geräte eine [kompatible
Firmware](appliance_usage.html#cma_webconf_firmware) nutzen. Kombinieren
Sie eine virt1-Appliance mit einem physischen Rack, muss die virtuelle
Maschine die gleichen Spezifikationen wie der physische Server
aufweisen --- ansonsten könnte sie abstürzen, wenn sie die Last vom Rack
übernimmt.
:::

::: paragraph
Die Geräte müssen mit mindestens zwei voneinander unabhängigen
Netzwerkverbindungen verkabelt sein. Eine dieser Verbindungen dient der
normalen Netzwerkanbindung, die zweite der Synchronisation zwischen den
Cluster-Knoten. Die Sync-Verbindung sollte möglichst direkt zwischen den
Geräten laufen, zumindest aber über ein separates Netzwerk.
:::

::: paragraph
[]{#cluster_virt1}Um die Verfügbarkeit der Netzwerkverbindungen zu
erhöhen, sollten Sie eine Bonding-Konfiguration erstellen. Wie diese
Bonding-Konfiguration konkret aussehen sollte, hängt in erster Linie von
Ihrer Umgebung ab. Konsultieren Sie dazu ggf. Ihre Kolleginnen und
Kollegen aus dem Rechenzentrum bzw. der Netzwerkabteilung.
:::

### Virtuelle Appliances clustern {#_virtuelle_appliances_clustern .discrete}

::: paragraph
Technisch ist es durchaus möglich, zwei virt1-Instanzen zu clustern. Da
die Cluster-Funktion jedoch darauf ausgelegt ist, Hardwareausfälle zu
kompensieren, empfehlen wir dies nicht für den produktiven Betrieb. Für
Hochverfügbarkeit bieten Virtualisierungsplattformen wie VMware vSphere
eigene Funktionen. Jedoch können Sie die Verhaltensweise und
Konfiguration eines Clusters mit zwei virtuellen Maschinen sehr einfach
testen. Dazu eignen sich auch \"Desktop-Virtualisierer\" wie VirtualBox
oder VMware Workstation Player. Auf die Bonding-Konfiguration können Sie
dabei verzichten. Statt also wie im Folgenden gezeigt das Bonding
einzurichten, nutzen Sie einfach die ungenutzte zweite
Netzwerkschnittstelle. Beim eigentlichen Clustern wählen Sie dann
schlicht Ihre beiden einzelnen Schnittstellen statt der
Bonding-Schnittstellen.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_konfiguration_des_clusters .hidden-anchor .sr-only}3. Konfiguration des Clusters {#heading__konfiguration_des_clusters}

:::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Diese Anleitung geht davon aus, dass Sie beide Geräte bereits so weit
vorkonfiguriert haben, dass Sie die Weboberfläche mit einem Webbrowser
öffnen können.
:::

::: paragraph
Vor der eigentlichen Einrichtung des Clusters müssen Sie zunächst beide
Geräte vorbereiten. Dabei müssen Sie hauptsächlich die
Netzwerkkonfiguration so anpassen, dass die oben genannten Anforderungen
erfüllt werden. Beachten Sie gegebenenfalls die für das Clustering
genutzten [Ports.](ports.html#appliance_cluster)
:::

::: paragraph
Im Folgenden wird eine Referenzimplementierung eines Clusters mit zwei
Bonding-Schnittstellen gezeigt, das dem folgendem Schaubild entspricht:
:::

:::: imageblock
::: content
![cluster](../images/cluster.png)
:::
::::

::: paragraph
Die im Schaubild verwendeten Schnittstellenbezeichnungen
[LAN1]{.guihint}, [LAN2]{.guihint} usw. repräsentieren die physischen
Schnittstellen am Gerät. Die tatsächlichen Bezeichnungen hängen von der
jeweiligen Hardware ab.
:::

::: paragraph
Die verwendeten IP-Adressen sind freilich beliebig. Achten Sie jedoch
darauf, dass das interne Cluster-Netz ([bond1]{.guihint} im Schaubild)
ein anderes IP-Netz verwendet, als das „externe" Netz ([bond0]{.guihint}
im Schaubild).
:::

:::::::::::::::::::::::::::::: sect2
### []{#_netzwerkkonfiguration .hidden-anchor .sr-only}3.1. Netzwerkkonfiguration {#heading__netzwerkkonfiguration}

::: paragraph
Öffnen Sie die Weboberfläche des ersten Knotens, wählen Sie die [Device
settings]{.guihint} und oben [Network Settings.]{.guihint} In diesen
[Network Settings]{.guihint} stehen Ihnen zwei Modi zur Verfügung.
:::

::: paragraph
Der [Simple Mode,]{.guihint} mit dem Sie nur die Standardschnittstelle
Ihres Geräts konfigurieren können, ist standardmäßig aktiviert. (Dieser
Modus entspricht der Konfiguration über die Textkonsole, die Sie während
der initialen Einrichtung der Appliance durchgeführt haben.)
:::

:::: imageblock
::: content
![appliance cluster edit simple
network](../images/appliance_cluster_edit_simple_network.png)
:::
::::

::: paragraph
Für das Clustern wird der *erweiterte Modus* benötigt. Um diesen Modus
zu aktivieren, klicken Sie oben auf den Button [Advanced Mode]{.guihint}
und akzeptieren Sie den Bestätigungsdialog.
:::

::: paragraph
Auf der folgenden Seite werden Ihnen alle im Gerät verfügbaren
Netzwerkschnittstellen angezeigt. Nur die Standardschnittstelle, hier im
Screenshot *ens32*, hat aktuell eine Konfiguration. Diese wurde vom
*einfachen Modus* übernommen.
:::

:::: {.imageblock .border}
::: content
![appliance cluster advanced
mode](../images/appliance_cluster_advanced_mode.png)
:::
::::

::: paragraph
Erstellen Sie nun durch Klick auf [Create Bonding]{.guihint} die erste
Bonding-Schnittstelle [bond0.]{.guihint} Tragen Sie dazu im darauf
folgenden Dialog alle Daten entsprechend des folgenden Screenshots ein
und bestätigen Sie den Dialog mit [Save.]{.guihint}
:::

:::: imageblock
::: content
![appliance cluster create
bond0](../images/appliance_cluster_create_bond0.png)
:::
::::

::: paragraph
Erstellen Sie nun die zweite Bonding-Schnittstelle [bond1]{.guihint} mit
der passenden Konfiguration für die direkte Sync-Verbindung.
:::

:::: imageblock
::: content
![appliance cluster create
bond1](../images/appliance_cluster_create_bond1.png)
:::
::::

::: paragraph
Nachdem Sie die beiden Bonding-Schnittstellen erstellt haben, sehen Sie
im Dialog zur Netzwerkkonfiguration noch einmal alle getätigten
Einstellungen zu den Netzwerkschnittstellen ...
:::

:::: imageblock
::: content
![appliance cluster create bonds pending
interfaces](../images/appliance_cluster_create_bonds_pending_interfaces.png)
:::
::::

::: paragraph
... sowie zu den erstellten Bondings:
:::

:::: imageblock
::: content
![appliance cluster create bonds pending
bonds](../images/appliance_cluster_create_bonds_pending_bonds.png)
:::
::::

::: paragraph
Wenn Sie alle Schritte zur Konfiguration erfolgreich abgeschlossen
haben, machen Sie die Einstellungen mit einem Klick auf [Activate
Changes]{.guihint} wirksam. Daraufhin werden die neuen
Netzwerkeinstellungen geladen. Nach wenigen Sekunden zeigt die
Netzwerkkonfiguration überall den Status OK, bei den echten
Netzwerkschnittstellen ...​
:::

:::: imageblock
::: content
![appliance cluster create bonds no pending
interfaces](../images/appliance_cluster_create_bonds_no_pending_interfaces.png)
:::
::::

::: paragraph
... sowie wiederum bei den Bondings:
:::

:::: imageblock
::: content
![appliance cluster create bonds no pending
bonds](../images/appliance_cluster_create_bonds_no_pending_bonds.png)
:::
::::

::: paragraph
Wiederholen Sie die Konfiguration der Netzwerkeinstellungen mit den
passenden Einstellungen nun auch auf Ihrem zweiten Gerät.
:::
::::::::::::::::::::::::::::::

:::: sect2
### []{#_host_namen .hidden-anchor .sr-only}3.2. Host-Namen {#heading__host_namen}

::: paragraph
Geräte, die in einem Cluster verbunden werden sollen, müssen
unterschiedliche Host-Namen haben. Diese können Sie jetzt in den
[Geräteeinstellungen](appliance_usage.html#cma_webconf_system_settings)
festlegen. Im Beispiel bekommen die Geräte die Namen `cma1` und `cma2`.
:::
::::

:::::::::::::: sect2
### []{#_cluster_verbinden .hidden-anchor .sr-only}3.3. Cluster verbinden {#heading__cluster_verbinden}

::: paragraph
Nachdem Sie nun die Vorbereitungen abgeschlossen haben, können Sie mit
dem Einrichten des Clusters fortfahren. Öffnen Sie dazu in der
Weboberfläche im Hauptmenü des ersten Geräts (hier `cma1`) das Modul
[Clustering]{.guihint} und klicken Sie dort auf [Create
Cluster.]{.guihint}
:::

::: paragraph
Tragen Sie im Dialog zum Erstellen des Clusters die entsprechende
Konfiguration ein und bestätigen Sie den Dialog mit [Save.]{.guihint}
Wichtig ist hier vor allem die [Cluster IP-Address,]{.guihint} über die
Sie später auf das Cluster zugreifen. Wenn Sie zu diesem Dialog
weiterführende Informationen benötigen, rufen Sie die Inline-Hilfe über
das Symbol neben dem Checkmk-Logo auf.
:::

:::: imageblock
::: content
![appliance cluster create
cluster](../images/appliance_cluster_create_cluster.png)
:::
::::

::: paragraph
Auf der folgenden Seite können Sie die beiden Geräte zu einem Cluster
verbinden. Hierzu müssen Sie das Passwort der Weboberfläche des zweiten
Geräts eingeben. Dieses wird einmalig dazu genutzt, die Verbindung
zwischen den beiden Geräten herzustellen. Akzeptieren Sie anschließend
den Bestätigungsdialog, wenn Sie sich sicher sind, dass Sie die Daten
des angezeigten Zielgeräts überschreiben wollen.
:::

:::: imageblock
::: content
![cma de cluster 2 2](../images/cma_de_cluster_2_2.png)
:::
::::

::: paragraph
Nachdem dieser Verbindungsaufbau erfolgreich war, wird mit der
Synchronisation des Clusters begonnen. Den aktuellen Status können Sie
sich auf der Cluster-Seite anzeigen lassen. Noch während dieser
Synchronisation werden alle Ressourcen, u.a. auch Ihre möglicherweise
bestehenden Monitoring-Instanzen, auf dem ersten Knoten gestartet.
:::

:::: imageblock
::: content
![appliance cluster cluster
resources](../images/appliance_cluster_cluster_resources.png)
:::
::::

::: paragraph
Ab sofort können Sie mit Hilfe der Cluster-IP-Adresse (hier `10.3.3.30`)
auf die Ressourcen des Clusters, z.B. Ihre Monitoring-Instanzen,
zugreifen --- egal von welchem Knoten die Ressourcen gerade gehalten
werden.
:::
::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::: sect1
## []{#_der_status_des_clusters .hidden-anchor .sr-only}4. Der Status des Clusters {#heading__der_status_des_clusters}

::::::::: sectionbody
::: paragraph
Nach Abschluss der ersten Synchronisation ist Ihr Cluster voll
einsatzbereit. Auf der Cluster-Seite können Sie den Zustand jederzeit
einsehen.
:::

:::: imageblock
::: content
![appliance cluster cluster
status](../images/appliance_cluster_cluster_status.png)
:::
::::

::: paragraph
Auch mit Hilfe der Statusansicht der Konsole können Sie den aktuellen
Zustand des Clusters im Kasten [Cluster]{.guihint} in zusammengefasster
Form einsehen. Die Rolle des jeweiligen Knotens wird hinter dem
aktuellen Status in Klammern angezeigt: beim aktiven Knoten
[M]{.guihint} (für *Main*) und beim passiven Knoten [S]{.guihint} (für
*Subordinate*).
:::

:::: imageblock
::: content
![appliance cluster tui
cluster](../images/appliance_cluster_tui_cluster.png){width="80%"}
:::
::::
:::::::::
::::::::::

:::::::::::::::: sect1
## []{#_besonderheiten_im_cluster .hidden-anchor .sr-only}5. Besonderheiten im Cluster {#heading__besonderheiten_im_cluster}

::::::::::::::: sectionbody
::::: sect2
### []{#_zugriff_auf_ressourcen .hidden-anchor .sr-only}5.1. Zugriff auf Ressourcen {#heading__zugriff_auf_ressourcen}

::: paragraph
Alle Anfragen an die Monitoring-Instanzen, wie z.B. Zugriffe auf die
Weboberfläche, aber auch eingehende Meldungen wie z.B. SNMP-Traps oder
Syslog-Meldungen an die Event-Console oder Anfragen an den Livestatus,
sollten im Normalfall immer über die Cluster-IP-Adresse gehen.
:::

::: paragraph
Nur in Ausnahmefällen, wie z.B. Fehlerdiagnosen oder Updates eines
bestimmten Knotens, sollten Sie direkt auf die einzelnen Knoten
zugreifen müssen.
:::
:::::

:::::: sect2
### []{#_geräteeinstellungen .hidden-anchor .sr-only}5.2. Geräteeinstellungen {#heading__geräteeinstellungen}

::: paragraph
Die Einstellungen, wie z.B. für die Zeitsynchronisation oder zur
Namensauflösung, die bisher auf den einzelnen Geräten unabhängig
voneinander gemacht wurden, werden im Cluster zwischen den beiden Knoten
synchronisiert.
:::

::: paragraph
Sie können diese Einstellungen aber nur auf dem jeweils aktiven Knoten
bearbeiten. Auf dem inaktiven Knoten sind die Einstellungen gesperrt.
:::

::: paragraph
Es gibt einige gerätespezifische Einstellungen, wie z.B. die des
Management-Interfaces des Checkmk rack1, die Sie zu jeder Zeit auf den
einzelnen Geräten anpassen können.
:::
::::::

::::: sect2
### []{#_ip_adressen_oder_host_namen_der_knoten .hidden-anchor .sr-only}5.3. IP-Adressen oder Host-Namen der Knoten {#heading__ip_adressen_oder_host_namen_der_knoten}

::: paragraph
Um die IP-Konfiguration der einzelnen Knoten bearbeiten zu können,
müssen Sie zunächst die Verbindung zwischen den Knoten lösen. Hierzu
klicken Sie auf der Cluster-Seite auf [Disconnect Cluster.]{.guihint}
Anschließend können Sie über die Weboberfläche der einzelnen Knoten die
gewünschten Einstellungen anpassen.
:::

::: paragraph
Nachdem Sie die Anpassungen abgeschlossen haben, müssen Sie nun auf der
Cluster-Seite [Reconnect Cluster]{.guihint} wählen. Wenn sich die Knoten
wieder erfolgreich verbinden können, nimmt der Cluster den Betrieb nach
wenigen Minuten wieder auf. Den Status können Sie auf der Cluster-Seite
einsehen.
:::
:::::

:::: sect2
### []{#_checkmk_versionen_und_monitoring_instanzen_verwalten .hidden-anchor .sr-only}5.4. Checkmk-Versionen und Monitoring-Instanzen verwalten {#heading__checkmk_versionen_und_monitoring_instanzen_verwalten}

::: paragraph
Auch die Monitoring-Instanzen und Checkmk-Versionen werden zwischen den
beiden Knoten synchronisiert. Diese können Sie nur in der Weboberfläche
des aktiven Knotens modifizieren --- sowohl über dessen eigene als auch
über die Cluster-IP-Adresse.
:::
::::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::::::: sect1
## []{#admincluster .hidden-anchor .sr-only}6. Administrative Aufgaben im Cluster {#heading_admincluster}

::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#majorfirmwareupdate .hidden-anchor .sr-only}6.1. Firmware-Update (Major-Version) {#heading_majorfirmwareupdate}

::: paragraph
Im Gegensatz zum nachfolgend beschriebenen Firmware-Update innerhalb
kompatibler Versionen, also beispielsweise 1.6.1 auf 1.6.2, müssen Sie
beim Update von einer Major-Versionen auf die nächste Major-Version
(bspw. von 1.6.x auf 1.7.y) etwas anders vorgehen. Der Grund: Die
Major-Updates aktualisieren entweder die als Basis verwendete
Betriebssystemversion oder ändern grundlegende Konzepte. Kurz gesagt
heißt das, dass Sie das Cluster kurzzeitig komplett offline nehmen
müssen - Sie bekommen also eine Wartungszeit (*downtime*). Bei
[Minor-Updates](#minorfirmwareupdate) genügt es, einzelne Knoten des
Clusters in den Wartungszustand zu versetzen, um die Aktualisierung
durchzuführen. Um ein Major-Update durchzuführen, gehen Sie wie folgt
vor:
:::

::: {.olist .arabic}
1.  Führen Sie vorbereitend ein Update auf die neueste
    Checkmk-Minor-Version durch und schließlich ein Update auf die
    neueste Minor-Version der Appliance-Firmware.

2.  Trennen Sie die Knoten mit [Clustering \> Disconnect
    Cluster]{.guihint} vom Cluster.

3.  Aktualisieren Sie alle Knoten wie im
    [Appliance-Hauptartikel](appliance_usage.html#cma_webconf_firmware)
    beschrieben.

4.  Wenn alle Knoten aktualisiert sind, verbinden Sie diese über
    [Clustering \> Reconnect Cluster]{.guihint} wieder zum Cluster.

5.  Prüfen Sie, ob Ihre Instanzen kompatible Checkmk-Versionen nutzen
    (dies wird meist *nicht* der Fall sein) und installieren Sie bei
    Bedarf für alle Checkmk Instanzen das jeweils zur Firmware der
    Appliance passende Checkmk-Paket wie im
    [Appliance-Hauptartikel](appliance_usage.html#update_site)
    beschrieben.
:::
:::::

::::::::::::::::: sect2
### []{#minorfirmwareupdate .hidden-anchor .sr-only}6.2. Firmware-Update (Minor-Version) {#heading_minorfirmwareupdate}

::: paragraph
Die Firmware-Version eines Geräts wird auch im Cluster-Betrieb nicht
synchronisiert. Das Update geschieht also pro Knoten. Sie haben jedoch
den Vorteil, dass der eine Knoten weiterhin das Monitoring durchführen
kann, während der andere Knoten aktualisiert wird.
:::

::: paragraph
Bei einem Update auf eine kompatible Firmware-Version sollten Sie stets
wie folgt vorgehen:
:::

::: paragraph
Öffnen Sie zunächst das Modul [Clustering]{.guihint} in der
Weboberfläche des Knotens, der aktualisiert werden soll.
:::

::: paragraph
Klicken Sie nun auf das Herz-Symbol in der Spalte dieses Knotens und
akzeptieren Sie den folgenden Bestätigungsdialog. Dadurch setzen Sie den
Knoten in den Wartungszustand.
:::

::: paragraph
Knoten, die sich im Wartungszustand befinden, geben alle Ressourcen
frei, die aktuell auf dem Knoten aktiv sind, woraufhin der andere Knoten
diese übernimmt.
:::

::: paragraph
Während sich ein Knoten im Wartungszustand befindet, ist der Cluster
nicht ausfallsicher. Wenn jetzt also der aktive Knoten ausgeschaltet
wird, übernimmt der inaktive Knoten, der sich im Wartungszustand
befindet, *nicht* die Ressourcen. Sollten Sie nun auch noch den zweiten
Knoten in den Wartungszustand setzen, werden alle Ressourcen
heruntergefahren. Diese werden erst wieder aktiviert, wenn ein Knoten
aus dem Wartungszustand geholt wird. Den Wartungszustand müssen Sie
stets wieder manuell entfernen.
:::

::: paragraph
Wenn die Cluster-Seite Folgendes zeigt, sehen Sie, dass sich der Knoten
im Wartungszustand befindet:
:::

:::: imageblock
::: content
![appliance cluster cluster
maintenance](../images/appliance_cluster_cluster_maintenance.png)
:::
::::

::: paragraph
Nun können Sie auf diesem Knoten, wie auf nicht-geclusterten Geräten
auch, das [Firmware-Update](appliance_usage.html#cma_webconf_firmware)
durchführen.
:::

::: paragraph
Öffnen Sie, nachdem Sie das Firmware-Update erfolgreich durchgeführt
haben, wieder die Cluster-Seite. Entfernen Sie den Wartungszustand des
aktualisierten Geräts. Das Gerät fügt sich anschließend automatisch
wieder in den Cluster ein, womit der Cluster wieder voll funktionsfähig
ist.
:::

:::: imageblock
::: content
![appliance cluster cluster
status](../images/appliance_cluster_cluster_status.png)
:::
::::

::: paragraph
Wir empfehlen, auf beiden Knoten die gleiche Firmware-Version zu
betreiben. Daher sollten Sie im Anschluss die gleiche Prozedur für den
anderen Knoten wiederholen, nachdem der Cluster sich vollständig
synchronisiert hat.
:::
:::::::::::::::::

::::::::::: sect2
### []{#dissolve .hidden-anchor .sr-only}6.3. Cluster auflösen {#heading_dissolve}

::: paragraph
Es ist möglich, die Knoten aus einem Cluster zu lösen und einzeln weiter
zu betreiben. Dabei können Sie auf beiden Geräten die synchronisierte
Konfiguration weiter nutzen oder z.B. eines der Geräte wieder auf den
Werkszustand zurücksetzen und neu konfigurieren.
:::

::: paragraph
Sie können einen oder beide Knoten im laufenden Betrieb aus dem Cluster
entfernen. Wenn Sie beide Knoten mit den aktuellen Daten weiterverwenden
wollen, müssen Sie vorher sicherstellen, dass die Synchronisation der
Daten ordnungsgemäß funktioniert. Dies sehen Sie auf der Cluster-Seite.
:::

::: paragraph
Um einen Cluster aufzulösen, klicken Sie auf der Cluster-Seite der
Weboberfläche auf [Disband Cluster]{.guihint}. Beachten Sie den Text des
folgenden Bestätigungsdialogs. Dieser gibt in den verschiedenen
Situationen Aufschluss darüber, in welchem Zustand sich das jeweilige
Gerät nach dem Auflösen der Verbindung befinden wird.
:::

:::: imageblock
::: content
![appliance cluster disband
cluster](../images/appliance_cluster_disband_cluster.png)
:::
::::

::: paragraph
Die Trennung der Geräte muss auf beiden Knoten separat durchgeführt
werden, damit zukünftig beide Geräte einzeln betrieben werden können.
:::

::: paragraph
Wenn Sie nur eines der Geräte zukünftig verwenden wollen, lösen Sie den
Cluster auf dem Gerät, das Sie weiterhin verwenden wollen und stellen
Sie auf dem anderen Gerät anschließend den Werkszustand wieder her.
:::

::: paragraph
Nachdem Sie einen Knoten aus dem Cluster getrennt haben, werden die
Monitoring-Instanzen nicht automatisch gestartet. Das müssen Sie im
Anschluss bei Bedarf manuell erledigen.
:::
:::::::::::

::::: sect2
### []{#_ein_gerät_austauschen .hidden-anchor .sr-only}6.4. Ein Gerät austauschen {#heading__ein_gerät_austauschen}

::: paragraph
Wenn die Festplatten des alten Geräts in Ordnung sind, können Sie diese
aus dem alten Gerät in das neue Gerät einbauen und das neue Gerät genau
so verkabeln, wie das alte Gerät verkabelt war --- und es anschließend
einschalten. Nach dem Start fügt sich das neue Gerät wieder so in den
Cluster ein wie das alte Gerät.
:::

::: paragraph
Wenn Sie ein altes Gerät komplett durch ein neues Gerät ersetzen wollen,
sollten Sie so vorgehen, wie wenn Sie den [Cluster komplett
auflösen.](#dissolve) Wählen Sie dazu eines der bisherigen Geräte aus,
lösen Sie dieses aus dem Cluster und erstellen Sie einen neuen Cluster
mit diesem und dem neuen Gerät.
:::
:::::
:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#_fehlerdiagnose .hidden-anchor .sr-only}7. Fehlerdiagnose {#heading__fehlerdiagnose}

:::::: sectionbody
::::: sect2
### []{#_logging .hidden-anchor .sr-only}7.1. Logging {#heading__logging}

::: paragraph
Die Cluster-Verwaltung geschieht weitestgehend automatisch. Dabei
entscheiden automatische Prozesse auf den Knoten, auf welchem Gerät
welche Ressourcen gestartet und gestoppt werden sollen. Dieses Verhalten
wird in Form von Log-Einträgen detailliert protokolliert. Diese Einträge
erreichen Sie von der Cluster-Seite aus über den Knopf [Cluster
Log.]{.guihint}
:::

::: paragraph
Beachten Sie, dass diese Einträge, genau wie die anderen
Systemmeldungen, bei einem Neustart des Geräts verloren gehen. Wenn Sie
die Meldungen darüber hinaus erhalten möchten, können Sie sich die
aktuelle Logdatei über Ihren Browser herunterladen oder dauerhaft eine
Weiterleitung der Log-Meldungen an einen Syslog-Server einrichten.
:::
:::::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
