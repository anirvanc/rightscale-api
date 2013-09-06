#!/bin/sh -e

# rs-list-security-groups.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

if [ $# -ne 1 ]
then
        echo "Usage  : $0 RS_CLOUD_ID"
        exit 1
fi

# Parameters:
RS_CLOUD_ID=$1     # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups?cloud_id=$RS_CLOUD_ID"
         echo "[API 1.0] GET: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE $URL 2>&1)
		 ;;
  "1.5") 
         #echo "[API 1.5] GET: $URL"
		 #RS_CLOUD_ID="2373" # e.g. 2373: Rackspace Open Cloud - London
         #URL="https://my.rightscale.com/api/clouds/$RS_CLOUD_ID/security_groups.xml"
		 #result=$(curl -s -S -i -k -H X_API_VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X GET $URL 2>&1)
	     ;;
      *) echo ERROR: RS_API_VERSION not valid
	     exit 1
	     ;;
esac

case $result in
	*'200 OK'*)
		echo "$result"
		exit
	;;
	*)
		echo "$result"
		exit 1
	;;
esac

