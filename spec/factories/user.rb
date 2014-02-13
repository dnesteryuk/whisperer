require 'ostruct'

User = Class.new(OpenStruct)

FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name  'Snow'
    group      'member'
  end
end