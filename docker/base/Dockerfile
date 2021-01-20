FROM alpine:3.12.0

ENV TZ America/Lima

RUN apk update && apk add --no-cache tzdata py3-pip py3-requests python3-dev curl
RUN pip3 install -U pip
RUN pip install setuptools gunicorn

ENV XRAY_VERSION=3.x

RUN apk --no-cache add bash ca-certificates libc6-compat tzdata \
    # Install packages needed for this image to build (cleaned at the end)
    && apk --no-cache add --virtual build-dependencies curl unzip \
    # Install AWS X-Ray daemon
    && curl https://s3.dualstack.us-east-1.amazonaws.com/aws-xray-assets.us-east-1/xray-daemon/aws-xray-daemon-linux-${XRAY_VERSION}.zip -o install.zip \ 
    && unzip install.zip -d xray_install \ 
    && mv xray_install/xray /usr/bin/xray \ 
    && rm -rf install.zip xray_install \     
    # Clean build dependancies
    && apk del --purge -r build-dependencies 


WORKDIR /app