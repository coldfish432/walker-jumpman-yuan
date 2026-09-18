# SOURCES.md — claude-liam-walker-jumpman-yuan-walkthrough

## Game project (subject of this film)

- `walker-jumpman-yuan/` — local student project, Yuan Jingya
  (yuan.jingya@northeastern.edu) with Claude Code (Sonnet 5), extending
  [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)
  "First Steps" slice. Not yet pushed to a remote (see `FRICTIONAL.md`
  "Setup decisions").
- Revision demonstrated: `44a8aaa8cf6446ef9208ebe9efaa9c5db101dc0c`
  (docs-only on top of `2569dc4`; gameplay identical to `2569dc4`).
- `CHANGE-BRIEF.md`, `TEST-REPORT.md`, `FRICTIONAL.md`, `README.md`,
  `SOURCES.md` (the game's own), `evidence/*` — read in full before
  authoring this reel's beat sheet.
- `git show 2569dc4 -- godot/game/session.gd` — the verbatim diff quoted in
  beat B06.

## Toolkit

- `brutalist.art` — Brutalist video-explainer toolkit. Skills read in full:
  `skills/make/godot-waikthrough/SKILL.md`,
  `skills/make/godot-waikthrough/references/capture-and-coverage.md`,
  `skills/make/riff/SKILL.md`, `skills/make/ai-explainer/SKILL.md`,
  `RENDER-TARGETS.md`, `docs/PIPELINE-SAFETY.md`, `OUTRO-LOCK.md`.

## Rendering / voice

- Kokoro TTS, voice `am_onyx` (Liam, in for Bear) — local, free, no
  account or paid API used.
- Remotion scenes: `ClaudeComposerAsk`, `BrutalistHesitantWriter`,
  `GitHubCodeDiff`, `ClaudeVerdictArtifact`, `ClaudeTitleOutro` — all
  pre-existing, registered components (`runtime/remotion/src/scenes.json`),
  found via `./art scenes` / `scene_search.py` before authoring (GATE L),
  not newly built for this reel.

## Environment notes (this machine)

- `python3` shim at `~/bin/python3` forwarding to
  `D:\CSYE 7370\.venv\Scripts\python.exe`.
- `PYTHONUTF8=1` set for every Python invocation (Windows GBK-default
  codepage otherwise crashes on smart quotes/em-dashes in JSON).
- Godot `4.7.2.stable.official.ed1daf0bf` at
  `D:\CSYE 7370\Godot_v4.7.2-stable_win64.exe`.
