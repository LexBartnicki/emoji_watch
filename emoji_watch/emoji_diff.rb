# frozen_string_literal: true

class EmojiDiff
  def self.call(*args)
    new(*args).call
  end

  def initialize(todays_emojis:, yesterdays_emojis:)
    @todays_emojis = todays_emojis
    @yesterdays_emojis = yesterdays_emojis
  end

  def call
    {
      created: new_emojis,
      deleted: missing_emojis
    }
  end

  private

  def new_emojis
    return todays_emojis if yesterdays_emojis.blank?
    todays_emojis - yeseterdays_emojis
  end

  def deleted_emojis
    return [] if todays_emojis.blank?
    yesterdays_emojis - todays_emojis
  end
end
