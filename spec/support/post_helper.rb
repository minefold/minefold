module PostHelper
  def raw_post(action, params, body)
    @request.env['RAW_POST_DATA'] = body
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end
end

RSpec.configure do |config|
  config.include PostHelper, :type => :controller
end