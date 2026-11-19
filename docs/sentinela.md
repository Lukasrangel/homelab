## Sentinela: serviços de borda e infraestrutura

O **Sentinela** concentra serviços utilizados tanto pela rede local quanto pelos dispositivos conectados remotamente através da VPN **Tailscale**.

Sua função é centralizar serviços de resolução DNS, armazenamento de arquivos, gerenciamento de senhas, monitoramento e acesso às aplicações hospedadas no homelab.

## Serviços em operação

### DNS e resolução de nomes

A infraestrutura DNS utiliza três componentes:

- **Unbound:** resolvedor DNS local, executado na porta `5353`.
- **Pi-hole:** responsável pela filtragem de consultas DNS e pelo encaminhamento ao Unbound.
- **dnsmasq:** instância dedicada à rede Tailscale, permitindo resolver os mesmos hostnames internos através dos endereços da Tailnet.

### Monitoramento

**Uptime Kuma:** monitora a disponibilidade dos serviços hospedados no homelab e de aplicações externas. Em caso de indisponibilidade, envia notificações pelo Telegram.

### Armazenamento de arquivos

**Samba (SMB):** disponibiliza compartilhamentos de arquivos para a rede local e para dispositivos conectados via Tailscale. É utilizado para armazenar arquivos pessoais e materiais dos projetos.

### Dashboard de serviços

**Homer:** painel centralizado com atalhos para acessar os serviços disponíveis na infraestrutura.

### Gerenciamento de senhas

**Vaultwarden:** gerenciador de senhas auto-hospedado, executado em container Docker, com acesso protegido por HTTPS.

### Proxy reverso e centralização de acesso

**Nginx Proxy Manager:** centraliza o acesso HTTP/HTTPS às aplicações executadas em containers Docker.

Por meio dele, cada aplicação pode ser acessada por um hostname próprio, sem a necessidade de expor diretamente as portas de cada container na rede.

## Arquitetura

```
                 ______________________________________
                /                                      /
               /       SENTINELA                       /
              /        
             /______________________________________/

                         .-----------.
                         |  CLIENTES |
                         '-----------'
                               |
                 +-------------+-------------+
                 |                           |
          REDE LOCAL                    TAILSCALE
                 |                           |
          +-------------+             +-------------+
          |   PI-HOLE   |             |  DNSMASQ    |
          | DNS + BLOCK |             | TAILNET DNS |
          +------+------+             +------+------+
                 |                           |
          +------+------+             +------+------+
          |   UNBOUND   |<------------|  PI-HOLE    |
          |  :5353      |             |  UPSTREAM   |
          +-------------+             +-------------+

                 |                           |
                 +-------------+-------------+
                               |
                      +--------v--------+
                      |  NGINX PROXY    |
                      |    MANAGER      |
                      |   HTTP / HTTPS  |
                      +--------+--------+
                               |
                     DOCKER NETWORK: PROXY
                               |
             +-----------------+-----------------+
             |                 |                 |
       +-----v------+    +-----v------+    +-----v------+
       | VAULTWARDEN|    |   HOMER    |    | UPTIME KUMA|
       | PASSWORDS  |    | DASHBOARD  |    | MONITORING |
       +------------+    +------------+    +------+-----+
                                                   |
                                             +-----v-----+
                                             | TELEGRAM  |
                                             |  ALERTS   |
                                             +-----------+

       +------------------------------------------------+
       |                 HOST SERVICES                  |
       |                                                |
       |   SAMBA / SMB                                  |
       |   FILE SHARING - LAN + TAILSCALE              |
       |                                                |
       +------------------------------------------------+

       ================================================
                    DEBIAN GNU/LINUX
       ================================================
```

## Considerações

O Sentinela reúne serviços fundamentais para o funcionamento e a administração do homelab. A centralização de DNS, monitoramento, armazenamento e acesso às aplicações facilita a manutenção e cria uma base para a expansão da infraestrutura.

Este ambiente continua em desenvolvimento, com foco em documentação, organização, segurança e maior resiliência dos serviços.
