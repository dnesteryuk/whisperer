module Fixtures
  # Returns content of a generated fixture
  def fixture(fixture_name)
    File.read('spec/fixtures/' << fixture_name << '.yml')
  end
end