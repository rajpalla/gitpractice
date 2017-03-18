echo -e '192.168.33.95 oracleweblogic.com oracleweblogic' >> /etc/hosts
echo 'oracleweblogic' > /etc/hostname
sudo hostnamectl set-hostname oracleweblogic
hostname -f

dd if=/dev/zero of=/swapfile bs=1M count=1024
mkswap /swapfile
swapon -v /swapfile
swapfile swap swap defaults 0 0

sudo apt-get update
sudo apt-get install tree -y zip unzip
# Installing jdk-8.0.112 and Its Configuration
sudo wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
sudo mkdir /opt/jdk
tar -xzvf jdk-8u112-linux-x64.tar.gz -C /opt/jdk
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_112/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_112/bin/javac 100
sudo update-alternatives --display java
sudo update-alternatives --display javac
java -version
# Installing Weblogic and Its Configuration
sudo groupadd oraclewls
sudo useradd -g oraclewls oraclewls
cp /vagrant/fmw_12.2.1.2.0_wls_Disk1_1of1.zip /home/ubuntu/fmw_12.2.1.2.0_wls_Disk1_1of1.zip
cd /home/ubuntu
unzip fmw_12.2.1.2.0_wls_Disk1_1of1.zip -d /opt/wls122120/
sudo mkdir -p /opt/wls122120/middleware
sudo mkdir -p /opt/wls122120/inventory
sudo chown -R oraclewls:oraclewls /opt/wls122120/
sudo chmod -R 755 /opt/wls122120/
echo '
MW_HOME=/opt/wls122120/middleware; export MW_HOME
JAVA_HOME=/opt/jdk/jdk1.8.0_112; export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH; export PATH
export WL_HOME=$MW_HOME/wlserver
export CLASSPATH=$WL_HOME/server/bin/setWLSEnv.sh' >> ~/.bash_profile
sudo echo 'inventory_loc=/opt/wls122120/inventory
inst_group=oraclewls' > /etc/oraInst.loc
echo '
[ENGINE]
Response File Version=1.0.0.0.0
[GENERIC]
ORACLE_HOME=/opt/wls122120/middleware
INSTALL_TYPE=WebLogic Server
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=<SECURE VALUE>
DECLINE_SECURITY_UPDATES=true
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=<SECURE VALUE>
COLLECTOR_SUPPORTHUB_URL=' >> /opt/wls122120/wls122120_silent.rsp
sudo chown -R oraclewls:oraclewls /opt/wls122120/wls122120_silent.rsp
#cd /opt/wls122120/
umask 027
sudo -u oraclewls java -Xmx1024m -Djava.security.egd=file:/dev/./urandom -jar /opt/wls122120/fmw_12.2.1.2.0_wls.jar -silent -invPtrLoc /etc/oraInst.loc -responsefile /opt/wls122120/wls122120_silent.rsp
#sh /opt/wls122120/middleware/oracle_common/common/bin/wlst.sh
#sh /opt/wls122120/middleware/user_projects/domains/oracleweblogic_domain/bin/startWebLogic.sh