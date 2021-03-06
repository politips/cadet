module Cadet
  class DynamicLabel
    @dynamic_labels = {}

    def self.label(name)
      @dynamic_labels[name] ||= org.neo4j.graphdb.DynamicLabel.label(name)
    end
  end
end