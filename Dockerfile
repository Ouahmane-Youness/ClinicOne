FROM tomcat:10.1-jdk17

# Install unzip
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR
COPY target/clinic-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Unpack the WAR
RUN cd /usr/local/tomcat/webapps && \
    unzip -q ROOT.war -d ROOT && \
    rm ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
