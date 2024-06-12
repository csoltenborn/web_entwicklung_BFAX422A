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
   Demnach sieht das Finale UI (siehe Abbildung 2) etwas anders aus, beinhaltet im Kern aber die gleiche Struktur.

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
   
   Um den Platz auszufüllen, wurden alle Elemente in ein "Expanded" Element eingebettet. Des weiteren haben alle Schaltflächen einen Lila Hintergrund erhalten.
   
## Logik
### Client
    
### Server
  Der Server wurde im Rahmen dieses Projekts nicht angepasst. Er wurde aus dem geforkten Projekt genommen.
  Dies hat den Grund, das der zugrundeliegende Server für die Entwicklung die schon benötigten Funktionalitäten bietet.
  Von dem Client wird der erstellte Prompt über die ChatAPI an den Server weitergeleitet. 
  Dieser verarbeitet diese Anfrage mit dem Chat-Model 3.5-Turbo und sendet die Antwort der AI über die API zurück an den Client.

## Sequenz Diagramm
![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/42e1b714-a4cd-47a5-9944-07f1a97fc9eb)
