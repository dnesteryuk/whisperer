require 'ostruct'

User = Class.new(OpenStruct)

FactoryGirl.define do
  factory :user do
    first_name  'John'
    last_name   'Doe'
    group       'member'
  end
end