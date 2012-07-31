class Tag < ActiveRecord::Base

  has_many :tagmaps
  has_many :posts, :through => :tagmaps

  attr_accessible :name

  validates_presence_of :name


  def self.perform_tags(tags)
    ## Add new tags. For both new and old return their ids.

    ids = tags.map do |name|
      tag = Tag.find_by_name(name)

      tag ? tag.id : Tag.create(name: name).id
    end

    ids.uniq
  end


  def self.clear_privacy_tags(tags)
    ## Search all privacy tags and leave the last.

    deleted = []

    tags.each do |tag|
      if %w(all public readers private).include?(tag)
        ind = tags.index(tag)
        deleted << tags.delete_at(ind)
      end
    end

    deleted.empty? ? tags : [deleted.last] + tags
  end


  def self.get_privacy_level(tags)
    ## Search privacy tag. Default is public.

    if %w(all public readers private).include?(tags[0])
      tags[0]
    else
      'public'
    end
  end

end
