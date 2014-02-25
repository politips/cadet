module Cadet
  class Node
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(node, db = nil)
      @db = db
      @underlying = node
    end

    def add_label(label)
      @underlying.addLabel(DynamicLabel.label(label))
      self
    end
    def labels
      @underlying.getLabels().map(&:name)
    end

    def []= (property, value)
      @underlying.setProperty(property.to_java_string, value)
    end

    def [] (property)
      @underlying.getProperty(property.to_java_string)
    end

    def each_relationship(direction, type)
      @underlying.getRelationships(direction, DynamicRelationshipType.withName(type)).each do |rel|
        yield Relationship.new(rel)
      end
    end

    def create_outgoing(to, type)
      @underlying.createRelationshipTo(to.underlying, DynamicRelationshipType.withName(type))
    end
    def outgoing(type)
      NodeRelationships.new(self, Cadet::Direction::OUTGOING, type)
    end
    def incoming(type)
      NodeRelationships.new(self, Cadet::Direction::INCOMING, type)
    end

    def == other_node
      @underlying.getId == other_node.underlying.getId
    end
  end
end
