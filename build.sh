#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

#Set git user
git config --global user.email "dan@haywood-associates.co.uk"
git config --global user.name "Travis"

#
# clone `master' branch of the repository 
# using encrypted GH_TOKEN for authentification
#
echo -e "Cloning master\n"
git clone -b master https://${GH_TOKEN}@github.com/danhaywood/danhaywood.github.io.git site

# should we zap everything before re-adding?
#pushd site
#git rm -rf *
#popd

echo -e "Building Jekyll site\n"
jekyll build -d site

pushd site

touch .nojekyll
rm build.sh

echo "branches:
  only:
  - jekyll
" > .travis.yml

echo -e "Committing site\n"
git add -A .

if [ -n "$(git status --porcelain)" ]; then 
  git commit -a -m "Travis build $TRAVIS_BUILD_NUMBER"
  git push --quiet origin master > /dev/null 2>&1
else 
  echo "... no changes to commit";
fi

popd
rm -rf site

