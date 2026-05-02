# zRAM: compactação de memória swap no Linux

Enfrentando o impacto de gargalo de RAM em meu homelab, busquei utilizar o zram para dar maior estabilidade ao sistema,
e fazer ele não crashar em caso de falta de RAM.

O zram é um módulo nativo do Linux que cria um sistema de arquivos swap compactado dentro da memória RAM. A compactação cria
um dispositivo de swap virtual (/dev/zram), fazendo com que a troca de informações de swap fique muito mais rápida.
É indicado para quando você tem diferentes serviços competindo pela memória RAM.

O zram diminui a escrita no disco, melhorando a vida útil do HD ou SSD e deixa o sistema mais estável,
pois ao invés da degradação rápida que acontece no sistema quando a RAM esgota, aqui temos memória swap muito mais rápida e compactada.
A compactação do swap exige um custo do processador, mas geralmente vale a pena.

O zram é melhor para sistemas com pouca RAM, como 4GB, e que possuem distintos processos.
Como em qualquer ajuste de infraestrutura, a escolha deve ser baseada em contexto e testes práticos.

---

## Instalação no Debian

```bash
sudo apt install zram-tools
```

---

## Verificar o serviço

```bash
sudo systemctl status zramswap
```

---

## Configuração

Edite o arquivo:

```bash
sudo nano /etc/default/zram
```

```bash
# Compression algorithm selection
# speed: lz4 > zstd
# compression: zstd > lz4
ALGO=zstd

# Specifies the amount of RAM that should be used for zram
# based on a percentage the total amount of available memory
PERCENT=50

# Specifies a static amount of RAM that should be used for
# the ZRAM devices, this is in MiB
SIZE=1024

# Specifies the priority for the swap devices. 
# Higher number = higher priority
PRIORITY=100
```

**Parâmetros:**

* `ALGO`: tipo de compactação — `lz4` é mais rápida, `zstd` é mais compacta
* `PERCENT`: porcentagem da RAM física que o zram irá utilizar
* `SIZE`: tamanho fixo do swap (em MiB)
* `PRIORITY`: prioridade da swap (deve ser maior que a do disco)

---

## Aplicar alterações

```bash
sudo systemctl restart zramswap
sudo systemctl status zramswap
```

---

## Ajuste de swappiness

```bash
sudo sysctl vm.swappiness=100
```

O `vm.swappiness` varia de 1 a 200.
Valores maiores fazem o kernel mover dados mais cedo para o swap (zram), o que é estratégico nesse cenário.

---

## Desabilitar swap em disco

Edite o arquivo `/etc/fstab` e comente a linha da partição swap.

---

## Verificar uso de swap

```bash
# desliga e limpa a partição swap física
sudo swapoff /dev/sda3  # ou a partição conforme seu fstab

# mostra as partições swap ativas
swapon --show
```

---

## Verificar compressão

```bash
zramctl
```

**Saída exemplo:**

```
NAME       ALGORITHM DISKSIZE  DATA COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram0 zstd          1,9G 63,9M 16,8M 18,3M       4 [SWAP]
```

---

## Desvendando o ganho real (zramctl)

Interpretação técnica:

* **DATA (63,9M):** quantidade real de dados enviados para o swap
* **COMPR (16,8M):** tamanho após compressão
* **TOTAL (18,3M):** custo real na RAM (incluindo overhead)

---

## Monitoramento de disco

```bash
iostat -xz 2
```

Esse comando mostra, a cada 2 segundos, a utilização do disco.

* `%util`: percentual de tempo em que o disco ficou ocupado
* Ideal: valores próximos de 0–1%

Valores baixos indicam que:

* o disco não é gargalo
* operações ocorrem sem fila
* há menor desgaste em HD/SSD
