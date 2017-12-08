package com.isartdigital.platformer.game.sprites.stationaries;
import com.isartdigital.platformer.game.sprites.Stationary;

/**
 * ...
 * @author dachicourt jordan
 */
class Platform extends Stationary
{
	public static var list : Array<Platform> = new Array<Platform>();
	
	public function new(pAsset:String) 
	{
		super(pAsset);	
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