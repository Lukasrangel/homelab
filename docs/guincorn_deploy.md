<h1>Deploy de Projeto Django no Homelab</h1>

<p>Este documento descreve o processo de deploy de uma aplicação Django em um ambiente de homelab utilizando Nginx, Gunicorn, SQLite e systemd.</p>

<div class="section">
<h2>Requisitos</h2>
<pre><code>sudo apt update
sudo apt install python3 python3-venv git nginx</code></pre>
</div>

<div class="section">
<h2>Clonando o projeto</h2>
<pre><code>git clone &lt;url-do-projeto&gt; django-todo
cd django-todo</code></pre>
</div>

<div class="section">
<h2>Ambiente virtual</h2>
<pre><code>python3 -m venv venv
source venv/bin/activate</code></pre>
</div>

<div class="section">
<h2>Dependências</h2>
<pre><code>pip install -r requirements.txt</code></pre>
</div>

<div class="section">
<h2>Banco de dados</h2>
<pre><code>python manage.py makemigrations
python manage.py migrate</code></pre>
</div>

<div class="section">
<h2>Teste local</h2>
<pre><code>python manage.py runserver</code></pre>
<p>Apenas para desenvolvimento local.</p>
</div>


<div class="section">
<h2>Permissão das pastas static</h2>
<pre><code>sudo chown -R www-data:www-data /caminho/static <br />
sudo chmod -R 755 /caminho/staticr <br /><br />
chmod 755 /caminho
chmod 755 /caminho/static
</code></pre>

</div>

<div class="section">
<h2>Gunicorn</h2>
<pre><code>pip install gunicorn
gunicorn -b 127.0.0.1:8000 todo.wsgi</code></pre>
</div>

<div class="section">
<h2>Nginx</h2>

<h3>Configuração</h3>
<pre><code>sudo nano /etc/nginx/sites-available/django-todo</code></pre>

<pre><code>server {
    listen 80;
    server_name 192.168.1.10;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Forwarded-Host $server_name;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        alias /home/cyx/django-todo/static/;
    }
}</code></pre>

<h3>Ativar</h3>
<pre><code>cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/django-todo
sudo rm default</code></pre>

<pre><code>sudo nginx -t
sudo systemctl restart nginx</code></pre>

</div>

<div class="section">
<h2>Arquivos estáticos</h2>

<pre><code># settings.py
STATIC_ROOT = '/home/cyx/django_todo/static/'
STATIC_URL = '/static/'</code></pre>

<pre><code>python manage.py collectstatic</code></pre>

</div>

<div class="section">
<h2>systemd (Gunicorn)</h2>

<pre><code>sudo nano /etc/systemd/system/gunicorn_django_todo.service</code></pre>

<pre><code>[Unit]
Description=Gunicorn Django Todo
After=network.target

[Service]
User=cyx
Group=www-data
WorkingDirectory=/home/cyx/django_todo
Environment="PATH=/home/cyx/django_todo/venv/bin"
ExecStart=/home/cyx/django_todo/venv/bin/gunicorn \
    --workers 3 \
    --bind 127.0.0.1:8000 \
    todo.wsgi

[Install]
WantedBy=multi-user.target</code></pre>

<pre><code>sudo systemctl daemon-reload
sudo systemctl start gunicorn_django_todo
sudo systemctl enable gunicorn_django_todo</code></pre>

</div>

<div class="section">
<h2>Domínio local (opcional)</h2>

<p>Configure via Pi-hole ou DNS local e atualize:</p>

<pre><code>server_name meu-dominio.local;</code></pre>

<pre><code>sudo systemctl restart nginx</code></pre>

</div>

<div class="section">
<h2>Resultado esperado</h2>
<ul>
  <li>Django rodando via Gunicorn</li>
  <li>Nginx como proxy reverso</li>
  <li>Arquivos estáticos servidos pelo Nginx</li>
  <li>Serviço gerenciado pelo systemd</li>
</ul>
</div>

<div class="section">
<h2>Observações</h2>
<ul>
  <li>SQLite é indicado apenas para ambientes pequenos</li>
  <li>Use PostgreSQL/MySQL em produção real</li>
</ul>
</div>

