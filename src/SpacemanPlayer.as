package {
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class SpacemanPlayer extends Character {

		private var player_speed:int = PLAYER_SPEED;
		
		private var isCrouched:Boolean;
		private var running:Boolean;
		
		private var standingImg:Image;
		private var runningImg:Image;
		private var jumpingImg:Image;
		private var crouchingImg:Image;
		
		private var interactionRadius:Image;
		
		//ESSENTIALS
		
		private var inventory:Array;
		
		//STATS
		private var strength:int;
		private var intelligence:int;
		private var dexterity:int;
		private var agility:int;
		
		public function SpacemanPlayer(position:Point) {
			x = position.x;
			y = position.y;
			
			PLAYER_SPEED = 120;
			player_speed = PLAYER_SPEED;
			JUMP = 450;
			
			health = 100;
			hunger = 100;
			
			standingImg = new Image(Assets.SPACEMAN_STANDING);
			runningImg = new Image(Assets.SPACEMAN_RUNNING);
			jumpingImg = new Image(Assets.SPACEMAN_JUMPING);
			crouchingImg = new Image(Assets.SPACEMAN_CROUCHING);
			
			graphic = standingImg;
			
			Input.define("Jump", Key.SPACE, Key.W);
			Input.define("Crouch", Key.S)
			
			this.setHitbox(Image(graphic).width, Image(graphic).height, 0, 0);
		
			isCrouched = false;
			running = false;
			
			animations = new Animations();
			super(position, health, hunger);

		}
		
		override public function update():void {
			
			updateGraphic();
			updateMovement();
			shoot();
			debug();
			checkForEnemyCollision();
				
			if (damageTimer > 0) damageTimer--;

			super.update();
		}
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void {
			if (Input.mousePressed) {
				var bullet_speed:int = 500;
				var initX:int;
				if (facingLeft) initX = x - 10;
				else initX = x + Image(graphic).width + 10;
				var initPos:Point = new Point(initX, y + halfHeight - 20);
				var destination:Point = new Point(Input.mouseX + FP.camera.x - 10, Input.mouseY + FP.camera.y - 10);
				var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
				
				var len:Number = cLength(initPos, destination);
				speed.x = (speed.x / len) * bullet_speed;
				speed.y = (speed.y / len) * bullet_speed;
				FP.world.add(new Projectile(initPos.x, initPos.y, speed.x, speed.y));
			}
		}
		
		
		protected function crouch():void {
			if(onGround && isCrouched){
				player_speed = PLAYER_SPEED/2;
			} else {
				player_speed = PLAYER_SPEED;
			}
			//updateGraphic()
		}
		
		private function updateGraphic():void {
			/*
			//TODO: when the player's graphic and hitbox change, parts of the new
			//graphic might extend into a solid surface.  Make sure this gets handled
			//whenever his graphic changes.
			if (running && onGround) {
				graphic = runningImg;
				this.setHitbox(50, 58, 0, 0);
			} else {
				graphic = standingImg;
				this.setHitbox(28, 58, 0, 0);
			}
			if (!onGround) {
				graphic = jumpingImg;
				this.setHitbox(32, 53, 0, 0);
			}
			if(isCrouched && onGround){
				graphic = crouchingImg;
				this.setHitbox(29, 31, 0, 0);
			}
			*/
			
			if (Input.mouseX < x + halfWidth - FP.camera.x) facingLeft = true;
			else facingLeft = false;
			
			if (facingLeft) Image(graphic).flipped = true;
			else Image(graphic).flipped = false;
			
		}
		
		
		override protected function updateMovement():void {
			
			super.updateMovement();
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//CHECK PLAYER INPUT
			
			//WSAD: MOVEMENT
			if (Input.check(Key.A)) {
				xInput -= 1;
				running = true;
			} else {
				running = false;
			}
			if (Input.check(Key.D)) {
				xInput += 1;
				running = true;
			} else {
				if (!running) {
					running = false;
				}
			}
			if (Input.pressed("Jump")) {
				jump();
			}
			if (Input.check("Crouch")) {
				isCrouched = true;
				crouch();
			} else {
				isCrouched = false;
				crouch();
			}
			
			velocity.x = player_speed * xInput;

		}
		
		private function debug():void {
			//DEBUG: increase hunger
			if (Input.pressed(Key.U)) {
				changeHunger(-10);
			}			
			//DEBUG: decrease hunger
			if (Input.pressed(Key.Y)) {
				changeHunger(10);
			}
			//DEBUG: take damage
			if (Input.pressed(Key.J)) {
				changeHealth(-10);
			}
			
			//DEBUG: heal
			if (Input.pressed(Key.H)) {
				changeHealth(10);
			}
		}
		
		//tentative idea: getHurt includes enemy-inflicted damage-
		//specific animations, takeDamage displays only the default,
		//i.e. red flash.
		private function getHurt(damage:int):void{
			trace("player hit!");
			if (damageTimer == 0) {
				takeDamage(10);
				damageTimer = 60;
			}
			//Jump up
		}
		
	}
}