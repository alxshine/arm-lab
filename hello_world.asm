.data
@ Nachricht als ASCII String
msg: .ascii "Hallo, Welt!"
@ Länge des Strings
len = . - msg

.align
.text
.global _start
_start:
@ Ausgabe an STDOUT
LDR r0, =1
@ Adresse von msg nach r1 laden
@ Länge nach r2 laden
@ Ausgabe-Systemaufruf auswählen
LDR r7, =4
SWI #0

@ Rückgabewert 0 in r0 laden
LDR r0, =0
@ EXIT Systemaufruf auswählen
LDR r7, =1
SWI #0
