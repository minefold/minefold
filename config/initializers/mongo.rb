MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOHQ_URL'] || 'mongodb://localhost/minefold'
  }
}

MongoMapper.connect(Rails.env)
