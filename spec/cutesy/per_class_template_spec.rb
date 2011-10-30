require_relative '../spec_helper'

describe 'per-class custom setter template' do

  before do
    Cutesy.template Person do |cute_object, attribute, value|
      cute_object.test_setter(attribute, value)
    end
  end

  let(:programmer) { Programmer.new }
  let(:person) { Person.new }
  let(:name) { 'Brian' }

  describe 'the given class' do

    after { person.named(name) }

    it 'is set using the custom template' do
      person.should_receive(:test_setter).with(:name, name)
    end

  end

  describe 'a different class' do

    before { programmer.named(name) }

    it 'is set using default behavior' do
      programmer.name.should == name
    end

  end

end
