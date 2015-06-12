#!/bin/sh -e

cd src
npm update
npm install

export ENDPOINT=`curl -u $KEY:$SECRET dev.watershedlrs.com/api/organizations -XPOST -d'{"name": "Canformance Test ${BUILD_NUMBER}"}' -H "Content-Type: application/json" -i -s | grep Location: | sed 's/Location: //'`

function cleanup {
    curl -u $KEY:$SECRET -H "Content-Type: application/json" -XDELETE $ENDPOINT
}


trap cleanup EXIT

(
set +e
grunt jshint --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=jshint-test-results.xml
grunt mochaTest:stage1-core --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-core-test-results.xml
grunt mochaTest:stage1-adhocValid --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-adhocValid-test-results.xml
grunt mochaTest:stage1-adhocInvalid --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-adhocInvalid-test-results.xml
grunt primeLRS --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=primeLRS-test-results.xml
grunt mochaTest:stage1-conflict --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage1-conflict-test-results.xml
grunt updateConsistent --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=updateConsistent-test-results.xml
grunt mochaTest:stage2-statementStructure --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-statementStructure-test-results.xml
grunt retrieveConflictStatements --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=retrieveConflictStatements-test-results.xml
grunt mochaTest:stage2-conflict --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-conflict-test-results.xml
grunt mochaTest:stage2-streamQueries --endpoint=$ENDPOINT/lrs --username=$KEY --password=$SECRET --xapi-version=1.0.0 --reporter=xunit --captureFile=stage2-streamQueries-test-results.xml
)
