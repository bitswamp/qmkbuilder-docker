FROM node:12-slim

# install qmk dependencies
# (copied from https://github.com/qmk/qmk_firmware/blob/master/util/linux_install.sh)
RUN apt update
RUN apt -yq install \
	build-essential \
	avr-libc \
	binutils-arm-none-eabi \
	binutils-avr \
	dfu-programmer \
	dfu-util \
    diffutils \
	gcc \
	gcc-arm-none-eabi \
	gcc-avr \
	git \
	libnewlib-arm-none-eabi \
	python3 \
	unzip \
	wget \
	zip

# clone the qmkbuilder project
# (alternate url https://github.com/bitswamp-projects/qmkbuilder)
RUN git clone https://github.com/ruiqimao/qmkbuilder /qmkbuilder

WORKDIR /qmkbuilder

# install qmkbuilder dependencies
RUN npm install

# create the local.json config file as per qmkbuilder readme
COPY setup_config.sh /qmkbuilder/setup_config.sh
RUN chmod +x /qmkbuilder/setup_config.sh
RUN bash /qmkbuilder/setup_config.sh

# build the qmkbuilder react app
RUN npm run deploy

# start the builder process
# (while the same dockerfile is used for the ui container, it  
# overrides the start command in docker-compose.yml)
WORKDIR /qmkbuilder/server
CMD node index.js
