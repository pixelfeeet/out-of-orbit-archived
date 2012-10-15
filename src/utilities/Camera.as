package utilities {
	import net.flashpunk.FP;
	
	public class Camera {
		
		private var cameraXSpeed:int;
		private var cameraYSpeed:int;
		
		private var cameraXOffset:int;
		private var cameraYOffset:int;
		
		private var player:SpacemanPlayer;
		
		public function Camera() {
			
			player = GameWorld.player;
			cameraXSpeed = 2;
			cameraYSpeed = 5;
			
			cameraXOffset = 200;
			cameraYOffset = 150;
			
			//adjustToPlayer();
		}
		
		public function followPlayer():void {
		
			//HORIZONTAL SCROLLING
			if(player.x - FP.camera.x < cameraXOffset) {
				if (FP.camera.x > 0) FP.camera.x -= cameraXSpeed;
			} else if ((FP.camera.x + FP.width) - (player.x + player.width) < cameraXOffset) {
				if (FP.camera.x + FP.width < 40 * Settings.TILESIZE) FP.camera.x += cameraXSpeed;
			}
			
			//VERTICAL SCROLLING
			if(player.y - FP.camera.y < cameraYOffset) {
				if (FP.camera.y > 0) FP.camera.y -= cameraYSpeed;
			} else if ((FP.camera.y + FP.height) - (player.y + player.height) < cameraYOffset) {
				if (FP.camera.y + FP.height < 40 * Settings.TILESIZE) FP.camera.y += cameraYSpeed;
			}
		}
		
		public function adjustToPlayer():void{
			var newCameraX:int = (player.x + player.width/2) - FP.width / 2;
			var newCameraY:int = (player.y + player.height/2) - FP.height / 2;
			
			if (newCameraX < 0) newCameraX = 0;
			else if (newCameraX + FP.width > 40 * Settings.TILESIZE) newCameraX = 40 * Settings.TILESIZE - FP.width;
			
			if (newCameraY < 0) newCameraY = 0;
			else if (newCameraY + FP.height > 40 * Settings.TILESIZE) newCameraY = 40 * Settings.TILESIZE - FP.height;
			
			FP.camera.x = newCameraX;
			FP.camera.y = newCameraY;
		}
	}
}