FROM php:alpine
COPY src composer.json ./
RUN apk add composer php-dom php-json php-pdo php-odbc php-simplexml php-tokenizer php-xml php-xmlwriter
RUN composer install
CMD ["composer"]