# Imagen del servicio web de reserva de horas médicas.
# Base liviana y oficial: Nginx sobre Alpine Linux (menor tamaño y menor superficie de ataque).
FROM nginx:alpine

LABEL org.opencontainers.image.title="reserva-horas" \
      org.opencontainers.image.description="Servicio web estático de reserva de horas médicas" \
      org.opencontainers.image.version="1.0.0"

# Copia solo el contenido público del sitio al directorio que sirve Nginx.
COPY src/ /usr/share/nginx/html/

# Nginx escucha en el puerto 80 dentro del contenedor (se publica como 8080 en docker-compose.yml).
EXPOSE 80
