# Workshop Best Practices

Preferences and patterns learned from building the PyFlink streaming workshop.

## Structure and Pacing

- Introduce services one at a time, not all at once. Start with one container
  (e.g., Redpanda), explain it, use it. Then add the next (PostgreSQL), etc.
- Start with the simplest version that works (plain Python consumer), then
  motivate the more complex tool (Flink) by showing what's missing.
- Use `docker compose up <service> -d` to start services selectively during
  the gradual buildup. `docker compose up --build -d` only when everything
  is ready.

## Data

- Use real datasets, not fake test data. NYC taxi data
  (`yellow_tripdata_YYYY-MM.parquet`) is a good go-to.
- Limit to manageable sizes (e.g., first 1000 rows) for workshop speed.

## Project Setup

- Assume starting from scratch: `uv init -p 3.12` + `uv add <package>`.
- Add dependencies gradually as they're needed in the narrative
  (e.g., `uv add kafka-python pandas pyarrow` first, `uv add psycopg2-binary`
  later when PostgreSQL is introduced).
- Always note "if you cloned the repo, run `uv sync` instead" as a blockquote.

## Code Delivery

- Break large code blocks into small, focused blocks. Each block should do
  one thing. Don't dump a full script in one block.
- Pattern for code blocks: short intro line (what it does), then the code,
  then the explanation of how it works below. Don't put detailed
  explanations before the code - let the reader see the code first.
- Keep imports local to each block - don't introduce all imports upfront.
  Each block should only import what it uses.
- Introduce functions and utilities where they're first used, not earlier.
  For example, show `dataclasses.asdict()` in the block that calls it, not
  in the block that defines the dataclass.
- When introducing a function, show a test with sample data before using it
  in the real code. For example, create a test binary string to verify a
  deserializer, then pass it to the consumer.
- Prefer named functions over inline lambdas. A named function is reusable,
  testable, and easier to explain step by step. For example,
  `value_deserializer=ride_deserializer` instead of
  `value_deserializer=lambda m: json.loads(m.decode('utf-8'))`.
- Extract repetitive logic into named functions. For example, row-to-object
  conversion that appears in multiple places should be a function like
  `ride_from_row(row)`.
- Split one-liner functions into multiple lines. Each step (decode, parse,
  construct) on its own line is easier to follow and explain.
- Show the simple approach first, then improve it. For example, show a
  generic `json_serializer` with manual `dataclasses.asdict()` calls, then
  introduce a specialized `ride_serializer` that handles the conversion
  internally. Let the student feel the friction before showing the fix.
- Extract shared code (dataclasses, serializers, deserializers, converters)
  into shared modules (e.g., `models.py`) so multiple scripts can import
  from one place.
- Reference the complete script at the end (e.g., "> The complete script is
  in `src/producers/producer.py`.").
- For infrastructure files that are long or complex (Dockerfile, YAML configs),
  link to the file on GitHub and provide a short summary list of what it does.
  Use `wget` to download from the GitHub repo instead of asking students to
  type them.
- Mention that students can run Python code in Jupyter notebooks
  (`uv add jupyter`, `uv run jupyter lab`) as an alternative to .py scripts.
  The small-block style maps naturally to notebook cells.
- Flink jobs must remain as .py files (they're submitted to the cluster via
  `docker compose exec`). Add a note explaining this distinction.

## Formatting

- No bold formatting (`**text**`) in README files. Use plain text.
- No em dashes. Use hyphens with spaces (` - `) instead.
- Use `python` not `python3`.
- Use `docker compose` not `docker-compose`.
- Use `uvx pgcli` not just `pgcli`.
- Use `uv run python` not `python` for running scripts.

## Naming

- Use meaningful names that reflect purpose, not generic placeholders.
  For example, `group_id='rides-console'` or `group_id='rides-to-postgres'`,
  not `group_id='test-consumer-group'`.

## Explanations

- For complex configurations (like Redpanda's docker-compose command), explain
  every parameter in a table or list.
- Explain the "why" not just the "what" (why two Kafka addresses? why
  checkpointing every 10 seconds? why watermarks?).
- Use tables for parameter explanations and comparisons.
- Include sample output for every command students will run.
- Use `>` blockquotes for tips, notes about the repo, and common mistakes from
  original workshops/streams.
- For complex concepts (watermarks, task slots, parallelism), pull the
  explanation out of bullet lists into its own multi-paragraph section. State
  the value or syntax in the bullet, then explain the concept below in
  separate paragraphs for easier reading.
- Use lists for multi-point summaries instead of packing everything into one
  long sentence.
- When showing a development shortcut (like mounting local files into Docker),
  add a note explaining how it works in production. Students benefit from
  understanding real-world deployment patterns alongside the workshop setup.

## Code Organization

- Define the source (where you read from) before the sink (where you write
  to) when presenting code blocks. Set up the consumer/reader first, then
  the database connection or output destination.

## Docker Compose

- Don't use `container_name` or `hostname` - Docker Compose handles naming
  automatically.
- Don't use `extra_hosts` unless specifically needed.
- Service names are automatically resolvable as hostnames within the Docker
  network.
- Prefer short service names (e.g., `redpanda` not `redpanda-1`).
- Keep `restart: on-failure` only for services that need it (like databases).

## Dependencies and Versions

- Always use the latest stable versions of images and libraries.
- Pin exact versions for Flink and its connectors (they must match).
- Use `uv` for everything Python-related (package management, running scripts,
  even installing Python itself inside Docker).
- Prefer `COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/` in Dockerfiles
  instead of `apt-get install`.

## Workshop Header

- Credit the original stream/video at the top with a link.
- If the new video is not yet available, put "TBA" with a sign-up link
  (e.g., Luma).
- Brief description of what we'll build and prerequisites.

## Workshop Flow Template

1. Introduce the first component (message broker, database, etc.)
2. Set up with docker-compose (explain parameters)
3. Create a simple producer/writer
4. Create a simple consumer/reader
5. Add a database, save data
6. Show limitations of the simple approach
7. Introduce the framework (Flink, Spark, etc.)
8. Reproduce the simple case with the framework
9. Do something the simple approach can't (aggregation, windowing)
10. Explain advanced concepts (window types, offsets, etc.)
11. Cleanup
12. Q&A - questions and answers from the original stream. Include production
    deployment topics here rather than as standalone sections.
