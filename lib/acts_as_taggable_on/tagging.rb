class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  belongs_to :tagger, :polymorphic => true
  validates_presence_of :context
  
  # def self.find_matching_contexts(tags_to_find, search_context, result_context)
  #   
  # end
  
end