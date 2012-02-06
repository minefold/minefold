require 'benchmark'

class Pivot < String

  def self.dir
    File.join('db', 'pivots')
  end

  def self.db
    Mongoid.database
  end

  def self.schema
    db[:schema_info]
  end

  def self.all
    Dir[File.join(dir, '*.rb')].map {|f| new(f) }
  end

  def self.previous
    schema.find.map {|doc| new(doc['file']) }
  end

  def self.pending
    (all - previous).sort
  end

  def db
    self.class.db
  end

  def run!
    start = Time.now
    load(self)
    finish = Time.now

    record!

    return (finish - start)
  end

  def run?
    not schema.find(file: self).first.nil?
  end

  def record!
    schema.insert(file: self, at: Time.now)
  end

  def name
    File.read(self).split("\n").first.sub(/^#\s+/, '')
  end

  def timestamp
    File.basename(self, '.rb')
  end

private

  def schema
    db[:schema_info]
  end

end
