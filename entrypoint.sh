#!/usr/bin/env bash

declare -a envvars=(GRAFANA_BACKUP_PATH GRAFANA_BACKUPS_TO_KEEP GRAFANA_URL GRAFANA_TOKEN)

for v in "${envvars[@]}" ; do
	if [ -z "$(eval "echo \$$v")" ] ; then
		echo "Missing environment variable $v"
		exit 1
	fi
done

mkdir -p $GRAFANA_BACKUP_PATH

ts=$(date -Iseconds)

# create backups
export BACKUP_DIR=${GRAFANA_BACKUP_PATH}/${ts}/${d}

grafana-backup save

# delete all but the most recent n backups
echo
echo "#############################################"
echo "Existing backups:"
ls -1tr $GRAFANA_BACKUP_PATH
echo
echo "Removing all but the most recent $GRAFANA_BACKUPS_TO_KEEP backups"
ls -1tr $GRAFANA_BACKUP_PATH | head -n -${GRAFANA_BACKUPS_TO_KEEP} | xargs -I '{}' rm -rfv $GRAFANA_BACKUP_PATH/'{}'
