:::: {#header}
# Installation unter Debian und Ubuntu

::: details
[Last modified on 31-Mar-2025]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_packages_debian.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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

:::::::::::::::::::::::::: sect1
## []{#package_sources .hidden-anchor .sr-only}1. Einrichten der Paketquellen {#heading_package_sources}

::::::::::::::::::::::::: sectionbody
::: paragraph
Minimalinstallationen von Debian oder Ubuntu enthalten möglicherweise
nicht alle für die Installation von Checkmk benötigten Paketquellen.
Vergleichen Sie die folgenden Minimalanforderungen mit den Einträgen
Ihrer `/etc/apt/sources.list`, beziehungsweise dem Inhalt des
Verzeichnisses `/etc/apt/sources.list.d`. Unsere Beispiele verwenden die
mehrzeilige Schreibweise und greifen auf den zentralen Spiegelserver zu.
Sofern nicht anders angegeben, gelten für ältere Versionen und
*STS-Versionen (Short Term Support)* die selben Anforderungen. Tauschen
Sie in diesem Fall einfach den Codenamen aus. Aktualisieren Sie nach
Überprüfung oder Anpassung der Paketquellen den lokalen Paket-Index:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apt update
```
:::
::::

:::::::::: sect2
### []{#debian .hidden-anchor .sr-only}1.1. Debian {#heading_debian}

::: paragraph
Bei Debian sind alle abhängig von Checkmk benötigten Pakete in der
Komponente `main` enthalten. In einigen Fällen setzt Checkmk bestimmte
Sicherheits-Updates voraus, das `security` Repository ist daher auch
erforderlich. Das Update-Repository ist empfohlen, aber nicht zwingend
erforderlich. Stabilitäts-Updates werden hier früher als zu den Dot
Releases bereitgestellt. Damit funktionieren die folgenden minimalen
Beispiele einer `/etc/apt/sources.list`:
:::

#### Debian 11 *Bullseye* {#debian11 .discrete}

::::: listingblock
::: title
/etc/apt/sources.list
:::

::: content
``` {.pygments .highlight}
deb http://deb.debian.org/debian/ bullseye main
deb https://security.debian.org/debian-security bullseye-security main
# deb http://deb.debian.org/debian bullseye-updates main
```
:::
:::::

#### Debian 12 *Bookworm* {#debian12 .discrete}

::::: listingblock
::: title
/etc/apt/sources.list
:::

::: content
``` {.pygments .highlight}
deb http://deb.debian.org/debian/ bookworm main
deb https://security.debian.org/debian-security bookworm-security main
# deb http://deb.debian.org/debian bookworm-updates main
```
:::
:::::
::::::::::

::::::::::::: sect2
### []{#ubuntu .hidden-anchor .sr-only}1.2. Ubuntu {#heading_ubuntu}

::: paragraph
Ubuntu benötigt mindestens die beiden Komponenten `main` und `universe`.
In einigen Fällen setzt Checkmk bestimmte Sicherheits-Updates voraus,
die `security` Repositories sind daher auch erforderlich. Die
Update-Repositories sind empfohlen, aber nicht zwingend erforderlich.
Stabilitäts-Updates werden hier früher als zu den Dot Releases
bereitgestellt. Daraus resultieren die folgenden Beispiele der
`/etc/apt/sources.list` bzw. ab Ubuntu 24.04 der
`/etc/apt/sources.list.d/ubuntu.sources`:
:::

#### Ubuntu 20.04 *Focal Fossa* {#ubuntu2004 .discrete}

::::: listingblock
::: title
/etc/apt/sources.list
:::

::: content
``` {.pygments .highlight}
deb http://archive.ubuntu.com/ubuntu/ focal main
deb http://archive.ubuntu.com/ubuntu/ focal universe
deb http://archive.ubuntu.com/ubuntu focal-security main
deb http://archive.ubuntu.com/ubuntu focal-security universe
# deb http://archive.ubuntu.com/ubuntu/ focal-updates main
# deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
```
:::
:::::

#### Ubuntu 22.04 *Jammy Jellyfish* {#ubuntu2204 .discrete}

::::: listingblock
::: title
/etc/apt/sources.list
:::

::: content
``` {.pygments .highlight}
deb http://archive.ubuntu.com/ubuntu/ jammy main
deb http://archive.ubuntu.com/ubuntu/ jammy universe
deb http://archive.ubuntu.com/ubuntu jammy-security main
deb http://archive.ubuntu.com/ubuntu jammy-security universe
# deb http://archive.ubuntu.com/ubuntu/ jammy-updates main
# deb http://archive.ubuntu.com/ubuntu/ jammy-updates universe
```
:::
:::::

#### Ubuntu 24.04 *Noble Numbat* {#ubuntu2404 .discrete}

::::: listingblock
::: title
/etc/apt/sources.list.d/ubuntu.sources
:::

::: content
``` {.pygments .highlight}
Types: deb
URIs: http://de.archive.ubuntu.com/ubuntu/
Suites: noble noble-updates
Components: main universe
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main universe
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```
:::
:::::
:::::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::::::::: sect1
## []{#download .hidden-anchor .sr-only}2. Herunterladen des passenden Pakets {#heading_download}

:::::::::::: sectionbody
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
Für eine Übertragung mit `scp` muss auf dem zukünftigen Checkmk-Server
das Paket `openssh-server` installiert sein. Sollte dies noch nicht der
Fall sein, so führen Sie den folgenden Befehl aus, um das Paket zu
installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apt install openssh-server
```
:::
::::

::: paragraph
Anschließend können Sie beispielsweise
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** für Ubuntu 22.04 *Jammy Jellyfish* wie folgt übertragen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# scp check-mk-raw-2.3.0p1_0.jammy_amd64.deb root@mymonitoring.mydomain.org:/tmp
```
:::
::::
::::::::::::
:::::::::::::

::::::::::::::::::::::::::: sect1
## []{#signed .hidden-anchor .sr-only}3. Installation des signierten Pakets {#heading_signed}

:::::::::::::::::::::::::: sectionbody
::: paragraph
Alle Pakete werden mittels [GnuPG](https://gnupg.org){target="_blank"}
signiert. Durch diese Signatur können Sie zum einen prüfen, ob das Paket
auch wirklich von uns stammt, und zum anderen, ob es insgesamt
vollständig ist.
:::

::: paragraph
Je nachdem mit welchen optionalen Paketen Ihre Distribution installiert
wurde, muss für eine erfolgreiche Verifikation noch das Paket `dpkg-sig`
inklusive seiner Abhängigkeiten installiert werden. Führen Sie dazu den
folgenden Befehl aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apt install dpkg-sig
```
:::
::::

::: paragraph
Damit die signierten Pakete wie gewohnt installiert werden können,
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
Signaturen. Unter Debian und Ubuntu benötigen Sie dafür den folgenden
Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# gpg --import Check_MK-pubkey.gpg
```
:::
::::

::: paragraph
Sobald Sie den Schlüssel importiert haben, verifizieren Sie das
Checkmk-Paket mit dem folgenden Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg-sig --verify check-mk-raw-2.3.0p1_0.jammy_amd64.deb
```
:::
::::

::: paragraph
In einigen Fällen scheitert die Signaturprüfung mit der folgenden
Fehlermeldung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
BADSIG _gpgbuilder
```
:::
::::

::: paragraph
Tritt dies auf, ist der wahrscheinlichste Grund, dass die installierte
Version von `dpkg-sig` nicht mit dem Kompressionsformat des Pakets
umgehen kann. Verwenden Sie in diesem Fall `gpg`, um die Signatur zu
prüfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# gpg --verify check-mk-raw-2.3.0p1_0.jammy_amd64.deb
gpg: Signature made Tue Apr 18 11:52:52 2023 CEST
gpg:                using RSA key B1E7106575B723F00611C612434DAC48C4503261
gpg: Good signature from "Check_MK Software Release Signing Key (2018) <feedback@check-mk.org>" [unknown]
gpg:                 aka "Check_MK Software Daily Build Signing Key (2018) <feedback@check-mk.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: B1E7 1065 75B7 23F0 0611  C612 434D AC48 C450 3261
```
:::
::::

::: paragraph
Die angezeigte Warnung bezieht sich auf den öffentlichen Schlüssel von
Checkmk, nicht die Signatur des Pakets selbst. Der Grund hierfür ist,
dass der verwendete Schlüssel mit keinem anderen Schlüssel signiert ist,
dem der Nutzer vertraut - was aber in diesem Fall kein Problem
darstellt.
:::

::: paragraph
Anschließend können Sie das Checkmk-Paket mit dem folgenden Befehl
installieren. Achten Sie dabei darauf, den vollständigen Pfad zu der
DEB-Datei an `apt install` zu übergeben:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apt install /tmp/check-mk-raw-2.3.0p1_0.jammy_amd64.deb
```
:::
::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

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
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
