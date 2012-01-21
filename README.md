# Fluentr

Fluentr provides tooling to quickly build fluent interfaces to your Ruby
objects.

## Why?

Whenever I sketch out ideas in code, I end up with nonsense like this:
`SleepPeriod.in(my_bed).with(teddy_bear).for(7.hours)`. I usually give that
stuff up when I find myself writing methods that just `tap` and set an
attribute, but then I decided that, no, I will have my sentences, and here we
are.

## Example

Suppose we have `Person`, and we want to define a few templates for new people.
Ideally, we'd have a method like so:

    class Person

      attr_accessor :name, :birth_date

      def self.newborn_named(name)
        new.named(name).born_on(Date.today)
      end

      # Person implementation

    end

Here's how we use Fluentr to do this:

    class Person
      extend Fluently

      fluently do
        set :name, :with => :named
        set :birth_date, :with => :born_on
      end

    end

## Plays well (I hope!) with others

By default, Fluentr will use an accessor if it can find one. Otherwise, it
will set an instance variable directly.

If you'd like to use a different strategy to set one or more attributes, you can
bend Fluentr to your will. Let's say you have a Rails app and want to set every
attribute using `update_attribute` (hypothetically, of course):

    Fluentr.template do |object, attribute, value|
      object.update_attribute(attribute, value)
    end

You can do this on a per-class, or per-attribute basis, too

    class Person
      extend Fluently

      # We'll use +update_attribute+ to set +name+, but we'll use some custom
      # method to set everything else
      fluently do
        set :birth_date, :with => :born_on
        set :name, :with => :named do |person, attribute, value|
          person.update_attribute(attribute, value)
        end

        template :set do |object, attribute, value|
          object.set_with_an_audit(attribute, value)
        end
      end

    end

## TODO

1. Concise syntax for toggle-able attributes.
2. Concise syntax for numerical attributes.

## Prior Art?

There's got to be something else like this, right? If so, please let me know.
I'm really curious about other ways folks have indulged their prosaic
tendencies.
