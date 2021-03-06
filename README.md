# Running it
Once you've got config (see below) done, start all the necessary services, that's Solr, Redis, MySQL, and lastly Rails.

Most of this is made easier by `start_server.sh`.

# Config

## SSH Configuration
Add this to your `~/.ssh/config` file (change `IdentityFile` as needed)

		Host *.sngtrkr.com
		  IdentityFile "~/Google Drive/SNGTRKR/linode_public_key.pub"
		  User deploy
		  ForwardAgent yes

## Git Configuration
The repo is set to use GitHub's HTTPS method, so no SSH keys are involved here. As long as 
your client is [configured to use](https://help.github.com/articles/set-up-git) the credential
helper, you won't have to remember any passwords or SSH key locations this way!

On deployment, the server is set to cache login details to GitHub for months. In the unlikely
event it doesn't remember the login details, you will need to SSH into it and run a command that
prompts for credentials. This will do:

	git ls-remote https://github.com/MattBessey/sngtrkr.git

## Hosts Configuration
If you want to do anything significant in dev, involving the FB api, you need to change your `/etc/hosts` file
to point `dev.sngtrkr.com` at `127.0.0.1`. Now to develop go to `http://dev.sngtrkr.com:3000`.

## Environment Variables
The following environmental variables will need to be added to your `.bashrc` file for SNGTRKR to work correctly:

		export SNGTRKR_7DIGITAL="replaceme"
		export SNGTRKR_7DIGITAL_SECRET="replaceme"
		export SNGTRKR_AWS_ID="replaceme"
		export SNGTRKR_AWS_KEY="replaceme"
		export SNGTRKR_DB_PW="replaceme"
		export SNGTRKR_DB_USER="replaceme"

