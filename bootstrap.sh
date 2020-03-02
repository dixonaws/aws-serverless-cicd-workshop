#!/bin/bash

set -euxo pipefail

ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
CURRENT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

export INFOPATH="/home/linuxbrew/.linuxbrew/share/info"

function _logger() {
    echo -e "$(date) ${YELLOW}[*] $@ ${NC}"
}

function upgrade_sam_cli() {
    _logger "[+] Backing up current SAM CLI"
    cp $(which sam) ~/.sam_old_backup

    _logger "[+] Installing latest SAM CLI"
    # pipx install aws-sam-cli
    # cfn-lint currently clashing with SAM CLI deps
    ## installing SAM CLI via brew instead
    brew tap aws/tap
    brew install aws-sam-cli

    _logger "[+] Updating Cloud9 SAM binary"
    # Allows for local invoke within IDE (except debug run)
    ln -sf $(which sam) ~/.c9/bin/sam
}

function upgrade_existing_packages() {
    _logger "[+] Upgrading system packages"
    sudo yum update -y

    _logger "[+] Upgrading Python pip and setuptools"
    python3 -m pip install --upgrade pip setuptools --user

    _logger "[+] Installing latest AWS CLI"
    # _logger "[+] Installing pipx, and latest AWS CLI"
    # python3 -m pip install --user pipx
    # pipx install awscli
    python3 -m pip install --upgrade --user awscli
}

function install_utility_tools() {
    _logger "[+] Installing jq"
    sudo yum install -y jq
}

function install_linuxbrew() {
    _logger "[+] Creating touch symlink"
    sudo ln -sf /bin/touch /usr/bin/touch
    _logger "[+] Installing homebrew..."
    echo | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    _logger "[+] Adding homebrew in PATH"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
}

function install_corretto_jdk11() {
    _logger "[+] Removing default JDK..."
    sudo yum remove java-1.7.0-openjdk -y
    _logger "[+] Installing JDK11 (Amazon Corretto)..."
    wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
    sudo tar zxf amazon-corretto-11-x64-linux-jdk.tar.gz -C /usr/local
    sudo ln -s /usr/local/amazon-corretto-11.0.6.10.1-linux-x64/ /usr/local/amazon-corretto-jdk11
    rm amazon-corretto-11-x64-linux-jdk.tar.gz
    echo "export JAVA_HOME=/usr/local/amazon-corretto-jdk11" >> ~/.profile
    sudo alternatives --install /usr/bin/java java /usr/local/amazon-corretto-jdk11/bin/java 2
    sudo alternatives --set java /usr/local/amazon-corretto-jdk11/bin/java

    sudo alternatives --install /usr/bin/javac javac /usr/local/amazon-corretto-jdk11/bin/javac 2
    sudo alternatives --set javac /usr/local/amazon-corretto-jdk11/bin/javac

    # for some reason alternatives does not work to install jar, so we just manually create a symlink instead
    sudo rm /usr/local/jar
    sudo ln -s /usr/local/amazon-corretto-jdk11/bin/jar /usr/bin/jar
}

function install_maven() {
    _logger "[+] Installing Maven 3.6.3..."
    https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
    tar xvf apache-maven-3.6.3-bin.tar.gz -C /usr/local
    sudo ln -s /usr/local/apache-maven-3.6.3 /usr/local/apache-maven
    
    echo "export M2_HOME=/usr/local/apache-maven" >> ~/.profile
    echo "export M2=$M2_HOME/bin" >> ~/.profile
    echo "export PATH=$M2:$PATH" ~/.profile
    
}

function main() {
    upgrade_existing_packages
    install_linuxbrew
    install_utility_tools
    upgrade_sam_cli
    install_corretto_jdk11
    install_maven
    
    echo -e "${RED} [!!!!!!!!!] Open up a new terminal to reflect changes ${NC}"
    _logger "[+] Restarting Shell to reflect changes"
    exec ${SHELL}
}

main
