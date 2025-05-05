:::: {#header}
# Die Checkmk REST-API

::: details
[Last modified on 09-Jul-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/rest_api.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::::::: sectionbody
::: paragraph
Mit der Checkmk REST-API als Anwendungsprogrammierschnittstelle können
Sie die Aufgaben, die Sie sonst in Checkmk über die GUI erledigen, per
Kommando oder Skript mit HTTP-Anfragen an den Checkmk-Server übermitteln
und ausführen lassen.
:::

::: paragraph
Das *REST* im Namen der REST-API steht für *REpresentational State
Transfer* und beschreibt eine Architektur für den Austausch von Daten
auf verteilten Systemen --- insbesondere für Web-Dienste. Eine API, die
gemäß der REST-Architektur implementiert ist, folgt bestimmten
Prinzipien, z.B. dem Client-Server-Modell, der zustandslosen
Kommunikation und einer einheitlichen Schnittstelle. In der Praxis
erfolgt die Umsetzung bevorzugt über das HTTP-Protokoll, wobei die
Ressourcen per Uniform Resource Identifier (URI) angesprochen werden und
auf diese mit HTTP-Methoden (GET, POST, PUT, DELETE) zugegriffen wird.
:::

::: paragraph
Soviel zu den REST-Prinzipien. Ihre Vorteile zeigen sich in den
konkreten Features, die Ihnen die Checkmk REST-API bietet:
:::

+-----------------+-----------------------------------------------------+
| Protokoll       | Das Hypertext Transfer Protocol (**HTTP/1.1**) wird |
|                 | als Transportsystem für die Kommunikation genutzt.  |
+-----------------+-----------------------------------------------------+
| Kodierung       | Als Datenformat wird die JavaScript Object Notation |
|                 | (**JSON**) verwendet. Die Nutzdaten (*payload*) der |
|                 | Antworten werden mit JSON serialisiert und in UTF-8 |
|                 | kodiert. Datums- und Zeitangaben sind im            |
|                 | **ISO-8601**-Format mit gültigen                    |
|                 | Zeitzoneninformationen kodiert.                     |
+-----------------+-----------------------------------------------------+
| Sprache         | Englisch ist die Sprache für Labels, Identifiers    |
|                 | und die API-Dokumentation.                          |
+-----------------+-----------------------------------------------------+
| Au              | Der Zugriff auf die API wird einem Client nur dann  |
| thentifizierung | gestattet, wenn er die Berechtigung mittels         |
|                 | **HTTP-Authentifizierung** (z.B. „Bearer")          |
|                 | nachgewiesen hat.                                   |
+-----------------+-----------------------------------------------------+
| Versionierung   | Die API ist versioniert und nutzt dabei eine        |
|                 | Nummerierung nach dem Standard **Semantic           |
|                 | Versioning 2.x.** Details finden Sie im [Abschnitt  |
|                 | zur Versionierung](#versioning) weiter unten.       |
+-----------------+-----------------------------------------------------+
| Dokumentation   | Die API wird in einem maschinenlesbaren Schema und  |
|                 | einem menschenlesbaren Format in englischer Sprache |
|                 | dokumentiert, mit allen Ressourcen, ihren Eingabe-  |
|                 | und Ausgabeparametern und den zugehörigen           |
|                 | Wertebereichen. Die API ist mit der **OpenAPI       |
|                 | Specification (OAS) 3.x** erstellt, einem           |
|                 | API-Beschreibungsformat speziell für REST-APIs. Das |
|                 | mit dieser Spezifikation erstellte API-Dokument     |
|                 | wird für den Benutzer mit ReDoc angezeigt, einem    |
|                 | responsiven Web-Design für OpenAPI-Dokumente.       |
+-----------------+-----------------------------------------------------+
| Beispiel-Code   | Um die Verwendung zu demonstrieren, gibt es zu      |
|                 | jeder Anfrage Beispiel-Code für verschiedene        |
|                 | Anwendungen (z.B. für Curl und Httpie).             |
+-----------------+-----------------------------------------------------+
| Fehleranzeige   | Die API sendet im Fehlerfall numerische             |
|                 | **HTTP-Status-Codes** und eine Diagnosemeldung des  |
|                 | Problems, die bei der Suche nach möglichen Ursachen |
|                 | für fehlerhafte Anfragen hilft.                     |
+-----------------+-----------------------------------------------------+
| REST-API        | Die API erfüllt alle vier Ebenen (0 bis 3) des      |
| Klassifizierung | **Richardson Maturity Model (RMM)**, mit dem        |
|                 | beurteilt werden kann, wie viel REST in einer API   |
|                 | steckt. In Ebene 1 wird die Einführung von          |
|                 | Ressourcen gefordert, damit über die API statt zu   |
|                 | einem globalen Endpunkt zu individuellen Endpunkten |
|                 | kommuniziert werden kann. Ebene 2 wird erfüllt,     |
|                 | wenn für die Anfragen HTTP-Methoden verwendet       |
|                 | werden. Auf der (höchsten) Ebene 3 dokumentiert     |
|                 | sich die API quasi selbst, indem der Server mit der |
|                 | Antwort auf eine Anfrage die nächsten möglichen     |
|                 | Aktionen und die dabei anzusprechenden Ressourcen   |
|                 | mitteilt, und es dem Client so ermöglicht, die      |
|                 | verfügbare Funktionalität selbst zu entdecken.      |
|                 | Diese Bereitstellung von Zusatzinformationen wird   |
|                 | auch „Hypermedia as the Engine of Application       |
|                 | State" (**HATEOAS**) genannt.                       |
+-----------------+-----------------------------------------------------+

::: paragraph
Neben diesen generellen Komfortfunktionen soll die REST-API die
komplette Funktionalität abdecken, die Checkmk über die GUI und über
Kommandoschnittstelle bietet.
:::

::: paragraph
[![CEE](../images/CEE.svg){.icon-left}]{.image-inline} Für Funktionen,
die es nur in den kommerziellen Editionen gibt, wie z.B. Service Level
Agreement (SLA) oder Agentenbäckerei, werden die zugehörigen Methoden
der REST-API auch nur in diesen Editionen angeboten.
:::
::::::::
:::::::::

:::::::::::::::::::::::: sect1
## []{#api_doc .hidden-anchor .sr-only}2. Die API-Dokumentation {#heading_api_doc}

::::::::::::::::::::::: sectionbody
::::::: sect2
### []{#versioning .hidden-anchor .sr-only}2.1. Versionierung {#heading_versioning}

::: paragraph
Einer der Vorteile der REST-API ist, dass Software und Dokumentation aus
der gleichen Quelle stammen: dem OpenAPI-Dokument. Daher passt die
API-Dokumentation stets zur Software und beschreibt genau das, was die
API kann. Daher ist es auch nicht nötig, den Referenzteil der
verfügbaren Ressourcen, Methoden, Parameter etc. im Checkmk-Handbuch zu
beschreiben: stattdessen finden Sie die API-Dokumentation außerhalb
dieses Handbuchs, direkt in Ihrer Checkmk-Instanz.
:::

::: paragraph
Die API mit ihrer Dokumentation ist versioniert und nutzt dabei eine
zweistufige Nummerierung im Format `X.Y`, wobei `X` für eine
Major-Version steht und `Y` für eine Minor-Version. Eine neue
Minor-Version enthält nur rückwärtskompatible Änderungen, die keinen
Einfluss auf bestehende Funktionen haben. Eine neue Major-Version
dagegen enthält Änderungen, die die API inkompatibel mit der vorherigen
Major-Version machen (sogenannte **breaking changes**). Die
Versionsnummern der Major- und Minor-Versionen sind Bestandteil der URL,
mit der eine Anfrage an den Server gesendet wird. Die Checkmk REST-API
nutzt zurzeit nicht die dritte Stufe (`.Z`) des
Semantic-Versioning-Standards für eine Patch-Version.
:::

::: paragraph
Beachten Sie, dass die REST-API einer anderen Versionierung folgt als
die Checkmk-Software. Da eine neue Major-Version der API dann notwendig
ist, wenn es inkompatible API-Änderungen gibt, passt das in der Regel
nicht zum Release-Zyklus der Checkmk-Software.
:::

::: paragraph
Trotzdem ist die Zuordnung der Versionen von API-Dokumentation und
Checkmk-Software sehr einfach, wie Sie im nächsten Kapitel erfahren.
:::
:::::::

:::::::: sect2
### []{#access .hidden-anchor .sr-only}2.2. Zugriff {#heading_access}

::: paragraph
Die REST-API-Dokumentation steht im HTML-Format zur Ansicht im
Web-Browser bereit.
:::

::: paragraph
In der Checkmk-GUI öffnen Sie die API-Dokumentation über die
Navigationsleiste mit [Help \> Developer resources \> REST API
documentation.]{.guihint} Die API-Dokumentation wird in einem neuen
Browser-Fenster (bzw. Browser-Tab) angezeigt. Wir gehen darauf im
nächsten Kapitel genauer ein.
:::

:::: imageblock
::: content
![Help-Menü in der
Navigationsleiste.](../images/restapi_help_menu.png){width="60%"}
:::
::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Sicher ist Ihnen aufgefallen,     |
|                                   | dass es im [Help]{.guihint}-Menü  |
|                                   | noch weitere Einträge zur         |
|                                   | REST-API gibt. Mit [REST API      |
|                                   | introduction]{.guihint} können    |
|                                   | Sie diesen Artikel öffnen. Mit    |
|                                   | [REST API interactive             |
|                                   | GUI]{.guihint} öffnen Sie eine    |
|                                   | weitere Sicht auf die REST-API.   |
|                                   | [GUI]{.guihint} heißt dieser      |
|                                   | Eintrag, weil Ihnen nicht nur die |
|                                   | REST-API-Funktionen angezeigt     |
|                                   | werden, sondern weil Sie aus dem  |
|                                   | Browser heraus direkt mit der API |
|                                   | interagieren können, indem Sie    |
|                                   | z.B. Anfragen an den Server       |
|                                   | senden. Wir stellen die REST-API  |
|                                   | GUI als Alternative zur           |
|                                   | Ausführung per Skript im [Kapitel |
|                                   | zur REST-API GUI](#rest_api_gui)  |
|                                   | später vor.                       |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
::::::::

::::::::::: sect2
### []{#structure .hidden-anchor .sr-only}2.3. Struktur und Inhalt {#heading_structure}

::: paragraph
Die API-Dokumentation nutzt ein responsives Web-Design mit 3 Bereichen:
:::

:::: {.imageblock .border}
::: content
![API-Dokumentation im responsiven Web-Design mit drei
Bereichen.](../images/restapi_redoc.png)
:::
::::

::: ulist
- Der linke Navigationsbereich dient der Orientierung, der Suche und dem
  schnellen Sprung zur genauen Beschreibung der Einträge im mittleren
  Bereich. Das Inhaltsverzeichnis enthält für jeden API-Endpunkt einen
  Eintrag. Ein Endpunkt bezeichnet per URL die Ressource, die die API
  zur Verfügung stellt (z.B. Hosts), zusammen mit der Methode, um auf
  die Ressource zuzugreifen (z.B. GET zur Anzeige eines Hosts). Die
  Endpunkte sind in mehrere Ordner organisiert.

- Der mittlere Inhaltsbereich enthält die harten Fakten der
  Dokumentation: alle Informationen zur Definition einer Anfrage (mit
  Parametern, Wertebereichen, Default-Werten und Beschreibungen) und die
  zugehörigen Antworten (ebenfalls mit allen Details). Die möglichen
  Antworten werden in unterschiedlichen Farben dargestellt, je nachdem
  ob der zurückgelieferte [HTTP-Status-Code](#http-status-code) Erfolg
  oder einen Fehler signalisiert.

- Der rechte Beispielbereich ([Request samples]{.guihint}) zeigt für den
  im Inhaltsbereich ausgewählten Endpunkt die Methode und die URL,
  gefolgt von mehreren Beispielen zu Anfragen: die Payload im
  JSON-Format (falls relevant für den Endpunkt) und Code-Beispiele z.B.
  für Curl, Httpie, Python Requests und Python Urllib. Dann folgen die
  Antworten passend zum HTTP-Status. Alle Code-Beispiele können über den
  Knopf [Copy]{.guihint} in die Zwischenablage kopiert werden.
:::

::: paragraph
Der Navigationsbereich ist scroll-synchronisiert zu den anderen beiden
Bereichen, das heißt, wenn Sie im Inhaltsbereich nach oben oder unten
scrollen, scrollt der Navigationsbereich automatisch zum passenden
Eintrag des Inhaltsverzeichnisses mit.
:::

::: paragraph
Das responsive Web-Design sorgt dafür, dass in einem Browser-Fenster mit
geringer Breite der Beispielbereich verschwindet (dafür werden dann die
Beispiele unterhalb der zugehörigen Methode angezeigt) und der
Navigationsbereich in ein Menü umgewandelt wird.
:::

::: paragraph
In allen Bereichen finden Sie Inhalte, die Sie ein- und ausblenden
können, zum Beispiel im Navigationsbereich die Einträge für die
Endpunkte und im Inhaltsbereich verschachtelte Parameter. Durch
Anklicken von [\>]{.guihint} oder [Expand all]{.guihint} blenden Sie die
verborgenen Inhalte ein und mit [∨]{.guihint} oder [Collapse
all]{.guihint} wieder aus.
:::

::: paragraph
Wie Sie die API-Dokumentation nutzen können, um aus den Informationen
konkrete Anfragen zu erstellen, an den Checkmk-Server zu senden,
ausführen zu lassen und den Erfolg zu kontrollieren: all das erfahren
Sie im nächsten Kapitel.
:::
:::::::::::
:::::::::::::::::::::::
::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#using_the_api .hidden-anchor .sr-only}3. Die API nutzen {#heading_using_the_api}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#auth .hidden-anchor .sr-only}3.1. Authentifizierung {#heading_auth}

::: paragraph
Um von einem Client aus die REST-API des Checkmk-Servers nutzen zu
können, muss der Client seine Identität nachweisen. Die REST-API
unterstützt die folgenden Methoden zur Authentifizierung: **Bearer**,
**Webserver** und **Cookie** --- in dieser Rangfolge. Das heißt zum
Beispiel, dass bei einer erfolgreichen Authentifizierung mit Bearer
keine der anderen Methoden mehr geprüft wird.
:::

:::::: sect3
#### []{#bearerauth .hidden-anchor .sr-only}Bearer- oder Header-Authentifizierung {#heading_bearerauth}

::: paragraph
„Bearer" bezeichnet den Träger oder Inhaber einer Identität. Der Client
authentisiert sich mit den Zugangsdaten eines auf dem Checkmk-Server
eingerichteten Benutzers. Idealerweise ist dies der sogenannte
[Automationsbenutzer](glossar.html#automation_user), der in Checkmk für
die Ausführung von Aktionen über eine API vorgesehen ist. Die
Bearer-Authentifizierung wird für die Verwendung in Skripten empfohlen.
:::

::: paragraph
Für die Authentifizierung benötigen Sie den Benutzernamen und das
zugehörige, sogenannte *automation secret for machine accounts*, das
heißt das Passwort des Automationsbenutzers. Beide Informationen müssen
im Header jeder Anfrage an den Checkmk-Server übermittelt werden. Bei
einer neu erstellten [Instanz](glossar.html#site) ist der Benutzer
`automation` bereits angelegt. Sie finden ihn, wie andere Benutzer auch,
unter [Setup \> Users \> Users.]{.guihint} Achten Sie darauf, dass die
Rollen und die damit verbundenen Berechtigungen für den
Automationsbenutzer so gesetzt sind, dass sie die Ausführung Ihrer
Anfragen erlauben.
:::

::: paragraph
Für die in diesem Artikel vorgestellten Skripten wird immer der
standardmäßig eingerichtete Automationsbenutzer als Beispiel genommen.
:::
::::::

::::: sect3
#### []{#webserverauth .hidden-anchor .sr-only}Webserver-Authentifizierung {#heading_webserverauth}

::: paragraph
Bei der Webserver-Authentifizierung nutzt die REST-API die
HTTP-Authentifizierung, die für den Webserver konfiguriert ist („Basic"
oder „Digest").
:::

::: paragraph
Diese Authentifizierungsmethode ist gedacht für große
Checkmk-Installationen mit speziellen Anforderungen, die durch den
Einsatz und die Konfiguration von Software-Modulen für die
Authentifizierung des Apache Webservers realisiert werden. Wenn Sie die
Webserver-Authentifizierung nutzen möchten, müssen Sie den Apache
Webserver der Checkmk-Instanz selbst neu konfigurieren.
:::
:::::

:::: sect3
#### []{#cookieauth .hidden-anchor .sr-only}Cookie-Authentifizierung {#heading_cookieauth}

::: paragraph
Die Cookie-Authentifizierung ist ein Spezialfall der Authentifizierung
per API-Schlüssel. Jeder Checkmk-Benutzer, der in Checkmk angemeldet ist
und dadurch ein HTTP Cookie zugewiesen bekommen hat, kann die REST-API
nutzen. Die Cookie-Authentifizierung dient zum Ausprobieren und Testen
mit der [REST-API GUI](#rest_api_gui). Ob Anfragen ausgeführt werden
können, hängt davon ab, ob Ihr Checkmk-Benutzerkonto die entsprechenden
Berechtigungen besitzt.
:::
::::
:::::::::::::

::::: sect2
### []{#http-status-code .hidden-anchor .sr-only}3.2. HTTP-Status-Code {#heading_http-status-code}

::: paragraph
Die REST-API gibt zu jeder Anfrage den
[HTTP-Status-Code](https://de.wikipedia.org/wiki/HTTP-Statuscode){target="_blank"}
zurück, mit dem Sie überprüfen können, ob die Anfrage erfolgreich war.
Alle für die Anfrage möglichen HTTP-Status-Codes werden in der
API-Dokumentation gelistet.
:::

::: paragraph
Beachten Sie, dass der HTTP-Status-Code nur Auskunft über die
erfolgreiche Übermittlung der Anfrage gibt, aber nicht über die
erfolgreiche Ausführung. Ausgeführt werden die Befehle auf dem
Checkmk-Server mit [Livestatus.](glossar.html#livestatus) Um sicher zu
sein, dass die Anfrage über die REST-API auch wirklich das bewirkt, was
Sie beabsichtigt haben, müssen Sie die Erfolgskontrolle selbst
übernehmen. Die API-Dokumentation, die Sie mit [Help \> Developer
resources \> REST API interactive GUI]{.guihint} öffnen können, enthält
im Abschnitt „Queries through the REST API" ein Beispiel eines Skripts
für diese Aufgabe.
:::
:::::

:::::::::::: sect2
### []{#testing .hidden-anchor .sr-only}3.3. Die API lokal testen {#heading_testing}

::: paragraph
Um die REST-API zu testen, bietet es sich an, die Anfragen direkt vom
Checkmk-Server aus zu stellen, das heißt, in diesem Fall befinden sich
der Client, der die Anfrage sendet, und der Server, der diese empfängt,
auf dem gleichen Rechner. Wenn Sie als Instanzbenutzer arbeiten, können
Sie zudem lokale Variablen wie z.B. `$OMD_SITE` verwenden, die auf den
Namen der Instanz verweist.
:::

::: paragraph
In den folgenden einfachen Beispielen nutzen wir den in der
API-Dokumentation enthaltenen Beispiel-Code für das
Kommandozeilenprogramm Curl, das es ermöglicht, ohne Benutzerinteraktion
Daten von oder zu einem Server zum Beispiel per HTTP zu übertragen.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Insbesondere bei komplexen        |
|                                   | Anfragen kann es vorkommen, dass  |
|                                   | die Curl-Beispiele Inkonsistenzen |
|                                   | enthalten und daher nicht immer   |
|                                   | verlässlich sind. Mit             |
|                                   | [Httpie](htt                      |
|                                   | ps://httpie.io/){target="_blank"} |
|                                   | steht eine Alternative zur        |
|                                   | Verfügung, die konsistent, leicht |
|                                   | zu verstehen und gut für die      |
|                                   | Verwendung in Skripten geeignet   |
|                                   | ist.                              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Das `curl`-Kommando wird innerhalb eines Bash-Skripts ausgeführt. Zur
Vorbereitung erstellen Sie für jede der im nächsten Abschnitt
auszuführenden Anfragen jeweils eine Skript-Datei, in die später der
Beispiel-Code kopiert wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ touch create_host.sh service_discovery.sh show_pending_changes.sh activate_changes.sh
OMD[mysite]:~$ chmod +x create_host.sh service_discovery.sh show_pending_changes.sh activate_changes.sh
```
:::
::::

::: paragraph
Die REST-API gibt alle Antworten im JSON-Format einzeilig aus. Da eine
formatierte Ausgabe die Lesbarkeit doch erheblich erleichtert, wird in
den folgenden Beispielen die einzeilige Ausgabe mehrzeilig formatiert
dargestellt. Zur Aufbereitung des JSON-Formats gibt es diverse Websites
und Werkzeuge, zum Beispiel den Kommandozeilen-JSON-Prozessor `jq`.
:::

::: paragraph
Bevor es los geht, sammeln Sie einige grundlegenden Informationen, die
spezifisch für Ihre Checkmk-Konfiguration sind:
:::

+-----------------+-----------------+-----------------------------------+
| Variable        | Beispielwert    | Bedeutung                         |
+=================+=================+===================================+
| `HOST_NAME`     | `myserver`      | Name des Checkmk-Servers          |
+-----------------+-----------------+-----------------------------------+
| `SITE_NAME`     | `mysite`        | Name der Checkmk-Instanz          |
+-----------------+-----------------+-----------------------------------+
| `USERNAME`      | `automation`    | Name des Automationsbenutzers     |
+-----------------+-----------------+-----------------------------------+
| `PASSWORD`      | `theau          | Passwort des Automationsbenutzers |
|                 | tomationsecret` |                                   |
+-----------------+-----------------+-----------------------------------+

::: paragraph
Diese Variablen werden im Beispiel-Code verwendet und müssen von Ihnen
geändert werden, bevor Sie eine Anfrage absenden. In der obigen Tabelle
finden Sie auch die Beispielwerte, die im Folgenden verwendet werden.
:::
::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#making_requests .hidden-anchor .sr-only}3.4. Anfragen stellen per Skript {#heading_making_requests}

::: paragraph
Wir werden nun den Umgang mit der REST-API an einem übersichtlichen
Beispiel demonstrieren: Sie erstellen einen Host mit seinen Services mit
insgesamt vier Anfragen. Prinzipiell gehen Sie dabei genauso vor, wie
Sie es auch mit der Checkmk-GUI tun würden:
:::

::: {.olist .arabic}
1.  Einen Host erstellen

2.  Eine Service-Erkennung auf dem Host durchführen

3.  Die ausstehenden Änderungen anzeigen

4.  Die Änderungen aktivieren
:::

:::::::::::::::::::::::: sect3
#### []{#create_host .hidden-anchor .sr-only}Einen Host erstellen {#heading_create_host}

::: paragraph
Öffnen Sie die API-Dokumentation und suchen Sie im linken
Navigationsbereich den Eintrag zum Erstellen eines Hosts ([Create a
host]{.guihint}):
:::

:::: {.imageblock .border}
::: content
![Der Eintrag in der API-Dokumentation zum Erstellen eines
Hosts.](../images/restapi_redoc_2pane.png)
:::
::::

::: paragraph
Im mittleren Bereich sehen Sie die Details zur gewählten Anfrage: welche
HTTP-Authentifizierung gefordert ist (diese ist identisch für alle
Anfragen über die REST-API) und die notwendigen und optionalen
Parameter. Notwendig (*required*) sind der Name des Hosts und der
Ordner, in dem er angelegt werden soll. Standardmäßig wird der Host im
Hauptordner ([Main]{.guihint}) erstellt. Falls Sie den Host in einem
anderen Ordner anlegen wollen, müssen Sie sich eventuell zuerst über
eine andere API-Anfrage ([Show all folders]{.guihint}) die existierenden
Ordner anzeigen lassen, um die ID des gewünschten herauszufinden.
:::

::: paragraph
In unserem Beispiel soll der Host `myhost123` mit der IP-Adresse
`192.168.0.42` im Hauptordner erstellt werden.
:::

::: paragraph
In der API-Dokumentation klicken Sie im rechten Beispielbereich auf den
Knopf [curl]{.guihint} und dann auf [Copy]{.guihint} um den
Curl-Beispiel-Code in die Zwischenablage zu kopieren. Öffnen Sie das
vorbereitete Skript `create_host.sh` und fügen Sie den Inhalt der
Zwischenablage ein:
:::

::::: listingblock
::: title
create_host.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

# NOTE: We recommend all shell users to use the "httpie" examples instead.
#       `curl` should not be used for writing large scripts.
#       This code is provided for debugging purposes only.

HOST_NAME="localhost"
SITE_NAME="mysite"
PROTO="http" #[http|https]
API_URL="$PROTO://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"

USERNAME="automation"
PASSWORD="test123"

curl \
  --request POST \
  --write-out "\nxxx-status_code=%{http_code}\n" \
  --header "Authorization: Bearer $USERNAME $PASSWORD" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{
          "attributes": {
            "ipaddress": "192.168.0.123"
          },
          "folder": "/",
          "host_name": "example.com"
        }' \
  "$API_URL/domain-types/host_config/collections/all"
```
:::
:::::

::: paragraph
Im ersten Teil des Beispiel-Codes finden Sie die Umgebungsvariablen,
dann folgt das `curl`-Kommando mit der POST-Methode auf die Ressource,
deren URL in der letzten Zeile steht. Durch die Option `-write-out` wird
abschließend eine Zeile mit dem [HTTP-Status-Code](#http-status-code)
ausgegeben. Nach den Header-Zeilen (eine davon definiert die
HTTP-Authentifizierung) folgt der Datenteil, in dem die Parameter für
den neuen Host festgelegt werden.
:::

::: paragraph
Beachten Sie, dass der Curl-Beispiel-Code mehr Parameter enthalten kann,
als Sie im konkreten Fall vielleicht benötigen. Für unser Beispiel ist
dies aber nicht der Fall, und Sie müssen nur die beiden vorhandenen
Parameter `host_name` und `ipaddress` ändern.
:::

::: paragraph
Passen Sie nun den Beispiel-Code an, so dass das Resultat ungefähr so
aussieht:
:::

::::: listingblock
::: title
create_host.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

# NOTE: We recommend all shell users to use the "httpie" examples instead.
#       `curl` should not be used for writing large scripts.
#       This code is provided for debugging purposes only.

HOST_NAME="myserver"
SITE_NAME="mysite"
PROTO="http" #[http|https]
API_URL="$PROTO://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"

USERNAME="automation"
PASSWORD="theautomationsecret"

curl \
  --request POST \
  --write-out "\nxxx-status_code=%{http_code}\n" \
  --header "Authorization: Bearer $USERNAME $PASSWORD" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{
          "attributes": {
            "ipaddress": "192.168.0.42"
          },
          "folder": "/",
          "host_name": "myhost123"
        }' \
  "$API_URL/domain-types/host_config/collections/all"
```
:::
:::::

::: paragraph
Führen Sie das Skript aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ./create_host.sh
{
  "links":[
    {
      "domainType":"link",
      "rel":"self",
      "href":"http://myserver/mysite/check_mk/api/1.0/objects/host_config/myhost123",
      "method":"GET",
      "type":"application/json"
    },
...
    {
      "domainType":"link",
      "rel":"urn:com.checkmk:rels/folder_config",
      "href":"http://myserver/mysite/check_mk/api/1.0/objects/folder_config/~",
      "method":"GET",
      "type":"application/json",
      "title":"The folder config of the host."
    }
  ],
  "domainType":"host_config",
  "id":"myhost123",
  "title":"myhost123",
  "members":{

  },
  "extensions":{
    "folder":"/",
    "attributes":{
      "ipaddress":"192.168.0.42",
      "meta_data":{
        "created_at":"2024-07-03T12:55:29.165920+00:00",
        "updated_at":"2024-07-03T12:55:29.174520+00:00",
        "created_by":"automation"
      }
    },
    "effective_attributes":null,
    "is_cluster":false,
    "is_offline":false,
    "cluster_nodes":null
  }
}
xxx-status_code=200
```
:::
::::

::: paragraph
Zur Erinnerung: Die eine, durch die geschweiften Klammern begrenzte
Zeile im JSON-Format wird hier mehrzeilig dargestellt.
:::

::: paragraph
Die API liefert unter `links` eine Auswahl von (im obigen Beispiel
gekürzten) Anfragen zurück, die auf den gerade erstellten Host
angewendet werden können --- wie es sich für eine REST-API gehört.
Abschließend liefert die API ID und Namen (`title`) des erstellten
Hosts, unter `folder` den Ordner (`/` für den Hauptordner) und unter
`attributes` die dem Host zugewiesenen Attribute inklusive der
IP-Adresse.
:::

::: paragraph
Als letzte wird die Zeile mit dem [HTTP-Status-Code](#http-status-code)
ausgegeben. Dabei steht die `200` für `OK` und bedeutet, dass die Aktion
erfolgreich durchgeführt wurde.
:::
::::::::::::::::::::::::

::::::::::::: sect3
#### []{#service_discovery .hidden-anchor .sr-only}Eine Service-Erkennung auf dem Host durchführen {#heading_service_discovery}

::: paragraph
Nachdem der Host `myhost123` erstellt wurde, können die Services
ermittelt werden. Damit eine
[Service-Erkennung](glossar.html#service_discovery) auch tatsächlich die
erwarteten Services liefert, müssen Sie zuvor auf Linux- und
Windows-Hosts die zugehörigen [Agenten](glossar.html#agent) installieren
und registrieren.
:::

::: paragraph
Für die Ausführung einer Service-Erkennung via REST-API wählen Sie in
der API-Dokumentation den entsprechenden Eintrag aus ([Execute a service
discovery on a host]{.guihint}), kopieren den Beispiel-Code in die dafür
erstellte Skript-Datei und passen ihn an.
:::

::: paragraph
Den ersten Teil mit den Umgebungsvariablen können Sie 1:1 aus dem
vorherigen Beispiel übernehmen. Im `curl`-Kommando ändern Sie den Namen
des Hosts zu `myhost123` und bei Bedarf mit dem Parameter `mode` die Art
der Service-Erkennung.
:::

::::: listingblock
::: title
service_discovery.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

# NOTE: We recommend all shell users to use the "httpie" examples instead.
#       `curl` should not be used for writing large scripts.
#       This code is provided for debugging purposes only.

HOST_NAME="myserver"
SITE_NAME="mysite"
PROTO="http" #[http|https]
API_URL="$PROTO://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"

USERNAME="automation"
PASSWORD="theautomationsecret"

curl \
  --request POST \
  --write-out "\nxxx-status_code=%{http_code}\n" \
  --header "Authorization: Bearer $USERNAME $PASSWORD" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{
          "host_name": "myhost123",
          "mode": "refresh"
        }' \
  "$API_URL/domain-types/service_discovery_run/actions/start/invoke"
```
:::
:::::

::: paragraph
Führen Sie auch dieses Skript aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ./service_discovery.sh

xxx-status_code=302
```
:::
::::

::: paragraph
Der HTTP-Status-Code `302` bedeutet, dass der Hintergrundauftrag
(*background job*) für die Service-Erkennung initialisiert wurde.
:::
:::::::::::::

:::::::::::: sect3
#### []{#show_pending_changes .hidden-anchor .sr-only}Die ausstehenden Änderungen anzeigen {#heading_show_pending_changes}

::: paragraph
Vor der Aktivierung der Änderungen ist noch ein Zwischenschritt
notwendig: die Anzeige der ausstehenden Änderungen mit der Anfrage [Show
all pending changes.]{.guihint} Zusätzlich zu den Änderungen, die sich
angesammelt haben, liefert die REST-API dabei das HTTP ETag (*entity
tag*), das Sie benötigen, um diese Änderungen zu aktivieren. Die
Änderung eines Objekts via REST-API erfolgt nicht über die ID oder den
Titel des Objekts. Stattdessen wird das generierte ETag genutzt, mit dem
verhindert werden soll, dass mehrere konkurrierende Anfragen Werte
desselben Objekts gegenseitig überschreiben.
:::

::: paragraph
Das ETag wird im Antwort-Header (*response header*) zurückgeliefert.
Damit dieser Header angezeigt wird, erweitern Sie den Beispiel-Code für
diese Anfrage, indem Sie `curl` mit der Option -i (für *include response
headers*) aufrufen. Die geänderten Zeilen sind auch im folgenden
Beispiel wieder markiert:
:::

::::: listingblock
::: title
show_pending_changes.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

# NOTE: We recommend all shell users to use the "httpie" examples instead.
#       `curl` should not be used for writing large scripts.
#       This code is provided for debugging purposes only.

HOST_NAME="myserver"
SITE_NAME="mysite"
PROTO="http" #[http|https]
API_URL="$PROTO://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"

USERNAME="automation"
PASSWORD="theautomationsecret"

curl \
  -i \
  --request GET \
  --write-out "\nxxx-status_code=%{http_code}\n" \
  --header "Authorization: Bearer $USERNAME $PASSWORD" \
  --header "Accept: application/json" \
  "$API_URL/domain-types/activation_run/collections/pending_changes"
```
:::
:::::

::: paragraph
Nach der Ausführung des Skripts werden in der Ausgabe nun zuerst die
Header-Zeilen gezeigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ./show_pending_changes.sh
HTTP/1.1 200 OK
Date: Wed, 03 Jul 2024 13:23:26 GMT
...
ETag: "2156db7032754ec778c75123ec12cdd897592b0a574760fa0963a1782c22472c"
...
Content-Type: application/json

{
...
  "domainType":"activation_run",
  "value":[
    {
      "id":"8cb85882-cdae-4d43-b5af-362b4c1cb717",
      "user_id":"automation",
      "action_name":"create-host",
      "text":"Created new host myhost123.",
      "time":"2024-07-03T13:05:07.466406+00:00"
    }
  ]
}
xxx-status_code=200
```
:::
::::

::: paragraph
Die Ausgabe ist gekürzt und markiert sind nur die wichtigen Zeilen: die
Header-Zeile mit dem ETag, die Attribute der einen ausstehenden Änderung
zum Erstellen eines Hosts und der HTTP-Status-Code für `OK`. Das ETag
benötigen Sie im nächsten und letzten Schritt.
:::
::::::::::::

:::::::::::: sect3
#### []{#activate_changes .hidden-anchor .sr-only}Die Änderungen aktivieren {#heading_activate_changes}

::: paragraph
Zum Abschluss müssen die Änderungen aktiviert werden. Die passende
Anfrage heißt [Activate pending changes.]{.guihint}
:::

::: paragraph
Im `curl`-Kommando ändern Sie die Header-Zeile `If-Match` und setzen Sie
dort das im vorherigen Abschnitt ausgelesene ETag ein. Im Datenteil
geben Sie für den Parameter `sites` den Namen der Instanz ein --- dort,
wo die Änderungen aktiviert werden sollen:
:::

::::: listingblock
::: title
activate_changes.sh
:::

::: content
``` {.pygments .highlight}
#!/bin/bash

# NOTE: We recommend all shell users to use the "httpie" examples instead.
#       `curl` should not be used for writing large scripts.
#       This code is provided for debugging purposes only.

HOST_NAME="myserver"
SITE_NAME="mysite"
PROTO="http" #[http|https]
API_URL="$PROTO://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"

USERNAME="automation"
PASSWORD="1234567890"

curl -L \
  --write-out "\nxxx-status_code=%{http_code}\n" \
  --header "Authorization: Bearer $USERNAME $PASSWORD" \
  --header "Accept: application/json" \
  --header "If-Match: "2156db7032754ec778c75123ec12cdd897592b0a574760fa0963a1782c22472c"" \
  --header "Content-Type: application/json" \
  --data '{
          "force_foreign_changes": false,
          "redirect": false,
          "sites": [
            "mysite"
          ]
        }' \
  "$API_URL/domain-types/activation_run/actions/activate-changes/invoke"
```
:::
:::::

::: paragraph
Führen Sie das Skript aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ./activate_changes.sh
{
  "links":[
    {
      "domainType":"link",
      "rel":"self",
      "href":"http://myserver/mysite/check_mk/api/1.0/objects/activation_run/eddbef05-438b-4108-9a02-0d010da2b290",
      "method":"GET",
      "type":"application/json"
    },
    {
      "domainType":"link",
      "rel":"urn:com.checkmk:rels/wait-for-completion",
      "href":"http://myserver/mysite/check_mk/api/1.0/objects/activation_run/eddbef05-438b-4108-9a02-0d010da2b290/actions/wait-for-completion/invoke",
      "method":"GET",
      "type":"application/json"
    }
  ],
  "domainType":"activation_run",
  "id":"eddbef05-438b-4108-9a02-0d010da2b290",
  "title":"Activation status: In progress.",
  "members":{

  },
  "extensions":{
    "sites":[
      "mysite"
    ],
    "is_running":true,
    "force_foreign_changes":false,
    "time_started":"2024-07-03T13:45:07.031741+00:00",
    "changes":[
      {
        "id":"8cb85882-cdae-4d43-b5af-362b4c1cb717",
        "user_id":"automation",
        "action_name":"create-host",
        "text":"Created new host myhost123.",
        "time":"2024-07-03T13:05:07.466406+00:00"
      }
    ]
  }
}
xxx-status_code=200
```
:::
::::

::: paragraph
Der Text im `title` zeigt, dass die Aktivierung gestartet wurde. Wieder
schlägt die REST-API unter `links` zwei sinnvolle Folgeanfragen vor: um
den Status dieser Aktivierung abzufragen und auf deren Abschluss zu
warten.
:::
::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::: sect2
### []{#rest_api_gui .hidden-anchor .sr-only}3.5. Anfragen stellen per REST-API GUI {#heading_rest_api_gui}

::: paragraph
Mit der REST-API **GUI** erhalten Sie eine neue Perspektive auf die API:
Sie können mit dieser GUI aus dem Browser heraus direkt mit der API
interagieren, indem Sie Anfragen per Curl-Kommando an den Server senden
und postwendend die Antworten sehen. Dafür müssen Sie in der API GUI auf
die Code-Beispiele der REST-API-Dokumentation verzichten: beide Sichten
sind eben für ihren Anwendungszweck optimiert.
:::

::: paragraph
Die REST-API GUI wird aus der gleichen Quelle wie die
REST-API-Dokumentation generiert --- dem OpenAPI-Dokument --- und bietet
daher stets die zur API passenden Funktionen an.
:::

::: paragraph
Sie öffnen die API GUI in der Checkmk-GUI über die Navigationsleiste im
Menü [Help \> Developer resources \> REST API interactive
GUI.]{.guihint} Die API GUI wird in einem neuen Browser-Fenster (bzw.
Browser-Tab) angezeigt:
:::

:::: {.imageblock .border}
::: content
![Der Eintrag in der REST API GUI zum Erstellen eines
Hosts.](../images/restapi_swaggerui.png)
:::
::::

::: paragraph
Im Folgenden skizzieren wir, wie Sie die erste Anfrage aus dem obigen
Beispiel (einen Host erstellen) statt per Skript auch mit der REST-API
GUI ausführen können:
:::

::: {.olist .arabic}
1.  Authentisieren: Die REST-API GUI bietet nach dem Anklicken des
    Knopfs [Authorize]{.guihint} (auf der rechten Seite über dem Eintrag
    des ersten Endpunkt-Ordners) eine Dialogbox zur Eingabe der
    Authentifizierungsinformationen. Sofern Sie als Instanzbenutzer
    angemeldet sind, brauchen Sie dort aber **keine** Eingaben zu
    machen, da Sie als Checkmk-Benutzer per
    [Cookie-Authentifizierung](#auth) berechtigt zur Nutzung der
    REST-API sind.

2.  Endpunkt auswählen: Wählen Sie im Ordner [Hosts]{.guihint} den
    Endpunkt [Create a host]{.guihint} aus und klicken Sie [Try it
    out]{.guihint}.

3.  Parameterwerte eingeben: Überschreiben Sie im [Request
    body]{.guihint} die Beispielwerte für `host_name` und `ipaddress`.

4.  Anfrage senden: Klicken Sie [Execute]{.guihint}.

5.  Antwort überprüfen: Unter [Responses]{.guihint} sehen Sie zunächst
    das gesendete Curl-Kommando und die URL des Endpunkts. Anschließend
    wird unter [Server response]{.guihint} die Antwort angezeigt mit
    HTTP-Status-Code und in [Responses]{.guihint} die (mehrzeilig
    formatierte) REST-API Antwort.
:::

::: paragraph
Die REST-API GUI bietet Ihnen also die Möglichkeit, schnell und
unkompliziert die Funktionen der API auszuprobieren und sich mit den
Details der Eingabewerte und mit konkreten Antworten vertraut zu machen.
:::
:::::::::::

::::::::::::: sect2
### []{#error_correction .hidden-anchor .sr-only}3.6. Fehler korrigieren {#heading_error_correction}

::: paragraph
Im Gegensatz zu den bisher gezeigten Ausgaben bei erfolgreichen
Kommandos per Skript, zeigt Ihnen die REST-API Fehler in der folgenden
Art an:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
{
  "title": "The operation has failed.",
  "status": 401,
  "detail": "There are changes from other users and foreign changes are not allowed in this API call."
}
xxx-status_code=401
```
:::
::::

::: paragraph
Je nach Fehler können die in der Ausgabe angezeigten Parameter
unterschiedlich sein. Immer erhalten Sie aber in `status` den
[HTTP-Status-Code](#http-status-code) und in `title` eine
Kurzbeschreibung der Fehlerursache.
:::

::: paragraph
In den meisten Fällen zeigt Ihnen `detail`, wie der Name schon vermuten
lässt, detaillierte Informationen an. Im obigen Beispiel erfahren Sie,
dass es zwar ausstehende Änderungen in Checkmk gibt, diese aber von
einem anderen Benutzer veranlasst wurden. Über die API können
standardmäßig nur Änderungen aktiviert werden, die auch über die API
durchgeführt wurden.
:::

::: paragraph
Auch im nächsten Beispiel stecken die hilfreichen in den detaillierten
Informationen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
{
  "title":"Bad Request",
  "status":400,
  "detail":"These fields have problems: host_name",
  "fields":{
    "host_name":[
      "'my/host123' does not match pattern '^[-0-9a-zA-Z_.]+\\\\Z'."
    ]
  }
}
xxx-status_code=400
```
:::
::::

::: paragraph
Hier liegt das Problem darin, dass ein Parameterwert sich nicht an den
gültigen Wertebereich hält (wegen eines Schrägstrichs im Host-Namen).
:::

::: paragraph
Die Anzahl der möglichen Fehler ist natürlich sehr viel länger als die
beiden, die wir vorgestellt haben. An den gezeigten Beispielen sehen Sie
aber, dass die REST-API in der Ausgabe meist genügend Informationen über
die Ursache liefert und Ihnen so Anhaltspunkte für den Einstieg in die
Analyse und die Fehlerbehebung gibt.
:::
:::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::: sect1
## []{#securing .hidden-anchor .sr-only}4. Die API absichern {#heading_securing}

::::: sectionbody
::: paragraph
Da beim Zugriff über die REST-API sensible Daten übertragen und --- je
nach Berechtigung des Automationsbenutzers --- umfassende Änderungen an
Checkmk durchgeführt werden können, sollten Sie den Zugriff entsprechend
absichern. Hier finden Sie einige der Möglichkeiten:
:::

::: ulist
- [Checkmk über HTTPS](omd_https.html): Nutzen Sie die API
  ausschließlich über das Hypertext Transfer Protocol Secure (HTTPS), da
  Benutzername, Passwort und auch Konfigurationsdaten sonst im Klartext
  im Netz übertragen werden.

- Geben Sie dem Automationsbenutzer ein Passwort mit einer ausreichenden
  Länge. Da das Passwort in der Regel nur in einem Skript hinterlegt
  wird, können Sie problemlos ein sehr langes vergeben.

- Achten Sie auf das Berechtigungskonzept zu den Skripten, mit denen Sie
  die Anfragen an die API stellen. In den Skripten können sensible
  Daten, wie Konfigurationsdaten, Passwörter usw. enthalten sein.
  Stellen Sie daher sicher, dass ausschließlich berechtigte Benutzer und
  Gruppen diese Skripte lesen können.
:::
:::::
::::::

:::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#examples .hidden-anchor .sr-only}5. Beispiele mit REST-API-Anfragen {#heading_examples}

::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
In diesem Kapitel finden Sie Beispiele, die zeigen, wie Sie mit Hilfe
der REST-API häufig benötigte Aktionen ausführen können. Die Beispiele
orientieren sich erneut an dem Beispiel-Code für das
Kommandozeilenprogramm *Curl.* Im Unterschied zum Vorgehen im Kapitel
[Die API nutzen](#using_the_api) werden die Anfragen jedoch nicht per
Skript sondern als `curl`-Befehle auf der Kommandozeile abgesetzt.
Dadurch können Sie die Beispiele gleich ausprobieren --- nachdem Sie sie
auf die bei Ihnen vorhandene Umgebung angepasst haben.
:::

::: paragraph
Um die Befehle noch übersichtlich darstellen zu können, haben wir aus
dem Beispiel-Code nur die für die Befehlsausführung absolut notwendigen
Zeilen übernommen.
:::

::: paragraph
So wie der Beispiel-Code in der API-Dokumentation enthalten auch die
Beispiele in diesem Kapitel Variablen: um die Basis-URL für die REST-API
auf Ihrem Checkmk-Server zusammenzubauen und die Zugangsdaten des
[Automationsbenutzers](glossar.html#automation_user) für die genutzte
[Bearer-Authentifizierung](#bearerauth) festzulegen:
:::

+---------+------------------------+-----------------------------------+
| V       | Beispielwert           | Bedeutung                         |
| ariable |                        |                                   |
+=========+========================+===================================+
| `HOS    | `myserver`             | Name des Checkmk-Servers          |
| T_NAME` |                        |                                   |
+---------+------------------------+-----------------------------------+
| `SIT    | `mysite`               | Name der Checkmk-Instanz          |
| E_NAME` |                        |                                   |
+---------+------------------------+-----------------------------------+
| `A      | `ht                    | Basis-URL der REST-API            |
| PI_URL` | tp://$HOST_NAME/$SITE_ |                                   |
|         | NAME/check_mk/api/1.0` |                                   |
+---------+------------------------+-----------------------------------+
| `US     | `automation`           | Name des Automationsbenutzers     |
| ERNAME` |                        |                                   |
+---------+------------------------+-----------------------------------+
| `PA     | `theautomationsecret`  | Passwort des Automationsbenutzers |
| SSWORD` |                        |                                   |
+---------+------------------------+-----------------------------------+

::: paragraph
Bevor Sie die `curl`-Kommandos absetzen, können Sie die Variablen mit
den folgenden Kommandos in der Shell auf Ihre Umgebung anpassen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ HOST_NAME="myserver"; SITE_NAME="mysite"; API_URL="http://$HOST_NAME/$SITE_NAME/check_mk/api/1.0"; \
USERNAME="automation"; PASSWORD="theautomationsecret";
```
:::
::::

:::::::::::::::::::::::::::::::::::: sect2
### []{#examples_hosts_folders .hidden-anchor .sr-only}5.1. Hosts und Ordner {#heading_examples_hosts_folders}

::: paragraph
Die in diesem Kapitel beschriebenen Anfragen finden Sie in der
API-Dokumentation in den Endpunktordnern [Hosts]{.guihint} und
[Folders]{.guihint}. Die in der API-Dokumentation enthaltenen Titel der
jeweiligen Endpunkte stehen in den folgenden Überschriften in Klammern.
:::

### Alle Ordner anzeigen (Show all folders) {#restapi_show_all_folders .discrete}

::: paragraph
Hier werden *alle* Ordner im Setup angezeigt --- rekursiv ausgehend vom
Hauptordner [Main]{.guihint} --- *ohne* Auflistung der enthaltenen
Hosts:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl -G \
--request GET \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--data-urlencode 'parent=~' \
--data-urlencode 'recursive=true' \
--data-urlencode 'show_hosts=false' \
"$API_URL/domain-types/folder_config/collections/all"
```
:::
::::

### Alle Hosts eines Ordners anzeigen (Show all hosts in a folder) {#restapi_show_all_hosts_in_a_folder .discrete}

::: paragraph
Hier werden die Hosts im Unterordner [Main \> Linux]{.guihint}
angefordert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request GET \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
"$API_URL/objects/folder_config/~linux/collections/hosts"
```
:::
::::

### Ordner erstellen (Create a folder) {#restapi_create_a_folder .discrete}

::: paragraph
Hier wird in [Main \> Linux]{.guihint} ein Unterordner [Production
Hosts]{.guihint} erstellt --- im Dateisystem als Verzeichnis
`production_hosts`. Dem neuen Ordner wird dabei das
[Host-Merkmal](glossar.html#host_tag) [Productive system]{.guihint} aus
der [vordefinierten Host-Merkmalsgruppe](host_tags.html#predefined_tags)
[Criticality]{.guihint} zugewiesen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request POST \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json"     \
--header "Content-Type: application/json" \
--data '{
    "attributes": {
        "tag_criticality": "prod"
    },
    "name": "production_hosts",
    "parent": "~linux",
    "title": "Production Hosts"
    }' \
"$API_URL/domain-types/folder_config/collections/all"
```
:::
::::

### Host erstellen (Create a host) {#restapi_create_a_host .discrete}

::: paragraph
Hier wird im Ordner [Main \> Linux \> Production Hosts]{.guihint} der
Host `mylinuxserver` mit der IP-Adresse `192.168.0.123` und dem
Host-Merkmal [Use piggyback data from other hosts if present]{.guihint}
erstellt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request POST \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '{
    "attributes": {
        "ipaddress": "192.168.0.123",
        "tag_piggyback": "auto-piggyback"
    },
    "folder": "~linux~production_hosts",
    "host_name": "mylinuxserver"
    }' \
"$API_URL/domain-types/host_config/collections/all"
```
:::
::::

### Host anzeigen (Show a host) {#restapi_show_a_host .discrete}

::: paragraph
Durch die Anzeige eines Hosts erhalten Sie die Liste der ihm
zugewiesenen Attribute. Zusätzlich wird dabei das HTTP ETag (*entity
tag*) geliefert, das Sie benötigen, um einen Host zu ändern. Mehr zum
ETag erfahren Sie im Abschnitt [Die ausstehenden Änderungen
anzeigen.](#show_pending_changes)
:::

::: paragraph
Das ETag wird im Antwort-Header (*response header*) zurückgeliefert.
Damit dieser Header angezeigt wird, rufen Sie `curl` mit der Option `-v`
(für *verbose*) auf. Hier wird der Host `mylinuxserver`
abgefragt --- und aus der Antwort nur die Zeile mit dem ETag gezeigt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl -vG \
--request GET \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
"$API_URL/objects/host_config/mylinuxserver"
...
< ETag: "57db3792f23bd81ca7447ba4885fa2865d0c78aed4753229b29e179e539da48b"
...
```
:::
::::

### Host ändern (Update a host) {#restapi_update_a_host .discrete}

::: paragraph
Vor der Änderung besorgen Sie sich das ETag des Hosts, wie im Abschnitt
[Host anzeigen (Show a host)](#restapi_show_a_host) beschrieben. Das
ETag tragen Sie dann im Anfrage-Header unter `If-Match` ein. Hier wird
das beim Erstellen des Hosts gesetzte Host-Merkmal aus der Gruppe
[Piggyback]{.guihint} wieder gelöscht und stattdessen das vordefinierte
Merkmal [API integrations if configured, else Checkmk agent]{.guihint}
gesetzt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request PUT \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "If-Match: "57db3792f23bd81ca7447ba4885fa2865d0c78aed4753229b29e179e539da48b"" \
--header "Content-Type: application/json" \
--data '{
    "remove_attributes": [
        "tag_piggyback"
    ],
    "update_attributes": {
        "tag_agent": "cmk-agent"
    }
    }' \
"$API_URL/objects/host_config/mylinuxserver"
```
:::
::::

### Service-Erkennung auf einem Host durchführen (Execute a service discovery on a host) {#restapi_execute_a_service_discovery_on_a_host .discrete}

::: paragraph
Damit eine [Service-Erkennung](hosts_setup.html#services) auch
tatsächlich die erwarteten Services liefert, müssen Sie zuvor auf Linux-
und Windows-Hosts die zugehörigen
[Monitoring-Agenten](wato_monitoringagents.html) installieren und
registrieren.
:::

::: paragraph
Hier wird die Service-Erkennung auf dem Host `mylinuxserver`
durchgeführt mit der Option `refresh`, was in der Checkmk-GUI dem Knopf
[Full service scan]{.guihint} entspricht:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request POST \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '{
    "host_name": "mylinuxserver",
    "mode": "refresh"
    }' \
"$API_URL/domain-types/service_discovery_run/actions/start/invoke"
```
:::
::::

### Mehrere Hosts erstellen (Bulk create hosts) {#restapi_bulk_create_host .discrete}

::: paragraph
Hier werden zwei Hosts im Ordner [Main \> Linux \> Production
Hosts]{.guihint} erstellt: der erste nur mit IP-Adresse und der zweite
zusätzlich mit einem [Parent-Host](monitoring_basics.html#parents) und
mit zwei [Labels:](glossar.html#label)
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request POST \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '{
   "entries": [
   {
   "attributes": {
       "ipaddress": "192.168.0.130"
   },
   "folder": "~linux~production_hosts",
   "host_name": "mylinuxserver02"
   },
   {
   "attributes": {
       "ipaddress": "192.168.0.131",
       "parents": [ "router01" ],
       "labels": {
           "color": "blue-metallic",
           "admin": "Fozzie Bear"
       }
   },
   "folder": "~linux~production_hosts",
   "host_name": "mylinuxserver03"
   }
   ]
   }' \
"$API_URL/domain-types/host_config/actions/bulk-create/invoke"
```
:::
::::

### Änderungen aktivieren (Activate pending changes) {#restapi_activate_pending_changes .discrete}

::: paragraph
Bevor die komplexe Aktion der Umbenennung eines Hosts in Angriff
genommen werden kann, ist es nötig, alle in der
[Konfigurationsumgebung](glossar.html#configuration_environment)
aufgelaufenen Änderungen zu aktivieren. Hier werden die Änderungen für
die Instanz `mysite` gesammelt aktiviert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request POST \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data '{
    "force_foreign_changes": false,
    "redirect": false,
    "sites": [
        "mysite"
     ]
     }' \
"$API_URL/domain-types/activation_run/actions/activate-changes/invoke"
```
:::
::::

### Host umbenennen (Rename a host) {#restapi_bulk_rename_a_host .discrete}

::: paragraph
Auch ein neuer Name ändert den Host. Besorgen Sie sich daher zuerst das
aktuelle ETag des Hosts, z.B. von `mylinuxserver`, wie im Abschnitt
[Host anzeigen (Show a host)](#restapi_show_a_host) beschrieben, und
tragen es im Anfrage-Header unter `If-Match` ein. Hier wird der Host in
`mylinuxserver01` umbenannt:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ curl \
--request PUT \
--header "Authorization: Bearer $USERNAME $PASSWORD" \
--header "Accept: application/json" \
--header "If-Match: "a200832df1b3c5ebe8f30809177630abbdcf8f7cbd9d0f69bd9f229b359f4d00"" \
--header "Content-Type: application/json" \
--data '{
   "new_name": "mylinuxserver01"
   }' \
"$API_URL/objects/host_config/mylinuxserver/actions/rename/invoke"
```
:::
::::
::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
