# CHANGE-BRIEF — walker-jumpman-yuan

**Author:** Yuan Jingya (yuan.jingya@northeastern.edu) · Assistant: Claude Code (Sonnet 5)
**Written:** 2026-09-17, before any code was touched (godot/features/player/player.gd,
godot/game/session.gd, godot/levels/first_steps.json were read but not edited yet).
**Starter:** [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)
"First Steps" slice, Godot 4.7.2, checked out locally at commit history preserved in
`walker-jumpman-src/` (this project is a fresh copy, not a fork-in-place of the
instructor's repository).

This is the required prediction record. Later corrections are appended under
**Revisions**, not edited into the original predictions.

## 1. Character concept

**"Crate-Bot"** — a small boxy robot instead of the starter's plain
blue-on-dark rectangle person. Visual features meant to make it read as a
distinct character, not a recolor:

- A wider, flatter **head unit** with a single visor **eye-slit** that shifts
  to the front edge depending on facing direction (the starter already does
  this for its head-highlight square; I'm keeping that idea but changing the
  read of the shape).
- A **stubby antenna** on top of the head — the one silhouette element that
  breaks the rectangle-on-rectangle look of the original and is visible in
  every state (idle, walking, jumping).
- **Two-tone panel body** (a dark chassis outline plus a lighter panel
  inset, like the original) but with a **hazard-stripe belt** across the
  midsection instead of the original's plain orange bar, and blocky
  **foot treads** instead of thin leg rectangles.
- Legs keep the original's alternating-stride animation (`sin(tick*0.7)`)
  because that is the only piece of "life" the starter's `_draw()` has, and
  removing it would make the new character feel like a worse regression, not
  an upgrade.

All original geometric `draw_rect`/`draw_colored_polygon` calls — no imported
art, so there is nothing to license or attribute for the character itself.

## 2. Level extension

A new **Zone 3 — "Stacked Landings"** is added past the original finish line,
which moves from x=916 (end of the original 960-wide level) to a new floor
further right in a widened level (see exact numbers in `godot/levels/first_steps.json`
after the edit, and in `TEST-REPORT.md`).

Shape of the addition:
1. A gap past the old zone-3 floor onto a **new narrow elevated ledge**
   (first new required-jump landing) — this is a *precision* jump: higher and
   narrower than anything before it, so overshooting or under-jumping both
   fail.
2. A second gap from that ledge down onto a **second narrow landing that has
   a spike patch on it** (second new required-jump landing) — this is the
   decision point: a player who commits to a fast, full-speed running jump
   can clear the gap *and* the spike patch in one arc, but a player who plays
   it safe and lands short on the ledge first must then line up a second,
   separate short hop over the spike from a standing start. Both routes are
   legal; neither is a hard gate. That is the "clear player decision"
   required by the assignment — not just a longer empty floor.
3. A final gap onto the **relocated finish floor**.

The original Zone 1/Zone 2 route is untouched geometry-wise; a player who
never engages Zone 3 cannot finish (finish is relocated), but everything
before it plays exactly as before.

## 3. What must stay the same (and why)

- **Movement tuning** (`tuning.gd`): speed 160, acceleration 1280,
  deceleration 1920, jump velocity -320, gravity 960, terminal velocity 480,
  6-tick coyote/buffer windows — unchanged. The new jumps are sized to this
  tuning (see math below), not the other way around.
- **Collider**: `RectangleShape2D(18, 28)` at local offset `(0,-14)` —
  unchanged. The new silhouette is drawn to visually match this box from all
  four states (see failure case 1).
- **Collision/hazard model**: triangle `CollisionPolygon2D` spikes, rectangle
  solids/goal — unchanged mechanism; only new instances of the same shapes
  are added for Zone 3.
- **Retry/pause/completion state machine** in `session.gd`
  (`MENU → PLAYING → DYING → PLAYING` / `→ COMPLETE`) — unchanged.
- **Controls** (A/D or arrows, Space, R, Esc/P, Enter) — unchanged.

**Necessary departures**, called out explicitly rather than silently:
- `fall_y` stays a single global threshold (430). Zone 3's elevated ledges
  sit *above* y=320, so a miss over Zone 3 still falls past 430 exactly like
  a miss over the original gaps — no new death rule needed. I will test this
  rather than assume it.
- Several drawing/HUD values in `session.gd` and `hud.gd` are hard-coded to
  the old width (960) and old finish x (916): the background rect width, the
  grid loop bound, the decorative mountain positions, the "FINISH" label
  position, and the HUD progress-bar denominator (`852 = 916-64`). These
  **must** change or the extension will be invisible/wrong even though the
  physics is correct. This is exactly the trap the assignment warns about.

## 4. Predicted failure cases and how I will check them

1. **New character silhouette vs. collider mismatch.** Predicted risk: the
   antenna or wider head could visually stick out past the 18×28 collider,
   making the player *look* like they're overlapping a wall/spike while the
   engine says they aren't (or vice versa). **Check:** render the player
   against a drawn wall edge and a spike triangle at rest, facing both
   directions, and mid-jump; compare the drawn silhouette's extremes against
   the collider rect in `_draw()`/screenshot evidence in `TEST-REPORT.md`.
2. **New jump distances/heights are unreachable or trivial.** Predicted
   risk: I am guessing pixel gap sizes before testing; a mistuned gap could
   be impossible (softlock at 100% retries) or so easy it isn't a real
   challenge. **Check:** compute the theoretical max jump arc from the
   existing tuning (peak rise ≈53px at ~0.33s, ≈107px max horizontal travel
   at full run speed) *before* picking gap widths, then confirm with the
   deterministic route driver (extended with new jump marks) and my own
   manual playtest that the intended route is completable and the "safe"
   sub-route is meaningfully harder, not free.
3. **Hard-coded drawing coordinates silently desync from the new level
   data.** Predicted risk: moving `level.width`/`level.finish` in the JSON
   changes physics and the dynamically-drawn parts of `_draw()`, but the
   background/mountain/label constants in `session.gd` and the HUD's
   progress-bar constant in `hud.gd` are literal numbers, not derived from
   `level`. If left alone, the game would look unfinished or show "FINISH"
   floating in the wrong place well before the actual goal. **Check:** visual
   diff of a full-level screenshot/camera pan before and after, plus reading
   every literal number in both `_draw()` functions against the new JSON.
4. **Extending the level breaks the existing automated route/tick budgets.**
   Predicted risk: `test_game.gd`'s `complete-real-route` check and
   `route_driver.gd`'s fixed `jump_marks` were authored for the 960-wide
   level and a 900-tick cap; a longer level will legitimately need more
   ticks and more marks, and I must not just raise the cap to hide a broken
   route. **Check:** add the new marks explicitly, document the new
   completion tick count observed, and keep the original marks/assertions
   for zones 1–2 unchanged so a regression there still fails the test.

## Revisions

(Additions only — see bottom of file for anything discovered during
build/playtest that contradicts a prediction above.)

- 2026-09-17 (pre-build): initial predictions above, written before editing
  `player.gd`, `session.gd`, or `first_steps.json`.
