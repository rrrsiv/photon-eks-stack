# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
FROM alpine:3.14

ENV JMETER_HOME /jmeter
ENV PATH $JMETER_HOME/bin:$PATH

RUN apk update \
     && apk upgrade \
     && apk add busybox-extras \
     && apk add --update openjdk8 wget curl unzip bash \
     && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz \
     && tar -xvzf apache-jmeter-5.3.tgz  \
     && rm apache-jmeter-5.3.tgz \
     && mv apache-jmeter-5.3 /jmeter 

COPY user.properties /jmeter/bin/user.properties
COPY rmi_keystore.jks /jmeter/bin/rmi_keystore.jks
COPY jmeter.backendlistener.elasticsearch-2.7.0.jar /jmeter/lib/ext/jmeter.backendlistener.elasticsearch-2.7.0.jar
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

# Plugin Management
COPY Plugins_Management/jmeter-dependencies.txt /jmeter/jmeter-dependencies.txt
COPY Plugins_Management/InstallPlugins.sh /jmeter/InstallPlugins.sh
RUN /jmeter/InstallPlugins.sh;  
EXPOSE 6000 1099 50000
ENTRYPOINT ["/docker-entrypoint.sh"]
