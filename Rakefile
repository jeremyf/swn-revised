desc "Extract tables from EPUB.xhtml"
task :extract_tables, [:filename] do |task, args|
  filename = args.fetch(:filename, "")
  require 'nokogiri'
  content = File.read(filename)
  doc = Nokogiri::HTML(content)
  counter = 0
  doc.css("div").each do |div|
    div_comments = []
    if first_p = div.css("p").first
      div_comments << first_p.text.strip
    end
    div.css("table").each do |table|
      rows = []
      table_comments = []
      counter += 1
      basename = sprintf("table-%05d", counter)
      table.css("thead").each do |thead|
        columns = thead.text.strip.split(/[\t\n]+/)
        table_comments << %(Columns: #{columns.join(",")})
      end
      table.css("tbody tr").each do |row|
        rows << row.text.strip.split(/[\t\n]+/)
      end
      File.open(File.expand_path("../data/#{basename}.tsv", __FILE__), "w+") do |file|
        div_comments.each do |comment|
          file.puts "# #{comment}"
        end
        table_comments.each do |comment|
          file.puts "# #{comment}"
        end
        rows.each do |row|
          file.puts row.join("\t")
        end
      end
    end
  end
end
