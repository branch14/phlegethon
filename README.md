           _     _                 _   _
     _ __ | |__ | | ___  __ _  ___| |_| |__   ___  _ __
    | '_ \| '_ \| |/ _ \/ _` |/ _ \ __| '_ \ / _ \| '_ \
    | |_) | | | | |  __/ (_| |  __/ |_| | | | (_) | | | |
    | .__/|_| |_|_|\___|\__, |\___|\__|_| |_|\___/|_| |_|
    |_|                 |___/

Welcome to phlegethon
=====================

Phlegethon is a generic endpoint for Webhooks which forwards all
requests to [RabbitMQ](https://www.rabbitmq.com/).

## Installation

Add this line to your application's Gemfile:

    gem 'phlegethon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phlegethon

## Usage

Simply run

    phlegethon

It will look for a config file in the following places

    ./phlegethon.yml
    ~/.phlegethon.yml

## Configuration

A phlegethon config file may look like this; these are the defaults

    rabbitmq:
      exchange: webhooks
      host: localhost
    server:
      port: 3002
      ssl: false


With the above config you can test you endpoint with curl

    curl -d '{"hey":"ho"}' -H 'Content-type: application/json' http://localhost:3002

## Prerequisites

To use phlegethon with https you have to have `libssl-dev` installed
before installing eventmachine.

    apt-get install libssl-dev
    gem install eventmachine

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Trivia

In Greek mythology, the river Phlegethon (Φλεγέθων, English
translation: "flaming") or Pyriphlegethon (Πυριφλεγέθων, English
translation: "fire-flaming") was one of the five rivers in the
infernal regions of the underworld, along with the rivers Styx, Lethe,
Cocytus, and Acheron. Plato describes it as "a stream of fire, which
coils round the earth and flows into the depths of Tartarus". It
was parallel to the river Styx. It is said that the goddess Styx was
in love with Phlegethon, but she was consumed by his flames and sent
to Hades. Eventually when Hades allowed her river to flow through,
they reunited. [Wikipedia](https://en.wikipedia.org/wiki/Phlegethon)
