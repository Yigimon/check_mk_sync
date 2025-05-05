:::: {#header}
# Benachrichtigungen

::: details
[Last modified on 26-Feb-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Quittierung von Problemen](basics_ackn.html) [Kommandos](commands.html)
[Benutzer, Zuständigkeiten, Berechtigungen](wato_user.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
:::: {.imageblock .inline-image}
::: content
![Symbol einer
Benachrichtigung.](../images/notifications_large_icon_notifications.png){width="80"}
:::
::::

::: paragraph
Benachrichtigung bedeutet, dass Benutzer im Falle von Problemen oder
anderen Ereignissen im Monitoring von Checkmk aktiv informiert werden.
Im häufigsten Fall geschieht das durch E-Mails. Es gibt aber auch viele
andere Methoden, wie z.B. das Versenden von SMS oder die Weiterleitung
an ein Ticketsystem. Checkmk bietet eine einfache Schnittstelle, um für
eigene Benachrichtigungsmethoden Skripte zu schreiben.
:::

::: paragraph
Ausgangspunkt für jede Benachrichtigung an einen Benutzer ist ein vom
Monitoring-Kern gemeldetes Ereignis. Wir nennen dies im folgenden
**Monitoring-Ereignis**, um Verwechslungen mit den Ereignissen zu
vermeiden, die von der [Event Console](ec.html) verarbeitet werden. Ein
Monitoring-Ereignis bezieht sich immer auf einen bestimmten Host oder
Service. Mögliche Typen von Monitoring-Ereignissen sind:
:::

::: ulist
- Ein Zustandswechsel, z.B. [OK]{.state0} → [WARN]{.state1}

- Der Wechsel zwischen einem stetigen und einem [![Symbol zur Anzeige
  des unstetigen
  Zustands.](../images/icons/icon_flapping.png)]{.image-inline}
  unstetigen (*flapping*) Zustand

- Start oder Ende einer [![Symbol zur Anzeige der Wartungszeit bei
  Services.](../images/icons/icon_downtime.png)]{.image-inline}
  [Wartungszeit](basics_downtimes.html)

- Die [![Symbol zur Anzeige der
  Quittierung.](../images/icons/icon_ack.png)]{.image-inline}
  [Quittierung eines Problems](basics_ackn.html) durch einen Benutzer

- Eine durch ein [![Symbol zur Anzeige eines
  Kommandos.](../images/icons/icon_commands.png)]{.image-inline}
  [Kommando](commands.html) manuell ausgelöste Benachrichtigung

- Die Ausführung eines [![Symbol eines Alert
  Handlers.](../images/icons/icon_alert_handlers.png)]{.image-inline}
  [Alert Handlers](alert_handlers.html)

- Ein Ereignis, das von der [![Symbol der Event
  Console.](../images/icons/icon_event_console.png)]{.image-inline}
  [Event Console](ec.html) zur Benachrichtigung übergeben wurde
:::

::: paragraph
Checkmk verfügt über ein regelbasiertes System, mit dem Sie aus diesen
Monitoring-Ereignissen Benutzerbenachrichtigungen erstellen lassen
können, und mit dem Sie auch sehr anspruchsvolle Anforderungen umsetzen
können. Eine einfache Benachrichtigung per E-Mail --- wie sie in vielen
Fällen zunächst völlig ausreicht --- ist trotzdem schnell eingerichtet.
:::
:::::::::
::::::::::

::::::::::: sect1
## []{#notify_or_not .hidden-anchor .sr-only}2. Benachrichtigen oder (noch) nicht benachrichtigen? {#heading_notify_or_not}

:::::::::: sectionbody
::: paragraph
Grundsätzlich sind Benachrichtigungen optional und Sie können Checkmk
durchaus auch ohne diese sinnvoll nutzen. Manche großen Unternehmen
haben eine Art Leitstand, in der das Monitoring-Team die
Checkmk-Oberfläche ständig im Blick hat und keine zusätzlichen
Benachrichtigungen benötigt. Wenn Sie noch im Aufbau Ihrer
Checkmk-Umgebung sind, sollten Sie außerdem bedenken, dass
Benachrichtigungen erst dann für Ihre Kollegen eine Hilfe sind, wenn
keine oder nur selten **Fehlalarme** (*false positives*) produziert
werden. Dazu müssen Sie erst einmal die Schwellwerte und alle anderen
Einstellungen soweit im Griff haben, dass im Normalfall alle Zustände
[OK]{.state0} / [UP]{.hstate0} sind oder mit anderen Worten: alles
„grün" ist.
:::

::: paragraph
Die Akzeptanz für das neue Monitoring ist schnell dahin, wenn es den
Posteingang jeden Tag mit Hunderten nutzloser E-Mails flutet.
:::

::: paragraph
Folgendes Vorgehen hat sich bewährt:
:::

::: paragraph
**Schritt 1:** Feinjustieren Sie das Monitoring, indem Sie einerseits
die durch Checkmk neu aufgedeckten, tatsächlichen Probleme beheben und
andererseits Fehlalarme eliminieren. Tun Sie das, bis im Normalfall
alles [OK]{.state0} / [UP]{.hstate0} ist. Im [Leitfaden für
Einsteiger](intro_finetune.html#filesystems) finden Sie einige
Empfehlungen, um typische Fehlalarme zu reduzieren.
:::

::: paragraph
**Schritt 2:** Schalten Sie Benachrichtigungen zunächst nur für sich
selbst ein. Reduzieren Sie das „Rauschen", welches durch sporadisch kurz
auftretende Probleme verursacht wird. Passen Sie dazu weitere
Schwellwerte an, nutzen Sie ggf. das [prognosebasierte
Monitoring](predictive_monitoring.html), erhöhen Sie die [Anzahl der
Check-Versuche](#repeated_check_attempts) oder versuchen Sie es mit der
[verzögerten Benachrichtigung](#delaying). Wenn es sich allerdings um
tatsächliche Probleme handelt, sollten Sie deren Ursache finden, um sie
in den Griff zu bekommen.
:::

::: paragraph
**Schritt 3:** Erst wenn in Ihrem eigenen Posteingang einigermaßen Ruhe
eingekehrt ist, schalten Sie die Benachrichtigungen für Ihre Kollegen
ein. Richten Sie dazu sinnvolle Kontaktgruppen ein, so dass jeder nur
solche Benachrichtigungen bekommt, die ihn auch wirklich etwas angehen.
:::

::: paragraph
Das Ergebnis ist ein sehr nützliches System, das Ihnen und Ihren
Kollegen hilft, mit relevanten Informationen Ausfallzeiten zu
reduzieren.
:::
::::::::::
:::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#simple_mail .hidden-anchor .sr-only}3. Einfache Benachrichtigung per E-Mail {#heading_simple_mail}

::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Eine von Checkmk versendete Benachrichtigung per E-Mail im HTML-Format
sieht etwa so aus:
:::

:::: {.imageblock .border}
::: content
![Eine Benachrichtigung per E-Mail.](../images/html_notification.png)
:::
::::

::: paragraph
Wie im Beispiel zu sehen ist, enthält die E-Mail auch die aktuellen
[Messwerte](graphing.html) des betroffenen Services.
:::

::: paragraph
Bevor Sie eine solche E-Mail von Checkmk erhalten, sind ein paar
Vorbereitungen notwendig, die im Folgenden beschrieben sind.
:::

::::: sect2
### []{#_voraussetzungen .hidden-anchor .sr-only}3.1. Voraussetzungen {#heading__voraussetzungen}

::: paragraph
In der Standardkonfiguration von Checkmk erhält ein Benutzer
Benachrichtigungen per E-Mail, wenn folgende Voraussetzungen erfüllt
sind:
:::

::: ulist
- Der Checkmk-Server hat ein funktionierendes [Setup für das Versenden
  von E-Mails](#smtp).

- Für den [Benutzer](wato_user.html#user_config) ist eine E-Mail-Adresse
  konfiguriert.

- Der Benutzer ist Mitglied einer
  [Kontaktgruppe](wato_user.html#contact_groups) und somit ein Kontakt.

- Bei einem Host oder Service, der dieser Kontaktgruppe zugeordnet ist,
  ereignet sich ein Monitoring-Ereignis, das eine Benachrichtigung
  auslöst.
:::
:::::

:::::::::: sect2
### []{#smtp .hidden-anchor .sr-only}3.2. Einrichten des Mailversands unter Linux {#heading_smtp}

::: paragraph
Damit das Versenden von E-Mails klappt, muss Ihr Checkmk-Server eine
funktionierende Konfiguration des SMTP-Servers haben. Je nach Ihrer
Linux-Distribution kann es sich dabei z.B. um Postfix, Qmail, Exim oder
Nullmailer handeln. Die Konfiguration erfolgt mit den Mitteln Ihrer
Linux-Distribution.
:::

::: paragraph
In der Regel beschränkt sich die Konfiguration auf das Eintragen eines
„Smarthosts" (auch SMTP-Relay-Server genannt), an den alle E-Mails
weitergeleitet werden. Dies ist dann Ihr firmeninterner SMTP-Mailserver.
Im LAN benötigen Smarthosts in der Regel keine Authentifizierung, was
die Sache einfach macht. Der Smarthost wird bei manchen Distributionen
schon während der Installation abgefragt. Bei der Checkmk-Appliance
können Sie den Smarthost bequem über die
[Weboberfläche](appliance_usage.html#cma_webconf_system_settings)
konfigurieren.
:::

::: paragraph
Sie können das Versenden von E-Mails auf der Kommandozeile mit dem
Befehl `mail` testen. Da es für diesen Befehl unter Linux zahlreiche
unterschiedliche Implementierungen gibt, liefert Checkmk zur
Vereinheitlichung die Variante aus dem Projekt [Heirloom
mailx](https://heirloom.sourceforge.net/mailx.html){target="_blank"} mit
aus --- direkt im Suchpfad des Instanzbenutzers als `~/bin/mail`. Die
zugehörige Konfigurationsdatei ist `~/etc/mail.rc`. Testen Sie also am
besten als Instanzbenutzer, denn mit den gleichen Rechten laufen später
auch die Benachrichtigungsskripte.
:::

::: paragraph
Der Inhalt der E-Mail wird von der Standardeingabe gelesen, der Betreff
mit `-s` angegeben und die Zieladresse einfach als Argument ans Ende der
Kommandozeile gestellt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "content" | mail -s test-subject harry.hirsch@example.com
```
:::
::::

::: paragraph
Die E-Mail sollte ohne Verzögerung zugestellt werden. Falls dies nicht
klappt, finden Sie Hinweise in der Log-Datei des SMTP-Server im
Verzeichnis `/var/log` (siehe [Dateien und Verzeichnisse](#maillog)).
:::
::::::::::

:::::::: sect2
### []{#_e_mail_adresse_und_kontaktgruppe .hidden-anchor .sr-only}3.3. E-Mail-Adresse und Kontaktgruppe {#heading__e_mail_adresse_und_kontaktgruppe}

::: paragraph
E-Mail-Adresse und Kontaktgruppe eines Benutzers legen Sie in der
[Benutzerverwaltung](wato_user.html#user_config) fest:
:::

:::: imageblock
::: content
![Dialog zur Eingabe von E-Mail-Adresse und Auswahl der
Kontaktgruppen.](../images/notifications_add_user.png)
:::
::::

::: paragraph
Bei einer frisch erzeugten Checkmk-Instanz gibt es zunächst nur die
Kontaktgruppe [Everything]{.guihint}. Mitglieder dieser Gruppe sind
automatisch für **alle** Hosts und Services zuständig und werden bei
jedem relevanten Monitoring-Ereignis per E-Mail benachrichtigt.
:::

::: paragraph
**Hinweis:** Falls Ihre Checkmk-Installation mit einer älteren Version
erzeugt wurde, kann diese Gruppe auch [Everybody]{.guihint} heißen. Dies
ist aber logisch falsch, denn diese Gruppe beinhaltet ja nicht alle
Benutzer, sondern alle Hosts. Bis auf den unterschiedlichen Namen ist
aber die Funktion die gleiche.
:::
::::::::

::::: sect2
### []{#ticketsystem .hidden-anchor .sr-only}3.4. Sonderfälle: Ticketsystem, Messenger und Event Engine {#heading_ticketsystem}

::: paragraph
Statt per E-Mail oder SMS können Sie Benachrichtigungen auch an ein
Ticketsystem (wie Jira oder ServiceNow), einen Messenger (Slack,
Mattermost) oder eine Event Engine (Event Console) schicken. Für jeden
dieser Sonderfälle gibt es eine eigene
[Benachrichtigungsmethode,](#notification_method) die in der
Benachrichtigungsregel ausgewählt werden kann. Allerdings müssen Sie bei
der Erstellung der Regel die folgenden zwei Punkte beachten:
:::

::: {.olist .arabic}
1.  Sorgen Sie bei der Kontaktauswahl dafür, dass die Benachrichtigungen
    nur an *einen* Kontakt versendet werden, z. B. durch Auswahl eines
    einzelnen Benutzers. Bei den Benachrichtigungsmethoden zu
    Ticketsystemen & Co. dient die Kontaktauswahl nur dazu, festzulegen,
    *dass* benachrichtigt wird. Die Benachrichtigungen werden aber nicht
    an den ausgewählten Benutzer, sondern an das Ticketsystem gesendet.
    Beachten Sie, dass eine Kontaktauswahl über Kontaktgruppen, alle
    Kontakte eines Objekts oder ähnliches in den meisten Fällen mehrere
    identische Benachrichtigungen für ein Ereignis generiert, die dann
    doppelt, dreifach oder noch öfter im Ticketsystem landen.

2.  Wenn der erste Punkt erfüllt ist, der Benutzer aber in mehreren
    Benachrichtigungsregeln für dieselbe Methode verwendet wird, dann
    greift jeweils nur die letzte Regel. Es empfiehlt sich daher, für
    jede dieser Benachrichtigungsregeln einen eigenen funktionalen
    Benutzer anzulegen.
:::
:::::

::::::::::::::::::::: sect2
### []{#notification_testing .hidden-anchor .sr-only}3.5. Benachrichtigungsregeln testen {#heading_notification_testing}

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | In Checkmk [2.3.0]{.new} können   |
|                                   | Sie mit [Test                     |
|                                   | notifications]{.guihint} alle     |
|                                   | **Benachrichtigungsregeln**       |
|                                   | testen und Benachrichtigungen per |
|                                   | **E-Mail** versenden.             |
|                                   | :::                               |
|                                   |                                   |
|                                   | ::: paragraph                     |
|                                   | Wenn Sie den tatsächlichen        |
|                                   | Versand von etwas anderem als     |
|                                   | E-Mails testen möchten, können    |
|                                   | Sie weiterhin [Fake check         |
|                                   | results](#fake_check_results)     |
|                                   | verwenden.                        |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Für den Test von Benachrichtigungsregeln bietet Checkmk mit [Test
notifications]{.guihint} ein smartes Werkzeug. Mit diesem können Sie
eine Benachrichtigung für einen Host oder einen Service simulieren und
erkennen, welche Ihrer Benachrichtigungsregeln greifen. Zusätzlich zur
Simulation können Sie Benachrichtigungen per E-Mail auch testweise
versenden lassen.
:::

::: paragraph
Sie erreichen den Benachrichtigungstest am schnellsten über [Setup \>
Events \> Notifications]{.guihint} und den Knopf [Test
notifications.]{.guihint} Zusätzlich gibt es noch andere Möglichkeiten
zum Aufruf aus einigen Tabellenansichten im Monitoring (Service-Liste
und Service-Details) und im Setup (Eigenschaften eines Hosts), jeweils
im Menü [Host \> Test notifications.]{.guihint}
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Eigenschaften der simulierten
Benachrichtigung.](../images/notifications_test.png)
:::
::::

::: paragraph
Zuerst entscheiden Sie durch Klick auf einen der beiden Knöpfe, ob es um
eine Benachrichtigung für einen [Host]{.guihint} oder einen
[Service]{.guihint} geht. Welcher Host bzw. Service es denn sein soll,
wählen Sie danach aus. Eine Beschreibung des Ereignisses können Sie bei
[Plugin output]{.guihint} hinzufügen. Als Ereignis können Sie einen
Zustandswechsel oder den Beginn einer
[Wartungszeit](glossar.html#scheduled_downtime) wählen. Mit der Checkbox
[Send out HTML/ASCII email notification according to notification
rules]{.guihint} legen Sie fest, ob die Benachrichtigung nur simuliert
oder auch tatsächlich versendet wird.
:::

::: paragraph
Unter [Advanced condition simulation]{.guihint} verbergen sich
abschließend zwei weitere Optionen, mit denen Sie den Zeitpunkt und die
Anzahl der Benachrichtigungen festlegen können. Damit können Sie
Benachrichtigungsregeln testen, die nur in einem bestimmten Zeitraum
(z.B. außerhalb der Geschäftszeiten) gelten oder die nach einer
festgelegten Anzahl von wiederholten Benachrichtigungen eine
[Eskalation](#repeat_escalate) starten.
:::

::: paragraph
Durch Klick auf [Test notifications]{.guihint} starten Sie den
Test --- und auch den E-Mail-Versand, sofern Sie diese Option ausgewählt
haben. Der Dialog [Test notifications]{.guihint} wird aus- und die
Ergebnisse eingeblendet:
:::

:::: imageblock
::: content
![Die Zusammenfassung der
Simulationsresultate.](../images/notifications_test_results1.png)
:::
::::

::: paragraph
Zuerst kommt die Zusammenfassung. Unter [Analysis results]{.guihint}
erfahren Sie, wie viele Benachrichtigungsregeln greifen und wie viele
Benachrichtigungen daraus resultieren. Haben Sie den Versand gewählt,
wird Ihnen hier die entsprechende Meldung `Notifications have been sent`
angezeigt. Das muss dann sofort zu einer E-Mail für dieses Problem
führen.
:::

::: paragraph
Die Zeile darunter fasst die aus Ihren Eingaben erzeugten
Benachrichtigungen zusammen. Durch Klick auf das Symbol [![Symbol zur
Anzeige des
Benachrichtigungskontexts.](../images/icons/icon_toggle_context.png)]{.image-inline}
können Sie den Benachrichtigungskontext einblenden. So sehen Sie die im
Kontext dieser Benachrichtigung gültigen Umgebungsvariablen und ihre
Werte.
:::

::: paragraph
Die folgenden beiden Abschnitte zeigen dann mehr Details:
:::

:::: imageblock
::: content
![Die Details der
Simulationsresultate.](../images/notifications_test_results2.png)
:::
::::

::: paragraph
Unter [Resulting notifications]{.guihint} sehen Sie, an wen und über
welchen Weg Benachrichtigungen abgesetzt werden. Diese Information zur
Simulation erhalten Sie auch dann, wenn Sie den Versand der
Benachrichtigung *nicht* ausgewählt haben.
:::

::: paragraph
Unter [Global notification rules]{.guihint} werden die
Benachrichtigungsregeln aufgelistet, die im [nächsten Kapitel](#rules)
genauer vorgestellt werden. An dieser Stelle ist nur die erste Spalte
der Tabelle wichtig, die mit Symbolen anzeigt, welche der Regeln greifen
[![Symbol zur Anzeige eines positiven
Status.](../images/icons/icon_checkmark.png)]{.image-inline} und welche
nicht [![Symbol zur Anzeige eines negativen
Status.](../images/icons/icon_hyphen.png)]{.image-inline}. Im Beispiel
greift die erste Regel nicht, da in dieser Zustandswechsel von Hosts
ausgewertet werden, es sich aber beim Ereignis um einen Zustandswechsel
eines Services handelt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Wie gewohnt können Sie alternativ |
|                                   | zum Test von Benachrichtigungen   |
|                                   | via Simulation auch weiterhin     |
|                                   | Benachrichtigungen direkt über    |
|                                   | die GUI auslösen, z. B. mit den   |
|                                   | [Kommandos](commands.html) [Send  |
|                                   | custom notification]{.guihint}    |
|                                   | und [Fake check                   |
|                                   | results]{.guihint}.               |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::::::::

:::::: sect2
### []{#finetuning .hidden-anchor .sr-only}3.6. Feineinstellungen für HTML-E-Mail {#heading_finetuning}

::: paragraph
Wenn Sie HTML-E-Mails verschicken, haben Sie möglicherweise den Wunsch,
zusätzliche Informationen hinzuzufügen oder flexibel eine Antwortadresse
([Reply to]{.guihint}) auf einen Kontakt für Rückfragen zu setzen.
Hierfür gibt es die Regel [Setup \> Services \> Service monitoring rules
\> Parameters for HTML Email]{.guihint} und in
[Benachrichtigungsregeln](notifications.html#notification_rule) die
Benachrichtigungsmethode HTML-E-Mail. Mit diesen Regeln können Sie eine
Reihe von Parametern wie Antwortadresse, zusätzliche Felder mit Details
oder Freitext als HTML formatiert hinzufügen.
:::

::: paragraph
Beachten Sie, dass im Feld [Add HTML section above table (e.g. title,
description...)]{.guihint} aus Sicherheitsgründen nur eine kleine Menge
an HTML-Tags zugelassen ist. Diese sind:
:::

+------+-----------------+---------------------------------------------+
| Tag  | Bedeutung       | Hinweise                                    |
+======+=================+=============================================+
| `a`  | [               | Zugelassen, wenn es mit dem Attribut `href` |
|      | Anchor/Link](ht | (verpflichtend) und `target` (optional)     |
|      | tps://developer | kombiniert ist. Links müssen hierbei        |
|      | .mozilla.org/en | entweder relative Pfade enthalten (also mit |
|      | -US/docs/Web/HT | `./` oder `../` beginnen) oder eines der    |
|      | ML/Element/a){t | URL-Schemas `http`, `https` oder `mailto`   |
|      | arget="_blank"} | verwenden. Von der Verwendung relativer     |
|      |                 | Pfade raten wir wegen der sehr              |
|      |                 | unterschiedlichen Handhabung durch          |
|      |                 | E-Mail-Clients ab.                          |
+------+-----------------+---------------------------------------------+
| `h1` | [Heading        |                                             |
|      | 1](htt          |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/h1){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `h2` | [Heading        |                                             |
|      | 2](htt          |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/h2){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `b`  | [Bring          |                                             |
|      | Attention       |                                             |
|      | (i.d.R.         |                                             |
|      | fett)](ht       |                                             |
|      | tps://developer |                                             |
|      | .mozilla.org/en |                                             |
|      | -US/docs/Web/HT |                                             |
|      | ML/Element/b){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `tt` | [Teletype       | Abgekündigt. Nicht mehr verwenden!          |
|      | (Monospace-S    |                                             |
|      | chriftart)](htt |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/tt){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `i`  | [Idiomatic      |                                             |
|      | (i.d.R.         |                                             |
|      | kursiv)](ht     |                                             |
|      | tps://developer |                                             |
|      | .mozilla.org/en |                                             |
|      | -US/docs/Web/HT |                                             |
|      | ML/Element/i){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `u`  | [Unarticulated  |                                             |
|      | Annotation      |                                             |
|      | (i.d.R.         |                                             |
|      | unt             |                                             |
|      | erstrichen)](ht |                                             |
|      | tps://developer |                                             |
|      | .mozilla.org/en |                                             |
|      | -US/docs/Web/HT |                                             |
|      | ML/Element/u){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `br` | [Break          |                                             |
|      | (Zeil           |                                             |
|      | enumbruch)](htt |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/br){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `n   | [Text ohne      | Abgekündigt. Nicht mehr verwenden!          |
| obr` | Zeile           |                                             |
|      | numbruch](https |                                             |
|      | ://developer.mo |                                             |
|      | zilla.org/en-US |                                             |
|      | /docs/Web/HTML/ |                                             |
|      | Element/nobr){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `    | [Pre            | Leerzeichen und Einrückungen bleiben        |
| pre` | formatted](http | erhalten.                                   |
|      | s://developer.m |                                             |
|      | ozilla.org/en-U |                                             |
|      | S/docs/Web/HTML |                                             |
|      | /Element/pre){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `    | [Su             |                                             |
| sup` | perscript](http |                                             |
|      | s://developer.m |                                             |
|      | ozilla.org/en-U |                                             |
|      | S/docs/Web/HTML |                                             |
|      | /Element/sup){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `p`  | [Paragraph](ht  |                                             |
|      | tps://developer |                                             |
|      | .mozilla.org/en |                                             |
|      | -US/docs/Web/HT |                                             |
|      | ML/Element/p){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `hr` | [Thematic Break |                                             |
|      | (horizontaler   |                                             |
|      | Strich)](htt    |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/hr){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `li` | [List           | Verwendung nur innerhalb der nachfolgenden  |
|      | Item](htt       | Listen `ul` und `ol`.                       |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/li){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `ul` | [Unordered      |                                             |
|      | List](htt       |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/ul){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+
| `ol` | [Ordered        |                                             |
|      | List](htt       |                                             |
|      | ps://developer. |                                             |
|      | mozilla.org/en- |                                             |
|      | US/docs/Web/HTM |                                             |
|      | L/Element/ol){t |                                             |
|      | arget="_blank"} |                                             |
+------+-----------------+---------------------------------------------+

::: paragraph
Wie bei allen Regeln in Checkmk üblich, ist eine sehr fein granulierte
Anwendung möglich, so dass Sie je nach Bedarf eine detailliert zu
bestimmende Menge an Benachrichtigungen zu Hosts und Services
individualisieren können.
:::
::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#rules .hidden-anchor .sr-only}4. Benachrichtigungen per Regeln steuern {#heading_rules}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_das_prinzip .hidden-anchor .sr-only}4.1. Das Prinzip {#heading__das_prinzip}

::: paragraph
Checkmk ist „ab Werk" so eingerichtet, dass es bei einem
Monitoring-Ereignis an jeden [Kontakt](wato_user.html#contact_groups)
des betroffenen Hosts oder Services eine Benachrichtigung per E-Mail
versendet. Das ist sicher erst einmal sinnvoll, aber in der Praxis
tauchen viele weitergehende Anforderungen auf, z. B.:
:::

::: ulist
- Unterdrücken bestimmter, wenig nützlicher Benachrichtigungen.

- „Abonnieren" von Benachrichtigungen zu Services, für die man kein
  Kontakt ist.

- Benachrichtigen per E-Mail, SMS oder Pager, abhängig von der
  Tageszeit.

- Eskalieren von Problemen nach einer bestimmten Zeit ohne
  [Quittierung.](basics_ackn.html)

- Eventuell keine Benachrichtigungen für [WARN]{.state1} oder
  [UNKNOWN]{.state3} erhalten.

- und vieles mehr ...​
:::

::: paragraph
Checkmk bietet Ihnen über einen regelbasierten Mechanismus maximale
Flexibilität bei der Umsetzung solcher Anforderungen. Mit [Setup \>
Events \> Notifications]{.guihint} steigen Sie in die Konfiguration ein.
:::

::: paragraph
**Hinweis:** Wenn Sie die Seite [Notification configuration]{.guihint}
das erste Mal aufrufen, wird Ihnen eine Warnung zur nicht konfigurierten
„fallback email address\" angezeigt. Die Warnung können Sie im Moment
ignorieren. Wir gehen darauf [weiter unten](#fallback) ein.
:::

::: paragraph
In der Benachrichtigungskonfiguration verwalten Sie die **Kette der
Benachrichtigungsregeln,** welche festlegen, *wer* *wie* benachrichtigt
werden soll. Bei jedem Monitoring-Ereignis wird diese Regelkette von
*oben nach unten* durchlaufen. Jede Regel hat eine Bedingung, die
entscheidet, ob die Regel überhaupt zur Anwendung kommt.
:::

::: paragraph
Ist die Bedingung erfüllt, legt die Regel zwei Dinge fest:
:::

::: ulist
- Eine Auswahl von Kontakten (*Wer* soll benachrichtigt werden?)

- Eine Benachrichtigungsmethode (*Wie* soll benachrichtigt
  werden?), z. B. HTML-E-Mail, und dazu optional Parameter für die
  Methode
:::

::: paragraph
**Wichtig:** Anders als bei den [Regeln](wato_rules.html) für Hosts und
Services geht die Auswertung hier auch nach einer zutreffenden Regel
weiter! Die nachfolgenden Regeln können weitere Benachrichtigungen
hinzufügen. Auch können Sie Benachrichtigungen wieder
[löschen](#cancel), welche vorherige Regeln generiert haben.
:::

::: paragraph
Das Endergebnis der Regelauswertung ist eine Tabelle, die etwa folgenden
Aufbau hat:
:::

+--------------------+--------------------+---------------------------+
| Wer (Kontakt)      | Wie (Methode)      | Parameter der Methode     |
+====================+====================+===========================+
| Harry Hirsch       | E-Mail             | `Reply-To:                |
|                    |                    |  linux.group@example.com` |
+--------------------+--------------------+---------------------------+
| Bruno Weizenkeim   | E-Mail             | `Reply-To:                |
|                    |                    |  linux.group@example.com` |
+--------------------+--------------------+---------------------------+
| Bruno Weizenkeim   | SMS                |                           |
+--------------------+--------------------+---------------------------+

::: paragraph
Nun wird pro Eintrag in dieser Tabelle das zur Methode gehörende
[Benachrichtigungsskript](#scripts) aufgerufen, welches die eigentliche
Benutzerbenachrichtigung durchführt.
:::
:::::::::::::

::::::::: sect2
### []{#_vordefinierte_regel .hidden-anchor .sr-only}4.2. Vordefinierte Regel {#heading__vordefinierte_regel}

::: paragraph
Wenn Sie Checkmk frisch aufgesetzt haben, dann finden Sie genau eine
Regel vordefiniert:
:::

:::: imageblock
::: content
![Liste mit der vordefinierten
Benachrichtigungsregel.](../images/notifications_default_rule.png)
:::
::::

::: paragraph
Diese eine Regel setzt das oben beschriebene Standardverhalten um. Sie
hat folgenden Aufbau:
:::

+--------------------+-------------------------------------------------+
| Bedingung          | Keine, d. h. die Regel gilt für **alle**        |
|                    | Monitoring-Ereignisse.                          |
+--------------------+-------------------------------------------------+
| Methode            | Versand einer E-Mail im HTML-Format (mit        |
|                    | eingebetteten Metrikgraphen)                    |
+--------------------+-------------------------------------------------+
| Kontakt            | Alle Kontakte des betroffenen Hosts/Services    |
+--------------------+-------------------------------------------------+

::: paragraph
Wie gewohnt, können Sie die Regel [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} bearbeiten, [![icon
clone](../images/icons/icon_clone.png)]{.image-inline} kopieren,
[![Symbol zum Löschen.](../images/icons/icon_delete.png)]{.image-inline}
löschen oder eine neue Regel anlegen. Sobald Sie mehr als eine Regel
haben, können Sie die Reihenfolge der Regeln per Drag & Drop über das
Symbol [![icon drag](../images/icons/icon_drag.png)]{.image-inline}
verändern.
:::

::: paragraph
**Hinweis:** Änderungen an Benachrichtigungsregeln erfordern **keine**
Aktivierung der Änderungen. Sie sind sofort wirksam.
:::
:::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#notification_rule .hidden-anchor .sr-only}4.3. Aufbau der Benachrichtigungsregeln {#heading_notification_rule}

::: paragraph
Im Folgenden stellen wir den generellen Aufbau der
Benachrichtigungsregeln mit den Festlegungen zu generellen
Eigenschaften, Methoden, Kontakten und Bedingungen vor.
:::

::::::: sect3
#### []{#_generelle_eigenschaften .hidden-anchor .sr-only}Generelle Eigenschaften {#heading__generelle_eigenschaften}

::: paragraph
Wie bei allen Regeln in Checkmk, können Sie hier eine Beschreibung und
einen Kommentar für die Regel hinterlegen sowie die Regel temporär
abschalten.
:::

:::: imageblock
::: content
![Regel mit der Option zur Aktivierung der Abschaltung von
Benachrichtigungen durch
Benutzer.](../images/notifications_rule_part1.png)
:::
::::

::: paragraph
Die Option [Overriding by users]{.guihint} ist per Default aktiviert.
Sie erlaubt Benutzern, Benachrichtigungen „abzubestellen", die von
dieser Regel erzeugt werden. Wie das geht, zeigen wir bei den
[benutzerdefinierten Benachrichtigungen.](#personal)
:::
:::::::

:::::::::::: sect3
#### []{#notification_method .hidden-anchor .sr-only}Benachrichtigungsmethode {#heading_notification_method}

::: paragraph
Die Benachrichtigungsmethode legt fest, auf welchem technischen Weg
benachrichtigt werden soll, z. B. mit HTML-E-Mail.
:::

:::: imageblock
::: content
![Regel mit den Optionen zur
Benachrichtigungsmethode.](../images/notifications_rule_part2.png)
:::
::::

::: paragraph
Jede Methode ist durch ein Skript realisiert. Checkmk liefert bereits
[einige Skripte](#includedscripts) mit aus. Sie können aber auch recht
einfach [eigene Skripte](#scripts) in beliebigen Programmiersprachen
schreiben, um speziellere Anforderungen umzusetzen, z. B. die
Weiterleitung der Benachrichtigungen an ein eigenes Ticketsystem.
:::

::: paragraph
Eine Methode kann Parameter anbieten. Zum Beispiel erlauben es die
Methoden für ASCII- und HTML-E-Mails, die Absenderadresse (`From:`)
explizit zu setzen.
:::

::: paragraph
Bevor Sie hier Einstellungen in der Benachrichtigungsregel machen,
sollten Sie wissen, dass Sie Parameter für die Benachrichtigungsmethoden
auch in den [Regeln](wato_rules.html) für Hosts und Services setzen
können: Unter [Setup \> Services \> Service monitoring rules]{.guihint}
finden Sie im Abschnitt [Notifications]{.guihint} für jede
Benachrichtigungsmethode einen Regelsatz, mit dem Sie die gleichen
Einstellungen festlegen können --- und das wie gewohnt abhängig von Host
oder Service.
:::

::: paragraph
Parameterdefinitionen in Benachrichtigungsregeln dienen dazu, für
Einzelfälle von diesen Einstellungen abzuweichen. So können Sie z. B.
global einen bestimmten Betreff für Ihre E-Mail festlegen, aber in einer
einzelnen Benachrichtigungsregel einen alternativen Betreff definieren.
:::

::: paragraph
Anstelle von Parametern können Sie auch [Cancel previous
notifications]{.guihint} auswählen. Dann werden Benachrichtigungen in
Form dieser Methode aus früheren Regeln wieder verworfen. Näheres dazu
finden Sie beim Thema [Löschen von Benachrichtigungen.](#cancel)
:::

::: paragraph
**Hinweis:** Für viele Benachrichtigungsmethoden zur Weiterleitung an
andere Systeme erhalten Sie genauere Informationen in separaten
Artikeln. Die Liste der Artikel finden Sie im Kapitel zu den
[Benachrichtigungsskripten.](#includedscripts)
:::
::::::::::::

:::::::::::: sect3
#### []{#_kontaktauswahl .hidden-anchor .sr-only}Kontaktauswahl {#heading__kontaktauswahl}

::: paragraph
Der häufigste Fall bei der Festlegung der Kontakte ist, alle Benutzer zu
benachrichtigen, die als
[Kontakt](wato_user.html#add_host_to_contact_group) für den jeweiligen
Host/Service eingetragen sind. Dies ist das „normale" Verhalten und
naheliegend, da über die Kontakte ebenfalls gesteuert wird, welcher
Benutzer welche Objekte in der GUI zu sehen bekommt und quasi dafür
zuständig ist.
:::

::: paragraph
Sie können bei der Kontaktauswahl mehrere Optionen ankreuzen und so die
Benachrichtigung auf mehr Kontakte ausweiten:
:::

:::: imageblock
::: content
![Regel mit den Optionen zur
Kontaktauswahl.](../images/notifications_rule_part3.png)
:::
::::

::: paragraph
Doppelte Kontakte werden von Checkmk automatisch entfernt. Damit die
Regel sinnvoll ist, muss mindestens eine Auswahl getroffen werden.
:::

::: paragraph
Die beiden Optionen, die mit [Restrict by ...​]{.guihint} beginnen,
arbeiten etwas anders. Hier werden die durch die übrigen Optionen
ausgewählten Kontakte wieder *eingeschränkt*. Damit können Sie auch eine
UND-Verknüpfung zwischen Kontaktgruppen herstellen, um z. B. alle
Kontakte zu benachrichtigen, die gleichzeitig Mitglied der Gruppen
`Linux` und `Data center` sind.
:::

::: paragraph
Durch die Angabe von E-Mail-Adressen ([Explicit email
addresses]{.guihint}) können Sie Personen benachrichtigen, die überhaupt
nicht als Benutzer in Checkmk hinterlegt sind. Dies ist natürlich nur
bei den Benachrichtigungsmethoden sinnvoll, die E-Mails verschicken.
:::

::: paragraph
Falls Sie in der Benachrichtigungsmethode [Cancel previous
notifications]{.guihint} gewählt haben, werden nur Benachrichtigungen an
die hier gewählten Kontakte entfernt.
:::

::: paragraph
**Hinweis:** Falls Sie als Benachrichtigungsmethode ein Ticketsystem,
einen Messenger oder eine Event Engine nutzen, beachten Sie zusätzlich
die Hinweise zu diesen [Sonderfällen.](#ticketsystem)
:::
::::::::::::

::::::::::::::::::::::::: sect3
#### []{#rule_conditions .hidden-anchor .sr-only}Bedingungen {#heading_rule_conditions}

::: paragraph
Bedingungen legen fest, wann eine Regel Anwendung findet. Für das
Verständnis ist es wichtig, sich daran zu erinnern, dass der
Ausgangspunkt immer ein Monitoring-Ereignis von einem ganz konkreten
Host oder Service ist.
:::

::: paragraph
Die Bedingungen befassen sich dabei
:::

::: ulist
- mit den statischen Eigenschaften des Objekts, z. B. ob der
  Service-Name den Text `/tmp` enthält oder ein Host sich in einer
  bestimmten Host-Gruppe befindet,

- mit dem aktuellen Zustand bzw. der Änderung des Zustands, z. B. ob der
  Service gerade von [OK]{.state0} nach [CRIT]{.state2} gewechselt hat,

- oder mit ganz anderen Dingen, z. B. ob die
  [Zeitperiode](timeperiods.html) „Arbeitszeit" gerade aktiv ist.
:::

::: paragraph
Bei der Festlegung der Bedingungen gibt es zwei wichtige Punkte zu
beachten:
:::

::: {.olist .arabic}
1.  Solange keine Bedingung definiert ist, greift die Regel bei
    **jedem** Monitoring-Ereignis.

2.  Sobald Sie auch nur eine einzige Bedingung auswählen, greift die
    Regel nur, wenn auch wirklich **alle** ausgewählten Bedingungen
    erfüllt sind. Alle ausgewählten Bedingungen werden mit UND
    verknüpft. Von dieser wichtigen Regel gibt es nur eine Ausnahme, auf
    die wir später eingehen werden und die wir jetzt nicht betrachten.
:::

::: paragraph
Das heißt, dass Sie sehr genau darauf achten sollten, ob die von Ihnen
gewählten Bedingungen gleichzeitig erfüllt sein können, damit eine
Benachrichtigung auch für den gewünschten Fall ausgelöst wird.
:::

::: paragraph
Nehmen wir an, eine Benachrichtigung soll erfolgen, wenn ein
Monitoring-Ereignis für einen Service, der mit dem Namen `NTP` beginnt,
auf einem Host im Ordner [Main]{.guihint} eintritt:
:::

:::: imageblock
::: content
![Regel mit den Bedingungen für die Erstellung einer
Benachrichtigung.](../images/notifications_rule_part4.png)
:::
::::

::: paragraph
Nehmen wir weiter an, dass diese Bedingung nun **erweitert** wird, indem
auch alle Zustandsänderungen eines Hosts auf den Zustand
[DOWN]{.hstate1} eine Benachrichtigung auslösen sollen:
:::

:::: imageblock
::: content
![Regel mit erweiterten Bedingungen für die Erstellung einer
Benachrichtigung.](../images/notifications_rule_part4_match_host_types.png)
:::
::::

::: paragraph
Das Ergebnis dieser Benachrichtigungsregel mit den drei
Einzelbedingungen ist, dass **nie** eine Benachrichtigung erfolgen wird,
weil kein Monitoring-Ereignis die Zustandsänderung eines Hosts **und**
den Service-Namen mit `NTP` enthalten wird.
:::

::: paragraph
Den folgenden Hinweis geben wir in diesem Handbuch immer wieder. Im
Zusammenhang mit der Konfiguration Ihrer Benachrichtigungen ist er
allerdings nochmal besonders hervorzuheben: Blenden Sie die
kontextsensitive Hilfe mit [Help \> Show inline help]{.guihint} ein, um
Einzelheiten über die Auswirkungen der verschiedenen Bedingungen zu
erfahren. Der folgende Auszug aus der kontextsensitiven Hilfe zur Option
[Match services]{.guihint} verdeutlicht das Verhalten sehr gut:
„*Anmerkung: Auf Host-Benachrichtigungen trifft diese Regel nie zu, wenn
diese Option benutzt wird.*"
:::

#### Die Ausnahme von der UND-Verknüpfung {#_die_ausnahme_von_der_und_verknüpfung .discrete}

::: paragraph
Nur wenn ein Monitoring-Ereignis alle konfigurierten Bedingungen
erfüllt, kommt die Benachrichtigungsregel zur Anwendung. Wie bereits
erwähnt, gibt es zu dieser allgemeinen Regel eine wichtige Ausnahme: für
die Bedingungen [Match host event type]{.guihint} und [Match service
event type]{.guihint}:
:::

:::: imageblock
::: content
![Die Bedingungen \'Match host event type\' und \'Match service event
type\'.](../images/notifications_rule_part4_match_event_types.png)
:::
::::

::: paragraph
Falls Sie **nur** [Match host event type]{.guihint} auswählen, wird die
Regel auf kein einziges Service-Ereignis matchen. Analog gilt dies auch
für die Auswahl von [Match service event type]{.guihint} und
Host-Ereignisse. Falls Sie aber **beide** Bedingungen aktivieren, matcht
die Regel, sobald der Ereignistyp in **einer** der beiden
Checkbox-Listen aktiviert ist. In diesem Ausnahmefall werden diese
beiden Bedingungen also nicht wie üblich mit einem logischen UND
verknüpft, sondern mit einem ODER. So können Sie bequemer Host- und
Service-Benachrichtigungen mit einer einzelnen Regel verwalten.
:::

::: paragraph
Ein Hinweis noch zu den Bedingungen [Match contacts]{.guihint} und
[Match contact groups]{.guihint}:
:::

:::: imageblock
::: content
![Die Bedingungen \'Match contacts\' und \'Match contact
groups\'.](../images/notifications_rule_part4_contacts.png)
:::
::::

::: paragraph
Hier wird als Bedingung geprüft, ob der Host/Service, um den es geht,
eine bestimmte Kontaktzuordnung hat. Damit kann man Dinge umsetzen wie
„Host-bezogene Benachrichtigungen in der Kontaktgruppe Linux sollen nie
per SMS versendet werden". Das hat nichts mit der oben beschriebenen
Kontaktauswahl zu tun.
:::
:::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::: sect2
### []{#cancel .hidden-anchor .sr-only}4.4. Benachrichtigungen durch Regeln löschen {#heading_cancel}

::: paragraph
Wie bei der Auswahl der Benachrichtigungsmethode bereits erwähnt, finden
Sie dort auch die Auswahlmöglichkeit [Cancel previous
notifications]{.guihint}. Um die Funktionsweise einer solchen Regel zu
verstehen, stellen Sie sich am besten die Benachrichtigungstabelle
bildlich vor. Nehmen wir an, einige Regeln zu einem konkreten
Monitoring-Ereignis wurden bereits abgearbeitet. Dadurch wurden die
folgenden drei Benachrichtigungen erzeugt:
:::

+-----------------------------------+-----------------------------------+
| Wer (Kontakt)                     | Wie (Methode)                     |
+===================================+===================================+
| Harry Hirsch                      | E-Mail                            |
+-----------------------------------+-----------------------------------+
| Bruno Weizenkeim                  | E-Mail                            |
+-----------------------------------+-----------------------------------+
| Bruno Weizenkeim                  | SMS                               |
+-----------------------------------+-----------------------------------+

::: paragraph
Nun kommt die nächste Regel mit der Methode [SMS]{.guihint} und der
Auswahl [Cancel previous notifications]{.guihint}. Als Kontakt sind die
Mitglieder der Kontaktgruppe „Windows" ausgewählt, der auch Bruno
Weizenkeim angehört. Als Ergebnis dieser Regel wird der Eintrag „Bruno
Weizenkeim / SMS" aus der Tabelle entfernt, die anschließend so
aussieht:
:::

+-----------------------------------+-----------------------------------+
| Wer (Kontakt)                     | Wie (Methode)                     |
+===================================+===================================+
| Harry Hirsch                      | E-Mail                            |
+-----------------------------------+-----------------------------------+
| Bruno Weizenkeim                  | E-Mail                            |
+-----------------------------------+-----------------------------------+

::: paragraph
Sollte eine spätere Regel wieder eine SMS-Benachrichtigung für Bruno
definieren, so hätte diese Vorrang und die SMS-Benachrichtigung würde
wieder in die Tabelle aufgenommen.
:::

::: paragraph
Zusammengefasst:
:::

::: ulist
- Regeln können gezielt Benachrichtigungen unterdrücken (löschen).

- Löschregeln müssen nach den Regeln kommen, welche Benachrichtigungen
  erzeugen.

- Eine Löschregel hebt nicht eine frühere Regel auf, sondern
  Benachrichtigungen, die aus (möglicherweise verschiedenen) früheren
  Regeln stammen.

- Spätere Regeln können vormals gelöschte Benachrichtigungen wieder
  hinzufügen.
:::
::::::::

:::::::::::: sect2
### []{#fallback .hidden-anchor .sr-only}4.5. Was ist, wenn keine Regel greift? {#heading_fallback}

::: paragraph
Wer konfiguriert, kann auch Fehler machen. Ein möglicher Fehler bei der
Benachrichtigungskonfiguration wäre, dass das Monitoring ein kritisches
Problem entdeckt und keine einzige Benachrichtigungsregel greift.
:::

::: paragraph
Um Sie vor so einem Fall zu schützen, bietet Checkmk die Einstellung
[Fallback email address for notifications]{.guihint}. Diese finden Sie
unter [Setup \> General \> Global settings]{.guihint} im Abschnitt
[Notifications]{.guihint}. Tragen Sie hier eine E-Mail-Adresse ein. An
diese werden Benachrichtigungen verschickt, für die keine einzige
Benachrichtigungsregel greift.
:::

::: paragraph
**Hinweis:** Alternativ können Sie auch einen Benutzer in seinen
[persönlichen Einstellungen](wato_user.html#user_config_notifications)
zum Empfänger machen. Als Fallback-Adresse wird die beim Benutzer
hinterlegte E-Mail-Adresse verwendet.
:::

::: paragraph
Die Fallback-Adresse wird nur dann verwendet, wenn **keine Regel**
greift, nicht wenn keine Benachrichtigung erzeugt würde! Wie wir im
vorherigen Kapitel gezeigt haben, ist das explizite Löschen von
Benachrichtigungen ja erwünscht und kein Konfigurationsfehler.
:::

::: paragraph
Die Einrichtung der Fallback-Adresse wird auf der Seite [Notification
configuration]{.guihint} durch die folgende Warnung „empfohlen":
:::

:::: imageblock
::: content
![Warnhinweis, dass keine Fallback-E-Mail-Adresse hinterlegt
ist.](../images/notifications_warning_fallback_email.png)
:::
::::

::: paragraph
Falls Sie - aus welchen Gründen auch immer - ausschließlich die Warnung
loswerden, aber gleichzeitig **keine** E-Mails an der Fallback-Adresse
erhalten wollen, so tragen Sie trotzdem zuerst eine Fallback-Adresse ein
und erzeugen dann eine neue Regel als *erste Regel*, die alle bisherigen
Benachrichtigungen löscht. Diese Regel ist für die
Benachrichtigungskonfiguration wirkungslos, da ja hier noch keine
Benachrichtigungen erzeugt wurden. Aber damit stellen Sie sicher, dass
immer eine Regel greift und lassen somit die Warnung verschwinden.
:::

::: paragraph
Wir raten von diesem Vorgehen explizit ab, weil Sie so eventuell
übersehen, dass Ihre Regelkette Lücken aufweist.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: sect1
## []{#personal .hidden-anchor .sr-only}5. Benutzerdefinierte Benachrichtigungen {#heading_personal}

::::::::::::::::::::::: sectionbody
::::: sect2
### []{#_übersicht .hidden-anchor .sr-only}5.1. Übersicht {#heading__übersicht}

::: paragraph
Eine nützliche Besonderheit des Benachrichtigungssystems von Checkmk
ist, dass Benutzer sich auch ohne Administratorrechte ihre
Benachrichtigungen anpassen können. Benutzer können:
:::

::: ulist
- Benachrichtigungen hinzufügen, die sie sonst nicht bekommen würden
  („abonnieren"),

- Benachrichtigungen löschen, die sie sonst bekommen würden (falls nicht
  gesperrt),

- Parameter von Benachrichtigungen anpassen und

- ihre Benachrichtigungen vorübergehend ganz abschalten.
:::
:::::

:::::::::::::: sect2
### []{#_benutzerdefinierte_benachrichtigungsregeln .hidden-anchor .sr-only}5.2. Benutzerdefinierte Benachrichtigungsregeln {#heading__benutzerdefinierte_benachrichtigungsregeln}

::: paragraph
Der Einstieg aus Sicht des Benutzers ist das
[User-Menü](user_interface.html#user_menu), und dort der Eintrag
[Notification rules]{.guihint}. Auf der Seite [Your personal
notification rules]{.guihint} kann mit [Add rule]{.guihint} eine neue
Regel erzeugt werden.
:::

::: paragraph
Benutzerdefinierte Regeln sind wie die normalen Regeln aufgebaut --- mit
einem Unterschied: Sie enthalten keine Kontaktauswahl. Als Kontakt ist
automatisch der Benutzer selbst gewählt. Dadurch kann ein Benutzer nur
für sich selbst Benachrichtigungen hinzufügen oder löschen.
:::

::: paragraph
Löschen kann der Benutzer Benachrichtigungen allerdings nur dann, wenn
in der Regel, die sie erzeugt, die Option [allow users to deactivate
this notification]{.guihint} aktiviert ist:
:::

:::: imageblock
::: content
![Regel mit der Option zur Aktivierung der Abschaltung von
Benachrichtigungen durch
Benutzer.](../images/notifications_rule_part1.png)
:::
::::

::: paragraph
In der Reihenfolge der Benachrichtigungsregeln kommen die
benutzerdefinierten Regeln immer *nach* den globalen Regeln und können
so die bisher erzeugte Benachrichtigungstabelle anpassen. Bis auf das
gerade beschriebene Sperren der Löschung gelten also die globalen Regeln
immer als Standardeinstellung, die vom Benutzer angepasst werden kann.
:::

::: paragraph
Wenn Sie ein Anpassen ganz unterbinden möchten, können Sie der
Benutzerrolle `user` die [Berechtigung](wato_user.html#roles) [General
Permissions \> Edit personal notification settings]{.guihint} entziehen.
:::

::: paragraph
Als Administrator können Sie sich alle Benutzerregeln anzeigen lassen,
wenn Sie im Menü [Display \> Show user rules]{.guihint} wählen:
:::

:::: imageblock
::: content
![Liste der Benutzerregeln aus
Administratorensicht.](../images/notifications_show_user_roles.png)
:::
::::

::: paragraph
Nach den globalen Regeln werden die Benutzerregeln aufgelistet, die Sie
mit [![icon edit](../images/icons/icon_edit.png)]{.image-inline} auch
bearbeiten können.
:::
::::::::::::::

::::::: sect2
### []{#_vorübergehende_abschaltung .hidden-anchor .sr-only}5.3. Vorübergehende Abschaltung {#heading__vorübergehende_abschaltung}

::: paragraph
Die komplette Abschaltung der Benachrichtigungen durch einen Benutzer
selbst ist mit der [Berechtigung](wato_user.html#roles) [General
Permissions \> Disable all personal notifications]{.guihint} geschützt,
die für die Benutzerrolle `user` per Default auf `no` gesetzt ist. Nur
wenn Sie der Rolle `user` dieses Recht explizit zuweisen, bekommt ein
Benutzer dafür in seinen persönlichen Einstellungen entsprechende
Checkboxen angezeigt:
:::

:::: imageblock
::: content
![Persönliche Einstellung zur vorübergehende Abschaltung der
Benachrichtigungen.](../images/notifications_edit_profile_disable.png)
:::
::::

::: paragraph
Da Sie als Administrator einfachen Zugriff auf die persönlichen
Einstellungen der Benutzer haben, können Sie das Abschalten
stellvertretend für den Benutzer machen --- auch wenn diesem die oben
genannte Berechtigung fehlt. Sie finden diese Einstellung unter [Setup
\> Users \> Users]{.guihint} und dann in den Eigenschaften des
Benutzerprofils. Damit können Sie z. B. während eines Urlaubs eines
Kollegen sehr schnell dessen Benachrichtigungen still schalten, ohne an
der eigentlichen Konfiguration etwas ändern zu müssen.
:::
:::::::
:::::::::::::::::::::::
::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#conditions .hidden-anchor .sr-only}6. Wann Benachrichtigungen erzeugt werden und wie man damit umgeht {#heading_conditions}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::: sect2
### []{#_einleitung .hidden-anchor .sr-only}6.1. Einleitung {#heading__einleitung}

::: paragraph
Ein großer Teil der Komplexität im Benachrichtigungssystem von Checkmk
liegt in den zahlreichen Tuning-Möglichkeiten, mit denen unwichtige
Benachrichtigungen vermieden werden können. Die meisten davon betreffen
Situationen, in denen bereits beim Auftreten der Monitoring-Ereignisse
Benachrichtigungen verzögert oder unterdrückt werden. Auch gibt es eine
im Monitoring-Kern eingebaute Intelligenz, die bestimmte
Benachrichtigungen von Haus aus unterdrückt. Alle diese Aspekte wollen
wir Ihnen in diesem Kapitel vorstellen.
:::
::::

::::::: sect2
### []{#_wartungszeiten .hidden-anchor .sr-only}6.2. Wartungszeiten {#heading__wartungszeiten}

:::: {.imageblock .inline-image}
::: content
![Symbol einer
Wartungszeit.](../images/notifications_large_icon_downtime.png){width="50"}
:::
::::

::: paragraph
Während sich ein Host oder Service in einer
[Wartungszeit](basics_downtimes.html) befindet, sind für dieses Objekt
die Benachrichtigungen unterdrückt. Das ist --- neben einer korrekten
Berechnung von Verfügbarkeiten --- der wichtigste Grund, warum man
überhaupt eine Wartungszeit im Monitoring hinterlegt. Interessant sind
dabei folgende Details:
:::

::: ulist
- Ist ein Host in Wartung, dann gelten automatisch auch alle seine
  Services als in Wartung, ohne dass man explizit eine Wartung für diese
  eintragen muss.

- Endet die Wartungszeit eines Objekts, das *während* der Wartungszeit
  in einen Problemzustand gewechselt hat, dann werden für dieses Problem
  exakt beim Ablauf der Wartung *nachträglich* Benachrichtigungen
  ausgelöst.

- Der Beginn und das Ende einer Wartungszeit selbst sind auch
  Monitoring-Ereignisse, für die Benachrichtigungen ausgelöst werden.
:::
:::::::

::::::::: sect2
### []{#_benachrichtigungsperioden .hidden-anchor .sr-only}6.3. Benachrichtigungsperioden {#heading__benachrichtigungsperioden}

:::: {.imageblock .inline-image}
::: content
![Symbol einer inaktiven
Benachrichtigungsperiode.](../images/notifications_large_icon_outofnot.png){width="50"}
:::
::::

::: paragraph
Per Konfiguration können Sie für jeden Host und Service eine
Benachrichtigungsperiode festlegen. Dies ist eine
[Zeitperiode](timeperiods.html), welche die Zeiträume festlegt, auf die
Benachrichtigungen beschränkt werden sollen.
:::

::: paragraph
Die Konfiguration geschieht über die Regelsätze [Notification period for
hosts]{.guihint} bzw. [Notification period for services]{.guihint}, die
Sie schnell über die [Suche im
Setup-Menü](user_interface.html#search_setup) finden können. Ein Objekt,
welches sich gerade **nicht** in seiner Benachrichtigungsperiode
befindet, wird durch ein graues Pause-Zeichen [![Symbol einer inaktiven
Benachrichtigungsperiode.](../images/icons/icon_outofnot.png)]{.image-inline}
markiert.
:::

::: paragraph
Monitoring-Ereignisse zu einem Objekt, das sich gerade außerhalb seiner
Benachrichtigungsperiode befindet, lösen keine Benachrichtigungen aus.
Benachrichtigungen werden nachgeholt, wenn die Benachrichtigungsperiode
wieder aktiv wird und der Host/Service sich immer noch in einem
Problemzustand befindet. Dabei löst nur der jeweils letzte Zustand eine
Benachrichtigung aus, auch wenn es außerhalb der Periode mehrere
Zustandswechsel gab.
:::

::: paragraph
Übrigens gibt es auch bei den Benachrichtigungsregeln die Möglichkeit,
Benachrichtigungen auf eine bestimmte Zeitperiode zu beschränken. Damit
können Sie die Zeiträume *zusätzlich* einschränken. Allerdings werden
Benachrichtigungen, die durch eine Regel mit Zeitbedingung verworfen
wurden, später **nicht** automatisch nachgeholt!
:::
:::::::::

::::::: sect2
### []{#state_host .hidden-anchor .sr-only}6.4. Der Zustand des Hosts, auf dem ein Service läuft {#heading_state_host}

::: paragraph
Wenn ein Host komplett ausfällt oder zumindest für das Monitoring nicht
erreichbar ist, können natürlich auch die Services des Hosts nicht mehr
überwacht werden. [Aktive Checks](active_checks.html) werden dann in der
Regel [CRIT]{.state2} oder [UNKNOWN]{.state3}, weil diese gezielt
versuchen, den Host zu erreichen und dabei in einen Fehler laufen. Alle
anderen Checks --- also die überwiegende Mehrheit --- werden in so einem
Fall ausgelassen und verharren in ihrem alten Zustand. Sie werden mit
der Zeit [![icon stale](../images/icons/icon_stale.png)]{.image-inline}
[stale]{.guihint}.
:::

::: paragraph
Natürlich wäre es sehr lästig, wenn alle Probleme von aktiven Checks in
so einem Zustand Benachrichtigungen auslösen würden. Denn wenn z. B. ein
Webserver nicht erreichbar ist --- und dies auch schon als
Benachrichtigung kommuniziert wurde --- wäre es wenig informativ, wenn
nun auch für jeden einzelnen HTTP-Dienst, den dieser bereit stellt, eine
E-Mail generiert würde.
:::

::: paragraph
Um dies zu vermeiden, erzeugt der Monitoring-Kern für Services
grundsätzlich nur dann Benachrichtigungen, wenn der Host den Zustand
[UP]{.hstate0} hat. Das ist auch der Grund, warum die Erreichbarkeit von
Hosts separat überprüft wird. Wenn Sie nichts anderes konfiguriert
haben, geschieht dies durch einen [Smart
Ping](cmc_differences.html#smartping) bzw. Ping.
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Wenn Sie Checkmk
Raw verwenden (oder eine der kommerziellen Editionen mit Nagios als
Kern), dann kann es in seltenen Fällen bei einem Host-Problem trotzdem
zu einer Benachrichtigung aufgrund eines aktiven Services kommen. Der
Grund liegt darin, dass Nagios die Resultate von Host-Checks für eine
kurze Zeit in der Zukunft als gültig betrachtet. Wenn zwischen dem
letzten erfolgreichen Ping an den Server und dem nächsten aktiven Check
nur wenige Sekunden vergehen, kann es sein, dass Nagios den Host noch
als [UP]{.hstate0} wertet, obwohl dieser bereits [DOWN]{.hstate1} ist.
Der [Checkmk Micro Core (CMC)](cmc.html) hingegen hält die
Service-Benachrichtigung solange in Wartestellung, bis der Zustand des
Hosts geklärt ist und vermeidet die unerwünschte Benachrichtigung so
zuverlässig.
:::
:::::::

:::::: sect2
### []{#parents .hidden-anchor .sr-only}6.5. Parent-Hosts {#heading_parents}

::: paragraph
Stellen Sie sich vor, ein wichtiger Netzwerk-Router zu einem
Unternehmensstandort mit Hunderten von Hosts fällt aus. Alle Hosts sind
dann für das Monitoring nicht mehr erreichbar und gehen auf
[DOWN]{.hstate1}. Hunderte Benachrichtigungen werden ausgelöst. Nicht
sehr schön.
:::

::: paragraph
Um das zu vermeiden, können Sie den Router als
[Parent-Host](hosts_structure.html#parents) der Hosts definieren. Wenn
es redundante Routen gibt, kann man auch mehrere Parents definieren.
Sobald alle Parents auf [DOWN]{.hstate1} gehen, werden die nicht mehr
erreichbaren Hosts auf den Zustand [UNREACH]{.hstate2} gesetzt und die
darauf basierenden Benachrichtigungen werden unterdrückt. Das Problem
mit dem Router selbst löst hingegen durchaus eine Benachrichtigung aus.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Der
[CMC](cmc.html) verhält sich intern übrigens geringfügig anders als
Nagios. Um Fehlalarme zu vermeiden, richtige Benachrichtigungen aber
korrekt abzusetzen, achtet er sehr genau auf die exakten Zeitpunkte der
jeweiligen Host-Checks. Scheitert ein Host-Check, so wartet der Kern
zunächst das Ergebnis des Host-Checks der Parent-Hosts ab, bevor eine
Benachrichtigung erzeugt wird. Dieses Warten geschieht asynchron und
ohne das übrige Monitoring zu beeinträchtigen. Benachrichtigungen von
Hosts können sich dadurch geringfügig verzögern.
:::
::::::

:::: sect2
### []{#_benachrichtigungen_per_regel_abschalten .hidden-anchor .sr-only}6.6. Benachrichtigungen per Regel abschalten {#heading__benachrichtigungen_per_regel_abschalten}

::: paragraph
Über die Regelsätze [Enable/disable notifications for hosts]{.guihint}
bzw. [Enable/disable notifications for services]{.guihint} können Sie
Hosts und Services bestimmen, aufgrund derer grundsätzlich keine
Benachrichtigungen erzeugt werden sollen. Wie oben erwähnt, unterbindet
dann bereits der Kern die Benachrichtigungen. Eine
Benachrichtigungsregel für ein „Abonnieren" solcher Benachrichtigungen
wäre wirkungslos, da diese ja gar nicht erzeugt werden.
:::
::::

::::::::::::: sect2
### []{#_benachrichtigungen_per_kommando_abschalten .hidden-anchor .sr-only}6.7. Benachrichtigungen per Kommando abschalten {#heading__benachrichtigungen_per_kommando_abschalten}

:::: {.imageblock .inline-image}
::: content
![Symbol einer deaktivierten
Benachrichtigung.](../images/notifications_large_icon_notif_man_disabled.png){width="50"}
:::
::::

::: paragraph
Es ist grundsätzlich möglich, die Benachrichtigungen bezogen auf
einzelne Hosts und Services auch per [Kommando](commands.html)
vorübergehend abzuschalten.
:::

::: paragraph
Voraussetzung dafür ist allerdings, dass die
[Berechtigung](wato_user.html#roles) [Commands on host and services \>
Enable/disable notifications]{.guihint} der Benutzerrolle zugewiesen
ist. Standardmäßig ist dies für **keine** Rolle der Fall.
:::

::: paragraph
Mit zugewiesener Berechtigung können Sie Benachrichtigungen auf Basis
von Hosts und Services mit dem Kommando [Commands \>
Notifications]{.guihint} abschalten (und später auch wieder
einschalten):
:::

:::: imageblock
::: content
![Kommando zur Aktivierung und Deaktivierung der
Benachrichtigungen.](../images/notifications_commands_disable.png)
:::
::::

::: paragraph
Solche Hosts oder Services werden dann mit dem Symbol [![icon notif man
disabled](../images/icons/icon_notif_man_disabled.png)]{.image-inline}
markiert.
:::

::: paragraph
Da Kommandos im Gegensatz zu Regeln weder eine
Konfigurationsberechtigung noch ein [Aktivieren der
Änderungen](wato.html#activate_changes) benötigen, können sie daher eine
Lösung sein, um auf eine Situation schnell zu reagieren.
:::

::: paragraph
**Wichtig:** Im Gegensatz zu [![icon
downtime](../images/icons/icon_downtime.png)]{.image-inline}
Wartungszeiten haben abgeschaltete Benachrichtigungen keinen Einfluss
auf die Berechnung der [Verfügbarkeit.](availability.html) Wenn Sie also
während eines ungeplanten Ausfalls einfach nur die Benachrichtigungen
abschalten, aber Ihre Verfügbarkeitsberechnung nicht verfälschen
möchten, sollten Sie keine Wartungszeiten dafür eintragen!
:::
:::::::::::::

::::::::: sect2
### []{#global .hidden-anchor .sr-only}6.8. Benachrichtigungen global ausschalten {#heading_global}

::: paragraph
Im Snapin [Master control]{.guihint} der Seitenleiste finden Sie einen
Hauptschalter für die Benachrichtigungen ([Notifications]{.guihint}):
:::

:::: imageblock
::: content
![Das Snapin Master
control.](../images/notifications_master_control.png){width="50%"}
:::
::::

::: paragraph
Dieser Schalter ist ausgesprochen nützlich, wenn Sie am System größere
Änderungen vornehmen, durch die bei einem Fehler unter Umständen eine
Vielzahl von Services auf [CRIT]{.state2} geht. Sie ersparen sich so den
Unmut Ihrer Kollegen über die vielen nutzlosen E-Mails. Vergessen Sie
aber nicht, die Benachrichtigungen später wieder einzuschalten.
:::

::: paragraph
Im [verteilten Monitoring](distributed_monitoring.html) gibt es diesen
Schalter einmal pro Instanz. Ein Abschalten der Benachrichtigungen auf
der Zentralinstanz lässt Benachrichtigungen auf den Remote-Instanzen
weiterhin aktiviert --- selbst wenn diese zur Zentralinstanz
weitergeleitet und von dort zugestellt werden.
:::

::: paragraph
**Wichtig:** Benachrichtigungen, die angefallen wären, während die
Benachrichtigungen abgeschaltet waren, werden beim Wiedereinschalten
**nicht** nachgeholt.
:::
:::::::::

:::::: sect2
### []{#delaying .hidden-anchor .sr-only}6.9. Benachrichtigungen verzögern {#heading_delaying}

::: paragraph
Vielleicht haben Sie Services, die gelegentlich für kurze Zeit in einen
Problemzustand gehen, der aber nur sehr kurz anhält und für Sie nicht
kritisch ist. In solchen Fällen sind Benachrichtigungen sehr lästig,
aber auch einfach zu unterdrücken. Dazu dienen die Regelsätze [Delay
host notifications]{.guihint} und [Delay service
notifications.]{.guihint}
:::

::: paragraph
Sie legen hier einen Zeitraum fest. Eine Benachrichtigung wird dann
solange zurückgehalten, bis diese Zeit abgelaufen ist. Tritt vorher der
[OK]{.state0} / [UP]{.hstate0}-Zustand wieder ein, so wird keine
Benachrichtigung erzeugt. Natürlich bedeutet das aber dann auch, dass
Sie im Falle eines *wirklichen* Problems erst mit einer Verzögerung
benachrichtigt werden.
:::

::: paragraph
Viel besser als eine Verzögerung der Benachrichtigungen ist es
natürlich, den eigentlichen Grund der sporadischen Probleme loszuwerden.
Aber das ist eine andere Geschichte ...​
:::
::::::

:::::: sect2
### []{#repeated_check_attempts .hidden-anchor .sr-only}6.10. Mehrere Check-Versuche {#heading_repeated_check_attempts}

::: paragraph
Eine zur Verzögerung der Benachrichtigungen sehr ähnliche Methode ist
es, mehrere Check-Versuche zu erlauben, wenn ein Service in einen
Problemzustand geht. Dies geschieht über die Regelsätze [Maximum number
of check attempts for host]{.guihint} bzw. [Maximum number of check
attempts for service.]{.guihint}
:::

::: paragraph
Wenn Sie hier z. B. eine `3` einstellen, dann führt ein Check mit dem
Resultat [CRIT]{.state2} zunächst zu keiner Benachrichtigung. Man
spricht dann zunächst von einem weichen [CRIT]{.state2}-Zustand (*soft
state*). Der harte Zustand (*hard state*) ist dann immer noch
[OK]{.state0}. Erst wenn drei Versuche in Folge zu keinem
[OK]{.state0}-Zustand führen, wechselt der Service den harten Zustand
und eine Benachrichtigung wird ausgelöst.
:::

::: paragraph
Im Gegensatz zur verzögerten Benachrichtigung haben Sie hier noch die
Möglichkeit, sich Tabellenansichten zu definieren, welche solche
Probleme ausblenden. Auch [BI-Aggregate](bi.html) können so gebaut
werden, dass nur die harten Zustände berücksichtigt werden, nicht die
weichen.
:::
::::::

:::::::::::: sect2
### []{#flapping .hidden-anchor .sr-only}6.11. Unstetige Hosts und Services {#heading_flapping}

:::: {.imageblock .inline-image}
::: content
![Symbol zur Anzeige des unstetigen
Zustands.](../images/notifications_large_icon_flapping.png){width="50"}
:::
::::

::: paragraph
Wenn ein Host oder Service binnen kurzer Zeit mehrfach den Zustand
ändert, so gilt er als unstetig (*flapping*). Dies ist sozusagen ein
eigener Zustand. Die Idee dabei ist das Vermeiden von exzessiven
Benachrichtigungen in Phasen, in denen ein Service nicht (ganz) stabil
läuft. Auch in der [Verfügbarkeitsberechnung](availability.html) können
Sie solche Phasen speziell auswerten.
:::

::: paragraph
Unstetige Objekte werden mit dem Symbol [![Symbol zur Anzeige des
unstetigen Zustands.](../images/icons/icon_flapping.png)]{.image-inline}
markiert. Während ein Objekt unstetig ist, erzeugen weitere
Zustandswechsel keine Benachrichtigungen mehr. Dafür wird aber jeweils
eine Benachrichtigung ausgelöst, wenn das Objekt in den Zustand unstetig
ein- oder austritt.
:::

::: paragraph
Sie können die Erkennung von Unstetigkeiten auf folgende Arten
beeinflussen:
:::

::: ulist
- Die [Master control]{.guihint} hat einen Hauptschalter für die
  Erkennung von Unstetigkeiten: [Flap Detection]{.guihint}

- Über die Regelsätze [Enable/disable flapping detection for
  hosts]{.guihint} bzw. [Enable/disable flapping detection for
  services]{.guihint} können Sie Objekte von der Erkennung ausklammern.

- In den kommerziellen Editionen können Sie mit [Global settings \>
  Monitoring Core \> Tuning of flap detection]{.guihint} die Parameter
  der Unstetigkeitserkennung festlegen und sie mehr oder weniger
  empfindlich einstellen:
:::

:::: imageblock
::: content
![Globale Einstellungen zur
Unstetigkeitsbehandlung.](../images/notifications_tuning_flap_detection.png)
:::
::::

::: paragraph
Blenden Sie die kontextsensitive Hilfe ein mit [Help \> Show inline
help]{.guihint} für Details zu den einstellbaren Werten.
:::
::::::::::::

:::::::::::::::::::::: sect2
### []{#repeat_escalate .hidden-anchor .sr-only}6.12. Periodisch wiederholte Benachrichtigungen und Eskalationen {#heading_repeat_escalate}

::: paragraph
Bei manchen Systemen kann es sinnvoll sein, es nicht bei einer einzelnen
Benachrichtigung zu belassen, falls das Problem über einen längeren
Zeitraum weiterhin besteht, z. B. bei Hosts, deren
[Host-Merkmal](glossar.html#host_tag) [Criticality]{.guihint} auf
[Business critical]{.guihint} gesetzt ist.
:::

::::::::: sect3
#### []{#_periodisch_wiederholte_benachrichtigungen_einrichten .hidden-anchor .sr-only}Periodisch wiederholte Benachrichtigungen einrichten {#heading__periodisch_wiederholte_benachrichtigungen_einrichten}

::: paragraph
Sie können Checkmk so einrichten, dass es in einem festen Intervall
immer weitere Benachrichtigungen versendet, solange bis das Problem
entweder [![Symbol zur Anzeige der
Quittierung.](../images/icons/icon_ack.png)]{.image-inline}
[quittiert](basics_ackn.html) oder behoben wurde.
:::

::: paragraph
Die Einstellung dafür finden Sie in den Regelsätzen [Periodic
notifications during host problems]{.guihint} bzw. [Periodic
notifications during service problems:]{.guihint}
:::

:::: imageblock
::: content
![Regel für periodisch wiederholte
Benachrichtigungen.](../images/notifications_periodic.png)
:::
::::

::: paragraph
Sobald diese Option aktiv ist, wird Checkmk für ein fortbestehendes
Problem im konfigurierten Intervall weitere Benachrichtigungen erzeugen.
Die Benachrichtigungen bekommen eine laufende Nummer, welche bei 1 (für
die erste Benachrichtigung) beginnt.
:::

::: paragraph
Periodische Benachrichtigungen haben nicht nur den Nutzen, das Problem
immer wieder in Erinnerung zu rufen (also den Operator damit zu
*nerven*), sondern sie bilden auch die Grundlage für *Eskalationen.*
Dies bedeutet, dass nach Ablauf einer bestimmten Zeit die
Benachrichtigung an andere Personen eskaliert werden kann.
:::
:::::::::

::::::::::::: sect3
#### []{#_eskalationen_aufbauen_und_verstehen .hidden-anchor .sr-only}Eskalationen aufbauen und verstehen {#heading__eskalationen_aufbauen_und_verstehen}

::: paragraph
Um eine Eskalation einzurichten, erzeugen Sie zusätzlich eine
Benachrichtigungsregel, welche die Bedingung [Restrict to notification
number]{.guihint} verwendet.
:::

:::: imageblock
::: content
![Regel zur Einstellung der Häufigkeit von
Benachrichtigungen.](../images/notifications_escalation.png)
:::
::::

::: paragraph
Tragen Sie hier als Bereich für den Zähler 3 bis 99999 ein, so greift
diese Regel ab der dritten Benachrichtigung. Diese Eskalation kann dann
entweder durch die Wahl einer anderen Methode (z.B. SMS) erfolgen oder
durch die Benachrichtigung von anderen Personen (Kontaktauswahl).
:::

::: paragraph
Mit der Option [Throttle periodic notifications]{.guihint} können Sie
die Rate der wiederholten Benachrichtigungen nach einer bestimmten Zeit
reduzieren. So können Sie z.B. zunächst jede Stunde eine E-Mail senden
lassen und später das Ganze auf einmal am Tag beschränken.
:::

::: paragraph
Mit mehreren Benachrichtigungsregeln können Sie ein Eskalationsmodell
aufbauen. Aber wie läuft diese Eskalation dann ab? Wer wird wann
informiert? Hierzu ein Beispiel, umgesetzt mit einer Regel für
periodisch wiederholte Benachrichtigungen und drei
Benachrichtigungsregeln:
:::

::: ulist
- Ein Service löst im Problemfall alle 60 Minuten eine Benachrichtigung,
  z.B. in Form einer E-Mail, aus, solange bis das Problem behoben oder
  bestätigt wird.

- Die Benachrichtigungen eins bis fünf gehen an die zwei zuständigen
  Mitarbeiter.

- Die Benachrichtigungen sechs bis zehn gehen zusätzlich an den
  betreffenden Teamleiter.

- Ab Benachrichtigung elf geht stattdessen täglich eine Mail an die
  Firmenleitung.
:::

::: paragraph
Morgens um 9 Uhr tritt im Betrieb ein Problem auf. Die beiden
Mitarbeiter werden benachrichtigt, reagieren aber nicht (aus welchen
Gründen auch immer). So bekommen sie um 10, 11, 12 und 13 Uhr jeweils
eine weitere E-Mail. Ab der sechsten Benachrichtigung um 14 Uhr bekommt
nun zusätzlich auch der Teamleiter eine E-Mail --- trotzdem ändert sich
weiterhin nichts am Problem. So werden um 15, 16, 17 und 18 Uhr weitere
E-Mails an die Mitarbeiter und an den Teamleiter verschickt.
:::

::: paragraph
Um 19 Uhr greift die dritte Eskalationsstufe: ab jetzt werden keine
E-Mails mehr an die Mitarbeiter oder den Teamleiter verschickt.
Stattdessen bekommt die Firmenleitung bis zur Problembehebung nun
täglich um 19 Uhr eine E-Mail.
:::

::: paragraph
Sobald das Problem behoben ist und der Service in Checkmk wieder auf
[OK]{.state0} geht, wird automatisch eine „Entwarnung" an den zuletzt
benachrichtigten Personenkreis versandt: Im obigen Beispiel also bei
einer Problembehebung vor 14 Uhr an die beiden Mitarbeiter, bei einer
Problembehebung zwischen 14 und 19 Uhr an die Mitarbeiter und den
Teamleiter und nach 19 Uhr nur noch an die Firmenleitung.
:::
:::::::::::::
::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#path .hidden-anchor .sr-only}7. Der Weg einer Benachrichtigung von Anfang bis Ende {#heading_path}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::: sect2
### []{#history .hidden-anchor .sr-only}7.1. Die Benachrichtigungshistorie {#heading_history}

::: paragraph
Zum Einstieg zeigen wir Ihnen, wie Sie sich in Checkmk die Historie der
Benachrichtigungen auf Host- und Service-Ebene anzeigen lassen und so
den Benachrichtigungsprozess nachverfolgen können.
:::

::: paragraph
Ein Monitoring-Ereignis, das Checkmk veranlasst, eine Benachrichtigung
auszulösen, ist z. B. der Zustandswechsel eines Services. Diesen
Zustandswechsel können Sie mit dem [Kommando](commands.html) [Fake check
results]{.guihint} zu Testzwecken manuell veranlassen.
:::

::: paragraph
Für einen Benachrichtigungstest können Sie einen Service auf diese Weise
vom Zustand [OK]{.state0} nach [CRIT]{.state2} versetzen. Wenn Sie sich
jetzt auf der Seite der Service-Details die Benachrichtigungen für
diesen Service mit [Service \> Service Notifications]{.guihint} anzeigen
lassen, sehen Sie die folgenden Einträge:
:::

:::: imageblock
::: content
![Liste aufgelaufener Benachrichtigungen für einen
Service.](../images/notifications_list.png)
:::
::::

::: paragraph
Der aktuellste Eintrag steht ganz oben in der Liste. Los ging es aber
mit dem untersten, daher sehen wir uns die einzelnen Einträge von unten
nach oben an:
:::

::: {.olist .arabic}
1.  Der Monitoring-Kern protokolliert das Monitoring-Ereignis des
    Zustandswechsels. Dabei zeigt das [![icon alert
    crit](../images/icons/icon_alert_crit.png)]{.image-inline} Symbol in
    der 1. Spalte den Zustand an (im Beispiel [CRIT]{.state2}).

2.  Der Monitoring-Kern erzeugt eine [![icon alert cmk
    notify](../images/icons/icon_alert_cmk_notify.png)]{.image-inline}
    Rohbenachrichtigung (*raw notification*). Diese wird vom Kern an das
    Benachrichtigungsmodul übergeben, welches die Auswertung der
    Benachrichtigungsregeln durchführt.

3.  Die Auswertung der Regeln ergibt eine [![icon alert
    notify](../images/icons/icon_alert_notify.png)]{.image-inline}
    Benutzerbenachrichtigung (*user notification*) an den Benutzer `hh`
    mit der Methode `mail`.

4.  Das [![icon alert notify
    result](../images/icons/icon_alert_notify_result.png)]{.image-inline}
    Benachrichtigungsergebnis (*notification result*) zeigt, dass die
    E-Mail erfolgreich an den SMTP-Server zur Auslieferung übergeben
    wurde.
:::

::: paragraph
Um die Zusammenhänge von allen Einstellmöglichkeiten und
Rahmenbedingungen genau zu verstehen und um eine sinnvolle
Fehlerdiagnose zu ermöglichen, wenn mal eine Benachrichtigung nicht wie
erwartet erfolgt oder ausbleibt, beschreiben wir im folgenden alle
Einzelheiten zum Ablauf einer Benachrichtigung mit allen beteiligten
Komponenten.
:::

::: paragraph
**Hinweis:** Die Benachrichtigungshistorie, die wir oben für einen
Service gezeigt haben, können Sie sich auch für einen Host anzeigen
lassen: auf der Seite der Host-Details im Menü [Host]{.guihint} für den
Host selbst (Menüeintrag [Notifications of host]{.guihint}) und auch für
den Host mit all seinen Services ([Notifications of host &
services]{.guihint}).
:::
::::::::::::

:::: sect2
### []{#_die_komponenten .hidden-anchor .sr-only}7.2. Die Komponenten {#heading__die_komponenten}

::: paragraph
Im Benachrichtigungssystem von Checkmk sind folgende Komponenten
beteiligt:
:::

+--------------------+-------------------------------+-----------------+
| Komponente         | Aufgabe                       | Log-Datei       |
+====================+===============================+=================+
| Nagios             | Monitoring-Kern von           | `~/var/l        |
|                    | [![CRE](../image              | og/nagios.log`\ |
|                    | s/icons/CRE.png "Checkmk Raw" | `~/var/na       |
|                    | ){width="20"}]{.image-inline} | gios/debug.log` |
|                    | **Checkmk Raw**, der          |                 |
|                    | Monitoring-Ereignisse erkennt |                 |
|                    | und Rohbenachrichtigungen     |                 |
|                    | erzeugt.                      |                 |
+--------------------+-------------------------------+-----------------+
| [Checkmk Micro     | Monitoring-Kern der           | `~/v            |
| Core               | kommerziellen Editionen, der  | ar/log/cmc.log` |
| (CMC)](cmc.html)   | die gleiche Aufgabe erfüllt   |                 |
|                    | wie Nagios in Checkmk Raw.    |                 |
+--------------------+-------------------------------+-----------------+
| Bena               | Auswertung der                | `~/var/         |
| chrichtigungsmodul | Benachrichtigungsregeln, um   | log/notify.log` |
|                    | aus einer Rohbenachrichtigung |                 |
|                    | eine Benutzerbenachrichtigung |                 |
|                    | zu erzeugen. Das Modul ruft   |                 |
|                    | die Benachrichtigungsskripte  |                 |
|                    | auf.                          |                 |
+--------------------+-------------------------------+-----------------+
| Benachr            | Asynchrone Zustellung von     | `~/var/log      |
| ichtigungs-Spooler | Benachrichtigungen und        | /mknotifyd.log` |
| (nur kommerzielle  | zentralisierte                |                 |
| Editionen)         | Benachrichtigungen in         |                 |
|                    | verteilten Umgebungen.        |                 |
+--------------------+-------------------------------+-----------------+
| Benac              | Für jede                      | `~/var/         |
| hrichtigungsskript | Benachrichtigungsmethode gibt | log/notify.log` |
|                    | es ein Skript, welches die    |                 |
|                    | eigentliche Zustellung        |                 |
|                    | durchführt (z.B. eine         |                 |
|                    | HTML-E-Mail generiert und     |                 |
|                    | versendet).                   |                 |
+--------------------+-------------------------------+-----------------+
::::

::::::::::::::::::::::::: sect2
### []{#_der_monitoring_kern .hidden-anchor .sr-only}7.3. Der Monitoring-Kern {#heading__der_monitoring_kern}

::::::::: sect3
#### []{#_rohbenachrichtigungen .hidden-anchor .sr-only}Rohbenachrichtigungen {#heading__rohbenachrichtigungen}

::: paragraph
Wie oben beschrieben, beginnt jede Benachrichtigung mit einem
Monitoring-Ereignis im Monitoring-Kern. Wenn alle Bedingungen erfüllt
sind und es grünes Licht für eine Benachrichtigung gibt, erzeugt der
Kern eine *Rohbenachrichtigung* an den internen Hilfskontakt
[check-mk-notify.]{.guihint} Die Rohbenachrichtigung enthält noch keine
Angabe zu den eigentlichen Kontakten oder der Benachrichtigungsmethode.
:::

::: paragraph
In der Benachrichtigungshistorie des Services sieht eine
Rohbenachrichtigung so aus:
:::

:::: imageblock
::: content
![Eine Rohbenachrichtigung in der
Benachrichtigungshistorie.](../images/notifications_raw.png)
:::
::::

::: ulist
- Das Symbol ist ein [![icon alert cmk
  notify](../images/icons/icon_alert_cmk_notify.png)]{.image-inline}
  hellgrauer Lautsprecher.

- Als Kontakt wird `check-mk-notify` angegeben.

- Als Benachrichtigungskommando wird `check-mk-notify` angegeben.
:::

::: paragraph
Die Rohbenachrichtigung geht dann an das Benachrichtigungsmodul von
Checkmk, welches die Auswertung der Benachrichtigungsregeln übernimmt.
Dieses Modul wird von Nagios als externes Programm aufgerufen
(`cmk --notify`). Der CMC hingegen hält das Modul als permanenten
Hilfsprozess in Bereitschaft (*notification helper*) und vermeidet so
das Erzeugen von Prozessen, um Rechenzeit zu sparen.
:::
:::::::::

:::::::::::: sect3
#### []{#_fehlerdiagnose_im_monitoring_kern_nagios .hidden-anchor .sr-only}Fehlerdiagnose im Monitoring-Kern Nagios {#heading__fehlerdiagnose_im_monitoring_kern_nagios}

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Der in
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** verwendete Nagios-Kern protokolliert alle
Monitoring-Ereignisse nach `~/var/log/nagios.log`. Diese Datei ist
gleichzeitig der Ort, wo die Benachrichtigungshistorie gespeichert wird,
welche Sie auch in der GUI abfragen, wenn Sie z.B. die
Benachrichtigungen eines Hosts oder Services sehen möchten.
:::

::: paragraph
Interessanter sind aber die Meldungen in der Datei
`~/var/nagios/debug.log`, welche Sie bekommen, wenn Sie in
`etc/nagios/nagios.d/logging.cfg` die Variable `debug_level` auf `32`
setzen.
:::

::: paragraph
Nach einem Core-Neustart ...​
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd restart nagios
```
:::
::::

::: paragraph
... finden Sie nützliche Informationen über Gründe, warum
Benachrichtigungen erzeugt oder unterdrückt wurden:
:::

::::: listingblock
::: title
\~/var/nagios/debug.log
:::

::: content
``` {.pygments .highlight}
[1592405483.152931] [032.0] [pid=18122] ** Service Notification Attempt ** Host: 'localhost', Service: 'backup4', Type: 0, Options: 0, Current State: 2, Last Notification: Wed Jun 17 16:24:06 2020
[1592405483.152941] [032.0] [pid=18122] Notification viability test passed.
[1592405485.285985] [032.0] [pid=18122] 1 contacts were notified.  Next possible notification time: Wed Jun 17 16:51:23 2020
[1592405485.286013] [032.0] [pid=18122] 1 contacts were notified.
```
:::
:::::
::::::::::::

::::::: sect3
#### []{#_fehlerdiagnose_im_monitoring_kern_cmc .hidden-anchor .sr-only}Fehlerdiagnose im Monitoring-Kern CMC {#heading__fehlerdiagnose_im_monitoring_kern_cmc}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} In den
kommerziellen Editionen finden Sie in der Log-Datei `~/var/log/cmc.log`
ein Protokoll des Monitoring-Kerns. In der Standardeinstellung enthält
dies keine Angaben zu Benachrichtigungen. Sie können aber ein sehr
detailliertes Logging einschalten, mit [Global settings \> Monitoring
Core \> Logging of the notification mechanics.]{.guihint} Der Kern gibt
dann darüber Auskunft, warum er ein Monitoring-Ereignis für die
Benachrichtigung an das Benachrichtigungsmodul weitergibt oder warum
(noch) nicht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ tail -f var/log/cmc.log
2021-08-26 16:12:37 [5] [core 27532] Executing external command: PROCESS_SERVICE_CHECK_RESULT;mysrv;CPU load;1;test
2021-08-26 16:12:43 [5] [core 27532] Executing external command: LOG;SERVICE NOTIFICATION: hh;mysrv;CPU load;WARNING;mail;test
2021-08-26 16:12:52 [5] [core 27532] Executing external command: LOG;SERVICE NOTIFICATION RESULT: hh;mysrv;CPU load;OK;mail;success 250 - b'2.0.0 Ok: queued as 482477F567B';success 250 - b'2.0.0 Ok: queued as 482477F567B'
```
:::
::::

::: paragraph
**Hinweis:** Das eingeschaltete Logging zu Benachrichtigungen kann sehr
viele Meldungen erzeugen. Es ist aber nützlich, wenn man später die
Frage beantworten will, warum in einer bestimmten Situation *keine*
Benachrichtigung erzeugt wurde.
:::
:::::::
:::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: sect2
### []{#rule_analysis .hidden-anchor .sr-only}7.4. Regelauswertung durch das Benachrichtigungsmodul {#heading_rule_analysis}

::: paragraph
Nachdem der Kern eine Rohbenachrichtigung erzeugt hat, durchläuft diese
die Kette der Benachrichtigungsregeln. Resultat ist die
Benachrichtigungstabelle. Neben den Daten aus der Rohbenachrichtigung
enthält jede Benutzerbenachrichtigung folgende zusätzliche
Informationen:
:::

::: ulist
- Der Kontakt, der benachrichtigt werden soll

- Die Methode für die Benachrichtigung

- Die Parameter für diese Methode
:::

::: paragraph
Bei einer synchronen Zustellung wird jetzt pro Eintrag in der Tabelle
das passende [Benachrichtigungsskript](#scripts) aufgerufen. Bei einer
[asynchronen Zustellung](#async) wird die Benachrichtigung per Datei an
den Benachrichtigungs-Spooler übergeben.
:::

::::::::::: sect3
#### []{#_analyse_der_regelkette .hidden-anchor .sr-only}Analyse der Regelkette {#heading__analyse_der_regelkette}

::: paragraph
Wenn Sie komplexere Regelwerke erstellen, stehen Sie sicher gelegentlich
vor der Frage, welche Regeln denn nun für eine bestimmte
Benachrichtigung greifen. Dazu bietet Checkmk auf der Seite
[Notifications configuration]{.guihint} eine eingebaute Analysefunktion,
welche Sie mit dem Menüeintrag [Display \> Show analysis]{.guihint}
erreichen.
:::

::: paragraph
Im Analysemodus werden Ihnen standardmäßig die letzten zehn
Rohbenachrichtigungen angezeigt, die das System erzeugt hat und welche
die Regeln durchlaufen haben:
:::

:::: imageblock
::: content
![Liste der der letzten 10 Rohbenachrichtigungen im
Analysemodus.](../images/notifications_analysis.png)
:::
::::

::: paragraph
Sollten Sie für Ihre Analyse eine größere Menge an Rohbenachrichtigungen
benötigen, können Sie die Anzahl über [Global settings \> Notifications
\> Store notifications for rule analysis]{.guihint} erhöhen:
:::

:::: imageblock
::: content
![Globale Einstellung für die Anzahl angezeigter
Rohbenachrichtigungen.](../images/notifications_storenotifications.png)
:::
::::

::: paragraph
Für jede dieser Rohbenachrichtigungen stehen Ihnen drei Aktionen zur
Verfügung:
:::

+------+---------------------------------------------------------------+
| [    | Test der Regelkette, in dem für jede Regel geprüft wird, ob   |
| ![Sy | das Monitoring-Ereignis alle Bedingungen der Regel erfüllen   |
| mbol | würde. Im Anschluss an die Regeln wird dann die daraus        |
| zum  | resultierende Benachrichtigungstabelle angezeigt.             |
| Test |                                                               |
| der  |                                                               |
| Re   |                                                               |
| gelk |                                                               |
| ette |                                                               |
| .](. |                                                               |
| ./im |                                                               |
| ages |                                                               |
| /ico |                                                               |
| ns/i |                                                               |
| con_ |                                                               |
| anal |                                                               |
| yze. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [    | Anzeige des kompletten Benachrichtigungskontexts.             |
| ![Sy |                                                               |
| mbol |                                                               |
| zur  |                                                               |
| Anz  |                                                               |
| eige |                                                               |
| des  |                                                               |
| Bena |                                                               |
| chri |                                                               |
| chti |                                                               |
| gung |                                                               |
| skon |                                                               |
| text |                                                               |
| s.]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _tog |                                                               |
| gle_ |                                                               |
| cont |                                                               |
| ext. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
| [    | Wiederholung der Rohbenachrichtigung, als wäre das            |
| ![Sy | Monitoring-Ereignis jetzt aufgetreten. Ansonsten ist die      |
| mbol | Anzeige gleich wie bei der Analyse. Damit können Sie nicht    |
| für  | nur die Bedingungen der Regel überprüfen, sondern auch        |
| die  | testen, wie eine Benachrichtigung dann aussieht.              |
| Wied |                                                               |
| erho |                                                               |
| lung |                                                               |
| der  |                                                               |
| Ro   |                                                               |
| hben |                                                               |
| achr |                                                               |
| icht |                                                               |
| igun |                                                               |
| g.]( |                                                               |
| ../i |                                                               |
| mage |                                                               |
| s/ic |                                                               |
| ons/ |                                                               |
| icon |                                                               |
| _rel |                                                               |
| oad_ |                                                               |
| cmk. |                                                               |
| png) |                                                               |
| ]{.i |                                                               |
| mage |                                                               |
| -inl |                                                               |
| ine} |                                                               |
+------+---------------------------------------------------------------+
:::::::::::

::::::::::::::::::::: sect3
#### []{#_fehlerdiagnose .hidden-anchor .sr-only}Fehlerdiagnose {#heading__fehlerdiagnose}

::: paragraph
Haben Sie den Test der Regelkette ([![Symbol zum Test der
Regelkette](../images/icons/icon_analyze.png)]{.image-inline})
durchgeführt, so sehen Sie, welche Regeln auf ein Monitoring-Ereignis
[![Symbol in grün](../images/icons/icon_test_green.png)]{.image-inline}
angewendet oder eben auch [![Symbol in
grau](../images/icons/icon_test_grey.png)]{.image-inline} nicht
angewendet wurden:
:::

:::: imageblock
::: content
![Liste der angewendeten und nicht angewendeten
Regeln.](../images/notifications_test_rules.png)
:::
::::

::: paragraph
Wurde eine Regel nicht angewendet, bewegen Sie die Maus über den grauen
Kreis, um den Hinweistext (Mouse-Over-Text) zu sehen:
:::

:::: imageblock
::: content
![Hinweistext bei einer nicht angewendeten
Regel.](../images/notifications_mouseover.png){width="72%"}
:::
::::

::: paragraph
Dieser Mouse-Over-Text verwendet jedoch für die Ursachen einer nicht
angewendeten Regel Abkürzungen. Diese beziehen sich auf die
[Bedingungen](#rule_conditions) [Match host event type]{.guihint} bzw.
[Match service event type]{.guihint} der Regel.
:::

+------+----------------------+----------------------------------------+
| E    |                      |                                        |
| reig |                      |                                        |
| nist |                      |                                        |
| ypen |                      |                                        |
| für  |                      |                                        |
| H    |                      |                                        |
| osts |                      |                                        |
+======+======================+========================================+
| **   | **Bedeutung**        | **Beschreibung**                       |
| Kürz |                      |                                        |
| el** |                      |                                        |
+------+----------------------+----------------------------------------+
| `rd` | UP ➤ DOWN            | Setzt den Host-Zustand von             |
|      |                      | [UP]{.hstate0} auf [DOWN]{.hstate1}    |
+------+----------------------+----------------------------------------+
| `ru` | UP ➤ UNREACHABLE     | Setzt den Host-Zustand von             |
|      |                      | [UP]{.hstate0} auf [UNREACH]{.hstate2} |
+------+----------------------+----------------------------------------+
| `dr` | DOWN ➤ UP            | Setzt den Host-Zustand von             |
|      |                      | [DOWN]{.hstate1} auf [UP]{.hstate0}    |
+------+----------------------+----------------------------------------+
| `du` | DOWN ➤ UNREACHABLE   | Setzt den Host-Zustand von             |
|      |                      | [DOWN]{.hstate1} auf                   |
|      |                      | [UNREACH]{.hstate2}                    |
+------+----------------------+----------------------------------------+
| `ud` | UNREACHABLE ➤ DOWN   | Setzt den Host-Zustand von             |
|      |                      | [UNREACH]{.hstate2} auf                |
|      |                      | [DOWN]{.hstate1}                       |
+------+----------------------+----------------------------------------+
| `ur` | UNREACHABLE ➤ UP     | Setzt den Host-Zustand von             |
|      |                      | [UNREACH]{.hstate2} auf [UP]{.hstate0} |
+------+----------------------+----------------------------------------+
| `?r` | any ➤ UP             | Setzt jeden beliebigen Host-Zustand    |
|      |                      | auf [UP]{.hstate0}                     |
+------+----------------------+----------------------------------------+
| `?d` | any ➤ DOWN           | Setzt jeden beliebigen Host-Zustand    |
|      |                      | auf [DOWN]{.hstate1}                   |
+------+----------------------+----------------------------------------+
| `?u` | any ➤ UNREACHABLE    | Setzt jeden beliebigen Host-Zustand    |
|      |                      | auf [UNREACH]{.hstate2}                |
+------+----------------------+----------------------------------------+
| `f`  | Start or end of      | Anfang oder Ende eines unstetigen      |
|      | flapping state       | Zustands                               |
+------+----------------------+----------------------------------------+
| `s`  | Start or end of a    | Anfang oder Ende einer Wartungszeit    |
|      | scheduled downtime   |                                        |
+------+----------------------+----------------------------------------+
| `x`  | Acknowledgment of    | Quittierung eines Problems             |
|      | problem              |                                        |
+------+----------------------+----------------------------------------+
| `as` | Alert handler        | Erfolgreiche Ausführung eines Alert    |
|      | execution,           | Handlers                               |
|      | successful           |                                        |
+------+----------------------+----------------------------------------+
| `af` | Alert handler        | Gescheiterte Ausführung eines Alert    |
|      | execution, failed    | Handlers                               |
+------+----------------------+----------------------------------------+

+------+----------------------+----------------------------------------+
| E    |                      |                                        |
| reig |                      |                                        |
| nist |                      |                                        |
| ypen |                      |                                        |
| für  |                      |                                        |
| Serv |                      |                                        |
| ices |                      |                                        |
+======+======================+========================================+
| **   | **Bedeutung**        | **Beschreibung**                       |
| Kürz |                      |                                        |
| el** |                      |                                        |
+------+----------------------+----------------------------------------+
| `rw` | OK ➤ WARN            | Setzt den Service-Zustand von          |
|      |                      | [OK]{.state0} auf [WARN]{.state1}      |
+------+----------------------+----------------------------------------+
| `rr` | OK ➤ OK              | Setzt den Service-Zustand von          |
|      |                      | [OK]{.state0} auf [OK]{.state0}        |
+------+----------------------+----------------------------------------+
| `rc` | OK ➤ CRIT            | Setzt den Service-Zustand von          |
|      |                      | [OK]{.state0} auf [CRIT]{.state2}      |
+------+----------------------+----------------------------------------+
| `ru` | OK ➤ UNKNOWN         | Setzt den Service-Zustand von          |
|      |                      | [OK]{.state0} auf [UNKNOWN]{.state3}   |
+------+----------------------+----------------------------------------+
| `wr` | WARN ➤ OK            | Setzt den Service-Zustand von          |
|      |                      | [WARN]{.state1} auf [OK]{.state0}      |
+------+----------------------+----------------------------------------+
| `wc` | WARN ➤ CRIT          | Setzt den Service-Zustand von          |
|      |                      | [WARN]{.state1} auf [CRIT]{.state2}    |
+------+----------------------+----------------------------------------+
| `wu` | WARN ➤ UNKNOWN       | Setzt den Service-Zustand von          |
|      |                      | [WARN]{.state1} auf [UNKNOWN]{.state3} |
+------+----------------------+----------------------------------------+
| `cr` | CRIT ➤ OK            | Setzt den Service-Zustand von          |
|      |                      | [CRIT]{.state2} auf [OK]{.state0}      |
+------+----------------------+----------------------------------------+
| `cw` | CRIT ➤ WARN          | Setzt den Service-Zustand von          |
|      |                      | [CRIT]{.state2} auf [WARN]{.state1}    |
+------+----------------------+----------------------------------------+
| `cu` | CRIT ➤ UNKNOWN       | Setzt den Service-Zustand von          |
|      |                      | [CRIT]{.state2} auf [UNKNOWN]{.state3} |
+------+----------------------+----------------------------------------+
| `ur` | UNKNOWN ➤ OK         | Setzt den Service-Zustand von          |
|      |                      | [UNKNOWN]{.state3} auf [OK]{.state0}   |
+------+----------------------+----------------------------------------+
| `uw` | UNKNOWN ➤ WARN       | Setzt den Service-Zustand von          |
|      |                      | [UNKNOWN]{.state3} auf [WARN]{.state1} |
+------+----------------------+----------------------------------------+
| `uc` | UNKNOWN ➤ CRIT       | Setzt den Service-Zustand von          |
|      |                      | [UNKNOWN]{.state3} auf [CRIT]{.state2} |
+------+----------------------+----------------------------------------+
| `?r` | any ➤ OK             | Setzt jeden beliebigen Service-Zustand |
|      |                      | auf [OK]{.state0}                      |
+------+----------------------+----------------------------------------+
| `?w` | any ➤ WARN           | Setzt jeden beliebigen Service-Zustand |
|      |                      | auf [WARN]{.state1}                    |
+------+----------------------+----------------------------------------+
| `?c` | any ➤ CRIT           | Setzt jeden beliebigen Service-Zustand |
|      |                      | auf [CRIT]{.state2}                    |
+------+----------------------+----------------------------------------+
| `?u` | any ➤ UNKNOWN        | Setzt jeden beliebigen Service-Zustand |
|      |                      | auf [UNKNOWN]{.state3}                 |
+------+----------------------+----------------------------------------+

::: paragraph
Basierend auf diesen Hinweisen können Sie Ihre Regeln prüfen und
überarbeiten.
:::

::: paragraph
Eine weitere wichtige Diagnosemöglichkeit ist die Log-Datei
`~/var/log/notify.log`. Während Tests mit den Benachrichtigungen bietet
sich dazu der beliebte Befehl `tail -f` an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ tail -f var/log/notify.log
2021-08-26 17:11:58,914 [20] [cmk.base.notify] Analysing notification (mysrv;Temperature Zone 7) context with 71 variables
2021-08-26 17:11:58,915 [20] [cmk.base.notify] Global rule 'Notify all contacts of a host/service via HTML email'...
2021-08-26 17:11:58,915 [20] [cmk.base.notify]  -> matches!
2021-08-26 17:11:58,915 [20] [cmk.base.notify]    - adding notification of hh via mail
2021-08-26 17:11:58,916 [20] [cmk.base.notify] Executing 1 notifications:
2021-08-26 17:11:58,916 [20] [cmk.base.notify]   * would notify hh via mail, parameters: smtp, graphs_per_notification, notifications_with_graphs, bulk: no
```
:::
::::

::: paragraph
Mit [Global settings \> Notifications \> Notification log
level]{.guihint} können Sie die Ausführlichkeit der Meldungen in drei
Stufen steuern. Wenn Sie [Full dump of all variables and
command]{.guihint} auswählen, so finden Sie in der Log-Datei eine
komplette Auflistung aller Variablen, die dem
[Benachrichtigungsskript](#scripts) bereitgestellt werden:
:::

:::: imageblock
::: content
![Globale Einstellung zur Festlegung der
Protokollierungsebene.](../images/notifications_log_level.png)
:::
::::

::: paragraph
Dies sieht dann z.B. so aus (Auszug):
:::

::::: listingblock
::: title
\~/var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2021-08-26 17:24:54,709 [10] [cmk.base.notify] Raw context:
                    CONTACTS=hh
                    HOSTACKAUTHOR=
                    HOSTACKCOMMENT=
                    HOSTADDRESS=127.0.0.1
                    HOSTALIAS=localhost
                    HOSTATTEMPT=1
                    HOSTCHECKCOMMAND=check-mk-host-smart
```
:::
:::::
:::::::::::::::::::::
::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect2
### []{#async .hidden-anchor .sr-only}7.5. Asynchrone Zustellung durch Benachrichtigungs-Spooler {#heading_async}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Eine mächtige
Zusatzfunktion der kommerziellen Editionen ist der
*Benachrichtigungs-Spooler*. Dieser ermöglicht eine asynchrone
Zustellung von Benachrichtigungen. Was bedeutet asynchron in diesem
Zusammenhang?
:::

::: ulist
- Synchrone Zustellung: Das Benachrichtigungsmodul wartet, bis das
  Benachrichtigungsskript fertig ausgeführt wurde. Sollte dies eine
  längere Ausführungszeit haben, stauen sich weitere Benachrichtigungen
  auf. Wird das Monitoring angehalten, gehen diese Benachrichtigungen
  verloren. Außerdem kann sich bei vielen Benachrichtigungen in kurzer
  Zeit ein Rückstau bis zum Kern bilden, so dass das Monitoring dadurch
  ins Stocken gerät.

- Asynchrone Zustellung: Jede Benachrichtigung wird in einer Spool-Datei
  unter `~/var/check_mk/notify/spool` abgelegt. Es kann sich kein Stau
  bilden. Bei einem Stopp des Monitorings bleiben die Spool-Dateien
  erhalten und Benachrichtigungen werden später korrekt zugestellt. Das
  Abarbeiten der Spool-Dateien übernimmt der Benachrichtigungs-Spooler.
:::

::: paragraph
Eine synchrone Zustellung ist dann vertretbar, wenn das
Benachrichtigungsskript schnell läuft und vor allem nicht in irgendeinen
Timeout geraten kann. Bei Benachrichtigungsmethoden, die auf vorhandene
Spooler zurückgreifen, ist das gegeben. Insbesondere bei E-Mail und SMS
kommen Spool-Dienste vom System zum Einsatz. Das Benachrichtigungsskript
übergibt eine Datei an den System-Spooler, wobei keine Wartezustände
auftreten können.
:::

::: paragraph
Bei Verwendung der [nachvollziehbaren Zustellung per SMTP](#syncsmtp)
oder anderer Skripte, welche Netzwerkverbindungen aufbauen, sollten Sie
**auf jeden Fall** die asynchrone Zustellung einstellen. Dazu gehören
auch Skripte, welche per HTTP Textnachrichten (SMS) über das Internet
versenden. Die Timeouts bei der Verbindung zu einem Netzwerkdienst
können bis zu mehrere Minuten lang sein und den oben beschriebenen Stau
auslösen.
:::

::: paragraph
Die gute Nachricht: Die asynchrone Zustellung ist in Checkmk
standardmäßig aktiviert. Zum einen wird der Benachrichtigungs-Spooler
(`mknotifyd`) beim Start der Instanz mitgestartet, was Sie mit dem
folgenden Kommando überprüfen können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd status mknotifyd
mknotifyd:      running
-----------------------
Overall state:  running
```
:::
::::

::: paragraph
Zum anderen ist in den globalen Einstellungen ([Global settings \>
Notifications \> Notification Spooling]{.guihint}) die asynchrone
Zustellung ([Asynchronous local delivery by notification
spooler]{.guihint}) ausgewählt:
:::

:::: imageblock
::: content
![Globale Einstellung zur Zustellungsmethode des
Benachrichtigungs-Spoolers.](../images/notifications_spooling.png)
:::
::::

::::::: sect3
#### []{#_fehlerdiagnose_2 .hidden-anchor .sr-only}Fehlerdiagnose {#heading__fehlerdiagnose_2}

::: paragraph
Der Benachrichtigungs-Spooler pflegt eine eigene Log-Datei:
`~/var/log/mknotifyd.log`. Diese verfügt über drei Log-Levels, die Sie
unter [Global settings \> Notifications \> Notification Spooler
Configuration]{.guihint} mit dem Parameter [Verbosity of
logging]{.guihint} auswählen können. Der Default steht auf [Normal
logging (only startup, shutdown and errors]{.guihint}. Bei der mittleren
Stufe, [Verbose logging (also spooled notifications),]{.guihint} können
Sie das Bearbeiten der Spool-Dateien sehen:
:::

::::: listingblock
::: title
\~/var/log/mknotifyd.log
:::

::: content
``` {.pygments .highlight}
2021-08-26 18:05:02,928 [15] [cmk.mknotifyd] processing spoolfile: /omd/sites/mysite/var/check_mk/notify/spool/dad64e2e-b3ac-4493-9490-8be969a96d8d
2021-08-26 18:05:02,928 [20] [cmk.mknotifyd] running cmk --notify --log-to-stdout spoolfile /omd/sites/mysite/var/check_mk/notify/spool/dad64e2e-b3ac-4493-9490-8be969a96d8d
2021-08-26 18:05:05,848 [20] [cmk.mknotifyd] got exit code 0
2021-08-26 18:05:05,850 [20] [cmk.mknotifyd] processing spoolfile dad64e2e-b3ac-4493-9490-8be969a96d8d successful: success 250 - b'2.0.0 Ok: queued as 1D4FF7F58F9'
2021-08-26 18:05:05,850 [20] [cmk.mknotifyd] sending command LOG;SERVICE NOTIFICATION RESULT: hh;mysrv;CPU load;OK;mail;success 250 - b'2.0.0 Ok: queued as 1D4FF7F58F9';success 250 - b'2.0.0 Ok: queued as 1D4FF7F58F9'
```
:::
:::::
:::::::
::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::: sect1
## []{#bulk .hidden-anchor .sr-only}8. Sammelbenachrichtigung (Bulk notifications) {#heading_bulk}

::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_übersicht_2 .hidden-anchor .sr-only}8.1. Übersicht {#heading__übersicht_2}

::: paragraph
Jeder, der mit Monitoring arbeitet, hat schon einmal erlebt, dass ein
isoliertes Problem eine ganze Flut von (Folge-)Benachrichtigungen
losgetreten hat. Mit den [Parent-Hosts](#parents) lässt sich dies in
bestimmten Fällen vermeiden, leider aber nicht in allen.
:::

::: paragraph
Nehmen Sie ein Beispiel aus dem Checkmk-Projekt selbst: Einmal pro Tag
bauen wir für jede unterstützte Linux-Distribution Installationspakete
von Checkmk. Unser eigenes Checkmk-Monitoring ist so eingerichtet, dass
wir für jede Distribution einen Service haben, der nur dann
[OK]{.state0} ist, wenn die richtige Anzahl von Paketen korrekt gebaut
wurde. Nun kommt es gelegentlich vor, dass ein genereller Fehler in der
Software das Paketieren verhindert und so gleichzeitig 43 Services auf
[CRIT]{.state2} gehen.
:::

::: paragraph
Die Benachrichtigungen sind bei uns so konfiguriert, dass in so einem
Fall nur eine einzige E-Mail versendet wird, welche alle 43
Benachrichtigungen nacheinander auflistet. Das ist natürlich viel
übersichtlicher als 43 einzelne E-Mails und verhindert, dass man im
Eifer des Gefechts eine 44. E-Mail übersieht, die zu einem ganz anderen
Problem gehört.
:::

::: paragraph
Die Funktionsweise dieser *Sammelbenachrichtigung* ist sehr einfach.
Wenn eine Benachrichtigung auftritt, so wird diese zunächst eine kurze
Zeit lang zurückgehalten. Weitere Benachrichtigungen, die während dieser
Zeit kommen, werden dann gleich mit in dieselbe E-Mail gepackt. Das
Sammeln stellen Sie *pro Regel* ein. So können Sie z. B. tagsüber mit
Einzel-E-Mails arbeiten, nachts aber mit einer Sammelbenachrichtigung.
Wird in einer Regel die Sammelbenachrichtigung aktiviert, so erhalten
Sie folgende Optionen:
:::

:::: imageblock
::: content
![Benachrichtigungsregel mit den Optionen zur
Sammelbenachrichtigung.](../images/notifications_bulk.png)
:::
::::

::: paragraph
Die Wartezeit können Sie beliebig konfigurieren. In vielen Fällen genügt
eine Minute, da spätestens dann alle verwandten Probleme aufschlagen
sollten. Sie können natürlich auch einen größeren Zeitraum einstellen.
Dadurch entsteht aber eine grundsätzliche Verzögerung der
Benachrichtigung.
:::

::: paragraph
Da es keinen Sinn ergibt, alles in einen Topf zu werfen, können Sie
bestimmen, welche Gruppen von Problemen jeweils gemeinsam benachrichtigt
werden sollen. Üblicherweise wird die Option [Host]{.guihint} gewählt,
die dafür sorgt, dass nur Benachrichtigungen vom gleichen Host
zusammengefasst werden.
:::

::: paragraph
Hier noch ein paar Fakten zur Sammelbenachrichtigung:
:::

::: ulist
- Wenn das Sammeln in einer Regel eingeschaltet ist, kann es mit einer
  späteren Regel auch wieder ausgeschaltet werden --- und umgekehrt.

- Die Sammelbenachrichtigung geschieht immer pro Kontakt. Jeder hat
  quasi seinen privaten „Sammeltopf".

- Sie können die Größe des Topfs limitieren ([Maximum bulk
  size]{.guihint}). Bei Erreichen dieses Maximums wird die
  Sammelbenachrichtigung sofort verschickt.
:::
:::::::::::::

::::: sect2
### []{#_sammelbenachrichtigungen_und_zeitperioden .hidden-anchor .sr-only}8.2. Sammelbenachrichtigungen und Zeitperioden {#heading__sammelbenachrichtigungen_und_zeitperioden}

::: paragraph
Was ist eigentlich, wenn eine Benachrichtigung innerhalb der
Benachrichtigungsperiode liegt, die Sammelbenachrichtigung, die ihn
enthält --- die ja etwas später kommt --- dann aber schon außerhalb
liegt? Und auch der umgekehrte Fall ist ja möglich ...​
:::

::: paragraph
Hier gilt ein ganz einfaches Prinzip: Alle Konfigurationen, die
Benachrichtigungen auf Zeitperioden eingrenzen, gelten immer nur **für
die eigentliche Benachrichtigung**. Die später folgende
Sammelbenachrichtigung wird immer **unabhängig** von sämtlichen
Zeitperioden zugestellt.
:::
:::::
:::::::::::::::::
::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::: sect1
## []{#syncsmtp .hidden-anchor .sr-only}9. Nachvollziehbare Zustellung per SMTP {#heading_syncsmtp}

:::::::::::::::::::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#_e_mail_ist_nicht_zuverlässig .hidden-anchor .sr-only}9.1. E-Mail ist nicht zuverlässig {#heading__e_mail_ist_nicht_zuverlässig}

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Das Monitoring
ist nur nützlich, wenn man sich auch darauf verlassen kann. Dazu gehört,
dass Benachrichtigungen *zuverlässig* und *zeitnah* ankommen. Nun ist
die Zustellung von E-Mails hier leider nicht ganz ideal. Denn der
Versand geschieht üblicherweise durch Übergabe der E-Mail an den lokalen
SMTP-Server. Dieser versucht dann die E-Mail selbständig und asynchron
zuzustellen.
:::

::: paragraph
Bei einem vorübergehenden Fehler (z.B. falls der empfangende SMTP-Server
nicht erreichbar ist) wird die E-Mail in eine Warteschlange versetzt und
später ein erneuter Zustellversuch gestartet. Dieses „später" ist dann
in der Regel frühestens in 15-30 Minuten. Aber dann kann die
Benachrichtigung eventuell schon viel zu spät sein!
:::

::: paragraph
Ist die E-Mail gar nicht zustellbar, so erzeugt der SMTP-Server eine
hübsche Fehlermeldung in seiner Log-Datei und versucht, an den
„Absender" eine E-Mail über die gescheiterte Zustellung zu generieren.
Aber das Monitoring-System ist kein richtiger Absender und kann auch
keine E-Mails empfangen. In der Folge gehen solche Fehler dann einfach
unter und Benachrichtigungen bleiben aus.
:::

::: paragraph
**Wichtig:** Für [Sammelbenachrichtigungen](#bulk) steht die
nachvollziehbare Benachrichtigung nicht zur Verfügung!
:::
:::::::

::::: sect2
### []{#_smtp_auf_direktem_weg_ermöglicht_fehlerauswertung .hidden-anchor .sr-only}9.2. SMTP auf direktem Weg ermöglicht Fehlerauswertung {#heading__smtp_auf_direktem_weg_ermöglicht_fehlerauswertung}

::: paragraph
Die kommerziellen Editionen bieten die Möglichkeit einer
*nachvollziehbaren* Zustellung per SMTP. Dabei wird bewusst auf eine
Hilfe des lokalen Mailservers verzichtet. Anstelle dessen sendet Checkmk
selbst die E-Mail direkt via SMTP zu Ihrem Smarthost und wertet die
SMTP-Antwort auch selbst aus.
:::

::: paragraph
Dabei werden nicht nur SMTP-Fehler intelligent behandelt, es wird auch
eine korrekte Zustellung genau protokolliert. Es ist ein bisschen wie
ein Einschreiben: Checkmk bekommt quasi vom SMTP-Smarthost (empfangender
Server) eine Quittung, dass die E-Mail übernommen wurde --- inklusive
einer Mail-ID.
:::
:::::

::::::::::::::::::::::::::::: sect2
### []{#_synchrone_zustellung_für_html_e_mails .hidden-anchor .sr-only}9.3. Synchrone Zustellung für HTML-E-Mails {#heading__synchrone_zustellung_für_html_e_mails}

::: paragraph
Die nachvollziehbare Zustellung per SMTP können Sie für die
Benachrichtigungsmethode HTML-E-Mail auswählen und konfigurieren, indem
Sie den Smarthost (mit Name und Portnummer) und die Zugangsdaten und
Verschlüsselungsmethode eintragen:
:::

:::: imageblock
::: content
![Benachrichtigungsregel mit den Optionen für die synchrone
E-Mail-Zustellung.](../images/notifications_enable_sync_smtp.png)
:::
::::

::: paragraph
In der Historie des betroffenen Services können Sie das dann die
Zustellung genau nachverfolgen. Hier ist ein Beispiel, in dem ein
Service testweise von Hand auf [CRIT]{.state2} gesetzt wurde. Folgende
Abbildung zeigt die Benachrichtigungen für diesen Service, die Sie sich
auf der Seite mit den Service-Details mit [Service \> Service
Notifications]{.guihint} anzeigen lassen können:
:::

:::: imageblock
::: content
![Liste aufgelaufener Benachrichtigungen für eine erfolgreiche
E-Mail-Zustellung.](../images/notifications_smtp_success.png)
:::
::::

::: paragraph
Sie sehen dabei die vier Einzelschritte in der zeitlichen Abfolge von
unten nach oben, wie wir sie bereits im Kapitel zur
[Benachrichtigungshistorie](#history) vorgestellt haben. Der wichtige
Unterschied ist, dass jetzt im [![icon alert notify
result](../images/icons/icon_alert_notify_result.png)]{.image-inline}
obersten Eintrag zu sehen ist, dass die E-Mail erfolgreich an den
Smarthost übergeben wurde und dessen Antwort `success` ist.
:::

::: paragraph
Die einzelnen Schritte können Sie auch in der Log-Datei `notify.log`
nachverfolgen. Die folgenden Zeilen gehören zum letzten Schritt und
enthalten die Antwort des SMTP-Servers:
:::

::::: listingblock
::: title
\~/var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2021-08-26 10:02:22,016 [20] [cmk.base.notify] Got spool file d3b417a5 (mysrv;CPU load) for local delivery via mail
2021-08-26 10:02:22,017 [20] [cmk.base.notify]      executing /omd/sites/mysite/share/check_mk/notifications/mail
2021-08-26 10:02:29,538 [20] [cmk.base.notify]      Output: success 250 - b'2.0.0 Ok: queued as 1BE667EE7D6'
```
:::
:::::

::: paragraph
Die Message-ID `1BE667EE7D6` wird in der Log-Datei des Smarthosts
auftauchen. Dort können Sie dann im Zweifel recherchieren, wo die E-Mail
verblieben ist. Auf jeden Fall können Sie so belegen, das und wann Sie
von Checkmk korrekt übergeben wurde.
:::

::: paragraph
Wiederholen wir den Test von oben, jedoch diesmal mit einem falsch
konfigurierten Passwort für die SMTP-Übergabe an den Smarthost. Hier
sieht man im Klartext die SMTP-Fehlermeldung
`Error: authentication failed` vom Smarthost:
:::

:::: imageblock
::: content
![Liste aufgelaufener Benachrichtigungen für eine gescheiterte
E-Mail-Zustellung.](../images/notifications_smtp_failed.png)
:::
::::

::: paragraph
Doch was tun bei gescheiterten Benachrichtigungen? Diese wiederum per
E-Mail zu benachrichtigen ist augenscheinlich keine gute Lösung.
Anstelle dessen zeigt Checkmk einen deutlichen Warnhinweis mit roter
Hintergrundfarbe im [Overview](user_interface.html#overview) an:
:::

:::: imageblock
::: content
![Anzeige gescheiterter Benachrichtigungen im Snapin
\'Overview\'.](../images/notifications_overview_failed.png){width="50%"}
:::
::::

::: paragraph
Hier können Sie:
:::

::: ulist
- durch Klick auf den Text [...​ failed notifications]{.guihint} zu einer
  Liste der fehlgeschlagenen Benachrichtigungen kommen und

- durch Klick auf [![Symbol zum
  Löschen.](../images/icons/icon_delete.png)]{.image-inline} diese
  Meldungen bestätigen und mit einem Klick auf [![Symbol zur
  Bestätigung.](../images/icons/icon_confirm.png)]{.image-inline}
  [Confirm]{.guihint} in der sich öffnenden Übersicht den Hinweis wieder
  entfernen.
:::

::: paragraph
**Wichtig:** Beachten Sie, dass die direkte Zustellung per SMTP in
Fehlersituationen dazu führen kann, dass das Benachrichtigungsskript
sehr lange läuft und am Ende in einen Timeout gerät. Deswegen ist es
unbedingt ratsam, dass Sie den Benachrichtigungs-Spooler verwenden und
eine [asynchrone Zustellung](#async) von Benachrichtigungen einstellen.
:::

::: paragraph
Das Verhalten bei wiederholbaren Fehlern (wie einem SMTP-Timeout) können
Sie mit [Global settings \> Notifications \> Notification spooler
configuration]{.guihint} pro Benachrichtigungsmethode einstellen:
:::

:::: imageblock
::: content
![Globale Timer-Einstellung für eine
Benachrichtigungsmethode.](../images/notifications_plugin_timing_settings.png)
:::
::::

::: paragraph
Neben einem optionalen Timeout (Default ist 1 Minute) und einer
maximalen Anzahl von Wiederholversuchen können Sie mit [Maximum
concurrent executions]{.guihint} festlegen, ob das Skript mehrfach
parallel laufen und so gleichzeitig mehrere Benachrichtigungen versenden
darf. Ist das Benachrichtigungsskript sehr langsam, kann eine parallele
Ausführung sinnvoll sein. Allerdings muss es dann auch so programmiert
sein, dass eine Mehrfachausführung sauber läuft (und nicht das Skript
z.B. bestimmte Dateien für sich beansprucht).
:::

::: paragraph
Eine mehrfache parallele Zustellung per SMTP ist unproblematisch, da der
Zielserver mehrere parallele Verbindungen verwalten kann. Bei der
Zustellung von SMS direkt über ein Modem ohne weiteren Spooler ist das
sicher nicht der Fall und Sie sollten dann bei der Einstellung 1
bleiben.
:::
:::::::::::::::::::::::::::::

:::: sect2
### []{#_sms_und_andere_benachrichtigungsmethoden .hidden-anchor .sr-only}9.4. SMS und andere Benachrichtigungsmethoden {#heading__sms_und_andere_benachrichtigungsmethoden}

::: paragraph
Eine synchrone Zustellung inklusive Fehlermeldung und
Nachvollziehbarkeit ist aktuell nur für HTML-E-Mails implementiert. Wie
Sie in einem eigenen Benachrichtigungsskript einen Fehlerstatus
zurückgeben können, erfahren Sie im Kapitel über [das Schreiben von
eigenen Skripten](#scripts).
:::
::::
::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#distributed .hidden-anchor .sr-only}10. Benachrichtigungen in verteilten Systemen {#heading_distributed}

:::::: sectionbody
::: paragraph
In verteilten Umgebungen --- also solchen mit mehr als einer
Checkmk-Instanz --- stellt sich die Frage, was mit Benachrichtigungen
geschehen soll, die auf Remote-Instanzen erzeugt werden. Hier gibt es
grundsätzlich zwei Möglichkeiten:
:::

::: {.olist .arabic}
1.  Lokale Zustellung

2.  Zentrale Zustellung auf der Zentralinstanz (nur kommerzielle
    Editionen)
:::

::: paragraph
Einzelheiten dazu finden Sie im Artikel über das [verteilte
Monitoring](distributed_monitoring.html#notifications).
:::
::::::
:::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#scripts .hidden-anchor .sr-only}11. Benachrichtigungsskripte {#heading_scripts}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::: sect2
### []{#_das_prinzip_2 .hidden-anchor .sr-only}11.1. Das Prinzip {#heading__das_prinzip_2}

::: paragraph
Benachrichtigungen können auf sehr vielfältige und individuelle Weise
geschehen. Typische Fälle sind:
:::

::: ulist
- Übergabe von Benachrichtigungen an ein Ticket- oder externes
  Benachrichtigungssystem

- Versand von SMS über verschiedene Internetdienste

- Automatisierte Anrufe

- Weiterleitung an ein übergeordnetes Monitoring-System
:::

::: paragraph
Aus diesem Grund bietet Checkmk eine sehr einfache Schnittstelle, mit
der Sie selbst eigene Benachrichtigungsskripte schreiben können. Sie
können diese in jeder von Linux unterstützten Programmiersprache
schreiben --- auch wenn Shell, Perl und Python zusammen hier sicher 95 %
„Marktanteil" haben.
:::

::: paragraph
Die von Checkmk [mitgelieferten Skripte](#includedscripts) liegen unter
`~/share/check_mk/notifications`. Dieses Verzeichnis ist Teil der
Software und nicht für Änderungen vorgesehen. Legen Sie eigene Skripte
stattdessen in `~/local/share/check_mk/notifications` ab. Achten Sie
darauf, dass sie ausführbar sind (`chmod +x`). Sie werden dann
automatisch gefunden und bei den Benachrichtigungsregeln als Methode zur
Auswahl angeboten.
:::

::: paragraph
Möchten Sie ein mitgeliefertes Skript anpassen, so kopieren Sie es
einfach von `~/share/check_mk/notifications` nach
`~/local/share/check_mk/notifications` und machen dort Ihre Änderungen.
Wenn Sie dabei den Dateinamen beibehalten, ersetzt Ihr Skript
automatisch die Originalversion und Sie müssen keine bestehenden
Benachrichtigungsregeln anpassen.
:::

::: paragraph
Einige weitere Beispielskripte werden unter
`~/share/doc/check_mk/treasures/notifications` mitgeliefert. Sie können
diese als Vorlage nehmen und anpassen. Die Konfiguration wird meist
direkt im Skript vorgenommen --- Hinweise dazu finden Sie dort in den
Kommentaren.
:::

::: paragraph
Im Falle einer Benachrichtigung wird Ihr Skript mit den Rechten des
Instanzbenutzers aufgerufen. In **Umgebungsvariablen**, die mit
`NOTIFY_` beginnen, bekommt es alle Informationen über den betreffenden
Host/Service, das Monitoring-Ereignis, den zu benachrichtigenden Kontakt
und die Parameter, die in der Benachrichtigungsregel angegeben wurden.
:::

::: paragraph
Texte, die das Skript in die **Standardausgabe** schreibt (mit `print`,
`echo`, etc.), erscheinen in der Log-Datei des Benachrichtigungsmoduls
`~/var/log/notify.log`.
:::
:::::::::::

::::::: sect2
### []{#_nachvollziehbare_benachrichtigungen .hidden-anchor .sr-only}11.2. Nachvollziehbare Benachrichtigungen {#heading__nachvollziehbare_benachrichtigungen}

::: paragraph
Benachrichtigungsskripte haben die Möglichkeit, über den Exit Code
mitzuteilen, ob ein wiederholbarer Fehler aufgetreten ist oder ein
endgültiger:
:::

+-----------------+-----------------------------------------------------+
| Exit Code       | Bedeutung                                           |
+=================+=====================================================+
| `0`             | Das Skript wurde erfolgreich ausgeführt.            |
+-----------------+-----------------------------------------------------+
| `1`             | Ein temporärer Fehler ist aufgetreten. Die          |
|                 | Ausführung soll nach kurzer Zeit erneut probiert    |
|                 | werden, bis die konfigurierte maximale Anzahl von   |
|                 | Versuchen erreicht ist. Beispiel: HTTP-Verbindung   |
|                 | zu SMS-Dienst konnte nicht aufgebaut werden.        |
+-----------------+-----------------------------------------------------+
| `2` und höher   | Ein endgültiger Fehler ist aufgetreten. Die         |
|                 | Benachrichtigungen werden nicht wiederholt. Auf der |
|                 | GUI wird ein Benachrichtigungsfehler angezeigt. Der |
|                 | Fehler wird in der Historie des Hosts/Services      |
|                 | angezeigt. Beispiel: der SMS-Dienst meldet den      |
|                 | Fehler „Ungültige Authentifizierung".               |
+-----------------+-----------------------------------------------------+

::: paragraph
Zudem wird in allen Fällen die Standardausgabe des
Benachrichtigungsskripts zusammen mit dem Status in die
Benachrichtigungshistorie des Hosts/Services eingetragen und ist somit
über die GUI sichtbar.
:::

::: paragraph
**Wichtig:** Für [Sammelbenachrichtigungen](#bulk) steht die
nachvollziehbare Benachrichtigung nicht zur Verfügung!
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Die Behandlung
von Benachrichtigungsfehlern aus Sicht des Benutzers wird im Kapitel
über die [nachvollziehbare Zustellung per SMTP](#syncsmtp) erklärt.
:::
:::::::

:::::::::::: sect2
### []{#example .hidden-anchor .sr-only}11.3. Ein einfaches Beispielskript {#heading_example}

::: paragraph
Als Beispiel können Sie ein Skript erstellen, das alle Informationen zu
der Benachrichtigung in eine Datei schreibt. Als Sprache kommt die Bash
Linux-Shell zum Einsatz:
:::

::::: listingblock
::: title
\~/local/share/check_mk/notifications/foobar
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# Foobar Teleprompter

env | grep NOTIFY_ | sort > $OMD_ROOT/tmp/foobar.out
echo "Successfully written $OMD_ROOT/tmp/foobar.out"
exit 0
```
:::
:::::

::: paragraph
Danach machen Sie das Skript ausführbar:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ chmod +x local/share/check_mk/notifications/foobar
```
:::
::::

::: paragraph
Hier einige Erklärungen zum Skript:
:::

::: ulist
- In der ersten Zeile stehen `#!` und der Pfad zum Interpreter der
  Skriptsprache (hier `/bin/bash`).

- In der zweiten Zeile steht nach dem Kommentarzeichen `#` ein **Titel**
  für das Skript. Dieser wird bei der Auswahl der
  Benachrichtigungsmethode in der Regel angezeigt.

- Der Befehl `env` gibt alle Umgebungsvariablen aus, die das Skript
  bekommen hat.

- Mit `grep NOTIFY_` werden die Variablen von Checkmk
  herausgefiltert ...​

- ... und mit `sort` alphabetisch sortiert.

- `> $OMD_ROOT/tmp/foobar.out` schreibt das Ergebnis in die Datei
  `~/tmp/foobar.out` im Instanzverzeichnis.

- Das `exit 0` wäre an dieser Stelle eigentlich überflüssig, da die
  Shell immer den Exit Code des letzten Befehls übernimmt. Dieser ist
  hier `echo` und immer erfolgreich. Aber explizit ist immer besser.
:::
::::::::::::

:::::::::::::::: sect2
### []{#example_test .hidden-anchor .sr-only}11.4. Beispielskript testen {#heading_example_test}

::: paragraph
Damit das Skript verwendet wird, müssen Sie es in einer
Benachrichtigungsregel als Methode einstellen. Selbst geschriebene
Skripte haben keine Parameterdeklaration. Daher fehlen die ganzen
Checkboxen, wie sie z.B. bei der Methode [HTML Email]{.guihint}
angeboten werden. Anstelle dessen können Sie eine Liste von Texten als
Parameter angeben, die dem Skript als `NOTIFY_PARAMETER_1`,
`NOTIFY_PARAMETER_2` usw. bereitgestellt werden. Für den Test übergeben
Sie die Parameter `Fröhn`, `Klabuster` und `Feinbein`:
:::

:::: imageblock
::: content
![Regel mit Auswahl des Beispielskripts als
Benachrichtigungsmethode.](../images/notifications_method_foobar.png)
:::
::::

::: paragraph
Nun setzen Sie zum Test den Service `CPU load` auf dem Host `myserver`
auf [CRIT]{.state2} --- mit dem [Kommando](commands.html) [Fake check
results.]{.guihint} In der Log-Datei des Benachrichtigungsmoduls
`~/var/log/notify.log` sehen Sie die Ausführung des Skripts samt
Parametern und der erzeugten Spool-Datei:
:::

::::: listingblock
::: title
\~/var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2021-08-25 13:01:23,887 [20] [cmk.base.notify] Executing 1 notifications:
2021-08-25 13:01:23,887 [20] [cmk.base.notify]   * notifying hh via foobar, parameters: Fröhn, Klabuster, Feinbein, bulk: no
2021-08-25 13:01:23,887 [20] [cmk.base.notify] Creating spoolfile: /omd/sites/mysite/var/check_mk/notify/spool/e1b5398c-6920-445a-888e-f17e7633de60
```
:::
:::::

::: paragraph
Die Datei `~/tmp/foobar.out` enthält nun eine alphabetische Liste aller
Checkmk-Umgebungsvariablen, die Informationen über die Benachrichtigung
beinhalten. Dort können Sie sich orientieren, was für Werte für Ihr
Skript zur Verfügung stehen. Hier die ersten zehn Zeilen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ head tmp/foobar.out
NOTIFY_ALERTHANDLERNAME=debug
NOTIFY_ALERTHANDLEROUTPUT=Arguments:
NOTIFY_ALERTHANDLERSHORTSTATE=OK
NOTIFY_ALERTHANDLERSTATE=OK
NOTIFY_CONTACTALIAS=Harry Hirsch
NOTIFY_CONTACTEMAIL=harryhirsch@example.com
NOTIFY_CONTACTNAME=hh
NOTIFY_CONTACTPAGER=
NOTIFY_CONTACTS=hh
NOTIFY_DATE=2021-08-25
```
:::
::::

::: paragraph
Auch die Parameter lassen sich hier wiederfinden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ grep PARAMETER tmp/foobar.out
NOTIFY_PARAMETERS=Fröhn Klabuster Feinbein
NOTIFY_PARAMETER_1=Fröhn
NOTIFY_PARAMETER_2=Klabuster
NOTIFY_PARAMETER_3=Feinbein
```
:::
::::
::::::::::::::::

:::::: sect2
### []{#environment_variables .hidden-anchor .sr-only}11.5. Umgebungsvariablen {#heading_environment_variables}

::: paragraph
Im obigen Beispiel haben Sie einige Umgebungsvariablen gesehen, die dem
Skript übergeben wurden. Welche Variablen genau bereitstehen, hängt ab
von der Art der Benachrichtigung, der Checkmk-Version und -Edition und
dem verwendeten Monitoring-Kern ([CMC](cmc.html) or Nagios). Neben dem
Trick mit dem Kommando `env` gibt es noch zwei weitere Wege zu einer
vollständigen Liste aller Variablen:
:::

::: ulist
- Das Hochschalten des Log-Levels für `~/var/log/notify.log` über
  [Global settings \> Notifications \> Notification log
  level]{.guihint}.

- Bei Benachrichtigungen per [HTML Email]{.guihint} gibt es eine
  Checkbox [Information to be displayed in the email body]{.guihint} und
  dort die Option [Complete variable list (for testing)]{.guihint}.
:::

::: paragraph
Folgendes sind die wichtigsten Variablen:
:::

+---------------------------+------------------------------------------+
| Umgebungsvariable         | Beschreibung                             |
+===========================+==========================================+
| `OMD_ROOT`                | Home-Verzeichnis der Instanz, z.B.       |
|                           | `/omd/sites/mysite`                      |
+---------------------------+------------------------------------------+
| `OMD_SITE`                | Name der Instanz, z.B. `mysite`          |
+---------------------------+------------------------------------------+
| `NOTIFY_WHAT`             | Bei Host-Benachrichtigungen das Wort     |
|                           | `HOST`, sonst `SERVICE`. Damit können    |
|                           | Sie Ihr Skript so intelligent machen,    |
|                           | dass es in beiden Fällen sinnvolle       |
|                           | Informationen meldet.                    |
+---------------------------+------------------------------------------+
| `NOTIFY_CONTACTNAME`      | Benutzername (Login) des Kontakts        |
+---------------------------+------------------------------------------+
| `NOTIFY_CONTACTEMAIL`     | E-Mail-Adresse des Kontakts              |
+---------------------------+------------------------------------------+
| `NOTIFY_CONTACTPAGER`     | Eintrag im Feld [Pager]{.guihint} des    |
|                           | Benutzerprofils des Kontakts. Da das     |
|                           | Feld meist nicht für einen bestimmten    |
|                           | Zweck belegt ist, können Sie es einfach  |
|                           | nutzen, um eine für die Benachrichtigung |
|                           | nötige Information pro Benutzer zu       |
|                           | speichern.                               |
+---------------------------+------------------------------------------+
| `NOTIFY_DATE`             | Datum der Benachrichtigung im            |
|                           | ISO-8601-Format, z.B. `2021-08-25`       |
+---------------------------+------------------------------------------+
| `NOTIFY_LONGDATETIME`     | Datum und Uhrzeit in der                 |
|                           | nicht-lokalisierten Standarddarstellung  |
|                           | des Linux-Systems, z.B.                  |
|                           | `Wed Aug 25 15:18:58 CEST 2021`          |
+---------------------------+------------------------------------------+
| `NOTIFY_SHORTDATETIME`    | Datum und Uhrzeit im ISO-Format, z.B.    |
|                           | `2021-08-25 15:18:58`                    |
+---------------------------+------------------------------------------+
| `NOTIFY_HOSTNAME`         | Name des betroffenen Hosts               |
+---------------------------+------------------------------------------+
| `NOTIFY_HOSTOUTPUT`       | Ausgabe des Check-Plugins des            |
|                           | Host-Checks, z.B.                        |
|                           | `Packet received via smart PING`. Diese  |
|                           | Ausgabe ist nur bei                      |
|                           | Host-Benachrichtigungen interessant,     |
|                           | aber auch bei Service-Benachrichtigungen |
|                           | vorhanden.                               |
+---------------------------+------------------------------------------+
| `NOTIFY_HOSTSTATE`        | Eines der Worte `UP`, `DOWN` oder        |
|                           | `UNREACH`                                |
+---------------------------+------------------------------------------+
| `NOTIFY_NOTIFICATIONTYPE` | Typ der Benachrichtigung, wie in der     |
|                           | [Einleitung dieses Artikels](#intro)     |
|                           | beschrieben. Er wird durch eines der     |
|                           | folgenden Worte ausgedrückt:\            |
|                           | `PROBLEM`: Normales                      |
|                           | Host-/Service-Problem\                   |
|                           | `RECOVERY`: Host/Service kehrt zurück    |
|                           | zum Zustand [UP]{.hstate0} /             |
|                           | [OK]{.state0}\                           |
|                           | `ACKNOWLEDGEMENT (…​)`:                   |
|                           | [Quittierung](basics_ackn.html) eines    |
|                           | Problems\                                |
|                           | `FLAPPINGSTART`: Host/Service beginnt    |
|                           | unstetig zu sein\                        |
|                           | `FLAPPINGSTOP`: Ende der Unstetigkeit\   |
|                           | `DOWNTIMESTART`: Beginn einer            |
|                           | [Wartungszeit](basics_downtimes.html)\   |
|                           | `DOWNTIMEEND`: Normales Ende einer       |
|                           | Wartungszeit\                            |
|                           | `DOWNTIMECANCELLED`: Vorzeitiger Abbruch |
|                           | einer Wartungszeit\                      |
|                           | `CUSTOM`: Mit [Kommando](commands.html)  |
|                           | manuell ausgelöste Benachrichtigung\     |
|                           | `ALERTHANDLER (…​)`: Alert                |
|                           | Handler-Ausführung (nur kommerzielle     |
|                           | Editionen)\                              |
|                           | Bei den Typen mit `(…​)` stehen in der    |
|                           | Klammer weitere Informationen über die   |
|                           | Art der Benachrichtigung.                |
+---------------------------+------------------------------------------+
| `NOTIFY_PARAMETERS`       | Alle Parameter des Skripts durch         |
|                           | Leerzeichen getrennt                     |
+---------------------------+------------------------------------------+
| `NOTIFY_PARAMETER_1`      | Erster Parameter des Skripts             |
+---------------------------+------------------------------------------+
| `NOTIFY_PARAMETER_2`      | Zweiter Parameter des Skripts, usw.      |
+---------------------------+------------------------------------------+
| `NOTIFY_SERVICEDESC`      | Name des betroffenen Services. Bei       |
|                           | Host-Benachrichtigungen ist diese        |
|                           | Variable nicht vorhanden.                |
+---------------------------+------------------------------------------+
| `NOTIFY_SERVICEOUTPUT`    | Ausgabe des Check-Plugins des            |
|                           | Service-Checks (nicht bei                |
|                           | Host-Benachrichtigungen)                 |
+---------------------------+------------------------------------------+
| `NOTIFY_SERVICESTATE`     | Eines der Worte `OK`, `WARN`, `CRIT`     |
|                           | oder `UNKNOWN`                           |
+---------------------------+------------------------------------------+
::::::

::::::::::::::: sect2
### []{#_sammelbenachrichtigungen .hidden-anchor .sr-only}11.6. Sammelbenachrichtigungen {#heading__sammelbenachrichtigungen}

::: paragraph
Wenn Ihr Skript [Sammelbenachrichtigungen](#bulk) unterstützen soll,
müssen Sie es speziell dafür präparieren, da hier dem Skript *mehrere
Benachrichtigungen auf einmal* übergeben werden. Aus diesem Grund
funktioniert dann auch die Übergabe per Umgebungsvariablen nicht mehr
sinnvoll.
:::

::: paragraph
Deklarieren Sie Ihr Skript in der *dritten Zeile* im Kopf wie folgt,
dann sendet das Benachrichtigungsmodul die Benachrichtigungen auf der
*Standardeingabe:*
:::

::::: listingblock
::: title
\~/local/share/check_mk/notifications/mybulk
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# My Bulk Notification
# Bulk: yes
```
:::
:::::

::: paragraph
Auf der Standardeingabe werden dem Skript Blöcke von Variablen gesendet.
Jede Zeile hat die Form `NAME=VALUE`. Blöcke werden getrennt durch
Leerzeilen. Das ASCII-Zeichen mit dem Code 1 (`\a`) wird verwendet, um
innerhalb der Texte Zeilenumbrüche (*newlines*) darzustellen.
:::

::: paragraph
Der erste Block enthält eine Liste von allgemeinen Variablen (z.B.
Aufrufparameter). Jeder weitere Block fasst die Variablen zu einer
Benachrichtigung zusammen.
:::

::: paragraph
Am besten, Sie probieren das Ganze erst einmal mit einem einfachen Test
aus, der die kompletten Daten in eine Datei schreibt und sehen sich an,
wie die Daten gesendet werden. Dazu können Sie z.B. das folgende
Benachrichtigungsskript nutzen:
:::

::::: listingblock
::: title
\~/local/share/check_mk/notifications/mybulk
:::

::: content
``` {.pygments .highlight}
#!/bin/bash
# My Bulk Notification
# Bulk: yes

cat > $OMD_ROOT/tmp/mybulktest.out
```
:::
:::::

::: paragraph
Testen Sie das Skript wie [oben beschrieben](#example_test) und
aktivieren Sie zusätzlich in der Benachrichtigungsregel die
Sammelbenachrichtigung ([Notification Bulking]{.guihint}).
:::
:::::::::::::::

::::: sect2
### []{#includedscripts .hidden-anchor .sr-only}11.7. Mitgelieferte Benachrichtigungsskripte {#heading_includedscripts}

::: paragraph
Im Auslieferungszustand stellt Checkmk bereits eine ganze Reihe Skripte
bereit zur Anbindung an beliebte und weit verbreitete
Instant-Messaging-Dienste, Incident-Management-Plattformen und
Ticketsysteme. Wie Sie diese Skripte nutzen können, erfahren Sie in den
folgenden Artikeln:
:::

::: ulist
- [Cisco Webex Teams](notifications_webex.html)

- [ilert](notifications_ilert.html)

- [Jira](notifications_jira.html)

- [Mattermost](notifications_mattermost.html)

- [Microsoft Teams](notifications_teams.html)

- [PagerDuty](notifications_pagerduty.html)

- [Pushover](notifications_pushover.html)

- [Opsgenie](notifications_opsgenie.html)

- [ServiceNow](notifications_servicenow.html)

- [SIGNL4](notifications_signl4.html)

- [Slack](notifications_slack.html)

- [Splunk On-Call](notifications_splunkoncall.html)
:::
:::::

:::::::::::: sect2
### []{#fake_check_results .hidden-anchor .sr-only}11.8. Benachrichtigungen mit [Fake check results]{.guihint} testen {#heading_fake_check_results}

::: paragraph
Um andere Benachrichtigungsmethoden als E-Mail zu testen, können Sie
einen [OK]{.state0}-Service einfach von Hand auf [CRIT]{.state2} setzen.
Dies geht mit dem [Kommando](commands.html) [Fake check
results,]{.guihint} das Sie in der Service-Liste im Menü
[Commands]{.guihint} finden. Sollten Sie das Kommando in der Liste nicht
sehen, klicken Sie bitte vorher noch auf den Knopf [Show more]{.guihint}
[![button
showmore](../images/icons/button_showmore.png)]{.image-inline}.
:::

:::: imageblock
::: content
![Dialog zum manuellen
Zustandswechsel.](../images/notifications_fake_check_results.png)
:::
::::

::: paragraph
Wenn so alle Bedingungen einer Ihrer Benachrichtigungsregeln erfüllt
sind, wird für diese Regel die eingestellte Benachrichtigungsmethode
ausgeführt. Beim nächsten regulären Check sollte der Service dann wieder
auf [OK]{.state0} gehen und eine erneute Benachrichtigung auslösen
(diesmal vom Typ Recovery).
:::

::: paragraph
Beachten Sie bei diesen Tests, dass der Service bei häufigen Wechseln
nach einiger Zeit in den Zustand [![icon
flapping](../images/icons/icon_flapping.png)]{.image-inline} unstetig
(*flapping*) gehen wird. Weitere Zustandswechsel lösen dann keine
Benachrichtigungen mehr aus. Im Snapin [Master
control](user_interface.html#master_control) der Seitenleiste können Sie
die Erkennung von Unstetigkeiten ([Flap Detection]{.guihint})
vorübergehend ausschalten.
:::

::: paragraph
Alternativ können Sie auch eine benutzerdefinierte Benachrichtigung
([Custom notification]{.guihint}) auslösen --- ebenfalls per Kommando:
:::

:::: imageblock
::: content
![Dialog für eine benutzerdefinierte
Benachrichtigung.](../images/notifications_custom.png)
:::
::::

::: paragraph
Dabei ändert sich der Status des entsprechenden Services nicht.
Allerdings ist die so erzeugte Benachrichtigung dann von einem anderen
Typ und kann sich --- abhängig von Ihren
Benachrichtigungsregeln --- anders verhalten.
:::
::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::: sect1
## []{#files .hidden-anchor .sr-only}12. Dateien und Verzeichnisse {#heading_files}

:::::: sectionbody
::: sect2
### []{#_pfade_von_checkmk .hidden-anchor .sr-only}12.1. Pfade von Checkmk {#heading__pfade_von_checkmk}

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `~/var/log/cmc.log`               | Log-Datei des [CMC](cmc.html).    |
|                                   | Falls das Debugging für           |
|                                   | Notifications eingeschaltet ist,  |
|                                   | finden Sie hier genaue Angaben,   |
|                                   | warum Benachrichtigungen (nicht)  |
|                                   | erzeugt wurden.                   |
+-----------------------------------+-----------------------------------+
| `~/var/log/notify.log`            | Log-Datei des                     |
|                                   | Benachrichtigungsmoduls           |
+-----------------------------------+-----------------------------------+
| `~/var/log/mknotifyd.log`         | Log-Datei des                     |
|                                   | Benachrichtigungs-Spoolers        |
+-----------------------------------+-----------------------------------+
| `~/var/log/mknotifyd.state`       | Aktueller Zustand des             |
|                                   | Benachrichtigungs-Spoolers. Das   |
|                                   | ist hauptsächlich bei             |
|                                   | [Benachrichtigungen in verteilten |
|                                   | Umgebungen](distribut             |
|                                   | ed_monitoring.html#notifications) |
|                                   | relevant.                         |
+-----------------------------------+-----------------------------------+
| `~/var/nagios/debug.log`          | Debug-Log-Datei von Nagios.       |
|                                   | Schalten Sie Debug-Meldungen in   |
|                                   | `etc/nagios/nagios.d/logging.cfg` |
|                                   | in der Variablen `debug_level`    |
|                                   | ein.                              |
+-----------------------------------+-----------------------------------+
| `~/var/check_mk/notify/spool/`    | Ablage der Spool-Dateien, die der |
|                                   | Benachrichtigungs-Spooler         |
|                                   | bearbeiten soll.                  |
+-----------------------------------+-----------------------------------+
| `~/var/check_mk/notify/deferred/` | Bei temporären Fehlern verschiebt |
|                                   | der Benachrichtigungs-Spooler die |
|                                   | Dateien hierher und probiert es   |
|                                   | erst nach ein paar Minuten        |
|                                   | nochmal.                          |
+-----------------------------------+-----------------------------------+
| `                                 | Defekte Spool-Dateien werden      |
| ~/var/check_mk/notify/corrupted/` | hierher verschoben.               |
+-----------------------------------+-----------------------------------+
| `~/share/check_mk/notifications`  | Von Checkmk mitgelieferte         |
|                                   | Benachrichtigungsskripte. Ändern  |
|                                   | Sie hier nichts.                  |
+-----------------------------------+-----------------------------------+
| `~/lo                             | Ablageort für eigene              |
| cal/share/check_mk/notifications` | Benachrichtigungsskripte. Möchten |
|                                   | Sie ein mitgeliefertes Skript     |
|                                   | anpassen, so kopieren Sie es von  |
|                                   | `~/share/check_mk/notifications`  |
|                                   | hierher und behalten dessen       |
|                                   | Dateinamen bei.                   |
+-----------------------------------+-----------------------------------+
| `~/share/doc/                     | Weitere Benachrichtigungsskripte, |
| check_mk/treasures/notifications` | die Sie geringfügig anpassen und  |
|                                   | verwenden können.                 |
+-----------------------------------+-----------------------------------+
:::

:::: sect2
### []{#maillog .hidden-anchor .sr-only}12.2. Log-Dateien des SMTP-Servers {#heading_maillog}

::: paragraph
Die Log-Dateien des SMTP-Servers sind Systemdateien und werden hier
folglich mit absoluten Pfaden angegeben. Wo die Log-Datei genau liegt,
hängt von Ihrer Linux-Distribution ab.
:::

+-----------------------------------+-----------------------------------+
| Pfad                              | Bedeutung                         |
+===================================+===================================+
| `/var/log/mail.log`               | Log-Datei des SMTP-Servers unter  |
|                                   | Debian und Ubuntu                 |
+-----------------------------------+-----------------------------------+
| `/var/log/mail`                   | Log-Datei des SMTP-Servers unter  |
|                                   | SUSE Linux Enterprise Server      |
|                                   | (SLES)                            |
+-----------------------------------+-----------------------------------+
| `/var/log/maillog`                | Log-Datei des SMTP-Servers unter  |
|                                   | Red Hat Enterprise Linux (RHEL)   |
+-----------------------------------+-----------------------------------+
::::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
