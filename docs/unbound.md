#  Setup

## Instalação do Unbound

```bash
apt install unbound
```

---

## Configuração básica

Arquivo:

```bash
/etc/unbound/unbound.conf.d/pihole.conf
```

Exemplo:

```bash
server:
    verbosity: 0
    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    root-hints: "/var/lib/unbound/root.hints"
    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

## Abilitar port-Fowarding no servidor

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

---

## Integração com Pi-hole

No Pi-hole:

* definir upstream DNS como:

```bash
127.0.0.1#5335
```

---

## Testes

```bash
dig google.com @127.0.0.1 -p 5335
```

---

## Verificação

```bash
systemctl status unbound
```


# Troubleshooting

## Unbound não resolve

Verificar:

```bash
systemctl status unbound
```

---

## Porta em uso

```bash
netstat -tulnp | grep 5335
```

---

## DNS não responde no Pi-hole

Verificar upstream configurado:

```bash
127.0.0.1#5335
```

---

## Erro com GPG_TTY (em scripts)

```bash
export GPG_TTY=$(tty)
```

