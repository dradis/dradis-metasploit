module Dradis::Plugins::Metasploit
  class Importer < Dradis::Plugins::Upload::Importer
    def self.templates
      {}
    end

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Metasploit output from #{ params[:file] }..." }
      @doc = Nokogiri::XML(file_content)
      logger.info { 'Done.' }

      case @doc.root.name
      when 'MetasploitV5'
        # version_importer = Dradis::Plugins::Metasploit::Importers::Version5.new(@doc)
      when /MetasploitV/
        error = "Invalid Metasploit version. Sorry, the XML file corresponds to a version of Metasploit we don't have a parser for. Please let us know: http://discuss.dradisframework.org"
        logger.fatal { error }
        content_service.create_note text: error
        return false
      else
        error = "Invalid XML file. The XML document didn't contain a Metasploit root tag. Did you upload a Metasploit XML file?"
        logger.fatal { error }
        content_service.create_note text: error
        return false
      end

      parse_file
    end

    private
    def parse_file
      # hosts
      @doc.root.xpath('hosts/host').each do |xml_host|
        parse_host(xml_host)
      end

      # events
      # services
      # web sites
      # web pages
      # web forms
      # web vulns
      # module details
    end

    # Parses each of the MetasploitV5/hosts/host entries in the document.
    def parse_host(xml_host)
      address = xml_host.at_xpath('address').text
      logger.info { "\tParsing: #{address}" }

      # Create the Node
      host_node = content_service.create_node(label: address, type: :host)

      # Node properties
      if host_node.respond_to?(:properties)
        # Set basic host properties
        host_node.set_property(:ip, address)

        if mac = xml_host.at_xpath('mac')
          host_node.set_property(:mac, mac.text)
        end

        if os_name = xml_host.at_xpath('os-name')
          host_node.set_property(:os, os_name.text)
        end

        # Service-related properties
        xml_host.xpath('services/service').each do |xml_service|
          port     = xml_service.at_xpath('port').text.to_i
          protocol = xml_service.at_xpath('proto').text
          state    = xml_service.at_xpath('state').text

          logger.info { "\t\tFound: #{protocol}/#{port} - #{state}" }

          host_node.set_service(
            protocol: protocol,
            port:     port,
            state:    state,
            name:     xml_service.at_xpath('name').text,
            source:   :metasploit,
            info:     xml_service.at_xpath('info').text,
          )
        end

        # Commit changes
        host_node.save
      end

      xml_host.xpath('notes/note').each do |xml_note|
        host_note = mapping_service.apply_mapping(source: 'host_note', data: xml_note)
        content_service.create_note(text: host_note, node: host_node)
      end
    end
  end
end
