FROM flask_service:python-3.10-slim-bullseye

COPY --from=drouhana/envoy-oqs:envoy /usr/local/bin/envoy /usr/local/bin/envoy

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -qr /tmp/requirements.txt

COPY ./service.py /code/service.py

COPY ./start_service.sh /usr/local/bin/start_service.sh
RUN chmod u+x /usr/local/bin/start_service.sh
ENTRYPOINT ["/usr/local/bin/start_service.sh"]
