:::: {#header}
# Passwortspeicher (Password store)

::: details
[Last modified on 13-Nov-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/password_store.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Netzwerkdienste überwachen (Aktive Checks)](active_checks.html)
[Datenquellenprogramme](datasource_programs.html)
[Benachrichtigungen](notifications.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
::: paragraph
Mit dem Passwortspeicher (*password store*) haben Sie in Checkmk die
Möglichkeit, Passwörter zentral abzulegen, die für den Zugriff auf die
unterschiedlichsten Systeme im Monitoring notwendig sind. Im
Passwortspeicher wird dabei unterschieden, wer ein Passwort ablegen und
wer es nutzen darf. Dadurch können Sie eine organisatorische Trennung in
Ihrer Firma zwischen Hinterlegung und Nutzung von Zugangsdaten in
Checkmk abbilden. Checkmk bietet dazu die
[Kontaktgruppen](wato_user.html#contact_groups) an.
:::

::: paragraph
Ein weiterer Vorteil ist, dass ein im Passwortspeicher abgelegtes
Passwort geändert werden kann, ohne dass die Konfiguration angefasst
werden muss, die dieses Passwort verwendet. Das Passwort selbst wird bei
der Nutzung nicht angezeigt, sondern nur dessen Titel.
:::

::: paragraph
Der Passwortspeicher nimmt nicht nur Passwörter auf, die einem Benutzer
zugeordnet sind, sondern zum Beispiel auch *Secrets* (für Apps in
[Microsoft Azure](monitoring_azure.html)), *Tokens* (für
Service-Accounts in einem
[Kubernetes](monitoring_kubernetes.html)-Cluster) oder *URLs* (für
Benachrichtigungen etwa zu [Microsoft Teams](notifications_teams.html),
[Slack](notifications_slack.html) oder [Cisco Webex
Teams](notifications_webex.html)).
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Der Passwortspeicher dient dazu,  |
|                                   | an einem zentralen Ort sensible   |
|                                   | Informationen zu sammeln, statt   |
|                                   | diese an unterschiedlichsten      |
|                                   | Stellen in der                    |
|                                   | Che                               |
|                                   | ckmk-[Instanz](glossar.html#site) |
|                                   | verteilt zu halten. Der           |
|                                   | Passwortspeicher ist **kein**     |
|                                   | Passwortsafe. Checkmk benötigt    |
|                                   | die Zugangsdaten mit den          |
|                                   | Passwörtern im Klartext, um       |
|                                   | laufend die fernen Systeme zu     |
|                                   | kontaktieren und die              |
|                                   | Monitoring-Daten abzurufen. Damit |
|                                   | die Passwörter nicht im Klartext  |
|                                   | im Dateisystem gespeichert        |
|                                   | werden, wird die Passwortdatei    |
|                                   | zwar verschlüsselt --- allerdings |
|                                   | mit einem Schlüssel, der          |
|                                   | ebenfalls im Instanzverzeichnis   |
|                                   | abgelegt ist. Um klar zu machen,  |
|                                   | dass diese Verschlüsselung nicht  |
|                                   | das ist, was man im allgemeinen   |
|                                   | darunter versteht, nennt man      |
|                                   | dieses Verfahren                  |
|                                   | **Verschleierung**                |
|                                   | (*obfuscation*).                  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die Nutzung des Passwortspeichers wird in Checkmk immer dort angeboten,
wo die Eingabe von Zugangsdaten notwendig ist, um auf die
Monitoring-Daten eines anderen Systems zuzugreifen, also zum Beispiel
bei der Konfiguration von [aktiven Checks,](glossar.html#active_check)
[Spezialagenten,](glossar.html#special_agent) Regeln für die
[Agentenbäckerei](glossar.html#agent_bakery) oder von
Benachrichtigungsmethoden in
[Benachrichtigungsregeln.](notifications.html#rules)
:::

::: paragraph
In diesem Artikel zeigen wir die Verwendung des Passwortspeichers am
Beispiel des Zugriffs auf einen MQTT-Server --- oder *Broker,* wie er in
der [MQTT](https://mqtt.org/){target="_blank"}-Architektur genannt wird.
Solch ein Broker sammelt Sensordaten im „Internet der Dinge" (Internet
of Things, IoT). In Checkmk kann dieser Broker überwacht werden, um zum
Beispiel festzustellen, wie viele Meldungen in der Warteschlange
vorhanden sind.
:::
:::::::::
::::::::::

:::::::::::::::: sect1
## []{#pwd_create .hidden-anchor .sr-only}2. Passwort erstellen {#heading_pwd_create}

::::::::::::::: sectionbody
::: paragraph
Den Checkmk-Passwortspeicher erreichen Sie über [Setup \> General \>
Passwords]{.guihint}. Um ein neues Passwort zu erstellen, klicken Sie
auf [Add password.]{.guihint}
:::

::::: imageblock
::: content
![Dialog zum Erstellen eines Passworts im
Passwortspeicher.](../images/password_store_add_password.png)
:::

::: title
Hier wird ein Passwort für einen MQTT-Broker erstellt
:::
:::::

::: paragraph
Wie üblich in Checkmk, verlangt auch die Erstellung eines Passworts im
Passwortspeicher eine interne [Unique ID]{.guihint} und einen
[Title]{.guihint}. Wählen Sie den Titel so sprechend, dass nicht nur Sie
später noch wissen, um was es geht, sondern auch diejenigen
Checkmk-Benutzer, die das Passwort nutzen werden --- denn nur dieser
Titel wird bei der [Auswahl eines Passworts](#pwd_select) angezeigt.
:::

::: paragraph
Im Kasten [Password properties]{.guihint} geben Sie dann zuerst das
Passwort ein. Mit den beiden folgenden Optionen [Editable by]{.guihint}
und [Share with]{.guihint} steuern Sie, wer auf dieses Passwort Zugriff
hat.
:::

::: paragraph
Mit [Editable by]{.guihint} wählen Sie eine Gruppe von Checkmk-Benutzern
aus, die vollen Zugriff auf das Passwort hat --- um es zu nutzen, zu
ändern und zu löschen. Die Standardauswahl hier ist
[Administrators]{.guihint} und schränkt den Zugriff auf
Checkmk-Administratoren ein, da nur die Rolle `admin` standardmäßig die
Berechtigung [Write access to all passwords]{.guihint} hat. Sie können
den vollen Zugriff aber auch einer Ihnen bereits zugewiesenen
Kontaktgruppe gewähren. Mit der Option [Share with]{.guihint} können Sie
Kontaktgruppen hinzufügen, denen das Passwort *zusätzlich zur Nutzung*
zur Verfügung gestellt werden soll.
:::

::: paragraph
Nachdem Sie die Erstellung mit [Save]{.guihint} abgeschlossen haben,
sehen Sie die Übersichtsseite zum Passwortspeicher, die alle Passwörter
mit den wichtigsten Parametern auflistet:
:::

::::: imageblock
::: content
![Die Übersichtsseite des
Passwortspeichers.](../images/password_store_password_store.png)
:::

::: title
Vor der Passwortliste steht, was der Passwortspeicher kann --- und was
nicht
:::
:::::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Der Zugang zum Passwortspeicher   |
|                                   | ist standardmäßig nicht nur für   |
|                                   | Administratoren, sondern auch für |
|                                   | normale Monitoring-Benutzer       |
|                                   | geöffnet, da die beiden Rollen    |
|                                   | `admin` und `user` die            |
|                                   | Berechtigung [Password            |
|                                   | management]{.guihint} besitzen.   |
|                                   | Allerdings sehen normale          |
|                                   | Monitoring-Benutzer nur die       |
|                                   | Passwörter, für die sie vollen    |
|                                   | Zugriff haben und können ein      |
|                                   | Passwort nur Kontaktgruppen       |
|                                   | zuweisen (und nicht etwa          |
|                                   | Checkmk-Administratoren).         |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::::
::::::::::::::::

:::::::::: sect1
## []{#pwd_select .hidden-anchor .sr-only}3. Passwort auswählen {#heading_pwd_select}

::::::::: sectionbody
::: paragraph
Ein Passwort aus dem Passwortspeicher auswählen können Sie auf sehr
vielen Seiten in Checkmk. So finden Sie beispielsweise die aktiven
Checks in [Setup \> Services \> HTTP, TCP, Email, ...​]{.guihint} und die
Spezialagenten in [Setup \> Agents \> VM, cloud, container]{.guihint}
oder [Setup \> Agents \> Other integrations.]{.guihint}
:::

::: paragraph
Der Regelsatz für den MQTT-Spezialagenten heißt [MQTT broker
statistics.]{.guihint} Erstellen Sie eine neue Regel:
:::

::::: imageblock
::: content
![Regel, in der ein Passwort aus dem Passwortspeicher ausgewählt werden
kann.](../images/password_store_select_password.png)
:::

::: title
Hier wird das Passwort für den MQTT-Broker verwendet
:::
:::::

::: paragraph
Aktivieren Sie [Username]{.guihint} und geben Sie den Benutzernamen des
MQTT-Brokers ein. Aktivieren Sie dann [Password of the user.]{.guihint}
Standardmäßig ist dort [Explicit]{.guihint} ausgewählt zur direkten
Eingabe des Passworts in das zugehörige Feld. Immer dann, wenn Ihnen bei
der Eingabe von Zugangsdaten eine Liste angeboten wird, können Sie statt
der expliziten Eingabe auch den Passwortspeicher nutzen. Wählen Sie dazu
in der Liste [From password store]{.guihint} aus. Dann wird rechts eine
Liste eingeblendet, die alle Passwörter enthält, die Sie nutzen können.
:::
:::::::::
::::::::::

:::: sect1
## []{#files .hidden-anchor .sr-only}4. Dateien und Verzeichnisse {#heading_files}

::: sectionbody
+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/v                          | Die Datei des Passwortspeichers mit  |
| ar/check_mk/stored_passwords` | den verschleierten Passwörtern.      |
+-------------------------------+--------------------------------------+
| `~/etc/password_store.secret` | Die Datei mit dem Schlüssel zur      |
|                               | Verschleierung der Passwortdatei.    |
+-------------------------------+--------------------------------------+
| `~/lib/python3/cmk/util       | Das Checkmk Python-Modul für den     |
| s/password_store/__init__.py` | Passwortspeicher. In Kommentarzeilen |
|                               | am Anfang dieser Datei finden Sie    |
|                               | Hinweise darauf, wie Sie den         |
|                               | Passwortspeicher in selbst           |
|                               | geschriebenen aktiven Checks oder    |
|                               | Spezialagenten nutzen können.        |
+-------------------------------+--------------------------------------+
:::
::::
:::::::::::::::::::::::::::::::::::::::::
