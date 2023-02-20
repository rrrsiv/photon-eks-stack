# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
if command -v terraform
then
    echo "Terraform is already installed"
else
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt -y update
    sudo apt -y install terraform=1.3.6
fi
