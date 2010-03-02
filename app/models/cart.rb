class Cart < ActiveRecord::Base
  belongs_to :collector, :polymorphic => true

  has_many :cart_pages
  has_many :pages, :through => :cart_pages, :order => :position

  def zipfile_url
    return nil unless self.zipfile_name
    "/zip/#{zipfile_name}"
  end

  def zipfile_path
    return nil unless self.zipfile_name
    Rails.root.join(USER_ZIP_FILE_DIR, zipfile_name).to_s
  end

  def zipfile_name
    return nil unless self.collector_type == 'User'
    'cart_' + self.collector.login + '_' + self.collector.single_access_token + '.zip'
  end

  def add_page(page)
    self.pages << page
    Zip::ZipFile.open(zipfile_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open(page.human_file_name, 'w'){|f| f.write(page.image_path.read)}
    end
    File.chmod(0664, zipfile_path);
  end

  def remove_page(page)
    cart_page = self.cart_pages.find_by_page_id(page)
    cart_page.destroy
    Zip::ZipFile.open(zipfile_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.delete(page.human_file_name) if zipfile.file.exist? page.human_file_name
    end
    File.chmod(0664, zipfile_path);
  end

  def empty
    self.pages.clear
    FileUtils.remove_file zipfile_path if File.exist? zipfile_path
  end

end
