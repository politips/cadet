module Cadet
  module CadetIndex
    class IndexProvider
      include_package "org.neo4j.index.impl.lucene"
      def initialize(db)
        @db = db
        @indexes = {}
        @lucene_index = LuceneBatchInserterIndexProviderNewImpl.new(db)
      end
      def nodeIndex(name, type = {"type" => "exact"})
        @indexes[name] ||= CadetIndex::Index.new(@lucene_index, name, type)
      end
      def shutdown
        @indexes.each do |name, index|
          index.flush
        end
      end
    end
  end
end
