.data
msg: .ascii "Hallo, Innsbruck!\n"
len = . - msg

.align
.text
.global _start
_start:
@ Start-Adresse
@ Wir geben nur einzelne Zeichen
LDR r2, =1
@ Ausgabe-Systemaufruf auswählen

@ Pointer zu Ende (für Abbruchbedingung)
ADD r3, r3, r1
loop:
@ Wenn Ende erreicht, dann spring aus Schleife
BEQ after_loop
@ Ausgabe an STDOUT
LDR r0, =0
SWI #0
@ Pointer auf aktuelles Zeichen eins weiter schieben
ADD r1, #1
B loop

after_loop:
@ Sauber beenden
LDR r0, =0
LDR r7, =1
SWI #0
