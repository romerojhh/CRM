# Use PHP 8.4 for ChurchCRM 7.x (PHP 8.4 required)
FROM php:8.4-apache

# Install system dependencies and PHP extensions required by ChurchCRM
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libgmp-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libsodium-dev \
    gettext \
    unzip \
    wget \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    soap \
    xml \
    zip \
    gmp \
    sodium \
    iconv \
    session \
    opcache

# Enable Apache rewrite module (required for ChurchCRM)
RUN a2enmod rewrite

# PHP configuration
RUN { \
        echo 'memory_limit = 512M'; \
        echo 'upload_max_filesize = 10M'; \
        echo 'post_max_size = 12M'; \
        echo 'max_execution_time = 60'; \
        echo 'file_uploads = On'; \
        echo 'allow_url_fopen = On'; \
        echo 'date.timezone = UTC'; \
    } > /usr/local/etc/php/conf.d/custom.ini

# Download and extract ChurchCRM directly into the document root
ARG CHURCHCRM_VERSION=7.0.2
RUN set -eux; \
    curl -fL -o ChurchCRM.zip "https://github.com/ChurchCRM/CRM/releases/download/${CHURCHCRM_VERSION}/ChurchCRM-${CHURCHCRM_VERSION}.zip"; \
    mkdir -p /var/www/html; \
    unzip -q ChurchCRM.zip -d /tmp; \
    mv /tmp/churchcrm/* /var/www/html/; \
    rm -rf /tmp/churchcrm ChurchCRM.zip

# Initial permissions (volumes may override at runtime)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/Include \
    && chmod -R 775 /var/www/html/Images/Family \
    && chmod -R 775 /var/www/html/Images/Person

# Apache virtual host configuration
COPY churchcrm.conf /etc/apache2/sites-available/churchcrm.conf
RUN a2ensite churchcrm.conf

# Suppress Apache warning about ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Entrypoint script to ensure permissions on mounted volumes
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]