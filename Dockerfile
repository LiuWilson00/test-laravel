FROM php:8.1-fpm

# 安裝依賴
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    sudo \
    unzip \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev

# 安裝 PHP 擴展
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 從容器外部複製 Laravel 代碼到容器內
COPY . /var/www

# 複製 Nginx 配置文件
COPY nginx.conf /etc/nginx/sites-available/default

# 設置工作目錄
WORKDIR /var/www


# Laravel 權限設置
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install

# 開放端口
EXPOSE 80 9000

# 啟動腳本
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

CMD ["start-container"]
