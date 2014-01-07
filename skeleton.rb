#!/usr/bin/ruby

require 'date'

def as_size(s)
    units = [ "B", "KB", "MB", "GB", "TB" ]

    size, unit = units.reduce(s.to_f) do |(fsize, _), utype|
        fsize > 512 ? [fsize / 1024, utype] : (break [fsize, utype])
    end

    "#{size > 9 || size.modulo(1) < 0.1 ? '%d' : '%.1f'} %s" % [size, unit]
end


filename = ARGV[0]

puts "Import Bible"
puts "Data: #{Date.today} - Hora: #{Time.now}"
puts "-------------------------------------------------------------"
puts ""

f = File.open(filename)
exit

sites = []

File.readlines(filename).each do |line|
    # Exemplo - line
    # www.conesulnews.com.br | 468 | 18429

    line_data = line.split(" | ")
    domain = line_data[0]
    bytes = line_data[1].to_i
    time = line_data[2].to_f

    if (i = sites.index{ |l| l[:domain]==domain })
        sites[i][:bytes] += bytes
        sites[i][:time] += time
        sites[i][:hits] += 1
    else
        sites << { domain: domain, bytes: bytes, time: time, hits: 1 }
    end


end

sites.sort_by! { |col| col[:bytes] }

sites.each do |s|
    line  = "Site: #{s[:domain].ljust(40,' ')} - "
    line += "Total: #{as_size(s[:bytes]).rjust(10,' ')} - "
    time_avg_nginx = "%7.4f" % ((s[:time]/s[:hits]))
    time_avg_apache = "%7.4f" % ((s[:time]/s[:hits]) / 1000000)
    line += "Avg Nginx: #{time_avg_nginx}s - "
    line += "Avg Apache: #{time_avg_apache}s - "
    line += "Hits: #{s[:hits]}"
    puts line
end


#array.sort_by { |col| col[:numero].to_i }
#candidato = @candidatos_hash.select{ |h| h[:numero] == numero }
