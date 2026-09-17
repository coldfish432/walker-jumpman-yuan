# SOURCES.md — walker-jumpman-yuan

## Starter code

**[nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)**,
"First Steps" slice, Godot 4.7.2/GDScript. Used under the course's
authorization to extend it for this assignment. Unmodified import is
preserved as git commit `271c2d6`; every subsequent commit's message states
exactly what it changed relative to that baseline. `BUILD-REPORT.md`,
`GDD.md`, `GAME-BRIEF.md`, `LEVEL-DESIGN.md`, `PRODUCTION-PLAN.md`,
`PLAYTEST-PLAN.md`, `ASSET-PLAN.md`, `DESIGN-REVIEW.md`,
`DESIGN-STATUS.json`, and `design/` are the starter's own documents, kept
for provenance; they describe the starter's proposed full three-zone/
twenty-cherry design, most of which is out of scope for this assignment.

## Character art

**Original.** The "Crate-Bot" redesign in
[godot/features/player/player.gd](godot/features/player/player.gd)'s
`_draw()` is hand-written `draw_rect`/`draw_colored_polygon` calls, exactly
like the starter's own player art it replaces. No imported images, sprite
sheets, or third-party asset packs were used for the character. No
attribution or license is required because nothing was imported.

## Level art and geometry

Zone 1/2 geometry, the background grid/mountain decoration style, and the
floor/spike/finish drawing style are the starter's own original vector
drawing in [godot/game/session.gd](godot/game/session.gd), unmodified for
those zones. Zone 3's geometry (`godot/levels/first_steps.json`) and its
added decoration/label draw calls are original, authored for this
assignment, in the same style and using the same color palette as the
starter (see `session.gd`/`hud.gd` `Color(...)` literals — no new colors
were introduced for Zone 3's terrain; the character redesign added two new
literals, `3f8f6d` panel-green and reused `ef875f`/`fff9e9`/`25354a` from
the starter's own palette).

## Fonts

`ThemeDB.fallback_font` — Godot's built-in default font, used by the
starter for all UI/label text and unchanged here.

## Tools

- **Godot 4.7.2.stable.official.ed1daf0bf** — game engine, GL Compatibility renderer.
- **Claude Code (Sonnet 5)** — implementation assistance; see FRICTIONAL.md
  for what was accepted, modified, or rejected.
- **Brutalist (`brutalist.art`)** `godot-waikthrough` skill, walker mode —
  film production (Kokoro local TTS, Remotion/ffmpeg rendering). No paid
  API credits or asset-generation service were used; the Fellow Tier of
  Brutalist runs entirely for free (local Kokoro TTS, Manim, Remotion).
- **Pillow (Python)** — used only to pixel-sample rendered PNG evidence
  during the inspect-and-revise cycle (`evidence/inspect-revise-pupil.md`);
  not used to generate or edit any shipped game asset.

## Film assets

Recorded gameplay and voice narration for the required explainer are
original to this project (real engine capture + locally-generated Kokoro
TTS via Brutalist's free Fellow Tier). Any stock outro/jingle assets used
by the Brutalist toolkit's regular outro are Brutalist's own bundled
assets (`svg/claude/mp3/`), not sourced or licensed separately for this
project; see the film's own `FACTCHECK.md`/`PROMPTS.md` for exact beat-by-
beat provenance once produced.
