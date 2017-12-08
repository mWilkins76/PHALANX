package com.isartdigital.utils.game.clipping;
import com.isartdigital.platformer.game.LevelDesignItem;
import com.isartdigital.platformer.game.LevelDesignManager;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import haxe.Json;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author dachicourt jordan
 */
class ClippingManager
{

	static var level:Array<Array<Cell>>;
	
	static inline var GRID_UNIT:Int = 280;
	static inline var LEVEL_META:String = "levelSize";
	
	public static var currentDisplay:Map<String,LevelDesignItem>;
	static var datas:Json;
	static var gridWidth:Int;
	static var gridHeight:Int;
	
	private function new() 
	{
		
	}
	
	/**
	 * Initialise la grille complete du niveau et stock les reference d'objet dedans en fonction du JSON
	 * @param	pJson
	 */
	static public function init(pJson : Json) {
		
		currentDisplay = new Map<String,LevelDesignItem>();

		datas = pJson;
		
		var lItem:LevelDesignItem,
			levelDatas  = Reflect.field(datas, LEVEL_META);

		gridWidth = Math.ceil(levelDatas.width / GRID_UNIT)+1;
		gridHeight = Math.ceil(levelDatas.height / GRID_UNIT)+1;
		level = new Array<Array<Cell>>();
		/*creation de la grille selon la taille du level*/
		for (y in 0 ...gridHeight) {
			level[y] = new Array<Cell>();
			for (x in 0 ... gridWidth) 
				level[y][x] = new Cell();
			
		}	
	
		/*on met les item dans la grille*/
		for (lInstanceName in Reflect.fields(pJson)) {
			if (lInstanceName == LEVEL_META) continue;
			lItem = Reflect.field(pJson, lInstanceName);
			
			
			/*on calcule à quelle cell l'objet commence et à quel cell il fini */
			var cellX = Math.floor(lItem.x / GRID_UNIT),
				cellY = Math.floor(lItem.y / GRID_UNIT),
				endCellX = Math.floor((lItem.x + lItem.width) / GRID_UNIT)+1,
				endCellY = Math.floor((lItem.y + lItem.height) / GRID_UNIT)+1;
				
			
			
			/*dans le cas ou l'element n'est que dans une cell*/
				/* On parcour de sa cell de depart à sa cell de fin */
			for (y in cellY ... endCellY)
				for (x in cellX ... endCellX) {
					if (lItem.type != "Player"&& lItem.type!="McFocus")
						level[y][x].add(lInstanceName);
				}
					
		}
		
	}
	
	/**
	 * Defini la portions de la grille utilisé pour le clipping et la stoque dans une map, elle passe cette map à la fonction clip qui s'occupe du clipping
	 * @param	pZone rectangle du clipping
	 */
	static public function update(pZone:Rectangle):Void {
		/*coo de depart et de fin en terme de cellule de grille*/
		var beginX:Int = Std.int(pZone.x / GRID_UNIT),
		beginY:Int =   Std.int(pZone.y / GRID_UNIT),
		endX:Int =  Std.int((pZone.x + pZone.width) / GRID_UNIT),
		endY:Int =  Std.int((pZone.y + pZone.height) / GRID_UNIT);
		
		/*clamp*/
		if (beginX < 0) beginX = 0;
		if (beginY < 0) beginY = 0;
		if (endX > gridWidth) endX = gridWidth;
		if (endY > gridHeight) endY = gridHeight;

		//va contenir tout les instance dans les cell entre begin et end
		var lMap:Map<String, LevelDesignItem> = new Map<String, LevelDesignItem>();
			
		for (y in beginY ... endY){
			for (x in beginX ... endX) {
				var lLength:Int = level[y][x].content.length;
				for (i in 0 ... lLength) {
					//si l'instance n'est pas deja stocké
					
					if (!lMap.exists(level[y][x].content[i]))
						lMap.set(level[y][x].content[i], Reflect.field(datas, level[y][x].content[i]));
				}
			}
		}
		
		clip(lMap);
	}
	
	/**
	 * Gere le clipping, il ajoute ce qui n'etait pas à l'ecran avant, et retire ce qui etait à l'ecran avant et ne l'est plus maintenant
	 * @param	pCurrentMap la map actuel contenant le futur affichage
	 */
	static public function clip(pCurrentMap:Map<String, LevelDesignItem>) {
		
		var toClip:Map<String,LevelDesignItem> = new Map<String,LevelDesignItem>();
		var toUnClip:Map<String,LevelDesignItem> = new Map<String,LevelDesignItem>();
		
		/*supression de ce qui n'est plus dans le futur affichage*/
		//pour toute les instance dans l'affichage en memoire
		for (lKey in currentDisplay.keys()) {
			//si elle n'est pas dans l'affichage qui arrive
			if (!pCurrentMap.exists(lKey)) {
				toUnClip.set(lKey, currentDisplay[lKey]);
				currentDisplay.remove(lKey);
			}
		}
		
		/*on ajoute ce qui n'etait pas dans le tableau de clip*/
		//pour toute les instance dans l'affichage qui arrive
		for (lKey in pCurrentMap.keys()) {
			//si elle n'est pas dans l'affichage actuel
			if (!currentDisplay.exists(lKey)) {	
				currentDisplay.set(lKey, pCurrentMap[lKey]);
				toClip.set(lKey, pCurrentMap[lKey]);
			}
		}

		LevelDesignManager.toAdd(toClip);
		LevelDesignManager.toRemove(toUnClip);	
	}
	

	
	/**
	 * Efface le contenue de la map passé en parametre
	 * @param	pMap
	 * 
	 */
	static public function clearMap(pMap:Map<String, LevelDesignItem>) {
		var it : Iterator<String> = pMap.keys();
		while (it.hasNext()) pMap.remove(it.next());
	}
}