# Git Credential Helper Github App

# Prereqs

Install `jq`.

# Setup

1.  Paste your app id into a file in this directory called `app_id`.
2.  Paste your installation id into a file in this directory called `installation_id`.
3.  Save your private key generated in the github app ui as `github-app.private-key.pem` in this directory.
4.  Make the script executable:

        chmod +x git-credential-helper-github-app.sh

5.  Use as your git credential helper by running this command, replacing `<path_to_git-credential-helper-github-app.sh>` with your path to this directory:

        git config --global credential.helper <path_to_this_directory>/git-credential-helper-github-app.sh

6.  You should be good to go. Test out your credentials by trying to `git pull` a repository that has this github app installed onto it with read permissions.
