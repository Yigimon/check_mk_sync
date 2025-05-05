:::: {#header}
# Zeitbasierte Prozesse (Cronjobs) überwachen

::: details
[Last modified on 21-Jul-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_jobs.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Linux überwachen](agent_linux.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::: sectionbody
::: paragraph
Wenn Sie *Unix-artige* Betriebssysteme benutzen, sind Sie sehr
wahrscheinlich bereits mit den sogenannten *Cronjobs* vertraut. Dabei
ist `cron` eigentlich ein Daemon, welcher im Hintergrund wiederkehrende
Prozesse verwaltet und dafür sorgt, dass sie in vorher festgelegten
Intervallen ausgeführt werden. Grundsätzlich muss das natürlich nicht
über das Programm `cron` laufen --- es ist lediglich die gängigste
Methode, um unter Linux, aber auch unter AIX oder Solaris, immer
wiederkehrende Jobs zuverlässig zu automatisieren.
:::

::: paragraph
Manche dieser Jobs sind essentiell für den sicheren Betrieb, weswegen
diese in die Überwachung des Hosts einbezogen werden sollten. In Checkmk
können Sie das mit dem Skript `mk-job` erreichen. Das kleine Skript wird
dem eigentlichen Job vorangestellt und führt dann diese Aufgabe aus.
Dabei zeichnet `mk-job` eine Vielzahl an Messdaten auf und liefert sie
an Checkmk weiter. Zu den wichtigsten Messdaten zählen dabei, wann der
Job zuletzt und ob er erfolgreich ausgeführt wurde.
:::

::: paragraph
Das Skript `mk-job` ist --- wie in Checkmk oft üblich --- ein einfaches
Shell-Skript, welches Sie jederzeit überprüfen können. Sie haben also
auch bei den wichtigen Jobs auf Ihrem Host jederzeit die maximale
Transparenz und Kontrolle.
:::
::::::
:::::::

::::::::::::::::::::::: sect1
## []{#_das_plugin_einrichten .hidden-anchor .sr-only}2. Das Plugin einrichten {#heading__das_plugin_einrichten}

:::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_einrichten_des_mk_job_programms .hidden-anchor .sr-only}2.1. Einrichten des mk-job-Programms {#heading__einrichten_des_mk_job_programms}

::: paragraph
Richten Sie als erstes das kleine Skript auf dem überwachten Host ein,
um es nutzen zu können. Dabei ist es die einfachste Methode, das
Programm mit `wget` direkt von Ihrem Checkmk-Server zu holen und
ausführbar zu machen, im folgenden Beispiel für einen Linux-Server:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# wget -O /usr/local/bin/mk-job https://myserver/mysite/check_mk/agents/mk-job
root@linux# chmod +x /usr/local/bin/mk-job
```
:::
::::

::: paragraph
Falls Sie das Skript unter AIX oder Solaris installieren wollen, laden
Sie stattdessen `mk-job.aix` oder `mk-job.solaris`. Wenn das Programm
`wget` nicht verfügbar ist, können Sie die Datei natürlich auch auf
anderem Weg, zum Beispiel mit `scp`, kopieren.
:::
:::::::

:::::::::::::::: sect2
### []{#first_steps .hidden-anchor .sr-only}2.2. Den ersten Job überwachen {#heading_first_steps}

::: paragraph
Um den ersten Job zu überwachen nehmen wir wieder `cron` als gängiges
Beispiel. Nehmen wir an, Sie haben einen Cronjob, wie diesen hier:
:::

::::: listingblock
::: title
/etc/cron.d/backup
:::

::: content
``` {.pygments .highlight}
5 0 * * * root /usr/local/bin/backup >/dev/null
```
:::
:::::

::: paragraph
Dieser Backup Job wird unter der Benutzerkennung `root` täglich um 0:05
Uhr ausgeführt. Um diesen Job zu überwachen, stellen Sie mit einem
Editor Ihres Vertrauens dem Kommando in der Zeile das Skript `mk-job`
zusammen mit einem Namen voran. Der Name wird dann später als
Service-Name in Checkmk genutzt und muss daher auf diesem Host
einzigartig sein:
:::

::::: listingblock
::: title
/etc/cron.d/backup
:::

::: content
``` {.pygments .highlight}
# Syntax:
# <Minute> <Stunde> <Tag> <Monat> <Wochentag> <Benutzer> mk-job <Service-Name> <Kommando>
5 0 * * * root mk-job nightly-backup /usr/local/bin/backup >/dev/null
```
:::
:::::

::: paragraph
Bei Ausführung des soeben definierten Cronjobs wird `mk-job` versuchen,
die Ergebnisse aus der Messung unterhalb des Verzeichnisses
`/var/lib/check_mk_agent/job/root` abzulegen. Da das Verzeichnis `job`
ebenfalls dem Benutzer `root` gehört, ist es für `mk-job` auch kein
Problem, das Benutzerverzeichnis `root` anzulegen, sollte es nicht
vorhanden sein.
:::

::: paragraph
Bei jedem Aufruf wird der Agent in den Verzeichnissen unterhalb von
`/var/lib/check_mk_agent/job/` schauen, welche Daten dort liegen und
diese der Ausgabe hinzufügen.
:::

::: paragraph
So ein Ergebnis könnte also etwa wie das folgende aussehen, wobei der
Übersicht halber hier nur der relevante Teil der Agentenausgabe gezeigt
wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
<<<job>>>
==> nightly-backup <==
start_time 1613509201
exit_code 0
real_time 2:06.03
user_time 0.62
system_time 0.58
reads 200040
writes 35536
max_res_kbytes 28340
avg_mem_kbytes 0
invol_context_switches 1624
vol_context_switches 2086
```
:::
::::
::::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::

:::::::::: sect1
## []{#_den_service_in_checkmk_aufnehmen .hidden-anchor .sr-only}3. Den Service in Checkmk aufnehmen {#heading__den_service_in_checkmk_aufnehmen}

::::::::: sectionbody
::: paragraph
In Checkmk werden Sie den Service automatisch finden, sobald der Job
einmal ausgeführt und entsprechend die Ergebnisse gespeichert wurden.
Gehen Sie also wie üblich in die Service-Erkennung und aktivieren Sie
den Service:
:::

:::: imageblock
::: content
![discover mkjob](../images/discover_mkjob.png)
:::
::::

::: paragraph
Sie finden in dem Service zum einen alle oben gezeigten Messpunkte als
Metrik und in vordefinierten Zeitreihen-Graphen. Zum anderen bekommen
sie die Messpunkte auch in der Zusammenfassung und den Details des
Services:
:::

:::: imageblock
::: content
![service mkjob](../images/service_mkjob.png)
:::
::::
:::::::::
::::::::::

:::::::: sect1
## []{#_jobs_nicht_privilegierter_benutzer_überwachen .hidden-anchor .sr-only}4. Jobs nicht-privilegierter Benutzer überwachen {#heading__jobs_nicht_privilegierter_benutzer_überwachen}

::::::: sectionbody
::: paragraph
Möchten Sie auch Jobs von anderen Benutzern als `root` überwachen, legen
Sie zunächst ein Benutzerverzeichnis im `job`-Verzeichnis
`/var/lib/check_mk_agent/job/` an und weisen die Rechte dem
entsprechenden Benutzer zu, im folgenden Beispielkommando dem Benutzer
`myuser`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cd /var/lib/check_mk_agent/job/ && mkdir myuser && chown myuser:myuser myuser
```
:::
::::

::: paragraph
Dadurch ist es `mk-job` überhaupt erst möglich, im Namen des Benutzers
die Ergebnisse in dieses Verzeichnis abzulegen.
:::
:::::::
::::::::

:::::::::::::::::::::: sect1
## []{#_diagnosemöglichkeiten .hidden-anchor .sr-only}5. Diagnosemöglichkeiten {#heading__diagnosemöglichkeiten}

::::::::::::::::::::: sectionbody
::: paragraph
Wenn die Einrichtung nicht funktioniert, haben Sie verschiedene
Möglichkeiten, um dem Problem oder den Problemen auf die Spur zu kommen.
Fangen Sie grundsätzlich immer beim Startpunkt der Kette an und prüfen
Sie als erstes, ob sie das Skript `mk-job` korrekt eingebunden haben,
wie in den [ersten Schritten](#first_steps) beschrieben.
:::

::: paragraph
Mögliche Fehlerquellen sind:
:::

::: ulist
- `mk-job` kann von `cron` nicht gefunden werden, weil es in einem Pfad
  liegt, der von `cron` nicht berücksichtigt wird. Geben Sie in diesem
  Fall den vollen Pfad zu `mk-job` an.

- Der Service-Name enthält Leerzeichen und wurde nicht in
  Anführungszeichen (\") umschlossen.

- Der Job wird mit einem Benutzer ausgeführt, welcher noch kein eigenes
  Verzeichnis für die Speicherung der Ergebnisse hat.
:::

::: paragraph
Sollten die Messergebnisse korrekt erfasst und abgespeichert werden,
prüfen Sie als nächstes auf dem Checkmk-Server, ob die Ergebnisse auch
vom Agenten korrekt weitergegeben werden.
:::

::: paragraph
Sie können sich die Agentenausgabe mit dem folgenden
[Kommando](cmk_commandline.html#dump_agent) anzeigen und die Ausgabe in
das Kommando `less` weiterleiten:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d myhost | less
```
:::
::::

::: paragraph
Üblicherweise befindet sich die relevante Sektion `<<<job>>>` in der
Ausgabe sehr weit unten.
:::

::: paragraph
Sind die Ergebnisse hier nicht zu sehen, kann das daran liegen, dass der
Agent nicht über die nötigen Berechtigungen verfügt, um die
entsprechenden Dateien zu lesen. Das kann zum Beispiel auftreten, wenn
Sie den Agenten nicht mit dem Benutzer `root` aufrufen, die Ergebnisse
aber nicht von anderen Benutzern gelesen werden dürfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# ls -l /var/lib/check_mk_agent/job/myUser/
total 5
-rw-rw---- 1 myUser   myUser   186 Jul 21 11:58  nightly-backup
```
:::
::::

::: paragraph
Fügen Sie in solchen Fällen entweder die Berechtigung hinzu, dass alle
Benutzer die Ergebnisse lesen dürfen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chmod 664 /var/lib/check_mk_agent/job/myUser/nightly-backup
```
:::
::::

::: paragraph
Oder Sie erstellen eine Gruppe und ordnen diese Gruppe allen Job-Dateien
zu. Mit dem folgenden Kommando ändern Sie nur die Gruppenberechtigung.
Der Besitzer wird nicht geändert, da dieser unangetastet bleibt, wenn
vor dem Doppelpunkt nichts eingetragen wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chown :myJobGroup /var/lib/check_mk_agent/job/myUser/nightly-backup
```
:::
::::

::: paragraph
Achten Sie darauf, dass Sie die Gruppe vorher angelegt und den Benutzer,
mit dem der Agent aufgerufen wird, auch als Mitglied hinzugefügt haben.
:::
:::::::::::::::::::::
::::::::::::::::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}6. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+------------------------+---------------------------------------------+
| Pfad                   | Bedeutung                                   |
+========================+=============================================+
| `/usr/local/bin/`      | Das Skript `mk-job` sollte in diesem        |
|                        | Verzeichnis abgelegt werden, damit es       |
|                        | unkompliziert aufgerufen werden kann.       |
+------------------------+---------------------------------------------+
| `/var/li               | Das übliche Verzeichnis unter dem die       |
| b/check_mk_agent/job/` | Ergebnisse geordnet nach Benutzern          |
|                        | gespeichert werden. Beachten Sie, dass der  |
|                        | Pfad unter **AIX** anders ist:              |
|                        | `/tmp/check_mk/job/`                        |
+------------------------+---------------------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
