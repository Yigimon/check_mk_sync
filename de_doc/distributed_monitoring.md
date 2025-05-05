:::: {#header}
# Verteiltes Monitoring

::: details
[Last modified on 19-Jan-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/distributed_monitoring.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Statusdaten abrufen via Livestatus](livestatus.html) [Der Checkmk Micro
Core](cmc.html) [Instanzen (Sites) mit omd verwalten](omd_basics.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
Unter dem Begriff „verteiltes Monitoring" (*distributed monitoring*)
versteht wahrscheinlich nicht jeder das Gleiche. Und eigentlich ist
Monitoring ja immer über viele Rechner verteilt --- solange das
Monitoring-System nicht nur sich selbst überwacht, was schließlich wenig
nützlich wäre.
:::

::: paragraph
In diesem Handbuch sprechen wir immer dann von einem verteilten
Monitoring, wenn das gesamte Monitoring-System aus *mehr als einer
Checkmk-Instanz* besteht. Dabei gibt es verschiedene Gründe für das
Aufteilen in mehrere Instanzen:
:::

::: ulist
- Performance: Die Rechenlast des Monitorings soll oder muss auf mehrere
  Maschinen verteilt werden.

- Organisation: Die Instanzen sollen von unterschiedlichen
  Personenkreisen eigenverantwortlich administriert werden.

- Verfügbarkeit: Das Monitoring an einem Standort soll unabhängig von
  anderen Standorten funktionieren.

- Sicherheit: Datenströme zwischen zwei Sicherheitsbereichen sollen
  getrennt und genau kontrolliert werden (DMZ etc.).

- Netzwerk: Standorte, die nur schmalbandig oder unzuverlässig
  angebunden sind, können nicht zuverlässig von der Ferne aus überwacht
  werden.
:::

::: paragraph
Checkmk unterstützt mehrere Verfahren für den Aufbau eines verteilten
Monitorings. Manche davon beherrscht Checkmk, weil es mit Nagios
weitgehend kompatibel ist bzw. darauf aufbaut (falls Nagios als Kern
eingestellt wurde). Dazu gehört z.B. das Verfahren mit `mod_gearman`.
Dieses bietet gegenüber den Checkmk-eigenen Verfahren keine Vorteile und
ist noch dazu umständlicher einzurichten. Wir empfehlen es daher nicht.
:::

::: paragraph
Das von Checkmk bevorzugte Verfahren basiert auf
[Livestatus](#livestatus) und einer automatischen
Konfigurationsverteilung. Für Situationen mit stark abgeschotteten
Netzen oder sogar einer *strikt unidirektionalen Datenübertragung* von
der Peripherie in die Zentrale gibt es eine Methode mit [Livedump bzw.
CMCDump.](#livedump) Beide Methoden können kombiniert werden.
:::
::::::::
:::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#livestatus .hidden-anchor .sr-only}2. Verteiltes Monitoring mit Livestatus {#heading_livestatus}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#_grundprinzip .hidden-anchor .sr-only}2.1. Grundprinzip {#heading__grundprinzip}

:::::::::: sect3
#### []{#central_status .hidden-anchor .sr-only}Zentraler Status {#heading_central_status}

::: paragraph
[Livestatus](livestatus.html) ist eine in den
[Monitoring-Kern](cmc.html) integrierte Schnittstelle, mit der andere
Programme von außen *Statusdaten* abfragen und *Kommandos* ausführen
können. Livestatus kann über das Netzwerk verfügbar gemacht werden, so
dass eine entfernte Checkmk-Instanz (*Remote-Instanz*) zugreifen kann.
Die [Benutzeroberfläche](user_interface.html) von Checkmk nutzt
Livestatus, um alle angebundenen Instanzen zu einer Gesamtsicht
zusammenzuführen. Das fühlt sich dann „wie ein großes\"
Monitoring-System an.
:::

::: paragraph
Folgende Skizze zeigt schematisch den Aufbau eines verteilten
Monitorings mit Livestatus über drei Standorte. In der Zentrale befindet
sich die Checkmk-Instanz *Central Site.* Von dieser aus werden zentrale
Systeme direkt überwacht. Außerdem gibt es die Instanzen *Remote Site 1*
und *Remote Site 2,* welche sich in anderen Netzen befinden und die
dortigen Systeme überwachen:
:::

:::: imageblock
::: content
![distributed monitoring overview
de](../images/distributed_monitoring_overview_de.png)
:::
::::

::: paragraph
Das Besondere an dieser Methode ist, dass der Monitoring-Status der
entfernten Instanzen *nicht* ständig an die Zentrale übertragen wird.
Die GUI ruft von den entfernten Instanzen immer nur *live* diejenigen
Daten ab, die ein Benutzer in der Zentrale haben will. Die Daten werden
dann in einer kombinierten Ansicht zusammengeführt. Es gibt also *keine
zentrale Datenhaltung,* was riesige Vorteile für die Skalierung
bedeutet!
:::

::: paragraph
Hier sind einige der Vorteile dieser Methode:
:::

::: ulist
- **Skalierung**: Das Monitoring selbst erzeugt keinerlei
  Netzwerkverkehr zwischen der Zentralinstanz und Remote-Instanz.
  Dadurch können hundert und mehr Standorte angebunden werden.

- **Zuverlässigkeit**: Fällt die Netzwerkverbindung zu einer
  Remote-Instanz aus, so geht das Monitoring dort trotzdem völlig normal
  weiter. Es gibt keine Lücke in der Datenaufzeichnung und auch keinen
  Datenstau. Lokale Benachrichtigungen funktionieren weiterhin.

- **Einfachheit**: Instanzen können sehr einfach eingebunden und wieder
  entfernt werden.

- **Flexibilität**: Die Remote-Instanzen sind weiterhin eigenständig und
  können an dem jeweiligen Standort für das Operating genutzt werden.
  Das ist insbesondere dann interessant, wenn der „Standort" auf keinen
  Fall Zugriff auf den Rest des Monitorings haben darf.
:::
::::::::::

::::::: sect3
#### []{#distr_wato .hidden-anchor .sr-only}Zentrale Konfiguration {#heading_distr_wato}

::: paragraph
Bei einem verteilten System via Livestatus wie oben beschrieben, ist es
durchaus möglich, dass die einzelnen Instanzen von unterschiedlichen
Teams eigenverantwortlich gepflegt werden und die Zentralinstanz
lediglich die Aufgabe hat, ein zentrales Dashboard bereitzustellen.
:::

::: paragraph
Falls aber mehrere oder alle Instanzen von den gleichen Menschen
administriert werden sollen, ist eine zentrale Konfiguration viel
komfortabler. Checkmk unterstützt dies und wir sprechen dann von einer
verteilten Konfigurationsumgebung. Dabei werden alle Hosts und Services,
Benutzer und Rechte, Zeitperioden, Benachrichtigungen u.s.w. im
[Setup]{.guihint} der Zentralinstanz zentral gepflegt und dann
automatisch nach Ihren Vorgaben auf die Remote-Instanzen verteilt.
:::

::: paragraph
So ein System hat nicht nur eine gemeinsame Statusoberfläche, sondern
auch eine gemeinsame Konfiguration und fühlt sich dann endgültig wie
„ein großes System" an.
:::

::: paragraph
Sie können solch ein System sogar noch um reine
[Viewer-Instanzen](#viewer) erweitern, die nur als Statusoberflächen
dienen, etwa für Teilbereiche oder bestimmte Nutzergruppen.
:::
:::::::
::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#distr_wato_config .hidden-anchor .sr-only}2.2. Verteiltes Monitoring aufsetzen {#heading_distr_wato_config}

::: paragraph
Das Aufsetzen eines verteilten Monitorings via Livestatus und verteilter
Konfigurationsumgebung geschieht in folgenden Schritten:
:::

::: {.olist .arabic}
1.  Zentralinstanz zunächst ganz normal wie eine Einzelinstanz aufsetzen

2.  Remote-Instanzen aufsetzen und Livestatus per Netzwerk freigeben

3.  Auf der Zentralinstanz die Remote-Instanzen über [Setup \> General
    \> Distributed monitoring]{.guihint} einbinden

4.  Bei Hosts und Ordnern festlegen, von welcher Instanz aus diese
    überwacht werden sollen

5.  Serviceerkennung für umgezogene Hosts neu durchführen und Änderungen
    aktivieren
:::

:::: sect3
#### []{#_zentralinstanz_aufsetzen .hidden-anchor .sr-only}Zentralinstanz aufsetzen {#heading__zentralinstanz_aufsetzen}

::: paragraph
An die Zentrale werden keine speziellen Anforderungen gestellt. Das
bedeutet, dass Sie auch eine schon länger bestehende Instanz ohne
weitere Anpassungen zu einem verteilten Monitoring ausbauen können.
:::
::::

::::::::::::::::::::::::: sect3
#### []{#_remote_instanzen_aufsetzen_und_livestatus_per_netzwerk_freigeben .hidden-anchor .sr-only}Remote-Instanzen aufsetzen und Livestatus per Netzwerk freigeben {#heading__remote_instanzen_aufsetzen_und_livestatus_per_netzwerk_freigeben}

::: paragraph
Die Remote-Instanzen werden zunächst als neue Instanzen wie üblich mit
`omd create` erzeugt. Dies geschieht dann natürlich auf dem (entfernten)
Server, der für die jeweilige Remote-Instanz vorgesehen ist.
:::

::: paragraph
**Hinweise**:
:::

::: ulist
- Verwenden Sie für die Remote-Instanzen IDs, die in Ihrem verteilten
  Monitoring *eindeutig* sind.

- Die Checkmk-Version (z.B. [2.2.0]{.new}) der Remote- und
  Zentralinstanz ist dieselbe -- ein [Mischbetrieb](#mixed_versions)
  wird nur für die leichtere Durchführung von Updates unterstützt.

- Da Checkmk mehrere Instanzen auf einem Server unterstützt, kann die
  Remote-Instanz auch auf dem gleichen Server laufen.
:::

::: paragraph
Hier ist ein Beispiel für das Anlegen einer Remote-Instanz mit dem Namen
`remote1`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd create remote1
Adding /opt/omd/sites/remote1/tmp to /etc/fstab.
Creating temporary filesystem /omd/sites/remote1/tmp...OK
Updating core configuration...
Generating configuration for core (type cmc)...
Starting full compilation for all hosts Creating global helper config...OK
 Creating cmc protobuf configuration...OK
Executing post-create script "01_create-sample-config.py"...OK
Restarting Apache...OK
Created new site remote1 with version 2.2.0p1.cee.

  The site can be started with omd start remote1.
  The default web UI is available at http://myserver/remote1/

  The admin user for the web applications is cmkadmin with password: lEnM8dUV
  For command line administration of the site, log in with 'omd su remote1'
  After logging in, you can change the password for cmkadmin with 'cmk-passwd cmkadmin'.
```
:::
::::

::: paragraph
Der wichtigste Schritt ist jetzt, dass Sie Livestatus via TCP auf dem
Netzwerk freigeben. Beachten Sie dabei, dass Livestatus per se kein
abgesichertes Protokoll ist und nur in einem sicheren Netzwerk
(abgesichertes LAN, VPN etc.) verwendet werden darf. Das Freigeben
geschieht als Instanzbenutzer bei noch gestoppter Instanz per
`omd config`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# su - remote1
OMD[remote1]:~$ omd config
```
:::
::::

::: paragraph
Wählen Sie jetzt [Distributed Monitoring]{.guihint}:
:::

:::: imageblock
::: content
![distributed monitoring omd
config](../images/distributed_monitoring_omd_config.png){width="46%"}
:::
::::

::: paragraph
Setzen Sie [LIVESTATUS_TCP]{.guihint} auf [on]{.guihint} und tragen Sie
für [LIVESTATUS_TCP_PORT]{.guihint} eine freie Portnummer ein, die auf
diesem Server eindeutig ist. Der Default dafür ist 6557:
:::

:::: imageblock
::: content
![distributed monitoring livestatus tcp
activated](../images/distributed_monitoring_livestatus_tcp_activated.png){width="380"}
:::
::::

::: paragraph
Nach dem Speichern starten Sie die Instanz wie gewohnt mit `omd start`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ omd start
Temporary filesystem already mounted
Starting mkeventd...OK
Starting liveproxyd...OK
Starting mknotifyd...OK
Starting rrdcached...OK
Starting cmc...OK
Starting apache...OK
Starting dcd...OK
Starting redis...OK
Starting xinetd...OK
Initializing Crontab...OK
```
:::
::::

::: paragraph
Merken Sie sich das Passwort für `cmkadmin`. Sobald die Remote-Instanz
der Zentralinstanz untergeordnet wurde, werden sowieso alle Benutzer
durch die von der Zentralinstanz ausgetauscht.
:::

::: paragraph
Die Instanz ist jetzt bereit. Eine Kontrolle mit `netstat` zeigt, dass
Port 6557 geöffnet ist. Die Bindung an diesen Port geschieht mit einer
Instanz des Internet Superservers `xinetd`, welcher direkt in der
Instanz läuft:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# netstat -lnp | grep 6557
tcp6       0      0 :::6557               :::*          LISTEN      10719/xinetd
```
:::
::::
:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect3
#### []{#connect_remote_sites .hidden-anchor .sr-only}Remote-Instanzen in die Zentralinstanz einbinden {#heading_connect_remote_sites}

::: paragraph
Die Konfiguration des verteilten Monitorings wird ausschließlich auf der
Zentralinstanz im Menü [Setup \> General \> Distributed
Monitoring]{.guihint} vorgenommen. Hier verwalten Sie die Verbindungen
zu den einzelnen Instanzen. Dabei zählt die Zentrale selbst auch als
Instanz und ist bereits in der Liste eingetragen:
:::

:::: imageblock
::: content
![distributed monitoring central
site](../images/distributed_monitoring_central_site.png)
:::
::::

::: paragraph
Legen Sie jetzt mit [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add
connection]{.guihint} die Verbindung zur ersten Remote-Instanz an:
:::

:::: imageblock
::: content
![distributed monitoring basic
settings](../images/distributed_monitoring_basic_settings.png)
:::
::::

::: paragraph
Bei den [Basic settings]{.guihint} ist es wichtig, dass Sie als [Site
ID]{.guihint} exakt den Namen der Remote-Instanz verwenden, so wie diese
mit `omd create` erzeugt wurde. Den Alias können Sie wie immer frei
vergeben und auch später ändern.
:::

:::: imageblock
::: content
![distributed monitoring status
connection](../images/distributed_monitoring_status_connection.png)
:::
::::

::: paragraph
Bei den Einstellungen der [Status connection]{.guihint} geht es darum,
wie die Zentralinstanz den Status der Remote-Instanzen per Livestatus
abfragt. Das Beispiel im Screenshot zeigt eine Verbindung mit der
Methode [Connect via TCP (IPv4)]{.guihint}. Diese ist für stabile
Verbindungen mit kurzen Latenzzeiten optimal (wie z.B. in einem LAN).
Optimale Einstellungen bei WAN-Verbindungen besprechen wir [weiter
unten.](#wan)
:::

::: paragraph
Tragen Sie hier die HTTP-URL zu der Weboberfläche der Remote-Instanz ein
und zwar nur den Teil bis vor dem `check_mk/`. Wenn Sie grundsätzlich
per HTTPS auf Checkmk zugreifen, dann ersetzen Sie das `http` hier durch
`https`. Weitere Details erfahren Sie wie immer in der [![icon
help](../images/icons/icon_help.png)]{.image-inline} Inline-Hilfe oder
dem [Handbuchartikel zu HTTPS mit Checkmk.](omd_https.html)
:::

:::: imageblock
::: content
![distributed monitoring configuration
connection](../images/distributed_monitoring_configuration_connection.png)
:::
::::

::: paragraph
Das Replizieren der Konfiguration und somit die Verwendung der
verteilten Konfigurationsumgebung ist, wie eingangs besprochen,
optional. Aktivieren Sie die Replikation, wenn Sie die Remote-Instanz
von der Zentralinstanz aus mitkonfigurieren möchten. In diesem Fall
wählen Sie genau die Einstellungen, die Sie in obiger Abbildung sehen.
:::

::: paragraph
Sehr wichtig ist eine korrekte Einstellung für [URL of remote
site]{.guihint}. Die URL muss immer mit `/check_mk/` enden. Eine
Verbindung mit HTTPS ist empfehlenswert, setzt aber voraus, dass der
Apache der Remote-Instanz HTTPS unterstützt. Dies muss auf Linux-Ebene
des entfernten Servers [von Hand](omd_https.html) aufgesetzt werden. Bei
der Checkmk Appliance kann [HTTPS über die webbasierte
Konfigurationsoberfläche eingerichtet](appliance_usage.html#ssl) werden.
Falls Sie ein selbst signiertes Zertifikat verwenden, benötigen Sie die
Checkbox [Ignore SSL certificate errors]{.guihint}.
:::

::: paragraph
Nachdem Sie die Maske gespeichert haben, sehen Sie in der Übersicht eine
zweite Instanz:
:::

:::: imageblock
::: content
![distributed monitoring before
login](../images/distributed_monitoring_before_login.png)
:::
::::

::: paragraph
Der Monitoring-Status der (noch leeren) Remote-Instanz ist jetzt schon
korrekt eingebunden. Für eine verteilte Konfigurationsumgebung benötigen
Sie noch einen [Login]{.guihint} auf die entfernte Instanz von Checkmk.
Dabei tauscht die Zentralinstanz mit der Remote-Instanz ein
Anmeldegeheimnis aus, über das dann in Zukunft alle weitere
Kommunikation abläuft. Der Zugang `cmkadmin` auf der Instanz wird dann
nicht mehr verwendet.
:::

::: paragraph
Verwenden Sie als [Login credentials]{.guihint} `cmkadmin` und das
generierte Passwort der Remote-Instanz. Bestätigen Sie an dieser Stelle
noch per [Confirm overwrite,]{.guihint} dass Sie die Einstellungen
überschreiben wollen.
:::

:::: imageblock
::: content
![distributed monitoring login
credentials](../images/distributed_monitoring_login_credentials.png)
:::
::::

::: paragraph
Ein erfolgreicher Login wird so quittiert:
:::

:::: imageblock
::: content
![distributed monitoring successful
login](../images/distributed_monitoring_successful_login.png)
:::
::::

::: paragraph
Sollte es zu einem Fehler bei der Anmeldung kommen, kann dies
verschiedene Gründe haben, z.B.:
:::

::: {.olist .arabic}
1.  Die Remote-Instanz ist gerade gestoppt.

2.  Die [Multisite-URL of remote site]{.guihint} ist nicht korrekt
    eingestellt.

3.  Die Remote-Instanz ist unter dem in der URL eingestellten Hostnamen
    *von der Zentralinstanz aus* nicht erreichbar.

4.  Zentralinstanz und Remote-Instanz haben (zu) unterschiedliche
    Checkmk-Versionen.

5.  Benutzer und/oder Passwort sind falsch.
:::

::: paragraph
Die Punkte eins und zwei können Sie einfach testen, indem Sie die URL
der Remote-Instanz von Hand in Ihrem Browser aufrufen.
:::

::: paragraph
Wenn alles geklappt hat, führen Sie nun ein [Activate pending
changes]{.guihint} aus. Auf der Übersichtsseite der noch nicht
aktivierten Änderungen sehen Sie auch eine Übersicht der
Livestatus-Verbindungen sowie des Synchronisationszustands der
verteilten Konfigurationsumgebung der einzelnen Instanzen:
:::

:::: imageblock
::: content
![distributed monitoring activate pending
changes](../images/distributed_monitoring_activate_pending_changes.png)
:::
::::

::: paragraph
Die Spalte [Version]{.guihint} zeigt die Livestatus-Version der
jeweiligen Instanz an. Bei der Verwendung des [CMC](cmc.html) als
Checkmk-Kern (kommerzielle Editionen) ist die Versionsnummer des Kerns
(Spalte [Core]{.guihint}) identisch mit der Livestatus-Version. Falls
Sie Nagios als Kern verwenden (Checkmk Raw), sehen Sie hier die
Versionsnummer von Nagios.
:::

::: paragraph
Folgende Symbole zeigen Ihnen den Replikationsstatus der
Konfigurationsumgebung:
:::

+-----------------------------------+-----------------------------------+
| [![icon need                      | Diese Instanz hat ausstehende     |
| restart](../images/icons/icon_    | Änderungen und muss neu gestartet |
| need_restart.png)]{.image-inline} | werden. Mit einem Klick auf den   |
|                                   | Knopf [![icon need                |
|                                   | restart](../images/icons/icon_    |
|                                   | need_restart.png)]{.image-inline} |
|                                   | können Sie dies gezielt für diese |
|                                   | Instanz durchführen.              |
+-----------------------------------+-----------------------------------+
| [![icon need                      | Die Konfigurationsumgebung dieser |
| r                                 | Instanz ist nicht synchron und    |
| eplicate](../images/icons/icon_ne | muss übertragen werden. Danach    |
| ed_replicate.png)]{.image-inline} | ist dann natürlich auch ein       |
|                                   | Neustart notwendig, um die        |
|                                   | Konfiguration zu aktivieren.      |
|                                   | Beides zusammen erreichen Sie mit |
|                                   | einem Klick auf den Knopf [![icon |
|                                   | need                              |
|                                   | re                                |
|                                   | plicate](../images/icons/icon_nee |
|                                   | d_replicate.png)]{.image-inline}. |
+-----------------------------------+-----------------------------------+

::: paragraph
In der Spalte [Status]{.guihint} sehen Sie den Zustand der
Livestatus-Verbindung zur jeweiligen Instanz. Dieser wird rein
informativ angezeigt, da die Konfiguration ja nicht per Livestatus,
sondern per HTTP übertragen wird. Folgende Werte sind möglich:
:::

+-----------------------------------+-----------------------------------+
| [![icon status label              | Die Instanz ist per Livestatus    |
| online](../images                 | erreichbar.                       |
| /icons/icon_status_label_online.p |                                   |
| ng){width="80px"}]{.image-inline} |                                   |
+-----------------------------------+-----------------------------------+
| [![icon status label              | Die Instanz ist gerade nicht      |
| dead](../imag                     | erreichbar. Livestatus-Anfragen   |
| es/icons/icon_status_label_dead.p | laufen in einen *Timeout*. Dies   |
| ng){width="80px"}]{.image-inline} | verzögert den Seitenaufbau.       |
|                                   | Statusdaten dieser Instanz sind   |
|                                   | in der GUI nicht sichtbar.        |
+-----------------------------------+-----------------------------------+
| [![icon status label              | Die Instanz ist gerade nicht      |
| down](../imag                     | erreichbar, aber das ist aufgrund |
| es/icons/icon_status_label_down.p | der Einrichtung eines             |
| ng){width="80px"}]{.image-inline} | Status-Hosts oder durch den       |
|                                   | [Li                               |
|                                   | vestatus-Proxy](#livestatusproxy) |
|                                   | bekannt (siehe [unten](#wan)).    |
|                                   | Die Nichterreichbarkeit führt     |
|                                   | **nicht** zu Timeouts.            |
|                                   | Statusdaten dieser Instanz sind   |
|                                   | in der GUI nicht sichtbar.        |
+-----------------------------------+-----------------------------------+
| [![icon status label              | Die Livestatus-Verbindung zu      |
| disabled](../images/i             | dieser Instanz ist vorübergehend  |
| cons/icon_status_label_disabled.p | durch den Administrator (der      |
| ng){width="80px"}]{.image-inline} | Zentralinstanz) deaktiviert       |
|                                   | worden. Die Einstellung           |
|                                   | entspricht der Checkbox           |
|                                   | [Temporarily disable this         |
|                                   | connection]{.guihint} in der      |
|                                   | Einstellung dieser Verbindung.    |
+-----------------------------------+-----------------------------------+

::: paragraph
Ein Klick auf [![icon activate
changes](../images/icons/icon_activate_changes.png)]{.image-inline}
[Activate on selected sites]{.guihint} synchronisiert nun alle Instanzen
und aktiviert die Änderungen. Dies geschieht parallel, so dass sich die
Gesamtzeit nach der Dauer bei der langsamsten Instanz richtet. In der
Zeit enthalten sind die Erstellung eines Konfigurations-Snapshots für
die jeweilige Instanz, das Übertragen per HTTP, das Auspacken des
Snapshots auf der Instanz und das Aktivieren der Änderungen.
:::

::: paragraph
**Wichtig:** Verlassen Sie die Seite nicht, bevor die Synchronisation
auf alle Instanzen abgeschlossen wurde. Ein Verlassen der Seite
unterbricht die Synchronisation.
:::
:::::::::::::::::::::::::::::::::::::::

::::::: sect3
#### []{#_bei_hosts_und_ordnern_festlegen_von_welcher_instanz_aus_diese_überwacht_werden_sollen .hidden-anchor .sr-only}Bei Hosts und Ordnern festlegen, von welcher Instanz aus diese überwacht werden sollen {#heading__bei_hosts_und_ordnern_festlegen_von_welcher_instanz_aus_diese_überwacht_werden_sollen}

::: paragraph
Nachdem Ihre verteilte Umgebung eingerichtet ist, können Sie beginnen,
diese zu nutzen. Eigentlich müssen Sie jetzt nur noch bei jedem Host
sagen, von welcher Instanz aus dieser überwacht werden soll. Per Default
ist die Zentralinstanz eingestellt.
:::

::: paragraph
Das nötige Attribut dazu heißt „[Monitored on site]{.guihint}". Sie
können das für jeden einzelnen Host individuell einstellen. Aber
natürlich bietet es sich an, das auf Ordnerebene zu konfigurieren:
:::

:::: imageblock
::: content
![distributed monitoring monitored on
site](../images/distributed_monitoring_monitored_on_site.png)
:::
::::
:::::::

::::::: sect3
#### []{#_service_erkennung_für_umgezogene_hosts_neu_durchführen_und_änderungen_aktivieren .hidden-anchor .sr-only}Service-Erkennung für umgezogene Hosts neu durchführen und Änderungen aktivieren {#heading__service_erkennung_für_umgezogene_hosts_neu_durchführen_und_änderungen_aktivieren}

::: paragraph
Das Aufnehmen von Hosts funktioniert wie gewohnt. Bis auf die Tatsache,
dass die Überwachung und auch die Service-Erkennung von der jeweiligen
Remote-Instanz durchgeführt wird, gibt es nichts Spezielles zu beachten.
:::

::: paragraph
Beim **Umziehen** von Hosts von einer zu einer anderen Instanz gibt es
einige Dinge zu beachten. Denn es werden *weder aktuelle noch
historische Statusdaten dieser Hosts übernommen.* Lediglich die
Konfiguration des Hosts bleibt erhalten. Es ist quasi, als würden Sie
den Host auf einer Instanz entfernen und auf der anderen *neu anlegen*.
Das bedeutet unter anderem:
:::

::: ulist
- Automatisch erkannte Services werden nicht übernommen. Führen Sie
  daher nach dem Umziehen eine [Service-Erkennung](wato_services.html)
  durch.

- Host und Services beginnen wieder bei [PEND]{.statep}. Zu eventuell
  aktuell vorhandenen Problemen werden neue Benachrichtigungen erzeugt
  und gegebenenfalls versendet.

- Historische [Metriken](graphing.html) gehen verloren. Dies können Sie
  vermeiden, indem Sie betroffene RRD-Dateien von Hand kopieren. Die
  Lage der Dateien finden Sie unter [Dateien und Verzeichnisse.](#files)

- Daten zur Verfügbarkeit und zu historischen Ereignissen gehen
  verloren. Diese sind leider nicht so einfach zu migrieren, da diese
  Daten sich in einzelnen Zeilen im Monitoring-Log befinden.
:::

::: paragraph
Wenn die Kontinuität der Historie für Sie wichtig ist, sollten Sie schon
beim Aufbau des Monitorings genau planen, welcher Host von wo aus
überwacht werden soll.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: sect2
### []{#livestatus_tls .hidden-anchor .sr-only}2.3. Livestatus verschlüsselt anbinden {#heading_livestatus_tls}

::: paragraph
Livestatus-Verbindungen können zwischen der Zentralinstanz und einer
Remote-Instanz verschlüsselt werden. Bei neu erzeugten Instanzen müssen
Sie nichts weiter tun. Checkmk kümmert sich automatisch um die nötigen
Schritte. Sobald Sie dann mittels [`omd config`](#distr_wato_config)
Livestatus aktivieren, ist die Verschlüsselung durch TLS automatisch
aktiviert:
:::

:::: imageblock
::: content
![distributed monitoring livestatus tcp tls
activated](../images/distributed_monitoring_livestatus_tcp_tls_activated.png){width="64%"}
:::
::::

::: paragraph
Die Konfiguration des verteilten Monitorings bleibt daher so einfach wie
bisher. Bei neuen Verbindungen zu anderen Instanzen ist dann die Option
[Encryption]{.guihint} automatisch aktiviert.
:::

::: paragraph
Nachdem Sie die Remote-Instanz hinzugefügt haben, werden Sie zwei Dinge
bemerken: Zum einen wird die Verbindung durch das neue Icon [![icon
encrypted](../images/icons/icon_encrypted.png)]{.image-inline} als
verschlüsselt markiert. Und zum anderen wird Checkmk Ihnen anzeigen,
dass der CA der Remote-Instanz nicht vertraut wird. Mit einem Klick auf
[![icon encrypted](../images/icons/icon_encrypted.png)]{.image-inline}
gelangen Sie in die Details der benutzten Zertifikate. Mit einem Klick
auf [![icon trust](../images/icons/icon_trust.png)]{.image-inline}
können Sie die CA bequem über die Weboberfläche hinzufügen. Danach
werden beide Zertifikate als vertrauenswürdig gelistet:
:::

:::: imageblock
::: content
![distributed monitoring certificate
details](../images/distributed_monitoring_certificate_details.png)
:::
::::

::::::: sect3
#### []{#_details_zu_den_eingesetzten_technologien .hidden-anchor .sr-only}Details zu den eingesetzten Technologien {#heading__details_zu_den_eingesetzten_technologien}

::: paragraph
Um die Verschlüsselung zu realisieren, nutzt Checkmk das Programm
`stunnel` zusammen mit einem eigenen Zertifikat und einer eigenen
*Certificate Authority* (CA), mit der das Zertifikat signiert wird. Sie
werden bei einer neuen Instanz automatisch zusammen mit dieser
individuell erzeugt und sind daher **keine** vordefinierten, statischen
CAs oder Zertifikate. Das ist ein sehr wichtiger Sicherheitsfaktor, um
zu verhindern, dass gefälschte Zertifikate von Angreifern benutzt werden
können, weil sie Zugriff auf eine allgemein zugängliche CA bekommen
konnten. Die erzeugten
:::

::: paragraph
Zertifikate haben zusätzlich folgende Eigenschaften:
:::

::: ulist
- Beide Zertifikate liegen im PEM-Format vor. Das signierte Zertifikat
  der Instanz enthält außerdem die komplette Zertifikatskette.

- Die Schlüssel verwenden 2048-Bit RSA und das Zertifikat wird mit
  SHA512 signiert.

- Das Zertifikat der Instanz ist 999 Jahre gültig.
:::

::: paragraph
Dass das Standard-Zertifikat so lange gültig ist, verhindert sehr
effektiv, dass Sie nach einiger Zeit Verbindungsprobleme bekommen, die
Sie nicht einordnen können. Gleichzeitig ist es dadurch natürlich auch
möglich ein einmal kompromittiertes Zertifikat auch entsprechend lange
zu missbrauchen. Wenn Sie also befürchten, dass ein Angreifer Zugriff
auf die CA oder das damit signierte Instanz-Zertifikat bekommen hat,
ersetzen Sie immer beide Zertifikate (CA und Instanz)!
:::
:::::::

::::::::::: sect3
#### []{#livestatus_tls_omd_update .hidden-anchor .sr-only}Verhalten beim Update von Checkmk {#heading_livestatus_tls_omd_update}

::: paragraph
Im Zuge eines Updates von Checkmk werden die beiden Optionen
`LIVESTATUS_TCP` und `LIVESTATUS_TCP_TLS` niemals automatisch verändert.
Eine automatische Aktivierung von TLS könnte schließlich dazu führen,
dass Ihre Remote-Instanzen nicht mehr abgefragt werden können.
:::

::: paragraph
Sollten Sie Livestatus bisher unverschlüsselt einsetzen und sich jetzt
entscheiden die Verschlüsselung nutzen zu wollen, müssen sie diese
manuell aktivieren. Stoppen Sie dazu zuerst die betroffenen Instanzen
und aktivieren Sie TLS anschließend mit dem folgenden Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set LIVESTATUS_TCP_TLS on
```
:::
::::

::: paragraph
Da die Zertifikate bei dem Update automatisch erzeugt wurden, wird die
Instanz danach sofort die Verschlüsselung nutzen. Damit Sie also von der
Zentralinstanz weiterhin auf die Remote-Instanz zugreifen können, muss
gewährleistet sein, dass im Menü unter [Setup \> General \> Distributed
Monitoring]{.guihint} bei der jeweiligen Instanz unter
[Encryption]{.guihint} die Option [Encrypt data using TLS]{.guihint}
ausgewählt ist. Prüfen Sie dies und stellen Sie die Option
gegebenenfalls, wie im folgenden Screenshots zu sehen ist, um:
:::

:::: imageblock
::: content
![distributed monitoring enable
encryption](../images/distributed_monitoring_enable_encryption.png)
:::
::::

::: paragraph
Der letzte Schritt ist wieder derselbe wie oben beschrieben: Auch hier
müssen Sie zunächst die CA der Remote-Instanz als vertrauenswürdig
markieren.
:::
:::::::::::
::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect2
### []{#_besonderheiten_im_verteilten_setup .hidden-anchor .sr-only}2.4. Besonderheiten im verteilten Setup {#heading__besonderheiten_im_verteilten_setup}

::: paragraph
Ein verteiltes Monitoring via Livestatus verhält sich zwar fast wie ein
einziges System, hat aber dennoch ein paar Besonderheiten:
:::

:::: sect3
#### []{#_zugriff_auf_die_überwachten_hosts .hidden-anchor .sr-only}Zugriff auf die überwachten Hosts {#heading__zugriff_auf_die_überwachten_hosts}

::: paragraph
Alle Zugriffe auf einen überwachten Host geschehen konsequent von der
Instanz aus, der dieser Host zugeordnet ist. Das betrifft nicht nur die
eigentliche Überwachung, sondern auch die Serviceerkennung, die
[Diagnoseseite,](wato_monitoringagents.html#diagnosticpage) die
[Benachrichtigungen,](notifications.html) [Alert
Handler](alert_handlers.html) und alles andere. Das ist sehr wichtig,
denn es ist überhaupt nicht gesagt, dass die Zentralinstanz auf diese
Hosts Zugriff hätte.
:::
::::

:::::::::::: sect3
#### []{#_angabe_der_instanz_in_den_ansichten .hidden-anchor .sr-only}Angabe der Instanz in den Ansichten {#heading__angabe_der_instanz_in_den_ansichten}

::: paragraph
Manche der mitgelieferten Standardansichten sind gruppiert nach der
Instanz, von der ein Host überwacht wird. Das gilt z.B. auch für [All
hosts]{.guihint}:
:::

:::: imageblock
::: content
![distributed monitoring all
hosts](../images/distributed_monitoring_all_hosts.png)
:::
::::

::: paragraph
Auch bei den Details eines Hosts oder Services wird die Instanz
angezeigt:
:::

:::: imageblock
::: content
![distributed monitoring service check
mk](../images/distributed_monitoring_service_check_mk.png)
:::
::::

::: paragraph
Allgemein steht diese Information als Spalte beim Erzeugen von [eigenen
Ansichten](views.html#edit) zur Verfügung. Und es gibt einen Filter, mit
dem Sie eine Ansicht nach Hosts aus einer bestimmten Instanz filtern
können:
:::

:::: imageblock
::: content
![distributed monitoring filter by
site](../images/distributed_monitoring_filter_by_site.png){width="60%"}
:::
::::
::::::::::::

::::::: sect3
#### []{#_site_status_snapin .hidden-anchor .sr-only}Site status Snapin {#heading__site_status_snapin}

::: paragraph
Es gibt für die Seitenleiste das Snapin [Site status]{.guihint}, welches
Sie mit [![button sidebar add
snapin](../images/icons/button_sidebar_add_snapin.png)]{.image-inline}
einbinden können. Dieses zeigt den Status der einzelnen Instanzen.
Außerdem bietet es die Möglichkeit, vorübergehend eine einzelne Instanz
durch einen Klick auf den Status zu deaktivieren und wieder zu
aktivieren --- oder auch gleich alle Instanzen auf einmal durch Klick
auf [Disable all]{.guihint} oder [Enable all.]{.guihint}
:::

:::: imageblock
::: content
![distributed monitoring snapin site
status](../images/distributed_monitoring_snapin_site_status.png){width="50%"}
:::
::::

::: paragraph
Deaktivierte Instanzen werden mit dem Status [![icon status label
disabled](../images/icons/icon_status_label_disabled.png){width="70px"}]{.image-inline}
angezeigt. Sie können so auch eine Instanz, die [![icon status label
dead](../images/icons/icon_status_label_dead.png){width="70px"}]{.image-inline}
ist und somit Timeouts erzeugt, deaktivieren und die Timeouts damit
vermeiden. Diese Deaktivierung entspricht **nicht** dem Abschalten der
Livestatus-Verbindung über die Verbindungskonfiguration im
[Setup]{.guihint}. Das Abschalten hier ist lediglich für den aktuell
angemeldeten Benutzer wirksam und hat eine rein optische Funktion. Ein
Klick auf den Namen einer Instanz bringt Sie zur Ansicht aller Hosts
dieser Instanz.
:::
:::::::

:::::: sect3
#### []{#_master_control_snapin .hidden-anchor .sr-only}Master control Snapin {#heading__master_control_snapin}

::: paragraph
Im verteilten Monitoring ändert das Snapin [Master control]{.guihint}
sein Aussehen. Die globalen Schalter gibt es immer *pro Instanz*:
:::

:::: imageblock
::: content
![distributed monitoring master
control](../images/distributed_monitoring_master_control.png){width="50%"}
:::
::::
::::::

:::: sect3
#### []{#_checkmk_cluster_hosts .hidden-anchor .sr-only}Checkmk Cluster Hosts {#heading__checkmk_cluster_hosts}

::: paragraph
Falls Sie mit Checkmk [HA-Cluster](clustered_services.html) überwachen,
so müssen die einzelnen Nodes des Clusters alle der gleichen Instanz
zugeordnet sein, wie der Cluster selbst. Dies liegt daran, dass bei der
Ermittlung des Zustands der geclusterten Services auf Cache-Dateien
zugegriffen wird, welche beim Überwachen der Nodes entstehen. Diese
liegen lokal auf der jeweiligen Instanz.
:::
::::

:::: sect3
#### []{#_piggyback_daten_z_b_esxi .hidden-anchor .sr-only}Piggyback-Daten (z.B. ESXi) {#heading__piggyback_daten_z_b_esxi}

::: paragraph
Manche Check-Plugins verwenden
[Piggyback](glossar.html#piggyback)-Daten, um z.B. Überwachungsdaten,
die „huckepack" von einem ESXi-Host geholt wurden, den einzelnen
virtuellen Maschinen zuzuordnen. Aus den gleichen Gründen wie beim
Cluster-Monitoring müssen im verteilten Monitoring sowohl der Piggyhost
als auch die davon abhängigen Hosts von der gleichen Instanz aus
überwacht werden. Im Falle von ESXi bedeutet das, dass Sie die
virtuellen Maschinen in Checkmk immer der gleichen Instanz zuordnen
müssen, wie das ESXi-System, von dem Sie die Überwachungsdaten holen.
Das kann dann dazu führen, dass Sie anstelle eines globalen vCenters
besser die ESXi Host-Systeme direkt abfragen. Details dazu finden Sie in
der Dokumentation zur Überwachung von ESXi.
:::
::::

:::::: sect3
#### []{#_hardware_softwareinventur .hidden-anchor .sr-only}Hardware-/Softwareinventur {#heading__hardware_softwareinventur}

::: paragraph
Die [Checkmk-Inventarisierung](inventory.html) funktioniert auch in
verteilten Umgebungen. Dabei müssen die Inventurdaten regelmäßig aus dem
Verzeichnis `var/check_mk/inventory` von den Remote-Instanzen zur
Zentralinstanz übertragen werden. Die Benutzeroberfläche greift aus
Gründen der Performance immer lokal auf dieses Verzeichnis zu.
:::

::: paragraph
In den kommerziellen Editionen geschieht die Synchronisation automatisch
auf allen Instanzen, bei denen Sie den
[Livestatus-Proxy](#livestatusproxy) zur Verbindung einsetzen.
:::

::: paragraph
Falls Sie mit Checkmk Raw in einem verteilten System Inventarisierung
verwenden, müssen Sie das Verzeichnis mit eigenen Mitteln regelmäßig zur
Zentralinstanz spiegeln (z.B. mit `rsync`).
:::
::::::

::::::::: sect3
#### []{#_passwortänderung .hidden-anchor .sr-only}Passwortänderung {#heading__passwortänderung}

::: paragraph
Auch wenn alle Instanzen zentral administriert werden, ist eine
Anmeldung auf der Oberfläche der einzelnen Instanzen durchaus möglich
und oft auch sinnvoll. Deswegen sorgt Checkmk dafür, dass das Passwort
eines Benutzers auf allen Instanzen immer gleich ist.
:::

::: paragraph
Bei einer Änderung durch den Administrator ist das automatisch gegeben,
sobald sie per [Activate pending changes]{.guihint} auf alle Instanzen
verteilt wird.
:::

::: paragraph
Etwas anderes ist eine Änderung durch den Benutzer selbst in seinen
[![button sidebar
settings](../images/icons/button_sidebar_settings.png)]{.image-inline}
persönlichen Einstellungen. Diese darf natürlich nicht zu einem
[Activate pending changes]{.guihint} führen, denn der Benutzer hat dazu
im Allgemeinen keine Berechtigung. Daher verteilt Checkmk in so einem
Fall das geänderte Passwort automatisch auf alle Instanzen --- und zwar
direkt nach dem Speichern.
:::

::: paragraph
Nun sind aber, wie wir alle wissen, Netzwerke nie zu 100 % verfügbar.
Ist eine Instanz zu diesem Zeitpunkt also nicht erreichbar, kann das
Passwort auf diese *nicht* übertragen werden. Bis zum nächsten
erfolgreichen [Activate pending changes]{.guihint} durch einen
Administrator bzw. der nächsten erfolgreichen Passwortänderung hat diese
Instanz also noch das alte Passwort für den Benutzer. Der Benutzer wird
über den Status der Passwortübertragung auf die einzelnen Instanzen
durch ein Statussymbol informiert.
:::

:::: imageblock
::: content
![distributed monitoring replicate user
profile](../images/distributed_monitoring_replicate_user_profile.png)
:::
::::
:::::::::
::::::::::::::::::::::::::::::::::::::::

::::::::::::::: sect2
### []{#_anbinden_von_bestehenden_instanzen .hidden-anchor .sr-only}2.5. Anbinden von bestehenden Instanzen {#heading__anbinden_von_bestehenden_instanzen}

::: paragraph
Wie bereits oben erwähnt, können Sie auch bestehende Instanzen
nachträglich an ein verteiltes Monitoring anbinden. Sofern die oben
beschriebenen Voraussetzungen erfüllt sind (passende Checkmk-Version),
geschieht dies genau wie beim Einrichten einer neuen Remote-Instanz.
Geben Sie Livestatus per TCP frei, tragen Sie die Instanz unter [Setup
\> General \> Distributed monitoring]{.guihint} ein --- fertig!
:::

::: paragraph
Der zweite Schritt, also die Umstellung auf eine zentrale Konfiguration,
ist etwas kniffliger. Bevor Sie, wie oben beschrieben, die Instanz in
die verteilte Konfigurationsumgebung einbinden, sollten Sie wissen, dass
dabei die komplette lokale Konfiguration der Instanz **überschrieben**
wird!
:::

::: paragraph
Wenn Sie also bestehende Hosts und eventuell auch Regeln übernehmen
möchten, benötigen Sie drei Schritte:
:::

::: {.olist .arabic}
1.  Schema der Host-Merkmale anpassen

2.  (Host-)Verzeichnisse kopieren

3.  Eigenschaften im Elternordner einmal editieren
:::

:::: sect3
#### []{#_1_host_merkmale .hidden-anchor .sr-only}1. Host-Merkmale {#heading__1_host_merkmale}

::: paragraph
Es versteht sich von selbst, dass die in der Remote-Instanz verwendeten
Host-Merkmale (*host tags*) auch in der Zentralinstanz bekannt sein
müssen, damit diese übernommen werden können. Kontrollieren Sie dies vor
dem Umziehen und legen Sie fehlende Tags in der Zentrale von Hand an.
Wichtig ist dabei, dass die Tag-ID übereinstimmt --- der Titel der Tags
spielt keine Rolle.
:::
::::

:::::: sect3
#### []{#_2_ordner .hidden-anchor .sr-only}2. Ordner {#heading__2_ordner}

::: paragraph
Als Zweites ziehen die Hosts und Regeln in die Konfigurationsumgebung
auf der Zentralinstanz um. Das funktioniert nur für Hosts und Regeln,
die in Unterordnern liegen (also nicht im Ordner [Main]{.guihint}).
Hosts im Hauptordner sollten Sie auf der Remote-Instanz einfach vorher
im Menü [Setup \> Hosts \> Hosts]{.guihint} in einen Unterordner
verschieben.
:::

::: paragraph
Das eigentliche Umziehen geht dann recht einfach durch Kopieren der
entsprechenden Verzeichnisse. Jeder Ordner in Checkmk entspricht einem
Verzeichnis unterhalb von `~/etc/check_mk/conf.d/wato/`. Dieses können
Sie mit einem Werkzeug Ihrer Wahl (z.B. `scp`) von der angebundenen
Instanz an die gleiche Stelle in die Zentralinstanz kopieren. Falls es
dort bereits ein gleichnamiges Verzeichnis gibt, benennen Sie es einfach
um. Achten Sie darauf, dass Linux-Benutzer und -Gruppe von der Zentrale
verwendet werden.
:::

::: paragraph
Nach dem Kopieren sollten die Hosts in der Konfigurationsumgebung auf
der Zentralinstanz auftauchen --- und ebenso Regeln, die Sie in diesen
Ordnern angelegt haben. Auch die Eigenschaften der Ordner wurden mit
kopiert. Diese befinden sich im Verzeichnis in der versteckten Datei
`.wato`.
:::
::::::

:::: sect3
#### []{#_3_einmal_editieren_und_speichern .hidden-anchor .sr-only}3. Einmal editieren und speichern {#heading__3_einmal_editieren_und_speichern}

::: paragraph
Damit die Vererbung von Attributen von Elternordnern der Zentralinstanz
korrekt funktioniert, müssen Sie als letzten Schritt nach dem Umziehen
einmal die Eigenschaften des Elternordners öffnen und speichern. Damit
werden alle Host-Attribute neu berechnet.
:::
::::
:::::::::::::::

:::::::::: sect2
### []{#sitespecific .hidden-anchor .sr-only}2.6. Instanzspezifische globale Einstellungen {#heading_sitespecific}

::: paragraph
Zentrale Konfiguration bedeutet zunächst einmal, dass alle Instanzen
eine gemeinsame und (bis auf die Hosts) gleiche Konfiguration haben. Was
ist aber, wenn Sie für einzelne Instanzen abweichende globale
Einstellungen benötigen? Ein Beispiel könnte z.B. die Einstellung
[Maximum concurrent Checkmk checks]{.guihint} des [CMC](cmc.html) sein.
Vielleicht benötigen Sie für eine besonders kleine oder große Instanz
eine angepasste Einstellung.
:::

::: paragraph
Für solche Fälle gibt es instanzspezifische globale Einstellungen. Zu
diesen gelangen Sie über das Symbol [![icon
configuration](../images/icons/icon_configuration.png)]{.image-inline}
im Menü [Setup \> General \> Distributed monitoring]{.guihint}:
:::

:::: imageblock
::: content
![distributed monitoring site specific global
configuration](../images/distributed_monitoring_site_specific_global_configuration.png)
:::
::::

::: paragraph
Damit gelangen Sie zur Auswahl aller globalen
Einstellungen --- allerdings gilt alles, was Sie jetzt einstellen, nur
für die ausgewählte Instanz. Die optische Hinterlegung für eine
Abweichung vom Standard bezieht sich jetzt nur auf diese Instanz:
:::

:::: imageblock
::: content
![distributed monitoring site specific global configuration
2](../images/distributed_monitoring_site_specific_global_configuration_2.png)
:::
::::
::::::::::

::::::: sect2
### []{#ec .hidden-anchor .sr-only}2.7. Verteilte Event Console {#heading_ec}

::: paragraph
Die [Event Console](ec.html) verarbeitet Syslog-Meldungen, SNMP Traps
und andere Arten von Ereignissen asynchroner Natur.
:::

::: paragraph
Checkmk bietet die Möglichkeit, die Event Console ebenfalls verteilt
laufen zu lassen. Auf jeder Instanz läuft dann eine eigene
Event-Verarbeitung, welche die Ereignisse von allen Hosts erfasst, die
von dieser Instanz aus überwacht werden. Die Events werden dann aber
*nicht* alle zum Zentralsystem geschickt, sondern verbleiben auf den
Instanzen und werden nur zentral abgefragt. Dies geschieht analog zu den
aktiven Zuständen über Livestatus und funktioniert sowohl mit
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** als auch mit den kommerziellen Editionen.
:::

::: paragraph
Eine Umstellung auf eine verteilte Event Console nach dem neuen Schema
erfordert folgende Schritte:
:::

::: ulist
- In den Verbindungseinstellungen die Replikation EC-Konfiguration
  einschalten ([Replicate Event Console configuration to this
  site]{.guihint}).

- Syslog-Ziele und SNMP-Trap-Destinations der betroffenen Hosts auf der
  Remote-Instanz umstellen. Das ist der aufwendigste Teil.

- Falls Sie den Regelsatz [Check event state in Event Console]{.guihint}
  verwenden, diesen wieder auf [Connect to the local Event
  Console]{.guihint} umstellen.

- Falls Sie den Regelsatz [Logwatch Event Console Forwarding]{.guihint}
  verwenden, diesen ebenfalls auf lokale Event Console umstellen.

- In den [Settings]{.guihint} der Event Console den [Access to event
  status via TCP]{.guihint} wieder auf [no access via TCP]{.guihint}
  zurückschalten.
:::
:::::::

::::::::: sect2
### []{#_nagvis .hidden-anchor .sr-only}2.8. NagVis {#heading__nagvis}

:::: {.imageblock .inline-image}
::: content
![nagvis](../images/nagvis.png){width="170"}
:::
::::

::: paragraph
Das Open Source Programm
[NagVis](https://www.nagvis.org){target="_blank"} visualisiert
Statusdaten aus dem Monitoring auf selbst erstellten Landkarten,
Diagrammen und anderen Skizzen. NagVis ist in Checkmk integriert und
kann sofort genutzt werden. Am einfachsten geht der Zugriff über das
[Seitenleistenelement](user_interface.html#sidebar) [NagVis
Maps]{.guihint}. Die Integration von NagVis in Checkmk beschreibt ein
[eigener Artikel](nagvis.html).
:::

::: paragraph
NagVis unterstützt ein verteiltes Monitoring via Livestatus in ziemlich
genau der gleichen Weise, wie es auch Checkmk macht. Die Anbindungen der
einzelnen Instanzen nennt man [Backends]{.guihint} (Deutsch:
[Datenquellen]{.guihint}). Die Backends werden von Checkmk automatisch
korrekt angelegt, so dass Sie sofort damit loslegen können,
NagVis-Karten zu erstellen --- auch im verteilten Monitoring.
:::

::: paragraph
Wählen Sie bei jedem Objekt, das Sie auf einer Karte platzieren, das
richtige Backend aus --- also die Checkmk-Instanz, von der aus das
Objekt überwacht wird. NagVis kann den Host oder Service nicht
automatisch finden, vor allem aus Gründen der Performance. Wenn Sie also
Hosts zu einer anderen Remote-Instanz verschieben, müssen Sie danach
Ihre NagVis-Karten entsprechend anpassen.
:::

::: paragraph
Einzelheiten zu den Backends finden Sie in der Dokumentation von
[NagVis.](http://docs.nagvis.org/1.9/de_DE/backends.html){target="_blank"}
:::
:::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#wan .hidden-anchor .sr-only}3. Instabile oder langsame Verbindungen {#heading_wan}

:::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Die gemeinsame Statusansicht in der Benutzeroberfläche erfordert einen
ständig verfügbaren und zuverlässigen Zugriff auf alle angebundenen
Instanzen. Eine Schwierigkeit dabei ist, dass eine Ansicht immer erst
dann dargestellt werden kann, wenn *alle* Instanzen geantwortet haben.
Der Ablauf ist immer so, dass an alle Instanzen eine Livestatus-Anfrage
gesendet wird (z.B. „Gib mir alle Services, deren Zustand nicht
[OK]{.state0} ist.\"). Erst wenn die letzte Instanz geantwortet hat,
kann die Ansicht dargestellt werden.
:::

::: paragraph
Ärgerlich wird es, wenn eine Instanz gar nicht antwortet. Um kurze
Ausfälle zu tolerieren (z.B. durch einen Neustart einer Instanz oder
verlorengegangene TCP-Pakete), wartet die GUI einen gewissen Timeout ab,
bevor eine Instanz als [![icon status label
dead](../images/icons/icon_status_label_dead.png){width="70px"}]{.image-inline}
deklariert wird und mit den Antworten der übrigen Instanzen fortgefahren
wird. Das führt dann zu einer „hängenden" GUI. Der Timeout ist per
Default auf 10 Sekunden eingestellt.
:::

::: paragraph
Wenn das in Ihrem Netzwerk gelegentlich passiert, sollten Sie entweder
Status-Hosts oder (besser) den Livestatus-Proxy einrichten.
:::

::::::::::: sect2
### []{#_status_hosts .hidden-anchor .sr-only}3.1. Status-Hosts {#heading__status_hosts}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Die Konfiguration
von *Status-Hosts* ist der bei
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** empfohlene Weg, defekte Verbindungen zuverlässig zu
erkennen. Die Idee dazu ist einfach: Die Zentrale überwacht aktiv die
Verbindung zu jeder einzelnen entfernten Instanz. Immerhin haben wir ein
Monitoring-System zur Verfügung! Die GUI kennt dann nicht erreichbare
Instanzen und kann diese sofort ausklammern und als [![icon status label
down](../images/icons/icon_status_label_down.png){width="70px"}]{.image-inline}
werten. Timeouts werden so vermieden.
:::

::: paragraph
So richten Sie für eine Verbindung einen Status-Host ein:
:::

::: {.olist .arabic}
1.  Nehmen Sie den Host, auf dem die Remote-Instanz läuft, auf der
    Zentralinstanz ins Monitoring auf.

2.  Tragen Sie diesen bei der Verbindung zur Remote-Instanz als
    Status-Host ein:
:::

:::: imageblock
::: content
![distributed monitoring status
host](../images/distributed_monitoring_status_host.png)
:::
::::

::: paragraph
Eine ausgefallene Verbindung zur Remote-Instanz kann jetzt nur noch für
kurze Zeit zu einem Hängen der GUI führen --- nämlich solange, bis das
Monitoring das erkannt hat. Durch ein Reduzieren des Prüfintervalls des
Status-Hosts vom Default von 60 Sekunden auf z.B. 5 Sekunden können Sie
dies minimieren.
:::

::: paragraph
Falls Sie einen Status-Host eingerichtet haben, gibt es weitere mögliche
Zustände für Verbindungen:
:::

+-----------------------------------+-----------------------------------+
| [![pill site status               | Der Rechner, auf dem die          |
| unreach](../images                | Remote-Instanz läuft, ist für das |
| /icons/pill_site_status_unreach.p | Monitoring gerade nicht           |
| ng){width="70px"}]{.image-inline} | erreichbar, weil ein Router       |
|                                   | dazwischen down ist (Status-Host  |
|                                   | hat den Zustand                   |
|                                   | [UNREACH]{.hstate2}).             |
+-----------------------------------+-----------------------------------+
| [![pill site status               | Der Status-Host, der die          |
| waiting](../images                | Verbindung zur Remote-Instanz     |
| /icons/pill_site_status_waiting.p | überwacht, wurde noch nicht vom   |
| ng){width="70px"}]{.image-inline} | Monitoring geprüft (steht noch    |
|                                   | auf [PEND]{.statep}).             |
+-----------------------------------+-----------------------------------+
| [![pill site status               | Der Zustand des Status-Hosts hat  |
| unknown](../images                | einen ungültigen Wert (sollte nie |
| /icons/pill_site_status_unknown.p | auftreten).                       |
| ng){width="70px"}]{.image-inline} |                                   |
+-----------------------------------+-----------------------------------+

::: paragraph
In allen drei Fällen wird die Verbindung zu der Instanz ausgeklammert,
wodurch Timeouts vermieden werden.
:::
:::::::::::

::::::::::: sect2
### []{#persistent .hidden-anchor .sr-only}3.2. Persistente Verbindungen {#heading_persistent}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Mit der Checkbox
[Use persistent connections]{.guihint} können Sie die GUI dazu
veranlassen, einmal aufgebaute Livestatus-Verbindungen zu
Remote-Instanzen permanent aufrecht zu erhalten und für weitere Anfragen
wieder zu verwenden. Gerade bei Verbindungen mit einer längeren
Paketlaufzeit (z.B. interkontinentale) kann das die GUI deutlich
reaktiver machen.
:::

::: paragraph
Da die GUI von Apache auf mehrere unabhängige Prozesse aufgeteilt wird,
ist pro gleichzeitig laufendem Apache Client-Prozess eine Verbindung
notwendig. Fall Sie viele gleichzeitige Benutzer haben, sorgen Sie bei
der Konfiguration des Nagios-Kerns der Remote-Instanz für eine
ausreichende Anzahl von Livestatus-Verbindungen. Diese werden in der
Datei `etc/mk-livestatus/nagios.cfg` konfiguriert. Der Default ist 20
(`num_client_threads=20`).
:::

::: paragraph
Per Default ist Apache in Checkmk so konfiguriert, dass er bis zu 128
gleichzeitige Benutzerverbindungen zulässt. Dies wird in der Datei
`etc/apache/apache.conf` in folgendem Abschnitt konfiguriert:
:::

::::: listingblock
::: title
etc/apache/apache.conf
:::

::: content
``` {.pygments .highlight}
<IfModule prefork.c>
StartServers         1
MinSpareServers      1
MaxSpareServers      5
ServerLimit          128
MaxClients           128
MaxRequestsPerChild  4000
</IfModule>
```
:::
:::::

::: paragraph
Das bedeutet, dass unter hoher Last bis zu 128 Apache-Prozesse entstehen
können, welche dann auch bis zu 128 Livestatus-Verbindungen erzeugen und
halten können. Sind die `num_client_threads` nicht entsprechend hoch
eingestellt, kommt es zu Fehlern oder sehr langsamen Antwortzeiten in
der GUI.
:::

::: paragraph
Bei Verbindungen im LAN oder in schnellen WAN-Netzen empfehlen wir, die
persistenten Verbindungen **nicht** zu verwenden.
:::
:::::::::::

:::::::::::::::::::::::::::::::: sect2
### []{#livestatusproxy .hidden-anchor .sr-only}3.3. Der Livestatus-Proxy {#heading_livestatusproxy}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen verfügen mit dem *Livestatus-Proxy* über einen ausgeklügelten
Mechanismus, um tote Verbindungen zu erkennen. Außerdem optimiert er die
Performance vor allem bei Verbindungen mit hohen Round-Trip-Zeiten.
Vorteile des Livestatus-Proxys sind:
:::

::: ulist
- Sehr schnelle proaktive Erkennung von nicht antwortenden Instanzen

- Lokales Zwischenspeichern von Anfragen, die statische Daten liefern

- Stehende TCP-Verbindungen, dadurch weniger Roundtrips notwendig und
  somit viel schnellere Antworten von weit entfernten Instanzen (z.B.
  USA ⇄ China)

- Genaue Kontrolle der maximal nötigen Livestatus-Verbindungen

- Ermöglicht [Hardware/Softwareinventur](inventory.html) in verteilten
  Umgebungen
:::

::::::::::::::: sect3
#### []{#_aufsetzen .hidden-anchor .sr-only}Aufsetzen {#heading__aufsetzen}

::: paragraph
Das Aufsetzen des Livestatus-Proxys ist sehr einfach. In den
kommerziellen Editionen ist dieser per Default aktiviert, wie Sie beim
Starten einer Instanz sehen können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[central]:~$ omd start
Temporary filesystem already mounted
Starting mkeventd...OK
Starting liveproxyd...OK
Starting mknotifyd...OK
Starting rrdcached...OK
Starting cmc...OK
Starting apache...OK
Starting dcd...OK
Starting redis...OK
Starting stunnel...OK
Starting xinetd...OK
Initializing Crontab...OK
```
:::
::::

::: paragraph
Wählen Sie nun bei den Verbindungen zu der Remote-Instanz anstelle von
„Connect via TCP" die Einstellung „[Use Livestatus
Proxy-Daemon]{.guihint}":
:::

:::: imageblock
::: content
![distributed monitoring livestatus proxy
daemon](../images/distributed_monitoring_livestatus_proxy_daemon.png)
:::
::::

::: paragraph
Die Angaben zu Host und Port sind wie gehabt. Auf den Remote-Instanzen
müssen Sie nichts ändern. Bei [Number of channels to keep
open]{.guihint} geben Sie die Anzahl der parallelen TCP-Verbindungen an,
die der Proxy zur Zielseite aufbauen *und aufrechterhalten* soll.
:::

::: paragraph
Der TCP-Verbindungspool wird von allen Anfragen der GUI gemeinsam
genutzt. Die Anzahl der Verbindungen begrenzt die maximale Anzahl von
gleichzeitig in Bearbeitung befindlichen Anfragen. Dies beschränkt
indirekt die Anzahl der Benutzer. In Situationen, in denen alle Kanäle
belegt sind, kommt es nicht sofort zu einem Fehler. Die GUI wartet eine
gewisse Zeit auf einen freien Kanal. Die meisten Anfragen benötigen
nämlich nur wenige Millisekunden.
:::

::: paragraph
Falls die GUI länger als [Timeout waiting for a free channel]{.guihint}
auf so einen Kanal warten muss, wird mit einem Fehler abgebrochen und
der Benutzer sieht eine Fehlermeldung. In so einem Fall sollten Sie die
Anzahl der Verbindungen erhöhen. Beachten Sie dabei jedoch, dass auf der
Gegenstelle (der Remote-Instanz) genügend gleichzeitige eingehende
Verbindungen erlaubt sein müssen. Per Default ist das auf 20
eingestellt. Sie finden diese Einstellung in den globalen Optionen unter
[Monitoring core \> Maximum concurrent Livestatus
connections]{.guihint}.
:::

::: paragraph
Der [Regular heartbeat]{.guihint} sorgt für eine ständige aktive
Überwachung der Verbindungen direkt auf Protokollebene. Dabei sendet der
Proxy regelmäßig eine einfache Livestatus-Anfrage, welche von der
Remote-Instanz in der eingestellten Zeit (Default: 2 Sekunden)
beantwortet sein muss. So werden auch Situationen erkannt, wo der
Zielserver und der TCP-Port zwar erreichbar sind, aber der
Monitoring-Kern nicht mehr antwortet.
:::

::: paragraph
Bleibt die Antwort aus, so werden alle Verbindungen als tot deklariert
und nach einer Cooldown-Zeit (Default: 4 Sekunden) wieder neu aufgebaut.
Das Ganze geschieht proaktiv --- also *ohne*, dass ein Benutzer eine
GUI-Seite abrufen muss. So werden Ausfälle schnell erkannt und bei einer
Wiedergenesung die Verbindungen sofort wieder aufgebaut und stehen dann
im besten Fall schon wieder zur Verfügung, bevor ein Benutzer den
Ausfall mitbekommt.
:::

::: paragraph
Das [Caching]{.guihint} sorgt dafür, dass statische Anfragen nur einmal
von der Remote-Instanz beantwortet werden müssen und ab dem Zeitpunkt
direkt lokal ohne Verzögerung beantwortet werden können. Ein Beispiel
dafür ist die Liste der überwachten Hosts, welche von
[Quicksearch]{.guihint} gebraucht wird.
:::
:::::::::::::::

:::::::::::::::: sect3
#### []{#_fehlerdiagnose .hidden-anchor .sr-only}Fehlerdiagnose {#heading__fehlerdiagnose}

::: paragraph
Der Livestatus-Proxy hat eine eigene Log-Datei, die Sie unter
`var/log/liveproxyd.log` finden. Bei einer korrekt eingerichteten
Remote-Instanz mit fünf Kanälen (Standard), sieht das etwa so aus:
:::

::::: listingblock
::: title
var/log/liveproxyd.log
:::

::: content
``` {.pygments .highlight}
2021-12-01 15:58:30,624 [20] ----------------------------------------------------------
2021-12-01 15:58:30,627 [20] [cmk.liveproxyd] Livestatus Proxy-Daemon (2.0.0p15) starting...
2021-12-01 15:58:30,638 [20] [cmk.liveproxyd] Configured 1 sites
2021-12-01 15:58:36,690 [20] [cmk.liveproxyd.(3236831).Manager] Reload initiated. Checking if configuration changed.
2021-12-01 15:58:36,692 [20] [cmk.liveproxyd.(3236831).Manager] No configuration changes found, continuing.
2021-12-01 16:00:16,989 [20] [cmk.liveproxyd.(3236831).Manager] Reload initiated. Checking if configuration changed.
2021-12-01 16:00:16,993 [20] [cmk.liveproxyd.(3236831).Manager] Found configuration changes, triggering restart.
2021-12-01 16:00:17,000 [20] [cmk.liveproxyd.(3236831).Manager] Restart initiated. Terminating site processes...
2021-12-01 16:00:17,028 [20] [cmk.liveproxyd.(3236831).Manager] Restart master process
```
:::
:::::

::: paragraph
In die Datei `var/log/liveproxyd.state` schreibt der Livestatus-Proxy
regelmäßig seinen Status:
:::

::::: listingblock
::: title
var/log/liveproxyd.state
:::

::: content
``` {.pygments .highlight}
Current state:
[remote1]
  State:                   ready
  State dump time:         2021-12-01 15:01:15 (0:00:00)
  Last reset:              2021-12-01 14:58:49 (0:02:25)
  Site's last reload:      2021-12-01 14:26:00 (0:35:15)
  Last failed connect:     Never
  Last failed error:       None
  Cached responses:        1
  Channels:
       9 - ready             -  client: none - since: 2021-12-01 15:01:00 (0:00:14)
      10 - ready             -  client: none - since: 2021-12-01 15:01:10 (0:00:04)
      11 - ready             -  client: none - since: 2021-12-01 15:00:55 (0:00:19)
      12 - ready             -  client: none - since: 2021-12-01 15:01:05 (0:00:09)
      13 - ready             -  client: none - since: 2021-12-01 15:00:50 (0:00:24)
  Clients:
  Heartbeat:
    heartbeats received: 29
    next in 0.2s
  Inventory:
    State: not running
    Last update: 2021-12-01 14:58:50 (0:02:25)
```
:::
:::::

::: paragraph
Und so sieht der Status aus, wenn eine Instanz gerade gestoppt ist:
:::

::::: listingblock
::: title
var/log/liveproxyd.state
:::

::: content
``` {.pygments .highlight}
----------------------------------------------
Current state:
[remote1]
  State:                   starting
  State dump time:         2021-12-01 16:11:35 (0:00:00)
  Last reset:              2021-12-01 16:11:29 (0:00:06)
  Site's last reload:      2021-12-01 16:11:29 (0:00:06)
  Last failed connect:     2021-12-01 16:11:33 (0:00:01)
  Last failed error:       [Errno 111] Connection refused
  Cached responses:        0
  Channels:
  Clients:
  Heartbeat:
    heartbeats received: 0
    next in -1.0s
  Inventory:
    State: not running
    Last update: 2021-12-01 16:00:45 (0:10:50)
```
:::
:::::

::: paragraph
Der Zustand ist hier `starting`. Der Proxy ist also gerade beim Versuch,
Verbindungen aufzubauen. Channels gibt es noch keine. Während dieses
Zustands werden Anfragen an die Instanz sofort mit einem Fehler
beantwortet.
:::
::::::::::::::::
::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#viewer .hidden-anchor .sr-only}4. Cascading Livestatus {#heading_viewer}

::::::::::::::::: sectionbody
::: paragraph
Wie in der Einleitung bereits erwähnt, ist es möglich, das verteilte
Monitoring um reine Checkmk-Viewer-Instanzen zu erweitern, die die
Monitoring-Daten von Remote-Instanzen anzeigen, die selbst nicht direkt
erreichbar sind. Einzige Voraussetzung dafür: Die Zentralinstanz muss
natürlich erreichbar sein. Technisch wird dies über den Livestatus-Proxy
umgesetzt: Die Zentralinstanz bekommt via Livestatus Daten von der
Remote-Instanz und fungiert selbst als Proxy --- kann die Daten also an
dritte Instanzen durchreichen. Diese Kette können Sie beliebig
erweitern, also zum Beispiel eine zweite Viewer-Instanz an die erste
anbinden.
:::

::: paragraph
Praktisch ist dies beispielsweise für ein Szenario wie folgendes: Die
Zentralinstanz kümmert sich um drei unabhängige Netze *kunde1,* *kunde2*
und *kunde3* und wird selbst im Netz *betreiber1* betrieben. Möchte nun
etwa das Management des Betreibers aus dem Netz *betreiber1* den
Monitoring-Status der Kundeninstanzen sehen, könnte dies natürlich über
einen Zugang auf der Zentralinstanz selbst geregelt werden. Aus
technischen wie rechtlichen Gründen könnte die Zentralinstanz jedoch
ausschließlich den zuständigen Mitarbeitern vorbehalten sein. Über eine
rein zur Ansicht von entfernten Instanzen aufgesetzte Viewer-Instanz
lässt sich der direkte Zugriff umgehen. Die Viewer-Instanz zeigt dann
zwar Hosts und Services verbundener Instanzen, die eigene Konfiguration
bleibt jedoch komplett leer.
:::

::: paragraph
Das Aufsetzen erfolgt in den Verbindungseinstellungen des verteilten
Monitorings, zunächst auf der Zentralinstanz, dann auf der
Viewer-Instanz (welche noch nicht existieren muss).
:::

::: paragraph
Öffnen Sie auf der Zentralinstanz die Verbindungseinstellungen der
gewünschten Remote-Instanz über [Setup \> General \> Distributed
monitoring.]{.guihint} Unter [Use Livestatus Proxy Daemon]{.guihint}
aktivieren Sie die Option [Allow access via TCP]{.guihint} und geben
einen freien Port an (hier `6560`). So verbindet sich der
Livestatus-Proxy der Zentralinstanz mit der Remote-Instanz und öffnet
einen Port für Anfragen der Viewer-Instanz --- welche dann an die
Remote-Instanz weitergeleitet werden.
:::

:::: imageblock
::: content
![Verbindungseinstellungen im verteilten Monitoring mit aktiviertem
TCP-Zugriff für
Viewer-Instanzen.](../images/distributed_livestatus_cascading_master.png)
:::
::::

::: paragraph
Erstellen Sie nun eine Viewer-Instanz und öffnen Sie auch dort wieder
die Verbindungseinstellungen über [Setup \> General \> Distributed
monitoring.]{.guihint} In den [Basic settings]{.guihint} geben
Sie --- wie immer bei Verbindungen im verteilten Monitoring --- als
[Site ID]{.guihint} den exakten Namen der Zentralinstanz an.
:::

:::: imageblock
::: content
![Instanz-ID in den
Verbindungseinstellungen.](../images/distributed_livestatus_cascading_viewer_01.png)
:::
::::

::: paragraph
Im Bereich [Status connection]{.guihint} geben Sie als Host die
Zentralinstanz an --- sowie den manuell vergebenen freien Port (hier
`6560`).
:::

:::: imageblock
::: content
![Verbindungseinstellungen mit Zentralinstanz und freiem Port für
Livestatus.](../images/distributed_livestatus_cascading_viewer_02.png)
:::
::::

::: paragraph
Sobald die Verbindung steht, sehen Sie die gewünschten Hosts und
Services der Remote-Instanz in den Monitoring-Ansichten der
Viewer-Instanz.
:::

::: paragraph
Möchten Sie weiter kaskadieren, müssen Sie auf der Viewer-Instanz, wie
zuvor auf der Zentralinstanz, ebenfalls den TCP-Zugriff auf den
Livestatus-Proxy erlauben, erneut mit einem anderen, freien Port.
:::
:::::::::::::::::
::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#livedump .hidden-anchor .sr-only}5. Livedump und CMCDump {#heading_livedump}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#_motivation .hidden-anchor .sr-only}5.1. Motivation {#heading__motivation}

::: paragraph
Das bisher beschriebene Konzept für ein verteiltes Monitoring mit
Checkmk ist in den meisten Fällen eine gute und einfache Lösung. Es
erfordert allerdings Netzwerkzugriff *von der Zentralinstanz auf die
Remote-Instanzen*. Es gibt Situationen, in denen das entweder nicht
möglich oder nicht gewünscht ist, z.B. weil
:::

::: ulist
- die Instanzen in den Netzen Ihrer Kunden stehen, auf die Sie keinen
  Zugriff haben,

- die Instanzen in einem Sicherheitsbereich stehen, auf den ein Zugriff
  strikt verboten ist oder

- die Instanzen keine permanente Netzwerkverbindung oder keine festen
  IP-Adressen haben und Techniken, wie [Dynamisches
  DNS](https://de.wikipedia.org/wiki/Dynamisches_DNS){target="_blank"}
  keine Option sind.
:::

::: paragraph
Das verteilte Monitoring mit Livedump bzw. CMCDump geht einen ganz
anderen Weg. Zunächst einmal sind die Remote-Instanzen so aufgesetzt,
dass sie völlig unabhängig von der Zentralinstanz arbeiten und
*dezentral administriert* werden. Auf eine verteilte
Konfigurationsumgebung wird verzichtet.
:::

::: paragraph
Dann werden in der Zentralinstanz alle Hosts und Services der
Remote-Instanzen als *Kopie* angelegt. Dazu kann Livedump/CMCDump einen
Abzug der Konfiguration der Remote-Instanzen erstellen, der bei der
Zentralinstanz eingespielt wird.
:::

::: paragraph
Während des Monitorings wird nun auf jeder Remote-Instanz einmal pro
definiertem Intervall (z.B. jede Minute) ein Abzug des aktuellen Status
in eine Datei geschrieben. Diese wird auf einem beliebigen Weg auf die
Zentrale übertragen und dort als Statusupdate eingespielt. Für die
Übertragung ist kein bestimmtes Protokoll vorgesehen oder vorbestimmt.
Alle automatisierbaren Übertragungsprotokolle kommen in Frage. Es muss
nicht unbedingt `scp` sein --- auch eine Übertragung per E-Mail ist
denkbar!
:::

::: paragraph
Ein solches Setup weist gegenüber dem „normalen" verteilten Monitoring
folgende Unterschiede auf:
:::

::: ulist
- Die Aktualisierung der Zustände und Messdaten in der Zentrale
  geschieht verzögert.

- Eine Berechnung der Verfügbarkeit wird auf der Zentralinstanz, im
  Vergleich mit der Remote-Instanz, geringfügig abweichende Werte
  ergeben.

- Zustandswechsel, die schneller geschehen als das
  Aktualisierungsintervall, sind für die Zentrale unsichtbar.

- Ist eine Remote-Instanz „tot", so veralten die Zustände auf der
  Zentralinstanz, die Services werden „stale", sind aber immer noch
  sichtbar. Messdaten und Verfügbarkeitsdaten gehen für diesen Zeitraum
  verloren (auf der Remote-Instanz sind sie noch vorhanden).

- Kommandos wie [Schedule downtimes]{.guihint} und [Acknowledge
  problems]{.guihint} auf der Zentralinstanz können *nicht* auf die
  Remote-Instanz übertragen werden.

- Zu keiner Zeit erfolgt ein Zugriff von der Zentralinstanz auf die
  Remote-Instanz.

- Ein Zugriff auf Details der von Logwatch überwachten Log-Dateien ist
  nicht möglich.

- Die Event Console wird von Livedump/CMCDump nicht unterstützt.
:::

::: paragraph
Da kurze Zustandswechsel bedingt durch das gewählte Intervall für die
Zentralinstanz eventuell nicht sichtbar sind, ist eine
[Benachrichtigung](notifications.html) durch die Zentrale nicht ideal.
Wird die Zentrale jedoch als reine *Anzeigeinstanz* verwendet --- z.B.
für einen zentralen Überblick über alle Kunden --- hat die Methode
durchaus ihre Vorteile.
:::

::: paragraph
Livedump/CMCDump kann übrigens ohne Probleme *gleichzeitig* mit dem
verteilten Monitoring über Livestatus verwendet werden. Manche Instanzen
sind dann einfach direkt über Livestatus angebunden --- andere verwenden
Livedump. Dabei kann der Livedump auch in eine der entfernten
Livestatus-Instanzen eingespielt werden.
:::
::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_aufsetzen_von_livedump .hidden-anchor .sr-only}5.2. Aufsetzen von Livedump {#heading__aufsetzen_von_livedump}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Wenn Sie
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** einsetzen (oder die kommerziellen Editionen mit Nagios
als Kern), dann verwenden Sie das Werkzeug `livedump`. Der Name leitet
sich ab von *Livestatus* und *Status-Dump.* `livedump` befindet sich
direkt im Suchpfad und ist daher global als Befehl verfügbar.
:::

::: paragraph
Wir gehen im Folgenden davon aus, dass
:::

::: ulist
- die Remote-Instanz bereits voll eingerichtet ist und fleißig Hosts und
  Services überwacht,

- die Zentralinstanz gestartet ist und läuft und

- auf der Zentrale *mindestens ein Host* lokal überwacht wird (z.B. weil
  sie sich selbst überwacht).
:::

::::::::::::::::::::: sect3
#### []{#_übertragen_der_konfiguration .hidden-anchor .sr-only}Übertragen der Konfiguration {#heading__übertragen_der_konfiguration}

::: paragraph
Als Erstes erzeugen Sie auf der Remote-Instanz einen Abzug der
Konfiguration Ihrer Hosts und Services im Nagios-Konfigurationsformat.
Leiten Sie dazu die Ausgabe von `livedump -TC` in eine Datei um:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ livedump -TC > config-remote1.cfg
```
:::
::::

::: paragraph
Der Anfang der Datei sieht in etwa wie folgt aus:
:::

::::: listingblock
::: title
config-remote1.cfg
:::

::: content
``` {.pygments .highlight}
define host {
    name                    livedump-host
    use                     check_mk_default
    register                0
    active_checks_enabled   0
    passive_checks_enabled  1

}

define service {
    name                    livedump-service
    register                0
    active_checks_enabled   0
    passive_checks_enabled  1
    check_period            0x0

}
```
:::
:::::

::: paragraph
Übertragen Sie die Datei zu der Zentralinstanz (z.B. mit `scp`) und
legen Sie sie dort in das Verzeichnis `~/etc/nagios/conf.d/`. In diesem
erwartet Nagios die Konfiguration für Hosts und Services. Wählen Sie
einen Dateinamen, der auf `.cfg` endet, z.B.
`~/etc/nagios/conf.d/config-remote1.cfg`. Wenn ein SSH-Zugang von der
Remote-Instanz auf die Zentralinstanz möglich ist, geht das z.B. so:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ scp config-remote1.cfg central@myserver.mydomain:etc/nagios/conf.d/
central@myserver.mydomain's password:
config-remote1.cfg                                             100% 8071     7.9KB/s   00:00
```
:::
::::

::: paragraph
Loggen Sie sich jetzt auf der Zentralinstanz ein und aktivieren Sie die
Änderungen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[central]:~$ cmk -R
Generating configuration for core (type nagios)...OK
Validating Nagios configuration...OK
Precompiling host checks...OK
Restarting monitoring core...OK
```
:::
::::

::: paragraph
Nun sollten alle Hosts und Services der Remote-Instanz in der
Zentralinstanz auftauchen --- und zwar im Zustand [PEND]{.statep}, in
dem sie bis auf Weiteres auch bleiben:
:::

:::: imageblock
::: content
![distributed monitoring livedump
pending](../images/distributed_monitoring_livedump_pending.png)
:::
::::

::: paragraph
Hinweise:
:::

::: ulist
- Durch die Option `-T` bei `livedump` erzeugt Livedump
  Template-Definitionen, auf die sich die Konfiguration bezieht. Ohne
  diese kann Nagios nicht gestartet werden. Sie dürfen jedoch *nur
  einmal* vorhanden sein. Falls Sie auch von einer zweiten
  Remote-Instanz eine Konfiguration übertragen, so dürfen Sie die Option
  `-T` dort **nicht** verwenden!

- Der Dump der Konfiguration ist auch auf einem [Checkmk Micro Core
  (CMC)](cmc.html) möglich, das Einspielen benötigt Nagios. Wenn auf
  Ihrer Zentralinstanz der CMC läuft, dann verwenden Sie
  [CMCDump.](#cmcdump)

- Das Abziehen und Übertragen der Konfiguration müssen Sie nach jeder
  Änderung von Hosts oder Services auf der Remote-Instanz wiederholen.
:::
:::::::::::::::::::::

:::::::::::::::::::::::: sect3
#### []{#_übertragung_des_status .hidden-anchor .sr-only}Übertragung des Status {#heading__übertragung_des_status}

::: paragraph
Nachdem die Hosts in der Zentralinstanz sichtbar sind, geht es jetzt an
die (regelmäßige) Übertragung des Monitoring-Status der Remote-Instanz.
Wieder erzeugen Sie mit `livedump` eine Datei, allerdings diesmal ohne
weitere Optionen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ livedump > state
```
:::
::::

::: paragraph
Diese Datei enthält den Zustand aller Hosts und Services in einem
Format, welches Nagios direkt aus dem Check-Ergebnis einlesen kann. Der
Anfang sieht etwa so aus:
:::

::::: listingblock
::: title
state
:::

::: content
``` {.pygments .highlight}
host_name=myhost1900
check_type=1
check_options=0
reschedule_check
latency=0.13
start_time=1615521257.2
finish_time=16175521257.2
return_code=0
output=OK - 10.1.5.44: rta 0.066ms, lost 0%|rta=0.066ms;200.000;500.000;0; pl=0%;80;100;; rtmax=0.242ms;;;; rtmin=0.017ms;;;;
```
:::
:::::

::: paragraph
Übertragen Sie diese Datei auf die Zentralinstanz in das Verzeichnis
`~/tmp/nagios/checkresults`. **Wichtig:** Der Name der Datei muss mit
`c` beginnen und sieben Zeichen lang sein (Nagios-Vorgabe). Mit `scp`
würde das etwa so aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ scp state central@myserver.mydomain:tmp/nagios/checkresults/caabbcc
server@myserver.mydomain's password:
state                                                  100%   12KB  12.5KB/s   00:00
```
:::
::::

::: paragraph
Anschließend erzeugen Sie auf der Zentralinstanz eine leere Datei mit
dem gleichen Namen und der Endung `.ok`. Dadurch weiß Nagios, dass die
Statusdatei komplett übertragen ist und eingelesen werden kann:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[central]:~$ touch tmp/nagios/checkresults/caabbcc.ok
```
:::
::::

::: paragraph
Der Zustand der Hosts/Services der Remote-Instanz wird jetzt auf der
Zentralinstanz sofort aktualisiert:
:::

:::: imageblock
::: content
![distributed monitoring livedump
status](../images/distributed_monitoring_livedump_status.png)
:::
::::

::: paragraph
Das Übertragen des Status muss ab jetzt natürlich regelmäßig vorgenommen
werden. Livedump unterstützt Sie dabei leider nicht und Sie müssen das
selbst (z.B. in einem Skript) umsetzen. In
`~/share/check_mk/doc/treasures/livedump` finden Sie das Skript
`livedump-ssh-recv`, welches Sie einsetzen können, um Livedump-Updates
(auch solche von der Konfiguration) per SSH auf der Zentralinstanz zu
empfangen. Details finden Sie in den Kommentaren im Skript selbst.
:::

::: paragraph
Sie können den Dump von Konfiguration und Status auch durch die Angabe
von Livestatus-Filtern einschränken, z.B. die Hosts auf die Mitglieder
der Host-Gruppe `mygroup`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$: livedump -H "Filter: host_groups >= mygroup" > state
```
:::
::::

::: paragraph
Weitere Hinweise zu Livedump finden Sie in der Datei `README` im
Verzeichnis `~/share/doc/check_mk/treasures/livedump`.
:::
::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::: sect2
### []{#cmcdump .hidden-anchor .sr-only}5.3. Aufsetzen von CMCDump {#heading_cmcdump}

::: paragraph
Was [Livedump](#livedump) für Nagios ist, ist CMCDump für den [Checkmk
Micro Core](cmc.html) --- und damit das Tool der Wahl für die
kommerziellen Editionen. Im Gegensatz zu Livedump kann CMCDump den
*vollständigen* Status von Hosts und Services replizieren (Nagios bietet
hier nicht die notwendigen Schnittstellen).
:::

::: paragraph
Zum Vergleich: Bei Livedump werden folgende Daten übertragen:
:::

::: ulist
- Der aktuelle Zustand, also [PEND]{.statep}, [OK]{.state0},
  [WARN]{.state1}, [CRIT]{.state2}, [UNKNOWN]{.state3}, [UP]{.hstate0},
  [DOWN]{.hstate1} oder [UNREACH]{.hstate2}

- Die Ausgabe des Check-Plugins

- Die Messdaten
:::

::: paragraph
Zusätzlich synchronisiert CMCDump auch noch
:::

::: ulist
- die *lange* Ausgabe des Plugins,

- ob das Objekte gerade [![icon
  flapping](../images/icons/icon_flapping.png)]{.image-inline} unstetig
  ist,

- Zeitpunkt der letzten Check-Ausführung und des letzten Statuswechsels,

- Dauer der Check-Ausführung,

- Latenz der Check-Ausführung,

- die Nummer des aktuellen Check-Versuchs und ob der aktuelle Zustand
  hart oder weich ist,

- [![icon ack](../images/icons/icon_ack.png)]{.image-inline}
  [Quittierung](basics_ackn.html), falls vorhanden und

- ob das Objekt gerade in einer [![icon
  downtime](../images/icons/icon_downtime.png)]{.image-inline}
  [geplanten Wartungszeit](basics_downtimes.html) ist.
:::

::: paragraph
Das Abbild des Monitorings ist hier also viel genauer. Der CMC simuliert
beim Einspielen des Status nicht einfach eine Check-Ausführung, sondern
überträgt mittels einer dafür bestimmten Schnittstelle einen korrekten
Status. Das bedeutet unter anderem, dass Sie in der Zentrale jederzeit
sehen können, ob Probleme quittiert oder Wartungszeiten eingetragen
wurden.
:::

::: paragraph
Das Aufsetzen ist fast identisch wie bei Livedump, allerdings etwas
einfacher, da Sie sich nicht um eventuelle doppelte Templates und
dergleichen kümmern müssen.
:::

::: paragraph
Der Abzug der Konfiguration geschieht mit `cmcdump -C`. Legen Sie diese
Datei auf der Zentralinstanz unterhalb von `etc/check_mk/conf.d/` ab.
Die Endung muss `.mk` heißen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ cmcdump -C > config.mk
OMD[remote1]:~$ scp config.mk central@mycentral.mydomain:etc/check_mk/conf.d/remote1.mk
```
:::
::::

::: paragraph
Aktivieren Sie auf der Zentralinstanz die Konfiguration:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[central]:~$ cmk -O
```
:::
::::

::: paragraph
Wie bei Livedump erscheinen jetzt die Hosts und Services auf der
Zentrale im Zustand [PEND]{.statep}. Allerdings sehen Sie gleich am
Symbol [![icon shadow](../images/icons/icon_shadow.png)]{.image-inline},
dass es sich um *Schattenobjekte* handelt. So können Sie diese von
direkt auf der Zentralinstanz oder einer „normalen" Remote-Instanz
überwachten Objekte unterscheiden:
:::

:::: imageblock
::: content
![distributed monitoring cmcdump
pending](../images/distributed_monitoring_cmcdump_pending.png)
:::
::::

::: paragraph
Das regelmäßige Erzeugen des Status geschieht mit `cmcdump` ohne weitere
Argumente:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ cmcdump > state
OMD[remote1]:~$ scp state central@mycentral.mydomain:tmp/state_remote1
```
:::
::::

::: paragraph
Zum Einspielen des Status auf der Zentralinstanz muss der Inhalt der
Datei mithilfe des Tools `unixcat` in das UNIX-Socket `tmp/run/live`
geschrieben werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[central]:~$ unixcat tmp/run/live < tmp/state_remote1
```
:::
::::

::: paragraph
Falls Sie per SSH einen passwortlosen Zugang von der Remote-Instanz zur
Zentralinstanz haben, können Sie alle drei Befehle zu einem einzigen
zusammenfassen --- wobei nicht mal eine temporäre Datei entsteht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[remote1]:~$ cmcdump | ssh central@mycentral.mydomain "unixcat tmp/run/live"
```
:::
::::

::: paragraph
Es ist wirklich so einfach! Aber wie schon erwähnt, ist `ssh`/`scp`
nicht die einzige Methode, um Dateien zu übertragen und genauso gut
können Sie Konfiguration oder Status per E-Mail oder einem beliebigen
anderen Protokoll übertragen.
:::
:::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#notifications .hidden-anchor .sr-only}6. Benachrichtigungen in verteilten Umgebungen {#heading_notifications}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_zentral_oder_dezentral .hidden-anchor .sr-only}6.1. Zentral oder dezentral {#heading__zentral_oder_dezentral}

::: paragraph
In einer verteilten Umgebung stellt sich die Frage, von welcher Instanz
aus Benachrichtigungen (z.B. E-Mails) verschickt werden sollen: von den
einzelnen entfernten Instanzen oder von der Zentralinstanz aus. Für
beide gibt es Argumente.
:::

::: paragraph
Argumente für den Versand von den Remote-Instanz aus:
:::

::: ulist
- Einfacher einzurichten.

- Benachrichtigungen vor Ort gehen auch dann, wenn die Verbindung zur
  Zentrale nicht verfügbar ist.

- Geht auch mit
  [![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
  **Checkmk Raw**.
:::

::: paragraph
Argumente für den Versand von der Zentralinstanz aus:
:::

::: ulist
- Benachrichtigungen können an einer zentralen Stelle verarbeitet werden
  (z.B. für Weiterleitung in Ticketsystem).

- Remote-Instanzen benötigen kein Setup für E-Mail oder SMS.

- Bei Versand von SMS über Hardware ist diese nur einmal notwendig: auf
  der Zentrale.
:::
::::::::

::::: sect2
### []{#_dezentrale_benachrichtigungen .hidden-anchor .sr-only}6.2. Dezentrale Benachrichtigungen {#heading__dezentrale_benachrichtigungen}

::: paragraph
Für die Einrichtung dezentraler Benachrichtigungen sind keine besonderen
Schritte notwendig, denn dies ist die Standardeinstellung. Jede
Benachrichtigung, die auf einer Remote-Instanz entsteht, durchläuft dort
die Kette der [Kette der
Benachrichtigungsregeln.](notifications.html#rules) Falls Sie eine
verteilte Konfigurationsumgebung einsetzen, sind diese Regeln auf allen
Instanzen gleich. Aus den Regeln resultierende Benachrichtigungen werden
wie üblich zugestellt, indem lokal die entsprechenden
Benachrichtigungsskripte aufgerufen werden.
:::

::: paragraph
Sie müssen lediglich sicherstellen, dass die entsprechenden Dienste auf
den Instanzen korrekt aufgesetzt sind, also z.B. für E-Mail ein
Smarthost eingetragen ist --- also die gleichen Schritte wie beim
Einrichten einer einzelnen Checkmk-Instanz.
:::
:::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_zentrale_benachrichtigungen .hidden-anchor .sr-only}6.3. Zentrale Benachrichtigungen {#heading__zentrale_benachrichtigungen}

::::: sect3
#### []{#_grundlegendes .hidden-anchor .sr-only}Grundlegendes {#heading__grundlegendes}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die kommerziellen
Editionen bieten einen eingebauten Mechanismus für zentralisierte
Benachrichtigungen, welcher pro Remote-Instanz einzeln aktiviert werden
kann. Solche Remote-Instanzen leiten dann alle Benachrichtigungen zur
weiteren Verarbeitung an die Zentralinstanz weiter. Dabei ist die
zentrale Benachrichtigung unabhängig davon, ob Sie Ihr verteiltes
Monitoring auf dem klassischen Weg oder mit [CMCDump](#cmcdump) oder
einer Mischung davon eingerichtet haben. Genau genommen muss der
zentrale Benachrichtigungs-Server nicht mal die Zentralinstanz sein.
Diese Aufgabe kann jede Checkmk-Instanz übernehmen.
:::

::: paragraph
Ist eine Remote-Instanz auf Weiterleitung eingestellt, so werden alle
Benachrichtigungen direkt wie sie vom Kern kommen --- quasi in *Rohform*
(wir sprechen hier auch von den *Rohbenachrichtigungen*) --- an die
Zentralinstanz weitergereicht. Erst dort werden die
Benachrichtigungsregeln ausgewertet, welche entscheiden, wer und wie
überhaupt benachrichtigt werden soll. Die dazu notwendigen
Benachrichtigungsskripte werden auf der Zentralinstanz aufgerufen.
:::
:::::

:::::::::::::::::::::: sect3
#### []{#_einrichten_der_tcp_verbindungen .hidden-anchor .sr-only}Einrichten der TCP-Verbindungen {#heading__einrichten_der_tcp_verbindungen}

::: paragraph
Die Benachrichtigung-Spooler von entfernter und zentraler
(Benachrichtigungs-)Instanz tauschen sich untereinander per TCP aus.
Benachrichtigungen werden von der Remote-Instanz zur Zentralinstanz
gesendet. Die Zentrale quittiert empfangene Benachrichtigungen an die
Remote-Instanz, was verhindert, dass Benachrichtigungen verloren gehen,
selbst wenn die TCP-Verbindung abbrechen sollte.
:::

::: paragraph
Für den *Aufbau* der TCP-Verbindung haben Sie zwei Möglichkeiten:
:::

::: {.olist .arabic}
1.  TCP-Verbindung wird von Zentralinstanz zur Remote-Instanz aufgebaut.
    Hier ist die Remote-Instanz der *TCP-Server*.

2.  TCP-Verbindung wird von Remote-Instanz zur Zentralinstanz aufgebaut.
    Hier ist die Zentralinstanz der *TCP-Server*.
:::

::: paragraph
Somit steht dem Weiterleiten von Benachrichtigungen auch dann nichts im
Wege, wenn aus Netzwerkgründen der Verbindungsaufbau nur in eine
bestimmte Richtung möglich ist. Die TCP-Verbindungen werden vom Spooler
mit einem Heartbeat-Signal überwacht und bei Bedarf sofort neu
aufgebaut --- nicht erst im Falle einer Benachrichtigung.
:::

::: paragraph
Da Remote-Instanz und Zentralinstanz für den Spooler unterschiedliche
globale Einstellungen brauchen, müssen Sie diese für *alle*
Remote-Instanzen [instanzspezifische Einstellungen](#sitespecific)
machen. Die Konfiguration der Zentrale geschieht über die normalen
globalen Einstellungen. Beachten Sie, dass diese automatisch an alle
Remote-Instanzen vererbt wird, für die Sie *keine* spezifischen
Einstellungen definiert haben.
:::

::: paragraph
Betrachten Sie zuerst den Fall, dass die Zentralinstanz die
TCP-Verbindungen zu den Remote-Instanzen aufbauen soll.
:::

::: paragraph
Schritt 1: Editieren Sie **bei der Remote-Instanz** die
instanzspezifische globale Einstellung [Notifications \> Notification
Spooler Configuration]{.guihint} und aktivieren Sie [Accept incoming TCP
connections]{.guihint}. Als TCP-Port wird 6555 vorgeschlagen. Sofern
nichts dagegen spricht, übernehmen Sie diese Einstellung.
:::

:::: imageblock
::: content
![distributed monitoring notification spooler
configuration](../images/distributed_monitoring_notification_spooler_configuration.png)
:::
::::

::: paragraph
Schritt 2: Setzen Sie nun ebenfalls nur **auf der Remote-Instanz** die
Einstellung [Notification Spooling]{.guihint} auf den Wert [Forward to
remote site by notification spooler]{.guihint}.
:::

:::: imageblock
::: content
![distributed monitoring notification
spooling](../images/distributed_monitoring_notification_spooling.png)
:::
::::

::: paragraph
Schritt 3: Auf der **Zentralinstanz** --- also in den normalen globalen
Einstellungen --- richten Sie nun zu der Remote-Instanz (und später dann
auch eventuell zu weiteren Remote-Instanzen) die Verbindungen ein:
:::

:::: imageblock
::: content
![distributed monitoring notification spooler central
configuration](../images/distributed_monitoring_notification_spooler_central_configuration.png)
:::
::::

::: paragraph
Schritt 4: Setzen Sie die globale Einstellung [Notification
Spooling]{.guihint} auf [Asynchronous local delivery by notification
spooler]{.guihint}, damit auch die Meldungen der Zentrale über den
gleichen zentralen Spooler abgewickelt werden.
:::

:::: imageblock
::: content
![distributed monitoring notification spooling
central](../images/distributed_monitoring_notification_spooling_central.png)
:::
::::

::: paragraph
Schritt 5: Aktivieren Sie die Änderungen.
:::
::::::::::::::::::::::

::::: sect3
#### []{#_verbindungsaufbau_von_der_remote_instanz_aus .hidden-anchor .sr-only}Verbindungsaufbau von der Remote-Instanz aus {#heading__verbindungsaufbau_von_der_remote_instanz_aus}

::: paragraph
Soll die TCP-Verbindung von der Remote-Instanz aus aufgebaut werden, so
ist das Vorgehen identisch, bis auf die Tatsache, dass Sie die oben
gezeigten Einstellungen einfach zwischen Zentralinstanz und
Remote-Instanz vertauschen.
:::

::: paragraph
Auch eine Mischung ist möglich. In diesem Fall muss die Zentrale so
aufgesetzt werden, dass sie sowohl auf eingehende Verbindungen lauscht,
als auch Verbindungen zu entfernten Instanzen aufbaut. Für jede
Beziehung zwischen Zentralinstanz und Remote-Instanz darf aber *nur
einer von beiden* die Verbindung aufbauen!
:::
:::::

::::::::::::::::::::::::: sect3
#### []{#_test_und_diagnose .hidden-anchor .sr-only}Test und Diagnose {#heading__test_und_diagnose}

::: paragraph
Der Benachrichtigungs-Spooler loggt in die Datei
`var/log/mknotifyd.log`. In den Spooler-Einstellungen können Sie das
Loglevel erhöhen, so dass Sie mehr Meldungen kommen. Bei einem
Standard-Loglevel sollten Sie auf der Zentralinstanz etwa Folgendes
sehen:
:::

::::: listingblock
::: title
var/log/mknotifyd.log
:::

::: content
``` {.pygments .highlight}
2021-11-17 07:11:40,023 [20] [cmk.mknotifyd] -----------------------------------------------------------------
2021-11-17 07:11:40,023 [20] [cmk.mknotifyd] Check_MK Notification Spooler version 2.0.0p15 starting
2021-11-17 07:11:40,024 [20] [cmk.mknotifyd] Log verbosity: 0
2021-11-17 07:11:40,025 [20] [cmk.mknotifyd] Daemonized with PID 31081.
2021-11-17 07:11:40,029 [20] [cmk.mknotifyd] Connection to 10.1.8.44 port 6555 in progress
2021-11-17 07:11:40,029 [20] [cmk.mknotifyd] Successfully connected to 10.1.8.44:6555
```
:::
:::::

::: paragraph
Die Datei `var/log/mknotifyd.state` enthält stets einen aktuellen
Zustand des Spoolers und aller seiner Verbindungen:
:::

::::: listingblock
::: title
central:var/log/mknotifyd.state (Auszug)
:::

::: content
``` {.pygments .highlight}
Connection:               10.1.8.44:6555
Type:                     outgoing
State:                    established
Status Message:           Successfully connected to 10.1.8.44:6555
Since:                    1637129500 (2021-11-17 07:11:40, 140 sec ago)
Connect Time:             0.002 sec
```
:::
:::::

::: paragraph
Die gleiche Datei gibt es auch auf der Remote-Instanz. Dort sieht die
Verbindung etwa so aus:
:::

::::: listingblock
::: title
remote-1:var/log/mknotifyd.state (Auszug)
:::

::: content
``` {.pygments .highlight}
Connection:               10.22.4.12:56546
Type:                     incoming
State:                    established
Since:                    1637129500 (2021-11-17 07:11:40, 330 sec ago)
```
:::
:::::

::: paragraph
Zum Testen wählen Sie z.B. einen beliebigen Service, der auf der
Remote-Instanz überwacht wird, und setzen diesen per Kommando [Fake
check results]{.guihint} auf [CRIT]{.state2}.
:::

::: paragraph
Auf der *Zentrale* sollen Sie nun in der entsprechenden Log-Datei
(`notify.log`) die eingehenden Benachrichtigung sehen:
:::

::::: listingblock
::: title
central:var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2021-11-17 07:59:36,231 ----------------------------------------------------------------------
2021-11-17 07:59:36,232 [20] [cmk.base.notify] Got spool file 307ad477 (myremotehost123;Check_MK) from remote host for local delivery.
```
:::
:::::

::: paragraph
Das gleiche Ereignis sieht bei der Remote-Instanz so aus:
:::

::::: listingblock
::: title
remote1:var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2021-11-17 07:59:28,161 [20] [cmk.base.notify] ----------------------------------------------------------------------
2021-11-17 07:59:28,161 [20] [cmk.base.notify] Got raw notification (myremotehost123;Check_MK) context with 71 variables
2021-11-17 07:59:28,162 [20] [cmk.base.notify] Creating spoolfile: /omd/sites/remote1/var/check_mk/notify/spool/307ad477-b534-4cc0-99c9-db1c517b31f3
```
:::
:::::

::: paragraph
In den globalen Einstellungen können Sie sowohl die normale Log-Datei
für Benachrichtigungen (`notify.log`) als auch die Log-Datei des
Benachrichtigungs-Spoolers auf ein höheres Loglevel umstellen.
:::
:::::::::::::::::::::::::

:::::: sect3
#### []{#_überwachung_des_spoolings .hidden-anchor .sr-only}Überwachung des Spoolings {#heading__überwachung_des_spoolings}

::: paragraph
Nachdem Sie alles wie beschrieben aufgesetzt haben, werden Sie
feststellen, dass sowohl auf der Zentralinstanz, als auch auf den
Remote-Instanzen jeweils ein neuer Service gefunden wird, den Sie
unbedingt in die Überwachung aufnehmen sollten. Dieser überwacht den
Benachrichtigungs-Spooler und dessen TCP-Verbindungen. Dabei wird jede
Verbindung zweimal überwacht: einmal durch die Zentralinstanz und einmal
durch die Remote-Instanz:
:::

:::: imageblock
::: content
![distributed monitoring notification
services](../images/distributed_monitoring_notification_services.png)
:::
::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#mixed_versions .hidden-anchor .sr-only}7. Versionsunterschiede zwischen Zentralinstanz und Remote-Instanzen {#heading_mixed_versions}

::::::::::: sectionbody
::: paragraph
Grundsätzlich müssen die Versionen aller Remote-Instanzen und der
Zentralinstanz übereinstimmen. Ausnahmen gelten lediglich während der
Durchführung von [Updates](update.html). Hier ist zwischen folgenden
Fällen zu unterscheiden:
:::

::::: sect2
### []{#_abweichende_patchlevel_gleiche_major_version .hidden-anchor .sr-only}7.1. Abweichende Patchlevel (gleiche Major-Version) {#heading__abweichende_patchlevel_gleiche_major_version}

::: paragraph
Die Patchlevel (z.B. p11) dürfen in den meisten Fällen unterschiedlich
sein. In seltenen Fällen sind aber auch diese untereinander
inkompatibel, so dass Sie den exakten Versionsstand (z.B.
[2.0.0]{.new}p11) auf allen Seiten einhalten müssen, damit eine
fehlerfreie Zusammenarbeit der Instanzen möglich ist. Beachten Sie daher
immer die inkompatiblen Änderungen zu jeder Patchversion in den
[Werks.](https://checkmk.com/de/werks){target="_blank"}
:::

::: paragraph
Im Regelfall --- Ausnahmen sind möglich und werden in den Werks
angegeben --- aktualisieren Sie zunächst die Remote-Instanzen und als
letztes die Zentralinstanz.
:::
:::::

:::::: sect2
### []{#_abweichende_major_versionen .hidden-anchor .sr-only}7.2. Abweichende Major-Versionen {#heading__abweichende_major_versionen}

::: paragraph
Für die reibungslose Durchführung von [Major-Updates](update_major.html)
(beispielsweise von [2.1.0]{.new} auf [2.2.0]{.new}) in großen
verteilten Umgebungen erlaubt Checkmk seit [2.0.0]{.new} einen
Mischbetrieb, bei dem die Differenz genau eine Major-Version sein darf.
Dabei ist darauf zu achten, dass Sie die Remote-Instanzen zuerst
aktualisieren. Die Zentralinstanz aktualisieren Sie erst, wenn alle
Remote-Instanzen auf dem höheren Versionsstand sind.
:::

::: paragraph
Auch hier gilt: Prüfen Sie unbedingt die Werks sowie die Hinweise zum
Versions-Update, *bevor* Sie mit dem Update beginnen! Es ist immer ein
bestimmtes Patchlevel der älteren Version auf der Zentralinstanz
erforderlich, um einen reibungslosen Mischbetrieb zu gewährleisten.
:::

::: paragraph
Eine Besonderheit im Mischbetrieb ist die zentrale Verwaltung von
Erweiterungspaketen, welche nun in Varianten für sowohl die ältere, als
auch die neuere Checkmk-Version vorgehalten werden können. Details
erklärt der Artikel zur Verwaltung von [MKPs](mkps.html).
:::
::::::
:::::::::::
::::::::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}8. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: sect2
### []{#_konfigurationsdateien .hidden-anchor .sr-only}8.1. Konfigurationsdateien {#heading__konfigurationsdateien}

+------------------------------+---------------------------------------+
| Pfad                         | Bedeutung                             |
+==============================+=======================================+
| `~/etc/ch                    | Hier speichert Checkmk die            |
| eck_mk/multisite.d/sites.mk` | Konfiguration der Verbindungen zu den |
|                              | einzelnen Instanzen. Sollte aufgrund  |
|                              | von Fehlkonfiguration die Oberfläche  |
|                              | so „hängen", dass sie nicht mehr      |
|                              | bedienbar ist, können Sie die         |
|                              | störenden Einträge direkt in dieser   |
|                              | Datei editieren. Falls der            |
|                              | Livestatus-Proxy zum Einsatz kommt,   |
|                              | ist anschließend jedoch ein Editieren |
|                              | und Speichern mindestens einer        |
|                              | Verbindung notwendig, da erst hierbei |
|                              | für diesen Daemon eine passende       |
|                              | Konfiguration erzeugt wird.           |
+------------------------------+---------------------------------------+
| `~                           | Konfiguration für den                 |
| /etc/check_mk/liveproxyd.mk` | Livestatus-Proxy. Diese Datei wird    |
|                              | von Checkmk bei jeder Änderung an der |
|                              | Konfiguration des verteilten          |
|                              | Monitorings neu generiert.            |
+------------------------------+---------------------------------------+
| `~/etc/check_mk              | Konfiguration für den                 |
| /mknotifyd.d/wato/global.mk` | Benachrichtigungs-Spooler. Diese      |
|                              | Datei wird von Checkmk beim Speichern |
|                              | der globalen Einstellungen erzeugt.   |
+------------------------------+---------------------------------------+
| `~/etc/check_mk              | Wird auf den Remote-Instanzen erzeugt |
| /conf.d/distributed_wato.mk` | und sorgt dafür, dass diese nur ihre  |
|                              | eigenen Hosts überwachen.             |
+------------------------------+---------------------------------------+
| `~/etc/nagios/conf.d/`       | Ablageort für selbst erstellte        |
|                              | Nagios-Konfigurationsdateien mit      |
|                              | Hosts und Services. Dies wird beim    |
|                              | Einsatz von [Livedump](#livedump) auf |
|                              | der Zentralinstanz benötigt.          |
+------------------------------+---------------------------------------+
| `~/e                         | Konfiguration von Livestatus bei      |
| tc/mk-livestatus/nagios.cfg` | Verwendung von Nagios als Kern. Hier  |
|                              | können Sie die maximale gleichzeitige |
|                              | Anzahl von Verbindungen               |
|                              | konfigurieren.                        |
+------------------------------+---------------------------------------+
| `~/etc/check_mk/conf.d/`     | Konfiguration von Hosts und Regeln    |
|                              | für Checkmk. Legen Sie hier           |
|                              | Konfigurationsdateien ab, die per     |
|                              | [CMCDump](#cmcdump) erzeugt wurden.   |
|                              | Nur das Unterverzeichnis `wato/` wird |
|                              | in der Konfigurationsumgebung         |
|                              | verwaltet und ist dort sichtbar.      |
+------------------------------+---------------------------------------+
| `~/var/check_mk/autochecks/` | Von der Serviceerkennung gefundene    |
|                              | Services. Dieses werden immer lokal   |
|                              | auf der Remote-Instanz gespeichert.   |
+------------------------------+---------------------------------------+
| `~/var/check_mk/rrds/`       | Ablage der Round-Robin-Datenbanken    |
|                              | für die Archivierung der Messwerte    |
|                              | beim Einsatz des Checkmk-RRD-Formats  |
|                              | (Default bei den kommerziellen        |
|                              | Editionen).                           |
+------------------------------+---------------------------------------+
| `~/var/pnp4nagios/perfdata/` | Ablage der Round-Robin-Datenbanken    |
|                              | bei PNP4Nagios-Format (Checkmk Raw).  |
+------------------------------+---------------------------------------+
| `~/var/log/liveproxyd.log`   | Log-Datei des Livestatus-Proxys.      |
+------------------------------+---------------------------------------+
| `~/var/log/liveproxyd.state` | Aktueller Zustand des                 |
|                              | Livestatus-Proxys in lesbarer Form.   |
|                              | Diese Datei wird alle fünf Sekunden   |
|                              | aktualisiert.                         |
+------------------------------+---------------------------------------+
| `~/var/log/notify.log`       | Log-Datei des                         |
|                              | Checkmk-Benachrichtigungssystems.     |
+------------------------------+---------------------------------------+
| `~/var/log/mknotifyd.log`    | Log-Datei des                         |
|                              | Benachrichtigungs-Spoolers.           |
+------------------------------+---------------------------------------+
| `~/var/log/mknotifyd.state`  | Aktueller Zustand des                 |
|                              | Benachrichtigungs-Spoolers in         |
|                              | lesbarer Form. Diese Datei wird alle  |
|                              | 20 Sekunden aktualisiert.             |
+------------------------------+---------------------------------------+
:::
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
