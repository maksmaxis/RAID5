#!/usr/bin/bash

# Поставить утилиту mdadm
yum install -y mdadm

#Построение массива RAID5 с 5 активными устройствами
mdadm --create --verbose --level=5 --metadata=1.2 --chunk=512 --raid-devices=5 /dev/md0 /dev/sd[b-f]

mkdir -p /raid/part{1,2,3,4,5}
# Создаем раздел GPT на RAID
parted -s /dev/md0 mklabel gpt
for i in $(seq 1 5) ; do parted /dev/md0 -s mkpart primary ${i}00Mib $((i+1))00Mib ; done
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done

# Смонтировать их по каталогам
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done

# Создать директорию кофнигурации
mkdir /etc/mdadm/ && touch mdadm.conf
# Сохранение Raid 5 конфигурации mdadm.conf
echo 'DEVICE partitions' > /etc/mdadm/mdadm.conf && mdadm --detail --scan >> /etc/mdadm/mdadm.conf

blkid /dev/md0p* | while read line; do

        md="$(echo $line | awk '{print $1}' | sed 's/://g')"
        uuid="$(echo $line | awk '{print $2}' | sed 's/UUID="//g' | sed 's/"//g')"

        echo "UUID=$uuid $md ext4 defaults 0 0" >> /etc/fstab



done