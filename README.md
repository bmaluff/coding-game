# Conding Game
El siguiente ejemplo es un desafio provisto por Coding Game

## Uso
Para generar manualmente las pruebas, puede ejecutar el workflow de [Unit Test](https://github.com/bmaluff/coding-game/actions/workflows/unit_test.yaml) o [Coverage Test](https://github.com/bmaluff/coding-game/actions/workflows/coverage_test.yaml), ambos subirán los resultados de los test en formato txt como artifacts, los cuáles pueden ser accedidos a través de la [API de GitHub](https://docs.github.com/en/rest/actions/artifacts?apiVersion=2022-11-28)

Para construir y subir a Docker Hub ejecute el workflow [Push Production](https://github.com/bmaluff/coding-game/actions/workflows/push_production.yaml). Los datos requeridos son:

 1. Repositorio público en Docker Hub
 2. Usuario de Docker
 3. Token de Docker
 
Para ejecutar todos los workflows anteriores ejecute el workflow [Main](https://github.com/bmaluff/coding-game/actions/workflows/main.yaml) agregando los datos requeridos para el workflow Push Production

## Vista General de la versión en producción
A diferencia del proyecto original basado en Django que corre con su servidor web integrado la versión en producción separa los componentes para hacerlo más escalable y resiliente.
```mermaid
graph LR
A[Client] --> B((Nginx)) --> C((Gunicorn)) --> D((Postgresql))
```
De esta forma podemos escalarlo con un orquestador como **Kubernetes** de la siguiente manera
```mermaid
graph LR
A[Client] --> B((Nginx)) --> C((Gunicorn)) --> D((Postgresql))
A --> E((Nginx))
A --> F((Nginx))
E --> C
F --> C
G((Gunicorn)) -->D
B --> G
E --> G
F --> G
```

## Despliegue con Kubernetes
La versión de producción de la aplicación puede implementarse usando Kubernetes en el entorno local
### Pre-requisitos
Antes de clonar el repositorio asegúrese de contar con los siguientes programas:
1. Docker ([Como Instalar Docker](https://docs.docker.com/engine/install/))
2. Kubectl ([Como Instalar Kubectl](https://kubernetes.io/docs/tasks/tools/))
3. Minikube ([Como Instalar Minikube](https://minikube.sigs.k8s.io/docs/start/))
### Uso
Para probar la implementación local de Kubernetes siga los siguientes pasos:
1. Clone el repositorio `git clone https://github.com/bmaluff/coding-game.git`
2. Ejecute el script `sh pipeline.sh` desde su terminal
3. Abra la aplicación desde su navegador con la URL [http://localhost:8080/api/](http://localhost:8080/api)
4. Para terminar la ejecución simplemente presione desde la terminal `Ctrl + c`
## Despliegue con Terraform
Para implementar la aplicación en la nube se utilizó Terraform como herramienta de IaC y como proveedor a AWS.
### Pre-requisitos
Para el despliegue de la aplicación con Terraform deberá contar con lo siguiente:
1. Una cuenta de AWS con permisos adecuados para el provisionamiento de los recursos configurada
2. La utilería [**jq**](https://jqlang.github.io/jq/download/)
3. El cliente [**AWS cli**](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
4. El cliente de [**Terraform**](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
5. Subir la versión de producción de la aplicación. Esto lo puede hacer desde el workflow del repositorio descrito anteriormente.
### Uso
Para desplegar la aplicación con Terraform debe seguir los siguientes pasos:
1.  Clone el repositorio `git clone https://github.com/bmaluff/coding-game.git`
2. Cambie el directorio de trabajo `cd terraform-code`
3. Ejecute el script `sh pipeline.sh` desde su terminal
3.1. Escriba el nombre del repositorio público en el cual se encuentra la imagen de la versión en producción de la aplicación. (Paso 5 del pre-requisito)
3.2. Designe un nombre para la base de datos a ser creada
3.3. Designe un nombre para la base de datos
3.4. Designe un nombre de usuario para el usuario master de la base de datos
>Importante: No olvide eliminar los recursos creados en la nube de AWS para evitar recargos indeseados, para eso desde el directorio **terraform-code** ejecute el siguiente comando:  `terraform destroy -auto-aprove`