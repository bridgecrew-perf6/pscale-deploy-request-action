function create-deploy-request {
    local DB_NAME=$1
    local BRANCH_NAME=$2
    local ORG_NAME=$3

    local raw_output=`pscale deploy-request create "$DB_NAME" "$BRANCH_NAME" --org "$ORG_NAME" --format json`
    if [ $? -ne 0 ]; then
        echo "Deploy request could not be created: $raw_output"
        exit 1
    fi
    local deploy_request_number=`echo $raw_output | jq -r '.number'`
    # if deploy request number is empty, then error
    if [ -z "$deploy_request_number" ]; then
        echo "Could not retrieve deploy request number: $raw_output"
        exit 1
    fi

    local deploy_request="https://app.planetscale.com/${ORG_NAME}/${DB_NAME}/deploy-requests/${deploy_request_number}"
    echo "Check out the deploy request created at $deploy_request"
    # if CI variable is set, export the deploy request URL
    if [ -n "$CI" ]; then
        echo "::set-output name=DEPLOY_REQUEST_URL::$deploy_request"
        echo "::set-output name=DEPLOY_REQUEST_NUMBER::$deploy_request_number"
        create-diff-for-ci "$DB_NAME" "$ORG_NAME" "$deploy_request_number" "$BRANCH_NAME"
    fi   
}

function create-diff-for-ci {
    local DB_NAME=$1
    local ORG_NAME=$2
    local deploy_request_number=$3 
    local BRANCH_NAME=$4
    local refresh_schema=$5

    local deploy_request="https://app.planetscale.com/${ORG_NAME}/${DB_NAME}/deploy-requests/${deploy_request_number}"
    local BRANCH_DIFF="Diff could not be generated for deploy request $deploy_request"

    # updating schema for branch
    if [ -n "$refresh_schema" ]; then
        pscale branch refresh-schema "$DB_NAME" "$BRANCH_NAME" --org "$ORG_NAME"
    fi  

    local lines=""
    # read shell output line by line and assign to variable
    while read -r line; do
        lines="$lines\n$line"
    done < <(pscale deploy-request diff "$DB_NAME" "$deploy_request_number" --org "$ORG_NAME" --format=json | jq .[].raw)

    
    if [ $? -ne 0 ]; then
        BRANCH_DIFF="$BRANCH_DIFF : ${lines}"
    else
        BRANCH_DIFF=$lines
    fi

    if [ -n "$CI" ]; then
        BRANCH_DIFF="${BRANCH_DIFF//'"'/''}"
        BRANCH_DIFF="${BRANCH_DIFF//'%'/'%25'}"
        BRANCH_DIFF="${BRANCH_DIFF//'\n'/'%0A'}"
        BRANCH_DIFF="${BRANCH_DIFF//'\r'/'%0D'}"
        echo "::set-output name=BRANCH_DIFF::$BRANCH_DIFF"
    fi
}