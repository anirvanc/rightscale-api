rightscale-api
==============
Includes a number of mainly BASH scripts using cURL against the Rightscale API.
The first lot are for controlling security groups.

Authentication setup and config is taken from Rightscale's own 1.0/1.5 examples:

http://support.rightscale.com/12-Guides/03-RightScale_API/RightScale_API_Examples
http://support.rightscale.com/12-Guides/03-RightScale_API/RightScale_API_Examples/Authentication

NOTE: The API 1.5 functions are not quite finished but can be used for reference.

**USE THESE SCRIPTS AT YOUR OWN RISK!**

Please **please** do not run them if you don't understand what the code is doing.

Example usage:

Clone this repository

    $ git clone https://github.com/jimfdavies/rightscale-api.git
Move into repository

    $ cd rightscale-api
Copy rs-set-auth.sh.example to rs-set-auth.sh

    $ cp rs-set-auth.sh.example rs-set-auth.sh
Edit rs-set-auth.sh

    # vim rs-set-auth.sh
    # RS_API_VERSION=1.0   # For EC2 connections
    # RS_API_VERSION=1.5   # For any other cloud
Run rs-set-auth.sh (creates the scripts which, in turn,
create the environment variables)

    ./rs-set-auth.sh
Run rs-login.sh

    ./rs-login.sh
If all is well, you will be able to run the following

    # List all secgroups in Rightscale cloud ID 2 (AWS EU)
	./rs-list-security-groups.sh 2    
	# Search through AWS EU and return ID of matching secgroup name
	./rs-list-security-groups.sh 2 default
    # Create a new group in AWS EU called sgtest with a description	"Test security group"
	./rs-create-security-group.sh -v 2 sgtest "Test security group"
	# Create a new group in AWS EU but just return the ID of the new secgroup
	./rs-create-security-group.sh 2 sgtest "Test security group"
	# Add a TCP/22 from anyone to a secgroup ID 12345678
	./rs-update-security-group.sh 12345678 0.0.0.0/0 tcp 22 22
	# Add a TCP/22 from anyone to a secgroup called SGNAME in AWS EU 12345678
	./rs-update-security-group.sh $(./rs-list-security-groups.sh 2 SGNAME) 0.0.0.0/0 tcp 22 22
	
	
	
	
	
	