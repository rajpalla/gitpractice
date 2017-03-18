sudo apt-get update
sudo apt-get install -y curl linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
curl -s https://yum.dockerproject.org/gpg | sudo apt-key add -
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main"
sudo apt-get update
sudo apt-cache policy docker-engine
sudo apt-get -y install docker-engine
sudo docker run hello-world
