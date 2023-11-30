FROM node:alpine

ARG VERSION_ARG="0.0"
ENV NODE_ENV=production

# INSTALL ADDITIONAL IMAGE DEPENDENCIES AND COPY APPLICATION TO IMAGE
RUN apk update && apk add --no-cache tzdata
RUN mkdir -p /portainer-backup/src
COPY package.json /portainer-backup
COPY src/*.js /portainer-backup/src
RUN sed -i 's/0.0.0-development/$VERSION_ARG/' /portainer-backup/package.json
WORKDIR /portainer-backup
VOLUME "/backup"
RUN npm install --omit=dev

# DEFAULT ENV VARIABLE VALUES
ENV TZ="America/New_York" 
ENV PORTAINER_BACKUP_URL="http://portainer:9000"
ENV PORTAINER_BACKUP_TOKEN=""
ENV PORTAINER_BACKUP_DIRECTORY="/backup"
ENV PORTAINER_BACKUP_FILENAME="/portainer-backup.tar.gz"
ENV PORTAINER_BACKUP_OVERWRITE=false
ENV PORTAINER_BACKUP_CONCISE=false
ENV PORTAINER_BACKUP_DEBUG=false
ENV PORTAINER_BACKUP_DRYRUN=false
ENV PORTAINER_BACKUP_STACKS=false

# NODEJS RUNNING THIS APPLICATION IS THE ENTRYPOINT
ENTRYPOINT [ "/usr/local/bin/node", "/portainer-backup/src/index.js" ]

# DEFAULT COMMAND (if none provided)
CMD ["schedule"]
