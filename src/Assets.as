package {
	import net.flashpunk.Entity;
	
	public class Assets extends Entity {
		
		//Tilesets
		[Embed(source = 'assets/cave_tileset.png')] public static const CAVE_TILESET:Class;
		[Embed(source = 'assets/space_tileset.png')] public static const SPACE_TILESET:Class;
		
		//Levels
		[Embed(source = 'assets/cave.tmx', mimeType = "application/octet-stream")] public static const CAVE_MAP:Class;
		[Embed(source = 'assets/space.tmx', mimeType = "application/octet-stream")] public static const SPACE_MAP:Class;
		
		//Spaceman sprites
		[Embed(source = 'assets/spaceman_standing.png')] public static const SPACEMAN_STANDING:Class;
		[Embed(source = 'assets/spaceman_running.png')] public static const SPACEMAN_RUNNING:Class;
		[Embed(source = 'assets/spaceman_jumping.png')] public static const SPACEMAN_JUMPING:Class;
		[Embed(source = 'assets/spaceman_crouching.png')] public static const SPACEMAN_CROUCHING:Class;
		
		[Embed(source = 'assets/rocket.png')] public static const ROCKET_IMAGE:Class;
		
		[Embed(source = 'assets/example_item.png')] public static const EXAMPLE_ITEM:Class;		
		[Embed(source = 'assets/interaction_radius.png')] public static const INTERACTION_RADIUS:Class;	
		
		//Sounds
		[Embed(source = "sounds/land.mp3")] public static const LAND_SOUND:Class;
		
		public function Assets() { }
	}
}