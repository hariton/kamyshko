class Project < ActiveRecord::Base
  belongs_to :user
  has_one :search_query, :as => :searcher

  has_many :project_pages
  has_many :pages, :through => :project_pages, :order => :position
end
