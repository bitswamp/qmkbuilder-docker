#!/bin/bash

# from the qmkbuilder readme:
# Create a local.json file in src/const, in the format:
# {
#   "API": "URL to server /build route",
#   "PRESETS": "URL to static/presets folder"
# }

# use the variables in .env to populate the config file
echo "{ \"API\": \"http://${QMKBUILDER_HOSTNAME:-localhost}:${QMKBUILDER_BUILDER_PORT_CONFIG:-5004}/build\", \"PRESETS\": \"http://${QMKBUILDER_HOSTNAME:-localhost}:${QMKBUILDER_UI_PORT_CONFIG:-8080}/presets/\" }" > /qmkbuilder/src/const/local.json

# print it to make sure it looks okay
cat /qmkbuilder/src/const/local.json | xargs -0 node -e "console.log(JSON.stringify(JSON.parse(process.argv[1]), null, 2))"
