:::: {#header}
# ntopng in Checkmk integrieren

::: details
[Last modified on 16-Jan-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/ntop.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
:::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![ntopng-Logo.](../images/ntop_ntopng_logo.png){width="150"}
:::
::::

::: paragraph
Checkmk bietet viele grundlegende Funktionen für das Monitoring Ihrer
Netzwerkinfrastruktur und liefert die zugehörigen Metriken --- etwa
Bandbreite, Paketrate oder Fehlerrate. Darüber hinaus ermöglicht es eine
Überwachung des Zustands und der Geschwindigkeit von
Netzwerkschnittstellen sowie von Schwellwerten.
:::

::: paragraph
So weit, so gut. Wie sieht es aber mit den folgenden Fragen aus: Wer
kommuniziert mit Ihren Hosts? Welche Ports Ihrer Hosts werden genutzt?
Wer spricht am häufigsten, d.h. wer sind die „Top Talker"? Welche
Applikationen werden im Netzwerk genutzt? Ist mein Netz performant und
wo befinden sich gegebenenfalls die Engpässe? Gibt es Bedrohungen z.B.
durch Distributed Denial of Service (DDoS) Angriffe?
:::

::: paragraph
Um Antworten auf solche und ähnliche Fragen zu erhalten, ist eine
tiefgehende Analyse Ihres Netzwerks notwendig, die Checkmk alleine nicht
leisten kann. Hier wird die Analyse der Netzwerkdatenflüsse (*network
flows*) benötigt, d.h. der vielfältigen Kommunikationsbeziehungen, die
gleichzeitig im Netz stattfinden. Ein Netzwerkdatenfluss ist dabei
definiert durch Quelle und Ziel (jeweils bestimmt durch IP-Adresse und
Port) und das verwendete Protokoll.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Statt Checkmk die
Funktionen zum tiefgehenden Netzwerk-Monitoring hinzuzufügen und damit
das Rad neu zu erfinden, gibt es eine elegantere Lösung: die Integration
von **ntopng** in Checkmk. Die ntopng-Integration ist ein
kostenpflichtiges Add-On, das für die kommerziellen Editionen von
Checkmk erhältlich ist.
:::

::: paragraph
ntopng ist die leistungsstarke und ressourcenschonende Software zur
Überwachung und Analyse des Netzwerkverkehrs in Echtzeit und aus der
Vergangenheit --- und kann daher die Antworten auf die oben gestellten
Fragen geben. ntopng ist der Kern der Open-Source-Lösung zur Überwachung
des Netzwerkverkehrs der Firma
[ntop.](https://www.ntop.org/){target="_blank"} In einer ntop-Lösung
werden in der Regel die Daten über spezielle Software-Module
(**nProbe**) von den Geräten eingesammelt und zur Analyse an ntopng
weitergeleitet.
:::

::: paragraph
ntopng ist in mehr als einer Hinsicht mit Checkmk verwandt: Es kommt aus
der Open-Source-Welt und ist darin verwurzelt. ntopng gibt es in einer
frei verfügbaren („Community") und in mehreren erweiterten
(„Professional" und „Enterprise")
[Versionen.](https://www.ntop.org/guides/ntopng/versions_and_licensing.html){target="_blank"}
Die Benutzeroberfläche ist Web-basiert und bietet die Informationen in
Views und Dashboards an. Es können mehrere Benutzer erstellt und jedem
Benutzer eine Rolle zugewiesen werden. Benachrichtigungen basierend auf
Schwellwerten werden unterstützt. Schließlich können die Daten aus
ntopng per REST-API abgeholt werden.
:::

::: paragraph
Das Zusammenspiel der beteiligten Produkte zeigt das folgende Bild:
:::

:::: {.imageblock .border}
::: content
![Illustration der Kommunikation zwischen Checkmk und den ntop-Produkten
ntopng und nProbe.](../images/ntop_product_flow.png)
:::
::::

::: paragraph
Durch die Integration von ntopng erweitert sich also der Funktionsumfang
von Checkmk um zwei wichtige Punkte: das Monitoring des
Netzwerkdatenflusses und die tiefgehende Analyse des Netzwerkverkehrs.
:::

::: paragraph
Dabei bedeutet die Integration konkret folgendes:
:::

::: {.olist .arabic}
1.  Checkmk und ntopng werden als unabhängige Systeme auf
    unterschiedlichen Servern installiert und konfiguriert. Es wird
    empfohlen, Checkmk und ntopng **nicht** auf demselben Server zu
    betreiben.

2.  Vom Checkmk-Server wird eine Verbindung zum ntopng-Server
    hergestellt. Dabei kommuniziert Checkmk mit ntopng über dessen
    REST-API. Mit den Verbindungsparametern wird entschieden, welche
    Daten von ntopng abgeholt werden. Die Zuordnung erfolgt dabei über
    die verfügbaren Benutzerkonten beider Systeme.

3.  Informationen von ntopng werden in der Checkmk-Benutzeroberfläche
    angezeigt. Das passiert zum einen in neuen
    [Dashboards](glossar.html#dashboard), in denen die
    ntopng-Informationen für Checkmk-Benutzer aufbereitet werden. Zum
    anderen können ntopng-Daten in bestehende
    [Tabellenansichten](glossar.html#view) (*views*) und Dashboards von
    Checkmk integriert werden.
:::
:::::::::::::::::
::::::::::::::::::

::::::::::::::::::::::::::: sect1
## []{#ntop_connect .hidden-anchor .sr-only}2. Verbindung zu ntopng herstellen {#heading_ntop_connect}

:::::::::::::::::::::::::: sectionbody
::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Um die
Integration von ntopng in Checkmk nutzen zu können, benötigen Sie eine
der kommerziellen Editionen von Checkmk mit dem Add-on für die
ntopng-Integration und ein ntopng in einer Professional oder Enterprise
Version \>= 5.6, mit einer REST-API v2, über die Checkmk und ntopng
kommunizieren.
:::

::: paragraph
Sammeln Sie zuerst die folgenden Informationen über das
ntopng-Zielsystem, das Sie mit Checkmk verbinden möchten. Diese
Informationen müssen Sie in Checkmk als ntopng-Verbindungsparameter
eingeben:
:::

+--------------------+-------------------------------------------------+
| Parameter          | Bedeutung                                       |
+====================+=================================================+
| Host-Name          | Name oder IP-Adresse ([Host Address]{.guihint}) |
|                    | des ntopng-Servers.                             |
+--------------------+-------------------------------------------------+
| Port-Nummer        | Nummer des TCP-Ports ([Port number]{.guihint}), |
|                    | über den ntopng erreichbar ist. Der Port wird   |
|                    | beim Start von ntopng festgelegt. Default ist   |
|                    | `3000`.                                         |
+--------------------+-------------------------------------------------+
| Protokoll          | `HTTP` oder `HTTPS`. Die Verbindung zwischen    |
|                    | Checkmk und ntopng sollte nur über HTTPS        |
|                    | erfolgen. Name und Passwort des                 |
|                    | ntopng-Benutzerkontos werden im Klartext in der |
|                    | Checkmk-Instanz gespeichert, da die             |
|                    | Zugangsdaten unverschlüsselt via REST-API zum   |
|                    | ntopng-Server übertragen werden müssen.         |
+--------------------+-------------------------------------------------+
| Benutzerkonto zur  | Name und Passwort eines Benutzerkontos der      |
| Authentisierung    | ntopng-Benutzergruppe `Administrator` ([ntopng  |
|                    | Admin User]{.guihint}). Checkmk authentisiert   |
|                    | sich mit diesen Zugangsdaten über die REST-API  |
|                    | beim ntopng-Server. Das Default-Benutzerkonto   |
|                    | von ntopng heißt übrigens `admin` und ist der   |
|                    | Benutzergruppe „Administrator" zugeordnet.      |
+--------------------+-------------------------------------------------+

::: paragraph
In Checkmk starten Sie die Eingabe der ntopng-Verbindungsparameter im
Menü [Setup \> General \> Global settings \> Ntopng (chargeable add-on)
\> Ntopng Connection Parameters (chargeable add-on)]{.guihint}:
:::

:::: imageblock
::: content
![Die ntopng-Verbindungsparameter in den globalen
Einstellungen.](../images/ntop_connection.png)
:::
::::

::: paragraph
Die meisten der abgefragten Parameterwerte haben Sie sich inzwischen
besorgt und können Sie daher der obigen Tabelle entnehmen. Nur einen der
Verbindungsparameter müssen wir uns genauer vornehmen: [ntopng username
to aquire data for]{.guihint}. Damit legen Sie fest, wer in Checkmk
welche ntopng-Daten sehen kann. Die Benutzerkonten, mit denen sich
Checkmk bei ntopng authentisiert und mit denen sich Checkmk bei ntopng
die Daten abholt, werden unterschiedlich festgelegt. Die
Auswahlmöglichkeiten und die daraus resultierenden Unterschiede bei der
Abholung der Daten erklären wir in den beiden folgenden Abschnitten.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Alle Eingaben für die Verbindung  |
|                                   | zu ntopng werden beim Sichern     |
|                                   | nicht auf Gültigkeit überprüft.   |
|                                   | Fehlermeldungen zu ungültigen     |
|                                   | Werten erhalten Sie erst bei der  |
|                                   | [Anzeige der                      |
|                                   | ntopng                            |
|                                   | -Informationen.](#ntop_info_show) |
|                                   | Mit dem ersten                    |
|                                   | ntopng-Verbindungsparameter       |
|                                   | [Enable this ntopng               |
|                                   | instance]{.guihint} können Sie    |
|                                   | die Verbindung zu ntopng          |
|                                   | deaktivieren, z.B. wenn der       |
|                                   | ntopng-Server temporär nicht      |
|                                   | erreichbar ist.                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::::::: sect2
### []{#ntop_user_fixed .hidden-anchor .sr-only}2.1. Feste Zuordnung von Checkmk- und ntopng-Benutzern gleichen Namens {#heading_ntop_user_fixed}

::: paragraph
Die einfachste Möglichkeit ist es, einem Benutzer in Checkmk Zugang zu
den Informationen zu geben, die er in ntopng unter dem gleichen
Benutzernamen sieht.
:::

::: paragraph
Dazu wählen Sie für den Parameter [ntopng username to aquire data
for]{.guihint} den Wert [Use the Checkmk username as ntopng user
name]{.guihint} aus. Checkmk wird dann den aktuellen
Checkmk-Benutzernamen verwenden und unter diesem Namen die Daten von
ntopng abrufen.
:::

::: paragraph
Damit der Datenabruf über diese Zuordnung funktioniert, muss sowohl in
Checkmk als auch in ntopng mindestens ein Benutzerkonto mit gleichem
Namen existieren. Wie Sie es drehen oder wenden: Wahrscheinlich ist eine
Änderung der Benutzer in Checkmk, ntopng oder gar in beiden Systemen
notwendig. Wie Sie einen Benutzer in Checkmk anlegen oder ändern,
erfahren Sie im Artikel zur [Benutzerverwaltung.](wato_user.html)
:::

::: paragraph
Nachdem Sie die [Änderungen aktiviert](glossar.html#activate_changes)
haben, wird jeder Checkmk-Benutzer die Änderungen der Benutzeroberfläche
für ntopng sehen, wie Sie im [Kapitel zur Anzeige der
ntopng-Informationen](#ntop_info_show) beschrieben sind, z.B. die
Erweiterung des [Monitor]{.guihint}-Menüs. Allerdings werden die
ntopng-Daten nur für diejenigen Checkmk-Benutzer sichtbar sein, die ein
Benutzerkonto auf der ntopng-Gegenseite haben. Die anderen
Checkmk-Benutzer können die ntopng-spezifischen Seiten öffnen, erhalten
aber nur leere Seiten bzw. eine Fehlermeldung, dass die Anmeldedaten
ungültig sind.
:::

::: paragraph
Dies ist die einfachste, aber auch eine unflexible Möglichkeit.
:::
::::::::

:::::::::::: sect2
### []{#ntop_user_flex .hidden-anchor .sr-only}2.2. Flexible Zuordnung von Checkmk- zu ntopng-Benutzern {#heading_ntop_user_flex}

::: paragraph
Checkmk und ntopng haben in der Benutzerverwaltung ähnliche Konzepte: In
beiden Systemen können mehrere Benutzer eingerichtet werden, und jedem
Benutzer wird dabei eine Rolle zugewiesen. In Checkmk heißen die Rollen
unter anderem „Administrator\", „Normal monitoring user" und „Guest
user", in ntopng „Administrator\" und „Non Privileged User\". Mit diesen
zugewiesenen Rollen wird (unter anderem) entschieden, auf welche
Informationen ein Benutzer zugreifen kann.
:::

::: paragraph
Statt der zuvor beschriebenen starren 1:1-Zuordnung haben Sie die
Möglichkeit, für jeden Checkmk-Benutzer zu entscheiden, ob Sie ihm
ntopng-Daten geben wollen und --- falls ja --- von welchem
ntopng-Benutzer er sie erhalten soll.
:::

::: paragraph
Da den Benutzern in beiden Systemen unterschiedliche Rollen zugewiesen
sind, können Sie sehr genau steuern, wer in Checkmk was von ntopng sehen
darf, zum Beispiel so: Einem Checkmk „Guest user" ohne Interesse am
Netzwerkverkehr weisen Sie keinen ntopng-Benutzer zu: Für diesen
Benutzer werden die ntopng-spezifischen Erweiterungen der
Checkmk-Oberfläche ausgeblendet. Einem Checkmk „Normal monitoring user"
und Netzwerk-Azubi weisen Sie einen ntopng „Non Privileged User\" zu.
Einem Checkmk „Administrator" und Netzwerkexperten weisen Sie einen
ntopng „Administrator\" zu.
:::

::: paragraph
Das Vorgehen für die flexible Zuordnung ist das folgende:
:::

::: paragraph
In den [Ntopng Connection Parameters (chargeable add-on)]{.guihint}
wählen Sie für [ntopng username to aquire data for]{.guihint} den Wert
[Use the ntopng username as configured in the User settings]{.guihint}
aus.
:::

::: paragraph
Nachdem Sie die ntopng-Verbindungseinstellungen gesichert haben, wird in
den Einstellungen jedes Benutzers ([Setup \> Users \> Users]{.guihint})
unter [Identity]{.guihint} ein neues Feld eingeblendet, z.B. wie im
folgenden für den Benutzer `cmkadmin`:
:::

:::: imageblock
::: content
![Die Eigenschaften eines Checkmk-Benutzers mit dem neuen Feld zur
Eingabe eines ntopng-Benutzers.](../images/ntop_user_settings.png)
:::
::::

::: paragraph
Tragen Sie in das Feld [ntopng Username]{.guihint} den
ntopng-Benutzernamen ein, dessen Informationen dem aktuellen
Checkmk-Benutzer angezeigt werden sollen. Wenn dieses Feld leer bleibt
(was der Default ist), werden für den Checkmk-Benutzer die
ntopng-spezifischen Erweiterungen der Checkmk-Oberfläche ausgeblendet.
Aktivieren Sie abschließend die Änderungen.
:::
::::::::::::
::::::::::::::::::::::::::
:::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#ntop_info_show .hidden-anchor .sr-only}3. Die ntopng-Informationen anzeigen {#heading_ntop_info_show}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Nachdem die im Kapitel [Verbindung zu ntopng herstellen](#ntop_connect)
beschriebenen Voraussetzungen erfüllt sind, haben Sie nunmehr in Checkmk
Zugriff auf die ntopng-Daten. Melden Sie sich dazu in Checkmk unter
einem Benutzerkonto an, das einem ntopng-Benutzerkonto zugeordnet ist.
:::

::: paragraph
Im Folgenden erhalten Sie einen Überblick darüber, wo und wie Sie auf
die ntopng-Informationen in der Checkmk-Benutzeroberfläche zugreifen
können.
:::

::::::: sect2
### []{#ntop_monitor_menu .hidden-anchor .sr-only}3.1. Network statistics im Monitor-Menü {#heading_ntop_monitor_menu}

:::: imageblock
::: content
![Das Monitor-Menü mit dem neuen Thema \'Network
statistics\'.](../images/ntop_menu_monitor.png)
:::
::::

::: paragraph
Die auffälligste Änderung finden Sie im Menü [Monitor]{.guihint}, das
das neue Thema [Network statistics]{.guihint} enthält mit Einträgen zu
mehreren Dashboards mit ntopng-Daten, die wir in späteren Abschnitten
vorstellen werden.
:::

::: paragraph
Doch zuerst zu den Informationen, die Sie über ntopng-Hosts in Checkmk
abrufen können.
:::
:::::::

::::::::: sect2
### []{#ntop_hosts_view .hidden-anchor .sr-only}3.2. Ansichten mit ntopng-Hosts {#heading_ntop_hosts_view}

::: paragraph
Checkmk und ntopng verwalten nicht nur ihre Benutzer, sondern auch ihre
Hosts unabhängig voneinander. Falls ein Host in Checkmk aber auch in
ntopng eingerichtet ist, können Sie für diesen Host ntopng-spezifische
Informationen anzeigen lassen.
:::

::: paragraph
In jeder Host-Ansicht können Sie mit dem Filter [Ntopng Host]{.guihint}
die Schnittmenge aus Checkmk- und ntopng-Hosts bilden - und zwar so:
Klicken Sie in der Host-Ansicht (zum Beispiel [All hosts]{.guihint}) in
der Aktionsleiste auf [![Symbol zur Anzeige der
Filterleiste.](../images/icons/icon_filter.png)]{.image-inline}
[Filter,]{.guihint} um die Filterleiste zu öffnen. In der Filterleiste
klicken Sie zuerst auf [Add filter]{.guihint} zur Anzeige der
verfügbaren Filter und dann auf [![Symbol zum Wechsel in den
Show-more-Modus.](../images/icons/button_showmore.png)]{.image-inline},
um sich *alle* Filter anzeigen zu lassen. Wählen Sie in der Liste den
Filter [Ntopng Host]{.guihint} aus, setzen Sie ihn auf [yes]{.guihint}
und aktivieren Sie ihn mit [Apply filters.]{.guihint}
:::

::: paragraph
Anschließend werden in der Ansicht nur noch Hosts angezeigt, die in
Checkmk *und* in ntopng eingerichtet sind:
:::

:::: imageblock
::: content
![Das Aktionsmenü eines ntopng-Hosts enthält einen zusätzlichen
Eintrag.](../images/ntop_hosts_action_menu.png)
:::
::::

::: paragraph
Im obigen Beispiel gibt es zwei gemeinsame Hosts. Ein ntopng-Host zeigt
im Aktionsmenü den Eintrag [Ntop integration of this host.]{.guihint}
:::
:::::::::

::::::::::: sect2
### []{#ntop_nw_statistics .hidden-anchor .sr-only}3.3. Netzwerk-Statistik eines Hosts {#heading_ntop_nw_statistics}

::: paragraph
Klicken Sie für einen ntopng-Host im Aktionsmenü den Eintrag [Ntop
integration of this host]{.guihint} und Sie erhalten die
Host-spezifische Seite [Network statistics and flows:]{.guihint}
:::

:::: imageblock
::: content
![Die Seite \'Network statistics and flows\' für einen
ntopng-Host.](../images/ntop_nw_statistics.png)
:::
::::

::: paragraph
Die erste Zeile zeigt eine Zusammenfassung für alle in ntopng
eingerichteten Hosts mit der Zahl der aktuellen Alerts
([Alerts]{.guihint} und [Flow Alerts]{.guihint}).
:::

::: paragraph
Anschließend werden auf dieser Seite die Netzwerkdaten des ausgewählten
Hosts aus unterschiedlichen Perspektiven auf den folgenden Reitern
(*tabs*) präsentiert:
:::

::: ulist
- [Host]{.guihint}: Basisinformationen über den Host und Zusammenfassung
  der wichtigsten Informationen aus den anderen Reitern.

- [Traffic]{.guihint}: Informationen zum Layer-4-Protokoll (TCP und
  UDP), zur Übersicht als Tortendiagramm und detailliert als Tabelle.

- [Packets]{.guihint}: Verteilung der Flags in TCP-Verbindungen. Flags
  zeigen einen bestimmten Zustand der Verbindung an oder liefern
  zusätzliche Informationen. Die am häufigsten verwendeten Flags sind
  SYN (synchronization), ACK (acknowledgment), FIN (finish) und RST
  (reset).

- [Ports]{.guihint}: Nach Client- und Server-Ports gruppierte
  Verkehrsstatistiken.

- [Peers]{.guihint}: Übersicht der am häufigsten kontaktierten Partner
  (*peers*) und der am häufigsten verwendeten Anwendungen --- als
  Grafiken und Tabelle. Die Grafikelemente können zum Filtern angeklickt
  werden.

- [Apps]{.guihint}: Menge des Datenverkehrs, aufgeteilt nach Anwendungen
  und zusammenfassenden Kategorien. Die Layer-7-Anwendungen werden durch
  eine tiefgehende Prüfung der Pakete (*deep packet inspection*)
  ermittelt. In der Anwendungstabelle sind die Anwendungsnamen verlinkt
  und führen zu einer ntopng-Seite mit Detailinformationen.

- [Flows]{.guihint}: Tabelle der Datenflüsse (*flows*), die den
  ausgewählten Host als Anfangs- oder Endpunkt haben. Mehr Informationen
  erhalten Sie im Abschnitt [Flows Dashboard.](#ntop_flows_dashboard)

- [Engaged Host]{.guihint}, [Past Host]{.guihint}, [Past
  Flow]{.guihint}: Tabellen der aktiven Alerts, vergangenen Alerts und
  Datenfluss-Alerts. Mehr Informationen erhalten Sie im Abschnitt
  [Alerts Dashboard.](#ntop_alerts_dashboard)
:::

::: paragraph
In jedem Reiter können Sie mit dem Link [View data in ntopng]{.guihint}
die zugehörige ntopng-Seite aufrufen, die Sie zu den ntopng [Host
Details](https://www.ntop.org/guides/ntopng/user_interface/network_interface/hosts/hosts.html#host-details){target="_blank"}
führt.
:::

::: paragraph
**Tipp:** Sie können die Seite [Network statistics and flows]{.guihint}
auch von den Ansichten [Services of Host]{.guihint} und [Status of
Host]{.guihint} aufrufen und dabei den Reiter auswählen, mit dem die
Seite geöffnet wird. Beide Ansichten bieten, wenn Sie für einen
ntopng-Host aufgerufen werden, in ihrer Menüleiste das Menü
[ntopng]{.guihint} an, das Einträge für jeden einzelnen Reiter enthält.
:::
:::::::::::

:::::::: sect2
### []{#ntop_host_status .hidden-anchor .sr-only}3.4. Status eines Hosts {#heading_ntop_host_status}

::: paragraph
Auf der Seite [Network statistics and flows]{.guihint} klicken Sie in
der Aktionsleiste auf [Status of host,]{.guihint} um die Ansicht [Status
of Host]{.guihint} zu öffnen.
:::

::: paragraph
In dieser Ansicht werden die unterschiedlichsten Host-spezifischen
Informationen in einer Tabelle anzeigt, die von Ihnen um
ntopng-spezifische Einträge erweitert werden kann. Diese zeigt dann
Informationen, die Sie bereits von einigen Reitern der Seite [Network
statistics and flows]{.guihint} kennen --- zum Teil aus Platzmangel aber
nur eine Auswahl davon.
:::

::: paragraph
Um die ntopng-spezifischen Einträge zu nutzen, müssen Sie die [Ansicht
anpassen:](views.html#edit) Wählen Sie im Menü [Display \> Clone
built-in view.]{.guihint} Auf der Seite [Clone view]{.guihint} werden im
Kasten [Columns]{.guihint} die Spalten des Tabelleninhalts definiert.
:::

::: paragraph
Sie können mit [Add column]{.guihint} die folgenden ntopng-spezifischen
Einträge hinzufügen:
:::

::: ulist
- [Hosts: Ntop hosts details]{.guihint}: Zeigt die wichtigsten
  Informationen des Reiters [Host.]{.guihint}

- [Hosts: Ntop protocol breakdown]{.guihint}: Zeigt die Protokolltabelle
  des Reiters [Traffic.]{.guihint}

- [Hosts: Ntop ports]{.guihint}: Zeigt die Client- und
  Server-Tortendiagramme des Reiters [Ports.]{.guihint}

- [Hosts: Ntop top peers]{.guihint}: Zeigt das Anwendungs-Tortendiagramm
  des Reiters [Peers.]{.guihint}
:::
::::::::

:::::::::::: sect2
### []{#ntop_alerts_dashboard .hidden-anchor .sr-only}3.5. Alerts Dashboard {#heading_ntop_alerts_dashboard}

::: paragraph
Das [Alerts]{.guihint} Dashboard gibt Ihnen den Überblick über alle
Alerts in ntopng.
:::

::: paragraph
Wählen Sie im Menü [Monitor \> Network statistics \> Alerts:]{.guihint}
:::

:::: imageblock
::: content
![Das \'Alerts\' Dashboard mit zwei vergangenen
Host-Alerts.](../images/ntop_dashboard_alerts.png)
:::
::::

::: paragraph
Sie können mit den folgenden Reitern zwischen den Alert-Tabellen
wechseln:
:::

::: ulist
- [Engaged Host]{.guihint}: Tabelle der aktiven Host-Alerts. ntopng
  generiert Alerts, um die Überschreitung von Schwellwerten zu melden.

- [Past Host]{.guihint}: Tabelle der vergangenen, nicht mehr aktiven
  Host-Alerts.

- [Past Flows]{.guihint}: Tabelle der Datenfluss-Alerts (*flow alerts*),
  einer speziellen Kategorie, in der ntopng anomale oder verdächtige
  Datenflüsse meldet. Datenfluss-Alerts sind immer mit Ereignissen
  verknüpft. Sie werden in ihrer eigenen Kategorie gesammelt und tauchen
  nicht in den Tabellen der aktiven oder vergangenen Alerts auf.
:::

::: paragraph
Jede Seite zeigt maximal 20 Einträge. Sie können mit den
Navigationsknöpfen rechts oberhalb der Tabelle zu den anderen Seiten
wechseln.
:::

::: paragraph
In allen Reitern gibt es oberhalb der Tabelle zwei Balkendiagramme mit
der Verteilung nach Datum und Zeit, die Sie zum Filtern der Tabelle
verwenden können: Markieren Sie durch Ziehen mit der Maus ein
Zeitintervall in einem Diagramm. Der so definierte Filter wird
unmittelbar auf die Alert-Tabelle angewendet. Um den Filter wieder
abzuschalten, klicken Sie außerhalb der Markierung in das Diagramm.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Dieses Dashboard ist ähnlich      |
|                                   | aufgebaut wie die drei            |
|                                   | Alert-spezifischen Reiter der     |
|                                   | Seite [Network statistics and     |
|                                   | flows]{.guihint} (siehe Abschnitt |
|                                   | [Netzwerk-Statistik eines         |
|                                   | Hosts](#ntop_nw_statistics)).     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::::

::::::::: sect2
### []{#ntop_flows_dashboard .hidden-anchor .sr-only}3.6. Flows Dashboard {#heading_ntop_flows_dashboard}

::: paragraph
Das [Flows]{.guihint} Dashboard gibt Ihnen den Überblick über die
Datenflüsse (*flows*) in ntopng. Ein Datenfluss ist eine Verbindung per
Layer-4-Protokoll zwischen Anfangs- und Endpunkt, jeweils bestimmt durch
IP-Adresse und Port. Erst nach Beendigung der Datenübertragung kann ein
Datenfluss angezeigt werden. Daher ist die Anzeige der Datenflüsse stets
ein Blick in die Vergangenheit --- auch wenn sie erst wenige Sekunden
zurückliegt.
:::

::: paragraph
Wählen Sie im Menü [Monitor \> Network statistics \> Flows:]{.guihint}
:::

:::: imageblock
::: content
![Das \'Flows\' Dashboard.](../images/ntop_dashboard_flows.png)
:::
::::

::: paragraph
Die Tabelle ist im Wesentlichen identisch mit der
[Flows](https://www.ntop.org/guides/ntopng/user_interface/network_interface/flows/flows.html){target="_blank"}
Tabelle in der ntopng-Oberfläche.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Dieses Dashboard ist ähnlich      |
|                                   | aufgebaut wie der Reiter          |
|                                   | [Flows]{.guihint} auf der Seite   |
|                                   | [Network statistics and           |
|                                   | flows]{.guihint} (siehe Abschnitt |
|                                   | [Netzwerk-Statistik eines         |
|                                   | Hosts](#ntop_nw_statistics)).     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::

:::::::::: sect2
### []{#ntop_toptalkers_dashboard .hidden-anchor .sr-only}3.7. Top Talkers Dashboard {#heading_ntop_toptalkers_dashboard}

::: paragraph
Das [Top Talkers]{.guihint} Dashboard zeigt Ihnen in Echtzeit, welche
Hosts in ntopng den meisten Netzwerkverkehr verursachen.
:::

::: paragraph
Wählen Sie im Menü [Monitor \> Network statistics \> Top
Talkers:]{.guihint}
:::

:::: imageblock
::: content
![Das \'Top Talkers\'
Dashboard.](../images/ntop_dashboard_toptalkers.png)
:::
::::

::: paragraph
Im linken Teil des Dashboards werden die aktuellen „Top Talker"
gelistet, sortiert nach der Menge des ausgetauschten Datenverkehrs. Im
oberen Bereich werden die Hosts im lokalen Netzwerk angezeigt, im
unteren Bereich die Ziele in entfernten Netzwerken. Jeder Host ist
anklickbar und öffnet dann die zugehörige ntopng-Seite mit den
Host-Details.
:::

::: paragraph
In den Diagrammen erhalten Sie zusätzlich einen Überblick über den
Datenverkehr der Anwendungen (links) und der überwachten Schnittstellen
(rechts), in der letzten Stunde (oben) und den letzten 24 Stunden
(unten). Die in einem Diagramm angezeigten Einträge der Legende sind
anklickbar und können zum Filtern der Daten verwendet werden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Dieses Dashboard ist ähnlich      |
|                                   | aufgebaut wie das [Traffic        |
|                                   | Dashboard](https://www            |
|                                   | .ntop.org/guides/ntopng/user_inte |
|                                   | rface/network_interface/dashboard |
|                                   | /dashboard.html){target="_blank"} |
|                                   | in der ntopng-Oberfläche.         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::

::::: sect2
### []{#ntop_dashlets .hidden-anchor .sr-only}3.8. Dashlets {#heading_ntop_dashlets}

::: paragraph
Die in den letzten Abschnitten vorgestellten Dashboards
[Alerts]{.guihint}, [Flows]{.guihint} und [Top Talkers]{.guihint}
bestehen alle jeweils nur aus einem einzigen Dashlet.
:::

::: paragraph
Beim Editieren eines [Dashboards](dashboards.html) können Sie diese
ntopng-Dashlets verwenden, um bestehende Dashboards anzupassen oder neue
zu erstellen. Den Einstieg in die Dashboard-Konfiguration finden Sie im
[Customize-Menü](user_interface.html#customize_menu) unter
[Visualization \> Dashboards.]{.guihint} Beim Editieren eines Dashboards
finden Sie die ntopng-Dashlets, wie auch die anderen Dashlets, im Menü
[Add]{.guihint} im Abschnitt [Ntop.]{.guihint}
:::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
