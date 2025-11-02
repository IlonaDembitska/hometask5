#!/bin/bash
set -eux

# === Оновлюємо систему та встановлюємо утиліти ===
apt update -y && apt install -y mc

# === Створюємо папки для перевірки ===
mkdir -p /root/folder1 /root/folder2

# === Створюємо нескінченний move-скрипт ===
cat << 'EOF' > /root/mover.sh
#!/bin/bash
SRC="/root/folder1"
DST="/root/folder2"

while true; do
  # Якщо в SRC є файли — переносимо
  if [ "$(ls -A "$SRC" 2>/dev/null)" ]; then
    mv -v "$SRC"/* "$DST"/ 2>/dev/null
  fi
  sleep 5
done
EOF

chmod +x /root/mover.sh

# === Створюємо systemd-сервіс ===
cat << 'EOF' > /etc/systemd/system/mover.service
[Unit]
Description=Move files from /root/folder1 to /root/folder2
After=network.target

[Service]
ExecStart=/root/mover.sh
Restart=always
RestartSec=2
User=root

[Install]
WantedBy=multi-user.target
EOF

# === Активуємо й запускаємо демон ===
systemctl daemon-reload
systemctl enable mover.service
systemctl start mover.service