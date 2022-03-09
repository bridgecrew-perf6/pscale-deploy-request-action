#!/bin/bash

ORG_NAME=$1
DB_NAME=$2
BRANCH_NAME=$3

. ps-authenticate.sh
. ps-helper-functions.sh
create-deploy-request "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"

