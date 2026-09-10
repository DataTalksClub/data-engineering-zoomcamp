# Bonus: Deploy to the Cloud (Optional)

Now that we've got all our pipelines working and we know how to quickly create new flows with Kestra's AI Copilot, we can deploy Kestra to the cloud so it can continue to orchestrate our scheduled pipelines.

In this bonus section, we'll cover how you can deploy Kestra on Google Cloud and automatically sync your workflows from a Git repository.


*Cloud deployment connects reviewed workflow code to scheduled execution while keeping credentials in a separate secret store.*

Note: When committing your workflows to Kestra, make sure your workflow doesn't contain any sensitive information. You can use [Secrets](https://go.kestra.io/de-zoomcamp/secret) and the [KV Store](https://go.kestra.io/de-zoomcamp/kv-store) to keep sensitive data out of your workflow logic.

## Resources
- [Install Kestra on Google Cloud](https://go.kestra.io/de-zoomcamp/gcp-install)
- [Moving from Development to Production](https://go.kestra.io/de-zoomcamp/dev-to-prod)
- [Using Git in Kestra](https://go.kestra.io/de-zoomcamp/git)
- [Deploy Flows with GitHub Actions](https://go.kestra.io/de-zoomcamp/deploy-github-actions)
