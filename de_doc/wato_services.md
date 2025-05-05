:::: {#header}
# Services verstehen und konfigurieren

::: details
[Last modified on 22-Sep-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/wato_services.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Grundlagen des Monitorings mit Checkmk](monitoring_basics.html)
[Verwaltung der Hosts](hosts_setup.html) [Regeln](wato_rules.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::: sectionbody
::: paragraph
Die Services sind das eigentliche Fleisch im Monitoring-System. Jeder
Einzelne von ihnen repräsentiert ein wichtiges Rädchen in Ihrer
komplexen IT-Landschaft. Der Nutzen des ganzen Monitorings steht und
fällt damit, wie treffsicher und sinnvoll die Services konfiguriert
sind. Schließlich soll das Monitoring zuverlässig melden, wenn sich
irgendwo ein Problem abzeichnet, aber auf der anderen Seite falsche und
nutzlose Benachrichtigungen unbedingt vermeiden.
:::

:::: {.imageblock .inline-image}
::: content
![wato services services
illu](../images/wato_services_services_illu.png){width="300"}
:::
::::

::: paragraph
Bei der Konfiguration der Services zeigt Checkmk seine vielleicht größte
Stärke: Es verfügt über ein einzigartiges und sehr mächtiges System für
eine *automatische Erkennung und Konfiguration von Services.* Sie müssen
mit Checkmk nicht jeden einzelnen Service über Schablonen und
Einzelzuweisungen definieren. Denn Checkmk kann die Liste der zu
überwachenden Services sehr zuverlässig automatisch ermitteln und vor
allem auch *aktuell halten.* Das spart nicht nur sehr viel Zeit --- es
macht das Monitoring auch *genauer.* Denn es stellt sicher, dass die
täglichen Änderungen im Rechenzentrum auch immer zeitnah im Monitoring
abgedeckt werden und kein wichtiger Dienst ohne Monitoring bleibt.
:::

::: paragraph
Die Service-Erkennung in Checkmk basiert auf einem wichtigen
Grundprinzip: der Trennung des *Was* vom *Wie*:
:::

::: ulist
- **Was** soll überwacht werden? → Das Dateisystem `/var` auf dem Host
  `myserver01`

- **Wie** soll es überwacht werden? → Bei 90 % belegtem Platz
  [WARN]{.state1}, bei 95 % [CRIT]{.state2}
:::

::: paragraph
Das *Was* wird bei der Service-Erkennung automatisch ermittelt. Es setzt
sich aus dem **Host-Namen** (`myserver01`), dem
[**Check-Plugin**](#checkplugins) (`df:` Dateisystemcheck unter Linux)
und dem **Item** (`/var`) zusammen. Check-Plugins, die auf einem Host
maximal einen Service erzeugen können, benötigen kein Item (z.B. das
Check-Plugin für die CPU-Ausnutzung). Das Ergebnis der Erkennung ist
eine Tabelle, die Sie sich so vorstellen können:
:::

+----------------------+----------------------+-----------------------+
| Host                 | Check-Plugin         | Item                  |
+======================+======================+=======================+
| `myserver01`         | `df`                 | `/`                   |
+----------------------+----------------------+-----------------------+
| `myserver01`         | `df`                 | `/var`                |
+----------------------+----------------------+-----------------------+
| `myserver01`         | `cpu.util`           |                       |
+----------------------+----------------------+-----------------------+
| ...​                  | ...​                  | ...​                   |
+----------------------+----------------------+-----------------------+
| `app01cz2`           | `hr_fs`              | `/`                   |
+----------------------+----------------------+-----------------------+
| ...​                  | ...​                  | ...​                   |
+----------------------+----------------------+-----------------------+

::: paragraph
Das *Wie* --- also die Schwellwerte/Check-Parameter für die einzelnen
Services --- wird unabhängig davon über [Regeln](wato_rules.html)
konfiguriert. Sie können z.B. eine Regel aufstellen, dass alle
Dateisysteme mit dem Mount-Punkt `/var` mit den Schwellwerten 90 % /
95 % überwacht werden, ohne sich dabei Gedanken machen zu müssen, auf
welchen Hosts denn nun überhaupt so ein Dateisystem existiert. Das ist
es, was die Konfiguration mit Checkmk so einfach und übersichtlich
macht!
:::

::: paragraph
Einige wenige Services können nicht über eine automatische Erkennung
eingerichtet werden. Dazu gehören z.B. Checks, die per HTTP bestimmte
Webseiten abrufen sollen. Diese werden per Regeln angelegt; wie,
erfahren Sie im Artikel über die [aktiven Checks.](active_checks.html)
:::
::::::::::::
:::::::::::::

::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#discovery .hidden-anchor .sr-only}2. Services eines Hosts im Setup {#heading_discovery}

:::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_host_neu_aufnehmen .hidden-anchor .sr-only}2.1. Host neu aufnehmen {#heading__host_neu_aufnehmen}

::: paragraph
Nachdem Sie einen neuen Host im Setup aufgenommen haben, ist der nächste
Schritt, die Liste der Services aufzurufen. Hierbei läuft bereits das
erste Mal die Service-Erkennung für den Host, gleichzeitig wird die
Erreichbarkeit der Datenquellen geprüft. Sie können diese Liste auch
jederzeit später wieder aufrufen, um die Erkennung neu zu starten oder
Anpassungen an der Konfiguration vorzunehmen. Sie erreichen die
Serviceliste auf verschiedene Arten:
:::

::: ulist
- über den Knopf [![icon save to
  services](../images/icons/icon_save_to_services.png)]{.image-inline}
  [Save & run service discovery]{.guihint} in den [Properties of
  host]{.guihint} im Setup

- in der Menüleiste der [Properties of host]{.guihint} über [Host \> Run
  service discovery]{.guihint}

- über das Symbol [![icon
  services](../images/icons/icon_services.png)]{.image-inline} in der
  Liste der Hosts in einem Ordner im Setup

- über den Eintrag [![icon
  services](../images/icons/icon_services.png)]{.image-inline} [Run
  service discovery]{.guihint} im Aktionsmenü des Services [[Check_MK
  Discovery]{.guihint}](#discovery_check) eines Hosts
:::

::: paragraph
Wenn der Host gerade neu aufgenommen wurde, ist noch kein Service
konfiguriert und daher erscheinen alle gefundenen Services in der Rubrik
[Undecided services - currently not monitored]{.guihint}:
:::

:::: imageblock
::: content
![Ansicht der Services of host nach der ersten
Service-Erkennung](../images/wato_services_first_service_discovery.png)
:::
::::

::: paragraph
Der übliche Weg ist nun einfach das Hinzufügen der Services über den
Knopf [![icon accept](../images/icons/icon_accept.png)]{.image-inline}
[Accept all]{.guihint}. Auf diese Weise werden zeitgleich auch alle
neuen Host-Labels mit aufgenommen. Danach ein [Activate
changes]{.guihint} und schon ist der Host samt Services im Monitoring.
:::
:::::::::

::::::: sect2
### []{#available .hidden-anchor .sr-only}2.2. Fehlende Services hinzufügen {#heading_available}

::: paragraph
Bei einem Host, der bereits überwacht wird, sieht diese Liste anders
aus. Anstelle von [Undecided services - currently not
monitored]{.guihint} sehen Sie [Monitored services]{.guihint}. Sollte
Checkmk allerdings feststellen, dass es auf dem Host etwas gibt, das
aktuell nicht überwacht wird, aber überwacht werden *sollte,* dann sieht
das etwa so aus:
:::

:::: imageblock
::: content
![Liste von erkannten, nicht aufgenommen
Services.](../images/wato_services_adding_newly_discovered_services.png)
:::
::::

::: paragraph
Ein Klick auf [![icon service to
old](../images/icons/icon_service_to_old.png)]{.image-inline} [Monitor
undecided services]{.guihint} oder auf [![icon
accept](../images/icons/icon_accept.png)]{.image-inline} [Accept
all]{.guihint} fügt abermals alle fehlenden Services hinzu, so dass die
Überwachung wieder vollständig ist. Wenn Sie nur manche der fehlenden
Services aufnehmen möchten, können Sie in den jeweiligen Zeilen auf den
Knopf [![icon service to
old](../images/icons/icon_service_to_old.png)]{.image-inline} für [Move
to monitored services]{.guihint} klicken.
:::
:::::::

::::::: sect2
### []{#vanished .hidden-anchor .sr-only}2.3. Verschwundene Services {#heading_vanished}

::: paragraph
Im Rechenzentrum können Dinge nicht nur neu auftauchen, sondern auch
verschwinden. Eine Datenbankinstanz wird abgeschafft, eine LUN
ausgehängt, ein Dateisystem entfernt u.s.w. Checkmk erkennt solche
Services dann automatisch als verschwunden *(vanished).* In der
Serviceliste sieht das z.B. so aus:
:::

:::: imageblock
::: content
![Listeneintrag eines verschwundenen
Services.](../images/wato_services_vanished_services.png)
:::
::::

::: paragraph
Der einfachste Weg um diese Services loszuwerden ist erneut ein Klick
auf [![icon accept](../images/icons/icon_accept.png)]{.image-inline}
[Accept all]{.guihint}. Alternativ können Sie die verschwundenen
Services auch über den Knopf [![icon service to
removed](../images/icons/icon_service_to_removed.png)]{.image-inline}
[Remove vanished services]{.guihint} entfernen. **Achtung:** Der Grund
für das Verschwinden kann durchaus auch ein Problem sein! Das
Verschwinden eines Dateisystems kann ja auch bedeuten, dass dieses
aufgrund eines Fehlers nicht gemountet werden konnte. Und für solche
Fälle ist das Monitoring schließlich da! Sie sollten den Service also
nur dann entfernen, wenn Sie wissen, dass hier eine Überwachung auch
wirklich keinen Sinn mehr macht.
:::
:::::::

::::::::::::::: sect2
### []{#remove_unwanted_services .hidden-anchor .sr-only}2.4. Ungewünschte Services loswerden {#heading_remove_unwanted_services}

::: paragraph
Nicht alles, was Checkmk findet, möchten Sie auch unbedingt überwachen.
Zwar arbeitet die Erkennung durchaus zielgerichtet und kann schon viel
Unnützes im Vorfeld ausschließen. Doch woher soll Checkmk z.B. wissen,
dass eine bestimmte Datenbankinstanz nur zum „Herumspielen" eingerichtet
wurde und nicht produktiv ist? Sie können solche Services auf zwei Arten
loswerden:
:::

::::: sect3
#### []{#_vorübergehendes_abschalten_von_services .hidden-anchor .sr-only}Vorübergehendes Abschalten von Services {#heading__vorübergehendes_abschalten_von_services}

::: paragraph
Um bestimmte Services vorübergehend aus dem Monitoring zu entfernen,
klicken Sie entweder auf das Symbol [![icon service to
undecided](../images/icons/icon_service_to_undecided.png)]{.image-inline}.
Hiermit wird der Service wieder in die Liste der [Undecided
services]{.guihint} verschoben. Oder Sie deaktivieren den Service
gänzlich, indem Sie am Anfang der Zeile auf [![icon move to
disabled](../images/icons/icon_move_to_disabled.png)]{.image-inline}
klicken. Und natürlich, wie immer [Activate changes]{.guihint} nicht
vergessen.
:::

::: paragraph
Das Ganze ist allerdings nur für vorübergehende und kleinere Maßnahmen
gedacht. Denn die so abgewählten Services werden von Checkmk dann wieder
als [missing]{.guihint} angemahnt. Und der [Discovery
Check](#discovery_check) (den wir Ihnen weiter unten zeigen) wird
ebenfalls nicht glücklich damit sein. Außerdem ist das in einer Umgebung
mit ein paar zigtausend Services einfach zu viel Arbeit und nicht
wirklich praktikabel ...​
:::
:::::

:::::::::: sect3
#### []{#disabled_services .hidden-anchor .sr-only}Permanentes Abschalten von Services {#heading_disabled_services}

::: paragraph
Viel eleganter und dauerhafter ist das permanente Ignorieren von
Services mit Hilfe des [Regelsatzes](wato_rules.html) [Disabled
services]{.guihint}. Hier können Sie nicht nur einzelne Services vom
Monitoring ausschließen, sondern Regeln wie „Auf dem Host
[myserver01]{.guihint} sollen keine Services überwacht werden, die mit
*myservice* beginnen." formulieren.
:::

::: paragraph
Sie erreichen die Regel über [Setup \> Services \> Discovery rules \>
Discovery and Checkmk settings \> Disabled Services]{.guihint}.
:::

:::: imageblock
::: content
![Eingabemaske für
Discovery-Bedinungen.](../images/wato_services_disabled_services_conditions.png)
:::
::::

::: paragraph
Wenn Sie die Regel speichern und erneut auf die Serviceliste des Hosts
gehen, finden Sie die stillgelegten Services gemeinsam mit manuell
deaktivierten Services unter [Disabled Services.]{.guihint}
:::

:::: imageblock
::: content
![Liste mit Services mit unterschiedlichen
Status.](../images/wato_services_disabled_services.png)
:::
::::
::::::::::
:::::::::::::::

::::: sect2
### []{#refresh .hidden-anchor .sr-only}2.5. Services auffrischen {#heading_refresh}

::: paragraph
Es gibt einige Check-Plugins, die sich während der Erkennung Dinge
*merken.* So merkt sich z.B. das Plugin für Netzwerkinterfaces die
Geschwindigkeit, auf die das Interface während der Erkennung eingestellt
war. Warum? Um Sie zu warnen, falls sich diese ändert! Es ist selten ein
gutes Zeichen, wenn ein Interface mal auf 10 Mbit/s, mal auf 1 Gbit/s
eingestellt ist --- eher ein Hinweis auf eine fehlerhafte
Autonegotiation.
:::

::: paragraph
Was aber, wenn diese Änderung gewollt ist und von nun an als OK gelten
soll? Entfernen Sie entweder den Service über das Symbol [![icon service
to
undecided](../images/icons/icon_service_to_undecided.png)]{.image-inline}
für [Move to undecided services]{.guihint} und fügen Sie Ihn
anschließend wieder hinzu. Dazu müssen Sie nach dem Entfernen einmal
speichern. Oder Sie frischen *alle* Services des Host auf, indem Sie in
der Menüleiste auf [Actions \> Remove all and find new]{.guihint}
klicken. Das ist natürlich viel bequemer --- geht aber nur, wenn Sie
nicht einzelne Services im Fehlerzustand behalten wollen.
:::
:::::

:::::: sect2
### []{#update_labels .hidden-anchor .sr-only}2.6. Host- und Service-Labels aktualisieren {#heading_update_labels}

::: paragraph
Über die Menüleiste haben Sie über [Actions \> Host labels \> Update
host labels]{.guihint} bzw. [Actions \> Services \> Update host
labels]{.guihint} auch die Möglichkeit nur die Liste der zugehörigen
Host- und Service-Labels zu aktualisieren. Sollte es mal notwendig sein
nur einzelne (neue) Service-Labels aufzunehmen bzw. zu aktualisieren,
dann ist dies in der Zeile des jeweiligen Service im Kasten [Changed
services]{.guihint} durch Anklicken von [![button update service
labels](../images/icons/button_update_service_labels.png)]{.image-inline}
möglich.
:::

:::: imageblock
::: content
![Neue Service-Labels in der Service-Erkennung und der Knopf für deren
Aufnahme ins
Monitoring.](../images/wato_services_update_service_labels.png)
:::
::::
::::::

:::: sect2
### []{#snmp .hidden-anchor .sr-only}2.7. Besonderheiten bei SNMP {#heading_snmp}

::: paragraph
Bei Geräten, die per SNMP überwacht werden, gibt es ein paar
Sonderheiten. Diese erfahren Sie im [Artikel über
SNMP.](snmp.html#services)
:::
::::
::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::: sect1
## []{#bulk_discovery .hidden-anchor .sr-only}3. Service-Erkennung für viele Hosts gleichzeitig {#heading_bulk_discovery}

::::::::::::::: sectionbody
::: paragraph
Wenn Sie die Erkennung für mehrere Hosts auf einmal machen wollen,
können Sie sich die Arbeit mit
[Bulk-Aktionen](hosts_setup.html#bulk_operations) von Checkmk
erleichtern. Wählen Sie zunächst aus, auf welchen Hosts die Erkennung
durchgeführt werden soll. Dazu haben Sie mehrere Möglichkeiten:
:::

::: {.olist .arabic}
1.  In einem Ordner die Checkboxen bei einzelnen Hosts ankreuzen und
    dann in der Menüleiste auf [Hosts \> On selected hosts \> Run bulk
    service discovery]{.guihint} drücken.

2.  Mit der [Host-Suche](hosts_setup.html#search) Hosts suchen, alle
    gefundenen mit einem Klick auf das Kreuz [![button select
    all](../images/icons/button_select_all.png)]{.image-inline}
    auswählen und wieder in der Menüleiste über [Hosts \> On selected
    hosts \> Run bulk service discovery]{.guihint} gehen.

3.  In einem Ordner in der Menüleiste auf [Hosts \> **In this folder**
    \> Run bulk service discovery]{.guihint} klicken.
:::

::: paragraph
Bei der dritten Variante können Sie die Service-Erkennung auch rekursiv
in allen Unterordnern ausführen lassen. In allen drei Fällen gelangen
Sie im nächsten Schritt zu folgendem Dialog:
:::

:::: imageblock
::: content
![Eingabemaske für Optionen der
Service-Erkennung.](../images/wato_services_bulk_discovery.png)
:::
::::

::: paragraph
Im Drop-down-Menü [Parameters]{.guihint} ist die Option [Custom service
configuration update]{.guihint} vorausgewählt. Die vier Checkboxen
darunter bieten genau die Möglichkeiten, die Sie auch in der
Serviceliste im Setup haben und die wir schon weiter oben erläutert
haben. Im Drop-down-Menü haben Sie zusätzlich noch die Möglichkeit
[Refresh all services (tabula rasa)]{.guihint} auszuwählen.
:::

::: paragraph
Unter [Selection]{.guihint} können Sie die Auswahl der Hosts noch mal
steuern. Das ist vor allem dann sinnvoll, wenn Sie diese nicht per
Checkboxen, sondern über den Ordner ausgewählt haben. Die meisten
Optionen zielen auf eine Beschleunigung der Discovery hin:
:::

+-----------------------------------+-----------------------------------+
| [Include all                      | Wenn Sie die Service-Erkennung    |
| subfolders]{.guihint}             | für einen Order gestartet haben,  |
|                                   | dann ist diese Option überhaupt   |
|                                   | nur verfügbar und standardmäßig   |
|                                   | aktiv. Die Service-Erkennung wird |
|                                   | dann auch bei allen Hosts in den  |
|                                   | Unterordnern des aktuell          |
|                                   | geöffneten Ordners durchgeführt.  |
+-----------------------------------+-----------------------------------+
| [Only include hosts that failed   | Hosts, bei denen eine frühere     |
| on previous discovery]{.guihint}  | Service-Erkennung per             |
|                                   | Bulk-Operation fehlgeschlagen ist |
|                                   | (z.B. weil der Host zu dem        |
|                                   | Zeitpunkt nicht erreichbar war),  |
|                                   | werden von Checkmk mit dem Symbol |
|                                   | [![icon inventory                 |
|                                   | failed](../images/icons/icon_inve |
|                                   | ntory_failed.png)]{.image-inline} |
|                                   | markiert. Diese Option erlaubt,   |
|                                   | die Erkennung nur genau für diese |
|                                   | Hosts zu wiederholen.             |
+-----------------------------------+-----------------------------------+
| [Only include hosts with a failed | Dies schränkt die Erkennung auf   |
| discovery check]{.guihint}        | solche Hosts ein, bei denen der   |
|                                   | [Discovery                        |
|                                   | Check](#discovery_check)          |
|                                   | angeschlagen hat. Wenn Sie mit    |
|                                   | dem Discovery Check arbeiten, ist |
|                                   | das eine gute Methode, um das     |
|                                   | Discovery von vielen Hosts massiv |
|                                   | zu beschleunigen. Die Kombination |
|                                   | mit der Option [Refresh all       |
|                                   | services (tabula rasa)]{.guihint} |
|                                   | macht hier allerdings weniger     |
|                                   | Sinn, da dies den Status von      |
|                                   | bestehenden Services verfälschen  |
|                                   | kann.                             |
+-----------------------------------+-----------------------------------+
| [Exclude hosts where the agent is | Hosts, die nicht erreichbar sind, |
| unreachable]{.guihint}            | verursachen beim Discovery        |
|                                   | Wartezeiten durch                 |
|                                   | Verbindungs-Timeouts. Dies kann   |
|                                   | das Discovery einer größeren Zahl |
|                                   | von Hosts stark verlangsamen.     |
|                                   | Wenn die Hosts aber schon im      |
|                                   | Monitoring sind und dieses weiß,  |
|                                   | dass die Hosts [DOWN]{.hstate1}   |
|                                   | sind, können Sie diese hiermit    |
|                                   | überspringen und die Timeouts     |
|                                   | somit vermeiden.                  |
+-----------------------------------+-----------------------------------+

::: paragraph
Die [Performance options]{.guihint} sind so voreingestellt, dass immer
ein vollständiger Service-Scan durchgeführt wird. Wenn Sie nicht auf
neue Plugins aus sind, können Sie die Erkennung durch Wegnahme der
Option beschleunigen.
:::

::: paragraph
Die eingestellte `10` unter [Number of hosts to handle at
once]{.guihint} bedeutet, dass immer zehn Hosts auf ein mal bearbeitet
werden. Intern geschieht das mit einem HTTP-Request. Sollten Sie
Probleme mit Timeouts haben, weil einzelne Hosts sehr lange zum Erkennen
brauchen, können Sie versuchen, diese Zahl kleiner einzustellen
(zulasten der Gesamtdauer).
:::

::: paragraph
Sobald Sie den Dialog bestätigen, geht es los und Sie können den
Fortschritt beobachten:
:::

:::: imageblock
::: content
![Status der laufenden
Service-Erkennung.](../images/wato_services_bulk_discovery_progress.png)
:::
::::
:::::::::::::::
::::::::::::::::

::::::::::::: sect1
## []{#parameters .hidden-anchor .sr-only}4. Check-Parameter von Services {#heading_parameters}

:::::::::::: sectionbody
::: paragraph
Viele der Check-Plugins können über Parameter konfiguriert werden. Die
häufigste Anwendung ist das Setzen von Schwellwerten für [WARN]{.state1}
und [CRIT]{.state2}. Parameter können aber auch deutlich komplexer
aufgebaut sein, wie das Beispiel der Temperaturüberwachung mit Checkmk
zeigt:
:::

:::: imageblock
::: content
![wato services example check parameters temperature
levels](../images/wato_services_example_check_parameters_temperature_levels.png)
:::
::::

::: paragraph
Die Check-Parameter für einen Service werden in drei Schritten gebildet:
:::

::: {.olist .arabic}
1.  Jedes Plugin hat Standardwerte für die Parameter.

2.  Manche Plugins setzen Werte während der Erkennung (siehe
    [oben](#refresh)).

3.  Parameter können über Regeln gesetzt werden.
:::

::: paragraph
Dabei haben Parameter aus Regeln Vorrang vor den bei der Erkennung
gesetzten und diese wiederum Vorrang für den Defaultwerten. Bei
komplexen Parametern, bei denen per Checkbox einzelne Unterparameter
festgelegt werden (wie im Beispiel mit der Temperatur), gilt diese
Vorrangregel für jeden einzelnen Unterparameter separat. Wenn Sie also
per Regel nur einen der Unterparameter anpassen, bleiben die anderen auf
ihren jeweiligen Defaultwerten. So können Sie z.B mit einer Regel die
Trendberechnung der Temperatur aktivieren und mit einer anderen die
Temperaturschwellwerte für einen konkreten Sensor einstellen. Der
komplette Parametersatz wird dann aus beiden Regeln zusammengesetzt.
:::

::: paragraph
Welche Parameter ein Service am Ende genau hat, erfahren Sie in der
Parameterseite des Services. Diese erreichen Sie in der Serviceliste
eines Hosts über das Symbol für die Check-Parameter [![icon check
parameters](../images/icons/icon_check_parameters.png)]{.image-inline}.
Wenn Sie die Parameter von allen Services direkt in der Servicetabelle
sehen möchten, können Sie diese mit über die Menüleiste [Display \>
Details \> Show check parameters]{.guihint} einblenden. Das sieht dann
etwa so aus:
:::

:::: imageblock
::: content
![wato services check
parameters](../images/wato_services_check_parameters.png)
:::
::::
::::::::::::
:::::::::::::

::::::::::::::::::::::::::::: sect1
## []{#_anpassen_der_service_erkennung .hidden-anchor .sr-only}5. Anpassen der Service-Erkennung {#heading__anpassen_der_service_erkennung}

:::::::::::::::::::::::::::: sectionbody
::: paragraph
Wie Sie die Service-Erkennung konfigurieren, um nicht erwünschte
Services auszublenden, haben wir bereits [weiter
oben](#disabled_services) gezeigt. Es gibt aber für etliche
Check-Plugins noch weitere Regelsätze, die das Verhalten der Discovery
bei diesen Plugins beeinflussen. Dabei gibt es nicht nur Einstellungen
zum *Weglassen* von Items, sondern auch solche, die positiv Items finden
oder zu Gruppen zusammenfassen. Auch die Benennung von Items ist
manchmal ein Thema --- z.B. bei den Switchports, wo Sie sich entscheiden
können, anstelle der Interface-ID dessen Description oder Alias als Item
(und damit im Servicenamen) zu verwenden.
:::

::: paragraph
Alle Regelsätze, die mit der Service-Erkennung zu tun haben, finden Sie
unter [[![icon main setup
dark](../images/icons/icon_main_setup_dark.png)]{.image-inline} Setup \>
Services \> Discovery rules]{.guihint}. Bitte verwechseln Sie diese
Regelsätze nicht mit denen, die zum Parametrieren der eigentlichen
Services gedacht sind. Etliche Plugins haben in der Tat zwei
Regelsätze --- einen für die Erkennung und einen für die Parameter. Dazu
gleich ein paar Beispiele.
:::

:::::::::::::: sect2
### []{#processes .hidden-anchor .sr-only}5.1. Überwachung von Prozessen {#heading_processes}

::: paragraph
Es wäre wenig sinnvoll, wenn Checkmk einfach für jeden Prozess, den es
auf einem Host findet, einen Service für die Überwachung einrichten
würde. Die meisten Prozesse sind entweder nicht interessant oder sogar
nur vorübergehend vorhanden. Und auf einem normalen Linux-Server laufen
mindestens hunderte von Prozessen.
:::

::: paragraph
Zum Überwachen von Prozessen müssen Sie daher mit [erzwungenen
Services](#enforced_services) arbeiten oder --- und das ist viel
eleganter --- der Service-Erkennung mit dem Regelsatz [Process
discovery]{.guihint} sagen, nach welchen Prozessen sie Ausschau halten
soll. So können Sie immer dann, wenn auf einem Host *bestimmte
interessante* Prozesse gefunden werden, dafür automatisch eine
Überwachung einrichten lassen.
:::

::: paragraph
Folgende Abbildung zeigt eine Regel im Regelsatz [Process
discovery]{.guihint}, welche nach Prozessen sucht, die das Programm
`/usr/sbin/apache2` ausführen. In diesem Beispiel wird für jeden
unterschiedlichen Betriebssystembenutzer, für den ein solcher Prozess
gefunden wird, ein Service erzeugt ([Grab user from found
processes]{.guihint}). Der Name des Services wird `Apache %u`, wobei das
`%u` durch den Benutzernamen ersetzt wird. Als Schwellwerte für die
Anzahl der Prozessinstanzen werden 1/1 (untere) bzw. 30/60 (obere)
verwendet:
:::

:::: imageblock
::: content
![wato services process
discovery](../images/wato_services_process_discovery.png)
:::
::::

::: paragraph
Bitte beachten Sie, dass die festgelegten Schwellwerte [Default
parameters for detected services]{.guihint} heißen. Denn Sie können
diese --- wie bei allen anderen Services auch --- per Regel
überdefinieren. Zur Erinnerung: Obige Regel konfiguriert die *Erkennung*
der Services --- also das *Was.* Sind die Services erst mal vorhanden,
so ist eigentlich die Regelkette [State and count of
processes]{.guihint} für die Schwellwerte zuständig.
:::

::: paragraph
Die Tatsache, dass Sie schon bei der Erkennung Schwellwerte festlegen
können, ist nur der Bequemlichkeit geschuldet. Und es gibt auch einen
Haken: Änderung in der Erkennungsregel haben erst bei der *nächsten
Erkennung* Einfluss. Wenn Sie also Schwellwerte ändern, müssen Sie die
Erkennung nochmal ausführen. Wenn Sie aber die Regel nur zum
eigentlichen Finden verwenden (also das *Was*), und den Regelsatz [State
and count of processes]{.guihint} für das *Wie* verwenden, haben Sie
dieses Problem nicht.
:::

::: paragraph
Um bestimmte oder einzelne Prozesse auf einem Windows-Host zu
überwachen, muss im Feld [Executable]{.guihint} tatsächlich nur der
Dateiname ohne Pfad angegeben werden. In Windows finden Sie diese Namen
im Reiter Details des Windows Task Managers. In der Regel [Process
discovery]{.guihint} könnte das für den Prozess `svchost` dann wie folgt
aussehen:
:::

:::: imageblock
::: content
![wato services process discovery
windows](../images/wato_services_process_discovery_windows.png)
:::
::::

::: paragraph
Weitere Details zur Prozesserkennung finden Sie über in der Inline-Hilfe
dieses Regelsatzes. Diese aktivieren Sie wie immer über [Help \> Show
inline help]{.guihint} in der Menüleiste.
:::
::::::::::::::

::::::: sect2
### []{#_überwachung_von_windows_diensten .hidden-anchor .sr-only}5.2. Überwachung von Windows-Diensten {#heading__überwachung_von_windows_diensten}

::: paragraph
Das Erkennen und Parametrieren der Überwachung von Windows-Services geht
analog zu den Prozessen und wird über die Regelsätze [Windows service
discovery]{.guihint} *(Was)* bzw. [Windows services]{.guihint} *(Wie)*
gesteuert. Hier ist ein Beispiel für eine Regel, die nach zwei Diensten
Ausschau hält:
:::

:::: imageblock
::: content
![wato services windows service
discovery](../images/wato_services_windows_service_discovery.png)
:::
::::

::: paragraph
Genau wie bei den Prozessen ist auch hier die Service-Erkennung nur eine
Option. Wenn Sie anhand von Host-Merkmalen und Ordnern präzise Regeln
formulieren können, auf welchen Hosts bestimmte Dienste erwartet werden,
können Sie auch mit [erzwungenen Services](#enforced_services) arbeiten.
Das ist dann unabhängig von der tatsächlich vorgefundenen
Situation --- allerdings kann das deutlich mehr Aufwand sein, da Sie
unter Umständen viele Regeln brauchen, um genau abzubilden, auf welchem
Host welche Dienste erwartet werden.
:::
:::::::

:::::::: sect2
### []{#switches .hidden-anchor .sr-only}5.3. Überwachung von Switchports {#heading_switches}

::: paragraph
Checkmk verwendet für die Überwachung von Netzwerkschnittstellen von
Servern und für die Ports von Ethernet-Switches die gleiche Logik. Vor
allem bei den Switchports sind die vorhandenen Optionen für die
Steuerung der Service-Erkennung interessant, auch wenn (im Gegensatz zu
den Prozessen und Windows-Diensten) die Erkennung auch erst mal ohne
Regel funktioniert. Per Default überwacht Checkmk nämlich automatisch
alle physikalischen Ports, die gerade den Zustand [UP]{.hstate0} haben.
Der Regelsatz dazu heißt [Network interface and switch port
discovery]{.guihint} und bietet zahlreiche Einstellmöglichkeiten, die
hier nur gekürzt dargestellt sind:
:::

:::: imageblock
::: content
![wato services network interface switch port
discovery](../images/wato_services_network_interface_switch_port_discovery.png)
:::
::::

::: paragraph
Am wichtigsten sind folgende Möglichkeiten:
:::

::: ulist
- Im Abschnitt [Appearance of network interface]{.guihint} können Sie
  bestimmen, wie das Interface im Servicenamen erscheinen soll. Sie
  haben hier die Wahl zwischen [Use description]{.guihint}, [Use
  alias]{.guihint} und [Use index]{.guihint}.

- [Match port types]{.guihint} ermöglicht das Einschränken oder
  *Ausweiten* der überwachten Interfacetypen oder -namen.
:::
::::::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#enforced_services .hidden-anchor .sr-only}6. Einrichtung von Services erzwingen {#heading_enforced_services}

:::::::::::::::::: sectionbody
::: paragraph
Es gibt einige Situationen, in denen eine automatische Service-Erkennung
nicht sinnvoll ist. Das ist immer dann der Fall, wenn Sie das Einhalten
einer bestimmte *Richtlinie* erzwingen möchten. Wie Sie im vorherigen
Kapitel gesehen haben, können Sie Überwachung von Windows-Diensten
automatisch einrichten lassen, wenn diese gefunden werden. Was ist aber,
wenn schon das Fehlen eines solchen Diensts ein Problem darstellt?
Beispiele:
:::

::: ulist
- Auf jedem Windows-Host soll ein bestimmter Virenscanner installiert
  sein.

- Auf jedem Linux-Host soll NTP konfiguriert sein.
:::

::: paragraph
In solchen Fällen können Sie das Anlegen von Services erzwingen. Den
Einstiegspunkt dafür finden Sie unter sind die [Setup \> Services \>
Enforced services]{.guihint}. Dahinter verbirgt sich eine Sammlung von
[Regelsätzen](wato_rules.html), welche exakt die gleichen Namen haben,
wie diejenigen Regelsätze, mit denen auch Parameter für diese Checks
konfiguriert werden.
:::

::: paragraph
Die Regeln unterscheiden sich jedoch in zwei Punkten:
:::

::: ulist
- Es sind Regeln für *Hosts,* nicht für Services. Die Services werden ja
  erst durch die Regeln erzeugt.

- Da keine Erkennung stattfindet, müssen Sie selbst das Check-Plugin
  auswählen, das für den Check verwendet werden soll.
:::

::: paragraph
Folgendes Beispiel zeigt den Rumpf der Regel [State of NTP time
synchronisation]{.guihint} unter [Enforced services]{.guihint}:
:::

:::: imageblock
::: content
![wato services example enforced services
ntp](../images/wato_services_example_enforced_services_ntp.png)
:::
::::

::: paragraph
Neben den Schwellwerten legen Sie hier auch das Check-Plugin fest (z.B.
`chrony` oder `ntp_time`). Bei Check-Plugins, die ein Item benötigen,
müssen Sie auch dieses angeben. Dies ist z.B. beim Plugin
[oracle_processes]{.guihint} notwendig, welches die Angabe der zu
überwachenden Datenbank-SID benötigt:
:::

:::: imageblock
::: content
![wato services example enforced services oracle
processes](../images/wato_services_example_enforced_services_oracle_processes.png)
:::
::::

::: paragraph
Der so definierte manuelle Service wird auf allen Hosts angelegt, auf
die diese Regel greift. Für die eigentliche Überwachung gibt es jetzt
drei Fälle:
:::

::: {.olist .arabic}
1.  Der Host ist korrekt aufgesetzt und der Service geht auf
    [OK]{.state0}.

2.  Der Agent liefert die Information, dass der gefragte Dienst nicht
    läuft oder ein Problem hat. Dann geht der Service auf
    [CRIT]{.state2} oder auf [UNKNOWN]{.state3}.

3.  Der Agent stellt überhaupt keine Informationen bereit, z.B. weil NTP
    überhaupt nicht installiert ist. Dann bleibt der Service auf
    [PEND]{.statep} und der Checkmk-Service geht auf [WARN]{.state1},
    mit dem Hinweis, dass die entsprechende Sektion in den Agentendaten
    fehlt.
:::

::: paragraph
Die meisten Regelsätze im Modul [Enforced services]{.guihint} werden Sie
nie benötigen und sind nur der Vollständigkeit halber vorhanden. Die
häufigsten Fälle für erzwungene Services sind:
:::

::: ulist
- Überwachung von Windows-Diensten (Regelsatz: [Windows
  Services]{.guihint})

- Überwachung von Prozessen (Regelsatz: [State and count of
  processes]{.guihint})
:::
::::::::::::::::::
:::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#discovery_check .hidden-anchor .sr-only}7. Der Discovery Check {#heading_discovery_check}

:::::::::::::::::::::::: sectionbody
::: paragraph
In der Einleitung haben wir versprochen, dass Checkmk die Liste der
Services nicht nur automatisch ermitteln, sondern auch *aktuell halten*
kann. Natürlich wäre dafür eine Möglichkeit, dass Sie ab und zu von Hand
eine Bulk-Erkennung über alle Hosts durchführen.
:::

:::::::::::::: sect2
### []{#discovery_auto .hidden-anchor .sr-only}7.1. Automatisches Prüfen auf nicht überwachte Services {#heading_discovery_auto}

::: paragraph
Viel besser ist dafür aber ein regelmäßiger *Discovery Check,* welcher
von Checkmk bei neuen Instanzen automatisch eingerichtet wird. Dieser
Service [Check_MK Discovery]{.guihint} existiert für jeden Host und
meldet sich mit einer Warnung, wenn er nicht überwachte Dinge findet:
:::

:::: imageblock
::: content
![wato services discovery check
warn](../images/wato_services_discovery_check_warn.png)
:::
::::

::: paragraph
Die Einzelheiten zu den nicht überwachten oder verschwundenen Services
finden Sie auf der Seite mit den Details des Services [Check_MK
Discovery]{.guihint} im Feld [Details:]{.guihint}
:::

:::: imageblock
::: content
![wato services discovery check
details](../images/wato_services_discovery_check_details.png)
:::
::::

::: paragraph
Zu der Service-Liste des Hosts im Setup gelangen Sie bequem über das
[![icon menu](../images/icons/icon_menu.png)]{.image-inline} Aktionsmenü
des [Check_MK Discovery]{.guihint} Services und den Eintrag [![icon
services](../images/icons/icon_services.png)]{.image-inline} [Run
service discovery.]{.guihint}
:::

::: paragraph
Das Parametrieren des Discovery Checks geht sehr einfach über den
[Regelsatz](glossar.html#rule_set) [Periodic service
discovery.]{.guihint} In einer frischen Instanz werden Sie hier bereits
eine global wirksame Regel mit den folgenden Einstellungen vorfinden:
:::

:::: imageblock
::: content
![wato services periodic service
discovery](../images/wato_services_periodic_service_discovery.png)
:::
::::

::: paragraph
Neben dem Intervall, in dem der Check laufen soll, können Sie auch noch
den Monitoring-Zustand auswählen --- für die Fälle von nicht überwachten
Services, verschwundenen Services, geänderten Service-Labels und neuen
Host-Labels.
:::
::::::::::::::

:::::::::: sect2
### []{#automatically_update_service_configuration .hidden-anchor .sr-only}7.2. Services automatisch hinzufügen {#heading_automatically_update_service_configuration}

::: paragraph
Sie können den Discovery Check fehlende Services automatisch hinzufügen
lassen. Dazu aktivieren Sie die Option [Automatically update service
configuration]{.guihint}. Nun werden weitere Optionen sichtbar.
:::

:::: imageblock
::: content
![wato services periodic service discovery update
configuration](../images/wato_services_periodic_service_discovery_update_configuration.png)
:::
::::

::: paragraph
Neben dem Hinzufügen können Sie bei [Parameters]{.guihint} auch
auswählen, verschwundene Services zu entfernen oder sogar alle
bestehenden Services zu entfernen und komplett neu zu erkennen. Letztere
Option finden Sie im Drop-down-Menü unter der Bezeichnung [Refresh all
services and host labels (tabula rasa)]{.guihint}. Beide Optionen sind
mit Vorsicht zu genießen! Ein verschwundener Service kann auf ein
Problem hindeuten! Der Discovery Check wird so einen Service dann
einfach entfernen und Sie im Glauben wiegen, dass alles in Ordnung ist.
Der Refresh ist besonders gefährlich. So übernimmt z.B. der Check für
Switchports nur solche Ports in das Monitoring, die [UP]{.hstate0} sind.
Ports mit Status [DOWN]{.hstate1} gelten dann als verschwunden und
würden vom Discovery Check ohne Rückfrage weggeräumt!
:::

::: paragraph
Ein weiteres Problem gilt es noch zu bedenken: Das Hinzufügen von
Services oder gar das automatische [Activate Changes]{.guihint} kann Sie
als Admin bei Ihrer Arbeit am System stören, wenn Sie gerade beim
Konfigurieren sind. Es kann theoretisch passieren, dass Sie gerade dabei
sind, an Regeln und Einstellungen zu arbeiten und just in dem Augenblick
ein Discovery Check Ihre Änderungen aktiviert. Denn in Checkmk können
immer nur alle Änderungen auf einmal aktiviert werden! Um dies zu
verhindern, können Sie die Uhrzeiten, in denen so etwas geschieht, z.B.
in die Nacht legen. Die obige Abbildung zeigt dafür ein Beispiel.
:::

::: paragraph
Unter [Vanished clustered services]{.guihint} können Sie [geclusterte
Services](clustered_services.html) separat handhaben. Die Besonderheit
hier: Wenn ein geclusterter Service von einem Node auf den anderen
wechselt, könnte er kurzzeitig als verschwunden angesehen und
entsprechend ungewollt gelöscht werden. Verzichten Sie hingegen auf
diese Option, würden wiederum tatsächlich verschwundene Services niemals
gelöscht.
:::

::: paragraph
Die Einstellung [Group discovery and activation for up to]{.guihint}
sorgt dafür, dass nicht jeder einzelne Service, der neu gefunden wird,
sofort ein [Activate Changes]{.guihint} auslöst, sondern eine bestimmte
Zeit gewartet wird, um gleich mehrere Änderungen in einem Rutsch zu
aktivieren. Denn selbst wenn der Discovery Check auf ein Intervall von
zwei Stunden oder mehr eingestellt ist, gilt das nur für jeden Host
separat. Die Checks laufen nicht für alle Hosts gleichzeitig --- und das
ist auch gut so, denn der Discovery Check braucht erheblich mehr
Ressourcen als ein normaler Check.
:::
::::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#passive_checks .hidden-anchor .sr-only}8. Passive Services {#heading_passive_checks}

:::::::::::::::::: sectionbody
::: paragraph
Passive Services sind solche, die nicht von Checkmk aktiv angestoßen
werden, sondern bei denen regelmäßig von außen neue Check-Ergebnisse
eingeschleust werden. Dies geschieht in der Regel über die Kommando-Pipe
des Cores. Hier ist ein Schritt-für-Schritt-Vorgehen für das Einrichten
eines passiven Services:
:::

::: paragraph
Zunächst müssen Sie den Service dem Kern bekannt machen. Dies geschieht
mit dem gleichen Regelsatz wie bei den [eigenen aktiven
Checks](active_checks.html#nagios_plugins), nur dass Sie die [Command
line]{.guihint} weglassen:
:::

:::: imageblock
::: content
![wato services passive checks integrate nagios
plugins](../images/wato_services_passive_checks_integrate_nagios_plugins.png)
:::
::::

::: paragraph
Die Abbildung zeigt auch, wie Sie prüfen lassen können, ob regelmäßig
Check-Ergebnisse eingehen. Wenn dies für länger als 10 Minuten
ausbleibt, so wird der Service hier automatisch auf [UNKNOWN]{.state3}
gesetzt.
:::

::: paragraph
Nach einem [Activate Changes]{.guihint} beginnt der neue Service sein
Leben im Zustand [PEND]{.statep}:
:::

:::: imageblock
::: content
![wato services passive checks
pending](../images/wato_services_passive_checks_pending.png)
:::
::::

::: paragraph
Das Senden der Check-Ergebnisse geschieht nun auf der Kommandozeile
durch ein `echo` des Befehls `PROCESS_SERVICE_CHECK_RESULT` in die
Kommando-Pipe `~/tmp/run/nagios.cmd`.
:::

::: paragraph
Die Syntax entspricht den bei Nagios üblichen Konventionen --- inklusive
eines aktuellen Zeitstempels in eckigen Klammern. Als Argumente nach dem
Befehl brauchen Sie den Host-Namen (z.B. `myhost`) und den gewählten
Servicenamen (im Beispiel `BAR`). Die beiden weiteren Argumente sind
wieder der Status (`0` ...​ `3`) und die Plugin-Ausgabe. Den Zeitstempel
erzeugen Sie mit `$(date +%s)`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "[$(date +%s)] PROCESS_SERVICE_CHECK_RESULT;myhost;BAR;2;Something bad happened" > ~/tmp/run/nagios.cmd
```
:::
::::

::: paragraph
Nun zeigt der Service ohne Verzögerung den neuen Status:
:::

:::: imageblock
::: content
![wato services passive checks
crit](../images/wato_services_passive_checks_crit.png)
:::
::::
::::::::::::::::::
:::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::: sect1
## []{#commandline .hidden-anchor .sr-only}9. Service-Erkennung auf der Kommandozeile {#heading_commandline}

:::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
So schön eine GUI ist, so praktisch ist doch manchmal noch die gute alte
Kommandozeile --- sei es zum Automatisieren oder einfach zum schnellen
Arbeiten für den geübten Benutzer. Die Service-Erkennung können Sie auf
der Kommandozeile mit dem Befehl `cmk -I` auslösen. Dabei gibt es ein
paar verschiedene Spielarten. Bei allen empfehlen wir die Option `-v`,
damit Sie sehen, was genau passiert. Ohne `-v` verhält sich Checkmk nach
guter alter Unix-Tradition: Solange alles gut geht, schweigt es.
:::

::: paragraph
Mit einem einfachen `-I` suchen Sie auf **allen** Hosts nach neuen
Services:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vI
Discovering services and host labels on all hosts
myserver01:
+ FETCHING DATA
Using data from cache file /omd/sites/mysite/tmp/check_mk/cache/myserver01
[TCPFetcher] Use cached data
No piggyback files for 'myserver01'. Skip processing.
[PiggybackFetcher] Execute data source
+ PARSE FETCHER RESULTS
Received no piggyback data
+ EXECUTING HOST LABEL DISCOVERY
+ PERFORM HOST LABEL DISCOVERY
+ EXECUTING DISCOVERY PLUGINS (42)
SUCCESS - Found no new services, 2 host labels
myserver02:
+ FETCHING DATA
Using data from cache file /omd/sites/mysite/tmp/check_mk/cache/myserver02
[TCPFetcher] Use cached data
No piggyback files for 'myserver02'. Skip processing.
[PiggybackFetcher] Execute data source
+ PARSE FETCHER RESULTS
Received no piggyback data
+ EXECUTING HOST LABEL DISCOVERY
+ PERFORM HOST LABEL DISCOVERY
+ EXECUTING DISCOVERY PLUGINS (1900)
SUCCESS - Found no new services, 2 host labels
```
:::
::::

::: paragraph
Sie können nach dem `-I` auch einen oder mehrere Host-Namen angeben, um
nur diese zu untersuchen. Das hat gleich noch einen zweiten Effekt.
Während ein `-I` auf allen Hosts grundsätzlich nur mit
**zwischengespeicherten** Daten arbeitet, holt Checkmk bei der
expliziten Angabe von einem Host immer **frische** Daten!
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vI myserver01
```
:::
::::

::: paragraph
Alternativ können Sie über Tags filtern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vI @mytag
```
:::
::::

::: paragraph
Damit würde das Discovery für alle Hosts mit dem Host-Merkmal `mytag`
durchgeführt. Filtern mit Tags steht für alle cmk-Optionen zur
Verfügung, die mehrere Hosts akzeptieren.
:::

::: paragraph
Mit den Optionen `--cache` bzw. `--no-cache` können Sie die Verwendung
von Cache auch explizit bestimmen.
:::

::: paragraph
Zusätzliche Ausgaben bekommen Sie mit einem zweiten `-v`. Bei
SNMP-basierten Geräten können Sie dann sogar jede einzelne OID sehen,
die vom Gerät geholt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vvI myswitch01
Discovering services on myswitch01:
myswitch01:
  SNMP scan:
       Getting OID .1.3.6.1.2.1.1.1.0: Executing SNMP GET of .1.3.6.1.2.1.1.1.0 on switch
=> ['24G Managed Switch'] OCTETSTR
24G Managed Switch
       Getting OID .1.3.6.1.2.1.1.2.0: Executing SNMP GET of .1.3.6.1.2.1.1.2.0 on switch
=> ['.1.3.6.1.4.1.11863.1.1.3'] OBJECTID
.1.3.6.1.4.1.11863.1.1.3
       Getting OID .1.3.6.1.4.1.231.2.10.2.1.1.0: Executing SNMP GET of .1.3.6.1.4.1.231.2.10.2.1.1.0 on switch
=> [None] NOSUCHOBJECT
failed.
       Getting OID .1.3.6.1.4.1.232.2.2.4.2.0: Executing SNMP GET of .1.3.6.1.4.1.232.2.2.4.2.0 on switch
=> [None] NOSUCHOBJECT
failed.
```
:::
::::

::: paragraph
Ein komplettes Erneuern der Services (Tabula Rasa) machen Sie mit einem
Doppel- `-II`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vII myserver01
Discovering services and host labels on: myserver01
myserver01:
+ FETCHING DATA
Using data from cache file /omd/sites/mysite/tmp/check_mk/cache/myserver01
[TCPFetcher] Use cached data
No piggyback files for 'myserver01'. Skip processing.
No piggyback files for '127.0.0.1'. Skip processing.
[PiggybackFetcher] Execute data source
+ PARSE FETCHER RESULTS
Received no piggyback data
+ EXECUTING HOST LABEL DISCOVERY
+ PERFORM HOST LABEL DISCOVERY
+ EXECUTING DISCOVERY PLUGINS (10)
    1 cpu.loads
    1 cpu.threads
    6 cups_queues
    3 df
    1 diskstat
    3 kernel
    1 kernel.util
    3 livestatus_status
    1 lnx_if
    1 lnx_thermal
SUCCESS - Found 21 services, 2 host labels
```
:::
::::

::: paragraph
Sie können das Ganze auch auf ein einzelnes Check-Plugin einschränken.
Die Option dazu lautet `--detect-plugins=` und muss vor dem Host-Namen
stehen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
cmk -vII --detect-plugins=df myserver01
Discovering services and host labels on: myserver01
myserver01:
+ FETCHING DATA
[TCPFetcher] Execute data source
No piggyback files for 'myserver01'. Skip processing.
No piggyback files for '127.0.0.1'. Skip processing.
[PiggybackFetcher] Execute data source
+ PARSE FETCHER RESULTS
Received no piggyback data
+ EXECUTING HOST LABEL DISCOVERY
+ PERFORM HOST LABEL DISCOVERY
+ EXECUTING DISCOVERY PLUGINS (1)
  3 df
SUCCESS - Found 3 services, no host labels
```
:::
::::

::: paragraph
Wenn Sie fertig sind, können Sie mit `cmk -O` (bei Nagios als Kern
`cmk -R`) die Änderungen aktivieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -O
Generating configuration for core (type cmc)...OK
Creating helper config...OK
Reloading monitoring core...OK
```
:::
::::

::: paragraph
Und wenn Sie mal bei einer Discovery auf einen Fehler stoßen ...​
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vII --detect-plugins=df myserver01
  WARNING: Exception in discovery function of check type 'df': global name 'bar' is not defined
  nothing
```
:::
::::

::: paragraph
 ... dann können Sie mit einem zusätzlichen `--debug` einen genauen
Python Aufrufstapel (*stack trace*) der Fehlerstelle bekommen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --debug -vII --detect-plugins=df myserver01
Discovering services and host labels on myserver01:
myserver01:
Traceback (most recent call last):
  File "/omd/sites/heute/share/check_mk/modules/check_mk.py", line 5252, in <module>
    do_discovery(hostnames, check_types, seen_I == 1)
  File "/omd/sites/heute/share/check_mk/modules/discovery.py", line 76, in do_discovery
    do_discovery_for(hostname, check_types, only_new, use_caches, on_error)
  File "/omd/sites/heute/share/check_mk/modules/discovery.py", line 96, in do_discovery_for
    new_items = discover_services(hostname, check_types, use_caches, do_snmp_scan, on_error)
  File "/omd/sites/heute/share/check_mk/modules/discovery.py", line 677, in discover_services
    for item, paramstring in discover_check_type(hostname, ipaddress, check_type, use_caches, on_error):
  File "/omd/sites/heute/share/check_mk/modules/discovery.py", line 833, in discover_check_type
    discovered_items = discovery_function(info)
  File "/omd/sites/heute/share/check_mk/checks/df", line 91, in inventory_df
    foo = bar
NameError: global name 'bar' is not defined
```
:::
::::

:::: sect2
### []{#_optionen_im_überblick .hidden-anchor .sr-only}9.1. Optionen im Überblick {#heading__optionen_im_überblick}

::: paragraph
Hier noch mal alle Optionen auf einen Blick:
:::

+-----------------+-----------------------------------------------------+
| `cmk -I`        | Neue Services erkennen.                             |
+-----------------+-----------------------------------------------------+
| `cmk -II`       | Alle Services verwerfen und neu erkennen (Tabula    |
|                 | Rasa).                                              |
+-----------------+-----------------------------------------------------+
| `-v`            | Verbose: Hosts und gefundene Services anzeigen.     |
+-----------------+-----------------------------------------------------+
| `-vv`           | Very verbose: genaues Protokoll von allen           |
|                 | Operationen anzeigen.                               |
+-----------------+-----------------------------------------------------+
| `--dete         | Erkennung (und auch Tabula Rasa) nur für das        |
| ct-plugins=foo` | gewählte Check-Plugin durchführen.                  |
+-----------------+-----------------------------------------------------+
| `@foo`          | Erkennung (und auch Tabula Rasa) nur für Hosts mit  |
|                 | dem gewählten Host-Merkmal durchführen.             |
+-----------------+-----------------------------------------------------+
| `--cache`       | Verwendung von Cache-Dateien erzwingen (sonst nur   |
|                 | bei fehlender Host-Angabe).                         |
+-----------------+-----------------------------------------------------+
| `--no-cache`    | Frische Daten holen (sonst nur bei Angabe von       |
|                 | Host-Name).                                         |
+-----------------+-----------------------------------------------------+
| `--debug`       | Im Fehlerfall abbrechen und den kompletten          |
|                 | Aufrufstapel von Python anzeigen.                   |
+-----------------+-----------------------------------------------------+
| `cmk -O`        | Änderungen aktivieren (kommerzielle Editionen mit   |
|                 | CMC als Kern).                                      |
+-----------------+-----------------------------------------------------+
| `cmk -R`        | Änderungen aktivieren (Checkmk Raw bzw. Nagios als  |
|                 | Kern).                                              |
+-----------------+-----------------------------------------------------+
::::

::::::: sect2
### []{#_speicherung_in_dateien .hidden-anchor .sr-only}9.2. Speicherung in Dateien {#heading__speicherung_in_dateien}

::: paragraph
Das *Ergebnis* der Service-Erkennung --- also die eingangs genannte
Tabelle von Host-Name, Check-Plugin, Item und erkannten
Parametern --- finden Sie im Verzeichnis `var/check_mk/autochecks`. Dort
existiert für jeden Host eine Datei, welche die automatisch erkannten
Services speichert. Solange Sie die Python-Syntax der Datei nicht
verletzen, können Sie einzelne Zeilen auch von Hand löschen oder ändern.
Ein Löschen der Datei entfernt alle Services und setzt diese quasi
wieder auf „unmonitored".
:::

::::: listingblock
::: title
var/check_mk/autochecks/myserver01.mk
:::

::: content
``` {.pygments .highlight}
[
  {'check_plugin_name': 'cpu_loads', 'item': None, 'parameters': (5.0, 10.0), 'service_labels': {}},
  {'check_plugin_name': 'cpu_threads', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'diskstat', 'item': 'SUMMARY', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'kernel_performance', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'kernel_util', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'livestatus_status', 'item': 'myremotesite', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'lnx_thermal', 'item': 'Zone 0', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'mem_linux', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'mknotifyd', 'item': 'mysite', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'mknotifyd', 'item': 'myremotesite', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'mounts', 'item': '/', 'parameters': ['errors=remount-ro', 'relatime', 'rw'], 'service_labels': {}},
  {'check_plugin_name': 'omd_apache', 'item': 'mysite', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'omd_apache', 'item': 'myremotesite', 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'tcp_conn_stats', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'timesyncd', 'item': None, 'parameters': {}, 'service_labels': {}},
  {'check_plugin_name': 'uptime', 'item': None, 'parameters': {}, 'service_labels': {}},
]
```
:::
:::::
:::::::
::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#service_groups .hidden-anchor .sr-only}10. Servicegruppen {#heading_service_groups}

::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_wofür_servicegruppen .hidden-anchor .sr-only}10.1. Wofür Servicegruppen? {#heading__wofür_servicegruppen}

::: paragraph
Bis hierher haben Sie erfahren, wie Sie Services ins Monitoring
aufnehmen. Nun macht es wenig Sinn, sich Listen mit Tausenden Services
anzuschauen oder immer über Host-Ansichten zu gehen. Wenn Sie
beispielsweise alle Dateisystem- oder Update-Services gemeinsam
beobachten wollen, können Sie in ähnlicher Weise Gruppen bilden, wie das
mit [Host-Gruppen](glossar.html#host_group) möglich ist.
:::

::: paragraph
Servicegruppen ermöglichen Ihnen auf einfach Art, über
[Ansichten](views.html) und NagVis-Karten deutlich mehr Ordnung ins
Monitoring zu bringen und gezielte
[Benachrichtigungen](notifications.html) und [Alert
Handler](alert_handlers.html) zu schalten. Übrigens: Sie könnten
entsprechende Ansichten fast immer auch rein über die Ansichten-Filter
konstruieren --- Servicegruppen sind aber einfacher und übersichtlicher
zu handeln.
:::
:::::

::::::::: sect2
### []{#_servicegruppen_anlegen .hidden-anchor .sr-only}10.2. Servicegruppen anlegen {#heading__servicegruppen_anlegen}

::: paragraph
Sie finden Servicegruppen unter [Setup \> Services \> Service
groups]{.guihint}.
:::

:::: imageblock
::: content
![wato services service groups add
group](../images/wato_services_service_groups_add_group.png)
:::
::::

::: paragraph
Das Anlegen einer Servicegruppe ist simpel: Legen Sie über [![icon
new](../images/icons/icon_new.png)]{.image-inline} [Add group]{.guihint}
eine neue Gruppe an und vergeben Sie einen später nicht mehr
veränderbaren Namen sowie einen aussagekräftigen Alias.
:::

:::: imageblock
::: content
![wato services add service
group](../images/wato_services_add_service_group.png)
:::
::::
:::::::::

::::::::: sect2
### []{#_services_in_servicegruppe_aufnehmen .hidden-anchor .sr-only}10.3. Services in Servicegruppe aufnehmen {#heading__services_in_servicegruppe_aufnehmen}

::: paragraph
Für die Zuordnung von Services in Servicegruppen benötigen Sie den
[Regelsatz](wato_rules.html#conditions) [Assignment of services to
service groups]{.guihint}. In der Übersicht Ihrer Servicegruppen ([Setup
\> Services \> Service Groups]{.guihint}), finden Sie diese Regel am
schnellsten und zwar über die Menüleiste und dort die Punkte [Service
Groups \> Assign to group \> Rules]{.guihint}. Alternativ können Sie die
Regel natürlich auch über die Regelsuche im [Setup]{.guihint}-Menü
finden, oder sich über [Setup \> Services \> Service monitoring rules \>
Various \> Assignment of services to service groups]{.guihint}
durchklicken. Erstellen Sie nun über [Create rule in folder]{.guihint}
eine neue Regel im gewünschten Ordner. Zunächst legen Sie fest, welcher
Servicegruppe Services zugeordnet werden sollen, hier beispielsweise
*myservicegroup* beziehungsweise dessen Alias *My service group 1.*
:::

:::: imageblock
::: content
![wato services servicegroups rule
assignment](../images/wato_services_servicegroups_rule_assignment.png)
:::
::::

::: paragraph
Der spannende Teil folgt nun im Bereich [Conditions]{.guihint}. Zum
einen dürfen Sie hier über Ordner, Host-Merkmale und explizite
Host-Namen Einschränkungen abseits der Services vornehmen. Zum anderen
nennen Sie eben die Services, die Sie gerne gruppiert hätten,
beispielsweise `Filesystem` und `myservice`, um eine Gruppe mit
Dateisystemen zu erstellen. Die Angabe der Services erfolgt hier in Form
[Regulärer Ausdrücke](regexes.html). So können Sie Gruppen ganz exakt
definieren.
:::

:::: imageblock
::: content
![wato services servicegroups rule
conditions](../images/wato_services_servicegroups_rule_conditions.png)
:::
::::
:::::::::

:::::: sect2
### []{#_servicegruppen_eines_services_prüfen .hidden-anchor .sr-only}10.4. Servicegruppen eines Services prüfen {#heading__servicegruppen_eines_services_prüfen}

::: paragraph
Die Zuordnungen von Services können Sie auf der Detailseite eines
jeweiligen Service prüfen. Hier finden Sie, standardmäßig weit unten,
die Zeile [Service groups the service is member of]{.guihint}.
:::

:::: imageblock
::: content
![wato services servicegroups service
detail](../images/wato_services_servicegroups_service_detail.png)
:::
::::
::::::

::::::::::::: sect2
### []{#_servicegruppen_einsetzen .hidden-anchor .sr-only}10.5. Servicegruppen einsetzen {#heading__servicegruppen_einsetzen}

::: paragraph
Zum Einsatz kommen die Servicegruppen wie bereits erwähnt an mehreren
Stellen: [Ansichten](views.html), NagVis-Karten,
[Benachrichtigungen](notifications.html) und [Alert
Handler](alert_handlers.html). Bei neuen Ansichten ist hier wichtig,
dass Sie als Datenquelle die [Service groups]{.guihint} setzen. Im
[Views]{.guihint}-Widget finden Sie natürlich auch vordefinierte
Ansichten für Servicegruppen, zum Beispiel eine übersichtliche
Zusammenfassung:
:::

:::: imageblock
::: content
![wato services servicegroups view
summary](../images/wato_services_servicegroups_view_summary.png)
:::
::::

::: paragraph
Mit einem Klick auf die Servicegruppennamen gelangen Sie zur
vollständigen Ansicht aller Services der jeweiligen Gruppe.
:::

::: paragraph
Wenn Sie Servicegruppen in NagVis-Karten einsetzen, bekommen Sie als
Ergebnis beispielsweise Zusammenfassungen von Servicegruppen per
Hover-Menü über ein einzelnes Icon:
:::

:::: imageblock
::: content
![wato services servicegroups nagvis
example](../images/wato_services_servicegroups_nagvis_example.png)
:::
::::

::: paragraph
Wenn Sie Servicegruppen in [Benachrichtigungen](notifications.html) und
[Alert Handlers](alert_handlers.html) nutzen, stehen sie als
[Bedingungen/Filter](wato_rules.html#conditions) zur Verfügung, von
denen Sie einen oder mehrere nutzen können:
:::

:::: imageblock
::: content
![wato services servicegroups notification
rule](../images/wato_services_servicegroups_notification_rule.png)
:::
::::
:::::::::::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

::::::::::::: sect1
## []{#checkplugins .hidden-anchor .sr-only}11. Mehr über Check-Plugins {#heading_checkplugins}

:::::::::::: sectionbody
:::: sect2
### []{#_kurze_beschreibung_der_funktionsweise .hidden-anchor .sr-only}11.1. Kurze Beschreibung der Funktionsweise {#heading__kurze_beschreibung_der_funktionsweise}

::: paragraph
Check-Plugins werden benötigt, um die Services in Checkmk zu erstellen.
Jeder Service greift auf ein Check-Plugin zurück, um seinen Status zu
ermitteln, Metriken zu erstellen/pflegen usw. Dabei kann ein solches
Plugin einen oder mehrere Services pro Host erstellen. Damit mehrere
Services vom gleichen Plugin unterschieden werden können, wird ein
**Item** benötigt. So ist z.B. beim Service `Filesystem /var` das Item
der Text `/var`. Bei Plugins, die pro Host maximal einen Service anlegen
können (z.B. `CPU utilization`), ist das Item leer und nicht sichtbar.
:::
::::

::::::::: sect2
### []{#_verfügbare_check_plugins .hidden-anchor .sr-only}11.2. Verfügbare Check-Plugins {#heading__verfügbare_check_plugins}

::: paragraph
Eine Liste aller verfügbaren Check-Plugins finden Sie unter [Setup \>
Services \> Catalog of check plugins]{.guihint}. Hier können Sie nach
verschiedenen Kategorien gefiltert die einzelnen Plugins durchsuchen:
:::

:::: imageblock
::: content
![wato services catalog of check
plugins](../images/wato_services_catalog_of_check_plugins.png)
:::
::::

::: paragraph
Zu jedem Plugin werden drei Spalten ausgegeben, die die
Servicebeschreibung (Type of Check), den Namen des Check-Plugins (Plugin
Name) und die kompatiblen Datenquellen (Agents) enthalten:
:::

:::: imageblock
::: content
![wato services catalog of check plugins
telephony](../images/wato_services_catalog_of_check_plugins_telephony.png)
:::
::::
:::::::::
::::::::::::
:::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
