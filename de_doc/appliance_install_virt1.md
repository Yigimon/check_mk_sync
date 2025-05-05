:::: {#header}
# Virtuelle Appliance installieren

::: details
[Last modified on 08-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/appliance_install_virt1.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Checkmk in der Appliance installieren](install_appliance_cmk.html)
[Appliance einrichten und nutzen](appliance_usage.html)
:::
::::
:::::
::::::
::::::::

:::::: sect1
## []{#virtual_appliance .hidden-anchor .sr-only}1. Die virtuelle Appliance {#heading_virtual_appliance}

::::: sectionbody
::: paragraph
Mit der virtuellen Appliance *Checkmk virt1* können Sie Checkmk als Gast
auf einer vorhandenen Virtualisierungsplattform (*Hypervisor*) wie
VMware ESXi oder Proxmox betreiben. Auch VirtualBox wird unterstützt und
eignet sich besonders gut zum Ausprobieren.
:::

::: paragraph
In der Appliance sind das Betriebssystem und eine Weboberfläche zur
Verwaltung bereits vorinstalliert. Die Appliance wird dialoggestützt
eingerichtet, über die Weboberfläche konfiguriert und ist nach wenigen
Handgriffen einsatzbereit. Sie benötigen daher keine Linux-Kenntnisse.
:::
:::::
::::::

:::::::: sect1
## []{#download_appliance .hidden-anchor .sr-only}2. Download der Appliance {#heading_download_appliance}

::::::: sectionbody
::: paragraph
Sie können die Appliance-Software über die
[Download-Seite](https://checkmk.com/de/download){target="_blank"}
herunterladen. Für Checkmk Enterprise und Checkmk MSP benötigen Sie eine
gültige Subskription und die zugehörigen Zugangsdaten.
:::

::: paragraph
Für die virtuelle Appliance werden die folgenden Dateitypen zum Download
angeboten:
:::

::: ulist
- OVA-Datei: Die virtuelle Appliance Checkmk virt1 für den Import in den
  Hypervisor. OVA steht für Open Virtualization Archive und ist das
  Archivformat des Open Virtualization Format (OVF). Die OVA-Datei
  finden Sie im Download-Bereich beim Produkt Checkmk Appliance.

  ::: paragraph
  Diese Datei benötigen Sie für die Erstinstallation.
  :::

- CFW-Datei: Die Firmware der Appliance. Genau wie die OVA-Datei wird
  eine CFW-Datei im Download-Bereich für jede Appliance-Version
  bereitgestellt. Mit dieser Datei können Sie eine bereits installierte
  Appliance im laufenden Betrieb aktualisieren. Das [Update der
  Firmware](appliance_usage.html#cma_webconf_firmware) erfolgt mit der
  Appliance-Weboberfläche.

  ::: paragraph
  Die CFW-Datei benötigen Sie nicht für die Erstinstallation, da in der
  OVA-Datei die Firmware bereits enthalten ist.
  :::

- CMA-Datei: Die Checkmk-Software zur Installation in der Appliance.
  Beginnend mit der Appliance-Version 1.4.14 ist in der Appliance keine
  Checkmk-Software mehr vorinstalliert. Auch die [Installation der
  Checkmk-Software](appliance_usage.html#manage_cmk) führen Sie mit der
  Appliance-Weboberfläche durch. Die CMA-Datei wird Ihnen im
  Download-Bereich angeboten, nach Auswahl der Appliance als Plattform,
  der Checkmk-Edition sowie -Version.

  ::: paragraph
  Die CMA-Datei benötigen Sie erst **nach** abgeschlossener
  Installation --- wenn Sie die Konfiguration der Appliance durchführen.
  :::
:::

::: paragraph
Laden Sie die OVA-Datei für die Erstinstallation der virtuellen
Appliance herunter.
:::
:::::::
::::::::

:::::::::::::::: sect1
## []{#install_virtualbox .hidden-anchor .sr-only}3. Installation unter VirtualBox {#heading_install_virtualbox}

::::::::::::::: sectionbody
:::: sect2
### []{#_voraussetzungen .hidden-anchor .sr-only}3.1. Voraussetzungen {#heading__voraussetzungen}

::: paragraph
Für die folgenden Schritte benötigen Sie außer der OVA-Datei eine
laufende VirtualBox-Installation. Auf welchem System VirtualBox läuft,
spielt dabei keine Rolle.
:::
::::

:::::::::::: sect2
### []{#_import_der_appliance .hidden-anchor .sr-only}3.2. Import der Appliance {#heading__import_der_appliance}

::: paragraph
Starten Sie den Import der OVA-Datei über [File \> Import
Appliance]{.guihint} und wählen Sie die OVA-Datei aus. Sie sehen
anschließend alle Einstellungen der virtuellen Maschine --- und können
diese auch so belassen. Freilich können Sie an diesem Punkt oder
nachträglich Werte ändern, um der Maschine etwa weitere Ressourcen
zuzuschreiben.
:::

::: paragraph
**Wichtig:** Bei den Appliance-Einstellungen sollten Sie unter [MAC
Address Policy]{.guihint} dringend die Option [Generate new MAC
addresses for all network adapters]{.guihint} wählen. Andernfalls wird
es zu Problemen kommen, wenn mehrere Appliances mit derselben
MAC-Adresse im Netzwerk laufen.
:::

:::: {.imageblock .border}
::: content
![virt1 virtualbox import](../images/virt1_virtualbox_import.png)
:::
::::

::: paragraph
Sie können die Appliance nun importieren.
:::

::: paragraph
Nach dem Import müssen Sie noch einen weiteren Schritt durchführen:
Rufen Sie die Netzwerkkonfiguration der virtuellen Maschine auf. Der
Modus ist hier auf [Bridged Adapter]{.guihint} gesetzt: Der virtuelle
Netzwerkadapter wird dabei mit einem Adapter auf Ihrem Host
verbunden --- und die variieren natürlich. Im Zweifelsfall verlassen Sie
die Konfiguration einfach ohne Änderung mit
[OK]{.guihint} --- VirtualBox ergänzt den fehlenden Adapternamen dann
automatisch mit Ihrem Standardadapter.
:::

:::: imageblock
::: content
![virt1 virtualbox
network](../images/virt1_virtualbox_network.png){width="90%"}
:::
::::

::: paragraph
Damit haben Sie die VirtualBox-spezifischen Schritte abgeschlossen.
:::
::::::::::::
:::::::::::::::
::::::::::::::::

:::::::::::::::: sect1
## []{#install_esxi .hidden-anchor .sr-only}4. Installation unter VMware ESXi {#heading_install_esxi}

::::::::::::::: sectionbody
:::: sect2
### []{#_voraussetzungen_2 .hidden-anchor .sr-only}4.1. Voraussetzungen {#heading__voraussetzungen_2}

::: paragraph
Sie benötigen die OVA-Datei der Appliance. Außerdem brauchen Sie einen
ESXi-Server, der bereits im Netzwerk läuft, und darin einen
*Datenspeicher* für die Konfigurationen der virtuellen Maschinen.
:::
::::

:::::::::::: sect2
### []{#_import_der_appliance_2 .hidden-anchor .sr-only}4.2. Import der Appliance {#heading__import_der_appliance_2}

::: paragraph
Der Import der Appliance läuft weitgehend automatisch, im Anschluss
sollten Sie jedoch noch einen Blick auf die Netzwerkkonfiguration
werfen.
:::

::: {.olist .arabic}
1.  Wählen Sie in der ESXi-Hauptnavigation den Punkt [Virtual
    Machines.]{.guihint}

2.  Starten Sie den Importassistenten über [Create/Register
    VM.]{.guihint}

3.  Wählen Sie den Import via OVA/OVF.

4.  Fügen Sie die OVA-Datei hinzu.

5.  Klicken Sie sich weiter durch den Assistenten, ohne weitere
    Änderungen vorzunehmen.
:::

::: paragraph
Anschließend wird die neue Maschine bereitgestellt, was einige Minuten
dauern kann.
:::

:::: imageblock
::: content
![virt1 esxi import](../images/virt1_esxi_import.png)
:::
::::

::: paragraph
**Wichtig:** Checkmk virt1 wird mit einem Netzwerk-Interface vom Typ
*E1000* ausgeliefert, einer Emulation des 1 GB-Netzwerkadapters *Intel
82545EM Gigabit Ethernet NIC*, für den in der Regel bereits Treiber
bereitstehen. Auf einem ESXi-Server sollten Sie die Karte für eine
bessere Performance gegen eine Karte vom Typ *VMXNET 3* austauschen, ein
komplett virtualisiertes 10 GB-Interface. Ändern Sie dafür die
Einstellung unter [virt1 \> Edit \> Network Adapter 1 \> Adapter
Type:]{.guihint}
:::

:::: imageblock
::: content
![virt1 esxi network](../images/virt1_esxi_network.png)
:::
::::

::: paragraph
Damit haben Sie die VMware ESXi-spezifischen Schritte abgeschlossen.
:::
::::::::::::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::: sect1
## []{#install_proxmox .hidden-anchor .sr-only}5. Installation unter Proxmox {#heading_install_proxmox}

::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#_voraussetzungen_3 .hidden-anchor .sr-only}5.1. Voraussetzungen {#heading__voraussetzungen_3}

::: paragraph
Sie benötigen die OVA-Datei der Appliance und eine laufende
Proxmox-Installation (Grundkonfiguration genügt).
:::
::::

::::: sect2
### []{#_ablauf .hidden-anchor .sr-only}5.2. Ablauf {#heading__ablauf}

::: paragraph
Der Import unter Proxmox muss derzeit noch teils händisch erledigt
werden, daher läuft er in mehreren Schritten ab:
:::

::: {.olist .arabic}
1.  Anlegen der virtuellen Maschine per Proxmox-Weboberfläche

2.  Upload der OVA-Datei auf den Proxmox-Server

3.  Entpacken der OVA-Datei im Terminal

4.  Import der virtuellen Festplatten im Terminal

5.  Aktivierung der Festplatten, Festlegung eines Bootlaufwerks und
    Aktivierung von UEFI
:::
:::::

::::::::::::::::::::::: sect2
### []{#_import_der_appliance_3 .hidden-anchor .sr-only}5.3. Import der Appliance {#heading__import_der_appliance_3}

::: paragraph
Legen Sie zunächst eine virtuelle Maschine in der Proxmox-Weboberfläche
an. Setzen Sie dabei zumindest folgende Einstellungen abseits der
Vorgaben:
:::

::: ulist
- [General \> VM ID:]{.guihint} beliebig, hier `103`

- [OS: Do not use any media]{.guihint}

- [Disks:]{.guihint} Löschen Sie den vorgegebenen Eintrag.

- [CPU \> Sockets:]{.guihint} `2`

- [Memory (MiB):]{.guihint} `4096`
:::

:::: imageblock
::: content
![Zusammenfassung der neuen
Proxmox-VM.](../images/introduction_virt1_proxmox_vm.png)
:::
::::

::: paragraph
Laden Sie nun die OVA-Datei auf den Proxmox-Server (hier
`myproxmox.com`) hoch:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@linux# scp virt1-1.7.1.ova root@myproxmox.com:/var/lib/vz/images
```
:::
::::

::: paragraph
Wechseln Sie via SSH zum Proxmox-Server und entpacken Sie die
hochgeladene OVA-Datei:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@linux# ssh root@myproxmox.com
root@myproxmox# cd /var/lib/vz/images
root@myproxmox# /var/lib/vz/images# tar xvf virt1-1.7.1.ova
virt1-1.7.1.ovf
virt1-1.7.1.mf
virt1-1.7.1-disk1.vmdk
virt1-1.7.1-disk2.vmdk
root@myproxmox# /var/lib/vz/images#
```
:::
::::

::: paragraph
Dann importieren Sie die beiden virtuellen Datenträger in die virtuelle
Maschine (hier die [VM ID]{.guihint} `103`) und Ihren Speicher
(Standard: `local-lvm`):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@myproxmox# qm importdisk 103 virt1-1.7.1-disk1.vmdk local-lvm
importing disk '/var/lib/vz/images/virt1-1.7.1-disk1.vmdk' to VM 103 ...
...
Successfully imported disk as 'unused0:local-lvm:vm-103-disk-0'
root@myproxmox# qm importdisk 103 virt1-1.7.1-disk2.vmdk local-lvm
importing disk '/var/lib/vz/images/virt1-1.7.1-disk2.vmdk' to VM 103 ...
...
Successfully imported disk as 'unused1:local-lvm:vm-103-disk-1'
```
:::
::::

::: paragraph
Die CMA-Datei sowie die entpackten Dateien können Sie nun wieder
löschen.
:::

::: paragraph
Als nächstes müssen Sie die soeben importierten Festplatten in Proxmox
aktivieren, da sie nach dem Importvorgang zunächst [Unused]{.guihint}
sind. Öffnen Sie die VM in der GUI von Proxmox und wählen Sie dort
[Hardware]{.guihint}. Doppelklicken Sie auf die erste Festplatte und
klicken Sie dann auf [Add]{.guihint}. Wiederholen Sie diesen Vorgang für
die zweite Platte.
:::

::: paragraph
Ab der Version [1.7.0]{.new} unterstützen **neue** Installationen der
Checkmk Appliance nur noch das Booten per UEFI. Um UEFI zu aktivieren,
benötigen Sie zunächst eine EFI-Disk. Fügen Sie diese hinzu, indem Sie
auf [Add]{.guihint} klicken und [EFI Disk]{.guihint} auswählen. Wählen
Sie den Speicherort für diese neue EFI-Disk, **entfernen** Sie den Haken
bei [Pre-Enroll keys]{.guihint} und klicken Sie auf [OK]{.guihint}.
Doppelklicken Sie nun auf [BIOS]{.guihint} und wechseln Sie zu [OVMF
(UEFI)]{.guihint}.
:::

::: paragraph
Als Nächstes müssen Sie das Gerät mit der Zeichenkette `disk-0` in
seiner Beschreibung als Boot-Gerät über [Options \> Boot
Order]{.guihint} aktivieren. Deaktivieren Sie währenddessen **alle**
anderen Geräte in diesem Menü und klicken Sie auf [OK]{.guihint}.
:::

:::: imageblock
::: content
![appliance install virt1 proxmox boot
order](../images/appliance_install_virt1_proxmox_boot_order.png){width="88%"}
:::
::::

::: paragraph
Damit haben Sie die Proxmox-spezifischen Schritte abgeschlossen. Ihre
Appliance ist jetzt startklar und Sie können mit der
[Grundkonfiguration](appliance_usage.html#basic_config) beginnen.
:::
:::::::::::::::::::::::
:::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
