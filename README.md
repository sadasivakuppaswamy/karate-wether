# karate-wether
# Introduction
In this project the most common examples of testing with the Karate framework are covered
# API testing with karate
Karate is the  open-source tool to combine API test-automation and ease of response validation and faster development.

https://github.com/intuit/karate

# Pre-Requisites

Oracle Java 14 SDK  - install jdk and set JAVA_HOME and add $JAVA_HOME/bin to PATH variable

Gradle 6.3 - install gradle and setup GRADLE_HOME env variable and add $GRADLE_HOME/bin  to path

# Choose IDE of your Choice :

Intellij IDEA: 
 add plugins required(karate plugin)
# Account and API Key details
As we are using weatherbit endpoints,we need to fetch API key by signing in.
https://www.weatherbit.io/api/swaggerui/weather-api-v2#/ - check this site and sign in to get API Key
# clone repository 
`` 
git clone git@github.com:sadasivakuppaswamy/karate-wether.git
``
# To execute manually 
From IDE -> select and run APITest java file
# Project Structure
![API implementation structure](https://github.com/sadasivakuppaswamy/karate-wether/assets/10988106/d27aaa0b-3cac-4bb4-9208-f8683643d8b0)


# Report structure
Under reports->cucumber-html-reports->open over-features.html

![karate reports](https://github.com/sadasivakuppaswamy/karate-wether/assets/10988106/30ba64a8-2349-4e9e-92c4-e7c9376219c9)

And report will look like

![cucumber reports](https://github.com/sadasivakuppaswamy/karate-wether/assets/10988106/e16d93da-cd59-4bcf-829c-9fb8e402a670)

# implementation
API implementation is seperated from feature files so maintanace will be more
Every scenario will call corresponding feature file to invoke API along with required inputs
```karate
* def wetherreport = call read('../api/currentweather.feature@currentwetherBylonlat') {paramDetails: #(query)}
```
And corresponding feature file
```karate
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
```
# Schema validation
API Response is validated against response schema mentioned under json folder
```karate
* match wetherreport.response == read('../json/weather.json')
```

# ENV Selection
Based on env, baseUrl and API_KEY will change,which is handled in build.gradle
```groovy
def baseUrls=["QA1":"http://api.weatherbit.io","QA2":"http2://api.weatherbit.io"]
```
```groovy
        def env = System.properties.getProperty("env")?"${System.getProperty("env")}" : "QA1"
        systemProperty "tag", System.getProperty("tag") ? "${System.getProperty("tag")}" : ""
        systemProperty "parallel", System.getProperty("parallel") ? "${System.getProperty("parallel")}" : "1"
        systemProperty "BaseURL", baseUrls[env]
        systemProperty "API_KEY", System.getProperty("API_KEY") ? "${System.getProperty("API_KEY")}" : "XXXXXXX"
        
```
And reading those system properties from karate-config.js as below

*****Note:: Added default values here to pass values while running from IDE direct run of scenario or APITest

```js
    BASE_URL : karate.properties['BaseURL']!= undefined? karate.properties['BaseURL']:"http://api.weatherbit.io",
    API_KEY : karate.properties['API_KEY']!= undefined? karate.properties['API_KEY']:"XXXXX",
    ENV: karate.properties['env'],


```
# Handling Data driven testing
Using table and example options data driven testing can be achieved.
```karate
@wethertable
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
```
# Filter tests based on tags - Not worked after few changes[Will check]
From APITest filter test by adding it to list,by default add feature tags to this list
```
        String[] tags = {"~@template","@wetherbypostal","@wetherreportbylonlat"};
```
`
   ~ means exclude
`
## Execution command
Navigate to the project and perform below actions to run all tests
```
    ./gradlew clean build
    ./gradlew test
```
with parameters
```gitexclude
./gradlew test -Dparallel=4 -DAPI_KEY=XXXXX -Denv=QA2 "-Dkarate.options=--tags @wetherSingle,@wetherExample"

```

##Open Items
Executing only one feature file - Not working
```
./gradlew test -Dtest.single=weatherReportLonLat -DAPI_KEY=XXXXX
./gradlew test --tests *weatherReportLonLat -DAPI_KEY=XXXXX
```
# CircleCi Integration

Create an account with CircleCi and create project against repo
Mention repo's config.yml to use building
Add env variable in CircleCI

![circle ci env varibles](https://github.com/sadasivakuppaswamy/karate-wether/assets/10988106/4de2466d-1907-4016-87f8-4a55c40b1076)

Runs build and pushes artifacts to reports folder
 
```
      - run:
          command: gradle test -Dparallel=${PARALLEL} -DAPI_KEY=${KEY_DATA} -Denv=${ENV} "-Dkarate.options=--tags $TAGS"
      - store_artifacts:
          path: ~/repo/reports
      - store_test_results:
          path: ~/repo/reports
```



Verify reports from artifacts in circleCi as shown below
![circle ci reports](https://github.com/sadasivakuppaswamy/karate-wether/assets/10988106/0a413ae5-6fcc-4849-ab97-b215574115df)

