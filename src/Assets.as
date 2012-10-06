package {
	import net.flashpunk.Entity;
	
	public class Assets extends Entity {
		
		//Tilesets
		[Embed(source = 'assets/cave_tileset.png')] public static const CAVE_TILESET:Class;
		[Embed(source = 'assets/space_tileset.png')] public static const SPACE_TILESET:Class;
		
		//Spaceman sprites
		[Embed(source = 'assets/spaceman_standing.png')] public static const SPACEMAN_STANDING:Class;
		[Embed(source = 'assets/spaceman_running.png')] public static const SPACEMAN_RUNNING:Class;
		[Embed(source = 'assets/spaceman_jumping.png')] public static const SPACEMAN_JUMPING:Class;
		[Embed(source = 'assets/spaceman_crouching.png')] public static const SPACEMAN_CROUCHING:Class;
		
		[Embed(source = 'assets/rocket.png')] public static const ROCKET_IMAGE:Class;
		
		[Embed(source = 'assets/interaction_radius.png')] public static const INTERACTION_RADIUS:Class;	
		
		public function Assets() { }
	}
}