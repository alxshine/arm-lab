.data
msg1: .ascii "Hello 1!\n"
msg2: .ascii "Testi 2!\n"
len = . - msg2

.align
.text
.global _start
_start:
@ Ausgabe Systemaufruf
@ Ausgabe über STDOUT
@ Adresse unseres Strings ist msg1
@ Länge unseres Strings ist len
@ Ausgabe
SWI #0

LDR r7, =4
LDR r0, =0
@ Adresse unseres Strings ist diesmal msg2
LDR r2, =len
SWI #0

@ Register für Schleife vorbereiten:
@ - msg1 in r0
@ - msg2 in r1
@ - Anzahl der zu tauschenden Zeichen in r2
@ - Schleifenzähler in r3 mit 0 initialisieren

@ eigentliche Schleife zum tauschen
swaploop:
@ Byte aus msg1 laden, mit r3 als Offset
@ Byte aus msg2 laden, mit r3 als Offset
@ Byte aus msg1 in msg2 speichern, mit r3 als Offset
@ Byte aus msg2 in msg1 speichern, mit r3 als Offset

@ Schleifenzähler erhöhen
@ Abbruchbedingung überprüfen
@ Wenn Zähler kleiner gewünschte Anzahl -> Sprung in Schleife
BLT swaploop

@ msg1 ausgeben

@ msg2 ausgeben

@ Programm beenden
