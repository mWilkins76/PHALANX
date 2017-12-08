package com.isartdigital.platformer.game.sprites.stationaries;

import com.isartdigital.platformer.game.sprites.Stationary;

/**
 * ...
 * @author Michael Wilkins
 */
class CollectableWin extends Stationary
{
	public static var list:Array<CollectableWin>=new Array<CollectableWin>();
	public function new(pAsset:String) 
	{
		super(pAsset);
		
	}
	override public function init():Void 
	{
		super.init();
		list.push(this);
	}
	override public function start():Void 
	{
		super.start();
	
	}
	override public function dispose():Void 
	{
		list.remove(this);
		super.dispose();
	}
	
	
}