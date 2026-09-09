# Streaming illustration source audit

**Audit date:** 2026-09-09

> **Superseded status:** The initial blocked attempt recorded below was
> superseded after the DataImpulse source/frame pass completed. The current
> source inventory is `/home/alexey/git/.tmp/workshop-processing/de-2027-m07/STATUS.md`;
> the first six published conceptual assets and their independent review are
> recorded in `visual-audit-2026-09-09.md` and the scratch report
> `.tmp/workshop-processing/de-2027-m07/INDEPENDENT-REVIEW-BATCH-1.md`.

**Scope:** `cohorts/2027/07-streaming` and source workshop
`07-streaming/workshop`

**Source:** [YDUgFeHQzJU](https://www.youtube.com/watch?v=YDUgFeHQzJU)

**Status:** superseded historical attempt (blocked before frame extraction)

## Outcome

No course illustrations were published. The source could not be decoded into
a local video, so there are no inspectable frames and no honest rubric scores.
All five prioritized candidates remain pending rather than being accepted or
rejected on visual evidence. No lesson Markdown, source-workshop file, Docker
file, warehouse path, or unit 10 Mermaid diagram was changed.

## Acquisition and extraction evidence

Working files were kept outside the course tree in the ignored
`/home/alexey/git/zoomcamp-ops/.tmp/videos/` directory.

| Attempt | Result |
| --- | --- |
| `uvx yt-dlp -f 'bv*[height<=720]+ba/b[height<=720]' -S 'res:720,br' --merge-output-format mkv` | YouTube returned `Sign in to confirm you're not a bot`. |
| Documented Oxylabs sticky-session route with `--js-runtimes node`, Android player client, and format `18` | Proxy returned `407 Proxy Authentication Required` on every request. |
| Documented Piped fallback | `pipedapi.ducks.party` returned metadata for a 360p, 5,553-second stream, but its signed media URL returned HTTP `403`; the downloaded file remained 0 bytes. Other checked instances returned 500/502/403/000. |
| Documented Invidious fallback | Checked instances were disabled, unauthorized, blocked, unsupported, or returned an HTML challenge; no valid JSON stream was available. |
| `ffprobe` on the only downloaded path | Failed with `moov atom not found`; file size was 0 bytes. |

The timestamped transcript is cached at
`~/.cache/youtube_transcripts/YDUgFeHQzJU.txt` and was used only to verify the
candidate cues. It is not a substitute for a source frame.

## Prioritized candidates

Scores are `N/A` rather than invented values: the rubric requires visual
inspection at normal rendered size, and no candidate frame was decoded.

| Unit / lesson | Requested window | Transcript cue / intended teaching point | Proposed caption and alt text | Score / disposition |
| --- | --- | --- | --- | --- |
| 02 — Redpanda | 13:18–13:49 | The Redpanda compose definition is on screen; the instructor focuses on the internal/external listeners and published ports used by Docker clients and the laptop. | **Caption:** “Redpanda exposes separate Kafka listeners for Docker and the laptop.” **Alt:** “Redpanda compose configuration showing internal port 29092 and external port 9092 listeners.” | N/A — blocked; do not publish until a readable frame is available. |
| 05 — Save events to PostgreSQL | 47:57–48:33 | A `SELECT count(*)` initially returns no rows; after data is sent, the consumer populates `processed_events` and the data is visible in PostgreSQL. | **Caption:** “The PostgreSQL sink fills as the consumer processes incoming rides.” **Alt:** “Terminal and PostgreSQL view showing processed event rows appearing after the producer sends data.” | N/A — blocked; do not publish until the result state is readable and checked against the lesson. |
| 07 — The Flink image and services | 1:03:03–1:03:21 | The Flink UI shows one TaskManager with 15 slots and no running job yet. | **Caption:** “Before submitting a job, the Flink cluster reports one TaskManager with 15 available slots.” **Alt:** “Flink dashboard showing one TaskManager, 15 slots, and no running jobs.” | N/A — blocked; do not publish until the UI labels and numbers can be checked. |
| 08 — The pass-through Flink job | 1:09:31–1:10:57 | The job is submitted through the JobManager, appears as running, and begins feeding the PostgreSQL sink as the event count is refreshed. | **Caption:** “The submitted pass-through Flink job moves Kafka events into the PostgreSQL sink.” **Alt:** “Flink dashboard showing a running pass-through job while the PostgreSQL processed-events count updates.” | N/A — blocked; do not publish until the job state and sink result are readable. |
| 11 — Late events and upserts | 1:17:29–1:17:41 | The generated stream output identifies events that arrived late, including an event 10 seconds late and another 4 seconds late. | **Caption:** “The stream records event lateness before the Flink job applies its late-event policy.” **Alt:** “Terminal output showing taxi events marked as on time, 10 seconds late, and 4 seconds late.” | N/A — blocked; do not publish until the exact lateness values and surrounding output are verified. |

## Active-unit audit

The 14 units listed in `module.yaml` were checked for active raster
illustration references. There are no active image references in this scope.
Unit 10 has native Mermaid sequence diagrams in its lesson; they are valid
source content and were preserved.

| Unit | Lesson | Illustration status |
| --- | --- | --- |
| 01 | PyFlink: Stream Processing Workshop | Missing — no active raster reference |
| 02 | Redpanda - a Kafka-compatible broker | Missing — candidate audit blocked |
| 03 | Produce messages to Kafka | Missing — no active raster reference |
| 04 | Consume messages with Python | Missing — no active raster reference |
| 05 | Save events to PostgreSQL | Missing — candidate audit blocked |
| 06 | Why Flink? | Missing — no active raster reference |
| 07 | The Flink image and services | Missing — candidate audit blocked |
| 08 | The pass-through Flink job | Missing — candidate audit blocked |
| 09 | Offsets - earliest vs latest | Missing — no active raster reference |
| 10 | Aggregation with tumbling windows | Native Mermaid diagrams present; no raster reference |
| 11 | Late events and upserts | Missing — candidate audit blocked |
| 12 | Understanding window types | Missing — no active raster reference |
| 13 | Cleanup | Missing — no active raster reference |
| 14 | Q&A | Missing — no active raster reference |

## Active-illustration audit

There are currently **zero active illustration references** under this module.
Therefore there are no resolved image targets, broken references, or
independent visual verdicts to report. The five rows above are source-audit
candidates only; none is a course asset.

## Resume conditions

Resume this pass only after a valid local recording is available under the
ignored `.tmp/videos/` workspace. Then extract a small frame set with ffmpeg
under `.tmp/illustrations/07-streaming/candidates/`, inspect each at lesson
size, score all six rubric criteria, deterministically crop exact UI/code/data,
and publish only candidates scoring at least 7/12 with a reviewed caption and
alt text. Keep all videos, candidates, crops, and rejected variants out of
Git.
