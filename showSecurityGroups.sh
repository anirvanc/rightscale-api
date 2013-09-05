#!/bin/sh -e
EMAIL="rightscale01@moneysupermarket.com"   # The email address for your RightScale User in the Dashboard
PWD="M0r3servers?"                         # Your User's password
ACCOUNT="70082"                             # Account ID, easily obtained from navigation in the Dashboard
APIVER="1.0"                                # API version to use. TODO: add as parameter

case "$APIVER" in
  "1.0") echo 1.0
  URL="https://my.rightscale.com/api/acct/$ACCOUNT/ec2_security_groups"
         curl -i -k -H X-API-VERSION:1.0 -c ~/rsauth -u $EMAIL:$PWD https://my.rightscale.com/api/acct/$ACCOUNT/login 
		curl -i -k -H X-API-VERSION:1.0 -b ~/rsauth $URL
		;;
  "1.5") echo 1.5
         curl -i -k -H X_API_VERSION:1.5 -c ~/rsauth -X POST -d email=$EMAIL -d password=$PWD -d account_href=/api/accounts/$ACCOUNT https://my.rightscale.com/api/session
	     ;;
      *) echo APIVER not set.
	     exit 1
	     ;;
esac
# Login and store auth in cookie jar ~/rsauth
#

#curl -i -k -H X_API_VERSION:1.5 -b ~/rsauth -X GET https://my.rightscale.com/api/clouds.xml

#CLOUD="2"
#curl -i -k -H X_API_VERSION:1.5 -b ~/rsauth -X GET https://my.rightscale.com/api/clouds/$CLOUD/security_groups.xml
