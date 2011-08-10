module Job
  class ImportWorld
    @queue = :worlds_to_import

    def self.perform(user_id)
      # code is in worker version of this class
    end
  end
end
