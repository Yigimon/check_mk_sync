:::: {#header}
# Update-Matrix für Version [2.3.0]{.new}

::: details
[Last modified on 26-Feb-2025]{#revdate}[Edit this page on
GitHub](https://github.com/Checkmk/checkmk-docs/edit/2.3.0/src/onprem/de/update_matrix.asciidoc){.edit-document}
:::
::::

:::::::::::::::::::::::::::::::::::::::::: {#content}
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
[Updates und Upgrades](update.html) [Update auf Version
[2.3.0]{.new}](update_major.html) [Linux-Upgrade auf dem
Checkmk-Server](release_upgrade.html) [Grundsätzliches zur Installation
von Checkmk](install_packages.html)
:::
::::
:::::
::::::
::::::::

::::: sect1
## []{#intro .hidden-anchor .sr-only}1. Einleitung {#heading_intro}

:::: sectionbody
::: paragraph
Mit jeder Version von Checkmk fallen bislang unterstützte
Linux-Versionen weg und neue kommen hinzu. Dies kann es erforderlich
machen, vor einem Update von Checkmk ein oder mehrere [Upgrades Ihrer
Linux-Distribution](release_upgrade.html) vorzunehmen. Die Grafiken in
diesem Artikel helfen Ihnen bei der Ermittlung der geeigneten
Reihenfolge. Studieren Sie diese aufmerksam, bevor Sie im
[Download-Archiv](https://checkmk.com/download/archive){target="_blank"}
suchen oder Anfragen nach alten Paketen stellen. Sollten Sie auf eine
ältere Checkmk-Version als [2.3.0]{.new} aktualisieren wollen, lesen Sie
diesen Artikel bitte für die Checkmk-Version, die *Ziel* der
Aktualisierung ist.
:::
::::
:::::

::::::::: sect1
## []{#steps .hidden-anchor .sr-only}2. Ermittlung der Update-Schritte {#heading_steps}

:::::::: sectionbody
::: paragraph
Die Aufgabe ist es nun, in der [Kompatibilitäts-Matrix](#matrix) für
Ihre Linux-Distribution tendenziell von links oben nach rechts unten zu
gelangen. Dabei sind die Vorgaben für das [Update von
Checkmk](update.html) zu berücksichtigen:
:::

::: ulist
- Es darf keine Major-Version ausgelassen werden.

- Vor dem Update der Major-Version muss auf die höchste verfügbare
  Patch-Version aktualisiert werden. Die Mindestanforderungen sind im
  [Artikel zum Update auf [2.3.0]{.new}](update_major.html#update_patch)
  beschrieben.

- Beim Upgrade der Linux-Distribution muss auf der neuen
  Distributionsversion exakt dieselbe Checkmk-Version installiert
  werden, die auf der alten vorhanden war.
:::

::: paragraph
Auch Linux-Distributoren machen in der Regel eine Vorgabe:
:::

::: ulist
- Upgrades dürfen keine Version auslassen.
:::

::: paragraph
Aus diesen Anforderungen ergibt sich, dass Sie sich in der Grafik für
Ihre Linux-Distribution nur zeilen- oder spaltenweise bewegen dürfen --
jedoch niemals diagonal -- und, dass Sprünge nur dann zulässig sind,
wenn sie nicht gegen die oben genannten Vorgaben verstoßen.
:::
::::::::
:::::::::

:::::::::::::::::: sect1
## []{#matrix .hidden-anchor .sr-only}3. Kompatibilitäts-Matrix {#heading_matrix}

::::::::::::::::: sectionbody
::: paragraph
Die Checkmk-Versionsnummern am oberen Rand der Grafiken in den folgenden
Abschnitten zeigen immer diejenigen an, *ab* der eine Veränderung
vorgenommen wurde, also eine Linux-Version neu unterstützt oder nicht
mehr unterstützt wird. Eine Pfeilspitze am Ende eines Balkens bedeutet,
dass diese Checkmk-Version im Support ist, also weitere Patch-Versionen
folgen werden. Ein stumpfes Ende kennzeichnet dagegen eine Kombination
aus Checkmk-Version und Distributionsversion, die Ihr Support-Ende
erreicht hat. Das kann an einer abgekündigten Checkmk-Version (alle
Balken sind stumpf) oder vom Distributor nicht mehr unterstützten
Distribution liegen (einzelne Balken gehen mit Pfeilspitze weiter).
Erstellt werden die Grafiken automatisch aus täglich aktualisierten
Daten zu den verfügbaren Downloads, das Änderungsdatum dieses Artikels
gibt folglich nicht die Aktualität der angezeigten Daten wieder.
:::

::::: sect2
### []{#debian .hidden-anchor .sr-only}3.1. Debian {#heading_debian}

::: paragraph
Die Support-Zeiträume der Debian-Versionen entnehmen Sie dem
[Debian-Wiki](https://wiki.debian.org/LTS){target="_blank"} oder der
Übersicht bei
[endoflife.date.](https://endoflife.date/debian){target="_blank"}
:::

::: {#matrix_debian .paragraph}
Aktivieren Sie JavaScript, um an dieser Stelle die Kompatibilitätsmatrix
für Debian angezeigt zu bekommen.
:::
:::::

::::: sect2
### []{#redhat .hidden-anchor .sr-only}3.2. Red Hat Enterprise Linux {#heading_redhat}

::: paragraph
Red Hat stellt eine ausführliche Übersicht der [geplanten
Support-Zeiträume](https://access.redhat.com/support/policy/updates/errata){target="_blank"}
bereit. Bei endoflife.date finden Sie Informationen zu binärkompatiblen
Distributionen
[AlmaLinux](https://endoflife.date/almalinux){target="_blank"},
[CentOS](https://endoflife.date/centos){target="_blank"}, [Oracle
Linux](https://endoflife.date/oracle-linux){target="_blank"} und [Rocky
Linux](https://endoflife.date/rocky-linux){target="_blank"}.
:::

::: {#matrix_redhat .paragraph}
Aktivieren Sie JavaScript, um an dieser Stelle die Kompatibilitätsmatrix
für Red Hat Enterprise Linux angezeigt zu bekommen.
:::
:::::

::::: sect2
### []{#sles .hidden-anchor .sr-only}3.3. SUSE Linux Enterprise Server {#heading_sles}

::: paragraph
Auf der Seite von SUSE finden Sie die
[Lifecycle-Übersicht](https://www.suse.com/lifecycle/#product-suse-linux-enterprise-server){target="_blank"}.
Alternativ steht eine Übersicht bei
[endoflife.date](https://endoflife.date/sles){target="_blank"} zur
Verfügung.
:::

::: {#matrix_sles .paragraph}
Aktivieren Sie JavaScript, um an dieser Stelle die Kompatibilitätsmatrix
für SUSE Linux Enterprise Server angezeigt zu bekommen.
:::
:::::

:::::: sect2
### []{#ubuntu .hidden-anchor .sr-only}3.4. Ubuntu {#heading_ubuntu}

::: paragraph
Beachten Sie, dass STS-Versionen von Ubuntu ab [2.3.0]{.new} von Checkmk
nicht mehr unterstützt werden. Wir achten jedoch immer darauf, dass von
jeder Checkmk-Version, die für eine STS-Version bereitgestellt wurde,
ein Update bis zur nächsten LTS-Version möglich ist. Seit [2.3.0]{.new}
schafft die [OS Support Policy](#ossupport) klare Regeln.
:::

::: paragraph
Ubuntu selbst pflegt eine nach noch im Support befindlichen und
abgekündigten Versionen sortierte
[Liste](https://wiki.ubuntu.com/Releases){target="_blank"}. Nach
Erscheinungsdatum sortiert ist die Liste bei
[endoflife.date.](https://endoflife.date/ubuntu){target="_blank"}
:::

::: {#matrix_ubuntu .paragraph}
Aktivieren Sie JavaScript, um an dieser Stelle die Kompatibilitätsmatrix
für Ubuntu angezeigt zu bekommen.
:::
::::::
:::::::::::::::::
::::::::::::::::::

::::::::: sect1
## []{#ossupport .hidden-anchor .sr-only}4. Richtlinie zur Betriebssystemunterstützung (*OS Support Policy*) in Checkmk {#heading_ossupport}

:::::::: sectionbody
::: paragraph
Um einen Ausblick auf die Unterstützung durch künftige Checkmk-Versionen
zu ermöglichen und Updates von Distributionen und Checkmk besser planen
zu können, hat die Checkmk GmbH sich einige Regeln gegeben:
:::

::: ulist
- *Enterprise-Distributionen* (SLES, Red Hat Enterprise Linux) werden
  bis 10 Jahre nach deren Erscheinungsdatum oder bis zum offiziellen
  Support-Ende durch den Distributor unterstützt.

- *Community-Distributionen* (Debian, Ubuntu) werden bis 5 Jahre nach
  deren Erscheinungsdatum oder bis zum offiziellen Support-Ende durch
  den Distributor unterstützt, sofern es sich um LTS-Releases handelt.
:::

::: paragraph
In beiden Fällen ist der frühere Zeitpunkt entscheidend.
:::

::: paragraph
Wir streben dabei an, jede beim Erscheinen einer neuen Checkmk-Version
unterstützte Distributionsversion über den gesamten Produkt-Lifecycle
dieser Checkmk-Version zu unterstützen, sofern dem nicht technische
Gründe entgegenstehen oder die Zahl der gleichzeitig unterstützten
Versionen einer Distribution vier übersteigt. Ist dies der Fall,
behalten wir uns vor, die Distributionsversion mit dem kürzesten
Rest-Support nicht mehr zu unterstützen. Bekanntgegeben wird dies beim
Erscheinen einer neuer Checkmk-Version.
:::

::: paragraph
Ubuntu STS-Versionen werden seit Checkmk [2.3.0]{.new} gar nicht mehr
unterstützt. Konkret bedeutet das: Nutzer von Checkmk [2.2.0]{.new}
unter Ubuntu 23.10 müssen zunächst noch unter Checkmk [2.2.0]{.new} das
[Betriebssystem-Upgrade](release_upgrade.html) auf Ubuntu 24.04
durchführen, bevor sie Checkmk auf [2.3.0]{.new} aktualisieren können.
:::
::::::::
:::::::::
::::::::::::::::::::::::::::::::::::::::::
