
begin
  require 'sqlite3'
  require 'passant/rules_engine'
  require 'passant/data/data_store'
  require 'passant/data/extensions'
  
  Passant::LOGGER.info("Loaded data extensions (sqlite3).")
  
rescue LoadError => e
  Passant::LOGGER.warn("#{e.message}. Not loading data extensions.")

end
