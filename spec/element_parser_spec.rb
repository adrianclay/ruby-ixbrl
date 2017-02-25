require 'spec_helper'

describe Ixbrl::ElementParser do

  def parse_element_from_xml(xml)
    xml = '<a xmlns:ix="http://www.xbrl.org/2008/inlineXBRL">' + xml + '</a>'
    Ixbrl::ElementParser.new.parse_element(Nokogiri::XML(xml).root.children.first)
  end

  it "pulls out formatless numeric elements" do
    item = '<ix:nonFraction unitRef="GBP" decimals="0" scale="0">34</ix:nonFraction>'
    expect(parse_element_from_xml(item)).to eq(34)
  end

  it "pulls out text elements" do
    item = '<ix:nonNumeric>Cheese on sticks</ix:nonNumeric>'
    expect(parse_element_from_xml(item)).to eq("Cheese on sticks")
  end

  describe Ixbrl::ElementParser::TNS_2011 do

    it "zero dash" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:zerodash">-</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(0)
    end

    it "num dot decimal" do
      item = '<ix:nonFraction unitRef="u1" decimals="0" xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:numdotdecimal">3,089,712.00</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(3089712.0)
    end

    it "date day month year (dots)" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:datedaymonthyear">30.4.16</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq('2016-04-30')
    end

    it "date day month year (slashes)" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:datedaymonthyear">30/4/15</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq('2015-04-30')
    end

    it "date day month year (long)" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:datedaymonthyearen"><span>24 November 2016</span></ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2016-11-24')
    end

    it "boolean true" do
      item = '<ix:nonFraction unitRef="u1" decimals="0" xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:booleantrue">3,089,712</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(true)
    end

    it "boolean false" do
      item = '<ix:nonFraction unitRef="u1" decimals="0" xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:booleanfalse">3,089,712</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(false)
    end

    it "no content" do
      item = '<ix:nonFraction unitRef="u1" decimals="0" xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2011-07-31"
                  format="ixt:nocontent">3,089,712</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(nil)
    end
  end

  describe Ixbrl::ElementParser::TNS_2010 do

    it "date dot eu" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:datedoteu">21.12.15</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq('2015-12-21')
    end

    it "date slash eu" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:dateslasheu">14/01/2016</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq('2016-01-14')
    end

    it "date long us" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:datelongus">April 30, 2015</span></ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2015-04-30')
    end

    it "num comma dot" do
      item = '<ix:nonFraction unitRef="u1" decimals="0" xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:numcommadot">3,089,712</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(3089712.0)
    end

    it "date long uk" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:datelonguk">24 November 2016</ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2016-11-24')
    end

    it "date long uk + contraction" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:datelonguk">16th October 2015</ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2015-10-16')
    end


    it "date short uk" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:dateshortuk">30 Nov 2016</span></ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2016-11-30')
    end

    it "num dash" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/inlineXBRL/transformation/2010-04-20"
                  format="ixt:numdash">-</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(0)
    end

  end

  describe Ixbrl::ElementParser::TNS_2008 do

    it "date long uk" do
      item = '<ix:nonNumeric xmlns:ixt="http://www.xbrl.org/2008/inlineXBRL/transformation"
                  format="ixt:datelonguk">30 April 2015</span></ix:nonNumeric>'
      expect(parse_element_from_xml(item)).to eq('2015-04-30')
    end

    it "num dash" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/2008/inlineXBRL/transformation"
                  format="ixt:numdash">-</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(0)
    end

    it "num comma dot" do
      item = '<ix:nonFraction unitRef="u1" decimals="0"
                  xmlns:ixt="http://www.xbrl.org/2008/inlineXBRL/transformation"
                  format="ixt:numcommadot">3,089,712.00</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq(3089712.0)
    end

    it "date slash eu" do
      item = '<ix:nonFraction xmlns:ixt="http://www.xbrl.org/2008/inlineXBRL/transformation" format="ixt:dateslasheu">05/04/2015</ix:nonFraction>'
      expect(parse_element_from_xml(item)).to eq('2015-04-05')
    end

  end

end