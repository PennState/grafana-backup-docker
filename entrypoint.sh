#!/usr/bin/env bash

GRAFANA_BACKUP_DEBUG="${GRAFANA_BACKUP_DEBUG:-false}"
GRAFANA_BACKUPS_TO_KEEP="${GRAFANA_BACKUPS_TO_KEEP:-7}"

declare -a envvars=(GRAFANA_BACKUP_PATH GRAFANA_URL GRAFANA_TOKEN)

for v in "${envvars[@]}" ; do
	if [ -z "$(eval "echo \$$v")" ] ; then
		echo "Missing environment variable $v"
		exit 1
	fi
done


mkdir -p $GRAFANA_BACKUP_PATH

ts=$(date -Iseconds)

# create backups
export BACKUP_DIR=${GRAFANA_BACKUP_PATH}/${ts}

grafana-backup save
rmdir $BACKUP_DIR/{datasources,folders,alert_channels,dashboards}

# delete all but the most recent n backups
echo
echo "#############################################"
echo "Existing backups:"
ls -1tr $GRAFANA_BACKUP_PATH
echo
echo "Removing all but the most recent $GRAFANA_BACKUPS_TO_KEEP backups"
ls -1tr $GRAFANA_BACKUP_PATH | head -n -${GRAFANA_BACKUPS_TO_KEEP} | xargs -I '{}' rm -rfv $GRAFANA_BACKUP_PATH/'{}'
