package com.isartdigital.platformer.game.sprites.planes;

import com.isartdigital.utils.game.StateGraphic;
import js.Lib;
import pixi.core.math.Point;

/**
 * ...
 * @author Eimin
 */
class PlanePart extends StateGraphic
{
	public var velocity:Point = new Point(0, 0);
	public function new(pAsset:String) 
	{
		super();
		assetName = pAsset;
		setState(DEFAULT_STATE);
	}
	
	public function move ():Void {
		x += velocity.x;
		y += velocity.y;
	}
	override public function destroy():Void 
	{
		if(parent!=null)parent.removeChild(this);
		super.destroy();
	}
}