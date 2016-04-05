#!/bin/sh

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
export JAVA_OPTS=$2
fi
echo "JAVA_OPTS=\"$JAVA_OPTS\"" >> $CATALINA_HOME/bin/setenv.sh
echo "Used JAVA_OPTS"+$JAVA_OPTS

# Start tomcat
$CATALINA_HOME/startup.sh && tail -f $CATALINA_HOME/logs/catalina.out
