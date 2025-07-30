#!/bin/bash

SITE_URL="http://localhost"
LOG_FILE="/var/log/monitoramento.log"
WEBHOOK_URL="https://discord.com/api/webhooks/1399105955647590460/I8zeUsedU1Nh4GSYng2frVUZSmBYVpGxW6QtGFOBDDy-zrU6hDt9VkQWVSpl_NTT-40v"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

echo "Verificando o site: $SITE_URL"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
    log "✅ SUCESSO: O site está online! (Status: $HTTP_STATUS)"

else
    log "❌ FALHA: O site está fora do ar ou com problemas. (Status: $HTTP_STATUS)"
    
    MESSAGE="Site Caiu"
    JSON_PAYLOAD="{\"content\": \"$MESSAGE\"}"
    curl -X POST -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"

fi