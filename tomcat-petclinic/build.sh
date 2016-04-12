#!/bin/sh

TOMCAT_VERSION=8.0.32
TOMCAT_DIST=apache-tomcat-${TOMCAT_VERSION}

# Clean up any artifacts left from previous builds
rm -rf tomcat-petclinic-dist.zip
rm -rf ${TOMCAT_DIST}

if [ -n "$HTTP_PROXY" ]; then
  PROXY_ARG="--proxy ${HTTP_PROXY}"
fi

# Download Tomcat distribution if necessary
if [ ! -r ${TOMCAT_DIST}.tar.gz ]; then
  # Find the closest mirror
  MIRROR=`curl ${PROXY_ARG} 'https://www.apache.org/dyn/closer.cgi' |
      grep -o '<strong>[^<]*</strong>' |
      sed 's/<[^>]*>//g' |
      head -1`
  curl -X GET \
     ${PROXY_ARG} \
     -o ${TOMCAT_DIST}.tar.gz \
     ${MIRROR}/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/${TOMCAT_DIST}.tar.gz
fi

# Unzip Tomcat distribution
tar -xf ${TOMCAT_DIST}.tar.gz

# build Petclinic

# Download Spring Petclinic if necessary
if [ ! -r spring-petclinic ]; then
  git clone https://github.com/spring-projects/spring-petclinic.git
fi

# Build Petclinic
cd spring-petclinic
mvn clean package
cd ..

# Move petclinic.war to Tomcat webapps folder
mv spring-petclinic/target/petclinic.war ${TOMCAT_DIST}/webapps/.

# Create application archive with Tomcat (with petclinic war) and manifest.json
zip -r tomcat-petclinic-dist.zip manifest.json ${TOMCAT_DIST}

# Remove the expanded Tomcat distribution
rm -rf ${TOMCAT_DIST}
