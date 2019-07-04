[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always
Environment="DATABASE_URL=${db_ip}:27017"

[Install]
WantedBy=multi-user.target
