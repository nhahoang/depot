FROM ruby:2.3.1

WORKDIR /app

COPY Gemfile* ./

COPY package.json ./

COPY yarn.lock ./

RUN apt-get update -qq && \
  apt-get install -y \
  apt-transport-https \
  apt-utils \
  build-essential \
  nodejs \
  libmysqlclient-dev \
  imagemagick \
  vim nano \
  node \
  cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn --no-install-recommends -y

RUN \
  gem update --system --quiet && \
  gem install bundler -v '~> 2.2.15'
ENV BUNDLER_VERSION 2.2.15

RUN bundle install -j 20 -r 5

COPY docker/*.sh /scripts/

RUN chmod a+x /scripts/*.sh