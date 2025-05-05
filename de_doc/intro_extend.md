:::: {#header}
# Das Monitoring weiter ausbauen

::: details
[Last modified on 15-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_extend.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Best Practices, Tipps & Tricks](intro_bestpractise.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#security .hidden-anchor .sr-only}1. Sicherheit optimieren {#heading_security}

:::: sectionbody
::: paragraph
Auch wenn im Monitoring „nur" geschaut wird, ist das Thema IT-Sicherheit
auch hier sehr wichtig, insbesondere bei der Anbindung und Einrichtung
ferner Systeme. Im [Artikel über Sicherheit](security.html) finden Sie
eine Übersicht von Themen, mit denen Sie die Sicherheit Ihres Systems
optimieren können.
:::
::::
:::::

::::::: sect1
## []{#distributed_monitoring .hidden-anchor .sr-only}2. Sehr große Umgebungen überwachen {#heading_distributed_monitoring}

:::::: sectionbody
::: paragraph
Wenn Ihr Monitoring eine Größenordnung erreicht hat, in der Sie Tausende
oder noch mehr Hosts überwachen, werden Fragen der Architektur und der
Optimierung dringlicher. Eines der wichtigsten Themen ist dabei das
[verteilte Monitoring.](glossar.html#distributed_monitoring) Dabei
arbeiten Sie mit mehreren Checkmk-Instanzen, die zu einem großen System
zusammengeschaltet sind und bei Bedarf im [verteilten
Setup](glossar.html#distributed_setup) zentral konfiguriert sein können.
:::

:::: imageblock
::: content
![Illustration der Beziehung zwischen mehreren Instanzen und ihrer
Komponenten im verteilten
Monitoring.](../images/distributed_monitoring_overview_de.png)
:::
::::
::::::
:::::::

:::::::::: sect1
## []{#availability .hidden-anchor .sr-only}3. Verfügbarkeit und SLAs {#heading_availability}

::::::::: sectionbody
::: paragraph
Checkmk kann sehr präzise berechnen, wie hoch die
[Verfügbarkeit](availability.html) (*availability*) von Hosts oder
Services in bestimmten Zeiträumen war, wie viele Ausfälle es gegeben
hat, wie lang diese waren und vieles mehr.
:::

:::: imageblock
::: content
![Liste von Services mit den Prozentwerten ihrer
Verfügbarkeit.](../images/intro_availability.png)
:::
::::

::: paragraph
Auf den Verfügbarkeitsdaten aufbauend ermöglicht das in den
kommerziellen Editionen enthaltene [SLA](sla.html) Software-Modul eine
wesentlich detailliertere Auswertung zur Einhaltung von Service Level
Agreements, die sogar aktiv überwacht werden können.
:::

:::: imageblock
::: content
![Ein Service und dessen Service Level Agreement für die letzten 15
Tage.](../images/sla_view_example_modern.png)
:::
::::
:::::::::
::::::::::

::::::: sect1
## []{#inventory .hidden-anchor .sr-only}4. Hardware und Software inventarisieren {#heading_inventory}

:::::: sectionbody
::: paragraph
Die [Hardware-/Software-Inventur](inventory.html) gehört eigentlich
nicht mehr zum Monitoring, aber Checkmk kann mit den bereits vorhandenen
[Agenten](glossar.html#agent) umfangreiche Informationen zu Hardware und
Software Ihrer überwachten Systeme ermitteln. Dies ist sehr hilfreich
für die Wartung, das Lizenzmanagement oder das automatische Befüllen von
Configuration Management Databases.
:::

:::: imageblock
::: content
![Baumdarstellung der Hardware-/Software-Inventurdaten eines
Hosts.](../images/inventory_example.png)
:::
::::
::::::
:::::::

::::::: sect1
## []{#ec .hidden-anchor .sr-only}5. Meldungen und Ereignisse überwachen {#heading_ec}

:::::: sectionbody
::: paragraph
Bisher haben wir uns nur mit der Überwachung der aktuellen Zustände von
Hosts und Services befasst. Ein ganz anderes Thema ist die Auswertung
spontaner Meldungen, die z.B. in Log-Dateien auftauchen oder per Syslog
oder SNMP-Traps versendet werden. Checkmk filtert aus den eingehenden
Meldungen die relevanten Ereignisse (*events*) heraus und hat dafür ein
komplett integriertes System mit dem Namen [Event Console.](ec.html)
:::

:::: imageblock
::: content
![Liste von Ereignissen in der Event
Console.](../images/ec_open_events.png)
:::
::::
::::::
:::::::

::::::: sect1
## []{#nagvis .hidden-anchor .sr-only}6. Auf Karten und Diagrammen visualisieren {#heading_nagvis}

:::::: sectionbody
::: paragraph
Mit dem in Checkmk integrierten Add-on [NagVis](nagvis.html) können Sie
auf beliebigen Karten oder Diagrammen Zustände darstellen. Dies eignet
sich hervorragend, um ansprechende Gesamtübersichten zu erstellen, z.B.
auf einem Bildschirm in einem Leitstand.
:::

:::: {.imageblock .border}
::: content
![Eine mit NagVis erstellte geografische Karte mit Symbolen für den
Host-/Service-Zustand.](../images/intro_nagvis_map.png)
:::
::::
::::::
:::::::

::::::: sect1
## []{#bi .hidden-anchor .sr-only}7. Business Intelligence (BI) {#heading_bi}

:::::: sectionbody
::: paragraph
Mit dem in Checkmk integrierten Software-Modul [Business
Intelligence](glossar.html#bi) können Sie aus den vielen einzelnen
Statuswerten den Gesamtzustand von geschäftskritischen Anwendungen
ableiten und übersichtlich darstellen.
:::

:::: imageblock
::: content
![Baumdarstellung in der Business Intelligence mit dem aus
Einzelzuständen abgeleiteten Gesamtzustand einer
Anwendung.](../images/intro_bi_downtimes.png)
:::
::::
::::::
:::::::

::::: sect1
## []{#reporting .hidden-anchor .sr-only}8. PDF-Berichte erstellen {#heading_reporting}

:::: sectionbody
::: paragraph
Die in Checkmk zur Verfügung stehenden Informationen (Tabellenansichten,
Verfügbarkeitstabellen, Graphen, Logos, und vieles mehr) können zu
[Berichten](reporting.html) (*reports*) zusammengestellt und als
druckfähige PDF-Dokumente exportiert werden. PDF-Berichte können nur in
den kommerziellen Editionen erstellt werden.
:::
::::
:::::

::::: sect1
## []{#agent_updater .hidden-anchor .sr-only}9. Agenten automatisch updaten {#heading_agent_updater}

:::: sectionbody
::: paragraph
Wenn Sie viele Linux- und Windows-Server überwachen, können Sie den in
den kommerziellen Editionen enthaltenen [Agent
Updater](agent_deployment.html) benutzen, um Ihre Monitoring-Agenten und
deren Konfiguration zentralisiert auf dem gewünschten Stand zu halten.
:::
::::
:::::

:::::: sect1
## []{#devel .hidden-anchor .sr-only}10. Eigene Plugins entwickeln {#heading_devel}

::::: sectionbody
::: paragraph
Auch wenn Checkmk über 2000 Check-Plugins mit ausliefert, kann es
trotzdem vorkommen, dass ein konkretes Plugin fehlt. Eine Einführung in
die Entwicklung von Erweiterungen für Checkmk erhalten Sie in einem
[eigenen Artikel.](devel_intro.html)
:::

::: paragraph
[Weiter geht es mit bewährten Tipps aus der
Praxis](intro_bestpractise.html)
:::
:::::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
