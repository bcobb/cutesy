require_relative '../spec_helper'

describe 'global custom setter template' do

  before do
    Cutesy.template do |cute_object, attribute, value|
      cute_object.test_setter(attribute, value)
    end
  end

  let(:person) { Person.new }
  let(:name) { 'Brian' }

  after { person.named(name) }

  it 'should use the custom template method instead of the default' do
    person.should_receive(:test_setter).with(:name, name)
  end

end
