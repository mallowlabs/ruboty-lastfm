require 'open-uri'
require 'rss'

module Ruboty
  module Handlers
    class Lastfm < Base
      on /what am I playing/, name: "now_playing_from", description: "See what is current user playing"
      on /what(')?s (?<user>.+) playing/, name: "now_playing_with_user", description: "See what is specified user playing"

      def now_playing_with_user(message)
        now_playing(message, message[:user])
      end

      def now_playing_from(message)
        now_playing(message, message.from)
      end

      private

      def now_playing(message, user)
        begin
          rss = fetch("http://ws.audioscrobbler.com/2.0/user/#{user}/recenttracks.rss")
          message.reply("#{rss.items.first.title}\n#{rss.items.first.link}")
        rescue
          warn $!, $@
          message.reply("An error happened")
        end
      end

      def fetch(url)
        content = open(url).read
        RSS::Parser.parse(content)
      end

    end
  end
end
