#!/bin/bash

# Ищем все устройства sd* и удаляем лишние строки
ls -la /dev/sd* | awk -F/ '{print $3}' > /tmp/check_disks_for_delete.log

# Удаляем диск sda, так как он всегда идет системным
sed -i '/sda/d' /tmp/check_disks_for_delete.log

# Считываем все диски из файла и проверяем его в физических томах
while read LINE
do
        DEVUST=$(/usr/sbin/pvdisplay | grep $LINE)
        if [[ -z "$DEVUST"  ]]
        then
                echo "$LINE" >> /tmp/check_disks_for_delete_final.log
        fi
done < /tmp/check_disks_for_delete.log

# Удаляем старый log файл
rm -f /tmp/check_disks_for_delete.log

### По итогу, должен появится файл /tmp/check_disks_for_delete_final.log c дисками
### Если его нет, значит что нет дисков которые не размечены