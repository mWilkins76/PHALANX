package com.isartdigital.utils.game;
import haxe.Json;
import js.Browser;

/**
 * ...
 * @author Eimin
 */
class SaveManager
{
	public static inline var LAST:String = "LastStatus";
	private static var restoredOject:Dynamic;
	private static var STATUS_SUFFIXE:String = "Status";
	public static var levelStatus:Map<String,Dynamic> = new Map<String,Dynamic>();
	public static  var status:Map<String,Dynamic> = new Map<String,Dynamic>();
	public function new() 
	{
		
	}
	/**
	 * Function permettant de restorer une map venant du local Storage
	 * @param	pString representant le nom du stockage dans le storage local 
	 */
	public static function restoreStatus(pString:String):Void{
		if (Browser.getLocalStorage().getItem(pString) == null) return ;
		restoredOject = Json.parse(Browser.getLocalStorage().getItem(pString)).h;
		for (InstanceName in Reflect.fields (restoredOject)){
			status.set(InstanceName, Reflect.field(restoredOject, InstanceName));
		}
		
	}
	/**
	 * Function permettant de sauvegarder une map dans le local storage
	 * @param	pString representant le nom du stockage dans le storage local 
	 */
	public static function saveMap(pString:String):Void{
		Browser.getLocalStorage().setItem(pString, Json.stringify(status));
	}
	/**
	 * Function permettant de restorer la map du level
	 * @param	pLevel representant le nom du level a restorer
	 */
	public static function restoreLevel(pLevel:String):Void{
		if (Browser.getLocalStorage().getItem(pLevel + STATUS_SUFFIXE) == null) return;
		restoredOject = Json.parse(Browser.getLocalStorage().getItem(pLevel+STATUS_SUFFIXE)).h;
		for (InstanceName in Reflect.fields (restoredOject)){
			levelStatus.set(InstanceName,Reflect.field(restoredOject,InstanceName));
		}
	}
	/**
	 * Function permettant de la map du level
	 * @param	pLevel representant le nom du level a sauvegarder dans le local storage
	 */
	public static function saveLevel(pLevel:String):Void{
		saveMap(pLevel + STATUS_SUFFIXE);
	}
	public static function finalClear():Void{
		clearMap(status);
		clearMap(levelStatus);
	}
	private static function clearMap(pMap:Map<Dynamic,Dynamic>){
		for (key in pMap.keys()){
			pMap.remove(key);
		}
	}
	
	

	
}