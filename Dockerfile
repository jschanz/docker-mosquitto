FROM debian:stretch
MAINTAINER Jens Schanz

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y curl gnupg apt-transport-https

# add Mosquitto repository key
RUN curl http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -

# add repository to sources.list.d
RUN curl http://repo.mosquitto.org/debian/mosquitto-stretch.list > /etc/apt/sources.list.d/mosquitto-stretch.list
RUN apt-get update -y

# finally install 
RUN apt-get install -y mosquitto mosquitto-clients

# add a user
RUN adduser --system --disabled-password --disabled-login mosquitto
RUN mkdir -p /etc/mosquitto && chown mosquitto -R /etc/mosquitto
RUN mkdir -p /etc/mosquitto/ssl && chown mosquitto -R /etc/mosquitto/ssl
RUN mkdir -p /var/log/mosquitto && chown mosquitto -R /var/log/mosquitto
RUN mkdir -p /var/lib/mosquitto && chown mosquitto -R /var/lib/mosquitto

USER mosquitto

# expose volumes for config, logs and database
VOLUME /etc/mosquitto
VOLUME /var/log/mosquitto
VOLUME /var/lib/mosquitto

# expose ports (normal unencrypted, TLS encrypted, WS encrypted)
EXPOSE 1883 8883 8080

# start mosquitto as main process
CMD ["/usr/sbin/mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]
