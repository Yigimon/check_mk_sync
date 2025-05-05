:::: {#header}
# Oracle-Datenbanken überwachen

::: details
[Last modified on 27-Aug-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_oracle.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
überwachen](agent_linux.html) [Windows überwachen](agent_windows.html)
[Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Checkmk bietet Ihnen umfangreiche Möglichkeiten Oracle-Datenbanken zu
überwachen. So können Sie mit dem
[Agentenplugin](glossar.html#agent_plugin) nicht nur Tablespaces oder
die aktiven Sitzungen einer Datenbank abrufen, sondern zusätzlich noch
viele andere Metriken. Eine vollständige Liste der
Überwachungsmöglichkeiten mit unseren
[Check-Plugins](glossar.html#check_plugin) können Sie im [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=oracle){target="_blank"}
nachlesen. Wir erweitern diese Plugins regelmäßig, so dass sich ein
Blick in den Katalog immer wieder lohnt. Unter anderem kann Checkmk die
folgenden Werte überwachen:
:::

::: ulist
- [Oracle Instance: Status of
  Database](https://checkmk.com/de/integrations/oracle_instance){target="_blank"}

- [Oracle Instance: Uptime of
  Database](https://checkmk.com/de/integrations/oracle_instance_uptime){target="_blank"}

- [Oracle Instance: Undo
  Retention](https://checkmk.com/de/integrations/oracle_undostat){target="_blank"}

- [Oracle Database:
  Version](https://checkmk.com/de/integrations/oracle_version){target="_blank"}

- [Oracle Database:
  Jobs](https://checkmk.com/de/integrations/oracle_jobs){target="_blank"}

- [Oracle Database:
  Locks](https://checkmk.com/de/integrations/oracle_locks){target="_blank"}

- [Oracle Database:
  Processes](https://checkmk.com/de/integrations/oracle_processes){target="_blank"}

- [Oracle Database: Number of Active
  Sessions](https://checkmk.com/de/integrations/oracle_sessions){target="_blank"}

- [Oracle Database: Recovery
  Area](https://checkmk.com/de/integrations/oracle_recovery_area){target="_blank"}

- [Oracle Database: Log Switch
  Activity](https://checkmk.com/de/integrations/oracle_logswitches){target="_blank"}

- [Oracle Tablespaces: General
  Information](https://checkmk.com/de/integrations/oracle_tablespaces){target="_blank"}

- [Oracle Tablespaces: Performance
  Data](https://checkmk.com/de/integrations/oracle_performance){target="_blank"}

- [Oracle Database: Long Active
  Sessions](https://checkmk.com/de/integrations/oracle_longactivesessions){target="_blank"}

- [Oracle: Checkpoint and User Managed Backup State of
  Datafiles](https://checkmk.com/de/integrations/oracle_recovery_status){target="_blank"}

- [Oracle Database: Custom
  SQLs](https://checkmk.com/de/integrations/oracle_sql){target="_blank"}

- [Oracle: RMAN Backup
  Status](https://checkmk.com/de/integrations/oracle_rman){target="_blank"}

- [Oracle: ASM Disk
  Groups](https://checkmk.com/de/integrations/oracle_asm_diskgroup){target="_blank"}

- [Oracle Data-Guard: Apply and Transport
  Lag](https://checkmk.com/de/integrations/oracle_dataguard_stats){target="_blank"}
:::

::: paragraph
Um die Datenbanken überwachen zu können, brauchen Sie lediglich das
Agentenplugin zusätzlich zu dem Agenten auf dem Datenbankserver.
Unterstützt werden dafür zur Zeit die Betriebssysteme Linux, Solaris,
AIX und Windows. Das Agentenplugin für Linux, Solaris, AIX heißt
`mk_oracle` und für Windows `mk_oracle.ps1`. Zusätzliche Software wird
weder auf dem Checkmk-Server noch auf dem Datenbankserver für eine
Überwachung benötigt.
:::

::: paragraph
Viele Schritte, um die Überwachung einzurichten, sind zwischen Linux und
Windows gleich. Aus diesem Grund werden zunächst die allgemeinen
Schritte beschrieben, dann die spezifischen für die jeweilige
Betriebssystemgruppe und schließlich die
[Agentenbäckerei](glossar.html#agent_bakery) der kommerziellen
Editionen.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#first_steps .hidden-anchor .sr-only}2. Ersteinrichtung {#heading_first_steps}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die in diesem und den folgenden Kapiteln vorgestellten
Konfigurationsdateien mit Beispielinhalten finden Sie auf dem
Checkmk-Server --- entweder über die [Kommandozeile](#files_cmk) oder
über die Checkmk-Weboberfläche. In Checkmk Raw wählen Sie [Setup \>
Agents]{.guihint} und in den kommerziellen Editionen [Setup \> Agents \>
Windows, Linux, Solaris, AIX \> Related.]{.guihint} In allen Editionen
finden Sie dort Menüeinträge für die unterschiedlichen Betriebssysteme.
Die Konfigurationsdateien finden Sie im Kasten [Example
Configurations.]{.guihint}
:::

:::::::::::::: sect2
### []{#create_user .hidden-anchor .sr-only}2.1. Datenbankbenutzer erstellen {#heading_create_user}

::: paragraph
Prinzipiell ist die erste Einrichtung schnell und in nur drei Schritten
erledigt. Der erste Schritt ist natürlich sicherzustellen, dass es einen
Benutzer gibt, welcher die Datenbanken auch abfragen darf. Sofern Sie
keinen [Real Application Cluster (RAC)](#rac) nutzen, legen Sie dafür in
jeder zu überwachenden Datenbank einen Benutzer an. Wie Sie sich auf
einer Instanz anmelden, unterscheidet sich je nachdem, welches
Betriebssystem Sie einsetzen. Für Linux können Sie das zum Beispiel
erledigen, indem Sie zuerst immer die jeweilige Instanz als
Umgebungsvariable setzen, in der Benutzer angelegt werden soll.
Normalerweise wechselt man dafür zuvor auf den `oracle`-Benutzer. Das
kann sich aber je nach Setup unterscheiden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# su - oracle
oracle@linux$ export ORACLE_SID=MYINST1
```
:::
::::

::: paragraph
Danach melden Sie sich bei der Instanz an und legen einen Benutzer für
das Monitoring an. Um an alle Daten zu kommen, werden auch die
nachfolgenden Berechtigungen benötigt. In dem folgendem Beispiel heißt
der neu angelegte Benutzer `checkmk`. Sie können auch jeden anderen
Namen wählen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
sqlplus> create user checkmk identified by myPassword;
sqlplus> grant select_catalog_role to checkmk;
sqlplus> grant create session to checkmk;
sqlplus> connect checkmk/myPassword
sqlplus> exit
```
:::
::::

::: paragraph
Wie die Anmeldung an einer bestimmten Instanz genau funktioniert, können
Sie in der Oracle-Dokumentation nachlesen.
:::

:::::: sect3
#### []{#_multi_tenant_datenbanken .hidden-anchor .sr-only}Multi-Tenant-Datenbanken {#heading__multi_tenant_datenbanken}

::: paragraph
Man kann auch den Login für
[Multi-Tenant-Datenbanken](https://docs.oracle.com/en/database/oracle/oracle-database/19/multi/introduction-to-the-multitenant-architecture.html){target="_blank"}
konfigurieren. Das wird normalerweise mit einem speziellen Benutzer und
in der Konfiguration mit dem Präfix `C##` durchgeführt. Die
Berechtigungsvergabe unterscheidet sich jedoch leicht von der Anleitung
für normale Benutzer, da Sie diese für alle jetzigen und zukünftigen
Container festlegen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
sqlplus> create user c##checkmk identified by myPassword;
sqlplus> alter user c##checkmk set container_data=all container=current;
sqlplus> grant select_catalog_role to c##checkmk container=all;
sqlplus> grant create session to c##checkmk container=all;
sqlplus> exit
```
:::
::::
::::::
::::::::::::::

:::::::::::: sect2
### []{#user_config .hidden-anchor .sr-only}2.2. Konfiguration erstellen {#heading_user_config}

::: paragraph
Nachdem Sie einen Benutzer angelegt haben, sorgen Sie als Zweites dafür,
dass das Agentenplugin später diese Informationen auch bekommt. Die
einfachste Möglichkeit ist es dann, wenn Sie für alle Instanzen die
gleichen Login-Daten gesetzt haben und einen Standard in der
Konfiguration setzen können. Legen Sie also nun auf dem Oracle-Host die
Konfigurationsdatei `mk_oracle.cfg` für [Linux, AIX, Solaris](#linux)
oder `mk_oracle_cfg.ps1` für [Windows](#windows) an. In dem folgenden
Beispiel sehen Sie die Datei für die Unix-artigen Systeme:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# Syntax:
# DBUSER='USERNAME:PASSWORD'
DBUSER='checkmk:myPassword'
```
:::
:::::

::: paragraph
Für Windows sieht das sehr ähnlich aus. Hier setzen Sie die Variable in
einem PowerShell-Skript:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Syntax:
# $DBUSER = @("USERNAME","PASSWORD")
$DBUSER = @("checkmk","myPassword")
```
:::
:::::

::: paragraph
Der Standardbenutzer ist das Einzige, was das Agentenplugin zwingend
benötigt. Alle anderen Einstellungen, die Sie unter [Unix-artigen
Systemen](#adv_linux) oder unter [Windows](#adv_windows) verwenden
können, sind optional.
:::
::::::::::::

::::::::::::::::::::::::::::::::::: sect2
### []{#oracle_wallet .hidden-anchor .sr-only}2.3. Oracle-Wallet nutzen {#heading_oracle_wallet}

::: paragraph
Alternativ dazu, den Benutzer direkt und mit Passwort in einer
Konfigurationsdatei anzugeben, können Sie auch das *Oracle-Wallet*
nutzen. Das hat den Vorteil, dass Sie nicht mehr die Zugangsdaten
unverschlüsselt sowohl auf dem Checkmk-Server als auch auf dem
Oracle-Host ablegen müssen. Denn selbst wenn Sie die Rechte der
Konfigurationsdatei auf dem Oracle-Host entsprechend angepasst haben,
haben die Zugangsdaten dennoch den Server verlassen und befinden sich
auf dem Checkmk-Server, sofern Sie die [Agentenbäckerei](#bakery)
nutzen.
:::

::: paragraph
Das Oracle-Wallet wiederum legt die Zugangsdaten verschlüsselt auf dem
zu überwachenden Host ab, so dass sie benutzt werden können, aber keine
Login-Daten explizit bekannt gemacht werden müssen. Checkmk kann dieses
Wallet nutzen, so dass die Zugangsdaten prinzipiell nur dem
Datenbankadministrator (DBA) bekannt sein müssen. Dazu legen
Sie --- oder der DBA --- ein Wallet auf dem entsprechenden Server an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mkstore -wrl /etc/check_mk/oracle_wallet -create
```
:::
::::

::: paragraph
Auf diese Datei wird das Agentenplugin später immer dann zugreifen, wenn
eine Verbindung zu einer Instanz hergestellt werden soll. Damit die
nötigen Benutzerdaten auch gefunden werden, müssen Sie diese einmalig in
das Wallet eintragen. In dem folgenden Beispiel fügen Sie also den
Benutzer `checkmk` für die Instanz `MYINST1` hinzu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mkstore -wrl /etc/check_mk/oracle_wallet -createCredential MYINST1 checkmk myPassword
```
:::
::::

::: paragraph
Damit das Agentenplugin weiß, wo es nach dem Wallet suchen muss, muss es
zwei Dateien finden. Die erste Datei ist `sqlnet.ora` in welcher
hinterlegt wird, wo das Wallet zu finden ist. Die zweite
Datei --- `tnsnames.ora` --- bestimmt die Adresse der Instanz, so dass
diese auch über ihren [Alias](#tns_config) angesprochen werden kann.
Damit das Agentenplugin diese Dateien findet, können Sie den Pfad unter
Linux, Solaris und AIX über die Umgebungsvariable
[`TNS_ADMIN`](#tns_config) setzen. Das ist vor allem dann von Vorteil,
wenn die Dateien bereits existieren. Alternativ können Sie sie auch
explizit anlegen. Unter Windows ist es sogar erforderlich, dass Sie
diese manuell bestimmen.
:::

::: paragraph
Legen Sie zunächst die Datei `sqlnet.ora` an. In dieser Datei sucht das
Agentenplugin alternativ nach den Zugangsdaten, so dass hier also der
korrekte Pfad zu der eben erstellten Wallet-Datei angegeben werden muss.
Achten Sie dabei darauf, dass Sie den Parameter `SQLNET.WALLET_OVERRIDE`
auf `TRUE` setzen:
:::

::::: listingblock
::: title
/etc/check_mk/sqlnet.ora
:::

::: content
``` {.pygments .highlight}
LOG_DIRECTORY_CLIENT = /var/log/check_mk/oracle_client
DIAG_ADR_ENABLED = OFF

SQLNET.WALLET_OVERRIDE = TRUE
WALLET_LOCATION =
 (SOURCE=
   (METHOD = FILE)
   (METHOD_DATA = (DIRECTORY=/etc/check_mk/oracle_wallet))
 )
```
:::
:::::

::: paragraph
Jetzt weiß das Plugin, welche Zugangsdaten benutzt werden sollen. Damit
es auch die korrekte Adresse ansteuert, legen Sie als Datei die
`tnsnames.ora` an. Die genaue Syntax können Sie der Oracle-Dokumentation
entnehmen, aber als Beispiel könnte die Datei so aussehen:
:::

::::: listingblock
::: title
/etc/check_mk/tnsnames.ora
:::

::: content
``` {.pygments .highlight}
MYINST1
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = MYINST1_ALIAS)
    )
  )
```
:::
:::::

::: paragraph
Mit diesem Schritt haben Sie die Voraussetzungen geschaffen, um die
Zugangsdaten aus der [Konfigurationsdatei des
Agentenplugins](#user_config) herauszunehmen. Statt den Zugangsdaten
tragen Sie lediglich ein `/` (Schrägstrich) ein:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
DBUSER='/:'
```
:::
:::::

::: paragraph
Sie können dem Wallet natürlich zu einem späteren Zeitpunkt weitere
Zugangsdaten hinzufügen. Lediglich die Datei `tnsnames.ora` muss dann
gegebenenfalls erweitert werden.
:::

::: paragraph
Zum Abschluss ändern Sie die Berechtigungen der in diesem Abschnitt
manuell erstellten Dateien und Verzeichnisse, damit die [Zugriffsrechte
bei der Ausführung](#access_linux) richtig gesetzt sind. Das
Agentenplugin, das als `root` ausgeführt wird, wechselt zum Eigentümer
der Oracle-Binärdateien (z.B. `$ORACLE_HOME/bin/sqlplus`), bevor es
diese ausführt. Zumindest die Gruppe des Eigentümers der
Oracle-Binärdateien benötigt daher lesenden Zugriff auf die manuell
erstellten Dateien in `/etc/check_mk/`. Im folgenden Beispiel nehmen wir
an, dass es sich bei der Gruppe um `oinstall` handelt.
:::

::: paragraph
Die folgenden Kommandos ändern die Gruppe zu `oinstall`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chgrp oinstall /etc/check_mk/sqlnet.ora /etc/check_mk/tnsnames.ora
root@linux# chgrp -R oinstall /etc/check_mk/oracle_wallet
```
:::
::::

::: paragraph
Diese Kommandos stellen dann sicher, dass die Gruppe das Verzeichnis
`oracle_wallet` samt Inhalt lesen kann:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod g+x /etc/check_mk/oracle_wallet
root@linux# chmod -R g+r /etc/check_mk/oracle_wallet
```
:::
::::

::: paragraph
Anschließend sollten die Berechtigungen etwa wie folgt aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# tree -ugpR /etc/check_mk
[drwxr-xr-x root     root    ]  /etc/check_mk
├── [drwxr-x--- root   oinstall ]  oracle_wallet
│   └── [-rw-r----- root   oinstall ]  cwallet.sso
│   └── [-rw-r----- root   oinstall ]  cwallet.sso.lck
│   └── [-rw-r----- root   oinstall ]  ewallet.p12
│   └── [-rw-r----- root   oinstall ]  ewallet.p12.lck
├── [-rw-r--r-- root   oinstall ]  sqlnet.ora
├── [-rw-r--r-- root   oinstall ]  tnsnames.ora
```
:::
::::

::: paragraph
Die Kommandoausgabe zeigt nur die Dateien und Verzeichnisse, um die es
geht.
:::
:::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#linux .hidden-anchor .sr-only}3. Einrichtung für Linux, Solaris, AIX {#heading_linux}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#paths_linux .hidden-anchor .sr-only}3.1. Plugin- und Konfigurationspfade {#heading_paths_linux}

::: paragraph
Unter Unix-artigen Systemen verwendet Checkmk ein einheitliches
Agentenplugin. Das reduziert zum einen den Aufwand der Pflege, da
SQL-Abfragen nicht dupliziert werden müssen, und sorgt zum anderen
dafür, dass Sie nur ein einziges Agentenplugin zu beachten haben. Auf
allen unterstützten Systemen sind die Pfade für die Agenten gleich oder
sehr ähnlich. Konkret benötigen Sie die folgenden Verzeichnisse:
:::

+-----------------+--------------------------+--------------------------+
| Betriebssystem  | Plugin-Pfad              | Konfigurationspfad       |
+=================+==========================+==========================+
| Linux, Solaris, | `/usr/lib/               | `/etc/check_mk/`         |
| AIX             | check_mk_agent/plugins/` |                          |
+-----------------+--------------------------+--------------------------+
| Linux mit       | `/usr/lib/check_         | `/etc/check_mk/`         |
| `systemd`       | mk_agent/plugins/<Zahl>` |                          |
+-----------------+--------------------------+--------------------------+
| AIX             | `/us                     | `/usr/check_mk/conf/`    |
|                 | r/check_mk/lib/plugins/` |                          |
+-----------------+--------------------------+--------------------------+
::::

:::::::: sect2
### []{#install_linux .hidden-anchor .sr-only}3.2. Agentenplugin installieren {#heading_install_linux}

::: paragraph
Nachdem Sie bei der [Ersteinrichtung](#first_steps) einen Benutzer
angelegt und diesen in der Konfigurationsdatei hinterlegt haben,
installieren Sie nun noch das Agentenplugin. Kopieren Sie die Datei
`mk_oracle` vom Checkmk-Server aus dem Verzeichnis
`~/share/check_mk/agents/plugins/` auf den Oracle-Host in das oben
beschriebene Plugin-Verzeichnis.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Das Agentenplugin für Unix-artige |
|                                   | Systeme `mk_oracle` verträgt sich |
|                                   | nicht gut mit `systemd` (siehe    |
|                                   | [Werk                             |
|                                   | #13732](https://checkmk.com/      |
|                                   | de/werk/13732){target="_blank"}). |
|                                   | Auf Systemen mit `systemd` müssen |
|                                   | Sie das Agentenplugin daher       |
|                                   | [asynchron ausführen              |
|                                   | lassen.                           |
|                                   | ](agent_linux.html#async_plugins) |
|                                   | Das heißt, Sie installieren das   |
|                                   | Agentenplugin nicht unter         |
|                                   | `                                 |
|                                   | /usr/lib/check_mk_agent/plugins/` |
|                                   | direkt, sondern in einem          |
|                                   | Unterordner                       |
|                                   | `/usr/lib                         |
|                                   | /check_mk_agent/plugins/<Zahl>/`. |
|                                   | `<Zahl>` meint dabei das          |
|                                   | Ausführungsintervall in Sekunden. |
|                                   | Wir empfehlen die minütliche      |
|                                   | Ausführung, also                  |
|                                   | `/usr                             |
|                                   | /lib/check_mk_agent/plugins/60/`. |
|                                   | Bei der Einrichtung über die      |
|                                   | [Agentenbäckerei](#bakery)        |
|                                   | erledigen Sie das freilich über   |
|                                   | die Option [Host uses xinetd or   |
|                                   | systemd]{.guihint} in der         |
|                                   | Oracle-Regel, bei der             |
|                                   | standardmäßig [xinetd]{.guihint}  |
|                                   | vorgegeben ist.                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Achten Sie darauf, dass das Agentenplugin ausführbar ist und korrigieren
Sie das gegebenenfalls:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cd /usr/lib/check_mk_agent/plugins/
root@linux# ls -lA
-rw-r--r-- 1 root root 120808 Jan 25 11:29 mk_oracle
root@linux# chmod +x mk_oracle
root@linux# ls -lA
-rwxr-xr-x 1 root root 120808 Jan 25 11:29 mk_oracle
```
:::
::::
::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#adv_linux .hidden-anchor .sr-only}3.3. Erweiterte Optionen {#heading_adv_linux}

::: paragraph
In der [Ersteinrichtung](#first_steps) haben Sie bereits erste Variablen
kennengelernt, um Überwachungsdaten von Ihren Oracle-Instanzen zu
bekommen. Je nach Anwendungsszenario werden Sie aber schnell weitere
Möglichkeiten benötigen, um die Überwachung besser und individuell pro
Instanz steuern zu können. Diese Optionen finden Sie in den
nachfolgenden Abschnitten.
:::

:::::::::: sect3
#### []{#adv_user_linux .hidden-anchor .sr-only}Erweiterte Benutzerkonfiguration {#heading_adv_user_linux}

::: paragraph
Mit dem Standard-Login können Sie reguläre oder vielleicht sogar alle
Instanzen einer Datenbank abfragen. Es gibt jedoch Sonderfälle, in denen
Sie für einzelne Instanzen individuelle Zugangsdaten benötigen. In der
Konfigurationsdatei haben Sie daher die folgenden drei Möglichkeiten,
Benutzer anzugeben:
:::

+-----------------+-----------------------------------------------------+
| Parameter       | Beschreibung                                        |
+=================+=====================================================+
| `DBUSER`        | Der Standard, wenn keine individuellen Zugangsdaten |
|                 | für die Datenbankinstanz definiert sind.            |
+-----------------+-----------------------------------------------------+
| `               | Zugangsdaten für eine ganz bestimmte                |
| DBUSER_MYINST1` | Datenbankinstanz, in diesem Fall für die Instanz    |
|                 | `MYINST1`. Die Zugangsdaten werden nur für diese    |
|                 | Instanz benutzt.                                    |
+-----------------+-----------------------------------------------------+
| `ASMUSER`       | Spezielle Zugangsdaten für das Automatic Storage    |
|                 | Management (ASM).\                                  |
|                 | **Wichtig:** Für ein ASM kann immer nur ein Login   |
|                 | angegeben werden.                                   |
+-----------------+-----------------------------------------------------+

::: paragraph
Zusätzlich erlauben diese Variablen noch mehr Optionen außer
Benutzername und Passwort. Sie können auch bestimmen, ob es sich bei dem
Benutzer um einen `SYSDBA` oder `SYSASM` handelt, auf welcher
Kombination von Adresse und Port die Instanz lauscht und sogar, welcher
[TNS-Alias](#tns_config) (`TNSALIAS`) benutzt werden soll. Diese Angaben
sind aber immer --- im Gegensatz zu Benutzer und Passwort --- optional.
Zusätzlich zu dem [obigen Beispiel](#user_config) kann eine
Konfiguration dann so aussehen:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# Syntax
# DBUSER='USERNAME:PASSWORD:ROLE:HOST:PORT:TNSALIAS'
DBUSER='checkmk:myPassword'

DBUSER_MYINST1='cmk_specific1:myPassword1:SYSDBA:localhost:1521'
DBUSER_MYINST2='cmk_specific2:myPassword2::localhost::INST2'

ASMUSER='cmk_asm:myASMPassword:SYSASM'
```
:::
:::::

::: paragraph
Ein paar Erläuterungen zu dem Beispiel:
:::

::: ulist
- Sie können beliebig viele individuelle Zugangsdaten definieren. Diese
  werden immer gegenüber dem Standard bevorzugt.

- Jede Option wird von den anderen durch ein `:` (Doppelpunkt) getrennt.

- Wird ein optionales Feld mittendrin ausgelassen, muss der Doppelpunkt
  geschrieben werden, wie beim Eintrag `DBUSER_MYINST2`, bei dem keine
  Rolle und kein Port angegeben wurde.

- Werden ab einem bestimmten Punkt keine optionalen Felder mehr
  gebraucht, können Sie die Doppelpunkte weglassen, wie beim Eintrag
  `ASMUSER`, bei dem weder Host, Port noch TNS-Alias angegeben wurde.
:::
::::::::::

::::::::::: sect3
#### []{#skip_include .hidden-anchor .sr-only}Instanzen ein- oder ausschließen {#heading_skip_include}

::: paragraph
In manchen Fällen wollen Sie bestimmte Instanzen nicht in die
Überwachung mit einbeziehen. Das kann zum Beispiel sein, weil es nur
eine Spielwiese für Entwickler ist. Um die Konfiguration im Einzelfall
möglichst einfach zu machen, haben Sie verschiedene Möglichkeiten, um
eine oder mehrere Instanzen ganz oder teilweise auszuschließen:
:::

+-----------------+-----------------------------------------------------+
| Parameter       | Beschreibung                                        |
+=================+=====================================================+
| `ONLY_SIDS`     | Hiermit können Sie bestimmen, welche Instanzen      |
|                 | überwacht werden sollen. Eine Instanz wird dabei    |
|                 | durch ihren *System Identifier (SID)* benannt. Es   |
|                 | handelt sich hierbei um eine positive Liste, bei    |
|                 | der alle Instanzen ignoriert werden, die nicht      |
|                 | explizit gelistet sind. Dieser Parameter eignet     |
|                 | sich also sehr gut, wenn die Menge der zu           |
|                 | überwachenden Instanzen kleiner ist, als die Anzahl |
|                 | derer, die ignoriert werden sollen.                 |
+-----------------+-----------------------------------------------------+
| `SKIP_SIDS`     | Im Gegensatz zu `ONLY_SIDS` handelt es sich hier um |
|                 | eine negative Liste, bei der alle Instanzen außer   |
|                 | der hier explizit gelisteten überwacht werden.      |
|                 | Dieser Parameter eignet sich daher sehr gut, wenn   |
|                 | die Anzahl der zu ignorierenden Instanzen kleiner   |
|                 | ist, als diejenige, die überwacht werden soll.      |
+-----------------+-----------------------------------------------------+
| `EXCLUDE_<SID>` | Mit diesem Parameter können Sie eine Instanz        |
|                 | teilweise ausschließen, indem Sie bestimmte         |
|                 | Sektionen der Instanz von der Überwachung           |
|                 | ausschließen. Auf diese Weise definieren Sie eine   |
|                 | Negativliste der Sektionen einer Instanz. Sie       |
|                 | können mit dem Wert `ALL` auch alle Sektionen       |
|                 | ausschließen und erreichen damit dasselbe, als      |
|                 | würden Sie sie die Instanz zu `SKIP_SIDS`           |
|                 | hinzufügen.\                                        |
|                 | **Wichtig:** Für ASM-SIDs können Sie dieses Konzept |
|                 | nicht verwenden, aber Sie können stattdessen        |
|                 | `SKIP_SIDS="+ASM1 …​"` verwenden.                    |
+-----------------+-----------------------------------------------------+

::: paragraph
Sie werden es schon ahnen: Die Reihenfolge der Verarbeitung dieser
Parameter bestimmt das Ergebnis. Tatsächlich werden die Angaben auch
genau in der Reihenfolge *pro Instanz* verarbeitet, wie sie in der
obigen Tabelle angegeben sind. Wenn also die Variable `ONLY_SIDS`
gesetzt ist, wird `SKIP_SIDS` gar nicht mehr ausgewertet und auch nicht
mehr, ob es eine Angabe der Variable `EXCLUDE_<SID>` auf `ALL` für diese
Instanz gibt. Ist `ONLY_SIDS` nicht gesetzt, geht es dann entsprechend
der Reihenfolge weiter. Im Zweifel --- also als
Standardverhalten --- wird die Instanz entsprechend überwacht.
:::

::: paragraph
Am nachfolgenden Beispiel erläutern wir das Verhalten, falls alle
Variablen gesetzt sind:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
ONLY_SIDS='INST1 INST2 INST5'
SKIP_SIDS='INST7 INST3 INST2'
EXCLUDE_INST1='ALL'
EXCLUDE_INST2='tablespaces rman'
```
:::
:::::

::: paragraph
Da die positive Liste aus der ersten Zeile immer bevorzugt wird, wird
die zweite und dritte Zeile nicht mehr ausgewertet. Lediglich die vierte
(letzte) Zeile wird zu einem späteren Zeitpunkt berücksichtigt, da hier
die Instanz nur teilweise ausgewertet werden soll.
:::

::: paragraph
In der Praxis ist es also sinnvoll nur *eine* der Variablen zu nutzen,
um die Menge der zu überwachenden Instanzen zu bestimmen.
:::
:::::::::::

::::::::::::::: sect3
#### []{#sections .hidden-anchor .sr-only}Zu holende Daten bestimmen {#heading_sections}

::: paragraph
Wie Sie bereits im vorherigen Abschnitt gelernt haben, können Sie
Instanzen nicht nur komplett ausschließen, sondern auch lediglich
teilweise überwachen. Die Einsatzzwecke sind vielfältig und vor allem
dann sinnvoll, wenn Sie bestimmte, lang laufende Sektionen nicht überall
berücksichtigen wollen oder auf Testinstanzen nur grundlegende
Informationen benötigen. Um Sektionen global einzuschränken, setzen Sie
die entsprechenden Variablen direkt. Um nur bestimmte Instanzen
einzuschränken, können Sie die Variable `EXCLUDE_<SID>` nutzen, die Sie
im [vorherigen Abschnitt](#skip_include) bereits kennengelernt haben.
Die globalen Variablen sind:
:::

+-----------------+-----------------------------------------------------+
| Parameter       | Beschreibung                                        |
+=================+=====================================================+
| `SYNC_SECTIONS` | Sektionen, die synchron --- das heißt bei jedem     |
|                 | Lauf des Agenten --- abgefragt werden sollen. Da    |
|                 | das Abfrageintervall im Standard bei 60 Sekunden    |
|                 | liegt, müssen die benutzten SQL-Abfragen            |
|                 | entsprechend schnell durchlaufen. Wird die Variable |
|                 | nicht angegeben, werden alle Sektionen abgefragt.   |
+-----------------+-----------------------------------------------------+
| `               | Sektionen, die asynchron --- das heißt nur alle x   |
| ASYNC_SECTIONS` | Minuten --- abgefragt werden sollen. Wie lange die  |
|                 | Daten gültig sind, bestimmt die Variable            |
|                 | `CACHE_MAXAGE` weiter unten in der Tabelle.         |
+-----------------+-----------------------------------------------------+
| `SYN            | Hier greift der gleiche Mechanismus für Sektionen   |
| C_ASM_SECTIONS` | der ASM, der bei der Variablen `SYNC_SECTIONS`      |
|                 | allgemein beschrieben ist.                          |
+-----------------+-----------------------------------------------------+
| `ASYN           | Hier greift der gleiche Mechanismus für Sektionen   |
| C_ASM_SECTIONS` | der ASM, der bei der Variablen `ASYNC_SECTIONS`     |
|                 | allgemein beschrieben ist.                          |
+-----------------+-----------------------------------------------------+
| `CACHE_MAXAGE`  | Mit dieser Variable bestimmen Sie, wie lange        |
|                 | asynchron abgerufene Daten valide sind. Wird die    |
|                 | Variable nicht angegeben, wird ein Standard von 600 |
|                 | Sekunden (10 Minuten) benutzt. Achten Sie darauf,   |
|                 | den Zeitraum nicht kürzer zu wählen, als das        |
|                 | Intervall, mit dem der Checkmk-Agent die Daten      |
|                 | anliefert (standardmäßig 60 Sekunden). Andernfalls  |
|                 | kann es passieren, dass die Daten als veraltet      |
|                 | betrachtet und vom Agenten nicht mitgeliefert       |
|                 | werden.                                             |
+-----------------+-----------------------------------------------------+
| `MAX_TASKS`     | Anzahl der SIDs, die parallel verarbeitet werden.   |
|                 | Der Standardwert ist 1.                             |
+-----------------+-----------------------------------------------------+

::: paragraph
Der Mechanismus erlaubt es demnach, in der Konfigurationsdatei einen
Standard zu setzen und diesen bei Bedarf je Instanz zu überschreiben.
Eine Konfiguration könnte dann zum Beispiel so aussehen:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# DEFAULTS:
# SYNC_SECTIONS="instance sessions logswitches undostat recovery_area processes recovery_status longactivesessions dataguard_stats performance locks"
# ASYNC_SECTIONS="tablespaces rman jobs ts_quotas resumable"
# SYNC_ASM_SECTIONS="instance processes"
# ASYNC_ASM_SECTIONS="asm_diskgroup"
# CACHE_MAXAGE=600

SYNC_ASM_SECTIONS='instance'
ASYNC_SECTIONS='tablespaces jobs rman resumable'

CACHE_MAXAGE=300

EXCLUDE_INST1='undostat locks'
EXCLUDE_INST2='jobs'
```
:::
:::::

::: paragraph
Wie Sie in dem Beispiel sehen, wird für die ASM-Instanzen lediglich die
Sektion `instance` abgefragt und auf allen regulären Instanzen ein
Minimalset für die asynchronen Sektionen angegeben. Zusätzlich wird auf
der Instanz `INST1` auf die synchronen Sektionen `undostat` und `locks`
verzichtet. Da die synchronen Sektionen nicht explizit angegeben wurden,
werden auf allen anderen Instanzen alle synchronen Sektionen abgerufen.
Bei der Instanz `INST2` wiederum werden nur drei der vier asynchronen
Sektionen abgefragt, da `jobs` zusätzlich ausgeschlossen wurde. Und
schließlich wird der Cache von 10 Minuten auf 5 Minuten (300 Sekunden)
heruntergesetzt, da es möglich ist, alle Daten in diesem Zeitraum zu
holen.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Wenn Sie in der                   |
|                                   | Konfigurationsdatei bestimmen,    |
|                                   | welche Sektionen auf welche Weise |
|                                   | abgeholt werden sollen --- Sie    |
|                                   | können ja auch eine asynchrone    |
|                                   | Sektion zu einer synchronen       |
|                                   | machen --- müssen Sie **alle**    |
|                                   | Sektionen angeben, welche in dem  |
|                                   | jeweiligen Bereich ausgeführt     |
|                                   | werden sollen.                    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Wollen Sie zum Beispiel nur `locks` aus der synchronen Abfrage
herausnehmen, geben Sie die gesamte synchrone Liste an und lassen Sie
lediglich `locks` weg:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# Just exclude 'locks' from sync sections:
SYNC_SECTIONS='instance sessions logswitches undostat recovery_area processes recovery_status longactivesessions dataguard_stats performance'
```
:::
:::::

::: paragraph
Gleiches gilt auch für die anderen drei Variablen, in denen die
Sektionen bestimmt werden.
:::
:::::::::::::::

::::::::: sect3
#### []{#tns_config .hidden-anchor .sr-only}TNS-Alias und TNS_ADMIN konfigurieren {#heading_tns_config}

::: paragraph
Der TNS-Alias ist ein benutzerfreundlicher Name für eine
Datenbankverbindung. Dabei steht TNS für die Oracle-Netzwerktechnologie
*Transparent Network Substrate.* Ein TNS-Alias ermöglicht es, eine
Verbindung zu einer Datenbankinstanz herzustellen, ohne jedes Mal die
vollständigen Verbindungsdetails (wie Host-Name, Port-Nummer oder
Service-Name) angeben zu müssen. TNS-Alias werden in der Datei
`tnsnames.ora` festgelegt. Der Abschnitt zur
[Oracle-Wallet](#oracle_wallet) enthält ein Beispiel zur Festlegung
eines TNS-Alias.
:::

::: paragraph
`TNS_ADMIN` ist eine Umgebungsvariable, die auf das Verzeichnis zeigt,
in dem sich Oracle-Konfigurationsdateien wie `sqlnet.ora` und
`tnsnames.ora` befinden. Standardmäßig wird `TNS_ADMIN` von Oracle auf
`$ORACLE_HOME/network/admin` gesetzt. In der Konfigurationsdatei können
Sie `TNS_ADMIN` einen anderen Pfad zuweisen, wie im folgenden Beispiel
für eine konkrete Oracle-Installation:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
export TNS_ADMIN=/opt/oracle/product/19c/dbhome_1/network/admin/
```
:::
:::::

::: paragraph
Nur falls die Variable gar nicht gesetzt ist, wird sie vom Agentenplugin
auf `/etc/check_mk/` gesetzt.
:::
:::::::::

::::::: sect3
#### []{#access_linux .hidden-anchor .sr-only}Zugriffsrechte bei der Ausführung {#heading_access_linux}

::: paragraph
Aus Sicherheitsgründen führt das Agentenplugin `mk_oracle`
Oracle-Binärprogramme nicht länger unter dem Benutzer `root` aus. Das
betrifft die Programme `sqlplus`, `tnsping` und --- falls
vorhanden --- `crsctl`. Stattdessen wechselt `mk_oracle` zum Beispiel
zum Eigentümer der Datei `$ORACLE_HOME/bin/sqlplus`, bevor es `sqlplus`
ausführt. Dies stellt sicher, dass Oracle-Programme nur noch von einem
nicht privilegierten Benutzer ausgeführt werden und verhindert so, dass
ein böswilliger Oracle-Benutzer ein Binärprogramm wie `sqlplus` ersetzen
und als `root`-Benutzer ausführen lassen kann.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In welcher Patch-Version von      |
|                                   | Checkmk diese Änderung            |
|                                   | durchgeführt wurde, können Sie in |
|                                   | den Werks                         |
|                                   | [#15327](https://checkmk.co       |
|                                   | m/de/werk/15327){target="_blank"} |
|                                   | und                               |
|                                   | [#15328](https://checkmk.co       |
|                                   | m/de/werk/15328){target="_blank"} |
|                                   | nachlesen.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die Ausführung der Oracle-Programme durch einen nicht privilegierten
Benutzer kann zu Problemen bei der Verwendung eines Oracle-Wallet
führen, da dieser Benutzer möglicherweise nicht auf die
Wallet-spezifischen Dateien zugreifen kann. Der nicht privilegierte
Benutzer benötigt die Berechtigungen zum Lesen der Dateien
`$TNS_ADMIN/sqlnet.ora` und `$TNS_ADMIN/tnsnames.ora`, zum Ausführen des
Wallet-Ordners und zum Lesen der Dateien im Wallet-Ordner. Sie sollten
keine Probleme mit den Zugriffsrechten haben, sofern Sie die Gruppe der
Dateien und Verzeichnisse so geändert haben, wie es am Ende des
Abschnitts zur [Oracle-Wallet](#oracle_wallet) beschrieben ist.
:::

::: paragraph
Das Agentenplugin hilft Ihnen bei der Diagnose und überprüft, ob es
Probleme beim Zugriff auf die genannten Dateien gibt und zeigt diese
beim [Verbindungstest](#connection_test) an. Das genaue Vorgehen bei der
Diagnose und Korrektur von Zugriffsrechten können Sie in der [Checkmk
Knowledge
Base](https://checkmk.atlassian.net/wiki/spaces/KB/pages/70582273/){target="_blank"}
nachlesen.
:::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::: sect2
### []{#remote_instances .hidden-anchor .sr-only}3.4. Entfernte Datenbanken überwachen {#heading_remote_instances}

::: paragraph
Unter Unix-artigen Systemen können Sie nicht nur lokal laufende
Instanzen abrufen, sondern sich auch auf entfernten anmelden und die
dort laufenden Datenbanken abrufen. Dies ist zum Beispiel dann von
Vorteil, wenn Sie keinen Zugriff auf das darunter liegende System haben,
aber die Datenbank dennoch überwachen wollen. Auch ist es möglich,
entfernte Datenbanken von einem Host aus zu überwachen, auf dem zwar das
Agentenplugin aber keine Oracle Datenbank läuft.
:::

::: paragraph
Um entfernte Datenbanken zu überwachen, müssen auf dem Host, auf dem das
Agentenplugin installiert ist, die folgenden Voraussetzungen erfüllt
sein:
:::

::: ulist
- Die *Linux AIO access library* ist installiert. Unter Red Hat
  Enterprise Linux und binärkompatiblen Distributionen heißt das Paket
  `libaio`.

- Der [Oracle Instant
  Client](https://www.oracle.com/database/technologies/instant-client.html){target="_blank"}
  ist installiert.

- Das Programm `sqlplus` ist in der Installation schon vorhanden oder
  wurde ggf. als Erweiterungspaket zu dem Client installiert.
:::

::: paragraph
In der Regel sind die Voraussetzungen schon erfüllt, wenn sich auf dem
Host eine Oracle-Installation befindet. Andernfalls holen Sie die
Installation der entsprechenden Pakete nach.
:::

::: paragraph
Damit sich das Agentenplugin mit der entfernten Datenbank verbinden
kann, hinterlegen Sie zunächst in der Konfigurationsdatei die
Zugangsdaten. Diese sind ähnlich zu den Angaben für `DBUSER`, die Sie
bereits in der [erweiterten Benutzerkonfiguration](#adv_user_linux)
kennengelernt haben. Allerdings gibt es zusätzlich noch eine Reihe mehr
an verpflichtenden Angaben:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# Syntax:
# REMOTE_INSTANCE_[ID]='USER:PASSWORD:ROLE:HOST:PORT:PIGGYBACKHOST:SID:VERSION:TNSALIAS'

REMOTE_INSTANCE_1='check_mk:mypassword::myRemoteHost:1521:myOracleHost:MYINST3:11.2'
REMOTE_INSTANCE_myinst1='/:::myRemoteHost:1521::MYINST1:11.2:INST1'

REMOTE_ORACLE_HOME='/usr/lib/oracle/11.2/client64'
```
:::
:::::

::: paragraph
Im Beispiel sind zwei entfernte Instanzen konfiguriert in zwei Zeilen.
Damit jede Zeile eindeutig ist, wird am Ende jeder Variablen eine ID
festgelegt. Diese können Sie frei wählen, sie muss lediglich pro
Konfigurationsdatei eindeutig sein. Wie Sie wahrscheinlich schon bemerkt
haben, folgen auf die Angabe des Ports nun weitere Werte. Diese sind
teilweise optional und teilweise notwendig, um eine Verbindung aufbauen
zu können:
:::

::: paragraph
Der erste neue Wert `PIGGYBACKHOST` ist bei der Instanz `MYINST3`
gesetzt auf `myOracleHost`. Durch diese Angabe werden die Ergebnisse für
die Abfrage durch den [Piggyback-Mechanismus](glossar.html#piggyback)
dem angegebenen Host zugeordnet. Ist dieser in Checkmk als Host
vorhanden, werden die neuen Services entsprechend dort erscheinen,
anstatt auf dem Host, auf dem das Agentenplugin läuft, bzw. von dem aus
die Daten geholt wurden. Auf der zweiten Instanz `MYINST1` sehen Sie
diese Angabe nicht --- die Zuordnung zu einem anderen Host ist
*optional.*
:::

::: paragraph
Der zweite neue Wert `SID` ist die Angabe des Instanznamens. Da das
Agentenplugin nicht schauen kann, welche Instanzen auf dem entfernten
Host laufen, muss für jede entfernte Instanz eine Konfigurationszeile
angegeben werden --- der Wert ist also *notwendig* und damit nicht
optional.
:::

::: paragraph
Der dritte Wert `VERSION` ist *notwendig* und ebenfalls dem Umstand
geschuldet, dass viele Metadaten nur zur Verfügung stehen, wenn man sich
direkt auf dem Host befindet. Die Versionsangabe kann daher auch nicht
weggelassen werden und bestimmt, welche SQL-Abfragen an die Instanz
übergeben werden können. Im Beispiel verwenden beide entfernten
Instanzen die Version `11.2`.
:::

::: paragraph
Der vierte und letzte Wert `TNSALIAS` ist wieder *optional* und kann
verwendet werden, wenn Sie auf die entfernte Instanz per [Oracle
Wallet](#oracle_wallet) oder LDAP/Active Directory zugreifen möchten.
Für den Fall, dass die Instanz dann nur auf einen bestimmten TNS-Alias
antwortet, können Sie diesen hier angeben. Für die zweite entfernte
Instanz hat `TNSALIAS` den Wert `INST1`.
:::

::: paragraph
Damit auch das Programm `sqlplus` gefunden wird, geben Sie schließlich
mit der Variablen `REMOTE_ORACLE_HOME` an, wo sich der Oracle-Client auf
dem Host befindet, der das Agentenplugin ausführt. Nur dann sind alle
Ressourcen verfügbar, die für die Abfragen benötigt werden.
:::

::: paragraph
Bei der Abfrage von entfernten Instanzen gelten ein paar Einschränkungen
und Besonderheiten:
:::

::: ulist
- Da Sie die entfernten Instanzen in der Konfigurationsdatei explizit
  eingetragen haben, können Sie diese Instanzen nicht per `SKIP_SIDS`
  [ausschließen](#skip_include) und brauchen sie im Gegenzug auch nicht
  mit `ONLY_SIDS` einzuschließen.

- Instanzen mit gleichem Namen (`SID`) dürfen nicht demselben Host
  zugewiesen werden. Das ist vor allem dann relevant, wenn Sie Instanzen
  von mehreren entfernten Hosts und/oder dem lokalen Host abrufen und
  dort identische Namen verwendet werden.
:::
:::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#windows .hidden-anchor .sr-only}4. Einrichtung für Windows {#heading_windows}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#paths_windows .hidden-anchor .sr-only}4.1. Plugin- und Konfigurationspfade {#heading_paths_windows}

::: paragraph
Unter Windows wird PowerShell als Skriptsprache benutzt, um
Oracle-Datenbanken zu überwachen. Die Funktionalität ist an das
Agentenplugin unter [Unix-artigen Systemen](#linux) angelehnt, enthält
aber nur einen Teil davon. Um das Agentenplugin unter Windows nutzen zu
können, benötigen Sie PowerShell ab Version 5.x und außerdem die
folgenden Verzeichnisse:
:::

+-----------------+--------------------------+--------------------------+
| Betriebssystem  | Plugin-Pfad              | Konfigurationspfad       |
+=================+==========================+==========================+
| Windows         | `C:\ProgramDat           | `C:\ProgramDa            |
|                 | a\checkmk\agent\plugins` | ta\checkmk\agent\config` |
+-----------------+--------------------------+--------------------------+
::::

:::: sect2
### []{#install_windows .hidden-anchor .sr-only}4.2. Agentenplugin installieren {#heading_install_windows}

::: paragraph
Nachdem Sie bei der [Ersteinrichtung](#first_steps) einen Benutzer
angelegt und diesen in der Konfigurationsdatei hinterlegt haben,
installieren Sie nun noch das Agentenplugin. Die Agentenplugins für
Windows werden bei der Installation des Checkmk-Agenten für Windows auf
dem Host abgelegt. Kopieren Sie auf dem Oracle-Host die Datei
`mk_oracle.ps1` aus dem Verzeichnis
`C:\Program Files (x86)\checkmk\service\plugins\` in das oben
beschriebene Plugin-Verzeichnis. Alternativ dazu können Sie in der
Konfigurationsdatei des Checkmk-Agenten auf die Datei im
Installationspfad [verweisen.](agent_windows.html#customizeexecution)
:::
::::

:::::::::::: sect2
### []{#_besonderheiten_unter_windows .hidden-anchor .sr-only}4.3. Besonderheiten unter Windows {#heading__besonderheiten_unter_windows}

::: paragraph
Windows verhindert normalerweise die Ausführung von PowerShell-Skripten,
wenn diese nicht signiert sind. Sie können dieses Problem nun sehr
einfach umgehen, indem Sie die Richtlinien zur Ausführung von
PowerShell-Skripten für den Benutzer anpassen, welcher den
Checkmk-Agenten ausführt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\ProgramData\checkmk\agent\> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
PS C:\ProgramData\checkmk\agent\> Get-ExecutionPolicy -Scope LocalMachine
Bypass
```
:::
::::

::: paragraph
Diese Option ist praktisch, wenn man kurz ein Skript oder die generelle
Funktionalität des Checkmk-Agenten testen möchte. Um die Sicherheit
Ihres Systems nicht zu gefährden, setzen Sie nach dem Test die
Einstellung auf produktiven Servern wieder zurück:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\Program\checkmk\agent\> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
PS C:\Program\checkmk\agent\> Get-ExecutionPolicy -Scope LocalMachine
RemoteSigned
```
:::
::::

::: paragraph
Verständlicherweise haben Sie wahrscheinlich keine Lust, alle 60
Sekunden die Richtlinien umzustellen. Setzen Sie daher eine permanente
Ausnahme nur für die relevanten Skripte. Dabei muss auch die
Konfigurationsdatei des Agentenplugins zu den Ausnahmen hinzugefügt
werden. Die Ausgabe aus dem Beispiel wurde zu Gunsten der Lesbarkeit
komplett weggelassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\ProgramData\checkmk\agent\> Unblock-File -Path .\plugins\mk_oracle.ps1
PS C:\ProgramData\checkmk\agent\> Unblock-File -Path .\config\mk_oracle_cfg.ps1
```
:::
::::
::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#adv_windows .hidden-anchor .sr-only}4.4. Erweiterte Optionen {#heading_adv_windows}

::: paragraph
In der [Ersteinrichtung](#user_config) haben Sie bereits erste Variablen
kennengelernt, um Überwachungsdaten von Ihren Oracle-Instanzen zu
bekommen. Je nach Anwendungsszenario werden Sie aber schnell weitere
Möglichkeiten benötigen, um die Überwachung besser und individuell pro
Instanz steuern zu können. Optionen, die Ihnen auch unter Windows zur
Verfügung stehen, finden Sie in den nachfolgenden Abschnitten.
:::

:::::::::: sect3
#### []{#adv_user_windows .hidden-anchor .sr-only}Erweiterte Benutzerkonfiguration {#heading_adv_user_windows}

::: paragraph
Wie unter [Linux](#adv_user_linux) können Sie auch bei dem
Windows-Agentenplugin nicht nur ein Standard-Login definieren, sondern
auch individuelle Zugangsdaten für einzelne Instanzen Sie haben also die
gleichen drei Möglichkeiten, Benutzer anzugeben:
:::

+-----------------+-----------------------------------------------------+
| Parameter       | Beschreibung                                        |
+=================+=====================================================+
| `DBUSER`        | Der Standard, wenn keine individuellen Zugangsdaten |
|                 | für die Datenbankinstanz definiert sind.            |
+-----------------+-----------------------------------------------------+
| `               | Zugangsdaten für eine ganz bestimmte                |
| DBUSER_MYINST1` | Datenbankinstanz, in diesem Fall für die Instanz    |
|                 | `MYINST1`. Die Zugangsdaten werden nur für diese    |
|                 | Instanz benutzt.                                    |
+-----------------+-----------------------------------------------------+
| `ASMUSER`       | Spezielle Zugangsdaten für das Automatic Storage    |
|                 | Management (ASM).\                                  |
|                 | **Wichtig:** Für ein ASM kann immer nur ein Login   |
|                 | angegeben werden.                                   |
+-----------------+-----------------------------------------------------+

::: paragraph
Zusätzlich können auch hier noch mehr Optionen außer Benutzername oder
Passwort angegeben werden. Diese zusätzlichen Angaben sind ebenfalls
optional. Allerdings muss jede Angabe ausgefüllt werden, wenn sie
benutzt wird. Eine Konfiguration kann dann zum Beispiel so aussehen:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Syntax
# DBUSER = @("USERNAME", "PASSWORD", "ROLE", "HOST", "PORT")
# Default
# DBUSER = @("", "", "", "localhost", "1521")
$DBUSER = @("checkmk", "myPassword", "SYSDBA", "localhost", "1521")

@DBUSER_MYINST1 = @("cmk_specific1", "myPassword1", "", "10.0.0.73")
@DBUSER_MYINST2 = @("cmk_specific2", "myPassword2", "SYSDBA", "localhost", "1531")

@ASMUSER = @("cmk_asm", "myASMPassword", "SYSASM")
```
:::
:::::

::: paragraph
Ein paar Erläuterungen zu dem Beispiel:
:::

::: ulist
- Sie können beliebig viele individuelle Zugangsdaten definieren. Diese
  werden immer gegenüber dem Standard bevorzugt.

- Jede Option wird in einer Liste definiert. Die Reihenfolge der
  Einträge ist nicht beliebig und darf daher nicht vertauscht werden.

- Soll ein optionales Feld nicht verändert werden, aber ein danach
  folgendes, so müssen *beide* korrekt angegeben werden, wie beim
  Eintrag `DBUSER_MYINST2`, bei dem der `HOST` weiterhin auf `localhost`
  gesetzt wird, obwohl nur der `PORT` verändert werden soll.

- Werden ab einem bestimmten Punkt keine optionalen Felder mehr
  gebraucht, können sie weggelassen werden, wie beim Eintrag `ASMUSER`,
  bei dem nur die Rolle des Benutzers angegeben wurde.

- Soll dem Benutzer keine spezielle Rolle zugewiesen, aber `HOST` oder
  `PORT` angepasst werden, tragen Sie an der Stelle lediglich zwei
  Anführungszeichen (`""`) ein.
:::
::::::::::

:::::::::: sect3
#### []{#skip_include_windows .hidden-anchor .sr-only}Instanzen ein- oder ausschließen {#heading_skip_include_windows}

::: paragraph
Auch unter Windows möchte man bestimmte Instanzen nicht immer
einbeziehen. Gründe dafür wurden im Abschnitt für [Linux](#skip_include)
bereits beschrieben. Zwei der drei Parameter für Linux können Sie auch
bei Windows verwenden:
:::

+-----------------+-----------------------------------------------------+
| Parameter       | Beschreibung                                        |
+=================+=====================================================+
| `ONLY_SIDS`     | Hiermit können Sie bestimmen, welche Instanzen      |
|                 | überwacht werden sollen. Eine Instanz wird dabei    |
|                 | durch ihren *System Identifier (SID)* benannt. Es   |
|                 | handelt sich hierbei um eine positive Liste, bei    |
|                 | der alle Instanzen ignoriert werden, die nicht      |
|                 | explizit gelistet sind. Dieser Parameter eignet     |
|                 | sich also sehr gut, wenn die Menge der zu           |
|                 | überwachenden Instanzen kleiner ist, als die Anzahl |
|                 | derer, die ignoriert werden sollen.                 |
+-----------------+-----------------------------------------------------+
| `EXCLUDE_<SID>` | Da Ihnen unter Windows der Parameter                |
|                 | [`SKIP_SIDS`](#skip_include) nicht zur Verfügung    |
|                 | steht, können Sie nur mit `EXCLUDE_<SID>` Instanzen |
|                 | ausschließen und dadurch eine negative Liste        |
|                 | definieren. Sie machen das, in dem Sie den Wert der |
|                 | Variable auf `ALL` setzen. Zusätzlich können Sie    |
|                 | mit diesem Parameter eine Instanz teilweise         |
|                 | ausschließen, indem Sie bestimmte Sektionen der     |
|                 | Instanz von der Überwachung ausschließen. Auf diese |
|                 | Weise definieren Sie eine Negativliste der          |
|                 | Sektionen einer Instanz.\                           |
|                 | **Wichtig:** Eine ASM (`+ASM`) kann mit dieser      |
|                 | Option nicht komplett ausgeschlossen werden.        |
+-----------------+-----------------------------------------------------+

::: paragraph
Die Verarbeitung erfolgt pro Instanz in der Reihenfolge, wie in der
obigen Tabelle angegeben. Es wird also zuerst geprüft, ob sich die
Instanz in `ONLY_SIDS` befindet und erst danach, ob bestimmte Sektionen
ausgeschlossen werden sollen. Ist die Variable `EXCLUDE_<SID>` auf `ALL`
gesetzt, so wird auch keine Sektion ausgeführt.
:::

::: paragraph
Nachfolgend ein Beispiel, bei dem beide Variablen einmal gezeigt werden:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
$ONLY_SIDS = @("MYINST1", "MYINST3")
$EXCLUDE_INST1 = "tablespaces rman"
$EXCLUDE_INST3 = "ALL"
```
:::
:::::

::: paragraph
Beachten Sie, dass es sich bei `ONLY_SIDS` um eine Liste handelt, bei
`EXCLUDE_INST1` hingegen um einen String, der durch Leerzeichen
separierte Sektionen enthält.
:::
::::::::::

::::::::::::: sect3
#### []{#sections_windows .hidden-anchor .sr-only}Zu holende Daten bestimmen {#heading_sections_windows}

::: paragraph
Die Festlegung, welche Sektionen überhaupt zu holen sind, erfolgt
äquivalent zu [Linux.](#sections) Daher hier nur ein Beispiel der
Konfiguration für Windows:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# DEFAULTS:
# $SYNC_SECTIONS = @("instance", "sessions", "logswitches", "undostat", "recovery_area", "processes", "recovery_status", "longactivesessions", "dataguard_stats", "performance", "locks")
# $ASYNC_SECTIONS = @("tablespaces", "rman", "jobs", "ts_quotas", "resumable")
# $SYNC_ASM_SECTIONS = @("instance", "processes")
# $ASYNC_ASM_SECTIONS = @("asm_diskgroup")
# $CACHE_MAXAGE = 600

$SYNC_ASM_SECTIONS = @("instance")
$ASYNC_SECTIONS = @("tablespaces", "jobs", "rman", "resumable")

$CACHE_MAXAGE = 300

$EXCLUDE_INST1 = "undostat locks"
$EXCLUDE_INST2 = "jobs'
```
:::
:::::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Wenn Sie in der                   |
|                                   | Konfigurationsdatei bestimmen,    |
|                                   | welche Sektionen auf welche Weise |
|                                   | abgeholt werden sollen --- Sie    |
|                                   | können ja auch eine asynchrone    |
|                                   | Sektion zu einer synchronen       |
|                                   | machen --- müssen Sie **alle**    |
|                                   | Sektionen angeben, welche in dem  |
|                                   | jeweiligen Bereich ausgeführt     |
|                                   | werden sollen.                    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Wollen Sie zum Beispiel nur `locks` aus der synchronen Abfrage
herausnehmen, geben Sie die gesamte synchrone Liste an und lassen Sie
lediglich `locks` weg:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Just exclude 'locks' from sync sections:
$SYNC_SECTIONS = @("instance", "sessions", "logswitches", "undostat", "recovery_area", "processes", "recovery_status", "longactivesessions", "dataguard_stats", "performance")
```
:::
:::::

::: paragraph
Gleiches gilt auch für die anderen drei Variablen, in denen die
Sektionen bestimmt werden.
:::
:::::::::::::

:::::::::::::::::::: sect3
#### []{#access_windows .hidden-anchor .sr-only}Zugriffsrechte bei der Ausführung {#heading_access_windows}

::: paragraph
Aus Sicherheitsgründen führt das Agentenplugin `mk_oracle.ps1`
Oracle-Binärprogramme nur noch dann als Administrator aus, wenn diese
Programme auch nur von Administratoren verändert werden können. Als
Administratoren unter Windows gelten dabei das LocalSystem-Konto und
Mitglieder der eingebauten Gruppe `Administrators`. Das betrifft die
Programme `sqlplus.exe`, `tnsping.exe` und --- falls
vorhanden --- `crsctl.exe`. Das Agentenplugin `mk_oracle.ps1` führt
keines dieser Programme aus, wenn nicht-administrative Benutzer eine der
Berechtigungen `Write`, `Modify` oder `Full control` für die Datei
haben. Dies verhindert das Sicherheitsrisiko der Ausführung von
Programmen nicht privilegierter Benutzer als Administrator.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In welcher Patch-Version von      |
|                                   | Checkmk diese Änderung            |
|                                   | durchgeführt wurde, können Sie im |
|                                   | [Werk                             |
|                                   | #15843](https://checkmk.co        |
|                                   | m/de/werk/15843){target="_blank"} |
|                                   | nachlesen.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Ändern Sie gegebenenfalls die Zugriffsrechte, indem Sie die oben
genannten Berechtigungen nicht-administrativer Benutzer für die
Programme entfernen. Das Agentenplugin hilft Ihnen bei der Diagnose und
überprüft, ob nicht-administrative Benutzer Zugriff auf die genannten
Dateien haben und zeigt diese beim [Verbindungstest](#connection_test)
an. Das genaue Vorgehen bei der Diagnose und Korrektur von
Zugriffsrechten können Sie in der [Checkmk Knowledge
Base](https://checkmk.atlassian.net/wiki/spaces/KB/pages/70582273/){target="_blank"}
nachlesen.
:::

::: paragraph
Falls es bei Ihnen nicht möglich ist, die Berechtigungen für die
Oracle-Programme sicher anzupassen, können Sie einzelnen Benutzern und
Gruppen die Ausführung der Programme erlauben:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Oracle plugin will allow users and groups in the list to have write access to the Oracle binaries
$WINDOWS_SAFE_ENTRIES=@("NT AUTHORITY\Authenticated Users", "<Domain>\<User>")
```
:::
:::::

::: paragraph
Nur wenn es keine andere Möglichkeit gibt, die Überwachung von Oracle
sicherzustellen, können Sie als letzte Option die Überprüfung der
Zugriffsrechte abschalten.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Wenn Sie die Prüfung der          |
|                                   | Zugriffsrechte abschalten, wird   |
|                                   | das Agentenplugin nicht mehr      |
|                                   | sicher ausgeführt.                |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Oracle plugin will not check if the used binaries are write-protected for non-admin users
$SKIP_ORACLE_SECURITY_CHECK=1
```
:::
:::::

::: paragraph
Es gibt aber auch noch einen anderen Weg, das Agentenplugin
auszuführen --- und zwar ganz ohne Administratorrechte. So können Sie
die [Ausführung des Agentenplugins
anpassen](agent_windows.html#customizeexecution) und es zum Beispiel
unter der lokalen Windows-Gruppe `Users` ausführen lassen. Dazu
bearbeiten Sie die Konfigurationsdatei `check_mk.user.yml` des
Windows-Agenten, zum Beispiel so:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
plugins:
    enabled: yes
    execution:
        - pattern: $CUSTOM_PLUGINS_PATH$\mk_oracle.ps1
          async: yes
          group: Users
          run: true
```
:::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können Sie sich diese Einträge mit der
Agentenregel [Run plug-ins and local checks using non-system
account]{.guihint} von der Agentenbäckerei erstellen lassen.
:::
::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::

:::: sect2
### []{#_entfernte_datenbanken_überwachen .hidden-anchor .sr-only}4.5. Entfernte Datenbanken überwachen {#heading__entfernte_datenbanken_überwachen}

::: paragraph
Die Überwachung entfernter Datenbanken ist derzeit nicht mit dem
Agentenplugin für Windows möglich. Wenn Sie entfernte Datenbanken
überwachen wollen, benötigen Sie daher einen Host mit einem kompatiblen
[Unix-artigen Betriebssystem.](#linux)
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}5. Einrichtung mit der Agentenbäckerei {#heading_bakery}

::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Einrichtung
wird in den kommerziellen Editionen mit der
[Agentenbäckerei](glossar.html#agent_bakery) stark vereinfacht, da
Syntaxfehler in den Konfigurationsdateien vermieden und Anpassungen an
sich verändernde Umgebungen einfacher umgesetzt werden können. Der
wesentliche Unterschied zu einer manuellen Konfiguration ist, dass Sie
nur noch dann auf dem Oracle-Host auf der Kommandozeile arbeiten müssen,
wenn Sie spezielle Oracle-spezifische Konfigurationen vornehmen wollen.
Die Einrichtung mit der Agentenbäckerei können Sie für Linux, Solaris,
AIX und Windows durchführen.
:::

::: paragraph
Trotzdem können Sie nicht alle Funktionen des Agentenplugins über die
Agentenbäckerei konfigurieren, zum Beispiel wenn es Funktionen sind,
welche einen größeren Eingriff benötigen und ein fundiertes Fachwissen
voraussetzen. Entsprechend sind die [benutzerdefinierten
SQL-Abfragen](#custom_sqls) nicht in der Agentenbäckerei konfigurierbar.
:::

::: paragraph
Über [Setup \> Agents \> Windows, Linux, Solaris, AIX]{.guihint} und das
Menü [Agents \> Agent rules]{.guihint} finden Sie die Seite mit dem
[Regelsatz](glossar.html#rule_set) [Oracle databases (Linux, Solaris,
AIX, Windows).]{.guihint} Erstellen Sie mit [Add rule]{.guihint} eine
neue Regel. Hier finden Sie alle Optionen, die Ihnen für die
Konfiguration des Agentenplugins zur Verfügung stehen:
:::

:::: imageblock
::: content
![Regel zur Konfiguration von Oracle in der
Agentenbäckerei.](../images/monitoring_oracle_bakery_ruleset.png)
:::
::::

::: paragraph
Viele Optionen werden ihnen aus der manuellen Einrichtung bekannt
vorkommen. Wie dort beschrieben, gibt es Optionen, die nicht für alle
Betriebssysteme verfügbar sind. Der Titel dieser Optionen zeigt, für
welche Betriebssysteme sie genutzt werden können.
:::

:::::::: sect2
### []{#bakery_users .hidden-anchor .sr-only}5.1. Benutzer konfigurieren {#heading_bakery_users}

::: paragraph
In der [einfachsten Konfiguration](#user_config) für eines der
Unix-artigen Betriebssysteme sieht die Regel etwa so aus:
:::

:::: imageblock
::: content
![Einfachste Regel zur Konfiguration von Oracle in der
Agentenbäckerei.](../images/monitoring_oracle_bakery_login1.png)
:::
::::

::: paragraph
Auch in der Agentenbäckerei haben Sie die Möglichkeit, Standardbenutzer
und Ausnahmen für spezielle Instanzen anzulegen. Die Optionen, die in
der Konfigurationsdatei mit Doppelpunkt (für [Linux &
Co.](#adv_user_linux)) oder als Listeneinträge (für
[Windows](#adv_user_windows)) separiert sind, finden Sie unter [Login
Defaults]{.guihint} als einzelne Optionen, die Sie dann entsprechend
ausfüllen. Natürlich können Sie auch hier das [Oracle
Wallet](#oracle_wallet) nutzen, indem Sie bei [Authentication
method]{.guihint} einfach auf [Use manually created Oracle password
wallet]{.guihint} wechseln.
:::

::: paragraph
Die Konfiguration für ein Automatic Storage Management (ASM) erledigen
Sie analog über die Option [Login for ASM,]{.guihint} und die Ausnahmen
für spezifische Instanzen tragen Sie bei [Login for selected
databases]{.guihint} ein, so wie es bei der erweiterten
Benutzerkonfiguration für [Linux, Solaris, AIX](#adv_user_linux) und
[Windows](#adv_user_windows) beschrieben ist.
:::
::::::::

:::: sect2
### []{#bakery_advanced .hidden-anchor .sr-only}5.2. Erweiterte Optionen {#heading_bakery_advanced}

::: paragraph
In der folgenden Tabelle finden Sie die restlichen Optionen des
Regelsatzes [Oracle databases (Linux, Solaris, AIX, Windows)]{.guihint}
zusammen mit einem Verweis darauf, wo Sie eine Beschreibung zu der
Option finden:
:::

+---------------------------+------------------------------------------+
| Option                    | Beschreibung                             |
+===========================+==========================================+
| [Host uses xinetd or      | Diese Option muss für Unix-artige        |
| systemd                   | Systeme mit `xinetd`/`systemd` aktiviert |
| (Linux/AIX/Solaris        | werden. Bei `systemd` ist die asynchrone |
| only)]{.guihint}          | Ausführung des Agentenplugins            |
|                           | obligatorisch --- im von Ihnen           |
|                           | festgelegten Intervall. Mehr dazu finden |
|                           | Sie bei der [Installation des            |
|                           | Agentenplugins.](#install_linux)         |
+---------------------------+------------------------------------------+
| [Instances to             | Diese Option fasst mehrere Optionen der  |
| monitor]{.guihint}        | Konfigurationsdatei zusammen, mit denen  |
|                           | Sie Instanzen für [Linux, Solaris,       |
|                           | AIX](#skip_include) oder                 |
|                           | [Windows](#skip_include_windows) ein-    |
|                           | oder ausschließen können.                |
+---------------------------+------------------------------------------+
| [Add pre or postfix to    | Mit dieser Option können Sie den         |
| TNSALIASes                | [TNS-Alias](#tns_config) entweder global |
| (Linux/AIX/Solaris        | oder für eine spezifische Instanz        |
| only)]{.guihint}          | erweitern.                               |
+---------------------------+------------------------------------------+
| [Sections - data to       | Alle verfügbaren Sektionen sind unter    |
| collect]{.guihint}        | dieser Option gelistet und können        |
|                           | individuell auf globaler Ebene           |
|                           | konfiguriert werden. Sie entsprechen     |
|                           | daher den Variablen `SYNC_SECTIONS` und  |
|                           | `ASYNC_SECTIONS` sowie für ASM deren     |
|                           | Gegenstücken `SYNC_ASM_SECTIONS` und     |
|                           | `ASYNC_ASM_SECTIONS`. Mehr dazu im       |
|                           | Abschnitt über die zu holenden Daten für |
|                           | [Linux, Solaris, AIX](#sections) oder    |
|                           | [Windows.](#sections_windows)            |
+---------------------------+------------------------------------------+
| [Exclude some sections on | Wenn Sie mit `EXCLUDE_<SID>` nicht die   |
| certain                   | gesamte Instanz, sondern nur ein paar    |
| instances]{.guihint}      | Sektionen ausschließen wollen, können    |
|                           | Sie dies mit dieser Option festlegen, so |
|                           | wie für [Linux, Solaris, AIX](#sections) |
|                           | oder [Windows](#sections_windows)        |
|                           | beschrieben.                             |
+---------------------------+------------------------------------------+
| [Cache age for background | Legen Sie hier fest, wie lange           |
| checks]{.guihint}         | asynchrone Sektionen gültig sein sollen. |
|                           | Der Standardwert liegt bei 600 Sekunden  |
|                           | (10 Minuten).                            |
+---------------------------+------------------------------------------+
| [Sqlnet Send              | Diese Option wird der Datei `sqlnet.ora` |
| timeout]{.guihint}        | hinzugefügt und setzt ein Timeout,       |
|                           | welches für alle Instanzen gilt.         |
+---------------------------+------------------------------------------+
| [Remote instances         | [Entfernte Instanzen](#remote_instances) |
| (Linux/AIX/Solaris        | konfigurieren Sie mit dieser Option. Sie |
| only)]{.guihint}          | enthält alle Elemente der Konfiguration, |
|                           | die Sie bereits kennen. Für die          |
|                           | Bestimmung der ID der Variablen haben    |
|                           | Sie über die [Unique ID]{.guihint} die   |
|                           | Wahl aus verschiedenen Möglichkeiten.    |
|                           | Sie müssen nur darauf achten, dass die   |
|                           | ID innerhalb der Konfiguration eindeutig |
|                           | ist.                                     |
+---------------------------+------------------------------------------+
| [ORACLE_HOME to use for   | Hier können Sie bestimmen, wo das        |
| remote access             | Agentenplugin das Programm `sqlplus`     |
| (Linux/AIX/Solaris        | findet. Sie müssen hier einen Wert       |
| only)]{.guihint}          | eintragen, wenn Sie eine [entfernte      |
|                           | Instanz](#remote_instances) überwachen   |
|                           | wollen, aber `sqlplus` nicht über die    |
|                           | Umgebungsvariablen gefunden werden kann. |
+---------------------------+------------------------------------------+
| [TNS_ADMIN to use for     | Falls die beiden Dateien in einem        |
| sqlnet.ora and            | anderen Verzeichnis als `/etc/check_mk/` |
| tnsnames.ora              | liegen, können Sie mit dieser Option den |
| (Linux/AIX/Solaris        | Pfadnamen über die Umgebungsvariable     |
| only)]{.guihint}          | [`TNS_ADMIN`](#tns_config) festlegen.    |
+---------------------------+------------------------------------------+
| [sqlnet.ora permission    | Tragen Sie hier die Linux-Gruppe des     |
| group (Linux/AIX/Solaris  | nicht privilegierten Benutzers ein, der  |
| only)]{.guihint}          | Eigentümer der Oracle-Binärprogramme     |
|                           | ist, damit dieser Benutzer die Datei     |
|                           | `sqlnet.ora` lesen kann, die von der     |
|                           | Agentenbäckerei erstellt wird. Bei einer |
|                           | Standard-Oracle-Installation kann        |
|                           | `oinstall` als Gruppe verwendet werden.\ |
|                           | Weitere Informationen finden Sie im      |
|                           | Abschnitt [Zugriffsrechte bei der        |
|                           | Ausführung](#access_linux) für Linux.    |
|                           | Dort werden auch andere Dateien und      |
|                           | Verzeichnisse genannt, z.B.              |
|                           | `tnsnames.ora`, die nicht von der        |
|                           | Agentenbäckerei erstellt werden. Für     |
|                           | diese manuell erstellten Dateien und     |
|                           | Verzeichnisse müssen Sie auch die        |
|                           | notwendigen Berechtigungen manuell       |
|                           | setzen.                                  |
+---------------------------+------------------------------------------+
| [Oracle binaries          | Hier können Sie die Prüfung der          |
| permissions check         | Zugriffsrechte für die                   |
| (Windows only)]{.guihint} | Oracle-Binärprogramme konfigurieren,     |
|                           | indem Sie einzelnen,                     |
|                           | nicht-administrativen Benutzern und      |
|                           | Gruppen die Ausführung der Programme     |
|                           | erlauben. Die Prüfung ausschalten        |
|                           | sollten Sie nur, wenn Sie wissen, was    |
|                           | Sie tun. Mehr zum Thema finden Sie im    |
|                           | Abschnitt [Zugriffsrechte bei der        |
|                           | Ausführung](#access_windows) für         |
|                           | Windows.                                 |
+---------------------------+------------------------------------------+
::::
:::::::::::::::::
::::::::::::::::::

:::::::::::::::::::::::::::: sect1
## []{#clustered_instances .hidden-anchor .sr-only}6. Cluster-Instanzen {#heading_clustered_instances}

::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::: sect2
### []{#_standby_datenbanken .hidden-anchor .sr-only}6.1. Standby-Datenbanken {#heading__standby_datenbanken}

::: paragraph
Oracle unterstützt sogenannte *Standby-Datenbanken,* welche bestimmte
Aufgaben erfüllen können und in der Regel schlicht Kopien von
produktiven bzw. primären Datenbanken sind. Diese Datenbankkonzepte
benötigen auch spezielle Mechanismen in der Überwachung. Welche das
sind, erfahren Sie in den folgenden Abschnitten.
:::

:::: sect3
#### []{#cluster_adg .hidden-anchor .sr-only}Mit Active Data Guard (ADG) {#heading_cluster_adg}

::: paragraph
Haben Sie ADG lizenziert und aktiviert, müssen Sie keinerlei
Veränderungen in der Konfiguration des Agentenplugins vornehmen, da Sie
jederzeit von einer Standby-Instanz lesen können, ohne die
Synchronisation mit der primären Instanz unterbrechen zu müssen.
:::
::::

:::::::::::: sect3
#### []{#cluster_dg .hidden-anchor .sr-only}Ohne Active Data Guard (DG) {#heading_cluster_dg}

::: paragraph
Wenn die Instanzen nicht über ADG verfügen, benötigt der Benutzer, mit
dem die Monitoring-Daten der Standby-Instanzen geholt werden sollen, die
Rolle `SYSDBA`. Durch diese Berechtigung ist der Benutzer auch dann in
der Lage zumindest einen Teil der Daten zu holen, wenn die primäre
Instanz ausfällt und auf dem Standby-Server die Instanz noch nicht von
`MOUNTED` auf `OPEN` umgestellt wurde.
:::

::: paragraph
Weisen Sie die Berechtigung dem Benutzer zu, welcher die Daten von den
Instanzen abholen darf. **Wichtig:** Wie das funktioniert, kann von dem
folgenden Beispiel abweichen. Die Rolle wird hier dem Benutzer
zugewiesen, wie er im Beispiel der [Ersteinrichtung](#first_steps)
angelegt wurde:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
sqlplus> grant sysdba to checkmk;
```
:::
::::

::: paragraph
Damit die Daten im Fehlerfall vom Agentenplugin auf dem Standby-Server
abgefragt werden können, legen Sie den Benutzer auf der primären Instanz
an und kopieren Sie die Passwortdatei danach auf den Standby-Server. In
der Konfigurationsdatei des Plugins setzen Sie abschließend die Rolle
des Benutzers auf `SYSDBA`:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
# Syntax:
# DBUSER='USER:PASSWORD:ROLE:HOST:PORT:TNSALIAS'
DBUSER='checkmk:myPassword:sysdba'
```
:::
:::::

::: paragraph
Beachten Sie, dass die Angabe eines Hosts, Ports oder des TNS-Alias
optional ist und weggelassen werden kann. Zusätzlich muss natürlich das
Agentenplugin sowohl auf dem Host der primären Instanz als auch auf den
Hosts der Standby-Instanzen installiert sein.
:::
::::::::::::

:::::: sect3
#### []{#clustered_services .hidden-anchor .sr-only}Cluster-Services einrichten {#heading_clustered_services}

::: paragraph
Auf der Seite von Checkmk ist es notwendig, dass Sie --- egal, ob Sie
ADG oder DG nutzen --- die Services anpassen und einem *Cluster-Host*
zuweisen. Die entsprechenden Check-Plugins wurden bereits soweit
vorbereitet, dass Sie auch als
[Cluster-Services](clustered_services.html) konfiguriert werden können.
Legen Sie also in Checkmk einen Cluster-Host an und fügen Sie diesem als
Knoten die einzelnen Oracle-Hosts zu, auf denen die primäre und die
Standby-Instanzen laufen. Danach weisen Sie diesem Cluster-Host die
folgenden Services zu:
:::

::: ulist
- `ORA .* RMAN Backup`

- `ORA .* Job`

- `ORA .* Tablespaces`
:::

::: paragraph
Sie brauchen sich sich nun nicht mehr darum zu kümmern, von welcher
Instanz die Daten kommen und haben auch im Falle eines Schwenks der
primären Instanz eine nahtlose Überwachung der genannten Services
sichergestellt.
:::
::::::
::::::::::::::::::::

:::::::: sect2
### []{#rac .hidden-anchor .sr-only}6.2. Real Application Cluster (RAC) {#heading_rac}

::: paragraph
Da es in einem RAC einen zentralen Speicher für die Daten gibt, reicht
es hier, den Benutzer für das Agentenplugin nur einmal anzulegen.
Lediglich das Agentenplugin muss auf jedem Knoten des Oracle-Clusters
installiert und konfiguriert werden.
:::

::: paragraph
**Wichtig:** Richten Sie immer die Knoten des Clusters selbst ein und
verzichten Sie auf die Abfrage des Oracle *SCAN Listener.* Nur dadurch
ist gewährleistet, dass der Zugriff über das Agentenplugin funktioniert.
:::

::::: sect3
#### []{#_cluster_services_einrichten .hidden-anchor .sr-only}Cluster-Services einrichten {#heading__cluster_services_einrichten}

::: paragraph
Auch bei einem RAC ist es sinnvoll, Cluster-Services einzurichten.
Zusätzlich zu den Services, die Sie bei einem [(Active) Data
Guard](#cluster_adg) dem Cluster-Host zuordnen, weisen Sie auch die
folgenden Services zu, um im Falle eines Schwenks eine nahtlose
Überwachung sicherzustellen:
:::

::: ulist
- `ASM .* Diskgroup`

- `ORA .* Recovery Area`
:::
:::::
::::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#custom_sqls .hidden-anchor .sr-only}7. Benutzerdefinierte SQL-Abfragen (Custom SQLs) {#heading_custom_sqls}

:::::::::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_warum_benutzerdefinierte_sql_abfragen .hidden-anchor .sr-only}7.1. Warum benutzerdefinierte SQL-Abfragen? {#heading__warum_benutzerdefinierte_sql_abfragen}

::: paragraph
Checkmk bietet mit dem Agentenplugin bereits eine große Menge an
SQL-Abfragen, mit denen Sie Ihre Datenbankinstanzen überwachen können.
Damit diese für eine möglichst große Menge an technischen und
inhaltlichen Anforderungen passend sind, sind diese natürlich sehr
allgemein gehalten.
:::

::: paragraph
Um die individuellen Anforderungen eines jeden Unternehmens an die
Überwachung einer konkreten Datenbank erfüllen zu können, bietet Checkmk
die Möglichkeit, eigene, benutzerdefinierte SQL-Abfragen (*Custom SQLs*)
zu erstellen und mit dem Agentenplugin abfragen zu lassen. Diese werden
dann automatisch in der Weboberfläche als eigene Services erkannt und
überwacht.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Es gibt nur unter Linux, Solaris  |
|                                   | und AIX die Möglichkeit,          |
|                                   | benutzerdefinierte SQL-Abfragen   |
|                                   | einzusetzen. Unter Windows steht  |
|                                   | diese Option nicht zur Verfügung. |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::

::::::::::::::::::::::: sect2
### []{#_einfache_benutzerdefinierte_sql_abfragen .hidden-anchor .sr-only}7.2. Einfache benutzerdefinierte SQL-Abfragen {#heading__einfache_benutzerdefinierte_sql_abfragen}

:::::::::::: sect3
#### []{#_sql_abfragen_schreiben .hidden-anchor .sr-only}SQL-Abfragen schreiben {#heading__sql_abfragen_schreiben}

::: paragraph
Die einfachste Weise so ein SQL anzubinden, ist die Nutzung des
Check-Plugins [Oracle Database: Custom
SQLs.](https://checkmk.com/de/integrations/oracle_sql){target="_blank"}
Erstellen Sie dafür zunächst die Datei `MyCustomSQL.sql` in dem
Konfigurationsverzeichnis des Agenten auf dem Hosts, auf dem das SQL
ausgeführt werden soll.
:::

::: paragraph
Nachfolgend ein Dummy, welcher die Syntax veranschaulicht:
:::

::::: listingblock
::: title
/etc/check_mk/MyCustomSQL.sql
:::

::: content
``` {.pygments .highlight}
/*Syntax help in comments. The first word is alwyas the key word and ends with a ":"*/

/*details:Text to display in the service detail output*/
prompt details: Some details for the service output;

/*perfdata:METRIKNAME=CURRENTVALUE;WARN;CRIT;MAX METRIKNAME=CURRENTVALUE2;WARN;CRIT;MAX*/
prompt perfdata:MyMetricName1=10;15;20;30 MyMetricName2=16;15;20;30;
prompt perfdata:MyMetricName3=21;15;20;30 MyMetricName4=15;15;20;30;

/*long:Text to display in the long output of the service*/
prompt long: Here comes some long output for the service;
prompt long: Here comes some more long output for the service;

/*exit:Status of the service as a number*/
prompt exit:2;
```
:::
:::::

::: paragraph
Das Beispiel zeigt zum einen, dass Sie in einer solchen Datei beliebig
viele Anweisungen definieren können. Zum anderen ist die Syntax dem
eines [lokalen Checks](glossar.html#local_check) sehr ähnlich, vor allem
mit Blick auf die [Metriken.](glossar.html#metric) Im Detail ist diese
Syntax hier wesentlich mächtiger, da Sie mehrzeilige Ausgaben erzeugen
können und diese dann auf dem Checkmk-Server als ein Service verarbeitet
werden. Prinzipiell sind alle Zeilen optional und müssen nicht befüllt
werden.
:::

::: paragraph
Die möglichen Schlüsselwörter sind im Einzelnen:
:::

::: ulist
- `details`: Hier können Sie bestimmen, was im [Summary]{.guihint} des
  erzeugten Service ausgegeben werden soll. Die Zeile wird mit dem
  Schlüsselwort und einem Doppelpunkt eingeleitet. Der Rest der Zeile
  ergibt die Ausgabe.

- `perfdata`: Metriken werden mit diesem Schlüsselwort übergeben.
  Innerhalb einer Zeile können Sie beliebig viele Metriken --- getrennt
  durch ein Leerzeichen --- erzeugen. Sie können die Ausgabe der
  Metriken auch über mehrere Zeilen verteilen. Beginnen Sie dabei
  einfach immer mit dem Schlüsselwort `perfdata:`.

- `long`: Wenn der Service eine lange Ausgabe für das Feld
  [Details]{.guihint} haben soll, können Sie diese hier angeben. Auch
  dieses Schlüsselwort können Sie mehrmals verwenden, um mehrere Zeilen
  in den [Details]{.guihint} zu erzeugen.

- `exit`: Soll die Ausgabe einen bestimmten Status haben, können Sie
  diesen hier bestimmen. Es stehen Ihnen dabei die bekannten Zuordnungen
  `0`, `1`, `2`, `3` für die Status [OK]{.state0}, [WARN]{.state1},
  [CRIT]{.state2}, [UNKNOWN]{.state3} zur Verfügung.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das Schlüsselwort `elapsed`       |
|                                   | müssen Sie nicht manuell          |
|                                   | definieren. Es wird während der   |
|                                   | Laufzeit automatisch erzeugt, um  |
|                                   | zu prüfen, wie lange die von      |
|                                   | Ihnen definierten Anweisungen     |
|                                   | gebraucht haben.                  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::

:::::::::::: sect3
#### []{#_agentenplugin_konfigurieren .hidden-anchor .sr-only}Agentenplugin konfigurieren {#heading__agentenplugin_konfigurieren}

::: paragraph
Nachdem Sie nun Ihr erstes, sehr einfaches SQL definiert haben, machen
Sie es dem Agentenplugin `mk_oracle` bekannt. Das erfolgt über die
bekannte Konfigurationsdatei, die Sie entsprechend erweitern:
:::

::::: listingblock
::: title
/etc/check_mk/mk_oracle.cfg
:::

::: content
``` {.pygments .highlight}
SQLS_SECTIONS="mycustomsection1"

mycustomsection1 () {
    SQLS_SIDS="INST1"
    SQLS_DIR="/etc/check_mk"
    SQLS_SQL="MyCustomSQL.sql"
}
```
:::
:::::

::: paragraph
Mit der ersten Option (`SQLS_SECTIONS`) bestimmen Sie, welche
individuellen Sektionen Sie ausführen lassen möchten. Beachten Sie, dass
mit *Sektion* hier ein Teil der Ausgabe des Agentenplugins gemeint
ist --- und *nicht* ein Teil einer Datenbankinstanz. Im Beispiel haben
wir nur eine Sektion (`mycustomsection1`) angegeben und diese dann
direkt danach näher beschrieben. Jede Sektion ist also eigentlich eine
kleine Funktion, die vom Agentenplugin aufgerufen wird.
:::

::: paragraph
In dieser Funktion können Sie dann weitere Details bestimmen und
festlegen, für welche Instanzen (`SQLS_SIDS`) diese Sektion gilt.
Außerdem bestimmen Sie zusätzlich, wo sich die Datei mit den
SQL-Anweisungen befindet (`SQLS_DIR`) und wie diese Datei heißt
(`SQLS_SQL`).
:::

::: paragraph
Diese einfache Konfiguration reicht bereits aus, um das Ergebnis in
Checkmk sehen zu können. Führen Sie dafür eine
[Service-Erkennung](glossar.html#service_discovery) durch und aktivieren
Sie den neuen Service. Danach sehen Sie ihn bei den anderen Services in
der Übersicht des Hosts:
:::

:::: imageblock
::: content
![Der neue, durch benutzerdefinierte SQL-Abfragen erzeugte Service in
der Service-Liste.](../images/monitoring_oracle_custom_sqls_list.png)
:::
::::
::::::::::::
:::::::::::::::::::::::

::::: sect2
### []{#adv_custom_sqls .hidden-anchor .sr-only}7.3. Erweiterte Optionen {#heading_adv_custom_sqls}

::: paragraph
Die Möglichkeiten, mit benutzerdefinierten SQL-Abfragen zu überwachen,
gehen natürlich über das einfache, oben gezeigte Beispiel hinaus. Im
nachfolgenden finden Sie eine Übersicht der verfügbaren Variablen, die
Sie in der Konfigurationsdatei `mk_oracle.cfg` nutzen können. Für eine
ausführliche Beschreibung können Sie auch das Agentenplugin `mk_oracle`
mit der Option `--help` aufrufen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Variablen, die nur außerhalb oder |
|                                   | nur innerhalb einer               |
|                                   | Sektions-Funktion gesetzt werden  |
|                                   | können, sind entsprechend         |
|                                   | markiert. Alle anderen können in  |
|                                   | beiden Bereichen definiert        |
|                                   | werden. Werden sie außerhalb      |
|                                   | einer Sektion gesetzt, gelten sie |
|                                   | global für alle Sektionen.        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

+------+------------------------------------------------------------+---+
| Vari | Kurzbeschreibung                                           | O |
| able |                                                            | p |
|      |                                                            | t |
|      |                                                            | i |
|      |                                                            | o |
|      |                                                            | n |
|      |                                                            | a |
|      |                                                            | l |
+======+============================================================+===+
| `SQ  | Die selbst definierten Sektions-Funktionen, die vom        | N |
| LS_S | Agentenplugin ausgeführt werden sollen.\                   | e |
| ECTI | Diese Variable kann nur global gesetzt werden (außerhalb   | i |
| ONS` | einer Sektions-Funktion).                                  | n |
+------+------------------------------------------------------------+---+
| `SQ  | Die Instanzen, welche die Sektion(en) ausführen sollen.    | N |
| LS_S |                                                            | e |
| IDS` |                                                            | i |
|      |                                                            | n |
+------+------------------------------------------------------------+---+
| `S   | Der Pfadname des Verzeichnisses, in dem die Dateien mit    | N |
| QLS_ | den benutzerdefinierten SQL-Abfragen abgelegt sind.        | e |
| DIR` |                                                            | i |
|      |                                                            | n |
+------+------------------------------------------------------------+---+
| `S   | Die Datei, welche die SQL-Anweisungen für eine Sektion     | N |
| QLS_ | enthält.                                                   | e |
| SQL` |                                                            | i |
|      |                                                            | n |
+------+------------------------------------------------------------+---+
| `SQ  | Der Name der Sektion, die Sie mit einem [eigenen           | J |
| LS_S | Check-Plugin](#own_check_plug-in) für die                  | a |
| ECTI | benutzerdefinierten SQL-Abfragen auswerten.                |   |
| ON_N |                                                            |   |
| AME` |                                                            |   |
+------+------------------------------------------------------------+---+
| `S   | Der Separator der einzelnen Elemente in einer Zeile der    | J |
| QLS_ | Ausgabe, definiert als dezimale                            | a |
| SECT | [ASCII](                                                   |   |
| ION_ | https://de.wikipedia.org/wiki/American_Standard_Code_for_I |   |
| SEP` | nformation_Interchange#ASCII-Tabelle){target="_blank"}-ID. |   |
|      | Diese Variable kann nur in Verbindung mit der Variablen    |   |
|      | `SQLS_SECTION_NAME` benutzt werden. Wir empfehlen, für     |   |
|      | eigene Sektionen auch einen eigenen Separator festzulegen  |   |
|      | und dabei die ASCII-ID `124` für das Pipe-Zeichen (`|`) zu |   |
|      | verwenden, da auch das Agentenplugin im Fehlerfall die     |   |
|      | Elemente der Ausgabe stets mit `|` trennt, im Format       |   |
|      | `<SID>|FAILURE|<error description>`. Die folgenden Zeichen |   |
|      | dürfen *nicht* als Separator verwendet werden: `;` `[` `]` |   |
|      | `=`                                                        |   |
+------+------------------------------------------------------------+---+
| `SQL | Bestimmt einen Teil des generierten Service-Namens.        | J |
| S_IT | Standardmäßig wird der Service-Name aus SID und dem        | a |
| EM_N | Dateinamen mit den benutzerdefinierte SQL-Abfragen         |   |
| AME` | zusammengesetzt. Der Wert dieser Variable ersetzt im       |   |
|      | Service-Namen den Dateinamen.\                             |   |
|      | Diese Variable kann nur lokal gesetzt werden (innerhalb    |   |
|      | einer Sektions-Funktion). Sie kann nicht zusammen mit der  |   |
|      | Variable `SQLS_SECTION_NAME` benutzt werden.               |   |
+------+------------------------------------------------------------+---+
| `SQL | Erfüllt dieselbe Aufgabe, wie                              | J |
| S_MA | [`CACHE_MAXAGE`](#sections) --- allerdings für die         | a |
| X_CA | benutzerdefinierten SQL-Abfragen.                          |   |
| CHE_ |                                                            |   |
| AGE` |                                                            |   |
+------+------------------------------------------------------------+---+
| `    | Bestimmt einen individuellen Benutzer für eine Sektion.    | J |
| SQLS |                                                            | a |
| _DBU |                                                            |   |
| SER` |                                                            |   |
+------+------------------------------------------------------------+---+
| `    | Bestimmt das Passwort des mit `SQLS_DBUSER` festgelegten   | J |
| SQLS | Benutzers.                                                 | a |
| _DBP |                                                            |   |
| ASSW |                                                            |   |
| ORD` |                                                            |   |
+------+------------------------------------------------------------+---+
| `SQ  | Nur wenn der mit `SQLS_DBUSER` festgelegte Benutzer        | J |
| LS_D | `SYSDBA` oder `SYSOPER` ist, müssen Sie mit dieser         | a |
| BSYS | Variablen die zugehörige Rolle (`SYSDBA` oder `SYSOPER`)   |   |
| CONN | bestimmen.                                                 |   |
| ECT` |                                                            |   |
+------+------------------------------------------------------------+---+
| `SQ  | Bestimmt einen individuellen [TNS-Alias](#tns_config) für  | J |
| LS_T | eine Sektion.                                              | a |
| NSAL |                                                            |   |
| IAS` |                                                            |   |
+------+------------------------------------------------------------+---+
:::::

::::: sect2
### []{#own_check_plug-in .hidden-anchor .sr-only}7.4. Eigene Check-Plugins nutzen {#heading_own_check_plug-in}

::: paragraph
Sollten Ihnen die Möglichkeiten der oben beschriebenen Syntax nicht
ausreichen, können Sie über die Variable `SQLS_SECTION_NAME` auch eigene
Sektionsnamen für ein oder mehrere SQL-Abfragen ausgeben lassen, und mit
`SQLS_SECTION_SEP` einen eigenen Separator festlegen. Das setzt
allerdings voraus, dass Sie auch ein entsprechendes Check-Plugin
geschrieben und in Ihre Checkmk-[Instanz](glossar.html#site) eingebunden
haben.
:::

::: paragraph
Mit einem eigenen Check-Plugin sind Sie komplett frei, wie Sie die
Ausgabe der selbst definierten Sektionen des Agentenplugins auswerten
und können ganz eigene Wege gehen. Da dieser Weg der umfangreichste und
auch schwierigste ist, ist er hier nur der Vollständigkeit halber
erwähnt. Er setzt voraus, dass Sie wissen, wie man ein [agentenbasiertes
Check-Plugin](devel_check_plugins.html) schreibt und in die Instanz
einbindet. Danach ordnen Sie die individuellen SQL-Abfragen mit den
Variablen diesem Check-Plugin zu.
:::
:::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#diagnostic .hidden-anchor .sr-only}8. Diagnosemöglichkeiten {#heading_diagnostic}

::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Unter Linux erfolgt die Diagnose durch Aufruf des Agentenplugins
`mk_oracle` mit verschiedenen Optionen. Mit `mk_oracle --help` können
Sie sich eine Übersicht aller verfügbaren Optionen anzeigen lassen.
:::

::::::::::::::::::::: sect2
### []{#connection_test .hidden-anchor .sr-only}8.1. Verbindungstest {#heading_connection_test}

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Der im folgenden beschriebene     |
|                                   | Verbindungstest überprüft auch,   |
|                                   | ob die notwendigen Zugriffsrechte |
|                                   | bei der Ausführung unter          |
|                                   | [Linux](#access_linux) oder       |
|                                   | [Windows](#access_windows)        |
|                                   | gesetzt sind. Falls               |
|                                   | Zugriffsrechte fehlen, werden     |
|                                   | diese angezeigt mit konkreten     |
|                                   | Vorschlägen zur Behebung. Das     |
|                                   | genaue Vorgehen bei der Diagnose  |
|                                   | und Korrektur von Zugriffsrechten |
|                                   | können Sie in der [Checkmk        |
|                                   | Knowledge                         |
|                                   | Base](https://chec                |
|                                   | kmk.atlassian.net/wiki/spaces/KB/ |
|                                   | pages/70582273/){target="_blank"} |
|                                   | nachlesen.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::::::::: sect3
#### []{#_linux_solaris_aix .hidden-anchor .sr-only}Linux, Solaris, AIX {#heading__linux_solaris_aix}

::: paragraph
Sollten Sie Problem mit der Verbindung zu einer oder mehreren Instanzen
auf einem Oracle-Server haben, können Sie als Erstes grundlegende
Parameter prüfen lassen. Wenn Sie das Agentenplugin mit der Option `-t`
starten, gibt es die Details zu einer Verbindung aus. Beachten Sie, dass
dem Agentenplugin zuvor die Pfade zu seiner Konfigurationsdatei und zu
den zwischengespeicherten Daten des Plugins bekannt gemacht werden muss.
In der Ausgabe wurden die *Dummy-Sektionen* zugunsten der Lesbarkeit
weggelassen.
:::

::: paragraph
Im Folgenden das Beispiel für einen Linux-Server mit `systemd`, auf dem
das Agentenplugin alle 60 Sekunden [asynchron](#install_linux)
ausgeführt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# export MK_CONFDIR="/etc/check_mk/"; export MK_VARDIR="/var/lib/check_mk_agent"
root@linux# /usr/lib/check_mk_agent/plugins/60/mk_oracle -t --no-spool
---login----------------------------------------------------------------
    Operating System:       Linux
    ORACLE_HOME (oratab):   /u01/app/oracle/product/11.2.0/xe
    Logincheck to Instance: XE
    Version:                11.2
    Login ok User:          checkmk on ORA-SRV01 Instance XE
    SYNC_SECTIONS:          instance dataguard_stats processes longactivesessions sessions recovery_status undostat logswitches recovery_area performance
    ASYNC_SECTIONS:         tablespaces rman jobs ts_quotas resumable
------------------------------------------------------------------------
```
:::
::::

::: paragraph
Auf einem Linux-Server mit `xinetd` rufen Sie stattdessen `mk_oracle`
für den Verbindungstest wie folgt auf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/plugins/mk_oracle -t
```
:::
::::

::: paragraph
Da man diesen Aufruf eher im Fehlerfall machen wird, werden Sie dann
auch weitere Informationen erhalten: Sowohl den *Connection String,*
welcher für die Verbindung benutzt wurde, als auch die ersten 100
Zeichen der Fehlermeldung, die bei dem Verbindungsversuch zurückgegeben
wurden. Mit Hilfe dieser Informationen können Sie bereits schnell
einfache Konfigurationsprobleme identifizieren und dann auch
entsprechend beheben.
:::
:::::::::::

:::::::::: sect3
#### []{#_windows .hidden-anchor .sr-only}Windows {#heading__windows}

::: paragraph
Das Agentenplugin akzeptiert unter Windows keine Parameter. Um hier also
die Verbindung zu testen, limitieren Sie temporär die abzurufenden
Sektionen auf `instance` und aktivieren Sie die Option `DEBUG`:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk_oracle_cfg.ps1
:::

::: content
``` {.pygments .highlight}
# Syntax:
# $DBUSER = @("USERNAME", "PASSWORD")
$DBUSER = @("checkmk", "myPassword")

SYNC_SECTIONS = @("instance")
ASYNC_SECTIONS = @("")
DEBUG = 1
```
:::
:::::

::: paragraph
Führen Sie danach das Agentenplugin manuell aus. Auch hier werden Sie
Informationen darüber bekommen, wie das Plugin versucht, auf die
Instanzen zuzugreifen. Eine Ausgabe kann dann z.B. so aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\ProgramData\checkmk\agent\plugins\> .\mk_oracle.ps1
2020-08-23T12:48:20.3930944+02:00 DEBUG:value of DBVERSION software = xxx112020xxx
<<<oracle_instances>>>
2020-08-23T12:48:20.3930944+02:00 DEBUG:value of inst_name = xxxXExxx
2020-08-23T12:48:20.3930944+02:00 DEBUG:value of DBVERSION database = xxx112020xxx
2020-08-23T12:48:20.3930944+02:00 DEBUG:value of the_section = sql_instance
2020-08-23T12:48:20.3930944+02:00 DEBUG:now calling multiple SQL
2020-08-23T12:48:20.3930944+02:00 DEBUG:value of sql_connect in dbuser = checkmk/myPassword@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SID=XE))) as sysdba
<<<oracle_instance>>>
XE|FAILURE|...
```
:::
::::
::::::::::
:::::::::::::::::::::

:::::::::::::: sect2
### []{#logging .hidden-anchor .sr-only}8.2. Logging {#heading_logging}

::::::::::: sect3
#### []{#_linux_solaris_aix_2 .hidden-anchor .sr-only}Linux, Solaris, AIX {#heading__linux_solaris_aix_2}

::: paragraph
Falls der Fehler nicht durch die Prüfung einer einfachen Verbindung
gefunden werden kann, können Sie als nächsten Schritt eine Log-Datei
anlegen lassen, welche sämtliche Schritte des Agentenplugins
protokolliert. Vergessen Sie auch hier nicht die notwendigen
Umgebungsvariablen: Auch im folgenden Beispiel wurde die Ausgabe der
Sektionen übersprungen, um die Lesbarkeit zu erhöhen.
:::

::: paragraph
Hier der Aufruf für einen Linux-Server mit `systemd`, auf dem das
Agentenplugin alle 60 Sekunden [asynchron](#install_linux) ausgeführt
wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# export MK_CONFDIR="/etc/check_mk/"; export MK_VARDIR="/var/lib/check_mk_agent"
root@linux# /usr/lib/check_mk_agent/plugins/60/mk_oracle -l --no-spool
Start logging to file: /var/lib/check_mk_agent/log/mk_oracle.log
```
:::
::::

::: paragraph
Hier der Aufruf von `mk_oracle` für das Logging auf einem Linux-Server
mit `xinetd`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/plugins/mk_oracle -l
```
:::
::::

::: paragraph
Mit Hilfe der erzeugten Log-Datei können Sie sehr genau identifizieren,
an welcher Zeile des Skripts das Problem auftritt.
:::
:::::::::::

:::: sect3
#### []{#_windows_2 .hidden-anchor .sr-only}Windows {#heading__windows_2}

::: paragraph
Das Logging unter Windows funktioniert ähnlich wie der oben beschriebene
Verbindungstest. Ist die Verbindung selbst stabil, können Sie in der
Konfigurationsdatei die echten Sektionen wieder hinzufügen und bekommen
dann entsprechend eine komplette Logging-Ausgabe.
:::
::::
::::::::::::::

:::::::::::::::: sect2
### []{#debugging .hidden-anchor .sr-only}8.3. Debugging {#heading_debugging}

::::::::::: sect3
#### []{#_linux_solaris_aix_3 .hidden-anchor .sr-only}Linux, Solaris, AIX {#heading__linux_solaris_aix_3}

::: paragraph
Wenn Sie auch mit Hilfe des Logs nicht an das Problem kommen, bietet das
Agentenplugin als letzte Möglichkeit der Fehleranalyse die komplette
Ausgabe aller Schritte. Diese Ausgabe ist entsprechend auch die
umfangreichste und sicherlich auch die am schwersten zu lesende
Möglichkeit, an die Ursache eines Problems zu kommen und sollte daher
auch nur als letztes Mittel eingesetzt werden.
:::

::: paragraph
Im Folgenden das Beispiel für das Debugging auf einem Linux-Server mit
`systemd`, auf dem das Agentenplugin alle 60 Sekunden
[asynchron](#install_linux) ausgeführt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# export MK_CONFDIR="/etc/check_mk/"; export MK_VARDIR="/var/lib/check_mk_agent"
root@linux# /usr/lib/check_mk_agent/plugins/60/mk_oracle -d --no-spool
```
:::
::::

::: paragraph
Hier der Aufruf von `mk_oracle` für das Debugging auf einem Linux-Server
mit `xinetd`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /usr/lib/check_mk_agent/plugins/mk_oracle -d
```
:::
::::

::: paragraph
**Wichtig:** In dieser Ausgabe werden keine sensiblen Daten wie
Passwörter maskiert. Es ist also alles in Klartext lesbar.
:::
:::::::::::

:::::: sect3
#### []{#_windows_3 .hidden-anchor .sr-only}Windows {#heading__windows_3}

::: paragraph
Unter Windows steht Ihnen eine ähnliche Funktionalität zur Verfügung. Da
Sie dem Agentenplugin keine Argumente übergeben können, müssen Sie das
Tracing allerdings manuell anschalten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS C:\ProgramData\checkmk\agent\plugins\> Set-PSDebug -Trace 1
PS C:\ProgramData\checkmk\agent\plugins\> .\mk_oracle.ps1
```
:::
::::
::::::
::::::::::::::::

:::: sect2
### []{#ora-01031 .hidden-anchor .sr-only}8.4. Fehlermeldungen in Oracle Log-Dateien {#heading_ora-01031}

::: paragraph
Der [Datenbankbenutzer](#create_user) für das Monitoring benötigt in der
Regel nicht die Rolle `SYSDBA`. Beachten Sie aber, dass das
Agentenplugin `mk_oracle` bei Multi-Tenant-Datenbanken (für das
Monitoring nicht relevante) Fehlermeldungen erzeugen kann, die eventuell
wegen der fehlenden `SYSDBA`-Berechtigung nicht in Log-Dateien der
Oracle-Datenbank geschrieben werden können. Dies kann dann z.B. zu
Oracle-Fehlermeldungen der Art `ORA-01031: insufficient privileges` in
einer Alert-Log-Datei führen.
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}9. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: sect2
### []{#_auf_dem_oracle_host_unter_linux_solaris_aix .hidden-anchor .sr-only}9.1. Auf dem Oracle-Host unter Linux, Solaris, AIX {#heading__auf_dem_oracle_host_unter_linux_solaris_aix}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `/usr/bin/check_mk_agent`         | Der Checkmk-Agent, welcher alle   |
|                                   | Daten zu dem Host sammelt.        |
+-----------------------------------+-----------------------------------+
| `/us                              | Das Oracle-Agentenplugin im       |
| r/lib/check_mk/plugins/mk_oracle` | üblichen Verzeichnis für          |
|                                   | Agentenplugins. Beachten Sie,     |
|                                   | dass der Pfadname unter AIX etwas |
|                                   | anders ist:                       |
|                                   | `/us                              |
|                                   | r/check_mk/lib/plugins/mk_oracle` |
+-----------------------------------+-----------------------------------+
| `/etc/check_mk/oracle.cfg`        | Die Konfigurationsdatei für das   |
|                                   | Agentenplugin. Auch hier          |
|                                   | unterscheidet sich AIX:           |
|                                   | `                                 |
|                                   | /usr/check_mk/conf/mk_oracle.cfg` |
+-----------------------------------+-----------------------------------+
| `/etc/check_mk/sqlnet.ora`        | Die Konfigurationsdatei, welche   |
|                                   | für das                           |
|                                   | [Oracle-Wallet](#oracle_wallet)   |
|                                   | benötigt wird.                    |
+-----------------------------------+-----------------------------------+
| `/etc/check_mk/tnsnames.ora`      | Die Konfigurationsdatei, welche   |
|                                   | TNS-Alias enthält.                |
|                                   | Beispieldateien liegen auch in    |
|                                   | der Oracle-Installation, aber da  |
|                                   | sich der Pfad je nach             |
|                                   | Installation unterscheidet, kann  |
|                                   | er nicht pauschal angegeben       |
|                                   | werden.                           |
+-----------------------------------+-----------------------------------+
:::

::: sect2
### []{#_auf_dem_oracle_host_unter_windows .hidden-anchor .sr-only}9.2. Auf dem Oracle-Host unter Windows {#heading__auf_dem_oracle_host_unter_windows}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `C:\Program Files (x86)\ch        | Der Agent, welcher alle Daten zu  |
| eckmk\service\check_mk_agent.exe` | dem Host sammelt.                 |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\che               | Das Oracle-Agentenplugin im       |
| ckmk\agent\plugins\mk_oracle.ps1` | üblichen Verzeichnis für          |
|                                   | Agentenplugins.                   |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\checkm            | Die Konfigurationsdatei für das   |
| k\agent\config\mk_oracle_cfg.ps1` | Agentenplugin.                    |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData                   | Die Konfigurationsdatei, welche   |
| \checkmk\agent\config\sqlnet.ora` | für das Oracle-Wallet benötigt    |
|                                   | wird.                             |
+-----------------------------------+-----------------------------------+
| `C:\ProgramData\c                 | Die Konfigurationsdatei, welche   |
| heckmk\agent\config\tnsnames.ora` | TNS-Alias enthält.                |
|                                   | Beispieldateien liegen auch in    |
|                                   | der Oracle-Installation, aber da  |
|                                   | sich der Pfad je nach             |
|                                   | Installation unterscheidet, kann  |
|                                   | er nicht pauschal angegeben       |
|                                   | werden.                           |
+-----------------------------------+-----------------------------------+
:::

::: sect2
### []{#files_cmk .hidden-anchor .sr-only}9.3. Auf dem Checkmk-Server {#heading_files_cmk}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/share/c                        | Das Agentenplugin für Unix-artige |
| heck_mk/agents/plugins/mk_oracle` | Systeme, welches auf dem          |
|                                   | Oracle-Host die Daten holt.       |
+-----------------------------------+-----------------------------------+
| `~/share/check                    | Dieses Agentenplugin für          |
| _mk/agents/plugins/mk_oracle_crs` | Unix-artige Systeme liefert Daten |
|                                   | zu einem Oracle Cluster Manager.  |
+-----------------------------------+-----------------------------------+
| `~/share/check_mk/agen            | Das Agentenplugin für Windows,    |
| ts/windows/plugins/mk_oracle.ps1` | welches auf dem Oracle-Host die   |
|                                   | Daten holt.                       |
+-----------------------------------+-----------------------------------+
| `~/sha                            | Hier befinden sich beispielhafte  |
| re/check_mk/agents/cfg_examples/` | Konfigurationsdateien für         |
|                                   | Unix-artige Systeme in den        |
|                                   | Dateien `mk_oracle.cfg`,          |
|                                   | `sqlnet.ora` und `tnsnames.ora`.  |
+-----------------------------------+-----------------------------------+
| `~/share/check_mk/agents/window   | Eine beispielhafte                |
| s/cfg_examples/mk_oracle_cfg.ps1` | Konfigurationsdatei für Windows.  |
+-----------------------------------+-----------------------------------+
:::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
