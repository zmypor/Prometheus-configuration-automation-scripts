This script automates the integration of Alertmanager with Prometheus for alerting purposes.

1.  #!/bin/bash
2.  # Integrate Alertmanager into Prometheus configuration
3. 
4.  PROMETHEUS_CONFIG="/opt/prometheus/prometheus.yml"
5. 
6.  echo "Integrating Alertmanager into Prometheus..."
7. 
8.  if grep -q "alertmanagers" $PROMETHEUS_CONFIG; then
9.     echo "Alertmanager configuration already exists in $PROMETHEUS_CONFIG."
10. else
11.    cat <<EOF | sudo tee -a $PROMETHEUS_CONFIG
12. alerting:
13.      alertmanagers:
14.        - static_configs:
15.            - targets: ['localhost:9093']
16.  EOF
17.        echo "A Alertmanager configuration has been added to PROMETHEUS_CONFIG."
18.        sudo systemctl restart Prometheus&&echo "Prometheus reboots successful."
19.   fi

Add the Alertmanager configuration to the prometheus.yml file.
Restart Prometheus to apply the changes.
