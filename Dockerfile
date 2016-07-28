FROM docker.clarin.eu/tomcat8:1.1.5

RUN apt-get update -y --force-yes \
 && apt-get install -y --force-yes sudo supervisor nginx git build-essential unzip

RUN apt-get update -y --force-yes \
 && apt-get install -y --force-yes openjdk-8-jdk-headless maven postgresql-9.4 tomcat8-admin

RUN useradd tomcat \
 && useradd dspace

#Configure postgresql
COPY postgres/postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
COPY postgres/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf

#Configure tomcat
COPY tomcat/context.xml /etc/tomcat8/context.xml
COPY tomcat/server.xml /etc/tomcat8/server.xml
COPY tomcat/tomcat-users.xml /etc/tomcat8/tomcat-users.xml

#Deploy and configure lindat dspace
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV DSPACE_INSTANCE_NAME repository
ENV DSPACE_BASE_DIRECTORY /opt/repository
ENV DSPACE_SOURCE_DIRECTORY /opt/repository/sources/dspace
ENV DSPACE_WORKSPACE /opt/repository/workspace
#ENV DSPACE_INSTALLATION_DIRECTORY /opt/repository/installations
ENV DSPACE_INSTALLATION_DIRECTORY /opt/lindat-dspace/installation
ENV DB_USER dspace
ENV DB_PASSWORD dspace1234

RUN mkdir -p /opt/repository/sources/dspace \
 && mkdir -p /opt/repository/workspace \
 && mkdir -p /opt/repository/workspace \
 && git clone https://github.com/ufal/lindat-dspace.git -b lindat $DSPACE_SOURCE_DIRECTORY

RUN cd $DSPACE_SOURCE_DIRECTORY/utilities/project_helpers \
 && ./setup.sh $DSPACE_WORKSPACE
COPY lindat-dspace/variable.makefile $DSPACE_WORKSPACE/config/variable.makefile
COPY lindat-dspace/local.properties $DSPACE_WORKSPACE/sources/local.properties

RUN /etc/init.d/postgresql start \
 && sudo -u postgres psql --command "CREATE USER dspace WITH SUPERUSER PASSWORD 'dspace1234';" \
 && cd $DSPACE_WORKSPACE/scripts \
 && sudo make create_databases

RUN cd $DSPACE_WORKSPACE/scripts \
 && sudo make install_libs

RUN /etc/init.d/postgresql start \
 && cd $DSPACE_WORKSPACE/scripts \
 && sudo make new_deploy

#Fix postgresql init script
#RUN ln -s /etc/init.d/postgresql /etc/init.d/postgresql-9.4

#Configure nginx
RUN mkdir -p /var/www/html
COPY nginx/robots.txt /var/www/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

#Configure supervisord
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisord

#Addd and set entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod u+x /usr/bin/entrypoint.sh
EXPOSE 8009 8080
CMD ["/usr/bin/entrypoint.sh"]