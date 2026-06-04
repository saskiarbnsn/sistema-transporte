#!/usr/bin/env bash
set -o errexit

bundle install
yarn install --frozen-lockfile
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails runner "ActiveRecord::Base.connection.execute('DROP SCHEMA public CASCADE; CREATE SCHEMA public;')"
bundle exec rails db:schema:load
bundle exec rails db:seed
