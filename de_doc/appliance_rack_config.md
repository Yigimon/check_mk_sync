:::: {#header}
# Besonderheiten der Hardware-Appliance

::: details
[Last modified on 15-Dec-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_rack_config.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Appliance einrichten und nutzen](appliance_usage.html) [Appliance im
Cluster-Betrieb](appliance_cluster.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![appliance rack1
cutout](../images/appliance_rack1_cutout.png){width="150"}
:::
::::

::: paragraph
Die Checkmk-Hardware-Appliance unterscheidet sich in einigen wenigen
Punkten von der virtuellen Appliance.
:::

::: paragraph
Zum einen verfügen die Racks über einen RAID-1-Verbund und einen
entsprechenden Menüpunkt in der Weboberfläche.
:::

::: paragraph
Zum anderen steht ein separates Management-Interface zur Verfügung, über
welches das Rack unabhängig von der regulären Netzwerkverbindung
gesteuert werden kann.
:::

::: paragraph
Außerdem können Sie die Racks mit einem SMS-Modem versehen, um bei
Ausfällen zuverlässig benachrichtigt zu werden.
:::

::: paragraph
Alle Aspekte erläutern wir in diesem Artikel, alles Weitere finden Sie
im [Appliance-Hauptartikel.](appliance_usage.html)
:::
::::::::::
:::::::::::

:::::::::: sect1
## []{#_anschlüsse_des_racks .hidden-anchor .sr-only}2. Anschlüsse des Racks {#heading__anschlüsse_des_racks}

::::::::: sectionbody
::: paragraph
Das Rack ist auf Redundanz und Fernwartung ausgelegt --- also nutzen Sie
beide Stromanschlüsse! Und das [Management-Interface,](#ipmi) um
zukünftig absolut keinen physischen Zugriff mehr zu benötigen.
:::

::::: imageblock
::: content
![Rückseite des Rack-Servers mit markierten
Anschlüssen.](../images/appliance_back_full.jpg)
:::

::: title
Rückseite des rack1: Doppelte Stromversorgung sorgt für deutlich mehr
Ausfallsicherheit
:::
:::::

::: paragraph
Die Racks verfügen zudem über eine Erweiterung mit zwei zusätzlichen
Netzwerkanschlüssen - für weitere Redundanz im
[Cluster-Betrieb.](appliance_cluster.html)
:::

::: paragraph
Sofern Sie ein **rack5** nutzen: Für die Ersteinrichtung müssen Sie
einen der Kupfer-Netzwerkanschlüsse verwenden. Über die zusätzlichen
Glasfaser-Schnittstellen kann initial keine IP-Adresse bezogen werden,
dies können Sie nur über die Weboberfläche erledigen.
:::
:::::::::
::::::::::

::::::::::::::::: sect1
## []{#_der_raid_verbund .hidden-anchor .sr-only}3. Der RAID-Verbund {#heading__der_raid_verbund}

:::::::::::::::: sectionbody
::: paragraph
Ihr Rack verfügt über zwei belegte Festplatteneinschübe an der
Vorderseite des Gehäuses. Diese sind bei den rack5-Geräten mit den
Nummern 0 und 1 markiert. Die hier eingebauten Festplatten sind in einem
RAID-1-Verbund (Spiegel) zusammengeschaltet, so dass Ihre Daten auf
beiden Festplatten redundant gespeichert werden. Sollte eine der
Festplatten ausfallen, sind die Daten weiterhin auf der zweiten
Festplatte verfügbar.
:::

### Verwaltung in der Weboberfläche {#_verwaltung_in_der_weboberfläche .discrete}

::: paragraph
Den Zustand des RAIDs können Sie in der Weboberfläche Ihres Geräts
einsehen. Wählen Sie dazu im Hauptmenü der Weboberfläche den Punkt
[RAID-Setup]{.guihint}. Außerdem haben Sie in dieser Maske die
Möglichkeit, das RAID zu reparieren, wenn es erforderlich sein sollte.
:::

:::: {.imageblock .border}
::: content
![cma de rack1 raid ok](../images/cma_de_rack1_raid_ok.png)
:::
::::

### Tausch einer defekten Festplatte {#_tausch_einer_defekten_festplatte .discrete}

::: paragraph
Wenn eine Festplatte als defekt erkannt wird, wird diese in der
Weboberfläche als [Degraded]{.guihint} angezeigt. Am Gerät selbst wird
der Fehler, je nach Art, durch eine blau blinkende LED-Lampe am
Festplatteneinschub angezeigt.
:::

:::: imageblock
::: content
![cma de rack1 raid broken](../images/cma_de_rack1_raid_broken.png)
:::
::::

::: paragraph
Durch Betätigen des kleinen Hebels an der linken Seite des Einschubs
wird die Befestigung entriegelt und Sie können den Rahmen inklusive
Festplatte aus dem Gehäuse ziehen. Nun können Sie die Schrauben an der
Unterseite des Rahmens lösen und die defekte Festplatte aus dem Rahmen
entfernen. Montieren Sie jetzt die neue Festplatte im Rahmen und
schieben Sie diesen wieder in den freien Einschub des Geräts.
:::

::: paragraph
Wenn das Gerät eingeschaltet ist, während Sie die Festplatte
austauschen, startet die Wiederherstellung des RAIDs automatisch. Den
Fortschritt können Sie in der Weboberfläche einsehen.
:::

:::: imageblock
::: content
![cma de rack1 raid repair](../images/cma_de_rack1_raid_repair.png)
:::
::::

::: paragraph
Die Ausfallsicherheit ist erst wiederhergestellt, wenn das RAID
vollständig repariert wurde.
:::

### Defekt beider Festplatten {#_defekt_beider_festplatten .discrete}

::: paragraph
Wenn das Gerät erkennt, dass beide Festplatten defekt sind oder entfernt
wurden, wird automatisch ein Neustart ausgelöst.
:::
::::::::::::::::
:::::::::::::::::

:::::::::::::::: sect1
## []{#ipmi .hidden-anchor .sr-only}4. Management-Interface des Racks {#heading_ipmi}

::::::::::::::: sectionbody
::: paragraph
Ihr Rack verfügt über ein eingebautes Management-Interface ([Dell
iDrac](https://www.dell.com/de-de/dt/solutions/openmanage/idrac.htm){target="_blank"}).
Sie können über die Weboberfläche dieses Management-Interfaces
beispielsweise das Gerät steuern, wenn es nicht eingeschaltet oder nicht
mehr erreichbar sein sollte, sowie die lokale Konsole fernsteuern.
:::

::: paragraph
Wenn Sie das Management-Interface nutzen möchten, müssen Sie zunächst
den dedizierten IPMI-LAN-Anschluss mit Ihrem Netzwerk verbinden.
:::

::::: imageblock
::: content
![iDrac-Anschluss auf der
Rack-Rückseite.](../images/appliance_back_idrac.jpg)
:::

::: title
iDrac ermöglicht Zugriff über das Netzwerk, selbst wenn der Server
ausgeschaltet ist
:::
:::::

::: paragraph
**Achtung:** Wir empfehlen aus Sicherheitsgründen, das IPMI-LAN mit
einem dedizierten Management-Netzwerk zu verbinden, sofern dies möglich
ist.
:::

::: paragraph
Das Management-Interface ist im Auslieferungszustand deaktiviert. Sie
können es über die Einstellung [Management Interface]{.guihint} in den
Geräteeinstellungen aktivieren und konfigurieren.
:::

:::: {.imageblock .border}
::: content
![appliance usage management interface in the
rack](../images/appliance_usage_management_interface_in_the_rack.png)
:::
::::

::: paragraph
Hier müssen Sie für das Management-Interface eine separate IP-Adresse
vergeben sowie dedizierte Zugangsdaten für den Zugriff einstellen.
:::

::: paragraph
Nachdem Sie diese Einstellungen gespeichert haben, können Sie mit Ihrem
Webbrowser die IP-Adresse des Management-Interfaces öffnen und sich dort
mit den soeben festgelegten Zugangsdaten einloggen.
:::

::: paragraph
**Wichtig:** Die Einstellungen zum Management-Interface sind persistent,
bleiben also auch beim Zurücksetzen auf die Werkseinstellungen erhalten.
Damit ist sichergestellt, dass Sie später keinen physischen Zugriff mehr
auf das Rack benötigen.
:::
:::::::::::::::
::::::::::::::::

:::::: sect1
## []{#update_bios .hidden-anchor .sr-only}5. BIOS, iDrac oder Firmware aktualisieren {#heading_update_bios}

::::: sectionbody
::: paragraph
Falls Sie das BIOS, den iDrac oder die Firmware von Hardware-Komponenten
(wie RAID-Controller oder SSDs) der Appliance aktualisieren **müssen**,
können Sie dies nach eigenem Ermessen tun. Die Aktualisierung des BIOS,
des iDrac oder der Firmware von Hardware-Komponenten gefährdet in keiner
Weise Ihren Support. Bitte gehen Sie bei der Aktualisierung derartiger
Software aber mit der nötigen Sorgfalt vor und nehmen Sie diese nur vor,
wenn Sie ein tatsächlich vorliegendes Problem damit beheben können. In
dem unwahrscheinlichen Fall, dass Probleme auftreten, können Sie Ihren
[Hardware-Support-Partner](appliance_usage.html#service) um
Unterstützung bitten.
:::

::: paragraph
Alle **aktuellen** Appliances basieren auf Dell-Hardware, daher können
Sie deren [offizielle
Dokumentation](https://www.dell.com/support/kbdoc/de-de/000134013/dell-poweredge-remote-update-der-firmware-von-einzelkomponenten-eines-systems-ueber-idrac?lang=de){target="_blank"}
verwenden, um zu erfahren, wie Sie BIOS/iDrac-Updates durchführen.
:::
:::::
::::::

::::::::::::::::::::: sect1
## []{#_sms_benachrichtigungen .hidden-anchor .sr-only}6. SMS-Benachrichtigungen {#heading__sms_benachrichtigungen}

:::::::::::::::::::: sectionbody
::::: sect2
### []{#_hardware .hidden-anchor .sr-only}6.1. Hardware {#heading__hardware}

::: paragraph
Es ist möglich, ein GSM-Modem an das Gerät anzuschließen, um darüber,
z.B. bei kritischen Problemen, SMS-Benachrichtigungen verschicken zu
lassen.
:::

::: paragraph
Aktuell ist es nicht möglich, ein UMTS-/GSM-Modem zusammen mit der
Appliance oder nachträglich als Zubehör zu erwerben. Es gibt aber
diverse Modems, wie z.B. das
[MTD-H5-2.0,](https://www.multitech.com/models/92507087LF){target="_blank"}
die mit der Appliance kompatibel sind. Alle unterstützten Modelle finden
Sie in der [Checkmk Knowledge
Base.](https://checkmk.atlassian.net/wiki/spaces/KB/pages/9473339){target="_blank"}
:::
:::::

:::::::::: sect2
### []{#_inbetriebnahme_des_modems .hidden-anchor .sr-only}6.2. Inbetriebnahme des Modems {#heading__inbetriebnahme_des_modems}

::: paragraph
Um das Modem in Betrieb zu nehmen, müssen Sie eine funktionsfähige
SIM-Karte einlegen und es an einen freien USB-Anschluss Ihrer Appliance
anschließen.
:::

::: paragraph
Sobald dies erledigt ist, erkennt das Gerät das Modem automatisch und
richtet es ein. Öffnen Sie die Weboberfläche des Geräts und wählen Sie
das Modul [Manage SMS.]{.guihint} Auf dieser Seite wird Ihnen der
aktuelle Zustand des Modems sowie der Verbindung mit dem Mobilfunknetz
angezeigt.
:::

:::: {.imageblock .border}
::: content
![appliance usage manage sms](../images/appliance_usage_manage_sms.png)
:::
::::

::: paragraph
Sofern Sie zur Nutzung Ihrer SIM-Karte eine PIN eingeben müssen, können
Sie diese unter [SMS Settings]{.guihint} festlegen.
:::

:::: {.imageblock .border}
::: content
![appliance usage configure
sms](../images/appliance_usage_configure_sms.png)
:::
::::
::::::::::

:::::::: sect2
### []{#_fehlerdiagnose .hidden-anchor .sr-only}6.3. Fehlerdiagnose {#heading__fehlerdiagnose}

::: paragraph
Falls verschickte Nachrichten Sie nicht erreichen, können Sie alle
verschickten, nicht verschickten sowie in der Warteschlange befindlichen
Nachrichten auf der Seite [Manage SMS]{.guihint} einsehen. Die Einträge
in diesen Listen werden für maximal 30 Tage aufgehoben und anschließend
automatisch gelöscht.
:::

::: paragraph
Über den Menüpunkt [Send test SMS]{.guihint} ist es möglich, eine
Test-SMS an eine Nummer Ihrer Wahl zu verschicken. Die Telefonnummer
muss dabei ohne führende Nullen und ohne führendes Plus-Zeichen
eingegeben werden, also z.B. `491512345678` für eine Mobilfunknummer in
Deutschland.
:::

:::: imageblock
::: content
![cma de sms 3](../images/cma_de_sms_3.png)
:::
::::

::: paragraph
Weiterführende Informationen zu eventuellen Fehlern beim SMS-Versand
finden Sie im [SMS Log.]{.guihint}
:::
::::::::
::::::::::::::::::::
:::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
