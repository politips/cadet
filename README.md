super simple. you dont even need to download neo4j.

1. Gemfile

    ```ruby
    gem 'cadet', git: 'https://github.com/karabijavad/cadet'
    ```
2. ``` bundle install ```
3. cadet-example.rb

    ```ruby
    require 'cadet'
    
    db = Cadet::Session.open("/tmp")
    db.transaction do
        a = db.create_node
        a.addLabel "Foolabel"
        a.vala = "fooa"
        a.valb = "foob"
    
        b = db.create_node
        b.addLabel "Barlabel"
        b.vala = "bara"
        b.valb = "barb"
    
        a.outgoing b, "foobar"
    end
    db.close()
    ```
4. ```bundle exec ruby```
