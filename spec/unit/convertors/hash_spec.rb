require 'spec_helper'

module Test
  class Status
    include Virtus.model

    attribute :code, Integer
  end

  class Position
    include Virtus.model

    attribute :name
    attribute :status, Status
  end

  class User
    include Virtus.model

    attribute :name,     String
    attribute :position, Test::Position
  end
end

describe Whisperer::Convertors::Hash do
  describe '#convert' do
    let(:attrs) {
      {
        name:     'Tester',
        position: {
          name: 'developer',
          status: {
            code: 1
          }
        }
      }
    }

    let(:expected_attrs) {
      {
        'name'      => 'Tester',
        'position'  => {
          'name'    => 'developer',
          'status'  => {
            'code'  => 1
          }
        }
      }
    }

    subject { described_class.new(Test::User.new(attrs)) }

    it 'returns a hash with all related objects' do
      expect(subject.convert).to eq(
        expected_attrs
      )
    end
  end
end