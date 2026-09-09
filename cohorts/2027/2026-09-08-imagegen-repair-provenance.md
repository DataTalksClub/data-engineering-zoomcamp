# Imagegen repair provenance — 2026-09-08

This ledger records the five screenshot repairs published in the focused
commit for the 2027 data warehouse and batch lessons. Each output was
generated with the built-in imagegen tool from the original non-crisp JPG and
the corresponding bounded crop. Existing crisp targets were used only as
layout/composition references where noted; no enlarged or sharpened derivative
was used as the source of truth.

Native output and a proportional 800px lesson-size render were inspected
before publication. Original JPGs and bounded crops remain preserved.

| Published target | Original source | Bounded crop | Imagegen output | Validation |
|---|---|---|---|---|
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-06-partition-pruning-crisp.png` | `01-data-warehouse-and-bigquery-06-partition-pruning.jpg` | `01-data-warehouse-and-bigquery-06-partition-pruning-cropped.png` | `exec-673d2ac2-db5d-470e-93e5-c0da8abb769f.png` | Blue SQL selection removed; exact query/results composition retained; native and 800px checks passed. |
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-08-cluster-pruning-crisp.png` | `01-data-warehouse-and-bigquery-08-cluster-pruning.jpg` | `01-data-warehouse-and-bigquery-08-cluster-pruning-cropped.png` | `exec-f8570e46-a73f-476b-a948-925bc1f709d0.png` | Blue SQL selection removed; dates, table names, counts, and result row retained; native and 800px checks passed. |
| `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-03-docker-running-crisp.png` | `06-deploying-a-machine-learning-model-03-docker-running.jpg` | `06-deploying-a-machine-learning-model-03-docker-running-cropped.png` | `exec-d0e3136f-450f-4011-8ca9-feeafb84e125.png` | Tight terminal redraw keeps the exact `docker ps` row, ports, and `great_crazy` name; native and 800px checks passed. |
| `cohorts/2027/06-batch/images/05-spark-dataframes-03-built-in-functions-crisp.png` | `05-spark-dataframes-03-built-in-functions.jpg` | `05-spark-dataframes-03-built-in-functions-cropped.png` | `exec-04676e4d-c051-4dfd-9933-7425d3fc6c78.png` | Green active-cell border and webcam/browser artifacts removed; autocomplete and output retained; native and 800px checks passed. |
| `cohorts/2027/06-batch/images/11-operations-on-spark-rdds-06-dag-two-stages-crisp.png` | `11-operations-on-spark-rdds-06-dag-two-stages.jpg` | `11-operations-on-spark-rdds-06-dag-two-stages-cropped.png` | `exec-9b893bf0-b432-44ab-b10a-7b03ab9d8d94.png` | Connector visibly starts at the Stage 30 output node and reaches Stage 31 `partitionBy` with complete margins; native and 800px checks passed. |

The imagegen outputs are stored in the local generated-image directory under
`/home/alexey/.codex/generated_images/01a08261-323e-7721-9a78-009063449c6c/`.

## Follow-up correction after independent review of `04f9c77`

Independent review rejected the two warehouse candidates from the original
batch: the partition-pruning candidate retained a red editor marker and the
wrong `9.4 GB` result, while the cluster-pruning candidate annotated the
clustered query as `864.5 MB`. Both were regenerated with the built-in
imagegen tool from the original JPG and bounded crop. The previous crisp PNG
was supplied only as a layout/composition reference. No enlarged or sharpened
derivative was used as an imagegen source.

The replacement outputs were inspected at native `1672×941` resolution and at
an 800px lesson-size render before copying them over the published paths.
Original JPGs and bounded crops remain unchanged. The new outputs are stored
under `/home/alexey/.codex/generated_images/01a0827f-adb1-7a43-8316-5dbbd14a2493/`.

| Published target | Original JPG source | Bounded crop | Previous published layout reference | Imagegen output | Correction and validation |
|---|---|---|---|---|---|
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-06-partition-pruning-crisp.png` | `01-data-warehouse-and-bigquery-06-partition-pruning.jpg` (`11bcbf8c5cc5afb7945dba804c3bfbb78c8b2d90f6a0a2ca0a2a3c2ffaa3b875`) | `01-data-warehouse-and-bigquery-06-partition-pruning-cropped.png` (`7388943c58f6a1b3e56f747ad4c5d8615b1367958512af55873311e71e3d3c1c`) | Previous PNG (`3069ee3763028ad1945d423326d8829c9267b557f3125a1e327db2b3865ec245`) | `exec-01586364-5aab-4927-aba8-f15067fb3a9d.png` | Removed the red marker; preserved the partitioned table and June 2019 filter; corrected the visible result to `105.9 MB processed` (not `9.4 GB`). Native and 800px checks passed. |
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-08-cluster-pruning-crisp.png` | `01-data-warehouse-and-bigquery-08-cluster-pruning.jpg` (`9e30b6dfe4881a55f9188a144b5d0e50edc25e6e844d847c0aff8d2bb5046aec`) | `01-data-warehouse-and-bigquery-08-cluster-pruning-cropped.png` (`60e175234f7690c56c33a1d5b586bd0ec4180a2f9edad15332a75b5b4faddd5d`) | Previous PNG (`5a87b8362f5234d3dcf9120ad8f66cd2bf3d248aa2ee81ea16dac8b22df836b5`) | `exec-5a660938-2b76-41ff-868b-87dd2f4e57e0.png` | Corrected the annotation to `-- Query scans 843.5 MB` (not `864.5 MB`); preserved the `1.1 GB` estimate, query, table, dates, `VendorID=1`, result count, and `843.5 MB processed` row. Native and 800px checks passed. |

### Follow-up published hashes

| File | SHA-256 |
|---|---|
| `01-data-warehouse-and-bigquery-06-partition-pruning-crisp.png` | `1f67d0c174ba5e2d8235af2b7c124b9a41058d79584296520d067d06a6cf5130` |
| `01-data-warehouse-and-bigquery-08-cluster-pruning-crisp.png` | `0f68a2acc9369537068f066b97091c8556f4dfad5fb532ab9074b5ec830430fa` |

## Published hashes

These hashes make the selected imagegen output auditable after copying it into
the lesson image paths.

| File | SHA-256 |
|---|---|
| `01-data-warehouse-and-bigquery-06-partition-pruning-crisp.png` | `3069ee3763028ad1945d423326d8829c9267b557f3125a1e327db2b3865ec245` |
| `01-data-warehouse-and-bigquery-08-cluster-pruning-crisp.png` | `5a87b8362f5234d3dcf9120ad8f66cd2bf3d248aa2ee81ea16dac8b22df836b5` |
| `06-deploying-a-machine-learning-model-03-docker-running-crisp.png` | `728cfc7d38e569e8db68b8621e501008605ee6261127a2decd1b042583888811` |
| `05-spark-dataframes-03-built-in-functions-crisp.png` | `4d719478c24cb4bce362ecf0ca54e0d162933924299a4991a6dd649e4b624d87` |
| `11-operations-on-spark-rdds-06-dag-two-stages-crisp.png` | `855afc5df9d8ca759534ec1297335e24973532a4fa5ac828043f1e6613655855` |

## Input hashes

| Repair | Original JPG SHA-256 | Bounded crop SHA-256 |
|---|---|---|
| Partition pruning | `11bcbf8c5cc5afb7945dba804c3bfbb78c8b2d90f6a0a2ca0a2a3c2ffaa3b875` | `7388943c58f6a1b3e56f747ad4c5d8615b1367958512af55873311e71e3d3c1c` |
| Cluster pruning | `9e30b6dfe4881a55f9188a144b5d0e50edc25e6e844d847c0aff8d2bb5046aec` | `60e175234f7690c56c33a1d5b586bd0ec4180a2f9edad15332a75b5b4faddd5d` |
| Docker running | `0b0266a6417fc628c06e317b42d4c114c0228667f913bcdf5837198910050998` | `0790349ec4b1994707d4faa3174028766adca031fdb541a08b91fa1577945360` |
| Spark built-in functions | `e446434b8e919d2e3ad53c34939e0cef2ff017fa6f8cb6fd9f3c4e0e422597e0` | `01b1a8bbce7f46b75a8405fd1b718e2d0ae35dcae5d25c4afb46a43c3068cdd2` |
| Spark RDD two-stage DAG | `a248d024dc20af56290836e8697ce8c7b3af950123323ea5012659b56666fabf` | `af5174e5a8e790ca18755d4c1e974e0e3b596b039a925c512d7c633f9c69b4ca` |

## Follow-up correction: Docker output readability

The previous imagegen-only redraw was superseded because exact terminal text
must not depend on generated typography. Imagegen was available and received
both the original JPG and the true native crop below. Its text-free output was
used only as the clean high-resolution terminal background; the final terminal
text was rendered deterministically as vector/text overlay. No resize,
sharpen, or enlarged derivative was used, and no candidate was rejected in
this pass.

The exact retained overlay is:

```text
ok331b4MLT03748:/tmp/model/tip_model$ docker ps
CONTAINER ID    44453cbc5cc3
IMAGE           tensorflow/serving
COMMAND         "/usr/bin/tf_serving..."
CREATED         7 seconds ago
STATUS          Up 5 seconds
PORTS           8501/tcp, 0.0.0.0:8501->8501/tcp,
                :::8501->8501/tcp
NAMES           great_crazy
```

The final `1672×941` PNG and proportional `608×342` lesson-size render were
inspected at 100%; both are readable, with no face, camera, browser/header,
cursor, selection, watermark, or unrelated overlay.

| Artifact | Path | Dimensions | SHA-256 |
|---|---|---:|---|
| Original source JPG | `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-03-docker-running.jpg` | `640×360` | `0b0266a6417fc628c06e317b42d4c114c0228667f913bcdf5837198910050998` |
| True native crop (`x=0,y=0,w=630,h=350`) | `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-03-docker-running-native-crop.png` | `630×350` | `d0e0ac0bdb733cdc4efa5f4221d8c59338648e8fb5054ecf1b0f2bc820084555` |
| Imagegen background-only artifact | `/home/alexey/.codex/generated_images/01a0860c-3c3b-7020-a713-02cef399034e/exec-8b4e51e4-820c-452c-8387-72f9845cfff5.png` | `1672×941` | `07a0f8d2eb989a704d67d1bfcb96e8af6f8d2addd1a3030ced06254a4e8a1e3a` |
| Final published PNG | `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-03-docker-running-crisp.png` | `1672×941` | `409a0b96bbc8c3cd7146db28e2c45a26bab9a37685023e858b778532e0e5fb85` |
| Uncommitted 608px validation render | `final-rgb-608.png` | `608×342` | `653e2fa86eb1fd9605360a7189baa0cfa0ddcfb35f3b7fd62a081575c995e973` |

## Strict follow-up repair — 2026-09-09

The earlier partition-pruning row above is superseded. A strict review found
that the published image still showed the `CREATE OR REPLACE TABLE` step and a
table-replacement result, even though the lesson discusses the cost of the
partitioned `SELECT`. The Dremel row was also repaired because its top query
omitted the table name. The final outputs below were generated from the
original non-crisp JPGs and fresh bounded crops made directly from those JPGs;
the previous published PNGs were layout references only.

The final PNGs were inspected at native size and after proportional rendering
to 608px wide. Both contain C2PA metadata. Crop geometry is recorded so the
input selection is reproducible.

| Published target | Original JPG (SHA-256) | Fresh bounded crop (geometry; SHA-256) | Imagegen output | Final PNG (SHA-256) | C2PA / validation |
|---|---|---|---|---|---|
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-06-partition-pruning-crisp.png` | `01-data-warehouse-and-bigquery-06-partition-pruning.jpg` (`11bcbf8c5cc5afb7945dba804c3bfbb78c8b2d90f6a0a2ca0a2a3c2ffaa3b875`) | `01-data-warehouse-and-bigquery-06-partition-pruning-source-crop.png` (`490x340+150+10`; `995c11cdd288c6d2f8b0161ae43f41b0af0ac25e1f9a3f5b5ec09ce14042f4ec`) | `/home/alexey/.codex/generated_images/01a083d3-1c68-7521-a874-2507255989bc/exec-9f499379-741a-4865-a3b7-4742e38ee68e.png` | `ca53634165d93dfd78d42dec4c6e0ba85aa35fe43965fd71d8db808aeebd904d` | C2PA `urn:c2pa:024fb66e-a92e-4663-a2a8-3d3439e94f46`; shows the partitioned `SELECT`, June 2019 filter, and `105.9 MiB processed`; no table-creation callout. |
| `cohorts/2027/03-data-warehouse/images/04-internals-of-bigquery-03-dremel-tree-imagegen.png` | `04-internals-of-bigquery-03-dremel-tree.jpg` (`37e8124f48499e1f411fa81f807804c357f9e1d7f3da48c72c5d8b9ebcaa88a8`) | `04-internals-of-bigquery-03-dremel-tree-source-crop.png` (`590x345+25+8`; `6f3f6c68f4d03a3ddd47c01bc585d67b4253f9494a10c9fde7d8657c5045224e`) | `/home/alexey/.codex/generated_images/01a083d3-1c68-7521-a874-2507255989bc/exec-06f4ee9e-ba1b-43ac-9723-91ba0ca05f93.png` | `79f8ff3a602471f7fadc5b3fee463171155afc24fbb2e42b876a615e4053c1ee` | C2PA `urn:c2pa:c6b22232-e6e6-40db-b178-61fa7cd3fca0`; top query is exactly `SELECT A, COUNT(B) FROM T GROUP BY A`, with the source topology retained. |

The `02-workflow-orchestration/images/homework-cropped.png` embed was removed
from `homework.md` and replaced by a native Markdown table listing the seven
2021 yellow and green monthly files. It was not regenerated; the source image
remains unmodified and no C2PA claim is made for it.

## Strict follow-up repair — 2026-09-09: deployment prediction screenshots

The strict audit found three defects in the published deployment screenshots:
the model-status response had duplicated/skipped line numbers, and both
prediction requests copied the stale source value `22.2` even though the
current lesson uses `trip_distance: 12.2`; the payment-type-2 response also
had corrupted line numbering. Each replacement was generated with the built-in
imagegen tool from the original non-crisp JPEG and its retained deterministic
crop. Supporting generated layout references were used for the prediction
passes only; no resized or sharpened derivative was used as the source of
truth.

The final PNGs were inspected at native resolution and after proportional
rendering to 608px lesson width. The status response has a complete numbered
JSON block from 1 through 14. Both prediction request editors have numbered
lines 1 and 2, use the lesson-authoritative `12.2`, and retain their original
response values; both response panels have consecutive line numbers 1 through
7. All three outputs contain C2PA metadata.

| Published target | Original JPG (SHA-256) | Deterministic crop (SHA-256) | Imagegen output | Final PNG (SHA-256) | C2PA / validation |
|---|---|---|---|---|---|
| `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-04-model-status-crisp.png` | `06-deploying-a-machine-learning-model-04-model-status.jpg` (`5ce611080efdc428384a0385a66fc058c6144205b677ca3c4801aca2b5e89dd2`) | `06-deploying-a-machine-learning-model-04-model-status-cropped.png` (`585ac58fcf28ff801dedf6855604963e0c8f6756d68a9d26bbb215dc11362f79`) | `/home/alexey/.codex/generated_images/01a083d3-42e1-7b11-8381-2eb4b4ba6920/exec-cf18e4f0-e6fa-4cfc-9ff4-c1d388652389.png` | `bce2b64a77f7794732233a3b75ac28f1b7251b36d473cdc3a00d42887277cb2c` | C2PA `urn:c2pa:478b5a8f-eb36-412f-a7e7-18364d9f6f77`; exact `AVAILABLE` response retained; gutter 1–14; native `1694×929` and 608px checks passed. |
| `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-05-predict-crisp.png` | `06-deploying-a-machine-learning-model-05-predict.jpg` (`c92bf5a12d3a87e4b91c8ebc694710b5e094e1f011dee37002d91a9c9397b4c8`) | `06-deploying-a-machine-learning-model-05-predict-cropped.png` (`8dcf32c3e95d2000e629485440adbb592ec2596869167f03fc1cb0a9c4647199`) | `/home/alexey/.codex/generated_images/01a083d3-42e1-7b11-8381-2eb4b4ba6920/exec-8328b032-8417-45c2-b6c9-9ca9ad9f6869.png` | `1425481effd7b53f6fbfebf5c1a4e0162e088fe191408567ee43849e7a39a2eb` | C2PA `urn:c2pa:af4c3ea5-b7e7-4431-b189-9457168e3300`; request corrected to lesson `12.2`, response `3.2106109757442027` retained; request/response gutters consecutive; native `1693×929` and 608px checks passed. |
| `cohorts/2027/03-data-warehouse/images/06-deploying-a-machine-learning-model-06-predict-payment-type-2-crisp.png` | `06-deploying-a-machine-learning-model-06-predict-payment-type-2.jpg` (`9bd2719d206afa8f92885e189bac067e3b62bdcb7454b80217ff044b48730b06`) | `06-deploying-a-machine-learning-model-06-predict-payment-type-2-cropped.png` (`084452f462faf00917480ac19da742f28df0e2b22cb27fc28d96abdac6c20484`) | `/home/alexey/.codex/generated_images/01a083d3-42e1-7b11-8381-2eb4b4ba6920/exec-7943939f-e07a-400d-8008-a6905b3b4297.png` | `a46b6ebb6cc85986e7ae4eb4598545563ca9be488ce9ca5aa0d55ffc67e41fef` | C2PA `urn:c2pa:4e5cdb45-bf73-4945-a074-08310022e18a`; request corrected to lesson `12.2` with `payment_type: 2`, response `0.25916742680327297` retained; request/response gutters consecutive; native `1695×928` and 608px checks passed. |

## Native-crop conceptual repairs — 2026-09-09 checkpoint

This focused checkpoint repairs only the three conceptual warehouse diagrams
that were active in the independent review. Each native crop was made directly
from its original 640×360 non-crisp JPG with ImageMagick `-crop`; no legacy
2× crop, published crisp PNG, resize, Lanczos filter, or sharpened derivative
was used as an input. The built-in imagegen tool received the original JPG and
the corresponding native crop as its only image references. The artifact was
copied byte-for-byte to the existing published path. The existing accepted
01-06 partition-pruning and 04-03 Dremel-tree outputs were not changed.

| Published target | Original JPG (SHA-256) | Fresh native crop (geometry; dimensions; SHA-256) | Imagegen artifact (path; SHA-256) | Published output (SHA-256; equality) | C2PA / semantic, overlay, and size validation |
|---|---|---|---|---|---|
| `cohorts/2027/03-data-warehouse/images/01-data-warehouse-and-bigquery-02-data-warehouse-diagram-imagegen.png` | `01-data-warehouse-and-bigquery-02-data-warehouse-diagram.jpg` (`8e3a538589dad35ca3a3955df2f9d8a46701b82b3ca8d12ab16e0c3f8313c478`) | `x=155,y=145,w=340,h=180`; `340×180`; `997d6ce1b2e07b5e6fe2d7bdb8d6cb84ef662fcd3e4c4227ba5f4cc1af7c5ea2` | `/home/alexey/.codex/generated_images/01a08536-1199-7450-9856-bbb2c7bc42a1/exec-77552cc7-8391-4237-9780-2c0caca80b3e.png` (`8e3ee7a58e88b6affd24c7f0b8af7276dbc7b9bc1b929b3f7f6f314158eabbca`) | `8e3ee7a58e88b6affd24c7f0b8af7276dbc7b9bc1b929b3f7f6f314158eabbca`; byte-identical to artifact | C2PA `urn:c2pa:ba85d49d-b9cb-4c20-9ff6-e1f16932f07a`; native `1918×820`, validation `608×260`; Data Sources → Staging area → Warehouse → Data Marts → Users topology and labels retained; no face, camera, cursor, browser chrome, watermark, or overlay. |
| `cohorts/2027/03-data-warehouse/images/04-internals-of-bigquery-01-architecture-imagegen.png` | `04-internals-of-bigquery-01-architecture.jpg` (`42738dd464d64ba766ff8d24b575d3caf24ba8ba739ef73d268c4fb51a5550c0`) | `x=175,y=33,w=320,h=298`; `320×298`; `35f5838813c0e14bf07959008f37f28146cb1b5482c0656bbed4fbf981590f77` | `/home/alexey/.codex/generated_images/01a08536-1199-7450-9856-bbb2c7bc42a1/exec-110e83a9-0e30-4ce5-bffb-4f2413a47362.png` (`da42d2fb220d2d8a74818ead537cc748b52ae679d45076a1a7f8a093f6a84514`) | `da42d2fb220d2d8a74818ead537cc748b52ae679d45076a1a7f8a093f6a84514`; byte-identical to artifact | C2PA `urn:c2pa:629ff191-2dfc-45e5-8518-4415d7670efb`; native `1532×1027`, validation `608×408`; Clients, Client Interface, Borg, Dremel query tree, Jupiter, and Colossus topology retained; no face, camera, cursor, browser chrome, watermark, or overlay. |
| `cohorts/2027/03-data-warehouse/images/04-internals-of-bigquery-02-columnar-storage-imagegen.png` | `04-internals-of-bigquery-02-columnar-storage.jpg` (`725b644562ea3daf9230e9bbe16a12bc44c39b01e205a752525137dabbecc9f7`) | `x=90,y=80,w=460,h=250`; `460×250`; `fe579ccf0e34bc98e5dff4a245f569c300c20c108916298cae2943520101ba8e` | `/home/alexey/.codex/generated_images/01a08536-1199-7450-9856-bbb2c7bc42a1/exec-5361c699-dfdf-4b0d-80d1-0640d8aa0726.png` (`961b3731882c7fc66bb93d8ce1007eb259ba34ef6c182ff2d2c76c2f15ba91da`) | `961b3731882c7fc66bb93d8ce1007eb259ba34ef6c182ff2d2c76c2f15ba91da`; byte-identical to artifact | C2PA `urn:c2pa:2e7d60c6-8e7a-4ab5-965c-b8ab996714ea`; native `1701×925`, validation `608×331`; r1/r2 rows, A–E tree, ellipses, separated colored columns, and record-/column-oriented labels retained; no face, camera, cursor, browser chrome, watermark, or overlay. |

The three crop commands were rerun independently and matched the retained
crops at zero differing pixels (PNG metadata timestamps may differ); all three
608px renders were visually inspected and remained readable. The three
published outputs were also compared byte-for-byte with their generated
artifacts. Remaining warehouse repairs are intentionally deferred to the next
checkpoint.
