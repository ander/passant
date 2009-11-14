
module Passant
  
  class DataStore
    DB_PATH = File.dirname(__FILE__)+'/board_data.db'
    
    FIELDS = ['string_rep', 'check_white', 'check_black', 'draw_white',
              'draw_black', 'checkmate_white', 'checkmate_black']
    
    CREATE_TABLE_SQL = \
      "CREATE TABLE boards (string_rep TEXT PRIMARY KEY, "+
      "check_white INTEGER, check_black INTEGER, draw_white INTEGER, "+
      "draw_black INTEGER, checkmate_white INTEGER, checkmate_black INTEGER)"

    attr_accessor :db
    
    def initialize
      @db = SQLite3::Database.new(DB_PATH)
      
      tables = db.execute('SELECT name FROM sqlite_master WHERE type = "table"')
      
      unless tables.flatten.include?('boards')
        puts "Creating db..."
        db.execute(CREATE_TABLE_SQL)
      else
        puts "Opened database with info on " +
             "#{@db.get_first_value('select count(*) from boards')} boards."
      end
    end

    def close
      puts "Closing db..."
      @db.close 
    end

    def check?(board, color)
      get_value(board, "check_#{color}")
    end

    def draw?(board, color)
      get_value(board, "draw_#{color}")
    end
    
    def checkmate?(board, color)
      get_value(board, "checkmate_#{color}")
    end
    
    def set_check(board, color, value)
      set_value(board, "check_#{color}", value)
    end

    def set_draw(board, color, value)
      set_value(board, "draw_#{color}", value)
    end
    
    def set_checkmate(board, color, value)
      set_value(board, "checkmate_#{color}", value)
    end
    
    private
    
    def get_value(board, field)
      val = @db.get_first_value("select #{field} from boards where string_rep='#{board}'")
      if val.nil?
        nil
      elsif val == '0'
        false
      else
        true
      end
    end

    def set_value(board, field, value)
      data = @db.execute("select * from boards where string_rep='#{board}'")
      
      if !data.empty?
        data.flatten!
        data[FIELDS.index(field)] = (value ? 1 : 0)
        data.delete_at(0)
        data.map!{|d| d.nil? ? 'NULL' : d}
        @db.query("update boards set check_white=?, check_black=?,"+
                  "draw_white=?, draw_black=?, checkmate_white=?,"+
                  "checkmate_black=? where string_rep='#{board}'", *data).close
                  
      else
        @db.query("insert into boards (string_rep, #{field}) values (?, ?)",
                  board.to_s, (value ? 1 : 0)).close
      end
    end

  end

end
