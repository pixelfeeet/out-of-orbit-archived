package {
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity {

		//ESSENTIALS
		private var health:int;
		private var maxHealth:int;
		private var minHealth:int;
		
		private var hunger:int;
		private var maxHunger:int;
		private var minHunger:int;
		
		public var velocity:Point;
		
		public function Player() {}
		
		private function takeDamage(damage:int):void{
			changeHealth(-damage);
			//Damage animation logic goes here
		}
		
		private function increaseHunger(addedHunger:int):void{
			changeHunger(-addedHunger);
			//hunger animation goes here.
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
		public function changeHealth(newHealth:int):void {
			if(newHealth > 0) {
				if (health < maxHealth && health + newHealth <= maxHealth) health += newHealth;
				else health = maxHealth;
			} else {
				if (health > minHealth && health + newHealth > minHealth) health += newHealth;
				else health = minHealth;
			}
		}
		
		public function changeHunger(newHunger:int):void {
			if (newHunger > 0) {
				if (hunger < maxHunger && hunger + newHunger <= maxHunger) hunger += newHunger;
				else hunger = maxHunger;
			} else {
				if (hunger > minHunger && hunger + newHunger > minHunger) hunger += newHunger;
				else hunger = minHunger;
			}
		}
	}
}