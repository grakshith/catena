FROM swift:4.1
ARG CATENA_CONFIGURATION=debug
ENV CATENA_CONFIGURATION $CATENA_CONFIGURATION

RUN adduser --system --group catena
RUN apt-get update && apt-get install -y libcurl4-openssl-dev npm 
RUN ln -s /usr/bin/nodejs /usr/bin/node
COPY . /root/
RUN cd /root/Resources && npm install && npm install --global gulp-cli && gulp
RUN cd /root && rm -rf .build
RUN cd /root && swift build -c $CATENA_CONFIGURATION
RUN chmod o+rwx /root/.build/$CATENA_CONFIGURATION/*
RUN mv /root/.build/$CATENA_CONFIGURATION/Catena /usr/bin/catena


EXPOSE 8338
EXPOSE 8339
ENTRYPOINT ["/usr/bin/catena"]
#HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:8338/api || exit 1
