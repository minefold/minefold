# TODO: this stuff shouldn't be hardcoded

class Funpack < Struct.new(:id, :name, :description, :settings)
  def initialize options
    super(options[:id], options[:name], options[:description], options[:settings])
  end

  def self.all
    [
      Funpack.new(
        id: 'minecraft-vanilla',
        name: 'Minecraft',
        description: 'Minecraft, the way Notch intended it!',
        settings: [{
            name: :minecraft_version,
            type: :radio,
            options: {'Latest' => 'HEAD', '12w23b' => '12w23b'},
            default: 'HEAD',
            label: 'Minecraft Version',
            hint: 'Use Latest for the current version of Minecraft',
            group: :admin
          }]
      ),

      Funpack.new(
        id: 'minecraft-essentials',
        name: 'Minecraft Essentials',
        description: 'Modified Minecraft! With bukkit, Essentials, WorldEdit, WorldGuard and LWC',
        settings: [{
            name: :new_player_can_build,
            type: :radio,
            options: {'Can build' => 'true', 'Read only' => 'false'},
            default: 'true',
            label: 'New Players',
            group: :admin
          }]
      ),

    ]
  end

  def self.find id
    all.find {|f| f.id == id }
  end
  
  def self.default
    find 'minecraft-vanilla'
  end
end