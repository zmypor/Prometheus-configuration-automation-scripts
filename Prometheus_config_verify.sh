Verify prometheus.yml before applying changes to avoid errors.

1.   #!/bin/bash
2.   # Verify Prometheus configuration
3. 
4.    CONFIG_FILE="/opt/prometheus/prometheus.yml"
5.    PROMTOOL_CMD="promtool"
6. 
7.   # Check if promtool is installed
8.   if ! command -v $PROMTOOL_CMD &> /dev/null; then
9.      echo "Error: Promtool is not installed or not in PATH."
10.    exit 1
11.  fi
12.    
13. # Check if the configuration file exists
14.  if [ ! -f "$CONFIG_FILE" ]; then
15.     echo "Error: Configuration file  '$CONFIG_FILE' is not found"
16.     exit 1
17.  fi
18.    
19. # Verify Prometheus configuration
20.  $PROMTOOL_CMD check config "$CONFIG_FILE"
21.   if [ $? -eq 0 ]; then
22.       echo "The configuration is valid"
23.   else
24.       echo "Configuration verification failed."
25.    fi

Use promtool to check Prometheus configuration syntax.
Prevent service interruption caused by configuration errors.
