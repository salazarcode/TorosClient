# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos y restauramos el proyecto
COPY ["TorosClient.csproj", "./"]
RUN dotnet restore

# Copiamos el resto del código
COPY . .

# Publicamos la aplicación
RUN dotnet publish -c Release -o /app/publish

# Imagen final con Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copiamos los archivos publicados
COPY --from=build /app/publish/wwwroot .

# Configuración para que Blazor WebAssembly funcione correctamente
RUN echo 'server { \
    listen 80; \
    location / { \
    root /usr/share/nginx/html; \
    try_files $uri $uri/ /index.html =404; \
    add_header Cache-Control "no-store, no-cache, must-revalidate"; \
    } \
    # Configuración para archivos .wasm \
    types { \
    application/wasm wasm; \
    } \
    # Configuración para archivos estáticos \
    location /css { \
    expires 1y; \
    add_header Cache-Control "public"; \
    } \
    location /_framework { \
    expires 1y; \
    add_header Cache-Control "public"; \
    } \
    }' > /etc/nginx/conf.d/default.conf

# Exponemos el puerto 80
EXPOSE 80