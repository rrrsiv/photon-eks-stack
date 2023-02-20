# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
export currdir=`pwd`
echo "INSTALLATION STARTED FROM ${currdir}"

jenkinspath=`/var/lib/jenkins`
if [ -d "$jenkinspath" ]
then
    # Just Restart
	echo "Jenkins Exists"
			sudo service jenkins restart
			echo "Jenkins is restarted"

else
    # Install
	sudo wget https://pkg.jenkins.io/debian/jenkins.io.key -O jenkins.io.key
	sudo apt-key add jenkins.io.key
	#downloading jenkins and completing the setup
	sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
	sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

	# Running Update on the system before installing jenkins
	sudo apt-get -y update
	sudo apt-get -y install openjdk-11-jdk-headless
	sudo apt-get -y install jenkins=2.375.2

	`sudo rm -rf jenkins.io.key`
	#fetching jenkins status
	status=`sudo service jenkins status`
	#checking for jenkins to be up and running, it will run till the time jenkins is not up 
	while [ "`wget --server-response --spider --quiet http://localhost:8080/jnlpJars/jenkins-cli.jar 2>&1 | awk 'NR==1{print $2}'`" != "200" ]
	do
		echo "PLEASE WAIT JENKINS WILL BE UP SOON!!!"
		sleep 5
	done
	#downloading jenkins cli for installation of plugins
	wget http://localhost:8080/jnlpJars/jenkins-cli.jar -O jenkins-cli.jar
	
	#Inital password for jenkins UI
	password=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
	# Create an account photon/photon
	echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("photon", "photon")' | java -jar jenkins-cli.jar -auth admin:$password -s http://localhost:8080/ groovy =
	# Installing Jenkins Plugins
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin uno-choice
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin git
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin log-parser
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin postbuild-task
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin extended-choice-parameter
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin credentials
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin ansible:1.1
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin workflow-aggregator
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin file-parameters
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin pipeline-stage-view
	java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon install-plugin build-timeout

    #restarting jenkins
    java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon restart
	
	#waiting for jenkins to be up
	while [ "`wget --server-response --spider --quiet http://localhost:8080/jnlpJars/jenkins-cli.jar 2>&1 | awk 'NR==1{print $2}'`" != "200" ]
	do
		echo "PLEASE WAIT JENKINS WILL BE UP SOON!!!"
		sleep 5
	done

fi

# Import Jobs
echo "IMPORTING JOBS."

for job in `ls ${currdir}/jenkins_jobs`
do
job_name=$(echo $job | cut -d "." -f1 | tee echo)
java -jar jenkins-cli.jar -s "http://localhost:8080/" -auth photon:photon create-job $job_name < ${currdir}/jenkins_jobs/$job
done

# Install custom plugins on demand (Read from a file)- TBD

# Restart Jenkins
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth photon:photon restart
	
echo "JENKINS IS READY TO USE"
rm -rf jenkins_jobs
