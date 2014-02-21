require 'spec_helper'

describe Cadet do

  it "should set a node's property" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad[:name].should == "Javad"
    end
  end

  it "should set a node's label" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad.add_label "Member"
        javad.labels.should == ["Person", "Member"]
    end
  end

  it "should add outgoing relationship's to a node" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows) << ellen

        javad.outgoing(:knows).to_a.should == [ellen]
    end
  end
end
