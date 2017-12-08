package com.isartdigital.platformer.game;
import com.isartdigital.platformer.game.sprites.mobiles.capacities.Shield;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyBomb;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyFire;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemySpeed;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyTurret;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootEnemy;
import com.isartdigital.platformer.game.sprites.stationaries.KillZone;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Collectable;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.game.StateGraphic;
import haxe.Json;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;

/**
 * ...
 * @author dachicourt jordan
 */
class LevelDesignManager{

	public static var totalCollectable:Int = 0;
	
	private static var limitsContainer: Container;
	private static var wallsContainer: Container;
	private static var platformsContainer: Container;
	private static var activeContainer: Container;
	private static var junkContainer: Container;
	
	public static var firstX:Float;
	public static var endX:Float;
	
	
	
	private static var focus:DisplayObject = new DisplayObject();
	
	public function new() 
	{
		
	}


	/**
	 * Charge dans la carte graphiques une partie des spritesheet
	 * 
	 ça marche pas :(  
	 */ 
	//static public function initGraphics() {
		//junkContainer = new Container();
		//var typeName:String;
		//for (lName in Reflect.fields(TypeName)) {
			//if (lName == "__name__") continue;
			//typeName = Reflect.field(TypeName, lName);
			//if ( typeName.indexOf(TypeName.ENEMY+"_") == 0 || typeName.indexOf(TypeName.COLLECTABLE) == 0 )
			//junkContainer.addChild(PoolManager.getFromPool(typeName) );
		//}
		//junkContainer.addChild(Shield.getInstance());
	//}
	//
	/**
	 * Initialise le level design en fonction du json passé en parametre
	 * @param	pLevel json contenant le level
	 */
	static public function init(pLevel:Json):Void {
	
		var lContainer:Container = GamePlane.getInstance();
		var lItem:LevelDesignItem = null;
		var lAsset:PoolObject = null;
		totalCollectable = 0;
		while (lContainer.children.length > 0) lContainer.removeChild(lContainer.getChildAt(0));
		
		limitsContainer = new Container();
		wallsContainer = new Container();
		platformsContainer = new Container();
		activeContainer = new Container();
		
		
			
		lContainer.addChild(limitsContainer);
		lContainer.addChild(wallsContainer);
		lContainer.addChild(platformsContainer);
		lContainer.addChild(activeContainer);	
		
		var object:Dynamic;
		for (lItemName in Reflect.fields (pLevel)) {
			
			
			
			if (lItemName == "levelSize") continue;
			lItem = Reflect.field(pLevel, lItemName);
			
			if (lItem.type == "Player"){
				lAsset = Player.getInstance();
				
				lAsset.x = lItem.x;
				lAsset.y = lItem.y;
				lAsset.rotation = lItem.rotation;
				lAsset.scale.x = lItem.scaleX;
				lAsset.scale.y = lItem.scaleY;
				lAsset.init();
				lAsset.start();
				activeContainer.addChild(lAsset);
			}
			else if (lItem.type == TypeName.COLLECTABLE || lItem.type == TypeName.DESTRUCTIBLE ||lItem.type.indexOf(TypeName.ENEMY) == 0||lItem.type== TypeName.CHECKPOINT){
				object = { onStage:lItem.onStage, x:lItem.x, y:lItem.y, type:lItem.type };
				if (lItem.type == TypeName.CHECKPOINT) object.active = false;
				if (lItem.type == TypeName.COLLECTABLE) totalCollectable++;
			
				SaveManager.status.set(lItemName, object);
			}
			if (lItem.type == TypeName.LIMIT_LEFT) firstX = lItem.x;
			if (lItem.type == TypeName.LIMIT_RIGHT) endX = lItem.x + lItem.width;
		}
		if (Browser.getLocalStorage().getItem(GameManager.selectedLevel + "maxscore")!=""+totalCollectable)
			Browser.getLocalStorage().setItem(GameManager.selectedLevel + "maxscore", ""+totalCollectable);
			
		//while (junkContainer.children.length > 0) junkContainer.removeChild(lContainer.getChildAt(0));
		SaveManager.saveMap(SaveManager.LAST);
		
	}
	
	/**
	 * Ajoute dans les container graphique les objet passé en parametre
	 * @param	pMap la map contenant les objet graphique
	 * 
	 */
	static public function toAdd (pMap:Map<String, LevelDesignItem>):Void {
		var lAsset:PoolObject,		
			lItem:LevelDesignItem;
		for (lKey in pMap.keys()) {
			
			lItem = pMap[lKey];
			
			if (lItem.type == "McFocus") continue;
			lAsset = PoolManager.getFromPool(lItem.type);
			lAsset.name = lKey;
			
			
			lAsset.x=lItem.x;
			lAsset.y = lItem.y;
			lAsset.rotation = lItem.rotation;
			lAsset.scale.x = lItem.scaleX;
			lAsset.scale.y = lItem.scaleY;
			lAsset.init();
			if (lItem.type != TypeName.CHECKPOINT) lAsset.start();
			if (lItem.type == TypeName.CHECKPOINT || lItem.type == TypeName.GROUND ||lItem.type.indexOf(TypeName.WALL) == 0 || lItem.type == TypeName.DESTRUCTIBLE)wallsContainer.addChild(lAsset);
			else if (lItem.type.indexOf(TypeName.PLATFORM) == 0 || lItem.type.indexOf(TypeName.BRIDGE) == 0) platformsContainer.addChild(lAsset);
			else if (lItem.type.indexOf(TypeName.COLLECTABLE) == 0|| lItem.type.indexOf(TypeName.KILLZONE) == 0 || lItem.type.indexOf(TypeName.ENEMY) == 0) activeContainer.addChild(lAsset);
			else if (lItem.type == TypeName.LIMIT_LEFT || lItem.type == TypeName.LIMIT_RIGHT) limitsContainer.addChild(lAsset);
			
			if (SaveManager.status.get(lKey)!=null){
				if (SaveManager.status.get(lKey).onStage) lAsset.dispose();
			}
			
		}
		
	}
	
	/**
	 * Retire des container graphique les objet passé en parametre
	 * @param	pMap la map contenant les objet graphique
	 * 
	 */
	static public function toRemove (pMap:Map<String, LevelDesignItem>):Void {		
		var lItem:LevelDesignItem;
		for (lKey in pMap.keys()) {
			var lObject:DisplayObject = null;
			lItem = pMap[lKey];	
			if (SaveManager.status.get(lKey) != null) {
				 if (SaveManager.status.get(lKey).type!= TypeName.CHECKPOINT && SaveManager.status.get(lKey).onStage) {
					 continue;
				 }
			}
			if (lItem.type == TypeName.CHECKPOINT || lItem.type == TypeName.GROUND || lItem.type.indexOf(TypeName.WALL) == 0 || lItem.type == TypeName.DESTRUCTIBLE)
				lObject = wallsContainer.getChildByName(lKey);
			else if (lItem.type.indexOf(TypeName.PLATFORM) == 0 || lItem.type.indexOf(TypeName.BRIDGE) == 0)
				lObject = platformsContainer.getChildByName(lKey);
			else if (lItem.type.indexOf(TypeName.COLLECTABLE) == 0 || lItem.type.indexOf(TypeName.KILLZONE) == 0 || lItem.type.indexOf(TypeName.ENEMY) == 0)
				lObject = activeContainer.getChildByName(lKey);
			else if (lItem.type == TypeName.LIMIT_LEFT || lItem.type == TypeName.LIMIT_RIGHT)
				lObject = limitsContainer.getChildByName(lKey);
			
			if(lObject != null)
				cast(lObject, PoolObject).dispose();
		}
		
	}
}