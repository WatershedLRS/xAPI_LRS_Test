Feature: Retrieve activity profile id's

Scenario: Good retrieve activity profile ids: typical request cluster

    Given a typical retrieveActivityProfileIds request cluster
    When the request is made on the primed LRS
    Then the retrieveActivityProfileIds response is verified

Scenario: Bad retrieve activity profile ids: typical request missing [property]

    Given a typical retrieveActivityProfileIds request
    Given the [property] is removed
    When the request is made
    Then the LRS responds with HTTP [HTTP]

    Where:
        HTTP | property
        401  | authority header
        400  | activityId parameter

# Pending because it will pass in 0.9 enabled LRSs, need to detect those and annotate accordingly
@Pending
Scenario: Bad retrieve activity profile ids: typical request missing version header

    Given a typical retrieveActivityProfileIds request
    Given the version header is removed
    When the request is made
    Then the LRS responds with HTTP 400

Scenario: Bad retrieve activity profile ids: [type] request with bad [property] '[value]'

    Given a [type] retrieveActivityProfileIds request
    Given the [property] is set to '[value]'
    When the request is made
    Then the LRS responds with HTTP [HTTP]

    Where:
        HTTP | type    | property             | value
        400  | typical | resource             | activity/state
        400  | typical | resource             | activities/states
        400  | typical | version header       | bad version
        400  | typical | version header       | 3.8.0
        400  | typical | authority header     | Basic badAuth
        401  | typical | authority header     | Basic TnsHNWplME1YZnc0VzdLTHRIWTo0aDdBb253Ml85WU53vSZLNlVZ
        400  | typical | activityId parameter | bad URI
