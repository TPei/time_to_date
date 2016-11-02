#!/usr/bin/env rake

begin
  require 'rubygems'
  require 'bundler'
  require 'rspec/core/rake_task'
  require 'dotenv'
  require 'sequel'
  RSpec::Core::RakeTask.new(:spec)
  Bundler.require
rescue LoadError
  puts 'You must `gem install bundler`
  and run `bundle install` to run rake tasks'
end

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_t, args|
    require 'dotenv'
    Dotenv.load

    require 'sequel'
    Sequel.extension :migration

    db_uri = ENV['DB_URI'] ||
      'postgres://127.0.0.1:5432/postgres?user=postgres'

    db = Sequel.connect(db_uri)
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, 'db/migrations', target: args[:version].to_i)
    else
      puts 'Migrating to latest'
      Sequel::Migrator.run(db, 'db/migrations')
    end
    puts 'all done'
  end

  desc 'Perform a migration reset (full rollback and migration)'
  task :reset do
    Dotenv.load
    Sequel.extension :migration

    db_uri = ENV['RDS_DB_URI'] ||
      'postgres://127.0.0.1:5432/postgres?user=postgres'

    db = Sequel.connect(db_uri)
    puts 'Performing rollback...'
    Sequel::Migrator.run(db, 'db/migrations', target: 0)

    puts 'Migrating to latest to database version...'
    Sequel::Migrator.run(db, 'db/migrations')
    puts 'all done'
  end

  desc 'Rollback database'
  task :rollback do
    Dotenv.load
    Sequel.extension :migration

    db_uri = ENV['RDS_DB_URI'] ||
      'postgres://127.0.0.1:5432/postgres?user=postgres'

    db = Sequel.connect(db_uri)
    puts 'Performing rollback...'
    Sequel::Migrator.run(db, 'db/migrations', target: 0)
    puts 'all done'
  end
end
