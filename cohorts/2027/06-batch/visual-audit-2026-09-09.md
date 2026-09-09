# Batch module visual audit — 2026-09-09

## Final status

The module was checked against all 16 workshop recordings listed in the
source audit. The first pass found 41 live image references:

- 14 source-backed conceptual redraws are retained as imagegen assets.
- 26 exact screenshot/UI/code/runtime captures were replaced with native
  lesson content (Markdown, code, tables, or text trees).
- 1 warning-heavy Spark UI capture was removed rather than preserved as an
  illustration.

After the cleanup, the lessons contain 14 live image references and no live
`*-crisp.png` screenshot references. The exact captures removed from lessons
11–15 were deleted in commit `81213ef`; their source frames, crops, and audit
records remain in the scratch evidence area and in the tracked follow-up
provenance document.

## Quality gate

Every retained image passed an independent review of the source frame, the
focused crop, the generated output, and the lesson placement. The retained
assets are conceptual redraws, not enlarged screenshots. The workflow was:

1. verify the workshop recording and timestamp;
2. preserve the original source frame;
3. make a focused crop that removes the presenter, webcam, browser/editor
   chrome, and transient overlays;
4. send both the original frame and focused crop to imagegen when a
   conceptual visual is appropriate;
5. compare the generated diagram against the source and lesson text for
   relationships, labels, arrows, and unsupported additions;
6. inspect the result at lesson width and run an independent review before
   publication.

Exact code, tables, runtime output, volatile dashboards, and environment-
specific UI were represented natively or removed. They were not redrawn as
illustrations because exact content is more useful and maintainable as text,
code, a table, or a deterministic diagram.

## Evidence and follow-up

- Initial complete review: `INDEPENDENT-REVIEW.md` in the processing evidence
  area.
- Lesson 02 recrop/regeneration review: `FOLLOW-UP-INDEPENDENT-REVIEW.md` in
  the processing evidence area.
- Lesson 03–06 native cleanup: `CLEANUP-03-06.md` in the processing evidence
  area.
- Lesson 07–10 native cleanup: `CLEANUP-07-10.md` in the processing evidence
  area.
- Lesson 11–15 native cleanup: `CLEANUP-11-15.md` in the processing evidence
  area.
- Source/crop/output hashes and generation notes: `2026-09-09-follow-up-provenance.md`.

The processing evidence is intentionally kept outside the course tree; the
tracked provenance file records the published asset hashes and the final
decisions needed to reproduce the audit.
