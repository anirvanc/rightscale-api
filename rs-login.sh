#! /bin/sh -e

# rs-login.sh
# Logs into Rightscale with given env vars
# Depends on rs-set-auth.sh to be run previously (usually via boot-time Rightscript)
# TSM tweak - added -k to cURL options to mitigate proxy issue

# by default API 1.0 is used unless RS_API_VERSION=1.5 is set in env or ~/.rightscale/rs_api_config.sh
# e.g. rs_api_config=1.5 rs-login.sh

# References
# http://support.rightscale.com/12-Guides/03-RightScale_API/RightScale_API_Examples/Authentication
# http://reference.rightscale.com/api1.0/ApiR1V0/Docs/ApiLogins.html
# http://support.rightscale.com/12-Guides/RightScale_API_1.5/Authentication
# http://reference.rightscale.com/api1.5/index.html

[ -e "$HOME"/.rightscale ] || ( mkdir -p "$HOME"/.rightscale && chmod -R 700 "$HOME"/.rightscale )

# set env vars
. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

# get and store the cookie
if [ "$RS_API_VERSION" = "1.5" ]; then
	URL="https://my.rightscale.com/api/session"
	echo "[API 1.5] POST: $URL"
	result=$(curl -s -S -k -v -H 'X_API_VERSION: 1.5' -c "$RS_API_COOKIE" -X POST -d email="$RS_API_USER" -d password="$RS_API_PASSWORD" -d account_href=/api/accounts/$RS_API_ACCOUNT_ID "$URL" 2>&1)
else
	URL="https://my.rightscale.com/api/acct/$RS_API_ACCOUNT_ID/login?api_version=$RS_API_VERSION"
	echo "[API 1.0] GET: $URL"
	result=$(curl -s -S -k -v -c "$RS_API_COOKIE" -u "$RS_API_USER":"$RS_API_PASSWORD" "$URL" 2>&1)
fi

case $result in
	*'204 No Content'*)
		echo 'Login successful.'
		exit
	;;
	*)
		echo 'Login failed!'
		echo "$result"
		exit 1
	;;
esac