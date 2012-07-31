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

    tags = Tag.clear_privacy_tags(result[0])

    Tagmap.perform_tagmaps(Tag.perform_tags(tags), post)

    Receiver.perform_receivers(post, user, Tag.get_privacy_level(tags))

    "Post ##{post.id} saved!"
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


  def to_message
    body = "##{self.id}\n"
    body += "@#{self.user.nick}: "

    body += self.tags.map { |tag| "*#{tag.name}" }.join(' ')
    body += "\n" unless tags.empty?

    body + self.body
  end

end
