#!/bin/sh -e
EMAIL="rightscale01@moneysupermarket.com"   # The email address for your RightScale User in the Dashboard
PWD="M0r3servers?"                         # Your User's password
ACCOUNT="70082"                             # Account ID, easily obtained from navigation in the Dashboard

curl -i -k -H X_API_VERSION:1.5 -c ~/rsauth -X POST -d email=$EMAIL -d password=$PWD -d account_href=/api/accounts/$ACCOUNT https://my.rightscale.com/api/session
