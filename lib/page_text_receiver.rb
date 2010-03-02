# не используется сейчас, т.к. мы отказались от извлечения текста из pdf'а
class PageTextReceiver 
  attr_accessor :content

  def initialize
    @content = []
  end

  def begin_page(arg = nil)
    @content << ''
  end

  def show_text(string, *params)
    @content.last << string.strip
  end

  alias :super_show_text :show_text
  alias :move_to_next_line_and_show_text :show_text
  alias :set_spacing_next_line_show_text :show_text

  def show_text_with_positioning(*params)
    params = params.first
    params.each { |str| show_text(str) if str.kind_of?(String) }
  end

end
