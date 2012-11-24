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
		private var subStrength:Button;
		private var addStrength:Button;
		
		//local variables
		private var intelligence:int;
		private var dexterity:int;
		private var agility:int;
		private var strength:int;
		
		private var statsList:Object;

		//player variables
		private var playerIntelligence:Text;
		private var playerDexterity:Text;
		private var playerAgility:Text;
		
		private var playerEXP:Text;
		private var playerLevel:Text;
		private var playerHealth:Text;
		private var playerHunger:Text;
		
		private var levelUpButton:Button;
		
		private var allocationPoints:int;
		private var points:Text;
		
		private var leftArrow:Class;
		private var rightArrow:Class;
		
		private var graphicList:Graphiclist;
		private var list:Object;
		private var levelUpTime:Boolean;
		
		private var titleText:Text;
		
		public function StatsMenu(_w:GameWorld) {
			super();
			
			w = _w;
			p = w.getPlayer();
			
			titleText = new Text("Stats", 10, 10, {size: 30});
			
			strength = p.strength;
			agility = p.agility;
			intelligence = p.intelligence;
			dexterity = p.dexterity;
			
			statsList = {"strength": strength, "agility": agility,
				"intelligence": intelligence, "dexterity": dexterity};
			
			leftArrow = Assets.ARROW_LEFT;
			rightArrow = Assets.ARROW_RIGHT;
			
			var bg:Graphic = Image.createRect(800, 400, 0x333333, 0.8);
			
			playerHealth = new Text("Health: " + p.getHealth() + "/"
				+ p.getMaxHealth(), 250, 40,
				{ size: 22, color: 0xffffff, align: "left" });
			
			playerHunger = new Text("Hunger: " + p.getHunger() + "/"
				+ p.getMaxHunger(), 250, 10,
				{ size: 22, color: 0xffffff, align: "left" });
			
			//playerIntelligence = new Text("Intelligence: " + p.intelligence, 10, 60);
			//playerDexterity = new Text("Dexterity: " + p.dexterity, 10, 80);
			//playerAgility = new Text("Agility: " + p.agility, 10, 100);
			
			points = new Text(allocationPoints + " allocation points.", 10, 360);
			points.size = 26;
			points.color = 0xffffff;
			
			levelUpButton = new Button(0, 0, "Confirm Points", onConfirm);
			
			playerLevel = new Text("Level: " + p.getLevel(), 800 - 120, 10,
			{ size: 26, color: 0xffffff, align: "right" });
			
			playerEXP = new Text("EXP: " + p.getExperience(), 800 - 120, 40,
			{ size: 20, color: 0xffffff, align: "right" });
			
			graphicList = new Graphiclist(bg, titleText, playerHealth, playerHunger,
				playerLevel, playerEXP, points);
			layer = -1110;
			
			panel = new Entity(0, 0, graphicList);
			panel.setHitboxTo(graphicList.children[0]);
			panel.layer = -1100;

			allocationPoints = p.allocationPoints;
		}
				
		public function show():void {
			p = w.getPlayer();
			
			strength = p.strength;
			agility = p.agility;
			intelligence = p.intelligence;
			dexterity = p.dexterity;
			
			allocationPoints = p.allocationPoints;
			
			panel.x = FP.camera.x + (FP.screen.width /2) - (panel.width / 2);
			panel.y = FP.camera.y + 10 + (FP.screen.height / 2) - (panel.height / 2);
			
			statsList = {"strength": strength, "agility": agility,
				"intelligence": intelligence, "dexterity": dexterity};
			
			list = createStatsUI();
			
			levelUpButton.x = panel.x + 330;
			levelUpButton.y = panel.y + 140;
			levelUpButton.layer = -1110;
			
			if (p.levelUpTime) levelUpButton.visible = true;
			else levelUpButton.visible = false;
			updateText();
			
			FP.world.add(levelUpButton);
			FP.world.add(panel); 
			
		}
		
		override public function update():void {
			levelUpTime = p.levelUpTime;
			renderLevelUp(levelUpTime);
			
			for (var attr:String in list){
				list[attr]["sub"].update();
				list[attr]["add"].update();
				
				list[attr]["sub"].visible = levelUpTime;
				list[attr]["add"].visible = levelUpTime;
			}
			levelUpButton.update();
		}

		private function createStatsUI():Object {
			var i:int = 1;
			var list:Object = {};
			for (var attribute:String in statsList) {
				//attribute == the key
				//statsList[attribute] == value	
				var row:Object = {};
				row["sub"] = new Button(panel.x + 10 , panel.y + 40 + (i * 20), "",
					alterPoints, {"attr": attribute, "i": -1},
					{"normal": leftArrow, "hover": leftArrow, "down": leftArrow})
					
				row["text"] = new Text(attribute + ": ", 25, 35 + i * 20);
				
				row["attribute"] = new Text(statsList[attribute], 135, 35 + i * 20);
				
				row["add"] = new Button(panel.x + 160, panel.y + 40 + (i * 20), "",
					alterPoints, {"attr": attribute, "i": 1},
					{"normal": rightArrow, "hover": rightArrow, "down": rightArrow});

				row["sub"].layer = row["add"].layer = -1110;
			
				i++;
				
				FP.world.add(row["sub"]);
				graphicList.add(row["text"]);
				graphicList.add(row["attribute"]);
				FP.world.add(row["add"]);
				
				row["sub"].visible = levelUpTime;
				row["add"].visible = levelUpTime;
				
				list[attribute] = row;
			}
			return list;
		}
		
		private function alterPoints(params:Object):void{
			if(allocationPoints > 0) {
				statsList[params["attr"]] += params["i"];
				allocationPoints -= params["i"];
				//trace(statsList[params["attr"]] + ": " + params["i"]);
			}
			updateText();
		}
		
		private function updateText():void {
			playerHealth.text = "Health: " + p.getHealth() + "/" + p.getMaxHealth();
			playerHunger.text = "Hunger: " + p.getHunger() + "/" + p.getMaxHunger();
			
			for (var attr:String in statsList){
				list[attr]["attribute"].text = statsList[attr];
			}

			playerEXP.text = "EXP: " + p.getExperience();
			playerLevel.text = "Level: " + p.getLevel();
			
			points.text = allocationPoints + " allocation points";
		}
		
		public function onConfirm():void {
			if(allocationPoints == 0) {
				p.strength = statsList["strength"];
				p.agility = statsList["agility"];
				p.intelligence = statsList["intelligence"];
				p.dexterity = statsList["dexterity"];
			for (var attr:String in statsList){
				p.statsList[attr] = statsList[attr];
			}	
				p.allocationPoints = 0;
				p.levelUpTime = false;
			}
		}
		
		public function onResume():void {
			//Todo: fix
			w.onStats();
		}
		
		public function renderLevelUp(render:Boolean):void {

			levelUpButton.visible = render;
		}
		
		public function remove():void {
			FP.world.remove(levelUpButton);
			FP.world.remove(panel); 
			for (var attr:String in list){
				FP.world.remove(list[attr]["sub"]);
				list[attr]["attribute"].text = "";
				FP.world.remove(list[attr]["add"]);
			}
		}
		
		public function destroy():void {
			FP.world.removeAll();
		}
	}
}