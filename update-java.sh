#!/usr/bin/env bash

# get to the cloud9 base environment directory
cd ~/environment

# clean up
rm ~/environment/apache-maven-3.5.4-bin.tar.gz
sudo rm -Rvf /usr/local/amazon-corretto-*
sudo rm /usr/bin/jar

sudo rm -rf /usr/local/amazon-coretto-jdk11
sudo rm -rf /usr/local/apache-maven/

# get amazon coretto JDK
wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
tar zxpvf amazon-corretto-11-x64-linux-jdk.tar.gz
sudo cp -Rvf amazon-corretto-11.0.6.10.1-linux-x64 /usr/local
sudo ln -s /usr/local/amazon-corretto-11.0.6.10.1-linux-x64/ /usr/local/amazon-corretto-jdk11
rm amazon-corretto-11-x64-linux-jdk.tar.gz
rm -Rvf amazon-corretto-11.0.6.10.1-linux-x64/

wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar xvf apache-maven-3.5.4-bin.tar.gz
sudo mv apache-maven-3.5.4  /usr/local/apache-maven

cat <<EOT >> ~/.bashrc
export M2_HOME=/usr/local/apache-maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
export JAVA_HOME=/usr/local/amazon-coretto-jdk11
EOT

sudo alternatives --install /usr/bin/java java /usr/local/amazon-corretto-jdk11/bin/java 2
sudo alternatives --set java /usr/local/amazon-corretto-jdk11/bin/java

sudo alternatives --install /usr/bin/javac javac /usr/local/amazon-corretto-jdk11/bin/javac 2
sudo alternatives --set javac /usr/local/amazon-corretto-jdk11/bin/javac

# for some reason alternatives does not work to install jar, so we just manually create a symlink instead
sudo ln -s /usr/local/amazon-corretto-jdk11/bin/jar /usr/bin/jar
#sudo alternatives --install /usr/bin/jar jar /usr/local/amazon-corretto-jdk11/bin/jar 2
#sudo alternatives --set jar /usr/local/amazon-corretto-jdk11/bin/jar

# remove the old openjdk from cloud9
sudo yum remove -y java-1.7.0

# set the path to include maven
export PATH=$PATH:/usr/local/apache-maven/bin

export JAVA_HOME=/usr/local/amazon-corretto-jdk11/

rm ~/environment/apache-maven-3.5.4-bin.tar.gz