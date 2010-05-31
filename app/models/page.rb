# encoding: utf-8

require 'digest/md5'

class Page < ActiveRecord::Base
  belongs_to :issue

  has_many :cart_pages
  has_many :cart, :through => :cart_pages, :order => :position

  has_many :project_pages
  has_many :projects, :through => :project_pages, :order => :position

  acts_as_list :scope => :issue, :order => :number, :column => :number
  default_scope :order => :number

  before_save :generate_digest

  define_index do

    # fields
    indexes text
    indexes number

    # attributes
    has issue(:date), :as => :date
    has issue.source(:id), :as => :source_id

    # settings
    set_property :delta => :delayed

  end

  def excerpts( search_query, limit = 1500 )

    index = 'page_core'
    words_list = riddle_client.keywords(search_query, index).collect{|w| w[:normalised]}.join(' ')

    riddle_client.excerpts(
      :docs         => [ self.text ],
      :before_match => '<span class="match">',
      :after_match  => '</span>',
      :words        => words_list,
      :around       => 25,
      :index        => index,
      :limit        => limit
    ).first

  end

  def file_name
    sprintf('%03d%s.jpg', self.number, self.digest)
  end

  def human_file_name
    sprintf('%s_%03d_%s_%03d.jpg', self.issue.source.files_dir_name, self.issue.number, self.issue.date, self.number)
  end

  def image_url(image_type = 'big')
    "/sources/#{self.issue.source.files_dir_name}/#{self.issue.files_dir_name}/images/#{image_type}/#{self.file_name}"
  end

  def image_path(image_type = 'big')
    Rails.root.join(SOURCE_BASE_FILES_DIR, "#{self.issue.source.files_dir_name}/#{self.issue.files_dir_name}/images/#{image_type}/#{self.file_name}")
  end

  def source_string
    "#{self.issue.source.title}, №#{self.issue.number}, #{::Russian::strftime(self.issue.date)}, стр. #{self.number}"
  end

  alias prev higher_item
  alias next lower_item

  private

  def generate_digest
    self.digest = Digest::MD5.hexdigest((self.number + rand(255)).to_s)
  end

  def riddle_client
    return @riddle_client if defined?(@riddle_client)
    begin
      ts_config = ThinkingSphinx::Configuration.instance
      @riddle_client = Riddle::Client.new ts_config.address, ts_config.port
    rescue
      nil
    end
  end

end
