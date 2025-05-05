:::: {#header}
# Benachrichtigungen einschalten

::: details
[Last modified on 15-Apr-2024]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/common/de/intro_notifications.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Das Monitoring weiter ausbauen](intro_extend.html)
[Benachrichtigungen](notifications.html)
:::
::::
:::::
::::::
::::::::

::::::::: sect1
## []{#notifications .hidden-anchor .sr-only}1. Grundlegendes zu Benachrichtigungen {#heading_notifications}

:::::::: sectionbody
::: paragraph
Benachrichtigungen (*notifications*) bedeuten in Checkmk, dass Benutzer
aktiv darüber informiert werden, wenn sich der Zustand eines Hosts oder
Services ändert. Nehmen wir an, zu einem bestimmten Zeitpunkt geht auf
dem Host `mywebsrv17` der Service `HTTP foo.bar` von [OK]{.state0} auf
[CRIT]{.state2}. Checkmk erkennt dies und sendet standardmäßig an alle
Kontaktpersonen dieses Services eine E-Mail mit den wichtigsten Daten zu
diesem Ereignis. Später ändert sich der Zustand wieder von
[CRIT]{.state2} auf [OK]{.state0} und die Kontakte bekommen eine erneute
E-Mail --- diesmal zu dem Ereignis, das *Recovery* genannt wird.
:::

::: paragraph
Dies ist aber nur die einfachste Art der Benachrichtigung. Es gibt
zahlreiche Möglichkeiten, wie Sie das verfeinern können:
:::

::: ulist
- Sie können per SMS, Pager, Slack und anderen Internetdiensten
  benachrichtigen.

- Sie können Benachrichtigungen an bestimmten
  [Zeitperioden](glossar.html#time_period) festmachen, z.B. um
  Bereitschaftsdienste zu berücksichtigen.

- Sie können Eskalationen definieren, falls der zuständige Kontakt nicht
  schnell genug aktiv wird.

- Benutzer können selbstständig Benachrichtigungen „abonnieren" oder
  abbestellen, wenn Sie das zulassen möchten.

- Sie können generell über Regeln festlegen, wer wann über was
  benachrichtigt werden soll.
:::

::: paragraph
Bevor Sie jedoch mit den Benachrichtigungen beginnen, sollten Sie noch
Folgendes beachten:
:::

::: ulist
- Benachrichtigungen sind ein optionales Feature. Manche Anwender
  verzichten auf Benachrichtigungen, da Sie einen Leitstand haben, der
  rund um die Uhr besetzt ist und nur mit der Statusoberfläche arbeitet.

- Aktivieren Sie die Benachrichtigungen zunächst nur für sich selbst und
  machen Sie sich für **alles** zuständig. Beobachten Sie mindestens ein
  paar Tage, wie groß das Volumen an Benachrichtigungen ist.

- Aktivieren Sie die Benachrichtigungen für andere Benutzer erst dann,
  wenn Sie die Fehlalarme (*false positives*) auf ein Minimum reduziert
  haben. Was Sie dafür tun können, haben wir im [Kapitel über die
  Feinjustierung des Monitorings](intro_finetune.html) beschrieben.
:::
::::::::
:::::::::

::::::::::: sect1
## []{#notify_init .hidden-anchor .sr-only}2. E-Mail-Versand vorbereiten {#heading_notify_init}

:::::::::: sectionbody
::: paragraph
Der einfachste und bei weitem üblichste Weg ist die Benachrichtigung per
E-Mail. In einer E-Mail ist genug Platz, um auch die Graphen von
Metriken mitzusenden.
:::

::: paragraph
Bevor Sie per E-Mail benachrichtigen können, muss Ihr Checkmk-Server für
das Versenden von E-Mails eingerichtet sein. Bei allen unterstützten
Linux-Distributionen läuft das auf Folgendes hinaus:
:::

::: {.olist .arabic}
1.  Installieren Sie einen SMTP-Serverdienst. Dies geschieht meist
    automatisch bei der Installation der Distribution.

2.  Geben Sie einen **Smarthost** an. Nach diesem werden Sie meist bei
    der Installation des SMTP-Servers gefragt. Der Smarthost ist ein
    Mailserver in Ihrem Unternehmen, der für Checkmk die Zustellung der
    E-Mails übernimmt. Sehr kleine Unternehmen haben meist keinen
    eigenen Smarthost. In diesem Fall verwenden Sie den SMTP-Server, der
    Ihnen von Ihrem E-Mail-Provider bereitgestellt wird.
:::

::: paragraph
Wenn der E-Mail-Versand korrekt eingerichtet ist, sollten Sie in der
Lage sein, auf der Kommandozeile eine E-Mail zu versenden, z.B. über
diesen Befehl:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ echo "test-content" | mail -s test-subject bill.martin@example.com
```
:::
::::

::: paragraph
Die E-Mail sollte ohne Verzögerung zugestellt werden. Falls das nicht
klappt, finden Sie Hinweise in der Logdatei des SMTP-Servers im
Verzeichnis `/var/log/`. Mehr Details zum Einrichten des E-Mail-Versands
unter Linux finden Sie im [Artikel über
Benachrichtigungen.](notifications.html#smtp)
:::
::::::::::
:::::::::::

::::::: sect1
## []{#mail_activate .hidden-anchor .sr-only}3. E-Mail-Benachrichtigungen aktivieren {#heading_mail_activate}

:::::: sectionbody
::: paragraph
Wenn der E-Mail-Versand grundsätzlich funktioniert, ist das Aktivieren
der Benachrichtigungen sehr einfach. Damit ein Benutzer
Benachrichtigungen per E-Mail erhält, müssen die folgenden zwei
Voraussetzungen erfüllt sein:
:::

::: ulist
- Dem Benutzer ist eine E-Mail-Adresse zugeordnet.

- Der Benutzer ist für Hosts oder Services zuständig --- über die
  Zuweisung von Kontaktgruppen.
:::

::: paragraph
E-Mail-Adresse und Kontaktgruppen weisen Sie über die Eigenschaften des
Benutzers zu, wie wir es zuvor im [Kapitel über die
Benutzerverwaltung](intro_users.html#create_users) gezeigt haben, z. B.
indem Sie dem Benutzerkonto `cmkadmin` Ihre E-Mail-Adresse und die
Kontaktgruppe [Everything]{.guihint} hinzufügen.
:::
::::::
:::::::

::::::::::::::::::: sect1
## []{#test .hidden-anchor .sr-only}4. Benachrichtigungen testen {#heading_test}

:::::::::::::::::: sectionbody
::: paragraph
Es wäre ein bisschen umständlich, zum Test der Benachrichtigungen auf
ein echtes Problem zu warten oder gar eines zu provozieren. Einfacher
geht das mit [Test notifications,]{.guihint} einem Werkzeug, mit dem Sie
eine Benachrichtigung für einen Host oder einen Service simulieren und
die Benachrichtigung auch gleich versenden lassen können.
:::

::: paragraph
Sie erreichen den Benachrichtigungstest über [Setup \> Events \>
Notifications]{.guihint} und den Knopf [Test notifications:]{.guihint}
:::

:::: imageblock
::: content
![Dialog zur Festlegung der Eigenschaften der simulierten
Benachrichtigung.](../images/intro_test_notifications.png)
:::
::::

::: paragraph
Wählen Sie einfach einen Host aus und dann als Ereignis einen beliebigen
Zustandswechsel. Durch Aktivieren der Checkbox [Send out
notification]{.guihint} legen Sie fest, dass die Benachrichtigung nicht
nur simuliert, sondern auch tatsächlich versendet wird.
:::

::: paragraph
Klicken Sie auf [Test notifications.]{.guihint} Der Dialog [Test
notifications]{.guihint} wird aus- und die Ergebnisse eingeblendet. Am
wichtigsten ist die Zusammenfassung [Analysis results]{.guihint} ganz
oben:
:::

:::: imageblock
::: content
![Die Zusammenfassung zur Analyse der simulierten
Benachrichtigung.](../images/intro_test_notifications_result1.png)
:::
::::

::: paragraph
Es muss zumindest eine Benachrichtigungsregel greifen und daraus eine
Benachrichtigung resultieren. Außerdem muss die Benachrichtigung
versendet worden sein, was die Meldung `Notifications have been sent`
anzeigt.
:::

::: paragraph
Unter [Resulting notifications]{.guihint} sehen Sie dann, an wen und
über welchen Weg die Benachrichtigung abgesetzt wurde:
:::

:::: imageblock
::: content
![Die resultierende Benachrichtigung zur
Simulation.](../images/intro_test_notifications_result2.png)
:::
::::

::: paragraph
Dies sollte sofort zu einer E-Mail für dieses simulierte Problem führen.
Die ausführliche Beschreibung zu den Optionen und den Resultaten für den
Benachrichtigungstest erhalten Sie im Artikel zu den
[Benachrichtigungen.](notifications.html#notification_testing)
:::

::: paragraph
Falls Sie im realen Monitoring, d. h. abseits der Simulation, keine
Benachrichtigung bekommen haben, muss das nicht gleich ein Fehler sein.
Es gibt Situationen, in denen die Benachrichtigungen von Checkmk
absichtlich unterdrückt werden, z.B.:
:::

::: ulist
- wenn Benachrichtigungen im Snapin [[Master
  control]{.guihint}](intro_tools.html#master_control) ausgeschaltet
  sind;

- wenn ein Host oder Service sich in einer Wartungszeit befindet;

- wenn ein Host [DOWN]{.hstate1} ist und daher keine Benachrichtigungen
  seiner Services ausgelöst werden;

- wenn der Status in letzter Zeit zu oft gewechselt hat und der Service
  deswegen als [![Symbol zur Anzeige eines unstetigen
  Zustands.](../images/icons/icon_flapping.png)]{.image-inline}
  „unstetig" (*flapping*) markiert wurde.
:::
::::::::::::::::::
:::::::::::::::::::

::::: sect1
## []{#finetune .hidden-anchor .sr-only}5. Benachrichtigungen feinjustieren {#heading_finetune}

:::: sectionbody
::: paragraph
Sie können Benachrichtigungen in Checkmk auf unterschiedlichste Art mit
komplexen Regeln an Ihre Bedürfnisse (bzw. die Ihrer Firma) anpassen.
Alle Einzelheiten dazu erfahren Sie im [Artikel über
Benachrichtigungen.](notifications.html)
:::
::::
:::::

:::::::::::::::::::: sect1
## []{#troubleshoot .hidden-anchor .sr-only}6. Fehlersuche {#heading_troubleshoot}

::::::::::::::::::: sectionbody
::: paragraph
Das Benachrichtigungsmodul in Checkmk ist sehr komplex --- weil es sehr
viele, sehr unterschiedliche Anforderungen abdeckt, die sich in
langjähriger Praxiserfahrung als wichtig herausgestellt haben. Die Frage
„Warum hat Checkmk hier nicht benachrichtigt?" wird Ihnen deswegen
gerade am Anfang öfter gestellt werden, als Sie vielleicht vermuten.
Deswegen finden Sie hier ein paar Tipps zur Fehlersuche.
:::

::: paragraph
Wenn eine Benachrichtigung von einem bestimmten Service nicht ausgelöst
wurde, ist der erste Schritt, die Historie der Benachrichtigungen für
diesen Service zu kontrollieren. Dazu öffnen Sie die Detailseite des
Services (indem Sie im Monitoring auf den Service klicken). Wählen Sie
im Menü [Service \> Service notifications.]{.guihint} Dort finden Sie
alle Ereignisse zu Benachrichtigungen für diesen Service chronologisch
von neu nach alt aufgelistet.
:::

::: paragraph
Hier ist ein Beispiel eines Services, für den die Benachrichtigung
versucht wurde, aber der E-Mail-Versand gescheitert ist, weil kein
SMTP-Server installiert ist.
:::

:::: imageblock
::: content
![Liste der Ereignisse zu Benachrichtigungen für einen
Service.](../images/intro_service_notifications.png)
:::
::::

::: paragraph
Noch mehr Informationen finden Sie in der Datei `~/var/log/notifiy.log`.
Diese können Sie als Instanzbenutzer z.B. mit dem Befehl `less`
auslesen:
:::

:::: listingblock
::: content
``` {.pygments .highlight}
OMD[mysite]:~$ less var/log/notify.log
```
:::
::::

::: paragraph
Falls Sie `less` noch nicht kennen: Mit der Tastenkombination `Shift+G`
springen Sie ans Ende der Datei (was bei Log-Dateien nützlich ist), und
mit der Taste `Q` beenden Sie `less`.
:::

::: paragraph
Mit dem Kommando `tail -f` können Sie den Dateiinhalt auch fortlaufend
beobachten. Das ist dann sinnvoll, wenn Sie nur an neuen Meldungen
interessiert sind, also solchen, die erst nach der Eingabe von `tail`
entstehen.
:::

::: paragraph
Hier ist ein Ausschnitt aus `notify.log` für eine erfolgreich ausgelöste
Benachrichtigung:
:::

::::: listingblock
::: title
\~/var/log/notify.log
:::

::: content
``` {.pygments .highlight}
2024-04-15 16:21:47,912 [20] [cmk.base.notify] Analysing notification (localhost) context with 14 variables
2024-04-15 16:21:47,912 [20] [cmk.base.notify] Global rule 'Notify all contacts of a host/service via HTML email'...
2024-04-15 16:21:47,913 [20] [cmk.base.notify]  -> matches!
2024-04-15 16:21:47,913 [20] [cmk.base.notify]    - adding notification of martin via mail
2024-04-15 16:21:47,913 [20] [cmk.base.notify] Executing 1 notifications:
2024-04-15 16:21:47,913 [20] [cmk.base.notify]   * notifying martin via mail, parameters: graphs_per_notification, notifications_with_graphs, bulk: no
2024-04-15 16:21:47,913 [20] [cmk.utils.notify] sending command LOG;HOST NOTIFICATION: martin;localhost;DOWN;mail;
2024-04-15 16:21:47,913 [20] [cmk.base.notify]      executing /omd/sites/mysite/share/check_mk/notifications/mail
2024-04-15 16:21:48,458 [20] [cmk.base.notify]      Output: Spooled mail to local mail transmission agent
2024-04-15 16:21:48,501 [20] [cmk.utils.notify] sending command LOG;HOST NOTIFICATION RESULT: martin;localhost;OK;mail;Spooled mail to local mail transmission agent;Spooled mail to local mail transmission agent
```
:::
:::::

::: paragraph
Mit dem Einrichten der Benachrichtigungen haben Sie den letzten Schritt
vollzogen: Ihr Checkmk-System ist einsatzbereit! Damit sind die
Möglichkeiten von Checkmk natürlich noch nicht ansatzweise ausgereizt.
:::

::: paragraph
[Weiter geht es mit dem Ausbau des Monitorings](intro_extend.html)
:::
:::::::::::::::::::
::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
