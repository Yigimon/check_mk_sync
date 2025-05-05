:::: {#header}
# Ports

::: details
[Last modified on 20-Aug-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/ports.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Grundsätzliches zur Installation von Checkmk](install_packages.html)
[Die Konfiguration von Checkmk](wato.html)
[Monitoring-Agenten](wato_monitoringagents.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#_übersicht .hidden-anchor .sr-only}1. Übersicht {#heading__übersicht}

::::::: sectionbody
::: paragraph
Für die Überwachung von Hosts und Services sowie die Kommunikation
verschiedener Komponenten einer Checkmk-Installation untereinander
verwendet Checkmk in vielen Fällen Datenübertragung über TCP/IP oder
UDP/IP.
:::

::: paragraph
Dieser Artikel soll Ihnen einen Überblick geben, welche Ports für welche
Funktionalität benötigt werden. Diese Ports müssen daher in der
Firewall-Konfiguration freigeschaltet werden, respektive beim Einsatz
von Checkmk in einem Container an diesen gebunden werden.
:::

::: paragraph
Die Kommunikationsrichtung ist, wenn nicht anders erwähnt, eingehend zur
in der Kapitelüberschrift genannten Komponente.
:::

::: paragraph
**Hinweis:** Die Mehrheit der hier aufgeführten Portnummern sind
Standardports. Diese können jederzeit manuell auf andere Ports
umgestellt werden. Diejenigen Ports, die nicht standardmäßig aktiv sind,
sondern stattdessen bei Bedarf freigegeben werden müssen, sind
zusätzlich mit einem Vermerk gekennzeichnet.
:::
:::::::
::::::::

:::::::::: sect1
## []{#_überwachung_von_hosts_agent_snmp .hidden-anchor .sr-only}2. Überwachung von Hosts (Agent, SNMP) {#heading__überwachung_von_hosts_agent_snmp}

::::::::: sectionbody
::::: sect2
### []{#host_incoming_cmk_outgoing .hidden-anchor .sr-only}2.1. Überwachter Host {#heading_host_incoming_cmk_outgoing}

::: paragraph
Die folgenden Ports auf überwachten Hosts müssen vom Checkmk-Server aus
erreichbar sein.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 161  | UDP  | [Simple Network           | Via SNMP überwachte Hosts |
|      |      | Management Protocol       | erhalten über diesen Port |
|      |      | (                         | die Anforderung           |
|      |      | SNMP)](glossar.html#snmp) | `GET-REQUEST`.            |
+------+------+---------------------------+---------------------------+
| 6556 | TCP  | [A                        | Via                       |
|      |      | gent](glossar.html#agent) | [Checkmk-Agent](wato_moni |
|      |      |                           | toringagents.html#agents) |
|      |      |                           | überwachte Hosts werden   |
|      |      |                           | über diesen Port          |
|      |      |                           | abgefragt. Die            |
|      |      |                           | Kommunikation erfolgt TLS |
|      |      |                           | verschlüsselt oder im     |
|      |      |                           | Klartext (wie beim        |
|      |      |                           | [Linux-Agenten im         |
|      |      |                           | Legacy-Modus](a           |
|      |      |                           | gent_linux_legacy.html)). |
+------+------+---------------------------+---------------------------+
| ---  | ICMP | Ping                      | Checkmk überwacht die     |
|      |      |                           | Erreichbarkeit von Hosts  |
|      |      |                           | per Ping. Ist dies nicht  |
|      |      |                           | möglich, muss die         |
|      |      |                           | Ermittlung des            |
|      |      |                           | Host-Zustands mit der     |
|      |      |                           | Regel [[Host Check        |
|      |      |                           | Comma                     |
|      |      |                           | nd]{.guihint}](hosts_setu |
|      |      |                           | p.html#monitoring_agents) |
|      |      |                           | festgelegt werden.        |
+------+------+---------------------------+---------------------------+

::: paragraph
[Aktive Checks](glossar.html#active_check) greifen direkt auf die Ports
der überwachten Dienste zu, die daher auch vom Checkmk-Server aus
erreichbar sein müssen. Die Überwachung mit
[Spezialagenten](glossar.html#special_agent) kann erfordern,
andere/weitere Ports zu öffnen. So benötigt der Spezialagent für VMware
ESXi (auch NetApp und viele weitere) die Öffnung des Ports 443 auf dem
ESXi Server.
:::
:::::

::::: sect2
### []{#cmk_incoming_host_outgoing .hidden-anchor .sr-only}2.2. Checkmk-Server {#heading_cmk_incoming_host_outgoing}

::: paragraph
Die folgenden Ports auf dem Checkmk-Server müssen für die Hosts im
Monitoring erreichbar sein.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 80   | TCP  | Hypertext Transfer        | [Agent                    |
|      |      | Protocol (HTTP)           | Updater](gl               |
|      |      |                           | ossar.html#agent_updater) |
|      |      |                           | ([Agentenbäckerei](glo    |
|      |      |                           | ssar.html#agent_bakery)), |
|      |      |                           | Discovery des Agent       |
|      |      |                           | Controller Ports          |
+------+------+---------------------------+---------------------------+
| 162  | UDP  | Simple Network Management | Empfang von [SNMP-Traps   |
|      |      | Protocol Trap (SNMPTRAP)  | über die Event            |
|      |      | EC                        | Console](ec.html#snmp)    |
|      |      |                           | *(optional aktivierbar)*  |
+------+------+---------------------------+---------------------------+
| 443  | TCP  | Hypertext Transfer        | Agent Updater             |
|      |      | Protocol over SSL/TLS     | (Agentenbäckerei),        |
|      |      | (HTTPS)                   | Discovery des Agent       |
|      |      |                           | Controller Ports, mit     |
|      |      |                           | Transportverschlüsselung  |
+------+------+---------------------------+---------------------------+
| 514  | TCP  | Syslog (EC)               | Empfang von               |
|      | und  |                           | [Syslog-Nachrichten über  |
|      | UDP  |                           | die Event                 |
|      |      |                           | Console](ec.html#setup)   |
|      |      |                           | *(optional aktivierbar)*  |
+------+------+---------------------------+---------------------------+
| 6559 | UDP  | [Echtzeitprüfunge         | Empfang von UDP-Paketen   |
|      |      | n](https://checkmk.com/we | für die Echtzeitprüfungen |
|      |      | rk/8350){target="_blank"} | einzelner Dienste (selten |
|      |      |                           | verwendet, *optional      |
|      |      |                           | aktivierbar*)             |
+------+------+---------------------------+---------------------------+
| 8000 | TCP  | Agent Controller          | Wenn mehrere Instanzen    |
|      |      | TLS-Registrierung,        | auf dem Checkmk-Server    |
|      |      | Agenten im                | laufen, sind eventuell    |
|      |      | [Push-Modus               | weitere Ports (8001,      |
|      |      | ](glossar.html#push_mode) | 8002...) nötig.           |
+------+------+---------------------------+---------------------------+

::: paragraph
Die TLS-Registrierung von Agenten nutzt die REST-API auf Port 80/443 zur
Discovery des Ports zur Registrierung (meist 8000 TCP). Sind beide nicht
erreichbar, kann der Port per
[Kommandozeilenoption](agent_linux.html#networkrequirements) angegeben
werden. Falls Port 8000 nicht erreichbar ist, kann auf anderen Hosts im
Monitoring eine [Registrierung im
Auftrag](agent_linux.html#proxyregister) erfolgen.
:::
:::::
:::::::::
::::::::::

::::::::: sect1
## []{#_verteiltes_monitoring .hidden-anchor .sr-only}3. Verteiltes Monitoring {#heading__verteiltes_monitoring}

:::::::: sectionbody
:::: sect2
### []{#remote_incoming_cmk_outgoing .hidden-anchor .sr-only}3.1. Remote-Instanz {#heading_remote_incoming_cmk_outgoing}

::: paragraph
Die folgenden Ports auf Remote-Instanzen müssen vom als Zentralinstanz
arbeitenden Checkmk-Server erreichbar sein.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 80   | TCP  | HTTPS (Hypertext Transfer | Synchronisierung im       |
|      |      | Protocol)                 | [verteilten               |
|      |      |                           | Monitoring](glossar.htm   |
|      |      |                           | l#distributed_monitoring) |
+------+------+---------------------------+---------------------------+
| 443  | TCP  | Hypertext Transfer        | Synchronisierung im       |
|      |      | Protocol over SSL/TLS     | verteilten Monitoring,    |
|      |      | (HTTPS)                   | mit                       |
|      |      |                           | Transportverschlüsselung  |
+------+------+---------------------------+---------------------------+
| 6555 | TCP  | Benachrichtigungs-Spooler | Der                       |
|      |      | (*notification spooler*)  | [Benachrichtigungs-S      |
|      |      |                           | pooler](distributed_monit |
|      |      |                           | oring.html#notifications) |
|      |      |                           | dient dem zentralen       |
|      |      |                           | Versand von               |
|      |      |                           | Benachrichtigungen, hier  |
|      |      |                           | beim Verbindungsaufbau    |
|      |      |                           | durch die Zentralinstanz  |
|      |      |                           | *(optional aktivierbar)*  |
+------+------+---------------------------+---------------------------+
| 6557 | TCP  | [Livestatus]              | Wenn mehrere Instanzen    |
|      |      | (glossar.html#livestatus) | auf dem Checkmk-Server    |
|      |      |                           | laufen, sind eventuell    |
|      |      |                           | weitere Ports nötig       |
|      |      |                           | *(optional aktivierbar)*  |
+------+------+---------------------------+---------------------------+
| 6558 | TCP  |                           | Statusanschluss der Event |
|      |      |                           | Console *(optional        |
|      |      |                           | aktivierbar)*             |
+------+------+---------------------------+---------------------------+
::::

::::: sect2
### []{#cmk_incoming_remote_outgoing .hidden-anchor .sr-only}3.2. Zentralinstanz {#heading_cmk_incoming_remote_outgoing}

::: paragraph
Prinzipiell ist verteiltes Monitoring ohne weitere Hilfsmittel wie
Tunneling bereits möglich, wenn die Zentralinstanz eine Verbindung zu
den Remote-Instanzen herstellen kann. Die Erreichbarkeit der
Zentralinstanz durch Remote-Instanzen ist nur für optionale
Funktionalitäten (z.B. Agentenbäckerei) erforderlich.
:::

::: paragraph
Die folgenden Ports auf dem als Zentralinstanz arbeitenden
Checkmk-Server müssen durch die zugeordneten Remote-Instanzen erreichbar
sein, um die beschriebene Funktionalität bereitzustellen.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 80   | TCP  | Hypertext Transfer        | Für                       |
|      |      | Protocol (HTTP)           | [Agentenbäckerei](g       |
|      |      |                           | lossar.html#agent_bakery) |
|      |      |                           | und [dynamische           |
|      |      |                           | Host                      |
|      |      |                           | -Konfiguration](dcd.html) |
+------+------+---------------------------+---------------------------+
| 443  | TCP  | Hypertext Transfer        | Für Agentenbäckerei und   |
|      |      | Protocol over SSL/TLS     | dynamische                |
|      |      | (HTTPS)                   | Host-Konfiguration, mit   |
|      |      |                           | Transportverschlüsselung  |
+------+------+---------------------------+---------------------------+
| 6555 | TCP  | Benachrichtigungs-Spooler | Der                       |
|      |      | (*notification spooler*)  | [Benachrichtigungs-S      |
|      |      |                           | pooler](distributed_monit |
|      |      |                           | oring.html#notifications) |
|      |      |                           | dient dem zentralen       |
|      |      |                           | Versand von               |
|      |      |                           | Benachrichtigungen, hier  |
|      |      |                           | beim Verbindungsaufbau    |
|      |      |                           | durch eine Remote-Instanz |
|      |      |                           | *(optional aktivierbar)*  |
+------+------+---------------------------+---------------------------+
:::::
::::::::
:::::::::

::::: sect1
## []{#loopback .hidden-anchor .sr-only}4. Lokale Ports auf dem Checkmk-Server {#heading_loopback}

:::: sectionbody
::: paragraph
Die folgenden Ports werden vom Checkmk-Server auf dem lokalen Loopback
Interface genutzt. Falls Sie auf Ihrem Checkmk-Server eine sehr strenge
Firewall-Konfiguration verwenden, müssen diese Ports auf der IP-Adresse
127.0.0.1 (IPv4), respektive ::1 (IPv6) eingehend und ausgehend
freigeschaltet werden.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 5000 | TCP  | HTTP Site Apache          | Jede Checkmk-Instanz      |
|      |      |                           | verfügt über einen        |
|      |      |                           | eigenen Apache, auf den   |
|      |      |                           | der extern aufrufbare     |
|      |      |                           | Apache als Reverse Proxy  |
|      |      |                           | zugreift. Weitere         |
|      |      |                           | Instanzen verwenden Port  |
|      |      |                           | 5001 usw.                 |
+------+------+---------------------------+---------------------------+
| 6558 | TCP  |                           | Statusanschluss der Event |
|      |      |                           | Console *(optional        |
|      |      |                           | aktivierbar)*             |
+------+------+---------------------------+---------------------------+
::::
:::::

::::: sect1
## []{#loopbackwindows .hidden-anchor .sr-only}5. Lokaler Port auf Windows-Hosts {#heading_loopbackwindows}

:::: sectionbody
::: paragraph
Der folgende Port wird auf Windows-Hosts im Monitoring zur Kommunikation
der beiden Komponenten *Agentenprogramm* und *Agent Controller* genutzt.
Falls Sie auf dem überwachten Host eine sehr strenge
Firewall-Konfiguration verwenden, muss dieser Port auf der IP-Adresse
127.0.0.1 (IPv4), respektive ::1 (IPv6) eingehend und ausgehend
freigeschaltet werden.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 2    | TCP  | Checkmk-Agent             | Das Agentenprogramm       |
| 8250 |      |                           | öffnet den Port. Der für  |
|      |      |                           | die verschlüsselte        |
|      |      |                           | Kommunikation mit dem     |
|      |      |                           | Checkmk-Server zuständige |
|      |      |                           | Agent Controller          |
|      |      |                           | `cmk-agent-ctl.exe`       |
|      |      |                           | greift auf ihn zu.        |
+------+------+---------------------------+---------------------------+
::::
:::::

::::::: sect1
## []{#appliance_cluster .hidden-anchor .sr-only}6. Checkmk Appliance Cluster {#heading_appliance_cluster}

:::::: sectionbody
::: paragraph
Sie können zwei Checkmk-Appliances (\"Knoten\") zu einem
[Cluster](appliance_cluster.html) zusammenschließen. Dabei werden alle
Konfigurationen und Daten zwischen den beiden Geräten abgeglichen.
:::

::: paragraph
Die folgenden Ports müssen von beiden Knoten aus ein- und ausgehend
freigegeben sein.
:::

::: paragraph
**Achtung!** Da die Kommunikation der beiden Appliances miteinander
unverschlüsselt stattfindet, müssen Sie gegebenenfalls Maßnahmen
ergreifen, damit unbefugte Dritte keinen Zugriff auf den Netzwerkverkehr
haben. Dies kann beispielsweise die direkte Verbindung beider Geräte in
einem Rack sein oder die Nutzung eines verschlüsselten VLAN, wenn keine
räumliche Nähe erwünscht ist.
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 3121 | TCP  | Pacemaker                 | Pacemaker Cluster         |
|      |      |                           | resource manager          |
+------+------+---------------------------+---------------------------+
| 4321 | UDP  | Corosync                  | Corosync Cluster Engine   |
+------+------+---------------------------+---------------------------+
| 4323 | UDP  | Corosync                  | Corosync Cluster Engine   |
+------+------+---------------------------+---------------------------+
| 7789 | TCP  | DRBD                      | Synchronisierung der DRBD |
|      |      |                           | (Distributed Replicated   |
|      |      |                           | Block Device)             |
+------+------+---------------------------+---------------------------+
::::::
:::::::

::::: sect1
## []{#misc_ports .hidden-anchor .sr-only}7. Erreichbare Ports (ausgehend) {#heading_misc_ports}

:::: sectionbody
::: paragraph
Eventuell benötigen Sie, vom Checkmk-Server ausgehend, einige weitere
Ports:
:::

+------+------+---------------------------+---------------------------+
| Port | P    | Bezeichnung               | Ergänzende Informationen  |
|      | roto |                           |                           |
|      | koll |                           |                           |
+======+======+===========================+===========================+
| 53   | UDP  | DNS                       | Die systemweit            |
|      |      |                           | konfigurierten Nameserver |
|      |      |                           | müssen erreichbar sein    |
+------+------+---------------------------+---------------------------+
| 123  | UDP  | NTP                       | Zeitsynchronisation       |
+------+------+---------------------------+---------------------------+
| 25   | TCP  | SMTP                      | Versand von               |
| /465 |      |                           | Benachrichtigungen vom    |
| /587 |      |                           | Checkmk-Server über       |
|      |      |                           | E-Mail (Ports je nach     |
|      |      |                           | Konfiguration des         |
|      |      |                           | verwendeten Mailservers)  |
+------+------+---------------------------+---------------------------+
| 443  | TCP  | HTTPS                     | Kommunikation mit dem     |
|      |      |                           | [Li                       |
|      |      |                           | zenzserver](license.html) |
|      |      |                           | (nur kommerzielle         |
|      |      |                           | Editionen, Server:        |
|      |      |                           | `license.checkmk.com`,    |
|      |      |                           | Alternative: [manuelle    |
|      |      |                           | Übermittlung](l           |
|      |      |                           | icense.html#manualtrans)) |
+------+------+---------------------------+---------------------------+
| 389  | TCP  | LDAP                      | LDAP Authentifizierung    |
| /636 |      |                           | (Port 389 TCP, als LDAPS  |
|      |      |                           | auf Port 636 TCP)         |
+------+------+---------------------------+---------------------------+
::::
:::::
::::::::::::::::::::::::::::::::::::::::::::
