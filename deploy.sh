#!/bin/sh

export CODE_PATH /opt/code

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
if [ ! -d $CODE_PATH ];
then
git clone $1 $CODE_PATH
else
cd $CODE_PATH && git pull origin master
fi

# Compile & Deploy code
cd $CODE_PATH && mvn clean package -Dmaven.test.skip=true
cp $CODE_PATH/target/*.war $CATALINA_HOME/webapps
mv $CATALINA_HOME/webapps/*.war $CATALINA_HOME/webapps/ROOT.war

# Clean & Start tomcat
rm -rf $CATALINA_HOME/temp/* && rm -rf $CATALINA_HOME/work/* && rm -rf $CATALINA_HOME/webapps/*
$CATALINA_HOME/bin/startup.sh && tail -f $CATALINA_HOME/logs/catalina.out
