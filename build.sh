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

echo -e "Building Jekyll site\n"
jekyll build -d site

cd site

touch .nojekyll
rm build.sh


echo -e "Committing site\n"
git commit -a -m "Travis build $TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1

cd ..
rm -rf site

