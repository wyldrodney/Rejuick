class Subscription < ActiveRecord::Base
  attr_accessible :confirm, :reader, :writer

  validates_presence_of :reader, :writer
 

  def self.find_pair(reader_id, writer_id)
    pair = where(reader: reader_id, writer: writer_id)

    pair.empty? ? nil : pair.first
  end

  def self.subscribe(reader_id, writer_id, confirmation)
    msg = 'Wait for user add you to whitelist.'

    pair = find_pair(reader_id, writer_id)

    if pair
      ## If subscription presens

      msg = 'Already subscribed!' if pair.confirm
    else
      ## If subscription call first time
      ## then create one
      ## Using writer's `confirm` attr setting
      ## to set whitelist confirmation option

      create(reader: reader_id, writer: writer_id, confirm: confirmation)

      msg = 'Subscribed!' if confirmation
    end

    msg
  end

  def self.whitelist(writer_id, reader_id, confirmation)
    if confirmation
      ## If writer's attr is {confirm: true}
      ## then subs are confirmed by default

      'Whitelist is disabled. Everyone can subscribe to you.'
    else
      ## Else find subscription and change it

      pair = find_pair(reader_id, writer_id)

      if pair.confirm
        pair.update_attributes(confirm: false)
        'User removed from whitelist.'
      else
        pair.update_attributes(confirm: true)
        'User added to whitelist.'
      end
    end
  end

  def self.readers(writer_id)
    select(:reader).where(writer: writer_id, confirm: true)
  end

  def self.writers(reader_id)
    select(:writer).where(reader: reader_id, confirm: true)
  end

  def self.friends(id)
    writers(id).map { |w| w.writer } & readers(id).map { |r| r.reader }
  end

end
