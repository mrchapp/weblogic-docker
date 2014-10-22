#
# Dockerfile for WebLogic 10.3.6 ZIP Distro
# 
# Download wls1036_dev.zip from www.oracle.com/technetwork/middleware/weblogic/downloads/index.html
# and put it in the same dir as this Dockerfile
#
# Based on:
# https://github.com/weblogic-community/weblogic-docker
#

# Pull base image
FROM dockerfile/java:oracle-java6

MAINTAINER Daniel Díaz <ddiaz@dextratech.com>

RUN mkdir /u01
RUN chmod a+x /u01
RUN chmod a+r /u01

RUN useradd -b /u01 -m -s /bin/bash oracle
RUN echo oracle:welcome1 | chpasswd

ADD container-scripts/create-wls-domain.py /u01/create-wls-domain.py
ADD wls1036_dev.zip /u01/wls1036_dev.zip
ADD container-scripts/add-machine.py /u01/oracle/add-machine.py
ADD container-scripts/createMachine.sh /u01/oracle/createMachine.sh
RUN chown oracle:oracle -R /u01

WORKDIR /u01

USER oracle

ENV JAVA_HOME /usr/lib/jvm/java-6-oracle
ENV MW_HOME /u01/oracle/wls1036
RUN unzip /u01/wls1036_dev.zip -d /u01/oracle/wls1036
WORKDIR /u01/oracle/wls1036
RUN bash configure.sh
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom
RUN /u01/oracle/wls1036/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /u01/create-wls-domain.py
RUN mkdir -p /u01/oracle/wls1036/user_projects/domains/base_domain/servers/AdminServer/security
RUN echo "username=weblogic" > /u01/oracle/wls1036/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
RUN echo "password=welcome1" >> /u01/oracle/wls1036/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
RUN rm /u01/create-wls-domain.py /u01/wls1036_dev.zip

# Increase memory
RUN perl -i -p -e 's:WLS_MEM_ARGS_32BIT=".*":WLS_MEM_ARGS_32BIT="-Xms512m -Xmx1024m":g' /u01/oracle/wls1036/user_projects/domains/base_domain/bin/setDomainEnv.sh
RUN perl -i -p -e 's:MEM_MAX_PERM_SIZE_32BIT=".*":MEM_MAX_PERM_SIZE_32BIT="-XX\:MaxPermSize=256m":g' /u01/oracle/wls1036/user_projects/domains/base_domain/bin/setDomainEnv.sh

RUN echo ". /u01/oracle/wls1036/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/wls1036/user_projects/domains/base_domain/bin" >> /u01/oracle/.bashrc

# Expose Node Manager default port, and also default http/https ports for admin console
EXPOSE 5556 7001 7002

USER root

RUN echo ". /u01/oracle/wls1036/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /root/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/wls1036/user_projects/domains/base_domain/bin" >> /root/.bashrc

WORKDIR /u01/oracle/home

# Define default command to start bash. 
# Modify if you want to start a nodemanager or the admin server by default
# CMD ["/bin/bash"]
# CMD ["/u01/oracle/wls1036/user_projects/domains/base_domain/bin/startNodeManager.sh"]
CMD ["/u01/oracle/wls1036/user_projects/domains/base_domain/bin/startWebLogic.sh"]

