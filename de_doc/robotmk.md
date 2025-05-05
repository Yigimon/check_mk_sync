:::: {#header}
# Checkmk Synthetic Monitoring mit Robotmk

::: details
[Last modified on 25-Jul-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/robotmk.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Monitoring-Agenten](wato_monitoringagents.html) [Automatische
Agenten-Updates](agent_deployment.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Synthetisches Monitoring mit Robot Framework {#heading_intro}

:::::::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Checkmk Synthetic
Monitoring ist in den kommerziellen Checkmk-Editionen verfügbar,
benötigt jedoch eine [zusätzliche
Subskription.](https://checkmk.com/request-quote/synthetic-monitoring){target="_blank"}
Sie können die Funktion allerdings mit bis zu drei Tests kostenlos und
ohne Zeitbegrenzung testen.
:::

::: paragraph
Mit Checkmk können Sie Ihre eigene Infrastruktur sehr genau
überwachen --- bis hin zur Frage, ob ein bestimmter Service,
beispielsweise ein Webserver, ordentlich läuft. Wird Ihre Website über
einen Cloud-Service von Dritten betrieben, werden Sie keinen Zugriff auf
den Service selbst haben, können aber über einen HTTP-Check prüfen, ob
die Website erreichbar ist. Aber was sagt das über die Nutzererfahrung
aus? Dass ein Online-Shop erreichbar ist, heißt ja noch nicht, dass die
Navigation, Bestellprozesse und dergleichen reibungslos funktionieren.
:::

::: paragraph
An dieser Stelle setzt das Checkmk Synthetic Monitoring an. Mit dem
Plugin Robotmk bietet Checkmk echtes End-to-End-Monitoring, also die
Überwachung laufender Anwendungen aus Sicht der Nutzer. Das eigentliche
Testen übernimmt dabei die Open-Source-Software [Robot
Framework](https://robotframework.org/){target="_blank"} --- in deren
Trägerverein auch die Checkmk GmbH Mitglied ist.
:::

::: paragraph
Mit der Automationssoftware lässt sich Nutzerverhalten komplett
automatisieren, um beispielsweise Bestellprozesse in Online-Shops Klick
für Klick nachzustellen. Das Besondere an Robot Framework: Tests werden
nicht in einer vollwertigen Programmiersprache geschrieben, sondern über
einfach zu verwendende Keywords definiert, wie `Open Browser` oder
`Click Button`. So genügt ein `Open Browser checkmk.com` zum Aufrufen
der Checkmk-Website. Mehrere Testfälle werden dann in so genannten
Test-Suites zusammengefasst (in Form einer `.robot`-Datei).
:::

::: paragraph
Robotmk kann nun diese Robot-Framework-Test-Suites auf dem Host triggern
und ihre Ausführung und Resultate als Services in Checkmk überwachen. In
der Checkmk-Weboberfläche finden Sie dann Status, zugehörige
Performance-Graphen sowie die Original-Auswertungen von Robot Framework
selbst.
:::

:::::::::::::::: sect2
### []{#_komponenten .hidden-anchor .sr-only}1.1. Komponenten {#heading__komponenten}

::: paragraph
Für dieses End-to-End-Monitoring spielen allerhand Komponenten zusammen,
daher hier ein kurzer Überblick.
:::

::::::::: sect3
#### []{#_checkmk_server .hidden-anchor .sr-only}Checkmk-Server {#heading__checkmk_server}

::: paragraph
Checkmk Synthetic Monitoring wird über Robotmk realisiert, das ein
Agentenplugin als Datensammler nutzt und den Robotmk-Scheduler (auf dem
überwachten Host) für das Triggern von Robot-Framework-Projekten.
Aktiviert und konfiguriert wird das synthetische Monitoring über die
Regel [Robotmk Scheduler]{.guihint}. Hier legen Sie fest, welche
Test-Suites ausgeführt werden sollen und wie exakt Robot Framework diese
starten soll --- zusammengefasst in einem *Plan.* Einmal ausgerollt,
sorgt der Robotmk-Scheduler auf dem Ziel-Host für die planmäßige
Ausführung Ihrer Robot-Framework-Suites.
:::

::: paragraph
Im Monitoring bekommen Sie letztlich mehrere neue Services: [RMK
Scheduler Status]{.guihint} zeigt den Status des Schedulers selbst, also
ob Test-Suites erfolgreich gestartet werden konnten. Hinzu kommen
Services für alle konfigurierten Test-Pläne (etwa [RMK MyApp1
Plan]{.guihint}) und einzelnen Tests aus Test-Suites (etwa [RMK MyApp1
Test]{.guihint}). Zu den Services der einzelnen Tests gehören auch die
originalen Robot-Framework-Berichte.
:::

::: paragraph
Zu guter Letzt gibt es noch zwei optionale Service-Regeln: [Robotmk
plan]{.guihint} und [Robotmk test]{.guihint} sorgen für die
Feineinstellung der Plan- und Test-Services --- beispielsweise um
Statuswechsel bei bestimmten Laufzeiten zu erwirken.
:::

::::: imageblock
::: content
![Robotmk-Regeln im Setup-Menü.](../images/robotmk_services_menu.png)
:::

::: title
Die Robotmk-Regeln in Checkmk
:::
:::::
:::::::::

::::::: sect3
#### []{#_testmaschine .hidden-anchor .sr-only}Testmaschine {#heading__testmaschine}

::: paragraph
Die Robot-Framework-Test-Suites müssen Sie auf einem **Windows-Host**
bereit stellen. Für die Ausführung benötigt Robot Framework Zugriff auf
deren Abhängigkeiten (Python, Bibliotheken, Treiber für die
Browser-Automation und so weiter). Diese Konfiguration ist unabhängig
von Checkmk und kann deklarativ in einem portablen Paket abgelegt
werden. Dies übernimmt das Open-Source-Kommandozeilenwerkzeug
[RCC.](https://github.com/robocorp/rcc){target="_blank"} Dieses baut
anhand Ihrer Konfigurationsdateien im YAML-Format virtuelle
Python-Umgebungen samt Abhängigkeiten und Robot Framework selbst. Der
als Hintergrundprozess laufende Robotmk-Scheduler stößt diesen Bau an
und sorgt anschließend selbst für die Ausführung der Tests.
:::

::: paragraph
Ein solches *RCC-Automationspaket* mit der Paketkonfiguration
(`robot.yaml`), der Definition der Ausführungsumgebung (`conda.yaml`)
und den Test-Suites (`tests.robot`) wird auch *Roboter* genannt. RCC und
der Scheduler werden mit dem Checkmk-Agenten ausgerollt, das
Automationspaket muss auf dem Host bereitstehen.
:::

::: paragraph
Der große Vorteil von RCC: Der ausführende Windows-Host selbst benötigt
keine konfigurierte Python-Umgebung.
:::

::: paragraph
Der Agent selbst wird nur für die Übertragung von Ergebnissen,
Protokollen und Screenshots benötigt. Dies ermöglicht auch die
Überwachung sehr lange laufender oder lokal sehr ressourcenintensiver
Suites -- vorausgesetzt, Ihr Windows-Host verfügt über entsprechende
Kapazitäten.
:::
:::::::
::::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#ruleconfig .hidden-anchor .sr-only}2. Test-Suites überwachen mit Robotmk {#heading_ruleconfig}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im Folgenden zeigen wir, wie Sie eine Test-Suite ins Monitoring
aufnehmen. Als Beispiel dient dazu eine simple Hello-World-Suite, die
lediglich zwei Strings ausgibt und dazwischen kurz wartet. Eine
Einführung in Robot Framework ist hier freilich nicht das Thema, ein
kurzer Blick in das Automationspaket und die Demo-Test-Suite muss aber
sein, damit Sie sehen, welche Daten wo im Monitoring landen.
:::

::: paragraph
Das Beispiel läuft auf Basis von RCC, so dass der Windows-Host nicht
extra konfiguriert werden muss. Die `rcc.exe` wird mit dem Agenten
ausgerollt und findet sich unter `C:\ProgramData\checkmk\agent\bin\`.
Die Beispiel-Suite können Sie als ZIP-Datei [über
GitHub](https://github.com/Checkmk/robotmk-examples/blob/main/templates/minimal.zip){target="_blank"}
herunterladen. Das Verzeichnis der Suite:
:::

::::: listingblock
::: title
C:\\robots\\mybot\\
:::

::: content
``` {.pygments .highlight}
conda.yaml
robot.yaml
tests.robot
```
:::
:::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | RCC kann grundsätzlich auch       |
|                                   | Test-Suites auf Basis etlicher    |
|                                   | anderer Programmiersprachen       |
|                                   | verarbeiten, für den Einsatz in   |
|                                   | Checkmk muss es aber die          |
|                                   | Deklaration nach Robot Framework  |
|                                   | sein.                             |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Das Suite-Dateiverzeichnis beinhaltet nun zwei wichtige Dateien: Die
Deklaration der für die Ausführung benötigten Umgebung in der Datei
`conda.yaml` und die eigentlichen Tests in der Datei `tests.robot` (die
Suite). Die Datei `robot.yaml` ist für den Einsatz in Checkmk nicht
relevant, wird aber von RCC benötigt.
:::

::: paragraph
Der Vollständigkeit halber, hier ein kurzer Blick in die Datei
`robot.yaml`:
:::

::::: listingblock
::: title
C:\\robots\\mybot\\robot.yaml
:::

::: content
``` {.pygments .highlight}
tasks:
  task1:
    # (task definitions are not required by Robotmk,
    but expected by RCC to be compatible with other Robocorp features)
    shell: echo "nothing to do"

environmentConfigs:
  - conda.yaml

artifactsDir: output
```
:::
:::::

::: paragraph
Zu Beginn legt `tasks` fest, welche Aufgaben, sprich Tests, überhaupt
ausgeführt werden sollen. Allerdings wird dieser Part zwar von RCC
formal vorausgesetzt, von Robotmk jedoch nicht benötigt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Robot Framework unterscheidet     |
|                                   | zwischen Tests und Tasks, die für |
|                                   | Automatisierungen stehen.         |
|                                   | Allerdings werden beide exakt     |
|                                   | gleich verwendet.                 |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Im Bereich `environmentConfigs` wird dann lediglich auf die `conda.yaml`
verwiesen, die sich um die eigentliche Umgebung kümmert.
:::

::: paragraph
Für die Umgebung werden in diesem Fall lediglich die Abhängigkeiten
Python, Pip und Robot Framework installiert. Im Monitoring taucht der
Umgebungsbau später als [RCC environment build status]{.guihint} auf.
Nur wenn die Umgebung erfolgreich gebaut wird, können auch die Tests
abgearbeitet und folglich überwacht werden.
:::

::::: listingblock
::: title
C:\\robots\\mybot\\conda.yaml
:::

::: content
``` {.pygments .highlight}
channels:
  - conda-forge

dependencies:
  - python=3.10.12
  - pip=23.2.1
  - pip:
     - robotframework==7.0
```
:::
:::::

::: paragraph
Die eigentliche Test-Suite sieht nun wie folgt aus:
:::

::::: listingblock
::: title
C:\\robots\\mybot\\tests.robot
:::

::: content
``` {.pygments .highlight}
*** Settings ***
Documentation       Template robot main suite.

*** Variables ***
${MYVAR}    Hello Checkmk!

*** Test Cases ***
My Test
    Log      ${MYVAR}
    Sleep    3
    Log      Done.
```
:::
:::::

::: paragraph
Hier wird also lediglich der Wert der Variablen `MYVAR` ausgegeben, dann
3 Sekunden gewartet und abschließend `Done` ausgegeben. Den Wert der
Variablen können Sie später in der Checkmk-Weboberfläche
setzen --- ansonsten wird der hier gesetzte Standard `Hello Checkmk!`
genutzt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Sie können diese Test-Suite       |
|                                   | manuell ausführen. Dafür muss der |
|                                   | Agent samt RCC bereits            |
|                                   | installiert sein (oder Sie laden  |
|                                   | die RCC-Binary selbst herunter).  |
|                                   | Navigieren Sie zunächst in Ihr    |
|                                   | Test-Suite-Dateiverzeichnis, in   |
|                                   | dem auch die `tests.robot` liegt. |
|                                   | Starten Sie dann die RCC-Shell    |
|                                   | mit                               |
|                                   | `C:\ProgramData\check             |
|                                   | mk\agent\bin\rcc.exe task shell`. |
|                                   | Daraufhin wird die in der         |
|                                   | `conda.yaml` definierte virtuelle |
|                                   | Umgebung gebaut. Anschließend     |
|                                   | starten Sie die Suite mit         |
|                                   | `robot tests.robot`.              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Und genau diese Ausführung übernimmt der Robotmk-Scheduler, sobald das
Agentenplugin aktiv ist.
:::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#agentconfig .hidden-anchor .sr-only}2.1. Regel für das Agentenplugin konfigurieren {#heading_agentconfig}

::: paragraph
Den Robotmk-Scheduler finden Sie unter [Setup \> Agent rules \> Robotmk
scheduler (Windows).]{.guihint} Da die Regel recht umfangreich ist, hier
zunächst ein Blick auf die noch leere Konfiguration:
:::

::::: imageblock
::: content
![Leere Robotmk-Scheduler-Regel.](../images/robotmk_scheduler_00.png)
:::

::: title
Konfiguration des Agentenplugins
:::
:::::

::: paragraph
Zunächst benötigt der Scheduler die Angabe des Basisverzeichnisses, in
dem all Ihre Test-Suites liegen. Tragen Sie diesen beliebigen, absoluten
Pfad unter [Base directory of suites]{.guihint} ein, beispielsweise
`C:\robots`.
:::

::::: imageblock
::: content
![Pfad für Test-Suites.](../images/robotmk_scheduler_01.png)
:::

::: title
Basisverzeichnis für alle Robot-Framework-Projekte
:::
:::::

::: paragraph
Mit [Parallel plan groups]{.guihint} folgt nun ein Checkmk-eigenes
Konzept.
:::

::: paragraph
Zur Erklärung müssen wir zunächst eine Hierarchieebene tiefer gehen:
Hier sehen Sie den Punkt [Sequential plans.]{.guihint} Ein solcher
sequenzieller Plan legt fest, welche Suites mit welchen Parametern
ausgeführt werden sollen. Und Robot Framework arbeitet diese Suites dann
nacheinander ab. Der Grund ist simpel: In der Praxis geht es manchmal um
Tests, die auf dem Desktop ausgeführt werden und da könnten sich mehrere
Test-Suites gleichzeitig in die Quere kommen (sich gegenseitig \"die
Maus klauen\").
:::

::: paragraph
Die Plangruppen sind nun eine Kapselung für sequenziell ausgeführte
Pläne --- und werden selbst parallel ausgeführt. Auch hier ist der Grund
simpel: So können Test-Suites, die eben nicht auf den Desktop angewiesen
sind, ohne Verzögerung in eigenen Plänen ausgeführt werden --- wie zum
Beispiel die hier im Artikel eingesetzte Test-Suite.
:::

::: paragraph
Wieder zurück zum Dialog: Die einzige explizite Einstellung ist das
Ausführungsintervall, das Sie unter [Group execution interval]{.guihint}
setzen.
:::

::::: imageblock
::: content
![Ausführungsintervall für
Ausführungsgruppen.](../images/robotmk_scheduler_02.png)
:::

::: title
Intervall für die (parallele) Ausführung von Plangruppen
:::
:::::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Die Pläne in der Plangruppe haben |
|                                   | natürlich selbst eine gewisse     |
|                                   | Laufzeit, bestimmt durch den      |
|                                   | Timeout einer einzelnen           |
|                                   | Ausführung und die maximale       |
|                                   | Anzahl wiederholter Ausführungen  |
|                                   | im Falle fehlgeschlagener Tests.  |
|                                   | Das Ausführungsintervall der      |
|                                   | Plangruppe muss folglich größer   |
|                                   | sein als die Summe der maximalen  |
|                                   | Laufzeiten aller Pläne in der     |
|                                   | Gruppe. Die maximale Laufzeit     |
|                                   | eines Plans berechnet sich wie    |
|                                   | folgt: [Limit per                 |
|                                   | attempt]{.guihint} × (1 +         |
|                                   | [Maximum number of                |
|                                   | re-executions]{.guihint}).        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Nun geht es an die Konfiguration eines ersten Plans. Unter [Application
name]{.guihint} können Sie einen beliebigen Namen eingeben. Dieser Name
muss nicht eindeutig sein! Sinnvoll ist hier der Name der zu
überwachenden Anwendung, beispielsweise `OnlineShop` oder hier im
Beispiel schlicht `MyApplication`. Nun kann es natürlich vorkommen, dass
eben dieser Online-Shop mehrfach getestet wird, sei es durch andere
Test-Suites oder dieselbe Test-Suite mit unterschiedlichen Parametern.
Um in solchen Fällen trotz identischer Namen dennoch eine Eindeutigkeit
in den Ergebnissen zu erzielen, gibt es das Feld [Variant.]{.guihint}
Wird die Anwendung `OnlineShop` etwa einmal auf Deutsch und einmal auf
Englisch getestet (über entsprechende Parameter), könnten Sie hier
entsprechende Kürzel verwenden. Im Monitoring gibt es dann Ergebnisse
für `My OnlineShop_de` und `My OnlineShop_en.`
:::

::: paragraph
Notwendig ist hingegen die Angabe unter [Relative path to test suite
file or folder.]{.guihint} Die Pfadangabe ist relativ zum oben
angegebenen Basisverzeichnis, also beispielsweise `mybot\test.robot` für
`C:\robots\`. Alternativ kann hier auch ein ein Verzeichnis (mit
mehreren `robot`-Dateien) angegeben werden, dann wäre es schlicht
`mybot`.
:::

::::: imageblock
::: content
![Bezeichnung und Pfad der Suite.](../images/robotmk_scheduler_03.png)
:::

::: title
Plan für die Ausführung von Suiten
:::
:::::

::: paragraph
Weiter geht es mit der [Execution configuration.]{.guihint} Unter [Limit
per attempt]{.guihint} legen Sie fest, wie lange eine Test-Suite maximal
laufen darf --- pro Versuch. Mit [Robot Framework
re-executions]{.guihint} können Sie nun Robot Framework anweisen,
Test-Suites bei fehlgeschlagenen Tests komplett oder inkrementell zu
wiederholen. Wenn die einzelnen Tests einer Test-Suite unabhängig
voneinander sind, bietet sich die inkrementelle Strategie an, um Zeit zu
sparen. Testet die Test-Suite hingegen eine logische Abfolge, etwa
\"Login → Aufruf Produktseite → Produkt in den Warenkorb → Checkout\",
muss die Test-Suite natürlich komplett neu abgearbeitet werden. Am Ende
gibt es immer nur ein Ergebnis.
:::

::: paragraph
Bei kompletten Wiederholungen werden für das Endergebnis nur in sich
abgeschlossene Suite-Ergebnisse berücksichtigt: Schlägt ein Test bei der
letzten Wiederholung fehl, wird die Test-Suite als Fehlschlag gewertet.
Bei inkrementellen Wiederholungen setzt sich das Endergebnis aus den
besten Teilergebnissen zusammen: Laufen einige Tests erst im dritten
Anlauf erfolgreich durch, wird auch das Endergebnis als Erfolg gewertet.
Zur Erinnerung: Die Kombination aus Versuchen und maximalen Laufzeiten
aller Pläne einer Plangruppe bestimmt deren minimales
Ausführungsintervall.
:::

::::: imageblock
::: content
![Konfiguration von Ausfühungslaufzeiten und
-wiederholungen.](../images/robotmk_scheduler_04.png)
:::

::: title
Fehlgeschlagene Tests/Suiten können wiederholt werden
:::
:::::

::: paragraph
Standardmäßig ist die Ausführung via RCC unter [Automated environment
setup (via RCC)]{.guihint} aktiviert, für die Sie zwei Werte eintragen
müssen. Zum einen benötigt RCC die Angabe, wo die Datei `robot.yaml`
liegt. Deren primärer Zweck ist der Verweis auf die Datei `conda.yaml`,
die für den Aufbau der Python-Umgebung verantwortlich ist, also die
Installation von Python und Abhängigkeiten. Diese Angabe ist relativ zum
Basisverzeichnis, das Sie oben unter [Relative path to test suite file
or folder]{.guihint} gesetzt haben. Die YAML-Dateien können durchaus in
Unterverzeichnissen gespeichert werden, Best-Practice ist aber das
oberste Suite-Verzeichnis. Für das obige Basisverzeichnis `C:\robot\`
und das Suite-Verzeichnis `C:\robot\mybot` ist es entsprechend
`mybot\robot.yaml`.
:::

::: paragraph
Beim folgenden Zeitlimit für den Bau der Python-Umgebung sollten Sie
bedenken, dass bisweilen größere Datenmengen heruntergeladen und
eingerichtet werden müssen. Insbesondere für die benötigten Browser
fallen hier schnell einige Hundert Megabytes an --- allerdings nur beim
ersten Durchlauf. RCC baut Umgebungen nur dann neu auf, wenn sich der
Inhalt der `conda.yaml` geändert hat
:::

::::: imageblock
::: content
![RCC-Konfiguration der Suite.](../images/robotmk_scheduler_05.png)
:::

::: title
Zeitlimit für den Aufbau virtueller Umgebungen
:::
:::::

::: paragraph
Unter [Robot Framework parameters]{.guihint} haben Sie die Möglichkeit,
einige der Kommandozeilenparameter von Robot Framework zu nutzen (die
auch der Befehl `robot --help` anzeigt). Sollten Sie weitere Parameter
nutzen wollen, hilft die Option [Argument files.]{.guihint} Eine hier
angegebene Datei kann beliebige robot-Parameter beinhalten. Weitere
Informationen über die einzelnen Parameter bekommen Sie über die
Inline-Hilfe.
:::

::: paragraph
Für unser Beispielprojekt wird lediglich die Option
[Variables]{.guihint} aktiviert und eine Variable `MYVAR` mit dem Wert
`My Value` gesetzt. Sie erinnern sich an den Befehl `Log ${MYVAR}` oben
in der Datei `tests.robot`? Dies ist die zugehörige Referenz.
:::

::::: imageblock
::: content
![Kommandozeilenparameter von Robot
Framework.](../images/robotmk_scheduler_06.png)
:::

::: title
Einige Optionen des `robot`-Befehls
:::
:::::

::: paragraph
Am Ende der Suite-Konfiguration gibt es noch drei weitgehend
selbsterklärende Optionen. [Execute plan as a specific user]{.guihint}
ermöglicht es, Robotmk im Kontext eines bestimmten Nutzerkontos
auszuführen. Hintergrund: Standardmäßig wird Robotmk im Kontext des
Checkmk-Agenten ausgeführt
([LocalSystem-Konto](https://learn.microsoft.com/de-de/windows/win32/services/localsystem-account){target="_blank"}),
der keine Berechtigung für den Zugriff auf den Desktop hat. Hier kann
nun ein Nutzer angegeben werden, der permanent an einer Desktop-Sitzung
angemeldet sein muss und entsprechend Zugriff auf grafische
Desktop-Anwendungen hat.
:::

::: paragraph
Mit [Assign plan/test result to piggyback host]{.guihint} lassen sich
die Ergebnisse des Plans/Tests einem anderen Host zuweisen. Testet Robot
Framework zum Beispiel den Bestellprozess eines Online-Shops, ließen
sich die Ergebnisse so dem zugehörigen Webserver zuweisen.
:::

::: paragraph
Jeder Testdurchlauf produziert Daten, die unter
`C:\ProgramData\checkmk\agent\robotmk_output\working\suites\` abgelegt
werden. Standardmäßig werden die Ergebnisse der letzten 14 Tage
behalten, allerdings sollten Sie bedenken, dass sich hier schnell große
Datenberge auftürmen. Pro Durchlauf fallen mindestens knapp 500
Kilobytes Daten an --- mit komplexeren Test-Suites und beispielsweise
eingebettete Screenshots können es aber auch schnell einige Megabyte
sein. Je nach Ausführungsintervall, Größe des Reports und Anforderungen
an Ihre Dokumentation, sollten Sie hier eingreifen.
:::

::::: imageblock
::: content
![Optionen für Nutzerkontext, Host-Zuweisung und automatische
Aufräumarbeiten.](../images/robotmk_scheduler_07.png)
:::

::: title
Automatisches Aufräumen der vielen anfallenden Daten
:::
:::::

::: paragraph
Hier angelangt, könnten Sie nun weitere Pläne in dieser Plangruppe oder
weitere Plangruppen erstellen.
:::

::: paragraph
Am Ende warten noch zwei Optionen, die sich wiederum auf die komplette
Robotmk-Scheduler-Konfiguration beziehen.
:::

::: paragraph
[RCC profile configuration]{.guihint} erlaubt die Angabe von
Proxy-Servern sowie davon auszunehmende Hosts.
:::

::: paragraph
Sehr nützlich kann auch [Grace period before scheduler starts]{.guihint}
sein: Der Scheduler startet zusammen mit dem Checkmk-Agenten noch vor
der Desktop-Anmeldung --- was freilich dazu führt, dass etwaige Tests
auf dem Desktop fehlschlagen müssen. Über eine Vorlaufzeit lässt sich
der Start manuell verzögern.
:::

::::: imageblock
::: content
![Optionen für Proxy-Server und eine Vorlaufszeit für den
Scheduler-Start.](../images/robotmk_scheduler_08.png)
:::

::: title
Eine Vorlaufzeit verhindert Fehlschläge
:::
:::::

::: paragraph
Damit ist die Konfiguration abgeschlossen und Sie können einen neuen
[Agenten mit dem Plugin backen](wato_monitoringagents.html#bakery) und
anschließend ausrollen, manuell oder über die [automatischen
Agenten-Updates.](agent_deployment.html)
:::

:::::::: sect3
#### []{#_daten_in_der_agentenausgabe .hidden-anchor .sr-only}Daten in der Agentenausgabe {#heading__daten_in_der_agentenausgabe}

::: paragraph
Die Ausgabe im Agenten ist recht umfangreich: In mehreren Sektionen
werden Fehlermeldungen, Status, Konfiguration und Testdaten übermittelt.
Letztere finden sich in der Sektion `robotmk_suite_execution_report`,
hier ein stark gekürzter Auszug:
:::

::::: listingblock
::: title
mysite-robot-host-agent.txt
:::

::: content
    <<<robotmk_suite_execution_report:sep(0)>>>
    {
        "attempts": [
            {
                "index": 1,
                "outcome": "AllTestsPassed",
                "runtime": 20
            }
        ],
        "rebot": {
            "Ok": {
                "xml": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n
                <robot generator=\"Rebot 6.1.1 (Python 3.10.12 on win32)\"
                generated=\"20240319 16:23:19.944\"
                rpa=\"true\"
                schemaversion=\"4\">\r\n<suite id=\"s1\"
                name=\"Mybot\"
                source=\"C:\\robots\\mybot\">\r\n<suite id=\"s1-s1\"
                name=\"Tests\"
                source=\"C:\\robots\\mybot\\tests.robot\">\r\n<test id=\"s1-s1-t1\"
                name=\"Mytest\"
                line=\"6\">\r\n<kw
                name=\"Sleep\"
                library=\"BuiltIn\">\r\n<arg>3 Seconds</arg>\r\n<doc>Pauses the test executed for the given time.</doc>\r\n<msg
                timestamp=\"20240319 16:23:02.936\"
                level=\"INFO\">Slept 3 seconds</msg>\r\n<status
                status=\"PASS\"
                starttime=\"20240319 16:23:00.934\"
                endtime=\"20240319 16:23:02.936\"/>"
            }
        },
        "suite_id": "mybot",
        "timestamp": 1710861778
    }
    ...
    "html_base64":"PCFET0NUWVBFIGh0bWw+DQo8aHRtbCBsYW ...
:::
:::::

::: paragraph
Interessant sind hier vor allem zwei Bereiche. Zum einen `rebot`: Das
Tool `rebot` hat den eigentlichen Statusbericht für Robot Framework aus
gegebenenfalls mehreren Teilergebnissen (daher auch re-bot) produziert.
Zum anderen die letzte Zeile `html_base64`: Danach folgen die
HTML-Berichte von Robot Framework base64-kodiert. Auch Screenshots, die
über Tests angefertigt werden, werden auf diese Weise
übertragen --- entsprechend umfangreich kann die Ausgabe/Datenmenge im
Agenten werden.
:::
::::::::

:::::::: sect3
#### []{#_daten_im_monitoring .hidden-anchor .sr-only}Daten im Monitoring {#heading__daten_im_monitoring}

::: paragraph
Sobald der Robotmk-Scheduler und die Test-Suite durchgelaufen sind, wird
die [Service-Erkennung](glossar.html#service_discovery) drei neue
Services hervorbringen:
:::

::::: imageblock
::: content
![](../images/robotmk_scheduler_09.png){robotmk-services="" im=""
monitoring.=""}
:::

::: title
Die neu erkannten Robotmk-Services
:::
:::::

::: paragraph
Der Service [RMK Scheduler Status]{.guihint} existiert einmalig und
unmittelbar nach der Verteilung. Die Services für Pläne und Tests, hier
[RMK MyApplication_mybot Plan]{.guihint} und [RMK MyApplication_mybot
Test: /Test: My Test,]{.guihint} kommen ins Monitoring, sobald die
zugehörigen Suites ein erstes Mal durchgelaufen sind.
:::
::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::: sect2
### []{#serviceconfig .hidden-anchor .sr-only}2.2. Service-Regeln konfigurieren {#heading_serviceconfig}

::::::::::: sect3
#### []{#_regel_für_plan_status_anlegen .hidden-anchor .sr-only}Regel für Plan-Status anlegen {#heading__regel_für_plan_status_anlegen}

::: paragraph
Zur Erinnerung: In der Agentenregel oben wurden maximale Laufzeiten für
Pläne festgelegt. Mit der Regel [Robotmk plan]{.guihint} lassen sich
diese Laufzeiten auswerten. So können Sie den Service etwa auf
[CRIT]{.state2} setzen, wenn 90 Prozent aller zusammengerechneten
Timeouts erreicht werden.
:::

::::: imageblock
::: content
![Konfigurationsdialog für Grenzwerte für Laufzeiten von
Test-Suites.](../images/robotmk_service_suite_status_01.png)
:::

::: title
Schwellwerte für Statuswechsel aufgrund von Laufzeiten
:::
:::::

::: paragraph
Im Kasten [Conditions]{.guihint} gibt es die Möglichkeit, die Regel auf
bestimmte Pläne zu beschränken.
:::

::::: imageblock
::: content
![Dialog mit Beschränkung auf die Test-Suite
\'mybot\'.](../images/robotmk_service_suite_status_02.png)
:::

::: title
Optionale Beschränkung auf bestimmte Pläne
:::
:::::
:::::::::::

::::::::::::: sect3
#### []{#_regel_für_test_status_anlegen .hidden-anchor .sr-only}Regel für Test-Status anlegen {#heading__regel_für_test_status_anlegen}

::: paragraph
Auch für einzelne Tests in den Test-Suites lassen sich weitere Daten ins
Monitoring holen, über die Regel [Robotmk test.]{.guihint} Hier finden
Sie wieder die Möglichkeit, Laufzeiten zu überwachen, sowohl von Tests
als auch von Keywords. Die Überwachung von Keywords ist dabei eine
Checkmk-eigene Funktion. Daher könnte auch der Suite-interne Status im
Robot-Framework-Bericht `OK` sein, weil die Test-Suite innerhalb der
maximal erlaubten Laufzeit verarbeitet wurde --- in Checkmk jedoch
[WARN]{.state1} oder [CRIT]{.state2}, weil schon bei zum Beispiel 80
Prozent dieser maximal erlaubten Laufzeit ein Statuswechsel stattfindet.
:::

::: paragraph
Zudem können über die Option [Enable metrics for high-level
keywords]{.guihint} Metriken für übergeordnete Keywords erzeugt werden.
Nützlich ist dies insbesondere dann, wenn Ihre Test so organisiert sind,
dass die übergeordneten Keywords das „Was" beschreiben und die darunter
liegenden Keywords das „Wie" --- so bekommen Sie abstraktere
Auswertungen.
:::

::: paragraph
Hier im Beispiel liegen die Schwellwerte für die maximale Laufzeit eines
Tests bei 2 und 4 Sekunden. Die Auswirkungen werden Sie unten im Kapitel
[Robotmk im Monitoring](#monitoring) sehen.
:::

::::: imageblock
::: content
![Regel zum Überwachen von Keywords mit
Beispielwerten.](../images/robotmk_service_test_status_01.png)
:::

::: title
Über Keyword-Metriken lässt sich das Monitoring ausbauen
:::
:::::

::: paragraph
Abermals gibt es im Kasten [Conditions]{.guihint} eine explizite
Filtermöglichkeit, hier für einzelne Tests.
:::

::::: imageblock
::: content
![Dialog mit Option zur Beschränkung auf
Tests.](../images/robotmk_service_test_status_02.png)
:::

::: title
Optionale Beschränkung auf bestimmte Tests
:::
:::::
:::::::::::::
:::::::::::::::::::::::

::::::::::::::::::::::::::::::::: sect2
### []{#monitoring .hidden-anchor .sr-only}2.3. Robotmk im Monitoring {#heading_monitoring}

::: paragraph
Im Monitoring finden Sie Services für den Status des Robotmk Schedulers
sowie der einzelnen Pläne und Tests --- natürlich auch, wenn sie keine
separaten Service-Regeln angelegt haben.
:::

:::::::: sect3
#### []{#_scheduler_status .hidden-anchor .sr-only}Scheduler-Status {#heading__scheduler_status}

::: paragraph
Der Service [RMK Scheduler Status]{.guihint} ist [OK]{.state0}, wenn der
Scheduler anläuft und erfolgreich die Ausführungsumgebungen bauen
konnte.
:::

::::: imageblock
::: content
![Status des Schedulers im
Monitoring.](../images/robotmk_monitorng_scheduler.png)
:::

::: title
RCC konnte die Umgebungen aufbauen --- in nur einer Sekunde
:::
:::::

::: paragraph
Hier im Bild sehen Sie den Hinweis [Environment build took 1
second.]{.guihint} Eine Sekunde, um eine virtuelle Python-Umgebung mit
Pip und Robot Framework aufzubauen? Das geht, weil RCC clever ist:
Bereits heruntergeladene Dateien werden wiederverwendet und neu gebaut
wird nur nach Änderungen in der `conda.yaml`. Der erste Bau hätte hier
eher 30 oder mehr Sekunden gedauert.
:::
::::::::

::::::: sect3
#### []{#_plan_status .hidden-anchor .sr-only}Plan-Status {#heading__plan_status}

::: paragraph
Der Status eines Plans wird in einem Service wiedergegeben, der nach
Applikationsnamen und Suite benannt ist, beispielsweise [RMK
MyApplication_mybot Plan.]{.guihint}
:::

::::: imageblock
::: content
![Status der Test-Suite im
Monitoring.](../images/robotmk_monitorng_suite.png)
:::

::: title
Die Ausführung eines Plans --- vor allem relevant für Administratoren
:::
:::::
:::::::

::::::::::::::: sect3
#### []{#_test_status .hidden-anchor .sr-only}Test-Status {#heading__test_status}

::: paragraph
Wirklich interessant wird es bei der Auswertung der Tests. Im Bild sehen
Sie nun die Auswirkung der oben gesetzten Schwellwerte für die Laufzeit
von Tests --- hier die 2 Sekunden für den Zustand [WARN]{.state1}. Da im
Test selbst die Anweisung `Sleep 3 Seconds` schon für eine längere
Laufzeit sorgt, muss dieser Service hier auf [WARN]{.state1} gehen,
obwohl der Test erfolgreich verlaufen ist. Dass der Test erfolgreich
verlaufen ist, zeigt der Bericht von Robot Framework, den Sie über das
[![icon log](../images/icons/icon_log.png)]{.image-inline} Log-Symbol
bekommen.
:::

::::: imageblock
::: content
![Status des Tests im Monitoring.](../images/robotmk_monitorng_test.png)
:::

::: title
Ergebnisse einer konkreten Suite --- vor allem relevant für Entwickler
:::
:::::

::: paragraph
Der Bericht zeigt nun klar und deutlich, dass Test und Test-Suite
erfolgreich durchgelaufen sind.
:::

::::: imageblock
::: content
![Robot-Framework-Bericht für Test-Suite
\'Mybot\'.](../images/robotmk_monitorng_report_01.png)
:::

::: title
Der Robot-Framework-Log, hier im optionalen Dark-Mode
:::
:::::

::: paragraph
Ganz unten in den Daten sehen Sie auch die einzelnen Keywords, hier zum
Beispiel `Log ${MYVAR}` samt dem in Checkmk für `MYVAR` gesetzten Wert
`My value`.
:::

::::: imageblock
::: content
![Robot-Framework-Bericht auf Ebene der
Keywords.](../images/robotmk_monitorng_report_02.png)
:::

::: title
Die Log-Datei lässt sich bis auf kleinste Details ausklappen
:::
:::::
:::::::::::::::

::::::: sect3
#### []{#_dashboards .hidden-anchor .sr-only}Dashboards {#heading__dashboards}

::: paragraph
Natürlich können Sie sich wie gewohnt eigene Dashboards bauen --- unter
[Monitor \> Synthetic Monitoring]{.guihint} finden Sie aber auch zwei
eingebaute Dashboards.
:::

::::: imageblock
::: content
![Robotmk-Dashboard in der
Weboberfläche.](../images/robotmk_dashboard_01.png)
:::

::: title
Das komplette Checkmk Synthetic Monitoring im Überblick (gekürzt)
:::
:::::
:::::::
:::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::: sect1
## []{#troubleshooting .hidden-anchor .sr-only}3. Troubleshooting {#heading_troubleshooting}

::::::: sectionbody
:::: sect2
### []{#_scheduler_meldet_no_data .hidden-anchor .sr-only}3.1. Scheduler meldet `No Data` {#heading__scheduler_meldet_no_data}

::: paragraph
Wenn der Scheduler keinerlei Daten bekommt, hat der Bau der Umgebung
vermutlich nicht funktioniert. Ein häufiger Grund dafür sind
Netzwerkprobleme, aufgrund derer zum Beispiel bestimmte Abhängigkeiten
nicht geladen werden können. Schauen Sie in diesem Fall in die
zugehörige Log-Datei unter
`C:\ProgramData\checkmk\agent\robotmk_output\working\environment_building`.
:::
::::

:::: sect2
### []{#_environment_building_schlägt_fehl_post_install_script_execution .hidden-anchor .sr-only}3.2. Environment Building schlägt fehl: `post-install script execution` {#heading__environment_building_schlägt_fehl_post_install_script_execution}

::: paragraph
Dies ist ein besonders interessanter Fehler, der Ihnen auf frischen
Windows-Systemen begegnen könnte. In der `conda.yaml` können auch
Anweisungen hinterlegt werden, die nach der Installation der
Abhängigkeiten ausgeführt werden sollen --- beispielsweise die
Initialisierung des Robot-Framework-Browsers. Hier sollen also
Python-Befehle ausgeführt werden. Nun hat Windows 11 standardmäßig
Aliasnamen für `python.exe` und `python3.exe` vorgegeben, die auf den
Microsoft-Store verweisen. Diese Aliasnamen müssen Sie unter
`Einstellungen/Aliase für App-Ausführung` deaktivieren.
:::
::::
:::::::
::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `C:\Pro            | Log-Dateien und Ergebnisse der Suites           |
| gramData\checkmk\a |                                                 |
| gent\robotmk_outpu |                                                 |
| t\working\suites\` |                                                 |
+--------------------+-------------------------------------------------+
| `C                 | Log-Dateien zum Aufbau virtueller Umgebungen    |
| :\ProgramData\chec |                                                 |
| kmk\agent\robotmk_ |                                                 |
| output\working\env |                                                 |
| ironment_building` |                                                 |
+--------------------+-------------------------------------------------+
| `C:\Progr          | Meldungen der RCC-Ausführung                    |
| amData\checkmk\age |                                                 |
| nt\robotmk_output\ |                                                 |
| working\rcc_setup` |                                                 |
+--------------------+-------------------------------------------------+
| `C:\ProgramD       | Log-Datei des Agentenplugins                    |
| ata\checkmk\agent\ |                                                 |
| logs\robotmk_sched |                                                 |
| uler_rCURRENT.log` |                                                 |
+--------------------+-------------------------------------------------+
| `C:\ProgramData\c  | `rcc.exe` und `robotmk_scheduler.exe`           |
| heckmk\agent\bin\` |                                                 |
+--------------------+-------------------------------------------------+
| `C:                | Agentenplugin `robotmk_agent_plugin.exe`        |
| \ProgramData\check |                                                 |
| mk\agent\plugins\` |                                                 |
+--------------------+-------------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
