#!/bin/sh
export DEPLOY_PATH="/opt/deploy"

# Check build dir
if [ ! -d $DEPLOY_PATH/build ];
then
cd $DEPLOY_PATH && mkdir build
fi

# Check Git Repository
if [ ! -n "$1" ];
then
echo "Please assign git repository url"
return;
fi;

# Check JAVA_OPTS
if [ ! -n "$2" ];
then
export JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=GMT+08 -Xms256m -Xmx1024m"
else
export JAVA_OPTS="$2"
fi
echo "JAVA_OPTS=\"$JAVA_OPTS\"" >> $CATALINA_HOME/bin/setenv.sh

# Git clone or update
if [ ! -d $DEPLOY_PATH/source/.git ];
then
cd $DEPLOY_PATH/source
git clone --no-checkout $1 tmp/git
mv tmp/git/.git .
rmdir tmp/git
git reset --hard HEAD
else
cd $DEPLOY_PATH/source && git pull origin master
fi

# Clean tomcat
rm -rf $CATALINA_HOME/temp/* && rm -rf $CATALINA_HOME/work/* && rm -rf $CATALINA_HOME/webapps/* && rm -rf $DEPLOY_PATH/build/*

# Compile & Deploy code
cd $DEPLOY_PATH/source && $MAVEN_HOME/bin/mvn clean package -Dmaven.test.skip=true
cp $DEPLOY_PATH/source/target/*.war $DEPLOY_PATH/build/
mv $DEPLOY_PATH/build/*.war $DEPLOY_PATH/build/ROOT.war

# Start tomcat
$CATALINA_HOME/bin/startup.sh && tail -f $CATALINA_HOME/logs/catalina.out
