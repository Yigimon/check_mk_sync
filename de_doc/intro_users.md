:::: {#header}
# Mit mehreren Benutzern arbeiten

::: details
[Last modified on 15-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_users.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Benachrichtigungen einschalten](intro_notifications.html) [Benutzer,
Zuständigkeiten, Berechtigungen](wato_user.html)
:::
::::
:::::
::::::
::::::::

:::::::: sect1
## []{#users_cmk .hidden-anchor .sr-only}1. Benutzer in Checkmk {#heading_users_cmk}

::::::: sectionbody
::: paragraph
Sobald Sie Ihr Monitoring in einem Zustand haben, wo es beginnt, für
andere nützlich zu werden, ist es an der Zeit, sich mit der
Benutzerverwaltung von Checkmk zu befassen. Falls Sie das System
lediglich alleine betreiben, ist das Arbeiten als Benutzer `cmkadmin`
völlig ausreichend, und Sie können einfach beim [nächsten Kapitel über
Benachrichtigungen](intro_notifications.html) weiterlesen.
:::

::: paragraph
Gehen wir also davon aus, dass Sie Kollegen haben, die gemeinsam mit
Ihnen Checkmk nutzen sollen. Warum arbeiten dann nicht einfach alle als
`cmkadmin`? Nun, theoretisch geht das schon, aber es entsteht dabei eine
Reihe von Schwierigkeiten. Wenn Sie pro Person ein Konto (*account*)
anlegen, haben Sie etliche Vorteile:
:::

::: ulist
- Unterschiedliche Benutzer können unterschiedliche **Berechtigungen**
  haben.

- Sie können die **Zuständigkeit** eines Benutzers auf bestimmte Hosts
  und Services beschränken, sodass nur noch diese im Monitoring sichtbar
  sind.

- Benutzer können eigene [Lesezeichen](intro_tools.html#bookmarks)
  (*bookmarks*) anlegen, ihre [Seitenleiste](intro_gui.html#sidebar)
  individuell einrichten und auch andere Dinge für sich anpassen.

- Sie können ein Konto löschen, wenn ein Mitarbeiter die Firma verlässt,
  ohne dass das die anderen Konten beeinflusst.
:::

::: paragraph
Sie finden im [Artikel über die Benutzerverwaltung](wato_user.html) alle
Details, die über die Einführung in diesem Leitfaden für Einsteiger
hinausgehen.
:::
:::::::
::::::::

::::::: sect1
## []{#roles .hidden-anchor .sr-only}2. Rollen für Berechtigungen {#heading_roles}

:::::: sectionbody
::: paragraph
Vor allem auf die beiden Punkte zu Berechtigungen und Zuständigkeiten
wollen wir näher eingehen. Beginnen wir mit den Berechtigungen --- also
mit der Frage, wer was tun darf. Dafür verwendet Checkmk das Konzept der
**Rollen**. Eine Rolle ist dabei nichts anderes als eine Sammlung von
Berechtigungen. Jede der Berechtigungen erlaubt eine ganz bestimmte
Handlung. So gibt es etwa eine Berechtigung für das Ändern der globalen
Einstellungen.
:::

::: paragraph
Checkmk wird mit vier vordefinierten Rollen ausgeliefert, die Sie einem
neuen Benutzer zuweisen:
:::

+-----------------+---------+------------------------------------------+
| Rolle           | Kürzel  | Bedeutung                                |
+=================+=========+==========================================+
| Administrator   | `admin` | Ein Administrator kann alle Funktionen   |
|                 |         | in Checkmk ausführen. Seine Hauptaufgabe |
|                 |         | ist die generelle Konfiguration von      |
|                 |         | Checkmk, **nicht** das Monitoring. Dies  |
|                 |         | schließt auch das Anlegen von Benutzern  |
|                 |         | und Anpassen von Rollen ein.             |
+-----------------+---------+------------------------------------------+
| Normal          | `user`  | Diese Rolle ist für den **Operator**     |
| monitoring user |         | gedacht, der das Monitoring durchführt.  |
|                 |         | Der Operator sollte grundsätzlich nur    |
|                 |         | solche Hosts und Services sehen, für die |
|                 |         | er zuständig ist. Zudem besteht die      |
|                 |         | Möglichkeit, dass Sie als Administrator  |
|                 |         | ihm die Berechtigung geben, seine Hosts  |
|                 |         | selbst zu verwalten.                     |
+-----------------+---------+------------------------------------------+
| Agent           | `agent  | Spezielle Rolle für einen                |
| registration    | _regist | [Automations                             |
| user            | ration` | benutzer,](glossar.html#automation_user) |
|                 |         | um eine Registrierung des                |
|                 |         | Checkmk-[Agenten](glossar.html#agent)    |
|                 |         | eines Hosts beim Checkmk-Server mit      |
|                 |         | minimalen Rechten durchzuführen.         |
+-----------------+---------+------------------------------------------+
| Guest user      | `guest` | Ein Gastbenutzer darf alles sehen, aber  |
|                 |         | nichts ändern. Diese Rolle ist z.B.      |
|                 |         | nützlich, wenn Sie einen Statusmonitor   |
|                 |         | an die Wand hängen möchten, der immer    |
|                 |         | eine Gesamtübersicht des Monitorings     |
|                 |         | zeigt. Da ein Gastbenutzer nichts ändern |
|                 |         | kann, ist es auch möglich, dass mehrere  |
|                 |         | Kollegen ein Konto mit dieser Rolle      |
|                 |         | gleichzeitig verwenden.                  |
+-----------------+---------+------------------------------------------+

::: paragraph
Wie Sie die vordefinierten Rollen anpassen können, erfahren Sie im
[Artikel über die Benutzerverwaltung](wato_user.html#roles).
:::
::::::
:::::::

:::::::::::::: sect1
## []{#contact_groups .hidden-anchor .sr-only}3. Kontaktgruppen für Zuständigkeiten {#heading_contact_groups}

::::::::::::: sectionbody
::: paragraph
Der zweite wichtige Aspekt der Benutzerverwaltung ist die Festlegung von
Zuständigkeiten: Wer ist für den Host `mysrv024` zuständig und wer für
den Service `Tablespace FOO` auf dem Host `ora012`? Wer soll den Host
und Service im Monitoring sehen und eventuell benachrichtigt werden,
wenn es ein Problem gibt?
:::

::: paragraph
Zuständigkeiten werden in Checkmk nicht über Rollen, sondern über
**Kontaktgruppen** definiert. Das Wort „Kontakt" ist im Sinne einer
Benachrichtigung gemeint: Wen soll das Monitoring kontaktieren, wenn es
ein Problem gibt?
:::

::: paragraph
Das Grundprinzip ist wie folgt:
:::

::: ulist
- Jeder Benutzer kann Mitglied von beliebig vielen Kontaktgruppen sein.

- Jeder Host und jeder Service ist Mitglied von mindestens einer oder
  mehreren Kontaktgruppen.
:::

::: paragraph
Hier ist ein Beispiel für so eine Zuordnung von Benutzern (links) und
Hosts (rechts) zu Kontaktgruppen (Mitte):
:::

:::: imageblock
::: content
![Illustration der Beziehung zwischen Benutzern, Kontaktgruppen und
Hosts/Services.](../images/intro_contactgroup_example.png){width="50%"}
:::
::::

::: paragraph
Wie Sie sehen, kann sowohl ein Benutzer als auch ein Host (oder Service)
Mitglied mehrerer Kontaktgruppen sein. Die Mitgliedschaft in den Gruppen
hat folgende Auswirkungen:
:::

::: ulist
- Ein Benutzer der Rolle `user` sieht im Monitoring genau die Objekte,
  die sich in seinen Kontaktgruppen befinden.

- Gibt es ein Problem mit einem Host oder Service, werden
  (standardmäßig) alle Benutzer benachrichtigt, die in mindestens einer
  seiner Kontaktgruppen sind.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Es gibt in Checkmk keine          |
|                                   | Möglichkeit, einen Host oder      |
|                                   | Service direkt einem Benutzer     |
|                                   | zuzuordnen. Das ist absichtlich   |
|                                   | nicht gewollt, da es in der       |
|                                   | Praxis zu Problemen               |
|                                   | führt --- z.B. dann, wenn ein     |
|                                   | Kollege Ihr Unternehmen verlässt. |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::::::
::::::::::::::

::::::::: sect1
## []{#create_contact_groups .hidden-anchor .sr-only}4. Kontaktgruppen erstellen {#heading_create_contact_groups}

:::::::: sectionbody
::: paragraph
Zur Verwaltung der Kontaktgruppen geht es hier entlang: [Setup \> Users
\> Contact groups.]{.guihint} Eine Kontaktgruppe mit dem Namen
[all]{.guihint} und dem Alias [Everything]{.guihint} ist bereits
vordefiniert. Dieser sind automatisch alle Hosts und Services
zugewiesen. Sie ist für einfache Setups gedacht, in denen es (noch)
keine Aufgabenteilung gibt und Sie vorerst für alles alleine zuständig
sind.
:::

::: paragraph
Mit [Add group]{.guihint} legen Sie eine neue Kontaktgruppe an. Hier
brauchen Sie, wie gewohnt, die interne ID ([Name]{.guihint}) und den
Titel ([Alias]{.guihint}), den Sie später ändern können:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Eigenschaften für die neue
Kontaktgruppe.](../images/intro_add_contact_group_properties.png)
:::
::::

::: paragraph
Im Beispiel sehen Sie eine neue Kontaktgruppe, die offensichtlich für
die Windows- und Linux-Server zuständig sein soll.
:::
::::::::
:::::::::

:::::::::::::::::::: sect1
## []{#assign_hosts .hidden-anchor .sr-only}5. Hosts zuordnen {#heading_assign_hosts}

::::::::::::::::::: sectionbody
::: paragraph
Nachdem Sie alle Ihre Kontaktgruppen angelegt haben, müssen Sie
einerseits Hosts und Services zuordnen und andererseits die Benutzer.
Letzteres machen Sie in den Eigenschaften der Benutzer selbst: wir
kommen in einem [späteren Kapitel](#create_users) noch dazu.
:::

::: paragraph
Für die Zuordnung von Hosts zu Kontaktgruppen gibt es zwei Wege, die Sie
auch parallel wählen können: über Regeln oder über die Eigenschaften der
Hosts (oder ihrer Ordner).
:::

::::::::: sect2
### []{#_mit_regeln_zuordnen .hidden-anchor .sr-only}5.1. Mit Regeln zuordnen {#heading__mit_regeln_zuordnen}

::: paragraph
Der benötigte Regelsatz heißt [Assignment of hosts to contact
groups.]{.guihint} Sie finden ihn z.B. auf der Seite [Contact
groups]{.guihint}, die Sie im vorherigen Kapitel geöffnet hatten, im
Menü [Contact groups \> Rules]{.guihint}.
:::

::: paragraph
Auch bei einer frischen Checkmk-Installation ist der Regelsatz übrigens
nicht leer. Sie finden hier eine Regel, die alle Hosts der oben
erwähnten Kontaktgruppe [Everything]{.guihint} zuweist.
:::

::: paragraph
Legen Sie hier selbst neue Regeln an und wählen Sie die jeweilige
Kontaktgruppe, die Sie den in der Bedingung ausgewählten Hosts zuweisen
wollen:
:::

:::: imageblock
::: content
![Dialog zur Zuweisung von Kontaktgruppen zu Hosts in einer
Regel.](../images/intro_rule_assignment_hosts_contact_groups.png)
:::
::::

::: paragraph
**Wichtig:** Greifen für einen Host mehrere Regeln, so werden alle
ausgewertet und der Host bekommt auf diese Art mehrere Kontaktgruppen.
:::
:::::::::

::::::::: sect2
### []{#_mit_host_eigenschaften_zuordnen .hidden-anchor .sr-only}5.2. Mit Host-Eigenschaften zuordnen {#heading__mit_host_eigenschaften_zuordnen}

::: paragraph
Öffnen Sie die Eigenschaften des Hosts, z.B. über [Setup \> Hosts \>
Hosts.]{.guihint} Klicken Sie den Host an, um die Seite [Properties of
host]{.guihint} anzuzeigen. Aktivieren Sie im Kasten [Basic
settings]{.guihint} die Checkbox [Permissions]{.guihint}.
:::

:::: imageblock
::: content
![Dialog zur Zuweisung von Kontaktgruppen zu Hosts in den
Host-Eigenschaften.](../images/intro_host_properties_permissions.png)
:::
::::

::: paragraph
Wählen Sie in der Liste [Available]{.guihint} eine oder mehrere
Kontaktgruppen aus und verschieben Sie diese mit dem Pfeil nach rechts
in die Liste [Selected.]{.guihint} Aktivieren Sie die Checkbox [Add
these contact groups to the host]{.guihint}.
:::

::: paragraph
Die Checkbox [Always add host contact groups also to its
services]{.guihint} müssen Sie in der Regel nicht auswählen, denn
Services erben automatisch die Kontaktgruppen ihrer Hosts. Mehr dazu
erfahren Sie gleich im nächsten Kapitel.
:::

::: paragraph
**Hinweis:** Sie können das Attribut [Permissions]{.guihint} analog
statt auf Host- auch auf Ordnerebene festlegen. Für einen Ordner werden
einige zusätzliche Optionen angeboten, bei denen es darum geht, ob die
Rechte auch für Unterordner gelten sollen.
:::
:::::::::
:::::::::::::::::::
::::::::::::::::::::

:::::::: sect1
## []{#assign_services .hidden-anchor .sr-only}6. Services zuordnen {#heading_assign_services}

::::::: sectionbody
::: paragraph
Services müssen Sie nur dann Kontaktgruppen zuordnen, wenn diese von
denen ihrer Hosts abweichen sollen. Dabei gilt allerdings ein wichtiger
Grundsatz: Hat ein Service mindestens eine Kontaktgruppe explizit
zugewiesen erhalten, dann erbt er keine Kontaktgruppen vom Host mehr.
:::

::: paragraph
Die Zuordnung auf Service-Ebene ermöglicht Ihnen z.B. eine Trennung von
Server- und Anwendungsbetrieb: Stecken Sie z.B. den Host `srvwin123` in
die Kontaktgruppe `Windows & Linux Servers`, aber alle Services, die mit
dem Präfix `Oracle` beginnen, in die Kontaktgruppe
`Oracle Administration`, so werden die Windows-Administratoren die
Oracle-Services nicht sehen, und die Oracle-Administratoren erhalten
umgekehrt keine Details zu den Services des Betriebssystems --- was oft
eine sehr sinnvolle Aufteilung ist.
:::

::: paragraph
Sollten Sie diese Trennung nicht benötigen, dann beschränken Sie sich
einfach auf die Zuordnungen für Hosts --- und sind fertig.
:::

::: paragraph
Für die Zuordnung auf Service-Ebene ist der Regelsatz [Assignment of
services to contact groups]{.guihint} zuständig. Bei der Erstellung der
Regel gehen Sie analog vor, wie es im vorherigen Kapitel für die
Host-Zuordnung beschrieben ist. Zusätzlich geben Sie noch Bedingungen
für die Service-Namen an.
:::
:::::::
::::::::

::::::::::::::::::::::: sect1
## []{#create_users .hidden-anchor .sr-only}7. Benutzer anlegen {#heading_create_users}

:::::::::::::::::::::: sectionbody
::: paragraph
In die Benutzerverwaltung steigen Sie ein mit [Setup \> Users \>
Users]{.guihint}:
:::

:::: imageblock
::: content
![Liste der Checkmk-Benutzer.](../images/intro_setup_users.png)
:::
::::

::: paragraph
Wundern Sie sich nicht, wenn es dort außer dem Eintrag `cmkadmin` auch
noch zwei weitere Benutzer `automation` und `agent_registration` gibt.
Diese [Automationsbenutzer](glossar.html#automation_user) sind für
Zugriffe von außen gedacht, z.B. per Skript oder
[REST-API.](rest_api.html)
:::

::: paragraph
Einen neuen Benutzer legen Sie mit dem Knopf [Add user]{.guihint} auf
der Seite gleichen Namens an:
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Identität für den neuen
Benutzer.](../images/intro_new_user_identity.png)
:::
::::

::: paragraph
Im Kasten [Identity]{.guihint} geben Sie die interne ID
([Username]{.guihint}) und einen Titel ([Full name]{.guihint})
ein --- hier den ausgeschriebenen Namen des Benutzers. Die Felder [Email
address]{.guihint} und [Pager address]{.guihint} sind optional und
dienen den Benachrichtigungen via E-Mail bzw. SMS.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Tragen Sie hier vorerst noch      |
|                                   | keine E-Mail-Adresse ein. Lesen   |
|                                   | Sie zunächst die Hinweise im      |
|                                   | [Kapitel über                     |
|                                   | Benachrichtig                     |
|                                   | ungen](intro_notifications.html). |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Sicherheitseinstellungen für den neuen
Benutzer.](../images/intro_new_user_security.png)
:::
::::

::: paragraph
Im Kasten [Security]{.guihint} lassen Sie die Standardeinstellung auf
[Normal user login with password]{.guihint} und vergeben nur ein
initiales Passwort. Standardmäßig muss ein Passwort für ein lokales
Benutzerkonto mindestens 12 Zeichen lang sein. Dies legt die globale
Einstellung [Global settings \> User management \> Password policy for
local accounts]{.guihint} fest.
:::

::: paragraph
Ganz unten bei [Roles]{.guihint} können Sie dem Benutzer die Rollen
zuordnen. Ordnen Sie mehr als eine Rolle zu, so erhält der Benutzer
einfach das Maximum an Berechtigungen aus diesen Rollen. Für die vier
vordefinierten Rollen ist das allerdings nicht sehr sinnvoll.
:::

:::: imageblock
::: content
![Dialog zur Auswahl der Kontaktgruppen für den neuen
Benutzer.](../images/intro_new_user_contact_groups.png)
:::
::::

::: paragraph
Unter [Contact Groups]{.guihint} können Sie jetzt aus den zuvor
erstellten Kontaktgruppen auswählen. Wählen Sie die vordefinierte Gruppe
[Everything]{.guihint} aus, so wird der Benutzer für alles zuständig
sein, da in dieser Gruppe alle Hosts und Services enthalten sind.
:::

::: paragraph
Übrigens: Die beiden letzten Kästen [Personal settings]{.guihint} und
[Interface settings]{.guihint} der Seite enthalten genau die
Einstellungen, die ein Benutzer auch selbst in seinem Profil ändern kann
über das Menü [User \> Edit profile]{.guihint}. Nur Gastbenutzer (mit
der Rolle [Guest user]{.guihint}) können diese Einstellungen ihres
Profils nicht ändern.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Auf der Übersichtsseite der       |
|                                   | Benutzerverwaltung                |
|                                   | [Users]{.guihint} finden Sie im   |
|                                   | Menü [Related]{.guihint} den      |
|                                   | Eintrag [LDAP & Active            |
|                                   | Directory.]{.guihint} Wenn Sie in |
|                                   | Ihrer Firma Active Directory oder |
|                                   | einen anderen LDAP-Dienst         |
|                                   | einsetzen, haben Sie auch die     |
|                                   | Möglichkeit, Benutzer und Gruppen |
|                                   | aus diesen Diensten einzubinden.  |
|                                   | Die Details dazu finden Sie im    |
|                                   | [Artikel über LDAP/Active         |
|                                   | Directory](ldap.html).            |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
[Weiter geht es mit den Benachrichtigungen](intro_notifications.html)
:::
::::::::::::::::::::::
:::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
