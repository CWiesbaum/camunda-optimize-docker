FROM openjdk:8-jre-slim
EXPOSE 8090
EXPOSE 8091
ADD ./camunda-optimize.zip /camunda-optimize.zip
RUN unzip -d /opt/camunda-optimize camunda-optimize.zip 
RUN groupadd camunda && useradd -ms /bin/bash -G camunda optimize && chown -R root:camunda /opt/camunda-optimize && chmod -R g+w /opt/camunda-optimize
USER optimize:camunda
ENV ARGS=""
ENTRYPOINT [ "sh", "-c", "/opt/camunda-optimize/start-optimize.sh $ARGS" ]
