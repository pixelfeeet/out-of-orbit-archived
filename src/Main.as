package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import utilities.Settings;
	
	public class Main extends Engine {
		public function Main() {
			super(Settings.SCREEN_WIDTH, Settings.SCREEN_HEIGHT, Settings.FRAMERATE, false);
			FP.world = new GameWorld();
			//FP.world = new GameWorld();
		}
		
		override public function init():void {
			trace("it works.");
		}
	}
}