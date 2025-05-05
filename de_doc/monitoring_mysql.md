:::: {#header}
# MySQL überwachen

::: details
[Last modified on 30-Dec-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_mysql.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen](agent_linux.html)
[Monitoring-Agenten](wato_monitoringagents.html) [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"}
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::: sectionbody
::: paragraph
Checkmk erlaubt Ihnen die umfangreiche Überwachung von MySQL und Galera
Cluster für MySQL. Eine vollständige Liste der Überwachungsmöglichkeiten
können Sie in unserem [Katalog der
Check-Plugins](https://checkmk.com/de/integrations?tags=mysql){target="_blank"}
nachlesen. Unter anderem kann Checkmk die folgenden Werte überwachen:
:::

::: ulist
- [MySQL:
  Sessions](https://checkmk.com/de/integrations/mysql_sessions){target="_blank"}

- [MySQL: Galera
  Donor](https://checkmk.com/de/integrations/mysql_galeradonor){target="_blank"}

- [MySQL: Galera
  Size](https://checkmk.com/de/integrations/mysql_galerasize){target="_blank"}

- [MySQL: Galera Cluster Addresses
  (Startup)](https://checkmk.com/de/integrations/mysql_galerastartup){target="_blank"}

- [MySQL: Galera
  Status](https://checkmk.com/de/integrations/mysql_galerastatus){target="_blank"}

- [MySQL: Galera Sync
  Status](https://checkmk.com/de/integrations/mysql_galerasync){target="_blank"}

- [MySQL: Maximum Connection Usage since
  Startup](https://checkmk.com/de/integrations/mysql_connections){target="_blank"}

- [MySQL: Slave Sync
  Status](https://checkmk.com/de/integrations/mysql_slave){target="_blank"}

- [MySQL: Status of
  Daemon](https://checkmk.com/de/integrations/mysql_ping){target="_blank"}

- [MySQL: IO Statistics of InnoDB
  Engine](https://checkmk.com/de/integrations/mysql_innodb_io){target="_blank"}

- [MySQL:
  Version](https://checkmk.com/de/integrations/mysql){target="_blank"}

- [MySQL:
  Capacity](https://checkmk.com/de/integrations/mysql_capacity){target="_blank"}
:::

::: paragraph
Um die Datenbanken überwachen zu können, benötigen Sie neben dem
Checkmk-Agenten lediglich das Agenten-Plugin auf dem Datenbankserver.
Zusätzliche Software wird weder auf dem Checkmk- noch auf dem
Datenbankserver benötigt.
:::

::: paragraph
Im Folgenden wird die Einrichtung für Linux- und Windows-Hosts
beschrieben. Weiter unten gehen wir auf die Einrichtung über die [Agent
Bakery](#bakery) ein.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_einrichten_der_überwachung .hidden-anchor .sr-only}2. Einrichten der Überwachung {#heading__einrichten_der_überwachung}

::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#benutzereinrichten .hidden-anchor .sr-only}2.1. Benutzer einrichten {#heading_benutzereinrichten}

:::::::::::: sect3
#### []{#_linux_und_windows .hidden-anchor .sr-only}Linux und Windows {#heading__linux_und_windows}

::: paragraph
Die einzige Voraussetzung für die Einrichtung der Überwachung innerhalb
von MySQL ist, dass ein Datenbanknutzer und dessen Passwort vorhanden
sein müssen. Dieser Benutzer benötigt lediglich lesende Rechte auf die
MySQL-Instanzen. Sollte noch kein solcher Benutzer vorhanden sein, legen
Sie diesen in den zu überwachenden Instanzen an. Melden Sie sich dazu
mit einem Benutzer mit ausreichenden Zugriffsberechtigungen in MySQL an
und erzeugen Sie anschließend einen neuen Datenbanknutzer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mysql> CREATE USER 'checkmk'@'localhost' IDENTIFIED BY 'MyPassword';
```
:::
::::

::: paragraph
Dieser neu angelegte Benutzer benötigt die Berechtigung, die Instanzen
zu lesen. Prüfen Sie daher, ob der Benutzer die notwendigen
Berechtigungen hat, oder fügen Sie sie mit dem folgenden Befehl hinzu.
Im folgenden Beispiel wird das für den Benutzer `checkmk` erledigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mysql> GRANT SELECT, SHOW DATABASES ON *.* TO 'checkmk'@'localhost';
```
:::
::::

::: paragraph
Sollten Sie die MySQL Replikation einsetzen so muss dem Nutzer zur
Überwachung der Replica Server noch mindestens das Recht REPLICATION
CLIENT erteilt werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mysql> GRANT REPLICATION CLIENT ON *.* TO 'checkmk'@'localhost';
```
:::
::::
::::::::::::
:::::::::::::

:::::::::::: sect2
### []{#_plugin_installieren .hidden-anchor .sr-only}2.2. Plugin installieren {#heading__plugin_installieren}

::::::: sect3
#### []{#_linux .hidden-anchor .sr-only}Linux {#heading__linux}

::: paragraph
Das benötigte Plugin `mk_mysql` finden Sie auf ihrem Checkmk-Server im
Verzeichnis `~/share/check_mk/agents/plugins/`. Kopieren Sie dieses nun
in einem ersten Schritt in das Plugins-Verzeichnis des
[Agenten](agent_linux.html#manualplugins) auf dem zu überwachenden Host.
Das Plugins-Verzeichnis lautet im Regelfall
`/usr/lib/check_mk_agent/plugins/`. Sobald das Skript im angegebenen
Verzeichnis liegt, machen Sie dieses noch ausführbar:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod 700 mk_mysql
```
:::
::::

::: paragraph
Selbstverständlich kann auch dieses Plugin auf Wunsch [asynchron
ausgeführt](agent_linux.html#async_plugins) werden.
:::
:::::::

:::::: sect3
#### []{#_windows .hidden-anchor .sr-only}Windows {#heading__windows}

::: paragraph
Der Agent für Windows wird standardmäßig bereits mit einer ganzen Reihe
von Plugins ausgeliefert. Deshalb finden Sie auch das Plugin für die
Überwachung von MySQL nach der Installation des Agenten bereits auf
Ihrem Host. Dieses kopieren Sie für die Verwendung nur noch in das
richtige Verzeichnis.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> copy "c:\Program Files (x86)\checkmk\service\plugins\mk_mysql.vbs" c:\ProgramData\checkmk\agent\plugins\
```
:::
::::
::::::
::::::::::::

::::::::::::::::::: sect2
### []{#_konfigurationsdatei_erstellen .hidden-anchor .sr-only}2.3. Konfigurationsdatei erstellen {#heading__konfigurationsdatei_erstellen}

:::::::::::: sect3
#### []{#_linux_2 .hidden-anchor .sr-only}Linux {#heading__linux_2}

::: paragraph
Erzeugen Sie anschließend eine Datei mit dem Namen `mysql.cfg` im
[Konfigurationsverzeichnis](agent_linux.html#pluginconfig) (regulär:
`/etc/check_mk/`) des Checkmk-Agenten auf dem Ziel-Host.
:::

::: paragraph
Unter Verwendung der darin eingetragenen Nutzerdaten kann der Agent die
gewünschten Informationen aus Ihrer MySQL-Instanz abrufen. Zwar ist die
Angabe eines Datenbanknutzers optional, wir empfehlen diese allerdings,
da der Agent das Plugin in der Regel als Systembenutzer *root* ausführt.
Wird kein Name eines Datenbankbenutzers angegeben, versucht der
MySQL-Client den Zugriff auf die Datenbank mit dem Benutzernamen des
ausführenden Systembenutzers ohne Verwendung eines Passwortes oder dem
in `.mylogin.cnf` hinterlegten Passwort. Weitere Informationen finden
Sie z.B. in der
[MySQL-Dokumentation.](https://dev.mysql.com/doc/refman/9.1/en/option-files.html){target="_blank"}
:::

::: paragraph
Diese Angabe wird im üblichen Format für MySQL Konfigurationsdateien
vorgenommen:
:::

::::: listingblock
::: title
/etc/check_mk/mysql.cfg
:::

::: content
``` {.pygments .highlight}
[client]
user=checkmk
password=MyPassword
```
:::
:::::

::: paragraph
Die so gespeicherten Zugangsdaten werden durch das folgende Kommando
noch vor unbefugtem Zugriff geschützt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod 400 mysql.cfg
```
:::
::::
::::::::::::

:::::::: sect3
#### []{#_windows_2 .hidden-anchor .sr-only}Windows {#heading__windows_2}

::: paragraph
Auf einem Windows-Host legen Sie im unten angegebenen Verzeichnis eine
Datei names `mysql.ini` an.
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mysql.ini
:::

::: content
``` {.pygments .highlight}
[client]
user=checkmk
password=MyPassword
```
:::
:::::

::: paragraph
Sollten Sie auf dem Host mehrere MySQL-Instanzen mit verschiedenen
Nutzernamen und Passwörtern betreiben, erstellen einfach Sie pro Instanz
eine `.ini`-Datei nach dem folgenden Namensschema:
`mysql_INSTANZ-ID.ini`
:::
::::::::
:::::::::::::::::::

:::::: sect2
### []{#_services_einrichten .hidden-anchor .sr-only}2.4. Services einrichten {#heading__services_einrichten}

::: paragraph
Nachdem Sie das Plugin nun installiert und konfiguriert haben, können
Sie für diesen Host eine [Service-Erkennung](hosts_setup.html#services)
durchführen. Der folgende Screenshot zeigt dabei nur eine Auswahl der
auffindbaren Services:
:::

:::: imageblock
::: content
![mysql discovery](../images/mysql_discovery.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_erweiterte_konfiguration .hidden-anchor .sr-only}3. Erweiterte Konfiguration {#heading__erweiterte_konfiguration}

::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#_asynchrone_ausführung_des_plugins .hidden-anchor .sr-only}3.1. Asynchrone Ausführung des Plugins {#heading__asynchrone_ausführung_des_plugins}

::: paragraph
Das Plugin für die Überwachung von MySQL kann - wie so viele andere -
asynchron ausgeführt werden, um beispielsweise längeren Laufzeiten bei
großen MySQL-Instanzen Rechnung zu tragen.
:::

:::: sect3
#### []{#_linux_3 .hidden-anchor .sr-only}Linux {#heading__linux_3}

::: paragraph
Auf einem Linux-Host wird das Plugin dafür nur in ein Unterverzeichnis
des Plugin-Verzeichnisses verschoben. Möchten Sie das Plugin
beispielsweise nur alle 5 Minuten ausführen, so verschieben Sie das
Skript `mk_mysql` einfach in ein Unterverzeichnis mit dem Namen `300`.
Eine detaillierte Anleitung zur asynchronen Ausführung von Plugins
finden Sie im [Artikel über den
Linux-Agenten](agent_linux.html#async_plugins).
:::
::::

:::::::: sect3
#### []{#_windows_3 .hidden-anchor .sr-only}Windows {#heading__windows_3}

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
        - pattern: mk_mysql.vbs
          cache_age: 300
          async: yes
```
:::
:::::

::: paragraph
Eine detaillierte Anleitung zur asynchronen Ausführung von Plugins auf
einem Windows-Host finden Sie im Artikel über den
[Windows-Agenten](agent_windows.html#customizeexecution).
:::
::::::::
::::::::::::

::::::::::::: sect2
### []{#_zusätzliche_optionen_der_konfigurationsdateien .hidden-anchor .sr-only}3.2. Zusätzliche Optionen der Konfigurationsdateien {#heading__zusätzliche_optionen_der_konfigurationsdateien}

::::::: sect3
#### []{#_kommunikation_mit_mysql_über_socket_einrichten .hidden-anchor .sr-only}Kommunikation mit MySQL über Socket einrichten {#heading__kommunikation_mit_mysql_über_socket_einrichten}

::: paragraph
Statt den Agenten über TCP mit MySQL kommunizieren zu lassen, können Sie
Checkmk anweisen den Socket anzusprechen. Dazu definieren Sie in der
Datei `mysql.cfg` lediglich die Variable `socket`. Hier an dem Beispiel
der Windows-Konfigurationsdatei:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mysql.ini
:::

::: content
``` {.pygments .highlight}
[client]
user=checkmk
password=MyPassword
*socket=/var/run/mysqld/mysqld.sock*
```
:::
:::::
:::::::

::::::: sect3
#### []{#_host_manuell_definieren .hidden-anchor .sr-only}Host manuell definieren {#heading__host_manuell_definieren}

::: paragraph
Des Weiteren ist es über die Konfigurationsdateien auch möglich den
MySQL-Host manuell zu setzen. Die entsprechende Variable dazu heißt
schlicht `host`. Auch hier wieder an dem Beispiel von Windows:
:::

::::: listingblock
::: title
C:\\ProgramData\\checkmk\\agent\\config\\mysql.ini
:::

::: content
``` {.pygments .highlight}
[client]
user=checkmk
password=MyPassword
*host=127.0.0.1*
```
:::
:::::
:::::::
:::::::::::::

::::::::::::::: sect2
### []{#_schwellwerte_konfigurieren .hidden-anchor .sr-only}3.3. Schwellwerte konfigurieren {#heading__schwellwerte_konfigurieren}

:::::: sect3
#### []{#_sitzungen_überwachen .hidden-anchor .sr-only}Sitzungen überwachen {#heading__sitzungen_überwachen}

::: paragraph
Einige der so eingerichteten Checks haben keine voreingestellten
Schwellwerte. Meistens ist das der Fall, weil es keine sinnvollen
Standardwerte gibt, die in den meisten Anwendungsfällen ausreichend
wären. Diese können aber mit wenigen Handgriffen eingerichtet werden.
Über die bekannten [Host & Service Parameters]{.guihint} finden Sie
beispielsweise die Regel [MySQL Sessions & Connections]{.guihint}.
Hiermit lassen sich die für ihre MySQL-Instanz sinnvollen Schwellwerte
für den Service [MySQL sessions]{.guihint} festlegen.
:::

:::: imageblock
::: content
![mysql sessions connections](../images/mysql_sessions_connections.png)
:::
::::
::::::

:::::: sect3
#### []{#_verbindungen_überwachen .hidden-anchor .sr-only}Verbindungen überwachen {#heading__verbindungen_überwachen}

::: paragraph
Auch für die Auslastung der durch MySQL vorgegebenen maximalen Anzahl an
gleichzeitigen Verbindungen haben wir keine Schwellwerte vorgegeben, da
diese viel stärker als bei anderen Services vom Aufbau Ihrer
MySQL-Instanz abhängig sind. Die Einrichtung entsprechender Schwellwerte
lässt sich mit einer Regel aus dem Satz [MySQL Connections]{.guihint} im
Handumdrehen bewerkstelligen. Gleiches gilt dann auch für die Anzahl der
offenen Verbindungen.
:::

:::: imageblock
::: content
![mysql connections](../images/mysql_connections.png)
:::
::::
::::::

:::::: sect3
#### []{#_datenbankgröße_überwachen .hidden-anchor .sr-only}Datenbankgröße überwachen {#heading__datenbankgröße_überwachen}

::: paragraph
Die Größe einzelner Datenbanken in MySQL wird durch das Check-Plugin
[MySQL:
Capacity](https://checkmk.com/de/integrations/mysql_capacity){target="_blank"}
überwacht. Schwellwerte hierfür lassen sich mit der Regel [Size of MySQL
databases]{.guihint} festlegen.
:::

:::: imageblock
::: content
![mysql size database](../images/mysql_size_database.png)
:::
::::
::::::
:::::::::::::::

:::::::: sect2
### []{#_log_dateien_überwachen .hidden-anchor .sr-only}3.4. Log-Dateien überwachen {#heading__log_dateien_überwachen}

::: paragraph
Unter Zuhilfenahme des Check-Plugins
[Logwatch](https://checkmk.com/de/integrations/logwatch){target="_blank"}
können Sie auch die von MySQL erzeugten Log-Dateien auf Fehler
überwachen. Nach der Einrichtung des Plugins prüfen Sie zuerst, wo in
Ihrer MySQL-Instanz die entsprechenden Log-Dateien liegen. Den genauen
Speicherort finden Sie in der `.ini` bzw. `.cnf`-Datei Ihrer Instanz.
:::

::: paragraph
In der Konfigurationsdatei von Logwatch können Sie die für Sie
interessanten Logs eintragen und auf einem Linux-Host etwa die folgenden
Einträge vornehmen:
:::

::::: listingblock
::: title
/etc/check_mk/logwatch.cfg
:::

::: content
``` {.pygments .highlight}
/var/log/mysql/error.log
 W Can't create/write to file
 C [ERROR] Can't start server
 C mysqld_safe mysqld from pid file /var/run/mysql/mysqld.pid ended
```
:::
:::::
::::::::
:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#bakery .hidden-anchor .sr-only}4. Konfiguration über die Agentenbäckerei {#heading_bakery}

::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Einrichtung
wird mittels der [Agent Bakery](wato_monitoringagents.html#bakery) sehr
vereinfacht, da Syntaxfehler in den Konfigurationsdateien vermieden
werden und Anpassungen an sich verändernde Umgebungen einfach
bewerkstelligt werden können. Der wesentliche Unterschied zu einer
manuellen Installation ist, dass Sie nur noch dann auf dem MySQL-Host
auf der Kommandozeile arbeiten müssen, wenn Sie spezielle
MySQL-spezifische Konfigurationen vornehmen möchten.
:::

::: paragraph
Für die erste Einrichtung reicht es, wenn Sie den [Datenbankbenutzer auf
dem MySQL-Host einrichten](#benutzereinrichten) und eine entsprechende
Regel in der Bakery anlegen. Sie finden den Regelsatz unter [Setup \>
Agents \> Windows, Linux, Solaris, AIX \> Agent rules]{.guihint}. In dem
Suchfeld können Sie dann nach `mysql` suchen:
:::

:::: {.imageblock .border}
::: content
![mysql bakery ruleset
search](../images/mysql_bakery_ruleset_search.png)
:::
::::

::: paragraph
Tragen Sie User ID und Password den neuen Datenbanknutzer entsprechend
ein. Über das folgende Feld können Sie für Linux-Hosts den
Checkmk-Agenten so einstellen, dass er die Verbindung zu MySQL nicht
über TCP sondern eben über den Socket aufbaut. Dies kann je nach Größe
und Auslastung zu einer besseren Performance beitragen.
:::

::: paragraph
Eine asynchrone Ausführung des MySQL-Plugins ist ebenfalls über diesen
Regelsatz einstellbar. Dies kann sinnvoll sein, um längeren Laufzeiten
bei großen MySQL-Instanzen Rechnung zu tragen oder wenn die Statusdaten
schlicht nicht im Minutentakt benötigt werden.
:::

:::: imageblock
::: content
![mysql bakery](../images/mysql_bakery.png)
:::
::::
:::::::::::
::::::::::::

::::::::::::::::::::::::::::::::::::: sect1
## []{#_diagnosemöglichkeiten .hidden-anchor .sr-only}5. Diagnosemöglichkeiten {#heading__diagnosemöglichkeiten}

:::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Sollte es beispielsweise bei der Einrichtung der Überwachung zu
unerwartetem Verhalten oder Problemen kommen, so empfiehlt sich eine
Prüfung direkt auf einem betroffenen Host. Da es sich bei den Plugins
für die Überwachung von MySQL sowohl für Linux als auch für Windows um
Shell- bzw. Visual Basic-Skripte handelt, können diese leicht auch ohne
den Agenten ausgeführt werden. Unabhängig vom verwendeten Betriebssystem
muss der Shell bzw. der Kommandozeile vorher nur das jeweilige
Konfigurationsverzeichnis bekannt gemacht werden.
:::

:::::::::::::: sect2
### []{#_diagnosemöglichkeiten_unter_linux .hidden-anchor .sr-only}5.1. Diagnosemöglichkeiten unter Linux {#heading__diagnosemöglichkeiten_unter_linux}

::: paragraph
Prüfen Sie zuerst die für ihren jeweiligen Host gültigen Verzeichnisse.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$  grep 'export MK' /usr/bin/check_mk_agent
export MK_LIBDIR='/usr/lib/check_mk_agent'
export MK_CONFDIR='/etc/check_mk'
```
:::
::::

::: paragraph
Erzeugen Sie nun mit dem Befehl export die Umgebungsvariablen
`MK_CONFDIR` und `MK_LIBDIR`. Passen Sie die Befehle entsprechend Ihrer
tatsächlichen Verzeichnisse an.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# export MK_CONFDIR="/etc/check_mk/"
root@linux# export MK_LIBDIR="/usr/lib/check_mk_agent"
```
:::
::::

::: paragraph
**Wichtig:** Diese Umgebungsvariablen existieren nur in der aktuell
geöffneten Shell und verschwinden sobald Sie diese schließen.
:::

::: paragraph
Anschließend können Sie das Skript `mk_mysql` direkt im
Plugin-Verzeichnis des Checkmk-Agenten ausführen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# $MK_LIBDIR/plugins/mk_mysql
```
:::
::::

::: paragraph
Wenn alle Rechte für den Datenbanknutzer korrekt erteilt sind, sollten
Sie jetzt selbst in einer kleinen und frischen MySQL-Umgebung mehrere
Hundert Zeilen Ausgabe sehen.
:::
::::::::::::::

:::::::::: sect2
### []{#_diagnosemöglichkeiten_unter_windows .hidden-anchor .sr-only}5.2. Diagnosemöglichkeiten unter Windows {#heading__diagnosemöglichkeiten_unter_windows}

::: paragraph
Um das Check-Plugin auf einem Windows-Host manuell anführen zu können,
öffnen Sie zuerst eine Kommandozeile mit Admin-Rechten. Setzen Sie in
dieser Kommandozeile nun die Umgebungsvariable `MK_CONFDIR`. Diese wird
benötigt, damit das Plugin Ihre Konfigurationsdateien finden kann.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> set MK_CONFDIR=c:\ProgramData\checkmk\agent\config
```
:::
::::

::: paragraph
**Wichtig:** Auch hier ist die gesetzte Umgebungsvariable nicht
permanent, sondern besteht nur, solange diese Kommandozeile offen ist.
:::

::: paragraph
Bei der eigentlichen Ausführung des Plugins empfiehlt es sich die
Ausgabe auf die Kommandozeile umzulenken. Zu diesen Zwecks liefert
Windows das Bordwerkzeug `cscript` mit.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
PS> cscript c:\ProgramData\checkmk\agent\plugins\mk_mysql.vbs
```
:::
::::
::::::::::

:::::::::::::: sect2
### []{#_mögliche_fehler_und_fehlermeldungen .hidden-anchor .sr-only}5.3. Mögliche Fehler und Fehlermeldungen {#heading__mögliche_fehler_und_fehlermeldungen}

::::::: sect3
#### []{#_mysqladmin_connect_to_server_at_xyz_failed .hidden-anchor .sr-only}mysqladmin: connect to server at *xyz* failed {#heading__mysqladmin_connect_to_server_at_xyz_failed}

::: paragraph
Die Fehlermeldung `connect to server at xyz failed` deutet darauf hin,
dass der in der Konfigurationsdatei angegebene Nutzer keinen Zugriff auf
MySQL hat. Prüfen Sie zuerst, dass sich keine Übertragungsfehler beim
Anlegen der Konfigurationsdatei (`mysql.cfg` bzw. `mysql.ini`)
eingeschlichen haben.
:::

::: paragraph
Sollte der in der Konfigurationsdatei angegebene Nutzername oder das
Passwort falsch sein, erhalten Sie in etwa die folgende Fehlermeldung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Access denied for user checkmk
```
:::
::::
:::::::

:::::::: sect3
#### []{#_größe_der_datenbank_wird_nicht_ausgegeben .hidden-anchor .sr-only}Größe der Datenbank wird nicht ausgegeben {#heading__größe_der_datenbank_wird_nicht_ausgegeben}

::: paragraph
Sollten Sie in Checkmk zwar eine ganze Reihe von Daten Ihrer
MySQL-Instanz sehen, es jedoch keinen Service geben, welcher die Größe
der enthaltenen Datenbanken überwacht, so ist dies ein Indiz dafür, dass
der Datenbanknutzer nicht über das Recht SELECT verfügt.
:::

::: paragraph
Prüfen Sie Ihren Datenbanknutzer aus MySQL heraus mit dem folgenden
Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
mysql> *show grants for 'checkmk'@'localhost';*
+--------------------------------------------------------------------------+
| Grants for checkmk@localhost                                             |
+--------------------------------------------------------------------------+
| GRANT SELECT, SHOW DATABASES ON *.* TO `checkmk`@`localhost`             |
+--------------------------------------------------------------------------+
```
:::
::::

::: paragraph
Sollte hier in Ihrer Ausgabe das Schlüsselwort SELECT fehlen, so
erteilen Sie dem Datenbanknutzer die entsprechenden Rechte, wie im
Abschnitt [Benutzer einrichten](#benutzereinrichten) angegeben.
:::
::::::::
::::::::::::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::::::: sectionbody
::::: sect2
### []{#_auf_dem_mysql_host .hidden-anchor .sr-only}6.1. Auf dem MySQL-Host {#heading__auf_dem_mysql_host}

::: sect3
#### []{#_linux_4 .hidden-anchor .sr-only}Linux {#heading__linux_4}

+---------------------------+------------------------------------------+
| Pfad                      | Verwendung                               |
+===========================+==========================================+
| `/usr/bin/check_mk_agent` | Der Agent, welcher alle Daten zu dem     |
|                           | Host sammelt.                            |
+---------------------------+------------------------------------------+
| `/u                       | Das übliche Verzeichnis, in dem Plugins  |
| sr/lib/check_mk/plugins/` | abgelegt werden.                         |
+---------------------------+------------------------------------------+
| `/etc/check_mk/mysql.cfg` | Die Konfigurationsdatei für das          |
|                           | MySQL-Plugin.                            |
+---------------------------+------------------------------------------+
| `/etc/                    | Weitere Konfigurationsdatei um           |
| check_mk/mysql.local.cfg` | Host-spezifische Sockets anzugeben       |
+---------------------------+------------------------------------------+
:::

::: sect3
#### []{#_windows_4 .hidden-anchor .sr-only}Windows {#heading__windows_4}

+---------------------------+------------------------------------------+
| Pfad                      | Verwendung                               |
+===========================+==========================================+
| `C:\ProgramDat            | übliches Plugins-Verzeichnis             |
| a\checkmk\agent\plugins\` |                                          |
+---------------------------+------------------------------------------+
| `C:\ProgramDa             | Übliches Konfigurationsverzeichnis       |
| ta\checkmk\agent\config\` |                                          |
+---------------------------+------------------------------------------+
| `C:\Program Files (x8     | übliches Konfigurationsverzeichnis vor   |
| 6)\checkmk\agent\config\` | Checkmk-Version [1.6.0]{.new}            |
+---------------------------+------------------------------------------+
| `C:\Program Files         | übliches Plugins-Verzeichnis vor         |
|  (x86)\check_mk\plugins\` | Checkmk-Version [1.6.0]{.new}            |
+---------------------------+------------------------------------------+
:::
:::::

::: sect2
### []{#_auf_dem_checkmk_server .hidden-anchor .sr-only}6.2. Auf dem Checkmk-Server {#heading__auf_dem_checkmk_server}

+---------------------------+------------------------------------------+
| Pfad                      | Verwendung                               |
+===========================+==========================================+
| `~/share/check_mk         | Das Plugin, welches auf dem MySQL-Host   |
| /agents/plugins/mk_mysql` | die Daten holt.                          |
+---------------------------+------------------------------------------+
:::
:::::::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
