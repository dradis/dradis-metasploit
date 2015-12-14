module Dradis::Plugins::Metasploit
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Metasploit output from #{ params[:file] }..." }
      # data = MultiJson.decode(file_content)
      logger.info { 'Done.' }

      # unless data.key?("scan_info")
      #   logger.error "ERROR: no 'scan_info' field present in the provided "\
      #                "data. Are you sure you uploaded a Metasploit file?"
      #   exit(-1)
      # end
    end
  end
end
