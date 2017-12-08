package com.isartdigital.platformer.game.sprites;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Classe gerant le comportement de tout les objets level
 * @author Michael Wilkins
 */
class LevelObject extends PoolObject
{

	private var object:Dynamic;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
	}
	
	/**
	 * Execute les doAction d'une list
	 * @param	pArray
	 */
	public static function executeAction(pArray:Array<Dynamic>) {
		var length:Int = pArray.length;
		for (i in 1...length + 1) {
			pArray[length - i].doAction();	
		}
	}
	
	/**
	 * Destroy les object d'une list
	 * @param	pArray
	 */
	public static function destroyObjects(pArray:Array<Dynamic>) {
		var length:Int = pArray.length;
		for (i in 1...length + 1) {
			pArray[length - i].destroy();	
		}
	}
	
	/**
	 * Gere l'etat des objet dans la sauvegarde
	 */
	public function switchStatus():Void
	{
		object = SaveManager.status.get(name);
		object.onStage = true;
		SaveManager.status.set(name, object);
	}
	/**
	 * Test la collision entre un point et une liste d'objet passer en parametre
	 * @param	pList : tableau d'objet à tester
	 * @param	pGlobalPoint : point à tester
	 * @return l'objet collision si collision, sinon null
	 */
	public function testPoint(pList:Array<Dynamic>, pGlobalPoint:Point):StateGraphic {
			for (lObject in pList) {
				if (CollisionManager.hitTestPoint(cast(lObject, StateGraphic).hitBox, pGlobalPoint)) return cast(lObject, StateGraphic);
			}
			return null;
	}
	
	/**
	 * Des les box d'une liste contre la box d'un objet
	 * @param	pList
	 * @param	box
	 * @return l'objet de la liste qui collisione, ou null
	 */
	public function hitTestBox (pList:Array<Dynamic>, box:Container):StateGraphic {
		for (lObject in pList) {
			if (CollisionManager.hasCollision(cast(lObject, StateGraphic).hitBox, box)){
				return cast(lObject, StateGraphic);
			}
		}
		return null;
	}
	
	/**
	 * Des les points d'une liste d'objet contre la box d'un objet
	 * @param	pList
	 * @param	box
	 * @return
	 */
	public function hitTestPointToBox (pList:Array<Dynamic>, box:Container):StateGraphic {
		for (lObject in pList) {
			if (CollisionManager.hasCollision(cast(lObject, StateGraphic).hitBox, box, lObject.hitPoints)) return cast(lObject, StateGraphic);
		}
		return null;
	}
	
	
	public function hitTestMultiBox(pList:Array<Dynamic>,box:Container):Array<StateGraphic>{
		var array:Array<StateGraphic> = new Array<StateGraphic>();
		for(lObject in pList){
			if (CollisionManager.hasCollision(cast(lObject, StateGraphic).hitBox, box)) array.push(cast(lObject, StateGraphic));
		}
		if (array.length == null) return null;
		return array;
	}
}