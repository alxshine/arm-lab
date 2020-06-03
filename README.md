# ARM Übungseinheit, Rechnerarchitektur Proseminar

In dieser interaktiven ARM Übung werden wir gemeinsam folgende Details zur ARM Programmierung besprechen:

- wie installiere ich die ARM Entwicklungsumgebung für mein Ubuntu Betriebssystem?
- wie kompiliere ich ein einfaches ARM Programm?
- wie führe ich das Programm aus?
- wie kann ich die Kompilierung einfacher gestalten?
- wie kann ich Fehler in meinem Progamm einfacher finden?
- wie schreibe ich komplexe Programme mit mehreren Funktionen?

## Vorbedingungen

Unsere Installations Befehle sind der Einfachheit halber für das [Ubuntu Betriebssystem](https://ubuntu.com/download/desktop) geschrieben.
Die gleichen Befehle können auf [Pop!_OS](https://pop.system76.com/) verwendet werden.
Auf anderen Distributionen sind die hier verwendeten Tools und Programme auch vorhanden, allerdings in anderen Installations-Paketen.

In dieser Übung wird Wissen aus der Rechnerarchitektur Vorlesung vorausgesetzt, Grundlagen der C Programmierung sind von Vorteil, da wir immer wieder parallelen zwischen ARM Assembly und C sehen werden.

## Installieren der Toolchain

Als erstes müssen wir die Toolchain installieren.
Diese Besteht für ARM Assembly aus einem Assembler und einem Linker.
Zum Ausführen brauchen wir noch einen Emulator für die ARM Architektur.

Der Assembler übersetzt die von uns geschriebenen Assembly Dateien in sogenannte Object Dateien.
Darin steht der gleiche Code, nur in einem für die Maschine einfacher lesbaren binären Format.
Der Linker kombiniert mehrere dieser Object Dateien zu einer ausführbaren binären Datei.
Dabei ordnet er die Code und Daten Blöcke aus den einzelnen Object Dateien um, und ersetzt Sprünge und Funktionsaufrufe durch die endgültigen Adressen.

Sowohl der Assembler als auch der Linker zählen zu den sogenannten `binutils`, Programmen zur Manipulation von Binärdateien.
Wir benötigen deren Variante für GNU/Linux, mit Unterstützung für Floating Point Zahlen in Hardware.
Das Paket dazu kann mit folgendem Befehl installiert werden:

```shell
sudo apt install binutils-arm-linux-gnueabihf
```

Nun haben wir noch das Problem, dass unsere Maschinen eine andere Instruktionssatzarchitektur als ARM verwenden, und wir die generierten Binärdateien nicht direkt ausführen können.
Dafür verwenden wir den [QEMU](https://www.qemu.org/) Emulator.
Wir verwenden QEMU um den User-Modus von anderen Prozessorarchitekturen zu emulieren, und benötigen dafür das User-Mode Paket von QEMU.
Das können wir mit folgendem Befehl installieren:

```shell
sudo apt install qemu-user
```

## Erstes "Hallo, Welt!" Programm

Für unser erstes Programm schreiben wir ein kleines Programm das einen Text ausgibt und sich dann beendet.
Damit üben wir gleichzeitig die grundlegenden Befehle in ARM Assembly und lernen wie man Text und Rückgabewerte mittels System-Interrupt ausgibt.
Der Code dafür ist in der Datei `hello_world.asm`.

### Code vervollständigen

Im Code sind einige Lücken, die wir einfüllen müssen damit das Programm "Hallo, Welt!" ausgibt und sich dann beendet.

### Kompilieren und Ausführen

Nachdem wir das Programm vervollständigt haben wollen wir es natürlich ausführen.
Dafür müssen wir es assemblieren, linken, und dann emulieren.
Assembliert wird das Programm mit dem Befehl: `arm-linux-gnueabihf-as hello_world.asm -o hello_world.o`.
Die generierte Object Datei wir dann mit dem folgenden Befehl zu einer ausführbaren Datei gelinkt: `arm-linux-gnueabihf-ld hello_world.o -o hello_world`.
Danach können wir das generierte Programm mit dem Befehl `qemu-arm ./hello_world` ausführen.
Unter Ubuntu kann auch ein simples `./hello_world` ausreichen, solange das QEMU Paket installiert ist.

### Vereinfachtes Kompilieren

Damit wir nicht jedes mal mehrere Befehle zum Kompilieren eingeben müssen, verwenden wir ein sogenanntes `Makefile`.
Darin sind die fertigen Programme aufgelistet, die wir generieren wollen, sowie die Dateien aus denen sie generiert werden und mit welchen Befehlen.
Das Standardziel wird mit dem Befehl `make` generiert, in unserem Fall ist das das `hello_world` Programm.
Für alle anderen Programme muss deren Name dem `make` Befehl als Argument übergeben werden.

Bei mehr Interesse schau einfach mal ins [Makefile](./Makefile), es ist gar nicht so kompliziert.

## Kontrollstrukturen: Schleifen und Verzweigungen

Sobald wir Programme schreiben wollen die kompliziertere Aufgaben erledigen, brauchen wir Kontrollstrukturen wie Schleifen (for, while) und Verzweigungen (if).
Schleifen funktionieren in fast allen Assembler Varianten gleich: solange die Schleifenbedingung erfüllt ist wird zu einem Schleifen-Label gesprungen.
Ein `for(int i=0; i<10; i++) {/*mach was*/}` sieht in ARM Assembly zum Beispiel folgendermaßen aus (das *@* wird für Kommentare verwendet):

```asm
LDR r0, =0
loop:
@ mach was
ADD r0, r0, #1
CMP r0, #10
BLT loop
```

Wir brauchen also folgende Bauteile für eine Schleife:

- ein Label, zu dem wir springen können
- eine Überprüfung ob wir noch zurückspringen sollen
- einen bedingten Rücksprung zu unserem Label

In dieser Schleife haben wir sogar implizit schon ein `if` verwendet.
Es gibt in ARM Assembly die Möglichkeit, nahezu jede Anweisung bedingt auszuführen.
So ist die Anweisung `BLT` nur eine Zusammensetzung aus dem *branch* Befehl `B` und der Bedingung *less than* mit dem Kürzel `LT`.
Die Anweisung wird dann nur ausgeführt solange die Bedingung *less than* erfüllt ist, was über Flags in einem speziellen Register überprüft wird.
In unserem kleinen Code-Beispiel wir die `CMP` Anweisung verwendet um zu überprüfen ob der Wert in r0 kleiner ist als 10.
`CMP` führt eine Subktraktion der beiden Operanden aus, setzt die Flags, und verwirft dann das Ergebnis.
So können die Flags aktualisiert werden ohne Werte in Registern zu überschreiben.
Eine Liste mit allen Vergleichsoperationen findest du auf unserem [ARM Cheatsheet](cheatsheet.pdf).

Alternativ zu den Vergleichsoperationen kann fast jeder Operation der Suffix `S` angehängt werden.
Dann werden alle oder manche Flags aktualisiert.
Genauere Informationen dazu, welche Flags nun aktualisiert werden suchst du am besten im [ARM Infocenter](http://infocenter.arm.com/help/index.jsp) für die jeweilige Instruktion.

### Übung: String Zeichen für Zeichen ausgeben

Zur Übung von Schleifen werden wir in der Datei [print_indiviual.asm](print_indiviual.asm) den String "Hallo, Innsbruck!\n" ausgeben, aber Zeichen für Zeichen.

Für diese Übung ist es wichtig zu verstehen, wie Strings im Speicher abgelegt sind.
Wenn wir einen String folgendermaßen im Speicher anlegen:

```asm
msg: .ascii "Hallo, Innsbruck!\n"
len = . - msg
```

dann passiert nichts anderes als dass die Zeichen der Zeichenkette "Hallo, Innsbruck!\n" als ASCII Zeichen interpretiert werden, und ihre dekodierten Binärwerte nacheinander im Speicher abgelegt werden.
Das Label `msg` wird dann überall wo es verwendet wird durch die Adresse des ersten Zeichens der Zeichenkette ersetzt.
Wenn wir also die Adresse `msg` in ein Register laden, und dann von dieser Adresse aus dem Speicher ein Byte laden, dann steht der erste Buchstabe "H" in unserem Register.

### Übung: Zwei Arrays tauschen

Als zweite Übung zu Schleifen werden wir Zeichen aus zwei Strings tauschen.
Wir haben dazu wieder einen Code mit Lücken [vorbereitet](array_swap.asm).

Um zwei Zeichenketten zu tauschen müssen wir ein Zeichen nach dem anderen aus den Ketten laden, und dann in die *jeweils andere* Zeichenkette speichern.
Die Kommentare sollten in der Datei `array_swap.asm` sollten dir dabei auch helfen.

### Fehlersuche für komplexe Programme

Jetzt wo unsere Programme komplexer werden ist es oft schwer, Fehler darin zu finden wenn sie passieren.
Um uns die Fehlersuche zu erleichtern können wir einen sogenannten Debugger verwenden, um unsere Programme Schritt für Schritt auszuführen und uns die Registerwerte anzuschauen.

Da wir Programme für eine andere Instruktionssatzarchitektur debuggen wollen als die, auf der unser Betriebssystem läuft ist der Prozess etwas komplizierter.
Normalerweise können wir das Programm einfach mit dem Debugger starten und dann Schritt für Schritt ausführen.
Hier müssen wir QEMU mit besonderen Optionen starten und dann unseren Debugger mit der Instanz verbinden.
Auch brauchen wir einen besonderen Debugger: `gdb-multiarch`.
Die *multiarch* Variante des GDB Debuggers kann für mehrere Architekturen verwendet werden, und erspart es uns einen speziellen Debugger pro Ziel-Architektur zu verwenden.

Wir können den Debugger mit folgendem Befehl installieren:

```shell
sudo apt install gdb-multiarch
```

und dann mit dem Befehl `gdb-multiarch` ausführen.

Die Standardansicht von GDB ist nicht sehr übersichtlich, aber es gibt noch einen TUI (Terminal User Interface) Modus, der deutlich komfortabler ist.
Dieser kann mit der Option `--tui`, oder mit der Tastenkombination `Strg+x,a` (das a ist ohne gedrückte Steuerungstaste) geöffnet werden.
Standardmäßig versucht der TUI Modus den Quellcode des Programms zu zeigen, den es bei uns nicht gibt, da wir direkt ARM Assembly geschrieben haben.
Die Anzeige können wir mit dem Befehl `layout asm` auf Assembly Output umstellen.

GDB kann unsere Programme nicht selbst starten.
Stattdessen müssen wir QEMU sagen, dass es mit der Ausführung erst dann weiter beginnen soll, sobald es merkt dass sich ein Debugger mit der Instanz verbunden hat.
Das machen wir mit der Option `-g`, die als Argument einen TCP Port benötigt, z.B. `qemu-arm -g 1234 hello_world`.
Wir können dann GDB mit dem Befehl `target remote localhost:1234` sagen, dass es sich mit diesem Port verbinden soll.

Wenn wir also das Programm `hello_world` debuggen wollen, brauchen wir folgende zwei Befehle:

```shell
qemu-arm -g 1234 ./hello_world
gdb-multiarch --tui -ex "target remote localhost:1234" -ex "layout asm" ./hello_world
```

Die beiden `-ex` Argumente beinhalten die Befehle, die GDB ausführen soll.
Diese können auch einfach in der GDB Eingabeaufforderung eingegeben werden.

Beachte dass die beiden Befehle in jeweils einem eigenen Terminal ausgeführt werden müssen.

## Komplexe Programme: Funktionen

Da wir Code nicht mehrmals schreiben wollen, wenn unsere Programme länger werden, macht es Sinn einzelne Funktionalitäten in Funktionen auszulagern.
Wenn wir diese Funktionen aufrufen wollen wir natürlich auch, dass diese nicht ale Register überschreiben und somit Daten zerstören.
Zu diesem Zweck gibt es die ARM Aufrufkonvention:

- Register r0, r1, r2, und r3 sind für Parameter
- Register r0 ist für Rückgabewerte
- Die Adresse, an der der Code nach der Funktion ausgeführt werden soll, steht im Link Register lr

Sollte eine Funktion Register über r3 benötigen, so muss sie die originalen Werte vor dem Überschreiben speichern, und danach wieder herstellen.
Variablen werden auf dem Stack mit dem Befehl `STMFD` (store multiple, full descending) gesichert, und mit `LDMFD` (load multiple, full descending) wieder hergestellt.
Die Funktion selbst wird mit der *branch and link* Anweisung `BL` aufgerufen.

### Übung: Print Systemaufruf als Funktion

Wie in unserem array_swap Beispiel schon gesehen haben wir oft das Problem dass sich die Befehle zur Ausgabe wiederholen.
Das Wählen des korrekten Systemaufrufs, das Setzen der richtigen Ausgabe, sowie der Systemaufruf selber müssen jedes Mal neu vorgenommen werden.

Stattdessen möchten wir jetzt eine Funktion haben, die uns mit den zwei nötigen Parametern Adresse und Länge einen String ausgibt.
Der Code mit Lücken dazu ist in der datei [print_function.asm](print_function.asm).

### Übung: Rekursion

Da wir nun Funktionen schreiben können die keine Zwischenergebnisse zerstören, können wir uns einer Technik aus der funktionalen Programmierung widmen: rekursiven Funktionen.
Als eine rekursive Funktionen bezeichnet man eine Funktion die sich, direkt oder indirekt, selber aufruft.
Viele Probleme lassen sich deutlich eleganter rekursiv lösen als mit Schleifen, deshalb ist Rekursion ein wichtiges Werkzeug für jeden Programmierer und jede Programmiererin.

Als Übung zu Rekursion schreiben wir ein Programm, das erkennt ob ein gegebenes Wort ein [Palindrom](https://de.wikipedia.org/wiki/Palindrom) ist.
Den Code dafür findest du in [palindrome.asm](palindrome.asm).
