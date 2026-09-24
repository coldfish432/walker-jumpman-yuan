# walker-jumpman-yuan

Assignment 1 extension of the **[nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)**
"First Steps" starter (Godot 4.7.2 / GDScript), by Yuan Jingya
(yuan.jingya@northeastern.edu) with Claude Code assistance. See
[SOURCES.md](SOURCES.md) for exactly what's original starter code vs. new,
and [FRICTIONAL.md](FRICTIONAL.md) for the honest build log.

## What this is

The starter's small control/retry platformer slice — two zones, two gaps,
one spike, a finish flag — with:

1. **A new character:** "Crate-Bot", an original geometric redesign
   (flat head, antenna, direction-shifting visor, hazard-stripe belt,
   blocky feet) drawn the same way the starter drew its character —
   `draw_rect`/`draw_colored_polygon` in `_draw()`, no imported art. Same
   collider, same movement tuning.
2. **A new Zone 3, "Stacked Landings":** past the original finish line, two
   new required-jump landings and a relocated finish. The second landing
   carries a spike, and the jump distances are tuned so a full-speed jump
   off the first landing clears the spike in one arc, while a cautious
   player who lands short must stop and take a separate hop over it —
   a real decision, not just a longer floor.

See [CHANGE-BRIEF.md](CHANGE-BRIEF.md) for the predictions made before any
code was touched, and [TEST-REPORT.md](TEST-REPORT.md) for what was
actually checked, including one documented inspect-and-revise cycle.

## Engine / run instructions

**Godot 4.7.2.stable.official.ed1daf0bf**, GL Compatibility renderer, no
.NET dependency.

- **Windows:** double-click [play.bat](play.bat), or run
  `godot --path godot` from this folder (needs `godot` on PATH, or edit
  the `.bat` to point at your Godot executable).
- **macOS:** double-click [walker-jumpman.command](walker-jumpman.command)
  (the starter's original launcher, unchanged).
- **Any platform:** open `godot/project.godot` in the regular Godot 4
  editor and run the main scene.

No export templates, .NET runtime, or paid services are required.

## Controls

Identical to the starter — unchanged by this extension:

- **A/D or arrow keys** — move
- **Space** — jump (fixed height, no double jump)
- **R** — retry the current attempt
- **Escape or P** — pause / resume
- **Enter** — start / resume / replay

Unlimited retries. No lives.

## What changed (summary)

| Area | Changed | Unchanged |
|---|---|---|
| Character | `_draw()` visuals (`godot/features/player/player.gd`) | Collider, `tuning.gd`, all movement/jump code |
| Level | `first_steps.json` width/solids/hazards/finish; `session.gd` drawing literals; `hud.gd` progress calc | Zone 1/Zone 2 geometry, camera clamp logic, state machine, spike/goal collision mechanism |
| Tests | `route_driver.gd` (+3 marks), tick budgets in `test_game.gd`/`capture_game.gd`, new `capture_states.gd` | Original 5 jump marks and all pre-existing assertions |

Full diff-level detail is in each commit message (`git log`) and in
[TEST-REPORT.md](TEST-REPORT.md).

## Known limitations

- The larger three-zone/twenty-cherry design in the starter's own `GDD.md`
  is **not** implemented here — this extension adds one bounded zone, per
  the assignment's scope.
- No audio, settings persistence, moving platforms, or exported build —
  matches the starter's own stated boundary.
- Human playtest results are recorded in `TEST-REPORT.md` §7 (single
  playtester: the author, two passes in one session — the second one
  confirming a sign-legibility fix made in response to the first); no
  second, independent playtester was available for this submission — see
  `FRICTIONAL.md`.
- The character's antenna intentionally overshoots the collider box by a
  few pixels (cosmetic only; documented in `CHANGE-BRIEF.md` failure case
  1 and `TEST-REPORT.md` §2).

## Next improvement

A dash/sprint pickup, placed before a course segment designed around it,
was raised during this build as a follow-up idea. It's deliberately not
implemented here — it would add a new movement ability, which this
assignment's brief requires to keep unchanged unless justified, and doing
it properly needs its own CHANGE-BRIEF predictions and test pass. See
`FRICTIONAL.md`.

## Final film

Rendered with the Brutalist `godot-waikthrough` skill (walker mode):
`claude-liam-walker-jumpman-yuan-walkthrough.mp4` — native 3840x2160, 30fps,
3:59, demonstrates game-source commit `44a8aaa` (gameplay identical to
`2569dc4`; later commits are docs-only).

**SHA-256:** `7b2c08dc9d4fcfff8f2e2114337f2b53c42ac2eca3ac5d38a7a66b2c9d30c882`

**Hosted at:** https://youtu.be/L3vC8UsDq0c (YouTube, unlisted)

The film's beat sheet, riff/shot-list/factcheck/prompt docs, real gameplay
input logs, and QC contact sheet are committed under
[youtube/claude-liam-walker-jumpman-yuan-walkthrough/](youtube/claude-liam-walker-jumpman-yuan-walkthrough/)
(video/audio media itself excluded per `.gitignore`).
