#!/usr/bin/bash -l

# Waiting for bootstrap completion:
FILE=/tmp/bootstrap_done

# Wait for file to exist
until [ -f $FILE ]; do
    echo "Waiting for ${FILE} ..."
    sleep 2
done

APP_HOME="/opt/hashicups/public-api"

while [ ! -d "$APP_HOME" ]
do
  echo "Waiting for ${APP_HOME} ..."
  sleep 1
done

APP_FILE=$APP_HOME/bin/amd64/public-api

if [ ! -f "$APP_FILE" ]; then
  echo "Building ${APP_FILE} ..."
  export GOPATH=/usr/local/go/bin
  export PATH=$PATH:$GOPATH
  cd $APP_HOME
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $APP_FILE
fi

SERVICE=/usr/lib/systemd/system/hashicups-public-api.service

until [ -f "$SERVICE" ]; do
  echo "Waiting for ${SERVICE} to be ready."
  sleep 1
done

cat << EOF > /tmp/local.conf
[Service]
Environment="BIND_ADDRESS=:8080"
Environment="PRODUCT_API_URI=http://${PRODUCT_API_IP}:9090"
Environment="PAYMENT_API_URI=http://localhost:18000"
EOF

sudo mv /tmp/local.conf /etc/systemd/system/hashicups-public-api.service.d/.
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
