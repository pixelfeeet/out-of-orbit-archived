package {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;

	public class Animations {
		private var e:Entity;
		private var counter:int;
		
		public function Animations() {
			counter = -1;
		}
		
		//THIS NEEDS TO GET REPLACED WITH TWEEN-BASED ANIMATION
		public function hurtAnimation(_e:Entity):void {
			e = _e;
			var fadeHurtTween:VarTween = new VarTween(onCompleteFlash);
			fadeHurtTween.tween(e.graphic as Image, "alpha", 0.5, 0.1);
			e.addTween(fadeHurtTween, true);
		}
		
		public function onCompleteFlash():void {
			var fadeHurtTween:VarTween = new VarTween();
			fadeHurtTween.tween(e.graphic as Image, "alpha", 1.0, 0.1);
			e.addTween(fadeHurtTween, true);
		}
		
	}
}