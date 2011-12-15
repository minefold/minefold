class PivotGenerator < Rails::Generators::Base
  def create_migration_file
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "#{timestamp}.rb"
    create_file File.join('db', 'pivots', filename), <<-EOF
# Add pivot here
EOF
  end
end
