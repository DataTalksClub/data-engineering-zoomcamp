# 06-batch illustration follow-up provenance — 2026-09-09

This ledger records the strict follow-up repairs for the 06-batch
illustrations. Each imagegen repair uses the original non-crisp JPG as the
factual source and a bounded crop as the composition/detail reference. The
published output is inspected at native resolution and at a proportional
608px-wide lesson render before it is committed. Originals and crops remain
preserved. The crop coordinates below are measured in the original `640×360`
frame; the tracked crop hash is the authoritative byte-level reference.

## Authoritative current-ref audit — lessons 11–15

After the independent audit result was available, the live Markdown image
references in lessons 11–15 were re-enumerated. There are eight current
references: two in lesson 11, one in lesson 12, none in lesson 13, two in
lesson 14, and three in lesson 15. The four outputs marked **kept** below
were already proven imagegen outputs and were left byte-for-byte unchanged.
The four outputs marked **regenerated** had either a deterministic
resize/sharpen derivative or a non-native retained crop in their prior
history, so each was regenerated from its original non-crisp JPG plus the
fresh native bounded crop shown below. The older processed crops remain
preserved as historical evidence and are not imagegen inputs.

| Live published ref | Disposition | Original JPG (SHA-256) | Native bounded crop (geometry; SHA-256) | Imagegen artifact / published output (SHA-256) | C2PA / validation |
|---|---|---|---|---|---|
| `images/11-operations-on-spark-rdds-02-map-key-value-whiteboard-imagegen.png` | kept — proven output unchanged | `61271e3361f77bd04eaefe44c4102d273c18fb7b0d375df72c6fdeb55836e1a8` | `x=37,y=0,w=465,h=340`; `c2930292eb4311141e1a91a5c1075b9cd5bddb54882d265e9fc3cd3e5cde3110` | `/home/alexey/.codex/generated_images/01a07ea3-b076-7290-bbd7-a10ef2cbb11f/exec-4990ab34-0718-4637-8e06-762d99fc6aae.png`; `daae0a1dbfb04c8930edad0fea7531a2146532d5576f634d63f4dc4b121b1ba0` | `urn:c2pa:853eb46d-4d04-4d2d-90d3-652a3713407c`; native `1667×943`, 608px `608×344`; exact `RDD`, `Row`, `map`, `(H, Z)`, `(AMT, CNT)`, arrows, and grouping semantics retained; no face/camera/toolbar/browser/cursor overlay. |
| `images/11-operations-on-spark-rdds-06-dag-two-stages-crisp.png` | regenerated from original + native crop | `a248d024dc20af56290836e8697ce8c7b3af950123323ea5012659b56666fabf` | `x=0,y=28,w=480,h=300`; `4b1c48456aedcb774b203369e36958c70e464291d6c3547bc2c666f1f094dee4` | `/home/alexey/.codex/generated_images/01a08481-68d1-7250-9be5-0e0d56a74eed/exec-e7bffc9c-d6ce-4279-b989-d122844f5b5c.png`; `0f42f80efc98dde09b1d9bbb99f64567950c589ea871af6bcebca127ac7d8572` | `urn:c2pa:1cf8efa6-f942-43ce-863c-ffff6b760a79`; byte-identical published/artifact; native `1586×992`, 608px `608×380`; exact Stage 30/31 labels, both `mapPartitions` nodes, all arrows, and full bottom map node retained; no face/camera/browser/editor/cursor/play/selection overlay. |
| `images/12-spark-rdd-mappartition-01-map-partitions-diagram-imagegen.png` | kept — proven output unchanged | `7db8b45581bcdda460a273ef9f0f5ba5b128a8e9b44f323250169902cb3fb106` | `x=37,y=0,w=465,h=340`; `b4eacca11cc92bf35c464c7f98dce8924492f4284d01f8ff9a32a5d6b573c075` | `/home/alexey/.codex/generated_images/01a08324-9092-7f41-b36b-4be7f604bada/exec-9ac431f6-bbc4-473f-9471-9ec224466957.png`; `70f194fe755ec4450a9b9ce85944f770ce7522a79cf086b15b97ad5aa7bacbe8` | `urn:c2pa:11d620fd-952b-4a14-b797-ce102a1c2f06`; native `1774×887`, 608px `608×304`; exact `RDD`, `Partition`, `mapPartitions`, `1TB`, and arrows retained; no face/camera/toolbar/browser/cursor overlay. |
| `images/14-creating-a-local-spark-cluster-01-spark-master-ui-crisp.png` | regenerated from original + native crop | `acbe938fb541ae8322b9e3bcb9c64663a811a121914f3e071393b35dec38978d` | `x=0,y=30,w=640,h=105`; `7687753cded06fad619191a34998275383fc27f017f92adf4057982d9fe5bc9c` | `/home/alexey/.codex/generated_images/01a08481-68d1-7250-9be5-0e0d56a74eed/exec-93867794-7809-468d-849a-cf0d0af6f1ce.png`; `0040b1fcc345cb9290d9715f849ae14778486b7aaef6925857ee4abe8ce736a5` | `urn:c2pa:9f5fb88b-b746-4ec6-8467-ff97ec05070a`; byte-identical published/artifact; native `1991×790`, 608px `608×241`; exact Spark `3.0.3`, master URL, zero counts, `ALIVE`, and empty table headers retained; no face/camera/browser/editor/cursor/play/selection overlay. |
| `images/14-creating-a-local-spark-cluster-02-worker-registered-crisp.png` | regenerated from original + native crop | `ebbf95dd6eaf2196d9069f3360303004886952231b15e1edb6364c9fba97c106` | `x=0,y=30,w=640,h=160`; `7048812f2712535051393fa66d2cfc412dc86c4a30cefa2134c2f538bfc19393` | `/home/alexey/.codex/generated_images/01a08481-68d1-7250-9be5-0e0d56a74eed/exec-c47fe6e4-538d-45bc-adb5-beb26015c03b.png`; `e817cd6e56a82ff8e2867ddbcc0a4fa3effdc956ead76f5786f7b88342ccdfe6` | `urn:c2pa:48cd3d0a-7d54-49d2-b76c-ddb50bf5a0b0`; byte-identical published/artifact; native `1774×887`, 608px `608×304`; exact worker ID/address, `ALIVE`, resource values, application IDs, timestamps, states, and table headers retained; no face/camera/browser/editor/cursor/play/selection overlay. |
| `images/15-setting-up-a-dataproc-cluster-01-create-cluster-crisp.png` | kept — proven output unchanged | `bcbc1727edf57f8792b975af2b6206c7058928299c32873ad04069ce04092876` | `x=0,y=30,w=535,h=330`; `7cca0e94be7edacb547c04f974188958589905f26e3c7e09bf655c21c6c96ef1` | `/home/alexey/.codex/generated_images/01a0836e-71b4-7e51-81c7-c5b905ca6493/exec-64b34174-22aa-4a10-b641-ab7c83a96f31.png`; `cd7e76b3b1c8bf24bd9cf3cecfbadb66b79e26942e4bbc63c88fbf9e9d50863f` | `urn:c2pa:124a9367-e097-4131-8a7f-577c8a048c6e`; native `1598×984`, 608px `608×374`; exact Dataproc labels, project, Jupyter/Docker selections, and controls retained; no face/camera/browser/cursor overlay. |
| `images/15-setting-up-a-dataproc-cluster-02-submit-job-form-crisp.png` | regenerated from original + native crop | `2dc190d5becb85faa1528065388e2f87300d7fb1f46c9de14d16fec17e037ef0` | `x=280,y=95,w=360,h=265`; `a26f1a72f3fc5ad78765186d5e552da4f3de4eb220d7380f67292405aa6b7538` | `/home/alexey/.codex/generated_images/01a08481-68d1-7250-9be5-0e0d56a74eed/exec-dfc80e47-8567-4283-a756-c3bbbd402eb0.png`; `ef5572be340409c8e4a9a63fd79cb23c6ff7b24b539f7f7654609c8d50851ec3` | `urn:c2pa:7f811570-2045-4ce8-8e9d-4f4134193c0b`; byte-identical published/artifact; native `1630×965`, 608px `608×360`; exact PySpark path, all three 2021 bucket arguments/wildcards, restart placeholder, and Properties control retained; no face/camera/browser/editor/cursor/play/selection overlay. |
| `images/15-setting-up-a-dataproc-cluster-05-reports-in-bucket-crisp.png` | kept — proven output unchanged | `01a1cc28707c611321086bfd4de3be9db38cbf0b6ad74ec32ef8bc953f459cf6` | `x=0,y=30,w=535,h=330`; `c5812061eddc30c2e933e501445c53f79f13a92e201b3d67b9e7e226e811cffb` | `/home/alexey/.codex/generated_images/01a07b59-81f1-7ad0-8caf-684763eaf05e/exec-3511bef5-af63-4b99-b8a9-ed679d96d569.png`; `0458cb6048aec80f359e4dfe5fe99f9f8b348e97d13ef1564525f2b59ccd21b5` | `urn:c2pa:55ad7e30-1210-4d98-85e3-8f23723d1751`; native `1672×941`, 608px `608×342`; exact bucket name, `code/`, `pq/`, `report-2020/`, and `report-2021/` rows retained; no face/camera/browser/cursor overlay. |

All new crops above were extracted from the native `640×360` JPGs with
ImageMagick `6.9.12-98 Q16 x86_64 18038` using `-crop`, `+repage`, `-strip`,
and `-define png:exclude-chunk=tIME`; none was resized or sharpened before
imagegen. The regenerated published PNGs were copied byte-for-byte from the
listed imagegen artifacts. The 608px renders are validation-only outputs
under `/tmp/de-batch-11-15-608/`, made with `convert <published.png>
-resize '608x608>'`; no published output was derived from a resize,
Lanczos, or sharpening step.

## Lessons 01–05 — remaining provenance-blocked outputs

The independent audit identified exactly these 13 active lesson references
without a durable original non-crisp JPG -> native bounded crop -> imagegen
output chain. They were regenerated from the original JPG and the retained
native crop, then copied byte-for-byte into the published target. No resize,
Lanczos, sharpening, or post-generation text edit was used. Native output and
proportional 608px-wide renders were inspected. The crop geometry is measured
in each original 640×360 frame.

| Published target | Original JPG SHA-256 | Native crop (geometry; SHA-256) | Imagegen artifact (path; SHA-256) | Published output SHA-256 | C2PA / validation |
|---|---|---|---|---|---|
| images/01-introduction-to-batch-processing-01-batch-vs-streaming-imagegen.png | ce1698c1674a2c2580d71ce72f7201409214bc3e383670215f58bdba461d7ffd | x=37,y=0,w=465,h=340; b2f838d1a30858d1dedf291e4528dcdc4f52732d357eb3ed2e50a71303c90d92 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-c87aa3dd-706c-4def-87f6-08b4a078f5ae.png; 9ef8e5c5efc53b7f7177aa9e5418cabb82f9b895cf8c2af4c76bda7e95cd36d3 | 9ef8e5c5efc53b7f7177aa9e5418cabb82f9b895cf8c2af4c76bda7e95cd36d3 | urn:c2pa:f1f6de13-1db3-4987-9b4e-feb42a2df0ff; native 1672×941, 608px 608×342. Exact PROCESSING DATA, BATCH, STREAMING, Jan 15, JOB, storage cylinder, week 6, timing notes, and arrow directions retained; the source-faithful STREAMING area remains empty and no unsupported RIDE.STARTS/PROCESSOR labels were added; no capture artifacts. |
| images/01-introduction-to-batch-processing-02-streaming-example-imagegen.png | 94e05e7f2b0ea09180d4800a9c4255fac206d52b331e14574714b05c5fa0e940 | x=37,y=0,w=465,h=340; 5e2e7c6a37eca5eaa51bc2113ae12a34282b382dbeb859dd10c001fca87d2802 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-3e50df9f-4a82-49ab-ad5e-3ad0340947c1.png; 62adcaeb2244ee1b7ca8304c1ea8ceedb26b4864c528418c92d59c56ddc4f14b | 62adcaeb2244ee1b7ca8304c1ea8ceedb26b4864c528418c92d59c56ddc4f14b | urn:c2pa:d0d5719c-3694-46b6-9956-12ed5d7e154f; native 1466×1073, 608px 608×445. Exact RIDE.STARTS -> stream -> PROCESSOR -> output-stream flow retained; the picture/camera icon and stick-person capture artifact were removed. |
| images/01-introduction-to-batch-processing-07-batch-vs-streaming-share-imagegen.png | be235d8cf87a717187030a1f436c76fc19410588a42e49c92ecb77be815993f3 | x=37,y=0,w=465,h=340; d051ca78f5209689d28ceda5fc019f1bfec7e0649e14090da1c8a873ebbfbb5f | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-c091aab1-758e-405c-bb70-c90bfb1c6af0.png; 5e33dd23040d15c2dd639fe27d7aada91223af2b4c3883b2fa88758984e6bafc | 5e33dd23040d15c2dd639fe27d7aada91223af2b4c3883b2fa88758984e6bafc | urn:c2pa:cddc3a57-6a21-45ad-bd1e-674e34b00aaa; native 1672×941, 608px 608×342. Exact 80%, 20%, PROCESSING DATA, BATCH, STREAMING, Jan 15, JOB, and timing notes retained with source arrow directions. |
| images/02-introduction-to-spark-02-data-processing-engine-whiteboard-redraw-imagegen.png | 38bcc26ca72eb12d1ca0d63bf307c83da9283dcd85143ce47912a7951c0176b7 | x=37,y=0,w=465,h=340; 37889efb69945d86a8e43b588aa881df836b40b0798e6eb907626a20a872ab34 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-840ec486-a900-40e8-9c2b-70b1efc72f1c.png; f61a9af49180b3de596a7b66fd4877c69b5baa2ad1116e971284584239f4f8fe | f61a9af49180b3de596a7b66fd4877c69b5baa2ad1116e971284584239f4f8fe | urn:c2pa:849b82db-d26d-4ad4-910c-b360a9d3dbe4; native 1672×941, 608px 608×342. Exact APACHE SPARK, DATA PROCESSING ENGINE, CLUSTER, SPARK, JAVA & SCALA, PYTHON, R, PYSPARK, and input/output arrows retained. |
| images/02-introduction-to-spark-03-when-to-use-spark-whiteboard-redraw-imagegen.png | 727c53b1a10725ba5a44509da67498d12a9f7bbd56c98aae2f74f1fa84dfd2e5 | x=37,y=0,w=465,h=340; ed8e2d5bc3d223f94327ea19b4851c4d20fd98995b7a75cf08cfac15b6c8c064 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-05c20f94-1f48-4ee1-b6ed-73954f521f75.png; ecfe02adc1c788d092c2f6ddb78e5727cc5625987c8ee58c49c93867eb190e41 | ecfe02adc1c788d092c2f6ddb78e5727cc5625987c8ee58c49c93867eb190e41 | urn:c2pa:53dae269-3aec-4649-a30b-ca7d84fbff97; native 1672×941, 608px 608×342. Both DL -> SPARK -> DL and DL -> SQL/HIVE / PRESTO / ATHENA -> DL routes, exact product labels, and callout text retained. |
| images/03-installing-spark-01-install-guide-java-crisp.png | ee58fa69eedf5fd6ce60f64c2af7073efa4da26d83da0b8b512d60faf4fdf878 | x=20,y=205,w=465,h=145; bdca1664d634b0c428a8e01a687b9feafa205f923189ba131bc900ab9f617f22 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-f945962d-928e-4aec-b585-4ef1232c2936.png; 08fc268b22e1ebcc525f45017a45912361a41185f6f07c773cf6118d37777d3c | 08fc268b22e1ebcc525f45017a45912361a41185f6f07c773cf6118d37777d3c | urn:c2pa:22cb1759-cdac-4dbd-a24c-ad9f66d2367f; native 2172×724, 608px 608×203. Exact Linux, Spark 3.0.3, Ubuntu 20.04, WSL, Java 11, OpenJDK, Oracle JDK, and 8 or 11 text retained; browser/webcam removed. |
| images/03-installing-spark-02-java-home-crisp.png | 9497042cd419adc96ac19b744a195a5a3322064f50f9d664ea478bc87dfddee5 | x=20,y=32,w=480,h=300; c04eb90699ef389f8468def07df99dfafd49c4d84d1325d6b7f5094ab2506048 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-0f56d45f-20e0-4f8a-bb67-151728d5a83f.png; 9f17ed6a945d8a15d1e7e305acd8cc291113632a8d9ec0058ab964529896bd9a | 9f17ed6a945d8a15d1e7e305acd8cc291113632a8d9ec0058ab964529896bd9a | urn:c2pa:2f085951-a66d-41eb-949c-56cb06560adb; native 1586×992, 608px 608×380. Exact JDK filenames, rm openjdk-11.0.1_linux-x64_bin.tar.gz, /home/alexey/spark, and export JAVA_HOME="\${HOME}/spark/jdk-11.0.1" retained; terminal capture artifacts removed. |
| images/03-installing-spark-03-spark-download-page-crisp.png | 170b251305f1c446354850822f9afefe1b4be733d7af7d6e0efcf7bae5f450fe | x=0,y=28,w=490,h=305; 40baf74260778bef34c0472128c47af075f28b561a4c0d0e6661daeb121d3965 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-0c63f43d-a184-4685-bd3d-9283ba63ca11.png; 524fc8a90e8d09097074341cda0e3558f4fa15c4e3bf1e7b3152e1de71419577 | 524fc8a90e8d09097074341cda0e3558f4fa15c4e3bf1e7b3152e1de71419577 | urn:c2pa:114f1010-cf56-4ff9-b977-33d118b6f6b2; native 1590×989, 608px 608×378. Exact Spark 3.0.3 selector, Hadoop 3.2 and later selector, archive filename, Scala versions, Maven coordinates, and release dates retained. |
| images/03-installing-spark-04-spark-home-crisp.png | 2a97f308c7762f6f47565a9a4531c8e41dcde7ed8dfadf1886d89c51459bce62 | x=20,y=32,w=480,h=300; 1296343ef87d6f6280ece5dc7582dcc30ff9fd3be4ca14598274da944a2d13b9 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-9f844319-565d-4a2a-998b-6a97977240d5.png; 1ff41d46648096525015fe3c9b58b56d49295eb33c9103d999354c686ad0c46b | 1ff41d46648096525015fe3c9b58b56d49295eb33c9103d999354c686ad0c46b | urn:c2pa:9d98781d-46a6-464f-b923-4bb779cef68d; native 1672×941, 608px 608×342. Exact license filenames, Spark 3.0.3 directory/archive names, directory-removal error, archive removal, and SPARK_HOME command retained. |
| images/03-installing-spark-05-spark-shell-crisp.png | 13a70c79f3eb930fe65579ea85ad12173157f57e3f674cdd981886ba241ab847 | x=20,y=32,w=480,h=300; a556913a8a2ecb0c246dde65b4dfb02e328cc9c5acf6d5084f62937fe952d165 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-21c5825a-e059-46dc-8639-68aeb8284668.png; 3779b89f08b32264332459a9ebf96b398a153b5f2a47400708f0f4dc83cf7933 | 3779b89f08b32264332459a9ebf96b398a153b5f2a47400708f0f4dc83cf7933 | urn:c2pa:0af80a1e-b57f-408c-af82-4c9a8dda798c; native 1586×992, 608px 608×380. Exact Spark 3.0.3, Scala 2.12.10, Java 11.0.1, 10000, <console>:26, and result Array(1, 2, 3, 4, 5, 6, 7, 8, 9) retained. |
| images/04-first-look-at-spark-03-schema-structtype-crisp.png | 93fdd5fe675c6c20b3362b8c7b5616e633076a0adc087bfb49fdbb68808c9ab2 | x=45,y=28,w=455,h=300; 27b60226e62ab1a502793c4c82ee587813bc6b97977a82edcd079783988052d3 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-d4aefbfa-8ea6-4e34-8dc6-bdb8a03de086.png; dc2904449fca48f256cf96907890d8652de331f7287fb06c843474cd656abdb8 | dc2904449fca48f256cf96907890d8652de331f7287fb06c843474cd656abdb8 | urn:c2pa:64a12aa3-412c-4d8f-9d36-402dbcd71f98; native 1672×941, 608px 608×342. Exact source code tokens, field names, StringType, LongType, DoubleType, true, commas, and brackets retained; editor/selection/webcam removed. |
| images/05-spark-dataframes-01-print-schema-crisp.png | 5993b050d91c10b83dda3885b5c6a558f6e8ac296646d9a7f229be55bc44dc93 | x=22,y=30,w=465,h=300; b6e9d3d23b7aab1a97c22e47a640181ebef4bb06f8f3039ce5c6eada0de8db35 | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-30caec6a-e2b6-481d-9ab3-0ee628285465.png; 5e3060264afd64197c0090d9cac4f5903e8e79e7655bb4d316bdfc3cc09f8664 | 5e3060264afd64197c0090d9cac4f5903e8e79e7655bb4d316bdfc3cc09f8664 | urn:c2pa:ac4ceed7-0d58-45b8-b3b1-131b57abb6e5; native 1900×828, 608px 608×265. Exact repartition(24), parquet path, printSchema(), seven FHV fields/types, and nullable = true output retained without blue selection. |
| images/05-spark-dataframes-02-select-crisp.png | 163bac58c4c2bcf44476366e3e2ef61e81f90afb0ff7d1d09caa8bb289885421 | x=22,y=30,w=465,h=300; 0593590b1108d018c00e18a98610b83e27d6a50a6e0fc7c64f171665a83c513f | /home/alexey/.codex/generated_images/01a0847b-121d-7733-a325-694481d71c06/exec-371fe62a-5341-42e2-adc7-9ea8b1fba594.png; 75655b819c2a8416b1450e3b20c8dd71bc1382246d5b1e67e56ab32c0a94a996 | 75655b819c2a8416b1450e3b20c8dd71bc1382246d5b1e67e56ab32c0a94a996 | urn:c2pa:47a668c3-9bdd-49ad-8042-18ef9c38cd0a; native 1561×1007, 608px 608×392. Exact parquet path, schema, four selected columns, cell numbers 44/48/49, and DataFrame[...] type summary retained without selection/browser/webcam artifacts. |

The crop files above were created with ImageMagick 6.9.12-98 Q16 x86_64
18038 using crop-only commands of this form:

    convert <original.jpg> -crop <width>x<height>+<x>+<y> +repage -strip \
      -define png:exclude-chunk=tIME <target-imagegen-crop.png>

## Strict semantic correction — explicit schema after review of `73be7e2`

Independent review of commit `73be7e2` found that the lesson-04 schema output
above was semantically wrong: it reproduced the inferred `StringType`,
`LongType`, and `DoubleType` example from the source frame instead of the
explicit schema taught by the live lesson. The prior row remains as historical
provenance, but its published output is superseded by the correction below.

The replacement was generated with the built-in imagegen tool from the
original JPG and the retained native crop. The live source of truth is
`04-first-look-at-spark.md` lines 109–123: `TimestampType` for both datetime
fields, `IntegerType` for both location IDs, and `StringType` for
`hvfhs_license_num`, `dispatching_base_num`, and `SR_Flag`, with the exact
`types.StructType` / `types.StructField` code block. The previous crisp PNG was
not supplied as an imagegen input. No resize, sharpening, or post-generation
text edit was used; the generated artifact was copied byte-for-byte into the
published target. Native output and a proportional 608px-wide lesson render
were inspected. No webcam, editor/browser chrome, cursor, line-number gutter,
selection, status-bar, or other overlay remains.

| Published target | Original JPG SHA-256 | Retained native crop (geometry; SHA-256) | Imagegen artifact (path; SHA-256) | Published output SHA-256 | C2PA / validation |
|---|---|---|---|---|---|
| `images/04-first-look-at-spark-03-schema-structtype-crisp.png` | `93fdd5fe675c6c20b3362b8c7b5616e633076a0adc087bfb49fdbb68808c9ab2` | `x=45,y=28,w=455,h=300`; `27b60226e62ab1a502793c4c82ee587813bc6b97977a82edcd079783988052d3` | `/home/alexey/.codex/generated_images/01a084bb-4abf-70d1-baab-5bd6cc148624/exec-adf77ecb-2a8f-4c40-a569-04d634b4d953.png`; `c2ba8fde92920707571eb66328572b5c8b90c4b8cda0f820eba1d4125780fe9e` | `c2ba8fde92920707571eb66328572b5c8b90c4b8cda0f820eba1d4125780fe9e` | `urn:c2pa:f810f22c-3375-42b8-b3de-892009de35ba`; native `1672×941`, 608px `608×342`; exact lesson block retained, including `TimestampType`, `IntegerType`, `StringType`, `True`, field names, punctuation, and `types.` prefixes; no inferred types or capture overlays; published/artifact byte-identical. |

### Already-proven imagegen outputs left unchanged

The audit rechecked but did not regenerate these five active lesson 01–05
references because their durable chains and native/608px validations are
already documented above: images/02-introduction-to-spark-04-typical-workflow-whiteboard-imagegen.png
(Typical Spark workflow — MODEL application-flow repair), the three
lesson-04 outputs images/04-first-look-at-spark-01-spark-ui-crisp.png,
images/04-first-look-at-spark-02-schema-problem-pandas-crisp.png, and
images/04-first-look-at-spark-04-partitions-slides-imagegen.png, and
images/05-spark-dataframes-03-built-in-functions-crisp.png (all in
Strict 06-batch semantic repairs). Their published bytes were left
unchanged.

## Strict 06-batch semantic repairs

These four outputs repair the semantic defects found by the strict 06-batch
review. Each was generated with the original non-crisp JPG and a fresh,
native-resolution bounded crop as imagegen inputs. The generated artifact was
copied byte-for-byte into the published target; no resize, sharpening, or
post-generation text edit was used. C2PA identifiers were read from the
published PNGs.

| Published target | Original JPG SHA-256 | Fresh crop (geometry; SHA-256) | Imagegen artifact | Published output SHA-256 | C2PA / validation |
|---|---|---|---|---|---|
| `images/04-first-look-at-spark-01-spark-ui-crisp.png` | `59ab4b83b501e10b8e70ee48ee560282ba1c47fc566563d64ae9fa2c3ce67f8a` | `x=0,y=27,w=640,h=213`; `f61658745eaf6c73f6ba4a458ba074f5944a6c4a011df2a5dd85f66afaab82ad` | `/home/alexey/.codex/generated_images/01a083f5-2669-7b33-9eee-fc91bf35902a/exec-2deec469-6837-46af-87aa-1d51980902d6.png` | `af09ca8730dcd3e2864f80f7cece625bc6406630643ba40ee6f9e16f9f2208ec` | `urn:c2pa:1375db67-a8d4-43fe-a0e3-79ac6c737bac`; native `2170×725` and 608px `608×203` inspected. Blank Jobs page is preserved; the lesson wording now describes the application Jobs page rather than claiming a visible job row. |
| `images/04-first-look-at-spark-02-schema-problem-pandas-crisp.png` | `53d58e89d35b4ffc5e0462d80728e734bb37d08f49df3bfdabcbac3804ecb704` | `x=0,y=27,w=600,h=215`; `dba05af6d0c2d0dcfd9f0b754f32f181c14e8c67213ea82927ae99a503e09e87` | `/home/alexey/.codex/generated_images/01a083f5-2669-7b33-9eee-fc91bf35902a/exec-7e027aba-fe1d-4717-ae69-1e58bca5bbbe.png` | `540cb55a9a4308c87707fbfb0bc3f62fd7cd47110d6f4494e3d1006e4a3e495a` | `urn:c2pa:9f042254-5254-43d8-b1a2-6e7aa4ea83c6`; native `2098×750` and 608px `608×217` inspected. The command visibly uses exact `head -n 101`, not `1001`. |
| `images/04-first-look-at-spark-04-partitions-slides-imagegen.png` | `33be12471c94b2b6f7001915b11bc0c510f1cb02e35c6ddf4d0f9ed4f0c144a2` | `x=131,y=20,w=467,h=220`; `819b09469da6be9a708be81a0e22d80742a68e836a9ba35beba54462f3c6cb11` | `/home/alexey/.codex/generated_images/01a083f5-2669-7b33-9eee-fc91bf35902a/exec-14476e43-1941-48c3-a072-b3fa37331edb.png` | `d8699e24408e321ac126a08e72cd1f6eb105664665df2e60d69347ef1bd4cdf9` | `urn:c2pa:2093003d-efe6-4f04-9901-95f03e97c023`; native `1672×941` and 608px `608×342` inspected. Six arrows terminate inside matching `Executor 1`–`Executor 6` boxes. An earlier generated grid variant was rejected because three arrows landed between boxes. |
| `images/05-spark-dataframes-03-built-in-functions-crisp.png` | `e446434b8e919d2e3ad53c34939e0cef2ff017fa6f8cb6fd9f3c4e0e422597e0` | `x=0,y=27,w=600,h=215`; `2da9f4e8080cac06a509cbf964d72d9c1375b779e4944f28b144e406d0d2767e` | `/home/alexey/.codex/generated_images/01a083f5-2669-7b33-9eee-fc91bf35902a/exec-e15f8c91-2fdc-4a5e-a333-80c30317d281.png` | `301d8a17b22b44b536de506ca1fb1beda8519ecb491a5348154222c1ba0fb29e` | `urn:c2pa:99f899e3-6162-4916-ad5c-0e1291c63e5a`; native `1672×941` and 608px `608×342` inspected. The SQL context and DataFrame filter both show the exact quoted value `'HV0003'`. |

The four bounded crops above were created with ImageMagick 6.9.12-98 using
the native original frames:

```bash
convert <original.jpg> -crop <width>x<height>+<x>+<y> +repage -strip \
  -define png:exclude-chunk=tIME <target-imagegen-crop.png>
```

The four 608px validation renders are reproducible with
`convert <published.png> -resize '608x608>' <validation.png>` and are kept
outside the repository under `/tmp/de-batch-06-batch-repair-608/`.

## Typical Spark workflow — MODEL application-flow repair

The strict review found that the previous redraw showed `MODEL` beside
`SPARK APPLY ML` but did not connect them. The output was regenerated from the
original non-crisp video frame and a fresh native-resolution crop. The new
diagram makes the required directed `MODEL` → `SPARK APPLY ML` relationship
explicit while preserving the lesson's SQL preparation, Spark/Python training,
and data-lake flow. The presenter, webcam inset, editor controls, and other
capture artifacts are removed.

| Published target | Original JPG SHA-256 | Native bounded crop (geometry; SHA-256) | Imagegen artifact (SHA-256) | Published output SHA-256 | C2PA / validation |
|---|---|---|---|---|---|
| `images/02-introduction-to-spark-04-typical-workflow-whiteboard-imagegen.png` | `28d74acb2c1a4787aeb2bef9126292a8089e32981e45b8d1495ed6bd786161c1` | `x=54,y=3,w=528,h=330`; `ff32c3ac3264b74e8029173dd38d4da95614ad3a32f14edb7221024dc716f7e3` | `/home/alexey/.codex/generated_images/01a0846a-ff62-7b53-ab57-4f77fb0a4f0e/exec-a37f9f13-3d22-4560-892b-fc44d8bebb15.png`; `552a80c8b4ccf18555a756ca9c818c9c976c456da5863932b5383bbeb1423d95` | `552a80c8b4ccf18555a756ca9c818c9c976c456da5863932b5383bbeb1423d95` | `urn:c2pa:13a81cf3-3e5e-4450-8e26-d0e7c0867a74`; native `1942×809` and proportional 608px `608×253` inspected. The output is byte-identical to the imagegen artifact; the directed MODEL-to-SPARK APPLY ML arrow, exact labels, and no-face/no-overlay constraints were checked at both sizes. |

The crop was created from the native `640×360` JPG without scaling or
sharpening:

```bash
convert 02-introduction-to-spark-04-typical-workflow-whiteboard.jpg \
  -crop 528x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  02-introduction-to-spark-04-typical-workflow-whiteboard-imagegen-crop.png
```

The imagegen prompt required these exact labels: `RAW DATA`, `LAKE`,
`SQL / ATHENA`, `SPARK`, `PYTHON TRAIN ML`, `MODEL`, `SPARK APPLY ML`, and
`LAKE`. It explicitly required the SQL → Spark/Python training → MODEL →
SPARK APPLY ML flow and prohibited invented text, faces, camera/browser UI,
watermarks, overlays, and simple enlargement/sharpening. The generated PNG
was copied byte-for-byte into the published target with no post-generation
resize, sharpening, or text edit.

## MapPartitions diagram

| Published target | Original JPG SHA-256 | Bounded crop SHA-256 | Published output SHA-256 | Imagegen output | Validation |
|---|---|---|---|---|---|
| `images/12-spark-rdd-mappartition-01-map-partitions-diagram-imagegen.png` | `7db8b45581bcdda460a273ef9f0f5ba5b128a8e9b44f323250169902cb3fb106` | `b4eacca11cc92bf35c464c7f98dce8924492f4284d01f8ff9a32a5d6b573c075` | `70f194fe755ec4450a9b9ce85944f770ce7522a79cf086b15b97ad5aa7bacbe8` | `/home/alexey/.codex/generated_images/01a08324-9092-7f41-b36b-4be7f604bada/exec-9ac431f6-bbc4-473f-9471-9ec224466957.png` | Native `1774×887` and `608×304` render inspected. Exact `RDD`, `Partition`, `mapPartitions`, and `1TB` labels are present; presenter, camera, toolbar, and handwritten artifacts are absent. C2PA metadata identifies `gpt-image`/OpenAI. |

The exact bounded crop is retained at
`images/12-spark-rdd-mappartition-01-map-partitions-diagram-cropped.png`.
It is the `465×340` region `x=37,y=0,w=465,h=340`, extracted from the
original `640×360` JPG before the imagegen repair.

## Dataproc create-cluster form

| Published target | Original JPG SHA-256 | Fresh bounded crop SHA-256 | Imagegen artifact SHA-256 | Published output SHA-256 | Validation |
|---|---|---|---|---|---|
| `images/15-setting-up-a-dataproc-cluster-01-create-cluster-crisp.png` | `bcbc1727edf57f8792b975af2b6206c7058928299c32873ad04069ce04092876` | `7cca0e94be7edacb547c04f974188958589905f26e3c7e09bf655c21c6c96ef1` | `cd7e76b3b1c8bf24bd9cf3cecfbadb66b79e26942e4bbc63c88fbf9e9d50863f` | `cd7e76b3b1c8bf24bd9cf3cecfbadb66b79e26942e4bbc63c88fbf9e9d50863f` | Fresh imagegen redraw copied byte-for-byte into the published target. Native `1598×984` and proportional `608×374` renders inspected; exact Dataproc setup labels and selected Jupyter/Docker components are preserved. The output contains `gpt-image`/OpenAI C2PA metadata and has no webcam, browser chrome, cursor, or overlay artifacts. |

The new imagegen input crop is retained at
`images/15-setting-up-a-dataproc-cluster-01-create-cluster-imagegen-crop.png`.
It is a native-resolution `535×330` crop at `x=0,y=30,w=535,h=330` from the
original `640×360` JPG. It is intentionally not upscaled or sharpened before
imagegen. The exact crop command, including the tool version used, is:

```bash
# ImageMagick 6.9.12-98 Q16 x86_64 18038
convert 15-setting-up-a-dataproc-cluster-01-create-cluster.jpg \
  -crop 535x330+0+30 +repage -strip -define png:exclude-chunk=tIME \
  15-setting-up-a-dataproc-cluster-01-create-cluster-imagegen-crop.png
```

The resulting crop is SHA-256
`7cca0e94be7edacb547c04f974188958589905f26e3c7e09bf655c21c6c96ef1`.
The imagegen artifact was generated from both the original JPG and this fresh
crop. It was saved at
`/home/alexey/.codex/generated_images/01a0836e-71b4-7e51-81c7-c5b905ca6493/exec-64b34174-22aa-4a10-b641-ab7c83a96f31.png`, has SHA-256
`cd7e76b3b1c8bf24bd9cf3cecfbadb66b79e26942e4bbc63c88fbf9e9d50863f`, and was
copied without post-processing to the published target. The published target
therefore has the identical SHA-256 and retains the imagegen C2PA metadata.

The exact imagegen prompt was:

```text
Use case: ui-mockup
Asset type: high-resolution instructional lesson illustration
Primary request: Recreate the Google Cloud Dataproc “Create a cluster” setup form as a clean, crisp, high-resolution raster illustration. Use Image 1 (the original non-crisp video frame) and Image 2 (the freshly bounded native-resolution crop) only as factual/layout references. Redraw the visible interface cleanly; do not upscale or sharpen the screenshot.
Input images: Image 1: original non-crisp JPG, factual source; Image 2: freshly bounded crop, composition/detail reference.
Scene/backdrop: clean white Google Cloud console interface with a blue cloud-console header and a narrow left navigation rail.
Subject: the “Create a cluster” page. Keep the left setup navigation and the right “Optional components” checklist.
Style/medium: faithful typeset UI redraw, precise vector-like edges, high-resolution bitmap output, neutral white background.
Composition/framing: wide landscape composition matching the reference; show the complete relevant form area, including the “Create a cluster” heading, left setup steps, right optional-components checklist, and Create/Cancel controls.
Text (verbatim): “Google Cloud Platform”, “de-zoomcamp-nytaxi”, “Search”, “dataproc”, “Create a cluster”, “Set up cluster”, “Begin by providing basic information.”, “Configure nodes (optional)”, “Change node compute and storage capabilities.”, “Customize cluster (optional)”, “Add cluster properties, features, and actions.”, “Manage security (optional)”, “Change access, encryption, and security settings.”, “Optional components”, “Select one or multiple components.”, “Learn more”, “Anaconda”, “Hive WebHCAT”, “Jupyter Notebook”, “Zeppelin Notebook”, “Druid”, “Presto”, “ZooKeeper”, “Ranger”, “HBase”, “Flink”, “Docker”, “Solr”, “CREATE”, “CANCEL”.
Constraints: preserve the factual layout and exact labels from the references; Jupyter Notebook and Docker are checked; all other optional components are unchecked; keep the selected project text “de-zoomcamp-nytaxi”; retain the blue header and console navigation as clean UI context.
Avoid: the presenter’s face, webcam circle, browser tabs/address bar, browser chrome, cursor, annotations, handwritten marks, selection highlights, watermarks, invented fields, altered labels, extra components, illegible text, cropped checklist rows, and any screenshot-like blur or simple enlargement.
```

The prior `images/15-setting-up-a-dataproc-cluster-01-create-cluster-cropped.png`
is retained as historical audit evidence for the superseded output. Its
`1070×660` bytes were produced by an undocumented 2× Lanczos/sharpen step and
could not be reproduced (`AE=265712`, `MAE=710.214`); it is not an input to
the new imagegen chain and is no longer used to substantiate the published
output.

For the required display check, resize the published output without sharpening:

```bash
convert 15-setting-up-a-dataproc-cluster-01-create-cluster-crisp.png \
  -resize '608x608>' /tmp/dataproc-create-cluster-608.png
```

Expected render dimensions are `608×374`; inspect both the native target and
that render for readable labels, complete checklist rows, and absence of
camera/browser/overlay artifacts.

## Dataproc reports in bucket

| Published target | Original JPG SHA-256 | Bounded crop SHA-256 | Published output SHA-256 | Imagegen output | Validation |
|---|---|---|---|---|---|
| `images/15-setting-up-a-dataproc-cluster-05-reports-in-bucket-crisp.png` | `01a1cc28707c611321086bfd4de3be9db38cbf0b6ad74ec32ef8bc953f459cf6` | `c5812061eddc30c2e933e501445c53f79f13a92e201b3d67b9e7e226e811cffb` | `0458cb6048aec80f359e4dfe5fe99f9f8b348e97d13ef1564525f2b59ccd21b5` | Generation artifact was not retained separately; the published PNG contains `gpt-image`/OpenAI C2PA metadata. | Published output unchanged. The retained `535×330` crop keeps the bucket context and both `report-2020/` and `report-2021/` folders; native `1672×941` output hash is recorded. |

The canonical bounded crop is now retained at
`images/15-setting-up-a-dataproc-cluster-05-reports-in-bucket-cropped.png`.
It represents `x=0,y=30,w=535,h=330` in the original `640×360` JPG. The
former `290×660` crop had hash
`244ed5e315d675c9724fa6633c5a6e4ab6617b51e7e1b3ad65a8f6c878f2bab0` and is
retained only as
`images/15-setting-up-a-dataproc-cluster-05-reports-in-bucket-narrow-crop-superseded.png`;
it is not the crop used for provenance or generation.

## Dataproc submit-job form

| Published target | Original JPG SHA-256 | Bounded crop SHA-256 | Published output SHA-256 | Imagegen output | Validation |
|---|---|---|---|---|---|
| `images/15-setting-up-a-dataproc-cluster-02-submit-job-form-crisp.png` | `2dc190d5becb85faa1528065388e2f87300d7fb1f46c9de14d16fec17e037ef0` | `52cf74160fffddcf55108190f46dfd5e7f960f6c191b92137d3470a3a90d036f` | `97eb3f5fe08d8aaa50cd0b27d0a9afaa9aac8e1738b86bf7a0cb780ee17cfb45` | `/home/alexey/.codex/generated_images/01a0833c-854d-7862-b9ae-3f5b7eeed1f5/exec-291b2909-8bda-40ae-b273-12502a1f320f.png` | Native `1586×992` and proportional `608×380` render inspected. The redraw shows the complete caption-promised form context: `PySpark`, the exact main Python file, no dependencies/JARs, and all three exact 2021 bucket arguments. Camera, browser chrome, cursor, selection, and overlays are absent; C2PA metadata identifies `gpt-image`/OpenAI. |

## Spark master UI — no workers

| Published target | Original JPG SHA-256 | Bounded crop SHA-256 | Published output SHA-256 | Imagegen output | Validation |
|---|---|---|---|---|---|
| `images/14-creating-a-local-spark-cluster-01-spark-master-ui-crisp.png` | `acbe938fb541ae8322b9e3bcb9c64663a811a121914f3e071393b35dec38978d` | `58db735dd0302ad646017145809db8a50d3a8f9e9c890c9d7e342b513dd8761c` | `728d0410f1436eb3f7c26140d05de26afeba55dffc8eaa49935fa634143db77c` | `/home/alexey/.codex/generated_images/01a0833c-854d-7862-b9ae-3f5b7eeed1f5/exec-5c8cae56-3a93-4b1e-b0af-0798f84227b9.png` | Native `1672×941` and proportional `608×342` renders inspected. The redraw preserves Spark `3.0.3`, the master URL, `ALIVE` status, zero workers, zero applications, and the empty tables. Camera, browser chrome, cursor, selection, and overlays are absent; C2PA metadata identifies `gpt-image`/OpenAI. |

## Spark master UI — worker registered

| Published target | Original JPG SHA-256 | Bounded crop SHA-256 | Published output SHA-256 | Imagegen output | Validation |
|---|---|---|---|---|---|
| `images/14-creating-a-local-spark-cluster-02-worker-registered-crisp.png` | `ebbf95dd6eaf2196d9069f3360303004886952231b15e1edb6364c9fba97c106` | `3bbc5fa8eb6b078349a434752ef3625ba02c6da40d86e16178ef1f7df4a039d3` | `97b571bb5cf58e35e78f465417cc103207af1e212193f7c5d15260c98d8bd987` | `/home/alexey/.codex/generated_images/01a0833c-854d-7862-b9ae-3f5b7eeed1f5/exec-ceb6c26f-2f24-4692-b2f1-9538aabde78f.png` | Native `1672×941` and proportional `608×342` renders inspected. The redraw preserves one `ALIVE` worker, exact worker/address identifiers, resource values, one `RUNNING` application, and one `FINISHED` application. Camera, browser chrome, cursor, selection, and overlays are absent; C2PA metadata identifies `gpt-image`/OpenAI. |

## BigQuery connector traceback — removed

| Former published target | Original JPG SHA-256 | Bounded crop SHA-256 | Former output SHA-256 | Decision |
|---|---|---|---|---|
| `images/16-connecting-spark-to-bigquery-02-failed-to-find-bigquery-crisp.png` | `f5bd4950c6b57cad657d6e787b58c84aa7bd9688b52546d583625a4b46b3880b` | `65d7259a7c58b69a03982db395c85fcb4063aa6f63c10692d76708ed98265f44` | `dd7a40484fc34b5fc8e543b8ca81e20ef166745bf6c72e1de006b19c238fc927` | Removed the Markdown embed. This is exact traceback/code output and is more useful as native lesson text; retaining it as a bitmap adds no instructional value and preserves capture artifacts. The JPG, crop, and PNG remain in the repository for auditability. |

## Lessons 08–10 provenance-blocked illustration repairs — 2026-09-09

These six repairs close the remaining provenance blocks in lessons 08–10 of
06-batch. Every source JPG is the retained native `640×360` video frame. A
fresh bounded crop was made at native resolution, with no resize, Lanczos,
sharpening, or text edit, and the original JPG plus that crop were sent to
the built-in imagegen workflow as Image 1 and Image 2. The final published
PNG is byte-identical to the listed final imagegen artifact. The Spark UI
asset remains a raster because the UI layout, job rows, counts, and progress
bars are instructional evidence; replacing it with a Markdown table would
not preserve that structure. The validation renders are display-only and
remain outside the repository at
`/tmp/de-batch-06-batch-repair-608-2026-09-09/`.

| Published target | Original JPG (SHA-256) | Fresh native crop (geometry; SHA-256) | Final imagegen artifact (path; SHA-256) | Published output (SHA-256; native → simulated 608px) | C2PA / semantic validation |
|---|---|---|---|---|---|
| `images/08-anatomy-of-a-spark-cluster-01-spark-submit-master-imagegen.png` | `images/08-anatomy-of-a-spark-cluster-01-spark-submit-master.jpg` (`a581ca58ccb942e7a2440040d2f27c28a7dc8b680e82852b1ded88dae5c18478`) | `images/08-anatomy-of-a-spark-cluster-01-spark-submit-master-imagegen-crop.png` (`x=54,y=3,w=446,h=330`; `d44213272a9df8dcaa6a71d6eaf5cf443577568f4aefb13c732c539cb5fea0ae`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-a7f95ce2-8670-44e5-bfc8-bf49c622a157.png` (`00f47406910ab34ca13dd2c8480e4b474f4c8780c5838726b824eec3c8ca15b4`) | `00f47406910ab34ca13dd2c8480e4b474f4c8780c5838726b824eec3c8ca15b4`; `1672×940 → 608×342` | `urn:c2pa:812d179d-ad6a-45da-a357-689341858354`; `DRIVER → SPARK SUBMIT → MASTER`, `4040` is associated with `MASTER`, and the cluster contains no executor nodes. No face, camera, browser, editor, or selection overlay. |
| `images/08-anatomy-of-a-spark-cluster-02-executors-failure-imagegen.png` | `images/08-anatomy-of-a-spark-cluster-02-executors-failure.jpg` (`31546cb274f628bf40524dd21b0e7ab09a6de9e1b226d5d7d9cd978bd17ace69`) | `images/08-anatomy-of-a-spark-cluster-02-executors-failure-imagegen-crop.png` (`x=54,y=3,w=446,h=330`; `6b2a636b8d7e87b425cd74a87590f6333d38feceb911c2c09426f69b92c816eb`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-24f7acef-604f-4250-b8ba-45217998163f.png` (`1a159090345423358816911b023fc0988b14b62f36d2ee1f9a7eb694bb10425c`) | `1a159090345423358816911b023fc0988b14b62f36d2ee1f9a7eb694bb10425c`; `1672×941 → 608×342` | `urn:c2pa:71480ee2-8eaa-4b1d-9a46-03e6a410150e`; exactly five executor boxes are shown: one failed red-X box and four green-check boxes, with master-to-executor arrows directed toward the executor group. The first candidate was rejected for one stray blank rectangle; the final targeted edit removes it. |
| `images/08-anatomy-of-a-spark-cluster-03-executors-pull-partitions-imagegen.png` | `images/08-anatomy-of-a-spark-cluster-03-executors-pull-partitions.jpg` (`3719ec21d59f2e99b7068cb4098157efcda7149042479ff40ec9ee6174869e83`) | `images/08-anatomy-of-a-spark-cluster-03-executors-pull-partitions-imagegen-crop.png` (`x=54,y=3,w=446,h=330`; `b6d65e5a7245849309eff62e2d0b3433da5fc0b321c7c74cf8a3b3af82ffd678`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-d65dd395-21de-45a3-bd1b-cb49c3db0d15.png` (`dedafa9b59689d3a106dbc0992d4c253069e120c4faef982b44db6c6ddc65d64`) | `dedafa9b59689d3a106dbc0992d4c253069e120c4faef982b44db6c6ddc65d64`; `1672×941 → 608×342` | `urn:c2pa:2ace5489-f45c-4e59-ab11-f0ad25a246cf`; four `DF` partitions feed `EXECUTOR 1`–`EXECUTOR 4` with four left-pointing partition-to-executor arrows; no face, camera, browser, editor, or selection overlay. |
| `images/08-anatomy-of-a-spark-cluster-04-s3-gcs-instead-of-hdfs-imagegen.png` | `images/08-anatomy-of-a-spark-cluster-04-s3-gcs-instead-of-hdfs.jpg` (`e0c6fe0810ea031f42db9c70f1aef3acda0e72fad02882d31d5944228c5346ee`) | `images/08-anatomy-of-a-spark-cluster-04-s3-gcs-instead-of-hdfs-imagegen-crop.png` (`x=54,y=3,w=446,h=330`; `8ce7f692b24ec4c28904fc348100c5829bab53708ff56e53078c4c32dd4a52f3`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-459f97d9-aad0-4163-8af1-562b9f0f7389.png` (`de59e4bae1ad5cdf51a3b9605b4f6392a4b95f8c21d580241b5c48f46b6bff18`) | `de59e4bae1ad5cdf51a3b9605b4f6392a4b95f8c21d580241b5c48f46b6bff18`; `1672×941 → 608×342` | `urn:c2pa:2bed2ac0-5a9d-4aac-9fe8-8df6098eded2`; `HADOOP/HDFS` is crossed out, `S3/GCS` is the active store, and exactly four non-crossing left-pointing arrows map `partition 1/2/3/N` to the four healthy executors. The first candidate was rejected because the arrows crossed/mislanded; the final targeted edit fixes the mapping. |
| `images/09-groupby-in-spark-03-reshuffling-whiteboard-imagegen.png` | `images/09-groupby-in-spark-03-reshuffling-whiteboard.jpg` (`10326539ab2c4ea9dd99563e465fcd9924a274f17e26892be029c06e9f953f17`) | `images/09-groupby-in-spark-03-reshuffling-whiteboard-imagegen-crop.png` (`x=54,y=3,w=446,h=330`; `4ec08aaa7055acd9999622c4fd1e94556e856195441ea7ea0331a210723d651d`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-3d2d857d-0141-4769-9aa4-5899cdf3fc05.png` (`f7034d5cfd17a5439783a82ab24fa9c1f827050f6b2de7218cb40f455f466aab`) | `f7034d5cfd17a5439783a82ab24fa9c1f827050f6b2de7218cb40f455f466aab`; `1459×1078 → 608×449` | `urn:c2pa:37f851ca-ccf5-49ea-b2ef-45e82a7718ee`; exact subresult values `100,5`, `200,10`, `50,2`, and `250,12` are preserved, with five left-to-right arrows grouping `(h1,z1)` into `P1` and `(h1,z2)` into `P2`. |
| `images/10-joins-in-spark-04-broadcast-exchange-crisp.png` | `images/10-joins-in-spark-04-broadcast-exchange.jpg` (`6ad6de2cc8cd383682459256764be1f3977e2cb4bed6b64d9dc09de230d9ac97`) | `images/10-joins-in-spark-04-broadcast-exchange-imagegen-crop.png` (`x=0,y=24,w=640,h=216`; `cd74244456707198c89d9e7e1dea9cdfd665526c0ba0f0a468d627602e9817ae`) | `/home/alexey/.codex/generated_images/01a08475-4c39-78e3-9808-678666e6c738/exec-940344e1-e0a2-44bd-b9cf-f702cc5a0696.png` (`1168c85376ec32fb9882684f1fcd0e9b9da3c4546e1021dd2f1261997351c8af`) | `1168c85376ec32fb9882684f1fcd0e9b9da3c4546e1021dd2f1261997351c8af`; `2160×728 → 608×205` | `urn:c2pa:2e30f186-b6f5-42b9-b22d-6be819e5f61d`; `Completed Jobs: 42`, broadcast-exchange rows 40/39/37, stage `1/1`, row-41 task `7/7`, and the visible Spark UI hierarchy are preserved; camera, browser chrome, cursor, and selection highlight are absent. |

The exact native crop commands were:

```bash
# ImageMagick 6.9.12-98 Q16 x86_64 18038; no scaling or sharpening
convert 08-anatomy-of-a-spark-cluster-01-spark-submit-master.jpg \
  -crop 446x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  08-anatomy-of-a-spark-cluster-01-spark-submit-master-imagegen-crop.png
convert 08-anatomy-of-a-spark-cluster-02-executors-failure.jpg \
  -crop 446x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  08-anatomy-of-a-spark-cluster-02-executors-failure-imagegen-crop.png
convert 08-anatomy-of-a-spark-cluster-03-executors-pull-partitions.jpg \
  -crop 446x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  08-anatomy-of-a-spark-cluster-03-executors-pull-partitions-imagegen-crop.png
convert 08-anatomy-of-a-spark-cluster-04-s3-gcs-instead-of-hdfs.jpg \
  -crop 446x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  08-anatomy-of-a-spark-cluster-04-s3-gcs-instead-of-hdfs-imagegen-crop.png
convert 09-groupby-in-spark-03-reshuffling-whiteboard.jpg \
  -crop 446x330+54+3 +repage -strip -define png:exclude-chunk=tIME \
  09-groupby-in-spark-03-reshuffling-whiteboard-imagegen-crop.png
convert 10-joins-in-spark-04-broadcast-exchange.jpg \
  -crop 640x216+0+24 +repage -strip -define png:exclude-chunk=tIME \
  10-joins-in-spark-04-broadcast-exchange-imagegen-crop.png
```

The final prompts used the original JPG and crop as factual/layout
references, required a clean high-resolution redraw, and prohibited simple
enlargement, sharpening, invented text, reversed arrows, faces, camera
circles, browser/editor chrome, cursors, selections, watermarks, and
post-generation text edits. The 08-02 base candidate
`exec-ebc519b9-61e3-4e84-b6b8-ba3162bd4124.png` was superseded by the listed
targeted edit after native inspection found one stray blank rectangle. The
08-04 base candidate
`exec-81040435-4bdf-42b1-9df7-f43598fe6e34.png` was superseded by the listed
targeted edit after native inspection found crossed/mislanded storage arrows.
Both base generations had already used the required original-JPG-plus-crop
input pair. No resized or sharpened derivative was used as a published asset.

The six display-only validation renders were generated without sharpening:

```bash
convert <published.png> -filter Triangle -resize '608x608>' <validation.png>
```

Native and simulated 608px inspections passed for all six finals; the
validation PNGs are not source or published assets.
