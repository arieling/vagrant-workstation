#!/usr/bin/env bash

echo 'Update packages list...'
echo "------------------------"
apt-get -y update

echo 'Install Xubuntu Desktop & co...'
echo "------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes --no-install-recommends install xubuntu-desktop mousepad xubuntu-icon-theme \
xfce4-goodies xubuntu-wallpapers gksu cifs-utils xfce4-whiskermenu-plugin firefox \
xarchiver filezilla

echo 'Set New York timezone...'
echo "------------------------"
echo "America/New_York" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

echo 'Set English keyboard layout...'
echo "------------------------"
sudo sed -i 's/XKBLAYOUT="us"/g' /etc/default/keyboard

echo 'Install Chrome...'
echo "------------------------"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp
sudo dpkg -i /tmp/google-chrome*
sudo apt-get -f install -y
rm /tmp/google*chrome*.deb

echo 'Install JDK 8 in /usr/lib/jvm/java-8-oracle...'
echo "------------------------"
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-jdk8-installer -y
sudo apt-get install oracle-java8-set-default -y
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export PATH=$JAVA_HOME/bin:$PATH

# echo 'Install JDK 6 in /usr/lib/jvm/java-6-oracle...'
# sudo apt-get install -y oracle-java6-installer

echo 'Create Development directory...'
echo "------------------------"
mkdir /home/vagrant/Development
mkdir /home/vagrant/Development/git
sudo chmod 777 -R /home/vagrant/Development/

echo 'Install Eclipse JEE Kepler SR2...'
echo "------------------------"
# wget http://eclipse.mirror.garr.it/mirrors/eclipse//technology/epp/downloads/release/kepler/SR2/eclipse-jee-kepler-SR2-linux-gtk-x86_64.tar.gz -P /tmp
wget http://dist.springsource.com/release/STS/3.7.0.RELEASE/dist/e4.5/spring-tool-suite-3.7.0.RELEASE-e4.5-linux-gtk-x86_64.tar.gz -P /tmp
tar xzf /tmp/spring-tool-suite-*-linux-gtk*.tar.gz -C /home/vagrant/Development/
# sudo ln -s /home/vagrant/Development/sts-bundle/sts-3.7.0.RELEASE /usr/bin/sts
# sudo ln -s /home/vagrant/Development/eclipse/eclipse /usr/bin/eclipse
# wget -N https://raw.github.com/lfiammetta/vagrant/master/settings/xubuntu/eclipse.desktop -P /tmp
# sudo mv /tmp/eclipse.desktop /usr/share/applications/
# rm /tmp/eclipse-jee-*-linux-gtk*.tar.gz

echo 'Install Tomcat 8.0.24...'
echo "------------------------"
# wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.39/bin/apache-tomcat-7.0.39.tar.gz -P /tmp
wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz -P /tmp
tar xzf /tmp/apache-tomcat*.tar.gz -C /home/vagrant/Development/
rm /tmp/apache-tomcat*.tar.gz

# http://localhost/
echo 'Install Apache2...'
echo "------------------------"
sudo apt-get install apache2 -y

# echo 'Install PHP 5...'
# echo "------------------------"
# sudo apt-get install php5 -y

# echo 'Install MySql...'
# echo "------------------------"
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install mysql-server

# http://localhost/phpmyadmin/
# echo 'Install phpMyAdmin...'
# echo "------------------------"
# sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
# sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
# sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
# sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
# sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
# export DEBIAN_FRONTEND=noninteractive && sudo apt-get -q -y install phpmyadmin

echo 'Install DBeaver 2.4.0...'
echo "------------------------"
wget -c http://dbeaver.jkiss.org/files/dbeaver_2.4.0_amd64.deb -P /tmp
sudo dpkg -i /tmp/dbeaver_2.4.0_amd64.deb
sudo apt-get install -f
rm /tmp/dbeaver*.deb

echo 'Install Git and create local repository directory'
echo "------------------------"
sudo apt-get install git -y

echo 'Install Git Flow...'
echo "------------------------"
wget -q – http://github.com/nvie/gitflow/raw/develop/contrib/gitflow-installer.sh –no-check-certificate -P /tmp
sudo chmod a+x /tmp/gitflow-installer.sh
sudo sh /tmp/gitflow-installer.sh

# echo 'Install Maven in /usr/share/maven...'
# echo "------------------------"
# sudo apt-cache search maven
# sudo apt-get install maven -y

# echo 'Install Oh My Zsh'
# echo "------------------------"
sudo apt-get install zsh -y
touch /home/vagrant/.zshrc
# wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
sh -c "$(wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chsh -s /bin/zsh vagrant
sudo zsh
sudo chown vagrant:vagrant /home/vagrant/.zshrc
sudo chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh

# Change the oh my zsh default theme.
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
sudo sed -i 's/plugins=(git)/plugins=(git ruby rails bower bundler docker gem git-extras mvn npm python redis-cli)/g' ~/.zshrc
git clone https://github.com/powerline/fonts.git /home/vagrant/workspace/powerline
sudo /home/vagrant/workspace/powerline/install.sh
rm -rf /home/vagrant/workspace/powerline

echo 'Install docker'
# Ask for the user password
# Script only works if sudo caches the password for a few minutes
sudo true

# Install kernel extra's to enable docker aufs support
sudo apt-get -y install linux-image-extra-$(uname -r)

# Add Docker PPA and install latest version
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker -y

echo 'Add docker group'
sudo usermod -aG docker vagrant

# Install docker-compose
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/1.3.3/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Install docker-cleanup command
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
sudo mv docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup
