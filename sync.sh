#!/usr/bin/env bash
#set -x

if [ -z "$S3_BUCKET" ]; then
    echo "Need to set S3_BUCKET"
    exit 1
fi

if [ -z "$S3_PATH" ]; then
    echo "Need to set S3_PATH"
    exit 1
fi

if [ -z "$S3_FILE" ]; then
    echo "Need to set S3_FILE"
    exit 1
fi

if [ -z "$CONSUL_HOST" ]; then
    echo "Need to set CONSUL_HOST"
    exit 1
fi

if [ -z "$CONSUL_PORT" ]; then
    echo "Need to set CONSUL_HOST"
    exit 1
fi

if [ -z "$BACKUP_INTERVAL" ]; then
    echo "Need to set BACKUP_INTERVAL"
    exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Need to set AWS_ACCESS_KEY_ID"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Need to set AWS_SECRET_ACCESS_KEY"
    exit 1
fi

while true; do
    echo ">>> Downloading Consul's KV store from '$CONSUL_HOST:$CONSUL_PORT' ..."
    consulate --api-host ${CONSUL_HOST} --api-port ${CONSUL_PORT} kv backup > /tmp/${S3_FILE}.json

    # Avoid the error message of next command
    touch /tmp/$S3_FILE-latest.json

    # Compare the cache file with the downloaded file
    diff -u /tmp/$S3_FILE.json /tmp/$S3_FILE-latest.json > /dev/null
    if [ "$?" -gt 0 ]; then
        echo ">>> Copying backup into AWS S3 bucket '$S3_BUCKET' ..."
        aws s3 cp /tmp/${S3_FILE}.json s3://${S3_BUCKET}/${S3_PATH}/${S3_FILE}-$(date +%s).json
        if [ "$?" -eq 0 ]; then
            echo ">>> Caching backup file ..."
            cp /tmp/${S3_FILE}.json /tmp/${S3_FILE}-latest.json
        fi
    else
        echo "No changes detected"
    fi

    echo ">>> Cleaning up ..."
    rm /tmp/${S3_FILE}.json

    echo ">>> Waiting for $BACKUP_INTERVAL seconds ..."
    sleep ${BACKUP_INTERVAL}
done
