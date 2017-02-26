require 'spec_helper'

describe Ixbrl::CompaniesHouseArchiveExtractor do
  let(:zip_name) { 'rspec_test.zip' }
  let(:file_contents) { 'a fantastic file' }

  it 'yields html file contents from archive' do
    compress_files('a.html' => file_contents)
    yielded_results = expect do |yield_observer|
      described_class.new.ixbrl_entries(zip_name, &yield_observer)
    end
    yielded_results.to yield_with_args(file_contents)
  end

  it 'ignores non-html files in archive' do
    compress_files('a.xml' => file_contents)
    yielded_results = expect do |yield_observer|
      described_class.new.ixbrl_entries(zip_name, &yield_observer)
    end
    yielded_results.to_not yield_control
  end

  after(:each) do
    File.delete(zip_name)
  end

  def compress_files(files)
    Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
      files.each do |filename, contents|
        zipfile.get_output_stream(filename) do |write_stream|
          write_stream.write contents
        end
      end
    end
  end
end