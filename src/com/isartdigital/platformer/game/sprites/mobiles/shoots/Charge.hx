package com.isartdigital.platformer.game.sprites.mobiles.shoots;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;

	
/**
 * ...
 * @author Michael Wilkins
 */
class Charge extends StateGraphic
{
	
	/**
	 * instance unique de la classe Charge
	 */
	private static var instance: Charge;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Charge {
		if (instance == null) instance = new Charge();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	
	override function setModeNormal():Void 
	{
		super.setModeNormal();
		setState(DEFAULT_STATE, true);
		if(anim.currentFrame==0) SoundManager.getSound("charge").play();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		x = GamePlane.getInstance().toLocal(Player.getInstance().weaponOrigin()).x;
		y = GamePlane.getInstance().toLocal(Player.getInstance().weaponOrigin()).y;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		if(parent!=null)parent.removeChild(this);
		instance = null;
		
		
	}

}