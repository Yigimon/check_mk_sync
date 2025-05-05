:::: {#header}
# MSSQL mit dem Legacy-Plugin überwachen

::: details
[Last modified on 17-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/monitoring_mssql_legacy.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Windows überwachen](agent_windows.html)
[Monitoring-Agenten](wato_monitoringagents.html) [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#preface .hidden-anchor .sr-only}1. Vorwort {#heading_preface}

:::::: sectionbody
::: paragraph
Das alte Plugin (`mssql.vbs`) für das Monitoring von Microsoft SQL
Server wurde ersetzt. Wenn Ihre Ihre SQL Server-Netzwerkkonfiguration
den Zugriff per TCP/IP erlaubt, empfehlen wir das neue Plugin zu
verwenden.
:::

::: paragraph
Wie Sie das neue Plugin einrichten und verwenden, erklären wir im
Artikel [Microsoft SQL Server überwachen](monitoring_mssql.html)
:::

::: paragraph
`mssql.vbs` wird mit den Version [2.4.0]{.new} von Checkmk entfernt
(vgl. [Werk #15844](https://checkmk.com/werk/15844)).
:::
::::::
:::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}2. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Checkmk erlaubt Ihnen die umfangreiche Überwachung von Microsoft SQL
Server. Eine vollständige Liste der Überwachungsmöglichkeiten können Sie
in unserem [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=mssql){target="_blank"}
nachlesen. Unter anderem kann Checkmk die folgenden Werte überwachen:
:::

::: ulist
- [MS SQL: Availability
  Groups](https://checkmk.com/de/integrations/mssql_availability_groups){target="_blank"}

- [MS SQL: General
  State](https://checkmk.com/de/integrations/mssql_instance){target="_blank"}

- [MS SQL: Size of
  Datafiles](https://checkmk.com/de/integrations/mssql_datafiles){target="_blank"}

- [MS SQL Database:
  Connections](https://checkmk.com/de/integrations/mssql_connections){target="_blank"}

- [MS SQL Database:
  Jobs](https://checkmk.com/de/integrations/mssql_jobs){target="_blank"}

- [MS SQL Database:
  Properties](https://checkmk.com/de/integrations/mssql_databases){target="_blank"}

- [MS SQL Server: Blocked
  Sessions](https://checkmk.com/de/integrations/mssql_blocked_sessions){target="_blank"}

- [MS SQL Server: Cache Hit
  Ratio](https://checkmk.com/de/integrations/mssql_counters_cache_hits){target="_blank"}

- [MS SQL Server: Page
  Activity](https://checkmk.com/de/integrations/mssql_counters_pageactivity){target="_blank"}

- [MS SQL Tablespaces: Locks per
  Second](https://checkmk.com/de/integrations/mssql_counters_locks){target="_blank"}

- [MS SQL Tablespaces: Size
  Information](https://checkmk.com/de/integrations/mssql_tablespaces){target="_blank"}

- [MS SQL Tablespaces: Transactions per
  Second](https://checkmk.com/de/integrations/mssql_counters_transactions){target="_blank"}
:::

::: paragraph
Um die Datenbanken überwachen zu können, benötigen Sie neben dem
Checkmk-Agenten lediglich das Agentenplugin auf dem Datenbank-Server.
Zusätzliche Software wird weder auf dem Checkmk- noch auf dem
Datenbank-Server benötigt.
:::

::: paragraph
Im Folgenden wird die Einrichtung für Windows-Hosts beschrieben. Weiter
unten gehen wir auf die Einrichtung über die
[Agentenbäckerei](monitoring_mysql.html#bakery) ein.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#setup_monitoring .hidden-anchor .sr-only}3. Überwachung einrichten {#heading_setup_monitoring}

::::::::::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_systembenutzer_verwenden .hidden-anchor .sr-only}3.1. Systembenutzer verwenden {#heading__systembenutzer_verwenden}

::: paragraph
Wenn Sie den Systembenutzer (`NT AUTHORITY\SYSTEM`) für das Monitoring
verwenden können, achten Sie darauf, dass dieses Konto (*login*),
mindestens Berechtigungen für die folgenden sicherungsfähigen Elemente
([Securables]{.guihint}) benötigt:
:::

::: ulist
- Verbindung mit beliebiger Datenbank ([Connect any database]{.guihint})

- [View Server State]{.guihint}

- [Connect SQL]{.guihint}
:::

::: paragraph
In Abhängigkeit davon, welche Datenbanken Ihrer Instanzen Sie überwachen
möchten und je nachdem über welche Server-Rollen und Mappings der
Systembenutzer (`NT AUTHORITY\SYSTEM`) bereits verfügt, kann es
notwendig sein, auch die Berechtigung für [Connect Any
Database]{.guihint} zu erteilen.
:::
::::::

:::::::::::::::::::::: sect2
### []{#setup_user .hidden-anchor .sr-only}3.2. Exkurs: Neuen Benutzer einrichten {#heading_setup_user}

::: paragraph
Sollte es unbedingt notwendig sein, dass in Ihrem Unternehmen nicht der
Systembenutzer verwendet wird, so müssen Sie in den zu überwachenden
Instanzen einen passenden Datenbankbenutzer für das Monitoring anlegen.
Die Grundvoraussetzung in MSSQL ist, dass die [Server
authentication]{.guihint} auf [SQL Server and Windows Authentication
mode]{.guihint} gestellt ist. Wenn Sie nicht den Windows-eigenen
Systembenutzer verwenden können, dürfte diese Voraussetzung zwar bereits
erfüllt sein, sie soll aber auch nicht unerwähnt bleiben.
:::

::: paragraph
Melden Sie sich nun mit einem Benutzer mit ausreichenden
Zugriffsberechtigungen in MSSQL an und erstellen Sie über das Microsoft
SQL Server Management Studio einen neuen Datenbankbenutzer:
:::

:::: imageblock
::: content
![Auswahl der Option \'New Login\...\' in
MSSQL.](../images/mssql_new_user.png){width="38%"}
:::
::::

::: paragraph
Dieser neu angelegte Benutzer benötigt die oben genannte Berechtigung.
Gehen Sie in den [Object Explorer]{.guihint}, öffnen Sie [Security \>
Logins]{.guihint} und dann die Eigenschaften des Kontos (*login*),
welche Sie für das Agentenplugin konfiguriert haben. Unter
[Securables]{.guihint} finden Sie die explizite Berechtigung [Connect
any database,]{.guihint} welche Sie erteilen müssen.
:::

:::: imageblock
::: content
![Berechtigung \'Connect any database\'
erteilen.](../images/mssql_permissions.png)
:::
::::

::: paragraph
Alternativ können Sie den Benutzer und die Berechtigungen auch über die
Befehlszeile erzeugen. Im folgenden Beispiel wird das für den Benutzer
`checkmk` erledigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mssql> USE master;
      CREATE USER checkmk WITH PASSWORD = 'MyPassword123';
      GO
```
:::
::::

::: paragraph
und danach:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mssql> USE master;
      GRANT CONNECT ANY DATABASE TO checkmk;
      GO
```
:::
::::

:::::::: sect3
#### []{#_konfigurationsdatei_erstellen .hidden-anchor .sr-only}Konfigurationsdatei erstellen {#heading__konfigurationsdatei_erstellen}

::: paragraph
Auf dem Windows-Host legen Sie im unten angegebenen Verzeichnis eine
Datei `mssql.ini` an:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mssql.ini
:::

::: content
``` {.pygments .highlight}
[client]
user=checkmk
password=MyPassword123
```
:::
:::::

::: paragraph
Sollten Sie auf dem Host mehrere MSSQL-Instanzen mit verschiedenen
Benutzernamen und Passwörtern betreiben, erstellen Sie einfach pro
Instanz eine `ini`-Datei nach dem Namensschema `mssql_instance-ID.ini`.
:::
::::::::
::::::::::::::::::::::

:::::: sect2
### []{#_agentenplugin_installieren .hidden-anchor .sr-only}3.3. Agentenplugin installieren {#heading__agentenplugin_installieren}

::: paragraph
Der Agent für Windows wird standardmäßig bereits mit einer ganzen Reihe
von Plugins ausgeliefert. Deshalb finden Sie auch das Plugin für die
Überwachung von MSSQL nach der Installation des Agenten bereits auf
Ihrem Host. Die Plugin-Datei kopieren Sie für die Verwendung nur noch in
das richtige Verzeichnis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> copy "c:\Program Files (x86)\checkmk\service\plugins\mssql.vbs" c:\ProgramData\checkmk\agent\plugins\
```
:::
::::
::::::

:::::: sect2
### []{#_services_einrichten .hidden-anchor .sr-only}3.4. Services einrichten {#heading__services_einrichten}

::: paragraph
Nachdem Sie das Plugin nun installiert und konfiguriert haben, können
Sie für diesen Host eine
[Service-Erkennung](glossar.html#service_discovery) durchführen. Der
folgende Screenshot zeigt dabei nur eine Auswahl der auffindbaren
Services:
:::

:::: imageblock
::: content
![Auszug der Service-Erkennung.](../images/mssql_discovery.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#extended_configuration .hidden-anchor .sr-only}4. Erweiterte Konfiguration {#heading_extended_configuration}

::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_asynchrone_ausführung_des_agentenplugins .hidden-anchor .sr-only}4.1. Asynchrone Ausführung des Agentenplugins {#heading__asynchrone_ausführung_des_agentenplugins}

::: paragraph
Das Plugin für die Überwachung von MSSQL kann - wie so viele andere -
asynchron ausgeführt werden, um beispielsweise längeren Laufzeiten bei
großen MSSQL-Instanzen Rechnung zu tragen.
:::

::: paragraph
Um das Plugin unter Windows asynchron auszuführen, passen Sie die
Konfiguration des Agenten an und erweitern die Sektion `execution` unter
`plugins` um den folgenden Eintrag:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\check_mk.user.yml
:::

::: content
``` {.pygments .highlight}
plugins:
    execution:
        - pattern: mssql.vbs
          cache_age: 300
          async: yes
```
:::
:::::

::: paragraph
Eine detaillierte Anleitung zur asynchronen Ausführung von Plugins auf
einem Windows-Host finden Sie im Artikel über den
[Windows-Agenten.](agent_windows.html#customizeexecution)
:::
:::::::::

::::::::::: sect2
### []{#_schwellwerte_konfigurieren .hidden-anchor .sr-only}4.2. Schwellwerte konfigurieren {#heading__schwellwerte_konfigurieren}

:::::: sect3
#### []{#_verbindungen_überwachen .hidden-anchor .sr-only}Verbindungen überwachen {#heading__verbindungen_überwachen}

::: paragraph
Für die Auslastung der durch MSSQL vorgegebenen maximalen Anzahl an
gleichzeitigen Verbindungen können Sie eigene Schwellwerte vorgeben, da
diese viel stärker als bei anderen Services vom Aufbau Ihrer
MSSQL-Instanz abhängig sind. Die Einrichtung entsprechender Schwellwerte
lässt sich mit einer Regel aus dem Regelsatz [MSSQL
Connections]{.guihint} im Handumdrehen bewerkstelligen.
:::

:::: imageblock
::: content
![Einstellung der oberen Schwellwerte für aktive
Verbindungen.](../images/mssql_connections.png)
:::
::::
::::::

:::::: sect3
#### []{#_dateigröße_überwachen .hidden-anchor .sr-only}Dateigröße überwachen {#heading__dateigröße_überwachen}

::: paragraph
Auch für die Größe einzelner Dateien in MSSQL können Sie Schwellwerte
festlegen. Dazu verwenden Sie den Regelsatz [MSSQL datafile
sizes.]{.guihint}
:::

:::: imageblock
::: content
![Einstellung der genutzten
Dateigrößen.](../images/mssql_size_datafile.png)
:::
::::
::::::
:::::::::::
:::::::::::::::::::
::::::::::::::::::::

:::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}5. Konfiguration über die Agentenbäckerei {#heading_bakery}

::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Einrichtung
wird in den kommerziellen Editionen mittels der
[Agentenbäckerei](glossar.html#agent_bakery) sehr vereinfacht, da
Syntaxfehler in den Konfigurationsdateien vermieden werden und
Anpassungen an sich verändernde Umgebungen einfach bewerkstelligt werden
können. Der wesentliche Unterschied zu einer manuellen Installation ist,
dass Sie nur noch dann auf dem MSSQL-Host auf der Kommandozeile arbeiten
müssen, wenn Sie spezielle MSSQL-spezifische Konfigurationen vornehmen
möchten.
:::

::: paragraph
Für die erste Einrichtung reicht es, wenn Sie den [Datenbankbenutzer auf
dem MSSQL-Host einrichten](#setup_user) und eine entsprechende Regel in
der Agentenbäckerei anlegen. Sie finden den Regelsatz unter [Setup \>
Agents \> Windows, Linux, Solaris, AIX \> Agent rules.]{.guihint} In dem
Suchfeld können Sie dann nach `mssql` suchen:
:::

:::: imageblock
::: content
![Die Regel \'Microsoft SQL Server\' in den
Agentenregeln.](../images/mssql_bakery_ruleset_search.png)
:::
::::

::: paragraph
Wählen Sie in der neuen Regel im Abschnitt [Microsoft SQL Server
(Windows)]{.guihint} idealerweise die Option [System
Authentication]{.guihint} für eine einfache und problemlose Anbindung.
:::

:::: imageblock
::: content
![Mögliche Einstellungen für den MSSQL Server in der
Agentenbäckerei.](../images/mssql_bakery.png)
:::
::::

::: paragraph
Entscheiden Sie sich stattdessen für die Option [Database User
Credentials]{.guihint}, so müssen Sie zusätzlich [User ID]{.guihint} und
[Password]{.guihint} des gewünschten Datenbanknutzers angeben (z.B. des
Benutzers, den Sie [zuvor](#setup_user) angelegt haben).
:::
:::::::::::
::::::::::::

::::::::::::::::::::: sect1
## []{#diagnostic .hidden-anchor .sr-only}6. Diagnosemöglichkeiten {#heading_diagnostic}

:::::::::::::::::::: sectionbody
::: paragraph
Sollte es beispielsweise bei der Einrichtung der Überwachung zu
unerwartetem Verhalten oder Problemen kommen, so empfiehlt sich eine
Prüfung direkt auf einem betroffenen Host. Da es sich bei dem Plugin für
die Überwachung von MSSQL um Shell- bzw. Visual Basic-Skripte handelt,
können diese leicht auch ohne den Agenten ausgeführt werden. Der Shell
bzw. der Kommandozeile muss vorher nur das jeweilige
Konfigurationsverzeichnis bekannt gemacht werden.
:::

::: paragraph
Um das Plugin manuell anführen zu können, öffnen Sie zuerst eine
Kommandozeile mit Admin-Rechten. Setzen Sie in dieser Kommandozeile nun
die Umgebungsvariable `MK_CONFDIR`. Diese wird benötigt, damit das
Plugin die Konfigurationsdateien finden kann.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> set MK_CONFDIR=c:\ProgramData\checkmk\agent\config
```
:::
::::

::: paragraph
**Hinweis:** Auch hier ist die gesetzte Umgebungsvariable nicht
permanent, sondern besteht nur, solange diese Kommandozeile offen ist.
:::

::: paragraph
Bei der eigentlichen Ausführung des Plugins empfiehlt es sich, die
Ausgabe auf die Kommandozeile umzulenken. Zu diesem Zweck liefert
Windows das Bordwerkzeug `cscript` mit.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> cscript c:\ProgramData\checkmk\agent\plugins\mssql.vbs
```
:::
::::

::::::::::: sect2
### []{#_mögliche_fehler_und_fehlermeldungen .hidden-anchor .sr-only}6.1. Mögliche Fehler und Fehlermeldungen {#heading__mögliche_fehler_und_fehlermeldungen}

::::: sect3
#### []{#_failed_to_connect_to_database .hidden-anchor .sr-only}Failed to connect to database {#heading__failed_to_connect_to_database}

::: paragraph
Es gibt drei verschiedene Treiber mit deren Hilfe Checkmk alternativ
versucht sich mit der MSSQL-Datenbank zu verbinden: `msoledbsql`,
`sqloledb` und `sqlncli11`.
:::

::: paragraph
Standardmäßig sind alle drei in der Regel vorhanden und werden beim
Verbindungsaufbau nacheinander getestet. In einzelnen Fällen kann es
vorkommen, dass diese sukzessive Abarbeitung zu Fehlermeldungen führt.
Gegebenenfalls müssen Sie dann ein oder sogar zwei der genannten Treiber
aus der Syntax des Aufrufs entfernen.
:::
:::::

::::::: sect3
#### []{#_mssql_vbs_no_backup_found .hidden-anchor .sr-only}mssql.vbs: \"no backup found\" {#heading__mssql_vbs_no_backup_found}

::: paragraph
Meldet ein Plugin \"no backup found\", so sollten Sie als erstes manuell
prüfen, ob ein Backup vorhanden ist. Ist ein Backup vorhanden und das
Problem besteht dennoch weiter, so liegt dies möglicherweise an den
Namenskonventionen auf der MSSQL-Seite.
:::

::: paragraph
Checkmk interpretiert Host-Namen grundsätzlich in Kleinbuchstaben,
werden diese aber im Rahmen der Backups vom Host beispielsweise in
Großbuchstaben übermittelt, so entstehen Verständigungsprobleme.
:::

::: paragraph
Sie können dann den Wert der `serverproperty('collation')` auf der
MSSQL-Seite prüfen. Ist hier zum Beispiel `SQL_Latin1_General_CP1_CS_AS`
gesetzt, so steht `CS` für „Case Sensitive". Das Plugin kann den
Host-Namen dann nicht anpassen und es kann zu Problemen aufgrund der
Schreibweise kommen. Ein Wechsel auf `SQL_Latin1_General_CP1_CI_AS`,
d.h. auf `CI` für „Case Insensitive" sollte das Problem beheben.
:::

::: paragraph
Alternativ können Sie auch die Schreibweise des ursprünglichen Namens
des MSSQL-Servers ändern. Dies ist nur nicht in jedem Unternehmen und in
jeder Umgebung möglich.
:::
:::::::
:::::::::::
::::::::::::::::::::
:::::::::::::::::::::

:::::: sect1
## []{#files .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading_files}

::::: sectionbody
::: sect2
### []{#_auf_dem_mssql_host .hidden-anchor .sr-only}7.1. Auf dem MSSQL-Host {#heading__auf_dem_mssql_host}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `C:                                  | Plugin-Verzeichnis            |
| \ProgramData\checkmk\agent\plugins\` |                               |
+--------------------------------------+-------------------------------+
| `C                                   | Konfigurationsverzeichnis     |
| :\ProgramData\checkmk\agent\config\` |                               |
+--------------------------------------+-------------------------------+
:::

::: sect2
### []{#_auf_dem_checkmk_server .hidden-anchor .sr-only}7.2. Auf dem Checkmk-Server {#heading__auf_dem_checkmk_server}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `~/                                  | Das Plugin, welches auf dem   |
| share/check_mk/agents/plugins/mssql` | MSSQL-Host die Daten holt.    |
+--------------------------------------+-------------------------------+
:::
:::::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
