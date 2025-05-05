:::: {#header}
# Anmeldung mit SAML

::: details
[Last modified on 23-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/saml.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Benutzerverwaltung mit LDAP/Active Directory](ldap.html)
:::
::::
:::::
::::::
::::::::

:::::::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

::::::::: sectionbody
::: paragraph
In diesem Artikel erfahren Sie, wie Sie eine Anmeldung via *Secure
Assertion Markup Language* (SAML) einrichten.
:::

::: paragraph
SAML ist eine standardisierte Methode, externen Anwendungen und Diensten
mitzuteilen, dass ein Benutzer derjenige ist, der er zu sein behauptet.
Durch SAML wird Single Sign-On (SSO) möglich, denn man kann damit einen
Benutzer einmal authentifizieren und diese Authentifizierung dann an
mehrere Anwendungen übermitteln. Mit Hilfe der Verbindung und
Kommunikation zwischen sogenanntem „Service Provider" (SP) und
sogenanntem „Identity Provider" (IdP) wird es somit den Mitarbeitern
ermöglicht, mit nur einer einzigen Anmeldung auf verschiedene
Webanwendungen zuzugreifen. In der SAML-Architektur stellt der Service
Provider die Anwendung zur Verfügung und der Identity Provider verwaltet
die digitalen Identitäten der Benutzer.
:::

::: paragraph
SAML wird in den kommerziellen Editionen von Checkmk unterstützt und
kann dort direkt in der Checkmk-Weboberfläche eingerichtet werden. Die
Rolle des Service Providers übernimmt Checkmk. Als Identity Provider
(IdP) fungiert beispielhaft Entra ID, wie im [Kapitel zur
Einrichtung](#saml_cee) beschrieben.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Microsoft Entra ID (kurz: Entra   |
|                                   | ID) ist seit 2023 der neue Name   |
|                                   | für Azure Active Directory (Azure |
|                                   | AD). Die in diesem Artikel        |
|                                   | enthaltenen Screenshots und       |
|                                   | Inhalte von Konfigurationsdateien |
|                                   | verwenden aber noch den alten     |
|                                   | Namen Azure AD.                   |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
[![CRE](../images/CRE.svg){.icon-left}]{.image-inline} Bis zur
Checkmk-Version [2.2.0]{.new} wurde SAML alternativ auch mit dem
Apache-Modul `mod_auth_mellon` unterstützt und dieses als Bestandteil
der Checkmk-Software mit ausgeliefert. Beginnend mit Version
[2.3.0]{.new} ist `mod_auth_mellon` nicht mehr in der Checkmk-Software
enthalten. Wenn Sie als Benutzer von
[![CRE](../images/icons/CRE.png "Checkmk Raw"){width="20"}]{.image-inline}
**Checkmk Raw** SAML nutzen wollen, müssen Sie `mod_auth_mellon` daher
selbst installieren. Die darauf aufbauende Konfiguration ist im [Kapitel
zu Checkmk Raw](#saml_re) beschrieben. Sie wird aber von uns **nicht**
mehr unterstützt.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Die Thematik                      |
|                                   | Transportverschlüsselung          |
|                                   | (TLS/SSL) wird in den Beispielen  |
|                                   | nur in einer simplen,             |
|                                   | beispielhaften Umsetzung          |
|                                   | aufgenommen. In                   |
|                                   | Produktivumgebungen mit [eigener  |
|                                   | CA](https://checkmk.com/d         |
|                                   | e/blog/how-become-your-own-certif |
|                                   | icate-authority){target="_blank"} |
|                                   | und sorgfältiger                  |
|                                   | Zertifikatsbehandlung werden sich |
|                                   | entsprechende Abweichungen        |
|                                   | ergeben, die von Ihrer eigenen    |
|                                   | Infrastruktur abhängen.           |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::
:::::::::
::::::::::

:::::::::::::::: sect1
## []{#use_saml .hidden-anchor .sr-only}2. SAML in Checkmk nutzen {#heading_use_saml}

::::::::::::::: sectionbody
::: paragraph
Sobald Sie alle Punkte der Einrichtung durchlaufen haben, kann das
SAML-Login vom Benutzer in Checkmk verwendet werden. Die
Button-Beschriftung kann verändert werden, wie [unten
beschrieben.](#configure_saml)
:::

:::: imageblock
::: content
![Checkmk Login mit SAML-Button.](../images/saml_login.png){width="55%"}
:::
::::

::: paragraph
Jeder durch SAML berechtigte Benutzer wird automatisch in Checkmk
angelegt, sobald er sich das erste Mal dort anmeldet. Vorausgesetzt, es
gibt nicht bereits einen Benutzer mit der gleichen ID. Sollte bereits
ein Benutzer mit gleicher ID vorhanden sein, so wird die aktuelle
Erstellung des Benutzers abgelehnt.
:::

::: paragraph
Die Benutzerdaten werden bei jeder Checkmk-Anmeldung des Benutzers
synchronisiert.
:::

::: paragraph
Damit SAML funktioniert, müssen mehrere Voraussetzungen erfüllt sein:
:::

::: ulist
- Die [Weboberfläche muss mit HTTPS abgesichert](omd_https.html) sein.
  HTTP-Adressen werden aus Sicherheitsgründen nicht akzeptiert.

- Checkmks SAML-Endpunkte für ID/Metadaten und Antworten (Assertion
  Consumer Service) müssen beim IdP registriert worden sein. Wie dies
  geschehen kann, zeigen wir weiter unten.

- Nachrichten, die der IdP an Checkmk richtet --- Antworten auf
  Authentifizierungsanfragen (nur für die Assertion zwingend) und
  Attributangaben --- müssen mit einem der [unterstützten
  Algorithmen](#supported_algorithms) signiert sein.
:::

::::::: sect2
### []{#supported_algorithms .hidden-anchor .sr-only}2.1. Unterstützte Algorithmen {#heading_supported_algorithms}

::: paragraph
Für die Kommunikation mit dem IdP akzeptiert Checkmk die folgenden
Algorithmen:
:::

::: ulist
- RSA-SHA256

- RSA-SHA384

- RSA-SHA512

- ECDSA-SHA256

- ECDSA-SHA384

- ECDSA-SHA512
:::

::: paragraph
Checkmk selber nutzt RSA-SHA256 für die Signierung seiner Anfragen.
:::

::: paragraph
Sollte der IdP für seine Antwort keinen der genannten Algorithmen
verwenden, so wird seine Antwort von Checkmk abgewiesen.
:::
:::::::
:::::::::::::::
::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#saml_cee .hidden-anchor .sr-only}3. SAML einrichten {#heading_saml_cee}

::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Um SAML in den kommerziellen Editionen nutzen zu können, muss erst der
IdP eingerichtet werden, in unserem Beispiel ist das Entra ID (hieß bis
2023 Azure Active Directory). Danach wird der SP, also Checkmk, mit den
benötigten Informationen versorgt.
:::

:::::::::::::::::::::::: sect2
### []{#access_azure .hidden-anchor .sr-only}3.1. Anmeldung in Entra ID {#heading_access_azure}

::::::::::::::::: sect3
#### []{#_checkmk_saml_service_in_entra_id_registrieren .hidden-anchor .sr-only}Checkmk-SAML-Service in Entra ID registrieren {#heading__checkmk_saml_service_in_entra_id_registrieren}

::: paragraph
Als nächstes wird der Checkmk-SAML-Service bei Entra ID registriert.
Rufen Sie hierfür [Enterprise applications \> Create your own
application]{.guihint} auf.
:::

:::: imageblock
::: content
![Erstellung einer eigenen Applikation in Entra
ID.](../images/saml_azure_own_application.png)
:::
::::

::: paragraph
Vergeben Sie einen beliebigen Namen, z.B. `checkmk-saml`. Wir empfehlen,
die Applikation nicht `checkmk` zu nennen, um Verwechslungen mit dem
Checkmk-Agenten zu vermeiden.
:::

::: paragraph
Wählen Sie die Option [Integrate any other application you don't find in
the gallery (Non-gallery)]{.guihint} und klicken Sie danach auf den
Button [Create.]{.guihint}
:::

::: paragraph
Auf der Entra ID-Übersichtsseite haben Sie damit folgende Funktion
angelegt: [Single sign-on \> SAML \> Basic SAML
Configuration:]{.guihint}
:::

:::: imageblock
::: content
![Übersicht der Applikationsdaten in Entra
ID.](../images/saml_azure_sign_on.png)
:::
::::

::: paragraph
Jetzt benötigt Entra ID noch zwei weitere Angaben:
:::

::: ulist
- den [Identifier (Entity ID)]{.guihint} im Format
  `https://myserver.com/mysite/check_mk/saml_metadata.py` und

- die [Reply URL (Assertion Consumer Service URL)]{.guihint} im Format
  `https://myserver.com/mysite/check_mk/saml_acs.py?acs`.
:::

::: paragraph
Alle anderen Optionen lassen Sie unangetastet auf dem Default-Wert bzw.
leer. Insbesondere der [Relay State]{.guihint} in der [Basic SAML
Configuration]{.guihint} muss unverändert bleiben, da sonst SAML nicht
funktioniert.
:::

::: paragraph
Rufen Sie nun [Edit \> Signing Option \> Sign SAML assertion]{.guihint}
auf, um Entra ID für die Antworten und Verifizierungen zu konfigurieren:
:::

:::: imageblock
::: content
![SAML Zugangsdaten in Entra
ID.](../images/saml_signing_certificate.png)
:::
::::
:::::::::::::::::

:::::::: sect3
#### []{#url_from_azure .hidden-anchor .sr-only}SAML-Informationen aus Entra ID erhalten {#heading_url_from_azure}

::: paragraph
Als nächstes suchen Sie jetzt in Entra ID die SAML-Informationen, die
Sie für Checkmk brauchen.
:::

::: paragraph
Und zwar in der Ansicht [Enterprise applications \| All applications \>
Browse Microsoft Entra Gallery \> checkmk-saml \| SAML-based
Sign-On]{.guihint} (siehe oben):
:::

::: ulist
- Im Kasten [SAML Certificates]{.guihint} finden Sie die [App Federation
  Metadata Url.]{.guihint} Diese benötigen Sie im nächsten Abschnitt für
  die Einrichtung von SAML in Checkmk [(Identity provider
  metadata)]{.guihint}.

- Über den Kasten [Attributes & Claims]{.guihint} gelangen Sie zu einer
  Ansicht der Benutzerattribute für Checkmk, z.B. E-Mail-Adresse, Vor-
  und Nachname:
:::

:::: imageblock
::: content
![Ansicht der Benutzerattribute in Entra
ID.](../images/saml_attributes_claims.png)
:::
::::
::::::::
::::::::::::::::::::::::

::::::::::::::::::::::: sect2
### []{#configure_saml .hidden-anchor .sr-only}3.2. SAML in der Checkmk-Weboberfläche aktivieren {#heading_configure_saml}

::: paragraph
Mit den zuvor ermittelten Informationen richten Sie die SAML-Verbindung
auf der Checkmk-Seite ein.
:::

::: paragraph
Falls nötig, fügen Sie vorab das TLS-Zertifikat Ihres IdPs in Checkmk zu
den vertrauenswürdigen Zertifikaten hinzu, indem Sie es unter [Setup \>
Global settings \> Trusted certificate authorities for SSL]{.guihint}
eintragen.
:::

::: paragraph
Öffnen Sie nun [Setup \> Users \> SAML authentication.]{.guihint} Nutzen
Sie dort [Add connection,]{.guihint} um die Konfiguration einer neuen
Verbindung zu beginnen:
:::

:::: imageblock
::: content
![Die SAML-Verbindung in
Checkmk.](../images/saml_saml_authentication.png)
:::
::::

::: paragraph
Vergeben Sie für die neue Verbindung eine [Connection ID]{.guihint} und
einen Namen. Der [Name]{.guihint} wird hinterher für die [Benennung des
Checkmk-Anmeldeknopfs](#use_saml) genutzt.
:::

::: paragraph
Als nächstes legen Sie im Kasten [Security]{.guihint} fest, ob Sie die
Zugriffsverbindungen mit Checkmk- oder mit eigenen Zertifikaten
absichern wollen:
:::

:::: imageblock
::: content
![Auswahl des Zertifikats für SAML.](../images/saml_security.png)
:::
::::

::: paragraph
Nutzen Sie eigene Zertifikate, so müssen Sie den [Private key]{.guihint}
sowie das [Certificate]{.guihint} angeben. Eigene Zertifikate werden im
Instanzverzeichnis unter `~/etc/ssl/saml2/custom/` abgelegt.
:::

::: paragraph
Danach tragen Sie im Kasten [Connection]{.guihint} als [Identity
provider metadata]{.guihint} die URL (z.B. App Federation Metadata URL)
ein, die Sie im [vorherigen Abschnitt](#access_azure) herausgesucht
haben:
:::

:::: imageblock
::: content
![Eingabe der Verbindungsdaten.](../images/saml_connection.png)
:::
::::

::: paragraph
Alternativ können Sie die Metadaten-XML-Datei auch direkt aus Entra ID
herunter- und im obigen Dialog hochladen durch Auswahl des Eintrags
[Upload XML file]{.guihint} unter [Identity provider
metadata.]{.guihint} Das ist zum Beispiel dann praktisch, wenn Ihr
Checkmk-Server keinen Zugriff auf das Internet hat. Geben Sie für die
zwingend benötigte [Checkmk server URL]{.guihint} die Adresse ein, über
die Sie --- nicht Entra ID --- normalerweise auf Checkmk zugreifen, z.B.
`https://myserver.com`.
:::

::: paragraph
Nun benötigen Sie im Kasten [Users]{.guihint} noch die Angaben zum
Benutzer:
:::

:::: imageblock
::: content
![Eingabe der Benutzerinformationen.](../images/saml_users.png)
:::
::::

::: paragraph
Auch diese Angaben müssen Sie, wie im [vorherigen
Abschnitt](#access_azure) beschrieben, heraussuchen. Wichtig ist
hierbei, dass [User ID attribute]{.guihint} unbedingt eindeutig sein
muss, z.B. die User-ID. Checkmk benötigt hier für jede Angabe den
kompletten [claim name]{.guihint} aus Entra ID, also die mit `http`
beginnende Adresse, beispielsweise für die User-ID in obigem Beispiel
`http://schemas.xmlsoap.org/ws/2005/05/identity/claims/userID`.
:::

::: paragraph
Um die Zuständigkeiten für alle Benutzer, die sich mit SAML
authentisieren, in Checkmk zu regeln, kann jeder Benutzer einer bzw.
mehreren [Kontaktgruppen zugeordnet](wato_user.html#contact_groups)
werden. Sie haben verschiedene Möglichkeiten, die Zuordnung in den
[Contact groups]{.guihint} zu definieren.
:::

::: paragraph
Über die [Roles]{.guihint} können Sie Benutzer gezielt verschiedenen
Rollen zuweisen, um hiermit normale Benutzer, Administratoren etc.
festzulegen.
:::
:::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#saml_re .hidden-anchor .sr-only}4. SAML in Checkmk Raw {#heading_saml_re}

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: {.admonitionblock .important}
+-----------------------------------+-----------------------------------+
| ![Importan                        | ::: paragraph                     |
| t](../images/icons/important.png) | Die in diesem Kapitel             |
|                                   | beschriebene Konfiguration ist    |
|                                   | nur für Benutzer von Checkmk Raw  |
|                                   | von Interesse, welche die in den  |
|                                   | kommerziellen Editionen von       |
|                                   | Checkmk eingebaute                |
|                                   | [SAML-Anbindung](#saml_cee) nicht |
|                                   | nutzen können. Voraussetzung ist, |
|                                   | dass Sie das Apache-Modul         |
|                                   | `mod_auth_mellon`, das nicht mit  |
|                                   | der Checkmk-Software ausgeliefert |
|                                   | wird, systemweit nach der         |
|                                   | [Anleitung auf der                |
|                                   | Projektse                         |
|                                   | ite](https://github.com/latchset/ |
|                                   | mod_auth_mellon){target="_blank"} |
|                                   | installiert haben. Die darauf     |
|                                   | aufbauende Konfiguration wird in  |
|                                   | diesem Kapitel beschrieben. Die   |
|                                   | SAML-Anbindung über               |
|                                   | `mod_auth_mellon` wird von uns    |
|                                   | aber nicht mehr unterstützt.      |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Die folgenden Abschnitte beschreiben lediglich die Konfiguration von
`mod_auth_mellon` für unterschiedliche, bereits laufende IdPs,
exemplarisch anhand von Active Directory Federation Services (ADFS). Die
Anbindung in Checkmk selbst beschränkt sich auf den letzten Schritt aus
der ADFS-Anleitung. Auf dem Checkmk-Server sorgt `mod_auth_mellon` als
Service Provider für die Authentifizierung.
:::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect2
### []{#_anmeldung_mit_active_directory_federation_services .hidden-anchor .sr-only}4.1. Anmeldung mit Active Directory Federation Services {#heading__anmeldung_mit_active_directory_federation_services}

:::::::: sect3
#### []{#_voraussetzungen .hidden-anchor .sr-only}Voraussetzungen {#heading__voraussetzungen}

::: paragraph
Die Anmeldung an Checkmk mittels Active Directory ist im Grunde relativ
simpel: Active Directory Federation Services (ADFS) dient als Identity
Provider (IdP), Checkmk übernimmt die SAML-Authentifizierung.
:::

::: paragraph
Voraussetzungen für diese Anleitung sind entsprechend:
:::

::: ulist
- Funktionierende LDAP-AD-Integration

- Funktionierendes ADFS als IdP

- Checkmk-Server mit SSL

- Ein unterstütztes Betriebssystem
:::

::: paragraph
Die Einrichtung erfolgt in drei Schritten:
:::

::: {.olist .arabic}
1.  Konfiguration von Apache (ein Ergebnis: XML-Datei mit Metadaten).

2.  Konfiguration von ADFS: Relying Party Trust mit Mellon-Metadaten
    einrichten.

3.  Aktivierung des Logins in Checkmk selbst.
:::
::::::::

:::::::::::::::::::::::::::::::::::: sect3
#### []{#_apache_konfigurieren .hidden-anchor .sr-only}Apache konfigurieren {#heading__apache_konfigurieren}

::: paragraph
Es geht hier natürlich um die Konfiguration des Instanz-eigenen
Apache-Servers, loggen Sie sich also zunächst dort ein:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# omd su mysite
```
:::
::::

::: paragraph
Erstellen Sie nun ein Verzeichnis für `mod_auth_mellon` und wechseln Sie
in das Verzeichnis:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ mkdir etc/apache/mellon
OMD[mysite]:~$ cd etc/apache/mellon
```
:::
::::

::: paragraph
Führen Sie nun `mellon_create_metadata` unter Angabe Ihres Servers sowie
Ihrer Instanz mit dem Zusatz `mellon` aus:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ mellon_create_metadata https://myserver "https://myserver/mysite/mellon"
```
:::
::::

::: paragraph
Das Modul erzeugt dabei drei Dateien: Zertifikat (`.cert`), Schlüssel
(`.key`) und statische Metadaten (`.xml`). Die XML-Datei wird nicht
benötigt und kann gelöscht werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ rm *.xml
```
:::
::::

::: paragraph
Benennen Sie die Schlüssel- und Zertifikatsdateien der Einfachheit
halber um:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ mv .key mellon.key
OMD[mysite]:~/etc/apache/mellon$ mv .cert mellon.cert
```
:::
::::

::: paragraph
Nun besorgen Sie die benötigten Metadaten direkt von Ihrem ADFS-Server
(hier `myadfs`) und speichern sie als `idp-metadata.xml`:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ wget --no-check-certificate -O ./idp-metadata.xml https://myadfs/FederationMetadata/2007-06/FederationMetadata.xml
```
:::
::::

::: paragraph
Nun benötigen Sie das öffentliche Zertifikat des ADFS-Servers, das in
der Datei `idp-public-key.pem` gespeichert wird:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ echo -n | openssl s_client -connect myadfs:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -pubkey -noout > idp-public-key.pem
```
:::
::::

::: paragraph
Nur für den Fall, dass Sie sich über das `echo -n` wundern: Darüber wird
die folgende SSL-Sitzung terminiert.
:::

::: {.admonitionblock .tip}
+-----------------------------------+-----------------------------------+
| ![Tip](../images/icons/tip.png)   | ::: paragraph                     |
|                                   | Das Zertifikat sollte oder muss   |
|                                   | gar in den Trust Store            |
|                                   | hochgeladen werden, für den Fall, |
|                                   | dass zum Beispiel der IdP-Service |
|                                   | die Zertifikatskette prüft.       |
|                                   | Weitere Informationen zum Thema   |
|                                   | finden Sie im                     |
|                                   | [HTTPS-Artikel.](omd_https.html)  |
|                                   | :::                               |
+-----------------------------------+-----------------------------------+
:::

::: paragraph
Als letzten Schritt ersetzen Sie die
Authentifizierungskonfigurationsdatei `~/etc/apache/conf.d/auth.conf`
mit der folgenden Variante --- natürlich unter Angabe Ihres
Checkmk-Servers (hier `myserver`) und Ihrer Instanz (hier `mysite`).
Beachten Sie in der folgenden Beispielkonfiguration, dass in der mit
`LoadModule` beginnenden Zeile der Pfad des Installationsverzeichnisses
je nach verwendeter Distribution variieren kann:
:::

::::: listingblock
::: title
\~/etc/apache/conf.d/auth.conf
:::

::: content
``` {.pygments .highlight}
# Set this to the Name of your Checkmk site, e.g.
#Define SITE
Define SITE mysite

# ServerName from listen-ports.conf needs to be overwritten here
# and being set to the URL of the real server. auth_mellon uses this
# to generate the needed URLs in the metadata
ServerName https://myserver

# Load the module.
<IfModule !mod_auth_mellon.c>

    LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so

</IfModule>

# Only enable this for debugging purposes
#MellonDiagnosticsFile /opt/omd/sites/${SITE}/tmp/mellon_diagnostics.txt
#MellonDiagnosticsEnable On

<Location /${SITE}>

    # Use SAML auth only in case there is no Checkmk authentication
    # cookie provided by the user and whitelist also some other required URLs
    <If "! %{HTTP_COOKIE} =~ /^(.*;)?auth_${SITE}/ && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/register_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/deploy_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/run_cron.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/restapi.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/automation.py' && \
        ! %{REQUEST_URI} -strmatch '/${SITE}/check_mk/api/*' && \
        ! %{REQUEST_URI} = '/${SITE}check_mk/ajax_graph_images.py' && \
        ! %{QUERY_STRING} =~ /(_secret=|auth_|register_agent)/ && \
        ! %{REQUEST_URI} =~ m#^/${SITE}/(omd/|check_mk/((images|themes)/.*\.(png|svg)|login\.py|.*\.(css|js)))# ">

        MellonIdPMetadataFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-metadata.xml
        MellonIdPPublicKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-public-key.pem
        MellonSPCertFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.cert
        MellonSPPrivateKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.key
        MellonEndpointPath "/${SITE}/mellon"
        MellonDefaultLoginPath "/${SITE}/check_mk/"

        Order allow,deny
        Allow from all

        MellonSecureCookie On
        MellonCookieSameSite None

        AuthType Mellon
        AuthName "Checkmk SAML Login"
        MellonEnable auth
        Require valid-user

        # Get Username
        # ADFS sends username as DOMAIN\username pair.
        # Checkmk just wants the username.
        RewriteEngine on
        RequestHeader set X-Remote-User "expr=%{REMOTE_USER}"
        RequestHeader edit X-Remote-User "^.*\\\(.*)$" "$1"

        # When SAML auth fails, show the login page to the user. This should only happen,
        # if e.g. the mellon cookie is lost/rejected or if the IDP is misconfigured.
        # A failed login at the IDP will not return you here at all.

    ErrorDocument 401 '<html> \
      <head> \
        <meta http-equiv="refresh" content="1; URL=/${SITE}/check_mk/login.py"> \
      </head> \
      <body> \
        SAML authentication failed, redirecting to login page. \
        <a href="/${SITE}/check_mk/login.py">Click here</a>. \
      </body> \
    </html>'

    </If>

    # This header is also needed after authentication (outside of the If clause)
    RequestHeader set X-Remote-User "expr=%{REMOTE_USER}"
    RequestHeader edit X-Remote-User "^.*\\\(.*)$" "$1"

</Location>
```
:::
:::::

::: paragraph
Anschließend starten Sie Apache neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ omd restart apache
```
:::
::::

::: paragraph
Zu guter Letzt laden Sie nun die dynamisch erstellten Mellon-Metadaten
als XML-Datei herunter, um sie gleich im AD-Management importieren zu
können:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~/etc/apache/mellon$ wget https://myserver/mysite/mellon/metadata -o metadata.xml
```
:::
::::
::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::: sect3
#### []{#_active_directory_konfigurieren .hidden-anchor .sr-only}Active Directory konfigurieren {#heading__active_directory_konfigurieren}

::: paragraph
Um einen Relying Party Trust in ADFS anzulegen, gehen Sie wie folgt vor:
:::

::: paragraph
Starten Sie die ADFS-Oberfläche:
:::

:::: {.imageblock .border}
::: content
![saml adfs 01](../images/saml_adfs_01.png)
:::
::::

::: paragraph
Klicken Sie auf [Add Relying Party Trust:]{.guihint}
:::

:::: {.imageblock .border}
::: content
![saml adfs 02](../images/saml_adfs_02.png)
:::
::::

::: paragraph
Belassen Sie die Option auf [Claims aware]{.guihint} und fahren Sie mit
dem Start-Knopf fort:
:::

:::: {.imageblock .border}
::: content
![saml adfs 03](../images/saml_adfs_03.png)
:::
::::

::: paragraph
Wählen Sie nun [Import data about the relying party from a
file]{.guihint} und geben Sie die eben heruntergeladene XML-Datei an:
:::

:::: {.imageblock .border}
::: content
![saml adfs 04](../images/saml_adfs_04.png)
:::
::::

::: paragraph
Die [AD FS Management]{.guihint}-Warnung können Sie getrost ignorieren:
:::

:::: {.imageblock .border}
::: content
![saml adfs 05](../images/saml_adfs_05.png)
:::
::::

::: paragraph
Unter [Specify Display Name]{.guihint} geben Sie nun `Checkmk` als Namen
ein:
:::

:::: {.imageblock .border}
::: content
![saml adfs 06](../images/saml_adfs_06.png)
:::
::::

::: paragraph
Bei der Rechtevergabe können Sie **zum Testen** zunächst für [Choose
Access Control Policy]{.guihint} den Wert [Permit everyone]{.guihint}
wählen; später sollten Sie nach [Permit specific group]{.guihint}
ändern.
:::

:::: {.imageblock .border}
::: content
![saml adfs 07](../images/saml_adfs_07.png)
:::
::::

::: paragraph
Bestätigen Sie die Zusammenfassung unter [Ready to Add Trust]{.guihint}:
:::

:::: {.imageblock .border}
::: content
![saml adfs 08](../images/saml_adfs_08.png)
:::
::::

::: paragraph
Bestätigen Sie abschließend den [Finish]{.guihint}-Dialog und behalten
Sie das Häkchen bei [Configure claims issuance policy for this
application:]{.guihint}
:::

:::: {.imageblock .border}
::: content
![saml adfs 09](../images/saml_adfs_09.png)
:::
::::

::: paragraph
Wählen Sie den eben erstellten Relying Party Trust aus und starten Sie
dann den Editor mit [Edit Claim Issuance Policy...​ :]{.guihint}
:::

:::: {.imageblock .border}
::: content
![saml adfs 10](../images/saml_adfs_10.png)
:::
::::

::: paragraph
Fügen Sie im folgenden Dialog über [Add Rule...​]{.guihint} eine neue
Regel hinzu:
:::

:::: {.imageblock .border}
::: content
![saml adfs 11](../images/saml_adfs_11.png)
:::
::::

::: paragraph
Im ersten Schritt [Select Rule Template]{.guihint} wählen Sie [Transform
an Incoming Claim]{.guihint} und bestätigen:
:::

:::: {.imageblock .border}
::: content
![saml adfs 12](../images/saml_adfs_12.png)
:::
::::

::: paragraph
Im zweiten Schritt [Configure Rule]{.guihint} setzen Sie folgende Werte:
:::

::: ulist
- [Incoming claim type:]{.guihint} `Windows account name`

- [Outgoing claim type:]{.guihint} `Name ID`

- [Outgoing name ID format:]{.guihint} `Transient Identifier`
:::

:::: {.imageblock .border}
::: content
![saml adfs 13](../images/saml_adfs_13.png)
:::
::::

::: paragraph
Damit ist auch die ADFS-Konfiguration abgeschlossen. FS kann nun aus der
Windows-Authentifizierung die Authentifizierung für Checkmk ableiten,
das Sie im nächsten Schritt anweisen, Benutzer über HTTP-Anfragen zu
authentifizieren.
:::
:::::::::::::::::::::::::::::::::::::::::::::

:::::: sect3
#### []{#_checkmk_konfigurieren .hidden-anchor .sr-only}Checkmk konfigurieren {#heading__checkmk_konfigurieren}

::: paragraph
In Checkmk aktivieren Sie nun unter [Setup \> General \> Global Settings
\> User Interface \> Authenticate users by incoming HTTP
requests]{.guihint} bei [Current settings]{.guihint} die Option
[Activate HTTP header authentication]{.guihint}:
:::

:::: imageblock
::: content
![saml adfs cmk](../images/saml_adfs_cmk.png)
:::
::::
::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::: sect2
### []{#_ergänzende_informationen_zu_anderen_systemen .hidden-anchor .sr-only}4.2. Ergänzende Informationen zu anderen Systemen {#heading__ergänzende_informationen_zu_anderen_systemen}

:::::::::: sect3
#### []{#_entra_id_mit_mod_auth_mellon .hidden-anchor .sr-only}Entra ID mit mod_auth_mellon {#heading__entra_id_mit_mod_auth_mellon}

::: paragraph
Wenn Entra ID (hieß bis 2023 Azure Active Directory) als IdP fungiert,
ergeben sich einige Änderungen, beispielsweise kann der Benutzername
direkt gesetzt werden, ohne umgeschrieben zu werden.
:::

::: paragraph
Voraussetzungen für die folgende Beispielkonfiguration:
:::

::: ulist
- UserPrincipalName in LDAP-Verbindung als Identifier setzen (weitere
  Informationen in der
  [Microsoft-Dokumentation](https://learn.microsoft.com/de-de/windows/win32/adschema/a-userprincipalname){target="_blank"}).

- Custom Enterprise App in Entra ID mit UserPrincipalName als
  \'name\'-Attribut (auch dazu mehr in der
  [Microsoft-Dokumentation](https://learn.microsoft.com/de-de/entra/identity/enterprise-apps/add-application-portal){target="_blank"}).
:::

::: paragraph
Beachten Sie in der folgenden Beispielkonfiguration, dass in der mit
`LoadModule` beginnenden Zeile der Pfad des Installationsverzeichnisses
je nach verwendeter Distribution variieren kann:
:::

::::: listingblock
::: title
\~/etc/apache/conf.d/auth.conf
:::

::: content
``` {.pygments .highlight}
#Set this to the Name of your Checkmk site, e.g.
# Define SITE mysite
Define SITE mysite

# ServerName from listen-ports.conf needs to be overwritten here
# and being set to the URL of the real server.
# auth_mellon uses this to generate the needed URLs in the metadata.
ServerName https://myserver

# Load the module.
<IfModule !mod_auth_mellon.c>

    LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so

</IfModule>

# Only enable this for debugging purposes
# MellonDiagnosticsFile /opt/omd/sites/${SITE}/tmp/mellon_diagnostics.log
# MellonDiagnosticsEnable On

<Location /${SITE}>

    # Use SAML auth only in case there is no Checkmk authentication
    # cookie provided by the user and whitelist also some other required URLs.
   <If "! %{HTTP_COOKIE} =~ /^auth_${SITE}/ && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/register_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/restapi.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/run_cron.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/automation.py' && \
        ! %{REQUEST_URI} -strmatch '/${SITE}/check_mk/api/*' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/deploy_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}check_mk/ajax_graph_images.py' && \
        ! %{QUERY_STRING} =~ /(_secret=|auth_|register_agent)/ && \
        ! %{REQUEST_URI} =~ m#^/${SITE}/(omd/|check_mk/((images|themes)/.*\.(png|svg)|login\.py|.*\.(css|js)))# ">

        RequestHeader unset X-Remote-User
        MellonIdPMetadataFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-metadata.xml
        # Azure-AD-specific: Not needed because in metadata:
        #MellonIdPPublicKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-public-key.pem
        MellonSPCertFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.cert
        MellonSPPrivateKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.key
        MellonEndpointPath "/${SITE}/mellon"
        MellonDefaultLoginPath "/${SITE}/check_mk/"

        Order allow,deny
        Allow from all

        MellonSecureCookie On
        MellonCookieSameSite None

        AuthType Mellon
        MellonEnable auth
        require valid-user

        # Azure-AD-specific:
        # Get Username
        # If your assertion offers the username for Checkmk in an attribute you can set it directly as the remote user (REMOTE_USER):
        MellonUser "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
        RequestHeader set X-Remote-User "%{MELLON_http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name}e" env=MELLON_http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name

        # When SAML auth fails, show the login page to the user. This should only happen, if e.g. the mellon cookie is lost/rejected or if the IDP is misconfigured.
        # A failed login at the IDP will not return you here at all.
        ErrorDocument 401 '<html> \
          <head> \
            <meta http-equiv="refresh" content="1; URL=/${SITE}/check_mk/login.py"> \
          </head> \
          <body> \
            SAML authentication failed, redirecting to login page. \
            <a href="/${SITE}/check_mk/login.py">Click here</a>. \
          </body> \
        </html>'

    </If>

    # Azure-AD-specific:
    # This header is also needed after authentication (outside of the If clause)
    RequestHeader set X-Remote-User "%{MELLON_http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name}e" env=MELLON_http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name

</Location>
```
:::
:::::
::::::::::

:::::::: sect3
#### []{#_netiq_access_manager .hidden-anchor .sr-only}NetIQ Access Manager {#heading__netiq_access_manager}

::: paragraph
Wenn NetIQ Access Manager als IdP fungiert, ergeben sich einige
Änderungen, beispielsweise kann der Benutzername direkt gesetzt werden,
ohne umgeschrieben zu werden.
:::

::: paragraph
Beachten Sie in der folgenden Beispielkonfiguration, dass in der mit
`LoadModule` beginnenden Zeile der Pfad des Installationsverzeichnisses
je nach verwendeter Distribution variieren kann:
:::

::::: listingblock
::: title
\~/etc/apache/conf.d/auth.conf
:::

::: content
``` {.pygments .highlight}
# Set this to the Name of your Checkmk site, e.g.# Define SITE mysite
# Define SITE mysite
Define SITE mysite

# ServerName from listen-ports.conf needs to be overwritten here
# and being set to the URL of the real server. auth_mellon uses this to generate the needed URLs in the metadata.

ServerName https://myserver.mydomain.tld

# Load the module.
<IfModule !mod_auth_mellon.c>

    LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so

</IfModule>

# Only enable this for debugging purposes
#MellonDiagnosticsFile /opt/omd/sites/${SITE}/tmp/mellon_diagnostics.log
#MellonDiagnosticsEnable On

<Location /${SITE}>

    # Use SAML auth only in case there is no Checkmk authentication
    # Cookie provided by the user and whitelist also some other required URLs.

    <If "! %{HTTP_COOKIE} =~ /^auth_${SITE}/ && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/register_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/run_cron.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/deploy_agent.py' && \
        ! %{REQUEST_URI} = '/${SITE}/check_mk/restapi.py' && \
        ! %{REQUEST_URI} -strmatch '/${SITE}/check_mk/api/*' && \
        ! %{REQUEST_URI} = '/${SITE}check_mk/ajax_graph_images.py' && \
        ! %{QUERY_STRING} =~ /(_secret=|auth_|register_agent)/ && \
        ! %{REQUEST_URI} =~ m#^/${SITE}/(omd/|check_mk/((images|themes)/.*\.(png|svg)|login\.py|.*\.(css|js)))# ">

        MellonIdPMetadataFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-metadata.xml
        # NetIQ-specific: Not needed because in metadata:
        #MellonIdPPublicKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/idp-public-key.pem
        MellonSPCertFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.cert
        MellonSPPrivateKeyFile /opt/omd/sites/${SITE}/etc/apache/mellon/mellon.key
        MellonEndpointPath "/${SITE}/mellon"
        MellonDefaultLoginPath "/${SITE}/check_mk/"

        Order allow,deny
        Allow from all

        MellonSecureCookie On
        MellonCookieSameSite None

        AuthType Mellon
        MellonEnable auth
        require valid-user


        # NetIQ-specific:
        # Even though it is set as 'optional' in https://docs.oasis-open.org/security/saml/v2.0/saml-metadata-2.0-os.pdf
        # a NetIQ Access Manager requires it to be set.
        # Specified in oasis link above - line 396
        MellonOrganizationName "<countrycode>" "<your organisation name>"
        # Specified in oasis link above - line 443 / 452
        MellonOrganizationURL  "<countrycode>" "<your organisation url>"
        # Specified in oasis link above - line 454
        MellonOrganizationDisplayName "<countrycode>" "<your organisation display name>"

        # NetIQ-specific:
        # If your assertion offers the username for Checkmk in an attribute you can set it directly as the remote user (REMOTE_USER)
        MellonUser "myusername"

        # NetIQ-specific:
        # If the assertion does contain the username (and was set to MellonUser) then you can set the header directly.
        RequestHeader set X-Remote-User "expr=%{REMOTE_USER}"

    # When SAML auth fails, show the login page to the user. This should only happen,
    # if e.g. the mellon cookie is lost/rejected or if the IDP is misconfigured.
    # A failed login at the IDP will not return you here at all.
        ErrorDocument 401 '<html> \
          <head> \
            <meta http-equiv="refresh" content="1; URL=/${SITE}/check_mk/login.py"> \
          </head> \
          <body> \
            SAML authentication failed, redirecting to login page. \
            <a href="/${SITE}/check_mk/login.py">Click here</a>. \
          </body> \
        </html>'

# This header is also needed after authentication (outside of the If clause)
RequestHeader set X-Remote-User "expr=%{REMOTE_USER}"

</Location>
```
:::
:::::
::::::::
:::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::: sect1
## []{#migration .hidden-anchor .sr-only}5. Bestehende Benutzer migrieren {#heading_migration}

::::::::: sectionbody
::: paragraph
Nachdem Sie SAML aktiviert haben, können Sie bestehende Benutzer von
einer Passwort-basierten Verbindung auf die SAML-Verbindung migrieren.
Setzen Sie dafür in der Benutzerverwaltung unter [Setup \> Users \>
Users]{.guihint} Häkchen bei den gewünschten Konten. Anschließend
starten Sie die Migration über [Migrate selected users.]{.guihint}
:::

:::: imageblock
::: content
![Liste mit zur Migration vorgemerkten
Benutzern.](../images/saml_migration_list.png)
:::
::::

::: paragraph
In einem Zwischenschritt können Sie beliebige Attribute löschen lassen.
:::

:::: imageblock
::: content
![Dialog mit löschbaren
Benutzerattributen.](../images/users_migration.png)
:::
::::
:::::::::
::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
