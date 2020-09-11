## Advanced Usage Building Scripts

```
name: Github Action with WP Engine Git Deploy

on:
  push:
    branches:
     - production
     - staging

jobs:
  build-and-deploy:
    name: Build and Deploy to WP Engine
    runs-on: ubuntu-18.04
    env:
      WPENGINE_SSH_KEY_PRIVATE: ${{ secrets.WPENGINE_SSH_KEY_PRIVATE }}
      WPENGINE_SSH_KEY_PUBLIC: ${{ secrets.WPENGINE_SSH_KEY_PUBLIC }}
    steps:
    - uses: actions/checkout@v1
    
    - name: Build Stuff
      run: |
        lando start &&
        cd wp-content/themes/iiba && lando yarn build:production

    - name: Set deployment gitignores then Commit
      run: |
        rm wp-content/themes/iiba/.gitignore
        rm wp-content/uploads/.htaccess
        cp dev/deployment/gitignore .gitignore &&
        timestamp=$(date "+%Y.%m.%d-%H.%M.%S") &&
        git status &&
        git add -A &&
        git commit -m "Github Actions Commit $timestamp"

    - name: Deploy to Production with GitHub Action for WP Engine Git
      if: github.ref == 'refs/heads/production'
      uses: campaignupgrade/github-action-wpengine-git-deploy@0.1.2
      env:
        WPENGINE_ENVIRONMENT_NAME: mycoolinstall
        LOCAL_BRANCH: 'production'

    - name: Deploy to WPEngine Staging Site
      if: github.ref == 'refs/heads/staging'  # if pushed to this branch
      uses: campaignupgrade/github-action-wpengine-git-deploy@master
      env:
        WPENGINE_SITE_NAME: 'iiba3staging' # deploy to this WPE site
        LOCAL_BRANCH: 'staging' # deploy this branch's code
```