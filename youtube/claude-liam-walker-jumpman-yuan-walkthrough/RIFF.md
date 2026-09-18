# RIFF.md — walker-jumpman-yuan walkthrough

Per `skills/make/riff/SKILL.md`: artifact + time range | visible observation |
interpretation and its source | narration | suggested next experiment.
Voice: Liam, in for Bear, Kokoro `am_onyx`. All clips are scripted-input
(see `CAPTURE.md`) — labeled as such, not a human playtest claim.

---

## B02 — `capture/run-01-menu.mp4` (0.0s–3.0s)

**Observation:** The start menu renders the "First steps. Real jumps."
modal with the control legend and an Enter/Start button, matching the
starter's own menu layout pixel-for-pixel.

**Interpretation (source):** `README.md` / `SOURCES.md` — the character and
level are extended, but the menu/session state machine (`session.gd`
`State.MENU`) is untouched by this project.

**Narration:** "This is walker-jumpman's First Steps slice… Yuan Jingya's
build keeps every one of those rules exactly as the starter shipped them."

**Next experiment:** Try a controller or a non-QWERTY keyboard layout — the
input map is rebuilt from physical keycodes (`_setup_input()`), which this
reel didn't test.

---

## B03 — `capture/run-02-movement.mp4` (0.0s–6.6s)

**Observation:** Player faces left, then right (visor block visibly moves
from the right half of the sprite to the left half); then four fixed-height
jumps clear the Zone 1 ledge/gap and the Zone 2 gap.

**Interpretation (source):** `CHANGE-BRIEF.md` §1 — the visor-shift is a
kept idea from the starter's own head-highlight square, re-read as
Crate-Bot's directional eye-slit. `TEST-REPORT.md` §2 — collider match
(18×28) confirmed by reading `_draw()` literals against `_ready()`'s
`RectangleShape2D`.

**Narration:** "Same eighteen-by-twenty-eight collider, same jump height,
same acceleration curve as the starter's character."

**Next experiment:** Zoom into the antenna during a jump apex — it overshoots
the collider top by 2–5px (a documented, cosmetic-only departure in
`CHANGE-BRIEF.md` failure case 1). Worth a close-up if a future cut wants to
show that trade-off explicitly.

---

## B04 — `capture/run-07-controls.mp4` (0.0s–4.6s)

**Observation:** Real `Escape` freezes the game on a "Take a breath." card
(position and elapsed-time counter both frozen); real `Enter` resumes; real
`R` snaps the player back to spawn (64,320) without incrementing the death
counter.

**Interpretation (source):** `session.gd` `set_paused()` / `restart_attempt()`
— pause disables `player.enabled`, retry re-seeds position without touching
`deaths`. Same mechanism the shipped `tests/test_keyboard.gd` exercises
(9/9 PASS, `evidence/keyboard-1789682695.119.json`).

**Narration:** "Only a hazard actually killing you increments the death
counter."

**Next experiment:** Chain pause → retry → pause again rapidly; the state
machine (`MENU → PLAYING → PAUSED/DYING → PLAYING`) should have no illegal
transition, but this reel only exercises the documented happy path once.

---

## B05 — `capture/run-03-fail-recover.mp4` (0.0s–1.9s)

**Observation:** Walking into the real Zone-1 spike (an `Area2D` at
x=320) triggers `DYING` immediately; a "Watch the spikes" card appears; after
the fixed 0.55s retry window the player respawns at (64,320) with
`retries: 01` shown on the HUD.

**Interpretation (source):** `TEST-REPORT.md` §4 — twenty consecutive real
deaths were exercised with no more than 34 ticks of extra retry delay each;
this is the same mechanism, shown once.

**Narration:** "A genuine spike overlap — not a scripted death flag."

**Next experiment:** Time a death right at the boundary of the 0.55s retry
window against a rapid manual `R` press — does manual retry cut the wait
short, or does it queue behind the automatic respawn?

---

## B06 — `GitHubCodeDiff` (source-code beat, no gameplay capture)

**Observation (verbatim, `git show 2569dc4 -- godot/game/session.gd`):**
the deleted line drew one hint string at `Vector2(966, 249)`, the same x as
the "03 / STACKED LANDINGS" zone-title at `(966, 227)` — i.e., at the zone
*entrance*. The two added lines draw at `Vector2(1006, 200)` and
`Vector2(1006, 214)` — on the first new ledge itself, above the jump arc's
peak.

**Interpretation (source):** `TEST-REPORT.md` §7 / `FRICTIONAL.md` — this
was found by a real human playtest (Yuan Jingya, `play.bat`), not invented
for the film: "at the time didn't realize this was a choice." Root-caused by
re-reading `session.gd`'s `_draw()`.

**Narration:** "By the time the player needed it, it had scrolled off screen
behind them."

**Next experiment:** none needed here — B07 IS the experiment (showing the
fixed position live).

---

## B07 — `capture/run-05-zone3-cautious.mp4` (6.28s–9.8s)

**Observation:** Player lands on the first new ledge, comes to a complete
stop (velocity 0, `test_axis=0`), and both hint lines are fully drawn and
legible on screen the entire time the character is stationary — this is the
direct payoff of the B06 diff. After a short, deliberate run-up, a single
hop clears the gap and the spike patch, landing stably on the second floor
(confirmed by a 35-tick post-landing hold with `deaths: 0`).

**Interpretation (source):** `tests/experiment_zone3.gd` (a private tuning
script written for this capture, see `CAPTURE.md`) — measured empirically,
under the same `--fixed-fps 30` stepping the movie capture uses, that a
run-up of 3–7 ticks clears the spike and settles stably from this route's
real landing spot (x≈1040.9); 4 ticks was used for a comfortable margin.

**Narration:** "It clears the gap and the spike, lands stable, no drama."

**Next experiment:** Sweep the stop duration (currently 45 ticks) down to
zero — does a *tap*-stop (barely slowing, not fully stopping) still count as
"the cautious route," or does it blend into the fast route's timing?

---

## B08 — `capture/run-04-zone3-fast.mp4` (5.64s–7.9s)

**Observation:** Without ever stopping on the first new ledge, the player
carries momentum through both jumps; the second jump (triggered at x≈1048,
per the shipped `tests/route_driver.gd` jump marks) clears the 60px gap and
the 24px spike patch in one continuous arc, landing past x=1156.

**Interpretation (source):** `TEST-REPORT.md` §3 — this is the exact,
already-validated route (`complete-real-route` check, `deaths: 0`,
`jumps_used: 8`), reused verbatim for this capture (see
`CAPTURE.md`).

**Narration:** "Same tuning, same jump height — just different timing."

**Next experiment:** Measure the actual horizontal distance covered in this
jump against `CHANGE-BRIEF.md`'s hand-calculated ≈107px max-range estimate —
does the real capture confirm or exceed that number?

---

## B09 — `capture/run-06-zone3-mistimed.mp4` (6.72s–10.0s)

**Observation:** Same ledge, same stop — but a 1-tick run-up (measured
below the 3-tick safe minimum for this exact landing spot) produces a jump
that falls short of the second floor; the player dies for real and
respawns at (64,320), `retries: 01`, `deaths: 1`.

**Interpretation (source):** `tests/experiment_zone3.gd` sweep — 0–2 ticks
of run-up reliably falls short; this is the boundary condition the fast/
cautious design decision creates, not a separately invented failure mode.

**Narration:** "Caution only pays off if the second jump is actually
timed."

**Next experiment:** Find the exact minimum run-up tick count (the sweep
found a 2→3-tick cliff edge) and check whether that's forgiving enough for
a first-time human player, or whether it should be widened.

---

## B10 — `capture/run-04-zone3-fast.mp4` (7.9s–8.6s)

**Observation:** The final jump lands on the relocated finish floor; the
"Course complete." modal appears with "8.3 seconds / 0 retries"; the HUD
progress bar reads 100% and the FINISH label sits directly next to the flag
at its new position.

**Interpretation (source):** `TEST-REPORT.md` §5 — the FINISH label position
was rewritten from a literal `Vector2(878,225)` to `finish_x - 38` so it
can't desync from a relocated finish again; the HUD progress-bar denominator
was rewritten from a literal `852` to `level.finish[0] - level.spawn[0]`.

**Narration:** "The validated route completes here in four hundred
ninety-eight ticks with zero deaths."

**Next experiment:** Compare the in-game elapsed-time readout (8.3s) against
the tick count (498 ticks ÷ 60 physics ticks/sec = 8.3s) — confirms the HUD
timer is a real physics-time accumulator, not a display trick.

---

## Missing/failed renders

None. All 7 planned captures rendered successfully at native 3840×2160; no
capture was silently dropped or downgraded to a still.
