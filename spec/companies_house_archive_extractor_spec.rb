require 'spec_helper'

describe Ixbrl::CompaniesHouseArchiveExtractor do

  it 'yields html file contents from archive' do
    compress_files({ "a.html": FILE_CONTENTS })
    yielded_results = expect do |yield_observer|
      Ixbrl::CompaniesHouseArchiveExtractor.new.ixbrl_entries(ZIP_NAME, &yield_observer)
    end
    yielded_results.to yield_with_args(FILE_CONTENTS)
  end

  it 'ignores non-html files in archive' do
    compress_files({ "a.xml": FILE_CONTENTS })
    yielded_results = expect do |yield_observer|
      Ixbrl::CompaniesHouseArchiveExtractor.new.ixbrl_entries(ZIP_NAME, &yield_observer)
    end
    yielded_results.to_not yield_control
  end

  ZIP_NAME = 'rspec_test.zip'
  FILE_CONTENTS = "a fantastic file"

  after(:each) do
    File.delete(ZIP_NAME)
  end

  def compress_files(zip_files)
    Zip::File.open(ZIP_NAME, Zip::File::CREATE) do |zipfile|
      zip_files.each do |filename, contents|
        zipfile.get_output_stream(filename) { |write_stream| write_stream.write contents }
      end
    end
  end
end