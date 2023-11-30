# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app
RUN npm cache add express

COPY . .
RUN npm install express
RUN npm install body-parser
RUN npm install ./fn

ARG HTTP_PORT
ENV PORT $HTTP_PORT

EXPOSE $PORT

RUN echo $PORT
RUN ls
RUN cat ports.txt
CMD [ "node", "functionhandler.js" ]
RUN cat ports.txt