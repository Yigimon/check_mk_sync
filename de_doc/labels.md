:::: {#header}
# Labels

::: details
[Last modified on 21-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/labels.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Verwaltung der Hosts](hosts_setup.html) [Regeln](wato_rules.html)
[Benachrichtigungen](notifications.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::::::: sectionbody
::: paragraph
Checkmk unterstützt das Konzept der Labels, von denen Sie beliebig viele
einem Host zuweisen können. Dabei verhalten sich Labels und
[Host-Merkmale](glossar.html#host_tag) (*host tags*) recht ähnlich:
:::

::: ulist
- Labels werden wie Merkmale an Hosts „gehängt".

- Labels können wie Merkmale als Bedingungen in Regeln verwendet werden.

- Labels werden ähnlich wie Merkmale nach dem Prinzip `Schlüssel:Wert`
  erstellt.
:::

::: paragraph
Warum gibt es hier also ein neues Konzept? Nun --- die IT-Welt ändert
sich und wird viel dynamischer. Cloud- und Containersysteme wie [Amazon
Web Services (AWS)](monitoring_aws.html), [Microsoft
Azure](monitoring_azure.html) und
[Kubernetes](monitoring_kubernetes.html) erzeugen und löschen
selbständig *Objekte,* die in Checkmk Hosts entsprechen. In diesen
Technologien spielen Labels und Merkmale eine große Rolle, denn sie
stellen die Verbindung zwischen den überwachten Objekten und ihrer
Bedeutung her. Die Host-Namen hingegen werden zunehmend zufällig und
nichtssagend.
:::

::: paragraph
Checkmk kann mit der [dynamischen Host-Konfiguration](dcd.html) solche
dynamischen Hosts automatisch anlegen und bekommt dabei auch die
Information über die dort bereits vorhandenen Labels/Merkmale. Diese
können Sie dann für Regelbedingungen, Suchen, Auswertungen, Dashboards
und andere Aufgaben verwenden.
:::

::: paragraph
Natürlich stellt sich die Frage, warum wir solche dynamischen Labels
nicht einfach auf das vorhandene Konzept der Host-Merkmale abbilden. Und
in der Tat ist das auch erst einmal sehr naheliegend. Allerdings haben
Host-Merkmale eine sehr wichtige Eigenschaft, die das sehr schwierig und
kompliziert machen würde: Welche Merkmalsgruppen und Merkmale es gibt,
legen Sie bei Checkmk starr fest. Alles ist wohldefiniert. Jeder Host
hat aus jeder Gruppe genau ein Merkmal. Alle können sich darauf
verlassen. Tippfehler in der Schreibweise von Merkmalen können nicht
vorkommen, ebenso wenig Hosts, die sich nicht an das Schema halten. Denn
dessen Einhaltung wird von Checkmk streng kontrolliert. Bei sehr
heterogenen Umgebungen mit vielen Tausend manuell gepflegten Hosts ist
das wichtig und nützlich.
:::

::: paragraph
Dynamische Labels von Kubernetes und Co hingegen sind quasi „Freiform".
Und selbst wenn diese einem Schema folgen, ist dieses Checkmk überhaupt
nicht bekannt. Außerdem überwachen Sie vielleicht mehrere
unterschiedliche Plattformen, die wiederum Labels auf sehr
unterschiedliche Art einsetzen.
:::

::: paragraph
Deswegen wurde mit den Checkmk-Labels ein Konzept eingeführt, welches
bestens auf die wachsende Dynamik passt. Und Sie können die Labels
natürlich auch ohne Anbindung an Cloud-Umgebungen nutzen.
:::

::: paragraph
Zur Beantwortung der Frage „Wann soll man Labels nehmen und wann
Host-Merkmale?" gibt es mehr Informationen im Artikel zur
[Strukturierung der Hosts.](hosts_structure.html)
:::

::: paragraph
Hier sind die Besonderheiten von Labels:
:::

::: ulist
- Labels müssen nirgendwo vordefiniert werden. Es gibt kein fixes Schema
  für Labels. Alles ist Freiform. Alles ist erlaubt.

- Jeder Host kann beliebig viele Labels haben. Diese können manuell
  gepflegt sein, über [Regeln](glossar.html#rule) definiert werden oder
  automatisch entstehen.

- Labels sind nach dem Prinzip `Schlüssel:Wert` aufgebaut. Pro Schlüssel
  darf ein Host nur einen Wert haben. Also kann ein Host, der das Label
  `foo:bar` hat, nicht gleichzeitig `foo:bar2` haben.

- Anders als die Host-Merkmale dürfen sowohl der Schlüssel als auch der
  Wert --- bis auf den Doppelpunkt --- **beliebige Zeichen** enthalten.

- Es gibt keine Unterscheidung zwischen ID und Titel (oder angezeigtem
  Namen): Der Schlüssel des Labels ist beides gleichzeitig.
:::

::: paragraph
Labels haben folgende Aufgaben:
:::

::: ulist
- Sie bilden eine Grundlage für Bedingungen in Konfigurationsregeln,
  z.B. „Alle Hosts mit dem Label `os:windows` sollen so oder so oder
  sehr genau überwacht werden."

- Sie können sehr einfach zusätzliche Informationen oder Anmerkungen zu
  einem Host speichern (z.B. `location:RZ 74/123/xyz`) und diese z.B. in
  [Tabellenansichten](glossar.html#view) anzeigen lassen.
:::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#create_labels .hidden-anchor .sr-only}2. Labels erstellen {#heading_create_labels}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::: sect2
### []{#explicit .hidden-anchor .sr-only}2.1. Explizite Labels {#heading_explicit}

::: paragraph
Einem Host können auf verschiedenen Wegen Labels zugeordnet werden.
:::

::: paragraph
Der erste davon ist einfach: Auf der Seite mit den Host-Eigenschaften,
die angezeigt wird, wenn Sie im [Setup](user_interface.html#setup_menu)
einen [Host erstellen oder bearbeiten,](hosts_setup.html#create_hosts)
können Sie diesem beliebig viele Labels verpassen:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts zum Definieren von
Labels.](../images/labels_host_properties.png)
:::
::::

::: paragraph
Aktivieren Sie [Labels]{.guihint} mit der Checkbox, klicken Sie dann in
das Feld [Add some label]{.guihint}, geben Sie die Label-Definition in
der Form `Schlüssel:Wert` ein und schließen diese mit Enter ab.
:::

::: paragraph
Ein bestehendes Label können Sie durch einen Klick in dessen Text
editieren oder mit dem kleinen Kreuz wieder entfernen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Sowohl der Schlüssel als auch der |
|                                   | Wert eines Labels dürfen *jedes   |
|                                   | beliebige Zeichen*                |
|                                   | enthalten --- außer dem           |
|                                   | Doppelpunkt! Allerdings sollten   |
|                                   | Sie sich genau überlegen, wie Sie |
|                                   | es mit der Groß-/Kleinschreibung  |
|                                   | halten. Denn wenn Sie später      |
|                                   | Bedingungen über Labels           |
|                                   | definieren, dann muss die         |
|                                   | Schreibweise sowohl beim          |
|                                   | Schlüssel als auch beim Wert      |
|                                   | strikt beachtet werden.           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Natürlich können Labels auch von einem Ordner vererbt werden. Wie andere
Attribute auch, können Labels in Unterordnern oder beim Host dann nach
Bedarf wieder überschrieben werden --- und zwar **pro Label**. Wird im
Ordner z.B. das Label `location:munich` gesetzt, so wird dies an alle
Hosts in diesem Ordner vererbt, welche nicht selbst das Label `location`
definiert haben. Andere Labels, die ein Hosts eventuell hat, bleiben
dadurch unberührt.
:::

::: paragraph
Beim Host oder beim Ordner explizit definierte Labels werden in der
Liste der Hosts violett dargestellt:
:::

:::: imageblock
::: content
![Listeneintrag eines Hosts mit den zugewiesenen expliziten
Labels.](../images/labels_host_list.png)
:::
::::
::::::::::::::

::::::::: sect2
### []{#rules .hidden-anchor .sr-only}2.2. Labels über Regeln erzeugen {#heading_rules}

::: paragraph
Wie in Checkmk üblich, können Attribute auch per
[Regeln](glossar.html#rule) den Hosts und Services zugeordnet werden.
Damit werden Sie unabhängig von der Ordnerstruktur. Dies gilt auch für
die Labels. Dazu gibt es den Regelsatz [Host labels]{.guihint}, den Sie
schnell über die [Suche im Setup-Menü](user_interface.html#search_setup)
finden können.
:::

::: paragraph
Folgende Regel fügt allen Hosts im Ordner `Bavaria` mit dem Host-Merkmal
`Real Hardware` das Label `hw:real` hinzu:
:::

:::: imageblock
::: content
![Regel für die Festlegung von Labels für
Hosts.](../images/labels_rule_host_labels.png)
:::
::::

::: paragraph
Vielleicht fällt Ihnen auf, dass bei den Bedingungen zu dieser Regel
Labels *nicht* verwendet werden können. Das ist kein Fehler, sondern
Absicht und vermeidet rekursive Abhängigkeiten und andere Anomalien.
:::

::: paragraph
Über Regeln hinzugefügte Labels werden rot dargestellt, tauchen
allerdings nicht in der Host-Liste im Setup auf, sondern nur in der
[Statusansicht des Hosts](#views).
:::
:::::::::

:::::: sect2
### []{#automatic .hidden-anchor .sr-only}2.3. Automatisch erzeugte Labels {#heading_automatic}

::: paragraph
Die dritte Art, wie Labels entstehen können, ist vollautomatisch.
Verschiedene Datenquellen, wie z.B. die
[Spezialagenten](glossar.html#special_agent) für das Überwachen von
Cloud- und Containersystemen erzeugen automatisch Labels. Im Speziellen
sind hier die Spezialagenten für AWS, Azure und Kubernetes zu nennen.
Mitunter werden diese Dinge auf den jeweiligen Plattformen auch als
*Tags* bezeichnet und in Checkmk eben als Host- oder Service-Labels
angelegt. Die jeweiligen Regelsätze geben darüber hinreichend Auskunft.
:::

::: paragraph
Das Schöne: Sie müssen gar nichts konfigurieren. Sobald diese
Datenquellen aktiv sind, entstehen die entsprechenden Labels.
:::

::: paragraph
Im Abschnitt [Automatisch generierte
Host-Labels](#automatic_host_labels) finden Sie eine Übersicht der
Labels, die Checkmk automatisch generiert.
:::
::::::

:::::::: sect2
### []{#agent_plugins .hidden-anchor .sr-only}2.4. Label per Agentenplugin setzen {#heading_agent_plugins}

::: paragraph
Ein einfacher Weg, Label direkt zu beeinflussen, ist die Ergänzung eines
[Agentenplugins](glossar.html#agent_plugin), das analog zu [lokalen
Checks](glossar.html#local_check) eine Sektion `labels` erzeugt. Sie
können auf diese Weise Labels detaillierter als alleine durch Auswertung
der HW-/SW-Inventur vergeben --- beispielsweise nach Nuancen der
verbauten Hardware (wie CPU-Features) oder tatsächlich laufenden
Prozessen (statt nur installierter Software).
:::

::: paragraph
Die Label-Ausgabe ist hierbei als Python Dictionary zu formatieren, wie
im folgenden Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
<<<labels:sep(0)>>>
{"cpu/vendor": "zilog"}
```
:::
::::

::: paragraph
Vermeiden Sie Konflikte mit den von Checkmk selbst und anderen Plugins
automatisch vergebenen Labels, da keine bestimmte Reihenfolge der
Auswertung garantiert werden kann.
:::
::::::::

::::::::::::: sect2
### []{#discovery_check .hidden-anchor .sr-only}2.5. Im Discovery Check gefundene Labels aufnehmen {#heading_discovery_check}

::: paragraph
Falls Sie den [Discovery Check](wato_services.html#discovery_check)
aktiviert haben --- und das ist bei neuen Installationen per Default der
Fall --- wird dieser Sie warnen, wenn neue Host-Labels gefunden wurden,
welche noch nicht in die Host-Eigenschaften im Setup aufgenommen wurden.
Das sieht dann z.B. so aus:
:::

:::: imageblock
::: content
![Service-Liste mit dem Service \'Check_MK
Discovery\'.](../images/labels_discovery_check.png)
:::
::::

::: paragraph
Sie haben zwei Möglichkeiten, auf diese Warnung zu reagieren. Die erste
ist das Aufnehmen der neuen Labels, indem Sie im Setup die
Service-Konfiguration des Hosts aufrufen und mit dem Menüeintrag [Hosts
\> Update host labels]{.guihint} die Konfiguration der Labels
aktualisieren. Der Discovery Check wird bei der nächsten Ausführung (in
bis zu zwei Stunden) dann wieder [OK]{.state0}, selbst wenn Sie die
Änderungen noch nicht aktiviert haben. Wenn Sie nicht so lange warten
wollen, können Sie den Service auch sofort manuell aktualisieren durch
Auswahl von [Reschedule check]{.guihint} im Aktionsmenü des Services.
:::

::: paragraph
Wenn das viele Hosts auf einmal betrifft, werden Sie sicher nicht für
jeden einzelnen die Service-Konfiguration besuchen wollen. Führen Sie
hier am besten die [Bulk-Aktion](hosts_setup.html#bulk_operations) zur
Service-Erkennung durch ([Run bulk service discovery]{.guihint}) und
wählen Sie als Modus [Only discover new host labels]{.guihint} --- oder
alternativ [Add unmonitored services and new host labels]{.guihint},
wenn Sie bei der Gelegenheit auch gleich neue Services aufnehmen wollen.
:::

::: paragraph
Die zweite Art, den Discovery Check grün zu bekommen, ist, dass Sie
diesen so umkonfigurieren, dass er neue Labels nicht mehr anmahnt. Gehen
Sie dazu in den Regelsatz [Periodic service discovery]{.guihint} und
editieren Sie die bestehende Regel. Dort finden Sie die Option [Severity
of new host labels]{.guihint}:
:::

:::: imageblock
::: content
![Regel für die regelmäßige
Service-Erkennung.](../images/labels_rule_periodic_service_discovery.png)
:::
::::

::: paragraph
Diese ist per Default auf [Warning]{.guihint} eingestellt. Wählen Sie
hier [OK - do not alert, just display]{.guihint} und der Check wird Ruhe
geben.
:::

::: paragraph
Per Discovery Check gefundene Labels werden gelb-ocker dargestellt.
:::
:::::::::::::

:::::: sect2
### []{#sequence .hidden-anchor .sr-only}2.6. Reihenfolge der Labelzuordnung {#heading_sequence}

::: paragraph
Theoretisch kann es sein, dass das gleiche Label in mehreren Quellen
gleichzeitig und mit unterschiedlichen Werten definiert wird. Deswegen
gibt es folgende Reihenfolge des Vorrangs:
:::

::: {.olist .arabic}
1.  Zuerst gelten die expliziten Labels, also solche, die Sie im Setup
    direkt dem Host oder Ordner zuordnen.

2.  An zweiter Stelle gelten Labels, die per Regeln erzeugt werden.

3.  An letzter Stelle stehen die automatisch erzeugten Labels.
:::

::: paragraph
Durch diese Vorrangregeln haben Sie stets die letztgültige Kontrolle
über die Labels.
:::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#conditions .hidden-anchor .sr-only}3. Labels als Bedingungen in Regeln {#heading_conditions}

::::::::::::::::::: sectionbody
:::::::::::::::: sect2
### []{#rule_conditions .hidden-anchor .sr-only}3.1. Bedingungen in Regeln {#heading_rule_conditions}

::: paragraph
Eine wichtige Funktion von Labels ist die gleiche wie bei
Host-Merkmalen: Nämlich ihre Verwendung als Bedingung in Regeln. Das ist
vor allem bei automatisch erzeugten Labels interessant, weil Sie so ihr
Monitoring vollautomatisch aufgrund von Informationen aus AWS, Azure,
Kubernetes und Co anpassen können.
:::

::: paragraph
Fügen Sie Bedingungen mit [Add to condition]{.guihint} für die Host-
oder die Service-Labels hinzu. Wählen Sie nun entweder [is]{.guihint}
oder [not]{.guihint} um eine positive oder negative Bedingung zu
formulieren und geben Sie dann das Label in der gewohnten Form
`Schlüssel:Wert` ein. Achten Sie hier auf die exakte Schreibweise
einschließlich der Groß-/Kleinschreibung. Da Labels ohne Vorgaben
festgelegt werden können, kann Checkmk Vertipper nicht erkennen.
Immerhin: Beim Eintippen eines Labels schlägt Checkmk bereits
existierende Labels vor, sofern sie zu ihrer bisherigen Eingabe passen.
Bei den Vorschlägen wird nicht nach Host- und Service-Labels
unterschieden: es werden alle passenden Labels angeboten. Achten Sie auf
die korrekte Schreibweise, denn Buchstabendreher, falsche
Groß-/Kleinschreibung etc. führen dazu, dass die Regel nicht mehr
funktioniert.
:::

::: paragraph
Die Definition der Bedingung geht aber noch einen Schritt weiter: Um die
Bedingung weiter zu verfeinern, stehen Ihnen zusätzlich die booleschen
Operatoren `Not`, `And` und `Or` zur Verfügung. Dabei ist `Not` die
Abkürzung für `And Not`.
:::

::: ulist
- `Not` bedeutet also, die Bedingung A muss erfüllt und gleichzeitig die
  Bedingung B nicht erfüllt sein.

- `And` bedeutet, dass sowohl die Bedingung A als auch gleichzeitig die
  Bedingung B erfüllt sein müssen.

- `Or` bedeutet, dass entweder Bedingung A oder Bedingung B erfüllt sein
  müssen, aber auch beide Bedingungen erfüllt sein dürfen.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Die Operatoren werden in genau    |
|                                   | dieser Priorität --- `Not`,       |
|                                   | `And`, `Or` --- abgearbeitet,     |
|                                   | also *nicht* notwendigerweise in  |
|                                   | der Reihenfolge, in der sie in    |
|                                   | der Liste stehen. Dies entspricht |
|                                   | dem Standard der booleschen       |
|                                   | Algebra. Zum Beispiel würde       |
|                                   | `A And B Not C Or D` der          |
|                                   | Klammersetzung                    |
|                                   | `(A And (B Not C)) Or D`          |
|                                   | entsprechen.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Um beispielsweise Hosts mit dem Label `cmk/site:heute` aber ohne das
Label `cmk/piggyback_source_heute:yes` zu finden, könnte die Bedingung
wie folgt aussehen:
:::

:::: imageblock
::: content
![Bedingung für Host-Labels.](../images/labels_props_labels.png)
:::
::::

::: paragraph
Diese Bedingung können Sie mit [is]{.guihint} oder [not]{.guihint} um
beliebige weitere Vorgaben verfeinern. Oder Sie fügen mit [Add to
condition]{.guihint} eine neue Gruppe von Bedingungen hinzu, was die
nunmehr komplexere Bedingung besser lesbar macht, aber nichts an der
Auswertung der booleschen Algebra ändert:
:::

:::: imageblock
::: content
![mehrere Bedingungen für
Host-Labels.](../images/labels_props_labels2.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Haben Sie weder [Host             |
|                                   | tags]{.guihint} noch [Host        |
|                                   | labels]{.guihint} definiert, wird |
|                                   | die betreffende Regel immer auf   |
|                                   | alle Hosts bzw. Services          |
|                                   | angewendet. Haben Sie mehrere     |
|                                   | Regeln erstellt, so werden        |
|                                   | nachfolgende Regeln dadurch unter |
|                                   | Umständen nicht mehr ausgewertet, |
|                                   | siehe [Arten der                  |
|                                   | Regelauswe                        |
|                                   | rtung](wato_rules.html#matching). |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Sie können in einer Regel sowohl Labels als auch Host-Merkmale
verwenden. Diese werden automatisch UND verknüpft. Die Regel greift also
nur dann, wenn beide Bedingungen gleichzeitig erfüllt sind.
:::
::::::::::::::::

:::: sect2
### []{#notification_conditions .hidden-anchor .sr-only}3.2. Bedingungen in Benachrichtigungsregeln {#heading_notification_conditions}

::: paragraph
Auch in [Benachrichtigungsregeln](notifications.html#rules) können Sie
Labels als Bedingungen nutzen. Das funktioniert analog zu den anderen
verfügbaren [Bedingungen](notifications.html#rule_conditions), so dass
Sie sich hier nicht umgewöhnen müssen. Wählen Sie [Match host
labels]{.guihint} und geben Sie einfach ein, welche Labels ein Host oder
Service haben muss, damit durch die Regel eine Benachrichtigung
ausgelöst wird. Auch hier werden mehrere Labels durch die
UND-Verknüpfung verbunden.
:::
::::
:::::::::::::::::::
::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#views .hidden-anchor .sr-only}4. Labels in Tabellenansichten {#heading_views}

::::::::::::::::::: sectionbody
::: paragraph
Bisher haben wir fast ausschließlich über die Labels in der
[Konfigurationsumgebung](glossar.html#configuration_environment) (oder
kurz: im Setup) gesprochen. Auch in der
[Monitoring-Umgebung](glossar.html#monitoring_environment) sind die
Labels sichtbar, z.B. in der Statusansicht eines Hosts:
:::

:::: imageblock
::: content
![Dialog mit dem Host-Zustand und den zugewiesenen
Labels.](../images/labels_host_status.png)
:::
::::

::: paragraph
Hier sehen Sie die Labels in den unterschiedlichen Farben, je nachdem,
wie sie erzeugt wurden: Explizite Labels in violett, durch Regeln
erzeugte in rot und per Discovery Check angelegte in gelb-ocker.
:::

::: paragraph
Die Farbtupfer der Label stechen nicht nur optisch aus der Ansicht
hervor, sie sind dazu auch noch praktisch, weil anklickbar, und führen
Sie dann zu einer Suche nach allen Hosts mit diesem Label weiter:
:::

:::: imageblock
::: content
![Filterleiste mit Filter zur Suche nach einem
Label.](../images/labels_search_filterbar.png){width="60%"}
:::
::::

::: paragraph
Hier können Sie nach Hosts fahnden *mit* diesem Label (über die Vorgabe
[is]{.guihint}) oder *ohne* dieses Label (mit der Option [is
not]{.guihint}).
:::

::: paragraph
Auch bei der Label-Suche können Sie die booleschen Operatoren `Not`,
`And` und `Or` nutzen, analog wie sie unter [Bedingungen in
Regeln](#rule_conditions) beschrieben wurden. Um beispielsweise
Linux-Hosts zu finden, die in München stehen und keine Web-Server sind,
könnte der Filter dann wie folgt aussehen:
:::

:::: imageblock
::: content
![Filterleiste mit 3 per logischen Operatoren verknüpften
Label-Filtern.](../images/labels_filter_boolean.png){width="60%"}
:::
::::

::: paragraph
Diesen Filter können Sie noch verfeinern, um z.B. (mit [or]{.guihint})
zusätzlich Windows-Hosts zu finden, die sowohl „headless" als auch
französisch sind (mit [and]{.guihint}). Die drei neuen Zeilen für diese
Erweiterung des Filters können Sie direkt unter die bestehenden
eintragen --- oder Sie erstellen mit [Add to query]{.guihint} eine neue
Gruppe, was den nunmehr komplexeren Filter besser lesbar macht, aber
nichts an der Auswertung der booleschen Algebra ändert:
:::

:::: imageblock
::: content
![Filterleiste mit 6 per logischen Operatoren verknüpften
Label-Filtern.](../images/labels_filter_boolean_extended.png){width="60%"}
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie daran interessiert sind, |
|                                   | welche Klammersetzung Checkmk aus |
|                                   | den eingegebenen Label-Filtern    |
|                                   | erzeugt, können Sie sich die      |
|                                   | zugehörige Livestatus-Abfrage     |
|                                   | einblenden lassen. Dazu           |
|                                   | aktivieren Sie in den globalen    |
|                                   | Einstellungen [Setup \> General   |
|                                   | \> Global settings \> Debug       |
|                                   | Livestatus queries.]{.guihint}    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die Suche nach Labels können Sie natürlich auch mit den anderen
verfügbaren Suchparametern in der Filterleiste kombinieren.
:::
:::::::::::::::::::
::::::::::::::::::::

:::::: sect1
## []{#service_labels .hidden-anchor .sr-only}5. Service-Labels {#heading_service_labels}

::::: sectionbody
::: paragraph
Auch Services können Labels haben. Diese sind ähnlich zu den
Host-Labels, allerdings mit ein paar kleinen Unterschieden:
:::

::: ulist
- Sie können Service-Labels nicht explizit vergeben. Diese können nur
  durch Regeln ([Service labels]{.guihint}) oder automatisch entstehen.

- Auch mit Service-Labels können Sie Bedingungen formulieren. In einem
  Regelsatz werden Ihnen die Service-Labels nur dann zur Eingabe
  angeboten, wenn die Regel auf einen Service matchen kann.
:::
:::::
::::::

::::::::::: sect1
## []{#agent_labels .hidden-anchor .sr-only}6. Agenten-Labels {#heading_agent_labels}

:::::::::: sectionbody
::: paragraph
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** und
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** verfügen über die Möglichkeit, [Hosts automatisch
erstellen](hosts_autoregister.html) zu lassen. Hierfür ist die gesamte
Kette der Registrierung des Agenten, das Anlegen des Hosts, die
Service-Erkennung und die Aktivierung der Änderungen automatisiert. Das
Anlegen des Hosts findet dabei nach der Registrierung statt.
:::

::: paragraph
Dieser Automatismus schafft einige Herausforderungen für die
Strukturierung neu angelegter Hosts. Bislang konnte das Betriebssystem
(im Host-Label `cmk/os_family` hinterlegt) erst aus der Agentenausgabe
ermittelt werden. Um diese zu bekommen, muss der Host jedoch bereits
angelegt sein.
:::

::: paragraph
Aus diesem Grund wurde das Konzept der flüchtigen Agenten-Labels
eingeführt, welche bereits bei der Registrierung übermittelt werden und
damit vor der ersten Agentenausgabe bereit stehen. Während der
Registrierung können Sie anhand dieser Labels bestimmen, ob ein Host
überhaupt im Monitoring angelegt werden soll, und - falls dem so ist -
seinen Ordner, aber auch andere Host-Attribute beeinflussen. Nach
abgeschlossener Registrierung kann nicht mehr auf Agenten-Labels
zugegriffen werden.
:::

::: paragraph
Zwei vordefinierte Agenten-Labels werden immer bei der Registrierung
übertragen:
:::

::: ulist
- `cmk/os-family` enthält die Betriebssystemfamilie (derzeit `Windows`
  oder `Linux`)

- `cmk/hostname-simple` enthält den Computernamen in Kurzform (also ohne
  Domainpart)
:::

::: paragraph
Sie können weitere, benutzerdefinierte Agenten-Label frei vergeben,
beispielsweise: `organizational/department:documentation`.
:::

::: paragraph
Automatisch registrierte Hosts erhalten das Host-Label
`cmk/agent_auto_registered:yes`. Eine direkte Zuweisung von Host-Labels
als Folge bestimmter Agenten-Labels ist nicht vorgesehen. Sie können
jedoch den Weg über die Registrierung in einem (temporären) Ordner und
anschließender Zuweisung von Host-Labels für alle Hosts in diesem Ordner
gehen.
:::
::::::::::
:::::::::::

::::: sect1
## []{#_weitere_informationen .hidden-anchor .sr-only}7. Weitere Informationen {#heading__weitere_informationen}

:::: sectionbody
::: sect2
### []{#automatic_host_labels .hidden-anchor .sr-only}7.1. Automatisch generierte Host-Labels {#heading_automatic_host_labels}

+------------------------+---------------------------------------------+
| Schlüssel              | Werte                                       |
+========================+=============================================+
| `cmk/                  | `yes`, wenn ein Host via Autoregistrierung  |
| agent_auto_registered` | angelegt wurde                              |
+------------------------+---------------------------------------------+
| `cmk/aws/ec2`          | `instance` für alle EC2-Instanzen           |
+------------------------+---------------------------------------------+
| `cmk/aws/account`      | Name des zugehörigen AWS-Accounts           |
+------------------------+---------------------------------------------+
| `cmk/aws/t             | Tags der AWS-Objekte                        |
| ag/{Schlüssel}:{Wert}` |                                             |
+------------------------+---------------------------------------------+
| `cmk                   | Ressourcengruppen, der das Azure-Objekt     |
| /azure/resource_group` | angehört                                    |
+------------------------+---------------------------------------------+
| `cmk/azure/t           | Tags der Azure-Objekte                      |
| ag/{Schlüssel}:{Wert}` |                                             |
+------------------------+---------------------------------------------+
| `cmk/azure/vm`         | `instance` für alle Azure-VMs               |
+------------------------+---------------------------------------------+
| `cmk/check_mk_server`  | `yes` für alle Checkmk-Server               |
+------------------------+---------------------------------------------+
| `cmk/device_type`      | SNMP-übertragene Gerätebezeichnung, z.B.    |
|                        | `appliance`, `fcswitch`, `firewall`,        |
|                        | `printer`, `router`, `sensor`, `switch`,    |
|                        | `ups`, `wlc`                                |
+------------------------+---------------------------------------------+
| `cmk/docker_image`     | Docker-Image, z.B.                          |
|                        | `docker.io/library/nginx:latest`            |
+------------------------+---------------------------------------------+
| `                      | Name des Docker-Images, z.B. `nginx`        |
| cmk/docker_image_name` |                                             |
+------------------------+---------------------------------------------+
| `cmk                   | Version des Docker-Images, z.B. `latest`    |
| /docker_image_version` |                                             |
+------------------------+---------------------------------------------+
| `cmk/docker_object`    | `container`, wenn der Host ein              |
|                        | Docker-Container ist; `node`, wenn der Host |
|                        | ein Docker-Knoten ist                       |
+------------------------+---------------------------------------------+
| `c                     | Diese Bezeichnungen werden für jede         |
| mk/kubernetes/annotati | Kubernetes-Beschriftung ausgegeben, die ein |
| on/{Schlüssel}:{Wert}` | gültiges Kubernetes-Label ist (über die     |
|                        | Regel [Kubernetes]{.guihint}                |
|                        | konfigurierbar).                            |
+------------------------+---------------------------------------------+
| `cmk/kubernetes`       | `yes`, wenn der Host ein Kubernetes-Objekt  |
|                        | ist                                         |
+------------------------+---------------------------------------------+
| `c                     | Name des Kubernetes Clusters                |
| mk/kubernetes/cluster` |                                             |
+------------------------+---------------------------------------------+
| `cmk/ku                | Name des Kubernetes Cluster-Hosts           |
| bernetes/cluster-host` |                                             |
+------------------------+---------------------------------------------+
| `c                     | Kubernetes Cronjobs                         |
| mk/kubernetes/cronjob` |                                             |
+------------------------+---------------------------------------------+
| `cmk                   | Name des DaemonSet                          |
| /kubernetes/daemonset` |                                             |
+------------------------+---------------------------------------------+
| `cmk/                  | Name des Deployments                        |
| kubernetes/deployment` |                                             |
+------------------------+---------------------------------------------+
| `cmk                   | Name des zugehörigen Kubernetes Namespace   |
| /kubernetes/namespace` |                                             |
+------------------------+---------------------------------------------+
| `cmk/kubernetes/node`  | Name des zugehörigen Kubernetes-Knotens.    |
|                        | Checkmk-Hosts vom Typ Pod oder Node         |
|                        | erhalten dieses Label.                      |
+------------------------+---------------------------------------------+
| `                      | Kubernetes Objekttyp, z.B. `endpoint`, wenn |
| cmk/kubernetes/object` | der Host ein Kubernetes Endpunktobjekt ist  |
+------------------------+---------------------------------------------+
| `cmk/k                 | Name des StatefulSet                        |
| ubernetes/statefulset` |                                             |
+------------------------+---------------------------------------------+
| `cmk/meraki`           | `yes` for alle Meraki-Geräte                |
+------------------------+---------------------------------------------+
| `c                     | Typ des Meraki-Geräts, z.B. `switch` oder   |
| mk/meraki/device_type` | `wireless`                                  |
+------------------------+---------------------------------------------+
| `cmk/meraki/net_id`    | Netzwerk-ID des Meraki-Geräts               |
+------------------------+---------------------------------------------+
| `cmk/meraki/org_id`    | ID der Organisation des Meraki-Geräts       |
+------------------------+---------------------------------------------+
| `cmk/meraki/org_name`  | Organisationsname des Meraki-Geräts         |
+------------------------+---------------------------------------------+
| `cmk/nutanix/object`   | `control_plane` für den                     |
|                        | Spezialagenten-Host; `node` für einen       |
|                        | Nutanix-Host; `vm` für Nutanix-VMs          |
+------------------------+---------------------------------------------+
| `cmk/os_family`        | Betriebssystem, vom Agenten als `AgentOS`   |
|                        | gemeldet (z.B. `windows` oder `linux` )     |
+------------------------+---------------------------------------------+
| `cmk/os_type`          | Betriebssystemgattung, vom Agenten als      |
|                        | `OSTyp` gemeldet (z.B. `windows`, `linux`   |
|                        | oder `unix`)                                |
+------------------------+---------------------------------------------+
| `cmk/os_name`          | Betriebssystemname, vom Agenten als         |
|                        | `OSName` gemeldet (z.B.                     |
|                        | `Microsoft Windows 10 Pro`, `Ubuntu` oder   |
|                        | `Oracle Solaris`)                           |
+------------------------+---------------------------------------------+
| `cmk/os_platform`      | Betriebssystemplattform, vom Agenten als    |
|                        | `OSPlatform` gemeldet (z.B. `Ubuntu` bei    |
|                        | Ubuntu-Derivaten wie *Xubuntu*), sofern in  |
|                        | `/etc/os-release` hinterlegt; fehlt diese   |
|                        | Zeile in der Agentenausgabe, erhält das     |
|                        | Label den Wert von `cmk/os_family`          |
+------------------------+---------------------------------------------+
| `cmk/os_version`       | Betriebssystemversion, vom Agenten als      |
|                        | `OSVersion` gemeldet (z.B. bei Ubuntu       |
|                        | `22.04` oder bei Windows `10.0.19045`)      |
+------------------------+---------------------------------------------+
| `cmk/vsphere_object`   | `vm`, wenn der Host eine virtuelle Maschine |
|                        | ist; `server`, wenn der Host ein ESXi       |
|                        | Host-System ist                             |
+------------------------+---------------------------------------------+
| `cmk/vsphere_vcenter`  | `yes`, wenn der Host ein VMware vCenter ist |
+------------------------+---------------------------------------------+
:::
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
