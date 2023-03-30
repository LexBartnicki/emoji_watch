# frozen_string_literal: true

class EmojiMessage
  HEADER_EMOJI_BY_HYPE = {
    0..3 => ':eyes',
    4..5 => ':redeyes:',
    6..7 => ':derp_eyes:',
    8..9 => ':googley-eyes:'
  }.freeze
  HYPEST_HEADER_EMOJI = ':catjam:'

  def initialize(created:, deleted:)
    @created_emojis = created
    @deleted_emojis = deleted
  end

  def header
    "#{header_emoji} #{header_emoji} #{header_emoji} EMOJI WATCH UPDATE #{header_emoji} #{header_emoji} #{header_emoji}"
  end

  def deleted
    return "No emoji were deleted today.\n" if deleted_emojis.empty?

    "Deleted emoji: #{deleted_emojis.join(', ')}"
  end

  def created
    return "No emoji were added today.\n" if created_emojis.empty?

    "New emoji: #{created_emojis.join(', ')}"
  end

  def preview_created
    return if created_emojis.empty?

    created_emojis.map { ":#{_1}:" }.join(' ')
  end

  private

  attr_reader :created_emojis, :deleted_emojis

  def header_emoji
    @header_emoji ||= begin
      hype = created_emojis.size
      emoji = HEADER_EMOJI_BY_HYPE.find { _1.first.include?(hype) }&.last
      emoji || HYPEST_HEADER_EMOJI
    end
  end
end
