:::: {#header}
# Updates und Upgrades

::: details
[Last modified on 08-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/update.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk-Versionen](cmk_versions.html) [Der Checkmk Micro
Core](cmc.html) [Migration auf den CMC](cmc_migration.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::::::::: sectionbody
::: paragraph
Das Update von Checkmk auf eine neue Version läuft etwas anders als bei
anderer Software. Warum?
:::

::: paragraph
Grund ist, dass Checkmk nicht nur mehrere unabhängige **Instanzen**
(*sites*) auf einem Server erlaubt, sondern auch mehrere gleichzeitig
installierte [Software-Versionen.](cmk_versions.html) Dabei ist jede
Instanz einer installierten Version zugeordnet. Nehmen Sie als Beispiel
folgende Situation auf einem fiktiven Server:
:::

:::: imageblock
::: content
![update1](../images/update1.png){width="400"}
:::
::::

::: paragraph
Hier verwendet die Instanz `mysite1` die Version `2.0.0p3.cee`, die
Instanzen `mysite2` und `mysite3` die Version `2.0.0p1.cre`. Die
Checkmk-Version `2.0.0p1.cfe` ist zwar installiert, wird aber aktuell
nicht verwendet.
:::

::: paragraph
Dieses Beispiel macht klar, dass ein Update nicht einfach nur die
Installation eines neuen RPM/DEB-Pakets von Checkmk auf dem Server
bedeuten kann. Vielmehr braucht es dazu noch einen weiteren Schritt.
Nehmen Sie nun als Beispiel folgende Situation:
:::

:::: imageblock
::: content
![update2](../images/update2.png){width="400"}
:::
::::

::: paragraph
Hier soll die Instanz `mysite` auf die Checkmk-Version `2.0.0p3.cee`
aktualisiert werden. Der erste Schritt ist das Herunterladen und
Installieren des passenden RPM/DEB-Pakets. Dies geschieht genauso wie
bei der [ersten Installation.](install_packages.html) Die neu
installierte Version wird zunächst noch von keiner Instanz verwendet und
das sieht dann so aus:
:::

:::: imageblock
::: content
![update3](../images/update3.png){width="400"}
:::
::::

::: paragraph
Als zweiter Schritt erfolgt nun ein Update der Instanz von `2.0.0p1.cre`
auf `2.0.0p3.cee`. Dies geschieht durch den Befehl `omd update`, welchen
Sie weiter unten im Detail kennenlernen:
:::

:::: imageblock
::: content
![update4](../images/update4.png){width="400"}
:::
::::

::: paragraph
Nach dem Update können Sie die (eventuell) nicht mehr benötigte Version
`2.0.0p1.cre` durch das Deinstallieren des entsprechenden Pakets
entfernen.
:::
::::::::::::::::::
:::::::::::::::::::

:::::::::::::::::::::::::::::::: sect1
## []{#before_update .hidden-anchor .sr-only}2. Vor dem Update {#heading_before_update}

::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Falls Sie ein Update der Checkmk-Version [2.2.0]{.new} auf [2.3.0]{.new}
planen, sollten Sie zuerst den Artikel [Update auf Version
2.3.0](update_major.html) lesen, in dem wir die wichtigsten Themen
zusammengetragen haben, die Sie vor und nach einem solchen Update
beachten sollten.
:::

::: paragraph
Aber auch, wenn Sie bereits eine [2.3.0]{.new}-Version installiert haben
und auf eine neue stabile Patch-Version der [2.3.0]{.new} updaten
wollen, können die in den folgenden Abschnitten beschriebenen Themen
relevant sein.
:::

::::: sect2
### []{#update_major_version .hidden-anchor .sr-only}2.1. Update der Major-Version {#heading_update_major_version}

::: paragraph
Bei einem Update auf eine höhere Major-Version müssen Sie immer direkt
auf die nächste Version aktualisieren und können nicht einfach eine
überspringen. Wenn Sie also beispielsweise von [2.1.0]{.new} auf
[2.3.0]{.new} aktualisieren wollen, aktualisieren Sie zunächst auf die
[2.2.0]{.new}. Der Grund ist simpel: Zwischen zwei Major-Versionen gibt
es bisweilen schlicht so viele Änderungen, dass es beim Überspringen zu
Problemen kommen würde.
:::

::: paragraph
Der Befehl `omd update` ermöglicht auch die „Aktualisierung" auf eine
*niedrigere* Version. Diese Vorgehensweise ist nur bei Regressionen
vorgesehen. Nach einem solchen Update in die Rückwärtsrichtung sind
viele Anpassungen nötig, um Konfiguration und Laufzeitumgebung wieder
kompatibel zu machen -- insbesondere, aber nicht nur, bei einem
\"Update\" auf eine niedrigere Major-Version. Daher raten wir von diesem
Vorgehen dringend ab -- und können auch bei einem Update auf eine
niedrigere Version keinen Support mehr bieten.
:::
:::::

:::::::: sect2
### []{#incompatible_mkps .hidden-anchor .sr-only}2.2. Inkompatible und obsolete MKPs {#heading_incompatible_mkps}

::: paragraph
Über die [Checkmk-Erweiterungspakete (MKPs)](glossar.html#mkp) lässt
sich Ihr Monitoring-System recht einfach und bequem erweitern. Auf der
einen Seite kommt es dabei vor, dass solche MKPs nicht weiter gepflegt
werden und dann ggf. mit neuen Versionen von Checkmk nicht mehr
kompatibel sind. Auf der anderen Seite nehmen wir immer wieder neue
Plugins und Funktionserweiterungen in Checkmk auf, weshalb MKPs mitunter
obsolet werden. Ihre Funktionalität wird schlicht von Checkmk selbst
sichergestellt.
:::

::: paragraph
Falls Sie MKPs installiert haben, ist aus diesem Grund eine Prüfung
dieser MKPs dringend geboten. So verhindern Sie, dass inkompatible
Pakete das Update behindern oder im Anschluss an das Update doppelte
oder zumindest sehr ähnliche Services entstehen.
:::

::: paragraph
Prüfen Sie hierzu Ihre installierten MKPs gegen unseren [Katalog der
Check-Plugins](https://checkmk.com/de/integrations){target="_blank"} und
entfernen Sie Pakete, welche inzwischen nativ von Checkmk bereitgestellt
werden. Bei dieser Gelegenheit können Sie auch MKPs entfernen, die
eventuell nur mal für einen Probelauf installiert worden sind. Eine
Auflistung finden Sie im [Setup]{.guihint}-Menü unter [Maintenance \>
Extension packages]{.guihint}. Auf der Kommandozeile können Sie sich
installierte Erweiterungen mit dem Befehl `mkp list` anzeigen lassen.
Überprüfen Sie die Ausgabe dieses Befehls auf Erweiterungen, die nicht
mehr benötigt werden oder die Sie gar nicht mehr zuordnen können.
:::

::: paragraph
Checkmk unterstützt zur Vorbereitung von Updates die Bereitstellung von
MKPs für eine neuere als die aktuell laufende Version. Beim Update wird
dann das Paket für die niedrigere Checkmk-Version deaktiviert und das
für die höhere aktiviert. Details erklärt der [Artikel zur Verwendung
von MKPs](mkps.html).
:::

::: paragraph
**Achtung:** Wenn Sie an Dateien, die ursprünglich MKPs entstammen,
lokal Änderungen vorgenommen haben, packen Sie das MKP nach Erhöhung der
Versionsnummer neu. Während des Updates werden sonst geänderte Dateien
durch die im MKP enthaltenen überschrieben.
:::
::::::::

:::::::::: sect2
### []{#local_files .hidden-anchor .sr-only}2.3. Lokale Dateien {#heading_local_files}

::: paragraph
Mit lokalen Dateien können Sie die von Checkmk bereitgestellte
Funktionalität anpassen und erweitern. Diese Dateien befinden sich im
lokalen Teil der Instanzverzeichnisstruktur, d. h. in `~/local`. Lokale
Dateien können bei einem Update Probleme bereiten, da sie eventuell
nicht mehr zur neuen Checkmk-Version passen.
:::

::: paragraph
Da es für Checkmk bei einem Update nicht möglich ist, die lokalen
Anpassungen und jede von einem Drittanbieter hergestellte Erweiterung
abzufangen und zu behandeln, sollten Sie Ihre Checkmk-Instanz vor einem
Update daraufhin überprüfen, ob lokale Dateien bei Ihnen verwendet
werden und gegebenenfalls welche.
:::

::: paragraph
Verschaffen Sie sich einen Überblick über die lokalen Dateien Ihrer
Checkmk-Instanz, indem Sie als Instanzbenutzer das folgende Kommando
ausführen (bei dem die Option `-L` dafür sorgt, dass auch symbolischen
Links gefolgt wird):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ find -L ~/local -type f
```
:::
::::

::: paragraph
In einer frischen Installation von Checkmk wird Ihnen derzeit nur eine
Datei namens `README.TXT` aufgelistet. Alles, was darüber hinaus
angezeigt wird, sollte ganz oben auf Ihrer Liste zur Fehlerdiagnose
stehen, falls es beim Update Probleme geben sollte.
:::

::: paragraph
Im Idealfall sind lokale Dateien bereits vollständig in
[MKPs](#incompatible_mkps) gebündelt. Verwenden Sie `mkp find` um
unpaketierte Dateien zu identifizieren. Die weitere Vorgehensweise der
Erstellung von Paketen zeigt unser [Artikel zu
Checkmk-Erweiterungspaketen.](mkps.html#developers) Einmal zu einem
Paket zusammengefasst, kann eine Erweiterung als ganzes deaktiviert oder
erneut aktiviert werden.
:::
::::::::::

::::::::::: sect2
### []{#backup .hidden-anchor .sr-only}2.4. Backup und Probelauf {#heading_backup}

::: paragraph
Die Selbstverständlichkeit, ein Backup unmittelbar vor dem Update zu
erstellen, um im Falle eines Fehlschlags nicht allzu viel Ihrer
Monitoring-Historie zu verlieren, müssen wir Ihnen nicht erklären. An
dieser Stelle relevant ist, dass ein reguläres Backup auch gute Dienste
für den Probelauf eines Updates leisten kann. So können Sie das Backup
unter einem anderen Namen wiederherstellen -- und anschließend mit der
Instanz `newsite` das Update testen:
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
muss die produktiv genutzte Instanz allerdings kurzzeitig gestoppt
werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd stop mysite && omd cp mysite newsite && omd start mysite
```
:::
::::

::: paragraph
Führen Sie das Update im Anschluss erst einmal auf dieser neuen,
geklonten Instanz durch, um hier beispielsweise die oben angesprochenen
lokalen Änderungen in der neuen Umgebung zu prüfen. Waren die Tests mit
der geklonten Instanz erfolgreich, werden Sie diese aus Platz- und
Performance-Gründen meist *vor* dem eigentlichen Update der
Produktivinstanz löschen oder zumindest stoppen wollen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Seit Checkmk [2.3.0]{.new} wird   |
|                                   | bei einem fehlgeschlagenen Update |
|                                   | der vor dem Update vorhandene     |
|                                   | Zustand der Konfiguration         |
|                                   | wiederhergestellt. Fehlschlagen   |
|                                   | kann ein Update durch einen       |
|                                   | unerwarteten internen Fehler,     |
|                                   | aber auch durch Benutzereingabe   |
|                                   | während des Update-Prozesses, zum |
|                                   | Beispiel durch Auswahl der        |
|                                   | Menüoption `abort` oder durch     |
|                                   | Drücken der Tastenkombination     |
|                                   | `CTRL+C`. Die Wiederherstellung   |
|                                   | der Konfiguration ersetzt kein    |
|                                   | vollständiges Backup, hilft aber  |
|                                   | in vielen Fällen, Ausfallzeiten   |
|                                   | zu verkürzen.                     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#detailed .hidden-anchor .sr-only}3. Update von Checkmk {#heading_detailed}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::: sect2
### []{#_installation_neuer_versionen .hidden-anchor .sr-only}3.1. Installation neuer Versionen {#heading__installation_neuer_versionen}

::: paragraph
Wie in der Einleitung beschrieben, ist der erste Schritt beim Update die
[Installation](install_packages.html) der gewünschten neuen
[Version](cmk_versions.html) von Checkmk. Dies erfolgt genau wie bei der
ersten Installation  ---  allerdings wird es wohl etwas schneller gehen,
weil die meisten abhängigen Pakete jetzt schon installiert sind. In
folgendem Beispiel installieren wir das Paket für Ubuntu 22.04 (Jammy
Jellyfish):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apt install /tmp/check-mk-enterprise-2.3.0p1_0.jammy_amd64.deb
```
:::
::::

::: paragraph
**Hinweis:** Wenn Sie ein lokal vorliegendes Paket mit `apt install`
installieren, müssen Sie den vollständigen Pfad zu der .deb-Datei
angeben.
:::

::: paragraph
Die Liste der installierten Checkmk-Versionen können Sie jederzeit mit
dem Befehl `omd versions` abrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd versions
2.1.0p42.cre
2.2.0p22.cee
2.3.0p1.cee (default)
```
:::
::::

::: paragraph
Eine dieser Versionen ist mit `(default)` markiert. Diese
Standardversion wird automatisch beim Anlegen von neuen Instanzen
verwendet, sofern Sie nicht mit `omd -V myversion create mysite` eine
andere angeben. Die aktuelle Standardversion können Sie mit
`omd version` abfragen und mit `omd setversion` ändern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd version
OMD - Open Monitoring Distribution Version 2.3.0p1.cee
root@linux# omd setversion 2.2.0p22.cee
root@linux# omd version
OMD - Open Monitoring Distribution Version 2.2.0p22.cre
```
:::
::::

::: paragraph
Beim Verwalten *bestehender* Instanzen spielt die Standardversion keine
Rolle. Der `omd`-Befehl startet immer mit der Version, die zur Instanz
passt, für die der Befehl aufgerufen wird.
:::

::: paragraph
Eine Auflistung der aktuellen Instanzen und welche Versionen diese
verwenden liefert der Befehl `omd sites`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd sites
SITE             VERSION          COMMENTS
mysite           2.2.0p22.cee
test             2.3.0p1.cee      default version
```
:::
::::
:::::::::::::::::

:::::::::::::::::::::::::::::::: sect2
### []{#execute .hidden-anchor .sr-only}3.2. Durchführen des Updates {#heading_execute}

::: paragraph
Nachdem die gewünschte neue Version installiert ist, können Sie das
Update der Instanz durchführen. Dazu sind keine `root`-Rechte
erforderlich. Machen Sie das Update am besten als Instanzbenutzer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd su mysite
```
:::
::::

::: paragraph
Stellen Sie sicher, dass die Instanz gestoppt ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd stop
```
:::
::::

::: paragraph
Das Updaten --- also eigentlich das Umschalten auf eine andere
Version --- geschieht nun einfach mit dem Befehl `omd update`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd update
```
:::
::::

::: paragraph
Falls es mehr als eine mögliche Zielversion gibt, bekommen Sie diese zur
Auswahl:
:::

:::: imageblock
::: content
![update omd update 2](../images/update_omd-update-2.png){width="55%"}
:::
::::

::: paragraph
Bestätigen Sie in der folgenden Dialogbox das gewählte Update auf die
neue Version:
:::

:::: imageblock
::: content
![update omd update 3](../images/update_omd-update-3.png){width="55%"}
:::
::::

::: paragraph
Wenn Sie gleichzeitig zum *Versions-Update* ein *Editions-Upgrade* von
einer Checkmk Raw auf eine der kommerziellen Editionen durchführen,
werden Sie sicherheitshalber noch einmal auf diesen Umstand hingewiesen:
:::

:::: imageblock
::: content
![update raw to
enterprise](../images/update_raw_to_enterprise.png){width="55%"}
:::
::::

::: paragraph
Ein wichtiger Teil des Updates ist das Aktualisieren von
mitausgelieferten Konfigurationsdateien. Dabei werden von Ihnen
eventuell vorgenommene Änderungen in diesen Dateien nicht einfach
verworfen, sondern zusammengeführt. Dies funktioniert sehr ähnlich zu
Versionskontrollsystemen, die versuchen, gleichzeitige Änderungen
mehrerer Entwickler in der gleichen Datei automatisch zusammenzuführen.
:::

::: paragraph
Manchmal --- wenn die Änderungen die gleiche Stelle der Datei
betreffen --- funktioniert das nicht und es kommt zu einem *Konflikt*.
Wie Sie diesen lösen können, zeigen wir [weiter unten.](#conflicts)
:::

::: paragraph
Das Update zeigt eine Liste aller angepassten Dateien und Verzeichnisse
(im folgenden Beispiel gekürzt):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
2024-04-09 15:55:04 - Updating site 'mysite' from version 2.2.0p23.cee to 2.3.0p1.cee...

 * Installed dir  etc/default
 * Updated        etc/mk-livestatus/nagios.cfg

...
 * Vanished       etc/jmx4perl/config/websphere
 * Vanished       etc/jmx4perl/config
Creating temporary filesystem /omd/sites/mysite/tmp...OK
ATTENTION
  Some steps may take a long time depending on your installation.
  Please be patient.

Cleanup precompiled host and folder files
Verifying Checkmk configuration...
 01/05 Rulesets...
 02/05 UI extensions...
 03/05 Agent based plugins...
 04/05 Autochecks...
 05/05 Deprecated .mk configuration of plugins...
Done (success)

Completed verifying site configuration. Your site now has version 2.3.0p1.cee.
Executing update-pre-hooks script "01_init_state_creation.py"...OK
Executing update-pre-hooks script "01_mkp-disable-outdated"...OK
Executing update-pre-hooks script "02_cmk-update-config"...
-| ATTENTION
-|   Some steps may take a long time depending on your installation.
-|   Please be patient.
-|
-| Cleanup precompiled host and folder files
-| Verifying Checkmk configuration...
-|  01/05 Rulesets...
-|  02/05 UI extensions...
-|  03/05 Agent based plugins...
-|  04/05 Autochecks...
-|  05/05 Deprecated .mk configuration of plugins...
-| Done (success)
-|
-| Updating Checkmk configuration...
-|  01/25 Cleanup microcore config...
...
-|  25/25 Update core config...
-| Generating configuration for core (type cmc)...
-| Starting full compilation for all hosts Creating global helper config...OK
-|  Creating cmc protobuf configuration...OK
-| Done (success)
OK
Finished update.
```
:::
::::

::: paragraph
Wenn die in der obigen Ausgabe hervorgehobene Zeile
`Completed verifying site configuration` angezeigt wird, ist die Instanz
auf die neue Version umgeschaltet:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd version
OMD - Open Monitoring Distribution Version 2.3.0p1.cee
```
:::
::::

::: paragraph
... und kann gestartet werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd start
```
:::
::::
::::::::::::::::::::::::::::::::

::::::::::::: sect2
### []{#incompatible .hidden-anchor .sr-only}3.3. Inkompatible Änderungen {#heading_incompatible}

::: paragraph
Software-Entwicklung bedeutet Änderung. Und da wir immer daran arbeiten,
Checkmk modern zu halten, kommen wir manchmal nicht drumherum, alte
Zöpfe abzuschneiden und Änderungen zu machen, die *inkompatibel* sind.
Das bedeutet, dass Sie nach einem Update *eventuell* Ihre Konfiguration
anpassen oder wenigstens überprüfen sollten.
:::

::: paragraph
Ein typisches Beispiel dafür sind neue Check-Plugins, die bestehende
Plugins ersetzen. Falls Sie eines der betroffenen Plugins einsetzen, ist
nach dem Update eine erneute
[Service-Erkennung](glossar.html#service_discovery) auf den betroffenen
Hosts notwendig.
:::

::: paragraph
Eine Übersicht über alle Änderungen in Checkmk, inklusive einer
Suchfunktion, finden Sie online in unseren
[Werks.](https://checkmk.com/de/werks){target="_blank"}
:::

::: paragraph
Noch praktischer ist aber die in Checkmk eingebaute Funktion zur
Recherche. Nachdem Sie sich an der Instanz angemeldet haben, finden Sie
oben im [Help]{.guihint}-Menü einen rot hinterlegten Link mit der Zahl
inkompatibler *und* noch nicht bestätigter Änderungen:
:::

:::: imageblock
::: content
![Help-Menü mit Link zur Liste der inkompatblen
Änderungen.](../images/update_help_menu_incompatible_werks.png){width="65%"}
:::
::::

::: paragraph
Checkmk verfolgt die beim Update zur aktuellen Version angefallenen
inkompatiblen Änderungen und fordert Sie auf, diese zu überprüfen und
dann zu bestätigen (*acknowledge*):
:::

:::: imageblock
::: content
![Liste der inkompatiblen und offenen
Änderungen.](../images/update_incomp_werks.png)
:::
::::

::: paragraph
Wenn Sie diese Seite über den rot hinterlegten Link im
[Help]{.guihint}-Menü öffnen, werden Ihnen nur die „Werks" (d.h. die
Änderungen) angezeigt, bei denen etwas zu tun ist, und die daher mit
[Incompatible - TODO]{.guihint} gekennzeichnet sind. Sie können jedes
Werk einzeln aufrufen, ansehen, per Mausklick bestätigen --- und damit
die Zahl der offenen, inkompatiblen Änderungen sukzessive verringern.
Zusätzlich haben Sie mit dem Menüeintrag [Help \> Change log
(Werks)]{.guihint} Zugriff auf die komplette Historie der Änderungen in
der aktuellen Major-Version.
:::
:::::::::::::

:::::::::::::::::::::: sect2
### []{#_das_update_im_detail .hidden-anchor .sr-only}3.4. Das Update im Detail {#heading__das_update_im_detail}

::: paragraph
Sind Sie neugierig, was beim Update genau „unter der Haube abläuft"?
Oder haben Sie beim Durchlauf von `omd update` Konflikte in Dateien
bekommen? Dann sollten Sie hier weiterlesen.
:::

::: paragraph
Bei `omd update` geschehen drei Dinge:
:::

::: {.olist .arabic}
1.  Aktualisieren von Standarddateien unter `~/etc/` und `~/var/`, also
    solchen Dateien, die bei `omd create` erzeugt wurden.

2.  Umschalten der Version auf die Zielversion durch Ändern des
    symbolischen Links `version`, welcher sich im Instanzverzeichnis
    befindet.

3.  Nachbearbeitungen durch verschiedene Pakete (z.B. Checkmk).
    Insbesondere werden automatisch die [Änderungen
    aktiviert](glossar.html#activate_changes), um eine valide
    Konfiguration für den Kern zu erzeugen.
:::

:::::: sect3
#### []{#_aktualisieren_von_dateien_zusammenführen_von_änderungen .hidden-anchor .sr-only}Aktualisieren von Dateien, Zusammenführen von Änderungen {#heading__aktualisieren_von_dateien_zusammenführen_von_änderungen}

::: paragraph
Der erste Schritt ist der bei weitem umfangreichste. Hier zeigt sich ein
großer Vorteil von Checkmk gegenüber klassischen
Software-Installationen: Checkmk hilft Ihnen, alle
Standard-Konfigurationsdateien an die Erfordernisse der neuen Version
anzupassen. Dies ähnelt dem Vorgang beim Update einer
Linux-Distribution, geht aber in der Umsetzung darüber hinaus. So
behandelt Checkmk eine Vielzahl von Fällen, zum Beispiel:
:::

::: ulist
- Zusammenführen von Dateiänderungen mit lokalen Änderungen des
  Benutzers.

- Dateien, Verzeichnisse und symbolische Links, die in der neuen Version
  obsolet sind oder vom Benutzer gelöscht wurden.

- Änderungen an den Berechtigungen.

- Änderungen des Dateityps (aus Verzeichnis oder Datei wird symbolischer
  Link oder umgekehrt).

- Änderungen des Ziels von symbolischen Links.
:::

::: paragraph
Dabei achtet Checkmk stets darauf, dass Ihre lokalen Änderungen erhalten
bleiben, gleichzeitig aber alle für die neue Version notwendigen
Änderungen umgesetzt werden.
:::
::::::

::::::::: sect3
#### []{#conflicts .hidden-anchor .sr-only}Zusammenführen und Konflikte {#heading_conflicts}

::: paragraph
Falls die neue Version eine Änderung an einer Konfigurationsdatei
vorsieht, an der Sie inzwischen selbst Änderungen vorgenommen haben,
versucht Checkmk, beide Änderungen automatisch zusammenzuführen
(*merge*). Dies geschieht mit den gleichen Methoden, die auch
Versionskontrollsysteme verwenden.
:::

::: paragraph
Am wenigsten Probleme gibt es immer dann, wenn Ihre und Checkmks
Änderungen räumlich weit genug auseinander liegen (mindestens ein paar
Zeilen). Dann erfolgt die Zusammenführung automatisch und ohne Ihre
Hilfe.
:::

::: paragraph
Wenn zwei Änderungen kollidieren, weil sie die gleiche Stelle der Datei
betreffen, kann und will Checkmk nicht entscheiden, welche der beiden
Änderungen wichtiger ist. In diesem Fall werden Sie als Benutzer
eingeschaltet und können den Konflikt interaktiv auflösen:
:::

:::: imageblock
::: content
![omd update](../images/omd-update.png){width="85%"}
:::
::::

::: paragraph
Sie haben nun folgende Möglichkeiten:
:::

+---+-------------------------------------------------------------------+
| * | Dies zeigt Ihnen die Unterschiede zwischen der neuen              |
| * | Standardversion der Datei und Ihrer Version in Form eines         |
| d | \"unified diff\" (`diff -u`).                                     |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Dies ist ähnlich der vorherigen Funktion, zeigt aber ausgehend    |
| * | von der früheren Standardversion, welche Änderungen Sie an der    |
| y | Datei gemacht haben.                                              |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Diese dritte Option schließt quasi das Dreieck und zeigt die      |
| * | Änderungen, welche Checkmk an der Datei vornehmen möchte.         |
| n |                                                                   |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Lösen Sie den Konflikt manuell im Editor auf.                     |
| * |                                                                   |
| e |                                                                   |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Drücken Sie **t**, so wird Ihre Originaldatei  ---  ohne die      |
| * | bereits erfolgreich zusammengeführten Änderungen  ---  in einem   |
| t | Editor geöffnet. Editieren Sie nun die Datei, um eventuellen      |
| * | Konflikten aus dem Weg zu gehen. Nach dem Schließen des Editors   |
| * | probiert Checkmk die Zusammenführung erneut.                      |
+---+-------------------------------------------------------------------+
| * | Hier entscheiden Sie sich dafür, die Datei so zu übernehmen, wie  |
| * | sie jetzt ist. Die erfolgreich eingebauten Änderungen bleiben.    |
| k | Ansonsten bleibt die Datei so, wie von Ihnen angepasst.           |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | So stellen Sie Ihre Datei im Ausgangszustand wieder her und       |
| * | verzichten auf das Update von Checkmk für diese Datei.            |
| r | Möglicherweise notwendige Anpassungen müssen Sie selbst           |
| * | vornehmen.                                                        |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Installieren der neuen Standardversion der Datei: Ihre Änderungen |
| * | an der Datei gehen verloren.                                      |
| i |                                                                   |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Wenn Sie unsicher sind, können Sie mit **s** eine Shell öffnen.   |
| * | Sie befinden sich im Verzeichnis, in dem die betroffene Datei     |
| s | liegt, und können sich ein Bild von der Lage machen. Beenden Sie  |
| * | die Shell mit CTRL+D, um das Update fortzusetzen.                 |
| * |                                                                   |
+---+-------------------------------------------------------------------+
| * | Abbruch des Updates. Die Instanz bleibt auf der alten Version und |
| * | deren vorherige Konfiguration wird wiederhergestellt. Sie können  |
| a | jederzeit einen neuen Update-Versuch starten.                     |
| * |                                                                   |
| * |                                                                   |
+---+-------------------------------------------------------------------+
:::::::::

::::: sect3
#### []{#_weitere_konfliktsituationen .hidden-anchor .sr-only}Weitere Konfliktsituationen {#heading__weitere_konfliktsituationen}

::: paragraph
Neben dem inhaltlichen Zusammenführen von Dateien gibt es noch eine
ganze Reihe weiterer Fälle, in denen Checkmk Ihre Entscheidung braucht.
Dies sind teils sehr ungewöhnliche Situationen, die aber trotzdem
korrekte Behandlung brauchen. Checkmk wird Ihnen in diesen Fällen stets
die Auswahl geben, Ihre Version beizubehalten oder die neue
Standardversion zu übernehmen. Außerdem haben Sie immer die Möglichkeit
eines Abbruchs oder können eine Shell öffnen. Beispiele für solche Fälle
sind:
:::

::: ulist
- Kollidierende Änderungen des Dateityps (z.B. wenn eine Datei durch
  einen symbolischen Link ersetzt wird)

- Kollidierende Änderungen an den Dateirechten

- Geänderte Dateien, die in der neuen Version entfallen

- Von Ihnen angelegte Dateien, Verzeichnisse oder Links, die mit neuen
  Dateien/Verzeichnissen/Links kollidieren
:::
:::::

:::: sect3
#### []{#_erklärung_der_ausgaben_beim_update .hidden-anchor .sr-only}Erklärung der Ausgaben beim Update {#heading__erklärung_der_ausgaben_beim_update}

::: paragraph
Immer wenn der Update-Vorgang automatisch Änderungen an Dateien macht,
gibt er eine Zeile zur Erklärung aus. Dabei gibt es folgende
Möglichkeiten (wenn von Datei die Rede ist, gilt dies analog auch für
Links und Verzeichnisse):
:::

+-------------+--------------------------------------------------------+
| Updated     | Eine Datei hat sich in der neuen Version geändert. Da  |
|             | Sie keine Änderungen an der Datei gemacht haben, setzt |
|             | Checkmk einfach die neue Standardversion der Datei     |
|             | ein.                                                   |
+-------------+--------------------------------------------------------+
| Merged      | Eine Datei hat sich in der neuen Version geändert,     |
|             | während Sie gleichzeitig andere Änderungen an der      |
|             | Datei gemacht haben. Beide konnten konfliktfrei        |
|             | zusammengeführt werden.                                |
+-------------+--------------------------------------------------------+
| Identical   | Eine Datei hat sich in der neuen Version geändert.     |
|             | Gleichzeitig haben Sie die Datei selbst schon in genau |
|             | der gleichen Art geändert. Checkmk muss nichts         |
|             | unternehmen.                                           |
+-------------+--------------------------------------------------------+
| Installed   | Die neue Version bringt eine neue Konfigurationsdatei  |
|             | mit, welche soeben installiert wurde.                  |
+-------------+--------------------------------------------------------+
| Id          | Die neue Version bringt eine Datei mit, inzwischen     |
| entical new | haben Sie selbst die gleiche Datei mit dem gleichen    |
|             | Inhalt angelegt.                                       |
+-------------+--------------------------------------------------------+
| Obsolete    | In der neuen Version ist eine Datei (Link,             |
|             | Verzeichnis) weggefallen. Sie haben diese Datei        |
|             | sowieso schon gelöscht. Nichts passiert.               |
+-------------+--------------------------------------------------------+
| Vanished    | Auch hier ist eine Datei weggefallen, welche Sie aber  |
|             | weder gelöscht noch verändert haben. Checkmk entfernt  |
|             | diese Datei automatisch.                               |
+-------------+--------------------------------------------------------+
| Unwanted    | Sie haben eine Datei gelöscht, die normalerweise       |
|             | vorhanden ist. Da sich in der neuen Version keine      |
|             | Änderung in der Datei ergeben hat, belässt es Checkmk  |
|             | dabei, dass die Datei fehlt.                           |
+-------------+--------------------------------------------------------+
| Missing     | Sie haben eine Datei gelöscht, an der sich in der      |
|             | neuen Version Änderungen ergeben haben. Checkmk legt   |
|             | die Datei nicht neu an, warnt Sie aber durch diese     |
|             | Ausgabe.                                               |
+-------------+--------------------------------------------------------+
| Permissions | Checkmk hat die Berechtigungen einer Datei             |
|             | aktualisiert, da in der neuen Version andere Rechte    |
|             | gesetzt sind.                                          |
+-------------+--------------------------------------------------------+
::::
::::::::::::::::::::::

::::::::::::::::: sect2
### []{#_update_ohne_benutzerinteraktion .hidden-anchor .sr-only}3.5. Update ohne Benutzerinteraktion {#heading__update_ohne_benutzerinteraktion}

::: paragraph
Möchten Sie das Software-Update von Checkmk automatisieren? Dann werden
Sie vielleicht erstmal an den interaktiven Rückfragen von `omd update`
gescheitert sein. Dafür gibt es eine einfache Lösung: Der Befehl kennt
nämlich Optionen, die speziell für den Einsatz in Skripten gedacht sind:
:::

::: ulist
- Die Option `-f` oder `--force` direkt nach `omd` verhindert alle
  Fragen vom Typ „Sind Sie sicher...​".

- Die Option `--conflict=` direkt nach `update` setzt das gewünschte
  Verhalten bei einem Dateikonflikt.
:::

::: paragraph
Mögliche Werte für `--conflict=` sind:
:::

+-------------+--------------------------------------------------------+
| `--confli   | Behält im Konfliktfall Ihre eigene modifizierte        |
| ct=keepold` | Version der Datei. Eventuell ist Checkmk dann aber     |
|             | nicht lauffähig und ein manuelles Nacharbeiten         |
|             | erforderlich.                                          |
+-------------+--------------------------------------------------------+
| `--confli   | Installiert im Konfliktfall die neue Standardversion   |
| ct=install` | der Datei. Damit gehen lokale Änderungen in der Datei  |
|             | zumindest teilweise verloren.                          |
+-------------+--------------------------------------------------------+
| `--conf     | Bricht das Update im Konfliktfall ab und stellt die    |
| lict=abort` | vorherige Konfiguration der alten Version wieder her.  |
+-------------+--------------------------------------------------------+
| `--co       | Dies ist das Standardverhalten, somit ist die Option   |
| nflict=ask` | in dieser Form eigentlich wirkungslos.                 |
+-------------+--------------------------------------------------------+

::: paragraph
Ein Beispiel für den kompletten Befehl für ein automatisches Update der
Instanz `mysite` auf die Version `2.3.0p1.cee`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd stop mysite ; omd -f -V 2.3.0p1.cee update --conflict=install mysite && omd start mysite
```
:::
::::

::: paragraph
Durch das `&&` vor dem `omd start` wird ein Starten der Instanz
verhindert, falls das `omd update` mit einem Fehler abbricht. Ersetzen
Sie das `&&` durch ein Semikolon (`;`), falls Sie einen Start auch in
diesem Fall unbedingt versuchen wollen.
:::

::: paragraph
Falls Sie sicher sind, dass Sie nur eine einzige Checkmk-Instanz auf dem
Server haben, können Sie deren Namen zur Verwendung in einem
Shell-Skript einfach in einer Variable einfangen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd sites --bare
mysite
root@linux# SITENAME=$(omd sites --bare)
root@linux# echo $SITENAME
mysite
```
:::
::::

::: paragraph
Das ermöglicht Ihnen, obige Zeile vom Namen der Instanz unabhängig zu
machen. Ein kleines Shell-Skript könnte z.B. so aussehen:
:::

::::: listingblock
::: title
update.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
SITE=$(omd sites --bare)
VERSION=2.3.0p1.cee

omd stop $SITE
omd -f -V $VERSION update --conflict=install $SITE  && omd start $SITE
```
:::
:::::
:::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#updatedistributed .hidden-anchor .sr-only}4. Update in verteilten Umgebungen {#heading_updatedistributed}

::::::::::::::::: sectionbody
::: paragraph
Es gibt zwei unterschiedliche Vorgehensweisen, um das Update aller in
einem [verteilten Monitoring](distributed_monitoring.html) beteiligten
Instanzen -- d.h. der Zentralinstanz und der Remote-Instanzen --
durchzuführen.
:::

::: paragraph
**Wichtig:** Für welches Vorgehen Sie sich auch entscheiden: Sie sollten
auch in diesem Szenario vorher [Backups](backup.html) aller Instanzen
anlegen.
:::

::: paragraph
Das bevorzugte, sichere Vorgehen ist das *Update in einem Rutsch*, bei
dem Sie folgende Schritte ausführen:
:::

::: {.olist .arabic}
1.  Zunächst stoppen Sie alle Instanzen.

2.  Führen Sie dann das Update für alle Instanzen durch.

3.  Starten Sie die aktualisierten Instanzen wieder.
:::

::: paragraph
Ist dies nicht möglich -- beispielsweise, weil die Umgebung auf
Instanzen in verschiedenen Zeitzonen und betreuenden Teams verteilt ist
-- kann unter strengen Auflagen ein vorübergehender Mischbetrieb
erfolgen. Der Versionsunterschied darf bei Major-Updates exakt eine
Version betragen und setzt immer ein bestimmtes Patchlevel der
Ausgangsversion voraus.
:::

::: paragraph
Diese Reihenfolge muss dafür unbedingt eingehalten werden: Zunächst
nehmen Sie die Aktualisierung aller Remote-Instanzen vor, erst als
letztes führen Sie das Update der Zentralinstanz durch. So ist
sichergestellt, dass zu keinem Zeitpunkt eine von einer neueren
Checkmk-Version erzeugte Konfiguration bei einer älteren Checkmk-Version
landet.
:::

::: paragraph
Die folgende Tabelle zeigt die möglichen Kombinationen beim Update von
[2.2.0]{.new} zur [2.3.0]{.new}:
:::

+-----------+-----------+-----------+----------------------------------+
| Zentr     | Remot     | Erlaubt?  | Hinweise                         |
| alinstanz | e-Instanz |           |                                  |
+===========+===========+===========+==================================+
| [2.2      | [2.2      | Ja        | Zustand vor dem Update aller     |
| .0]{.new} | .0]{.new} |           | Instanzen.                       |
+-----------+-----------+-----------+----------------------------------+
| [2.2      | [2.3      | Ja        | Während des Updates sind         |
| .0]{.new} | .0]{.new} |           | kleinere Funktionseinbußen zu    |
|           |           |           | erwarten, halten Sie den         |
|           |           |           | Mischbetrieb daher kurz. Es      |
|           |           |           | besteht keine Gefahr für Daten   |
|           |           |           | und Konfiguration.               |
+-----------+-----------+-----------+----------------------------------+
| [2.3      | [2.2      | **Nein**  | **Achtung:** Bei [zentraler      |
| .0]{.new} | .0]{.new} |           | Konfiguration](distrib           |
|           |           |           | uted_monitoring.html#distr_wato) |
|           |           |           | besteht hier die Gefahr,         |
|           |           |           | Remote-Instanzen irreparabel zu  |
|           |           |           | beschädigen. Vermeiden Sie       |
|           |           |           | diesen Zustand unbedingt!        |
+-----------+-----------+-----------+----------------------------------+
| [2.3      | [2.3      | Ja        | Zustand nach dem Update aller    |
| .0]{.new} | .0]{.new} |           | Instanzen.                       |
+-----------+-----------+-----------+----------------------------------+

::::: sect2
### []{#_technische_hintergründe .hidden-anchor .sr-only}4.1. Technische Hintergründe {#heading__technische_hintergründe}

::: paragraph
Der technische Grund für die Vorgehensweise liegt in den verwendeten
Protokollen: Die Zentralinstanz greift auf die Daten der
Remote-Instanzen primär lesend via [Livestatus](glossar.html#livestatus)
zu. Bei [zentraler
Konfiguration](distributed_monitoring.html#distr_wato) zudem schreibend
über eine nicht öffentliche HTTP-API. In beiden Fällen gilt, dass neue
Versionen echte Obermengen der verwendeten Protokolle einführen. So
nutzt eine ältere Zentralinstanz nur eine echte Teilmenge der
Funktionalität der neueren Remote-Instanzen. Würde man die
Zentralinstanz zuerst aktualisieren, würde sie bei den Remote-Instanzen
möglicherweise API-Aufrufe oder Livestatus-Anfragen verwenden, welche
diese noch nicht verstehen.
:::

::: paragraph
Der maximale Versionsunterschied *einer* Major-Version resultiert
wiederum daraus, dass die Entfernung von Schnittstellen mit einer
*Schonfrist* genau einer Version einhergeht. So wurde die Web-API intern
bereits von Checkmk [2.1.0]{.new} nicht mehr benutzt, ihre Abschaffung
erfolgte aber erst mit Version [2.2.0]{.new}. Aus diesem Grund arbeitet
eine [2.1.0]{.new} Zentralinstanz mit [2.2.0]{.new} Remote-Instanzen
zusammen, nicht jedoch eine [2.0.0]{.new} Zentralinstanz mit
[2.2.0]{.new} Remote-Instanzen.
:::
:::::

:::: sect2
### []{#_erweiterungspakete_bei_zentraler_konfiguration .hidden-anchor .sr-only}4.2. Erweiterungspakete bei zentraler Konfiguration {#heading__erweiterungspakete_bei_zentraler_konfiguration}

::: paragraph
Um die phasenweise Aktualisierung zu erleichtern, bietet Checkmk die
Möglichkeit, gleichnamige Erweiterungspakete in verschiedenen Versionen
-- eines passend zur älteren Zentralinstanz, eines passend zu den
neueren Remote-Instanzen -- zu hinterlegen. Aktiviert wird das jeweils
passende. Details beschreibt der [Artikel zu Erweiterungspaketen
(MKPs)](mkps.html).
:::
::::

:::: sect2
### []{#_cascading_livestatus .hidden-anchor .sr-only}4.3. Cascading Livestatus {#heading__cascading_livestatus}

::: paragraph
Bei der Verwendung von
[Viewer-Instanzen](distributed_monitoring.html#viewer) dürfen die
Viewer-Instanzen erst nach den Instanzen aktualisiert werden, deren
Daten sie anzeigen. Zeigt eine Viewer-Instanz nur Daten von
Remote-Instanzen, kann deren Aktualisierung erfolgen, sobald diese
aktualisiert sind. Zeigt sie dagegen auch Daten der Zentralinstanz, darf
ihre Aktualisierung erst als letztes stattfinden.
:::
::::
:::::::::::::::::
::::::::::::::::::

:::::::::: sect1
## []{#updatedocker .hidden-anchor .sr-only}5. Update eines Docker-Containers {#heading_updatedocker}

::::::::: sectionbody
::: paragraph
Der Update-Prozess für eine Checkmk-Instanz im Docker-Container ist sehr
einfach. Es gibt lediglich die folgenden Voraussetzungen:
:::

::: ulist
- Der Container wird nicht gelöscht, wenn er gestoppt wird. Das heißt,
  die Option `--rm` wurde beim Starten nicht benutzt.

- Sie kennen die ID des Datenspeichers (*volume*) zum Container.
  Normalerweise sollten Sie beim Start des Containers seinem Speicher
  eine eindeutige ID gegeben haben. Wenn Sie sich unsicher sind, wie die
  ID Ihres Volumes ist, können Sie Informationen zum Container namens
  `myContainer` mit dem [Kommando](managing_docker.html#commands)
  `docker inspect myContainer` abrufen.
:::

::: paragraph
Wenn Sie der [Installationsanleitung für Checkmk in
Docker](introduction_docker.html) gefolgt sind, sollten Sie die
Voraussetzungen automatisch erfüllt haben.
:::

::: paragraph
Die Aktualisierung selbst ist in 3 Schritten erledigt:
:::

::: {.olist .arabic}
1.  Stoppen Sie den Container. Wenn der Checkmk-Container `myContainer`
    heißt, lautet der Befehl: `docker stop myContainer`.

2.  Entfernen Sie den Container. Der Befehl dazu ist:
    `docker rm myContainer`.

3.  Starten Sie einen neuen Container mit dem Befehl
    `docker container run` mit der gewünschten Version und binden Sie
    das bekannte Volume ein. Wenn Ihr Volume `myVolume` heißt, ist die
    entsprechende Option `-v myVolume:/omd/sites`. Alle Optionen des
    Kommandos finden Sie in der [Installationsanleitung für Checkmk in
    Docker.](introduction_docker.html)
:::

::: paragraph
Danach wird Checkmk automatisch den Rest erledigen und Ihre
Checkmk-Instanz aktualisieren und starten. Sie können sich danach wie
gewohnt anmelden.
:::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::::::::::: sect1
## []{#upgrade .hidden-anchor .sr-only}6. Upgrades {#heading_upgrade}

::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Upgrades von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** auf eine der kommerziellen Editionen oder von einer der
kommerziellen Editionen auf eine andere mit größerem Funktionsumfang
sind jederzeit unkompliziert möglich. Das Vorgehen ist im wesentlichen
immer gleich: Installieren Sie das gewünschte Paket und stellen Sie
betroffene Instanzen mit `omd update` um. Wenn Sie auf eine der
kommerziellen Editionen upgraden, müssen Sie diese nach dem Upgrade
[lizenzieren.](license.html)
:::

::: paragraph
Beim Upgrade einer kommerziellen Version auf eine mit größerem
Funktionsumfang ist immer *nach* dem Upgrade die Lizenz neu einzutragen.
Dies gilt auch für Fälle, in denen Ihr Sales-Kontakt zugesichert hat,
dass Sie nach einem Lizenz-Upgrade Ihre \"niedrigere\" Checkmk-Umgebung
bereits mit der \"höheren\" Lizenz nutzen können: Beim Upgrade wird der
Lizenzstatus zurückgesetzt (die Historie bleibt erhalten), daher muss
die Lizenz neu hinterlegt werden.
:::

::::::::::: sect2
### []{#updateraw .hidden-anchor .sr-only}6.1. Upgrade Checkmk Raw auf eine der kommerziellen Editionen {#heading_updateraw}

::: paragraph
Dieses Kapitel deckt primär das Upgrade zu Checkmk Enterprise ab. Sie
können in einem Schritt auch zu Checkmk Cloud upgraden, beachten Sie in
diesem Fall jedoch auch die Hinweise im folgenden Abschnitt.
:::

::: paragraph
Da die kommerziellen Editionen etliche zusätzliche Module und Features
haben, gibt es nach der Umstellung ein paar Dinge zu beachten. Der
entscheidende Punkt ist, dass beim Anlegen von *neuen* Instanzen der
Checkmk Raw bzw. der kommerziellen Editionen *unterschiedliche
Standardeinstellungen* gesetzt werden.
:::

:::: sect3
#### []{#_nagios_vs_cmc .hidden-anchor .sr-only}Nagios vs. CMC {#heading__nagios_vs_cmc}

::: paragraph
Da Checkmk Raw nur Nagios als Kern unterstützt, ist dieser bei Instanzen
voreingestellt, die mit Checkmk Raw erstellt wurden. Diese Einstellung
bleibt beim Upgrade auf
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise** erhalten. Das bedeutet, dass Sie nach einem
Upgrade zunächst weiterhin mit Nagios als Kern fahren. Eine Umstellung
auf den CMC erfolgt auf der Kommandozeile mit `omd config` oder in
[Setup \> Global settings]{.guihint} und wird in dem Artikel zur
[Migration auf den CMC](cmc_migration.html) beschrieben.
:::
::::

:::: sect3
#### []{#_rrd_format .hidden-anchor .sr-only}RRD-Format {#heading__rrd_format}

::: paragraph
Die kommerziellen Editionen unterstützen ein alternatives Format für die
Speicherung historischer Messdaten, welches deutlich weniger Platten-I/O
erzeugt. Bei neuen Instanzen der kommerziellen Editionen ist dies
automatisch voreingestellt. Instanzen Checkmk Raw werden auch hier beim
Upgrade nicht automatisch umgestellt. Wie das Umstellen geht, beschreibt
ein eigener [Abschnitt](graphing.html#rrdformat) im Artikel über
Messwerte und Graphen.
:::
::::

:::: sect3
#### []{#_weitere_unterschiede .hidden-anchor .sr-only}Weitere Unterschiede {#heading__weitere_unterschiede}

::: paragraph
Um vollen Nutzen aus Checkmk Enterprise ziehen zu können, beachten Sie
die Übersicht der Unterschiede zwischen Checkmk Raw und [Checkmk
Enterprise.](cse.html)
:::
::::
:::::::::::

::::::::: sect2
### []{#cee2cce .hidden-anchor .sr-only}6.2. Upgrade von Checkmk Enterprise auf Checkmk Cloud {#heading_cee2cce}

::: paragraph
Am Monitoring-Kern und dem Benachrichtigungssystem gibt es keine
Unterschiede zwischen Checkmk Enterprise und Checkmk Cloud. Je nach
Schwerpunkt des Einsatzes werden Sie den größeren Funktionsumfang oft
erst beim Hinzufügen neuer Hosts nutzen. An einigen Stellen ist dennoch
die Überprüfung der vorhandenen Einstellungen angeraten.
:::

::: paragraph
Eine vollständige Übersicht der zusätzlichen Funktionalität bietet der
Artikel zu [Checkmk Cloud.](cce.html)
:::

:::: sect3
#### []{#_check_plugins_für_cloud_services .hidden-anchor .sr-only}Check-Plugins für Cloud-Services {#heading__check_plugins_für_cloud_services}

::: paragraph
Wenn Sie [Amazon Web Services (AWS),](monitoring_aws.html) [Microsoft
Azure](monitoring_azure.html) oder [Google Cloud Platform
(GCP)](monitoring_gcp.html) überwachen, sind die Checkmk Cloud
vorbehaltenen Services bestehender Hosts zunächst nicht aktiviert. Sie
können diese in der Regel [XYZ services to monitor]{.guihint} (wobei XYZ
für den Namen der Cloud-Plattform steht) aktivieren. Führen Sie
anschließend eine [Service-Erkennung](glossar.html#service_discovery)
bei diesen Hosts durch, um die nun verfügbaren Services zu finden.
:::
::::

:::: sect3
#### []{#_agent_controller_im_push_modus .hidden-anchor .sr-only}Agent Controller im Push-Modus {#heading__agent_controller_im_push_modus}

::: paragraph
Mit der Möglichkeit, Hosts direkt zu überwachen, welche zwar den
Checkmk-Server erreichen können, aber nicht von diesem erreichbar sind,
fällt in vielen Fällen die Notwendigkeit selbst gestrickter Lösungen mit
[Datenquellen-Programmen](datasource_programs.html) weg. Sie können
diese Hosts [auf Push-Modus umstellen](agent_linux.html#changepush) und
so direktes Monitoring ermöglichen.
:::
::::
:::::::::

:::::::::::::::::::: sect2
### []{#editiondistributed .hidden-anchor .sr-only}6.3. Editions-Upgrades in verteilten Umgebungen {#heading_editiondistributed}

::: paragraph
Beachten Sie, dass in verteilten Umgebungen immer zuerst das Update der
Version durchgeführt werden muss, bevor das Upgrade der Edition folgen
kann. Eine andere Reihenfolge oder ein *Crossgrade* (Update der Version
und Upgrade der Edition in einem Schritt) ist nicht vorgesehen. Als
generelles Vorgehen empfehlen wir das Offline-Upgrade, bei dem von einer
beliebigen niedrigeren Edition auf eine beliebige höhere Edition
gesprungen werden kann.
:::

::: paragraph
Bei zwei häufig nachgefragten Upgrade-Szenarien ([Checkmk Raw nach
Checkmk Enterprise](#cre2cee_distributed) und [Checkmk Enterprise nach
Checkmk Cloud](#cee2cce_distributed)) ist ein Mischbetrieb für einen
eingeschränkten Zeitraum möglich. Während das Offline-Upgrade mit allen
Versionen funktioniert, erfordern die beiden Online-Szenarien wenigstens
Checkmk [2.2.0]{.new}p23.
:::

:::::: sect3
#### []{#offline_distributed .hidden-anchor .sr-only}Offline-Upgrade (alle Kombinationen) {#heading_offline_distributed}

::: paragraph
Da das Mischen von Editionen nur in wenigen Kombinationen möglich ist,
empfehlen wir grundsätzlich, das Upgrade der Edition *offline*
durchzuführen. Gehen Sie dafür wie folgt vor:
:::

::: {.olist .arabic}
1.  Stoppen Sie alle Instanzen.

2.  Führen Sie das Upgrade der Zentralinstanz durch.

3.  Wenn Sie möchten (und eine Fülle von Benachrichtigungen kein Problem
    darstellt), können Sie die Zentralinstanz sofort wieder starten.

4.  Nun steht das Upgrade der Remote-Instanzen an. Dieses können Sie
    parallel durchführen und einzelne Remote-Instanzen nach dem Upgrade
    sofort wieder starten.
:::

::: paragraph
Selbstverständlich können Sie mit dem Start warten, bis alle Instanzen
das Upgrade erhalten haben, was die Zahl von Benachrichtigungen etwas
reduziert.
:::
::::::

:::::::: sect3
#### []{#cre2cee_distributed .hidden-anchor .sr-only}Checkmk Raw nach Checkmk Enterprise (online) {#heading_cre2cee_distributed}

::: paragraph
Checkmk erlaubt nur den Mischbetrieb von Checkmk Enterprise als
Zentralinstanz mit Checkmk Raw oder Checkmk Cloud als Remote-Instanzen.
Für das Upgrade nach Checkmk Enterprise bedeutet dies, dass die
Zentralinstanz das Update *zuerst* erhält. Während des Mischbetriebes
sollte keine Übertragung der Konfiguration von der Zentralinstanz zu den
Remote-Instanzen durchgeführt werden, die noch kein Upgrade erhalten
haben. Daher empfehlen wir, für die Dauer des Mischbetriebes auf der
Zentralinstanz via [Setup \> General \> Read only mode]{.guihint} die
Änderung der Konfiguration zu unterbinden. Theoretisch kann dieser
Mischbetrieb von Checkmk Enterprise als Zentralinstanz mit Checkmk Raw
als Remote-Instanz beliebig lange währen.
:::

::: paragraph
Für das Upgrade ergibt sich daraus folgende Reihenfolge:
:::

::: {.olist .arabic}
1.  Führen Sie das Upgrade der Zentralinstanz auf Checkmk Enterprise
    durch.

2.  Geben Sie die Subskriptionsdaten ein und übermitteln Sie diese, wie
    im Artikel zur [Lizenzierung](license.html) beschrieben. Die von
    allen Remote-Instanzen bereitgestellten Services werden bei der
    Berechnung der Subskription gleich behandelt, das heißt während des
    Mischbetriebes werden Services von Checkmk Raw Remote-Instanzen
    bereits als Checkmk Enterprise abgerechnet.

3.  Aktualisieren Sie nach und nach die Remote-Instanzen.

4.  Falls Sie die Übertragung der Konfiguration nicht global, sondern
    für jede Remote-Instanz separat deaktiviert haben, können Sie die
    Übertragung der Konfiguration für jede Remote-Instanz, welche das
    Upgrade erhalten hat, wieder aktivieren.

5.  Im verteilten Monitoring ohne [verteiltes
    Setup](glossar.html#distributed_setup) müssen auch die
    Remote-Instanzen gleich nach dem Upgrade lizenziert werden.
:::

::: paragraph
Nach dem Upgrade aller Instanzen können Sie die Checkmk Enterprise
spezifischen Features aktivieren.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | **Warum empfehlen wir, während    |
|                                   | des Upgrades auf die              |
|                                   | Synchronisation der Konfiguration |
|                                   | zu verzichten?**                  |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Tatsächlich verwerfen             |
|                                   | Remote-Instanzen Einstellungen,   |
|                                   | mit denen sie \"nichts anfangen\" |
|                                   | können. Dadurch geht zwar nichts  |
|                                   | kaputt, aber es kann einiges      |
|                                   | durcheinander kommen. Nehmen wir  |
|                                   | an, Sie aktivieren eine Checkmk   |
|                                   | Enterprise spezifische            |
|                                   | Einstellung -- beispielsweise     |
|                                   | [regelmäßige                      |
|                                   | Wartungszeiten]                   |
|                                   | (basics_downtimes.html#scheduled) |
|                                   | --, bevor alle Remote-Instanzen   |
|                                   | das Upgrade erhalten haben. In    |
|                                   | diesem Fall verwerfen Checkmk     |
|                                   | Raw-Instanzen die Einstellung,    |
|                                   | woraus folgt, dass diese auch     |
|                                   | nach dem Upgrade nicht zur        |
|                                   | Verfügung steht. Erst nach        |
|                                   | erneuter Änderung der betroffenen |
|                                   | Einstellung nach dem Upgrade      |
|                                   | steht diese zur Verfügung.        |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Sollte es unvermeidbar sein,      |
|                                   | während des Upgrades auf die      |
|                                   | Synchronisation der Konfiguration |
|                                   | zu verzichten, prüfen Sie nach    |
|                                   | dem vollständigen Upgrade die     |
|                                   | Konsistenz der Checkmk Enterprise |
|                                   | spezifischen Einstellungen.       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::

::::::: sect3
#### []{#cee2cce_distributed .hidden-anchor .sr-only}Checkmk Enterprise nach Checkmk Cloud (online) {#heading_cee2cce_distributed}

::: paragraph
Wie bereits erwähnt, erlaubt Checkmk nur den Mischbetrieb von Checkmk
Enterprise als Zentralinstanz mit Checkmk Raw oder Checkmk Cloud als
Remote-Instanzen. Für das Upgrade nach Checkmk Cloud bedeutet dies, dass
die Zentralinstanz das Update *zuletzt* erhält. Das Upgrade der gesamten
Umgebung muss in 30 Tagen abgeschlossen sein. Während des Mischbetriebes
kann die Übertragung der Konfiguration von der Zentralinstanz zu den
Remote-Instanzen durchgeführt werden.
:::

::: paragraph
Daraus resultiert folgende Reihenfolge für das Upgrade:
:::

::: {.olist .arabic}
1.  Führen Sie das Upgrade der Remote-Instanzen auf Checkmk Cloud durch.
    **Wichtig:** Nur im 30 Tage währenden Lizenzstatus „Trial" ist der
    Mischbetrieb mit Checkmk Enterprise als Zentralinstanz möglich.
    Hinterlegen Sie also noch keine Checkmk Cloud-Subskriptionsdaten!

2.  Hinterlegen Sie in der Zentralinstanz noch unter Checkmk Enterprise
    die Subskriptionsdaten für Checkmk Cloud.

3.  Führen Sie das Upgrade der Zentralinstanz auf Checkmk Cloud durch.

4.  Im verteilten Monitoring ohne [verteiltes
    Setup](glossar.html#distributed_setup) müssen nun auch die
    Remote-Instanzen gleich nach dem Upgrade lizenziert werden.
:::

::: paragraph
Soll ein Upgrade direkt von Checkmk Raw auf Checkmk Cloud erfolgen,
müssen Sie auf der Zentralinstanz als Zwischenschritt auf Checkmk
Enterprise hieven: Zuerst führen Sie das Upgrade der Zentralinstanz von
Checkmk Raw nach Checkmk Enterprise durch, es folgt das Upgrade der
Remote-Instanzen direkt von Checkmk Raw nach Checkmk Cloud. Zuletzt
führen Sie noch das Upgrade der Zentralinstanz von Checkmk Enterprise
nach Checkmk Cloud durch.
:::
:::::::
::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::: sect1
## []{#down2cee .hidden-anchor .sr-only}7. Downgrades {#heading_down2cee}

::::::::::::::::::::::::: sectionbody
::: paragraph
Auch Downgrades zwischen den Editionen sind vorgesehen. Ein Downgrade
ist eine komplexere und damit zeitaufwändigere Aktion, da einige
Funktionen in der Zielversion möglicherweise nicht funktionieren und
manuell deaktiviert und durch eine möglicherweise weniger effiziente
oder weniger komfortable Alternative ersetzt werden müssen.
:::

::: paragraph
Das eigentliche Downgrade **muss** - genau wie beim Update oder
Upgrade - mit dem Befehl `omd update` durchgeführt werden. Die Details
dazu finden Sie im im Abschnitt [Durchführen des Updates.](#execute)
:::

::: paragraph
Wenn Sie nun beispielsweise von der Checkmk Cloud auf die Checkmk
Enterprise downgraden wollen, überzeugt sich Checkmk, ob das tatsächlich
Ihre Intention ist:
:::

:::: imageblock
::: content
![update downgrade ce
se](../images/update_downgrade_ce_se.png){width="30%"}
:::
::::

::: paragraph
Sobald Sie diese Abfrage mit [yes]{.guihint} bestätigen, geht das
Downgrade unmittelbar los. Informieren Sie sich im Folgenden unbedingt,
was **vor** diesem Downgrade zu erledigen ist.
:::

::: paragraph
Andere Downgrades als die im folgenden beschriebenen sind nicht
vorgesehen und werden von uns nicht unterstützt, beispielsweise ein
Downgrade von Checkmk MSP. Stattdessen empfehlen wir, in einem solchen
Fall mit einer frischen Instanz zu beginnen.
:::

:::::::: sect2
### []{#cce2cee .hidden-anchor .sr-only}7.1. Downgrade von Checkmk Cloud nach Checkmk Enterprise {#heading_cce2cee}

::: paragraph
Als Vorbereitung für das Downgrade von Checkmk Cloud nach Checkmk
Enterprise müssen Sie mindestens die folgenden Änderungen vornehmen:
:::

::: ulist
- Stellen Sie Hosts, die im Push-Modus arbeiten, auf
  [Pull-Modus](agent_linux.html#changepush) um. Andernfalls empfängt
  Checkmk von diesen keine Monitoring-Daten und betroffene Hosts werden
  im Regelfall [*stale*.](monitoring_basics.html#stale)

- Konfigurieren Sie die Agentenpakete für Ordner so um, dass keine
  [Autoregistrierung](hosts_autoregister.html) mehr vorgenommen wird.
  Backen Sie anschließend die Agentenpakete neu.
:::

::: paragraph
Ferner stehen nicht mehr alle Cloud-Services und weniger Dashboards zur
Verfügung. Als Folge werden Sie [verschwundene
Services](wato_services.html#vanished) aufräumen müssen.
:::

::: paragraph
Falls Sie unter Checkmk Cloud das [Grafana-Plugin](grafana.html) aus dem
„Grafana Store" genutzt haben, müssen sie dieses durch ein aus dem
Zip-Archiv installiertes ersetzen.
:::

::: paragraph
Eine Übersicht der Unterschiede zwischen Checkmk Cloud und Checkmk
Enterprise liefert der [Artikel zu Checkmk Cloud.](cce.html)
:::
::::::::

:::::: sect2
### []{#cee2cre .hidden-anchor .sr-only}7.2. Downgrade von Checkmk Enterprise nach Checkmk Raw {#heading_cee2cre}

::: paragraph
Als Vorbereitung für das Downgrade von Checkmk Enterprise nach Checkmk
Raw müssen Sie mindestens die folgenden Änderungen vornehmen:
:::

::: ulist
- Änderung des RRD-Datenbankformats mit der Regel [Configuration of RRD
  databases of hosts]{.guihint} auf [Multiple RRDs per
  host/service.]{.guihint} Neben leichten Performance-Nachteilen ist
  hier anzumerken, dass eine Konvertierung nicht vorgesehen ist, demnach
  historische Monitoring-Daten nicht mehr sichtbar sind.

- Umschalten des Monitoring-Kerns von CMC auf Nagios -- von dieser
  Änderung sind in erster Linie Performance-Nachteile zu erwarten.
:::

::: paragraph
Daneben sind nicht mehr alle Dashboards, Graphen-Einstellungen,
Benachrichtigungs-Plugins und Spezialagenten verfügbar. Im [Artikel zu
Checkmk Enterprise](cse.html) können Sie ermitteln, wie viel Checkmk
Enterprise-Funktionalität im Falle des Downgrades nach Checkmk Raw
wegfällt und wo Sie gegebenenfalls weitere Anpassungen vornehmen müssen.
:::
::::::

::::::: sect2
### []{#editiondistributed_down .hidden-anchor .sr-only}7.3. Editions-Downgrades in verteilten Umgebungen {#heading_editiondistributed_down}

::: paragraph
Die in den beiden vorherigen Abschnitten vorgestellten
Downgrade-Szenarien können auch in verteilten Umgebungen durchgeführt
werden. Beachten Sie, dass in verteilten Umgebungen immer zuerst das
Update der Version durchgeführt werden muss, bevor das Downgrade der
Edition folgen kann. Eine andere Reihenfolge oder ein *Crossgrade*
(Update der Version und Downgrade der Edition in einem Schritt) ist
nicht vorgesehen.
:::

::: paragraph
In keinem Downgrade-Szenario unterstützt Checkmk den Mischbetrieb
zwischen unterschiedlichen Editionen. Aus diesem Grund empfehlen wir
dringend, das Downgrade der Edition *offline* durchzuführen. Gehen Sie
dafür wie folgt vor:
:::

::: {.olist .arabic}
1.  Stoppen Sie alle Instanzen.

2.  Führen Sie das Downgrade der Zentralinstanz durch.

3.  Wenn Sie möchten (und eine Fülle von Benachrichtigungen kein Problem
    darstellt), können Sie die Zentralinstanz sofort wieder starten.

4.  Nun steht das Downgrade der Remote-Instanzen an. Dieses können Sie
    parallel durchführen und Remote-Instanzen nach dem Downgrade sofort
    wieder starten.
:::

::: paragraph
Selbstverständlich können Sie mit dem Start warten, bis alle Instanzen
das Downgrade erhalten haben, was die Zahl von Benachrichtigungen etwas
reduziert.
:::
:::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#uninstall .hidden-anchor .sr-only}8. Deinstallation von Checkmk {#heading_uninstall}

:::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_übersicht .hidden-anchor .sr-only}8.1. Übersicht {#heading__übersicht}

::: paragraph
Das Deinstallieren von nicht mehr benötigten Checkmk-Versionen geschieht
mit dem Paketmanager des Betriebssystems. Geben Sie hier den Namen des
installierten Pakets an, *nicht* den Dateinamen der ursprünglichen
RPM/DEB-Datei. Wichtig: Löschen Sie nur solche Checkmk-Versionen, die
von keiner Instanz mehr verwendet werden!
:::

::: paragraph
Nicht mehr benötigte Checkmk-Instanzen können Sie einfach mit `omd rm`
entfernen (und dabei alle Daten löschen!):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd rm mysite
```
:::
::::
:::::::

::::::::: sect2
### []{#_sles_red_hat_enterprise_linux_centos .hidden-anchor .sr-only}8.2. SLES, Red Hat Enterprise Linux, CentOS {#heading__sles_red_hat_enterprise_linux_centos}

::: paragraph
So finden Sie bei RPM-basierten Systemen heraus, welche Checkmk-Pakete
installiert sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -qa | grep check-mk
check-mk-enterprise-2.3.0p1-el9-38.x86_64.rpm
check-mk-raw-2.2.0p25-el9-38.x86_64.rpm
check-mk-raw-2.1.0p34-el8-38.x86_64.rpm
```
:::
::::

::: paragraph
Das Löschen geschieht mit `rpm -e`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -e check-mk-raw-2.1.0p34-el8-38.x86_64.rpm
```
:::
::::
:::::::::

::::::::: sect2
### []{#_debian_ubuntu .hidden-anchor .sr-only}8.3. Debian, Ubuntu {#heading__debian_ubuntu}

::: paragraph
So finden Sie heraus, welche Pakete installiert sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg -l | grep check-mk
ii  check-mk-enterprise-2.3.0p1  0.jammy  amd64  Checkmk - Best-in-class infrastructure & application monitoring
ii  check-mk-raw-2.2.0p25        0.jammy  amd64  Checkmk - Best-in-class infrastructure & application monitoring
ii  check-mk-raw-2.1.0p34        0.jammy  amd64  Checkmk - Best-in-class infrastructure & application monitoring
```
:::
::::

::: paragraph
Die Deinstallation geschieht mit `dpkg --purge`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg --purge check-mk-raw-2.1.0p34
(Reading database ... 567850 files and directories currently installed.)
Removing check-mk-raw-2.1.0p34 (0.jammy) ...
...
```
:::
::::
:::::::::
::::::::::::::::::::::
:::::::::::::::::::::::

:::::: sect1
## []{#diagnose .hidden-anchor .sr-only}9. Diagnosemöglichkeiten {#heading_diagnose}

::::: sectionbody
::: paragraph
Sollte es beim Update von Checkmk mal zu einem Fehler kommen, liegt
diesem zumeist eine der folgenden drei Ursachen zugrunde, die bereits in
den vorherigen Kapiteln angesprochen wurden:
:::

::: ulist
- Der durch eine [inkompatible Änderung](#incompatible) notwendige
  manuelle Eingriff wurde nicht vorgenommen.

- Sie haben ein [inkompatibles Erweiterungspaket
  (MKP)](#incompatible_mkps) installiert.

- Es befinden sich inkompatible Skripte in den [lokalen
  Dateien](#local_files) der Instanzverzeichnisstruktur.
:::
:::::
::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}10. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: paragraph
Hier finden Sie für diesen Artikel relevante Dateien und Verzeichnisse.
Pfade, die nicht mit einem `/` beginnen, gelten wie immer ab dem
Home-Verzeichnis der Instanz (`/omd/sites/mysite`).
:::

+-----------------+-----------------------------------------------------+
| Pfad            | Bedeutung                                           |
+=================+=====================================================+
| `~/version`     | Symbolischer Link auf die Installation der von      |
|                 | dieser Instanz verwendeten Checkmk-Version.         |
+-----------------+-----------------------------------------------------+
| `/omd/versions` | In diesem Verzeichnis existiert für jede            |
|                 | installierte Checkmk-Version ein Unterverzeichnis.  |
|                 | Die Dateien gehören `root` und werden niemals       |
|                 | geändert.                                           |
+-----------------+-----------------------------------------------------+
| `/omd/sites`    | In diesem Verzeichnis liegt für jede Instanz deren  |
|                 | Home-Verzeichnis mit den Konfigurationsdateien und  |
|                 | den variablen Daten. Die Dateien gehören dem        |
|                 | Instanzbenutzer und werden durch Konfiguration und  |
|                 | Betrieb geändert.                                   |
+-----------------+-----------------------------------------------------+
| `/usr/bin/omd`  | Verwaltungsbefehl für Checkmk-Instanzen. Dies ist   |
|                 | ein symbolischer Link in das `bin`-Verzeichnis der  |
|                 | Standardversion. Sobald auf eine bestimmte Instanz  |
|                 | zugegriffen wird, ersetzt sich der `omd`-Befehl     |
|                 | selbst durch denjenigen der passenden Version.      |
+-----------------+-----------------------------------------------------+
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
