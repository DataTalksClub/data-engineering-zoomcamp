"""Generate self-hosted YouTube thumbnails for course READMEs.

The READMEs used to embed thumbnails through the external service
markdown-videos-api.jorgenkh.no, which renders a thumbnail with a play
button on the fly. That service is flaky, so GitHub's image cache often
times out and thumbnails randomly fail to load (issue #591).

This script removes the runtime dependency: for every such link it
downloads the raw YouTube thumbnail, pastes our own play-button overlay
on top, saves the result next to the README under images/, and rewrites
the markdown to point at the committed image.

Usage:
    uv run generate_thumbnails.py            # scan the whole repo
    uv run generate_thumbnails.py PATH ...   # only the given files/dirs

Use --dry-run to see what would change without writing anything.
"""

import argparse
import re
import sys
from io import BytesIO
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse

import requests
from PIL import Image

REPO_ROOT = Path(__file__).resolve().parent.parent
PLAY_OVERLAY = Path(__file__).resolve().parent / "play.png"
THUMBNAIL_SOURCE = "https://img.youtube.com/vi/%s/0.jpg"

# Matches the image source URLs the READMEs use, e.g.
#   https://markdown-videos-api.jorgenkh.no/youtube/<id>
#   https://markdown-videos-api.jorgenkh.no/url?url=<url-encoded youtube link>
SERVICE_URL = re.compile(
    r"https://markdown-videos-api\.jorgenkh\.no/[^\s)\"'>]+"
)


def extract_video_id(service_url: str) -> str | None:
    """Pull the YouTube video id out of a markdown-videos service URL."""
    parsed = urlparse(service_url)

    if parsed.path.startswith("/youtube/"):
        return parsed.path.split("/youtube/", 1)[1].strip("/") or None

    if parsed.path.startswith("/url"):
        target = parse_qs(parsed.query).get("url", [None])[0]
        if not target:
            return None
        target = urlparse(unquote(target))
        if target.netloc.endswith("youtu.be"):
            return target.path.strip("/").split("/")[0] or None
        return parse_qs(target.query).get("v", [None])[0]

    return None


def build_thumbnail(video_id: str, dest: Path) -> bool:
    """Download the thumbnail, overlay the play button, save to dest."""
    if dest.exists():
        return True

    url = THUMBNAIL_SOURCE % video_id
    response = requests.get(url, timeout=30)
    if response.status_code != 200:
        print(f"  ! failed to download {url} ({response.status_code})")
        return False

    thumbnail = Image.open(BytesIO(response.content)).convert("RGB")
    play = Image.open(PLAY_OVERLAY)

    w_img, h_img = thumbnail.size
    w_play, h_play = play.size
    x0 = w_img // 2 - w_play // 2
    y0 = h_img // 2 - h_play // 2
    thumbnail.paste(play, (x0, y0), play)

    dest.parent.mkdir(parents=True, exist_ok=True)
    thumbnail.save(dest, quality=90)
    return True


def process_file(md_file: Path, dry_run: bool) -> int:
    text = md_file.read_text(encoding="utf-8")
    matches = list(dict.fromkeys(SERVICE_URL.findall(text)))
    if not matches:
        return 0

    images_dir = md_file.parent / "images"
    changed = 0

    for service_url in matches:
        video_id = extract_video_id(service_url)
        if not video_id:
            print(f"  ? could not parse video id from {service_url}")
            continue

        rel_path = f"images/thumbnail-{video_id}.jpg"
        dest = images_dir / f"thumbnail-{video_id}.jpg"

        if not dry_run and not build_thumbnail(video_id, dest):
            continue

        text = text.replace(service_url, rel_path)
        changed += 1
        print(f"  {video_id} -> {rel_path}")

    if changed and not dry_run:
        md_file.write_text(text, encoding="utf-8")

    return changed


def collect_markdown(paths: list[Path]) -> list[Path]:
    files: list[Path] = []
    for path in paths:
        if path.is_dir():
            files.extend(sorted(path.rglob("*.md")))
        elif path.suffix == ".md":
            files.append(path)
    return files


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "paths",
        nargs="*",
        type=Path,
        help="Markdown files or directories to process (default: whole repo)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report what would change without downloading or writing",
    )
    args = parser.parse_args()

    if not PLAY_OVERLAY.exists():
        print(f"missing play overlay: {PLAY_OVERLAY}")
        return 1

    targets = args.paths or [REPO_ROOT]
    total = 0
    for md_file in collect_markdown(targets):
        changed = process_file(md_file, args.dry_run)
        if changed:
            print(f"{md_file.relative_to(REPO_ROOT)}: {changed} thumbnail(s)")
            total += changed

    verb = "would update" if args.dry_run else "updated"
    print(f"\nDone: {verb} {total} thumbnail link(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
