:::: {#header}
# Backup in der Appliance

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_backup.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Appliance einrichten und nutzen](appliance_usage.html) [Besonderheiten
der Hardware-Appliance](appliance_rack_config.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#_grundlagen .hidden-anchor .sr-only}1. Grundlagen {#heading__grundlagen}

::::::: sectionbody
::: paragraph
Damit Ihre Monitoring-Daten im Falle eines Hardware-Defekts oder einer
andersartigen Zerstörung gesichert sind, können Sie über die
Weboberfläche die Sicherung Ihrer Daten (*backup*) konfigurieren.
:::

::: paragraph
Um die Daten wirklich zu sichern, müssen sie auf einem anderen Gerät,
z.B. einem File Server, abgelegt werden. Hierzu konfigurieren Sie
zunächst über die
[Dateisystemverwaltung](appliance_usage.html#cma_mounts) die für das
Backup zu nutzende Netzwerkfreigabe. Diese richten Sie anschließend in
der Konfiguration der Backups als Backup-Ziel ein. Sobald Sie dies
gemacht haben, können Sie einen Backup-Auftrag (*backup job*) anlegen,
der dann im festgelegten Intervall eine Datensicherung Ihres Geräts auf
der Netzwerkfreigabe ablegt.
:::

::: paragraph
Das volle Backup beinhaltet alle von Ihnen auf dem Gerät getätigten
Konfigurationen, installierte Dateien sowie Ihre Monitoring-Instanzen.
:::

::: paragraph
Das Backup wird während des Betriebs (online) durchgeführt.
:::
:::::::
::::::::

:::::: sect1
## []{#_automatisches_backup .hidden-anchor .sr-only}2. Automatisches Backup {#heading__automatisches_backup}

::::: sectionbody
::: paragraph
Um ein automatisches Backup einzurichten, konfigurieren Sie einen oder
mehrere Backup-Aufträge. Pro Backup-Auftrag wird auf dem Backup-Ziel
eine Datensicherung abgelegt. Beim Abschluss der Folgesicherung wird die
vorherige Sicherung gelöscht. Das bedeutet, dass Sie auf dem Zielsystem
temporär mit dem doppelten Speicherbedarf rechnen müssen.
:::

::: paragraph
Ein Backup-Auftrag kümmert sich nicht um die Verwaltung mehrerer
Generationen. Wenn Sie also von einem Backup-Auftrag mehrere Kopien über
längere Zeiträume aufheben wollen, müssen Sie diese selbst anlegen.
:::
:::::
::::::

:::::::::::::::::::: sect1
## []{#_konfiguration_der_backups .hidden-anchor .sr-only}3. Konfiguration der Backups {#heading__konfiguration_der_backups}

::::::::::::::::::: sectionbody
::: paragraph
Konfigurieren Sie mit Hilfe der
[Dateisystemverwaltung](appliance_usage.html#cma_mounts) zunächst Ihre
Netzwerkfreigaben. Hier im Beispiel ist eine Netzwerkfreigabe unter dem
Pfad `/mnt/auto/backup` konfiguriert.
:::

::: paragraph
Wählen Sie nun aus dem Hauptmenü der Weboberfläche den Eintrag [Device
backup]{.guihint} und öffnen Sie von dort aus die Backup-Ziele über
[Backup targets.]{.guihint} Erzeugen Sie über [New backup
target]{.guihint} ein neues Ziel. Die ID und den Titel können Sie frei
wählen. Unter dem Punkt [Directory to save the backup to]{.guihint}
konfigurieren Sie den Pfad der eingehängten Netzwerkfreigabe, hier
`/mnt/auto/backup`. Die Option [Is mountpoint]{.guihint} sollte aktiv
sein, wenn Sie auf eine Netzwerkfreigabe sichern. Damit prüft das Backup
vor der Speicherung, ob die Netzwerkfreigabe auch wirklich eingehängt
ist.
:::

:::: imageblock
::: content
![Einstellung des
Backup-Ziels.](../images/cma_de_backup_target_new_2.png)
:::
::::

::: paragraph
Nachdem Sie das Backup-Ziel angelegt haben, gehen Sie zurück auf die
Seite [Device backup]{.guihint} und wählen dort [New job]{.guihint} aus.
Hier können Sie wieder eine ID und einen Titel angeben. Wählen Sie dann
das soeben angelegte Backup-Ziel aus und legen Sie das gewünschte
Ausführungsintervall fest.
:::

:::: imageblock
::: content
![Einstellungen zum Backup-Job.](../images/cma_de_backup_job_new_2.png)
:::
::::

::: paragraph
Nach dem Speichern sehen Sie auf der Seite [Device backup]{.guihint}
einen Eintrag für Ihren neuen Backup-Auftrag. Hier wird Ihnen am Ende
der Zeile der Zeitpunkt der nächsten Ausführung angezeigt. Sobald der
Auftrag läuft, bzw. abgeschlossen ist, wird Ihnen in dieser Ansicht der
Status angezeigt. Hier können Sie den Auftrag auch manuell starten bzw.
laufende Backups abbrechen.
:::

:::: imageblock
::: content
![Anzeige der nächsten
Backup-Ausführung.](../images/cma_de_backup_job_list_2.png)
:::
::::

::: paragraph
Starten Sie testweise Ihren soeben eingerichteten Auftrag durch einen
Klick auf das Wiedergabe-Symbol. Sie sehen nun in der Tabelle, dass der
Auftrag aktuell ausgeführt wird. Mit einem Klick auf das Log-Symbol
können Sie sich den Fortschritt des Auftrags in Form der Log-Ausgaben
anzeigen lassen.
:::

:::: imageblock
::: content
![.](../images/cma_de_backup_job_log_2.png)
:::
::::

::: paragraph
Sobald das Backup abgeschlossen ist, wird dies ebenfalls in der Tabelle
angezeigt.
:::

:::: imageblock
::: content
![cma de backup list complete
2](../images/cma_de_backup_list_complete_2.png)
:::
::::
:::::::::::::::::::
::::::::::::::::::::

:::::::::: sect1
## []{#_format_der_backups .hidden-anchor .sr-only}4. Format der Backups {#heading__format_der_backups}

::::::::: sectionbody
::: paragraph
Jeder Backup-Auftrag erzeugt auf dem Backup-Ziel ein Verzeichnis. Dieses
Verzeichnis wird nach folgendem Schema benannt:
:::

::: ulist
- `Checkmk_Appliance-[HOSTNAME]-[LOCAL_JOB_ID]-[STATE]`
:::

::: paragraph
Während des Backups wird in das Verzeichnis mit dem Suffix `-incomplete`
gesichert. Bei Abschluss des Backups wird dieses Verzeichnis umbenannt
und das Suffix zu `-complete` geändert.
:::

::: paragraph
In dem Verzeichnis liegt eine Datei `mkbackup.info`, die Metadaten zu
der Sicherung enthält. Neben dieser Datei werden mehrere Archive in dem
Verzeichnis abgelegt.
:::

::: paragraph
Das Archiv mit dem Namen `system` enthält die Gerätekonfiguration,
`system-data` enthält die Daten des Datendateisystems exklusive der
Monitoring-Instanzen. Die Monitoring-Instanzen sind in separaten
Archiven nach dem Namensschema `site-[SITENAME]` gespeichert.
:::

::: paragraph
Je nach Modus der Sicherung werden diese Dateien mit den Dateiendungen
`.tar` für unkomprimierte und unverschlüsselte, `.tar.gz` für
komprimierte aber unverschlüsselte und `.tar.gz.enc` für komprimierte
und verschlüsselte Archive gespeichert.
:::
:::::::::
::::::::::

:::::::::::::: sect1
## []{#encryption .hidden-anchor .sr-only}5. Verschlüsselung {#heading_encryption}

::::::::::::: sectionbody
::: paragraph
Wenn Sie Ihr Backup verschlüsseln wollen, können Sie dies direkt aus der
Weboberfläche heraus konfigurieren. Ihre gesicherten Dateien werden
hierbei vor der Übertragung auf das Backup-Ziel komplett verschlüsselt.
Die Verschlüsselung geschieht mit einem zuvor angelegten
Backup-Schlüssel. Dieser Schlüssel ist durch ein Passwort geschützt, das
Sie beim Anlegen des Schlüssels festlegen und zusammen mit dem Schlüssel
gut verwahren müssen, da nur damit die Wiederherstellung des Backups
möglich ist.
:::

::: paragraph
Öffnen Sie hierzu die Seite [Device backup]{.guihint} und wählen Sie
dort die Seite [Backup keys.]{.guihint} Erzeugen Sie von hier aus einen
neuen Backup-Schlüssel. Bei der Angabe des Passworts sollten Sie auf
genügend Komplexität achten.
:::

:::: imageblock
::: content
![cma de backup key new 2](../images/cma_de_backup_key_new_2.png)
:::
::::

::: paragraph
Nachdem Sie den Schlüssel erzeugt haben, laden Sie ihn herunter und
verwahren Sie ihn an einem sicheren Ort.
:::

::: paragraph
Ein verschlüsseltes Backup kann nur mit dem Backup-Schlüssel und dem
dazugehörigen Passwort wiederhergestellt werden.
:::

::: paragraph
Editieren Sie nun von der Seite [Device backup]{.guihint} aus den
Backup-Auftrag, der verschlüsselte Backups erzeugen soll, aktivieren Sie
dort den Punkt [Encryption]{.guihint} und wählen Sie den soeben
angelegten Backup-Schlüssel aus.
:::

:::: imageblock
::: content
![cma de backup job edit encrypt
2](../images/cma_de_backup_job_edit_encrypt_2.png)
:::
::::

::: paragraph
Nachdem Sie den Dialog bestätigt haben, wird das nächste Backup
automatisch verschlüsselt.
:::
:::::::::::::
::::::::::::::

:::::: sect1
## []{#_komprimierung .hidden-anchor .sr-only}6. Komprimierung {#heading__komprimierung}

::::: sectionbody
::: paragraph
Es ist möglich, die gesicherten Daten während des Kopiervorgangs zu
komprimieren. Dies kann nützlich sein, wenn Sie Bandbreite sparen müssen
oder auf dem Zielsystem nur begrenzt Platz haben.
:::

::: paragraph
Bitte beachten Sie jedoch, dass die Komprimierung deutlich mehr CPU-Zeit
erfordert und daher den Vorgang des Backups verlängert. In der Regel ist
es empfehlenswert, die Komprimierung nicht zu aktivieren.
:::
:::::
::::::

::::::::::::::::::::::::::: sect1
## []{#_wiederherstellung .hidden-anchor .sr-only}7. Wiederherstellung {#heading__wiederherstellung}

:::::::::::::::::::::::::: sectionbody
::: paragraph
Ein Backup können Sie über die in der Weboberfläche eingebauten
Mechanismen nur komplett wiederherstellen. Die Wiederherstellung
einzelner Dateien über die Weboberfläche ist nicht vorgesehen. Dies ist
jedoch über die Kommandozeile durch manuelles Auspacken aus dem Backup
möglich.
:::

::: paragraph
Wenn Sie ein komplettes Backup auf einem laufenden Gerät
wiederherstellen wollen, wählen Sie auf der Seite [Device
backup]{.guihint} den Punkt [Restore.]{.guihint} Auf der Folgeseite
wählen Sie das Backup-Ziel, von dem Sie das Backup wiederherstellen
wollen.
:::

:::: imageblock
::: content
![cma de backup restore list
2](../images/cma_de_backup_restore_list_2.png)
:::
::::

::: paragraph
Nach der Auswahl des Backup-Ziels bekommen Sie alle dort vorhandenen
Backups aufgelistet.
:::

:::: imageblock
::: content
![cma de backup restore
backuplist](../images/cma_de_backup_restore_backuplist.png)
:::
::::

::: paragraph
Klicken Sie nun beim Backup, das Sie wiederherstellen wollen, auf das
Pfeil-Symbol, um die Wiederherstellung zu starten. Nach einem
Bestätigungsdialog startet die Wiederherstellung und Sie landen wieder
auf der [Restore]{.guihint}-Startseite. Durch Aktualisierung der Seite
können Sie den aktuellen Status nachvollziehen.
:::

::: paragraph
Im Anschluss an die Wiederherstellung startet Ihr Gerät automatisch neu.
Nach dem Neustart ist die Wiederherstellung abgeschlossen.
:::

:::::::: sect2
### []{#decrypt_backup .hidden-anchor .sr-only}7.1. Entschlüsseln eines Backups {#heading_decrypt_backup}

::: paragraph
In Ausnahmesituationen kann es notwendig sein ein verschlüsseltes Backup
nur zu entschlüsseln und eben nicht vollständig wiederherzustellen.
Womöglich möchten Sie einem Backup nur einzelne Dateien entnehmen oder
das Backup untersuchen. Ab Version 1.7.3 der Appliance gibt es dafür
einen weiteren Knopf im Menü für die Wiederherstellung ([Device backup
\> Restore]{.guihint}).
:::

:::: imageblock
::: content
![cma de backup decrypt
backup](../images/cma_de_backup_decrypt_backup.png)
:::
::::

::: paragraph
Sobald Sie diesen Knopf anklicken, bekommen Sie eine Übersicht aller
verschlüsselten Backups zu sehen, die in diesem Backup-Ziel liegen.
Klicken Sie nun das Schlosssymbol in der Zeile des gewünschten Backups
an, geben Sie danach die Passphrase des verwendeten Backup-Schlüssels
ein und klicken Sie auf [Start decryption]{.guihint}.
:::

::: paragraph
Nachdem der Vorgang abgeschlossen ist, finden Sie das entschlüsselte
Backup in der Liste aller Backups des jeweiligen Backup-Ziels. ([Device
backup \> Restore]{.guihint}) Es trägt den gleichen Namen wie das
Ausgangsbackup, ergänzt um das Suffix `_decrypted`.
:::
::::::::

:::::::::: sect2
### []{#_disaster_recovery .hidden-anchor .sr-only}7.2. Disaster Recovery {#heading__disaster_recovery}

::: paragraph
Wenn Sie ein Gerät komplett neu wiederherstellen müssen, läuft das
Disaster Recovery in folgenden Schritten ab:
:::

::: ulist
- Starten Sie mit einem Gerät im Werkszustand (neues, baugleiches oder
  auf Werkszustand zurückgesetztes Gerät).

- Stellen Sie sicher, dass die Firmware-Version mit der Version der
  Sicherung übereinstimmt.
:::

::: paragraph
Konfigurieren Sie an der Konsole mindestens folgende Einstellungen:
:::

::: ulist
- Netzwerkeinstellungen

- Zugriff auf die Weboberfläche
:::

::: paragraph
In der Weboberfläche gehen Sie wie folgt vor:
:::

::: ulist
- Wählen Sie das Backup-Ziel, von dem Sie wiederherstellen wollen.

- Laden Sie ggf. den Backup-Schlüssel für das wiederherzustellende
  Backup hoch.
:::

::: paragraph
Zum Abschluss starten Sie dann die Wiederherstellung wie im vorherigen
Kapitel beschrieben.
:::
::::::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

::::: sect1
## []{#_monitoring .hidden-anchor .sr-only}8. Monitoring {#heading__monitoring}

:::: sectionbody
::: paragraph
Für jeden konfigurierten Backup-Auftrag findet das [Service
Discovery]{.guihint} von Checkmk auf dem Gerät automatisch einen neuen
Service `Backup [JOB-ID]`. Dieser Service informiert Sie über eventuelle
Probleme bei der Sicherung und zeichnet hilfreiche Messwerte wie Größe
und Dauer auf.
:::
::::
:::::

::::::: sect1
## []{#_besonderheiten_im_cluster .hidden-anchor .sr-only}9. Besonderheiten im Cluster {#heading__besonderheiten_im_cluster}

:::::: sectionbody
::: paragraph
Die gesamte Konfiguration des Backups inklusive der Backup-Schlüssel
wird zwischen den Cluster-Knoten synchronisiert. Die Cluster-Knoten
führen Ihr Backup voneinander getrennt aus, erstellen also im
Backup-Ziel auch separate Verzeichnisse für die Sicherung.
:::

::: paragraph
Der aktive Cluster-Knoten sichert das komplette Gerät inklusive der
Daten des Dateisystems und der Monitoring-Instanzen. Der inaktive
Cluster-Knoten sichert nur seine lokale Gerätekonfiguration und benötigt
entsprechend nur wenige Megabytes Speicherplatz.
:::

::: paragraph
Demnach können Sie auch nur mit dem Backup des aktiven Cluster-Knotens
die Monitoring-Instanzen wiederherstellen.
:::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
