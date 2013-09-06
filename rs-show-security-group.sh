#!/bin/sh -e

# rs-show-security-group.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

case $# in
   1) VERBOSE="false"    # VERBOSE off
      RS_SG_ID=$1        # ec2_security_group[aws_group_name], mandatory
      ;;
   2) if [ $1 == "-v" ] 
      then 
	     VERBOSE="true"  # VERBOSE on
		 RS_SG_ID=$2     # ec2_security_group[aws_group_name], mandatory
	  else
	     echo "Unrecognized parameter"
		 exit 1
	  fi
	  ;;
   *) echo "Usage  : $0 [-v] RS_SG_ID"
	  echo "Example: $0 -v 985781001"
      exit 1
      ;;
esac

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups/$RS_SG_ID"
         if [ $VERBOSE == "true" ] 
		 then
		    echo "[API 1.0] GET: $URL"
		 fi
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X GET \
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
		if [ $VERBOSE == "true" ] 
		then
		  echo "$result"
		else
		  echo "$result" | grep "<href>" | cut -d"/" -f8 | cut -d"<" -f1
		fi
		exit
	;;
	*)
		echo "$result"
		exit 1
	;;
esac
