# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
if command -v unzip
then
    echo "unzip is already installed"
else
sudo apt -y update
sudo apt -y install unzip
fi

if command -v python3
then
    echo "python3 is already installed"
else
sudo apt -y update
sudo apt -y install python3-pip
fi

if command -v ansible
then
    echo "ansible is already installed"
else
sudo apt -y update
sudo apt -y install ansible=2.9.6+dfsg-1
fi

