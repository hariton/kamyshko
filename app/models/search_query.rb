class SearchQuery < ActiveRecord::Base
  belongs_to :searcher, :polymorphic => true
end
