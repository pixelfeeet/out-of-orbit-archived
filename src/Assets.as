package {
	import net.flashpunk.Entity;
	
	public class Assets extends Entity {
		
		//Tilesets
		[Embed(source = 'assets/cave_tileset.png')] public static const CAVE_TILESET:Class;
		[Embed(source = 'assets/space_tileset.png')] public static const SPACE_TILESET:Class;
		
		//Levels
		[Embed(source = 'assets/cave.tmx', mimeType = "application/octet-stream")] public static const CAVE_MAP:Class;
		[Embed(source = 'assets/cave2.tmx', mimeType = "application/octet-stream")] public static const CAVE_MAP2:Class;
		[Embed(source = 'assets/space.tmx', mimeType = "application/octet-stream")] public static const SPACE_MAP:Class;
		
		//Spaceman parts	
		[Embed(source = 'assets/spaceman_parts/legs_map.png')] public static const LEGS_MAP:Class;
		[Embed(source = 'assets/spaceman_parts/standing_torso.png')] public static const TORSO:Class;
		[Embed(source = 'assets/spaceman_parts/head.png')] public static const HEAD:Class;
		
		//Weapons
		[Embed(source = 'assets/pb.png')] public static const PB:Class;
		[Embed(source = 'assets/rocket.png')] public static const ROCKET_IMAGE:Class;	
		
		//InteractionItems
		[Embed(source = 'assets/food.png')] public static const FOOD_IMG:Class;	
		[Embed(source = 'assets/medipack.png')] public static const MEDIPACK_IMG:Class;	
		
		//Sounds
		[Embed(source = "sounds/land.mp3")] public static const LAND:Class;
		[Embed(source = "sounds/injury.mp3")] public static const INJURY:Class;
		[Embed(source = "sounds/jump.mp3")] public static const JUMP:Class;
		[Embed(source = "sounds/enemy_destroy.mp3")] public static const ENEMY_DESTROY:Class;
		[Embed(source = "sounds/shoot.mp3")] public static const SHOOT:Class;
		[Embed(source = "sounds/blip.mp3")] public static const BLIP:Class;
		[Embed(source = "sounds/ping.mp3")] public static const PING:Class;
		
		//Ambience/Music
		[Embed(source = "sounds/ambience.mp3")] public static const AMBIENCE:Class;
		
		
		//Cursors
		[Embed(source = 'assets/cursor.png')] public static const CURSOR:Class;	
		
	}
}