package NPCs {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Entity;
	import flash.utils.getDefinitionByName;
	
	public class NPC extends Character {
		public var respawning:Boolean;
		public var eliminated:Boolean;
		public var behavior:Function;
		public var dropItems:Array;
		public var expValue:int;
		public var label:String;
		
		protected var movementTimer:int;
		public var movementFrequency:int;
		
		public var enemy_destroy:Sfx;
		
		public static var label:String = "generic_NPC";
		
		public function NPC(_position:Point = null, _health:int=100, _hunger:int=-1) {
			if(!_position) _position = new Point(0,0);
			super(_position, _health, _hunger);
			PLAYER_SPEED = 50;
			JUMP = 300;
			dropItems = generateDropItems();
			expValue = 2;
			
			health = 40;
			hunger = _hunger;
			
			respawning = true;
			eliminated = false;
			
			movementFrequency = 100;
			movementTimer = movementFrequency;
			
			graphic = Image.createRect(30, 30, 0xffaa88, 0.5);
			setHitboxTo(graphic);
			initBehavior();
			
			//Sounds
			enemy_destroy = new Sfx(Assets.ENEMY_DESTROY);
		}
		
		override public function update():void {
			behavior();
			super.update();
		}
		
		protected function initBehavior():void {
			behavior = function():void {}
		}
		
		protected function generateDropItems():Array{
			var f:InteractionItem = GameWorld.interactionItems.food;
			return [f];
		}
		
		override protected function takeDamage(damage:int):void {
			super.takeDamage(damage);
			//TODO: destroy animation
			if (health <= 0) destroy();
		}
		
		public function setMovementFrequency(n:int):void {
			movementFrequency = n;
			movementTimer = movementFrequency;
		}
		
		public function destroy():void {
			
			for (var i:int = 0; i < dropItems.length; i++){
				if (dropItems[i].type == "InteractionItem") {
					var item:InteractionItem = new InteractionItem();
					item.getPropertiesFrom(dropItems[i], new Point(x + ((i + 1) * 10), y + i));
					FP.world.add(item);
				} else {
					var myClass:Class = getDefinitionByName(dropItems[i].toString()) as Class;

					var anItem:Entity = new myClass();
					var p:Point = new Point(x + ((i + 1) * 10), y + i);
					anItem.x = p.x;
					anItem.y = p.y;

					trace("The new item is: " + anItem);
					FP.world.add(anItem);
				}
				
			}
			GameWorld.player.gainExperience(expValue);
			enemy_destroy.play();
			FP.world.remove(this);
			if (!respawning) eliminated = true;
		}
		
		public function getBehavior():Function {
			return behavior;	
		}
		
		public function randomRange(max:Number, min:Number = 0):Number {
			return Math.random() * (max - min) + min;
		}

	}
}