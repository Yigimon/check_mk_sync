:::: {#header}
# Backups

::: details
[Last modified on 03-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/backup.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_grundlagen .hidden-anchor .sr-only}1. Grundlagen {#heading__grundlagen}

:::::: sectionbody
::: paragraph
Im Laufe der Zeit werden Sie einiges an Arbeit in die Konfiguration
Ihrer Hosts und Services, Grenzwerte, Benachrichtigungen und so weiter
stecken --- daher sollten Sie Backups erstellen. Das ist nicht nur
nützlich für den Fall, dass etwas schiefgeht, sondern auch zum Testen
oder Nutzen unterschiedlicher Konfigurationen. Sie können die komplette
Konfiguration sichern und bei Bedarf auch wieder zurückspielen
(*restore*). Backups lassen sich zeitgesteuert ausführen, verschlüsseln
und komprimieren.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Checkmk bietet alternativ die     |
|                                   | Möglichkeit die grundlegenden     |
|                                   | Backup und Restore-Funktionen per |
|                                   | Kommandozeile mit `omd backup`    |
|                                   | und `omd restore` auszuführen.    |
|                                   | Dies wird im Artikel zur          |
|                                   | [Verwaltung von Instanzen mit     |
|                                   | omd](om                           |
|                                   | d_basics.html#omd_backup_restore) |
|                                   | erklärt.                          |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Den Einstieg in die Erstellung der Backups in der Checkmk-GUI finden Sie
in [Setup \> Maintenance \> Backups.]{.guihint}
:::
::::::
:::::::

::::::: sect1
## []{#_voraussetzungen .hidden-anchor .sr-only}2. Voraussetzungen {#heading__voraussetzungen}

:::::: sectionbody
::: paragraph
Um Backups auf dem Quellsystem zu erstellen und später auch wieder auf
das Zielsystem zurückspielen zu können, gibt es zwei wesentliche
Voraussetzungen:
:::

::: ulist
- Auf beiden Systemen muss die exakt gleiche
  [Checkmk-Version](cmk_versions.html) installiert sein, also z.B.
  [`2.3.0`]{.new}`p1`.

- Auf beiden Systemen muss die gleiche Checkmk-Edition installiert sein,
  z.B.
  [![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
  **Checkmk Raw**.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Systemplattform ist nicht     |
|                                   | relevant, so dass Sie zum         |
|                                   | Beispiel ein Backup mit Ubuntu    |
|                                   | als Quellsystem erstellen und mit |
|                                   | Red Hat oder einer Appliance als  |
|                                   | Zielsystem zurückspielen können.  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::
:::::::

:::::::::::::::::: sect1
## []{#backup_config .hidden-anchor .sr-only}3. Verschlüsselte Backups konfigurieren {#heading_backup_config}

::::::::::::::::: sectionbody
::: paragraph
Im ersten Schritt wechseln Sie auf der Seite [Site backup]{.guihint} mit
dem Aktionsknopf [![icon backup
targets](../images/icons/icon_backup_targets.png)]{.image-inline}
[Backup targets]{.guihint} zur Liste der Backup-Ziele und legen mit [Add
target]{.guihint} ein neues Ziel an:
:::

:::: imageblock
::: content
![Dialog zur Festlegung eines
Backup-Ziels.](../images/backup_target_config.png)
:::
::::

::: paragraph
Die absolute Pfadangabe unter [Destination]{.guihint} bezieht sich auf
das System, nicht auf die Instanz.
:::

::: paragraph
Nachdem Sie das Backup-Ziel gesichert haben, wechseln Sie zurück zur
Seite [Site backup]{.guihint}. Öffnen Sie mit [Backup encryption
keys]{.guihint} die Liste der Backup-Schlüssel und erstellen Sie mit
[Add key]{.guihint} einen neuen Schlüssel für Ihre Backups mit einem
aussagekräftigen Namen und einem sicheren Passwort (*Passphrase*):
:::

:::: imageblock
::: content
![Dialog zur Festlegung eines
Backup-Schlüssels.](../images/backup_key_config.png)
:::
::::

::: paragraph
Nach dem Erstellen des Schlüssels werden Sie eine Meldung sehen, die Sie
darauf hinweist, dass Sie die Schlüssel noch nicht heruntergeladen
haben:
:::

:::: imageblock
::: content
![Meldung, dass die Backup-Schlüssel noch nicht heruntergeladen
wurden.](../images/backup_key_warning.png)
:::
::::

::: paragraph
Den Schlüssel im PEM-Format können Sie über den Knopf [Download this
key]{.guihint} herunterladen. Übrigens müssen Sie auch beim
Herunterladen die Passphrase des Schlüssels eingeben. Da Sie die
Schlüssel für die Wiederherstellung von Backups zwingend benötigen,
verbleibt die Meldung bis Sie alle Schlüssel gesichert haben.
:::

:::: imageblock
::: content
![Liste der Backup-Schlüssel.](../images/backup_keys_for_backups.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Falls ein Backup-Schlüssel einmal |
|                                   | nicht mehr vorhanden sein sollte, |
|                                   | können Sie den gesicherten        |
|                                   | Schlüssel wieder hochladen. Auch  |
|                                   | vor dem Hochladen müssen Sie die  |
|                                   | Passphrase eingeben.              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::::
::::::::::::::::::

:::::::: sect1
## []{#backup_job_create .hidden-anchor .sr-only}4. Backup-Auftrag erstellen {#heading_backup_job_create}

::::::: sectionbody
::: paragraph
Nun können Sie einen neuen Backup-Auftrag (*backup job*)
erstellen --- erneut auf der Seite [Site backup]{.guihint}, diesmal mit
dem Knopf [Add job]{.guihint}:
:::

:::: imageblock
::: content
![Dialog zur Festlegung eines
Backup-Auftrags.](../images/backup_job_config.png)
:::
::::

::: paragraph
Hier können Sie unter anderem die eben erstellten Elemente unter
[Target]{.guihint} und [Encryption]{.guihint} wählen. Zudem finden Sie
hier Optionen für die Komprimierung und die Planung der Ausführung. Wie
Sie gleich sehen werden, können Sie Backups aber auch manuell anstoßen.
Über [Do not backup historical data]{.guihint} lassen sich Metriken
(RRD-Dateien), Monitoring-Verlauf und Logdateien einsparen, was zu
deutlich kleineren Backup-Archiven führt.
:::
:::::::
::::::::

:::::::::::::: sect1
## []{#backup_create .hidden-anchor .sr-only}5. Backup erstellen {#heading_backup_create}

::::::::::::: sectionbody
::: paragraph
Auf der Seite [Site backup]{.guihint} sehen Sie nun Ihren fertigen
Backup-Auftrag und können ihn über [![Symbol zum Starten des
Backups.](../images/icons/icon_backup_start.png)]{.image-inline}
starten:
:::

:::: imageblock
::: content
![Listeneintrag eines noch nicht gestarteten
Backup-Auftrags.](../images/backup_job_play.png)
:::
::::

::: paragraph
Laufende Backups können Sie über [![Symbol zum Stoppen des
Backups.](../images/icons/icon_backup_stop.png)]{.image-inline} stoppen:
:::

:::: imageblock
::: content
![Listeneintrag eines laufenden
Backup-Auftrags.](../images/backup_job_running.png)
:::
::::

::: paragraph
Zu guter Letzt sehen Sie die Bestätigung des fertiggestellten Backups:
:::

:::: imageblock
::: content
![Listeneintrag eines abgeschlossenen
Backup-Auftrags.](../images/backup_job_finished.png)
:::
::::

::: paragraph
Sowohl bei laufenden als auch bei abgeschlossenen Aufträgen gelangen Sie
über [![Symbol zur Anzeige der Details des
Backup-Auftrags.](../images/icons/icon_backup_state.png)]{.image-inline}
zu den Details des Auftrags.
:::
:::::::::::::
::::::::::::::

::::::::::::: sect1
## []{#backup_restore .hidden-anchor .sr-only}6. Restore {#heading_backup_restore}

:::::::::::: sectionbody
::: paragraph
Die Wiederherstellung von Backups starten Sie auf der Seite [Site
backup]{.guihint} durch Klick auf [Restore]{.guihint}. Das Vorgehen ist
weitestgehend selbsterklärend:
:::

::: {.olist .arabic}
1.  Wählen Sie mit [![Symbol zur Wiederherstellung des
    Backups.](../images/icons/icon_backup_restore.png)]{.image-inline}
    das Backup-Ziel.

2.  Wählen Sie mit [![Symbol zur Wiederherstellung des
    Backups.](../images/icons/icon_backup_restore.png)]{.image-inline}
    das gewünschte Backup für die Wiederherstellung.

3.  Geben Sie die Passphrase für den Backup-Schlüssel ein.

4.  Starten Sie die Wiederherstellung.
:::

::: paragraph
Nach der Wiederherstellung wird die Instanz neu gestartet, daher sehen
Sie kurzzeitig eine HTTP 503 Fehlermeldung:
:::

:::: imageblock
::: content
![HTTP 503 Fehlermeldung.](../images/backup_restore_warning.png)
:::
::::

::: paragraph
Sobald die Instanz wieder verfügbar ist, erhalten Sie die Details über
das Ergebnis:
:::

:::: imageblock
::: content
![Dialog mit den Details der
Wiederherstellung.](../images/backup_restore_finished.png)
:::
::::

::: paragraph
Bestätigen Sie abschließend die Wiederherstellung durch Klick auf
[Complete the restore]{.guihint}.
:::
::::::::::::
:::::::::::::

:::::::::: sect1
## []{#distributed .hidden-anchor .sr-only}7. Backup im verteilten Monitoring {#heading_distributed}

::::::::: sectionbody
::: paragraph
Die Backup-Funktion der Checkmk-GUI sichert nur die Daten der lokalen
Instanz. Ist zum Beispiel die lokale Instanz die Zentralinstanz in einem
[verteilten Monitoring](glossar.html#distributed_monitoring#) mit
[verteiltem Setup,](glossar.html#distributed_setup#) so umfasst das
Backup die Konfigurationsdaten dieser Zentralinstanz und aller
Remote-Instanzen, die von der Zentralinstanz aus konfiguriert werden.
Wenn Sie allerdings ein vollständiges Backup inklusive der Statusdaten
Ihrer Remote-Instanzen haben wollen, müssen Sie auch ein Backup auf
diesen Remote-Instanzen konfigurieren.
:::

::: paragraph
Dies ist etwas aufwändiger, denn auf jeder Remote-Instanz müssen Sie
zuerst die Konfiguration via [Setup]{.guihint} erlauben, sich dann dort
anmelden und das Backup konfigurieren. Abschließend können Sie die
geänderte Konfiguration der Remote-Instanzen wieder zurücksetzen.
:::

::: paragraph
Dies funktioniert in allen Checkmk-[Editionen.](glossar.html#edition)
:::

::: paragraph
Im Einzelnen gehen Sie dabei für eine Remote-Instanz wie folgt vor:
:::

::: {.olist .arabic}
1.  Öffnen Sie auf der Zentralinstanz in [Setup \> General \>
    Distributed monitoring]{.guihint} die [Eigenschaften der
    Remote-Instanz.](distributed_monitoring.html#connect_remote_sites)

2.  Im Kasten [Configuration connection]{.guihint} aktivieren Sie die
    Option [Users are allowed to directly login into the Web GUI of this
    site]{.guihint} und **deaktivieren** Sie die Option [Disable
    configuration via Setup on this site,]{.guihint} denn standardmäßig
    ist die Konfiguration via [Setup]{.guihint} an einer Remote-Instanz
    nicht möglich.

3.  [Aktivieren Sie die Änderungen.](wato.html#activate_changes)

4.  Melden Sie sich auf der Remote-Instanz an, und richten Sie das
    Backup so ein, wie es in diesem Artikel beschrieben ist.

5.  Abschließend setzen Sie auf der Zentralinstanz die geänderten
    Optionen in den Eigenschaften der Remote-Instanz wieder auf die
    vorherigen Werte zurück. Aktivieren Sie auch diese Änderungen.
:::

::: paragraph
Um die [Wiederherstellung (Restore)](#backup_restore) eines Backups auf
einer Remote-Instanz durchzuführen, gehen Sie analog vor, indem Sie
zuerst wieder die interaktive Anmeldung und die Konfiguration via
[Setup]{.guihint} erlauben und abschließend die Optionen wieder
zurücksetzen.
:::
:::::::::
::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
