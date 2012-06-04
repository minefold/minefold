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
            options: {'Latest' => 'HEAD', '12w21b' => '12w21b'},
            default: 'HEAD',
            label: 'Minecraft Version',
            hint: 'Use Latest for the current version of Minecraft',
            group: :admin
          }]
      ),

    ]
  end

  def self.find id
    all.find {|f| f.id == id }
  end
end