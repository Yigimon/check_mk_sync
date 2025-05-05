:::: {#header}
# FreeBSD überwachen

::: details
[Last modified on 11-Jan-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/agent_freebsd.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html)
[Datenquellenprogramme](datasource_programs.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::: sectionbody
::: paragraph
Es gibt viele gute Gründe, statt Linux oder anderen Unix-artigen
Systemen [FreeBSD](https://www.freebsd.org/){target="_blank"} zu
verwenden: Sei es das seit 2000 vorhandene Container-Feature „Jails",
die hohe Performance auch bei großer I/O-Last, die Robustheit des
Dateisystems UFS2 oder die hervorragende Unterstützung des modernen
transaktionalen Dateisystems ZFS. Checkmk stellt einen Agenten für
FreeBSD bereit, der auf dem Agenten für Linux basiert, aber für
FreeBSD-Feinheiten angepasst wurde, wie z.B. unterschiedliche
Ausgabeformate der Kommandozeilen-Tools und abweichende
Pfad-Konventionen. Die Installation und die Funktionsprüfung muss
allerdings weitgehend manuell erfolgen, denn eine Paketierung oder
Bereitstellung per Agentenbäckerei ist nicht vorgesehen.
:::

::: paragraph
**Hinweis zu anderen BSD-Systemen:** Dieser Artikel erklärt Installation
und Einrichtung des Agenten für *FreeBSD*, [Agenten für *OpenBSD* und
*NetBSD*](https://github.com/Checkmk/checkmk/tree/master/agents){target="_blank"}
stehen ebenso zur Verfügung. Die Installation ähnelt der hier
beschriebenen. Sollten Sie DragonFly BSD nutzen, freuen wir uns über
Tests und gegebenenfalls Patches für den FreeBSD-Agenten.
:::

::: paragraph
Zum grundsätzlichen Aufbau des FreeBSD-Agenten gilt das zum
[Linux-Agenten](agent_linux_legacy.html) beschriebene: Es handelt sich
um ein reines Shell-Skript, welches über einen Internet-Superserver
(`inetd` oder `xinetd`) oder einen SSH-Tunnel aufgerufen wird, was es
leicht und sicher macht.
:::

::: paragraph
Generell setzen wir in diesem Artikel voraus, dass Sie bereits eine
gewisse Erfahrung mit Linux oder Solaris haben und arbeiten in diesem
Artikel vor allem die Unterschiede heraus.
:::
:::::::
::::::::

::::::::::::::::::::::::: sect1
## []{#_installation .hidden-anchor .sr-only}2. Installation {#heading__installation}

:::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_voraussetzungen .hidden-anchor .sr-only}2.1. Voraussetzungen {#heading__voraussetzungen}

::: paragraph
Damit der Checkmk-Agent alle fürs Monitoring sinnvollen Informationen
auslesen kann, ist die Installation zusätzlicher Tools erforderlich:
:::

::: ulist
- `sysutils/ipmitool`

- `devel/libstatgrab`

- `shells/bash`

- `lang/python3`

- `ftp/wget`
:::

::: paragraph
Python ist an dieser Stelle optional, wird aber spätestens für viele
Agentenplugins benötigt. Eine Besonderheit ist `bash`, denn tatsächlich
verwendet das Agentenskript eine Syntax, die nicht mit der FreeBSD
Bourne Shell kompatibel ist. Das `ipmitool` wird zum Auslesen von
Hardwareinformationen benötigt.
:::

::: paragraph
All diese Tools installieren Sie mit dem folgenden Kommando:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # pkg install ipmitool libstatgrab bash python3 wget
```
:::
::::
:::::::::

:::::: sect2
### []{#_installation_aus_den_freebsd_ports .hidden-anchor .sr-only}2.2. Installation aus den FreeBSD Ports {#heading__installation_aus_den_freebsd_ports}

::: paragraph
Die [FreeBSD Ports](https://ports.freebsd.org/){target="_blank"}
enthalten einen von Mark Peek gepflegten [Port des
Checkmk-Agenten](https://cgit.freebsd.org/ports/tree/net-mgmt/check_mk_agent){target="_blank"},
der ggf. Patches enthält, um den Agenten mit neueren FreeBSD-STABLE
Versionen kompatibel zu machen. Wenn die Version (z.B. [2.0.0]{.new})
dieses in den FreeBSD Ports verfügbaren Checkmk-Agenten Ihrer aktuell
verwendeten Checkmk-Version entspricht oder etwas höher liegt, können
Sie diesen Agenten installieren.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # cd /usr/ports/net-mgmt/check_mk_agent
root@bsd:/usr/ports/net-mgmt/check_mk_agent # make install
```
:::
::::
::::::

::::::: sect2
### []{#_manuelle_installation .hidden-anchor .sr-only}2.3. Manuelle Installation {#heading__manuelle_installation}

::: paragraph
Ist die in den FreeBSD Ports verfügbare Version älter als die Ihres
Checkmk-Servers, installieren Sie den aktuellen Agenten aus dem
GitHub-Repository. Da Anpassungen an neue FreeBSD-Versionen nicht immer
auf Agenten für ältere Checkmk-Versionen zurückportiert werden, ist es
in der Regel sinnvoll, aus dem aktuellsten Entwicklungszweig zu
installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # wget -O /usr/local/bin/check_mk_agent https://checkmk.io/3EjKJlt
root@bsd:/root # chmod 0700 /usr/local/bin/check_mk_agent
```
:::
::::

::: paragraph
Falls Sie die Agenten für andere BSD-Systeme suchen oder den
Entwicklungszweig auf eine bestimmte Checkmk-Version festlegen wollen,
suchen Sie den [Agentenordner in
Github](https://github.com/Checkmk/checkmk/tree/master/agents){target="_blank"}
auf.
:::
:::::::

::::::: sect2
### []{#_test_auf_der_kommandozeile .hidden-anchor .sr-only}2.4. Test auf der Kommandozeile {#heading__test_auf_der_kommandozeile}

::: paragraph
Rufen Sie nun den Agenten auf der Kommandozeile auf und überfliegen Sie
die Ausgabe im Pager:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # check_mk_agent | more
<<<check_mk>>>
Version: 2.1.0i1
AgentOS: freebsd
Hostname: fbsd13
AgentDirectory: /etc/check_mk
DataDirectory:
SpoolDirectory: /var/spool/check_mk_agent
PluginsDirectory: /usr/local/lib/check_mk_agent/plugins
LocalDirectory: /usr/local/lib/check_mk_agent/local
```
:::
::::

::: paragraph
Falls gar nichts ausgegeben wird, überprüfen Sie bitte noch einmal die
Voraussetzungen, insbesondere, dass die Bash unter `/usr/local/bin`
installiert ist.
:::
:::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: sect1
## []{#_zugriff_über_das_netzwerk_einrichten .hidden-anchor .sr-only}3. Zugriff über das Netzwerk einrichten {#heading__zugriff_über_das_netzwerk_einrichten}

::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::::::::::::: sect2
### []{#_freebsd_inetd .hidden-anchor .sr-only}3.1. FreeBSD inetd {#heading__freebsd_inetd}

::: paragraph
Die einfachste Möglichkeit, auf den Agenten zuzugreifen, ist der bei
FreeBSD mitgelieferte `inetd`. Alternativ steht der von Linux bekannte
`xinetd` aus der FreeBSD Ports Sektion `security` zur Verfügung. Dessen
Konfiguration entspricht exakt der im [Artikel zum
Linux-Agenten](agent_linux_legacy.html#manual) beschriebenen. Mit dem
`inetd` wird die Ausgabe des Agenten an TCP-Port 6556 gebunden und --
falls erforderlich -- der Zugriff auf bestimmte Checkmk-Server
eingeschränkt.
:::

::: paragraph
Prüfen Sie zunächst, ob Ihre `/etc/services` bereits einen Eintrag für
Port 6556 enthält:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # grep 6556/ /etc/services
```
:::
::::

::: paragraph
Ist dies nicht der Fall, muss Checkmk als Dienst bekannt gemacht werden.
Fügen Sie dafür folgende Zeile hinzu:
:::

::::: listingblock
::: title
/etc/services
:::

::: content
``` {.pygments .highlight}
checkmk-agent        6556/tcp   #Checkmk monitoring agent
```
:::
:::::

::: paragraph
Jetzt ergänzen Sie die Konfigurationsdatei `/etc/inetd.conf` um folgende
Zeile:
:::

::::: listingblock
::: title
/etc/inetd.conf
:::

::: content
``` {.pygments .highlight}
checkmk-agent stream tcp nowait root /usr/local/bin/check_mk_agent check_mk_agent
```
:::
:::::

::: paragraph
Der `inetd` muss grundsätzlich aktiviert werden. Dazu hängen Sie
folgende Zeile an die Datei `/etc/rc.conf` an:
:::

::::: listingblock
::: title
/etc/rc.conf
:::

::: content
``` {.pygments .highlight}
inetd_enable="YES"
```
:::
:::::

::: paragraph
Ist eine Zugriffsbeschränkung notwendig, editieren Sie die Datei
`/etc/hosts.allow`. Kommentieren Sie zunächst die Zeile aus, die
Zugriffe von überall erlaubt, fügen Sie dann eine Zeile ein, die nur dem
Checkmk-Server -- hier mit der IP-Adresse `10.2.3.4` -- den Zugriff
erlaubt. Der erste Parameter ist der Name des vom `inetd` ausgeführten
Kommandos:
:::

::::: listingblock
::: title
/etc/hosts.allow
:::

::: content
``` {.pygments .highlight}
# The rules here work on a "First match wins" basis.
# ALL : ALL : allow
sshd : ALL : allow
check_mk_agent : 10.2.3.4 : allow
```
:::
:::::

::: paragraph
Sind die Konfigurationsänderungen vorgenommen, starten Sie neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # reboot
```
:::
::::

::: paragraph
Jetzt sollte vom Monitoring-Server aus der Zugriff auf den Agenten
funktionieren.
:::

::: paragraph
Am einfachsten ist der Test mit `netcat` oder `nc`. Führen Sie folgendes
Kommando als Instanzbenutzer auf dem Checkmk-Server aus, um die
Netzwerkverbindung zum Agenten zu testen (im Beispiel zum Host mit der
IP-Adresse `10.2.3.5`). Die Kommandoausgabe zeigt nur die ersten Zeilen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ nc 10.2.3.5 6556
<<<check_mk>>>
Version: 2.1.0i1
AgentOS: freebsd
```
:::
::::
::::::::::::::::::::::::::::::

:::: sect2
### []{#_sicherheit .hidden-anchor .sr-only}3.2. Sicherheit {#heading__sicherheit}

::: paragraph
Da der FreeBSD Agent zum gegenwärtigen Zeitpunkt keine Verschlüsselung
unterstützt, raten wir in Fällen, in denen die Absicherung der
übertragenen Daten notwendig ist, zur Verwendung eines SSH-Tunnels.
Dessen Einrichtung erklären wir im Artikel zum
[Linux-Agenten](agent_linux_legacy.html#ssh).
:::
::::
:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#_aufnahme_ins_monitoring .hidden-anchor .sr-only}4. Aufnahme ins Monitoring {#heading__aufnahme_ins_monitoring}

::::::: sectionbody
::: paragraph
Die [Aufnahme ins Monitoring](hosts_setup.html#create_hosts) verläuft
wie bei allen anderen Systemen über die automatische Service-Erkennung.
Bei einem „nackten" FreeBSD, auf dem noch keine Server-Dienste
konfiguriert sind, sollten mindestens 12 Dienste erkannt werden, bei
Installation auf ZFS zehn zusätzliche für Dateisysteminformationen:
:::

::::: imageblock
::: content
![Liste mit 12 automatisch erkannten
Services.](../images/agent_freebsd_discovery.png)
:::

::: title
Die Service-Erkennung in Checkmk findet mindestens 12 Services
:::
:::::
:::::::
::::::::

:::::::::::::::::::::::::::::: sect1
## []{#_plugins .hidden-anchor .sr-only}5. Plugins {#heading__plugins}

::::::::::::::::::::::::::::: sectionbody
::: paragraph
Wegen der komplett manuellen Konfiguration, dem Fehlen einer
automatischen Verteilung und den im Vergleich mit Linux
unterschiedlichen Pfaden, empfiehlt sich ein Test der wichtigsten
Plugin-Mechanismen. Den Anfang macht [MRPE.](agent_linux.html#mrpe)
:::

:::::::::::::: sect2
### []{#_mrpe .hidden-anchor .sr-only}5.1. MRPE {#heading__mrpe}

::: paragraph
Erstellen Sie eine Konfigurationsdatei `/etc/check_mk/mrpe.cfg` mit
folgendem Inhalt:
:::

::::: listingblock
::: title
/etc/check_mk/mrpe.cfg
:::

::: content
``` {.pygments .highlight}
Flux_Comp /bin/echo 'OK - Flux compensator up and running'
```
:::
:::::

::: paragraph
In der Ausgabe des Agenten sollte nun eine MRPE-Sektion enthalten sein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # check_mk_agent | grep -A1 '^...mrpe'
<<<mrpe>>>
(echo) Flux_Comp 0 OK - Flux compensator up and running
```
:::
::::

::: paragraph
In der Service-Erkennung taucht nun [Flux_Comp]{.guihint} als neuer
Service auf:
:::

::::: imageblock
::: content
![Liste mit dem neu erkannten Service
Flux_Comp.](../images/agent_freebsd_mrpe.png)
:::

::: title
Das MRPE-Plugin wurde erfolgreich konfiguriert
:::
:::::
::::::::::::::

::::::::::::::: sect2
### []{#_agentenplugins .hidden-anchor .sr-only}5.2. Agentenplugins {#heading__agentenplugins}

::: paragraph
Die Installation von Agentenplugins entspricht der im [Artikel zum
Linux-Agenten](agent_linux.html#manualplugins) beschriebenen. Achten Sie
bei der Installation von Plugins auf den korrekten Shebang. Perl und
Python sind bei FreeBSD in `/usr/local/bin` installiert und so manches
Shell-Skript, das unter Linux mit `/bin/sh` funktioniert, setzt
eigentlich die unter FreeBSD in `/usr/local/bin/bash` installierte
Bourne Again Shell voraus.
:::

::: paragraph
Zum Testen eignet sich ein simpler [lokaler Check](localchecks.html),
bei dem die Auswertung, ob der überwachte Dienst [OK]{.state0},
[WARN]{.state1} oder [CRIT]{.state2} ist, direkt auf dem überwachten
Host stattfindet. Wenn wir schon dabei sind, einen Zweizeiler zu
schreiben, nutzen wir diesen gleich für einen Test des
Python-Interpreters. Beachten Sie auch hier die zu Linux
unterschiedlichen Standardpfade:
:::

::::: listingblock
::: title
/usr/local/lib/check_mk_agent/local/hello.py
:::

::: content
``` {.pygments .highlight}
#!/usr/local/bin/python3
print("0 \"Hello Beastie\" - Just check paths and Python interpreter!")
```
:::
:::::

::: paragraph
Vergessen Sie nicht, das Skript ausführbar zu machen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@bsd:/root # chmod 0755 /usr/local/lib/check_mk_agent/local/hello.py
```
:::
::::

::: paragraph
Auch in diesem Fall wird der Dienst sofort gefunden:
:::

::::: imageblock
::: content
![Liste mit dem neu erkannten Service Hello
Beastie.](../images/agent_freebsd_local.png)
:::

::: title
Der neue Service \"Hello Beastie\" wurde gefunden
:::
:::::
:::::::::::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

:::::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::::: sectionbody
:::: sect2
### []{#_pfade_auf_dem_überwachten_host .hidden-anchor .sr-only}6.1. Pfade auf dem überwachten Host {#heading__pfade_auf_dem_überwachten_host}

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `/                            | Installationsort des Checkmk-Agenten |
| usr/local/bin/check_mk_agent` | auf dem Ziel-Host.                   |
+-------------------------------+--------------------------------------+
| `/                            | Basisverzeichnis für Erweiterungen   |
| usr/local/lib/check_mk_agent` | des Agenten.                         |
+-------------------------------+--------------------------------------+
| `/usr/loca                    | Plugins, welche den Agenten um       |
| l/lib/check_mk_agent/plugins` | zusätzliche Überwachungsdaten        |
|                               | erweitern. Plugins können in jeder   |
|                               | verfügbaren Programmiersprache       |
|                               | geschrieben werden.                  |
+-------------------------------+--------------------------------------+
| `/usr/lo                      | Ablageort für eigene [lokale         |
| cal/lib/check_mk_agent/local` | Checks.](localchecks.html)           |
+-------------------------------+--------------------------------------+
| `/var/spool/check_mk_agent`   | Enthält Daten, die z.B. von Cronjobs |
|                               | erstellt werden und eine eigene      |
|                               | Sektion beinhalten. Diese werden     |
|                               | ebenfalls der Agentenausgabe         |
|                               | angehängt.                           |
+-------------------------------+--------------------------------------+
| `/etc/check_mk`               | Ablage von Konfigurationsdateien für |
|                               | den Agenten.                         |
+-------------------------------+--------------------------------------+
| `/etc/check_mk/mrpe.cfg`      | Konfigurationsdatei für              |
|                               | [                                    |
|                               | MRPE](agent_linux.html#mrpe) --- für |
|                               | die Ausführung von klassischen       |
|                               | Nagios-kompatiblen Check-Plugins.    |
+-------------------------------+--------------------------------------+

::: paragraph
**Achtung:** Für FreeBSD sind keine Standardpfade hinterlegt, wie für
Linux unterhalb von `/var/lib/check_mk_agent`. Wählen Sie einen
passenden Ablageort und tragen Sie diesen im Agentenskript ein.
:::
::::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
