package com.isartdigital.platformer.game.sprites;

import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Classe gerant les objets mobile
 * @author dachicourt jordan, wilkins michael, falla marc olivier
 */
class Mobile extends LevelObject
{

	/**
	 * Les etats graphiques
	 */
	private var  WAIT_STATE(default, never):String = 'wait';
    private var  WALK_STATE(default, never):String = 'walk';
	private var HURT_STATE(default, never):String = 'hurt';
	private var DEAD_STATE(default, never):String = 'hurt';
	private var  WAITSHOOT_STATE(default, never):String = 'waitShoot';
    private var  WALKSHOOT_STATE(default, never):String = 'walkShoot';
	
	/**
	 * Les propriétés physiques
	 */
	private var velocity:Point = new Point(0, 0);
	private var acceleration:Point = new Point(0, 0);
	private var friction:Point = new Point(0, 0);
	private var maxHSpeed:Float = 0;
	
	
	private var life:Int=1;
	private var shoot:Shoot;
	
	public function new(pAsset:String) 
	{
		super(pAsset);
		boxType = BoxType.SIMPLE;
		
	}
	
	override public function start():Void 
	{
		super.start();
		anim.animationSpeed = 0.5;
	}
	override private function setModeNormal():Void {
		
		setState(WAIT_STATE,true);
		super.setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		collisions();
	}
	private function setModeFire(pState:String):Void
	{
		if (pState == WAIT_STATE) setState(WAITSHOOT_STATE);
		else if (pState == WALK_STATE) setState(WALKSHOOT_STATE);
	}
	
	
   
    private function doActionWalk():Void
    {
		collisions();
    }
	
	
	private function setModeHurt():Void{
		if (life > 0) {
			setState(HURT_STATE);
			doAction = doActionHurt;
		}
		else setModeDie();
		
		
	}
	private function doActionHurt():Void {
		collisions();
		
		if (isAnimEnd) setModeNormal();
	}
	
	private function setModeDie():Void {
		setState(DEAD_STATE);
		doAction = doActionDie;
		
	}
	
	private function doActionDie():Void {
		
		if (isAnimEnd) {
			switchStatus();
			dispose();
		}
		
	}
	
	private function move ():Void {
		velocity.x += acceleration.x;
		velocity.x *= friction.x;
		velocity.y += acceleration.y;
		velocity.y *= friction.y;
		
		velocity.x = (velocity.x < 0 ? -1 : 1) * Math.min(Math.abs(velocity.x), maxHSpeed);
		
		x += velocity.x;
		y += velocity.y;
		
		acceleration.set(0, 0);
	}
	private function flipLeft():Void {
		if (scale.x == 1) {
			scale.x = -1;
			flip();
		}
	}
	/**
	 * Inversion du mobile, si dirigé vers la gauche, vers la droite
	 */
	private function flipRight():Void {
		if (scale.x == -1) {
			scale.x = 1;
			flip();
		}
	}
	public function getVelocity():Point{
		return velocity;
	}
	private function flip():Void { }
	
	private function collisions():Void { }

	public function weaponOrigin():Point{
		return box.toGlobal(box.getChildByName("mcWeapon").position);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	

}