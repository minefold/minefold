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
        description:
%Q{
**Original Minecraft**, the way Notch intended!
},
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
        name: 'Minecraft Essentials Pack (Beta)',
        description:
%Q{
Hi beta tester! This pack is **Bukkit enabled**

Included plugins:

 * [Essentials](http://dev.bukkit.org/server-mods/essentials/)
 * [WorldEdit](http://dev.bukkit.org/server-mods/worldedit/)
 * [WorldGuard](http://dev.bukkit.org/server-mods/worldguard/)
 * [LWC](http://dev.bukkit.org/server-mods/lwc/)

**Please report any issues you have!**
},
        settings: []
        # {
        #     name: :new_player_can_build,
        #     type: :radio,
        #     options: {'Can build' => 'true', 'Read only' => 'false'},
        #     default: 'true',
        #     label: 'New Players',
        #     group: :admin
        #   }]
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