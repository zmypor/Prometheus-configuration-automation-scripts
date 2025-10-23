Backup Prometheus data and configuration.
1.    #!/bin/bash
2.    # Prometheus data backup directory
3. 
4.    DATA_DIR=${1:-"/opt/prometheus/data"}
5.    BACKUP_DIR=${2:-"/backups/prometheus"}
6.    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
7. 
8.     echo "Backing up Prometheus data from $DATA_DIR to $BACKUP_DIR..."
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
