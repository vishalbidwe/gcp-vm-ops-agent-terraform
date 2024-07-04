
#!/bin/bash
sudo su
apt-get update

# Donwload and Install ops-agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# Install nginx light
apt-get install nginx-light -y

# Configure logging metrics for nginx server vm 
set -e
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    nginx:
      type: nginx
      stub_status_url: http://127.0.0.1:80/nginx_status
  service:
    pipelines:
      nginx:
        receivers:
          - nginx
logging:
  receivers:
    nginx_access:
      type: nginx_access
    nginx_error:
      type: nginx_error
  service:
    pipelines:
      nginx:
        receivers:
          - nginx_access
          - nginx_error
EOF

sudo service google-cloud-ops-agent restart
sudo service nginx reload
sleep 60

# Test Errors
for i in $(seq 1 20);
do
  curl http://127.0.0.2/test_error
  sleep 5
done