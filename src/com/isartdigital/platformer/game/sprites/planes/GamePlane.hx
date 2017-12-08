package com.isartdigital.platformer.game.sprites.planes;

import com.isartdigital.utils.game.GameObject;

	
/**
 * ...
 * @author dachicourt jordan
 */
class GamePlane extends GameObject 
{
	
	/**
	 * instance unique de la classe GamePlane
	 */
	private static var instance: GamePlane;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GamePlane {
		if (instance == null) instance = new GamePlane();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		parent.removeChild(this);
		instance = null;	
		super.destroy();
		
	}

}