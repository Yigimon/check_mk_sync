:::: {#header}
# Business Intelligence (BI)

::: details
[Last modified on 11-Apr-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/bi.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Ansichten von Hosts und Services (Views)](views.html) [Verfügbarkeit
(Availability)](availability.html)
[Wartungszeiten](basics_downtimes.html)
:::
::::
:::::
::::::
::::::::

::::::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![bi large icon aggr](../images/bi_large_icon_aggr.png){width="80"}
:::
::::

::: paragraph
Checkmk Business Intelligence --- das klingt zugegeben etwas hochtrabend
für eine im Grunde recht einfache Sache. Aber dieser Name trifft den
Kern des *BI*-Moduls von Checkmk recht gut. Hier geht es nämlich darum,
aus den vielen einzelnen Zustandswerten den Gesamtzustand von
**geschäftskritischen Anwendungen** abzuleiten und übersichtlich
darzustellen.
:::

::: paragraph
Nehmen Sie als Beispiel den Dienst *E-Mail,* der in vielen Unternehmen
noch immer unverzichtbar ist. Dieser Dienst basiert auf der korrekten
Funktion einer Vielzahl von Hardware- und
Softwarekomponenten --- angefangen bei bestimmten Switches, über SMTP-
und IMAP-Dienste, bis hin zu Infrastrukturdiensten wie LDAP und DNS.
:::

::: paragraph
Der Ausfall eines essenziellen Bausteins ist kein Problem, wenn dieser
redundant ausgelegt ist. Umgekehrt mag ein Problem bei einem ganz
anderen Service, der auf den ersten Blick mit E-Mail nichts zu tun hat,
viel schwerwiegendere Auswirkungen haben. Ein einfacher Blick auf eine
Liste von Services in Checkmk ist also nicht immer
aussagekräftig --- zumindest nicht für jeden!
:::

::: paragraph
*Checkmk BI* ermöglicht Ihnen, aus dem aktuellen Zustand von einzelnen
Hosts und Services einen Gesamtzustand für eine Anwendung abzuleiten.
Dazu definieren Sie über BI-Regeln, wie die Dinge baumartig voneinander
abhängen. Jede Anwendung ist dann insgesamt [OK]{.state0},
[WARN]{.state1} oder [CRIT]{.state2}. Die Information über den Zustand
und die Abhängigkeiten können Sie auf verschiedene Weise nutzen:
:::

::: ulist
- Anzeige des Gesamtzustands einer Anwendung in der GUI.

- Berechnung der [Verfügbarkeit](availability.html) einer Anwendung.

- [Benachrichtigungen](notifications.html) bei einem Problem oder gar
  einem Ausfall einer Anwendung.

- Impact-Analyse: Ein Service geht auf [CRIT]{.state2} --- welche
  Anwendungen sind davon betroffen?

- Planung von Wartungszeiten und „Was wäre wenn ...​"-Analysen.
:::

::: paragraph
Daneben gibt es noch die Möglichkeit, die Baumdarstellung von BI für
eine „Drill Down"-Ansicht für den Zustand eines Hosts mit allen seinen
Services zu verwenden.
:::

::: paragraph
Eine Besonderheit von Checkmk BI im Gegensatz zu vergleichbaren Tools im
Monitoring-Umfeld ist, dass Checkmk auch hier *regelbasiert* arbeitet.
Das ermöglicht Ihnen z.B. mit einem generischen Satz von Regeln,
dynamisch eine unbestimmte Zahl von ähnlichen Anwendungen zu
beschreiben. Das erleichtert immens die Arbeit und hilft, Fehler zu
vermeiden --- besonders in sehr dynamischen Umgebungen.
:::

:::: imageblock
::: content
![business intelligence](../images/business_intelligence.png)
:::
::::
::::::::::::::
:::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#first .hidden-anchor .sr-only}2. Konfiguration Teil 1: Das erste Aggregat {#heading_first}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_begriffe .hidden-anchor .sr-only}2.1. Begriffe {#heading__begriffe}

::: paragraph
Bevor Sie Schritt für Schritt mit der Praxis anfangen, benötigen Sie
zunächst ein paar Begriffe:
:::

::: paragraph
Jede mit BI formalisierte Anwendung wird als **Aggregation** bezeichnet,
da hier aus vielen Einzelzuständen ein Gesamtzustand aggregiert wird.
:::

::: paragraph
Eine Aggregation ist ein Baum von Objekten. Diese werden **Knoten**
genannt. Die untersten Knoten --- also die *Blätter* des Baums --- sind
Hosts und Services aus Ihren Checkmk-Instanzen. Die übrigen Knoten sind
künstlich erzeugte BI-Objekte.
:::

::: paragraph
Jeder Knoten wird durch eine **Regel** erzeugt. Das gilt auch für die
Wurzel des Baums --- also den obersten Knoten. Die Regeln legen fest,
welche Knoten unter einem Knoten hängen und wie aus deren Zuständen der
Zustand des Knotens berechnet werden soll.
:::

::: paragraph
Auch der oberste Knoten einer Aggregation (die Wurzel des Baums) wird
mit einer Regel erzeugt. Dabei kann eine Regel mehrere Aggregationen
erzeugen.
:::
::::::::

::::::::::: sect2
### []{#_ein_beispiel .hidden-anchor .sr-only}2.2. Ein Beispiel {#heading__ein_beispiel}

::: paragraph
Am einfachsten geht alles mit einem konkreten Beispiel. Dafür haben wir
uns für diesen Artikel die *„Mystery Application"* ausgedacht. Nehmen
Sie an, dass dies eine wichtige Anwendung in einem nicht näher genannten
Unternehmen ist. Dabei spielen unter anderem fünf Server und zwei
Netzwerk-Switches eine wichtige Rolle. Damit Sie das Beispiel besser
nachvollziehen können, bekommen diese einfache Namen wie `srv-mys-1`
oder `switch-1`. Folgendes Schaubild gibt den Aufbau grob wieder:
:::

:::: imageblock
::: content
![bi example](../images/bi_example.jpeg){width="90%"}
:::
::::

::: ulist
- Die beiden Server `srv-mys-1` und `srv-mys-2` bilden einen redundanten
  Cluster, auf welchem die eigentliche Anwendung läuft.

- `srv-db` ist ein Datenbankserver, welcher die Daten der Anwendung
  speichert.

- `switch-1` und `switch-2` sind zwei redundante Router, welche das
  Servernetz mit einem höheren Netz verbinden.

- In jenem befindet sich ein Zeitgeber `srv-ntp`, welcher für eine exakt
  synchrone Zeit sorgt.

- Außerdem arbeitet dort der Server `srv-spool`, welcher die von der
  Mystery Application berechneten Resultate in ein Spool-Verzeichnis
  befördert.

- Von dort werden die Daten von einem mysteriösen übergeordneten Dienst
  abgeholt.
:::

::: paragraph
Wenn Sie die nachfolgenden Schritte eins zu eins durchspielen möchten,
können Sie die aufgeführten Monitoring-Objekte kurz nachbauen. Zum
Testen genügt es dabei, wenn Sie einen vorhandenen Host mehrfach klonen
und die Klone entsprechend benennen. Später kommen noch einige wenige
Services ins Spiel, die Sie dann bei Zeit für die betroffenen Hosts ins
Monitoring aufnehmen können. Auch da können Sie wieder schummeln: Mit
simplen [Dummy-Local-Checks](localchecks.html) bekommen Sie schnell
passende Services zum Spielen.
:::

::: paragraph
Die Hosts im Monitoring sehen in etwa so aus:
:::

:::: imageblock
::: content
![bi 2 example 2](../images/bi_2_example_2.png)
:::
::::
:::::::::::

:::::::::::::::::::::::::::::::::: sect2
### []{#_ihre_erste_bi_regel .hidden-anchor .sr-only}2.3. Ihre erste BI-Regel {#heading__ihre_erste_bi_regel}

::: paragraph
Beginnen Sie mit etwas Einfachem --- quasi der einfachst möglichen
sinnvollen Aggregation überhaupt: einer Aggregation mit nur zwei Knoten.
Dabei möchten Sie den Zustand bei beiden Hosts `switch-1` und `switch-2`
zusammenfassen. Die Aggregation soll *Netzwerk* heißen und [OK]{.state0}
sein, wenn beide Switche erreichbar sind. Bei einem Teilausfall soll sie
auf [WARN]{.state1} gehen und wenn beide Switche weg sind auf
[CRIT]{.state2}.
:::

:::: {.imageblock .inline-image}
::: content
![bi aggregation icon](../images/bi_aggregation_icon.png){width="80"}
:::
::::

::: paragraph
Legen Sie los: Das BI-Modul erreichen Sie über [Setup \> Business
Intelligence \> Business Intelligence.]{.guihint} Die Konfiguration der
Regeln und Aggregate geschieht innerhalb von Konfigurationspaketen: den
*BI Packs*. Die Pakete sind nicht nur deswegen praktisch, weil Sie
komplexere Konfigurationen damit besser verwalten können. Sie können
auch für ein Paket Berechtigungen für bestimmte Kontaktgruppen vergeben
und somit Benutzern ohne Administratorrechte das Editieren von Teilen
der Konfiguration erlauben. Doch dazu später mehr ...​
:::

::: paragraph
Wenn Sie das BI-Modul zum ersten Mal aufrufen, sieht das etwa so aus:
:::

:::: imageblock
::: content
![bi 2 default](../images/bi_2_default.png)
:::
::::

::: paragraph
Dort ist bereits ein Paket mit dem Titel [Default Pack]{.guihint}
vorhanden. Es enthält eine Demo für eine Aggregation, die Daten eines
einzelnen Hosts zusammenfasst.
:::

::: paragraph
Für das aktuelle Beispiel legen Sie am besten ein neues Paket an (Knopf
[Add BI pack]{.guihint}), welches Sie *Mystery* nennen. Wie immer in
Checkmk, vergeben Sie eine interne ID (`mystery`), welche sich später
nicht ändern lässt, und einen beschreibenden Titel. Die Option
[Public]{.guihint} brauchen andere Benutzer, wenn sie Regeln in diesem
Paket für ihre eigenen Regeln oder Aggregationen verwenden möchten. Da
Sie Ihre Experimente vermutlich erst mal in Ruhe alleine durchführen
wollen, lassen Sie das deaktiviert:
:::

:::: imageblock
::: content
![bi 2 create pack](../images/bi_2_create_pack.png)
:::
::::

::: paragraph
Nach dem Anlegen finden Sie in der Hauptliste jetzt natürlich zwei
Pakete:
:::

:::: imageblock
::: content
![bi 2 two rulepacks](../images/bi_2_two_rulepacks.png)
:::
::::

::: paragraph
Vor jedem Eintrag steht ein Symbol zum Editieren der Eigenschaften
([![icon edit](../images/icons/icon_edit.png)]{.image-inline}) und
eines, um zum eigentlichen *Inhalt* des Pakets zu kommen ([![icon
rules](../images/icons/icon_rules.png)]{.image-inline}), wo Sie jetzt
auch hin wollen. Dort angelangt, legen Sie gleich Ihre erste Regel über
[Add rule]{.guihint} an.
:::

::: paragraph
Wie immer in Checkmk, will auch diese Regel eine eindeutige ID und einen
Titel haben. Der Titel der Regel hat hier allerdings nicht nur
Dokumentationscharakter, sondern wird später auch als Name desjenigen
Knotens sichtbar, den diese Regel erzeugt:
:::

:::: imageblock
::: content
![bi 2 create rule 2](../images/bi_2_create_rule_2.png)
:::
::::

::: paragraph
Der darunter folgende Kasten hat den Namen [Child Node
Generation]{.guihint} und ist der wichtigste. Hier legen Sie fest,
welche Objekte in diesem Knoten zusammengefasst werden sollen. Das
können entweder andere BI-Knoten sein; dazu würden Sie eine andere
BI-Regel auswählen. Oder es sind Monitoring-Objekte --- also Hosts oder
Services.
:::

::: paragraph
Für das erste Beispiel wählen Sie die zweite Variante ([State of a
host]{.guihint}) und legen zwei Objekte als Kinder an, nämlich die
beiden Hosts `switch-1` und `switch-2`. Das geschieht jeweils mit dem
Knopf [Add child node generator]{.guihint}. Hier wählen Sie dann
logischerweise [State of a host]{.guihint} und tragen jeweils den Namen
des Hosts ein:
:::

:::: imageblock
::: content
![bi 2 create rule 3](../images/bi_2_create_rule_3.png)
:::
::::

::: {#aggregationfunction .paragraph}
Im dritten und letzten Kasten, [Aggregation Function]{.guihint}, geben
Sie an, wie der Monitoring-Zustand des Knotens berechnet werden soll.
Grundlage dafür ist immer die Liste der Zustände der Unterknoten.
Verschiedene logische Verknüpfungen sind möglich.
:::

::: paragraph
Vorausgewählt ist [Best --- take best of all node states.]{.guihint} Das
würde bedeuten, dass der Knoten erst dann [CRIT]{.state2} wird, wenn
auch alle Unterknoten [CRIT]{.state2} bzw. [DOWN]{.hstate1} sind. Wie
oben erwähnt, soll das hier aber nicht der Fall sein. Wählen Sie
stattdessen [Count the number of nodes in state OK]{.guihint}, um die
Anzahl der Unterknoten im Zustand [OK]{.state0} als Maßstab
heranzuziehen. Hier werden als Schwellwerte die beiden Zahlen 2 und 1
vorgeschlagen. Das ist prima, denn es ist genau das was Sie brauchen:
:::

::: ulist
- Wenn beide Switche [UP]{.hstate0} sind (das wird hier als
  [OK]{.state0} gewertet), soll der Knoten [OK]{.state0} werden.

- Wenn nur ein Switch [UP]{.hstate0} ist, wird er [WARN]{.state1}.

- Und wenn beide [DOWN]{.hstate1} sind, wird er [CRIT]{.state2}.
:::

::: paragraph
Und so sieht die Maske ausgefüllt aus:
:::

:::: imageblock
::: content
![bi 2 create rule 5](../images/bi_2_create_rule_5.png)
:::
::::

::: paragraph
Ein Klick auf [Create]{.guihint}, und schon haben Sie Ihre erste Regel:
:::

:::: imageblock
::: content
![bi 2 create rule 6](../images/bi_2_create_rule_6.png)
:::
::::
::::::::::::::::::::::::::::::::::

::::::::: sect2
### []{#_ihre_erste_aggregation .hidden-anchor .sr-only}2.4. Ihre erste Aggregation {#heading__ihre_erste_aggregation}

::: paragraph
Nun ist es wichtig, dass Sie verstehen, dass eine Regel noch keine
Aggregation ist. Checkmk kann ja noch nicht wissen, ob das hier alles
ist oder nur Teil eines größeren Baums! Wirkliche BI-Objekte werden erst
dann erzeugt und in der Statusoberfläche sichtbar, wenn Sie eine
*Aggregation* anlegen. Dazu wechseln Sie in die Liste der [![button
aggregations](../images/icons/button_aggregations.png)]{.image-inline}
Aggregationen.
:::

::: paragraph
Der Knopf [![button add
aggregation](../images/icons/button_add_aggregation.png)]{.image-inline}
bringt Sie zu einer Maske zum Anlegen einer neuen Aggregation. Bei den
[Aggregation groups]{.guihint} können Sie beliebige Namen angeben. Diese
erscheinen dann in der Statusoberfläche als Gruppen, unter denen all
diejenigen Aggregationen sichtbar werden, welche eben diese
Gruppenbezeichnung teilen. Das ist eigentlich das gleiche Konzept wie
bei Hashtags oder Schlagworten. Auch die [Aggregation ID]{.guihint}
können Sie wie gewohnt frei vergeben, später aber nicht mehr ändern.
:::

::: paragraph
Den Inhalt der Aggregation legen Sie über [Add new element]{.guihint}
fest. Wählen Sie hier die Einstellung [Call a rule]{.guihint} und bei
[Rule:]{.guihint} die Regel, die Sie gerade angelegt haben (und davor
das Regelpaket, in dem diese sich befindet).
:::

:::: imageblock
::: content
![bi 2 new aggregation](../images/bi_2_new_aggregation.png)
:::
::::

::: paragraph
Wenn Sie die Aggregation jetzt mit [![icon
save](../images/icons/icon_save.png)]{.image-inline} speichern, sind Sie
fertig! Ihre erste Aggregation sollte jetzt in der Statusoberfläche
auftauchen --- vorausgesetzt, Sie haben auch tatsächlich mindestens
einen der Hosts `switch-1` oder `switch-2` im System!
:::
:::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#statusgui .hidden-anchor .sr-only}3. BI im Operating Teil 1: Die Statusansicht {#heading_statusgui}

::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_alle_aggregate_anzeigen .hidden-anchor .sr-only}3.1. Alle Aggregate anzeigen {#heading__alle_aggregate_anzeigen}

::: paragraph
Wenn Sie alles richtig gemacht haben, können Sie jetzt Ihr erstes
Aggregat über die Statusoberfläche aufrufen. Das geht am einfachsten
über [Monitor \> Business Intelligence \> All Aggregations]{.guihint}:
:::

:::: imageblock
::: content
![bi 3 status gui 1](../images/bi_3_status_gui_1.png)
:::
::::

:::: sect3
#### []{#_ansichten_für_bi_erstellen .hidden-anchor .sr-only}Ansichten für BI erstellen {#heading__ansichten_für_bi_erstellen}

::: paragraph
Neben den vorgefertigten BI-Ansichten können Sie auch individuell
erstellte Ansichten nutzen. Wählen Sie dazu beim [Anlegen einer neuen
Ansicht](views.html#new) eine der BI-Datenquellen. [BI
Aggregations]{.guihint} liefert Informationen über die Aggregate, [BI
Hostname Aggregations]{.guihint} fügt Filter und Informationen für
einzelne Hosts hinzu, [BI Aggregations affected by one host]{.guihint}
zeigt lediglich Aggregate, die sich auf einen einzelnen Host beziehen
und [BI Aggregations for Hosts by Hostgroups]{.guihint} ermöglicht die
Unterscheidung nach Host-Gruppen.
:::
::::
::::::::

::::::::: sect2
### []{#_mit_dem_baum_arbeiten .hidden-anchor .sr-only}3.2. Mit dem Baum arbeiten {#heading__mit_dem_baum_arbeiten}

::: paragraph
Sehen Sie sich die Darstellung des BI-Baums etwas näher an. Folgendes
Beispiel zeigt Ihr Miniaggregat in einer Situation, in der einer der
beiden Switches [DOWN]{.hstate1} ist und der andere [UP]{.hstate0}. Wie
gewollt, geht das Aggregat dabei in den Zustand [WARN]{.state1}:
:::

:::: imageblock
::: content
![bi 3 tree minimal](../images/bi_3_tree_minimal.png)
:::
::::

::: paragraph
Dabei sehen Sie auch, dass zur Vereinheitlichung von Hosts und Services
ein Host, der [DOWN]{.hstate1} ist, quasi wie ein Service gewertet wird,
der [CRIT]{.state2} ist. Aus [UP]{.hstate0} wird entsprechend
[OK]{.state0}.
:::

::: paragraph
Die Blätter des Baums zeigen die Zustände von Hosts und Services. Der
Host-Name --- und bei Services auch der Service-Name --- ist anklickbar
und führt Sie zum aktuellen Zustand des entsprechenden Objekts. Außerdem
sehen Sie die letzte Ausgabe des Check-Plugins.
:::

::: paragraph
Ganz links neben jedem Aggregat finden Sie zwei Symbole: [![icon
showbi](../images/icons/icon_showbi.png)]{.image-inline} und [![button
availability](../images/icons/button_availability.png)]{.image-inline}.
Mit dem ersten Symbol --- [![icon
showbi](../images/icons/icon_showbi.png)]{.image-inline} --- kommen Sie
zu einer Seite, die nur genau dieses eine Aggregat anzeigt. Das ist
natürlich hauptsächlich dann nützlich, wenn Sie mehr als ein Aggregat
angelegt haben. Es eignet sich z.B. gut für ein Lesezeichen. [![button
availability](../images/icons/button_availability.png)]{.image-inline}
bringt Sie zur Berechnung der Verfügbarkeit. Dazu später mehr.
:::
:::::::::

::::::::::: sect2
### []{#_bi_ausprobieren_was_wäre_wenn .hidden-anchor .sr-only}3.3. BI ausprobieren: Was wäre wenn? {#heading__bi_ausprobieren_was_wäre_wenn}

::: paragraph
Links vom Host-Namen finden Sie noch ein interessantes Symbol: [![icon
assume none](../images/icons/icon_assume_none.png)]{.image-inline}. Dies
ermöglicht eine „Was wäre wenn"-Analyse. Die Idee dahinter ist einfach:
Durch einen Klick auf das Symbol schalten Sie das Objekt testweise auf
einen anderen Zustand --- allerdings nur für die BI-Oberfläche, nicht in
echt! Durch mehrfache Klicks gelangen Sie von [![icon assume
0](../images/icons/icon_assume_0.png)]{.image-inline} ([OK]{.state0})
über [![icon assume
1](../images/icons/icon_assume_1.png)]{.image-inline} ([WARN]{.state1}),
[![icon assume 2](../images/icons/icon_assume_2.png)]{.image-inline}
([CRIT]{.state2}) und [![icon assume
3](../images/icons/icon_assume_3.png)]{.image-inline}
([UNKNOWN]{.state3}) wieder zu [![icon assume
none](../images/icons/icon_assume_none.png)]{.image-inline} zurück.
:::

::: paragraph
BI berechnet dann den kompletten Baum anhand des angenommenen Zustands.
Folgende Abbildung zeigt das Minimalaggregat unter der Annahme, dass
neben `switch-1`, der tatsächlich ausgefallen ist, auch `switch-2`
[DOWN]{.hstate1} wäre:
:::

:::: imageblock
::: content
![bi 3 assume example 1](../images/bi_3_assume_example_1.png)
:::
::::

::: paragraph
Der Gesamtzustand des Aggregats geht dadurch von [WARN]{.state1} auf
[CRIT]{.state2}. Dabei wird dessen Farbe mit einem Karomuster
hinterlegt. Dieses Muster zeigt Ihnen an, dass der **tatsächliche**
Zustand eigentlich anders ist. Das ist keineswegs immer der Fall, denn
manche Änderungen bei einem Host oder Service sind für den Gesamtzustand
nicht mehr relevant, z. B. weil dieser sowieso schon [CRIT]{.state2} ist
(wie hier im Bild `switch-1`).
:::

::: paragraph
Sie können diese „Was wäre wenn"-Analyse auf verschiedene Arten nutzen,
z. B.:
:::

::: ulist
- Testen, ob das BI-Aggregat so reagiert, wie Sie das wollen.

- Planung der Abschaltung einer Komponente aus Gründen der Wartung.
:::

::: paragraph
Bei letzterem Szenario setzen Sie das zu wartende Gerät bzw. dessen
Services testweise auf [![icon assume
2](../images/icons/icon_assume_2.png)]{.image-inline}. Wenn das
Gesamtaggregat dann [OK]{.state0} bleibt, muss das bedeuten, dass der
Ausfall **aktuell** durch Redundanz kompensiert werden kann.
:::
:::::::::::

:::::::::: sect2
### []{#_bi_ausprobieren_durch_gefakte_zustände .hidden-anchor .sr-only}3.4. BI ausprobieren durch gefakte Zustände {#heading__bi_ausprobieren_durch_gefakte_zustände}

::: paragraph
Es gibt noch eine zweite Möglichkeit, die BI-Aggregate zu testen: Das
direkte Ändern des *tatsächlichen* Zustands von Objekten. Das bietet
sich vor allem in einem Testsystem an.
:::

::: paragraph
Zu diesem Zweck gibt es bei den [Kommandos](commands.html) ein
Host-/Servicekommando mit dem Namen [Fake check results]{.guihint}. Es
ist per Default nur in der Rolle Administrator verfügbar. Diese Methode
wurde z. B. bei der Erstellung der Screenshots für diesen Artikel
genutzt, um `switch-1` auf [DOWN]{.hstate1} zu setzen. Daher kommt der
verräterische Text [Manually set to Down by cmkadmin]{.guihint}.
:::

:::: imageblock
::: content
![bi 3 fake check results](../images/bi_3_fake_check_results.png)
:::
::::

:::: {.imageblock .inline-image}
::: content
![bi 3 master control checks
off](../images/bi_3_master_control_checks_off.png){width="280"}
:::
::::

::: paragraph
Hier noch ein kleiner Tipp: Wenn Sie mit dieser Methode arbeiten,
schalten Sie am besten die aktiven Checks für die betroffenen Hosts und
Services aus, denn sonst gehen diese beim nächsten Check-Intervall
sofort wieder auf den eigentlichen Zustand zurück. Wenn Sie faul sind,
machen Sie das einfach global über das Seitenleistenelement [Master
Control.]{.guihint} Vergessen Sie nie, das später wieder zu aktivieren!
:::
::::::::::

::::::: sect2
### []{#_bi_gruppen .hidden-anchor .sr-only}3.5. BI-Gruppen {#heading__bi_gruppen}

::: paragraph
Beim Anlegen des Aggregats haben wir die Eingabemöglichkeit der
[Aggregation Groups]{.guihint} kurz angesprochen. Im Beispiel hatten Sie
das vorgeschlagene [Main]{.guihint} hier einfach bestätigt. Sie sind
aber bei der Vergabe der Namen völlig frei und können ein Aggregat auch
mehreren Gruppen zuweisen.
:::

::: paragraph
Gruppen werden dann wichtig, wenn die Anzahl der Aggregate das
übersteigt, was Sie vielleicht auf einem Bildschirm sehen möchten. Sie
gelangen zu einer Gruppe, indem Sie bei der Seite [All
Aggregations]{.guihint} auf die angezeigten Namen der Gruppen
klicken --- also in unserem obigen Beispiel einfach auf die Überschrift
[Main]{.guihint}. Wenn Sie bisher nur dieses eine Aggregat haben, ändert
sich natürlich nicht viel. Nur wenn man genau hinsieht merkt man:
:::

::: ulist
- Der Titel der Seite heißt jetzt [Aggregation group Main]{.guihint}.

- Die Gruppenüberschrift [Main]{.guihint} ist verschwunden.
:::

::: paragraph
Wenn Sie diese Ansicht öfter besuchen wollen, legen Sie doch einfach ein
Lesezeichen davon an --- am besten mit dem [Bookmarks]{.guihint}-Element
in der Seitenleiste.
:::
:::::::

::::::: sect2
### []{#_vom_hostservice_zum_aggregat .hidden-anchor .sr-only}3.6. Vom Host/Service zum Aggregat {#heading__vom_hostservice_zum_aggregat}

::: paragraph
Sobald Sie BI-Aggregate eingerichtet haben, werden Sie bei Ihren Hosts
und Services im Kontextmenü ein neues [![icon
aggr](../images/icons/icon_aggr.png)]{.image-inline} Symbol finden:
:::

:::: imageblock
::: content
![bi 3 service popup](../images/bi_3_service_popup.png)
:::
::::

::: paragraph
Mit diesem Symbol gelangen Sie zur Liste aller Aggregationen, in denen
der betroffene Host oder Service enthalten ist.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::: sect1
## []{#multilevel .hidden-anchor .sr-only}4. Konfiguration Teil 2: Mehrstufige Bäume {#heading_multilevel}

:::::::::::::::::::::::::: sectionbody
::: paragraph
Nach diesem ersten kurzen Eindruck der BI-Statusoberfläche geht es
zurück zur Konfiguration. Denn mit solch einem Miniaggregat können Sie
natürlich noch niemanden wirklich beeindrucken.
:::

::: paragraph
Es beginnt damit, dass Sie den Baum um eine Ebene erweitern --- also von
zwei Ebenen (Wurzel und Blätter) auf drei Ebenen (Wurzel, Zwischenebene,
Blätter) gehen. Dazu kombinieren Sie Ihren vorhandenen Knoten „Switches
1 & 2" mit dem Zustand der NTP-Zeitsynchronisation zu einem Oberknoten
„Infrastructure".
:::

::: paragraph
Aber der Reihe nach --- und zunächst das Ergebnis vorweg:
:::

:::: imageblock
::: content
![bi 4 rule infra 4](../images/bi_4_rule_infra_4.png)
:::
::::

::: paragraph
Voraussetzung ist, dass es einen Host `srv-ntp` gibt, der einen Service
mit dem Namen `NTP Time` hat:
:::

:::: imageblock
::: content
![bi 4 service ntp](../images/bi_4_service_ntp.png)
:::
::::

::: paragraph
Legen Sie erst einmal eine BI-Regel an, welche als Unterknoten 1 die
Regel „Switches 1 & 2" bekommt und als Unterknoten 2 direkt den Service
`NTP Time` des Hosts `srv-ntp`. Im Kopf der Regel wählen Sie
`infrastructure` als Regel-ID und [Infrastructure]{.guihint} als Namen.
Weitere Angaben können Sie sich erst einmal sparen:
:::

:::: imageblock
::: content
![bi 4 rule infra 1](../images/bi_4_rule_infra_1.png)
:::
::::

::: paragraph
Unter [Child Node Generation]{.guihint} wird es interessant. Der erste
Eintrag ist jetzt vom Typ [Call a rule]{.guihint} und als Regel wählen
Sie Ihre Regel von oben aus. Damit „hängen" Sie diese quasi in den
Unterbaum ein.
:::

::: paragraph
Der zweite Unterknoten ist vom Typ [State of a service]{.guihint}, und
hier wählen Sie Ihren NTP-Host per Namen (beachten Sie hier die exakte
Schreibung, inklusive der Groß-/Kleinbuchstaben) sowie den
`NTP Time`-Service per Regex:
:::

:::: imageblock
::: content
![bi 4 rule infra 2](../images/bi_4_rule_infra_2.png)
:::
::::

::: paragraph
Die [Aggregation Function]{.guihint} im dritten Kasten setzen Sie dieses
Mal auf [Worst - take worst state of all nodes.]{.guihint}
:::

::: paragraph
Der Zustand des Knotens leitet sich bei dieser Funktion also vom
schlechtesten Zustand eines Services darunter ab. Heißt hier: Geht
`NTP Time` auf [CRIT]{.state2}, geht auch der Knoten auf
[CRIT]{.state2}.
:::

::: paragraph
Damit der neue größere Baum sichtbar wird, müssen Sie natürlich wieder
eine Aggregation anlegen. Am besten verändern Sie einfach die bestehende
Aggregation, so dass fortan die neue Regel verwendet wird:
:::

:::: imageblock
::: content
![bi 4 rule infra 3](../images/bi_4_rule_infra_3.png)
:::
::::

::: paragraph
Auf diese Art bleiben Sie bei *einer* Aggregation. Und die sieht dann so
aus (dieses mal sind beide Switches wieder auf [OK]{.state0}):
:::

:::: imageblock
::: content
![bi 4 rule infra 4](../images/bi_4_rule_infra_4.png)
:::
::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#displayoptions .hidden-anchor .sr-only}5. BI im Operating Teil 2: Alternative Darstellungen {#heading_displayoptions}

::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::::::: sect2
### []{#_einleitung_2 .hidden-anchor .sr-only}5.1. Einleitung {#heading__einleitung_2}

::: paragraph
Jetzt da Sie einen etwas interessanteren Baum haben, können Sie sich
etwas genauer mit den verschiedenen Darstellungsmöglichkeiten befassen,
die Checkmk bietet. Ausgangspunkt dafür ist die Funktion [Modify display
options]{.guihint}, welche Sie im Menü [Display]{.guihint} finden. Diese
öffnet einen Kasten mit Optionen. Der Inhalt des Kastens ist immer
angepasst auf die Elemente, die auf der Seite dargestellt werden. Im
Falle von BI finden Sie aktuell sechs Optionen:
:::

:::: imageblock
::: content
![bi 5 display options
screen](../images/bi_5_display_options_screen.png)
:::
::::

:::: sect3
#### []{#_bäume_sofort_auf_oder_zuklappen .hidden-anchor .sr-only}Bäume sofort auf- oder zuklappen {#heading__bäume_sofort_auf_oder_zuklappen}

::: paragraph
Wenn Sie nicht nur ein Aggregat, sondern sehr viele anzeigen, dann ist
die Einstellung **Initial expansion of aggregations** hilfreich. Hier
legen Sie fest, wie weit die Bäume beim ersten Anzeigen aufgeklappt sein
sollen. Die Auswahl reicht von geschlossen ([collapsed]{.guihint}) über
die ersten drei Ebenen bis hin zu komplett geöffnet
([complete]{.guihint}).
:::
::::

:::::: sect3
#### []{#_nur_probleme_zeigen .hidden-anchor .sr-only}Nur Probleme zeigen {#heading__nur_probleme_zeigen}

::: paragraph
Wenn Sie die Option **Show only problems** aktivieren, werden in den
Bäumen nur noch solche Zweige angezeigt, die nicht den Zustand
[OK]{.state0} haben. Das sieht dann z.B. so aus:
:::

:::: imageblock
::: content
![bi 5 only problems](../images/bi_5_only_problems.png)
:::
::::
::::::

::::::::: sect3
#### []{#_art_der_baumdarstellung .hidden-anchor .sr-only}Art der Baumdarstellung {#heading__art_der_baumdarstellung}

::: paragraph
Unter dem Punkt **Type of tree layout** finden Sie etliche alternative
Darstellungsarten für den Baum. Eine davon heißt [Table: top
down]{.guihint} und sieht so aus:
:::

:::: imageblock
::: content
![bi 5 top down](../images/bi_5_top_down.png)
:::
::::

::: paragraph
Extrem platzsparend --- vor allem, wenn Sie viele Aggregate gleichzeitig
sehen möchten --- ist die Darstellung [Boxes.]{.guihint} Hier ist jeder
Knoten ein farbiger Kasten, der per Klick aufgeklappt wird. Die
Baumstruktur ist nicht mehr sichtbar, aber Sie können sich so bei
minimalem Platzbedarf schnell zu einem Problem durchklicken. Hier im
Beispiel sind die Boxen komplett aufgeklappt:
:::

:::: imageblock
::: content
![bi 5 boxes](../images/bi_5_boxes.png)
:::
::::
:::::::::
:::::::::::::::::::

:::: sect2
### []{#_weitere_optionen .hidden-anchor .sr-only}5.2. Weitere Optionen {#heading__weitere_optionen}

::: paragraph
Letztlich können Sie ein [Refresh interval]{.guihint} von 30, 60 oder 90
Sekunden setzen und die Anzahl der Spalten über [Entries per
row]{.guihint} bestimmen.
:::
::::

::::::::::::::::::::::::::::::::::: sect2
### []{#visualization .hidden-anchor .sr-only}5.3. Visualisierung von BI-Aggregaten {#heading_visualization}

::: paragraph
Checkmk beherrscht neben tabellarischen Darstellungen auch die
Visualisierung von BI-Aggregaten. So können Sie Aggregate aus neuer
Perspektive und bisweilen übersichtlicher darstellen. Sie finden die [BI
visualization]{.guihint} über [![icon
aggr](../images/icons/icon_aggr.png)]{.image-inline} in der regulären
Aggregatsansicht.
:::

:::: imageblock
::: content
![bi 5 visualization start](../images/bi_5_visualization_start.png)
:::
::::

::: paragraph
Sie können den Baum frei per Klick auf den Hintergrund bewegen und die
gesamte Darstellung per Mausrad skalieren. Sobald der Mauszeiger über
den einzelnen Knoten landet, bekommen Sie die zugehörigen
Zustandsinformationen via Hover-Fenster. Per Mausrad skalieren Sie nun
die Länge der Zweige des Baums.
:::

:::: imageblock
::: content
![bi 5 visualization
standard](../images/bi_5_visualization_standard.png)
:::
::::

::: paragraph
Per Klick auf die Blatt-Knoten gelangen Sie direkt zu den
Detailansichten der Hosts oder Services. Per Rechtsklick auf die
sonstigen Knoten erhalten Sie, je nach Art des Knotens, Zugriff auf
Darstellungsoptionen und beispielsweise die verantwortliche Regel
selbst; im Bild über [Edit rule]{.guihint}.
:::

:::: imageblock
::: content
![bi 5 visualization context](../images/bi_5_visualization_context.png)
:::
::::

::::::::::::::::: sect3
#### []{#_visualisierung_anpassen .hidden-anchor .sr-only}Visualisierung anpassen {#heading__visualisierung_anpassen}

::: paragraph
Wirklich interessant wird es aber erst mit dem [Layout
Designer]{.guihint}, den Sie über [![icon
aggr](../images/icons/icon_aggr.png)]{.image-inline} oben neben dem
Suchfeld öffnen. Zunächst sehen Sie zwei neue Elemente: Den Kasten
[Layout Configuration]{.guihint} und zwei neue Icons an der Wurzel,
[![icon bi visualization
rotate](../images/icons/icon_bi_visualization_rotate.png)]{.image-inline}
und [![icon bi visualization
resize](../images/icons/icon_bi_visualization_resize.png)]{.image-inline}.
:::

::: paragraph
In der Konfiguration haben Sie die Wahl zwischen unterschiedlichen
Linienarten und können die [Node icons]{.guihint} aktivieren. Damit
werden die Icons angezeigt, die Sie in den Regeln von BI-Aggregaten im
Bereich [Aggregation Function](#aggregationfunction) festlegen dürfen
(direkt zu erreichen über das Kontextmenü des Knotens). Über die Icons
[![icon bi visualization
rotate](../images/icons/icon_bi_visualization_rotate.png)]{.image-inline}
und [![icon bi visualization
resize](../images/icons/icon_bi_visualization_resize.png)]{.image-inline}
lässt sich der Baum durch Ziehen mit der Maus drehen beziehungsweise in
Länge und Breite skalieren --- einmal angeklickt, erscheint zudem der
Kasten [Style configuration]{.guihint} mit weiteren
Darstellungsoptionen. Welche am besten passt, finden Sie durch
schlichtes Ausprobieren heraus.
:::

:::: imageblock
::: content
![bi 5 visualization
designer2](../images/bi_5_visualization_designer2.png)
:::
::::

::: paragraph
Die größten Anpassungen ermöglichen Ihnen jedoch die Kontextmenüs der
Knoten, die im Designer-Modus vier verschiedene Darstellungen für die
Hierarchie ab diesem Knoten bieten:
:::

::: {.olist .arabic}
1.  [Hierarchical style]{.guihint}: Standardeinstellung mit einfacher
    Hierarchie.

2.  [Radial style]{.guihint}: Kreisförmige Anordnung mit einstellbarem
    Kreisausschnitt.

3.  [Leaf-Nodes Block style]{.guihint}: Blatt-Knoten werden grau
    unterlegt als Gruppe dargestellt.

4.  [Free-Floating style]{.guihint}: Dynamisches Layout mit Optionen wie
    Anziehung, Abständen, Länge der Äste.
:::

:::: imageblock
::: content
![bi 5 visualization styles](../images/bi_5_visualization_styles.png)
:::
::::

::: paragraph
Knoten, denen ein Stil zugeordnet wurde, lassen sich frei platzieren. Je
nach Stil unterscheiden sich auch die Optionen, beim [Radial
style]{.guihint} sehen Sie am Wurzelknoten etwa ein drittes Icon [![icon
bi visualization
pie](../images/icons/icon_bi_visualization_pie.png)]{.image-inline},
über das Sie die Darstellung auf einen Kreisausschnitt beschränken
können.
:::

::: paragraph
Über die Option [Detach from parent style]{.guihint} können Sie Knoten
vom Stil des übergeordneten Knotens lösen, um diese anders zu
konfigurieren und frei zu platzieren. In die gleiche Richtung zielt auch
[Include parent rotation]{.guihint}, womit Sie übergeordnete Knoten beim
Drehen ein- und ausschließen dürfen.
:::

::: paragraph
Im Grunde sind alle Stile selbsterklärend, lediglich der [Free-Floating
style]{.guihint} bedarf einiger Erklärungen. Hierbei handelt es sich um
ein System aus Anziehung und Abstoßung, wie Sie es von
Gravitationssimulationen kennen.
:::

+------------------------+---------------------------------------------+
| [Center force          | Anziehungskraft der Mitte auf die Knoten.   |
| strength]{.guihint}    |                                             |
+------------------------+---------------------------------------------+
| [Repulsion force       | Kraft des Abstoßungseffekts von Blättern    |
| leaf]{.guihint}        | auf andere Knoten.                          |
+------------------------+---------------------------------------------+
| [Repulsion force       | Kraft der Abstoßung von Knoten auf andere   |
| branches]{.guihint}    | Knoten im selben Zweig.                     |
+------------------------+---------------------------------------------+
| [Link distance         | Idealer Abstand vom Blattknoten zum         |
| leaf]{.guihint}        | vorherigen Knoten.                          |
+------------------------+---------------------------------------------+
| [Link distance         | Idealer Abstand vom Zweigknoten zum         |
| branches]{.guihint}    | vorherigen Knoten.                          |
+------------------------+---------------------------------------------+
| [Link                  | Stärke, mit der der ideale Abstand          |
| strength]{.guihint}    | erzwungen wird.                             |
+------------------------+---------------------------------------------+
| [Collision box         | Größe des Blattknotenbereichs, der andere   |
| leaf]{.guihint}        | Knoten abstößt.                             |
+------------------------+---------------------------------------------+
| [Collision box         | Größe des Zweigknotenbereichs, der andere   |
| branch]{.guihint}      | Knoten abstößt.                             |
+------------------------+---------------------------------------------+

::: paragraph
Das folgende Bild zeigt einen Zweig im [Free-Floating
style]{.guihint} --- die Positionen der einzelnen Blätter ergeben sich
dynamisch gemäß der gesetzten Optionen.
:::

:::: imageblock
::: content
![bi 5 visualization float](../images/bi_5_visualization_float.png)
:::
::::
:::::::::::::::::

:::::: sect3
#### []{#_bi_regeln_layout_stil_vorgeben .hidden-anchor .sr-only}BI-Regeln Layout-Stil vorgeben {#heading__bi_regeln_layout_stil_vorgeben}

::: paragraph
Sie können BI-Regeln, die Sie über das Kontextmenü der Knoten erreichen,
im Bereich [Rule Properties]{.guihint} die Layouts
[Hierarchical]{.guihint}, [Radial]{.guihint} oder [Leaf-Nodes
Block]{.guihint} zuordnen sowie zugehörige Optionen festlegen.
:::

:::: imageblock
::: content
![bi 5 visualization rule](../images/bi_5_visualization_rule.png)
:::
::::
::::::

:::::: sect3
#### []{#_suchfunktion .hidden-anchor .sr-only}Suchfunktion {#heading__suchfunktion}

::: paragraph
In größeren Bäumen ist die Suchfunktion eine enorme Hilfe. Im Suchfeld
[Search node]{.guihint} können Sie einfach einen Namensteil des
gewünschten Knotens eingeben und bekommen direkt live eine Liste mit
Treffern. Wenn Sie nun mit der Maus über diese Vorschlagsliste fahren,
wird der Node unter dem Mauszeiger im Baum durch einen blauen Rand
hervorgehoben --- das erleichtert eine erste Orientierung. Klicken Sie
auf einen Node in der Liste, wird der Baum auf diesen zentriert. So
lässt sich auch in Visualisierungen mit Hunderten Nodes schnell der
passende Bereich Ihrer Infrastruktur finden.
:::

:::: imageblock
::: content
![bi 5 visualization search](../images/bi_5_visualization_search.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#config3 .hidden-anchor .sr-only}6. Konfiguration Teil 3: Variablen, Schablonen, Suche {#heading_config3}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_konfiguration_mit_mehr_intelligenz .hidden-anchor .sr-only}6.1. Konfiguration mit mehr Intelligenz {#heading__konfiguration_mit_mehr_intelligenz}

::: paragraph
Weiter geht's mit der Konfiguration. Und jetzt wird es Zeit, dass es
wirklich zur Sache geht. Bisher war das Beispiel nämlich so einfach,
dass es ohne Schwierigkeit möglich war, die Objekte in der Aggregation
alle einzeln aufzulisten. Aber was, wenn die Dinge komplexer werden?
Wenn Sie viele immer wiederkehrende gleiche oder ähnliche Abhängigkeiten
formulieren wollen? Wenn es von einer Anwendung nicht nur eine, sondern
mehrere Instanzen gibt? Oder wenn Sie mal eben hundert Einzelservices
einer Datenbank zu einem BI-Knoten zusammenfassen wollen?
:::

::: paragraph
Nun, dann brauchen Sie mächtigere Methoden der Konfiguration. Und die
sind genau das, was Checkmk BI gegenüber anderen Tools
auszeichnet --- und leider auch die Lernkurve etwas steiler gestaltet.
Es ist auch der Grund, warum Checkmk BI sich nicht per „Drag-and-Drop"
konfigurieren lässt. Aber wenn Sie die Möglichkeiten erst einmal
kennengelernt haben, werden Sie sie sicher nicht mehr missen wollen.
:::
:::::

:::::::::::::::::::::::: sect2
### []{#_parameter .hidden-anchor .sr-only}6.2. Parameter {#heading__parameter}

::: paragraph
Beginnen Sie mit den *Parametern.* Nehmen Sie folgende Situation: Sie
möchten bei den beiden Switches nicht nur feststellen, ob sie
[UP]{.hstate0} sind, sondern auch den Zustand von zwei Ports wissen, die
für den Uplink zuständig sind. Insgesamt geht es um folgende vier
Services:
:::

:::: imageblock
::: content
![bi 6 switch service](../images/bi_6_switch_service.png)
:::
::::

::: paragraph
Nun soll der Knoten [Switch 1 & 2]{.guihint} so erweitert werden, dass
es anstelle der beiden Host-Zustände für Switch 1 und 2 jeweils einen
Unterknoten gibt, der den Host-Zustand **und** die beiden
Uplink-Interfaces zeigt. Diese beiden Unterknoten sollen [Switch
1]{.guihint} bzw. [Switch 2]{.guihint} heißen.
:::

::: paragraph
Eigentlich bräuchten Sie jetzt also zwei neue Regeln --- für jeden
Switch eine. Besser geht das, indem Sie eine neue Regel `switch`
erstellen, diese aber mit einem *Parameter* ausstatten. Dieser Parameter
ist eine Variable, die man beim Aufruf der Regel aus dem übergeordneten
Knoten, hier die alte Regel `Switch 1 & 2`, mitgeben kann. Im Beispiel
können Sie einfach entweder `1` oder `2` übergeben. Der Parameter
bekommt einen Namen, den Sie frei wählen können. Nehmen Sie hier z. B.
den Namen `NUMBER`. Die Schreibweise mit Großbuchstaben ist rein
willkürlich. Wenn Sie Kleinbuchstaben schöner finden, können Sie gerne
auch diese verwenden.
:::

::: paragraph
Und so sieht der Kopf der Regel aus:
:::

:::: imageblock
::: content
![bi 6 rule with parameter](../images/bi_6_rule_with_parameter.png)
:::
::::

::: paragraph
Als ID für die neue Regel können Sie hier `switch` wählen. Bei
[Parameter]{.guihint} tragen Sie einfach den Namen der Variablen ein:
`NUMBER`. Wichtig ist jetzt, dass auch im [Rule Title]{.guihint} der
Regel die Variable eingesetzt wird, damit nicht beide Knoten einfach nur
`Switch` heißen und so den gleichen Namen hätten. Beim **Verwenden** der
Variable wird (wie an vielen Stellen in Checkmk üblich) vorne und hinten
ein Dollarzeichen gesetzt. Als Ergebnis werden die beiden Knoten dann
`Switch 1` und `Switch 2` heißen.
:::

:::::::::::::: sect3
#### []{#_präfix_match_ist_für_service_namen_default .hidden-anchor .sr-only}Präfix-Match ist für Service-Namen Default {#heading__präfix_match_ist_für_service_namen_default}

::: paragraph
Unter [Child Node Generation]{.guihint} fügen Sie jetzt als erstes den
Host-Zustand ein. Dabei dürfen Sie beim Host-Namen anstelle der `1` oder
`2` einfach Ihre Variable einsetzen und zwar auch hier wieder mit je
einem `$` hinten und vorne.
:::

::: paragraph
Das Gleiche machen Sie bei dem Host-Namen der Uplink-Interfaces. Und
hier kommt gleich noch der zweite Trick. Denn wie Sie vielleicht an der
kleinen Serviceliste oben bemerkt haben, heißen die Services für den
Uplink bei beiden Switches unterschiedlich! Das ist aber kein Problem,
da BI den Service-Namen --- ganz analog zu den bekannten
Service-[Regeln](wato_rules.html) --- immer als Präfix-Match mit
regulären Ausdrücken interpretiert. Schreiben Sie also einfach
`Interface Uplink`, erwischen Sie so alle Services *auf dem jeweiligen
Host,* die mit `Interface Uplink` **beginnen:**
:::

:::: imageblock
::: content
![bi 6 rule with parameter 2](../images/bi_6_rule_with_parameter_2.png)
:::
::::

::: paragraph
Übrigens: Durch das Anhängen von `$` können Sie das Präfix-Verhalten
abschalten. Ein `$` bedeutet bei regulären Ausdrücken --- im Kontext der
Checkmk-Regeln --- soviel wie „Der Text muss hier enden". Also greift
`Interface 1$` auch nur auf `Interface 1` und nicht z.B. auch auf
`Interface 10`.
:::

::: paragraph
Bauen Sie jetzt noch die alte Regel [Switch 1 & 2]{.guihint} so um, dass
diese anstelle der Host-Zustände die neue Regel für jeden der beiden
Switche je einmal aufruft. Und hier ist jetzt auch die Stelle, an der
Sie die Werte `1` und `2` als Parameter für die Variable `NUMBER`
übergeben:
:::

:::: imageblock
::: content
![bi 6 rule with parameter 3](../images/bi_6_rule_with_parameter_3.png)
:::
::::

::: paragraph
Und voila: Schon haben Sie einen hübschen Baum mit drei Ebenen:
:::

:::: imageblock
::: content
![bi 6 rule with parameter 4](../images/bi_6_rule_with_parameter_4.png)
:::
::::
::::::::::::::
::::::::::::::::::::::::

:::::::::: sect2
### []{#_reguläre_ausdrücke_fehlende_objekte .hidden-anchor .sr-only}6.3. Reguläre Ausdrücke, fehlende Objekte {#heading__reguläre_ausdrücke_fehlende_objekte}

::: paragraph
Die Sache mit den [regulären Ausdrücken](regexes.html) ist nochmal einen
genaueren Blick wert. Beim Matching der Service-Namen haben wir nämlich
am Anfang stillschweigend unterschlagen, dass es sich eben grundsätzlich
um reguläre Ausdrücke handelt. Wie gerade erwähnt, findet dabei ein
Präfix-Match statt.
:::

::: paragraph
Wenn Sie also in einem BI-Knoten beim Service-Namen z. B. `Disk`
angeben, werden alle Services des betreffenden Hosts eingefangen, die
mit `Disk` *beginnen*.
:::

::: paragraph
Dabei gelten generell folgende Prinzipien:
:::

::: {.olist .arabic}
1.  Wenn sich ein Knoten auf Objekte bezieht, die es (aktuell) nicht
    gibt, dann werden diese einfach weggelassen.

2.  Wenn ein Knoten dadurch leer wird, wird er selbst weggelassen.

3.  Ist auch der Wurzelknoten eines Aggregats leer, wird das Aggregat
    selbst weggelassen.
:::

::: paragraph
Vielleicht klingt das für Sie erst einmal etwas verwegen. Ist es nicht
gefährlich, einfach Dinge, die da sein sollten, stillschweigend
wegzulassen, wenn sie fehlen?
:::

::: paragraph
Nun --- mit der Zeit werden Sie feststellen, wie praktisch dieses
Konzept ist. Denn dadurch können Sie „intelligente" Regeln schreiben,
die auf sehr unterschiedliche Situationen reagieren können. Gibt es
einen Service, der nicht bei jeder Instanz einer Anwendung vorhanden
ist? Kein Problem --- er wird einfach nur dann berücksichtigt, wenn er
auch da ist. Oder werden Hosts oder Services vorübergehend aus dem
Monitoring genommen? Dann verschwinden diese einfach aus BI, ohne dass
es zu Fehlern oder dergleichen kommt. BI ist **nicht** dafür da, um
festzustellen, ob Ihre Monitoring-Konfiguration vollständig ist!
:::

::: paragraph
Dieses Prinzip gilt übrigens auch bei *explizit* definierten Services.
Denn eigentlich gibt es diese ja nicht, weil die Service-Namen ja immer
als reguläre Ausdrücke gesehen werden, auch wenn sie keine speziellen
Sonderzeichen wie `.*` enthalten. Es handelt sich immer automatisch um
ein Suchmuster.
:::
::::::::::

:::::::::::::::::::::::::::::: sect2
### []{#_knoten_als_ergebnis_einer_suche_anlegen .hidden-anchor .sr-only}6.4. Knoten als Ergebnis einer Suche anlegen {#heading__knoten_als_ergebnis_einer_suche_anlegen}

::: paragraph
Sie können aber noch weiter automatisieren und vor allem flexibel auf
Veränderungen reagieren. Weiter geht es mit dem Beispiel der beiden
Anwendungsserver `srv-mys-1` und `srv-mys-2` aus dem Beispiel. Ihr Baum
soll weiter wachsen. Der Knoten [Infrastructure]{.guihint} soll auf
Ebene 2 rutschen. Und als endgültige Wurzel soll eine Regel mit dem
Titel [The Mystery Application]{.guihint} dienen, unter der alles hängen
wird. Neben [Infrastructure]{.guihint} soll es einen Knoten mit dem
Namen [Mystery Servers]{.guihint} geben. Unter diesem sollen die
(aktuell) zwei Mystery-Server hängen. Von jedem kommen ein paar
exemplarische Services in das Aggregat. Das Ergebnis soll so aussehen:
:::

:::: imageblock
::: content
![bi 6 mystery tree](../images/bi_6_mystery_tree.png)
:::
::::

:::::::::: sect3
#### []{#_unterste_regel_mystery_server_x .hidden-anchor .sr-only}Unterste Regel: Mystery Server X {#heading__unterste_regel_mystery_server_x}

::: paragraph
Fangen Sie von unten an. Denn das ist in BI immer der einfachste Weg.
Unten gibt es die neue Regel [Mystery Server X]{.guihint}. Natürlich
verwenden Sie einen Parameter, damit Sie nicht für jeden Server eine
eigene Regel brauchen. Den Parameter nennen Sie z. B. wieder `NUMBER`.
Er soll dann später als Wert `1` oder `2` haben. Wie bereits oben
geschehen, müssen Sie `NUMBER` abermals im Kopf der Regel bei
[Parameters]{.guihint} eintragen.
:::

::: paragraph
Der folgende Child-Node-Generator sieht dann so aus:
:::

:::: imageblock
::: content
![bi 6 mystery server rule](../images/bi_6_mystery_server_rule.png)
:::
::::

::: paragraph
Hier ist Folgendes bemerkenswert:
:::

::: ulist
- Beim Host-Namen `srv-mys-$NUMBER$` wird die Nummer aus dem Parameter
  eingesetzt.

- Bei [Service Regex:]{.guihint} wird der raffinierte [reguläre
  Ausdruck](regexes.html) `CPU|Memory` eingesetzt, der mit einem
  senkrechten Balken alternative Service-Namen (-Anfänge) zulässt und
  auf alle Services greift, die mit `CPU` oder `Memory` beginnen. Das
  spart eine Verdoppelung der Konfiguration!
:::

::: paragraph
Übrigens: Dieses Beispiel ist natürlich noch nicht unbedingt perfekt.
Zum Beispiel wurde Zustand des Hosts selbst gar nicht aufgenommen. Wenn
also einer der Server [DOWN]{.hstate1} geht, werden die Services auf
diesem veralten ([stale]{.guihint} gehen), aber der Zustand wird
[OK]{.state0} bleiben und das Aggregat von dem Ausfall nichts
„mitbekommen". Wenn Sie so etwas aber wissen möchten, sollten Sie neben
den Services auf jeden Fall auch den Host-Zustand aufnehmen.
:::
::::::::::

:::::::::::::::: sect3
#### []{#_mittlere_regel_mystery_servers .hidden-anchor .sr-only}Mittlere Regel: Mystery Servers {#heading__mittlere_regel_mystery_servers}

::: paragraph
Diese Regel wird interessant. Sie fasst die beiden Mystery-Server zu
einem Knoten zusammen. Nun soll es möglich sein, dass die Anzahl der
Server nicht festgelegt ist und durchaus später auch mal drei oder mehr
sein kann. Oder es könnte gar sein, dass es dutzende Instanzen der
Mystery-Anwendung gibt --- jede mit einer anderen Anzahl von Servern.
:::

::: paragraph
Der Trick liegt im Child-Node-Generator-Typ [Create nodes based on a
host search]{.guihint}. Dieser sucht nach vorhandenen Hosts und erzeugt
Knoten auf Basis der gefundenen Hosts. Er sieht hier so aus:
:::

:::: imageblock
::: content
![bi 6 mystery server rule2](../images/bi_6_mystery_server_rule2.png)
:::
::::

::: paragraph
Das Ganze funktioniert so:
:::

::: {.olist .arabic}
1.  Sie formulieren eine Suchbedingung, um Hosts zu finden.

2.  Für jeden gefundenen Host wird ein Child-Node angelegt.

3.  Dabei können Sie aus den gefundenen Host-Namen Teile herausschneiden
    und als Parameter bereitstellen.
:::

::: paragraph
Den Anfang macht das Finden. Hier stehen Ihnen wie üblich Host-Merkmale
zur Verfügung. Im Beispiel können Sie darauf verzichten und stattdessen
den regulären Ausdruck `srv-mys-(.*)` für den Host-Namen verwenden.
Dieser greift auf alle Hosts, die mit `srv-mys-` beginnen. Das `.*`
steht für eine beliebige Zeichenfolge.
:::

::: paragraph
Wichtig ist hierbei, dass das `.*` *eingeklammert* ist, also `(.*)`.
Durch die Klammerung bildet der Match eine sogenannte *Gruppe*. In
dieser wird genau der Text eingefangen (und gespeichert), auf den das
`.*` greift --- hier also `1` oder `2`. Die Match-Gruppen werden intern
durchnummeriert. Hier gibt es nur eine, welche die Nummer 1 bekommt. Auf
den gematchten Text können Sie später daher mit `$1$` zugreifen.
:::

::: paragraph
Die Suche wird jetzt zwei Hosts finden:
:::

+-----------------------------------+-----------------------------------+
| Host-Name                         | Wert von `$1$`                    |
+===================================+===================================+
| `srv-mys-1`                       | 1                                 |
+-----------------------------------+-----------------------------------+
| `srv-mys-2`                       | 2                                 |
+-----------------------------------+-----------------------------------+

::: paragraph
Für jeden gefundenen Host erzeugen Sie einen Unterknoten mit der
Funktion [Call a rule]{.guihint}. Wählen Sie die Regel
`Mystery Server $NUMBER$` aus, die Sie gerade angelegt haben. Als
Argument für `NUMBER` übergeben Sie die Match-Gruppe: `$1$`.
:::

::: paragraph
Jetzt wird also die Unterregel `Mystery Server $NUMBER$` zweimal
aufgerufen: einmal mit `1` und einmal mit `2`.
:::

::: paragraph
Sollte in Zukunft einmal ein neuer Server mit dem Namen `srv-mys-3` ins
Monitoring aufgenommen werden, so wird dieser **automatisch** im
BI-Aggregat auftauchen. Der Zustand des Hosts ist dabei egal. Auch wenn
der Server [DOWN]{.hstate1} ist, wird er natürlich **nicht** aus dem
Aggregat entfernt!
:::

::: paragraph
Zugegeben, das ist hier eine sehr steile Lernkurve. Diese Methode ist
wirklich komplex. Aber wenn Sie das erst einmal ausprobiert und
verstanden haben, werden Sie auch verstehen, wie mächtig das ganze
Konzept ist. Und bislang wurden die Möglichkeiten gerade erst
angekratzt!
:::
::::::::::::::::

:::: sect3
#### []{#_oberste_regel .hidden-anchor .sr-only}Oberste Regel {#heading__oberste_regel}

::: paragraph
Der neue oberste Knoten [The Mystery Application]{.guihint} ist jetzt
einfach: Dazu ist eine neue Regel notwendig, die zwei Unterknoten der
Art [Call a rule]{.guihint} hat. Diese beiden Regeln sind die bestehende
[Infrastructure]{.guihint} und die gerade neu angelegte Regel mit dem
Namen [Mystery Servers.]{.guihint}
:::
::::
::::::::::::::::::::::::::::::

::::::::: sect2
### []{#_knoten_mit_servicesuche_anlegen .hidden-anchor .sr-only}6.5. Knoten mit Servicesuche anlegen {#heading__knoten_mit_servicesuche_anlegen}

::: paragraph
Analog zu der Host-Suche gibt es auch einen Child-Generator-Typ der
[Create nodes based on a service search]{.guihint} heißt. Hier sehen Sie
ein Beispiel:
:::

:::: imageblock
::: content
![bi 6 service search](../images/bi_6_service_search.png)
:::
::::

::: paragraph
Sie können hier sowohl beim Host als auch beim Service mit `()`
Teilausdrücke einklammern. Hierbei gilt:
:::

::: ulist
- Wählen Sie [Regex for host name]{.guihint}, so *müssen* Sie genau
  einen Klammerausdruck definieren. Der Match-Text wird dann als `$1$`
  bereitgestellt.

- Wählen Sie [All hosts]{.guihint}, so wird der Host-Name komplett als
  `$1$` bereitgestellt.

- Im Service-Namen dürfen Sie mehrere Subgruppen verwenden. Die
  zugehörigen Match-Texte werden als `$2$`, `$3$` usw. bereitgestellt.
:::

::: paragraph
Und vergessen Sie nie, dass Sie mit [![icon
help](../images/icons/icon_help.png)]{.image-inline} stets die
Inline-Hilfe aufrufen können.
:::
:::::::::

:::: sect2
### []{#_alle_übrigen_services .hidden-anchor .sr-only}6.6. Alle übrigen Services {#heading__alle_übrigen_services}

::: paragraph
Vielleicht sind Sie bei Ihren Versuchen über den Child-Node-Generator
[State of remaining services]{.guihint} gestolpert. Dieser erzeugt für
jeden Service eines Hosts, der in Ihrem BI-Aggregat noch nirgends
einsortiert ist, einen Knoten. Dies ist nützlich, wenn Sie BI dazu
verwenden, um den Zustand aller Services eines Hosts übersichtlich zu
gruppieren --- so wie dies im mitgelieferten Beispiel gemacht wird.
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#hostaggr .hidden-anchor .sr-only}7. Die vordefinierte Host-Aggregation {#heading_hostaggr}

:::::::::::::::: sectionbody
::: paragraph
Wie erwähnt, können Sie BI auch dazu verwenden, die Services eines Hosts
strukturiert anzuzeigen. Dabei fassen Sie alle Services zu einem Baum in
einem Aggregat zusammen und verwenden grundsätzlich die Funktion
[worst]{.guihint}. Der Gesamtzustand eines Hosts zeigt dann nur noch, ob
es irgendein Problem bei dem Host gibt. Und Sie nutzen BI als
übersichtliche „Drill Down"-Methode.
:::

::: paragraph
Für diesen Zweck liefert Checkmk bereits einen vordefinierten Satz an
Regeln mit, welchen Sie einfach nur freischalten müssen. Diese Regeln
sind auf die Darstellung von Services auf Windows- oder Linux-Hosts
optimiert, aber Sie können sie natürlich nach Ihren Wünschen anpassen.
Sie finden alle Regeln im Regelpaket [Default]{.guihint}. Wie üblich
gelangen Sie von dort durch einen Klick auf [![icon
rules](../images/icons/icon_rules.png)]{.image-inline} zu den Regeln:
:::

:::: imageblock
::: content
![bi 7 wato start](../images/bi_7_wato_start.png)
:::
::::

::: paragraph
Dort finden Sie eine Liste von zwölf Regeln (hier gekürzt):
:::

:::: imageblock
::: content
![bi 7 host tree rules](../images/bi_7_host_tree_rules.png)
:::
::::

::: paragraph
Die erste Regel ist die Regel für die Wurzel des Baums. Das Symbol
[![icon aggr](../images/icons/icon_aggr.png)]{.image-inline} bei dieser
Regel bringt Sie zu einer Baumdarstellung. Hier können Sie sehen, wie
die Regeln untereinander verschachtelt sind:
:::

:::: imageblock
::: content
![bi 7 host tree tree](../images/bi_7_host_tree_tree.png){width="40%"}
:::
::::

::: paragraph
Zurück in der Liste der Regeln, gelangen Sie mit dem Knopf [![button
aggregations](../images/icons/button_aggregations.png)]{.image-inline}
[Aggregations]{.guihint} zur Liste der Aggregationen in diesem
Regelpaket --- welche nur aus einer einzigen Aggregation besteht.
Entfernen Sie in den [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} Details einfach die
Checkbox bei [Currently disable this aggregation]{.guihint} und sofort
bekommen Sie pro Host eine Aggregation mit dem Titel `Host myhost123`.
Diese sieht dann z. B. so aus:
:::

:::: imageblock
::: content
![bi 7 host aggregation](../images/bi_7_host_aggregation.png)
:::
::::
::::::::::::::::
:::::::::::::::::

::::::::::::::::::::: sect1
## []{#permissions .hidden-anchor .sr-only}8. Berechtigungen und Sichtbarkeit {#heading_permissions}

:::::::::::::::::::: sectionbody
::::::::::: sect2
### []{#_berechtigungen_zum_editieren .hidden-anchor .sr-only}8.1. Berechtigungen zum Editieren {#heading__berechtigungen_zum_editieren}

::: paragraph
Nochmal zurück zu den Regelpaketen. Normalerweise benötigt man für alle
Editieraktionen in BI die Rolle [Administrator]{.guihint}. Genauer
gesagt gibt es für BI zwei [Berechtigungen,](wato_user.html#roles) zu
finden unter [Setup \> Users \> Roles & permissions:]{.guihint}
:::

:::: imageblock
::: content
![bi 8 wato permissions](../images/bi_8_wato_permissions.png)
:::
::::

::: paragraph
In der Rolle [User]{.guihint} ist standardmäßig nur die erste der beiden
Berechtigungen aktiv. Normale Benutzer können also nur in solchen
Regelpaketen arbeiten, in denen sie als Kontakt hinterlegt sind. Dies
erledigen Sie in den [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} Details des
Regelpakets.
:::

::: paragraph
Im folgenden Beispiel ist bei [Permitted Contact Groups]{.guihint} die
Kontaktgruppe [The Mystery Admins]{.guihint} hinterlegt. Alle Mitglieder
dieser Gruppe dürfen jetzt in diesem Paket Regeln editieren:
:::

:::: imageblock
::: content
![bi 8 pack properties](../images/bi_8_pack_properties.png)
:::
::::

::: paragraph
Übrigens können Sie mit [Public \> Allow all users to refer to rules
contained in this pack]{.guihint} anderen Benutzern zumindest erlauben,
die hier enthaltenen Regeln zu **verwenden** --- also (woanders) eigene
Regeln zu definieren, welche diese Regeln als Unterknoten aufrufen.
:::
:::::::::::

:::::::::: sect2
### []{#_berechtigungen_auf_hosts_und_services .hidden-anchor .sr-only}8.2. Berechtigungen auf Hosts und Services {#heading__berechtigungen_auf_hosts_und_services}

::: paragraph
Und wie ist es eigentlich mit der Sichtbarkeit der Aggregationen in der
Statusoberfläche? Welcher Kontakt darf was sehen?
:::

::: paragraph
Nun --- in BI-Aggregaten selbst können Sie keine Rechte vergeben. Das
geschieht indirekt über die Sichtbarkeit der Hosts und Services und wird
geregelt über die Berechtigung [See all hosts and services]{.guihint}
einzelner Rollen unter [Setup \> Roles & Permissions:]{.guihint}
:::

:::: imageblock
::: content
![bi 8 see all](../images/bi_8_see_all.png)
:::
::::

::: paragraph
In der Rolle [User]{.guihint} ist dieses Recht per Default ausgeknipst.
Normale Benutzer können nur für sie freigegebene Hosts und Services
sehen. Und das drückt sich bei BI so aus, dass sie genau alle
BI-Aggregationen sehen, welche mindestens einen freigegebenen Host oder
Service enthalten. Diese Aggregate enthalten aber auch **nur** diese
berechtigten Objekte und sind daher eventuell ausgedünnt. Und das
wiederum bedeutet, dass sie für unterschiedliche Benutzer
unterschiedliche Zustände haben können!
:::

::: paragraph
Ob das jetzt gut oder schlecht ist, hängt davon ab, was Sie möchten. Im
Zweifel können Sie die Berechtigung umschalten und manchen oder allen
Benutzern erlauben, über den Umweg von BI auch Hosts und Services zu
sehen, für die sie kein Kontakt sind --- und damit sicherstellen, dass
der Zustand eines Aggregats immer für alle gleich ist.
:::

::: paragraph
Das ganze Thema spielt natürlich nur dann eine Rolle, wenn es überhaupt
Aggregate gibt, die so bunt zusammengewürfelt sind, dass eben manche
Benutzer nur für Teile davon Kontakte sind.
:::
::::::::::
::::::::::::::::::::
:::::::::::::::::::::

::::::::::::::::::::::::::::::: sect1
## []{#operating .hidden-anchor .sr-only}9. BI im Operating Teil 3: Wartungszeiten, Quittierung {#heading_operating}

:::::::::::::::::::::::::::::: sectionbody
::::::::::::::: sect2
### []{#_die_generelle_idee .hidden-anchor .sr-only}9.1. Die generelle Idee {#heading__die_generelle_idee}

::: paragraph
Wie hält es BI eigentlich mit [![icon
downtime](../images/icons/icon_downtime.png)]{.image-inline}
[Wartungszeiten?](basics_downtimes.html) Nun, hier haben wir lange
nachgedacht und mit vielen Anwendern diskutiert. Das Ergebnis ist wie
folgt:
:::

::: ulist
- Sie können ein BI-Aggregat nicht direkt in eine Wartungszeit
  versetzen --- müssen es aber auch nicht, denn ...​

- die Wartungszeit eines BI-Aggregats leitet sich automatisch von den
  Wartungszeiten seiner Hosts und Services ab.
:::

::: paragraph
Um zu verstehen, nach welcher Regel BI den Zustand „in Wartung"
berechnet, hilft es, wenn Sie sich zurückerinnern, was die eigentliche
Idee hinter Wartungszeiten ist: *Am betreffenden Objekt wird gerade
gearbeitet. Mit Ausfällen ist zu rechnen. Auch wenn das Objekt gerade
[OK]{.state0} ist, sollte man sich nicht darauf verlassen. Es kann
jederzeit [CRIT]{.state2} werden. Dies ist bekannt und dokumentiert. Es
soll nicht benachrichtigt werden.*
:::

::: paragraph
Diese Idee kann man 1:1 auf BI übertragen: Im Aggregat gibt es
vielleicht ein paar Hosts und Services, welche gerade in Wartung sind.
Ob diese gerade [OK]{.state0} oder [CRIT]{.state2} sind, spielt keine
Rolle, denn es ist ja eigentlich Zufall, ob die Objekte während der
Wartungsarbeiten ab und zu mal wieder funktionieren oder nicht. Bloß
weil im Aggregat aber ein Wartungsobjekt steckt, bedeutet das aber auch
nicht gleich, dass die Anwendung, die das Aggregat abbildet, selbst
„bedroht" ist und als „in Wartung" markiert sein muss. Denn es kann ja
Redundanz eingebaut sein, welche den Ausfall der Wartungsobjekte
kompensiert. Nur wenn so ein Ausfall tatsächlich zum
[CRIT]{.state2}-Zustand des Aggregats führen würde --- es also eben
*nicht* genug Redundanz gibt und das Aggregat wirklich bedroht
ist --- genau dann wird es von Checkmk als „in Wartung" markiert. Wobei
auch hier der *aktuelle* Zustand der Objekte generell keine Rolle
spielt.
:::

::: paragraph
Knapper formuliert ist die genaue Regel wie folgt:
:::

::: paragraph
Wenn ein [CRIT]{.state2}-Zustand eines Hosts/Services zu einem
[CRIT]{.state2}-Zustand der Aggregation führen **würde,** führt ein „in
Wartung"-Zustand dieses Hosts/Services zu einem „in Wartung"-Zustand der
Aggregation.
:::

::: paragraph
Wichtig: der *wirkliche* aktuelle Zustand der Hosts/Services spielt bei
der Berechnung *keine* Rolle - was in Wartung ist, wird in der BI-Logik
als [CRIT]{.state2} angenommen. Warum? Weil ein [UP]{.hstate0}- oder
[OK]{.state0}-Zustand während einer Wartungszeit reiner Zufall ist,
etwa, wenn ein Host zwischen mehreren Neustarts zwischenzeitlich für
wenige Sekunden [UP]{.hstate0} meldet.
:::

::: paragraph
Und hier haben wir jetzt noch ein Beispiel: Um Platz zu sparen ist dies
eine Variante mit nur einem Mystery-Server anstelle von zwei:
:::

:::: imageblock
::: content
![bi 9 downtimes](../images/bi_9_downtimes.png)
:::
::::

::: paragraph
Hier ist zunächst der Host `switch-1` in Wartung. Für den Knoten
`Infrastructure` hat das aber keine Auswirkung. Denn `switch-2` ist ja
*nicht* in Wartung. Also ist `Infrastructure` auch nicht in Wartung.
Dort fehlt das Symbol [![icon derived
downtime](../images/icons/icon_derived_downtime.png)]{.image-inline} für
abgeleitete Wartungszeiten.
:::

::: paragraph
Aber: Auch der Service `Memory` auf `srv-mys-1` ist in Wartung. Dieser
ist *nicht* redundant. Die Wartung vererbt sich daher auf den
Vaterknoten `Mystery Server 1`, dann weiter auf `Mystery Servers` und
schließlich auf den obersten Knoten `The Mystery Application`. Also ist
dieser auch in Wartung.
:::
:::::::::::::::

:::: sect2
### []{#_kommando_wartungszeit .hidden-anchor .sr-only}9.2. Kommando Wartungszeit {#heading__kommando_wartungszeit}

::: paragraph
Haben wir oben geschrieben, dass Sie ein BI-Aggregat nicht manuell in
eine Wartungszeit versetzen können? Das stimmt eigentlich nur halb. Denn
Sie werden in der Tat bei BI-Aggregaten ein Kommando [![icon
commands](../images/icons/icon_commands.png)]{.image-inline} zum Setzen
von Wartungszeiten finden. Aber das macht nichts anderes, als auf auf
*jeden einzelnen Host und Service* des Aggregats eine Wartung
einzutragen. Das führt dann natürlich in der Regel dazu, dass das
Aggregat selbst auch als in Wartung gilt. Aber das ist nur indirekt.
:::
::::

::::::: sect2
### []{#_tuning_möglichkeiten .hidden-anchor .sr-only}9.3. Tuning-Möglichkeiten {#heading__tuning_möglichkeiten}

::: paragraph
Oben haben Sie gesehen, dass die Wartungszeitberechnung auf Basis eines
angenommenen [CRIT]{.state2}-Zustands läuft. In den Eigenschaften eines
Aggregats können Sie den Algorithmus so anpassen, dass ein Knoten
bereits bei einem angenommenen [WARN]{.state1}-Zustand als in Wartung
gilt. Die Option hierzu heißt [Escalate downtimes based on aggregated
WARN state]{.guihint}:
:::

:::: imageblock
::: content
![bi 9 downtimes on warn](../images/bi_9_downtimes_on_warn.png)
:::
::::

::: paragraph
Die Grundannahme, dass die in Wartung befindlichen Objekte
[CRIT]{.state2} sind, bleibt bestehen. Einen Unterschied gibt es nur
dort, wo aufgrund der Aggregatsfunktion aus [CRIT]{.state2} ein
[WARN]{.state1} werden kann --- so wie das z. B. beim allerersten
Beispiel mit [Count the number of nodes in state OK]{.guihint} der Fall
war. Hier würde eine Wartungszeit bereits dann angenommen werden, wenn
auch nur einer der beiden Switche in Wartung wäre.
:::
:::::::

::::::::: sect2
### []{#_quittierungen .hidden-anchor .sr-only}9.4. Quittierungen {#heading__quittierungen}

::: paragraph
Ganz ähnlich zu den Wartungszeiten wird auch die Information, ob ein
Problem [![icon ack](../images/icons/icon_ack.png)]{.image-inline}
[quittiert](basics_ackn.html) ist, von BI automatisch berechnet. Diesmal
spielt der Zustand der Objekte durchaus eine Rolle.
:::

::: paragraph
Die Idee hier ist, folgendes Konzept auf BI zu übertragen: Ein Objekt
hat ein Problem ([WARN]{.state1}, [CRIT]{.state2}). Aber das ist bekannt
und jemand arbeitet daran ([![icon
ack](../images/icons/icon_ack.png)]{.image-inline}).
:::

::: paragraph
Sie können das für ein Aggregat wie folgt selbst berechnen:
:::

::: ulist
- Nehmen Sie an, dass alle Hosts und Services, die [![icon
  ack](../images/icons/icon_ack.png)]{.image-inline} quittierte Probleme
  haben, wieder [OK]{.state0} wären.

- Würde das Aggregat dann selbst auch wieder [OK]{.state0}? Genau dann
  gilt es ebenfalls als [![icon
  ack](../images/icons/icon_ack.png)]{.image-inline} quittiert.
:::

::: paragraph
Würde das Aggregat jedoch [WARN]{.state1} oder [CRIT]{.state2} bleiben,
dann gilt es **nicht** als quittiert. Dann muss es noch mindestens ein
weiteres wichtiges Problem geben, das selbst nicht quittiert ist und den
[OK]{.state0}-Zustand des Aggregats entfernt.
:::

::: paragraph
Übrigens wird Ihnen bei den [![icon
commands](../images/icons/icon_commands.png)]{.image-inline} Kommandos
zu einem BI-Aggregat angeboten, dessen Probleme zu quittieren. Dies
bedeutet aber nur, dass *alle* im Aggregat erfassten Hosts und Services
quittiert werden (nur solche, die aktuell auch Probleme haben).
:::
:::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

::::::::::::::::: sect1
## []{#freeze .hidden-anchor .sr-only}10. Veränderungen sichtbar machen {#heading_freeze}

:::::::::::::::: sectionbody
::: paragraph
Die Knoten eines Aggregats können sich im laufenden Betrieb schon mal
ändern. Durch eingefrorene Aggregate (*frozen aggregations*) können Sie
solche Änderungen sichtbar machen.
:::

::: paragraph
Hier ein Beispiel: Ein Switch mit 6 Ports soll [OK]{.state0} sein, wenn
5 Services/Ports [OK]{.state0} sind. Dann werden im Rahmen eines
Firmware-Updates 2 Ports umbenannt und die zugehörigen Services
verschwinden aus dem Monitoring.
:::

::: paragraph
Das Aggregat bestünde dann aus 4 Services mit Zustand [OK]{.state0},
wäre selbst aber [WARN]{.state1} oder [CRIT]{.state2} --- ohne einen
Hinweis auf den Grund zu liefern. Und genau hier setzt die eingefrorene
Aggregate an: Sie frieren den Ist-Zustand ein und können später
jederzeit per Klick aufführen lassen, was sich seitdem geändert hat,
also welche Knoten hinzugekommen beziehungsweise herausgefallen sind.
Soll heißen: Während die Regeln eines Aggregats dessen Zustand erklären,
erklären eingefrorene Aggregate Zustandsänderungen.
:::

:::::::::::: sect2
### []{#_einfrieren_und_vergleichen .hidden-anchor .sr-only}10.1. Einfrieren und vergleichen {#heading__einfrieren_und_vergleichen}

::: paragraph
Der Einsatz der Einfrieren-Funktion ist denkbar einfach: Aktivieren Sie
die Option [New aggregations are frozen]{.guihint} in den Einstellungen
von Aggregaten.
:::

:::: imageblock
::: content
![Option zum Einfrieren einer
Aggregation.](../images/bi_freeze_option.png)
:::
::::

::: paragraph
Damit wird das Aggregat beim Speichern eingefroren - und zwar immer,
wenn das Häkchen neu gesetzt wird; auch wenn das Aggregat vorher schon
bestanden hat (trotz des Hinweises auf [New aggregations
...​]{.guihint}). Um den Eingefroren-Status aufzuheben, entfernen Sie das
Häkchen entsprechend.
:::

::: paragraph
Im Monitoring sehen Sie nun neben dem Aggregat ein neues
[![Schneeflocken-Symbol](../images/icons/icon_bi_freeze.png)]{.image-inline}
Schneeflocken-Symbol. Damit gelangen Sie zu der Differenzansicht: Links
der eingefrorene Baum, rechts der aktuelle Baum mit hervorgehobenen
Veränderungen (hier der Wegfall des Services [backup3)]{.guihint}:
:::

::::: imageblock
::: content
![Differenz zwischen eingefrorenem und aktuellem Zustand eines
Aggregats.](../images/bi_freeze_diff.png)
:::

::: title
Ohne eingefrorenen Zustand bliebe der Wegfall von [backup3]{.guihint}
unbemerkt
:::
:::::

::: paragraph
Wenn Sie nun den aktuellen Zustand abermals einfrieren wollen, erledigen
Sie das über [Commands \> Freeze aggregations.]{.guihint} Aber Vorsicht:
Es gibt immer nur einen eingefrorenen Ist-Zustand und keine Historie mit
älteren Zuständen.
:::
::::::::::::
::::::::::::::::
:::::::::::::::::

:::::::: sect1
## []{#availability .hidden-anchor .sr-only}11. Verfügbarkeit {#heading_availability}

::::::: sectionbody
::: paragraph
Genauso wie bei Hosts und Services können Sie auch bei BI die
[Verfügbarkeit](availability.html) eines oder mehrerer Aggregate für
beliebige Zeiträume in der Vergangenheit berechnen lassen. Dazu
rekonstruiert das BI-Modul anhand der Historie von Hosts und Services
den Zustand des Aggregats für jeden Zeitpunkt in der Vergangenheit.
Somit können Sie auch für solche Zeiträume Verfügbarkeiten berechnen, in
denen das Aggregat noch gar nicht konfiguriert war!
:::

:::: imageblock
::: content
![bi 10 availability example](../images/bi_10_availability_example.png)
:::
::::

::: paragraph
Alle Einzelheiten zu BI und Verfügbarkeit finden Sie im Artikel zur
Verfügbarkeit im Abschnitt zu [BI](availability.html#bi).
:::
:::::::
::::::::

:::::::::: sect1
## []{#_bi_im_verteilten_monitoring .hidden-anchor .sr-only}12. BI im verteilten Monitoring {#heading__bi_im_verteilten_monitoring}

::::::::: sectionbody
::: paragraph
Was geschieht eigentlich mit BI in einer [verteilten
Umgebung](distributed_monitoring.html)? Also wenn die Hosts über mehrere
Monitoring-Server verteilt sind?
:::

::: paragraph
Die Antwort ist relativ einfach: Es funktioniert --- und zwar ohne, dass
Sie etwas Weiteres beachten müssten. Da BI eine Komponente der
Benutzeroberfläche ist und diese von Haus aus eine verteilte Umgebung
annimmt, ist dies für BI vollkommen transparent.
:::

::: paragraph
Sollte ein Standort aktuell nicht erreichbar oder durch Sie manuell aus
der GUI ausgeblendet worden sein, so sind die Hosts des Standorts für BI
nicht mehr vorhanden. Das bedeutet dann:
:::

::: ulist
- BI-Aggregate, die *ausschließlich* aus Objekten dieses Standorts
  aufgebaut sind, verschwinden.

- BI-Aggregate, die *teilweise* aus Objekten dieses Standorts aufgebaut
  sind, werden ausgedünnt.
:::

::: paragraph
In letzterem Fall kann sich das natürlich auf den Zustand der
betroffenen Aggregate auswirken. Wie genau, das hängt von Ihren
Aggregatsfunktionen ab. Wenn Sie z. B. überall [worst]{.guihint}
verwendet haben, kann der Zustand insgesamt nur gleich bleiben oder
besser werden. Denn Objekte des nicht mehr vorhandenen Standorts könnten
[WARN]{.state1} oder [CRIT]{.state2} gewesen sein. Bei anderen
Aggregatsfunktionen können sich natürlich andere Zustände ergeben.
:::

::: paragraph
Ob dieses Verhalten für Sie sinnvoll ist oder nicht, müssen Sie im
Einzelfall beurteilen. BI ist auf jeden Fall so aufgebaut, dass nicht
vorhandene Objekte nicht in einem Aggregat vorkommen können und auch
nicht vermisst werden. Denn alle BI-Regeln arbeiten ja, wie bereits oben
erklärt, ausschließlich mit Suchmustern.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::: sect1
## []{#biasservice .hidden-anchor .sr-only}13. Benachrichtigungen, BI als Service {#heading_biasservice}

:::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_aktive_checks_oder_datenquellenprogramm .hidden-anchor .sr-only}13.1. Aktive Checks oder Datenquellenprogramm {#heading__aktive_checks_oder_datenquellenprogramm}

:::: {.imageblock .inline-image}
::: content
![bi large icon
notifications](../images/bi_large_icon_notifications.png){width="80"}
:::
::::

::: paragraph
Kann man bei Zustandsänderungen in BI-Aggregaten eigentlich
[benachrichtigen](notifications.html)? Nun --- auf direktem Wege geht
das erst mal nicht, denn BI ist ausschließlich in der GUI vorhanden und
hat keinen Bezug zum eigentlichen Monitoring. Aber: Sie können aus
BI-Aggregaten normale Services machen. Und diese können dann natürlich
wieder Benachrichtigungen auslösen. Dazu gibt es zwei Möglichkeiten:
:::

::: ulist
- Mit dem Datenquellenprogramm [Check state of BI
  Aggregations]{.guihint}

- Mit aktiven Checks vom Typ [Check State of BI Aggregation]{.guihint}
:::
:::::::

:::::::::: sect2
### []{#_benachrichtigungen_über_datenquellenprogramm .hidden-anchor .sr-only}13.2. Benachrichtigungen über Datenquellenprogramm {#heading__benachrichtigungen_über_datenquellenprogramm}

::: paragraph
Den Anfang macht die Methode
„[Datenquellenprogramm](datasource_programs.html)", denn diese ist immer
dann gut, wenn Sie mehr als nur eine Handvoll Aggregate als Services
erzeugen wollen. Dazu finden Sie unter [Setup \> Agents \> Other
integrations \> BI Aggregations]{.guihint} den passenden Regelsatz:
:::

:::: imageblock
::: content
![bi 12 datasource program](../images/bi_12_datasource_program.png)
:::
::::

::: paragraph
Hier können Sie sogar verschiedene Optionen angeben, zu welchen Hosts
die Services hinzugefügt werden sollen. Sie müssen nicht zwingend an dem
Host kleben, welcher das Datenquellenprogramm ausführt ([Assign to the
querying host]{.guihint}). Möglich ist auch eine Zuordnung zu den Hosts,
welche das Aggregat betrifft ([Assign to the affected hosts]{.guihint}).
Das macht allerdings nur dann wirklich Sinn, wenn es sich dabei immer
nur um einen Host handelt. Über reguläre Ausdrücke und Ersetzungen
können Sie sogar noch flexibler zuordnen. Das Ganze geschieht dann über
den [Piggyback-Mechanismus](piggyback.html).
:::

::: paragraph
**Wichtig:** Falls der Host, dem Sie diese Regel zuweisen, auch noch
über den normalen Agenten überwacht werden soll, müssen Sie unbedingt in
dessen Einstellungen dafür sorgen, dass Agent **und**
Datenquellenprogramme ausgeführt werden:
:::

:::: imageblock
::: content
![bi 12 agent and all ds
program](../images/bi_12_agent_and_all_ds_program.png)
:::
::::
::::::::::

:::::::::::::: sect2
### []{#_benachrichtigungen_über_einen_aktiven_check .hidden-anchor .sr-only}13.3. Benachrichtigungen über einen aktiven Check {#heading__benachrichtigungen_über_einen_aktiven_check}

::: paragraph
Die Benachrichtigung mit einem aktiven Check ist quasi der direktere Weg
und erfordert keinen künstlichen „Hilfs-Host", welcher das
Datenquellenprogramm ausführt. Da er jedes Aggregat einzeln abfragen
muss, ist er aber bei einer größeren Menge von Aggregaten deutlich
weniger performant und dann auch umständlicher aufzusetzen.
:::

::: paragraph
Das Ganze geht so: Es gibt einen aktiven Check, welcher per HTTP von der
[REST-API](rest_api.html) von Checkmk den Zustand von BI-Aggregaten
abrufen kann. Diesen können Sie bequem mit dem Regelsatz [Setup \>
Services \> Other services \> Check State of BI Aggregation]{.guihint}
einrichten:
:::

:::: imageblock
::: content
![bi 12 active check rule](../images/bi_12_active_check_rule.png)
:::
::::

::: paragraph
Beachten Sie hierbei Folgendes:
:::

::: ulist
- Aktivieren Sie diese Regel nur für den Host, welcher den
  entsprechenden neuen BI-Service bekommen soll.

- Die URL muss diejenige sein, mittels der **dieser Host** auf die GUI
  von Checkmk zugreifen kann.

- Der Benutzer muss ein [Automationsbenutzer](wato_user.html#automation)
  sein. Nur solch einer darf die REST-API abrufen. Der Benutzer
  `automation` bietet sich an, da dieser immer automatisch für solche
  Zwecke angelegt wird.

- Tragen Sie bei [Automation Secret]{.guihint} das [Automation secret
  for machine accounts]{.guihint} des Benutzers ein, welches Sie in der
  Konfigurationsmaske der Benutzereigenschaften finden (nur, wenn Sie
  einen anderen Automationsbenutzer verwenden als `automation`).
:::

::: paragraph
Im Beispiel ist [Automatically track downtimes of aggregation]{.guihint}
aktiviert. Genau genommen sind damit die *scheduled* Downtimes gemeint,
also die geplanten Wartungszeiten. Damit wird der neue aktive Service
automatisch eine Wartungszeit bekommen, wenn auch das BI-Aggregat dies
tut.
:::

::: paragraph
Der neue Service zeigt dann --- natürlich mit einer Verzögerung von bis
zu einem Check-Intervall --- den Zustand des Aggregats. Im Beispiel
liegt der BI-Check auf dem Host `srv-mys-1`:
:::

:::: imageblock
::: content
![bi 12 active check output](../images/bi_12_active_check_output.png)
:::
::::

::: paragraph
Diesen Service können Sie dann wie gewohnt Kontakten zuordnen und ihn
als Basis für Benachrichtigungen verwenden.
:::
::::::::::::::
::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
