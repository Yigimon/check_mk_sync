:::: {#header}
# Installation unter SUSE Linux Enterprise Server

::: details
[Last modified on 08-May-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_packages_sles.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk aufsetzen](intro_setup.html) [Virtuelle Appliance
installieren](appliance_install_virt1.html) [Grundsätzliches zur
Installation von Checkmk](install_packages.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#_einrichten_der_paketquellen .hidden-anchor .sr-only}1. Einrichten der Paketquellen {#heading__einrichten_der_paketquellen}

::::::::::: sectionbody
::: paragraph
Checkmk benötigt etliche Software-Pakete Ihrer Linux-Distribution.
Software aus Drittquellen wird nicht benötigt. Damit alle benötigten
Pakete korrekt nachinstalliert werden können, benötigen Sie eine
korrekte Konfiguration der Software-Quellen.
:::

::: paragraph
Das Vorgehen zum Einrichten unterscheidet sich je nach verwendeter
Version von SUSE Linux Enterprise Server (SLES) ein wenig.
:::

::::: sect2
### []{#sles12 .hidden-anchor .sr-only}1.1. SLES 12 {#heading_sles12}

::: paragraph
Mit SLES 12 wurden einige Software-Komponenten, wie z.B. PHP, das von
OMD benötigt wird, in sogenannte Module ausgelagert. Damit Sie Zugriff
auf die PHP-Pakete von SLES 12 bekommen, müssen Sie folgende Schritte
ausführen:
:::

::: {.olist .arabic}
1.  [Registrieren von SLES
    12](https://documentation.suse.com/de-de/sles/12-SP5/html/SLES-all/cha-planning.html#sec-planning-registering){target="_blank"}

2.  [Installieren des Moduls „Web and
    Scripting"](https://documentation.suse.com/de-de/sles/12-SP5/html/SLES-all/cha-add-ons.html#sec-add-ons-installation){target="_blank"}
:::
:::::

::::: sect2
### []{#sles15 .hidden-anchor .sr-only}1.2. SLES 15 {#heading_sles15}

::: paragraph
Unter SLES 15 müssen Sie zusätzlich zum Modul „Web and Scripting" noch
die Module „Development Tools" und „SUSE Package Hub 15" installieren:
:::

::: ulist
- [Registrieren von SLES 15 und Verwalten von
  Modulen](https://documentation.suse.com/de-de/sles/15-SP5/html/SLES-all/cha-register-sle.html){target="_blank"}
:::
:::::
:::::::::::
::::::::::::

:::::::::: sect1
## []{#_herunterladen_des_passenden_pakets .hidden-anchor .sr-only}2. Herunterladen des passenden Pakets {#heading__herunterladen_des_passenden_pakets}

::::::::: sectionbody
::: paragraph
Wählen Sie zunächst die für Ihre Bedürfnisse passende
[Checkmk-Edition.](intro_setup.html#editions) Auf der
[Download-Seite](https://checkmk.com/de/download){target="_blank"}
finden Sie Checkmk Raw, welche Open Source ist, und die bis 750 Services
gratis nutzbare Checkmk Cloud. Wenn Sie eine Subskription besitzen, dann
finden Sie die Installationspakete im
[Kundenportal.](https://portal.checkmk.com/de/){target="_blank"}
:::

::: paragraph
Wir empfehlen den Einsatz der *letzten stabilen Checkmk-Version.* Falls
Sie (beispielsweise als Basis für die Wiederherstellung eines Backups)
eine ältere Version benötigen, finden Sie diese im
[Download-Archiv.](https://checkmk.com/de/download/archive){target="_blank"}
Achten Sie darauf, dass das ausgewählte Paket exakt zur installierten
Linux-Distribution und deren Version passt.
:::

::: paragraph
Nachdem Sie das Paket heruntergeladen haben, bringen Sie es auf das
Linux-System, auf dem Checkmk installiert werden soll. Das kann zum
Beispiel über das Kommandozeilentool `scp` geschehen, welches jedes
moderne System mitbringt -- und auch bei Windows 10 in der PowerShell
verfügbar ist. Zusätzliche Programme wie *WinSCP* sind meist nicht
erforderlich.
:::

::: paragraph
Das Beispiel zeigt die Übertragung eines
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** Pakets auf SLES 15:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# scp check-mk-raw-2.3.0p1-sles15-38.x86_64.rpm root@mymonitoring.mydomain.org:
```
:::
::::
:::::::::
::::::::::

:::::::::::::: sect1
## []{#signed .hidden-anchor .sr-only}3. Installation des signierten Pakets {#heading_signed}

::::::::::::: sectionbody
::: paragraph
Alle Pakete werden mittels [GnuPG](https://gnupg.org){target="_blank"}
signiert. Durch diese Signatur können Sie zum einen prüfen, ob das Paket
auch wirklich von uns stammt, und zum anderen, ob es insgesamt
vollständig ist.
:::

::: paragraph
Damit diese signierten Pakete wie gewohnt installiert werden können,
müssen Sie einmalig unseren öffentlichen Schlüssel importieren, damit
der Signatur vertraut wird. Laden Sie dazu zuerst den Schlüssel direkt
von unserer Website:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# wget https://download.checkmk.com/checkmk/Check_MK-pubkey.gpg
```
:::
::::

::: paragraph
Danach importieren Sie den Schlüssel in die Liste der vertrauenswürdigen
Signaturen. Unter SLES ist dafür das Tool `rpm` zuständig:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm --import Check_MK-pubkey.gpg
```
:::
::::

::: paragraph
Sobald Sie den Schlüssel importiert haben, können Sie das Checkmk-Paket
nun noch einmal verifizieren und anschließend mit `zypper install`
installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -K check-mk-raw-2.3.0p1-sles15-38.x86_64.rpm
check-mk-raw-2.3.0p1-sles15-38.x86_64.rpm: digests signatures OK
root@linux# zypper install check-mk-raw-2.3.0p1-sles15-38.x86_64.rpm
```
:::
::::
:::::::::::::
::::::::::::::

::::::: sect1
## []{#_abschlusstest .hidden-anchor .sr-only}4. Abschlusstest {#heading__abschlusstest}

:::::: sectionbody
::: paragraph
Nach der erfolgreichen Installation von Checkmk und allen Abhängigkeiten
steht Ihnen der Befehl `omd` zur Verfügung, mit dem Sie
[Monitoring-Instanzen](omd_basics.html) anlegen und verwalten können.
Zur Kontrolle können Sie die installierte Version ausgeben lassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd version
OMD - Open Monitoring Distribution Version 2.3.0p1.cre
```
:::
::::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::
