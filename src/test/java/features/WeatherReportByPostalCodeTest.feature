@wetherbypostal @All
Feature: location

  Background:

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @getWetherByPostalSingle
  Scenario: get weather by postal code
        * def query = { "postal_code": 2055,key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')
    * assert wetherreport.response.data[0].city_name == "North Sydney"


  @getWetherByPostalUsingExample
  Scenario Outline: get weather for a postal code '<postalcode>'
    * def query = { postal_code: '<postalcode>',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')
    * assert wetherreport.response.data[0].city_name == <city>

    Examples:
      | postalcode   |city|
      | 2055   |"North Sydney"|
      | 517415      |"Palmaner"|

  @getWetherByPostalUsingTableAndExample
  Scenario Outline: Get weather for postal code

    * table postalcodes
      | code   |
      | 2055   |
      | 517415 |
    * def query = { postal_code: '#(<postalCodeData>["code"])',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')


    Examples:
      |postalCodeData|
      | postalcodes[0]|
      | postalcodes[1] |

  @wetherErrorCases
  Scenario Outline: get weather for postal code - Error Cases '#(<postalCodeData>["code"])'

    * table postalcode
      | code   |
      | ""   |
      | null |
    |    "gdfdsfsf"  |
    |-64654655453|
    * def query = { postal_code: '#(<postalCodeData>["code"])',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    And print wetherreport.response
    * assert wetherreport.responseStatus == <status>
    Then wetherreport.response == <error>

    Examples:
      |postalCodeData|status|error|
      | postalcode[0]| 400     | {"error": "Invalid lat supplied. Must be between -90 and +90"}    |
      | postalcode[1]| 400     | {"error": "Invalid Parameters supplied."}    |
      | postalcode[2]| 400     | {"error": "Invalid Parameters supplied."}    |
      | postalcode[3]| 400     | {"error": "Invalid Parameters supplied."}    |