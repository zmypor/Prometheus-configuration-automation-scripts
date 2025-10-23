This script automatically creates Prometheus services to ensure they start and run smoothly with the system.

1.  #!/bin/bash
2.  # Configure Prometheus as a systemd service and verify
3. 
4.   SERVICE_FILE="/etc/systemd/system/prometheus.service"
5. 
6.   echo "Configuring Prometheus systemd service..."
7. 
8.   cat <<EOF | sudo tee $SERVICE_FILE
9.   [Unit]
10. Description=Prometheus Monitoring System
11. After=network.target
12.    
13.  [Service]
14.  User=nobody
15.  ExecStart=/usr/local/bin/prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data
16.  Restart=always
17.    
18.  [Install]
19.  WantedBy=multi-user.target
20.  EOF
21.    
22.  # Reload and Enable Service
23.  if sudo systemctl daemon-reload && sudo systemctl enable prometheus && sudo systemctl start prometheus; then
24.      echo "Prometheus service successfully configured and started."
25.  else
26.      echo "Configuration or startup of Prometheus service failed. Check the logs for details."
27.      exit 1
28.  fi

Set up the systemd service for Prometheus.
Prometheus starts with the system and can be managed like other services.
