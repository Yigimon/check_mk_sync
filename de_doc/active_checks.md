:::: {#header}
# Netzwerkdienste überwachen (Aktive Checks)

::: details
[Last modified on 22-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/active_checks.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html)
[Datenquellenprogramme](datasource_programs.html) [Linux
überwachen](agent_linux.html) [Windows überwachen](agent_windows.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::: sectionbody
::: paragraph
In Checkmk haben Sie viele Möglichkeiten, Ihre Infrastruktur zu
überwachen. Die Überwachung durch einen
[Agenten](wato_monitoringagents.html#agents) oder [SNMP](snmp.html) sind
dabei nur zwei von [mehreren Methoden.](wato_monitoringagents.html)
Beiden ist gemein, dass sie einem nur Zustände mitteilen, wie sie der
Host von innen heraus sieht. Sie werden aber sicher einige Dienste
kennen, die man nur von außen sinnvoll überwachen kann. Ob der Webserver
läuft, lässt sich noch von innen heraus beantworten. Wie jedoch die
Erreichbarkeit und die Antwortzeiten bei dem eigentlichen Benutzer
aussehen, lässt sich auf diese Weise nicht herausfinden.
:::

::: paragraph
Checkmk bietet für diese Fälle die aktiven Checks (*active checks*) an.
Über diese können Sie Netzwerkdienste direkt und bequem von außen
überwachen und die Daten auf ihrem Host anzeigen lassen. Aktive Checks
sind also kleine Programme oder Skripte, die eine Verbindung zu einem
Dienst im Netzwerk oder Internet aufbauen und dem Benutzer dann die
Monitoring-Daten zur Verfügung stellen. Viele der Skripte und Programme,
die Sie in Checkmk finden, stammen ursprünglich von
[monitoring-plugins.org.](https://www.monitoring-plugins.org){target="_blank"}
Da Checkmk aber generell kompatibel zu Nagios ist, können Sie alle
Plugins nutzen, die auch unter Nagios funktionieren.
:::

::: paragraph
Wenn Sie solche Plugins integrieren, behalten Sie den Hauptzweck der
aktiven Checks im Auge: Sie sollen im Sinne eines End-to-End-Monitorings
die Erreichbarkeit, Antwortzeit oder den Antwortstatus eines über das
Netzwerk erreichbaren Dienstes auf dem überwachten Host prüfen. Für
viele andere Überwachungsaufgaben bietet Checkmk effizientere Checks.
Eine Übersicht finden Sie im Artikel [Erweiterungen für Checkmk
entwickeln.](devel_intro.html)
:::

::: paragraph
Die wichtigsten dieser Programme und Skripte sind in Checkmk direkt in
der Weboberfläche verfügbar. Hier eine kleine Auswahl:
:::

::: ulist
- [Check HTTP web
  service](https://checkmk.com/de/integrations/check_httpv2){target="_blank"}

- [Check
  certificates](https://checkmk.com/de/integrations/check_cert){target="_blank"}

- [Check DNS
  service](https://checkmk.com/de/integrations/check_dns){target="_blank"}

- [Check access to SMTP
  services](https://checkmk.com/de/integrations/check_smtp){target="_blank"}

- [Check
  Email](https://checkmk.com/de/integrations/check_mail){target="_blank"}

- [Check SFTP
  service](https://checkmk.com/de/integrations/check_sftp){target="_blank"}

- [Check connecting to a TCP
  Port](https://checkmk.com/de/integrations/check_tcp){target="_blank"}

- [Check SSH
  service](https://checkmk.com/de/integrations/check_ssh){target="_blank"}

- [Check hosts with PING (ICMP Echo
  Request)](https://checkmk.com/de/integrations/check_icmp){target="_blank"}

- [Check access to LDAP
  service](https://checkmk.com/de/integrations/check_ldap){target="_blank"}
:::
::::::::
:::::::::

::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup .hidden-anchor .sr-only}2. Aktive Checks einrichten {#heading_setup}

:::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_reguläre_aktive_checks_einrichten .hidden-anchor .sr-only}2.1. Reguläre aktive Checks einrichten {#heading__reguläre_aktive_checks_einrichten}

::: paragraph
Im [Setup]{.guihint} können Sie --- wie bereits weiter oben
erwähnt --- die wichtigsten und am häufigsten genutzten Checks direkt in
der Weboberfläche einrichten. Wählen Sie dafür den Menüpunkt [Setup \>
Services \> HTTP, TCP, Email.]{.guihint} Hier finden Sie die Regelsätze,
mit denen Sie diese Checks einrichten können:
:::

:::: imageblock
::: content
![Liste der Regelsätze für aktive
Checks.](../images/active_checks_rulesets.png)
:::
::::

::: paragraph
Die meisten Optionen in den Regelsätzen sind selbsterklärend. Falls doch
einmal etwas unklar sein sollte, können Sie auch hier für viele Optionen
auf die [Inline-Hilfe](user_interface.html#inline_help) zurückgreifen.
:::
:::::::

::::::::::::::: sect2
### []{#_aktive_checks_einem_host_zuweisen .hidden-anchor .sr-only}2.2. Aktive Checks einem Host zuweisen {#heading__aktive_checks_einem_host_zuweisen}

::: paragraph
Bei manchen Regeln ist es in den Optionen notwendig, eine IP-Adresse
oder einen Host-Namen anzugeben. An vielen Stellen ist möglich diese
Option leer zu lassen, so dass der Host-Name oder dessen IP genommen
wird. Auf diese Weise können Sie sehr leicht mit nur einer Regel eine
ganze Gruppe an Hosts mit einem aktiven Check versorgen. Achten Sie
daher immer darauf (auch mit Hilfe der bereits erwähnten Inline-Hilfe),
ob diese Möglichkeit in dem konkreten Regelsatz zur Verfügung steht. Sie
sparen sich damit unter Umständen eine Menge Konfigurationsarbeit.
:::

::: paragraph
[Check HTTP web service]{.guihint} ist ein häufig benötigter Check zur
Überwachung vieler Parameter von Webservern, wie Zertifikatsgültigkeit,
Antwortzeit, Response Code oder der Suche nach Zeichenketten in
ausgelieferten Webseiten. Sie finden ihn unter [Networking \> Check HTTP
web service]{.guihint}. Nehmen wir an, Sie möchten die Gültigkeit der
Zertifikate sämtlicher Webserver in Ihrer Infrastruktur überwachen,
Antwortzeiten von unter einer Sekunde und einen Statuscode 200
sicherstellen, dafür aber nicht Dutzende oder gar Hunderte Regeln
anlegen:
:::

:::: imageblock
::: content
![Beispielhafte Konfiguration der Regel \'Check HTTP web
service\'.](../images/active_checks_http_conf.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | **Warum existiert mit [Check      |
|                                   | certificates]{.guihint} ein       |
|                                   | weiterer aktiver Check für        |
|                                   | Zertifikate?**                    |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Der vorgestellte Check [Check     |
|                                   | HTTP web service]{.guihint} führt |
|                                   | immer *einen vollständigen*       |
|                                   | HTTP-Request durch, was seinen    |
|                                   | Einsatz auf Webserver beschränkt. |
|                                   | Im Gegenzug ist seine Ausführung  |
|                                   | sehr effizient, er kann mit nur   |
|                                   | einem *einzigen* HTTP-Request     |
|                                   | eine Reihe von Prüfungen          |
|                                   | durchführen.                      |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Dagegen prüft [Check              |
|                                   | certificates]{.guihint} nur den   |
|                                   | TLS-Verbindungsaufbau und dabei   |
|                                   | die Zertifikate. Dieser Check     |
|                                   | kann folglich auch auf anderen    |
|                                   | mit TLS abgesicherten Diensten    |
|                                   | wie IMAP/S angewandt werden.      |
|                                   | Zudem kann er Zertifikate weit    |
|                                   | detaillierter untersuchen,        |
|                                   | beispielsweise auf bestimmte per  |
|                                   | [Server Name Indication           |
|                                   | (SNI)](http                       |
|                                   | s://de.wikipedia.org/wiki/Server_ |
|                                   | Name_Indication){target="_blank"} |
|                                   | hinterlegte Host-Namen.           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Um den eben konfigurierten Check mit einer einzigen Regel auf alle
passenden Hosts anzuwenden, machen Sie sich zunächst Gedanken, wie Sie
die [Conditions]{.guihint} am besten befüllen. In dem nachfolgenden
Beispiel nutzen wir dafür die Funktion der [Labels](glossar.html#label)
und setzen auf alle unsere Webserver das Label `webprotocol:https`. Mit
solch einem Label können Sie eine Regel anlegen und die
[Conditions]{.guihint} auf eben dieses Label setzen:
:::

:::: imageblock
::: content
![Einschränkung der Regel per Host-Label auf
Webserver.](../images/active_checks_http_conditions.png)
:::
::::

::: paragraph
Nachdem Sie die eben erstellte Regel aktiviert haben, suchen Sie im
[Monitor-Menü](user_interface.html#search_monitor) nach dem soeben
gesetzten Service-Namen `Basic webserver health`. Im nachfolgenden
Beispiel sehen Sie die Hosts bei denen das Label entsprechend gesetzt
wurde.
:::

:::: imageblock
::: content
![Die von der Regel erzeugten Services im
Monitoring.](../images/active_checks_http_services.png)
:::
::::

::: paragraph
**Wichtig**: Beachten Sie, dass bei den aktiven Checks nicht nur die
erste Regel ausgewertet wird, auf welche die Bedingungen zutreffen,
sondern vielmehr *alle*, für die die Bedingungen zu einem Host
zutreffen. Nur so ist es möglich, mehrere aktive Services auf einem Host
anzulegen.
:::
:::::::::::::::

::::::::::::::::::::::::: sect2
### []{#nagios_plugins .hidden-anchor .sr-only}2.3. Andere zu Nagios kompatible Plugins einbinden {#heading_nagios_plugins}

::: paragraph
In Checkmk stehen Ihnen natürlich nicht nur die aktiven Checks zur
Verfügung, die Sie in der Weboberfläche als Regelsätze vorfinden. Über
diese Check-Plugins hinaus, finden Sie noch viele weitere in Ihrer
Instanz. Um die Übersicht zu wahren, werden in der folgenden Ausgabe nur
ausgewählte Zeilen angezeigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll ~/lib/nagios/plugins/
total 2466
-rwxr-xr-x 1 root root   56856 Feb  3 00:45 check_dig
-rwxr-xr-x 1 root root    6396 Feb  3 00:45 check_flexlm
-rwxr-xr-x 1 root root    6922 Feb  3 00:45 check_ircd
-rwxr-xr-x 1 root root   60984 Feb  3 00:45 check_ntp_peer
-rwxr-xr-x 1 root root   78136 Feb  3 00:45 check_snmp
```
:::
::::

::: paragraph
Jedes dieser Check-Plugins bietet auch eine Hilfe-Option an (`-h`), über
die Sie mehr zur Nutzung des jeweiligen Plugins erfahren können, ohne
die
[monitoring-plugins.org](https://www.monitoring-plugins.org){target="_blank"}
Website bemühen zu müssen.
:::

::: paragraph
Checkmk bietet dafür unter [Setup \> Services \> Other
services]{.guihint} den speziellen Regelsatz [Integrate Nagios
plugins]{.guihint} an, um diese Plugins bequem nutzen zu können. Die
beiden wichtigsten Optionen sind hier die Angabe einer
Service-Beschreibung und die Kommandozeile. Letztere kann so geschrieben
werden, als würden Sie sich bereits im richtigen Verzeichnis befinden:
:::

:::: imageblock
::: content
![Regel zur Integration von Nagios
plugins.](../images/active_checks_custom_config.png)
:::
::::

::: paragraph
Beachten Sie, dass Ihnen hier auch die oben gezeigten Makros, wie
`$HOSTNAME$` oder `$HOSTADDRESS$` zur Verfügung stehen. Eine Liste von
allen verfügbaren Makros finden Sie wie immer in der Inline-Hilfe.
Nachdem Sie die Änderungen aktiviert haben, können Sie den neuen Service
auf dem zugeordneten Host sehen:
:::

:::: imageblock
::: content
![Der von der Regel erzeugte Service im
Monitoring.](../images/active_checks_custom_service01.png)
:::
::::

:::::::::::::: sect3
#### []{#_eigene_plugins_verwenden .hidden-anchor .sr-only}Eigene Plugins verwenden {#heading__eigene_plugins_verwenden}

::: paragraph
In manchen Fällen haben Sie bereits eigene Plugins geschrieben und
möchten diese nun in Checkmk verwenden. In diesem Fall ist das Vorgehen
weitgehend identisch. Voraussetzung ist lediglich, dass das Plugin
kompatibel zu Nagios ist. Dazu gehört eine einzeilige Ausgabe mit den
Details des Status und ein Exit-Code, welcher den Status beschreibt.
Dieser muss `0` für [OK]{.state0}, `1` für [WARN]{.state1}, `2` für
[CRIT]{.state2} oder `3` für [UNKNOWN]{.state3} sein.
:::

::: paragraph
Ein kurzes Beispiel, um die sehr einfache Syntax zu veranschaulichen,
zeigt das folgende Skript, dass Sie z.B. im Unterverzeichnis `~/tmp` des
Instanzverzeichnisses erstellen können:
:::

::::: listingblock
::: title
\~/tmp/myscript.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
echo "I am a self written check and I feel well."
exit 0
```
:::
:::::

::: paragraph
Legen Sie das Plugin in dem lokalen Pfad ihrer Instanz ab und machen Sie
es in einem Rutsch ausführbar:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ install -m755 ~/tmp/myscript.sh ~/local/lib/nagios/plugins/
```
:::
::::

::: paragraph
Das weitere Vorgehen ist dann identisch zu anderen Plugins, die über den
Regelsatz [Integrate Nagios plugins]{.guihint} angelegt werden, so dass
Sie am Ende den neuen Service sehen können:
:::

:::: imageblock
::: content
![Der vom eigenen Plugin erzeugte Service im
Monitoring.](../images/active_checks_custom_service02.png)
:::
::::
::::::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#special_features .hidden-anchor .sr-only}3. Besonderheiten bei aktiven Checks {#heading_special_features}

::::: sectionbody
::: paragraph
Services, welche durch aktive Checks erstellt wurden, verhalten sich in
mancher Hinsicht anders, als andere Services. So wird der Service eines
aktiven Checks...​
:::

::: ulist
- ...​ auch dann weiter geprüft, wenn ein Host [DOWN]{.hstate1} ist.

- ...​ unabhängig von anderen (passiven) Services ausgeführt. Das
  ermöglicht auch das Setzen eines eigenen Intervalls.

- ...​ immer vom Checkmk-Server ausgeführt. Ausnahmen sind hier
  [MRPEs](#mrpe), welche direkt auf einem Host ausgeführt werden.

- ...​ nicht über die [Service-Erkennung](glossar.html#service_discovery)
  aufgenommen, sondern automatisch erzeugt.
:::
:::::
::::::

::::::: sect1
## []{#mrpe .hidden-anchor .sr-only}4. Aktive Checks auf einem Host ausführen (MRPE) {#heading_mrpe}

:::::: sectionbody
::: paragraph
Angenommen, Sie überwachen von Ihrer Checkmk-Instanz einen Host A (bspw.
einen Webserver), der wiederum auf Dienste von Host B (bspw. eine
Datenbank) zurückgreift. Eine Überwachung der Services auf Host B direkt
von der Checkmk-Instanz aus wird sehr wahrscheinlich durch andere
Paketlaufzeiten etc. verfälscht werden und daher keine Aussage darüber
treffen, wie sich die Erreichbarkeit in der Praxis von Host A verhält.
Hier ist es praktisch, ein Nagios-Plugin vom Agenten des überwachten
Hosts (hier A) ausführen zu lassen, welches direkt die Dienste auf Host
B überprüft.
:::

::: paragraph
Hierfür stellen wir *MK's Remote Plugin Executor* (kurz: MRPE) zur
Verfügung. Je nachdem, ob Sie ein solches Plugin auf einem Unix-artigen
System oder auf einem Windows System ausführen wollen, legen Sie es an
unterschiedlichen Stellen im Installationsverzeichnis des jeweiligen
Agenten ab. Zusätzlich benötigen Sie noch eine Konfigurationsdatei,
welche bestimmt, in welcher Art und Weise das Plugin ausgeführt werden
soll und wie die konkrete Kommandozeile für den Aufruf aussieht.
:::

::: paragraph
Ausführliche Anleitungen finden Sie in den jeweiligen Artikeln zu
[Linux](agent_linux.html#mrpe) und [Windows.](agent_windows.html#mrpe)
:::
::::::
:::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}5. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `~/li              | Hier finden Sie alle Plugins, welche mit        |
| b/nagios/plugins/` | Checkmk mitgeliefert werden. Es wird dabei      |
|                    | keine Unterscheidung zwischen Plugins gemacht,  |
|                    | welche von                                      |
|                    | [monitoring-plugins.org](https                  |
|                    | ://www.monitoring-plugins.org){target="_blank"} |
|                    | und welche speziell für Checkmk geschrieben     |
|                    | wurden.                                         |
+--------------------+-------------------------------------------------+
| `~/local/li        | Eigene Plugins legen Sie hier ab. Sie werden    |
| b/nagios/plugins/` | dann dynamisch eingelesen und überstehen auch   |
|                    | ein Update der Checkmk-Instanz.                 |
+--------------------+-------------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
