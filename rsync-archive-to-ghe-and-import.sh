#!/bin/sh
set -eu
. ./SECRETS
set -x
if [ -z "${GUID-}" ]; then
    # We start a fresh migration, keyed to current time
    GUID=cae4a192-8fed-11ed-84b0-$(date +"%y%m%d%H%M%S")
fi
if [ -z "${TARGET_REPO-}" ]; then
    # Freshly named repository for each migration attempt
    TARGET_REPO=sage-$(date +"%Y%m%d%H%M%S")
fi
sed -e "s/@HOST_IP@/$HOST_IP/;s/@TARGET_REPO@/$TARGET_REPO/" map-ghe.csv.in > map-ghe.csv
#RSYNC_OPTIONS=--stats
RSYNC_OPTIONS=--verbose
if [ -z "${REMOTE_WORK_DIR-}" ]; then
    REMOTE_WORK_DIR=.
fi
rsync $RSYNC_OPTIONS --delete --rsh='ssh -p122' -a archive map-ghe.csv admin@$HOST_IP:$REMOTE_WORK_DIR
# import
time ssh -p 122 admin@$HOST_IP "set -x;
    (cd $REMOTE_WORK_DIR/archive && tar cfz - .) > archive.tgz &&
    (ghe-migrator list | grep -q $GUID || ghe-migrator prepare archive.tgz -g $GUID) &&
    ghe-migrator map -i $REMOTE_WORK_DIR/map-ghe.csv -g $GUID &&
    if ghe-migrator import archive.tgz -g $GUID  -u mkoeppe -p $IMPORT_TOKEN; then
        ghe-migrator audit -g $GUID;
        ghe-migrator unlock -g $GUID;
    else
        ghe-migrator conflicts -g $GUID | tee conflicts.csv;
    fi;
    grep guid=$GUID /var/log/github/ghe-migrator.log"
