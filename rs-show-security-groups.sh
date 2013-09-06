#!/bin/sh -e

# rs-show-security-groups.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

# Parameters:
rs_cloud_id="2"     # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $rs_api_version in
  "1.0") url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_security_groups?cloud_id=$rs_cloud_id"
         echo "[API 1.0] GET: $url"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$rs_api_version -b $rs_api_cookie $url 2>&1)
		 ;;
  "1.5") 
         #echo "[API 1.5] GET: $url"
		 #rs_cloud_id="2373" # e.g. 2373: Rackspace Open Cloud - London
         #url="https://my.rightscale.com/api/clouds/$rs_cloud_id/security_groups.xml"
		 #result=$(curl -s -S -i -k -H X_API_VERSION:$rs_api_version -b $rs_api_cookie -X GET $url 2>&1)
	     ;;
      *) echo ERROR: rs_api_version not set
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

