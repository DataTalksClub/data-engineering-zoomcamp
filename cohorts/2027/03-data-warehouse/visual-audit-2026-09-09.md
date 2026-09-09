# Module 03 visual audit — 2026-09-09

The six canonical module-03 recordings were source-validated and the 16
published bitmap references were independently inspected at normal lesson
width. The independent review is preserved in
`/home/alexey/git/.tmp/workshop-processing/de-2027-m03/INDEPENDENT-REVIEW.md`.

## Final disposition

- 12 source-backed bitmaps remain published. The review found them genuinely
  crisp and source-faithful; none is only an enlarged or sharpened 640x360
  screenshot.
- The external-table details, partition-pruning result, and cluster-pruning
  result were converted to native Markdown tables. Exact values are now
  selectable text rather than screenshots.
- The local-model-copy screenshot was removed because it prominently showed
  an unnecessary destructive `rm -rf model` command next to the copy command.
  The exact `gsutil cp` command and model-file explanation remain native lesson
  content.
- No current bitmap failed for crispness, invented visual content, or an
  overlay. The removed/converted assets were content and accessibility
  decisions, not failed upscales.

## Provenance corrections

The independent review found and corrected three audit-record errors:

1. The clustering source-reference path is under
   `cohorts/2027/03-data-warehouse/`, not a nonexistent
   `03-data-warehouse-and-bigquery/` directory.
2. The architecture source-reference SHA ends in `...a5550c0`.
3. The prediction source-reference SHA ends in `...a9397b4c8`.

Current images retain their verified output hashes, raw-frame hashes, crop
coordinates, and crop hashes in the scratch machine-readable audit. The
source frame and focused crop were preserved for every retained regenerated
asset; exact UI/code content was reconstructed deterministically, while
conceptual diagrams used imagegen only for the durable relationship.
