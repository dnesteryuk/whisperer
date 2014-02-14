FactoryGirl.define do
  factory :ned_stark, class: User do
    first_name 'Ned'
    last_name  'Stark'
    group      'member'
  end
end