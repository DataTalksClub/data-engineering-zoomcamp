# Module 04 visual audit — 2026-09-09

This audit records the three source-backed conceptual illustrations published in Module 04. The source screenshots were not published as-is: each candidate was selected from the matching lesson video, cropped to the useful region, and sent to imagegen together with the original non-crisp frame. Webcam, browser/editor chrome, exact code, URLs, and transient UI were excluded from the published redraws.

## Published assets

| Lesson | Video timestamp | Source video SHA-256 | Original frame SHA-256 | Crop and coordinates | Crop SHA-256 | Published asset SHA-256 |
| --- | ---: | --- | --- | --- | --- | --- |
| `01-analytics-engineering-basics.md` | 03:03 | `c938ca9ff4bf2115eee38664afa9fb71a8125944c8aebbf7ca6754a8c9955722` | `a1b6e48c866531b9a9d23777a6e1b7c09a6603b7f707c22fe7931606367b3667` | `uF76d5EmdtU/targeted/183-b-clean.jpg`, `x=0,y=0,w=640,h=300` | `cf67a90778f6392bd4e4d47fe6e0319955552fe0b071168cf059597ab619982f` | `f293a110d349adba986fb32a9d310260ce6454bdd37fd5015d390cd00331123c` |
| `02-what-is-dbt.md` | 03:00 | `53214894eadfcc049ff3529b156f6061cebfd3a4e022b38495356a362351a333` | `c6f36c4879ea11f536fa579951800201e9435f18903d5ab9fbe8c3eca7ff0b20` | `gsKuETFJr54/targeted/180-b-clean2.jpg`, `x=15,y=0,w=625,h=270` | `c481559610b83ff74e03b25de7a418940537feeb07eb4fb2134936b78ea87a65` | `9e218efa87e2ed777e78c8b3044b4bf6768877f1e105f09358864dbb11a930be` |
| `08-documentation.md` | 07:45 | `bd573cc627e03938c47f54b4bb096cfeab507edd19a2ddb378088a4e505ccd30` | `9fad479b75071e9c40f1b778d570f087d8e4d6f155ec2e6b022577fcc62d5fc7` | `UqoWyMjcqrA/targeted/465-b-clean2.jpg`, `x=0,y=55,w=640,h=125` | `359d14ebd59fcde82e3577cbb44aaa5c27fe7c415cf9f8ece27bd9b6a8e9017a` | `e173def5c69470628c65ae2d8d4db7b29c5c1ce0204bd36f9cd9847e2b7bcf33` |

The same source hashes are retained in the machine-readable scratch audit at `/home/alexey/git/.tmp/workshop-processing/de-2027-m04/metadata/` and `crop-register.tsv`.

## Acceptance checks

- All 10 Module 04 source videos and transcripts were validated before candidate selection.
- The original non-crisp frame was supplied to imagegen for every published asset; the focused crop was supplied as the second reference where it improved framing.
- The redraws preserve only relationships taught by the source: the analytics-engineering toolchain, dbt model-to-warehouse flow, and dbt lineage flow.
- The redraws remove faces, webcam tiles, browser/editor chrome, exact code, URLs, and transient values.
- Each output was inspected after generation at normal viewing size and checked for readability, layout integrity, and absence of obvious artifacts.
- Independent visual review is recorded separately in `/home/alexey/git/.tmp/workshop-processing/de-2027-m04/INDEPENDENT-REVIEW.md`; all three published assets passed the final re-review after the dbt-flow correction.

The other seven Module 04 source IDs were rejected or kept native because their useful content was exact code, terminal output, tables, editor views, or transient UI rather than a durable illustration.
