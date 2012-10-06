package
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;

	public class Character extends Entity {
		
		protected const GRAVITY:int = 8;
		protected var PLAYER_SPEED:int;
		protected var JUMP:int;
		
		protected var acceleration:Point;
		public var velocity:Point;
		
		protected var health:int;
		protected var maxHealth:int;
		protected var minHealth:int;
		
		protected var hunger:int;
		protected var maxHunger:int;
		protected var minHunger:int;
		
		protected var onGround:Boolean;
		
		protected var animations:Animations;
		
		protected var damageTimer:int;
		
		protected var hungerTimer:int;
		
		protected var facingLeft:Boolean;
		
		protected var xSpeed:int;
		
		public function Character(_position:Point , _health:int = 100, _hunger:int = -1) {
			
			super();
			
			x = _position.x;
			y = _position.y;
			
			acceleration = new Point();
			velocity = new Point();
			
			animations = new Animations;

			onGround = false;
			
			//ESSENTIALS
			health = _health;
			maxHealth = health;
			minHealth = 0;
			damageTimer = 0;
			
			hunger = _hunger;
			maxHunger = hunger;
			minHunger = 0;
			hungerTimer = 0;
			
		}
		
		override public function update():void {
			updateMovement();
			updateCollision();
			checkForDamage();
			if (hunger != -1) updateHunger();
			super.update();
		}
		
		protected function updateCollision():void {
			
			//TODO: don't let character move offscreen.
			// or do?
			
			//HORIZONTAL MOVEMENT
			x += velocity.x * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.x) > 0){
					//moving to the right
					velocity.x = 0;
					
					x = Math.floor(x / 32) * 32;
				} else {
					//moving the left
					velocity.x = 0;
					x = Math.floor(x/32) * 32 + 32;
				}
			}
			
			// VERTICAL MOVEMENT
			y += velocity.y * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.y) > 0){
					//moving down
					calcFallDamage(velocity.y);
					y = Math.floor(y / 32) * 32 + Math.abs((height % 32) - 32);
					onGround = true;
				} else {
					//moving up
					velocity.y = 0;
					y = Math.floor(y / 32) * 32 + 32;
					onGround = false;
				}
			}
			
		}
		
		protected function calcFallDamage(_v:int):void {
			var damageVelocity:int = 700;
			if (_v - damageVelocity > 0 ) {
				_v-= damageVelocity;
				while(_v > 0) {
					takeDamage(5);
					_v -= 50;
				}
			}
			velocity.y = 0;
		}
		
		private function updateHunger():void {
			if (hungerTimer < 60 * 5) { //5 seconds
				hungerTimer++;
			} else {
				hungerTimer = 0;
				if (hunger > 0) increaseHunger(1);
				else takeDamage(10);
			}
		}
		
		protected function updateMovement():void{	
			velocity.x = xSpeed;
			acceleration.y = GRAVITY;
			velocity.y += acceleration.y;
		}
		
		protected function checkForDamage():void {
			var bullet:Projectile = collide("bullet", x, y) as Projectile;
			
			if (bullet) {
				bullet.destroy();
				takeDamage(bullet.getDamagePoints());
			}
		}
		
		//ACTIONS
		protected function jump():void {
			if (onGround){
				velocity.y = -JUMP;
				onGround = false;
			}
		}
		
		//ATTACK
		protected function attack():void { }
		protected function melee():void { }
		
		protected function shoot():void {
			var bullet_speed:int = 100;
			var initPos:Point = new Point(0,0);
			var destination:Point = new Point (x, y);
			var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
			
			var len:Number = cLength(initPos, destination);
			speed.x = (speed.x / len) * bullet_speed;
			speed.y = (speed.y / len) * bullet_speed;
			FP.world.add(new Projectile(initPos.x, initPos.y, speed.x, speed.y));
		}
		
		protected function increaseHunger(addedHunger:int):void{
			changeHunger(-addedHunger);
			//hunger animation goes here?
		}
		
		protected function takeDamage(damage:int):void{
			changeHealth(-damage);
			//Damage animation logic goes here
			animations.hurtAnimation(this);
		}
		
		//GETTER FUNCTIONS
		public function getVelocity():Point {
			return velocity;
		}
		
		public function getHealth():int {
			return health;
		}
		
		public function getHunger():int {
			return hunger;
		}
		
		//SETTER FUNCTIONS
		public function changeHunger(newHunger:int):void {
			if (newHunger > 0) {
				if (hunger < maxHunger && hunger + newHunger <= maxHunger) hunger += newHunger;
				else hunger = maxHunger;
			} else {
				if (hunger > minHunger && hunger + newHunger > minHunger) hunger += newHunger;
				else hunger = minHunger;
			}
		}
		
		public function changeHealth(newHealth:int):void {
			if(newHealth > 0) {
				if (health < maxHealth && health + newHealth <= maxHealth) health += newHealth;
				else health = maxHealth;
			} else {
				if (health > minHealth && health + newHealth > minHealth) health += newHealth;
				else health = minHealth;
			}
		}
		
		
		
		//GEOMETRY STUFF.  If enough of this amasses
		//it should go in its own class.
		protected function cLength(a:Point, b:Point):Number {
			return Math.sqrt(((b.x - a.x) * (b.x - a.x)) + (b.y - a.y) * (b.y - a.y));
		}
		
		protected function pythagoras(p:Point):Number {
			return Math.sqrt(p.x * p.x + p.y * p.y);
		}
		
		protected function getDistanceBetween(v:Vector):Number{
			return 0;
		}
	}
}