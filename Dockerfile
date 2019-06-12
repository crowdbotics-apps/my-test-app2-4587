
FROM alpine:latest

# Install system dependencies
RUN apk add --no-cache --update \
  libjpeg-turbo-dev \
  zlib-dev \
  bash \
  gcc \
  build-base \
  musl-dev \
  postgresql-dev \
  python3 \
  python3-dev \
  py3-pip \
  curl
RUN pip3 install --no-cache-dir -q pipenv

# Add our code
ADD ./ /opt/webapp/
WORKDIR /opt/webapp

# Install dependencies
RUN pipenv install --deploy --system

RUN python3 manage.py collectstatic --no-input

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the web server on port $PORT
CMD waitress-serve --port=$PORT my_test_app2_4587.wsgi:application
