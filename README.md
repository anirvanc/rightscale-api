rightscale
==========
Includes a number of mainly BASH scripts using cURL against the Rightscale API.
The first lot are for controlling security groups.

Example usage:

Clone this repository

    git clone https://github.com/jimfdavies/rightscale-api.git
Move into repository

    cd rightscale-api
Copy rs-set-auth.sh.example to rs-set-auth.sh

    cp rs-set-auth.sh.example rs-set-auth.sh
Edit rs-set-auth.sh

    # vim rs-set-auth.sh
For EC2 connections

    RS_API_VERSION=1.0
For any other cloud

    RS_API_VERSION=1.5
Run rs-login.sh

    ./rs-login.sh
If all is well, you will be able to run the following

    ./rs-list-security-groups.sh 2          # List all security groups in Rightscale cloud ID 2 (AWS EU)
	./rs-list-security-groups.sh 2 default  # Search through AWS EU and return ID of matching secgroup name