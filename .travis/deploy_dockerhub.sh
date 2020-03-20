#!/bin/sh
docker login -u $DOCKER_USER -p $DOCKER_PASS
if [ "$TRAVIS_BRANCH" = "master" ]; then
    TAG="latest"
else
    TAG="$TRAVIS_BRANCH"
fi
docker build -f Dockerfile -t $TRAVIS_REPO_SLUG:$TAG -t $TRAVIS_REPO_SLUG:$TRAVIS_JOB_ID .
docker push $TRAVIS_REPO_SLUG:$TAG