module Dradis
  module Plugins
    module Metasploit
    end
  end
end

require 'dradis/plugins/metasploit/engine'
require 'dradis/plugins/metasploit/field_processor'
require 'dradis/plugins/metasploit/importer'
require 'dradis/plugins/metasploit/importers/version5'
require 'dradis/plugins/metasploit/version'

# This is required while we transition the Upload Manager to use
# Dradis::Plugins only
module Dradis
  module Plugins
    module Metasploit
      module Meta
        NAME = "Metasploit Framework database dump (XML)"
        EXPECTS = "Expects Metasploit XML, use: db_export"

        module VERSION
          include Dradis::Plugins::Metasploit::VERSION
        end
      end
    end
  end
end
