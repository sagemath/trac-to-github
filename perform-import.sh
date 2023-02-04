#! /bin/sh
. ./SECRETS
set -x
curl --request POST \
  --url https://api.github.com/graphql \
  --header 'authorization: bearer '$GH_IMPORT_TOKEN \
  --header 'content-type: application/json' \
  --header 'graphql-features: gh_migrator_import_to_dotcom' \
  --data '{"query":"mutation(\n  $migrationId: ID!\n){\n  performImport(input: {migrationId: $migrationId}) {\n    migration {\n      guid\n      id\n      state\n    }\n  }\n}","variables":{"migrationId":"'$MIGRATION_ID'"}}'

#'{"query":"query(\n  $login: String!,\n  $guid: String!\n){\n  organization (login: $login) {\n    migration (\n      guid: $guid\n    )\n    {\n      guid\n      id\n      state\n\t\t\tuploadUrl\n    }\n  }\n}","variables":{"login":"sagemath","guid":"'$GUID'"}}'
