# Pull source ubuntu base image. 
FROM jelastic/payara-micro-cluster 

ADD helloworld.war /opt/payara-micro-wars
CMD ["/start.sh"]
