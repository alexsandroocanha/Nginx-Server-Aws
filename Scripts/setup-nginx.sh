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
mkdir -p /var/www/meusite.com/

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
wget -O /var/www/meusite.com/index.html https://raw.githubusercontent.com/alexsandroocanha/Trabalho-Compass-01/refs/heads/main/Configuracoes/pagina.html

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

wget -O /opt/scripts/monitor.sh https://raw.githubusercontent.com/alexsandroocanha/Trabalho-Compass-01/refs/heads/main/Configuracoes/script.sh

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

wget -O /opt/aws/amazon-cloudwatch-agent/etc/config.json https://raw.githubusercontent.com/alexsandroocanha/Trabalho-Compass-01/refs/heads/main/Configuracoes/config.json

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json -s