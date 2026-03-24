# Homelab Backup Strategy (3-2-1)

Este projeto documenta a implementação de uma estratégia de backup baseada no modelo **3-2-1**, aplicada em um ambiente de homelab.

## Estratégia 3-2-1

A estratégia consiste em:

* **3 cópias dos dados**
* **2 tipos diferentes de mídia**
* **1 cópia fora da rede (offsite)**

### Implementação prática

Neste ambiente:

*  1 cópia local → `/backup`
*  1 cópia externa → `/mnt/backup` (pendrive ou HD)
*  1 cópia em nuvem → Mega (via rclone)

---

## Montagem de disco externo

Identifique o dispositivo:

```bash
lsblk
```

Crie o ponto de montagem:

```bash
mkdir -p /mnt/backup
```

Monte o dispositivo:

```bash
mount /dev/sdb /mnt/backup
```

---

## Criptografia com GPG

Os backups são criptografados utilizando **GPG (criptografia simétrica)**.

### Verificar instalação:

```bash
gpg --version
```

### Criptografar arquivo:

```bash
gpg -c backup.tar.gz
```

### Descriptografar:

```bash
gpg -d backup.tar.gz.gpg
```

---

## Backup em nuvem (rclone + Mega)

O envio para nuvem é feito utilizando o **rclone**, com integração ao Mega.

### Instalação:

```bash
wget https://downloads.rclone.org/rclone-current-linux-386.zip
unzip rclone-current-linux-386.zip
cp rclone-*/rclone /usr/local/bin/
```

### Configuração:

```bash
rclone config
```

### Verificar remotes:

```bash
rclone listremotes
```

---

## Script de Backup

O script automatiza:

* compactação dos dados
* criptografia com GPG
* cópia local
* cópia externa (se disponível)
* envio para nuvem
* geração de logs

### Estrutura

O script é dividido em:

* variáveis de configuração
* funções por tipo de backup
* função `main()` para execução

Exemplo:

```bash
main() {
    backup_local
    backup_usb
    backup_cloud
}
```

---

## Senha do GPG

A senha utilizada na criptografia é armazenada em:

```bash
/root/.gpg-passphrase
```

### Ajuste necessário:

```bash
export GPG_TTY=$(tty)
```

Adicionar no:

```bash
~/.bashrc
```

---

## Montagem automática (fstab)

Para montagem automática do dispositivo:

```bash
blkid
```

Adicionar no `/etc/fstab`:

```bash
UUID=XXXX-XXXX /mnt/backup ext4 defaults 0 0
```

---

## Automação com Cron

Execução automática do backup:

```bash
crontab -e
```

Exemplo:

```bash
0 2 */2 * * /usr/bin/flock -n /tmp/backup.lock /root/backup.sh
```

### Uso do `flock`

Evita execução simultânea do script:

```bash
flock -n /tmp/backup.lock /root/backup.sh
```

---

##  Recuperação de Desastres

O processo de restore é feito por um script separado, que:

* descriptografa o backup
* extrai para diretório temporário
* restaura diretórios por blocos

Exemplo:

```bash
main() {
    restore_var
    restore_home
    restore_root
}
```

Essa abordagem permite restaurar apenas partes específicas do sistema.


##  Referências

* Script de backup:
  https://github.com/Lukasrangel/homelab/blob/main/scripts/backup/backup.sh




