# WebApp
## Einleitung
Das Feature, welches ich für die ChatGPT Web-App programmiert habe, eröffnet die Möglichkeit mit Hilfe von ChatGPT eine To-Do liste zu sortieren nach der Wichtigkeit welche Aufgabe als erstes erledigt werden muss. 

## Anforderungen
Die Web-App soll eine To-do-Liste hinzufügen und eine Liste, wo diese To-do-Liste nach Wichtigkeit sortiert wird.
Die daten sollen in einer Datenbank gespeichert werden.  
Desweiteren habe ich die Technologien OpenAPI für die AI funktion, Flutter für die UI und Firebase für die Datenbank.

## Architekturdiagramm
![image](https://github.com/TimonKy/web_entwicklung_BFAX422A/assets/126243654/43953235-8019-4105-8e73-5e8abdb6f6bc)

## Klassendiagramm
![Klassendiagramm](https://github.com/TimonKy/web_entwicklung_BFAX422A/assets/126243654/8d12616a-77ce-41b5-a76e-263fe5038123)

## Design Überlegung
![Unbenannt](https://github.com/TimonKy/web_entwicklung_BFAX422A/assets/126243654/7074763c-5898-44e1-8c2f-7b69d8b41bc0)   
Es wurde beschlossen, in der Designüberlebeung eine normale todo-Liste auf der linken Seite und eine AI-Sortierte todo-Liste auf der rechten Seite zu platzieren. 

## Code
Im Volgendem Abschnitt wird erklärt was vom vorgegebenen Programm Verändert wurde.  

### Hauptanwendungs-Setup
Von Zeile 14 bis 16 der Hauptfunktion wurde Firebase mit einer Standardkonfigurationsoption für Web gestartet. Um sicherzustellen, dass die Initialisierung vor dem Fortsetzen des Codes abgeschlossen ist, erfolgt die asynchrone Initialisierung.  
Zeile 17 legt fest, dass die Offline-Datenpersistenz der Datenbank deaktiviert wird, damit die Datenbank ausschließlich im Online-Modus arbeitet.   

### Datenbankdienste 
Mit der Klasse DatabaseServices kann eine Kommunikation mit der Firestore-Datenbank hergestellt werden. Die Klasse ermöglicht vor allem die Hinzufügung, Aktualisierung, Abruf und Löschung von Todo-Objekten, wobei eine Konvertierung zwischen Firestore und Todo stattfindet.  
Im Konstruktor der DatabaseServices Klasee wird ein Firestore-Objekt in ein Todo-Objekt, durch fromJson, umgewandelt.  
Des weiteren wird auch ein Todo-Objekt in ein Firestore-Objekt umgewandet durch toJson.  
In der Methode getTodos werden alle todos aktualisiert wenn sich was in der Sammlung ändert, zum Beispiel ein neues todo wird Hinzugefügt.  
Von Zeile 23 bis 33 werden die Methoden addTodo, updateTodo und deleteTodo formuliert. 

### Todo-Modell
Die Todo-Klasse definiert die Erscheinungsweise eines Todo. String task, Timestamp createdOn und Timestamp updatedOn müssen vorhanden sein.  
Es wird im Konstruktor festgelegt, dass die zuvor erwähnten Eigenheiten bei der Erstellung eines Todo-Objekts neu definiert werden müssen.  
Ein Factory-Konstruktor fromJson wurde entwickelt, um sicherzustellen, dass die angegebenen Werte die korrekten Typen aufweisen.  
In den Zeilen 20 bis 30 wird ein neues Beispiel für das Todo-Objekt erzeugt.  
Mit der toJson-Methode wird ein Todo-Objekt in eine JSON-ähnliche DartMap umgewandelt, um die Todos im Firesore zu speichern.  
 
### Homepage
Es werden zwei FloatingActionButtons in den Zeilen 69 bis 86 eingefügt.  
Alle todos, die noch nicht in der allTodoTextsnot enthalten sind, werden in der for Schleife von Zeile 142 bis 146 eingefügt, damit sie später aus der sortListe ausgelesen werden.  
In der Zeile danach wird überprüft ob die Task gelöscht wurden und wen ja wird diese auch aus der allTodoTextsnot Liste gelöscht.  
Beim Löschen eines Todo aus der Todo-Liste öffnet sich mit einem langen Klick die sortList-Methode, um diese auch aus der AI-Liste zu löschen (Zeile169 bis 170).  
In Zeile 182 wird ein verticaler Divider eingefügt um ListTile auf der rechte Seite einzufügen.  
Dieser ListTile gibt die allTodoTexts Liste mit einer Nummerrierung aus, welches die Todos sind.  
Im Dialogfenster _displayTextInputDialog werden neue Todo-Objekte in einem Dialogfenster erstellt. Die Zeilen 235 und 236 verwenden das Timestamp.now, um den createdOn und den updatedOn einzustellen.  
Die sortList-Methode importiert zunächst die allTodoTextsnot-Liste. Anschließend erhält sie einen Prompt, in dem angegeben wird, was ChatGPT gneau mit der Liste zu tun hat. Danach wird ChatGPTs Antwort in die filterWords-Methode geschriben, in der ausschließlich die Todos extrahiert und anschließend zurückgegeben werden. Dieser Todos String wird dann in eine Liste geschrieben welche im ListTile ausgegeben wird.


## Zusammenfassung
Diese Todo-Listen-App kombiniert die Leistungsfähigkeit von Flutter für die Benutzeroberfläche mit Firebase für das Backend und OpenAPI für die KI-Integration. Diese Struktur ermöglicht es Benutzern, ihre Aufgaben effektiv zu verwalten und mit Hilfe der KI sinnvoll zu priorisieren. Die detaillierte Implementierung zeigt, wie die verschiedenen Komponenten miteinander interagieren, um eine nahtlose Benutzererfahrung zu bieten.
