# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
if command -v aws
then
    echo "AWS CLI is already installed"
else
    sudo apt-get update
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -u awscliv2.zip
    sudo ./aws/install || true
    rm -f awscliv2.zip
fi
