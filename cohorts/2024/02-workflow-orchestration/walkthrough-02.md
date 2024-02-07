
## Resources

- [github issue#16925 for IMPT, NOTE, WARNING admonitions etc](https://github.com/orgs/community/discussions/16925) used in `EllaNotes`
- [stackoverflow post for youtube image and play button](https://stackoverflow.com/a/76557033
- [answer by ardalis.com](https://ardalis.com/how-to-embed-youtube-video-in-github-readme-markdown/)
- https://vscode-sqltools.mteixeira.dev/en/home
- https://startlearningcode.com/2020/01/08/visual-studio-code-sqltools-extension/


## hierarchical gitignore

TODO #learninpublic post

## architecture and ports

TODO #learninpublic post

### GCP VM and Mage-ai

This is to run *local* mage on GCP VM instead of locally on WSL+Ubuntu. 

drag+drop `env.` and `nyc-rides-ella-85c8b8d18b10.json` to `cohorts/2024/02-workflow-orchestration` as these files were not committed to github.

TODO Need to research how to store these safely in GCP, think there's a SECRETS settings to configure

docker volume create --name hmwk02_volume -d local 
docker network create pg-network   

TODO check this! The entrypoint is still at `http://localhost:6789/`; with the above volume and network created.  (?)

### Deploying Mage to GCP

This is for [chapter 7 🤖-deployment](../../../02-workflow-orchestration/README.md/#227---🤖-deployment-optional)

Notes moved. See [module's README](../../../02-workflow-orchestration/README.md), under chapter 7 linked above.

Results: can provision VM and deploy mage via Terraform. But pipeline fails, at Data Exporter blocks, bacause the contents are not from docker-compose.yaml. 

```bash
root@localhost:/home/src# ls -la
total 0
```

TODO Research:
- 
- there is no buckets, but SQL this time.
- how do I hook into the postgres?
- how do I hook into the BigQuery?
- default_repo folder in Mage UI not appearing in  mave-vm SSH, presumably it would be persistent in `volume: hmwk02_volume`?
- need to try hooking into postgres DB from jupyter with 
  - connection string: `nyc-rides-ella:asia-southeast1:mage-data-vm-db-instance`

[mage-data-vm-db-instance](https://console.cloud.google.com/sql/instances/mage-data-vm-db-instance/overview?project=nyc-rides-ella)
- nyc-rides-ella:asia-southeast1:mage-data-vm-db-instance

```
Environment variables (7)
Name Value
GCP_PROJECT_ID	nyc-rides-ella	
GCP_REGION	asia-southeast1	
GCP_SERVICE_NAME	mage-data-vm	
ULIMIT_NO_FILE	16384	
FILESTORE_IP_ADDRESS	10.220.170.74	
FILE_SHARE_NAME	share1	
MAGE_DATABASE_CONNECTION_URL	postgresql://mageuser:postgres@/mage-data-vm-db?host=/cloudsql/nyc-rides-ella:asia-southeast1:mage-data-vm-db-instance
```



## SqlTools install

issue with node runtime

db drivers @tag::



TODO
If the service we just edited with the Roles are not showing up, it's because we need to redownload and sftp it into the VM storage? 
Ans: Not according to GCP docs. Need to locate the source again.

No containers running.
```bash
docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## GCP Cloud SQL resources

Need to understand these:

- https://cloud.google.com/sql/docs/postgres/connect-overview#external-connection-methods
- https://cloud.google.com/knowledge/kb/access-environment-variables-in-jupyter-notebook-000004403
