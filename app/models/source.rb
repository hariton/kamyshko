class Source < ActiveRecord::Base
  has_many :issues

  after_create :files_dir_make
  after_update :files_dir_move
  after_destroy :files_dir_remove

  validates_presence_of :title, :message => 'Укажите название источника'
  validates_uniqueness_of :title, :message => 'Источник с таким названием уже существует. Укажите правильное название источника'

  def issue_first
    self.issues.active.first(:order => :date)
  end

  def issue_last
    self.issues.active.last(:order => :date)
  end

  def issue_last_updated
    self.issues.active.last(:order => :updated_at)
  end

  # может быть это правильнее сделать атрибутом?
  def files_dir_path(title = self.title)
    Rails.root.join(SOURCE_BASE_FILES_DIR, files_dir_name(title))
  end

  def files_dir_name(title = self.title)
    Russian::transliterate(title).downcase.squeeze.strip.gsub(/ /, '_').gsub(/\//, '-').gsub(/["']/, '')
  end

  private

  def files_dir_make
    begin
      FileUtils.mkdir_p( files_dir_path ) unless File.directory?( files_dir_path )
    rescue Exception => e
      logger.warn{"Cannot create dir #{files_dir_path}: #{e.message}"}
    end
  end

  def files_dir_move

    if self.title_changed? and files_dir_path
      begin
        old_files_dir_path = files_dir_path(self.title_was)
        FileUtils.mv old_files_dir_path, files_dir_path if old_files_dir_path != files_dir_path
      rescue Exception => e
        logger.error{"Cannot move dir '#{old_files_dir_path}' to '#{files_dir_path}': #{e.message}"}
      end
    end

  end

  def files_dir_remove
    begin
      FileUtils.rmtree( files_dir_path ) if File.directory?( files_dir_path )
    rescue Exception => e
      logger.warn{"Cannot remove dir #{files_dir_path}: #{e.message}"}
    end
  end

end
