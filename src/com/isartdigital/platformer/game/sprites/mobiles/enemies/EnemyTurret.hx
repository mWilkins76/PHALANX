package com.isartdigital.platformer.game.sprites.mobiles.enemies;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootEnemy;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author dachicourt jordan
 */
class EnemyTurret extends Enemy
{
	private var shootNumber:Int;
	private var MAX_SHOOT(default, never):Int = 3;
	private var WAIT_RATE(default, never):Int = 90;
	
	public function new() 
	{
		super(Type.getClassName(Type.getClass(this)).split(".").pop());
		FIRE_RATE = 20;
		
	}
	
	override public function init():Void 
	{
		super.init();
		life = 3;
	}
	
	override private function setModeNormal():Void {
		fireCounter = 0;
		super.setModeNormal();
	}
	
	override private function doActionNormal():Void 
	{
		super.doActionNormal();
		if (CollisionManager.hasCollision(hitTriggerFire(), Player.getInstance().hitBox)) {
			setModeShoot();
		}
	}
	
	private function setModeShoot():Void {
		
		SoundManager.getSound("snake_detect").play();
		
		setState(WAITSHOOT_STATE, true);
		shootNumber = MAX_SHOOT;
		doAction = doActionShoot;
	}
	
	private function doActionShoot():Void {
		fireCounter++;
		if (fireCounter > WAIT_RATE) shootNumber = 4;
		if (fireCounter > FIRE_RATE && shootNumber > 1) {
			shootNumber--;
			createShoot();
		}
		if (!CollisionManager.hasCollision(hitTriggerFire(), Player.getInstance().hitBox)) {
			setModeNormal();
		}
		collisions();
		
	}
	private function createShoot():Void {
		
		SoundManager.getSound("snake_shoot").play();
		
		shoot = cast(PoolManager.getFromPool(Shoot.ENEMYTURRET),Shoot);
		shoot.init();
		shoot.position = parent.toLocal(weaponOrigin());
		shoot.setAngle(Math.atan2(( Player.getInstance().position.y - shoot.position.y), (Player.getInstance().position.x - shoot.position.x)));
		shoot.start();
		parent.addChild(shoot);
		fireCounter = 0;
	
	}
	
	/**
	 * Donne la boxe de detection pour tirer du Turret
	 * @return mcTriggerFire boxe de detection du Turret
	 */
	private function hitTriggerFire():Container{
		return cast(box.getChildByName("mcTriggerFire"), Container);
	}
	
	
	override function get_hitBox():Container 
	{
		return cast(box.getChildByName("mcGlobalBox"), Container);
	}
	
}