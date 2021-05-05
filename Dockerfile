FROM quay.io/ibmgaragecloud/maven:3.6.3-jdk-11-slim AS build-stage
COPY . /project
WORKDIR /project/CustomerOrderServicesProject
RUN mvn clean package

FROM image-registry-openshift-image-registry.appmod-keybank-73aebe06726e634c608c4167edcc2aeb-0000.us-east.containers.appdomain.cloud/bk-base-image-bitbucket/kb-base-image-liberty:0.0.1

ARG SSL=false
ARG MP_MONITORING=false
ARG HTTP_ENDPOINT=false

COPY --chown=1001:0 ./liberty/server.xml /config/server.xml
COPY --chown=1001:0 ./liberty/jvm.options /config/jvm.options
COPY --chown=1001:0 --from=build-stage /project/CustomerOrderServicesApp/target/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear /config/apps/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear
COPY --chown=1001:0 ./resources/ /opt/ibm/wlp/usr/shared/resources/

RUN configure.sh

