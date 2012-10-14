package {
	import mx.core.ButtonAsset;
	
	import net.flashpunk.World;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;

	public class MainMenuWorld extends World {
		
		[Embed(source = 'assets/PlayGameButton.png')] private const PLAYBUTTON:Class;

		private var _playButton:Button;
		
		public function MainMenuWorld() {
			
			_playButton = new Button(playTheGame, null, 48, 395);
			
			_playButton.setSpritemap(PLAYBUTTON, 312, 22);
			
			add(_playButton);
		}
		
		private function playTheGame():void {
			FP.world = new GameWorld();
			destroy();
		}
		
		public function destroy():void {
			removeAll();
			_playButton = null;
		}

	}
}