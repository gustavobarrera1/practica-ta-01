# Tech Assignment de Práctica — Junior DevOps Engineer

## Objetivo

Diseñar e implementar una pequeña plataforma desplegable utilizando contenedores, automatización e infraestructura básica.

## Arquitectura y Tecnologías

* Docker & Docker Compose
* Terraform
* GitHub Actions
* AWS (EC2, SSM, IAM, S3)

## Pasos para Desplegar

### Clonar el repositorio

```bash
git clone https://github.com/gustavobarrera1/practica-ta-01

cd practica-ta-01/app/
```

### Configurar las credenciales de la base de datos

```bash
cat > .env <<EOF
DB_HOST=db
DB_NAME=appdb
DB_USERNAME=postgres
DB_PASSWORD=postgres
EOF
```

### Construir y levantar los servicios con Docker

```bash
docker compose up -d
```

### Verificar el estado de la aplicación

```bash
curl localhost:5000/health
```

## Decisiones Técnicas

Se implementó el proyecto sobre una instancia EC2 con el objetivo de analizar las diferencias y comprender qué problemas resuelve el despliegue de aplicaciones utilizando ECS. Para ello, fue necesario identificar y resolver los desafíos asociados a una instancia sin Docker preinstalado, sin acceso directo y con una gestión manual de los componentes necesarios para la ejecución de la aplicación.

El proceso de despliegue e implementación se resolvió mediante herramientas de AWS como SSM e IAM, permitiendo una administración segura de accesos y una implementación automatizada de la aplicación.

Se implementó un bucket S3 para almacenar el estado remoto de Terraform (`tfstate`), junto con su mecanismo de bloqueo, facilitando el trabajo colaborativo y evitando conflictos durante la gestión de la infraestructura.

## Variables y Validaciones

Se agregaron variables para gestionar información sensible de la aplicación, tanto en `docker-compose` como en la configuración de CI/CD mediante GitHub Actions.

Se incorporaron *health checks* en `docker-compose` para validar el estado de la aplicación y verificar la disponibilidad de la base de datos.

Se implementaron validaciones estáticas de código mediante `pylint`, validaciones del `Dockerfile` mediante herramientas de *linting* y análisis de vulnerabilidades con `Trivy` para validar la imagen Docker antes de su publicación en Docker Hub.

## Scripts Útiles

Se agregó un script para la instalación automática de Docker en la instancia EC2 durante el aprovisionamiento de infraestructura mediante Terraform.

## Problemas Encontrados

Al utilizar una instancia EC2 directamente en lugar de un servicio administrado de contenedores, fue necesario investigar y evaluar distintas alternativas para implementar el proyecto de forma segura y escalable.

Por este motivo, se utilizó principalmente AWS SSM para el despliegue de la aplicación y la administración de accesos a la instancia. Además, se implementó el acceso al repositorio mediante SSH, ya que inicialmente se trataba de un repositorio privado, y se automatizó el despliegue de nuevas versiones de la aplicación ante cada cambio realizado.