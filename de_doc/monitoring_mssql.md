:::: {#header}
# Microsoft SQL Server überwachen

::: details
[draft]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_mssql.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::: sectionbody
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

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Dieser Artikel ist derzeit im     |
|                                   | Entstehen begriffen und wird      |
|                                   | regelmäßig ergänzt.               |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::
:::::::::

::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::: sectionbody
::: paragraph
Checkmk ermöglicht Ihnen ein umfangreiches Monitoring von [Microsoft SQL
Server]{.brand} (im weiteren Verlauf nur noch mit \"MSSQL\" abgekürzt).
Eine vollständige Auflistung aller verfügbaren
[Check-Plugins](glossar.html#check_plugin) finden Sie in unserem
[Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=mssql){target="_blank"}.
:::

::: paragraph
Um die Datenbanken überwachen zu können, benötigen Sie neben dem
Checkmk-Agenten zusätzlich noch das
[Agentenplugin](glossar.html#agent_plugin) `mk-sql`. Dieses
Agentenplugin ist ab Checkmk [2.3.0]{.new} auch in der Lage, Datenbanken
auf entfernten Systemen zu überwachen. Zusätzliche Software wird weder
auf dem Checkmk- noch auf dem Datenbank-Server benötigt.
:::

::: paragraph
Die einzige zwingende Voraussetzung für die Verwendung von `mk-sql` ist,
dass in der SQL-Server-Netzwerkkonfiguration das Protokoll TCP/IP
aktiviert ist. Sollte in Ihrer MSSQL-Server-Umgebung kein TCP/IP
zugelassen beziehungsweise erlaubt sein, müssen Sie bis auf Weiteres auf
das [Legacy-Plugin `mssql.vbs`](monitoring_mssql_legacy.html)
zurückgreifen.
:::
::::::
:::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup_login_windows .hidden-anchor .sr-only}2. Login für die Überwachung einrichten (Windows) {#heading_setup_login_windows}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Agentenplugin benötigt Zugang zu Ihren MSSQL-Instanzen. Im Regelfall
steht --- lange bevor das Monitoring-Team kommt --- fest, wie ein
solcher Zugang aussehen kann oder darf. Im Falle von MSSQL gibt es zwei
Möglichkeiten. Entweder Sie verwenden ausschließlich den [Windows
Authentication mode]{.guihint} oder den Mischbetrieb [SQL Server and
Windows Authentication mode]{.guihint}.
:::

:::::: sect2
### []{#system_user .hidden-anchor .sr-only}2.1. Systembenutzer verwenden {#heading_system_user}

::: paragraph
Der Checkmk-Agent wird auf Windows-Systemen vom Systembenutzer
(`NT AUTHORITY\SYSTEM`) ausgeführt. Wenn Sie diesen Systembenutzer auch
für das Monitoring von MSSQL verwenden können, müssen Sie nur noch
darauf achten, dass dieses Konto (*login*), mindestens Berechtigungen
für die folgenden absicherungsfähigen Elemente ([Securables]{.guihint})
besitzt:
:::

::: ulist
- [View server state]{.guihint}

- [Connect SQL]{.guihint}
:::

::: paragraph
In Abhängigkeit davon, welche Datenbanken Ihrer Instanzen Sie überwachen
möchten und je nachdem über welche Server-Rollen und Mappings der
Systembenutzer (`NT AUTHORITY\SYSTEM`) bereits verfügt, kann es
notwendig sein, auch die Berechtigung für [Connect any database
(Verbindung mit beliebiger Datenbank)]{.guihint} zu erteilen.
:::
::::::

:::::::::::::::::::: sect2
### []{#dedicated_login .hidden-anchor .sr-only}2.2. Dediziertes Konto für das Monitoring verwenden {#heading_dedicated_login}

::: paragraph
Es gibt auch gute Gründe dafür, das Monitoring von MSSQL **nicht** über
den Systembenutzer von Windows laufen zu lassen. Denkbar sind unter
anderem Sicherheitsvorgaben im Unternehmen oder einfach der Wunsch,
dedizierte und klar benannte Logins zu haben, deren Sinn und Zweck schon
am Namen ablesbar ist.
:::

::: paragraph
Selbstverständlich funktioniert das Agentenplugin auch mit solchen
Konten (*Logins*).
:::

::: paragraph
Die Grundvoraussetzung in MSSQL ist, dass die [Server
authentication]{.guihint} auf [SQL Server and Windows Authentication
mode]{.guihint} gestellt ist. Wenn Sie nicht den Windows-eigenen
Systembenutzer verwenden wollen oder können, dürfte diese Voraussetzung
zwar bereits erfüllt sein, sie soll aber auch nicht unerwähnt bleiben.
:::

::: paragraph
Sollte noch kein entsprechender Benutzer auf Ihrem MSSQL-Server bzw. in
Ihrer -Instanz vorhanden sein, so können Sie diesen auf Ihrem
Windows-System über das Microsoft SQL Server Management Studio (mit
einem beliebigen Benutzernamen) erstellen:
:::

:::: imageblock
::: content
![Auswahl der Option \'New Login\...\' in
MSSQL.](../images/monitoring_mssql_new_user.png){width="38%"}
:::
::::

::: paragraph
Dieser Login benötigt die folgenden Berechtigungen:
:::

::: ulist
- [View server state]{.guihint}

- [Connect SQL]{.guihint}

- [Connect any database]{.guihint}
:::

::: paragraph
Erteilen Sie diese Berechtigungen im [Object Explorer]{.guihint} über
[Security \> Logins]{.guihint}. Öffnen Sie hier die Eigenschaften des
Kontos (*login*) und klicken Sie auf [Securables]{.guihint}. Unter
[Explicit]{.guihint} finden Sie die drei oben genannten Einträge. Setzen
Sie in der Spalte [Grant]{.guihint} die entsprechenden Haken und
bestätigen über [OK]{.guihint}.
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
      GRANT CONNECT SQL TO checkmk;
      GRANT CONNECT ANY DATABASE TO checkmk;
      GRANT VIEW ANY DATABASE TO checkmk;
      GO
```
:::
::::
::::::::::::::::::::

:::::::::::::::::::::::::::: sect2
### []{#_manuelle_einrichtung_der_verbindung .hidden-anchor .sr-only}2.3. Manuelle Einrichtung der Verbindung {#heading__manuelle_einrichtung_der_verbindung}

::: paragraph
Wenn Sie
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** nutzen oder die Agentenbäckerei der kommerziellen
Editionen nicht nutzen wollen, richten Sie die Kommunikation manuell
ein.
:::

::: paragraph
Für die weitere Beschreibung gehen wir davon aus, dass der Agent für die
Windows-Überwachung bereits auf dem Host installiert ist.
:::

:::::::::::::::: sect3
#### []{#_konfigurationsdatei_erstellen .hidden-anchor .sr-only}Konfigurationsdatei erstellen {#heading__konfigurationsdatei_erstellen}

::: paragraph
Auf dem Windows-Host legen Sie im unten angegebenen Verzeichnis eine
Datei `mk-sql.yml` an:
:::

::: paragraph
Bei Verwendung des Systembenutzers genügt:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk-sql.yml
:::

::: content
``` {.pygments .highlight}
---
mssql:
  main:
    authentication:
      username: ''
      type: integrated
```
:::
:::::

::: paragraph
Verwenden Sie stattdessen das [dezidierte Konto für das
Monitoring,](#dedicated_login) so brauchen Sie folgenden Inhalt:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk-sql.yml
:::

::: content
``` {.pygments .highlight}
---
mssql:
  main:
    authentication:
      username: checkmk
      password: MyPassword123
      type: sql_server
```
:::
:::::

::: paragraph
Sollten Sie auf dem Host mehrere MSSQL-Instanzen mit verschiedenen
Benutzernamen und Passwörtern betreiben, erweitern Sie die `yml`-Datei
entsprechend um die Angaben zu den Instanzen. Ihre `yml`-Datei könnte
dann beispielsweise so aussehen:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mk-sql.yml
:::

::: content
``` {.pygments .highlight}
---
mssql:
  main:
    authentication:
      username: ""
      type: integrated
    instances:
      - sid: myInstance 1
        auth:
          username: myUser1
          password: "123456"
          type: sql_server
      - sid: myInstance 2
        auth:
          username: myUser2
          password: "987654"
          type: sql_server
```
:::
:::::
::::::::::::::::

::::::: sect3
#### []{#_agentenplugin_installieren .hidden-anchor .sr-only}Agentenplugin installieren {#heading__agentenplugin_installieren}

::: paragraph
Unter [Setup \> Agents \> Windows files]{.guihint} finden Sie im
Abschnitt [Windows Agent]{.guihint} die Datei `mk-sql.exe`.
:::

:::: imageblock
::: content
![Auswahl des Agentenplugins in
Checkmk.](../images/monitoring_mssql_agentfile.png)
:::
::::

::: paragraph
Laden Sie die Datei herunter und legen Sie diese auf dem Windows-Host im
Verzeichnis `C:\ProgramData\checkmk\agent\plugins\` ab. Führen Sie die
Datei danach einmal aus.
:::
:::::::

:::::: sect3
#### []{#_services_einrichten .hidden-anchor .sr-only}Services einrichten {#heading__services_einrichten}

::: paragraph
Nachdem Sie das Agentenplugin nun installiert und konfiguriert haben,
können Sie für diesen Host eine
[Service-Erkennung](glossar.html#service_discovery) durchführen. Der
folgende Screenshot zeigt dabei nur eine Auswahl der auffindbaren
Services:
:::

:::: imageblock
::: content
![Auszug der
Service-Erkennung.](../images/monitoring_mssql_discovery.png)
:::
::::
::::::
::::::::::::::::::::::::::::

:::::::::: sect2
### []{#extended_configuration .hidden-anchor .sr-only}2.4. Erweiterte Konfiguration {#heading_extended_configuration}

::::::::: sect3
#### []{#_asynchrone_ausführung_des_agentenplugins .hidden-anchor .sr-only}Asynchrone Ausführung des Agentenplugins {#heading__asynchrone_ausführung_des_agentenplugins}

::: paragraph
Das Agentenplugin für die Überwachung von MSSQL kann --- wie so viele
andere --- asynchron ausgeführt werden, um beispielsweise längeren
Laufzeiten bei großen MSSQL-Instanzen Rechnung zu tragen.
:::

::: paragraph
Um das Agentenplugin unter Windows asynchron auszuführen, passen Sie die
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
Eine detaillierte Anleitung zur asynchronen Ausführung von
Agentenplugins auf einem Windows-Host finden Sie im Artikel über den
[Windows-Agenten.](agent_windows.html#customizeexecution)
:::
:::::::::
::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup_login_linux .hidden-anchor .sr-only}3. Login für die Überwachung einrichten (Linux) {#heading_setup_login_linux}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#system_user_linux .hidden-anchor .sr-only}3.1. Benutzer für das Monitoring anlegen {#heading_system_user_linux}

::: paragraph
Der Checkmk-Agent wird auf Linux-Systemen von einem Systembenutzer
(`root`) ausgeführt. Auch für das Monitoring von MSSQL können Sie einen
Systembenutzer verwenden. Dieser Benutzer sollte mindestens die
folgenden Berechtigungen besitzen:
:::

::: ulist
- `View server state`

- `Connect SQL`

- `` Connect any database` ``
:::

::: paragraph
Es gibt auch gute Gründe dafür, das Monitoring von MSSQL **nicht** über
einen Systembenutzer von Linux laufen zu lassen. Diese reichen von
Sicherheitsvorgaben im Unternehmen bis zu einfach dem Wunsch, dedizierte
und klar benannte Logins zu haben, deren Sinn und Zweck schon am Namen
ablesbar ist.
:::

::: paragraph
Selbstverständlich funktioniert das Agentenplugin auch mit solchen
Konten (*Logins*).
:::

::: paragraph
Die Grundvoraussetzung in MSSQL ist, dass die [Server
authentication]{.guihint} auf [SQL Server and Windows Authentication
mode]{.guihint} gestellt ist. Wenn Sie keinen Linux-Systembenutzer
verwenden wollen oder können, dürfte diese Voraussetzung zwar bereits
erfüllt sein, sie soll aber auch nicht unerwähnt bleiben.
:::

::: paragraph
Sollte noch kein entsprechender Benutzer auf Ihrem MSSQL-Server bzw. in
Ihrer -Instanz vorhanden sein, so können Sie diesen auf Ihrem
Linux-System über die Befehlszeile erstellen:
:::

::: paragraph
Im folgenden Beispiel wird das für den Benutzer `checkmk` erledigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
sudo adduser --system checkmk --ingroup sudo
```
:::
::::

::: paragraph
Folgen Sie den Aufforderungen zur Passwortvergabe etc.
:::

::: paragraph
Danach:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
sudo
      GRANT CONNECT SQL TO checkmk;
      GRANT CONNECT ANY DATABASE TO checkmk;
      GRANT VIEW ANY DATABASE TO checkmk;
      GO
```
:::
::::
::::::::::::::::

:::::::::::::::::::::::: sect2
### []{#_manuelle_einrichtung_der_verbindung_2 .hidden-anchor .sr-only}3.2. Manuelle Einrichtung der Verbindung {#heading__manuelle_einrichtung_der_verbindung_2}

::: paragraph
Wenn Sie
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** nutzen oder die Agentenbäckerei der kommerziellen
Editionen nicht nutzen wollen, richten Sie die Kommunikation manuell
ein.
:::

::: paragraph
Für die weitere Beschreibung gehen wir davon aus, dass der Agent für die
Linux-Überwachung bereits auf dem Host installiert ist.
:::

::::::::::: sect3
#### []{#_konfigurationsdatei_erstellen_2 .hidden-anchor .sr-only}Konfigurationsdatei erstellen {#heading__konfigurationsdatei_erstellen_2}

::: paragraph
Auf dem Linux-Host legen Sie im unten angegebenen Verzeichnis eine Datei
`mk-sql.yml` an:
:::

::::: listingblock
::: title
/etc/check_mk/mk-sql.yml
:::

::: content
``` {.pygments .highlight}
---
mssql:
  main:
    authentication:
      username: checkmk
      password: checkmkPW
      type: sql_server
```
:::
:::::

::: paragraph
Sollten Sie auf dem Host mehrere MSSQL-Instanzen mit verschiedenen
Benutzernamen und Passwörtern betreiben, erweitern Sie die `yml`-Datei
entsprechend um die Angaben zu den Instanzen. Ihre `yml`-Datei könnte
dann beispielsweise so aussehen:
:::

::::: listingblock
::: title
/etc/check_mk/mk-sql.yml
:::

::: content
``` {.pygments .highlight}
---
mssql:
  main:
    authentication:
      username: checkmk
      password: checkmkPW
      type: sql_server
    instances:
    - sid: myInstance1
      auth:
        username: myUser1
        password: 123456
        type: sql_server
    - sid: myInstance2
      auth:
        username: myUser2
        password: 987654
        type: sql_server
```
:::
:::::
:::::::::::

:::::::: sect3
#### []{#_agentenplugin_installieren_2 .hidden-anchor .sr-only}Agentenplugin installieren {#heading__agentenplugin_installieren_2}

::: paragraph
Unter [Setup \> Agents \> Linux, Solaris, AIX files]{.guihint} finden
Sie im Abschnitt [/linux]{.guihint} die Datei `mk-sql.txt`.
:::

:::: imageblock
::: content
![Auswahl des Agentenplugins in
Checkmk.](../images/monitoring_mssql_agentfile_linux.png)
:::
::::

::: paragraph
Laden Sie die Datei herunter und legen Sie diese auf dem Linux-Host im
Verzeichnis `~/usr/lib/check_mk_agent/plugins/mk-sql` ab.
:::

::: paragraph
Führen Sie die Datei danach einmal aus.
:::
::::::::

:::::: sect3
#### []{#_services_einrichten_2 .hidden-anchor .sr-only}Services einrichten {#heading__services_einrichten_2}

::: paragraph
Nachdem Sie das Agentenplugin nun installiert und konfiguriert haben,
können Sie für diesen Host eine
[Service-Erkennung](glossar.html#service_discovery) durchführen. Der
folgende Screenshot zeigt dabei nur eine Auswahl der auffindbaren
Services:
:::

:::: imageblock
::: content
![Auszug der
Service-Erkennung.](../images/monitoring_mssql_discovery.png)
:::
::::
::::::
::::::::::::::::::::::::

:::::::::: sect2
### []{#extended_configuration_linux .hidden-anchor .sr-only}3.3. Erweiterte Konfiguration {#heading_extended_configuration_linux}

::::::::: sect3
#### []{#_asynchrone_ausführung_des_agentenplugins_2 .hidden-anchor .sr-only}Asynchrone Ausführung des Agentenplugins {#heading__asynchrone_ausführung_des_agentenplugins_2}

::: paragraph
Das Agentenplugin für die Überwachung von MSSQL kann --- wie so viele
andere --- asynchron ausgeführt werden, um beispielsweise längeren
Laufzeiten bei großen MSSQL-Instanzen Rechnung zu tragen.
:::

::: paragraph
Um das Agentenplugin unter Linux asynchron auszuführen, passen Sie die
Konfiguration des Agenten an und erweitern die Sektion `execution` unter
`plugins` um den folgenden Eintrag:
:::

::::: listingblock
::: title
/etc/check_mk/mk-sql.yml
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
Eine detaillierte Anleitung zur asynchronen Ausführung von
Agentenplugins auf einem Linux-Host finden Sie im Artikel über den
[Linux-Agenten.](agent_linux.html#async_plugins)
:::
:::::::::
::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::: sect1
## []{#_weitere_konfiguration_in_checkmk .hidden-anchor .sr-only}4. Weitere Konfiguration in Checkmk {#heading__weitere_konfiguration_in_checkmk}

:::::::::::: sectionbody
::::::::::: sect2
### []{#_schwellwerte_konfigurieren .hidden-anchor .sr-only}4.1. Schwellwerte konfigurieren {#heading__schwellwerte_konfigurieren}

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
Verbindungen.](../images/monitoring_mssql_connections.png)
:::
::::
::::::

:::::: sect3
#### []{#_dateigrößen_überwachen .hidden-anchor .sr-only}Dateigrößen überwachen {#heading__dateigrößen_überwachen}

::: paragraph
Auch für die Größe einzelner Dateien in MSSQL können Sie Schwellwerte
festlegen. Dazu verwenden Sie den Regelsatz [MSSQL datafile
sizes.]{.guihint}
:::

:::: imageblock
::: content
![Einstellung der genutzten
Dateigrößen.](../images/monitoring_mssql_size_datafile.png)
:::
::::
::::::
:::::::::::
::::::::::::
:::::::::::::

:::::::::::::::::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}5. Konfiguration über die Agentenbäckerei {#heading_bakery}

::::::::::::::::::::::::: sectionbody
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
Für die erste Einrichtung reicht es, wenn Sie eine entsprechende Regel
in der Agentenbäckerei anlegen. Sie finden den Regelsatz unter [Setup \>
Agents \> Windows, Linux, Solaris, AIX \> Agent rules.]{.guihint} In dem
Suchfeld können Sie dann nach `mssql` suchen:
:::

:::: imageblock
::: content
![Die Regel \'Microsoft SQL Server (Linux, Windows)\' in den
Agentenregeln.](../images/monitoring_mssql_bakery_ruleset_search.png)
:::
::::

:::::::::: sect2
### []{#_einrichtung_der_agentenregel_windows .hidden-anchor .sr-only}5.1. Einrichtung der Agentenregel (Windows) {#heading__einrichtung_der_agentenregel_windows}

::: paragraph
Je nachdem, wie sich das Agentenplugin an Ihrem MSSQL-Server anmelden
darf (siehe [Login für die Überwachung einrichten](#setup_login)),
wählen Sie unter [Authentication]{.guihint} nun die entsprechende Option
aus. Nutzen Sie den Systembenutzer (`NT AUTHORITY\SYSTEM`), belassen Sie
die Auswahl bei [Local Integrated Authentication (Windows)]{.guihint}.
:::

:::: imageblock
::: content
![Mögliche Einstellungen für den MSSQL Server in der
Agentenbäckerei.](../images/monitoring_mssql_bakery_new.png)
:::
::::

::: paragraph
Verwenden Sie stattdessen die *SQL Server Authentication,* wählen Sie
hier die Option [SQL Database User Credentials,]{.guihint} geben
zusätzlich den [Login name]{.guihint} im Feld [User]{.guihint} ein und
fügen das zugehörige [Password]{.guihint} hinzu.
:::

::: paragraph
Sollten Sie auf dem Host mehrere MSSQL-Instanzen mit verschiedenen
Benutzernamen und Passwörtern betreiben, wählen Sie die Option [Custom
instances]{.guihint}. Über [Add new element]{.guihint} gelangen Sie zu
den Angaben für die erste --- und danach jede weitere --- Instanz, die
überwacht werden soll. Tragen Sie hier, analog zur obigen Beschreibung,
die Zugriffsdaten je Instanz ein.
:::

:::: imageblock
::: content
![Mehrere MSSQL-Instanzen in der
Bakery-Regel.](../images/monitoring_mssql_bakery_more.png)
:::
::::
::::::::::

:::::::::: sect2
### []{#_einrichtung_der_agentenregel_linux .hidden-anchor .sr-only}5.2. Einrichtung der Agentenregel (Linux) {#heading__einrichtung_der_agentenregel_linux}

::: paragraph
Wählen Sie unter [Authentication]{.guihint} die Option [SQL database
user credentials]{.guihint}.
:::

:::: imageblock
::: content
![Mögliche Einstellungen für den MSSQL Server in der
Agentenbäckerei.](../images/monitoring_mssql_bakery_unix.png)
:::
::::

::: paragraph
Geben Sie dann den [Login name]{.guihint} im Feld [User]{.guihint} ein
und fügen Sie das zugehörige [Password]{.guihint} hinzu. Ergänzen Sie
für die [Connection]{.guihint} den [Host name]{.guihint}.
:::

::: paragraph
Sollten Sie auf dem Host mehrere MSSQL-Instanzen mit verschiedenen
Benutzernamen und Passwörtern betreiben, wählen Sie die Option [Custom
instances]{.guihint}. Über [Add new element]{.guihint} gelangen Sie zu
den Angaben für die erste --- und danach jede weitere --- Instanz, die
überwacht werden soll. Tragen Sie hier, analog zur obigen Beschreibung,
die Zugriffsdaten je Instanz ein.
:::

:::: imageblock
::: content
![Mehrere MSSQL-Instanzen in der
Bakery-Regel.](../images/monitoring_mssql_bakery_more.png)
:::
::::
::::::::::

:::: sect2
### []{#_weitere_optionen .hidden-anchor .sr-only}5.3. Weitere Optionen {#heading__weitere_optionen}

::: paragraph
Mit den soeben vorgenommenen Einstellungen kreieren Sie zunächst einen
einfachen Agenten zur Überwachung Ihrer MSSQL-Instanz, die sich direkt
auf dem Host befindet. Alle verfügbaren Daten werden direkt in Checkmk
ausgewertet und für den Standardfall sollte dies bereits genügen. Haben
Sie eine komplexere MSSQL-Welt in Ihrem Unternehmen, so gibt es jedoch
weitere Optionen, sowohl für die Überwachung der Datenbank auf dem
gleichen Host als auch für die Überwachung auf einem entfernten Host.
Diese sind prinzipiell für beide Verbindungstypen gleich.
:::

+--------------------+-------------------------------------------------+
| Option             | Funktion                                        |
+====================+=================================================+
| [Con               | Brauchen Sie für die allgemeine Verbindung zum  |
| nection]{.guihint} | MSSQL-Server spezifischere Verbindungsdaten, so |
|                    | können Sie diese hier angeben.                  |
+--------------------+-------------------------------------------------+
| [Data to collect   | Hier können Sie abschnittsweise einschränken,   |
| (Se                | welche Daten eingesammelt werden sollen bzw. ob |
| ctions)]{.guihint} | diese synchron oder asynchron gesammelt werden  |
|                    | sollen.                                         |
+--------------------+-------------------------------------------------+
| [Cache age for     | Für die zuvor festgelegten asynchronen Checks   |
| asynchronous       | können Sie den Caching-Zeitraum in Sekunden     |
| checks]{.guihint}  | ändern.                                         |
+--------------------+-------------------------------------------------+
| Map data to        | [Piggyback](glossar.html#piggyback)-Daten       |
| specific host      | können --- unabhängig von der eigentlichen      |
| (Piggyback)        | Quelle --- einem Host zugeordnet werden. So     |
|                    | lassen sich zum Beispiel die SQL-Informationen  |
|                    | von den Daten des zugrundeliegenden             |
|                    | Windows-Servers trennen.                        |
+--------------------+-------------------------------------------------+
| [Discovery mode of | Einstellungen für die Suche in der Instanz.     |
| da                 |                                                 |
| tabases]{.guihint} |                                                 |
+--------------------+-------------------------------------------------+
| [Custom            | Ergänzend zu den allgemeinen Vorgaben zum       |
| in                 | Zugriff auf Ihren MSSQL-Server, können Sie hier |
| stances]{.guihint} | für spezifische Instanzen eigene Einstellungen  |
|                    | setzen.                                         |
+--------------------+-------------------------------------------------+
| [                  | Die maximale Anzahl an parallelen               |
| Options]{.guihint} | SQL-Server-Verbindungen kann hier eingestellt   |
|                    | werden.                                         |
+--------------------+-------------------------------------------------+
::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::: sect1
## []{#diagnostic .hidden-anchor .sr-only}6. Diagnosemöglichkeiten {#heading_diagnostic}

:::::: sectionbody
::::: sect2
### []{#_mögliche_fehler_und_fehlermeldungen .hidden-anchor .sr-only}6.1. Mögliche Fehler und Fehlermeldungen {#heading__mögliche_fehler_und_fehlermeldungen}

:::: sect3
#### []{#_fehlermeldung_failed_to_gather_sql_server_instances .hidden-anchor .sr-only}Fehlermeldung: Failed to gather SQL Server instances {#heading__fehlermeldung_failed_to_gather_sql_server_instances}

::: paragraph
Prüfen Sie, ob die TCP/IP-Verbindung konfiguriert ist und funktioniert.
:::
::::
:::::
::::::
:::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: sect2
### []{#_auf_dem_mssql_host_windows .hidden-anchor .sr-only}7.1. Auf dem MSSQL-Host (Windows) {#heading__auf_dem_mssql_host_windows}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `C:                                  | Verzeichnis zur Ablage der    |
| \ProgramData\checkmk\agent\plugins\` | Agentenplugins.               |
+--------------------------------------+-------------------------------+
| `C:\ProgramD                         | Konfigurationsdatei für das   |
| ata\checkmk\agent\config\mk-sql.yml` | Agentenplugin.                |
+--------------------------------------+-------------------------------+
:::

::: sect2
### []{#_auf_dem_mssql_host_linux .hidden-anchor .sr-only}7.2. Auf dem MSSQL-Host (Linux) {#heading__auf_dem_mssql_host_linux}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `/usr/lib/check_mk_agent/plugins/`   | Verzeichnis zur Ablage der    |
|                                      | Agentenplugins.               |
+--------------------------------------+-------------------------------+
| `/etc/check_mk/mk-sql.yml`           | Konfigurationsdatei für das   |
|                                      | Agentenplugin.                |
+--------------------------------------+-------------------------------+
:::

::: sect2
### []{#_auf_dem_checkmk_server .hidden-anchor .sr-only}7.3. Auf dem Checkmk-Server {#heading__auf_dem_checkmk_server}

+--------------------------------------+-------------------------------+
| Pfad                                 | Verwendung                    |
+======================================+===============================+
| `~/share/                            | Das Agentenplugin, das Sie    |
| check_mk/agents/windowss/mk-sql.exe` | auf Ihre Windows-Hosts        |
|                                      | kopieren müssen, um MSSQL     |
|                                      | dort zu überwachen.           |
+--------------------------------------+-------------------------------+
| `~                                   | Das Agentenplugin, das Sie    |
| /share/check_mk/agents/linux/mk-sql` | auf Ihre Linux-Hosts kopieren |
|                                      | müssen, um MSSQL dort zu      |
|                                      | überwachen.                   |
+--------------------------------------+-------------------------------+
:::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
