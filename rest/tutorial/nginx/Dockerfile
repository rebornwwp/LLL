FROM nginx:latest

ADD nginx.conf /etc/nginx/

RUN mkdir -p /var/www/static

WORKDIR /var/www/static

RUN chown -R nginx:nginx /var/www/static
