#!/bin/bash
# Downloading Plugins
cd "/jmeter/"
echo " Plugins Installation Started ..."

for plugin in `cat jmeter-dependencies.txt`
do
  #echo "$plugin"
  wget -P "/jmeter/" "$plugin"
done

# Deleting unneccessary files
cd "/jmeter/" 
for z in *.zip;
do
  unzip -o $z;
  rm $z;
done

echo "Plugins Installed ..."