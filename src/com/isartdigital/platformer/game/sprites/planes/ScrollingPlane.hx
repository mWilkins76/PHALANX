package com.isartdigital.platformer.game.sprites.planes;

import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.planes.PlanePart;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Lib;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author Eimin
 */
class ScrollingPlane extends GameObject
{
	private var parts:Array<PlanePart> = new Array<PlanePart>();
	public static var lScreen:Rectangle;
	private static inline var theoWidth:Int = 1220;
	private var partName:String = "_part";
	private var coefReducX:Float;
	private var coefReducY:Float;
	public function new(pString:String,pNumPart:Int,pCoefX:Float,pCoefY:Float) 
	{
		super();
		coefReducX = pCoefX;
		coefReducY = pCoefY;
		var part:PlanePart;
		lScreen = DeviceCapabilities.getScreenRect(this);
		for (i in 1...pNumPart + 1) {
			
			part = new PlanePart(pString + partName+i);
			part.x = lScreen.x + (i - 1) * theoWidth - theoWidth;
			part.y = lScreen.y - 100;
			part.start();
			addChild(part);
			parts.push(part);
		}
		
	}	
	override public function doActionNormal():Void 
	{
		super.doActionNormal();
		var length = parts.length;
		var part:PlanePart;
		lScreen = DeviceCapabilities.getScreenRect(this);
		
		for(i in 0...length ){
			part = parts[i];
			part.velocity.x = Camera.getInstance().velocity.x * coefReducX;
			part.velocity.y = -Camera.getInstance().velocity.y* coefReducY;
			part.move();
		}
		if (parts[0].x + theoWidth < lScreen.x) {
			parts[0].x += 3 * (theoWidth-4);
			parts.push(parts.shift());
		}
		if (parts[2].x > lScreen.width-175) {  
			parts[2].x -= 3 * (theoWidth-4) ;
			parts.unshift(parts.pop());	
		}
	}
	override public function destroy():Void 
	{
		for(part in parts){
			part.destroy();
			parts.remove(part);
		}
		PlaneManager.destroy(this);
		parent.removeChild(this);
		super.destroy();
	}
	
	
}