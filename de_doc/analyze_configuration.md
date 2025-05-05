:::: {#header}
# Konfiguration der Checkmk Instanz analysieren

::: details
[Last modified on 07-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/analyze_configuration.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html) [Best Practices, Tipps &
Tricks](intro_bestpractise.html) [Sicherheit (Security)](security.html)
:::
::::
:::::
::::::
::::::::

::::::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::::::: sectionbody
::: paragraph
Wenn Ihr Checkmk Server einmal eingerichtet und konfiguriert ist, kommen
über kurz oder lang Fragen auf: Geht das nicht schneller? Lässt sich das
optimieren? Kann man das System sicherer machen?
:::

::: paragraph
Ein Ansatz zur Beantwortung dieser Fragen ist die Überprüfung und
nachfolgende Optimierung der auf dem Checkmk-Server eingerichteten
[Instanz](glossar.html#site). Je performanter Ihr System ist, um so
schneller und effektiver arbeitet es auch. Je verlässlicher Sie Ihre
Instanz abgesichert haben, um so beruhigter können Sie damit arbeiten.
:::

::: paragraph
Checkmk analysiert schnell und übersichtlich die wesentlichen Parameter
der aktuellen Instanz sowie eventuell vorhandener angebundener
Instanzen, wenn es sich um ein [verteiltes
Monitoring](glossar.html#distributed_monitoring) handelt.
:::

::: paragraph
Die Hosts und Services innerhalb Ihrer Instanz(en) sind von dieser
Prüfung nicht betroffen, sie werden in den [Ansichten der Hosts und
Services](views.html) dargestellt. Die Ergebnisse der hier behandelten
*Checks* für die Instanz werden auf der Seite [Setup \> Maintenance \>
Analyze configuration]{.guihint} angezeigt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Beim Aufruf von [Analyze          |
|                                   | configuration]{.guihint} wird     |
|                                   | stets der aktuelle Zustand aller  |
|                                   | Checks geprüft und angezeigt.     |
|                                   | Daher kann es nach dem Aufruf des |
|                                   | Menüeintrags ein wenig dauern,    |
|                                   | bis die Seite mit den Ergebnissen |
|                                   | angezeigt wird:                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::: imageblock
::: content
![Ergebnis der \'Analyze configuration\'.](../images/analyze_config.png)
:::

::: title
Die Standard-Checks in Checkmk Raw
:::
:::::

::: paragraph
Der obige Screenshot zeigt die Checks, die in Checkmk Raw für eine
einzelne Instanz standardmäßig ausgeführt werden. Das ist aber nicht die
ganze Wahrheit, denn es können durchaus mehr Checks angeboten werden.
Welche das sind, hängt zum Beispiel davon ab, ob Sie Checkmk Raw oder
eine der kommerziellen Editionen installiert haben, ob Ihre Instanz im
verteilten Monitoring genutzt wird, ob eine bestimmte Regel eingerichtet
ist, eine LDAP-Verbindung existiert, eine globale Einstellung gesetzt
ist --- oder sogar vom Wert einer Option in einer Regel. Welcher Check
für Ihre Instanz relevant ist --- darum kümmert sich Checkmk.
:::
::::::::::::
:::::::::::::

:::::::::: sect1
## []{#interpreting .hidden-anchor .sr-only}2. Die Anzeige interpretieren {#heading_interpreting}

::::::::: sectionbody
::: paragraph
Die analysierten Instanzdaten werden als Checks in verschiedene
Kategorien unterteilt. Jeder Check hat eine farbige Zustandsanzeige.
Folgende Zustände kann ein Check nach der Analyse haben:
:::

+------+------+--------------------------------------------------------+
| Zus  | F    | Bedeutung                                              |
| tand | arbe |                                                        |
+======+======+========================================================+
| [    | grün | Der Check ist vollständig in Ordnung. Alle überprüften |
| OK]{ |      | Werte werden als optimal eingestuft.                   |
| .sta |      |                                                        |
| te0} |      |                                                        |
+------+------+--------------------------------------------------------+
| [WA  | gelb | Der Check ist prinzipiell in Ordnung, aber Checkmk hat |
| RN]{ |      | Potential für Verbesserungen erkannt.                  |
| .sta |      |                                                        |
| te1} |      |                                                        |
+------+------+--------------------------------------------------------+
| [CR  | rot  | Der Check hat kritische Werte erkannt. Diese sollten   |
| IT]{ |      | geprüft und gegebenenfalls behoben werden, um ein      |
| .sta |      | reibungsfreies Arbeiten von Checkmk zu gewährleisten.  |
| te2} |      |                                                        |
+------+------+--------------------------------------------------------+

::: paragraph
Betrachten wir den Check [Backup configured]{.guihint} in einem
verteilten Monitoring mit zwei Instanzen:
:::

:::: imageblock
::: content
![Ausschnitt des Checks \'Backup
configured\'.](../images/analyze_config_backup.png)
:::
::::

::: paragraph
Dieser Check ist im Zustand [WARN]{.state1}, daher wird hinter dem
[WARN]{.state1} ein [![Knopf zur Quittierung der
Meldung.](../images/icons/button_ackn_test.png)]{.image-inline} Knopf
zur Quittierung angezeigt. Auch für Checks im Zustand [CRIT]{.state2}
wird dieser Knopf angezeigt. Durch die Quittierung verschwindet die
gelbe bzw. rote Farbe des Zustands. Der Eintrag an sich bleibt erhalten,
wird aber optisch dezenter. Ist der Check quittiert, so wechselt der
Knopf zu [![Knopf zur Rücknahme der
Quittierung.](../images/icons/button_unackn_test.png)]{.image-inline}.
Mit diesem Knopf können Sie die Quittierung wieder aufheben.
:::

::: paragraph
Generell ist die Prüfung der Systemumgebung auf alle Parameter sinnvoll.
Wollen Sie jedoch einzelne Checks nicht (erneut) durchführen lassen,
können Sie durch Klick auf den zugehörigen [![Knopf zum Ausschalten
eines Tests.](../images/icons/button_disable_test.png)]{.image-inline}
Knopf jeden der Checks ausschalten. So schalten Sie zum Beispiel den
Check [Backup configured]{.guihint} aus, wenn in Ihrem Unternehmen eine
andere Lösung zur Backup-Erstellung genutzt wird.
:::
:::::::::
::::::::::

::::::::: sect1
## []{#checks_detail .hidden-anchor .sr-only}3. Die Checks im Detail {#heading_checks_detail}

:::::::: sectionbody
::: paragraph
Zu jedem Check erhalten Sie mit einem Klick auf den zugehörigen [![Knopf
zum Einblenden weiterer
Informationen.](../images/icons/button_info.png)]{.image-inline} Knopf
weitere Details zu den festgestellten Werten, eine Einschätzung des
Status sowie Hinweise zur Optimierung.
:::

:::: imageblock
::: content
![Detailansicht \'Backup
configured\'.](../images/analyze_config_backup_ext.png)
:::
::::

::: paragraph
Vieles lässt sich damit bereits verstehen und bearbeiten. Für die
folgenden Themen bietet dieses Handbuch --- aber auch andere
Quellen --- zusätzliche Informationen:
:::

+---------+--------------------+--------------------------------------+
| Ka      | Check              | Weiterführende Informationen         |
| tegorie |                    |                                      |
+=========+====================+======================================+
| [Co     | [Site              | Im verteilten Monitoring können      |
| nnectiv | conne              | Remote-Instanzen wegen [instabiler   |
| ity]{.g | ctivity]{.guihint} | oder langsamer                       |
| uihint} |                    | Verbindung                           |
|         |                    | en](distributed_monitoring.html#wan) |
|         |                    | möglicherweise nicht erreicht        |
|         |                    | werden.                              |
+---------+--------------------+--------------------------------------+
| [De     | [Deprecated HW/SW  | Im [Werk                             |
| precati | inventory          | #14084](https://checkmk              |
| ons]{.g | p                  | .com/de/werk/14084){target="_blank"} |
| uihint} | lug-ins]{.guihint} | finden Sie weitere Details und       |
|         |                    | Informationen zur Migration von      |
|         |                    | Plugins, die noch die alte API für   |
|         |                    | die HW/SW-Inventur nutzen.           |
+---------+--------------------+--------------------------------------+
|         | [Deprecated check  | Im Handbuch finden Sie Artikel über  |
|         | p                  | die [Entwicklung von Erweiterungen   |
|         | lug-ins]{.guihint} | für Checkmk](devel_intro.html) und   |
|         |                    | das [Schreiben von agentenbasierten  |
|         |                    | Chec                                 |
|         |                    | k-Plugins](devel_check_plugins.html) |
|         |                    | mit der in Version [2.0.0]{.new}     |
|         |                    | eingeführten Check-API. Für die      |
|         |                    | Migration alter Check-Plugins gibt   |
|         |                    | es ausführliche Informationen in     |
|         |                    | [diesem                              |
|         |                    | Blog-Artikel.](https://check         |
|         |                    | mk.com/de/blog/migrating-check-plug- |
|         |                    | ins-to-checkmk-2-0){target="_blank"} |
+---------+--------------------+--------------------------------------+
| [P      | [Check helper      | [Hilfsprozesse]                      |
| erforma | usage]{.guihint}   | (cmc_differences.html#aux_processes) |
| nce]{.g |                    | für den Checkmk Micro Core (CMC) der |
| uihint} |                    | kommerziellen Editionen.             |
+---------+--------------------+--------------------------------------+
|         | [Checkmk checker   |                                      |
|         | count]{.guihint}   |                                      |
+---------+--------------------+--------------------------------------+
|         | [Checkmk checker   |                                      |
|         | usage]{.guihint}   |                                      |
+---------+--------------------+--------------------------------------+
|         | [Checkmk fetcher   |                                      |
|         | usage]{.guihint}   |                                      |
+---------+--------------------+--------------------------------------+
|         | [Checkmk helper    |                                      |
|         | usage]{.guihint}   |                                      |
+---------+--------------------+--------------------------------------+
|         | [Livestatus        | [Verbindung aufrecht erhalten        |
|         | usage]{.guihint}   | (Ke                                  |
|         |                    | epAlive)](livestatus.html#keepalive) |
+---------+--------------------+--------------------------------------+
|         | [Persistent        | [Persistente                         |
|         | conn               | Verbindungen](dis                    |
|         | ections]{.guihint} | tributed_monitoring.html#persistent) |
|         |                    | zwischen Zentral- und                |
|         |                    | Remote-Instanzen im verteilten       |
|         |                    | Monitoring.                          |
+---------+--------------------+--------------------------------------+
|         | [Number of         | [Benutzerverwaltung mit LDAP/Active  |
|         | users]{.guihint}   | Directory](ldap.html)                |
+---------+--------------------+--------------------------------------+
|         | [Size of           | Im verteilten Monitoring werden die  |
|         | ext                | Daten zwischen Zentral- und          |
|         | ensions]{.guihint} | Remote-Instanzen eventuell deshalb   |
|         |                    | langsam synchronisiert, weil die     |
|         |                    | [Synchronisation von Erweiterungen   |
|         |                    | wie MKPs](mkps.html#distr_wato)      |
|         |                    | eingeschaltet ist.                   |
+---------+--------------------+--------------------------------------+
|         | [Use Livestatus    | [Der                                 |
|         | Proxy              | Livestatus-Proxy](distribu           |
|         | Daemon]{.guihint}  | ted_monitoring.html#livestatusproxy) |
|         |                    | der kommerziellen Editionen für      |
|         |                    | Verbindungen zwischen Zentral- und   |
|         |                    | Remote-Instanzen im verteilten       |
|         |                    | Monitoring.                          |
+---------+--------------------+--------------------------------------+
| [R      | [Backups           | [Backups](backup.html)               |
| eliabil | con                |                                      |
| ity]{.g | figured]{.guihint} |                                      |
| uihint} |                    |                                      |
+---------+--------------------+--------------------------------------+
| [Secur  | [Encrypt           | [Verschlüsselte Backups              |
| ity]{.g | backups]{.guihint} | konfi                                |
| uihint} |                    | gurieren](backup.html#backup_config) |
+---------+--------------------+--------------------------------------+
|         | [Encrypt           | Im [Werk                             |
|         | notification       | #13610](https://checkmk              |
|         | daemon             | .com/de/werk/13610){target="_blank"} |
|         | commun             | steht, wie Sie die                   |
|         | ication]{.guihint} | Transportverschlüsselung des         |
|         |                    | Notification Spooler `mknotifyd`     |
|         |                    | aktivieren können.                   |
+---------+--------------------+--------------------------------------+
|         | [Livestatus        | [Livestatus verschlüsselt            |
|         | enc                | anbinden](distrib                    |
|         | ryption]{.guihint} | uted_monitoring.html#livestatus_tls) |
|         |                    | für Instanzen, die Livestatus über   |
|         |                    | das Netzwerk (TCP) aktiviert haben.  |
+---------+--------------------+--------------------------------------+
|         | [Secure Agent      | [Automatische Updates                |
|         | Updater]{.guihint} | einrichten](agent_depl               |
|         |                    | oyment.html#setup_automatic_updates) |
|         |                    | in den kommerziellen Editionen.      |
+---------+--------------------+--------------------------------------+
|         | [Secure GUI        | [Weboberfläche mit HTTPS             |
|         | (HTTP)]{.guihint}  | absichern](omd_https.html)           |
+---------+--------------------+--------------------------------------+
|         | [Secure            | [LDAP mit SSL                        |
|         | LDAP]{.guihint}    | absichern](ldap.html#ssl) für        |
|         |                    | eingerichtete LDAP-Verbindungen      |
+---------+--------------------+--------------------------------------+

::: paragraph
Ergänzend finden Sie im Artikel [Sicherheit (Security)](security.html)
einen Überblick über weitere sicherheitsrelevante Themen rund um
Checkmk.
:::
::::::::
:::::::::
:::::::::::::::::::::::::::::::::::
