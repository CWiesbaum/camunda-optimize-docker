FROM openjdk:8-jre-slim
EXPOSE 8090
EXPOSE 8091
ADD ./camunda-optimize.zip /camunda-optimize.zip
RUN unzip -d /opt/camunda-optimize camunda-optimize.zip
ENV ARGS=""
ENTRYPOINT [ "sh", "-c", "/opt/camunda-optimize/start-optimize.sh $ARGS" ]
