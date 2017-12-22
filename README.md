# caldwell-api
Servant Api for caldwell.band

This README documents the steps necessary to get the
application up and running.

## System dependencies
    * `gem install docker-sync`
    * docker / docker-compose: install edge from [download-docker-for-mac](https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac)

## Initial Setup
    * This project uses docker to create a virtualized development environment.
        Run the following commands to get setup.
    * `docker-sync-stack start`
    * In another Terminal: `docker-compose exec api stack exec --system-ghc seed`
    * Go to localhost:7777 in a browser and wait for the page to load.
        You should see requests coming in to the server.

## How to run the test suite
    * With a running container:
    * In another Terminal: `docker-compose exec api stack --system-ghc test`

## Deployment instructions
    * circle is setup for the backend deployments so a commit and push to master should trigger a ci-build & deploy.
    * for the frontent, need to automate, but for now
        * `docker-compose exec client npm run build`
        * delete files currently in s3 bucket and copy/paste new public/* up to S3


### Elm Lines of Code as of Sept 2nd 2017
```bash
$ alias elmloc
alias elmloc='find . -name '\''*.elm'\'' | grep -v elm-stuff | grep -v node_modules | xargs cloc'
$ erlandsona ❯ ~/code/personal/caldwell
$ elmloc
      15 text files.
      15 unique files.
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.02 s (673.0 files/s, 71655.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             15            260             75           1262
-------------------------------------------------------------------------------
SUM:                            15            260             75           1262
-------------------------------------------------------------------------------
```
