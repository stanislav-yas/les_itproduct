FROM dart:2.18.2-sdk

WORKDIR /app

ADD . /app/
RUN dart pub get
RUN dart pub global activate conduit 3.2.9
RUN dart run conduit db generate
RUN dart run conduit db validate
# RUN dart pub run conduit db upgrade
EXPOSE 6200

ENTRYPOINT [ "dart","run","conduit:conduit","serve","--port","6200" ]
