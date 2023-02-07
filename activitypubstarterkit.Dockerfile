# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

ARG HTTP_PROXY
ENV HTTP_PROXY=$HTTP_PROXY

ARG HTTPS_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

RUN npm install \
  && mkdir node_modules/@types/simple-proxy-agent/ \
  && echo "declare module 'simple-proxy-agent';" | tee node_modules/@types/simple-proxy-agent/index.d.ts

# Bundle app source
COPY . .

RUN npm run build

ENTRYPOINT /usr/src/app/entrypoint.sh
CMD [ "npm", "run", "start" ]

# The path to the database schema
ARG SCHEMA_PATH="db/schema.sql"
ENV SCHEMA_PATH=$SCHEMA_PATH

# The path to the database file
ARG DATABASE_PATH="db/database.sqlite3"
ENV DATABASE_PATH=$DATABASE_PATH

ARG PORT=8000
ENV PORT=$PORT

ARG ACCOUNT=push
ENV ACCOUNT=$ACCOUNT

ARG ADMIN_USERNAME=admin
ENV ADMIN_USERNAME=$ADMIN_USERNAME

ARG FDQN
ENV FDQN=$FDQN
