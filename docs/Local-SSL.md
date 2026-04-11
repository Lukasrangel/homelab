#  SSL em Site na Rede Local

Guia para configurar HTTPS em ambiente local utilizando mkcert e Nginx.

---

##  Instalação do mkcert

```bash
sudo apt install mkcert libnss3-tools
```

## Criar autoridade certificadora local

No servidor, execute:

```bash
mkcert -install
```

Isso cria uma CA (Certificate Authority) local confiável no sistema.

## Gerar certificado para o domínio

```bash
mkcert todo.web.lab
```


Serão gerados os arquivos:

```bash
todo.web.lab.pem
todo.web.lab-key.pem
```

## Organizar certificados
```bash
sudo mkdir -p /etc/nginx/ssl
sudo mv *.pem /etc/nginx/ssl/
```

## Configurar Nginx com HTTPS

```bash
server {
    listen 80;
    server_name todo.web.lab;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name todo.web.lab;

    ssl_certificate /etc/nginx/ssl/todo.web.lab.pem;
    ssl_certificate_key /etc/nginx/ssl/todo.web.lab-key.pem;

    location / {
        proxy_pass http://127.0.0.1:8000;

        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /static/ {
        alias /var/www/django_todo/static/;
    }
}
```

## Reiniciar Nginx
```bash
sudo systemctl restart nginx
```

## Observações
O navegador exibirá aviso de segurança se o certificado não estiver instalado no cliente.
Para remover o aviso, é necessário instalar a CA do mkcert nos dispositivos clientes.
Ideal para uso em homelab e ambientes internos.


## Resultado

Acesse:

https://todo.web.lab

Seu site estará disponível via HTTPS na rede local.
