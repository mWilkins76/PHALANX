package com.isartdigital.platformer.game.sprites.stationaries;
import com.isartdigital.platformer.game.sprites.Stationary;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import pixi.core.math.Point;

/**
 * ...
 * @author dachicourt jordan
 */
class KillZone extends Stationary
{

	public static var list : Array<KillZone> = new Array<KillZone>();
	private static inline var DISTANCE_MAX : Float = 280;
	private static inline var WAIT_FRAMES : Float = 30;
	private var waitCount:Float = 0;
	private var speed:Int = 0;
	private var angle:Float = 0;
	private var initialPos:Point;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
	}
	override public function init():Void 
	{
		super.init();
		list.push(this);
		speed = 0;
		angle = 0;
		waitCount = 0;
		if (assetName == "KillZoneDynamic") {
			speed = 20;
			angle = rotation*Math.PI/180;
			initialPos = new Point(position.x,  position.y);
		}
	}
	override function setModeNormal():Void 
	{
		state = "*";
		setState(DEFAULT_STATE, true);
		super.setModeNormal();
	}
	override function doActionNormal():Void 
	{
		
		
		x += Math.cos(angle) * speed;
		y += Math.sin(angle) * speed;
		
		if (isBeyondDistance(initialPos, position)) {
			speed = -speed;
			setModeWait();
		}
	}
	
	public function setModeWait():Void{
		doAction = doActionWait;
		waitCount = 0;
	}
	
	function doActionWait():Void {
		if (waitCount++ > WAIT_FRAMES) setModeNormal();
	}
	
	private function isBeyondDistance(pointA: Point, pointB: Point):Bool {
		if (pointA == null || pointB == null) return false;
		var x:Float = (pointB.x - pointA.x);
		var y:Float = (pointB.y - pointA.y);
		return Math.sqrt( Math.abs(x * x - y * y)) >= DISTANCE_MAX;
	}
	override public function dispose():Void 
	{
		list.remove(this);
		super.dispose();	
	}
}
