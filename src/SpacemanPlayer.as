package {
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class SpacemanPlayer extends Character {
		
		public var player_speed:int = PLAYER_SPEED;
		
		private var isCrouched:Boolean;
		private var running:Boolean;
		
		private var standingImg:Image;
		private var runningImg:Image;
		private var jumpingImg:Image;
		private var crouchingImg:Image;
		
		private var standingTorso:Image;
		private var standingLegs:Image;
		private var pbTorso:Image;
		
		private var interactionRadius:Image;
	
		//ESSENTIALS
		
		//STATS
		private var strength:int;
		private var intelligence:int;
		private var dexterity:int;
		private var agility:int;
		
		private var experience:int;
		private var level:int;
		
		private var display:Graphiclist;
		private var legsMap:Spritemap;

		private var bulletFrequency:int;
		private var bulletTimer:int;
		
		//INVENTORY
		public static var inventory:Inventory;
		public var landSound:Sfx = new Sfx(Assets.LAND_SOUND);
		public var reachDistance:int;
		public var inventoryLength:int;
		
		public function SpacemanPlayer(_position:Point = null) {
			if (!_position) _position = new Point(0, 0);
			x = _position.x;
			y = _position.y;
			
			PLAYER_SPEED = 240;
			player_speed = PLAYER_SPEED;
			JUMP = 580;
			
			health = 100;
			hunger = 100;
			
			bulletFrequency = 10;
			bulletTimer = 0;
			
			standingImg = new Image(Assets.SPACEMAN_STANDING);
			runningImg = new Image(Assets.SPACEMAN_RUNNING);
			jumpingImg = new Image(Assets.SPACEMAN_JUMPING);
			crouchingImg = new Image(Assets.SPACEMAN_CROUCHING);
			
			legsMap = new Spritemap(Assets.LEGS_MAP, 35, 46);
			legsMap.add("running", [0, 1, 0, 2], 5);
			legsMap.add("standing", [0]);
			
			pbTorso = new Image(Assets.PB_TORSO);
			
			pbTorso.originX = 14;
			pbTorso.originY = pbTorso.height;
			
			pbTorso.x = 12;
			pbTorso.y = 30;
			
			standingLegs = new Image(Assets.STANDING_LEGS);
			
			display = new Graphiclist(legsMap, pbTorso);
			standingLegs.y = 19;
			legsMap.y = 19;
			graphic = display;
			
			Input.define("Jump", Key.W);
			Input.define("Crouch", Key.S)
			Input.define("Use", Key.E);
			
			this.setHitbox(32, 64, 0, 0);
			isCrouched = false;
			running = false;
			
			animations = new Animations();
			
			inventoryLength = 14;
			inventory = new Inventory(inventoryLength);
			reachDistance = 100;
			
			experience = 0;
			level = 5;
			
			super(_position, health, hunger);

		}
		
		override public function update():void {
			
			updateGraphic();
			updateMovement();
			shoot();
			debug();
			checkForEnemyCollision();
				
			if (damageTimer > 0) damageTimer--;
			if (bulletTimer > 0) bulletTimer--;

			if (Input.pressed("Use")){
				onUse();
			}
			super.update();
		}
		
		private function onUse():void {
			for (var i:int = 0; i < HUD.inventoryBoxes.length; i++){
				if (HUD.inventoryBoxes[i].isSelected()) {
					trace("#" + i + " is selected");
					if (inventory.inventory[i] != null) inventory.inventory[i].onUse();
					else trace("nothing to use");
					return;
				}
			}
			trace("no selected things");
		}
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void {
			if (Input.mouseDown && !Input.check(Key.SHIFT) && bulletTimer == 0) {
				var bullet_speed:int = 500;
				var initX:int;
				if (facingLeft) initX = x;
				else initX = x + pbTorso.width;
				var initPos:Point = new Point(initX, y + halfHeight - 20);
				var destination:Point = new Point(Input.mouseX + FP.camera.x - 10, Input.mouseY + FP.camera.y - 10);
				var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
				
				var len:Number = cLength(initPos, destination);
				speed.x = (speed.x / len) * bullet_speed;
				speed.y = (speed.y / len) * bullet_speed;
				FP.world.add(new Projectile(initPos.x, initPos.y, speed.x, speed.y));
				bulletTimer = bulletFrequency;
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
			
			if(running)legsMap.play("running");
			else legsMap.play("standing");
			
			if (Input.mouseX < x + halfWidth - FP.camera.x) facingLeft = true;
			else facingLeft = false;
			
			if (facingLeft) { 
				for (var i:int = 0; i < display.count; i++) {
					Image(display.children[i]).flipped = true;
				}
				pbTorso.originX = pbTorso.width - 11;
				pbTorso.x = 24;
			} else {
				for (var j:int = 0; j < display.count; j++) {
					Image(display.children[j]).flipped = false;
				}
				pbTorso.originX = 11;
				pbTorso.x = 12;
			}

			var angle:Number = FP.angle(Math.abs(FP.camera.x - x), Math.abs(FP.camera.y - y), Input.mouseX, Input.mouseY);
			var f:Boolean = Image(display.children[1]).flipped;
			if(f) angle += 180;
			
			trace(angle);
			//player is bending down too low
			if (f && angle > 410) angle = 410;
			else if (!f && 270 <= angle && angle < 310) angle = 310;
			
			//player is bending back too much
			if (f && angle < 310) angle = 310;
			else if (!f && angle > 45 && angle < 90) angle = 45;
			

			Image(display.children[1]).angle = Math.floor(angle); //torso
			
		}
			
		override protected function updateMovement():void {
			
			super.updateMovement();
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//CHECK PLAYER INPUT
			
			//WSAD: MOVEMENT
			if (Input.check(Key.A)) {
				xInput -= 1;
				if(!Input.check(Key.D)) running = true;
			} else {
				running = false;
			}
			if (Input.check(Key.D)) {
				xInput += 1;
				if(!Input.check(Key.A)) running = true;
			} else {
				if (!running) {
					running = false;
				}
			}
			
			if (Input.pressed(Key.D) || Input.pressed(Key.A)) {

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
			
			if (Input.released("Crouch")) {
				while(collide("level", x, y + 1)) {
					y -= 10;
				}
			}
			
			velocity.x = player_speed * xInput;

		}
		
		private function land():void {
			calcFallDamage(velocity.y);
			if(!onGround){
				onGround = true;
			}
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
			
			//DEBUG: remove last item from inventory
			if (Input.pressed(Key.DIGIT_1)) {
				inventory.removeLastItemFromInventory();
			}
			
			//DEBUG: addItemToInventory
			if (Input.pressed(Key.DIGIT_2)) {
				inventory.addItemToInventory();
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
		
		//INVENTORY
		public function getInventory():Inventory {
			return inventory;
		}
		
		//EXPERIENCE
		public function gainExperience(_exp:int):void {
			experience += _exp;
			checkForLevelUp();
		}
		
		private function checkForLevelUp():void {
			if (experience % 20 == 0) levelUp();
		}
		
		private function levelUp():void {
			level++;
		}
		
		public function getPlayerExperience():int {
			return experience;
		}
		
		public function getLevel():int {
			return level;
		}
	}
}