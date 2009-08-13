class ExceptionNotificationParser
  
  def self.parse(body)
    return false if body.empty?
    body = body.split("\n") if body.is_a?(String)
    
    data = {:main => {}}
    title = body[0].split ' '
    data[:main][:controller], data[:main][:action] = title[4][0..-2].split '#'
    
    # TODO: Do it better, maybe regex?
    message = []
    message_array = body[2].split ' '
    message_array.each do |part|
      break if part == 'in' || part == 'for'
      message << part
    end
    message = message.join ' '
    
    data[:main][:exception_name] = "#{title[1]} #{message}"
    data[:main][:first_line] = body[3].strip
    
    current_line = 5 # first line with ---..
    current_section = :main
    body_lines = body.size
    while current_line <= body_lines
      line = body[current_line].to_s.strip
      unless line.empty?
        if line == '-------------------------------'
          current_section = body[current_line+1].to_s[0..-3].downcase.to_sym
          data[current_section] = (current_section == :backtrace) ? '' : {}
          current_line += 3
        else
          if current_section == :backtrace
            data[:backtrace] += "#{line}\n"
          elsif line[0..0] == '*'
            # TODO: Do it cleaner (maybe regex)
            line = line.split ':'
            param = line.shift
            value = line.join ':'
            data[current_section][param.strip[2..-1]] = value.to_s.strip
          else
            puts "Unmatched line: #{line}" # TODO: log
          end
        end
      end
      current_line += 1
    end
    
    data
  end
  
end
