:::: {#header}
# Lizenzen verwalten

::: details
[Last modified on 02-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/license.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Nutzen Sie eine
der kommerziellen Editionen, d.h.
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise**,
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** oder
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** (oberhalb der Grenzen des Lizenzstatus „Free": 750
Services, eine Instanz), so sind Sie verpflichtet, regelmäßig eine
Übersicht über den Einsatz von Checkmk in Ihrem Unternehmen an die
Checkmk GmbH zu liefern.
:::

::: paragraph
Nach der Ersteinrichtung - und im Falle von Checkmk Cloud der
Lizenzeinspielung zum Ende der Testphase (Lizenzstatus „Trial") - kann
Checkmk Ihnen den Rest dieser Verwaltungsarbeit komplett abnehmen.
:::

::: paragraph
Checkmk sammelt jeden Tag zu einem zufälligen Zeitpunkt die aktuellen
Service-Zahlen für alle verbundenen Checkmk-Instanzen. Diese werden in
der Lizenznutzung übersichtlich und transparent dargestellt.
:::

::: paragraph
Checkmk speichert diese Informationen über einen Zeitraum von 400 Tagen.
Ältere Daten werden entfernt.
:::

::: paragraph
Als Administrator von Checkmk überlassen Sie die Kommunikation mit dem
Checkmk-Kundenportal komplett Checkmk, sowohl für die Lizenzierung als
auch für die Übermittlung der Nutzungsinformationen. Sollte Ihnen dies
technisch nicht möglich sein, so können Sie die Kommunikation alternativ
manuell ausführen.
:::
::::::::
:::::::::

:::::::::::::: sect1
## []{#generate_application_password .hidden-anchor .sr-only}2. Subskriptionsdaten aus dem Kundenportal auslesen {#heading_generate_application_password}

::::::::::::: sectionbody
::: paragraph
Rufen Sie das
[Checkmk-Kundenportal](https://portal.checkmk.com/de/){target="_blank"}
auf. Melden Sie sich dort mit Ihren Zugangsdaten an, um die [Licensing
Credentials]{.guihint} zu erstellen, die Sie im nächsten Schritt in
Checkmk eintragen müssen.
:::

::: paragraph
**Hinweis:** Mit dem Kauf einer Checkmk-Edition haben Sie die
Zugangsdaten für das Checkmk-Kundenportal erhalten. Sollten Sie diese
nicht (mehr) haben, so kontaktieren Sie bitte den
[Checkmk-Vertrieb](https://checkmk.com/de/kontakt){target="_blank"}.
:::

::: paragraph
Wählen Sie Ihre Lizenz aus. Die Ansicht sieht dann beispielsweise so
aus:
:::

:::: imageblock
::: content
![Die License Subscription im
Kundenportal.](../images/license_subscription.png)
:::
::::

::: paragraph
**Hinweis:** Sollten Sie die markierten Knöpfe nicht sehen, so hat Ihr
Benutzerkonto möglicherweise keine passenden Rechte im
Checkmk-Kundenportal. Wenden Sie sich in so einem Fall an den in Ihrem
Unternehmen für die Lizenzverlängerung zuständigen Administrator.
:::

::: paragraph
Klicken Sie nun auf [Generate Licensing Credentials]{.guihint}, um das
Passwort für die Übermittlung zu erstellen.
:::

:::: imageblock
::: content
![Passwort im Kundenportal
erstellen.](../images/license_generate_password.png){width="75%"}
:::
::::

::: paragraph
Kopieren Sie die [Licensing ID]{.guihint} und das [Password]{.guihint}
und schließen Sie dieses Fenster mit [Confirm]{.guihint}.
:::
:::::::::::::
::::::::::::::

::::::::::::::::::::::::::::::: sect1
## []{#license_cce .hidden-anchor .sr-only}3. Lizenzierung von Checkmk Cloud und Checkmk MSP {#heading_license_cce}

:::::::::::::::::::::::::::::: sectionbody
::: paragraph
Nach Ablauf der Testphase müssen Sie, zu Beginn der ersten Lizenzphase,
eine Verifizierungsanfrage an das
[Checkmk-Kundenportal](https://portal.checkmk.com/de/){target="_blank"}
übertragen und sich einen passenden Lizenzschlüssel geben lassen. Den
Lizenzschlüssel hinterlegen Sie in Checkmk. Zugleich laden Sie die
Verifizierungsantwort in Checkmk hoch. Durch diese beiden Schritte
lizenzieren Sie Ihre Checkmk Cloud bzw. Checkmk MSP und schalten diese
zur weiteren Nutzung frei.
:::

::: paragraph
Dies gilt bei Checkmk Cloud natürlich nur, wenn Sie die Grenzwerte des
Lizenzstatus „Free" überschritten haben. Anderenfalls können Sie diese
im Lizenzstatus „Free" ungehindert weiter nutzen ohne eine Lizenzierung
durchführen zu müssen.
:::

::::::::::: sect2
### []{#setup_cce .hidden-anchor .sr-only}3.1. Subskriptionsdaten in Checkmk eingeben {#heading_setup_cce}

::: paragraph
Öffnen Sie als [Checkmk-Administrator](wato_user.html#roles) [Setup \>
Maintenance \> Licensing.]{.guihint} Die Seite ist noch leer, solange
keine Subskriptionsdaten hinterlegt wurden.
:::

:::: imageblock
::: content
![Der Knopf \'Edit settings\' zum Öffnen der Seite mit den
Subskriptionseinstellungen.](../images/license_licensing_ce_ausschnitt.png)
:::
::::

::: paragraph
Öffnen Sie mit dem Knopf [Edit settings]{.guihint} die gleichnamige
Seite:
:::

:::: imageblock
::: content
![Formular zur Eingabe der
Lizenznutzungseinstellungen.](../images/license_edit_settings_ce.png)
:::
::::

::: paragraph
Wählen Sie nun, ob Sie die Subskriptionsinformationen online oder
offline übermitteln wollen. Wir empfehlen, die Online-Übermittlung zu
nutzen. Dann kann Ihnen Checkmk alle weiteren Aktivitäten zur
Lizenzierung abnehmen. Für die Online-Übermittlung füllen Sie noch die
Felder [Licensing ID]{.guihint} und [Password]{.guihint} mit den
[Informationen aus dem Kundenportal.](#generate_application_password)
:::

::: paragraph
Zum Abschluss klicken Sie auf [Save]{.guihint}, um Ihre Angaben zu
speichern.
:::
:::::::::::

:::::::::::: sect2
### []{#submit_usage_cce .hidden-anchor .sr-only}3.2. Lizenznutzungsinformationen an Checkmk GmbH/Inc. übermitteln {#heading_submit_usage_cce}

::: paragraph
Als Benutzer von Checkmk Cloud oder Checkmk MSP lassen Sie Checkmk Ihre
Lizenzinformationen per Online-Kommunikation übertragen. Nur falls in
Ihrem Unternehmen der Checkmk-Server aus technischen Gründen das
Checkmk-Kundenportal nicht erreichen kann, müssen Sie [die Daten manuell
übermitteln](#manualtrans).
:::

::: paragraph
Ihre Lizenzinformationen sind für Sie jederzeit transparent einsehbar.
Es werden die Angaben verwendet, die Sie auf den Seiten [License
usage]{.guihint} und [Edit settings]{.guihint} sehen.
:::

::: paragraph
Die Lizenzierungs-Anmeldedaten müssen vor der ersten Übertragung in
Checkmk hinterlegt worden sein (siehe [Subskriptionsdaten in Checkmk
eingeben](#setup_cce)).
:::

::: paragraph
Haben Sie sich für die Online-Übermittlung entschieden, so klicken Sie
auf den aktiven Knopf [Online verification]{.guihint}. Sie erhalten dann
eine Erfolgsmeldung in Checkmk.
:::

:::: imageblock
::: content
![Anzeige der übermittelten
Lizenzinformationen.](../images/license_online_success_cce.png)
:::
::::

::: paragraph
Damit haben Sie Ihre Checkmk Cloud / Checkmk MSP erstmalig für die
lizenzierte Nutzung freigeschaltet.
:::

::: paragraph
Ab jetzt meldet Checkmk regelmäßig Ihre aktuelle Lizenznutzung an
Checkmk GmbH/Inc. Nach jeder erfolgreichen Übertragung sehen Sie eine
Bestätigung sowie eine Zusammenfassung der übermittelten Informationen.
Im Rahmen dieses Prozesses holt Checkmk auch automatisch neue
Lizenzinformationen aus dem Checkmk-Kundenportal, falls Sie
zwischenzeitlich die Lizenz erweitert oder verlängert haben.
:::

::: paragraph
Sie können jederzeit eine erneute Synchronisation Ihrer Daten mit dem
Checkmk-Kundenportal anstoßen, indem Sie den Button [Online
verification]{.guihint} anklicken.
:::
::::::::::::

:::::::: sect2
### []{#_lizenzverifizierung .hidden-anchor .sr-only}3.3. Lizenzverifizierung {#heading__lizenzverifizierung}

::: paragraph
Was passiert, wenn sich die Nutzungsphase Ihrer Lizenz dem Ende nähert?
Hier greift eine Abfolge verschiedener Eskalationsstufen. Sobald eine
neue Lizenz hochgeladen wurde, wird das Eskalationssystem abgebrochen.
:::

::: paragraph
Überprüft wird hierbei nur die Laufzeit der Lizenz. Gleichzeitig läuft
Ihr Monitoring aber normal weiter, auch Benachrichtigungen werden
regulär verschickt. Jedoch wird die Möglichkeit Änderungen zu aktivieren
im Falle einer Verletzung der vereinbarten Lizenzrichtlinien
unterbunden. Eine Überschreitung der aktuell lizenzierten Services und
Module hingegen wird nur erfasst und mit der nächsten Abrechnung
rückwirkend in Rechnung gestellt.
:::

::: paragraph
Derzeit gelten die folgenden Eskalationsstufen:
:::

::: ulist
- 30 Tage vor Lizenzende verschickt Checkmk eine E-Mail an die
  Administratoren, um diese über den Ablauf des Lizenzzeitraums zu
  informieren.

- 14 Tage vor Lizenzablauf verschickt Checkmk eine weitere E-Mail an die
  Administratoren. Zeitgleich wird für die Administratoren in Checkmk
  ein Hinweis-Banner sichtbar.

- 7 Tage vor Lizenzablauf verschickt Checkmk erneut eine E-Mail an die
  Administratoren. Außerdem wird nun in Checkmk für alle Benutzer
  dauerhaft ein Hinweis-Banner sichtbar.

- Nach Ablauf einer Karenzzeit blockiert Checkmk, wie oben beschrieben,
  die Möglichkeit Änderungen zu aktivieren. Das Hinweis-Banner bleibt
  für alle Benutzer dauerhaft sichtbar.
:::

::: paragraph
Sollte sich Ihr Checkmk in einem blockierten Zustand befinden, so
kontaktieren Sie den Checkmk-Vertrieb, der Ihnen weiterhelfen kann.
:::
::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#_lizenzierung_von_checkmk_enterprise .hidden-anchor .sr-only}4. Lizenzierung von Checkmk Enterprise {#heading__lizenzierung_von_checkmk_enterprise}

:::::::::::::::::::::: sectionbody
::: paragraph
Wenn Sie mit Checkmk Enterprise starten, schalten Sie anfangs nur Ihre
Lizenz frei. Die Übermittlung der Nutzungsdaten startet erst zum Ende
der ersten Lizenzphase.
:::

::::::::::: sect2
### []{#setup_cee .hidden-anchor .sr-only}4.1. Subskriptionsdaten in Checkmk eingeben {#heading_setup_cee}

::: paragraph
Öffnen Sie als [Checkmk-Administrator](wato_user.html#roles) [Setup \>
Maintenance \> Licensing.]{.guihint} Die Seite ist noch leer, solange
keine Subskriptionsdaten hinterlegt wurden.
:::

:::: imageblock
::: content
![Der Knopf \'Edit settings\' zum Öffnen der Seite mit den
Subskriptionseinstellungen.](../images/license_licensing_ausschnitt.png)
:::
::::

::: paragraph
Öffnen Sie über den Link [Settings]{.guihint} die Seite [Edit
settings]{.guihint}:
:::

:::: imageblock
::: content
![Formular zur Eingabe der
Lizenznutzungseinstellungen.](../images/license_edit_settings.png)
:::
::::

::: paragraph
Wählen Sie nun, ob Sie die Subskriptionsinformationen online oder
offline übermitteln wollen. Wir empfehlen, die Online-Übermittlung zu
nutzen. Dann kann Ihnen Checkmk die Arbeit zur Übermittlung Ihrer
Lizenzinformationen erleichtern. Für die Online-Übermittlung füllen Sie
noch die Felder [Licensing ID]{.guihint} und [Password]{.guihint} mit
den [Informationen aus dem
Kundenportal.](#generate_application_password)
:::

::: paragraph
Zum Abschluss klicken Sie auf [Save]{.guihint}, um Ihre Angaben zu
speichern.
:::
:::::::::::

::::::::::: sect2
### []{#submit_usage_cee .hidden-anchor .sr-only}4.2. Lizenznutzungsinformationen an Checkmk GmbH/Inc. übermitteln {#heading_submit_usage_cee}

::: paragraph
Einmal eingestellt übernimmt Checkmk den Großteil der Arbeit zur
Online-Übermittlung Ihrer Lizenzinformationen. Sie müssen lediglich
jeweils zum Beginn und zum Ende einer Nutzungsphase einmal die
Datenübertragung anstoßen. Nur falls dies in Ihrem Unternehmen nicht
möglich ist, müssen Sie [die Daten manuell übermitteln.](#manualtrans)
:::

::: paragraph
Ihre Lizenzinformationen sind für Sie jederzeit transparent einsehbar.
Es werden die Angaben verwendet, die Sie auf den Seiten [License
usage]{.guihint} und [Edit settings]{.guihint} sehen.
:::

::: paragraph
Die [Licensing credentials]{.guihint} müssen vor der ersten Übertragung
in Checkmk hinterlegt worden sein (siehe [Subskriptionsdaten in Checkmk
eingeben](#setup_cee)).
:::

::: paragraph
Haben Sie sich für die Online-Übermittlung entschieden (der
entsprechende Knopf ist aktiv), so klicken Sie auf [Submit license usage
online]{.guihint}. Checkmk kümmert sich um den Rest und für Sie entsteht
während der gesamten Nutzungsdauer keine weitere Arbeit. Nach jeder
erfolgreichen Übertragung erhalten Sie eine Bestätigung sowie eine
Zusammenfassung der übermittelten Informationen. Diese sieht dann zum
Beispiel so aus:
:::

:::: imageblock
::: content
![Anzeige der übermittelten
Lizenzinformationen.](../images/license_online_success_cee.png)
:::
::::

::: paragraph
Damit haben Sie erfolgreich die Nutzungsdaten der ersten Lizenzphase an
Checkmk GmbH/Inc. übermittelt.
:::

::: paragraph
Ab jetzt übermitteln Sie zum Ende einer Lizenzphase Ihre jeweilige
Lizenznutzung mit einem Klick auf [Submit license usage
online]{.guihint} an das Checkmk-Kundenportal. Sobald der Vertrag
verlängert oder angepasst wurde, holen Sie sich die neuen
Lizenzinformationen mit [Submit license usage online]{.guihint} zurück
in Checkmk.
:::
:::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::

:::::::::::::: sect1
## []{#_lizenznutzungsinformationen_anzeigen .hidden-anchor .sr-only}5. Lizenznutzungsinformationen anzeigen {#heading__lizenznutzungsinformationen_anzeigen}

::::::::::::: sectionbody
::: paragraph
Checkmk beginnt ab dem Start Ihrer Lizenz, die lizenzrelevanten
Informationen in Form eines farbigen Diagramms anzuzeigen.
:::

::: paragraph
Wenn die Lizenzverwaltung mindestens zwei volle Tage gelaufen ist, sehen
Sie ein Diagramm dieser Art:
:::

:::: imageblock
::: content
![Graphische Übersicht über die aktuelle
Lizenznutzung.](../images/license_usage.png)
:::
::::

::: paragraph
Anhand der verschiedenfarbigen Elemente können Sie Folgendes ablesen:
:::

::: ulist
- Die rote Linie zeigt das aktuell vertraglich vereinbarte Lizenzlimit.
  Damit sind Überschreitungen der Service-Anzahl leicht zu erkennen.

- Die hellblaue Linie zeigt die durchschnittliche Service-Anzahl pro
  Monat an. Hierdurch werden Spitzen, die z.B. durch eine
  Fehlkonfiguration entstehen, geglättet.

- Die dunkelblaue Linie zeigt für jeden Tag die Gesamtzahl der
  überwachten Services über alle verbundenen Instanzen hinweg an.

- Die grüne Spalte zeigt die durchschnittliche Service-Anzahl im
  aktuellen Monat.

- Die gelbe Spalte zeigt den ersten Monat, in dem das Lizenzlimit
  überschritten wird.

- Die lila Spalte zeigt den Monat mit der höchsten Lizenzüberschreitung.
:::

::: paragraph
In einer Tabelle unterhalb dieser Grafik sehen Sie eine Übersicht der
Services und Hosts, wie sie an die Checkmk GmbH gemeldet werden:
:::

:::: imageblock
::: content
![Übersicht der Services und Hosts in den verschiedenen
Stati.](../images/license_usage_unten.png)
:::
::::

::: paragraph
In der Lizenzierung wird unterschieden nach:
:::

+--------------------+-------------------------------------------------+
| Lizenzierbare      | Anzahl der Services bzw. Hosts, die für die     |
| Services / Hosts   | Größe der Lizenzberechnung herangezogen werden. |
+--------------------+-------------------------------------------------+
| Ausgeschlossene    | Services bzw. Hosts, die nicht in die           |
| Services / Hosts   | Lizenzgröße eingerechnet werden. Sie sind für   |
|                    | Instanzen gedacht, mit denen neue Funktionen,   |
|                    | Konfigurationsänderungen, oder ähnliches von    |
|                    | Checkmk getestet werden soll. Um Services oder  |
|                    | Hosts als ausgeschlossen zu markieren, setzen   |
|                    | Sie Labels vom Typ `cmk/licensing:excluded`     |
|                    | entsprechend der Beschreibung zur [Erstellung   |
|                    | von Labels](labels.html#create_labels).         |
+--------------------+-------------------------------------------------+
| Schatten-Services  | Services bzw. Hosts, die automatisiert und aus  |
| / -Hosts           | technischen Gründen als [Schatten-Services bzw. |
|                    | -Hosts](distributed_monitoring.html#cmcdump)    |
|                    | angelegt werden. Sie werden in die              |
|                    | Lizenzberechnung nicht einbezogen.              |
+--------------------+-------------------------------------------------+
| Cloud-Services /   | Cloud-basierte Services bzw. Hosts, die für die |
| -Hosts             | Größe der Lizenzberechnung herangezogen werden. |
+--------------------+-------------------------------------------------+
:::::::::::::
::::::::::::::

::::::::::::::: sect1
## []{#manualtrans .hidden-anchor .sr-only}6. Manuelle Übermittlung {#heading_manualtrans}

:::::::::::::: sectionbody
::: paragraph
Sollten Sie aus technischen Gründen gezwungen sein, Ihre
Lizenzinformationen manuell in das Kundenportal hochzuladen, so gehen
Sie dabei folgendermaßen vor:
:::

::: paragraph
Öffnen Sie [Setup \> Maintenance \> Licensing.]{.guihint} Klicken Sie
dann auf den Knopf [![Symbol zur Offline-Übertragung der
Lizenzdaten.](../images/icons/icon_assume_0.png)]{.image-inline}
[Offline verification]{.guihint} in Checkmk Cloud bzw. [Submit license
usage offline]{.guihint} in den anderen kommerziellen Editionen.
:::

::: paragraph
Sie gelangen auf eine dieser Seiten:
:::

::::: imageblock
::: content
![Seite zur Offline-Verifizierung der Lizenzinformationen in Checkmk
Cloud.](../images/license_offline_verification.png){width="85%"}
:::

::: title
Offline-Verifizierung der Lizenz in Checkmk Cloud
:::
:::::

::::: imageblock
::: content
![Seite für Offline-Übermittlung der Lizenzinformationen in Checkmk
Enterprise.](../images/license_offline_submission.png){width="85%"}
:::

::: title
Offline-Übermittlung der Lizenzinformationen in Checkmk Enterprise
:::
:::::

::: paragraph
Folgen Sie den Anweisungen auf dieser Seite. Laden Sie also die
geforderten Daten aus Checkmk herunter. Als nächstes laden Sie die
zugehörige Datei ins Kundenportal hoch. Die Antwortdatei, die Sie
daraufhin erhalten, laden Sie dann in Checkmk hoch, um den Prozess
abzuschließen.
:::

::: paragraph
Achten Sie darauf, dass Sie in einem [verteilten
Monitoring](glossar.html#distributed_monitoring) sowohl die
Übermittlungen *zum* Kundenportal als auch die *aus dem* Kundenportal
nicht nur auf der Zentralinstanz, sondern auch auf allen
Remote-Instanzen ausführen müssen. Beim [verteilten
Setup](glossar.html#distributed_setup) erfolgt die komplette Abwicklung
der Lizenzierung über die Zentralinstanz.
:::
::::::::::::::
:::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
