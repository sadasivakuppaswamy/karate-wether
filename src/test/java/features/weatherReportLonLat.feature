@locationtest
Feature: location

  Background:
    #* url "http://api.weatherbit.io"

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @wetherSingle
  Scenario: get weather for lang and lat
        * def query = { lat: '-43.00311', lon: '113.6594',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')



  @wetherReportUsingExample
  Scenario Outline: get weather for lang and lat
    * def query = { lat: '<lat>', lon: '<lon>',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')

    Examples:
      | lat         |  lon |
      | -43.00311   | 113.6594|
      | 54          | 2     |

  @wetherReportUsingtable
  Scenario Outline: get weather for lang and lat with table

    * table weather
      | lat   | lon |
      | -43.00311   | 113.6594|
      | 54          | 2     |
    * def query = { lat: '#(<weatherdate>["lat"])', lon: '#(<weatherdate>["lon"])',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    * match wetherreport.responseStatus == 200
    And print wetherreport.response
    * match wetherreport.response == read('../json/weather.json')
    #* match wetherreport.response['data']['lon'] == 11

    Examples:
      |weatherdate|
      | weather[0]|
      | weather[1] |

  @wetherReportErrorCases
  Scenario Outline: get weather for lang and lat with table - Error Cases

    * table weather
      | lat         | lon |
      | 113.6594    |-43.00311 |
      | 54          |      |
      |             |      |
      |   null      |  null    |
      |   4545.54   |  433.434 |

    * def query = { lat: '#(<weatherdate>["lat"])', lon: '#(<weatherdate>["lon"])',key: '#(API_KEY)' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    And print wetherreport.response
    * assert wetherreport.responseStatus == <status>
    Then wetherreport.response == <error>

    Examples:
      |weatherdate|status|error|
      | weather[0]| 400     | {"error": "Invalid lat supplied. Must be between -90 and +90"}    |
      | weather[1]| 400     | {"error": "Invalid Parameters supplied."}    |
      | weather[2]| 400     | {"error": "Invalid Parameters supplied."}    |
      | weather[3]| 400     | {"error": "Invalid Parameters supplied."}    |
      | weather[4]| 400     | {"error": "Invalid lon supplied. Must be between -180 and +180"}   |

  @wetherErrorCasesKey
  Scenario Outline: get weather for lang and lat with table - Error Cases

    * table weather
      | lat         | lon |key|
      | -43.00311   | 113.6594|"fdfdf"|
      | 54          | 2     |         |

    * def query = { lat: '#(<weatherdate>["lat"])', lon: '#(<weatherdate>["lon"])',key:'#(<weatherdate>["key"])' }
    * def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
    And print wetherreport.response
    * assert wetherreport.responseStatus == <status>
    Then wetherreport.response == <error>

    Examples:
      |weatherdate|status|error|
      | weather[0]| 403     | {"error": "API key not valid, or not yet activated. If you recently signed up for an account or created this key, please allow up to 30 minutes for key to activate."}    |
      | weather[1]| 403     | {"error": "API key is required."}    |