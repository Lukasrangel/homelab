## Artemis: servidor core e hospedagem de aplicações

A **Artemis** é o servidor core do meu homelab, responsável por hospedar aplicações Web e serviços disponibilizados externamente.

Sua arquitetura segue uma abordagem de isolamento de serviços utilizando **Docker**, com o acesso às aplicações centralizado por meio do **Nginx**, instalado diretamente no sistema operacional.

## Hospedagem e aplicações

A Artemis funciona como plataforma de hospedagem de aplicações Web e abriga um sistema próprio de provisionamento de hospedagens WordPress.

O projeto automatiza a criação e configuração de ambientes de hospedagem WordPress. Seu desenvolvimento e funcionamento podem ser consultados no repositório [provisioning-site-script](https://github.com/Lukasrangel/provisioning-site-script).

Além da plataforma de provisionamento, o servidor hospeda:

- **WordPress:** ambientes de hospedagem provisionados pela plataforma.
- **Nextcloud:** solução de armazenamento e sincronização de arquivos.
- **Punkzine:** projeto de infraestrutura digital comunitária, disponível em [punkzinese.org](https://punkzinese.org).

```
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │                         REDE DOCKER INTERNAL (punkzinese.org)               │
 │                                                                             │
 │  ┌────────────────────────┐   ┌────────────────────────┐   ┌─────────────┐  │
 │  │ Container: App 1       │   │ Container: App 2       │   │ Container:  │  │
 │  │ (WordPress / Blog A)   │   │ (WordPress / Blog B)   │   │ App N (etc) │  │
 │  └───────────┬────────────┘   └───────────┬────────────┘   └──────┬──────┘  │
 │              │                            │                       │         │
 │              │ (User A / DB_A)            │ (User B / DB_B)       │         │
 │              └──────────────────┐         │         ┌─────────────┘         │
 │                                 ▼         ▼         ▼                       │
 │                           ┌──────────────────────────────┐                  │
 │                           │ Container Compartilhado:     │                  │
 │                           │ MySQL / MariaDB Server       │                  │
 │                           │                              │                  │
 │                           │  [DB_A]   [DB_B]   [DB_N]    │                  │
 │                           └──────────────────────────────┘                  │
 └──────────────────────────────────────────┬──────────────────────────────────┘
                                            │ Volumes Mapeados
                                            ▼
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │                     STORAGE LOCAL DO HOST (Bare-Metal)                      │
 │                                                                             │
 │  /var/www/html/app1   │   /var/www/html/app2   │   /var/lib/mysql (Data)    │
 └─────────────────────────────────────────────────────────────────────────────┘
                                            ▲
                                            │ Reverse Proxy / Socket
 ┌──────────────────────────────────────────┴──────────────────────────────────┐
 │                         HOST LINUX (Nginx / Edge)                           │
 │                                                                             │
 │  • Virtual Hosts (Server Blocks) por aplicação                              │
 │  • Hardening: Bloqueio de instalação de Plugins/Temas no WP                 │
 │  • Rate Limiting & Fail2ban na borda                                        │
 └────────────────────────────────
```


## Segurança e controle de requisições

Como primeira camada de proteção contra atividades abusivas, como varreduras de diretórios, tentativas de força bruta e excesso de requisições, utilizo mecanismos de limitação de tráfego do Nginx.

### Rate limiting

A diretiva `limit_req_zone` define zonas de memória compartilhada utilizadas para controlar a frequência de requisições por endereço IP.

Quando um cliente ultrapassa os limites configurados, o Nginx pode rejeitar as requisições excedentes, retornando o código HTTP `429 Too Many Requests`.

### Fail2ban

O **Fail2ban** monitora os arquivos de log das aplicações e identifica padrões de requisições que correspondem às regras de proteção configuradas.

Quando uma origem atinge as condições definidas nos filtros, o Fail2ban aplica um bloqueio temporário por meio do firewall, com duração configurada de uma hora.

Essa integração adiciona uma camada de resposta automatizada a comportamentos abusivos, complementando o controle de requisições realizado pelo Nginx.

```
    [   Requisições  ]
            │
            ▼
┌───────────────────────┐
│     Nginx Webserver   │ ──(Dentro do Limite)──► [ Processa Aplicação ]
│  (limit_req_zone)     │
└───────────┬───────────┘
            │
 (Excedeu o Limite de Req/s)
            │
            ▼
┌───────────────────────┐
│  HTTP Status 429      │ ──► [ Registra no error.log ]
│ (Too Many Requests)   │                    │
└───────────────────────┘                    │
                                             ▼
                                ┌────────────────────────┐
                                │    Fail2ban Daemon     │
                                │ (Monitora error.log)  │
                                └────────────┬───────────┘
                                             │
                                  (Threshold Atingido)
                                             │
                                             ▼
                                ┌────────────────────────┐
                                │ iptables / nftables    │
                                │  [ BAN do IP: 1 Hora ] │
                                └────────────────────────┘
```

## Considerações

A Artemis concentra a camada de hospedagem e disponibilização externa de aplicações do homelab. Além de executar serviços próprios, também funciona como base para projetos de automação e provisionamento de ambientes Web.

A infraestrutura continua em evolução, com foco em isolamento de serviços, automação, segurança e disponibilidade.
