package com.isartdigital.platformer.game.sprites;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;

/**
 * 
 * @author dachicourt jordan
 */
class Stationary extends LevelObject
{

	public function new(pAsset:String) 
	{
		super(pAsset);
		boxType = BoxType.SIMPLE;
		setState(DEFAULT_STATE);
		
	}
}