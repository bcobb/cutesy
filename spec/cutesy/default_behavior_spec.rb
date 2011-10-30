require_relative '../spec_helper'

module Accessors 
  attr_accessor :name, :birthdate
end

shared_examples_for 'a default Cutesy implementation' do

  context 'when setting one attribute' do

    subject { person.named(name) }

    its(:name) { should == name }

  end

  context 'when setting multiple attributes' do

    subject { person.named(name).born_on(birthdate) }

    its(:name) { should == name }
    its(:birthdate) { should == birthdate }

  end

end

describe 'the default behavior' do

  let(:person) { Person.new }
  let(:name) { 'Brian' }
  let(:birthdate) { 'August 8th, 1988' }

  context 'when setters exist' do

    before { person.extend Accessors }

    it_should_behave_like 'a default Cutesy implementation'

  end

  context "when setters don't exist" do

    it_should_behave_like 'a default Cutesy implementation'

  end

end
