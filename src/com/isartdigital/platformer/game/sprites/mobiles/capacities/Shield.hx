package com.isartdigital.platformer.game.sprites.mobiles.capacities;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.filters.color.ColorMatrixFilter;

	
/**
 * ...
 * @author Michael Wilkins
 */
class Shield extends StateGraphic 
{
	
	/**
	 * instance unique de la classe Shield
	 */
	private static var instance: Shield;
	
	/**
	 * Les constantes d'etats graphiques
	 */
	private var  APPEAR_STATE(default, never):String = 'appear';
    private var  IDLE_STATE(default, never):String = 'idle';
	private var  EXPLODE_STATE(default, never):String = 'explode';
	
	
	private var godFilter:ColorMatrixFilter = new ColorMatrixFilter();
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Shield {
		if (instance == null) instance = new Shield();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		//SoundManager.getSound("shield_appear").play();
		super();
		godFilter.toBGR(false);
		start();
		GamePlane.getInstance().addChild(this);
		setState(APPEAR_STATE);
		
	}
	
	/**
	 * Applique un filtre pour differencier l'etat god
	 */
	private function applyGodFilter():Void {
		anim.filters = [godFilter];
	}
	
	/**
	 * Actions effectué en etat normal
	 */
	override function doActionNormal():Void 
	{
		
		if(Player.getInstance().isGod) applyGodFilter();
		
		super.doActionNormal();
		x = Player.getInstance().x;
		y = Player.getInstance().y;
		if (isAnimEnd) setState(IDLE_STATE, true);
	}
	
	/**
	 * Met l'etat graphique explode et place l'action sur doActionExplode
	 */
	public function setModeExplode():Void {
		
		SoundManager.getSound("shield_crack").play();
	
		setState(EXPLODE_STATE);
		doAction = doActionExplode;
	}
	
	/**
	 * Actions effectué en etat explode
	 */
	private function doActionExplode():Void {
		
	
		if (isAnimEnd) {
			if (Player.getInstance().isGod) Player.getInstance().beGod();
			anim.filters = null;
			destroy();
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		if(parent!=null)parent.removeChild(this);
		instance = null;
		
	}

}