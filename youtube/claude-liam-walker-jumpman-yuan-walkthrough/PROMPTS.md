# PROMPTS.md — claude-liam-walker-jumpman-yuan-walkthrough

## B00 — reconstructed ask (illustrative, NOT a historical transcript)

> Please use Walker to convert my game design document about extending
> walker-jumpman's First Steps slice with a new character and a
> new decision-driven level section into a playable Godot project.

This is a reconstruction of the *kind* of ask that produced this project
(see `CHANGE-BRIEF.md`'s actual predictions, written before any code was
touched). It is explicitly labeled as illustrative in B00's own narration —
no fictional live build/progress receipts are shown.

## B12 — handoff prompt (paste-ready for the viewer)

> I added a new zone to my Godot platformer with two required jumps and a
> hazard. Read my draw calls and tell me: is the hint text actually visible
> from the exact position the player stands in when the decision has to be
> made — not just visible somewhere on screen?

This prompt targets the exact defect class this reel demonstrates (B06/B07):
a hint drawn at the wrong world position relative to where the camera and
player actually are when the decision needs to be made. It is read aloud in
full and discussed in B12's narration before the handoff, per HANDOFF LAW.

## Build/render commands actually run for this reel

```bash
# From brutalist.art, with PYTHONUTF8=1 set (Windows GBK-default workaround):
export PYTHONUTF8=1
python3 skills/make/godot-waikthrough/scripts/verify_walkthrough.py \
  "../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough"
python3 runtime/scripts/generate_audio_kokoro.py \
  "../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough"
python3 runtime/scripts/remotion_scenes.py \
  "../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough"
./art final "../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough" \
  --height 2160 --fps 30 \
  --out "../walker-jumpman-yuan/youtube/claude-liam-walker-jumpman-yuan-walkthrough/exports/landscape"
```

## Godot capture commands (isolated copy only — see CAPTURE.md)

```bash
godot --path <isolated-copy> \
  --write-movie capture_out/<clip>.avi --fixed-fps 30 --quit-after 3000 \
  --script res://tests/capture_reel.gd -- <clip-name>
```
