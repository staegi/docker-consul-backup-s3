FROM debian:jessie
MAINTAINER Thomas Stägemann <thomas@staegemann.info>

# Install required packages
RUN apt-get update && apt-get install -y python-pip

# Install AWS command line tools
RUN pip install awscli

# Install Consul command line tool
RUN pip install consulate

# Install sync script
COPY sync.sh /usr/local/bin/sync
RUN chmod +x  /usr/local/bin/sync

# Set up environment
ENV S3_FILE consul-kv
ENV S3_PATH consul-backup
ENV CONSUL_HOST consul.service.consul
ENV CONSUL_PORT 8500
ENV BACKUP_INTERVAL 60

CMD ["sync"]
