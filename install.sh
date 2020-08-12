#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install build-essential nginx python3-pip -y
sudo apt-get install python3-venv -y
sudo ufw --force enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

pip3 install wheel

# sudo systemctl status nginx
git clone  https://github.com/hamada147/python-flask-gcloud.git
mv python-flask-gcloud app
cd app
python3 -m venv env
source ./env/bin/activate
pip install -r requirements.txt

# sudo nano /etc/systemd/system/app.service
sudo touch /etc/systemd/system/app.service
echo "[Unit]" >> /etc/systemd/system/app.service
echo "Description=A simple Flask uWSGI application" >> /etc/systemd/system/app.service
echo "After=network.target" >> /etc/systemd/system/app.service
echo "[Service]" >> /etc/systemd/system/app.service
echo "User=moussa_ahmed95" >> /etc/systemd/system/app.service
echo "Group=www-data" >> /etc/systemd/system/app.service
echo "WorkingDirectory=/home/moussa_ahmed95/app" >> /etc/systemd/system/app.service
echo 'Environment="PATH=/home/moussa_ahmed95/app/env/bin"' >> /etc/systemd/system/app.service
echo "ExecStart=/home/moussa_ahmed95/app/env/bin/uwsgi --ini app.ini" >> /etc/systemd/system/app.service
echo "[Install]" >> /etc/systemd/system/app.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/app.service

sudo systemctl start app
sudo systemctl enable app
# sudo systemctl status app

# sudo nano /etc/nginx/sites-available/app
$ip=curl ifconfig.me
sudo touch /etc/nginx/sites-available/app
echo "server {" >> /etc/nginx/sites-available/app
echo "listen 80;" >> /etc/nginx/sites-available/app
echo "server_name $ip;" >> /etc/nginx/sites-available/app
echo "location / {" >> /etc/nginx/sites-available/app
echo "include uwsgi_params;" >> /etc/nginx/sites-available/app
echo "uwsgi_pass unix:/home/moussa_ahmed95/app/app.sock;" >> /etc/nginx/sites-available/app
echo "}" >> /etc/nginx/sites-available/app
echo "}" >> /etc/nginx/sites-available/app

sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled
sudo systemctl restart nginx