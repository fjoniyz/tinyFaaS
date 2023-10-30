#https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:20-alpine

ARG HTTP_PORT

ENV PORT=$HTTP_PORT

EXPOSE $PORT

# Create app directory
WORKDIR /usr/src/app
RUN npm cache add express

COPY . .
RUN npm install express
RUN npm install ./fn

CMD [ "node", "functionhandler.js" ]
