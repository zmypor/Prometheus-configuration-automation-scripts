This script sends a test alert to Alertmanager to check if it works as expected or to identify and fix errors.
1.  #!/bin/bash
2.  # Send test alerts to Alertmanager
3. 
4.  ALERTMANAGER_URL=${1:-"http://localhost:9093"}
5.  RECEIVER=${2:-"default"}
6.  ALERT_FILE=${3:-"/tmp/test_alert.json"}
7. 
8.  echo "Sending a test alert to Alertmanager to $ALERTMANAGER_URL..."
9. 
10. # Create Test Alarm Load
11. cat <<EOF > $ALERT_FILE
12.  [\
13.    {\
14.      "labels": 
               {\
15.          "alertname": "TestAlert",\
16.          "severity": "info"\
17.           },\
18.        "annotations": 
                {\
19.          "summary": "This is a test alarm."\
20.           },\
21.        "startsAt": "$(date -Iseconds)"\
22.      }\
23.  ]
24.  EOF
25.    
26.  response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" \
27.      -d @"$ALERT_FILE" "$ALERTMANAGER_URL/api/v1/alerts")
28.    
29.  if [ "$response" -eq 200 ]; then
30.      echo "Test alarm successfully sent to receiver: $RECEIVER。"
31.  else
32.      echo "Error: Failed to send a test alarm. HTTP status code: $response"
33.      exit 1
34.  fi

Create JSON files for customizable test alarms
