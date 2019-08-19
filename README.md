# qmkbuilder-docker

Quickly set up a local copy of https://kbfirmware.com using Docker and docker-compose.

## I want to run the QMK builder locally on my computer

* Install [Docker](https://www.docker.com/get-started)
* Download this repo or clone it with git
```
git clone https://github.com/bitswamp/qmkbuilder-docker
```
* Navigate to the repo and start the containers with docker-compose
```
cd qmkbuilder-docker
docker-compose up
```

Now the QMK builder should be accessible at http://localhost:8080/

To check everything works OK:

* Select the GH60 preset
* Go to the "compile" tab
* Click "Download .hex"

If you get an error, make sure:

* The docker hello-world example runs successfully
* You don't have other programs running on port 8080 or 5004
* Docker is configured to use linux containers, not windows containers

`docker-compose up` will show the container output in the console. Pressing Ctrl+C will stop the QMK builder containers and return you to the prompt. To start the containers quietly in the background, use `docker-compose up -d`, and to stop them later, run `docker-compose down`.

### I have something running on port 8080 or 5004. I want to run the QMK builder on different ports.

Edit the `.env` file and adjust both `PORT_DOCKER` and `PORT_CONFIG` for the given service to a different value. I often put things on ports 8010, 8020, etc. Then run `docker-compose up --build` to recreate the containers with the new config.

If you adjust the `BUILDER` ports, the address in your browser won't change, but if you change the `UI` ports, the site will appear at http://localhost:your_chosen_port instead of 8080.

## I want to make the QMK builder available at example.com

* Setup [Docker](https://www.docker.com/get-started) and clone the repo as described above
* Edit the `.env` file in the project root and set `QMKBUILDER_HOSTNAME=example.com`
* Adjust the `PORT` values in the `.env` file as appropriate.
* Start the containers
```
cd qmkbuilder-docker
docker-compose up
```

### What port values should I use?

There are two sets of port values to consider. The `PORT_DOCKER` values determine which ports are bound on the docker host (allows traffic to/from the containers from outside). The `PORT_CONFIG` values are used to generate urls in the web UI.

Most websites with multiple services running under one url will listen on port 80 (insecure) or port 443 (https), and use [nginx](https://nginx.org/en/) (or similar) to route requests based on a set of rules. In this case, set ports like:

```
QMKBUILDER_HOSTNAME=example.com
QMKBUILDER_BUILDER_PORT_CONFIG=80
QMKBUILDER_BUILDER_PORT_DOCKER=5004
QMKBUILDER_UI_PORT_CONFIG=80
QMKBUILDER_UI_PORT_DOCKER=8080
```

Then configure your routing rules so http://example.com/build is routed to localhost:5004, and all other qmk builder urls are routed to localhost:8080.

## I want to edit qmkbuilder and run my own source

* Create a fork of https://github.com/ruiqimao/qmkbuilder
* Make your code changes
* Edit `Dockerfile` so it clones your repo instead of the original
* `docker-compose up --build`
