module Dradis::Plugins::Metasploit
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Metasploit output from #{ params[:file] }..." }
      @doc = Nokogiri::XML(file_content)
      logger.info { 'Done.' }

      version_importer = nil
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
      @doc.xpath('hosts/host') do |xml_host|
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
  end
end
