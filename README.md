# SCOMP Timer Peripheral (ECE 2031 Project)

A time-based I/O peripheral for SCOMP: an independent countdown with a done flag and a drift-free periodic tick, at I/O addresses 0x070–0x073 within the course-reserved range 0x070–0x07F.

- **Current Register Map:** https://docs.google.com/document/d/1MqQJpHz38CJbJ5rJvDWZvqNIUWdX6qTd-m8o5Bhb5qs/edit
- **Programmer's Reference Manual (draft; use the register map above for current addresses):** https://docs.google.com/document/d/1wXg2tX60ipIZ6WCXmOE4ErOo9tXZ6VG4BwRyAMGlQ2M/edit
- **Roadmap:** spec freeze Nov 10 · integration Nov 18 · first board test Nov 20 · feature freeze Nov 23 

## What's in this repo

The Quartus project lives in `SCOMP_Lab8_Fall25/`. Keep all project files inside that folder and don't move them into subfolders: the `.qsf` and `SCOMP.vhd` (memory init) refer to them by path.

| File(s) in `SCOMP_Lab8_Fall25/` | What it is | Owner |
|---|---|---|
| `TIMER_PERIPH.vhd` | The new peripheral | Role 1 (logic), Role 2 (ports, decode, bus) |
| `SCOMP_System.bdf` | Top-level schematic | Role 2 |
| `SCOMP.vhd` | The processor (unchanged except the `.mif` name) | Role 2 |
| `*.vwf` | Simulation tests | Role 3 |
| `*.asm`, `*.mif` | SCOMP test and demo programs, and their assembled output | Role 4 |
| `*.qpf`, `*.qsf`, `PLL_main*` | Quartus project settings and the PLL | Role 2 |
| `TIMER.vhd`, `DIG_IN.vhd`, `DIG_OUT.vhd`, `HEX_DISP*`, `clk_div.vhd` | Lab 8 peripherals (reference, leave as is) | Nobody |

Build output (`db/`, `output_files/`, `*.sof`, reports) is ignored. Compile locally to get a `.sof`.

## Role 4 software

- `r4_legacy_demo.asm`: countdown and moving LED using the original timer at `0x002`.
- `r4_timer_demo.asm`: the same basic demo using Timer 2.0; 63 instruction words instead of 85 in the legacy demo.
- `r4_timer_tests.asm`: 16 automatic test groups and a manual controls mode.

Each source has a matching `.mif`. Both new-timer programs use `CD_VAL=0x070`, `CD_CTRL=0x071`, `INT_PERIOD=0x072`, and `TIMER_SCALE=0x073`.

`SCOMP.vhd` loads `SimpleDemo.mif`, which currently matches the legacy demo. After hardware integration, copy the chosen program's MIF to `SimpleDemo.mif`, rebuild the Quartus project, and program the board. Changing a MIF on disk does not update the FPGA.

For `r4_timer_tests.mif`, set SW9 before pressing and releasing KEY0: 0 selects automatic tests; 1 selects manual mode. In manual mode, SW0=1 pauses the countdown and SW0=0 resumes it; a SW1 transition from 0 to 1 restarts it; SW2=1 stops LED movement and SW2=0 enables it. Automatic PASS is upper digits `10`, lower digits `0000`, and all ten LEDs on. Manual completion with LED motion enabled is upper digits `02`, lower digits `0000`, with the LED continuing to move.

Software validation on 2026-11-20 passed: all three source/MIF pairs and the selected legacy image, 10 local tool tests, 6 demo scenarios, 3 edge cases, 5 automatic runs covering 16 groups each, 8 fault-detection cases, and 4 manual scenarios. This includes a full 10 MHz instruction-level model run without polling acceleration. These are software-model results; official SCASM, Quartus, HDL simulation, and FPGA board verification were not rerun. Hardware integration is required before the new-timer programs can be tested on the board.

## How we work

1. **`main` always compiles.** Nobody commits straight to `main`.
2. **One branch per task**, named `role-task`, e.g. `r1-countdown`, `r4-demo-program`.
3. **Compile before you open a pull request.** No errors, and your test still passes.
4. **Open a pull request into `main`.** Role 2 (integration) reviews and merges.
5. **Pull `main` before you start work** each day, so you build on the latest version.

## Rules that prevent the classic breakages

- **The `ENTITY` (port list) of `TIMER_PERIPH.vhd` is frozen.** Changing a port also changes the BDF symbol, so tell Role 2 first.
- **In `TIMER_PERIPH.vhd`, edit only your sections** (marked with comment headers).
- **Spec changes go through the PM** (Role 5), who updates the manual first.
- **Never commit build folders.** If `git status` shows `db/` or `output_files/`, check `.gitignore`.
