# Workshop illustration audit — Docker and Terraform

Audit date: 2026-09-09

The three illustrations in this module were derived from the 2027 Docker and
Terraform workshop videos. Raw screenshots were not published: they contain
editor/browser chrome, transient UI, or exact commands and values that belong
in native Markdown and code blocks. Each accepted asset is a clean,
source-backed conceptual redraw made with imagegen from the original frame and
the focused crop. The generated files were inspected at normal lesson width
and independently reviewed before publication.

## Accepted assets

| Lesson | Source video and frame | Original frame SHA-256 | Crop | Crop SHA-256 | Published asset SHA-256 | Review |
| --- | --- | --- | --- | --- | --- | --- |
| `01-introduction.md` | `lP8xXebHmuE`, `m04-1523s-c` | `f52426bf5e21f3111e3c5a5c789535b570ca0551e44217c44e52f00bd4e1083b` | `(44, 27, 510, 304)` | `b21f703fd0ce1c2a11be0281bb52403ecd40ef0b95a66e0dd180346918ac60fe` | `1ffb94aacffabc46a97d361b4045952e271492760bb607c477613ae9029907eb` | PASS |
| `12-terraform-overview.md` | `s2bOYDCKl_M`, `m05-450s-b` | `9ebc0a786fbec4933f4064d53d48ce5aa672d1dce419d6445b85b9452f36ef6e` | `(0, 0, 640, 360)` | `fcf432dc41588c43e4b8ea9b399d75336189fd147672a514609036e4b5258d1e` | `2443a9e1a8aacf09eca2f1a8a5262686826d8f4a3b3c5fd56516ae3988706369` | PASS |
| `13-gcp-overview.md` | `18jIzE41fJ4`, `m02-60s-b` | `701ef29e34f344c9f8a2f0d08a3772eb7cda55851c08a25370c39692a2724791` | `(0, 23, 576, 314)` | `190e754247c0358742b791dac30bd94d6cfdc4a3e5e96e5ad339fbc9510f5420` | `9b620fd0b3d14b250cc494511094779d7676c6602e30ed8eb9ec8c9cf7ac1218` | PASS |

Source-video SHA-256 values are preserved in the worker audit at
`.tmp/workshop-processing/de-2027-m01/`. The frames and crops above are the
exact inputs used for the imagegen runs; no enlarged screenshot was accepted as
a crisp asset. The published images contain no presenter face, webcam feed,
Zoom overlay, cursor, browser/editor chrome, credentials, exact commands, or
transient numeric output.

The independent review is recorded at
`.tmp/workshop-processing/de-2027-m01/INDEPENDENT-REVIEW.md`. It passes all
three generated assets and rejects the raw screenshot candidates.
