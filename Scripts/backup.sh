#!/bin/bash
set -e




# Instalando dependencias
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y nginx
apt-get install -y curl
apt-get install -y wget
apt-get install -y git


# Configurando o Nginx
mkdir -p /var/www/meusite.com
cat <<EOF > /etc/nginx/sites-available/meusite.conf
server {
    listen 80;
    server_name meusite.com www.meusite.com;

    root /var/www/meusite.com;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }


    location ~ /\.ht {
        deny all;
    }
}
EOF

ln -s /etc/nginx/sites-available/meusite.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
chown -R www-data:www-data /var/www/meusite.com
mkdir -p /etc/systemd/system/nginx.service.d




# Configurando a pagina HTML
wget -O /var/www/meusite.com/pagina.html https://raw.githubusercontent.com/alexsandroocanha/html/refs/heads/main/pagina.html


# Configurando o Servidor Linux reiniciar o Nginx caso ele caia
cat <<EOF > /etc/systemd/system/nginx.service.d/override.conf
[Service]
Restart=always
RestartSec=5s
EOF

systemctl daemon-reload
nginx -t
systemctl restart nginx



# Configurando o Script de Monitoramento
mkdir -p /opt/scripts
touch /var/log/monitoramento.log && chown ubuntu:ubuntu /var/log/monitoramento.log

cat <<'EOF' > /opt/scripts/monitor.sh
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
EOF

chmod +x /opt/scripts/monitor.sh



#Configurando para que ele verifique a cada 1 m
cat <<EOF > /etc/cron.d/monitor_site_bash
*/1 * * * * ubuntu /bin/bash /opt/scripts/monitor.sh
EOF


chmod 0644 /etc/cron.d/monitor_site_bash
systemctl restart cron


cd /tmp

wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

wget -O /opt/aws/amazon-cloudwatch-agent/etc/config.json https://raw.githubusercontent.com/alexsandroocanha/json/refs/heads/main/config.json


sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json -s