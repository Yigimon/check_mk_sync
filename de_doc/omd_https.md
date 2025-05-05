:::: {#header}
# Weboberfläche mit HTTPS absichern

::: details
[Last modified on 18-Oct-2022]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/omd_https.asciidoc){.edit-document}
:::
::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Single Sign-On mit Kerberos](kerberos.html) [Benutzerverwaltung mit
LDAP/Active Directory](ldap.html)
:::
::::
:::::
::::::
::::::::

::::::: sect1
## []{#_einleitung .hidden-anchor .sr-only}1. Einleitung {#heading__einleitung}

:::::: sectionbody
::: paragraph
Wenn Sie die Weboberfläche von Checkmk über HTTPS einsetzen möchten,
dann müssen Sie auf Ihrem Monitoring-Server --- unabhängig von Ihren
Instanzen --- folgende Voraussetzungen schaffen:
:::

::: ulist
- Das Apache-Modul `mod_ssl` ist installiert und aktiviert.

- Die Apache-Module `mod_rewrite` und `mod_headers` sind vorhanden und
  ebenfalls aktiviert.

- Sie besitzen ein gültiges Server-Zertifikat.

- Der Server ist über HTTPS erreichbar.
:::

::: paragraph
Was dafür zu tun ist, erklärt dieser Artikel.
:::
::::::
:::::::

::::::::::::::::::::::::: sect1
## []{#_apache_module_aktivieren .hidden-anchor .sr-only}2. Apache-Module aktivieren {#heading__apache_module_aktivieren}

:::::::::::::::::::::::: sectionbody
::: paragraph
Die HTTPS-Absicherung der Checkmk-Oberfläche benötigt das Apache-Modul
`mod_ssl`. Wir gehen im weiteren Verlauf der Einrichtung zudem davon
aus, dass eine auf dem unverschlüsselten Port 80 eingehende Verbindung
auf den SSL verschlüsselten Port 443 weitergeleitet werden soll. Dafür
ist das Modul `mod_rewrite` nötig. Schließlich wird noch `mod_headers`
benötigt, damit der als [Reverse
Proxy](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html){target="_blank"}
konfigurierte extern erreichbare Apache dem [Site
Apache](ports.html#loopback) die Request Header weiterleitet.
:::

::: paragraph
Die geladenen Apache-Module können Sie sich mit dem Kommando `apachectl`
anzeigen lassen. Alte Red Hat Enterprise Linux (RHEL) und
CentOS-Versionen benötigen möglicherweise stattdessen `httpd`. Mit
`grep` prüfen Sie gleich, ob alle drei benötigten Module vorhanden sind:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# apachectl -M | grep -E 'headers|rewrite|ssl'
 headers_module (shared)
 rewrite_module (shared)
```
:::
::::

::: paragraph
Die Aktivierung fehlender Module gelingt auf den meisten Distributionen
mit dem Skript `a2enmod`. Es legt Softlinks im Ordner
`/etc/apache2/mods-enabled` an. Die Datei mit der Endung `.load` enthält
dabei Anweisungen zum Laden des Moduls, und die Datei `.conf` enthält
die eigentliche Konfiguration des Moduls:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# a2enmod ssl
Enabling module ssl.
To activate the new configuration, you need to run:
  systemctl restart apache2
```
:::
::::

::: paragraph
Bei älteren Versionen von RHEL und darauf basierenden Distributionen ist
`mod_ssl` ein eigenes Paket, das Sie separat installieren müssen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# yum install -y httpd mod_ssl
```
:::
::::

::: paragraph
Ist das Kommando `a2enmod` nicht vorhanden, arbeiten Sie mit einer
Distribution, welche die Apache-Konfiguration statt auf Verzeichnisse
und viele Einzeldateien aufzuteilen in einer einzigen
Konfigurationsdatei vorhält. In solch einem Fall muss in der
Konfigurationsdatei `/etc/httpd/conf/httpd.conf` die auskommentierte
Zeile `LoadModule ssl_module […​]` vom `#` befreit werden. Analog ist für
die beiden anderen Module vorzugehen.
:::

::: paragraph
Ob der Apache-Webserver bereits jetzt oder erst später neu gestartet
werden kann, entscheidet sich an der Frage, ob bei der Installation von
Apache einfache, selbst signierte Zertifikate automatisch erzeugt
wurden.
:::

::: paragraph
Dies erfahren Sie, indem Sie zunächst nach der Konfigurationsdatei
suchen, welche die Pfade zu Zertifikat und Schlüsseln enthält und dann
prüfen, ob diese Dateien existieren (bei RHEL ist als Startverzeichnis
der Suche `/etc/httpd` anzugeben):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# find /etc/apache2/ -type f -exec grep -Hn '^\s*SSLCertificate.*File' {} \;
/etc/apache2/sites-available/default-ssl.conf:32: SSLCertificateFile   /etc/ssl/certs/ssl-cert-snakeoil.pem
/etc/apache2/sites-available/default-ssl.conf:33: SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
```
:::
::::

::: paragraph
Prüfen Sie, ob die in der Konfigurationsdatei angegebenen Dateien
existieren. Falls kein automatisch erstelltes Zertifikat vorhanden ist,
warten Sie mit dem Neustart des Apache-Webservers, bis Sie ein
Zertifikat erhalten oder selbst erstellt haben -- sonst schlägt der
Neustart fehl.
:::

::: paragraph
Sind Zertifikat und Schlüssel vorhanden, starten Sie den
Apache-Webserver neu, beim mittlerweile standardmäßig verwendeten
`systemd` mit folgendem Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl restart apache2
```
:::
::::

::: paragraph
Wieder gilt: Einige Distributionen verwenden als Name des Dienstes nicht
`apache2`, sondern das etwas generischere `httpd`. Passen Sie in diesem
Fall den Befehl an.
:::

::: paragraph
**Hinweis:** In der Checkmk-Appliance aktivieren Sie [HTTPS über die
Weboberfläche!](appliance_usage.html#ssl)
:::
::::::::::::::::::::::::
:::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sect1
## []{#_zertifikate_erhalten .hidden-anchor .sr-only}3. Zertifikate erhalten {#heading__zertifikate_erhalten}

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: sectionbody
::: paragraph
Im Wesentlichen existieren die folgenden Methoden, um an ein
Server-Zertifikat zu gelangen:
:::

::: ulist
- Sie greifen auf einen externen Dienstleister für die
  [Zertifikatsausstellung mittels CSR](#oldschoolcsr) (*Certificate
  Signing Request*) zurück, dessen Root-Zertifikat von Browser- und
  Betriebssystemherstellern vertraut wird. Mit diesem Verfahren können
  Zertifikate nicht nur auf
  [Ebene](https://de.wikipedia.org/wiki/Zertifizierungsstelle_(Digitale_Zertifikate)#Web_PKI){target="_blank"}
  einer Domain validiert werden, sondern auch auf Organisationsebene
  (Organization Validation) und höher (Extended Validation), wie es in
  einigen Branchen aus regulatorischen Gründen verpflichtend ist.

- Sie nutzen [kostenlose Zertifikate von *Let's Encrypt*.](#letsencrypt)
  Dieses Verfahren erlaubt nur eine Validierung auf Domain-Ebene. Um
  Zertifikate anfordern zu können, muss der abzusichernde Server von
  außen erreichbar sein oder Sie müssen die Möglichkeit haben,
  (automatisiert) Einträge im öffentlichen DNS der verwendeten Domain
  anzulegen.

- Sie werden Ihre [eigene *Certificate Authority* (CA)](#becomeca) und
  erzeugen Zertifikate selbst. Das Root-Zertifikat der eigenen CA muss
  auf allen Rechnern vorhanden sein, die mit Servern kommunizieren, die
  mit dem CA-Schlüssel signierte Zertifikate verwenden. Im Umgang mit
  der eigenen CA sollten hohe Sicherheitsstandards eingehalten werden,
  da mit dieser CA Zertifikate für beliebige Domains ausgestellt werden
  können.
:::

:::::::::::::::::::::::::: sect2
### []{#oldschoolcsr .hidden-anchor .sr-only}3.1. Externe CA verwenden {#heading_oldschoolcsr}

::: paragraph
Zertifikate bei einer kommerziellen Certificate Authority signieren zu
lassen, war lange Zeit der einzige Weg, von allen Browsern und
Betriebssystemen akzeptierte Zertifikate zu erhalten. Dieses Verfahren
ist heute insbesondere dann noch üblich, wenn lange Gültigkeitszeiträume
erwünscht sind.
:::

::: paragraph
Die Abfolge ist, dass Sie zunächst den privaten Server-Schlüssel
erzeugen und dann für diesen ein *Certificate Signing Request* (CSR)
erstellen, welches Sie an den ausgewählten Anbieter übertragen. Dieser
prüft dann die Inhaberschaft der Domain, bestätigt das CSR mit seinem
Schlüssel und schickt Ihnen das resultierende Server-Zertifikat.
:::

::: paragraph
Beachten Sie --- ungeachtet der nachfolgenden Beispiele --- unbedingt
auch die Vorgaben Ihrer Certificate Authority und ändern Sie die
Kommandos gegebenenfalls entsprechend ab.
:::

:::::::::::: sect3
#### []{#createcsr .hidden-anchor .sr-only}Schlüssel und CSR erzeugen {#heading_createcsr}

::: paragraph
Zunächst erzeugen Sie den privaten Server-Schlüssel. Diesen Schritt
können Sie direkt auf dem Server durchführen, auf dem die abzusichernde
Checkmk-Instanz läuft.
:::

::: paragraph
Der verwendete Ordner `/etc/certs` entspricht dem Standard vieler
Distributionen. Sie können aber jeden beliebigen Ordner verwenden, auf
den der Apache-Prozess lesend zugreifen kann. Den Schlüssel nach dem
primären Domain-Namen zu benennen, für den er verwendet wird (hier
`checkmk.mydomain.com`), dient hier der besseren Übersicht. Insbesondere
wenn später weitere Server-Namen hinzukommen sollten, für die eigene
Schlüssel/Zertifikate verwendet werden, erleichtert dieses Namensschema
die Zuordnung.
:::

::: paragraph
Der private Schlüssel dient später der Verschlüsselung des Datenverkehrs
und sollte entsprechend umsichtig behandelt werden (beispielsweise
hinsichtlich der Zugriffsrechte). Um einen Neustart des Apache-Servers
auch automatisiert durchführen zu können, vergeben die meisten
Administratoren keine Passphrase.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# openssl genrsa -out /etc/certs/checkmk.mydomain.com.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.....++
...............................................................++
e is 65537 (0x010001)
```
:::
::::

::: paragraph
Im nächsten Schritt erstellen Sie das Certificate Signing Request (CSR)
-- einen digitalen Antrag auf Erstellung eines Identitäts-Zertifikats
(hier: Public-Key-Zertifikat):
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# openssl req -new -key checkmk.mydomain.com.key -out checkmk.mydomain.com.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
---
Country Name (2 letter code) [AU]: DE
State or Province Name (full name) [Some-State]: Bavaria
Locality Name (eg, city) []: Munich
Organization Name (eg, company) [Internet Widgits Pty Ltd]: Yoyodyne Inc.
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []: checkmk.mydomain.com
Email Address []: webmaster@mydomain.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```
:::
::::

::: paragraph
Achten Sie darauf, die Angaben zum Unternehmen korrekt anzugeben und als
`Common Name` den Server-Namen einzutragen. Die `Email Address` sollte
in derselben Domain liegen und zu einem existierenden und gelesenen
Postfach gehören.
:::
::::::::::::

::::::: sect3
#### []{#_extension_datei_erstellen .hidden-anchor .sr-only}Extension-Datei erstellen {#heading__extension_datei_erstellen}

::: paragraph
Moderne Browser erfordern Zertifikate, welche die Erweiterung für
*alternative Host-Namen* nutzen, selbst wenn die Zertifikate nur für
einen Host-Namen ausgestellt werden. Dies erfordert eine
Extension-Datei, welche manche Anbieter automatisch erstellen und
integrieren. Ist das nicht der Fall oder Sie sind unsicher, erstellen
Sie eine solche Datei. Soll ein Zertifikat für mehrere Host-Namen gültig
sein, folgen unter `[alt_names]` weitere Zeilen `DNS.2 =` und so weiter:
:::

::::: listingblock
::: title
/tmp/checkmk.mydomain.com.ext
:::

::: content
``` {.pygments .highlight}
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = checkmk.mydomain.com
```
:::
:::::
:::::::

::::: sect3
#### []{#_unterlagen_einreichen .hidden-anchor .sr-only}Unterlagen einreichen {#heading__unterlagen_einreichen}

::: paragraph
Je nach angestrebter Validierungsebene kann es erforderlich sein,
weitere Unterlagen wie Handelsregisterauszüge oder Bankdaten
zusammenzustellen. Da die angeforderten Unterlagen, die Wege der
Einreichung und die Wege der Bestätigung von Anbieter zu Anbieter
verschieden sind, kann hier keine allgemein gültige Anleitung gegeben
werden. So kann Extended Validation beispielsweise auch bedeuten, dass
per Einschreiben ein Code an Geschäftsführer oder Prokurist verschickt
wird, der über ein Webformular eingegeben werden muss.
:::

::: paragraph
Im einfachsten Fall einer Validierung nur auf Domain-Ebene wird die
CSR-Datei und gegebenenfalls die EXT-Datei über eine Weboberfläche
hochgeladen. Sie erhalten dann die Möglichkeit, eine E-Mail-Adresse
auszuwählen: aus den für Admin-C (Inhaber) oder Tech-C (technisch
Verantwortlicher) der Domain hinterlegten oder einer generischen
E-Mail-Adresse wie `webmaster@domain.com`. An diese Adresse wird dann
ein Bestätigungslink verschickt.
:::
:::::

:::: sect3
#### []{#_zertifikat_erhalten .hidden-anchor .sr-only}Zertifikat erhalten {#heading__zertifikat_erhalten}

::: paragraph
Der Prüfungsvorgang selbst dauert bei Validierung auf Domain-Ebene in
der Regel maximal einige Minuten, bei Extended Validation manchmal
mehrere Tage. Sobald dieser abgeschlossen ist, erhalten Sie das zu Ihrem
Schlüssel gehörende Zertifikat per E-Mail oder Download. Neben dem
Zertifikat erhalten Sie auch einen Downloadlink zur *Zertifikatskette*
(*Certificate Chain File*). Speichern Sie diese unbedingt mit ab.
:::
::::
::::::::::::::::::::::::::

::::::::::::::::::::: sect2
### []{#letsencrypt .hidden-anchor .sr-only}3.2. Let's Encrypt {#heading_letsencrypt}

::: paragraph
Ist ein Server von außen erreichbar oder haben Sie Zugriff auf den
Name-Server, so können Sie automatisiert Zertifikate über den zu der
Electronic Frontier Foundation (EFF) gehörenden Non-Profit-Dienstleister
[Let's Encrypt](https://letsencrypt.org/#){target="_blank"} erstellen
lassen. Es entstehen keine Kosten. Per DNS validierte Zertifikate
erfordern alle 90 Tage wenige Minuten Aufmerksamkeit, per
Server-Verzeichnis validierte Zertifikate können Jahre lang automatisch
neu erzeugt werden.
:::

::: paragraph
Für Let's Encrypt-Zertifikate stellt die EFF das Python-Programm
*Certbot* in vielen verschiedenen Paketformaten bereit. Der Certbot
übernimmt die Erstellung des Schlüssels, den Versand der CSR, die
Prüfung der Inhaberschaft von Server oder Domain und lädt schließlich
das Zertifikat herunter. Er kommuniziert hierfür über das Protokoll
[Automatic Certificate Management Environment
(ACME)](https://de.wikipedia.org/wiki/Automatic_Certificate_Management_Environment){target="_blank"}
mit den Servern der EFF.
:::

::::: sect3
#### []{#_installation_des_certbot_skripts .hidden-anchor .sr-only}Installation des Certbot-Skripts {#heading__installation_des_certbot_skripts}

::: paragraph
Es existieren drei Möglichkeiten, Certbot zu installieren. Welche Sie
wählen, dürfte vor allem vom Alter der eingesetzten Distribution und den
Richtlinien in Ihrem Unternehmen zur Installation aus fremden
Paketquellen abhängen:
:::

::: ulist
- Wenn das Paketmanagement Ihrer Linux-Distribution Certbot-Version 1.10
  oder höher bereitstellt, kann diese Certbot-Version verwendet werden.

- Certbot ist über das Python-Paketinstallationstool `pip3` aus dem
  [Python Package
  Index](https://pypi.org/project/certbot/#){target="_blank"}
  installierbar. Der Befehl `pip3 install certbot` installiert auch alle
  abhängig benötigten Python-Module.

- Die EFF bevorzugt auf ihrer
  [Certbot-Dokumentationsseite](https://certbot.eff.org/instructions#){target="_blank"}
  die Installation aus einem Snap-Image. Es gelten die bekannten Vor-
  und Nachteile des Snap-Paketformates.
:::
:::::

::::::: sect3
#### []{#_vollautomatische_konfiguration .hidden-anchor .sr-only}Vollautomatische Konfiguration {#heading__vollautomatische_konfiguration}

::: paragraph
Falls der Checkmk-Server aus dem Internet erreichbar ist und Sie an der
Konfiguration des systemweiten Apache-Webservers seit der Installation
von Checkmk keine Änderung vorgenommen haben, können Sie den
\"Apache-Automatismus\" von Certbot verwenden. Mit diesem können Sie
Schlüssel erzeugen, Zertifikate anfordern, die Apache-Konfiguration
automatisch anpassen und schließlich einen Cronjob einrichten, um
regelmäßig die 90 Tage laufenden Zertifikate zu erneuern.
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# certbot --apache
```
:::
::::

::: paragraph
Das Skript fragt nun interaktiv einige Informationen zu Kontaktdaten
(E-Mail-Kontakt für zusätzliche Informationen wie notwendige
Zertifikatsrückrufe) und Installationspfaden ab. Am Ende steht die
funktionsfähige SSL-Konfiguration. Eine Anpassung der
Konfigurationsdatei für `mod_ssl` ist nicht nötig, dies hat der Certbot
bereits erledigt.
:::
:::::::

::::::: sect3
#### []{#_teilautomatisierte_konfiguration .hidden-anchor .sr-only}Teilautomatisierte Konfiguration {#heading__teilautomatisierte_konfiguration}

::: paragraph
Falls Sie, wie im vorherigen Abschnitt beschrieben, Zertifikate
anfordern, aber die Apache-Konfiguration selbst anpassen wollen,
verwenden Sie den Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# certbot certonly --apache
```
:::
::::

::: paragraph
Die Konfiguration schließen Sie dann [wie unten
beschrieben](#configsample) in der Konfigurationsdatei für `mod_ssl` ab.
:::
:::::::

::::: sect3
#### []{#_weitere_möglichkeiten .hidden-anchor .sr-only}Weitere Möglichkeiten {#heading__weitere_möglichkeiten}

::: paragraph
Ist der Checkmk-Server beispielsweise nur aus dem Intranet oder per VPN
erreichbar, aber der DNS-Server öffentlich, können Sie die Validierung
über eine *DNS-Challenge* vornehmen. Hier wird die Inhaberschaft einer
Domain nicht darüber geprüft, Dateien auf dem Webserver ablegen zu
können, sondern darüber, dass Sie Einträge im DNS hinzufügen können.
Dabei kommen keine Einträge zur Anwendung, die einen Host-Namen zu einer
IP-Adresse auflösen, sondern sogenannte TXT-Einträge, die beliebige
Zeichenketten enthalten können. TXT-Einträge werden beispielsweise auch
verwendet, um anzugeben, welche Server E-Mails für eine Domain versenden
dürfen.
:::

::: paragraph
DNS-Challenges können manuell durchgeführt werden, was bei 90 Tagen
Gültigkeit meist nur für einzelne Testsysteme praktikabel ist. Verfügt
Ihr DNS-Anbieter über ein von Let's Encrypt unterstütztes API, kann auch
eine automatische Erneuerung durchgeführt werden. Lesen Sie hierfür die
[Übersicht der Challenge
Typen](https://letsencrypt.org/de/docs/challenge-types/){target="_blank"}
bei Let's Encrypt.
:::
:::::
:::::::::::::::::::::

::::::::::::::::::::: sect2
### []{#becomeca .hidden-anchor .sr-only}3.3. Interne CA verwenden {#heading_becomeca}

::: paragraph
Sie können sich selbst in die Rolle einer Certificate Authority (CA)
versetzen und Zertifikate für beliebige Domains (Ihre Domains, fremde
Domains und Phantasie-Domains) ausstellen. Der Weg über die eigene CA
ist vor allem für Testumgebungen oder abgeschottete Checkmk-Server mit
überschaubarer Nutzerzahl sinnvoll. Dies ist zudem die einzige
Möglichkeit, Zertifikate zu erhalten, wenn Sie intern eine der fünf
reservierten Top-Level-Domains (TLD) `.example`, `.invalid`, `.local`,
`.localhost` oder `.test` verwenden. Für diese Domains gibt es keine
Registrare, folglich kann keine Inhaberschaft bestätigt werden.
:::

::: paragraph
Dieses Kapitel erklärt die Ausstellung von Zertifikaten mit solch einer
internen CA. Als Voraussetzungen werden angenommen, dass Sie bereits
über den privaten CA-Root- oder CA-Intermediate-Schlüssel verfügen und
diesen nun verwenden sollen, um Zertifikate zur Absicherung eines
Checkmk-Servers auszustellen.
:::

::: paragraph
Die Erstellung der CA-Schlüssel, des CA-Zertifikats und der
dazugehörigen Konfigurationsdatei ist nicht Bestandteil dieser
Anleitung.
:::

:::: sect3
#### []{#_schlüssel_und_csr_erzeugen .hidden-anchor .sr-only}Schlüssel und CSR erzeugen {#heading__schlüssel_und_csr_erzeugen}

::: paragraph
Gehen Sie für die Erstellung von Server-Schlüssel, Certificate Signing
Request (CSR) und Extension-Datei so vor, wie es im Abschnitt zur
[Zertifikatsausstellung über eine kommerzielle CA](#createcsr)
beschrieben ist. Die Vorgehensweise und die benötigten Dateien sind
identisch.
:::
::::

:::::::: sect3
#### []{#signyourself .hidden-anchor .sr-only}CSR signieren {#heading_signyourself}

::: paragraph
Um selbst Zertifikate zu signieren, benötigen Sie wenigstens einen
privaten Schlüssel (hier `intermediate.key.pem`) und das dazugehörige
Intermediate-Zertifikat `intermediate.pem`. Falls Sie zudem über eine
Konfigurationsdatei verfügen, ist der Pfad zu dieser mit dem Parameter
`--config` anzugeben.
:::

::: paragraph
Die Signatur auf Basis der CSR-Datei `checkmk.mydomain.com.csr`,
Extension-Datei `checkmk.mydomain.com.ext` und der Ausgabedatei
`checkmk.mydomain.com.crt` erledigen Sie dann mit folgendem Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
user@host:~$ openssl x509 -CAcreateserial -req \
    -in checkmk.mydomain.com.csr \
    -CA intermediate.pem -CAkey intermediate.key.pem \
    -out checkmk.mydomain.com.crt -days 365 \
    -sha256 -extfile checkmk.mydomain.com.ext
```
:::
::::

::: paragraph
Neben dem hier erstellten Server-Zertifikat `checkmk.mydomain.com.crt`
müssen Sie Ihr CA-Zertifikat `intermediate.pem` weitergeben. Falls Sie
nicht Root-CA sind, müssen Sie zusätzlich auch das Root-Zertifikat (im
weiteren Text als `ca_certificate_intern.pem` referenziert) weitergeben.
:::
::::::::

::::::::: sect3
#### []{#_zertifikat_importieren .hidden-anchor .sr-only}Zertifikat importieren {#heading__zertifikat_importieren}

::: paragraph
Die Wege, ein CA-Zertifikat als vertrauenswürdig zu importieren,
unterscheiden sich von Browser zu Browser. Meist genügt es, das
Zertifikat `ca_certificate_intern.pem` unter [Einstellungen \>
Datenschutz]{.guihint} und [Sicherheit \> Zertifikate \>
Importieren]{.guihint} hinzuzufügen.
:::

::: paragraph
Damit die Zertifikatsverwaltung kein Stolperstein beim automatischen
Agenten-Update in den kommerziellen Editionen darstellt, haben wir in
der [Agentenbäckerei](glossar.html#agent_bakery) die Möglichkeit
vorgesehen, ein [eigenes
CA-Zertifikat](agent_deployment.html#certificates_for_https) zu
übergeben, das nur für Agenten-Updates benutzt wird. Die
Systemzertifikate werden hierbei nicht angetastet, und Agenten-Updates
sind dennoch möglich.
:::

::: paragraph
Alternativ zur Verteilung per Agenten-Update können Sie das
Root-Zertifikat in der lokalen CA-Datenbank des Hosts integrieren.
Kopieren Sie dafür die Datei `ca_certificate_intern.pem` nach
`/usr/local/share/ca-certificates/`. Anschließend generieren Sie den
Cache neu:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# update-ca-certificates
```
:::
::::

::: paragraph
Unter Windows ist es möglich, die Systemzertifikate über das MMC-Snap-In
\"Certificates\" zu verwalten. Dies ist beispielsweise nötig, wenn Sie
einen Microsoft-Browser verwenden wollen, um auf ein mit eigener CA
abgesichertes Checkmk zuzugreifen. Das genaue Vorgehen können Sie im
[Microsoft Knowledge Base Artikel
PKI](https://docs.microsoft.com/de-de/troubleshoot/windows-server/windows-security/import-third-party-ca-to-enterprise-ntauth-store#method-1---import-a-certificate-by-using-the-pki-health-tool){target="_blank"}
nachlesen. Alternativ können Sie Zertifikate per
[Intune](https://docs.microsoft.com/de-de/mem/intune/protect/certificates-configure){target="_blank"}
verteilen.
:::
:::::::::
:::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: sect1
## []{#configsample .hidden-anchor .sr-only}4. HTTPS-Verbindung für eine Instanz konfigurieren {#heading_configsample}

:::::::::::::::::::::::: sectionbody
::: paragraph
Zunächst müssen Sie in der SSL-Konfigurationsdatei die korrekten Pfade
zu Schlüssel, Zertifikat und Intermediate-Zertifikat angeben. Beachten
Sie, dass es sich hier um Konfigurationen für den Webserver `apache2`
handelt und diese nicht spezifisch für Checkmk sind. Daher ist die
verwendete Konfigurationsdatei unter Debian-basierten Systemen in der
Regel der Standard `/etc/apache2/sites-enabled/default-ssl.conf`. Der
Pfad kann jedoch bei älteren Distributionen abweichen.
:::

::: paragraph
Im Beispiel unten bezeichnet das `SSLCertificateKeyFile` den eingangs
erzeugten privaten Schlüssel für diesen Server.
`SSLCertificateChainFile` enthält das Intermediate Certificate oder
gegebenenfalls aneinandergereihte Intermediate Certificates. Lediglich
bei einer internen CA, wo direkt mit dem CA-Schlüssel signiert wird,
fällt dieses weg.
:::

::: paragraph
Viele kommerzielle Anbieter verwenden eher generische Dateinamen, wenn
Sie diese übernehmen, wird die Konfiguration ähnlich zu der Folgenden
aussehen:
:::

::::: listingblock
::: title
/etc/apache2/sites-enabled/default-ssl.conf
:::

::: content
``` {.pygments .highlight}
SSLEngine on
SSLCertificateKeyFile /etc/certs/checkmk.mydomain.com.key
SSLCertificateChainFile /etc/certs/ca_bundle.crt
SSLCertificateFile /etc/certs/certificate.crt
```
:::
:::::

::: paragraph
Wenn Sie Let's Encrypt verwendet haben, um Zertifikate zu generieren,
aber die Konfiguration manuell aktualisieren wollen, finden Sie die
Pfade unterhalb `/etc/letsencrypt/live` heraus und tragen Sie diese ein:
:::

::::: listingblock
::: title
/etc/apache2/sites-enabled/default-ssl.conf
:::

::: content
``` {.pygments .highlight}
SSLEngine on
SSLCertificateKeyFile /etc/letsencrypt/live/checkmk.mydomain.com/privkey.pem
SSLCertificateChainFile /etc/letsencrypt/live/checkmk.mydomain.com/chain.pem
SSLCertificateFile /etc/letsencrypt/live/checkmk.mydomain.com/cert.pem
```
:::
:::::

::::::::::::: sect2
### []{#httpsredirect .hidden-anchor .sr-only}4.1. HTTPS-Weiterleitung hinzufügen {#heading_httpsredirect}

::: paragraph
Apache arbeitet mit virtuellen Hosts, um unter einer IP-Adresse
verschiedene Inhalte bereitstellen zu können. Wird im Apache-Kontext der
Begriff \"Site\" verwendet, ist solch ein virtueller Host, keine
Checkmk-Site gemeint. Auf einem reinen Checkmk-Server wird in der Regel
nur ein virtueller Host mit einem Servernamen verwendet, unter dem dann
alle Checkmk-Sites erreichbar sind. Die `VirtualHost`-Konfiguration
befindet sich -- je nach eingesetzter Distribution -- in einer dieser
Dateien:
:::

+-----------------+-----------------------------------------------------+
| Debian, Ubuntu  | `/etc/apache2/sites-enabled/000-default`(`.conf`)   |
+-----------------+-----------------------------------------------------+
| RHEL, CentOS    | `/etc/httpd/conf.d/ssl.conf`                        |
+-----------------+-----------------------------------------------------+
| SLES            | `/etc/apache2/httpd.conf`                           |
+-----------------+-----------------------------------------------------+

::: paragraph
Das folgende Beispiel geht davon aus, dass Sie eine einzige
Konfigurationsdatei für unverschlüsselte Verbindungen auf Port 80 und
verschlüsselte Verbindungen auf 443 nutzen. In diesem Fall ergänzen Sie
im Abschnitt für den `VirtualHost` folgende Zeilen:
:::

::::: listingblock
::: title
/etc/apache2/sites-enabled/000-default
:::

::: content
``` {.pygments .highlight}
RewriteEngine On
# Never forward request for .well-known (important when using Let's Encrypt)
RewriteCond %{REQUEST_URI} !^/.well-known
# Next 2 lines: Force redirection if incoming request is not on 443
RewriteCond %{SERVER_PORT} !^443$
RewriteRule (.*) https://%{HTTP_HOST}$1 [L]
# This section passes the system Apaches connection mode to the
# instance Apache. Make sure mod_headers is enabled, otherwise it
# will be ignored and "Analyze configuration" will issue "WARN".
<IfModule headers_module>
    RequestHeader set X-Forwarded-Proto expr=%{REQUEST_SCHEME}
    RequestHeader set X-Forwarded-SSL expr=%{HTTPS}
</IfModule>
```
:::
:::::

::: paragraph
Die beiden Zeilen `RequestHeader set X-Forwarded…​` stellen hier sicher,
dass dem [Site Apache auf Port 5000](ports.html#loopback) mitgeteilt
wird, dass ein Aufruf über SSL erfolgte, Sicherheitsregeln also
eingehalten wurden.
:::

::: paragraph
Nach der Konfigurationsänderung muss der Webserver neu gestartet werden:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# systemctl restart apache2
```
:::
::::

::: paragraph
Erneut gilt: Einige Distributionen verwenden als Name des Dienstes nicht
`apache2`, sondern das etwas generischere `httpd`. Passen Sie in diesem
Fall den Befehl an.
:::
:::::::::::::
::::::::::::::::::::::::
:::::::::::::::::::::::::

::::::::::::::::::: sect1
## []{#_zusätzliche_optionen .hidden-anchor .sr-only}5. Zusätzliche Optionen {#heading__zusätzliche_optionen}

:::::::::::::::::: sectionbody
::::::::::::::::: sect2
### []{#_hsts_einrichten .hidden-anchor .sr-only}5.1. HSTS einrichten {#heading__hsts_einrichten}

::: paragraph
Den Checkmk-Server nur noch mittels HTTPS erreichbar zu machen, ist der
erste und wichtigste Schritt, um Verbindungen zum Monitoring
abzusichern. Erhöhen kann man die Sicherheit aber mit zusätzlichen,
optionalen Einstellungen. So kann der Webserver dem Browser mitteilen,
dass er in Zukunft bitte nur noch über HTTPS angesprochen werden soll
und eine ungesicherte Verbindung über HTTP immer abgelehnt wird.
:::

::: paragraph
Diese Technik nennt sich HTTP Strict Transport Security (HSTS) und wird
für einen bestimmten Zeitraum in Sekunden gesetzt. Ist dieser Zeitraum
abgelaufen, prüft der Browser erneut, ob die Limitierung über HSTS
weiterhin gültig ist.
:::

::::: sect3
#### []{#hsts_specifics .hidden-anchor .sr-only}Besonderheiten {#heading_hsts_specifics}

::: paragraph
Die Einrichtung von HSTS bietet den Vorteil, dass nur sichere
Verbindungen genutzt werden. Der Einsatz bringt auch bestimmte
Besonderheiten mit sich, derer man sich *vor* der Umstellung bewusst
sein muss:
:::

::: ulist
- Ist der Eintrag zu HSTS einmal vom Browser des Benutzers angelegt,
  kann er --- zumindest vor Ablauf der Zeit --- nur mit entsprechendem
  Detailwissen zu dem jeweiligen Browser entfernt werden. Beachten Sie,
  dass viele Benutzer dieses Wissen nicht haben.

- Die Verbindung wird u.a. dann abgelehnt, wenn das Zertifikat
  abgelaufen ist oder durch ein selbst signiertes ausgetauscht wurde.
  Solche Seiten können auch nicht mit einer Ausnahme zum temporären
  Vertrauen eines Zertifikats aufgerufen werden.

- HSTS wird umgekehrt nur dann berücksichtigt, wenn dem Zertifikat beim
  ersten Verbindungsaufbau **vertraut** wird. Ansonsten legt der Browser
  keinen Eintrag zu HSTS an, so dass der zusätzliche Schutzmechanismus
  nicht benutzt wird.
:::
:::::

::::::::::: sect3
#### []{#_konfiguration_des_apache_webservers .hidden-anchor .sr-only}Konfiguration des Apache-Webservers {#heading__konfiguration_des_apache_webservers}

::: paragraph
Um die Option zu setzen, fügen Sie den folgenden Eintrag der
HTTPS-Konfiguration hinzu. Unter Debian/Ubuntu ist das standardmäßig die
Datei `default-ssl.conf`:
:::

::::: listingblock
::: title
/etc/apache2/sites-enabled/default-ssl.conf
:::

::: content
``` {.pygments .highlight}
Header always set Strict-Transport-Security "max-age=43200"
```
:::
:::::

::: paragraph
**Wichtig**: Setzen Sie zunächst einen kurzen Zeitraum --- z.B. 600
Sekunden \--, um die Einstellung zu testen, da es sein kann, dass
ansonsten die Verbindung im Fehlerfall für einen sehr langen Zeitraum
abgelehnt wird! Mehr dazu auch bei den
[Besonderheiten](#hsts_specifics).
:::

::: paragraph
Um zu sehen, ob die neue Einstellung funktioniert, können Sie mit Hilfe
des Programms `curl` den Server abrufen. Hier in der Ausgabe nur die
ersten 4 Zeilen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
root@linux# curl -I \https://mycmkserver/mysite/check_mk/login.py
HTTP/1.1 200 OK
Date: Tue, 01 Jun 2021 09:30:20 GMT
Server: Apache
Strict-Transport-Security: max-age=3600
```
:::
::::
:::::::::::
:::::::::::::::::
::::::::::::::::::
:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
