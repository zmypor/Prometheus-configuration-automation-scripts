This script uses Grafana API to automate dashboard import.

1.    #!/bin/bash
2.    # Import the JSON File of Grafana Dashboard
3. 
4.    GRAFANA_URL=${1:-"http://localhost:3000"}
5.    DASHBOARD_FILE=${2:-"/path/to/dashboard.json"}
6.    API_KEY=${3:-"your_api_key"}
7. 
8.    echo "Importing Grafana dashboard from $DASHBARD_FILE to $GRAFANA_URL..."
9. 
10.   if [ ! -f "$DASHBOARD_FILE" ]; then
11.     echo "Error: The dashboard file $DASHBEARD_FILE does not exist!"
12.     exit 1
13.   fi
14.    
15.   response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Authorization: Bearer $API_KEY" \
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
