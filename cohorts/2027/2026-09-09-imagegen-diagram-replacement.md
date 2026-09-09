# Imagegen diagram replacement — 2026-09-09

All 45 raster illustrations that were generated with an image model
(`*-imagegen.png`) and referenced by the DE 2027 lessons were audited and
confirmed to be diagrams (flows, hierarchies, timelines, architectures,
decision trees) rather than photos or decorative art. They were re-created as
deterministic SVG diagrams with the `diagram-creator` skill and published as
2x PNGs rendered with Chromium. Every published diagram was checked by an
independent reviewer agent against the teaching point of the figure.

For every figure the repo now keeps the editable JSON spec, the SVG source,
and the published PNG side by side in the lesson's `images/` directory:

```
<figure>.json   diagram-creator spec (edit this to change the diagram)
<figure>.svg    deterministic render of the spec
<figure>.png    2x Chromium render referenced by the lesson markdown
```

## Replaced figures

| Module | Lesson | New asset (`.json`/`.svg`/`.png`) |
| --- | --- | --- |
| 2024 workshop | dlt_resources | `incremental_loading` |
| 01 docker-terraform | 01-introduction | `docker-volume-mapping` |
| 01 docker-terraform | 12-terraform-overview | `terraform-provider-flow` |
| 01 docker-terraform | 13-gcp-overview | `cloud-service-families` |
| 03 data-warehouse | 01-data-warehouse-and-bigquery | `01-data-warehouse-and-bigquery-02-data-warehouse-diagram` |
| 03 data-warehouse | 04-internals-of-bigquery | `04-internals-of-bigquery-01-architecture` |
| 03 data-warehouse | 04-internals-of-bigquery | `04-internals-of-bigquery-02-columnar-storage` |
| 03 data-warehouse | 04-internals-of-bigquery | `04-internals-of-bigquery-03-dremel-tree` |
| 04 analytics-engineering | 01-analytics-engineering-basics | `analytics-engineering-toolchain` |
| 04 analytics-engineering | 02-what-is-dbt | `dbt-model-warehouse-flow` |
| 04 analytics-engineering | 08-documentation | `dbt-lineage-graph` |
| 05 data-platforms | 03-nyc-taxi-pipeline | `bruin-pipeline-lineage` |
| 05 data-platforms | 06-core-concepts-projects | `bruin-project-structure` |
| 05 data-platforms | 07-core-concepts-pipelines | `bruin-project-pipelines`, `bruin-pipeline-configuration` |
| 05 data-platforms | 08-core-concepts-assets | `bruin-asset-lineage` |
| 05 data-platforms | 10-core-concepts-commands | `bruin-project-command-hierarchy` |
| 06 batch | 01-introduction-to-batch-processing | `01-...-01-batch-vs-streaming`, `01-...-02-streaming-example`, `01-...-07-batch-vs-streaming-share` |
| 06 batch | 02-introduction-to-spark | `02-...-02-data-processing-engine-whiteboard-redraw`, `02-...-03-when-to-use-spark-whiteboard-redraw`, `02-...-04-typical-workflow-whiteboard` |
| 06 batch | 04-first-look-at-spark | `04-first-look-at-spark-04-partitions-slides` |
| 06 batch | 08-anatomy-of-a-spark-cluster | `08-...-01-spark-submit-master`, `08-...-02-executors-failure`, `08-...-03-executors-pull-partitions`, `08-...-04-s3-gcs-instead-of-hdfs` |
| 06 batch | 09-groupby-in-spark | `09-groupby-in-spark-03-reshuffling-whiteboard` |
| 06 batch | 11-operations-on-spark-rdds | `11-operations-on-spark-rdds-02-map-key-value-whiteboard` |
| 06 batch | 12-spark-rdd-mappartition | `12-spark-rdd-mappartition-01-map-partitions-diagram` |
| 07 streaming | theory/README | `07-stream-processing-two-topic-flow`, `07-kafka-event-fanout-to-partitions`, `07-kafka-notice-board-topics`, `07-kafka-replication`, `07-kafka-retention-window`, `07-kafka-partitions-to-nodes`, `07-kafka-consumer-group-partition-assignment`, `07-kafka-key-count-flow`, `07-kafka-testing-topology`, `07-kafka-global-ktable-replication`, `07-kafka-stream-join-window`, `07-kafka-tumbling-window-timeline`, `07-kafka-schema-registry-flow`, `07-kafka-schema-forward-compatibility` |

## Removed artifacts

With the referenced `*-imagegen.png` files replaced, the remaining
unreferenced `*-imagegen-crop.png` / `*-imagegen-redraw.png` intermediates
(screenshot crops and redraw variants kept from earlier repair passes) were
removed as well. The pre-imagegen audit documents above retain their
historical record; the SHA-256 tables in them refer to the removed raster
assets.

## Regenerating a diagram

```bash
cd /home/alexey/git/diagram-creator
uv run diagram-creator <images-dir>/<figure>.json <images-dir>/<figure>.svg
```

Then re-publish the 2x PNG and update the markdown reference in one step:

```bash
python skills/diagram-creator/scripts/publish_svgs.py --scale 2 <lesson>.md
```
