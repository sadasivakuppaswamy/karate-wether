@wetherbypostal
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



  @getWetherByPostalUsingExample
  Scenario Outline: get weather for a postal code '<postalcode>'
    * def query = { postal_code: '<postalcode>',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')

    Examples:
      | postalcode   |
      | 2055   |
      | 517415      |

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
    #* match wetherreport.response['data']['lon'] == 11

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