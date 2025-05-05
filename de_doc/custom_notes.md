:::: {#header}
# Anmerkungen (Custom notes)

::: details
[Last modified on 18-Aug-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/custom_notes.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Benachrichtigungen](notifications.html) [Ansichten von Hosts und
Services](views.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::: sectionbody
::: paragraph
In Checkmk können Sie für alle Hosts und Services einzeln und spezifisch
oder für ganze Gruppen Anmerkungen (sogenannte *custom notes*)
hinterlegen. Diese Anmerkungen werden in jeweils eigenen Spalten namens
[Custom services notes]{.guihint} und [Custom host notes]{.guihint}
angezeigt. Standardmäßig werden diese Spalten bereits in den
detaillierten [Tabellenansichten](glossar.html#view) zu Hosts ([Status
of Host myhost]{.guihint}) und Services ([Service myservice,
myhost]{.guihint}) angezeigt. Weil es sich hierbei um reguläre Spalten
handelt, können diese auch in viele andere [Ansichten in Checkmk
eingefügt](views.html#edit) werden.
:::
::::
:::::

::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#create .hidden-anchor .sr-only}2. Anmerkungen erstellen {#heading_create}

:::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Anmerkungen erstellen Sie direkt im Konfigurationsverzeichnis Ihrer
Checkmk-Instanz. Erzeugen Sie dazu zuerst das Verzeichnis `notes`
unterhalb von `~/etc/check_mk/`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes
```
:::
::::

:::::::::::::::::::: sect2
### []{#host_notes .hidden-anchor .sr-only}2.1. Host-Anmerkungen {#heading_host_notes}

::: paragraph
Um nun Anmerkungen zu Hosts zu erstellen, erzeugen Sie unterhalb des
Verzeichnisses `notes` das Verzeichnis `hosts`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes/hosts
```
:::
::::

::: paragraph
Wollen Sie nun eine Anmerkung für einen bestimmten Host erstellen, so
erzeugen Sie eine Datei, deren Namen exakt dem Host-Namen in Checkmk
entspricht. Nutzen Sie dazu den Editor Ihrer Wahl oder die Shell
Redirection, wie im folgenden Beispiel:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "My custom host note for myhost" > ~/etc/check_mk/notes/hosts/myhost
```
:::
::::

::: paragraph
Ganz unten in der Ansicht [Status of Host]{.guihint} sieht diese
Anmerkung dann so aus:
:::

:::: imageblock
::: content
![Eine Anmerkung in der Ansicht \'Status of
Host\'.](../images/custom_notes_first_host_note.png)
:::
::::

::: paragraph
Wenn Sie möchten, dass sich eine einzelne solche Datei gleich auf
mehrere Hosts bezieht und dort angezeigt wird, können Sie mit Suchmuster
für Dateinamen (*shell patterns*) wie dem Stern, dem Fragezeichen und
auch Zeichenklassen arbeiten. Dazu muss dann tatsächlich der Dateiname
im jeweiligen Verzeichnis diese Zeichen enthalten. Eine Datei namens
`'*'` im Verzeichnis `~/etc/check_notes/hosts/` würde sich also auf alle
Host beziehen. Der Inhalt der Datei `'*'` würde folgerichtig bei jedem
einzelnen Host Ihrer Instanz angezeigt.
:::

::: paragraph
**Wichtig:** Die Namen solcher Dateien **müssen** in einfache
Anführungsstriche eingefasst werden.
:::

::: paragraph
Möchten Sie - aus Gründen - bei allen Hosts deren Name auf `t` endet
eine bestimmte Anmerkung anzeigen, dann erstellen Sie dazu eine Datei
namens `'*t'`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "The name auf this host ends with t" > ~/etc/check_mk/notes/hosts/'*t'
```
:::
::::

::: paragraph
Sollten mehrere Dateien zum Namen eines Hosts passen, werden im Feld
[Custom host notes]{.guihint} auch alle passenden Anmerkungen angezeigt.
Die verschiedenen Anmerkungen werden dabei von einer horizontale Linie
von einander getrennt:
:::

:::: imageblock
::: content
![Anmerkungen aus unterschiedlichen Quell-Dateien werden durch eine
horizontale Linie
getrennt.](../images/custom_notes_notes_from_different_sources.png)
:::
::::
::::::::::::::::::::

:::::::::::::::::::::: sect2
### []{#service_notes .hidden-anchor .sr-only}2.2. Service-Anmerkungen {#heading_service_notes}

::: paragraph
Um auch für Services solche Anmerkungen einrichten zu können, benötigen
Sie unterhalb von `~/etc/check_mk/notes/` noch das Verzeichnis
`services`.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes/services
```
:::
::::

::: paragraph
Im Gegensatz zu den Hosts können Sie nicht gleich in diesem Verzeichnis
mit den Dateien für Ihre Anmerkungen loslegen. Hier ist noch eine
weitere Verzeichnisebene erforderlich, die festlegt, bei welchen Hosts
eine Service-Anmerkung angezeigt werden soll.
:::

::: paragraph
Erzeugen Sie also als nächstes ein Verzeichnis, welches einen Host -
oder nach den Mustern [oben](#host_notes) - mehrere Hosts bezeichnet.
:::

::: paragraph
Ein Verzeichnis namens `'*'` würde sich also wieder auf alle Hosts
beziehen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes/services/'*'
```
:::
::::

::: paragraph
In einem Verzeichnis, welches exakt einem Host-Namen entspricht, können
Sie anschließend somit nur die Services dieses einen Hosts mit
Anmerkungen versehen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes/services/myhost
```
:::
::::

::: paragraph
Möchten Sie Anmerkungen für Services bei allen Hosts erstellen, die mit
`my` beginnen, müssen Sie ein Verzeichnis namens `'my*'` anlegen.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir ~/etc/check_mk/notes/services/'my*'
```
:::
::::

::: paragraph
Achten Sie auch hier wieder darauf, die Verzeichnisnamen in einfache
Anführungsstriche einzufassen.
:::

::: paragraph
Sobald Sie jetzt die Host-Ebene nach Ihren Wünschen erstellt haben,
können Sie --- analog zu den Host-Anmerkungen --- wieder Dateien
anlegen, die diesmal der gewünschten [Service description]{.guihint}
entsprechen muss. Auch hier können Sie wieder mit Sternen, Fragezeichen
und Zeichenklassen arbeiten.
:::

::: paragraph
Das folgende Beispiel erzeugt eine Anmerkung für den Service
[Check_MK]{.guihint} auf jedem Host Ihrer Instanz.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "Note about service Check_MK for all hosts" > ~/etc/check_mk/notes/services/'*'/Check_MK
```
:::
::::
::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::

::::::::: sect1
## []{#macros .hidden-anchor .sr-only}3. Verwendbare Makros {#heading_macros}

:::::::: sectionbody
::: paragraph
Innerhalb der Anmerkungen können Sie Makros verwenden, welche dann in
der Ansicht passend ersetzt werden. Folgende Makros stehen Ihnen hier zu
Verfügung:
:::

+--------------------+-------------------------------------------------+
| `$HOSTNAME$`       | Host-Name                                       |
+--------------------+-------------------------------------------------+
| `$HOSTNAME_LOWER$` | Host-Name in Kleinbuchstaben                    |
+--------------------+-------------------------------------------------+
| `$HOSTNAME_UPPER$` | Host-Name in Großbuchstaben                     |
+--------------------+-------------------------------------------------+
| `$HOSTNAME_TITLE$` | Host-Name mit dem ersten Buchstaben als         |
|                    | Großbuchstaben und dem Rest klein               |
+--------------------+-------------------------------------------------+
| `$HOSTADDRESS$`    | Diejenige IP-Adresse des Hosts, über die er     |
|                    | überwacht wird.                                 |
+--------------------+-------------------------------------------------+
| `$SERVICEDESC$`    | Service-Beschreibung (nur bei                   |
|                    | Service-Anmerkungen)                            |
+--------------------+-------------------------------------------------+
| `$SITE$`           | ID der Checkmk-Instanz                          |
+--------------------+-------------------------------------------------+
| `$URL_PREFIX$`     | URL-Präfix der Instanz                          |
+--------------------+-------------------------------------------------+
| `$HOSTOUTPUT$`     | Ausgabe des                                     |
|                    | [Check-Plugins](glossar.html#check_plugin) (nur |
|                    | für Host-Anmerkungen)                           |
+--------------------+-------------------------------------------------+
| `$SERVICEOUTPUT$`  | Ausgabe des Check-Plugins (nur für              |
|                    | Service-Anmerkungen)                            |
+--------------------+-------------------------------------------------+

::: paragraph
So könnten Sie beispielsweise mit einer einzigen Datei auf
unterschiedliche Einträge in Ihrem firmeneigenen Wiki verweisen, welche
immer zu dem gerade geöffneten Host passen.
:::

::::: listingblock
::: title
\~/etc/check_mk/notes/hosts/\'\*\'
:::

::: content
``` {.pygments .highlight}
Additional information about <a href="http://mywiki.local/page.php?host=$HOSTNAME$" target="_blank">this host in our wiki</a>
```
:::
:::::
::::::::
:::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
