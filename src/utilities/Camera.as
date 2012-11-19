package utilities {
	import net.flashpunk.FP;
	
	public class Camera {
		
		private var cameraXSpeed:int;
		private var cameraYSpeed:int;
		
		private var cameraXOffset:int;
		private var cameraYOffset:int;
		
		private var player:SpacemanPlayer;
		private var level:Level;
		
		private var lWidth:int;
		private var lHeight:int;
		
		public function Camera(l:Level) {
			
			player = GameWorld.player;
			cameraXSpeed = 2;
			cameraYSpeed = 5;
			
			cameraXOffset = 200;
			cameraYOffset = 150;

			level = l;
			var t:int = Settings.TILESIZE;
			lWidth = level.width / t;
			lHeight = level.height / t;
			trace("w: " + lWidth + ", h: " + lHeight);
			
			//adjustToPlayer();
		}
		
		public function followPlayer():void {
		
			//HORIZONTAL SCROLLING
			if(player.x - FP.camera.x < cameraXOffset) {
				if (FP.camera.x > 0) FP.camera.x -= cameraXSpeed;
			} else if ((FP.camera.x + FP.width) - (player.x + player.width) < cameraXOffset) {
				if (FP.camera.x + FP.width < lWidth * Settings.TILESIZE) FP.camera.x += cameraXSpeed;
			}
			
			//VERTICAL SCROLLING
			if(player.y - FP.camera.y < cameraYOffset) {
				if (FP.camera.y > 0) FP.camera.y -= cameraYSpeed;
			} else if ((FP.camera.y + FP.height) - (player.y + player.height) < cameraYOffset) {
				if (FP.camera.y + FP.height < lHeight * Settings.TILESIZE) FP.camera.y += cameraYSpeed;
			}
		}
		
		public function adjustToPlayer():void{
			var newCameraX:int = (player.x + player.width/2) - FP.width / 2;
			var newCameraY:int = (player.y + player.height/2) - FP.height / 2;
			
			if (newCameraX < 0) newCameraX = 0;
			else if (newCameraX + FP.width > lWidth * Settings.TILESIZE) newCameraX = lWidth * Settings.TILESIZE - FP.width;

			if (newCameraY < 0) newCameraY = 0;
			else if (newCameraY + FP.height > lHeight * Settings.TILESIZE) newCameraY = lHeight * Settings.TILESIZE - FP.height;
			
			FP.camera.x = newCameraX;
			FP.camera.y = newCameraY;
		}
	}
}