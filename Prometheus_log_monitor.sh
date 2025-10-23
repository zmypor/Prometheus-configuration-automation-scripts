      #!/bin/bash
2.   # Monitor errors in Prometheus logs
3.
4.    LOG_FILE=${1:-"/var/log/prometheus/prometheus.log"}
5.    TAIL_LINES=${2:-100}
6. 
7.    echo "Check for errors in the last $TAIL_LINES lines of Prometheus log $LOG_FILE..."
8. 
9.    if [ ! -f "$LOG_FILE" ]; then
10.        echo "Error: The log file $LOG_FILE does not exist!"
11.        exit 1
12.  fi
13.    
14.  grep -i "error" <(tail -n $TAIL_LINES "$LOG_FILE") || echo "No error was found in the last $TAIL_LINES lines。"
