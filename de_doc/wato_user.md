:::: {#header}
# Benutzer, Zuständigkeiten, Berechtigungen

::: details
[Last modified on 19-Mar-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/wato_user.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Die Konfiguration von Checkmk](wato.html) [Regeln](wato_rules.html)
[Benutzerverwaltung mit LDAP/Active Directory](ldap.html)
:::
::::
:::::
::::::
::::::::

:::::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

::::::::::: sectionbody
::: paragraph
In diesem Artikel zeigen wir Ihnen alles rund um Benutzerverwaltung und
Berechtigungen in Checkmk. Doch bevor wir in die Details gehen können,
müssen wir erst einige Begriffe klären.
:::

::: paragraph
Ein **Benutzer** (*user*) ist in Checkmk jemand, der Zugang zur
[Benutzeroberfläche](user_interface.html) hat. Er hat eine oder mehrere
**Rollen.** Aus den Rollen ergeben sich **Berechtigungen**
(*permissions*).
:::

::: paragraph
Sobald ein Benutzer für bestimmte Hosts und Services zuständig ist, wird
er als **Kontakt** bezeichnet. Ein Kontakt sieht normalerweise nur seine
eigenen Hosts und Services in der
[Monitoring-Umgebung](user_interface.html) und wird eventuell über
Probleme benachrichtigt.
:::

::: paragraph
Es gibt auch Benutzer, die keine Kontakte sind. Ein Beispiel dafür ist
`cmkadmin`, der beim Erzeugen einer Instanz automatisch angelegt wird.
Dieser darf zwar alle Hosts und Services sehen, aber nur, weil in seiner
Rolle `admin` die Berechtigung [See all hosts and services]{.guihint}
enthalten ist und nicht, weil er für alles ein Kontakt wäre.
:::

::: paragraph
Wenn ein Kontakt nur zum Zwecke der
[Benachrichtigung](notifications.html) angelegt wurde (z.B. zur
Weiterleitung von Benachrichtigungen an ein Ticketsystem), dann kann es
sinnvoll sein, ihn so anzulegen, dass kein Login in die Oberfläche
möglich ist.
:::

::: paragraph
Ein Kontakt ist immer Mitglied von einer oder mehreren
**Kontaktgruppen.** Der Zweck dieser Gruppen ist die Zuordnung von
Kontakten zu Hosts und Services. Zum Beispiel könnte der Kontakt
`hhirsch` in der Kontaktgruppe `linux` sein und diese wiederum per
[Regel](wato_rules.html) allen Linux-Hosts zugeordnet. Eine direkte
Zuordnung von Kontakten zu Hosts oder Services ist nicht möglich und
würde in der Praxis auch Schwierigkeiten bereiten (z.B. beim Ausscheiden
eines Benutzers).
:::

::: paragraph
Noch einmal zusammengefasst:
:::

::: ulist
- **Benutzer** können die Benutzeroberfläche verwenden.

- **Kontakte** sind Benutzer, die für bestimmte Hosts und Services
  zuständig sind.

- **Kontaktgruppen** legen fest, für was jemand zuständig ist.

- **Rollen** legen fest, welche **Berechtigungen** jemand hat.
:::
:::::::::::
::::::::::::

::::::::::::::::::::::::::::::::::::::: sect1
## []{#user_config .hidden-anchor .sr-only}2. Benutzerverwaltung über die Konfigurationsumgebung {#heading_user_config}

:::::::::::::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#_übersicht .hidden-anchor .sr-only}2.1. Übersicht {#heading__übersicht}

::: paragraph
Die Benutzerverwaltung finden Sie unter [Setup \> Users \>
Users]{.guihint}. In einer frisch angelegten Instanz sieht diese Seite
so aus (im Bild nur um einige Tabellenspalten gekürzt):
:::

:::: imageblock
::: content
![Liste der Benutzer mit Eigenschaften des
Administrators.](../images/wato_user_users.png)
:::
::::

::: paragraph
Das obige Bild zeigt alle Benutzer, welche automatisch beim Erzeugen der
Instanz angelegt wurden. Das sind zuerst zwei
[Automationsbenutzer](glossar.html#automation_user), gefolgt von dem
einzigen Benutzer (`cmkadmin`) für die interaktive Anmeldung mit
Passwort. Bei der Checkmk-Appliance kann dieser Benutzer anders heißen,
da Sie dessen Namen und Passwort selbst festlegen. Dieser Benutzer
`cmkadmin` hat folgende Eigenschaften:
:::

::: ulist
- Er hat die Rolle [Administrator]{.guihint} (`admin`) und damit alle
  Berechtigungen.

- Er ist für nichts Kontakt und bekommt keine Benachrichtigungen.

- Er darf trotzdem alles sehen (wegen seiner Rolle `admin`).

- Das Passwort, das beim Erstellen der Instanz vergeben wurde, sollten
  Sie auf jeden Fall ändern!
:::

::: paragraph
Das Formular zum Anlegen eines neuen Benutzers mit [![button new
user](../images/icons/button_new_user.png)]{.image-inline} oder zum
Editieren eines bestehenden Benutzers mit [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} ist in fünf
Abschnitte unterteilt. Im ersten geht es um die Identität:
:::
:::::::::

:::::::: sect2
### []{#_identität .hidden-anchor .sr-only}2.2. Identität {#heading__identität}

:::: imageblock
::: content
![Dialog für die Identität eines
Benutzers.](../images/wato_user_identity.png)
:::
::::

::: paragraph
Wie immer in Checkmk ist die ID eines Datensatzes (hier
[Username]{.guihint}) später nicht änderbar. Sie wird für die Anmeldung
verwendet und auch als interner Schlüssel in sämtlichen Dateien und
Datenstrukturen.
:::

::: paragraph
Die E-Mail-Adresse ist optional und nur dann notwendig, wenn der
Benutzer ein Kontakt werden soll, der per E-Mail
[benachrichtigt](notifications.html) werden soll
([SMTP-Konfiguration](notifications.html#smtp) notwendig). Analog ist
das Feld [Pager address]{.guihint} für die Benachrichtigung per SMS oder
ähnliche Systeme vorgesehen. Wenn Sie eigene Benachrichtigungsskripte
schreiben, können Sie auf die Werte in den Feldern zugreifen und sie für
beliebige Zwecke verwenden.
:::

::: paragraph
Über [Authorized sites]{.guihint} dürfen Sie optional beschränken, auf
welche der vorhandenen Instanzen zugegriffen werden darf. Praktisch ist
das vor allem bei sehr großen Umgebungen, etwa einem verteilten
Monitoring mit Hunderten von Instanzen: Sofern ein Benutzer nur einen
Teil dieser Instanzen für seine Hosts benötigt, wird die GUI auch nur
die autorisierten Instanzen kontaktieren, um Ansichten
aufzubauen --- was wiederum der Performance enorm zugutekommt.
:::
::::::::

:::::::: sect2
### []{#_sicherheit .hidden-anchor .sr-only}2.3. Sicherheit {#heading__sicherheit}

:::: imageblock
::: content
![Dialog für Sicherheitseinstellungen eines
Benutzers.](../images/wato_user_security.png)
:::
::::

::: paragraph
Der zweite Kasten dient der Anmeldung und Berechtigung. Die Option
[Automation secret for machine accounts]{.guihint} ist für Konten
gedacht, die skriptgesteuert per HTTP auf Checkmk zugreifen und sich
über die URL authentifizieren. Wie das geht, zeigen wir Ihnen [weiter
unten](#automation).
:::

::: paragraph
Bei den Rollen müssen Sie mindestens eine auswählen. Theoretisch können
Sie einem Benutzer auch mehrere Rollen geben. Er bekommt dann die Rechte
von allen diesen Rollen. Mit den vordefinierten Rollen (siehe [weiter
unten](#roles)) macht dies jedoch wenig Sinn.
:::

::: paragraph
Wenn Sie einen Benutzer mit der Option [disable the login to this
account]{.guihint} **sperren,** wird er in der Tabelle mit dem Symbol
[![icon user
locked](../images/icons/icon_user_locked.png)]{.image-inline}
dargestellt. Er kann sich dann nicht mehr anmelden, bleibt aber trotzdem
im System erhalten. Falls er ein Kontakt ist, sind auch die
Benachrichtigungen von der Sperre nicht beeinflusst und er wird
weiterhin E-Mails etc. erhalten. War der Benutzer zum Zeitpunkt der
Sperrung gerade angemeldet, so wird er automatisch abgemeldet.
:::
::::::::

:::::: sect2
### []{#_kontaktgruppen .hidden-anchor .sr-only}2.4. Kontaktgruppen {#heading__kontaktgruppen}

:::: imageblock
::: content
![Dialog für Kontaktgruppen eines
Benutzers.](../images/wato_user_contact_groups.png)
:::
::::

::: paragraph
Sobald Sie einen Benutzer einer Kontaktgruppe oder mehreren zuordnen,
wird dieser Benutzer zum Kontakt. Bei einer neuen Instanz wird
automatisch die Kontaktgruppe [Everything]{.guihint} angelegt, die immer
alle Hosts und alle Services enthält. Ein Benutzer in dieser Gruppe ist
automatisch für *alle* Hosts und Services zuständig.
:::
::::::

:::::: sect2
### []{#user_config_notifications .hidden-anchor .sr-only}2.5. Benachrichtigungen {#heading_user_config_notifications}

:::: imageblock
::: content
![Dialog für Benachrichtigungseinstellungen eines
Benutzers.](../images/wato_user_notifications_fallback.png)
:::
::::

::: paragraph
Im Kasten [Notifications]{.guihint} können Sie über die Option [Receive
fallback notifications]{.guihint} festlegen, dass dieser Kontakt
Benachrichtigungen bekommt, wenn [keine Benachrichtigungsregel
greift.](notifications.html#fallback)
:::
::::::

:::::: sect2
### []{#user_config_personal .hidden-anchor .sr-only}2.6. Persönliche Einstellungen {#heading_user_config_personal}

:::: imageblock
::: content
![Dialog für persönliche Einstellungen eines
Benutzers.](../images/wato_user_personal_settings.png)
:::
::::

::: paragraph
Alle Einstellungen in diesem Kasten kann der Benutzer über [User \> Edit
profile]{.guihint} auch [selbst ändern](#personal_settings) (außer in
der Rolle `guest`). Abgesehen von der Auswahl der Sprache der Oberfläche
handelt es sich um selten benötigte Einstellungen. Details dazu finden
Sie wie immer in der [Inline-Hilfe.](user_interface.html#inline_help)
:::
::::::

:::::: sect2
### []{#user_config_interface .hidden-anchor .sr-only}2.7. Oberflächeneinstellungen {#heading_user_config_interface}

:::: imageblock
::: content
![Dialog für Oberflächeneinstellungen eines
Benutzers.](../images/wato_user_interface_settings.png)
:::
::::

::: paragraph
Auch die Oberflächeneinstellungen können Benutzer selbst über [User \>
Edit profile]{.guihint} anpassen. Besonders interessant ist die Option
[Show more / Show less]{.guihint} zur Festlegung, ob Checkmk in der
Oberfläche [mehr oder weniger anzeigen](intro_gui.html#show_less_more)
soll. Wenn Sie immer alles sehen wollen, können Sie dies hier mit
[Enforce show more]{.guihint} erzwingen.
:::
::::::
::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#contact_groups .hidden-anchor .sr-only}3. Kontaktgruppen {#heading_contact_groups}

::::::::::::::::::::::::::::::::::::::::::::: sectionbody
:::::::::::::::::: sect2
### []{#_kontaktgruppen_anlegen_und_editieren .hidden-anchor .sr-only}3.1. Kontaktgruppen anlegen und editieren {#heading__kontaktgruppen_anlegen_und_editieren}

::: paragraph
Kontaktgruppen sind das Bindeglied zwischen Hosts und Services auf der
einen und Kontakten auf der anderen Seite. Jede Kontaktgruppe
repräsentiert eine Zuständigkeit für einen bestimmten Bereich in Ihrer
IT-Landschaft. So könnte z.B. die Kontaktgruppe `SAP` alle Personen
umfassen, die SAP-Systeme betreuen, und allen Hosts und Services
zugeordnet sein, die Dienste in diesem Umfeld bereitstellen.
:::

::: paragraph
Die Kontaktgruppen verwalten Sie über [Setup \> Users \> Contact
groups.]{.guihint} Folgende Abbildung zeigt dieses Modul mit vier
angelegten Kontaktgruppen:
:::

:::: imageblock
::: content
![Liste der
Kontaktgruppen.](../images/wato_user_contact_groups_list.png)
:::
::::

::: paragraph
Das Anlegen einer neuen Gruppe ist trivial. Wie immer ist die ID
unveränderlich und der Alias ein Anzeigename, den Sie später jederzeit
anpassen können:
:::

:::: imageblock
::: content
![Dialog für Name und Alias von
Kontaktgruppen.](../images/wato_user_contact_groups_new.png)
:::
::::

::: paragraph
Die neue Kontaktgruppe ist erst einmal leer in doppelter Hinsicht: Sie
enthält weder Kontakte noch Hosts oder Services. Die Zuordnung von
Kontaktgruppen zu Kontakten geschieht über die Benutzerprofile, wie Sie
schon beim Editieren des Benutzers gesehen haben.
:::

::::::::: sect3
#### []{#visibility .hidden-anchor .sr-only}Inventar-Sichtbarkeit festlegen {#heading_visibility}

::: paragraph
Zusätzlich können Sie die Sichtbarkeit des mit der
[Hardware-/Software-Inventur](inventory.html) gefundenen Inventars
festlegen. Standardmäßig ist das komplette Inventar sichtbar, es lässt
sich aber auch komplett unterdrücken oder gezielt freischalten mit der
Option [Allowed to see the following entries]{.guihint} und den
**internen Inventur-Pfaden**:
:::

:::: imageblock
::: content
![Dialog für die Sichtbarkeit von
Inventurdaten.](../images/wato_user_contact_groups_inventory_00.png)
:::
::::

::: paragraph
Um die geforderten Pfadinformationen eingeben zu können, müssen Sie
diese zuerst aus den [Inventurdaten
auslesen.](inventory.html#internal_paths) Mit diesen Informationen
können Sie dann die Pfade und Attribute befüllen und so beispielsweise
ausschließlich einige ausgewählte Inventurdaten zum Prozessor sichtbar
machen (Modell und Architektur):
:::

:::: imageblock
::: content
![Dialog für die Sichtbarkeit von Inventurdaten mit
CPU-Filter.](../images/wato_user_contact_groups_inventory_03.png)
:::
::::
:::::::::
::::::::::::::::::

:::::::::::::::::::: sect2
### []{#add_host_to_contact_group .hidden-anchor .sr-only}3.2. Hosts in eine Kontaktgruppe aufnehmen {#heading_add_host_to_contact_group}

::: paragraph
Zum Aufnehmen von Hosts in Kontaktgruppen gibt es zwei Methoden: über
[Ordner](hosts_setup.html#folder) und über [Regeln](wato_rules.html).
Sie können auch beide Methoden kombinieren. In diesem Fall bekommt der
Host dann die Summe der jeweiligen Kontaktgruppen zugeordnet.
:::

:::::::::: sect3
#### []{#_zuweisung_über_ordner .hidden-anchor .sr-only}Zuweisung über Ordner {#heading__zuweisung_über_ordner}

::: paragraph
Zu den Eigenschaften eines Ordners gelangen Sie über [Folder \>
Properties]{.guihint} während Sie im Ordner sind. Dort finden Sie die
Option [Permissions]{.guihint}. Aktivieren Sie diese Checkbox, um zur
Auswahl der Kontaktgruppen zu kommen:
:::

:::: imageblock
::: content
![Dialog zum Zuordnen von Kontaktgruppen zu
Ordnern.](../images/wato_user_contact_groups_folder.png)
:::
::::

::: paragraph
Der eigentliche Sinn dieser Option ist das Setzen von Berechtigungen für
das Pflegen von Hosts, was wir [weiter unten](#folder_permissions) im
Detail zeigen.
:::

::: paragraph
Sobald Sie Berechtigungen für bestimmte Kontaktgruppen vergeben, können
Sie diese Gruppen im gleichen Zug wiederum als Kontaktgruppen für die
Hosts im Monitoring eintragen lassen. Dabei können Sie entscheiden, ob
die Zuordnungen auch für Hosts in Unterordnern gelten sollen und, ob die
Services der Hosts ebenfalls *explizit* diese Gruppen bekommen sollen.
Services ohne explizite Zuweisung erben nämlich **alle** Kontaktgruppen
eines Hosts, auch solche, die durch Regeln zugewiesen wurden.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die                               |
|                                   | [Vererbu                          |
|                                   | ng](hosts_setup.html#inheritance) |
|                                   | des                               |
|                                   | [Permissions]{.guihint}-Attributs |
|                                   | über die Ordner ist an dieser     |
|                                   | Stelle außer Kraft gesetzt. Dies  |
|                                   | erlaubt Ihnen, in Unterordnern    |
|                                   | weitere Kontaktgruppen            |
|                                   | hinzuzufügen. Die Zuordnung       |
|                                   | geschieht also kumulativ auch     |
|                                   | über alle Elternordner, falls in  |
|                                   | diesen die Option [Add these      |
|                                   | groups as contacts in all         |
|                                   | subfolders]{.guihint} aktiviert   |
|                                   | ist.                              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Übrigens finden Sie die Kontaktgruppenoptionen in vereinfachter Form
auch direkt in den Details eines Hosts. Somit können Sie einzelnen Hosts
auch hierüber Kontaktgruppen zuordnen. Da das aber schnell recht
unübersichtlich werden kann, sollten Sie das nur in Ausnahmefällen tun
und bei Bedarf eventuell lieber mit Regeln arbeiten.
:::
::::::::::

:::::::::: sect3
#### []{#_zuweisung_über_regeln .hidden-anchor .sr-only}Zuweisung über Regeln {#heading__zuweisung_über_regeln}

::: paragraph
Die zweite Methode --- das Zuweisen von Kontaktgruppen über
[Regeln](wato_rules.html) --- ist etwas umständlicher, aber dafür
deutlich flexibler. Und es ist sehr nützlich, wenn Sie Ihre
Ordnerstruktur nicht nach organisatorischen Prinzipien aufgebaut haben
und daher die Ordner nicht eindeutig Kontaktgruppen zuordnen können.
:::

::: paragraph
Den dafür nötigen Regelsatz [Assignment of hosts to contact
groups]{.guihint} erreichen Sie über [Setup \> Hosts \> Host monitoring
rules.]{.guihint} In diesem Regelsatz finden Sie eine vordefinierte
Regel, die beim Erzeugen der Instanz angelegt wurde und welche alle
Hosts der Kontaktgruppe [Everything]{.guihint} zuweist.
:::

:::: imageblock
::: content
![Regelsatz für die Zuordnung von Hosts zu
Kontaktgruppen.](../images/wato_user_contact_groups_rules_list.png)
:::
::::

::: paragraph
Beachten Sie, dass dieser Regelsatz so definiert ist, dass **alle**
zutreffenden Regeln ausgewertet werden und nicht nur die erste! Es kann
nämlich durchaus nützlich sein, dass ein Host zu mehreren Kontaktgruppen
gehört. In diesem Fall benötigen Sie für jede Zuweisung eine eigene
Regel.
:::

:::: imageblock
::: content
![Dialog für die Zuordnung von Hosts zur Kontaktgruppe
Windows-Servers.](../images/wato_user_contact_groups_rules_new.png)
:::
::::
::::::::::
::::::::::::::::::::

:::::: sect2
### []{#add_service_to_contact_group .hidden-anchor .sr-only}3.3. Services in Kontaktgruppen aufnehmen {#heading_add_service_to_contact_group}

::: paragraph
Es ist nicht immer sinnvoll, dass ein Service in den gleichen
Kontaktgruppen ist wie sein Host. Daher können Sie über den Regelsatz
[Assignment of services to contact groups]{.guihint} Services zu
Kontaktgruppen zuordnen --- unabhängig von den Kontaktgruppen des Hosts.
Dabei gelten folgende Regeln:
:::

::: ulist
- Wenn einem Service **keine** Kontaktgruppe zugeordnet ist, erhält er
  automatisch die **gleichen Kontaktgruppen wie sein Host**.

- Sobald einem Service **mindestens eine** Kontaktgruppe explizit
  zugeordnet ist, erbt er die Kontaktgruppen vom Host **nicht** mehr.
:::

::: paragraph
In einer einfachen Umgebung genügt es also, wenn Sie nur den Hosts
Kontaktgruppen zuordnen. Sobald Sie mehr Differenzierung brauchen,
können Sie auch Regeln für die Services anlegen.
:::
::::::

:::::: sect2
### []{#_kontrolle_der_zuordnung .hidden-anchor .sr-only}3.4. Kontrolle der Zuordnung {#heading__kontrolle_der_zuordnung}

::: paragraph
Ob Sie alle Regeln und Ordner richtig konfiguriert haben, können Sie in
den Details eines Hosts oder Services in der Monitoring-Umgebung
überprüfen. Dort finden Sie die Einträge [Host contact groups]{.guihint}
und [Host contacts]{.guihint} (bzw. [Service contact groups]{.guihint}
und [Service contacts]{.guihint}), welche die letztendliche Zuordnung
für dieses Objekt auflisten:
:::

:::: imageblock
::: content
![Liste mit
Host-Details.](../images/wato_user_contact_groups_host_details.png)
:::
::::
::::::
:::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::: sect1
## []{#visibility_host .hidden-anchor .sr-only}4. Sichtbarkeit von Hosts und Services {#heading_visibility_host}

:::::::::::::::::::: sectionbody
:::::::: sect2
### []{#_übersicht_2 .hidden-anchor .sr-only}4.1. Übersicht {#heading__übersicht_2}

::: paragraph
Die Tatsache, dass ein normaler Benutzer (Rolle `user`) nur solche
Objekte sieht, für die er ein Kontakt ist, ist umso wichtiger, je größer
Ihre Monitoring-Umgebung ist. Das sorgt nicht nur für Übersicht, sondern
verhindert auch, dass Benutzer dort eingreifen, wo sie nichts zu suchen
haben.
:::

::: paragraph
Als Administrator (Rolle `admin`) dürfen Sie natürlich immer alles
sehen. Gesteuert wird das über die Berechtigung [See all host and
services.]{.guihint} In Ihren [persönlichen
Einstellungen](#personal_settings) finden Sie bei [Visibility of
hosts/services]{.guihint} die Checkbox [Only show hosts and services the
user is a contact for.]{.guihint} Mit dieser können Sie das „Alles
Sehen" freiwillig aufgeben und sich nur noch die Hosts und Services
anzeigen lassen, für die Sie ein Kontakt sind. Diese Option ist für
Doppelrollen gedacht --- also für jemanden, der gleichzeitig
Administrator und auch normaler Benutzer ist.
:::

::: paragraph
Die Rolle `guest` ist so voreingestellt, dass auch ihre Benutzer alles
sehen können. Ein Eingreifen oder persönliche Einstellungen sind hier
deaktiviert.
:::

::: paragraph
Für normale Benutzer ist die Sichtbarkeit in der
[Monitoring-Umgebung](user_interface.html) so umgesetzt, dass sich das
System so anfühlt, als wären die Hosts und Services, für die man nicht
Kontakt ist, überhaupt nicht vorhanden. Unter anderem berücksichtigen
folgende Elemente die Sichtbarkeit:
:::

::: ulist
- [Tabellenansichten](views.html) von Hosts und Services

- [Dashboards](dashboards.html)

- Das Snapin [Overview](user_interface.html#overview) der Seitenleiste

- [Berichte](reporting.html), die von dem Benutzer erstellt werden
:::
::::::::

::::::::: sect2
### []{#_sichtbarkeit_von_services .hidden-anchor .sr-only}4.2. Sichtbarkeit von Services {#heading__sichtbarkeit_von_services}

::: paragraph
Wie wir oben gezeigt haben, ist es möglich, dass Sie für einen Host
Kontakt sind, aber nicht für alle seine Services. Trotzdem werden Sie in
so einem Fall alle Services des Hosts in der GUI sehen können.
:::

::: paragraph
Diese Ausnahme ist so voreingestellt, weil das meistens nützlich ist.
Das bedeutet in der Praxis z.B., dass die Kollegin, die für den Host an
sich verantwortlich ist, auch solche Services sehen kann, die mit dem
eigentlichen Host (Hardware, Betriebssystem etc.) nichts zu tun haben.
Trotzdem erhält sie für diese keine Benachrichtigungen!
:::

::: paragraph
Wenn Ihnen das nicht gefällt, können Sie das umstellen über [![icon
configuration](../images/icons/icon_configuration.png)]{.image-inline}
[Global settings \> Monitoring Core \> Authorization
settings]{.guihint}. Wenn Sie dort [Hosts]{.guihint} auf [Strict -
Visible if user is contact for the service]{.guihint} umstellen, können
Benutzer Services nur noch dann sehen, wenn sie direkt als Kontakt dem
Service zugeordnet sind.
:::

:::: imageblock
::: content
![Dialog mit
Autorisierungseinstellungen.](../images/wato_user_authorization_settings.png)
:::
::::

::: paragraph
Das Ganze hat übrigens **nichts** damit zu tun, dass ein Service die
Kontaktgruppen seines Hosts erbt, falls für ihn keine eigenen definiert
sind. Denn dann *wären* Sie ja Kontakt für den Service (und würden auch
deren Benachrichtigungen bekommen).
:::
:::::::::

:::::: sect2
### []{#_host_und_service_gruppen .hidden-anchor .sr-only}4.3. Host- und Service-Gruppen {#heading__host_und_service_gruppen}

::: paragraph
Die zweite Option in der globalen Einstellung [Authorization
settings]{.guihint} betrifft Host- und Service-Gruppen. Normalerweise
können Sie eine Gruppe immer dann sehen, wenn Sie mindestens ein Element
der Gruppe sehen können. Allerdings sieht die Gruppe dann für Sie aus,
als würde sie auch nur die für Sie sichtbaren Element enthalten.
:::

::: paragraph
Ein Umschalten auf [Strict - Visible if all members are
visible]{.guihint} macht alle Gruppen unsichtbar, in denen Sie für
mindestens einen Host bzw. Service **kein** Kontakt sind.
:::

::: paragraph
Beachten Sie, dass diese beiden Einstellungen zur Sichtbarkeit *keinen
Einfluss* auf die Benachrichtigungen haben.
:::
::::::
::::::::::::::::::::
:::::::::::::::::::::

::::::: sect1
## []{#notifications .hidden-anchor .sr-only}5. Benachrichtigungen {#heading_notifications}

:::::: sectionbody
::: paragraph
Kontaktzuordnungen haben auch einen Einfluss auf die Benachrichtigungen.
Checkmk ist so voreingestellt, dass im Falle eines Problems alle
Kontakte des betroffenen Hosts oder Services benachrichtigt werden. Das
geschieht durch eine Benachrichtigungsregel, die bei neuen Instanzen
automatisch angelegt wird. Dies ist ein sehr sinnvolles Verhalten.
:::

::: paragraph
Trotzdem können Sie bei Bedarf die Regel anpassen oder durch weitere
Regeln ergänzen, so dass Benachrichtigungen im Extremfall sogar ganz
unabhängig von den Kontaktgruppen geschehen. Häufiger Grund dafür ist,
dass ein Benutzer sich wünscht, bestimmte Benachrichtigungen *nicht* zu
bekommen oder umgekehrt über Probleme bei einzelnen Hosts oder Services
informiert zu werden, auch wenn er für diese nicht zuständig (und
folglich kein Kontakt) ist.
:::

::: paragraph
Details erfahren Sie im [Artikel über die
Benachrichtigungen.](notifications.html)
:::
::::::
:::::::

:::::::::::::::::::::::::::: sect1
## []{#roles .hidden-anchor .sr-only}6. Rollen und Berechtigungen {#heading_roles}

::::::::::::::::::::::::::: sectionbody
::::::::: sect2
### []{#predefined_roles .hidden-anchor .sr-only}6.1. Vordefinierte Rollen {#heading_predefined_roles}

::: paragraph
Checkmk vergibt Berechtigungen an Benutzer immer über Rollen --- niemals
direkt. Eine Rolle ist nichts anderes als eine Liste von Berechtigungen.
Wichtig ist, dass Sie verstehen, dass Rollen das *Niveau* von
Berechtigungen definieren und nicht den Bezug zu irgendwelchen Hosts
oder Services. Dafür sind die Kontaktgruppen da.
:::

::: paragraph
Checkmk wird mit folgenden vordefinierten Rollen ausgeliefert, welche
niemals gelöscht, aber beliebig angepasst werden können:
:::

+-------------+---------------------------+---------------------------+
| Rolle       | Berechtigungen            | Einsatzzweck              |
+=============+===========================+===========================+
| `admin`     | Alle                      | Der                       |
|             | Berech                    | Checkmk-Administrator,    |
|             | tigungen --- insbesondere | der das Monitoring-System |
|             | das Recht, Berechtigungen | an sich betreut.          |
|             | zu ändern.                |                           |
+-------------+---------------------------+---------------------------+
| `user`      | Darf nur die eigenen      | Der normale               |
|             | Hosts und Services sehen, | Checkmk-Benutzer, der das |
|             | in der Weboberfläche nur  | Monitoring nutzt und auf  |
|             | in für sie [freigegebenen | Benachrichtigungen        |
|             | Ordn                      | reagiert.                 |
|             | ern](#folder_permissions) |                           |
|             | Änderungen machen und     |                           |
|             | darf generell nichts      |                           |
|             | machen, was andere        |                           |
|             | Benutzer beeinflusst.     |                           |
+-------------+---------------------------+---------------------------+
| `agent_re   | Die Berechtigung, den     | Diese Rolle ist dem       |
| gistration` | [C                        | [                         |
|             | heckmk-Agenten](wato_moni | Automationsbenutzer](glos |
|             | toringagents.html#agents) | sar.html#automation_user) |
|             | eines Hosts beim          | `agent_registration`      |
|             | Checkmk-Server für die    | zugewiesen, um eine       |
|             | TLS-verschlüsselte        | Registrierung mit         |
|             | Datenübertragung zu       | minimalen Rechten         |
|             | registrieren --- sonst    | durchzuführen. In         |
|             | nichts.                   | [                         |
|             |                           | ![CSE](../images/icons/CS |
|             |                           | E.png "Checkmk Cloud"){wi |
|             |                           | dth="20"}]{.image-inline} |
|             |                           | **Checkmk Cloud** und     |
|             |                           | [![CME](../images/icons/  |
|             |                           | CME.png "Checkmk MSP"){wi |
|             |                           | dth="20"}]{.image-inline} |
|             |                           | **Checkmk MSP** enthält   |
|             |                           | diese Rolle zusätzliche   |
|             |                           | Berechtigungen, um [Hosts |
|             |                           | automatisch zu            |
|             |                           | erstellen.]               |
|             |                           | (hosts_autoregister.html) |
+-------------+---------------------------+---------------------------+
| `guest`     | Darf alles sehen aber     | Gedacht zum einfachen     |
|             | nichts ändern.            | „Gucken", wobei sich alle |
|             |                           | Gäste ein gemeinsames     |
|             |                           | Konto teilen. Auch        |
|             |                           | nützlich für öffentliche  |
|             |                           | Statusmonitore, die an    |
|             |                           | der Wand hängen.          |
+-------------+---------------------------+---------------------------+

::: paragraph
Die Rollen werden über [Setup \> Users \> Roles & permissions]{.guihint}
verwaltet:
:::

:::: imageblock
::: content
![Liste mit Benutzerrollen.](../images/wato_user_roles_list.png)
:::
::::

::: paragraph
Übrigens: Beim Erzeugen einer neuen Checkmk-Instanz wird nur ein
Benutzer (`cmkadmin`) der Rolle `admin` angelegt. Die anderen Rollen
werden erst mal nicht verwendet. Wenn Sie einen Gastbenutzer wünschen,
müssen Sie diesen selbst anlegen.
:::
:::::::::

::::::::: sect2
### []{#_bestehende_rollen_anpassen .hidden-anchor .sr-only}6.2. Bestehende Rollen anpassen {#heading__bestehende_rollen_anpassen}

::: paragraph
Wie üblich gelangen Sie über das Symbol [![icon
edit](../images/icons/icon_edit.png)]{.image-inline} in den Editiermodus
für eine Rolle:
:::

:::: imageblock
::: content
![Liste mit Berechtigungen für eine
Benutzerrolle.](../images/wato_user_roles_permissions.png)
:::
::::

::: paragraph
Welche Bedeutung die zahlreichen Berechtigungen haben (hier in Auszügen
dargestellt), erfahren Sie aus der [![icon
help](../images/icons/icon_help.png)]{.image-inline} Onlinehilfe.
:::

::: paragraph
Das Besondere hier: Für jede Berechtigung gibt es drei
Auswahlmöglichkeiten: *yes*, *no* und *default (yes)* bzw.
*default(no)*. Am Anfang stehen alle Werte auf *default*. Für die
Berechtigung selbst macht es erst mal keinen Unterschied, ob Sie *yes*
oder *default (yes)* eingestellt haben. Allerdings kann eine neue
Version von Checkmk den Defaultwert ändern (auch wenn das sehr selten
vorkommt). Eine von Ihnen explizite gemachte Einstellung wäre dann von
der Änderung nicht betroffen.
:::

::: paragraph
Außerdem können Sie durch dieses Prinzip sehr schnell erkennen, wo Ihre
Checkmk-Installation vom Standard abweicht.
:::
:::::::::

:::::::: sect2
### []{#_eigene_rollen_definieren .hidden-anchor .sr-only}6.3. Eigene Rollen definieren {#heading__eigene_rollen_definieren}

::: paragraph
Vielleicht sind Sie überrascht, dass es keinen Knopf gibt, um eine neue
Rolle anzulegen. Dahinter steckt Absicht! Neue Rollen erschaffen Sie
durch ein Ableiten von bestehenden Rollen mittels [![icon
clone](../images/icons/icon_clone.png)]{.image-inline}
[Clone]{.guihint}. Die neue Rolle wird nicht einfach als Kopie erzeugt,
sondern behält den Bezug zur Ausgangsrolle ([Based on role]{.guihint}):
:::

:::: imageblock
::: content
![Basiseigenschaften einer erstellten
Benutzerrolle.](../images/wato_user_roles_new_role.png)
:::
::::

::: paragraph
Diese Verbindung hat eine wichtige Funktion. Denn alle Berechtigungen
der geklonten Rolle, die nicht explizit gesetzt sind (also noch auf
[default]{.guihint} stehen), werden von der Ausgangsrolle geerbt.
Änderungen in der Ausgangsrolle schlagen also durch. Das ist sehr
praktisch, wenn man bedenkt, wie viele Berechtigungen es gibt. Bei einer
simplen Kopie könnten Sie sonst leicht den Überblick verlieren, was
eigentlich das Besondere an Ihrer selbst definierten Rolle ausmacht.
:::

::: paragraph
Das Ableiten löst noch ein weiteres Problem: Da wir Checkmk rege
weiterentwickeln, kommen immer wieder neue Berechtigungen hinzu. Jedes
mal entscheiden wir dann, in welcher der drei Rollen `admin`, `user` und
`guest` die neue Berechtigung enthalten sein soll. Da jede Ihrer eigenen
Rollen von genau einer der drei vordefinierten Rollen abgeleitet ist,
wird dann die neue Berechtigung automatisch auf einen sinnvollen Wert
voreingestellt. Es wäre doch sehr unpraktisch, wenn Sie z.B. eine eigene
`user`-Rolle definieren und dort neue Berechtigungen immer fehlen
würden. Dann müssten Sie bei jedem neuen Feature Ihre Rolle anpassen,
damit Ihre Benutzer diese nutzen könnten.
:::
::::::::

:::::: sect2
### []{#_rollen_vergleichen_mit_der_matrixansicht .hidden-anchor .sr-only}6.4. Rollen vergleichen mit der Matrixansicht {#heading__rollen_vergleichen_mit_der_matrixansicht}

::: paragraph
Wenn Sie die Berechtigungen in den einzelnen Rollen vergleichen möchten,
hilft die Matrixansicht, zu erreichen über [Setup \> Users \> Roles &
permissions \> Permission matrix.]{.guihint} Der Menüeintrag erzeugt
folgende Darstellung, in der Sie nicht nur die Berechtigungen der
einzelnen Rollen vergleichen können, sondern auch die Stellen sehen, an
denen explizit Berechtigungen gesetzt (Symbol [![icon perm
yes](../images/icons/icon_perm_yes.png)]{.image-inline}) bzw. entfernt
(Symbol [![icon perm
no](../images/icons/icon_perm_no.png)]{.image-inline}) wurden.
:::

:::: imageblock
::: content
![Matrix mit Benutzerrollen im
Vergleich.](../images/wato_user_roles_matrix.png)
:::
::::
::::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

:::::: sect1
## []{#personal_settings .hidden-anchor .sr-only}7. Persönliche Einstellungen {#heading_personal_settings}

::::: sectionbody
::: paragraph
Einen kleinen Teil der Benutzereinstellungen kann jeder Benutzer für
sein Profil selbst verwalten. Eine genaue Beschreibung aller Optionen
finden Sie im Artikel zur
[Benutzeroberfläche.](user_interface.html#user_menu)
:::

::: paragraph
Dazu ein Hinweis für **verteiltes Monitoring:** In einer [verteilten
Umgebung](distributed_monitoring.html) werden nach jeder Änderung die
neuen Einstellungen sofort auf alle Monitoring-Instanzen übertragen. Nur
so ist sichergestellt, dass insbesondere ein neu vergebenes Passwort
auch sofort überall funktioniert --- und nicht erst beim nächsten
Aktivieren der Änderungen. Das klappt allerdings nur für Instanzen, die
zu diesem Zeitpunkt auch über das Netzwerk erreichbar sind. Alle andere
Instanzen bekommen die Aktualisierungen beim nächsten erfolgreichen
[Aktivieren der Änderungen.](wato.html#activate_changes)
:::
:::::
::::::

:::::::::::::::::::::::::::: sect1
## []{#automation .hidden-anchor .sr-only}8. Automationsbenutzer (für Webdienste) {#heading_automation}

::::::::::::::::::::::::::: sectionbody
::: paragraph
Bei der Anbindung von Checkmk an andere Systeme kommt oft der Wunsch
auf, bestimmte Tätigkeiten, die normalerweise über die GUI stattfinden,
zu automatisieren. Einige Beispiele dafür sind:
:::

::: ulist
- Setzen und Entfernen von
  [Wartungszeiten](monitoring_basics.html#downtimes) per Skript

- Verwalten von Hosts per [REST-API](rest_api.html)

- Abrufen von Daten aus [Ansichten](views.html) als CSV oder JSON zum
  Zwecke der Weiterverarbeitung

- Abrufen des aktuellen Status von [BI-Aggregaten](bi.html), um diese
  als Service anzulegen
:::

::: paragraph
In diesen Situationen muss eine externe Software bestimmte URLs der
Checkmk-Oberfläche automatisiert abrufen können. Und da stellt sich
natürlich die Frage, wie hier die Benutzeranmeldung geschieht. Der
normale Weg über den [Anmeldedialog](intro_setup.html#login) ist
umständlich und erfordert den Abruf von mehreren URLs hintereinander und
das Speichern eines Cookies.
:::

::: paragraph
Um dies zu vereinfachen, bietet Checkmk das Konzept der
*Automationsbenutzer*. Diese Benutzer sind ausschließlich für eine
Fernsteuerung vorgesehen und erlauben keine normale Anmeldung über die
GUI. Die Authentifizierung geschieht hier über *HTTP Basic
Authentication.*
:::

::: paragraph
In jeder Checkmk-Instanz sind zwei Automationsbenutzer bereits
eingerichtet: für Webdienste und für die Registrierung des Agenten beim
Checkmk-Server zur TLS-verschlüsselten Datenübertragung. Sie können
diese Automationsbenutzer nutzen --- oder auch einen neuen erstellen.
Sie legen einen Automationsbenutzer wie einen normalen Benutzer an,
vergeben aber kein normales Passwort, sondern ein Automationspasswort
([Automation secret]{.guihint}). Dieses können Sie mit dem [![icon
random](../images/icons/icon_random.png)]{.image-inline} Würfel
automatisch erstellen lassen:
:::

:::: imageblock
::: content
![Sicherheitseinstellungen des
Automationsbenutzers.](../images/wato_user_automation_user.png)
:::
::::

::: paragraph
Ein Automationsbenutzer hat genauso wie ein normaler Benutzer eine Rolle
und kann auch Kontakt sein. Damit können Sie also die Berechtigungen und
die Sichtbarkeit von Hosts und Services nach Bedarf einschränken.
:::

::: paragraph
Beim automatischen Abruf von Webseiten geben Sie dann den Header der
[HTTP-Basisauthentifizierung](https://en.wikipedia.org/wiki/Basic_access_authentication){target="_blank"}
an, der grundsätzlich so aussieht:
`Authorization: Basic 1234567890abcdef`. Die Zeichenfolge ist dabei die
Base64-kodierte Form von `nutzername:passwort`.
:::

::: paragraph
Hier ist ein Beispiel für den Abruf einer Ansicht im JSON-Format mit dem
Automationsbenutzer `automation` und dem Automationspasswort aus der
obigen Abbildung --- die Base64-Kodierung erledigt Curl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# curl --user automation:a8075a39-e7fe-4b5c-9daa-02635 'http://moni01.mycompany.net/mysite/check_mk/view.py?view_name=svcproblems&output_format=json'
 [
  "service_state",
  "host",
  "service_description",
  "service_icons",
  "svc_plugin_output",
  "svc_state_age",
  "svc_check_age",
  "perfometer"
 ],
 [
  "CRIT",
  "stable",
  "Filesystem /",
  "menu pnp",
  "CRIT - 96.0% used (207.27 of 215.81 GB), (warn/crit at 80.00/90.00%), trend: +217.07 MB / 24 hours",
  "119 min",
  "30 sec",
  "96%"
 ],
 ...
```
:::
::::

::: paragraph
Wenn das Skript, das die URL abruft, direkt in der Monitoring-Instanz
läuft, können Sie das Automationspasswort für den Benutzer direkt aus
dem Dateisystem auslesen. Das ist keine Sicherheitslücke, sondern so
vorgesehen: Sie können Automatisierungsskripte schreiben, die das
Automationspasswort nicht enthalten müssen und keine Konfigurationsdatei
benötigen. Lesen Sie dazu die Datei
`~/var/check_mk/web/myuser/automation.secret` aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cat var/check_mk/web/automation/automation.secret
a8075a39-e7fe-4b5c-9daa-02635
```
:::
::::

::: paragraph
In der Shell können Sie den Inhalt dieser Datei leicht in einer Variable
speichern:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ SECRET=$(cat var/check_mk/web/automation/automation.secret)
OMD[mysite]:~$ echo "$SECRET"
a8075a39-e7fe-4b5c-9daa-02635
```
:::
::::

::: paragraph
Dies macht sich z.B. auch das Skript `downtime` zunutze, welches Sie im
`treasures`-Verzeichnis von Checkmk finden und mit dem Sie
skriptgesteuert Wartungszeiten für Hosts und Services setzen und
entfernen können. Wenn der Automationsbenutzer wie bei uns im Beispiel
`automation` heißt, brauchen Sie als einziges Argument den Host-Namen,
für den eine Wartung eingetragen werden soll:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ~/share/doc/check_mk/treasures/downtime.py myhost123
```
:::
::::

::: paragraph
Weitere Optionen des Skripts erfahren Sie in dessen Onlinehilfe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ ~/share/doc/check_mk/treasures/downtime.py --help
```
:::
::::
:::::::::::::::::::::::::::
::::::::::::::::::::::::::::

::::::::::::::::::::::: sect1
## []{#_automatische_anmeldung_über_die_url .hidden-anchor .sr-only}9. Automatische Anmeldung über die URL {#heading__automatische_anmeldung_über_die_url}

:::::::::::::::::::::: sectionbody
::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Die im folgenden beschriebene     |
|                                   | automatische Anmeldung über die   |
|                                   | URL im Browser ist seit Checkmk   |
|                                   | [2.2.0]{.new} aus                 |
|                                   | Sicherheitsgründen deaktiviert,   |
|                                   | da die per URL übergebenen        |
|                                   | Zugangsdaten (Benutzername und    |
|                                   | Passwort) in den Log-Dateien des  |
|                                   | instanzspezifischen Apache        |
|                                   | gespeichert werden (siehe [Werk   |
|                                   | #14261](https://checkmk.com/      |
|                                   | de/werk/14261){target="_blank"}). |
|                                   | Falls Sie die automatische        |
|                                   | Anmeldung über die URL trotz      |
|                                   | dieses Sicherheitsrisikos nutzen  |
|                                   | wollen, müssen Sie dies explizit  |
|                                   | aktivieren mit der globalen       |
|                                   | Einstellung [Setup \> General \>  |
|                                   | Global settings \> User interface |
|                                   | \> Enable login via GET           |
|                                   | requests.]{.guihint}              |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Wie Sie gesehen haben, können Sie mit Automationsbenutzern beliebige
URLs ohne Anmeldung skriptgesteuert abrufen. In Situationen, die ein
echtes Login im Browser benötigen, funktioniert dies jedoch nicht, da
die Logindaten bei enthaltenen Links (z.B. zu Bildern und Iframes) nicht
weitergereicht werden.
:::

::: paragraph
Das beste Beispiel dafür ist der Wunsch, einen Monitor an die Wand zu
hängen, der ständig ein bestimmtes Dashboard von Checkmk zeigt. Der
Monitor soll von einem Rechner angesteuert werden, der beim Starten
automatisch den Browser öffnet, sich an Checkmk anmeldet und das
Dashboard aufruft.
:::

::: paragraph
Um so etwas zu realisieren, legen Sie sich am besten zunächst dafür
einen speziellen Benutzer an. Die Rolle `guest` ist dafür gut geeignet,
weil diese alle Leserechte einräumt, aber keine Veränderungen oder
Eingriffe zulässt.
:::

::: paragraph
Die URL für eine automatische Anmeldung konstruieren Sie wie folgt:
:::

::: {.olist .arabic}
1.  Beginnen Sie mit:
    `http://mycmkserver/mysite/check_mk/login.py?_origtarget=`

2.  Ermitteln Sie die eigentlich anzuzeigende URL (z.B. die des
    Dashboards) mit Ihrem Browser --- am besten ohne Navigation, was
    über [Display \> This page without navigation]{.guihint} geht.

3.  Hängen Sie diese URL an, wobei Sie alles vor dem Teil `/mysite/…​`
    weglassen.

4.  Fügen Sie an die URL die beiden Variablen `_username` und
    `_password` an und zwar in folgender Form:
    `&_username=myuser&_password=mysecret`.

5.  Fügen Sie noch ein `&_login=1` an.
:::

::: paragraph
Hier ist ein Beispiel für so eine URL:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
http://mycmkserver/mysite/check_mk/login.py?_origtarget=/mysite/check_mk/dashboard.py?name=mydashboard&_username=myuser&_password=mypassword&_login=1
```
:::
::::

::: paragraph
Beachten Sie:
:::

::: ulist
- Ersetzen Sie im Beispiel die Werte `mycmkserver`, `mysite`, `myuser`
  und `mypassword` durch die bei Ihnen gültigen Werte. Als `myuser`
  können Sie nicht den Automationsbenutzer verwenden, da für ihn eine
  Anmeldung über die GUI nicht erlaubt ist.

- Kommen die Sonderzeichen `&` oder `%` in einem dieser Werte oder in
  dem Wert von `_origtarget` vor, müssen Sie diese wie folgt ersetzen:
  `&` durch `%26` und `%` durch `%25`.
:::

::: paragraph
Testen Sie das Ganze, indem Sie sich in Ihrem Browser von Checkmk
abmelden und dann die konstruierte URL in Ihre Adresszeile vom Browser
kopieren. Sie müssen dann direkt auf die Zielseite gelangen --- ohne
Anmeldedialog. Gleichzeitig werden Sie dabei angemeldet und können in
der Seite enthaltene Links direkt aufrufen.
:::

::: paragraph
Sie können die fertige URL auch mit `curl` auf der Kommandozeile
ausprobieren. Wenn Sie alles richtig gemacht haben, bekommen Sie als
Ergebnis den HTTP-Status-Code `302 FOUND` und eine Weiterleitung auf die
angegebene `Location`, wie in der folgenden gekürzten Ausgabe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ curl -v 'http://mycmkserver/mysite/check_mk/login.py?_origtarget=/mysite/check_mk/dashboard.py?name=mydashboard&_username=myuser&_password=mypassword&_login=1'
...
< HTTP/1.1 302 FOUND
...
< Location: /mysite/check_mk/dashboard.py?name=mydashboard
...
```
:::
::::

::: paragraph
Sollten Sie im Browser trotz dieser Erfolgsmeldung nicht die gewünschte
Ansicht bekommen, prüfen Sie die unter `Location` angegebene URL - auch
wenn diese falsch ist, liefert `curl` den HTTP-Status-Code `302 FOUND`.
:::

::: paragraph
Bei falschen Login-Daten bekommen Sie die HTTP-Status-Code `200 OK`,
sehen aber lediglich den HTML-Code der Anmeldeseite, wie in der
folgenden erneut gekürzten Ausgabe:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ curl -v 'http://mycmkserver/mysite/check_mk/login.py?_origtarget=/mysite/check_mk/dashboard.py?name=mydashboard&_username=myuser&_password=NOT&_login=1'
...
< HTTP/1.1 200 OK
...
<!DOCTYPE HTML>
<html><head><meta content="text/html; ...
...
</script>
<script type="text/javascript">
cmk.visibility_detection.initialize();
</script>
</body></html>
```
:::
::::
::::::::::::::::::::::
:::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#wato_permissions .hidden-anchor .sr-only}10. Berechtigungen in Checkmk {#heading_wato_permissions}

:::::::::::::::::: sectionbody
:::::::::: sect2
### []{#_bedeutung_der_rolle_user_für_checkmk .hidden-anchor .sr-only}10.1. Bedeutung der Rolle user für Checkmk {#heading__bedeutung_der_rolle_user_für_checkmk}

::: paragraph
Wenn Sie eine etwas größere Monitoring-Umgebung zu verwalten haben, dann
möchten Sie sicher auch Mit-Administratoren in die Konfiguration und
insbesondere in das Verwalten von Hosts und Services mit einbeziehen.
Damit Sie die Kontrolle darüber behalten, wer was ändern darf und damit
sich die Leute nicht in die Quere kommen, können Sie Berechtigungen für
das Checkmk [Setup](wato.html) auf der Basis von Ordnern vergeben.
:::

::: paragraph
Der erste Schritt dazu ist, dass Ihre Administrator-Kollegen mit eigenen
Benutzern arbeiten, die auf der Rolle `user` basieren.
:::

::: paragraph
Diese Rolle hat grundsätzlich eine Berechtigung für die
Konfigurationsumgebung, allerdings mit einigen wichtigen
Einschränkungen:
:::

::: ulist
- Es sind lediglich Änderungen an Hosts, Services,
  [Regeln](wato_rules.html) und [BI-Aggregaten](bi.html) erlaubt.

- Hosts, Services und Regeln können nur in [freigegebenen
  Ordnern](#folder_permissions) verwaltet werden.

- BI-Aggregate können nur in freigegebenen BI-Paketen verwaltet werden.

- Alles, was globale Auswirkungen hat, ist nicht erlaubt.
:::

::: paragraph
Solange Sie noch keine Ordner oder BI-Pakete freigegeben haben bedeutet
das, dass die Benutzer der Rolle `user` zunächst keinerlei Änderungen
machen können! Das **abgespeckte** [Setup]{.guihint}-Menü der
Navigationsleiste sieht für normale Benutzer so aus:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Setup-Menü aus
Benutzersicht.](../images/wato_user_setupmenu.png){width="65%"}
:::
::::
::::::::::

::::::::: sect2
### []{#folder_permissions .hidden-anchor .sr-only}10.2. Benutzern das Verwalten von Hosts ermöglichen {#heading_folder_permissions}

::: paragraph
Die Berechtigung für das Anlegen, Editieren und Entfernen von Hosts
erhält ein Benutzer über [Kontaktgruppen.](#contact_groups) Der Ablauf
ist wie folgt:
:::

::: {.olist .arabic}
1.  Nehmen Sie den Benutzer in eine Kontaktgruppe auf.

2.  Bestimmen Sie einen oder mehrere [Ordner](hosts_setup.html#folder),
    für die der Benutzer berechtigt sein soll.

3.  Aktivieren Sie die Eigenschaft [Permissions]{.guihint} dieser Ordner
    und wählen Sie die Kontaktgruppe hier aus.
:::

::: paragraph
Das folgende Beispiel zeigt die Eigenschaften eines Ordners, in dem alle
Benutzer der Kontaktgruppe [Linux]{.guihint} Hosts verwalten dürfen.
Dabei ist die Option aktiviert, dass dies auch in Unterordnern erlaubt
sein soll.
:::

:::: imageblock
::: content
![Ordnereigenschaften mit freigegebener Kontaktgruppe
Linux.](../images/wato_user_user_folder.png)
:::
::::

::: paragraph
Ob Sie die Hosts automatisch in die Kontaktgruppe aufnehmen möchten,
bleibt Ihnen überlassen. In diesem Beispiel ist die Option [Add these
groups as contacts to all hosts in this folder]{.guihint} nicht gesetzt
und die Hosts werden somit auch nicht in die Kontaktgruppe
[Linux]{.guihint} aufgenommen. Damit sind sie in der Monitoring-Umgebung
dann für die Kontaktgruppe [Linux]{.guihint} nicht sichtbar (solange
dies nicht eine Regel erledigt). Wie Sie sehen, sind also die
Sichtbarkeit (und Zuständigkeit im Monitoring) und die Berechtigung für
die Konfigurationsumgebung getrennt regelbar.
:::
:::::::::
::::::::::::::::::
:::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#passwords .hidden-anchor .sr-only}11. Passwörter {#heading_passwords}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::::::::::::::: sect2
### []{#_sicherheit_von_passwörtern .hidden-anchor .sr-only}11.1. Sicherheit von Passwörtern {#heading__sicherheit_von_passwörtern}

::: paragraph
Sicherheit wird heutzutage hoch aufgehängt. Daher gibt es in manchen
Unternehmen generelle Vorgaben, wie mit Passwörtern umgegangen werden
soll. Checkmk bietet etliche Einstellungen, um solche Vorgaben zu
erzwingen. Einen Teil davon finden Sie unter [Global settings \> User
management \> Password policy for local accounts]{.guihint}:
:::

:::: imageblock
::: content
![Dialog für Passwort-Regeln.](../images/wato_user_password_policy.png)
:::
::::

::: paragraph
Die erste Option [Minimum password length]{.guihint} soll die Qualität
des Passworts sicherstellen.
:::

::: paragraph
Für die zweite Option [Number of character groups to use]{.guihint} gibt
es insgesamt vier Zeichengruppen:
:::

::: ulist
- Kleinbuchstaben

- Großbuchstaben

- Ziffern

- Sonderzeichen
:::

::: paragraph
Tragen Sie hier eine `4` ein, so muss ein Passwort aus jeder der
genannten Gruppen mindestens ein Zeichen enthalten. Bei einer `2` ist
zumindest sichergestellt, dass das Passwort nicht z.B. nur aus
Kleinbuchstaben besteht. Diese Einstellungen werden bei jeder Änderung
des Passworts überprüft.
:::

::: paragraph
Die dritte Option [Maximum age of passwords]{.guihint} zwingt den
Benutzer, in regelmäßigen Abständen sein Passwort zu ändern. Sobald es
soweit ist, führt der nächste Seitenzugriff den Benutzer zu folgender
Eingabeaufforderung:
:::

:::: imageblock
::: content
![Dialog für erzwungene
Passwort-Neuvergabe.](../images/wato_user_forced_password_change.png)
:::
::::

::: paragraph
Erst nach einer Änderung seines Passworts darf der Benutzer
weitermachen.
:::

::: paragraph
Sie können eine Änderung des initialen Passworts gleich beim ersten
Login vorschreiben. Dazu dient die Option [Enforce change: Change
password at next login or access]{.guihint} im Abschnitt
[Security]{.guihint} in den Eigenschaften des jeweiligen Benutzers.
:::
:::::::::::::::

:::::::::::::::::::::::::::::: sect2
### []{#_richtlinien_für_die_anmeldung .hidden-anchor .sr-only}11.2. Richtlinien für die Anmeldung {#heading__richtlinien_für_die_anmeldung}

::: paragraph
Unter [Global settings \> User management]{.guihint} finden Sie noch
weitere globale Einstellungen, welche die Anmeldung von Benutzern
betreffen.
:::

:::::::::: sect3
#### []{#suspension .hidden-anchor .sr-only}Sperrung nach fehlerhaften Anmeldungen {#heading_suspension}

::: paragraph
Mit der Einstellung [Lock user accounts after N logon
failures]{.guihint} können Sie ein Konto nach einer Reihe von
fehlerhaften Anmeldeversuchen sperren:
:::

:::: imageblock
::: content
![Dialog für automatische
Login-Deaktivierung.](../images/wato_user_login_failures.png)
:::
::::

::: paragraph
Ein Entsperren ist dann nur noch durch einen Benutzer mit der Rolle
`admin` möglich. Als Admin können Sie andere Benutzer über [Setup \>
Users \> Users]{.guihint} und dann die Eigenschaften des gesperrten
Benutzers wieder entsperren. Beachten Sie allerdings, dass auch die
Administratorkonten gesperrt werden können! Sollten Sie als Admin
endgültig ausgesperrt sein, so können Sie Ihr Konto nur noch auf der
Kommandozeile entsperren. Editieren Sie dazu als Instanzbenutzer die
Datei `etc/htpasswd` und entfernen Sie in der Zeile des betroffenen
Benutzers, hier `myuser`, das Ausrufezeichen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cat etc/htpasswd
agent_registration:$2y$12$83XzYwtQJVFizC...
automation:$2y$12$zKF4Sasws7rDJCByZ1r5ke...
cmkadmin:$2y$12$ZmE96frGSm9sdWiWRXtxbuyu...
myuser:!$2y$12$8FU93yH7TFTyJsyUvKCh1eqYJG..
OMD[mysite]:~$ vim etc/htpasswd
...
OMD[mysite]:~$ cat etc/htpasswd
agent_registration:$2y$12$83XzYwtQJVFizC...
automation:$2y$12$zKF4Sasws7rDJCByZ1r5ke...
cmkadmin:$2y$12$ZmE96frGSm9sdWiWRXtxbuyu...
myuser:$2y$12$8FU93yH7TFTyJsyUvKCh1eqYJG...
```
:::
::::

::: paragraph
Dann können Sie sich wieder anmelden.
:::
::::::::::

::::::::::: sect3
#### []{#_automatisches_abmelden .hidden-anchor .sr-only}Automatisches Abmelden {#heading__automatisches_abmelden}

::: paragraph
Im Kasten [Session management]{.guihint} können Sie zwei verschiedene
Formen der Beendigung einer Sitzung einstellen und diese auch
miteinander kombinieren: einerseits abhängig von der Sitzungsdauer,
andererseits abhängig von der Benutzertätigkeit.
:::

::: paragraph
[Maximum session duration]{.guihint} sorgt für ein automatisches Beenden
der Sitzung (*session*) nach einer festgesetzten Zeitspanne. Damit
reduzieren Sie unter anderem das Risiko einer Fremdnutzung der Sitzung,
da diese nicht unendlich lange aktiv bleibt:
:::

:::: imageblock
::: content
![Dialog für die Beendigung von
Sitzungen.](../images/wato_user_session_management.png)
:::
::::

::: paragraph
Nach Ablauf der eingestellten Sitzungsdauer muss sich der Benutzer neu
anmelden, unabhängig davon, ob er zum Sitzungsende aktiv war oder nicht.
Gleichzeitig können Sie über [Advise re-authentification before
termination]{.guihint} angeben, wann der Benutzer vor der \"harten\"
Beendigung seiner Sitzung darauf hingewiesen werden soll, seine Eingaben
zu sichern, sich abzumelden und erneut anzumelden:
:::

:::: imageblock
::: content
![Warnung vor Abschaltung der
Sitzung.](../images/wato_user_session_termination.png)
:::
::::

::: paragraph
Die Einstellung [Set an individual idle timeout]{.guihint} sorgt dafür,
dass eine Sitzung beendet wird, wenn ein Benutzer längere Zeit die GUI
nicht aktiv verwendet. Also z. B., wenn er seinen Arbeitsplatz zeitweise
verlassen hat ohne sich in Checkmk abzumelden. Dieser Timeout kann durch
aktives Verwenden der GUI aufgehalten werden. Es reicht dabei aber
nicht, nur eine Ansicht geöffnet zu haben, die sich selbst regelmäßig
neu lädt.
:::
:::::::::::

::::::::::: sect3
#### []{#_verhinderung_von_mehrfachanmeldungen .hidden-anchor .sr-only}Verhinderung von Mehrfachanmeldungen {#heading__verhinderung_von_mehrfachanmeldungen}

::: paragraph
Die Einstellung [Limit login to single session at a time]{.guihint}
verhindert, dass ein Benutzer sich mit zwei Browsern parallel an Checkmk
anmeldet:
:::

:::: imageblock
::: content
![Dialog zur Begrenzung der Anzahl von
Sitzungen.](../images/wato_user_limit_login.png)
:::
::::

::: paragraph
Diese Option ist gleichzeitig mit einem Timeout für einen automatischen
Logout bei Untätigkeit verknüpft. Dies ist auch sinnvoll. Nehmen wir an,
Sie haben an Ihrem Arbeitsplatz vergessen, sich abzumelden, bevor Sie
den Browser schließen. Ohne einen Timeout wäre es Ihnen in diesem Fall
nicht möglich, sich während der Bereitschaft von zu Hause aus
anzumelden. Denn das Schließen des Browsers oder das Herunterfahren des
Rechners löst keine Abmeldung aus!
:::

::: paragraph
Bei dem Versuch einer parallelen zweiten Anmeldung sehen Sie dann
folgenden Fehler:
:::

:::: {.imageblock style="text-align: center;"}
::: content
![Gesperrter Anmeldedialog mit Hinweis auf laufende
Sitzung.](../images/wato_user_another_session_is_active.png){width="60%"}
:::
::::

::: paragraph
Die Anmeldung kann in diesem Fall nur durchgeführt werden, wenn Sie die
bestehende Sitzung aktiv beenden oder den eingestellten Timeout
abwarten.
:::
:::::::::::
::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: sect2
### []{#2fa .hidden-anchor .sr-only}11.3. Zwei-Faktor-Authentifizierung {#heading_2fa}

::: paragraph
Um die Absicherung Ihrer Checkmk-Instanzen zu verbessern, bietet Checkmk
die Nutzung einer Zwei-Faktor-Authentifizierung für jeden Benutzer an.
Diese Zwei-Faktor-Authentifizierung basiert auf dem Internetstandard
FIDO2/WebAuthn. Authentifiziert wird klassisch auf Basis von Wissen
(Passwort) und Besitz (Authentifikator). Sie können jede von Browser und
Betriebssystem unterstützte FIDO2-kompatible Hardware verwenden. Am
weitesten verbreitet sind USB- oder NFC-Token wie der YubiKey.
Alternativ ist die Nutzung von Software-Authentifikatoren
(Authenticator-Apps auf dem Smartphone), die ein *time-based one-time
password* (TOTP) (oder *Einmalpasswort*) generieren, möglich.
:::

::::: sect3
#### []{#2fareq .hidden-anchor .sr-only}Voraussetzungen für den Checkmk-Server {#heading_2fareq}

::: paragraph
Durch die Vorgaben des WebAuthn-Standards ergeben sich für den Einsatz
der Zwei-Faktor-Authentifizierung drei Voraussetzungen:
:::

::: ulist
- [Absicherung der Checkmk Weboberfläche mit HTTPS](omd_https.html)

- Angabe der Webadresse als einfacher Hostname oder als voll
  qualifizierter Domain-Name, auf jeden Fall eine gültige Domainadresse

- Die URL wird durchgängig im gleichen Format eingegeben, also
  beispielsweise immer `https://www.mycompany.com/mysite`.
:::
:::::

:::::::::: sect3
#### []{#2fasetup .hidden-anchor .sr-only}Einrichtung {#heading_2fasetup}

::: paragraph
Rufen Sie die Zwei-Faktor-Authentifizierung über das
[User-Menü](user_interface.html#user_menu) auf.
:::

:::: imageblock
::: content
![Auswahl der Zwei-Faktor-Authentifizierung aus dem
User-Menü.](../images/wato_user_2fa.png){width="67%"}
:::
::::

::: paragraph
Sie erhalten nun zwei mit dem Schlüsselsymbol [![Knopf zum Hinzufügen
eines neuen
Berechtigungsnachweises.](../images/icons/icon_2fa_add.png)]{.image-inline}
gekennzeichnete Möglichkeiten, den zweiten Faktor hinzuzufügen:
[Register authenticator app]{.guihint} für die Konfiguration einer App,
die Einmalpasswörter generiert, und [Register security token]{.guihint}
für die Verwendung eines Hardware-Token.
:::

:::: imageblock
::: content
![Einrichtungsseite zur
Zwei-Faktor-Authentifizierung.](../images/wato_user_2fa_2.png)
:::
::::

::: paragraph
Checkmk erkennt die auf Ihrem Computer verfügbaren
Authentifizierungsmöglichkeiten. Es öffnet sich ein kleiner Dialog im
Browserfenster, in dem Sie den Authentifikator festlegen. Bei Verwendung
eines Hardware-Tokens ist die Einrichtung mit der Berührung des Knopfes
abgeschlossen. Bei Nutzung von Einmalpasswörtern müssen Sie ein
generiertes Passwort zur Bestätigung eingeben. Die Sitzung wird in
beiden Fällen nahtlos weitergeführt.
:::
::::::::::

::::::: sect3
#### []{#2falogin .hidden-anchor .sr-only}Anmeldung {#heading_2falogin}

::: paragraph
Bei künftigen Anmeldeversuchen ist dann die
Zwei-Faktor-Authentifizierung in Checkmk aktiv: Zuerst geben Sie, wie
gewohnt, Ihren Benutzernamen und das Passwort ein. Dann erscheint ein
weiterer Anmeldebildschirm:
:::

:::: imageblock
::: content
![Anmeldung mit dem zweiten
Authentifizierungsfaktor.](../images/wato_user_2fa_login.png){width="53%"}
:::
::::

::: paragraph
Nach der Aktivierung des Authentifikators können Sie wie gewohnt mit
Checkmk arbeiten.
:::
:::::::

::::::::::: sect3
#### []{#2fabackup .hidden-anchor .sr-only}Backup-Codes erstellen und nutzen {#heading_2fabackup}

::: paragraph
Für den Fall, dass Sie Ihren Authentifikator einmal nicht zur Hand
haben, können Sie alternativ einen Backup-Code eingeben.
:::

::: paragraph
Erstellen Sie sich dazu vorab auf der Seite [User \> Two-factor
authentication]{.guihint} mit Hilfe von [![Knopf zur Erstellung von
Backup-Codes.](../images/icons/icon_regenerate.png)]{.image-inline}
[Generate backup codes]{.guihint} eine Liste mit Backup-Codes.
:::

:::: imageblock
::: content
![Anzeige der erstellten
Backup-Codes.](../images/wato_user_2fa_backup.png){width="85%"}
:::
::::

::: paragraph
Verwahren Sie diese an einem sicheren Ort.
:::

::: paragraph
Wollen Sie sich dann mit einem Backup-Code auf der Checkmk Webseite
anmelden, klicken Sie auf dem zweiten Anmeldebildschirm auf [Use backup
code]{.guihint}. Geben Sie einen Ihrer Backup-Codes ein und melden Sie
sich mit [Use backup code]{.guihint} an.
:::

:::: imageblock
::: content
![Aufforderung zur Eingabe des
Backup-Codes.](../images/wato_user_2fa_login2.png){width="53%"}
:::
::::
:::::::::::

:::::::::: sect3
#### []{#2faadmin .hidden-anchor .sr-only}Als Administrator die Zwei-Faktor-Authentifizierung prüfen und aufheben {#heading_2faadmin}

::: paragraph
Als Administrator sehen Sie in der Benutzerverwaltung ([Setup \> Users
\> Users]{.guihint}) anhand des Eintrags in der Spalte
[Authentication]{.guihint}, welche Benutzer eine
Zwei-Faktor-Authentifizierung eingerichtet haben.
:::

:::: imageblock
::: content
![Ansicht einer Zwei-Faktor-Authentifizierung in der
Benutzerverwaltung.](../images/wato_user_2fa_admin.png)
:::
::::

::: paragraph
Hat nun einer dieser Benutzer keinen Zugang mehr zu Checkmk, also z. B.
seinen Token verloren oder beschädigt, so können Sie die
Zwei-Faktor-Authentifizierung gezielt für diesen Benutzer entfernen.
Öffnen Sie dazu in der Benutzerverwaltung den betreffenden Eintrag mit
einem Klick auf [![Symbol zur
Bearbeitung.](../images/icons/icon_edit.png)]{.image-inline}. In der
Ansicht des Benutzers entfernen Sie über [User \> Remove two-factor
authentication]{.guihint} die Zwei-Faktor-Authentifizierung für diesen
Benutzer wieder.
:::

:::: imageblock
::: content
![Entfernung einer
Zwei-Faktor-Authentifizierung.](../images/wato_user_2fa_remove.png){width="39%"}
:::
::::

::: paragraph
Nach Ihrer Bestätigung der Sicherheitsabfrage kann sich der Benutzer
wieder \"nur\" mit Benutzernamen und Passwort an der Weboberfläche von
Checkmk anmelden.
:::
::::::::::
:::::::::::::::::::::::::::::::::::::

:::::::: sect2
### []{#change_passwd .hidden-anchor .sr-only}11.4. Passwort auf der Kommandozeile ändern {#heading_change_passwd}

::: paragraph
Sie können im Notfall ein Passwort auch per Kommandozeile ändern. Das
rettet Sie in dem Fall, in dem Sie das Passwort von `cmkadmin` verloren
haben. Voraussetzung ist natürlich, dass noch eine Anmeldung als
Linux-Benutzer auf dem Checkmk-Server möglich ist und Sie mit
`omd su mysite` Instanzbenutzer werden können.
:::

::: paragraph
Die Passwörter sind in der Datei `~/etc/htpasswd` gespeichert, wie
bereits [weiter oben](#suspension) beschrieben.
:::

::: paragraph
Das Ändern geschieht mit dem Befehl `cmk-passwd`. Dieser fragt Sie
**nicht** nach dem bestehenden Passwort. `cmk-passwd` wird in einer
aktuellen Version von Checkmk immer eine sichere Verschlüsselungsmethode
wählen, um Ihre Passwörter zu speichern. Aktuell verwendet `cmk-passwd`
dafür bcrypt. Unverschlüsselte und schwach verschlüsselte Passwörter
(bspw. mit MD5) erlauben keine Anmeldung an der GUI.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ cmk-passwd cmkadmin
New password: secret
Re-type new password: secret
```
:::
::::
::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::: sect1
## []{#custom_user_attributes .hidden-anchor .sr-only}12. Benutzerdefinierte Attribute {#heading_custom_user_attributes}

:::::::::: sectionbody
::: paragraph
Für die Benachrichtigung von Benutzern steht Ihnen neben dem Feld für
die E-Mail-Adresse noch das Feld [Pager address]{.guihint} zur
Verfügung. Wenn Ihnen das nicht ausreicht und Sie noch mehr
Informationen zu einem Benutzer speichern möchten, können Sie über
[Setup \> Users \> Custom user attributes \> Add attribute]{.guihint}
eigene Felder erzeugen, die dann pro Benutzer individuell mit Werten
gefüllt werden können.
:::

::: paragraph
Das Anlegen eines neuen solchen Attributs bringt Sie zu folgendem
Dialog:
:::

:::: imageblock
::: content
![Dialog für benutzerdefinierte
Attribute.](../images/wato_user_custom_macro.png)
:::
::::

::: paragraph
Wie immer ist die ID ([Name]{.guihint}) später nicht änderbar, der Titel
([Title]{.guihint}) aber schon. Das [Topic]{.guihint} legt fest, in
welchen Abschnitt der Benutzereinstellungen das neue Feld einsortiert
wird. Ferner können Sie entscheiden, ob Benutzer das Feld selbst
editieren können (es wird dann in ihren persönlichen Einstellungen
auftauchen) und ob der Wert direkt in der Benutzertabelle angezeigt
werden soll.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Nur wenn Sie die Checkbox bei     |
|                                   | [Make this variable available in  |
|                                   | notifications]{.guihint}          |
|                                   | aktivieren, können Sie diesen     |
|                                   | Wert auch bei Benachrichtigungen  |
|                                   | verwenden. Denn dazu muss der     |
|                                   | Wert dem Monitoring-Kern (z.B.    |
|                                   | [CMC](cmc.html)) in einer         |
|                                   | Variablen (ein sogenanntes        |
|                                   | „Custom macro") bekannt gemacht   |
|                                   | werden.                           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Der Name der Custom-Variable wird aus der von Ihnen gewählten ID
abgeleitet. Diese wird in Großbuchstaben umgewandelt und es wird ein
`CONTACT_` vorangestellt. Aus einem `phone` wird dann also
`CONTACT_PHONE`. Beachten Sie, dass beim Übergeben der Variable über
Umgebungsvariablen dann nochmal ein `NOTIFY_` vorangestellt wird. Bei
Ihrem eigenen [Benachrichtigungsskript](notifications.html#scripts)
kommt die Variable dann also als `NOTIFY_CONTACT_PHONE` an.
:::
::::::::::
:::::::::::

:::::::::: sect1
## []{#_meldungen_an_benutzer_schreiben .hidden-anchor .sr-only}13. Meldungen an Benutzer schreiben {#heading__meldungen_an_benutzer_schreiben}

::::::::: sectionbody
::: paragraph
Im Artikel über [Benachrichtigungen](notifications.html) gehen wir sehr
ausführlich darauf ein, wie Checkmk die Kontakte über Probleme bei Hosts
oder Service informieren kann. Manchmal möchten Sie aber vielleicht alle
Benutzer (auch solche, die keine Kontakte sind) über Organisatorisches
in eigener Sache informieren --- z.B. über eine Wartung des
Checkmk-Systems selbst.
:::

::: paragraph
Für solche Zwecke bietet Checkmk ein kleines eingebautes Meldungstool,
das völlig getrennt von den Benachrichtigungen funktioniert. Das Tool
finden Sie über [Setup \> Users]{.guihint} und dort in [Users \> Send
user messages]{.guihint}. Hier haben Sie die Möglichkeit, eine Meldung
an alle (oder manche) Ihrer Benutzer zu schreiben.
:::

:::: imageblock
::: content
![Dialog für Benutzermeldungen.](../images/wato_user_notify_users.png)
:::
::::

::: paragraph
Dabei haben Sie die Wahl zwischen vier Meldungsarten:
:::

+-----------------------------------+-----------------------------------+
| [Show popup message]{.guihint}    | Beim nächsten Seitenaufruf des    |
|                                   | Benutzers wird ein Popup-Fenster  |
|                                   | mit der Nachricht geöffnet.       |
+-----------------------------------+-----------------------------------+
| [Show hint in the \'User\'        | Der Benutzer wird durch ein       |
| menu]{.guihint}                   | Zahlensymbol im                   |
|                                   | [User-Men                         |
|                                   | ü](user_interface.html#user_menu) |
|                                   | der Navigationsleiste auf die     |
|                                   | Nachricht hingewiesen.            |
+-----------------------------------+-----------------------------------+
| [Send email]{.guihint}            | Versendet eine E-Mail. Damit      |
|                                   | erreichen Sie aber nur Benutzer,  |
|                                   | bei denen auch eine               |
|                                   | E-Mail-Adresse konfiguriert ist.  |
+-----------------------------------+-----------------------------------+
| [Show in the dashboard element    | Die Nachricht wird in einem       |
| \'User messages\']{.guihint}      | [Dashlet](                        |
|                                   | dashboards.html#builtin_dashlets) |
|                                   | des Typs [User                    |
|                                   | messages]{.guihint} angezeigt.    |
+-----------------------------------+-----------------------------------+

::: paragraph
Mit [Message expiration]{.guihint} können Sie noch nicht abgerufene
Meldungen einfach löschen, sobald diese nicht mehr relevant sind.
:::
:::::::::
::::::::::

:::::: sect1
## []{#_weiterführende_themen .hidden-anchor .sr-only}14. Weiterführende Themen {#heading__weiterführende_themen}

::::: sectionbody
::: paragraph
Checkmk beherrscht noch weitere Spielarten der Anmeldung:
:::

::: ulist
- Anbindung von [LDAP/Active Directory](ldap.html)

- Authentifizierung mit [SAML](saml.html)

- Authentifizierung mit [Kerberos](kerberos.html)

- Authentifizierung in einem Aufbau mit Reverse-Proxy

- Authentifizierung mit HTTP Basic Authentication
:::
:::::
::::::

::::: sect1
## []{#files .hidden-anchor .sr-only}15. Dateien und Verzeichnisse {#heading_files}

:::: sectionbody
::: paragraph
Folgende Aufstellung zeigt Ihnen, welche Dateien und Verzeichnisse auf
dem Checkmk-Server mit der Benutzerverwaltung zu tun haben. Wie immer
sind alle Angaben hier relativ zum Instanzverzeichnis (z.B.
`/omd/sites/mysite`).
:::

+-------------------------------+--------------------------------------+
| Pfad                          | Bedeutung                            |
+===============================+======================================+
| `~/etc/htpasswd`              | Passwörter der Benutzer im           |
|                               | Apache-`htpasswd`-Format.            |
+-------------------------------+--------------------------------------+
| `~/etc/auth.secret`           | Diese Datei enthält ein zufälliges   |
|                               | Geheimnis, mit dem Anmelde-Cookies   |
|                               | signiert werden. In verteilten       |
|                               | Umgebungen soll diese Datei in allen |
|                               | Instanzen gleich sein --- und ist    |
|                               | dies auch, wenn Sie alles mit der    |
|                               | Weboberfläche einrichten. Wird diese |
|                               | Datei geändert, so werden alle       |
|                               | Anmeldungen sofort ungültig und      |
|                               | Benutzer müssen sich neu anmelden.   |
|                               | Diese Datei ist mit den Rechten      |
|                               | `660` versehen, da ein Lesezugriff   |
|                               | von Dritten das Fälschen einer       |
|                               | Anmeldung ermöglichen würde.         |
+-------------------------------+--------------------------------------+
| `~/etc/auth.serials`          | Seriennummern der Passwörter pro     |
|                               | Benutzer. Jede Änderung des          |
|                               | Passworts erhöht die Seriennummer    |
|                               | und macht damit alle aktuellen       |
|                               | Sitzungen ungültig. Damit ist        |
|                               | sichergestellt, dass eine            |
|                               | Passwortänderung einen Benutzer      |
|                               | zuverlässig abmeldet.                |
+-------------------------------+--------------------------------------+
| `~/etc/check_                 | Enthält die mit der                  |
| mk/multisite.d/wato/users.mk` | Konfigurationsumgebung               |
|                               | eingerichteten Benutzer. Hier sind   |
|                               | nur diejenigen Daten über die        |
|                               | Benutzer gespeichert, die sich rein  |
|                               | mit der GUI befassen. Manuelle       |
|                               | Änderungen in dieser Datei werden    |
|                               | sofort wirksam.                      |
+-------------------------------+--------------------------------------+
| `~/etc/chec                   | Kontaktinformationen der mit der     |
| k_mk/conf.d/wato/contacts.mk` | Konfigurationsumgebung               |
|                               | eingerichteten Benutzer. Hier sind   |
|                               | alle Daten abgelegt, die für die     |
|                               | Konfiguration des Monitoring-Kerns   |
|                               | relevant sind. Nur Benutzer, die     |
|                               | auch Kontakte sind, sind hier        |
|                               | aufgeführt. Damit manuelle           |
|                               | Änderungen hier wirksam werden, muss |
|                               | die neue Konfiguration in den Kern   |
|                               | geladen werden --- z.B. mit          |
|                               | `cmk -O`.                            |
+-------------------------------+--------------------------------------+
| `~/var/check_mk/web`          | Jeder Benutzer, der sich mindestens  |
|                               | einmal an der GUI angemeldet hat,    |
|                               | hat hier ein Unterverzeichnis, in    |
|                               | dem Dinge wie selbst erstellte       |
|                               | Ansichten und Berichte, die aktuelle |
|                               | Konfiguration der Seitenleiste und   |
|                               | vieles anderes in einzelnen kleinen  |
|                               | Dateien mit der Endung `.mk`         |
|                               | gespeichert sind. Diese Dateien      |
|                               | haben das Format Python.             |
+-------------------------------+--------------------------------------+
| `~/var/log/web.log`           | Logdatei der Benutzeroberfläche.     |
|                               | Hier finden Sie Fehlermeldungen      |
|                               | bezüglich Authentifizierung und      |
|                               | LDAP-Anbindung.                      |
+-------------------------------+--------------------------------------+
::::
:::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
