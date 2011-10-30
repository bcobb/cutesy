# Cutesy

Though the name will likely change seven times before I'm done with this, the
intent sure won't. Cutesy is a, well, _cutesy_ way to get nice, meaningful names
for your setters.

## Why?

Whenever I sketch out ideas in code, I end up with nonsense like this:
`SleepPeriod.in(my_bed).with(teddy_bear).for(7.hours)`. I usually give that
stuff up when I find myself writing methods that just `tap` and set an
attribute, but then I decided that, no, I will have my sentences, and here we
are.

## Example

Suppose we have `Person`, and we're interested in a `Person`'s name and birth
date.

    class Person

      attr_reader :name, :birth_date

      def initialize(name)
        @name = name
      end

      # Person implementation

    end

Now we can configure cutesy for `Person`:
     
    Cutesy.klass Person do |person|
      person.sets :name, :with => :named
      person.sets :birth_date, :with => :born_on
    end

And lo, we can do things like this:

    ruby :001 > brian = Person.new.named('Brian').born_on('August 8th, 1988')
    => #<Person @name="Brian", @birth_date="August 8th, 1988">

## Plays well (I hope!) with others

Out of the box, Cutesy will use an accessor if it can find one. Otherwise, it
will set an instance variable directly. 

But what do I know about anything? Maybe that behavior causes more problems for
you than cute syntax is worth. No worries; you can bend Cutesy to your will.
Let's say you have a Rails app and want to set every attribute using
`update_attribute` (hypothetically, of course):

    Cutesy.template do |object, attribute, value|
      object.update_attribute(attribute, value)
    end

In the event that you have Cutesied up several classes, but you only need
custom behavior for a subset of them, you can specify custom behavior on a
per-class basis:

    Cutesy.template Person do |object, attribute, value|
      # template will only be called for attributes on instances of Person
    end

Finally, you can change the behavior for a single attribute of a single class:

    Cutesy.template Person, :name do |object, attribute, value|
      # template will only be called when setting Person#name
    end

## Prior Art?

There's got to be something else like this, right? If so, please let me know.
I'm really curious about other ways folks have indulged their prosaic
tendencies. 
