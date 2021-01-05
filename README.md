# SlipFire: Github to WP Engine Deploy

An action to deploy your repository to a **[WP Engine](https://wpengine.com)** site via git. [Read more](https://wpengine.com/git/) about WP Engine's git deployment support.

These configs automatically deploy when:
- a commit is made to the designated branch
- when a PR is merged into the designated branch

## To use
1. create a `.github/workflows` folder in your project repository.
2. create a .yml file, name it whatever you want (e.g. deploy-to-production.yml).
3. Add the appropriate config, below, to your file.
4. Update the `WPENGINE_SITE_NAME`, `LOCAL_BRANCH` and `WP_ENGINE_ENV` in the file.
5. Add two secrets to Github, named `WPENGINE_SSH_KEY_PRIVATE` and `WPENGINE_SSH_KEY_PUBLIC`, with the appropriate values.
6. Commit your .yml file to Github and you're ready to go!

Original action forked from @yikesinc who forked from @campaignupgrade who forked from @jovrtn! Thanks everyone!

## Example Production Github Action Deploy

```
name: SlipFire Deploy Main

on:
  push:
    branches:
      -  main

jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v2
    - run: |
          git fetch --prune --unshallow

    - name: GitHub Action for WP Engine Git Deployment
      uses: slipfire/github-action-wpengine-git-deploy@master
      env:
        WPENGINE_SITE_NAME: 'slipfire' # your wp engine site name. example: slipfire.wpengine.com would be slipfire
        LOCAL_BRANCH: 'main' # branch that you're pushing too on WP Engine.
        WP_ENGINE_ENV: 'production' # environment you're pushing too. Use 'staging' for legacy staging.
        WPENGINE_SSH_KEY_PRIVATE: ${{ secrets.WPENGINE_SSH_KEY_PRIVATE }}
        WPENGINE_SSH_KEY_PUBLIC: ${{ secrets.WPENGINE_SSH_KEY_PUBLIC }}
```

## Example Legacy Staging Github Action Deploy

```
name: SlipFire Deploy Staging

on:
  push:
    branches:
      - staging

jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v2
    - run: |
          git fetch --prune --unshallow

    - name: GitHub Action for WP Engine Git Deployment
      uses: slipfire/github-action-wpengine-git-deploy@master
      env:
        WPENGINE_SITE_NAME: 'slipfire'
        LOCAL_BRANCH: 'staging'
        WP_ENGINE_ENV: 'staging'
        WPENGINE_SSH_KEY_PRIVATE: ${{ secrets.WPENGINE_SSH_KEY_PRIVATE }}
        WPENGINE_SSH_KEY_PUBLIC: ${{ secrets.WPENGINE_SSH_KEY_PUBLIC }}
```

## Environment Variables & Secrets

### Required

| Name | Type | Usage |
|-|-|-|
| `WPENGINE_SITE_NAME` | Environment Variable | The name of the WP Engine site you want to deploy to. |
| `WPENGINE_SSH_KEY_PRIVATE` | Secret | Private SSH key of your WP Engine git deploy user. See below for SSH key usage. |
|  `WPENGINE_SSH_KEY_PUBLIC` | Secret | Public SSH key of your WP Engine git deploy user. See below for SSH key usage. |
| `WPENGINE_ENV` | Environment Variable  | Defaults to `production`. You shouldn't need to change this, but if you're using WP Engine's legacy staging, you can override the default and set to `staging` if needed. |
| `LOCAL_BRANCH` | Environment Variable  | Set which branch in your repository you'd like to push to WP Engine. Defaults to `master`. |

### Further reading

* [Defining environment variables in GitHub Actions](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables)
* [Storing secrets in GitHub repositories](https://developer.github.com/actions/managing-workflows/storing-secrets/)

## Setting up your SSH keys

1. [Generate a new SSH key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) as a special deploy key. The simplest method is to generate a key pair with a blank passphrase, which creates an unencrypted private key.
2. Store your public and private keys in your GitHub repository as new 'Secrets' (under your repository settings), using the names `WPENGINE_SSH_KEY_PRIVATE` and `WPENGINE_SSH_KEY_PUBLIC` respectively. In theory, this replaces the need for encryption on the key itself, since GitHub repository secrets are encrypted by default.
3. Add the public key to your target WP Engine environment.
4. Per the [WP Engine documentation](https://wpengine.com/git/), it takes about 30-45 minutes for the new SSH key to become active.
