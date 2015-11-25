#!/bin/bash

set -e

function cleanup {
    curl -k -u $KEY:$SECRET -H "Content-Type: application/json" -XDELETE $ORGANIZATION
}

trap cleanup EXIT

cd src
npm install

ORGANIZATION=`curl -k -vvv -u $KEY:$SECRET https://$HOST/api/organizations -XPOST -d"{\"name\": \"Canformance Test $BUILD_NUMBER\"}" -H "Content-Type: application/json" -i -s | grep Location: | sed 's/Location: //' | tr -d '\r'`
if [ -z "$ORGANIZATION" ]; then
    echo "couldn't create organization, failing."
    exit -1
fi

export ENDPOINT="${ORGANIZATION}/lrs"
echo $ENDPOINT

set +e
rm config.json
grunt --xapi-version=1.0.2 --endpoint=$ENDPOINT --username=$KEY --password=$SECRET --reporter=xunit --captureFile=test-results.xml 
