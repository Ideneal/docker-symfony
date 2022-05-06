FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    curl \
    git \
    apt-transport-https \
    apt-utils \
    build-essential \
    locales \
    acl \
    mailutils \
    wget \
    nodejs \
    npm \
    ssh-client \
    gnupg2 \
    zip \
    unzip \
    zlib1g-dev \
    libonig-dev \
    libzip-dev \
    sudo \
    software-properties-common

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Add user for application
RUN groupadd -g 1000 www
RUN useradd  -g www -u 1000 -ms /bin/bash www
RUN passwd -d www
RUN echo "www ALL=(ALL) ALL" > /etc/sudoers

# Clear cache and generate locale
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]