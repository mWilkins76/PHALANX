package com.isartdigital.platformer.game.sprites.stationaries;

import com.isartdigital.platformer.game.sprites.Stationary;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.sounds.SoundManager;
import js.Browser;

/**
 * ...
 * @author Eimin
 */
class Checkpoint extends Stationary
{
	public static var list:Array<Checkpoint> = new Array<Checkpoint>();
	public static var activeList:Array<Checkpoint> = new Array<Checkpoint>();
	
	private var  APPEAR_STATE(default, never):String =  'appear';
	private var  CHECKED_STATE(default, never):String = 'checked';
	
	
	public function new(pAsset:String) 
	{
		super(pAsset);
	}
	override public function init():Void 
	{
		super.init();
		if(SaveManager.status.get(name)!=null){
			if(SaveManager.status.get(name).active){
				setState(CHECKED_STATE);
			}
		}
		doAction = doActionVoid;
		list.push(this);
		
	}
	
	
	override function setModeNormal():Void 
	{
		setState(APPEAR_STATE);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		if (isAnimEnd) setState(CHECKED_STATE);
		
	}
	
	public function saveLocation():Void {
		if (!SaveManager.status.get(name).active) {
			start();
			object = SaveManager.status.get(name);
			object.active = true;
			SaveManager.status.set(name, object);
			Browser.getLocalStorage().setItem("saveX", "" + x);
			Browser.getLocalStorage().setItem("saveY", "" + y);
			SaveManager.saveMap(SaveManager.LAST);
			SoundManager.getSound("checkpoint").play();
		}	
		
			
	
	}
	override public function dispose():Void 
	{
		if (list.indexOf(this) != null) list.remove(this);
		else activeList.remove(this);
		super.dispose();	
	}
}
	
	
	
