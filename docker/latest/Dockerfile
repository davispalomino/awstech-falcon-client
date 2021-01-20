ARG IMAGE
FROM $IMAGE
COPY /app .
RUN pip install -r requirements.txt
COPY docker/latest/init.sh .
ENTRYPOINT bash ./init.sh