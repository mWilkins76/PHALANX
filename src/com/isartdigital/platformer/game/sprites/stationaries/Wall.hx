package com.isartdigital.platformer.game.sprites.stationaries;
import com.isartdigital.platformer.game.sprites.Stationary;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;


/**
 * ...
 * @author dachicourt jordan
 */
class Wall extends Stationary
{

	public static var list : Array<Wall> = new Array<Wall>();
	
	private var EXPLODING_STATE(default, never):String = "explode";
	
	public function new(pAsset:String) 
	{
		super(pAsset);	
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		//testCollision();
		
		
	}
	
	
	
	public function setModeExplosion():Void {
		
		SoundManager.getSound("destructible_collapse").play();
	
		setState(EXPLODING_STATE);
		doAction = doActionExplosion;
	}
	

	
	private function doActionExplosion():Void {
	
		if (isAnimEnd) {
			switchStatus();
			dispose();
		}
	}
	
	override public function init():Void 
	{
		super.init();
		list.push(this);
	}
	
	override public function dispose():Void 
	{
		list.remove(this);
		super.dispose();	
	}
	
	
	
}