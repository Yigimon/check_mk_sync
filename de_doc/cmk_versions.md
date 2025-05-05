:::: {#header}
# Checkmk-Versionen

::: details
[Last modified on 29-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cmk_versions.asciidoc){.edit-document}
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
[Updates und Upgrades](update.html) [Checkmk
aufsetzen](intro_setup.html) [Der Checkmk Micro Core](cmc.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#development_cycle .hidden-anchor .sr-only}1. Der Entwicklungszyklus {#heading_development_cycle}

::::::::: sectionbody
::: paragraph
Ein Zyklus von einer stabilen Checkmk-Version bis zur nächsten umfasst
circa ein bis eineinhalb Jahre. Es beginnt damit, dass nach dem Release
der Vorgängerversion (z.B. [`2.2.0`]{.new}) mit dem Entwickeln der neuen
Features für die kommende Version (z.B. [`2.3.0`]{.new}) begonnen wird.
Die Entwicklung findet auf dem Hauptentwicklungszweig (*Master*) statt.
:::

::: paragraph
Optional wird nach etwa 6--9 Monaten die erste Innovation-Version
erstellt, welche in einem eigenen Zweig für eine kurze Zeit gepflegt
wird.
:::

::: paragraph
Nach zwei bis vier Innovation-Versionen beginnt die Beta-Phase. Auch für
diese wird ein Zweig abgespalten, auf dem die stabile Version
finalisiert und später gepflegt wird. Auf dem Hauptzweig beginnt dann
schon wieder die Vorbereitung für den nächsten Zyklus.
:::

::: paragraph
Sowohl auf dem Hauptentwicklungszweig als auch auf dem stabilen Zweig
gibt es tägliche Zwischenversionen (*Daily Builds*), welche Ihnen einen
schnellen Zugriff auf neue Features oder Bug Fixes bieten. Grafisch
dargestellt sieht das Ganze zum Beispiel für die Version [1.6.0]{.new}
etwa so aus:
:::

:::: imageblock
::: content
![development cycle](../images/development_cycle.png){width="550"}
:::
::::
:::::::::
::::::::::

:::::::::::::::::::::: sect1
## []{#versions .hidden-anchor .sr-only}2. Versionen {#heading_versions}

::::::::::::::::::::: sectionbody
::: paragraph
Eine jede [Checkmk-Edition](glossar.html#edition) gibt es in
verschiedenen Versionen, d.h. in unterschiedlichen Stadien der
Entwicklung. Auch hier im Handbuch begegnen Sie daher verschiedenen
Varianten des Begriffs *Version.*
:::

:::::::: sect2
### []{#daily .hidden-anchor .sr-only}2.1. Tagesversionen vom Master (Daily Builds) {#heading_daily}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Auf dem
Entwicklungszweig (in der Versionskontrolle Git heißt dieser „master")
wird die Zukunft von Checkmk entwickelt. Damit Entwickler, Anwender und
andere Interessierte sich jederzeit ein Bild vom aktuellen Stand der
Software machen können, wird jeden Tag zwischen 0:00 und 6:00 Uhr
mitteleuropäischer Zeit ein Installationspaket für alle unterstützten
Linux-Distributionen gebaut. Diese Pakete werden auch *Daily Builds*,
*Git Snapshots* oder *Entwicklerversionen* genannt und stellen den
exakten Stand der Softwareentwicklung zu Beginn eines jeden Tages dar.
:::

::: paragraph
Die Tagesversionen sind natürlich oft fehlerbehaftet, da sie quasi einen
mehr oder weniger „zufälligen" Stand der Software enthalten. Im
Gegensatz zu Innovation- und stabilen Versionen eröffnen Tagesversionen
auch keinen neuen Entwicklungszweig und können daher auch nicht von uns
gepatcht werden. Die einzige Möglichkeit einen Fehler in einer
Tagesversion zu beheben, ist das Einspielen einer neueren Tagesversion,
bei der dieser Fehler behoben ist. Leider kann dabei natürlich wieder
ein neuer, anderer Fehler hineingeraten. Daher sollten Sie
Tagesversionen niemals produktiv einsetzen.
:::

::: paragraph
Trotzdem sind die Tagesversionen sehr nützlich, wenn Sie neue Features
zeitnah ausprobieren möchten. Dies gilt insbesondere dann, wenn Sie
diese Features selbst bei uns in Auftrag gegeben haben!
:::

::: paragraph
Unser Support hilft Ihnen auch gerne bei Schwierigkeiten mit
Tagesversionen, allerdings mit folgenden Einschränkungen:
:::

::: ulist
- Wir können Ihnen nur helfen, wenn Ihre Tagesversion nicht älter als
  eine Woche ist.

- Wir können keine Patches erstellen.
:::
::::::::

::::: sect2
### []{#innovation .hidden-anchor .sr-only}2.2. Innovation-Versionen {#heading_innovation}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline}
Innovation-Versionen sind ein besonderes Feature der kommerziellen
Editionen und geben Ihnen die Möglichkeit, neue interessante Features
der Software bereits lange vor der nächsten stabilen Version zu nutzen.
Sie stellen einen Kompromiss zwischen Stabilität und Innovation dar.
Innovation-Versionen sind jedoch optional und werden nicht in
Vorbereitung auf jede stabile Version bereitgestellt.
:::

::: paragraph
Die erste Innovation-Version gibt es in der Regel ein halbes Jahr nach
dem letzten stabilen Release. In einer Abfolge von 1-2 Monaten
erscheinen 3-4 Releases, welche jeweils mit dem Kürzel `i` nummeriert
sind (z.B. [`2.0.0`]{.new}`i2`). Ähnlich wie stabile Versionen werden
auch diese aktiv gepflegt --- allerdings nur eine begrenzte Zeit von 1-2
Monaten, an die sich eine ebenso lange passive Pflege anschließt.
Patches von `i`-Versionen erkennen Sie an einem `p`-Suffix, z.B.
[`2.0.0`]{.new}`i2p1`.
:::
:::::

::::: sect2
### []{#beta .hidden-anchor .sr-only}2.3. Beta-Versionen {#heading_beta}

::: paragraph
Das Release einer neuen stabilen Version (z.B. [`2.3.0`]{.new}) beginnt
mit einer Beta-Phase. Um alle Fehler zu beheben und die Software
tauglich für die Produktion zu machen, wird dazu ein *stabiler Zweig*
abgespalten, welcher nur noch Fehlerbehebungen enthält. Auf dem
Hauptzweig geht parallel die Entwicklung der Features für die Zukunft
weiter.
:::

::: paragraph
Auf dem stabilen Zweig wird nun eine Serie von Beta-Versionen mit einem
kleinen `b` im Namen veröffentlicht --- (z.B. [`2.3.0`]{.new}`b1`,
[`2.3.0`]{.new}`b2`, usw.). Das geschieht etwa alle zwei Wochen  --- 
solange bis keine gravierenden Fehler mehr bekannt sind.
:::
:::::

::::::: sect2
### []{#stable .hidden-anchor .sr-only}2.4. Stabile Version {#heading_stable}

::: paragraph
Nach der Beta-Phase gibt es den feierlichen Augenblick, an dem die neue
stabile Version, auch **Major-Version** genannt, erscheint (z.B.
[`2.3.0`]{.new}). Da die Software nun von mehr Benutzern eingesetzt
wird, werden jetzt in der Regel noch Probleme bekannt, die während der
Beta-Phase nicht aufgefallen sind. Diese werden in einer Reihe von
**Patch-Versionen**, manchmal auch als Patch Releases bezeichnet,
behoben ([`2.3.0`]{.new}`p1`, [`2.3.0`]{.new}`p2`, usw.). Die Abstände
dieser Patch-Versionen sind anfangs recht kurz (etwa eine Woche) und
später viel länger (einige Monate).
:::

::: paragraph
Zusätzlich zum Master werden auch auf dem stabilen Zweig Tagesversionen
veröffentlicht, die Ihnen Bug Fixes zeitnah bereitstellen. Diese tragen
den Namen des Zweigs plus das Datum, z.B. [`2.3.0`]{.new}`-2024.03.30`.
:::

::: paragraph
Sie können diese Versionen produktiv einsetzen, solange Sie Folgendes
beachten:
:::

::: ulist
- Setzen Sie eine Tagesversion auf dem stabilen Zweig nur dann ein, wenn
  sie ein für Sie gravierendes Problem behebt.

- Aktualisieren Sie auf die nächste Patch-Version, sobald diese
  erscheint.
:::
:::::::
:::::::::::::::::::::
::::::::::::::::::::::

:::::::: sect1
## []{#suffix .hidden-anchor .sr-only}3. Editionen und ihre Suffixe {#heading_suffix}

::::::: sectionbody
::: paragraph
Wenn Sie die Version einer Checkmk-Instanz mit dem Befehl `omd version`
anzeigen, sehen Sie noch einen Suffix, der aus Sicht von OMD Teil der
Versionsnummer ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd version
OMD - Open Monitoring Distribution Version 2.3.0p1.cre
```
:::
::::

::: paragraph
Dieses Suffix dient dazu, gleiche Versionen von verschiedenen
[Checkmk-Editionen](https://checkmk.com/de/produkt/editionen){target="_blank"}
zu unterscheiden. Auf diese Art ist es kein Problem, z.B. gleichzeitig
die Version [`2.3.0`]{.new} von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** und
[![CSE](../images/icons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline}
**Checkmk Enterprise** installiert zu haben. Dies ist manchmal sogar
sehr sinnvoll --- nämlich wenn Sie von Checkmk Raw auf eine der
kommerziellen Editionen umsteigen möchten. Folgende Suffixe sind
möglich:
:::

+------+---------------------------------------------------------------+
| `.   | [![CRE](../im                                                 |
| cre` | ages/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline} |
|      | **Checkmk Raw**                                               |
+------+---------------------------------------------------------------+
| `.   | [![CSE](../images/ic                                          |
| cee` | ons/CSE.png "Checkmk Enterprise"){width="20"}]{.image-inline} |
|      | **Checkmk Enterprise**                                        |
+------+---------------------------------------------------------------+
| `.   | [![CSE](../imag                                               |
| cce` | es/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline} |
|      | **Checkmk Cloud**                                             |
+------+---------------------------------------------------------------+
| `.   | [![CME](../im                                                 |
| cme` | ages/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline} |
|      | **Checkmk MSP**                                               |
+------+---------------------------------------------------------------+
:::::::
::::::::

::::::::::::::: sect1
## []{#maintenance .hidden-anchor .sr-only}4. Pflege und Support {#heading_maintenance}

:::::::::::::: sectionbody
::: paragraph
Eine Checkmk-Version (z.B. [`2.3.0`]{.new}) erhält mindestens 24 Monate
lang Fehler- und Sicherheitskorrekturen. Dieser Zeitraum wird in die
aktive und die passive Phase unterteilt.
:::

::::: sect2
### []{#active_maintenance .hidden-anchor .sr-only}4.1. Aktive Pflege {#heading_active_maintenance}

::: paragraph
Die stabile Version wird aktiv gepflegt, d.h. mit Patch-Versionen
versorgt. Wie lange das passiert, hängt davon ab, wann die Folgeversion
freigegeben wird und dadurch zur neuen stabilen Version wird. Die Regel
ab der Version [1.6.0]{.new} lautet: Die aktive Pflege endet für eine
Version 6 Monate nach Freigabe der neuen Version. Da für die stabile
Version die Folgeversion noch nicht freigegeben ist, dient der geplante
Freigabetermin zur Festlegung des Produkt-Lifecycle.
:::

::: paragraph
Damit werden für 6 Monate zwei Versionen parallel mit Patch-Versionen
bedient: die stabile Version (*stable*) und die Vorgängerversion
(*oldstable*). Eine Übersicht über den
[Produkt-Lifecycle](#support_periods) finden Sie am Ende dieses
Artikels.
:::
:::::

:::::: sect2
### []{#passive_maintenance .hidden-anchor .sr-only}4.2. Passive Pflege {#heading_passive_maintenance}

::: paragraph
Nach Ablauf der aktiven Pflege geht der stabile Zweig in die passive
Pflege über, die in der Regel ein weiteres Jahr dauert.
:::

::: paragraph
Während dieser Zeit beheben wir Fehler nur noch im Auftrag von Kunden,
die uns diese im Rahmen eines Support-Vertrags in Form von Support
Tickets melden.
:::

::: paragraph
Bug Fixes während der passiven Pflege lösen weitere Patch-Versionen aus,
von denen dann natürlich auch diejenigen Anwender profitieren, welche
keinen Support-Vertrag haben.
:::
::::::

::::: sect2
### []{#support_periods .hidden-anchor .sr-only}4.3. Produkt-Lifecycle der stabilen Versionen {#heading_support_periods}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Ob Ihre Version
also noch gepflegt wird und wann sie ihr Lebensende (*End of Life*)
erreicht hat oder erreichen wird, können Sie der nachfolgenden Tabelle
entnehmen:
:::

+---------+-------------------+-------------------+-------------------+
| Version | Freigabedatum     | Ende der aktiven  | Ende der passiven |
|         |                   | Pflege            | Pflege            |
+=========+===================+===================+===================+
| [2.3.0  | 29.04.2024        | 6 Monate nach     | 29.10.2026        |
| ]{.new} |                   | Freigabe von      |                   |
|         |                   | [2.4.0]{.new}^\   |                   |
|         |                   | [[1](#_footnote_1 |                   |
|         |                   |  "View footnote." |                   |
|         |                   | ){#_footnoteref_1 |                   |
|         |                   | .footnote}\]^     |                   |
+---------+-------------------+-------------------+-------------------+
| [2.2.0  | 23.05.2023        | 29.10.2024        | 23.11.2025        |
| ]{.new} |                   |                   |                   |
+---------+-------------------+-------------------+-------------------+
| [2.1.0  | 24.05.2022        | 23.11.2023        | 24.11.2024        |
| ]{.new} |                   |                   |                   |
+---------+-------------------+-------------------+-------------------+

::: paragraph
Für ältere Versionen empfehlen wir dringend ein Update.
:::
:::::
::::::::::::::
:::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: {#footnotes}

------------------------------------------------------------------------

::: {#_footnote_1 .footnote}
\[[1](#_footnoteref_1)\]. Aktuell ist noch kein Freigabedatum
festgesetzt.
:::
::::
