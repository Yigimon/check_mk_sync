:::: {#header}
# Strukturierung der Hosts

::: details
[Last modified on 25-Aug-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/hosts_structure.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Verwaltung der Hosts](hosts_setup.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::: sectionbody
::: paragraph
Checkmk bietet so einige Möglichkeiten, um Hosts zu organisieren:
Ordner, Host-Merkmale, Labels, Parents, Host-Gruppen. Manchmal ist die
Entscheidung aber nicht so einfach, welches Werkzeug für das konkrete
Problem am geeignetsten ist und einfach scheinende Fragen stellen sich
als komplizierter heraus, als gedacht: Warum gibt es eigentlich
Host-Merkmale *und* Labels? Welche Eigenschaften können Ordnern
zugewiesen werden und werden dann in der Ordnerstruktur vererbt? Wo
finde ich in einer Regel die Bedingung für Host-Gruppen? (Spoiler-Alarm:
Die gibt es nicht.)
:::

::: paragraph
Dieser Artikel gibt eine Übersicht über die verschiedenen
Strukturierungselemente in Checkmk und erläutert ihre Gemeinsamkeiten
und Unterschiede. Damit haben Sie dann alle Informationen zur Hand, um
die für Ihre Umgebung passende Struktur aufzusetzen. Wir wissen, dass
momentan noch Aspekte fehlen, die für dieses Thema wichtig sind. Wir
arbeiten daher immer wieder daran, diese Lücken nach und nach zu
stopfen.
:::

::: paragraph
Besonders interessant sind die Strukturierungselemente für die
[Konfigurationsumgebung](glossar.html#configuration_environment), die in
Regeln als Bedingungen ausgewählt werden können, also Ordner,
Host-Merkmale und Labels. Damit können Sie regelbasiert auf Ihre
Struktur zugreifen und zum Beispiel (neue) Hosts automatisch in die für
sie vorgesehenen Ordner sortieren. Zusätzlich erfahren Sie für jedes der
vorgestellten Strukturierungselemente, wie Sie es in der
[Monitoring-Umgebung](glossar.html#monitoring_environment) nutzen
können.
:::

::: paragraph
Am [Ende des Artikel](#summary) werden schließlich die wichtigen
Eigenschaften der Strukturierungselemente in einer Tabelle
zusammengefasst.
:::
:::::::
::::::::

::::::::::::::::::::: sect1
## []{#folder .hidden-anchor .sr-only}2. Ordner und Vererbung {#heading_folder}

:::::::::::::::::::: sectionbody
:::::::: sect2
### []{#folder_structure .hidden-anchor .sr-only}2.1. Mit Ordnern strukturieren {#heading_folder_structure}

::: paragraph
Jeder, der mit Computern arbeitet, ist mit Dateien und Ordnern vertraut.
In Checkmk wird dieses bekannte Prinzip für die Strukturierung von Hosts
übernommen, die in Ordnern gespeichert sind. Vordefiniert ist mit dem
Ordner [Main]{.guihint} nur die Wurzel des Ordnerbaums. Unterhalb dieses
Hauptordners können Sie Ihre eigene Ordnerstruktur mit beliebig vielen
Unterordnern als Host-Baum erstellen. Übliche Kriterien für den Aufbau
des Host-Baums sind Standort, Technologie und Organisationsstruktur. Im
Hauptordner [Main]{.guihint} landen Sie, wenn Sie [Setup \> Hosts \>
Hosts]{.guihint} auswählen.
:::

::: paragraph
Über Ordner können Attribute an Unterordner und enthaltene Hosts
**vererbt** werden. Wie die Vererbung genau abläuft, erfahren Sie im
Artikel über die [Verwaltung der Hosts.](hosts_setup.html#inheritance)
Vererbt werden die Ordnerattribute, d.h. die Ordnereigenschaften, die im
[Setup]{.guihint} auf der Seite [Folder properties]{.guihint} angezeigt
werden wie z.B. Monitoring-Agenten und Permissions --- aber auch andere
Strukturierungselemente wie Host-Merkmale, Labels oder Parents. Viele
der Ordnereigenschaften finden Sie auch bei den Host-Eigenschaften auf
der Seite [Properties of host.]{.guihint} Die Vererbung ist besonders
nützlich für Attribute, die bei vielen Hosts gleich sind, z.B. ob der
Host per Checkmk-Agent oder per SNMP überwacht werden soll. Ein weiterer
Vorteil der Vererbung von Ordnerattributen ist, dass Sie Ordner für die
Aufnahme von Hosts vorbereiten können, die erst in Zukunft hinzukommen
werden. Einfach den neuen Host in den richtigen Ordner werfen und alle
vordefinierten Attribute stimmen automatisch.
:::

::: paragraph
Um die Vorteile der Vererbung voll auszunutzen, hat es sich bewährt, als
Erstes ein Ordnungssystem zu überlegen und dieses danach mit Inhalt zu
füllen. Sie beschäftigen sich also erst mit dem Aufbau der Ordner und
ihrer Hierarchie. Danach sortieren Sie die Hosts ein.
:::

::: paragraph
Das ist umso wichtiger, je größer die Umgebung ist, und je zahlreicher
die Hosts sind. Zwar kann eine einmal aufgesetzte Ordnerstruktur auch
nachträglich geändert und etwa Ordner problemlos umbenannt werden.
Allerdings ist dabei Vorsicht geboten: Das Verschieben eines Hosts in
einen anderen Ordner kann nämlich zur Folge haben, dass sich dessen
Attribute ändern, ohne dass Sie sich dessen vielleicht bewusst sind,
weil der Zielordner andere Attribute haben kann als der Quellordner.
:::

::: paragraph
Eine Ordnerstruktur alleine kann aber nur in seltenen Fällen die
Komplexität der Wirklichkeit abbilden. Wenn Sie Ihre Hosts nach *vielen
unterschiedlichen Kriterien* organisieren wollen (oder müssen), dann
bieten sich als Ergänzung die Host-Merkmale an, die im [nächsten
Kapitel](#host_tags) beschrieben werden.
:::
::::::::

::::::::::::: sect2
### []{#folder_monitoring .hidden-anchor .sr-only}2.2. Die Ordnerstruktur im Monitoring {#heading_folder_monitoring}

::: paragraph
Die Baumstruktur, die sich durch die Ordner ergibt, ist auch in der
[Monitoring-Umgebung](glossar.html#monitoring_environment)
sichtbar --- allerdings erst dann, wenn ein Ordner mindestens einen Host
enthält.
:::

### Filterleiste {#filter_bar .discrete}

::: paragraph
Zum einen gibt es in in der Filterleiste der
[Tabellenansichten](glossar.html#view) den Filter [Folder]{.guihint},
mit dem Sie die aktuelle Ansicht auf die Hosts unterhalb von einem
bestimmten Ordner einschränken können.
:::

::: paragraph
Wie das folgende Bild zeigt, gibt es weitere Filter auch für andere
Strukturierungselemente wie Host-Merkmale, Labels und Host-Gruppen.
:::

::::: imageblock
::: content
![Tabellenansicht mit Filterleiste und ausgewählten Filtern für
Strukturierungselemente.](../images/hosts_filterbar.png){width="60%"}
:::

::: title
In der Filterleiste haben Sie Zugriff auf diverse
Strukturierungselemente
:::
:::::

### Tree of folders {#tree_of_folders .discrete}

::: paragraph
Zum zweiten bietet in der [Seitenleiste](user_interface.html#sidebar)
das Snapin [Tree of folders]{.guihint} die gleiche Auswahlmöglichkeit
wie das [Monitor-Menü](user_interface.html#monitor_menu), aber kann
zusätzlich noch die Anzeige auf einen Ordner einschränken:
:::

::::: imageblock
::: content
![Snapin Tree of
folders.](../images/hosts_treeoffolders_snapin.png){width="50%"}
:::

::: title
Das Snapin [Tree of folders]{.guihint} zeigt ganz unten die
Ordnerstruktur an
:::
:::::
:::::::::::::
::::::::::::::::::::
:::::::::::::::::::::

::::::::::::::::: sect1
## []{#host_tags .hidden-anchor .sr-only}3. Host-Merkmale {#heading_host_tags}

:::::::::::::::: sectionbody
::: paragraph
Host-Merkmale (englisch: *host tags*) sind in diesem Handbuch im
[Leitfaden für Einsteiger](intro_finetune.html#host_tags) und in einem
[eigenen Artikel](host_tags.html) ausführlich beschrieben. Daher an
dieser Stelle nur das Wichtigste in Kürze:
:::

::: paragraph
Ein Host-Merkmal ist ein Attribut, das einem Host zugewiesen wird.
Host-Merkmale sind in Gruppen organisiert, den sogenannten
Host-Merkmalsgruppen (englisch: *host tag groups*). Mit der Erstellung
einer Host-Merkmalsgruppe werden alle Merkmale dieser Gruppe vollständig
definiert. Die Merkmale einer Gruppe schließen sich gegenseitig aus,
d.h. jeder Host erhält genau ein Merkmal aus der Gruppe. Wenn Sie nichts
anderes festgelegt haben, ist dies das erste Merkmal der Gruppe, das als
Standardwert dient.
:::

::: paragraph
Verfeinerungen dieses generellen Konzepts sind die
[Checkbox-Merkmale](host_tags.html#checkbox_tag) und die
[Hilfsmerkmale.](host_tags.html#aux_tag) Ein Checkbox-Merkmal ist eine
spezielle Host-Merkmalsgruppe mit nur einem Element und dient der
Ja-/Nein-Entscheidung der Art: „Auf diesem Host läuft Oracle." Mit
Hilfsmerkmalen (*auxiliary tags*) können Sie verschiedene Merkmale einer
Gruppe zusammenfassen, z. B. die Merkmale `Windows Server 2012 R2` und
`Windows Server 2016` zum Hilfsmerkmal `Windows`.
:::

::::::::: sect2
### []{#host_tags_structure .hidden-anchor .sr-only}3.1. Mit Host-Merkmalen strukturieren {#heading_host_tags_structure}

::: paragraph
Host-Merkmale haben Eigenschaften, die Labels **und** Ordnern ähneln.
:::

::: paragraph
Ein Merkmal oder ein Label einem Host zuzuordnen ist im Ergebnis sehr
ähnlich. Das zugewiesene Kennzeichen können Sie in beiden Fällen in der
Konfiguration nutzen, um Bedingungen in Regeln festzulegen. Allerdings
müssen Sie, bevor Sie ein Host-Merkmal vergeben können, die zugehörige
*Host-Merkmalsgruppe* definieren --- sich also Gedanken um alle
möglichen Ausprägungen eines solchen Merkmals machen.
:::

::: paragraph
Die *Abgeschlossenheit* einer Host-Merkmalsgruppe erinnert daher an das
Aufsetzen der [Ordnerstruktur.](#folder_structure) Genauso, wie ein Host
nur in einem Ordner abgelegt werden kann, kann er auch nur ein Merkmal
einer Host-Merkmalsgruppe tragen. Anders herum: Ein Host ist immer einem
Ordner zugeordnet und hat stets ein Merkmal einer Host-Merkmalsgruppe
(wenn wir mal kurz die Checkbox-Merkmale außen vor lassen). Daher eignen
sich Host-Merkmale für Eigenschaften, die immer da sind (oder zumindest
sein sollen) und in der Regel durch den Checkmk-Administrator für das
gesamte zu überwachende System und für alle Checkmk-Benutzer vorgegeben
werden.
:::

::: paragraph
Wie für die Ordnerstruktur gilt: Für die Konfiguration großer Umgebungen
ist es sehr hilfreich, von Beginn an eine wohlüberlegte Struktur der
Host-Merkmale aufzusetzen.
:::

::: paragraph
Einem Host ordnen Sie Merkmale zu in den Host-Eigenschaften auf der
Seite [Properties of host]{.guihint} --- beim Erstellen oder Bearbeiten
eines Hosts. Viele Attribute finden Sie sowohl in den Eigenschaften
eines Hosts als auch in den Ordnereigenschaften wieder --- und genau das
trifft auch auf die Host-Merkmale zu. Das heißt, Host-Merkmale sind
nicht nur für Hosts sondern auch für Ordner gültig. Und damit werden
auch Host-Merkmale über die Ordnerstruktur in Checkmk vererbt. Um zu
verhindern, dass es bei der Vererbung zu ungewollten Überraschungen
kommt, sollten Sie bei der Festlegung der Host-Merkmalsgruppe auf den
Standardwert achten. In der Regel ist es sinnvoll, hier einen neutralen
Wert festzulegen wie `None` oder `not applicable`.
:::

::: paragraph
Nachträgliche [Änderungen](host_tags.html#edit_delete_tag) einmal
eingerichteter Host-Merkmale sind möglich, sollten aber vermieden
werden --- sofern es sich um die Umbenennung der ID eines Merkmals
handelt, da dies in den meisten Fällen manuelle Nacharbeit erfordert.
Änderungen, die lediglich die Anzeige betreffen oder nur neue
Auswahlmöglichkeiten hinzufügen, sind dagegen unproblematisch und haben
keine Auswirkung auf die bestehenden Hosts und Regeln.
:::
:::::::::

::::: sect2
### []{#host_tags_monitoring .hidden-anchor .sr-only}3.2. Die Host-Merkmale im Monitoring {#heading_host_tags_monitoring}

::: paragraph
Host-Merkmale sind nicht nur bei der Konfiguration, sondern auch im
Monitoring nützlich. Zum Beispiel gibt es in der Filterleiste von
Tabellenansichten auch Filter für Host-Merkmale, wie es der Screenshot
im Kapitel zu [Ordnern](#filter_bar) zeigt.
:::

::: paragraph
Darüber hinaus bietet Ihnen in der Seitenleiste das
[Snapin](glossar.html#snapin) [Virtual host tree]{.guihint} die
Möglichkeit eine „virtuelle" Hierarchie aus Host-Merkmalen abzubilden.
Im Artikel zu den [Host-Merkmalen](host_tags.html#tags_in_monitoring)
erfahren Sie, wie das geht.
:::
:::::
::::::::::::::::
:::::::::::::::::

::::::::::::::::: sect1
## []{#labels .hidden-anchor .sr-only}4. Labels {#heading_labels}

:::::::::::::::: sectionbody
::: paragraph
Labels sind Attribute, die einem Host zugewiesen werden und
damit --- genau wie Host-Merkmale --- Kennzeichen für einen Host. Die
ausführliche Einleitung des Artikels zu den [Labels](labels.html)
erklärt daher das Konzept der Labels im Vergleich und in Abgrenzung zu
den Host-Merkmalen. An dieser Stelle können wir uns auf das Wesentliche
der Labels beschränken:
:::

::: paragraph
Labels sind einfache Schlüssel-Wert-Paare, wie z.B. `os:linux`,
`os:windows` oder `foo:bar`, die nirgendwo vordefiniert sind. Bei der
Festlegung der Labels gibt es (fast) keine Einschränkungen --- bis auf
die folgenden: Schlüssel und Wert müssen durch Doppelpunkt getrennt
sein. Ein Host kann beliebig viele Labels haben, aber pro Schlüssel nur
einen Wert. Also kann ein Host, der das Label `foo:bar` hat, nicht
gleichzeitig `foo:bar2` haben.
:::

::: paragraph
Übrigens können in Checkmk nicht nur Hosts sondern auch Services Labels
tragen. Allerdings gibt es bei den Service-Labels einige Besonderheiten
zu beachten, die im Artikel zu den [Labels](labels.html#service_labels)
beschrieben sind.
:::

:::::::::: sect2
### []{#labels_structure .hidden-anchor .sr-only}4.1. Mit Labels strukturieren {#heading_labels_structure}

::: paragraph
Wenn die Label erstmal gesetzt sind, dann haben Sie mit Ihnen die
gleichen Möglichkeiten, die Ihnen auch Ordner und Host-Merkmale bieten:
Während der Konfiguration können Sie die Bedingungen der Regeln in
Abhängigkeit der Labels definieren.
:::

::: paragraph
Während bei den Host-Merkmalen bereits durch die Definition der
Host-Merkmalsgruppe alle Hosts mit einem Host-Merkmal versorgt werden,
läuft die Zuweisung bei Labels anders. Labels können
[explizit](labels.html#explicit), über [Regeln](labels.html#rules) und
[automatisch](labels.html#automatic) gesetzt werden. Die
unterschiedlichen Wege, über die Hosts an ihre Labels kommen können,
sollten Sie beachten, wenn es darum geht, wie Sie Labels für die
Strukturierung Ihrer Hosts nutzen können.
:::

::: paragraph
Die explizite Zuweisung von Labels erfolgt in den Eigenschaften eines
Hosts, im Kasten [Custom attributes]{.guihint}: Schlüssel-Wert-Paar
eingeben, Enter-Taste drücken: Fertig! Auch in den Eigenschaften von
Ordnern können Labels gesetzt werden, die dann über die Ordnerstruktur
in Checkmk vererbt werden.
:::

::: paragraph
Wenn Sie für ein Label eigentlich keinen Wert brauchen, sondern nur
wissen wollen, ob an dem Host ein bestimmtes Label hängt oder nicht,
vergeben Sie z.B. einfach `yes` als Wert (`vm:yes`). Falls Sie dieses
Schema konsequent einhalten, haben Sie es später leichter, für solche
Labels Bedingungen zu definieren.
:::

::: paragraph
Die explizite Zuweisung ist sehr einfach, hat aber ihre Tücken, denn die
Gefahr von Inkonsistenzen durch Schreibfehler ist groß. Da Labels frei
vergeben werden können, kann Checkmk auch nicht überprüfen ob `foo:Bar`,
`Foo:bar` oder `Fu:baa` das „richtige" Label ist. Sie sollten sich daher
auch überlegen, wie Sie es mit der Groß-/Kleinschreibung halten. Denn
wenn Sie später Bedingungen über Labels definieren, dann muss die
Schreibweise sowohl beim Schlüssel als auch beim Wert strikt beachtet
werden.
:::

::: paragraph
Es liegt daher nahe, für die Strukturierung von Hosts auf die explizite
Zuweisung zu verzichten und Labels regelbasiert oder automatisch
erstellen zu lassen.
:::

::: paragraph
Wenn sich Host-Merkmale für globale Eigenschaften eignen, die immer da
sind und in der Regel durch den Checkmk-Administrator für das gesamte zu
überwachende System und für alle Checkmk-Benutzer vorgegeben werden,
dann können einzelne Checkmk-Benutzer die spezifischen Anforderungen in
ihrem Verantwortungsbereich mit Labels umsetzen. Für eine überschaubare
lokale Struktur können die Labels die Lücken füllen, die von der
globalen Administration freigelassen wurden, und dabei ihre Vorteile
ausspielen: Sie sind schnell und einfach erstellt --- und auch wieder
gelöscht.
:::
::::::::::

:::: sect2
### []{#labels_monitoring .hidden-anchor .sr-only}4.2. Die Labels im Monitoring {#heading_labels_monitoring}

::: paragraph
Die vollständige Übersicht aller Labels eines Hosts erhalten Sie in der
Monitoring-Umgebung, in der Statusansicht eines Hosts. In der
Filterleiste von Tabellenansichten haben Sie Zugriff auf alle
Host-Labels --- und können diese sogar mit den booleschen Operatoren
`Not`, `And` und `Or` zum Filtern kombinieren. Beide Wege sind im
Artikel zu den [Labels](labels.html#views) beschrieben.
:::
::::
::::::::::::::::
:::::::::::::::::

:::::::::::::::::::::::::::::::::::: sect1
## []{#parents .hidden-anchor .sr-only}5. Parents {#heading_parents}

::::::::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#parents_structure .hidden-anchor .sr-only}5.1. Mit Parents strukturieren {#heading_parents_structure}

::: paragraph
Was Parents sind, und wie sie funktionieren, haben Sie bereits in den
[Grundlagen des Monitorings](monitoring_basics.html#parents) erfahren.
:::
::::

::::::::: sect2
### []{#parents_create_manual .hidden-anchor .sr-only}5.2. Parents manuell anlegen {#heading_parents_create_manual}

::: paragraph
Einen Parent für einen einzelnen Host legen Sie so fest: Wählen Sie
[Setup \> Hosts \> Hosts]{.guihint} und klicken Sie den gewünschten Host
an, um seine Eigenschaften anzuzeigen. Im Kasten [Basic
settings]{.guihint} tragen Sie den Parent über seinen Namen oder die
IP-Adresse ein. Sobald ein Parent angegeben wird, erscheint ein weiteres
Eingabefeld für einen zusätzlichen Parent:
:::

::::: imageblock
::: content
![Dialog mit den Eigenschaften eines Hosts zur Festlegung der
Parents.](../images/hosts_properties_parents.png)
:::

::: title
Bei der manuellen Zuweisung können auch mehrere Parents angegeben werden
:::
:::::

::: paragraph
**Wichtig**: Geben Sie nur direkte Parent-Hosts ein.
:::

::: paragraph
Analog lassen sich Parents auch in den Eigenschaften von Ordnern
festlegen und auf die beinhalteten Hosts vererben, wie es im obigen
Kapitel über [Ordner und Vererbung](#folder) steht.
:::
:::::::::

::::::::::::::::::: sect2
### []{#parents_scan .hidden-anchor .sr-only}5.3. Parents per Scan anlegen lassen {#heading_parents_scan}

::: paragraph
Wenn Sie Ihr Monitoring frisch aufsetzen und von vorne herein sauber mit
Ordnern und Parents planen, werden Sie mit der Parent-Vererbung über
Ordner vermutlich gut zurecht kommen. Sie können Parents aber auch über
den [Parent scan]{.guihint} automatisch einrichten lassen.
:::

::: paragraph
Der Scan sucht über das IP-Protokoll auf dem Network Layer des
OSI-Modells (Schicht 3) via `traceroute` nach dem letzten Gateway vor
einem Host. Wird ein solches Gateway gefunden und gehört dessen Adresse
zu einem Ihrer überwachten Hosts, so wird dieser als Parent gesetzt.
Bekommt `traceroute` von den *Hops* vor dem anvisierten Host keine
Informationen, so wird der letzte erfolgreiche Hop verwendet.
:::

::: paragraph
Wird jedoch kein Gateway unter den überwachten Hosts gefunden, legt
Checkmk per Default einen künstlichen „Ping-only-Host" an, standardmäßig
im Ordner [Parents]{.guihint}, der gleich mit erstellt wird.
:::

::: paragraph
Diese Standardeinstellung kann allerdings auch zu unerwünschten
Ergebnissen führen: Nehmen wir als Beispiel ein typisches, kleines
Netzwerk mit dem Adressbereich *192.168.178.0/24.* Wird in das
Monitoring nun ein Host mit einer Adresse aus einem anderen
Adressbereich aufgenommen, der nicht angepingt werden kann, so versucht
der Scan den Weg über den Router --- und findet dort nur den Knotenpunkt
des Netz-Providers. Und so könnte dann zum Beispiel ein Telekom-Server
aus dem WAN-Bereich als Parent für diesen Host gesetzt werden. Um dies
zu vermeiden, können Sie die entsprechende Option vor dem Scan
deaktivieren.
:::

::: paragraph
Wenn Sie einen Ordner mit neuen Hosts auf Parents scannen wollen, gehen
Sie wie folgt vor: Öffnen Sie zunächst den gewünschten Ordner und wählen
Sie im Menü [Hosts \> Detect network parent hosts]{.guihint}, um die
Scan-Konfiguration zu öffnen. Sie können übrigens auch, statt eines
ganzen Ordners, nur eine Auswahl von Hosts scannen lassen, indem Sie
diese vorher in der ersten Spalte der Liste auswählen.
:::

::::: imageblock
::: content
![Dialog mit der Scan-Konfiguration für die
Parents.](../images/hosts_parent_scan.png)
:::

::: title
Der Scan bietet reichlich Optionen zur Konfiguration
:::
:::::

::: paragraph
Um alle Hosts in allen Unterordnern komplett neu einzuscannen,
unabhängig von eventuell manuell gesetzten Parents, wählen Sie die
Optionen [Include all subfolders]{.guihint} und [Scan all
hosts]{.guihint}. Im Bereich [Performance]{.guihint} können Sie die
Scan-Dauer anpassen, die bei vielen Hosts recht lang ausfallen kann.
:::

::: paragraph
Unter [Creation of gateway hosts]{.guihint} bestimmen Sie, ob, wie und
unter welchem Alias neu gefundene Parent-Hosts erzeugt werden.
Deaktivieren Sie die Funktion, wenn Sie Parents auf überwachte Hosts
beschränken wollen.
:::

::: paragraph
Klicken Sie nun auf [Start]{.guihint}. Die Ausgabe des Scans können Sie
live mitverfolgen.
:::

::: paragraph
Anschließend sehen Sie die konfigurierten Parents sowie gegebenenfalls
einen neuen Ordner [Parents]{.guihint} in [Main]{.guihint} (falls Sie
dies vor dem Scan so angegeben haben).
:::

::::: imageblock
::: content
![Liste der Hosts mit Anzeige der
Parents.](../images/hosts_parents_list.png)
:::

::: title
Im [Setup]{.guihint} werden die Parents in einer eigenen Spalte
angezeigt
:::
:::::

::: paragraph
Damit ist der Scan abgeschlossen.
:::
:::::::::::::::::::

:::::::: sect2
### []{#parents_monitoring .hidden-anchor .sr-only}5.4. Parents im Monitoring {#heading_parents_monitoring}

::: paragraph
Nach einem durchgeführten Scan und der Aktivierung der Änderungen werden
die Parent-Child-Beziehungen als Topologie-Karte visualisiert, die Sie
über [Monitor \> Overview \> Parent / Child topology]{.guihint} aufrufen
können:
:::

::::: imageblock
::: content
![Aus den Parent-Child-Beziehungen umgesetzte
Netztopologie.](../images/hosts_parents_topology.png){width="55%"}
:::

::: title
Anzeige der Parent-Child-Beziehungen im Monitoring
:::
:::::

::: paragraph
**Tipp:** Wenn die Ergebnisse des Scans an einigen Stellen nicht
plausibel erscheinen, ist ein manueller Aufruf von `traceroute`
bisweilen hilfreich, um die einzelnen Hops nachzuvollziehen.
:::
::::::::
:::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::: sect1
## []{#host_groups .hidden-anchor .sr-only}6. Host-Gruppen {#heading_host_groups}

:::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Mit Host-Gruppen können Sie eine Reihe von Hosts zusammenfassen, um
diese im Monitoring anzeigen zu lassen. So können Sie zum Beispiel alle
Linux-, Windows- und bestimmte Application-Server gemeinsam betrachten,
indem Sie für diese Server-Typen jeweils eine Host-Gruppe einrichten.
:::

::: paragraph
Eine Host-Gruppe wird über eine Regel befüllt. In der Bedingung dieser
Regel können Sie, wie gewohnt, auf Ordner, Host-Merkmale und Labels
zugreifen. Host-Gruppen selbst tauchen **nicht** standardmäßig als
Auswahlkriterien in Regeln auf, denn sie dienen nicht der Konfiguration,
sondern den Ansichten.
:::

:::::::: sect2
### []{#host_groups_create .hidden-anchor .sr-only}6.1. Host-Gruppe erstellen {#heading_host_groups_create}

::: paragraph
Sie finden die Host-Gruppen unter [Setup \> Hosts \> Host
groups.]{.guihint}
:::

::: paragraph
Eine neue Host-Gruppe legen Sie über den Aktionsknopf [Add
group]{.guihint} an. Das Anlegen ist trivial und beschränkt sich auf die
Vergabe eines eindeutigen Namens, der später nicht mehr geändert werden
kann, und eines Alias:
:::

::::: imageblock
::: content
![Dialog mit Eigenschaften einer
Host-Gruppe.](../images/hosts_hostgroups_properties.png)
:::

::: title
Mit Name und Alias ist die Host-Gruppe fertig konfiguriert
:::
:::::
::::::::

:::::::::::::: sect2
### []{#host_groups_include_hosts .hidden-anchor .sr-only}6.2. Hosts in Host-Gruppe aufnehmen {#heading_host_groups_include_hosts}

::: paragraph
Um Hosts in Host-Gruppen aufzunehmen, bemühen Sie den
[Regelsatz](glossar.html#rule_set) [Assignment of hosts to host
groups]{.guihint}, den Sie unter [Setup \> Hosts \> Host monitoring
rules]{.guihint} finden. Legen Sie eine neue Regel an.
:::

::: paragraph
Zunächst wählen Sie im Kasten [Assignment of hosts to host
groups]{.guihint} die Host-Gruppe aus, der Hosts zugeordnet werden
sollen, im Beispiel etwa der Gruppe `My Linux servers`:
:::

::::: imageblock
::: content
![Dialog zur Auswahl der Host-Gruppe in einer
Regel.](../images/hosts_hostgroups_rule_assignment.png)
:::

::: title
Zur Auswahl werden die bereits erstellten Host-Gruppen angeboten
:::
:::::

::: paragraph
Anschließend kümmern Sie sich im Kasten [Conditions]{.guihint} um den
oder *die* Filter, um die Gruppe einzuschränken --- denn Filter lassen
sich natürlich auch kombinieren. Sie können Hosts nach Ordnern,
Host-Merkmalen und Host-Labels filtern oder spezifische Hosts angeben.
Möchten Sie Hosts mit zwei Merkmalen aus ein und derselben
Host-Merkmalsgruppe in die Host-Gruppe aufnehmen, müssen Sie zwei
separate Regeln anlegen. Generell sind die Gruppenzuordnungen kumulativ.
Hosts können in mehreren Gruppen sein und Gruppen von mehreren Regeln
gefüllt werden.
:::

::: paragraph
Im folgenden Beispiel nutzen wir das von Checkmk automatisch zugewiesene
Host-Label `cmk/os_family:linux`, um die Linux-Server der Host-Gruppe
hinzuzufügen:
:::

::::: imageblock
::: content
![Dialog zur Festlegung der Bedingungen für die Zuweisung zur
Host-Gruppe.](../images/hosts_hostgroups_rule_conditions.png)
:::

::: title
Für die Festlegung der Bedingung werden u.a. Ordner, Host-Merkmale und
Host-Labels angeboten
:::
:::::

::: paragraph
Wie üblich, müssen Sie die Änderungen anschließend noch aktivieren.
:::
::::::::::::::

::::::::::::::::::: sect2
### []{#host_groups_monitoring .hidden-anchor .sr-only}6.3. Host-Gruppen im Monitoring {#heading_host_groups_monitoring}

#### Übersicht der Host-Gruppen {#_übersicht_der_host_gruppen .discrete}

::: paragraph
Das Ergebnis Ihrer Zuordnungen im [Setup]{.guihint} können Sie
komfortabel im Monitoring überprüfen. Unter [Monitor \> Overview \> Host
groups]{.guihint} werden Ihnen die existierenden Host-Gruppen
aufgelistet:
:::

::::: imageblock
::: content
![Tabellenansicht der
Host-Gruppen.](../images/hosts_hostgroups_view.png)
:::

::: title
Host-Gruppen im Monitoring
:::
:::::

::: paragraph
Über einen Klick auf den Namen einer Host-Gruppe gelangen Sie zur
vollständigen Ansicht der Hosts dieser Gruppe.
:::

::: paragraph
Abseits dieser Übersicht können Sie Host-Gruppen an mehreren Stellen
einsetzen: zur Erstellung von Tabellenansichten und NagVis-Karten sowie
als Filter in Regeln für Benachrichtigungen und Alert Handlers.
:::

#### Tabellenansichten {#_tabellenansichten .discrete}

::: paragraph
Wichtig bei der Erstellung von [Tabellenansichten](glossar.html#view)
(über [Customize \> Visualization \> Views]{.guihint}) ist lediglich die
Auswahl einer Datenquelle ([Datasource]{.guihint}), die Host-Gruppen
nutzt, z.B. [Host groups.]{.guihint}
:::

::: paragraph
Im [Monitor]{.guihint}-Menü finden Sie freilich bereits fertige
Ansichten, beispielsweise [Host groups]{.guihint}, die wir bereits im
vorherigen Abschnitt gezeigt haben.
:::

#### NagVis-Karten {#_nagvis_karten .discrete}

::: paragraph
Auf [NagVis-Karten](nagvis.html) können Sie mit dem Snapin [NagVis
maps]{.guihint} der [Seitenleiste](user_interface.html#sidebar)
zugreifen. In einer NagVis-Karte bekommen Sie als Ergebnis
beispielsweise die Zusammenfassung für eine Host-Gruppe per Hover-Menü
über ein einzelnes Symbol:
:::

::::: imageblock
::: content
![Anzeige einer Host-Gruppe in einer
NagVis-Karte.](../images/hosts_hostgroups_nagvis.png)
:::

::: title
Zu den NagVis-Karten geht es über das Snapin [NagVis maps]{.guihint} der
Seitenleiste
:::
:::::

#### Benachrichtigungen und Alert Handlers {#_benachrichtigungen_und_alert_handlers .discrete}

::: paragraph
In den [Regelsätzen](glossar.html#rule_set) für
[Benachrichtigungen](glossar.html#notification) und [Alert
Handlers](alert_handlers.html) werden Ihnen die Host-Gruppen als Filter
in den Bedingungen ([Conditions]{.guihint}) angeboten:
:::

::::: imageblock
::: content
![Dialog zur Auswahl von Host-Gruppen in einer
Benachrichtigungsregel.](../images/hosts_hostgroups_notifications_rule.png)
:::

::: title
Auswahl der Host-Gruppen in der Bedingung einer Benachrichtigungsregel
:::
:::::
:::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::

::::: sect1
## []{#summary .hidden-anchor .sr-only}7. Zusammenfassung {#heading_summary}

:::: sectionbody
::: paragraph
Zur Verbesserung der Übersichtlichkeit zeigt die folgende Tabelle
wichtige Eigenschaften der in diesem Artikel vorgestellten
Strukturierungselemente.
:::

+------------+------------+------------+-------+-------+------------+
| St         | Erstellung | Hinzufügen | Bedi  | Vere  | Si         |
| rukturieru |            | von Hosts  | ngung | rbung | chtbarkeit |
| ngselement |            |            | in    | über  | im         |
|            |            |            | R     | O     | Monitoring |
|            |            |            | egeln | rdner |            |
+============+============+============+=======+=======+============+
| Ordner     | Manuell im | Manuell im | Ja    |  ---  | Snapin     |
|            | Setup      | Setup      |       |       | [Tree of   |
|            | ([Setup \> | ([Setup \> |       |       | folders]{  |
|            | Hosts \>   | Hosts \>   |       |       | .guihint}, |
|            | Hosts]{    | Hosts]{    |       |       | Filter in  |
|            | .guihint}) | .guihint}) |       |       | Tabelle    |
|            |            |            |       |       | nansichten |
+------------+------------+------------+-------+-------+------------+
| Hos        | Manuell im | A          | Ja    | Ja    | Snapin     |
| t-Merkmale | Setup      | utomatisch |       |       | [Virtual   |
|            | ([Setup \> | durch      |       |       | host       |
|            | Hosts \>   | Festlegung |       |       | tree]{     |
|            | Tags]{     | der        |       |       | .guihint}, |
|            | .guihint}) | Host-Merk  |       |       | Filter in  |
|            | durch      | malsgruppe |       |       | Tabelle    |
|            | Festlegung |            |       |       | nansichten |
|            | der        |            |       |       |            |
|            | Host-Merk  |            |       |       |            |
|            | malsgruppe |            |       |       |            |
+------------+------------+------------+-------+-------+------------+
| Labels     | Manuel     |  --- (Ein  | Ja    | Ja    | Sta        |
|            | l/explizit | Label wird |       |       | tusansicht |
|            | im Setup   | stets für  |       |       | eines      |
|            | ([         | einen Host |       |       | Hosts      |
|            | Properties | erstellt.) |       |       | ([Status   |
|            | of         |            |       |       | of         |
|            | host]{.    |            |       |       | Host]{.    |
|            | guihint}), |            |       |       | guihint}), |
|            | per Regel  |            |       |       | Filter in  |
|            | ([Host     |            |       |       | Tabelle    |
|            | labels]{   |            |       |       | nansichten |
|            | .guihint}) |            |       |       |            |
|            | oder       |            |       |       |            |
|            | a          |            |       |       |            |
|            | utomatisch |            |       |       |            |
+------------+------------+------------+-------+-------+------------+
| Parents    | Manuell im |  --- (Ein  | Nein  | Ja    | Topol      |
|            | Setup      | Parent     |       |       | ogie-Karte |
|            | ([         | wird stets |       |       | ([Monitor  |
|            | Properties | für einen  |       |       | \>         |
|            | of         | Host       |       |       | Overview   |
|            | host]{     | erstellt.) |       |       | \> Parent  |
|            | .guihint}) |            |       |       | / Child    |
|            | oder       |            |       |       | topology]{ |
|            | a          |            |       |       | .guihint}) |
|            | utomatisch |            |       |       |            |
|            | per Scan   |            |       |       |            |
|            | in einem   |            |       |       |            |
|            | Ordner     |            |       |       |            |
|            | ([Hosts \> |            |       |       |            |
|            | Detect     |            |       |       |            |
|            | network    |            |       |       |            |
|            | parent     |            |       |       |            |
|            | hosts]{    |            |       |       |            |
|            | .guihint}) |            |       |       |            |
+------------+------------+------------+-------+-------+------------+
| Ho         | Manuell im | Per Regel  | Nein  | Nein  | Als eigene |
| st-Gruppen | Setup      | ([         |       |       | Ansicht    |
|            | ([Setup \> | Assignment |       |       | ([Monitor  |
|            | Hosts \>   | of hosts   |       |       | \>         |
|            | Host       | to host    |       |       | Overview   |
|            | groups]{   | groups]{   |       |       | \> Host    |
|            | .guihint}) | .guihint}) |       |       | groups]{.  |
|            |            |            |       |       | guihint}), |
|            |            |            |       |       | Filter in  |
|            |            |            |       |       | Tabellen   |
|            |            |            |       |       | ansichten, |
|            |            |            |       |       | auf        |
|            |            |            |       |       | NagV       |
|            |            |            |       |       | is-Karten, |
|            |            |            |       |       | etc.       |
+------------+------------+------------+-------+-------+------------+
::::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
