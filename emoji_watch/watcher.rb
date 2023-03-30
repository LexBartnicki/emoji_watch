# frozen_string_literal: true

require_relative 'emoji_diff'

class Watcher
  EMOJI_CACHE_PATH = 'emojis_cache.txt'

  def initialize(client:, channels:)
    @client = client
    @channels = channels
  end

  def take_oath
    client.auth_test
  end

  def report_watch
    diff = EmojiDiff.call(todays_emojis: todays_emojis, yesterdays_emojis: yesterdays_emojis)
    message = EmojiMessage.new(**diff)
    channels.each do |channel|
      client.chat_postMessage(channel: channel, text: message.header)
      client.chat_postMessage(channel: channel, text: message.created)
      client.chat_postMessage(channel: channel, text: message.deleted)
      client.chat_postMessage(channel: channel, text: message.preview_created)
    end
  end

  def end_watch
    File.write(EMOJI_CACHE_PATH, JSON.dump({}))
    File.write(EMOJI_CACHE_PATH, JSON.dump(todays_emojis))
  end

  private

  attr_reader :client, :channels

  def todays_emojis
    client.emoji_list['emoji']
  end

  def yesterdays_emojis
    file = File.read(EMOJI_CACHE_PATH)
    emojis = JSON.parse(file) if file
    emojis || {}
  end
end
