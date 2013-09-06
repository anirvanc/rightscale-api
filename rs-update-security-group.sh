#!/bin/sh -e

# rs-update-security-group.sh
# REQUIRES rs-login.sh to be run previously

# REFERENCE:
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiEc2SecurityGroups.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Examples/Security_Groups/List_Security_Groups
# http://reference.rightscale.com/api1.5/resources/ResourceSecurityGroups.html

if [ $# -ne 5 ]
then
        echo "Usage  : $0 RS_SG_ID SG_CIDR_IPS SG_PROTOCOL SG_FROM_PORT SG_TO_PORT"
		echo "Example: $0 985781001 0.0.0.0/0 tcp 22 22"
        exit 1
fi

# Parameters:
RS_SG_ID=$1     # ec2_security_group[aws_group_name], mandatory
SG_CIDR_IPS=$2  # ec2_security_group[cidr_ips], mandatory (IP range (e.g. 192.168.0.1/8))
SG_PROTOCOL=$3  # ec2_security_group[protocol], mandatory (‘tcp’, ‘udp’ or ‘icmp’)
SG_FROM_PORT=$4 # ec2_security_group[from_port], mandatory (Port range lower bound)
SG_TO_PORT=$5   # ec2_security_group[to_port], mandatory (Port range upper bound)
RS_CLOUD_ID=2373 # TESTING ONLY. API 1.5 function not complete

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

case $RS_API_VERSION in
  "1.0") URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/ec2_security_groups/$RS_SG_ID"
         echo "[API 1.0] PUT: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X PUT \
		 -d "ec2_security_group[cidr_ips]=$SG_CIDR_IPS" \
		 -d "ec2_security_group[protocol]=$SG_PROTOCOL" \
		 -d "ec2_security_group[from_port]=$SG_FROM_PORT" \
		 -d "ec2_security_group[to_port]=$SG_TO_PORT" \
		 $URL 2>&1)
		 ;;
  "1.5") 
         # UNTESTED
		 # CREATE not UPDATE!
		 URL="https://my.rightscale.com/api/clouds/$RS_CLOUD_ID/security_groups/$RS_SG_ID/security_group_rules"
		 echo "[API 1.5] POST: $URL"
		 result=$(curl -s -S -i -k -H X-API-VERSION:$RS_API_VERSION -b $RS_API_COOKIE -X POST \
		 -d "security_group_rule[source_type]=cidr_ips" \
		 -d "security_group_rule[cidr_ips]=$SG_CIDR_IPS" \
		 -d "security_group_rule[protocol]=$SG_PROTOCOL" \
		 -d "security_group_rule[protocol_details][start_port]=$SG_FROM_PORT" \
		 -d "security_group_rule[protocol_details][end_port]=$SG_TO_PORT" \
		 $URL 2>&1)
	     ;;
      *) echo ERROR: RS_API_VERSION not set
	     exit 1
	     ;;
esac

case $result in
	*'204 No Content'*)
		echo "$result"
		exit
	;;
	*)
		echo "$result"
		exit 1
	;;
esac

