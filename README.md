# Prometheus-configuration-automation-scripts
1. Service configuration script
Automatically create Prometheus services to ensure they start and run smoothly with the system.
1. #!/bin/bash
2. # Configure Prometheus as a systemd service and verify
3. 
4. SERVICE_FILE="/etc/systemd/system/prometheus.service"
5. 
6. echo "Configuring Prometheus systemd service..."
7. 
8. cat <<EOF | sudo tee $SERVICE_FILE
9. [Unit]
10.    Description=Prometheus Monitoring System
11.    After=network.target
12.    
13. [Service]
14.    User=nobody
15.    ExecStart=/usr/local/bin/prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data
16.    Restart=always
17.    
18. [Install]
19.    WantedBy=multi-user.target
20.    EOF
21.    
22.    # Reload and Enable Service
23.    if sudo systemctl daemon-reload && sudo systemctl enable prometheus && sudo systemctl start prometheus; then
24.        echo "Prometheus service successfully configured and started."
25.    else
26.        echo "Configuration or startup of Prometheus service failed. Check the logs for details."
27.        exit 1
28.    fi
Set up the systemd service for Prometheus.
Prometheus starts with the system and can be managed like other services.

2. Alertmanager integration
This script automates the integration of Alertmanager with Prometheus for alerting purposes.
1. #!/bin/bash
2. # Integrate Alertmanager into Prometheus configuration
3. 
4. PROMETHEUS_CONFIG="/opt/prometheus/prometheus.yml"
5. 
6. echo "Integrating Alertmanager into Prometheus..."
7. 
8. if grep -q "alertmanagers" $PROMETHEUS_CONFIG; then
9.     echo "Alertmanager configuration already exists in $PROMETHEUS_CONFIG."
10.    else
11.        cat <<EOF | sudo tee -a $PROMETHEUS_CONFIG
12.    alerting:
13.      alertmanagers:
14.        - static_configs:
15.            - targets: ['localhost:9093']
16.    EOF
17.        echo "A Alertmanager configuration has been added to PROMETHEUS_CONFIG."
18.        sudo systemctl restart Prometheus&&echo "Prometheus reboots successful."
19.    fi
Add the Alertmanager configuration to the prometheus.yml file.
Restart Prometheus to apply the changes.
       
3. Automated exporter settings
Prometheus uses an exporter to capture metrics. This script automates the installation and configuration of Node Exporter。
1. #!/bin/bash
2. # Install and configure Node Exporter
3. 
4. VERSION=${1:-"1.7.0"} # Default Node Exporter version
5. BIN_DIR="/usr/local/bin"
6. SERVICE_FILE="/etc/systemd/system/node_exporter.service"
7. 
8. echo "Install the Node Exporter version $VERSION..."
9. 
10.    if wget -q https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz; then
11.        tar -xzf node_exporter-$VERSION.linux-amd64.tar.gz
12.        sudo mv node_exporter-$VERSION.linux-amd64/node_exporter $BIN_DIR/
13.        sudo useradd -M -r -s /bin/false node_exporter || echo " The user node_exporter already exists."
14.    
15.        # Create Systemd Service
16.        cat <<EOF | sudo tee $SERVICE_FILE
17. [Unit]
18.    Description=Node Exporter
19.    After=network.target
20.    
21. [Service]
22.    User=node_exporter
23.    ExecStart=$BIN_DIR/node_exporter
24.    Restart=always
25.    
26. [Install]
27.    WantedBy=multi-user.target
28.    EOF
29.    
30.        sudo systemctl daemon-reload
31.        sudo systemctl enable node_exporter && sudo systemctl start node_exporter
32.        echo "Node Exporter is installed and running as a service "
33.    else
34.        echo "Error: Failed to download Node Exporter version $VERSION. Check the version and try again."
35.        exit 1
36.    fi
Install Node Exporter and set up the systemd service for it.
System metrics are available for Prometheus to use.


4. Creation of automated rules
This script creates an alarm rule for Prometheus, such as monitoring CPU usage or memory consumption.
1. #!/bin/bash
2. # Add an alarm rule to Prometheus and verify
3. 
4. RULES_FILE="/opt/prometheus/alert_rules.yml"
5. PROMETHEUS_CONFIG="/opt/prometheus/prometheus.yml"
6. 
7. echo "Add an alarm rule..."
8. 
9. if ! grep -q "alert_rules.yml" $PROMETHEUS_CONFIG; then
10.        cat <<EOF | sudo tee -a $PROMETHEUS_CONFIG
11.    rule_files:
12.      - $RULES_FILE
13.    EOF
14.        echo "The rule file has been linked to Prometheus configuration。"
15.    fi
16.    
17.    # Create an Alarm Rule
18.    cat <<EOF | sudo tee $RULES_FILE
19.    groups:
20.      - name: example_alerts
21.        rules:
22.          - alert: HighCPUUsage
23.            expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
24.            for: 2m
25.            labels:
26.              severity: warning
27.            annotations:
28.              summary: "High CPU usage detected"
29.              description: "The CPU usage of instance {{ $labels.instance }} has exceeded 80% in the past 2 minutes."
30.    EOF
31.    
32.    sudo systemctl restart prometheus && echo "Alarm rule has been added and Prometheus has been restarted."

Create rule files to monitor system performance.
Prometheus triggers alarms based on defined thresholds.

5.Grafana dashboard import
This script uses Grafana API to automate dashboard import.
1. #!/bin/bash
2. # Import the JSON File of Grafana Dashboard
3. 
4. GRAFANA_URL=${1:-"http://localhost:3000"}
5. DASHBOARD_FILE=${2:-"/path/to/dashboard.json"}
6. API_KEY=${3:-"your_api_key"}
7. 
8. echo "Importing Grafana dashboard from $DASHBARD_FILE to $GRAFANA_URL..."
9. 
10.    if [ ! -f "$DASHBOARD_FILE" ]; then
11.        echo "Error: The dashboard file $DASHBEARD_FILE does not exist!"
12.        exit 1
13.    fi
14.    
15.    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Authorization: Bearer $API_KEY" \
16.      -H "Content-Type: application/json" \
17.      -d @"$DASHBOARD_FILE" "$GRAFANA_URL/api/dashboards/db")
18.    
19.    if [ "$response" -eq 200 ]; then
20.        echo "Dashboard successfully imported"
21.    else
22.        echo "Error: Dashboard import failed! HTTP status code: $response "
23.        exit 1
24.    fi

Upload the pre-defined JSON file of dashboard s using Grafana API.
Simplify dashboard configuration.

6. Automated PromQL queries
Schedule regular PromQL queries to generate reports or health checks.
1. #!/bin/bash
2. # Run PromQL query and display results
3. 
4. PROMETHEUS_URL=${1:-"http://localhost:9090"}
5. QUERY=${2:-"up"}
6. QUERY_ENDPOINT="$PROMETHEUS_URL/api/v1/query"
7. 
8. echo "Runingn PromQL query: $QUERY..."
9. 
10.    response=$(curl -s "$QUERY_ENDPOINT?query=$QUERY")
11.    
12.    if jq -e . >/dev/null 2>&1 <<<"$response"; then
13.        echo "Query results:"
14.        echo "$response" | jq '.data.result[] | {metric: .metric, value: .value}'
15.    else
16.        echo "Error: Failed to retrieve query results! Ensure that Prometheus is accessible under $PROMETHEUS_URL"
17.        exit 1
18.    fi

Automated PromQL queries and formatted output to improve readability.
Suitable for regular health checks.

7. Slack alarm notifications
Integrate Slack with Alertmanager to provide real-time alert notifications.

1. #!/bin/bash
2. # Configure Slack notifications
3. cat <<EOF | sudo tee /opt/alertmanager/alertmanager.yml
4. global:
5.   slack_api_url: 'https://hooks.slack.com/services/your/slack/webhook'
6. 
7. route:
8.   receiver: slack
9. 
10.    receivers:
11.      - name: slack
12.        slack_configs:
13.          - channel: '#alerts'
14.            text: "{{ .CommonAnnotations.summary }}"
15.    EOF
16.    
17.    sudo systemctl restart alertmanager
18.    echo "SSlack notifications have been configured."
Set up Alertmanager to send notifications to Slack channels.
       
8. Backup Script
Backup Prometheus data and configuration.
1. #!/bin/bash
2. # Prometheus data backup directory
3. 
4. DATA_DIR=${1:-"/opt/prometheus/data"}
5. BACKUP_DIR=${2:-"/backups/prometheus"}
6. TIMESTAMP=$(date +"%Y%m%d%H%M%S")
7. 
8. echo "Backing up Prometheus data from $DATA_DIR to $BACKUP_DIR..."
9. 
10.    if [ ! -d "$DATA_DIR" ]; then
11.        echo "Error: Prometheus data directory $DATA_DIR does not exist!"
12.        exit 1
13.    fi
14.    
15.    sudo mkdir -p "$BACKUP_DIR"
16.    sudo tar -czvf "$BACKUP_DIR/prometheus_backup_$TIMESTAMP.tar.gz" "$DATA_DIR"
17.    
18.    if [ $? -eq 0 ]; then
19.        echo " Backup completed: $BACKUP_DIR/prometheus_backup_$TIMESTAMP.tar.gz"
20.    else
21.        echo "Error: Backup failed. Please check permissions and disk space"
22.        exit 1
23.    fi

Compress and save Prometheus data for recovery.

9. Automated configuration verification
Verify prometheus.yml before applying changes to avoid errors.
1. #!/bin/bash
2. # Verify Prometheus configuration
3. 
4. CONFIG_FILE="/opt/prometheus/prometheus.yml"
5. PROMTOOL_CMD="promtool"
6. 
7. # Check if promtool is installed
8. if ! command -v $PROMTOOL_CMD &> /dev/null; then
9.     echo "Error: Promtool is not installed or not in PATH."
10.        exit 1
11.    fi
12.    
13.    # Check if the configuration file exists
14.    if [ ! -f "$CONFIG_FILE" ]; then
15.        echo "Error: Configuration file  '$CONFIG_FILE' is not found"
16.        exit 1
17.    fi
18.    
19.    # Verify Prometheus configuration
20.    $PROMTOOL_CMD check config "$CONFIG_FILE"
21.    if [ $? -eq 0 ]; then
22.        echo "The configuration is valid"
23.    else
24.        echo "Configuration verification failed."
25.    fi

Use promtool to check Prometheus configuration syntax.
Prevent service interruption caused by configuration errors.

10. Alertmanager Receiver Test Script
This script sends a test alert to Alertmanager to check if it works as expected or to identify and fix errors.
1. #!/bin/bash
2. # Send test alerts to Alertmanager
3. 
4. ALERTMANAGER_URL=${1:-"http://localhost:9093"}
5. RECEIVER=${2:-"default"}
6. ALERT_FILE=${3:-"/tmp/test_alert.json"}
7. 
8. echo "Sending a test alert to Alertmanager to $ALERTMANAGER_URL..."
9. 
10.    # Create Test Alarm Load
11.    cat <<EOF > $ALERT_FILE
12.    [\
13.      {\
14.        "labels": {\
15.          "alertname": "TestAlert",\
16.          "severity": "info"\
17.        },\
18.        "annotations": {\
19.          "summary": "This is a test alarm."\
20.        },\
21.        "startsAt": "$(date -Iseconds)"\
22.      }\
23.    ]
24.    EOF
25.    
26.    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" \
27.      -d @"$ALERT_FILE" "$ALERTMANAGER_URL/api/v1/alerts")
28.    
29.    if [ "$response" -eq 200 ]; then
30.        echo "Test alarm successfully sent to receiver: $RECEIVER。"
31.    else
32.        echo "Error: Failed to send a test alarm. HTTP status code: $response"
33.        exit 1
34.    fi

Create JSON files for customizable test alarms
       
11. Prometheus log monitoring script
1. #!/bin/bash
2. # Monitor errors in Prometheus logs
3.
4. LOG_FILE=${1:-"/var/log/prometheus/prometheus.log"}
5. TAIL_LINES=${2:-100}
6. 
7. echo "Check for errors in the last $TAIL_LINES lines of Prometheus log $LOG_FILE..."
8. 
9. if [ ! -f "$LOG_FILE" ]; then
10.        echo "Error: The log file $LOG_FILE does not exist!"
11.        exit 1
12.    fi
13.    
14.    grep -i "error" <(tail -n $TAIL_LINES "$LOG_FILE") || echo "No error was found in the last $TAIL_LINES lines。"

