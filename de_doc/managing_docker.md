:::: {#header}
# Checkmk-Server im Docker-Container

::: details
[Last modified on 22-Apr-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/managing_docker.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Installation als Docker-Container](introduction_docker.html) [Virtuelle
Appliance installieren](appliance_install_virt1.html) [Updates und
Upgrades](update.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#_checkmk_im_docker_container .hidden-anchor .sr-only}1. Checkmk im Docker-Container {#heading__checkmk_im_docker_container}

:::: sectionbody
::: paragraph
In unserer [Installationsanleitung für Checkmk in
Docker](introduction_docker.html) haben wir Ihnen bereits gezeigt, wie
Sie Checkmk in einem Docker-Container aufsetzen können. Dieser Artikel
geht etwas ausführlicher auf die weiteren Einzelheiten ein.
:::
::::
:::::

:::::::::::::::::::::::::::::: sect1
## []{#_optionale_parameter_bei_der_einrichtung .hidden-anchor .sr-only}2. Optionale Parameter bei der Einrichtung {#heading__optionale_parameter_bei_der_einrichtung}

::::::::::::::::::::::::::::: sectionbody
::: paragraph
Alle folgenden Parameter werden zusätzlich bei der Einrichtung einer
Checkmk-Instanz als Container angegeben und stehen daher nicht alleine.
:::

:::: sect2
### []{#https .hidden-anchor .sr-only}2.1. Nutzung von HTTPS {#heading_https}

::: paragraph
Wenn Checkmk der einzige Webserver auf Ihrer Docker-Node ist, können Sie
den Port auch auf den Standard Port (`80`) von HTTP binden. Sobald sie
jedoch mehrere Webserver auf einer Docker-Node haben, werden Sie
wahrscheinlich einen Reverse-Proxy wie Nginx nutzen. Dieser leitet die
Anfragen an den richtigen Container weiter. Über diese Technologie
können Sie auch (eventuell bereits vorhandenes) HTTPS nutzen. Der
Reverse-Proxy wird dann über HTTPS angesprochen, während die
Kommunikation mit dem Container weiterhin über HTTP erfolgt.
:::
::::

:::: sect2
### []{#_setzen_eines_initialen_passworts .hidden-anchor .sr-only}2.2. Setzen eines initialen Passworts {#heading__setzen_eines_initialen_passworts}

::: paragraph
In Checkmk wird beim [Erstellen einer
Instanz](intro_setup.html#create_site) ein zufälliges Passwort für den
Standardbenutzer `cmkadmin` gewählt. Bei der Erstellung eines
Checkmk-Containers können sie auch manuell ein Passwort vergeben. Fügen
Sie dazu lediglich die Option `-e CMK_PASSWORD='mypassword'` der
Erstellung hinzu.
:::
::::

::::::: sect2
### []{#_setzen_einer_eigenen_instanz_id .hidden-anchor .sr-only}2.3. Setzen einer eigenen Instanz-ID {#heading__setzen_einer_eigenen_instanz_id}

::: paragraph
Mit dem Standardbefehl zur Erstellung eines Checkmk-Containers wird die
ID der erzeugten Instanz in dem Container `cmk`. Diese ist wichtig, um
die Instanz über HTTP(S) ansteuern zu können und muss daher eindeutig
sein. Wenn Sie mehrere Container von Checkmk auf der gleichen
Docker-Node betreiben wollen, werden Sie die ID manuell setzen müssen,
um die Eindeutigkeit gewährleisten zu können. Sie erreichen das, indem
Sie die Option `-e CMK_SITE_ID=mysite` hinzufügen. Der vollständige
Befehl könnte dann so aussehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container run -e CMK_SITE_ID="mysite" -dit -p 8080:5000 -p 8000:8000 --tmpfs /opt/omd/sites/mysite/tmp:uid=1000,gid=1000 -v monitoring:/omd/sites --name monitoring -v /etc/localtime:/etc/localtime:ro --restart always checkmk/check-mk-raw:2.1.0-latest
```
:::
::::

::: paragraph
Achtens Sie unbedingt darauf auch bei der Option `--tmpfs` im Pfad den
Namen Ihrer Instanz (hier: `mysite`) zu anzugeben.
:::
:::::::

::::::: sect2
### []{#_senden_von_benachrichtigungen .hidden-anchor .sr-only}2.4. Senden von Benachrichtigungen {#heading__senden_von_benachrichtigungen}

::: paragraph
Eine wichtige Funktionen von Checkmk ist es, im Falle von Problemen
[Benachrichtigungen](monitoring_basics.html#notifications) per E-Mail zu
versenden. Checkmk nutzt in seinen Container-Images Postfix als MTA
(Mail Transfer Agent) für ausgehende E-Mails. Dieser ist so
konfiguriert, dass er die E-Mails nicht direkt an die Empfänger zustellt
sondern grundsätzlich an einen einen weiteren Mailserver
(SMTP-Relay-Server, Smarthost) weiterleiten möchte, welchen Sie
außerhalb des Containers bereitstellen müssen. So ein Relay-Server ist
praktisch in jeder Organisation vorhanden.
:::

::: paragraph
Geben Sie bei der Erstellung den Relay-Mailserver an, der die
Benachrichtigungen weiterleiten soll. Dazu setzen Sie mit der Option
`-e` die Variable `MAIL_RELAY_HOST`, wie zum Beispiel
`-e MAIL_RELAY_HOST='mailrelay.mydomain.com'`. Falls der Mailserver
einen korrekten Hostnamen erwartet, fügen sie zusätzlich folgende Option
an: `--hostname 'mymonitoring.mydomain.com'`.
:::

::: paragraph
Checkmk-Container unterstützen derzeit keine Konfiguration von
Zugangsdaten für den Smarthost. Falls Sie diese benötigen, können Sie
eine Postfix-Konfiguration oder ein Konfigurationsverzeichnis aus dem
Docker-Node in den Container binden.
:::

::: paragraph
Falls Sie eine der kommerziellen Editionen verwenden, können Sie Postfix
auch komplett umgehen und die Benachrichtigungen von Checkmk direkt an
einen Smarthost weiterleiten lassen. Dies geschieht per [synchronem
SMTP](notifications.html#syncsmtp) und ist im Artikel über die
[Benachrichtigungen](notifications.html) genauer beschrieben. Und hier
ist auch eine Authentifizierung innerhalb von SMTP möglich.
:::
:::::::

:::: sect2
### []{#_zugriff_auf_livestatus_per_tcp .hidden-anchor .sr-only}2.5. Zugriff auf Livestatus per TCP {#heading__zugriff_auf_livestatus_per_tcp}

::: paragraph
Sobald sie mehrere Checkmk-Container/Instanzen miteinander zu einer
verteilten Umgebung verknüpfen wollen, benötigen Sie einen speziellen
TCP-Port für die Schnittstelle Livestatus. Diese Schnittstelle
ermöglicht die Kommunikation der Instanzen untereinander. Binden Sie
dafür diesen Port, wie den Port für HTTP auch, an einen der Docker-Nodes
und aktivieren Sie diesen TCP-Port in der Instanz für Livestatus:
`-e CMK_LIVESTATUS_TCP=on -p 6557:6557`.
:::
::::

::::::: sect2
### []{#bash .hidden-anchor .sr-only}2.6. Zugriff per Kommandozeile {#heading_bash}

::: paragraph
In machen Fällen werden Sie Befehle auf der Kommandozeile ausführen
wollen. Da Befehle für eine Instanz immer mit einem speziellen Benutzer
ausgeführt werden, müssen Sie diesen bei dem Login angeben. Der Benutzer
hat in Checkmk immer den gleichen Namen wie die Instanz, die er
verwaltet. Mit der Option `-u cmk` geben Sie den Benutzer `cmk` an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container exec -it -u cmk monitoring bash
```
:::
::::

::: paragraph
Danach können Sie Ihre [Befehle](cmk_commandline.html) an die Instanz
übergeben.
:::
:::::::

:::::: sect2
### []{#_nutzung_der_event_console .hidden-anchor .sr-only}2.7. Nutzung der Event Console {#heading__nutzung_der_event_console}

::: paragraph
Checkmk ist in der Lage SNMP-Traps und Syslog-Nachrichten zu empfangen.
Damit Sie diese Funktion in einem Checkmk-Container nutzen können,
müssen sie die standardisierten Ports mit den folgenden Optionen an den
Checkmk-Container weiterreichen:
`-p 162:162/udp -p 514:514/udp -p 514:514/tcp`. Damit die Instanz selbst
auch diese Ports beachtet, schalten Sie danach in der Instanz mit
[`omd config`](omd_basics.html#omd_config) die entsprechenden Add-ons
ein. Sie finden diese in dem Untermenü `Addons`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container exec -it -u cmk monitoring bash
OMD[mysite]:~$ omd config
```
:::
::::
::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::

:::: sect1
## []{#commands .hidden-anchor .sr-only}3. Nützliche Befehle {#heading_commands}

::: sectionbody
+-----------------------------------+-----------------------------------+
| Befehl                            | Beschreibung                      |
+===================================+===================================+
| `docker inspect myContainer`      | Mit diesem Befehl können Sie      |
|                                   | allerlei Informationen über einen |
|                                   | laufenden Container mit dem Namen |
|                                   | `myContainer` bekommen. Unter     |
|                                   | anderem finden Sie hier, welche   |
|                                   | Datenspeicher (Volumes)           |
|                                   | eingebunden sind. Das ist vor     |
|                                   | allem dann nützlich, wenn Sie dem |
|                                   | Volume keinen menschenlesbaren    |
|                                   | Namen gegeben haben und Ihren     |
|                                   | [Container                        |
|                                   | aktuali                           |
|                                   | sieren](update.html#updatedocker) |
|                                   | wollen.                           |
+-----------------------------------+-----------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::
