:::: {#header}
# Vorhersagegraphen erstellen

::: details
[Last modified on 11-Mar-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/forecast_graphs.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Messwerte und Graphing](graphing.html) [Dashboards](dashboards.html)
[Prognosebasiertes Monitoring](predictive_monitoring.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Der Kern des
Monitorings mit Checkmk ist es, Ihnen jederzeit ein klares Bild vom
Ist-Zustand Ihrer IT-Infrastruktur zu geben. Die Aufzeichnung all dieser
Ist-Zustände in Datenbanken erlaubt es dann jederzeit in die
Vergangenheit zu blicken, Performance-Graphen zu erstellen und
Zusammenhänge zu erkennen, die eventuell zu Problemen geführt haben.
:::

::: paragraph
Und auch wenn beispielsweise ein Blick auf die Graphen eines
Dateisystems schon grob erahnen lässt, wann der Platz hier mal eng
werden könnte, trügt dieser schnelle Eindruck häufig. Er lässt nämlich
zentrale Elemente des Capacity Managements außen vor. Saisonale Faktoren
etwa lassen viel Raum für Fehleinschätzungen. Wie sich die Anforderungen
an Ihre IT-Infrastruktur zum Beispiel während Ferienzeiten, Feiertagen
oder gar im Bezug auf Jahreszeiten ändern kann, ist nicht immer trivial
und augenscheinlich.
:::

::: paragraph
Ein weiterer wichtiger Faktor in der Berechnung von Vorhersagen sind
Einmaleffekte. Wenn beispielsweise der verwendete Speicherplatz rund um
eine große Aufräumaktion auf einem Dateisystem unter Anwendung einer
linearen Regression für eine Extrapolation herangezogen würde, könnte
der Eindruck entstehen, dass Ihr Dateisystem in naher Zukunft
vollständig leer sein wird. Dass dies falsch ist erschließt sich sofort
und zeigt plakativ, warum es für verlässliche Vorhersagen deutlich
robusterer Methoden bedarf.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Solche robusten
Methoden, welche auf Grundlage der gesammelten historischen Daten eine
schlaue Interpretation und bei korrekter Konfiguration gute Vorhersagen
ermöglichen, bietet Checkmk in den kommerziellen Editionen an. Wie diese
eingerichtet werden, zeigen wir Ihnen im Folgenden.
:::
:::::::
::::::::

:::::::::::::::::::::::::::::::::::::: sect1
## []{#configuration .hidden-anchor .sr-only}2. Konfiguration in Checkmk {#heading_configuration}

::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#_erstellen_eines_vorhersagegraphen .hidden-anchor .sr-only}2.1. Erstellen eines Vorhersagegraphen {#heading__erstellen_eines_vorhersagegraphen}

::: paragraph
Die mit Abstand einfachste Möglichkeit, einen Vorhersagegraphen zu
erstellen, ist der Weg über die Detailansicht eines beliebigen Service,
welcher Metriken produziert. In einer solchen Detailansicht finden Sie
direkt unter den Servicegraphen die Zeile mit den [Service
Metrics.]{.guihint} Hinter den aktuellen Werten jeder dieser Kennzahlen
finden Sie jeweils einen Knopf für das spezielle Aktionsmenü [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} für Metriken.
:::

:::: imageblock
::: content
![forecast graphs service
metrics](../images/forecast_graphs_service_metrics.png)
:::
::::

::: paragraph
Öffnen Sie nun das Aktionsmenü und wählen Sie anschließend [New forecast
graph...​ .]{.guihint}
:::

:::: imageblock
::: content
![forecast graphs service metrics action
menu](../images/forecast_graphs_service_metrics_action_menu.png){width="50%"}
:::
::::

::: paragraph
Nach wenigen Augenblicken sehen Sie bereits den ersten Vorhersagegraphen
zu der von Ihnen gewählten Metrik.
:::

:::: imageblock
::: content
![forecast graphs first
graph](../images/forecast_graphs_first_graph.png)
:::
::::
::::::::::::

:::::::::::::::::::::::::: sect2
### []{#_die_modellparameter .hidden-anchor .sr-only}2.2. Die Modellparameter {#heading__die_modellparameter}

::: paragraph
Jetzt ist es an der Zeit, speziell für diese Metrik die Parameter für
die Berechnung der Vorhersage auszuwählen --- zu finden direkt unterhalb
des Graphen. Da diese Parameter besonders stark von Ihrer jeweiligen
Umgebung und dem Zweck der Vorhersage abhängen, ist eine genaue
Auseinandersetzung mit den Optionen und ihren möglichen Auswirkungen
sehr wichtig.
:::

:::: imageblock
::: content
![forecast graphs model
parameters](../images/forecast_graphs_model_parameters.png)
:::
::::

:::: sect3
#### []{#_minimummaximumdurchschnitt .hidden-anchor .sr-only}Minimum --- Maximum --- Durchschnitt {#heading__minimummaximumdurchschnitt}

::: paragraph
Bereits das letzte Feld in der Zeile [Metric]{.guihint} kann erheblichen
Einfluss auf die Sinnhaftigkeit der Vorhersage haben. Vorgabe ist an
dieser Stelle immer die Option [Maximum,]{.guihint} da dieses im Kontext
des Capacity Managements am häufigsten einen Hinweis auf eben das
liefert, was man mit einer solchen Vorhersage erkennen
möchte --- Engpässe bei Spitzenlasten. Würden Sie beispielsweise beim
Service [CPU utilization]{.guihint} ausschließlich auf
Durchschnittswerte schauen, könnten Sie zwar sehen, dass die Auslastung
im Schnitt noch akzeptabel ist. Dass Ihre CPU aber in absehbarer Zeit
bei Spitzenlasten ständig an ihre Grenzen stößt, würden Sie im
Monitoring erst dann erkennen, wenn es soweit ist.
:::
::::

::::: sect3
#### []{#_consider_history_of .hidden-anchor .sr-only}Consider history of {#heading__consider_history_of}

::: paragraph
Mit dieser Option können Sie festlegen, welcher Zeitraum der
historischen Daten als Berechnungsgrundlage für die Vorhersage
herangezogen werden soll. Pauschal lässt sich sagen, dass viele
Datenpunkte benötigt werden um einen guten Fit zu ermöglichen. Wenn Sie
aber beispielsweise immer die Messwerte des Vormonats als Grundlage
nehmen möchten, können Sie dies mit der Auswahlmöglichkeit [Last
month]{.guihint} tun. Dies meint nämlich nicht die vergangen 30 Tage,
sondern den vorherigen Kalendermonat.
:::

::: paragraph
Ein anderer Grund, den Zeitraum zu begrenzen, könnte zum Beispiel ein
Upgrade einzelner Komponenten eines Servers sein. Die Einbeziehung von
Daten **vor** diesem Upgrade könnte ja gegebenenfalls die Vorhersage
verfälschen.
:::
:::::

::::: sect3
#### []{#_forecast_into_the_future .hidden-anchor .sr-only}Forecast into the future {#heading__forecast_into_the_future}

::: paragraph
Die Vorhersage beginnt am letzten Tag des unter [Consider history
of]{.guihint} ausgewählten Zeitraums. Dies ist deshalb erwähnenswert,
weil je nach Auswahl auch eine Vorhersage für einen Zeitraum berechnet
wird, in dem bereits reale Messdaten angefallen sind. Innerhalb dieser
Überschneidung lässt sich also schon ablesen, wie nah die Vorhersage an
den tatsächlichen Werten liegt.
:::

::: paragraph
Des Weiteren bleibt hier nur zu sagen, dass die Vorhersage natürlich um
so unpräziser wird, je weiter Sie versuchen in die Zukunft zu blicken.
Diese Banalität wird aber im Vorhersagegraphen durch die immer größer
werdenden orangen Schattierungen sehr gut visualisiert.
:::
:::::

:::: sect3
#### []{#_trend_flexibility .hidden-anchor .sr-only}Trend flexibility {#heading__trend_flexibility}

::: paragraph
Bei der Betrachtung und Analyse von Zeitreihen --- hier also den
aufgezeichneten Messwerten Ihrer Services --- spielen sogenannte
Strukturbrüche oder *Change Points* eine sehr wichtige Rolle.
Vereinfacht ausgedrückt bezeichnen diese Change Points gerade die
Momente in der Zeitreihe, an denen sich mehr oder weniger starke
Veränderungen beobachten lassen. Während der Analyse der Zeitreihe
identifiziert Checkmk nun eine ganze Reihe dieser Change Points und
nutzt diese, um sie in der Vorhersage wiederzuverwenden und damit zu
präzisieren. Wie stark Checkmk die Kurve des Vorhersagegraphen nun an
diese Change Points anpasst, lässt sich über die fünf Wahlmöglichkeiten
der Option [Trend flexibility]{.guihint} bestimmen. Durch eine zu starke
Anpassung --- eine sogenannte Überanpassung (*overfitting*) --- würde
die Vorhersagefunktion zu stark einer schlichten Fortschreibung (im
Grunde einer Kopie) der bisherigen Zeitreihe gleichen. Eine
Unteranpassung (underfitting) auf der anderen Seite, würde die
Vorhersage extrem ungenau machen. Checkmk gibt hier einen für viele
Fälle guten Standardwert vor, den wir mit [Medium]{.guihint}
umschreiben. Sollte Ihr Vorhersagegraph zu ungenau sein --- also eine
Unteranpassung vorliegen \--, müssten Sie die Flexibilität der
Trendkurve erhöhen, indem Sie hier [High]{.guihint} oder [Very
High]{.guihint} wählen. Im umgekehrten Fall --- also einer
Überanpassung --- blieben Ihnen noch die beiden Optionen [Low]{.guihint}
und [None (Linear)]{.guihint} übrig, obwohl wir von der Verwendung von
[None (linear)]{.guihint} eher abraten, weil Sie nur der Vollständigkeit
halber zur Verfügung steht.
:::
::::

:::::: sect3
#### []{#_model_seasonality .hidden-anchor .sr-only}Model seasonality {#heading__model_seasonality}

::: paragraph
An dieser Stelle müssen Sie festlegen, wie im Vorhersagegraphen mit
wiederkehrenden und saisonabhängigen Anforderungen an Ihre Infrastruktur
umgegangen werden soll. In den Vorhersagegraphen werden hier automatisch
in erster Linie zwei Zeiträume betrachtet. Wöchentlich wiederkehrende,
wie etwa die unterschiedlichen Anforderungen zwischen einer 5-tägigen
Arbeitswoche und dem Wochenende, und jährliche bzw. saisonabhängige
Anforderungen, wie Sie beispielsweise durch Feiertage und Urlaubszeiten
zustande kommen. Checkmk erkennt diese Saisonabhängigkeit automatisch
und Sie müssen hier nur auswählen, wie diese in die Vorhersage
eingerechnet werden soll.
:::

::: paragraph
Die Option [Additive]{.guihint} rechnet diese veränderten Anforderungen
nur einmalig mit in die Vorhersage ein. Wie der Name schon sagt, wird
die erhöhte bzw. auch verringerte Anforderung nur zum Trend addiert.
:::

::: paragraph
Mit der Auswahl von [Multiplicative]{.guihint} hingegen erhöht bzw.
verringert sich der zukünftige saisonale Bedarf proportional zum Trend.
:::
::::::

:::: sect3
#### []{#_confidence_interval .hidden-anchor .sr-only}Confidence interval {#heading__confidence_interval}

::: paragraph
An dieser Stelle müssen Sie das Konfidenzniveau für Ihre Voraussage
festlegen. Vereinfacht ausgedrückt legen Sie hier fest, mit welcher
Wahrscheinlichkeit die zu erwartenden Werte innerhalb des aus dem Niveau
resultierenden Konfidenzintervalls liegen sollen. Ziel einer solchen
Auswahl ist es immer bei einem möglichst hohen Niveau ein möglichst
schmales Intervall zu erhalten. Dies gelingt mit den Vorhersagegraphen
umso besser je mehr historische Daten zur Verfügung stehen. Wichtig ist,
dass diese Auswahl den eigentlichen Fit nicht beeinflusst. Nur der ihn
umgebende Bereich (also die Visualisierung des Intervalls) wird bei
höheren Niveaus dementsprechend größer.
:::
::::

:::: sect3
#### []{#_display_historic_data_since_the_last .hidden-anchor .sr-only}Display historic data since the last {#heading__display_historic_data_since_the_last}

::: paragraph
Im Vorhersagegraphen sehen Sie auf der linken Seite --- abgetrennt durch
eine vertikale gelbe Linie --- die Visualisierung einer gewissen Anzahl
an Tagen tatsächlicher aufgezeichneter Daten. Wie viele dies sein
sollen, können Sie hier festlegen. Der Wert hat keine Auswirkungen auf
die Berechnung der Vorhersage, sondern beeinflusst nur die Darstellung.
:::
::::

:::: sect3
#### []{#_display_model_parametrization_in_graph .hidden-anchor .sr-only}Display Model Parametrization in graph {#heading__display_model_parametrization_in_graph}

::: paragraph
Und auch die letzte Option hat erneut nur Einfluss auf die Darstellung
des Graphen. Wenn Sie hier den Haken bei [Model parameters]{.guihint}
setzen, werden die zuvor ausgewählten Parameter unter dem fertigen
Graphen angezeigt. Dies ermöglicht dem Betrachter den Graphen ggf.
besser einordnen zu können.
:::
::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#diagnostics .hidden-anchor .sr-only}3. Diagnosemöglichkeiten {#heading_diagnostics}

:::::: sectionbody
::::: sect2
### []{#_mögliche_fehler_und_fehlermeldungen .hidden-anchor .sr-only}3.1. Mögliche Fehler und Fehlermeldungen {#heading__mögliche_fehler_und_fehlermeldungen}

:::: sect3
#### []{#_cannot_create_graph .hidden-anchor .sr-only}Cannot create graph {#heading__cannot_create_graph}

::: paragraph
Die Fehlermeldung [Cannot create graph - Metric historic data has less
than 2 days of valid values]{.guihint} ist weitgehend selbsterklärend.
Um sinnvolle Vorhersagen treffen zu können, benötigt Checkmk mehr als 2
volle Tage an historischen Messdaten. Mit weniger Messpunkten als
Grundlage ist schlicht kein halbwegs seriöser Fit möglich.
:::
::::
:::::
::::::
:::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::
