module Dradis::Plugins::Metasploit
  module Mapping
    DEFAULT_MAPPING = {
      host_note: {
        'Title' => 'Note {{ metasploit[host_note.id] }}',
        'Type' => '{{ metasploit[host_note.ntype] }}',
        'Data' => '{{ metasploit[host_note.data] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      host_note: [
        'host_note.id',
        'host_note.ntype',
        'host_note.data'
      ]
    }.freeze
  end
end
