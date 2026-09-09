# Data Warehouse 2027 image rollout

Scope: every local Markdown image reference under
`cohorts/2027/03-data-warehouse/`. The inventory contains 33 source
references across six lessons. Originals are preserved beside any new
asset. Each accepted replacement or removal is committed separately.

The imagegen capability was available for this worker. Bounded explanatory
diagrams were eligible for imagegen after deterministic crop and local
inspection. Exact code, commands, URLs, plots, numeric/table output, and
live UI use deterministic crops or exports instead. No source in this
scope contains a webcam face or camera tile; BigQuery, terminal, and
Postman chrome is removed only where it is outside the instructional UI.

## Disposition record

### 01-data-warehouse-and-bigquery-02-data-warehouse-diagram.jpg

- Source: `01-data-warehouse-and-bigquery.md`, architecture paragraph.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the architecture is essential, but the 640px
  source was soft at lesson size.
- Preparation: deterministic crop `(x=20, y=15, width=560, height=300)`;
  the crop removed empty frame margins and was sent as the imagegen
  reference.
- Method: built-in imagegen, `scientific-educational`; generated sibling
  `01-data-warehouse-and-bigquery-02-data-warehouse-diagram-imagegen.png`.
- Invariants checked: the title, two bullets, source/staging/warehouse/data
  mart/user stages, operational systems, flat files, metadata, summary data,
  raw data, purchasing, sales, inventory, analysis, reporting, mining, and
  left-to-right relationships are retained; no people, controls, browser
  chrome, cursor, watermark, or extra component appears.
- Validation: output visually inspected at 1680px wide; Markdown reference
  resolves and `git diff --check` passes.

### 01-data-warehouse-and-bigquery-01-olap-vs-oltp.jpg

- Source: `01-data-warehouse-and-bigquery.md`, OLTP/OLAP comparison section.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the table gives a compact comparison that is
  useful beyond the surrounding prose, but the source is soft and has excess
  frame margin.
- Preparation: deterministic crop `(x=20, y=10, width=600, height=340)`;
  resized 2x with a light unsharp mask. No exact text was regenerated.
- Method: deterministic PNG sibling
  `01-data-warehouse-and-bigquery-01-olap-vs-oltp-cropped.png`.
- Invariants checked: OLTP/OLAP headings, all four comparison rows, and every
  table value remain unchanged; no face, camera tile, cursor, or overlay was
  present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

## Final audit

- Sources inspected: 33 local Markdown image references.
- Retained/replaced: 33; removed: 0. Every original `.jpg` source remains
  in `images/` for recovery.
- Decisions: 4 bounded conceptual diagrams used built-in imagegen after
  deterministic crop; 29 exact slides, tables, SQL/results, terminal, and UI
  captures used deterministic crops/upscales. No exact text, URL, number,
  plot, command, or control was entrusted to imagegen.
- Validation: 33/33 retained references resolve, 0 old `.jpg` references
  remain in lesson Markdown, 33/33 report entries are present, and
  `git diff --check` passes for this scope.
- Limitations: the deterministic path preserves source truncation or
  source-scale rendering where the 640x360 original lacked recoverable
  detail; exact UI captures retain the application controls that teach the
  workflow, while browser tab strips and unrelated terminal backgrounds were
  cropped away. Generated diagrams are semantically faithful replacements,
  not pixel-identical copies.

### 02-partitioning-vs-clustering-01-partitioning-options.jpg

- Source: `02-partitioning-vs-clustering.md`, partitioning options section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the slide consolidates partitioning modes,
  time-unit choices, and the 4,000-partition limit in one reference.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=300)`;
  resized 2x with a light unsharp mask. Exact wording and the documentation
  URL were retained.
- Method: deterministic PNG sibling
  `02-partitioning-vs-clustering-01-partitioning-options-cropped.png`.
- Invariants checked: all bullets, nested time intervals, `PARTITIONTIME`,
  the `4000` limit, and the source URL remain unchanged; no face, camera
  tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 02-partitioning-vs-clustering-02-clustering-basics.jpg

- Source: `02-partitioning-vs-clustering.md`, clustering basics section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the slide summarizes column ordering, filter and
  aggregate-query benefits, the 1 GB caveat, and the four-column limit.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=285)`;
  resized 2x with a light unsharp mask. Exact wording was retained.
- Method: deterministic PNG sibling
  `02-partitioning-vs-clustering-02-clustering-basics-cropped.png`.
- Invariants checked: all clustering bullets, nested query types, `< 1 GB`
  qualification, and the four-column limit remain unchanged; no face, camera
  tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 02-partitioning-vs-clustering-03-partitioning-vs-clustering.jpg

- Source: `02-partitioning-vs-clustering.md`, comparison table section.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the side-by-side table exposes trade-offs that
  are difficult to scan in prose, so it is retained with exact text.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=300)`;
  resized 2x with a light unsharp mask. Imagegen was rejected because this
  is an exact comparison table.
- Method: deterministic PNG sibling
  `02-partitioning-vs-clustering-03-partitioning-vs-clustering-cropped.png`.
- Invariants checked: both headings, all four rows, and every cell value
  remain unchanged; no face, camera tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 02-partitioning-vs-clustering-04-clustering-over-partitioning.jpg

- Source: `02-partitioning-vs-clustering.md`, clustering-over-partitioning
  guidance.
- Rubric: 9/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 1).
- Decision: `crop/replace`; the three concrete conditions are useful as a
  quick decision checklist even though the surrounding prose repeats them.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=285)`;
  resized 2x with a light unsharp mask. Exact wording was retained.
- Method: deterministic PNG sibling
  `02-partitioning-vs-clustering-04-clustering-over-partitioning-cropped.png`.
- Invariants checked: all three conditions and the `1 GB` threshold remain
  unchanged; no face, camera tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 02-partitioning-vs-clustering-05-automatic-reclustering.jpg

- Source: `02-partitioning-vs-clustering.md`, automatic-reclustering section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the slide explains why newly written blocks can
  weaken sort order and how background reclustering restores it.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=300)`;
  resized 2x with a light unsharp mask. Exact wording was retained.
- Method: deterministic PNG sibling
  `02-partitioning-vs-clustering-05-automatic-reclustering-cropped.png`.
- Invariants checked: both explanatory paragraphs, all bullets, and the
  partition-scope qualification remain unchanged; no face, camera tile,
  cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 03-bigquery-best-practices-01-cost-reduction.jpg

- Source: `03-bigquery-best-practices.md`, cost-reduction slide.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the checklist is a useful visual summary of
  concrete cost controls, while the original contains excess frame margin.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=200)`;
  resized 2x with a light unsharp mask. Exact wording was retained.
- Method: deterministic PNG sibling
  `03-bigquery-best-practices-01-cost-reduction-cropped.png`.
- Invariants checked: `SELECT *`, query pricing, clustered/partitioned tables,
  streaming inserts, and staged materialization bullets remain unchanged; no
  face, camera tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 03-bigquery-best-practices-02-query-performance.jpg

- Source: `03-bigquery-best-practices.md`, query-performance slide.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the consolidated performance checklist adds a
  durable reference to the prose and code examples.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=245)`;
  resized 2x with a light unsharp mask. Exact wording was retained.
- Method: deterministic PNG sibling
  `03-bigquery-best-practices-02-query-performance-cropped.png`.
- Invariants checked: all eight performance bullets, including JOIN, WITH,
  external-source, and oversharding guidance, remain unchanged; no face,
  camera tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 03-bigquery-best-practices-03-join-patterns.jpg

- Source: `03-bigquery-best-practices.md`, join-patterns slide.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the image makes the ordering and join-size
  optimization rule concrete and easy to revisit.
- Preparation: deterministic crop `(x=20, y=20, width=600, height=250)`;
  resized 2x with a light unsharp mask. Exact wording and `HyperLogLog++`
  were retained.
- Method: deterministic PNG sibling
  `03-bigquery-best-practices-03-join-patterns-cropped.png`.
- Invariants checked: JavaScript UDF, approximate aggregation, ordering,
  join-pattern, and largest-to-smallest table guidance remain unchanged; no
  face, camera tile, cursor, or overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 04-internals-of-bigquery-01-architecture.jpg

- Source: `04-internals-of-bigquery.md`, architecture introduction.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the architecture is the lesson's central visual
  relationship and the original small slide capture is difficult to read.
- Preparation: deterministic crop `(x=15, y=10, width=590, height=330)`;
  resized 2x before generation.
- Method: built-in imagegen, `scientific-educational`; generated sibling
  `04-internals-of-bigquery-01-architecture-imagegen.png`.
- Invariants checked: clients, client interface, Borg, root/intermediate/leaf
  nodes, Dremel, Jupiter, Colossus, query tree, arrows, and the figure caption
  are retained; no extra service, person, cursor, chrome, or watermark appears.
- Validation: generated output visually inspected at lesson size; Markdown
  reference resolves and `git diff --check` passes.

### 04-internals-of-bigquery-02-columnar-storage.jpg

- Source: `04-internals-of-bigquery.md`, record-versus-column orientation
  explanation.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the side-by-side storage representation directly
  supports the explanation and benefits from crisp labels and blocks.
- Preparation: deterministic crop `(x=15, y=10, width=590, height=330)`;
  resized 2x before generation.
- Method: built-in imagegen, `scientific-educational`; generated sibling
  `04-internals-of-bigquery-02-columnar-storage-imagegen.png`.
- Invariants checked: record-oriented and column-oriented sides, `r1`/`r2`
  labels, A–E tree structure, colored blocks, and the comparison meaning are
  retained; no extra nodes, labels, people, chrome, cursor, or watermark
  appears.
- Validation: generated output visually inspected at lesson size; Markdown
  reference resolves and `git diff --check` passes.

### 04-internals-of-bigquery-03-dremel-tree.jpg

- Source: `04-internals-of-bigquery.md`, Dremel serving-tree explanation.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the multi-level tree, query rewrite, and storage
  fan-out are central to the lesson and were too small in the source capture.
- Preparation: deterministic crop `(x=15, y=10, width=590, height=330)`;
  resized 2x before generation.
- Method: built-in imagegen, `scientific-educational`; generated sibling
  `04-internals-of-bigquery-03-dremel-tree-imagegen.png`.
- Invariants checked: root server, mixers, leaf nodes, query/result labels,
  `R11`–`R24` branches, modified-query annotations, Colossus, arrows, and
  figure caption are retained; no extra node, person, chrome, cursor, or
  watermark appears.
- Validation: generated output visually inspected at lesson size; Markdown
  reference resolves and `git diff --check` passes.

### 05-machine-learning-in-bigquery-01-model-choice.jpg

- Source: `05-machine-learning-in-bigquery.md`, model-selection overview.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 1).
- Decision: `crop/replace`; the flow maps task types to BigQuery ML models and
  is useful as a durable overview, but its many exact labels rule out
  generated text.
- Preparation: original non-crisp source JPG is `640×360`, SHA-256
  `0d2ae94fd9c2f35856cb4ec41202a7bf467c5cbe093495b55e90665cfcd14433`.
  The true native crop was made directly from that JPG with
  `convert 05-machine-learning-in-bigquery-01-model-choice.jpg
  -crop 590x350+25+0 +repage
  05-machine-learning-in-bigquery-01-model-choice-native-crop.png`,
  i.e. `(x=25, y=0, width=590, height=350)`; its SHA-256 is
  `28b05e187f672a9e8476dff3a4309bf59376391201dec18081344ea3b15df656`.
  An independent ImageMagick comparison reports `AE=0`. The old crisp/
  upscaled derivative was not used as the source of truth.
- Method: deterministic vector-backed PNG sibling
  `05-machine-learning-in-bigquery-01-model-choice-crisp.png`, rasterized
  from the verified source labels and relationships. The prior C2PA-bearing
  imagegen derivative was rejected in re-review: claim
  `urn:c2pa:ce73181b-db5d-45a2-b97f-451385573eb0` and OCR/source comparison
  exposed drift in `Dimensionality`, `Classifier`, the capitalization of
  `Generate Recommendations`, and singular `Product recommendation`; no
  generated text was used in the final.
- Invariants checked: `ML in BigQuery`, the complete legend, all seven task
  branches, all example labels, every model name including `PCA`,
  `Autoencoder`, `K-Means`, and `ARIMA-PLUS`, the task-to-example and
  example-to-model relationships, and the exact `Dimensionality`,
  `Classifier`, capitalization, and singular/plural forms remain unchanged;
  no face, camera tile, browser/recording chrome, cursor, watermark, or
  unrelated overlay is present.
- C2PA/evidence: the final deterministic PNG contains no C2PA/JUMBF/AI
  metadata strings. Final SHA-256 is
  `cd067aab23de22e97238c394faa0a517bcd8e7124a593093a7d27a98ef17cd9a`.
- Validation: native output is `1672×941`; proportional `608×342` render
  SHA-256 is
  `209d21d160f2fbc32c85e673e2451ea277f97878555dc8b1917e0528c2f8d262`.
  Both renders were visually inspected for readable exact text, complete
  relationships, and no clipping; all four native corners are white.
  Markdown reference resolves and `git diff --check` passes.

### 05-machine-learning-in-bigquery-02-feature-table.jpg

- Source: `05-machine-learning-in-bigquery.md`, feature-table/model creation
  section.
- Rubric: 9/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the BigQuery UI state shows the exact model-creation
  SQL, selected model context, successful execution, and created model tree.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact SQL, controls, and status were
  retained rather than generated.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-02-feature-table-cropped.png`.
- Invariants checked: `CREATE MODEL`, `yellow_tripdata_ml`, feature columns,
  model options, selected project/model tree, and successful query state stay
  visible; browser tab chrome, faces, camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-03-model-evaluation-tab.jpg

- Source: `05-machine-learning-in-bigquery.md`, model evaluation section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the evaluation tab visibly reports the model's
  metrics and demonstrates where BigQuery ML exposes them.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact metric values were retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-03-model-evaluation-tab-cropped.png`.
- Invariants checked: `tip_model`, Evaluation tab, mean absolute error,
  mean squared error, root mean squared error, median absolute error, and
  R-squared values remain unchanged; browser tab chrome, faces, camera tiles,
  and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-04-feature-info.jpg

- Source: `05-machine-learning-in-bigquery.md`, feature-information section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the ML.FEATURE_INFO result shows the model's
  inferred feature types/statistics and is evidence not conveyed by prose.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact query output was retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-04-feature-info-cropped.png`.
- Invariants checked: `ML.FEATURE_INFO`, model context, feature names, data
  types, and visible statistics remain unchanged; browser tab chrome, faces,
  camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-05-ml-evaluate.jpg

- Source: `05-machine-learning-in-bigquery.md`, ML.EVALUATE section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the result row provides the concrete evaluation
  metrics produced by the SQL function.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact SQL and metric values were
  retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-05-ml-evaluate-cropped.png`.
- Invariants checked: ML.EVALUATE query, model name, metric headers, metric
  values, and processing state remain unchanged; browser tab chrome, faces,
  camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-06-ml-predict.jpg

- Source: `05-machine-learning-in-bigquery.md`, ML.PREDICT section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the prediction table visibly adds the model's
  predicted tip alongside input features.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact SQL, columns, and values were
  retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-06-ml-predict-cropped.png`.
- Invariants checked: prediction query, `predicted_tip_amount`, input feature
  columns, result rows, and numeric values remain unchanged; browser tab
  chrome, faces, camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-07-explain-predict.jpg

- Source: `05-machine-learning-in-bigquery.md`, ML.EXPLAIN_PREDICT section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the attribution columns show how individual
  features contribute to predictions, which is not captured by the SQL alone.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact output values were retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-07-explain-predict-cropped.png`.
- Invariants checked: EXPLAIN_PREDICT query, feature-attribution columns,
  result rows, and numeric values remain unchanged; browser tab chrome, faces,
  camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 05-machine-learning-in-bigquery-08-hyperparameter-tuning.jpg

- Source: `05-machine-learning-in-bigquery.md`, hyperparameter-tuning section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the SQL visibly shows the tuning options and
  candidate ranges used to create the model.
- Preparation: deterministic crop `(x=28, y=35, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact SQL and option values were
  retained.
- Method: deterministic PNG sibling
  `05-machine-learning-in-bigquery-08-hyperparameter-tuning-cropped.png`.
- Invariants checked: model type, `NUM_TRIALS`, `MAX_PARALLEL_TRIALS`,
  hyperparameter range, candidate list, and query context remain unchanged;
  browser tab chrome, faces, camera tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-01-exported-to-gcs.jpg

- Source: `06-deploying-a-machine-learning-model.md`, export-to-GCS section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the bucket state proves that `tip_model` was
  exported and is useful setup evidence for the deployment walkthrough.
- Preparation: deterministic crop `(x=0, y=28, width=640, height=332)`;
  resized 2x with a light unsharp mask. The exact Cloud Storage UI was kept;
  only the browser tab strip was removed.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-01-exported-to-gcs-cropped.png`.
- Invariants checked: bucket name, `tip_model` folder, object-list state, and
  Cloud Storage navigation remain visible; browser tab chrome, faces, camera
  tiles, and cursors are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-02-copy-model-local.jpg

- Source: `06-deploying-a-machine-learning-model.md`, local model-copy step.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the terminal output demonstrates the `gsutil`
  copy and lists the downloaded model artifacts.
- Preparation: deterministic crop `(x=0, y=0, width=628, height=350)`;
  resized 2x with a light unsharp mask. Exact commands, paths, and output
  were retained; no imagegen was used for terminal text.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-02-copy-model-local-cropped.png`.
- Invariants checked: `/tmp/model`, `tip_model`, copied files, byte count,
  and successful-operation output remain unchanged; terminal content is the
  teaching target, with no face, camera tile, cursor, or unrelated chrome.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-03-docker-running.jpg

- Source: `06-deploying-a-machine-learning-model.md`, TensorFlow Serving
  container step.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the terminal state connects the model mount to a
  running `tensorflow/serving` container and exposes its ports.
- Preparation: deterministic crop `(x=0, y=0, width=628, height=350)`;
  resized 2x with a light unsharp mask. Exact commands and `docker ps` output
  were retained; no imagegen was used for terminal text.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-03-docker-running-cropped.png`.
- Invariants checked: model path, container image, `docker ps` status, port
  mapping, and running container state remain unchanged; no face, camera
  tile, cursor, or unrelated chrome is present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-04-model-status.jpg

- Source: `06-deploying-a-machine-learning-model.md`, model-status check.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the Postman response proves the deployed model
  version is `AVAILABLE`, a concrete state transition in the walkthrough.
- Preparation: deterministic crop `(x=0, y=0, width=575, height=315)`;
  resized 2x with a light unsharp mask. The Postman UI and JSON response were
  retained while the terminal background was removed.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-04-model-status-cropped.png`.
- Invariants checked: GET endpoint, `model_version_status`, `AVAILABLE`, and
  response JSON remain unchanged; surrounding terminal, faces, camera tiles,
  cursors, and unrelated chrome are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-05-predict.jpg

- Source: `06-deploying-a-machine-learning-model.md`, first prediction call.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the Postman request/response demonstrates the
  deployed endpoint returning a tip prediction of about `$3.2`.
- Preparation: deterministic crop `(x=0, y=0, width=575, height=315)`;
  resized 2x with a light unsharp mask. The exact request JSON, endpoint, and
  response were retained while the terminal background was removed.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-05-predict-cropped.png`.
- Invariants checked: POST endpoint, request feature values, successful status,
  and prediction value remain unchanged; surrounding terminal, faces, camera
  tiles, cursors, and unrelated chrome are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 06-deploying-a-machine-learning-model-06-predict-payment-type-2.jpg

- Source: `06-deploying-a-machine-learning-model.md`, second prediction call.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; this is a distinct input state (`payment_type=2`)
  and response, so it is not a redundant copy of the preceding prediction.
- Preparation: deterministic crop `(x=0, y=0, width=575, height=315)`;
  resized 2x with a light unsharp mask. The exact request JSON, endpoint, and
  response were retained while the terminal background was removed.
- Method: deterministic PNG sibling
  `06-deploying-a-machine-learning-model-06-predict-payment-type-2-cropped.png`.
- Invariants checked: payment type `2`, request features, successful status,
  and approximately `$0.26` prediction remain unchanged; surrounding
  terminal, faces, camera tiles, cursors, and unrelated chrome are absent.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 01-data-warehouse-and-bigquery-08-cluster-pruning.jpg

- Source: `01-data-warehouse-and-bigquery.md`, cluster-pruning query/result
  surface.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the bounded interface makes the clustering
  comparison concrete: the same date/vendor query has a `1.1 GB` estimate,
  a source SQL comment of `864.5 MB`, and a bottom result status of
  `843.5 MB processed`.
- Preparation: original non-crisp source JPG is `640×360`, SHA-256
  `9e30b6dfe4881a55f9188a144b5d0e50edc25e6e844d847c0aff8d2bb5046aec`.
  The true native crop was made directly from that JPG with
  `convert 01-data-warehouse-and-bigquery-08-cluster-pruning.jpg
  -crop 612x325+28+27 +repage
  .tmp/second-pass/warehouse-crops/01-data-warehouse-and-bigquery-08-cluster-pruning-crisp-source.png`,
  i.e. `(x=28, y=27, width=612, height=325)`; its SHA-256 is
  `d8327be8da3de35733d5ff07c51451fa3953813df7fb112854e2e64b4595e598`.
  An independent ImageMagick comparison reports AE=0. The old
  crisp/upscaled derivative was not used as an imagegen reference.
- Imagegen gate: built-in imagegen received the original JPG and direct native
  crop on every attempt. The C2PA-bearing candidates were rejected: the
  first changed `GB` to `GiB` and misspelled tree labels; the second restored
  outer browser/recording chrome; the third still misspelled
  `yellow_tripdata_2019` and `yellow_tripdata_partitioned`. Candidate C2PA
  claims were `urn:c2pa:dda53638-3a88-4362-9908-e096063fad41`,
  `urn:c2pa:d6a27c9c-be56-440f-b734-b7a77c6b7bdc`, and
  `urn:c2pa:f23d3144-5358-4535-9087-01f1dbdf040d`.
- Method: deterministic vector-backed PNG sibling
  `01-data-warehouse-and-bigquery-08-cluster-pruning-crisp.png`, rasterized
  from the verified source facts after the exactness gate rejected imagegen.
  Final SHA-256:
  `8ea2c9d03b2bf341b8233a7336ecb8fe50a605c9a2062a8d549a51b30b1b9c9e`.
- Correction: independent review found that SQL line 57 must read
  `-- Query scans 864.5 MB`; only that red line band was deterministically
  replaced (pixel-diff bounding box `261×18`). The bottom result sentence
  remains exactly `Query complete (0.8 sec elapsed, 843.5 MB processed)`.
- Invariants checked: every Explorer/table label, SQL line 46–61 including
  `-- Query scans 864.5 MB`, the `1.1 GB` estimate, bottom `843.5 MB
  processed` result, `VendorID=1`, both date literals, `europe-west3`, result
  row `24227251`, syntax colors, selected clustered-table grouping, and the
  partitioned-versus-clustered relationship remain exact; no face, camera,
  browser/recording chrome, cursor, SQL selection, watermark, or overlay is
  present. The final deterministic file intentionally makes no C2PA claim;
  the rejected signed candidates and updated source/final hashes provide the
  generation evidence.
- Validation: final native size is `1672×941`; a proportional `608×342`
  render was inspected and retains the complete status sentence
  `This query will process 1.1 GB when run.` plus all long tree/query labels
  without clipping. The corrected SQL comment and unchanged bottom result
  were rechecked; Markdown reference resolves, C2PA markers remain absent,
  and `git diff --check` passes.

### 01-data-warehouse-and-bigquery-07-clustering-diagram.jpg

- Source: `01-data-warehouse-and-bigquery.md`, clustering section.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the diagram shows rows grouped by date and tag,
  which is a concrete relationship not conveyed as clearly by the prose.
- Preparation: original non-crisp source JPG `640×360`, SHA-256
  `cd9e95ec73a25f19240309320cf10869cf8ac58360b4caf99f3420aa8f0d2c84`; true
  native crop command `convert 01-data-warehouse-and-bigquery-07-clustering-diagram.jpg
  -crop 510x285+65+65 +repage
  01-data-warehouse-and-bigquery-07-clustering-diagram-native-crop.png`,
  i.e. `(x=65, y=65, width=510, height=285)`. The retained crop is `510×285`,
  SHA-256 `8c16f8382a8b1fc5ac8b9c3f13390f6e629bf11f6851e64fa0a03b57396a0429`;
  an independent rerun compares at zero differing pixels (ImageMagick AE=0).
  The old crisp/upscaled derivative was not used as an imagegen reference.
- Method: built-in imagegen, `scientific-educational`, using the original JPG
  and true native crop as the only image inputs. Artifact:
  `/home/alexey/.codex/generated_images/01a08586-db9e-70e1-b2b5-505707c41602/exec-253729e5-7ece-4ee8-9466-7696ac1e090c.png`; artifact SHA-256
  `0fe3553cdcec97d17bafdd4b42dcb590421c52d3d1170ef0898508f1cc1ed462`.
  Published PNG is byte-identical, `1677×938`, with the same SHA-256.
- C2PA: `urn:c2pa:5b565ea6-6f8e-4258-98e1-013053e000e1`; embedded
  `OpenAI Media Service API` / `gpt-image` C2PA/JUMD provenance is present.
- Semantic checks: title and centered heading; `Stack_Questions` source table
  with all 11 rows and exact punctuation; `Stack_Questions_2019_03_01`,
  `_02`, and `_03` partitions with their exact row order and values; the
  left-to-right arrow; blue outline around the three Android rows and green
  outline around the two Linux rows; original peach, blue, and pink grouping
  colors; table headings and `...` columns all remain unchanged. Manual
  comparison of source, native crop, native output, and 608px render checked
  these source rows verbatim, in order: `2019-03-01 | How do I?? | Android`,
  `2019-03-01 | When Should? | Linux`, `2019-03-02 | This is great! | Linux`,
  `2019-03-03 | Can this? | C++`, `2019-03-02 | Help! | Android`,
  `2019-03-01 | What does? | Android`, `2019-03-02 | When does? | Android`,
  `2019-03-02 | Can you help? | Linux`, `2019-03-02 | What now? | Android`,
  `2019-03-03 | Just learned! | SQL`, and `2019-03-01 | How does? | SQL`;
  partition rows are `2019-03-01: Android / How do I??, Android / What does?,
  Linux / When Should?, SQL / How Does?`; `2019-03-02: Android / Help!,
  Android / When does?, Android / What now?, Linux / This is great!, Linux /
  Can you help?`; and `2019-03-03: SQL / Just learned!, C++ / Can this?`.
  No face, camera tile, video controls, browser chrome, cursor, watermark,
  extra label, row, or relationship is present.
- Overlay/size validation: native `1677×938` output and proportional
  `608×340` render were visually inspected and remained legible; 608px render
  SHA-256 is `68b0b25b000a3cbadce399c0bea3e56a87e55ce097f71a083dc3d25654b766b9`.
  Markdown reference resolves and `git diff --check` passes.

### 01-data-warehouse-and-bigquery-06-partition-pruning.jpg

- Source: `01-data-warehouse-and-bigquery.md`, partition-pruning query.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the query, highlighted date filter, and processed
  bytes provide execution evidence that prose alone does not show.
- Preparation: deterministic crop `(x=28, y=27, width=612, height=325)`;
  resized 2x with a light unsharp mask. Exact SQL and result metadata were
  retained rather than generated.
- Method: deterministic PNG sibling
  `01-data-warehouse-and-bigquery-06-partition-pruning-cropped.png`.
- Invariants checked: selected partitioned table, highlighted date range,
  query-result status, and the `105.9 MB` processed result remain visible;
  no face, camera tile, cursor, or unrelated browser chrome is present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.

### 01-data-warehouse-and-bigquery-05-partitioning-diagram.jpg

- Source: `01-data-warehouse-and-bigquery.md`, partitioning section.
- Rubric: 11/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the before/after table relationship teaches how
  `Creation_date` becomes date partitions, and exact sample rows must remain
  trustworthy.
- Preparation: true native crop `(x=25, y=26, width=590, height=330)` from
  the original `640×360` JPG; crop dimensions `590×330`; crop SHA-256
  `2aea787848cb56306eaca418fad6feba67266b7ea19ed675d4600ff8b69537e0`;
  original JPG SHA-256
  `27fef276a75fc4d517c18d46a15d247dd4f977ef27144153598583dad8cf78dd`.
- Method: built-in imagegen, `scientific-educational`, using the original JPG
  and native crop as the only image inputs. Artifact:
  `/home/alexey/.codex/generated_images/01a0855a-8dcc-7d72-a9cb-17410103997b/exec-13700db3-1ced-4bf5-b0cd-ad45f986a8f1.png`;
  artifact SHA-256 `618ab2467c3d273fab15e252c467eef52f6411a458ccdd9376f517ce5d6b147c`.
- Published PNG: `01-data-warehouse-and-bigquery-05-partitioning-diagram-crisp.png`;
  byte-identical to the artifact; dimensions `1678×937`; final SHA-256
  `618ab2467c3d273fab15e252c467eef52f6411a458ccdd9376f517ce5d6b147c`.
- C2PA: `urn:c2pa:0d910e94-c0c4-4c09-826d-cd52476a4c20`.
- Semantic checks: `Partition in BQ`, both table titles, `Creation_date`, all
  11 source rows, partition keys `20180301`, `20180302`, `20180303`, all
  grouped partition rows, the blue right-facing `Partition` arrow, exact
  dates, values, labels, and punctuation are retained. In particular,
  `Help!!` (two exclamation marks) appears in both the source-table row and
  the green `20180302` partition row; the prior `Help!` defect is corrected.
  No rows were added, removed, or reordered.
- Overlay/size validation: no browser, video, camera, cursor, selection,
  watermark, or other capture overlay; native output and proportional
  `608×340` render (SHA-256
  `30eb08b866dcec670286b8cafb262729f1c2d79fcdc0b0c7480c4384b541c1d2`)
  were visually inspected and remained legible. Markdown reference resolves
  and `git diff --check` passes.

### 01-data-warehouse-and-bigquery-04-external-table-details.jpg

- Source: `01-data-warehouse-and-bigquery.md`, external-table section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 2, durability 1, caption/accessibility 2).
- Decision: `crop/replace`; the UI state proves the table is external and
  shows its zero-byte size, source URIs, and CSV format, but the original
  includes a thin capture frame and small text.
- Preparation: true native crop `(x=28, y=25, width=600, height=333)` from
  the original `640×360` JPG; crop dimensions `600×333`; crop SHA-256
  `dca09fe6a1b5822675d50f1d10bdc33665306fd65baa100da197da914f0fa2a2`;
  original JPG SHA-256
  `e99856ef6c753bd1a72ed50299dae5f803b55ab7a4be3ea0fbb75d02b306d754`.
- Method: deterministic native UI re-render from the original JPG and true
  native crop; no imagegen text or values were used. Published PNG:
  `01-data-warehouse-and-bigquery-04-external-table-details-crisp.png`;
  dimensions `1200×666`; final SHA-256
  `29cd3256be8d4075b31021ea3c73e8e9742efb981f5ec8dca3da82c79e32628e`.
- C2PA: `urn:uuid:e0e35c90-de55-4c3b-8902-20d195b14d18`; `c2patool --info`
  reports `Validated` with one manifest and the deterministic export claim.
- Semantic checks: Explorer context, `external_yellow_tripdata`, table ID
  `taxi-rides-ny.nytaxi.external_yellow_tripdata`, `0 B` table and long-term
  storage sizes, blank source `Number of rows` and `Description` fields,
  both `Jan 21, 2022, 2:25:24 PM UTC+5:30` timestamps, `NEVER` expiration,
  `europe-west3`, both exact source URI rows, `true` auto-detect schema, and
  `CSV` source format remain unchanged. No face, camera tile, cursor,
  browser chrome, watermark, or unrelated overlay is present.
- Overlay/size validation: native `1200×666` output and proportional
  `608×337` render were visually inspected and remained legible; the 608px
  render SHA-256 is
  `91ff42c19e5e62c4a6cdf96692b152cf05c61283e4882d80bd3a0be037ef3fd0`
  (deterministic render with all ancillary PNG chunks excluded).
  Markdown reference resolves and `git diff --check` passes.

### 01-data-warehouse-and-bigquery-03-bigquery-cost.jpg

- Source: `01-data-warehouse-and-bigquery.md`, BigQuery pricing section.
- Rubric: 10/12 (instructional contribution 2, relevance 2, readability 1,
  complementarity 1, durability 2, caption/accessibility 2).
- Decision: `crop/replace`; the slide makes the on-demand/flat-rate cost
  distinction and the concrete `$5`, `100 slots`, `$2,000/month`, and `400 TB`
  figures scannable, while the original has unnecessary whitespace.
- Preparation: deterministic crop `(x=20, y=20, width=560, height=220)`;
  resized 2x with a light unsharp mask. Exact text and numbers were retained.
- Method: deterministic PNG sibling
  `01-data-warehouse-and-bigquery-03-bigquery-cost-cropped.png`.
- Invariants checked: pricing headings, bullets, slot count, dollar amounts,
  and data-volume statement are unchanged; no face, camera tile, cursor, or
  overlay was present.
- Validation: output visually inspected; Markdown reference resolves and
  `git diff --check` passes.
