# Container
FROM ubuntu:14.04

# Author
MAINTAINER SUMIN "dev@sumin.me"

# ENV
ENV ENV_PATH /opt/env
ENV PATH $PATH:$ENV_PATH/bin

ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz
ENV TOMCAT_URL http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.0.M4/bin/apache-tomcat-9.0.0.M4.tar.gz

# Update source  
RUN apt-get update
# Install environment
RUN apt-get -y install curl and git

# Install JDK
RUN cd /tmp && mkdir jdk && cd jdk &&  curl -L $JDK_URL -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz
RUN mv /tmp/jdk/* $ENV_PATH/jdk
ENV JAVA_HOME $ENV_PATH/jdk

# Install tomcat
RUN cd /tmp && mkdir tomcat && cd tomcat &&  curl -L $TOMCAT_URL | tar -xz
RUN mv /tmp/tomcat/* $ENV_PATH/tomcat
ENV CATALINA_HOME $ENV_PATH/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# Expose ports.
EXPOSE 8080

# ENTRYPOINT
