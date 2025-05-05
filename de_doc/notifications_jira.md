:::: {#header}
# Benachrichtigungen per Jira

::: details
[Last modified on 29-May-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/notifications_jira.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::::::::: sectionbody
::::: paragraph
:::: {.dropdown .dropdown__related}
Related Articles

::: {.dropdown-menu .dropdown-menu-right aria-labelledby="relatedMenuButton"}
[Benachrichtigungen](notifications.html)
:::
::::
:::::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Wenn Sie die
Software Jira zum Projektmanagement, zur Software-Entwicklung oder zur
Fehlerverfolgung verwenden, können Sie mit den kommerziellen Editionen
Benachrichtigungen aus Checkmk heraus an Jira senden und dort *Issues*
erzeugen. Dies funktioniert für die Produkte Jira Work Management
(ehemals Jira Core), Jira Software und Jira Service Management (ehemals
Jira Service Desk).
:::

::: paragraph
Unterstützt werden dabei folgende Optionen:
:::

::: ulist
- Issues für Host- und Service-Probleme erzeugen.

- Issues mit definierter Priorität (*priority*) erstellen.

- Issues mit einem definierten *Label* erstellen.

- Links auf Host/Services in Checkmk aus den erzeugten Jira-Issues
  setzen.

- Eine *Resolution* im Issue bei eintretenden [OK]{.state0}-Zuständen
  setzen.
:::

::: paragraph
Um die Anbindung von Checkmk an Jira einzurichten, legen Sie in Jira
zunächst einige neue Felder (*Fields*) an und ermitteln bestimmte
Jira-*IDs.*
:::

::: paragraph
Anschließend konfigurieren Sie die Benachrichtigungsmethode für Jira in
Checkmk, wobei Sie die erstellten und ausgelesenen Jira-IDs eintragen.
Mehr Flexibilität erhalten Sie, wenn Sie zusätzlich [benutzerdefinierte
Attribute](wato_user.html#custom_user_attributes) verwenden. Denn statt
die Jira-IDs direkt in die Benachrichtigungsmethode einzutragen, können
Sie einige Jira-IDs als benutzerdefinierte Attribute definieren. Damit
ist es dann einfach möglich, dass verschiedene Benutzer Issues in
verschiedenen JIRA-Projekten erstellen können.
:::
:::::::::::
:::::::::::::

:::::::::::::::::::::::::: sect1
## []{#config_jira .hidden-anchor .sr-only}1. Jira konfigurieren {#heading_config_jira}

::::::::::::::::::::::::: sectionbody
::: paragraph
Checkmk muss bei der Interaktion mit Jira wissen, welche
Benachrichtigungen bereits einen Issue erzeugt haben und welche nicht.
Damit das möglich wird, müssen Sie in Jira zwei sogenannte *Custom
fields,* also benutzerdefinierte Felder, erstellen --- eines für
Benachrichtigungen über Host-Probleme, und eines über Service-Probleme.
:::

::: paragraph
Um die Host- und Service-Probleme zuordnen zu können, müssen deren IDs
eindeutig sein. Dies ist der Fall, wenn Ihre Jira-Instanz von genau
*einer* Checkmk-Instanz Benachrichtigungen erhält, da der
Monitoring-Kern einer Checkmk-Instanz für die Eindeutigkeit sorgt. Nun
kann es aber sein, dass im verteilten Monitoring mehrere
Checkmk-Instanzen Benachrichtigungen senden, falls [dezentrale
Benachrichtigungen](distributed_monitoring.html#notifications)
konfiguriert sind. Erhält Ihre Jira-Instanz also von mehreren
Checkmk-Instanzen Benachrichtigungen, ist es höchstwahrscheinlich mit
der Eindeutigkeit vorbei --- spätestens dann, wenn die ID eines
Host-Problems bereits von einer anderen Checkmk-Instanz verwendet wurde.
In einer solchen Konfiguration benötigen Sie ein weiteres
benutzerdefiniertes Feld für die Checkmk-Instanz, mit dem die eindeutige
Zuordnung wieder möglich wird.
:::

::: paragraph
Für die Konfiguration in Checkmk benötigen Sie die Jira-IDs der
erstellten benutzerdefinierten Felder --- und zusätzlich die von einigen
anderen Feldern, im Ganzen also die folgende Liste:
:::

::: ulist
- Project ID

- Issue type ID

- Priority ID (optional)

- Host custom field ID

- Service custom field ID

- Site custom field ID (optional)

- (Workflow) Transition ID (optional)
:::

::: paragraph
Die allermeisten dieser IDs können mit dem unten angegebenem Skript über
eine der REST APIs von Jira ausgelesen werden. Jira-Administratoren
können die IDs - auch solche, die über die API und somit das Skript
nicht abrufbar sind - über die GUI von Jira ermitteln.
:::

:::::: sect2
### []{#jira_custom_fields .hidden-anchor .sr-only}1.1. Einrichten der benutzerdefinierten Felder in Jira {#heading_jira_custom_fields}

::: paragraph
Wie Sie benutzerdefinierte Felder (*custom fields*) in Jira erstellen,
können Sie in der
[Jira-Dokumentation](https://confluence.atlassian.com/adminjiraserver/adding-custom-fields-1047552713.html){target="_blank"}
nachlesen, inklusive der Zuweisung des Feldes zu den sogenannten *Issue
Screens* in Jira.
:::

::: paragraph
Bei der Erstellung der für Checkmk notwendigen Felder beachten Sie dabei
die folgenden Punkte zum Feldtyp (*field type*). Die Feldnamen können
Sie frei wählen. Die in der folgenden Tabelle enthaltenen Namen passen
aber zum Skript, mit dem Sie im nächsten Abschnitt [Jira-IDs über
externes Skript ermitteln](#jira_ids_script) die Jira-IDs auslesen
können.
:::

+----------------------+----------------------+-----------------------+
| Benutzerdefiniertes  | Feldtyp              | Name                  |
| Feld                 |                      |                       |
+======================+======================+=======================+
| Host custom field    | `Number field`       | `CMK_HOST_FIELD`      |
|                      |                      | (Beispiel)            |
+----------------------+----------------------+-----------------------+
| Service custom field | `Number field`       | `CMK_SVC_FIELD`       |
|                      |                      | (Beispiel)            |
+----------------------+----------------------+-----------------------+
| Site custom field    | `Text                | `CMK_SITE_FIELD`      |
| (optional)           | field (single line)` | (Beispiel)            |
+----------------------+----------------------+-----------------------+

::: paragraph
Achten Sie außerdem darauf, dass der Jira-Benutzer, der von Checkmk zum
Erstellen von Issues verwendet wird, d.h. in der
[Checkmk-Benachrichtigungsregel](#config_cmk) eingetragen ist, Lese-
*und Schreibzugriff* auf diese benutzerdefinierten Felder hat.
:::
::::::

:::::::::::: sect2
### []{#jira_ids_script .hidden-anchor .sr-only}1.2. Jira-IDs über externes Skript ermitteln {#heading_jira_ids_script}

::: paragraph
Sie können die IDs gesammelt mit folgendem Skript abfragen, das die
[Jira
REST-API](https://docs.atlassian.com/software/jira/docs/api/REST/latest){target="_blank"}
nutzt.
:::

::: paragraph
Ersetzen Sie dabei `JIRA_USERNAME`, `JIRA_PASSWORD`, `PROJECT_KEY` und
`https://jira.server.your-domain.de` mit den bei Ihnen gültigen Werten.
Den `PROJECT_KEY` können Sie auch ohne administrative Rechte aus der
Jira-GUI ermitteln.
:::

::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Falls Sie ein Jira Cloud-Produkt  |
|                                   | nutzen, erfolgt die               |
|                                   | Authentifizierung des Skripts     |
|                                   | nicht mit Passwort, sondern mit   |
|                                   | einem API-Token. Hintergründe und |
|                                   | die Anleitung zum Erstellen eines |
|                                   | API-Tokens stehen in der          |
|                                   | [Jira-                            |
|                                   | Dokumentation.](https://support.a |
|                                   | tlassian.com/atlassian-account/do |
|                                   | cs/manage-api-tokens-for-your-atl |
|                                   | assian-account/){target="_blank"} |
|                                   | In Jira können Sie das generierte |
|                                   | API-Token in die Zwischenablage   |
|                                   | kopieren und im folgenden Skript  |
|                                   | als `JIRA_PASSWORD` einfügen.     |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::::: listingblock
::: title
example_script.py
:::

::: content
``` {.pygments .highlight}
#!/usr/bin/env python3

import requests
import sys
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

user = "JIRA_USERNAME"
password = "JIRA_PASSWORD"
project_key = "PROJECT_KEY"
jira_instance = "https://jira.server.your-domain.de"
custom_field_1 = "CMK_HOST_FIELD"
custom_field_2 = "CMK_SVC_FIELD"
custom_field_3 = "CMK_SITE_FIELD" # don't edit if field is not used

def handle_response(user, password, jira_instance, what):
    url = "%s/rest/api/2/%s" % (jira_instance, what)
    sess = requests.Session()
    sess.auth = (user, password)
    response = sess.get(url, verify=False)

    return response

sys.stdout.write("=== IDs for project %s ===\n" % project_key)
infotext = ""
for section, id_name in [ ("Project_ID", "project"),
                          ("Issue", "issuetype"),
                          ("Priority", "priority"),
                          ("Field", "field"),
                        ]:

    json_response = handle_response(user,password,jira_instance,id_name).json()
    if id_name == "project":
        infotext = ""
        for project in json_response:
            if project["key"] == project_key:
                infotext += "%s\n\n" % project.get("id", "Project ID not found")
        if not infotext:
            infotext += "Project ID not found, project name existing?\n\n"
    else:
        types = ""
        for line in json_response:
            if id_name == "field":
                if line["name"].lower() == custom_field_1.lower() or \
                    line["name"].lower() == custom_field_2.lower() or \
                    line["name"].lower() == custom_field_3.lower():
                    types += "%s: %s\n" % (line["name"], line["id"].split("_")[1])
            else:
                types += "%s: %s\n" % (line["name"], line["id"])

        infotext += "=== %s types\n%s\n" % (section, types)

sys.stdout.write(infotext)
```
:::
:::::

::: paragraph
Die Ausgabe des Skripts sieht dann ungefähr so aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
=== IDs for project MY_PROJECT ===
10401

=== Issue types
Test case: 10600
Epic: 10000
Task: 10003
Sub-task: 10004
Bug: 10006
Story: 10001
Feedback: 10200
New Feature: 10005
Support: 10500
Improvement: 10002

=== Priority types
Blocker: 1
High: 2
Medium: 3
Low: 4
Lowest: 5
Informational: 10000
Critical impact: 10101
Significant impact: 10102
Limited impact: 10103
Minimal impact: 10104

=== Field types
CMK_HOST_FIELD: 11400
CMK_SVC_FIELD: 11401
CMK_SITE_FIELD: 11403
```
:::
::::
::::::::::::

::::: sect2
### []{#jira_ids_gui .hidden-anchor .sr-only}1.3. Jira-IDs über die GUI ermitteln {#heading_jira_ids_gui}

::: paragraph
Als Alternative zur Skriptausführung können Sie die IDs auch über die
Jira-GUI auslesen, wofür Sie sich aber mit einem administrativen Konto
in Jira anmelden müssen. Atlassian, der Hersteller von Jira, hat das
Vorgehen am Beispiel der Project ID in einer eigenen
[Anleitung](https://confluence.atlassian.com/jirakb/how-to-get-project-id-from-the-jira-user-interface-827341414.html){target="_blank"}
beschrieben.
:::

::: paragraph
Die IDs der weiteren Felder und Issues types lassen sich ablesen, in dem
Sie das jeweilige Element in der Administrator-GUI von Jira editieren.
Die ID steht dann im Regelfall als letzter Wert in der Adressleiste
Ihres Browsers.
:::
:::::
:::::::::::::::::::::::::
::::::::::::::::::::::::::

::::::::::::: sect1
## []{#config_cmk .hidden-anchor .sr-only}2. Checkmk konfigurieren {#heading_config_cmk}

:::::::::::: sectionbody
::: paragraph
Wie Sie Benachrichtigungen im Allgemeinen in Checkmk einrichten, haben
Sie bereits im Artikel über [Benachrichtigungen](notifications.html)
erfahren.
:::

::: paragraph
Um nun die Jira-Benachrichtigungen zu nutzen, gehen Sie in Checkmk wie
folgt vor:
:::

::: {.olist .arabic}
1.  Wenn Sie [benutzerdefinierte
    Attribute](wato_user.html#custom_user_attributes) verwenden möchten,
    können Sie diese für die folgenden Jira-IDs erstellen: Project ID
    (`jiraproject`), Issue type ID (`jiraissuetype`), Priority ID
    (`jirapriority`) und Transition ID (`jiraresolution`). In den
    Klammern sind die Namen angegeben, die Sie als [Name]{.guihint}
    eines Attributs eingeben. Ein benutzerdefinierter Attribut legen Sie
    mit [Setup \> Users \> Custom user attributes \> Add
    attribute]{.guihint} an:\

    :::: imageblock
    ::: content
    ![Ein benutzerdefinierter Attribut für die Jira Project
    ID.](../images/jira_notification_custom_user_attribute.png)
    :::
    ::::

    ::: paragraph
    Achten Sie darauf, dass bei allen diesen für Jira erstellten
    benutzerdefinierten Attributen die Checkbox [Make this variable
    available in notifications]{.guihint} gesetzt ist.\
    In den Eigenschaften eines Benutzers können Sie dann in diese
    Attribute die Jira-IDs eintragen, für die dieser Benutzer zuständig
    ist.\
    Für jedes benutzerdefinierte Attribut lassen Sie in der
    Benachrichtigungsregel, die in den folgenden Schritten erstellt
    wird, das Feld der zugehörigen Jira-ID *leer.* Diese Felder werden
    dann mit den benutzerdefinierten Attributen gefüllt.
    :::

2.  Erstellen Sie eine neue Benachrichtigungsregel mit [Setup \> Events
    \> Notifications \> Add rule.]{.guihint}

3.  Wählen Sie als [Notification Method]{.guihint} den Eintrag [JIRA
    (Commercial editions only):]{.guihint}

    :::: imageblock
    ::: content
    ![Die Einstellungen zur Benachrichtigungsmethode für
    Jira.](../images/jira_notification_rule.png)
    :::
    ::::

4.  Im Feld [JIRA URL]{.guihint} tragen Sie die URL Ihrer Jira-Instanz
    ein, also z.B. `jira.server.your-domain.com`.

5.  Bei [User Name]{.guihint} und [Password]{.guihint} hinterlegen Sie
    die Zugangsdaten des Jira-Kontos für den Zugriff.

6.  Für [Project ID]{.guihint} und [Issue type ID]{.guihint} benötigen
    Sie die vorher ermittelten IDs in Jira, im Beispiel `10401` für die
    Project ID und `10006` für den Issue-Typ `Bug`.

7.  Bei [Host custom field ID]{.guihint}, [Service custom field
    ID]{.guihint} und (optional) [Site custom field ID]{.guihint} tragen
    Sie IDs der von Ihnen in Jira angelegten, benutzerdefinierten Felder
    ein.

8.  Um in den erzeugten Issues direkt nach Checkmk verlinken zu können,
    tragen Sie unter [Monitoring URL]{.guihint} die URL Ihrer
    Checkmk-Instanz ein, also z.B.: `https://mycmkserver/mysite`
:::

::: paragraph
Weiterhin haben Sie noch die folgenden optionalen
Einstellungsmöglichkeiten:
:::

::: ulist
- Mit der [Priority ID]{.guihint} können Sie definieren, mit welcher
  Priorität die Issues in Jira angelegt werden. Hier können Sie eine der
  im Skript ausgelesenen `Priority types` eintragen, von `1` bis `5`.

- Die Beschreibungen, die in den Issues für Host- und Service-Probleme
  erzeugt werden, können Sie über die Optionen [Summary for host
  notifications]{.guihint} und [Summary for service
  notifications]{.guihint} ändern.

- Über den Punkt [Label]{.guihint} können Sie definieren, ob Sie bei der
  Issue-Erzeugung in Jira Label mit übergeben möchten. Wenn Sie Label
  aktivieren, ohne einen Wert einzutragen, wird `monitoring` gesetzt.\
  Checkmk schreibt den Wert des Labels in das Jira-Feld `labels`, was
  nur gelingt, wenn dieses Feld in Ihrer Jira-Applikation existiert, was
  z.B. bei *Jira Software* der Fall ist, nicht aber bei *Jira Service
  Desk*.

- Wenn Sie bei Benachrichtigungen über eine Zustandsänderung auf
  [OK]{.state0} in Checkmk auch eine [Resolution]{.guihint} in den Issue
  in Jira eintragen lassen wollen, können Sie diese unter [Activate
  resolution with following resolution transition ID]{.guihint}
  definieren.\
  Um hier die richtige ID ermitteln zu können, benötigen Sie ebenfalls
  Administrator-Rechte in Jira. Navigieren Sie wieder in den Bereich
  [Issues]{.guihint} und klicken Sie hier auf [Workflows]{.guihint}.
  Klicken Sie anschließend in der Zeile des Standard-Workflows des
  verwendeten Jira-Projekts auf [View]{.guihint}. Sollten Sie nun einen
  Flowchart sehen, stellen Sie die Anzeige durch einen Klick auf
  [Text]{.guihint} um. Nun können Sie die gewünschte ID in der Spalte
  [Transitions (id)]{.guihint} ablesen.

- Mit [Set optional timeout for connections to JIRA]{.guihint} können
  Sie den Timeout für Verbindungen zu Jira konfigurieren. Wenn Sie hier
  nichts eintragen, gilt der Standardwert von 10 Sekunden.
:::

::: paragraph
Bei der Kontaktauswahl im folgenden Kasten [Contact selection]{.guihint}
beachten Sie die folgenden Punkte:
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

3.  Etwas anders stellt sich das Thema Kontaktauswahl bei der Nutzung
    benutzerdefinierter Attribute dar, denn damit sollen ja gerade
    verschiedenen Benutzern verschiedene Jira-IDs zugewiesen werden.
    Daher werden Sie in diesem Fall in der Regel *mehrere* Kontakte
    informieren wollen, und zwar diejenigen Benutzer, denen Sie die
    benutzerdefinierten Attribute zugewiesen haben. Wenn diese Benutzern
    verschiedene Jira-IDs verwenden, werden auch keine identischen
    Benachrichtigungen generiert.
:::

::: paragraph
Mit der neuen Funktion [Test
notifications](notifications.html#notification_testing) können Sie
überprüfen, ob Ihre neue Benachrichtigungsregel für bestimmte Hosts und
Services zutrifft.
:::

::: paragraph
Um Test-Benachrichtigungen über diese Benachrichtigungsmethode auch
tatsächlich zu versenden, müssen Sie in Checkmk [2.3.0]{.new} weiterhin
[Fake check results](notifications.html#fake_check_results) verwenden.
:::
::::::::::::
:::::::::::::

:::::::: sect1
## []{#diagnosis .hidden-anchor .sr-only}3. Diagnosemöglichkeiten {#heading_diagnosis}

::::::: sectionbody
::: paragraph
Sollten nach der Einrichtung der Benachrichtigungsregel in Checkmk keine
Tickets in Jira ankommen, prüfen Sie die zugehörige Log-Datei
`~/var/log/notify.log`. Von Jira kommen hier im Regelfall recht
brauchbare Fehlermeldungen zurück, die Ihnen bei der Diagnose
tatsächlich helfen können. Im folgenden listen wir einige Beispiele auf.
:::

### Fehlermeldung: Unable to create issue, JIRA response code 400, Field \'labels\' cannot be set. {#_fehlermeldung_unable_to_create_issue_jira_response_code_400_field_labels_cannot_be_set .discrete}

::: paragraph
Eventuell verfügt Ihr verwendetes Jira-Produkt nicht über Labels.
Schalten Sie in Checkmk die Verwendung von Labels in Ihrer
Benachrichtigungsregel einfach ab, indem Sie den Haken vor
[Label]{.guihint} wieder entfernen.
:::

### Fehlermeldung: Unable to create issue, JIRA response code 400, b'project is required\'. {#_fehlermeldung_unable_to_create_issue_jira_response_code_400_bproject_is_required .discrete}

::: paragraph
Diese Fehlermeldung weist darauf hin, dass die ID nicht korrekt ist,
welche Sie in der Benachrichtigungsregel für das betreffende Feld (hier:
Project ID) eingetragen haben.
:::

### Fehlermeldung: Unable to resolve https://jira.server.your-domain.de/browse/ISSUE-123, JIRA response code 500, b'Internal server error\' {#_fehlermeldung_unable_to_resolve_httpsjira_server_your_domain_debrowseissue_123_jira_response_code_500_binternal_server_error .discrete}

::: paragraph
Erhalten Sie diese Fehlermeldung, wenn ein Ticket in Jira von Checkmk
automatisch geschlossen bzw. in einen anderen Status versetzt werden
soll, dann **kann** dies ein Hinweis darauf sein, das die von Ihnen
eingetragene Transition ID nicht korrekt ist. Die Transition ID steht in
der Benachrichtigungsregel im Feld [Activate resolution with following
resolution transition ID]{.guihint}. Gleichen Sie diese ID in der Regel
erneut mit der Weboberfläche von Jira ab.
:::
:::::::
::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::
