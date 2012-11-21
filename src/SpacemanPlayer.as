package {
	
	import Inventory.Inventory;
	
	import Weapons.Weapon;
	
	import data.Weapons;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.HUD;
	
	import utilities.Settings;
	
	public class SpacemanPlayer extends Character {
		
		public var player_speed:int = PLAYER_SPEED;
		
		private var isCrouched:Boolean;
		private var running:Boolean;
		
		private var standingTorso:Image;
		private var standingLegs:Image;
		private var torso:Image;
		private var head:Image;
		private var weaponImg:Image;
		
		private var display:Graphiclist;
		private var legsMap:Spritemap;
		
		//Stats
		public var strength:int;
		public var intelligence:int;
		public var dexterity:int;
		public var agility:int;
		
		public var statsList:Object;
		
		private var experience:int;
		private var level:int;

		private var bulletFrequency:int;
		private var bulletTimer:int;
		private var bulletSource:Point;
		
		public var allocationPoints:int;
		public var levelUpTime:Boolean;
		
		private var flying:Boolean;
		
		//Inventory
		public static var inventory:Inventory;
		public static var weaponInventory:WeaponInventory;
		public var reachDistance:int;
		public var inventoryLength:int;
		public var weaponInventoryLength:int;
		//tentitive currency name
		public var scraps:int;
		
		//Exchange rate
		public var constructionRate:Number;
		public var recycleRate:Number;
		
		//Combat/Weapons
		public var equipped:Boolean;
		public var weapon:Weapon;
		public var ammunition:int;
		
		public var weapons:Weapons;
		public var meleeAttacking:Boolean;
		
		//Sounds
		public var landSound:Sfx;
		public var injurySound:Sfx;
		public var jumpSound:Sfx;
		public var shootSound:Sfx;
		public var walkSound:Sfx;
		
		//World
		private var w:GameWorld;
		
		public function SpacemanPlayer(_world:GameWorld, _position:Point = null) {
			
			//Essentials
			maxHealth = 100;
			maxHunger = 100;
			health = 100;
			hunger = 100;
			
			if (!_position) _position = new Point(0, 0);
			w = _world;
			
			super(_position, health, hunger);
			
			type = "Player";
			
			PLAYER_SPEED = 840;
			player_speed = PLAYER_SPEED;
			JUMP = 580;
			
			//Stats
			strength = 10;
			intelligence = 10;
			dexterity = 10;
			agility = 10;
			
			statsList = {"strength": strength, "agility": agility,
				"intelligence": intelligence, "dexterity": dexterity};
			
			/*
			Graphiclist components
			*/
			//Weapons/Combat
			weapons = new Weapons(this);
			weapon = weapons.unarmed;
			meleeAttacking = false;
			
			bulletFrequency = 10;
			bulletTimer = 0;

			equipWeapon(weapon);
			FP.world.add(weapon);
			
			//Legs
			legsMap = new Spritemap(Assets.LEGS_MAP, 42, 34)
			legsMap.add("running", [0, 1, 2, 3, 4], 18);
			legsMap.add("backwards_running", [4, 3, 2, 1, 0], 18);
			legsMap.add("standing", [0]);
			legsMap.add("jumping", [5]);
			legsMap.y = (Settings.TILESIZE * 2) - legsMap.height + 2;
			
			//Torso
			torso = new Image(Assets.TORSO);
			torso.originX = 5;
			torso.originY = torso.height - 10;
			torso.x = 12;
			torso.y = 57;
			
			//Head
			head = new Image(Assets.HEAD);
			head.originX = 12;
			head.originY = 12;
			head.x = 26;
			head.y = 14;
			
			display = new Graphiclist(weaponImg, legsMap, torso, head);
			graphic = display;
			
			this.setHitbox(Settings.TILESIZE, Settings.TILESIZE * 2, 0, 0);
			isCrouched = false;
			running = false;
			
			flying = true;
			
			//Input Definitions
			Input.define("Left", Key.A);
			Input.define("Right", Key.D);
			Input.define("Jump", Key.W);
			Input.define("Use", Key.E);
			Input.define("Toggle Flying", Key.T);
			
			//Inventory
			inventoryLength = 7;
			inventory = new Inventory(inventoryLength);
			reachDistance = 100;
			scraps = 0;
			
			//Stats
			experience = 0;
			level = 5;
			levelUpTime = true;
			allocationPoints = 10;
			
			//Exchange rate
			constructionRate = 1.1;
			recycleRate = 0.9;
			
			//Sound
			landSound = new Sfx(Assets.LAND);
			injurySound = new Sfx(Assets.INJURY);
			jumpSound = new Sfx(Assets.BUMP);
			shootSound = new Sfx(Assets.SHOOT);
			walkSound = new Sfx(Assets.BLIP);
			
			layer = -400 //debug layer
		}
		
		override public function update():void {
			super.update();

			updateGraphic();
			if (!flying) updateMovement();
			else debugMovement();
			debug();
			checkForEnemyCollision();
			inventoryButtons();
			
			//combat
			shoot();
			weapon.update();
			if (damageTimer > 0) damageTimer--;

			//Interaction
			if (Input.pressed("Use")) onUse();
			if (Input.pressed("Toggle Flying")) toggleFlying();
		}
		
		override protected function updateCollision():void {
			//DEBUG: No collisiton detection
			if (!flying) {
				super.updateCollision();
			} else {
				x += velocity.x * FP.elapsed;
				y += velocity.y * FP.elapsed;
			}
		}
		
		public function inventoryButtons():void {
			var boxes:Array = w.hud.inventoryBoxes;
			
			if (Input.pressed(Key.DIGIT_1)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[0])
					w.hud.inventoryBoxes[0]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_2)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[1])
					w.hud.inventoryBoxes[1]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_3)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[2])
					w.hud.inventoryBoxes[2]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_4)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[3])
					w.hud.inventoryBoxes[3]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_5)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[4])
					w.hud.inventoryBoxes[4]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_6)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[5])
					w.hud.inventoryBoxes[5]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_7)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[6])
					w.hud.inventoryBoxes[6]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_8)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[7])
					w.hud.inventoryBoxes[7]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_9)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[8])
					w.hud.inventoryBoxes[8]["box"].select();	
			}
			
			if (Input.pressed(Key.DIGIT_0)) {
				w.hud.deselectAll();
				if (w.hud.inventoryBoxes[9])
					w.hud.inventoryBoxes[9]["box"].select();	
			}
		}
		
		public function equipWeapon(_weapon:Weapon):void {
			weapon = _weapon;
			setWeaponGfx(weapon);
		}
		
		public function setWeaponGfx(_weapon:Weapon):void{
			weaponImg = Image(_weapon.graphic)
			
			if(!facingLeft) weaponImg.originX = _weapon.originX;
			else weaponImg.originX = _weapon.leftOriginX;
			weaponImg.originY = _weapon.originY;
			
			if (!facingLeft) weaponImg.x = _weapon.x;
			else weaponImg.x = _weapon.leftX;
			weaponImg.y = _weapon.y;
			
			if (display) display.children[0] = weaponImg;
		}
		
		private function onUse():void {
			for (var i:int = 0; i < w.hud.inventoryBoxes.length; i++){
				if (w.hud.inventoryBoxes[i]["box"].isSelected()) {
					if (inventory.items[i].length > 0)
						inventory.items[i][inventory.items[i].length - 1].onUse();
					return;
				}
			}
		}
		
		private function toggleFlying():void {
			if (!flying) {
				velocity.x = 0;
				velocity.y = 0;
				xSpeed = 0;
				flying = true;
			} else {
				flying = false;
			}
		}
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void { 
			if (weapon.fireTimer > 0) weapon.fireTimer--;
			if (Input.mouseDown) weapon.shoot();
		}

		private function updateGraphic():void {
			
			//Get the player to face the cursor horizontally
			if (Input.mouseX < x + halfWidth - FP.camera.x) facingLeft = true;
			else facingLeft = false;
			
			//Calculating angles of head and weapon
			if (facingLeft) { 
				for (var i:int = 0; i < display.count; i++) {
					Image(display.children[i]).flipped = true;
				}
				head.originX = 12;
				head.originY = 12;
				head.x = 18;

				weaponImg.originX = weaponImg.width - weapon.leftOriginX;
				weaponImg.x = weapon.leftX;
			} else {
				for (var j:int = 0; j < display.count; j++) {
					Image(display.children[j]).flipped = false;
				}
				head.originX = 12;
				head.originY = 12;
				head.x = 24;
				
				weaponImg.originX = weapon.originX;
				weaponImg.x = weapon.x;
			}
			
			//Play the animation
			if (!onGround){
				legsMap.play("jumping");
			} else if (FP.sign(velocity.x) != 0) {
				if (!facingLeft) {
					if (FP.sign(velocity.x) == 1) legsMap.play("running");
					else legsMap.play("backwards_running");
				} else {
					if (FP.sign(velocity.x) == -1) legsMap.play("running");
					else legsMap.play("backwards_running");
				}
				//if(legsMap.frame == 1) walkSound.play();
			} else {
				legsMap.play("standing");
			}
			
			torso.originX = 22;
			torso.x = 22;

			var angle:Number = FP.angle(Math.abs(FP.camera.x - x), Math.abs(FP.camera.y - y), Input.mouseX, Input.mouseY - 30);
			
			var f:Boolean = Image(display.children[3]).flipped;
			if(f) angle -= 180;
			if(angle > 180) angle += 360;
			
			var headAngle:Number = angle;
			headAngle /= 2;
			
			//player is bending down too low
			if (f && headAngle < -15) headAngle = -15;
			else if (!f && 270 <= headAngle && headAngle < 350) headAngle = 350;
			
			//player is bending back too much
			if (f && headAngle > 15) headAngle = 15;
			else if (!f && headAngle > 15 && headAngle < 90) headAngle = 15;

			Image(display.children[0]).angle = angle; //PB
			Image(display.children[3]).angle = headAngle; //HEAD
		}
			
		override protected function updateMovement():void {
			
			if (!flying) super.updateMovement();
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//WSAD: MOVEMENT
			if (Input.check("Left")) {
				xInput -= 1;
				if(!Input.check("Right")) running = true;
			} else {
				running = false;
			}
			if (Input.check("Right")) {
				xInput += 1;
				if(!Input.check("Left")) running = true;
			} else {
				running = false;
			}
			
			//Jump = W
			if (Input.pressed("Jump")) jump();

			velocity.x = player_speed * xInput;

		}
		
		private function debugMovement():void {
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//WSAD: MOVEMENT
			if (Input.check("Left")) {
				xInput -= 1;
				if(!Input.check("Right")) running = true;
			} else {
				running = false;
			}
			if (Input.check("Right")) {
				xInput += 1;
				if(!Input.check("Left")) running = true;
			} else {
				running = false;
			}
			
			//DEBUG MOVEMENT
			if (Input.check(Key.W)) {
				yInput -= 1;
			}
			if (Input.check(Key.S)) {
				yInput += 1;
			}

			
			velocity.y = player_speed * yInput; //This isn't normally here
			velocity.x = player_speed * xInput;
		}
		
		override protected function land():void {
			if(!onGround) {
				calcFallDamage(velocity.y);
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
			
		}
		
		override protected function jump():void {
			if (onGround){
				velocity.y = -JUMP;
				onGround = false;
				jumpSound.play();
			}
		}
		
		//tentative idea: getHurt includes enemy-inflicted damage-
		//specific animations, takeDamage displays only the default,
		//i.e. red flash.
		private function getHurt(damage:int):void{
			if (damageTimer == 0) {
				takeDamage(10);
				injurySound.play();
				damageTimer = 60;
			}
			//TODO: animation
		}
		
		override protected function calcFallDamage(_v:int):void {
			var damageVelocity:int = 700;
			var totalDamage:int = 0;
			if (_v - damageVelocity > 0 ) {
				_v -= damageVelocity;
				while(_v > 0) {
					totalDamage += 5;
					_v -= 50;
				}
			}
			if (totalDamage != 0) getHurt(totalDamage);
			velocity.y = 0;
		}
		
		//INVENTORY
		public function getInventory():Inventory { return inventory; }

		//EXPERIENCE
		public function gainExperience(_exp:int):void {
			experience += _exp;
			w.hud.expText(_exp);
			checkForLevelUp();
		}
		
		private function checkForLevelUp():void {
			//checking logic goes here
			levelUp();
		}
		
		private function levelUp():void {
			level++;
			allocationPoints += 5;
			levelUpTime = true;
		}
		
		//Getter functions
		public function getPlayerExperience():int { return experience; }
		public function getLevel():int { return level; }
		public function getExperience():int { return experience; }
		public function isFacingLeft():Boolean { return facingLeft; }
		
	}
}