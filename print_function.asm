.data
msg1: .ascii "Hello World!\n"
len1 = . - msg1
msg2: .ascii "Look Mom, I'm on the internet!\n"
len2 = . - msg2

.align
.text
.global _start

print:
@ Gib einen String aus
@ Arguments:
@ r0 - auszugebender String
@ r1 - Länge des Strings
@ Returns:
@ Anzahl der ausgegebenen Zeichen in r0

@ Register auf Stack sichern

@ Register für Ausgabe Systemaufruf verschieben
@ Ausgabe über STDOUT
LDR r0, =0
@ Ausgabe-Systemaufruf
LDR r7, =4
SWI #0

@ Register vom Stack holen
@ Rücksprung aus Funktion

_start:
@ Normale Ausgabe
LDR r0, =0
LDR r1, =msg1
LDR r2, =len1
LDR r7, =4
SWI #0

@ Ausgabe mit Funktion
LDR r0, =msg2
LDR r1, =len2
BL print

LDR r0, =0
LDR r7, =1
SWI #0
