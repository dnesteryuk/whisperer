module Cassettes
  # Returns content of a generated cassette
  def cassette(cassette_name)
    f = File.read('spec/cassettes/' << cassette_name << '.yml')
    #, '"99*/*"'
    if RUBY_VERSION =~ /2.0.\d+/
      f.gsub(/("\*\/\*")/, '\'*/*\'')
    elsif RUBY_VERSION =~ /2.1.0/
      f.gsub(/string: '(.+)'/) do |found|
        found.gsub('"', '\"').gsub('\'', '"')
      end
    else
      f
    end
  end
end