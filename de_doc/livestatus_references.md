:::: {#header}
# Livestatus Befehlsreferenz

::: details
[Last modified on 11-Dec-2020]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/livestatus_references.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::: {#content}
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
[Statusdaten abrufen via Livestatus](livestatus.html) [Checkmk auf der
Kommandozeile](cmk_commandline.html) [Die Checkmk
REST-API](rest_api.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#tables .hidden-anchor .sr-only}1. Verfügbare Tabellen {#heading_tables}

:::::::: sectionbody
::: paragraph
Im Livestatus stehen Ihnen die folgenden Tabellen zur Verfügung. Manche
verfügen zusätzlich noch über die Spalten einer anderen Tabelle. Diese
Spalten werden dann mit dem Tabellennamen als Präfix gekennzeichnet:
:::

+-----------------+-----------------------------------------------------+
| Tabelle         | Kommentar                                           |
+=================+=====================================================+
| `hosts`         | Enthält alle Informationen zu den konfigurierten    |
|                 | Hosts.                                              |
+-----------------+-----------------------------------------------------+
| `services`      | Enthält alle Informationen zu den konfigurierten    |
|                 | Services und zusätzlich die Spalten aus `hosts`.    |
+-----------------+-----------------------------------------------------+
| `hostgroups`    | Informationen zu den Host-Gruppen.                  |
+-----------------+-----------------------------------------------------+
| `servicegroups` | Informationen zu den Service-Gruppen.               |
+-----------------+-----------------------------------------------------+
| `contactgroups` | Informationen zu den Kontaktgruppen.                |
+-----------------+-----------------------------------------------------+
| `s              | Wie `services`, aber zusätzlich mit den Spalten aus |
| ervicesbygroup` | `servicegroups`.                                    |
+-----------------+-----------------------------------------------------+
| `servi          | Wie `services`, aber zusätzlich mit den Spalten aus |
| cesbyhostgroup` | `hostgroups`.                                       |
+-----------------+-----------------------------------------------------+
| `hostsbygroup`  | Wie `hosts`, aber zusätzlich mit den Spalten aus    |
|                 | `hostgroups`.                                       |
+-----------------+-----------------------------------------------------+
| `contacts`      | Informationen zu den Kontakten.                     |
+-----------------+-----------------------------------------------------+
| `commands`      | Alle konfigurierten Check-Commands, wie sie bei     |
|                 | einem Service unter [Service check                  |
|                 | command]{.guihint} stehen.                          |
+-----------------+-----------------------------------------------------+
| `timeperiods`   | Alle Informationen zu konfigurierten Zeitperioden.  |
+-----------------+-----------------------------------------------------+
| `downtimes`     | Wie `timeperiods`, nur für Wartungszeiten.          |
+-----------------+-----------------------------------------------------+
| `comments`      | Enthält alle Informationen zu Kommentaren und       |
|                 | zusätzlich die Spalten von `hosts` und `services`.  |
+-----------------+-----------------------------------------------------+
| `log`           | Alle Informationen zu mitgeschriebenen Ereignissen. |
|                 | Diese sollten nach Klasse und Zeitpunkt/Zeitraum    |
|                 | gefiltert werden.                                   |
+-----------------+-----------------------------------------------------+
| `status`        | Informationen zu dem Status und der Performance des |
|                 | Cores.                                              |
+-----------------+-----------------------------------------------------+
| `columns`       | Alle verfügbaren Tabellen werden hier aufgelistet.  |
|                 | Zusätzlich gibt es auch eine Beschreibung zu jeder  |
|                 | Spalte einer Tabelle.                               |
+-----------------+-----------------------------------------------------+
| `statehist`     | Mit dieser Tabelle kann die Status-Vergangenheit    |
|                 | eines Hosts/Services umfangreich durchsucht werden. |
+-----------------+-----------------------------------------------------+
| `even           | Listet alle Events der [Event                       |
| tconsoleevents` | Console](glossar.html#ec). Zusätzlich verfügt diese |
|                 | Tabelle über alle Spalten von `hosts`.              |
+-----------------+-----------------------------------------------------+
| `event          | Wie `eventconsoleevents` nur zusätzlich noch mit    |
| consolehistory` | Spalten zur Historie eines Events.                  |
+-----------------+-----------------------------------------------------+
| `even           | Listet Statistiken zu der Performance der Event     |
| tconsolestatus` | Console.                                            |
+-----------------+-----------------------------------------------------+
| `eve            | Statistiken darüber, wie oft ein Regelabgleich mit  |
| ntconsolerules` | einem ankommenden Event erfolgreich war.            |
+-----------------+-----------------------------------------------------+

::: paragraph
Wenn Sie wissen möchten, über welche Spalten (Columns) eine Tabelle
verfügt, können Sie diese einfach mit dem folgenden Befehl abrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ lq "GET columns\nColumns: name\nFilter: table = columns"
description
name
table
type
```
:::
::::

::: paragraph
Über den Filter lassen sich auch andere Tabellen auswählen. Alle
verfügbaren Spalten für die Suche nach Spalten und Tabellen sehen Sie in
der Ausgabe des Beispiels.
:::
::::::::
:::::::::

:::::: sect1
## []{#hdr .hidden-anchor .sr-only}2. Verfügbare Header {#heading_hdr}

::::: sectionbody
+-------------+---------+---------------------------------------------+
| Header      | A       | Beschreibung                                |
|             | rgument |                                             |
+=============+=========+=============================================+
| `Columns`   | Spal    | Schränkt die Ausgabe auf die angegebenen    |
|             | tenname | Spalten ein.                                |
+-------------+---------+---------------------------------------------+
| `Filter`    | Spalt   | Schränkt die Ausgabe auf das definierte     |
|             | enname, | Objekt ein. Siehe auch                      |
|             | O       | [Livestatus-Filter.](#filter)               |
|             | perator |                                             |
|             | und     |                                             |
|             | Obj     |                                             |
|             | ektname |                                             |
+-------------+---------+---------------------------------------------+
| `OrderBy`   | Spal    | Sortiert die Ausgabe nach dem Inhalt der    |
|             | tenname | angegebenen Spalte bzw. dem Wert. Die       |
|             | oder    | Standardsortierreihenfolge ist aufsteigend, |
|             | Dictio  | alternativ können Sie zusätzlich `asc` oder |
|             | nary-Sc | `desc` angeben.                             |
|             | hlüssel |                                             |
+-------------+---------+---------------------------------------------+
| `Or`        | G       | Verbindet die letzten n Filter mit einem    |
|             | anzzahl | logischen ODER.                             |
+-------------+---------+---------------------------------------------+
| `And`       | G       | Verbindet die letzten n Filter mit einem    |
|             | anzzahl | logischen UND.                              |
+-------------+---------+---------------------------------------------+
| `Negate`    | G       | Kehrt die letzten n Filter um.              |
|             | anzzahl |                                             |
+-------------+---------+---------------------------------------------+
| `           | ASCI    | Definiert die Zeichen, welche die Trennung  |
| Separators` | I-Werte | eines Elements von einem anderen anzeigt.   |
+-------------+---------+---------------------------------------------+
| `Ou         | Name    | Definiert eine komplett andere Ausgabe der  |
| tputFormat` |         | Daten. Möglich sind `json`, `python`,       |
|             |         | `python3`, `CSV` und `csv`                  |
|             |         | (Standardausgabe).                          |
+-------------+---------+---------------------------------------------+
| `Stats`     | O       | Bildet Statistiken zu bestimmten Spalten.   |
|             | perator |                                             |
|             | und     |                                             |
|             | Spal    |                                             |
|             | tenname |                                             |
+-------------+---------+---------------------------------------------+
| `StatsOr`   | G       | Bietet die Funktionen des `OR`-Headers in   |
|             | anzzahl | den Statistiken.                            |
+-------------+---------+---------------------------------------------+
| `StatsAnd`  | G       | Bietet die Funktionen des `AND`-Headers in  |
|             | anzzahl | den Statistiken.                            |
+-------------+---------+---------------------------------------------+
| `S          | G       | Bietet die Funktionen des `NEGATE`-Headers  |
| tatsNegate` | anzzahl | in den Statistiken.                         |
+-------------+---------+---------------------------------------------+
| `Limit`     | G       | Beschränkt die Ausgabe auf n Zeilen.        |
|             | anzzahl |                                             |
+-------------+---------+---------------------------------------------+
| `Timelimit` | G       | Schränkt die Verarbeitung der Abfrage auf n |
|             | anzzahl | Sekunden ein.                               |
+-------------+---------+---------------------------------------------+
| `Col        | \-      | Gibt in der ersten Zeile die Namen der      |
| umnHeaders` |         | verwendeten Spalten aus. Ist zusätzlich der |
|             |         | Header `ResponseHeader` gesetzt, werden die |
|             |         | Namen der Spalten in der zweiten Zeile      |
|             |         | ausgegeben.                                 |
+-------------+---------+---------------------------------------------+
| `AuthUser`  | Benut   | Schränkt die Ausgabe auf die Zeilen ein,    |
|             | zername | die der angegebene Benutzer sehen darf.     |
+-------------+---------+---------------------------------------------+
| `           | Obj     | Das Objekt, bei dem ein bestimmtes          |
| WaitObject` | ektname | Verhalten erwartet wird. Das ist der Name   |
|             |         | des Objekts bzw. bei der Tabelle `services` |
|             |         | der Name des Hosts gefolgt von einem        |
|             |         | Leerzeichen und der Service-Beschreibung.   |
|             |         | Wenn der Host-Name selbst Leerzeichen       |
|             |         | enthält, können die zwei Elemente auch mit  |
|             |         | einem Semikolon getrennt werden. Dieser     |
|             |         | Header wird nur von den Tabellen `hosts`,   |
|             |         | `services` `hostgroups` `servicegroups`     |
|             |         | `contacts` und `contactgroups` unterstützt. |
+-------------+---------+---------------------------------------------+
| `Wai        | F       | Die Bedingung, die für das definierte       |
| tCondition` | ilterbe | Objekt erfüllt sein muss. Es können         |
|             | dingung | beliebig viele Bedingungen definiert        |
|             |         | werden; diese werden mit einem logischen    |
|             |         | UND miteinander verknüpft.                  |
+-------------+---------+---------------------------------------------+
| `WaitC      | G       | Bietet die Funktionen des `OR`-Headers in   |
| onditionOr` | anzzahl | den Wait-Bedingungen.                       |
+-------------+---------+---------------------------------------------+
| `WaitCo     | G       | Bietet die Funktionen des `AND`-Headers in  |
| nditionAnd` | anzzahl | den Wait-Bedingungen.                       |
+-------------+---------+---------------------------------------------+
| `WaitCondi  | G       | Bietet die Funktionen des `NEGATE`-Headers  |
| tionNegate` | anzzahl | in den Wait-Bedingungen.                    |
+-------------+---------+---------------------------------------------+
| `W          | Schlüs  | Schlüsselwörter wirken wie eine normale     |
| aitTrigger` | selwort | Bedingung, wenn sie allein eingesetzt       |
|             | \*      | werden. In Kombination mit der              |
|             |         | `WaitCondition` erleichtert es das          |
|             |         | Auffinden von relevanten Log-Einträgen und  |
|             |         | reduziert den Overhead im Livestatus.       |
+-------------+---------+---------------------------------------------+
| `W          | G       | Setzt eine Zeitbeschränkung in              |
| aitTimeout` | anzzahl | Millisekunden. Danach, z.B. nach 5000       |
|             |         | Millisekunden (5 Sekunden), wird die        |
|             |         | Abfrage ausgeführt, auch wenn die Bedingung |
|             |         | nicht erfüllt ist.                          |
+-------------+---------+---------------------------------------------+
| `Localtime` | Un      | Versucht durch Angabe einer Referenzzeit    |
|             | ix-Zeit | voneinander abweichende Zeitstempel in      |
|             |         | verteilten Umgebungen auszugleichen.        |
+-------------+---------+---------------------------------------------+
| `Resp       | fixe    | Gibt eine Statuszeile in der ersten Zeile   |
| onseHeader` | d16/off | der Antwort zurück. Die Ausgabe bleibt      |
|             |         | selbst dann in der ersten Zeile, wenn       |
|             |         | zusätzlich der Header `ColumnHeaders`       |
|             |         | gesetzt wurde.                              |
+-------------+---------+---------------------------------------------+
| `KeepAlive` | on      | Verhindert, dass der Livestatus-Kanal nach  |
|             |         | einer Abfrage geschlossen wird.             |
+-------------+---------+---------------------------------------------+

::: paragraph
\* Für den `WaitTrigger` gibt es folgende Schlüsselwörter:
:::

::: ulist
- check

- state

- log

- downtime

- comment

- command

- program

- all
:::
:::::
::::::

:::::::::: sect1
## []{#filter .hidden-anchor .sr-only}3. Operatoren für Filter {#heading_filter}

::::::::: sectionbody
::::: sect2
### []{#operators .hidden-anchor .sr-only}3.1. Allgemeine Operatoren {#heading_operators}

+-------------+------------------------+-------------------------------+
| Operator \* | Bei Zahlen             | Bei Zeichenketten             |
+=============+========================+===============================+
| `=`         | Gleichheit             | Gleichheit                    |
+-------------+------------------------+-------------------------------+
| `~`         | Obermenge \*\*         | Enthält eine Zeichenfolge als |
|             |                        | regulären Ausdruck.           |
+-------------+------------------------+-------------------------------+
| `=~`        | Untermenge \*\*        | Schreibungsunabhängige        |
|             |                        | Gleichheit                    |
+-------------+------------------------+-------------------------------+
| `~~`        | Enthält mindestens     | Enthält eine                  |
|             | einen der Werte \*\*   | schreibungsunabhängige        |
|             |                        | Zeichenfolge als regulären    |
|             |                        | Ausdruck.                     |
+-------------+------------------------+-------------------------------+
| `<`         | Kleiner als            | Lexikografisch kleiner als    |
+-------------+------------------------+-------------------------------+
| `>`         | Größer als             | Lexikografisch größer als     |
+-------------+------------------------+-------------------------------+
| `<=`        | Kleiner oder gleich    | Lexikografisch kleiner oder   |
|             |                        | gleich                        |
+-------------+------------------------+-------------------------------+
| `>=`        | Größer oder gleich     | Lexikografisch größer oder    |
|             |                        | gleich                        |
+-------------+------------------------+-------------------------------+

::: paragraph
\* Alle Operatoren können mit einem Ausrufezeichen (`!`) negiert werden.
:::

::: paragraph
\*\* Diese Operatoren sind nützlich, wenn mit Listen gearbeitet wird.
Livestatus interpretiert die angegebenen Werte dann als eine Menge.
:::
:::::

::::: sect2
### []{#list_operators .hidden-anchor .sr-only}3.2. Operatoren für Listen {#heading_list_operators}

::: paragraph
Mit den folgenden Operatoren können Sie prüfen, ob ein Element in einer
Liste enthalten ist:
:::

+-------------+--------------------------------------------------------+
| Operator    | Art der Prüfung                                        |
+=============+========================================================+
| `=`         | Prüft auf eine leere Liste \*                          |
+-------------+--------------------------------------------------------+
| `>=`        | Gleichheit                                             |
+-------------+--------------------------------------------------------+
| `<`         | Ungleichheit                                           |
+-------------+--------------------------------------------------------+
| `<=`        | Schreibungsunabhängige Gleichheit                      |
+-------------+--------------------------------------------------------+
| `>`         | Schreibungsunabhängige Ungleichheit                    |
+-------------+--------------------------------------------------------+
| `~`         | Die Zeichenkette eines regulären Ausdrucks \*          |
+-------------+--------------------------------------------------------+
| `~~`        | Die schreibungsunabhängige Zeichenkette eines          |
|             | regulären Ausdrucks \*                                 |
+-------------+--------------------------------------------------------+

::: paragraph
\* Dieser Operator kann mit einem Ausrufezeichen (`!`) negiert werden.
:::
:::::
:::::::::
::::::::::

:::: sect1
## []{#stats .hidden-anchor .sr-only}4. Operatoren für Statistiken {#heading_stats}

::: sectionbody
+-------------+--------------------------------------------------------+
| Operator    | Beschreibung                                           |
+=============+========================================================+
| `sum`       | Bildet eine Summe aus den Werten.                      |
+-------------+--------------------------------------------------------+
| `min`       | Sucht den kleinsten Wert heraus.                       |
+-------------+--------------------------------------------------------+
| `max`       | Sucht den größten Wert heraus.                         |
+-------------+--------------------------------------------------------+
| `avg`       | Erstellt einen Durchschnittswert (Mittelwert).         |
+-------------+--------------------------------------------------------+
| `std`       | Gibt die Standardabweichung aus.                       |
+-------------+--------------------------------------------------------+
| `suminv`    | Invertiert die Summe aus den Werten gemäß 1/`sum`.     |
+-------------+--------------------------------------------------------+
| `avginv`    | Invertiert den Mittelwert aus den Werten gemäß         |
|             | 1/`avg`.                                               |
+-------------+--------------------------------------------------------+
:::
::::

:::: sect1
## []{#response .hidden-anchor .sr-only}5. Status-Codes des ResponseHeader {#heading_response}

::: sectionbody
+-------------+--------------------------------------------------------+
| Status-Code | Beschreibung                                           |
+=============+========================================================+
| `200`       | Der Aufruf war erfolgreich und die Antwort enthält die |
|             | abgefragten Daten.                                     |
+-------------+--------------------------------------------------------+
| `400`       | Der Aufruf enthält einen fehlerhaften Header.          |
+-------------+--------------------------------------------------------+
| `404`       | Die Tabelle konnte nicht gefunden werden.              |
+-------------+--------------------------------------------------------+
| `413`       | Das Zeitlimit der Abfrage wurde überschritten.         |
+-------------+--------------------------------------------------------+
| `451`       | Die Abfrage wurde nicht vollständig übergeben.         |
+-------------+--------------------------------------------------------+
| `452`       | Die Abfrage ist komplett ungültig.                     |
+-------------+--------------------------------------------------------+
:::
::::

:::::: sect1
## []{#commands .hidden-anchor .sr-only}6. Kommandos {#heading_commands}

::::: sectionbody
::: paragraph
Kommandos, welche Ihnen in allen Editionen von Checkmk zur Verfügung
stehen:
:::

+------------------------+---------------------------------------------+
| Kommando               | Beschreibung                                |
+========================+=============================================+
| **Host-Kommandos**     |                                             |
+------------------------+---------------------------------------------+
| `ACK                   | [Probleme eines Hosts                       |
| NOWLEDGE_HOST_PROBLEM` | bestätigen](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=39){target="_blank"} |
+------------------------+---------------------------------------------+
| `REMOVE                | [Bestätigung der Probleme eines Hosts       |
| _HOST_ACKNOWLEDGEMENT` | löschen](https://assets.nagios.c            |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=116){target="_blank"} |
+------------------------+---------------------------------------------+
| `ADD_HOST_COMMENT`     | [Einem Host einen Kommentar                 |
|                        | hinzufügen](https://assets.nagios           |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=1){target="_blank"} |
+------------------------+---------------------------------------------+
| `DEL_HOST_COMMENT`     | [Einen Kommentar bei einem Host             |
|                        | löschen](https://assets.nagios              |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=3){target="_blank"} |
+------------------------+---------------------------------------------+
| `S                     | [Eine Wartungszeit für einen Host           |
| CHEDULE_HOST_DOWNTIME` | festlegen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=118){target="_blank"} |
+------------------------+---------------------------------------------+
| `DEL_HOST_DOWNTIME`    | [Eine Wartungszeit für einen Host           |
|                        | löschen](https://assets.nagios.c            |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=125){target="_blank"} |
+------------------------+---------------------------------------------+
| `START_                | [Die Ausführung von Host-Checks global      |
| EXECUTING_HOST_CHECKS` | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=67){target="_blank"} |
+------------------------+---------------------------------------------+
| `STOP_                 | [Die Ausführung von Host-Checks global      |
| EXECUTING_HOST_CHECKS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=68){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENABLE_HOST_CHECK`    | [Aktive Checks für einen Host               |
|                        | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=53){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISABLE_HOST_CHECK`   | [Aktive Checks für einen Host               |
|                        | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=54){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENABL                 | [Passive Host-Checks für einen Host         |
| E_PASSIVE_HOST_CHECKS` | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=71){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISABL                | [Passive Host-Checks für einen Host         |
| E_PASSIVE_HOST_CHECKS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=72){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENAB                  | [Benachrichtigungen für einen Host          |
| LE_HOST_NOTIFICATIONS` | erlauben](https://assets.nagios             |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=8){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISAB                 | [Benachrichtigungen für einen Host          |
| LE_HOST_NOTIFICATIONS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=16){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENABLE_H              | [Benachrichtigungen für alle Services eines |
| OST_SVC_NOTIFICATIONS` | Hosts                                       |
|                        | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=35){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISABLE_H             | [Benachrichtigungen für alle Services eines |
| OST_SVC_NOTIFICATIONS` | Hosts                                       |
|                        | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=36){target="_blank"} |
+------------------------+---------------------------------------------+
| `SCHED                 | [Die Aktualisierung eines Host-Checks zu    |
| ULE_FORCED_HOST_CHECK` | einem bestimmten Zeitpunkt                  |
|                        | erzwingen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=128){target="_blank"} |
+------------------------+---------------------------------------------+
| `PROC                  | [Das Ergebnis eines Host-Checks manuell     |
| ESS_HOST_CHECK_RESULT` | setzen](https://assets.nagios.c             |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=115){target="_blank"} |
+------------------------+---------------------------------------------+
| `SEND_CUS              | [Eine benutzerdefinierte Benachrichtigung   |
| TOM_HOST_NOTIFICATION` | für einen Host                              |
|                        | erstellen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=134){target="_blank"} |
+------------------------+---------------------------------------------+
| `CHANGE_HOST_MODATTR`  | [Die modifizierten Attribute eines Hosts    |
|                        | ändern](https://assets.nagios.c             |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=154){target="_blank"} |
+------------------------+---------------------------------------------+
| **Service-Kommandos**  |                                             |
+------------------------+---------------------------------------------+
| `AC                    | [Probleme eines Service                     |
| KNOWLEDGE_SVC_PROBLEM` | bestätigen](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=40){target="_blank"} |
+------------------------+---------------------------------------------+
| `REMOV                 | [Bestätigung der Probleme eines Service     |
| E_SVC_ACKNOWLEDGEMENT` | löschen](https://assets.nagios.c            |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=117){target="_blank"} |
+------------------------+---------------------------------------------+
| `ADD_SVC_COMMENT`      | [Einem Service einen Kommentar              |
|                        | hinzufügen](https://assets.nagios           |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=2){target="_blank"} |
+------------------------+---------------------------------------------+
| `DEL_SVC_COMMENT`      | [Einen Kommentar bei einem Service          |
|                        | löschen](https://assets.nagios              |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=4){target="_blank"} |
+------------------------+---------------------------------------------+
| `                      | [Eine Wartungszeit für einen Service        |
| SCHEDULE_SVC_DOWNTIME` | festlegen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=119){target="_blank"} |
+------------------------+---------------------------------------------+
| `DEL_SVC_DOWNTIME`     | [Eine Wartungszeit für einen Service        |
|                        | löschen](https://assets.nagios.c            |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=126){target="_blank"} |
+------------------------+---------------------------------------------+
| `START                 | [Die Ausführung von aktiven Services global |
| _EXECUTING_SVC_CHECKS` | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=41){target="_blank"} |
+------------------------+---------------------------------------------+
| `STOP                  | [Die Ausführung von aktiven Services global |
| _EXECUTING_SVC_CHECKS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=42){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENABLE_SVC_CHECK`     | [Die Ausführung eines aktiven Services      |
|                        | erlauben](https://assets.nagios             |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=5){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISABLE_SVC_CHECK`    | [Die Ausführung eines aktiven Services      |
|                        | verhindern](https://assets.nagios           |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=6){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENAB                  | [Die Ausführung eines passiven Services     |
| LE_PASSIVE_SVC_CHECKS` | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=45){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISAB                 | [Die Ausführung eines passiven Services     |
| LE_PASSIVE_SVC_CHECKS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=46){target="_blank"} |
+------------------------+---------------------------------------------+
| `ENA                   | [Benachrichtigungen für einen Service       |
| BLE_SVC_NOTIFICATIONS` | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=11){target="_blank"} |
+------------------------+---------------------------------------------+
| `DISA                  | [Benachrichtigungen für einen Service       |
| BLE_SVC_NOTIFICATIONS` | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=12){target="_blank"} |
+------------------------+---------------------------------------------+
| `SCHE                  | [Die Aktualisierung eines Services zu einem |
| DULE_FORCED_SVC_CHECK` | bestimmten Zeitpunkt                        |
|                        | erzwingen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=129){target="_blank"} |
+------------------------+---------------------------------------------+
| `PROCESS               | [Das Ergebnis eines passiven Services       |
| _SERVICE_CHECK_RESULT` | manuell                                     |
|                        | setzen](https://assets.nagios.c             |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=114){target="_blank"} |
+------------------------+---------------------------------------------+
| `SEND_CU               | [Eine benutzerdefinierte Benachrichtigung   |
| STOM_SVC_NOTIFICATION` | für einen Service                           |
|                        | erstellen](https://assets.nagios.c          |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=135){target="_blank"} |
+------------------------+---------------------------------------------+
| `CHANGE_SVC_MODATTR`   | [Die modifizierten Attribute eines Services |
|                        | ändern](https://assets.nagios.c             |
|                        | om/downloads/nagioscore/docs/externalcmds/c |
|                        | mdinfo.php?command_id=155){target="_blank"} |
+------------------------+---------------------------------------------+
| **Andere Kommandos**   |                                             |
+------------------------+---------------------------------------------+
| `ENABLE_NOTIFICATIONS` | [Benachrichtigungen global                  |
|                        | erlauben](https://assets.nagios             |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=8){target="_blank"} |
+------------------------+---------------------------------------------+
| `                      | [Benachrichtigungen global                  |
| DISABLE_NOTIFICATIONS` | verhindern](https://assets.nagios           |
|                        | .com/downloads/nagioscore/docs/externalcmds |
|                        | /cmdinfo.php?command_id=7){target="_blank"} |
+------------------------+---------------------------------------------+
| `                      | [Die Erkennung von unstetigen               |
| ENABLE_FLAP_DETECTION` | Hosts/Services global                       |
|                        | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=73){target="_blank"} |
+------------------------+---------------------------------------------+
| `D                     | [Die Erkennung von unstetigen               |
| ISABLE_FLAP_DETECTION` | Hosts/Services global                       |
|                        | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=74){target="_blank"} |
+------------------------+---------------------------------------------+
| `EN                    | [Die Verarbeitung von Performance-Daten     |
| ABLE_PERFORMANCE_DATA` | global                                      |
|                        | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=65){target="_blank"} |
+------------------------+---------------------------------------------+
| `DIS                   | [Die Verarbeitung von Performance-Daten     |
| ABLE_PERFORMANCE_DATA` | global                                      |
|                        | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=66){target="_blank"} |
+------------------------+---------------------------------------------+
| `                      | [Die Ausführung von Alert Handlers/Event    |
| ENABLE_EVENT_HANDLERS` | Handlers global                             |
|                        | erlauben](https://assets.nagios.            |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=47){target="_blank"} |
+------------------------+---------------------------------------------+
| `D                     | [Die Ausführung von Alert Handlers/Event    |
| ISABLE_EVENT_HANDLERS` | Handlers global                             |
|                        | verhindern](https://assets.nagios.          |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=48){target="_blank"} |
+------------------------+---------------------------------------------+
| `S                     | [Alle Statusinformationen sofort            |
| AVE_STATE_INFORMATION` | abspeichern](https://assets.nagios.         |
|                        | com/downloads/nagioscore/docs/externalcmds/ |
|                        | cmdinfo.php?command_id=31){target="_blank"} |
+------------------------+---------------------------------------------+

::: paragraph
Kommandos, welche Ihnen nur mit dem CMC in den kommerziellen Editionen
zur Verfügung stehen:
:::

+------------------------+---------------------------------------------+
| Kommando               | Beschreibung                                |
+========================+=============================================+
| **Host-Kommandos**     |                                             |
+------------------------+---------------------------------------------+
| `                      | tba                                         |
| PROCESS_HOST_PERFDATA` |                                             |
+------------------------+---------------------------------------------+
| `UPD                   | tba                                         |
| ATE_SHADOW_HOST_STATE` |                                             |
+------------------------+---------------------------------------------+
| **Service-Kommandos**  |                                             |
+------------------------+---------------------------------------------+
| `PROCESS_SVC_PERFDATA` | tba                                         |
+------------------------+---------------------------------------------+
| `UPDATE                | tba                                         |
| _SHADOW_SERVICE_STATE` |                                             |
+------------------------+---------------------------------------------+
| **Andere Kommandos**   |                                             |
+------------------------+---------------------------------------------+
| `LOG`                  | tba                                         |
+------------------------+---------------------------------------------+
| `MK                    | tba                                         |
| _LOGWATCH_ACKNOWLEDGE` |                                             |
+------------------------+---------------------------------------------+
| `RELOAD_CONFIG`        | tba                                         |
+------------------------+---------------------------------------------+
| `REOPEN_DAEMONLOG`     | tba                                         |
+------------------------+---------------------------------------------+
| `ROTATE_LOGFILE`       | tba                                         |
+------------------------+---------------------------------------------+
| `SEGFAULT`             | tba                                         |
+------------------------+---------------------------------------------+
:::::
::::::
::::::::::::::::::::::::::::::::::::
