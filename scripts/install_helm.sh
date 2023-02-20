# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
if command -v helm
then
    echo "Helm is already installed"
else
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get -y install apt-transport-https
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get -y update
    sudo apt-get -y install helm=3.10.3-1
fi