package
{
	import flash.display.BitmapData;
	import flash.display.ColorCorrection;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
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
		
		private var bmp:BitmapData;
		private var rect:Rectangle;
		private var bmpMask:Image;
		
		private var screenRect:Rectangle;
		private var offLeft:int;
		private var offTop:int;
		private var lightRadius:int;
		private var p:SpacemanPlayer;
		
		private var _w:GameWorld;
		private var time:String; //"Day" or "Night"
		
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
			
			image = Image.createRect(FP.screen.width, FP.screen.height, dayColor, dayOpacity);
			
			_w = w;
			
			graphic = image;
			initTimeCycle();
			
			p = _w.getPlayer();
			lightRadius = 100;
			
			rect = new Rectangle();
			screenRect = new Rectangle();
			bmp = new BitmapData(FP.screen.width, FP.screen.height, true, 0);
			rect.left = screenRect.left = 0;
			rect.top = screenRect.top = 0;
			rect.width = screenRect.width = FP.screen.width;
			rect.height = screenRect.height = FP.screen.height;
			bmp.fillRect(rect, 0xEEFFFFFF);
			bmpMask = new Image(bmp);
			image.drawMask = bmp;
			
			layer = -600;
		}
		
		public function initTimeCycle():void {
			onDay();
		}
		
		override public function update():void {
			if (time == "Night") drawLightSource();
			dayNightCycle();
		}
		
		private function drawLightSource():void {
			bmp.fillRect(screenRect, 0xFFFFFFFF);
			offLeft = p.x - FP.camera.x + (_w.getPlayer().width / 2);
			offTop = p.y - FP.camera.y + (_w.getPlayer().height / 2) - 20;
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 3, 0xaaffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 6, 0x99ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 9, 0x88ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 12, 0x77ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 15, 0x66ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 18, 0x55ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 21, 0x44ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 24, 0x33ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 27, 0x22ffffff);
			drawBitmapCircle(bmp, offLeft, offTop, lightRadius - 30, 0x11ffffff);
			bmpMask = new Image(bmp);
			image.drawMask = bmp;
		}
		
		private function dayNightCycle():void {
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
			time = "Day";
			timeTween = new ColorTween(onDay);
			timeTween.tween(dawnLength, nightColor, dayColor, nightOpacity, dayOpacity);
			addTween(timeTween, true);	
		}
		
		public function onDusk():void {
			time = "Night";
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
		
		private function drawBitmapCircle(target:BitmapData, cX:Number, cY:Number, r:Number, color:Number):void {
			var x:Number = 0;
			var y:Number = 0;
			var r2:Number = r * r;
			for (x=1; x<r; x++) {
				y = Math.ceil(Math.sqrt(r2 - x*x));
				rect.topLeft = new Point(cX-x, cY-y);
				rect.size = new Point(2*x, 2*y);
				target.fillRect(rect, color);
			}
		}
		
	}
}