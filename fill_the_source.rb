
a = []
2000.times do
  a.push( (0...rand(5000)).map { ('a'..'z').to_a[rand(26)] }.join )
end

File.open('source.txt', 'w') { |file| file.write(a.join("\n")) }
