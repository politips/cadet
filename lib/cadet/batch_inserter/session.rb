module Cadet
  module BatchInserter
    class Session < Cadet::Session
      include_package "org.neo4j.graphdb"
      include_package "org.neo4j.unsafe.batchinsert"
      include_package "org.neo4j.index.impl.lucene"
      include_package "org.neo4j.helpers.collection"

      def initialize(db)
        @db = db
        @index_provider = Cadet::CadetIndex::IndexProvider.new(db)
      end

      def close
        @index_provider.shutdown
        super
      end

      def self.open(location)
        new BatchInserters.inserter(location)
      end

      def transaction
        yield
      end

      def constraint(label, property)
        @db.createDeferredConstraint(DynamicLabel.label(label))
          .assertPropertyIsUnique(property.to_s)
          .create()
      end

      def find_node(label, property, value)
        index = @index_provider.nodeIndex(label)

        ( node = IteratorUtil.firstOrNull(index.get(property, value)) ) ?
          Node.new(node, @db) : nil
      end

      def create_node(label, property, value)
        Node.new(@db.createNode({property.to_s => value}, DynamicLabel.label(label)), @db).tap do |n|
          index = @index_provider.nodeIndex(label).add(n.underlying, property, value)
        end
      end
    end
  end
end