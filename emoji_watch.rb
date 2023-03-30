#!/usr/bin/env ruby

require 'optparse'
require 'slack-client-ruby'
require_relative 'emoji_watch'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

cli_options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: emoji_watch.rb --channels test-channel,other-channel"

  opts.on('-C', '--channels CHANNELS', 'Slack Channels') do |channels|
    options[:channels] = channels&.split(',')&.map { |channel| "##{channel}" }
  end
end.parse!

abort('Must Specify Channels. See --help for usage.') if options[:channels].blank?

watcher = Watcher.new(client: Slack::Web::Client.new, channels: options[:channels])
watcher.take_oath
watcher.report_watch
watcher.end_watch
exit
