# base image elixer to start with
FROM elixir:1.4.4


# install hex package manager
RUN mix local.hex --force

# install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install node
RUN apt-get update && apt-get install -y \
    software-properties-common \
    npm
RUN npm install npm@latest -g

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

ENV MIX_ENV=prod
ENV PORT=4000

# install dependencies
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

# install node dependencies
#RUN npm install
RUN node node_modules/brunch/bin/brunch build --production

# run phoenix
RUN mix phoenix.digest
CMD mix phoenix.server

