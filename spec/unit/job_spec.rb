require 'spec_helper'

RSpec.configure {|config| config.mock_with :mocha }

describe 'Gremlin::Job' do

  describe '#new' do
    it "takes at least two parameters: template and user and returns a new Gremlin::Job object" do
      Job1 = Gremlin::Job.new(:template => 'CreateInfrastructure', :user => 'test_user')
      Job1.should be_an_instance_of Gremlin::Job
    end

    it "takes an optional third args Hash type argument and returns a new Gremlin::Job object" do
      Job2 = Gremlin::Job.new(:template => 'CreateInfrastructure', :user => 'test_user', :args => {'test' => 'test'})
      Job2.should be_an_instance_of Gremlin::Job
    end

    it "it should raise an error when passing anything other than a string to template or user" do
      expect { Gremlin::Job.new(:template => 1234 , :user => 'test_user') }.to raise_error(TypeError, "Value (Fixnum) '1234' is not any of: String.")
      expect { Gremlin::Job.new(:template => 'CreateInfrastructure' , :user => 1234 ) }.to raise_error(TypeError, "Value (Fixnum) '1234' is not any of: String.")
    end

    it "it should raise an error when passing anything other than a Hash to args" do
      expect { Gremlin::Job.new(:template => 'CreateInfrastructure' , :user => 'test_user', :args => 'testing' ) }.to raise_error(TypeError, "Value (String) 'testing' is not any of: Hash.")
    end
  end

  context 'with no args passed' do
    before :each do
      @Job = Gremlin::Job.new(:template => 'CreateInfrastructure', :user => 'test_user')
    end

    describe '#validate' do
      it 'should return true' do
        @Job.validated.should be_an_instance_of TrueClass
      end
    end
    describe 'self.all' do
      it 'should return an array containing CreateInfrastructure' do
        Gremlin::Job.all.should include(@Job)
      end
    end

  end
end