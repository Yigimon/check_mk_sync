:::: {#header}
# Host-Merkmale

::: details
[Last modified on 05-Sep-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/host_tags.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Verwaltung der Hosts](hosts_setup.html) [Strukturierung der
Hosts](hosts_structure.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::::::::::::::: sectionbody
::: paragraph
Host-Merkmale (englisch: *host tags*) sind Schlagworte, die Hosts
zugeordnet werden können, um diese zu strukturieren und zu organisieren,
etwa nach Wichtigkeit, IP-Adressfamilie oder nach dem Weg, auf dem der
Host seine Daten erhält. So werden Host-Merkmale über die
[Ordnerstruktur](hosts_setup.html#folder) in Checkmk vererbt und können
als Bedingung in einer [Regel](glossar.html#rule) ausgewählt werden, um
Hosts gezielt anzusprechen.
:::

::: paragraph
Host-Merkmale sind aber nicht nur bei in der Konfiguration, sondern auch
im Monitoring nützlich. Zum Beispiel gibt es in
[Tabellenansichten](views.html#filter_context) einen Filter für
Host-Merkmale und das [Snapin](glossar.html#snapin) [Virtual host
tree]{.guihint} kann Ihre Ordner anhand der Merkmale in einem Baum
anordnen.
:::

::: paragraph
Und auf der Kommandozeile können Sie bei vielen Befehlen mit der Syntax
`@foo` alle Hosts mit dem Merkmal `foo` auswählen.
:::

::: paragraph
Damit alles richtig Sinn ergibt, sollten Sie Ihr eigenes Schema für
Host-Merkmale einrichten, welches für Ihre Umgebung optimal passt und
mit den anderen Möglichkeiten der [Strukturierung von
Hosts](hosts_structure.html) zusammenpasst. Nachträgliche Änderungen
einmal eingerichteter Host-Merkmale sind möglich, sollten aber vermieden
werden --- da die [Umbenennung der ID](#rename_tag_id) eines Merkmals in
den meisten Fällen manuelle Nacharbeit erfordert.
:::

::: paragraph
Aber bevor wir Ihnen zeigen, wie Sie im [Setup]{.guihint} eigene
Host-Merkmale definieren können, klären wir zunächst einige Begriffe.
:::

::::::::::: sect2
### []{#host_tag_group .hidden-anchor .sr-only}1.1. Host-Merkmalsgruppen {#heading_host_tag_group}

::: paragraph
Host-Merkmale sind in Gruppen organisiert, den sogenannten
Host-Merkmalsgruppen (englisch: *host tag groups*). Von diesen
Merkmalsgruppen gibt es zwei verschiedene Sorten. Diese Unterscheidung
ist für den gesamten Aufbau Ihrer Host-Merkmale sehr wichtig. Es gibt
Merkmalsgruppen, die mehrere Merkmale enthalten und es gibt
Merkmalsgruppen, die nur **ein einziges** Merkmal enthalten: die
*Checkbox-Merkmale.*
:::

::::::: sect3
#### []{#_gruppen_mit_mehreren_merkmalen .hidden-anchor .sr-only}Gruppen mit mehreren Merkmalen {#heading__gruppen_mit_mehreren_merkmalen}

::: paragraph
Ein gutes Beispiel für eine solche Host-Merkmalsgruppe ist `Data center`
mit den möglichen Merkmalen `Data center 1` und `Data center 2`. Damit
wäre dann jeder Host genau einem der beiden Rechenzentren zugeordnet.
Möchten Sie Hosts anlegen, die in keinem der beiden Rechenzentren
stehen, so brauchen Sie eine dritte Auswahlmöglichkeit, z.B.
`Not in a data center`.
:::

::: paragraph
**Jeder** Host in Checkmk erhält aus dieser Merkmalsgruppe **genau ein**
Merkmal. Daher ist die Festlegung des Standardwerts wichtig. Der
Standardwert wird gesetzt, wenn einem Host ein Merkmal aus der Gruppe
*nicht* explizit zugewiesen wird. Bei der [Erstellung einer
Merkmalsgruppe](#create_tag_group) ist das erste Merkmal in der Liste
der Standardwert. Für das Beispiel `Data center` ist das Merkmal
`Not in a data center` wahrscheinlich der geeignete Standardwert.
:::

::: paragraph
Manche Anwender haben versucht, die Anwendung, die auf einem Host läuft,
in einer Merkmalsgruppe abzubilden. Die Gruppe hieß z.B. `Application`
und hatte die Ausprägungen `Oracle`, `SAP`, `MS Exchange`, usw. Das geht
so lange gut, bis der Tag kommt, an dem ein Host *zwei* Anwendungen
hat --- und der kommt sicher!
:::

::: paragraph
Die richtige Lösung, um Anwendungen Hosts zuzuordnen, ist eine andere:
Erzeugen Sie *pro* Anwendung eine eigene Merkmalsgruppe, die nur zwei
Möglichkeiten (sprich: Merkmale) anbietet: `Ja` oder `Nein`. Und wenn
Sie auf ein Merkmal wie `Nein` gänzlich verzichten können und ein
Merkmal einfach nur aktivieren oder deaktivieren möchten, dann nützen
Sie einfach die Checkbox-Merkmale in Checkmk.
:::
:::::::

:::: sect3
#### []{#checkbox_tag .hidden-anchor .sr-only}Checkbox-Merkmale {#heading_checkbox_tag}

::: paragraph
Checkmk erlaubt es Ihnen nämlich, Merkmalsgruppen mit nur einem einzigen
Merkmal anzulegen, die sogenannten Checkbox-Merkmale (englisch:
*checkbox tags*). Für das obige Beispiel einer Anwendung können Sie dann
eine Merkmalsgruppe `Oracle` mit dem einzigen Merkmal `Ja`
erzeugen --- d.h. das `Nein` können Sie sich sparen. Ein
Checkbox-Merkmal wird in den Host-Eigenschaften nicht als Liste, sondern
als eben eine Checkbox dargestellt. Ein Ankreuzen der Checkbox setzt das
Merkmal, andernfalls entfällt das Merkmal. Im Gegensatz zu den
Merkmalsgruppen mit mehreren Merkmalen, bei denen immer genau ein
Merkmal gesetzt bzw. aktiviert ist, verbleiben Checkbox-Merkmale
standardmäßig deaktiviert.
:::
::::
:::::::::::

:::::: sect2
### []{#topic .hidden-anchor .sr-only}1.2. Themen {#heading_topic}

::: paragraph
Damit das Ganze nicht unübersichtlich wird, wenn Sie sehr viele
Host-Merkmalsgruppen haben (z.B. weil Sie sehr viele verschiedene
Anwendungen abbilden), können Sie die Merkmalsgruppen zu Themen
(englisch: *topics*) zusammenfassen. Alle Merkmalsgruppen des gleichen
Themas
:::

::: ulist
- werden in den Host-Eigenschaften in einem eigenen Kasten
  zusammengefasst und

- zeigen bei den Bedingungen einer Regel den Namen des Themas vor dem
  der Merkmalsgruppe, z.B. *Anwendungen / Oracle.*
:::

::: paragraph
Die Themen haben also „nur" eine optische Funktion und keine Auswirkung
auf die eigentliche Konfiguration.
:::
::::::

:::::: sect2
### []{#aux_tag .hidden-anchor .sr-only}1.3. Hilfsmerkmale {#heading_aux_tag}

::: paragraph
Hilfsmerkmale (englisch: *auxiliary tags*) lösen folgendes Problem:
Stellen Sie sich vor, dass Sie eine Host-Merkmalsgruppe `Betriebssystem`
definieren, mit den Ausprägungen `Linux`, `AIX`, `Windows 2016` und
`Windows 2019`. Nun möchten Sie eine Regel definieren, welche für alle
Windows-Hosts gelten soll.
:::

::: paragraph
Eine Möglichkeit ist es, ein Hilfsmerkmal namens `Windows` zu
definieren. Ordnen Sie den beiden Merkmalen `Windows 2016` und
`Windows 2019` dieses Hilfsmerkmal zu. Ein Host, der eines der beiden
Merkmale hat, erhält dann von Checkmk *automatisch* immer auch das
Hilfsmerkmal `Windows`. In den Regeln erscheint *Windows* als eigenes
Merkmal für die Formulierung von Bedingungen.
:::

::: paragraph
Diese Lösung hat den großen Vorteil, dass sie sich zu einem späteren
Zeitpunkt sehr leicht um neue Versionen von Windows erweitern lässt.
Sobald dann im Jahr 2030 Windows 3.0 erscheint, legen Sie einfach ein
neues Merkmal `Windows 3.0` an und ordnen diesem ebenfalls das
Hilfsmerkmal `Windows` zu. Alle bestehenden Regeln, die dieses
Hilfsmerkmal verwenden, gelten dann automatisch auch für die Hosts mit
dem neuen Merkmal. So ersparen Sie sich jede einzelne Regel prüfen und
bearbeiten zu müssen.
:::
::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

:::::::::: sect1
## []{#predefined_tags .hidden-anchor .sr-only}2. Vordefinierte Merkmalsgruppen {#heading_predefined_tags}

::::::::: sectionbody
::: paragraph
Den Einstieg in die Konfiguration der Host-Merkmale finden Sie über
[Setup \> Hosts \> Tags:]{.guihint}
:::

::::: {#hosttags_tags_default .imageblock}
::: content
![Liste aller vordefinierten
Host-Merkmalsgruppen.](../images/hosttags_tags_default.png)
:::

::: title
In einem frisch aufgesetzten System werden nur die vordefinierten
Merkmalsgruppen und Hilfsmerkmale aufgelistet
:::
:::::

::: paragraph
Checkmk richtet bei der Installation mehrere Host-Merkmalsgruppen ein:
:::

+-----------------+-----------------+-----------------+-----------------+
| ID              | Titel           | Merkmale        | Zweck           |
+=================+=================+=================+=================+
| `criticality`   | Criticality     | Productive      | Wichtigkeit des |
|                 |                 | system (ID:     | Systems. Für    |
|                 |                 | `prod`),        | das Merkmal     |
|                 |                 | Business        | `offline` wird  |
|                 |                 | critical (ID:   | die Regel       |
|                 |                 | `critical`),    | [Hosts to be    |
|                 |                 | Test system     | monit           |
|                 |                 | (ID: `test`),   | ored]{.guihint} |
|                 |                 | Do not monitor  | mit             |
|                 |                 | this host (ID:  | ausgeliefert,   |
|                 |                 | `offline`)      | welche die      |
|                 |                 |                 | Überwachung des |
|                 |                 |                 | Hosts           |
|                 |                 |                 | abschaltet. Die |
|                 |                 |                 | anderen         |
|                 |                 |                 | Merkmale sind   |
|                 |                 |                 | nur Beispiele   |
|                 |                 |                 | und ohne        |
|                 |                 |                 | Funktion. Sie   |
|                 |                 |                 | können diese    |
|                 |                 |                 | aber Hosts      |
|                 |                 |                 | zuweisen und    |
|                 |                 |                 | dann in Regeln  |
|                 |                 |                 | verwenden.      |
+-----------------+-----------------+-----------------+-----------------+
| `networking`    | Networking      | Local network   | Verstehen Sie   |
|                 | Segment         | (low latency)   | diese           |
|                 |                 | (ID: `lan`),    | Merkmalsgruppe  |
|                 |                 | WAN (high       | nur als         |
|                 |                 | latency) (ID:   | Beispiel. Für   |
|                 |                 | `wan`), DMZ     | das Merkmal     |
|                 |                 | (low latency,   | `wan` ist die   |
|                 |                 | secure access)  | Beispielregel   |
|                 |                 | (ID: `dmz`)     | [PING and host  |
|                 |                 |                 | check           |
|                 |                 |                 | parame          |
|                 |                 |                 | ters]{.guihint} |
|                 |                 |                 | hinterlegt,     |
|                 |                 |                 | welche die      |
|                 |                 |                 | Schwellwerte    |
|                 |                 |                 | für             |
|                 |                 |                 | PIN             |
|                 |                 |                 | G-Antwortzeiten |
|                 |                 |                 | an die längeren |
|                 |                 |                 | Laufzeiten im   |
|                 |                 |                 | WAN anpasst.    |
+-----------------+-----------------+-----------------+-----------------+
| `agent`         | Checkmk agent / | API             | Legt fest, auf  |
|                 | API             | integrations if | welche Art die  |
|                 | integrations    | configured,     | Daten vom Host  |
|                 |                 | else Checkmk    | geholt werden.  |
|                 |                 | agent (ID:      |                 |
|                 |                 | `cmk-agent`),   |                 |
|                 |                 | Configured API  |                 |
|                 |                 | integrations    |                 |
|                 |                 | and Checkmk     |                 |
|                 |                 | agent (ID:      |                 |
|                 |                 | `all-agents`),  |                 |
|                 |                 | Configured API  |                 |
|                 |                 | integrations,   |                 |
|                 |                 | no Checkmk      |                 |
|                 |                 | agent (ID:      |                 |
|                 |                 | `sp             |                 |
|                 |                 | ecial-agents`), |                 |
|                 |                 | No API          |                 |
|                 |                 | integrations,   |                 |
|                 |                 | no Checkmk      |                 |
|                 |                 | agent (ID:      |                 |
|                 |                 | `no-agent`)     |                 |
+-----------------+-----------------+-----------------+-----------------+
| `piggyback`     | Piggyback       | Use piggyback   | Dieses Merkmal  |
|                 |                 | data from other | legt fest, ob   |
|                 |                 | hosts if        | und wie         |
|                 |                 | present (ID:    | [Piggyback-     |
|                 |                 | `au             | Daten](glossar. |
|                 |                 | to-piggyback`), | html#piggyback) |
|                 |                 | Always use and  | für den Host    |
|                 |                 | expect          | erwar           |
|                 |                 | piggyback data  | tet/verarbeitet |
|                 |                 | (ID:            | werden.         |
|                 |                 | `piggyback`),   |                 |
|                 |                 | Never use       |                 |
|                 |                 | piggyback data  |                 |
|                 |                 | (ID:            |                 |
|                 |                 | `no-piggyback`) |                 |
+-----------------+-----------------+-----------------+-----------------+
| `snmp_ds`       | SNMP            | No SNMP (ID:    | Hier wird       |
|                 |                 | `no-snmp`),     | bestimmt, ob    |
|                 |                 | SNMP v2 or v3   | Daten (auch)    |
|                 |                 | (ID:            | per SNMP        |
|                 |                 | `snmp-v2`),     | eingesammelt    |
|                 |                 | SNMP v1 (ID:    | werden sollen.  |
|                 |                 | `snmp-v1`)      |                 |
+-----------------+-----------------+-----------------+-----------------+
| `               | IP address      | IPv4 only (ID:  | Legt fest, ob   |
| address_family` | family          | `ip-v4-only`),  | der Host per    |
|                 |                 | IPv6 only (ID:  | IPv4 oder IPv6  |
|                 |                 | `ip-v6-only`),  | oder beidem     |
|                 |                 | IPv4/IPv6       | überwacht       |
|                 |                 | dual-stack (ID: | werden soll.    |
|                 |                 | `ip-v4v6`), No  | „No IP" ist     |
|                 |                 | IP (ID:         | relevant für    |
|                 |                 | `no-ip`)        | Hosts, die über |
|                 |                 |                 | einen           |
|                 |                 |                 | [Spezialagente  |
|                 |                 |                 | n](glossar.html |
|                 |                 |                 | #special_agent) |
|                 |                 |                 | abgefragt       |
|                 |                 |                 | werden.         |
+-----------------+-----------------+-----------------+-----------------+

::: paragraph
Sie können vordefinierte Merkmalsgruppen (englisch: *predefined tag
groups*) anpassen, solange diese nicht als *built-in* markiert sind (in
der Spalte [Actions]{.guihint}). Die *eingebauten* Merkmalsgruppen
werden intern von Checkmk bei der Konfigurationserzeugung benötigt und
sind daher nicht änderbar. Dagegen sind Änderungen in `Criticality` oder
`Network Segment` unkritisch. Diese sind nur als Beispiel vorgesehen.
:::
:::::::::
::::::::::

::::::::::::::::::::::::::: sect1
## []{#create_tag_group .hidden-anchor .sr-only}3. Merkmalsgruppen erstellen {#heading_create_tag_group}

:::::::::::::::::::::::::: sectionbody
::: paragraph
Sie starten die Erstellung von eigenen Host-Merkmalen auf der Seite
[[Tag groups](#hosttags_tags_default)]{.guihint}, die Sie wieder über
[Setup \> Hosts \> Tags]{.guihint} erreichen.
:::

::: paragraph
Bevor Sie Host-Merkmale erstellen können, müssen Sie zunächst die
Host-Merkmalsgruppe anlegen, die die Merkmale enthalten soll. Das
Anlegen einer neuen Merkmalsgruppe erfolgt mit dem Knopf [![Symbol zum
Anlegen einer neuen
Merkmalsgruppe.](../images/icons/icon_new.png)]{.image-inline} [Add tag
group]{.guihint} und bringt Sie zu folgenden Formularen:
:::

::::: imageblock
::: content
![Grundeinstellungen einer
Merkmalsgruppe.](../images/hosttags_group_basic_settings.png)
:::

::: title
ID und Titel werden in den Grundeinstellungen der Merkmalsgruppe
festgelegt
:::
:::::

::: paragraph
Die [Tag group ID]{.guihint} wird intern als ID für die Merkmalsgruppe
verwendet. Sie muss eindeutig sein und kann später nicht mehr geändert
werden. Es gelten die üblichen Regeln für erlaubte Zeichen (nur
Buchstaben, Ziffern, Unterstrich).
:::

::: paragraph
Der [Title]{.guihint} wird überall in der GUI verwendet, wo es um die
Merkmalsgruppe geht. Da dies ein reiner Anzeigetext ist, kann er
jederzeit geändert werden, ohne dass das einen Einfluss auf die
bestehende Konfiguration hat.
:::

::: paragraph
Das [Topic]{.guihint} können Sie leer lassen. Dann wird Ihre
Merkmalsgruppe zusammen mit den mitgelieferten Gruppen `Criticality` und
`Networking Segment` bei den Host-Eigenschaften im Kasten [Custom
attributes]{.guihint} angezeigt. Sie können aber auch eigene
[Themen](#topic) anlegen und damit Ihre Merkmalsgruppen übersichtlich
zusammenfassen.
:::

::: paragraph
Am wichtigsten ist der nächste Kasten [Tag choices]{.guihint}, in dem
Sie nacheinander alle Host-Merkmale für die neue Merkmalsgruppe
festlegen:
:::

::::: imageblock
::: content
![Liste der zur Merkmalsgruppe gehörenden
Host-Merkmale.](../images/hosttags_group_tag_choices.png)
:::

::: title
Auch jedes Host-Merkmal benötigt eine ID und einen Titel
:::
:::::

::: paragraph
Dabei muss die [Tag ID]{.guihint} eindeutig innerhalb der Gruppe sein.
:::

::: paragraph
Die Reihenfolge, welche Sie wie gewohnt mit dem Knopf [![Symbol zum
Verschieben eines
Listeneintrags.](../images/icons/icon_drag.png)]{.image-inline} ändern
können, hat nicht nur eine optische Funktion: **Das erste Merkmal in der
Liste ist der Standardwert**! Das bedeutet, dass *alle* Hosts, die keine
explizite Einstellung für diese Merkmalsgruppe haben, automatisch auf
diesen Wert gesetzt werden.
:::

::: paragraph
Unter [Auxiliary tags]{.guihint} können Sie jedem Host-Merkmal
Hilfsmerkmale zuordnen, die automatisch dem Host hinzugefügt werden
sollen, wenn das Host-Merkmal gewählt ist.
:::

::: paragraph
Ein Checkbox-Merkmal erstellen Sie analog, indem Sie eine Merkmalsgruppe
anlegen, die aber nur **ein** Merkmal enthält:
:::

::::: imageblock
::: content
![Grundeinstellungen und Merkmalsdefinition für ein
Checkbox-Merkmal.](../images/hosttags_checkbox_tag.png)
:::

::: title
Die Merkmalsgruppe eines Checkbox-Merkmals enthält genau einen Eintrag
:::
:::::

::: paragraph
In den Eigenschaften des Hosts wird dieses Merkmal dann so angezeigt:
:::

::::: imageblock
::: content
![Eigenschaften eines Hosts mit einem
Checkbox-Merkmal.](../images/hosttags_checkbox_tag_in_host_prop.png)
:::

::: title
Ein Checkbox-Merkmal ist standardmäßig deaktiviert
:::
:::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

:::::::::: sect1
## []{#create_aux_tag .hidden-anchor .sr-only}4. Hilfsmerkmale erstellen {#heading_create_aux_tag}

::::::::: sectionbody
::: paragraph
Zusätzlich zu den vordefinierten Host-Merkmalsgruppen richtet Checkmk
auch passende [Hilfsmerkmale](#aux_tag) (englisch: *auxiliary tags*)
ein, die auf der Seite [[Tag groups](#hosttags_tags_default)]{.guihint}
unter den Gruppen aufgelistet werden.
:::

::: paragraph
Neue Hilfsmerkmale können Sie mit [![Symbol zum Anlegen von
Hilfsmerkmalen.](../images/icons/icon_aux_tag.png)]{.image-inline} [Add
aux tag]{.guihint} erstellen.
:::

::::: imageblock
::: content
![Die Einstellungen eines
Hilfsmerkmals.](../images/hosttags_auxtag_basic_settings.png)
:::

::: title
Die Grundeinstellungen eines Hilfsmerkmals sind fast identisch zu denen
einer Merkmalsgruppe
:::
:::::

::: paragraph
Mit der unveränderlichen ID und einem aussagekräftigen Titel sind alle
notwendigen Einstellungen eines Hilfsmerkmals gesetzt. Die Zuordnung von
Hilfsmerkmalen zu Host-Merkmalen erfolgt in den
[Merkmalsgruppen.](#create_tag_group)
:::
:::::::::
::::::::::

::::::::::::::::::::::::::::::::: sect1
## []{#edit_delete_tag .hidden-anchor .sr-only}5. Merkmalsgruppen und Merkmale ändern und löschen {#heading_edit_delete_tag}

:::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das Ändern der bestehenden Merkmalsgruppenkonfiguration mag auf den
ersten Blick wie eine einfache Operation aussehen. Das ist aber leider
nicht immer so, da es größere Auswirkungen auf Ihre bestehende
Konfiguration haben kann.
:::

::: paragraph
Änderungen, die lediglich die Anzeige betreffen oder nur neue
Auswahlmöglichkeiten hinzufügen, sind unproblematisch und haben keine
Auswirkung auf die bestehenden Hosts und Regeln:
:::

::: ulist
- Änderung im Titel oder Thema von Merkmalen und Merkmalsgruppen

- Hinzufügen eines weiteren Merkmals zu einer Merkmalsgruppe
:::

::: paragraph
Alle anderen Änderungen können Auswirkungen auf bestehende Ordner, Hosts
und Regeln haben, die die betroffenen Merkmale verwenden. Checkmk
verbietet dabei nicht einfach solche Änderungen, sondern versucht für
Sie, Ihre bestehende Konfiguration so anzupassen, dass alles wieder Sinn
ergibt. Was das genau bedeutet, hängt von der Art der Operation ab.
:::

::: paragraph
**Tipp:** Checkmk kann Ihnen zeigen, in welchen Ordnern, Hosts und
Regeln alle Host-Merkmale und alle Hilfsmerkmale gerade verwendet
werden: Wählen Sie dazu auf der Seite [[Tag
groups](#hosttags_tags_default)]{.guihint} den Menüeintrag [Tags \> Tag
usage.]{.guihint}
:::

:::::::::: sect2
### []{#delete_tag_group .hidden-anchor .sr-only}5.1. Merkmalsgruppen löschen {#heading_delete_tag_group}

::: paragraph
Mit dem Löschen einer Merkmalsgruppe wird von allen Hosts die
Information über die betroffenen Merkmale entfernt. Falls die
Merkmalsgruppe in vorhandenen Regeln als Bedingung verwendet wird,
erhalten Sie folgende Warnung:
:::

::::: imageblock
::: content
![Warnung beim Löschen einer
Merkmalsgruppe.](../images/hosttags_delete_warn.png)
:::

::: title
Beim Löschen einer Merkmalsgruppe entscheiden Sie, wie die betroffenen
Regeln angepasst werden
:::
:::::

::: paragraph
Sie müssen sich hier entscheiden, ob Sie aus bestehenden Regeln die
Bedingungen mit den betroffenen Host-Merkmalen, oder ob Sie die ganzen
Regeln löschen möchten. Beides kann sinnvoll sein und Checkmk kann nicht
für Sie entscheiden, was hier besser ist.
:::

::: paragraph
Mit dem Knopf [Delete rules containing tags that have been removed,
...​]{.guihint} entscheiden Sie sich für das Löschen von Regeln.
Allerdings wird eine Regel nur dann gelöscht, wenn sie eine *positive*
Bedingung mit einem Merkmal aus der Merkmalsgruppe besitzt. Regeln, die
eine *negative* Bedingung mit einem solchen Merkmal haben, verlieren
einfach diese Bedingung, bleiben aber erhalten. Wenn Sie z.B. eine Regel
für alle Hosts erstellt haben, die **nicht** das Merkmal `dc02` haben
und Sie entfernen das Merkmal `dc02` komplett aus der Konfiguration,
dann ist augenscheinlich auch diese Bedingung überflüssig.
:::

::: paragraph
Wenn Sie sich nicht sicher sind, sollten Sie die Regeln (die in der
Warnung verlinkt sind) von Hand durchgehen und alle Bedingungen der
betroffenen Merkmalsgruppe entfernen oder abändern.
:::
::::::::::

:::::: sect2
### []{#delete_tag .hidden-anchor .sr-only}5.2. Merkmale löschen {#heading_delete_tag}

::: paragraph
Das Löschen eines Merkmals erreichen Sie durch Editieren der Gruppe,
Entfernen des Merkmals und anschließendem Speichern. Dabei kann es zu
einer ähnlichen Warnung wie beim Entfernen einer Merkmalsgruppe kommen.
:::

::: paragraph
Hosts, die das betroffene Merkmal gesetzt hatten, werden automatisch auf
den Standardwert gesetzt. Dies ist, wie beim [Erstellen einer
Merkmalsgruppe](#create_tag_group) beschrieben, stets das erste Merkmal
in der Liste.
:::

::: paragraph
Bei Regeln, die das zu löschende Merkmal als Bedingung erhalten, wird
genauso verfahren, wie im vorherigen Abschnitt beim Löschen von
Merkmalsgruppen beschrieben.
:::
::::::

:::: sect2
### []{#delete_aux_tag .hidden-anchor .sr-only}5.3. Hilfsmerkmale löschen {#heading_delete_aux_tag}

::: paragraph
Sie können ein Hilfsmerkmal nur dann löschen, wenn es keinem
Host-Merkmal zugewiesen ist.
:::
::::

:::::::::::: sect2
### []{#rename_tag_id .hidden-anchor .sr-only}5.4. Merkmal-IDs umbenennen {#heading_rename_tag_id}

::: paragraph
Anders als bei den Merkmalsgruppen können Sie die IDs von Merkmalen
tatsächlich nachträglich ändern. Dies ist eine Ausnahme vom
Checkmk-Prinzip, das IDs unveränderlich sind, wenn sie einmal vergeben
wurden. Diese Ausnahme kann aber nützlich sein, wenn Sie z.B. einen
Datenimport von einem anderen System vorbereiten wollen, und dafür das
vorhandene, unterschiedliche Merkmalsschema in Checkmk anpassen müssen.
:::

::: paragraph
Um eine Merkmal-ID umzubenennen, editieren Sie die Merkmalsgruppe und
ändern dort einfach die ID des Merkmals.
:::

::: paragraph
**Wichtig:** Verändern Sie dabei **nicht** den Titel des Merkmals.
:::

::: paragraph
Bevor Checkmk mit der Anpassung der Konfiguration zu Werke geht, werden
Sie über die Konsequenzen aufgeklärt:
:::

::::: imageblock
::: content
![Warnung beim Umbenennen von von
Merkmal-IDs.](../images/hosttags_rename_warn.png)
:::

::: title
Die Warnung zeigt Ihnen, wie Checkmk die Umbenennung der Merkmal-IDs
durchführen wird
:::
:::::

::: paragraph
Checkmk wird nun alle betroffenen Ordner, Hosts und Regeln entsprechend
anpassen.
:::

::: paragraph
Beachten Sie, dass es trotzdem noch Situationen geben kann, in denen Sie
an anderen Stellen manuell nacharbeiten müssen. So sind z.B. Merkmal-IDs
Bestandteile von URLs, welche [Tabellenansichten](glossar.html#view)
aufrufen, die nach Merkmalen filtern. Checkmk kann diese URLs nicht für
Sie anpassen. Auch Filterkonfigurationen in [Berichten](reporting.html)
und [Dashboards](glossar.html#dashboard) können nicht automatisch
angepasst werden.
:::
::::::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#tags_in_monitoring .hidden-anchor .sr-only}6. Host-Merkmale im Monitoring anzeigen {#heading_tags_in_monitoring}

:::::::::::::::::::::::: sectionbody
::: paragraph
Hosts werden in Checkmk in der Regel in Ordnern organisiert. Die sich
daraus ergebende Hierarchie können Sie als Baumansicht in der
Seitenleiste am unteren Ende des [Snapins](glossar.html#snapin) [Tree of
Folders]{.guihint} darstellen und von dort die Standardansicht für die
pro Verzweigung gefilterten Hosts aufrufen.
:::

::: paragraph
Eine solche Baumansicht können Sie aber auch aus Host-Merkmalen
erstellen und so eine „virtuelle" Hierarchie abbilden --- und zwar mit
dem Snapin [Virtual host tree]{.guihint}. Neben den Host-Merkmalen
dürfen Sie auch die Ordnerstruktur in derlei Bäume einbauen, wobei
sowohl die Anzahl der virtuellen Bäume als auch der jeweiligen
Verzweigungen unbeschränkt ist.
:::

::: paragraph
Angenommen, Sie verwenden für Ihre Hosts die drei Merkmalsgruppen
`Criticality`, `Data center` und `Operating systems`. Dann bekommen Sie
auf der obersten Baumebene eine Auswahl nach System, darunter nach
Rechenzentrum und letztlich nach Betriebssystem. Jede Hierarchieebene
bringt Sie direkt zur Ansicht aller Hosts mit eben diesen Merkmalen.
:::

::: paragraph
Zum Anlegen eines Virtual host tree fügen Sie zunächst das Snapin über
den Knopf [![Symbol zum Anzeigen aller
Snapins.](../images/icons/button_sidebar_add_snapin.png)]{.image-inline}
unten in der Seitenleiste zu dieser hinzu:
:::

::::: imageblock
::: content
![Snapin Virtual host
tree.](../images/hosttags_snapin_virtual_host_tree_default.png){width="50%"}
:::

::: title
Beim ersten Aufruf des Snapins fehlt noch die Konfiguration
:::
:::::

::: paragraph
Klicken Sie auf den Link im Text, der auf die noch fehlende
Konfiguration hinweist, oder rufen Sie manuell die Seite in den globalen
Einstellungen über [Setup \> General \> Global Settings \> User
interface \> Virtual host trees]{.guihint} auf:
:::

::::: imageblock
::: content
![Der Standard in den globalen Einstellungen zum Virtual host
tree.](../images/hosttags_virtual_host_tree_new.png)
:::

::: title
Per Knopfdruck können Sie die Einstellungen zum Virtual host tree öffnen
:::
:::::

::: paragraph
Erstellen Sie dann einen neuen Baum mit [Create new virtual host tree
configuration:]{.guihint}
:::

::::: imageblock
::: content
![Festlegung der Baumstruktur in den globalen
Einstellungen.](../images/hosttags_virtual_host_tree_settings.png)
:::

::: title
Host-Merkmalsgruppen definieren die Ebenen des Baums
:::
:::::

::: paragraph
Vergeben Sie zuerst ID und Titel des Baums. Optional können Sie die
Anzeige leerer Baumzweige durch Ankreuzen von [Exclude empty tag
choices]{.guihint} ausschließen. Anschließend fügen Sie über [Add new
element]{.guihint} die gewünschten Merkmalsgruppen in der gewünschten
Reihenfolge hinzu. Über den Eintrag [Folder tree]{.guihint} können Sie
auch die Ordnerhierarchie miteinbeziehen. Die Reihenfolge für die
Hierarchie können Sie wie üblich mit dem Knopf [![Symbol zum Verschieben
eines Listeneintrags.](../images/icons/icon_drag.png)]{.image-inline}
ändern.
:::

::: paragraph
Nach dem Speichern zeigt das Snapin die ausgewählte Hierarchie als
Baumstruktur:
:::

::::: imageblock
::: content
![Snapin Virtual host tree mit 3
Merkmalsgruppen.](../images/hosttags_snapin_virtual_host_tree_configured.png){width="50%"}
:::

::: title
Das konfigurierte Snapin zeigt nun 3 Ebenen von Merkmalsgruppen
:::
:::::

::: paragraph
Die Zweige und Blätter des Baums sind die Host-Merkmale aus den in der
Konfiguration gewählten Merkmalsgruppen. Die Nummern in Klammern bei den
Blättern zeigen, wie viele Hosts diese Merkmale besitzen.
:::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~/etc/check_mk/(conf.d|m | In diesen Dateien befinden sich die      |
| ultisite.d)/wato/tags.mk` | Definitionen aller Host-Merkmale.        |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
