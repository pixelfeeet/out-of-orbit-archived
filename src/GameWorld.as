package {
	
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class GameWorld extends World {
		[Embed(source = 'assets/cave.tmx', mimeType = "application/octet-stream")] private static const DEFAULT_MAP:Class;
		
		private var cameraXSpeed:int;
		private var cameraYSpeed:int;
		
		private var cameraXOffset:int;
		private var cameraYOffset:int;
		
		public static var player:SpacemanPlayer;
		public static var hud:HUD;
		
		public function GameWorld() {
		
			
			player = new SpacemanPlayer(new Point(400, 100));
			add(player);
			add(new Level(DEFAULT_MAP))
			add(new InteractionItem(300, 100));
			add(new Cursor());

			var enemy:Enemy = new Enemy(new Point(200, 200), 60);
			enemy.targetCharacter = player;
			add(enemy);
			
		
			cameraXSpeed = player.velocity.x / 100;
			cameraYSpeed = player.velocity.y / 80;
			
			cameraXOffset = 200;
			cameraYOffset = 150;
		
			followPlayer();
			//adjustToPlayer();
			
			//UI
			hud = new HUD(player);
			add(hud)
		}
		
		override public function update():void {
			followPlayer();
			//adjustToPlayer();
			super.update();
		}
		
		private function followPlayer():void {

			cameraXSpeed = player.velocity.x / 50;
			cameraYSpeed = player.velocity.y / 50;
			
			//HORIZONTAL SCROLLING
			if(player.x - FP.camera.x < cameraXOffset) {
				if (FP.camera.x > 0) FP.camera.x += cameraXSpeed;
			} else if ((FP.camera.x + FP.width) - (player.x + player.width) < cameraXOffset) {
				if (FP.camera.x + FP.width < 1280) FP.camera.x += cameraXSpeed;
			}
			
			//VERTICAL SCROLLING
			if(player.y - FP.camera.y < cameraYOffset) {
				if (FP.camera.y > 0) FP.camera.y += cameraYSpeed;
			} else if ((FP.camera.y + FP.height) - (player.y + player.height) < cameraYOffset) {
				if (FP.camera.y + FP.height < 1280) FP.camera.y += cameraYSpeed;
			}
		}
		
		private function adjustToPlayer():void{
			var newCameraX:int = (player.x + player.width/2) - FP.width / 2;
			var newCameraY:int = (player.y + player.height/2) - FP.height / 2;
			
			if (newCameraX < 0) newCameraX = 0;
			else if (newCameraX + FP.width > 1280) newCameraX = 1280 - FP.width;
			
			if (newCameraY < 0) newCameraY = 0;
			else if (newCameraY + FP.height > 1280) newCameraY = 1280 - FP.height;
			
			FP.camera.x = newCameraX;
			FP.camera.y = newCameraY;
		}
		
		public function getPlayer():SpacemanPlayer {
			return player;	
		}
	}
	
}