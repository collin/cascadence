cascadence
=

Helper for organizing flow-based specs for such things as writing integration tests with rspec-capybara

Example Usage
=
Suppose you have the files:

```
  flows
  |- spam
  |   |- spam_flow.rb
  |   |- hard_spam_flow.rb
  |- spam.rb
  |- flow_helper.rb
```
1. flows
  1. spam
    1. spam_flow.rb
    2. hard_spam_flow.rb
  2. spam.rb
  3. flow_helper.rb

1. spam_flow.rb

```ruby
  module Spam
    class SpamFlow < Cascadence::Flow

      cascading_order :step1, :step2, :step3

      def initialize(zero_state)
        self.state = zero_state
      end

      def step1
        self.state += 1
      end

      def step2
        _modifiy_state_in_some_way
      end

      def step3
        # more state modification
      end

      private

      def _modify_state_in_some_way
        # do stuff with self.state
      end
    end
  end
```

1.5. hard_spam_flow.rb

```ruby
  module Spam
    class HardSpamFlow < SpamFlow
      fork_after :step1
      merge_before :step2
      cascading_order :step1point25, :step1point5

      def step1point25
        # modify state
      end

      def step1point5
        # modify state
      end
    end
  end
```

2. flow_helper.rb

```ruby
  require 'cascadence'
  require 'spam'
  require 'capybara'

  Cascadence.config do |config|
    config.parallel = true # or false
    config.max_thread_count = 4
    config.zero_state_generator = lambda { Capybara::Session.new :selenium }
  end
```

3. spam.rb

```ruby
  require 'spam/spam_flow.rb'
  require 'spam/hard_spam_flow.rb'
```

How to run
=

```sh
  $ cascadence flows/ # runs all flows
  $ cascadence flows/spam # runs all flows in the spam folder
  $ cascadence flows/spam/spam_flow.rb # runs the spam_flow.rb flow
```

Notes
=
You (I guess that would be me) need to fix how cascadence order is read, right now, the dependence on
recursion is extremely resource heavy and definitely a bad idea (if not a target for memory leaks)

Update: version 0.2.1 out and still not fixed. You (that would be me) are a major faggot.

Contributing to cascadence
==  
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
== 
Copyright (c) 2013 Thomas Chen. See LICENSE.txt for
further details.

