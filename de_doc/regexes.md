:::: {#header}
# Reguläre Ausdrücke in Checkmk

::: details
[Last modified on 24-Aug-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/regexes.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Regeln](wato_rules.html) [Ansichten von Hosts und Services
(Views)](views.html) [Die Event Console](ec.html)
:::
::::
:::::
::::::
::::::::

::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::::: sectionbody
::: paragraph
Reguläre Ausdrücke (englisch *regular expression* oder *regex*, selten
*regexp*), werden in Checkmk für die Angabe von Service-Namen und auch
an vielen anderen Stellen verwendet. Es sind Muster, die auf einen
bestimmten Text passen (*match*) oder nicht passen (*non-match*). Damit
können Sie viele praktische Dinge anstellen, wie z.B. flexible
[Regeln](wato_rules.html) formulieren, die für alle Services greifen,
bei denen `foo` oder `bar` im Namen vorkommt.
:::

::: paragraph
Oft werden reguläre Ausdrücke mit den Suchmustern für Dateinamen
verwechselt, denn die Sonderzeichen `*` und `?`, sowie eckige und
geschweifte Klammern gibt es in beiden.
:::

::: paragraph
In diesem Artikel zeigen wir Ihnen die wichtigsten Möglichkeiten der
regulären Ausdrücke, selbstverständlich im Kontext von Checkmk. Da
Checkmk zwei verschiedene Komponenten für reguläre Ausdrücke nutzt,
steckt manchmal der Teufel im Detail. Im wesentlichen nutzt der
Monitoring-Kern die **C-Bibliothek** und alle weiteren Komponenten
**Python 3**. Wo Unterschiede bestehen, erklären wir diese.
:::

::: paragraph
**Tipp:** In Checkmk sind regexp in Eingabefeldern auf unterschiedlichen
Seiten erlaubt. Wenn Sie sich unsicher sind, lassen Sie sich die
kontextsensitive Hilfe über das [Help]{.guihint}-Menü einblenden ([Help
\> Show inline help]{.guihint}). Dann sehen Sie, ob reguläre Ausdrücke
erlaubt sind und wie sie genutzt werden können.
:::

::: paragraph
Bei der Arbeit mit älteren Plugins oder Plugins aus externen Quellen
kann es mitunter vorkommen, dass diese Python 2 oder Perl nutzen und von
den hier geschilderten Konventionen abweichen, bitte beachten Sie daher
die jeweilige Plugin-spezifische Dokumentation.
:::

::: paragraph
In diesem Artikel zeigen wir Ihnen die wichtigsten Möglichkeiten der
regulären Ausdrücke --- aber bei weitem nicht alle. Falls Ihnen die hier
gezeigten Möglichkeiten nicht weit genug gehen, finden Sie [weiter
unten](#reference) Hinweise, wo Sie alle Details nachlesen können. Und
dann gibt es ja immer noch das Internet.
:::

::: paragraph
Falls Sie eigene Plugins programmieren wollen, die beispielsweise mit
regulären Ausdrücken Auffälligkeiten in Log-Dateien finden, können Sie
diesen Artikel als Grundlage verwenden. Allerdings ist bei der Suche in
großen Datenmengen die Optimierung der Performance ein wichtiger Aspekt.
Schlagen Sie daher im Zweifel immer in der Dokumentation der verwendeten
Regex-Bibliothek nach.
:::
::::::::::
:::::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_mit_regulären_ausdrücken_arbeiten .hidden-anchor .sr-only}2. Mit regulären Ausdrücken arbeiten {#heading__mit_regulären_ausdrücken_arbeiten}

::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
In diesem Abschnitt zeigen wir anhand konkreter Beispiele die Arbeit mit
regulären Ausdrücken, von einfachen Matches einzelner Zeichen oder
Zeichenketten, bis hin zu komplexen Gruppen von Zeichen.
:::

:::::: sect2
### []{#alphanumeric .hidden-anchor .sr-only}2.1. Alphanumerische Zeichen {#heading_alphanumeric}

::: paragraph
Bei den regulären Ausdrücken geht es immer darum, ob ein Muster
(\"Pattern\", beziehungsweise der reguläre Ausdruck) auf einen
bestimmten Text (z.B. einen Service-Namen) *passt* (*matcht*). Der
einfachste Anwendungsfall sind Ketten alphanumerischer Zeichen. Diese
(und das als Bindestrich verwendete Minus-Zeichen) im Ausdruck matchen
einfach sich selbst.
:::

::: paragraph
Beim [Suchen in der
Monitoring-Umgebung](user_interface.html#search_monitor) unterscheidet
Checkmk dabei in der Regel nicht zwischen Groß- und Kleinschreibung. Der
Ausdruck `CPU load` matcht also in den meisten Fällen auf den Text
`CPU load` genauso wie auf `cpu LoAd`. Beim [Suchen in der
Konfigurationsumgebung](user_interface.html#search_setup) dagegen wird
üblicherweise zwischen Groß- und Kleinschreibung unterschieden.
Begründete Ausnahmen von diesen Standards sind möglich und werden in der
Inline-Hilfe beschrieben.
:::

::: paragraph
**Achtung:** Bei Eingabefeldern, in denen ohne reguläre Ausdrücke ein
exakter Match vorgesehen ist (meistens bei Host-Namen), wird Groß- und
Kleinschreibung immer unterschieden!
:::
::::::

:::: sect2
### []{#dotaswildcard .hidden-anchor .sr-only}2.2. Der Punkt als Wildcard {#heading_dotaswildcard}

::: paragraph
Neben den \"Klartext\"-Zeichenketten gibt es eine Reihe von Zeichen und
Zeichenfolgen, die \"magische\" Bedeutung haben. Das wichtigste
derartige Zeichen ist der `.` (Punkt). **Er matcht genau ein einziges
beliebiges Zeichen:**
:::

+------------------------------+-------------------+-------------------+
| Regulärer Ausdruck           | Match             | Kein Match        |
+==============================+===================+===================+
| `Me.er`                      | `Meier`\          | `Meyyer`          |
|                              | `Meyer`           |                   |
+------------------------------+-------------------+-------------------+
| `.var.log`                   | `1var2log`\       | `/var//log`       |
|                              | `/var/log`        |                   |
+------------------------------+-------------------+-------------------+
::::

:::::: sect2
### []{#repetition .hidden-anchor .sr-only}2.3. Wiederholungen von Zeichen {#heading_repetition}

::: paragraph
Sehr häufig möchte man definieren, dass eine Folge von Zeichen
bestimmter Länge vorkommen darf. Hierfür gibt man in geschweiften
Klammern die Zahl der Wiederholungen des vorhergehenden Zeichens an:
:::

+-----------------+------------------------+-------------+-------------+
| Regulärer       | Bedeutung              | Match       | Kein Match  |
| Ausdruck        |                        |             |             |
+=================+========================+=============+=============+
| `Ax{2,5}B`      | `x` tritt mindestens   | `AxxB`\     | `AxB`\      |
|                 | zweimal, aber          | `AxxxxB`    | `AxxxxxxB`  |
|                 | höchstens fünfmal auf  |             |             |
+-----------------+------------------------+-------------+-------------+
| `Ax{0,5}B`      | `x` tritt höchstens    | `AB`\       | `AxxxxxxB`  |
|                 | fünfmal auf, es muss   | `AxxxxxB`   |             |
|                 | aber nicht auftreten   |             |             |
+-----------------+------------------------+-------------+-------------+
| `Ax{3}B`        | `x` tritt genau        | `AxxxB`     | `AxxB`\     |
|                 | dreimal auf            |             | `AxxxxB`    |
+-----------------+------------------------+-------------+-------------+
| `Ax{0,}B`       | `x` tritt beliebig oft | `AB`\       |             |
|                 | auf                    | `AxxxxxxB`  |             |
+-----------------+------------------------+-------------+-------------+
| `Ax{1,}B`       | `x` tritt mindestens   | `AxB`\      | `AB`        |
|                 | einmal auf             | `AxxxxxB`   |             |
+-----------------+------------------------+-------------+-------------+
| `Ax{0,1}B`      | `x` tritt höchstens    | `AB`\       | `AxxB`      |
|                 | einmal auf             | `AxB`       |             |
+-----------------+------------------------+-------------+-------------+

::: paragraph
Für die letzten drei Fälle gibt es Abkürzungen: `*` matcht das
vorhergehende Zeichen **beliebig oft**, `+` matcht ein **mindestens
einmaliges Auftreten** und `?` matcht das **höchstens einmalige
Auftreten**.
:::

::: paragraph
Sie können auch den [Punkt](#dotaswildcard) `.` mit den
Wiederholungsoperatoren verknüpfen, um eine Folge beliebiger Zeichen
definierter zu suchen:
:::

+---------------------------+--------------------+--------------------+
| Regulärer Ausdruck        | Match              | Kein Match         |
+===========================+====================+====================+
| `State.*OK`               | `State is OK`\     | `StatOK`           |
|                           | `State = OK`\      |                    |
|                           | `StateOK`          |                    |
+---------------------------+--------------------+--------------------+
| `State*OK`                | `StateOK`\         | `State OK`         |
|                           | `StatOK`           |                    |
+---------------------------+--------------------+--------------------+
| `a *= *5`                 | `a=5`\             | `a==5`             |
|                           | `a = 5`            |                    |
+---------------------------+--------------------+--------------------+
| `State.+OK`               | `State is OK`\     | `StateOK`          |
|                           | `State=OK`\        |                    |
|                           | `State OK`         |                    |
+---------------------------+--------------------+--------------------+
| `State.?OK`               | `State=OK`\        | `State is OK`      |
|                           | `State OK`\        |                    |
|                           | `StateOK`          |                    |
+---------------------------+--------------------+--------------------+
::::::

:::::::: sect2
### []{#characterclasses .hidden-anchor .sr-only}2.4. Zeichenklassen, Ziffern und Buchstaben {#heading_characterclasses}

::: paragraph
Zeichenklassen erlauben es, bestimmte Ausschnitte des Zeichensatzes zu
matchen, beispielsweise „hier muss eine Ziffer kommen". Dafür setzen Sie
alle zu matchenden Zeichen innerhalb eckiger Klammern. Mit einem
Minuszeichen können Sie auch Bereiche angeben. **Hinweis:** es gilt
dabei die Reihenfolge im
[7-Bit-ASCII-Zeichensatz.](https://de.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange){target="_blank"}
:::

::: paragraph
So steht beispielsweise `[abc]` für genau eines der Zeichen **a, b oder
c** und `[0-9]` für **eine beliebige Ziffer -** beides lässt sich
kombinieren. Auch eine Negation des Ganzen ist möglich: Mit einem `^` in
der Klammer steht `[^abc]` dann für ein beliebiges Zeichen **außer a, b,
c**.
:::

::: paragraph
Zeichenklassen lassen sich natürlich mit anderen Operatoren kombinieren.
Zunächst mal einige abstrakte Beispiele:
:::

+-----------------------+----------------------------------------------+
| Zeichenklasse         | Bedeutung                                    |
+=======================+==============================================+
| `[abc]`               | Genau eines der Zeichen a, b, c.             |
+-----------------------+----------------------------------------------+
| `[0-9a-z_]`           | Genau eine Ziffer, ein Kleinbuchstabe oder   |
|                       | ein Unterstrich.                             |
+-----------------------+----------------------------------------------+
| `[^abc]`              | Jedes beliebige Zeichen außer a, b, c.       |
+-----------------------+----------------------------------------------+
| `[ --]`               | Genau ein Zeichen aus dem Bereich von        |
|                       | Leerzeichen bis Bindestrich gemäß            |
|                       | ASCII-Tabelle. In diesem Bereich befinden    |
|                       | sich die folgenden Zeichen: `!"#$%&'()*+,`   |
+-----------------------+----------------------------------------------+
| `[0-9a-z]{1,20}`      | Eine Folge von mindestens einem und maximal  |
|                       | 20 Buchstaben und/oder Ziffern in beliebiger |
|                       | Reihenfolge.                                 |
+-----------------------+----------------------------------------------+

::: paragraph
Dazu einige praktische Beispiele:
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `[0-7]`               | `0`\                 | `9`                  |
|                       | `5`                  |                      |
+-----------------------+----------------------+----------------------+
| `[0-7]{2}`            | `00`\                | `183`                |
|                       | `53`                 |                      |
+-----------------------+----------------------+----------------------+
| `M[ae]{1}[iy]{1}e?r`  | `Meier`\             | `Myers`              |
|                       | `Meyer`\             |                      |
|                       | `Mayr`               |                      |
+-----------------------+----------------------+----------------------+
| `myhost_[0-9a-z_]{3}` | `myhost_1a3`\        | `myhost_xy`          |
|                       | `myhost_1_5`         |                      |
+-----------------------+----------------------+----------------------+
| `[+0-9/ ()-]+`        | `+49 89 998209700`\  | `089 : 9982 097-00`\ |
|                       | `089 / 9982 097-00`  | (hier wird nur die   |
|                       |                      | Gruppe vor dem       |
|                       |                      | Doppelpunkt          |
|                       |                      | gematcht)            |
+-----------------------+----------------------+----------------------+

::: paragraph
**Hinweis:** Wenn Sie eines der Zeichen `-`, `[` oder `]` brauchen,
müssen Sie etwas tricksen. Das `-` (Minuszeichen) schreiben Sie ans
*Ende der Klasse* --- wie im letzten Beispiel bereits gezeigt. Beim
Auswerten der regulären Ausdrücke wird das Minuszeichen, wenn es nicht
mittleres von drei Zeichen ist, nicht als Operator, sondern als exakt
dieses Zeichen ausgewertet. Eine schließende eckige Klammer platzieren
Sie als *erstes* Zeichen in der Klasse, eine öffnende gegebenenfalls als
*zweites* Zeichen. Da keine leeren Klassen erlaubt sind, wird die
schließende eckige Klammer dann als normales Zeichen interpretiert. Eine
Klasse mit diesen Sonderzeichen sähe also so aus: `[]-]`,
beziehungsweise `[][-]` wenn auch die öffnende eckige Klammer benötigt
wird.
:::
::::::::

::::::::: sect2
### []{#prefixinfixsuffix .hidden-anchor .sr-only}2.5. Anfang und Ende --- Präfix, Suffix und Infix {#heading_prefixinfixsuffix}

::: paragraph
In vielen Fällen ist es erforderlich, zwischen Matches am Anfang, am
Ende oder einfach irgendwo innerhalb einer Zeichenkette zu
unterscheiden. Für den Match des Anfangs einer Zeichenkette
(Präfix-Match) verwenden Sie den `^` (Zirkumflex), für das Ende
(Suffix-Match) das `$` (Dollarzeichen). Ist keines der beiden Zeichen
angegeben, ist bei den meisten Bibliotheken für reguläre Ausdrücke
Infix-Match Standard --- es wird an beliebiger Stelle in der
Zeichenkette gesucht. Für exakte Matches verwenden Sie sowohl `^` als
auch `$`.
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `/var`                | `/var`\              |                      |
|                       | `/var/log`\          |                      |
|                       | `/usr/var`           |                      |
+-----------------------+----------------------+----------------------+
| `^/var`               | `/var`\              | `/usr/var`           |
|                       | `/var/log`           |                      |
+-----------------------+----------------------+----------------------+
| `/var$`               | `/var`\              | `/var/log`           |
|                       | `/usr/var`           |                      |
+-----------------------+----------------------+----------------------+
| `^/var$`              | `/var`               | `/var/log`\          |
|                       |                      | `/usr/var`           |
+-----------------------+----------------------+----------------------+

::: paragraph
**Hinweis:** Im Monitoring und der [Event Console](ec.html) ist
Infix-Match Standard. Ausdrücke, die irgendwo im Text vorkommen, werden
gefunden, d.h. die Suche nach \"memory\" findet auch \"Kernel memory\".
In der Setup-GUI dagegen prüft Checkmk beim Vergleichen von regulären
Ausdrücken mit Service-Namen und anderen Dingen grundsätzlich, ob der
Ausdruck mit dem *Anfang* des Textes übereinstimmt (Präfix-Match) -- in
der Regel ist dies, was Sie suchen:
:::

:::: imageblock
::: content
![regexes servicematch](../images/regexes_servicematch.png)
:::
::::

::: paragraph
Falls Sie an Stellen, an denen *Präfix-Match* vorgesehen ist, doch
einmal einen *Infix-Match* benötigen, erweitern Sie einfach Ihren
regulären Ausdruck am Anfang mit `.*`, um eine beliebige vorangestellte
Zeichenkette zu matchen:
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `/var`                | `/var`\              | `/usr/var`           |
|                       | `/var/log`           |                      |
+-----------------------+----------------------+----------------------+
| `.*/var`              | `/var`\              |                      |
|                       | `/usr/var`\          |                      |
|                       | `/var/log`           |                      |
+-----------------------+----------------------+----------------------+
| `/var$`               | `/var`               | `/var/log`\          |
|                       |                      | `/usr/var`           |
+-----------------------+----------------------+----------------------+

::: paragraph
**Tipp:** Sie können *jede* Suche am Anfang einer Zeichenkette mit `^`
und *jede* Suche innerhalb mit `.*` einleiten, die Interpreter für
reguläre Ausdrücke ignorieren redundante Symbole.
:::
:::::::::

::::: sect2
### []{#escaping .hidden-anchor .sr-only}2.6. Sonderzeichen mit Backslash maskieren {#heading_escaping}

::: paragraph
Da der Punkt alles matcht, matcht er natürlich auch einen Punkt. Wenn
Sie nun aber *genau* einen Punkt matchen wollen, so müssen Sie diesen
mit einem `\` (Backslash) maskieren (eingedeutscht: „escapen"). Das gilt
analog auch für alle anderen Sonderzeichen. Dies sind:
`\ . * + ? { } ( ) [ ] | & ^` und `$`. Der `\` Backslash **wertet das
nächste dieser Sonderzeichen als normales Zeichen:**
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `example\.com`        | `example.com`        | `example\.com`\      |
|                       |                      | `example-com`        |
+-----------------------+----------------------+----------------------+
| `Wie\?`               | `Wie?`               | `Wie\?`\             |
|                       |                      | `Wie`                |
+-----------------------+----------------------+----------------------+
| `C:\\Programs`        | `C:\Programs`        | `C:Programs`\        |
|                       |                      | `C:\\Programs`       |
+-----------------------+----------------------+----------------------+

::: paragraph
**Achtung Python:** Da in
[Python](https://docs.python.org/3/howto/regex.html#the-backslash-plague){target="_blank"}
der Backslash in der internen Zeichenkettendarstellung intern mit einem
weiteren Backslash maskiert wird, müssen diese beiden Backslashes
wiederum maskiert werden, was zu insgesamt vier Backslashes führt:
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `C:\\\\Programs`      | `C:\Programs`        | `C:Programs`\        |
|                       |                      | `C:\\Programs`       |
+-----------------------+----------------------+----------------------+
:::::

:::: sect2
### []{#alternatives .hidden-anchor .sr-only}2.7. Alternativen {#heading_alternatives}

::: paragraph
Mit dem senkrechten Strich `|` können Sie *Alternativen* definieren,
sprich eine ODER-Verknüpfung verwenden: `1|2|3` matcht also 1, 2 oder 3.
Wenn Sie die Alternativen inmitten eines Ausdrucks benötigen, gruppieren
Sie diese innerhalb runder Klammern.
:::

+-----------------------+----------------------+----------------------+
| Regulärer Ausdruck    | Match                | Kein Match           |
+=======================+======================+======================+
| `CP                   | `CPU load`\          | `CPU utilization`    |
| U load|Kernel|Memory` | `Kernel`             |                      |
+-----------------------+----------------------+----------------------+
| `01|02|1[1-5]`        | `01`\                | `05`                 |
|                       | `02`\                |                      |
|                       | `11` bis `15`        |                      |
+-----------------------+----------------------+----------------------+
::::

:::::::::: sect2
### []{#matchgroups .hidden-anchor .sr-only}2.8. Match-Gruppen {#heading_matchgroups}

::: paragraph
Match-Gruppen (englisch *match groups* oder *capture groups*) erfüllen
zwei Zwecke: Der erste ist --- wie im letzten Beispiel gezeigt --- die
Gruppierung von Alternativen oder Teil-Matches. Dabei sind auch
verschachtelte Gruppierungen möglich. Zudem ist es zulässig, hinter
runden Klammern die Wiederholungsoperatoren `*`, `+`, `?` und `{`...​`}`
zu verwenden. So passt der Ausdruck `(/local)?/share` sowohl auf
`/local/share` als auch auf `/share`.
:::

::: paragraph
Der zweite Zweck ist das \"Einfangen\" gematchter Zeichengruppen in
Variablen. In der [Event Console (EC)](ec.html), [Business Intelligence
(BI)](bi.html), beim [Massenumbenennen von
Hosts](hosts_setup.html#rename) und bei
[Piggyback-Zuordnungen](piggyback.html) besteht die Möglichkeit, den
Textteil der dem regulären Ausdruck in der ersten Klammer entspricht,
als `\1` zu verwenden, den der zweiten Klammer entsprechenden als `\2`
usw. Das letzte Beispiel der Tabelle zeigt die Verwendung von
[Alternativen](#alternatives) innerhalb einer Match-Gruppe.
:::

+-----------------------+--------------+--------------+--------------+
| Regulärer Ausdruck    | Zu           | Gruppe 1     | Gruppe 2     |
|                       | matchender   |              |              |
|                       | Text         |              |              |
+=======================+==============+==============+==============+
| `([a-z]+)([123]+)`    | `def231`     | `def`        | `231`        |
+-----------------------+--------------+--------------+--------------+
| `server-(.*)\.local`  | `server-     | `lnx02`      |              |
|                       | lnx02.local` |              |              |
+-----------------------+--------------+--------------+--------------+
| `server\.(            | `ser         | `dmz`        |              |
| intern|dmz|123)\.net` | ver.dmz.net` |              |              |
+-----------------------+--------------+--------------+--------------+

::: paragraph
Folgende Abbildung zeigt eine solche Umbenennung mehrerer Hosts. Alle
Host-Namen, die auf den regulären Ausdruck `server-(.*)\.local` passen,
werden durch `\1.servers.local` ersetzt. Dabei steht das `\1` genau für
den Text, der mit dem `.*` in der Klammer \"eingefangen\" wurde:
:::

:::: imageblock
::: content
![bulk renaming regex](../images/bulk_renaming_regex.png)
:::
::::

::: paragraph
Im konkreten Fall wird also `server-lnx02.local` in
`lnx02.servers.local` umbenannt.
:::

::: paragraph
Soll eine Match-Gruppe keine Zeichengruppen „einfangen", beispielsweise
wenn sie nur zur Strukturierung dient, kann mit `?:` die Umwandlung in
eine nicht einfangende Match-Gruppe (*non-capturing match group*)
erfolgen: `(?:/local)?/share`.
:::
::::::::::

::::::: sect2
### []{#inlineflags .hidden-anchor .sr-only}2.9. Inline Flags {#heading_inlineflags}

::: paragraph
Mit *Inline Flags* können bestimmte, den Modus der Auswertung
betreffende Einstellungen innerhalb eines regulären Ausdrucks
vorgenommen werden. Für die Arbeit mit Checkmk relevant ist vor allem
`(?i)`, welches bei Ausdrücken, die sonst mit Groß- und Kleinschreibung
ausgewertet werden, auf ein Matching umschaltet, das Groß- und
Kleinschreibung nicht berücksichtigt (*case-insensitive*). In sehr
seltenen Fällen werden Sie für die Arbeit mit mehrzeiligen Strings auch
[`(?s)` und
`(?m)`](https://www.regular-expressions.info/modifiers.html){target="_blank"}
benutzen wollen.
:::

::: paragraph
Beachten Sie, dass Python seit Version 3.11 Inline Flags entweder am
Anfang eines regulären Ausdruckes --- `(?i)somestring` --- oder unter
Angabe des Geltungsbereiches --- `(?i:somestring)` --- erwartet. Da
Checkmk in einigen Fällen aus Gründen besserer Performance reguläre
Ausdrücke intern kombiniert, raten wir dringend, Inline Flags *nicht* am
Anfang eines regulären Ausdruckes zu benutzen. Verwenden Sie stattdessen
*immer* die Schreibweise mit Geltungsbereich -- der sich im Zweifel auf
den gesamten regulären Ausdruck erstreckt:
:::

::: paragraph
`(?i:somestring)`
:::

::: paragraph
Hierbei handelt es sich um eine Variante der nicht einfangenden
[Match-Gruppe.](#matchgroups)
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

::::::::: sect1
## []{#characters .hidden-anchor .sr-only}3. Tabelle der Sonderzeichen {#heading_characters}

:::::::: sectionbody
::: paragraph
Hier finden Sie zusammengefasst die Liste von allen oben erklärten
Sonderzeichen und Funktionen der regulären Ausdrücke, die Checkmk
verwendet:
:::

+---------+------------------------------------------------------------+
| `.`     | Passt auf *ein* [beliebiges Zeichen](#dotaswildcard).      |
+---------+------------------------------------------------------------+
| `\`     | Wertet das nächste [Sonderzeichen als normales             |
|         | Zeichen](#escaping).                                       |
+---------+------------------------------------------------------------+
| `{5}`   | Das vorherige Zeichen muss genau [fünfmal                  |
|         | vorkommen](#repetition).                                   |
+---------+------------------------------------------------------------+
| `       | Das vorherige Zeichen muss mindestens fünf- und höchstens  |
| {5,10}` | zehnmal vorkommen.                                         |
+---------+------------------------------------------------------------+
| `*`     | Das vorherige Zeichen darf beliebig oft vorkommen          |
|         | (entspricht `{0,}`).                                       |
+---------+------------------------------------------------------------+
| `+`     | Das vorherige Zeichen darf beliebig oft, aber muss         |
|         | mindestens einmal vorkommen (entspricht `{1,}`).           |
+---------+------------------------------------------------------------+
| `?`     | Das vorherige Zeichen darf null- oder einmal vorkommen     |
|         | (entspricht `{0,1}`).                                      |
+---------+------------------------------------------------------------+
| `[abc]` | Steht für genau [eines der Zeichen](#characterclasses)     |
|         | `a`, `b` oder `c`.                                         |
+---------+------------------------------------------------------------+
| `[0-9]` | Steht für genau eines der Zeichen `0`, `1` ...​ `9` (also   |
|         | eine Ziffer).                                              |
+---------+------------------------------------------------------------+
| `[0-    | Steht für genau eine Ziffer, einen Kleinbuchstaben oder    |
| 9a-z_]` | den Unterstrich.                                           |
+---------+------------------------------------------------------------+
| `[^"']` | Steht für genau ein beliebiges Zeichen *außer* dem         |
|         | einfachen oder doppelten Anführungszeichen.                |
+---------+------------------------------------------------------------+
| `$`     | Matcht das [*Ende* eines Textes](#prefixinfixsuffix).      |
+---------+------------------------------------------------------------+
| `^`     | Matcht den *Anfang* eines Textes.                          |
+---------+------------------------------------------------------------+
| `A|B|C` | Matcht auf [`A` oder auf `B` oder auf                      |
|         | `C_`](#alternatives).                                      |
+---------+------------------------------------------------------------+
| `(`*    | Fasst den Unterausdruck *A* zu einer                       |
| `A`*`)` | [Match-Gruppe](#matchgroups) zusammen.                     |
+---------+------------------------------------------------------------+
| `(?i:`* | Ändert den Auswertungsmodus des Unterausdrucks *A* per     |
| `A`*`)` | [Inline Flag](#inlineflags) auf *case-insensitive.*        |
+---------+------------------------------------------------------------+
| `\t`    | Matcht einen Tabstopp (Tabulator). Dieses Zeichen kommt    |
|         | oft in Log-Dateien oder CSV-Tabellen vor                   |
+---------+------------------------------------------------------------+
| `\s`    | Matcht alle Leerzeichen (ASCII kennt 5 verschiedene).      |
+---------+------------------------------------------------------------+

::: paragraph
Folgende Zeichen müssen durch [Backslash maskiert werden](#escaping),
wenn sie wörtlich verwendet werden sollen:
`\ . * + ? { } ( ) [ ] | & ^ $`.
:::

::::: sect2
### []{#_unicode_in_python_3 .hidden-anchor .sr-only}3.1. Unicode in Python 3 {#heading__unicode_in_python_3}

::: paragraph
Insbesondere, wenn Eigennamen in Kommentaren oder beschreibenden Texten
per Copy und Paste übernommen wurde und daher Unicode-Zeichen oder
verschiedene Typen von Leerzeichen im Text auftreten, sind Pythons
erweiterte Klassen sehr hilfreich:
:::

+---------+------------------------------------------------------------+
| `\t`    | Matcht einen Tabstopp (Tabulator), teils in Logdateien     |
|         | oder CSV-Tabellen.                                         |
+---------+------------------------------------------------------------+
| `\s`    | Matcht alle Leerzeichen (Unicode kennt 25 verschiedene,    |
|         | ASCII 5).                                                  |
+---------+------------------------------------------------------------+
| `\S`    | Invertierung von `\s`, d.h. matcht alle Zeichen, die keine |
|         | Leerzeichen sind.                                          |
+---------+------------------------------------------------------------+
| `\w`    | Matcht alle Zeichen, die Wortbestandteil sind, also        |
|         | Buchstaben, in Unicode aber auch Akzente, chinesische,     |
|         | arabische oder koreanische Glyphen.\                       |
|         | **Achtung:** Ziffern zählen hier zu den Wortbestandteilen. |
+---------+------------------------------------------------------------+
| `\W`    | Invertierung von `\w`, d.h. matcht alles, was              |
|         | typischerweise kein Wortbestandteil ist (Leerzeichen,      |
|         | Satzzeichen, Emoticons, mathematische Sonderzeichen).      |
+---------+------------------------------------------------------------+

::: paragraph
An Stellen, an denen Checkmk Unicode-Matching erlaubt, ist `\w` vor
allem zur Suche nach ähnlich geschriebenen Worten in verschiedenen
Sprachen hilfreich, beispielsweise Eigennamen, die mal mit und mal ohne
Accent geschrieben werden:
:::

+--------------------+------------------------+------------------------+
| Regular Expression | Match                  | Kein Match             |
+====================+========================+========================+
| `\                 | `Schnitzel` (Deutsch)\ | `šnicl` (Kroatisch)\   |
| w{1,3}ni\w{1,2}el` | `șnițel` (Rumänisch)   | `Schnit'el` (mit       |
|                    |                        | Auslassungszeichen)    |
+--------------------+------------------------+------------------------+
:::::
::::::::
:::::::::

::::::::::::::::: sect1
## []{#testing .hidden-anchor .sr-only}4. Test regulärer Ausdrücke {#heading_testing}

:::::::::::::::: sectionbody
::: paragraph
Die Logik regulärer Ausdrücke ist nicht immer einfach zu durchschauen,
insbesondere bei verschachtelten Match-Gruppen oder der Frage in welcher
Reihenfolge von welchem Ende des zu matchenden Strings ausgewertet wird.
Besser als Trial and Error in Checkmk sind diese zwei Möglichkeiten zum
Test regulärer Ausdrücke: Online-Dienste wie
[regex101.com](https://regex101.com/){target="_blank"} bereiten Matches
grafisch auf und erklären darüber die Reihenfolge der Auswertung in
Echtzeit:
:::

:::: imageblock
::: content
![regexes testing](../images/regexes_testing.png)
:::
::::

::: paragraph
Die zweite Testmöglichkeit ist der Python-Prompt, den jede
Python-Installation mitbringt. Unter Linux und auf dem Mac ist Python 3
in der Regel vorinstalliert. Gerade weil reguläre Ausdrücke am
Python-Prompt exakt wie in Checkmk ausgewertet werden, gibt es auch bei
komplexen Schachtelungen keine Abweichungen bei der Interpretation. Mit
dem Test im Python-Interpreter sind Sie damit immer auf der sicheren
Seite.
:::

::: paragraph
Nach dem Öffnen müssen Sie das Modul `re` importieren. Im Beispiel
schalten wir zudem mit `re.IGNORECASE` die Unterscheidung zwischen Groß-
und Kleinschreibung ab:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ python3
Python 3.8.10 (default, Jun  2 2021, 10:49:15)
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import re
>>> re.IGNORECASE
re.IGNORECASE
```
:::
::::

::: paragraph
Um das Verhalten der regulären Ausdrücke von C nachzubilden, das auch in
vielen Python-Komponenten genutzt wird, schränken Sie auf ASCII ein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
>>> re.ASCII
re.ASCII
```
:::
::::

::: paragraph
Nun können Sie mit der Funktion `re.match()` direkt einen regulären
Ausdruck gegen einen String matchen und die [Match-Gruppe](#matchgroups)
ausgeben, `group(0)` steht hierbei für den gesamten Match, mit
`group(1)` wird der Match ausgegeben, der zum ersten in einer runden
Klammer gruppierten Unterausdruck passt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
>>> x = re.match('M[ae]{1}[iy]{1}e?r', 'Meier')
>>> x.group(0)
'Meier'
>>> x = re.match('M[ae]{1}[iy]{1}e?r', 'Mayr')
>>> x.group(0)
'Mayr'
>>> x = re.match('M[ae]{1}[iy]{1}e?r', 'Myers')
>>> x.group(0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: no such group
>>> x = re.match('server-(.*)\.local', 'server-lnx23.local')
>>> x.group(0)
'server-lnx23.local'
>>> x.group(1)
'lnx23'
```
:::
::::
::::::::::::::::
:::::::::::::::::

::::::::::::: sect1
## []{#reference .hidden-anchor .sr-only}5. Weitere externe Dokumentation {#heading_reference}

:::::::::::: sectionbody
::: paragraph
Ken Thompson, einer der Erfinder von UNIX, hat schon in den 1960ern als
erster reguläre Ausdrücke in der heutigen Form entwickelt --- unter
anderem im bis heute gebräuchlichen Unix-Befehl `grep`. Seitdem wurden
zahlreiche Erweiterungen und Dialekte von regulären Ausdrücken
geschaffen --- darunter erweiterter Regexe, Perl-kompatible Regexe und
auch eine sehr ähnlich Variante in Python.
:::

::: paragraph
Checkmk verwendet in den [Filtern in Ansichten](views.html#filter)
*POSIX erweiterte reguläre Ausdrücke* (extended REs). Diese werden im
Monitoring-Kern in C mit der Regex-Funktion der C-Bibliothek
ausgewertet. Sie finden eine komplette Referenz dazu in der Linux Man
Page zu `regex(7)`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ man 7 regex

REGEX(7)                   Linux Programmer's Manual                   REGEX(7)

NAME
       regex - POSIX.2 regular expressions

DESCRIPTION
       Regular  expressions  ("RE"s), as defined in POSIX.2, come in two forMFS:
       modern REs (roughly those of egrep; POSIX.2 calls these "extended"  REs)
       and  obsolete  REs (roughly those of *ed*(1); POSIX.2 "basic" REs).  Obso-
       lete REs mostly exist for backward compatibility in some  old  programs;
```
:::
::::

::: paragraph
An allen anderen Stellen stehen darüber hinaus alle Möglichkeiten der
regulären Ausdrücke von Python zur Verfügung. Dies betrifft unter
anderem die [Konfigurationsregeln](wato_rules.html), [Event Console
(EC)](ec.html) und [Business Intelligence (BI)](bi.html).
:::

::: paragraph
Die regulären Ausdrücke in Python sind eine Erweiterung der extended REs
und sehr ähnlich zu denen aus Perl. Sie unterstützen z.B. den
sogenannten *negative Lookahead*, einen nicht gierigen `*` Stern, oder
ein Erzwingen der Unterscheidung von Groß-/Kleinschreibung. Die genauen
Möglichkeiten dieser regulären Ausdrücke finden Sie in der Online-Hilfe
von Python zum Modul `re`, oder ausführlicher in der
[Online-Dokumentation von
Python.](https://docs.python.org/3/library/re.html){target="_blank"}
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ pydoc3 re
Help on module re:

NAME
    re - Support for regular expressions (RE).

MODULE REFERENCE
    https://docs.python.org/3.8/library/re

    The following documentation is automatically generated from the Python
    source files.  It may be incomplete, incorrect or include features that
    are considered implementation detail and may vary between Python
    implementations.  When in doubt, consult the module reference at the
    location listed above.

DESCRIPTION
    This module provides regular expression matching operations similar to
    those found in Perl.  It supports both 8-bit and Unicode strings; both
    the pattern and the strings being processed can contain null bytes and
    characters outside the US ASCII range.

    Regular expressions can contain both special and ordinary characters.
    Most ordinary characters, like "A", "a", or "0", are the simplest
    regular expressions; they simply match themselves.  You can
    concatenate ordinary characters, so last matches the string 'last'.
```
:::
::::

::: paragraph
Eine sehr ausführliche Erklärung zu regulären Ausdrücken finden Sie in
[Wikipedia.](https://de.wikipedia.org/wiki/Regul%C3%A4rer_Ausdruck){target="_blank"}
:::
::::::::::::
:::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
