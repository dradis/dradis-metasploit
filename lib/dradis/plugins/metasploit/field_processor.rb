module Dradis
  module Plugins
    module Metasploit
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        # No need to implement anything here
        # def post_initialize(args={})
        # end

        def value(args={})
          field = args[:field]

          # fields in the template are of the form <foo>.<field>, where <foo>
          # is common across all fields for a given template (and meaningless).
          type, name, attribute = field.split('.')

          @data.key?(name) ? @data[name] : 'n/a'
        end
      end
    end
  end
end
