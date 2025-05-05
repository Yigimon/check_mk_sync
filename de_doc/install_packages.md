:::: {#header}
# Grundsätzliches zur Installation von Checkmk

::: details
[Last modified on 15-May-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/install_packages.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk aufsetzen](intro_setup.html) [Installation unter Debian und
Ubuntu](install_packages_debian.html) [Installation unter Red Hat
Enterprise Linux](install_packages_redhat.html) [Installation unter SUSE
Linux Enterprise Server](install_packages_sles.html) [Virtuelle
Appliance installieren](appliance_install_virt1.html) [Installation als
Docker-Container](introduction_docker.html) [Update-Matrix für Version
[2.3.0]{.new}](update_matrix.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#_warum_linux .hidden-anchor .sr-only}1. Warum Linux? {#heading__warum_linux}

::::: sectionbody
::: paragraph
Checkmk ist ein umfangreiches Software-Paket, welches grundsätzlich
*Linux* als Betriebssystem voraussetzt. Warum? Linux eignet sich
hervorragend als Plattform für den Betrieb von Checkmk, weil es sehr
performant und stabil ist und viele wichtige Werkzeuge dort bereits
integriert sind. Nebenbei hat das noch die angenehme Begleiterscheinung,
dass es von Linux mit Debian, Ubuntu, AlmaLinux und Rocky Linux völlig
kostenlose Distributionen gibt, welche durchaus Enterprise-fähig sind
und von Checkmk unterstützt werden.
:::

::: paragraph
Falls Sie sich auf keinen Fall mit Linux befassen möchten, gibt es die
Möglichkeit, Checkmk auch als [virtuelle
Appliance](appliance_install_virt1.html), [physische
Appliance](https://checkmk.com/de/produkt/appliances){target="_blank"}
oder als [Docker-Container](introduction_docker.html) zu betreiben.
:::
:::::
::::::

::::::::::::: sect1
## []{#supported_distributions .hidden-anchor .sr-only}2. Unterstützte Distributionen {#heading_supported_distributions}

:::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![linux](../images/linux.png){width="150"}
:::
::::

::: paragraph
Linux ist ein freies System und wird von vielen Herstellern in eigenen
Varianten (Distributionen) angeboten. Das ist natürlich erst einmal sehr
positiv, denn Konkurrenz belebt das Geschäft, steigert die Qualität und
als Anwender haben Sie immer die Möglichkeit, zu einer für Sie besseren
Linux-Distribution zu wechseln.
:::

::: paragraph
Diese Vielfalt hat allerdings auch einen Nachteil: Die angebotenen
Distributionen unterscheiden sich in vielen Details, unter anderem auch
in den Versionen von mitgelieferten Software-Bibliotheken,
Verzeichnispfaden, Vorkonfiguration und so weiter.
:::

::: paragraph
Damit bei Ihnen mit Checkmk trotzdem alles reibungslos läuft, haben wir
uns schon von Anfang an entschlossen, für jede wichtige
Linux-Distribution ein eigenes Installationspaket von Checkmk
anzubieten. Die unterstützten Distributionen sind:
:::

::: ulist
- Red Hat Enterprise Linux (RHEL) und binärkompatible Distributionen
  (CentOS, AlmaLinux, Rocky Linux, Oracle Linux...​)

- SUSE Linux Enterprise Server (SLES)

- Debian

- Ubuntu in den LTS-Versionen
:::

::: paragraph
Prinzipiell wird von den erwähnten Linux-Distributionen mit wenigstens
fünf Jahren Support durch den Distributor jede unterstützt, die bei
Veröffentlichung einer Checkmk-Version in aktivem Support war. Exakte
Versionsnummern unterstützter Distributionen entnehmen Sie bitte der
[Kompatibilitätsmatrix](update_matrix.html#matrix), auf derselben Seite
finden Sie auch die [Richtlinie zur Betriebssystemunterstützung (*OS
Support Policy*)](update_matrix.html#ossupport).
:::

::: paragraph
Zur Installation benötigen Sie einen physischen oder virtuellen Server,
auf dem Sie Linux bereits installiert haben. Die Installation von
Checkmk geschieht dann in vier Schritten:
:::

::: {.olist .arabic}
1.  Vorbereiten des Linux-Systems.

2.  Einrichten der Paketquellen.

3.  Herunterladen des passenden Checkmk-Pakets.

4.  Installation des Pakets.
:::
::::::::::::
:::::::::::::

::::::::::: sect1
## []{#_vorbereiten_des_linux_systems .hidden-anchor .sr-only}3. Vorbereiten des Linux-Systems {#heading__vorbereiten_des_linux_systems}

:::::::::: sectionbody
::: paragraph
Je nachdem, welche Distribution Sie einsetzen, sind unterschiedliche
Schritte für die Vorbereitung notwendig. Im Folgenden gehen wir davon
aus, dass Sie das Linux-System, auf dem Checkmk installiert werden soll,
mit den Standardvorgaben des Herstellers installieren und korrekt in das
Netzwerk einbinden, so dass es von Ihrem Arbeitsplatz aus per HTTP und
SSH erreichbar ist.
:::

:::: sect2
### []{#_aufteilung_festplattenplatz .hidden-anchor .sr-only}3.1. Aufteilung Festplattenplatz {#heading__aufteilung_festplattenplatz}

::: paragraph
Checkmk legt seine Daten unter dem physikalischen Pfad `/opt/omd` ab,
konkret `/opt/omd/versions` für die Checkmk-Software und
`/opt/omd/sites` für Monitoring-Daten. Wenn das System ausschließlich
für Checkmk verwendet werden soll, sollte hier der Hauptanteil des
verfügbaren Plattenplatzes bereitstehen. Dabei ist für `/opt/omd`, bzw.
`/opt` zwar nicht unbedingt eine eigene Partition notwendig, aber sehr
sinnvoll.
:::
::::

:::: sect2
### []{#smtpconfig .hidden-anchor .sr-only}3.2. SMTP für ausgehende E-Mails {#heading_smtpconfig}

::: paragraph
Wenn Sie beim Monitoring Benachrichtigungen per E-Mail versenden
möchten, dann benötigen Sie eine korrekte Konfiguration des
SMTP-Dienstes für ausgehende E-Mails. Hierfür können Sie einen
SMTP-Server ohne lokale Zustellung wie `nullmailer`, `msmtp` oder
`esmtp` konfigurieren. Üblicherweise geben Sie dabei einen Smarthost an,
an den alle E-Mails weitergeleitet werden.
:::
::::

:::: sect2
### []{#_einstellungen_für_die_systemzeit .hidden-anchor .sr-only}3.3. Einstellungen für die Systemzeit {#heading__einstellungen_für_die_systemzeit}

::: paragraph
Damit der Monitoring-Server eine korrekte Systemzeit hat, empfehlen wir
dringend, NTP einzurichten. Die Hardware-Uhr des Systems sollte auf UTC
eingestellt sein. Sobald Sie den Server selbst ins Monitoring mit
Checkmk aufnehmen, wird die korrekte Funktion von NTP automatisch
überwacht.
:::
::::
::::::::::
:::::::::::

:::::: sect1
## []{#distribution_instructions .hidden-anchor .sr-only}4. Installationsanleitungen {#heading_distribution_instructions}

::::: sectionbody
::: paragraph
Für die einzelnen Distributionen stehen Ihnen jeweils dedizierte
Anleitungen zur Verfügung:
:::

::: ulist
- [Red Hat Enterprise Linux](install_packages_redhat.html)

- [SUSE Linux Enterprise Server](install_packages_sles.html)

- [Debian und Ubuntu](install_packages_debian.html)
:::
:::::
::::::
:::::::::::::::::::::::::::::::::::::
