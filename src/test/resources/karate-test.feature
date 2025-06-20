Feature: Pruebas de la API de Personajes de Marvel

  Background:
    # Definimos la URL base según el entorno
    * def config = read('classpath:karate-config.js')()
    * url config.port_inspire_challenge_api
    * configure ssl = true
    * def username = 'testuser'
    * def basePath = '/' + username + '/api/characters'
    
    # Datos de prueba para crear y actualizar personajes
    * def ironManData = 
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    
    * def thorData = 
    """
    {
      "name": "Thor",
      "alterego": "Thor Odinson",
      "description": "God of Thunder",
      "powers": ["Lightning", "Mjolnir", "Super Strength"]
    }
    """
    
    * def invalidCharacterData = 
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    
    * def updatedDescription = "Updated description for testing"

  # ==================== PRUEBAS GET ====================
  
  Scenario: Obtener todos los personajes
    Given path basePath
    When method get
    Then status 200
    And match response == '#array'
    And assert response.length >= 0
    And match each response contains { id: '#number' }
    And match each response contains { name: '#string' }
    And match each response contains { alterego: '#string' }
    And match each response contains { description: '#string' }
    And match each response contains { powers: '#array' }
  Scenario: Obtener un personaje por ID (caso exitoso)
    # Primero buscamos si hay personajes existentes o creamos uno con nombre único
    Given path basePath
    When method get
    Then status 200
    
    # Generamos un nombre único para evitar conflictos
    * def timestamp = java.lang.System.currentTimeMillis()
    * def uniqueThorData = 
    """
    {
      "name": "Thor_#(timestamp)",
      "alterego": "Thor Odinson",
      "description": "God of Thunder",
      "powers": ["Lightning", "Mjolnir", "Super Strength"]
    }
    """
    
    # Creamos un personaje con nombre único
    Given path basePath
    And request uniqueThorData
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And match response contains { id: '#number' }
    
    # Guardamos el ID del personaje creado
    * def characterId = response.id
    * def characterName = response.name
    
    # Ahora probamos obtener el personaje por ID
    Given path basePath + '/' + characterId
    When method get
    Then status 200
    And match response.id == characterId
    And match response.name == characterName
    And match response.alterego == 'Thor Odinson'
    And match response.description == 'God of Thunder'
    And match response.powers contains 'Lightning'

  Scenario: Obtener un personaje por ID (ID no existente)
    # Usamos un ID que probablemente no exista
    * def nonExistentId = 999999
    
    Given path basePath + '/' + nonExistentId
    When method get
    Then status 404
    And match response.error == '#notnull'

  # ==================== PRUEBAS POST ====================
  
  Scenario: Crear un personaje (caso exitoso)
    Given path basePath
    And request ironManData
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And match response.name == 'Iron Man'
    And match response.alterego == 'Tony Stark'
    And match response.description == 'Genius billionaire'
    And match response.powers == ['Armor', 'Flight']
    And match response.id == '#number'

  Scenario: Crear un personaje (nombre duplicado)
    # Primero creamos un personaje
    Given path basePath
    And request ironManData
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    
    # Intentamos crear el mismo personaje de nuevo
    Given path basePath
    And request ironManData
    And header Content-Type = 'application/json'
    When method post
    Then status 409
    And match response.error contains 'duplicate'

  Scenario: Crear un personaje (faltan campos requeridos)
    Given path basePath
    And request invalidCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.error == '#notnull'

  # ==================== PRUEBAS PUT ====================
  
  Scenario: Actualizar un personaje (caso exitoso)
    # Primero creamos un personaje para obtener su ID
    Given path basePath
    And request ironManData
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And match response contains { id: '#number' }
    
    # Guardamos el ID del personaje creado
    * def characterId = response.id
    
    # Actualizamos el personaje
    * def updatedIronMan = ironManData
    * set updatedIronMan.description = updatedDescription
    
    Given path basePath + '/' + characterId
    And request updatedIronMan
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.id == characterId
    And match response.name == 'Iron Man'
    And match response.description == updatedDescription

  Scenario: Actualizar un personaje (ID no existente)
    # Usamos un ID que probablemente no exista
    * def nonExistentId = 999999
    
    Given path basePath + '/' + nonExistentId
    And request ironManData
    And header Content-Type = 'application/json'
    When method put
    Then status 404
    And match response.error == '#notnull'

  # ==================== PRUEBAS DELETE ====================
  
  Scenario: Eliminar un personaje (caso exitoso)
    # Primero creamos un personaje para obtener su ID
    Given path basePath
    And request thorData
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And match response contains { id: '#number' }
    
    # Guardamos el ID del personaje creado
    * def characterId = response.id
    
    # Eliminamos el personaje
    Given path basePath + '/' + characterId
    When method delete
    Then status 200
    
    # Verificamos que el personaje fue eliminado
    Given path basePath + '/' + characterId
    When method get
    Then status 404

  Scenario: Eliminar un personaje (ID no existente)
    # Usamos un ID que probablemente no exista
    * def nonExistentId = 999999
    
    Given path basePath + '/' + nonExistentId
    When method delete
    Then status 404
    And match response.error == '#notnull'
