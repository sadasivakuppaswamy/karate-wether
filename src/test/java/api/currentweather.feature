@locationtest
Feature: location

  Background:
    * url BASE_URL

  @currentwetherBylonlat
  Scenario: get weather for lang and lat
    Given path '/v2.0/current'
    And header Content-Type = 'application/json'
    And params paramDetails
    When method get
    #Then status 200
    And print response
    #* match response == read('../json/weather.json')
    * def responseStatus = responseStatus
    * def response = response

