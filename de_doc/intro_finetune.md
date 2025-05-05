:::: {#header}
# Das Monitoring feinjustieren

::: details
[Last modified on 11-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_finetune.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Mit mehreren Benutzern arbeiten](intro_users.html)
[Regeln](wato_rules.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#false_positives .hidden-anchor .sr-only}1. Fehlalarme --- der Tod jedes Monitorings {#heading_false_positives}

:::::::::: sectionbody
::: paragraph
Ein Monitoring ist nur dann wirklich nützlich, wenn es präzise ist. Das
größte Hindernis für die Akzeptanz bei Kollegen (und wohl auch bei Ihnen
selbst) sind dabei *false positives* --- oder auf gut deutsch
**Fehlalarme**.
:::

::: paragraph
Bei einigen Checkmk-Einsteigern haben wir erlebt, wie diese in kurzer
Zeit sehr viele Systeme in die Überwachung aufgenommen
haben --- vielleicht deswegen, weil das in Checkmk so einfach geht. Als
sie dann kurz danach die Benachrichtigungen für alle aktiviert hatten,
wurden die Kolleginnen mit Hunderten von E-Mails pro Tag überflutet, und
bereits nach wenigen Tagen war die Begeisterung für das Monitoring
nachhaltig gestört.
:::

::: paragraph
Auch wenn Checkmk sich wirklich Mühe gibt, für alle möglichen
Einstellungen sinnvolle und vernünftige Standardwerte zu definieren,
kann es einfach nicht präzise genug wissen, wie es in Ihrer IT-Umgebung
unter Normalzuständen zugehen soll. Deswegen ist von Ihrer Seite ein
bisschen Handarbeit erforderlich, um das Monitoring feinzujustieren
(*fine-tuning*) bis auch der letzte Fehlalarm gar nicht erst gesendet
wird. Abgesehen davon wird Checkmk auch etliche wirkliche Probleme
finden, von denen Sie und Ihre Kolleginnen noch nichts geahnt haben.
Auch die gilt es zuerst einmalig zu beheben --- und zwar in der
Realität, nicht im Monitoring!
:::

::: paragraph
Bewährt hat sich folgender Grundsatz: erst Qualität, dann
Quantität --- oder anders ausgedrückt:
:::

::: ulist
- Nehmen Sie nicht zu viele Hosts auf einmal ins Monitoring auf.

- Sorgen Sie dafür, dass alle Services, bei denen nicht wirklich ein
  Problem besteht, zuverlässig auf [OK]{.state0} sind.

- Aktivieren Sie die Benachrichtigungen per E-Mail oder SMS erst, wenn
  Checkmk eine Zeit lang zuverlässig ohne oder mit sehr wenigen
  Fehlalarmen läuft.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Fehlalarme können natürlich nur   |
|                                   | bei eingeschalteten               |
|                                   | Benachrichtigungen entstehen.     |
|                                   | Worum es im folgenden also geht,  |
|                                   | ist es die Vorstufe der           |
|                                   | Benachrichtigungen abzustellen    |
|                                   | und die kritischen Zustände       |
|                                   | [DOWN]{.hstate1}, [WARN]{.state1} |
|                                   | oder [CRIT]{.state2} für          |
|                                   | unkritische Probleme zu           |
|                                   | vermeiden.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Welche Möglichkeiten zur Feinjustierung Sie haben (damit all das grün
wird, was keine Probleme verursacht), und wie Sie gelegentliche
Aussetzer in den Griff bekommen, zeigen wir Ihnen in den folgenden
Kapiteln zur Konfiguration.
:::
::::::::::
:::::::::::

:::::::::: sect1
## []{#rules .hidden-anchor .sr-only}2. Regelbasiert konfigurieren {#heading_rules}

::::::::: sectionbody
::: paragraph
Bevor wir ans Konfigurieren gehen, müssen wir uns zuerst kurz mit den
Einstellungen von Hosts und Services in Checkmk auseinandersetzen. Da
Checkmk für große und komplexe Umgebungen entwickelt wurde, geschieht
das anhand von **Regeln**. Dieses Konzept ist sehr leistungsfähig und
bringt auch in kleineren Umgebungen viele Vorteile.
:::

::: paragraph
Die Grundidee ist, dass Sie nicht für jeden Service jeden einzelnen
Parameter explizit festlegen, sondern so etwas umsetzen wie: „*Auf allen
produktiven Oracle-Servern werden Dateisysteme mit dem Präfix
`/var/ora/` bei 90 % Füllgrad* [WARN]{.state1} *und bei 95 %*
[CRIT]{.state2}."
:::

::: paragraph
So eine Regel kann mit einem Schlag Schwellwerte für Tausende von
Dateisystemen festlegen. Gleichzeitig dokumentiert sie auch sehr
übersichtlich, welche Überwachungsrichtlinien in Ihrem Unternehmen
gelten.
:::

::: paragraph
Basierend auf einer Grundregel können Sie dann Ausnahmen für Einzelfälle
gesondert festlegen. Eine passende Regel könnte so aussehen: „*Auf dem
Oracle-Server `srvora123` wird das Dateisystem `/var/ora/db01/` bei 96 %
Füllgrad* [WARN]{.state1} *und bei 98 %* [CRIT]{.state2}." Diese
Ausnahmeregel wird in Checkmk in der gleichen Art und Weise wie die
Grundregel festgelegt.
:::

::: paragraph
Jede Regel hat den gleichen Aufbau. Sie besteht immer aus einer
**Bedingung** und einem **Wert.** Zusätzlich können Sie noch eine
Beschreibung und einen Kommentar hinterlegen, um den Sinn der Regel zu
dokumentieren.
:::

::: paragraph
Die Regeln sind in Regelsätzen (*rule sets*) organisiert. Für jede Art
von Parameter hat Checkmk einen passenden Regelsatz parat, sodass Sie
aus mehreren hundert Regelsätzen auswählen können. So gibt es etwa einen
mit dem Namen [Filesystems (used space and growth)]{.guihint}, der die
Schwellwerte für alle Services festlegt, die Dateisysteme überwachen. Um
das obige Beispiel umzusetzen, würden Sie aus diesem Regelsatz die
Grundregel und die Ausnahmeregel festlegen. Um festzustellen, welche
Schwellwerte für ein bestimmtes Dateisystem gültig sind, geht Checkmk
alle für den Check gültigen Regeln der Reihe nach durch. Die erste
Regel, bei der die Bedingung zutrifft, legt den Wert fest --- also in
diesem Fall den Prozentwert, bei dessen Erreichen der Dateisystemcheck
[WARN]{.state1} oder [CRIT]{.state2} wird.
:::
:::::::::
::::::::::

:::::::::::::: sect1
## []{#find_rules .hidden-anchor .sr-only}3. Regeln finden {#heading_find_rules}

::::::::::::: sectionbody
::: paragraph
Sie haben verschiedene Möglichkeiten zum Zugriff auf das Regelwerk von
Checkmk.
:::

::: paragraph
Zum einen finden Sie die Regelsätze im [Setup]{.guihint}-Menü unter den
Themen der Objekte, für die es Regelsätze gibt ([Hosts]{.guihint},
[Services]{.guihint} und [Agents]{.guihint}) in verschiedenen
Kategorien. Für Services gibt es z.B. die folgenden Einträge mit
Regelsätzen: [Service monitoring rules]{.guihint}, [Discovery
rules]{.guihint}, [Enforced services]{.guihint}, [HTTP, TCP, Email,
...​]{.guihint} und [Other Services]{.guihint}. Wenn Sie einen dieser
Einträge auswählen, werden Ihnen die zugehörigen Regelsätze auf der
Hauptseite aufgelistet. Das können eine Handvoll sein, aber auch sehr,
sehr viele wie bei den [Service monitoring rules]{.guihint}. Daher haben
Sie auf der Ergebnisseite die Möglichkeit zu filtern: im
[Filter]{.guihint}-Feld der Menüleiste.
:::

::: paragraph
Wenn Sie sich unsicher sind, in welcher Kategorie der Regelsatz zu
finden ist, können Sie auch gleich **alle** Regeln durchsuchen, indem
Sie entweder das [Suchfeld im Setup-Menü](intro_gui.html#search_setup)
nutzen oder über [Setup \> General \> Rule search]{.guihint} die Seite
zur Regelsuche öffnen. Wir werden den letztgenannten Weg im folgenden
Kapitel gehen, in dem wir die Erstellung einer Regel vorstellen.
:::

::: paragraph
Bei der großen Anzahl der verfügbaren Regelsätze ist es mit oder ohne
Suche nicht immer einfach, den richtigen zu finden. Es gibt aber noch
einen anderen Weg, mit dem Sie auf die passenden Regeln für einen
bereits existierenden Service zugreifen können. Klicken Sie in einer
Tabellenansicht mit dem Service auf das [![Symbol zum Öffnen des
Aktionsmenüs.](../images/icons/icon_menu.png)]{.image-inline} Menü und
wählen Sie den Eintrag [Parameters for this service]{.guihint}:
:::

:::: imageblock
::: content
![Listeneintrag eines Services mit geöffnetem
Aktionsmenü.](../images/intro_service_rule_icon.png)
:::
::::

::: paragraph
Sie erhalten eine Seite, von der aus Sie Zugriff auf alle Regelsätze
dieses Services haben:
:::

:::: imageblock
::: content
![Liste aller Regelsätze für einen
Service.](../images/intro_parameters_of_this_service.png)
:::
::::

::: paragraph
Im ersten Kasten mit dem Titel [Check origin and parameters]{.guihint}
führt Sie der Eintrag [Filesystems (used space and growth)]{.guihint}
direkt zum Regelsatz für die Schwellwerte der Dateisystemüberwachung.
Sie können aber in der Übersicht sehen, dass Checkmk bereits
Standardwerte festgelegt hat, sodass Sie eine Regel nur dann erstellen
müssen, wenn Sie die Standardwerte ändern wollen.
:::
:::::::::::::
::::::::::::::

:::::::::::::::::::::::::::::::::: sect1
## []{#create_rules .hidden-anchor .sr-only}4. Regeln erstellen {#heading_create_rules}

::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Wie sieht das mit den Regeln nun in der Praxis aus? Am besten starten
Sie damit, die Regel, die Sie umsetzen wollen, in einem Satz zu
formulieren, etwa in diesem: „*Auf allen produktiven Oracle-Servern
werden die Tablespaces DW20 und DW30 bei 90 % Füllgrad* [WARN]{.state1}
*und bei 95 %* [CRIT]{.state2}."
:::

::: paragraph
Dann suchen Sie sich den passenden Regelsatz --- in diesem Beispiel über
die Regelsuche: [Setup \> General \> Rule search.]{.guihint} Dies öffnet
eine Seite, in der Sie nach „Oracle" oder nach „tablespace" suchen
können (Groß- und Kleinschreibung spielen keine Rolle) und alle
Regelsätze finden, die diesen Text im Namen oder in der (hier
unsichtbaren) Beschreibung enthalten:
:::

::::: imageblock
::: content
![Ergebnis der Suche nach \'tablespace\' in
Regeln.](../images/intro_ruleset_search_tablespace.png)
:::

::: title
Ergebnis der Regelsuche nach „tablespace"
:::
:::::

::: paragraph
Der Regelsatz [Oracle Tablespaces]{.guihint} wird in zwei Kategorien
gefunden. Die Zahl hinter dem Titel (hier überall `0`) zeigt die Anzahl
der Regeln, die aus diesem Regelsatz bereits erstellt wurden.
:::

::: paragraph
In diesem Beispiel soll *nicht* die [Einrichtung eines Services
erzwungen](wato_services.html#enforced_services) werden (*enforced
service*). Klicken Sie daher auf den Namen in der Kategorie [Service
monitoring rules.]{.guihint} Sie landen Sie in der Übersichtsseite des
Regelsatzes:
:::

:::: imageblock
::: content
![Dialog zur Erstellung einer Regel aus dem Regelsatz \'Oracle
Tablespaces\'.](../images/intro_ruleset_oracle_tablespaces.png)
:::
::::

::: paragraph
Der Regelsatz enthält noch keine Regeln. Sie können die erste mit dem
Knopf [Add rule]{.guihint} erstellen. Das Anlegen (und auch das spätere
Bearbeiten) der Regel bringt Sie zu einem Formular mit drei Kästen [Rule
properties]{.guihint}, [Value]{.guihint} und [Conditions.]{.guihint} Wir
werden uns die drei nacheinander vornehmen.
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Eigenschaften für die neue
Regel.](../images/intro_rule_ora_properties.png)
:::
::::

::: paragraph
Im Kasten [Rule properties]{.guihint} sind alle Angaben optional. Neben
den informativen Texten haben Sie hier auch die Möglichkeit, eine Regel
vorübergehend zu deaktivieren. Das ist praktisch, denn so vermeiden Sie
manchmal ein Löschen und Neuanlegen, wenn Sie eine Regel vorübergehend
nicht benötigen.
:::

::: paragraph
Was Sie im Kasten [Value]{.guihint} finden, hängt individuell vom Inhalt
dessen ab, was gerade geregelt wird:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Werte für die neue
Regel.](../images/intro_rule_ora_value.png)
:::
::::

::: paragraph
Wie Sie sehen, kann das schon eine ganze Menge an Parametern sein. Das
Beispiel zeigt einen typischen Fall: Jeder einzelne Parameter kann per
Checkbox aktiviert werden, und die Regel legt dann auch nur diesen fest.
Sie können z.B. einen anderen Parameter von einer anderen Regel
bestimmen lassen, wenn das Ihre Konfiguration vereinfacht. Im Beispiel
werden nur die Schwellwerte für den prozentualen freien Platz im
Tablespace definiert.
:::

::: paragraph
Der Kasten [Conditions]{.guihint} zur Festlegung der Bedingung sieht auf
den ersten Blick etwas unübersichtlicher aus:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Bedingungen für die neue
Regel.](../images/intro_rule_ora_condition.png)
:::
::::

::: paragraph
Wir gehen nur auf die Parameter ein, die wir für die Festlegung der
Beispielregel unbedingt benötigen:
:::

::: paragraph
Mit [Folder]{.guihint} legen Sie fest, in welchem Ordner die Regel
gelten soll. Wenn Sie die Voreinstellung [Main]{.guihint} z.B. auf
[Windows]{.guihint} ändern, so gilt die neue Regel nur für Hosts die
direkt im oder unterhalb vom Ordner [Windows]{.guihint} liegen.
:::

::: paragraph
Die Host-Merkmale ([Host tags]{.guihint}) sind ein ganz wichtiges
Feature von Checkmk, deshalb widmen wir ihnen gleich im Anschluss an
dieses ein eigenes Kapitel. An dieser Stelle nutzen Sie eines der
vordefinierten Host-Merkmale aus, um festzulegen, dass die Regel nur für
Produktivsysteme gelten soll: Wählen Sie zunächst in der Liste die
Host-Merkmalsgruppe [Criticality]{.guihint} aus, klicken Sie danach auf
[Add tag condition]{.guihint} und wählen den Wert [Productive
system]{.guihint} aus.
:::

::: paragraph
Sehr wichtig für das Beispiel sind die [Explicit tablespaces]{.guihint},
welche die Regel auf ganz bestimmte Services einschränken. Dazu sind
zwei Anmerkungen wichtig:
:::

::: ulist
- Der Name dieser Bedingung passt sich dem Regeltyp an. Wenn hier
  [Explicit services]{.guihint} steht, geben Sie die **Namen** der
  betroffenen Services an. Ein solcher könnte z.B. `Tablespace DW20`
  lauten --- also inklusive des Worts `Tablespace`. Im gezeigten
  Beispiel hingegen möchte Checkmk von Ihnen lediglich den Namen des
  Tablespaces selbst wissen, also z.B. `DW20`.

- Die eingegebenen Texte werden immer gegen den Anfang gematcht. Die
  Eingabe von `DW20` greift also auch auf einen fiktiven Tablespace
  `DW20A`. Wenn Sie das verhindern möchten, hängen Sie das Zeichen `$`
  an das Ende an, also `DW20$`, denn es handelt sich hier um sogenannte
  [reguläre Ausdrücke](regexes.html).
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die detaillierte Beschreibung     |
|                                   | aller anderen Parameter und eine  |
|                                   | ausführliche Erklärung zum        |
|                                   | wichtigen Konzept der Regeln      |
|                                   | finden Sie im [Artikel über       |
|                                   | Regeln](wato_rules.html). Mehr zu |
|                                   | den [Service labels]{.guihint},   |
|                                   | dem letzten Parameter im obigen   |
|                                   | Bild, erfahren Sie übrigens im    |
|                                   | [Artikel über                     |
|                                   | Labels](labels.html).             |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Nachdem alle Eingaben zur Festlegung komplett sind, sichern Sie die
Regel mit [Save.]{.guihint} Nach dem Speichern findet sich im Regelsatz
genau die eine neue Regel:
:::

:::: imageblock
::: content
![Liste der Regeln mit der erstellten neuen
Regel.](../images/intro_ruleset_ora_one_rule.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie statt mit einer später   |
|                                   | mit Hunderten von Regeln          |
|                                   | arbeiten, droht die Gefahr, den   |
|                                   | Überblick zu verlieren. Checkmk   |
|                                   | bietet auf jeder Seite, die       |
|                                   | Regeln auflistet, im Menü         |
|                                   | [Related]{.guihint} sehr          |
|                                   | hilfreiche Einträge an, um den    |
|                                   | Überblick zu behalten: Sie können |
|                                   | sich die in der aktuellen Instanz |
|                                   | genutzten Regeln anzeigen lassen  |
|                                   | ([Used rulesets]{.guihint}) und   |
|                                   | umgekehrt auch die, die gar nicht |
|                                   | genutzt werden ([Ineffective      |
|                                   | rules]{.guihint}).                |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::: sect1
## []{#host_tags .hidden-anchor .sr-only}5. Host-Merkmale {#heading_host_tags}

::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_so_funktionieren_host_merkmale .hidden-anchor .sr-only}5.1. So funktionieren Host-Merkmale {#heading__so_funktionieren_host_merkmale}

::: paragraph
Im vorherigen Kapitel haben wir ein Beispiel für eine Regel gesehen, die
nur für „produktive" Systeme gelten soll. Genauer gesagt haben wir in
der Regel eine Bedingung über das Host-Merkmal (*host tag*) [Productive
system]{.guihint} definiert. Warum haben wir die Bedingung als Merkmal
definiert und sie nicht einfach für den Ordner festgelegt? Nun, Sie
können nur eine einzige Ordnerstruktur definieren, und jeder Host kann
nur in einem Ordner sein. Es gibt aber viele unterschiedliche Merkmale,
die ein Host haben kann. Dafür ist die Ordnerstruktur zu beschränkt und
nicht flexibel genug.
:::

::: paragraph
Dagegen können Sie Host-Merkmale den Hosts völlig frei und beliebig
zuordnen --- egal, in welchem Ordner sich die Hosts befinden. In Ihren
Regeln können Sie sich dann auf diese Merkmale beziehen. Das macht die
Konfiguration nicht nur einfacher, sondern auch leichter verständlich
und weniger fehleranfällig, als wenn Sie für jeden Host alles explizit
festlegen würden.
:::

::: paragraph
Aber wie und wo legt man nun fest, welche Hosts welche Merkmale haben
sollen? Und wie können Sie eigene Merkmale definieren?
:::
::::::

::::::::::::::::: sect2
### []{#_host_merkmale_definieren .hidden-anchor .sr-only}5.2. Host-Merkmale definieren {#heading__host_merkmale_definieren}

::: paragraph
Beginnen wir mit der Antwort auf die zweite Frage nach eigenen
Merkmalen. Zunächst müssen Sie wissen, dass Merkmale in Gruppen
organisiert sind, den sogenannten Host-Merkmalsgruppen (*host tag
groups*). Nehmen wir als Beispiel den Standort (*location*). Eine
Merkmalsgruppe könnte *Location* heißen, und diese Gruppe könnte die
Merkmale *Munich*, *Austin* und *Singapore* enthalten. Grundsätzlich
gilt dabei, dass jedem Host aus jeder Merkmalsgruppe **genau ein
Merkmal** zugewiesen wird. Sobald Sie also eine eigene Merkmalsgruppe
definieren, trägt **jeder** Host eines der Merkmale aus dieser Gruppe.
Hosts, bei denen Sie kein Merkmal aus der Gruppe gewählt haben, bekommen
einfach per Default das erste zugewiesen.
:::

::: paragraph
Die Definition der Host-Merkmalsgruppen finden Sie unter [Setup \> Hosts
\> Tags:]{.guihint}
:::

:::: imageblock
::: content
![Liste aller vordefinierten
Host-Merkmalsgruppen.](../images/intro_tags_default.png)
:::
::::

::: paragraph
Wie Sie sehen, sind einige Merkmalsgruppen bereits vordefiniert. Die
meisten davon können Sie nicht ändern. Wir empfehlen Ihnen außerdem, die
beiden vordefinierten Beispielgruppen [Criticality]{.guihint} und
[Networking Segment]{.guihint} nicht anzutasten. Definieren Sie lieber
Ihre eigenen Gruppen:
:::

::: paragraph
Klicken Sie auf [Add tag group]{.guihint}. Dies öffnet die Seite zum
Erstellen einer neuen Merkmalsgruppe. Im ersten Kasten [Basic
settings]{.guihint} vergeben Sie --- wie so oft in Checkmk --- eine
interne ID, die als Schlüssel dient und später nicht mehr geändert
werden kann. Zusätzlich zur ID legen Sie einen sprechenden Titel fest,
den Sie später jederzeit ändern können. Mit [Topic]{.guihint} können Sie
das Thema bestimmen, unter dem das Merkmal bei den Eigenschaften des
Hosts später angeboten wird. Wenn Sie hier ein neues Topic erstellen,
wird das Merkmal bei den Host-Eigenschaften in einem eigenen Kasten
angezeigt.
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Grundeinstellungen für die neue
Host-Merkmalsgruppe.](../images/intro_new_taggroup_basic.png)
:::
::::

::: paragraph
Im zweiten Kasten [Tag choices]{.guihint} geht es um die eigentlichen
Merkmale, also die Auswahlmöglichkeiten der Gruppe. Klicken Sie [Add tag
choice]{.guihint}, um ein Merkmal zu erstellen und vergeben Sie auch
hier pro Merkmal eine interne ID und einen Titel:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Merkmale für die neue
Host-Merkmalsgruppe.](../images/intro_new_taggroup_choices.png)
:::
::::

::: paragraph
Hinweise:
:::

::: ulist
- Auch Gruppen mit nur einer einzigen Auswahl sind erlaubt und sogar
  sinnvoll. Das darin enthaltene Merkmal heißt Checkbox-Merkmal
  (*checkbox tag*) und erscheint dann in den Host-Eigenschaften als eben
  eine Checkbox. Jeder Host hat dann das Merkmal --- oder eben nicht,
  denn Checkbox-Merkmale sind standardmäßig deaktiviert.

- An dieser Stelle können Sie die Hilfsmerkmale (*auxiliary tags*)
  erstmal ignorieren. Sie erhalten alle Informationen zu Hilfsmerkmalen
  im Speziellen und zu Host-Merkmalen im Allgemeinen im [Artikel über
  Host-Merkmale.](host_tags.html)
:::

::: paragraph
Sobald Sie mit [Save]{.guihint} die neue Host-Merkmalsgruppe gesichert
haben, können Sie sie nutzen.
:::
:::::::::::::::::

::::::: sect2
### []{#_ein_merkmal_einem_host_zuordnen .hidden-anchor .sr-only}5.3. Ein Merkmal einem Host zuordnen {#heading__ein_merkmal_einem_host_zuordnen}

::: paragraph
Wie Sie einem Host Merkmale zuordnen, haben Sie schon gesehen: in den
Host-Eigenschaften beim Erstellen oder Bearbeiten eines Hosts. Im Kasten
[Custom attributes]{.guihint} (oder in einem eigenen, falls Sie ein
[Topic]{.guihint} erstellt haben) taucht nun die neue
Host-Merkmalsgruppe auf, und Sie können für den Host die Auswahl treffen
und das Merkmal festlegen:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften eines Hosts mit der neuen
Host-Merkmalsgruppe.](../images/intro_host_custom_attributes.png)
:::
::::

::: paragraph
Nachdem Sie jetzt die wichtigen Prinzipien der Konfiguration mit Regeln
und Host-Merkmalen kennengelernt haben, möchten wir Ihnen in den
restlichen Kapiteln einige konkrete Empfehlungen geben, um in einem
neuen Checkmk-System Fehlalarme zu reduzieren.
:::
:::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

::::::: sect1
## []{#filesystems .hidden-anchor .sr-only}6. Dateisystem-Schwellwerte anpassen {#heading_filesystems}

:::::: sectionbody
::: paragraph
Überprüfen Sie die Schwellwerte für die Überwachung von Dateisystemen
und passen Sie diese gegebenenfalls an. Die Standardwerte hatten wir
bereits weiter oben bei der [Suche nach Regeln](#find_rules) kurz
gezeigt.
:::

::: paragraph
Standardmäßig nimmt Checkmk beim Füllgrad von Dateisystemen die
Schwellen 80 % für [WARN]{.state1} und 90 % für [CRIT]{.state2}. Nun
sind 80 % bei einer 2 Terabytes großen Festplatte immerhin
400 Gigabytes --- vielleicht ein bisschen viel Puffer für eine Warnung.
Daher hier ein paar Tipps zum Thema Dateisysteme:
:::

::: ulist
- Legen Sie Ihre eigenen Regeln an im Regelsatz [Filesystems (used space
  and growth).]{.guihint}

- Die Parameter erlauben Schwellwerte, die von der Größe des
  Dateisystems abhängen. Wählen Sie dazu [Levels for used/free space \>
  Levels for used space \> Dynamic levels.]{.guihint} Mit dem Knopf [Add
  new element]{.guihint} definieren Sie jetzt pro Plattengröße eigene
  Schwellwerte.

- Noch einfacher geht es mit dem [Magic factor]{.guihint}, den wir im
  [letzten Kapitel](intro_bestpractise.html#magic_factor) vorstellen.
:::
::::::
:::::::

:::::::: sect1
## []{#hosts_downtime .hidden-anchor .sr-only}7. Hosts in die Wartung schicken {#heading_hosts_downtime}

::::::: sectionbody
::: paragraph
Manche Server werden turnusmäßig neu gestartet --- sei es, um Patches
einzuspielen oder einfach, weil das so vorgesehen ist. Sie können
Fehlalarme zu diesen Zeiten auf zwei Arten vermeiden:
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In Checkmk Raw
definieren Sie zunächst eine Zeitperiode (*time period*), welche die
Zeiten des Reboots abdeckt. Wie das geht, erfahren Sie im [Artikel über
Zeitperioden](timeperiods.html). Danach legen Sie jeweils eine Regel in
den Regelsätzen [Notification period for hosts]{.guihint} und
[Notification period for services]{.guihint} für die betroffenen Hosts
an und wählen dort die zuvor definierte Zeitperiode aus. Die zweite
Regel für die Services ist nötig, damit auch Services, die in dieser
Zeit auf [CRIT]{.state2} gehen, keine Benachrichtigungen auslösen. Falls
nun während dieser Zeiten Probleme auftreten (und rechtzeitig wieder
verschwinden), werden keine Benachrichtigungen ausgelöst.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen gibt es regelmäßige Wartungszeiten für diesen
Zweck, die Sie für die betroffenen Hosts setzen können.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Eine Alternative zur Erstellung   |
|                                   | von Wartungszeiten für Hosts, die |
|                                   | wir im [Kapitel über              |
|                                   | Wartungszeit                      |
|                                   | en](intro_monitor.html#downtimes) |
|                                   | schon beschrieben haben, ist in   |
|                                   | den kommerziellen Editionen der   |
|                                   | Regelsatz [Recurring downtimes    |
|                                   | for hosts.]{.guihint} Dieser hat  |
|                                   | den großen Vorteil, dass auch     |
|                                   | Hosts, die erst später in die     |
|                                   | Überwachung aufgenommen werden,   |
|                                   | automatisch diese Wartungszeiten  |
|                                   | erhalten.                         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::
::::::::

::::::::::::: sect1
## []{#hosts_down .hidden-anchor .sr-only}8. Abgeschaltete Hosts ignorieren {#heading_hosts_down}

:::::::::::: sectionbody
::: paragraph
Nicht immer ist es ein Problem, wenn ein Rechner abgeschaltet wird. Ein
klassisches Beispiel sind Drucker. Diese mit Checkmk zu überwachen ist
durchaus sinnvoll. Manche Anwender organisieren sogar die Nachbestellung
von Toner mit Checkmk. In aller Regel ist aber das Ausschalten eines
Druckers vor Feierabend kein Problem. Dumm ist nur, wenn Checkmk hier
benachrichtigt, weil der entsprechende Host [DOWN]{.hstate1} ist.
:::

::: paragraph
Sie können Checkmk mitteilen, dass es völlig in Ordnung ist, wenn ein
Host ausgeschaltet ist. Dazu suchen Sie den Regelsatz [Host Check
Command]{.guihint}, erstellen eine neue Regel und setzen Sie den Wert
auf [Always assume host to be up]{.guihint}:
:::

:::: imageblock
::: content
![Dialog zur Festlegung des \'Host Check Command\' in der gleichnamigen
Regel.](../images/intro_host_check_command.png)
:::
::::

::: paragraph
Stellen Sie im Kasten [Conditions]{.guihint} sicher, dass diese Regel
wirklich nur auf die passenden Hosts angewendet wird --- je nach der von
Ihnen gewählten Struktur. Sie können dazu z.B. ein Host-Merkmal
definieren und hier nutzen oder Sie können die Regel über einen Ordner
festlegen, in dem sich alle Drucker befinden.
:::

::: paragraph
Jetzt werden alle Drucker grundsätzlich als [UP]{.hstate0}
angezeigt --- egal, wie ihr Status tatsächlich ist.
:::

::: paragraph
Die Services des Druckers werden allerdings weiterhin geprüft und ein
Timeout würde zu einem [CRIT]{.state2} Zustand führen. Um auch dies zu
vermeiden, konfigurieren Sie für die betroffenen Hosts im Regelsatz
[Status of the Checkmk services]{.guihint} eine Regel, in der Sie
Timeouts und Verbindungsprobleme jeweils auf [OK]{.state0} setzen:
:::

:::: imageblock
::: content
![Dialog zur Festlegung des Zustands von \'Checkmk services\' in einer
Regel.](../images/intro_rule_status_of_cmk_services.png)
:::
::::
::::::::::::
:::::::::::::

:::::::::::: sect1
## []{#switchports .hidden-anchor .sr-only}9. Switch Ports konfigurieren {#heading_switchports}

::::::::::: sectionbody
::: paragraph
Wenn Sie mit Checkmk einen Switch überwachen, dann werden Sie
feststellen, dass bei der Service-Konfiguration automatisch für jeden
Port, der zu dem Zeitpunkt *up* ist, ein Service angelegt wird. Dies ist
eine sinnvolle Standardeinstellung für Core und Distribution
Switches --- also solche, an denen nur Infrastrukturgeräte oder Server
angeschlossen sind. Bei Switches, an denen Endgeräte wie Arbeitsplätze
oder Drucker angeschlossen sind, führt das aber einerseits zu ständigen
Benachrichtigungen, falls ein Port auf *down* geht, und andererseits zu
ständig neu gefundenen Services, weil ein bisher nicht überwachter Port
umgekehrt *up* geht.
:::

::: paragraph
Hier haben sich zwei Vorgehensweisen bewährt: So können Sie erstens die
Überwachung auf die Uplink-Ports beschränken. Dazu legen Sie eine Regel
bei den [deaktivierten Services](#services_disabled) an, welche die
anderen Ports von der Überwachung ausschließt.
:::

::: paragraph
Viel interessanter ist jedoch die zweite Methode: Hier überwachen Sie
zwar alle Ports, erlauben aber den Zustand *down* als gültigen Zustand.
Der Vorteil: Auch für Ports, an denen Endgeräte hängen, haben Sie eine
Überwachung der Übertragungsfehler und erkennen so sehr schnell
schlechte Patchkabel oder Fehler in der Autonegotiation. Um das
umzusetzen, benötigen Sie zwei Regeln:
:::

::: paragraph
Der erste Regelsatz [Network interface and switch port
discovery]{.guihint} legt fest, unter welchen Bedingungen Switch Ports
überwacht werden sollen. Legen Sie eine Regel für die gewünschten
Switches an und wählen Sie aus, ob einzelne Schnittstellen ([Configure
discovery of single interfaces]{.guihint}) oder Gruppen ([Configure
grouping of interfaces]{.guihint}) gefunden werden sollen. Aktivieren
Sie dann unter [Conditions for this rule to apply \> Specify matching
conditions \> Match port states]{.guihint} zusätzlich zu [1 -
up]{.guihint} auch [2 - down:]{.guihint}
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Überwachung von Switch Ports in einer
Regel.](../images/intro_rule_switch_port_discovery.png)
:::
::::

::: paragraph
In der Service-Konfiguration der Switches werden nun auch die Ports mit
dem Zustand *down* angeboten, und Sie können sie zur Liste der
überwachten Services hinzufügen.
:::

::: paragraph
Bevor Sie die Änderung aktivieren, benötigen Sie noch die zweite Regel,
die dafür sorgt, dass dieser Zustand als [OK]{.state0} gewertet wird.
Der Regelsatz heißt [Network interfaces and switch ports.]{.guihint}
Erstellen Sie eine neue Regel und aktivieren Sie die Option [Operational
state]{.guihint}, deaktivieren Sie darunter [Ignore the operational
state]{.guihint} und aktivieren Sie dann bei den [Allowed operational
states]{.guihint} die Zustände [1 - up]{.guihint} und [2 -
down]{.guihint} (und eventuell weitere Zustände).
:::
:::::::::::
::::::::::::

:::::::: sect1
## []{#services_disabled .hidden-anchor .sr-only}10. Services dauerhaft deaktivieren {#heading_services_disabled}

::::::: sectionbody
::: paragraph
Bei manchen Services, die einfach nicht zuverlässig auf [OK]{.state0} zu
bekommen sind, ist es am Ende besser, sie gar nicht zu überwachen. Hier
könnten Sie nun einfach bei den betroffenen Hosts in der
Service-Konfiguration (auf der Seite [Services of host]{.guihint}) die
Services manuell aus der Überwachung herausnehmen, indem Sie sie auf
[Disabled]{.guihint} oder [Undecided]{.guihint} setzen. Dies ist aber
umständlich und fehleranfällig.
:::

::: paragraph
Viel besser ist es, wenn Sie Regeln definieren, nach denen bestimmte
Services **systematisch** nicht überwacht werden. Dafür gibt es den
Regelsatz [Disabled services.]{.guihint} Hier können Sie z.B. eine Regel
anlegen und in der Bedingung festlegen, dass Dateisysteme mit dem
Mount-Punkt `/var/test/` grundsätzlich nicht überwacht werden sollen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie in der                   |
|                                   | Service-Konfiguration eines Hosts |
|                                   | einen einzelnen Service durch     |
|                                   | Klick auf [![Symbol zur           |
|                                   | Deaktivierung eines               |
|                                   | Ser                               |
|                                   | vices.](../images/icons/icon_move |
|                                   | _to_disabled.png)]{.image-inline} |
|                                   | deaktivieren, wird für den Host   |
|                                   | automatisch eine Regel in eben    |
|                                   | diesem Regelsatz angelegt. Diese  |
|                                   | Regel können Sie manuell          |
|                                   | bearbeiten und z.B. den           |
|                                   | expliziten Host-Namen entfernen.  |
|                                   | Dann wird der betroffene Service  |
|                                   | auf allen Hosts abgeschaltet.     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Weitere Informationen können Sie im [Artikel über die Konfiguration von
Services](wato_services.html#remove_unwanted_services) nachlesen.
:::
:::::::
::::::::

::::::::: sect1
## []{#average_value .hidden-anchor .sr-only}11. Durch Mittelwert Ausreißer abfangen {#heading_average_value}

:::::::: sectionbody
::: paragraph
Ein Grund für sporadische Benachrichtigungen sind oft Schwellwerte auf
Auslastungsmetriken, wie z.B. die CPU-Auslastung (*CPU utilization*),
die nur kurzfristig überschritten werden. In der Regel sind solche
kurzen Spitzen kein Problem und sollten vom Monitoring auch nicht
bemängelt werden.
:::

::: paragraph
Aus diesem Grund haben eine ganze Reihe von Check-Plugins in ihrer
Konfiguration die Möglichkeit, dass die Messwerte vor der Anwendung der
Schwellen über einen längeren Zeitraum gemittelt werden. Ein Beispiel
dafür ist der Regelsatz für die CPU-Auslastung für nicht-Unix-Systeme
mit dem Namen [CPU utilization for simple devices]{.guihint}. Hier gibt
es den Parameter [Averaging for total CPU utilization:]{.guihint}
:::

:::: imageblock
::: content
![Dialog zur Festlegung von Mittelwerten für die CPU-Auslastung in einer
Regel.](../images/intro_rule_cpu_util_average.png)
:::
::::

::: paragraph
Wenn Sie diesen aktivieren und `15` eintragen, wird die CPU-Auslastung
zunächst über einen Zeitraum von 15 Minuten gemittelt und die
Schwellwerte erst danach auf diesen Mittelwert angewendet.
:::
::::::::
:::::::::

::::::: sect1
## []{#sporadic_errors .hidden-anchor .sr-only}12. Sporadische Fehler kontrollieren {#heading_sporadic_errors}

:::::: sectionbody
::: paragraph
Wenn alles nichts hilft und Services immer wieder gelegentlich für einen
einzelnen Check (also für eine Minute) auf [WARN]{.state1} oder
[CRIT]{.state2} gehen, gibt es eine letzte Methode, die Fehlalarme
verhindert: den Regelsatz [Maximum number of check attempts for
service.]{.guihint}
:::

::: paragraph
Legen Sie dort eine Regel an und setzen Sie den Wert z.B. auf `3`, so
wird ein Service, der z.B. von [OK]{.state0} auf [WARN]{.state1} geht,
zunächst noch keine Benachrichtigungen auslösen und auch im
[[Overview]{.guihint}](intro_tools.html#overview) noch nicht als Problem
angezeigt werden. Der Zwischenzustand, in dem sich der Service befindet,
wird als „weicher Zustand" (*soft state*) bezeichnet. Erst wenn der
Zustand in drei aufeinanderfolgenden Checks (was insgesamt dann knapp
über zwei Minuten dauert) nicht [OK]{.state0} ist, wird das hartnäckige
Problem gemeldet. Nur ein harter Zustand (*hard state*) löst eine
Benachrichtigung aus.
:::

::: paragraph
Das ist zugegeben keine schöne Lösung. Sie sollten immer versuchen, das
Problem an der Wurzel zu packen, aber manchmal sind die Dinge einfach
so, wie sie sind, und mit der Anzahl der Check-Versuche haben Sie für
solche Fälle zumindest einen gangbaren Weg zur Umgehung.
:::
::::::
:::::::

::::::::::: sect1
## []{#discovery .hidden-anchor .sr-only}13. Liste der Services aktuell halten {#heading_discovery}

:::::::::: sectionbody
::: paragraph
In einem Rechenzentrum wird ständig gearbeitet, und so wird die Liste
der zu überwachenden Services nie konstant bleiben. Damit Sie dabei
möglichst nichts übersehen, richtet Checkmk für Sie automatisch einen
besonderen Service auf jedem Host ein. Dieser heißt [Check_MK
Discovery]{.guihint}:
:::

:::: imageblock
::: content
![Service-Liste mit dem Service \'Check_MK
Discovery\'.](../images/intro_service_discovery.png)
:::
::::

::: paragraph
Dieser prüft in der Voreinstellung alle zwei Stunden, ob neue (noch
nicht überwachte) Services gefunden oder bestehende weggefallen sind.
Ist dies der Fall, so geht der Service auf [WARN]{.state1}. Sie können
dann die Service-Konfiguration aufrufen (auf der Seite [Services of
host]{.guihint}) und die Liste der Services wieder auf den aktuellen
Stand bringen.
:::

::: paragraph
Detaillierte Informationen zu diesem *Discovery Check* erhalten Sie im
[Artikel über die Konfiguration von
Services](wato_services.html#discovery_check). Dort erfahren Sie auch,
wie Sie nicht überwachte Services automatisch hinzufügen lassen können,
was die Arbeit in großen Konfiguration erheblich erleichtert.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Über [Monitor \> System \>        |
|                                   | Unmonitored services]{.guihint}   |
|                                   | können Sie sich eine Ansicht      |
|                                   | aufrufen, die Ihnen die neuen und |
|                                   | weggefallenen Services anzeigt.   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
[Weiter geht es mit mehreren Benutzern](intro_users.html)
:::
::::::::::
:::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
