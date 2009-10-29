
begin
  require 'sqlite3'
  require 'passant/rules_engine'
  require 'passant/data/data_store'
  require 'passant/data/extensions'
  puts "Loaded data extensions (sqlite3)."
rescue LoadError => e
  puts "#{e.message}. Not loading data extensions."
end
