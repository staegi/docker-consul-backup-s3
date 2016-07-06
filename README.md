# docker-consul-backup-s3

## Environment variables

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BUCKET
    S3_FILE (default: consul-kv)
    S3_PATH (default: consul-backup)
    CONSUL_HOST (default: consul.service.consul)
    CONSUL_PORT (default: 8500)
    BACKUP_INTERVAL (default: 60)

## Build & run

    docker build -t consul-backup .
    docker run -d -e S3_BUCKET=mybucketname -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOPQRS -e AWS_SECRET_ACCESS_KEY=A1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6Q7r8S9t0 consul-backup

