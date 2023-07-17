# Conding Game

  

El siguiente ejemplo fue un desafio provisto por Coding Game

  

## Uso

  

Para Generar los tests de forma manual puede ejecutar el workflow de [Unit Test](https://github.com/bmaluff/coding-game/actions/workflows/unit_test.yaml) o [Coverage Test](https://github.com/bmaluff/coding-game/actions/workflows/coverage_test.yaml), ambos subirán los resultados de los test en formato txt como artifacts

  

Para construir y subir a Docker Hub ejecute el workflow [Push Production](https://github.com/bmaluff/coding-game/actions/workflows/push_production.yaml). Los datos requeridos son:

 1. Repositorio público en Docker Hub
 2. Usuario de Docker
 3. Token de Docker