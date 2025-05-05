:::: {#header}
# Verfügbarkeit (Availability)

::: details
[Last modified on 13-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/availability.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Erweiterte Verfügbarkeiten (SLAs)](sla.html) [Berichte
(Reports)](reporting.html) [Zeitperioden (Time
Periods)](timeperiods.html) [Business Intelligence (BI)](bi.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#_grundprinzip .hidden-anchor .sr-only}1. Grundprinzip {#heading__grundprinzip}

:::::::::::: sectionbody
:::::: sect2
### []{#_der_blick_in_die_vergangenheit .hidden-anchor .sr-only}1.1. Der Blick in die Vergangenheit {#heading__der_blick_in_die_vergangenheit}

::: paragraph
Da Checkmk alle Hosts und Services in regelmäßigen Intervallen
kontinuierlich überwacht, schafft es damit eine hervorragende Grundlage
für spätere Auswertungen über deren Verfügbarkeit. Und nicht nur
das --- Sie können berechnen lassen, welchen Anteil der Zeit ein Objekt
in einem bestimmten Zustand war, wie oft dieser Zustand aufgetreten ist,
wie lange er am längsten angehalten hat und vieles mehr.
:::

::: paragraph
Jeder Berechnung liegen dabei eine *Auswahl von Objekten* und ein
bestimmter *Zeitraum der Vergangenheit* zugrunde. Checkmk rekonstruiert
dann für diesen Zeitraum den Verlauf des Zustands für jedes der
ausgewählten Objekte. Pro Zustand werden die Zeiten aufsummiert und in
einer Tabelle dargestellt. Das Ergebnis kann dann z.B. sein, dass der
Zustand eines bestimmten Services zu 99,95 % [OK]{.state0} war und zu
0,005 % [WARN]{.state1}.
:::

::: paragraph
Dabei rechnet Checkmk auch Dinge wie Wartungszeiten, Service-Zeiten,
nicht überwachte Zeiträume und andere Besonderheiten korrekt ab, erlaubt
das Zusammenfassen von Zuständen, das Ignorieren von „kurzen Aussetzern"
und noch etliche weitere Anpassungsmöglichkeiten. Auch eine
Verfügbarkeit von [BI-Aggregaten](#bi) ist möglich.
:::
::::::

::::::: sect2
### []{#states .hidden-anchor .sr-only}1.2. Mögliche Zustände {#heading_states}

::: paragraph
Durch die Einbeziehung von Wartungszeiten und ähnlichen Sonderzuständen
gibt es theoretisch eine sehr große Zahl von möglichen
Zustandskombinationen, wie z.B. [CRIT]{.state2} + In Wartungszeit + In
der Service-Zeit + Flapping. Da die meisten dieser Kombinationen nicht
sehr nützlich sind, reduziert Checkmk sie auf eine kleine Zahl und geht
dabei nach einem Prinzip von Prioritäten vor. Da in obigem Beispiel der
Service in einer Wartungszeit war, gilt als Zustand einfach [in
scheduled downtime]{.guihint} und der eigentliche Zustand wird
ignoriert. Das reduziert die Anzahl der möglichen Zustände auf die
Folgenden:
:::

:::: imageblock
::: content
![Illustration der möglichen Zustände.](../images/avail_states.png)
:::
::::

::: paragraph
Diese Grafik zeigt auch die Reihenfolge, nach der Zustände priorisiert
werden. Später werden wir zeigen, wie Sie manche der Zustände ignorieren
oder zusammenfassen können. Hier die Zustände noch einmal im Detail:
:::

+--------------------+--------+----------------------------------------+
| Zustand            | Abk    | Bedeutung                              |
|                    | ürzung |                                        |
+====================+========+========================================+
| [unmo              | N/A    | Zeiträume, während derer das Objekt    |
| nitored]{.guihint} |        | nicht überwacht wurde. Dafür gibt es   |
|                    |        | zwei mögliche Ursachen: Das Objekt war |
|                    |        | nicht Teil der                         |
|                    |        | Monitoring-Konfiguration, oder das     |
|                    |        | Monitoring selbst ist für diesen       |
|                    |        | Zeitraum nicht gelaufen.               |
+--------------------+--------+----------------------------------------+
| [out of service    |        | Das Objekt war außerhalb seiner        |
| period]{.guihint}  |        | [![icon outof                          |
|                    |        | serviceperiod](../images/icons/icon_ou |
|                    |        | tof_serviceperiod.png)]{.image-inline} |
|                    |        | Service-Periode --- also in einem      |
|                    |        | Zeitraum, in dem die Verfügbarkeit     |
|                    |        | „egal" war. Mehr zu den                |
|                    |        | Service-Perioden erfahren Sie [weiter  |
|                    |        | unten](#serviceperiod).                |
+--------------------+--------+----------------------------------------+
| [in scheduled      | [D     | Das Objekt war innerhalb einer         |
| d                  | owntim | geplanten [![icon                      |
| owntime]{.guihint} | e]{.gu | downtime](../images/ic                 |
|                    | ihint} | ons/icon_downtime.png)]{.image-inline} |
|                    |        | [Wartungszeit](basics_downtimes.html). |
|                    |        | Bei Services wird dieser Zustand auch  |
|                    |        | dann angenommen, wenn Ihr Host in      |
|                    |        | einer Wartung ist.                     |
+--------------------+--------+----------------------------------------+
| [on down           | [H.Dow | Diesen Zustand gibt es nur bei         |
| host]{.guihint}    | n]{.gu | Services --- und zwar wenn der Host    |
|                    | ihint} | des Services [DOWN]{.hstate1} ist.     |
|                    |        | Eine Überwachung des Services zu so    |
|                    |        | einem Zeitpunkt ist nicht möglich. Bei |
|                    |        | den meisten Services ist dies          |
|                    |        | gleichbedeutend damit, dass der        |
|                    |        | Service [CRIT]{.state2} ist --- aber   |
|                    |        | nicht bei allen! Zum Beispiel ist der  |
|                    |        | Zustand eines Dateisystems             |
|                    |        | ([Filesystem]{.guihint}-Check) sicher  |
|                    |        | unabhängig davon, ob der Host          |
|                    |        | erreichbar ist.                        |
+--------------------+--------+----------------------------------------+
| [f                 |        | Phasen, in denen Zustand [![icon       |
| lapping]{.guihint} |        | flapping](../images/ic                 |
|                    |        | ons/icon_flapping.png)]{.image-inline} |
|                    |        | [unst                                  |
|                    |        | etig](monitoring_basics.html#flapping) |
|                    |        | ist --- also viele Zustandswechsel in  |
|                    |        | kurzer Zeit erfahren hat.              |
+--------------------+--------+----------------------------------------+
| [UP]{.hstate0}     |        | Monitoring-Zustand von Hosts.          |
| [DOWN]{.hstate1}   |        |                                        |
| [                  |        |                                        |
| UNREACH]{.hstate2} |        |                                        |
+--------------------+--------+----------------------------------------+
| [OK]{.state0}      |        | Monitoring-Zustand von Services und    |
| [WARN]{.state1}    |        | BI-Aggregaten.                         |
| [CRIT]{.state2}    |        |                                        |
| [UNKNOWN]{.state3} |        |                                        |
+--------------------+--------+----------------------------------------+
:::::::
::::::::::::
:::::::::::::

::::::::::::::::::::::::::::::::::::: sect1
## []{#_availability_aufrufen .hidden-anchor .sr-only}2. Availability aufrufen {#heading__availability_aufrufen}

:::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_von_der_ansicht_zur_auswertung .hidden-anchor .sr-only}2.1. Von der Ansicht zur Auswertung {#heading__von_der_ansicht_zur_auswertung}

::: paragraph
Das Erstellen einer Verfügbarkeitsauswertung ist sehr einfach. Rufen Sie
zunächst eine beliebige [Ansicht](views.html) von Hosts, Services oder
[BI-Aggregaten](bi.html) auf. Dort finden Sie im Menü
[Services]{.guihint} bzw. [Hosts]{.guihint} den Eintrag
[Availability]{.guihint}, welcher Sie direkt zur Berechnung der
Verfügbarkeit der ausgewählten Objekte bringt. Diese wird tabellarisch
angezeigt:
:::

:::: imageblock
::: content
![Tabellenansicht der Verfügbarkeiten aller
Services.](../images/avail_screenshot.png)
:::
::::

::: paragraph
Die Tabelle zeigt die gleichen Objekte, die auch in der vorherigen
Ansicht sichtbar waren. In jeder Spalte wird dargestellt, welchen Anteil
des Abfragezeitraums das Objekt im besagten Zustand war. Die Darstellung
ist per Default in Prozent mit zwei Kommastellen, aber das können Sie
leicht [umstellen](#format_time_range).
:::

::: paragraph
Den Anfragezeitraum können Sie mit dem Menüeintrag [Availability \>
Change display options \> [Time Range](#option_timerange)]{.guihint}
ändern. Dazu weiter unten mehr  ...​
:::

::: paragraph
Sie haben die Möglichkeit, die Ansicht als PDF zu exportieren (nur
kommerzielle Editionen). Auch ein Download der Daten in CSV-Format ist
möglich [(Export as CSV)]{.guihint}. Das sieht dann für obiges Beispiel
so aus:
:::

::::: listingblock
::: title
Checkmk-Availability-2021-10-19_11-01-15.csv
:::

::: content
``` {.pygments .highlight}
Host;Service;OK;WARN;CRIT;UNKNOWN;Flapping;H.Down;Downtime;N/A
mail.mydomain.test;Check_MK;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Check_MK Discovery;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Filesystem /;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Filesystem /var/spool;0.00%;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;HTTP https://mail.mydomain.test/;99.85%;0.15%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;HTTPS https://mail.mydomain.test/;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;MTA performance check;99.23%;0.30%;0.46%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Postfix Queue;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Postfix status;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
mail.mydomain.test;Uptime;100.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
Summary;;89.91%;10.05%;0.05%;0.00%;0.00%;0.00%;0.00%;0.00%
```
:::
:::::

::: paragraph
Mithilfe eines [Automationsbenutzers](wato_user.html#automation), der
sich über die URL authentifizieren kann, können Sie so die Daten auch
skriptgesteuert abrufen (z.B. mit `wget` oder `curl`) und automatisiert
verarbeiten.
:::
:::::::::::::

:::::::: sect2
### []{#timeline .hidden-anchor .sr-only}2.2. Zeitleistendarstellung {#heading_timeline}

::: paragraph
In jeder Zeile finden Sie das Symbol [![button
timeline](../images/icons/button_timeline.png)]{.image-inline}. Dies
bringt Sie zu einer Zeitleistendarstellung des entsprechenden Objekts,
in der genau aufgeschlüsselt ist, welche Zustandswechsel es im
Anfragezeitraum gab (hier gekürzt):
:::

:::: imageblock
::: content
![Tabellenansicht mit Zeitleiste der
Zustandswechsel.](../images/avail_timeline.png)
:::
::::

::: paragraph
Dazu einige Hinweise:
:::

::: ulist
- Fahren Sie mit der Maus in der Zeitleistengrafik über einen Abschnitt,
  so wird dieser in der Tabellendarstellung hervorgehoben.

- Auch in der Zeitleiste können Sie mit dem Menüeintrag [Availability \>
  Change display options]{.guihint} bzw. [Availability \> Change
  computation options]{.guihint} die [Optionen](#options) für die
  Darstellung und Auswertung anpassen.

- Mit dem Symbol [![button
  annotation](../images/icons/button_annotation.png)]{.image-inline}
  erstellen Sie eine Anmerkung [(Annotation)]{.guihint} zu dem gewählten
  Abschnitt. Hier können Sie auch nachträglich Wartungszeiten angeben
  (mehr dazu gleich im nächsten Abschnitt).

- Bei der Verfügbarkeit von BI-Aggregaten können Sie mit dem [![button
  timewarp](../images/icons/button_timewarp.png)]{.image-inline}
  Zauberstab eine Zeitreise zu dem Zustand des Aggregats im besagten
  Abschnitt machen. Mehr dazu [weiter unten](#bi).

- Mit dem Menüeintrag [Availability \> Timeline]{.guihint} in der
  Hauptansicht können Sie die Zeitleisten von allen gewählten Objekten
  in einer einzigen langen Seite ansehen.
:::
::::::::

::::::::::::: sect2
### []{#annotations .hidden-anchor .sr-only}2.3. Anmerkungen und nachträgliche Wartungszeiten {#heading_annotations}

::: paragraph
Wie gerade erwähnt, bietet die Zeitleiste über das Symbol [![button
annotation](../images/icons/button_annotation.png)]{.image-inline} die
Möglichkeit, für einen Zeitabschnitt eine Anmerkung zu hinterlegen.
Dahinter finden Sie ein bereits ausgefülltes Formular, in dem Sie einen
Kommentar eingeben können:
:::

:::: imageblock
::: content
![Eigenschaften einer Anmerkung.](../images/avail_anno_1.png)
:::
::::

::: paragraph
Dabei können Sie den Zeitraum auch anders festlegen und erweitern. Das
ist z.B. praktisch, wenn Sie einen größeren Abschnitt annotieren
möchten, der mehrere Zustandswechsel erlebt hat. Wenn Sie die Angabe
eines Services weglassen, erzeugen Sie eine Anmerkung für einen Host.
Diese bezieht sich automatisch auch auf alle Services des Hosts.
:::

::: paragraph
In jeder Verfügbarkeitsansicht werden automatisch alle Anmerkungen
sichtbar, die zum Zeitraum und den Objekten passen, die dargestellt
werden.
:::

::: paragraph
Aber Annotationen haben noch eine weitere Funktion: Sie können damit
nachträglich Wartungszeiten eintragen oder umgekehrt auch entfernen. Die
Verfügbarkeitsberechnung berücksichtigt diese Korrekturen wie ganz
normale Wartungszeiten. Es gibt für so etwas mindestens zwei legitime
Gründe:
:::

::: ulist
- Während des Betriebs kann es passieren, dass geplante Wartungszeiten
  nicht korrekt eingetragen wurden. Das sieht für die Verfügbarkeit
  natürlich schlecht aus. Durch nachträgliches Eintragen dieser Zeiten
  können Sie den Bericht richtigstellen.

- Es gibt Benutzer, die bei einem spontanen Ausfall Wartungszeiten
  missbrauchen, um Benachrichtigungen abzustellen. Das verfälscht später
  die Auswertungen. Durch nachträgliches *Entfernen* der Wartungszeit
  können Sie das korrigieren.
:::

::: paragraph
Zum Umklassifizieren von Wartungszeiten wählen Sie einfach die Checkbox
[Reclassify downtime of this period]{.guihint}:
:::

:::: imageblock
::: content
![Die Option \'Reclassify downtime of this period\' in den
Anmerkungseigenschaften.](../images/avail_anno_2.png)
:::
::::
:::::::::::::

::::::: sect2
### []{#_monitoring_historie_anzeigen .hidden-anchor .sr-only}2.4. Monitoring-Historie anzeigen {#heading__monitoring_historie_anzeigen}

::: paragraph
In der Verfügbarkeitstabelle finden Sie neben dem Symbol für die
Zeitleiste noch ein weiteres Symbol: [![button
history](../images/icons/button_history.png)]{.image-inline}. Dieses
bringt Sie zur [Ansicht](views.html) der Monitoring-Historie mit einem
bereits ausgefüllten Filter für das entsprechende Objekt und den
Anfragezeitraum. Dort sehen Sie nicht nur die Ereignisse, auf denen die
Verfügbarkeitsberechnung basiert (die Zustandswechsel), sondern auch die
zugehörigen Benachrichtigungen und ähnliche Ereignisse:
:::

:::: imageblock
::: content
![Die Monitoring-Historie.](../images/avail_history.png)
:::
::::

::: paragraph
Was Sie hier nicht sehen, ist der Zustand des Objekts am *Anfang* des
Abfragezeitraums. Die Berechnung der Verfügbarkeit geht dazu noch weiter
in die Vergangenheit zurück, um den Anfangszustand zuverlässig zu
ermitteln.
:::
:::::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#options .hidden-anchor .sr-only}3. Auswertungen anpassen {#heading_options}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Menü mit Optionen zur Anpassung der
Auswertung.](../images/avail_menu_options.png){width="350"}
:::
::::

::: paragraph
Sowohl die Berechnung als auch die Darstellung der Verfügbarkeit können
Sie durch zahlreiche Optionen beeinflussen. Sie finden diese im
Menüeintrag [Availability \> Change display options]{.guihint}
(Anzeigeoptionen ändern) respektive [Availability \> Change computation
options]{.guihint} (Berechnungsregeln ändern).
:::

::: paragraph
Nachdem Sie die Optionen geändert und mit [Apply]{.guihint} bestätigt
haben, wird die Verfügbarkeit neu berechnet und dargestellt. Alle
geänderten Optionen werden für Ihr Benutzerprofil als Default
hinterlegt, so dass Sie beim nächsten Aufruf wieder die gleichen
Einstellungen vorfinden.
:::

::: paragraph
Gleichzeitig sind die Optionen in der URL der aktuellen Seite kodiert.
Wenn Sie also jetzt ein *Lesezeichen* auf die Seite speichern (z.B. mit
dem praktischen [Bookmarks]{.guihint}-Element), dann sind die Optionen
Teil von diesem und werden bei einem späteren Klick darauf genau so
wieder hergestellt.
:::

::::::::::::: sect2
### []{#option_timerange .hidden-anchor .sr-only}3.1. Auswahl des Zeitbereichs {#heading_option_timerange}

::::::: {.openblock .float-group}
:::::: content
:::: {.imageblock .inline-image}
::: content
![Optionen für den
Zeitraum.](../images/avoption_time_range2.png){width="350"}
:::
::::

::: paragraph
Die wichtigste und erste Option jeder Verfügbarkeitsauswertung ist
natürlich der Zeitbereich, der betrachtet wird. Bei [Date
range]{.guihint} können Sie einen exakten Zeitbereich mit Anfangs- und
Enddatum festlegen. Dabei ist der letzte Tag bis 24:00 Uhr mit
eingeschlossen.
:::
::::::
:::::::

::::::: {.openblock .float-group}
:::::: content
:::: {.imageblock .inline-image}
::: content
![Option für einen relativen
Zeitraum.](../images/avoption_time_range.png){width="350"}
:::
::::

::: paragraph
Viel praktischer sind die relativen Zeitangaben wie z.B. [Last
week]{.guihint}. Welcher Zeitraum genau angezeigt wird, hängt dabei
(gewollt) vom Zeitpunkt ab, zu dem die Berechnung angestellt wird. Eine
Woche geht hier übrigens immer von Montag 00:00 Uhr bis Sonntag 24:00
Uhr.
:::
::::::
:::::::
:::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_optionen_die_die_darstellung_betreffen .hidden-anchor .sr-only}3.2. Optionen, die die Darstellung betreffen {#heading__optionen_die_die_darstellung_betreffen}

::: paragraph
Viele Optionen betreffen die Art, wie die Daten präsentiert werden,
andere wiederum beeinflussen die Berechnungsmethode. Zunächst ein Blick
auf die Darstellung:
:::

:::::: sect3
#### []{#_zeilen_mit_100_verfügbarkeit_ausblenden .hidden-anchor .sr-only}Zeilen mit 100 % Verfügbarkeit ausblenden {#heading__zeilen_mit_100_verfügbarkeit_ausblenden}

:::: {.imageblock .inline-image}
::: content
![Optionen zur Ausblendung von Zeilen mit 100 %
Verfügbarkeit.](../images/avoption_only_outages.png){width="350"}
:::
::::

::: paragraph
Die Option [Only show objects with outages]{.guihint} begrenzt die
Darstellung auf solche Objekte, die überhaupt Ausfälle hatten (also
Zeiten, zu denen der Zustand nicht [OK]{.state0} bzw. [UP]{.hstate0}
war). Das ist nützlich, wenn Sie bei einer großen Zahl von Services nur
die paar wenigen herauspicken wollen, bei denen es ein Problem ab.\
:::
::::::

::::::: sect3
#### []{#_beschriftungsoptionen .hidden-anchor .sr-only}Beschriftungsoptionen {#heading__beschriftungsoptionen}

:::: {.imageblock .inline-image}
::: content
![Beschriftungsoptionen.](../images/avoption_labelling.png){width="350"}
:::
::::

::: paragraph
Die [Labelling options]{.guihint} erlauben es, verschiedene
Beschriftungsfelder ein- oder umgekehrt auszuschalten. Manche der
Optionen sind vor allem für das [Reporting](reporting.html) interessant.
Zum Beispiel ist bei einem Bericht, der sowieso nur über einen Host
geht, die Spalte mit dem Host-Namen eventuell überflüssig.
:::

::: paragraph
Die alternativen Anzeigenamen [(alternative display names)]{.guihint}
von Services können Sie über eine [Regel](wato_rules.html) festlegen und
damit z.B. wichtigen Services einen für den Leser Ihres Berichts
aussagekräftigen Namen geben.
:::
:::::::

:::::: sect3
#### []{#thresholds .hidden-anchor .sr-only}SLAs mit Schwellwerten farbig darstellen {#heading_thresholds}

:::: {.imageblock .inline-image}
::: content
![Optionen zur farbigen Darstellung bei Unterschreitung von
Schwellwerten.](../images/avoption_visual_levels.png){width="350"}
:::
::::

::: paragraph
Mit den [Visual levels]{.guihint} können Sie Objekte optisch
hervorheben, die eine bestimmte Verfügbarkeit im Anfragezeitraum
unterschritten haben. Das betrifft ausschließlich die Spalte für den
[OK]{.state0}-Zustand. Diese ist normalerweise immer grün eingefärbt.
Bei Unterschreitung der eingestellten Schwellen ändert sich die Farbe
dieser Zelle dann auf Gelb bzw. Rot. Man kann das als sehr einfache
SLA-Auswertung bezeichnen.
:::
::::::

::::::::::::: sect3
#### []{#_anzahl_und_dauer_der_einzelnen_ausfälle_anzeigen .hidden-anchor .sr-only}Anzahl und Dauer der einzelnen Ausfälle anzeigen {#heading__anzahl_und_dauer_der_einzelnen_ausfälle_anzeigen}

::::::: {.openblock .float-group}
:::::: content
:::: {.imageblock .inline-image}
::: content
![Optionen zur Darstellung von Anzahl und Dauer von
Ausfällen.](../images/avoption_outage_statistics.png){width="350"}
:::
::::

::: paragraph
Die Option [Outage statistics]{.guihint} liefert zusätzliche
Informationsspalten in der Verfügbarkeitstabelle. In der Abbildung
wurden die Informationen [max. duration]{.guihint} und [count]{.guihint}
für die Statusspalte [Crit/Down]{.guihint} aktiviert. Das bedeutet, dass
Sie zu Ausfällen vom Zustand [CRIT]{.state2}/[DOWN]{.hstate1} jeweils
die Anzahl der Vorfälle sowie die Dauer des längsten Vorfalls sehen.
:::
::::::
:::::::

::::::: {.openblock .float-group}
:::::: content
:::: {.imageblock .inline-image}
::: content
![Ansicht mit den zusätzlichen Spalten zur Darstellung von
Ausfällen.](../images/avoption_count_max.png){width="350"}
:::
::::

::: paragraph
In der Tabelle entstehen so zusätzliche Spalten.
:::
::::::
:::::::
:::::::::::::

::::::::: sect3
#### []{#format_time_range .hidden-anchor .sr-only}Darstellung von Zeitangaben {#heading_format_time_range}

:::: {.imageblock .inline-image}
::: content
![Optionen zur Formatierung von
Zeiträumen.](../images/avoption_format_time.png){width="350"}
:::
::::

::: paragraph
Nicht immer ist es sinnvoll, (Nicht-)Verfügbarkeiten in Prozent
anzugeben. Die Option [Format time ranges]{.guihint} erlaubt das
Umstellen auf eine Darstellung, in der Zeiträume in absoluten Zahlen
gezeigt werden. Damit können Sie die Gesamtlänge der Ausfallzeiten auf
die Minute genau sehen. Die Darstellung zeigt sogar Sekunden, aber
bedenken Sie, dass das nur dann Sinn macht, wenn Sie die Überwachung
auch im Sekundenraster durchführen und nicht wie üblich mit einem Check
pro Minute. Auch die Genauigkeit der Angabe (Kommastellen in den
Prozentwerten) können Sie hier bestimmen.
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Formatierung von
Zeitstempeln.](../images/avoption_format_timestamps.png){width="350"}
:::
::::

::: paragraph
Die Formatierung von Zeitstempeln betrifft Angaben in der Zeitleiste
[(Timeline)]{.guihint}. Die Umstellung auf UNIX-Epoch (Sekunden seit dem
1.1.1970) erleichtert die Zuordnung von Zeitbereichen zu den
entsprechenden Stellen in den Logdateien der Monitoring-Historie.
:::
:::::::::

:::::: sect3
#### []{#_anpassen_der_zusammenfassungszeile .hidden-anchor .sr-only}Anpassen der Zusammenfassungszeile {#heading__anpassen_der_zusammenfassungszeile}

:::: {.imageblock .inline-image}
::: content
![Option zur Anpassung der
Zusammenfassung.](../images/avoption_summary_line.png){width="350"}
:::
::::

::: paragraph
Die Zusammenfassung in der letzten Zeile der Tabelle können Sie hiermit
nicht nur ein- und ausschalten. Sie können sich auch zwischen Summe und
Durchschnitt entscheiden. Bei Spalten, die Prozentwerte enthalten, wird
auch bei der Einstellung [Summe]{.guihint} ein Durchschnitt angezeigt,
da es wenig sinnvoll ist, Prozentwerte zu addieren.
:::
::::::

:::::: sect3
#### []{#_kleine_zeitleiste_einblenden .hidden-anchor .sr-only}Kleine Zeitleiste einblenden {#heading__kleine_zeitleiste_einblenden}

:::: {.imageblock .inline-image}
::: content
![Option zur Einblendung der kleinen
Zeitleiste.](../images/avoption_timeline.png){width="350"}
:::
::::

::: paragraph
Diese Option fügt eine Miniaturversion der [Zeitleiste](#timeline)
direkt in die Ergebnistabelle ein. Sie entspricht dem grafischen Balken
in der detaillierten Zeitleiste, ist aber kleiner und direkt in die
Tabelle integriert. Außerdem ist sie maßstabsgetreu, damit Sie mehrere
Objekte in der gleichen Tabelle vergleichen können.
:::
::::::

::::::: sect3
#### []{#_gruppierung_nach_host_host_gruppe_oder_service_gruppe .hidden-anchor .sr-only}Gruppierung nach Host, Host-Gruppe oder Service-Gruppe {#heading__gruppierung_nach_host_host_gruppe_oder_service_gruppe}

:::: {.imageblock .inline-image}
::: content
![Option zur Gruppierung nach Host, Host-Gruppe oder
Service-Gruppe.](../images/avoption_group.png){width="350"}
:::
::::

::: paragraph
Unabhängig von der Darstellung der Ansicht, von der Sie kommen, zeigt
die Verfügbarkeit immer alle Objekte in einer gemeinsamen Tabelle. Sie
können mit dieser Option eine Gruppierung nach Host, Host-Gruppe oder
Service-Gruppe festlegen. Damit bekommen Sie auch pro Gruppe eine eigene
[Summary]{.guihint}-Zeile.
:::

::: paragraph
Beachten Sie, dass bei einer Gruppierung nach Service-Gruppe Services
*mehrfach* auftreten können. Das liegt daran, dass Services in mehreren
Gruppen gleichzeitig enthalten sein können.
:::
:::::::

:::::: sect3
#### []{#_nur_die_verfügbarkeit_anzeigen .hidden-anchor .sr-only}Nur die Verfügbarkeit anzeigen {#heading__nur_die_verfügbarkeit_anzeigen}

:::: {.imageblock .inline-image}
::: content
![Option zur Einschränkung der Anzeige auf die
Verfügbarkeit.](../images/avoption_availability.png){width="350"}
:::
::::

::: paragraph
Die Option [Availability]{.guihint} sorgt dafür, dass als einzige Spalte
diejenige für den Zustand [OK]{.state0} bzw. [UP]{.hstate0} ausgegeben
wird und diese den Titel [Avail.]{.guihint} bekommt. Damit wird
ausschließlich die eigentliche Verfügbarkeit angezeigt. Sie können das
mit den weiter unter gezeigten Möglichkeiten kombinieren, andere
Zustände (z.B. [WARN]{.state1}) auch dem OK-Zustand zuzurechnen und
damit als verfügbar zu werten.
:::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::: sect2
### []{#_gruppierung_nach_zuständen .hidden-anchor .sr-only}3.3. Gruppierung nach Zuständen {#heading__gruppierung_nach_zuständen}

::: paragraph
Die in der Einleitung beschriebenen [Zustände](#states) können auf
verschiedenste Arten angepasst und verdichtet werden. Auf diese Weise
werden flexibel sehr unterschiedliche Arten von Auswertungen erstellt.
Dafür gibt es verschiedene Optionen.
:::

:::::::::: sect3
#### []{#_behandlung_von_warn_unknown_und_host_down .hidden-anchor .sr-only}Behandlung von WARN, UNKNOWN und Host Down {#heading__behandlung_von_warn_unknown_und_host_down}

:::: {.imageblock .inline-image}
::: content
![Optionen zur Gruppierung von
Service-Zuständen.](../images/avoption_status_grouping.png){width="350"}
:::
::::

::: paragraph
Die Option [Service status grouping]{.guihint} bietet die Möglichkeit,
verschiedene „Zwischenzustände" auf andere abzubilden. Ein häufiger Fall
ist, dass man [WARN]{.state1} zu [OK]{.state0} dazuschlägt (wie in der
Abbildung zu sehen). Wenn Sie an der eigentlichen *Verfügbarkeit* eines
Service interessiert sind, kann dies durchaus sinnvoll sein. Denn
[WARN]{.state1} bedeutet ja meist, dass es noch kein wirkliches Problem
gibt, dies aber bald der Fall sein *könnte.* So betrachtet muss dann
[WARN]{.state1} noch als verfügbar gelten. Bei Netzwerkdiensten wie
einem HTTP-Server ist es sicherlich sinnvoll, Zeiten, in denen der Host
[DOWN]{.hstate1} ist, ebenso zu behandeln wie wenn der Service selbst
[CRIT]{.state2} ist.
:::

::: paragraph
Die durch die Umgruppierung weggefallenen Zustände fehlen dann natürlich
auch in der Ergebnistabelle, welche dann weniger Spalten hat.
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Gruppierung von
Host-Zuständen.](../images/avoption_host_status_grouping.png){width="350"}
:::
::::

::: paragraph
Die Option [Host status grouping]{.guihint} ist sehr ähnlich, betrifft
aber Auswertungen der Verfügbarkeiten von Hosts. Der Zustand
[UNREACH]{.hstate2} bedeutet ja, dass ein Host aufgrund von
Netzwerkproblemen nicht von Checkmk überwacht werden konnte. Sie können
hier entscheiden, ob Sie das zum Zwecke der Verfügbarkeitsauswertung
lieber als als [UP]{.hstate0} oder [DOWN]{.hstate1} werten möchten.
Default ist, dass [UNREACH]{.hstate2} als eigener Zustand gewertet wird.
:::
::::::::::

:::::::: sect3
#### []{#_behandlung_von_nicht_überwachten_zeiträumen_und_flapping .hidden-anchor .sr-only}Behandlung von nicht überwachten Zeiträumen und Flapping {#heading__behandlung_von_nicht_überwachten_zeiträumen_und_flapping}

:::: {.imageblock .inline-image}
::: content
![Optionen zur Behandlung weiterer
Zustände.](../images/avoption_status_classification.png){width="350"}
:::
::::

::: paragraph
In der Option [Status classification]{.guihint} werden weitere
Zusammenfassungen vorgenommen. Die Checkbox [Consider periods of
flapping states]{.guihint} ist per Default an, womit Phasen häufiger
Zustandswechsel einen eigenen Zustand bilden: [![icon
flapping](../images/icons/icon_flapping.png)]{.image-inline} unstetig.
Die Idee dahinter ist, dass man gut sagen kann, dass der betroffene
Dienst während solcher Zeiten zwar immer wieder [OK]{.state0} ist, aber
durch die häufigen Ausfälle trotzdem nicht nutzbar. Deaktivieren Sie
diese Option, so wird das Konzept „flapping" komplett ignoriert und der
jeweils eigentliche Zustand kommt wieder zum Vorschein. Und die Spalte
[flapping]{.guihint} wird aus der Tabelle entfernt.
:::

::: paragraph
Das Entfernen der Option [Consider times where the host is
down]{.guihint} wirkt ähnlich. Sie schaltet das Konzept von [Host
down]{.guihint} ab. Diese Option macht nur bei der Verfügbarkeit von
Services Sinn. In Phasen, in denen der Host nicht [UP]{.hstate0} ist,
wird bei der Verfügbarkeit trotzdem der eigentliche Zustand des Services
zugrunde gelegt --- genauer gesagt der Zustand vom letzten Check bevor
der Host unerreichbar wurde. Dies kann sinnvoll sein bei Services, bei
denen es nicht um die Erreichbarkeit über das Netzwerk geht.
:::

::: paragraph
Ähnlich ist auch die Option [Include unmonitored time]{.guihint}.
Stellen Sie sich vor, Sie machen eine Auswertung über den Februar und
ein bestimmter Service ist erst am 15. Februar überhaupt in das
Monitoring aufgenommen worden. Hat dieser deswegen eine Verfügbarkeit
von nur 50 Prozent? In der Standardeinstellung (Option gesetzt) ist dies
tatsächlich der Fall. Die fehlenden 50 Prozent aber nicht als Ausfall
gewertet, sondern in einer eigenen Spalte mit dem Titel [N/A]{.guihint}
aufsummiert. Ohne die Option beziehen sich 100 Prozent auf die Zeit vom
15. bis zum 28. Februar. Das bedeutet dann allerdings auch, dass eine
Stunde Ausfall bei *diesem* Service prozentual doppelt so stark zu Buche
schlägt wie der Ausfall eines Services, der den ganzen Monat über
vorhanden war.
:::
::::::::

::::::: sect3
#### []{#_behandlung_von_geplanten_wartungszeiten .hidden-anchor .sr-only}Behandlung von geplanten Wartungszeiten {#heading__behandlung_von_geplanten_wartungszeiten}

:::: {.imageblock .inline-image}
::: content
![Optionen zur Behandlung von
Wartungszeiten.](../images/avoption_downtimes.png){width="350"}
:::
::::

::: paragraph
Mit der Option [Scheduled Downtimes]{.guihint} können Sie einstellen,
wie sich [Wartungszeiten](basics_downtimes.html) in der
Verfügbarkeitsauswertung auswirken:
:::

::: ulist
- [Honor scheduled downtimes]{.guihint} ist der Default. Hier werden
  Wartungszeichen als eigener Zustand in einer eigenen Spalte
  aufsummiert. Mit [Treat phases of UP/OK as non-downtime]{.guihint}
  können Sie die Zeiten, in denen der Service trotz Wartungszeit
  [OK]{.state0} war, von der Wartungszeit abziehen.

- [Ignore scheduled downtimes]{.guihint} ist, als wären überhaupt keine
  Wartungszeiten eingetragen gewesen. Ausfälle sind Ausfälle. Punkt.
  Aber natürlich auch nur dann, wenn es tatsächlich einen Ausfall
  gegeben hat.

- [Exclude scheduled downtimes]{.guihint} sorgt dafür, dass die
  Wartungszeiten einfach aus dem Berechnungszeitraum ausgeschlossen
  werden. Die prozentuale Verfügbarkeit bezieht sich dann nur auf die
  Zeiten außerhalb der Wartung.
:::
:::::::

:::::: sect3
#### []{#_zusammenfassen_gleicher_phasen .hidden-anchor .sr-only}Zusammenfassen gleicher Phasen {#heading__zusammenfassen_gleicher_phasen}

:::: {.imageblock .inline-image}
::: content
![Option zur Zusammenfassung gleicher
Phasen.](../images/avoption_phase_merging.png){width="350"}
:::
::::

::: paragraph
Durch das Umbiegen von Zuständen auf andere (z.B. aus [WARN]{.state1}
wird [OK]{.state0}) kann es sein, dass aufeinanderfolgende Abschnitte
der Zeitleiste eines Objekts den gleichen Zustand bekommen. Diese
Abschnitte werden dann normalerweise zu einem einzigen zusammengefasst.
Das ist meistens gut so und übersichtlich, hat aber Auswirkungen auf die
Darstellung der Details in der Zeitleiste und eventuell auch auf die
Zählung von Ereignissen mit der Option [Outage statistics]{.guihint}.
Daher können Sie das Verschmelzen mit [Do not merge consecutive phases
with equal state]{.guihint} abschalten.
:::
::::::
:::::::::::::::::::::::::::

:::::::::::: sect2
### []{#softstates .hidden-anchor .sr-only}3.4. Ignorieren kurzer Störungen {#heading_softstates}

::: paragraph
Manchmal werden Sie Überwachungen haben, die oft kurzzeitig ein Problem
melden, das aber im Normalfall beim nächsten Check (nach einer Minute)
schon wieder [OK]{.state0} ist. Und Sie finden keinen Weg durch Anpassen
von Schwellwerten oder Ähnlichem, das sauber in den Griff bekommen. Eine
häufige Lösung ist dann das Setzen der [[Maximum number of check
attempts]{.guihint}](monitoring_basics.html#max_check_attempts) von 1
auf 3, um mehrere Fehlversuche zu erlauben, bevor eine Benachrichtigung
stattfindet. Dadurch ergibt sich das Konzept von [Soft
states]{.guihint} --- die Zustände [WARN]{.state1}, [CRIT]{.state2} und
[UNKNOWN]{.state3} vor Ablauf aller Versuche.
:::

::: paragraph
Von Anwendern, die dieses Feature einsetzen, werden wir gelegentlich
gefragt, warum das Availability-Modul von Checkmk keine Funktion hat, um
für die Berechnung nur [Hard states]{.guihint} zu verwenden. Der Grund
ist: Es gibt eine bessere Lösung! Denn würde man die Hard states als
Grundlage nehmen,
:::

::: ulist
- würden Ausfälle aufgrund der erfolglosen Versuche 1 und 2 zwei Minuten
  zu kurz gewertet, und

- man könnte das Verhalten bei kurzen Ausfällen nicht *nachträglich*
  nachjustieren.
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Behandlung kurzer
Störungen.](../images/avoption_short_times.png){width="350"}
:::
::::

::: paragraph
Die Option [Short time Intervals]{.guihint} ist viel flexibler und
gleichzeitig sehr einfach. Sie legen schlicht eine Zeitdauer fest,
unterhalb derer Zustände nicht gewertet werden.
:::

::: paragraph
Nehmen Sie an, Sie setzen den Wert auf 2,5 Minuten (150 Sekunden). Ist
nun ein Service die ganze Zeit auf [OK]{.state0}, geht dann 2 Minuten
lang auf [CRIT]{.state2} und dann wieder auf [OK]{.state0}, so wird das
kurze [CRIT]{.state2}-Intervall einfach als [OK]{.state0} gewertet! Das
gilt allerdings auch umgekehrt! Ein kurzes [OK]{.state0} innerhalb einer
langen [WARN]{.state1}-Phase wird dann ebenfalls als [WARN]{.state1}
gewertet.
:::

::: paragraph
Allgemein gesagt, werden kurze Abschnitte, bei denen *vorher und nachher
der gleiche Zustand herrscht*, mit diesem gleichgesetzt. Bei einer
Abfolge [OK]{.state0}, dann 2 Minuten [WARN]{.state1}, dann
[CRIT]{.state2}, bleibt das [WARN]{.state1} bestehen, auch wenn dessen
Dauer unterhalb der eingestellten Zeit liegt!
:::

::: paragraph
Bedenken Sie beim Festlegen der Zeit das bei Checkmk übliche
Check-Intervall von einer Minute. Dadurch dauert jeder Zustand *etwa*
das Vielfache einer Minute. Da die Antwortzeiten der Agenten leicht
schwanken, können das auch leicht mal 61 oder 59 Sekunden sein. Daher
ist es sicherer, wenn Sie als Wert keine ganze Minutenzahl eintragen,
sondern einen Puffer einbauen (daher das Beispiel mit den 2,5 Minuten).
:::
::::::::::::

::::::::::::::: sect2
### []{#serviceperiod .hidden-anchor .sr-only}3.5. Einfluss von Zeitperioden {#heading_serviceperiod}

::: paragraph
Eine wichtige Funktion der Verfügbarkeitsberechnung in den kommerziellen
[Editionen](glossar.html#edition) von Checkmk ist, dass Sie diese
Berechnungen von [Zeitperioden](glossar.html#time_period) abhängig
machen können. Damit können Sie für jeden Host oder Service individuelle
Zeiten definieren. In diesen Zeiten wird der Host/Service als verfügbar
erwartet und der Zustand dann zur Auswertung genutzt. Dafür hat jedes
Objekt das Attribut [Service period]{.guihint}. Das Vorgehen ist wie
folgt:
:::

::: ulist
- Definieren Sie für Ihre Service-Zeiten eine Zeitperiode.

- Weisen Sie diese über den Regelsatz [Host & Service parameters \>
  Monitoring configuration \> Service period for hosts]{.guihint} bzw.
  [...​ for services]{.guihint} den Objekten zu.

- Aktivieren Sie die Änderungen.

- Nutzen Sie die Availability-Option [Service time]{.guihint}, um das
  Verhalten zu beeinflussen.
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Behandlung von Zeitperioden für
Services.](../images/avoption_service_time.png){width="350"}
:::
::::

::: paragraph
Hier gibt es drei einfache Möglichkeiten. Der Default [Base report only
on service times]{.guihint} blendet die Zeiten außerhalb der definierten
Service-Zeit komplett aus. Diese zählen damit auch nicht zu den 100
Prozent. Es werden nur die Zeiträume innerhalb der Service-Zeiten
betrachtet. In der Zeitleistendarstellung sind die übrigen Zeiten grau
dargestellt.
:::

::: paragraph
[Base report only on none-service times]{.guihint} macht das Gegenteil
und berechnet quasi die inverse Darstellung: Wie gut war die
Verfügbarkeit *außerhalb* der Service-Zeiten?
:::

::: paragraph
Und die dritte Option [Include both service and non-service
times]{.guihint} deaktiviert das ganze Konzept der Service-Zeiten und
zeigt die Auswertungen wieder für alle Zeiten von Montag bis Sonntag und
00:00 Uhr bis 24:00 Uhr.
:::

::: paragraph
Übrigens: Wenn ein Host nicht in der Service-Zeit ist, heißt das für
Checkmk *nicht* automatisch, dass das auch für die Services auf dem Host
gilt. Sie benötigen für Services immer eine eigene Regel in [Service
period for services]{.guihint}.
:::

:::::: sect3
#### []{#_der_benachrichtigungszeitraum .hidden-anchor .sr-only}Der Benachrichtigungszeitraum {#heading__der_benachrichtigungszeitraum}

:::: {.imageblock .inline-image}
::: content
![Option zur Behandlung eines
Benachrichtigungszeitraums.](../images/avoption_notification_period.png){width="350"}
:::
::::

::: paragraph
Es gibt übrigens noch eine etwas verwandte Option: [Notification
period]{.guihint}. Hier können Sie auch den *Benachrichtigungszeitraum*
für die Auswertung heranziehen. Dieser ist aber eigentlich nur dafür
gedacht, in bestimmten Zeiten keine Benachrichtigungen über Probleme zu
erzeugen und deckt sich nicht unbedingt mit der Service-Zeit. Die Option
wurde zu einer Zeit eingeführt, als die Software noch keine Service-Zeit
kannte und ist nur noch aus Kompatibilitätsgründen vorhanden. Sie
sollten Sie am besten nicht verwenden.
:::
::::::
:::::::::::::::

::::::::::: sect2
### []{#_begrenzung_der_berechnungszeit .hidden-anchor .sr-only}3.6. Begrenzung der Berechnungszeit {#heading__begrenzung_der_berechnungszeit}

::: paragraph
Bei der Berechnung der Verfügbarkeit muss die komplette Vergangenheit
der gewählten Objekte aufgerollt werden. Wie das im einzelnen geht,
erfahren Sie [weiter unten](#technical). Vor allem in
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** kann die Auswertung etwas Zeit beanspruchen, da dessen
Kern keinen Cache für die benötigten Daten hat und die textbasierten
Logdateien durchsucht werden müssen.
:::

::: paragraph
Damit eine allzu komplexe Anfrage --- die eventuell aus Versehen
aufgerufen wurden --- nicht über sehr lange Zeit einen Apache-Prozess
lahmlegt, die CPU übermäßig strapaziert und dabei „hängt", gibt es zwei
Optionen, welche die Dauer der Berechnung begrenzen. Beide sind per
Default aktiviert:
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Begrenzung des Zeitraums für die
Auswertung.](../images/avoption_query_time_limit.png){width="350"}
:::
::::

::: paragraph
Das [Query time limit]{.guihint} begrenzt die Dauer der
zugrundeliegenden Abfrage an den Monitoring-Kern auf eine bestimmte
Zeit. Diese ist auf eine halbe Minute voreingestellt. Wird diese
überschritten, wird die Auswertung abgebrochen und ein Fehler angezeigt.
Wenn Sie sicher sind, dass die Auswertung länger dauern darf, können Sie
dieses Timeout einfach hochsetzen.
:::

:::: {.imageblock .inline-image}
::: content
![Option zur Begrenzung der Datenmenge für die
Auswertung.](../images/avoption_limit_data.png){width="350"}
:::
::::

::: paragraph
Die Option [Limit processed data]{.guihint} schützt Sie vor Auswertungen
mit zu vielen Objekten. Hier wird ein Limit eingezogen, das analog zu
dem in den [Ansichten](views.html#limit) funktioniert. Wenn die Anfrage
an den Monitoring-Kern mehr als 5000 Zeitabschnitte liefern würde, wird
die Berechnung mit einer Warnung abgebrochen. Die Limitierung wird
bereits im Kern durchgeführt --- do wo die Daten beschafft werden.
:::
:::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::: sect1
## []{#bi .hidden-anchor .sr-only}4. Availability bei Business Intelligence {#heading_bi}

::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_grundprinzip_2 .hidden-anchor .sr-only}4.1. Grundprinzip {#heading__grundprinzip_2}

::: paragraph
Ein starkes Feature der Verfügbarkeitsberechnung von Checkmk ist die
Möglichkeit, die Verfügbarkeit von [BI-Aggregaten](bi.html) zu
berechnen. Ein Alleinstellungsmerkmal dabei ist, dass Checkmk dazu
*nachträglich* anhand des Verlaufs der einzelnen Zustände von Hosts und
Services Schritt für Schritt rekonstruiert, wie der Zustand des
jeweiligen Aggregats zu einem bestimmte Zeitpunkt genau war.
:::

::: paragraph
Warum der ganze Aufwand? Warum nicht einfach das BI-Aggregat mit einem
aktiven Check abfragen und dann dessen Verfügbarkeit anzeigen? Nun, der
Aufwand hat für Sie eine ganze Menge Vorteile:
:::

::: ulist
- Sie können den Aufbau von BI-Aggregaten nachträglich anpassen und die
  Verfügbarkeit dann neu berechnen lassen.

- Die Berechnung ist genauer, da nicht durch den aktiven Check eine
  Ungenauigkeit von +/- einer Minute entsteht.

- Sie haben eine exzellente Analysefunktion, mit der Sie nachträglich
  untersuchen können, was denn damals genau zu einem Ausfall geführt
  hat.

- Nicht zuletzt müssen Sie nicht extra einen Check einrichten.
:::
::::::

::::::::: sect2
### []{#_verfügbarkeit_aufrufen .hidden-anchor .sr-only}4.2. Verfügbarkeit aufrufen {#heading__verfügbarkeit_aufrufen}

::: paragraph
Das Aufrufen der Verfügbarkeitsansicht geht erst einmal analog zu den
Hosts und Services. Sie wählen eine Ansicht mit einem oder mehreren
BI-Aggregaten und wählen den Menüeintrag [BI Aggregations \>
Availability]{.guihint} aus. Es gibt aber hier noch einen zweiten Weg:
Jedes BI-Aggregat hat über das Symbol [![button
availability](../images/icons/button_availability.png)]{.image-inline}
einen direkten Weg zu dessen Verfügbarkeit:
:::

:::: imageblock
::: content
![BI-Tabellenansicht mit Symbol zum Aufruf der
Verfügbarkeit.](../images/avail_bi_icon.png)
:::
::::

::: paragraph
Die Auswertung an sich ist erst einmal analog zu der bei
Services --- allerdings ohne die Spalten [Host down]{.guihint} und
[flapping]{.guihint}, da es diese Zustände bei BI nicht gibt:
:::

:::: imageblock
::: content
![Tabellenansicht der Verfügbarkeit eines
BI-Aggregats.](../images/avail_bi_table.png)
:::
::::
:::::::::

::::::::: sect2
### []{#_die_zeitreise .hidden-anchor .sr-only}4.3. Die Zeitreise {#heading__die_zeitreise}

::: paragraph
Der große Unterschied kommt in der [![button
timeline](../images/icons/button_timeline.png)]{.image-inline}
Zeitleistenansicht. Folgendes Beispiel zeigt ein Aggregat von unserem
Demoserver, welches für einen sehr kurzen Abschnitt von gerade mal einer
Sekunde [CRIT]{.state2} war (das wäre eines gutes Beispiel für die
Option [Short time intervals]{.guihint}).
:::

:::: imageblock
::: content
![Tabellenansicht mit Zeitleiste der Zustandswechsel eines
BI-Aggregats.](../images/avail_bi_timeline.png)
:::
::::

::: paragraph
Wollen Sie wissen, was hier der Grund für den Ausfall war? Ein einfacher
Klick auf den [![button
timewarp](../images/icons/button_timewarp.png)]{.image-inline}
Zauberstab genügt. Er ermöglicht eine Zeitreise zu genau dem Zeitpunkt,
an dem der Ausfall auftrat und öffnet eine Darstellung des BI-Aggregats
zu jenem Zeitpunkt --- in der folgenden Abbildung bereits an der
richtigen Stelle aufgeklappt:
:::

:::: imageblock
::: content
![Timewarp eines BI-Aggregats.](../images/avail_bi_timewarp.png)
:::
::::
:::::::::
:::::::::::::::::::::
::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#_verfügbarkeit_in_berichten .hidden-anchor .sr-only}5. Verfügbarkeit in Berichten {#heading__verfügbarkeit_in_berichten}

::::::::::::::::: sectionbody
::: paragraph
Sie können Verfügbarkeitsansichten in [Berichte](reporting.html)
einbinden. Der einfachste Weg führt über [Export \> Add to
report]{.guihint} in der Menüleiste. Wählen Sie den Bericht aus, dem Sie
die Ansicht hinzufügen wollen und bestätigen Sie mit [Add to]{.guihint}.
:::

:::: imageblock
::: content
![Auswahl des Berichts zur Integration der
Verfügbarkeit.](../images/avail_addto.png)
:::
::::

::: paragraph
Das Berichtselement [Availability table]{.guihint} fügt in den Bericht
eine Verfügbarkeitsauswertung ein. Die ganzen oben genannten Optionen
finden Sie dabei direkt als Parameter des Elements --- wenn auch in
einer optisch etwas anderen Darstellung:
:::

:::: imageblock
::: content
![Optionen für die Darstellung der Verfügbarkeit im
Bericht.](../images/avail_reporting_options.png)
:::
::::

::: paragraph
Eine Besonderheit ist die allerletzte Option:
:::

:::: imageblock
::: content
![Die Option \'Elements to show\' in den
Darstellungsoptionen.](../images/avail_reporting_elements.png)
:::
::::

::: paragraph
Hier können Sie festlegen, welche Darstellung in den Bericht übernommen
werden soll:
:::

::: ulist
- Die Tabelle der Verfügbarkeiten

- Die grafische Darstellung der Zeitleiste

- Die detaillierte Zeitleiste mit den einzelnen Abschnitten
:::

::: paragraph
Anders als bei der normalen interaktiven Ansicht, können Sie also hier
im Bericht Tabelle und Zeitleiste *gleichzeitig* einbinden.
:::

::: paragraph
Eine zweite Besonderheit ist die fehlende Angabe für den
Auswertungszeitraum; sie fehlt hier, weil sie automatisch vom Bericht
vorgegeben wird.
:::

::: paragraph
Die Auswahl der Objekte wird wie bei allen Berichtselementen entweder
vom Bericht übernommen oder im Element direkt festgelegt.
:::
:::::::::::::::::
::::::::::::::::::

:::::::::::::::::::::::::::: sect1
## []{#technical .hidden-anchor .sr-only}6. Technische Hintergründe {#heading_technical}

::::::::::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#_wie_die_berechnung_funktioniert .hidden-anchor .sr-only}6.1. Wie die Berechnung funktioniert {#heading__wie_die_berechnung_funktioniert}

::: paragraph
Zur Berechnung der Verfügbarkeit greift Checkmk auf die
Monitoring-Historie zurück. Es orientiert sich dabei an den
*Zustandswechseln.* Wenn ein Service z.B. am 20.10.2021 um 17:14 Uhr auf
[CRIT]{.state2} geht und um 17:24 Uhr wieder auf [OK]{.state0}, dann
wissen Sie, dass er während dieser Zeitspanne 10 Minuten den Zustand
[CRIT]{.state2} hatte.
:::

::: paragraph
Diese Zustandswechsel sind in Form von Einträgen im Monitoring-Log
enthalten, haben den Typ `HOST ALERT` oder `SERVICE ALERT` und sehen
z.B. so aus:
:::

::::: listingblock
::: title
var/check_mk/core/history
:::

::: content
``` {.pygments .highlight}
[1634742874] SERVICE ALERT: mail.mydomain.com;Filesystem /var/spool;CRITICAL;HARD;1;CRIT - 95.9% used (206.96 of 215.81 GB), (warn/crit at 90.00/95.00%), trend: 0.00 B / 24 hours
```
:::
:::::

::: paragraph
Dabei gibt es immer eine aktuelle Logdatei, die die Einträge der letzten
Stunden oder Tage beinhaltet und ein Verzeichnis mit einem Archiv der
früheren Zeiträume. Der Ort ist je nach verwendetem Monitoring-Kern
unterschiedlich:
:::

+-------------+---------------------------+---------------------------+
| Kern        | aktuelle Datei            | ältere Dateien            |
+=============+===========================+===========================+
| [![C        | `var/log/nagios.log`      | `var/nagios/archive/`     |
| RE](../imag |                           |                           |
| es/icons/CR |                           |                           |
| E.png)]{.im |                           |                           |
| age-inline} |                           |                           |
| Nagios      |                           |                           |
+-------------+---------------------------+---------------------------+
| [![C        | `v                        | `v                        |
| EE](../imag | ar/check_mk/core/history` | ar/check_mk/core/archive` |
| es/icons/CE |                           |                           |
| E.png)]{.im |                           |                           |
| age-inline} |                           |                           |
| [CMC        |                           |                           |
| ](cmc.html) |                           |                           |
+-------------+---------------------------+---------------------------+

::: paragraph
Dabei greift die [Benutzeroberfläche](user_interface.html) nicht direkt
auf diese Dateien zu, sondern fragt sie mittels einer
[Livestatus](livestatus.html)-Abfrage vom Monitoring-Kern ab. Das ist
unter anderem wichtig, weil in einem [verteilten
Monitoring](distributed_monitoring.html) die Dateien mit der Historie
gar nicht auf dem gleichen System liegen wie die GUI.
:::

::: paragraph
Die Livestatus-Abfrage benutzt dabei die Tabelle `statehist`. Im
Gegensatz zur Tabelle `log`, welche einen „nackten" Zugriff auf die
Historie bietet, wird hier die Tabelle `statehist` verwendet, weil sie
bereits erste aufwendige Berechnungsschritte durchführt. Sie übernimmt
unter anderem das Zurücklaufen in die Vergangenheit zur Ermittlung des
Anfangszustands und das Berechnen von Zeitabschnitten gleichen Zustands
mit Anfang, Ende und Dauer.
:::

::: paragraph
Das Verdichten der Zustände nach dem am Anfang beschriebenen Schema
macht dann das Verfügbarkeitsmodul in der Benutzeroberfläche.
:::
::::::::::::

:::::::::::::::: sect2
### []{#_der_availability_cache_im_cmc .hidden-anchor .sr-only}6.2. Der Availability Cache im CMC {#heading__der_availability_cache_im_cmc}

:::::: sect3
#### []{#_funktionsweise_des_caches .hidden-anchor .sr-only}Funktionsweise des Caches {#heading__funktionsweise_des_caches}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Bei Anfragen, die
weit in die Vergangenheit zurückreichen, müssen entsprechend viele
Logdateien abgearbeitet werden. Das wirkt sich natürlich negativ auf die
Dauer der Berechnung aus. Aus dem Grund gibt es im Checkmk Micro Core
einen sehr effizienten Cache der Monitoring-Historie, welcher alle
wichtigen Informationen über die Zustandswechsel von Objekten bereits
direkt beim Start aus den Logdateien ermittelt, fest im RAM behält und
im laufenden Monitoring ständig aktualisiert. Folge ist, dass **alle**
Verfügbarkeitsanfragen direkt und sehr effizient aus dem RAM beantwortet
werden können und kein Dateizugriff mehr nötig ist.
:::

::: paragraph
Das Parsen der Logdateien ist sehr schnell und erreicht bei ausreichend
schnellen Platten bis zu 80 MB/s! Damit das Erstellen des Caches den
Start des Monitorings nicht verzögert, geschieht dies zudem
asynchron --- und zwar von der Gegenwart in Richtung Vergangenheit. Sie
werden also eine kurze Verzögerung lediglich dann feststellen, wenn Sie
*direkt nach dem Start* der Checkmk-Instanz sofort eine
Verfügbarkeitsanfrage über einen längeren Zeitraum machen. Dann kann es
sein, dass der Cache noch nicht weit genug in die Vergangenheit
zurückreicht und die GUI eine kleine Denkpause einlegen muss.
:::

::: paragraph
Bei einem [Activate changes]{.guihint} bleibt der Cache erhalten! Er
muss nur bei einem echten (Neu-)Start von Checkmk neu berechnet
werden --- z.B. nach einem Booten des Servers oder nach einem Update von
Checkmk.
:::
::::::

:::::: sect3
#### []{#_cache_statistik .hidden-anchor .sr-only}Cache-Statistik {#heading__cache_statistik}

::: paragraph
Wenn Sie neugierig sind, wie lange das Berechnen des Caches dauert,
finden Sie eine Statistik in der Logdatei `var/log/cmc.log`. Hier ist
ein Beispiel von einem kleineren Monitoring-System:
:::

:::: imageblock
::: content
![Statistik zur Berechnung des
Cache.](../images/avail_statehist_cache.png)
:::
::::
::::::

::::::: sect3
#### []{#_den_cache_justieren .hidden-anchor .sr-only}Den Cache justieren {#heading__den_cache_justieren}

::: paragraph
Um den Speicherbedarf des Caches in Grenzen zu halten, ist dieser auf
einen Horizont von 730 Tagen in die Vergangenheit limitiert. Dieses
Limit ist definitiv --- Anfragen, die weiter in die Vergangenheit gehen
sind somit nicht nur langsamer, sondern ganz unmöglich. Sie können das
mit der globalen Einstellung [Global Settings \> Monitoring Core \>
In-memory cache for availability data]{.guihint} leicht anpassen:
:::

:::: imageblock
::: content
![Globale Einstellungen zum Cache für die
Verfügbarkeit.](../images/avail_histcache.png)
:::
::::

::: paragraph
Neben dem Horizont für die Auswertung gibt es hier noch eine zweite
interessante Einstellung: [Ignore core restarts shorter
than...​]{.guihint}. Denn ein Neustart des Cores (z.B. zum Zwecke eines
Updates oder Server-Neustarts) führt ja faktisch zu Zeitabschnitten, die
als [unmonitored]{.guihint} gelten. Auszeiten von bis zu 30 Sekunden
werden dabei einfach ignoriert. Diese Zeit können Sie hier hochsetzen
und auch längere Zeiten einfach ausblenden. Die Verfügbarkeitsauswertung
geht dann davon aus, dass alle Hosts und Services den jeweils letzten
ermittelten Zustand die ganze Zeit beibehalten haben.
:::
:::::::
::::::::::::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `var/check_mk/core/history`       | Aktuelle Log-Datei der            |
|                                   | Monitoring-Historie beim CMC.     |
+-----------------------------------+-----------------------------------+
| `var/check_mk/core/archive/`      | Verzeichnis mit den älteren       |
|                                   | Log-Dateien der Historie.         |
+-----------------------------------+-----------------------------------+
| `var/log/cmc.log`                 | Logdatei des CMC, in dem die      |
|                                   | Statistik des Availability Caches |
|                                   | zu sehen ist.                     |
+-----------------------------------+-----------------------------------+
| `var/nagios/nagios.log`           | Aktuelle Log-Datei der            |
|                                   | Monitoring-Historie von Nagios.   |
+-----------------------------------+-----------------------------------+
| `var/nagios/archive/`             | Verzeichnis mit den älteren       |
|                                   | Log-Dateien bei Nagios.           |
+-----------------------------------+-----------------------------------+
| `var/chec                         | Hier werden die                   |
| k_mk/availability_annotations.mk` | [Anmerkungen](#annotations) und   |
|                                   | nachträglich angepassten          |
|                                   | Wartungszeiten zu Ausfällen       |
|                                   | gespeichert. Die Datei hat        |
|                                   | Python-Format und kann von Hand   |
|                                   | editiert werden.                  |
+-----------------------------------+-----------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
