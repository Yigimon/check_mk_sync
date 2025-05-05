:::: {#header}
# Release notes

::: details
[Last modified on 17-Feb-2025]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/release_notes.asciidoc){.edit-document}
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
[Update auf Version 2.3.0](update_major.html) [Update-Matrix für Version
2.3.0](update_matrix.html) [Grundsätzliches zur Installation von
Checkmk](install_packages.html) [Linux überwachen](agent_linux.html)
[Windows überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::: sectionbody
::: paragraph
Dieses Dokument listet die unterstützten Plattformen und Integrationen
von Checkmk [2.3.0]{.new} auf. Sofern keine besonderen Gründe vorliegen
(z. B. Sicherheit), werden diese Plattformen während der aktiven Pflege
im Checkmk [2.3.0]{.new} Produkt-Lifecycle einschließlich aller
Patch-Versionen unterstützt.
:::
::::
:::::

:::::::: sect1
## []{#os .hidden-anchor .sr-only}2. OS für den Server {#heading_os}

::::::: sectionbody
::: paragraph
Checkmk kann auf den folgenden Linux-Server-Betriebssystemdistributionen
und -versionen installiert werden, die auf x86_64-Hardware laufen. Dazu
geben wir eine Liste der unterstützen Versionen heraus. Einträge können
folgende Zusätze enthalten:
:::

::: ulist
- *Deprecated:* So gekennzeichnete LTS/LTSS Versionen werden noch
  während des gesamten Lebenszyklus von Version [2.3.0]{.new}
  unterstützt und fallen danach aus dem Support heraus.

- *Once released:* Die Unterstützung für diese Versionen ist geplant.
  Die Bereitstellung von Checkmk [2.3.0]{.new} Paketen erfolgt zeitnah
  nach Erscheinen der neuen Distributionsversion.
:::

::: paragraph
Wir werden auch neue Versionen dieser Distributionen für die
Unterstützung evaluieren. Diese entnehmen Sie der
[Update-Matrix.](update_matrix.html)
:::

+----------------------+-----------------------------------------------+
| Betriebssystem       | Unterstützte Versionen                        |
+======================+===============================================+
| Debian               | 10 Buster (deprecated)                        |
+----------------------+-----------------------------------------------+
|                      | 11 Bullseye                                   |
+----------------------+-----------------------------------------------+
|                      | 12 Bookworm                                   |
+----------------------+-----------------------------------------------+
| Red Hat Enterprise   | 8                                             |
| Linux                |                                               |
+----------------------+-----------------------------------------------+
|                      | 9                                             |
+----------------------+-----------------------------------------------+
|                      | 10 (once released)                            |
+----------------------+-----------------------------------------------+
| SUSE Linux           | 12 SP5 (deprecated)                           |
| Enterprise Server    |                                               |
+----------------------+-----------------------------------------------+
|                      | 15 SP3                                        |
+----------------------+-----------------------------------------------+
|                      | 15 SP4                                        |
+----------------------+-----------------------------------------------+
|                      | 15 SP5                                        |
+----------------------+-----------------------------------------------+
|                      | 15 SP6 (once released)                        |
+----------------------+-----------------------------------------------+
| Ubuntu               | 20.04 LTS Focal Fossa (deprecated)            |
+----------------------+-----------------------------------------------+
|                      | 22.04 LTS Jammy Jellyfish                     |
+----------------------+-----------------------------------------------+
|                      | 24.04 LTS Noble Numbat (once released)        |
+----------------------+-----------------------------------------------+

::: paragraph
Ubuntu STS-Versionen werden ab Checkmk [2.3.0]{.new} nicht mehr
unterstützt, Nutzer von Ubuntu 23.10 müssen unter Checkmk [2.2.0]{.new}
[auf Ubuntu 24.04 aktualisieren](release_upgrade.html), bevor sie zu
Checkmk [2.3.0]{.new} wechseln können.
:::
:::::::
::::::::

:::::::: sect1
## []{#browser .hidden-anchor .sr-only}3. Browser {#heading_browser}

::::::: sectionbody
::: paragraph
Die Checkmk-Benutzeroberfläche ist für die folgenden Desktop-Browser und
Mindestversionen geprüft:
:::

::: ulist
- Google Chrome \>= 121 unter Windows, Linux und macOS

- Firefox \>= 122 unter Windows, Linux und macOS

- Microsoft Edge \>= 121 unter Windows

- Safari \>= 17.2 unter macOS
:::

::: paragraph
Die mobile Checkmk-Benutzeroberfläche ist für die folgenden mobilen
Browser geprüft:
:::

::: ulist
- Safari unter iPadOS/iPhoneOS (aktuelle und letzte Hauptversion des
  Betriebssystems)

- Google Chrome unter Android (aktuelle und letzte Hauptversion des
  Betriebssystems)
:::
:::::::
::::::::

::::::::::::::: sect1
## []{#agent .hidden-anchor .sr-only}4. OS für den Checkmk-Agenten {#heading_agent}

:::::::::::::: sectionbody
::: paragraph
Der Checkmk-Agent kann auf den folgenden Betriebssystemen installiert
und betrieben werden, wenn grundlegende Anforderungen erfüllt sind.
:::

:::::::: sect2
### []{#_linuxunix .hidden-anchor .sr-only}4.1. Linux/Unix {#heading__linuxunix}

::: paragraph
Alle Linux-Distributionen und diverse Unix-Betriebssysteme wie *Solaris*
und *AIX* werden unterstützt, sofern sie mindestens die folgenden
technischen Komponenten in der minimalen Version mitbringen:
:::

::: ulist
- Bash \>= 4.2

- ksh \>= 93

- Perl \>= 5.14.0
:::

::: paragraph
Zusätzlich muss eine der folgenden Komponenten vorhanden sein:
:::

::: ulist
- systemd \>= 219

- xinetd (keine Mindestversion)
:::

::: paragraph
Beachten Sie: Es kann sein, dass Plugins für ihre Funktion zusätzliche
Komponenten benötigen. Python-Plugins erfordern Version 2.7 oder \> 3.5.
:::
::::::::

:::::: sect2
### []{#windows .hidden-anchor .sr-only}4.2. Windows {#heading_windows}

::: paragraph
Alle folgenden 64-Bit-Versionen der Windows Betriebssysteme werden
unterstützt:
:::

::: ulist
- 2016

- 2019

- 2022

- 2025
:::

::: paragraph
Für ältere Systeme stellen wir einen [Legacy
Agenten](https://download.checkmk.com/legacy-agents/){target="_blank"}
bereit. Dieser hat ein geringeres Feature-Set und wird nicht offiziell
unterstützt.
:::
::::::
::::::::::::::
:::::::::::::::

:::::: sect1
## []{#grafana .hidden-anchor .sr-only}5. Grafana Plugin {#heading_grafana}

::::: sectionbody
::: paragraph
Checkmk [2.3.0]{.new} unterstützt die folgenden Grafana Plugin
Versionen:
:::

::: ulist
- \>= 3.0.0
:::
:::::
::::::

:::::: sect1
## []{#appliance .hidden-anchor .sr-only}6. Checkmk Appliance {#heading_appliance}

::::: sectionbody
::: paragraph
Checkmk [2.3.0]{.new} kann auf den folgenden Versionen der Checkmk
Appliance ausgeführt werden:
:::

::: ulist
- \>= 1.6.8
:::
:::::
::::::

:::::: sect1
## []{#ldap .hidden-anchor .sr-only}7. LDAP-Server {#heading_ldap}

::::: sectionbody
::: paragraph
Checkmk [2.3.0]{.new} unterstützt die Synchronisierung mit LDAP der
folgenden LDAP-Server:
:::

::: ulist
- Microsoft Active Directory

- OpenLDAP

- 389 Directory Server
:::
:::::
::::::

::::::: sect1
## []{#saml .hidden-anchor .sr-only}8. SAML IdP {#heading_saml}

:::::: sectionbody
::: paragraph
Die SAML-Integration unterstützt die folgenden Identity Provider (IdPs):
:::

::: ulist
- Microsoft Entra ID (hieß bis 2023 Azure Active Directory)

- Google Cloud

- Okta
:::

::: paragraph
Checkmk arbeitet möglicherweise auch mit anderen SAML-Integrationen
zusammen, aber für diese kann keine Unterstützung gegeben werden.
:::
::::::
:::::::

:::::: sect1
## []{#ntopng .hidden-anchor .sr-only}9. ntopng {#heading_ntopng}

::::: sectionbody
::: paragraph
Die ntopng-Integration unterstützt die folgenden Versionen von ntopng
Professional und Enterprise:
:::

::: ulist
- 5.6 (deprecated)

- \>= 6.0
:::
:::::
::::::

::::::: sect1
## []{#nagvis .hidden-anchor .sr-only}10. Nagvis {#heading_nagvis}

:::::: sectionbody
::: paragraph
Nagvis hängt von PHP ab und benötigt eine Mindestversion, um zu laufen.
Stellen Sie sicher, dass Sie eine passende PHP-Version in Ihrer
Installation haben, um Nagvis auszuführen:
:::

::: ulist
- \>= 7.2
:::

::: paragraph
Je nach verwendeter Linux-Distribution kann die als Abhängigkeit des
Checkmk-Installationspaketes definierte Version höher sein.
:::
::::::
:::::::

:::::: sect1
## []{#influxdb .hidden-anchor .sr-only}11. InfluxDB {#heading_influxdb}

::::: sectionbody
::: paragraph
Checkmk unterstützt den Export von Daten an die folgenden Versionen der
InfluxDB API:
:::

::: ulist
- \>= 2.0
:::
:::::
::::::

::::::::: sect1
## []{#_änderungsprotokoll .hidden-anchor .sr-only}12. Änderungsprotokoll {#heading__änderungsprotokoll}

:::::::: sectionbody
::::::: sect2
### []{#_korrekturen .hidden-anchor .sr-only}12.1. Korrekturen {#heading__korrekturen}

:::: sect3
#### []{#_12_juli_2024 .hidden-anchor .sr-only}12. Juli 2024 {#heading__12_juli_2024}

::: ulist
- Windows 2012 & Windows 2012 R2 wurden aus der Liste der unterstützten
  Betriebssysteme für Agenten entfernt, da sie inkompatibel mit Python
  3.12 sind. Eine teilweise Funktion des aktuellen Agenten ist möglich,
  kann aber nicht garantiert oder offiziell unterstützt werden.
:::
::::

:::: sect3
#### []{#_17_februar_2025 .hidden-anchor .sr-only}17. Februar 2025 {#heading__17_februar_2025}

::: ulist
- Windows 2025 wurde nach Tests zur Liste der unterstützten
  Betriebssysteme für Agenten hinzugefügt.
:::
::::
:::::::
::::::::
:::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
