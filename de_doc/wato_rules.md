:::: {#header}
# Regeln

::: details
[Last modified on 27-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/wato_rules.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html) [Verwaltung der
Hosts](hosts_setup.html) [Services verstehen und
konfigurieren](wato_services.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::::::::::::::::::: sectionbody
::: paragraph
In Checkmk konfigurieren Sie Parameter für Hosts und Services über
*Regeln.* Diese Besonderheit macht Checkmk in komplexen Umgebungen sehr
leistungsfähig und bringt auch in kleineren Installationen etliche
Vorteile. Um das Prinzip der regelbasierten Konfiguration anschaulich zu
machen, vergleichen wir es mit der klassischen Methode.
:::

::::: sect2
### []{#classic .hidden-anchor .sr-only}1.1. Der klassische Ansatz {#heading_classic}

::: paragraph
Nehmen wir als Beispiel die Konfiguration von Schwellwerten für
[WARN]{.state1} und [CRIT]{.state2} bei der Überwachung von
Dateisystemen. Bei einer an Datenbanken orientierten Konfiguration würde
man in einer Tabelle für jedes Dateisystem eine Zeile anlegen:
:::

+-----------------+-----------------+-----------------+-----------------+
| Host            | Dateisystem     | Warnung         | Kritisch        |
+=================+=================+=================+=================+
| `myserver001`   | `/var`          | 90 %            | 95 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver001`   | `/sapdata`      | 90 %            | 95 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver001`   | `/var/log`      | 90 %            | 95 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver002`   | `/var`          | 85 %            | 90 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver002`   | `/opt`          | 85 %            | 90 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver002`   | `/sapdata`      | 85 %            | 95 %            |
+-----------------+-----------------+-----------------+-----------------+
| `myserver002`   | `/var/trans`    | 100 %           | 100 %           |
+-----------------+-----------------+-----------------+-----------------+

::: paragraph
Das ist einigermaßen übersichtlich --- aber nur weil die Tabelle hier
kurz ist. In der Praxis haben Sie eher Hunderte oder Tausende von
Dateisystemen. Werkzeuge wie Copy & Paste und Bulk-Operationen können
die Arbeit erleichtern, aber es bleibt ein Grundproblem: Wie können Sie
hier eine Richtlinie (*policy*) erkennen und durchsetzen? Wie ist die
generelle Regel? Wie sollen Schwellwerte für zukünftige Hosts
eingestellt werden?
:::
:::::

:::::::: sect2
### []{#rule_based .hidden-anchor .sr-only}1.2. Regelbasiert ist besser! {#heading_rule_based}

::: paragraph
Eine regelbasierte Konfiguration hingegen **besteht** aus der
Richtlinie! Die Logik der obigen Tabelle ersetzen wir durch einen Satz
aus vier Regeln. Wenn wir davon ausgehen, dass `myserver001` ein
Testsystem ist, und dass für jedes Dateisystem die jeweils *erste
zutreffende Regel* gilt, ergeben sich die gleichen Schwellwerte wie in
der Tabelle von oben:
:::

::: {.olist .arabic}
1.  Dateisysteme mit dem Mount-Punkt `/var/trans` haben die Schwellwerte
    100/100 %.

2.  Das Dateisystem `/sapdata` auf `myserver002` hat die Schwellwerte
    85/95 %.

3.  Dateisysteme auf Testsystemen haben die Schwellwerte 90/95 %.

4.  Alle (übrigen) Dateisysteme haben die Schwellwerte 85/90 %.
:::

::: paragraph
Zugegeben --- bei nur zwei Hosts bringt das nicht viel. Aber wenn es nur
ein paar mehr sind, wird der Mehraufwand schnell sehr groß. Die Vorteile
der regelbasierten Konfiguration liegen auf der Hand:
:::

::: ulist
- Die Richtlinie ist klar erkennbar und wird zuverlässig durchgesetzt.

- Sie können die Richtlinie jederzeit ändern, ohne dass Sie Tausende
  Datensätze anfassen müssen.

- *Ausnahmen* sind immer noch möglich, aber in Form von Regeln
  dokumentiert.

- Das Aufnehmen von neuen Hosts ist einfach und wenig fehleranfällig.
:::

::: paragraph
Zusammengefasst also: weniger Arbeit --- mehr Qualität! Und deswegen
finden Sie Regeln bei Checkmk an allen Stellen, wo es irgendwie um Hosts
oder Services geht: bei Schwellwerten, Monitoring-Einstellungen,
Zuständigkeiten, Benachrichtigungen, Agentenkonfiguration und vielem
mehr.
:::
::::::::

::::::::: sect2
### []{#rule_set_types .hidden-anchor .sr-only}1.3. Arten von Regelsätzen {#heading_rule_set_types}

::: paragraph
Im Setup von Checkmk werden Regeln in *Regelsätzen* organisiert. Jeder
Regelsatz hat die Aufgabe, einen ganz bestimmten Parameter für Hosts
oder Services festzulegen. In Checkmk gibt es über 700 Regelsätze! Hier
einige Beispiele:
:::

::: ulist
- [Host check command]{.guihint} --- legt fest, wie geprüft werden soll,
  ob Hosts [UP]{.hstate0} sind.

- [Alternative display name for services]{.guihint} --- definiert für
  Services alternative Anzeigenamen.

- [JVM memory levels]{.guihint} --- legt Schwellwerte und andere
  Parameter für die Überwachung des Speicherbedarfs von Java virtuellen
  Maschinen (VM) fest.
:::

::: paragraph
Jeder Regelsatz ist entweder für Hosts oder für Services
zuständig --- nie für beide. Wenn Parameter sowohl für Hosts als auch
für Services einstellbar sind, gibt es jeweils ein Paar von
Regelsätzen --- z.B. [Normal check interval for host checks]{.guihint}
und [Normal check interval for services checks]{.guihint}.
:::

::: paragraph
Einige Regelsätze legen genau genommen nicht Parameter fest, sondern
erzeugen Services. Ein Beispiel sind die Regeln für [aktive
Checks](glossar.html#active_check), die Sie unter [Setup \> Services \>
HTTP, TCP, Email, ...​]{.guihint} finden. Damit können Sie z.B. einen
HTTP-Check für bestimmte Hosts einrichten. Diese Regeln gelten als
Host-Regeln. Denn die Tatsache, dass so ein Check auf einem Host
existiert, gilt als eine Eigenschaft des Hosts.
:::

::: paragraph
Ferner gibt es Regelsätze, welche die
[Service-Erkennung](glossar.html#service_discovery) steuern. So können
Sie z.B. über [Windows service discovery]{.guihint} festlegen, für
welche Windows-Dienste automatisch Checks eingerichtet werden sollen,
falls diese auf einem System gefunden werden. Auch dies sind
Host-Regeln.
:::

::: paragraph
Der Großteil der Regelsätze legt Parameter für bestimmte
[Check-Plugins](glossar.html#check_plugin) fest. Ein Beispiel ist
[Network interfaces and switch ports.]{.guihint} Die Einstellungen in
diesen Regeln sind sehr individuell auf das jeweilige Plugin
zugeschnitten. Solche Regelsätze finden grundsätzlich nur bei denjenigen
Services Anwendung, die auf diesem Check-Plugin basieren. Falls Sie
unsicher sind, welcher Regelsatz für welche Services zuständig ist,
navigieren Sie am besten direkt über den Service zur passenden Regel.
Wie das geht, erfahren Sie später.
:::
:::::::::

:::::: sect2
### []{#host_tags .hidden-anchor .sr-only}1.4. Host-Merkmale {#heading_host_tags}

::: paragraph
Eines haben wir bisher noch unterschlagen: In obigem Beispiel gibt es
eine Regel für alle Testsysteme. Wo ist eigentlich festgelegt, welcher
Host ein Testsystem ist?
:::

::: paragraph
So etwas wie *Testsystem* heißt bei Checkmk
[Host-Merkmal](glossar.html#host_tag) (englisch: *host tag*). Welche
Merkmale es gibt, können Sie sich über [Setup \> Hosts \>
Tags]{.guihint} anzeigen lassen. Einige Merkmale sind bereits
vordefiniert --- zum Beispiel für ein [Test system]{.guihint}, das in
der Gruppe [Criticality]{.guihint} definiert ist.
:::

::: paragraph
Die Zuordnung zu den Hosts geschieht entweder explizit in den
Eigenschaften des Hosts oder per Vererbung über die Ordnerhierarchie.
Wie das geht, erfahren Sie im [Artikel über die
Hosts.](hosts_setup.html#folder) Wie Sie eigene Merkmale anlegen können
und was es mit den bereits vordefinierten Merkmalen auf sich hat, lesen
Sie im Artikel über die [Host-Merkmale.](host_tags.html)
:::
::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#determining_sets .hidden-anchor .sr-only}2. Auffinden der richtigen Regelsätze {#heading_determining_sets}

:::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::::::: sect2
### []{#host_rule_sets .hidden-anchor .sr-only}2.1. Host-Regelsätze {#heading_host_rule_sets}

::: paragraph
Wenn Sie eine neue Regel anlegen möchten, die für einen oder mehrere
Hosts einen Parameter definiert, dann gibt es mehrere Wege zum Ziel. Der
direkte Weg geht über die entsprechende Gruppe im
[Setup]{.guihint}-Menü, in diesem Fall also [Setup \> Hosts \> Host
monitoring rules:]{.guihint}
:::

:::: imageblock
::: content
![Setup-Menü mit Fokus auf die \'Host monitoring
rules\'.](../images/wato_rules_host_monitoring_rules.png)
:::
::::

::: paragraph
In der folgenden Ansicht werden nun alle für das Host-Monitoring
relevanten Regelsätze angezeigt. Die Zahlen hinter den Namen dieser
Regelsätze zeigen die Anzahl der bereits definierten Regeln:
:::

:::: imageblock
::: content
![Die \'Host monitoring rules\' im
Setup-Menü.](../images/wato_rules_host_monitoring_rules_2.png)
:::
::::

::: paragraph
Etwas schneller können Sie allerdings über das *Suchfeld* an Ihr Ziel
gelangen. Dazu müssen Sie natürlich ungefähr wissen, wie der Regelsatz
heißt. Hier ist als Beispiel das Ergebnis einer Suche nach
`host checks`.
:::

:::: imageblock
::: content
![Auszug des Ergebnisses einer Suche nach host
checks.](../images/wato_rules_search_host_checks.png){width="50%"}
:::
::::

::: paragraph
Ein anderer Weg geht über den Menüpunkt [Hosts \> Effective
parameters]{.guihint} in den Eigenschaften eines vorhandenen Hosts im
Setup oder über das [![icon
rulesets](../images/icons/icon_rulesets.png)]{.image-inline} Symbol in
der Liste der Hosts eines Ordners.
:::

:::: imageblock
::: content
![Host-Liste im Setup-Menü mit Hervorhebung des Knopfes für die gültigen
Parameter.](../images/wato_rules_setup_object_parameters.png)
:::
::::

::: paragraph
Dort finden Sie nicht nur alle Regelsätze, die den Host betreffen,
sondern auch den jeweils für diesen Host aktuell wirksamen Parameter. Im
Beispiel von [Host check command]{.guihint} greift für den gezeigten
Host keine Regel, und er steht deswegen auf [Smart PING (only with
Checkmk Micro Core),]{.guihint} dem Standardwert in den kommerziellen
Editionen. In Checkmk Raw ist der Standardwert [PING (active check with
ICMP echo request).]{.guihint}
:::

:::: imageblock
::: content
![Anzeige für das \'Host check command\' mit dem
Standardwert.](../images/wato_rules_host_rule_sets.png)
:::
::::

::: paragraph
Klicken Sie auf [Host Check Command,]{.guihint} um den ganzen Regelsatz
zu sehen.
:::

::: paragraph
Falls bereits eine Regel existiert, erscheint anstelle von [Default
Value]{.guihint} die Nummer der Regel, welche diesen Parameter festlegt:
:::

:::: imageblock
::: content
![Anzeige für das \'Host check command\' mit
Regel.](../images/wato_rules_host_rule_sets2.png)
:::
::::

::: paragraph
Ein Klick darauf bringt Sie direkt zu dieser Regel.
:::
:::::::::::::::::::::::

:::::::::::: sect2
### []{#checkparameters .hidden-anchor .sr-only}2.2. Service-Regelsätze {#heading_checkparameters}

::: paragraph
Der Weg zu den Regelsätzen für Services ist ähnlich. Der allgemeine
Zugang geht auch hier über das [Setup]{.guihint}-Menü, in diesem Fall
also [Setup \> Services \> Service monitoring rules]{.guihint} oder
zweckmäßigerweise über das Suchfeld.
:::

:::: imageblock
::: content
![Setup-Menü mit Fokus auf die \'Service monitoring rules\' und das
Suchfeld.](../images/wato_rules_service_monitoring_rules.png)
:::
::::

::: paragraph
Wenn Sie nicht schon sehr geübt mit den Namen der Regelsätze sind, dann
ist der Weg über den Service allerdings einfacher. Analog zu den Hosts
gibt es auch hier eine Seite, auf der alle Parameter des Services
dargestellt werden und Sie die Möglichkeit haben, die passenden
Regelsätze direkt anzusteuern. Sie erreichen diese Parameterseite mit
dem [![icon services](../images/icons/icon_services.png)]{.image-inline}
Symbol in der Liste der Services eines Hosts im Setup. Das [![icon check
parameters](../images/icons/icon_check_parameters.png)]{.image-inline}
Symbol bringt Sie direkt zu demjenigen Regelsatz, der die [Parameter für
das Check-Plugin](wato_services.html#parameters) des Services festlegt.
:::

:::: imageblock
::: content
![Services-Liste im Setup mit den Symbolen zum Aufruf der
Parameter.](../images/wato_rules_setup_service_list.png)
:::
::::

::: paragraph
Das Symbol [![icon
rulesets](../images/icons/icon_rulesets.png)]{.image-inline} für die
Parameterseite gibt es übrigens auch im Monitoring im Aktionsmenü jedes
Services:
:::

:::: imageblock
::: content
![Services-Liste im Monitoring mit geöffnetem Aktionsmenü eines
Services.](../images/wato_rules_service_context_menu.png)
:::
::::
::::::::::::

:::: sect2
### []{#enforced_services .hidden-anchor .sr-only}2.3. Erzwungene Services {#heading_enforced_services}

::: paragraph
Im [Setup]{.guihint}-Menü finden Sie des Weiteren einen Eintrag für
[Enforced Services]{.guihint}, d.h. für erzwungene Services. Wie der
Name schon sagt, können Sie über diese Regelsätze erzwingen, dass
Services bei Ihren Hosts angelegt werden. Einzelheiten dazu finden Sie
im [Artikel über die Services](wato_services.html#enforced_services).
Eine kleine Zahl von Regelsätzen --- wie z.B. [Simple checks for
BIOS/Hardware errors]{.guihint} --- finden Sie ausschließlich unter den
erzwungenen Services. Hierbei handelt es sich um Services, welche nicht
durch die Service-Erkennung entstehen, sondern von Ihnen manuell
angelegt werden.
:::
::::

:::: sect2
### []{#rule_sets_used .hidden-anchor .sr-only}2.4. Benutzte Regelsätze {#heading_rule_sets_used}

::: paragraph
In jeder der vorgenannten Auflistungen von Regelsätzen --- sei es in den
[Host monitoring rules]{.guihint} oder den [Service monitoring
rules]{.guihint} --- können Sie über [Related \> Used
rulesets]{.guihint} in der Menüleiste, nur genau die Regelsätze anzeigen
lassen, in denen Sie mindestens eine Regel definiert haben. Dies ist oft
ein bequemer Einstieg, wenn Sie Anpassungen an Ihren bestehenden Regeln
vornehmen möchten. Einige der Regeln entstehen übrigens schon beim
Anlegen der Checkmk-Instanz und sind Teil der Beispielkonfiguration.
Auch diese werden hier angezeigt.
:::
::::

:::: sect2
### []{#ineffective_rules .hidden-anchor .sr-only}2.5. Wirkungslose Regeln {#heading_ineffective_rules}

::: paragraph
Monitoring ist eine komplexe Sache. Da kann es schon mal vorkommen, dass
es Regeln gibt, welche bei keinem einzigen Host oder Service
greifen --- entweder, weil Sie einen Fehler gemacht haben oder weil die
passenden Hosts und Services verschwunden sind. Solche wirkungslosen
Regeln können Sie, in den vorgenannten Auflistungen von Regelsätzen,
über [Related \> Ineffective rulesets]{.guihint} in der Menüleiste
anzeigen lassen.
:::
::::

:::::: sect2
### []{#obsolete_rule_sets .hidden-anchor .sr-only}2.6. Veraltete Regelsätze {#heading_obsolete_rule_sets}

::: paragraph
Checkmk wird ständig weiterentwickelt. Gelegentlich werden dabei Dinge
vereinheitlicht und es kommt dazu, dass manche Regelsätze durch andere
ersetzt werden. Wenn Sie solche Regelsätze im Einsatz haben, finden Sie
diese am einfachsten durch eine Regelsuche. Öffnen Sie diese über [Setup
\> General \> Rule search.]{.guihint} Klicken Sie anschließend in der
Menüleiste auf [Rules \> Refine search]{.guihint}, wählen Sie hinter
[Deprecated]{.guihint} die Option [Search for deprecated
rulesets]{.guihint} und hinter [Used]{.guihint} die Option [Search for
rulesets that have rules configured]{.guihint}. Nach einem weiteren
Klick auf [Search]{.guihint} bekommen Sie die gewünschte Übersicht.
:::

:::: imageblock
::: content
![Optionen zur Suche nach veralteten
Regelsätzen.](../images/wato_rules_search_deprecated_rules.png)
:::
::::
::::::
::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#create_rules .hidden-anchor .sr-only}3. Regeln erstellen und editieren {#heading_create_rules}

:::::::::::::::: sectionbody
::: paragraph
Die folgende Abbildung zeigt den Regelsatz [Filesystems (used space and
growth)]{.guihint} mit vier konfigurierten Regeln:
:::

:::: imageblock
::: content
![rules filesystem](../images/rules_filesystem.png)
:::
::::

::: paragraph
**Neue Regeln** erzeugen Sie entweder über den Knopf [Create rule in
folder]{.guihint} oder über das [![icon
clone](../images/icons/icon_clone.png)]{.image-inline} Klonen einer
bestehenden Regel. Das Klonen erzeugt eine identische Kopie einer Regel,
die Sie anschließend mit [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} bearbeiten können.
Eine über den Knopf [Create rule in folder]{.guihint} erzeugte neue
Regel wird immer am Ende der Liste der Regeln erzeugt, während eine
geklonte Regel als Kopie unterhalb des Originals erzeugt wird.
:::

::: paragraph
Die **Reihenfolge** von Regeln können Sie mit dem Knopf [![icon
drag](../images/icons/icon_drag.png)]{.image-inline} ändern. Die
Reihenfolge ist wichtig, weil weiter oben stehende Regeln immer
**Vorrang** vor späteren haben.
:::

::: paragraph
Die Regeln sind dabei in den [Ordnern](hosts_setup.html#folder)
abgelegt, in denen Sie auch die Hosts verwalten. Der Wirkungsbereich von
Regeln ist auf die Hosts eingeschränkt, die in diesem Ordner oder in
seinen Unterordnern liegen. Falls sich Regeln widersprechen, so hat
immer die Regel in einem Unterordner Vorrang. So können z.B. Benutzer,
die nur für manche Ordner [berechtigt](wato_user.html#wato_permissions)
sind, für ihre Hosts Regeln anlegen, ohne dass diese Einfluss auf den
Rest des Systems haben. In den Eigenschaften einer Regel können Sie
deren Ordner ändern und sie somit „umziehen".
:::

::::::::: sect2
### []{#analyse_traffic_light .hidden-anchor .sr-only}3.1. Analyse mit der Ampel {#heading_analyse_traffic_light}

::: paragraph
Wenn Sie im [Setup]{.guihint} einen Regelsatz für einen Host oder
Service ansteuern, zeigt Checkmk Ihnen diesen Regelsatz im
**Analysemodus.** Dorthin gelangen Sie, wenn Sie im [Setup]{.guihint} in
der Host- oder Service-Liste im [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} Aktionsmenü das
Symbol [![icon
rulesets](../images/icons/icon_rulesets.png)]{.image-inline} anklicken.
Die folgende Seite [Effective parameters of]{.guihint} zeigt die Liste
der für den Host/Service geltenden Regeln. Um zum Analysemodus zu
gelangen, klicken Sie den Namen eines Regelsatzes an, für den zumindest
eine Regel existiert, der also nicht auf [Default value]{.guihint}
steht:
:::

:::: imageblock
::: content
![Der Analysemodus mit der
Ampel.](../images/rules_filesystem_analyze.png)
:::
::::

::: paragraph
Dies bewirkt zwei Dinge: Zum einen taucht oben ein zweiter Knopf zum
Anlegen von Regeln auf: [Add rule for current host]{.guihint} bzw. [Add
rule for current host and service.]{.guihint}
:::

::: paragraph
Damit können Sie eine neue Regel erzeugen, welche als Bedingung direkt
den aktuellen Host bzw. Service eingetragen hat. So können Sie sehr
einfach direkt eine Ausnahmeregel erzeugen. Zum anderen taucht in jeder
Zeile ein Kugelsymbol auf, welches Ihnen anzeigt, ob diese Regel für den
aktuellen Host bzw. Service greift. Dabei gibt es folgende mögliche
Fälle:
:::

+---+-------------------------------------------------------------------+
| [ | Diese Regel greift nicht für den aktuellen Host oder Service.     |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| h |                                                                   |
| y |                                                                   |
| p |                                                                   |
| h |                                                                   |
| e |                                                                   |
| n |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| h |                                                                   |
| y |                                                                   |
| p |                                                                   |
| h |                                                                   |
| e |                                                                   |
| n |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Diese Regel greift und definiert einen oder mehrere Parameter.    |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| f |                                                                   |
| i |                                                                   |
| r |                                                                   |
| m |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| f |                                                                   |
| i |                                                                   |
| r |                                                                   |
| m |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Diese Regel greift zwar. Aber da eine Regel weiter oben auch      |
| ! | greift und Vorrang hat, ist die Regel wirkungslos.                |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| c |                                                                   |
| k |                                                                   |
| m |                                                                   |
| a |                                                                   |
| r |                                                                   |
| k |                                                                   |
| o |                                                                   |
| r |                                                                   |
| a |                                                                   |
| n |                                                                   |
| g |                                                                   |
| e |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| c |                                                                   |
| k |                                                                   |
| m |                                                                   |
| a |                                                                   |
| r |                                                                   |
| k |                                                                   |
| _ |                                                                   |
| o |                                                                   |
| r |                                                                   |
| a |                                                                   |
| n |                                                                   |
| g |                                                                   |
| e |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+
| [ | Diese Regel greift. Eine Regel weiter oben hat zwar Vorrang und   |
| ! | greift auch, definiert aber nicht alle Parameter, so dass         |
| [ | mindestens ein Parameter von dieser Regel definiert wird.         |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| c |                                                                   |
| k |                                                                   |
| m |                                                                   |
| a |                                                                   |
| r |                                                                   |
| k |                                                                   |
| p |                                                                   |
| l |                                                                   |
| u |                                                                   |
| s |                                                                   |
| ] |                                                                   |
| ( |                                                                   |
| . |                                                                   |
| . |                                                                   |
| / |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| / |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| c |                                                                   |
| h |                                                                   |
| e |                                                                   |
| c |                                                                   |
| k |                                                                   |
| m |                                                                   |
| a |                                                                   |
| r |                                                                   |
| k |                                                                   |
| _ |                                                                   |
| p |                                                                   |
| l |                                                                   |
| u |                                                                   |
| s |                                                                   |
| . |                                                                   |
| p |                                                                   |
| n |                                                                   |
| g |                                                                   |
| ) |                                                                   |
| ] |                                                                   |
| { |                                                                   |
| . |                                                                   |
| i |                                                                   |
| m |                                                                   |
| a |                                                                   |
| g |                                                                   |
| e |                                                                   |
| - |                                                                   |
| i |                                                                   |
| n |                                                                   |
| l |                                                                   |
| i |                                                                   |
| n |                                                                   |
| e |                                                                   |
| } |                                                                   |
+---+-------------------------------------------------------------------+

::: paragraph
Der letzte Fall --- das [![icon checkmark
plus](../images/icons/icon_checkmark_plus.png)]{.image-inline} partielle
Greifen einer Regel --- kann nur bei solchen Regelsätzen auftreten, in
denen eine Regel **mehrere Parameter** festlegt, welche durch Checkboxen
einzeln angewählt werden können. Hier kann theoretisch jeder einzelne
der Parameter von einer anderen Regel festgelegt werden. Dazu später
mehr.
:::
:::::::::
::::::::::::::::
:::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#rule_characteristics .hidden-anchor .sr-only}4. Eigenschaften einer Regel {#heading_rule_characteristics}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Jede Regel besteht aus drei Blöcken. Der erste Block enthält allgemeine
Informationen zur Regel, wie z.B. den Namen der Regel. Im zweiten Block
wird definiert, was die Regel machen soll, welche Aktionen also durch
sie ausgeführt werden. Der dritte Block enthält die Informationen
darüber, auf wen, d.h. auf welche Hosts oder Services, die Regel
angewendet werden soll.
:::

::::::: sect2
### []{#rule_properties .hidden-anchor .sr-only}4.1. Allgemeine Optionen (Rule properties) {#heading_rule_properties}

::: paragraph
Alles im ersten Block [Rule Properties]{.guihint} ist optional und dient
vor allem der Dokumentation:
:::

:::: imageblock
::: content
![Allgemeine Regeloptionen.](../images/rules_props_properties.png)
:::
::::

::: ulist
- Die [Description]{.guihint} wird in der Tabelle aller Regeln eines
  Regelsatzes angezeigt.

- Das Feld [Comment]{.guihint} können Sie für eine längere Beschreibung
  verwenden. Es erscheint nur im Editiermodus einer Regel. Über das
  Symbol [![icon
  insertdate](../images/icons/icon_insertdate.png)]{.image-inline}
  können Sie einen Zeitstempel und Ihren Login-Namen in den Text
  einfügen lassen.

- Die [Documentation URL]{.guihint} ist für einen Link auf interne
  Dokumentation gedacht, die Sie in einem anderen System (z.B. einer
  CMDB) pflegen. Sie wird in der Regeltabelle über das Symbol [![icon
  url](../images/icons/icon_url.png)]{.image-inline} anklickbar
  dargestellt.

- Mit der Checkbox [do not apply this rule]{.guihint} können Sie die
  Regel vorübergehend abschalten. Sie wird dann in der Tabelle mit
  [![icon disabled](../images/icons/icon_disabled.png)]{.image-inline}
  dargestellt und hat keine Wirkung.
:::
:::::::

::::::::::::::: sect2
### []{#defined_parameters .hidden-anchor .sr-only}4.2. Die festgelegten Parameter {#heading_defined_parameters}

::: paragraph
Der zweite Abschnitt ist bei jeder Regel anders, legt aber immer fest,
was geschehen soll. Folgende Abbildung zeigt einen weit verbreiteten Typ
von Regel ([DB2 Tablespaces]{.guihint}). Über Checkboxen können Sie
bestimmen, welche Einzelparameter die Regel definieren soll. Wie weiter
oben beschrieben, wird von Checkmk für jeden einzelnen Parameter
getrennt ermittelt, welche Regel diesen setzt. Die Regel aus der
Abbildung setzt also nur den einen Wert und lässt alle anderen
Einstellungen unbeeinflusst:
:::

:::: imageblock
::: content
![Verschiedene Regelwerte mit Festlegung eines
Wertes.](../images/rules_props_value_1.png)
:::
::::

::: paragraph
Die Werte in dieser und anderen Regeln können Sie auch zeitabhängig
steuern. So können Sie zum Beispiel die Schwellwerte für die Nutzung der
Tablespaces während der Geschäftszeiten anders setzen als am Wochenende.
:::

::: paragraph
Klicken Sie erst auf den Knopf [Enable timespecific
parameters]{.guihint} und dann auf [Add new element]{.guihint}, werden
Ihnen die zeitabhängigen Optionen angezeigt:
:::

:::: imageblock
::: content
![Ansicht der Regelwerte bei Auswahl zeitabhängiger
Parameter.](../images/wato_rules_time_period.png)
:::
::::

::: paragraph
Nun wählen Sie in der Liste [Match only during time period]{.guihint}
eine [Zeitperiode](timeperiods.html) aus und anschließend die Parameter,
für die diese Zeitperiode gelten soll.
:::

::: paragraph
Manche Regelsätze legen keinen Parameter fest, sondern entscheiden nur,
welche Hosts *drin* sind und welche nicht. Ein Beispiel ist der
Regelsatz [Hosts to be monitored]{.guihint}, dessen Parameterbereich so
aussieht:
:::

:::: imageblock
::: content
![Auswahl der positiven oder negativen
Übereinstimmung.](../images/wato_rules_positive.png)
:::
::::

::: paragraph
Durch Auswahl eines der beiden verfügbaren Werte entscheiden Sie, was
mit den betroffenen Hosts geschehen soll. Wählen Sie [Positive match
(Add matching hosts to the set)]{.guihint}, so werden die betroffenen
Hosts in die Menge der zu überwachenden Hosts aufgenommen. Durch Auswahl
von [Negative match (Exclude matching hosts from the set)]{.guihint}
entfernen Sie die betroffenen Hosts aus dem Monitoring. Das [Positive
match]{.guihint} bzw. [Negative match]{.guihint} bezieht sich auf den
Inhalt der aktuellen Regel. Es ist *kein* zusätzliches Filterkriterium
zur Auswahl der Hosts. Die Menge der betroffenen Hosts filtern Sie
ausschließlich mit den nachfolgenden Bedingungen
([Conditions]{.guihint}).
:::
:::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect2
### []{#conditions .hidden-anchor .sr-only}4.3. Bedingungen (Conditions) {#heading_conditions}

::: paragraph
Im vorigen Abschnitt haben Sie festgelegt, wie all jene Hosts bzw.
Services bearbeitet werden sollen, die von Ihrer Regel betroffen sind.
Im dritten Abschnitt [Conditions]{.guihint} definieren Sie nun, welche
Hosts bzw. Services für die Regel --- und damit deren
Auswirkungen --- herangezogen werden sollen. Dabei gibt es verschiedene
Arten von Bedingungen, die alle erfüllt sein müssen, damit die Regel
greift. Die Bedingungen werden also logisch UND-verknüpft:
:::

:::: imageblock
::: content
![Die Bedingungen für eine
Regel.](../images/rules_props_conditions_1.png)
:::
::::

:::::: sect3
#### []{#_condition_type .hidden-anchor .sr-only}Condition type {#heading__condition_type}

::: paragraph
Hier haben Sie die Möglichkeit, neben einer normalen Bedingung auch auf
vordefinierte Bedingungen (*predefined conditions*) zurückzugreifen.
Diese werden über [Setup \> General \> Predefined conditions]{.guihint}
verwaltet. Geben Sie hier Regelbedingungen, die Sie immer wieder
brauchen, einen festen Namen und verweisen in den Regeln einfach darauf.
Sie können sogar später den Inhalt dieser Bedingungen zentral ändern und
alle Regeln werden automatisch angepasst. In folgendem Beispiel wird die
vordefinierte Bedingung [No VM]{.guihint} ausgewählt:
:::

:::: imageblock
::: content
![Auswahl einer vordefinierten Bedingung für eine
Regel.](../images/rules_props_conditions_2.png)
:::
::::
::::::

:::: sect3
#### []{#_folder .hidden-anchor .sr-only}Folder {#heading__folder}

::: paragraph
Mit der Bedingung [Folder]{.guihint} legen Sie fest, dass die Regel nur
für Hosts gelten soll, die in diesem Ordner (oder einem Unterordner)
enthalten sind. Ist die Einstellung auf [Main,]{.guihint} so gilt diese
Bedingung also für alle Hosts. Wie weiter oben beschrieben, haben die
Ordner auch einen Einfluss auf die Reihenfolge der Regeln. Regeln in
tieferen Ordnern haben immer Vorrang vor Regeln in höher liegenden.
:::
::::

::::::::: sect3
#### []{#_host_tags .hidden-anchor .sr-only}Host tags {#heading__host_tags}

::: paragraph
Die [Host tags]{.guihint} schränken die Regel auf solche Hosts ein, die
bestimmte Host-Merkmale haben oder nicht haben. Auch hier wird immer mit
UND verknüpft. Jede weitere Bedingung für Host-Merkmale in einer Regel
verringert also die Menge der Hosts, auf die diese wirkt.
:::

::: paragraph
Wenn Sie eine Regel für zwei mögliche Ausprägungen eines Merkmals gelten
lassen möchten (z.B. bei [Criticality]{.guihint} sowohl [Productive
system]{.guihint} als auch [Business critical]{.guihint}), so geht das
nicht mit einer einzelnen Regel. Sie benötigen dann eine Kopie der Regel
für jede Variante. Manchmal hilft hier aber auch die Negation. Sie
können als Bedingung auch festlegen, dass ein Merkmal **nicht**
vorhanden ist (z.B. nicht [Test system]{.guihint}). Eine andere
Möglichkeit sind sogenannte [Hilfsmerkmale.](host_tags.html#aux_tag)
:::

::: paragraph
Weil einige Anwender wirklich sehr viele Host-Merkmale verwenden, haben
wir den Dialog so gestaltet, dass nicht sofort alle Host-Merkmalsgruppen
angezeigt werden. Sie müssen diese zunächst für die Regel aktivieren.
Das geht so:
:::

::: {.olist .arabic}
1.  Wählen Sie in der Auswahlbox eine Host-Merkmalsgruppe.

2.  Klicken Sie [Add tag condition]{.guihint}. Dadurch wird darüber ein
    Eintrag für diese Gruppe hinzugefügt.

3.  Wählen Sie [is]{.guihint} oder [is not.]{.guihint}

4.  Wählen Sie das gewünschte Merkmal als Vergleichswert.
:::

:::: imageblock
::: content
![Festlegung mehrerer Host-Merkmale in einer
Bedingung.](../images/rules_props_hosttags.png)
:::
::::
:::::::::

:::: sect3
#### []{#_labels .hidden-anchor .sr-only}Labels {#heading__labels}

::: paragraph
Auch [Labels](glossar.html#label) können Sie für Bedingungen in Regeln
verwenden. Lesen Sie hierzu die Beschreibung zu den [Bedingungen in
Regeln.](labels.html#rule_conditions)
:::
::::

::::::::::::: sect3
#### []{#_explicit_hosts .hidden-anchor .sr-only}Explicit hosts {#heading__explicit_hosts}

::: paragraph
Diese Art von Bedingung ist für Ausnahmeregeln vorgesehen. Hier können
Sie einen oder mehrere Host-Namen auflisten. Die Regel gilt dann nur für
diese Hosts. Beachten Sie, dass wenn Sie [Explicit hosts]{.guihint}
angekreuzt haben und **keinen** Host eintragen, die Regel überhaupt
nicht greifen wird.
:::

::: paragraph
Über die Option [Negate]{.guihint} können Sie eine umgekehrte Ausnahme
definieren. Damit schließen Sie bestimmte explizit genannte Hosts von
der Regel aus. Die Regel greift dann für alle Hosts **außer** den hier
genannten.
:::

:::: imageblock
::: content
![Bedingung für explizit genannte
Hosts.](../images/rules_props_explicithosts_1.png)
:::
::::

::: paragraph
**Wichtig**: Alle hier eingetippten Host-Namen werden auf **genaue
Übereinstimmung** geprüft. Groß-/Kleinschreibung wird von Checkmk in
Host-Namen grundsätzlich unterschieden!
:::

::: paragraph
Sie können dieses Verhalten auf [reguläre Ausdrücke](regexes.html)
umstellen, indem Sie dem Host-Namen eine Tilde (`~`) voranstellen. In
diesem Fall gilt wie immer im [Setup]{.guihint}:
:::

::: ulist
- Die Suche geht auf den **Anfang** des Host-Namens.

- Die Suche ignoriert Groß-/Kleinschreibung.
:::

::: paragraph
Punkt-Stern (`.*`) bedeutet bei [regulären Ausdrücken](regexes.html)
eine beliebige Folge von Zeichen. Folgendes Beispiel zeigt eine
Bedingung, die bei allen Hosts greift, deren Namen die Zeichenfolge `my`
(oder `My`, `MY`, `mY` usw.) **enthält**:
:::

:::: imageblock
::: content
![Bedingung zur Host-Auswahl mit
Platzhaltern.](../images/rules_props_explicithosts_2.png)
:::
::::
:::::::::::::

::::::::: sect3
#### []{#_explicit_services .hidden-anchor .sr-only}Explicit services {#heading__explicit_services}

::: paragraph
Bei Regeln, die sich auf Services beziehen, gibt es als letzte
Bedingungsart noch eine Suche auf den Namen des Services, bzw. bei
Regeln, die Check-Parameter festlegen, auf den Namen des **Check
Items.** Wonach genau gesucht wird, sehen Sie in der Beschriftung. In
unserem Beispiel ist das der Name ([Instance]{.guihint}) eines
Tablespaces:
:::

:::: imageblock
::: content
![Bedingung zur Service-Auswahl mit
Platzhaltern.](../images/rules_props_explicitservices.png)
:::
::::

::: paragraph
Hier gilt grundsätzlich eine Suche mit [regulären
Ausdrücken](regexes.html). Die Folge `.*temp` findet alle Tablespaces,
die `temp` **enthalten,** denn die Suche geht immer auf den Anfang des
Namens. Das Dollarzeichen am Ende von `transfer$` steht für das Ende und
erzwingt somit einen exakten Treffer. Ein Tablespace mit dem Namen
`transfer2` würde daher **nicht** gefunden.
:::

::: paragraph
Vergessen Sie nicht: Bei Regeln, in denen es um [Explicit
services]{.guihint} geht, benötigen Sie eine Suche nach dem
Service-Namen (z.B. `Tablespace transfer`). Bei Regeln mit
Check-Parametern geht es um eine Suche nach dem Item (z.B. `transfer`).
Das Item ist quasi der variable Teil des Service-Namens und legt fest,
um *welchen* Tablespace es sich handelt.
:::

::: paragraph
Es gibt übrigens auch Services ohne Item. Ein Beispiel ist die [CPU
load.]{.guihint} Diese gibt es pro Host nur einmal, also ist kein Item
notwendig. Regeln für solche Check-Typen haben folglich auch keine
Bedingung dafür.
:::
:::::::::
:::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#matching .hidden-anchor .sr-only}5. Regelauswertungen {#heading_matching}

:::::::::::::::::::::: sectionbody
::: paragraph
Nun haben wir beschrieben, wie Regeln erstellt werden. Mit der
Erstellung von Regeln ist es jedoch nicht getan. Im Beispiel des
Abschnitts [Regelbasiert ist besser](#rule_based) reicht eine einzelne
Regel nicht, um das gewünschte Ergebnis zu erreichen. Ein komplexeres
System aus logisch aufeinanderfolgenden Regeln wird hierfür benötigt.
Damit wird auch das Verständnis für das Zusammenspiel verschiedener
Regeln bedeutsam.
:::

::::::: sect2
### []{#matching_type .hidden-anchor .sr-only}5.1. Arten der Regelauswertung {#heading_matching_type}

::: paragraph
In der Einleitung in das Prinzip der Regeln haben Sie gesehen, dass
immer die erste zutreffende Regel den Ergebniswert festlegt. Das ist
nicht die ganze Wahrheit. Es gibt insgesamt drei verschiedene Arten der
Auswertung:
:::

+-----------------------------------+-----------------------------------+
| Auswertung                        | Verhalten                         |
+===================================+===================================+
| Erste Regel\                      | Die erste Regel, die zutrifft,    |
| ([The first matching rule defines | legt den Wert fest. Weitere       |
| the parameter.]{.guihint})        | Regeln werden nicht mehr          |
|                                   | ausgewertet. Dies ist der         |
|                                   | Normalfall für Regeln, die        |
|                                   | einfache Parameter festlegen.     |
+-----------------------------------+-----------------------------------+
| Erste Regel pro Parameter\        | Jeder Einzelparameter wird von    |
| ([Each parameter is defined by    | der ersten Regel festgelegt, bei  |
| the first matching rule where     | der dieser Parameter definiert    |
| that parameter is                 | ist (Checkbox angekreuzt). Dies   |
| set.]{.guihint})                  | ist der Normalfall für alle       |
|                                   | Regeln mit Unterparametern, die   |
|                                   | mit Checkboxen aktiviert werden.  |
+-----------------------------------+-----------------------------------+
| Alle Regeln\                      | Alle zutreffenden Regeln fügen    |
| ([All matching rules will add to  | Elemente zum Ergebnis hinzu.      |
| the resulting list.]{.guihint})   | Dieser Typ kommt z.B. bei der     |
|                                   | Zuordnung von Hosts und Services  |
|                                   | zu Host-, Service- und            |
|                                   | Kontaktgruppen zum Einsatz.       |
+-----------------------------------+-----------------------------------+

::: paragraph
Die Information, wie die Regel ausgewertet wird, wird bei jedem
Regelsatz direkt unterhalb der Menüleiste angezeigt:
:::

:::: imageblock
::: content
![Anzeige der geltenden Regelauswertung oberhalb der
Regel.](../images/rules_matching_strategy.png)
:::
::::
:::::::

::::::::::::::: sect2
### []{#rules_applied .hidden-anchor .sr-only}5.2. Regelauswertung praktisch erklärt {#heading_rules_applied}

::: paragraph
Wie wird nun konkret ausgewertet, wenn man mehrere Regeln erstellt hat,
die auf mehrere Hosts angewendet werden sollen? Um dies zu
veranschaulichen, nehmen wir ein einfaches Beispiel:
:::

::: paragraph
Angenommen, Sie haben drei Hosts und wollen für jeden dieser Hosts (und
auch für alle künftig hinzukommenden) mit der Regel [Periodic
notifications during host problems]{.guihint} unterschiedliche
periodisch wiederholte Benachrichtigungen festlegen:
:::

::: {.olist .arabic}
1.  Regel A: Host-1 alle 10 Minuten

2.  Regel B: Host-2 alle 20 Minuten

3.  Regel C: alle Hosts alle 30 Minuten (allgemeine Regel, um sowohl
    Host-3 als auch künftige Hosts abzudecken)
:::

::: paragraph
Wenn Sie nun Ihre Konfiguration aktivieren, läuft Checkmk die Regelkette
von oben nach unten durch. Es ergibt sich so die folgende Auswertung:
:::

::: ulist
- Für Host-1 trifft Regel A zu und wird angewendet. Die Benachrichtigung
  für Host-1 erfolgt im 10-Minuten-Takt. Damit ist die Bearbeitung für
  Host-1 abgeschlossen.

- Für Host-2 trifft Regel A nicht zu. Weiter geht es mit Regel B. Diese
  trifft für Host-2 zu und wird angewendet, so dass für Host-2 im
  20-Minuten-Takt benachrichtigt wird. Damit ist die Bearbeitung für
  Host-2 abgeschlossen.

- Für Host-3 trifft Regel A nicht zu, ebenso wenig Regel B. Aber Regel C
  passt und wird angewendet: die Benachrichtigung für Host-3 erfolgt im
  30-Minuten-Takt. Damit ist auch die Bearbeitung für Host-3
  abgeschlossen.
:::

::: paragraph
Zu beachten ist hier: Da bei diesem Regelsatz [„The first matching rule
defines the parameter"](#matching_type) gilt, wird die Abarbeitung der
Regelkette jeweils nach dem ersten Treffer beendet. Die Reihenfolge der
Regeln ist daher entscheidend für das Ergebnis! Das zeigt sich, wenn die
Reihenfolge der Regeln umgestellt wird und Regel B und C vertauscht
werden:
:::

::: {.olist .arabic}
1.  Regel A: Host-1 alle 10 Minuten

2.  Regel C: alle Hosts alle 30 Minuten

3.  Regel B: Host-2 alle 20 Minuten
:::

::: paragraph
Wird nun die Regelkette erneut von oben nach unten für die einzelnen
Hosts durchlaufen, so ändert sich auch das Ergebnis: Regel C trifft
jetzt nicht nur auf Host-3, sondern auch auf Host-2 zu, so dass die
Benachrichtigung für beide Hosts im 30-Minuten-Takt erfolgt. Damit ist
die Bearbeitung für beide Hosts abgeschlossen. Obwohl Regel B für Host-2
relevant wäre, ja sogar für diesen Host geschrieben wurde, wird sie
nicht mehr ausgewertet und angewendet. Im
[Analysemodus](#analyse_traffic_light) sieht das dann so aus:
:::

::::: imageblock
::: content
![Analysemodus für Host-2 nach Vertauschung der Regeln B und
C.](../images/rules_analyse_mode_example.png)
:::

::: title
Für Host-2 trifft auch die letzte Regel mit der gelben Kugel zu, wird
aber nicht angewendet
:::
:::::

::: paragraph
Kombinieren Sie die verschiedenen in diesem Artikel genannten
Einstellungen und beachten dabei die Abarbeitungsreihenfolge, so können
Sie damit komplexe Regelketten für ganze Host-Komplexe aufbauen.
:::
:::::::::::::::
::::::::::::::::::::::
:::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
