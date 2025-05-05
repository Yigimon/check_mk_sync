:::: {#header}
# Linux-Upgrade auf dem Checkmk-Server

::: details
[Last modified on 27-Apr-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/release_upgrade.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
von Checkmk](install_packages.html) [Update-Matrix für Version
[2.3.0]{.new}](update_matrix.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
::: paragraph
Für das Release-Upgrade der Linux-Distribution auf einem Checkmk-Server
gibt es verschiedene empfohlene Methoden. Welche davon für Sie die
richtige ist, hängt von den Möglichkeiten Ihrer IT-Landschaft, dem
Datenbestand der Checkmk-Installation und der angestrebten Ausfallzeit
ab. Die unterschiedlichen Methoden mit Ihren jeweiligen Voraussetzungen
stellen wir hier vor.
:::

::: paragraph
Im Wesentlichen ist das zum einen die Aktualisierung an Ort und Stelle
-- in der Archäologie oder Paläontologie wird die Arbeit am Fundort auf
Lateinisch *in situ* genannt. Und zum anderen die Sicherung als Archiv,
auf welche die Neuinstallation des Grundsystems und schließlich die
Wiederherstellung eben jenen Archivs erfolgt -- nicht unähnlich zur
Arbeit im Labor *ex situ*. Englisch wird für die beiden Verfahren
mitunter analog *in-place* oder *out-of-place* verwendet.
:::

::: paragraph
Auch Kombinationen der vorgestellten Methoden sind möglich, zum
Beispiel, wenn Sie `/opt/omd` oder `/opt/omd/sites` auf einem eigenen
Mount-Punkt abgelegt haben.
:::

::: paragraph
Das Release-Upgrade spielen wir hier exemplarisch anhand des Wechsels
von Ubuntu 20.04 (Focal) auf 22.04 (Jammy) durch. Bei anderen
Distributionen weichen die Befehle für Upgrade und Paketmanagement
hiervon mehr oder weniger stark ab.
:::

::: paragraph
Unser Beispielsystem nutzt nur eine einzige
[Instanz.](glossar.html#site) Falls Sie mehrere Instanzen auf dem zu
aktualisierenden System betreiben (beispielsweise eine produktive und
eine zum Testen), sind die instanzspezifischen Befehle für jede zu
wiederholen.
:::

::: paragraph
Wenn Sie ein Release-Upgrade der Linux-Distribution mit einem
[Versions-Update](update_major.html) von Checkmk kombinieren wollen oder
müssen (zum Beispiel weil eine ältere Checkmk-Version nicht mehr für
eine neuere Distributionsversion angeboten wird), bestimmen Sie anhand
unserer [Update-Matrix](update_matrix.html) die geeignete Reihenfolge
der durchzuführenden Schritte.
:::
:::::::::
::::::::::

::::::::: sect1
## []{#getyourbackupdone .hidden-anchor .sr-only}2. Hinweise zum Backup {#heading_getyourbackupdone}

:::::::: sectionbody
::: paragraph
Die Wichtigkeit einer Datensicherung ausreichenden Umfangs, welche auf
Konsistenz geprüft ist, müssen wir IT-Profis nicht wirklich erklären. Im
Idealfall -- beispielsweise beim Betrieb von Checkmk in einer virtuellen
Maschine -- ist eine Vollsicherung leicht durch Kopieren von
Festplatten-Images möglich.
:::

::: paragraph
Wir empfehlen mindestens:
:::

::: ulist
- Eine Sicherung mit den von Checkmk bereitgestellten Tools, entweder
  auf der Kommandozeile mit dem [Befehl
  `omd`](omd_basics.html#omd_backup_restore) oder im
  [Setup](backup.html) erstellt. Dies kann vorbereitend im laufenden
  Betrieb erledigt werden.

- Eine Sicherung des Inhaltes von `/opt/omd/sites` mit Werkzeugen des
  Betriebssystems nach Stoppen der Instanz und Unmount des
  instanzspezifischen `/tmp` Dateisystems. Dies kann im Zuge des
  Upgrades durchgeführt werden.
:::

::: paragraph
Bewahren Sie die Sicherung *separat* von der zu aktualisierenden
Maschine auf und testen Sie das Backup *vor* den ersten Änderungen am
Produktivsystem.
:::

::: paragraph
Falls Sie sich bei der Installation des Checkmk-Servers für ein
*Copy-on-Write-Dateisystem* wie ZFS oder BTRFS entschieden haben,
sollten Sie vor dem Upgrade *Snapshots* erstellen. Diese ersetzen kein
separat gelagertes Backup, können aber bei Wiederherstellung des
Ursprungszustandes nach einem fehlgeschlagenen Upgrade helfen,
Ausfallzeiten erheblich zu reduzieren.
:::
::::::::
:::::::::

::::::::::: sect1
## []{#insitu .hidden-anchor .sr-only}3. Upgrade an Ort und Stelle *(in situ)* {#heading_insitu}

:::::::::: sectionbody
::: paragraph
Diese Methode ist oft beim Einsatz von Checkmk auf dedizierter Hardware
mit großen Datenbeständen sinnvoll, wo das Hinkopieren eines Archivs und
das Herkopieren für dessen Wiederherstellung die Ausfallzeit deutlich
erhöhen würde.
:::

::::: sect2
### []{#_vorbereitung .hidden-anchor .sr-only}3.1. Vorbereitung {#heading__vorbereitung}

::: paragraph
Die Vorbereitung besteht vor allem aus der Entfernung *aller* bereits
jetzt nicht mehr benötigter Checkmk-Pakete. So vermeiden Sie beim
eigentlichen Upgrade Probleme im Paketmanagement. Daneben sollten Sie
bereits jetzt das richtige Checkmk-Installationspaket für die neue
Distributionsversion herunterladen.
:::

::: {.olist .arabic}
1.  Verschaffen Sie sich zuerst einen Überblick über installierte
    Checkmk-Versionen...​

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd versions
    2.2.0p25.cre
    2.3.0p1.cee
    2.3.0p2.cee (default)
    ```
    :::
    ::::

2.  ...​und dann, welche davon tatsächlich im Einsatz sind:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd sites
    SITE      VERSION        COMMENTS
    mysite    2.3.0p2.cee    default version
    ```
    :::
    ::::

    ::: paragraph
    Von diesen müssen sie die Installationspakete für die neue
    Betriebssystemversion herunterladen. **Wichtig:** Die Edition und
    die Versionsnummer von Checkmk müssen exakt der bisher verwendeten
    entsprechen.
    :::

3.  Deinstallieren Sie jetzt alle nicht benutzten Checkmk-Versionen. Im
    folgenden Befehl sorgt der Parameter `--purge` dafür, auch alte
    Konfigurationsdateien zu tilgen.

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# apt-get remove --purge -y check-mk-enterprise-2.3.0p1
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following packages will be REMOVED:
      check-mk-enterprise-2.3.0p1*
    0 upgraded, 0 newly installed, 1 to remove and 1 not upgraded.
    After this operation, 884 MB disk space will be freed.
    (Reading database ... 125980 files and directories currently installed.)
    Removing check-mk-enterprise-2.3.0p1 (0.focal) ...
    (Reading database ... 89444 files and directories currently installed.)
    Purging configuration files for check-mk-enterprise-2.3.0p1 (0.focal) ...
    Processing triggers for systemd (245.4-4ubuntu3.21) ...
    ```
    :::
    ::::
:::
:::::

::::: sect2
### []{#_durchführung .hidden-anchor .sr-only}3.2. Durchführung {#heading__durchführung}

::: paragraph
Und nun zur heißen Phase, in welcher der Checkmk-Server nicht zur
Verfügung steht.
:::

::: {.olist .arabic}
1.  Stoppen Sie Ihre Checkmk-Instanz:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd stop mysite
    ```
    :::
    ::::

2.  Benennen Sie den Softlink um, welcher auf die verwendete
    Checkmk-Installation zeigt. Der folgende Befehl ändert ihn von
    `version` zu `_version`:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# mv -v /opt/omd/sites/mysite/{,_}version
    ```
    :::
    ::::

3.  Jetzt können Sie Checkmk deinstallieren. In diesem Fall behalten Sie
    vorhandene Konfigurationsdateien:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# apt-get remove -y check-mk-enterprise-2.3.0p2
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following packages will be REMOVED:
      check-mk-enterprise-2.3.0p2*
    ...
    ```
    :::
    ::::

4.  Führen Sie das Upgrade von Linux entsprechend der Anleitung des
    jeweiligen Distributors durch. Im Fall von Ubuntu wäre das:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# do-release-upgrade
    ```
    :::
    ::::

    ::: paragraph
    Wird ein Neustart empfohlen, folgen Sie der Empfehlung bevor Sie zum
    nächsten Schritt gehen.
    :::

5.  Machen Sie die Umbenennung des Softlinks rückgängig, welcher auf die
    verwendete Checkmk-Installation zeigt. Der folgende Befehl ändert
    ihn wieder von `_version` zu `version`:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# mv -v /opt/omd/sites/mysite/{_,}version
    ```
    :::
    ::::

6.  Installieren Sie nun das zur neuen Version der verwendeten
    Distribution passendes Paket von Checkmk. Im Falle von Ubuntu genügt
    an dieser Stelle der folgende Befehl:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# apt install /tmp/check-mk-enterprise-2.3.0p2_0.jammy_amd64.deb
    ```
    :::
    ::::

    ::: paragraph
    Halten Sie sich bei der Neuinstallation von Checkmk an die jeweilige
    [detaillierte Installationsanleitung](install_packages.html) für
    Ihre jeweilige Distribution.
    :::

7.  Starten Sie Ihre Checkmk-Instanz:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd start mysite
    ```
    :::
    ::::
:::
:::::
::::::::::
:::::::::::

::::::::::::::: sect1
## []{#exsitu .hidden-anchor .sr-only}4. Archivierung, Neuinstallation und Wiederherstellung *(ex situ)* {#heading_exsitu}

:::::::::::::: sectionbody
::: paragraph
Diese Methode bietet sich häufig beim Einsatz von Checkmk in
virtualisierten Umgebungen an, wo es möglich ist, einen zweiten Server
mit der neuen Distributionsversion vorbereitend \"hochzuziehen\" und mit
diesem im Parallelbetrieb bereits erste Tests durchzuführen. Zudem ist
die Flexibilität größer, weil auch ein Wechsel der Linux-Distribution
möglich ist. Technisch entspricht das der Vorgehensweise in einem
Schadensfall als *Backup, Reinstall and Restore*.
:::

::::::::: sect2
### []{#_vorbereitung_2 .hidden-anchor .sr-only}4.1. Vorbereitung {#heading__vorbereitung_2}

::: paragraph
Wesentlicher Vorbereitungsschritt ist, das passende
Checkmk-Installationspaket für die neue Distributionsversion
herunterzuladen.
:::

::: paragraph
Verschaffen Sie sich einen Überblick über die von den Instanzen
genutzten Checkmk-Versionen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd sites
SITE      VERSION        COMMENTS
mysite    2.3.0p2.cee    default version
```
:::
::::

::: paragraph
Von diesen müssen sie die Installationspakete für die neue
Betriebssystemversion herunterladen.
:::

::: paragraph
**Wichtig:** Die Edition und die Versionsnummer von Checkmk müssen exakt
der bisher verwendeten entsprechen.
:::
:::::::::

::::: sect2
### []{#_durchführung_2 .hidden-anchor .sr-only}4.2. Durchführung {#heading__durchführung_2}

::: paragraph
Die Schritte, welche hier seriell dargestellt werden, können Sie oft
teilweise parallelisieren, was die Ausfallzeit minimieren hilft. So zum
Beispiel bei Verwendung virtueller Maschinen oder wenn sowieso eine
Hardware-Neuanschaffung ansteht.
:::

::: {.olist .arabic}
1.  Stoppen Sie Ihre Checkmk-Instanz -- hier ist dieser Schritt nicht
    zwingend, aber aus Gründen der Konsistenz der Daten empfohlen:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd stop mysite
    ```
    :::
    ::::

2.  Erstellen Sie ein [Archiv](omd_basics.html#omd_backup_restore) (in
    anderen Kontexten Backup) der Instanz. Unser Beispiel verwendet als
    Ziel ein Netzwerk-Share, welches später auch auf der neuen
    Installation bereitstehen wird.

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    OMD[mysite]:~$ omd backup /mnt/someshare/mysite.tgz
    ```
    :::
    ::::

3.  Bereiten Sie nun das Zielsystem vor und konfigurieren Sie dort die
    für Checkmk benötigte Software, beispielsweise das E-Mail-System.
    Verwenden Sie denselben Host-Namen und dieselbe IP-Adresse wie beim
    Ausgangssystem.

4.  [Installieren](install_packages.html) Sie die zuvor heruntergeladene
    Checkmk-Version, passend für die neue Distribution.

    ::: paragraph
    Im Falle von Ubuntu genügt an dieser Stelle der folgende Befehl:
    :::

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# apt install /tmp/check-mk-enterprise-2.3.0p2_0.jammy_amd64.deb
    ```
    :::
    ::::

5.  Erstellen Sie eine neue Instanz mit demselben Namen wie die
    gesicherte Instanz:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    root@linux# omd create mysite
    ```
    :::
    ::::

6.  Führen Sie nun als Instanzbenutzer die Wiederherstellung aus dem
    Archiv durch:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    OMD[mysite]:~$ omd restore /mnt/someshare/mysite.tgz
    ```
    :::
    ::::

7.  Starten Sie Ihre Checkmk-Instanz:

    :::: listingblock
    ::: content
    ``` {.pygments .highlight}
    OMD[mysite]:~$ omd start
    ```
    :::
    ::::
:::
:::::
::::::::::::::
:::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
