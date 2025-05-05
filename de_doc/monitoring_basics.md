:::: {#header}
# Grundlagen des Monitorings mit Checkmk

::: details
[Last modified on 21-Mar-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/monitoring_basics.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Verwaltung der Hosts](hosts_setup.html)
[Monitoring-Agenten](wato_monitoringagents.html)
:::
::::
:::::

::: paragraph
In diesem Artikel erläutern wir die grundlegenden Begriffe und Konzepte
in Checkmk, wie z.B. Host, Service, Benutzer, Kontaktgruppe,
Benachrichtigung, Zeitraum, Wartungszeit.
:::
:::::::
:::::::::

::::::::: sect1
## []{#states_events .hidden-anchor .sr-only}1. Zustände und Ereignisse {#heading_states_events}

:::::::: sectionbody
::: paragraph
Zunächst ist es wichtig, die grundlegenden Unterschiede zwischen
*Zuständen* und *Ereignissen* zu verstehen --- und zwar aus ganz
praktischem Nutzen. Die meisten klassischen IT-Monitoring-Systeme drehen
sich um Ereignisse (Events). Ein Ereignis ist etwas zu einem ganz
bestimmten Zeitpunkt einmalig Geschehenes. Ein gutes Beispiel wäre
*Fehler beim Zugriff auf Platte X.* Übliche Quellen von Ereignissen sind
Syslog-Meldungen, SNMP-Traps, das Windows-Event-Log und Einträge in
Log-Dateien. Ereignisse passieren quasi spontan (von selbst, asynchron).
:::

::: paragraph
Dagegen beschreibt ein *Zustand* eine anhaltende Situation, z.B. *Platte
X ist online.*. Um den aktuellen Zustand von etwas zu überwachen, muss
das Monitoring-System diesen regelmäßig abfragen. Wie das Beispiel
zeigt, gibt es beim Monitoring oft die Wahl, ob man mit Ereignissen oder
mit Zuständen arbeitet.
:::

::: paragraph
Checkmk beherrscht beide Disziplinen, gibt jedoch immer dort, wo die
Wahl besteht, dem *zustandsbasierten Monitoring* den Vorzug. Der Grund
liegt in den zahlreichen Vorteilen dieser Methode. Einige davon sind:
:::

::: ulist
- Ein Fehler in der Überwachung selbst wird sofort erkannt, weil es
  natürlich auffällt, wenn das Abfragen des Zustands nicht mehr
  funktioniert. Die Abwesenheit einer *Meldung* dagegen gibt keine
  Sicherheit, ob das Monitoring noch funktioniert.

- Das Monitoring kann selbst steuern, mit welcher Rate Zustände
  abgerufen werden. Es gibt keine Gefahr eines Sturms an Event-Meldungen
  in systemweiten Problemsituationen.

- Das regelmäßige Abfragen in einem festen Zeitraster ermöglicht das
  Erfassen von [Metriken](glossar.html#metric), um deren Zeitverlauf
  aufzuzeichnen.

- Auch nach chaotischen Situationen --- z.B. Stromausfall im
  Rechenzentrum --- hat man immer einen zuverlässigen Gesamtzustand.
:::

::: paragraph
Man kann also sagen, dass das zustandsbasierte Monitoring bei Checkmk
das *normale* ist. Für das Verarbeiten von Ereignissen gibt es daneben
die [Event Console](glossar.html#ec). Diese ist auf das Korrelieren und
Bewerten von großen Mengen an Ereignissen spezialisiert und nahtlos in
das Monitoring mit Checkmk integriert.
:::
::::::::
:::::::::

::::::::::::::::::::::::::::::::: sect1
## []{#hosts_services .hidden-anchor .sr-only}2. Hosts und Services {#heading_hosts_services}

:::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#hosts .hidden-anchor .sr-only}2.1. Hosts {#heading_hosts}

::: paragraph
Alles in der Überwachung dreht sich um *Hosts* und *Services.* Wir haben
uns lange Gedanken gemacht, wie man Host ins Deutsche übersetzen könnte
und am Ende entschieden, dass wir den Begriff so belassen, um keine
unnötige Verwirrung zu stiften. Denn ein Host kann vieles sein, z.B.:
:::

::: ulist
- Ein Server

- Ein Netzwerkgerät (Switch, Router, Load Balancer)

- Ein Messgerät mit IP-Anschluss (Thermometer, Luftfeuchtesensor)

- Irgendetwas anderes mit einer IP-Adresse

- Ein Cluster aus mehreren Hosts

- Eine virtuelle Maschine

- Ein Docker-Container
:::

::: paragraph
Im Monitoring hat ein Host immer einen der folgenden Zustände:
:::

+------+------+--------------------------------------------------------+
| Zus  | F    | Bedeutung                                              |
| tand | arbe |                                                        |
+======+======+========================================================+
| [U   | grün | Der Host ist über das Netzwerk erreichbar (in der      |
| P]{. |      | Regel heißt das, dass er auf PING antwortet).          |
| hsta |      |                                                        |
| te0} |      |                                                        |
+------+------+--------------------------------------------------------+
| [DOW | rot  | Der Host antwortet nicht auf Anfragen aus dem          |
| N]{. |      | Netzwerk, ist nicht erreichbar.                        |
| hsta |      |                                                        |
| te1} |      |                                                        |
+------+------+--------------------------------------------------------+
| [UN  | or   | Der *Weg* zu dem Host ist aktuell für das Monitoring   |
| REAC | ange | versperrt, weil ein Router oder Switch auf dem Weg     |
| H]{. |      | dorthin ausgefallen ist.                               |
| hsta |      |                                                        |
| te2} |      |                                                        |
+------+------+--------------------------------------------------------+
| [PE  | grau | Der Host wurde frisch in die Überwachung aufgenommen   |
| ND]{ |      | und noch nie abgefragt. Genau genommen ist das aber    |
| .sta |      | kein Zustand.                                          |
| tep} |      |                                                        |
+------+------+--------------------------------------------------------+

::: paragraph
Neben dem Zustand hat ein Host noch einige Attribute, die vom Benutzer
konfiguriert werden, z.B.:
:::

::: ulist
- Einen eindeutigen Namen

- Eine IP-Adresse

- Optional einen Alias-Namen, welcher nicht eindeutig sein muss

- Optional einen oder mehrere *Parents*
:::
::::::::

::::::::: sect2
### []{#parents .hidden-anchor .sr-only}2.2. Parents {#heading_parents}

::: paragraph
Damit das Monitoring den Zustand [UNREACH]{.hstate2} berechnen kann,
muss es wissen, über welchen Weg es jeden einzelnen Host erreichen kann.
Dazu kann man bei jedem Host einen oder mehrere sogenannte
*Parent-Hosts* angeben. Wenn z.B. ein Server A *vom Monitoring aus
gesehen* nur über einen Router B erreichbar ist, dann ist B ein
Parent-Host von A. In [Checkmk
konfiguriert](hosts_structure.html#parents) werden dabei nur *direkte*
Parents. Daraus ergibt sich dann eine baumartige Struktur mit der
Checkmk-Instanz in der Mitte (hier dargestellt als [![Symbol für die
Checkmk-Instanz.](../images/icons/parent_map_root.png)]{.image-inline}):
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Netzwerktopologie mit einem konfigurierten
Parent.](../images/monitoring_basics_parents.png){width="43%"}
:::
::::

::: paragraph
Nehmen wir an, dass in der oben gezeigten beispielhaften
Netzwerktopologie die Hosts *myhost* und *myhost4* nicht mehr erreichbar
sind. Der Ausfall von *myhost4* ist dadurch erklärbar, dass *myhost*
ausgefallen ist. Daher wird *myhost4* im Monitoring als
[UNREACH]{.hstate2} klassifiziert. Es ist schlicht nicht eindeutig
feststellbar, weswegen Checkmk *myhost4* nicht mehr erreichen kann und
der Zustand [DOWN]{.hstate1} wäre daher unter Umständen irreführend.
Stattdessen bewirkt das [UNREACH]{.hstate2} standardmäßig die
Unterdrückung einer [Benachrichtigung](notifications.html). Denn das ist
die wichtigste Aufgabe des Konzepts der Parents: Die Vermeidung
massenhafter Benachrichtigungen, falls ein ganzes Netzwerksegment
aufgrund einer Unterbrechung für das Monitoring nicht mehr erreichbar
ist.
:::

::: paragraph
Der Vermeidung von Fehlalarmen dient auch ein
[Feature](cmc_differences.html#no_on-demand_host_checks) des in den
kommerziellen Editionen verwendeten Checkmk Micro Core (CMC). Hier wird
der Zustandswechsel über einen ausgefallenen Host wenige Augenblicke
zurückgehalten und findet erst dann statt, wenn *gesichert* ist, dass
der Parent noch erreichbar ist. Falls der Parent dagegen sicher
[DOWN]{.hstate1} ist, wechselt der Host nach
[UNREACH]{.hstate2} --- ohne dass benachrichtigt wird.
:::

::: paragraph
In manchen Fällen hat ein Host mehrere Parents, zum Beispiel, wenn ein
Router hochverfügbar in einem Cluster betrieben wird. Für Checkmk reicht
es, wenn einer dieser Parents erreichbar ist, um den Zustand des Hosts
eindeutig zu bestimmen. Falls ein Host also *mehrere* Parents hat und
zumindest einer dieser Parents [UP]{.hstate0} ist, wird der Host im
Monitoring als erreichbar betrachtet. Mit anderen Worten: In diesem Fall
wird der Host nicht automatisch in den Zustand [UNREACH]{.hstate2}
wechseln.
:::
:::::::::

::::::: sect2
### []{#services .hidden-anchor .sr-only}2.3. Services {#heading_services}

::: paragraph
Ein Host hat eine Menge von *Services.* Ein Service kann alles Mögliche
sein, verwechseln Sie das nicht mit den Diensten (*services*) von
Windows. Ein Service ist irgendein Teil oder Aspekt des Hosts, der
[OK]{.state0} sein kann oder eben nicht. Der Zustand von Services kann
natürlich immer nur dann abgefragt werden, wenn der Host im Zustand
[UP]{.hstate0} ist.
:::

::: paragraph
Folgende Zustände kann ein Service im Monitoring haben:
:::

+------+------+--------------------------------------------------------+
| Zus  | F    | Bedeutung                                              |
| tand | arbe |                                                        |
+======+======+========================================================+
| [    | grün | Der Service ist vollständig in Ordnung. Alle Messwerte |
| OK]{ |      | liegen im erlaubten Bereich.                           |
| .sta |      |                                                        |
| te0} |      |                                                        |
+------+------+--------------------------------------------------------+
| [WA  | gelb | Der Service funktioniert normal, aber seine Parameter  |
| RN]{ |      | liegen außerhalb des optimalen Bereichs.               |
| .sta |      |                                                        |
| te1} |      |                                                        |
+------+------+--------------------------------------------------------+
| [CR  | rot  | Der Service ist ausgefallen, defekt.                   |
| IT]{ |      |                                                        |
| .sta |      |                                                        |
| te2} |      |                                                        |
+------+------+--------------------------------------------------------+
| [U   | or   | Der Zustand des Services konnte nicht korrekt          |
| NKNO | ange | ermittelt werden. Der Monitoring-Agent hat fehlerhafte |
| WN]{ |      | Daten geliefert oder die zu überwachende Sache ist     |
| .sta |      | ganz verschwunden.                                     |
| te3} |      |                                                        |
+------+------+--------------------------------------------------------+
| [PE  | grau | Der Service ist gerade in die Überwachung aufgenommen  |
| ND]{ |      | worden und es gibt noch keine Monitoring-Daten.        |
| .sta |      |                                                        |
| tep} |      |                                                        |
+------+------+--------------------------------------------------------+

::: paragraph
Wenn es darum geht, welcher Zustand „schlimmer" ist, verwendet Checkmk
folgende Reihenfolge:
:::

::: paragraph
[OK]{.state0} → [WARN]{.state1} → [UNKNOWN]{.state3} → [CRIT]{.state2}
:::
:::::::

::::::::::::: sect2
### []{#checks .hidden-anchor .sr-only}2.4. Checks {#heading_checks}

::: paragraph
Ein [Check](glossar.html#check) sorgt dafür, dass ein Host oder ein
Service einen Zustand erhält. Welche Zustände das sein können, ist im
vorherigen Abschnitt beschrieben. Services und Checks hängen eng
miteinander zusammen. Daher werden sie manchmal, vielleicht sogar in
diesem Handbuch, synonym verwendet, obwohl es doch verschiedene Dinge
sind.
:::

::: paragraph
Im Setup können Sie sich anzeigen lassen, welches
[Check-Plugin](glossar.html#check_plugin) für welchen Service zuständig
ist. Öffnen Sie mit [Setup \> Hosts]{.guihint} die Eigenschaften eines
Hosts und dann im Menü [Hosts \> Service Configuration]{.guihint} die
Liste der Services dieses Hosts. Dann blenden Sie mit [Display \> Show
plugin names]{.guihint} eine neue Spalte ein, die Ihnen für jeden
Service das zuständige Check-Plugin anzeigt:
:::

::::: imageblock
::: content
![monitoring basics services
checks](../images/monitoring_basics_services_checks.png)
:::

::: title
Die hier nicht relevante Tabellenspalte [Status detail]{.guihint} haben
wir weggelassen
:::
:::::

::: paragraph
Wie Sie am Beispiel des Check-Plugins [df]{.guihint} sehen, kann ein
Check-Plugin für mehrere Services verantwortlich sein. Übrigens sind in
der eingeblendeten Spalte die Namen der Check-Plugins Links, die Sie zur
Beschreibung des Check-Plugins führen.
:::

::: paragraph
Der Zusammenhang und die Abhängigkeit von Services und Checks sind auch
im Monitoring zu sehen. In der Service-Liste eines Hosts im Monitoring
können Sie feststellen, dass im [![icon
menu](../images/icons/icon_menu.png)]{.image-inline} Aktionsmenü beim
Eintrag [Reschedule]{.guihint} bei einigen Services ein gelber Pfeil
steht ([![icon
reload](../images/icons/icon_reload.png)]{.image-inline}), bei den
meisten anderen aber ein grauer Pfeil ([![icon reload
cmk](../images/icons/icon_reload_cmk.png)]{.image-inline}). Ein Service
mit dem gelben Pfeil basiert auf einem [aktiven
Check:](glossar.html#active_check)
:::

:::: imageblock
::: content
![monitoring basics check mk
service](../images/monitoring_basics_check_mk_service.png)
:::
::::

::: paragraph
Solch ein aktiver Check wird von Checkmk direkt ausgeführt. Services mit
dem grauen Pfeil basieren auf passiven Checks, deren Daten von einem
anderen Service, dem Service [Check_MK]{.guihint}, geholt werden. Dies
geschieht aus Gründen der Performance und stellt eine Besonderheit von
Checkmk dar.
:::
:::::::::::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

:::::: sect1
## []{#host_service_groups .hidden-anchor .sr-only}3. Host- und Service-Gruppen {#heading_host_service_groups}

::::: sectionbody
::: paragraph
Zur Verbesserung der Übersicht können Sie Hosts in
[Host-Gruppen](glossar.html#host_group) und Services in
[Service-Gruppen](glossar.html#service_group) organisieren. Dabei kann
ein Host/Service auch in mehreren Gruppen sein. Die Erstellung dieser
Gruppen ist optional und für die Konfiguration nicht notwendig. Haben
Sie aber z.B. die Ordnerstruktur nach geographischen Gesichtspunkten
aufgebaut, dann kann eine Host-Gruppe `Linux-Server` sinnvoll sein, die
alle Linux-Server zusammenfasst, egal an welchen Standorten diese
stehen.
:::

::: paragraph
Mehr zu Host-Gruppen erfahren Sie im Artikel über die [Strukturierung
der Hosts](hosts_structure.html#host_groups) und zu Service-Gruppen im
Artikel über [Services.](wato_services.html#service_groups)
:::
:::::
::::::

::::::::: sect1
## []{#contacts .hidden-anchor .sr-only}4. Kontakte und Kontaktgruppen {#heading_contacts}

:::::::: sectionbody
::: paragraph
[Kontakte](glossar.html#contact) und Kontaktgruppen bieten die
Möglichkeit, Hosts und Services Personen zuzuordnen. Ein Kontakt
entspricht einer Benutzerkennung der Weboberfläche. Die Zuordnung zu
Hosts und Services geschieht jedoch nicht direkt, sondern über
Kontaktgruppen.
:::

::: paragraph
Zunächst wird ein Kontakt (z.B. `harri`) einer Kontaktgruppe (z.B.
`linux-admins`) zugeordnet. Der Kontaktgruppe werden dann wieder Hosts
oder nach Bedarf auch einzelne Services zugeordnet. Dabei können sowohl
Benutzer als auch Hosts und Services jeweils mehreren Kontaktgruppen
zugeordnet sein.
:::

::: paragraph
Diese Zuordnung ist für mehrere Aspekte nützlich:
:::

::: {.olist .arabic}
1.  Wer darf was *sehen?*

2.  Wer darf welche Hosts und Services *konfigurieren und steuern?*

3.  Wer wird bei welchen Problemen *benachrichtigt?*
:::

::: paragraph
Der Benutzer `cmkadmin`, der beim Erzeugen einer Instanz automatisch
angelegt wird, darf übrigens immer alle Hosts und Services sehen, auch
wenn er kein Kontakt ist. Dies ist durch seine Rolle als Administrator
bedingt.
:::
::::::::
:::::::::

::::: sect1
## []{#users_roles .hidden-anchor .sr-only}5. Benutzer und Rollen {#heading_users_roles}

:::: sectionbody
::: paragraph
Während über Kontakte und Kontaktgruppen gesteuert wird, welche Personen
für einen bestimmten Host oder Service zuständig sind, werden die
Berechtigungen über *Rollen* gesteuert. Checkmk wird dabei mit einigen
vordefinierten Rollen ausgeliefert, von denen Sie später weitere Rollen
ableiten können. Jede Rolle definiert eine Reihe von Berechtigungen,
welche Sie anpassen können. Die Bedeutung der Standardrollen ist:
:::

+-------------+--------------------------------------------------------+
| Rolle       | Bedeutung                                              |
+=============+========================================================+
| `admin`     | Darf alles sehen und tun, hat alle Berechtigungen.     |
+-------------+--------------------------------------------------------+
| `user`      | Darf nur sehen, wofür er Kontakt ist. Darf Hosts       |
|             | verwalten in Ordnern, die ihm zugewiesen sind. Darf    |
|             | keine globalen Einstellungen machen.                   |
+-------------+--------------------------------------------------------+
| `agent_re   | Darf nur den                                           |
| gistration` | [Checkmk-Agenten](wato_monitoringagents.html#agents)   |
|             | eines Hosts beim Checkmk-Server registrieren --- sonst |
|             | nichts.                                                |
+-------------+--------------------------------------------------------+
| `guest`     | Darf alles sehen, aber nichts konfigurieren und auch   |
|             | nicht in das Monitoring eingreifen.                    |
+-------------+--------------------------------------------------------+
::::
:::::

::::::::::::::::::::::::::::::: sect1
## []{#_probleme_ereignisse_und_benachrichtigungen .hidden-anchor .sr-only}6. Probleme, Ereignisse und Benachrichtigungen {#heading__probleme_ereignisse_und_benachrichtigungen}

:::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#problems .hidden-anchor .sr-only}6.1. Bearbeitete und unbehandelte Probleme {#heading_problems}

::: paragraph
Checkmk bezeichnet jeden Host der nicht [UP]{.hstate0} und jeden
Service, der nicht [OK]{.state0} ist, als ein *Problem.* Dabei kann ein
Problem zwei Zustände haben: unbehandelt (*unhandled*) und bearbeitet
(*handled*). Der Ablauf ist so, dass ein neues Problem zunächst als
unbehandelt gilt. Sobald jemand das Problem im Monitoring bestätigt
(quittiert, *acknowledge*), gilt es als bearbeitet. Man könnte auch
sagen, dass die unbehandelten Probleme solche sind, um die sich noch
niemand gekümmert hat. Der [Overview](user_interface.html#overview) in
der Seitenleiste unterscheidet deswegen diese beiden Arten von
Problemen:
:::

:::: imageblock
::: content
![Snapin Overview im
Show-more-Modus.](../images/overview_more.png){width="50%"}
:::
::::

::: paragraph
Übrigens: Service-Probleme von Hosts, die gerade nicht [UP]{.hstate0}
sind, werden hier nicht als Problem angezeigt.
:::

::: paragraph
Weitere Details zu den Quittierungen finden Sie in einem [eigenen
Artikel.](basics_ackn.html)
:::
::::::::

::::::: sect2
### []{#notifications .hidden-anchor .sr-only}6.2. Benachrichtigungen {#heading_notifications}

::: paragraph
Wann immer sich der Zustand eines Hosts oder Services ändert (z.B. von
[OK]{.state0} auf [CRIT]{.state2}), spricht Checkmk von einem
*Monitoring-Ereignis.* So ein Ereignis kann --- muss aber nicht --- zu
einer [Benachrichtigung](glossar.html#notification) führen. Checkmk ist
so voreingestellt, dass im Falle eines Problems von einem Host oder
Service jeder Kontakt dieses Objekts per E-Mail benachrichtigt wird
(beachten Sie hierbei, dass der Benutzer `cmkadmin` erst einmal *kein*
Kontakt von irgendeinem Objekt ist). Dies kann aber sehr flexibel
angepasst werden. Auch hängen die Benachrichtigungen von einigen
Rahmenbedingungen ab. Am einfachsten ist es, wenn wir uns ansehen, in
welchen Fällen *nicht* benachrichtigt wird. Benachrichtigungen werden
unterdrückt, wenn:
:::

::: ulist
- Benachrichtigungen global im [Master
  control](user_interface.html#master_control) ausgeschaltet wurden,

- Benachrichtigungen bei dem Host/Service ausgeschaltet wurden,

- der jeweilige Zustand bei dem Host/Service für Benachrichtigungen
  abgeschaltet ist (z.B. keine Benachrichtigung bei [WARN]{.state1}),

- das Problem einen Service betrifft, dessen Host [DOWN]{.hstate1} oder
  [UNREACH]{.hstate2} ist,

- das Problem einen Host betrifft, dessen Parents alle [DOWN]{.hstate1}
  oder [UNREACH]{.hstate2} sind,

- für den Host/Service ein Benachrichtigungszeitraum (*notification
  period*) definiert wurde, der gerade nicht aktiv ist,

- der Host/Service gerade [unstetig](#flapping) [![icon
  flapping](../images/icons/icon_flapping.png)]{.image-inline}
  (*flapping*) ist,

- sich der Host/Service gerade in einer [Wartungszeit](#downtimes)
  (*scheduled downtime*) befindet.
:::

::: paragraph
Wenn keine dieser Bedingungen für eine Unterdrückung erfüllt ist,
erzeugt der Monitoring-Kern eine Benachrichtigung, welche dann im
zweiten Schritt eine Kette von Regeln durchläuft. Dort können Sie dann
noch weitere Ausschlusskriterien festlegen und entscheiden, wer auf
welchem Wege benachrichtigt werden soll (E-Mail, SMS etc.).
:::

::: paragraph
Alle Einzelheiten rund um die Benachrichtigungen finden Sie in einem
[eigenen Artikel](notifications.html).
:::
:::::::

:::: sect2
### []{#flapping .hidden-anchor .sr-only}6.3. Unstetige Hosts und Services (Flapping) {#heading_flapping}

::: paragraph
Manchmal kommt es vor, dass sich der Zustand von einem Service in kurzen
Abständen immer wieder ändert. Um ständige Benachrichtigungen zu
vermeiden, schaltet Checkmk so einen Service in den Zustand „unstetig"
(*flapping*). Dies wird durch das Symbol [![icon
flapping](../images/icons/icon_flapping.png)]{.image-inline}
illustriert. Wenn ein Service in diesen Flapping-Zustand eintritt, wird
eine Benachrichtigung generiert. Diese informiert, dass eben dieser
Zustand eingetreten ist, und danach ist Ruhe. Wenn für eine angemessene
Zeit kein weiterer Zustandswechsel geschieht --- sich also alles
beruhigt und endgültig zum Guten oder zum Schlechten gewendet
hat --- verschwindet dieser Zustand wieder und die normalen
Benachrichtigungen setzen wieder ein.
:::
::::

:::::::: sect2
### []{#downtimes .hidden-anchor .sr-only}6.4. Wartungszeiten (Scheduled downtimes) {#heading_downtimes}

::: paragraph
Wenn Sie an einem Server, Gerät oder an einer Software Wartungsarbeiten
vornehmen möchten, möchten Sie in der Regel Benachrichtigungen über
eventuelle Probleme in dieser Zeit vermeiden. Außerdem möchten Sie Ihren
Kollegen eventuell signalisieren, dass Probleme, die das Monitoring
anzeigt, vorübergehend ignoriert werden sollen.
:::

::: paragraph
Zu diesem Zweck können Sie zu einem Host oder Service Wartungszeiten
(*scheduled downtimes*) eintragen. Diese können Sie entweder direkt beim
Beginn der Arbeiten oder auch schon im Vorfeld eintragen. Wartungszeiten
werden durch Symbole illustriert:
:::

+---+-------------------------------------------------------------------+
| [ | Der Service befindet sich in einer Wartungszeit.                  |
| ! |                                                                   |
| [ |                                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| r |                                                                   |
| A |                                                                   |
| n |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| g |                                                                   |
| e |                                                                   |
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| W |                                                                   |
| a |                                                                   |
| r |                                                                   |
| t |                                                                   |
| u |                                                                   |
| n |                                                                   |
| g |                                                                   |
| s |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| t |                                                                   |
| b |                                                                   |
| e |                                                                   |
| i |                                                                   |
| S |                                                                   |
| e |                                                                   |
| r |                                                                   |
| v |                                                                   |
| i |                                                                   |
| c |                                                                   |
| e |                                                                   |
| s |                                                                   |
| . |                                                                   |
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
| d |                                                                   |
| o |                                                                   |
| w |                                                                   |
| n |                                                                   |
| t |                                                                   |
| i |                                                                   |
| m |                                                                   |
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
| [ | Der Host befindet sich in einer Wartungszeit. Auch Services,      |
| ! | deren Host sich in einer Wartung befinden, werden mit diesem      |
| [ | Symbol gekennzeichnet.                                            |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| r |                                                                   |
| A |                                                                   |
| n |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| g |                                                                   |
| e |                                                                   |
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| W |                                                                   |
| a |                                                                   |
| r |                                                                   |
| t |                                                                   |
| u |                                                                   |
| n |                                                                   |
| g |                                                                   |
| s |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| t |                                                                   |
| b |                                                                   |
| e |                                                                   |
| i |                                                                   |
| H |                                                                   |
| o |                                                                   |
| s |                                                                   |
| t |                                                                   |
| s |                                                                   |
| . |                                                                   |
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
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| i |                                                                   |
| v |                                                                   |
| e |                                                                   |
| d |                                                                   |
| _ |                                                                   |
| d |                                                                   |
| o |                                                                   |
| w |                                                                   |
| n |                                                                   |
| t |                                                                   |
| i |                                                                   |
| m |                                                                   |
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

::: paragraph
Während ein Host oder Service in Wartungszeit ist,
:::

::: ulist
- werden keine Benachrichtigungen versendet,

- werden Probleme nicht im Snapin [Overview]{.guihint} angezeigt.
:::

::: paragraph
Auch wenn Sie später Auswertungen über die Verfügbarkeit von Hosts oder
Services machen möchten, ist es eine gute Idee Wartungszeiten
einzutragen. Diese können dann später bei der Berechnung berücksichtigt
werden.
:::
::::::::

:::::::::: sect2
### []{#stale .hidden-anchor .sr-only}6.5. Veraltete Hosts und Services (Stale) {#heading_stale}

::: paragraph
Wenn Sie eine Weile mit Checkmk gearbeitet haben, kann es passieren,
dass in Ihren Host- und Service-Ansichten Spinnennetze angezeigt werden.
Für Services sieht das dann zum Beispiel so aus:
:::

:::: imageblock
::: content
![Ansicht zweier Services im Zustand
stale.](../images/monitoring_basics_stale.png)
:::
::::

::: paragraph
Diese Spinnennetze symbolisieren den Zustand veraltet (*stale*). Sobald
es einen veralteten Host oder Service gibt, wird das auch im Snapin
[[Overview]{.guihint}](user_interface.html#overview) angezeigt, das um
die Spalte [Stale]{.guihint} erweitert wird.
:::

::: paragraph
Doch was bedeutet der Zustand *stale* genau? Generell wird ein Host oder
Service als *stale* gekennzeichnet, wenn Checkmk über eine längere
Zeitdauer keine aktuellen Informationen über dessen Zustand mehr
bekommt:
:::

::: ulist
- Ein Service wird *stale*: Fällt ein Agent oder auch nur ein
  Agentenplugin - aus welchen Gründen auch immer - über längere Zeit
  aus, so liefert der Agent keine aktuellen Daten mehr für die
  Auswertung. Services, deren Zustand von passiven Checks ermittelt
  wird, können nicht aktualisiert werden, da sie auf die Daten des
  Agenten angewiesen sind. Die Services verbleiben im jeweils letzten
  Zustand, werden aber nach Ablauf einer bestimmten Zeit als *stale*
  markiert.

- Ein Host wird *stale*: Liefert das [Host Check Command]{.guihint}, mit
  dem die Erreichbarkeit des Hosts überprüft wird, keine aktuelle
  Antwort, behält der Host den letzten ermittelten Zustand bei --- und
  wird dann aber als *stale* gekennzeichnet.
:::

::: paragraph
Sie können den Zeitraum anpassen, ab wann Hosts und Services *stale*
werden. Lesen Sie hierzu den Abschnitt über
[Check-Intervalle.](#checkinterval)
:::
::::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::

:::::::::: sect1
## []{#time_periods .hidden-anchor .sr-only}7. Zeiträume (Time periods) {#heading_time_periods}

::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![timeperiods](../images/timeperiods.png){width="8%"}
:::
::::

::: paragraph
Wöchentlich wiederkehrende Zeiträume kommen an verschiedenen Stellen in
der Konfiguration zum Einsatz. Ein typischer Zeitraum könnte
`work hours` heißen und die Zeiten von jeweils 8:00 bis 17:00 Uhr
beinhalten, an allen Wochentagen außer Samstag und Sonntag. Vordefiniert
ist der Zeitraum `24X7`, welcher einfach alle Zeiten einschließt.
Zeiträume können auch Ausnahmen für bestimmte Kalendertage
enthalten --- z.B. für die bayerischen Feiertage.
:::

::: paragraph
Einige wichtige Stellen, an denen Zeiträume zum Einsatz kommen, sind:
:::

::: ulist
- Begrenzung der Zeiten, innerhalb derer benachrichtigt wird
  (Benachrichtigungszeitraum, *notification period*).

- Begrenzung der Zeiten, innerhalb derer Checks ausgeführt werden
  ([Check-Zeitraum](#checkperiod), *check period*).

- Service-Zeiten für die Berechnung von Verfügbarkeit (Service-Zeitraum,
  *service period*).

- Zeiten, innerhalb derer bestimmte Regeln in der [Event
  Console](glossar.html#ec) greifen.
:::

::: paragraph
Wie Sie Zeiträume einstellen können, lesen Sie im Artikel [Zeitperioden
(Time Periods).](timeperiods.html)
:::
:::::::::
::::::::::

::::::::::::::::::: sect1
## []{#check_period_interval_attempt .hidden-anchor .sr-only}8. Check-Zeiträume, Check-Intervalle und Check-Versuche {#heading_check_period_interval_attempt}

:::::::::::::::::: sectionbody
:::: sect2
### []{#checkperiod .hidden-anchor .sr-only}8.1. Check-Zeiträume festlegen {#heading_checkperiod}

::: paragraph
Sie können die Zeiträume einschränken, in denen Checks ausgeführt
werden. Dazu dienen die Regelsätze [Check period for hosts]{.guihint},
[Check period for active services]{.guihint} und [Check period for
passive Checkmk services.]{.guihint} Mit diesen Regeln wählen Sie einen
der verfügbaren [Zeiträume](#time_periods) (*time periods*) als
Check-Zeitraum (*check period*) aus.
:::
::::

::::::::::: sect2
### []{#checkinterval .hidden-anchor .sr-only}8.2. Check-Intervalle einstellen {#heading_checkinterval}

::: paragraph
Das Ausführen von Checks geschieht beim zustandsbasierten Monitoring in
festen Intervallen. Checkmk verwendet als Standard für Service-Checks
eine Minute, für Host-Checks mit Smart Ping 6 Sekunden.
:::

::: paragraph
Mit Hilfe der Regelsätze [Normal check interval for service
checks]{.guihint} und [Normal check interval for host checks]{.guihint}
kann dies geändert werden:
:::

::: ulist
- Auf einen längeren Wert, um CPU-Ressourcen auf dem Checkmk-Server und
  dem Zielsystem zu sparen.

- Auf einen kürzeren Wert, um schneller Benachrichtigungen zu bekommen
  und Messdaten in einer höheren Auflösung einzusammeln.
:::

::: paragraph
Kombinieren Sie nun einen Check-Zeitraum mit einem Check-Intervall, so
können Sie dafür sorgen, dass ein aktiver Check genau einmal am Tag zu
einer ganz bestimmten Zeit ausgeführt wird. Setzen Sie z.B. das
Check-Intervall auf 24 Stunden und den Check-Zeitraum auf 2:00 bis 2:01
Uhr an jedem Tag (also nur eine Minute pro Tag), dann wird Checkmk dafür
sorgen, dass der Check auch wirklich in dieses kurze Zeitfenster
verschoben wird.
:::

::: paragraph
Der Zustand der Services wird außerhalb des festgelegten Check-Zeitraums
nicht mehr aktualisiert und die Services werden dann mit dem Symbol
[![icon stale](../images/icons/icon_stale.png)]{.image-inline} als
[veraltet (*stale*)](#stale) gekennzeichnet. Mit der globalen
Einstellung [Staleness value to mark hosts / services stale]{.guihint}
können Sie definieren, wie viel Zeit vergehen soll, bis ein Host/Service
auf *stale* geht. Diese Einstellung finden Sie unter [Setup \> General
\> Global settings \> User interface:]{.guihint}
:::

:::: imageblock
::: content
![Festlegung des Faktors für
Staleness.](../images/monitoring_basics_staleness.png)
:::
::::

::: paragraph
Dieser Faktor stellt das **n**-fache des Check-Intervalls dar. Ist also
Ihr Check-Intervall auf eine Minute (60 Sekunden) eingestellt, so geht
ein Service, für den es keine neuen Check-Ergebnisse gibt, nach der
1,5-fachen Zeit, somit nach 90 Sekunden, auf *stale*.
:::
:::::::::::

:::::: sect2
### []{#max_check_attempts .hidden-anchor .sr-only}8.3. Check-Versuche anpassen {#heading_max_check_attempts}

::: paragraph
Mit Hilfe der Check-Versuche (*check attempts*) können Sie
Benachrichtigungen bei sporadischen Fehlern vermeiden. Sie machen einen
Check damit quasi weniger sensibel. Dazu können Sie die Regelsätze
[Maximum number of check attempts for host]{.guihint} und [Maximum
number of check attempts for service]{.guihint} nutzen.
:::

::: paragraph
Sind die Check-Versuche z.B. auf 3 eingestellt, und der entsprechende
Service wird [CRIT]{.state2}, dann wird zunächst noch keine
Benachrichtigung ausgelöst. Erst wenn auch die nächsten beiden Checks
ein Resultat liefern, das nicht [OK]{.state0} ist, steigt die Nummer des
aktuellen Versuchs auf 3 und die Benachrichtigung wird versendet.
:::

::: paragraph
Ein Service, der sich in diesem Zwischenzustand befindet --- also nicht
[OK]{.state0} ist, aber die maximalen Anzahl der Check-Versuche noch
nicht erreicht hat --- hat einen „weichen Zustand" (*soft state*). Nur
ein „harter Zustand" (*hard state*) löst eine Benachrichtigung aus.
:::
::::::
::::::::::::::::::
:::::::::::::::::::

::::: sect1
## []{#_übersicht_über_die_wichtigsten_host_und_service_symbole .hidden-anchor .sr-only}9. Übersicht über die wichtigsten Host- und Service-Symbole {#heading__übersicht_über_die_wichtigsten_host_und_service_symbole}

:::: sectionbody
::: paragraph
Folgende Tabelle gibt eine kurze Übersicht der wichtigsten Symbole, die
Sie neben Hosts und Services finden:
:::

+---+-------------------------------------------------------------------+
| [ | Dieser Service ist in einer Wartungszeit.                         |
| ! |                                                                   |
| [ |                                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| r |                                                                   |
| A |                                                                   |
| n |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| g |                                                                   |
| e |                                                                   |
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| W |                                                                   |
| a |                                                                   |
| r |                                                                   |
| t |                                                                   |
| u |                                                                   |
| n |                                                                   |
| g |                                                                   |
| s |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| t |                                                                   |
| b |                                                                   |
| e |                                                                   |
| i |                                                                   |
| S |                                                                   |
| e |                                                                   |
| r |                                                                   |
| v |                                                                   |
| i |                                                                   |
| c |                                                                   |
| e |                                                                   |
| s |                                                                   |
| . |                                                                   |
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
| d |                                                                   |
| o |                                                                   |
| w |                                                                   |
| n |                                                                   |
| t |                                                                   |
| i |                                                                   |
| m |                                                                   |
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
| [ | Dieser Host ist in einer Wartungszeit. Auch Services, deren Host  |
| ! | sich in einer Wartung befindet, werden mit diesem Symbol          |
| [ | gekennzeichnet.                                                   |
| S |                                                                   |
| y |                                                                   |
| m |                                                                   |
| b |                                                                   |
| o |                                                                   |
| l |                                                                   |
| z |                                                                   |
| u |                                                                   |
| r |                                                                   |
| A |                                                                   |
| n |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| g |                                                                   |
| e |                                                                   |
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| W |                                                                   |
| a |                                                                   |
| r |                                                                   |
| t |                                                                   |
| u |                                                                   |
| n |                                                                   |
| g |                                                                   |
| s |                                                                   |
| z |                                                                   |
| e |                                                                   |
| i |                                                                   |
| t |                                                                   |
| b |                                                                   |
| e |                                                                   |
| i |                                                                   |
| H |                                                                   |
| o |                                                                   |
| s |                                                                   |
| t |                                                                   |
| s |                                                                   |
| . |                                                                   |
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
| d |                                                                   |
| e |                                                                   |
| r |                                                                   |
| i |                                                                   |
| v |                                                                   |
| e |                                                                   |
| d |                                                                   |
| _ |                                                                   |
| d |                                                                   |
| o |                                                                   |
| w |                                                                   |
| n |                                                                   |
| t |                                                                   |
| i |                                                                   |
| m |                                                                   |
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
| [ | Dieser Host/Service ist gerade außerhalb seines                   |
| ! | Benachrichtigungszeitraums.                                       |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| o |                                                                   |
| u |                                                                   |
| t |                                                                   |
| o |                                                                   |
| f |                                                                   |
| n |                                                                   |
| o |                                                                   |
| t |                                                                   |
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
| o |                                                                   |
| u |                                                                   |
| t |                                                                   |
| o |                                                                   |
| f |                                                                   |
| n |                                                                   |
| o |                                                                   |
| t |                                                                   |
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
| [ | Benachrichtigungen für diesen Host/Service sind gerade            |
| ! | abgeschaltet.                                                     |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| n |                                                                   |
| o |                                                                   |
| t |                                                                   |
| i |                                                                   |
| f |                                                                   |
| m |                                                                   |
| a |                                                                   |
| n |                                                                   |
| d |                                                                   |
| i |                                                                   |
| s |                                                                   |
| a |                                                                   |
| b |                                                                   |
| l |                                                                   |
| e |                                                                   |
| d |                                                                   |
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
| n |                                                                   |
| o |                                                                   |
| t |                                                                   |
| i |                                                                   |
| f |                                                                   |
| _ |                                                                   |
| m |                                                                   |
| a |                                                                   |
| n |                                                                   |
| _ |                                                                   |
| d |                                                                   |
| i |                                                                   |
| s |                                                                   |
| a |                                                                   |
| b |                                                                   |
| l |                                                                   |
| e |                                                                   |
| d |                                                                   |
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
| [ | Checks dieses Services sind gerade abgeschaltet.                  |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| d |                                                                   |
| i |                                                                   |
| s |                                                                   |
| a |                                                                   |
| b |                                                                   |
| l |                                                                   |
| e |                                                                   |
| d |                                                                   |
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
| d |                                                                   |
| i |                                                                   |
| s |                                                                   |
| a |                                                                   |
| b |                                                                   |
| l |                                                                   |
| e |                                                                   |
| d |                                                                   |
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
| [ | Der Zustand dieses Hosts/Services ist veraltet (stale).           |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| s |                                                                   |
| t |                                                                   |
| a |                                                                   |
| l |                                                                   |
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
| s |                                                                   |
| t |                                                                   |
| a |                                                                   |
| l |                                                                   |
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
| [ | Der Zustand dieses Hosts/Services ist unstetig (flapping).        |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| f |                                                                   |
| l |                                                                   |
| a |                                                                   |
| p |                                                                   |
| p |                                                                   |
| i |                                                                   |
| n |                                                                   |
| g |                                                                   |
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
| f |                                                                   |
| l |                                                                   |
| a |                                                                   |
| p |                                                                   |
| p |                                                                   |
| i |                                                                   |
| n |                                                                   |
| g |                                                                   |
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
| [ | Dieser Host/Service hat ein Problem, das bestätigt wurde.         |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| a |                                                                   |
| c |                                                                   |
| k |                                                                   |
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
| a |                                                                   |
| c |                                                                   |
| k |                                                                   |
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
| [ | Zu diesem Host/Service gibt es einen Kommentar.                   |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| o |                                                                   |
| m |                                                                   |
| m |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
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
| m |                                                                   |
| m |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
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
| [ | Dieser Host/Service ist Teil einer BI-Aggregat.                   |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| a |                                                                   |
| g |                                                                   |
| g |                                                                   |
| r |                                                                   |
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
| a |                                                                   |
| g |                                                                   |
| g |                                                                   |
| r |                                                                   |
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
| [ | Hier gelangen Sie direkt zur Einstellung der Check-Parameter.     |
| ! |                                                                   |
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
| p |                                                                   |
| a |                                                                   |
| r |                                                                   |
| a |                                                                   |
| m |                                                                   |
| e |                                                                   |
| t |                                                                   |
| e |                                                                   |
| r |                                                                   |
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
| _ |                                                                   |
| p |                                                                   |
| a |                                                                   |
| r |                                                                   |
| a |                                                                   |
| m |                                                                   |
| e |                                                                   |
| t |                                                                   |
| e |                                                                   |
| r |                                                                   |
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
| [ | Nur bei Logwatch-Services: Hier gelangen Sie zu den gespeicherten |
| ! | Log-Dateien.                                                      |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| l |                                                                   |
| o |                                                                   |
| g |                                                                   |
| w |                                                                   |
| a |                                                                   |
| t |                                                                   |
| c |                                                                   |
| h |                                                                   |
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
| l |                                                                   |
| o |                                                                   |
| g |                                                                   |
| w |                                                                   |
| a |                                                                   |
| t |                                                                   |
| c |                                                                   |
| h |                                                                   |
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
| [ | Hier gelangen Sie zum Zeitverlauf der aufgezeichneten Messwerte.  |
| ! |                                                                   |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| p |                                                                   |
| n |                                                                   |
| p |                                                                   |
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
| p |                                                                   |
| n |                                                                   |
| p |                                                                   |
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
| [ | Dieser Host besitzt HW/SW-Inventurdaten. Ein Klickt bringt Sie zu |
| ! | deren Ansicht.                                                    |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| i |                                                                   |
| n |                                                                   |
| v |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
| o |                                                                   |
| r |                                                                   |
| y |                                                                   |
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
| i |                                                                   |
| n |                                                                   |
| v |                                                                   |
| e |                                                                   |
| n |                                                                   |
| t |                                                                   |
| o |                                                                   |
| r |                                                                   |
| y |                                                                   |
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
| [ | Bei diesem Check ist ein Fehler aufgetreten. Über einen Klick     |
| ! | können Sie einen Fehlerreport einsehen und absenden.              |
| [ |                                                                   |
| i |                                                                   |
| c |                                                                   |
| o |                                                                   |
| n |                                                                   |
| c |                                                                   |
| r |                                                                   |
| a |                                                                   |
| s |                                                                   |
| h |                                                                   |
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
| r |                                                                   |
| a |                                                                   |
| s |                                                                   |
| h |                                                                   |
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
::::
:::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
