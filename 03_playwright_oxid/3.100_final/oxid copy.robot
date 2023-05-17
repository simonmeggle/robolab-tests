*** Comments ***
Coding-Hilfen verwenden:
1) Robocop - statische Code-Analyse
- RF Language Server: integriert
- Robot Code: pip install robotframework-robocop
Im dot-File ".robocop" können die enthält Argumente angegeben werden, z.b. welche Rules "excluded" werden sollen.
Übersicht über alle Regeln: https://robocop.readthedocs.io/en/stable/rules.html
Empfehlung: mit minimalen Anpassungen beginnen und selbst entscheiden, welche Rules Sinn machen.
Manche Rules sehen erst einmal sinnfrei aus (z.b. too many newlines), sorgen aber für konsistent aussehenden Code.
Das konsequente Entfernen von Leerzeichen am Zeilenende verhindert, dass Git-commits verwässert werden.
Alternativ können Rules auch inline angepasst werden:
robocop: disable=missing-doc-suite
Nach Änderung der Datei muss VS Code neu gestartet werden.

2) Robotidy - Code-Formatter
- RF Language Server: integriert
- Robot Code: pip install robotframework-tidy
Formatiert das Dokument automatisch beim Speichern (command: Strg+Shift+P "Format Document" bzw. VS Code Settings,
"Format on Save" bzw. "Formatter")


*** Settings ***
Documentation       Beschreibung der RF-Suite in Kurzform. Die README.md des Projektes sollte ausführlich
...                 Auskunft über Zweck des Tests, Stakeholder der Applikation etc. geben. Dieser Doc-String ist gewissemaßen die
...                 "Visitenkarte" der Suite, denn er ist ganz oben im HTML-Log zu sehen.

# I) Import von Standard-Libraries: immer _vor_ 3rdparty-Libraries!
Library             OperatingSystem
# II) Import von 3rdParty-Libraries
Library             Browser
# Verschlüsseln von sensiblen Daten mit der CryptoLibrary.
# Die Umgebungsvariable %ROBOT_CRYPTO_KEY_PASSWORD_APPNAME% speichert das Passwort für den
# private Key. Sie sollte im System hinterlegt sein - es ist nicht ratsam, diese unter "env"
# in der launch.json von VS Code zu hinterlegen (Gefahr, dass diese Datei ins Git committed wird!)
# Das Keypair darf bzw. sollte im Projektverzeichnis mitgepflegt werden.
Library             CryptoLibrary    %{ROBOT_CRYPTO_KEY_PASSWORD_APPNAME}
...                     variable_decryption=True    key_path=${CURDIR}${/}keys
# zum Anlegen von Screenshots im Teardown-Hook
Library             ScreenCapLibrary
# Bilderkennung / UI-Automatisierung
# Der Referenzfolder sollte möglichst schon beim Import der Library gesetzt werden.
# OS-spezifische Unterschiede können mit Subfoldern je Bild abgefangen werden: wird statt eines BildNAMENS
# ein ORDNER unterhalb des reference_folders angegeben, so versucht IHL, irgendeines der Bilder zu finden.
# Beispiel: Ordner "button_ok" mit Bildern "foobutton_win11.png" und "bar_bt_win10.png",
# Wait For Image    button_ok    # => der Test wird auf Win10 und 11 funktionieren.
#
# Um Inkompatibilitäten zwischen Linux/Windows zu vermeiden, kann die special variable ${/}
# verwendet werden, die je nach OS in / oder \ verwandelt wird.
Library             ImageHorizonLibrary
...                     reference_folder=${CURDIR}${/}images
...                     keyword_on_failure=Builtin.No Operation
# III) Laden von Resource Files.
# Einfügen des git-submodules "common" in neue, nicht template-basierte Projekte:
# git submodule add ssh://git@gitlab//e2e/common.git common
# Beispiele f. Resource-Files:
# - nützliche Helper-Funktionen für relative Lokalisierungen, Mehrsprachigkeit etc.
Resource            common/ImageHorizon.resource
# - Handling von Citrix-Sessions (s.u.)
Resource            common/Citrix.resource
# - Allgemeine Helper
Resource            common/Common.resource
# Beispiel: Laden einer komplexeren Datenstruktur aus einem Python-Dict (Beispiel zum Zugriff siehe Testcase 1):
Variables           testdata.py

# Nur in Ausnahmefällen notwendig: der Start und Login von Applikationen ist i.a.R. besser im Test Setup aufgehoben
Suite Setup         Suite Initialization
# Jeder Test sollte isoliert startbar sein; Abhängigkeiten zwischen Tests (z.b. Test1 = Login, Test 2 = xy) sind zu vermeiden.
# Stattdessen die Hooks "Setup" und "Teardown" verwenden, um jeden Test einzeln kontrollieren zu können. Das ist auch wichtig
# für die Re-execution von failed tests über Robotmk.
Test Setup          Test Initialization
Test Teardown       Test Finalization


*** Variables ***
# Vermeide "Set Suite Variable" in Suite Setup - möglichst alle Variablen
# hier in dieser Sektion definieren.
# Auch wenn RF bei Namen von variablen und Keywords case-insensitive ist, sollten
# globale Variablen (=Suite Context) UPPERCASE sein.
${BROWSER}          Chromium
${CITRIX_URL}       https://citrix.local/Citrix/ctxprodWeb/
${DOWNLOAD_DIR}     ${TEMPDIR}
# e2e-User (CryptoLibrary)
${USERNAME}         crypt:ei+N/y23BuDLKvCRSVQDC3D9oGWiZCMB57srjXlUtTXG2jTALwJ2/U+9KYnz0lAaAYsKaXuc7R0=
${PASSWORD}         crypt:Jp3G6eD4a+M9+JFjh9DKpgitah0JnbDSlvmDhf/I831/wpQ0HeqAVJ6ShDAehnI+xOo3PLU6YprOLYQ=


*** Test Cases ***
# Citrix-Applikation wird im Test Setup gestartet und ist bereit für den Test
# Unterhalb von Tests möglichst keine Library-Keywords und keine Schleifenkonstrukte verwenden;
# es sieht für RF-nicht-Kenner wüst aus, wenn sie im HTML-Log den Test ausklappen.
# Besser: Abstrahieren von komplexem/sperrigem Code in gut lesbaren und sprechenden Keywords.
Test Beispiel 1
    [Documentation]    Dokumentation dieses Tests, dieser Text
    ...    kann auch mehrzeilig sein; drei Punkte und zwei Space leiten Multiline ein (wie bei keywords)
    Oeffne Mandant
    Lade Report
    # Beispiel: Iterieren über Testdaten, die aus Python-Dict geladen wurden:
    FOR    ${KANTON_UC}    IN    @{TESTDATA}
        ${active}=    Evaluate    ${TESTDATA['${KANTON_UC}']['active']}==${True}
        IF    ${active}
            # ...
        END
    END


*** Keywords ***
Oeffne Mandant
    # (Mandant ist direkt nach dem Programmstart geöffnet)
    # Empfehlung: starte mit einer Assertion mit ausreichend langem Timeout.
    # So wird sichergestellt, dass die App bereit ist für den Test.
    # Mehrdeutige Keywords wie "Wait For" müssen sicherheritshalber immer mit Librarynamen genannt werden:
    ImageHorizonLibrary.Wait For    bild_welches_garantiert_dass_app_geoeffnet_wurde    90
    # ggf. Weitere Aktionen ...

Lade Report
    # Maximiere das Fenster, sofern es nicht schon maximiert ist
    Click Image If Exists    FIS_Maximize
    # Bewege Maus in obere linke Ecke, damit Abteilungen-Button kein Hover-Effekt zeigt.
    # Achtung: die ImageHorizonLibrary triggert "Panic"-Mode, wenn die Maus ins linke obere Eck bewegt wird.
    # Deshalb nicht zu Koordinate 1/1 fahren!
    Move To    10    10
    # "Wait For And Click"s sind die beste Methode, performant durch eine Abfolge von Navigations-Clicks
    # zu gelangen, ohne Zeit mit künstlichen "sleeps" zu verlieren.
    Wait For and Click    FIS_Navigation_Abteilungen
    Wait For and Click    Abteilungen_Finanzbuchhaltung
    Wait For and Click    Abteilungen_Finanzbuchhaltung_Kontenplan
    Wait For and Click    FIS_Filtereingabe
    Type    3000.00
    Wait For and Click    FIS_Kontenplan_Select
    # Heruntersetzen der Confidence normalerweise nicht notwendig / nicht empfohlen. "Letzte Rettung"!
    Set Confidence    0.89
    # markiere erste Zeile, damit Zeile blau markiert ist; der hier angewandte Trick ist, einen "Fixpunkt" (hier: Spaltenkopf)
    # anzuklicken, und hiervon 40px nach unten zu gehen. Tipp: Greenshot zeigt beim Erstellen von Screenshots bereits die Pixelzahl!
    Click To The Below Of Image    FIS_Kontenplan_Spalte_Name_40px_above    40
    # Wenn Confidence heruntergedreht wurde, sofort wieder resetten
    Set Confidence    0.99
    Wait For And Double Click    Abteilungen_Finanzbuchhaltung_Kontenplan_Liste_126-FW-Feurwehr_3000.00
    ImageHorizonLibrary.Wait For    Abteilungen_Finanzbuchhaltung_Kontenplan_Karte_126-FW-Feurwehr_3000.00
    Wait For and Click    FIS_Schliessen

Suite Initialization
    Set Suite Variable    ${SUITE_SETUP_OK}    False
    # App-Start, Login etc.
    # Wenn es hier kracht, kann im Suite Teardown ggf. reagiert werden (siehe Suite Finalization)
    Set Suite Variable    ${SUITE_SETUP_OK}    True

Test Initialization
    # "Starte App" ist der Entrypoint für den Aufruf einer Citrix-App:
    # - CITRIX_URL = Start-URL f. Anmeldung
    # - USERNAME/PASSWORD
    # - Name der Applikations-Kachel im Citrix-Dashboard
    # - Modus (accept/choose)
    # Durchgeführte Schritte:
    # - Anmeldung an SecureConnect (BrowserLib)
    # - Start der Citrix-Session per ICA-Download oder direkter Auswahl
    #    (hier gibt es keine Regel - muss getestet werden!)
    Citrix.Starte App    ${CITRIX_URL}    ${USERNAME}    ${PASSWORD}    FIS FinanzSuite BC    accept

Test Finalization
    # Lege Screenshot an, wenn Test-Start failed
    Run Keyword If Test Failed    Common.Take a Screenshot
    # Sicheres Beenden von Citrix-Sesions ("LogoffSessions")
    Citrix.LogoffSessions

Suite Finalization
    # Lege Screenshot an, wenn Suite-Start failed
    IF    '${SUITE_SETUP_OK}'=='False'    Common.Take A Screenshot
    # Weitere AufräumTasks...
