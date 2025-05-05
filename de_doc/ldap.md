:::: {#header}
# Benutzerverwaltung mit LDAP/Active Directory

::: details
[Last modified on 29-Dec-2021]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/ldap.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Single Sign-On mit Kerberos](kerberos.html) [Weboberfläche mit HTTPS
absichern](omd_https.html) [Benutzer, Zuständigkeiten,
Berechtigungen](wato_user.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::: sectionbody
::: paragraph
Da eine händische Einrichtung von Benutzern nur bis zu einem gewissen
Grad skaliert, bietet Checkmk die Möglichkeit, LDAP-basierte Dienste für
die Benutzerverwaltung zu nutzen. Sie sind damit in der Lage,
automatisiert Benutzer aus diesen zentralen Verzeichnissen zu
synchronisieren und ihnen, ebenfalls automatisiert, Kontaktgruppen,
Rollen und andere Attribute in Checkmk zuzuweisen. Checkmk ist dabei
nicht auf eine einzelne LDAP-Quelle eingeschränkt und kann die Benutzer
bei Bedarf auch an andere verbundene Instanzen weiterverteilen.
:::
::::
:::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#connect .hidden-anchor .sr-only}2. Konfiguration einer LDAP Verbindung {#heading_connect}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::: sect2
### []{#_verbindung_zum_server .hidden-anchor .sr-only}2.1. Verbindung zum Server {#heading__verbindung_zum_server}

::: paragraph
Um zu einem LDAP-fähigen Server eine Verbindung herzustellen, benötigen
Sie zunächst einen Benutzer, welcher Leserechte auf dem Server besitzt.
Er muss mindestens Lesezugriff auf die Personen und Gruppen haben,
welche er synchronisieren soll. In den folgenden Beispielen heißt dieser
Benutzer `check_mk`.
:::

::: paragraph
Unter [Setup \> Users \> LDAP & Active Directory \> Add
connection]{.guihint} können Sie nun eine neue Verbindung anlegen. Im
Formular vergeben Sie zunächst eine beliebige [ID]{.guihint} für die
Verbindung im Kasten [General Properties]{.guihint}. Optional können Sie
hier unter [Description]{.guihint} einen leicht lesbaren Titel vergeben.
Die [ID]{.guihint} muss wie immer eindeutig sein und kann später nicht
mehr geändert werden. Sie darf nur aus Buchstaben, Ziffern, Gedanken-
und Unterstrich bestehen, beginnend mit einem Buchstaben oder
Unterstrich.
:::

:::: imageblock
::: content
![ldap new connection general
properties](../images/ldap_new_connection_general_properties.png)
:::
::::

::: paragraph
Unter [LDAP Connection]{.guihint} werden nun der LDAP-Server
und --- falls vorhanden --- ein oder mehrere Failover Server definiert.
Sie müssen nun noch den [Directory type]{.guihint} auswählen und die
Benutzerdaten für den Lesezugriff unter [Bind credentials]{.guihint}
definieren. Achten Sie darauf, dass der Benutzer mit seinem
vollständigen LDAP-Pfad angegeben wird. Groß-/Kleinschreibung muss nicht
beachtet werden. Ihre Konfiguration sollte nun etwa so aussehen:
:::

:::: imageblock
::: content
![ldap new connection ldap
connection](../images/ldap_new_connection_ldap_connection.png)
:::
::::

::: paragraph
Checkmk unterstützt nicht nur Active Directory. Um das Verzeichnis z.B.
auf OpenLDAP zu ändern, wählen Sie es entsprechend in dem Feld
[Directory type]{.guihint} aus. Die weitere Konfiguration ändert sich
dabei für Sie nur an wenigen Stellen.
:::

::: paragraph
Die [Failover Servers]{.guihint} werden benutzt, wenn der eigentliche
Server nicht erreichbar ist oder eine Zeitbeschränkung überschritten
wurde. Das ist sinnvoll, wenn Sie lokal über keinen eigenen Server
verfügen, aber die Verbindung redundant aufbauen möchten.
:::

::: paragraph
Die Verbindung von Checkmk mit dem LDAP-Server wird immer so lange
aufrechterhalten bis der LDAP-Server aufgrund eines Timeouts oder
anderer Probleme nicht mehr erreichbar ist. Erst dann wird zum Failover
Server gewechselt. Das Gleiche gilt auch nach dem Wechsel: Die
Verbindung wird erst dann wieder zurück zum eigentlich konfigurierten
Server wechseln, wenn der Failover Server nicht erreicht werden kann.
:::
:::::::::::::

:::::::::::::::::::: sect2
### []{#user_filter .hidden-anchor .sr-only}2.2. Benutzer definieren {#heading_user_filter}

::: paragraph
Als Nächstes werden die Pfade zu den Benutzern und Gruppen bestimmt und
Filter gesetzt. Geben Sie in [User base DN]{.guihint} zunächst den Pfad
an, unter dem die Benutzer zu finden sind. Achten Sie hier darauf, die
*Operational Unit* (OU) so zu setzen, dass möglichst alle gewünschten
Benutzer, aber möglichst wenig andere enthalten sind. Je mehr Benutzer
abgefragt werden, desto langsamer wird die Synchronisation am Ende sein.
:::

::: paragraph
Danach setzen Sie die Option [Search scope]{.guihint}. Sie können hier
rekursiv nach allen Benutzern filtern, die sich in der OU und in den
Units darunter befinden oder die Suche auf diejenigen einschränken, die
sich nur direkt in dieser OU befinden. Falls Sie in dem Pfad einen
Benutzer direkt angegeben haben, sollten Sie [Search only the entry at
the base DN]{.guihint} auswählen. Es wird dann nur dieser Benutzer
erfasst.
:::

::: paragraph
Sie können nun mithilfe der Option [Search filter]{.guihint} die Auswahl
der zu importierenden Benutzer weiter einschränken. Wollen Sie z.B. nur
Benutzer synchronisieren, welche einer bestimmten Gruppe angehören, so
setzen Sie hier eine LDAP-Abfrage ein, wie in dem folgenden Screenshot
zu sehen. Voraussetzung dabei ist, dass die Benutzer über das Attribut
`memberof` verfügen. Wie Sie ohne dieses Attribut nach einer
Gruppenzugehörigkeit filtern, erfahren Sie weiter
[unten.](#filter_group)
:::

:::: imageblock
::: content
![ldap new connection users](../images/ldap_new_connection_users.png)
:::
::::

::: paragraph
Sie können den Standardfilter auch mit `memberof` oder anderen Filtern
kombinieren:
:::

::: paragraph
`(&(objectclass=user)(objectcategory=person)(memberof=cn=cmk-admins,ou=groups,dc=mycompany,dc=example))`
:::

::: paragraph
Wie Sie im Kasten [Users]{.guihint} sehen können, gibt es noch weitere
Optionen bei der Benutzersuche. So ist es möglich mit der Option
[User-ID attribute]{.guihint} zu bestimmen, welches Attribut der
Benutzer als Login ID in Checkmk benutzen wird. Mit diesem Login wird
sich der Benutzer später anmelden. In der Regel wird dies bei Active
Directory das Attribut `sAMAccountName` sein, welches auch als Standard
in Checkmk genutzt wird. Unter OpenLDAP ist dies oft das Attribut `uid`.
:::

::: paragraph
Mit der Option [Lower case User-IDs]{.guihint} können Sie die
synchronisierten IDs in Kleinbuchstaben umwandeln. Das ist unter
Umständen sinnvoll, da, wie bereits erwähnt, Active Directory/LDAP nicht
zwischen Groß- und Kleinschreibung unterscheidet, Checkmk allerdings
schon. Das kann zu Verwirrung führen, die durch diese Option gelöst
wird.
:::

::: paragraph
Die Option [Umlauts in User-IDs (deprecated)]{.guihint} ist nur noch aus
Kompatibilitätsgründen vorhanden und sollte nicht mehr
verwendet/verändert werden.
:::

::: paragraph
Zu guter Letzt bietet Ihnen die Option [Create users only on
login]{.guihint} die Möglichkeit, neue Benutzer nicht bei der
Synchronisierung sondern erst bei ihrem ersten Login in Checkmk
anzulegen.
:::

:::: imageblock
::: content
![ldap new connection users search filter
2](../images/ldap_new_connection_users_search_filter_2.png)
:::
::::

::: {#filter_group .paragraph}
Die Option [Filter group]{.guihint} sollte nur verwendet werden, wenn
der LDAP-Server **kein** Active Directory ist und in den Benutzerdaten
das dynamische Attribut `memberof` nicht verfügbar ist. Die Filterung
der Benutzer erfolgt in diesem Fall in Checkmk selbst. Es werden dabei
unter Umständen viele Benutzer abgefragt, welche später wieder verworfen
werden. Ein solches Szenario kann das LDAP-Modul in Checkmk stark
ausbremsen.
:::

::: paragraph
Sind Sie jedoch auf diese Option angewiesen, so wird hier der komplette
Pfad zu der Gruppe eingetragen, nach der gefiltert werden soll:
:::

:::: imageblock
::: content
![ldap new connection users filter
group](../images/ldap_new_connection_users_filter_group.png)
:::
::::
::::::::::::::::::::

::::::: sect2
### []{#groupfilter .hidden-anchor .sr-only}2.3. Gruppen definieren {#heading_groupfilter}

::: paragraph
Falls Sie bei den Benutzern nach einer Gruppe filtern, richten Sie noch
den Pfad zu der Gruppe ein, damit ein Abgleich stattfinden kann. Sie
können hier in gleicher Weise vorgehen, wie bei den Benutzern: Wird eine
Gruppe direkt angegeben, so kann unter [Search scope]{.guihint} die
Option [Search only the entry at the base DN]{.guihint} genommen werden.
Ansonsten wird entweder in der OU direkt gesucht, oder die Units
darunter werden ebenfalls einbezogen.
:::

::: paragraph
Und auch hier ist es mithilfe der Option [Search filter]{.guihint}
möglich, zu bestimmen, wie der Name der Gruppe in Checkmk festgelegt
wird. Zusätzlich können Sie angeben, wie das Attribut heißt ([Member
attribute]{.guihint}), in dem die Mitglieder der Gruppe hinterlegt sind.
Standardmäßig verwendet Checkmk `member`. Unter OpenLDAP kann dies aber
auch `uniqueMember` sein. Ändern Sie die Option dann entsprechend ab.
:::

:::: imageblock
::: content
![ldap new connection groups](../images/ldap_new_connection_groups.png)
:::
::::
:::::::

::::::: sect2
### []{#config_test .hidden-anchor .sr-only}2.4. Testen der Konfiguration {#heading_config_test}

::: paragraph
Sie haben nun bereits die erste Einrichtung abgeschlossen und können zur
Diagnose die Konfiguration über den Knopf [Save & test]{.guihint}
speichern und testen:
:::

:::: {.imageblock .border}
::: content
![ldap new connection
diagnostics](../images/ldap_new_connection_diagnostics.png)
:::
::::

::: paragraph
Sie müssen keine Gruppen angeben, um eine funktionierende Konfiguration
zu erhalten. Sofern sich aber in der OU nur Benutzer für Checkmk
befinden, ist es sinnvoll die Auswahl über eine oder mehrere Gruppen
einzuschränken.
:::
:::::::

::::::: sect2
### []{#_das_synchronisierungsintervall .hidden-anchor .sr-only}2.5. Das Synchronisierungsintervall {#heading__das_synchronisierungsintervall}

::: paragraph
Als Letztes können Sie noch definieren, wie oft die Benutzer automatisch
synchronisiert werden sollen. In einer Umgebung, in der sich selten
etwas ändert, ist der Standardwert vielleicht etwas zu eng gewählt. Das
Zeitfenster sollte allerdings auch nicht zu weit gesetzt werden, damit
Änderungen auch zeitnah in Checkmk abgebildet werden können.
:::

:::: imageblock
::: content
![ldap new connection other](../images/ldap_new_connection_other.png)
:::
::::

::: paragraph
Sie können die Synchronisation auch jederzeit manuell in [Setup \> Users
\> Users \> Synchronize users]{.guihint} anstoßen. Zusätzlich wird ein
Benutzer auch bei Bedarf synchronisiert, wenn er versucht sich
anzumelden, aber noch nicht synchronisiert ist.
:::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::: sect1
## []{#_automatische_zuordnung_von_attributen .hidden-anchor .sr-only}3. Automatische Zuordnung von Attributen {#heading__automatische_zuordnung_von_attributen}

::::::::::::::::::: sectionbody
::::::::::: sect2
### []{#contact_groups .hidden-anchor .sr-only}3.1. Kontaktgruppen {#heading_contact_groups}

::: paragraph
Es bringt leider nichts alle Benutzer automatisch anzulegen, wenn man
diese danach manuell den Kontaktgruppen zuordnen muss. Checkmk bietet
die Möglichkeit, die Gruppen des LDAP-Servers zu nutzen, um diese
Kontaktgruppen zuzuordnen. Aktivieren Sie dafür die Option [Attribute
sync plugins \> Contactgroup Membership:]{.guihint}
:::

:::: imageblock
::: content
![ldap new connection contactgroup
membership](../images/ldap_new_connection_contactgroup_membership.png)
:::
::::

::: paragraph
Damit eine Zuordnung klappt, muss der Name (`cn`) der Gruppe auf dem
LDAP-Server identisch mit dem in Checkmk sein. Das heißt, die
Kontaktgruppe `oracle_admins` wird nur korrekt einem Benutzer
zugeordnet, wenn dieser auch im LDAP in der Gruppe `oracle_admins` ist.
Ist er stattdessen in der Gruppe `oracle-admins` oder `ORACLE_admins`,
so wird die Zuordnung nicht funktionieren. Achten Sie also auf die
korrekte Schreibweise, falls es an dieser Stelle zu Problemen kommt.
:::

:::: sect3
#### []{#nested_groups .hidden-anchor .sr-only}Nested Groups {#heading_nested_groups}

::: paragraph
Checkmk bietet --- im Moment nur für Active Directory --- die
Möglichkeit, auch vererbte Gruppen zu nutzen. Aktivieren Sie diese
Option, wenn z.B. Ihr Benutzer in der Gruppe `oracle_admins` ist und
diese Gruppe wiederum Mitglied in `cmk-user`.
:::
::::

:::: sect3
#### []{#_gruppen_aus_anderen_verbindungen .hidden-anchor .sr-only}Gruppen aus anderen Verbindungen {#heading__gruppen_aus_anderen_verbindungen}

::: paragraph
Wenn in Checkmk mehrere LDAP-Verbindungen eingerichtet wurden, können
Sie auch Gruppen aus anderen Quellen benutzen, um eine Zuordnung zu
ermöglichen. Das kann sinnvoll sein, wenn Sie eine allgemeine Verbindung
konfiguriert haben und in den anderen nur auf bestimmte Gruppen filtern.
:::
::::
:::::::::::

::::::: sect2
### []{#_rollen .hidden-anchor .sr-only}3.2. Rollen {#heading__rollen}

::: paragraph
Auch die Rollen können in einer ähnlichen Weise automatisch zugeordnet
werden und die Funktion [Nested Groups](#nested_groups) kann hier
ebenfalls genutzt werden. Für jede Rolle können eine oder mehrere
Gruppen definiert werden. Wählen Sie dafür die Rolle aus, zu der Sie
eine Verknüpfung einrichten wollen und geben Sie den vollständigen Pfad
zu der Gruppe an. Standardmäßig wird in den Gruppen gesucht, welche vom
[Gruppenfilter](#groupfilter) gefunden wurden. Sie können aber auch
andere Verbindungen und die darüber gefundenen Gruppen nutzen. Wählen
Sie dafür in der Liste die entsprechende Verbindung aus.
:::

:::: imageblock
::: content
![ldap new connection roles](../images/ldap_new_connection_roles.png)
:::
::::

::: paragraph
Mit den Einstellungen im obigen Bild werden alle Benutzer aus der
angegebenen Gruppe der Rolle [Administrator]{.guihint} zugeordnet,
sofern sie durch den [Benutzerfilter](#user_filter) auch synchronisiert
werden. Wie Sie im Bild sehen können, können Sie auch selbst
konfigurierte Rollen auswählen und mit Gruppen aus dem LDAP verknüpfen.
:::
:::::::

:::: sect2
### []{#other_attr .hidden-anchor .sr-only}3.3. Weitere Attribute {#heading_other_attr}

::: paragraph
Für die Synchronisation von weiteren Benutzerinformationen braucht es in
der Regel nur die Aktivierung des jeweiligen Plugins unter [Attribute
Sync Plugins]{.guihint} und eventuell der Angabe des Attributs, welches
die Information bereitstellt. Nachfolgend eine Tabelle der Plugins,
genutzten Attribute (wenn nicht manuell gesetzt) und Kurzbeschreibungen.
Einige der Attribute finden sich auch im
[User-Menü](user_interface.html#user_menu) eines Benutzers.
:::

+------------------------+---+---+---+--------------------------------------+
| Plugin                 | A | S | M | Beschreibung                         |
|                        | t | y | ö |                                      |
|                        | t | n | g |                                      |
|                        | r | t | l |                                      |
|                        | i | a | i |                                      |
|                        | b | x | c |                                      |
|                        | u |   | h |                                      |
|                        | t |   | e |                                      |
|                        |   |   | W |                                      |
|                        |   |   | e |                                      |
|                        |   |   | r |                                      |
|                        |   |   | t |                                      |
|                        |   |   | e |                                      |
+========================+===+===+===+======================================+
| [Alias]{.guihint}      | ` | S |   | Normalerweise der Vor- und Nachname  |
|                        | c | t |   | des Benutzers.                       |
|                        | n | r |   |                                      |
|                        | ` | i |   |                                      |
|                        |   | n |   |                                      |
|                        |   | g |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Authentication        | ` | I |   | Wann ein Benutzer abgemeldet oder    |
| Expiration]{.guihint}  | p | n |   | gesperrt wird.                       |
|                        | w | t |   |                                      |
|                        | d | e |   |                                      |
|                        | l | r |   |                                      |
|                        | a | v |   |                                      |
|                        | s | a |   |                                      |
|                        | t | l |   |                                      |
|                        | s |   |   |                                      |
|                        | e |   |   |                                      |
|                        | t |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Disable               | ` | B | ` | `True` deaktiviert **alle**          |
| no                     | d | o | T | Benachrichtigungen an den Benutzer.  |
| tifications]{.guihint} | i | o | r |                                      |
|                        | s | l | u |                                      |
|                        | a | e | e |                                      |
|                        | b | a | ` |                                      |
|                        | l | n | , |                                      |
|                        | e |   | ` |                                      |
|                        | _ |   | F |                                      |
|                        | n |   | a |                                      |
|                        | o |   | l |                                      |
|                        | t |   | s |                                      |
|                        | i |   | e |                                      |
|                        | f |   | ` |                                      |
|                        | i |   |   |                                      |
|                        | c |   |   |                                      |
|                        | a |   |   |                                      |
|                        | t |   |   |                                      |
|                        | i |   |   |                                      |
|                        | o |   |   |                                      |
|                        | n |   |   |                                      |
|                        | s |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Email                 | ` | S |   | Die E-Mail-Adresse des Benutzers.    |
| address]{.guihint}     | m | t |   |                                      |
|                        | a | r |   |                                      |
|                        | i | i |   |                                      |
|                        | l | n |   |                                      |
|                        | ` | g |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Mega menu             | ` | S | ` | In den Mega-Menüs grüne Symbole beim |
| icons]{.guihint}       | i | t | N | Thema (`None`) oder farbige Symbole  |
|                        | c | r | o | bei jedem Menüeintrag (`entry`)      |
|                        | o | i | n | anzeigen.                            |
|                        | n | n | e |                                      |
|                        | s | g | ` |                                      |
|                        | _ |   | , |                                      |
|                        | p |   | ` |                                      |
|                        | e |   | e |                                      |
|                        | r |   | n |                                      |
|                        | _ |   | t |                                      |
|                        | i |   | r |                                      |
|                        | t |   | y |                                      |
|                        | e |   | ` |                                      |
|                        | m |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Navigation bar        | ` | S | ` | In der                               |
| icons]{.guihint}       | n | t | N | [Navigations                         |
|                        | a | r | o | leiste](glossar.html#navigation_bar) |
|                        | v | i | n | nur Symbole (`hide`) oder Symbole    |
|                        | _ | n | e | mit Titel (`None`) anzeigen.         |
|                        | h | g | ` |                                      |
|                        | i |   | , |                                      |
|                        | d |   | ` |                                      |
|                        | e |   | h |                                      |
|                        | _ |   | i |                                      |
|                        | i |   | d |                                      |
|                        | c |   | e |                                      |
|                        | o |   | ` |                                      |
|                        | n |   |   |                                      |
|                        | s |   |   |                                      |
|                        | _ |   |   |                                      |
|                        | t |   |   |                                      |
|                        | i |   |   |                                      |
|                        | t |   |   |                                      |
|                        | l |   |   |                                      |
|                        | e |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Pager]{.guihint}      | ` | S |   | Eine hinterlegte                     |
|                        | m | t |   | Telefon-/Pagernummer.                |
|                        | o | r |   |                                      |
|                        | b | i |   |                                      |
|                        | i | n |   |                                      |
|                        | l | g |   |                                      |
|                        | e |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Show more / Show      | ` | S | ` | In der Benutzeroberfläche weniger    |
| less]{.guihint}        | s | t | d | (`default_show_less`), mehr          |
|                        | h | r | e | (`default_show_more`) oder stets     |
|                        | o | i | f | alles (`enforce_show_more`)          |
|                        | w | n | a | anzeigen. Mehr Informationen zum     |
|                        | _ | g | u | Show-less- und Show-more-Modus       |
|                        | m |   | l | finden Sie im [Leitfaden für         |
|                        | o |   | t | Einstei                              |
|                        | d |   | _ | ger.](intro_gui.html#show_less_more) |
|                        | e |   | s |                                      |
|                        | ` |   | h |                                      |
|                        |   |   | o |                                      |
|                        |   |   | w |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | l |                                      |
|                        |   |   | e |                                      |
|                        |   |   | s |                                      |
|                        |   |   | s |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | , |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | d |                                      |
|                        |   |   | e |                                      |
|                        |   |   | f |                                      |
|                        |   |   | a |                                      |
|                        |   |   | u |                                      |
|                        |   |   | l |                                      |
|                        |   |   | t |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | s |                                      |
|                        |   |   | h |                                      |
|                        |   |   | o |                                      |
|                        |   |   | w |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | m |                                      |
|                        |   |   | o |                                      |
|                        |   |   | r |                                      |
|                        |   |   | e |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | , |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | e |                                      |
|                        |   |   | n |                                      |
|                        |   |   | f |                                      |
|                        |   |   | o |                                      |
|                        |   |   | r |                                      |
|                        |   |   | c |                                      |
|                        |   |   | e |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | s |                                      |
|                        |   |   | h |                                      |
|                        |   |   | o |                                      |
|                        |   |   | w |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | m |                                      |
|                        |   |   | o |                                      |
|                        |   |   | r |                                      |
|                        |   |   | e |                                      |
|                        |   |   | ` |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Sidebar               | ` | S | ` | Die                                  |
| position]{.guihint}    | u | t | N | [Seitenleiste](glossar.html#sidebar) |
|                        | i | r | o | auf der rechten (`None`) oder auf    |
|                        | _ | i | n | der linken (`left`) Seite anzeigen.  |
|                        | s | n | e |                                      |
|                        | i | g | ` |                                      |
|                        | d |   | , |                                      |
|                        | e |   | ` |                                      |
|                        | b |   | l |                                      |
|                        | a |   | e |                                      |
|                        | r |   | f |                                      |
|                        | _ |   | t |                                      |
|                        | p |   | ` |                                      |
|                        | o |   |   |                                      |
|                        | s |   |   |                                      |
|                        | i |   |   |                                      |
|                        | t |   |   |                                      |
|                        | i |   |   |                                      |
|                        | o |   |   |                                      |
|                        | n |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Start URL to display  | ` | S | B | URL der Startseite.                  |
| in main                | s | t | e |                                      |
| frame]{.guihint}       | t | r | i |                                      |
|                        | a | i | s |                                      |
|                        | r | n | p |                                      |
|                        | t | g | i |                                      |
|                        | _ |   | e |                                      |
|                        | u |   | l |                                      |
|                        | r |   | e |                                      |
|                        | l |   | : |                                      |
|                        | ` |   | ` |                                      |
|                        |   |   | v |                                      |
|                        |   |   | i |                                      |
|                        |   |   | e |                                      |
|                        |   |   | w |                                      |
|                        |   |   | . |                                      |
|                        |   |   | p |                                      |
|                        |   |   | y |                                      |
|                        |   |   | ? |                                      |
|                        |   |   | v |                                      |
|                        |   |   | i |                                      |
|                        |   |   | e |                                      |
|                        |   |   | w |                                      |
|                        |   |   | _ |                                      |
|                        |   |   | n |                                      |
|                        |   |   | a |                                      |
|                        |   |   | m |                                      |
|                        |   |   | e |                                      |
|                        |   |   | = |                                      |
|                        |   |   | a |                                      |
|                        |   |   | l |                                      |
|                        |   |   | l |                                      |
|                        |   |   | h |                                      |
|                        |   |   | o |                                      |
|                        |   |   | s |                                      |
|                        |   |   | t |                                      |
|                        |   |   | s |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | o |                                      |
|                        |   |   | d |                                      |
|                        |   |   | e |                                      |
|                        |   |   | r |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | d |                                      |
|                        |   |   | a |                                      |
|                        |   |   | s |                                      |
|                        |   |   | h |                                      |
|                        |   |   | b |                                      |
|                        |   |   | o |                                      |
|                        |   |   | a |                                      |
|                        |   |   | r |                                      |
|                        |   |   | d |                                      |
|                        |   |   | . |                                      |
|                        |   |   | p |                                      |
|                        |   |   | y |                                      |
|                        |   |   | ` |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Temperature           | ` | S | ` | Einheit der Temperatur in Celsius    |
| unit]{.guihint}        | t | t | c | oder Fahrenheit für die Anzeige in   |
|                        | e | r | e | Graphen und Perf-O-Metern.           |
|                        | m | i | l |                                      |
|                        | p | n | s |                                      |
|                        | e | g | i |                                      |
|                        | r |   | u |                                      |
|                        | a |   | s |                                      |
|                        | t |   | ` |                                      |
|                        | u |   | , |                                      |
|                        | r |   | ` |                                      |
|                        | e |   | f |                                      |
|                        | _ |   | a |                                      |
|                        | u |   | h |                                      |
|                        | n |   | r |                                      |
|                        | i |   | e |                                      |
|                        | t |   | n |                                      |
|                        | ` |   | h |                                      |
|                        |   |   | e |                                      |
|                        |   |   | i |                                      |
|                        |   |   | t |                                      |
|                        |   |   | ` |                                      |
+------------------------+---+---+---+--------------------------------------+
| [User interface        | ` | S | ` | Das Thema der Benutzeroberfläche:    |
| theme]{.guihint}       | u | t | f | Dark (`modern-dark`) oder Light      |
|                        | i | r | a | (`facelift`).                        |
|                        | _ | i | c |                                      |
|                        | t | n | e |                                      |
|                        | h | g | l |                                      |
|                        | e |   | i |                                      |
|                        | m |   | f |                                      |
|                        | e |   | t |                                      |
|                        | ` |   | ` |                                      |
|                        |   |   | , |                                      |
|                        |   |   | ` |                                      |
|                        |   |   | m |                                      |
|                        |   |   | o |                                      |
|                        |   |   | d |                                      |
|                        |   |   | e |                                      |
|                        |   |   | r |                                      |
|                        |   |   | n |                                      |
|                        |   |   | - |                                      |
|                        |   |   | d |                                      |
|                        |   |   | a |                                      |
|                        |   |   | r |                                      |
|                        |   |   | k |                                      |
|                        |   |   | ` |                                      |
+------------------------+---+---+---+--------------------------------------+
| [Visibility of         | ` | B | ` | Alle Hosts und Services anzeigen     |
| hos                    | f | o | T | (`False`) oder nur diejenigen, für   |
| ts/services]{.guihint} | o | o | r | die der Benutzer als Kontakt         |
|                        | r | l | u | zugewiesen ist (`True`).             |
|                        | c | e | e |                                      |
|                        | e | a | ` |                                      |
|                        | _ | n | , |                                      |
|                        | a |   | ` |                                      |
|                        | u |   | F |                                      |
|                        | t |   | a |                                      |
|                        | h |   | l |                                      |
|                        | u |   | s |                                      |
|                        | s |   | e |                                      |
|                        | e |   | ` |                                      |
|                        | r |   |   |                                      |
|                        | ` |   |   |                                      |
+------------------------+---+---+---+--------------------------------------+
::::
:::::::::::::::::::
::::::::::::::::::::

:::::::: sect1
## []{#distr_wato .hidden-anchor .sr-only}4. LDAP in verteilten Umgebungen {#heading_distr_wato}

::::::: sectionbody
::: paragraph
Bei der Einrichtung einer [verteilten
Umgebung](distributed_monitoring.html) mit einer [zentralen
Konfiguration](distributed_monitoring.html#distr_wato) können Sie
bestimmen, ob und welche LDAP-Verbindungen von der Remote-Instanz aus
synchronisiert werden sollen. Wenn Sie nichts ändern, wird die
Remote-Instanz alle Benutzer aus den konfigurierten Verbindungen selbst
synchronisieren. Auf diese Weise werden Änderungen automatisch auf jeder
Instanz innerhalb des definierten Intervalls abgebildet und müssen nicht
erst von der Zentralinstanz zur Remote-Instanz kopiert werden. Sie
können die Synchronisation aber auch auf bestimmte Verbindungen
einschränken oder ganz abschalten. In letzterem Fall werden die Benutzer
auf der Zentralinstanz aus den LDAP-Verbindungen abgerufen und beim
[Aktivieren der Änderungen](glossar.html#activate_changes) auf die
Remote-Instanzen kopiert.
:::

::: paragraph
Sie können die Einstellungen in [Setup \> General \> Distributed
monitoring]{.guihint} in den [Properties]{.guihint} der Verbindung
konfigurieren. Hier ein Beispiel, bei dem die oben eingerichtete
Verbindung ausgewählt wird:
:::

:::: imageblock
::: content
![ldap distributed monitoring sync
ldap](../images/ldap_distributed_monitoring_sync_ldap.png)
:::
::::
:::::::
::::::::

:::::::::::: sect1
## []{#ssl .hidden-anchor .sr-only}5. LDAP mit SSL absichern {#heading_ssl}

::::::::::: sectionbody
::: paragraph
Um die LDAP-Verbindung mit SSL abzusichern, aktivieren Sie lediglich in
den Verbindungsdaten das Häkchen [Use SSL]{.guihint} und passen noch den
[TCP port]{.guihint} an (bei LDAP über SSL üblicherweise `636`).
:::

:::: imageblock
::: content
![ldap new connection ldap connection
ssl](../images/ldap_new_connection_ldap_connection_ssl.png)
:::
::::

::: paragraph
Sofern der oder die LDAP-Server ein Zertifikat nutzen, welches von einer
vertrauenswürdigen Zertifizierungsstelle signiert wurde, ist damit
bereits alles Nötige getan, um eine verschlüsselte Verbindung
aufzubauen.
:::

::: paragraph
Wenn Sie ein selbst signiertes Zertifikat nutzen, wird der
Verbindungsaufbau nur dann funktionieren, wenn Sie dieses noch in den
Zertifikatsspeicher importieren. Erst dann wird es als vertrauenswürdig
eingestuft und die Verbindung aufgebaut.
:::

::: paragraph
Öffnen Sie dazu [Setup \> General \> Global settings \> Site management
\> Trusted certificate authorities for SSL.]{.guihint} Klicken Sie hier
auf [Add new CA certificate or chain]{.guihint} und kopieren Sie den
Inhalt Ihres Zertifikats entweder in das vorgesehene Feld oder wählen
Sie [Upload CRT/PEM File]{.guihint} und laden Sie Ihre PEM- oder
CRT-Datei hoch.
:::

:::: imageblock
::: content
![ldap add new ca
certificate](../images/ldap_add_new_ca_certificate.png)
:::
::::
:::::::::::
::::::::::::

:::::::: sect1
## []{#_fehlerdiagnose .hidden-anchor .sr-only}6. Fehlerdiagnose {#heading__fehlerdiagnose}

::::::: sectionbody
::: paragraph
Eine Fehlerdiagnose ist in der [Konfigurationseinrichtung](#config_test)
direkt implementiert. Auch nach der Einrichtung kann hier überprüft
werden, woher ein Problem kommen könnte. Zusätzlich werden
Fehlermeldungen auch in das `web.log` geschrieben. Diese Meldungen
können ebenfalls auf die Fehlerquelle hinweisen:
:::

::::: listingblock
::: title
\~/var/log/web.log
:::

::: content
``` {.pygments .highlight}
2020-09-19 16:03:17,155 [40] [cmk.web 31797] /ldaptest/check_mk/wato.py Internal error: Traceback (most recent call last):
  File "/omd/sites/ldaptest/share/check_mk/web/htdocs/wato.py", line 6563, in mode_edit_ldap_connection
    state, msg = test_func(connection, address)
  File "/omd/sites/ldaptest/share/check_mk/web/htdocs/wato.py", line 6506, in test_group_count
    connection.connect(enforce_new = True, enforce_server = address)
  File "/omd/sites/ldaptest/share/check_mk/web/plugins/userdb/ldap.py", line 274, in connect
    ('\n'.join(errors)))
MKLDAPException: LDAP connection failed:
ldap://myldap.mycompany.org: Can't contact LDAP server
```
:::
:::::
:::::::
::::::::

:::: sect1
## []{#_dateien_und_verzeichnisse .hidden-anchor .sr-only}7. Dateien und Verzeichnisse {#heading__dateien_und_verzeichnisse}

::: sectionbody
+---------------------------+------------------------------------------+
| Pfad                      | Bedeutung                                |
+===========================+==========================================+
| `~/                       | In dieser Datei werden alle im Setup     |
| etc/check_mk/multisite.d/ | konfigurierten LDAP Verbindungen         |
| wato/user_connections.mk` | festgehalten.                            |
+---------------------------+------------------------------------------+
| `~/etc/check_mk/m         | Alle Benutzer werden hier definiert.     |
| ultisite.d/wato/users.mk` |                                          |
+---------------------------+------------------------------------------+
| `~/var/log/web.log`       | Die Log-Datei, in der Verbindungsfehler  |
|                           | aufgezeichnet werden. Es ist damit eine  |
|                           | der ersten Quellen bei Problemen.        |
+---------------------------+------------------------------------------+
:::
::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
