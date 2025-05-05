:::: {#header}
# SNMP-basierte Check-Plugins schreiben

::: details
[Last modified on 02-Sep-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/devel_check_plugins_snmp.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Erweiterungen für Checkmk entwickeln](devel_intro.html)
[Agentenbasierte Check-Plugins schreiben](devel_check_plugins.html)
[Überwachen via SNMP](snmp.html) [Services verstehen und
konfigurieren](wato_services.html) [Checkmk auf der
Kommandozeile](cmk_commandline.html)
:::
::::
:::::
::::::
::::::::

:::::::::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::::::::::::: sectionbody
::: paragraph
Check-Plugins, die mit SNMP arbeiten, werden auf ähnliche Weise
entwickelt wie ihre [agentenbasierten
Verwandten.](devel_check_plugins.html) Der Unterschied liegt sowohl im
Ablauf der [Service-Erkennung](glossar.html#service_discovery)
(*Discovery*) als auch des Checks selbst. Bei den agentenbasierten
Check-Plugins wird mit dem [Agentenplugin](glossar.html#agent_plugin)
festgelegt, welche Daten an die Checkmk-Instanz *gesendet* werden, zudem
findet auf dem Host oft bereits eine Vorfilterung (aber keine
Auswertung) statt. Im Gegensatz dazu müssen Sie bei SNMP selbst genau
festlegen, welche Datenbereiche Sie benötigen und diese explizit
*anfordern.* Diese Bereiche (Äste eines Baumes) oder einzelne
Datenfelder (Blätter) werden bei SNMP durch OIDs (*object identifier*)
identifiziert.
:::

::: paragraph
Eine Komplettübertragung aller Daten wäre zwar theoretisch möglich
(durch den sogenannten *SNMP-Walk*), dauert aber selbst bei schnellen
Geräten eher im Bereich von Minuten und bei komplexen Switches gern auch
über eine Stunde. Daher scheidet dies bereits bei der Discovery und erst
recht beim Check selbst aus. Checkmk geht hier zielgerichteter vor. Für
das Debugging vorhandener und die Entwicklung eigener Checks stehen in
Checkmk dennoch SNMP-Walks zur Verfügung.
:::

::: paragraph
Falls Sie noch keine Erfahrung mit SNMP haben, empfehlen wir Ihnen als
vorbereitende Lektüre den Artikel über das [Überwachen via
SNMP.](snmp.html)
:::

::::::::: sect2
### []{#snmp_special .hidden-anchor .sr-only}1.1. Was bei SNMP anders läuft {#heading_snmp_special}

::: paragraph
Im Vergleich zu einem Check-Plugin für den Checkmk-Agenten gibt es bei
SNMP einige Besonderheiten zu beachten. Bei einem Check-Plugin für SNMP
teilt sich die Service-Erkennung in zwei Phasen auf.
:::

::: paragraph
Zunächst erfolgt mit der **SNMP-Detection** die Erkennung des Gerätes.
Diese dient dazu, zu ermitteln, ob das Check-Plugin für das jeweilige
Gerät denn überhaupt interessant ist und wird bei jedem Gerät
durchgeführt, welches per SNMP überwacht wird. Dazu werden einige wenige
OIDs abgerufen --- und zwar einzelne, ohne SNMP-Walk. Die wichtigste
davon ist die `sysDescr` (OID: `1.3.6.1.2.1.1.1.0`). Unter dieser OID
hält jedes SNMP-Gerät eine Beschreibung von sich selbst bereit, zum
Beispiel `Flintstones, Inc. Fred Router rev23`.
:::

::: paragraph
Im zweiten Schritt werden für jeden dieser Kandidaten die jeweils
nötigen Monitoring-Daten mit SNMP-Walks geholt. Diese werden dann zu
einer Tabelle zusammengefasst und der **Discovery-Funktion** des
Check-Plugins in dem Argument `section` bereitgestellt, welche dann
daraus die zu überwachenden Items ermittelt. Für jedes dieser Items wird
dann ein [Service](glossar.html#service) erzeugt.
:::

::: paragraph
Beim **Check** ist dann schon bekannt, ob das Plugin für das Gerät
ausgeführt werden soll, und eine erneute SNMP-Detection entfällt. Hier
werden per SNMP-Walks die für das Plugin benötigten aktuellen
Monitoring-Daten geholt.
:::

::: paragraph
Was müssen Sie also bei einem Check-Plugin für SNMP anders machen als
bei einem agentenbasierten?
:::

::: {.olist .arabic}
1.  Sie benötigen *kein* [Agentenplugin.](glossar.html#agent_plugin)

2.  Sie legen die für die SNMP-Detection nötigen OIDs fest und die
    Texte, die diese enthalten sollen.

3.  Sie entscheiden, welche Äste und Blätter des SNMP-Baums für das
    Monitoring geholt werden müssen.
:::
:::::::::

:::::::: sect2
### []{#mibs .hidden-anchor .sr-only}1.2. Keine Angst vor MIBs! {#heading_mibs}

::: paragraph
In diesem kurzen Einschub wollen wir auf die berüchtigten SNMP-MIBs
eingehen, über die es viele Vorurteile gibt. Die gute Nachricht: Checkmk
benötigt keine MIBs! Sie können aber eine wichtige Hilfe bei der
*Entwicklung* eines Check-Plugins oder der *Fehlersuche* in vorhandenen
Check-Plugins sein.
:::

::: paragraph
Was sind MIBs? MIB bedeutet wörtlich *Management Information Base,* was
kaum mehr Information als die Abkürzung beinhaltet. Konkret ist eine MIB
eine auch menschenlesbare Textdatei, welche Äste und Blätter im Baum der
SNMP-Daten beschreibt.
:::

::: paragraph
OIDs können Äste oder Blätter identifizieren. In der Beschreibung der
Äste finden Sie Informationen zu den System- und Subsysteminformationen,
welche der Ast bereithält. Referenziert eine OID ein Blatt, enthalten
die Informationen der MIB Hinweise zum Datentyp (Zeichenkette,
Festkommazahl, Hex-String, ...​), dem Wertebereich und der
Repräsentation. So können Temperaturen beispielsweise mal als
Festkommazahl mit Vorzeichen auf der Celsius-Skala in 0,1° Auflösung
gespeichert werden oder mal ohne Vorzeichen in Schritten von 1,0° auf
der Kelvin-Skala.
:::

::: paragraph
Checkmk liefert eine Reihe von frei verfügbaren MIB-Dateien mit aus.
Diese beschreiben sehr allgemeine Bereiche im globalen OID-Baum,
enthalten aber keine herstellerspezifischen Bereiche. Daher helfen sie
für selbst entwickelte Check-Plugins nicht viel weiter.
:::

::: paragraph
Versuchen Sie also, die für Ihr spezielles Gerät relevanten MIB-Dateien
irgendwo auf der Website des Herstellers oder sogar auf dem
Management-Interface des Geräts zu finden. Installieren Sie diese
Dateien in der Checkmk-Instanz in das Verzeichnis
`~/local/share/snmp/mibs/`. Dann können Sie in SNMP-Walks OID-Nummern in
Namen übersetzen lassen und so schneller die für das Monitoring
interessanten Daten finden. Wie bereits erwähnt, enthalten gut gepflegte
MIBs außerdem interessante Informationen in den Kommentaren. Sie können
eine MIB-Datei einfach mit einem Texteditor oder dem Pager `less`
ansehen.
:::
::::::::
:::::::::::::::::::
::::::::::::::::::::

:::::::::::::::::::::::: sect1
## []{#locating_oids .hidden-anchor .sr-only}2. Die richtigen OIDs finden {#heading_locating_oids}

::::::::::::::::::::::: sectionbody
::: paragraph
Die entscheidende Voraussetzung, um ein SNMP-basiertes Check-Plugin zu
entwickeln, ist, dass Sie wissen, welche OIDs die relevanten
Informationen enthalten. Für das vorgestellte Beispielszenario gehen wir
davon aus, dass Sie einen Schwung Router vom Typ *Flintstones, Inc. Fred
Router rev23* frisch in Betrieb genommen haben. Diesem fiktiven Gerät
werden Sie auch häufig in Herstellerdokumentation und MIB-Kommentaren
begegnen. Dabei haben Sie aber bei einigen Geräten vergessen, Kontakt-
und Standortinformationen einzutragen. Ein selbst geschriebenes
Check-Plugin für Checkmk soll nun helfen, diese Geräte zu
identifizieren.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das von uns vorbereitete          |
|                                   | Beispiel-Plugin ist so            |
|                                   | geschrieben, dass Sie es mit      |
|                                   | *beinahe jedem* SNMP-fähigen      |
|                                   | Gerät durchspielen können.        |
|                                   | Lediglich die zu vergleichende    |
|                                   | Zeichenkette müssen Sie anpassen. |
|                                   | Ist gerade kein Gerät zur Hand,   |
|                                   | finden Sie im Kapitel zur         |
|                                   | [Fehlerbehebung](#simulation)     |
|                                   | verschiedene                      |
|                                   | Simulationsmöglichkeiten.         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Der erste Schritt dahin ist, einen kompletten SNMP-Walk auszuführen.
Dabei werden *alle* per SNMP verfügbaren Daten abgerufen. Checkmk kann
das sehr einfach für Sie erledigen. Nehmen Sie dazu zunächst das Gerät,
für das Sie ein Check-Plugin entwickeln wollen, [in das Monitoring
auf.](snmp.html#add_device) Stellen Sie sicher, dass es [in den
Grundfunktionen](snmp.html#services) überwacht werden kann. Zumindest
müssen die Services [SNMP Info]{.guihint} und [Uptime]{.guihint}
gefunden werden und wahrscheinlich auch noch mindestens ein
[Interface.]{.guihint} So stellen Sie sicher, dass der SNMP-Zugriff
sauber funktioniert.
:::

::: paragraph
Wechseln Sie dann auf die Kommandozeile der Checkmk-Instanz. Hier können
Sie mit folgendem Befehl einen kompletten Walk ziehen --- im folgenden
Beispiel für das Gerät mit dem Host-Namen `mydevice01`. Dabei empfehlen
wir, zusätzlich die Option `-v` (für *verbose*) zu verwenden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --snmpwalk mydevice01
mydevice01:
Walk on ".1.3.6.1.2.1"...3898 variables.
Walk on ".1.3.6.1.4.1"...6025 variables.
Wrote fetched data to /omd/sites/mysite/var/check_mk/snmpwalks/mydevice01.
```
:::
::::

::: paragraph
Wie bereits erwähnt, kann so ein kompletter SNMP-Walk Minuten oder sogar
Stunden dauern (auch wenn letzteres eher selten ist). Werden Sie also
nicht nervös, wenn es hier etwas dauert. Der Walk wird in der Datei
`~/var/check_mk/snmpwalks/mydevice01` gespeichert. Es handelt sich dabei
um eine gut lesbare Textdatei, die etwa so beginnt:
:::

::::: listingblock
::: title
\~/var/check_mk/snmpwalks/mydevice01
:::

::: content
``` {.pygments .highlight}
.1.3.6.1.2.1.1.1.0 Flintstones, Inc. Fred Router rev23
.1.3.6.1.2.1.1.2.0 .1.3.6.1.4.1.424242.2.3
.1.3.6.1.2.1.1.3.0 546522419
.1.3.6.1.2.1.1.4.0 barney@example.com
.1.3.6.1.2.1.1.5.0 big-router-01
.1.3.6.1.2.1.1.6.0 Server room 23, Stonestreet 52, Munich
.1.3.6.1.2.1.1.7.0 72
.1.3.6.1.2.1.1.8.0 0
```
:::
:::::

::: paragraph
In jeder Zeile steht eine OID und danach deren Wert. Gleich in der
ersten Zeile finden Sie die Wichtigste, nämlich die `sysDescr`. Diese
sollte ein Hardware-Modell eindeutig identifizieren.
:::

::: paragraph
Interessant ist auch die zweite Zeile: Unterhalb von `1.3.6.1.4.1`
befinden sich Äste, die Hardware-Hersteller selbst belegen können, hier
hat *Flintstones, Inc.* die fiktive Hersteller-ID `424242`. Darunter hat
das Unternehmen die `2` für Router vergeben und die `3` für eben jenes
Modell. Innerhalb dieses Astes finden Sie dann gerätespezifische OIDs.
:::

::: paragraph
Nun sind die OIDs nicht sehr aussagekräftig. Wenn die richtigen MIBs
installiert sind, können Sie diese in einem zweiten Schritt in Namen
übersetzen lassen. Am besten leiten Sie die Ausgabe des folgenden
Befehls, die sonst im Terminal angezeigt würde, in eine Datei um:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --snmptranslate mydevice01 > /tmp/translated
```
:::
::::

::: paragraph
Die Datei `translated` liest sich wie der ursprüngliche Walk, zeigt aber
in jeder Zeile nach dem `-->` den Namen der OID:
:::

::::: listingblock
::: title
/tmp/translated
:::

::: content
``` {.pygments .highlight}
.1.3.6.1.2.1.1.1.0 Flintstones, Inc. Fred Router rev23 --> SNMPv2-MIB::sysDescr.0
.1.3.6.1.2.1.1.2.0 .1.3.6.1.4.1.424242.2.3 --> SNMPv2-MIB::sysObjectID.0
.1.3.6.1.2.1.1.3.0 546522419 --> DISMAN-EVENT-MIB::sysUpTimeInstance
.1.3.6.1.2.1.1.4.0 barney@example.com --> SNMPv2-MIB::sysContact.0
.1.3.6.1.2.1.1.5.0 big-router-01 --> SNMPv2-MIB::sysName.0
.1.3.6.1.2.1.1.6.0 Server room 23, Stonestreet 52, Munich --> SNMPv2-MIB::sysLocation.0
.1.3.6.1.2.1.1.7.0 42 --> SNMPv2-MIB::sysServices.0
.1.3.6.1.2.1.1.8.0 27 --> SNMPv2-MIB::sysORLastChange.0
```
:::
:::::

::: paragraph
In der obigen Ausgabe hat zum Beispiel die OID `1.3.6.1.2.1.1.4.0` den
Wert `barney@example.com` und den Namen `SNMPv2-MIB::sysContact.0`. Die
zusätzliche Angabe der Namen für die OIDs gibt wichtige Hinweise, um die
interessanten OIDs zu identifizieren. Für das vorgestellte Beispiel
genügen die OIDs `1.3.6.1.2.1.1.4.0` bis `1.3.6.1.2.1.1.6.0`.
:::
:::::::::::::::::::::::
::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#simple_snmp_plugin .hidden-anchor .sr-only}3. Ein einfaches Check-Plugin schreiben {#heading_simple_snmp_plugin}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Nun haben Sie die Vorarbeit erledigt: Sie haben jetzt eine Liste der
OIDs, die Sie auslesen und auswerten wollen. Jetzt geht es darum, anhand
dieser Notizen Checkmk beizubringen, welche Services erzeugt werden, und
wann diese auf [WARN]{.state1} oder [CRIT]{.state2} gehen sollen. Die
dafür angewandte Programmierung eines Check-Plugins in Python hat viele
Parallelen zum [agentenbasierten
Check-Plugin.](devel_check_plugins.html#write_check_plugin) Da einige
Feinheiten zu beachten sind, zeigen wir den vollständigen Aufbau mit
allen verwendeten Funktionen.
:::

::::::::::::::::::: sect2
### []{#scaffold .hidden-anchor .sr-only}3.1. Die Datei vorbereiten {#heading_scaffold}

::: paragraph
Für Ihre eigenen Check-Plugins finden Sie das Basisverzeichnis
vorbereitet in der `local`-Hierarchie des
[Instanzverzeichnisses.](cmk_commandline.html#sitedir) Dieses lautet
`~/local/lib/python3/cmk_addons/plugins/`. Das Verzeichnis gehört dem
Instanzbenutzer und ist daher für Sie schreibbar.
:::

::: paragraph
In diesem Verzeichnis werden die Plugins in *Plugin-Familien*
organisiert, deren Verzeichnisnamen Sie frei wählen können. Zum Beispiel
werden alle Plugins, die Cisco-Geräte betreffen, im Ordner `cisco`
abgelegt --- oder im Ordner `flintstone` alle Plugins, die Router des
Herstellers `Flintstones, Inc.` betreffen.
:::

::: paragraph
In diesem Unterverzeichnis `<plug-in_family>` werden dann nach Bedarf
für die verschiedenen APIs weitere Unterverzeichnisse mit vorgegebenem
Namen angelegt, z.B. `agent_based` für die Check-API agentenbasierter,
einschließlich SNMP-basierter Check-Plugins.
:::

::: paragraph
Erstellen Sie die beiden Unterverzeichnisse für das neue Check-Plugin
und wechseln Sie am besten danach zum Arbeiten dort hinein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir -p local/lib/python3/cmk_addons/plugins/flintstone/agent_based
OMD[mysite]:~$ cd local/lib/python3/cmk_addons/plugins/flintstone/agent_based
```
:::
::::

::: paragraph
Legen Sie die Datei `flintstone_setup_check.py` für das Check-Plugin
hier an. Konvention ist, dass der Dateiname den Namen des Check-Plugins
wiedergibt, wie er bei der Erstellung des Check-Plugins als Instanz der
Klasse `CheckPlugin` festgelegt wird. *Pflicht* ist, dass die Datei mit
`.py` endet, denn ab Version [2.0.0]{.new} von Checkmk handelt es sich
bei den Check-Plugins immer um echte Python-Module.
:::

::: paragraph
Ein lauffähiges Grundgerüst ([Download bei
GitHub](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins_snmp/flintstone_setup_check_bare_minimum.py){target="_blank"}),
das Sie im Folgenden Schritt für Schritt weiter ausbauen werden, sieht
so aus:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python3

from cmk.agent_based.v2 import (
    CheckPlugin,
    CheckResult,
    startswith,
    DiscoveryResult,
    Result,
    Service,
    SimpleSNMPSection,
    SNMPTree,
    State,
    StringTable,
)

def parse_flintstone(string_table):
    return {}

def discover_flintstone(section):
    yield Service()

def check_flintstone(section):
    yield Result(state=State.OK, summary="Everything is fine")

snmp_section_flintstone_setup = SimpleSNMPSection(
    name = "flintstone_base_config",
    parse_function = parse_flintstone,
    detect = startswith(".1.3.6.1.2.1.1.1.0", "Flintstone"),
    fetch = SNMPTree(base='.1.3.6.1.2.1.1', oids=['4.0']),
)

check_plugin__flintstone_setup = CheckPlugin(
    name = "flintstone_setup_check",
    sections = [ "flintstone_base_config" ],
    service_name = "Flintstone setup check",
    discovery_function = discover_flintstone,
    check_function = check_flintstone,
)
```
:::
:::::

::: paragraph
Als erstes müssen Sie die für die Check-Plugins nötigen Funktionen und
Klassen aus Python-Modulen importieren. Vom gelegentlich gesehenen
`import *`, raten wir ab, da es zum einen unnötig viel Speicher nutzt
und zum anderen verschleiert, welche Namespaces tatsächlich verfügbar
gemacht werden. Für unser Beispiel wird nur importiert, was im weiteren
Verlauf des Artikels genutzt wird oder nützlich sein kann.
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
from cmk.agent_based.v2 import (
    CheckPlugin,
    CheckResult,
    startswith,
    DiscoveryResult,
    Result,
    Service,
    SimpleSNMPSection,
    SNMPTree,
    State,
    StringTable,
)
```
:::
:::::

::: paragraph
Im Vergleich mit dem [agentenbasierten
Check-Plugin](devel_check_plugins.html#scaffold) fallen die
SNMP-spezifischen neuen Funktionen und Klassen auf: `SNMPTree`,
`SimpleSNMPSection` und `startswith`. Selbsterklärend ist `SNMPTree`, es
handelt sich um eine Klasse zur Darstellung von SNMP-Bäumen. Die Klasse
`SimpleSNMPSection` dient zum Erstellen einer SNMP-Sektion. Die Funktion
`startswith()` vergleicht den Inhalt eines SNMP-Blattes mit einer
Zeichenkette. Mehr dazu später.
:::
:::::::::::::::::::

::::::::::::::::::::::::::::: sect2
### []{#snmp_section .hidden-anchor .sr-only}3.2. Die SNMP-Sektion erstellen {#heading_snmp_section}

::: paragraph
Nachdem Sie die [richtigen OIDs](#locating_oids) herausgefunden haben,
geht es an die eigentliche Entwicklung des Check-Plugins. Beim Erstellen
der SNMP-Sektion legen Sie zwei Dinge fest:
:::

::: {.olist .arabic}
1.  Sie identifizieren die Geräte, für welche das Check-Plugin
    ausgeführt werden soll.\
    Im folgenden Beispiel geschieht dies mit der Funktion
    `startswith()`, welche eine Zeichenkette mit dem Anfang des Inhalts
    eines OID-Blattes vergleicht. Weitere Zuordnungsmöglichkeiten zeigen
    wir weiter unten.

2.  Sie deklarieren, welche OID-Äste oder Blätter für das Monitoring
    geholt werden.\
    Dies geschieht mit dem Konstruktor der Klasse `SNMPTree`.
:::

::: paragraph
Erweitern Sie die vorbereitete Beispieldatei so, dass das Plugin nur für
eine kleine Zahl von Geräten ausgeführt wird: den Modellen des
`Flintstones, Inc. Fred Router`. Für diese Geräte werden dann die OIDs
für *Kontakt*, *Gerätename* und *Standort* abgerufen. Diese drei OIDs
stellt jedes Gerät bereit. Wenn Sie das Beispiel mit echten SNMP-fähigen
Geräten testen wollen, genügt es daher, den zu erkennenden Modellnamen
anzupassen.
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
snmp_section_flintstone_setup_check = SimpleSNMPSection(
    name = "flintstone_base_config",
    parse_function = parse_flintstone,
    detect = startswith(
        ".1.3.6.1.2.1.1.1.0",
        "Flintstones, Inc. Fred Router",
    ),
    fetch = SNMPTree(
        base = '.1.3.6.1.2.1.1',
        oids = ['4.0', '5.0', '6.0'],
    ),
)
```
:::
:::::

::: paragraph
Das Beispiel enthält noch den Parameter `name` mit dem die erzeugte
SNMP-Sektion identifiziert wird und eine Parse-Funktion, auf die wir
[später](#parse_function) noch zu sprechen kommen.
:::

::::::::::::::::::::: sect3
#### []{#detect .hidden-anchor .sr-only}Die SNMP-Detection {#heading_detect}

::: paragraph
Mit dem Parameter `detect` geben Sie an, unter welchen Bedingungen die
Discovery-Funktion überhaupt ausgeführt werden soll. In unserem Beispiel
ist das der Fall, wenn der Wert der OID `1.3.6.1.2.1.1.1.0` (also die
`sysDescr`) mit dem Text `Flintstones, Inc. Fred Router` beginnt (wobei
Groß-/Kleinschreibung grundsätzlich nicht unterschieden werden). Neben
`startswith` gibt es noch eine ganze Reihe weiterer möglicher Funktionen
zur Identifikation. Dabei existiert von jeder auch eine negierte Form,
welche mit `not_` beginnt. Beachten Sie, dass jede Funktion separat im
`import`-Statement verfügbar gemacht werden muss.
:::

+-----------------+-----------------------------------+-----------------+
| Attribut        | Bedeutung                         | Negation        |
+=================+===================================+=================+
| `equals(        | Der Wert der OID ist gleich dem   | `not_equals(    |
| oid, "needle")` | Text `needle`.                    | oid, "needle")` |
+-----------------+-----------------------------------+-----------------+
| `contains(      | Der Wert der OID enthält an       | `not_contains(  |
| oid, "needle")` | irgendeiner Stelle den Text       | oid, "needle")` |
|                 | `needle`.                         |                 |
+-----------------+-----------------------------------+-----------------+
| `startswith(    | Der Wert der OID beginnt mit dem  | `               |
| oid, "needle")` | Text `needle`.                    | not_startswith( |
|                 |                                   | oid, "needle")` |
+-----------------+-----------------------------------+-----------------+
| `endswith(      | Der Wert der OID endet auf den    | `not_endswith(  |
| oid, "needle")` | Text `needle`.                    | oid, "needle")` |
+-----------------+-----------------------------------+-----------------+
| `match          | Der Wert der OID entspricht dem   | `not_match      |
| es(oid, regex)` | [regulären                        | es(oid, regex)` |
|                 | Ausdruck](regexes.html) `regex`,  |                 |
|                 | und zwar hinten und vorne         |                 |
|                 | geankert, also mit einer exakten  |                 |
|                 | Übereinstimmung. Wenn Sie nur     |                 |
|                 | einen Teilstring benötigen,       |                 |
|                 | ergänzen Sie einfach vorne bzw.   |                 |
|                 | hinten noch ein `.*`.             |                 |
+-----------------+-----------------------------------+-----------------+
| `exists(oid)`   | Die OID ist auf dem Gerät         | `n              |
|                 | verfügbar. Ihr Wert darf leer     | ot_exists(oid)` |
|                 | sein.                             |                 |
+-----------------+-----------------------------------+-----------------+

::: paragraph
Daneben gibt es noch die Möglichkeit, mehrere Attribute mit `all_of`
oder `any_of` zu verknüpfen.
:::

::: paragraph
`all_of` erfordert mehrere erfolgreiche Prüfungen für eine positive
Erkennung. Folgendes Beispiel ordnet Ihr Check-Plugin einem Gerät zu,
wenn in der `sysDescr` der Text mit `foo` (oder `FOO` oder `Foo`)
beginnt **und** die OID `1.3.6.1.2.1.1.2.0` den Text `.4.1.11863.`
enthält:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
detect = all_of(
    startswith(".1.3.6.1.2.1.1.1.0", "foo"),
    contains(".1.3.6.1.2.1.1.2.0", ".4.1.11863.")
)
```
:::
::::

::: paragraph
`any_of` hingegen ist damit zufrieden, wenn auch nur eines der Kriterien
erfüllt ist. Hier ist ein Beispiel, in dem verschiedene Werte für die
`sysDescr` erlaubt sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
detect = any_of(
    startswith(".1.3.6.1.2.1.1.1.0", "foo version 3 system"),
    startswith(".1.3.6.1.2.1.1.1.0", "foo version 4 system"),
    startswith(".1.3.6.1.2.1.1.1.0", "foo version 4.1 system"),
)
```
:::
::::

::: paragraph
Übrigens: Kennen Sie sich gut mit [regulären Ausdrücken](regexes.html)
aus? Dann würden Sie wahrscheinlich das Beispiel vereinfachen und doch
wieder mit einer Zeile auskommen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
detect = matches(".1.3.6.1.2.1.1.1.0", "FOO Version (3|4|4.1) .*")
```
:::
::::

::: paragraph
Und noch ein wichtiger Hinweis: Die OIDs, die Sie der SNMP-Detection
eines Check-Plugins übergeben, werden von **jedem** Gerät geholt,
welches per SNMP überwacht wird. Nur so kann Checkmk feststellen, auf
welche Geräte das Check-Plugin anzuwenden ist.
:::

::: paragraph
Seien Sie daher sehr sparsam bei der Verwendung von
herstellerspezifischen OIDs. Versuchen Sie, Ihre SNMP-Detection so zu
gestalten, dass bevorzugt die `sysDescr` (`1.3.6.1.2.1.1.1.0`) und die
`sysObjectID` (`1.3.6.1.2.1.1.2.0`) geprüft werden.
:::

::: paragraph
Falls Sie dennoch eine andere OID zur exakten Identifikation benötigen,
verwenden Sie `all_of()` und gehen Sie wie folgt vor:
:::

::: {.olist .arabic}
1.  Prüfen Sie zunächst auf `sysDescr` oder `sysObjectID`.

2.  In weiteren Argumenten können Sie dann den Kreis der Geräte weiter
    einschränken, für die Ihr Plugin ausgeführt werden soll.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
detect = all_of(
    startswith(".1.3.6.1.2.1.1.1.0", "Flintstone"),   # first check sysDescr
    contains(".1.3.6.1.4.1.424242.2.3.37.0", "foo"),  # fetch vendor specific OID
)
```
:::
::::

::: paragraph
Dies funktioniert dank *lazy evaluation*: Sobald eine der früheren
Prüfungen fehlschlägt, wird keine weitere mehr durchgeführt. Im obigen
Beispiel wird die OID `1.3.6.1.4.1.424242.2.3.37.0` nur bei solchen
Geräten geholt, die auch `Flintstone` in ihrer `sysDescr` haben.
:::
:::::::::::::::::::::
:::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::: sect2
### []{#parse_function .hidden-anchor .sr-only}3.3. Die Parse-Funktion schreiben {#heading_parse_function}

::: paragraph
Wie beim [agentenbasierten](devel_check_plugins.html#parse_function) hat
auch beim SNMP-basierten Check-Plugin die Parse-Funktion die Aufgabe,
die erhaltenen Agentendaten in eine gut und vor allem performant zu
verarbeitende Form zu bringen.
:::

::: paragraph
Die Daten erhalten Sie hier ebenfalls als Liste. Allerdings gilt es
einige Feinheiten zu beachten, denn es macht einen Unterschied, ob Sie
Blätter abfragen oder Äste. Zur Erinnerung: In unserem
[oben](#snmp_section) vorgestellten Beispiel werden Blätter angefordert:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
    fetch = SNMPTree(
        base = '.1.3.6.1.2.1.1',
        oids = ['4.0', '5.0', '6.0'],
    )
```
:::
:::::

::: paragraph
Wenn Sie die Parse-Funktion temporär mit der Funktion `print()`
erweitern, können Sie sich beim [Testen des Check-Plugins](#test) die
Daten anzeigen lassen, die Checkmk aus dieser Abfrage zur Verfügung
stellt:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
def parse_flintstone(string_table):
    print(string_table)
    return {}
```
:::
:::::

::: paragraph
Sie erhalten eine verschachtelte Liste, welche in der ersten Ebene nur
ein Element, nämlich eine Liste der abgerufenen Werte, enthält:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
[
    ['barney@example.com', 'big-router-01', 'Server room 23, Stonestreet 52, Munich']
]
```
:::
::::

::: paragraph
Ein wenig anders sieht das Ergebnis aus, wenn Sie Äste abrufen, die
mehrere Blätter enthalten. Angenommen, der Router kann mit einer
variablen Zahl von Netzwerkkarten bestückt werden, deren Name,
Verbindungsstatus und Geschwindigkeit unterhalb von
`1.3.6.1.4.1.424242.2.3.23` ausgelesen werden können ...
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    fetch = SNMPTree(
        base = '.1.3.6.1.4.1.424242.2.3.23',
        oids = [
            '6', # all names
            '7', # all states
            '8', # all speeds
        ],
    )
```
:::
::::

::: paragraph
... dann sähe die zweidimensionale Liste möglicherweise so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
[
    # Name, State, Speed
    ['net0', '1', '1000'],
    ['net1', '0', '100'],
    ['net2', '1', '10000'],
    ['net3', '1', '1000'],
]
```
:::
::::

::: paragraph
Alle unter einer OID erhältlichen Blätter werden in eine Tabellenspalte
geschrieben. Damit dürfte es offensichtlich sein, dass wegen der
Darstellung der Daten nur zusammenpassende OIDs abgefragt werden dürfen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Auch das zuletzt gezeigte         |
|                                   | Beispiel zum Abruf von OID-Ästen  |
|                                   | ist Bestandteil unseres auf       |
|                                   | GitHub bereitgestellten           |
|                                   | [SNMP-Walks](                     |
|                                   | https://github.com/Checkmk/checkm |
|                                   | k-docs/blob/master/examples/devel |
|                                   | _check_plugins_snmp/flintstones_f |
|                                   | red_router.txt){target="_blank"}, |
|                                   | den Sie zur                       |
|                                   | [Simulation](#simulation) nutzen  |
|                                   | können.                           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Doch nun zurück zum Beispiel, in dem die OID-Blätter zu Kontakt,
Gerätename und Standort abgefragt werden: Die folgende Parse-Funktion
übernimmt einfach jedes Element der inneren Liste in ein
Schlüssel-Wert-Paar des zurückgegebenen Dictionaries:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
def parse_flintstone(string_table):
    # print(string_table)
    result = {}
    result["contact"] = string_table[0][0]
    result["name"] = string_table[0][1]
    result["location"] = string_table[0][2]
    # print(result)
    return result
```
:::
:::::

::: paragraph
Das Resultat der Parse-Funktion sieht dann so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
{
    'contact': 'barney@example.com',
    'name': 'big-router-01',
    'location': 'Server room 23, Stonestreet 52, Munich'
}
```
:::
::::
::::::::::::::::::::::::::::::

:::::::: sect2
### []{#check_plug-in .hidden-anchor .sr-only}3.4. Das Check-Plugin erstellen {#heading_check_plug-in}

::: paragraph
Die Erstellung des Check-Plugins geschieht exakt wie bei den
[agentenbasierten Check-Plugins](devel_check_plugins.html#check_plug-in)
beschrieben.
:::

::: paragraph
Da Sie in den meisten Fällen mehrere SNMP-Äste abfragen werden und
daraus mehrere SNMP-Sektionen resultieren, ist der Parameter `sections`
mit der Liste der auszuwertenden Sektionen in der Regel erforderlich:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
check_plugin__flintstone_setup = CheckPlugin(
    name = "flintstone_setup_check",
    sections = [ "flintstone_base_config" ],
    service_name = "Flintstone setup check",
    discovery_function = discover_flintstone,
    check_function = check_flintstone,
)
```
:::
:::::
::::::::

::::::: sect2
### []{#discovery_function .hidden-anchor .sr-only}3.5. Die Discovery-Funktion schreiben {#heading_discovery_function}

::: paragraph
Auch die Discovery-Funktion entspricht dem Beispiel des
[agentenbasierten
Check-Plugins.](devel_check_plugins.html#discovery_function) Bei
Check-Plugins, die pro Host nur einen Service erzeugen, genügt ein
einziges `yield()`:
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
def discover_flintstone(section):
    yield Service()
```
:::
:::::
:::::::

::::::::: sect2
### []{#check_function .hidden-anchor .sr-only}3.6. Die Check-Funktion schreiben {#heading_check_function}

::: paragraph
Im Beispiel soll überprüft werden, ob die Informationen zu Kontakt,
Gerätename und Standort vorhanden sind. Es reicht daher aus, in der
Check-Funktion zu prüfen, welche Felder leer sind und entsprechend den
Zustand auf [CRIT]{.state2} zu setzen (wenn etwas fehlt) oder auf
[OK]{.state0} (wenn alles da ist):
:::

::::: listingblock
::: title
\~/local/lib/python3/cmk_addons/plugins/flintstone/agent_based/flintstone_setup_check.py
:::

::: content
``` {.pygments .highlight}
def check_flintstone(section):
    missing = 0
    for e in ["contact", "name", "location"]:
        if section[e] == "":
            missing += 1
            yield Result(state=State.CRIT, summary=f"Missing information: {e}!")
    if missing > 0:
        yield Result(state=State.CRIT, summary=f"Missing fields: {missing}!")
    else:
        yield Result(state=State.OK, summary="All required information is available.")
```
:::
:::::

::: paragraph
Mit der Erstellung der Check-Funktion ist das Check-Plugin fertig.
:::

::: paragraph
Das komplette Check-Plugin haben wir auf
[GitHub](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins_snmp/flintstone_setup_check.py){target="_blank"}
bereitgestellt.
:::
:::::::::

::::::::::::::::: sect2
### []{#test .hidden-anchor .sr-only}3.7. Das Check-Plugin testen und aktivieren {#heading_test}

::: paragraph
Test und Aktivierung erfolgen wie beim [agentenbasierten
Check-Plugin.](devel_check_plugins.html#test)
:::

::: paragraph
Als erstes ist die Service-Erkennung des Plugins an der Reihe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -vI --detect-plugins=flintstone_setup_check mydevice01
Discovering services and host labels on: mydevice01
mydevice01:
+ FETCHING DATA
No piggyback files for 'mydevice01'. Skip processing.
No piggyback files for '127.0.0.1'. Skip processing.
Get piggybacked data
+ ANALYSE DISCOVERED HOST LABELS
SUCCESS - Found no new host labels
+ ANALYSE DISCOVERED SERVICES
+ EXECUTING DISCOVERY PLUGINS (1)
  1 flintstone_setup_check
SUCCESS - Found 1 services
```
:::
::::

::: paragraph
Wie erwartet hat die Service-Erkennung funktioniert. Jetzt können Sie
den im Check-Plugin enthaltenen Check ausprobieren:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -v --detect-plugins=flintstone_setup_check mydevice01
+ FETCHING DATA
No piggyback files for 'mydevice01'. Skip processing.
No piggyback files for '127.0.0.1'. Skip processing.
Get piggybacked data
Flintstone setup check All required information is available.
No piggyback files for 'mydevice01'. Skip processing.
No piggyback files for '127.0.0.1'. Skip processing.
[snmp] Success, [piggyback] Success ...
```
:::
::::

::: paragraph
Nach dem Neustart des Monitoring-Kerns ...
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -R
Generating configuration for core (type nagios)...
Precompiling host checks...OK
Validating Nagios configuration...OK
Restarting monitoring core...OK
```
:::
::::

::: paragraph
... ist dann der neue Service im Monitoring sichtbar:
:::

::::: imageblock
::: content
![Der vom Check-Plugin erzeugte neue Service im
Monitoring.](../images/devel_snmp_service.png)
:::

::: title
Da alle Felder der drei SNMP-Blätter befüllt sind, ist der Service
[OK]{.state0}
:::
:::::
:::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::: sect1
## []{#errors .hidden-anchor .sr-only}4. Fehler beheben {#heading_errors}

::::::::::: sectionbody
::: paragraph
Da die Fehlerbehebung bei [agentenbasierten
Check-Plugins](devel_check_plugins.html#errors) im Wesentlichen auch für
SNMP-basierte Check-Plugin gilt, gehen wir hier nur auf SNMP-Spezifika
ein.
:::

::::::: sect2
### []{#simulation .hidden-anchor .sr-only}4.1. Simulationsmöglichkeiten {#heading_simulation}

:::: sect3
#### []{#savedwalk .hidden-anchor .sr-only}Gespeicherte SNMP-Walks in Checkmk nutzen {#heading_savedwalk}

::: paragraph
Im Artikel zur Überwachung via SNMP [zeigen wir
detailliert,](snmp.html#simulation) wie Sie SNMP-Walks aus der GUI
erstellen und wie Sie diese zur Simulation einsetzen können. So ist es
auch möglich, Check-Plugins auf Testsystemen zu entwickeln, welche die
SNMP-Hosts, für die Sie ein Plugin entwickeln, nicht erreichen können.
In unserem GitHub-Repository finden Sie ein Beispiel eines
[SNMP-Walks,](https://github.com/Checkmk/checkmk-docs/blob/master/examples/devel_check_plugins_snmp/flintstones_fred_router.txt){target="_blank"}
den wir in diesem Artikel verwenden, und den Sie zur Entwicklung und zum
Testen des Check-Plugins nutzen können.
:::
::::

:::: sect3
#### []{#dummydaemon .hidden-anchor .sr-only}Dummy SNMP-Daemon {#heading_dummydaemon}

::: paragraph
Soll sichergestellt werden, dass bestimmte OIDs sich abhängig
voneinander ändern, kann es sinnvoll sein, einen Dummy SNMP-Daemon zu
programmieren, der in sich konsistente Daten ausliefert. Ein Hilfsmittel
bei der Programmierung eines solchen kann das [Python-Modul
`snmp-agent`](https://pypi.org/project/snmp-agent/){target="_blank"}
sein.
:::
::::
:::::::

:::: sect2
### []{#hwbugs .hidden-anchor .sr-only}4.2. Unkooperative Hardware {#heading_hwbugs}

::: paragraph
Bevor ein Gerät mit einem neuen SNMP-basierten Check-Plugin überwacht
werden kann, muss es zuerst einmal grundsätzlich über SNMP überwacht
werden können. Die Übersicht bekannter Probleme mit Lösungsvorschlägen
finden Sie daher im Artikel zur [Überwachung via
SNMP.](snmp.html#cursedhardware)
:::
::::
:::::::::::
::::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}5. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/local                          | Basisverzeichnis zur Ablage von   |
| /lib/python3/cmk_addons/plugins/` | Plugin-Dateien.                   |
+-----------------------------------+-----------------------------------+
| `~/l                              | Ablageort für nach der Check-API  |
| ocal/lib/python3/cmk_addons/plugi | V2 selbst geschriebene            |
| ns/<plug-in_family>/agent_based/` | Check-Plugins.                    |
+-----------------------------------+-----------------------------------+
| `~/local/share/snmp/mibs/`        | Legen Sie hier SNMP-MIB-Dateien   |
|                                   | ab, die automatisch geladen       |
|                                   | werden sollen.                    |
+-----------------------------------+-----------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
