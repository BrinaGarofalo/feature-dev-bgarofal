function fn() {
  //configuracion de entornos
  var config = {
   
    baseUrl: 'http://localhost:8080',
  
  };
  //microservicios
  config.port_inspire_challenge_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  
  // Configuración por entorno
  var env = karate.env || 'dev'; // si no se especifica, se usa 'dev'
  karate.log('karate.env:', env);
  
  if (env == 'dev') {
    config.baseUrl= 'http://api-dev.empresa.com'
    config.port_marvel_character_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  } else if (env == 'qa') {
    config.baseUrl= 'http://api-qa.empresa.com'
    config.port_inspire_challenge_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  }
  return config;
}
