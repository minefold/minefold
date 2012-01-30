module ControllerHelpers
  def post_json action, body, params={}
    @request.env['RAW_POST_DATA'] = body.to_json
    response = post action, params
    @request.env.delete 'RAW_POST_DATA'
    response
  end
end