function init() {
  var env_values={
    Env : karate.env , // get system property 'karate.env'
    BASE_URL : karate.properties['BaseURL']!= undefined? karate.properties['BaseURL']:"http://api.weatherbit.io",
    API_KEY : karate.properties['API_KEY']!= undefined? karate.properties['API_KEY']:"ce735350b0ed424d8e39fc071853ff6f",
    ENV: karate.properties['env'],

    }
  return env_values;
}