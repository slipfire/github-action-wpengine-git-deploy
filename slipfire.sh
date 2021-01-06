#!/bin/sh -l

set -e

: ${WPENGINE_SITE_NAME?Required environment name variable not set.}
: ${WPENGINE_SSH_KEY_PRIVATE?Required secret not set.}
: ${WPENGINE_SSH_KEY_PUBLIC?Required secret not set.}
: ${WP_ENGINE_ENV?Required environment not set ie staging or production.}
: ${LOCAL_BRANCH?Required branch not set ie staging or master.}

SSH_PATH="$HOME/.ssh"
WPENGINE_HOST="git.wpengine.com"
KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"
WPENGINE_SSH_KEY_PRIVATE_PATH="$SSH_PATH/wpengine_key"
WPENGINE_SSH_KEY_PUBLIC_PATH="$SSH_PATH/wpengine_key.pub"

mkdir "$SSH_PATH"

ssh-keyscan -t rsa "$WPENGINE_HOST" >> "$KNOWN_HOSTS_PATH"

echo "$WPENGINE_SSH_KEY_PRIVATE" > "$WPENGINE_SSH_KEY_PRIVATE_PATH"
echo "$WPENGINE_SSH_KEY_PUBLIC" > "$WPENGINE_SSH_KEY_PUBLIC_PATH"

chmod 700 "$SSH_PATH"
chmod 644 "$KNOWN_HOSTS_PATH"
chmod 600 "$WPENGINE_SSH_KEY_PRIVATE_PATH"
chmod 644 "$WPENGINE_SSH_KEY_PUBLIC_PATH"

git config core.sshCommand "ssh -i $WPENGINE_SSH_KEY_PRIVATE_PATH -o UserKnownHostsFile=$KNOWN_HOSTS_PATH"
git remote add $WPENGINE_SITE_NAME git@$WPENGINE_HOST:$WP_ENGINE_ENV/$WPENGINE_SITE_NAME.git

printf "\nLocal branches:\n"
git branch
printf "\nRemote branches:\n"
git branch -r
printf "\nGit Remote Show $WPENGINE_SITE_NAME:\n"
git remote show $WPENGINE_SITE_NAME
printf "\nGit status:\n"
git status
printf "\nPushing to WPE Site $WPENGINE_SITE_NAME\n"
git push -fu git@$WPENGINE_HOST:$WP_ENGINE_ENV/$WPENGINE_SITE_NAME.git $LOCAL_BRANCH
