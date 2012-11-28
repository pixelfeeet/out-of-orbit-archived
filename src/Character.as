package
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	import utilities.Settings;

	public class Character extends Entity {
		
		protected const GRAVITY:int = 14;
		protected var SPEED:int;
		protected var JUMP:int;
		
		protected var vSpeed:int;
		protected var vGravity:int;
		protected var vJump:int;
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
		
		protected var isInWater:Boolean;
		
		protected var t:int; //Settings.TILESIZE
		
		private var player:SpacemanPlayer;

		
		public function Character(_position:Point , _health:int = 100, _hunger:int = -1) {
			super();
			player = GameWorld.player;
			
			x = _position.x;
			y = _position.y;
			
			acceleration = new Point();
			velocity = new Point();
			vGravity = GRAVITY;
			vSpeed = SPEED;
			vJump = JUMP;
			
			animations = new Animations;

			onGround = false;
			isInWater = false;
			
			//ESSENTIALS
			health = _health;
			maxHealth = health;
			minHealth = 0;
			damageTimer = 0;
			
			hunger = _hunger;
			maxHunger = hunger;
			minHunger = 0;
			hungerTimer = 0;
			
			t = Settings.TILESIZE;	
		}
		
		override public function update():void {
			updateMovement();
			updateCollision();
			updateGraphic();
			if (health != -1) checkForDamage();
			if (hunger != -1) updateHunger();
			
			super.update();
		}
		
		protected function updateGraphic():void {}
		
		protected function updateCollision():void {

			//HORIZONTAL MOVEMENT
			x += velocity.x * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.x) > 0){
					//moving to the right
					velocity.x = 0;
					
					x = Math.floor(x / t) * t;
					while (!collide("level", x + 1, y)){
						x++;
					}
				} else {
					//moving the left
					velocity.x = 0;
					x = Math.floor(x / t) * t + t;
				}
			}
			
			// VERTICAL MOVEMENT
			y += velocity.y * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.y) > 0){
					//moving down
					calcFallDamage(velocity.y);
					velocity.y = 0;
					y = Math.floor(y / t) * t;
					while (!collide("level", x, y + 1)){
						y++;
					}
					if (!onGround) {
						onGround = true;
						land();
					}
				} else {
					//moving up
					velocity.y = 0;
					y = Math.floor(y / t) * t + t;
					onGround = false;
				}
			}
			
		}
		
		protected function land():void{}
		
		protected function calcFallDamage(_v:int):void {
			/*
			var damageVelocity:int = 700;
			var totalDamage:int;
			if (_v - damageVelocity > 0 ) {
				_v-= damageVelocity;
				while(_v > 0) {
					totalDamage += 5;
					_v -= 50;
				}
			}
			takeDamage(totalDamage);
			velocity.y = 0;
			*/
		}
		
		private function updateHunger():void {
			//Todo: if hunger is at 100, stay there for a while
			//and regenerate the players health
			if (hungerTimer < 60 * 5) { //5 seconds
				hungerTimer++;
			} else {
				hungerTimer = 0;
				if (hunger > 0) increaseHunger(1);
				else takeDamage(10);
			}
		}
		
		protected function updateMovement():void{
			if (GameWorld(FP.world).currentLevel.tiles.getTile(x / t, (y / t) + 1) == 20) isInWater = true;
			else isInWater = false;
			
			if (isInWater) {
				vGravity = GRAVITY / 2;
				vSpeed = SPEED / 2;
				vJump = JUMP / 2;
			} else {
				vGravity = GRAVITY;
				vSpeed = SPEED;
				vJump = JUMP;
			}

			//xSpeed = vSpeed;
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
			
			if (GameWorld.player.meleeAttacking &&
				cLength(new Point(x, y), new Point(GameWorld.player.x, GameWorld.player.y)) < 100 &&
				this.type != "Player") {
				var dist:int = 0;
				if (GameWorld.player.isFacingLeft()) {
					dist = GameWorld.player.x - x;
					if (0 <= dist && dist < 100) takeDamage(GameWorld.player.weapon.getDamage());
				} else {
					dist = x - GameWorld.player.x;
					if (0 <= dist && dist < GameWorld.player.weapon.getRange()) takeDamage(GameWorld.player.weapon.getDamage());
				}
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
			//animations.hurtAnimation(this);
		}
		
		//GETTER FUNCTIONS
		public function getVelocity():Point {
			return velocity;
		}
		
		public function getHealth():int { return health; }
		public function getMaxHealth():int { return maxHealth; }
		public function getHunger():int { return hunger; }
		public function getMaxHunger():int { return maxHunger; }
		
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
		
		public function setHealth(h:int):void {
			health = h;
		}
		
		protected function cLength(a:Point, b:Point):Number {
			return Math.sqrt(((b.x - a.x) * (b.x - a.x)) + (b.y - a.y) * (b.y - a.y));
		}
		
		public function setPosition(p:Point):void {
			x = p.x;
			y = p.y;
		}

		
	}
}