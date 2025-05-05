:::: {#header}
# Überwachen via SNMP

::: details
[Last modified on 05-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/snmp.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Die Event
Console](ec.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Was ist SNMP? {#heading_intro}

::::::::::::::: sectionbody
::::::: sect2
### []{#_snmp_anstelle_des_checkmk_agenten .hidden-anchor .sr-only}1.1. SNMP anstelle des Checkmk-Agenten {#heading__snmp_anstelle_des_checkmk_agenten}

::: paragraph
Router, Switches, Firewalls, Drucker, Appliances, USVs, Hardwaresensoren
und viele andere Geräte erlauben keine Installation eines
Checkmk-Agenten. Dafür haben sie aber bereits vom Hersteller aus eine
eingebaute Schnittstelle für das Monitoring: einen *SNMP-Agenten*.
Dieser ist über das *Simple Network Management Protocol (SNMP)*
erreichbar. Checkmk nutzt SNMP, um solche Geräte zu überwachen. Der
Vorteil für Sie: Das Einrichten der Überwachung ist sehr einfach.
:::

::: paragraph
Es gibt übrigens auch SNMP-Agenten für Windows und Linux. Es ist
allerdings nicht zu empfehlen, diese *anstelle* des Checkmk-Agenten zu
nutzen. SNMP ist nicht sehr performant und für die Überwachung benötigt
der Checkmk-Server generell mehr CPU und Speicher pro Host, als wenn er
mit seinem eigenen Agenten arbeitet. Außerdem sind die per SNMP
bereitgestellten Daten unvollständig. In einigen Fällen kann allerdings
die Überwachung per SNMP **zusätzlich** zum Checkmk-Agenten sinnvoll
sein. Im Kapitel über [SNMP und Checkmk-Agent](#snmp_cmk_agent) finden
Sie mehr zu diesem Thema.
:::

::: paragraph
Sollte allerdings für eine Hard- oder Software-Komponente
(beispielsweise ein RAID-Controller) kein Checkmk-Agenten-Plugin zur
Überwachung, dafür jedoch eine SNMP-Schnittstelle existieren, können Sie
selbstverständlich über SNMP zusätzliche Monitoring-Daten erheben.
Achten Sie in diesem Fall auf hinreichend lange Abfrageintervalle.
:::

::: paragraph
Das Überwachen von SNMP-Geräten mit Checkmk ist sehr einfach. Wenn Sie
einfach nur schnell mit SNMP starten möchten, genügt Ihnen
wahrscheinlich der kurze Abschnitt über SNMP im [Leitfaden für
Einsteiger.](intro_setup_monitor.html#snmp) Dieser Artikel hingegen geht
deutlich mehr in die Tiefe und zeigt Ihnen alle Einzelheiten und
Sonderfälle der SNMP-Überwachung mit Checkmk.
:::
:::::::

:::: sect2
### []{#_snmp_versionen .hidden-anchor .sr-only}1.2. SNMP-Versionen {#heading__snmp_versionen}

::: paragraph
Das SNMP-Protokoll gibt es in verschiedenen Versionen. Diese sind nicht
miteinander kompatibel, und so müssen sich das Monitoring-System und das
überwachte Gerät immer einig sein, welche Protokollversion sie gerade
verwenden. Checkmk unterstützt die Versionen v1, v2c und v3. In der
Praxis wird in geschätzt 99 % der Fälle v2c eingesetzt. Hier ist eine
Übersicht über alle relevanten Versionen von SNMP:
:::

+------+-------------+------+------------------------------------------+
| Ver  | Features    | Che  | Bedeutung in der Praxis                  |
| sion |             | ckmk |                                          |
+======+=============+======+==========================================+
| **   |             | ja   | Findet man nur bei sehr alten Geräten    |
| v1** |             |      | (eher 15 Jahre und älter), die v2c nicht |
|      |             |      | unterstützen oder deren                  |
|      |             |      | v2c-Unterstützung Fehler hat.            |
+------+-------------+------+------------------------------------------+
| **v  | Bulk        | ja   | Dies ist der Standard in der Praxis. v2c |
| 2c** | -Abfragen,\ |      | ist eine „Light"-Variante von v2, und    |
|      | 64-         |      | das „c" steht hier für „Community", die  |
|      | Bit-Counter |      | bei SNMP die Rolle eines Passworts       |
|      |             |      | spielt. Die 64-Bit-Counter sind          |
|      |             |      | essenziell bei der Überwachung von       |
|      |             |      | Switch Ports mit 1 Gbit/s und mehr. Die  |
|      |             |      | Bulk-Abfragen beschleunigen das          |
|      |             |      | Monitoring um bis zu Faktor 10.          |
+------+-------------+------+------------------------------------------+
| **   | Security    | nein | Version 2 bietet zusätzlich zu den       |
| v2** |             |      | Features von v2c noch bessere            |
|      |             |      | Security-Möglichkeiten. In der Praxis    |
|      |             |      | ist Version 2 von SNMP nicht             |
|      |             |      | anzutreffen. Deswegen unterstützt        |
|      |             |      | Checkmk diese Protokollversion nicht.    |
|      |             |      | Wenn Sie Security benötigen, verwenden   |
|      |             |      | Sie stattdessen [Version 3](#v3).\       |
|      |             |      | **Achtung:** Da die „echte" Version 2    |
|      |             |      | keine Relevanz hat, sprechen viele       |
|      |             |      | Masken in Checkmk einfach von v2, meinen |
|      |             |      | dann aber immer v2c.                     |
+------+-------------+------+------------------------------------------+
| **   | Security,\  | ja   | [Version 3](#v3) kommt zum Einsatz, wenn |
| v3** | Kontexte    |      | der SNMP-Datenverkehr verschlüsselt      |
|      |             |      | werden soll. Bei v2c und v1 läuft dieser |
|      |             |      | im Klartext --- inklusive der Community. |
|      |             |      | In der Praxis ist Version 3 eher weniger |
|      |             |      | verbreitet, weil diese Version deutlich  |
|      |             |      | mehr Rechenleistung benötigt und auch    |
|      |             |      | der Aufwand für die Konfiguration        |
|      |             |      | deutlich höher ist als bei v2c. Die      |
|      |             |      | *Kontexte* sind ein Konzept, bei dem im  |
|      |             |      | gleichen Bereich der SNMP-Datenstruktur  |
|      |             |      | (OID) je nach Kontext-ID                 |
|      |             |      | unterschiedliche Informationen sichtbar  |
|      |             |      | sind. Dies wird zum Beispiel beim        |
|      |             |      | Partitionieren von                       |
|      |             |      | Fibre-Channel-Switches verwendet.        |
+------+-------------+------+------------------------------------------+
::::

::::::: sect2
### []{#_snmp_traps .hidden-anchor .sr-only}1.3. SNMP-Traps {#heading__snmp_traps}

::: paragraph
Checkmk nutzt für die SNMP-Überwachung *aktive Anfragen* -- also eine
Pull-Methode. Dabei sendet Checkmk ein UDP-Paket (Port 161) mit einer
SNMP-Anfrage an das Gerät mit der Bitte, bestimmte Daten zu liefern. Das
Gerät antwortet dann seinerseits mit einem UDP-Paket, das die Daten
(oder eine Fehlermeldung) enthält.
:::

::: paragraph
Aber SNMP hat noch eine zweite Spielart: *SNMP-Traps.* Das sind spontane
Meldungen, die Geräte an konfigurierte Adressen per UDP (Port 162) im
Push-Verfahren versenden. Traps haben viele Nachteile gegenüber aktiven
Anfragen, weswegen sie für das Monitoring keine große Bedeutung haben.
Einige der Nachteile von SNMP-Traps sind:
:::

::: ulist
- Traps sind nicht zuverlässig. UDP-Pakete können verloren gehen. Es
  gibt keine Empfangsquittung.

- Meist werden nur *Fehler*-Meldungen versendet, aber keine
  *Recovery*-Meldungen. Somit ist der aktuelle Status im Monitoring
  unklar.

- Wenn Tausende von Switches gleichzeitig Traps senden (z.B. wenn für
  diese ein wichtiger Upstream-Dienst nicht verfügbar ist), kann der
  Trap-Empfänger sich dieser nicht erwehren und unter der Last
  einbrechen. Dann ist das Monitoring genau dann überlastet, wenn man es
  am meisten brauchen würde.

- Bei einer Änderung der IP-Adresse des Trap-Empfängers müssen alle
  Geräte neu konfiguriert werden.

- Traps sind nur schwer testbar. Die wenigsten Geräte haben überhaupt
  eine Funktion, um eine generische Test-Trap zu versenden --- vom Test
  realer Fehlermeldungen ganz zu schweigen. Daher kann man nur schwer
  vorhersagen, ob eine wichtige Trap dann richtig verarbeitet wird, wenn
  es nach ein paar Monaten oder Jahren das erste Mal soweit ist.
:::

::: paragraph
Falls Sie dennoch mit Traps arbeiten wollen oder müssen, bietet die
[Event Console](ec.html#snmp) dafür eine Lösung: Sie kann Traps
empfangen und daraus Events generieren.
:::
:::::::
:::::::::::::::
::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#snmphost .hidden-anchor .sr-only}2. Einrichten von SNMP in Checkmk {#heading_snmphost}

:::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#enable_snmp .hidden-anchor .sr-only}2.1. Gerät vorbereiten {#heading_enable_snmp}

::: paragraph
Der erste Schritt ist das Vorbereiten des Gerätes. Jedes Gerät, das SNMP
unterstützt, hat in seiner Konfiguration dafür irgendwo eine Maske.
Nehmen Sie dort folgende Einstellungen vor:
:::

::: {.olist .arabic}
1.  Gehen Sie zur Konfiguration für *aktive* Abfragen (SNMP GET).
    (Verwechseln Sie das nicht mit den Traps. Die Begrifflichkeit in den
    Konfigurationsdialogen kann sehr verwirrend sein.)

2.  Aktivieren Sie SNMP für *lesende* Anfragen.

3.  Tragen Sie als erlaubte IP-Adressen die Adressen Ihrer
    Checkmk-Server ein. Es kann auch nützlich sein, hier noch eine
    Testinstanz von Checkmk vorzusehen. Wichtig: Falls Sie mehrere
    redundante Checkmk-Server betreiben, vergessen Sie nicht, auch die
    IP-Adressen anzugeben, die nach einem Failover verwendet werden.
    Speziell bei der Checkmk-Appliance ist es so, dass diese im
    Cluster-Betrieb als Quell-IP-Adresse bei ausgehenden Verbindungen
    jeweils die IP-Adresse des aktiven Nodes verwendet --- und nicht die
    Service-IP-Adresse. In einer [verteilten
    Umgebung](distributed_monitoring.html) ist die IP-Adresse derjenigen
    Remote-Instanz entscheidend, von der aus das Gerät überwacht wird.

4.  Vergeben Sie eine *Community,* wenn die Protokollversionen v1 und
    v2c verwendet werden.
:::

::: paragraph
Die Community ist eine Art Passwort, nur mit dem Unterschied, dass es
bei SNMP keinen Benutzernamen gibt. Es gibt eine Konvention, nach der
die Community `public` lautet. Das ist bei vielen Geräten --- und auch
bei Checkmk --- der Standard. Nun kann man natürlich argumentieren, dass
das unsicher ist und man eine andere Community vergeben sollte.
Allerdings wird bei SNMP die Community im Klartext übertragen (außer bei
[SNMP Version 3](#v3)). Jeder, der Pakete mithören kann, kann also sehr
einfach die Community herausfinden. Andererseits haben Sie den Zugriff
ja auf reine Lesezugriffe begrenzt, und meist sind die Informationen,
die man per SNMP abrufen kann, nicht sehr kritisch.
:::

::: paragraph
Ferner führt die Verwendung von *unterschiedlichen* Communities bei
mehreren Geräten zu einer sehr umständlichen Handhabung. Denn diese
müssen ja dann nicht nur in den Geräten gepflegt werden, sondern auch im
Monitoring-System. Deswegen ist es in der Praxis so, dass Anwender meist
überall die gleiche Community verwenden --- oder zumindest überall in
einer Region, einer Abteilung, einem Rechenzentrum etc.
:::

::: paragraph
**Tipp:** Wenn Sie die Sicherheit auch ohne SNMP Version 3 erhöhen
möchten, ist es sinnvoll, das Netzwerkkonzept so zu erweitern, dass man
den Datenverkehr mit den Management-Diensten (und somit auch SNMP) in
ein eigenes Management-VLAN legt und den Zugriff darauf via Firewall
absichert.
:::
::::::::

:::::::::::::::::: sect2
### []{#add_device .hidden-anchor .sr-only}2.2. Gerät in Checkmk aufnehmen {#heading_add_device}

::: paragraph
Nehmen Sie die zu überwachenden Geräte in Checkmk wie gewohnt als Hosts
auf. Wenn Sie Ihre Ordnerstruktur so gewählt haben, dass in einem Ordner
jeweils nur SNMP-Geräte sind, dann können Sie die weiteren Einstellungen
direkt am Ordner vornehmen. Das vereinfacht später das Aufnehmen von
weiteren Hosts und vermeidet zudem Fehler.
:::

:::: imageblock
::: content
![Aufnahme eines Hosts ins Monitoring per
SNMP.](../images/snmp_host_configuration.png)
:::
::::

::: paragraph
Setzen Sie jetzt in den Eigenschaften des Hosts (oder Ordners) im Kasten
[Monitoring agents]{.guihint} die Einstellung [Checkmk agent / API
integrations]{.guihint} auf [No API integrations, no Checkmk
agent.]{.guihint}
:::

::: paragraph
Im selben Kasten aktivieren Sie außerdem den Punkt [SNMP]{.guihint} und
wählen als SNMP-Protokoll [SNMP v2 or v3]{.guihint} aus. Die Auswahl von
Protokollversion 1 ist nur für *sehr* alte Geräte eine Notlösung. Sie
sollten das nur dann verwenden, wenn Sie wissen, das v2 wirklich nicht
unterstützt wird oder die Implementierung auf dem Gerät dafür defekt ist
(dies kann in der Praxis vereinzelt vorkommen). SNMP in Version 1 ist
vor allem sehr langsam, da sie keine Bulk-Zugriffe unterstützt -- der
Unterschied ist gravierend.
:::

::: paragraph
Die dritte Einstellung heißt [SNMP credentials]{.guihint}. Hier ist
zunächst wieder eine Wahl der Protokollversion notwendig, da sich v2c
und v3 voneinander unterscheiden. Die Version 3 erläutern wir [weiter
unten](#v3). Wenn Sie nicht sehr hohe Sicherheitsanforderungen haben,
liegen Sie mit v2c richtig, bzw. können die SNMP-Kommunikation in ein
Management-VLAN legen und so absichern. SNMP v2c erfordert die Eingabe
der oben besprochenen Community.
:::

::: paragraph
Für die Konfiguration der SNMP-Credentials gibt es noch einen
alternativen Weg, falls Sie diese nicht einfach über ihre Ordnerstruktur
vererben können: den [Regelsatz](wato_rules.html) [Setup \> Agents \>
SNMP rules \> SNMP credentials of monitored hosts]{.guihint}. Damit
können Sie die Credentials anhand von Host-Merkmalen,
[Labels](labels.html) und ähnlichen Eigenschaften vergeben. Dabei gilt
der Grundsatz, dass eine Community, die direkt beim Host oder Ordner
festgelegt ist, immer Vorrang hat vor den Regeln.
:::

:::::::::: sect3
#### []{#snmp_cmk_agent .hidden-anchor .sr-only}Überwachung per SNMP und Checkmk-Agent {#heading_snmp_cmk_agent}

::: paragraph
Gelegentlich kommt die Frage auf, ob es nicht möglich oder sogar
sinnvoll wäre, Linux oder Windows mit SNMP statt mit dem Checkmk-Agenten
zu überwachen. Die Antwort ist sehr einfach: möglich ja, sinnvoll nein.
Warum?
:::

::: ulist
- Die Monitoring-Daten des SNMP-Agenten sind sehr begrenzt. Daher
  brauchen Sie den Checkmk-Agenten für eine halbwegs sinnvolle
  Überwachung sowieso.

- Der SNMP-Agent liefert keine sinnvollen Daten, die nicht auch der
  Checkmk-Agent liefern würde.

- Der SNMP-Agent ist umständlicher aufzusetzen.

- Nicht zuletzt braucht das Protokoll SNMP deutlich mehr CPU- und
  Netzwerkressourcen als die normale Überwachung mit Checkmk.
:::

::: paragraph
Es gibt allerdings ein paar wenige Situationen, in denen eine
Überwachung per SNMP **zusätzlich** zum Checkmk-Agenten sinnvoll sein
kann. Das kann dann sowohl den Checkmk-Agenten für
[Linux](agent_linux.html) als auch für [Windows](agent_windows.html)
betreffen. Ein typisches Beispiel ist, dass für eine Software- oder
Hardware-Komponente (beispielsweise einen RAID-Controller) ein Tool des
Server-Herstellers installiert ist und Überwachungsdaten nur per SNMP
liefert, wie das z.B. bei Fujitsu ServerView der Fall ist. Dann können
Sie selbstverständlich über SNMP zusätzliche Monitoring-Daten erheben.
Achten Sie in diesem Fall auf hinreichend lange Abfrageintervalle. Bei
Windows kann es außerdem vorkommen, dass  eine Abfrage über PowerShell
nicht möglich ist --- aufgrund der eingesetzten Windows-Version oder
weil es für die Anwendung keine Cmdlets gibt.
:::

::: paragraph
Falls Sie in so einem Fall den Linux- oder Windows-Host per
Checkmk-Agent **und** SNMP überwachen wollen, gehen Sie wie folgt vor:
Setzen Sie in den Eigenschaften des Hosts im [Setup]{.guihint}-Menü im
Kasten [Monitoring agents]{.guihint} die Option [Checkmk agent / API
integrations]{.guihint} auf einen Wert mit Checkmk-Agent ([API
integrations if configured, else Checkmk agent]{.guihint} oder
[Configured API integrations and Checkmk agent]{.guihint}). Im gleichen
Kasten aktivieren Sie die Option [SNMP]{.guihint} und setzen den Wert
auf [SNMP v2 or v3]{.guihint} bzw. [SNMP v1]{.guihint}, wie oben
beschrieben:
:::

:::: imageblock
::: content
![Aufnahme eines Hosts ins Monitoring per Checkmk-Agent und
SNMP.](../images/snmp_host_agent_and_snmp_configuration.png)
:::
::::

::: paragraph
Services, die sowohl per SNMP als auch per Checkmk-Agent verfügbar sind
(z.B. CPU-Auslastung, Dateisysteme, Netzwerkkarten), werden dann
automatisch vom Checkmk-Agenten geholt und nicht per SNMP. Damit wird
eine Doppelübertragung automatisch vermieden.
:::
::::::::::
::::::::::::::::::

::::::::: sect2
### []{#_diagnose .hidden-anchor .sr-only}2.3. Diagnose {#heading__diagnose}

::: paragraph
Wenn Sie mit den Einstellungen fertig sind, bietet sich der kleine Umweg
über die Diagnoseseite an. Dazu speichern Sie mit dem Aktionsknopf [Save
& go to connection test.]{.guihint} Hier ist ein Beispiel der Diagnose
für einen Switch. Dabei werden verschiedene Protokollversionen von SNMP
gleichzeitig ausprobiert und zwar:
:::

::: ulist
- SNMP v1

- SNMP v2c

- SNMP v2c ohne Bulk-Anfragen

- SNMP v3
:::

::: paragraph
Ein normales modernes Gerät sollte auf alle vier Varianten mit den
gleichen Daten antworten, wobei das je nach Konfiguration eingeschränkt
sein kann. Das sieht dann z.B. so aus:
:::

:::: imageblock
::: content
![Ausgabe der SNMP v2c Diagnose.](../images/snmp_diagnostics.png)
:::
::::

::: paragraph
Die ausgegebenen vier Informationen bedeuten im Einzelnen:
:::

+-----------------+-----------------------------------------------------+
| `sysDescr`      | Die Beschreibung des Geräts, wie sie vom Hersteller |
|                 | in der Firmware fest eingebrannt ist. Dieser Text   |
|                 | ist für Checkmk sehr wichtig für die automatische   |
|                 | Service-Erkennung.                                  |
+-----------------+-----------------------------------------------------+
| `sysContact`    | Dieses Feld ist vorgesehen für die Angabe einer     |
|                 | Kontaktperson und wird in der Konfiguration des     |
|                 | Gerätes von Ihnen festgelegt.                       |
+-----------------+-----------------------------------------------------+
| `sysName`       | Hier steht der Host-Name des Gerätes. Auch dieses   |
|                 | Feld wird im Gerät konfiguriert. Für das Monitoring |
|                 | spielt der Name keine weitere Rolle und wird nur    |
|                 | informativ angezeigt. Es ist aber durchaus sinnvoll |
|                 | und hilfreich, wenn der Host-Name mit dem           |
|                 | Host-Namen in Checkmk übereinstimmt.                |
+-----------------+-----------------------------------------------------+
| `sysLocation`   | Das ist ein Feld für eine rein informative Angabe,  |
|                 | und Sie können einen frei wählbaren Text zum        |
|                 | Standort des Gerätes eintragen.                     |
+-----------------+-----------------------------------------------------+
:::::::::

:::::::::::::::::: sect2
### []{#services .hidden-anchor .sr-only}2.4. Die Service-Konfiguration {#heading_services}

::::::::: sect3
#### []{#_besonderheiten_bei_snmp_geräten .hidden-anchor .sr-only}Besonderheiten bei SNMP-Geräten {#heading__besonderheiten_bei_snmp_geräten}

::: paragraph
Nach dem Speichern der Host-Eigenschaften (und optional der Diagnose)
ist wie gewohnt der nächste Schritt die [Konfiguration der
Services.](wato_services.html) Dort gibt es einige Besonderheiten, denn
bei SNMP-Geräten erfolgt die Service-Erkennung intern ganz anders als
bei Hosts, die mit dem Checkmk-Agenten überwacht werden. Checkmk kann
bei diesen einfach in die Ausgabe des Agenten schauen und
darin --- mithilfe der einzelnen Check-Plugins --- die interessanten
Punkte finden. Bei SNMP ist etwas mehr Arbeit notwendig. Zwar könnte
Checkmk bei der Erkennung einen kompletten Abzug aller SNMP-Daten
(SNMP-Walk) machen und darin nach interessanten Informationen Ausschau
halten. Aber es gibt Geräte, bei denen dann eine einzige Erkennung
mehrere Stunden dauern würde!
:::

::: paragraph
Daher geht Checkmk intelligenter vor. Es ruft zunächst vom Gerät nur die
allerersten beiden Datensätze (OIDs) auf: die `sysDescr` und
`sysObjectID`. Danach folgen je nach Bedarf daraus resultierende weitere
Abfragen. Anhand der Ergebnisse entscheidet dann jedes der fast 1 000
mitgelieferten SNMP-Check-Plugins, ob das Gerät dieses Plugin überhaupt
unterstützt. Diese Phase nennt Checkmk den *SNMP-Scan.* Als Ergebnis
gibt die Software eine Liste von Check-Plugins aus, die als Kandidaten
für die eigentliche Service-Erkennung dienen.
:::

::: paragraph
In einem zweiten Schritt läuft dann die eigentliche Erkennung. Die
gefundenen Plugins rufen per örtlich begrenzten SNMP-Abfragen gezielt
genau die Daten ab, die sie benötigen, und ermitteln daraus die zu
überwachenden Services. Die abgerufenen Daten sind genau die gleichen,
die später auch regelmäßig für die Überwachung geholt werden.
:::

::: paragraph
Bei Geräten im LAN dauert der ganze Vorgang in der Regel nicht sehr
lange --- mehrere Sekunden sind schon eher die Ausnahme. Wenn Sie aber
Geräte über WAN-Strecken mit einer hohen Latenz überwachen, kann der
komplette Scan einige Minuten dauern. Auch bei Switches mit Hunderten
von Ports dauert der Scan natürlich länger. Nun wäre es sehr
unpraktisch, wenn Sie jedes Mal, wenn Sie die Seite der Services öffnen,
so lange warten müssten.
:::

::: paragraph
Daher überspringt das Setup den Scan im Normalfall und macht die
Erkennung nur mit den Check-Plugins, die bei dem Host aktuell schon zum
Einsatz kommen. Die SNMP-Walks liegen dann bereits durch das normale
Monitoring als Cache-Dateien vor, und die Erkennung dauert nicht lange.
Nun können Sie so zwar neue Einträge von bestehenden Plugins finden
(z.B. neue Switch Ports, Festplatten, Sensoren, VPNs usw.), aber keine
ganz *neuen Plugins.*
:::

::: paragraph
Der Knopf [Full service scan]{.guihint} erzwingt einen SNMP-Scan und
anschließendes Holen von frischen Daten via SNMP. Dadurch werden dann
auch Services von ganz neuen Plugins gefunden. Bei langsam antwortenden
Geräten kann eine Wartezeit entstehen.
:::
:::::::::

:::::::::: sect3
#### []{#_standard_services .hidden-anchor .sr-only}Standard-Services {#heading__standard_services}

::: paragraph
Egal, welches Gerät Sie per SNMP überwachen, es sollten zumindest die
folgenden drei Services in der Konfiguration auftauchen:
:::

:::: imageblock
::: content
![Anzeige der drei Standard-Services, die jedes SNMP Gerät aufweisen
sollte.](../images/snmp_standard_services.png)
:::
::::

::: paragraph
Das Erste ist ein Check, der die Netzwerkports überwacht. Und zumindest
einen muss das Gerät haben (und der muss auch aktiv sein) --- sonst
würde ja SNMP auch nicht funktionieren. Generell ist Checkmk dabei so
voreingestellt, dass es alle Ports in die Überwachung aufnimmt, die zum
Zeitpunkt der Service-Erkennung aktiv sind (operational status „up").
Sie können das mit dem Regelsatz [Setup \> Services \> Service discovery
rules \> Network interface and switch port discovery]{.guihint}
beeinflussen.
:::

::: paragraph
Im Leitfaden für Einsteiger finden Sie übrigens ein Kapitel mit
Handlungsempfehlungen zum [Konfigurieren von Switch
Ports.](intro_finetune.html#switchports)
:::

::: paragraph
Das zweite ist der Service [SNMP Info,]{.guihint} der die gleichen vier
Informationen anzeigt, die Sie auch bei der Diagnose gesehen haben. Er
hat rein informelle Funktion und ist immer [OK]{.state0}.
:::

::: paragraph
Und schließlich gibt es den Service [Uptime,]{.guihint} der Ihnen zeigt,
wann das Gerät zum letzten mal neu gestartet wurde. Dieser Service ist
in der Voreinstellung immer [OK]{.state0}; Sie können aber untere und
obere Schwellwerte für die Uptime setzen.
:::
::::::::::
::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::: sect1
## []{#cursedhardware .hidden-anchor .sr-only}3. Wenn Geräte Probleme machen {#heading_cursedhardware}

::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::: sect2
### []{#_defekte_snmp_implementierungen .hidden-anchor .sr-only}3.1. Defekte SNMP-Implementierungen {#heading__defekte_snmp_implementierungen}

::: paragraph
Es scheint tatsächlich so zu sein, dass jeder denkbare Fehler, den man
beim Implementieren von SNMP machen kann, auch von irgendeinem
Hersteller irgendwann gemacht wurde. Und so gibt es Geräte, bei denen
SNMP zwar einigermaßen funktioniert, aber bestimmte Teile des Protokolls
nicht oder falsch umgesetzt wurden.
:::

::: paragraph
Treten die Probleme mit den kommerziellen Editionen zu Tage, kann ein
Grund darin liegen, dass die dort standardmäßig aktivierte,
performantere [Inline-SNMP](#performance) Implementierung sich stärker
auf die Einhaltung von Standards verlässt, als `snmpget`. Antworten
Geräte überhaupt nicht, oder nicht zuverlässig, hilft es mitunter,
Inline-SNMP für betroffene Geräte abzuschalten und damit das etwas
robustere und deutlich langsamere `snmpget` zu aktivieren.
:::

::: paragraph
Hierfür steht für Tests auf der Kommandozeile dem Befehl `cmk` für
einige Optionen die Zusatzoption `--snmp-backend` zur Verfügung, welche
als Parameter `inline` (Verwendung von inline SNMP), `classic`
(Verwendung von `snmpget`) oder `stored-walk` (Verwendung eines
hinterlegten [SNMP-Walks](#simulation)) akzeptiert. War der Test auf der
Kommandozeile erfolgreich, können Sie mit dem Regelsatz [Hosts not using
Inline-SNMP]{.guihint} die Hosts bestimmen, welche dauerhaft kein
Inline-SNMP nutzen sollen.
:::

:::: sect3
#### []{#_keine_antwort_auf_anfrage_nach_sysdescr .hidden-anchor .sr-only}Keine Antwort auf Anfrage nach „sysDescr" {#heading__keine_antwort_auf_anfrage_nach_sysdescr}

::: paragraph
Ein möglicher Fehler ist, wenn SNMP-Agenten nicht auf die Anfrage nach
den Standardinformationen wie z.B. der `sysDescr` antworten. Diese
Geräte sind in der Diagnose wie tot. Und auch in der Service-Erkennung
werden sie keine Resultate liefern, wenn Sie nicht durch eine spezielle
Konfiguration nachhelfen. Legen Sie dazu für die betroffenen Hosts eine
Regel an unter [Setup \> Agents \> SNMP rules \> Hosts without system
description OID]{.guihint} mit der Option [Positive match (Add matching
hosts to the set)]{.guihint}. Checkmk geht dann einfach davon aus, dass
alles in Ordnung ist und überspringt den Test mit der `sysDescr`. Zwar
werden dann auch keine Check-Plugins erkannt, die bestimmte Teile in
diesem Text erwarten, aber das spielt in der Praxis keine Rolle, da die
betroffenen Plugins so entwickelt wurden, dass sie diesen Fall
berücksichtigen.
:::
::::

:::::::: sect3
#### []{#_snmp_v2c_geht_aber_bulk_anfragen_scheitern .hidden-anchor .sr-only}SNMP v2c geht, aber Bulk-Anfragen scheitern {#heading__snmp_v2c_geht_aber_bulk_anfragen_scheitern}

::: paragraph
Einige Geräte unterstützen zwar Version v2c --- und werden in der
Diagnose darauf auch eine Antwort liefern --- allerdings fehlt im
Protokoll die Umsetzung des Befehls `GetBulk`. Dieser wird von Checkmk
dazu verwendet, mit einer Anfrage möglichst viele Informationen auf
einmal zu bekommen; er ist daher sehr wichtig für die Performance.
:::

::: paragraph
Bei einem solchen Host werden auch einige einfache SNMP-Checks
funktionieren, wie z.B die [SNMP Info]{.guihint} oder die [SNMP
Uptime]{.guihint}. Aber andere Services fehlen --- insbesondere die
Netzwerkschnittstellen, die eigentlich bei jedem Gerät vorhanden sein
müssen.
:::

::: paragraph
Falls Sie tatsächlich einen Host haben, bei dem das so ist, können Sie
diesen mit v2c, aber ohne Bulk-Anfragen betreiben. Konfigurieren Sie
einen solchen Host wie folgt:
:::

::: {.olist .arabic}
1.  Setzen Sie bei den Host-Eigenschaften die SNMP-Version auf [SNMP
    v1.]{.guihint}

2.  Legen Sie im Regelsatz [Setup \> Agents \> SNMP rules \> Legacy SNMP
    devices using SNMP v2c]{.guihint} eine Regel für den Host an und
    stellen Sie in der Regel den Wert auf [Positive match (Add matching
    hosts to the set)]{.guihint}.
:::

::: paragraph
Dadurch wird der Host gezwungen, trotz eingestellter Version 1 das
Protokoll SNMP v2c zu verwenden, allerdings *ohne Bulkwalk.* Wir
empfehlen übrigens nicht den Einsatz von SNMP v1 --- selbst wenn das
Protokoll unterstützt würde, denn hier werden keine 64-Bit-Counter
unterstützt. Das kann zu fehlenden oder fehlerhaften Messdaten bei
Netzwerkports führen, über die viel Verkehr läuft.
:::
::::::::

::::: sect3
#### []{#_geräte_die_sehr_langsam_antworten .hidden-anchor .sr-only}Geräte, die sehr langsam antworten {#heading__geräte_die_sehr_langsam_antworten}

::: paragraph
Es gibt Geräte, bei denen manche SNMP-Abfragen sehr sehr lange brauchen.
Teilweise liegt das an fehlerhaften Implementierungen. Hier kann es
helfen, auf SNMP v1 zurückzugehen (was normalerweise viel langsamer ist,
aber manchmal immer noch schneller als ein kaputtes SNMP v2c). Bevor Sie
das versuchen, sollten Sie jedoch prüfen, ob der Hersteller ein
Firmware-Upgrade bereitstellt, welches das Problem löst.
:::

::: paragraph
Eine zweite Ursache kann sein, dass das Gerät sehr viele Switch Ports
hat und gleichzeitig eine langsame SNMP-Implementierung. Falls Sie von
den Ports nur sehr wenige überwachen möchten (z.B. nur die ersten
beiden), können Sie Checkmk manuell auf die Abfrage von einzelnen Ports
begrenzen. Details finden Sie weiter unten im Abschnitt zu
[Performance.](#performance)
:::
:::::
:::::::::::::::::

:::::::::::: sect2
### []{#_es_werden_nur_die_standard_services_gefunden .hidden-anchor .sr-only}3.2. Es werden nur die Standard-Services gefunden {#heading__es_werden_nur_die_standard_services_gefunden}

::: paragraph
Wenn Sie ein SNMP-Gerät in die Überwachung aufnehmen und Checkmk erkennt
lediglich die Services [SNMP Info,]{.guihint} [SNMP Uptime]{.guihint}
und die Interfaces, so kann das verschiedene Ursachen haben:
:::

::::: sect3
#### []{#_a_es_gibt_keine_plugins .hidden-anchor .sr-only}a) Es gibt keine Plugins {#heading__a_es_gibt_keine_plugins}

::: paragraph
Checkmk liefert fast 1 000 Check-Plugins für SNMP-Geräte aus, aber
natürlich ist selbst diese Liste nie vollständig. So kommt es immer
wieder vor, dass Checkmk für bestimmte Geräte keine spezifischen Plugins
mit ausliefert und Sie dann nur die besagten Standard-Services
überwachen können. Hier haben Sie folgende Möglichkeiten:
:::

::: ulist
- Eventuell werden Sie auf der Website [Checkmk
  Exchange](https://exchange.checkmk.com){target="_blank"} fündig, wo
  Anwender ihre eigenen Plugins veröffentlichen können.

- Sie entwickeln selbst Plugins. Dazu finden Sie in diesem Handbuch
  [Artikel.](devel_intro.html)

- Sie kontaktieren unseren Support oder einen unserer Partner und geben
  die Entwicklung der passenden Plugins in Auftrag.
:::
:::::

:::: sect3
#### []{#_b_die_erkennung_der_plugins_funktioniert_nicht .hidden-anchor .sr-only}b) Die Erkennung der Plugins funktioniert nicht {#heading__b_die_erkennung_der_plugins_funktioniert_nicht}

::: paragraph
Manchmal kommt es vor, dass eine neuere Firmware von einem Gerät dazu
führt, dass Checkmk-Plugins das Gerät nicht mehr erkennen --- z.B. weil
sich in der Systembeschreibung des Geräts ein Text geändert hat. In
diesem Fall müssen die bestehenden Plugins angepasst werden.
Kontaktieren Sie dafür unseren Support.
:::
::::

::::: sect3
#### []{#_c_das_gerät_liefert_die_benötigen_daten_nicht_aus .hidden-anchor .sr-only}c) Das Gerät liefert die benötigen Daten nicht aus {#heading__c_das_gerät_liefert_die_benötigen_daten_nicht_aus}

::: paragraph
Manche (wenige) Geräte haben in ihrer SNMP-Konfiguration die
Möglichkeit, den Zugriff auf bestimmte Informationsbereiche einzeln zu
konfigurieren. Eventuell ist Ihr Gerät so eingestellt, dass zwar die
Standardinformationen geliefert werden, aber nicht die Bereiche für die
gerätespezifischen Services.
:::

::: paragraph
Bei einigen wenigen Geräten müssen Sie SNMP v3 und [Kontexte](#contexts)
verwenden, um an die gewünschten Daten zu kommen.
:::
:::::
::::::::::::

::::: sect2
### []{#_geräte_die_gar_nicht_auf_snmp_antworten .hidden-anchor .sr-only}3.3. Geräte, die gar nicht auf SNMP antworten {#heading__geräte_die_gar_nicht_auf_snmp_antworten}

::: paragraph
Falls der Ping geht, aber keine einzige SNMP-Protokollversion
funktioniert, gibt es mehrere mögliche Ursachen:
:::

::: ulist
- Das Gerät ist überhaupt nicht per IP erreichbar. Das können Sie mit
  dem Ping-Test (erster Kasten) überprüfen.

- Das Gerät unterstützt überhaupt kein SNMP.

- Die SNMP-Freigabe ist nicht korrekt konfiguriert (Aktivierung,
  erlaubte Adressen, Community).

- Eine Firewall unterbindet SNMP. Sie benötigen die Freischaltung von
  UDP Port 161 in beide Richtungen.
:::
:::::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::

:::::::::::::::: sect1
## []{#v3 .hidden-anchor .sr-only}4. SNMP v3 {#heading_v3}

::::::::::::::: sectionbody
::::::::: sect2
### []{#_security .hidden-anchor .sr-only}4.1. Security {#heading__security}

::: paragraph
SNMP ist standardmäßig unverschlüsselt und nur sehr schwach
authentifiziert durch eine im Klartext übertragene Community. Für ein
lokales abgeschottetes Netzwerk ist dieses Niveau eventuell trotzdem
ausreichend, da für das Monitoring der Zugriff auf rein lesende
Operationen beschränkt ist.
:::

::: paragraph
Wenn Sie trotzdem ein höheres Sicherheitsniveau möchten, dann benötigen
Sie SNMP in der Version 3. Diese bietet Verschlüsselung und eine echte
Authentifizierung. Allerdings ist dafür auch eine entsprechende
Konfiguration notwendig.
:::

::: paragraph
SNMP v3 kennt verschiedene Stufen der Sicherheit:
:::

+---------+------------------------------------------------------------+
| `noAuth | Keine echte Benutzer-basierte Authentifizierung, keine     |
| NoPriv` | Verschlüsslung. Der Vorteil gegenüber v2c ist, dass das    |
|         | Passwort nicht mehr im Klartext, sondern gehasht           |
|         | übertragen wird.                                           |
+---------+------------------------------------------------------------+
| `auth   | Benutzer-basierte Authentifizierung mit Name ([Security    |
| NoPriv` | name]{.guihint}) und Passwort, trotzdem keine              |
|         | Verschlüsselung.                                           |
+---------+------------------------------------------------------------+
| `au     | Benutzer-basierte Authentifizierung wie bei `authNoPriv`,  |
| thPriv` | und zusätzlich werden alle Daten verschlüsselt. Hierzu     |
|         | müssen Sie manuell einen Schlüssel austauschen und ihn     |
|         | sowohl im Gerät als auch in Checkmk hinterlegen.           |
+---------+------------------------------------------------------------+

::: paragraph
Die Sicherheitsstufe konfigurieren Sie da, wo Sie auch die Community
eingestellt haben, also entweder bei den Host-Eigenschaften oder in der
Regel [SNMP credentials of monitored hosts.]{.guihint} Dort wählen Sie
anstelle von [SNMP Community]{.guihint} eine der drei Stufen von v3 aus
und konfigurieren die notwendigen Werte:
:::

:::: imageblock
::: content
![Konfiguration der SNMP v3
Sicherheitseinstellungen.](../images/snmp_credentials_v3.png)
:::
::::
:::::::::

::::::: sect2
### []{#contexts .hidden-anchor .sr-only}4.2. Kontexte {#heading_contexts}

::: paragraph
SNMP v3 führt das Konzept der *Kontexte* ein. Dabei kann ein Gerät an
derselben Stelle im SNMP-Baum unterschiedliche Informationen
zeigen --- je nachdem, welche *Kontext-ID* bei der Abfrage mitgegeben
wird.
:::

::: paragraph
Falls Sie ein Gerät haben, das mit solchen Kontexten arbeitet, benötigen
Sie in Checkmk zwei Einstellungen:
:::

::: ulist
- Zunächst muss das Gerät mit SNMP v3 abgefragt werden (wie im
  vorherigen Abschnitt beschrieben).

- Dann benötigen Sie noch eine Regel im Regelsatz [SNMPv3 contexts to
  use in requests]{.guihint}. Hier wählen Sie das Check-Plugin aus, für
  das Kontexte aktiviert werden sollen, und dann die Liste der Kontexte,
  die im Monitoring abgefragt werden sollen.
:::

::: paragraph
Zum Glück gibt es sehr selten Situationen, in denen man mit Kontexten
arbeiten muss, denn es ist leider nicht möglich, dass das Monitoring
diese automatisch erkennt. Eine manuelle Konfiguration der Kontexte ist
immer notwendig.
:::
:::::::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::: sect1
## []{#performance .hidden-anchor .sr-only}5. Performance und Timing {#heading_performance}

::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_inline_snmp .hidden-anchor .sr-only}5.1. Inline-SNMP {#heading__inline_snmp}

::: paragraph
Performance spielt immer eine Rolle --- vor allem in Umgebungen mit
vielen Hosts. Und die Überwachung mit SNMP benötigt mehr CPU und
Speicher als die mit Checkmk-Agenten.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Während Checkmk
Raw SNMP-Anfragen auf klassische Weise über die Kommandozeilenbefehle
`snmpget` bzw. `snmpbulkwalk` macht, haben die kommerziellen Editionen
eine eingebaute SNMP-Engine, die SNMP-Anfragen sehr performant
durchführt ohne weitere Prozesse zu erzeugen. Die CPU-Last für die
SNMP-Verarbeitung halbiert sich dadurch in etwa. Und durch die kürzeren
Abfragezeiten reduziert sich auch die Anzahl der gleichzeitig benötigten
Checkmk-Prozesse und damit auch der Speicherbedarf.
:::
:::::

:::::: sect2
### []{#_check_intervals_for_snmp_checks .hidden-anchor .sr-only}5.2. Check intervals for SNMP checks {#heading__check_intervals_for_snmp_checks}

::: paragraph
Falls Sie mit Ihren Ressourcen an die Grenzen stoßen bzw. die Abfrage
eines einzelnen Gerätes länger als 60 Sekunden dauert, können Sie das
Intervall reduzieren, mit dem Checkmk den oder die Hosts abfragt. Mit
dem Regelsatz [Normal check interval for service checks,]{.guihint} den
Sie gezielt auf die Checkmk-Services von Hosts anwenden, können Sie das
generelle Intervall von einer Minute auf z.B. 2 oder 5 Minuten
verlängern.
:::

::: paragraph
Speziell für SNMP-Checks gibt es darüber hinaus noch den Regelsatz
[Check intervals for SNMP checks.]{.guihint} Mit diesem können Sie das
Intervall für *einzelne* Check-Plugins herabsetzen. Wichtig ist, dass
Sie es nie schneller einstellen können, als es das Intervall für die
generelle Überwachung durch den Checkmk-Service vorgibt.
:::

::: paragraph
Insgesamt empfehlen wir aber, das Monitoring so auszulegen, dass das
Standardintervall von einer Minute beibehalten werden kann und nur in
Ausnahmefällen für einzelne Hosts oder Checks erhöht wird.
:::
::::::

::::::: sect2
### []{#_timing_settings_for_snmp_access .hidden-anchor .sr-only}5.3. Timing settings for SNMP access {#heading__timing_settings_for_snmp_access}

::: paragraph
Standardmäßig erwartet Checkmk auf eine SNMP-Anfrage eine Antwort
innerhalb von einer Sekunde. Außerdem verschickt die Monitoring-Software
insgesamt drei Anfragen, bevor sie aufgibt. Bei Geräten, die nur sehr
langsam antworten oder über ein sehr langsames Netzwerk erreichbar sind,
kann es notwendig sein, diese Parameter zu ändern. Das machen Sie über
den Regelsatz [Timing settings for SNMP access:]{.guihint}
:::

:::: imageblock
::: content
![Erhöhen des Response Timeouts.](../images/snmp_timing_settings.png)
:::
::::

::: paragraph
Beachten Sie, dass sich diese Einstellungen auf eine *einzelne
SNMP-Anfrage* beziehen. Der komplette Überwachungsvorgang eines Hosts
besteht aus vielen Einzelanfragen. Der gesamte Timeout ist daher ein
Vielfaches der hier angegebenen Einstellungen.
:::
:::::::

:::::: sect2
### []{#_bulkwalk_number_of_oids_per_bulk .hidden-anchor .sr-only}5.4. Bulkwalk: Number of OIDs per bulk {#heading__bulkwalk_number_of_oids_per_bulk}

::: paragraph
SNMP überträgt pro `GetBulk`-Anfrage in der Voreinstellung 10 Antworten
in einem Paket. Mit dem experimentellen Regelsatz [Bulk walk: Number of
OIDs per bulk]{.guihint} können Sie ausprobieren, ob ein höherer Wert
eine bessere Performance bringt. Das wird allerdings nur dann der Fall
sein, wenn bei dem Host große Tabellen übertragen werden --- z.B. wenn
es sich um einen Switch mit sehr vielen Ports handelt.
:::

::: paragraph
Das liegt daran, dass SNMP die Pakete immer auf die eingestellte Zahl
mit den jeweils nächsten Datensätzen auffüllt. Und wenn nur wenige
benötigt werden, werden somit nutzlos Daten übertragen, und der Overhead
steigt.
:::

::: paragraph
Andererseits kann es in der Praxis auch vereinzelt vorkommen, dass
Geräte mit dem voreingestellten Wert von 10 OIDs per bulk Probleme
haben. Dann kann es sinnvoll sein, die Anzahl zu senken.
:::
::::::

:::::::::: sect2
### []{#_limit_snmp_oid_ranges .hidden-anchor .sr-only}5.5. Limit SNMP OID Ranges {#heading__limit_snmp_oid_ranges}

::: paragraph
Checkmk arbeitet normalerweise so, dass es immer die Informationen zu
allen Switch Ports holt, auch wenn nicht alle überwacht werden. Das ist
auch gut so, denn im Normalfall ist das schneller, denn Einzelabfragen
können nicht mit den effizienten Bulk-Anfragen gemacht werden. Zudem ist
es aus unserer Sicht sowieso empfehlenswert, grundsätzlich alle Ports zu
überwachen, um defekte Ports oder Kabel mit hohen Fehlerraten zu finden.
Wenn Ports nicht zuverlässig UP sind, können Sie auch den Linkstatus
[DOWN]{.hstate1} als [OK]{.state0} werten lassen.
:::

::: paragraph
Nun gibt es aber Einzelfälle, wo Switches sehr viele Ports haben und aus
irgendeinem Grund nur sehr langsam antworten oder SNMP sehr ineffizient
verarbeiten, so dass eine Überwachung bei einem vollständigen Abrufen
aller Port-Informationen nicht mehr möglich ist.
:::

::: paragraph
Für solche Fälle gibt es den Regelsatz [Bulk walk: Limit SNMP OID
Ranges.]{.guihint} Mit diesem können Sie die Liste der abgefragten Daten
(z.B. Ports) statisch begrenzen. Im Wert der Regel legen Sie jeweils für
ein bestimmtes Check-Plugin fest, welche Indizes der jeweiligen Tabelle
geholt werden sollen.
:::

::: paragraph
Der übliche Check-Typ für Switch Ports heißt [SNMP interface check with
64 bit counters (using v2c).]{.guihint} Folgendes Beispiel zeigt eine
Einstellung, bei der nur die ersten beiden Ports per SNMP geholt werden:
:::

:::: imageblock
::: content
![Bulkwalk: limit SNMP OID ranges.](../images/snmp_limit_oid_ranges.png)
:::
::::

::: paragraph
**Hinweis:** Diese Filterung findet dann quasi *vor* der
Service-Erkennung und dem Monitoring statt. Je nach Einstellung von
[Network interface and switch port discovery]{.guihint} bedeutet das
noch nicht automatisch, dass diese beiden Ports auch wirklich überwacht
werden.
:::
::::::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

::::::::::::::::::::::::::: sect1
## []{#simulation .hidden-anchor .sr-only}6. Simulation durch SNMP-Walks {#heading_simulation}

:::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_prinzip_des_snmp_walks .hidden-anchor .sr-only}6.1. Prinzip des SNMP-Walks {#heading__prinzip_des_snmp_walks}

::: paragraph
Die SNMP-Engine von Checkmk hat ein sehr praktisches Feature: Sie können
von einem überwachten Gerät einen kompletten Abzug aller seiner
SNMP-Daten in eine Datei schreiben lassen (einen *SNMP-Walk*). Diese
Datei können Sie später verwenden, um die Überwachung des Geräts auf
einem anderen Checkmk-Server zu simulieren, auch wenn dieser überhaupt
keine Netzwerkverbindung zu dem Gerät hat.
:::

::: paragraph
Wir verwenden das z.B. ganz intensiv in unserem Support, um für unsere
Kunden neue Check-Plugins zu entwickeln. So benötigen unsere Entwickler
keinen Zugriff auf Ihre Geräte, sondern lediglich einen SNMP-Walk.
:::
:::::

::::::: sect2
### []{#snmpwalks .hidden-anchor .sr-only}6.2. Erstellen eines Walks über die GUI {#heading_snmpwalks}

::: paragraph
Sie können einen SNMP-Walk direkt über die GUI erstellen. Die Funktion
finden Sie im Kontextmenü des Checkmk-Services der Hosts und auch im
Menü der Hosts (Eintrag [![icon agent
output](../images/icons/icon_agent_output.png)]{.image-inline} [Download
SNMP walk]{.guihint}):
:::

:::: imageblock
::: content
![Download des SNMP Walks im Kontextmenü des Hosts in der
Monitoring-Übersicht.](../images/snmp_download_walk.png)
:::
::::

::: paragraph
Die Erstellung des Walks dauert im besten Fall einige Sekunden, ein paar
Minuten sind aber auch nicht ungewöhnlich. Wenn das Erstellen
abgeschlossen ist, können Sie die Datei in der Zeile [Result]{.guihint}
herunterladen.
:::
:::::::

::::::::::::: sect2
### []{#_erstellen_eines_walks_auf_der_kommandozeile .hidden-anchor .sr-only}6.3. Erstellen eines Walks auf der Kommandozeile {#heading__erstellen_eines_walks_auf_der_kommandozeile}

::: paragraph
Alternativ können Sie Walks auch auf der Kommandozeile erzeugen. Melden
Sie sich dazu auf der Instanz an, von der aus das Gerät überwacht wird.
Das Erstellen des Walks geht dort einfach mit dem Befehl
`cmk --snmpwalk` und der Angabe des überwachten Hosts (der dazu im
Monitoring konfiguriert sein muss):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --snmpwalk switch23
```
:::
::::

::: paragraph
Verwenden Sie zusätzlich den Schalter `-v`, um ausführlichere Ausgaben
über den Fortschritt zu sehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --snmpwalk switch23
switch23:
Walk on ".1.3.6.1.2.1"...3664 variables.
Walk on ".1.3.6.1.4.1"...5791 variables.
Wrote fetched data to /omd/sites/mysite/var/check_mk/snmpwalks/switch23.
```
:::
::::

::: paragraph
Die Datei wird dann im Verzeichnis `var/check_mk/snmpwalks` abgelegt und
trägt den Namen des Hosts. Es handelt sich dabei um eine Textdatei. Wenn
Sie neugierig sind, können Sie diese z.B. mit `less` betrachten; Sie
beenden das Programm mit der Taste `Q`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ less var/check_mk/snmpwalks/switch23
.1.3.6.1.2.1.1.1.0 Yoyodyne Frobolator 23 port L2 Managed Switch
.1.3.6.1.2.1.1.2.0 .1.3.6.1.4.1.11863.1.1.3
.1.3.6.1.2.1.1.3.0 560840147
.1.3.6.1.2.1.1.4.0 Zoe Zhang 
.1.3.6.1.2.1.1.5.0 cmkswitch23
.1.3.6.1.2.1.1.6.0 Data Center 42
.1.3.6.1.2.1.1.7.0 3
.1.3.6.1.2.1.2.1.0 27
```
:::
::::

::: paragraph
Der Befehl `cmk --snmpwalk` kennt noch weitere nützliche Optionen:
:::

+-----------------+-----------------------------------------------------+
| Option          | Wirkung                                             |
+=================+=====================================================+
| `--             | Wenn Checkmk einen Walk auf einem Host ausführt,    |
| extraoid <OID>` | dann ruft es generell zwei Teilbäume aus dem        |
|                 | SNMP-Datenbereich ab. Diese werden im SNMP-Baum     |
|                 | über sogenannte *OIDs* (object identifier)          |
|                 | spezifiziert. Diese sind `MIB-2` und                |
|                 | `enterprises` --- also zum einen ein                |
|                 | Standardbereich, der für alle SNMP-Geräte normiert  |
|                 | und gleich ist, und zum anderen ein                 |
|                 | herstellerspezifischer Bereich. Bei einer korrekten |
|                 | Implementierung von SNMP sollte das Gerät *alle*    |
|                 | Daten senden, die es bereitstellt. Falls das nicht  |
|                 | der Fall ist und Sie nach einem bestimmten Bereich  |
|                 | Ausschau halten, können Sie dessen OID mit dieser   |
|                 | Option zum Walk hinzufügen, z.B.                    |
|                 | `cmk --snmpwalk --extraoid .1.2.3.4 switch23`.      |
|                 | Vergessen Sie nicht den Punkt am Anfang der OID.    |
+-----------------+-----------------------------------------------------+
| `--oid`         | Diese Option arbeitet ähnlich wie `--extraoid`,     |
|                 | ruft aber dann *nur* die angegebene OID ab. Dies    |
|                 | ist zu Testzwecken interessant. Beachten Sie, dass  |
|                 | der Walk dann unvollständig ist.                    |
+-----------------+-----------------------------------------------------+
| `-v`            | Das `v` steht für *verbose* und sorgt für einige    |
|                 | informative Ausgaben, während der Walk läuft.       |
+-----------------+-----------------------------------------------------+
| `-vv`           | Das `vv` steht hier für *very verbose* und gibt     |
|                 | noch deutlich mehr Informationen aus.               |
+-----------------+-----------------------------------------------------+
:::::::::::::

:::::: sect2
### []{#_gespeicherte_walks_zur_simulation_verwenden .hidden-anchor .sr-only}6.4. Gespeicherte Walks zur Simulation verwenden {#heading__gespeicherte_walks_zur_simulation_verwenden}

::: paragraph
Wenn Sie nun auf einer anderen (oder auf derselben) Checkmk-Instanz
diesen Walk für eine Simulation verwenden möchten, dann legen Sie die
Walk-Datei auf dieser Instanz wieder unter `var/check_mk/snmpwalks` mit
dem Namen des Hosts ab. Stellen Sie sicher, dass der Instanzbenutzer
Eigentümer der Datei ist und die Berechtigungen auf `0600` (nur der
Eigentümer darf lesen und schreiben) gesetzt sind.
:::

::: paragraph
Legen Sie jetzt eine Regel im Regelsatz [Simulating SNMP by using a
stored SNMP walk]{.guihint} an, die für den oder die betroffenen Hosts
greift.
:::

::: paragraph
Ab sofort wird bei der Überwachung des Hosts nur noch die gespeicherte
Datei verwendet. Es erfolgt kein Netzwerkzugriff auf den Host
mehr --- außer der Ping für den Host Check und eventuell konfigurierte
aktive Checks. Diese können Sie einfach auf den Checkmk-Server umbiegen,
indem Sie den Hosts die IP-Adresse `127.0.0.1` geben.
:::
::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+-----------------+-----------------------------------------------------+
| Pfad            | Bedeutung                                           |
+=================+=====================================================+
| `var/chec       | Hier werden SNMP-Walk-Dateien erzeugt bzw. auch     |
| k_mk/snmpwalks` | erwartet, falls Sie diese zum Simulieren von        |
|                 | SNMP-Daten verwenden möchten.                       |
+-----------------+-----------------------------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
