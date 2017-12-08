package com.isartdigital.platformer.game.sprites.mobiles.enemies;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author Eimin
 */
class EnemyMovable extends Enemy
{
	private var accelerationGround:Float = 0;
	private var frictionGround (default, never):Float = 0.75;

	private var wall:StateGraphic;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
		
	}
	
	private function walk():Void{
		acceleration.x =  scale.x*accelerationGround;
		collisions();
		move();
	}
	
	public function setModeMovement():Void{
		setState(WALK_STATE, true);
		friction.set(frictionGround, 0);
		doAction = doActionMovement;
	}
	
	private function doActionMovement():Void { }
	
	public function setModeWait():Void{
		setState(WAIT_STATE);
		if(wall!=null){
			if (scale.x > 0 ) x = wall.x-hitBox.width / 2;
			else if (scale.x < 0) x = wall.x + wall.hitBox.width+hitBox.width / 2;
		}
		scale.x *= -1;
		doAction = doActionWait;
	}
	
	private function doActionWait():Void {
		collisions();
		if (isAnimEnd) {
			
			setModeMovement();
		}
	}
	
	/**
	 * Donne la box de detection de l'ennemi speed
	 * @return mcDetection boxe de detection de l'ennemi speed
	 */
	private function hitDetection():Container{
		return cast(box.getChildByName("mcDetection"), Container);
	}
	
	override private function get_hitBox():Container 
	{
		return cast(box.getChildByName("mcGlobalBox"), Container);
	}
	
	/**
	 * Donne la boxe de detection pour tirer du Turret
	 * @return mcTriggerFire boxe de detection du Turret
	 */
	private function hitFront():Point{
		return box.toGlobal(box.getChildByName("mcFront").position);
	}
	
	private function hitFloor():Point{
		return box.toGlobal(box.getChildByName("mcCanWalk").position);
	
	}
}