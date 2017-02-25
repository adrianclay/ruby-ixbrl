require 'parallel'
require 'elasticsearch'

module Ixbrl
  class ImportAccountsToElasticSearch
    # @param client [Elasticsearch::Client]
    def initialize( client )
      @client = client
    end

    def import_companies_house_archive(location)
      dp = Ixbrl::DocumentParser.new

      document_queue = SizedQueue.new(Parallel.processor_count * 2)
      t = Thread.new do
        Ixbrl::CompaniesHouseArchiveExtractor.new.ixbrl_entries(location) do |document|
          document_queue.push(document)
        end
        document_queue.push(Parallel::Stop)
      end

      Parallel.each document_queue  do |document|
        instants = dp.get_items_under_instants(document)
        instants.each do |date, items|
          items['instant'] = date
          self.send_to_elastic items
        end
      end
      t.join
    end


    def send_to_elastic(document)
      @client.index index: 'ixbrl',
                    type: 'ixbrl',
                    body: document
    end
  end
end
