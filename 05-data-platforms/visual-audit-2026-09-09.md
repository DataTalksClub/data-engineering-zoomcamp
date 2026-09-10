# Module 05 visual audit — 2026-09-09

This audit records the six source-backed conceptual illustrations published
for the Bruin/Data Platforms lessons. Each output was generated with the
original non-crisp video frame and the focused source crop as references. Raw
screenshots were not published; faces, webcams, browser/editor/recording
chrome, exact YAML/commands, credentials, URLs, and environment identifiers
were removed from the redraws.

## Published assets and provenance

| Lesson/video moment | Original frame SHA-256 | Focused crop SHA-256 | Published asset SHA-256 |
| --- | --- | --- | --- |
| 03 / `q0k_iz9kWsI` / M03-C03 | `4ab1b3a8fe6c3ceb5ff012f5bfdb2fa9ca36558b99fb5fad7afbcb6d0cc92e09` | `63ec5f5f195fe8f554c8a33e8df9feb721230e2fbcbfd37b8eed0efe7e447b0e` | `6743517378ef2d3f515e9b35f5cc8b828fc570c22710ca28a19d342d86e91a2f` |
| 06 / `YWDjnSxbBtY` / M06-C01 | `db62fee7a3786069ecaeaf056e6cf01c44436cab4c927ccb5f96a6ca020c768c` | `f13b93818f6461be8ba0b7373f37ac74d440243ae96af6c8407f77ca3d2f0aee` | `28f34d5bbea2104e34536ab360d189affd43eb6cb27405beb0549cff6daeeff5` |
| 07 / `uzp_DiR4Sok` / M07-C01 | `e610839c9c4540c80b0fea95c0cb97fa42328581d65fcb3f7dbf6ba279315d1e` | `67c5d4a9225d8211feaf2c9a6df696dafb152337b38f42b9016a3ace75d340d4` | `0be55ca8b2e2c22496b448bc6127c7cf1e90f456a15d01015c1b682e3e951b82` |
| 07 / `uzp_DiR4Sok` / M07-C02 corrected | `ee03a49e8dd8b543c2d50d3a2886f8de9fa4de8d9a7b115a8904c86d3a81c2e4` | `2b92e2527ff6fe0a468a385865c3467dcced9d2c8844856b2b98f3d4dbbc4c88` | `562b47e03d3e4408c6bc166f0e77cbe8a6e0c56d499c5741f2149cf47ea4f9e6` |
| 08 / `ZElY5SoqrwI` / M08-C02 corrected | `00e69ee02f061cdaaba7b5723e54d7af734ac8591143041f277a3975485ba6cb` | `6a6748cd71715265ab8f5e69a56b56312557565c0154b986568c1efd1ef4e0a1` | `6efaa1e67609f1802c176d73dd0e462dcddbb60fc4ed243f13994474824d8205` |
| 10 / `3nykPEs_V7E` / M10-C01 | `5b9486f00ca1adb79e7fc57ee329b5adbf5cd8c6aa16342ad0f08b60a14f53f5` | `21b402f65796206590e5280879b7db9d8def7ba64ebd84e3cb7dc374184eccb8` | `701be496c822bf80d9c2a054e0b784e5943f8719b1027aa7d062ab4a95842686` |

The source/frame audit covers all 10 canonical Module 05 videos: 10/10
ffprobe records, video hashes, and timestamped transcripts verified. The
complete candidate decisions are retained in
`.tmp/workshop-processing/de-2027-m05/STATUS.md` and its machine-readable
audit.

## Review gate

The first six redraws were independently reviewed against their original
frames and crops. Two defects were found and corrected before publication:

- the pipeline-configuration arrows initially pointed inward; the corrected
  diagram points outward from configuration to the defined components;
- the asset-lineage redraw initially omitted one of three upstream assets; the
  corrected diagram preserves all three generic upstream inputs.

The correction outputs were independently re-reviewed and both passed. The
full reports are retained under `.tmp/workshop-processing/de-2027-m05/`.

The remaining Module 05 candidates are exact configuration/code/UI/table/result
material or weak/duplicate frames. They remain native lesson content or are
excluded; no screenshot raster is used in their place.
