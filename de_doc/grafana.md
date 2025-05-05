:::: {#header}
# Checkmk in Grafana integrieren

::: details
[Last modified on 08-Nov-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/grafana.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Kubernetes überwachen](monitoring_kubernetes.html) [Docker
überwachen](monitoring_docker.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![grafana logo](../images/grafana_logo.png){width="168"}
:::
::::

::: paragraph
Checkmk verfügt mit seinem integrierten [Graphing-System](graphing.html)
über ein mächtiges Werkzeug zum Aufzeichnen und Visualisieren von
[Metriken.](glossar.html#metric) Dennoch kann es sinnvoll sein,
[Grafana](https://grafana.com/){target="_blank"} als externes
Graphing-System anzubinden, z.B. weil Sie Grafana bereits nutzen und die
Daten von Checkmk mit Daten aus anderen Systemen in gemeinsamen
Dashboards zusammenführen möchten.
:::

::: paragraph
Ab Grafana 8.x ist es möglich, Checkmk in allen Editionen direkt als
Datenquelle anzusprechen und einzelne Metriken oder sogar ganze Graphen,
wie sie in Checkmk vordefiniert sind, anzeigen zu lassen. Zusätzlich
können Sie dynamisch eigene Graphen erstellen lassen, indem Sie über
[reguläre Ausdrücke](regexes.html) eine Gruppe von Hosts und Services
bestimmen, von denen bestimmte Metriken in dem Graphen berücksichtigt
werden sollen.
:::

::: paragraph
Dieser Artikel beschreibt, wie Sie Ihre Metriken aus Checkmk in Grafana
abrufen und darstellen. Screenshots wurden mit Grafana 10.1 erstellt,
frühere Versionen weichen in der Benutzerführung etwas davon ab. Eine
ausführliche Anleitung, wie Sie Grafana nutzen und konfigurieren können,
finden Sie in der [Dokumentation bei Grafana
Labs.](https://grafana.com/docs/){target="_blank"}
:::

::: paragraph
Das Grafana-Plugin wird unabhängig von Checkmk entwickelt und in einem
eigenen
[Github-Repository](https://github.com/Checkmk/grafana-checkmk-datasource){target="_blank"}
gepflegt. Dieser Artikel beschreibt die Einrichtung des Plugins in
Version 3.1, welche mit Checkmk [2.1.0]{.new} und [2.2.0]{.new}
zusammenspielt. Da die Installation des Plugins in Grafana erfolgt, ist
eine Auslieferung zusammen mit Checkmk nicht sinnvoll.
:::
:::::::::
::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#installation .hidden-anchor .sr-only}2. Das Plugin in Grafana installieren {#heading_installation}

::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Je nach Installationsart Ihres Grafana-Servers und Ihrer Checkmk-Edition
kommen verschiedene Methoden der Plugin-Installation in Frage. Einzige
Einschränkung hierbei: Benutzer des Grafana Cloud Angebots müssen
mindestens
[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud** verwenden, d.h. Checkmk Cloud oder Checkmk MSP, und
das Plugin [über die offizielle Grafana
Plugin-Sammlung](#installation_marketplace) aktivieren.
On-Premises-Installationen von Grafana können an alle Checkmk-Editionen
angebunden werden.
:::

:::::::::: sect2
### []{#installation_cli .hidden-anchor .sr-only}2.1. Installation auf der Kommandozeile (ab Checkmk Cloud, eigener Grafana-Server) {#heading_installation_cli}

::: paragraph
Diese Installationsart setzt die Verwendung von mindestens Checkmk Cloud
voraus. Bei Betrieb von Grafana auf einem eigenen Server ist dort die
Installation aus der Grafana Plugin-Sammlung via Kommandozeile möglich:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# grafana-cli plugins install checkmk-cloud-datasource
```
:::
::::

::: paragraph
Starten Sie den Grafana-Serverdienst neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl restart grafana-server
```
:::
::::

::: paragraph
Anschließend ist das Plugin in der Oberfläche von Grafana verfügbar und
kann aktiviert und eingerichtet werden.
:::
::::::::::

:::: sect2
### []{#installation_marketplace .hidden-anchor .sr-only}2.2. Installation aus der Grafana Cloud GUI (ab Checkmk Cloud, Grafana Cloud) {#heading_installation_marketplace}

::: paragraph
Loggen Sie sich zuerst in der Grafana-Instanz ein, in der Sie die
Checkmk-Datenquelle installieren wollen. Rufen Sie dann die [Seite der
Datenquelle in der Grafana
Plugin-Sammlung](https://grafana.com/grafana/plugins/checkmk-cloud-datasource/?tab=installation){target="_blank"}
auf. Im Reiter [Installation]{.guihint} setzen Sie ein Häkchen bei der
Grafana-Instanz, die das Plugin erhalten soll und klicken anschließend
auf den Knopf [Install.]{.guihint} Bis das Plugin im Web-Interface der
Grafana-Installation verfügbar ist, können wenige Minuten vergehen.
:::
::::

::::::::::::::::::::::::::::::::::::::::: sect2
### []{#installation_zip .hidden-anchor .sr-only}2.3. Installation aus Zip-Archiv (alle Editionen, eigener Grafana-Server) {#heading_installation_zip}

::: paragraph
Auf der [Releases-Seite des
GitHub-Repositories](https://github.com/Checkmk/grafana-checkmk-datasource/releases){target="_blank"}
finden Sie zwei Varianten des Plugins als Zip-Archiv:
:::

::: ulist
- Die [oben](#installation_cli) erwähnte signierte Variante
  `checkmk-cloud-datasource-X.Y.Z.zip`, die nur ab Checkmk Cloud genutzt
  werden kann.

- Eine Variante, die das alte Namensschema
  `tribe-29-checkmk-datasource-X.Y.Z.zip` nutzt, für alle Editionen von
  Checkmk [2.1.0]{.new} an aufwärts.
:::

::: paragraph
Laden Sie einfach die aktuellste Version als Zip-Datei herunter und
kopieren Sie sie, zum Beispiel mit `scp`, auf den Grafana-Server.
:::

:::: {.imageblock .border}
::: content
![grafana download plugin](../images/grafana_download_plugin.png)
:::
::::

::: paragraph
Statt über den Browser können Sie die Datei natürlich auch direkt über
die Kommandozeile laden. Beachten Sie, dass Sie dafür die aktuelle
Version wissen müssen -- im folgenden Beispiel schreiben wir die Version
in die Variable `$plugvers`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# plugvers='3.1.1'
root@linux# wget https://github.com/Checkmk/grafana-checkmk-datasource/releases/download/v${plugvers}/tribe-29-checkmk-datasource-${plugvers}.zip
```
:::
::::

::: paragraph
Entpacken Sie jetzt das Zip-Archiv:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# unzip tribe-29-checkmk-datasource-${plugvers}.zip
```
:::
::::

::: paragraph
Erstellen Sie ein Plugin-Verzeichnis, falls dieses noch nicht existiert,
und machen Sie den Linux-Benutzer, unter dessen Kennung die
Grafana-Prozesse ausgeführt werden (meist `grafana`) zu dessen
Eigentümer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mkdir -p /var/lib/grafana/plugins
root@linux# chown grafana:grafana /var/lib/grafana/plugins
```
:::
::::

::: paragraph
Verschieben Sie den entstandenen Ordner in das Plugin-Verzeichnis von
Grafana. Üblicherweise ist das der Pfad `/var/lib/grafana/plugins/`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# mv -v tribe-29-checkmk-datasource /var/lib/grafana/plugins/tribe-29-checkmk-datasource
```
:::
::::

::: paragraph
Ändern Sie den Eigentümer auf den Grafana-Benutzer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# chown -R grafana:grafana /var/lib/grafana/plugins/tribe-29-checkmk-datasource
```
:::
::::

::: paragraph
Eine Installation über das Klonen des Git-Archivs (wie es früher in
diesem Artikel beschrieben wurde) ist nicht mehr möglich. Falls Sie am
Plugin mitentwickeln wollen, lesen Sie die [Hinweise für
Entwickler.](https://github.com/Checkmk/grafana-checkmk-datasource/blob/main/DEVELOPMENT.md){target="_blank"}
:::

:::::::::::::: sect3
#### []{#allow_unsigned .hidden-anchor .sr-only}Nicht signierte Plugins zulassen {#heading_allow_unsigned}

::: paragraph
Seit Grafana 8.0 ist es nicht mehr ohne Weiteres möglich, externe
Plugins einzubinden, solange sie nicht signiert sind. Das trifft auch
auf das Checkmk-Plugin zu, so dass Sie einen zusätzlichen Schritt
benötigen.
:::

::: paragraph
Passen Sie dazu die Konfigurationsdatei `/etc/grafana/grafana.ini` im
Abschnitt `[plugins]` an. Ändern Sie hier die Zeile
`;allow_loading_unsigned_plugins =` wie folgt. Achten Sie dabei darauf,
das Semikolon am Zeilenanfang zu entfernen:
:::

::::: listingblock
::: title
/etc/grafana/grafana.ini
:::

::: content
``` {.pygments .highlight}
[plugins]
allow_loading_unsigned_plugins = tribe-29-checkmk-datasource
```
:::
:::::

::: paragraph
Mit dieser Einstellung fügen Sie eine Ausnahme für dieses eine Plugin
hinzu. Sollten Sie Grafana in einem (Docker-) Container einsetzen, haben
Sie verschiedene Möglichkeiten, Änderungen an der Grafana-Konfiguration
vorzunehmen. Sind nur kleine Konfigurationsänderungen nötig, können
diese über Umgebungsvariablen vorgenommen werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ sudo docker run -d \
-e GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS=tribe-29-checkmk-datasource \
-p 3000:3000 --name grafana \
-v grafana-plugins:/var/lib/grafana/plugins \
-v grafana-db:/var/lib/grafana grafana/grafana
```
:::
::::

::: paragraph
Falls größere Anpassungen an der INI-Datei oder dem gesamten
`/etc/grafana/` erforderlich sind, verlinken Sie entweder die angepasste
INI-Datei in den Container oder erstellen ein `Volume`, welches Sie auf
das Verzeichnis im Container (`/etc/grafana/`) mappen. Es folgt ein
Beispiel, wie Sie mit `--mount` die INI-Datei verlinken. Beachten Sie,
dass es sich hier nur um ein Beispiel handelt und wahrscheinlich nicht
direkt auf Ihre Umgebung passt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ sudo docker run -d \
--mount type=bind,source=/home/user/grafana/grafana.ini,target=/etc/grafana/grafana.ini \
-p 3000:3000 --name grafana \
-v grafana-plugins:/var/lib/grafana/plugins \
-v grafana-db:/var/lib/grafana grafana/grafana
```
:::
::::
::::::::::::::

::::::: sect3
#### []{#restart .hidden-anchor .sr-only}Neustart des Grafana-Dienstes {#heading_restart}

::: paragraph
Nach der Installation des Plugins, Updates oder einer Änderung der
Konfigurationsdatei starten Sie den Grafana-Serverdienst neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl restart grafana-server
```
:::
::::

::: paragraph
Anschließend ist das Plugin in der Oberfläche von Grafana verfügbar und
kann aktiviert und eingerichtet werden.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#create_user .hidden-anchor .sr-only}3. Grafana-Benutzer in Checkmk erstellen {#heading_create_user}

:::::: sectionbody
::: paragraph
Die Grafana-Anbindung benötigt auf Seite von Checkmk einen Benutzer, der
über ausreichende Berechtigungen verfügt und sich zudem über ein
Automationspasswort (*automation secret*) statt eines Passworts
authentifiziert. Normale Gast- oder Monitoring-Benutzer genügen nicht,
aus Sicherheitsgründen sollten Sie jedoch keinen Administrator
verwenden.
:::

::: paragraph
Der einfachste Weg zu einem \"passenden\" Benutzer ist, die
[Rolle](wato_user.html#roles) des Gastbenutzers (`guest`) zu klonen und
mit der zusätzlichen Berechtigung [User management]{.guihint} (lesender
Zugriff auf Benutzerinformationen) zu versehen. Falls Sie Ihre
Grafana-Benutzerrolle auf einer anderen Rolle basieren lassen, achten
Sie darauf, dass neben [User management]{.guihint} auch die Berechtigung
[See all host and services]{.guihint} gesetzt ist.
:::

::: paragraph
Ist die Rolle erstellt, legen Sie einen oder mehrere Grafana-Benutzer
mit Automationspasswort (*automation secret*) an. Der Rolle zugewiesene
Berechtigungen können Sie später weiter einschränken, beispielsweise
wird kein Zugriff auf [BI](glossar.html#bi) oder die [Event
Console](glossar.html#ec) benötigt.
:::
::::::
:::::::

::::::::::::::: sect1
## []{#activate .hidden-anchor .sr-only}4. Plugin aktivieren und einrichten {#heading_activate}

:::::::::::::: sectionbody
::: paragraph
Nachdem die notwendigen Dateien installiert wurden, können Sie das
Plugin in Grafana aktivieren. Wechseln Sie dazu in die Konfiguration und
wählen den Reiter [Data sources]{.guihint} aus. Hier können Sie über den
Knopf [Add data source]{.guihint} eine neue Datenquelle hinzufügen:
:::

:::: imageblock
::: content
![grafana plugins overview](../images/grafana_plugins_overview.png)
:::
::::

::: paragraph
Den Eintrag zu Checkmk finden Sie unten in der Kategorie
[Others]{.guihint}:
:::

:::: imageblock
::: content
![grafana plugin cmk](../images/grafana_plugin_cmk.png)
:::
::::

::: paragraph
Das Formular zu dieser Datenquelle ist recht einfach gehalten. Geben Sie
hier die URL zu Ihrer Instanz, den Typ Ihrer Edition und den soeben für
Grafana angelegten [Benutzer](#create_user) ein. **Wichtig**: Wenn Sie
Checkmk in einer [verteilten Umgebung](distributed_monitoring.html)
verwenden, dann geben Sie hier die URL zu Ihrer Zentralinstanz an:
:::

:::: imageblock
::: content
![grafana plugin config](../images/grafana_plugin_config.png)
:::
::::

::: paragraph
Falls Sie mehrere Checkmk-Instanzen anbinden möchten, können Sie die
einzelnen Verbindungen optional mit einem eindeutigen Namen versehen.
Ansonsten lassen Sie den Standard `Checkmk` respektive
`Checkmk for Cloud Edition` einfach stehen.
:::

::: paragraph
Nachdem Sie die Verbindung mit dem Knopf [Save & test]{.guihint}
gespeichert haben, steht sie Ihnen als Datenquelle in Grafana zur
Verfügung und Sie können Ihre ersten Graphen konfigurieren.
:::
::::::::::::::
:::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#graphs .hidden-anchor .sr-only}5. Graphen erstellen {#heading_graphs}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#emptydash .hidden-anchor .sr-only}5.1. Ein leeres Dashboard erzeugen {#heading_emptydash}

::: paragraph
Unter [Home \> Dashboards]{.guihint} finden Sie ein Drop-down-Menü,
welches mit dem Pluszeichen gekennzeichnet ist. Klicken Sie dort auf
[New dashboard]{.guihint}, um ein neues Dashboard zu erstellen:
:::

:::: imageblock
::: content
![grafana new dashboard](../images/grafana_new_dashboard.png)
:::
::::
::::::

::::::::::::::::::: sect2
### []{#singlemetric .hidden-anchor .sr-only}5.2. Eine einzelne Metrik eines Hosts anzeigen {#heading_singlemetric}

::: paragraph
Das einfachste Dashboard zeigt einen einzigen Graphen eines Services
eines Hosts. Dies kann auch die Metrik eines [lokalen
Checks](glossar.html#local_check) sein, für den keine vorgefertigten
Graphen existieren. In einem bestehenden oder dem eben erzeugten
Dashboard erstellen Sie eine neue Visualisierung. Wählen Sie hier zuerst
[Add visualization]{.guihint} aus:
:::

:::: imageblock
::: content
![grafana dashboard addpanel](../images/grafana_dashboard_addpanel.png)
:::
::::

::: paragraph
Mit Erstellung der Visualisierung gelangen Sie zur Auswahl der
Datenquelle. Nach der Auswahl von [Checkmk]{.guihint} befinden Sie sich
direkt im Editiermodus der Abfrage (*Query*) für das neu erstellte
Panel. Ein Panel ist ein Container für eine Visualisierung.
:::

::: paragraph
Der Zugriff auf zu visualisierende Daten unterscheidet sich etwas
zwischen
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** und den kommerziellen Editionen: In Checkmk Raw arbeiten
Sie mit vordefinierten Menüs für Instanz, Host-Name, Service und so
weiter. In den kommerziellen Editionen haben Sie die Möglichkeit,
Kaskaden von Filtern zu bestimmen. Dies erlaubt eine sehr detaillierte
Auswahl auch unter Verwendung regulärer Ausdrücke. Das folgende einfache
Beispiel ist so gewählt, dass Sie es mit allen Editionen durchspielen
können.
:::

::: paragraph
Wählen Sie zunächst die [Site]{.guihint}, danach filtern Sie nach einem
[Hostname]{.guihint} im Monitoring. Nutzen Sie für den ersten Test einen
beliebigen Host, der den Windows- oder Linux-Agenten nutzt. Als
[Service]{.guihint} wählen Sie [Check_MK]{.guihint}. Setzen Sie den Typ
der [Aggregation]{.guihint} auf [Maximum]{.guihint}. Als [Graph
type]{.guihint} stehen [Single metric]{.guihint} oder [Predefined
graph]{.guihint} (vordefinierte Graphen) zur Auswahl: [Predefined
graphs]{.guihint} übernehmen Metriken aus Checkmk, welche auch
kombinierte Graphen enthalten können. Unsere Screenshots zeigen hier die
[Single metric]{.guihint}, welche die Gesamtausführungszeit des Agenten
([Time spent waiting for Checkmk agent]{.guihint}) enthält.
:::

::::: imageblock
::: content
![grafana dashboard single
config](../images/grafana_dashboard_single_config.png)
:::

::: title
Auswahl der Metriken über Filter in den kommerziellen Editionen
:::
:::::

::::: imageblock
::: content
![grafana dashboard single config
cre](../images/grafana_dashboard_single_config_cre.png)
:::

::: title
Auswahl der Metriken über vordefinierte Menüs in Checkmk Raw
:::
:::::

::: paragraph
Grafana zeigt das Ergebnis direkt an. Mit dem Knopf [Apply]{.guihint}
können Sie den Graphen anwenden ohne das Dashboard zu sichern. Mit
[Save]{.guihint} werden Sie aufgefordert, einen Titel für das neue
[Dashboard]{.guihint} anzugeben und speichern schließlich das neu
erstellte Dashboard.
:::

::::: imageblock
::: content
![grafana dashboard single
view](../images/grafana_dashboard_single_view.png)
:::

::: title
Neues Dashboard mit wiedererkennbarer Benennung
:::
:::::
:::::::::::::::::::

::::::::::: sect2
### []{#predefined .hidden-anchor .sr-only}5.3. Einen vordefinierten Graphen aus Checkmk anzeigen {#heading_predefined}

::: paragraph
Die Entwickler von Checkmk haben bereits viele korrespondierende
Metriken in gemeinsamen Graphen zusammengefasst, damit Benutzer leichter
einen Überblick über verschiedene Aspekte einer einzigen Ressource
erhalten. Sie können die Metriken aus einem solchen vorgefertigten
Graphen direkt in Grafana anzeigen lassen.
:::

::: paragraph
Die Vorgehensweise entspricht zunächst der im vorherigen Abschnitt
erläuterten. Allerdings wählen Sie zum Abschluss als [Graph
type]{.guihint} den Eintrag [Predefined graph]{.guihint} und den zu
verwendenden [Predefined graph]{.guihint} des Services.
:::

::: paragraph
Sollten Sie eine Fehlermeldung erhalten, dass die Auswahl kombinierter
Metriken mit mehr als 200 Elementen unzulässig ist, schränken Sie mit
weiteren Filtern ein. Stellen Sie im Zweifel die Filter nach vorne, die
eine deutliche Einschränkung der Ergebnismenge versprechen.
:::

:::: imageblock
::: content
![grafana dashboard predefined
config](../images/grafana_dashboard_predefined_config.png)
:::
::::

::: paragraph
Sind Sie mit der getroffenen Auswahl zufrieden, klicken Sie den Knopf
[Apply]{.guihint}. Der Graph ist nun im gewählten Dashboard verfügbar.
:::

:::: imageblock
::: content
![grafana dashboard predefined
view](../images/grafana_dashboard_predefined_view.png)
:::
::::
:::::::::::

::::::::::: sect2
### []{#complexgraphs .hidden-anchor .sr-only}5.4. Komplexe Graphen erstellen {#heading_complexgraphs}

::: paragraph
Gerade in einem dynamischen Cluster möchte man oft den gesamten Verlauf
einer Metrik über alle beteiligten Hosts verfolgen können, ohne einen
Graphen jedes Mal anpassen zu müssen, wenn ein neuer Knoten hinzukommt
oder wegfällt. Um dies zu erreichen, haben Sie verschiedene
Möglichkeiten, Graphen dynamisch anzupassen.
:::

::: paragraph
Die erste Möglichkeit besteht in der Filterung nach [Host
Labels]{.guihint} oder [Host Tags]{.guihint} statt der Auswahl einzelner
Hosts. Eine weitere Möglichkeit ist die Verwendung [regulärer
Ausdrücke.](regexes.html) Sie können reguläre Ausdrücke auf Hosts oder
Services anwenden. Im folgenden Beispiel matcht `filesystem` alle
Services, die `filesystem` enthalten -- egal, wie viele Dateisysteme ein
Host eingebunden hat.
:::

:::: imageblock
::: content
![grafana dashboard combined
config](../images/grafana_dashboard_combined_config.png)
:::
::::

::: paragraph
Mit `filesystem.*nvme` würden Sie die Auswahl auf alle Dateisysteme auf
NVMe-Laufwerken einschränken, ganz gleichen welchen Dateisystemtyp diese
nutzen, da der Teil des Strings zwischen `filesystem` und `nvme`
beliebig sein kann.
:::

::: paragraph
Zusätzlich zu den erweiterten Filtermöglichkeiten bestimmen Sie mit
[Aggregation]{.guihint} die Darstellung der Metriken im Graphen und mit
[Graph]{.guihint}, welcher Graph als Referenz herangezogen werden soll.
Beachten Sie, dass nur dann Metriken zu einem Host/Service angezeigt
werden, wenn dieser auch über den ausgewählten Graphen verfügt. Der
Graph sieht dann zum Beispiel so aus:
:::

:::: imageblock
::: content
![grafana dashboard combined
view](../images/grafana_dashboard_combined_view.png)
:::
::::
:::::::::::

::::::: sect2
### []{#transform .hidden-anchor .sr-only}5.5. Umbenennung über reguläre Ausdrücke {#heading_transform}

::: paragraph
Im Editiermodus jedes Panels finden Sie einen Reiter
[Transform]{.guihint}. Mit dem hier vorhandenen Unterpunkt [Rename by
regex]{.guihint} können Sie die Bezeichnung von Metriken umsortieren
oder nicht benötigte Informationen unterdrücken. Unser folgendes
Beispiel sucht zwei durch Komma und folgendes Leerzeichen getrennte
Zeichengruppen, vertauscht diese und stellt explizit `Service` und
`Host` vorne an:
:::

:::: imageblock
::: content
![grafana series renaming
regex](../images/grafana_series_renaming_regex.png)
:::
::::

::: paragraph
Die Variablen `$1` und `$2` entsprechen hierbei den in der Zeile darüber
„eingefangenen" Zeichenketten (*Match-Gruppen* oder *Capture Groups*).
Grafana erlaubt auch verschachtelte Match-Gruppen. Einen Überblick über
deren Möglichkeiten zeigt der entsprechende Abschnitt im [Artikel zu
regulären Ausdrücken](regexes.html#matchgroups).
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::: sect1
## []{#variables .hidden-anchor .sr-only}6. Flexiblere Graphen mit Variablen {#heading_variables}

::::::::::::::::::::::::: sectionbody
::: paragraph
Über Variablen können Sie Dashboards flexibel mit Graphen versehen. So
haben Sie die Möglichkeit per Drop-down-Auswahl den Host einer
bestimmten Metrik zu bestimmen oder Sie nutzen Variablen, um Graphen für
mehrere Hosts auf einen Schlag einem Dashboard hinzuzufügen. Dieser
Artikel kann und soll nicht die [Dokumentation bei
Grafana](https://grafana.com/docs/grafana/latest/dashboards/variables/){target="_blank"}
ersetzen. In erster Linie wollen wir einen Überblick der
Einsatzmöglichkeiten und einen Einstieg in das Thema vermitteln.
:::

::: paragraph
Variablen können aus *Queries* erstellt werden. In diesem Fall können
Sie auf Sites, Hosts oder Services filtern. Alternativ haben Sie die
Möglichkeit, *Mengen* oder *Freitextfelder* zu definieren, was beliebige
Filter ermöglicht.
:::

::::::::::::: sect2
### []{#variable_create .hidden-anchor .sr-only}6.1. Variablen erstellen {#heading_variable_create}

::: paragraph
Jede Variable ist eine Eigenschaft eines Dashboards. Sie muss in den
Einstellungen des Dashboards erstellt werden und kann dann nur innerhalb
dieses Dashboards verwendet werden. Da *Query* die umfangreichste
Konfiguration erfordert, zeigen wir dessen Verwendung in unserem
Beispiel.
:::

::: paragraph
Die relevanten Eigenschaften einer Variablen sind ihr Typ und ihr Name,
alle anderen Eigenschaften dienen nur der Übersichtlichkeit im
Dashboard. Der Name sollte Unterscheidungen unterstützen. Wenn Sie also
planen, mehrere Variablen zur Auswahl von Hosts aus verschiedenen
Untermengen zu nutzen, verwenden Sie statt `host` wie im Beispiel einen
Namen, der auf diese Menge referenziert, zum Beispiel
`host_from_linuxservers`.
:::

::::: imageblock
::: content
![grafana variable name](../images/grafana_variable_name.png)
:::

::: title
Erstellung einer Variable `host` in den Dashboard-Eigenschaften
:::
:::::

::: paragraph
Achten Sie bei der Wahl der Datenquelle darauf, dass eine
Checkmk-Verbindung ausgewählt ist. Den gewählten Objekttyp können sie
weiter einschränken, zum Beispiel mit regulären Ausdrücken. Verwendete
Filter werden auf dem Checkmk-Server ausgewertet. Dagegen werden die
folgenden Felder [Regex]{.guihint} und [Sort]{.guihint} von Grafana
ausgewertet.
:::

::::: imageblock
::: content
![grafana variable query](../images/grafana_variable_query.png)
:::

::: title
Mit Filtern legen Sie fest, welche Werte die Variable annehmen kann
:::
:::::

::: paragraph
Die beiden Checkboxen für [Selection options]{.guihint} ganz unten auf
der Seite sind von der späteren Verwendung abhängig. Sie können diese
bei Bedarf jederzeit anpassen, lassen Sie für den ersten Test beide auf
der (leeren) Voreinstellung. Speichern Sie die Variablen mittels [Save
dashboard]{.guihint}, wenn Sie alle Einstellungen vorgenommen haben.
:::
:::::::::::::

::::::::::: sect2
### []{#variable_use .hidden-anchor .sr-only}6.2. Variablen für Graphen nutzen {#heading_variable_use}

::: paragraph
Sie können die vergebenen Variablen nun in die dafür passenden Felder
eintragen um einen flexiblen Graphen zu erstellen. Die Verwendung der
Variablen ist zudem im Titel des Graphen möglich.
:::

::::: imageblock
::: content
![grafana variable use](../images/grafana_variable_use.png)
:::

::: title
Der Zugriff auf Variablennamen geschieht, wie in einigen Shells, über
das vorangestellte Dollarzeichen
:::
:::::

::: paragraph
Im Dashboard wird für jede Variable eine Drop-down-Auswahl angezeigt,
über die Sie einstellen, für welche Variablenwerte (Hosts, Services...​)
Sie das Dashboard anzeigen lassen. Wenn Sie Mehrfachauswahl aktiviert
haben, können Sie in den Einstellungen des Panels die Option [Repeat by
variable]{.guihint} setzen, um das Panel für jeden ausgewählten
Variablenwert anzuzeigen.
:::

::::: imageblock
::: content
![grafana variable panel](../images/grafana_variable_panel.png)
:::

::: title
Drop-down-Auswahl der referenzierten Hosts mit Möglichkeit der
Mehrfachauswahl
:::
:::::
:::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: paragraph
Die folgenden Dateien und Verzeichnisse sind auf einem selbst gehosteten
Grafana-Server relevant.
:::

+--------------------+-------------------------------------------------+
| Pfad               | Bedeutung                                       |
+====================+=================================================+
| `/var/lib          | Hier sucht Grafana nach (neuen) Plugins. Jedes  |
| /grafana/plugins/` | Plugin bekommt dabei ein eigenes                |
|                    | Unterverzeichnis. Das Plugin von Checkmk legen  |
|                    | Sie daher hier ab.                              |
+--------------------+-------------------------------------------------+
| `/etc/grafana/`    | Konfigurationsverzeichnis von Grafana.          |
+--------------------+-------------------------------------------------+
| `/etc/gr           | Zentrale Konfigurationsdatei von Grafana. Hier  |
| afana/grafana.ini` | legen Sie fest, welche nicht signierten Plugins |
|                    | Sie zulassen.                                   |
+--------------------+-------------------------------------------------+
::::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
