Integrate Slack with Alertmanager to provide real-time alert notifications.

1.   #!/bin/bash
2.   # Configure Slack notifications
3.   cat <<EOF | sudo tee /opt/alertmanager/alertmanager.yml
4.   global:
5.      slack_api_url: 'https://hooks.slack.com/services/your/slack/webhook'
6. 
7.   route:
8.      receiver: slack
9. 
10.  receivers:
11.     - name: slack
12.        slack_configs:
13.          - channel: '#alerts'
14.             text: "{{ .CommonAnnotations.summary }}"
15.   EOF
16.    
17.   sudo systemctl restart alertmanager
18.   echo "Slack notifications have been configured."

Set up Alertmanager to send notifications to Slack channels.
