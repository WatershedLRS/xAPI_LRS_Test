Feature: Save state

Scenario: Good save state: [type] request

    Given a [type] saveState request
    When the request is made
    Then the LRS responds with HTTP 204

    Where:
        type
        typical
        JSON
        withRegistration

Scenario: Good save state: [type] request missing [property]

    Given a [type] saveState request
    Given the [property] is removed
    When the request is made
    Then the LRS responds with HTTP 204

    Where:
        type             | property
        typical          | Content-Type header
        typical          | content
        JSON             | content
        withRegistration | Content-Type header
        withRegistration | content

Scenario: Good save state: [type] request with [property] set to [value]

    Given a [type] saveState request
    Given the [property] is set to [value]
    When the request is made
    Then the LRS responds with HTTP 204

    Where:
        type             | property             | value
        typical          | agent parameter      | an mboxAndType agent
        typical          | agent parameter      | an mboxSha1AndType agent
        typical          | agent parameter      | an openidAndType agent
        typical          | agent parameter      | an accountAndType agent
        typical          | agent parameter      | an mboxOnly agent
        typical          | agent parameter      | an mboxSha1Only agent
        typical          | agent parameter      | an openidOnly agent
        typical          | agent parameter      | an accountOnly agent
        typical          | content              | a typical statement
        withRegistration | agent parameter      | an mboxAndType agent
        withRegistration | agent parameter      | an mboxSha1AndType agent
        withRegistration | agent parameter      | an openidAndType agent
        withRegistration | agent parameter      | an accountAndType agent
        withRegistration | agent parameter      | an mboxOnly agent
        withRegistration | agent parameter      | an mboxSha1Only agent
        withRegistration | agent parameter      | an openidOnly agent
        withRegistration | agent parameter      | an accountOnly agent
        withRegistration | content              | a typical statement

Scenario: Good save state: [type] request with [property] set to '[value]'

    Given a [type] saveState request
    Given the [property] is set to '[value]'
    When the request is made
    Then the LRS responds with HTTP 204

    Where:
        type    | property            | value
        typical | Content-Type header | application/unknown
        typical | stateId parameter   | test state id
        typical | content             | test content
        JSON    | method              | POST

Scenario: Bad save state: typical request missing [property]

    Given a typical saveState request
    Given the [property] is removed
    When the request is made
    Then the LRS responds with HTTP [HTTP]

    Where:
        HTTP | property
        400  | version header
        401  | authority header
        400  | stateId parameter
        400  | activityId parameter
        400  | agent parameter

Scenario: Bad save state: [type] request with bad agent parameter an empty agent

    Given a [type] saveState request
    Given the agent parameter is set to an empty agent
    When the request is made
    Then the LRS responds with HTTP 400

    Where:
        type
        typical
        withRegistration

Scenario: Bad save state: [type] request with bad [property] '[value]'

    Given a [type] saveState request
    Given the [property] is set to '[value]'
    When the request is made
    Then the LRS responds with HTTP [HTTP]

    Where:
        HTTP | type             | property               | value
        400  | typical          | resource               | activity/state
        400  | typical          | resource               | activities/states
        400  | typical          | version header         | bad version
        400  | typical          | version header         | 3.8.0
        400  | typical          | authority header       | Basic badAuth
        401  | typical          | authority header       | Basic TnsHNWplME1YZnc0VzdLTHRIWTo0aDdBb253Ml85WU53vSZLNlVZ
        400  | typical          | method                 | POST
        400  | typical          | activityId parameter   | bad URI
        400  | withRegistration | activityId parameter   | bad URI
        400  | withRegistration | registration parameter | bad UUID
        400  | typical          | Content-Type header    | bad content type

Scenario: Bad save state: typical request with [modifier] agent parameter with bad [property] '[value]'

    Given a typical saveState request
    Given the agent parameter is set to a [modifier] agent
    Given the params agent [property] is set to '[value]'
    When the request is made
    Then the LRS responds with HTTP 400

    Where:
        modifier       | property         | value
        mboxAndType    | mbox             | conformancetest@tincanapi.com
        mboxAndType    | mbox             | bad mbox
        mboxAndType    | objectType       | notAgent
        mboxAndType    | objectType       | Activity
        mboxOnly       | mbox             | conformancetest@tincanapi.com
        mboxOnly       | mbox             | bad mbox
        mboxAndType    | objectType       | agent
        openidAndType  | openid           | bad URI
        openidOnly     | openid           | bad URI
        accountAndType | account homePage | bad URI
        accountOnly    | account homePage | bad URI

Scenario: Bad save state: typical request [modifier] agent parameter missing [property]

    Given a typical saveState request
    Given the agent parameter is set to a [modifier] agent
    Given the params agent [property] is removed
    When the request is made
    Then the LRS responds with HTTP 400

    Where:
        modifier       | property
        accountAndType | account homePage
        accountAndType | account name
        accountOnly    | account homePage
        accountOnly    | account name
        mboxAndType    | mbox
