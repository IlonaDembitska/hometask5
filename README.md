Ilona Dembitska, 
#!/bin/bash
set -x

# === Створення папок ===
mkdir -p /root/folder1 /root/folder2

# === Створення скрипта, який переносить файли ===
cat << 'EOF' > /root/mover.sh
#!/bin/bash
while true; do
  if [ "$(ls -A /root/folder1 2>/dev/null)" ]; then
    mv -v /root/folder1/* /root/folder2/
  fi
  sleep 5
done
EOF

chmod +x /root/mover.sh

# === Створення systemd-сервісу ===
cat << 'EOF' > /etc/systemd/system/move_daemon.service
[Unit]
Description=Move Daemon Service

[Service]
ExecStart=/root/mover.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# === Активація сервісу ===
systemctl daemon-reload
systemctl start move_daemon.service
systemctl enable move_daemon.service

Ilona Dembitska, [04.11.2025 18:17]
# 1️ Підключитись до EC2
ssh -i "Anna-dev.pem" ubuntu@<твій_public_ip>

# 2️ Перевірити статус демона
sudo systemctl status move_daemon.service

# 3️ Перевірити автозапуск
sudo systemctl is-enabled move_daemon.service

# 4️ Перевірити роботи
sudo touch /root/folder1/test1.txt
sleep 5
ls /root/folder2

# 5️ Зупинити демон (якщо потрібно)
sudo systemctl stop move_daemon.service
