class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  named_scope :named, lambda { |name| { :conditions => ["name = ?", name.strip ] } }
  named_scope :named_like, lambda { |name| { :conditions => ["name LIKE ?", "%#{name.strip}%"] } }
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end
  
  def self.to_fixture
    write_file(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT),
     self.find(:all).inject("---\n") { |s, record|
       self.columns.inject(s+"#{record.id}:\n") { |s, c|
         s+"  #{{c.name => record.attributes[c.name]}.to_yaml[5..-1]}\n" }
    })
  end
end
