# FACTCHECK.md — claude-liam-walker-jumpman-yuan-walkthrough

Every factual claim in the narration is checked against the project's own
source files or evidence, not invented for the film. DOUBLE-CHECK LAW:
claims are rewritten in the reel's register, never parroted verbatim from
the docs (except the one verbatim quoted diff in B06, cited).

| Claim (beat) | Source | Verified |
|---|---|---|
| "cross two gaps, clear a spike patch, reach the flag... one jump, no double jump, unlimited retries" (B02) | `README.md` "Controls"; `godot/game/session.gd` (`jump` handling, no re-jump before `is_on_floor`) | Yes |
| "same eighteen-by-twenty-eight collider... same acceleration curve" (B03) | `godot/features/player/player.gd` `_ready()` (`RectangleShape2D(18,28)`) vs `CHANGE-BRIEF.md` §3 ("Movement tuning... unchanged") | Yes |
| Visor shifts side with facing (B03) | `godot/features/player/player.gd` `_draw()`: `visor_x = 0.0 if facing > 0 else -8.0` | Yes |
| Real Escape/Enter/R pause/resume/retry, unchanged (B04) | `godot/game/session.gd` `_unhandled_input`, `set_paused`, `restart_attempt`; `evidence/keyboard-1789682695.119.json` 9/9 PASS | Yes |
| "twenty consecutive deaths... no more than thirty-four extra ticks" (B05) | `TEST-REPORT.md` §4, `twenty-retries` check in `evidence/mechanics-1789682693.842.json` | Yes |
| Sign originally at zone entrance (x=966), moved to ledge (x=1006) (B06) | `git show 2569dc4 -- godot/game/session.gd` (verbatim diff, quoted in beat props) | Yes — verbatim |
| "found in human playtest... didn't realize this was a choice" (B06) | `TEST-REPORT.md` §7 (direct quote: "at the time didn't realize this was a choice"); `FRICTIONAL.md` | Yes |
| Fixed sign fully legible while stopped on the ledge (B07) | Real capture `run-05-zone3-cautious.mp4`, frame-inspected at t≈6.5s (see QC notes) | Yes — visually confirmed |
| Fast route clears gap+spike in one arc using validated jump marks (B08) | `TEST-REPORT.md` §3 (`complete-real-route`, `jump_marks_used: 8`, `deaths: 0`); `godot/tests/route_driver.gd` | Yes |
| Mistimed hop dies for real (B09) | `tests/experiment_zone3.gd` sweep (this reel's own tuning experiment, logged in `CAPTURE.md`); real capture `run-06-zone3-mistimed.mp4` shows `deaths: 1` | Yes |
| Finish moved from x=916 to x=1376 (B10) | `godot/levels/first_steps.json` (`"finish": [1376, ...]`); `CHANGE-BRIEF.md` §2 states the old finish was at x=916 (end of the original 960-wide level) | Yes |
| FINISH label / HUD progress bar rewritten to derive from `level.finish` (B10) | `TEST-REPORT.md` §5 | Yes |
| "four hundred ninety-eight ticks with zero deaths" (B10) | `TEST-REPORT.md` §3 (`"ticks":498`, `"deaths":0`) — the same validated route this reel's `run-04-zone3-fast.mp4` replays | Yes |
| "twenty-five of twenty-five mechanics checks, nine of nine keyboard checks" (B11) | `TEST-REPORT.md` §6 summary table | Yes |
| Invisible visor pupil found and fixed (B11) | `TEST-REPORT.md` §2 "Inspect-and-revise cycle"; `evidence/inspect-revise-pupil.md` | Yes |
| "only one playtester... a dash pickup was scoped out" (B11) | `TEST-REPORT.md` §7 "Still open"; `FRICTIONAL.md` "Still open (unresolved)"; `README.md` "Next improvement" | Yes |

## Claims explicitly NOT made

- No claim that this film's captures are a human playtest — every capture
  is labeled scripted-input in `CAPTURE.md`, `coverage.json`, and the
  narration ("real physics, a real death" — not "I played this").
- No claim that B00's prompt is a historical transcript — labeled
  "reconstructed, not a transcript" in its own narration.
- No dash-pickup demo — explicitly out of scope, marked `"planned"` with a
  reason in `coverage.json`, mentioned only as a deferred idea in B11.
- No invented sound effects, chiptune, or victory jingle — the game is
  silent (no audio system implemented) and the outro card uses only the
  existing slug-seeded stock jingle per `OUTRO-LOCK.md`.

## Corrections applied during scripting (DOUBLE-CHECK LAW)

- Draft B10 narration originally said "the finish moved further right";
  rewritten to the exact figures (916 → 1376, 460px) once the real
  `first_steps.json` values were confirmed, rather than leaving it vague.
- Draft B01 hesitant-writer text first tried the trigger word "rebuilt"
  alone; corrected to the full phrase "rebuilt this game from scratch" so
  the corrected sentence ("extended one existing slice") reads as a
  complete, accurate claim on its own, per the "correct the sentence, not
  just the word" rule in `ai-explainer/SKILL.md`.
