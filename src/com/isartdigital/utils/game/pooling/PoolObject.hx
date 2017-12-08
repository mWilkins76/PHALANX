package com.isartdigital.utils.game.pooling;
import com.isartdigital.platformer.game.sprites.mobiles.Player;

/**
 * ...
 * @author dachicourt jordan
 */
class PoolObject extends StateGraphic
{

	public function new(pAsset:String) 
	{
		super();
		assetName = pAsset;
		
	}
	
	public function init():Void { }
	
	/**
	 * Gere l'enlevement graphique et d'ecoute, l'arret, de l'objet de pooling
	 */
	public function dispose():Void {
		removeAllListeners();
		setModeVoid();
		parent.removeChild(this);
	}
	
	override public function destroy():Void 
	{
		if (this!=Player.getInstance()) dispose();
		super.destroy();
		
	}
	
}