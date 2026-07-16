# Ejecución local con Docker

## Requisitos

- Docker Desktop en ejecución.
- Puerto `8088` disponible (se puede cambiar en `.env`).

## Iniciar

```powershell
Copy-Item .env.example .env
docker compose up --build -d
docker compose ps
```

Abra <http://localhost:8088>. La primera ejecución importa automáticamente
`bk_basededatos.sql`, incluyendo los datos de prueba.

## Comandos útiles

```powershell
docker compose logs -f app db
docker compose down
docker compose down -v  # elimina la base local y permite reimportarla
```

Los archivos del proyecto se montan dentro de Apache, por lo que los cambios
PHP/CSS se reflejan al recargar. Las imágenes o certificados cargados desde el
sistema se guardan en `public/` en el equipo. La base se conserva en el volumen
`gym_mysql_data`.
