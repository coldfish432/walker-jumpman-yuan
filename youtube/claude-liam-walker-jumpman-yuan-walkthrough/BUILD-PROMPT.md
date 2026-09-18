# BUILD-PROMPT.md

Paste-ready Claude Code prompt that rebuilds this reel end to end from the
already-authored `beat_sheet.json`, `coverage.json`, and `capture/` clips.
Run from `brutalist.art/`.

```
Rebuild the reel at
../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough:

1. export PYTHONUTF8=1 (Windows GBK-default codepage workaround - required
   for every step below).
2. Run `python3 skills/make/godot-waikthrough/scripts/verify_walkthrough.py
   <reel>` and confirm PASS before touching media.
3. Generate Kokoro narration: `python3 runtime/scripts/generate_audio_kokoro.py
   <reel>`. This is the master clock - do not hand-edit any beat's timing
   after this step; if a duration is wrong, fix the narration_text and
   regenerate.
4. For each gameplay beat (B02-B05, B07-B10), conform its real capture in
   capture/ to the beat's measured audio duration: trim to the meaningful
   action window (see coverage.json's start_s/end_s for that beat's
   feature), then pad any shortfall with a labeled freeze-hold on the last
   frame (ffmpeg tpad) - never a speed change on real gameplay. Write the
   result to media/<BID>.mp4.
5. Render the Remotion bookend/mechanism beats (B00, B01, B06, B11, B12,
   B13): `python3 runtime/scripts/remotion_scenes.py <reel>`.
6. Assemble and QC: `./art run <reel> --height 1080` for a fast review cut,
   inspect it, then `./art final <reel> --height 2160 --fps 30 --out
   <reel>/exports/landscape`.
7. Re-run `python3 skills/make/godot-waikthrough/scripts/verify_walkthrough.py
   <reel>` after the final export.
8. Sample frames from the final MP4 with ffmpeg (>=2fps plus each beat at
   15/50/85% of its span), actually look at them, and check: native 4K
   dimensions, the opening/closing sequence, the B06->B07 cause-and-effect
   pair (sign bug -> diff -> fixed behavior on screen), every claimed
   feature in coverage.json, and clean silent-under-jingle outro audio.
   Log defects and fixes.
9. Report: the final MP4's absolute path and SHA-256, a quoted open
   command, feature coverage vs. anything skipped and why, and any
   remaining QC concerns. Do not publish or push.
```

## Constraints this prompt assumes

- `walker-jumpman-yuan/godot/` is never modified. All game-source
  inspection is read-only; capture happens against an isolated copy (see
  `CAPTURE.md`).
- Kokoro/Remotion only - no paid API, no upload, no publish.
- Coverage/checks are structural gates, not truth certification - a human
  (or a careful re-read of `FACTCHECK.md`) still has to confirm the claims.
