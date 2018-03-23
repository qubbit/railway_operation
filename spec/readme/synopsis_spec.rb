# frozen_string_literal: true

require 'spec_helper'

module Readme
  class Synopsis
    include RailwayOperation

    operation do |o|
      o.add_step 1, :first_method
      o.add_step 1, :another_method
      o.add_step 1, :final_method
    end

    def initialize(someone = 'someone')
      @someone = someone
    end

    def first_method(argument, **_info)
      argument << "Hello #{@someone}, from first_method."
      argument
    end

    def another_method(argument, **_info)
      argument << 'Hello from another_method.'
      argument
    end

    def final_method(argument, **_info)
      argument << 'Hello from final_method.'
      argument
    end
  end
end

describe Readme::Synopsis do
  let(:argument) { [] }
  it 'executes methods in the order they are specified' do
    result, info = described_class.run(argument)

    expect(result).to eq(
      [
        'Hello someone, from first_method.',
        'Hello from another_method.',
        'Hello from final_method.'
      ]
    )

    # expect(RailwayOperation::Info.execution(info)).to eq(
    #   [
    #     { track_identifier: 0, step_index: 0, argument: [], noop: false},
    #     { track_identifier: 0, step_index: 1, argument: ['Hello someone, from first_method.'], noop: false},
    #     { track_identifier: 0, step_index: 2, argument: ['Hello someone, from first_method.', 'Hello from another_method.'], noop: false},
    #     { track_identifier: 0, step_index: 3, argument: ['Hello someone, from first_method.', 'Hello from another_method.', 'Hello from final_method.'], noop: true},
    #   ]
    # )
  end

  it 'executes operation with the initialized parameter' do
    result, _info = described_class.new('Felix').run(argument)

    expect(result).to eq(
      [
        'Hello Felix, from first_method.',
        'Hello from another_method.',
        'Hello from final_method.'
      ]
    )
  end
end
