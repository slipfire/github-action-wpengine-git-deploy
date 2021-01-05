FROM debian:9.7-slim

LABEL "com.github.actions.name"="SlipFire Github WP Engine Deploy"
LABEL "com.github.actions.description"="An action to deploy to WP Engine even legacy staging!"
LABEL "com.github.actions.icon"="chevrons-right"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/slipfire/github-action-wpengine-git-deploy"
LABEL "maintainer"="Steve Bruner <sbruner@slipfire.com>"

RUN apt-get update && apt-get install -y git

ADD slipfire.sh /slipfire.sh
ENTRYPOINT ["/slipfire.sh"]
