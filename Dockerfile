FROM fpco/stack-build:lts-9.10

########################
# System Deps

RUN apt-get update
RUN apt-get upgrade -y --assume-yes
# Install packages needed for libraries used by our app.
RUN apt-get install -y --assume-yes libpq-dev g++

# Remove apt caches to reduce the size of our container.
# RUN rm -rf /var/lib/apt/lists/*

########################
# Project Deps

ENV STACK_ROOT /box

RUN mkdir -p /app
WORKDIR /app
COPY . $WORKDIR

CMD bin/build
