#!/bin/bash

gitlabBackupDir="/var/opt/gitlab/backups"
mattermostDir="/var/opt/gitlab/mattermost"

# prepare
rm -rf $gitlabBackupDir/mattermost
mkdir -p $gitlabBackupDir/mattermost/data

# backup data
cp -R $mattermostDir/* $gitlabBackupDir/mattermost/data
# backup postgres
su - mattermost -c "/opt/gitlab/embedded/bin/pg_dump -U gitlab_mattermost -h /var/opt/gitlab/postgresql -p 5432 mattermost_production" > $gitlabBackupDir/mattermost/mattermost_production_backup.sql

# package and cleanup
backupfile=$(date +%s_%Y_%m_%d)_mattermost_backup.tar.gz
tar -zcf $gitlabBackupDir/$backupfile $gitlabBackupDir/mattermost
rm -rf $gitlabBackupDir/mattermost
