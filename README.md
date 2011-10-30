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

Suppose we have `MenuItem`, which we use to represent restaurant meny data. In
this case, we care about the meal during which we'd serve this item, and the
condiments available for the item:

    class MenuItem

      attr_reader :name, :meal, :condiments

      def initialize(name)
        @name = name
        @meal = nil
        @condiments = []
      end

      # MenuItem implementation

    end

Now, we can make `MenuItem` cute.
     
    Cutesy.klass MenuItem do |menu_item|

      menu_item.sets :meal, :with => :for
      menu_item.sets :condiments, :with => :with_condiments

    end

And lo, we can do things like this:

    #> m = MenuItem.new('Cheeseburger').for(lunch).with_condiments(condiments)
    >> <MenuItem>
    #> m.name == 'Condiments'
    >> true
    #> m.meal == meal
    >> true
    #> m.condiments == condiments
    >> true

## Plays well (I hope!) with others

Out of the box, Cutesy will use an accessor if it can find one. Otherwise, it
will set an instance variable directly. 

But what do I know about anything? Maybe that behavior causes more problems for
you than cute syntax is worth. No worries; you can bend Cutesy to your will.
Let's say you have a Rails app and want to set every attribute using
`update_attribute` (hypothetically, of course):

    Cutesy.template do |cute_object, attribute, value|
      cute_object.update_attribute(attribute, value)
    end

And if you only want to change the behavior for one class, you'd give that class
as an argument:

    Cutesy.template MenuItem do |cute_object, attribute, value|
      # template
    end

## Prior Art?

There's got to be something else like this, right? If so, please let me know.
I'm really curious about other ways folks have indulged their prosaic
tendencies. 
