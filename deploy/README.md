# 360medical deployment script

Deploy Symfony2 application without breaking end user service by using symlinks.

Supports assets, symlinks, cache clearing and all other common Sf2 post deploy tasks.

## Installation

```
cd /somewhere/convenient
wget https://github.com/adadgio/deploy/archive/1.2.zip && unzip 1.2.zip && rm 1.2.zip
chmod +x deploy.sh
sudo ln -s /somewhere/convenient/deploy.sh /usr/local/bin/deploy
```

## Prerequisites

Have the following files and directory in the Sf2 project.

```
deploy/
    include.txt (optional)
    exclude.txt
    conf-staging.cnf
    conf-staging.cnf (optional)
```

## Commands

Deploy to a new version or override existing version.

```
deploy --env=staging --version=2.2.1 --verbose
# deploy --e=staging -v=2.2.1
```

Rollback to a specific version.

```
deploy --env=staging --version=2.2.0 --rollback
```

Read current remotely deployed live version vs local version.

```
deploy --env=staging --status
```

Clean older version (safe).

```
deploy --version=2.2.1 --env=staging --clean
```
