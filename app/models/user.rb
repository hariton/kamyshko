class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_one :search_query, :as => :searcher
  has_one :cart, :as => :collector
  has_many :projects
  acts_as_authentic do | options |
    options.merge_validates_length_of_email_field_options :allow_nil => true
    options.merge_validates_format_of_email_field_options :allow_nil => true
  end
  has_gravatar

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

end
