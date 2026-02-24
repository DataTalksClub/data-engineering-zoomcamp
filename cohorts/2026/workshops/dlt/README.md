# From APIs to Warehouses: AI-Assisted Data Ingestion with dlt

Welcome to the **Data Engineering Zoomcamp 2026** workshop!

In this workshop, you'll use an AI-powered IDE to build a complete data pipeline. Using simple prompts, you can go from an API to a local data warehouse with [dlt](https://dlthub.com/docs) (data load tool). The AI handles the code generation. You focus on the results.

## What You'll Build

By the end of this workshop, you will have:

1. A working dlt pipeline that extracts data from the [Open Library API](https://openlibrary.org/developers/api)
2. Normalized relational tables stored in DuckDB
3. The ability to query, inspect, and visualize your data
4. Experience using AI-assisted development for data engineering

**No API key required!** The Open Library API is completely open and doesn't require authentication. You can start building immediately.

---

## Prerequisites

Before the workshop, make sure you have the following set up:

### 1. Understand What dlt Does (Recommended for Beginners)

If you're unfamiliar with dlt and what the library does, we recommend reading through the included Jupyter notebook before the workshop.

**[Open the notebook in Google Colab](https://colab.research.google.com/github/anair123/data-engineering-zoomcamp/blob/workshop/dlt_2026/cohorts/2026/workshops/dlt/dlt_Pipeline_Overview.ipynb)**

It walks through dlt step by step:

- What a dlt source and pipeline are
- How data moves through Extract, Normalize, and Load
- How to inspect the loaded data

Understanding these concepts will help you know what the agent-generated code is actually doing.

> You do not need to clone the repo to follow the workshop. The `dlt init` command scaffolds everything you need.

### 2. An Agentic IDE

You'll need an AI-powered code editor that can understand context and generate code from natural language. We recommend:

| IDE | Description |
|-----|-------------|
| [**Cursor**](https://cursor.sh) | VS Code fork with built-in AI assistance (recommended) |
| [Windsurf](https://codeium.com/windsurf) | Alternative agentic IDE |
| [VS Code + GitHub Copilot](https://github.com/features/copilot) | Works, but less integrated |

### 3. Python 3.11+

```bash
python --version  # Should be 3.11 or higher
```

### 4. uv (Recommended) or pip

We use [uv](https://docs.astral.sh/uv/) for fast dependency management:

```bash
# Install uv (if you don't have it)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## Workshop Instructions

### Step 1: Create a New Project Folder

Create a fresh folder for your pipeline and open it in Cursor (or your preferred agentic IDE):

```bash
mkdir my-dlt-pipeline
cd my-dlt-pipeline
```

### Step 2: Add the dlt MCP Server Config

Choose the setup for your IDE:

Cursor - go to **Settings → Tools & MCP → New MCP Server** and add:

```json
{
  "mcpServers": {
    "dlt": {
      "command": "uv",
      "args": [
        "run",
        "--with",
        "dlt[duckdb]",
        "--with",
        "dlt-mcp[search]",
        "python",
        "-m",
        "dlt_mcp"
      ]
    }
  }
}
```

VS Code (Copilot) - create `.vscode/mcp.json` in your project folder:

```json
{
  "servers": {
    "dlt": {
      "command": "uv",
      "args": [
        "run",
        "--with",
        "dlt[duckdb]",
        "--with",
        "dlt-mcp[search]",
        "python",
        "-m",
        "dlt_mcp"
      ]
    }
  }
}
```

Claude Code - run in your terminal:

```bash
claude mcp add dlt -- uv run --with "dlt[duckdb]" --with "dlt-mcp[search]" python -m dlt_mcp
```

This enables the dlt MCP server, which gives the AI access to dlt documentation, code examples, and your pipeline metadata.

### Step 3: Install dlt Workspace

```bash
pip install "dlt[workspace]"
```

### Step 4: Initialize the dlt Project

```bash
dlt init dlthub:open_library duckdb
```

This scaffolds the pipeline files and configuration for Open Library. You now have everything you need to start prompting.

> 📖 **Reference:** [Open Library Workspace Instructions](https://dlthub.com/workspace/source/open-library)

### Step 5: Prompt the Agent to Build and Run the Pipeline

This is where the magic happens. The `dlt init` command scaffolds sample prompts you can use. Here's an example to get started:

```
Please generate a REST API Source for Open Library API, as specified in @open_library-docs.yaml
Start with endpoint(s) books and skip incremental loading for now.
Place the code in open_library_pipeline.py and name the pipeline open_library_pipeline.
If the file exists, use it as a starting point.
Do not add or modify any other files.
Use @dlt rest api as a tutorial.
After adding the endpoints, allow the user to run the pipeline with python open_library_pipeline.py and await further instructions.
```

Feel free to tweak the prompt based on your objective. The agent will:
1. Generate the pipeline code
2. Run the pipeline
3. Load data into your local DuckDB database

All from a single prompt.

### Step 6: Debug with the Agent

If there are any errors, paste them into the chat and let the AI resolve them. This is the power of AI-assisted development: you iterate quickly without getting stuck.

### Step 7: Inspect Pipeline Data with the dlt Dashboard

Once your pipeline runs successfully, launch the dashboard to inspect your data and metadata:

```bash
dlt pipeline open_library_pipeline show
```

This opens a web app where you can:
- View pipeline state and run history
- Explore schemas, tables, and columns
- Query the loaded data
- Debug any issues

> 📖 **Reference:** [dlt Dashboard Documentation](https://dlthub.com/docs/general-usage/dashboard)

### Step 8: Inspect the Pipeline via Chat

With the dlt MCP server configured, you can ask the AI about your pipeline directly:

> "What tables were created in the pipeline?"  
> "Show me the schema for the books table."  
> "How many rows were loaded?"

The agent has access to your pipeline metadata and can answer these questions.

### Step 9 (Bonus): Build Visualizations with marimo + ibis

Take your analysis further by creating interactive reports with [marimo](https://marimo.io/) notebooks and [ibis](https://ibis-project.org/).

Prompt the agent to build a visualization:

> "Create a marimo notebook that visualizes the top 10 authors by book count. Use ibis for data access. Reference: https://dlthub.com/docs/general-usage/dataset-access/marimo"

By providing the docs link, the agent will use the correct stack.

Run your notebook:

```bash
# Edit mode (for development)
marimo edit your_notebook.py

# Run mode (view the report)
marimo run your_notebook.py
```

> 📖 **Reference:** [Explore Data with marimo](https://dlthub.com/docs/general-usage/dataset-access/marimo)

---

## Homework

You've seen me do it, now it's your turn!

See [dlt_homework.md](dlt_homework.md) for instructions.

---

## Resources

| Resource | Link |
|----------|------|
| dlt Documentation | [dlthub.com/docs](https://dlthub.com/docs) |
| Open Library Workspace Guide | [dlthub.com/workspace/source/open-library](https://dlthub.com/workspace/source/open-library) |
| dlt Dashboard Docs | [dlthub.com/docs/general-usage/dashboard](https://dlthub.com/docs/general-usage/dashboard) |
| marimo + dlt Guide | [dlthub.com/docs/general-usage/dataset-access/marimo](https://dlthub.com/docs/general-usage/dataset-access/marimo) |
| Open Library API | [openlibrary.org/developers/api](https://openlibrary.org/developers/api) |

---

*Workshop by [dltHub](https://dlthub.com) for the Data Engineering Zoomcamp 2026*
