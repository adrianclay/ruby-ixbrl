require 'zip'

module Ixbrl
  class CompaniesHouseArchiveExtractor
    def ixbrl_entries(archive_path)
      Zip::File.open(archive_path) do |zip_file|
        zip_file.glob('*.html').each do |entry|
          yield entry.get_input_stream.read
        end
      end
    end
  end
end
