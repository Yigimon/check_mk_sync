:::: {#header}
# Best Practices, Tipps & Tricks

::: details
[Last modified on 18-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_bestpractise.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
:::::::::::: sect1
## []{#cpu_single_core .hidden-anchor .sr-only}1. CPU-Auslastung aller Kerne einzeln überwachen {#heading_cpu_single_core}

::::::::::: sectionbody
::: paragraph
Checkmk richtet sowohl unter Linux als auch unter Windows automatisch
einen Service ein, der die durchschnittliche CPU-Auslastung der letzten
Minute ermittelt. Dies ist einerseits sinnvoll, erkennt aber
andererseits einige Fehler nicht, beispielsweise den, dass ein einzelner
Prozess Amok läuft und permanent **eine** CPU mit 100 % belastet. Bei
einem System mit 16 CPUs trägt eine CPU aber nur mit 6,25 % zur
Gesamtleistung bei, und so wird selbst im geschilderten Extremfall nur
eine Auslastung von 6,25 % gemessen --- was dann nicht zu einer
Benachrichtigung führt.
:::

::: paragraph
Deswegen bietet Checkmk die Möglichkeit (für Linux und für Windows),
alle vorhandenen CPUs einzeln zu überwachen und festzustellen, ob einer
der Kerne über längere Zeit permanent ausgelastet ist. Diesen Check
einzurichten hat sich als gute Idee herausgestellt.
:::

::: paragraph
Um diese Überprüfung für Ihre Windows-Server einzurichten, benötigen Sie
für den Service [CPU utilization]{.guihint} den Regelsatz [CPU
utilization for simple devices]{.guihint}, den Sie unter den [Service
monitoring rules]{.guihint} finden. Dieser Regelsatz ist für die
Überwachung **aller** CPUs zuständig --- hat aber auch diese Option im
Angebot: [Levels over an extended time period on a single core CPU
utilization.]{.guihint}
:::

::: paragraph
Erstellen Sie eine neue Regel und aktivieren Sie darin nur diese Option:
:::

:::: imageblock
::: content
![Dialog, um die Überwachung der CPU-Auslastung einzelner Kerne eines
Windows-Servers festzulegen.](../images/intro_cpu_single_core.png)
:::
::::

::: paragraph
Definieren Sie die Bedingung so, dass sie nur für die Windows-Server
greift, z.B. durch einen geeigneten Ordner oder ein Host-Merkmal. Diese
Regel wird andere Regeln des gleichen Regelsatzes nicht beeinflussen,
wenn diese andere Optionen festlegen, z.B. die Schwellwerte für die
Gesamtauslastung.
:::

::: paragraph
Bei Linux-Servern ist dafür der Regelsatz [CPU utilization on
Linux/UNIX]{.guihint} zuständig, in dem Sie die gleiche Option setzen
können.
:::
:::::::::::
::::::::::::

:::::::::::::::::: sect1
## []{#windows_services .hidden-anchor .sr-only}2. Windows-Dienste überwachen {#heading_windows_services}

::::::::::::::::: sectionbody
::: paragraph
In der Voreinstellung überwacht Checkmk auf Ihren Windows-Servern keine
Dienste. Warum nicht? Nun, weil Checkmk nicht weiß, welche Dienste für
Sie wichtig sind.
:::

::: paragraph
Wenn Sie sich nicht die Mühe machen wollen, für jeden Server von Hand
festzulegen, welche Dienste dort wichtig sind, können Sie auch einen
Check einrichten, der einfach überprüft, ob alle Dienste mit der
Startart „automatisch" auch wirklich laufen. Zusätzlich können Sie sich
informieren lassen, ob Dienste laufen, die manuell --- quasi außer der
Reihe --- gestartet wurden. Diese werden nach einem Reboot nicht mehr
laufen, was ein Problem sein kann.
:::

::: paragraph
Um dies umzusetzen, benötigen Sie zunächst den Regelsatz [Windows
Services]{.guihint}, den Sie unter den [Service monitoring
rules]{.guihint} finden, z.B. über die Suchfunktion [Setup \> General \>
Rule search]{.guihint}. Die entscheidende Option in der neuen Regel
lautet [Services states.]{.guihint} Aktivieren Sie diesen und fügen Sie
drei neue Elemente für die Zustände der Dienste hinzu:
:::

:::: imageblock
::: content
![Dialog, um die zu überwachenden Windows-Server-Dienste in Abhängigkeit
ihres Zustands festzulegen.](../images/intro_windows_services_rule.png)
:::
::::

::: paragraph
Dadurch erreichen Sie folgende Überwachung:
:::

::: ulist
- Ein Dienst mit der Startart [auto]{.guihint}, der läuft, gilt als
  [OK]{.state0}.

- Ein Dienst mit der Startart [auto]{.guihint}, der nicht läuft, gilt
  als [CRIT]{.state2}.

- Ein Dienst mit der Startart [demand]{.guihint}, der läuft, gilt als
  [WARN]{.state1}.
:::

::: paragraph
Diese Regel gilt allerdings nur für Dienste, die auch wirklich überwacht
werden. Daher benötigen wir noch einen zweiten Schritt und eine zweite
Regel, diesmal aus dem Regelsatz [Windows service discovery]{.guihint},
mit der Sie festlegen, welche Windows-Dienste Checkmk als Services
überwachen soll.
:::

::: paragraph
Wenn Sie diese Regel anlegen, können Sie zunächst bei der Option
[Services (Regular Expressions)]{.guihint} den regulären Ausdruck `.*`
eingeben, der auf alle Services zutrifft.
:::

::: paragraph
Nach dem Sichern der Regel wechseln Sie für einen passenden Host in die
Service-Konfiguration. Dort werden Sie eine große Zahl von neuen
Services finden --- für jeden Windows-Dienst einen.
:::

::: paragraph
Um die Anzahl der überwachten Services auf die für Sie interessanten
einzuschränken, kehren Sie zu der Regel zurück und verfeinern die
Suchausdrücke nach Bedarf. Dabei wird Groß- und Kleinschreibung
unterschieden. Hier ist ein Beispiel für eine angepasste
Service-Auswahl:
:::

:::: imageblock
::: content
![Dialog, um die Namen der zu überwachenden Windows-Dienste
festzulegen.](../images/intro_windows_service_discovery.png)
:::
::::

::: paragraph
Sollten Sie Services, die den neuen Suchausdrücken nicht entsprechen,
zuvor schon in die Überwachung aufgenommen haben, erscheinen diese jetzt
in der Service-Konfiguration als fehlend. Mit dem Knopf
[Rescan]{.guihint} können Sie reinen Tisch machen und die ganze
Service-Liste neu erstellen lassen.
:::
:::::::::::::::::
::::::::::::::::::

::::::::::: sect1
## []{#internet .hidden-anchor .sr-only}3. Internetverbindung überwachen {#heading_internet}

:::::::::: sectionbody
::: paragraph
Der Zugang Ihrer Firma zum Internet ist sicherlich für alle sehr
wichtig. Die Überwachung der Verbindung zu „dem Internet" ist dabei
etwas schwierig umzusetzen, da es um Milliarden von Rechnern geht, die
(hoffentlich) erreichbar sind --- oder eben nicht. Sie können aber
trotzdem effizient eine Überwachung einrichten, nach folgendem Bauplan:
:::

::: {.olist .arabic}
1.  Wählen Sie mehrere Rechner im Internet, die normalerweise per
    `ping`-Kommando erreichbar sein sollten, und notieren Sie deren
    IP-Adressen.

2.  Legen Sie in Checkmk einen neuen Host an, etwa mit dem Namen
    `internet` und konfigurieren diesen wie folgt: Als [IPv4
    address]{.guihint} geben Sie eine der notierten IP-Adressen ein.
    Unter [Additional IPv4 addresses]{.guihint} tragen Sie die
    restlichen IP-Adressen ein. Aktivieren Sie unter [Monitoring
    agents]{.guihint} die Option [Checkmk agent / API
    integrations]{.guihint} und wählen dort [No API integrations, no
    Checkmk agent]{.guihint} aus. Speichern Sie den Host ohne
    Service-Erkennung.

3.  Erstellen Sie eine neue Regel aus dem Regelsatz [Check hosts with
    PING (ICMP Echo Request)]{.guihint}, die nur für den neuen Host
    `internet` greift (z.B. über die Bedingung mit [Explicit
    hosts]{.guihint} oder einem passenden Host-Merkmal). Konfigurieren
    Sie die Regel wie folgt: Aktivieren Sie [Service
    Description]{.guihint} und geben Sie `Internet connection` ein.
    Aktivieren Sie [Alternative address to ping]{.guihint} und wählen
    Sie dort [Ping all IPv4 addresses]{.guihint} aus. Aktivieren Sie
    [Number of positive responses required for OK state]{.guihint} und
    tragen Sie `1` ein.

4.  Erstellen Sie eine weitere Regel, die ebenfalls nur für den Host
    `internet` gilt, diesmal aus dem Regelsatz [Host Check
    Command]{.guihint}. Wählen Sie dort als [Host Check
    Command]{.guihint} die Option [Use the status of the
    service...​]{.guihint} und tragen Sie als Namen `Internet connection`
    ein, den Sie im vorherigen Schritt als Service-Namen gewählt haben.
:::

::: paragraph
Wenn Sie jetzt die Änderungen aktivieren, erhalten Sie im Monitoring den
neuen Host `internet` mit dem einzigen Service `Internet connection`.
:::

::: paragraph
Wenn mindestens eines der Ping-Ziele erreichbar ist, hat der Host den
Status [UP]{.hstate0} und der Service den Status [OK]{.state0}.
Gleichzeitig erhalten Sie beim Service für jede der eingetragenen
IP-Adressen Messdaten für die durchschnittliche Paketumlaufzeit (*round
trip average*) und den Paketverlust. Damit erhalten Sie einen
Anhaltspunkt für die Qualität Ihrer Verbindung im Laufe der Zeit:
:::

:::: imageblock
::: content
![Listeneintrag eines Services zur Überwachung der Internetverbindung zu
mehreren IP-Adressen.](../images/intro_service_internet.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Der letzte und vierte Schritt in  |
|                                   | obiger Prozedur ist notwendig,    |
|                                   | damit der Host nicht den Zustand  |
|                                   | [DOWN]{.hstate1} erhält, falls    |
|                                   | die erste IP-Adresse nicht per    |
|                                   | `ping` erreichbar ist.            |
|                                   | Stattdessen übernimmt der Host    |
|                                   | den Status seines einzigen        |
|                                   | Services.\                        |
|                                   | Da ein Service grundsätzlich      |
|                                   | nicht benachrichtigt, wenn sein   |
|                                   | Host [DOWN]{.hstate1} ist, ist es |
|                                   | wichtig, dass Sie die             |
|                                   | Benachrichtigungen über den Host  |
|                                   | steuern --- und nicht über den    |
|                                   | Service. Außerdem sollten Sie in  |
|                                   | diesem speziellen Fall einen      |
|                                   | Benachrichtigungsweg verwenden,   |
|                                   | der keine Internetverbindung      |
|                                   | voraussetzt.                      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::::
:::::::::::

:::::::::::: sect1
## []{#http .hidden-anchor .sr-only}4. HTTP/HTTPS-Dienste überwachen {#heading_http}

::::::::::: sectionbody
::: paragraph
Nehmen wir an, Sie wollen die Erreichbarkeit einer Website oder eines
Webdienstes prüfen. Der
[Checkmk-Agent](wato_monitoringagents.html#agents) bietet hier keine
Lösung, da er diese Information nicht anzeigt --- und außerdem haben Sie
vielleicht gar nicht die Möglichkeit, den Agenten auf dem Server zu
installieren.
:::

::: paragraph
Die Lösung ist ein sogenannter [aktiver
Check.](glossar.html#active_check) Das ist einer, der nicht per Agent
durchgeführt wird, sondern direkt durch das Kontaktieren eines
Netzwerkprotokolls beim Ziel-Host --- in diesem Fall HTTP(S).
:::

::: paragraph
Das Vorgehen ist wie folgt:
:::

::: {.olist .arabic}
1.  Legen Sie einen neuen Host für den Webserver an, z.B. für
    `checkmk.com`. Aktivieren Sie unter [Monitoring agents]{.guihint}
    die Option [Checkmk agent / API integrations]{.guihint} und wählen
    dort [No API integrations, no Checkmk agent]{.guihint} aus.
    Speichern Sie den Host ohne Service-Erkennung.

2.  Erstellen Sie eine neue Regel aus dem Regelsatz [Check HTTP web
    service,]{.guihint} die nur für den neuen Host greift (z.B. über die
    Bedingung [Explicit hosts]{.guihint}).

3.  Im Kasten [Value]{.guihint} finden Sie zahlreiche Optionen zur
    Durchführung des Checks. Das Prinzip dabei ist: Für jede zu
    überprüfende URL definieren Sie einen neuen Endpunkt. Pro Endpunkt
    wird ein Service erzeugt. Den Service-Namen (z. B.
    `Basic webserver health`) und gegebenenfalls einen Präfix (`HTTP`
    oder `HTTPS`) legen Sie beim Endpunkt fest.

4.  Ebenfalls im Kasten [Value]{.guihint}, unterhalb der Endpunkte,
    können Sie zusätzliche Einstellungen vornehmen. So können Sie per
    [Response time]{.guihint} den Service auf [WARN]{.state1} oder
    [CRIT]{.state2} setzen lassen, wenn die Antwortzeit zu langsam ist
    und mit [Certificate validity]{.guihint} die Gültigkeitsdauer des
    Zertifikats überprüfen. Mit [Search for strings]{.guihint} können
    Sie prüfen lassen, ob in der Antwort --- also in der gelieferten
    Seite --- ein bestimmter Text vorkommt. Damit können Sie einen
    relevanten Teil des Inhalts prüfen, damit nicht eine simple
    Fehlermeldung des Servers als positive Antwort gewertet wird.

    ::: paragraph
    Diese Einstellungen können Sie identisch für alle Endpunkte
    festlegen oder für jeden Endpunkt individuell.
    :::

    ::: {.admonitionblock .tip}
    +-----------------------------------+-----------------------------------+
    | ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
    |                                   | Für alle verfügbaren Optionen     |
    |                                   | finden Sie in der                 |
    |                                   | [Inline-Hilfe]                    |
    |                                   | (user_interface.html#inline_help) |
    |                                   | sehr nützliche Informationen.     |
    |                                   | :::                               |
    +-----------------------------------+-----------------------------------+
    :::

5.  Speichern Sie die Regel und aktivieren Sie die Änderungen.
:::

::: paragraph
Sie bekommen jetzt einen neuen Host mit den von Ihnen festgelegten
Services, die den Zugriff per HTTP(S) prüfen:
:::

:::: imageblock
::: content
![Listeneintrag der Services zur Überwachung der HTTP/HTTPS-Dienste auf
einem Host.](../images/intro_check_httpv2_services.png)
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Sie können diesen Check natürlich |
|                                   | auch auf einem Host durchführen,  |
|                                   | der bereits mit Checkmk per Agent |
|                                   | überwacht wird. In diesem Fall    |
|                                   | entfällt das Anlegen des Hosts    |
|                                   | und Sie müssen nur die Regel für  |
|                                   | den Host erstellen.               |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::
::::::::::::

::::::::::::::::::: sect1
## []{#magic_factor .hidden-anchor .sr-only}5. Dateisystem-Schwellwerte magisch anpassen {#heading_magic_factor}

:::::::::::::::::: sectionbody
::: paragraph
Gute Schwellwerte für die Überwachung von Dateisystemen zu finden, kann
mühsam sein. Denn eine Schwelle von 90 % ist bei einer sehr großen
Festplatte viel zu niedrig und bei einer kleinen vielleicht schon zu
knapp. Wir hatten bereits im [Kapitel über die Feinjustierung des
Monitoring](intro_finetune.html#filesystems) die Möglichkeit
vorgestellt, Schwellwerte in Abhängigkeit von der Dateisystemgröße
festzulegen --- und angedeutet, dass Checkmk eine weitere, noch
schlauere Option im Angebot hat: den **Magic Factor.**
:::

::: paragraph
Den Magic Factor richten Sie so ein:
:::

::: {.olist .arabic}
1.  Im Regelsatz [Filesystems (used space and growth)]{.guihint} legen
    Sie nur eine einzige Regel an.

2.  In dieser Regel aktivieren Sie [Levels for used/free
    space]{.guihint} und lassen den Standard der Schwellwerte 80 % bzw.
    90 % unverändert.

3.  Zusätzlich aktivieren Sie [Magic factor (automatic level adaptation
    for large filesystems)]{.guihint} und akzeptieren den Standardwert
    von 0.80.

4.  Setzen Sie ferner [Reference size for magic factor]{.guihint} auf
    20 GB. Da 20 GB der Standardwert ist, wird er wirksam, auch ohne
    dass Sie die Option explizit aktivieren.
:::

::: paragraph
Das Ergebnis sieht dann so aus:
:::

:::: imageblock
::: content
![Dialog zur Festlegung des Magic Factors für
Dateisystem-Schwellwerte.](../images/intro_magic_factor.png)
:::
::::

::: paragraph
Wenn Sie jetzt die Regel sichern und die Änderung aktivieren, erhalten
Sie Schwellwerte, die automatisch von der Größe des Dateisystems
abhängen:
:::

::: {.olist .arabic}
1.  Dateisysteme, die genau 20 GB groß sind, erhalten die Schwellwerte
    80 % / 90 %.

2.  Dateisysteme, die kleiner als 20 GB sind, erhalten niedrigere
    Schwellwerte.

3.  Dateisysteme, die größer als 20 GB sind, erhalten höhere
    Schwellwerte.
:::

::: paragraph
Wie hoch die Schwellwerte genau sind ist --- nun ja --- magisch! Über
den Faktor (hier 0.80) bestimmen Sie, wie stark die Werte verbogen
werden. Ein Faktor von 1.0 ändert gar nichts, und alle Dateisysteme
bekommen die gleichen Werte. Kleinere Werte verbiegen die Schwellwerte
stärker. Die in diesem Kapitel angewendeten Standardwerte von Checkmk
haben sich in der Praxis bei sehr vielen Installationen bewährt.
:::

::: paragraph
Welche Schwellen genau gelten, können Sie bei jedem Service in seiner
Zusammenfassung ([Summary]{.guihint}) sehen:
:::

:::: imageblock
::: content
![Liste mit zwei Dateisystem-Services und ihren
Schwellwerten.](../images/intro_magic_factor_services.png)
:::
::::

::: paragraph
Die folgende Tabelle zeigt einige Beispiele für die Auswirkung des Magic
Factor bei einer Referenz von 20 GB / 80 %:
:::

+---------+-------+-------+-------+-------+-------+-------+-------+
| Magic   | 5 GB  | 10 GB | 20 GB | 50 GB | 1     | 3     | 8     |
| Factor  |       |       |       |       | 00 GB | 00 GB | 00 GB |
+=========+=======+=======+=======+=======+=======+=======+=======+
| **1.0** | **8   | **8   | **8   | **8   | **8   | **8   | **8   |
|         | 0 %** | 0 %** | 0 %** | 0 %** | 0 %** | 0 %** | 0 %** |
+---------+-------+-------+-------+-------+-------+-------+-------+
| **0.9** | 77 %  | 79 %  | **8   | 82 %  | 83 %  | 85 %  | 86 %  |
|         |       |       | 0 %** |       |       |       |       |
+---------+-------+-------+-------+-------+-------+-------+-------+
| **0.8** | 74 %  | 77 %  | **8   | 83 %  | 86 %  | 88 %  | 90 %  |
|         |       |       | 0 %** |       |       |       |       |
+---------+-------+-------+-------+-------+-------+-------+-------+
| **0.7** | 70 %  | 75 %  | **8   | 85 %  | 88 %  | 91 %  | 93 %  |
|         |       |       | 0 %** |       |       |       |       |
+---------+-------+-------+-------+-------+-------+-------+-------+
| **0.6** | 65 %  | 74 %  | **8   | 86 %  | 89 %  | 93 %  | 95 %  |
|         |       |       | 0 %** |       |       |       |       |
+---------+-------+-------+-------+-------+-------+-------+-------+
| **0.5** | 60 %  | 72 %  | **8   | 87 %  | 91 %  | 95 %  | 97 %  |
|         |       |       | 0 %** |       |       |       |       |
+---------+-------+-------+-------+-------+-------+-------+-------+

::: paragraph
Mit dem Magic Factor schließen wir den Leitfaden für Einsteiger ab. Wir
hoffen, dass Sie es geschafft haben, Ihr Checkmk grundlegend
einzurichten --- mit oder ohne Magie. Für fast alle Themen, die wir in
diesem Leitfaden behandelt haben, finden Sie vertiefende Informationen
in anderen Artikeln des Handbuchs.
:::

::: paragraph
Wir wünschen viel Erfolg mit Checkmk!
:::
::::::::::::::::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
