module Dradis::Plugins::Metasploit
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Metasploit

    include ::Dradis::Plugins::Base
    description 'Processes Metasploit XML output, use: db_export'
    provides :upload
  end
end
