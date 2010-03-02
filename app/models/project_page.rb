class ProjectPage < ActiveRecord::Base
  belongs_to :project
  belongs_to :page
  acts_as_list :scope => :project
  default_scope :order => :position

end
