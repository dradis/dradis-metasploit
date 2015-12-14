require_relative 'gem_version'

module Dradis
  module Plugins
    module Metasploit
      # Returns the version of the currently loaded Metasploit as a
      # <tt>Gem::Version</tt>.
      def self.version
        gem_version
      end
    end
  end
end
