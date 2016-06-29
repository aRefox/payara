# Pull source ubuntu base image. 
FROM ubuntu:14.04.4 

ENV PAYARA_PKG http://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=fish.payara.extras&a=payara-micro&v=LATEST 
ENV PKG_FILE_NAME payara-micro.jar 

#Install packages on ubuntu base image 
RUN apt-get update && \ 
apt-get install -y wget && \ 
apt-get install -y software-properties-common python-software-properties 

ADD /bin/start.sh /start.sh
RUN mkdir -p /opt/config
RUN mkdir -p /opt/bin
RUN mkdir -p /opt/lib
ADD config/hazelcast.xml /opt/config/hazelcast.xml
ADD bin/clusterManager.sh /opt/bin/clusterManager.sh
ADD bin/memoryConfig.sh /opt/bin/memoryConfig.sh
ADD lib/jelastic-gc-agent.jar /opt/lib/jelastic-gc-agent.jar
RUN chmod +x /start.sh
RUN chmod +x /opt/bin/clusterManager.sh
RUN chmod +x /opt/bin/memoryConfig.sh

# Install Java 8 
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \ 
add-apt-repository -y ppa:webupd8team/java && \ 
apt-get update && \ 
apt-get install -y oracle-java8-installer && \ 
rm -rf /var/lib/apt/lists/* && \ 
rm -rf /var/cache/oracle-jdk8-installer 

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle 

# add payara user, download payara micro build. Download sample war app and package on image. 

RUN useradd -b /opt -m -s /bin/bash payara && echo payara:payara | chpasswd
RUN cd /opt && wget $PAYARA_PKG -O $PKG_FILE_NAME
RUN mkdir -p /opt/payara-micro-wars
RUN chown -R payara:payara /opt
# Set up payara user and the home directory for the user USER payara WORKDIR /opt
#ENTRYPOINT ["java", "-jar", "payara-micro.jar", "--deploymentDir", "/opt/payara-micro-wars"]
CMD ["/start.sh"]
