#!/usr/bin/env bash
#
# BOSM : Bill Of Software Materials
#
# Utility script to keep track of package dependencies.
#
# Attempting to minimise distro differences, and manage docker complexity/size.

find_yum_packages() 
{
grep yum install-packages.sh | \
while read line
do
if [[ "$line" =~ ^yum -y install(.*)$ ]]
then
echo $line
fi
done
}


find_yum_packages
