# Reserva de Horas Médicas – Proyecto DevOps

[![DevOps automation](https://github.com/MODPDS/reserva-horas-devops/actions/workflows/devops-automation.yml/badge.svg)](https://github.com/MODPDS/reserva-horas-devops/actions/workflows/devops-automation.yml)

Servicio web **estático** que simula la reserva de horas médicas de un centro de salud.
La página muestra un formulario de reserva, información general de atención y el estado del servicio.
Se sirve con **Nginx (`nginx:alpine`)** dentro de un contenedor **Docker** y se ejecuta localmente con
**Docker Compose** en el puerto **8080**.

> Proyecto académico – IACC, asignatura DevOps (Semana 3).
> Es una **simulación**: no utiliza API ni base de datos y no envía ni almacena datos.

---

## Estructura del proyecto

```
reserva-horas-devops/
├── .github/
│   └── workflows/
│       └── devops-automation.yml   # Validación automática (complementario)
├── src/
│   ├── index.html                  # Página con el formulario de reserva
│   └── styles.css                  # Hoja de estilos
├── .env.example                    # Plantilla de variables (sin valores reales)
├── .gitignore                      # Archivos que no se publican
├── docker-compose.yml              # Levanta el servicio en el puerto 8080
├── Dockerfile                      # Imagen basada en nginx:alpine
└── README.md
```

## Requisitos

| Herramienta | Uso |
|---|---|
| Git | Clonar el repositorio y controlar versiones |
| Docker Desktop (incluye Docker Compose) | Construir y ejecutar el contenedor |
| Navegador web | Verificar el servicio en `http://localhost:8080` |
| Visual Studio Code (u otro editor) | Revisar y editar el código |

## Instalación

```bash
git clone https://github.com/MODPDS/reserva-horas-devops.git
cd reserva-horas-devops
cp .env.example .env        # crea tu archivo local de variables (no se publica)
```

Variables disponibles en `.env`:

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `APP_PORT` | `8080` | Puerto local donde se publica el servicio |
| `CONTAINER_NAME` | `reserva-horas-web` | Nombre del contenedor |
| `APP_VERSION` | `1.0.0` | Etiqueta de la imagen `reserva-horas` |
| `APP_ENV` | `local` | Entorno de ejecución |

Si no se crea `.env`, Docker Compose usa los valores por defecto.

## Ejecución

Con Docker Desktop iniciado:

```bash
docker compose build          # construye la imagen reserva-horas:1.0.0
docker compose up -d          # crea e inicia el contenedor en segundo plano
```

O en un solo paso: `docker compose up -d --build`.

## Verificación

```bash
docker compose ps                     # estado: running (healthy)
curl -I http://localhost:8080         # debe responder HTTP/1.1 200 OK
```

Luego abre **http://localhost:8080** en el navegador. También puedes revisar el contenedor
en Docker Desktop, en la sección **Containers**.

## Monitoreo básico

```bash
docker logs reserva-horas-web          # registros de acceso y errores de Nginx
docker logs -f reserva-horas-web       # registros en tiempo real (Ctrl+C para salir)
docker stats --no-stream               # consumo de CPU, memoria y red
docker inspect --format '{{.State.Health.Status}}' reserva-horas-web   # estado del healthcheck
```

## Detener el servicio

```bash
docker compose stop        # detiene el contenedor (se puede reanudar con docker compose start)
docker compose down        # detiene y elimina el contenedor y la red
```

## Flujo de trabajo (Git y GitHub)

1. Cada tarea se registra como **issue**.
2. El trabajo se realiza en una rama (`feature/...`, `fix/...`, `docs/...`), nunca directo en `main`.
3. Commits pequeños con mensajes descriptivos en español.
4. Se abre un **pull request** hacia `main`, que ejecuta el workflow de validación.
5. Tras la revisión, se fusiona y se etiqueta la versión (`v1.0.0`).

## Automatización (complementario)

El workflow [`devops-automation.yml`](.github/workflows/devops-automation.yml) se ejecuta en cada
push y pull request hacia `main` y:

1. Verifica que existan los archivos obligatorios del proyecto.
2. Comprueba que no se haya publicado un archivo `.env` ni credenciales evidentes.
3. Valida la sintaxis de `docker-compose.yml`.
4. Construye la imagen y levanta el servicio con Docker Compose.
5. Verifica que el servicio responda **HTTP 200** y que el healthcheck quede `healthy`.

No publica la aplicación en servidores externos.

## Seguridad y protección de datos

- **Sin credenciales en el repositorio:** las variables reales van en `.env`, excluido por `.gitignore`.
  Solo se versiona `.env.example` con valores de ejemplo.
- **`.gitignore` preventivo:** excluye `.env`, claves (`*.key`, `*.pem`), respaldos y datos (`*.sql`, `*.csv`) y logs.
- **Sin datos personales:** el formulario usa datos ficticios y no envía información a ningún servidor.
- **Imagen mínima y oficial:** `nginx:alpine` reduce el tamaño y la superficie de ataque.
- **Revisión antes de integrar:** todo cambio pasa por pull request y validación automática.
- **Secretos reales:** en un entorno productivo se gestionarían con GitHub Secrets o un gestor de secretos.

## Autor

Patricio Díaz Silva – Ingeniería en Informática, IACC (2026).
