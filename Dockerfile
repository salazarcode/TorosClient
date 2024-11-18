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

# Copiamos los archivos publicados - AQUÍ ESTÁ EL CAMBIO IMPORTANTE
COPY --from=build /app/publish/wwwroot/ .

RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Configuración de Nginx
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
    try_files $uri $uri/ /index.html =404; \
    add_header Cache-Control "no-store, no-cache, must-revalidate"; \
    } \
    types { \
    application/wasm wasm; \
    } \
    }' > /etc/nginx/conf.d/default.conf

EXPOSE 80