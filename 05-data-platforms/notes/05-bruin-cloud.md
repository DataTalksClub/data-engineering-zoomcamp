# 5.5 - Deploying to Bruin Cloud

## What is Bruin Cloud?

Bruin Cloud is a fully managed infrastructure for your data pipelines. It is powered by the same open-source CLI tool you use locally for development. Everything lives in the same place:

- Ingestions and transformations
- Quality checks and monitoring
- Lineage and metadata
- Data governance
- AI-powered features (automatic metadata generation, conversational data analysis)

## Registration

1. Go to [Bruin Cloud](https://getbruin.com/) and sign up
2. Fill out your name, email, and set a password
3. Verify your email by clicking the link in the verification email
4. Choose to join an existing team or create a new organization
5. Give your organization a name

## Connecting your GitHub repository

You have two options:

1. **Direct GitHub connection** (recommended) — connect your GitHub account directly and select your repo from a dropdown
2. **Personal Access Token** — provide a GitHub personal access token and your repo link manually

## Setting up connections

After connecting your repo, set up your data warehouse connections. These are the same connections you configure locally in `.bruin.yml`, but stored securely in the cloud.

1. Go to the connections page
2. Select your connection type (MotherDuck, BigQuery, Redshift, etc.)
3. Give it the same connection name you use locally
4. Provide the required credentials (e.g., service token, database name)
5. The connection will be validated and tested automatically

Read the Bruin documentation for details on how secrets are stored securely.

## Deploying pipelines

1. Navigate to the **Pipelines** page to see the list of pipelines from your repository
2. Bruin will validate every asset and ensure lineage and connections work (this takes a moment)
3. Once ready, **enable** the pipeline

When you enable a pipeline with a schedule, Bruin automatically creates a run for the last interval. For example, a monthly pipeline will immediately process the previous month's data.

## Monitoring

After a pipeline runs:

- Check the status of each asset (success/failure)
- Review quality check results
- View lineage across all assets
- Use AI-powered features to analyze data or ask questions about your pipelines

## Getting help

- Join the [Bruin Slack community](https://getbruin.com/) for questions and feature requests
- Submit issues on [GitHub](https://github.com/bruin-data/bruin)
