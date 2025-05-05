:::: {#header}
# Installation als Docker-Container

::: details
[Last modified on 11-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/introduction_docker.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk aufsetzen](intro_setup.html) [Checkmk-Server im
Docker-Container](managing_docker.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_grundsätzliches .hidden-anchor .sr-only}1. Grundsätzliches {#heading__grundsätzliches}

:::::::: sectionbody
::: paragraph
Es gibt viele Gründe, weshalb Anwender Software in einem
Docker-Container betreiben möchten. Auch Checkmk kann man in einer
Docker-Umgebung einsetzen. Ein Anwendungsfall kann sein, eine dynamisch
erstellte Containergruppe zu überwachen und Checkmk zu einem Teil dieser
Gruppe zu machen. Wird die Containergruppe nicht mehr benötigt, kann
auch die Instanz von Checkmk wieder entfernt werden.
:::

::: paragraph
**Wichtig:** Auch wenn es möglich und sehr einfach ist, Checkmk in eine
containerisierte Umgebung zu integrieren, ist das nicht immer der
sinnvollste Weg. Da jegliche Virtualisierung zum einen eine verringerte
Performance mit sich bringt und zum anderen das Monitoring prinzipiell
möglichst wenige physische Abhängigkeiten haben sollte, eignen sich
Checkmk-Container zum Beispiel nicht, um damit die gesamte Infrastruktur
zu überwachen. In einem in sich abgeschlossenen Container-Cluster kann
es aber durchaus zielführend sein, in dieses einen Checkmk-Container zu
integrieren, um es direkt von innen heraus zu überwachen. Prüfen Sie
also auch und besonders hier, ob das Werkzeug Docker/Container für Ihre
konkrete Anforderung das richtige ist.
:::

::: paragraph
Um Ihnen die Nutzung als Container so einfach wie möglich zu machen,
stellen wir für jede [Checkmk-Edition](intro_setup.html#editions) eigene
Images zur Verfügung, welche neben Checkmk das Linux-Betriebssystem
Ubuntu enthalten:
:::

+-----------------+-----------------------------------------------------+
| [![CRE](../ima  | [Docker                                             |
| ges/icons/CRE.p | Hub](https://hub.d                                  |
| ng "Checkmk Raw | ocker.com/r/checkmk/check-mk-raw/){target="_blank"} |
| "){width="20"}] | oder                                                |
| {.image-inline} | [Checkmk-Down                                       |
| **Checkmk Raw** | load-Seite](https://checkmk.com/de/download?method= |
|                 | docker&edition=cre&version=stable){target="_blank"} |
+-----------------+-----------------------------------------------------+
| Kommerzielle    | [Checkmk-Down                                       |
| Editionen       | load-Seite](https://checkmk.com/de/download?method= |
|                 | docker&edition=cce&version=stable){target="_blank"} |
|                 | (ab                                                 |
|                 | [![CSE](../images/icons/C                           |
|                 | SE.png "Checkmk Cloud"){width="20"}]{.image-inline} |
|                 | **Checkmk Cloud**, d.h. für Checkmk Cloud und       |
|                 | Checkmk MSP),                                       |
|                 | [Checkmk-Kundenporta                                |
|                 | l](https://portal.checkmk.com/de/){target="_blank"} |
+-----------------+-----------------------------------------------------+

::: paragraph
**Hinweis:** Die Bereitstellung im Docker Hub ermöglicht den Download
und die Installation in einem Kommando, wie wir im [Kapitel zur
Installation von Checkmk Raw](#install_cre) zeigen werden.
:::

::: paragraph
In diesem Artikel führen wir Sie durch die Einrichtung von Checkmk in
Docker und zeigen Ihnen einige Tricks, die das Leben mit Checkmk in
Docker einfacher machen. Weitere Informationen finden Sie im Artikel
[Checkmk-Server im Docker-Container.](managing_docker.html)
:::
::::::::
:::::::::

::::: sect1
## []{#prerequisites .hidden-anchor .sr-only}2. Voraussetzungen {#heading_prerequisites}

:::: sectionbody
::: paragraph
Zur Ausführung der in diesem Artikel vorgestellten Kommandos benötigen
Sie eine funktionierende Installation der [Docker
Engine](https://docs.docker.com/engine/install/){target="_blank"} und
Grundkenntnisse in deren Nutzung.
:::
::::
:::::

::::::::::::::::::::::::: sect1
## []{#install_cre .hidden-anchor .sr-only}3. Installation der Checkmk Raw {#heading_install_cre}

:::::::::::::::::::::::: sectionbody
::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Der Start mit
Docker mit der
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** ist einfach. Ein passendes Image steht Ihnen direkt über
Docker Hub zur Verfügung. Das Ganze geht mit einem einzigen Kommando auf
der Linux-Konsole. Dabei wird nicht nur ein Docker-Container mit Checkmk
erzeugt, sondern auch gleich eine Monitoring-Instanz mit dem Namen `cmk`
eingerichtet und gestartet. Diese ist sofort bereit zur Anmeldung mit
dem Benutzer `cmkadmin`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container run -dit -p 8080:5000 -p 8000:8000 --tmpfs /opt/omd/sites/cmk/tmp:uid=1000,gid=1000 -v monitoring:/omd/sites --name monitoring -v /etc/localtime:/etc/localtime:ro --restart always checkmk/check-mk-raw:2.3.0-latest
Unable to find image 'checkmk/check-mk-raw:2.3.0-latest' locally
2.3.0-latest: Pulling from checkmk/check-mk-raw
43f89b94cd7d: Pull complete
c6b4550f40cc: Pull complete
86f6e730bc27: Pull complete
cf0f3e792f33: Pull complete
81777b9c4e2e: Pull complete
da44e2c4d930: Pull complete
Digest: sha256:8a71002e019fab358bcefb204d6bff3390713781df99fb5c6587b289df9796e4
Status: Downloaded newer image for checkmk/check-mk-raw:2.3.0-latest
86e14b7d604033cc44f4b92c25ce67f45967c82db3e84f2e16fee76f4ff48fdf
```
:::
::::

::: paragraph
Nähere Informationen zu den benutzten Optionen:
:::

+---------------------------+------------------------------------------+
| Option                    | Beschreibung                             |
+===========================+==========================================+
| `-p 8080:5000`            | Der Webserver des Containers lauscht     |
|                           | standardmäßig auf Port 5000. In diesem   |
|                           | Beispiel wird der Port 8080 des          |
|                           | Docker-Nodes an den Port des Containers  |
|                           | gebunden, damit dieser von außen         |
|                           | erreichbar ist. Wenn Sie keinen anderen  |
|                           | Container oder Prozess haben, welcher    |
|                           | den Standard-HTTP-Port 80 benutzt,       |
|                           | können Sie den Container auch daran      |
|                           | binden. In diesem Fall würde die Option  |
|                           | so aussehen: `-p 80:5000`. Die Nutzung   |
|                           | von HTTPS wird im Artikel                |
|                           | [Checkmk-Server im                       |
|                           | Docker-Container](managing_docker.html)  |
|                           | erläutert.                               |
+---------------------------+------------------------------------------+
| `-p 8000:8000`            | Seit Checkmk [2.1.0]{.new} müssen Sie    |
|                           | zusätzlich noch den Port des Agent       |
|                           | Receivers veröffentlichen, um die        |
|                           | [Registrierung des Agent                 |
|                           | Con                                      |
|                           | trollers](agent_linux.html#registration) |
|                           | durchführen zu können.                   |
+---------------------------+------------------------------------------+
| `--tmpfs /opt/omd/sites/c | Für eine optimale Performance können Sie |
| mk/tmp:uid=1000,gid=1000` | ein temporäres Dateisystem direkt im RAM |
|                           | des Docker-Nodes nutzen. Mit dieser      |
|                           | Option geben Sie den Pfad zu diesem      |
|                           | Dateisystem an. Wenn Sie die ID der      |
|                           | Instanz ändern, so muss auch dieser Pfad |
|                           | entsprechend angepasst werden.           |
+---------------------------+------------------------------------------+
| `                         | Diese Option bindet die Daten der        |
| -v monitoring:/omd/sites` | Instanz in diesem Container an eine      |
|                           | persistente Stelle im Dateisystem des    |
|                           | Docker-Nodes. Sie gehen daher nicht      |
|                           | verloren, wenn der Container wieder      |
|                           | entfernt wird. Der Teil vor dem          |
|                           | Doppelpunkt bestimmt hierbei den Namen.  |
|                           | So können Sie später den Speicherpunkt   |
|                           | eindeutig identifizieren, zum Beispiel   |
|                           | mit dem Befehl `docker volume ls`.       |
+---------------------------+------------------------------------------+
| `--name monitoring`       | Hiermit wird der Name des Containers     |
|                           | definiert. Dieser Name muss eindeutig    |
|                           | sein und darf auf dem Docker-Node kein   |
|                           | zweites Mal verwendet werden.            |
+---------------------------+------------------------------------------+
| `-v /etc/loc              | Mit dieser Option nutzen Sie in dem      |
| altime:/etc/localtime:ro` | Container dieselbe Zeitzone wie im       |
|                           | Docker-Node. Gleichzeitig wird die Datei |
|                           | nur lesend (`ro`) eingebunden.           |
+---------------------------+------------------------------------------+
| `--restart always`        | Normalerweise startet ein Container      |
|                           | nicht neu, wenn er gestoppt wurde. Mit   |
|                           | dieser Option sorgen Sie dafür, dass er  |
|                           | eben doch automatisch neu startet. Wenn  |
|                           | Sie allerdings einen Container manuell   |
|                           | stoppen, wird er nur neu gestartet, wenn |
|                           | der Docker-Daemon neu startet oder der   |
|                           | Container selbst manuell neu gestartet   |
|                           | wird.                                    |
+---------------------------+------------------------------------------+
| `checkmk/c                | Bezeichnung des Checkmk Images im Format |
| heck-mk-raw:2.3.0-latest` | `<Repository>:<Tag>`. Die Bezeichnungen  |
|                           | können Sie über den Befehl               |
|                           | `docker images` auslesen.                |
+---------------------------+------------------------------------------+

::: {#login .paragraph}
Nachdem alle benötigten Dateien geladen wurden und der Container
gestartet ist, sollten Sie die GUI von Checkmk über
`http://localhost:8080/cmk/check_mk/` erreichen:
:::

:::: imageblock
::: content
![Checkmk-Anmeldedialog.](../images/login.png){width="60%"}
:::
::::

::: paragraph
Sie können sich nun erstmals [einloggen und Checkmk
ausprobieren.](intro_gui.html) Das initiale Passwort für den Benutzer
`cmkadmin` finden Sie in den Logs, die für diesen Container geschrieben
werden (hier auf die wesentlichen Informationen gekürzt):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container logs monitoring
Created new site cmk with version 2.3.0p1.cre.

  The site can be started with omd start cmk.
  The default web UI is available at http://73a86e310b60/cmk/

  The admin user for the web applications is cmkadmin with password: 2JLysBmv
  For command line administration of the site, log in with 'omd su cmk'.
  After logging in, you can change the password for cmkadmin with 'cmk-passwd cmkadmin'.
```
:::
::::

::: paragraph
**Hinweis:** Die im Log angezeigte URL zum Zugriff auf die Weboberfläche
mit der ID des Containers ist nur innerhalb des Containers bekannt und
für den Zugriff von außen im Webbrowser nicht geeignet.
:::

:::::::::::: sect2
### []{#short-lived_containers .hidden-anchor .sr-only}3.1. Kurzlebige Container {#heading_short-lived_containers}

::: paragraph
Wenn Sie sich sicher sind, dass die Daten in der
Checkmk-Container-Instanz nur in diesem speziellen Container verfügbar
sein sollen, können Sie entweder darauf verzichten, dem Container einen
persistenten Datenspeicher zuzuordnen oder diesen Speicher automatisch
beim Stoppen des Containers entfernen.
:::

::: paragraph
Um den persistenten Speicher wegzulassen, lassen Sie schlicht die Option
`-v monitoring:/omd/sites` weg:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container run -dit -p 8080:5000 -p 8000:8000 --tmpfs /opt/omd/sites/cmk/tmp:uid=1000,gid=1000 --name monitoring -v /etc/localtime:/etc/localtime:ro --restart always checkmk/check-mk-raw:2.3.0-latest
```
:::
::::

::: paragraph
Um einen persistenten Speicher anzulegen und beim Stoppen automatisch zu
entfernen, verwenden Sie den folgenden Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container run --rm -dit -p 8080:5000 -p 8000:8000 --tmpfs /opt/omd/sites/cmk/tmp:uid=1000,gid=1000 -v /omd/sites --name monitoring -v /etc/localtime:/etc/localtime:ro checkmk/check-mk-raw:2.3.0-latest
```
:::
::::

::: paragraph
Dieser Befehl hat --- im Gegensatz zu dem vorherigen --- lediglich zwei
andere Optionen:
:::

::: ulist
- Mit `--rm` übergeben Sie direkt zum Start den Befehl, dass auch der
  Datenspeicher für den Container beim Stoppen entfernt werden soll. Auf
  diese Weise sparen Sie sich das manuelle Aufräumen, wenn Sie viele
  kurzlebige Checkmk-Container haben.

  ::: paragraph
  **Wichtig:** Beim Stoppen wird auch der Container selbst komplett
  entfernt!
  :::

- Die Option `-v /omd/sites` ist im Vergleich zu oben angepasst. Sie
  beinhaltet keinen selbst vergebenen Namen mehr, da der Datenspeicher
  sonst nicht korrekt gelöscht wird.
:::
::::::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::: sect1
## []{#install_cee .hidden-anchor .sr-only}4. Installation der kommerziellen Editionen {#heading_install_cee}

::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Auch die
kommerziellen Editionen können Sie in einem Docker-Container betreiben.
Die Images der kommerziellen Editionen sind nicht frei über Docker Hub
verfügbar. Laden Sie sich die gewünschte Edition und Version von der
[Checkmk-Download-Seite](https://checkmk.com/de/download?method=docker&edition=cce&version=stable){target="_blank"}
(ab Checkmk Cloud) oder im
[Checkmk-Kundenportal](https://portal.checkmk.com/de/){target="_blank"}
herunter.
:::

::: paragraph
Laden Sie das Image aus der heruntergeladenen tar-Archivdatei in Docker,
im folgenden Beispiel für Checkmk Cloud:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker load -i check-mk-cloud-docker-2.3.0p1.tar.gz
1f35d34cf8fa: Loading layer [==================================================>]  2.048kB/2.048kB
9fcc49e3e223: Loading layer [==================================================>]  365.5MB/365.5MB
96507768f1a4: Loading layer [==================================================>]  261.2MB/261.2MB
a65c9018ee9b: Loading layer [==================================================>]   1.27GB/1.27GB
4dbb1e959fe6: Loading layer [==================================================>]  7.168kB/7.168kB
Loaded image: checkmk/check-mk-cloud:2.3.0p1
```
:::
::::

::: paragraph
Danach können Sie den Container mit einem sehr ähnlichen Befehl wie oben
starten. Achten Sie nur darauf, dass Sie den Namen des geladenen Images
(`Loaded image`) aus der vorherigen Kommandoausgabe im folgenden
Startkommando verwenden, also in diesem Beispiel
`checkmk/check-mk-cloud:2.3.0p1`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container run -dit -p 8080:5000 -p 8000:8000 --tmpfs /opt/omd/sites/cmk/tmp:uid=1000,gid=1000 -v monitoring:/omd/sites --name monitoring -v /etc/localtime:/etc/localtime:ro --restart always checkmk/check-mk-cloud:2.3.0p1
f00d10fcb16313d3539065933b90c4dec9f81745f3d7283d794160f4f9b28df1
```
:::
::::

::: paragraph
Nach dem Start des Containers können Sie sich an der
Checkmk-Weboberfläche anmelden, wie es bei der [Installation der Checkmk
Raw](#login) beschrieben ist.
:::
:::::::::::
::::::::::::

::::: sect1
## []{#update .hidden-anchor .sr-only}5. Update {#heading_update}

:::: sectionbody
::: paragraph
Wie Sie Checkmk im Docker-Container aktualisieren können, ist im Artikel
[Updates und Upgrades](update.html#updatedocker) beschrieben.
:::
::::
:::::

:::::::::::::: sect1
## []{#uninstall .hidden-anchor .sr-only}6. Deinstallation {#heading_uninstall}

::::::::::::: sectionbody
::: paragraph
Bei der Deinstallation entfernen Sie den Docker-Container und optional
die beim Erstellen des Containers erzeugten Daten.
:::

::: paragraph
Lassen Sie sich die Docker-Container auflisten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container ls -a
CONTAINER ID   IMAGE                                 COMMAND                  CREATED          STATUS                    PORTS                              NAMES
9a82ddbabc6e   checkmk/check-mk-cloud:2.3.0p1   "/docker-entrypoint.…"   57 minutes ago   Up 53 minutes (healthy)   6557/tcp, 0.0.0.0:8080->5000/tcp   monitoring
```
:::
::::

::: paragraph
Übernehmen Sie aus der Kommandoausgabe die angezeigte `CONTAINER ID` für
die nächsten Kommandos.
:::

::: paragraph
Stoppen Sie zuerst den Container und entfernen Sie ihn anschließend:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# docker container stop 9a82ddbabc6e
9a82ddbabc6e
root@linux# docker container rm 9a82ddbabc6e
9a82ddbabc6e
```
:::
::::

::: paragraph
Falls Sie den Container mit der Option `-v monitoring:/omd/sites`
erstellt haben, können Sie auch das dadurch erstellte Docker-Volume
entfernen: `docker volume ls` zeigt die Volumes an und
`docker volume rm <VOLUME NAME>` löscht das Volume.
:::

::: paragraph
Auf ähnliche Weise können Sie abschließend auch das Image entfernen: Mit
`docker images` erhalten Sie die Liste der Images und
`docker rmi <IMAGE ID>` entfernt das ausgewählte Image.
:::
:::::::::::::
::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
