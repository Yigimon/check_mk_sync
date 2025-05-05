:::: {#header}
# Installation unter Red Hat Enterprise Linux

::: details
[Last modified on 14-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_packages_redhat.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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

:::::::::::::::::: sect1
## []{#_einrichten_der_paketquellen .hidden-anchor .sr-only}1. Einrichten der Paketquellen {#heading__einrichten_der_paketquellen}

::::::::::::::::: sectionbody
::: paragraph
Checkmk benötigt etliche Software-Pakete Ihrer Linux-Distribution.
Software aus Drittquellen wird nicht benötigt. Damit alle benötigten
Pakete fehlerfrei nachinstalliert werden können, benötigen Sie eine
korrekte Konfiguration der Software-Quellen.
:::

::: paragraph
Bei Red Hat Enterprise Linux (RHEL) und allen binärkompatiblen
Distributionen wie CentOS, AlmaLinux oder Rocky Linux muss das *EPEL
(Extra Packages for Enterprise Linux)*-Repository als Paketquelle
eingerichtet werden.
:::

::: paragraph
Dies geschieht mit Hilfe eines RPM-Pakets, welches mit dem Befehl `yum`
installiert wird.
:::

+------+---------------------------------------------------------------+
| Ver  | Paketlink                                                     |
| sion |                                                               |
+======+===============================================================+
| 8    | `https://dl                                                   |
|      | .fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm` |
+------+---------------------------------------------------------------+
| 9    | `https://dl                                                   |
|      | .fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm` |
+------+---------------------------------------------------------------+

::: paragraph
Hier ein Beispiel für die Installation der EPEL-Paketquelle für die
Version 8:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```
:::
::::

::: paragraph
Damit Sie EPEL auf RHEL und binärkompatiblen Distributionen nutzen
können, benötigen Sie noch die Paketquelle für optionale RPMs, sofern
diese nicht bereits bei der Installation des Betriebssystems
eingerichtet worden ist. Ohne diese Quelle werden Ihnen die Pakete
`freeradius-utils`, `graphviz-gd` und `php-mbstring` fehlen.
:::

::: paragraph
Seit Version 8.x genügt hier die Aktivierung der sogenannten PowerTools
mithilfe des Dandified YUM in den freien binärkompatiblen Distributionen
bzw. dem `subscription-manager` in RHEL. Dies geht z.B. mit folgenden
Befehlen:
:::

::: paragraph
CentOS ab 8.4, AlmaLinux und Rocky Linux:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dnf config-manager --set-enabled powertools
```
:::
::::

::: paragraph
RHEL 8.x:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# subscription-manager repos --enable "codeready-builder-for-rhel-8-x86_64-rpms"
```
:::
::::
:::::::::::::::::
::::::::::::::::::

:::::::::: sect1
## []{#_einrichten_von_selinux_und_firewall .hidden-anchor .sr-only}2. Einrichten von SELinux und Firewall {#heading__einrichten_von_selinux_und_firewall}

::::::::: sectionbody
::: paragraph
Da RHEL und damit auch die binärkompatiblen Distributionen standardmäßig
Security-Enhanced Linux (SELinux) und eine lokale Firewall mitliefern,
müssen hier gegebenenfalls noch Anpassungen vorgenommen werden. Erlauben
Sie zunächst, dass der Webserver auf die Netzwerkschnittstellen
zugreifen darf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# setsebool -P httpd_can_network_connect 1
```
:::
::::

::: paragraph
Als Zweites geben Sie den Webserver frei und aktivieren die Änderung:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# firewall-cmd --zone=public --add-service=http --permanent
success
root@linux# firewall-cmd --reload
success
```
:::
::::
:::::::::
::::::::::

:::::::::: sect1
## []{#_herunterladen_des_passenden_pakets .hidden-anchor .sr-only}3. Herunterladen des passenden Pakets {#heading__herunterladen_des_passenden_pakets}

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
**Checkmk Raw** Paketes auf AlmaLinux 8.x:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# scp check-mk-raw-2.3.0p1-el8-38.x86_64.rpm root@mymonitoring.mydomain.org:
```
:::
::::
:::::::::
::::::::::

:::::::::::::: sect1
## []{#signed .hidden-anchor .sr-only}4. Installation des signierten Pakets {#heading_signed}

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
Signaturen. Unter RHEL und allen binärkompatiblen Distributionen ist
auch dafür das Tool `rpm` zuständig:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm --import Check_MK-pubkey.gpg
```
:::
::::

::: paragraph
Sobald Sie den Schlüssel importiert haben, können Sie das Paket noch
einmal verifizieren und anschließend wie gewohnt mit `yum install`
installieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -K check-mk-raw-2.3.0p1-el8-38.x86_64.rpm
check-mk-raw-2.3.0p1-el8-38.x86_64.rpm: digests signatures OK
root@linux# yum install check-mk-raw-2.3.0p1-el8-38.x86_64.rpm
```
:::
::::
:::::::::::::
::::::::::::::

::::::: sect1
## []{#_abschlusstest .hidden-anchor .sr-only}5. Abschlusstest {#heading__abschlusstest}

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
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
