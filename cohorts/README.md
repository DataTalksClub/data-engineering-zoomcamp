# Cohorts

Each directory here is one delivery of the course. **The directory name is the cohort
identifier and it appears in the public URL**, so it is never renamed.

## Layout

From 2027 onwards a cohort directory holds the whole curriculum for that year:

```
cohorts/2027/
├── cohort.yaml                  # cohort identity, dates, module/homework flow
├── README.md                    # the human-readable schedule page
├── project.md
└── 01-docker-terraform/         # the directory name is the module slug
    ├── module.yaml              # module identity and the ordered unit list
    ├── README.md                # GitHub-facing module index (not published to the site)
    ├── 01-introduction.md       # a unit; the file stem is the unit slug
    ├── 02-virtual-environment.md
    ├── ...
    ├── homework.md              # homework instructions
    ├── homework.yaml            # homework identity, due date, form, questions
    ├── images/                  # every image the units in this module reference
    └── ...                      # code and companion files the units link to
```

Rules a reviewer (and the site's importer) can check:

1. **Names are identity.** Cohort identifier = directory name. Module slug = directory
   name. Unit slug = the markdown file's stem. Nothing restates them in prose.
2. **Units are siblings of `module.yaml`**, named `NN-kebab-case.md`, ordered by their
   numeric prefix. `README.md` and `homework.md` are the only other markdown files
   directly inside a module directory; anything else (setup guides, appendices) goes in a
   subdirectory.
3. **A module directory is self-contained.** Images live in that module's `images/`,
   companion code lives inside the module directory, and no relative link leaves the
   cohort directory. Targets outside the cohort are written as absolute GitHub URLs.
4. **One module, one homework, side by side.** `homework.md` and `homework.yaml` live in
   the module directory they belong to.
5. **A unit's title is its single leading `#` heading.** Videos go in the unit's YAML
   frontmatter as `video_url`, not in the body.

## Which cohort do I edit?

Edit the **current** cohort. Earlier cohort directories are frozen archives — the drift
between them is the record of what was actually taught. Backport only factual or breaking
fixes (a wrong command, a dead dataset URL), and do it explicitly per year.

## Earlier cohorts

`2022`–`2026` predate this layout. They hold homework, schedules and per-year notes only;
the teaching material for those years lives in the numbered module directories at the
repository root. Those directories stay where they are so that existing links keep
working.
