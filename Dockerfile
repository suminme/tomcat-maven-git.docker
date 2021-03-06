# Container
FROM ubuntu:16.04

# Author
MAINTAINER SUMIN "dev@sumin.me"

# ENV
ENV ENV_PATH /opt/env
RUN mkdir $ENV_PATH
ENV PATH $PATH:$ENV_PATH/bin

# Update system
RUN apt-get update
RUN apt-get -y install curl and git

# Install jdk
ENV JAVA_HOME $ENV_PATH/jdk
ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
RUN cd /tmp && mkdir jdk && cd jdk &&  curl -L $JDK_URL -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz
RUN mv /tmp/jdk/* $JAVA_HOME

# Install tomcat
ENV CATALINA_HOME $ENV_PATH/tomcat
ENV TOMCAT_URL http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz
RUN cd /tmp && mkdir tomcat && cd tomcat &&  curl -L $TOMCAT_URL | tar -xz
RUN mv /tmp/tomcat/* $CATALINA_HOME
ADD /tomcat/server8.xml $CATALINA_HOME/conf/server.xml

# Install maven
ENV MAVEN_HOME $ENV_PATH/maven
ENV MAVEN_URL http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN cd /tmp && mkdir maven && cd maven &&  curl -L $MAVEN_URL | tar -xz
RUN mv /tmp/maven/* $MAVEN_HOME

# Deploy.sh
ADD deploy.sh /deploy.sh
RUN chmod 777 /*.sh

# ENTRYPOINT
ENTRYPOINT ["/deploy.sh"]
