require 'spec_helper'

RSpec.configure {|config| config.mock_with :mocha }

describe 'Gremlin::Scheduler' do
  before :each do
    @scheduler = Gremlin.scheduler
  end

  describe '#scheduler' do
    it 'returns a scheduler object' do
      @scheduler.should  be_instance_of Rufus::Scheduler
    end
  end
end

