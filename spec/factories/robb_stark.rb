FactoryGirl.define do
  factory :robb_stark, class: User do
    first_name 'Robb'
    last_name  'Stark'
    group      'member'
  end
end