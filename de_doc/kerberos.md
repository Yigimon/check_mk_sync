:::: {#header}
# Single Sign-On mit Kerberos

::: details
[Last modified on 21-Sep-2023]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/kerberos.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Benutzerverwaltung mit LDAP/Active Directory](ldap.html) [Benutzer,
Zuständigkeiten, Berechtigungen](wato_user.html) [Weboberfläche mit
HTTPS absichern](omd_https.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::::: sectionbody
::: paragraph
Ein Single Sign-On auf die GUI von Checkmk mit Kerberos wird von Checkmk
zwar nicht offiziell unterstützt, aber Sie können es sich selbst
einrichten, sofern Sie grundsätzliches Wissen rund um Kerberos
mitbringen. Was Sie auf der Seite von Checkmk benötigen, zeigt Ihnen
diese Anleitung.
:::

::: paragraph
Folgende Voraussetzungen müssen erfüllt sein, um die Konfiguration in
Checkmk nachträglich auf SSO (Single Sign-On) mit Kerberos umzustellen:
:::

::: ulist
- Die Apache-Version ist 2.4 oder neuer.

- Auf dem Checkmk-Server ist das Modul `libapache-mod-auth-kerb`
  installiert (bzw. `mod_auth_kerb` unter Red Hat Enterprise Linux und
  CentOS oder `apache2-mod_auth_kerb` unter SUSE).

- Der Kerberos-Client ist auf dem Checkmk-Server installiert und
  konfiguriert.

- Eine Keytab wurde --- z.B. in der Checkmk-Instanz unter
  `~/etc/apache/cmk_http.keytab` --- erstellt und darf nur von dem
  Instanzbenutzer gelesen werden.

- Der Checkmk-Server wurde als *Service Principal* eingerichtet.

- Der Browser der Clients ist für den Zugriff mittels Kerberos
  konfiguriert.
:::

::: paragraph
*Optional:*
:::

::: paragraph
Wenn Sie möchten, dass sich Nutzer **ohne SSO** weiterhin über die
reguläre Login-Seite anmelden können, muss die
[Cookie-Authentifizierung](#cookie) eingeschaltet sein.
:::
::::::::
:::::::::

::::::::: sect1
## []{#configuration .hidden-anchor .sr-only}2. Integration von Kerberos {#heading_configuration}

:::::::: sectionbody
::: paragraph
Um Checkmk auf die Authentifizierung über Kerberos umzustellen, löschen
Sie die Datei `~/etc/apache/conf.d/auth.conf` und schreiben sie neu. Die
Einträge am Anfang des folgenden Dateiinhalts sind lediglich Beispiele.
Passen Sie daher alle mit dem Ausdruck `Define` beginnenden Zeilen Ihrer
Umgebung entsprechend an:
:::

::::: listingblock
::: title
\~/etc/apache/conf.d/auth.conf
:::

::: content
``` {.pygments .highlight}
Define SITE MyCheckmkSite
Define REALM MyRealm.org
Define SERVICENAME myservice.mydomain.tld
Define KEYTAB /omd/sites/${SITE}/etc/apache/cmk_http.keytab

<IfModule !mod_auth_kerb.c>
  LoadModule auth_kerb_module /usr/lib/apache2/modules/mod_auth_kerb.so
</IfModule>

<Location /${SITE}>
  <If "! %{HTTP_COOKIE} =~ /^(.*;)?auth_${SITE}/ && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/register_agent.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/deploy_agent.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/run_cron.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/restapi.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/webapi.py' && \
    ! %{REQUEST_URI} = '/${SITE}/check_mk/automation.py' && \
    ! %{REQUEST_URI} -strmatch '/${SITE}/check_mk/api/*' && \
    ! %{REQUEST_URI} = '/${SITE}check_mk/ajax_graph_images.py' && \
    ! %{QUERY_STRING} =~ /(_secret=|auth_|register_agent)/ && \
    ! %{REQUEST_URI} =~ m#^/${SITE}/(omd/|check_mk/((images|themes)/.*\.(png|svg)|login\.py|.*\.(css|js)))# ">
  Order allow,deny
  Allow from all
  Require valid-user

  AuthType Kerberos
  AuthName "Checkmk Kerberos Login"

  KrbMethodNegotiate on
  KrbMethodK5Passwd off
  KrbLocalUserMapping on


  # Environment specific: Path to the Keytab, Realm and ServicePrincipal
  KrbAuthRealm ${REALM}
  KrbServiceName HTTP/${SERVICENAME}@${REALM}
  Krb5Keytab ${KEYTAB}

  # When Kerberos auth fails, show the login page to the user
  ErrorDocument 401 '<html> \
      <head> \
        <meta http-equiv="refresh" content="1; URL=/${SITE}/check_mk/login.py"> \
      </head> \
      <body> \
        Kerberos authentication failed, redirecting to login page. \
        <a href="/${SITE}/check_mk/login.py">Click here</a>. \
      </body> \
    </html>'
  </If>
</Location>

# These files are accessible unauthenticated (login page and needed ressources)
<LocationMatch /${SITE}/(omd/|check_mk/(images/.*\.png|login\.py|.*\.(css|js)))>
  Order allow,deny
  Allow from all
  Satisfy any
</LocationMatch>
```
:::
:::::

::: paragraph
In der Beispiel-Konfiguration werden anschließend nur noch
Authentifizierungen über Kerberos zugelassen. Sie müssen nun
entscheiden, ob Sie weiterhin `basic auth` mit oder ohne Cookies - für
Nutzer ohne SSO bzw. als Fallback - unterstützen möchten. Was Sie dazu
einstellen müssen erklären wir in den beiden folgenden Kapiteln.
:::
::::::::
:::::::::

::::::::: sect1
## []{#basic_auth .hidden-anchor .sr-only}3. Basic-Authentifizierung zulassen {#heading_basic_auth}

:::::::: sectionbody
::: paragraph
Wenn Sie zusätzlich zum SSO per Kerberos weiterhin die Authentifizierung
per `basic auth` erlauben möchten, müssen Sie in der oben angegebenen
Konfiguration eine Zeile anpassen.
:::

::: paragraph
Ändern Sie dazu in der folgenden Zeile den Wert auf `on`:
:::

::::: listingblock
::: title
\~/etc/apache/conf.d/auth.conf
:::

::: content
``` {.pygments .highlight}
  KrbMethodK5Passwd on
```
:::
:::::
::::::::
:::::::::

:::::::::::::::: sect1
## []{#cookie .hidden-anchor .sr-only}4. Cookie-Authentifizierung prüfen {#heading_cookie}

::::::::::::::: sectionbody
::: paragraph
Um die Authentifizierung komfortabler zu gestalten, bietet Checkmk
darüber hinaus noch die Anmeldung über ein Cookie an. In einer neuen und
unveränderten Checkmk-Instanz ist dies derzeit der Standard.
:::

::: paragraph
Zu guter Letzt sollten Sie noch prüfen, ob diese Möglichkeit der
Authentifizierung noch eingeschaltet ist und ob dies so bleiben soll.
:::

::: paragraph
Den aktuellen Zustand Ihrer Instanz prüfen Sie mit dem folgenden Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config show MULTISITE_COOKIE_AUTH
```
:::
::::

::: paragraph
Wenn Sie hier ein `on` zurückbekommen und die Cookie-Authentifizierung -
beispielsweise als Fallback - weiterhin aktiviert lassen wollen, sind
Sie an dieser Stelle fertig.
:::

::: paragraph
Möchten Sie die `MULTISITE_COOKIE_AUTH` hingegen abschalten,
funktioniert dies über den folgenden Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ omd config set MULTISITE_COOKIE_AUTH off
```
:::
::::

::: paragraph
Löschen Sie anschließend noch die Datei `cookie_auth.conf` aus dem
Apache-Verzeichnis der Instanz:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ rm ~/etc/apache/conf.d/cookie_auth.conf
```
:::
::::
:::::::::::::::
::::::::::::::::

::::::: sect1
## []{#_fehlerdiagnose .hidden-anchor .sr-only}5. Fehlerdiagnose {#heading__fehlerdiagnose}

:::::: sectionbody
::: paragraph
Mit den folgenden Kommandos können Sie prüfen, ob das Kerberos-Setup an
sich funktioniert:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# kinit username
root@linux# klist
```
:::
::::
::::::
:::::::
:::::::::::::::::::::::::::::::::::::::::::::::::
