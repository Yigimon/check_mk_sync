:::: {#header}
# Erweiterte Verfügbarkeiten (SLAs)

::: details
[Last modified on 10-Feb-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/sla.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Verfügbarkeit (Availability)](availability.html) [Ansichten von Hosts
und Services (Views)](views.html) [Regeln](wato_rules.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#_was_leisten_slas .hidden-anchor .sr-only}1.1. Was leisten SLAs? {#heading__was_leisten_slas}

::: paragraph
In Checkmk können Sie [Verfügbarkeiten](availability.html) auswerten und
für diese auch eine rudimentäre
[SLA-Auswertung](availability.html#thresholds) konfigurieren. Nun ist
die absolute Verfügbarkeit in einem Zeitraum nicht sonderlich
aussagekräftig. Dazu ein extremes Beispiel: Eine Verfügbarkeit von 99,9
Prozent würde weniger als 10 Stunden Downtime pro Jahr
zulassen --- genau genommen sogar nur 8 Stunden, 45 Minuten und 36
Sekunden. Verteilen sich diese auf etwas mehr als 43 Minuten pro Monat,
mag das für viele Systeme in Ordnung sein. Eine ganze Stunde Ausfall am
Stück würde dagegen enormen Schaden anrichten. Es ist naheliegend, dass
so ein Ausfall in der Beurteilung von Verfügbarkeit abgebildet sein
sollte.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie eine der
kommerziellen Editionen einsetzen, verfügt Checkmk über eine separate
Funktion für Service Level Agreements (SLA). Das SLA-Feature baut auf
den Verfügbarkeitsdaten auf und erlaubt nun eine wesentlich
detailliertere Auswertung.
:::

::: paragraph
Zwei unterschiedliche Anforderungen können umgesetzt werden:
:::

::: ulist
- Prozentsatz-SLA: Prozentsatz, zu dem ein Service-Zustand
  ([OK]{.state0}, [WARN]{.state1}, [CRIT]{.state2}, [UNKNOWN]{.state3})
  ober-/unterhalb eines vorgegebenen Werts liegt.

- Ausfall-SLA: Maximale Anzahl von Ausfällen, genauer der Zustand
  [CRIT]{.state2}, [WARN]{.state1}, [UNKNOWN]{.state3} einer gegebenen
  Dauer.
:::

::: paragraph
Sie können dabei mehrere Instanzen einer oder beider Anforderungen
kombinieren, um beispielsweise sicherzustellen, dass ein bestimmter
Service im Berichtszeitraum mindestens zu 90 Prozent [OK]{.state0} sein
muss und maximal zweimal für zwei oder mehr Minuten den Zustand
[CRIT]{.state2} annehmen darf.
:::

::: paragraph
Die Ergebnisse dieser Berechnungen lassen sich später auf zwei Varianten
in Tabellenansichten rendern:
:::

::: ulist
- Service-spezifisch: Zu einem Service wird sein zugeordnetes SLA
  angezeigt.

- Spalten-spezifisch: Zu jedem Service wird ein fixes SLA angezeigt.
:::

::: paragraph
Hier sehen Sie beispielsweise die Auswertung für ein Dateisystem in der
Übersicht: von heute (mit 3 Symbolen in der Spalte ganz rechts) und der
letzten 15 Tage davor --- und auch sofort, dass bis vor 4 Tagen
offensichtlich Probleme bestanden:
:::

::::: imageblock
::: content
![Eine Ansicht mit einem Service und der SLA-Information in der rechten
Spalte.](../images/sla_view_example_modern.png)
:::

::: title
Symbole in der SLA-Spalte zeigen den Zustand der verschiedenen
SLA-Perioden: ganz rechts wird die aktuelle angezeigt
:::
:::::

::: paragraph
Aber was bringen Ihnen diese Auswertungen nun? Zum einen können Sie die
Erfüllung oder Nichterfüllung abgeschlossener SLAs sehen und
beispielsweise gegenüber Kunden offenlegen. Zum anderen können Sie
bereits im Voraus eine drohende Nichterfüllung erkennen: Standardmäßig
geht die SLA-Anzeige auf [CRIT]{.state2}, sobald sie gebrochen wurde.
Sie lässt sich aber auch so einstellen, dass sie bereits auf
[CRIT]{.state2} geht, wenn zum Beispiel die erlaubten
[CRIT]{.state2}-Zustände des Services zu 80 Prozent aufgebraucht sind.
Und noch davor könnte sie auf [WARN]{.state1} wechseln.
:::

::: paragraph
Letztlich sind SLAs vor allem sehr detaillierte Ansichten, generiert aus
verrechneten Verfügbarkeitsdaten. Diese bekommen Sie später an zwei
Punkten zu sehen: In Tabellen, wahlweise zu allen dort aufgeführten
Hosts und Services, oder nur zu Services, die ganz konkret an einzelne
SLAs gebunden sind. Und zweitens gibt es zu jeder
Service-SLA-Kombination eine ausführliche Detailseite.
:::
::::::::::::::::

::::::::::: sect2
### []{#_funktionsweise .hidden-anchor .sr-only}1.2. Funktionsweise {#heading__funktionsweise}

::: paragraph
Datengrundlage für die SLA-Funktion sind die Verfügbarkeitsdaten. Die
Berechnungen zu den SLA-Vorgaben werden aber natürlich nicht auf den
gesamten Rohdatenbestand angewendet, schließlich sollen mit SLAs
Aussagen über bestimmte Zeiträume getroffen werden. Also wird zunächst
bestimmt, in welchem Zeitraum die SLA-Vorgaben erfüllt werden sollen,
die sogenannte „SLA-Periode". Etwa: „Der Service *MyService* soll
innerhalb eines Monats zu mindestens 90 Prozent [OK]{.state0} sein." Für
diese SLA-Periode werden auch nicht (zwangsläufig) alle Daten des Monats
aus einem 24/7-Betrieb genutzt. Die Daten können auf die im Setup
definierten [Zeitperioden](timeperiods.html), also etwa Arbeitszeiten,
begrenzt werden.
:::

::: paragraph
So ergibt sich dann eine konkretisierte Anforderung wie: „Der Service
*MyService* soll innerhalb eines Monats (SLA-Periode) während der
Arbeitszeiten (Zeitperiode), Montag bis Freitag von 10.00 bis 20.00 Uhr,
zu 90 Prozent [OK]{.state0} sein (SLA-Anforderung)." SLA- und
Zeitperiode ergänzen sich also, wobei letztere nicht eingeschränkt
werden muss: Selbstverständlich können Sie alle innerhalb einer
SLA-Periode angefallenen Monitoring-Daten verwenden.
:::

::: paragraph
Zusammengefasst: Sie benötigen zwei Perioden, um die Datenbasis für die
Berechnung einer SLA-Anforderung einzuschränken:
:::

::: ulist
- SLA-Periode: Der Zeitraum (z.B. wöchentlich), welcher in der SLA
  vereinbart wurde und die Grundlage für den Bericht darstellt.

- Zeitperiode: Eine aktive Zeitperiode aus der Setup-Konfiguration; etwa
  nur Werktage.
:::

::: paragraph
Für jede SLA-Periode bekommen Sie ein eigenständiges Resultat. Wie viele
dieser Einzelresultate Sie in einer Tabelle sehen, konfigurieren Sie
über eine [Ansicht.](views.html) So ließen sich zum Beispiel die letzten
fünf Wochen, beschränkt auf Werktage, als fünf einzelne SLA-Perioden
direkt an Hosts und Services anzeigen.
:::

::: paragraph
Wie üblich bei Checkmk, gibt es zwischen der Datenquelle
(SLA-Definition) und der Ausgabe (Ansicht) noch eine Regel, um SLAs
bestimmten Services zuordnen zu können --- ein Muss ist das aber nicht.
Und somit ergibt sich für SLAs in der Regel ein dreistufiger Ablauf,
sofern sie an bestimmte Services gebunden werden:
:::

::: {.olist .arabic}
1.  SLA definieren über [Customize \> Business reporting \> Service
    Level Agreements]{.guihint}.

2.  SLA per Regel [Setup \> Services \> Service monitoring rules \>
    Assign SLA definition to service]{.guihint} an Hosts/Services binden
    (optional).

3.  Ansichten für SLA erstellen beziehungsweise anpassen.
:::

::: paragraph
Im Folgenden sehen Sie, wie Sie ein einfaches SLA samt Ansicht
einrichten: Die Dateisysteme der Hosts `MyHost1` und `MyHost2` sollen im
Berichtszeitraum von einer Woche zu mindestens 90 Prozent [OK]{.state0}
sein (heißt hier im Beispiel maximal zu 80 Prozent belegt). Zusätzlich
dürfen sie maximal fünfmal für zwei oder mehr Minuten den Zustand
[WARN]{.state1} annehmen.
:::
:::::::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#setup_sla .hidden-anchor .sr-only}2. SLAs einrichten {#heading_setup_sla}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::::: sect2
### []{#create_sla .hidden-anchor .sr-only}2.1. SLA anlegen {#heading_create_sla}

::: paragraph
Zunächst legen Sie das eigentliche SLA an. Zur Konfiguration gelangen
Sie über [Customize \> Business reporting \> Service Level
Agreements]{.guihint} (diesen Menüeintrag sehen Sie übrigens nur im
[Show-more-Modus](intro_gui.html#show_less_more)):
:::

::::: imageblock
::: content
![Liste der Service Level Agreements (SLAs) mit Aktionsknopf zum
Erstellen eines SLAs.](../images/sla_main_page.png)
:::

::: title
In der Liste der Service Level Agreements (SLAs) finden Sie den
Aktionsknopf zum Erstellen eines SLAs
:::
:::::

::: paragraph
Legen Sie mit [![icon new](../images/icons/icon_new.png)]{.image-inline}
[New SLA]{.guihint} ein neues SLA an. Im Bereich [General
Properties]{.guihint} vergeben Sie zunächst eine eindeutige ID, hier
`MySLA`, sowie einen Titel, etwa `Filesystems`:
:::

::::: imageblock
::: content
![Dialog zur Festlegung der allgemeinen Eigenschaften eines
SLAs.](../images/sla_general_properties.png)
:::

::: title
Mit ID und Titel werden die allgemeinen Eigenschaften des SLAs
festgelegt
:::
:::::

::: paragraph
Unter [SLA settings]{.guihint} setzen Sie nun die [SLA period]{.guihint}
auf den gewünschten Zeitraum, wie zum Beispiel [Weekly]{.guihint}. Die
folgend aufgestellten Anforderungen gelten also immer für den Zeitraum
einer Woche.
:::

::: paragraph
Bevor Sie die eigentlichen Anforderungen aufstellen, können Sie aber
noch unter [Filtering and computation options]{.guihint} weitere
Einschränkungen und Optionen setzen, die für unser einfaches
Beispiel-SLA jedoch nicht benötigt werden:
:::

+----------------------+-----------------------------------------------+
| Option               | Erklärung                                     |
+======================+===============================================+
| [Scheduled           | Berücksichtigung von                          |
| Downtimes]{.guihint} | [Wartungszeiten.](basics_downtimes.html)      |
+----------------------+-----------------------------------------------+
| [Status              | Berücksichtigung von Flapping, Downtimes und  |
| Class                | Zeiten außerhalb der Monitoring-Zeiten.       |
| ification]{.guihint} |                                               |
+----------------------+-----------------------------------------------+
| [Service Status      | Umklassifizierung der Zustände.               |
| Grouping]{.guihint}  |                                               |
+----------------------+-----------------------------------------------+
| [Only show objects   | Nur Objekte mit gegebenen Ausfallraten        |
| with                 | anzeigen.                                     |
| outages]{.guihint}   |                                               |
+----------------------+-----------------------------------------------+
| [Host Status         | Berücksichtigung des Host-Zustands            |
| Grouping]{.guihint}  | [UNREACH]{.hstate2} als [UNREACH]{.hstate2},  |
|                      | [UP]{.hstate0} oder [DOWN]{.hstate1}.         |
+----------------------+-----------------------------------------------+
| [Service             | Berücksichtigung von                          |
| Time]{.guihint}      | [Serv                                         |
|                      | ice-Zeiten.](availability.html#serviceperiod) |
+----------------------+-----------------------------------------------+
| [Notification        | Berücksichtigung von                          |
| Period]{.guihint}    | Benachrichtigungsperioden.                    |
+----------------------+-----------------------------------------------+
| [Short Time          | Ignorieren von Intervallen unterhalb einer    |
| Intervals]{.guihint} | gegebenen Dauer, um kurzzeitige Störungen zu  |
|                      | ignorieren (ähnlich dem Konzept der [Soft     |
|                      | States](availability.html#softstates)).       |
+----------------------+-----------------------------------------------+
| [Phase               | Aufeinander folgende Berichtszeiträume trotz  |
| Merging]{.guihint}   | gleichem Zustand nicht verschmelzen.          |
+----------------------+-----------------------------------------------+
| [Query Time          | Begrenzung der Abfragezeit als Maßnahme gegen |
| Limit]{.guihint}     | langsam oder gar nicht antwortende Systeme.   |
+----------------------+-----------------------------------------------+
| [Limit processed     | Begrenzung der zu verarbeitenden Datenzeilen; |
| data]{.guihint}      | standardmäßig 5 000.                          |
+----------------------+-----------------------------------------------+

::: paragraph
Anschließend legen Sie die eigentlichen Anforderungen im Bereich [SLA
requirements]{.guihint} mit [Add new timeperiod]{.guihint} fest. Sofern
Sie [Zeitperioden](timeperiods.html) festgelegt haben, können diese auch
bei den SLAs eingesetzt werden, wie bereits für die [allgemeine
Verfügbarkeit](availability.html#serviceperiod) erwähnt. Wählen Sie dazu
unter [Active in timeperiod]{.guihint} eine Zeitperiode aus oder hier im
Beispiel `24X7 - Always`, um die Anforderungen an einen 24/7-Betrieb zu
stellen. Vergeben Sie unter [Title]{.guihint} einen sprechenden Namen,
hier etwa `90 percent OK`:
:::

::::: imageblock
::: content
![Dialog zur Festlegung der ersten
SLA-Anforderung.](../images/sla_settings_requirements_percentage.png)
:::

::: title
Die erste Anforderung wird als Prozentsatz-SLA definiert
:::
:::::

::: paragraph
Bei [Computation Type]{.guihint} wählen Sie für **die erste
Anforderung** [Service state percentage]{.guihint} und fügen über [Add
state configuration]{.guihint} ein neues Kriterium hinzu. Es öffnet sich
ein neuer Absatz für das [Monitoring state requirement]{.guihint}. Um
mindestens 90 Prozent Verfügbarkeit zu verlangen, setzen Sie hier den
Datensatz auf [OK]{.guihint}, [Minimum]{.guihint}, [90]{.guihint}. Wird
dieser Wert unterschritten, gilt das SLA als *broken* und nimmt den
Zustand [CRIT]{.state2} an, wie Sie später auf der Ergebnisseite sehen
werden.
:::

::: paragraph
Vielleicht soll das SLA aber nicht erst auf [CRIT]{.state2} gehen, wenn
es gebrochen wurde, sondern bereits auf [WARN]{.state1}, sobald 50
Prozent des Puffers verbraucht sind, und auf [CRIT]{.state2}, wenn noch
10 Prozent Puffer übrig sind. Das eigentliche Brechen des SLA würde dann
zwar den Hinweis [broken]{.guihint} erzeugen, aber keine weitere
Zustandsänderung (mehr dazu unten im Abschnitt
[SLA-Detailseite](#sla_detail_page)). Für eine solche Konfiguration
aktivieren Sie das Kästchen bei [Levels for SLA monitoring]{.guihint}:
Hier können Sie Restwerte für den Übergang nach [WARN]{.state1} und
[CRIT]{.state2} eingeben. Damit sind Sie mit der ersten Anforderung
fertig.
:::

::: paragraph
Fügen Sie nun eine **zweite Anforderung** mit [Add new
timeperiod]{.guihint} hinzu. Bestimmen Sie wieder die Zeitperiode,
vergeben Sie als Namen bei [Title]{.guihint} zum Beispiel
`Max 5 warnings a 2 minutes` und setzen Sie den [Computation
Type]{.guihint} dieses Mal auf [Maximum number of service
outages]{.guihint}. Die eigentliche Anforderung lautet dann: [Maximum 5
times WARN with duration 0 days 0 hours 2 mins 0 secs]{.guihint}:
:::

::::: imageblock
::: content
![Dialog zur Festlegung der zweiten
SLA-Anforderung.](../images/sla_settings_requirements_outages.png)
:::

::: title
Die zweite Anforderung wird als Ausfall-SLA definiert
:::
:::::

::: paragraph
Der Service darf laut SLA nun also maximal fünfmal pro SLA-Periode für
ein Maximum von zwei Minuten den angegeben Zustand haben, ohne dass das
SLA gebrochen wird. Statt [WARN]{.state1} könnte an dieser Stelle
natürlich auch ein anderer Zustand genommen werden. Und auch hier dürfen
Sie wieder über die [Levels for SLA monitoring]{.guihint} verfeinern und
bestimmen, bei wie vielen verbleibenden Vorfällen vor dem Brechen des
SLA Sie mit einem [WARN]{.state1} beziehungsweise [CRIT]{.state2}
gewarnt werden.
:::

::: paragraph
Wie bereits erwähnt, können Sie weitere solcher Anforderungen hinzufügen
und somit detaillierte SLAs stricken. Noch gibt es aber keinerlei
Services, die auf dieses SLA „reagieren" --- für unser Beispiel muss
eine Regel her und diese Verbindung herstellen. Wie Sie die bis hierher
erstellte Konfiguration ohne solch eine SLA-Service-Verbindung nutzen,
lesen Sie weiter unten unter [Spalten-spezifische
SLA-Anzeige.](#sla_column)
:::
:::::::::::::::::::::::::

:::::::::::: sect2
### []{#link_sla_service .hidden-anchor .sr-only}2.2. SLA an Service binden {#heading_link_sla_service}

::: paragraph
Das Anbinden eines SLA an einen Service erledigen Sie mit dem Regelsatz
[Setup \> Services \> Service monitoring rules \> Assign SLA definition
to service.]{.guihint} Erstellen Sie eine Regel, aktivieren Sie die
einzige regelspezifische Option [Assign SLA to service]{.guihint} und
wählen Sie dann Ihre SLA-Definition `MySLA`, die hier über ihren Titel
`Filesystems` aufgeführt wird:
:::

::::: imageblock
::: content
![Regel zur Auswahl des SLAs für den
Service.](../images/sla_rule_assign_sla.png)
:::

::: title
Das zuvor erstellte SLA wird in der Liste zur Auswahl angeboten
:::
:::::

::: paragraph
Anschließend setzen Sie unter [Conditions]{.guihint} im Bereich
[Services]{.guihint} noch Filter für die gewünschten Services. Wie immer
können Sie hier mit [regulären Ausdrücken](regexes.html) arbeiten und
die SLA-Definition wie in diesem Beispiel per `Filesystem`{.guihint} an
alle lokalen Dateisysteme knüpfen. Optional dürfen Sie das Ganze noch
über die regeltypischen Filter für Ordner, Host-Merkmale und explizite
Hosts einschränken; für das Beispiel handelt es sich um die Hosts
`MyHost1` und `MyHost2`:
:::

::::: imageblock
::: content
![Bedingung zur Service-Auswahl für den
SLA.](../images/sla_rule_condition.png)
:::

::: title
Die Dateisystem-Services werden dem SLA zugewiesen
:::
:::::

::: paragraph
Natürlich könnten Sie an dieser Stelle auch auf jegliche Angabe von
Service-Filtern verzichten, um das SLA an alle Services zu binden. Wie
und warum Sie das besser über eine Ansicht mit Spalten-spezifischer
SLA-Anzeige erledigen, sehen Sie [weiter unten.](#sla_column)
:::
::::::::::::

:::::::::::::::::::::::::: sect2
### []{#_sla_in_ansicht_einbinden .hidden-anchor .sr-only}2.3. SLA in Ansicht einbinden {#heading__sla_in_ansicht_einbinden}

::: paragraph
Sie haben nun also die SLA-Definition `MySLA` erstellt und an alle
Services der beiden Hosts gebunden, die mit `Filesystem` beginnen. Jetzt
erstellen Sie noch eine [neue Ansicht](views.html#new) für die SLAs. Für
das SLA-Beispiel soll eine simple Ansicht für die beiden Hosts mit den
Dateisystem-Services und den SLAs genügen. Zur Verdeutlichung kommen
noch die Checkmk-Services hinzu, an die eben kein SLA gebunden ist. Das
Ergebnis wird dann so aussehen wie das [Bild am Ende dieses
Kapitels.](#image_sla_view)
:::

::: paragraph
Erstellen Sie über [Customize \> Visualization \> Views \> Add
view]{.guihint} eine neue Ansicht. In der ersten Abfrage geben Sie [All
services]{.guihint} als [Datasource]{.guihint} an. Die folgende Abfrage,
ob Informationen eines einzelnen Objekts gezeigt werden sollen,
bestätigen Sie mit dem Standardwert [No restrictions to specific
objects.]{.guihint}
:::

::: paragraph
Geben Sie unter [General Properties]{.guihint} eine ID ein (hier
`MySLAView_Demo`), einen Titel (etwa `My SLA Demo View`), und wählen Sie
letztlich noch ein Thema aus wie [Workplace]{.guihint}, wenn Sie später
die SLA-Ansichten unter einem eigenen Eintrag im
[Monitor-Menü](user_interface.html#monitor_menu) sehen möchten.
Sämtliche sonstigen Werte können Sie für den Test unverändert lassen.
:::

::: paragraph
Navigieren Sie nun zum Kasten [Columns]{.guihint} und fügen Sie initial
über [Add column]{.guihint} die drei allgemeinen Spalten [Services:
Service state]{.guihint}, [Hosts: Hostname]{.guihint} und [Services:
Service description]{.guihint} hinzu, um eine Basis für die Ansicht zu
haben.
:::

::: paragraph
In der Spaltenauswahl finden Sie auch zwei SLA-spezifische Spalten:
[Hosts/Services: SLA - Service specific]{.guihint} und [Hosts/Services:
SLA - Column specific.]{.guihint} Letztere ist die oben erwähnte bessere
Alternative, um *eine fixe* SLA-Definition zu jedem Service der Ansicht
anzeigen zu lassen. Dazu [später](#sla_column) mehr.
:::

::: paragraph
Fügen Sie an dieser Stelle die Spalte [Hosts/Services: SLA - Service
specific]{.guihint} hinzu. Hier bekommen Sie nun allerhand Optionen für
die Darstellung der SLA-Ergebnisse:
:::

::::: imageblock
::: content
![SLA-Darstellungsoptionen bei der Erstellung der
Ansicht.](../images/sla_view_options.png)
:::

::: title
Allerlei Optionen für die SLA-Darstellung in der Ansicht
:::
:::::

::: paragraph
[SLA timerange]{.guihint}: Damit bestimmen Sie den Zeitraum, für den Sie
SLA-Ergebnisse sehen wollen. Wenn Sie beispielsweise den
Berichtszeitraum [Monthly]{.guihint} in Ihrer SLA-Definition gewählt
haben und hier [Last Year]{.guihint} festlegen, bekommen Sie zwölf
einzelne Resultate. Hier im Beispiel kommt die Option [SLA period
range]{.guihint} zum Einsatz, über die die Anzahl der angezeigten
Berichtszeiträume direkt gesetzt werden kann: Für fünf
Zeiträume/Ergebnisse setzen Sie [Starting from period number]{.guihint}
auf `0` und [Looking back]{.guihint} auf `4`.
:::

::: paragraph
[Layout options]{.guihint}: Standardmäßig steht diese Option auf [Only
display SLA Name]{.guihint}. Um tatsächlich die Ergebnisse der SLAs zu
sehen, wählen Sie hier [Display SLA statistics]{.guihint}. Damit können
Sie bis zu drei unterschiedliche Elemente auswählen:
:::

::: ulist
- [Display SLA subresults for each requirement]{.guihint} zeigt jedes
  betroffene SLA mit Namen in einer eigenen Zeile an.

- [Display a summary for each SLA period]{.guihint} zeigt eine grafische
  Zusammenfassung in der Zeile [Aggregated result.]{.guihint}

- [Display a summary over all SLA periods]{.guihint}: Zeigt eine
  textliche, prozentuale Zusammenfassung über alle SLAs in der Zeile
  [Summary.]{.guihint}
:::

::: paragraph
Für das laufende Beispiel aktivieren Sie alle drei Optionen.
:::

::: paragraph
[Generic plugin display options]{.guihint}: An dieser Stelle legen Sie
für die Anzeige von *Ausfall-/Prozentsatz-SLAs* jeweils fest, ob
Zusammenfassungen (Texte) oder Einzelergebnisse (Symbole) der
Berichtszeiträume erscheinen. Um beides in Aktion zu sehen, belassen Sie
die Option für die prozentualen SLAs auf [Show separate result for each
SLA period]{.guihint} und wählen Sie unter [Service outage count display
options]{.guihint} den Eintrag [Show aggregated info over all SLA
periods]{.guihint}.
:::

::: paragraph
Wenn Sie die Ansicht nach einzelnen Hosts gruppieren wollen, fügen Sie
unter [Grouping]{.guihint} die Spalte [Hosts: Hostname]{.guihint}
hinzu --- das sorgt für eine optische Trennung der Hosts.
:::

::: paragraph
Da die Ansicht nur die Hosts `MyHost1` und `MyHost2` zeigen soll, müssen
Sie im letzten Schritt noch unter [Context / Search Filters]{.guihint}
einen Filter unter [Host]{.guihint} für [Hostname]{.guihint} setzen:
`MyHost1|MyHost2`. Für eine etwas übersichtlichere Beispielansicht
können Sie noch einen Filter unter [Service]{.guihint} setzen,
beispielsweise `filesystem.*|Check_MK.*`. So bekommen Sie dann die per
SLA überwachten Dateisystem-Services und als nicht überwachtes
Gegenstück die Checkmk-Services --- so wird der Effekt der
Service-spezifischen SLA-Anzeige einfach deutlicher.
:::

::::: imageblock
::: content
![Filter mit der Auswahl der Hosts und Services für die
Ansicht.](../images/sla_view_context.png)
:::

::: title
Die Ansicht wird auf die interessierenden Hosts und Services
eingeschränkt
:::
:::::

::: paragraph
Damit ist die Einrichtung der Ansicht abgeschlossen. Nach Auswahl im
[Monitor]{.guihint}-Menü bekommen Sie als Ergebnis eine Ansicht mit fünf
Statussymbolen als Einzelresultate des Prozentsatz-SLAs und dazu eine
Zusammenfassung als Prozentsatz für das Ausfall-SLA --- natürlich nur in
den Zeilen der Dateisystem-Services, die Checkmk-Zeilen bleiben leer.
:::

::::: {#image_sla_view .imageblock}
::: content
![Die Ansicht im Monitoring zeigt zwei Services mit
SLA-Informationen.](../images/sla_view.png)
:::

::: title
Die Ansicht im Monitoring zeigt pro Host je einen Service mit und einen
ohne SLA-Informationen
:::
:::::
::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#more_sla_views .hidden-anchor .sr-only}3. Weitere Ansichten {#heading_more_sla_views}

:::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#sla_column .hidden-anchor .sr-only}3.1. Spalten-spezifische SLA-Anzeige {#heading_sla_column}

::: paragraph
Die Service-spezifische Ansicht hat einen Nachteil: Sie können zwar
mehrere Regeln erstellen, die ein und demselben Service unterschiedliche
SLAs zuordnen, anzeigen können Sie aber nur das SLA, das mit der ersten
dieser Regeln zugeordnet wird. Es gibt keine Möglichkeit, das SLA einer
zweiten greifenden Regel in einer zweiten Spalte darzustellen.
:::

::: paragraph
Sie können aber sehr wohl mehrere Spalten mit unterschiedlichen fix
angegebenen SLAs einblenden. Nützlich sind solche Spalten-spezifischen
Ansichten zum Beispiel, wenn Sie mehrere SLAs benötigen, die für alle
Services einiger oder aller Hosts gelten sollen. So ließen sich etwa
Gold-, Silber- und Bronze-SLAs definieren, die jeweils in einer eigenen
Spalte neben den Services eines Hosts angezeigt werden. Somit wäre auf
einen Blick klar, welchen SLA-Definitionen ein Service/Host genügt. Kurz
gesagt: Über die Spalten-spezifische Ansicht können Sie zu Services mehr
als nur ein SLA anzeigen lassen.
:::

::: paragraph
In dem [oben](#setup_sla) fertiggestellten Beispiel wurden die eingangs
erwähnten drei Schritte abgearbeitet --- SLA erstellen, an Service
binden, in Ansicht einbauen. Für Spalten-spezifische Ansichten können
Sie den zweiten Schritt einfach auslassen. Erstellen Sie nur das SLA und
ordnen Sie einer Ansicht die Spalte [Hosts/Services: SLA - Column
specific]{.guihint} zu. Die SLA-Ergebnisse werden dann eben unabhängig
vom jeweiligen Service in jeder Zeile angezeigt.
:::

::: paragraph
Im folgenden Bild sehen Sie die [obige SLA-Ansicht](#image_sla_view) für
`MyHost1` mit einer zusätzlichen Spalte, die für jeden Service
SLA-Ergebnisse (maximal drei Ausfälle der Checkmk-Services) anzeigt:
:::

::::: imageblock
::: content
![Die Ansicht mit einer zusätzlichen SLA-Spalte für alle
Services.](../images/sla_view_columnspecific.png)
:::

::: title
Die Ansicht mit einer neuen SLA-Spalte für jeden Service
:::
:::::

::: paragraph
So ist der Unterschied zwischen Service- und Spalten-spezifischer
Anzeige klar zu erkennen. Was ebenfalls klar werden sollte: Das speziell
auf die Checkmk-Services ausgelegte SLA ergibt in den
Dateisystem-Spalten natürlich nur mäßig Sinn. Es lohnt sich also
gründlich zu planen, bevor es an die Umsetzung geht!
:::

::: paragraph
Noch ein kleiner **Hinweis:** Bei den Optionen der Service-spezifischen
Ansicht haben Sie oben unter [Generic plugin display options]{.guihint}
die Einstellungen für Ausfall- und Prozentsatz-SLAs gesehen. Bei den
Optionen der Spalten-spezifischen Ansichten sehen Sie diese beiden
ebenfalls --- aber nur, wenn das SLA auch tatsächlich Ausfall- und
prozentuale Kriterien beinhaltet. Hier wird eben nicht *generisch* die
passende, sondern *statisch* eine fixe SLA-Definition aufgerufen. Also
sehen Sie auch nur die Optionen, die zu diesem einen SLA gehören.
:::

::: paragraph
Es gibt viele Möglichkeiten, SLAs, Services und Ansichten
zusammenzubringen --- hier ist gute Planung gefragt, was genau Sie über
SLAs abbilden möchten.
:::
:::::::::::::

:::::::::::::::::::: sect2
### []{#sla_detail_page .hidden-anchor .sr-only}3.2. SLA-Detailseite {#heading_sla_detail_page}

::: paragraph
Das Einbinden der SLA-Informationen in Tabellen bietet eine schnelle
Übersicht, aber natürlich können Sie die Ergebnisse auch im Einzelnen
betrachten. In einer Ansicht bringt Sie ein Klick auf die Zelle mit den
SLA-Daten direkt zur Detailseite der SLA-Ergebnisse des betroffenen
Services:
:::

::::: imageblock
::: content
![SLA-Detailseite nach Auswahl eines
Services.](../images/sla_view_details_bars.png)
:::

::: title
Die Details werden nach Anklicken einer Tabellenzelle mit
SLA-Informationen angezeigt
:::
:::::

::: paragraph
Hier finden Sie vier unterschiedliche Informationen:
:::

::: ulist
- Rohdaten der Verfügbarkeit,

- Zusammenfassung aller Anforderungen eines SLA,

- Einzelergebnisse aller Anforderungen eines SLA und

- die SLA-Spezifikation.
:::

::: paragraph
[General information]{.guihint}: Hier sehen Sie die Rohdaten der
Verfügbarkeit, und somit der SLA-Berechnungen, als Übersicht mit Zustand
der einzelnen Perioden und darunter die aggregierten Resultate der
SLA-Anforderungen.
:::

::: paragraph
Anschließend folgen Tabellen für jede einzelne SLA-Anforderung. Die
Zeitleiste ([Timeline]{.guihint}) zeigt jeden einzelnen Zustand und die
Zeile [Result]{.guihint} die Ergebnisse für jeden einzelnen
Berichtszeitraum. Eine Besonderheit hier: Wenn Sie, wie im Beispiel
beschrieben, die SLA-Levels gesetzt haben und das SLA noch vor dem
Brechen auf [CRIT]{.state2} geht, wird das hier über einen orangen und
nicht über den sonst üblichen roten Balken angezeigt. Rot werden die
Balken dann beim Brechen des SLA. Sobald Sie den Mauszeiger auf den
Ergebnisbalken ziehen, sehen Sie per Tooltipp auch gleich die einzelnen
Ereignisse, die für den Zustand verantwortlich sind. Im folgenden Bild
ist der Zustand [WARN]{.state1}, weil nur noch zwei von drei erlaubten
Ausfällen übrig sind:
:::

::::: imageblock
::: content
![Tooltipp einer Ergebniszeile auf der
SLA-Detailseite.](../images/sla_view_details_result.png)
:::

::: title
Ein Tooltipp zeigt genaue Informationen zu der Ergebniszeile
:::
:::::

::: paragraph
Auch die Meldung [SLA broken]{.guihint} würde in diesem Tooltipp
erscheinen.
:::

::: paragraph
Ein kleiner Hinweis zur Nutzung der Ansicht: Wenn Sie mit der Maus über
den Ergebnisbalken [Aggregated results]{.guihint} oder
[Result]{.guihint} einer Periode fahren, wird diese Periode
hervorgehoben --- bei allen einzelnen Anforderungen und auch der
Zusammenfassung unter [General information]{.guihint}. Per Klick können
Sie eine oder mehrere Perioden markieren oder eine Markierung auch
wieder aufheben.
:::

::: paragraph
Zum Schluss folgen unter [SLA specification]{.guihint} noch die
Konfigurationsdaten Ihres SLA, mithilfe derer Sie die präsentierten
Ergebnisse besser auswerten und nachvollziehen können:
:::

::::: imageblock
::: content
![Die SLA-Spezifikation für den in der Ansicht ausgewählten
Service.](../images/sla_view_details_spec.png)
:::

::: title
Die komplette Spezifikation, die für die SLA-Ergebnisse des Services
ausgewertet wird
:::
:::::
::::::::::::::::::::

:::::::::::: sect2
### []{#slas_for_bi .hidden-anchor .sr-only}3.3. SLAs für BI-Aggregate {#heading_slas_for_bi}

::: paragraph
Im [Artikel zur Verfügbarkeit](availability.html#bi) haben Sie erfahren,
wie die Verfügbarkeit für BI-Aggregate genutzt wird. Und auch die SLAs
stehen den Aggregaten (der obersten Ebene) zur Verfügung --- über einen
kleinen Umweg: Der Zustand eines BI-Aggregats kann über den Regelsatz
[Check State of BI Aggregation]{.guihint} als ganz normaler Service
überwacht werden. Dieser erscheint dann beispielsweise als [Aggr My Bi
Rule Top Level]{.guihint} in den Ansichten und kann wiederum über die
bereits [oben](#link_sla_service) genutzte Regel [Assign SLA definition
to service]{.guihint} mit einem SLA verknüpft werden. Im Ergebnis sieht
das dann etwa so aus:
:::

::::: imageblock
::: content
![Eine Ansicht mit den SLA-Informationen eines
BI-Aggregats.](../images/sla_view_bi.png){width="97%"}
:::

::: title
Der Service zeigt die SLA-Informationen eines BI-Aggregats
:::
:::::

::: paragraph
Sie finden die Regel unter [Setup \> Services \> Other services \> Check
State of BI Aggregation]{.guihint} und eine Beschreibung des Regelsatzes
im [BI-Artikel.](bi.html#biasservice) Die Regel ist darauf ausgelegt,
BI-Aggregate auch auf entfernten Checkmk-Servern abzufragen. Daher
müssen Sie hier für die Verbindung die URL zum Server und einen
[Automationsbenutzer](wato_user.html#automation) angeben --- und
natürlich das gewünschte BI-Aggregat: Im Feld [Aggregation
Name]{.guihint} tragen Sie den Titel einer Top-Level-Regel aus Ihrem
BI-Paket ein, im folgenden Beispiel die Regel mit dem Titel [My BI Rule
Top Level]{.guihint}:
:::

::::: imageblock
::: content
![Liste von BI-Regeln zur Auswahl einer
Top-Level-Regel.](../images/sla_bi_rules.png)
:::

::: title
Aus der BI-Regelliste können Sie den Titel der Top-Level-Regel ablesen
:::
:::::

::: paragraph
**Hinweis:** Hier besteht **Verwechslungsgefahr**: In der
BI-Konfiguration erstellen Sie die eigentliche Aggregation, also die
Logik, über Regeln --- und eine der obersten Regeln wird hier über ihren
Titel als [Aggregation Name]{.guihint} eingetragen.
:::
::::::::::::
::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

::::::::::::: sect1
## []{#_fehlerbehebung .hidden-anchor .sr-only}4. Fehlerbehebung {#heading__fehlerbehebung}

:::::::::::: sectionbody
:::::: sect2
### []{#_fehlerhafte_oder_keine_funktion .hidden-anchor .sr-only}4.1. Fehlerhafte oder keine Funktion {#heading__fehlerhafte_oder_keine_funktion}

::: paragraph
In der Praxis sind SLAs ein Zusammenspiel aus allerlei unterschiedlichen
Konfigurationen: Das SLA selbst, Ansichts- und Service-Optionen,
Zeitperioden, Regeln und natürlich Verfügbarkeitsdaten. Zeigt das SLA
andere Ergebnisse als erwartet, gehen Sie einfach die komplette Kette
durch. Im Zweifelsfall hilft es auch, den gesamten Prozess einmal mit
Stift und Papier zu visualisieren, um alle beteiligten Informationen auf
einen Blick zu sehen. Folgende Punkte können Sie dabei als kleine
Checkliste verwenden:
:::

::: ulist
- [Zeitperioden](timeperiods.html): [Setup \> General \> Time
  periods]{.guihint}

- [Wartungszeiten](basics_downtimes.html): [Setup \> Hosts \> Host
  monitoring rules \> Recurring downtimes for hosts]{.guihint} und
  [Setup \> Services \> Service monitoring rules \> Recurring downtimes
  for services]{.guihint} (beide Regeln nur in den kommerziellen
  Editionen)

- Service-Zeiten: [Setup \> Hosts \> Host monitoring rules \> Service
  period for hosts]{.guihint} und [Setup \> Services \> Service
  monitoring rules \> Service period for services]{.guihint}

- Service-Konfiguration: [Setup \> Services \> Service monitoring rules
  \> MyService]{.guihint}

- SLA-Konfiguration: [Customize \> Business reporting \> Service Level
  Agreements]{.guihint}

- SLA-Service-Verknüpfung: [Setup \> Services \> Service monitoring
  rules \> Assign SLA definition to service]{.guihint}

- Konfiguration der Ansichten: [Customize \> Visualization \>
  Views]{.guihint}

- BI-Konfiguration: [Setup \> Business Intelligence \> Business
  Intelligence \> MyBiPack \> MyTopLevelRule]{.guihint}

- BI-Überwachung: [Setup \> Services \> Other services \> Check State of
  BI Aggregation]{.guihint}
:::

::: paragraph
Nachdem Sie die Konfigurationen geprüft haben, können Sie die Funktion
des SLA über manuelle (gefälschte) Zustandsänderungen und Wartungszeiten
prüfen, indem Sie [Kommandos](commands.html) auf die Objekte einer
Ansicht anwenden.
:::
::::::

::::: sect2
### []{#_sla_wird_nicht_angezeigt .hidden-anchor .sr-only}4.2. SLA wird nicht angezeigt {#heading__sla_wird_nicht_angezeigt}

::: paragraph
Öffnen Sie in so einem Fall die Einstellungen der betroffenen Ansicht
und überprüfen Sie zunächst das Offensichtliche: Gibt es überhaupt eine
Spalte mit einem SLA? Wahrscheinlicher sind aber widersprüchliche
Filter: Wenn Sie das SLA mit einer Regel an einen Service gebunden
haben, darf dieser Service in den Ansichtsoptionen unter [Context /
Search Filters]{.guihint} natürlich nicht ausgeschlossen werden.
:::

::: paragraph
An Services gebundene SLAs bieten noch eine Fehlerquelle: Wie oben
beschrieben, können Sie in einer Ansicht zu jedem Service nur ein per
Regel verknüpftes SLA anzeigen lassen --- und zwar das der ersten
passenden Regel. Die Ansicht bekommt schließlich nur die Anweisung, in
jeder Zeile das mit dem Service verbundene SLA anzuzeigen, und nicht das
zweite oder fünfte verbundene SLA. Sofern Sie entsprechende Regeln
angelegt haben, werden sie schlicht ignoriert. In solchen Fällen können
Sie zur [Spalten-spezifische Anzeige](#sla_column) wechseln.
:::
:::::

:::: sect2
### []{#_sla_zustandsänderung_wird_nicht_angezeigt .hidden-anchor .sr-only}4.3. SLA-Zustandsänderung wird nicht angezeigt {#heading__sla_zustandsänderung_wird_nicht_angezeigt}

::: paragraph
In der einfachsten Form wechselt der SLA-Zustand in den Ansichten der
GUI erst beim Brechen der Anforderungen. Um über eine Zustandsänderung
bereits vorher informiert zu werden, müssen Sie die [SLA-Levels
konfigurieren.](#create_sla)
:::
::::
::::::::::::
:::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
