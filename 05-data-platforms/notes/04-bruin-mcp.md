# 5.4 - Using Bruin MCP with AI Agents

## What is Bruin MCP?

MCP stands for **Model Context Protocol**. Bruin MCP is a way for AI agents (in Cursor, VS Code, Claude, etc.) to communicate with Bruin — querying documentation, running commands on your behalf, going through your code, troubleshooting, and analyzing data.

With the Bruin MCP and an AI agent, you can:

- Write pipeline code and asset configurations
- Write documentation and metadata
- Troubleshoot errors and debug issues
- Run queries and analyze data using natural language
- Ask questions about your pipeline logic and structure

## Installing Bruin MCP in Cursor / VS Code

1. Open your IDE settings
2. Go to **Tools and MCP**
3. Click **New MCP**
4. Go to the [Bruin MCP documentation](https://getbruin.com/docs/bruin/getting-started/bruin-mcp) and copy the configuration
5. Paste into your MCP JSON configuration
6. If it shows a failure/error, close and reopen your IDE — you should see "Bruin enabled"

Bruin also has integrations with other agents (Claude Code, etc.) — check the [MCP docs](https://getbruin.com/docs/bruin/getting-started/bruin-mcp) for details.

## Building a pipeline with MCP

### Using the template prompt

The zoomcamp template includes an example prompt in its README that you can give to the AI agent to create the entire pipeline end-to-end:

```bash
bruin init zoomcamp my-taxi-pipeline
```

Open the generated `README.md` — it contains a prompt you can paste into the agent to scaffold the entire pipeline automatically.

### What the agent does

When given the pipeline prompt, the agent will:

1. Create all pipeline assets (ingestion, staging, reports)
2. Configure materialization strategies and dependencies
3. Set up quality checks and column metadata
4. Validate the pipeline with `bruin validate`
5. Run the pipeline with a test date range
6. Run custom checks to validate query logic
7. Execute verification queries using `bruin query`

### Working incrementally

In practice, you may prefer working asset by asset rather than generating everything at once. This lets you be involved in every design choice:

- Create and test the ingestion asset first
- Then build the staging layer
- Then add the reports layer
- Review and adjust quality checks at each step

## Querying data with the agent

Once your pipeline has run, you can use the agent conversationally to query your data:

**Example queries:**
- "Query the staging table and tell me how many days of data we have"
- "Which day had the highest number of trips and total fare?"
- "In which asset are we aggregating data?"

The agent understands the context of your pipeline — it knows the table structures, can write SQL queries, and can explain the logic behind each asset. This is useful for:

- Ad hoc analysis without writing SQL manually
- Understanding unfamiliar pipeline logic
- Data validation and troubleshooting
- Onboarding new team members to an existing pipeline
