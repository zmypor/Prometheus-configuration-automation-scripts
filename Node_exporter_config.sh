Prometheus uses an exporter to capture metrics. This script automates the installation and configuration of Node Exporter.

1.   #!/bin/bash
2.   # Install and configure Node Exporter
3. 
4.   VERSION=${1:-"1.7.0"} # Default Node Exporter version
5.   BIN_DIR="/usr/local/bin"
6.   SERVICE_FILE="/etc/systemd/system/node_exporter.service"
7. 
8.   echo "Install the Node Exporter version $VERSION..."
9. 
10.  if wget -q https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz; then
11.      tar -xzf node_exporter-$VERSION.linux-amd64.tar.gz
12.      sudo mv node_exporter-$VERSION.linux-amd64/node_exporter $BIN_DIR/
13.      sudo useradd -M -r -s /bin/false node_exporter || echo " The user node_exporter already exists."
14.    
15.   # Create Systemd Service
16.      cat <<EOF | sudo tee $SERVICE_FILE
17.  [Unit]
18.  Description=Node Exporter
19.  After=network.target
20.    
21.  [Service]
22.  User=node_exporter
23.  ExecStart=$BIN_DIR/node_exporter
24.  Restart=always
25.    
26.  [Install]
27.  WantedBy=multi-user.target
28.  EOF
29.    
30.        sudo systemctl daemon-reload
31.        sudo systemctl enable node_exporter && sudo systemctl start node_exporter
32.        echo "Node Exporter is installed and running as a service "
33.  else
34.       echo "Error: Failed to download Node Exporter version $VERSION. Check the version and try again."
35.        exit 1
36.    fi

Install Node Exporter and set up the systemd service for it.
System metrics are available for Prometheus to use.
