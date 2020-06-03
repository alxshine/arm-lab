.data
input: .ascii "racecar"
len = . - input
truemsg: .ascii " ist ein Palindrom"
truelen = . - truemsg
falsemsg: .ascii " ist kein Palindrom"
falselen = . - falsemsg

.align
.text
print:
    @ Gib einen String aus
    @ Arguments:
    @ r0 - auszugebender String
    @ r1 - Länge des Strings
    @ Returns:
    @ Anzahl der ausgegebenen Zeichen in r0

    @ Register auf Stack sichern
    STMFD sp!, {r7, lr}

    @ Register für Ausgabe Systemaufruf verschieben
    MOV r2, r1
    MOV r1, r0
    LDR r0, =0
    LDR r7, =4
    SWI #0

    @ Register vom Stack holen
    LDMFD sp!, {r7, lr}
    @ Rücksprung aus Funktion
    MOV pc, lr

palindrome:
    @ Teste ob der übergebene String ein Palindrom ist
    @ Arguments:
    @ r0 - Adresse des Strings
    @ r1 - Länge des Strings
    @ Returns:
    @ 1 falls String ein Palindrom ist, 0 sonst

    @ Register auf Stack sichern
    STMFD sp!, {lr}

    @ wenn String 1 oder 0 Zeichen lang ist, ist es ein Palindrom
    CMP r1, #1
    @ dann gib 1 zurück
    @ Register von Stack wieder herstellen
    @ Rücksprung aus Funktion

    @ teste ob erstes und letztes Zeichen gleich sind
    @ lade dafür das erste Zeichen
    @ letztes Zeichen ist in r0 + r1 - 1
    @ vergleiche erstes und letztes Zeichen

    @ ACHTUNG: Funktionen müssen Flags nicht speichern
    @ wenn nicht gleich, setze Rückgabewert auf 0
    @ wenn gleich, rekursiver Aufruf von zweitem bis vorletztem Zeichen

    @ Werte von Stack wiederherstellen
    @ Rücksprung

.global _start
_start:
    LDR r0, =input
    LDR r1, =len
    BL print

    LDR r0, =input
    LDR r1, =len
    BL palindrome

    CMP r0, #1
    LDREQ r0, =truemsg
    LDREQ r1, =truelen
    LDRNE r0, =falsemsg
    LDRNE r1, =falselen
    BL print

    LDR r0, =0
    LDR r7, =1
    SWI #0
