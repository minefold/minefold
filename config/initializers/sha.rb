module CarrierWave
  module Sha
    def set_sha
      model.sha = Digest::SHA1.hexdigest(read)
    end
  end
end
