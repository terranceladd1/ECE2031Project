Switches    EQU &H000
LEDs        EQU &H001
OldTimer    EQU &H002
Hex0        EQU &H004
Hex1        EQU &H005
CD_VAL      EQU &H070
CD_CTRL     EQU &H071
INT_PERIOD  EQU &H072
TIMER_SCALE EQU &H073

        ORG   0
Start:
        LOADI 0
        OUT   LEDs
        OUT   Hex0
        OUT   Hex1
        IN    Switches
        AND   Bit9
        JNZ   ManualStart

        LOADI &H01
        CALL  SetTest
        LOADI 0
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        IN    CD_CTRL
        CALL  AssertEqual
        IN    INT_PERIOD
        CALL  AssertEqual
        LOADI 1
        STORE Expected
        IN    TIMER_SCALE
        CALL  AssertEqual

        LOADI 3
        CALL  DelayTicks
        LOADI 0
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        IN    CD_CTRL
        CALL  AssertEqual
        IN    INT_PERIOD
        CALL  AssertEqual

        LOADI &H02
        CALL  SetTest
        LOADI 0
        OUT   CD_VAL
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 1
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual
        IN    CD_CTRL
        CALL  AssertEqual

        LOADI &H03
        CALL  SetTest
        LOADI 2
        OUT   TIMER_SCALE
        LOADI 20
        OUT   CD_VAL
        LOADI 0
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual
        LOADI 10
        CALL  WaitDone
        LOADI 1
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual
        LOADI 0
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 2
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual

        LOADI &H04
        CALL  SetTest
        LOADI 1
        OUT   TIMER_SCALE
        LOADI 20
        OUT   CD_VAL
        LOADI 0
        OUT   CD_CTRL
        IN    CD_VAL
        STORE Expected
        LOADI 5
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 0
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual
        LOADI 1
        OUT   CD_CTRL
        LOADI 30
        CALL  WaitDone
        LOADI 0
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual

        LOADI &H05
        CALL  SetTest
        LOADI 0
        OUT   TIMER_SCALE
        LOADI 2
        OUT   CD_CTRL
        LOADI 0
        OUT   CD_CTRL
        LOADI 20
        STORE Expected
        IN    CD_VAL
        CALL  AssertLoaded
        LOADI 0
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual

        LOADI &H06
        CALL  SetTest
        LOADI 0
        OUT   CD_VAL
        LOADI 3
        OUT   CD_CTRL
        LOADI 0
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual

        LOADI &H07
        CALL  SetTest
        LOADI 1
        OUT   TIMER_SCALE
        LOADI 200
        OUT   CD_VAL
        LOADI 0
        OUT   CD_CTRL
        IN    CD_VAL
        STORE Expected
        LOADI 5
        OUT   CD_CTRL
        LOADI 3
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 4
        OUT   CD_CTRL
        LOADI 3
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual
        LOAD  AllBits
        OUT   CD_CTRL
        LOADI 3
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 0
        STORE Expected
        IN    CD_CTRL
        CALL  AssertEqual

        LOADI &H08
        CALL  SetTest
        LOADI 0
        STORE Expected
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual
        LOADI 1
        STORE Expected
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual
        LOADI 2
        STORE Expected
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual
        LOADI 3
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual

        LOADI 4
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual
        LOAD  AllBits
        OUT   TIMER_SCALE
        IN    TIMER_SCALE
        CALL  AssertEqual

        LOADI &H09
        CALL  SetTest
        LOADI 5
        OUT   INT_PERIOD
        LOADI 12
        CALL  WaitPeriod
        LOADI 0
        STORE Expected
        IN    INT_PERIOD
        CALL  AssertEqual
        LOADI 12
        CALL  WaitPeriod
        IN    INT_PERIOD
        CALL  AssertEqual

        LOADI &H0A
        CALL  SetTest
        LOADI 2
        OUT   INT_PERIOD
        LOADI 8
        CALL  WaitPeriod
        LOADI 7
        CALL  DelayTicks
        LOADI 1
        STORE Expected
        IN    INT_PERIOD
        CALL AssertEqual
        LOADI 0
        STORE Expected
        IN    INT_PERIOD
        CALL  AssertEqual

        LOADI &H0B
        CALL  SetTest
        LOADI 0
        OUT   INT_PERIOD
        LOADI 5
        CALL  DelayTicks
        LOADI 0
        STORE Expected
        IN    INT_PERIOD
        CALL  AssertEqual
        LOADI 3
        OUT   INT_PERIOD
        LOADI 10
        CALL  WaitPeriod
        IN    INT_PERIOD
        CALL  AssertEqual

        LOADI &H0C
        CALL  SetTest
        LOADI 0
        OUT   TIMER_SCALE
        LOADI 10
        OUT   CD_VAL
        LOADI 0
        OUT   CD_CTRL
        IN    CD_VAL
        STORE PausedValue
        CALL  StartKnownPeriod
        LOADI 20
        CALL  WaitPeriod
        LOADI 20
        CALL  WaitPeriod
        CALL  CheckPeriodMinimum
        LOAD  PausedValue
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 2
        OUT   TIMER_SCALE
        CALL  StartKnownPeriod
        LOADI 20
        CALL  WaitPeriod
        LOADI 20
        CALL  WaitPeriod
        CALL  CheckPeriodMinimum
        IN    CD_VAL
        CALL  AssertEqual
        LOADI 0
        OUT   INT_PERIOD
        IN    INT_PERIOD

        LOADI &H0D
        CALL  SetTest
        LOADI 0
        OUT   TIMER_SCALE
        LOADI 1
        CALL  CheckBoundary
        LOAD  Value32767
        CALL  CheckBoundary
        LOAD  Value32768
        CALL  CheckBoundary
        LOAD  AllBits
        CALL  CheckBoundary

        LOADI &H0E
        CALL  SetTest
        LOADI 0
        OUT   TIMER_SCALE
        LOADI 15
        STORE RateMinimum
        LOADI 3
        OUT   CD_VAL
        CALL  CheckCountdownRate
        LOADI &H0F
        CALL  SetTest
        LOADI 1
        OUT   TIMER_SCALE
        LOADI 20
        STORE RateMinimum
        LOADI 30
        OUT   CD_VAL
        CALL  CheckCountdownRate
        LOADI &H10
        CALL  SetTest
        LOADI 2
        OUT   TIMER_SCALE
        LOAD  Value300
        OUT   CD_VAL
        CALL  CheckCountdownRate

Passed:
        LOADI 0
        OUT   INT_PERIOD
        OUT   Hex0
        LOADI 1023
        OUT   LEDs
PassedLoop:
        JUMP  PassedLoop

SetTest:
        STORE TestID
        OUT   Hex1
        LOADI 0
        OUT   Hex0
        RETURN

AssertEqual:
        STORE Observed
        SUB   Expected
        JNZ   Fail
        RETURN

AssertLoaded:
        STORE Observed
        SUB   Expected
        JZERO LoadedOK
        ADDI  1
        JNZ   Fail
LoadedOK:
        RETURN

CheckBoundary:
        STORE Expected
        OUT   CD_VAL
        LOADI 0
        OUT   CD_CTRL
        IN    CD_VAL
        CALL  AssertLoaded
        LOAD  Observed
        STORE Expected
        LOADI 2
        CALL  DelayTicks
        IN    CD_VAL
        CALL  AssertEqual
        RETURN

BeginWait:
        STORE WaitLimit
        LOADI 0
        OUT   OldTimer
        LOAD  PollBlock
        STORE PollLow
        LOADI 100
        STORE PollHigh
        RETURN

PollBudget:
        LOAD  PollLow
        ADDI  -1
        STORE PollLow
        JNZ   BudgetOK
        LOAD  PollBlock
        STORE PollLow
        LOAD  PollHigh
        ADDI  -1
        STORE PollHigh
        JNZ   BudgetOK
        LOAD  BudgetCode
        STORE Observed
        JUMP  Fail
BudgetOK:
        RETURN

CheckDeadline:
        CALL  PollBudget
        IN    OldTimer
        STORE Elapsed
        SUB   WaitLimit
        JNEG  BeforeDeadline
        LOAD  TimeoutCode
        STORE Observed
        JUMP  Fail
BeforeDeadline:
        RETURN

WaitDone:
        CALL  BeginWait
WaitDoneLoop:
        IN    CD_CTRL
        STORE Observed
        JNZ   CheckDoneValue
        CALL  CheckDeadline
        JUMP  WaitDoneLoop
CheckDoneValue:
        ADDI  -1
        JNZ   Fail
        LOADI 1
        RETURN

WaitPeriod:
        CALL  BeginWait
WaitPeriodLoop:
        IN    INT_PERIOD
        STORE Observed
        JNZ   CheckPeriodValue
        CALL  CheckDeadline
        JUMP  WaitPeriodLoop
CheckPeriodValue:
        ADDI  -1
        JNZ   Fail
        LOADI 1
        RETURN

DelayTicks:
        STORE DelayTarget
        ADDI  10
        CALL  BeginWait
DelayLoop:
        IN    OldTimer
        SUB   DelayTarget
        JNEG  DelayNotYet
        RETURN
DelayNotYet:
        CALL  CheckDeadline
        JUMP  DelayLoop

StartKnownPeriod:
        LOADI 0
        OUT   INT_PERIOD
        IN    INT_PERIOD
        LOADI 10
        OUT   INT_PERIOD
        RETURN

CheckPeriodMinimum:
        IN    OldTimer
        STORE Elapsed
        ADDI  -5
        JNEG  TooEarly
        RETURN

CheckCountdownRate:
        LOADI 40
        CALL  WaitDone
        IN    OldTimer
        STORE Elapsed
        SUB   RateMinimum
        JNEG  TooEarly
        LOADI 0
        STORE Expected
        IN    CD_VAL
        CALL  AssertEqual
        RETURN

TooEarly:
        LOAD  EarlyCode
        STORE Observed
        JUMP  Fail
Fail:
        LOAD  TestID
        OUT   Hex1
        LOAD  Observed
        OUT   Hex0
        LOADI 341
        OUT   LEDs
FailLoop:
        JUMP  FailLoop

ManualStart:
        IN    Switches
        AND   Mask7
        STORE PreviousSwitches
        STORE CurrentSwitches
        LOADI 1
        STORE Pattern
        OUT   LEDs
        LOADI 0
        STORE Direction
        OUT   TIMER_SCALE
        LOADI 10
        OUT   CD_VAL
        LOAD  CurrentSwitches
        AND   Mask1
        JZERO InitialNotPaused
        LOADI 0
        OUT   CD_CTRL
InitialNotPaused:
        LOAD  CurrentSwitches
        AND   Mask4
        JNZ   InitialPeriodOff
        LOADI 2
        OUT   INT_PERIOD
        JUMP  ManualLoop
InitialPeriodOff:
        LOADI 0
        OUT   INT_PERIOD

ManualLoop:
        IN    Switches
        AND   Mask7
        STORE CurrentSwitches
        XOR   PreviousSwitches
        STORE ChangedSwitches
        AND   Mask1
        JZERO CheckRestartSwitch
        LOAD  CurrentSwitches
        AND   Mask1
        JZERO ResumeFromSwitch
        LOADI 0
        OUT   CD_CTRL
        JUMP  CheckRestartSwitch
ResumeFromSwitch:
        IN    CD_CTRL
        JNZ   CheckRestartSwitch
        LOADI 1
        OUT   CD_CTRL
CheckRestartSwitch:
        LOAD  ChangedSwitches
        AND   Mask2
        JZERO CheckPeriodSwitch
        LOAD  CurrentSwitches
        AND   Mask2
        JZERO CheckPeriodSwitch
        LOADI 10
        OUT   CD_VAL
        LOAD  CurrentSwitches
        AND   Mask1
        JZERO CheckPeriodSwitch
        LOADI 0
        OUT   CD_CTRL
CheckPeriodSwitch:
        LOAD  ChangedSwitches
        AND   Mask4
        JZERO ManualDisplay
        LOAD  CurrentSwitches
        AND   Mask4
        JNZ   DisableFromSwitch
        LOADI 2
        OUT   INT_PERIOD
        JUMP  ManualDisplay
DisableFromSwitch:
        LOADI 0
        OUT   INT_PERIOD
ManualDisplay:
        LOAD  CurrentSwitches
        STORE PreviousSwitches
        IN    CD_CTRL
        JZERO DisplayRunning
        LOADI 2
        STORE ManualStatus
        LOADI 0
        CALL  ShowSeconds
        JUMP  DisplayStatus
DisplayRunning:
        LOAD  CurrentSwitches
        AND   Mask1
        STORE ManualStatus
        IN    CD_VAL
        CALL  ShowSeconds
DisplayStatus:
        LOAD  CurrentSwitches
        AND   Mask4
        ADD   ManualStatus
        OUT   Hex1
        IN    INT_PERIOD
        STORE PeriodEvent
        JZERO ManualLoop
        LOAD  CurrentSwitches
        AND   Mask4
        JNZ   ManualLoop
        CALL  MoveLED
        JUMP  ManualLoop

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

Bit9:             DW &H0200
Mask1:            DW &H0001
Mask2:            DW &H0002
Mask4:            DW &H0004
Mask7:            DW &H0007
AllBits:          DW &HFFFF
Value32767:       DW &H7FFF
Value32768:       DW &H8000
Value300:         DW 300
PollBlock:        DW 30000
TimeoutCode:      DW &HE001
BudgetCode:       DW &HE002
EarlyCode:        DW &HE003

TestID:           DW 0
Expected:         DW 0
Observed:         DW 0
PausedValue:      DW 0
WaitLimit:        DW 0
Elapsed:          DW 0
DelayTarget:      DW 0
PollLow:          DW 0
PollHigh:         DW 0
RateMinimum:      DW 0
Pattern:          DW 1
Direction:        DW 0
PreviousSwitches: DW 0
CurrentSwitches:  DW 0
ChangedSwitches:  DW 0
ManualStatus:     DW 0
PeriodEvent:      DW 0
