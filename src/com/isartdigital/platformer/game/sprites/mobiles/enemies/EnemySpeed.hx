package com.isartdigital.platformer.game.sprites.mobiles.enemies;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author dachicourt jordan
 */
class EnemySpeed extends EnemyMovable
{

	
	private var groundAcceleration(default, never):Float = 15;
	private var COUNT_TURN(default, never):Float = 30;
	
	
	
	public function new() 
	{
		super(name);
		
	}
	override public function init():Void 
	{
		super.init();
		maxHSpeed = 20;
		accelerationGround = groundAcceleration;
	}
	override public function setModeNormal():Void {
		setState(WAIT_STATE, true);
		super.setModeNormal();
		
	}
	override public function setModeMovement():Void 
	{	
		SoundManager.getSound("satyre_laugh").play();
		super.setModeMovement();
		anim.animationSpeed = 100;
	}
	override private function doActionNormal():Void {
		super.doActionNormal();
		if (CollisionManager.hasCollision(hitDetection(), Player.getInstance().hitBox)) {
			setModeMovement();
		}
	}
	override public function setModeWait():Void 
	{
		super.setModeWait();
		anim.animationSpeed = 1;
	}
	override private function doActionMovement():Void {
		
		if (anim.currentFrame==7) SoundManager.getSound("satyre_footsteps1").play();
		if (anim.currentFrame==25) SoundManager.getSound("satyre_footsteps2").play();
		
    	walk();
		wall = testPoint(Wall.list, hitFront());
		if (wall != null || (testPoint(Platform.list, hitFloor()) == null && testPoint(Wall.list, hitFloor()) == null)){
			setModeWait();
		}
		
	}
	override private function doActionWait():Void 
	{
		super.doActionWait();
		
	}
	
	override function setModeDie():Void 
	{
		SoundManager.getSound("satyre_die").play();
		super.setModeDie();
	}
}
