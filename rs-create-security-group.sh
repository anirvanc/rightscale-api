#!/bin/sh -e

# rs-create-security-group.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

if [ $# -ne 3 ]
then
        echo "Usage  : $0 RS_CLOUD_ID SG_GROUP_NAME SG_GROUP_DESC"
		echo "Example: $0 2 sgtest 'Test security group'"
        exit 1
fi

# Parameters:
RS_CLOUD_ID=$1    # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2
SG_GROUP_NAME=$2  # ec2_security_group[aws_group_name], mandatory
SG_GROUP_DESC=$3  # ec2_security_group[aws_description], mandatory

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups"
         echo "[API 1.0] POST: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE \
		 -d "ec2_security_group[aws_group_name]=$SG_GROUP_NAME" \
		 -d "ec2_security_group[aws_description]=$SG_GROUP_DESC" \
		 -d "cloud_id=$RS_CLOUD_ID" \
		 $URL 2>&1)
		 ;;
  "1.5") 
         # UNTESTED
		 URL="https://my.rightscale.com/api/clouds/$RS_CLOUD_ID/security_groups"
		 echo "[API 1.5] POST: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE \
		 -d "security_group[name]=$SG_GROUP_NAME" \
		 -d "security_group[description]=$SG_GROUP_DESC" \
		 $URL 2>&1)
	     ;;
      *) echo ERROR: RS_API_VERSION not valid
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

