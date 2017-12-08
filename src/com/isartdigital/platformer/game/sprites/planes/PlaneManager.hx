package com.isartdigital.platformer.game.sprites.planes;

import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;

/**
 * ...
 * @author Eimin
 */
class PlaneManager
{
	
	private static inline var BACKGROUND_BACK:String = "Background_back";
	private static inline var BACKGROUND_MIDDLE:String = "Background_middle";
	private static inline var BACKGROUND_FRONT:String = "Background_front";
	
	public static var list:Array<ScrollingPlane> = new Array<ScrollingPlane>();
	private static var lPlane:ScrollingPlane;
	private static var numPart:Int = 3;
	private static var container:Container = GameStage.getInstance().getGameContainer();
	private static var numPlane:Int = 3;
	
	public function new() 
	{
		
	}
	
	public static function init():Void{
		for(i in 0...numPlane){
			switch i{
				case 0:
					lPlane = new ScrollingPlane(BACKGROUND_BACK, numPart, 0.15,0.00001);
				case 1:
					lPlane = new ScrollingPlane(BACKGROUND_MIDDLE, numPart, 0.35,0.00005);
				case 2:
					lPlane = new ScrollingPlane(BACKGROUND_FRONT, numPart, 0.55,0.001);
			}
			lPlane.start();
			list.push(lPlane);
			container.addChild(lPlane);
		}
	}
	public static function destroy(lPlane:ScrollingPlane):Void{
		list.remove(lPlane);
	}
	
}