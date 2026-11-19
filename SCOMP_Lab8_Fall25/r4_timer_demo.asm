        ORG 0
Switches:   EQU &H000
LEDs:       EQU &H001
Timer:      EQU &H002
Hex0:       EQU &H004
Hex1:       EQU &H005
CD_VAL:     EQU &H070
CD_CTRL:    EQU &H071
INT_PERIOD: EQU &H072
TIMER_SCALE: EQU &H073

Start:
        LOADI 0
        STORE Direction
        OUT   Hex1
        LOADI 1
        STORE Pattern
        OUT   LEDs
        LOADI 10
        CALL  ShowSeconds
        LOADI 0
        OUT   TIMER_SCALE
        LOADI 2
        OUT   INT_PERIOD
        LOADI 10
        OUT   CD_VAL

Main:
        IN    CD_VAL
        JZERO Done
        CALL  ShowSeconds
        IN    INT_PERIOD
        JZERO Main
        CALL  MoveLED
        JUMP  Main
Done:

        LOADI 0
        OUT   Hex0
        LOADI 1
        OUT   Hex1
AfterDone:
        IN    INT_PERIOD
        JZERO AfterDone
        CALL  MoveLED
        JUMP  AfterDone

ShowSeconds:
        ADDI  -10
        JZERO ShowTen
        ADDI  10
        OUT   Hex0
        RETURN
ShowTen:
        LOADI &H0010
        OUT   Hex0
        RETURN

MoveLED:
        LOAD  Direction
        JNZ   MoveRight
        LOAD  Pattern
        SUB   Bit9
        JZERO TurnRight
        LOAD  Pattern
        SHIFT 1
        JUMP  WriteLED
TurnRight:
        LOADI 1
        STORE Direction
        LOAD  Pattern
        SHIFT -1
        JUMP  WriteLED
MoveRight:
        LOAD  Pattern
        ADDI  -1
        JZERO TurnLeft
        LOAD  Pattern
        SHIFT -1
        JUMP  WriteLED
TurnLeft:
        LOADI 0
        STORE Direction
        LOAD  Pattern
        SHIFT 1
WriteLED:
        STORE Pattern
        OUT   LEDs
        RETURN

Pattern:   DW 1
Direction: DW 0

Bit9:      DW &H0200
