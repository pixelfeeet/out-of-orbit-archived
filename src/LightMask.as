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
	
	import utilities.Settings;
	
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
		
		private var updateFreq:int;
		private var updateTimer:int;
		
		public function LightMask(w:GameWorld, x:Number=0, y:Number=0) {
			super(x, y);
			//TODO: Make this lightmask the size of the screen, rather than of the level,
			//and fix its positions
			dayLength = nightLength = 5; //seconds
			duskLength = dawnLength = 5; //seconds
			dayTimer = -1;
			nightTimer = -1;
			
			dayColor = 0x120020;
			nightColor = 0x120020;
			
			dayOpacity = 0.0;
			nightOpacity = 0.5;
			
			updateFreq = Settings.FRAMERATE; //1 update/second
			updateTimer = updateFreq;
			
			image = Image.createRect(FP.screen.width, FP.screen.height, dayColor, dayOpacity)
			graphic = image;
			initTimeCycle();
			
			layer = -600;
		}
		
		public function initTimeCycle():void {
			onDay();
		}
		
		override public function update():void {
			x = FP.camera.x;
			y = FP.camera.y;
			if (updateTimer <= 0) {
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
				updateTimer = updateFreq;
			} else {
				updateTimer--;
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
		
	}
}