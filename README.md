# AI-powered Dev-Tool
  Name: Finn Eric Ehrlich
  
  Studiengang: BFAX422A

  Dozent: Christian Soltenborn
  
  Modul: Projekt Web Entwicklung

## Einleitung
   In diesem Projekt wurde eine Client/Server Web-Anwendung erstellt, die als Unterstützung für Entwickler dient. Die Anwendung stellt Funkionen bereit, wie beispielweise Fehlerüberprüfungen in Code.
   Das Besondere dabei ist, das diese Funktionen KI gestützt sind. Die verwendete KI ist hierbei GPT3.5-Turbo.

   Diese App stellt eine simple Alternative zu bestehenden Systemen dar. Der Kernvorteil besteht darin, die Produktivität von Entwicklern zu steigern.
   Die Applikation stellt keinen normalen KI-Chat bereit sondern festverankerte, KI gestützte Funktionen. Dadurch sparen Entwickler Zeit, eigene Fragen/Anfragen an die KI zu stellen.

## Technologien
   Framework: Flutter
   Programmiersprache: Dart
   Schnittstellen: OpenAPI/OpenAI
  
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
   Demnach sieht das Finale UI etwas anders aus, beinhaltet im Kern aber die gleiche Struktur.

   Zunächst wurden die im Projekt schon bestehenden Elemente "UserInputField" und "AiAnswerText" angepasst und vergrößert. Das Textelement "AiAnswertext"
   wurde zu einem "RichText" welches "Textspans" als Text enthält. 
   

## Sequenz Diagramm
![image](https://github.com/FinnEhrl/web_entwicklung_BFAX422A/assets/147406212/42e1b714-a4cd-47a5-9944-07f1a97fc9eb)
