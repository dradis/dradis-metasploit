module Dradis::Plugins::Metasploit
  module Mapping
    def self.default_mapping
      {
        'host_note' => {
          'Title' => 'Note {{ metasploit[host_note.id] }}',
          'Type' => '{{ metasploit[host_note.ntype] }}',
          'Data' => '{{ metasploit[host_note.data] }}'
        }
      }
    end
  end
end
