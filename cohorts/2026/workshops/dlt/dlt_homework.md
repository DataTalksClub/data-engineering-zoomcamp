# Homework: Build Your Own dlt Pipeline

You've seen how to build a pipeline with a scaffolded source. Now it's your turn to do it from scratch with a **custom API**.

## The Challenge

Build a dlt pipeline that loads NYC taxi trip data from a custom API into DuckDB.

## Data Source

You'll be working with **NYC Yellow Taxi trip data** from a custom API (not available as a dlt scaffold). This dataset contains records of individual taxi trips in New York City, including:

- Pickup and dropoff timestamps
- Trip distance
- Fare amount and payment type
- Tip amount
- Passenger count

| Property | Value |
|----------|-------|
| Base URL | `https://us-central1-dlthub-analytics.cloudfunctions.net/data_engineering_zoomcamp_api` |
| Format | Paginated JSON |
| Page Size | 1,000 records per page |
| Pagination | Stop when an empty page is returned |

## Setup Instructions

Since this API is custom (not one of the scaffolds in dlt workspace), the setup is slightly different.

### Step 1: Create a New Project (or Reuse Your Demo Project)

If you already created a project folder while following along with the workshop demo, you can reuse that folder. Otherwise, create a new one:

```bash
mkdir taxi-pipeline
cd taxi-pipeline
```

Open this folder in Cursor (or your preferred agentic IDE).

### Step 2: Set Up the dlt MCP Server (If Not Already Done)

In Cursor, go to **Settings → Tools & MCP → New MCP Server**. This will open (or create) the `.cursor/mcp.json` file.

Add the following configuration:

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

This enables the dlt MCP server, giving the AI access to dlt documentation, code examples, and your pipeline metadata.

### Step 3: Install dlt

```bash
pip install "dlt[workspace]"
```

### Step 4: Initialize the Project

```bash
dlt init dlthub:taxi_pipeline duckdb
```

You can name the project whatever you like. Since this API has no scaffold, the command will create:
- The dlt project files
- Cursor rules for AI assistance

**But no YAML file with API metadata.** You will need to provide the API information yourself.

### Step 5: Prompt the Agent

Now use your AI assistant to build the pipeline. You'll need to provide the API details in your prompt since there's no scaffold.

Here's an example to get you started:

```
Build a REST API source for NYC taxi data.

API details:
- Base URL: https://us-central1-dlthub-analytics.cloudfunctions.net/data_engineering_zoomcamp_api
- Data format: Paginated JSON (1,000 records per page)
- Pagination: Stop when an empty page is returned

Place the code in taxi_pipeline.py and name the pipeline taxi_pipeline.
Use @dlt rest api as a tutorial.
```

### Step 6: Run and Debug

Run your pipeline and iterate with the agent until it works:

```bash
python taxi_pipeline.py
```

---

## Questions

Once your pipeline has run successfully, use the methods covered in the workshop to investigate the following:

- **dlt Dashboard**: `dlt pipeline taxi_pipeline show`
- **dlt MCP Server**: Ask the agent questions about your pipeline
- **Marimo Notebook**: Build visualizations and run queries

**Questions to answer:**

1. What is the start date and end date of the dataset?
2. What proportion of trips are paid with credit card?
3. How long in duration is the average trip?
4. How long in distance is the average trip?
5. What is the total amount of money generated in tips?

We challenge you to try out the different methods explored in the workshop when answering these questions to see what works best for you. Feel free to share your thoughts on what worked (or didn't) in your submission!

### Resources

| Resource | Link |
|----------|------|
| dlt Dashboard Docs | [dlthub.com/docs/general-usage/dashboard](https://dlthub.com/docs/general-usage/dashboard) |
| marimo + dlt Guide | [dlthub.com/docs/general-usage/dataset-access/marimo](https://dlthub.com/docs/general-usage/dataset-access/marimo) |
| dlt Documentation | [dlthub.com/docs](https://dlthub.com/docs) |

---

## Submitting the Solutions

**Form for submitting:** Link will be provided later

**Deadline:** TBD

We will publish the solution here after the deadline.

---

## Tips

- The API returns paginated data. Make sure your pipeline handles pagination correctly.
- If the agent gets stuck, paste the error into the chat and let it debug.
- Use the dlt MCP server to ask questions about your pipeline metadata.

Good luck!
