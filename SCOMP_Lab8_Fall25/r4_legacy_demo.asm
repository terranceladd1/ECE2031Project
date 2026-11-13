        ORG 0
Switches: EQU &H000
LEDs:     EQU &H001
Timer:    EQU &H002
Hex0:     EQU &H004
Hex1:     EQU &H005

Start:
        LOADI 0
        STORE Direction
        OUT   Hex1
        LOADI 1
        STORE Pattern
        OUT   LEDs
        LOADI 10
        STORE SecondsLeft
        STORE NextSecond
        CALL  ShowSeconds
        LOADI 2
        STORE NextLED
        LOADI 0
        OUT   Timer

Main:
        IN    Timer
        STORE Now
CheckSecond:
        LOAD  SecondsLeft
        JZERO Done
        LOAD  Now
        SUB   NextSecond
        JNEG  ServiceLED
        LOAD  NextSecond
        ADDI  10
        STORE NextSecond
        LOAD  SecondsLeft
        ADDI  -1
        STORE SecondsLeft
        CALL  ShowSeconds
        JUMP  CheckSecond
ServiceLED:
        CALL  CheckLED
        JUMP  Main
Done:
        LOADI 0
        OUT   Hex0
        LOADI 1
        OUT   Hex1
AfterDone:
        IN    Timer
        STORE Now
        CALL  CheckLED
        JUMP  AfterDone

CheckLED:
        LOAD  Now
        SUB   NextLED
        JNEG  NoLEDEvent
AdvanceLED:
        LOAD  NextLED
        ADDI  2
        STORE NextLED
        LOAD  Now
        SUB   NextLED
        JNEG  DoLEDEvent
        JUMP  AdvanceLED
DoLEDEvent:
        CALL  MoveLED
NoLEDEvent:
        RETURN

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
Now:        DW 0
SecondsLeft: DW 10
NextSecond: DW 10
NextLED:    DW 2

Bit9:      DW &H0200
