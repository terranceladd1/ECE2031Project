# SCOMP Timer Peripheral (ECE 2031 Project)

A time-based I/O peripheral for SCOMP: an independent countdown with a done flag and a drift-free periodic tick, at I/O addresses 0x020–0x023.

- **Programmer's Reference Manual:** https://docs.google.com/document/d/1wXg2tX60ipIZ6WCXmOE4ErOo9tXZ6VG4BwRyAMGlQ2M/edit
- **Roadmap:** spec freeze Nov 10 · integration Nov 18 · first board test Nov 20 · feature freeze Nov 23 

## What's in this repo

The Quartus project lives in `SCOMP_Lab8_Fall25/`. Keep all project files inside that folder and don't move them into subfolders: the `.qsf` and `SCOMP.vhd` (memory init) refer to them by path.

| File(s) in `SCOMP_Lab8_Fall25/` | What it is | Owner |
|---|---|---|
| `TIMER_PERIPH.vhd` (to be added) | The new peripheral | Role 1 (logic), Role 2 (ports, decode, bus) |
| `SCOMP_System.bdf` | Top-level schematic | Role 2 |
| `SCOMP.vhd` | The processor (unchanged except the `.mif` name) | Role 2 |
| `*.vwf` | Simulation tests | Role 3 |
| `*.asm`, `*.mif` | SCOMP test and demo programs, and their assembled output | Role 4 |
| `*.qpf`, `*.qsf`, `PLL_main*` | Quartus project settings and the PLL | Role 2 |
| `TIMER.vhd`, `DIG_IN.vhd`, `DIG_OUT.vhd`, `HEX_DISP*`, `clk_div.vhd` | Lab 8 peripherals (reference, leave as is) | Nobody |

Build output (`db/`, `output_files/`, `*.sof`, reports) is ignored. Compile locally to get a `.sof`.

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
