:::: {#header}
# Update auf Version 2.3.0

::: details
[Last modified on 08-Jul-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/update_major.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Updates und Upgrades](update.html) [Grundsätzliches zur Installation
von Checkmk](install_packages.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::: sectionbody
::: paragraph
In diesem Artikel finden Sie die wichtigsten Themen, die für das Update
Ihrer Checkmk-Version [2.2.0]{.new} auf [2.3.0]{.new} relevant sind.
:::

::: paragraph
Wir empfehlen Ihnen, vor dem Update den kompletten Artikel durchzulesen,
damit Sie genau wissen, was auf Sie zukommt: vor, während und nach dem
Update.
:::
:::::
::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#prep .hidden-anchor .sr-only}2. Vorbereitungen {#heading_prep}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
In diesem Kapitel erhalten Sie die Übersicht der Themen, um die Sie sich
kümmern sollten, bevor Sie das Update durchführen. Wahrscheinlich wird
nicht jedes der Themen für Sie relevant sein: Bei einem solchen können
Sie intern einen Haken setzen und sich gleich das nächste Thema
vornehmen.
:::

:::::::: sect2
### []{#backup .hidden-anchor .sr-only}2.1. Backup {#heading_backup}

::: paragraph
Wie vor jedem Update einer produktiven Software sollten Sie auch vor dem
von Checkmk die Aktualität Ihrer Backups prüfen.
:::

::: paragraph
**Betrifft Sie das?** Ja.
:::

::: paragraph
**Was müssen Sie tun?** Wenn Sie Ihre Backups automatisiert über [Setup
\> Maintenance \> Backups]{.guihint} erstellen, prüfen Sie dort, ob die
letzten Backup-Aufträge fehlerfrei durchgelaufen sind.
:::

::: paragraph
Weitere Informationen finden Sie in den Artikeln zu
[Backups](backup.html) und zum Thema [Instanzen sichern und
wiederherstellen.](omd_basics.html#omd_backup_restore)
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Ab dem Update auf [2.3.0]{.new}   |
|                                   | werden Änderungen bei einem       |
|                                   | fehlgeschlagenen Update           |
|                                   | zurückgerollt ([Werk              |
|                                   | #16408](https://checkmk.com/      |
|                                   | de/werk/16408){target="_blank"}). |
|                                   | Fehlschlagen kann ein Update      |
|                                   | durch einen unerwarteten internen |
|                                   | Fehler, aber auch durch           |
|                                   | Benutzereingabe während des       |
|                                   | Update-Prozesses, zum Beispiel    |
|                                   | durch Auswahl der Menüoption      |
|                                   | `abort` oder durch Drücken der    |
|                                   | Tastenkombination `CTRL+C`. Erst, |
|                                   | wenn der Text                     |
|                                   | `Completed verifying              |
|                                   | site configuration. Your site now |
|                                   |  has version `[`2.3.0`]{.new}`pX` |
|                                   | angezeigt wird, ist die           |
|                                   | aktualisierte Konfiguration       |
|                                   | aktiv. Die Wiederherstellung der  |
|                                   | Konfiguration ersetzt kein        |
|                                   | Backup, reduziert aber meist die  |
|                                   | Ausfallzeit, wenn etwas schief    |
|                                   | läuft.                            |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::

:::::: sect2
### []{#performance .hidden-anchor .sr-only}2.2. Hardware-Auslastung überprüfen {#heading_performance}

::: paragraph
Checkmk [2.3.0]{.new} erfordert etwas höhere Systemressourcen als
[2.2.0]{.new}. Daher ist es ratsam, vor dem Update zu ermitteln, welche
freien Kapazitäten für Checkmk verwendete Server noch haben.
:::

::: paragraph
**Betrifft Sie das?** Ja. Allerdings hängt es stark von der Art der
Nutzung von Checkmk ab, wie stark sie betroffen sind. Alleine das Update
des Python-Interpreters von Version 3.11 auf 3.12 verursacht eine
Lastzunahme im einstelligen Prozentbereich. Des weiteren können
umfangreichere Checks gerade im Cloud-Bereich je nach Anteil an der
Gesamtmenge der Checks für weitere Mehrlast sorgen, so dass insgesamt
10--15 % (in Extremfällen um 20 %) mehr CPU-Last zu erwarten sind.
:::

::: paragraph
**Was müssen Sie tun?** Stellen Sie sicher, dass genügend freie
Kapazitäten vorhanden sind. Als Faustregel gilt: Liegt die *CPU load*
unter *Zahl der Prozessorkerne × 0,8* und die CPU utilization unter
70 %, sind keine Probleme zu erwarten. Liegt einer der beiden Werte oder
beide höher, schaffen Sie genügend freie Kapazitäten, beispielsweise
indem Sie Test-Instanzen auf demselben Server deaktivieren oder Hosts
auf andere Instanzen verschieben.
:::
::::::

:::::::: sect2
### []{#linux_versions .hidden-anchor .sr-only}2.3. Linux-Distributionsversionen {#heading_linux_versions}

::: paragraph
In der Checkmk Version [2.3.0]{.new} werden einige veraltete
Distributionen nicht mehr unterstützt werden.
:::

::: paragraph
**Betrifft Sie das?** Das betrifft Sie, wenn auf Ihrem Checkmk-Server
eine der folgenden -- in der [2.2.0]{.new} noch unterstützten --
Linux-Distributionen installiert ist:
:::

::: ulist
- RedHat Enterprise Linux 7

- Ubuntu in Short Term Support (STS) Versionen 22.10 bis 23.10.\
  Ab [2.3.0]{.new} unterstützt Checkmk nur noch Ubuntu Long Term Support
  (LTS) Versionen.

- SLES 15 SP1 und SP2
:::

::: paragraph
**Was müssen Sie tun?** Führen Sie vor dem Update von Checkmk zuerst ein
[Versions-Upgrade der Linux-Distribution](release_upgrade.html) durch.
Achten Sie darauf, dass die Zielversion der Linux-Distribution von
Checkmk [2.2.0]{.new} **und** [2.3.0]{.new} unterstützt wird. Welche
Linux-Distributionsversionen Checkmk unterstützt, erfahren Sie in der
[Update-Matrix für [2.3.0]{.new}](update_matrix.html) und auf der
[Download-Seite](https://checkmk.com/de/download){target="_blank"}
nachdem Sie die Checkmk-Version und Ihre Linux-Distribution ausgewählt
haben.
:::

::: paragraph
Kurz nach Erscheinen von Ubuntu 24.04 LTS werden wir Pakete von Checkmk
[2.2.0]{.new} und [2.3.0]{.new} für diese Distributionsversion
bereitstellen. Dies erlaubt es Ihnen, zunächst auf die neueste
Patch-Version von Checkmk [2.2.0]{.new} zu aktualisieren, dann das
Update von Ubuntu 23.10 STS nach 24.04 LTS durchzuführen und hier
schließlich auf die neueste Patch-Version von Checkmk [2.3.0]{.new} zu
aktualisieren.
:::
::::::::

:::::: sect2
### []{#sles_php .hidden-anchor .sr-only}2.4. PHP auf SLES 15 SP3/SP4 {#heading_sles_php}

::: paragraph
Mit Checkmk Version [2.3.0]{.new} (und [2.2.0]{.new}p21) wird unter SUSE
Linux Enterprise Server 15 Service Pack 3 und 4 die Abhängigkeit zur
Laufzeitumgebung der Programmiersprache PHP von Version 7 auf Version 8
angehoben.
:::

::: paragraph
**Betrifft Sie das?** Ja, als Nutzer von SLES 15 SP3/SP4. Das Update ist
etwas aufwendiger, da Paketquellen für die veraltete Version 7
deaktiviert und für die neue Version 8 aktiviert werden müssen.
:::

::: paragraph
**Was müssen Sie tun?** Falls Sie neben Checkmk Anwendungen auf Ihrem
Server nutzen, welche die Programmiersprache PHP verwenden, stellen Sie
vorbereitend sicher, dass diese problemlos mit PHP 8 zurecht kommen.
Bereiten Sie dann das bereits für das Update auf [2.2.0]{.new}p21 (oder
höher), welches für die Installation von Checkmk [2.3.0]{.new}
obligatorisch ist, die Änderung der Paketquellen vor, wie sie in [Werk
#16025](https://checkmk.com/de/werk/16025){target="_blank"} beschrieben
wird.
:::
::::::

:::::: sect2
### []{#browser .hidden-anchor .sr-only}2.5. Browser-Unterstützung {#heading_browser}

::: paragraph
Checkmk [2.3.0]{.new} nutzt neue JavaScript-Funktionen, die in älteren
Browsern nicht zur Verfügung stehen. Welche Browser in welchen Versionen
unterstützt werden, steht in den [Release
notes.](release_notes.html#browser)
:::

::: paragraph
**Betrifft Sie das?** In der Regel werden Sie auf Desktop-Systemen
automatische Updates auf die neueste Version aktiviert haben.
:::

::: paragraph
**Was müssen Sie tun?** Prüfen Sie die verwendete Browser-Version und
installieren Sie gegebenenfalls einen aktuelleren Browser. Wenn Sie für
die Anzeige von Dashboards *Single Board Computer*, *Smart TVs* oder
*Digital Signage* Lösungen verwenden, auf deren Systembrowser Sie keinen
Einfluss haben, testen Sie vor dem Update, ob benötigte Dashboards
korrekt angezeigt werden. Kontaktieren Sie gegebenenfalls den
Hardware-Hersteller für Updates.
:::
::::::

::::::: sect2
### []{#openssl .hidden-anchor .sr-only}2.6. SSL-Kompatibilität {#heading_openssl}

::: paragraph
Checkmk [2.3.0]{.new} liefert erstmals OpenSSL in Version 3.0 statt
bisher 1.1 mit. Diese Änderung hat Auswirkungen auf fast alle
Komponenten, welche *Secure Socket Layer* oder *Transport Level
Security* nutzen.
:::

::: paragraph
**Betrifft Sie das?** Da OpenSSL 3 mittlerweile eine weite Verbreitung
erlangt hat, sind kaum Überraschungen zu erwarten. Zu Problemen -- vor
allem bei aktiven Checks -- kann es kommen, wenn Verbindungen zu Geräten
hergestellt werden sollen, die alte *Ciphers* erwarten oder
*Renegotiation* versuchen. Meist handelt es sich um alte Netzwerkgeräte
(Switches, Drucker...​), die keine Updates mehr erhalten. In einigen
Fällen sind ältere Dienste auf Linux-Distributionen oder Unix-Versionen
betroffen, die immer noch mit Updates versorgt werden.
:::

::: paragraph
**Was müssen Sie tun?** Versuchen Sie möglichst im Vorfeld, Geräte
ausfindig zu machen, bei denen Probleme zu erwarten sind. Gute
Indikatoren hierfür sind Alter und wie lange Updates zurück liegen.
Testen Sie diese Geräte mit Checkmk [2.3.0]{.new}. Treten Probleme auf,
haben Sie zwei Möglichkeiten:
:::

::: {.olist .arabic}
1.  Prüfen Sie, ob Updates oder Konfigurationsänderungen möglich sind.
    Gerade ältere, aber noch unterstützte Betriebssysteme erlauben oft,
    ältere Default-Einstellungen mit sichereren modernen Einstellungen
    zu überschreiben.

2.  Ist dies nicht möglich, können die betroffenen aktiven Checks über
    die Regel [Integrate Nagios plugins]{.guihint} manuell für andere
    Default-Einstellungen konfiguriert werden. Eine detaillierte
    Anleitung bereiten wir gerade vor. Bei Bedarf können Sie eine
    Vorabversion per Help Desk Beta oder im Forum anfragen.
:::
:::::::

:::::::: sect2
### []{#cme .hidden-anchor .sr-only}2.7. Checkmk MSP basiert auf Checkmk Cloud {#heading_cme}

::: paragraph
Mit Checkmk [2.3.0]{.new} wechselt Checkmk MSP die Basis von Checkmk
Enterprise zu Checkmk Cloud. Dies bedeutet nicht nur, dass Checkmk MSP
den erweiterten Funktionsumfang von Checkmk Cloud erhält, sondern auch,
dass das Lizenzmanagement an das von Checkmk Cloud angeglichen wird.
:::

::: paragraph
**Betrifft Sie das?** Dies betrifft nur Benutzer von Checkmk MSP, andere
Formen des verteilten Monitorings sind nicht betroffen.
:::

::: paragraph
**Was müssen Sie tun?** Das Update von Checkmk MSP auf [2.3.0]{.new}
folgt der generellen [Prozedur in verteilten Umgebungen mit verteiltem
Setup.](#update_distributed_monitoring) Allerdings muss sichergestellt
sein, das die Zentralinstanz noch unter Checkmk [2.2.0]{.new} die
Lizenzinformationen an bereits auf Checkmk [2.3.0]{.new} aktualisierte
Remote-Instanzen übertragen kann.
:::

::: paragraph
Da die notwendigen Änderungen erst in Checkmk [2.2.0]{.new}p17 ([Werk
#16193](https://checkmk.com/de/werk/16193){target="_blank"})
implementiert sind, müssen Sie folglich die Zentralinstanz mindestens
auf diese Version aktualisieren. Damit ist die Übertragung der
[Lizenzinformationen](license.html#license_cce) sichergestellt.
Anschließend können die Remote-Instanzen auf [2.3.0]{.new} aktualisiert
werden und abschließend die Zentralinstanz.
:::

::: paragraph
Unabhängig von der hier genannten Mindestanforderung an die
[2.2.0]{.new}p17 empfehlen wir, auf allen beteiligten Instanzen zuerst
das Update auf die letzte verfügbare Patch-Version der [2.2.0]{.new}
durchzuführen und erst dann mit dem Update auf [2.3.0]{.new} zu
beginnen.
:::
::::::::

:::::: sect2
### []{#agentupdaterhash .hidden-anchor .sr-only}2.8. Automatische Agenten-Updates von Versionen vor [2.2.0]{.new}p8 {#heading_agentupdaterhash}

::: paragraph
Checkmk [2.3.0]{.new} erstellt keine SHA1-Signaturen für Agentenpakete
mehr. Die Prüfung von SHA256-Signaturen wurde mit Checkmk
[2.2.0]{.new}p8 eingeführt. Damit Agenten-Updates auf Version
[2.3.0]{.new} automatisch stattfinden können, müssen die Agenten vorher
auf Version [2.2.0]{.new}p8 oder höher aktualisiert werden.
:::

::: paragraph
**Betrifft Sie das?** Dies betrifft Sie, wenn Sie automatische
Agenten-Updates durchführen, aber Patch-Versionen des Agenten
gelegentlich auslassen. Es betrifft Sie außerdem, wenn Ihr Deployment
vorbereitete Betriebssystem-Images verwendet, die den Checkmk Agent
Updater mit ausliefern und sich auf automatische
[Installation/Aktualisierung](agent_deployment.html#automatic_installer)
verlassen.
:::

::: paragraph
**Was müssen Sie tun?** Stellen Sie sicher, dass alle Agenten, die
automatisch aktualisiert werden sollen, mindestens auf Version
[2.2.0]{.new}p8 aktualisiert wurden. Überprüfen Sie insbesondere
vorbereitete Betriebssystem-Images und aktualisieren Sie den dort
vorhandenen Agenten ebenfalls auf Version [2.2.0]{.new}p8 oder höher.
Und wenn Sie gerade mit Agenten-Updates beschäftigt sind, können Sie
bereits jetzt das per Agentenbäckerei ausgelieferte [Zertifikat
hinzufügen,](#agentupdatercert), sofern dieses später nötig ist.
:::
::::::

:::: sect2
### []{#agentwindows .hidden-anchor .sr-only}2.9. Der Windows-Agent: Deprecated Plugins {#heading_agentwindows}

::: paragraph
Einige Plugins, die als *deprecated* markiert waren, wurden entfernt und
erfordern gegebenenfalls manuelle Installation, falls diese noch
benötigt werden. Details erläutert [Werk
#16359](https://checkmk.com/de/werk/16359){target="_blank"}.
:::
::::

:::::: sect2
### []{#pythonwindows .hidden-anchor .sr-only}2.10. Der Windows-Agent: Python 3.4 entfernt {#heading_pythonwindows}

::: paragraph
Der offizielle Support für den Checkmk-Agenten unter Windows Server 2008
und Windows 7 durch die Checkmk GmbH endete bereits mit der
Veröffentlichung von Checkmk [2.2.0]{.new}. Dennoch war der Betrieb
unter Windows Server 2008 R2 und Windows 7 ohne Einschränkungen weiter
möglich. Mit [2.3.0]{.new} sind Einschränkungen in Kauf zu nehmen: Die
bisherige Möglichkeit, per Regel der Agentenbäckerei eine Python 3.4
Laufzeitumgebung für Windows-Agenten mitzuliefern fällt in [2.3.0]{.new}
weg.
:::

::: paragraph
**Betrifft Sie das?** Hoffentlich nicht: Der Wegfall betrifft Sie nur,
wenn Sie in Python geschriebene
[Agentenplugins](glossar.html#agent_plugin) auf Windows Server 2008 R2
oder Windows 7 (beide End of Life bereits in 2020) nutzen. Auf allen
neueren Windows-Versionen laufen aktuelle Python-Versionen. Auf allen
noch älteren Windows-Versionen -- wie Windows Server 2008 R1 oder
Windows Vista -- konnte der Agent bereits in Version [2.2.0]{.new} nicht
mehr benutzt werden.
:::

::: paragraph
**Was müssen Sie tun?** Wenn Sie diese Windows-Systeme weiterhin
überwachen wollen, müssen Sie Laufzeitumgebung für Agentenplugins, die
Python benötigen, selbst bereitstellen: Installieren Sie auf betroffenen
Systemen Python 3.4 manuell. Stellen Sie für diese Systeme in der Regel
[Setup \> Agents \> Windows, Linux, Solaris, AIX \> Agent rules \>
Windows modules \> Install Python runtime environment]{.guihint} die
Einstellung [Install Python runtime environment \>
Installation]{.guihint} auf [Never install Python with the
agent]{.guihint}. Beachten Sie, dass wir für derart alte Windows-Systeme
keinen Support garantieren können und neue Agentenversionen in
Patch-Releases nicht mehr testen.
:::
::::::

:::::::::: sect2
### []{#mod_auth_mellon .hidden-anchor .sr-only}2.11. Checkmk ohne Apache-Modul mod_auth_mellon {#heading_mod_auth_mellon}

::: paragraph
[`mod_auth_mellon`](https://github.com/latchset/mod_auth_mellon){target="_blank"}
ist ein Software-Modul für Apache, das Dienste zur Authentifizierung
(*authentication*) über Secure Assertion Markup Language (SAML)
bereitstellt. Die Anbindung an SAML-Authentifizierungsdienste war in
Checkmk [2.2.0]{.new} auf zwei Arten möglich: Auf Apache-Ebene mit
`mod_auth_mellon` (bis Version [2.1.0]{.new} die einzig unterstützte
Möglichkeit) oder in den kommerziellen Editionen von Checkmk die
[eingebaute SAML-Authentifizierung.](saml.html#saml_cee) Mit Version
[2.3.0]{.new} wird `mod_auth_mellon` nicht mehr mit der Checkmk-Software
ausgeliefert.
:::

::: paragraph
**Betrifft Sie das?** Dies betrifft Sie, wenn Sie die
SAML-Authentifizierung mit `mod_auth_mellon` nutzen.
:::

::: paragraph
**Was müssen Sie tun?** Nutzer der kommerziellen Editionen sollten *vor*
dem Update auf [2.3.0]{.new} die SAML-Authentifizierung auf die in
Checkmk integrierte Lösung umstellen.
:::

::: paragraph
Falls Sie Checkmk Raw benutzen, können Sie bereits vor dem Update
systemweit `mod_auth_mellon` nach der [Anleitung auf der
Projektseite](https://github.com/latchset/mod_auth_mellon){target="_blank"}
installieren. Stellen Sie dann die Zeile zum Laden des Moduls in der
Konfigurationsdatei `~/etc/apache/conf.d/auth.conf` auf den systemweiten
Installationspfad um. Das Installationsverzeichnis kann je nach
verwendeter Distribution variieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so
```
:::
::::

::: paragraph
Starten Sie Ihre Instanz nach der Änderung neu. Testen Sie schließlich
-- noch unter [2.2.0]{.new} -- ob die SAML-Authentifizierung weiterhin
funktioniert. Ist dies der Fall, sind nach dem Update keine
Schwierigkeiten zu erwarten.
:::
::::::::::

:::::::::::: sect2
### []{#pip3 .hidden-anchor .sr-only}2.12. Python-Module deinstallieren {#heading_pip3}

::: paragraph
Checkmk [2.3.0]{.new} aktualisiert Python von 3.11 auf 3.12. Diese
Aktualisierung betrifft in einer Instanz nachinstallierte Module. In
vielen Fällen sind nachinstallierte Module mit Python 3.12 inkompatibel.
Schlimmstenfalls überschreiben veraltete Module Funktionalität der von
Checkmk mitgelieferten Module.
:::

::: paragraph
**Betrifft Sie das?** Dies betrifft Sie nur, wenn Sie für selbst
geschriebene oder aus der Exchange bezogene Spezialagenten oder
agentenbasierte Check-Plugins explizit Python-Module nachinstalliert
haben. Wenn Sie unsicher sind, führen Sie die im folgenden Schritt
beschriebene Prüfung durch.
:::

::: paragraph
**Was müssen Sie tun?** Finden Sie zunächst heraus, ob und -- wenn ja
--, welche Python-Module in der Instanz installiert sind. Suchen Sie
hierfür die Verzeichnisse `dist-info` und `egg-info`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ find ~/local/lib/python3/ -type d -name '*.*-info'
local/lib/python3/cryptography-41.0.5.dist-info
local/lib/python3/ecdsa-0.18.0.dist-info
```
:::
::::

::: paragraph
Notieren Sie die installierten Module und deinstallieren Sie diese
anschließend:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ pip3 uninstall cryptography ecdsa
```
:::
::::

::: paragraph
Wie Sie mit deinstallierten Python-Modulen nach dem Update umgehen,
erfahren Sie weiter [unten.](#pip3post)
:::
::::::::::::

::::: sect2
### []{#prometheus .hidden-anchor .sr-only}2.13. Prometheus-Checks Datenquelle und Einstellungen {#heading_prometheus}

::: paragraph
Der [Prometheus-Spezialagent](monitoring_prometheus.html) bot
`kube-state-metrics` als Datenquelle, dessen Checks nicht mehr
unterstützt werden. Diese wurden mittlerweile durch verbesserte
Gegenstücke im Kubernetes-Agenten ersetzt (siehe [Werk
#14572](https://checkmk.com/de/werk/14572){target="_blank"}). Zudem
wurden in den Regeln [Prometheus]{.guihint} und [Alertmanager]{.guihint}
die Angabe von IP-Adresse/Host-Name, Port und Pfadpräfix durch ein
einziges Eingabefeld [Custom URL]{.guihint} abgelöst (siehe [Werk
#14573](https://checkmk.com/de/werk/14573){target="_blank"}).
:::

::: paragraph
In beiden Fällen funktionierte das alte Verfahren weiterhin in
[2.2.0]{.new}. Zur Verwendung in [2.3.0]{.new} müssen Sie jedoch Ihre
Konfiguration auf das neue Verfahren umgestellt haben.
:::
:::::

::::::: sect2
### []{#local_files .hidden-anchor .sr-only}2.14. Paketierte (MKPs) und nicht paketierte lokale Dateien {#heading_local_files}

::: paragraph
Mit lokalen Dateien können Sie die von Checkmk bereitgestellte
Funktionalität anpassen und erweitern. Diese Dateien befinden sich im
lokalen Teil der Instanzverzeichnisstruktur, d.h. in `~/local` und
können in Erweiterungspaketen organisiert sein oder einfach so
„herumliegen". Lokale Dateien können bei einem Update Probleme bereiten,
wenn sie nicht mehr zur neuen Checkmk-Version passen.
:::

::: paragraph
**Betrifft Sie das?** Da es für Checkmk bei einem Update nicht möglich
ist, die Kompatibilität von lokalen Anpassungen vollständig
sicherzustellen, sollten Sie Ihre Checkmk-Instanz vor einem Update
daraufhin überprüfen, ob lokale Dateien bei Ihnen verwendet werden,
welche das sind und wie sie organisiert sind.
:::

::: paragraph
**Was müssen Sie tun?**
:::

::: {.olist .arabic}
1.  Erstellen Sie mit `mkp list` einen Überblick über vorhandene
    [Erweiterungspakete (MKPs)](mkps.html) und deren Quellen: Ihre
    selbst entwickelten Erweiterungen können Sie meist leicht testen und
    gegebenenfalls anpassen. Bei extern bezogenen MKPs sollten Sie
    recherchieren, ob bekannte Probleme mit Checkmk [2.3.0]{.new}
    vorhanden sind und neue Versionen vorliegen. In Fällen, in denen
    bisher vom MKP bereitgestellte Funktionalität nun von Checkmk
    [2.3.0]{.new} bereitgestellt wird, deaktivieren Sie das Paket vor
    dem Update.

2.  Verschaffen Sie sich einen [Überblick](mkps.html#find_unpackaged)
    über *nicht paketierte* lokale Dateien Ihrer Checkmk-Instanz, indem
    Sie als Instanzbenutzer das Kommando `mkp find` ausführen. Tauchen
    hier Pfade mit `python3` auf, gehen Sie noch einmal [nach oben zu
    den Python-Modulen](#pip3). Für alle weiteren Dateien gilt: Fassen
    Sie zusammen gehörende Dateien in [MKPs
    zusammen.](mkps.html#package_mkp) Dies erleichtert später die
    Deaktivierung *en bloc*, sollten nach dem Update Inkompatibilitäten
    festgestellt werden.

3.  Im Falle von MKPs, die für Checkmk [2.2.0]{.new} und [2.3.0]{.new}
    unterschiedliche Versionen erfordern, sollten Sie vor dem Update
    [beide Paketversionen mit korrekten
    Kompatibilitätsinformationen](mkps.html#enabled_inactive_cli) in
    Checkmk installiert haben. Wenn verschiedene Versionen eines Paketes
    vorhanden sind, aktiviert Checkmk beim Update automatisch die
    passende Version. Da Zentralinstanzen mit Checkmk [2.2.0]{.new}
    Pakete für [2.3.0]{.new} vorhalten und an Remote-Instanzen verteilen
    können, hilft dieses Feature zudem beim Update in [verteilten
    Umgebungen](glossar.html#distributed_monitoring) mit [verteiltem
    Setup](glossar.html#distributed_setup).
:::
:::::::

::::::: sect2
### []{#apis .hidden-anchor .sr-only}2.15. Programmierschnittstellen {#heading_apis}

::: paragraph
In Checkmk [2.3.0]{.new} wurden einige intern Programmierschnittstellen
(APIs) umgebaut. So werden einige bislang *ad-hoc* definierte APIs durch
wohl spezifizierte ersetzt. Daneben wurde die bereits in [2.0.0]{.new}
als *deprecated* gekennzeichnete Check-API endgültig entfernt.
:::

::: paragraph
**Betrifft Sie das?** Das Thema APIs betrifft Sie, wenn Sie die mit
Checkmk ausgelieferten um Ihre eigenen, selbst geschriebenen Checks
erweitert haben und/oder wenn Sie Plugins aus anderen Quellen nutzen.
:::

::: paragraph
**Was müssen Sie tun?** Überprüfen Sie selbst geschriebene Erweiterungen
und solche von Drittanbietern auf ihre Funktionsfähigkeit. Da die neuen
APIs während Checkmk [2.3.0]{.new} parallel zu den alten benutzt werden
können und Änderungen an den bestehenden APIs klein ausfallen konnten,
werden die meisten Erweiterungen ohne Modifikationen weiter benutzbar
sein. Sollten Änderungen notwendig sein, raten wir dazu, gleich auf die
[neuen APIs zu migrieren](#outlook_newapi), die ab Checkmk [2.4.0]{.new}
die alten APIs vollständig ersetzen.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Mit Checkmk [2.3.0]{.new}b6 wurde |
|                                   | die bereits in [2.0.0]{.new} als  |
|                                   | *deprecated* gekennzeichnete      |
|                                   | Check-API der Versionen bis       |
|                                   | [1.6.0]{.new} endgültig entfernt  |
|                                   | ([Werk                            |
|                                   | #16689](https://checkmk.com/      |
|                                   | de/werk/16689){target="_blank"}). |
|                                   | Checks, die unter Verwendung      |
|                                   | dieser Programmierschnittstelle   |
|                                   | erstellt wurden, werden beim      |
|                                   | Update deaktiviert. Prüfen Sie    |
|                                   | vor dem Update, ob solche Checks  |
|                                   | vorhanden sind und portieren Sie  |
|                                   | diese auf eine der beiden neuen   |
|                                   | API-Versionen -- vorzugsweise     |
|                                   | natürlich die ab [2.3.0]{.new}    |
|                                   | bereitstehenden wohl              |
|                                   | spezifizierten.                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::

:::::: sect2
### []{#rest_api .hidden-anchor .sr-only}2.16. Abkündigungen in der REST-API {#heading_rest_api}

::: paragraph
Abgekündigte Endpunkte oder Parameter der Checkmk REST-API werden in der
API-Dokumentation mit dem Symbol
[![](../images/icons/icon_rest_api_deprecated.png){symbol="" zur=""
anzeige="" einer="" abk="" in="" der=""
rest-api-dokumentation=""}]{.image-inline} gekennzeichnet.
:::

::: paragraph
**Betrifft Sie das?** Das kann Sie betreffen, wenn Sie die Checkmk
REST-API zum Beispiel in eigenen Skripten nutzen.
:::

::: paragraph
**Was müssen Sie tun?** Öffnen Sie die REST-API-Dokumentation mit [Help
\> Developer Resources \> REST API documentation.]{.guihint} Suchen Sie
im Browser auf der Seite nach `Deprecated`, überprüfen Sie, ob Sie
abgekündigte Elemente in Ihren Skripten verwenden, und ersetzen Sie
diese vor dem Update. In der REST-API-Dokumentation finden Sie
gewöhnlich Hinweise, wie Sie die in der neuen Version nicht mehr
existierenden Funktionen ersetzen können.
:::
::::::

:::::::: sect2
### []{#incompatible .hidden-anchor .sr-only}2.17. Inkompatible Änderungen {#heading_incompatible}

::: paragraph
Wie in jeder Checkmk Version, so gibt es auch in der aktuellen Version
[2.3.0]{.new} Änderungen der Software -- bei Checkmk in sogenannten
*Werks* organisiert und dokumentiert --, die Rückwirkungen auf ihre
Checkmk-Installation haben *können*. Eine sogenannte *inkompatible
Änderung* erfordert, dass Sie manuelle Anpassungen durchführen, um
bestehende Funktionen weiterhin wie gewohnt ablaufen zu lassen und/oder
neue Funktionen nutzen zu können.
:::

::: paragraph
**Betrifft Sie das?** In aller Regel wird es inkompatible Änderungen
geben, die auch Ihre Checkmk-Installation betreffen. Eine generelle
Aussage ist aber leider unmöglich. In diesem Artikel haben wir
diejenigen Themen zusammengetragen, die für alle oder die meisten
Checkmk-Installationen zutreffen. Es kann aber sein, dass es darüber
hinaus weitere, für Sie relevante Änderungen gibt, zum Beispiel bei
Checks, die Sie in Ihrer Installation verwenden.
:::

::: paragraph
**Was müssen Sie tun?** Nach jedem Update -- auch solchen auf
Patch-Releases -- zeigt Ihnen Checkmk Anzahl und Inhalt der
inkompatiblen Änderungen und fordert Sie auf, diese zu prüfen und zur
Kenntnis zu nehmen. Vor dem Update ist der richtige Zeitpunkt, liegen
gebliebene Änderungen der Version [2.2.0]{.new} darauf hin abzuklappern,
welche Auswirkungen diese auf das Update haben können. Seit Checkmk
[2.3.0]{.new} werden solche Werks nämlich nicht mehr weiter geschleppt,
sondern beim Update nach Zustimmung in einem Bestätigungsdialog gelöscht
([Werk #15292](https://checkmk.com/de/werk/15292){target="_blank"}).
:::

::: paragraph
Es ist zudem eine gute Idee, sich bereits **vor** dem Update einen
Überblick über die inkompatiblen Änderungen der Version [2.3.0]{.new} zu
verschaffen: Öffnen Sie die Liste der
[Werks](https://checkmk.com/de/werks?search=&cmk_version%5B%5D=2.3&compatible=0){target="_blank"}
auf der Checkmk-Webseite. In der Beschreibung eines Werks finden Sie
Hinweise, was gegebenenfalls zu tun ist, um die Änderung kompatibel zu
machen.
:::

::: paragraph
Nachdem Sie das [Update](#update) durchgeführt haben, werden Ihnen in
der Checkmk-Oberfläche Anzahl und Inhalt der inkompatiblen Änderungen
angezeigt, und Sie werden aufgefordert, diese zu prüfen und zur Kenntnis
zu nehmen. Bei der Prüfung helfen Links, so dass Sie mit wenigen Klicks
herausfinden können, ob Sie eine betroffene Komponente nutzen. Ist
sichergestellt, dass ein Werk keine Auswirkungen hat oder Sie haben
benötigte Änderungen vorgenommen, bestätigen Sie es mit
[Acknowledge]{.guihint}.
:::
::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#update .hidden-anchor .sr-only}3. Update {#heading_update}

::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::::::::: sect2
### []{#dry_run .hidden-anchor .sr-only}3.1. Best Practices beim Update {#heading_dry_run}

::: paragraph
Im Folgenden beschreiben wir bewährte Vorgehensweisen (*best
practices*), welche wir selbst bei Updates von großen Checkmk-Umgebungen
befolgen. Diese sind sicherlich nicht in jeder Umgebung Pflicht, Sie
können Ihnen den Prozess des Updates jedoch erleichtern.
:::

:::::: sect3
#### []{#update_patch .hidden-anchor .sr-only}Checkmk-Version aktualisieren {#heading_update_patch}

::: paragraph
Vor dem Update auf die Version [2.3.0]{.new} muss auf der
Checkmk-Instanz die Version [2.2.0]{.new} installiert sein.
:::

::: paragraph
Wir haben bereits früher von einem Update mit Auslassung einer
Hauptversion abgeraten, da es dazwischen einfach zu viele Änderungen
gibt, die ein reibungsloses Update behindern und mit großer
Wahrscheinlichkeit zu Problemen führen. Mit der Version [2.2.0]{.new}
wurde aus dieser Empfehlung eine Voraussetzung --- und eine Sperre
eingeführt, die zum Beispiel ein direktes Update von Version
[2.0.0]{.new} auf [2.3.0]{.new} verhindert.
:::

::: paragraph
Das Update auf [2.3.0]{.new} setzt zurzeit mindestens [2.2.0]{.new}p8
voraus. Es kann aber sein, dass in der Zukunft eine bestimmte
[2.3.0]{.new} Patch-Version eine höhere [2.2.0]{.new} Patch-Version für
das Update voraussetzt. Generell empfehlen wir, zuerst Checkmk auf die
neueste [2.2.0]{.new} Patch-Version zu aktualisieren und erst dann das
Update auf die [2.3.0]{.new} durchzuführen.
:::
::::::

:::::::::: sect3
#### []{#_probelauf_des_updates_durchführen .hidden-anchor .sr-only}Probelauf des Updates durchführen {#heading__probelauf_des_updates_durchführen}

::: paragraph
In großen Umgebungen, in denen auch das Zurückspielen eines
selbstverständlich vorhandenen Backups Ihrer Checkmk-Umgebung mit einem
gewissen zeitlichen Aufwand verbunden wäre, empfiehlt es sich, vor dem
Update der produktiven Umgebung, einen Test mit einer geklonten Instanz
durchzuführen. Zu diesem Zweck können Sie beispielsweise das letzte
reguläre Backup Ihrer Instanz unter einem anderen Namen
wiederherstellen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd restore newsite /path/to/backup
```
:::
::::

::: paragraph
**Alternativ** können Sie Ihre Instanz auch per `omd cp` kopieren. Dafür
muss die Instanz allerdings kurzzeitig gestoppt werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd stop mysite
root@linux# omd cp mysite newsite
```
:::
::::

::: paragraph
Führen Sie das Update im Anschluss erst einmal auf dieser neuen
geklonten Instanz durch, um hier beispielsweise die oben angesprochenen
lokalen Änderungen in der neuen Umgebung zu prüfen.
:::
::::::::::

:::::::::::: sect3
#### []{#automatic_agent_updates .hidden-anchor .sr-only}Agenten-Update vorübergehend abschalten {#heading_automatic_agent_updates}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie in den
kommerziellen Editionen die automatischen Agenten-Updates verwenden,
sollten Sie überlegen, diese vor dem Update von Checkmk vorübergehend zu
deaktivieren, um den Wechsel auf die neuen Agenten bei den Hosts später
kontrolliert vollziehen zu können. Dazu wählen Sie zuerst [Setup \>
Agents \> Windows, Linux, Solaris, AIX]{.guihint} und auf der folgenden
Seite den Menüeintrag [Agents \> Automatic updates.]{.guihint} Durch
Klick auf den Knopf [![Symbol zum Bearbeiten eines
Listeneintrags.](../images/icons/icon_edit.png)]{.image-inline} vor dem
[Master switch]{.guihint} können Sie das Agenten-Update komplett
abschalten:
:::

:::: imageblock
::: content
![Abschaltung des Agenten-Updates per
Hauptschalter.](../images/update_major_automatic_agent_updates.png)
:::
::::

::: paragraph
Nach dem erfolgreichen Update von Checkmk können Sie das Agenten-Update
auf gleichem Weg wieder anschalten.
:::

::: paragraph
Wir empfehlen an dieser Stelle das automatische Agenten-Update erstmal
nur für einzelne Hosts oder Host-Gruppen wieder zu aktivieren. Auf diese
Weise wird der neue Agent nicht gleich auf all Ihre Server ausgerollt
und Sie können sich auf einigen wenigen Systemen mit den neu
angelieferten Daten vertraut machen. Auch aufgrund der deutlich
gestiegenen Zahl an mitgelieferten Check-Plugins könnten Sie eine ganze
Reihe neuer Services finden, welche Sie dann auf den von Ihnen gewählten
Testsystemen richtig einstellen können. Eventuell sind für neue Services
auch neue Schwellwerte vonnöten. Wenn Sie dies erst einmal im Kleinen
angehen, ersparen Sie sich so einige Fehlalarme.
:::

::: paragraph
Auf der oben angegebenen Seite können Sie dafür einfach ein paar Hosts
oder Host-Gruppen in die entsprechenden Felder eintragen und dann den
[Master switch]{.guihint} wieder aktivieren.
:::

:::: imageblock
::: content
![Optionen beim Agenten-Update zur Aktivierung auf bestimmten
Hosts.](../images/update_major_activate_update_on_selected_hosts.png)
:::
::::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Denken Sie daran, diese           |
|                                   | Einschränkungen auf explizite     |
|                                   | Hosts und Host-Gruppen wieder zu  |
|                                   | entfernen, sobald Sie mit den     |
|                                   | Ergebnissen zufrieden sind.       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::

::::::: sect3
#### []{#notifications .hidden-anchor .sr-only}Benachrichtigungen vorübergehend abschalten {#heading_notifications}

::: paragraph
Sie sollten auch überlegen,
[Benachrichtigungen](glossar.html#notification) in der Instanz vor dem
Update abzuschalten --- aus ähnlichen Gründen, die wir im vorherigen
Abschnitt zu den automatischen Agenten-Updates erklärt haben. So
vermeiden Sie, dass Ihre Kollegen aus dem Monitoring-Team *unnötige*
Benachrichtigungen erhalten.
:::

::: paragraph
Die Benachrichtigungen können Sie zentral im Snapin [Master
control](user_interface.html#master_control) mit dem Schalter
[Notifications]{.guihint} abschalten.
:::

::: paragraph
Es kann durchaus vorkommen, dass nach dem Update der eine oder andere
Service [CRIT]{.state2} ist, der dies vorher nicht gewesen ist. Kümmern
Sie sich nach dem Update zuerst um neu auftretende Probleme. Die
unbehandelten Probleme (*unhandled problems*) können Sie sich z.B. im
Snapin [Overview](user_interface.html#overview) anzeigen lassen.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Vergessen Sie nicht, die          |
|                                   | Benachrichtigungen wieder         |
|                                   | einzuschalten, z.B. dann, wenn    |
|                                   | sich die Zahl der unbehandelten   |
|                                   | Probleme nach dem Update auf das  |
|                                   | Niveau vor dem Update eingepegelt |
|                                   | hat.                              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::
:::::::::::::::::::::::::::::::

:::::: sect2
### []{#update_distributed_monitoring .hidden-anchor .sr-only}3.2. Update im verteilten Monitoring {#heading_update_distributed_monitoring}

::: paragraph
Es gibt zwei unterschiedliche Vorgehensweisen, um das Update aller in
einem [verteilten Monitoring](glossar.html#distributed_monitoring)
beteiligten Instanzen durchzuführen:
:::

::: ulist
- Alle Instanzen stoppen, das Update *en bloc* durchführen und dann alle
  Instanzen wieder starten.

- Unter strengen Auflagen ist ein *Mischbetrieb* für einen gewissen
  Zeitraum möglich, in dem zunächst die Remote-Instanzen aktualisiert
  werden und zum Schluss mit dem Update der Zentralinstanz wieder
  Versionsgleichstand hergestellt wird.
:::

::: paragraph
Insbesondere, wenn Sie die Aktualisierung im laufenden Betrieb
anstreben, sollten Sie die Hinweise im allgemeinen Artikel zu [Updates
und Upgrades](update.html#updatedistributed) lesen.
:::
::::::

::::: sect2
### []{#_das_update_durchführen .hidden-anchor .sr-only}3.3. Das Update durchführen {#heading__das_update_durchführen}

::: paragraph
Am eigentlichen Update der Software hat sich in der Checkmk
[2.3.0]{.new} nichts Grundlegendes geändert, d.h. Sie installieren die
neue Version, führen das Update der Checkmk-Instanz durch, kümmern sich
um Konflikte (falls es denn welche geben sollte) und überprüfen und
bestätigen die inkompatiblen Änderungen.
:::

::: paragraph
Führen Sie die Update-Prozedur so aus, wie sie im Artikel zu [Updates
und Upgrades](update.html#detailed) beschrieben ist.
:::
:::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: sect1
## []{#follow-up .hidden-anchor .sr-only}4. Nachbereitungen {#heading_follow-up}

::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#gui .hidden-anchor .sr-only}4.1. Änderungen der Benutzeroberfläche {#heading_gui}

::: paragraph
Die Benutzeroberfläche (GUI) von Checkmk, die mit Version [2.0.0]{.new}
komplett neu gestaltet wurde, hat sich auch in der [2.3.0]{.new} nicht
grundlegend verändert. Die generellen Abläufe, die Sie aus der Version
[2.0.0]{.new} und [2.2.0]{.new} kennen, können Sie auch in der
[2.3.0]{.new} unverändert anwenden. Allerdings haben sich Menüs,
Menüeinträge, Symbole und andere Details geändert, um neue Funktionen
verfügbar zu machen --- und bestehende zu verbessern.
:::

::: paragraph
In den Artikeln dieses Handbuchs stellen wir Ihnen diese Änderungen
vor - und im [Leitfaden für Einsteiger](intro_setup.html) finden Sie
eine ausführliche Einführung, unter anderem in die wichtigsten Elemente
der [Benutzeroberfläche.](intro_gui.html)
:::
:::::

:::::::: sect2
### []{#service_discovery .hidden-anchor .sr-only}4.2. Services aktualisieren {#heading_service_discovery}

::: paragraph
Wie jede Hauptversion, so bringt auch Checkmk [2.3.0]{.new} eine ganze
Reihe neuer Check-Plugins mit sich. Sollten Sie den [„Discovery
Check"](wato_services.html#discovery_check) nicht einsetzen, d.h. das
automatische Update der Service-Konfiguration über die periodische
Service-Erkennung, werden Sie auf einer ganzen Reihe von Hosts die Suche
nach Services durchführen müssen.
:::

::: paragraph
Wenn Ihre Hosts entsprechend organisiert sind (z.B. in Ordnern), können
Sie hierfür zumeist mit der Funktion [Bulk discovery]{.guihint}
arbeiten. Diese finden Sie unter [Setup \> Hosts \> Hosts]{.guihint} und
dann im Menü [Hosts \> Run bulk service discovery.]{.guihint}
:::

::::: sect3
#### []{#service_descriptions .hidden-anchor .sr-only}Service-Beschreibungen {#heading_service_descriptions}

::: paragraph
Jedes Update von Checkmk bedeutet, dass Service-Beschreibungen geändert
werden, um die Konsistenz der Benennung innerhalb des Monitorings und
der Dokumentation von Checkmk zu verbessern. Da die Änderung von
Service-Beschreibungen bedeutet, dass mitunter Regeln angepasst werden
müssen und historische Monitoring-Daten verloren gehen, belässt Checkmk
bei Updates zunächst die alten Beschreibungen. Sie sollten bei Services,
bei denen Verlust alter Monitoring-Daten zu verschmerzen und der Aufwand
für die Anpassung von Regeln überschaubar ist, zeitnah auf neue
Service-Beschreibungen umstellen.
:::

::: paragraph
Gehen Sie hierfür in [Setup \> General \> Global settings \> Execution
of checks]{.guihint} die Liste [Use new service descriptions]{.guihint}
durch und identifizieren Sie die Services, bei denen die Checkboxen noch
nicht aktiv sind und aktivieren Sie diese. Nach Anwenden der Änderungen
sind die neuen Service-Beschreibungen aktiv und es werden wenige Minuten
vergehen, bis Sie wieder definierte Zustände der betroffenen Services im
Monitoring sehen.
:::
:::::
::::::::

:::::: sect2
### []{#agentupdatercert .hidden-anchor .sr-only}4.3. Zertifikatsprüfung bei Agenten-Updates {#heading_agentupdatercert}

::: paragraph
Das Verhalten des Kommandozeilenparameters `--trust-cert` des Befehls
`cmk-update-agent` wurde geändert. Bislang wurde die gesamte
Zertifikatskette geprüft und dem in der Hierarchie höchsten gefundenen
selbst signierten Zertifikat vertraut, in der Regel ist dies das Root-
oder ein Intermediate-Zertifikat. Ab Checkmk [2.3.0]{.new} wird nur das
Serverzertifikat importiert und diesem vertraut.
:::

::: paragraph
**Betrifft Sie das?** Dies betrifft Sie nur, wenn Sie sich bei der
Registrierung von Hosts für automatische Agenten-Updates auf
`--trust-cert` verlassen und daneben kein [Zertifikat per
Agentenbäckerei](agent_deployment.html#connection_to_cmk_server)
bereitstellen. In diesem Fall verlieren ab Checkmk [2.3.0]{.new} Hosts
bereits bei Ablauf des Serverzertifikats die Vertrauensstellung, mit
Checkmk [2.2.0]{.new} registrierte Hosts erst bei Ablauf der Root- oder
Intermediate-Zertifikate.
:::

::: paragraph
**Was müssen Sie tun?** Wir empfehlen, zeitnah nach dem Update auf
[2.3.0]{.new} die korrekten Zertifikate per Agentenbäckerei
bereitzustellen und ein Update aller Agenten durchzuführen, um so ein
konsistentes Verhalten bei allen Hosts herzustellen, die den Agent
Updater verwenden.
:::
::::::

::::::::::: sect2
### []{#pip3post .hidden-anchor .sr-only}4.4. Python-Module installieren {#heading_pip3post}

::: paragraph
**Betrifft Sie das?** Dies betrifft Sie nur, wenn Sie für selbst
geschriebene oder aus der Exchange bezogene Spezialagenten oder
agentenbasierte Check-Plugins explizit Python-Module nachinstalliert
hatten, und diese im Zuge der Vorbereitung des Updates [entfernt](#pip3)
haben.
:::

::: paragraph
**Was müssen Sie tun?** Finden Sie zunächst heraus, ob die zuvor
deinstallierten Module bereits mit der neuen Checkmk-Version
ausgeliefert werden, zum Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ pip3 list | grep '^cryptography'
```
:::
::::

::: paragraph
Wird das Modul bereits gefunden, kennzeichnen Sie es in Ihren Notizen
als nicht benötigt. Installieren Sie nicht mitgelieferte Module in Ihrer
aktuellsten Version nach:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ pip3 install ecdsa
```
:::
::::

::: paragraph
Testen Sie anschließend die Check-Plugins oder Spezialagenten, die auf
in der Instanz installierte Python-Module angewiesen sind.
:::
:::::::::::

:::::: sect2
### []{#winnet .hidden-anchor .sr-only}4.5. Netzwerk-Interfaces unter Windows {#heading_winnet}

::: paragraph
Bis Checkmk [2.2.0]{.new} war der Windows-Agent auf das zusätzliche
Plugin [Windows: State and Performance of Network
Interfaces](https://checkmk.com/de/integrations/winperf_if){target="_blank"}
angewiesen, um den Status von Netzwerk-Interfaces korrekt zu
übermitteln. Ohne Plugin war der Status immer *up*. Ab Checkmk
[2.3.0]{.new} kann der Agent alleine den korrekten Status übermitteln
([Werk #15839](https://checkmk.com/de/werk/15839){target="_blank"}).
:::

::: paragraph
**Betrifft Sie das?** Je nachdem, in welchem Umfang Sie das Plugin
verteilt haben und ob Sie bei Hosts ohne Plugin das Monitoring des
Zustands von Netzwerk-Interfaces deaktiviert haben, kann Sie das
betreffen. Hosts, die bisher kein Plugin verwendet haben und deren
Netzwerk-Interfaces ins Monitoring aufgenommen waren, werden viele
Schnittstellen von *up* nach *down* wechseln, damit den Status
[CRIT]{.state2} annehmen und so Benachrichtigungen auslösen.
:::

::: paragraph
**Was müssen Sie tun?** Überprüfen Sie, ob der ermittelte Zustand der
betroffenen Netzwerkschnittstellen der gewünschte ist. Führen Sie dann
für betroffene Hosts die Service-Erkennung neu durch. Nutzen Sie die
Gelegenheit, um zunächst wenigstens für Ihre Windows-Hosts die
Empfehlungen des Blog-Artikels [Netzwerk-Monitoring mit Checkmk: 3 rules
to rule them
all](https://checkmk.com/de/blog/network-monitoring-with-checkmk-2-0){target="_blank"}
umzusetzen. Für Windows sind die erwähnten Einstellungen in der Regel
[Network interfaces on Windows]{.guihint} vorzunehmen.
:::
::::::

:::::: sect2
### []{#cmeccelicense .hidden-anchor .sr-only}4.6. Lizenzinformationen synchronisieren {#heading_cmeccelicense}

::: paragraph
Bei Checkmk Cloud und Checkmk MSP mit verteiltem Setup werden mitunter
beim Update keine Lizenzinformationen zu Remote-Instanzen
synchronisiert.
:::

::: paragraph
**Betrifft Sie das?** Falls Sie unmittelbar nach dem Update einen
vollständigen Überblick über Ihre Lizenznutzung benötigen, sind Sie
möglicherweise betroffen. Überprüfen Sie den Lizenzstatus und stoßen Sie
gegebenenfalls die Synchronisierung manuell an.
:::

::: paragraph
**Was müssen Sie tun?** Werfen Sie unter [Setup \> General \>
Distributed Monitoring]{.guihint} einen Blick in die Übersicht der
Remote-Instanzen und suchen Sie Instanzen, welche mit [License state:
trial]{.guihint} gekennzeichnet sind. Um eine unmittelbare
Synchronisation für diese Instanzen zu erzwingen, führen Sie unter
[Setup \> Licensing]{.guihint} eine Überprüfung der Lizenz durch oder
speichern Sie die Lizenzeinstellungen. Sollte dieser Schritt vergessen
werden, wird in der Regel innerhalb von sieben Tagen nach dem Update
eine Synchronisierung der Lizenzdaten im Hintergrund durchgeführt.
:::
::::::
:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::: sect1
## []{#outlook .hidden-anchor .sr-only}5. Ausblick {#heading_outlook}

:::::::::::::::::::::::::::: sectionbody
::: paragraph
In diesem Kapitel geht es um Themen, die nicht die aktuelle Checkmk
Version [2.3.0]{.new}, sondern eine der darauf folgenden Versionen
betreffen.
:::

::::::: sect2
### []{#check_http .hidden-anchor .sr-only}5.1. HTTP-Check in neuer Version {#heading_check_http}

::: paragraph
Checkmk [2.3.0]{.new} enthält einen neuen aktiven Check für
HTTP-Verbindungen und Zertifikate, der wesentlich performanter, robuster
und besser zu konfigurieren ist, als der bisherige [Check HTTP
service]{.guihint}. Zudem ist es mit einer einzigen Regel nun möglich,
mehrere Dinge auf einmal zu überwachen, beispielsweise HTTP Response
Code, Antwortzeit und Zertifikatsgültigkeit.
:::

::: paragraph
Den neuen [Check HTTP web service]{.guihint} finden Sie unter [Setup \>
Services \> HTTP, TCP, Email, ...​]{.guihint} im Kasten
[Networking.]{.guihint} Er wird mittelfristig den alten [Check HTTP
service]{.guihint} komplett ablösen, den Sie auf der gleichen Seite
finden können. Aus diesem Grund raten wir dazu, beim Neuanlegen von
Hosts den bisherigen Check (intern: `check_http`) nicht mehr zu
verwenden und Hosts im Bestand nach und nach auf den neuen Check
(intern: `check_httpv2`) zu migrieren.
:::

::: paragraph
Ein Migrationsskript wird im späteren Verlauf des Lifecycle von Checkmk
[2.3.0]{.new} bereitgestellt werden. Allerdings ist eine komplett
automatisierte Migration tendenziell schwierig, weil bei vielen Hosts
Regeln von zwei Checks zusammengeführt werden müssen, um von der
verbesserten Effizienz zu profitieren.
:::

::: paragraph
Weitere Informationen finden Sie in den beiden Werks
[#15514](https://checkmk.com/de/werk/15514){target="_blank"} und
[#15515](https://checkmk.com/de/werk/15515){target="_blank"}.
:::
:::::::

:::::: sect2
### []{#check_cert .hidden-anchor .sr-only}5.2. Neuer Check für Zertifikate {#heading_check_cert}

::: paragraph
Basisfunktionalität für die Prüfung von Zertifikaten enthielt der
bisherige [Check HTTP service]{.guihint} und der im vorherigen Abschnitt
erwähnte neue [Check HTTP web service]{.guihint} verbessert sie noch
einmal. Allerdings haben beide einige Gemeinsamkeiten: Zunächst sind sie
eben nur anwendbar, wenn ein Zertifikat an einem HTTPS-Endpunkt
verwendet wird, zudem fehlt die Möglichkeit einer detaillierten
Untersuchung der Zertifikate beispielsweise auf enthaltene *Certificate
Subject Alternative Names* oder die ausstellende Stelle.
:::

::: paragraph
Die hieraus resultierenden Nutzerwünsche haben wir mit dem neuen [Check
certificates]{.guihint} (intern: `check_cert`) umgesetzt. Alle
Einstellungen des neuen Checks finden Sie ebenfalls unter [Setup \>
Services \> HTTP, TCP, Email, ...​]{.guihint} im Kasten
[Networking.]{.guihint}
:::

::: paragraph
Weitere Informationen finden Sie im [Werk
#15516](https://checkmk.com/de/werk/15516){target="_blank"}.
:::
::::::

::::: sect2
### []{#outlook_newapi .hidden-anchor .sr-only}5.3. Programmierschnittstellen {#heading_outlook_newapi}

::: paragraph
Nach Checkmk Version [2.3.0]{.new} werden nur noch die wohl
spezifizierten APIs zur Programmierung von Check-Plugins,
Spezialagenten, Graphing, etc. unterstützt werden. Die Änderungen
betreffen die Verzeichnisstruktur, Erkennung der Plugins (*Discovery*
statt *Registry*) und natürlich die Funktionen und Objekte der APIs
selbst. Einen Überblick über die größten Änderungen liefert [Werk
#16259](https://checkmk.com/de/werk/16259){target="_blank"}.
:::

::: paragraph
Da die bisherigen APIs ab Checkmk [2.4.0]{.new} nicht mehr unterstützt
werden, müssen bis zum Update auf [2.4.0]{.new} alle Plugins, welche die
älteren APIs nutzen, auf die neuen APIs migriert sein.
:::
:::::

:::::: sect2
### []{#mk_sql .hidden-anchor .sr-only}5.4. Verbessertes Microsoft SQL Server Monitoring {#heading_mk_sql}

::: paragraph
Für das Monitoring von Microsofts SQL Server steht mit Checkmk
[2.3.0]{.new} ein neues [Agentenplugin](glossar.html#agent_plugin) zur
Verfügung. Sie finden es unter [Setup \> Agents \> Windows, Linux,
Solaris, AIX \> Agent rules \> Microsoft SQL Server (Linux,
Windows).]{.guihint} Dieses ist in Rust implementiert und ersetzt
langfristig das bisherige, in VBScript geschriebene. Lauffähig ist das
neue Plugin unter Linux und Windows auf der x86/64-Plattform. Zudem
bietet es eine erhöhte Flexibilität durch lokales und Remote-Monitoring
unter Windows und Remote-Monitoring unter Linux. Selbstverständlich
können Sie eine lokal unter Linux laufende MS SQL Datenbank unter
Verwendung der TCP/IP-Schnittstelle überwachen.
:::

::: paragraph
Die Konfigurierbarkeit wurde deutlich verbessert. So können Sie nun
wählen, welche Sektionen geprüft werden sollen und eigene SQL-Statements
hinzufügen. Des weiteren können Sie nun mit *einem* Plugin Datenbanken
auf verschiedenen Hosts überwachen. Damit dies übersichtlich bleibt, ist
über den [Piggyback](glossar.html#piggyback)-Mechanismus die Zuordnung
zu anderen Hosts möglich. Die Konfiguration erfolgt per YAML-Datei. Hier
sind die stabilen Optionen per Regeln der Agentenbäckerei verfügbar.
Weitere Einstellungen, bei denen wir uns Modifikationen vorbehalten,
können Sie per Editor konfigurieren. Details erfahren Sie in [Werk
#15842](https://checkmk.com/de/werk/15842){target="_blank"}.
:::

::: paragraph
Mit der Einführung des neuen Agentenplugins startet die Abkündigung des
alten Agentenplugins [Microsoft SQL Server (Windows)]{.guihint}. In
Checkmk [2.3.0]{.new} erhalten Sie lediglich Hinweise auf die Verwendung
eines veralteten Regelsatzes. Ab [2.4.0]{.new} wird es nicht mehr
möglich sein, neue Regeln anzulegen und mit [2.5.0]{.new} wird das alte
Plugin voraussichtlich aus Checkmk entfernt werden. Weitere
Informationen liefert [Werk
#15844](https://checkmk.com/de/werk/15844){target="_blank"}.
:::
::::::

::::: sect2
### []{#management_board .hidden-anchor .sr-only}5.5. Management Boards {#heading_management_board}

::: paragraph
Die Bezeichnung *Management Board* steht für separate Steckkarten oder
erweiterte BIOS-Funktionalität (Baseboard Management Controller/BMC,
Management Engine/ME, Lights Out Management/LOM) zur Überwachung und
Verwaltung der Hardware neben dem installierten Betriebssystem.
:::

::: paragraph
Bis Checkmk [2.3.0]{.new} können Management Boards auf zwei Arten
konfiguriert werden: Als Eigenschaft eines Hosts oder als separater
Host. Da die Konfigurierbarkeit als Eigenschaft eines Hosts sehr
limitiert ist, wird diese Möglichkeit künftig wegfallen. Die
Unterstützung von Redfish kompatiblen Management Boards wird während des
Lifecycle von Checkmk [2.3.0]{.new} eingebaut und verbessert werden,
zunächst als optional zu aktivierendes MKP ([Werk
#16589](https://checkmk.com/de/werk/16589){target="_blank"}). Weitere
Hintergründe und Alternativen erläutern wir im Blog-Artikel [Monitoring
management
boards.](https://checkmk.com/blog/monitoring-management-boards){target="_blank"}
:::
:::::

::::: sect2
### []{#automation_login .hidden-anchor .sr-only}5.6. Authentifizierung per GET-Parameter {#heading_automation_login}

::: paragraph
Bis Checkmk [2.2.0]{.new} konnte jeder
[Automationsbenutzer](glossar.html#automation_user) mit per
GET-Parameter übergebenen Benutzernamen und Passwort angemeldet werden.
Diese Möglichkeit wird ab Checkmk [2.3.0]{.new} zurückgefahren und
schließlich ganz abgeschafft ([Werk
#16223](https://checkmk.com/de/werk/16223){target="_blank"}).
Mittelfristig müssen Sie daher Ihre Skripte auf Authentifizierung per
HTTP-Header umstellen.
:::

::: paragraph
Zunächst macht [2.3.0]{.new} die Möglichkeit des Logins per
GET-Parameter konfigurierbar. Die globale Einstellung [Enable automation
user authentication via HTTP parameters]{.guihint} wird jedoch zunächst
als Standard [enabled]{.guihint} verwenden. In Checkmk [2.4.0]{.new}
wird der Standard dann zu [disabled]{.guihint} wechseln. Schließlich
wird die Möglichkeit des Logins per GET-Parameter mit Checkmk
[2.5.0]{.new} ganz wegfallen.
:::
:::::

:::: sect2
### []{#ntopng56_deprecation .hidden-anchor .sr-only}5.7. ntopng 5.6 und älter werden nicht mehr unterstützt {#heading_ntopng56_deprecation}

::: paragraph
Checkmk [2.3.0]{.new} wird die letzte Version sein, die
[ntopng](ntop.html) in den Versionen 5.x *und* 6.x unterstützt ([Werk
#16483](https://checkmk.com/de/werk/16483){target="_blank"}). Mit
Checkmk [2.4.0]{.new} wird die Unterstützung für ntopng 5.x eingestellt
und nur noch ntopng 6.x unterstützt. Aktualisieren Sie während des
Lifecycle von Checkmk [2.3.0]{.new} daher Ihre ntopng-Installationen auf
6.x.
:::
::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
