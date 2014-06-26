require 'rubygems'
require 'rake'

# split giga-csv into n smaller files

def self.split_csv(original, file_count)
  header_lines = 1
  lines = `cat #{original} | wc -l`.to_i - header_lines
  lines_per_file = (lines / file_count) + header_lines
  header = `head -n #{header_lines} #{original}`

  start = header_lines
  generated_files = []
  file_count.times do |i|
    finish = start + lines_per_file
    file = "#{original}-#{i}.csv"

    File.open(file,'w'){|f| f.write header }
    sh "tail -n #{lines - start} #{original} | head -n #{lines_per_file} >> #{file}"

    start = finish
    generated_files << file
  end

  generated_files
end
