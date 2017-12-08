package com.isartdigital.platformer.game.sprites.mobiles.enemies;

import com.isartdigital.platformer.game.sprites.Mobile;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.game.StateGraphic;

/**
 * 
 * @author dachicourt jordan
 */
class Enemy extends Mobile
{
	
	public static var list : Array<Enemy> = new Array<Enemy>();
	
	
	private var fireCounter:Int = 0;
	private var FIRE_RATE:Int;
	
	
	
	public function new(pAsset:String) 
	{
		super(pAsset);	
		
	}
	
	/**
	 * Initialisation de l'objet
	 */
	override public function init():Void 
	{
		super.init();
		list.push (this);
	}
	
	/**
	 * Gere les actions de l'enemie en etat normal
	 */
	override function doActionNormal():Void 
	{
		scale.x = (Player.getInstance().x - x > 0?1: -1);
		super.doActionNormal();	
	}
	
	/**
	 * Gere l'enlevement graphique et d'ecoute, l'arret, de l'objet de pooling
	 */
	override public function dispose():Void 
	{
		super.dispose();
		list.remove(this);
	}
		
}