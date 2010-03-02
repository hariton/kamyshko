require 'tempfile'

=begin
  на основе actionpack/lib/action_controller/test_process.rb используется
  для имитации загруженных файлов через rake-задачу (без веб-интерфейса)

  также можно использовать для загрузки выпусков в seed и т.п.
=end

class UploadedFile
  attr_reader :original_filename
  attr_accessor :content_type

  def initialize(path, content_type = Mime::TEXT, binary = false)
    raise "#{path} file does not exist" unless File.exist?(path)
    @content_type = content_type
    @original_filename = path.sub(/^.*#{File::SEPARATOR}([^#{File::SEPARATOR}]+)$/) { $1 }
    @tempfile = Tempfile.new(@original_filename)
    @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)
    @tempfile.binmode if binary
    FileUtils.copy_file(path, @tempfile.path)
  end

  def path
    @tempfile.path
  end

  alias local_path path

  def method_missing(method_name, *args, &block)
    @tempfile.__send__(method_name, *args, &block)
  end

end
