#!/bin/bash

set -e

function cleanup {
    curl -u $KEY:$SECRET -H "Content-Type: application/json" -XDELETE $ORGANIZATION
}

trap cleanup EXIT

cd src
npm install

ORGANIZATION=`curl -u $KEY:$SECRET https://$HOST/api/organizations -XPOST -d"{\"name\": \"Canformance Test $BUILD_NUMBER\"}" -H "Content-Type: application/json" -i -s | grep Location: | sed 's/Location: //' | tr -d '\r'`
if [ -z "$ORGANIZATION" ]; then
    echo "couldn't create organization, failing."
    exit -1
fi

export ENDPOINT="${ORGANIZATION}/lrs"
echo $ENDPOINT

set +e
grunt jshint --endpoint=$ENDPOINT --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=jshint-test-results.xml
grunt mochaTest:stage1-core --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-core-test-results.xml
grunt mochaTest:stage1-adhocValid --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-adhocValid-test-results.xml
grunt mochaTest:stage1-adhocInvalid --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-adhocInvalid-test-results.xml
grunt primeLRS --xapi-version=1.0.0 --reporter=xunit --captureFile=primeLRS-test-results.xml
grunt mochaTest:stage1-conflict --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-conflict-test-results.xml
grunt updateConsistent --xapi-version=1.0.0 --reporter=xunit --captureFile=updateConsistent-test-results.xml
grunt mochaTest:stage2-statementStructure --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-statementStructure-test-results.xml
grunt retrieveConflictStatements --xapi-version=1.0.0 --reporter=xunit --captureFile=retrieveConflictStatements-test-results.xml
grunt mochaTest:stage2-conflict --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-conflict-test-results.xml
grunt mochaTest:stage2-streamQueries --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-streamQueries-test-results.xml
