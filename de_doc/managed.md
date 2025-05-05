:::: {#header}
# Checkmk MSP

::: details
[Last modified on 10-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/managed.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk Cloud](cce.html) [Checkmk aufsetzen](intro_setup.html) [Updates
und Upgrades](update.html) [Verteiltes
Monitoring](distributed_monitoring.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::: sectionbody
::: paragraph
Checkmk ist in verschiedenen Editionen verfügbar, die sich im
Leistungsumfang und in den Einsatzmöglichkeiten unterscheiden. Im
Folgenden möchten wir Ihnen mit
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** eine der kommerziellen
[Editionen](intro_setup.html#editions) vorstellen.
:::

::: paragraph
In einem [verteilten Monitoring](glossar.html#distributed_monitoring)
mit [verteiltem Setup](glossar.html#distributed_setup) werden sich die
Benutzer in der Regel auf der *Zentralinstanz* anmelden, um dort
Konfigurationen vorzunehmen oder auf die Monitoring-Daten zuzugreifen.
Die Benutzer können sich zwar zusätzlich auch auf den *Remote-Instanzen*
anmelden, weil sie z.B. nur für die Hosts und Services zuständig sind,
die von dort aus überwacht werden. Das Berechtigungskonzept von Checkmk,
die Sichtbar- und Konfigurierbarkeit von Hosts und Services mittels
[Rollen](wato_user.html#roles) und
[Kontaktgruppen](wato_user.html#contact_groups) einzuschränken, ist
jedoch für beide Szenarien vollkommen ausreichend. Benutzer mit sehr
eingeschränkten Berechtigungen werden in aller Regel keinen direkten
Kommandozeilenzugriff auf den Monitoring-Server bekommen und können
daher auch nur die Daten sehen, für die sie zuständig sind. Dass sie
dabei eventuell über die Existenz von anderen Hosts und Services
informiert sind, ist kein Problem.
:::

::: paragraph
In einem verteilten Setup wird Checkmk in Checkmk Raw, Checkmk
Enterprise und Checkmk Cloud daher alle Konfigurationsdaten an alle
beteiligten Instanzen verteilen, da sie prinzipiell auch überall liegen
könnten, bzw. benötigt werden. So müssen zum Beispiel zentral verwaltete
Passwörter auch für die Remote-Instanzen zur Verfügung gestellt werden
und Hosts/Services von Kontaktgruppen können über mehrere Instanzen
verteilt sein.
:::

::: paragraph
Sobald Checkmk jedoch als Dienstleistung einem Dritten (das heißt einem
Kunden) angeboten werden soll, dürfen bestimmte Konfigurationsdaten nur
noch auf *bestimmten* Remote-Instanzen verteilt werden. Das heißt,
sensible Daten eines Kunden dürfen nicht auf dem Server eines anderen
Kunden liegen --- eine reine Einschränkung der Sichtbarkeit in der
Weboberfläche ist daher nicht mehr ausreichend. Schließlich kann es
sein, dass der lokale Monitoring-Server von dem Kunden selbst betrieben
wird oder er anderweitig über direkten Zugang zu der Kommandozeile des
Servers verfügt.
:::

::: paragraph
Zusätzlich ist es nicht mehr erforderlich, dass ein Kunde seine Instanz
konfigurieren kann --- der Sinn einer Dienstleistung ist es ja gerade,
diesem Kunden solche Arbeiten zu ersparen. Auch benötigt er keine
zentrale Ansicht, da er nur auf seine eigenen Daten Zugriff benötigt.
:::

::: paragraph
Mit
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** bindet ein Dienstleister (das heißt ein Managed Service
Provider, kurz MSP oder Provider) in seiner Zentralinstanz für jeden
Kunden über das [verteilte Monitoring](distributed_monitoring.html) eine
oder mehrere Remote-Instanzen ein, die nur diesem Kunden gehören.
Einzelne Elemente im [Setup]{.guihint} werden dann diesem Kunden
zugewiesen. Checkmk wird jetzt bei der Verteilung der
Konfigurationsdaten nur diese zu einer Kundeninstanz schicken, welche
entweder allgemeiner Natur sind oder für diesen Kunden freigegeben
wurden. Die Konfiguration kann vom Provider weiterhin bequem über das
verteilte Setup seiner eigenen Zentralinstanz erfolgen. Ebenso steht dem
Provider eine zentrale Weboberfläche für alle seine Kunden zur
Verfügung, um dort mit den Monitoring-Daten arbeiten zu können. Das
funktioniert genauso, wie in einer normalen verteilten Umgebung auch,
mit dem einzigen Unterschied, dass **alle** beteiligten Instanzen
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** verwenden müssen.
:::

:::: imageblock
::: content
![Illustration der Kommunikation im verteilten Monitoring von Checkmk
MSP.](../images/managed_distributed_monitoring_de.png)
:::
::::

::: paragraph
In Checkmk MSP können Kunden wichtige Konfigurationsdaten (zum Beispiel
Remote-Instanzen und Benutzer) zugewiesen werden. Dem Kunden steht also
über die ihm zugeordnete Instanz nur seine eigene Konfiguration mit den
Host- und Service-Daten zur Verfügung. Er muss sich nur auf seiner
eigenen Instanz anmelden und bekommt daher auch nur seine Daten. Ein
Login auf der Zentralinstanz des Providers ist nicht
erforderlich --- und auch nicht möglich!
:::

::: paragraph
**Wichtig**: Sie müssen
[![CME](../images/icons/CME.png "Checkmk MSP"){width="20"}]{.image-inline}
**Checkmk MSP** verwenden, wenn Sie mit Checkmk nicht nur Ihre eigene,
sondern auch die Infrastruktur von anderen Unternehmen überwachen.
:::
:::::::::::::
::::::::::::::

:::::: sect1
## []{#editions .hidden-anchor .sr-only}2. Einordnung von Checkmk MSP {#heading_editions}

::::: sectionbody
::: paragraph
Checkmk MSP ist die derzeit umfangreichste Edition von Checkmk.
Inhaltlich baut sie auf
[[![CSE](../images/icons/CSE.png "Checkmk Cloud"){width="20"}]{.image-inline}
**Checkmk Cloud**](cce.html) auf und ist deren mandantenfähige
Erweiterung. Sie verfügt über alle notwendigen Funktionen, um mit
Checkmk über das verteilte Monitoring voneinander abgeschottete
Instanzen für mehrere Kunden zu betreiben.
:::

::: paragraph
Falls Sie als Provider Checkmk als Dienst für Ihre Kunden anbieten
wollen, ist dies Ihre Edition.
:::
:::::
::::::

:::::: sect1
## []{#functions .hidden-anchor .sr-only}3. Zusätzliche Funktionen von Checkmk MSP {#heading_functions}

::::: sectionbody
::: paragraph
Die wesentliche Funktion von Checkmk MSP, die diese von anderen
Editionen unterscheidet, ist die Möglichkeit, folgende Elemente Kunden
zuzuweisen:
:::

::: ulist
- Remote-Instanzen

- Benutzer

- LDAP-Verbindungen

- [Regeln](glossar.html#rule) und Regelpakete der [Event
  Console](glossar.html#ec)

- Passwörter im [Passwortspeicher](password_store.html)

- Kontaktgruppen

- [Host-Gruppen](glossar.html#host_group) und
  [Service-Gruppen](glossar.html#service_group)

- [BI](glossar.html#bi)-Aggregate

- Globale Einstellungen von Remote-Instanzen
:::
:::::
::::::

::::::::: sect1
## []{#upgrade .hidden-anchor .sr-only}4. Upgrade zu Checkmk MSP {#heading_upgrade}

:::::::: sectionbody
::: paragraph
Für den Wechsel von einer der anderen Editionen zu Checkmk MSP folgen
Sie der [Upgrade-Beschreibung.](update.html#upgrade) Für das Upgrade zu
Checkmk MSP kommt in verteilten Umgebungen nur das
[Offline-Upgrade](update.html#offline_distributed) in Frage.
:::

::: paragraph
Nach dem Upgrade sind alle kompatiblen Komponenten in Checkmk dem
[Provider]{.guihint} zugeordnet. Ihnen stehen nun alle Funktionen zur
Verfügung, um Kunden anzulegen und diesen Instanzen, Benutzer, usw.
zuzuordnen.
:::

::: paragraph
Achten Sie dabei auf mögliche Abhängigkeiten, die sich aus einer bereits
bestehenden Konfiguration ergeben können, und ordnen Sie auch die
richtigen Elemente aus den anderen Komponenten in Checkmk entsprechend
dem Kunden zu, bevor Sie die Zuordnung zu einer Instanz aktivieren.
:::

::: paragraph
**Wichtig**: Mindestens ein Benutzer muss an die Instanz eines Kunden
übertragen werden. Dabei ist es egal, ob es sich um einen globalen
Benutzer handelt, der an alle Instanzen repliziert wird, oder ob es sich
um einen kundenspezifischen Benutzer handelt.
:::

::: paragraph
Weitere Hinweise finden Sie im folgenden Kapitel.
:::
::::::::
:::::::::

::::::::::::::::::::::::::::::::::: sect1
## []{#config .hidden-anchor .sr-only}5. Konfiguration {#heading_config}

:::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_kunden_anlegen .hidden-anchor .sr-only}5.1. Kunden anlegen {#heading__kunden_anlegen}

::: paragraph
Das Anlegen eines Ihrer Kunden erledigen Sie mit lediglich einem
Schritt: Wählen Sie unter [Setup \> Users \> Customers]{.guihint} den
Knopf [Add customer]{.guihint} aus und vergeben Sie dort eine eindeutige
ID, sowie den Namen, wie er in Checkmk angezeigt werden soll. Nach dem
Speichern ist Ihr erster Kunde bereits in Checkmk angelegt:
:::

:::: imageblock
::: content
![Die Ansicht zur Verwaltung von Kunden.](../images/managed_create.png)
:::
::::

::: paragraph
Wie Sie sehen können, wird der Provider ebenfalls wie ein Kunde
behandelt und ist aus diesem Grund als [Provider]{.guihint} bereits
angelegt. Sie können diese Zuweisung nicht löschen.
:::
:::::::

:::::::: sect2
### []{#_instanzen_zuweisen .hidden-anchor .sr-only}5.2. Instanzen zuweisen {#heading__instanzen_zuweisen}

::: paragraph
Nachdem Sie einen Kunden angelegt haben, verknüpfen Sie als nächstes die
entsprechenden Komponenten in Checkmk mit diesem Kunden. Die
Zentralinstanz, an die alle weiteren Instanzen der Kunden ihre Daten
schicken, wird auch *Provider-Instanz* genannt. Die Trennung der Daten
funktioniert nur, wenn Sie für jeden Kunden eine eigene Instanz anlegen
und diese mit Ihrer [Provider-Instanz
verbinden.](distributed_monitoring.html#connect_remote_sites) Die
Einrichtung unterscheidet sich in diesem Fall an einer einzigen Stelle:
Sie geben in den [Basic settings]{.guihint} zusätzlich zu der ID und dem
Alias noch den [Customer]{.guihint} an, welchen Sie zuvor angelegt
haben:
:::

:::: imageblock
::: content
![Auswahl eines Kunden bei der Verbindung einer
Remote-Instanz.](../images/managed_sites.png)
:::
::::

::: paragraph
Dadurch, dass auch der Provider als Kunde behandelt wird, weiß Checkmk
anhand der Zuweisung zu einer Instanz immer, welcher Host zu welchem
Kunden gehört.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die [Global settings]{.guihint}   |
|                                   | einer Kundeninstanz können Sie    |
|                                   | wie gewohnt über die              |
|                                   | [instanzspezifischen globalen     |
|                                   | Einstellungen](distribu           |
|                                   | ted_monitoring.html#sitespecific) |
|                                   | konfigurieren.                    |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::

:::::::::: sect2
### []{#_weitere_zuordnungen .hidden-anchor .sr-only}5.3. Weitere Zuordnungen {#heading__weitere_zuordnungen}

::: paragraph
Neben der Instanz selbst können Sie --- wie bereits weiter
[oben](#functions) erwähnt --- auch andere Elemente aus dem
[Setup]{.guihint} einem Kunden zuweisen. Dabei wird ein Element einem
Kunden direkt zugewiesen. Alternativ können Sie einen Benutzer oder ein
Passwort mit dem Eintrag [Global]{.guihint} aber auch *allen* zur
Verfügung stellen. Hier am Beispiel eines Benutzers:
:::

:::: imageblock
::: content
![Die Einträge der Option \'Customer\'.](../images/managed_users.png)
:::
::::

::: paragraph
Die Zuweisung erfolgt dabei immer über die Eigenschaften des jeweiligen
Elements über die Option [Customer.]{.guihint} Ausgenommen davon sind
die instanzspezifischen globalen Einstellungen.
:::

::::: sect3
#### []{#_besonderheiten_bei_der_event_console .hidden-anchor .sr-only}Besonderheiten bei der Event Console {#heading__besonderheiten_bei_der_event_console}

::: paragraph
In der [Event Console](glossar.html#ec) können Sie sowohl einzelne
Regeln, als auch ganze Regelpakete einem Kunden zuordnen. Dabei gilt es
zu beachten, dass die Vererbung bei Regelpaketen immer zwingend erfolgt.
Sie kann also --- anders, als bei Ordnern --- nicht von den einzelnen
Regeln wieder überschrieben werden. Auf diese Weise können Sie sich
immer darauf verlassen, dass die Zuordnung bei jeder Regel gewährleistet
ist.
:::

::: paragraph
Ist ein Regelpaket keinem Kunden zugeordnet, können Sie auch die
einzelnen Regeln jeweils einem Kunden zuordnen.
:::
:::::
::::::::::

:::::::::: sect2
### []{#_nicht_anpassbare_komponenten .hidden-anchor .sr-only}5.4. Nicht anpassbare Komponenten {#heading__nicht_anpassbare_komponenten}

::: paragraph
Alle Komponenten, welche im vorherigen [Kapitel](#functions) nicht
genannt wurden, können einzelnen Kunden *nicht* zugewiesen werden.
Dennoch gibt es ein paar Worte zu verschiedenen Komponenten zu
verlieren, um auf Besonderheiten aufmerksam zu machen. Die
Nichtbeachtung dieser Hinweise kann ein moderates Sicherheitsrisiko
darstellen.
:::

:::: sect3
#### []{#_host_merkmale .hidden-anchor .sr-only}Host-Merkmale {#heading__host_merkmale}

::: paragraph
Auch für [Host-Merkmale](glossar.html#host_tag) (*host tags*) gilt, dass
sie keine vertraulichen Informationen enthalten dürfen, da die Merkmale
an alle Instanzen verteilt werden.
:::
::::

:::: sect3
#### []{#_benachrichtigungen .hidden-anchor .sr-only}Benachrichtigungen {#heading__benachrichtigungen}

::: paragraph
Regeln zu [Benachrichtigungen](glossar.html#notification) enthalten oft
Kontaktgruppen und sehr spezifische Bedingungen, unter denen die
Benachrichtigung ausgelöst und verschickt werden soll. Da auch diese
Regeln an alle Instanzen verteilt werden, verzichten Sie hier
insbesondere auf explizite Host- und Service-Namen, Kontaktadressen und
andere sensible Daten.
:::
::::

:::: sect3
#### []{#_anpassungen_bei_globalen_benutzern .hidden-anchor .sr-only}Anpassungen bei globalen Benutzern {#heading__anpassungen_bei_globalen_benutzern}

::: paragraph
Beachten Sie, dass alle Anpassungen, welche bei einem globalen Benutzer
vorgenommen werden, auf alle Instanzen der Kunden übertragen werden.
Globale Benutzer eignen sich daher nicht für spezielle Ansichten, eigene
Graphen oder Lesezeichen, da diese sensible, kundenspezifische Daten
enthalten können. Nutzen Sie die globalen Benutzer daher eher für
Ausnahmefälle und nicht für reguläre, alltägliche Aufgaben.
:::
::::
::::::::::

:::::: sect2
### []{#certificate_management .hidden-anchor .sr-only}5.5. Zertifikatsmanagement {#heading_certificate_management}

::: paragraph
Die im vorhergehenden Kapitel erwähnten Punkte wie Benachrichtigungen
mit Kontaktgruppen oder Host-Merkmale können lediglich Informationen
über organisatorische Strukturen anderer Kunden offen legen.
:::

::: paragraph
Anders sieht es mit der Verteilung von CA („Certificate Authority")
Root-Zertifikaten aus: Würde ein für *Kunde A* bestimmtes CA-Zertifikat
zu *Kunde B* verteilt werden, bestünde die Gefahr, dass böswillige
Mitarbeitende bei *Kunde A* einen *Machine-in-the-Middle-Angriff* auf
die verschlüsselte Kommunikation bei *Kunde B* durchführen können. Aus
diesem Grund werden mit der globalen Einstellung [Trusted certificate
authorities for SSL]{.guihint} hinterlegte CA-Zertifikate *nicht* zu den
Remote-Instanzen übertragen.
:::

::: paragraph
Der richtige Weg zur Konfiguration von kundenspezifischen
CA-Zertifikaten ist es, sie in den [instanzspezifischen globalen
Einstellungen](distributed_monitoring.html#sitespecific) der
Remote-Instanzen des Kunden einzutragen.
:::
::::::
::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#details .hidden-anchor .sr-only}6. Unterschiede der Komponenten im Detail {#heading_details}

:::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#setup .hidden-anchor .sr-only}6.1. Setup-Oberfläche {#heading_setup}

::: paragraph
In [Setup \> Users \> Customers]{.guihint} können Sie auf eine Ansicht
zur Verwaltung der Kunden zugreifen.
:::

::: paragraph
Bei der Einrichtung der Elemente, die Kunden zugewiesen werden können,
wird ein zusätzliches Feld [Customer]{.guihint} angeboten.
:::

::: paragraph
Diese Funktionen werden exemplarisch im Kapitel zur
[Konfiguration](#config) beschrieben.
:::
::::::

::::::::::::::::::: sect2
### []{#ui .hidden-anchor .sr-only}6.2. Monitoring-Oberfläche {#heading_ui}

::::::: sect3
#### []{#_dashboard .hidden-anchor .sr-only}Dashboard {#heading__dashboard}

::: paragraph
Neu im [Main dashboard]{.guihint} ist das Dashlet [Customers]{.guihint},
welches sich links der Service-Probleme befindet:
:::

:::: imageblock
::: content
![Das \'Customers\' Dashlet im \'Main\'
Dashboard.](../images/managed_dashboard.png){width="600"}
:::
::::

::: paragraph
Bei Auswahl eines Kunden gelangen Sie in eine Ansicht, in der alle seine
Hosts gelistet sind. Diese [Tabellenansicht](glossar.html#view)
funktioniert also wie die Ansicht [All hosts]{.guihint} --- mit dem
Unterschied, dass hier nur die Elemente eines bestimmten Kunden
angezeigt werden.
:::
:::::::

:::::: sect3
#### []{#_seitenleiste .hidden-anchor .sr-only}Seitenleiste {#heading__seitenleiste}

::: paragraph
Für die [Seitenleiste](glossar.html#sidebar) gibt es in der
Zentralinstanz das Snapin [Customers]{.guihint}, welches genauso
funktioniert, wie das ähnlich aussehende Snapin [Site status]{.guihint}.
Sie können sich hier den Status der Instanzen der einzelnen Kunden
ausgeben lassen und mit einem Klick auf den Status bestimmte Kunden aus
der Ansicht aus- oder einblenden.
:::

:::: imageblock
::: content
![Das Snapin \'Customers\' der
Seitenleiste.](../images/managed_snapin.png){width="50%"}
:::
::::
::::::

::::::::: sect3
#### []{#_ansichten_filtern_und_bauen .hidden-anchor .sr-only}Ansichten filtern und bauen {#heading__ansichten_filtern_und_bauen}

::: paragraph
Selbstverständlich können Sie die Filter und Datensätze, so wie sie für
das Dashlet und das Snapin verwendet werden, auch für die eigenen
Ansichten benutzen. Zum einen ist dafür der Filter [Site]{.guihint}
erweitert worden, um eine [Ansicht anzupassen:](views.html#using_views)
:::

:::: imageblock
::: content
![Der um Kunden erweiterte Filter
\'Site\'.](../images/managed_filter.png){width="60%"}
:::
::::

::: paragraph
Zum anderen können Sie auch ganz [neue Ansichten](views.html#new) auf
Basis eines oder aller Kunden bauen. Wählen Sie dazu als Datenquelle
[All customers]{.guihint} aus:
:::

:::: imageblock
::: content
![Die Datenquelle \'All customers\' beim Erstellen einer
Ansicht.](../images/managed_customer_view.png)
:::
::::
:::::::::
:::::::::::::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
