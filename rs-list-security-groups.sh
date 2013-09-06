#!/bin/sh -e

# rs-list-security-groups.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

# TODO: Add 'search' function

case $# in
   1) RS_CLOUD_ID=$1     # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2
      ;;
   2) RS_CLOUD_ID=$1     # cloud_id: Id of the cloud in which the security group should be created e.g AWS EU: 2
      SG_NAME=$2         # security group name to search index for. Setting this reduces stdout to just ID (and null if not found)
	  ;;
   *) echo "Usage  : $0 RS_CLOUD_ID [SG_GROUP_NAME]"
	  echo "Example: $0 2 sgweb"
	  echo
	  echo "If SG_NAME is set, only the matching ID is returned (or null if not found)."
	  echo "Otherwise all secgroups are returned"
      exit 1
      ;;
esac

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups?cloud_id=$RS_CLOUD_ID"
         if [ -z "$SG_NAME" ]
		 then
		   echo "[API 1.0] GET: $URL"
		 fi
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE $URL 2>&1)
		 ;;
  "1.5") 
         #URL="https://my.rightscale.com/api/clouds/$RS_CLOUD_ID/security_groups.xml"
		 #if [ -z "$SG_GROUP_NAME" ]
		 #then
		 #echo "[API 1.5] GET: $URL"
		 #fi
		 #result=$(curl -s -S -i -k -H X_API_VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X GET $URL 2>&1)
	     ;;
      *) echo ERROR: RS_API_VERSION not valid
	     exit 1
	     ;;
esac

case $result in
	*'200 OK'*)
	    if [ -n "$SG_NAME" ]
		then
		  echo "$result" | grep -A 1 -i "<aws-group-name>$SG_NAME" | tail -n1 | cut -d"/" -f8 | cut -d"<" -f1
		else
		  echo "$result"
		fi
		exit
	;;
	*)
		echo "$result"
		exit 1
	;;
esac

