#!/bin/bash
echo "Script iniciado"

# Diretório para salvar os logs
logs="/home/ubuntu/projeto/logs"

# Verificar o status do serviço
STATUS=$(systemctl is-active nginx)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$STATUS" = "active" ]; then
  echo "$TIMESTAMP - Nginx: ONLINE" >> $logs/online.log
  echo "Nginx está ONLINE"
else
  echo "$TIMESTAMP - Nginx: OFFLINE" >>$logs/offline.log
  echo "Nginx está OFFLINE"
fi

