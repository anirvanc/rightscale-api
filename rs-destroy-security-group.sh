#!/bin/sh -e

# rs-destroy-security-group.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

case $# in
   1) RS_SG_ID=$1        # ec2_security_group[aws_group_name], mandatory
      ;;
   *) echo "Usage  : $0 RS_SG_ID"
	  echo "Example: $0 985781001"
      exit 1
      ;;
esac

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups/$RS_SG_ID"
		 echo "[API 1.0] DELETE: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X DELETE \
		 $URL 2>&1)
		 ;;
  "1.5") 
         # UNTESTED
		 #URL="https://my.rightscale.com/api/clouds/$RS_CLOUD_ID/security_groups/$RS_SG_ID"
		 #echo "[API 1.5] GET: $URL"
		 #result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X GET \
		 #$URL 2>&1)
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
