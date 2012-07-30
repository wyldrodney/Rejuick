class Tag < ActiveRecord::Base

  has_many :tagmaps
  has_many :posts, :through => :tagmaps

  attr_accessible :name

  validates_presence_of :name


  def self.create_tags(tags)
    ids = tags.map do |name|
      tag = Tag.find_by_name(name)

      tag ? tag.id : Tag.create(name: name).id
    end

    ids.uniq
  end

end
