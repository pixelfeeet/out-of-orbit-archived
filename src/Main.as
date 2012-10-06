package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class Main extends Engine {
		public function Main() {
			super(640, 480, 60, false);
			FP.world = new GameWorld();
		}
		
		override public function init():void {
			trace("successful loading!");
		}
	}
}