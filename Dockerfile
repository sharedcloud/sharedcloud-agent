FROM python:3.7.0-alpine3.8

ADD requirements.txt /requirements.txt

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
            gcc \
            make \
            libc-dev \
            musl-dev \
            linux-headers \
            pcre-dev \
    && pyvenv /venv \
    && /venv/bin/pip install -U pip \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install --no-cache-dir -r /requirements.txt" \
    && runDeps="$( \
            scanelf --needed --nobanner --recursive /venv \
                    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                    | sort -u \
                    | xargs -r apk info --installed \
                    | sort -u \
    )" \
    && apk add --virtual .python-rundeps $runDeps \
    && apk del .build-deps

RUN apk add --update bash

# Install code
RUN mkdir /code/
WORKDIR /code/
ADD . /code/

EXPOSE 4005

ENV UWSGI_VIRTUALENV=/venv UWSGI_WSGI_FILE=/code/wsgi.py UWSGI_HTTP=:4005 UWSGI_MASTER=1 UWSGI_WORKERS=4 UWSGI_UID=1000 UWSGI_GID=2000 UWSGI_THREADS=1 UWSGI_LAZY_APPS=1 UWSGI_WSGI_ENV_BEHAVIOR=holy

CMD /venv/bin/uwsgi --http-auto-chunked --http-keepalive
