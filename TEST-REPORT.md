# TEST-REPORT — walker-jumpman-yuan

**Engine:** Godot 4.7.2.stable.official.ed1daf0bf, GL Compatibility renderer, 60Hz physics.
**OS:** Windows 11.
**Game-source revision under test:** `1314487` (`Extend level with Zone 3 (Stacked
Landings); relocate finish`) — no game code changed after this commit; only
this file, README.md, FRICTIONAL.md, and SOURCES.md were added afterward.
**Baseline (starter, unmodified) revision:** `271c2d6` (`Import walker-jumpman
starter unmodified`).

Repeat the automated checks yourself:

```bash
godot --headless --path godot --script res://tests/test_game.gd
godot --headless --path godot --script res://tests/test_keyboard.gd
godot --path godot --script res://tests/capture_game.gd
godot --path godot --script res://tests/capture_states.gd
```

## 1. Startup and controls

**Evidence:** `evidence/keyboard-1789682695.119.json` (9/9 PASS), `evidence/screens/01-menu.png`.

The main scene launches without script errors. Synthetic keyboard events
(Enter/D/Space/Escape/R/P/M through Godot's real `Input` system, not
position/velocity edits) confirmed: Enter starts, D moves, Space jumps,
Escape pauses, Enter resumes, R retries, Enter after completion replays,
P then M returns to the main menu, and Enter from the menu restarts. All
identical in behavior and assertion to the starter's own `test_keyboard.gd`
— nothing here was loosened.

## 2. Character appearance

**Evidence:** `evidence/screens/state-facing-right.png`, `state-facing-left.png`,
`state-jumping.png`, `state-on-narrow-landing.png` (rendered by the new
`godot/tests/capture_states.gd`), plus close-up crops
`state-facing-{left,right}-zoom.png`.

- **Collider match:** the chassis/panel/feet all draw inside the unchanged
  18x28 collider (local x -9..9, y -28..0). Confirmed by reading the
  `_draw()` rect literals against `_ready()`'s `RectangleShape2D` and by
  the standing screenshots — the feet sit exactly on the floor line the
  collider would occupy.
- **Facing left/right:** the visor block moves from the character's right
  half (facing right) to its left half (facing left); pixel-sampled to
  confirm (see below and `evidence/inspect-revise-pupil.md`).
- **Jumping:** `state-jumping.png` shows the same silhouette mid-arc with
  the leg-stride pose frozen (no separate jump pose was added — same
  scope as the starter, which also has no distinct jump art).
- **One documented departure:** the antenna tip draws at local y -33 to
  -31, about 2-5px above the collider's top edge (-28). This is
  cosmetic-only — `_draw()` output is never consulted for collision, only
  the `CollisionShape2D` is — and is called out in `CHANGE-BRIEF.md`
  failure case 1 rather than silently shipped.
- **No misleading visual/collision mismatch found:** `state-on-narrow-landing.png`
  places the character standing at the very edge (x=1024) of the new
  52px-wide elevated ledge; the drawn feet align with the ledge edge as
  drawn, matching where the solid's collision rectangle actually starts.

**Inspect-and-revise cycle (required by the assignment):** the first pupil
accent (a 3x3 `ink`-colored square at the visor's leading edge) was the
same color as the adjacent chassis border and was pixel-sampled to be
genuinely invisible, not just subtle, on both facings — see
`evidence/inspect-revise-pupil.md` for the exact pixel runs. Fixed by
recoloring the pupil to the panel green; re-verified with a second
pixel sample and the full mechanics/keyboard suites (still 25/25 and 9/9 —
draw-only change).

## 3. Extended route

**Evidence:** `evidence/mechanics-1789682693.842.json`, check `complete-real-route`;
`evidence/screens/03-jump.png` (original gap), `05-zone3-landing.png` (first
new elevated landing), `04-complete.png` (relocated finish).

The deterministic input route (`route_driver.gd`, real `move_and_slide()`
physics, no teleporting/position edits) now includes 3 additional jump
marks (936, 1048, 1168) for the Zone 3 gap-onto-elevated-ledge, the
full-speed jump that clears the second ledge's spike in one arc, and the
final gap onto the relocated finish floor. Observed result:

```json
{"id":"complete-real-route","observed":{"deaths":0,"jump_marks_used":8,
 "position":"(1374.214, 319.9253)","state":4,"ticks":498},"status":"PASS"}
```

Zero deaths, 8 jumps used (5 original + 3 new), 498 ticks (~8.3s) —
completion time roughly proportional to the ~54% longer spawn-to-finish
distance (1312px vs. the starter's 852px) plus the extra jumps, consistent
with the starter's own 325-tick/852px baseline. The original Zone 1/Zone 2
route and its five original jump marks are untouched and still pass, so a
regression there would still fail this same check.

A normal playable route reaches both new landings and the relocated finish
(confirmed by the route above and by direct engine capture in
`05-zone3-landing.png`, taken while the deterministic route was airborne
over the first new landing).

## 4. Failure and recovery

**Evidence:** `evidence/mechanics-1789682693.842.json` checks
`actual-spike-collision`, `duplicate-death-ignored`, `respawn`,
`twenty-retries`, `fall-boundary`; `evidence/screens/02-failure.png`.

A real spike overlap (not a scripted "death" flag) triggers `DYING`,
increments `deaths`, and respawns at the original spawn point after the
unchanged 0.55s retry window — all identical to the starter's own passing
behavior, since none of `session.gd`'s state machine was touched. Twenty
consecutive real deaths were exercised with no more than 34 physics ticks
of retry delay each. `enter-replay` (keyboard suite) confirms replaying
after a completion resets `deaths` and `jumps` to zero
(`replay-idempotent` in the mechanics suite: `deaths:0, jumps:0`).

The new Zone 3 hazard (on the second new ledge) uses the same triangular
`CollisionPolygon2D` hazard mechanism as the original spike — no new death
rule was added; a miss over any Zone 3 gap falls past the same global
`fall_y=430` threshold as the original gaps, confirmed by the route
completing with zero deaths and by manual inspection of the level JSON
(no solids fill the new gaps).

## 5. Camera and presentation

**Evidence:** `evidence/screens/05-zone3-landing.png`, `04-complete.png`.

`camera.position.x` is clamped to `[320, level.width-320]`, which is
computed from `level.width` directly, so the camera bound updated
automatically when `first_steps.json`'s width changed. What required an
explicit fix (not automatic) were the *drawing* literals in `session.gd`
and `hud.gd` that were hardcoded to the old 960-wide level:

- Background rect and grid-line loop bound (previously stopped at x=960 —
  the extension would have rendered against a bare/cut-off backdrop).
- Decorative mountain positions (added a fourth one over Zone 3).
- The "FINISH" label position (was a literal `Vector2(878,225)` tied to
  the old finish at x=916; now `finish_x - 38`, so it can't desync from a
  relocated finish again).
- `hud.gd`'s progress-bar denominator (was a literal `852 = 916-64`; now
  `level.finish[0] - level.spawn[0]`).

`04-complete.png` shows the progress bar at 100% and the "FINISH" label
sitting correctly next to the actual flag at the new location, confirming
these are no longer desynced. The new Zone 3 sign ("03 / STACKED LANDINGS")
and its decision hint are readable in `05-zone3-landing.png`.

## 6. Automated checks — summary

| Suite | File | Result |
|---|---|---|
| Mechanics (25 checks) | `evidence/mechanics-1789682693.842.json` | 25/25 PASS |
| Keyboard (9 checks) | `evidence/keyboard-1789682695.119.json` | 9/9 PASS |
| Visual capture (5 shots + 4 states) | `evidence/screens/*.png` | ran to completion, 0 deaths |
| Build manifest | `evidence/build-manifest.json` | 18 source files hashed, 34 checks, 0 failures |

Starter's own baseline (unmodified, for comparison): `evidence/mechanics-1789078494.18347.json`
(25/25) and `evidence/keyboard-1789078680.84209.json` (9/9), committed in
`271c2d6`.

**What changed in the fixture and why:** `route_driver.gd` gained 3 jump
marks (936/1048/1168) for the new gaps; `test_game.gd`'s and
`capture_game.gd`'s route tick caps were raised from 900 to 1500 to fit the
longer route (measured completion is 498 ticks — the cap still fails a
route that doesn't finish, it isn't a rubber-stamp). No existing assertion
was deleted or weakened; the original 5 jump marks and all pre-existing
checks are unchanged and still pass.

## 7. Human playtest

**Playtester:** Yuan Jingya (the author), single session, 2026-09-17, played
the real build via `play.bat` — normal keyboard input, not scripted.

| Check | Result |
|---|---|
| Startup, movement, jump, pause/resume, retry | Works, "feels fine, no issues." Character reads clearly while moving/jumping. |
| Reached the relocated finish through the new section | Yes. |
| Zone 3 decision (fast-jump-clears-spike vs. land-then-hop) legible **before** committing | **No** — reached the finish but "at the time didn't realize this was a choice" (player's own words, translated). |
| Deliberate failure + retry in Zone 3 | Not yet tested by the human playtester (only the success path was played this session); covered by automated evidence in §4 in the meantime. |

**This is the required inspect-and-revise finding**, not a passing box to
check: the risk flagged in `FRICTIONAL.md` before playtesting
("untested whether the choice is *felt* in the moment, or only visible in
hindsight") turned out to be real. Root cause found by re-reading
`session.gd`'s `_draw()`: the only sign explaining the decision was posted
at x=1006, y=227/249 **before the fix below**, but positioned as part of
the zone-entrance title block at the *takeoff* for the first gap (around
x=966) — by the time the player is actually standing on the first new
ledge deciding how to take the second jump, that text has already
scrolled off screen behind them.

**Revision:** moved the decision-specific text
("Jump now: fast clears the spike ahead." / "Land first, then hop, to play
it safe.") to draw directly above the first new ledge itself (world
position ~x1006, y200/214 — above the jump arc's peak height so it's never
obscured by the character), separate from the "03 / STACKED LANDINGS"
zone-entrance title, which stays where it was. Re-verified: mechanics
suite still 25/25 (`complete-real-route` unaffected — this is a draw-only
change), and `evidence/screens/05-zone3-landing.png` was re-captured
showing both lines clearly positioned above the character while it stands
on the ledge, before the second jump.

**Second human pass (same session, same playtester, after the fix):**
replayed via `play.bat`. Confirmed the two-line hint is now visible above
the first new ledge before committing to the second jump, and that the
choice reads clearly beforehand ("现在能提前看到并看懂了" — "can now see it
in advance and understand it"). Also deliberately failed in Zone 3 (ran
into the new spike / fell into a gap) and confirmed the death prompt,
retry wait, and respawn all behave exactly like the original zones
("正常，和原区域一致" — "normal, consistent with the original zones").

**Still open:** only one playtester (the author) has played this build;
a second, different playtester was not available for this submission
window (see `FRICTIONAL.md`).
