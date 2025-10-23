Schedule regular PromQL queries to generate reports or health checks.

1.  #!/bin/bash
2.  # Run PromQL query and display results
3. 
4.   PROMETHEUS_URL=${1:-"http://localhost:9090"}
5.   QUERY=${2:-"up"}
6.   QUERY_ENDPOINT="$PROMETHEUS_URL/api/v1/query"
7. 
8.   echo "Runingn PromQL query: $QUERY..."
9. 
10.    response=$(curl -s "$QUERY_ENDPOINT?query=$QUERY")
11.    
12.  if jq -e . >/dev/null 2>&1 <<<"$response"; then
13.     echo "Query results:"
14.     echo "$response" | jq '.data.result[] | {metric: .metric, value: .value}'
15.  else
16.     echo "Error: Failed to retrieve query results! Ensure that Prometheus is accessible under $PROMETHEUS_URL"
17.     exit 1
18.  fi

Automated PromQL queries and formatted output to improve readability.
Suitable for regular health checks.
