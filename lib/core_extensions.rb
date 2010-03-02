require 'iconv'
require 'stringio'

class String

  def utf8_clean
    Iconv.open( 'UTF-8', 'UTF-8' ) do |iconv|
      output  = StringIO.new
      working = self.to_s
      loop do
        begin
          output.print iconv.iconv( working )
          break
        rescue Iconv::IllegalSequence => is
          output.print is.success
          working = is.failed[1..-1]
        end
      end
      return output.string
    end
  end

end

class Array

  def columnize(n_columns)
    columns = []

    remaining_size = self.size

    n_columns.times do |column_idx|
      column_size = (remaining_size.to_f / (n_columns - column_idx)).ceil
      break if column_size == 0
      columns << self.slice(self.size - remaining_size, column_size)
      remaining_size -= column_size
    end

    columns
  end

  # TODO отправить в тесты
  # class ColumnizeTest < Test::Unit::TestCase    
  #   def test_columnize_9
  #     assert_equal [[1,2,3],[4,5],[6,7],[8,9]], (1..9).to_a.columnize(4)
  #   end

  #   def test_columnize_10
  #     assert_equal [[1,2,3],[4,5,6],[7,8],[9,10]], (1..10).to_a.columnize(4)
  #   end
  # end

end
