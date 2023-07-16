@locationtest
Feature: location

  Background:
    * url "http://api.weatherbit.io"

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @wetherlan
  Scenario: get weather for lang and lat
    Given path '/v2.0/current'
    And header Content-Type = 'application/json'
    And param lat = "-43.00311"
    And param lon = "113.6594"
    And param key = "ce735350b0ed424d8e39fc071853ff6f"
    When method get
    Then status 200
    And print response

  @wetherlan2
  Scenario Outline: get weather for lang and lat
    * def query = { lat: '<lat>', lon: '<lon>',key: '<key>' }
    Given path '/v2.0/current'
    And params query
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    Examples:
      | lat | lon |key|
      | -43.00311   | 113.6594      |ce735350b0ed424d8e39fc071853ff6f|
      | 54   | 2     |ce735350b0ed424d8e39fc071853ff6f|


