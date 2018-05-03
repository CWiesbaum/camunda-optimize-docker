FROM openjdk:8-jre-slim
EXPOSE 8090 8091
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*
ADD ./camunda-optimize.zip /camunda-optimize.zip
RUN unzip -d /opt/camunda-optimize camunda-optimize.zip 
ADD ./start-optimize.sh /opt/camunda-optimize/start-optimize.sh
RUN groupadd camunda && useradd -ms /bin/bash -G camunda optimize && chown -R root:camunda /opt/camunda-optimize && chmod -R g+w /opt/camunda-optimize
USER optimize:camunda
ENV ARGS=""
ENTRYPOINT [ "sh", "-c", "/opt/camunda-optimize/start-optimize.sh $ARGS" ]
