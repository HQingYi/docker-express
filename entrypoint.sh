#!/bin/bash
set -e

# Default values
: ${BRANCH:="master"}
: ${PORT:="3000"}

# If we were given arguments, run them instead
if [ $? -gt 1 ]; then
   exec "$@"
fi

mkdir -p /usr/src

if [ -n "${REPO}" ]; then
   if [ -e /usr/src/app/.git ]; then
      pushd /usr/src/app
      echo "Updating local repository..."
      git fetch
      popd
   else
      echo "Getting ${REPO}..."
      git clone ${REPO} /usr/src/app
   fi

   cd /usr/src/app

   echo "Switching to branch/tag ${BRANCH}..."
   git checkout ${BRANCH}

   echo "Forcing clean..."
   git reset --hard origin/${BRANCH}
   git clean -d -f
   pushd /usr/src/app

   echo "Execute project install: npm insatll..."
   npm install

   echo "Execute project build: grunt build-all..."
   ./node_modules/.bin/grunt build-all
fi

# Run meteor
cd /usr/src/.dist/
echo "Starting Meteor on ${PORT}..."
export NODE_ENV="production"
exec node ./server.js
