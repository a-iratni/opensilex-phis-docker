FROM tomcat:9.0

ARG PR_REPO__CLONE_URL
ARG PR_SHA
ARG PR_REF

RUN echo "----------------->>>>>>>>>>>>>>>>>>>>>>>---PR_REPO__CLONE_URL-->>>>>>>>>>>>>>>>>>>>>>>>>>>"

RUN echo "PR_REPO__CLONE_URL :"$PR_REPO__CLONE_URL
RUN echo "PR_SHA : " $PR_SHA
RUN echo "PR_REF : " $PR_REF

RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget default-jdk maven ssh

ARG USER_UID=1001

RUN echo USER_UID $USER_UID; \
    useradd --uid $USER_UID --create-home --shell /bin/bash phis && \
    echo `echo "phis\nphis\n" | passwd phis` && \
    adduser phis sudo && \
    ln -snf /bin/bash /bin/sh

RUN echo "org.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true" >> /usr/local/tomcat/conf/catalina.properties

USER phis
WORKDIR /home/phis

RUN mkdir logs
RUN mkdir documents

ARG VERSION=continuous_integration

# Build app
RUN git clone -b $PR_REF $PR_REPO__CLONE_URL
RUN cd phis-ws
RUN git checkout $PR_SHA
# Add this line for caching dependencies
#RUN cd /home/phis/phis-ws/phis2-ws && mvn clean install -Pprod

ARG RDF4J_HOST=localhost
ARG RDF4J_PORT=8080

ARG MONGO_HOST=localhost
ARG MONGO_PORT=27017

ARG PG_HOST=localhost
ARG PG_PORT=5432

ARG PHIS_WEBAPP_HOST=localhost
ARG PHIS_WEBAPP_PORT=80

ARG PHIS_WS_HOST=localhost
ARG PHIS_WS_PORT=8080

ARG BASE_URI=http://example.com/

ARG PLATFORM=opensilex
ARG PLATFORM_CODE=OS



# Build the configured application
ADD config.properties /home/phis/phis-ws/phis2-ws/src/main/profiles/prod
#RUN cd /home/phis/phis-ws/phis2-ws && mvn clean install -Pprod

USER root
#RUN cp /home/phis/phis-ws/phis2-ws/target/opensilex-v0.1.war /usr/local/tomcat/webapps/$PLATFORM.war

ENTRYPOINT /etc/init.d/ssh start  && /usr/local/tomcat/bin/catalina.sh run
