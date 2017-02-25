require 'spec_helper'

describe Ixbrl::DocumentParser do

  it 'gets items under contexts with instant' do
    document = '<html>

                  <xbrli:context id="instant_uno" xmlns:xbrli="http://www.xbrl.org/2003/instance">
                    <xbrli:entity>
                      <xbrli:identifier scheme="http://www.companieshouse.gov.uk/">02085300</xbrli:identifier>
                    </xbrli:entity>
                    <xbrli:period>
                      <xbrli:instant>2015-04-30</xbrli:instant>
                    </xbrli:period>
                  </xbrli:context>

                  <ix:nonNumeric contextRef="instant_uno"
                    xmlns:uk-direp="http://www.xbrl.org/uk/reports/direp/2009-09-01"
                    xmlns:ix="http://www.xbrl.org/2008/inlineXBRL"
                    name="uk-direp:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct">The director acknowledges his responsibilities for complying with the requirements of the Act with respect to accounting records and the preparation of accounts.</ix:nonFraction>

          </html>'
    items_under_instants = Ixbrl::DocumentParser.new.get_items_under_instants(document)
    expect(items_under_instants).to eq(
      {
        '2015-04-30' => {
          'http://www.xbrl.org/uk/reports/direp/2009-09-01:DirectorsAcknowledgeTheirResponsibilitiesUnderCompaniesAct' => 'The director acknowledges his responsibilities for complying with the requirements of the Act with respect to accounting records and the preparation of accounts.'
        }
      })
  end

  it "groups up and merges contexts with the same instant" do

    context = '<xbrli:context id="instant_uno">
                 <xbrli:entity>
                   <xbrli:identifier scheme="http://www.companieshouse.gov.uk/">02085300</xbrli:identifier>
                 </xbrli:entity>
                 <xbrli:period>
                    <xbrli:instant>2015-04-30</xbrli:instant>
                 </xbrli:period>
               </xbrli:context>'

    item = '<ix:nonFraction
              contextRef="instant_uno"
              name="ns5:ProfitLossAccountReserve"
              unitRef="GBP"
              decimals="0"
              scale="0"
              xmlns:ix="http://www.xbrl.org/2008/inlineXBRL">34</ix:nonFraction>'

    context2 = '<xbrli:context id="instant_duo">
                 <xbrli:entity>
                   <xbrli:identifier scheme="http://www.companieshouse.gov.uk/">02085300</xbrli:identifier>
                 </xbrli:entity>
                 <xbrli:period>
                    <xbrli:instant>2015-04-30</xbrli:instant>
                 </xbrli:period>
               </xbrli:context>'

    item2 = '<ix:nonFraction
              contextRef="instant_duo"
              name="ns5:ParValueShare"
              unitRef="GBP"
              decimals="INF"
              scale="0"
              xmlns:ix="http://www.xbrl.org/2008/inlineXBRL">1.00005</ix:nonFraction>'

    string = '<html xmlns:xbrli="http://www.xbrl.org/2003/instance"
                    xmlns:ns5="http://www.xbrl.org/uk/gaap/core/2009-09-01"
                    xmlns:ix="http://www.xbrl.org/2008/inlineXBRL">' + context + context2 + item + item2 + '</html>'
    items_under_instants = Ixbrl::DocumentParser.new.get_items_under_instants(string)
    expect(items_under_instants).to eq(
      {
        '2015-04-30' => {
          "http://www.xbrl.org/uk/gaap/core/2009-09-01:ProfitLossAccountReserve" => 34,
          "http://www.xbrl.org/uk/gaap/core/2009-09-01:ParValueShare" => 1.00005
        }
      })
  end

end