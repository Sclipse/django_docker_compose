# Use an Python alpine runtime as a parent image
FROM python:3.9
LABEL maintainer="Sclipse"

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Adding backend directory to make absolute filepaths consistent across services
WORKDIR /app
# Make port 8000 available for the app
EXPOSE 8000

COPY ./requirements.txt /requirements.txt
COPY ./app /app
COPY ./scripts /scripts


RUN apt-get update
RUN apt-get install -y gettext

# Install Python dependencies
RUN python3 -m venv /py && \
    /py/bin/pip install --upgrade pip -r /requirements.txt && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

#RUN python -m venv /py && \
#    /py/bin/pip install --upgrade pip && \
#    apk add --update --no-cache postgresql-client && \
#    apk add --update --no-cache --virtual .tmp-build-deps \
#        build-base postgresql-dev musl-dev linux-headers && \
#    /py/bin/pip install -r /requirements.txt && \
#    apk del .tmp-build-deps && \
#    adduser --disabled-password --no-create-home app &&
#    mkdir -p /vol/web/static && \
#    mkdir -p /vol/web/media && \
#    chown -R app:app /vol && \
#    chmod -R 755 /vol

ENV PATH="/scripts:/py/bin:$PATH"

USER app

CMD ["run.sh"]