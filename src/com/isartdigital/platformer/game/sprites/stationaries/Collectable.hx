package com.isartdigital.platformer.game.sprites.stationaries;
import com.isartdigital.utils.game.SaveManager;
import haxe.Json;
import js.Browser;

/**
 * ...
 * @author dachicourt jordan
 */
class Collectable extends Stationary
{

	
	public static var list : Array<Collectable> = new Array<Collectable>();
	//public static var status:Array<String> = new Array<String>();

	
	
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
		if (SaveManager.levelStatus.get(name)!=null){
			alpha = SaveManager.levelStatus.get(name).onStage?0.5:1;  
		}
			//
		super.start();
	}
	override public function dispose():Void 
	{
		list.remove(this);
		super.dispose();
	}
	
}