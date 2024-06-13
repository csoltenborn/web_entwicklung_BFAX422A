# AI-powered Dev-Tool
  Name: Finn Eric Ehrlich
  
  Studiengang: BFAX422A

  Dozent: Christian Soltenborn
  
  Modul: Projekt Web Entwicklung

## Einleitung
   In diesem Projekt wurde eine Client/Server Web-Anwendung auf Basis des Projekts von Christian Soltenborn erstellt, die als Unterstützung für Entwickler dient. Die Anwendung stellt Funkionen bereit, wie     beispielweise Fehlerüberprüfungen in Code. Das Besondere dabei ist, das diese Funktionen KI gestützt sind. Die verwendete KI ist hierbei GPT3.5-Turbo.

   Diese App stellt eine simple Alternative zu bestehenden Systemen dar. Der Kernvorteil besteht darin, die Produktivität von Entwicklern zu steigern.
   Die Applikation stellt keinen normalen KI-Chat bereit sondern festverankerte, KI gestützte Funktionen. Dadurch sparen Entwickler Zeit, eigene Fragen/Anfragen an die KI zu stellen.

## Technologien
   Framework: Flutter
   Programmiersprache: Dart
   Schnittstellen: OpenAPI und OpenAI
  
## Anforderungen

### Funktionale Anforderungen:
- In dem linken Textfeld soll man seinen eigenen Programmcode hineinschreiben können.
- In dem rechten Textfeld sollen die Antworten der KI stehen.
- Über die Schaltfläche "Code auf Fehler überprüfen" soll der eingegebene Programmcode von der KI überprüft werden.
- Alle entdeckten Fehler sollen Rot markiert werden und einen Infotext daneben erhalten, der den Fehler erklärt.
- Wenn ein Fehler entdeckt wird, soll die Schaltfläche "Vorschlag zur Behebung des Fehlers erhalten" erscheinen.
- Über die Schaltfläche "Vorschlag zur Behebung des Fehlers erhalten" soll eine Fehlerbehebung durch die KI stattfinden.
- Über die Auswahlliste soll eine Programmiersprache auswählbar sein.
- Über die Schaltfläche "Code in eine andere Sprache konvertieren" soll die KI den eingegeben Programmcode in die ausgewählte Programmiersprache konvertieren.
- Über die Schaltfläche "Unit Tests generieren" sollen Unit tests zu der ausgewählten Programmiersprache von der KI generiert werden.
- Über die Schaltfläche "Code dokumentieren" soll der Code von der KI dokumentiert werden.

### Nicht funktionale Anforderungen:
- Platform: Web
- Robustheit: Die Anwendung darf nicht in einen Zustand gelangen, in dem sie nicht reagiert oder die Verbindung verliert.
- Performance: Die AI muss schnell Antworten können. Die Anwendung muss diese Antworten schnell anzeigen können
- Verfügbarkeit: Die Anwendung muss die Möglichkeit bieten, immer erreichbar zu sein.
- Nutzerfreundlichkeit: Die Anwendung benötigt ein gut strukturiertes und intuitives Design.
   
## Konzept
  Bei dem anfänglichen Ausarbeiten der Idee, wurde ein erstes UI-Konzept erstellt (siehe Abbildung 1). Das Design der Oberfläche ist simpel, intuitiv und enthält
  alle bis dahin geplanten Features.Durch die Abtrennung von Funktionen und Ein-/Ausgabe wird eine Übersichtlichkeit geschaffen. 
  Die Auswahlliste der Programmiersprache liegt zwischen den beiden Funktionen, für die sie relevant ist.
  
  Abbildung 1: UI-Konzept
  ![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/2ff00b0a-482f-44f5-b176-5a36c26b3ba7)

# Umsetzung

## UI Implementierung
   Während der Entwicklung wurden zwei weitere Ideen für Funktionen in das Projekt mit aufgenommen: Eine Schaltfläche für das Kopieren des generierten Codes und eine für Fehlerbehebungsvorschläge.
   Demnach sieht das Finale UI (siehe Abbildung 2) etwas anders aus, beinhaltet im Kern aber die gleiche Struktur. Alle UI-Elemente befinden sich in der "home_page.dart" Datei.

   Abbildung 2: Finales UI
   ![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/9c4fafca-b8e8-4f8f-bcfe-f3680b3d3733)

   Zunächst wurden die im Projekt schon bestehenden Elemente "UserInputField" und "AiAnswerText" angepasst und vergrößert. Das Textelement "AiAnswertext"
   wurde zu einer "SingeChildScrollsView" geändert, welche ein "RichText" enthält. Dieses "RichText" enthält Textspans.
   Zudem wurde die Schaltfläche vom Typ "Floatingbutton" entfernt, welche die Eingabe des Benutzers an den Server weitergeleitet hat.
   Die gesamten Komponenten wurden in einem "Column" Element eingebettet, welches zwei "Row" Elemente beinhaltet.
   In der ersten Reihe der Spalten wurden vier Schaltflächen vom Typ "TextButton" erstellt, welche alle ein passendes Icon enthalten.
   Die Schaltflächen sind "Code auf Fehler überprüfen", "Code in eine andere Sprache konvertieren", "Unit Tests generieren" und "Code dokumentieren".
   Zwischen der zweiten und dritten Schaltfläche wurde eine Auswahlliste vom Typ "Dropdownbutton", die der Auswahl von Programmiersprachen dient.
   Es wurden vier Programmiersprachen manuell der Liste hinzugefügt: C#, Java, Python und Javascript.
   Zudem wurde eine Kopierschaltfläche oben rechts neben dem "AiAnswerText" mit einem Kopiericon hinzugefügt.
   Des weiteren wurde eine weitere Schaltfläche "Vorschlag zur Behebung des Fehlers" vom Typ "TextButton" hinzugefügt, welche auch ein Icon enthält. 
   Das Besondere bei dieser Schaltfläche ist es, das sie in ein "Visibility" Element eingebettet wurde. 
   Das bedeutet das die Schaltfläche basierend auf einem Booleanwert zu sehen ist. Diese Schaltfläche wird unter der Auswahlliste angezeigt.
   
   Um den leeren Platz auszufüllen und Symmetrie zu schaffen, wurden alle Elemente außer die Auswahlliste in ein "Expanded" Element eingebettet. Des weiteren haben alle Schaltflächen einen Lila Hintergrund 
   erhalten. Für die Übersichtlichkeit wurden Abstände mithilfe von "SizedBox" zwischen Elemente eingebaut.
   
## Logik
### Client
  Um mit dem Server zu kommunizieren wurden alle Komponenten des geforkten Projekts beibehalten. Die einzige Änderung war der geänderte Messagetext in der Methode "_askAI".
  Dort wurde nun statt die Benutzereingabe eine Variable gesetzt, die den konstruierten Prompt enthält. Dieser Prompt wird je nach ausgeführter Funktion dynamisch erstellt.

  Abbildung 3: Methode "AnalyseCodeError"
  ![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/f1f22669-adb2-4e81-9373-0c550c4bb6db)
  Für die Funktion "Code auf Fehler überprüfen" wurde die Methode "AnalyseCodeError" geschrieben (siehe Abbildung 3), welche über das onPressed Event der Schaltfläche ausgeführt wird.
  Zunächst wurde die Variable "isErrorRequest", welche einen Booleanwert enthält, auf den Wert "true" gesetzt. Danach wurde die Variable "_prompt" mit einem speziell für die Fehlerüberprüfung erstellter 
  Text gefüllt. Dieser enthält sowohl die Anweisung als auch den eingegebenen Programmcode des Benutzers. Nach dem erstellen des Prompts, wird die Methode "_askAI" ausgeführt. 
  In dieser wird die Anfrage an den Server weitergeleitet und die Antwort in die Variable "response" gespeichert. Danach wird die Methode "_setAiAnswer" ausgeführt.
  Diese war in dem Projekt schon vorhanden und wurde den Anforderungen entsprechend bearbeitet.
  In dieser Methode wird in einem "setState" zunächst eine Liste "errorindex" geleert. Diese Liste beinhaltet die Indizies der Codezeilen, die einen Fehler enthalten.
  Die Antwort der KI wurde zunächst so bearbeitet, das sie keine Whitespaces mehr enthält. Danach wurden die Zeilen der Antwort einzeln aufgeteilt und in die Liste "code" geschrieben.
  Diese Liste besteht aus Stringwerten. Des weiteren wurde überprüft, ob es sich bei der aktuellen Anfrage um die Fehlerüberprüfung handelt. 
  Wenn dies zutrifft, wird die Methode "GetLineErrors" ausgeführt. In dieser Methode wurde mittels einer For-Schleife jede Codezeile darauf überprüft, ob diese das Format "// Error" enthält.
  Für jede gefundene Zeile wird deren Index in die Liste "errorindex" geschrieben. Es wurde eine weitere Überprüfung eingebaut, um sicher zu gehen, das auch wirklich Fehler vorhanden sind.
  Dies geschieht über eine kleine if-Abfrage, in der überprüft wird, ob die Liste keine Elemente enthält. Sollte diese keine Elemente enthalten, so wird die Variable "isErrorRequest" auf den Wert "false" 
  gesetzt. Zuletzt wird die Methode "setSpans" ausgeführt. In dieser Methde wird ein Mapping der Liste "code" durchgeführt, um den Zeilen indizes zu geben.
  Für jede Zeile wird ein Element vom Typ "TextSpan" zurückgegeben, in dem durch eine Überprüfung die Farbe des Textes festgelegt wird.
  Wenn der Zeilenindex mit einem aus der Liste "errorindex" übereinstimmt, wird der Text Rot gefärbt, ansonsten Schwarz. Diese "TextSpans" werden in der Liste "answerSpans" von "TextSpans" gespeichert.
  Die Liste "answerSpans" ist der Wert des "AiAnswerText" Elements.
  
### Server
  Der Server wurde im Rahmen dieses Projekts nicht angepasst. Er wurde aus dem geforkten Projekt genommen.
  Dies hat den Grund, das der zugrundeliegende Server für die Entwicklung die schon benötigten Funktionalitäten bietet.
  Von dem Client wird der erstellte Prompt über die ChatAPI an den Server weitergeleitet. 
  Dieser verarbeitet diese Anfrage mit dem Chat-Model 3.5-Turbo und sendet die Antwort der AI über die API zurück an den Client.

## Sequenz Diagramm
Abbildung #Zahl#: Sequenz Diagramm
![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/42e1b714-a4cd-47a5-9944-07f1a97fc9eb)
