# Container image entrypoint
set -xe

openssl genrsa -out keypair.pem 4096
openssl rsa -in keypair.pem -pubout -out publickey.crt
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in keypair.pem -out pkcs8.key

export PUBLIC_KEY="$(cat publickey.crt)"
export PRIVATE_KEY="$(cat pkcs8.key)"

head -n 10000 /dev/urandom | sha384sum | awk '{print $1}' | tee ../webhook
head -n 10000 /dev/urandom | sha384sum | awk '{print $1}' | tee ../password

WEBHOOK_GENERATED="$(cat ../webhook)"
PASSWORD_GENERATED="$(cat ../password)"

# NODE_ENV=production
# PORT=8000 ACCOUNT=push
# ADMIN_USERNAME=admin
# FDQN

export WEBHOOK_PATH="${WEBHOOK:-${WEBHOOK_GENERATED}}"
export ADMIN_PASSWORD="${PASSWORD:-${PASSWORD_GENERATED}}"

npm run start

