class Post < ActiveRecord::Base

  belongs_to :user

  has_many :tagmaps
  has_many :tags, :through => :tagmaps

  has_many :receivers

  attr_accessible :body

  validates_presence_of :body


  def self.create_post(body, jid)
    ## Method ONLY for creating posts.
    ## Check that user registered
    ## and post format is correct.

    user = User.find_by_jid(jid)
    return User.not_registered unless user

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


  def self.formatted_post?(number)
    number.kind_of?(String) && number =~ /^#\d+$/
  end


  def self.read_post(number, jid)
    ## Check that user registered.
    ## Parse post number,
    ## check that user is receiver
    ## and send post if true.

    user = User.find_by_jid(jid)
    return User.not_registered unless user

    return 'Usage: #12345' unless Post.formatted_post?(number)

    post = Post.find_by_id(number[1..-1])
    return 'Post not found.' unless post 

    Receiver.can_read?(user, post) ? post.to_message : 'You aren\'t allowed to read this post.'
  end


  def to_message
    body = "@#{self.user.nick} (##{self.id}): "

    body += self.tags.map { |tag| "*#{tag.name}" }.join(' ')
    body += "\n" unless tags.empty?

    body + self.body
  end

end
