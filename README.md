# Homelab

Infraestrutura de laboratório pessoal voltada para estudos em **DevOps, redes, automação e segurança**.

Este repositório documenta a arquitetura, serviços e rotinas utilizadas no ambiente.

---

## Estrutura do Homelab

O ambiente é composto por um servidor principal responsável por:

* roteamento DNS interno
* proxy reverso para aplicações
* execução de serviços web
* rotinas automatizadas (backup)

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

### Sistema Operacional

* Debian 13 (Trixie) — arquitetura x64 - *Artemis*
* Debian 13 (Trixie) — arquitetura x64 - *Sentilea* 


---

## Funções de cada Servidor

# *Sentinela*

* Borda de segurança da rede responsável pelo DNS e Pi-hole, concentra monitoramento.

# Serviços Ativos

### Infraestrutura

* **Pi-hole** → DNS interno com bloqueio de anúncios
* **Unbound** → resolvedor DNS recursivo (privacidade + performance)
* **NetData** → Concentra informções/métricas de todos os nós da rede, monitora e envia alertas via telegram


---

## *Artemis*


* Hospeda os containers dockers para aplicações web e proxysvia NGINX

# Serviços Ativos

### Infraestrutura

* **Nginx** → proxy reverso para aplicações internas
* **Doker** → gerenciando as aplicações web

---

# Aplicações

* **TodoList **

  * Backend em Python (Gunicorn)
  * Integração via Nginx
  * https://github.com/Lukasrangel/django-todo


* **NeoTube**

  * Backend em PHP (PHP-FPM)
  * Script python no fundo 
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
* [ ] Exposição segura via Cloudflare Tunnel
* [X] Dockerizar apps


---

### Observabilidade

* [ ] Monitoramento de estado do servidor
* [ ] NetData em ambos os nós
* [ ] Serviço de monitoramento bash + bot telegram
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

## Notas

Este projeto está em constante evolução. Novos serviços e melhorias são adicionados conforme testes e necessidades surgem.
