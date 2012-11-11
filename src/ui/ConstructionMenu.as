package ui {
	import Inventory.InventoryItem;
	
	import data.InventoryItems;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class ConstructionMenu extends Entity {
		private var panel:Entity;
		private var p:SpacemanPlayer;
		private var w:GameWorld;
		private var availableItems:Array;
		private var constructButton:Button;
		public var boxes:Array;
		private var itemList:Array;
		public var captionText:Text;
		private var display:Graphiclist;
		
		public function ConstructionMenu(_w:GameWorld, _p:SpacemanPlayer, _position:Point = null) {
			if (!_position) _position = new Point(0, 0);
			super();
			w = _w;
			p = _p;
			
			panel = new Entity(0, 0, Image.createRect(700, 400, 0x333333, 0.8));
			panel.setHitboxTo(panel.graphic);
			panel.layer = -550;
			
			availableItems = [];
			boxes = [];
			itemList = GameWorld.inventoryItems.list;
			
			constructButton = new Button(panel.x + 100,
				panel.y + Image(panel.graphic).height, "Construct", onConstruct);
			constructButton.layer = -560;
			
			captionText = new Text("Caption", panel.x + 5, panel.y + 100);
			display = new Graphiclist(captionText);
			graphic = display;
			setHitboxTo(display);
			layer = -560;
		}
		
		override public function update():void {
			for each (var item:InventoryItem in availableItems) {
				item.update();
			}
			
			for (var i:int = 0; i < boxes.length; i ++){ 
				boxes[i].update();
			}
			
			constructButton.update();
		}
		
		public function onConstruct():void {
			for (var i:int = 0; i < boxes.length; i ++) {
				if (boxes[i].isSelected()) {
					var value:Number = Math.floor(availableItems[i].scrapValue * p.constructionRate);
					if (p.scraps >= value) {
						var item:InventoryItem = GameWorld.inventoryItems.copyItem(availableItems[i]);
						p.getInventory().addItemToInventory(item);
						p.scraps -= value;
						w.hud.update();
						captionText.text = availableItems[i].label + " constructed";
					} else {
						captionText.text = "Not enough scraps";
					}
				}
			}
		}
		
		public function displayPrice():void {
			for (var i:int = 0; i < boxes.length; i ++) {
				if (boxes[i].isSelected()) {
					captionText.text = availableItems[i].label + ": "
						+ Math.floor(availableItems[i].scrapValue * p.constructionRate) + " scraps";	
				}
			}
		}
		
		public function show():void {
			panel.x = FP.camera.x + (FP.screen.width /2) - (panel.width / 2);
			panel.y = FP.camera.y + 10 + (FP.screen.height / 2) - (panel.height / 2);
			constructButton.x = panel.x + 100;
			constructButton.y = panel.y + 300;
			captionText.x = panel.x + 5;
			captionText.y = panel.y + 100;
			captionText.text = "";
			FP.world.add(panel);
			FP.world.add(constructButton);
			FP.world.add(this);

			//draw Boxes
			for (var i:int = 0; i < itemList.length; i++){
				var box:ConstructionBox = new ConstructionBox(new Point(5 + panel.x + (i * 55),
					panel.y + 5), w);
				box.layer = -550;
				boxes.push(box);
				FP.world.add(box);
			}
			//draw Items

			for (i = 0; i < itemList.length; i++){
				var e:InventoryItem = GameWorld.inventoryItems.copyItem(itemList[i]);
				e.x = panel.x + 5 + (i * 55);// + (Image(e.graphic).width / 2);
				e.y = panel.y + 5;// + (Image(e.graphic).height / 2);
				e.layer = -560;
				availableItems.push(e);
				FP.world.add(e);
			}
		}
		
		public function remove():void {
			FP.world.remove(panel);
			FP.world.remove(constructButton);
			
			for (var i:int = 0; i < availableItems.length; i++) {
				FP.world.remove(availableItems[i]);
			}
			
			for each (var box:ConstructionBox in boxes) {
				FP.world.remove(box);
			}
			
			FP.world.remove(this);
		}
	}
}