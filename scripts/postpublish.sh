#!/bin/bash -e

get_property() {
  echo $(node -p "p=require('./${1}').${2};")
}

echo "Getting version number from package.json"
version="$(get_property 'package.json' 'version')"

echo "(Re)Creating bookshelf-source remote"
git remote remove bookshelf-source || true
git remote add bookshelf-source git@github.com:bookshelf/bookshelf.git

echo "Regenerating documentation"
npm run jsdoc

echo "Committing new release version ($version) w/ any outstanding changes"
git commit -am "Release $version"

echo "Tagging version w/ number"
git tag $version

echo "Pushing commit and tags to source master"
git push bookshelf-source master
git push bookshelf-source master --tags
