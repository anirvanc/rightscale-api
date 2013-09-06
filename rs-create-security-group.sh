#!/bin/sh -e

# rs-create-security-group.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

# Parameters:
cloud_id="2"           # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2
sg_group_name="SGTest" # ec2_security_group[aws_group_name], mandatory
sg_group_desc="SGTest" # ec2_security_group[aws_description], mandatory

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $rs_api_version in
  "1.0") url="https://my.rightscale.com/api/acct/$rs_api_account_id/ec2_security_groups"
         echo "[API 1.0] POST: $url"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$rs_api_version -b $rs_api_cookie \
		 -d "ec2_security_group[aws_group_name]=$sg_group_name" \
		 -d "ec2_security_group[aws_description]=$sg_group_desc" \
		 -d "cloud_id=$cloud_id" \
		 $url 2>&1)
		 ;;
  "1.5") 
         #echo "[API 1.5] GET: $url"
	     ;;
      *) echo ERROR: rs_api_version not set
	     exit 1
	     ;;
esac

case $result in
	*'201 CREATED'*)
		echo "$result"
		exit
	;;
	*)
		echo "$result"
		exit 1
	;;
esac

