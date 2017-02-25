module Ixbrl
  class ElementParser
    TNS_2008 = 'http://www.xbrl.org/2008/inlineXBRL/transformation'
    TNS_2010 = 'http://www.xbrl.org/inlineXBRL/transformation/2010-04-20'
    TNS_2011 = 'http://www.xbrl.org/inlineXBRL/transformation/2011-07-31'

    def parse_element(c)
      i = c.inner_text
      unless c['format'].nil?
        prefix, format_name = c['format'].split(':')
        format_namespace = c.namespaces['xmlns:' + prefix]
        case [format_namespace, format_name]
          when [TNS_2011, 'datedaymonthyear'], [TNS_2008, 'dateslasheu'], [TNS_2010, 'datedoteu'], [TNS_2010, 'dateslasheu']
            begin
              return guess_century(Date.strptime(i.gsub(/[^0-9]+/, '.'), '%d.%m.%Y')).strftime('%Y-%m-%d')
            rescue
              raise 'invalid date' + i
            end
          when [TNS_2010, 'datelonguk'], [TNS_2011, 'datedaymonthyearen'], [TNS_2008, 'datelonguk']
            begin
              i_gsub = i.gsub(/^(\d{1,2})(st|nd|rd|th)/, '\1')
              return Date.strptime(i_gsub, '%d %B %Y').strftime('%Y-%m-%d')
            rescue
              raise 'invalid date' + i_gsub
            end
          when [TNS_2010, 'dateshortuk']
            return Date.strptime(i, '%d %b %Y').strftime('%Y-%m-%d')
          when [TNS_2010, 'datelongus']
            return Date.strptime(i, '%B %d, %Y').strftime('%Y-%m-%d')
          when [TNS_2010, 'numcommadot'], [TNS_2011, 'numdotdecimal'], [TNS_2008, 'numcommadot']
            return i.gsub(/[^\d.]/, '').to_f
          when [TNS_2011, 'booleantrue']
            return true
          when [TNS_2011, 'booleanfalse']
            return false
          when [TNS_2011, 'nocontent']
            return nil
          when [TNS_2011, 'zerodash'], [TNS_2010, 'numdash'], [TNS_2008, 'numdash']
            return 0
          else
            raise "Unknown format #{format_namespace}:#{format_name} with inner text \"#{i.to_s}\""
        end
      end
      if c.name == 'nonNumeric'
        return i
      end
      i.tr(',', '').to_f
    end


    def guess_century(date)
      if date.year < 100
        date = date >> 12 * 2000
      end
      date
    end
  end
end
