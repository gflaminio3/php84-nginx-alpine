# PHP 8.4 + Nginx + Alpine (Laravel Ready)

Lightweight Docker image based on **Alpine 3.22**, featuring:

- PHP **8.4** + PHP-FPM  
- Nginx  
- Self-signed SSL  
- Cron with Laravel scheduler  
- Composer  
- Modular, file-based configuration  
- Non-root `www-data` user  
- Ready for Laravel or any modern PHP app  

---

## Repository Structure

```
php-nginx-84-alpine/
├─ Dockerfile
├─ docker/
│  ├─ nginx/app.conf
│  ├─ php-fpm/www.conf
│  └─ cron/root
└─ README.md
```

---

## Build

```bash
docker build -t php-nginx-84-alpine .
# with timezone
docker build --build-arg TZ=Europe/Rome -t php-nginx-84-alpine .
```

---

## Run

```bash
docker run --rm -p 443:443   -v $(pwd)/app:/var/www/app   php-nginx-84-alpine
```

Laravel root: `/var/www/app/public`

---

## Override Configs

```bash
-v ./docker/nginx/app.conf:/etc/nginx/http.d/app.conf
-v ./docker/php-fpm/www.conf:/etc/php84/php-fpm.d/www.conf
-v ./docker/cron/root:/etc/crontabs/root
```

---

## SSL

Self-signed certificate generated automatically.  
To use your own:

```bash
-v ./certs/cert.pem:/etc/ssl/certs/selfsigned.crt
-v ./certs/key.pem:/etc/ssl/private/selfsigned.key
```

---

## Composer

```bash
docker exec -it <container> composer install
```

---

## Publish (optional)

### Docker Hub
```bash
docker tag php-nginx-84-alpine yourname/php-nginx-84-alpine
docker push yourname/php-nginx-84-alpine
```

### GHCR
```bash
docker tag php-nginx-84-alpine ghcr.io/USER/php-nginx-84-alpine
docker push ghcr.io/USER/php-nginx-84-alpine
```
