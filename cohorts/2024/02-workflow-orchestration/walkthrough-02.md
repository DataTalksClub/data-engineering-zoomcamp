
## Resources

- [github issue#16925 for IMPT, NOTE, WARNING admonitions etc](https://github.com/orgs/community/discussions/16925) used in `EllaNotes`
- [stackoverflow post for youtube image and play button](https://stackoverflow.com/a/76557033
- [answer by ardalis.com](https://ardalis.com/how-to-embed-youtube-video-in-github-readme-markdown/)
- https://vscode-sqltools.mteixeira.dev/en/home
- https://startlearningcode.com/2020/01/08/visual-studio-code-sqltools-extension/


## hierarchical gitignore



## architecture and ports

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


## SqlTools install

issue with node runtime

db drivers @tag::



TODO
If the service we just edited with the Roles are not showing up, it's because we need to redownload and sftp it into the VM storage.

No containers running.
```bash
docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
