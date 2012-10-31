package ui {

	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	public class Button extends Entity
	{
		protected const NORMAL:int = 0;
		protected const HOVER:int = 1;
		protected const DOWN:int = 2;
		
		protected var normal:Graphic;
		protected var hover:Graphic;
		protected var down:Graphic;
		
		protected var clicked:Boolean;
		protected var label:Text;
		
		public var callback:Function;
		public var params:Object;
		public var graphics:Object;
		
		public function Button(x:Number=0, y:Number=0, text:String = "", callback:Function = null, params:Object = null, graphics:Object = null)
		{
			super(x, y);
			this.callback = callback;
			this.params = params;
			this.graphics = graphics;
			
			var normalStamp:Stamp;
			if (graphics != null) {
				normalStamp = graphics["normal"];
				hover = new Stamp(graphics["hover"]);
				down = new Stamp(graphics["down"]);
			} else {
				normalStamp  = new Stamp(Assets.BUTTON);
				hover = new Stamp(Assets.BUTTON_HOVER);
				down = new Stamp(Assets.BUTTON_DOWN);
			}
			
			normal = normalStamp;
			  
			label = new Text(text, 10, 0, { size: 16, color: 0x000000, width: normalStamp.width - 30, wordWrap: true, align: "center" } );
			label.y = (normalStamp.height - label.textHeight) * 0.5;
			
			graphic = normal;
			setHitboxTo(normalStamp);
		}
		
		override public function update():void
		{
			super.update();
			
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				if (Input.mousePressed) clicked = true;
				
				if (clicked) changeState(DOWN);
				else changeState(HOVER);
				
				if (clicked && Input.mouseReleased) click();
			}
			else
			{
				if (clicked) changeState(HOVER);
				else changeState(NORMAL);
			}
			
			if (Input.mouseReleased) clicked = false;
		}
		
		protected function click():void
		{
			if (callback != null)
			{
				if (params != null) callback(params);
				else callback();
			}
		}
		
		protected function changeState(state:int = 0):void
		{
			switch(state)
			{
				case NORMAL:
					graphic = normal;
					break;
				case HOVER:
					graphic = hover;
					break;
				case DOWN:
					graphic = down;
					break;
			}
		}
		
		protected function renderGraphic(graphic:Graphic):void
		{
			if (graphic && graphic.visible)
			{
				if (graphic.relative)
				{
					_point.x = x;
					_point.y = y;
				}
				else _point.x = _point.y = 0;
				_camera.x = world ? world.camera.x : FP.camera.x;
				_camera.y = world ? world.camera.y : FP.camera.y;
				graphic.render(renderTarget ? renderTarget : FP.buffer, _point, _camera);
			}
		}
		protected var _point:Point = FP.point;
		protected var _camera:Point = FP.point2;
		
		override public function render():void
		{
			super.render();
			
			renderGraphic(label);
		}
	}
}