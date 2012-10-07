package {
	
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	import utilities.Camera;
	import utilities.Settings;
	
	
	public class GameWorld extends World {
		[Embed(source = 'assets/cave.tmx', mimeType = "application/octet-stream")] private static const DEFAULT_MAP:Class;
	
		
		public static var player:SpacemanPlayer;
		public static var hud:HUD;
		private var cam:Camera;
		
		public function GameWorld() {
		
			
			player = new SpacemanPlayer(new Point(400, 100));
			add(player);
			add(new Level(DEFAULT_MAP))
			add(new InteractionItem(new Point(300, 100)));
			add(new Cursor());

			var enemy:Enemy = new Enemy(new Point(200, 200), 60);
			enemy.targetCharacter = player;
			add(enemy);

			cam = new Camera();
			
			//UI
			hud = new HUD(player);
			add(hud)
		}
		
		override public function update():void {
			cam.followPlayer();
			super.update();
		}
		
		public function getPlayer():SpacemanPlayer {
			return player;	
		}
	}
	
}