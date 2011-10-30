require_relative '../cutesy'

module Readers
  attr_reader :name, :birthdate
end

class Person
  include Readers
end

class Programmer
  include Readers
end

Cutesy.klass Person do |person|
  person.sets :name, :with => :named
  person.sets :birthdate, :with => :born_on
end

Cutesy.klass Programmer do |programmer|
  programmer.sets :name, :with => :named
end

RSpec.configure do |c|
  c.before(:each) { Cutesy.reset! }
end
