:::: {#header}
# Sicherheit (Security)

::: details
[Last modified on 29-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/security.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::: {#content}
::::::: {#preamble}
::: {#staticinfo}
Dies ist eine am 2025-05-04 21:12:21 +0000 für die Offline-Nutzung
exportierte Seite. Sie spiegelt möglicherweise nicht den aktuellen Stand
der Checkmk Dokumentation wider. Um eine täglich aktualisierte Version
dieser Seite anzusehen, rufen Sie bitte
[docs.checkmk.com](https://docs.checkmk.com/){target="_blank"} auf.
:::

::::: sectionbody
::: paragraph
Diesen Artikel vervollständigen wir nach und nach zu einer zentralen
Übersicht über alle Sicherheits-Features in Checkmk und Hilfen bei der
weiteren Absicherung.
:::

::: paragraph
Die gute Nachricht vorab: Checkmk verwendet schon immer eine
Architektur, die Sicherheitsbedürfnisse berücksichtigt und wo möglich
bereits in Standardeinstellungen verwendet. Dennoch gibt es Punkte, an
denen Eingriffe notwendig sind, beispielsweise wenn Schlüssel oder
Zertifikate erzeugt oder importiert werden müssen.
:::
:::::
:::::::

:::::::: sect1
## []{#agent_output .hidden-anchor .sr-only}1. Agentenausgabe {#heading_agent_output}

::::::: sectionbody
::: paragraph
Seit Version [2.1.0]{.new} bietet Checkmk TLS-Verschlüsselung an für die
Kommunikation zwischen Server und den Agenten auf Linux- und
Windows-Hosts. Details der Kommunikation beschreiben die beiden
folgenden Artikel:
:::

::: ulist
- [Linux überwachen](agent_linux.html)

- [Windows überwachen](agent_windows.html)
:::

::: paragraph
In bestimmten Konstellationen, in denen die TLS-Verschlüsselung bei
Linux- und Unix-Hosts nicht verwendet werden kann, haben Sie die
Möglichkeit, verschlüsselte Tunnel zu verwenden, beispielsweise per SSH:
:::

::: ulist
- [Linux überwachen und absichern im
  Legacy-Modus](agent_linux_legacy.html#ssh)

- [Datenquellenprogramme](datasource_programs.html)
:::
:::::::
::::::::

:::::: sect1
## []{#https .hidden-anchor .sr-only}2. HTTP(S)-Kommunikation {#heading_https}

::::: sectionbody
::: paragraph
An verschiedenen Stellen in Checkmk wird Kommunikation über HTTP
abgewickelt, sei es für die interne Kommunikation oder im verteilten
Monitoring. Setzen Sie wo immer möglich HTTPS ein:
:::

::: ulist
- [Weboberfläche mit HTTPS absichern](omd_https.html)

- [LDAP mit SSL absichern](ldap.html#ssl)

- [Appliance-GUI per TLS absichern](appliance_usage.html#ssl)

- [Docker mit HTTPS absichern](managing_docker.html#https)
:::
:::::
::::::

:::::: sect1
## []{#access_control .hidden-anchor .sr-only}3. Zugriffsschutz {#heading_access_control}

::::: sectionbody
::: paragraph
Checkmk bietet Anbindungen für verschiedene Authentifizierungsverfahren
und unterstützt für eine höhere Sicherheit auch
Zwei-Faktor-Authentifizierung:
:::

::: ulist
- [Benutzerverwaltung mit LDAP/Active Directory](ldap.html)

- [Zwei-Faktor-Authentifizierung der
  Checkmk-Benutzer](wato_user.html#2fa)

- [Single Sign-On mit Kerberos](kerberos.html)

- [Anmeldung mit SAML](saml.html)
:::
:::::
::::::

::::::::::: sect1
## []{#logging .hidden-anchor .sr-only}4. Logging {#heading_logging}

:::::::::: sectionbody
::: paragraph
Die Erkennung sicherheitsrelevanter Ereignisse erleichtert die Log-Datei
`security.log`. Hier werden Ereignisse beispielsweise aus den Bereichen
Authentifizierung, Benutzerverwaltung, Service (z. B. Start und Stopp
der [Instanz](glossar.html#site)) und Anwendungsfehler protokolliert.
Sie finden diese Log-Datei im Instanzverzeichnis, im folgenden mit
einigen beispielhaften Einträgen als Inhalt:
:::

::::: listingblock
::: title
\~/var/log/security.log
:::

::: content
``` {.pygments .highlight}
2024-04-02 19:12:33,891 [cmk_security.service 269382] {"summary": "site stopped", "details": {}}
2024-04-03 08:55:46,480 [cmk_security.service 5652] {"summary": "site started", "details": {}}
2024-04-03 09:21:18,830 [cmk_security.auth 8798] {"summary": "authentication succeeded", "details": {"method": "login_form", "user": "cmkadmin", "remote_ip": "127.0.0.1"}}
2024-04-03 15:41:20,499 [cmk_security.user_management 8798] {"summary": "user created", "details": {"affected_user": "myuser", "acting_user": "cmkadmin"}}
2024-04-03 16:36:04,099 [cmk_security.auth 1882076] {"summary": "authentication failed", "details": {"user_error": "Incorrect username or password. Please try again.", "method": "login_form", "user": "myuser", "remote_ip": "127.0.0.1"}}
2024-04-03 18:19:05,640 [cmk_security.application_errors 1882076] {"summary": "CSRF token validation failed", "details": {"user": "cmkadmin", "remote_ip": "127.0.0.1"}}
```
:::
:::::

::: paragraph
Jede Zeile ist so aufgebaut:
:::

::: ulist
- Datum und Uhrzeit (Ortszeit) der Erstellung des Log-Eintrags.

- Sicherheitsdomäne (z. B. `cmk_security.auth` ) und Prozess-ID.

- Die Meldung selbst als Zusammenfassung (`summary`) und detailliert
  (`details`), jeweils im JSON-Format. Der Inhalt der Details variiert
  je nach Sicherheitsdomäne.
:::

::: paragraph
Beachten Sie, dass sich die Inhalte der Log-Datei in Zukunft ändern
können, z. B. durch Hinzufügen weiterer Sicherheitsdomänen,
protokollierter Ereignisse oder der in den Details bereitgestellten
Informationen.
:::
::::::::::
:::::::::::
:::::::::::::::::::::::::::::::
