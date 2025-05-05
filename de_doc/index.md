:::::::::::::::::::::::::::::::: {.home role="main"}
::::::::: {#topicopaque}
:::::::: {#topicshadow}
:::::: innercols
::: col
## Checkmk 2.3.0 -- die Highlights

![](../images/CEE.svg){align="left" width="80" style="margin: 10px;"}

Checkmk 2.3.0 enthält viele Detailverbesserungen und spannende neue
Features. So integriert Checkmk Cloud erstmals synthetisches Monitoring
mit Robotmk. Zahlreiche Usability-Verbesserungen erleichtern die Arbeit
mit Checkmk. Und besonders Systeme, die von vielen Personen gemeinsam
administriert werden, profitieren von einer verbesserten Verwaltung der
Änderungen. Wer Erweiterungen für Checkmk programmiert, kann nun auf
verbesserte Check- und Graphing-APIs zurückgreifen.

### Checkmk Synthetic Monitoring

Checkmk Synthetic Monitoring ist ab Version 2.3 ein neues Add-on, das
auf Robotmk basiert. Robotmk baut wiederum auf das führende
Open-Source-Tool Robot Framework zur Testautomatisierung auf.  Die
nahtlose Integration von Robot Framework bietet gleich mehrere Vorteile.
So ist keine Anpassung bestehender Tests nötig und die UI von Checkmk
ermöglicht neben dem Zugriff auf das IT-Infrastruktur-Monitoring auch
den auf das Monitoring von Applikationen. Auf diese Weise vereint
Checkmk proaktives und reaktives Monitoring in einer Plattform.

### Neue aktive Checks für Web- und Zertifikatsmonitoring

Checkmk 2.3.0 enthält einen [neuen aktiven Check für
HTTP-Verbindungen](update_major.html#check_http) und Zertifikate, der
wesentlich performanter, robuster und besser zu konfigurieren ist, als
der bisherige check_http. Zudem ist es mit einer einzigen Regel nun
möglich, mehrere Dinge auf einmal zu überwachen, beispielsweise HTTP
Response Code, Antwortzeit und Zertifikatsgültigkeit.

Basisfunktionalität für die Prüfung von Zertifikaten enthielt der
bisherige `check_http` und der im vorherigen Abschnitt erwähnte
`check_httpv2` verbessert sie noch einmal. Allerdings haben beide einige
Gemeinsamkeiten: Zunächst sind sie eben nur anwendbar, wenn ein
Zertifikat an einem HTTPS-Endpunkt verwendet wird, zudem fehlt die
Möglichkeit einer detaillierten Untersuchung der Zertifikate
beispielsweise auf enthaltene Certificate Subject Alternative Names oder
die ausstellende Stelle. Die hieraus resultierenden Nutzerwünsche haben
wir mit dem [neuen `check_cert`](update_major.html#check_cert)
umgesetzt.
:::

:::: col
::: {#videocontainer .ytvideo style="padding-bottom: 0px"}
[Auf Youtube
anschauen](https://www.youtube.com/embed/PzIPNJgARQI "Updating Checkmk and using multiple instances")
:::

### Handbuch-Artikel

- [Updates und Upgrades](update.html)
- [Update auf Version 2.3.0](update_major.html)
- [Backups](backup.html)
- [Instanzen (Sites) mit omd verwalten](omd_basics.html)

### Weitere Informationen zum Thema

- [Checkmk herunterladen](https://checkmk.com/download){target="_blank"}
- [Das Checkmk-Forum](https://forum.checkmk.com/){target="_blank"}
- [Abonnieren Sie den
  Checkmk-Youtube-Kanal!](https://www.youtube.com/c/checkmk-channel/videos){target="_blank"}
::::
::::::

::: {.closeonly style="text-align: right; width: 99%;"}
[Schließen](#){.hidefeatured onclick="hideFeaturedTopic()"}
:::
::::::::
:::::::::

::: {#header}
# Das offizielle Checkmk Handbuch
:::

::::::::::::::::::::::: {#content}
:::::::: lbox
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

![](../images/landingpage_black_mac.png){width="300"}

::: paragraph
**Liebe Leserinnen und Leser,**\
wir freuen uns, dass Sie den Weg zu Checkmk gefunden haben.
:::

::: paragraph
Checkmk bietet als Monitoring-Software umfassende und spezialisierte
Möglichkeiten, mit den sehr unterschiedlichen Rahmenbedingungen von
IT-Infrastrukturen umzugehen. Das erfordert zwangsläufig auch eine sehr
umfassende Dokumentation, die über die reine Beschreibung des
Offensichtlichen hinausgeht. Dieses Handbuch soll Sie so gut wie möglich
dabei unterstützen, Checkmk besser zu verstehen, mit Checkmk Ihre
Anforderungen umzusetzen, aber auch neue Lösungswege zu entdecken.
:::

::: paragraph
Um den Umgang mit Checkmk so einfach wie möglich zu gestalten, verfolgen
die Artikel dieses Handbuchs an vielen Stellen eher ungewöhnliche
Herangehensweisen. Es geht dabei fast nie nur darum, eine vorgefertigte
Abfolge von Einzelschritten nachzumachen. Vielmehr soll Ihnen als Leser
oder Leserin ein tieferes Verständnis eines Features in Checkmk
vermittelt werden.
:::

::: paragraph
Wenn man es kurz zusammenfasst, ist unsere wichtigste Prämisse: Das
Handbuch soll hilfreich sein. Und hilfreich ist es dann, wenn man die
Beschreibung in die Lösung eines eigenen Problems übersetzen kann.
[Weiterlesen...](./welcome.html#landing_page_continue)
:::
::::::::

:::::::::::::::: outercols
::: col
### Neu bei Checkmk?

Jeder fängt einmal mit Checkmk an. Da Ihnen in Checkmk sehr viele
Möglichkeiten und Funktionen geboten werden, fällt es am Anfang manchmal
schwer, sich in den ersten Schritten zurechtzufinden.

Damit Sie trotzdem schnell und bequem zu Ihrem ersten Checkmk-Monitoring
kommen, haben wir einen [Leitfaden für Einsteiger](./intro_setup.html)
geschrieben. Dieser führt Sie Schritt für Schritt in Checkmk ein und ist
so aufgebaut, dass Sie ihn zügig von Anfang bis Ende lesen und dabei
gleich mitmachen können. Deswegen ist er auch kurz und knapp und hält
sich nicht mit unnötigen Details auf. Am Ende des Leitfadens haben Sie
ein praxisgerechtes Checkmk-System.
:::

::::::::::::: {#featuredtopic .col}
### Featured Topic: Checkmk 2.3.0

Checkmk 2.3.0 enthält viele Detailverbesserungen und spannende neue
Features. So integriert Checkmk Cloud erstmals synthetisches Monitoring
mit Robotmk. Zahlreiche Usability-Verbesserungen erleichtern die Arbeit
mit Checkmk. Und besonders Systeme, die von vielen Personen gemeinsam
administriert werden, profitieren von einer verbesserten Verwaltung der
Änderungen. Wer Erweiterungen für Checkmk programmiert, kann nun auf
verbesserte Check- und Graphing-APIs zurückgreifen.

[Erfahren Sie mehr ...](#){#morebutton}

:::: {#ytbox}
![](../images/featured_23beta.png)

::: ytbanderole
Auf YouTube:\
**Updating Checkmk and using multiple instances**
:::
::::

<div>

::::::::: {#topicopaque}
:::::::: {#topicshadow}
:::::: innercols
::: col
## Checkmk 2.3.0 -- die Highlights

![](../images/CEE.svg){align="left" width="80" style="margin: 10px;"}

Checkmk 2.3.0 enthält viele Detailverbesserungen und spannende neue
Features. So integriert Checkmk Cloud erstmals synthetisches Monitoring
mit Robotmk. Zahlreiche Usability-Verbesserungen erleichtern die Arbeit
mit Checkmk. Und besonders Systeme, die von vielen Personen gemeinsam
administriert werden, profitieren von einer verbesserten Verwaltung der
Änderungen. Wer Erweiterungen für Checkmk programmiert, kann nun auf
verbesserte Check- und Graphing-APIs zurückgreifen.

### Checkmk Synthetic Monitoring

Checkmk Synthetic Monitoring ist ab Version 2.3 ein neues Add-on, das
auf Robotmk basiert. Robotmk baut wiederum auf das führende
Open-Source-Tool Robot Framework zur Testautomatisierung auf.  Die
nahtlose Integration von Robot Framework bietet gleich mehrere Vorteile.
So ist keine Anpassung bestehender Tests nötig und die UI von Checkmk
ermöglicht neben dem Zugriff auf das IT-Infrastruktur-Monitoring auch
den auf das Monitoring von Applikationen. Auf diese Weise vereint
Checkmk proaktives und reaktives Monitoring in einer Plattform.

### Neue aktive Checks für Web- und Zertifikatsmonitoring

Checkmk 2.3.0 enthält einen [neuen aktiven Check für
HTTP-Verbindungen](update_major.html#check_http) und Zertifikate, der
wesentlich performanter, robuster und besser zu konfigurieren ist, als
der bisherige check_http. Zudem ist es mit einer einzigen Regel nun
möglich, mehrere Dinge auf einmal zu überwachen, beispielsweise HTTP
Response Code, Antwortzeit und Zertifikatsgültigkeit.

Basisfunktionalität für die Prüfung von Zertifikaten enthielt der
bisherige `check_http` und der im vorherigen Abschnitt erwähnte
`check_httpv2` verbessert sie noch einmal. Allerdings haben beide einige
Gemeinsamkeiten: Zunächst sind sie eben nur anwendbar, wenn ein
Zertifikat an einem HTTPS-Endpunkt verwendet wird, zudem fehlt die
Möglichkeit einer detaillierten Untersuchung der Zertifikate
beispielsweise auf enthaltene Certificate Subject Alternative Names oder
die ausstellende Stelle. Die hieraus resultierenden Nutzerwünsche haben
wir mit dem [neuen `check_cert`](update_major.html#check_cert)
umgesetzt.
:::

:::: col
::: {#videocontainer .ytvideo style="padding-bottom: 0px"}
[Auf Youtube
anschauen](https://www.youtube.com/embed/PzIPNJgARQI "Updating Checkmk and using multiple instances")
:::

### Handbuch-Artikel

- [Updates und Upgrades](update.html)
- [Update auf Version 2.3.0](update_major.html)
- [Backups](backup.html)
- [Instanzen (Sites) mit omd verwalten](omd_basics.html)

### Weitere Informationen zum Thema

- [Checkmk herunterladen](https://checkmk.com/download){target="_blank"}
- [Das Checkmk-Forum](https://forum.checkmk.com/){target="_blank"}
- [Abonnieren Sie den
  Checkmk-Youtube-Kanal!](https://www.youtube.com/c/checkmk-channel/videos){target="_blank"}
::::
::::::

::: {.closeonly style="text-align: right; width: 99%;"}
[Schließen](#){.hidefeatured onclick="hideFeaturedTopic()"}
:::
::::::::
:::::::::

</div>
:::::::::::::

::: {#autolists .col}
#### Am häufigsten besucht

- [Linux überwachen](agent_linux.html)
- [Windows überwachen](agent_windows.html)
- [Monitoring-Agenten](wato_monitoringagents.html)
- [Checkmk aufsetzen](intro_setup.html)
- [Benachrichtigungen](notifications.html)

#### Neue Artikel

- [Ports](ports.html)
- [Strukturierung der Hosts](hosts_structure.html)
- [Verwaltung der Hosts](hosts_setup.html)
- [Suchen in docs.checkmk.com](search.html)

#### Zuletzt aktualisiert

- [Reguläre Ausdrücke in Checkmk](regexes.html)
- [Update auf Version 2.3.0](update_major.html)
- [Weboberfläche mit HTTPS absichern](omd_https.html)
- [Statusdaten abrufen via Livestatus](livestatus.html)
:::
::::::::::::::::
:::::::::::::::::::::::
::::::::::::::::::::::::::::::::
