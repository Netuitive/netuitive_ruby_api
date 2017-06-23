FROM ruby:2.2

RUN mkdir /opt/app
WORKDIR /opt/app

COPY Gemfile* /opt/app/

RUN bundle install

COPY . /opt/app
RUN mkdir /opt/app/log

RUN rake test
RUN rubocop

CMD gem build netuitive_ruby_api.gemspec
