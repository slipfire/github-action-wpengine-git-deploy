FROM debian:9.7-slim

LABEL "com.github.actions.name"="Yikes WP Engine Deploy"
LABEL "com.github.actions.description"="An action to deploy to WP Engine even legacy staging!"
LABEL "com.github.actions.icon"="chevrons-right"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/yikesinc/github-action-wpengine-git-deploy"
LABEL "maintainer"="Freddie Mixell <freddie@yikesinc.com>"

RUN apt-get update && apt-get install -y git

ADD yikes.sh /yikes.sh
ENTRYPOINT ["/yikes.sh"]
