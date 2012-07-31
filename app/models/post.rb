class Post < ActiveRecord::Base

  belongs_to :user

  has_many :tagmaps
  has_many :tags, :through => :tagmaps

  has_many :receivers

  attr_accessible :body

  validates_presence_of :body


  def self.create_post(body, jid)
    ## Method ONLY for creating posts.

    user = User.find_by_jid(jid)
    return 'You aren\'t registered. Type: nick.' unless user

    result = Post.get_tags_and_body(body)
    return 'Message body can\'t be empty.' unless result

    post = user.posts.create(body: result[1])

    tags = Post.clear_privacy_tags(result[0])

    Tag.perform_tags(tags).each do |tag_id|
      Tagmap.create(post_id: post.id, tag_id: tag_id)

      ## DO NOT check anything. We need checks on post modification.
    end


#    get_privacy_level(tags)
  end


  def self.get_tags_and_body(body)
    body = ' ' + body
    splitter = body.index(/\s+[^\*]/)

    return nil unless splitter

    tags = body[0...splitter].scan(/\s{1}\*{1}[a-z\u0430-\u044f\u0451\_\-]+/).map { |tag| tag.strip[1..-1] }

    ## Detect tags. Allowed: english, russain chars, minus and underline signs.

    body = body[splitter..-1].strip

    [tags, body]
  end


  def self.clear_privacy_tags(tags)
    ## Search all privacy tags and leave the last.

    deleted = []

    tags.each do |tag|
      if %w(all public readers friends private).include?(tag)
        ind = tags.index(tag)
        deleted << tags.delete_at(ind)
      end
    end

    deleted.empty? ? tags : [deleted.last] + tags
  end


  def self.get_privacy_level(tags)
    ## Search privacy tag. Default is public.

    if %w(all public readers friends private).include?(tags[0])
      tags[0]
    else
      'public'
    end
  end

end
