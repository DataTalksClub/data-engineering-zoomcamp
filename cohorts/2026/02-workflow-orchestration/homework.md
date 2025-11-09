## Module 2 Homework

ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format, please include these directly in the README file of your repository.

> In case you don't get one option exactly, select the closest one 

For the homework, we'll be working with the _green_ taxi dataset located here:

`https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/green/download`

To get a `wget`-able link, use this prefix (note that the link itself gives 404):

`https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/`

### Assignment

So far in the course, we processed data for the year 2019 and 2020. Your task is to extend the existing flows to include data for the year 2021.

![homework datasets](../../../02-workflow-orchestration/images/homework.png)

As a hint, Kestra makes that process really easy:
1. You can leverage the backfill functionality in the [scheduled flow](../../../02-workflow-orchestration/flows/05_gcp_taxi_scheduled.yaml) to backfill the data for the year 2021. Just make sure to select the time period for which data exists i.e. from `2021-01-01` to `2021-07-31`. Also, make sure to do the same for both `yellow` and `green` taxi data (select the right service in the `taxi` input).
2. Alternatively, run the flow manually for each of the seven months of 2021 for both `yellow` and `green` taxi data. Challenge for you: find out how to loop over the combination of Year-Month and `taxi`-type using `ForEach` task which triggers the flow for each combination using a `Subflow` task.

### Quiz Questions

Complete the Quiz shown below. It's a set of 12 multiple-choice questions to test your understanding of workflow orchestration, Kestra, ETL pipelines for data lakes and warehouses, and AI workflows with agents.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537.299
- 24,648,499
- 18,324,219
- 29,430,127

4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

---

### AI Workflows & Agents Questions

The following questions test your understanding of AI Copilot, RAG (Retrieval Augmented Generation), and AI Agents in Kestra. Make sure you have completed Section 5 of Module 2 before attempting these questions.

7) After trying the same prompt in ChatGPT vs Kestra Copilot ("Create a Kestra flow that loads NYC taxi data from CSV to BigQuery"), what is the primary reason Copilot generates better Kestra flows?
- Copilot uses a more powerful model
- Copilot has access to current Kestra plugin documentation
- Copilot uses more tokens
- Copilot has internet access

8) Run both `06_chat_without_rag.yaml` and `07_chat_with_rag.yaml` flows and compare their outputs. Both ask: "Which features were released in Kestra 1.1?" When comparing the outputs, what difference do you observe?
- RAG version provides specific, accurate feature details grounded in the documentation
- Both produce identical results
- Non-RAG version is more detailed and accurate
- RAG version hallucinates more features than the non-RAG version

9) Run the `08_simple_agent.yaml` flow twice: first with `summary_length` = "short", then with `summary_length` = "long". Check the token usage logged at the end of each execution. How does token usage differ between short and long summaries for the `multilingual_agent` task?
- No significant difference (within 10% variance)
- Long summary uses 2-4x more output tokens than short summary
- Short summary uses more tokens due to compression complexity
- Token usage is identical regardless of length

10) Run the `09_web_research_agent.yaml` flow with the default research topic about data orchestration trends. In this flow, who decides when to use the web search tool?
- The workflow designer specifies exact tool usage order in YAML
- The agent autonomously decides based on the prompt and system message
- Tools are called randomly by the LLM
- Web search runs on every agent execution automatically

11) Examine the `10_multi_agent_research.yaml` flow and run it with the default company (kestra.io). What is the role of the research agent in this multi-agent system?
- It makes final decisions about company analysis and structures the output
- It serves as a tool for the main agent to gather web data
- It summarizes the main agent's findings into a report
- It validates the main agent's output for accuracy

12) Based on what you learned in Section 5, for production workflows requiring deterministic, repeatable results with strict compliance requirements (e.g., financial reporting), which approach is most appropriate?
- Always use AI agents for maximum flexibility and adaptation
- Use traditional task-based workflows for predictability and auditability
- Use only RAG without agents for better performance
- Use web search tools exclusively to ensure current data

---

## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw2
* Check the link above to see the due date

## Solution

Will be added after the due date
