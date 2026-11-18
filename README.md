# Homelab

Infraestrutura de laboratório pessoal voltada para estudos em **DevOps, redes, automação e segurança**.

Este repositório documenta a arquitetura, serviços e rotinas utilizadas no ambiente.

---

## Estrutura do Homelab

O ambiente é composto por tres servidores:

* roteamento DNS interno
* proxy reverso para aplicações
* execução de serviços web
* rotinas automatizadas (backup)
* containers dockers
* monitoraçao do ambiente
* plataforma de hospedagem de blogs wordpress
* drive colaborativo (NextCLoud)
* Cofre de senhas (Vaultwarden)

---

##  Setup

### 🖥️ Servidor — *Artemis*

* Notebook Acer A515-51-51UX
* CPU: Intel i5-7200U
* RAM: 4GB
* Armazenamento externo: Pen Drive 16GB (backup)

### 🖥️ Servidor - *Sentinela*

* Notebook Positivo
* CPU: Intel i3-6006U
* RAM 4GB

---

### 🖥️ Servidor - *Brutus*

* Desktop 
* CPU: AMD A10-7890K Radeon R7
* RAM 16GB

### Sistema Operacional

* Debian 13 (Trixie) — arquitetura x64 - *Artemis*
* Debian 13 (Trixie) — arquitetura x64 - *Sentinela*
* Debian 13 (Trixie) — arquitetura x64 - *Brutus* 


---

## Funções de cada Servidor

# *Sentinela*

* Borda de segurança da rede responsável pelo DNS e Pi-hole, manten cofre de senhas e samba na rede interna, concentra monitoramento.

# Serviços Ativos

### Infraestrutura

* **Pi-hole** → DNS interno com bloqueio de anúncios
* **Unbound** → resolvedor DNS recursivo (privacidade + performance)
* **Uptime Kuma** → Monitora servidores e serviços, envia alertas via telegram
* **Homer** → Painel Home Page que concentra os serviços da rede
* **Tailscale** → Nó da rede tailscale para acesso remoto
* **SMB**  → Pasta compartilhada na rede local e Tailscale como Drive
* **Vaultwarden** → Cofre de senhas
* **Nginx Proxy Manager** → Centraliza acesso aos containers


---

## *Artemis*


* Hospeda os containers dockers para aplicações web e proxys via NGINX

# Serviços Ativos

### Infraestrutura

* **Nginx** → proxy reverso para aplicações internas
* **Doker** → gerenciando as aplicações web
* **Tailscale** → Nó na rede tailscale, para acesso remoto
* **Hospedagem Wordpress** → Scripts de provisionamento ambiente de hospedagem Wordpress
* **NextCloud** → Drive de fanzines 

---

# Aplicações

* **TodoList**

  * Backend em Python (Gunicorn)
  * Integração via Nginx
  * https://github.com/Lukasrangel/django-todo


* **NeoTube**

  * Backend em PHP (PHP-FPM)
  * Script python no fundo

* **punkzinese.org**

  * Ambiente de provisionamento e hospedagem de Blogs Wordpress
  * Drive de fanzines via NextCloud
---

## *Brutus*

### Infraestrutura

* **SMB** → Backup do SMB do Sentinela
* **mdadm** → RAID1 de todo o sistema com um HD de desktop + HD de notebook
* **Tailscale** → Nó na rede tailscale, para acesso remoto

---


## Automação

### Cron Jobs

* Execução periódica do script de backup
* Estratégia baseada em **3-2-1**
* Criptografia com GPG
* Envio para nuvem via rclone

Documentação completa em:
`docs/backup.md`

---

## Backup

O sistema implementa:

* compactação automatizada
* criptografia (GPG - simétrica)
* múltiplos destinos:

  * local
  * mídia externa
  * nuvem

---

## Organização do Repositório

```bash
homelab/
├── scripts/
├── configs/
├── docs/
├── services/
└── README.md
```

---

## Roadmap

### Infraestrutura

* [X] Atualizar Debian para versão estável mais recente
* [X] Adicionar segundo servidor (alta disponibilidade / testes distribuídos)

---

### Aplicações

* [X] Deploy de aplicação PHP com FPM
* [X] Exposição segura via Cloudflare Tunnel
* [X] Dockerizar apps


---

### Observabilidade

* [x] Monitoramento de estado do servidor
* [x] Serviço de monitoramento bash + bot telegram
* [ ] Integração com Arduino + display LED (status físico do sistema)

---

### Experimentação

* [ ] Execução de LLM local (estudos de IA on-premise)

---

## Objetivo

Este homelab serve como ambiente de:

* experimentação prática
* validação de arquiteturas
* estudo de ferramentas reais de mercado

---


Este projeto está em constante evolução. Novos serviços e melhorias são adicionados conforme testes e necessidades surgem.
