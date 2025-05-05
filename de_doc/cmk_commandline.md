:::: {#header}
# Checkmk auf der Kommandozeile

::: details
[Last modified on 06-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/cmk_commandline.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html) [Statusdaten abrufen via
Livestatus](livestatus.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_warum_kommandozeile .hidden-anchor .sr-only}1. Warum Kommandozeile? {#heading__warum_kommandozeile}

:::::: sectionbody
::: paragraph
Wenn ein Checkmk-System erst einmal installiert ist, können Sie es zu
100 % über die Weboberfläche konfigurieren und bedienen. Trotzdem gibt
es Situationen, in denen es nützlich ist, sich auf die Untiefen der
Kommandozeile zu begeben, z.B.
:::

::: ulist
- bei der Suche nach der Ursache von Problemen,

- beim Automatisieren der Administration von Checkmk,

- beim Programmieren und Testen von eigenen Erweiterungen,

- um zu verstehen, wie Checkmk intern funktioniert oder

- einfach, weil Sie gerne auf der Kommandozeile arbeiten!
:::

::: paragraph
Dieser Artikel zeigt Ihnen die wichtigsten Befehle, Dateien und
Verzeichnisse auf der Kommandozeile von Checkmk.
:::
::::::
:::::::

::::::::::::::::::::::::::::::::: sect1
## []{#site_user .hidden-anchor .sr-only}2. Der Instanzbenutzer {#heading_site_user}

:::::::::::::::::::::::::::::::: sectionbody
:::::::::::::: sect2
### []{#_login_als_instanzbenutzer .hidden-anchor .sr-only}2.1. Login als Instanzbenutzer {#heading__login_als_instanzbenutzer}

::: paragraph
Bei der Administration von Checkmk müssen Sie mit wenigen Ausnahmen
niemals als `root`-Benutzer arbeiten. In diesem Artikel gehen wir
grundsätzlich davon aus, dass Sie als *Instanzbenutzer* angemeldet sind.
Das geht z.B. mit:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# su - mysite
```
:::
::::

::: paragraph
Auch ein direkter SSH-Login in eine Instanz ohne den Umweg über `root`
ist möglich. Da der Instanzbenutzer ein „ganz normaler" Linux-Benutzer
ist, müssen Sie dazu lediglich ein Passwort vergeben (was ein letztes
Mal `root`-Rechte erfordert):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# passwd mysite
Enter new UNIX password: **********
Retype new UNIX password: **********
passwd: password updated successfully
```
:::
::::

::: paragraph
Danach sollte ein SSH-Login von einem anderen Rechner aus direkt möglich
sein (Windows-Benutzer verwenden am besten PuTTY dafür). Von Linux aus
geht das einfach mit dem Kommandozeilenbefehl `ssh`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@otherhost> ssh mysite@myserver123
mysite@localhost's password: **********
```
:::
::::

::: paragraph
Beim ersten Login bekommen Sie wahrscheinlich eine Warnung wegen eines
unbekannten Host-Schlüssels. Wenn Sie sicher sind, dass kein Angreifer
in diesem Augenblick die IP-Adresse Ihres Monitoring-Systems übernommen
hat, können Sie diese einfach mit `yes` bestätigen.
:::

::: paragraph
Auch bei der Checkmk-Appliance können Sie auf die Kommandozeile
zugreifen. Wie das geht, erklärt ein [eigener
Artikel](appliance_usage.html#ssh).
:::
::::::::::::::

:::::::::::::::: sect2
### []{#_profil_und_umgebungsvariablen .hidden-anchor .sr-only}2.2. Profil und Umgebungsvariablen {#heading__profil_und_umgebungsvariablen}

::: paragraph
Damit es zu möglichst wenig Problemen aufgrund von Besonderheiten
einzelner Distributionen oder unterschiedlicher
Betriebssystemkonfigurationen kommt, sorgt das Checkmk-System dafür,
dass Instanzbenutzer --- und gleichzeitig alle Prozesse des
Monitorings --- immer eine klar definierte Umgebung haben. Neben dem
Home-Verzeichnis und den Berechtigungen, spielen hier die
**Umgebungsvariablen** (*environment variables*) eine wichtige Rolle.
:::

::: paragraph
Unter anderem werden beim Login als Instanzbenutzer folgende Variablen
gesetzt bzw. modifiziert. Sie stehen in allen Prozessen zur Verfügung,
welche innerhalb der Instanz laufen. Das betrifft auch Skripte, die
indirekt von diesen aufgerufen werden (z.B. eigene
[Benachrichtigungsskripte](notifications.html#scripts)).
:::

+-----------------+-----------------------------------------------------+
| `OMD_SITE`      | Der Name der Instanz (`mysite`). In eigenen         |
|                 | Skripten sollten Sie anstelle eines hartkodierten   |
|                 | Instanznamens immer diese Variable verwenden (z.B.  |
|                 | in der Shell mit `$OMD_SITE`). So können Sie das    |
|                 | Skript unverändert auch in andere Instanzen         |
|                 | übernehmen.                                         |
+-----------------+-----------------------------------------------------+
| `OMD_ROOT`      | Der Pfad des Instanzverzeichnisses                  |
|                 | (`/omd/sites/mysite`).                              |
+-----------------+-----------------------------------------------------+
| `PATH`          | Verzeichnisse, in denen ausführbare Programme       |
|                 | gesucht werden. Checkmk hängt hier z.B. das `bin/`  |
|                 | der Instanz mit ein. Bei Namensgleichheit haben     |
|                 | Checkmk-Programme Vorrang. Das ist z.B. wichtig     |
|                 | beim Befehl `mail`, den Checkmk in einer ganz       |
|                 | bestimmten Version mit ausliefert.                  |
+-----------------+-----------------------------------------------------+
| `L              | Verzeichnisse, in denen nach zusätzlichen           |
| D_LIBRARY_PATH` | Binärbibliotheken gesucht wird. Durch diese         |
|                 | Variable stellt Checkmk sicher, dass mit            |
|                 | ausgelieferte Bibliotheken Vorrang vor den im       |
|                 | normalen Betriebssystem installierten haben.        |
+-----------------+-----------------------------------------------------+
| `PERL5LIB`      | Suchpfad für Perl-Module. Auch hier haben von       |
|                 | Checkmk ausgelieferte Modulvarianten im Zweifel den |
|                 | Vorrang.                                            |
+-----------------+-----------------------------------------------------+
| `LANG`          | Spracheinstellung für Kommandozeilenbefehle. Diese  |
|                 | Einstellung wird von der Spracheinstellung Ihrer    |
|                 | Linux-Installation übernommen. Bei Prozessen der    |
|                 | Instanz wird diese Variable aber automatisch        |
|                 | entfernt! Die Sprache fällt dann auf die            |
|                 | Systemsprache zurück (Englisch). Das betrifft auch  |
|                 | andere regionale Einstellungen. Das Entfernen von   |
|                 | `LANG` ist sehr wichtig, denn einige klassische     |
|                 | Nagios-Plugins verwenden sonst z.B. bei deutscher   |
|                 | Spracheinstellung ein Komma anstelle eines Punkts   |
|                 | als Dezimaltrenner. Ihre Ausgabe könnte dann nicht  |
|                 | sauber ausgewertet werden.                          |
+-----------------+-----------------------------------------------------+

::: paragraph
Mit dem Befehl `env` können Sie sich alle Umgebungsvariablen ausgeben
lassen. Ein kleines, hübsches `| sort` dahinter macht das Ganze etwas
übersichtlicher:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ env | sort
HOME=/omd/sites/mysite
LANG=de_DE.UTF-8
LD_LIBRARY_PATH=/omd/sites/mysite/local/lib:/omd/sites/mysite/lib
LOGNAME=mysite
MAILRC=/omd/sites/mysite/etc/mail.rc
MAIL=/var/mail/mysite
MANPATH=/omd/sites/mysite/share/man:
MODULEBUILDRC=/omd/sites/mysite/.modulebuildrc
MP_STATE_DIRECTORY=/omd/sites/mysite/var/monitoring-plugins
NAGIOS_PLUGIN_STATE_DIRECTORY=/omd/sites/mysite/var/monitoring-plugins
OMD_ROOT=/omd/sites/mysite
OMD_SITE=mysite
PATH=/omd/sites/mysite/lib/perl5/bin:/omd/sites/mysite/local/bin:/omd/sites/mysite/bin:/omd/sites/mysite/local/lib/perl5/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
PERL5LIB=/omd/sites/mysite/local/lib/perl5/lib/perl5:/omd/sites/mysite/lib/perl5/lib/perl5:
PERL_MM_OPT=INSTALL_BASE=/omd/sites/mysite/local/lib/perl5/
PWD=/omd/sites/mysite
PYTHONPATH=/omd/sites/mysite/lib/python:/omd/sites/mysite/local/lib/python
SHELL=/bin/bash
SHLVL=1
TERM=xterm
USER=mysite
_=/usr/bin/env
```
:::
::::

::: paragraph
Unter Linux ist das Environment eine Eigenschaft eines *Prozesses*.
Jeder Prozess hat seine eigenen Variablen, welche er an Unterprozesse
automatisch vererbt. Dieser startet zwar dann erst einmal mit den
gleichen Variablen, kann diese aber verändern.
:::

::: paragraph
Mit dem Befehl `env` können Sie immer nur die Umgebung der aktuellen
Shell ansehen. Wenn Sie einen Fehler in der Umgebung eines bestimmten
Prozesses vermuten, können Sie diese mit einem kleinen Trick ausgeben
lassen. Dazu brauchen Sie nur die Prozess-ID (PID). Diese können Sie
z.B. mit `ps ax`, `pstree -p` oder `top` ermitteln. Damit greifen Sie
dann über das `/proc`-Dateisystem direkt auf die Datei `environ` des
Prozesses zu. Hier ist ein passender Befehl für die Beispiel-PID
`13222`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ tr \\0 \\n < /proc/13222/environ | sort
```
:::
::::

::: paragraph
Wenn Sie für eigene Skripten oder andere Software, die in der Instanz
laufen soll, eigene Variablen benötigen, so legen Sie diese bitte in der
Datei `etc/environment` an, welche extra dafür vorgesehen ist. Alle hier
definierten Variablen werden überall in der Instanz bereitgestellt:
:::

::::: listingblock
::: title
etc/environment
:::

::: content
``` {.pygments .highlight}
# Custom environment variables
#
# Here you can set environment variables. These will
# be set in interactive mode when logging in as site
# user and also when starting the OMD processes with
# omd start.
#
# This file has shell syntax, but without 'export'.
# Better use quotes if your values contain spaces.
#
# Example:
#
# FOO="bar"
# FOO2="With some spaces"
#
MY_SUPER_VAR=blabla123
MY_OTHER_VAR=10.88.112.17
```
:::
:::::
::::::::::::::::

::::: sect2
### []{#_anpassung_der_shell .hidden-anchor .sr-only}2.3. Anpassung der Shell {#heading__anpassung_der_shell}

::: paragraph
Wenn Sie Ihre Shell anpassen möchten (Prompt oder andere Dinge), können
Sie das wie gewohnt in der Datei `.bashrc` tun. Umgebungsvariablen
gehören trotzdem nach `etc/environment`, damit diese auch sicher in
allen Prozessen vorhanden sind.
:::

::: paragraph
Es spricht auch nichts gegen eine eigene `.vimrc`, falls Sie gerne mit
VIM arbeiten.
:::
:::::
::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#folder_structure .hidden-anchor .sr-only}3. Die Verzeichnisstruktur {#heading_folder_structure}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_trennung_von_software_und_daten .hidden-anchor .sr-only}3.1. Trennung von Software und Daten {#heading__trennung_von_software_und_daten}

::: paragraph
Folgendes Schaubild zeigt die wichtigsten Verzeichnisse einer
Checkmk-Installation mit einer Instanz namens `mysite` und einer
`<version>`, die zum Beispiel `2.0.0p8.cee` heißt:
:::

:::: imageblock
::: content
![Illustration der Verzeichnisstruktur einer Checkmk
Instanz.](../images/filesystem.png)
:::
::::

::: paragraph
Die Basis bildet das Verzeichnis `/omd`. Alle Dateien von Checkmk
befinden sich ohne Ausnahme hier. Zwar ist `/omd` ein symbolischer Link
auf `/opt/omd`, womit die Daten *physikalisch* eigentlich unterhalb von
`/opt` liegen. Aber alle Pfadangaben in Checkmk verwenden immer `/omd`.
:::

::: paragraph
Wichtig ist die Aufteilung in Daten (gelb dargestellt) und Software
(blau). Die Daten der Instanzen liegen unterhalb von `/omd/sites`, die
installierte Software unter `/omd/versions`.
:::
::::::::

::::::::::::: sect2
### []{#sitedir .hidden-anchor .sr-only}3.2. Instanzverzeichnis {#heading_sitedir}

::: paragraph
Wie jeder Linux-Benutzer hat auch der Instanzbenutzer ein
Home-Verzeichnis, welches wir als Instanzverzeichnis bezeichnen. Wenn
Ihre Instanz `mysite` heißt, so liegt dieses unter `/omd/sites/mysite`.
Wie bei Linux üblich kürzt die Shell das eigene Home-Verzeichnis mit
einer Tilde (`~`) ab. Da Sie sich nach einem Login direkt in diesem
Verzeichnis befinden, erscheint die Tilde im Eingabeprompt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$
```
:::
::::

::: paragraph
Unterverzeichnisse des Instanzverzeichnisses werden relativ zur Tilde
dargestellt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cd var/log
OMD[mysite]:~/var/log$
```
:::
::::

::: paragraph
Direkt im Instanzverzeichnis befinden sich etliche Unterverzeichnisse,
die Sie mit `ll` (Alias für `ls -alF)` auflisten können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll
total 16
lrwxrwxrwx  1 mysite mysite   11 Jan 24 11:56 bin -> version/bin/
drwxr-xr-x 22 mysite mysite 4096 Jan 24 11:56 etc/
lrwxrwxrwx  1 mysite mysite   15 Jan 24 11:56 include -> version/include/
lrwxrwxrwx  1 mysite mysite   11 Jan 24 11:56 lib -> version/lib/
drwxr-xr-x  5 mysite mysite 4096 Jan 24 11:56 local/
lrwxrwxrwx  1 mysite mysite   13 Jan 24 11:56 share -> version/share/
drwxr-xr-x 13 mysite mysite 4096 Jan 24 09:57 tmp/
drwxr-xr-x 13 mysite mysite 4096 Jan 24 11:56 var/
lrwxrwxrwx  1 mysite mysite   29 Jan 24 11:56 version -> ../../versions/2.0.0p8.cee/
```
:::
::::

::: paragraph
Wie Sie sehen können, sind die Verzeichnisse `bin`, `include`, `lib`,
`share` und `version` symbolische Links. Beim Rest handelt es sich um
„normale" Verzeichnisse. Dies spiegelt die oben genannte Trennung von
Software und Daten wieder. Die Verzeichnisse zur Software müssen zwar in
der Instanz als Unterverzeichnisse verfügbar sein, liegen aber
physikalisch unterhalb von `/omd/versions` und werden dort eventuell
noch von weiteren Instanzen genutzt.
:::

+-----------------+------------------------+---------------------------+
|                 | Software               | Daten                     |
+=================+========================+===========================+
| Verzeichnisse   | `bin`, `include`,      | `etc`, `local`, `tmp`,    |
|                 | `lib`, `share`         | `var`                     |
+-----------------+------------------------+---------------------------+
| Eigentümer      | `root`                 | Instanzbenutzer           |
|                 |                        | (`mysite`)                |
+-----------------+------------------------+---------------------------+
| Entsteht durch  | Installation von       | Anlegen der Instanz,      |
|                 | Checkmk                | Konfiguration, Monitoring |
+-----------------+------------------------+---------------------------+
| Physikalischer  | `/omd/                 | `/omd/sites/mysite/`      |
| Ort             | versions/2.0.0p8.cee/` |                           |
+-----------------+------------------------+---------------------------+
| Dateityp        | Symbolische Links      | Normale Verzeichnisse     |
+-----------------+------------------------+---------------------------+
:::::::::::::

::::: sect2
### []{#_software .hidden-anchor .sr-only}3.3. Software {#heading__software}

::: paragraph
Die Verzeichnisse der Software gehören wie unter Linux üblich `root` und
sind daher vor Veränderungen durch den Instanzbenutzer geschützt. Es
gibt folgende Unterverzeichnisse, welche hier im Beispiel physikalisch
unterhalb von `/omd/versions/2.0.0p8.cee` liegen und über symbolische
Links vom Instanzverzeichnis aus erreichbar sind:
:::

+-------------+--------------------------------------------------------+
| `bin/`      | Verzeichnis für ausführbare Programme. Dort liegt z.B. |
|             | der Befehl `cmk`.                                      |
+-------------+--------------------------------------------------------+
| `lib/`      | C-Bibliotheken, Plugins für Apache und Python          |
|             | und --- im Unterverzeichnis `nagios/plugins`           |
|             | klassische Monitoring-Plugins, die meist in C oder     |
|             | Perl geschrieben sind.                                 |
+-------------+--------------------------------------------------------+
| `share/`    | Hauptteil der installierten Software. Sehr viele       |
|             | Komponenten befinden sich unter                        |
|             | `share/check_mk` --- unter anderem auch die über 2.000 |
|             | Check-Plugins.                                         |
+-------------+--------------------------------------------------------+
| `include/`  | Enthält Include-Dateien für C-Programme, die mit den   |
|             | in `lib/` befindlichen Bibliotheken gelinkt werden     |
|             | sollen. Dieses Verzeichnis ist nicht wichtig und wird  |
|             | nur verwendet, wenn Sie selbst C-Programme übersetzen  |
|             | möchten.                                               |
+-------------+--------------------------------------------------------+

::: paragraph
Der symbolische Link `version/` ist ein „Zwischenstopp" und dient als
zentrale Umschaltstelle für die von der Instanz verwendete Version. Bei
einem [Software-Update](update.html) wird dieser symbolische Link von
der alten auf die neue Version umgebogen. Bitte versuchen Sie trotzdem
nicht, ein Update von Hand durch Ändern des Links durchzuführen, denn
beim Update sind noch einige weitere Schritte notwendig, die dann fehlen
würden.
:::
:::::

::::: sect2
### []{#data .hidden-anchor .sr-only}3.4. Daten {#heading_data}

::: paragraph
Die eigentlichen **Daten** einer Instanz liegen in den restlichen
Unterverzeichnissen des Instanzverzeichnisses. Diese gehören ohne
Ausnahme dem Instanzbenutzer. Auch das Instanzverzeichnis selbst gehört
dazu. Checkmk legt dort außer den hier gezeigten Verzeichnissen keine
Dinge ab. Sie können hier aber problemlos eigene Dateien und
Verzeichnisse anlegen, in denen Sie Tests, heruntergeladene Dateien,
Kopien von Logdateien oder was auch immer ablegen möchten.
:::

::: paragraph
Es gibt folgende vordefinierte Verzeichnisse:
:::

+---------+------------------------------------------------------------+
| `etc/`  | Konfigurationsdateien. Diese können Sie entweder von Hand  |
|         | oder mit dem Checkmk [Setup](wato.html) editieren.         |
|         |                                                            |
|         | Hinweis: Die Skripten unter `etc/init.d` sind zwar - weil  |
|         | sie unter `etc/` liegen --- auch „Konfigurationsdateien".  |
|         | Dies ist in Anlehnung an das gleiche Schema, das Sie auf   |
|         | jedem Linux-System unter `/etc/init.d/` finden. Aber wir   |
|         | empfehlen, diese Skripten nicht zu ändern, da dies zu      |
|         | [Konflikten](update.html#conflicts) bei einem              |
|         | Softwareupdate führen kann. Änderungen an den Skripten     |
|         | sind nicht notwendig.                                      |
+---------+------------------------------------------------------------+
| `var/`  | Laufzeitdaten. Hier werden alle vom Monitoring erzeugten   |
|         | Daten abgelegt. Je nach Anzahl der überwachten Hosts und   |
|         | Services können immense Datenmengen zusammenkommen. Den    |
|         | größten Umfang haben dabei die aufgezeichneten Messdaten   |
|         | in den [RRDs](graphing.html#rrds).                         |
+---------+------------------------------------------------------------+
| `tmp/`  | Flüchtige Daten. Hier legen Checkmk und andere Komponenten |
|         | temporäre Daten ab, die nicht persistiert werden müssen.   |
|         | Deswegen ist hier ein `tmpfs` gemountet. Das ist ein       |
|         | Dateisystem, welches die Daten im RAM verwaltet und        |
|         | deswegen keinerlei Disk-IO erzeugt. Beim Neustart des      |
|         | Rechners gehen alle Daten in `tmp/` verloren! Ein Stoppen  |
|         | und Starten der Instanz löscht die Daten *nicht*. Unter    |
|         | `tmp/run` finden Sie Dateien wie Sockets, Pipes und        |
|         | PID-Dateien, welche zur Kommunikation und Verwaltung der   |
|         | Serverprozesse notwendig sind. Verwenden Sie `tmp/`        |
|         | **nicht** für die Ablage von eigenen Dateien. Da dieses    |
|         | Verzeichnis im RAM liegt, ist der Platz begrenzt. Legen    |
|         | Sie eigene Dinge direkt in das Instanzverzeichnis oder in  |
|         | ein eigenes Unterverzeichnis davon.                        |
+---------+------------------------------------------------------------+
| `       | Eigene Erweiterungen. Unter `local/` finden Sie eine       |
| local/` | „Schattenhierarchie" der Softwareverzeichnisse `bin/`,     |
|         | `lib/` und `share/`. Diese sind für Ihre eigenen           |
|         | Änderungen oder Erweiterungen der Software vorgesehen.     |
|         | Auch hier gilt: Legen Sie unter `local/` auf keinen Fall   |
|         | Testdateien, Logdateien, Sicherheitskopien oder Sonstiges  |
|         | an, was dort nicht hingehört. Checkmk könnte versuchen,    |
|         | diese Dateien als Teil der Software auszuführen. Auch      |
|         | werden die Dateien beim verteilten Monitoring auf alle     |
|         | Remote-Instanzen verteilt.                                 |
+---------+------------------------------------------------------------+
:::::

:::::::::::: sect2
### []{#local .hidden-anchor .sr-only}3.5. Checkmk verändern und erweitern - die lokalen Dateien {#heading_local}

::: paragraph
Wie gerade in der Tabelle gezeigt, ist das Verzeichnis `local` mit
seinen zahlreichen Unterverzeichnissen für Ihre eigenen Erweiterungen
vorgesehen. In einer neuen Instanz sind alle Verzeichnisse unter
`local/` zunächst leer.
:::

::: paragraph
Mit dem praktischen Befehl `tree` können Sie sich schnell einen
Überblick über die Struktur unter `local` verschaffen. Die Option `-L 3`
begrenzt hier die Tiefe auf 3:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ tree -L 3 local
local
├── bin
├── lib
│   ├── apache
│   ├── check_mk -> python3/cmk
│   ├── nagios
│   │   └── plugins
│   ├── python
│   └── python3
│       └── cmk
└── share
    ├── check_mk
    │   ├── agents
    │   ├── alert_handlers
    │   ├── checkman
    │   ├── checks
    │   ├── inventory
    │   ├── locale
    │   ├── mibs
    │   ├── notifications
    │   ├── pnp-rraconf
    │   ├── pnp-templates
    │   ├── reporting
    │   └── web
    ├── diskspace
    ├── doc
    │   └── check_mk
    ├── nagios
    │   └── htdocs
    ├── nagvis
    │   └── htdocs
    └── snmp
        └── mibs
```
:::
::::

::: paragraph
Alle Verzeichnisse der *untersten* Ebene sind aktiv in die Software
eingebunden. Legen Sie hier eine Datei ab, so wird diese genauso
behandelt, als läge sie im gleichnamigen Verzeichnis unterhalb von
`/omd/versions/…​` (bzw. im logischen Pfad von der Instanz aus unter
`bin`, `lib` oder `share`).
:::

::: paragraph
Beispiel: In der Instanz werden ausführbare Programme in `bin` und in
`local/bin` gesucht.
:::

::: paragraph
Dabei gilt, dass bei einer *exakten Namensgleichheit* die Datei unter
`local` immer Vorrang hat. Das ermöglicht Ihnen, Dateien der Software zu
modifizieren, ohne Installationsdateien unterhalb von `/omd/versions/`
ändern zu müssen. Das Vorgehen ist einfach:
:::

::: {.olist .arabic}
1.  Kopieren Sie die gewünschte Datei in das passende Verzeichnis unter
    `local`.

2.  Ändern Sie diese Datei.

3.  Starten Sie betroffenen Dienste neu, damit die Änderung wirksam
    wird.
:::

::: paragraph
Falls Sie beim dritten Punkt nicht genau wissen, welche Dienste das
sind, so können Sie einfach mit `omd restart` die ganze Instanz neu
starten.
:::
::::::::::::

::::::::::::::::::::::::: sect2
### []{#logs .hidden-anchor .sr-only}3.6. Logdateien {#heading_logs}

::: paragraph
Die Logdateien werden bei Checkmk unterhalb des bereits erwähnten
[Datenverzeichnisses](#data) `var/` abgelegt. Hier finden Sie zu allen
Komponenten die zugehörigen Logdateien:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ll -R var/log/
var/log/:
total 48
-rw-r--r-- 1 mysite mysite  759 Sep 21 16:54 alerts.log
drwxr-xr-x 2 mysite mysite 4096 Sep 21 16:52 apache/
-rw-r--r-- 1 mysite mysite 8603 Sep 21 16:54 cmc.log
-rw-r--r-- 1 mysite mysite 3175 Sep 21 11:38 dcd.log
-rw-rw---- 1 mysite mysite    0 Oct 27 11:05 diskspace.log
-rw-r--r-- 1 mysite mysite  313 Sep 21 16:54 liveproxyd.log
-rw-r--r-- 1 mysite mysite   62 Sep 21 16:54 liveproxyd.state
drwxr-xr-x 2 mysite mysite 4096 Sep 20 13:44 mkeventd/
-rw-r--r-- 1 mysite mysite  676 Sep 21 16:54 mkeventd.log
-rw-r--r-- 1 mysite mysite  310 Sep 21 16:54 mknotifyd.log
-rw-r--r-- 1 mysite mysite  327 Sep 21 16:54 notify.log
-rw-r--r-- 1 mysite mysite  458 Sep 21 16:54 rrdcached.log
-rw-r--r-- 1 mysite mysite    0 Sep 21 16:52 web.log

var/log/apache:
total 32
-rw-r--r-- 1 mysite mysite 26116 Sep 21 16:54 access_log
-rw-r--r-- 1 mysite mysite   841 Sep 21 16:54 error_log
-rw-r--r-- 1 mysite mysite     0 Sep 22 10:21 stats

var/log/mkeventd:
total 0
```
:::
::::

::: paragraph
Auf der Weboberfläche können Sie bequem konfigurieren, in welchem Umfang
Daten in die Logdateien geschrieben werden sollen, indem Sie in [Setup
\> General \> Global settings]{.guihint} nach allen Einträgen mit
`logging` suchen:
:::

:::: imageblock
::: content
![Liste der globalen Einstellungen für das
Logging.](../images/cmk_commandline_global_settings_logging.png)
:::
::::

::: paragraph
Alternativ können Sie die Log Level auch auf der Kommandozeile in
Konfigurationsdateien anpassen. Die Dateien heißen jeweils `global.mk`,
befinden sich aber in unterschiedlichen Verzeichnissen. Setzen Sie die
Einträge, wenn Sie noch nicht vorhanden sind, was dann der Fall ist,
wenn ein Standardwert ([Factory setting]{.guihint}) noch nicht verändert
wurde.
:::

::::: listingblock
::: title
\~/etc/check_mk/conf.d/wato/global.mk
:::

::: content
``` {.pygments .highlight}
notification_logging = 15
alert_logging = 10
cmc_log_levels = {
 'cmk.alert'        : 5,
 'cmk.carbon'       : 5,
 'cmk.core'         : 5,
 'cmk.downtime'     : 5,
 'cmk.helper'       : 5,
 'cmk.livestatus'   : 5,
 'cmk.notification' : 5,
 'cmk.rrd'          : 5,
 'cmk.smartping'    : 5,
}
cmc_log_rrdcreation = None
```
:::
:::::

::: paragraph
In dieser Datei werden die Einträge für [Monitoring Core]{.guihint},
[Notifications]{.guihint} und [Alert Handlers]{.guihint} gesetzt:
:::

::: ulist
- Für `notification_logging` stehen die drei Zahlenwerte 10 für [Full
  dump of all variables and command]{.guihint}, 15 für [Normal
  logging]{.guihint} und 20 für [Minimal logging]{.guihint}.

- Das `alert_logging` kann die Werte 10 für [Full dump of all
  variables]{.guihint} oder 20 für [Normal logging]{.guihint} erhalten.

- Für `cmc_log_levels` nimmt der Umfang der geloggten Daten mit größeren
  Zahlen zu. Hier gibt es acht Abstufungen (0 bis 7), wobei 0 für
  [Emergency]{.guihint} und 7 für [Debug]{.guihint} steht.

- Mit den drei Werten `None`, `'terse'` und `'full'` für
  `cmc_log_rrdcreation` können Sie festlegen, inwiefern die Erzeugung
  von [RRDs](graphing.html#rrds) geloggt werden soll.
:::

::::: listingblock
::: title
\~/etc/check_mk/multisite.d/wato/global.mk
:::

::: content
``` {.pygments .highlight}
log_levels = {
 'cmk.web'                : 50,
 'cmk.web.auth'           : 10,
 'cmk.web.automations'    : 15,
 'cmk.web.background-job' : 10,
 'cmk.web.bi.compilation' : 20,
 'cmk.web.ldap'           : 30,
}
```
:::
:::::

::: paragraph
In dieser Datei können Sie das [User Interface]{.guihint} Logging
festlegen.
:::

::: paragraph
Der Umfang der geloggten Daten steigt, je kleiner die Zahl ist. Das
geringste Log Level ist somit 50 ([Critical]{.guihint}), während 10 dem
höchsten ([Debug]{.guihint}) entspricht.
:::

::::: listingblock
::: title
\~/etc/check_mk/liveproxyd.d/wato/global.mk
:::

::: content
``` {.pygments .highlight}
liveproxyd_log_levels = {'cmk.liveproxyd': 20}
```
:::
:::::

::: paragraph
Diese Datei dient dem [Livestatus Proxy logging]{.guihint}. Die
möglichen Werte hier entsprechen denen beim [User Interface]{.guihint}
Logging.
:::

::: paragraph
**Wichtig:** Logdateien können schnell sehr groß werden, wenn ein hohes
Level eingestellt ist. Es eignet sich daher vor allem zur temporären
Anpassung, um Probleme besser identifizieren zu können.
:::
:::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#cmk .hidden-anchor .sr-only}4. Der Befehl cmk {#heading_cmk}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Neben dem [Befehl `omd`](omd_basics.html), welcher zum Starten und
Stoppen von Instanzen, zur Grundkonfiguration der Komponenten und dem
Starten eines [Software-Updates](update.html) dient, ist `cmk` der
wichtigste Befehl. Mit diesem können Sie eine Konfiguration für den
Monitoring-Kern erzeugen, Checks von Hand ausführen, eine
Service-Erkennung durchführen und vieles mehr.
:::

::::::::::: sect2
### []{#options .hidden-anchor .sr-only}4.1. Die Befehlsoptionen {#heading_options}

::: paragraph
Der Befehl `cmk` ist eigentlich eine Abkürzung für `check_mk`, die
eingeführt wurde, damit man den Befehl schneller tippen kann. Der Befehl
verfügt über eine eingebaute, sehr ausführliche Onlinehilfe, die Sie mit
der Option `--help` aufrufen können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -h
WAYS TO CALL:
 cmk  --automation [COMMAND...]          Internal helper to invoke Check_MK actions
 cmk  --backup BACKUPFILE.tar.gz         make backup of configuration and data
 cmk  --cap [pack|unpack|list FILE.cap]  Pack/unpack agent packages (Enterprise only)
 cmk  --check [HOST [IPADDRESS]]         Check all services on the given HOST
...
```
:::
::::

::: paragraph
Wie Sie im obigen Kommando sehen, haben wir die Hilfe statt mit `--help`
mit der Option `-h` aufgerufen. Denn was für den Befehl selbst gilt,
stimmt auch für seine Optionen: Je weniger zu tippen ist, um so
schneller geht es. Nicht für alle, aber für die oft benötigten Optionen,
gibt es daher neben der Lang- auch eine Kurzform. Auch wenn die
Langform, gerade für Einsteiger, intuitiver ist
(`check_mk --list-hosts`) als die Kurzform (`cmk -l`) werden wir im
Handbuch die Kurzform verwenden. Im Zweifel können Sie immer in der
Hilfe zum Kommando nachschlagen. Ein längerer Blick in die Kommandohilfe
ist auf jeden Fall eine gute Idee, da wir im Handbuch nicht alle
Optionen vorstellen werden.
:::

::: paragraph
Durch die Eingabe einer Option starten Sie den Befehl `cmk` in einem
bestimmten Modus. Hier folgt die Übersicht der Optionen, die wir in
diesem Kapitel, aber auch an anderen Stellen des Handbuchs, vorstellen
werden:
:::

+---------------------------+------------------------------------------+
| Option                    | Wirkung                                  |
+===========================+==========================================+
| **Monitoring-Kern**       |                                          |
+---------------------------+------------------------------------------+
| `cmk -R`                  | [Kern neu starten](#commands_core)       |
+---------------------------+------------------------------------------+
| `cmk -O`                  | [Neue Konfiguration in den Kern          |
|                           | laden](#commands_core)                   |
+---------------------------+------------------------------------------+
| `cmk -U`                  | [Neue Konfiguration für den Kern         |
|                           | erstellen](#commands_core)               |
+---------------------------+------------------------------------------+
| `cmk -N`                  | [Nagios-Konfiguration des Kerns          |
|                           | ausgeben](#commands_core)                |
+---------------------------+------------------------------------------+
| **Checks**                |                                          |
+---------------------------+------------------------------------------+
| `cmk myserver123`         | [Checks ausführen](#execute_checks) auf  |
|                           | dem Host `myserver123`                   |
+---------------------------+------------------------------------------+
| **Services**              |                                          |
+---------------------------+------------------------------------------+
| `cmk -I myserver123`      | [Service-Erkennung                       |
|                           | au                                       |
|                           | sführen](wato_services.html#commandline) |
+---------------------------+------------------------------------------+
| `cmk --che                | Führt auf dem Host den [Discovery        |
| ck-discovery myserver123` | Ch                                       |
|                           | eck](wato_services.html#discovery_check) |
|                           | aus, der nach neuen und verschwundenen   |
|                           | Services und nach neuen Host-Labels      |
|                           | sucht. Bei einer Änderung wird der Host  |
|                           | \"markiert\" indem eine Datei mit dem    |
|                           | Host-Namen in                            |
|                           | `var/check_mk/autodiscovery` angelegt    |
|                           | wird --- allerdings nur dann, wenn in    |
|                           | Checkmk die automatische Aktualisierung  |
|                           | der Service-Konfiguration aktiviert ist  |
|                           | (im Regelsatz [Periodic service          |
|                           | discovery]{.guihint}).                   |
+---------------------------+------------------------------------------+
| **Agenten**               |                                          |
+---------------------------+------------------------------------------+
| `cmk -d myserver123`      | [Agentenausgabe holen](#dump_agent)      |
+---------------------------+------------------------------------------+
| `cmk -A myserver123`      | [Agenten backen](#bake_agents)           |
+---------------------------+------------------------------------------+
| **Diagnose**              |                                          |
+---------------------------+------------------------------------------+
| `cmk -l`                  | [Hosts auflisten](#list_hosts)           |
+---------------------------+------------------------------------------+
| `cmk --list-tag mytag`    | [Hosts mit Host-Merkmal                  |
|                           | auflisten](#list_hosts)                  |
+---------------------------+------------------------------------------+
| `cmk -D myserver123`      | [Host-Konfiguration                      |
|                           | anzeigen](#dump_host)                    |
+---------------------------+------------------------------------------+
| **Information**           |                                          |
+---------------------------+------------------------------------------+
| `cmk -V`                  | Zeigt die in der Instanz installierte    |
|                           | Checkmk-Version an.                      |
+---------------------------+------------------------------------------+
| `cmk -L`                  | [Check-Plugins auflisten](#info_plugins) |
+---------------------------+------------------------------------------+
| `cmk -m`                  | [Katalog der Check-Plugins               |
|                           | aufrufen](#info_plugins)                 |
+---------------------------+------------------------------------------+
| `cmk -M df`               | [Manual Page eines Check-Plugins         |
|                           | anzeigen](#info_plugins) (hier des       |
|                           | Plugins `df`)                            |
+---------------------------+------------------------------------------+
| **Spezialthemen**         |                                          |
+---------------------------+------------------------------------------+
| `cmk --update-dns-cache`  | Löscht den DNS-Cache und erzeugt ihn     |
|                           | neu. Details zum DNS-Cache finden Sie im |
|                           | [Artikel über die                        |
|                           | Hosts.](hosts_setup.html#dns) Dieser     |
|                           | Befehl wird in einer Checkmk-Instanz     |
|                           | standardmäßig einmal am Tag per Cronjob  |
|                           | durchgeführt.                            |
+---------------------------+------------------------------------------+
| `cmk --cleanup-piggyback` | Löscht alle veralteten                   |
|                           | [Piggyback-Daten](piggyback.html) im     |
|                           | Verzeichnis `tmp/check_mk/piggyback/`.   |
|                           | Dieser Befehl wird in einer              |
|                           | Checkmk-Instanz standardmäßig einmal am  |
|                           | Tag per Cronjob durchgeführt.            |
+---------------------------+------------------------------------------+
| `cmk -P`                  | [MKPs verwalten](mkps.html#commandline)  |
+---------------------------+------------------------------------------+
| `cmk --convert-rrds`      | [RRDs                                    |
|                           | kon                                      |
|                           | vertieren](graphing.html#customise_rrds) |
+---------------------------+------------------------------------------+
| `cmk --snmpwalk myswitch` | [SNMP-Walk ziehen](snmp.html#simulation) |
|                           | vom Host `myswitch`                      |
+---------------------------+------------------------------------------+
| `cmk --snmptranslate`     | [SNMP-Walk                               |
|                           | übersetzen](deve                         |
|                           | l_check_plugins_snmp.html#locating_oids) |
+---------------------------+------------------------------------------+
| `cmk -                    | [Support Diagnostics Dump                |
| -create-diagnostics-dump` | erstelle                                 |
|                           | n](support_diagnostics.html#commandline) |
+---------------------------+------------------------------------------+

::: paragraph
In einigen Modi stehen Ihnen weitere, spezifische Optionen zur
Verfügung, z.B. können Sie die Service-Erkennung auf bestimmte Checks
einschränken, z.B. mit dem Kommando
`cmk -I --detect-plugins=df myserver123` auf den Check `df`.
:::

::: paragraph
Einige Optionen funktionieren immer --- egal mit welchem Modus Sie den
Befehl aufrufen:
:::

+------------------------+---------------------------------------------+
| Option                 | Wirkung                                     |
+========================+=============================================+
| `cmk -v`               | Veranlasst `cmk` zu einer ausführlichen     |
|                        | Ausgabe dessen, was er gerade macht         |
|                        | („verbose").                                |
+------------------------+---------------------------------------------+
| `cmk -vv`              | Das Ganze noch etwas ausführlicher („very   |
|                        | verbose").                                  |
+------------------------+---------------------------------------------+
| `cmk --cache`          | Die Informationen werden aus Cache-Dateien  |
|                        | gelesen, auch wenn diese veraltet sind. Der |
|                        | Agent wird nur dann kontaktiert, wenn keine |
|                        | Cache-Datei existiert. Die                  |
|                        | zwischengespeicherten Agentendaten des      |
|                        | Hosts finden Sie unter                      |
|                        | `tmp/check_mk/cache`.                       |
+------------------------+---------------------------------------------+
| `cmk --no-tcp`         | Arbeitet wie `--cache`, bricht allerdings   |
|                        | ab, wenn keine Cache-Datei existiert oder   |
|                        | diese nicht aktuell ist. So können Sie      |
|                        | einen Zugriff auf den Agenten in jedem Fall |
|                        | unterbinden.                                |
+------------------------+---------------------------------------------+
| `cmk --no-cache`       | Die Informationen werden stets aktuell      |
|                        | abgeholt, d.h. es werden keine              |
|                        | Cache-Dateien verwendet.                    |
+------------------------+---------------------------------------------+
| `cmk --usewalk`        | Für SNMP-Hosts: Verwendet anstatt eines     |
|                        | Zugriffs auf den SNMP-Agenten einen         |
|                        | gespeicherten SNMP-Walk, der zuvor mit      |
|                        | `cmk --snmpwalk myserver123` gezogen wurde. |
|                        | Diese Walks liegen unter                    |
|                        | `var/check_mk/snmpwalks`.                   |
+------------------------+---------------------------------------------+
| `cmk --debug`          | Falls es zu einem Fehler kommt, sorgt diese |
|                        | Option dafür, dass dieser nicht mehr        |
|                        | abgefangen, sondern die ursprüngliche       |
|                        | Python-Exception vollständig angezeigt      |
|                        | wird. Das kann den Entwicklern als wichtige |
|                        | Information dienen, wo genau im Programm    |
|                        | der Fehler auftritt. Auch wird es Ihnen     |
|                        | sehr helfen, Fehler in selbst geschriebenen |
|                        | Check-Plugins zu lokalisieren. Falls Sie    |
|                        | bei einem Aufruf von `cmk` auf einen Fehler |
|                        | stoßen, den Sie dem Support oder als        |
|                        | Feedback melden möchten, rufen Sie bitte    |
|                        | den gleichen Befehl nochmal mit `--debug`   |
|                        | auf und fügen den Python-Trace in Ihre      |
|                        | E-Mail ein.                                 |
+------------------------+---------------------------------------------+

::: paragraph
Im Folgenden zeigen wir, wie Sie die Befehle verwenden können. Die
Beispielausgaben sind meist gekürzt dargestellt.
:::
:::::::::::

::::::::::::: sect2
### []{#commands_core .hidden-anchor .sr-only}4.2. Befehle für den Monitoring-Kern {#heading_commands_core}

::: paragraph
Die kommerziellen Editionen verwenden als Monitoring-Kern den [Checkmk
Micro Core](cmc.html) (CMC), bei der
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** kommt Nagios zum Einsatz. Eine wichtige Aufgabe von
`cmk` ist es, eine für den Kern lesbare Konfigurationsdatei zu erzeugen,
welche alle konfigurierten Hosts, Services, Kontakte, Kontaktgruppen,
Zeitperioden usw. enthält. Anhand dieser weiß der Kern, welche Checks er
ausführen muss und welche Objekte er per [Livestatus](livestatus.html)
der GUI bereitstellen soll.
:::

::: paragraph
Grundsätzlich gilt sowohl für Nagios also auch für den CMC, dass die
Menge der Hosts, Services und anderen Objekte zur Laufzeit immer
statisch ist und sich nur durch das Erstellen einer neuen Konfiguration
ändern kann, welche der Kern anschließend neu laden muss. Bei Nagios ist
dazu ein Neustart des Kerns nötigt. Der CMC beherrscht ein sehr
effizientes Neuladen der Konfiguration im laufenden Betrieb.
:::

::: paragraph
Folgende Tabelle zeigt wichtige Unterschiede bei der Konfiguration der
beiden Kerne:
:::

+-------------+-------------------------------+------------------------+
|             | Nagios                        | CMC                    |
+=============+===============================+========================+
| Konfigur    | `etc/nagios                   | `var                   |
| ationsdatei | /conf.d/check_mk_objects.cfg` | /check_mk/core/config` |
+-------------+-------------------------------+------------------------+
| Dateiart    | Textdatei mit                 | Komprimierte und       |
|             | `define`-Befehlen             | optimierte Binärdatei  |
+-------------+-------------------------------+------------------------+
| Aktivierung | Neustart des Kerns            | Befehl an den Kern zum |
|             |                               | Neuladen der           |
|             |                               | Konfiguration          |
+-------------+-------------------------------+------------------------+
| Befehl      | `cmk -R`                      | `cmk -O`               |
+-------------+-------------------------------+------------------------+

::: paragraph
Das Neuerzeugen der Konfiguration ist immer dann notwendig, wenn sich
Inhalte der Konfigurationsdateien unterhalb von `etc/check_mk/conf.d`
oder automatisch erkannte Services unter `var/check_mk/autochecks`
geändert haben. Das Setup führt Buch über solche Änderungen und zeigt
diese in der GUI als zu [aktivierende
Änderungen](wato.html#activate_changes) an. Falls Sie die Konfiguration
manuell oder durch Skripte „am Setup vorbei" modifizieren, müssen Sie
sich selbst um das Aktivieren kümmern. Dazu dienen folgende Befehle:
:::

+------------------------+---------------------------------------------+
| Option                 | Wirkung                                     |
+========================+=============================================+
| `cmk -R`               | Erzeugt eine neue Konfiguration für den     |
|                        | Kern und startet diesen dann neu (analog zu |
|                        | `omd restart core`). Das ist die bei Nagios |
|                        | vorgesehene Methode.                        |
+------------------------+---------------------------------------------+
| `cmk -O`               | Erzeugt die Konfiguration für den Kern und  |
|                        | lädt diese ohne einen Neustart im laufenden |
|                        | Betrieb (analog zu `omd reload core`). Das  |
|                        | ist die beim CMC empfohlene Variante.       |
|                        |                                             |
|                        | **Achtung:** Bei Nagios als Kern            |
|                        | funktioniert diese Option zwar auch, kann   |
|                        | aber zu Speicherlöchern und anderen         |
|                        | Instabilitäten führen. Außerdem wird dort   |
|                        | ohnehin kein echter Reload ausgeführt,      |
|                        | sondern nur der Prozess quasi innerlich     |
|                        | runter- und wieder hochgefahren.            |
+------------------------+---------------------------------------------+
| `cmk -U`               | Erzeugt die Konfiguration für den Kern,     |
|                        | *ohne* diese zu aktivieren.                 |
+------------------------+---------------------------------------------+
| `cmk -N`               | Gibt zu Diagnosezwecken die zu erzeugende   |
|                        | Konfiguration auf der Standardausgabe aus,  |
|                        | ohne die eigentliche Konfigurationsdatei zu |
|                        | ändern. Sie können dabei den Namen eines    |
|                        | Hosts angeben, um nur die Konfiguration     |
|                        | dieses Hosts zu sehen (z.B.                 |
|                        | `cmk -N myserver123`).                      |
+------------------------+---------------------------------------------+

::: paragraph
Zusammengefasst bedeutet das: Wenn Sie von Hand die
Checkmk-Konfiguration anpassen und die Änderungen aktivieren möchten,
benötigen Sie anschließend bei Nagios:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -R
```
:::
::::

::: paragraph
Und beim CMC:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -O
```
:::
::::
:::::::::::::

:::::::::: sect2
### []{#execute_checks .hidden-anchor .sr-only}4.3. Checks ausführen {#heading_execute_checks}

::: paragraph
Ein zweiter Modus von Checkmk befasst sich mit der Ausführung von
Checkmk-basierten Checks eines Hosts. Damit können Sie alle automatisch
erkannten und auch manuell hinzu konfigurierten Services sofort checken
lassen, ohne dass Sie dafür den Monitoring-Kern oder die GUI bemühen
müssen.
:::

::: paragraph
Geben Sie dazu `cmk --check` gefolgt vom Namen eines im Monitoring
konfigurierten Hosts ein. Da die Option `--check` die Standardoption von
`cmk` ist, können Sie diese auch weglassen. Außerdem sollten Sie immer
die beiden Optionen `-n` (Ergebnisse nicht an den Kern übermitteln) und
`-v` (alle Ergebnisse ausgeben) hinzufügen. Dazu mehr bei der
Beschreibung der Optionen weiter unten.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -nv myserver123
Checkmk version 2.0.0p8
CPU load             15 min load 0.22 at 8 Cores (0.03 per Core)
CPU utilization      Total CPU: 8.20%
Disk IO SUMMARY      Read: 14.0 kB/s, Write: 316 kB/s, Latency: 442 microseconds
Filesystem /         82.0% used (177.01 of 215.81 GB), (warn/crit at 80.00/90.00%),
Interface 2          [wlo1], (up), MAC: 5C:80:B6:3E:38:7F, Speed: unknown, In: 1.02 kB/s, Out: 902 B/s
Kernel Performance   Process Creations: 67.82/s, Context Switches: 4183.41/s, Major Page Faults: 1.71/s, Page Swap in: 0.00/s, Page Swap Out: 0.00/s
Memory               Total virtual memory: 37.07% - 6.08 GB of 16.41 GB
Mount options of /   Mount options exactly as expected
NTP Time             sys.peer - stratum 2, offset 16.62 ms, jitter 5.19 ms, last reac
Number of threads    Count: 1501 threads, Usage: 1.19%
TCP Connections      Established: 11
Temperature Zone 0   25.0 °C
Uptime               Up since Jul 29 2021 08:38:32, Uptime: 4 hours 43 minutes
[agent] Version: 2.0.0b5, OS: linux, execution time 0.9 sec | execution_time=0.850 user_time=0.050 system_time=0.010 children_user_time=0.000 children_system_time=0.000 cmk_time_agent=0.800
```
:::
::::

::: paragraph
Hinweise dazu:
:::

::: ulist
- Verwenden Sie diesen Befehl nicht bei produktiv überwachten Hosts,
  welche Logdatei-Monitoring verwenden. Log-Meldungen werden vom Agenten
  nur einmal gesendet. Es kann Ihnen passieren, dass Ihr manueller
  `cmk -nv` diese „erwischt" und sie dann für das Monitoring verloren
  sind. Verwenden Sie in diesem Fall die Option `--no-tcp`.

- Wenn Sie Nagios als Kern verwenden und `-n` weglassen, führt das zu
  einer sofortigen Aktualisierung der Check-Ergebnisse im Kern und in
  der GUI.

- Der Befehl ist nützlich beim Entwickeln eigener Check-Plugins, weil so
  ein schnellerer Test möglich ist als über die GUI. Falls der Check in
  einen Fehler läuft und [UNKNOWN]{.state3} wird, hilft die Option
  `--debug` die genaue Stelle im Code zu finden.
:::

::: paragraph
Folgende Optionen beeinflussen den Befehl:
:::

+------------------------+---------------------------------------------+
| Option                 | Wirkung                                     |
+========================+=============================================+
| `-v`                   | Check-Ergebnisse ausgeben: Ohne diese       |
|                        | Option sehen Sie nur die Ausgabe des        |
|                        | Services [Check_MK]{.guihint} selbst und    |
|                        | nicht die Resultate der anderen Services.   |
+------------------------+---------------------------------------------+
| `-n`                   | Trockenlauf: Ergebnisse **nicht** an den    |
|                        | Kern übermitteln, Performance Counter nicht |
|                        | aktualisieren.                              |
+------------------------+---------------------------------------------+
| `--det                 | Beschränkt die Ausführung auf die           |
| ect-plugins=df,uptime` | Check-Plugins `df` und `uptime`. Im Falle   |
|                        | von SNMP-Hosts werden auch nur die dafür    |
|                        | benötigten Daten geholt. Diese Option ist   |
|                        | praktisch, wenn Sie eigene Check-Plugins    |
|                        | entwickeln und nur diese testen möchten.    |
+------------------------+---------------------------------------------+
::::::::::

::::::: sect2
### []{#dump_agent .hidden-anchor .sr-only}4.4. Agentenausgabe holen {#heading_dump_agent}

::: paragraph
`cmk -d` holt die Ausgabe des Checkmk-Agenten eines Hosts und zeigt sie
an. Die Agentendaten werden bei `cmk -d` auf dem gleichen Weg geholt wie
während des Monitorings und weder geprüft noch aufbereitet. Damit
entsprechen die angezeigten Daten den Daten, die bei aktivierter
TLS-Verschlüsselung dem Agent Controller oder bei Verwendung eines
[Datenquellenprogramms](datasource_programs.html) dem übertragenden
Programm übergeben werden.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -d myserver123
<<<check_mk>>>
Version: 2.1.0b5
AgentOS: linux
Hostname: myserver123
AgentDirectory: /etc/check_mk
DataDirectory: /var/lib/check_mk_agent
SpoolDirectory: /var/lib/check_mk_agent/spool
PluginsDirectory: /usr/lib/check_mk_agent/plugins
LocalDirectory: /usr/lib/check_mk_agent/local
OnlyFrom:
<<<df>>>
udev              devtmpfs     8155492         4   8155488       1% /dev
tmpfs             tmpfs        1634036      1208   1632828       1% /run
/dev/sda5         ext4       226298268 175047160  39732696      82% /
none              tmpfs              4         0         4       0% /sys/fs/cgroup
```
:::
::::

::: paragraph
Sie können `cmk -d` sogar mit dem Namen oder der IP-Adresse eines Hosts
aufrufen, der nicht im Monitoring angelegt ist. In diesem Fall werden
für den Host Legacy-Einstellungen angenommen (TCP-Verbindung zu Port
6556, kein Agent Controller, keine Verschlüsselung, kein
Datenquellenprogramm).
:::
:::::::

:::::::::::: sect2
### []{#bake_agents .hidden-anchor .sr-only}4.5. Agenten backen {#heading_bake_agents}

::: paragraph
In den kommerziellen Editionen können Sie die Agenten auch von der
Kommandozeile backen, so wie Sie es sonst über die
[Weboberfläche](wato_monitoringagents.html#bakery) tun würden. Damit
haben Sie z.B. die Möglichkeit, die Agenten regelmäßig zu aktualisieren,
etwa über einen Cronjob.
:::

::: paragraph
Zum Backen der Agenten dient die Option `-A`, gefolgt vom Namen eines
Hosts (oder auch von mehreren):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -Av myserver123
myserver123...linux_deb:baking...linux_rpm:baking...(fast repackage)...solaris_pkg:baking...windows_msi:baking...linux_tgz:baking...(fast repackage)...solaris_tgz:baking...(fast repackage)...aix_tgz:baking...OK
```
:::
::::

::: paragraph
Die Ausgabe zeigt, dass die für den Host `myserver123` verfügbaren
Agentenpakete erfolgreich gebacken wurden. Wenn Sie keinen Host angeben,
werden die Pakete für alle Hosts gebacken.
:::

::: paragraph
Das Kommando backt nur dann, wenn es notwendig ist. Falls die Pakete
noch aktuell sind, sieht die Ausgabe etwa so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -Av myserver123
myserver123...linux_deb:uptodate...linux_rpm:uptodate...solaris_pkg:uptodate...windows_msi:uptodate...linux_tgz:uptodate...solaris_tgz:uptodate...aix_tgz:uptodate...OK
```
:::
::::

::: paragraph
Mit der Option `-f` (*force*) können Sie das Backen trotzdem erzwingen.
:::
::::::::::::

:::::::::::::::: sect2
### []{#list_hosts .hidden-anchor .sr-only}4.6. Hosts auflisten {#heading_list_hosts}

::: paragraph
Der Befehl `cmk -l` listet einfach die Namen aller im Setup
eingerichteten Hosts auf:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -l
myserver123
myserver124
myserver125
```
:::
::::

::: paragraph
Da die Daten „nackt" und ohne Verzierungen ausgegeben werden, können Sie
sie leicht in Skripten nutzen. Zum Beispiel können Sie damit eine
Schleife über alle Hostnamen bauen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ for host in $(cmk -l) ; do echo "Host: $host" ; done
Host: myserver123
Host: myserver124
Host: myserver125
```
:::
::::

::: paragraph
Wenn Sie jetzt anstelle des `echo` einen Befehl einsetzen, der etwas
Sinnvolles macht, kann das wirklich nützlich sein.
:::

::: paragraph
Der Aufruf `cmk --list-tag` gibt ebenfalls Hostnamen aus, bietet dabei
aber die Möglichkeit, nach [Host-Merkmalen](glossar.html#host_tag) zu
filtern. Geben Sie einfach ein Host-Merkmal an und Sie erhalten alle
Hosts, die dieses Merkmal besitzen. Folgendes Beispiel listet alle Host
auf, die per SNMP überwacht werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --list-tag snmp
myswitch01
myswitch02
myswitch03
```
:::
::::

::: paragraph
Geben Sie mehrere Merkmale an, so werden diese per UND verknüpft.
Folgendes Kommando liefert alle Hosts, die gleichzeitig per SNMP **und**
Checkmk-Agenten überwacht werden. Da keine Hosts diese Bedingung
erfüllen, bleibt die Ausgabe leer:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk --list-tag snmp tcp
```
:::
::::
::::::::::::::::

:::::: sect2
### []{#dump_host .hidden-anchor .sr-only}4.7. Host-Konfiguration anzeigen {#heading_dump_host}

::: paragraph
`cmk -D` zeigt für einen oder mehrere Hosts die konfigurierten Services,
Host-Merkmale, Labels und andere Attribute. Da die Liste der Services
sehr breit ist, kann das Ganze im Terminal etwas unübersichtlich
aussehen. Schicken Sie die Ausgabe durch `less -S` um einen Umbruch zu
vermeiden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -D myserver123 | less -S
myserver123
Addresses:              192.168.178.34
Tags:                   [address_family:ip-v4-only], [agent:cmk-agent], [criticality:prod], [ip-v4:ip-v4], [networking:lan], [piggyback:auto-piggyback], [site:mysite], [tcp:tcp]
Labels:                 [cmk/check_mk_server:yes], [cmk/os_family:linux]
Host groups:            mylinuxservers
Contact groups:         all
Agent mode:             Normal Checkmk agent, or special agent if configured
Type of agent:
  TCP: 192.168.178.34:6556
  Process piggyback data from /omd/sites/mysite/tmp/check_mk/piggyback/mycmkserver
Services:
Type of agent:          TCP (port: 6556)
Is aggregated:          no
Services:
  checktype        item              params
  ---------------- ----------------- ------------
  cpu.loads        None              (5.0, 10.0)
  kernel.util      None              {}
```
:::
::::
::::::

::::::::::::::::::::::: sect2
### []{#info_plugins .hidden-anchor .sr-only}4.8. Informationen zu den Check-Plugins {#heading_info_plugins}

::: paragraph
Checkmk liefert eine große Zahl von fertigen Plugins mit aus. In jedem
Release kommen etliche dazu und Version [2.0.0]{.new} umfasst bereits
über 2.000 Plugins. Drei Optionen des Befehls `cmk` bieten Ihnen Zugriff
auf Informationen zu diesen Plugins.
:::

::: paragraph
`cmk -L` gibt in einer Tabelle alle Plugins mit Namen, Typ und
Beschreibung aus. Dabei werden auch solche aufgelistet, welche Sie
eventuell per Hand unterhalb von `local/` nachinstalliert haben.
:::

::: paragraph
Beim Typ gibt es die folgenden Werte:
:::

+-------------+--------------------------------------------------------+
| `agent`     | Wertet Daten eines Checkmk-Agenten aus. Dieser wird    |
|             | (normalerweise) per TCP Port 6556 abgerufen.           |
+-------------+--------------------------------------------------------+
| `snmp`      | Dient zur Überwachung von Geräten via SNMP.            |
+-------------+--------------------------------------------------------+
| `active`    | Ruft für die Überwachung ein Nagios-kompatibles Plugin |
|             | nach klassischer Art auf. Hier übernimmt Checkmk       |
|             | eigentlich nur die Konfiguration.                      |
+-------------+--------------------------------------------------------+

::: paragraph
Natürlich können Sie in der Liste einfach mit `grep` filtern, wenn Sie
nach etwas Bestimmten suchen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -L | grep f5
f5_bigip_apm                      snmp   F5 Big-IP: number of current SSL/VPN connections
f5_bigip_chassis_temp             snmp   F5 Big-IP: Chassis temperature
f5_bigip_cluster                  snmp   F5 Big-IP: Cluster state, up to firmware version 10
f5_bigip_cluster_status           snmp   F5 Big-IP: active/active or passive/active cluster status
f5_bigip_cluster_status.v11_2     snmp   F5 Big-IP: active/active or passive/active cluster status
f5_bigip_cluster_status_v11_2     snmp   F5 Big-IP: active/active or passive/active cluster status
f5_bigip_cluster_v11              snmp   F5 Big-IP: Cluster state for firmware version >= 11
f5_bigip_conns                    snmp   F5 Big-IP: number of current connections
f5_bigip_cpu_temp                 snmp   F5 Big-IP: CPU temperature
f5_bigip_fans                     snmp   F5 Big-IP: System fans
f5_bigip_interfaces               snmp   F5 Big-IP: Special Network Interfaces
f5_bigip_mem                      snmp   F5 Big-IP: Usage of memory
f5_bigip_mem.tmm                  snmp   F5 Big-IP: Usage of TMM memory
f5_bigip_pool                     snmp   F5 Big-IP: Load Balancing Pools
f5_bigip_psu                      snmp   F5 Big-IP: Power Supplies
f5_bigip_snat                     snmp   F5 Big-IP: Source NAT
f5_bigip_vcmpfailover             snmp   F5 Big-IP: active/active or passive/active vCMP guest failover status
f5_bigip_vcmpguests               snmp   F5 Big-IP: show failover states of all vCMP guests running on a vCMP host
f5_bigip_vserver                  snmp   F5 Big-IP: Virtual servers
```
:::
::::

::: paragraph
Wenn Sie zu einem der Plugins mehr Information möchten, können Sie
dessen Dokumentation als *Manual Page* (oder *Man Page*) mit `cmk -M`
aufrufen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -M f5_bigip_pool
```
:::
::::

::: paragraph
Das ergibt dann folgende Ausgabe:
:::

:::: imageblock
::: content
![Beispiel einer Check-Plugin Manual
Page.](../images/check_manpage_example.png)
:::
::::

::: paragraph
Mit einem `cmk -m` ohne weitere Angaben kommen Sie in den kompletten
Katalog aller Check-Plugin Man Pages:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk -m
```
:::
::::

::: paragraph
Hier können Sie interaktiv navigieren:
:::

:::: imageblock
::: content
![Hauptmenü zur Auswahl einer Manual
Page.](../images/cmk_commandline_manpage_catalog_level1.png){width="65%"}
:::
::::

:::: imageblock
::: content
![Untermenü zur Auswahl einer Manual
Page.](../images/cmk_commandline_manpage_catalog_level2.png){width="65%"}
:::
::::
:::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#config .hidden-anchor .sr-only}5. Konfiguration ohne Setup {#heading_config}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Das [Setup-Menü](wato.html) ist ein tolles Konfigurationswerkzeug. Aber
es gibt gute Gründe, eine Konfiguration mit Textdateien in guter alter
Linux-Tradition zu bevorzugen. Wenn auch Sie diese Meinung haben, gibt
es für Sie eine gute Nachricht: Sie können Checkmk vollständig über
Textdateien konfigurieren. Und da die Aktionen im [Setup]{.guihint}-Menü
ebenfalls nichts anderes machen, als (dieselben) Textdateien zu
bearbeiten, ist das noch nicht einmal ein Entweder/Oder.
:::

:::::::::::::::: sect2
### []{#_wo_ist_die_dokumentation .hidden-anchor .sr-only}5.1. Wo ist die Dokumentation? {#heading__wo_ist_die_dokumentation}

::: paragraph
Falls Sie jetzt allerdings ein umfassendes Kompendium über den genauen
Aufbau von allen von Checkmk verwendeten Konfigurationsdateien erwarten,
müssen wir Sie an dieser Stelle leider enttäuschen. Die Komplexität und
Vielfalt, die in den Konfigurationsdateien steckt, ist einfach viel zu
groß, um sie in diesem Handbuch komplett zu beschreiben.
:::

::: paragraph
Folgendes Beispiel zeigt einen komplett ausgefüllten Parametersatz für
das Check-Plugin, welches in Checkmk Dateisysteme überwacht. Wegen der
vielen Parameter ist der Screenshot in zwei Teile zerlegt und in kleiner
Schrift gesetzt:
:::

:::: {.imageblock .border}
::: content
![Kompletter Parametersatz des Check-Plugins zur Überwachung von
Dateisystemen.](../images/cmk_commandline_parameters_for_df_check.png)
:::
::::

::: paragraph
Die entsprechende Passage dazu in der Konfigurationsdatei sieht (etwas
hübscher formatiert) so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
{ 'inodes_levels'      : (10.0, 5.0),
  'levels'             : (80.0, 90.0),
  'levels_low'         : (50.0, 60.0),
  'magic'              : 0.8,
  'magic_normsize'     : 20,
  'show_inodes'        : 'onlow',
  'show_levels'        : 'onmagic',
  'show_reserved'      : True,
  'subtract_reserved'  : False,
  'trend_mb'           : (100, 200),
  'trend_perc'         : (5.0, 10.0),
  'trend_perfdata'     : True,
  'trend_range'        : 24,
  'trend_showtimeleft' : True,
  'trend_timeleft'     : (12, 6)},
```
:::
::::

::: paragraph
Wie Sie sehen, gibt es hier mehr als 10 verschiedene Parameter, die
jeweils eine ganz eigene Logik haben. Manche werden über
Fließkommazahlen (`0.8`), manche über Ganzzahlen (`24`), manche über
Schlüsselworte (`'onlow'`), manche über boolesche Werte (`True`) und
andere wieder über Tupel aus solchen Dingen konfiguriert
(`(5.0, 10.0)`).
:::

::: paragraph
Dieses Beispiel ist nur eines von über 2.000 Plugins. Und dann gibt es
ja auch noch andere Konfigurationen als Check-Parameter: Man denke nur
an Zeitperioden, Regeln der Event Console, Benutzerprofile und vieles
mehr.
:::

::: paragraph
Das soll natürlich nicht heißen, dass Sie auf eine Konfiguration über
Textdateien verzichten müssen! Wenn Sie die genaue Syntax für die
Konfigurationsaufgabe Ihrer Wahl noch nicht kennen, brauchen Sie dafür
nur das richtige Werkzeug --- und das heißt: **Setup:**
:::

::: {.olist .arabic}
1.  Erzeugen Sie eine Testinstanz von Checkmk.

2.  Konfigurieren Sie dort die gewünschten Parameter mit dem
    [Setup]{.guihint}-Menü.

3.  Suchen Sie die dadurch veränderte Konfigurationsdatei (dazu gleich
    mehr).

4.  Übernehmen Sie die exakte Syntax des betroffenen Abschnitts aus
    dieser Datei in Ihr Produktivsystem.
:::

::: paragraph
Sie müssen also nur wissen, in welche Datei das Setup was schreibt.
:::

::: paragraph
**Hinweis:** Wenn es um die Namen von Dateiverzeichnissen, Dateien oder
auch um Dateiinhalte geht, werden Sie des öfteren die Bezeichnung `wato`
finden. **WATO** ist die Abkürzung für Web Administration Tool: das
Checkmk-Konfigurationswerkzeug bis einschließlich zur Version
[1.6.0]{.new}. Die Funktion von WATO hat ab der Version [2.0.0]{.new}
das [Setup]{.guihint}-Menü, oder auch kurz **Setup**, übernommen. Obwohl
WATO in der Weboberfläche (fast) vollständig durch Setup ersetzt wurde,
lebt es im Dateisystem weiter.
:::
::::::::::::::::

::::::: sect2
### []{#_welche_konfigurationsdatei_wird_verwendet .hidden-anchor .sr-only}5.2. Welche Konfigurationsdatei wird verwendet? {#heading__welche_konfigurationsdatei_wird_verwendet}

::: paragraph
Um herauszufinden, welche Datei Setup gerade verändert hat, gibt es
einen praktischen Befehl: `find`. Mit folgenden Parametern aufgerufen,
finden Sie alle Dateien (`-type f`) unterhalb von `etc/`, welche
innerhalb der letzten Minute (`-mmin -1`) geändert wurden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ find etc/ -mmin -1 -type f
etc/check_mk/conf.d/wato/rules.mk
```
:::
::::

::: paragraph
Die Basis der Konfiguration ist immer das Verzeichnis `etc/check_mk`.
Darunter gibt es eine Aufteilung in verschiedene Domänen, welche meist
einen bestimmten Dienst betreffen. Dabei gibt es jeweils ein Verzeichnis
mit der Endung `.d`, unterhalb dessen alle Dateien mit der Endung `.mk`
automatisch und in *alphabetischer Reihenfolge* eingelesen werden. Bei
manchen gibt es noch eine Hauptdatei, welche als Erstes eingelesen wird.
Diese wird vom Setup nie angefasst und ist nur für manuelle Änderungen
vorgesehen.
:::

+-----------------+--------------------+-------------+-----------------+
| Domäne          | Konfigu            | Hauptdatei  | Änderungen      |
|                 | rationsverzeichnis |             | aktivieren      |
+=================+====================+=============+=================+
| Monitoring      | `etc               | `main.mk`   | `cmk -O` bzw.   |
|                 | /check_mk/conf.d/` |             | `cmk -R`        |
+-----------------+--------------------+-------------+-----------------+
| [GUI](user_     | `etc/chec          | `mu         | automatisch     |
| interface.html) | k_mk/multisite.d/` | ltisite.mk` |                 |
+-----------------+--------------------+-------------+-----------------+
| [Event          | `etc/che           | `m          | `omd r          |
| Co              | ck_mk/mkeventd.d/` | keventd.mk` | eload mkeventd` |
| nsole](ec.html) |                    |             |                 |
+-----------------+--------------------+-------------+-----------------+
| [Benachr        | `etc/chec          |             | automatisch     |
| ichtigungs-Spoo | k_mk/mknotifyd.d/` |             |                 |
| ler](notificati |                    |             |                 |
| ons.html#async) |                    |             |                 |
+-----------------+--------------------+-------------+-----------------+
:::::::

:::::::::::::::::::::: sect2
### []{#_setup_und_konfigurationsdateien .hidden-anchor .sr-only}5.3. Setup und Konfigurationsdateien {#heading__setup_und_konfigurationsdateien}

::: paragraph
Unterhalb der `.d/`-Konfigurationsverzeichnisse gibt es immer das
Unterverzeichnis `wato`, z.B. `etc/check_mk/conf.d/wato`. Das Setup
liest und schreibt grundsätzlich nur dort. Der für das
Konfigurationsverzeichnis zuständige Dienst liest aber auch die übrigen
Dateien in „seinem" `.d`-Verzeichnis, falls Sie dort welche von Hand
anlegen. Das bedeutet:
:::

::: ulist
- Möchten Sie, dass Ihre manuelle Konfiguration im Setup sichtbar und
  editierbar wird, so verwenden Sie die existierenden Pfade.

- Möchten Sie, dass Ihre Konfiguration einfach nur wirksam, aber im
  Setup nicht sichtbar wird, so verwenden Sie eigene Dateien außerhalb
  von `wato/`.

- Möchten Sie, dass Ihre Konfiguration im Setup sichtbar, aber nicht
  änderbar wird, so können Sie manche der Dateien *sperren.*
:::

::::::::::::::::::: sect3
#### []{#_sperren_von_dateien_und_ordnern .hidden-anchor .sr-only}Sperren von Dateien und Ordnern {#heading__sperren_von_dateien_und_ordnern}

::: paragraph
Ein häufiger Grund für das manuelle Erzeugen von Konfigurationsdateien
ohne Setup ist der Import von zu überwachenden Hosts aus einer
Configuration Management Database (CMDB). Im Gegensatz zur Methode über
die [REST-API](rest_api.html) erzeugen Sie hier mit einem Skript direkt
in `etc/check_mk/conf.d/wato` die Ordner für die Hosts und darin jeweils
die Datei `hosts.mk` für die im Ordner enthaltenen Hosts und eventuell
auch die Datei `.wato`, welche die Ordnereigenschaften enthält.
:::

::: paragraph
Wenn dieser Import nicht nur einmalig geschieht, sondern regelmäßig
wiederholt wird, weil die CMDB das führende System ist, wäre es sehr
ungünstig, wenn Ihre Benutzer über das Setup irgendwelche Änderungen an
den Dateien machen würden. Denn diese gingen dann beim nächsten Import
verloren.
:::

::: paragraph
Eine `hosts.mk`-Datei können Sie sperren, indem Sie eine Zeile für das
Attribut `lock` einfügen:
:::

::::: listingblock
::: title
hosts.mk
:::

::: content
``` {.pygments .highlight}
# Created by WATO
# encoding: utf-8

_lock = True
```
:::
:::::

::: paragraph
Beim Öffnen dieses Ordners im Setup wird über der Hosts-Liste die
folgende Meldung angezeigt:
:::

:::: imageblock
::: content
![Meldung, dass die Bearbeitung von Hosts im Ordner gesperrt
ist.](../images/cmk_commandline_locked_host_attributes.png)
:::
::::

::: paragraph
Sämtliche Aktionen, welche eine Änderung an der Datei `hosts.mk`
erfordern würden, sind in der GUI dann gesperrt. Das betrifft übrigens
*nicht* die Service-Erkennung. Die konfigurierten Services eines Hosts
werden unter `var/check_mk/autochecks/` gespeichert.
:::

::: paragraph
Sie können auch die Ordnereigenschaften sperren. Dies geschieht durch
einen Eintrag in der Datei `.wato` des Ordners: Setzen Sie im Dictionary
der Datei das Attribut `lock` auf `True`:
:::

::::: listingblock
::: title
.wato
:::

::: content
``` {.pygments .highlight}
{'title': 'My folder',
 'attributes': {},
 'num_hosts': 1,
 'lock': True,
 'lock_subfolders': False,
 '__id': '7f2a8906d3c3448fac8a379e2d1cec0e'}
```
:::
:::::

::: paragraph
Setzen Sie auch noch das Attribut `lock_subfolders` auf `True`, so
verhindern Sie das Anlegen und Löschen von Unterordnern.
:::

::: paragraph
Das Sperren von anderen Dateien --- wie z.B. `rules.mk` --- ist aktuell
nicht möglich.
:::
:::::::::::::::::::
::::::::::::::::::::::

::::::::::: sect2
### []{#_die_syntax_der_dateien .hidden-anchor .sr-only}5.4. Die Syntax der Dateien {#heading__die_syntax_der_dateien}

::: paragraph
Rein formal gilt für alle Konfigurationsdateien von Checkmk, dass diese
in **Python 3**-Syntax geschrieben sind. Dabei gibt es zwei Arten von
Dateien:
:::

::: ulist
- solche, die von Python wie ein Skript *ausgeführt* werden, wozu z.B.
  `hosts.mk` gehört und

- solche, die von Python als Wert eingelesen werden, wozu z.B. `.wato`
  gehört.
:::

::: paragraph
Die ausführbaren Dateien erkennen Sie daran, dass hier Variablen durch
Zuweisungen (`=`) mit Werten belegt werden. Die anderen Dateien
enthalten meist ein Python-Dictionary, welches mit einer öffnenden
geschweiften Klammer beginnt. Manchmal sind es auch einfache Werte.
:::

::: paragraph
Falls Sie in einer Datei ein Nicht-ASCII-Zeichen benötigen (z.B. einen
deutschen Umlaut) so müssen Sie in die erste oder zweite Zeile folgenden
Kommentar einfügen:
:::

::::: listingblock
::: title
somefile.mk
:::

::: content
``` {.pygments .highlight}
# encoding: utf-8
```
:::
:::::

::: paragraph
Andernfalls wird es beim Einlesen zu einem Syntaxfehler kommen. Für
weitere Hinweise zur Syntax von Python verweisen wir auf dafür
spezialisierte Seiten, zum Beispiel auf die [offizielle Referenz von
Python 3](https://docs.python.org/3/reference/).
:::
:::::::::::

::::::: sect2
### []{#check_config_files .hidden-anchor .sr-only}5.5. Konfigurationsdateien überprüfen {#heading_check_config_files}

::: paragraph
Wenn Sie Konfigurationsdateien in `etc/check_mk/` händisch editieren,
bietet es sich an, die Konfiguration prüfen zu lassen. Dies können Sie
mit dem Tool `cmk-update-config` erledigen, welches eigentlich nur
automatisch nach einem Versionsupdate mit `omd update` ausgeführt wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk-update-config
...
Verifying Checkmk configuration...
 01/05 Cleanup precompiled host and folder files...
 02/05 Rulesets...
Exception while trying to load rulesets: Cannot read configuration file "/omd/sites/mysite/etc/check_mk/conf.d/wato/rules.mk":
 '[' was never closed (<string>, line 44)

You can abort the update process (A) and try to fix the incompatibilities or try to continue the update (c).
Abort update? [A/c]
...
```
:::
::::

::: paragraph
Im Auszug oben sehen Sie beispielsweise den Hinweis auf eine nicht
geschlossene Klammer.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
