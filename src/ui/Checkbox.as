package ui
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Text;	
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;

	public class Checkbox extends Button {
		protected var normalChecked:Graphic;
		protected var hoverChecked:Graphic;
		protected var downChecked:Graphic;
		
		public var checked:Boolean = false;
		
		public function Checkbox(x:Number=0, y:Number=0, text:String = "", callback:Function = null, params:Object = null) 
		{
			super(x, y, text, callback, params);
			
			normal = new Image(Assets.CHECKBOX, new Rectangle(0, 0, 30, 30));
			hover = new Image(Assets.CHECKBOX, new Rectangle(30, 0, 30, 30));
			down = new Image(Assets.CHECKBOX, new Rectangle(60, 0, 30, 30));
			
			normalChecked = new Image(Assets.CHECKBOX, new Rectangle(0, 30, 30, 30));
			hoverChecked = new Image(Assets.CHECKBOX, new Rectangle(30, 30, 30, 30));
			downChecked = new Image(Assets.CHECKBOX, new Rectangle(60, 30, 30, 30));
			
			label = new Text(text, 40, 0, { color: 0xFFFFFF, size: 16 } );
			label.y = (Image(normal).height - label.textHeight) * 0.5;
			
			graphic = normal;
			setHitboxTo(normal);
		}
		
		override protected function click():void {
			checked = !checked;
			
			if (callback != null)
			{
				if (params != null) callback(checked, params);
				else callback(checked);
			}
		}
		
		override protected function changeState(state:int = 0):void
		{
			if (checked)
			{
				switch(state)
				{
					case NORMAL:
						graphic = normalChecked;
						break;
					case HOVER:
						graphic = hoverChecked;
						break;
					case DOWN:
						graphic = downChecked;
						break;
				}
			}
			else
			{
				super.changeState(state);
			}
		}
	}
}