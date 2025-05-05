:::: {#header}
# Appliance einrichten und nutzen

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_usage.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Besonderheiten der Hardware-Appliance](appliance_rack_config.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::: sectionbody
::: paragraph
In diesem Artikel finden Sie alle Informationen rund um die Einrichtung
und Nutzung sowohl der virtuellen als auch der physischen Appliance.
Zwei größere Themen werden in separaten Artikeln abgehandelt:
[Backups](appliance_backup.html) und [Cluster.](appliance_cluster.html)
In einem weiteren Artikel gehen wir auf die [Hardware-spezifischen
Aspekte](appliance_rack_config.html) der Racks ein.
:::

::: paragraph
Wir beginnen hier mit dem Erststart der Appliance --- die virtuelle
Appliance muss also bereits [installiert](appliance_install_virt1.html),
beziehungsweise das Rack [angeschlossen](appliance_rack_config.html),
sein. Wenn Sie einfach möglichst zügig zu dem Punkt kommen wollen, an
dem Sie sich ganz normal im Browser bei Checkmk anmelden können, greifen
Sie am besten auf unsere Schnellstart-Anleitungen für das
[Rack](appliance_rack1_quick_start.html) beziehungsweise
[virt1](appliance_virt1_quick_start.html) zurück.
:::
:::::
::::::

::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#basic_config .hidden-anchor .sr-only}2. Grundeinrichtung {#heading_basic_config}

:::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#init_start .hidden-anchor .sr-only}2.1. Initialisierung beim Erststart {#heading_init_start}

::: paragraph
Während des ersten Starts erscheint zunächst eine Meldung zur Auswahl
der gewünschten Sprache:
:::

:::: imageblock
::: content
![Sprachauswahl bei der
Erstinstallation.](../images/cma_boot_preinit_language_2.png)
:::
::::

::: paragraph
Diese Sprache wird für das gesamte Gerät gespeichert. Im Anschluss
erscheint eine Meldung, die zur Initialisierung des Datenmediums (bei
Racks des RAIDs) auffordert:
:::

:::: imageblock
::: content
![Dialog zur
Initialisierung.](../images/cma_boot_preinit_init_uservol_2.png)
:::
::::

::: paragraph
Bestätigen Sie diesen Dialog und warten Sie, bis der Prozess
abgeschlossen ist. An der lokalen Konsole wird anschließend die
Statusansicht angezeigt:
:::

:::: imageblock
::: content
![Aktuelle Statusansicht an der lokalen
Konsole.](../images/cma_console_welcome_2.png)
:::
::::

::: paragraph
Diese Ansicht zeigt Ihnen allgemeine Statusinformationen und die
wichtigsten Konfigurationsoptionen Ihres Geräts an.
:::
:::::::::::::

:::::::::::::::::::::: sect2
### []{#network_access_config .hidden-anchor .sr-only}2.2. Netzwerk- und Zugriffskonfiguration via Konsole {#heading_network_access_config}

::: paragraph
Von der Statusansicht aus erreichen Sie das Konfigurationsmenü über die
Taste `F1`:
:::

:::: imageblock
::: content
![Auswahl der Network
Configuration.](../images/cma_console_config_2.png)
:::
::::

::: paragraph
Für die Inbetriebnahme des Geräts müssen Sie nun die
Netzwerkkonfiguration einstellen und das Gerätepasswort festlegen.
:::

#### Netzwerkkonfiguration {#network_config .discrete}

::: paragraph
Über den Punkt [Network Configuration]{.guihint} richten Sie zunächst
das Netzwerk ein. Dazu werden nacheinander die IP-Adresse, Netzmaske und
das optionale Standard-Gateway abgefragt.
:::

::: paragraph
In den meisten Fällen soll das Gerät auch auf Netzwerkgeräte außerhalb
des eigenen Netzwerksegments zugreifen können. Hierfür muss das
Standard-Gateway ebenfalls konfiguriert werden.
:::

::: paragraph
Nach der Eingabe dieser Werte wird die Konfiguration aktiviert. Damit
ist das Gerät sofort unter der angegebenen IP-Adresse über das Netzwerk
erreichbar. Dies können Sie z.B. mit einem `ping` von einem anderen
Gerät im Netzwerk testen.
:::

#### Weboberfläche aktivieren {#network_access .discrete}

::: paragraph
Der Großteil der Konfiguration des Geräts wird über die Weboberfläche
erledigt. Der Zugriff darauf ist durch das Gerätepasswort geschützt, das
Sie zunächst festlegen müssen. Im Auslieferungszustand ist kein solches
Passwort gesetzt, also auch kein Zugriff auf die Weboberfläche möglich.
:::

::: paragraph
Wählen Sie im Konfigurationsmenü [Device Password,]{.guihint} um das
Gerätepasswort festzulegen. Das Passwort muss mindestens 8 Zeichen lang
sein und mindestens einen Kleinbuchstaben, einen Großbuchstaben und eine
Ziffer enthalten.
:::

::: paragraph
Anschließend wählen Sie aus dem Konfigurationsmenü die Option [Web
Configuration,]{.guihint} um die Weboberfläche zu aktivieren.
:::

::: paragraph
Wenn Sie diese Schritte abgeschlossen haben, sehen Sie die veränderte
Statusansicht der Konsole:
:::

:::: imageblock
::: content
![Ansicht der Änderungen an der
Statusansicht.](../images/cma_console_welcome_basic_2.png)
:::
::::

::: paragraph
Im Kasten [Device Infos]{.guihint} steht die konfigurierte IP-Adresse
und im Kasten [Access]{.guihint} steht [Web Configuration:
on.]{.guihint} Wenn Sie das Gerät bereits korrekt mit Ihrem Netzwerk
verbunden haben, sehen Sie im Kasten [Status]{.guihint} auch, dass die
Netzwerkverbindung aktiv ist: [LAN: UP.]{.guihint}
:::

#### Zugriff auf die Konsole schützen {#_zugriff_auf_die_konsole_schützen .discrete}

::: paragraph
Beim Start der Appliance ist Ihnen vielleicht aufgefallen, dass es keine
Passwortabfrage gab. Jeder mit physischem Zugriff auf das Rack oder die
Management-Oberfläche der Virtualisierungslösung könnte die
Grundeinstellungen über die Konsole ändern.
:::

::: paragraph
Sie sollten daher den Passwortschutz im Konfigurationsmenü über den
Menüpunkt [Console Login]{.guihint} aktivieren. Bei eingeschaltetem
Schutz wird das Gerätepasswort abgefragt bevor die Statusansicht
angezeigt wird und Einstellungen verändert werden können.
:::

::: paragraph
Anschließend sehen Sie in der Statusansicht im Kasten [Access]{.guihint}
den Eintrag [Console Login: on]{.guihint}.
:::

:::: imageblock
::: content
![Veränderte
Statusansicht.](../images/cma_console_welcome_console_login_2.png)
:::
::::
::::::::::::::::::::::

:::::::::::::::::: sect2
### []{#basic_settings_webconf .hidden-anchor .sr-only}2.3. Grundeinstellungen in der Weboberfläche {#heading_basic_settings_webconf}

::: paragraph
Nachdem Sie durch die bisherige Konfiguration den Zugriff auf die
Weboberfläche freigeschaltet haben, können Sie diese nun über einen
beliebigen Rechner im Netzwerk aufrufen. Dazu geben Sie in die
Adresszeile des Browsers die Appliance-URL ein, hier etwa
`http://192.168.178.60/`. Anschließend sehen Sie den Anmeldedialog der
Weboberfläche:
:::

:::: imageblock
::: content
![Login-Fenster von
Checkmk.](../images/cma_webconf_login_2.png){width="50%"}
:::
::::

::: paragraph
Nachdem Sie sich mit dem vorher festgelegten Gerätepasswort angemeldet
haben, öffnet sich das Hauptmenü, aus dem Sie alle Funktionen der
Weboberfläche erreichen können.
:::

:::: {.imageblock .border}
::: content
![Hauptmenü auf der Weboberfläche.](../images/cma_webconf_index_2.png)
:::
::::

::: paragraph
Wählen Sie [Device Settings,]{.guihint} um die wichtigsten Einstellungen
des Geräts einzusehen und bei Bedarf zu ändern:
:::

:::: imageblock
::: content
![Auswahl der Device Settings.](../images/cma_webconf_settings_2.png)
:::
::::

::: paragraph
Per Klick auf den Parameternamen gelangen Sie zur jeweiligen Seite zum
Anpassen dieser Einstellung.
:::

::: paragraph
Sofern in Ihrer Umgebung vorhanden, sollten Sie nun zunächst einen oder
mehrere DNS-Server konfigurieren, damit die Auflösung von Host-Namen
genutzt werden kann. Wenn in Ihrer Umgebung ein oder mehrere NTP-Server
für die Zeitsynchronisation zur Verfügung stehen, geben Sie diese über
IP-Adressen oder Host-Namen unter [NTP Servers]{.guihint} ein.
:::

::: paragraph
Wenn von Ihrem Gerät aus E-Mails verschickt werden sollen, z.B.
Benachrichtigungen bei Problemen, müssen Sie die Option [Outgoing
Emails]{.guihint} konfigurieren. Dazu tragen Sie den für dieses Gerät
zuständigen SMTP-Relay-Server und eventuell dafür benötigte Zugangsdaten
ein. An diesen Server werden alle E-Mails geschickt, die auf dem Gerät
erzeugt werden. Sie können in dieser Einstellung auch konfigurieren,
dass alle E-Mails, die vom Betriebssystem des Geräts erzeugt werden,
z.B. bei kritischen Fehlern, an eine separate E-Mail-Adresse geschickt
werden.
:::

:::: imageblock
::: content
![Bearbeitung der
E-Mail-Einstellungen.](../images/cma_webconf_settings_3.png)
:::
::::

::: paragraph
Damit ist die Grundkonfiguration des Geräts abgeschlossen. Sie können
mit der [Installation der Checkmk-Software](#manage_cmk) und der
[Einrichtung der ersten Monitoring-Instanz](#site_management) fortfahren
oder weitere Geräteeinstellungen vornehmen.
:::
::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#cma_webconf_system_settings .hidden-anchor .sr-only}3. Geräteeinstellungen {#heading_cma_webconf_system_settings}

:::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Alle folgenden Einstellungen finden Sie im Bereich [Device
Settings.]{.guihint}
:::

:::: sect2
### []{#_sprache_anpassen .hidden-anchor .sr-only}3.1. Sprache anpassen {#heading__sprache_anpassen}

::: paragraph
Während der [Grundeinrichtung](#basic_config) haben Sie die Sprache
Ihres Geräts festgelegt. Diese können Sie jederzeit sowohl über die
Konfiguration der Konsole als auch über die Geräteeinstellungen in der
Weboberfläche anpassen. Wie auch alle sonstigen Einstellungen in diesem
Dialog, werden Änderungen durch das Speichern sofort wirksam.
:::
::::

:::: sect2
### []{#_standard_website_ändern .hidden-anchor .sr-only}3.2. Standard-Website ändern {#heading__standard_website_ändern}

::: paragraph
Wenn Sie im Browser die URL der Appliance ohne weitere Pfadangaben
aufrufen, gelangen Sie standardmäßig auf deren Startseite. Über [HTTP
access without URL brings you to]{.guihint} können Sie alternativ eine
installierte Monitoring-Instanz auswählen, auf die umgeleitet werden
soll. Die Appliance-Startseite erreichen Sie dann über die URL samt
Pfadangabe, also zum Beispiel `192.168.178.60/webconf`.
:::
::::

:::: sect2
### []{#_host_und_domain_namen_konfigurieren .hidden-anchor .sr-only}3.3. Host- und Domain-Namen konfigurieren {#heading__host_und_domain_namen_konfigurieren}

::: paragraph
Host- und Domain-Namen dienen der Identifikation eines Computers im
Netzwerk. Diese Namen werden beispielsweise beim Versenden von E-Mails
zum Bilden der Absenderadresse genutzt. Außerdem werden alle
Log-Einträge, die an einen Syslog-Server gesendet werden, mit den
konfigurierten Hostnamen als Quell-Host ergänzt, um die Einträge
leichter zuordnen zu können.
:::
::::

:::::: sect2
### []{#_namensauflösung_konfigurieren .hidden-anchor .sr-only}3.4. Namensauflösung konfigurieren {#heading__namensauflösung_konfigurieren}

::: paragraph
Häufig werden auch zum Monitoring statt IP-Adressen die Hostnamen oder
FQDNs (Fully Qualified Domain Names) genutzt. In den meisten Umgebungen
werden DNS-Server zum Übersetzen von IP-Adressen zu Hostnamen und
umgekehrt eingesetzt.
:::

::: paragraph
Um die Namensauflösung auf Ihrem Gerät nutzen zu können, müssen Sie die
IP-Adressen mindestens eines DNS-Servers Ihrer Umgebung konfigurieren.
Wir empfehlen, mindestens zwei DNS-Server einzutragen.
:::

::: paragraph
Nur wenn Sie diese Option konfiguriert haben, können Sie z.B. bei der
Konfiguration der NTP- oder Mailserver Host- und Domain-Namen verwenden.
:::
::::::

::::: sect2
### []{#_zeitsynchronisation_konfigurieren .hidden-anchor .sr-only}3.5. Zeitsynchronisation konfigurieren {#heading__zeitsynchronisation_konfigurieren}

::: paragraph
Die Systemzeit des Geräts wird an vielen Stellen, z.B. zum Erfassen von
Messwerten oder Schreiben von Log-Dateien, genutzt. Daher ist eine
stabile Systemzeit sehr wichtig. Diese wird am besten durch die Nutzung
eines Zeitsynchronisationsdiensts (NTP) sichergestellt.
:::

::: paragraph
Zum Aktivieren der Synchronisation tragen Sie die Host-Adresse
mindestens eines (vorzugsweise nicht virtuellen) Zeitservers unter
[NTP-Server]{.guihint} ein.
:::
:::::

::::::: sect2
### []{#_syslog_einträge_weiterleiten .hidden-anchor .sr-only}3.6. Syslog-Einträge weiterleiten {#heading__syslog_einträge_weiterleiten}

::: paragraph
Auf dem Gerät werden durch das Betriebssystem und einige dauerhaft
laufende Prozesse Log-Meldungen erzeugt, die per Syslog zunächst in ein
lokales Log geschrieben werden. Diese Einträge können Sie auch an einen
Syslog-Server schicken lassen, um sie dort auszuwerten, zu filtern oder
zu archivieren.
:::

::: paragraph
Wählen Sie zur Konfiguration der Weiterleitung den Punkt
[Syslog.]{.guihint}
:::

::: paragraph
Im folgenden Dialog können Sie nun einstellen, welches Protokoll Sie zur
Weiterleitung verwenden wollen. Syslog über UDP ist weiter verbreitet,
allerdings nicht so zuverlässig wie über TCP. Wenn Ihr Syslog-Server
also beide Protokolle unterstützt, empfehlen wir TCP.
:::

::: paragraph
Weiterhin müssen Sie noch die Host-Adresse des Syslog-Servers
konfigurieren, der die Log-Meldungen annehmen soll.
:::
:::::::

::::::::: sect2
### []{#_ausgehende_e_mails_konfigurieren .hidden-anchor .sr-only}3.7. Ausgehende E-Mails konfigurieren {#heading__ausgehende_e_mails_konfigurieren}

::: paragraph
Damit Sie von dem Gerät aus E-Mails verschicken können, z.B. bei
Ereignissen während des Monitorings, muss die Weiterleitung der Mails an
einen Ihrer Mailserver über [Outgoing Emails]{.guihint} konfiguriert
werden.
:::

::: paragraph
Dazu muss mindestens die Host-Adresse Ihres Mailservers als [SMTP Relay
Host]{.guihint} gesetzt werden. Dieser Server nimmt die E-Mails von
Ihrem Gerät an und leitet sie weiter.
:::

::: paragraph
Die Konfiguration des SMTP-Relay-Servers ist allerdings nur ausreichend,
solange Ihr Mailserver E-Mails über anonymes SMTP akzeptiert. Wenn Ihr
Mailserver eine Authentifizierung voraussetzt, dann müssen Sie unter
[Authentication]{.guihint} die passende Login-Methode aktivieren und
passende Zugangsdaten eingeben.
:::

::: paragraph
Sollten Sie selbst nach der Konfiguration keine E-Mails erreichen, lohnt
ein Blick in das Systemlog des Geräts. Hier werden alle Versuche, Mails
zu verschicken, protokolliert.
:::

::: paragraph
Das Gerät selbst kann Systemmails verschicken, wenn es kritische
Probleme gibt, z.B. wenn ein Job nicht ausgeführt werden kann oder ein
Hardwareproblem erkannt wurde. Um diese E-Mails zu empfangen, müssen Sie
über [Send local system mails to]{.guihint} eine E-Mail-Adresse
konfigurieren, an die diese Mails verschickt werden sollen.
:::

::: paragraph
Letztlich können Sie noch die Transportverschlüsselung via TLS
aktivieren und manuell eine Standard-Absenderadresse setzen.
:::
:::::::::

::::: sect2
### []{#_zugriff_auf_checkmk_agenten_anpassen .hidden-anchor .sr-only}3.8. Zugriff auf Checkmk-Agenten anpassen {#heading__zugriff_auf_checkmk_agenten_anpassen}

::: paragraph
Auf dem Gerät ist ein Checkmk-Agent installiert, der in der
Grundeinstellung nur vom Gerät selbst abgefragt werden kann. So können
Sie die Appliance in eine auf ihr laufende Monitoring-Instanz aufnehmen.
:::

::: paragraph
Es ist ebenfalls möglich, den Checkmk-Agenten von einem entfernten Gerät
aus erreichbar zu machen, so dass die lokale Appliance auch von einem
anderen Checkmk-System überwacht werden kann, z.B. in einer verteilten
Umgebung von einem zentralen Server. Hierzu können Sie eine Liste von
IP-Adressen konfigurieren, die den Checkmk-Agenten kontaktieren dürfen.
:::
:::::

:::::::: sect2
### []{#_netzwerkkonfiguration_anpassen .hidden-anchor .sr-only}3.9. Netzwerkkonfiguration anpassen {#heading__netzwerkkonfiguration_anpassen}

::: paragraph
Die grundlegende Netzwerkkonfiguration für die
Standard-Netzwerkschnittstelle haben Sie während der Inbetriebnahme über
die Konsole erledigt. Sie können diese Einstellungen über [Device
Settings \> Network Settings]{.guihint} aufrufen und nachträglich
ändern. Zudem lässt sich an dieser Stelle eine [IPv6 address]{.guihint}
hinzufügen.
:::

:::: imageblock
::: content
![Anpassung der Simple Network
Settings.](../images/appliance_network_simple.png)
:::
::::

::: paragraph
Bei diesen Einstellungen handelt es sich um den *einfachen Modus,* wie
Sie am Titel des Dialogs erkennen können: [Edit Simple Network
Settings.]{.guihint} Über den Knopf [Advanced Mode]{.guihint} aktivieren
Sie den *erweiterten Modus,* der Ihnen Zugriff auf alle verfügbaren
Netzwerkschnittstellen und Bonding-Funktionen gewährt.
:::

::: paragraph
Die erweiterte Konfiguration kann Ihnen helfen, die Verfügbarkeit des
Monitorings über Redundanzen zu erhöhen. Sie ist zudem Ausgangspunkt für
die Konfiguration eines Clusters und wird daher im
[Cluster-Artikel](appliance_cluster.html) ausführlich beschrieben.
:::
::::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#manage_cmk .hidden-anchor .sr-only}4. Checkmk-Versionen verwalten {#heading_manage_cmk}

:::::::::::::::::: sectionbody
:::::: sect2
### []{#_grundsätzliches .hidden-anchor .sr-only}4.1. Grundsätzliches {#heading__grundsätzliches}

::: paragraph
Beginnend mit der Appliance-Version 1.4.14 ist in der Appliance keine
Checkmk-Software mehr vorinstalliert. Der Grund dafür ist simpel:
Checkmk wird wesentlich häufiger aktualisiert als die Appliance und Sie
sollen natürlich nicht mit einer veralteten Checkmk-Version starten
müssen.
:::

::: paragraph
Die Installation von Checkmk läuft in der Appliance nicht wie auf
normalen Rechnern über die Kommandozeile, sondern bequem über eine
eigene Weboberfläche --- wie Sie im Folgenden sehen werden. Um diese
Weboberfläche nutzen zu können, müssen Sie sie in der Geräteverwaltung
der Appliance [aktivieren.](#network_access)
:::

::: paragraph
Die Checkmk-Software zur Installation in der Appliance wird Ihnen als
CMA-Datei angeboten (Checkmk-Appliance). Dabei handelt es sich schlicht
um ein Archivformat, das die Checkmk-Ordnerstruktur plus eine Info-Datei
enthält.
:::
::::::

::::::::::::: sect2
### []{#_checkmk_installieren .hidden-anchor .sr-only}4.2. Checkmk installieren {#heading__checkmk_installieren}

::: paragraph
Laden Sie die CMA-Datei über die
[Download-Seite](https://checkmk.com/de/download) herunter. Sie bekommen
die passende CMA-Datei nach der Auswahl der Checkmk-Edition und -Version
sowie der Plattform der Appliance.
:::

::: paragraph
Nachdem Sie die CMA-Datei heruntergeladen haben, wählen Sie im Hauptmenü
[Check_MK versions.]{.guihint} Suchen Sie dann auf der folgenden Seite
mit Hilfe des Dateiauswahldialogs die CMA-Datei von Ihrer Festplatte und
bestätigen Sie die Auswahl mit einem Klick auf [Upload &
Install.]{.guihint}
:::

::: paragraph
Nun wird die Checkmk-Software auf das Gerät hochgeladen. Dies kann, je
nach Netzwerkverbindung zwischen Ihrem Computer und dem Gerät, einige
Minuten dauern. Nachdem das Hochladen erfolgreich abgeschlossen wurde,
sehen Sie die neue Version in der Tabelle der installierten Versionen:
:::

:::: {.imageblock .border}
::: content
![Ansicht der installierten
Checkmk-Versionen.](../images/cma_webconf_cmk_versions_upload1_finished.png)
:::
::::

::: paragraph
Es ist möglich, auf dem Gerät mehrere Checkmk-Versionen parallel zu
installieren. Dadurch können mehrere Instanzen in verschiedenen
Versionen betrieben und einzelne Instanzen unabhängig voneinander auf
neuere Versionen aktualisiert werden. So können Sie beispielsweise eine
neue Version installieren und diese zunächst in einer Testinstanz
ausprobieren, um, nach erfolgreichem Test, anschließend Ihre
Produktivinstanz zu aktualisieren.
:::

::: paragraph
Eine weitere Checkmk-Software-Version laden und installieren Sie in
gleicher Weise wie die erste. Das Ergebnis sieht dann etwa so aus:
:::

:::: {.imageblock .border}
::: content
![Detailansicht der installierten
Checkmk-Versionen.](../images/cma_webconf_cmk_versions_upload2_finished.png)
:::
::::

::: paragraph
Sofern eine Software-Version von keiner Instanz verwendet wird, können
Sie diese Version mit dem Papierkorb-Symbol löschen.
:::
:::::::::::::
::::::::::::::::::
:::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#site_management .hidden-anchor .sr-only}5. Monitoring-Instanzen verwalten {#heading_site_management}

::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::::: sect2
### []{#create_site .hidden-anchor .sr-only}5.1. Instanz erstellen {#heading_create_site}

::: paragraph
Wählen Sie im Hauptmenü der Weboberfläche [Site Management.]{.guihint}
Auf dieser Seite haben Sie Zugriff auf alle Monitoring-Instanzen dieses
Geräts, können die Instanzen konfigurieren, aktualisieren,
löschen --- und neue anlegen.
:::

::: paragraph
Beim ersten Zugriff ist die Seite noch leer. Zum Erstellen Ihrer ersten
Instanz klicken Sie den Knopf [Create New Site.]{.guihint} Auf der
folgenden Seite können Sie die initiale Konfiguration der Instanz
festlegen:
:::

:::: imageblock
::: content
![Eigenschaften der
Seitenkonfiguration.](../images/cma_webconf_site_create_2.png)
:::
::::

::: paragraph
Tragen Sie hier zunächst eine ID (*Unique site ID*) ein, die der
eindeutigen Identifikation der Instanz dient. Die ID darf nur
Buchstaben, Ziffern, Bindestriche (`-`) und Unterstriche (`_`)
enthalten, muss mit einem Buchstaben oder Unterstrich beginnen und darf
maximal 16 Zeichen lang sein.
:::

::: paragraph
Wählen Sie dann die Checkmk-Version, mit der die Instanz erstellt werden
soll. Es werden Ihnen alle installierten Versionen angeboten, die in der
[Verwaltung der Checkmk-Versionen](#manage_cmk) aufgelistet sind.
:::

::: paragraph
Abschließend legen Sie noch den Benutzernamen des Checkmk-Administrators
und sein Passwort fest. Alle weiteren Einstellungen können Sie zunächst
unverändert lassen und bei Bedarf später anpassen.
:::

::: paragraph
Klicken Sie [Create Site]{.guihint} um die Instanz zu erstellen. Dies
kann einige Sekunden dauern. Nachdem die Instanz angelegt und gestartet
wurde, werden auf der Seite alle Instanzen aufgelistet:
:::

:::: imageblock
::: content
![Übersicht der vorhandenen
Instanzen.](../images/cma_webconf_site_list_2.png)
:::
::::

::: paragraph
Die Liste ist kurz und zeigt momentan nur die soeben erstellte Instanz
mit der ID [mysite]{.guihint} und ihrem Status, hier
[running.]{.guihint} Mit dem Knopf ganz rechts in der Spalte
[Control]{.guihint} können Sie die Instanz stoppen bzw. starten. Ganz
links in der Spalte [Actions]{.guihint} werden Symbole für die möglichen
Aktionen gezeigt, die Sie auf die Instanz anwenden können, von links
nach rechts: Bearbeiten, Aktualisieren, Umbenennen, Klonen, Löschen und
Anmelden.
:::

::: paragraph
Sie können sich jetzt an der gestarteten Instanz anmelden, wahlweise
indem Sie auf die Instanz-ID klicken oder indem Sie in der Adresszeile
Ihres Webbrowsers die URL der Instanz aufrufen, in unserem Beispiel:
`http://192.168.178.60/mysite`. Im Anmeldedialog der Instanz geben Sie
die Zugangsdaten ein, die Sie beim Erstellen der Instanz festgelegt
haben.
:::

::: paragraph
Nach der Anmeldung können Sie Checkmk wie gewohnt einrichten --- die
ersten Schritte sind im Artikel zu [Das Monitoring
einrichten](intro_setup_monitor.html) beschrieben.
:::

::: paragraph
In allen Instanzen der Appliance ist für alle Administratoren in der
[Seitenleiste](user_interface.html#sidebar) das Snapin [Checkmk
Appliance]{.guihint} verfügbar:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Das Snapin Checkmk
Appliance.](../images/cma_site_sidebar_2.png){width="50%"}
:::
::::

::: paragraph
Mit den Einträgen dieses Snapins können Sie stets aus einer Instanz zur
Weboberfläche der Appliance wechseln.
:::
::::::::::::::::::::

::::::::::::::::: sect2
### []{#update_site .hidden-anchor .sr-only}5.2. Instanz updaten {#heading_update_site}

::: paragraph
Beim Update einer Instanz wird diese auf eine neue
Checkmk-Software-Version aktualisiert. Installieren Sie zuerst die
gewünschte neue Version, wie es im Kapitel zur [Verwaltung der
Checkmk-Versionen](#manage_cmk) beschrieben ist.
:::

::: paragraph
**Achtung:** Bei Aktualisierungen auf neue Checkmk-Major-Versionen
sollten Sie den [zugehörigen Artikel](update_major.html) beachten.
Wichtig ist hier, dass Sie immer nur auf die nächste Major-Version
aktualisieren und keine Zwischenversionen überspringen.
:::

::: paragraph
Lassen Sie sich dann auf der Weboberfläche der Appliance die Instanzen
auflisten ([Main Menu \> Site Management]{.guihint}):
:::

:::: {.imageblock .border}
::: content
![Anzeige des Running-Status für eine
Appliance.](../images/cma_webconf_site_list_2.png)
:::
::::

::: paragraph
Sorgen Sie dafür, dass die Instanz nicht läuft, d.h. ist der
[Status]{.guihint} gleich [running,]{.guihint} stoppen Sie die Instanz
([Control \> Stop]{.guihint}). Klicken Sie anschließend unter
[Actions]{.guihint} auf das Update-Symbol [![icon cma site
update](../images/icons/icon_cma_site_update.png)]{.image-inline}.
:::

::: paragraph
Auf der folgenden Seite werden Ihnen die möglichen Zielversionen für das
Update aufgelistet:
:::

:::: {.imageblock .border}
::: content
![Ansicht der Zielversionen für ein Checkmk
Update.](../images/cma_site_update_1.png)
:::
::::

::: paragraph
Wählen Sie hinter [Target Check_MK version]{.guihint} die Zielversion
aus und klicken Sie dann auf [Update now.]{.guihint} Nach kurzer Zeit
werden die Meldungen zum Update angezeigt:
:::

:::: imageblock
::: content
![Meldungsverlauf während einem Checkmk
Update.](../images/cma_site_update_2.png)
:::
::::

::: paragraph
Mit dem Knopf [Back]{.guihint} kehren Sie zurück zur Liste der
Instanzen, nun mit der aktualisierten Versionsinformation. Sie können
die Instanz nun wieder starten.
:::

::: paragraph
**Hinweis:** Das Update einer Instanz in der Appliance folgt dem
gleichen Prinzip wie das Update auf einem regulären Linux-Server. Bei
Problemen, Fehlermeldungen oder Konflikten erhalten Sie im Artikel
[Updates und Upgrades](update.html#detailed) genaue Informationen zum
Update-Prozess.
:::
:::::::::::::::::

::::::::::::::::::: sect2
### []{#migrate_site .hidden-anchor .sr-only}5.3. Instanz migrieren {#heading_migrate_site}

::: paragraph
Es kommt häufig vor, dass eine bereits auf einem anderen Linux-System
laufende Instanz auf eine Checkmk-Appliance migriert werden soll. Die
Checkmk-Appliance bietet hierzu eine Funktion an, mit der Sie diese
Migration durchführen können.
:::

::: paragraph
Folgende Voraussetzungen müssen erfüllt sein:
:::

::: ulist
- Sie benötigen eine Netzwerkverbindung zwischen dem Quellsystem und
  Ihrem Gerät als Zielsystem.

- Die Checkmk-Version der Quellinstanz muss auf Ihrem Gerät installiert
  sein (Architekturwechsel von 32-Bit auf 64-Bit ist möglich).

- Die Quellinstanz muss während der Migration gestoppt sein.
:::

::: paragraph
In der Weboberfläche finden Sie unter dem Punkt [Site
Management]{.guihint} den Knopf [Migrate Site,]{.guihint} der Sie zu
dieser Seite führt:
:::

:::: imageblock
::: content
![Geben Sie die Migrationswerte
an.](../images/cma_webconf_site_migrate_start_2.png)
:::
::::

::: paragraph
Auf dieser Seite müssen Sie zunächst unter [Source Host]{.guihint} die
Host-Adresse (Host-Name, DNS-Name oder IP-Adresse) des Quellsystems
angeben. Außerdem geben Sie die ID der zu migrierenden Instanz unter
[Source site ID]{.guihint} an.
:::

::: paragraph
Die Migration der Instanz erfolgt über SSH. Sie benötigen hierzu die
Zugangsdaten für einen Benutzer, der sich auf dem Quellsystem anmelden
kann und berechtigt ist, auf alle Dateien der Instanz zuzugreifen.
Hierzu können Sie den `root`-Benutzer des Quellsystems
verwenden --- oder den Instanzbenutzer, falls ein Passwort für den
Instanzbenutzer festgelegt ist.
:::

::: paragraph
Optional können Sie nun noch wählen, ob Sie für die Zielinstanz auf
Ihrem Gerät eine neue Instanz-ID verwenden oder die Original-ID
unverändert lassen wollen.
:::

::: paragraph
Weiterhin können Sie festlegen, dass Sie die [performance
data]{.guihint} (Metriken und Graphen) und die historischen Daten der
Ereignisse des Monitorings bei der Migration *nicht* mit übertragen
wollen. Dies kann sinnvoll sein, wenn Sie kein 1:1-Abbild der Instanz
brauchen, sondern diese nur, z.B. zu Testzwecken, duplizieren wollen.
:::

::: paragraph
Nachdem Sie die Parameter ausgefüllt und mit [Start]{.guihint} bestätigt
haben, wird Ihnen der Fortschritt der Migration angezeigt:
:::

:::: imageblock
::: content
![Ansicht des
Migrationsfortschritts.](../images/cma_webconf_site_migrate_progress_2.png)
:::
::::

::: paragraph
Nach Abschluss der Migration können Sie die Migrationsverwaltung über
den Knopf [Complete]{.guihint} verlassen. Sie landen wieder in der
Instanzverwaltung und können die migrierte Instanz starten und
verwalten:
:::

:::: {.imageblock .border}
::: content
![Migrationsprotokoll bis zum Ende der
Migration.](../images/cma_webconf_site_migrate_complete_2.png)
:::
::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#cma_webconf_firmware .hidden-anchor .sr-only}6. Firmware verwalten {#heading_cma_webconf_firmware}

:::::::::::::::::: sectionbody
::: paragraph
Sie können die Software Ihres Geräts, d.h. die Firmware der Appliance,
im laufenden Betrieb auf eine neuere Version aktualisieren.
:::

::: paragraph
Die Firmware der Appliance können Sie als CFW-Datei auf der
[Download-Seite](https://checkmk.com/de/download){target="_blank"}
herunterladen.
:::

::: paragraph
Nachdem Sie die CFW-Datei heruntergeladen haben, wählen Sie im Hauptmenü
[Firmware Update]{.guihint} und auf der folgenden Seite mit dem
Dateiauswahldialog die CFW-Datei von Ihrer Festplatte:
:::

:::: {.imageblock .border}
::: content
![Auswahl der gewünschten
CFW-Datei.](../images/cma_webconf_firmware_upload_2.png)
:::
::::

::: paragraph
Bestätigen Sie mit einem Klick auf [Upload & Install.]{.guihint} Nun
wird die Firmware auf Ihr Gerät hochgeladen, was je nach
Netzwerkverbindung einige Minuten dauern kann.
:::

::: paragraph
Nachdem die Datei als gültige Firmware erkannt wurde, wird Ihnen der
[Confirm Firmware Update]{.guihint}-Dialog zur Bestätigung des
Firmware-Updates angezeigt. Dabei erscheinen, je nach
Versionsunterschieden der aktuellen und der zu installierenden Version,
verschiedene Meldungen, die Sie über die Behandlung Ihrer Daten während
des Updates informieren:
:::

::: ulist
- Änderung der ersten Stelle (*major release*) der Versionsnummer: Sie
  müssen die Daten Ihres Geräts manuell sichern und nach dem Update
  wieder einspielen. Ein Update ohne manuelle Datenmigration ist nicht
  möglich.

- Update auf höhere Nummer in der zweiten Stelle (*minor release*): Das
  Update kann ohne manuelle Datenmigration durchgeführt werden. Eine
  vorherige Sicherung wird trotzdem empfohlen.

- Änderung der dritten Stelle (*patch*) der Versionsnummer: Das Update
  kann ohne manuelle Datenmigration durchgeführt werden. Eine vorherige
  Sicherung wird trotzdem empfohlen.
:::

::: paragraph
Sie können an dieser Stelle den Dialog mit [No]{.guihint} abbrechen und
zuerst eine gegebenenfalls notwendige Datensicherung durchführen.
:::

::: paragraph
**Wichtig:** Wenn Sie den Dialog [Confirm Firmware Update]{.guihint}
aber mit [Yes!]{.guihint} bestätigen, wird das Gerät **sofort** neu
gestartet!
:::

::: paragraph
Beim Neustart wird die ausgewählte Firmware installiert. Der Neustart
dauert dadurch deutlich länger als sonst, jedoch in der Regel weniger
als 10 Minuten. Anschließend wird automatisch ein weiterer Neustart
ausgeführt, womit das Firmware-Update abgeschlossen ist. Die
Statusansicht der Konsole zeigt die neu installierte Firmware-Version
an.
:::

::: paragraph
**Hinweis zum Update der Major-Version:** Wenn Sie die Firmware
beispielsweise von 1.6.x auf 1.7.y aktualisieren, müssen Sie auch alle
Checkmk-Versionen, die von einer Instanz verwendet werden, wahlweise
aktualisieren oder in der gleichen Version (aber für die neue Plattform)
installieren. Der Grund: Die Major-Updates aktualisieren entweder die
als Basis verwendete Betriebssystemversion oder ändern grundlegende
Konzepte.
:::

::: paragraph
Unter [Checkmk versions]{.guihint} können Sie prüfen, ob Versionen
inkompatibel sind. Instanzen, die inkompatible Versionen verwenden,
lassen sich nicht mehr starten.
:::

:::: imageblock
::: content
![Übersicht aller installierten Versionen von
Checkmk.](../images/cma_sites_incompatible_versions.png)
:::
::::
::::::::::::::::::
:::::::::::::::::::

:::::::::::::::::::: sect1
## []{#reset .hidden-anchor .sr-only}7. Gerät zurücksetzen/neu starten {#heading_reset}

::::::::::::::::::: sectionbody
:::::::::::::: sect2
### []{#_neu_starten_herunterfahren .hidden-anchor .sr-only}7.1. Neu starten / Herunterfahren {#heading__neu_starten_herunterfahren}

::: paragraph
Das Gerät können Sie sowohl über die Weboberfläche als auch über die
Konsole neu starten bzw. herunterfahren.
:::

::: paragraph
In der Weboberfläche finden Sie die Menüpunkte [Reboot Device]{.guihint}
und [Shutdown Device]{.guihint} unterhalb des Punkts [Control
Device]{.guihint} im Hauptmenü. Das Gerät führt die Aktion unmittelbar
nach der Auswahl des Befehls aus.
:::

:::: {.imageblock .border}
::: content
![cma webconf control 2](../images/cma_webconf_control_2.png)
:::
::::

::: paragraph
In der Konsole erreichen Sie das Menü zur Steuerung des Geräts durch
einen Druck auf `F2`.
:::

:::: imageblock
::: content
![cma console actions 2](../images/cma_console_actions_2.png)
:::
::::

::: paragraph
**Warnung:** Wenn Sie die physische Appliance herunterfahren, benötigen
Sie für einen Neustart entweder physischen Zugang, um die Stromzufuhr zu
trennen und wieder anzuschließen, oder ein aktiviertes
[Management-Interface.](appliance_rack_config.html#ipmi)
:::

::::: imageblock
::: content
![iDrac port on the back of the
rack.](../images/appliance_back_idrac.jpg)
:::

::: title
Der iDrac-Anschluss gewährt Zugang zur separaten
Verwaltungsschnittstelle
:::
:::::
::::::::::::::

:::::: sect2
### []{#_werkseinstellungen_wiederherstellen .hidden-anchor .sr-only}7.2. Werkseinstellungen wiederherstellen {#heading__werkseinstellungen_wiederherstellen}

::: paragraph
Sie können Ihr Gerät auf die Werkseinstellungen zurücksetzen. Das
bedeutet, dass alle Änderungen, die Sie am Gerät vorgenommen haben, z.B.
Ihre Geräteeinstellungen, Monitoring-Konfiguration oder die erfassten
Statistiken und Logs, gelöscht werden. Beim Zurücksetzen der
Einstellungen bleibt die aktuell installierte Firmware-Version erhalten.
Die bei der Auslieferung des Geräts installierte Firmware wird nicht
wiederhergestellt.
:::

::: paragraph
Diese Aktion können Sie auf der Konsole durchführen. Drücken Sie dazu in
der Statusansicht die Taste `F2`, wählen Sie im folgenden Dialog
[Factory Reset]{.guihint} und bestätigen Sie den darauf folgenden Dialog
mit [yes.]{.guihint} Nun werden Ihre Daten vom Gerät gelöscht und direkt
im Anschluss wird ein Neustart ausgeführt. Das Gerät startet nun mit
einer frischen Konfiguration.
:::

::: paragraph
**Wichtig:** Die Einstellungen zum Management-Interface der physischen
Appliance sind persistent, bleiben also auch beim Zurücksetzen auf die
Werkseinstellungen erhalten. Damit ist sichergestellt, dass Sie später
keinen physischen Zugriff mehr auf das Rack benötigen.
:::
::::::
:::::::::::::::::::
::::::::::::::::::::

::::::::::::::: sect1
## []{#cma_mounts .hidden-anchor .sr-only}8. Einbinden von Netzwerkdateisystemen {#heading_cma_mounts}

:::::::::::::: sectionbody
::: paragraph
Wenn Sie eine [Datensicherung](appliance_backup.html) auf eine
Netzwerkfreigabe machen möchten, müssen Sie zunächst das gewünschte
Netzwerkdateisystem konfigurieren.
:::

::: paragraph
Aktuell werden die Netzwerkdateisysteme NFS in Version 3 und
Windows-Netzwerkfreigaben (Samba bzw. CIFS) sowie SSHFS (SFTP)
unterstützt.
:::

::: paragraph
Wählen Sie aus dem Hauptmenü der Weboberfläche den Punkt [Manage
mounts]{.guihint} und legen Sie von dort aus ein neues Dateisystem über
[New mount]{.guihint} an. Geben Sie hier eine ID ein, die später zur
Identifizierung des Dateisystems genutzt wird.
:::

:::: imageblock
::: content
![cma de mount new 2](../images/cma_de_mount_new_2.png)
:::
::::

::: paragraph
Wählen Sie dann, ob und wie das Dateisystem eingebunden werden soll.
Empfohlen wird hier das automatische Einbinden bei Zugriff bzw.
automatische Aushängen bei Inaktivität.
:::

::: paragraph
Konfigurieren Sie dann noch, welchen Freigabetyp Sie einbinden wollen.
Je nach Typ werden dann entsprechende Einstellungen benötigt,
beispielsweise Netzwerkadressen, Login-Daten oder exportierte Pfade für
NFS.
:::

::: paragraph
Nach dem Speichern sehen Sie in der Dateisystemverwaltung das soeben
konfigurierte Dateisystem und den aktuellen Zustand. Mit einem Klick auf
den Stecker können Sie nun das Dateisystem manuell einhängen, um zu
testen, ob die Konfiguration korrekt ist.
:::

:::: imageblock
::: content
![cma de mount list 2](../images/cma_de_mount_list_2.png)
:::
::::

::: paragraph
Sollte es Probleme geben, können Sie eventuelle Fehlermeldungen im
Systemlog finden.
:::
::::::::::::::
:::::::::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#ssh .hidden-anchor .sr-only}9. Remote-Zugriff über SSH {#heading_ssh}

:::::::::::::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_zugriffsoptionen .hidden-anchor .sr-only}9.1. Zugriffsoptionen {#heading__zugriffsoptionen}

::: paragraph
Sie können verschiedene Zugriffsarten über das Fernwartungsprotokoll SSH
aktivieren. Grundsätzlich werden
:::

::: ulist
- der Zugriff auf die Konsole und

- der direkte Login in die Instanzen
:::

::: paragraph
unterstützt. Der Zugriff auf den Systembenutzer *root* ist zwar möglich,
wird aber nicht empfohlen bzw. unterstützt, da es hiermit sehr einfach
möglich ist, die Konfiguration oder die Software zu beschädigen.
:::
::::::

::::::: sect2
### []{#_instanzlogin_über_ssh_aktivieren .hidden-anchor .sr-only}9.2. Instanzlogin über SSH aktivieren {#heading__instanzlogin_über_ssh_aktivieren}

::: paragraph
Sie können den Zugriff auf die Kommandozeile der einzelnen
Monitoring-Instanzen aktivieren. Hiermit können Sie die gesamte Umgebung
der Instanz einsehen und steuern.
:::

::: paragraph
Dieser Zugriff wird über die [Instanzverwaltung](#site_management)
gesteuert. Im Einstellungsdialog jeder einzelnen Instanz können Sie den
Zugriff aktivieren und deaktivieren sowie ein Passwort zum Schutz des
Zugriffs festlegen.
:::

:::: imageblock
::: content
![cma webconf site edit pw 2](../images/cma_webconf_site_edit_pw_2.png)
:::
::::
:::::::

:::::::::: sect2
### []{#_konsole_über_ssh_aktivieren .hidden-anchor .sr-only}9.3. Konsole über SSH aktivieren {#heading__konsole_über_ssh_aktivieren}

::: paragraph
Es ist möglich, den Zugriff auf die textbasierte Konfigurationsumgebung
des Geräts (Konsole) über das Netzwerk zu aktivieren. Damit können Sie
die Grundkonfiguration des Geräts auch ohne direkten Zugriff auf das
Gerät einsehen und anpassen.
:::

::: paragraph
Sie können den Zugriff über das Konfigurationsmenü der Konsole
freischalten. Wählen Sie dazu den Menüpunkt [Console via SSH.]{.guihint}
:::

:::: imageblock
::: content
![cma console config ssh console
2](../images/cma_console_config_ssh_console_2.png)
:::
::::

::: paragraph
Wenn Sie die Option aktivieren, werden Sie zur Eingabe eines Passworts
aufgefordert. Dieses Passwort müssen Sie eingeben, wenn Sie sich mit dem
Benutzernamen `setup` per SSH verbinden. Direkt nach dem Bestätigen
dieses Dialogs wird der Zugriff automatisch freigeschaltet.
:::

::: paragraph
Sie können sich nun als Benutzer `setup` mit Hilfe eines SSH-Clients
(z.B. PuTTY) mit dem Gerät verbinden.
:::

::: paragraph
Ob der Zugriff aktuell freigeschaltet ist, können Sie in der
Statusansicht der Konsole im Kasten [Access]{.guihint} sehen.
:::
::::::::::

:::::::::::::::: sect2
### []{#_root_zugriff_über_ssh_aktivieren .hidden-anchor .sr-only}9.4. root-Zugriff über SSH aktivieren {#heading__root_zugriff_über_ssh_aktivieren}

::: paragraph
Es ist möglich, den Zugriff als Systembenutzer `root` auf das Gerät zu
aktivieren. Nach der Initialisierung des Geräts ist dieser Zugriff
jedoch deaktiviert. Einmal aktiviert, können Sie sich als Benutzer
`root` über SSH am Gerät anmelden. Als `root` landen Sie jedoch nicht im
Menü der Appliance, sondern schlicht auf der Kommandozeile.
:::

::: paragraph
**Warnung:** Befehle, die Sie als `root` auf dem Gerät ausführen, können
nicht nur Ihre Daten, sondern auch das ausgelieferte System nachhaltig
verändern oder beschädigen. Wir haften nicht für Veränderungen, die Sie
auf diese Art vorgenommen haben. Aktivieren und verwenden Sie den
Benutzer `root` nur, wenn Sie sich sicher sind, was Sie tun und nur zu
Diagnosezwecken.
:::

::: paragraph
Sie können den Zugriff über das Konfigurationsmenü der Konsole
freischalten. Wählen Sie dazu den Menüpunkt [Root Access via
SSH.]{.guihint}
:::

:::: imageblock
::: content
![cma console config ssh root 1
2](../images/cma_console_config_ssh_root_1_2.png)
:::
::::

::: paragraph
Anschließend setzen Sie die Option auf [enable.]{.guihint}
:::

:::: imageblock
::: content
![cma console config ssh root 2
2](../images/cma_console_config_ssh_root_2_2.png)
:::
::::

::: paragraph
Sobald Sie die Option aktivieren, werden Sie zur Eingabe eines Passworts
aufgefordert. Dieses Passwort müssen Sie eingeben, wenn Sie sich als
Benutzer `root` per SSH verbinden. Direkt nach dem Bestätigen dieses
Dialogs wird der Zugriff automatisch freigeschaltet.
:::

:::: imageblock
::: content
![cma console config ssh root 3
2](../images/cma_console_config_ssh_root_3_2.png)
:::
::::

::: paragraph
Sie können sich nun als Benutzer `root` mit Hilfe eines SSH-Clients mit
dem Gerät verbinden.
:::

::: paragraph
Ob der Zugriff aktuell freigeschaltet ist, können Sie in der
Statusansicht der Konsole im Kasten [Access]{.guihint} sehen.
:::
::::::::::::::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::: sect1
## []{#ssl .hidden-anchor .sr-only}10. Appliance-GUI per TLS absichern {#heading_ssl}

::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_zugriff_über_tls_einrichten .hidden-anchor .sr-only}10.1. Zugriff über TLS einrichten {#heading__zugriff_über_tls_einrichten}

::: paragraph
Im Auslieferungszustand läuft der Zugriff auf die Weboberfläche Ihres
Geräts über HTTP im Klartext. Sie können diesen Zugriff per HTTPS (TLS)
absichern, so dass die Daten zwischen Ihrem Browser und dem Gerät
verschlüsselt übertragen werden.
:::

::: paragraph
Die Konfiguration erreichen Sie über den Knopf [Web Access]{.guihint} in
den [Device Settings.]{.guihint}
:::
:::::

::::::::::::::::: sect2
### []{#_zertifikat_installieren .hidden-anchor .sr-only}10.2. Zertifikat installieren {#heading__zertifikat_installieren}

::: paragraph
Um den Datenverkehr verschlüsseln zu können, benötigt das Gerät zunächst
ein Zertifikat und einen privaten Schlüssel. Sie haben nun mehrere
Möglichkeiten, wie Sie das Zertifikat installieren können:
:::

::: ulist
- Neues Zertifikat erstellen und mit einer
  Zertifikatsregistrierungsanforderung von einer Zertifizierungsstelle
  signieren lassen.

- Existierenden privaten Schlüssel und Zertifikat hochladen.
:::

::: paragraph
Je nachdem, wie Ihre Anforderungen und Möglichkeiten sind, können Sie
eine der obigen Optionen wählen. Zertifikate, die von
Zertifizierungsstellen signiert sind, haben im Allgemeinen den Vorteil,
dass Clients beim Zugriff automatisch verifizieren können, dass die
Gegenstelle (das Gerät) authentisch ist. Dies ist für offizielle
Zertifizierungsstellen in der Regel sichergestellt.
:::

::: paragraph
Wenn ein Benutzer auf die Weboberfläche per HTTPS zugreift und das
Zertifikat von einer Zertifizierungsstelle signiert ist, der er nicht
vertraut, führt das zunächst zu einer Warnung im Webbrowser.
:::

#### Neues Zertifikat erstellen und signieren lassen {#_neues_zertifikat_erstellen_und_signieren_lassen .discrete}

::: paragraph
Um ein neues Zertifikat zu erstellen, wählen Sie die Option [New
Certificate.]{.guihint} Im folgenden Dialog geben Sie nun Informationen
zu Gerät und Betreiber ein, die dann in dem Zertifikat hinterlegt werden
und sowohl von der Zertifizierungsstelle als auch später von Clients
genutzt werden können, um das Zertifikat zu verifizieren.
:::

:::: imageblock
::: content
![cma webconf ssl csr 2](../images/cma_webconf_ssl_csr_2.png)
:::
::::

::: paragraph
Nachdem Sie den Dialog mit [Save]{.guihint} bestätigt haben, gelangen
Sie wieder zur Startseite des Bereichs [Web Access]{.guihint} und können
die Datei zur Zertifikatsregistrierungsanforderung (CSR) herunterladen.
Diese Datei müssen Sie Ihrer Zertifizierungsstelle zur Verfügung
stellen. Anschließend bekommen Sie von Ihrer Zertifizierungsstelle ein
signiertes Zertifikat und ggf. eine Zertifikatskette (oft bestehend aus
Intermediate- und/oder Root-Zertifikaten). Diese erhalten Sie
üblicherweise in Form von PEM- oder CRT-Dateien.
:::

::: paragraph
Das signierte Zertifikat können Sie nun über den Dialog [Upload
Certificate]{.guihint} auf das Gerät übertragen. Wenn Sie eine
Zertifikatskette erhalten haben, können Sie diese ebenfalls über den
Dialog hochladen.
:::

:::: imageblock
::: content
![cma webconf ssl upload 2](../images/cma_webconf_ssl_upload_2.png)
:::
::::

::: paragraph
Nachdem Sie den Dialog mit [Upload]{.guihint} bestätigt haben, können
Sie mit der Konfiguration der Zugriffswege fortfahren.
:::

#### Existierendes Zertifikat hochladen {#_existierendes_zertifikat_hochladen .discrete}

::: paragraph
Wenn Sie ein existierendes Zertifikat und einen privaten Schlüssel
besitzen, die Sie zur Absicherung des HTTPS-Verkehrs nutzen wollen,
können Sie diese Dateien über den Dialog [Upload Certificate]{.guihint}
auf Ihr Gerät übertragen.
:::

::: paragraph
Nachdem Sie den Dialog mit [Upload]{.guihint} bestätigt haben, können
Sie mit der Konfiguration der Zugriffswege fortfahren.
:::
:::::::::::::::::

:::::::: sect2
### []{#_zugriffswege_konfigurieren .hidden-anchor .sr-only}10.3. Zugriffswege konfigurieren {#heading__zugriffswege_konfigurieren}

::: paragraph
Nachdem Sie ein Zertifikat installiert haben, können Sie die
Zugriffswege nun entsprechend Ihrer Anforderungen konfigurieren.
:::

::: paragraph
Wenn Sie den Zugriff auf Ihr Gerät per HTTPS absichern wollen, empfiehlt
sich die Option [HTTPS enforced (incl. redirect from HTTP to
HTTPS).]{.guihint} Das Gerät antwortet nur per HTTPS, leitet allerdings
alle eingehenden HTTP-Anfragen auf HTTPS um. Benutzer, die versehentlich
direkt oder über Bookmarks per HTTP auf die Weboberfläche zugreifen,
werden also automatisch auf HTTPS umgeleitet.
:::

::: paragraph
Wenn es Ihnen sehr wichtig ist, dass keine einzige Anfrage im Klartext
über das Netz geht, können Sie die Option [HTTPS only]{.guihint} wählen.
Benutzer, die per HTTP zugreifen, erhalten mit dieser Einstellung eine
Fehlermeldung.
:::

::: paragraph
Sie können außerdem beide Protokolle über [HTTP and HTTPS]{.guihint}
gleichzeitig aktivieren. Allerdings ist diese Einstellung nur in
Ausnahmefällen, zu Migrationszwecken oder zum Testen, empfehlenswert.
:::

::: paragraph
Sollten Sie HTTPS einmal deaktivieren wollen, so können Sie dies mit der
Option [HTTP only]{.guihint} erreichen.
:::
::::::::

:::::: sect2
### []{#_aktuelle_konfiguration_zertifikate_anzeigen .hidden-anchor .sr-only}10.4. Aktuelle Konfiguration / Zertifikate anzeigen {#heading__aktuelle_konfiguration_zertifikate_anzeigen}

::: paragraph
Auf der Seite zur Konfiguration der Zugriffswege können Sie jederzeit
die aktuell aktiven Zugriffswege sowie Informationen zum aktuellen
Zertifikat einsehen.
:::

:::: imageblock
::: content
![cma webconf ssl info 2](../images/cma_webconf_ssl_info_2.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::

::::::::::::::::::::: sect1
## []{#fault_diagnosis .hidden-anchor .sr-only}11. Fehlerdiagnose {#heading_fault_diagnosis}

:::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#_logs .hidden-anchor .sr-only}11.1. Logs {#heading__logs}

::: paragraph
Trotz sorgfältiger Tests ist es nicht auszuschließen, dass es zu
unvorhergesehenen Fehlern kommt, die ohne Blick auf das Betriebssystem
nur schwer zu diagnostizieren sind.
:::

::: paragraph
Eine Möglichkeit ist, die Log-Einträge, die auf dem System erzeugt
werden, per Syslog an einen Syslog-Server schicken zu lassen. Allerdings
werden die Log-Einträge der einzelnen Monitoring-Instanzen nicht per
Syslog verarbeitet, so dass diese nicht weitergeleitet werden und nur am
Gerät eingesehen werden können.
:::

::: paragraph
Um die Fehlerdiagnose auf dem Gerät zu vereinfachen, existiert eine
Ansicht zum Anzeigen diverser Log-Dateien des Geräts. Diese erreichen
Sie über den Menüpunkt [View Log Files]{.guihint} im Hauptmenü der
Weboberfläche.
:::

:::: {.imageblock .border}
::: content
![cma webconf logs 2](../images/cma_webconf_logs_2.png)
:::
::::

::: paragraph
Hier können Sie die Logs des Geräts auswählen und deren aktuellen Inhalt
einsehen.
:::

::: paragraph
**Hinweis:** Das Systemlog wird bei jedem Start des Geräts neu
initialisiert. Wenn Sie die Log-Einträge erhalten möchten, müssen Sie
diese an einen Syslog-Server schicken.
:::

::: paragraph
An der lokalen Konsole gibt es ebenfalls die Möglichkeit, das Systemlog
einzusehen. Auf dem zweiten Terminal werden die letzten Einträge des
Systemlogs angezeigt.
:::

::: paragraph
Dieses Terminal erreichen Sie durch die Tastenkombination `CTRL+ALT+F2`.
Auf dem dritten Terminal werden alle Kernelmeldungen ausgegeben. Hier
finden Sie bei Hardwareproblemen die entsprechenden Meldungen. Dieses
Terminal ist mit der Tastenkombination `CTRL+ALT+F3` erreichbar. Mit
Hilfe der Tastenkombination `CTRL+ALT+F1` können Sie wieder auf die
Statusansicht zurückschalten.
:::
::::::::::::

::::::::: sect2
### []{#_verfügbarer_arbeitsspeicher .hidden-anchor .sr-only}11.2. Verfügbarer Arbeitsspeicher {#heading__verfügbarer_arbeitsspeicher}

::: paragraph
Der im Gerät verfügbare Arbeitsspeicher steht Ihren Monitoring-Instanzen
abzüglich des Speichers, der von den Systemprozessen der
Checkmk-Appliance benötigt wird, zur freien Verfügung.
:::

::: paragraph
Um die Stabilität der Systemplattform gewährleisten zu können, wird eine
feste Menge des Arbeitsspeichers für die Systemprozesse reserviert. Je
nach Konfiguration Ihres Geräts ist die Menge des reservierten Speichers
wie folgt:
:::

::: ulist
- Einzelgerät (ohne Cluster-Konfiguration): **100 MB**

- Geclustert: **300 MB**
:::

::: paragraph
Wenn Sie genau wissen wollen, wie viel Arbeitsspeicher Ihren
Monitoring-Instanzen zur Verfügung steht und wie viel aktuell belegt
ist, können Sie Ihr Gerät von Checkmk überwachen lassen. Auf dem Gerät
wird ein Service [User_Memory]{.guihint} angelegt, der Ihnen die
aktuellen und historischen Auslastungen anzeigt.
:::

::: paragraph
Falls von den Monitoring-Instanzen mehr Arbeitsspeicher verlangt wird
als verfügbar ist, wird automatisch einer der Prozesse der
Monitoring-Instanzen beendet.
:::

::: paragraph
Dies wird durch Standard-Mechanismen des Linux-Kernels umgesetzt.
:::
:::::::::
::::::::::::::::::::
:::::::::::::::::::::

::::::::::: sect1
## []{#service .hidden-anchor .sr-only}12. Service und Support {#heading_service}

:::::::::: sectionbody
::: paragraph
Bei Problemen während der Inbetriebnahme oder während des Betriebs,
bitten wir Sie, zuerst dieses Handbuch zu Rate zu ziehen.
:::

::: paragraph
Aktuelle Support-Informationen zur Appliance sind zudem jederzeit im
Internet über unsere
[Website](https://checkmk.com/de/produkt/appliances){target="_blank"}
abrufbar. Dort finden Sie die aktuellste Fassung der Dokumentation und
allgemeine aktuelle Informationen, die über die Angaben in diesem
Handbuch gegebenenfalls hinaus gehen.
:::

#### Firmware {#_firmware .discrete}

::: paragraph
Die aktuellen Versionen der Firmware finden Sie auf unserer
[Website.](https://checkmk.com/de/download){target="_blank"} Für den
Zugriff auf die kommerziellen Editionen benötigen Sie die Zugangsdaten
Ihres laufenden Support-Vertrags.
:::

#### Hardware-Support {#_hardware_support .discrete}

::: paragraph
Bei einem Hardwareausfall kontaktieren Sie uns bitte per E-Mail an
<cma-support@checkmk.com> oder per Telefon unter +49 89 99 82 097 - 20.
:::

#### Software-Support {#_software_support .discrete}

::: paragraph
Im Fall eines Softwarefehlers, egal ob Firmware oder
Checkmk-Monitoring-Software, kontaktieren Sie uns über das [Checkmk
Support-Portal](https://support.checkmk.com/){target="_blank"}. Die
Unterstützung erfolgt im Rahmen des abgeschlossenen Support-Vertrags.
:::

#### Nicht unterstützte Modifikationen {#_nicht_unterstützte_modifikationen .discrete}

::: paragraph
Jegliche Modifikationen, Aktualisierungen oder Änderungen an der
Appliance-Software oder -Hardware, die vom Benutzer oder von Dritten
vorgenommen werden und nicht vom Hersteller autorisiert sind, führen
dazu, dass sämtliche Support-Leistungen hinfällig werden. Dies schließt
ein, ist aber nicht beschränkt auf:
:::

::: ulist
- die Installation einer nicht von uns gelieferten Firmware,

- nicht autorisierte Software-Installation oder Upgrades,

- und jegliche Manipulation der Konfiguration.
:::
::::::::::
:::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
