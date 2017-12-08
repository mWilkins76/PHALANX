package com.isartdigital.utils.game.pooling;

import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootEnemy;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootPlayer;
import com.isartdigital.platformer.game.sprites.stationaries.Checkpoint;
import com.isartdigital.platformer.game.sprites.stationaries.CollectableWin;
import com.isartdigital.platformer.game.TypeName;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyBomb;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyFire;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemySpeed;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.EnemyTurret;
import com.isartdigital.platformer.game.sprites.stationaries.KillZone;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Collectable;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import haxe.Json;



/**
 * Gere le pooling, l'ajout et la sortie du pool et son initialisation
 * @author dachicourt jordan
 */
class PoolManager
{
	
	
	

	public static var pool: Map<String, Array<PoolObject>> = new Map<String, Array<PoolObject>>();

	private function new() 
	{
		
	}
	
	/**
	 * Initialise le pooling en fonction du fichier json en parametre
	 * @param	pPool json contenant les pool de depart
	 */
	static public function init(pPool:Json) {
		
		for (lClassName in Reflect.fields(pPool)) {
			pool.set(lClassName, new Array<PoolObject>());
			
			var numberOfInstance:Int = Reflect.field(pPool, lClassName);
			
			for (i in 0 ... numberOfInstance) {
				addToPool(lClassName, getInstance(lClassName));
			}
		}
	}
	
	/**
	 * Ajoute une instance dansle pool
	 * @param	pType asset du l'objet
	 * @param	pInstance instance de l'objet
	 */
	public static function addToPool(pType:String, pInstance:PoolObject):Void {
		if (pType == null || pInstance == null)
			return null;
		
		if (!pool.exists(pType))
			pool.set(pType,  new Array<PoolObject>());	
		
		pool.get(pType).push(pInstance);	
	}
	
	/**
	 * Prend une instance dans la piscine
	 * @param	pType asset voulu
	 * @return instance correspondant à l'asset
	 */
	public static function getFromPool(pType:String):PoolObject {
		if (pType == null) return null;
		
		if (!pool.exists(pType) ||  pool.get(pType).length == 0)
			addToPool(pType, getInstance(pType));
			
		return pool.get(pType).pop();
	}
	
	/**
	 * Retourne l'instance correspondant au type
	 * @param	pType asset voulu
	 * @return l'instance voulu
	 */
	private static function getInstance(pType:String):PoolObject{
			if (pType == TypeName.GROUND || pType == TypeName.LIMIT_LEFT || pType == TypeName.LIMIT_RIGHT)return new Wall(pType);
			else if (pType.indexOf(TypeName.WALL) == 0 || pType==TypeName.DESTRUCTIBLE) return new Wall(pType);
			else if (pType.indexOf(TypeName.PLATFORM) == 0 || pType.indexOf(TypeName.BRIDGE) == 0) return new Platform(pType);
			else if (pType == TypeName.ENEMY_BOMB) return new EnemyBomb();
			else if (pType == TypeName.ENEMY_SPEED) return new EnemySpeed();
			else if (pType == TypeName.ENEMY_FIRE) return new EnemyFire();
			else if (pType == TypeName.ENEMY_TURRET) return new EnemyTurret();
			else if (pType.indexOf(TypeName.KILLZONE) == 0) return new KillZone(pType);
			else if (pType == TypeName.COLLECTABLE ) return new Collectable(pType);
			else if (pType== TypeName.COLLECTABLE_WIN ) return new CollectableWin(pType);
			else if (pType == TypeName.CHECKPOINT) return new Checkpoint(pType);
			else if (pType.indexOf(TypeName.SHOOT_ENEMY) == 0) return new ShootEnemy(pType);
			else if (pType == TypeName.SHOOT_PLAYER) return new ShootPlayer(pType);
			else if (pType == TypeName.SUPER) return new ShootPlayer(pType);
			else return null;
	}
	
	/**
	 * efface ce qu'il y a dans le tableau de pool, si un type est passé en parametre il efface seulement les instance correspondante.
	 * @param	pType
	 */
	public static function clear(?pType:String = null):Void {
		
		/*si le type est defini on ne supprime qu'un type du pool*/
		if (pType != null){
			pool.remove(pType);
			return;
		}
		
		/*supression du tableau de tout le tableau de pool*/
		var it : Iterator<String> = pool.keys();
		while (it.hasNext()) pool.remove(it.next());
	}
	
}