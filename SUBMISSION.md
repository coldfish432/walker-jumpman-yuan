# SUBMISSION.md

**Assignment:** Assignment 1 - Extend Walker Jumpman
**Student:** Yuan Jingya (yuan.jingya@northeastern.edu)
**Project name:** walker-jumpman-yuan
**GitHub repository/folder URL:** https://github.com/coldfish432/walker-jumpman-yuan
**Submitted commit SHA:** *see the Canvas submission note (not embedded here, per the assignment's own instruction not to self-reference a commit's SHA inside that commit)*
**Game-source revision shown in the film:** `44a8aaa` ("Record second human playtest pass: sign fix confirmed, failure/retry OK"). Gameplay is identical to `2569dc4` (the last commit that touched anything under `godot/`); `44a8aaa` and everything after it are documentation/film-only.
**Godot version and operating system:** Godot 4.7.2.stable.official.ed1daf0bf, GL Compatibility renderer; Windows 11.
**Final film URL and filename:** https://youtu.be/L3vC8UsDq0c (YouTube, unlisted) — filename `claude-liam-walker-jumpman-yuan-walkthrough.mp4` (3840x2160, 30fps, 3:59).
**Final film SHA-256:** `7b2c08dc9d4fcfff8f2e2114337f2b53c42ac2eca3ac5d38a7a66b2c9d30c882`

## Summary of my changes

Starter: [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman) "First Steps" slice.

1. **Character:** replaced the player's `_draw()` with an original geometric
   redesign, "Crate-Bot" — flat head, antenna, a visor that shifts sides
   with facing direction, a hazard-stripe belt, and blocky foot treads.
   Collider (`RectangleShape2D` 18x28) and all movement/jump tuning are
   unchanged.
2. **Level:** added Zone 3 ("Stacked Landings") past the original finish —
   two new required-jump landings, the second carrying a spike hazard
   sized so a full-speed jump clears it in one arc while a cautious,
   land-then-hop approach also works. Finish relocated from x=916 to
   x=1376, so completing the extension is required to win. Zones 1-2 are
   untouched. Fixed several hardcoded drawing/HUD literals (background
   width, mountain positions, FINISH label position, HUD progress
   denominator) that would have desynced from the wider level.
3. **Testing:** 25/25 mechanics checks, 9/9 keyboard checks, and an
   extended deterministic route completing in 498 ticks with 0 deaths —
   all against the real Godot 4.7.2 engine, not mocked. Two real human
   playtest passes (by me) — the first surfaced a genuine defect (the
   Zone 3 decision sign was posted before the actual decision point and
   wasn't legible in time), which was fixed and re-verified in the second
   pass. A separate inspect-and-revise cycle (pixel-sampling rendered
   screenshots) found and fixed an invisible visor-pupil accent.
4. **Film:** produced with Brutalist's `godot-waikthrough` skill, walker
   mode — real engine gameplay captures (menu, movement, a genuine
   failure+recovery, both Zone 3 approaches, a mistimed jump, completion),
   the actual `session.gd` diff for the sign fix as a cause-and-effect
   beat, and an honest Verdict/Your Turn.

Full detail: [CHANGE-BRIEF.md](CHANGE-BRIEF.md) (predictions),
[TEST-REPORT.md](TEST-REPORT.md) (evidence), [FRICTIONAL.md](FRICTIONAL.md)
(honest build log), [SOURCES.md](SOURCES.md) (provenance), `git log`
(commit-by-commit history).

## Known limitations

- Only one playtester (the author); no second, independent playtester was
  available for this submission window.
- A dash/sprint pickup was requested mid-session as a stretch idea;
  deliberately deferred rather than built, since it would change movement
  tuning the assignment requires to keep fixed unless justified. Tracked
  as a follow-up, not part of this submission.
- The character's antenna cosmetically overshoots the collider box by a
  few pixels (documented, not a collision bug).
- No audio, settings persistence, moving platforms, or exported build —
  matches the starter's own stated boundary; only the specified extension
  was built.
