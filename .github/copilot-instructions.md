# Guía Senior para Automatización con Karate Framework

## Estructura estándar del proyecto

```
src/
├── main/
│   └── java/
│       └── com/
│           └── pichincha/
│               ├── database/
│               ├── model/
│               └── utils/
└── test/
    ├── java/
    │   ├── logback-test.xml
    │   └── com/
    │       └── pichincha/
    │           ├── TestRunner.java
    │           ├── features/  <-- UBICACIÓN ESTÁNDAR PARA TODOS LOS FEATURES
    │           │   ├── proyecto1/
    │           │   │   └── crearUsuario.feature
    │           │   └── proyecto2/
    │           │       └── consultarProducto.feature
    │           └── utils/
    └── resources/
        ├── karate-config.js
        └── karate-test.feature