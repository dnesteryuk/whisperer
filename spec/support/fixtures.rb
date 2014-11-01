module Fixtures
  # Returns content of a generated fixture
  def fixture(fixture_name)
    dir = RUBY_VERSION =~ /2.1.[1-9]/ ? '2.1.x/' : '2.0.x/'

    File.read('spec/fixtures/' << dir << fixture_name << '.yml')
  end
end