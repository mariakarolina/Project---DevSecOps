#!/bin/bash
echo "Script iniciado"

# Verificar o status do serviço
STATUS=$(systemctl is-active nginx)
DATA=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$STATUS" = "active" ]; then
  echo "$DATA - Nginx: ONLINE" >> online.log
  echo "Nginx está ONLINE"
else
  echo "$DATA - Nginx: OFFLINE" >> offline.log
  echo "Nginx está OFFLINE"
fi

