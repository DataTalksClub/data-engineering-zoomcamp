# Scripts

## generate_thumbnails.py

Generates self-hosted YouTube thumbnails for the course READMEs.

The READMEs used to embed thumbnails through the external service
`markdown-videos-api.jorgenkh.no`, which renders a thumbnail with a play
button on the fly. That service is flaky, so GitHub's image cache often
times out and thumbnails randomly fail to load (issue #591).

This script removes the runtime dependency. It scans the markdown files,
and for every link that still points at the external service it:

1. downloads the raw YouTube thumbnail (`https://img.youtube.com/vi/<id>/0.jpg`)
2. pastes our own play-button overlay (`play.png`) on top
3. saves the result next to the README under `images/thumbnail-<id>.jpg`
4. rewrites the markdown to point at the committed image

It is idempotent: links that already point at a local `images/...` path are
skipped, and existing thumbnails are not re-downloaded. To add thumbnails for
new videos, keep using the `markdown-videos-api.jorgenkh.no` link in the
markdown and re-run the script - only the new ones get processed.

### Usage

```bash
cd scripts
uv run generate_thumbnails.py            # scan the whole repo
uv run generate_thumbnails.py PATH ...   # only the given files/dirs
uv run generate_thumbnails.py --dry-run  # report changes without writing
```
