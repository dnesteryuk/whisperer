class CustomSerializer
  def self.serialize(record, options = {})
    "#{record.first_name} #{record.last_name}"
  end
end