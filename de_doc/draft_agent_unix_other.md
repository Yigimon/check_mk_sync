:::: {#header}
# Andere Linux-/Unix-artige Systeme überwachen

::: details
[draft]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/draft_agent_unix_other.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen](agent_linux.html) [Linux überwachen im
Legacy-Modus](agent_linux_legacy.html) [FreeBSD
überwachen](agent_freebsd.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
Da der Checkmk im wesentlichen aus einem simplen Shellscript besteht,
das für viele Linux- und Unix-Systeme verfügbar ist, stehen die Chancen
gut, dass Sie auch nicht offiziell unterstützte Systeme mit vertretbarem
Aufwand überwachen können. Dies ermöglicht die Überwachung exotischer
Systeme, von im Container-Umfeld beliebten Distributionen, sowie vielen
Linux oder Unix basierten Appliances. Die Vorgehensweise ist dabei immer
die gleiche:
:::

::: {.olist .arabic}
1.  Installation des Agentenskriptes

2.  Test des Agentenskriptes und gegebenenfalls Prüfung, ob Sektionen
    deaktiviert werden müssen

3.  Wahl eines Transportweges

4.  Wenn nötig Einrichtung der Datenquellenprogramme auf dem
    Checkmk-Server
:::

::: paragraph
Bevor Sie in diesem Artikel weiterlesen, prüfen Sie bitte, ob die
Informationen in den Artikeln \"[Linux überwachen im
Legacy-Modus](agent_linux_legacy.html)\" (Linux-Server- und
Desktopsysteme mit `systemd` oder `xinetd`) oder \"[FreeBSD
überwachen](agent_freebsd.html)\" (weitgehend auf andere BSD-Systeme wie
NetBSD, OpenBSD und darauf basierende Firewall- oder NAS-Betriebssysteme
übertragbar) auf Ihre Systemumgebung anwendbar sind.
:::

::: paragraph
Bitte beachten Sie Folgendes:
:::

::: ulist
- Hier vorgestellte Agenten werden nicht so intensiv getestet wie die
  mit Checkmk ausgelieferten Agenten, zudem müssen Sie eine sehr breite
  Palette an Systemen unterstützen, so dass Sie unter Umständen einzelne
  Sektionen deaktivieren oder das Agentenskript anpassen müssen.

- Aus diesem Grund ist auch nur sehr eingeschränkter Support seitens
  Checkmk für so überwachte Systeme möglich.

- Prüfen Sie *vor* der Installation, ob die Installation des
  Checkmk-Agenten Auswirkungen die Garantie des zu überwachenden Gerätes
  hat.

- Auf (Embedded) Systemen mit nur-lesbar eingebundenem Root-Verzeichnis
  kann es erforderlich sein, das Agentenskript an einen Ort wie `/tmp`
  zu kopieren und explizit mit der verwendeten Shell aufzurufen. Auf
  derartigen Systemen müssen Sie das Agentenskript nach jedem Neustart
  erneut installieren.
:::
::::::::
:::::::::

::::::::::::::::::::::: sect1
## []{#installation .hidden-anchor .sr-only}2. Installation {#heading_installation}

:::::::::::::::::::::: sectionbody
:::: sect2
### []{#_auswahl_des_agentenskripts .hidden-anchor .sr-only}2.1. Auswahl des Agentenskripts {#heading__auswahl_des_agentenskripts}

::: paragraph
Sie könnnen die aktuellste Version des Agentenskriptes im Checkmk-Setup
oder direkt in unserem
[GitHub-Repository](https://github.com/Checkmk/checkmk/tree/2.2.0/agents){target="_blank"}
herunterladen. Der Weg über GitHub hat den Vorteil, dass Sie bei
Vorhandensein einer sehr alten Shell auf dem zu überwachenden System
:::
::::

::::::::::::::::::: sect2
### []{#manual .hidden-anchor .sr-only}2.2. Manuelle Installation des Agentenskripts {#heading_manual}

::: paragraph
Die manuelle Installation des Agentenskripts ist zwar selten nötig, aber
auch nicht sehr schwierig. Bei dieser Installationsart wird zunächst nur
das Agentenskript installiert, aber noch keine Konfiguration des
Zugriffs vorgenommen. Sie benötigen aus der Seite der Agentendateien
dazu den Kasten [Agents]{.guihint}. Dort finden Sie die Datei
`check_mk_agent.linux`:
:::

:::: imageblock
::: content
![Liste der Agentenskripte zum
Download](../images/agent_linux_agents_manual.png){width="."}
:::
::::

::: paragraph
Laden Sie diese Datei auf das Zielsystem und kopieren Sie sie in ein
Verzeichnis, das für `root` ausführbar ist. Gut eignet sich
`/usr/local/bin/`, da es sich im Suchpfad befindet und für eigene
Erweiterungen gedacht ist. Alternativ können Sie `/usr/bin` oder ein
Unterverzeichnis von `/opt` verwenden. Wir verwenden `/usr/bin`, damit
alle Tests den anderen Installationsmethoden entsprechen. Die
Installation können Sie auch direkt mit `wget` durchführen, sofern
vorhanden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cd /usr/bin
root@linux# wget http://mycmkserver/mysite/check_mk/agents/check_mk_agent.linux
root@linux# mv check_mk_agent.linux check_mk_agent
root@linux# chmod 755 check_mk_agent
```
:::
::::

::: paragraph
Vergessen Sie nicht die letzten beiden Befehle: Damit entfernen Sie die
Endung `.linux` und machen die Datei ausführbar. Jetzt muss der Agent
als Befehl ausführbar sein und seine typische Ausgabe erzeugen. Das
`| head` schneidet hier alles ab der 11. Zeile weg:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# check_mk_agent | head
<<<check_mk>>>
Version: 2.2.0b1
AgentOS: linux
Hostname: mycmkserver
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
LocalDirectory: /usr/lib/check_mk_agent/local
<<<df>>>
```
:::
::::

::: paragraph
Falls Sie den Agenten konfigurieren oder erweitern möchten, müssen Sie
die dafür notwendigen Verzeichnisse selbst anlegen. Der Ort für die drei
notwendigen Verzeichnisse ist im Agenten hart kodiert in Variablen, die
mit `MK_` beginnen und über das Environment auch den Plugins
bereitgestellt werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# grep 'export MK_' check_mk_agent
export MK_LIBDIR="/usr/lib/check_mk_agent"
export MK_CONFDIR="/etc/check_mk"
export MK_VARDIR="/var/lib/check_mk_agent"
```
:::
::::

::: paragraph
Diese drei Verzeichnisse sollten Sie anlegen (mit den Standardrechten
755 und `root` als Eigentümer):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mkdir /usr/lib/check_mk_agent /etc/check_mk /var/lib/check_mk_agent
```
:::
::::

::: paragraph
Falls Sie die Pfade ändern möchten, so editieren Sie einfach
`/usr/bin/check_mk_agent`.
:::
:::::::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::

:::::::::: sect1
## []{#inventory .hidden-anchor .sr-only}3. Bestandsaufnahme nach Installation {#heading_inventory}

::::::::: sectionbody
::: paragraph
Prüfen Sie nach der Installation, ob bereits ein Dienst eingerichtet
wurde, der auf dem TCP Port 6556 lauscht. Insbesondere bei Installation
über Paketmanager wird ein bereits vorhandener `xinetd` oder `systemd`
(im Superserver-Modus) verwendet, um eine unverschlüsselte
Agentenausgabe auf TCP Port 6556 bereitzustellen.
:::

::: paragraph
Wir verwenden den Befehl `ss`. Sollte er (auf älteren Distributionen)
nicht vorhanden sein, steht ersatzweise eines der Programme `netstat`,
`sockstat` oder `lsof` zur Verfügung.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ss -tulpn | grep 6556
tcp    LISTEN 0    64  *:6556  *:* users:(("xinetd",pid=1573,fd=5))
```
:::
::::

::: paragraph
Erfolgt keine Ausgabe, ist Port 6556 noch nicht geöffnet. Wird eine
Zeile ausgegeben, dann ist Port 6556 geöffnet. Uns interessiert in
diesem Fall der Programmname innerhalb der Klammer, hier `xinetd`.
Merken Sie sich diesen Programmnamen, da sie ihn im weiteren Verlauf
noch benötigen -- unabhängig von der gewählten Zugriffsmethode.
:::

::: paragraph
Wenn nach Installation aus DEB- oder RPM-Paket hier als Programmname
`cmk-agent-ctl` ausgegeben wird, können Sie sich freuen: Ihr Linux (vor
allem die verwendete systemd-Version) ist dann doch aktuell genug für
die Verwendung des Agent Controllers, wie im Artikel [Linux
überwachen](agent_linux.html) beschrieben, und Sie können die
Registrierung des Agenten vornehmen.
:::
:::::::::
::::::::::

:::::::: sect1
## []{#access_method .hidden-anchor .sr-only}4. Auswahl der Zugriffsmethode {#heading_access_method}

::::::: sectionbody
::: paragraph
An dieser Stelle stehen Sie vor der Entscheidung:
:::

::: ulist
- Wollen Sie eine einfach einzurichtende unverschlüsselte Verbindung
  zulassen?

- Oder ist Ihnen die höhere Sicherheit mit Verschlüsselung einen
  gewissen Mehraufwand wert?
:::

::: paragraph
Die hierfür relevanten Aspekte sind, auf welche Informationen ein
potentieller Angreifer Zugriff hat und wie groß sein Aufwand ist. So
kann bereits die immer übertragene Prozesstabelle wertvolle Hinweise
liefern und eine Liste noch nicht durchgeführter Software-Updates
ermöglicht zielgerichtete Angriffe.
:::

::: paragraph
Wir raten daher im Regelfall zu einer verschlüsselten Datenübertragung
über einen [SSH-Tunnel](#ssh).
:::
:::::::
::::::::

::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#unencrypted .hidden-anchor .sr-only}5. Unverschlüsselt: Einrichtung von (x)inetd {#heading_unencrypted}

:::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Sollten Sie zum Schluss kommen, dass eine unverschlüsselte
Datenübertragung ein kalkulierbares Risiko ist, steht die Einrichtung
eines *Internet Superservers* an. Falls der Test mit `ss` ergeben hat,
dass bereits `xinetd`, `inetd` oder `systemd` auf TCP Port 6556 lauscht,
springen Sie weiter zum [Verbindungstest](#connectiontest).
:::

::: paragraph
Ist dies nicht der Fall, prüfen Sie mit dem `ps` Befehl, ob bereits ein
`inetd` aktiv ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ps ax | grep inetd
 1913 ?        Ss     0:00 /usr/sbin/xinetd -pidfile /run/xinetd.pid -stayalive -inetd_compat -inetd_ipv6
```
:::
::::

::: paragraph
Am ausgeführten Prozess erkennen Sie, ob es sich um den moderneren
`xinetd` oder einen der anderen Internet Superserver (GNU-Inetutils,
OpenBSD-Inetd, Busybox-Inetd) handelt. Ist kein Prozess aktiv,
installieren Sie einen `xinetd` über das Paketmanagement Ihrer
Distribution. Sollte ein \"klassischer\" `inetd` aktiv sein, ist es
meist sinnvoll, diesen zu nutzen und [einzurichten](#otherinetd) statt
auf `xinetd` zu wechseln.
:::

:::::::::::::::: sect2
### []{#xinetd .hidden-anchor .sr-only}5.1. xinetd einrichten {#heading_xinetd}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Für die
Konfiguration eines bereits vorhandenen `xinetd`, der das Verzeichnis
`/etc/xinetd.d/` zur Konfiguration verwendet, bringen sowohl das
TGZ-Archiv als auch die DEB- und RPM-Pakete ein Skript bei, welches in
zwei Schritten zuerst die Konfiguration installiert und dann den
`xinetd` die geänderten Einstellungen einlesen lässt. Das Skript müssen
Sie mit vollem Pfad aufrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /var/lib/cmk-agent/scripts/super-server/1_xinetd/setup deploy
root@linux# /var/lib/cmk-agent/scripts/super-server/1_xinetd/setup trigger
```
:::
::::

::: paragraph
Bei manueller Installation des Agentenskriptes legen Sie die
Konfigurationsdatei `/etc/xinetd.d/check-mk-agent` mit dem Editor an.
Als Inhalt genügt:
:::

::::: listingblock
::: title
/etc/xinetd.d/check-mk-agent
:::

::: content
``` {.pygments .highlight}
service check_mk
{
        type           = UNLISTED
        port           = 6556
        socket_type    = stream
        protocol       = tcp
        wait           = no
        user           = root
        server         = /usr/local/bin/check_mk_agent
        # only_from    = 10.118.14.5 10.118.14.37
        disable        = no
}
```
:::
:::::

::: paragraph
Hier haben wir eine (auskommentierte) Zeile ergänzt, in welcher der
Zugriff auf zwei Checkmk-Server eingeschränkt wird. Weitere
Konfigurationsmöglichkeiten zeigt ein Blick in die Datei
`~/share/check_mk/agents/scripts/super-server/1_xinetd/check-mk-agent`
auf Ihrem Checkmk-Server.
:::

::: paragraph
Falls Ihr `xinetd` das alte Konfigurationsschema mit lediglich einer
großen `/etc/xinetd.conf` nutzt, übertragen Sie die
Beispielkonfiguration aus `/etc/check_mk/xinetd-service-template.cfg` in
die `/etc/xinetd.conf`.
:::

::: paragraph
Ist die Konfiguration des `xinetd` abgeschlossen, starten Sie ihn neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# service xinetd restart
```
:::
::::

::: paragraph
Sie sind nun bereit für den [Verbindungstest](#connectiontest).
:::
::::::::::::::::

:::::::::::::::::: sect2
### []{#otherinetd .hidden-anchor .sr-only}5.2. Andere inetd einrichten {#heading_otherinetd}

::: paragraph
Prüfen Sie zunächst, ob Ihre `/etc/services` bereits einen Eintrag für
Port 6556 enthält:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# grep 6556/ /etc/services
```
:::
::::

::: paragraph
Ist dies nicht der Fall, muss Checkmk als Dienst bekannt gemacht werden.
Fügen Sie dafür folgende Zeile hinzu. Die Schreibweise entspricht dabei
exakt der in der [IANA-Tabelle
hinterlegten](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml?search=checkmk-agent){target="_blank"}
mit nur einem Bindestrich:
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
Das Format der Konfigurationsdatei `/etc/inetd.conf` unterscheidet sich
zwischen den verschiedenen Varianten. Entnehmen Sie den Kommentaren in
der Konfigurationsdatei und der Manual Page (`man 5 inetd.conf`) das zu
Ihrem `inetd` passende Format. Es folgt die Konfiguration passend zum
`openbsd-inetd` mit zwei Zeilen für IPv4- und IPv6-Unterstützung. Auch
hier gilt es, die korrekte Schreibweise zu beachten:
:::

::::: listingblock
::: title
/etc/inetd.conf
:::

::: content
``` {.pygments .highlight}
checkmk-agent stream tcp  nowait root /usr/bin/check_mk_agent
checkmk-agent stream tcp6 nowait root /usr/bin/check_mk_agent
```
:::
:::::

::: paragraph
Nach Änderung der Konfigurationsdatei starten Sie den `inetd` neu, bspw.
mit:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /etc/init.d/inetd restart
```
:::
::::

::: paragraph
Je nach verwendetem init-System und installiertem Superserver kann
dieses Kommando abweichen.
:::
::::::::::::::::::

:::::::::: sect2
### []{#connectiontest .hidden-anchor .sr-only}5.3. Verbindungstest {#heading_connectiontest}

::: paragraph
Prüfen Sie zunächst, ob der `xinetd` oder `inetd` (neu) gestartet werden
konnte:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ss -tulpn | grep 6556
tcp    LISTEN 0    64  *:6556  *:* users:(("xinetd",pid=1573,fd=5))
```
:::
::::

::: paragraph
Nun können Sie sich mit `telnet` oder `nc` (`netcat`) auf TCP Port 6556
verbinden -- zunächst vom Host selbst, später vom Checkmk-Server aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ nc 12.34.56.78 6556
<<<check_mk>>>
Version: 2.2.0b1
AgentOS: linux
Hostname: myhost123
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
LocalDirectory: /usr/lib/check_mk_agent/local
```
:::
::::

::: paragraph
Erfolgt trotz aktivem `(x)inetd` ein Hinweis auf eine verweigerte
Verbindung, prüfen Sie Ihre Firewall-Einstellungen.
:::
::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#ssh .hidden-anchor .sr-only}6. Verschlüsselt: Nutzung eines SSH-Tunnels {#heading_ssh}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die Einrichtung des SSH-Tunnels geschieht in folgenden Schritten:
:::

::: {.olist .arabic}
1.  Erstellen Sie ein SSH-Schlüsselpaar speziell für diesen Zweck.

2.  Erlauben Sie auf den Zielsystemen den Zugriff auf den Agenten
    mittels dieses Schlüssels.

3.  Konfigurieren Sie den Checkmk-Server so, dass er anstelle der
    TCP-Verbindung auf Port 6556 SSH verwendet.

4.  Falls vorhanden: Klemmen Sie den Zugriff via `(x)inetd` ab.
:::

::: paragraph
Und das Ganze jetzt Schritt für Schritt mit allen notwendigen Details:
:::

:::::::::::::: sect2
### []{#_ssh_schlüsselpaar_erstellen .hidden-anchor .sr-only}6.1. SSH-Schlüsselpaar erstellen {#heading__ssh_schlüsselpaar_erstellen}

::: paragraph
SSH arbeitet mit „Public-Key-Authentifizierung". Dazu erzeugt man
zunächst ein Paar von aufeinander abgestimmten Schlüsseln, bei denen
einer öffentlich (public) ist und einer geheim (private). Bei der Wahl
der Algorithmen können Sie wählen zwischen `rsa`, `ecdsa` oder
`ed25519`. In dem nachfolgenden Beispiel nutzen Sie den Befehl
`ssh-keygen -t ed25519` als Instanzbenutzer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/omd/sites/mysite/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /omd/sites/mysite/.ssh/id_ed25519.
Your public key has been saved in /omd/sites/mysite/.ssh/id_ed25519.pub.
The key fingerprint is:
cc:87:34:d2:ed:87:ed:f7:1b:ec:58:1f:7c:23:00:e2 mysite@mycmkserver
The key's randomart image is:
+--[ED25519  256--+
|                 |
|       . .       |
|      ..+..      |
|      .=.+.o     |
|       ES +.o    |
|         . o. o  |
|            ...B.|
|             .=.*|
|             . o+|
+-----------------+
```
:::
::::

::: paragraph
Lassen Sie den Dateinamen leer, um den vorgeschlagenen Dateinamen zu
verwenden. Selbstverständlich können Sie einen anderen Pfad angeben,
beispielsweise wenn Sie mit [verschiedenen Schlüsseln für verschiedene
Hosts](#multiplekeys) arbeiten wollen.
:::

::: paragraph
**Wichtig**: Geben Sie **keine** Passphrase an! Es nützt Ihnen nichts,
die Datei mit dem geheimen Schlüssel zu verschlüsseln. Denn Sie möchten
ja sicher nicht jedes Mal beim Start des Checkmk-Servers die Passphrase
eingeben müssen...​
:::

::: paragraph
Das Ergebnis sind zwei Dateien im Verzeichnis `.ssh`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll .ssh
total 8
-rw------- 1 mysite mysite 1679 Feb 20 14:18 id_ed25519
-rw-r--r-- 1 mysite mysite  398 Feb 20 14:18 id_ed25519.pub
```
:::
::::

::: paragraph
Der private Schlüssel heißt `id_ed25519` und ist nur für den
Instanzbenutzer lesbar (`-rw-------`) --- und das ist auch gut so! Der
öffentliche Schlüssel `id_ed25519.pub` sieht etwa so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cat .ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGb6AaqRPlbEmDnBkeIW3Q6Emb5lr2QEbWEQLmA5pb48 mysite@mycmkserver
```
:::
::::
::::::::::::::

:::::::::: sect2
### []{#_zugriff_per_ssh_erlauben .hidden-anchor .sr-only}6.2. Zugriff per SSH erlauben {#heading__zugriff_per_ssh_erlauben}

::: paragraph
Der nächste Schritt muss jetzt auf (je-)dem per SSH überwachten
Linux-Hosts stattfinden. Loggen Sie sich dort als `root` ein und legen
Sie in dessen Home-Verzeichnis (`/root`) das Unterverzeichnis `.ssh` an,
falls es das nicht bereits gibt. Mit dem folgenden Befehl werden die
Zugriffsrechte gleich korrekt auf 700 gesetzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mkdir -m 700 /root/.ssh
```
:::
::::

::: paragraph
Öffnen Sie jetzt die Datei `authorized_keys` mit einem Texteditor Ihrer
Wahl. Falls die Datei nicht existiert, wird sie der Editor automatisch
anlegen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# vim /root/.ssh/authorized_keys
```
:::
::::

::: paragraph
Kopieren Sie den Inhalt der öffentlichen Schlüssel in diese Datei. Das
geht z.B. mit der Maus und Copy & Paste. Seien Sie genau! Jedes
Leerzeichen zählt. Achten Sie auch darauf, dass **nirgendwo zwei**
Leerzeichen hintereinander stehen. Und: Das ganze ist **eine Zeile!**
Wenn die Datei schon existiert, dann hängen Sie einfach unten eine neue
Zeile an.
:::
::::::::::

::::::::::::::::: sect2
### []{#_zugriff_auf_die_ausführung_des_agenten_beschränken .hidden-anchor .sr-only}6.3. Zugriff auf die Ausführung des Agenten beschränken {#heading__zugriff_auf_die_ausführung_des_agenten_beschränken}

::: paragraph
Was jetzt kommt, ist sehr wichtig! Der SSH-Schlüssel soll
**ausschließlich** zur Ausführung des Agenten dienen. SSH bietet so
etwas unter dem Namen *Command restriction* an. Dazu setzen Sie den Text
`command="/usr/bin/check_mk_agent"` an den Anfang der Zeile, die Sie
gerade erzeugt haben --- mit **einem** Leerzeichen vom Rest getrennt.
Das sieht dann etwa so aus:
:::

::::: listingblock
::: title
/root/.ssh/authorized_keys
:::

::: content
``` {.pygments .highlight}
command="/usr/bin/check_mk_agent" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGb6AaqRPlbEmDnBkeIW3Q6Emb5lr2QEbWEQLmA5pb48 mysite@mycmkserver
```
:::
:::::

::: paragraph
Speichern Sie die Datei und kontrollieren Sie die Rechte. Nur der
Eigentümer darf Schreibrechte auf dieser Datei haben.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod 600 /root/.ssh/authorized_keys
root@linux# ll /root/.ssh/authorized_keys
-rw------- 1 root root 1304 Feb 20 14:36 authorized_keys
```
:::
::::

::: paragraph
Testen Sie jetzt den Zugriff auf den Agenten mit dem Befehl `ssh`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ssh root@myhost23
The authenticity of host 'myhost23 (10.11.12.13)' can't be established.
ECDSA key fingerprint is SHA256:lWgVK+LtsMgjHUbdsA1FK12PdmVQGqaEY4TE8TEps3w.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
<<<check_mk>>>
Version: 2.2.0b1
AgentOS: linux
Hostname: myhost123
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
LocalDirectory: /usr/lib/check_mk_agent/local
<<<df>>>
```
:::
::::

::: paragraph
Beim ersten Mal müssen Sie den Fingerprint des Schlüssels mit der
Eingabe von `yes` bestätigen. Alle weiteren Zugriffe können dann ohne
Nutzerinteraktion erfolgen, so auch die minütliche automatische Abfrage
des Agentenskripts durch den Checkmk-Server.
:::

::: paragraph
Wenn es nicht klappt, überprüfen Sie bitte:
:::

::: ulist
- Ist der SSH-Server auf dem Zielsystem überhaupt installiert?

- Haben die genannten Dateien und Verzeichnisse die richtigen
  Berechtigungen?

- Haben Sie die Syntax von `authorized_keys` korrekt getippt?

- Haben Sie dort den richtigen öffentlichen Schlüssel eingetragen?

- Haben Sie sich als der richtige Benutzer eingeloggt (`root@…​`)?

- Haben Sie an das `command="…​"` gedacht?
:::

::: paragraph
Bei sehr alten Zielsystemen kann es zudem vorkommen, dass Schlüssel mit
elliptischen Kurven (`ed25519` und `ecdsa`) nicht bekannt sind. Erzeugen
Sie in diesem Fall zusätzlich einen RSA-Schlüssel und tragen Sie auch
diesen in die `authorized_keys` ein. SSH wird für die Verbindung dann
automatisch den stärksten bekannten Schlüssel verwenden.
:::
:::::::::::::::::

::::::::: sect2
### []{#_zugriff_von_checkmk_auf_ssh_umstellen .hidden-anchor .sr-only}6.4. Zugriff von Checkmk auf SSH umstellen {#heading__zugriff_von_checkmk_auf_ssh_umstellen}

::: paragraph
Das Zielsystem ist vorbereitet. Jetzt fehlt nur noch die Konfiguration
von Checkmk selbst. Das geschieht über den Regelsatz [Setup \> Agents \>
Other integrations\> Custom integrations \> Individual program call
instead of agent access]{.guihint}. Erstellen Sie hier für die
betroffenen Hosts eine Regel und tragen Sie als Befehl
`ssh -T root@$HOSTNAME$` oder `ssh -C -T root@$HOSTNAME$` (für
zusätzliche Komprimierung der Agentendaten) ein:
:::

::::: imageblock
::: content
![Regel zum Aufruf des Agenten über
SSH.](../images/agent_linux_rule_ssh_key.png)
:::

::: title
Der Aufruf des Agenten über SSH erfolgt per Regel
:::
:::::

::: paragraph
Sie können in der GUI unter [Setup \> Hosts \> Properties of host \>
Test connection to host]{.guihint} mit dem Button [Run tests]{.guihint}
den Verbindungstest durchführen. Schlägt dieser mit Timeout oder
verweigertem Zugriff fehl, überprüfen Sie, ob Sie zum Verbindungstest
den Hostnamen in exakt der Schreibweise verwendet haben, die im
Monitoring hinterlegt ist --- OpenSSH unterscheidet mittlerweile
zwischen Hostnamen ohne Domainpart, FQDN und IP-Adresse. Alternativ
können Sie auch über die IP-Adresse zugreifen, müssen dann aber das
Macro `$HOSTADDRESS$` verwenden, welches durch die von Checkmk
zwischengespeicherte IP-Adresse ersetzt wird.
:::

::: paragraph
Nach einem Speichern und einem [Aktivieren der
Änderungen](glossar.html#activate_changes) ist der Host ins Monitoring
aufgenommen. Im Monitoring wird nun der Dienst [Check-MK
Agent]{.guihint} mit dem Hinweis `Transport via SSH` angezeigt. Zur
weiteren Diagnose bieten sich die Befehle `cmk -D` und `cmk -d` an, die
im [Artikel über die Kommandozeile](cmk_commandline.html#cmk) erklärt
werden.
:::
:::::::::

:::::::: sect2
### []{#multiplekeys .hidden-anchor .sr-only}6.5. Mehrere SSH-Schlüssel {#heading_multiplekeys}

::: paragraph
Sie können auch mit mehr als einem SSH-Schlüssel arbeiten. Legen Sie die
Schlüssel in einem beliebigen Verzeichnis ab. In der Regel [Individual
program call instead of agent access]{.guihint} müssen Sie den Pfad zum
jeweiligen privaten Schlüssel dann mit der Option `-i` angeben.
Verwenden Sie hier am besten `$OMD_ROOT` als Ersatz für den Pfad zum
Instanzverzeichnis (`/omd/sites/mysite`). Der vollständige Befehl könnte
dann `ssh -i $OMD_ROOT/.ssh/my_key -T root@$HOSTADDRESS$` lauten und
damit wäre die Konfiguration auch in einer Instanz mit einem anderen
Namen lauffähig:
:::

::::: imageblock
::: content
![Regel zum Aufruf des Agenten mit mehreren
SSH-Schlüsseln.](../images/agent_linux_rule_multiple_ssh_keys.png)
:::

::: title
Um mehrere SSH-Schlüssel zu verwenden, muss das Kommando in der Regel
erweitert werden
:::
:::::

::: paragraph
Sie können so für verschiedene Gruppen von Hosts verschiedene
SSH-Schlüssel verwenden, indem Sie mehrere unterschiedliche Regeln
verwenden.
:::
::::::::

::::::::::::::::::::::::::::::::: sect2
### []{#_zugriff_auf_port_6556_deaktivieren .hidden-anchor .sr-only}6.6. Zugriff auf Port 6556 deaktivieren {#heading__zugriff_auf_port_6556_deaktivieren}

::: paragraph
Um potentielle Angreifer nicht trotz SSH-Tunnels mit Klartextdaten zu
versorgen, müssen Sie auf dem Host im Monitoring den eventuell noch
möglichen Zugriff auf Port 6556 deaktivieren. Falls der
[oben](#inventory) ausgeführte Befehl `ss -tulpn | grep 6556` keinen
Prozess gefunden hat, der an TCP Port 6556 lauscht, sind Sie mit der
Einrichtung des SSH-Tunnels fertig. Wird eine Zeile ausgegeben, muss der
gefundene Prozess dauerhaft deaktiviert werden.
:::

::::::::::::::: sect3
#### []{#_xinetd .hidden-anchor .sr-only}xinetd {#heading__xinetd}

::: paragraph
Um den von `xinetd` bereitgestellten Port zu schließen, deaktivieren Sie
den xinetd-Dienst von Checkmk, indem Sie den Wert von `disabled` auf
`yes` setzen. Löschen Sie *nicht* die ganze Konfigurationsdatei -- diese
würde in manchen Konstellationen bei Agenten-Updates sonst wieder
auftauchen!
:::

::: paragraph
Das Deaktivieren führen Sie in der Datei `/etc/xinetd.d/check-mk-agent`
durch (bei Systemen mit älterer Agenten-Installation heißt die Datei
möglicherweise `/etc/xinetd.d/check_mk`):
:::

::::: listingblock
::: title
/etc/xinetd.d/check-mk-agent
:::

::: content
``` {.pygments .highlight}
service check_mk
{
        type           = UNLISTED
        port           = 6556
        socket_type    = stream
        protocol       = tcp
        wait           = no
        user           = root
        server         = /usr/bin/check_mk_agent
        disable        = yes
}
```
:::
:::::

::: paragraph
Danach starten Sie xinetd neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /etc/init.d/xinetd restart
```
:::
::::

::: paragraph
oder
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# service xinetd restart
```
:::
::::

::: paragraph
Stellen Sie nun sicher, dass [kein Zugriff über Port
6556](#connectiontest) mehr möglich ist.
:::
:::::::::::::::

:::::::::: sect3
#### []{#_inetd .hidden-anchor .sr-only}inetd {#heading__inetd}

::: paragraph
Ist es `inetd`, der den Zugriff auf Port 6556 regelt, passen Sie die
Konfigurationsdatei `/etc/inetd.conf` an. Suchen Sie dort die relevante
Zeile:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# grep -n check.*mk /etc/inetd.conf
```
:::
::::

::: paragraph
Kommentieren Sie die Zeile mit einer Raute `#` aus und starten Sie den
Prozess dann neu.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# /etc/init.d/inetd restart
```
:::
::::

::: paragraph
Prüfen Sie anschließend mit `telnet` oder `nc`, [ob der Zugriff noch
möglich](#connectiontest) ist.
:::
::::::::::

:::::::::: sect3
#### []{#_systemd .hidden-anchor .sr-only}systemd {#heading__systemd}

::: paragraph
Ergab die Suche, dass `systemd` TCP Port 6556 geöffnet hat, müssen Sie
jetzt den exakten Namen der Konfiguration ermitteln, die den Socket
bereitstellt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl list-units | grep 'check.*mk.*socket'
  check-mk-agent.socket        loaded active listening CheckMK Agent Socket
```
:::
::::

::: paragraph
Nun können Sie den Dienst zunächst stoppen und dann deaktivieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl stop check-mk-agent.socket
root@linux# systemctl disable check-mk-agent.socket
Removed /etc/systemd/system/sockets.target.wants/check-mk-agent.socket.
```
:::
::::

::: paragraph
Jetzt darf [kein Zugriff auf Port 6556](#connectiontest) mehr möglich
sein.
:::
::::::::::
:::::::::::::::::::::::::::::::::

:::::: sect2
### []{#checkconnection .hidden-anchor .sr-only}6.7. Erfolgskontrolle {#heading_checkconnection}

::: paragraph
Vergessen Sie auf keinen Fall einen abschließenden Test. Eine Verbindung
auf Port 6556 darf jetzt nicht mehr möglich sein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ telnet myhost123 6556
Trying 10.118.15.23...
telnet: Unable to connect to remote host: Connection refused
```
:::
::::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#further_options .hidden-anchor .sr-only}7. Weitere Absicherungsmöglichkeiten {#heading_further_options}

::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die hier vorgestellten Absicherungsmöglichkeiten beschreiben wir primär
aus Gründen der Kompatibilität zu Installationen im Bestand. In vielen
Fällen wird die Übermittlung der Agentenausgabe per SSH den
Anforderungen an Zugriffsbeschränkung und Abhörsicherheit genügen.
Dennoch kann es in Einzelfällen sinnvoll sein, die nachfolgend
vorgestellten Schutzmechanismen *zusätzlich* zu verwenden oder dann
einzusetzen, wenn kein SSH-Tunnel möglich ist.
:::

::: paragraph
Das Checkmk-Agentenskript kann seine Daten ohne Zusatzmittel selbst
verschlüsseln. Diese eingebaute symmetrische Verschlüsselung ist kein
Ersatz für eine Zugangskontrolle. Da aber ein Angreifer keine Befehle
senden und mit verschlüsselten Ausgabedaten nichts anfangen kann, ist
das Ziel der Abhörsicherheit meist hinreichend erfüllt.
:::

::: paragraph
Die Verschlüsselung braucht natürlich sowohl auf dem Agenten als auch
auf dem Server eine passende Konfiguration. Diese kann entweder von Hand
erstellt werden (Checkmk Raw) oder mit der Agentenbäckerei (kommerzielle
Editionen).
:::

::: paragraph
**Hinweis:** Da die symmetrische Verschlüsselung denselben Schlüssel für
Ver- und Entschlüsselung verwendet, kann ein Angreifer, der
beispielsweise ein mit der Agentenbäckerei erstelltes Update-Paket mit
dort enthaltenem Schlüssel abfängt, Kommunikationsinhalte entschlüsseln.
:::

:::::::::::::::::::::::::::: sect2
### []{#encryption .hidden-anchor .sr-only}7.1. Eingebaute Verschlüsselung aufsetzen {#heading_encryption}

:::::::: sect3
#### []{#_verschlüsselung_aktivieren .hidden-anchor .sr-only}Verschlüsselung aktivieren {#heading__verschlüsselung_aktivieren}

::: paragraph
Der erste Schritt führt über das [Setup]{.guihint}-Menü und das Anlegen
einer Regel im Regelsatz [Setup \> Agents \> Access to agents \> Checkmk
agent \> Symmetric encryption (Linux, Windows).]{.guihint} Die Regel
soll auf alle Hosts greifen, für die Sie Verschlüsselung einsetzen
möchten. SNMP-Hosts ignorieren diese Einstellung, daher müssen Sie sie
nicht explizit ausschließen.
:::

::::: imageblock
::: content
![Regel zur Aktivierung der eingebauten
Verschlüsselung.](../images/agent_linux_encrypt.png)
:::

::: title
Die eingebaute Verschlüsselung wird über eine Regel aktiviert
:::
:::::

::: paragraph
Mit der Option [Configure shared secret and apply symmetric
encryption]{.guihint} legen Sie fest, dass der Agent die Daten
verschlüsselt sendet. Die Verschlüsselung funktioniert mit einem
gemeinsamen Passwort (*shared secret*), das Sie hier angeben und sowohl
auf dem Checkmk-Server als auch auf dem Agenten im Klartext gespeichert
werden muss. Wählen Sie mit [![Symbol zum Auswürfeln eines
Passworts.](../images/icons/icon_random.png)]{.image-inline} ein
zufälliges Passwort aus und halten Sie es parat für den zweiten Schritt:
die Konfiguration des Agenten.
:::
::::::::

:::::::::: sect3
#### []{#_agent_konfigurieren .hidden-anchor .sr-only}Agent konfigurieren {#heading__agent_konfigurieren}

::: paragraph
Auf dem Host des Agenten erzeugen Sie die Datei
`/etc/check_mk/encryption.cfg` mit folgendem Inhalt:
:::

::::: listingblock
::: title
/etc/check_mk/encryption.cfg
:::

::: content
``` {.pygments .highlight}
ENCRYPTED=yes
PASSPHRASE='MyPassword'
```
:::
:::::

::: paragraph
Natürlich setzen Sie hier bei `PASSPHRASE` Ihr eigenes Passwort ein. Und
Sie sollten die Datei unbedingt vor Lesezugriffen anderer Benutzer
schützen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod 600 /etc/check_mk/encryption.cfg
```
:::
::::
::::::::::

:::::::::: sect3
#### []{#_checkmk_server_konfigurieren .hidden-anchor .sr-only}Checkmk-Server konfigurieren {#heading__checkmk_server_konfigurieren}

::: paragraph
Im dritten und letzten Schritt legen Sie mit der Regel [Enforce agent
data encryption]{.guihint} fest, wie der Checkmk-Server mit
unverschlüsselten Daten umgehen soll.
:::

::: paragraph
Sie haben die Wahl zwischen:
:::

::: ulist
- [Accept all incoming data, including unencrypted]{.guihint}: Daten von
  Agenten mit und ohne Verschlüsselung werden akzeptiert.

- [Accept all types of encryption]{.guihint}: Es werden nur noch
  verschlüsselte Daten akzeptiert, entweder per TLS oder per
  symmetrischer Verschlüsselung, wie im ersten Schritt aktiviert.

- [Accept TLS encrypted connections only]{.guihint}: Es werden nur per
  TLS verschlüsselte Daten akzeptiert.
:::

::::: imageblock
::: content
![Regel zur Festlegung, welche Daten des Agenten der Checkmk-Server
annimmt.](../images/agent_linux_enforce_encryption.png)
:::

::: title
Mit dieser Auswahl werden symmetrisch und TLS verschlüsselte Daten
akzeptiert
:::
:::::

::: paragraph
Es ist sinnvoll, zunächst mit [Accept all incoming data, including
unencrypted]{.guihint} zu beginnen. Sobald Sie meinen, dass alle Agenten
auf Verschlüsselung umgestellt sind, stellen Sie auf [Accept all types
of encryption]{.guihint}, um dadurch Hosts zu finden, die möglicherweise
noch Daten im Klartext senden. Hosts, die unverschlüsselte Daten senden,
werden erkannt und „rot" gekennzeichnet.
:::
::::::::::

::::: sect3
#### []{#_test .hidden-anchor .sr-only}Test {#heading__test}

::: paragraph
Jetzt können Sie folgende Tests machen (siehe dazu auch den Artikel über
[Checkmk auf der Kommandozeile](cmk_commandline.html)):
:::

::: ulist
- Der Aufruf von `check_mk_agent` auf dem Zielsystem muss wirren
  Zeichensalat ausgeben.

- Der Zugriff via `telnet myhost123 6556` vom Checkmk-Server muss den
  gleichen Zeichensalat ausgeben.

- Der Befehl `cmk -d myhost123` auf dem Checkmk-Server muss die sauberen
  Klartextdaten anzeigen.
:::
:::::
::::::::::::::::::::::::::::

:::: sect2
### []{#_eingebaute_verschlüsselung_mit_der_agentenbäckerei_aufsetzen .hidden-anchor .sr-only}7.2. Eingebaute Verschlüsselung mit der Agentenbäckerei aufsetzen {#heading__eingebaute_verschlüsselung_mit_der_agentenbäckerei_aufsetzen}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Das Aufsetzen der
Verschlüsselung mit der Agentenbäckerei geht so: Mit dem ersten Schritt,
dem Erstellen der Regel [Symmetric encryption (Linux,
Windows),]{.guihint} sind Sie fast fertig. Sie brauchen nur noch neue
Agenten zu backen und zu verteilen. Die Datei
`/etc/check_mk/encryption.cfg` wird automatisch für Sie erzeugt und mit
in die Agentenpakete eingebaut. Übrig bleibt dann nur der dritte
Schritt, d.h. die Erstellung der Regel [Enforce agent data
encryption.]{.guihint}
:::
::::

:::::::::: sect2
### []{#_xinetd_ip_beschränkung .hidden-anchor .sr-only}7.3. xinetd: IP-Beschränkung {#heading__xinetd_ip_beschränkung}

::: paragraph
Auch wenn ein Angreifer keine Befehle ausführen kann: Die
Monitoring-Daten des Agenten könnten für ihn bereits nützlich sein, denn
sie enthalten unter anderem eine Liste von allen auf dem System
laufenden Prozessen. Am besten ist es daher, wenn die Daten nicht jeder
einfach abrufen kann.
:::

::: paragraph
Wenn Sie den Checkmk Agenten über den `xinetd` freigeben, ist es sehr
einfach und effektiv, den Zugriff auf bestimmte IP-Adressen zu
beschränken --- und zwar natürlich auf die des Monitoring-Servers. Das
ist über die Direktive `only_from` der Konfigurationsdatei Ihres
`xinetd` schnell zu erreichen. Tragen Sie durch Leerzeichen getrennt
IP-Adressen oder Adressbereiche (in der Form `12.34.56.78/29` oder
`1234::/46`) ein. Zulässig sind auch Host-Namen. In diesem Fall wird
geprüft, ob der durch *Rückwärtsauflösung* der IP-Adresse des
anfragenden Hosts ermittelte Host-Name mit dem eingetragenen
übereinstimmt:
:::

::::: listingblock
::: title
/etc/xinetd.d/check-mk-agent
:::

::: content
``` {.pygments .highlight}
service check_mk
{
        type           = UNLISTED
        port           = 6556
        socket_type    = stream
        protocol       = tcp
        wait           = no
        user           = root
        server         = /usr/bin/check_mk_agent
        only_from      = 10.118.14.5 10.118.14.37
        disable        = no
}
```
:::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen können Benutzer der Agentenbäckerei die
erlaubten IP-Adressen über den Regelsatz [Allowed agent access via IP
address (Linux, Windows)]{.guihint} konfigurieren. Diesen Regelsatz
finden Sie über [Setup \> Agents \> Windows, Linux, Solaris, AIX \>
Agent rules \> Generic Options]{.guihint}.
:::

::: paragraph
Natürlich kann ein Angreifer sehr leicht seine IP-Adresse fälschen und
so eine Verbindung zum Agenten bekommen. Aber dann ist es sehr
wahrscheinlich, dass er die Antwort nicht bekommt --- weil diese zum
echten Monitoring-Server geht. Oder er bekommt sie tatsächlich, aber der
Checkmk-Server bekommt keinerlei Daten und wird sehr bald einen Fehler
melden.
:::
::::::::::
:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#errors .hidden-anchor .sr-only}8. Häufige Fehlermeldungen beim Umgang mit SSH {#heading_errors}

::::: sectionbody
::: paragraph
Wenn Sie den Checkmk-Agenten über SSH abrufen möchten, kann es mitunter
vorkommen, dass eben dieser Abruf nicht klappt und der Service
[Check_MK]{.guihint} auf Ihrem Host in den Zustand [CRIT]{.state2}
wechselt. Diese Fehlermeldungen beginnen dann häufig mit
`Agent exited with code 255`.
:::

::: paragraph
Informationen zur Behebung solcher Fehler, können Sie in dem
[entsprechenden Artikel in unserer
Wissensdatenbank](https://kb.checkmk.com/display/KB/Executing+the+Linux+agent+over+ssh){target="_blank"}
finden.
:::
:::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
