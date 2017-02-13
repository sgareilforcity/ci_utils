FROM python:3.5
WORKDIR /opt/forcity
ENV DOCKERIZE_VERSION v0.2.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY module_to_test module_to_test
ENV PYTHONPATH /opt/forcity/module_to_test:$PYTHONPATH