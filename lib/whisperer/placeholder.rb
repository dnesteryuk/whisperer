# This class is a fake model to define factories
# since FactoryGirl requires a module.
#
# Example:
#
#   FactoryGirl.define do
#     factory :ned_stark, class: Placeholder do
#       first_name 'Ned'
#       last_name  'Stark'
#       group      'member'
#     end
#   end
#
Placeholder = Class.new(OpenStruct)