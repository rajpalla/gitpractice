echo -e '192.168.33.95 oracleweblogic.com oracleweblogic' >> /etc/hosts
echo 'oracleweblogic' > /etc/hostname
sudo hostnamectl set-hostname oracleweblogic
hostname -f

dd if=/dev/zero of=/swapfile bs=1M count=2048
mkswap /swapfile
swapon -v /swapfile
swapfile swap swap defaults 0 0

sudo apt-get update

# Installing jdk-8.0.112 and Its Configuration
sudo wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
sudo mkdir /opt/jdk
tar -xzvf jdk-8u112-linux-x64.tar.gz -C /opt/jdk
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_112/bin/java 1100
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_112/bin/javac 1100
sudo update-alternatives --display java
sudo update-alternatives --display javac
java -version

# Installing WebLogic and its configuration
sudo echo '
export JAVA_HOME=/opt/jdk/jdk1.8.0_112
export PATH=$JAVA_HOME/bin:$PATH
export MW_HOME=/opt/oracle/middleware
export WL_HOME=$MW_HOME/wlserver
export CLASSPATH=$WL_HOME/server/bin/setWLSEnv.sh' >> ~/.bash_profile
sudo groupadd -g 666 oinstall
sudo useradd -u 666 -g oinstall -G oinstall oracle
echo "oracle:oracle" | chpasswd
sudo mkdir -p opt/oracle/inventory
sudo mkdir -p /opt/oracle/middleware
sudo chown -R oracle:oinstall /opt/oracle 
sudo chmod -R 755 /opt/oracle
cp /vagrant/fmw_12.1.3.0.0_wls.jar /opt/oracle/
sudo echo 'inventory_loc=/opt/oracle/inventory
inst_group=oinstall' > /etc/oraInst.loc
sudo echo '
[ENGINE]
Response File Version=1.0.0.0.0
[GENERIC]
ORACLE_HOME=/opt/oracle/middleware
INSTALL_TYPE=WebLogic Server
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
DECLINE_SECURITY_UPDATES=true
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
COLLECTOR_SUPPORTHUB_URL=' > /opt/oracle/Install.rsp
sudo chown -R oraclewls:oraclewls /opt/oracle/Install.rsp
cd /opt/oracle
#sudo -u oracle java -Xmx1024m -Djava.security.egd=file:/dev/./urandom -jar fmw_12.1.3.0.0_wls.jar -silent -invPtrLoc /etc/oraInst.loc -responseFile /opt/oracle/Install.rsp

