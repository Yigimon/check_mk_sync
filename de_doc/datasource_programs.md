:::: {#header}
# Datenquellenprogramme

::: details
[Last modified on 07-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/datasource_programs.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Linux
überwachen](agent_linux.html) [Lokale Checks](localchecks.html) [Der
Piggyback-Mechanismus](piggyback.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::::: sectionbody
::: paragraph
Der Checkmk-Server erreicht Hosts im
[Pull-Modus](glossar.html#pull_mode) üblicherweise über eine
TCP-Verbindung auf Port 6556. Seit Version [2.1.0]{.new} lauscht auf
diesem Port in den meisten Fällen der Agent Controller, welcher die
Agentenausgabe über eine TLS verschlüsselte Verbindung weiterleitet.
Checkmk [2.2.0]{.new} führte mit dem
[Push-Modus](glossar.html#push_mode) die zusätzliche Möglichkeit ein,
die Übertragungsrichtung zu wählen.
:::

::: paragraph
Es gibt jedoch Umgebungen --- zum Beispiel bei sehr schlanken
Containern, Legacy- oder Embedded-Systemen --- , in der der Agent
Controller nicht verwendet werden kann. Im *Legacy-Modus* kommt hier
`(x)inetd` zum Einsatz, der bei jeder Anfrage das Agentenskript
ausführt, die Ausgabe im Klartext überträgt und dann die Verbindung
wieder schließt.
:::

::: paragraph
In vielen Fällen verlangen Richtlinien, dass Sicherheitsaspekte wie der
Verzicht auf die Übertragung von Daten im Klartext berücksichtigt werden
müssen. So kann ein Angreifer zwar mit den Füllständen von Dateisystemen
meist wenig anfangen, aber Prozesstabellen und Listen von anstehenden
Sicherheitsupdates können helfen, Angriffe zielgerichtet vorzubereiten.
Darüber hinaus sollen oft keine zusätzlichen Ports geöffnet und
stattdessen vorhandene Kommunikationskanäle genutzt werden.
:::

::: paragraph
Die universelle Methode, um solche Transportwege an Checkmk anzudocken,
sind die Datenquellenprogramme (*datasource programs*). Die Idee ist
sehr einfach: Sie geben Checkmk die Kommandozeile eines Befehls.
Anstelle der Verbindung auf Port 6556 führt Checkmk diesen Befehl aus.
Dieser produziert die Agentendaten auf der *Standardausgabe*, welche
dann von Checkmk genauso verarbeitet werden, als kämen sie von einem
„normalen" Agenten. Da Änderungen der Datenquellen meist Transportwege
betreffen, ist es wichtig, dass Sie den Host in der
[Setup-GUI](hosts_setup.html#monitoring_agents) auf der Einstellung [API
integrations if configured, else Checkmk agent]{.guihint} belassen.
:::

::: paragraph
Die Modularität von Checkmk hilft, diese Anforderungen zu erfüllen.
Letztlich kann die Klartextausgabe des Agentenskripts über beliebige
Wege transportiert werden --- direkt oder indirekt, per Pull oder Push.
Hier sind einige Beispiele, mit denen Checkmk-Anwender Daten vom Agenten
zum Checkmk-Server bekommen:
:::

::: ulist
- per E-Mail

- per HTTP-Zugriff vom Server aus

- per HTTP-Upload vom Host aus

- per Zugriff auf eine Datei, die per `rsync` oder `scp` vom Host zum
  Server kopiert wurde

- per Skript, welches die Daten per HTTP von einem Webdienst abholt
:::

::: paragraph
Ein weiterer Anwendungsbereich für Datenquellenprogramme sind Systeme,
die keine Agenten-Installation zulassen, aber Zustandsdaten per REST-API
oder über eine Telnet-Schnittstelle herausgeben. In solchen Fällen
können Sie ein Datenquellenprogramm schreiben, das die vorhandene
Schnittstelle abfragt und aus den gewonnenen Daten Agenten-Output
generiert.
:::
::::::::::
:::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#writing .hidden-anchor .sr-only}2. Schreiben von Datenquellenprogrammen {#heading_writing}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::: sect2
### []{#_das_einfachst_mögliche_programm .hidden-anchor .sr-only}2.1. Das einfachst mögliche Programm {#heading__das_einfachst_mögliche_programm}

::: paragraph
Das Schreiben und Einbinden eines eigenen Datenquellenprogramms ist
nicht schwer. Sie können jede von Linux unterstützte Skript- und
Programmiersprache verwenden. Legen Sie das Programm am besten im
Verzeichnis `~/local/bin/` an, dann wird es immer automatisch ohne
Pfadangabe gefunden.
:::

::: paragraph
Folgendes erstes minimale Beispiel heißt `myds` und erzeugt einfache
fiktive Monitoring-Daten. Anstatt einen neuen Transportweg zu
integrieren, erzeugt es Monitoring-Daten selbst. Diese enthalten als
einzige Sektion `<<<df>>>`. mit der Information zu einem einzigen
Dateisystem der Größe 100 kB und dem Namen `My_Disk`. Das Ganze ist ein
Shell-Skript mit drei Zeilen:
:::

::::: listingblock
::: title
\~/local/bin/myds
:::

::: content
``` {.pygments .highlight}
#!/bin/sh
echo '<<<df>>>'
echo 'My_Disk  foobar  100 70 30  70% /my_disk'
```
:::
:::::

::: paragraph
Vergessen Sie nicht, Ihr Programm ausführbar zu machen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ chmod +x local/bin/myds
```
:::
::::

::: paragraph
Legen Sie nun im Setup zum Test einen Host an --- z.B. `myserver125`.
Dieser benötigt keine IP-Adresse. Um zu verhindern, dass Checkmk den
Namen `myserver125` per DNS aufzulösen versucht, tragen Sie diesen Namen
als explizite „IP-Adresse" ein.
:::

::: paragraph
Legen Sie dann eine Regel im Regelsatz [Setup \> Agents \> Other
integrations \> Individual program call instead of agent
access]{.guihint} an, welche für diesen Host gilt und tragen Sie `myds`
als aufzurufendes Programm ein:
:::

:::: imageblock
::: content
![Eingabemaske für einen individuellen
Befehl.](../images/ds_program.png)
:::
::::

::: paragraph
Wenn Sie jetzt in der Setup-GUI zur Service-Konfiguration des Hosts
wechseln, sollten Sie genau einen Service sehen, der für die Überwachung
bereitsteht:
:::

:::: imageblock
::: content
![Der neue Service wurde erkannt.](../images/ds_program_discovery.png)
:::
::::

::: paragraph
Nehmen Sie diesen in die Überwachung auf, aktivieren Sie die Änderungen
und Ihr erstes Datenquellenprogramm läuft. Sobald Sie jetzt testweise
die Daten ändern, die das Programm auswirft, wird das der nächste Check
des Dateisystems `My_Disk` sofort anzeigen.
:::
:::::::::::::::::::

:::::::::::: sect2
### []{#_fehlerdiagnose .hidden-anchor .sr-only}2.2. Fehlerdiagnose {#heading__fehlerdiagnose}

::: paragraph
Wenn etwas nicht funktioniert, können Sie auf der Kommandozeile mit
`cmk -D` die Konfiguration des Hosts überprüfen und feststellen, ob Ihre
Regel greift:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -D myserver125

myserver125
Addresses:              myserver125
Tags:                   [address_family:ip-v4-only], [agent:cmk-agent], [criticality:prod], [ip-v4:ip-v4], [networking:lan], [piggyback:auto-piggyback], [site:mysite], [snmp_ds:no-snmp], [tcp:tcp]
Host groups:            check_mk
Agent mode:             Normal Checkmk agent, or special agent if configured
Type of agent:
Program: myds
```
:::
::::

::: paragraph
Mit einem `cmk -d` können Sie den Abruf der Agentendaten --- und damit
das Ausführen Ihres Programms --- auslösen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d myserver125
<<<df>>>
My_Disk  foobar  100 70 30  70% /my_disk
```
:::
::::

::: paragraph
Ein doppeltes `-v` sollte eine Meldung erzeugen, dass Ihr Programm
aufgerufen wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vvd myserver125
Calling: myds
<<<df>>>
My_Disk  foobar  100 70 30  70% /my_disk
```
:::
::::
::::::::::::

:::::::::::::::: sect2
### []{#_übergeben_des_host_namens .hidden-anchor .sr-only}2.3. Übergeben des Host-Namens {#heading__übergeben_des_host_namens}

::: paragraph
Das Programm aus dem ersten Beispiel funktioniert zwar, ist aber nicht
sehr praxistauglich, denn es gibt immer die gleichen Daten aus, egal für
welchen Host es aufgerufen wird.
:::

::: paragraph
Ein echtes Programm, dass z.B. per HTTP von irgendwoher Daten holt,
benötigt dazu zumindest den Namen des Hosts, für den Daten geholt werden
sollen. Sie können diesen in der Kommandozeile mit dem Platzhalter
`$HOSTNAME$` übergeben lassen:
:::

:::: imageblock
::: content
![Übergabe des Host-Namens mit dem Makro
\$HOSTNAME\$.](../images/ds_program_host.png)
:::
::::

::: paragraph
In diesem Beispiel bekommt das Programm `myds` den Host-Namen als erstes
Argument geliefert. Folgendes Beispielprogramm gibt diesen zum Testen in
Form eines [lokalen Checks](localchecks.html) aus. Es greift per `$1`
auf das erste Argument zu und speichert es zum Zwecke der Übersicht in
der Variable `$HOST_NAME`. Diese wird dann in die Plugin-Ausgabe des
lokalen Checks eingesetzt:
:::

::::: listingblock
::: title
\~/local/bin/myds
:::

::: content
``` {.pygments .highlight}
#!/bin/sh
HOST_NAME="$1"

echo '<<<local>>>'
echo "0 Hostname - My name is ${HOST_NAME}"
```
:::
:::::

::: paragraph
Die Service-Erkennung wird jetzt einen neuen Service vom Typ `local`
finden, in dessen Ausgabe der Host-Name zu sehen ist:
:::

:::: imageblock
::: content
![Die Service-Erkennung findet den neuen Service, der nun den
übergebenen Host-Namen als Information
ausgibt.](../images/ds_program_discovery_host.png)
:::
::::

::: paragraph
Der Schritt zu einem echten Datenquellenprogramm, das z.B. Daten per
HTTP mit dem Befehl `curl` holt, ist jetzt nicht mehr weit. Folgende
Platzhalter sind in der Befehlszeile der Datenquellenprogramme erlaubt:
:::

+--------------------+-------------------------------------------------+
| `$HOSTNAME$`       | Der Host-Name, wie er im Setup konfiguriert     |
|                    | ist.                                            |
+--------------------+-------------------------------------------------+
| `$HOSTADDRESS$`    | Diejenige IP-Adresse des Hosts, über die er     |
|                    | überwacht wird.                                 |
+--------------------+-------------------------------------------------+
| `$_HOSTTAGS$`      | Die Liste aller                                 |
|                    | [Host-Merkmale](glossar.html#host_tag) durch    |
|                    | Leerzeichen getrennt. Setzen Sie dieses         |
|                    | Argument auf jeden Fall in Anführungszeichen,   |
|                    | um es vor einem Aufteilen durch die Shell zu    |
|                    | schützen.                                       |
+--------------------+-------------------------------------------------+

::: paragraph
Falls Sie den Host dual per IPv4 und IPv6 überwachen, sind unter
Umständen noch folgende Makros für Sie interessant:
:::

+--------------------+-------------------------------------------------+
| `$_HOSTADDRESS_4$` | Die IPv4-Adresse des Hosts                      |
+--------------------+-------------------------------------------------+
| `$_HOSTADDRESS_6$` | Die IPv6-Adresse des Hosts                      |
+--------------------+-------------------------------------------------+
| `$_HO              | Die Ziffer `4`, wenn die zur Überwachung        |
| STADDRESS_FAMILY$` | genutzte Adresse die IPv4-Adresse ist,          |
|                    | ansonsten `6`.                                  |
+--------------------+-------------------------------------------------+
::::::::::::::::

:::::::::::::::::::: sect2
### []{#_fehlerbehandlung .hidden-anchor .sr-only}2.4. Fehlerbehandlung {#heading__fehlerbehandlung}

::: paragraph
Egal, welchen Beruf Sie in der IT ausüben --- den meisten Teil Ihrer
Zeit werden Sie sich mit Fehlern und Problemen befassen. Und auch
Datenquellenprogramme bleiben davon nicht verschont. Vor allem bei
Programmen, die per Netzwerk Daten beschaffen, ist ein Fehler keineswegs
unrealistisch.
:::

::: paragraph
Damit Ihr Programm Checkmk so einen Fehler sauber mitteilen kann, gilt
Folgendes:
:::

::: {.olist .arabic}
1.  Jeder Exit Code außer `0` wird als Fehler gewertet.

2.  Fehlermeldungen werden auf dem Standardfehlerkanal (`stderr`)
    erwartet.
:::

::: paragraph
Falls ein Datenquellenprogramm scheitert,
:::

::: ulist
- verwirft Checkmk die kompletten Nutzdaten der Ausgabe,

- setzt den Checkmk-Service auf [CRIT]{.state2} und zeigt dort die Daten
  von `stderr` als Fehler an,

- bleiben die eigentlichen Services auf dem alten Stand (und werden mit
  der Zeit veralten).
:::

::: paragraph
Sie können das Beispiel von oben so modifizieren, dass es einen Fehler
simuliert. Mit der Umleitung `>&2` wird der Text auf `stderr` gelenkt.
Und `exit 1` setzt den Exit Code des Programms auf `1`:
:::

::::: listingblock
::: title
\~/local/bin/myds
:::

::: content
``` {.pygments .highlight}
#!/bin/sh
HOST_NAME=$1

echo "<<<local>>>"
echo "0 Hostname - My name is $HOST_NAME"

echo "This didn't work out" >&2
exit 1
```
:::
:::::

::: paragraph
Im Checkmk-Service sieht dies dann so aus:
:::

:::: imageblock
::: content
![Wenn ein Skript von 0 verschiedene Exit Codes liefert, wird der Dienst
sofort CRIT (rot).](../images/ds_program_error.png)
:::
::::

::: paragraph
Falls Sie Ihr Programm als Shell-Skript schreiben, können Sie gleich am
Anfang die Option `set -e` verwenden:
:::

::::: listingblock
::: title
\~/local/bin/myds
:::

::: content
``` {.pygments .highlight}
#!/bin/sh
set -e
```
:::
:::::

::: paragraph
Sobald ein Befehl fehlschlägt (Exit Code ungleich `0`), bricht die Shell
sofort ab und beendet das Skript mit dem Exit Code `1`. Damit haben Sie
eine generische Fehlerbehandlung und müssen nicht bei jedem einzelnen
Befehl auf Erfolg prüfen.
:::
::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#specialagents .hidden-anchor .sr-only}3. Spezialagenten {#heading_specialagents}

:::::::::::::::::: sectionbody
::: paragraph
Einige häufig benötigte Datenquellenprogramme werden von Checkmk
mitgeliefert. Diese erzeugen Agentenausgaben nicht durch den Abruf eines
normalen Checkmk-Agenten auf irgendwelchen krummen Wegen, sondern sind
für die Abfrage von bestimmter Hardware oder Software konzipiert.
:::

::: paragraph
Weil diese Programme teilweise recht komplexe Parameter benötigen, haben
wir dafür spezielle Regelsätze in der Setup-GUI definiert, mit denen Sie
diese direkt konfigurieren können. Diese Regelsätze finden Sie gruppiert
nach Anwendungsfällen unter [Setup \> Agents \> VM, cloud,
container]{.guihint} und [Setup \> Agents \> Other
integrations:]{.guihint}
:::

::::: imageblock
::: content
![Regelsätze für die Überwachung von Anwendungen per Datenquelle und
Piggyback.](../images/ds_program_rules.png)
:::

::: title
Regelsätze unter [Setup \> Agents \> Other integrations]{.guihint}
:::
:::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wer von älteren Checkmk Versionen |
|                                   | umgestiegen ist, wird sich        |
|                                   | möglicherweise über die neue      |
|                                   | Gruppierung wundern: Seit         |
|                                   | [2.0.0]{.new} gruppiert Checkmk   |
|                                   | nicht mehr nach Zugriffstechnik,  |
|                                   | sondern nach Art des überwachten  |
|                                   | Objektes. Dies ist insbesondere   |
|                                   | deshalb sinnvoll, weil es in      |
|                                   | vielen Fällen den Anwender nicht  |
|                                   | interessiert, mit welcher Technik |
|                                   | Daten eingeholt werden und zudem  |
|                                   | oft Datenquellen und              |
|                                   | [Piggyback](piggyback.html)       |
|                                   | miteinander kombiniert werden,    |
|                                   | hier also keine klare Abgrenzung  |
|                                   | möglich ist.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Diese Programme heißen auch *Spezialagenten,* weil sie eben ein
*spezieller* Ersatz für den normalen Checkmk-Agenten sind. Nehmen Sie
als Beispiel die Überwachung von *NetApp Filers.* Diese lassen die
Installation eines Checkmk-Agenten nicht zu. Die SNMP-Schnittstelle ist
langsam, fehlerhaft und unvollständig. Aber es gibt eine spezielle
HTTP-Schnittstelle, welche Zugriff auf das NetApp-Betriebssystem *Ontap*
und alle Überwachungsdaten liefert.
:::

::: paragraph
Der Spezialagent `agent_netapp_ontap` greift über eine REST-API auf
diese Schnittstelle zu und wird über den Regelsatz [NetApp via Ontap
REST API]{.guihint} als Datenquellenprogramm eingerichtet. Im Inhalt der
Regel können Sie dann die Daten eingeben, die der Spezialagent braucht.
Fast immer sind das irgendwelche Zugangsdaten. Beim
NetApp-Spezialagenten gibt es unter anderen auch noch eine zusätzliche
Checkbox für das Erfassen von Metriken (die hier recht umfangreich
werden können):
:::

:::: imageblock
::: content
![Regel zur Konfiguration des
Netapp-Spezialagenten.](../images/ds_program_netapp.png)
:::
::::

::: paragraph
Wichtig ist, dass Sie den Host in der
[Setup-GUI](hosts_setup.html#monitoring_agents) auf der Einstellung [API
integrations if configured, else Checkmk agent]{.guihint} belassen.
:::

::: paragraph
Es gibt seltene Situationen, in denen Sie sowohl einen Spezialagenten
als auch den normalen Agenten abfragen möchten. Ein Beispiel dafür ist
die Überwachung von [VMware ESXi](monitoring_vmware.html) über das
vCenter. Letzteres ist auf einer (meist virtuellen) Windows-Maschine
installiert, auf welcher sinnvollerweise auch ein Checkmk-Agent läuft.
:::

:::: imageblock
::: content
![Auswahlmöglichkeiten beim Abfragetyp in der VMware ESXi
Konfiguration.](../images/ds_program_vcenter.png)
:::
::::

::: paragraph
Die Spezialagenten sind unter `~/share/check_mk/agents/special/`
installiert. Wenn Sie eine Modifikation an einem solchen Agenten machen
möchten, dann kopieren Sie die Datei mit dem gleichen Namen nach
`~/local/share/check_mk/agents/special/` und ändern Sie sie dort.
:::
::::::::::::::::::
:::::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/local/bin/`                | Ablage von eigenen Programmen oder   |
|                               | Skripten, die im Suchpfad sein       |
|                               | sollen und ohne Pfadangabe direkt    |
|                               | ausgeführt werden können. Ist ein    |
|                               | Programm sowohl in `~/bin/` als auch |
|                               | in `~/local/bin/`, hat letzteres     |
|                               | Vorrang.                             |
+-------------------------------+--------------------------------------+
| `~/sh                         | Hier sind die mitgelieferten         |
| are/check_mk/agents/special/` | Spezialagenten installiert.          |
+-------------------------------+--------------------------------------+
| `~/local/sh                   | Ablage der von Ihnen modifizierten   |
| are/check_mk/agents/special/` | Spezialagenten.                      |
+-------------------------------+--------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
