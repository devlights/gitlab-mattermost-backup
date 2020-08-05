# gitlab-mattermost-backup

本リポジトリは、 [gitlab-tools/gitlab-mattermost-backup](https://github.com/gitlab-tools/gitlab-mattermost-backup) のフォークです。

元スクリプトが、AWSにアップロードをする動きになっていたので、ローカルでホストしている場合でバックアップ出来るよう少し調整しました。

利用される場合は、ブランチを master から change-localhost-purpose に切り替えてご利用ください。

以下のようにして、バックアップ設定を行います。

```sh
$ cd $HOME

# git を インストール（存在しなければ）
$ which git
$ sudo apt install -y git

# 作業場所を確保して、スクリプトをクローン
$ mkdir tmp; cd tmp
$ git clone https://github.com/devlights/gitlab-mattermost-backup
$ cd gitlab-mattermost-backup/
$ git checkout change-localhost-purpose

# Mattermost バックアップスクリプト を所定の場所に配置
$ sudo cp backup_mattermost.sh "$(dirname $(which gitlab-backup))"/

# root の cron タスクとして追加
$ sudo crontab -e -u root
# 以下を追加
0 5 * * * /usr/bin/backup_mattermost.sh

```

ここから下は フォーク元の README の記載です。
---

Gitlab ships mattermost in the omnibus package without backup script.

This repository contains a simple script to backup the mattermost data and uploads it to s3.

## Prerequisites

The AWS cli must be installed for user root. See [official install guide](http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html).

run `aws configure` or set the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in config file. 

## Installation

Clone the repository and create a `backup_mattermost.conf` file.

```bash
git clone https://github.com/gitlab-tools/gitlab-mattermost-backup.git && cd gitlab-mattermost-backup && cp backup_mattermost.conf.sample backup_mattermost.conf
```

## Configuration

See: [backup_mattermost.conf.sample](backup_mattermost.conf.sample)

## Usage

Just execute the script:

```bash
./backup_mattermost.sh
```

## Setup cron job

Run the backup everyday at 2:00 am everyday.

```bash
crontab -e
```

and add following line:

```bash
0 2 * * * /path/to/backup_mattermost/backup_mattermost.sh
```

## Restore

Install gitlab omnibus and execute following commands:

```bash
tar -zxvf %s_%Y_%m_%d_mattermost.tar.gz -C /tmp/
mv /tmp/mattermost/data/* /var/opt/gitlab/mattermost/
su - mattermost -c "/opt/gitlab/embedded/bin/psql -U gitlab_mattermost -h /var/opt/gitlab/postgresql -p 5432 mattermost_production" < /tmp/mattermost/mattermost_production_backup.sql
rm -rf /tmp/mattermost
```
