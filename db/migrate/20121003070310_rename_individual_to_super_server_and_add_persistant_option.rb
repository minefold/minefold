class RenameIndividualToSuperServerAndAddPersistantOption < ActiveRecord::Migration
  
  def change
    change_table :games do |t|
      t.rename :individual, :super_servers
      t.boolean :persistant_data, :null => false, default: false
    end
    
    change_table :servers do |t|
      t.rename :individual, :super_server
      t.remove :funpack
    end
  end
  
end
