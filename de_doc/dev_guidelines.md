:::: {#header}
# Richtlinien für Check-Plugins

::: details
[Last modified on 18-May-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/dev_guidelines.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Katalog der Check-Plugins](https://checkmk.com/de/integrations) [Lokale
Checks](localchecks.html) [Checkmk-Erweiterungspakete (MKPs)](mkps.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::::::: sectionbody
::: paragraph
Ein großer Vorteil von Checkmk gegenüber vielen anderen
Monitoring-Systemen ist die große Zahl von gut gepflegten mitgelieferten
Check-Plugins. Damit diese eine einheitlich hohe Qualität haben, gibt es
standardisierte Kriterien, die jedes Plugin erfüllen muss, welche wir
hier vorstellen.
:::

::: paragraph
Dazu ein wichtiger Hinweis: gehen Sie nicht davon aus, dass alle mit
Checkmk mitgelieferten Plugins sich bereits an alle aktuellen
Richtlinien halten. Vergessen Sie Copy & Paste. Orientieren Sie sich
lieber an den Hinweisen in diesem Artikel.
:::

::: paragraph
Wenn Sie Plugins nur für Ihren eigenen Bedarf entwickeln, sind Sie
natürlich völlig frei und nicht an die Richtlinien gebunden.
:::

::::: sect2
### []{#_qualität .hidden-anchor .sr-only}1.1. Qualität {#heading__qualität}

::: paragraph
Für Check-Plugins, die offiziell Teil von Checkmk sind oder es werden
wollen, gelten viel höhere Ansprüche an Qualität, als für solche, die
man nur „für sich selbst" schreibt. Dabei geht es sowohl um äußere
Qualität (also Verhalten aus Sicht des Benutzers) als auch um innere
Qualität (Lesbarkeit des Codes, etc.).
:::

::: paragraph
Schreiben Sie das Plugin so gut und hochwertig wie Sie können.
:::
:::::

::::: sect2
### []{#_umfang_eines_check_plugins .hidden-anchor .sr-only}1.2. Umfang eines Check-Plugins {#heading__umfang_eines_check_plugins}

::: paragraph
Jedes Check-Plugin muss mindestens folgende Komponenten umfassen:
:::

::: ulist
- Das Check-Plugin selbst.

- Eine [Man page](#manpage).

- Bei Plugins mit Check-Parametern eine Definition für den zugehörigen
  [Regelsatz.](#wato)

- [Metrikdefinitionen](#metrics) für Graphen und Perf-O-Meter, falls der
  Check Metrikdaten ausgibt.

- Eine Definition für die Agentenbäckerei, falls es ein Agentenplugin
  gibt.

- Mehrere vollständige unterschiedliche Beispielausgaben des Agenten
  bzw. SNMP-Walks.
:::
:::::
::::::::::::
:::::::::::::

::::::::::::: sect1
## []{#naming .hidden-anchor .sr-only}2. Benennung {#heading_naming}

:::::::::::: sectionbody
::::: sect2
### []{#_name_des_check_plugins .hidden-anchor .sr-only}2.1. Name des Check-Plugins {#heading__name_des_check_plugins}

::: paragraph
Die Wahl des Namens für das Plugin ist besonders kritisch, da dieser
später nicht geändert werden kann.
:::

::: ulist
- Der Name des Plugins muss **kurz**, **spezifisch genug** und
  **verständlich** sein. Beispiel: `firewall_status` ist nur dann ein
  guter Name, wenn das Plugin für **alle** oder zumindest viele
  Firewalls funktioniert.

- Der Name besteht aus Kleinbuchstaben und Ziffern. Als Trenner ist der
  Unterstrich erlaubt.

- Das Wort `status` oder `state` hat im Namen nichts verloren, denn
  schließlich überwacht **jedes** Plugin einen Status. Gleiches gilt für
  das überflüssige Wort `current`. Verwenden Sie also anstelle von
  `foobar_current_temp_status` einfach nur `foobar_temp`.

- Check-Plugins, bei denen das Item ein Ding repräsentiert (z.B. Fan,
  Power supply), sollen im **Singular** benannt werden (z.B. `casa_fan`,
  `oracle_tablespace`). Check-Plugins bei denen jedes Item eine Anzahl
  oder Menge darstellt hingegen werden im Plural (z.B. `user_logins`,
  `printer_pages`) benannt.

- Produktspezifische Check-Plugins sollen den Produktnamen als Präfix
  haben (z.B. `oracle_tablespace`).

- Herstellerspezifische Check-Plugins, die sich **nicht** auf ein
  bestimmtes Produkt beziehen, sollen mit einem Präfix versehen werden,
  das den Hersteller wiedergibt (z.B. `fsc_` für Fujitsu Siemens
  Computers).

- SNMP-basierte Check-Plugins, die einen allgemeinen Teil der MIB
  verwenden, der womöglich von mehr als einem Hersteller unterstützt
  wird, sollen nach der MIB benannt werden, nicht nach dem Hersteller
  (z.B. die `hr_*`-Check-Plugins)
:::
:::::

:::: sect2
### []{#_name_des_services .hidden-anchor .sr-only}2.2. Name des Services {#heading__name_des_services}

::: ulist
- Benutzen Sie bekannte, gut abgegrenzte Abkürzungen (z.B. CPU, DB, VPN,
  IO,...).

- Schreiben Sie Abkürzungen in Großbuchstaben.

- Verwenden Sie Groß- und Kleinschreibung wie in natürlichen englischen
  Sätzen (z.B. `CPU utilization`, nicht
  `Cpu Utilization`) --- Eigennamen sind eine Ausnahme.

- Verwenden Sie für Produktnamen die Schreibweise des Herstellers (z.B.
  `vSphere`).

- Nutzen Sie amerikanisches Englisch (z.B. `utilization`, nicht
  `utilisation`).

- Folgen Sie Namenskonventionen, sofern diese existieren. So sollten
  alle Services für Interfaces das Template `Interface %s` nutzen.

- Halten Sie Beschreibungen kurz, denn Service-Namen werden in
  Dashboards, Views und Reports abgeschnitten, wenn diese zu lang sind.
:::
::::

:::: sect2
### []{#_name_der_metriken .hidden-anchor .sr-only}2.3. Name der Metriken {#heading__name_der_metriken}

::: ulist
- Metriken, für die schon eine sinnvolle Definition existiert, sollen
  wiederverwendet werden.

- Ansonsten gelten analoge Regeln wie bei den Namen von Check-Plugins
  (produktspezifisch, herstellerspezifisch, etc.)
:::
::::

:::: sect2
### []{#_name_der_check_gruppe_für_den_regelsatz .hidden-anchor .sr-only}2.4. Name der Check-Gruppe für den Regelsatz {#heading__name_der_check_gruppe_für_den_regelsatz}

::: paragraph
Hier gilt das gleiche wie bei den Metriken.
:::
::::
::::::::::::
:::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#structure .hidden-anchor .sr-only}3. Aufbau des Check-Plugins {#heading_structure}

::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_genereller_aufbau .hidden-anchor .sr-only}3.1. Genereller Aufbau {#heading__genereller_aufbau}

::: paragraph
Die eigentliche Python-Datei unter `~/share/check_mk/checks/` soll
folgenden Aufbau haben (Reihenfolge einhalten):
:::

::: {.olist .arabic}
1.  Datei-Header mit GPL-Hinweis.

2.  Name und E-Mail-Adresse des ursprünglichen Autors, falls das Plugin
    nicht vom Checkmk-Projekt selbst entwickelt wurde.

3.  Eine kurze Beispielausgabe des Agenten.

4.  Standardwerte für die Check-Parameter (`factory_settings`).

5.  Hilfsfunktionen, falls vorhanden.

6.  Die Parse-Funktion, falls vorhanden.

7.  Die Discovery-Funktion.

8.  Die Check-Funktion.

9.  Die `check_info`-Deklaration.
:::
:::::

:::::::::::::::::::::::::::::::::::: sect2
### []{#_coding_richtlinien .hidden-anchor .sr-only}3.2. Coding-Richtlinien {#heading__coding_richtlinien}

:::: sect3
#### []{#_autor .hidden-anchor .sr-only}Autor {#heading__autor}

::: paragraph
Wenn das Plugin nicht vom Checkmk-Team entwickelt wurde, kann der Name
und die E-Mail-Adresse des Autors hinterlegt werden, direkt nach dem
Datei-Header.
:::
::::

:::: sect3
#### []{#_lesbarkeit .hidden-anchor .sr-only}Lesbarkeit {#heading__lesbarkeit}

::: ulist
- Vermeiden Sie lange Zeilen. Die maximale erlaubte Länge sind 100
  Zeichen.

- Die Einrückung erfolgt durch jeweils vier Leerzeichen. Verwenden Sie
  kein Tabulatorzeichen.

- Orientieren Sie sich am Python-Standard PEP 8.
:::
::::

::::::: sect3
#### []{#_beispielausgabe_des_agenten .hidden-anchor .sr-only}Beispielausgabe des Agenten {#heading__beispielausgabe_des_agenten}

::: paragraph
Das Hinzufügen einer Beispielausgabe vom Agenten erleichtert das Lesen
des Codes ungemein. Dabei ist es wichtig, dass auch verschiedene
mögliche Varianten der Ausgabe im Beispiel vorkommen. Machen Sie das
Beispiel nicht länger als notwendig. Bei SNMP-basierten Checks geben Sie
einen SNMP-Walk an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
# Example excerpt from SNMP data:
# .1.3.6.1.4.1.2.3.51.2.2.7.1.0  255
# .1.3.6.1.4.1.2.3.51.2.2.7.2.1.1.1  1
# .1.3.6.1.4.1.2.3.51.2.2.7.2.1.2.1  "Good"
# .1.3.6.1.4.1.2.3.51.2.2.7.2.1.3.1  "No critical or warning events"
# .1.3.6.1.4.1.2.3.51.2.2.7.2.1.4.1  "No timestamp"
```
:::
::::

::: paragraph
Wenn es z.B. aufgrund verschiedener Firmwareversionen des Zielgerätes
verschiedene Ausgabeformate gibt, dann geben Sie für jeden ein Beispiel
an, mit einem Hinweis auf die Version. Ein gutes Beispiel dafür finden
Sie im Check-Plugin `multipath`.
:::
:::::::

:::::: sect3
#### []{#_snmp_mibs .hidden-anchor .sr-only}SNMP-MIBs {#heading__snmp_mibs}

::: paragraph
Bei der Definition des `snmp_info` soll in Kommentaren der lesbare Pfad
zur OID angegeben werden. Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    'snmp_info' : (".1.3.6.1.2.1.47.1.1.1.1", [
        OID_END,
        "2",    # ENTITY-MIB::entPhysicalDescription
        "5",    # ENTITY-MIB::entPhysicalClass
        "7",    # ENTITY-MIB::entPhysicalName
    ]),
```
:::
::::
::::::

:::::: sect3
#### []{#_verwendung_von_lambda .hidden-anchor .sr-only}Verwendung von `lambda` {#heading__verwendung_von_lambda}

::: paragraph
Vermeiden Sie komplizierte Ausdrücke mit `lambda`. Erlaubt ist `lambda`
bei der Scan-Funktion `lambda oid: …​` und wenn man bestehende Funktionen
lediglich mit einem bestimmten geänderten Argument aufrufen möchte,
z.B.:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
     "inventory_function" : lambda info: inventory_foobar_generic(info, "temperature")
```
:::
::::
::::::

::::::::: sect3
#### []{#_schleifen_über_snmp_agentendaten .hidden-anchor .sr-only}Schleifen über SNMP-Agentendaten {#heading__schleifen_über_snmp_agentendaten}

::: paragraph
Bei Checks, die in einer Schleife über SNMP-Daten gehen, sollen Sie
keine Indizes verwenden wie hier:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    for line in info:
        if line[1] != '' and line[0] ...
```
:::
::::

::: paragraph
Besser ist es, jede Zeile gleich in sinnvolle Variablen auszupacken:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    for *sensor_id, state_state, foo, bar* in info:
        if sensor_state != '1' and sensor_id ...
```
:::
::::
:::::::::

:::: sect3
#### []{#_parse_funktionen .hidden-anchor .sr-only}Parse-Funktionen {#heading__parse_funktionen}

::: paragraph
Verwenden Sie Parse-Funktionen wann immer das Parsen der Agentenausgabe
nicht trivial ist. Das Argument der Parse-Funktion soll dann immer
`info` heißen und bei der Discovery- und Check-Funktion nicht mehr
`info`, sondern `parsed`. Somit wird dem Leser deutlich, dass dies das
Ergebnis der Parse-Funktion ist.
:::
::::

::::::: sect3
#### []{#_checks_mit_mehreren_teilresultaten .hidden-anchor .sr-only}Checks mit mehreren Teilresultaten {#heading__checks_mit_mehreren_teilresultaten}

::: paragraph
Ein Check, der in einem Service mehrere Teilzustände liefert (z.B.
aktuelle Belegung und Wachstum), muss diese mit `yield` zurückgeben.
Checks, die nur ein Resultat liefern, müssen dies mit `return` tun.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
    if "abs_levels" in params:
        warn, crit = params["abs_levels"]
        if value >= crit:
            yield 2, "...."
        elif value >= warn:
            yield 1, "...."
        else:
            yield 0, "..."

    if "perc_levels" in params:
        warn, crit = params["perc_levels"]
        if percentage >= crit:
            yield 2, "...."
        elif percentage >= warn:
            yield 1, "...."
        else:
            yield 0, "..."
```
:::
::::

::: paragraph
Die Markierungen `(!)` und `(!!)` sind veraltet und dürfen nicht mehr
verwendet werden. Diese sollen durch `yield` ersetzt werden.
:::
:::::::

:::: sect3
#### []{#_schlüssel_in_check_info .hidden-anchor .sr-only}Schlüssel in `check_info[…​]` {#heading__schlüssel_in_check_info}

::: paragraph
Legen Sie in Ihrem Eintrag in `check_info` nur solche Schlüssel an, die
verwendet werden. Die einzigen verpflichtenden Einträge sind
`"service_description"` und `"check_function"`. Fügen Sie
`"has_perfdata"` und andere Schlüssel mit booleschen Werten nur dann
ein, wenn der Wert `True` ist.
:::
::::
::::::::::::::::::::::::::::::::::::

::::: sect2
### []{#_agentenplugins .hidden-anchor .sr-only}3.3. Agentenplugins {#heading__agentenplugins}

::: paragraph
Wenn Ihr Check-Plugin ein Agentenplugin benötigt, dann beachten Sie
folgende Regeln:
:::

::: ulist
- Legen Sie das Plugin nach `~/share/check_mk/agents/plugins` für
  Unix-artige Systeme und setzen Sie die Ausführungsrechte auf `755`.

- Bei Windows heißt das Verzeichnis
  `~/share/check_mk/agents/windows/plugins`.

- Shell- und Python-Skripte sollen keine Endung haben (`.sh` oder `.py`
  weglassen).

- Verwenden Sie bei Shell-Skripten `#!/bin/sh` in der ersten Zeile.
  Verwenden Sie `#!/bin/bash` nur dann, wenn Sie Features der Bash
  brauchen.

- Fügen Sie den Standard Checkmk-Datei-Header mit dem GPL-Hinweis ein.

- Ihr Plugin darf auf dem Zielsystem keinerlei Schaden verursachen, vor
  allem auch dann nicht, wenn das Plugin von dem System eigentlich nicht
  unterstützt wird.

- Vergessen Sie den Hinweis auf das Plugin nicht in der Man page des
  Check-Plugins.

- Wenn die Komponente, die das Plugin überwacht, auf einem System gar
  nicht existiert, darf das Plugin auch keinen Sektions-Header ausgeben.

- Wenn das Plugin eine Konfigurationsdatei benötigt, soll es diese (bei
  Linux) im Verzeichnis `$MK_CONFDIR` suchen und die Datei soll den
  gleichen Namen wie das Plugin haben, nur mit der Endung `.cfg` und
  ohne ein mögliches `mk_` am Anfang. Bei Windows gilt das analog. Das
  Verzeichnis ist hier `%MK_CONFDIR%`.

- Schreiben Sie unter Windows keine Plugins in PowerShell. Dieses ist
  nicht portabel und außerdem sehr ressourcenhungrig. Verwenden Sie
  VBScript.

- Schreiben Sie keine Plugins in Java.
:::
:::::

:::: sect2
### []{#_was_man_nicht_tun_sollte .hidden-anchor .sr-only}3.4. Was man nicht tun sollte {#heading__was_man_nicht_tun_sollte}

::: ulist
- Verwenden Sie kein `import` in Ihrer Check-Plugin-Datei. Alle
  erlaubten Python-Module sind bereits importiert.

- Verwenden Sie zum Parsen und zur Verrechnung von Zeitangaben nicht
  `datetime` sondern `time`. Das kann alles, was Sie brauchen. Wirklich!

- Argumente, die eine Ihrer Funktionen übergeben bekommt, darf diese auf
  keinen Fall modifizieren. Dies gilt insbesondere für `params` und
  `info`.

- Wenn Sie wirklich mit regulären Ausdrücken arbeiten wollen (diese sind
  langsam!), so holen Sie sich diese mit der Funktion `regex()`.
  Verwenden Sie nicht `re` direkt.

- Selbstverständlich dürfen Sie nirgendwo `print` verwenden,
  anderweitige Ausgaben nach `stdout` machen oder sonst irgendwie mit
  der Außenwelt kommunizieren!

- Die SNMP-Scan-Funktion darf keine OIDs außer `.1.3.6.1.2.1.1.1.0` und
  `.1.3.6.1.2.1.1.2.0` holen. Ausnahme: sie hat vorher durch Check einer
  dieser beiden OIDs sichergestellt, dass weitere OIDs nur von einer eng
  eingegrenzten Zahl von Geräten geholten werden.
:::
::::
:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: sect1
## []{#behavior .hidden-anchor .sr-only}4. Verhalten des Check-Plugins {#heading_behavior}

::::::::::::::::::::::: sectionbody
:::::: sect2
### []{#_exceptions .hidden-anchor .sr-only}4.1. Exceptions {#heading__exceptions}

::: paragraph
Ihr Check-Plugin darf nicht nur sondern **soll** sogar stets davon
ausgehen, dass die Ausgabe des Agenten syntaktisch valide ist. Das
Plugin darf auf keinen Fall versuchen, etwaige unbekannte
Fehlersituationen in der Ausgabe selbst zu behandeln!
:::

::: paragraph
Warum? Checkmk hat eine sehr ausgefeilte automatische Behandlung von
solchen Fehlern. Es kann für den Benutzer ausführliche Absturzberichte
(*crash reports*) erzeugen und setzt auch den Zustand des Plugins
zuverlässig auf [UNKNOWN]{.state3}. Dies ist viel hilfreicher als wenn
der Check z.B. einfach nur `unknown SNMP code 17` ausgibt.
:::

::: paragraph
Generell **soll** die Discovery-, Parse- und/oder Check-Funktion in eine
Exception laufen, wenn die Ausgabe des Agenten nicht in dem definierten,
bekannten Format ist, aufgrund dessen das Plugin entwickelt wurde.
:::
::::::

::::: sect2
### []{#_saveint_und_savefloat .hidden-anchor .sr-only}4.2. saveint() und savefloat() {#heading__saveint_und_savefloat}

::: paragraph
Die Funktionen `saveint()` und `savefloat()` konvertieren einen String
in `int` bzw. `float` und ergeben eine `0`, falls der String nicht
konvertierbar ist (z.B. leerer String).
:::

::: paragraph
Verwenden Sie diese Funktionen nur dann, wenn der leere bzw. ungültige
Wert ein bekannter und erwartbarer Fall ist. Ansonsten würden Sie
wichtige Fehlermeldungen damit unterdrücken (siehe oben).
:::
:::::

:::: sect2
### []{#_nicht_gefundenes_item .hidden-anchor .sr-only}4.3. Nicht gefundenes Item {#heading__nicht_gefundenes_item}

::: paragraph
Ein Check, der das überwachte Item nicht findet, soll einfach `None`
zurückgeben und **nicht** eine eigene Fehlermeldung dafür generieren.
Checkmk wird in diesem Fall eine standardisierte konsistente
Fehlermeldung ausgeben und den Service auf [UNKNOWN]{.state3} setzen.
:::
::::

::::: sect2
### []{#_schwellwerte .hidden-anchor .sr-only}4.4. Schwellwerte {#heading__schwellwerte}

::: paragraph
Viele Check-Plugins haben Parameter, die Schwellwerte für bestimmte
Metriken definieren und so festlegen, wann der Check [WARN]{.state1}
bzw. [CRIT]{.state2} wird. Beachten Sie dabei die folgenden Regeln, die
dafür sorgen, dass sich Checkmk **konsistent** verhält:
:::

::: ulist
- Die Schwellen für [WARN]{.state1} und [CRIT]{.state2} sollen immer mit
  `>=` und `<=` überprüft werden. Beispiel: ein Plugin überwacht die
  Länge einer E-Mail-Warteschlange. Die kritische obere Schwelle
  ist 100. Das bedeutet, dass der Wert 100 bereits kritisch ist!

- Wenn es nur obere oder nur untere Schwellwerte gibt (häufigster Fall),
  dann sollen die Eingabefelder im Regelsatz mit [Warning at]{.guihint}
  und [Critical at]{.guihint} beschriftet werden.

- Wenn es obere und untere Schwellwerte gibt, soll die Beschriftung wie
  folgt lauten: [Warning at or above]{.guihint}, [Critical at or
  above]{.guihint}, [Warning at or below]{.guihint} und [Critical at or
  below]{.guihint}.
:::
:::::

::::: sect2
### []{#_ausgabe_des_check_plugins .hidden-anchor .sr-only}4.5. Ausgabe des Check-Plugins {#heading__ausgabe_des_check_plugins}

::: paragraph
Jeder Check gibt eine Zeile Text aus - die Plugin-Ausgabe. Um ein
konsistenten Verhalten von allen Plugins zu erreichen, gelten folgende
Regeln:
:::

::: ulist
- Bei der Anzeige von Messwerten steht genau ein Leerzeichen zwischen
  dem Wert und der Einheit (z.B. `17.4 V`). Die einzige Ausnahme: bei
  `%` steht kein Leerzeichen: `89.5%`.

- Bei der Anzeige von Messwerten ist die Bezeichnung des Wertes in
  Großbuchstaben geschrieben, gefolgt von einem Doppelpunkt. Beispiel:
  `Voltage: 24.5 V, Phase: negative, Flux-Compensator: operational`

- Zeigen Sie in der Plugin-Ausgabe keine internen Schlüssel, Codewörter,
  SNMP-Interna oder anderen Müll an, mit dem der Benutzer nichts
  anfangen kann. Verwenden Sie sinnvolle menschenlesbare Begriffe.
  Verwenden Sie die Begriffe, die Benutzer üblicherweise erwarten.
  Beispiel: Verwenden Sie `route monitor has failed` anstelle von
  `routeMonitorFail`.

- Wenn das Check-Item eine zusätzliche Spezifikation hat, dann setzen
  Sie diese in eckige Klammern an den Anfang der Ausgabe (z.B.
  `Interface 2 - [eth0] …​`).

- Bei Aufzählungen wird mit einem Komma getrennt und danach mit einem
  Großbuchstaben fortgesetzt:
  `Swap used: …​, Total virtual memory used: …​`
:::
:::::

::::: sect2
### []{#_standardschwellwerte .hidden-anchor .sr-only}4.6. Standardschwellwerte {#heading__standardschwellwerte}

::: paragraph
Jedes Plugin, das mit Schwellwerten arbeitet, soll sinnvolle
Standard-Schwellwerte definieren. Dabei gelten folgende Regeln:
:::

::: ulist
- Die im Check verwendeten Standardschwellwerte sollen auch 1:1 im
  zugehörigen Regelsatz als Standardparameter definiert sein.

- Die Standardschwellwerte sollen in `factory_settings` definiert werden
  (falls der Check ein Dictionary als Parameter hat).

- Die Standardschwellwerte sollen fachlich fundiert gewählt werden. Gibt
  es vom Hersteller eine Vorgabe? Gibt es „Best Practices"?

- Im Check muss unbedingt dokumentiert sein, woher die Schwellwerte
  kommen.
:::
:::::

:::: sect2
### []{#_nagios_vs_cmc .hidden-anchor .sr-only}4.7. Nagios vs. CMC {#heading__nagios_vs_cmc}

::: paragraph
Stellen Sie sicher, dass Ihr Check auch mit Nagios als Monitoring-Kern
funktioniert. Meist ist das automatisch der Fall, aber nicht immer.
:::
::::
:::::::::::::::::::::::
::::::::::::::::::::::::

::::::::::::: sect1
## []{#metrics .hidden-anchor .sr-only}5. Metriken {#heading_metrics}

:::::::::::: sectionbody
:::: sect2
### []{#_format_der_metriken .hidden-anchor .sr-only}5.1. Format der Metriken {#heading__format_der_metriken}

::: ulist
- Die Metrikdaten werden vom Check-Plugin immer als `int` oder `float`
  zurückgegeben. Strings sind nicht erlaubt.

- Wenn Sie in dem Sechstupel von einem Metrikwert Felder auslassen
  möchten, dann verwenden Sie `None` an deren Stelle. Beispiel:
  `[("taple_util", utilization, None, None, 0, size)]`

- Wenn Sie Einträge am Ende nicht benötigen, dann kürzen Sie einfach das
  Tupel. Verwenden Sie kein `None` am Ende.
:::
::::

::::: sect2
### []{#_benennung_der_metriken .hidden-anchor .sr-only}5.2. Benennung der Metriken {#heading__benennung_der_metriken}

::: ulist
- Die Namen von Metriken bestehen aus Kleinbuchstaben und Unterstrichen.
  Ziffern sind erlaubt, allerdings nicht am Anfang.

- Die Namen von Metriken sollen analog zu den Check-Plugins kurz aber
  spezifisch benannt sein. Metriken, die von mehreren Plugins verwendet
  werden, sollen generische Namen haben.

- Vermeiden Sie das sinnlose Füllwort `current`. Der Messwert ist ja
  immer der gerade aktuelle.

- Die Metrik soll nach dem „Ding" benannt werden, nicht nach der
  Einheit. Also z.B. `current` anstelle von `ampere` oder `size`
  anstelle von `bytes`.
:::

::: paragraph
**Wichtig:** Verwenden Sie immer die kanonische Größenordnung. Wirklich!
Checkmk skaliert die Daten von sich aus sinnvoll. Beispiele:
:::

+-----------------------------------+-----------------------------------+
| Domäne                            | kanonische Einheit                |
+===================================+===================================+
| Dauer                             | Sekunde                           |
+-----------------------------------+-----------------------------------+
| Dateigröße                        | Byte                              |
+-----------------------------------+-----------------------------------+
| Temperatur                        | Celsius                           |
+-----------------------------------+-----------------------------------+
| Netzwerkdurchsatz                 | Oktette pro Sekunde (nicht Bits   |
|                                   | pro Sekunde!)                     |
+-----------------------------------+-----------------------------------+
| Prozentwert                       | Wert von 0 bis 100 (nicht 0.0 bis |
|                                   | 1.0)                              |
+-----------------------------------+-----------------------------------+
| Ereignisse pro Zeit               | 1 pro Sekunde                     |
+-----------------------------------+-----------------------------------+
| Elektrische Leistung              | Watt (nicht mW)                   |
+-----------------------------------+-----------------------------------+
:::::

:::: sect2
### []{#_kennzeichen_für_metrikdaten .hidden-anchor .sr-only}5.3. Kennzeichen für Metrikdaten {#heading__kennzeichen_für_metrikdaten}

::: paragraph
Setzen Sie `"has_perfdata"` in `check_info` nur genau dann auf `True`,
wenn der Check wirklich Metrikdaten ausgibt (oder ausgeben kann).
:::
::::

:::: sect2
### []{#_definition_für_graph_und_perf_o_meter .hidden-anchor .sr-only}5.4. Definition für Graph und Perf-O-Meter {#heading__definition_für_graph_und_perf_o_meter}

::: paragraph
Die Definition für Graphen soll analog zu den Definitionen in
`~/web/plugins/metrics/check_mk.py` erfolgen. Erzeugen Sie keine
Definitionen für PNP-Graphen. Auch in Checkmk Raw werden diese anhand
der Metrikdefinition in Checkmk selbst erzeugt.
:::
::::
::::::::::::
:::::::::::::

:::::::::::::: sect1
## []{#wato .hidden-anchor .sr-only}6. Definition des Regelsatzes {#heading_wato}

::::::::::::: sectionbody
::::::: sect2
### []{#_name_der_check_gruppe .hidden-anchor .sr-only}6.1. Name der Check-Gruppe {#heading__name_der_check_gruppe}

::: paragraph
Check-Plugins mit Parametern erfordern zwingend die Definition eines
Regelsatzes. Die Verbindung zwischen Plugin und Regelsatz erfolgt über
die Check-Gruppe (Eintrag `"group"` in `check_info`). Über die Gruppe
werden alle Checks zusammengefasst, welche über den gleichen Regelsatz
konfiguriert werden.
:::

::: paragraph
Falls Ihr Plugin sinnvollerweise mit einem bestehenden Regelsatz
konfiguriert werden soll, dann verwenden Sie eine bestehende Gruppe.
:::

::: paragraph
Falls Ihr Plugin so spezifisch ist, dass es auf jeden Fall eine eigene
Gruppe benötigt, dann legen Sie eine eigene Gruppe an, wobei der Name
der Gruppe einen Bezug zum Plugin haben soll.
:::

::: paragraph
Falls abzusehen ist, dass es später noch weitere Plugins mit dem
gleichen Regelsatz geben kann, verwenden Sie entsprechend einen
generischen Namen.
:::
:::::::

::::: sect2
### []{#_standardwerte_von_valuespecs .hidden-anchor .sr-only}6.2. Standardwerte von ValueSpecs {#heading__standardwerte_von_valuespecs}

::: paragraph
Definieren Sie bei Ihren Parameterdefinitionen (*ValueSpecs*) die
Standardwerte genau so, wie die wirklichen Defaults des Checks sind
(falls das geht).
:::

::: paragraph
Beispiel: Wenn der Check ohne Regel die Schwellwerte `(5, 10)` für
[WARN]{.state1} und [CRIT]{.state2} annimmt, dann soll das ValueSpec so
definiert sein, dass automatisch auch `5` und `10` als Schwellwerte
angeboten werden.
:::
:::::

:::: sect2
### []{#_wahl_der_valuespecs .hidden-anchor .sr-only}6.3. Wahl der ValueSpecs {#heading__wahl_der_valuespecs}

::: paragraph
Für manche Arten von Daten gibt es spezialisierte ValueSpecs. Ein
Beispiel ist `Age` für eine Anzahl von Sekunden. Diese müssen überall da
verwendet werden, wo sie sinnvoll sind. Verwenden Sie z.B. nicht
`Integer` in so einem Fall.
:::
::::
:::::::::::::
::::::::::::::

:::::: sect1
## []{#includes .hidden-anchor .sr-only}7. Include-Dateien {#heading_includes}

::::: sectionbody
::: paragraph
Für etliche Arten von Checks gibt es bereits fertige Implementierungen
in Include-Dateien, die Sie nicht nur verwenden können, sondern sollen.
Wichtige Include-Dateien sind:
:::

+-----------------------------------+-----------------------------------+
| `temperature.include`             | Überwachung von Temperaturen      |
+-----------------------------------+-----------------------------------+
| `elphase.include`                 | Elektrische Wechselstromphase     |
|                                   | (z.B. bei USV)                    |
+-----------------------------------+-----------------------------------+
| `fan.include`                     | Lüfter                            |
+-----------------------------------+-----------------------------------+
| `if.include`                      | Netzwerkschnittstellen            |
+-----------------------------------+-----------------------------------+
| `df.include`                      | Füllstände von Dateisystemen      |
+-----------------------------------+-----------------------------------+
| `mem.include`                     | Überwachung von RAM               |
|                                   | (Hauptspeicher)                   |
+-----------------------------------+-----------------------------------+
| `ps.include`                      | Prozesse eines Betriebssystems    |
+-----------------------------------+-----------------------------------+

::: paragraph
**Wichtig:** Verwenden Sie vorhandene Include-Dateien nur dann, wenn
diese für den jeweiligen Zweck auch **gedacht** sind und nicht, wenn
diese nur so ungefähr passen!
:::
:::::
::::::

::::::::::::::::::::::::::::::::::::: sect1
## []{#manpage .hidden-anchor .sr-only}8. Man pages {#heading_manpage}

:::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Jedes Check-Plugin **muss** eine Man page haben. Falls Sie in einer
Check-Plugin-Datei mehrere Plugins programmiert haben muss natürlich
jedes davon eine eigene Man page haben.
:::

::: paragraph
Die Man page ist für den Benutzer gedacht! Schreiben Sie Informationen,
die diesem helfen. Es geht nicht darum, zu dokumentieren, was Sie
programmiert haben, sondern darum, dass der Benutzer die für ihn
wichtigen, nützlichen Informationen bekommt.
:::

::: paragraph
Die Man page muss sein
:::

::: ulist
- vollständig,

- präzise,

- knapp,

- hilfreich.
:::

::: paragraph
Eine Man page besteht aus mehreren, teilweise optionalen, Bereichen:
:::

:::::: sect2
### []{#_titel .hidden-anchor .sr-only}8.1. Titel {#heading__titel}

::: paragraph
Mit dem Makro `title:` bestimmen Sie die Überschrift. Sie besteht aus:
:::

::: ulist
- dem exakten Gerätenamen oder der Gerätegruppe, für welche der Check
  geschrieben ist,

- der Information, was der Check überwacht (z.B. System Health).
:::

::: paragraph
Diese beiden Teile werden mit einem Doppelpunkt voneinander getrennt.
Nur auf diese Weise können bestehende Checks leicht durchsucht und vor
allem auch gefunden werden.
:::
::::::

::::: sect2
### []{#_agentenkategorien .hidden-anchor .sr-only}8.2. Agentenkategorien {#heading__agentenkategorien}

::: paragraph
Das Makro `agents:` kann verschiedene Kategorien haben. Grundsätzlich
werden drei Bereiche unterschieden:
:::

::: ulist
- Agenten: In diesem Fall werden die Betriebssysteme angegeben, für
  welche der Check gebaut wurde und zur Verfügung steht, zum Beispiel
  `linux` oder `linux, windows, solaris`.

- SNMP: In diesem Fall gibt es nur den Eintrag `snmp`.

- Aktive Checks: Wenn ein aktiver Check in die Oberfläche von Checkmk
  integriert wurde, nehmen Sie die Kategorie `active`.
:::
:::::

:::::: sect2
### []{#_katalogeintrag .hidden-anchor .sr-only}8.3. Katalogeintrag {#heading__katalogeintrag}

::: paragraph
Über den Header `catalog:` legen Sie fest, wo im Katalog der
Check-Plugins die Man page einsortiert wird.
:::

::: paragraph
Falls eine Kategorie fehlt (z.B. ein neuer Hersteller), so muss dieser
in der Datei `cmk/utils/man_pages.py` in der Variable `catalog_titles`
definiert werden. Aktuell kann diese Datei nicht über Plugins in
`local/` erweitert werden, so dass Änderungen hier nur die Entwickler
von Checkmk machen können.
:::

::: paragraph
Beachten Sie die genaue Groß-/Kleinschreibung von Produkt- und
Firmennamen! Das gilt nicht nur für den Katalogeintrag, sondern auch für
alle anderen Texte, in denen diese vorkommen. Beispiel: `NetApp` wird
immer `NetApp` geschrieben und **nicht** `netapp`, `NETAPP`, `Netapp`,
oder dergleichen. Google hilft, die richtige Schreibung zu finden.
:::
::::::

:::::: sect2
### []{#_beschreibung_des_plugins .hidden-anchor .sr-only}8.4. Beschreibung des Plugins {#heading__beschreibung_des_plugins}

::: paragraph
Folgende Informationen müssen in der `description:` der Man page
enthalten sein:
:::

::: ulist
- Welche Hard- oder Software überwacht der Check genau? Gibt es
  Besonderheiten von bestimmten Firmware- oder Produktversionen der
  Geräte? Beziehen Sie sich dabei **nicht** auf eine MIB, sondern auf
  Produktbezeichnungen. Beispiel: Dem Benutzer ist nicht geholfen, wenn
  Sie schreiben „Dieser Check funktioniert bei allen Geräten, welche die
  Foobar-17.11-MIB unterstützen\". Schreiben Sie, welche Produktlinien
  oder dergleichen unterstützt werden.

- Welcher Aspekt davon wird überwacht? Was macht der Check?

- Unter welchen Bedingungen wird der Check [OK]{.state0},
  [WARN]{.state1} oder [CRIT]{.state2}?

- Wird für den Check ein Agentenplugin benötigt? Falls ja: wie wird
  dieses installiert? Das muss auch ohne Agentenbäckerei gehen.

- Gibt es weitere Voraussetzungen, damit der Check funktioniert
  (Vorbereitung des Zielsystems, Installation von Treibern, etc.). Diese
  sollen nur dann aufgeführt werden, wenn Sie nicht sowieso
  normalerweise erfüllt sind (z.B. das Mounten von `/proc` unter Linux).
:::

::: paragraph
Schreiben Sie nichts, was alle Checks insgesamt betrifft. Wiederholen
Sie z.B. nicht generelle Dinge, wie man SNMP-basierte Checks einrichtet.
:::
::::::

:::: sect2
### []{#_item .hidden-anchor .sr-only}8.5. Item {#heading__item}

::: paragraph
Bei Checks, die ein Item haben (also auch ein `%s` im Service-Namen),
muss in der Man page unter `item:` beschrieben sein, wie dieses gebildet
wird. Wenn das Check-Plugin kein Item benutzt, können Sie diese Zeile
komplett auslassen.
:::
::::

::::::::::::: sect2
### []{#_service_erkennung .hidden-anchor .sr-only}8.6. Service-Erkennung {#heading__service_erkennung}

::: paragraph
Schreiben Sie unter `inventory:` unter welchen Bedingungen der Service
bzw. die Services dieses Checks automatisch gefunden werden, also wie
sich die Service-Erkennung (*service discovery*) verhält. Ein Beispiel
aus `nfsmounts`:
:::

::::: listingblock
::: title
nfsmounts
:::

::: content
``` {.pygments .highlight}
inventory:
  All NFS mounts are found automatically. This is done
  by scanning {/proc/mounts}. The file {/etc/fstab} is irrelevant.
```
:::
:::::

::: paragraph
Achten Sie darauf, dass der Text ohne tiefere Kenntnisse einer MIB oder
des Codes verständlich ist. Schreiben Sie also nicht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
One service is created for each temperature sensor, if the state is 1.
```
:::
::::

::: paragraph
Stattdessen ist es besser, möglichst alles zu übersetzen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
One service is created for each temperature sensor, if the state is "active".
```
:::
::::
:::::::::::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
