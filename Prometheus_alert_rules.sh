This script creates an alarm rule for Prometheus, such as monitoring CPU usage or memory consumption.

1. #!/bin/bash
2. # Add an alarm rule to Prometheus and verify
3. 
4.  RULES_FILE="/opt/prometheus/alert_rules.yml"
5.  PROMETHEUS_CONFIG="/opt/prometheus/prometheus.yml"
6. 
7.  echo "Add an alarm rule..."
8. 
9.   if ! grep -q "alert_rules.yml" $PROMETHEUS_CONFIG; then
10.        cat <<EOF | sudo tee -a $PROMETHEUS_CONFIG
11.  rule_files:
12.        - $RULES_FILE
13.  EOF
14.       echo "The rule file has been linked to Prometheus configuration。"
15.  fi
16.    
17.  # Create an Alarm Rule
18.  cat <<EOF | sudo tee $RULES_FILE
19.  groups:
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
