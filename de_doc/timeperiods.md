:::: {#header}
# Zeitperioden (Time Periods)

::: details
[Last modified on 25-Jun-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/timeperiods.asciidoc){.edit-document}
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
[Die Konfiguration von Checkmk](wato.html)
[Wartungszeiten](basics_downtimes.html) [Regeln](wato_rules.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![alt](../images/timeperiods.png){symbol="" f="" zeitperioden.=""
width="107px"}
:::
::::

::: paragraph
Um das Monitoring an die Arbeitsrhythmen des Menschen anzupassen und so
z.B. sinnlose Benachrichtigungen zu vermeiden, bietet Checkmk die
Möglichkeit, verschiedene Einstellungen von Tageszeit oder Wochentag
abhängig zu machen.
:::

::: paragraph
Damit die Konfiguration einfach und übersichtlich ist, geschieht das in
zwei Schritten. Zunächst definieren Sie **Zeitperioden** (*time
periods*). Eine solche kann z.B. „Arbeitszeit" heißen und die Tage
Montag bis Freitag von jeweils 8:00 bis 17:00 Uhr enthalten. Jede der
Zeitperioden ist also zu einem bestimmten Zeitpunkt entweder aktiv oder
inaktiv.
:::

::: paragraph
Anschließend können Sie diese Zeitperioden in der Konfiguration
verwenden. Sie kommen unter anderem in den folgenden Regeln zum Einsatz.
[All diese Regeln](wato_rules.html) haben gemeinsam, dass die Angabe der
Zeitperiode optional ist und den zeitlichen Wirkungsbereich der Regeln
einschränkt:
:::

+--------------------+-------------------------------------------------+
| [Notification      | Einschränkung der Zeiten, in denen für einen    |
| period for         | Host oder Service eine                          |
| ...​]{.guihint}     | [Benachrichtigung](glossar.html#notification)   |
|                    | erzeugt wird. Außerhalb der definierten Zeiten  |
|                    | werden keine Benachrichtigungen erzeugt und die |
|                    | Kette der Benachrichtigungsregeln kommt gar     |
|                    | nicht erst zum Einsatz.                         |
+--------------------+-------------------------------------------------+
| Benac              | Auch in jeder einzelnen                         |
| hrichtigungsregeln | [Be                                             |
|                    | nachrichtigungsregel](notifications.html#rules) |
|                    | können Sie eine bestimmte Zeitperiode zur       |
|                    | Bedingung machen. So können Sie z.B. den        |
|                    | Benachrichtigungsweg (E-Mail oder SMS) von der  |
|                    | Tageszeit abhängig machen.                      |
+--------------------+-------------------------------------------------+
| [Check period for  | Damit können Sie die Ausführung von Checks      |
| ...​]{.guihint}     | zeitlich einschränken. Außerhalb der            |
|                    | definierten Zeitperiode werden die Checks nicht |
|                    | durchgeführt und der Status bleibt auf dem      |
|                    | Zustand der letzten Check-Ausführung. Verwenden |
|                    | Sie dies jedoch mit Vorsicht: Ein Service kann  |
|                    | als [OK]{.state0} angezeigt werden, obwohl er   |
|                    | schon seit Stunden eigentlich [CRIT]{.state2}   |
|                    | ist.                                            |
+--------------------+-------------------------------------------------+
| [Service period    | Mithilfe der Service-Periode können Sie die     |
| for ...​]{.guihint} | prozentualen Verfügbarkeiten von Services       |
|                    | innerhalb von bestimmten Zeiten berechnen.      |
+--------------------+-------------------------------------------------+
| Event Console      | Die Gültigkeit von Regeln in der [Event         |
|                    | Console](glossar.html#ec) kann abhängig von     |
|                    | einer Zeitperiode sein. Damit können Sie z.B.   |
|                    | bestimmte Log-Meldungen zu manchen Zeiten als   |
|                    | unproblematisch deklarieren.                    |
+--------------------+-------------------------------------------------+
| Alert Handler      | Auch die Ausführung von Regeln für [Alert       |
|                    | Handler](alert_handlers.html) kann durch        |
|                    | Zeitperioden gesteuert werden.                  |
+--------------------+-------------------------------------------------+
| Schwellwerte       | Sie können die Gültigkeit der Schwellwerte      |
|                    | bestimmter Checks an eine Zeitperiode knüpfen.  |
|                    | Damit könnten Sie z.B. die Schwellwerte für die |
|                    | CPU-Auslastung eines Servers tagsüber anders    |
|                    | einstellen als in der Nacht.                    |
+--------------------+-------------------------------------------------+

::: paragraph
**Tipp**: Die oben genannten konkreten Regeln können Sie leicht mit der
Suche [Setup \> General \> Rule search]{.guihint} finden.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::: sect1
## []{#_zeitperioden_konfigurieren .hidden-anchor .sr-only}2. Zeitperioden konfigurieren {#heading__zeitperioden_konfigurieren}

:::::::::::::::::::::::::: sectionbody
:::::::::: sect2
### []{#_wochentage .hidden-anchor .sr-only}2.1. Wochentage {#heading__wochentage}

::: paragraph
In die Verwaltung der Zeitperioden steigen Sie mit [Setup \> General \>
Time periods]{.guihint} ein. Die angezeigte Liste enthält die stets
vorhandene Zeitperiode [Always]{.guihint}, die nicht änder- oder
löschbar ist.
:::

::: paragraph
Klicken Sie [Add time period]{.guihint}, um eine neue Zeitperiode zu
erstellen.
:::

::: paragraph
Wie üblich in Checkmk, verlangt auch die Definition einer Zeitperiode
mindestens eine interne ID und einen Namen zur Anzeige
([Alias]{.guihint}). Nur letzterer kann später geändert werden und wird
in Listen etc. angezeigt:
:::

:::: imageblock
::: content
![Dialog zur Erstellung einer Zeitperiode für
Arbeitstage.](../images/timeperiods_create.png)
:::
::::

::: paragraph
Sie können wahlweise jeden einzelnen Wochentag konfigurieren oder über
[Same times for all weekdays]{.guihint} alle sieben Tage gleich setzen.
Für jeden Wochentag können Sie mehrere Zeiträume angeben, in denen die
Zeitperiode *aktiv* ist. Verwenden Sie dabei eine Notation im
24-Stunden-Format.
:::

::: paragraph
**Wichtig:** Um den kompletten Tag bis Mitternacht einzuschließen,
schreiben Sie `00:00` - `24:00`, auch wenn die Uhrzeit 24:00 ja
eigentlich nicht existiert.
:::
::::::::::

::::::: sect2
### []{#_einzelne_kalendertage .hidden-anchor .sr-only}2.2. Einzelne Kalendertage {#heading__einzelne_kalendertage}

::: paragraph
Mithilfe von [Add Exception]{.guihint} können Sie einzelne Kalendertage
im „internationalen Datumsformat" angeben, also im Format `YYYY-MM-DD`,
z.B. `2021-12-25`. An diesen Tagen gelten dann *nur* die dort
angegebenen Tageszeiten:
:::

:::: imageblock
::: content
![Dialog zur Erstellung einer Zeitperiode mit Ausnahmen für
Feiertage.](../images/timeperiods_exception.png)
:::
::::

::: paragraph
Auf diese Art können Sie sich z.B. einen individuellen Kalender von
Feiertagen zusammenstellen. Dabei geben Sie bei den erstellten
Feiertagen jeweils den Zeitraum `00:00` - `24:00` ein.
:::
:::::::

:::::: sect2
### []{#_zeitperioden_aus_anderen_ausschließen .hidden-anchor .sr-only}2.3. Zeitperioden aus anderen ausschließen {#heading__zeitperioden_aus_anderen_ausschließen}

::: paragraph
So einen Feiertagskalender können Sie dann aus einer anderen Zeitperiode
*ausklammern*. Der häufigste Fall ist das Ausklammern der Feiertage aus
einer Zeitperiode für die normalen Büroarbeitszeiten. Dazu kreuzen Sie
einfach Ihren Feiertagskalender bei [Exclude]{.guihint} an:
:::

:::: imageblock
::: content
![Dialog, in dem der Feiertagskalender als Ausnahme definiert
wird.](../images/timeperiods_holidays.png)
:::
::::
::::::

:::::::: sect2
### []{#_kalender_importieren .hidden-anchor .sr-only}2.4. Kalender importieren {#heading__kalender_importieren}

::: paragraph
Gerade für Ferien- und Feiertagskalender gibt es den praktischen Import
von Kalenderdateien im iCal-Format. Solche Dateien sind im Internet
leicht zu finden und ersparen Ihnen das mühsame Eingeben von Feiertagen
von Hand. Feiertage aller deutschen Bundesländer finden Sie z.B. auf der
[Ferienwiki
Website.](https://www.ferienwiki.de/exports/de){target="_blank"}
:::

::: paragraph
Importieren Sie so eine Datei auf der Seite [Time periods]{.guihint} mit
dem Knopf [![Symbol zum Import einer Datei im
iCal-Format.](../images/icons/icon_ical.png)]{.image-inline} [Import
iCalendar]{.guihint} und legen Sie auf der nächsten Seite fest, für wie
viele Jahre in die Zukunft periodische Feiertage in die Zeitperiode
eingetragen werden sollen:
:::

:::: imageblock
::: content
![Dialog zum Import einer Datei im
iCal-Format.](../images/timeperiods_ical.png)
:::
::::

::: paragraph
Sie erhalten dann eine ausgefüllte Zeitperiodendefinition, bei der Sie
nur noch ID und Name festlegen müssen und können diese dann wie oben
beschrieben aus anderen Zeitperioden ausschließen.
:::
::::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::
