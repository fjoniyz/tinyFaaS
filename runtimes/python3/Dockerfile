FROM python:3.11-alpine

ARG HTTP_PORT

ENV PORT=$HTTP_PORT

EXPOSE $PORT

# Create app directory
WORKDIR /usr/src/app

COPY . .
RUN mv fn/* .
RUN python -m pip install -r requirements.txt --user

CMD [ "python3", "functionhandler.py" ]
