package ui {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkWindow;
	
	import ui.Button;
	
	public class StatsMenu extends Entity {
		
		private var panel:Entity;
		private var resumeButton:Button;
		private var quitButton:Button;
		
		private var w:GameWorld;
		private var p:SpacemanPlayer;
		
		private var playerStrength:Text;
		private var playerIntelligence:Text;
		private var playerDexterity:Text;
		private var playerAgility:Text;
		
		private var playerEXP:Text;
		private var playerLevel:Text;
		private var playerHealth:Text;
		private var playerHunger:Text;
		
		public function StatsMenu(_w:GameWorld) {
			super();
			
			w = _w;
			p = w.getPlayer();
			
			var bg:Graphic = Image.createRect(800, 400, 0x333333, 0.8);
			
			playerHealth = new Text("Health: " + p.getHealth() + "/"
				+ p.getMaxHealth(), 10, 10,
				{ size: 22, color: 0xffffff, align: "left" });
			
			playerHunger = new Text("Hunger: " + p.getHunger() + "/"
				+ p.getMaxHunger(), 250, 10,
				{ size: 22, color: 0xffffff, align: "left" });
			
			playerStrength = new Text("Strength: " + p.strength, 10, 40);
			playerIntelligence = new Text("Intelligence: " + p.intelligence, 10, 60);
			playerDexterity = new Text("Dexterity: " + p.dexterity, 10, 80);
			playerAgility = new Text("Agility: " + p.agility, 10, 100);
	
			
			playerLevel = new Text("Level: " + p.getLevel(), 800 - 120, 10,
			{ size: 26, color: 0xffffff, align: "right" });
			
			playerEXP = new Text("EXP: " + p.getExperience(), 800 - 120, 40,
			{ size: 20, color: 0xffffff, align: "right" });
			
			var graphicList:Graphiclist = new Graphiclist(bg, playerHealth, playerHunger,
				playerStrength, playerIntelligence, playerDexterity, playerAgility,
				playerLevel, playerEXP);
			
			panel = new Entity(0, 0, graphicList);
			panel.setHitboxTo(graphicList.children[0]);
			panel.layer = -550;

			//resumeButton = new Button(0, 0, "Resume", onResume);
			//resumeButton.layer = -555;
		}
		
		override public function update():void {	
			//resumeButton.update();
		}
		
		public function show():void {
			p = w.getPlayer();
			
			panel.x = FP.camera.x + (FP.screen.width /2) - (panel.width / 2);
			panel.y = FP.camera.y + 10 + (FP.screen.height / 2) - (panel.height / 2);
			
			playerHealth.text = "Health: " + p.getHealth() + "/" + p.getMaxHealth();
			playerHunger.text = "Hunger: " + p.getHunger() + "/" + p.getMaxHunger();
			
			playerStrength.text = "Strength: " + p.strength;
			playerIntelligence.text = "Intelligence: " + p.intelligence;
			playerDexterity.text = "Dexterity: " + p.dexterity;
			playerAgility.text = "Agility: " + p.agility;
			
			playerEXP.text = "EXP: " + p.getExperience();
			playerLevel.text = "Level: " + p.getLevel();
			//resumeButton.x = panel.x + 30;
			//resumeButton.y = panel.y + 30;
			
			FP.world.add(panel); 
			//FP.world.add(resumeButton);
		}
		
		public function onResume():void {
			//Todo: fix
			w.onStats();
		}
		
		public function remove():void {
			FP.world.remove(panel); 
			//FP.world.remove(resumeButton)
		}
		
		public function destroy():void {
			FP.world.removeAll();
		}
	}
}