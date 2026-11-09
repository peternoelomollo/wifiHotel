FROM php:8.4-cli
RUN apt-get update && apt-get install -y git curl libpng-dev libonig-dev libxml2-dev zip unzip libzip-dev libsqlite3-dev sqlite3 nodejs npm && docker-php-ext-install pdo_mysql pdo_sqlite mbstring exif pcntl bcmath gd zip
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . .
RUN mkdir -p database && touch database/database.sqlite
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN npm install && npm run build || true
EXPOSE 10000
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=10000"
