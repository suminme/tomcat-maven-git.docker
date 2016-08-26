#!/bin/sh

export BUILD_PATH="/opt/deploy/build"
export SOURCE_PATH="/opt/deploy/source"

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
if [ ! -d $SOURCE_PATH/.git ];
then
cd $SOURCE_PATH
git clone --no-checkout $1 tmp/git
mv tmp/git/.git .
rmdir tmp/git
git reset --hard HEAD
else
cd $SOURCE_PATH && git pull origin master
fi

# Clean tomcat
rm -rf $CATALINA_HOME/temp/* && rm -rf $CATALINA_HOME/work/* && rm -rf $CATALINA_HOME/webapps/* && rm -rf $BUILD_PATH/*

# Compile & Deploy code
cd $SOURCE_PATH && $MAVEN_HOME/bin/mvn clean package -Dmaven.test.skip=true
cp $SOURCE_PATH/target/*.war $BUILD_PATH/
mv $BUILD_PATH/*.war $BUILD_PATH/ROOT.war

# Start tomcat
$CATALINA_HOME/bin/startup.sh && tail -f $CATALINA_HOME/logs/catalina.out
