package com.isartdigital.utils.game.clipping;

/**
 * ...
 * @author dachicourt jordan
 */
class Cell
{

	
	public var content:Array<String>;
	
	public function new() 
	{
		content = new Array<String>();
	}
	
	public function add(pInstance:String) {
		content.push(pInstance);
	}
}