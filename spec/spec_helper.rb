require 'cadet'

def quick_neo4j
  tmp_neo4j do |db|
    db.transaction do
      yield db
    end
  end
end

def tmp_neo4j
  Dir.mktmpdir do |tmpdir|
    db = Cadet::Test::Session.open
      yield db
    db.close
  end
end