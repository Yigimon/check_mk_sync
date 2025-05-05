:::: {#header}
# Das Monitoring einrichten

::: details
[Last modified on 03-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_setup_monitor.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Monitoring-Werkzeuge](intro_tools.html) [Verwaltung der
Hosts](hosts_setup.html) [Linux überwachen](agent_linux.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#hosts .hidden-anchor .sr-only}1. Hosts, Services und Agenten {#heading_hosts}

:::::: sectionbody
::: paragraph
So, Checkmk steht bereit. Doch bevor wir mit dem eigentlichen Monitoring
beginnen, werden wir kurz einige wichtige Begriffe erläutern. Das
beginnt mit dem **Host**: Ein Host ist in Checkmk jedes eigenständige,
physische oder virtuelle System, das von Checkmk überwacht wird. In der
Regel handelt es sich um Dinge mit eigener IP-Adresse (Server, Switches,
SNMP-Geräte, virtuelle Maschinen), aber auch um beispielsweise Docker
Container oder andere logische Objekte ohne eine solche IP-Adresse.
Jeder Host hat immer einen der Zustände [UP]{.hstate0},
[DOWN]{.hstate1}, [UNREACH]{.hstate2} oder [PEND]{.statep}.
:::

::: paragraph
Auf jedem Host wird eine Anzahl von **Services** überwacht. Ein Service
kann dabei alles Mögliche sein, zum Beispiel ein Dateisystem, ein
Prozess, ein Hardware-Sensor, ein Switchport --- aber auch einfach nur
eine bestimmte Metrik wie die CPU-Auslastung oder die RAM-Nutzung. Jeder
Service hat einen der Zustände [OK]{.state0}, [WARN]{.state1},
[CRIT]{.state2}, [UNKNOWN]{.state3} oder [PEND]{.statep}.
:::

::: paragraph
Damit Checkmk von einem Host Daten abfragen kann, ist ein **Agent**
notwendig. Das ist ein kleines Programm, das auf dem Host installiert
wird, und auf Anfrage Daten über den Zustand (oder die „Gesundheit") des
Hosts liefert. Server, auf denen Windows, Linux oder Unix läuft, können
von Checkmk nur dann sinnvoll überwacht werden, wenn Sie dort einen von
uns gelieferten Checkmk-Agenten installieren. Bei Netzwerkgeräten und
vielen Appliances hat meist der Hersteller bereits einen Agenten
eingebaut, den Checkmk ohne Weiteres mit dem standardisierten Protokoll
SNMP abfragen kann. Cloud-Dienste wie Amazon Web Services (AWS) oder
Azure stellen stattdessen eine Schnittstelle („API") bereit, die von
Checkmk per HTTP abgefragt werden kann.
:::
::::::
:::::::

:::::: sect1
## []{#dns .hidden-anchor .sr-only}2. Vorüberlegungen zu DNS {#heading_dns}

::::: sectionbody
::: paragraph
Auch wenn Checkmk keine Namensauflösung von Hosts voraussetzt,
erleichtert ein gut gepflegtes Domain Name System (DNS) die
Konfiguration erheblich und vermeidet Fehler, denn Checkmk kann dann die
Namen der Hosts selbständig auflösen, ohne dass Sie IP-Adressen in
Checkmk eintragen müssen.
:::

::: paragraph
Der Aufbau des Monitorings ist daher ein guter Anlass, zu überprüfen, ob
Ihr DNS auf dem neuesten Stand ist und gegebenenfalls dort fehlende
Einträge zu ergänzen.
:::
:::::
::::::

:::::::::::::: sect1
## []{#folders .hidden-anchor .sr-only}3. Ordnerstruktur für Hosts {#heading_folders}

::::::::::::: sectionbody
::: paragraph
Checkmk verwaltet Ihre Hosts in einem hierarchischen Baum von
Ordnern --- ganz analog zu dem, was Sie von Dateien in Ihrem
Betriebssystem kennen. Wenn Sie nur eine Handvoll Hosts überwachen, mag
das für Sie weniger wichtig sein. Aber erinnern Sie sich: Checkmk ist
für das Überwachen von Tausenden und Zigtausenden Hosts
geschaffen --- und dabei ist Ordnung die halbe Miete.
:::

::: paragraph
Bevor Sie die ersten Hosts in Checkmk aufnehmen, ist es daher von
Vorteil, wenn Sie sich Gedanken über die Struktur dieser Ordner machen.
Die Ordnerstruktur ist zum einen für Ihre eigene Übersicht nützlich.
Wichtiger aber ist, dass sie für die Konfiguration von Checkmk verwendet
werden kann: Alle Konfigurationsattribute von Hosts können in einem
Ordner definiert werden, die dann automatisch an die dort enthaltenen
Unterordner und Hosts **vererbt** werden. Daher ist es nicht nur, aber
insbesondere für die Konfiguration großer Umgebungen elementar, von
Beginn an eine wohlüberlegte Ordnerstruktur aufzusetzen.
:::

::: paragraph
Eine einmal erstellte Ordnerstruktur können Sie verändern --- müssen
dabei allerdings sehr gewissenhaft vorgehen. Das Verschieben eines Hosts
in einen anderen Ordner kann nämlich zur Folge haben, dass sich dessen
Attribute ändern, ohne dass Sie sich dessen vielleicht bewusst sind.
:::

::: paragraph
Die eigentliche Frage beim Aufbau einer für Sie sinnvollen
Ordnerstruktur ist, nach welchen Kriterien Sie die Ordner organisieren
möchten. Die Kriterien können in jeder Ebene des Baums andere sein. So
können Sie z.B. in der ersten Ebene nach Standorten unterscheiden und in
der zweiten Ebene nach Technologie.
:::

::: paragraph
Folgende Ordnungskriterien haben sich in der Praxis bewährt:
:::

::: ulist
- Standort/Geografie

- Organisation

- Technologie
:::

::: paragraph
Eine Sortierung nach Standort ist vor allem in größeren Unternehmen sehr
naheliegend, insbesondere dann, wenn Sie das Monitoring über mehrere
Checkmk-Server verteilen. Jeder Server überwacht dann z.B. eine Region
oder ein Land. Wenn Ihre Ordner diese Aufteilung abbilden, dann können
Sie z.B. im Ordner „München" definieren, dass alle Hosts in diesem
Ordner von der Checkmk-Instanz „muc" aus überwacht werden sollen.
:::

::: paragraph
Alternativ dazu kann die Organisation (d.h. die Antwort auf die Frage
\"Wer ist für einen Host zuständig?") ein sinnvolleres Kriterium sein,
denn nicht immer ist Standort und Verantwortung das Gleiche. So mag es
sein, dass eine Gruppe Ihrer Kollegen für die Administration von Oracle
zuständig ist, und zwar unabhängig davon, an welchem Standort die
entsprechenden Hosts stehen. Ist also z.B. der Ordner „Oracle" für die
Hosts der Oracle-Kollegen vorgesehen, so ist es in Checkmk einfach zu
konfigurieren, dass alle Hosts unterhalb dieses Ordners nur für diese
Kollegen sichtbar sind und, dass diese ihre Hosts dort sogar selbst
pflegen können.
:::

::: paragraph
Eine Strukturierung nach Technologie könnte z.B. einen Ordner für
Windows-Server und einen für Linux-Server vorsehen. Das würde die
Umsetzung des Schemas „Auf allen Linux-Servern muss der Prozess `sshd`
laufen." vereinfachen. Ein anderes Beispiel ist die Überwachung von
Geräten via SNMP, wie beispielsweise Switches oder Router. Hier kommt
kein Checkmk-Agent zum Einsatz, sondern die Geräte werden über das
Protokoll SNMP abgefragt. Sind diese Hosts in eigenen Ordnern
zusammengefasst, so können Sie direkt am Ordner die für SNMP notwendigen
Einstellungen wie etwa die „Community" vornehmen.
:::

::: paragraph
Da eine Ordnerstruktur nur in seltenen Fällen die Komplexität der
Wirklichkeit abbilden kann, bietet Checkmk mit den Host-Merkmalen (*host
tags*) eine weitere ergänzende Möglichkeit zur Strukturierung: doch dazu
in einem [anderen Kapitel](intro_finetune.html#host_tags) mehr.
Weiterführende Informationen zur Ordnerstruktur finden Sie in den
Artikeln über die [Verwaltung](hosts_setup.html#folder) und die
[Strukturierung](hosts_structure.html#folder) von Hosts.
:::
:::::::::::::
::::::::::::::

:::::::::::::::::::: sect1
## []{#create_folders .hidden-anchor .sr-only}4. Ordner erstellen {#heading_create_folders}

::::::::::::::::::: sectionbody
::: paragraph
Den Einstieg in die Verwaltung von Ordnern und Hosts finden Sie über die
Navigationsleiste, das [Setup]{.guihint}-Menü, das Thema
[Hosts]{.guihint} und den Eintrag [Hosts]{.guihint} --- oder kürzer über
[Setup \> Hosts \> Hosts.]{.guihint} Dann wird die Seite
[Main]{.guihint} angezeigt:
:::

:::: imageblock
::: content
![Ordneransicht \'Main\' ohne Ordner und
Hosts.](../images/intro_empty_main.png)
:::
::::

::: paragraph
Bevor wir den ersten Ordner erstellen, werden wir kurz auf den Aufbau
dieser Seite eingehen, da Sie die verschiedenen Elemente auf den meisten
Checkmk-Seiten so oder so ähnlich wiederfinden werden. Unterhalb des
Seitentitels [Main]{.guihint} finden Sie den Breadcrumb-Pfad, der Ihnen
zeigt, wo Sie sich innerhalb der Checkmk-Oberfläche gerade befinden.
Darunter wird die Menüleiste angezeigt, die die möglichen Aktionen auf
dieser Seite in Menüs und Menüeinträgen zusammenfasst. Die Menüs sind in
Checkmk stets kontext-spezifisch, d.h. sie finden nur Menüeinträge für
Aktionen, die auf der aktuellen Seite Sinn ergeben.
:::

::: paragraph
Unter der Menüleiste finden Sie die Aktionsleiste, in der die
wichtigsten Aktionen aus den Menüs als Knöpfe zum direkten Anklicken
angeboten werden. Die Aktionsleiste können Sie mit dem Knopf [![Symbol
zum Ausblenden der
Aktionsleiste.](../images/icons/button_hide_toolbar.png)]{.image-inline}
rechts neben dem [Help]{.guihint}-Menü ausblenden und mit [![Symbol zum
Einblenden der
Aktionsleiste.](../images/icons/button_show_toolbar.png)]{.image-inline}
wieder einblenden. Bei ausgeblendeter Aktionsleiste werden die Symbole
in der Menüleiste rechts neben [![Symbol zum Einblenden der
Aktionsleiste.](../images/icons/button_show_toolbar.png)]{.image-inline}
angezeigt.
:::

::: paragraph
Da wir uns zurzeit auf einer leeren Seite befinden (ohne Ordner und ohne
Hosts), werden die wichtigen Aktionen zum Erstellen des ersten Objekts
zusätzlich über noch größere Knöpfe angeboten --- damit die
Möglichkeiten auch nicht übersehen werden, die die Seite bietet. Diese
Knöpfe werden nach dem Erstellen des ersten Objekts verschwinden.
:::

::: paragraph
Nun aber zurück zum Thema, weswegen wir uns eigentlich auf dieser Seite
befinden: dem Anlegen von Ordnern. *Einen* Ordner --- den
Hauptordner --- gibt es in jedem frisch aufgesetzten Checkmk-System. Er
heißt [Main]{.guihint}, wie Sie im Titel der Seite sehen können.
Unterhalb des Hauptordners werden wir nun für ein einfaches Beispiel die
drei Ordner `Windows`, `Linux` und `Network` erstellen.
:::

::: paragraph
Legen Sie den ersten der drei Ordner an, indem Sie eine der angebotenen
Aktionen zum Erstellen eines Ordners auswählen, z.B. den Aktionsknopf
[![Symbol zum Erstellen eines
Ordners.](../images/icons/icon_newfolder.png)]{.image-inline} [Add
folder]{.guihint}. Auf der neuen Seite [Add folder]{.guihint} tragen Sie
im ersten Kasten [Basic settings]{.guihint} den Ordnernamen ein:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften beim Erstellen eines Ordners: die \'Basic
settings\' mit Titel.](../images/intro_folder_basic_settings.png)
:::
::::

::: paragraph
Im obigen Bild ist der [Show-less-Modus](intro_gui.html#show_less_more)
aktiv und es wird nur derjenige Eintrag angezeigt, der zum Erstellen
eines Ordners unbedingt notwendig ist. Bestätigen Sie die Eingabe mit
[Save]{.guihint}.
:::

::: paragraph
Erstellen Sie analog zum Ordner `Windows` die anderen beiden Ordner
`Linux` und `Network`. Danach sieht die Situation so aus:
:::

:::: imageblock
::: content
![Ansicht \'Main\' mit drei Ordnern, einer davon aufgeklappt mit
Symbolen für Ordneraktionen.](../images/intro_three_empty_folders.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie mit der Maus auf den     |
|                                   | Reiter oder den oberen Bereich    |
|                                   | eines Ordner-Symbols zeigen,      |
|                                   | klappt der Ordner auf und         |
|                                   | enthüllt die Symbole, die Sie     |
|                                   | benötigen, um wichtige Aktionen   |
|                                   | mit dem Ordner auszuführen (die   |
|                                   | Eigenschaften ändern, den Ordner  |
|                                   | verschieben oder ihn löschen).    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
**Noch ein Tipp:** Rechts oben auf jeder Seite finden Sie die
Information, ob --- und wenn ja, wie viele --- Änderungen inzwischen
bereits aufgelaufen sind. Da wir drei Ordner erstellt haben, gibt es
drei Änderungen, die jetzt aber noch nicht aktiviert werden müssen. Wir
werden uns mit dem Aktivieren von Änderungen weiter unten genauer
beschäftigen.
:::
:::::::::::::::::::
::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#linux .hidden-anchor .sr-only}5. Den ersten Host aufnehmen {#heading_linux}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Jetzt ist alles dafür vorbereitet, um den ersten Host in das Monitoring
aufzunehmen --- und was wäre naheliegender, als den Checkmk-Server
selbst zu überwachen? Natürlich wird dieser nicht seinen eigenen
Totalausfall melden können, aber nützlich ist das trotzdem, denn Sie
erhalten so nicht nur eine Übersicht über die CPU- und RAM-Nutzung,
sondern auch etliche Metriken und Checks, die das Checkmk-System selbst
betreffen.
:::

::: paragraph
Das Vorgehen zum Aufnehmen eines Linux-Hosts (wie übrigens auch eines
Windows-Hosts) ist im Prinzip stets das Folgende:
:::

::: {.olist .arabic}
1.  Agent herunterladen

2.  Agent installieren

3.  Host erstellen

4.  Host registrieren
:::

::: paragraph
Nachdem der Host in der
[Konfigurationsumgebung](glossar.html#configuration_environment)
erstellt wurde, werden zum Abschluss noch die Services konfiguriert und
die Änderungen für die
[Monitoring-Umgebung](glossar.html#monitoring_environment) aktiviert.
:::

:::::::::: sect2
### []{#download_agent .hidden-anchor .sr-only}5.1. Agent herunterladen {#heading_download_agent}

::: paragraph
Da der Checkmk-Server ein Linux-Rechner ist, benötigen Sie den
Checkmk-Agenten für Linux.
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} In Checkmk Raw
finden Sie die vorkonfigurierten Linux-Pakete des Agenten über [Setup \>
Agents \> Linux:]{.guihint}
:::

::::: imageblock
::: content
![Download-Seite mit den
RPM/DEB-Paketen.](../images/intro_agent_download_cre.png)
:::

::: title
Die Download-Seite von Checkmk Raw für die Linux-Pakete
:::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen gelangen Sie mit [Setup \> Agents \> Windows,
Linux, Solaris, AIX]{.guihint} zu einer Seite, die Ihnen auch den Zugang
zur [Agentenbäckerei](glossar.html#agent_bakery) (*Agent Bakery*)
bietet, mit der Sie sich individuell konfigurierte Agentenpakete
„backen" können. Von dieser Seite aus kommen Sie mit dem Menüeintrag
[Related \> Linux, Solaris, AIX files]{.guihint} zur Seite mit den
Agentendateien wie in Checkmk Raw.
:::

::: paragraph
Laden Sie die Paketdatei herunter: Wählen Sie das RPM-Dateiformat für
Red Hat Enterprise Linux (RHEL) basierte Systeme und SLES oder das
DEB-Dateiformat für Debian und Ubuntu.
:::
::::::::::

:::::::::::::: sect2
### []{#install_agent .hidden-anchor .sr-only}5.2. Agent installieren {#heading_install_agent}

::: paragraph
Für das folgende Installationsbeispiel nehmen wir an, dass sich die
heruntergeladene Paketdatei im Verzeichnis `/tmp/` befindet. Falls Sie
die Datei in ein anderes Verzeichnis heruntergeladen haben, ersetzen Sie
im folgenden Installationskommando das Verzeichnis `/tmp/` mit eben
diesem Verzeichnis. Ähnliches gilt für den Namen der Paketdatei, den Sie
mit dem Namen der von Ihnen heruntergeladene Datei ersetzen.
:::

::: paragraph
Die Paketdatei wird nur während der Installation benötigt. Sie können
sie nach der Installation löschen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In unserem Beispiel wird der      |
|                                   | Agent auf dem Checkmk-Server      |
|                                   | installiert, d.h. Sie brauchen    |
|                                   | die Paketdatei nicht auf einen    |
|                                   | anderen Rechner zu kopieren.      |
|                                   | Falls sich die heruntergeladene   |
|                                   | Datei nicht auf dem Ziel-Host für |
|                                   | die Installation des Agenten      |
|                                   | befinden sollte, müssen Sie die   |
|                                   | Datei zuerst auf den Ziel-Host    |
|                                   | kopieren, zum Beispiel mit dem    |
|                                   | Kommandozeilentool `scp`. Das     |
|                                   | passiert auf die gleiche Weise    |
|                                   | wie bei der Installation der      |
|                                   | Checkmk-Software und wie es für   |
|                                   | die Linux-Installation            |
|                                   | beschrieben ist, z.B. für die     |
|                                   | [Installation unter Debian und    |
|                                   | Ubunt                             |
|                                   | u](install_packages_debian.html). |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die Installation erfolgt als `root` auf der Kommandozeile, für die
RPM-Datei mit `rpm`, am besten mit der Option `-U`, die für *Update*
steht und dafür sorgt, dass die Installation auch dann fehlerlos
durchläuft, wenn bereits eine alte Version des Agenten installiert ist:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# rpm -U /tmp/check-mk-agent-2.3.0p1-1.noarch.rpm
```
:::
::::

::: paragraph
... oder für die DEB-Datei mit dem Befehl `dpkg -i`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# dpkg -i /tmp/check-mk-agent_2.3.0p1-1_all.deb
```
:::
::::

::: paragraph
Mit dem Agenten wird der Agent Controller installiert, mit dem unter
anderem bei der [Registrierung](#register) die TLS-Verschlüsselung der
Verbindung zum Checkmk-Server hergestellt wird. Damit die Installation
des Agent Controllers klappt, setzt dies eine Linux-Distribution mit dem
init-System `systemd` voraus, das seit 2015 in den meisten
Linux-Distributionen Standard ist. Für die seltenen Fälle, in denen der
Agent Controller nicht verwendet werden kann, finden Sie Informationen
im Artikel [Linux überwachen im Legacy-Modus.](agent_linux_legacy.html)
:::

::: paragraph
Damit ist die Installation des Agenten abgeschlossen. Die Kommandozeile
können Sie geöffnet lassen. Sie wird nochmal bei der Registrierung des
Hosts benötigt.
:::
::::::::::::::

::::::::::::::::: sect2
### []{#create_host .hidden-anchor .sr-only}5.3. Host erstellen {#heading_create_host}

::: paragraph
Nachdem der Agent auf dem Host installiert ist, können Sie den Host in
die Konfigurationsumgebung von Checkmk aufnehmen --- und zwar in den
vorbereiteten Ordner [Linux]{.guihint}. Nur zur Erinnerung: In diesem
Beispiel sind der Checkmk-Server und der zu überwachende Host identisch.
:::

::: paragraph
Öffnen Sie in der Checkmk-Oberfläche die gleiche Seite [Main]{.guihint},
auf der Sie bereits die drei Ordner erstellt haben: [Setup \> Hosts \>
Hosts]{.guihint}. Wechseln Sie dort in den Ordner [Linux]{.guihint},
indem Sie den Ordner anklicken.
:::

::: paragraph
Klicken Sie [Add host]{.guihint} und die Seite [Add host]{.guihint} wird
geöffnet:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften beim Erstellen eines
Hosts.](../images/intro_host_allsettings_less.png)
:::
::::

::: paragraph
Wie schon beim Anlegen der drei Ordner weiter oben ist immer noch der
[Show-less-Modus](intro_gui.html#show_less_more) aktiv. Daher zeigt
Checkmk im Formular nur die wichtigsten und zum Erstellen eines Hosts
notwendigen Host-Attribute an. Falls es Sie interessiert, können Sie
sich den Rest ansehen, indem Sie bei jedem der geöffneten Kästen die
drei Auslassungszeichen [![Symbol zum Wechsel in den
Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline}
anklicken und die beiden zugeklappten Kästen am Ende der Seite öffnen.
Wie am Anfang erwähnt, ist Checkmk ein komplexes System, das auf jede
Frage eine Antwort hat. Deswegen kann man bei einem Host (aber nicht nur
dort) auch sehr viel konfigurieren.
:::

::: paragraph
**Tipp:** Auf vielen Seiten --- auch auf dieser --- können Sie sich
zusätzlich Hilfetexte zu den Attributen anzeigen lassen. Wählen Sie dazu
im [Help]{.guihint}-Menü den Eintrag [Show inline help]{.guihint}. Die
gewählte Einstellung bleibt auch auf anderen Seiten aktiv, bis Sie die
Hilfe wieder abschalten. Das folgende Bild zeigt die Inline-Hilfe für
den Parameter [IPv4 address:]{.guihint}
:::

:::: imageblock
::: content
![Die Eigenschaften eines Hosts mit eingeblendeter Inline-Hilfe für die
IPv4-Adresse.](../images/intro_ipv4_inlinehelp.png)
:::
::::

::: paragraph
Aber nun zu den Eingaben, um den ersten Host zu erstellen. Sie müssen
nur ein einziges Feld ausfüllen, nämlich [Hostname]{.guihint} bei den
[Basic settings.]{.guihint}
:::

::: paragraph
Diesen Namen können Sie recht frei vergeben und er darf bis zu 253
Zeichen lang sein. Er darf aus Buchstaben, Ziffern, Punkten, Binde- und
Unterstrichen bestehen. Dabei sollten Sie aber wissen, dass der
Host-Name von zentraler Bedeutung ist, denn er dient im Monitoring an
allen Stellen als interne ID (oder Schlüssel) zur eindeutigen
Identifizierung des Hosts. Da er in Checkmk so wichtig ist und oft
genutzt wird, sollten Sie sich die Benamsung Ihrer Hosts gut überlegen.
Ein Host-Name kann später geändert werden, aber da dies ein aufwendiger
Vorgang ist, sollten Sie ihn vermeiden.
:::

::: paragraph
Am besten ist es, wenn der Host unter seinem Namen im DNS auflösbar ist.
Dann sind Sie mit diesem Formular auch schon fertig. Falls nicht, oder
falls Sie kein DNS verwenden möchten, können Sie die IP-Adresse aber
auch von Hand im Feld [IPv4 address]{.guihint} eintragen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Damit Checkmk immer stabil und    |
|                                   | performant laufen kann, unterhält |
|                                   | es einen eigenen Cache für die    |
|                                   | Auflösung der Host-Namen. Daher   |
|                                   | führt der Ausfall des             |
|                                   | DNS-Dienstes nicht zum Ausfall    |
|                                   | des Monitorings. Die Details zu   |
|                                   | Host-Namen, IP-Adressen und DNS   |
|                                   | finden Sie im [Artikel über die   |
|                                   | Verwaltung der                    |
|                                   | Hosts.](hosts_setup.html#dns)     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Ein Host muss in der Konfigurationsumgebung existieren, bevor er im
nächsten Schritt registriert werden kann. Schließen Sie also die
Erstellung des Hosts vorerst ab, indem Sie auf [Save & view
folder]{.guihint} klicken.
:::
:::::::::::::::::

::::::::::::: sect2
### []{#register .hidden-anchor .sr-only}5.4. Host registrieren {#heading_register}

::: paragraph
Mit der Registrierung des Hosts beim Checkmk-Server wird das
Vertrauensverhältnis zwischen beiden eingerichtet. Die Kommunikation
zwischen Host und Server erfolgt dann nur noch Transport Layer Security
(TLS) verschlüsselt.
:::

::: paragraph
Die Registrierung erfolgt durch Aufruf des Agent Controllers
`cmk-agent-ctl` als `root` auf der Kommandozeile. Für das Kommando
benötigen Sie die Namen des Checkmk-Servers (im Beispiel `myserver`),
der Checkmk-Instanz (`mysite`) und des Hosts (`localhost`), wie er
[soeben](#create_host) in Checkmk eingerichtet wurde. Komplettiert
werden die Optionen durch den Namen eines Checkmk-Benutzers mit Zugriff
auf die [REST-API.](rest_api.html) Dazu können Sie `cmkadmin` verwenden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# cmk-agent-ctl register --hostname localhost --server myserver --site mysite --user cmkadmin
```
:::
::::

::: paragraph
Waren die angegebenen Werte korrekt, werden Sie aufgefordert, die
Identität der Checkmk-Instanz zu bestätigen, zu der Sie die Verbindung
herstellen wollen. Das zu bestätigende Server-Zertifikat haben wir aus
Gründen der Übersichtlichkeit stark verkürzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
Attempting to register at myserver, port 8000. Server certificate details:

PEM-encoded certificate:
-----BEGIN CERTIFICATE-----
MIIC9zCCAd+gAwIBAgIUM7th5NaTjbkXVo1gMXVDC3XkX4QwDQYJKoZIhvcNAQEL
[...]
jbXj75+c48W2u4O0+KezRDIG/LdeVdk0Gq/kQQ8XmdqgObDU7mJKBArkuw==
-----END CERTIFICATE-----

Issued by:
   Site 'mysite' local CA
Issued to:
   mysite
Validity:
   From Mon, 25 Mar 2024 16:01:10 +0000
   To   Sat, 25 Mar 2034 16:01:10 +0000

Do you want to establish this connection? [Y/n]
> Y

Please enter password for 'cmkadmin'
> *****
Registration complete.
```
:::
::::

::: paragraph
Bestätigen Sie mit `Y` und geben Sie anschließend auf Anforderung das
Passwort des Benutzers `cmkadmin` ein, um den Vorgang abzuschließen.
:::

::: paragraph
Falls keine Fehlermeldung angezeigt wird, ist die verschlüsselte
Verbindung hergestellt. Über diese Verbindung werden alle Daten
komprimiert übertragen.
:::

::: paragraph
Nach diesem (vorerst letzten) Ausflug auf die Kommandozeile, geht es
wieder weiter in der Checkmk-Oberfläche.
:::
:::::::::::::

::::::::::::: sect2
### []{#diagnosis .hidden-anchor .sr-only}5.5. Diagnose {#heading_diagnosis}

::: paragraph
Murphys Gesetz („Alles, was schiefgehen kann, wird auch schiefgehen.")
kann leider auch von Checkmk nicht außer Kraft gesetzt werden.
Schiefgehen kann vor allem dann etwas, wenn man es zum ersten Mal
probiert. Daher sind gute Möglichkeiten zur Fehlerdiagnose wichtig.
:::

::: paragraph
Bereits bei der Erstellung eines Hosts bietet Checkmk an, nicht nur die
Eingaben (Host-Name und IP-Adresse) auf der Seite [Add host]{.guihint}
zu sichern, sondern zusätzlich die Verbindung zum Host zu testen. Nach
der kurzen Unterbrechung zur Registrierung werden wir diesen
Verbindungstest nun nachholen. Auf der Seite [Linux]{.guihint} klicken
Sie beim gerade erstellten Host auf das Symbol [![Symbol zum Bearbeiten
eines Listeneintrags.](../images/icons/icon_edit.png)]{.image-inline},
um die Host-Eigenschaften zu öffnen. In der Aktionsleiste der Seite
[Properties of host]{.guihint} finden Sie unter anderem den Knopf [Save
& run connection tests]{.guihint}. Klicken Sie auf diesen.
:::

::: paragraph
Die Seite [Test connection to host]{.guihint} wird angezeigt und Checkmk
versucht, den Host auf den verschiedensten Wegen zu erreichen. Für
Linux- und Windows-Hosts sind dabei nur die beiden oberen Kästen
interessant:
:::

:::: imageblock
::: content
![Ergebnis des Verbindungstests zum Host mit ping und mit Ausgabe des
Agenten.](../images/intro_host_diagnostics.png)
:::
::::

::: paragraph
Durch die Ausgabe im Kasten [Agent]{.guihint} erhalten Sie die
Gewissheit, dass Checkmk erfolgreich mit dem Agenten kommunizieren kann,
den Sie zuvor auf dem Host manuell installiert und registriert hatten.
:::

::: paragraph
In weiteren Kästen sehen Sie, wie Checkmk versucht, per SNMP Kontakt
aufzunehmen. Das führt in diesem Beispiel erwartbar zu SNMP-Fehlern, ist
aber sehr nützlich für Netzwerkgeräte, die wir weiter [unten](#snmp)
besprechen werden.
:::

::: paragraph
Auf dieser Seite können Sie im Kasten [Host Properties]{.guihint} bei
Bedarf eine andere IP-Adresse ausprobieren, den Test erneut durchführen
und die geänderte IP-Adresse mit [Save & go to host
properties]{.guihint} sogar direkt in die Host-Eigenschaften übernehmen.
:::

::: paragraph
Klicken Sie diesen Knopf (ob Sie die IP-Adresse geändert haben oder
nicht) und Sie landen wieder auf der Seite [Properties of
host]{.guihint}.
:::

::: paragraph
Weitere Möglichkeiten zur Diagnose finden Sie übrigens im Artikel zum
[Linux-Agenten.](agent_linux.html#test)
:::
:::::::::::::

:::::::::::::: sect2
### []{#services .hidden-anchor .sr-only}5.6. Die Services konfigurieren {#heading_services}

::: paragraph
Nachdem der Host selbst aufgenommen wurde, kommt das eigentlich
Interessante: die Konfiguration seiner Services. Auf der oben genannten
Seite der Host-Eigenschaften klicken Sie [Save & run service
discovery]{.guihint} und die Seite [Services of host]{.guihint} wird
angezeigt.
:::

::: paragraph
Auf dieser Seite legen Sie fest, welche Services Sie auf dem Host
überwachen möchten. Außerdem zeigt Ihnen der oberste Kasten an, ob bei
dem Host (= Datenquelle) Probleme erkannt wurden. Wenn der Agent auf dem
Host erreichbar ist und korrekt läuft, findet Checkmk automatisch eine
Reihe von Services und schlägt diese für das Monitoring vor (hier
gekürzt dargestellt):
:::

:::: imageblock
::: content
![Liste der auf dem Host gefundenen Services zur Aufnahme ins
Monitoring.](../images/intro_services_of_host.png)
:::
::::

::: paragraph
Für jeden dieser Services gibt es prinzipiell die folgenden
Möglichkeiten:
:::

::: ulist
- [Undecided]{.guihint} : Sie haben sich noch nicht entschieden, ob
  dieser Service überwacht werden soll.

- [Monitored]{.guihint} : Der Service wird überwacht.

- [Disabled]{.guihint} : Sie haben sich dafür entschieden, den Service
  grundsätzlich nicht zu überwachen.

- [Vanished]{.guihint} : Der Service wurde überwacht, existiert aber
  jetzt nicht mehr.
:::

::: paragraph
Die Seite zeigt alle Services nach diesen Kategorien in Tabellen an. Da
Sie noch keinen Service konfiguriert haben, sehen Sie nur die Tabelle
[Undecided]{.guihint}.
:::

::: paragraph
Wenn Sie auf [Monitor undecided services]{.guihint} klicken, werden alle
Services direkt in das Monitoring übernommen und alle
[Undecided]{.guihint} zu [Monitored]{.guihint} Services.
:::

::: paragraph
Umgekehrt können Services auch verschwinden, z.B. weil ein Dateisystem
entfernt wurde. Diese erscheinen dann im Monitoring als
[UNKNOWN]{.state3} und auf dieser Seite als [Vanished]{.guihint} und
können mit [Remove vanished services]{.guihint} aus dem Monitoring
entfernt werden.
:::

::: paragraph
Für den Anfang ist es am einfachsten, wenn Sie jetzt auf den Knopf
[Accept all]{.guihint} klicken, der alles auf einmal macht: fehlende
Services hinzufügen, verschwundene entfernen --- und zusätzlich
gefundene Änderungen an Host- und Service-[Labels](glossar.html#label)
übernehmen.
:::

::: paragraph
Sie können diese Seite jederzeit später aufrufen, um die Konfiguration
der Services anzupassen. Manchmal entstehen durch Änderungen an einem
Host neue Services, z.B. wenn Sie eine Logical Unit Number (LUN) als
Dateisystem einbinden oder eine neue Oracle Datenbankinstanz
konfigurieren. Diese Services erscheinen dann wieder als
[Undecided]{.guihint}, und Sie können sie einzeln oder alle auf einmal
in das Monitoring aufnehmen.
:::
::::::::::::::

::::::::::: sect2
### []{#activate_changes .hidden-anchor .sr-only}5.7. Änderungen aktivieren {#heading_activate_changes}

::: paragraph
Checkmk speichert alle Änderungen, die Sie vornehmen, zunächst nur in
einer vorläufigen „Konfigurationsumgebung", die das aktuell laufende
Monitoring noch nicht beeinflusst. Erst durch das „Aktivieren der
ausstehenden Änderungen" werden diese in das Monitoring übernommen. Mehr
über die Hintergründe dazu erfahren Sie im [Artikel über die
Konfiguration von Checkmk](wato.html#activate_changes).
:::

::: paragraph
Wie wir schon oben erwähnt hatten, finden Sie auf jeder Seite rechts
oben die Information, wie viele Änderungen sich bisher angesammelt
haben, die noch nicht aktiviert sind. Klicken Sie auf den Link mit der
Anzahl der Änderungen. Dies bringt Sie auf die Seite [Activate pending
changes]{.guihint}, die unter anderem bei [Pending changes]{.guihint}
die noch nicht aktivierten Änderungen auflistet:
:::

:::: imageblock
::: content
![Liste der aufgelaufenen Änderungen zur
Aktivierung.](../images/intro_activate_changes.png)
:::
::::

::: paragraph
Klicken Sie jetzt auf den Knopf [Activate on selected sites]{.guihint},
um die Änderungen anzuwenden.
:::

::: paragraph
Kurz danach können Sie das Resultat in der Seitenleiste im
[Overview]{.guihint} sehen, der nunmehr die Zahl der Hosts (1) und die
Zahl der zuvor von Ihnen ausgewählten Services anzeigt. Auch im
Standard-Dashboard, das Sie mit einem Klick auf das Checkmk-Logo links
oben in der Navigationsleiste erreichen, können Sie jetzt sehen, dass
sich das System mit Leben gefüllt hat.
:::

::: paragraph
Damit haben Sie den ersten Host mit seinen Services erfolgreich ins
Monitoring übernommen: Gratulation!
:::

::: paragraph
Detailliertere Informationen über den Linux-Agenten können Sie im
[Artikel über die Überwachung von Linux](agent_linux.html) nachlesen.
Informationen dazu, wie man ausstehende Änderungen wieder zurückzieht
finden Sie in der [Konfiguration von Checkmk.](wato.html#revert_changes)
:::
:::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#windows .hidden-anchor .sr-only}6. Windows überwachen {#heading_windows}

::::: sectionbody
::: paragraph
Ebenso wie für Linux hat Checkmk auch für Windows einen eigenen Agenten.
Dieser ist als MSI-Paket verpackt. Sie finden ihn nur einen Menüeintrag
entfernt vom [Linux-Agenten.](#download_agent) Sobald Sie das MSI-Paket
heruntergeladen und auf Ihren Windows-Rechner kopiert haben, können Sie
es wie bei Windows üblich per Doppelklick installieren.
:::

::: paragraph
Sobald der Agent installiert ist, können Sie den Host in Checkmk
erstellen, per Kommando registrieren und ins Monitoring aufnehmen. Dabei
gehen Sie nach dem gleichen Ablauf vor, wie oben für den Linux-Host
beschrieben, allerdings sollten Sie den Host im dafür vorgesehenen
Ordner `Windows` erstellen. Da Windows anders aufgebaut ist als Linux,
findet der Agent natürlich andere Services. Die detaillierte Einführung
ins Thema finden Sie im [Artikel über die Überwachung von
Windows](agent_windows.html).
:::
:::::
::::::

:::::::::::::::: sect1
## []{#snmp .hidden-anchor .sr-only}7. Mit SNMP überwachen {#heading_snmp}

::::::::::::::: sectionbody
::: paragraph
Professionelle Switches, Router, Drucker und viele andere Geräte und
Appliances haben bereits vom Hersteller eine eingebaute Schnittstelle
für das Monitoring: das Simple Network Management Protocol (SNMP).
Solche Geräte lassen sich sehr einfach mit Checkmk überwachen --- und
Sie müssen noch nicht einmal einen Agenten installieren.
:::

::: paragraph
Das grundsätzliche Vorgehen ist dabei immer gleich:
:::

::: {.olist .arabic}
1.  In der Management-Oberfläche des Geräts schalten Sie SNMP frei für
    **lesende** Zugriffe von der IP-Adresse des Checkmk-Servers.

2.  Vergeben Sie dabei eine **Community**. Das ist nichts anderes als
    ein Passwort für den Zugriff. Da dieses im Netzwerk in der Regel im
    Klartext übertragen wird, ist es nur begrenzt sinnvoll, das Kennwort
    sehr kompliziert zu wählen. Die meisten Anwender verwenden für alle
    Geräte innerhalb eines Unternehmens einfach die gleiche Community.
    Das vereinfacht auch die Konfiguration in Checkmk sehr.

3.  Erstellen Sie in Checkmk den Host für das SNMP-Gerät wie [oben
    beschrieben](#create_host), diesmal im dafür vorgesehenen Ordner
    `Network`.

4.  In den Eigenschaften des Hosts, im Kasten [Monitoring
    agents]{.guihint} aktivieren Sie [Checkmk agent / API
    integrations]{.guihint} und wählen Sie [No API integrations, no
    Checkmk agent]{.guihint} aus.

5.  Im gleichen Kasten [Monitoring agents]{.guihint} aktivieren Sie
    [SNMP]{.guihint} und wählen Sie [SNMP v2 or v3]{.guihint} aus.

6.  Falls die Community nicht `public` lautet, aktivieren Sie wieder
    unter [Monitoring agents]{.guihint} den Eintrag [SNMP
    credentials]{.guihint}, wählen Sie [SNMP community (SNMP Versions 1
    and 2c)]{.guihint} aus und tragen Sie im Eingabefeld darunter die
    Community ein.
:::

::: paragraph
Für die letzten 3 Punkte sollte das Ergebnis so aussehen wie im
folgenden Bild:
:::

:::: imageblock
::: content
![Dialog mit Eigenschaften beim Erstellen eines Hosts per SNMP: die
\'Monitoring agents\'.](../images/intro_snmp_configuration.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wenn Sie alle SNMP-Geräte in      |
|                                   | einem eigenen Ordner angelegt     |
|                                   | haben, führen Sie die             |
|                                   | Konfiguration der [Monitoring     |
|                                   | agents]{.guihint} einfach für den |
|                                   | Ordner aus. Damit gelten die      |
|                                   | Einstellungen automatisch für     |
|                                   | alle Hosts in diesem Ordner.      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Der Rest läuft wie gehabt. Wenn Sie möchten, können Sie noch mit dem
Knopf [Save & go to connection tests]{.guihint} einen Blick auf die
Seite [Test connection to host]{.guihint} werfen. Dort sehen Sie auch
sofort, ob der Zugriff via SNMP funktioniert, hier z.B. für einen
Switch:
:::

:::: imageblock
::: content
![Ergebnis des Verbindungstests zum Host per
SNMP.](../images/intro_snmp_diagnostics.png)
:::
::::

::: paragraph
Klicken Sie auf der Seite [Properties of host]{.guihint} anschließend
auf [Save & run service discovery,]{.guihint} um die Liste aller
Services angezeigt zu bekommen. Diese sieht natürlich komplett anders
aus als bei Linux oder Windows. Auf allen Geräten überwacht Checkmk per
Default alle Ports, die aktuell in Benutzung sind. Dies können Sie
später nach Belieben anpassen. Außerdem zeigt Ihnen ein Service, der
immer [OK]{.state0} ist, die allgemeinen Informationen zu dem Gerät, und
ein anderer Service die Uptime an.
:::

::: paragraph
Die ausführliche Beschreibung finden Sie im [Artikel über die
Überwachung via SNMP](snmp.html).
:::
:::::::::::::::
::::::::::::::::

::::::::: sect1
## []{#cloud .hidden-anchor .sr-only}8. Cloud, Container und virtuelle Maschinen {#heading_cloud}

:::::::: sectionbody
::: paragraph
Auch Cloud-Dienste, Container und virtuelle Maschinen (VM) können Sie
mit Checkmk überwachen, selbst wenn Sie keinen Zugriff auf die
eigentlichen Server haben. Checkmk nutzt dafür die von den Herstellern
vorgesehenen Anwendungsprogrammierschnittstellen (API). Diese verwenden
für den Zugriff durchgehend HTTP bzw. HTTPS.
:::

::: paragraph
Das Grundprinzip ist immer das Folgende:
:::

::: {.olist .arabic}
1.  Richten Sie in der Management-Oberfläche des Herstellers einen
    Account für Checkmk ein.

2.  Erstellen Sie in Checkmk einen Host für den Zugriff auf die API.

3.  Richten Sie für diesen Host eine Konfiguration zum Zugriff auf die
    API ein.

4.  Für die überwachten Objekte wie VMs, EC2-Instanzen, Container usw.
    legen Sie weitere Hosts in Checkmk an bzw. automatisieren die
    Erstellung.
:::

::: paragraph
Sie finden im Handbuch Schritt-für-Schritt-Anleitungen zur Einrichtung
der Überwachung von [Amazon Web Services (AWS)](monitoring_aws.html),
[Microsoft Azure](monitoring_azure.html), [Google Cloud Platform
(GCP)](monitoring_gcp.html), [Docker](monitoring_docker.html),
[Kubernetes](monitoring_kubernetes.html) und [VMware
ESXi](monitoring_vmware.html).
:::

::: paragraph
[Weiter geht es mit den Monitoring-Werkzeugen](intro_tools.html)
:::
::::::::
:::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
