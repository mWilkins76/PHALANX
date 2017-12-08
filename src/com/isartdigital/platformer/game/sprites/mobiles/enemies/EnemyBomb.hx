package com.isartdigital.platformer.game.sprites.mobiles.enemies;
import com.isartdigital.platformer.controller.Controller;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.display.Container;


/**
 * 
 * @author dachicourt jordan
 */
class EnemyBomb extends EnemyMovable
{
	private var arrayCollision:Array<StateGraphic>;
	private var groundAcceleration(default, never):Float = 15;
	private var destructible:Wall;
	private var counter:Int;
	private var TIMETOEXPLODE:Int = 120;
	
	public function new() 
	{
		super(name);
	}
	
	/**
	 * Gere les action du de l'enemie bomb en mode normal
	 */
	override private function doActionNormal():Void 
	{
		super.doActionNormal();
		if (CollisionManager.hasCollision(hitDetection(), Player.getInstance().hitBox)) {
			setModeMovement();
		}	
	}
	
	/**
	 * Gere les actions de l'enemie en etat normal
	 */
	override public function init():Void 
	{
		super.init();
		maxHSpeed = 10;
		accelerationGround = groundAcceleration;
	}
	
	
	override public function setModeMovement():Void 
	{
		SoundManager.getSound("minotaure_detect").play();
		if (counter == null) counter = TIMETOEXPLODE;
		super.setModeMovement();
	}
	
	override function doActionMovement():Void 
	{
		counter--;
		testExplosion();
		scale.x = (Player.getInstance().x - x > 0?1: -1);
		walk();
		wall = testPoint(Wall.list, hitFront());
		if (wall != null || (testPoint(Platform.list, hitFloor()) == null && testPoint(Wall.list, hitFloor()) == null)){
			setModeWait();
		}
	}
	override public function setModeWait():Void 
	{
		setState(WAIT_STATE);
		doAction = doActionWait;
	}
	override function doActionWait():Void 
	{
		counter--;
		testExplosion();
		
	}
	
	override function setModeDie():Void 
	{
		SoundManager.getSound("minotaure_explode").play();
		collisionsDeath();
		super.setModeDie();
	}
	override function doActionDie():Void 
	{
		if(isAnimEnd){
			switchStatus();
			dispose();
		}
	}
	private function collisionsDeath():Void 
	{
		arrayCollision = hitTestMultiBox(Wall.list, getExplosion());
		for(collision in arrayCollision){
			destructible = cast(collision, Wall);
			if (destructible.assetName == TypeName.DESTRUCTIBLE) destructible.setModeExplosion();
		}
		if (!Player.getInstance().isGod && CollisionManager.hasCollision(Player.getInstance().hitBox, getExplosion())) Player.getInstance().setModeHurt();
	}
	private function testExplosion():Void{
		if (counter < 0) {
			setModeDie();
			return;
		}
	}
	private function getExplosion():Container{
		return cast(box.getChildByName("mcExplosion"), Container);
	}
}