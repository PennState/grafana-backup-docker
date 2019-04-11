#!/usr/bin/env bash

declare -a envvars=(GRAFANA_BACKUP_PATH GRAFANA_BACKUPS_TO_KEEP GRAFANA_URL GRAFANA_TOKEN)

for v in "${envvars[@]}" ; do
	if [ -z "$(eval "echo \$$v")" ] ; then
		echo "Missing environment variable $v"
		exit 1
	fi
done

mkdir -p $GRAFANA_BACKUP_PATH

ts=$(date --iso-8601=seconds)

alias python=python3

# create backups
for d in Dashboards Datasources Folders ; do
	p=${GRAFANA_BACKUP_PATH}/${ts}/${d}
	mkdir -p ${p}
	python /opt/grafana-backup-tool/save${d}.py ${p} || exit 0
	tar -czvf ${p}.tar.gz ${p}
	rm -rf ${p}
done

# delete all but the most recent n backups
ls -1tr | head -n -${GRAFANA_BACKUPS_TO_KEEP} | xargs -d '\n' -f -- 2>/dev/null
