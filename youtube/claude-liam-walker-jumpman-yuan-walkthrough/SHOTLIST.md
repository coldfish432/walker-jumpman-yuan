# SHOTLIST.md — claude-liam-walker-jumpman-yuan-walkthrough

| Beat | Act | Visual | Source | Duration target |
|---|---|---|---|---|
| B00 | ASK | `ClaudeComposerAsk` — reconstructed Walker prompt | Remotion | ~20s |
| B01 | BLUF | `BrutalistHesitantWriter` — scope correction | Remotion | ~17s (audio ≥9s per law) |
| B02 | GAMEPLAY | Start menu | `capture/run-01-menu.mp4` (real, 3.07s native) | conformed to narration |
| B03 | GAMEPLAY | Crate-Bot facing + Zone 1/2 jumps | `capture/run-02-movement.mp4` (real, 6.63s native) | conformed to narration |
| B04 | GAMEPLAY | Real keyboard: pause/resume/retry | `capture/run-07-controls.mp4` (real, 4.57s native) | conformed to narration |
| B05 | GAMEPLAY | Genuine spike death + respawn | `capture/run-03-fail-recover.mp4` (real, 1.97s native) | conformed to narration |
| B06 | MECHANISM | `GitHubCodeDiff` — real `git show 2569dc4` diff | Remotion | ~28s |
| B07 | GAMEPLAY | Fixed sign legible + cautious hop | `capture/run-05-zone3-cautious.mp4` (real, 9.9s native) | conformed to narration |
| B08 | GAMEPLAY | Fast route clears spike in one arc | `capture/run-04-zone3-fast.mp4` segment (real) | conformed to narration |
| B09 | GAMEPLAY | Mistimed hop, real death, respawn | `capture/run-06-zone3-mistimed.mp4` (real, 10.07s native) | conformed to narration |
| B10 | GAMEPLAY | Relocated finish, course complete | `capture/run-04-zone3-fast.mp4` segment (real) | conformed to narration |
| B11 | VERDICT | `ClaudeVerdictArtifact` | Remotion | ~28s |
| B12 | HANDOFF | `ClaudeComposerAsk` — "Your turn." | Remotion | ~30s |
| B13 | OUTRO | `ClaudeTitleOutro` (locked, silent under jingle) | Remotion | ~7s |

## Render order

1. Remotion bookends (B00, B01, B06, B11, B12, B13) via `remotion_scenes.py`
   — each writes `media/<BID>.mp4` and is duration-conformed automatically
   to the beat's measured audio length (freeze-hold, never sped up).
2. Gameplay beats (B02–B05, B07–B10) — media pre-conformed by hand from the
   native captures in `capture/` (trim to the real action window, then a
   labeled freeze-hold pad to reach the measured narration length; never a
   speed change on real gameplay, per `capture-and-coverage.md`). Placed
   directly at `media/<BID>.mp4`.
3. `compile.py` (via `./art run` / `./art final`) assembles all 14 beats
   against the Kokoro audio track, which is the master clock.

## Native capture footprint

All 7 gameplay source clips are native `3840x2160 @ 30fps` H.264 (see
`CAPTURE.md`), recorded via Godot's own Movie Maker
(`--write-movie ... --fixed-fps 30`) with the isolated capture copy's window
override raised to 3840x2160 (the logical 640x360 canvas scales up by an
exact 6x integer factor — crisp, not upscaled).
