# FRICTIONAL.md — honest build log

Author of this log: Claude Code (Sonnet 5), organizing the actual session
transcript at Yuan Jingya's request; entries describe what was actually
tried and observed, not manufactured struggle. Human/AI contributions are
called out explicitly in each entry.

## Setup decisions (human)

Yuan chose the project slug (`walker-jumpman-yuan`), decided to defer the
GitHub remote/push until the local work is reviewed rather than have
Claude create a repo without credentials in this environment, and chose to
have Claude propose the character concept rather than specifying one.
These were asked directly rather than assumed, since they're
irreversible/public-facing decisions (naming, hosting) or a creative
choice Yuan wanted to delegate on purpose.

## Reading before writing (AI)

Before any edit, Claude read `player.gd`, `tuning.gd`, `session.gd`,
`first_steps.json`, `hud.gd`, and all four test/driver scripts in full,
specifically to find every hardcoded literal that assumes the old
960-wide level (background width, grid range, decorative mountain x
positions, the "FINISH" label position, and the HUD progress-bar
denominator `852 = 916-64`). This produced CHANGE-BRIEF.md failure case 3
*before* the level was extended, not as a post-hoc discovery — all of
those literals were in fact the exact set that needed changing, confirmed
against the diff in commit `1314487`.

## Jump geometry: worked on the first engine run (AI, unresolved risk noted honestly)

CHANGE-BRIEF.md failure case 2 flagged that new gap/ledge sizes were
picked by hand calculation (from the existing tuning's fixed ~0.667s
flight time and ~107px max horizontal travel at full run speed) before
ever running the engine, and that this could produce an unreachable or
trivial jump. In practice, the first headless run of the extended
`test_game.gd` (`evidence/mechanics-1789682462.543.json`) passed
`complete-real-route` with zero deaths and all 8 jump marks on the first
attempt — no iteration on the geometry was needed. This is reported
honestly as "worked immediately, checked by running the real physics
engine" rather than dressed up as a struggle; the check that would have
caught a miss (the deterministic route through real `move_and_slide()`
physics, not just the hand math) is the same one that confirmed success.

## Invisible pupil accent (AI found it, AI fixed it, re-verified)

While producing the CHANGE-BRIEF failure-case-1 evidence
(`godot/tests/capture_states.gd`), Claude wrote a small Pillow
pixel-sampling script (not part of the shipped test suite) to check the
rendered PNGs row-by-row rather than eyeballing a 640x360 screenshot. That
sampling showed the visor's "pupil" accent (drawn in the same `ink` color
as the adjacent chassis border) was genuinely indistinguishable from the
border on both facings — a real defect the naked-eye screenshot review
had missed. See `evidence/inspect-revise-pupil.md` for the exact pixel
runs before and after. Fixed by recoloring the pupil to the body-panel
green; re-verified with a second pixel sample and the full 25/9 automated
suites (still passing — draw-only change, no physics touched). This is
the one required inspect-and-revise cycle, and it addressed a real
clarity defect (an accent detail that had zero visible effect), not a
crash.

## Human playtest confirmed a real design gap (human found it, AI fixed it)

Yuan played the actual build (`play.bat`, normal keyboard input) and
reported: reached the relocated finish, but "at the time didn't realize
this was a choice" regarding the Zone 3 fast-jump-vs-land-then-hop
decision. This is exactly the risk flagged as untested earlier in this
log — it turned out to be real, not hypothetical.

Root cause (Claude, by re-reading `session.gd`'s `_draw()`): the only
sign explaining the decision was drawn at the zone-entrance title
position (around the takeoff for the *first* gap), not at the actual
decision point (the first new ledge, where the player is about to choose
how to take the *second* jump). By the time a player is standing on that
ledge, the sign has scrolled off screen behind them.

Fix (Claude): moved the decision-specific two-line hint to draw directly
above the first new ledge, above the jump arc's peak height so the
character sprite never covers it, leaving the zone title where it was.
Re-verified the mechanics suite (still 25/25 — draw-only change) and
re-captured `evidence/screens/05-zone3-landing.png`. See `TEST-REPORT.md`
§7 for the full before/after.

**Still open (unresolved):**

- Whether the repositioned sign actually makes the choice legible *in the
  moment* to a first-time player is itself untested until re-played by a
  human — not assumed fixed just because the reasoning sounds right.
- The human playtester has only played the success path once; deliberate
  failure/retry in Zone 3 has not yet been human-tested (automated
  evidence covers the mechanism in `TEST-REPORT.md` §4, but not the human
  "does retry still feel fine here" judgment).
- No second playtester was available for this submission window.

## Traceability

| Entry | Commit(s) | Evidence |
|---|---|---|
| Baseline import | `271c2d6` | `evidence/mechanics-1789078494.18347.json` (starter's own) |
| Predictions | `be0c37c` | `CHANGE-BRIEF.md` |
| Character redesign | `1e60035` | `evidence/screens/state-*.png` |
| Level extension | `1314487` | `evidence/mechanics-1789682462.543.json` |
| Pupil fix (inspect-and-revise) | `f120b31` | `evidence/inspect-revise-pupil.md`, `evidence/mechanics-1789682693.842.json` |

## Human/AI contribution summary

**Yuan (human):** scope/authorization decisions above; is the one required
human playtester (pending, to be appended to `TEST-REPORT.md` §7); reviews
and is responsible for every change described in this file and in the git
history, per the assignment's terms.

**Claude (AI):** read the starter source before editing; wrote
`CHANGE-BRIEF.md`; implemented the character redraw, level extension, and
all consequent drawing/HUD/test-fixture updates; ran and evidence-captured
all automated/mechanical checks; found and fixed the pupil-visibility
defect; wrote this log, `TEST-REPORT.md`, `SOURCES.md`, and `README.md`.
