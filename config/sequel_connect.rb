require 'sequel'

db_uri ||= ENV['DB_URI'] ||
    'postgres://127.0.0.1:5432/postgres?user=postgres'

DB = Sequel.connect(db_uri, max_connections: 10)

