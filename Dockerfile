#
#     docker build -t branch14/phlegethon .
#     docker run branch14/phlegethon
#
FROM ruby:2.1

MAINTAINER phil@branch14.org

ADD . /phlegethon

RUN apt-get -y update \
    && apt-get install libssl-dev \
    && (cd phlegethon && bundle install)

WORKDIR /phlegethon/bin

CMD ./phlegethon run -h rabbitmq
