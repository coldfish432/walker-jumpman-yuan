# Inspect-and-revise log: invisible pupil accent

**When:** during the first character-redesign playtest pass, before any human
playtest, right after `capture_states.gd` was written to check CHANGE-BRIEF.md
failure case 1 (silhouette vs. collider, all facings).

## Observation

`player.gd`'s first Crate-Bot `_draw()` drew the visor "pupil" accent in the
same `ink` color (`25354a`) as the chassis border, positioned at the visor's
outer edge — right where it sits flush against that same-colored border.

Rendered evidence: `evidence/screens/state-facing-right.png` and
`state-facing-left.png` (captured by `godot/tests/capture_states.gd`).
Pixel-sampling the visor row (screen y≈594-599) with Pillow gave, left to
right:

- **Facing left:** `ink(x95-103) → cream(x103-113) → panel-green(x113-127) → ink(x127-131)`
  — no separate dark pupil segment resolves; it is indistinguishable from the
  adjacent chassis border.
- **Facing right:** `panel-green(...-135) → ink-border(...) → cream(149-...)`
  — same problem, mirrored.

So the visor itself correctly swaps sides with `facing` (confirming the main
direction cue works), but the pupil detail was invisible in practice, not
just subtle — a real defect, not a cosmetic nitpick.

## Revision

Changed the pupil's color from `ink` to `panel` (`3f8f6d`, the body-panel
green) in `player.gd`, so it reads as a green notch inside the cream visor
regardless of which edge it sits against. Re-ran `capture_states.gd`; the
same pixel scan now shows a clearly separated `cream → green → cream`
(or mirrored) run inside the visor block on both facings. Re-verified with
the full mechanics/keyboard suites (still 25/9 passing — this was a
draw-only change, no physics touched).

## What this did and didn't change

- Did not touch the collider, tuning, or any physics/state-machine code.
- Did not change the antenna's intentional ~5px overshoot above the collider
  box (see CHANGE-BRIEF.md failure case 1) — that overshoot is still present
  and still purely cosmetic (no collision is computed against drawn pixels).
- This is the one documented inspect-and-revise cycle from an observation,
  as required by the assignment; see TEST-REPORT.md for the before/after
  check results.
