require 'nokogiri'

module Ixbrl
  class DocumentParser
    NS_XBRL = 'http://www.xbrl.org/2003/instance'
    NS_IXBRL = 'http://www.xbrl.org/2008/inlineXBRL'

    def initialize
      @element_formatter = ElementParser.new
    end


    def get_items_under_instants(document)
      doc = Nokogiri::XML(document)
      contexts = doc.xpath('//xbrli:context', 'xbrli' => NS_XBRL)
      contexts.reduce({}) do |reduced, context|
        instant = get_instant_from_context(context)
        items = get_items_under_context(doc, context)
        unless reduced[instant].nil?
          items = items.merge(reduced[instant])
        end
        reduced[instant] = items
        reduced
      end
    end


    def get_items_under_context(doc, context)
      items = doc.xpath("//ix:*[@contextRef='" + context['id'] + "']", 'ix' => NS_IXBRL)
      items.map { |item|
        [
            fully_qualify_item_name(item),
            @element_formatter.parse_element(item)]
      }.to_h
    end

    def get_instant_from_context(context)
      context.xpath('//xbrli:instant', 'xbrli' => NS_XBRL).first.inner_text
    end

    def fully_qualify_item_name(item)
      name_prefix, name_type = item['name'].split(':')
      namespace_uri = item.namespaces['xmlns:' + name_prefix]
      namespace_uri + ':' + name_type
    end
  end
end
