# CAPTURE.md — how the gameplay evidence in this reel was made

## Game revision under demonstration

Commit `44a8aaa8cf6446ef9208ebe9efaa9c5db101dc0c` (docs-only on top of
`2569dc4`, so gameplay is byte-for-byte identical to `2569dc4` — the commit
that fixed the Zone 3 sign-legibility defect found in human playtest).
`git log --oneline` in `walker-jumpman-yuan/` shows the full history.

**No file under `walker-jumpman-yuan/godot/` was modified to produce this
film.** All captures were recorded from an **isolated copy** of the `godot/`
folder (per `skills/make/godot-waikthrough/references/capture-and-coverage.md`,
"work on an isolated copy for harness/config changes; preserve the original
game's code, assets, saves, and currently open instance"), made with a plain
recursive file copy, at
`D:\CodexData\Temp\claude\...\scratchpad\wj-capture\godot`. The only changes
in that isolated copy relative to the shipped game:

1. Two added test-only scripts, `tests/capture_reel.gd` and
   `tests/experiment_zone3.gd` — capture choreography and a private timing
   experiment, not shipped game code.
2. `project.godot`'s `window/size/window_width_override` /
   `window_height_override` raised from `1280x720` to `3840x2160` so
   Godot's own window (and therefore `--write-movie`'s output) renders at
   native 4K instead of 720p. The logical game canvas stays `640x360`
   (`window/stretch/mode="canvas_items"`, `aspect="keep"`) — 3840x2160 is an
   exact 6x integer multiple, so the capture is crisp, not upscaled.

## Build identity (`build_id`)

`build_id` in `coverage.json` is a SHA-256 over every file under the real
`walker-jumpman-yuan/godot/` (the unmodified game, not the capture copy),
computed as: for each file (POSIX relative path, sorted), take
`sha256(file bytes)`, join as `"<path>:<hex>"` lines with `\n`, and SHA-256
the resulting UTF-8 blob. 17 files were hashed.

```
build_id = bf7faeebe970529c7cbceb0169527d2beb2af4815ab5ab0b2bcaa3f72f914334
```

## Engine and capture command

Godot `4.7.2.stable.official.ed1daf0bf`, GL Compatibility renderer (same as
`TEST-REPORT.md`), Windows 11, NVIDIA GeForce RTX 4060 Laptop GPU.

```bash
godot --path <isolated-copy> \
  --write-movie capture_out/<clip>.avi --fixed-fps 30 --quit-after 3000 \
  --script res://tests/capture_reel.gd -- <clip-name>
```

Each `<clip>.avi` (Godot's own Movie Maker output, native `3840x2160 @ 30
FPS`, confirmed by `ffprobe`) was transcoded losslessly-for-purpose to H.264
(`ffmpeg -c:v libx264 -pix_fmt yuv420p -crf 18`) for the mp4s in this folder;
no resolution or frame-rate change, no re-cut, in that transcode.

## Method: scripted-input, not a human playtest

`tests/capture_reel.gd` drives the real main scene (`game/session.gd`) the
same way the game's own shipped `tests/route_driver.gd` and
`tests/capture_game.gd`/`capture_states.gd` do: via
`player.test_control` / `test_axis` / `test_jump_pressed` (observed against
real `position` / `is_on_floor()` / `state`), or, for `run-07-controls`, via
real `InputEventKey` through `Input.parse_input_event()` — the exact
technique the shipped `tests/test_keyboard.gd` uses. **No teleporting, no
disabled collisions, no direct state/completion writes, no test-only
gameplay shortcuts.** Every input decision is logged to a per-clip
`capture/<clip>-inputs.jsonl` alongside the video.

**All captures in this reel are scripted-input, not a human playtest.**
The human playtest referenced in the narration (the Zone 3 sign-legibility
defect and its fix) is the one already recorded in `TEST-REPORT.md` §7 and
`FRICTIONAL.md` by Yuan Jingya, on 2026-09-17, via `play.bat` — this film
does not re-stage that session; it shows the *current, fixed* build's
on-screen behavior and the real source diff that produced it.

## Timing tuning note (`run-05`/`run-06`)

The "cautious" second-jump run-up tick count was measured empirically, not
guessed: `tests/experiment_zone3.gd` sweeps a run-up-tick parameter with the
player seeded at the route's actual observed first-landing position and
reports whether the resulting hop clears the spike and settles stably. A
real discrepancy was found and corrected during this process: the same
run-up tick count behaves differently under plain `--headless` stepping than
under `--fixed-fps 30` (the mode `--write-movie` forces), because fixed-fps
changes how many physics ticks elapse per script-observed step. The shipped
`run-05`/`run-06` clips were tuned and captured under `--fixed-fps 30` to
match the real recording conditions, not the faster preliminary sweep.

## Clips in this folder

| Clip | Real duration | What it shows | Method |
|---|---|---|---|
| `run-01-menu.mp4` | 3.07s | Start menu, "First steps. Real jumps." | scripted-input |
| `run-02-movement.mp4` | 6.63s | Facing left/right, Zone 1 + Zone 2 jumps (unchanged from starter) | scripted-input |
| `run-03-fail-recover.mp4` | 1.97s | Real spike overlap -> death -> respawn | scripted-input |
| `run-04-zone3-fast.mp4` | 9.90s | Full-speed route, all 8 validated jump marks, 0 deaths, reaches relocated finish | scripted-input |
| `run-05-zone3-cautious.mp4` | 9.90s | Lands on first new ledge, full stop (sign fully legible), deliberate hop clears spike | scripted-input |
| `run-06-zone3-mistimed.mp4` | 10.07s | Same stop, but an under-timed hop -> real death -> respawn | scripted-input |
| `run-07-controls.mp4` | 4.57s | Real keyboard: Enter/D/Escape/Enter/R (start, move, pause, resume, retry) | scripted-input (real `InputEventKey`) |

Each `<clip>-inputs.jsonl` is the input log required by the `coverage.json`
contract (nonempty, tick-stamped).
