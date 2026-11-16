# frozen_string_literal: true

=begin

  aromancer_plugin.rb

  aro dom aromancer plugin

  by i2097i

=end

module Aro
  module Dom
    class AromancerPlugin

      EXCLUDE_KEYS = [
        "last_error"
      ]
      def self.oss_om_start!(plugin_data = {})
        Aro::P.less(:aromancer_plugin_starting)

        aromancer_installed = system("#{:which} -#{:s} #{:aromancer}")
        Aro::P.say("aromancer_installed: #{aromancer_installed}")
        raise "aromancer not installed!" unless aromancer_installed

        aromancer_thread = Thread.new{
          require :aromancer.to_s
          begin
            return Aromancer::Cli.run(:plugin_mode)
          rescue StandardError => e
            Aromancer::Prompt.say("aromancer thread threw an error: #{e}")
            raise e
          end
        }

        begin
          Aro::P.say("aromancer_thread.join")
          aromancer_thread.join
        rescue StandardError => e
          Aro::P.less(e.inspect)
          Aro::P.say("#{e}")
        end

        require :aromancer.to_s
        game_state = Aromancer::Storage.instance.dump_game_state.stringify_keys
        game_state["plugin_file_path"] = plugin_data["plugin_file_path"]
        game_state["oss_om_type"] = plugin_data["oss_om_type"]
        return game_state.except(*Aro::Dom::AromancerPlugin::EXCLUDE_KEYS)
      end
    end
  end
end

