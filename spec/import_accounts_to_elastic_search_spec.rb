require "spec_helper"

describe Ixbrl::ImportAccountsToElasticSearch do

  before(:each) do
    @elasticsearch_client = Elasticsearch::Client.new
    delete_elasticsearch_data
    @importer = Ixbrl::ImportAccountsToElasticSearch.new @elasticsearch_client

  end

  it "imports companies house document into elasticsearch" do
    @importer.import_companies_house_archive(File.dirname(__FILE__) + '/ch_09175128.zip')
    wait_for_elasticsearch
    expected_documents = [{
      'instant' => "2016-08-31",
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:NameDirectorSigningAccounts' => "",
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:FixedAssets' => 0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:CurrentAssets' => 1557.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:CreditorsDueWithinOneYear' => 22112.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:NetCurrentAssetsLiabilities' => 20555.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:TotalAssetsLessCurrentLiabilities' => 20555.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:NetAssetsLiabilitiesIncludingPensionAssetLiability' => 20555.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:ShareholderFunds' => 20555.0,
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:DateApprovalAccounts' => "2016-09-19",
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:CompanyEntitledToExemptionUnderSection477CompaniesAct2006' => "For the year ending 31 August 2016 the company was entitled to exemption under section 477 of the Companies Act 2006 relating to small companies.",
      'http://www.xbrl.org/uk/gaap/core/2009-09-01:MembersHaveNotRequiredCompanyToObtainAnAudit' => "The members have not required the company to obtain an audit in accordance with section 476 of the Companies Act 2006.",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:NameEntityOfficer' => "Mr Bruce Nisbet",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:BalanceSheetDate' => "2016-08-31",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:StartDateForPeriodCoveredByReport' => "2015-09-01",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:EndDateForPeriodCoveredByReport' => "2016-08-31",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:UKCompaniesHouseRegisteredNumber' => "09175128",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:EntityCurrentLegalOrRegisteredName' => "CHUMBA PHOTOGRAPHY LTD",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:EntityDormant' => "false",
      'http://www.xbrl.org/uk/cd/business/2009-09-01:EntityTrading' => "true",
      'http://www.xbrl.org/uk/reports/direp/2009-09-01:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct' => "The directors acknowledge their responsibilities for complying with the requirements of the Companies Act 2006 with respect to accounting records and the preparation of accounts.",
      'http://www.xbrl.org/uk/reports/direp/2009-09-01:AccountsAreInAccordanceWithSpecialProvisionsCompaniesActRelatingToSmallCompanies' => "The accounts have been prepared in accordance with the micro-entity provisions and delivered in accordance with the provisions applicable to companies subject to the small companies regime."
    }]
    expect(get_elasticsearch_data).to eq(expected_documents)
  end


  def get_elasticsearch_data
    @elasticsearch_client.search(index: "ixbrl")['hits']['hits'].map do |hit|
      hit['_source']
    end
  end

  def wait_for_elasticsearch
    sleep 1
  end

  def delete_elasticsearch_data
    begin
      Elasticsearch::API::Indices::IndicesClient.new(@elasticsearch_client).delete index: "ixbrl"
    rescue
      # ignored
    end
  end
end