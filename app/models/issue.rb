# encoding: utf-8

require 'core_extensions'
require 'load_issue_job'

class Issue < ActiveRecord::Base
  belongs_to :source
  has_many :pages, :order => :number

  after_save :save_files
  after_update :update_dirnames
  after_destroy :cleanup

  validates_numericality_of :number, :only_integer => true, :message => 'Укажите номер выпуска!'
  validates_uniqueness_of :number, :scope => [:source_id, :date], :message => 'Выпуск за такую дату с тем же номером уже существует. Укажите правильный номер выпуска!'
  # validates_acceptance_of :pdf_file, :message => 'Разрешена загрузка только PDF-файлов!'

  named_scope :active, :conditions => { :active => true }

  def files_dir_name(number = self.number, date = self.date)
    sprintf('%03d_%s', number, date)
  end

  def files_dir_path(number = self.number, date = self.date)
    File.join( self.source.files_dir_path, files_dir_name( number, date ) )
  end

  def pdf_file=(pdf_file)
    if pdf_file and pdf_file.content_type.chomp == 'application/pdf'
      @pdf_file = pdf_file
    end
  end

  def pdf_file
    @pdf_file
  end

  def pdf_path
    file_name = self.source.files_dir_name + '.pdf'
    File.join( files_dir_path, file_name)
  end

  def txt_file=( txt_file )
    if txt_file and txt_file.content_type.chomp == 'text/plain'
      @txt_file = txt_file
    end
  end

  def txt_file
    @txt_file
  end

  def txt_path
    file_name = self.source.files_dir_name + '.txt'
    File.join( files_dir_path, file_name)
  end

  def save_files

    if not @pdf_file
      logger.debug "Absent @pdf_file"
    elsif not @txt_file
      logger.debug "Absent @txt_file"
    else
      cleanup
      files_dir_make
      save_pdf
      save_text
      Delayed::Job.enqueue(LoadIssueJob.new(self))
    end

  end

  def load_text

    encoding = `/usr/bin/file --brief '#{self.txt_path}'`
    encoding.chomp!

    raise "File '#{self.txt_path}'. Bad encoding - '#{encoding}'" if encoding !~ /utf-8/i

    lines = File.open(self.txt_path, 'r').readlines

    pages = lines.join.gsub(/\x0c/, " \x0c").split(/\x0c/)

    raise "File '#{self.txt_path}'. Text without page-dividers" if pages.size == 1

    pages.each_with_index do |page, index|
      page_number = index + 1
      self.pages.create :number => page_number, :text => page
    end

    self.save!

    LOADER_LOGGER.info{"TXT-file successfully loaded to DB: '#{self.txt_path}'"}

  end

  def extract_images

    dir_images_big = File.join( self.files_dir_path, 'images/big' )
    dir_images_medium = File.join( self.files_dir_path, 'images/medium' )
    dir_images_small = File.join( self.files_dir_path, 'images/small' )

    FileUtils.mkdir_p( dir_images_big ) unless File.directory?( dir_images_big )
    FileUtils.mkdir_p( dir_images_medium ) unless File.directory?( dir_images_medium )
    FileUtils.mkdir_p( dir_images_small ) unless File.directory?( dir_images_small )

    pdfimages_tmpdir = File.join( Dir.tmpdir, 'pdfimages')
    pdfimages_image_root = 'pic'

    FileUtils.rm_rf(pdfimages_tmpdir) if File.exists?(pdfimages_tmpdir)
    FileUtils.mkdir_p(pdfimages_tmpdir)

    stdout = `/usr/bin/pdfimages -q -j "#{self.pdf_path}" "#{File.join(pdfimages_tmpdir, pdfimages_image_root)}"`
    raise "File '#{self.pdf_path}'. Extracting images error" if $?.exitstatus != 0

    images = Dir.glob( File.join(pdfimages_tmpdir, pdfimages_image_root + '*.jpg') )

    raise "Files '#{self.pdf_path}' and '#{self.txt_path}'. Differs pages number (#{self.pages.size}) and images number(#{images.size})" if self.pages.size != images.size

    images.each do |image_path|

      image_fn = File.basename(image_path)

      page_number = image_fn.gsub(/[^\d]/, '').to_i + 1 # в имени файла оставляем только цифры, нумерацию начинаем с 1 (как нумеруются страницы)

      page = self.pages.find_by_number(page_number)
      raise "Files '#{self.pdf_path}' and '#{self.txt_path}'. Cannot find page number #{page_number} for issue" unless page

      target_fn = page.file_name

      FileUtils.cp(image_path, File.join(dir_images_big, target_fn))

      image = MiniMagick::Image.from_file(image_path)
      image.resize '685x1000>'
      image.write(path_images_medium)

      image.resize '95x160>'
      image.write(path_images_small)

    end

    LOADER_LOGGER.info{"Images successfully extracted from: '#{self.pdf_path}'"}

  end

  private

  def cleanup
    FileUtils.rmtree( files_dir_path ) if File.directory?( files_dir_path )
  end

  def files_dir_make
    begin
      FileUtils.mkdir_p( files_dir_path ) unless File.directory?( files_dir_path )
    rescue Exception => e
      LOADER_LOGGER.error{"Cannot create dir '#{files_dir_path}': #{e.message}"}
    end
  end

  def save_pdf
    begin
      File.open(self.pdf_path, 'wb') { |f| f.write( @pdf_file.read ) }
      @pdf_file = nil
      LOADER_LOGGER.info{"PDF-file successfully saved: '#{self.pdf_path}'"}
    rescue Exception => e
      LOADER_LOGGER.error{"Cannot save file '#{self.pdf_path}': #{e.message}"}
    end
  end

  def save_text
    begin
      File.open(self.txt_path, 'wb') { |f| f.write( @txt_file.read ) }
      @txt_file = nil
      LOADER_LOGGER.info{"TXT-file successfully saved: '#{self.txt_path}'"}
    rescue Exception => e
      LOADER_LOGGER.error{"Cannot save file '#{txt_path}': #{e.message}"}
    end
  end

  def update_dirnames

    if (self.number_changed? or self.date_changed?) and files_dir_path
      begin
        old_files_dir_path = files_dir_path(self.number_was || self.number, self.date_was || self.date)
        FileUtils.mv old_files_dir_path, files_dir_path if old_files_dir_path != files_dir_path
      rescue Exception => e
        LOADER_LOGGER.error{"Cannot move dir '#{old_files_dir_path}' to '#{files_dir_path}': #{e.message}"}
      end
    end

  end

end
