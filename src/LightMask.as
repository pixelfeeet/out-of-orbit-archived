package
{
	import flash.display.ColorCorrection;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.ColorTween;
	
	public class LightMask extends Entity {
		
		public var image:Image
		public var timeTween:ColorTween
		
		public var dayColor:uint;
		public var nightColor:uint;
		
		public var dayLength:Number;
		public var nightLength:Number;
		public var duskLength:int;
		public var dawnLength:int;
		
		public var dayTimer:int;
		public var nightTimer:int;
		
		public var dayOpacity:Number;
		public var nightOpacity:Number;
		
		public function LightMask(w:GameWorld, x:Number=0, y:Number=0) {
			super(x, y);
			
			dayLength = nightLength = 60;
			duskLength = dawnLength = 1;
			dayTimer = -1;
			nightTimer = -1;
			
			dayColor = 0x120020;
			nightColor = 0x120020;
			
			dayOpacity = 0.0;
			nightOpacity = 0.5;
			
			image = Image.createRect(w.currentLevel.width, w.currentLevel.height, dayColor, dayOpacity)
			graphic = image;
			initTimeCycle();
			
			layer = -200;
		}
		
		public function initTimeCycle():void {
			onDay();
		}
		
		override public function update():void {
			if (timeTween) {
				image.color = timeTween.color;
				image.alpha = timeTween.alpha;
			}
			
			if (dayTimer != -1) {
				dayTimer --;
				if (dayTimer == 0) {
					onDusk();
				}
			}
			
			if (nightTimer != -1) {
				nightTimer --;
				if (nightTimer == 0) {
					onDawn();
				}
			}
		}
		
		public function onDawn():void {
			timeTween = new ColorTween(onDay);
			timeTween.tween(dawnLength, nightColor, dayColor, nightOpacity, dayOpacity);
			addTween(timeTween, true);	
		}
		
		public function onDusk():void {
			timeTween = new ColorTween(onNight);
			timeTween.tween(duskLength, dayColor, nightColor, dayOpacity, nightOpacity);
			addTween(timeTween, true);
		}
		
		public function onNight():void {
			nightTimer = nightLength;
		}
		
		public function onDay():void {
			dayTimer = dayLength;
		}
		
		public function resize(_width:int, _height:int):void {
			var currentColor:uint = image.color;
			var currentOpacity:Number = image.alpha;
			image = Image.createRect(_width, _height, currentColor, currentOpacity);
			graphic = image;
		}
	}
}