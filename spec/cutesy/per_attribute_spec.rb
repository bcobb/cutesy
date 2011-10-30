require_relative '../spec_helper'

describe 'per-attribute setter template' do

  before do
    Cutesy.template Person, :name do |cute_object, attribute, value|
      cute_object.test_setter(attribute, value)
    end
  end

  let(:person) { Person.new }
  let(:name) { 'Brian' }
  let(:birthdate) { 'August 8th, 1988' }

  describe 'the given attribute' do

    after { person.named(name) }

    it 'is set using the custom template' do
      person.should_receive(:test_setter).with(:name, name)
    end

  end

  describe 'a different attribute' do

    before { person.born_on(birthdate) }

    it 'is set using default behavior' do
      person.birthdate.should == birthdate
    end

  end

end
