#! /bin/sh
. ./SECRETS
set -x
curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_IMPORT_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/sagemath/migrations
