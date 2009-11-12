module Passant
  
  class CompositeEvaluator

    def initialize(board, *evaluator_classes)
      @board = board
      @evaluators = evaluator_classes.flatten.map{|klass| klass.new(@board)}
    end
    
    def value
      val = {:white => 0, :black => 0}
      @evaluators.each do |e|
        e_val = e.value
        val[:white] += e_val[:white]
        val[:black] += e_val[:black]
      end
      val
    end

    def value_str
      str = ''
      @evaluators.each{|e| str += (e.value_str + "\n")}
      str
    end
    
  end
end