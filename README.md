# grafana-backup-docker

This is a simple docker image containing grafana-backup-tool[1] and a custom entrypoint to backup up the dashboards, datasources, and folders from Grafana to local disk. 

The intent is to run this as a CronJob alongside a grafana instance, writing to a PersistentVolumeClaim. A PVC, even if not truly persistent, will provide some level of resilience and the ability to restore should grafana's database be lost or become corrupt.

Future work could include the option to backup straight to S3.

## Usage

Environment variables:
* `GRAFANA_BACKUP_PATH` - where to save the backups to
* `GRAFANA_BACKUPS_TO_KEEP` - how many backups to keep
* `GRAFANA_URL` - base url for the grafana instance
* `GRAFANA_TOKEN` - API token with admin rights to the grafana instance
